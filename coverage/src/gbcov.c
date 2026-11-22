/* gbcov: a minimal, instruction-accurate Game Boy core for COVERAGE runs of the Pocket Camera ROM.
 * No rendering. Models: SM83 CPU, interrupts, timers, LCD timing (LY/STAT/VBlank/LYC), joypad, serial (+ simple printer),
 * OAM DMA, MBC with the Pocket Camera mapper (ROM bank, RAM banks 0-15, camera registers at bank 0x10, synthetic sensor).
 * Records: opcode/operand fetches per ROM byte, ROM data reads per ROM byte (+ first reader PC), bank-select writes (writer PC, bank).
 * Build: gcc -O2 -shared -fPIC -o gbcov.so gbcov.c
 */
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define ROMSZ (1<<20)
static uint8_t rom[ROMSZ]; static int rom_loaded=0;
/* ---- coverage (global, not part of snapshots) ---- */
static uint8_t cov_exec[ROMSZ];      /* 1 = opcode byte executed, 2 = operand byte fetched (opcode wins) */
static uint8_t cov_dread[ROMSZ];     /* 1 = read as data */
static uint32_t cov_reader[ROMSZ];   /* first reader/fetcher: (bank<<16)|pc, +1 flag 0x80000000 if valid */
static uint8_t cov_ram[0x10000];     /* executed addresses in RAM (8000-FFFF) */
static uint8_t org_exec[ROMSZ], org_dread[ROMSZ], org_ram[0x10000]; static int organic=1; static uint8_t known[ROMSZ]; static int known_loaded=0, wild=0;   /* coverage reached with no state pokes in the lineage */
static int32_t last_rd=-1, a_src=-1;
static uint16_t cov_mode[ROMSZ]; static uint32_t cov_site[ROMSZ], cov_site2[ROMSZ]; static uint32_t cur_site=0, cur_site2=0; static int site_bank=-1; static uint16_t site_sp=0xFFFF;   /* site_sp: SP at the bank switch; a read with a higher SP comes after the switching routine returned (stale site, not recorded; 2026-11-02) */
#define CMPSZ 8192
static uint32_t cmp_key[CMPSZ], cmp_pc[CMPSZ], cmp_ep[CMPSZ]; static uint32_t cmp_epoch=1, cmp_n=0;
static uint32_t cur_fetch_pc_bank_fwd;
static uint64_t cnt_exec=0, cnt_dread=0, cnt_ram=0;
#define BSZ 65536
static uint32_t bsel_key[4][BSZ]; static uint32_t bsel_cnt[4][BSZ];  /* key = (writer bank<<24)|(writer pc<<8)|new bank ; open addressing; table 0 = all, table 1 = organic only */
static uint32_t bsel_n[4]={0,0,0,0};
static void bsel_add1(int t,uint32_t key,uint32_t add){ uint32_t h=(key*2654435761u)>>16; for(int i=0;i<BSZ;i++){ uint32_t j=(h+i)&(BSZ-1); if(bsel_cnt[t][j]==0){bsel_key[t][j]=key;bsel_cnt[t][j]=add;bsel_n[t]++;return;} if(bsel_key[t][j]==key){bsel_cnt[t][j]+=add;return;} } }
int organic_get(void);
static void site_push(void); static void site_pop(void);
static uint8_t rd(uint16_t a);
static uint8_t rom_at_bank(uint16_t pc,uint8_t bank);
static void bsel_add(uint32_t key,uint8_t oldbank,uint16_t sp){
  bsel_add1(0,key,1); if(organic_get()) bsel_add1(1,key,1);
  uint8_t nb=key&0xFF; int level=0; cur_site=0; cur_site2=0; site_bank=nb&0x3F; site_sp=sp;
  for(int k=0;k<6&&level<2;k++){ uint16_t a=sp+2*k; uint16_t w=rd(a)|(rd(a+1)<<8);
    if(w<3||w>=0x8000) continue; uint8_t opc=rom_at_bank(w-3,oldbank);
    if(opc==0xCD||opc==0xC4||opc==0xCC||opc==0xD4||opc==0xDC){ uint32_t cb=(w-3<0x4000)?0:(oldbank&0x3F);
      if(level==0) cur_site=0x80000000u|(cb<<16)|(w-3); else cur_site2=0x80000000u|(cb<<16)|(w-3);
      uint32_t k2=((uint32_t)level<<30)|(cb<<24)|((uint32_t)(w-3)<<8)|nb; bsel_add1(2,k2,1); if(organic_get()) bsel_add1(3,k2,1); level++; } }
}


static void cmp_log(int32_t src, uint8_t val, uint8_t kind, uint32_t pcb){
  if(src<0 || cmp_n>CMPSZ/2) return;
  uint32_t key=((uint32_t)src<<16)|((uint32_t)val<<8)|kind; uint32_t h=(key*2654435761u)>>19;
  for(int i=0;i<CMPSZ;i++){ uint32_t j=(h+i)&(CMPSZ-1);
    if(cmp_ep[j]!=cmp_epoch){ cmp_ep[j]=cmp_epoch; cmp_key[j]=key; cmp_pc[j]=pcb; cmp_n++; return; }
    if(cmp_key[j]==key) return; }
}
static uint32_t rd_ep[0x2080]; static uint8_t rd_val[0x2080];
static void rd_log(int32_t addr,uint8_t v){ int idx=addr<0xE000?addr-0xC000:0x2000+(addr-0xFF80); if(idx<0||idx>=0x2080) return; rd_ep[idx]=cmp_epoch; rd_val[idx]=v; }
/* ---- state (snapshotted) ---- */
typedef struct {
  uint8_t a,f,b,c,d,e,h,l; uint16_t sp,pc; uint8_t ime, ei_delay, halted, stopped;
  uint64_t cycles;
  uint8_t vram[0x2000], wram[0x2000], oam[0xA0], hram[0x80], io[0x80], ie;
  uint8_t sram[0x20000]; uint8_t cam[0x80];
  uint8_t rombank, rambank, ramen;
  uint16_t div; int32_t tima_acc;
  int32_t line_cycle; uint8_t ly; uint8_t stat_line; uint8_t lcd_on;
  int32_t serial_cd; uint8_t serial_rx;
  int32_t cam_cd;
  uint8_t keys; uint8_t p1sel; uint8_t last_p1lines;
  uint32_t frame; uint32_t rng;
  /* printer */
  uint8_t pr_state; uint16_t pr_len; uint16_t pr_cnt; uint8_t pr_cmd; uint8_t pr_status; uint8_t pr_busy; uint16_t pr_sum;
  uint8_t pr_rx_next; uint8_t pr_attached; uint32_t pr_bytes;
  uint8_t pr_unproc, pr_printing;      /* real-trace model (gb_printer_model(1)) */
  uint16_t pr_n[16];                   /* packets answered so far, per command (counted from gb_attach_printer) */
} GB;
static GB g;
static uint32_t cur_fetch_pc_bank;

size_t gb_state_size(void){ return sizeof(GB); }
void gb_save(uint8_t*buf){ memcpy(buf,&g,sizeof(GB)); }
void gb_load(const uint8_t*buf){ memcpy(&g,buf,sizeof(GB)); a_src=-1; last_rd=-1; wild=0; }

int gb_load_rom(const char*path){ FILE*f=fopen(path,"rb"); if(!f)return -1; size_t n=fread(rom,1,ROMSZ,f); fclose(f); rom_loaded=1; return (int)n; }

static uint8_t rom_at_bank(uint16_t pc,uint8_t bank){ return pc<0x4000?rom[pc]:rom[((uint32_t)(bank&0x3F)<<14)|(pc-0x4000)]; }
static inline uint32_t romoff(uint16_t addr){ if(addr<0x4000) return addr; return ((uint32_t)(g.rombank&0x3F)<<14)|(addr-0x4000); }
static inline int cur_bank(uint16_t pc){ return pc<0x4000?0:(g.rombank&0x3F); }

static uint8_t joyp(void){
  uint8_t sel=g.p1sel&0x30, lines=0x0F;
  if(!(sel&0x10)) lines &= ~(g.keys&0x0F);
  if(!(sel&0x20)) lines &= ~((g.keys>>4)&0x0F);
  return 0xC0|sel|lines;
}
static uint8_t cur_lines(void){ return joyp()&0x0F; }

static uint8_t stat_mode(void){ if(!g.lcd_on) return 0; if(g.ly>=144) return 1; if(g.line_cycle<80) return 2; if(g.line_cycle<252) return 3; return 0; }

static uint8_t rd(uint16_t a);
static void req(int bit){ g.io[0x0F] |= (1<<bit); }

/* ---- printer (very small model of the Game Boy Printer) ---- */
/* status injection (README 16.16): the reply of the nth packet of a command (01 INIT, 02 PRINT, 04 DATA, 0F INQUIRY) is replaced by a chosen status byte, count packets in a row;
   plog = every reply given (command, status). Not part of the snapshot: call gb_printer_inject_clear() at the start of a run. */
static uint8_t inj_cmd[16], inj_st[16]; static uint16_t inj_nth[16], inj_cnt[16]; static int inj_n;
static uint8_t plog_cmd[8192], plog_rx[8192]; static int plog_n;
static int pr_real;   /* gb_printer_model(1): replies copied from the real printer traces (as tools/jp/bgb_printer.py): INIT 00, first DATA 00, later DATA 08, PRINT 08, INQUIRY 06 x18, 04 x2, then 00 */
static uint8_t printer_xfer(uint8_t tx){
  uint8_t rx=0x00;
  switch(g.pr_state){
    case 0: if(tx==0x88){g.pr_state=1;} break;
    case 1: if(tx==0x33){g.pr_state=2;} else g.pr_state=(tx==0x88)?1:0; break;
    case 2: g.pr_cmd=tx; g.pr_state=3; g.pr_sum=tx; break;
    case 3: g.pr_state=4; g.pr_sum+=tx; break;               /* compression */
    case 4: g.pr_len=tx; g.pr_state=5; g.pr_sum+=tx; break;
    case 5: g.pr_len|=(uint16_t)tx<<8; g.pr_sum+=tx; g.pr_cnt=0; g.pr_state=g.pr_len?6:7; break;
    case 6: g.pr_sum+=tx; if(++g.pr_cnt>=g.pr_len) g.pr_state=7; break;
    case 7: g.pr_state=8; break;                               /* checksum lo */
    case 8: g.pr_state=9; rx=0x00; break;                      /* checksum hi */
    case 9: rx=0x81; g.pr_state=10; break;                     /* device id */
    case 10: {                                                  /* status */
      if(pr_real){
        if(g.pr_cmd==0x01){ g.pr_status=0x00; g.pr_busy=0; g.pr_printing=0; g.pr_unproc=0; }
        else if(g.pr_cmd==0x04){ g.pr_status=g.pr_unproc?0x08:0x00; g.pr_unproc=1; }
        else if(g.pr_cmd==0x02){ g.pr_status=0x08; g.pr_printing=1; g.pr_busy=20; }
        else if(g.pr_cmd==0x0F){
          if(g.pr_printing){ if(g.pr_busy>2){ g.pr_status=0x06; g.pr_busy--; } else if(g.pr_busy>0){ g.pr_status=0x04; g.pr_busy--; } else { g.pr_status=0x00; g.pr_printing=0; g.pr_unproc=0; } }
          else { g.pr_status=0x00; g.pr_unproc=0; } }
      }
      else if(g.pr_cmd==0x01){ g.pr_status=0x00; g.pr_busy=0; }
      else if(g.pr_cmd==0x04){ g.pr_status=0x08; }
      else if(g.pr_cmd==0x02){ g.pr_status=0x06; g.pr_busy=6; }
      else if(g.pr_cmd==0x0F){ if(g.pr_busy){ g.pr_busy--; g.pr_status=g.pr_busy>2?0x06:(g.pr_busy?0x04:0x00);} }
      rx=g.pr_status; g.pr_state=0;
      { uint16_t n=++g.pr_n[g.pr_cmd&15]; for(int i=0;i<inj_n;i++) if(inj_cmd[i]==g.pr_cmd && n>=inj_nth[i] && n<(uint32_t)inj_nth[i]+inj_cnt[i]) rx=inj_st[i];
        if(plog_n<8192){ plog_cmd[plog_n]=g.pr_cmd; plog_rx[plog_n]=rx; plog_n++; } }
      break; }
  }
  g.pr_bytes++;
  return rx;
}

/* ---- camera: the realistic sensor (opt-in, gb_cam_model(1); 2026-11-22, owner: "do a realistic sensor faker") ----
   One capture = the M64282FP and the MAC-GBD as this repository knows them (docs §18, §19; sensor/README.md), with the light response
   of the M64283FP datasheet (Japanese original, 特性曲線 / 感度特性, clamp off, 25 C, infrared-cut filter, Vdd 5 V, Vref 1.5 V, gain 04h =
   20 dB): the markers of its graph read from the PDF's vectors (sensor/m64283fp_sensitivity_curve.csv), "a sensor with a very similar
   light behaviour" (owner); the arrays below are generated from that file (tools/sensor_curve_extract.py). Per pixel (x, y) of the scene (illuminance at the sensor face, lux):
     s   = curve(L, t) / 10 (input-referred: the curve is at 20 dB) + kd t                      light signal + dark current, volts
     q   = s, or s + a k (enhancement) / a k (extraction, E3), k = 2s - (W + E) (H), 2s - (N + S) (V), 4s - (N + S + E + W) (2-D)
                                                                                                  (the M64282FP datasheet, §11.6, a = E ratio)
     V   = Vref + O + G q - 0.028 - G w (- 0.25 G when Z = 00) + noise, clipped to 0-4 V        sensor output, volts (G linear gain)
     2 bits: 3 if V < thr(t0), 2 if V < thr(t1), 1 if V < thr(t2), else 0, thr(b) = 3.0 V x b / 255, cell 4 (y & 3) + (x & 3) of $A006
   t = C x 16 / 1,048,576 s. Fitted on camera 1 (I, docs §19): w, the dark level below Vref per unit of gain (9.3 mV positive, 12 + 4a mV
   H / V edge, 15 + 4a mV 2-D), the -28 mV and kd = 0.011 V/s fit its boot and factory offset searches (sensor/sar_check_real.txt); the
   threshold scale (the prototype's "$55 = 1 V", docs §19.6), the comparator polarity (MAME, dither-pattern-gen) and the Z = 00 shift
   (without the zero-point clamp the dark output falls more than the 1 V the gain probe tests at G = 0 on every real camera, docs §18.4)
   are I. Frame lines 0-119 go to SRAM $A000-$AEFF (the 8 lines above the photo
   hold the 12 test pixels the ROM reads at $A002 / $A082, docs §19.3). Off (default): the old synthetic picture, unchanged. */
static int cam_model;
static float cam_scene[128 * 128], cam_volts[128 * 128];
static float cam_w_scale = 1.0f, cam_kd = 0.011f, cam_noise = 0.002f;
static const float CV_T[5] = {16e-6f, 128e-6f, 1e-3f, 10e-3f, 100e-3f};
static const float CV_SAT[5] = {2200.0f, 2200.0f, 2273.0f, 2096.0f, 2119.0f};          /* mV: the plateaus; 16 / 128 us: not reached in the graph, 2200 (I) */
static const int CV_N[5] = {5, 9, 7, 6, 3};
static const float CV_L[5][9] = {{150.1f, 301.9f, 745.4f, 4313.0f, 5465.0f}, {36.39f, 77.63f, 143.6f, 296.4f, 738.0f, 1437.0f, 2919.0f, 4303.0f, 5518.0f}, {8.303f, 16.54f, 36.19f, 77.19f, 142.9f, 294.8f, 740.2f}, {1.368f, 2.454f, 4.423f, 8.373f, 16.5f, 36.54f}, {1.371f, 2.433f, 4.365f}};
static const float CV_V[5][9] = {{1.887f, 4.014f, 11.23f, 81.72f, 122.6f}, {4.486f, 11.63f, 20.94f, 46.41f, 130.2f, 264.8f, 708.5f, 1254.0f, 1664.0f}, {2.806f, 5.359f, 15.86f, 51.12f, 135.8f, 412.7f, 1707.0f}, {7.546f, 15.14f, 32.44f, 81.53f, 209.4f, 617.3f}, {138.1f, 324.4f, 774.9f}};
static float cv_series(int j, float L){                /* mV at 20 dB, series j at L lux: log-log between markers, slope 1 below, last slope above */
  const float *X = CV_L[j], *Y = CV_V[j]; int n = CV_N[j]; float v;
  if(L <= X[0]) v = Y[0] * (L / X[0]);
  else { int i = 0; while(i < n - 2 && L > X[i + 1]) i++;
    float a = logf(Y[i + 1] / Y[i]) / logf(X[i + 1] / X[i]); v = Y[i] * powf(L / X[i], a); }
  return v > CV_SAT[j] ? CV_SAT[j] : v;
}
static float cv_signal(float L, float t){             /* mV at 20 dB: the two series around t, each at the same L t (reciprocity), log-mixed */
  if(L <= 0 || t <= 0) return 0;
  float E = L * t; int j = 0;
  if(t <= CV_T[0]) return cv_series(0, E / CV_T[0]);
  if(t >= CV_T[4]) return cv_series(4, E / CV_T[4]);
  while(j < 3 && t > CV_T[j + 1]) j++;
  float f = logf(t / CV_T[j]) / logf(CV_T[j + 1] / CV_T[j]);
  float a = cv_series(j, E / CV_T[j]), b = cv_series(j + 1, E / CV_T[j + 1]);
  if(a <= 0 || b <= 0) return (1 - f) * a + f * b;
  return expf((1 - f) * logf(a) + f * logf(b));
}
static float cam_gauss(void){ float s = 0; for(int k = 0; k < 4; k++){ g.rng ^= g.rng << 13; g.rng ^= g.rng >> 17; g.rng ^= g.rng << 5; s += (g.rng & 0xFFFF) / 65536.0f; } return (s - 2.0f) * 1.7320508f; }
static void cam_capture_model(void){
  static const float GDB[16] = {14.0f, 15.5f, 17.0f, 18.5f, 20.0f, 21.5f, 23.0f, 24.5f, 26.0f, 29.0f, 32.0f, 35.0f, 38.0f, 41.0f, 45.5f, 51.5f};
  static const float ALPHA[8] = {0.5f, 0.75f, 1.0f, 1.25f, 2.0f, 3.0f, 4.0f, 5.0f};
  static float s[128 * 128];
  uint8_t r1 = g.cam[1], r7 = g.cam[4], r0 = g.cam[5];
  int vh = (r1 >> 5) & 3, gi = r1 & 0x1F, e = r7 >> 4, inv = (r7 >> 3) & 1, z = r0 >> 6, o = r0 & 0x3F;
  if(((g.cam[0] >> 1) & 3) == 0) inv ^= 1;              /* $A000 bits 2-1 = 00: P / M = 00 / 01, the negative image (AntonioND, docs §18.2) */
  float t = (float)(((uint32_t)g.cam[2] << 8) | g.cam[3]) * 16.0f / 1048576.0f;
  float G = powf(10.0f, (GDB[gi & 15] + ((gi & 16) ? 6.0f : 0.0f)) / 20.0f), al = ALPHA[e & 7];
  float vref = 0.5f * (r7 & 7), ov = (o & 0x20 ? 1.0f : -1.0f) * 0.032f * (o & 0x1F);
  float w = (vh == 0 ? 0.0093f : vh == 3 ? 0.015f + 0.004f * al : 0.012f + 0.004f * al) * cam_w_scale;
  for(int i = 0; i < 128 * 128; i++) s[i] = (t > 0 ? cv_signal(cam_scene[i], t) * 0.0001f : 0.0f) + cam_kd * t;
  for(int y = 0; y < 128; y++) for(int x = 0; x < 128; x++){
    int i = y * 128 + x; float p = s[i], q = p;
    if(vh){
      float W = s[y * 128 + (x > 0 ? x - 1 : x)], E_ = s[y * 128 + (x < 127 ? x + 1 : x)];
      float N_ = s[(y > 0 ? y - 1 : y) * 128 + x], S_ = s[(y < 127 ? y + 1 : y) * 128 + x];
      float k = vh == 1 ? 2 * p - W - E_ : vh == 2 ? 2 * p - N_ - S_ : 4 * p - N_ - S_ - E_ - W;
      q = (e & 8) ? al * k : p + al * k;
    }
    float v = vref + ov + (inv ? -G * q : G * q) - 0.028f - G * w + (z == 0 ? -0.25f * G : 0.0f) + cam_noise * cam_gauss();
    if(v < 0) v = 0; if(v > 4.0f) v = 4.0f;
    cam_volts[i] = v;
  }
  for(int y = 0; y < 120; y++) for(int tx = 0; tx < 16; tx++){
    uint8_t lo = 0, hi = 0;
    for(int px = 0; px < 8; px++){
      int x = tx * 8 + px; const uint8_t *th = &g.cam[6 + 3 * (4 * (y & 3) + (x & 3))]; float v = cam_volts[y * 128 + x];
      int val = v < th[0] * (3.0f / 255) ? 3 : v < th[1] * (3.0f / 255) ? 2 : v < th[2] * (3.0f / 255) ? 1 : 0;
      lo |= (val & 1) << (7 - px); hi |= ((val >> 1) & 1) << (7 - px);
    }
    int off = (y >> 3) * 256 + tx * 16 + (y & 7) * 2; g.sram[off] = lo; g.sram[off + 1] = hi;
  }
}
void gb_cam_model(int on){ cam_model = on; }
static uint8_t cam_log[8192][6]; static int cam_log_n;           /* every capture started: reg 1, reg 7, reg 0, C1, C0, first matrix byte */
static void cam_log_capture(void){ if(cam_log_n < 8192){ uint8_t *q = cam_log[cam_log_n]; q[0] = g.cam[1]; q[1] = g.cam[4]; q[2] = g.cam[5]; q[3] = g.cam[2]; q[4] = g.cam[3]; q[5] = g.cam[6]; } cam_log_n++; }
int gb_cam_log(uint8_t *out, int max){ int n = cam_log_n < max ? cam_log_n : max; if(n > 8192) n = 8192; memcpy(out, cam_log, 6 * n); return cam_log_n; }
void gb_cam_log_clear(void){ cam_log_n = 0; }
void gb_cam_scene(const float *lux){ memcpy(cam_scene, lux, sizeof cam_scene); }
void gb_cam_scene_uniform(float lux){ for(int i = 0; i < 128 * 128; i++) cam_scene[i] = lux; }
void gb_cam_unit(float w_scale, float kd, float noise){ cam_w_scale = w_scale; cam_kd = kd; cam_noise = noise; }   /* the sensor unit: 1, 0.011, 0.002 = camera 1 */
float *gb_cam_volts_ptr(void){ return cam_volts; }
float gb_cam_signal_mv(float lux, float t){ return cv_signal(lux, t); }            /* the curve alone, for checks */
static void cam_fill(void){
  if(cam_model){ cam_capture_model(); return; }
  /* synthetic 128x112 image: smooth gradient + noise, stored as 2bpp tiles at SRAM bank 0 $A100.. (offset 0x100) */
  uint32_t r=g.rng;
  for(int t=0;t<224;t++){
    for(int row=0;row<8;row++){
      uint8_t lo=0,hi=0;
      for(int px=0;px<8;px++){
        r^=r<<13; r^=r>>17; r^=r<<5;
        int base=((t%16)*8+px)*3/128 + ((t/16)*8+row)*2/112;   /* 0..4 */
        int v=(base+(r&3))/2; if(v>3)v=3;
        lo|=(v&1)<<(7-px); hi|=((v>>1)&1)<<(7-px);
      }
      g.sram[0x100+t*16+row*2]=lo; g.sram[0x100+t*16+row*2+1]=hi;
    }
  }
  g.rng=r;
}

static uint8_t rd_io(uint8_t o){
  switch(o){
    case 0x00: return joyp();
    case 0x04: return g.div>>8;
    case 0x0F: return g.io[0x0F]|0xE0;
    case 0x41: return 0x80|(g.io[0x41]&0x78)|((g.lcd_on&&g.ly==g.io[0x45])?4:0)|stat_mode();
    case 0x44: return g.lcd_on?g.ly:0;
    case 0x02: return g.io[0x02]|0x7E;
    case 0x26: return g.io[0x26]|0x70;
    default: break;
  }
  if(o>=0x10&&o<=0x3F) return g.io[o];
  if(o==0x01||o==0x05||o==0x06||o==0x07||o==0x40||o==0x42||o==0x43||o==0x45||o==0x46||o==0x47||o==0x48||o==0x49||o==0x4A||o==0x4B) return g.io[o];
  if(o==0x07) return g.io[o]|0xF8;
  return 0xFF;
}

static uint8_t rd(uint16_t a){
  if(a<0x8000){ uint32_t o=romoff(a); return rom[o]; }
  if(a<0xA000) return g.vram[a-0x8000];
  if(a<0xC000){
    if(g.rambank>=0x10){ uint8_t r=a&0x7F; if(r==0) return g.cam[0]; return 0x00; }
    return g.sram[((g.rambank&0xF)<<13)|(a-0xA000)];
  }
  if(a<0xE000) return g.wram[a-0xC000];
  if(a<0xFE00) return g.wram[a-0xE000];
  if(a<0xFEA0) return g.oam[a-0xFE00];
  if(a<0xFF00) return 0xFF;
  if(a<0xFF80) return rd_io(a-0xFF00);
  if(a<0xFFFF) return g.hram[a-0xFF80];
  return g.ie;
}
static int site_all=-1;
/* an interrupt that switches banks (and switches back) must not leave its own call site as the read site of the code it interrupted: saved at
   dispatch, restored at reti (added 2026-11-02; before, reads after a VBlank in the middle of a far copy were credited to Irq_VBlank) */
static uint32_t ss_site[16], ss_site2[16]; static int ss_bank[16]; static uint16_t ss_sp[16]; static int ss_n=0;
static void site_push(void){ if(ss_n<16){ ss_site[ss_n]=cur_site; ss_site2[ss_n]=cur_site2; ss_bank[ss_n]=site_bank; ss_sp[ss_n]=site_sp; } ss_n++; }
static void site_pop(void){ if(ss_n>0){ ss_n--; if(ss_n<16){ cur_site=ss_site[ss_n]; cur_site2=ss_site2[ss_n]; site_bank=ss_bank[ss_n]; site_sp=ss_sp[ss_n]; } } }
/* copy-queue origin (GBCAM_QPC = "lo-hi[,lo-hi...]" hex, bank-0 PC ranges of the routines that copy from a queue in an interrupt, e.g. Vq_Process..Vq_RunStream):
   every write to RAM ($C000-$FFFE) by code outside those ranges records its writer and the two call sites above it (qwr*); a read of a queue byte by
   code inside the ranges makes that writer the current origin; the ROM bytes it then reads get the origin in cov_qsite* (first time only). */
static int q_init=0, q_n=0; static uint16_t q_lo[8], q_hi[8];
static uint32_t qwr[0x4000], qwr2[0x4000], qwr3[0x4000]; static uint32_t q_org=0, q_org2=0, q_org3=0;
static uint32_t cov_qsite[ROMSZ], cov_qsite2[ROMSZ], cov_qsite3[ROMSZ];
/* reader chain (GBCAM_RCHAIN=1): for the first data read of each ROM byte, the reading instruction and the two call sites above it on the stack */
static uint32_t cov_rch1[ROMSZ], cov_rch2[ROMSZ], cov_rch3[ROMSZ]; static int rch_flag=-1;
static inline int rch_on(void){ if(rch_flag<0){ const char*e=getenv("GBCAM_RCHAIN"); rch_flag=(e&&*e=='1'); } return rch_flag; }
static void q_load(void){ q_init=1; const char*e=getenv("GBCAM_QPC"); if(!e) return;
  while(*e && q_n<8){ unsigned lo,hi; if(sscanf(e,"%x-%x",&lo,&hi)!=2) break; q_lo[q_n]=lo; q_hi[q_n]=hi; q_n++; e=strchr(e,','); if(!e) break; e++; } }
static int in_q(void){ if(!q_init) q_load(); if(!q_n) return 0; uint16_t pc=cur_fetch_pc_bank&0xFFFF; if(pc>=0x4000) return 0;
  for(int i=0;i<q_n;i++) if(pc>=q_lo[i]&&pc<=q_hi[i]) return 1; return 0; }
static void q_callers(uint32_t*c2,uint32_t*c3){ int level=0; *c2=0; *c3=0;
  for(int k=0;k<8&&level<2;k++){ uint16_t a=g.sp+2*k; uint16_t w=rd(a)|(rd(a+1)<<8);
    if(w<3||w>=0x8000) continue; uint8_t bk=(w-3<0x4000)?0:(g.rombank&0x3F); uint8_t opc=rom_at_bank(w-3,bk);
    if(opc==0xCD||opc==0xC4||opc==0xCC||opc==0xD4||opc==0xDC){ uint32_t v=0x80000000u|((uint32_t)bk<<16)|(w-3); if(level==0) *c2=v; else *c3=v; level++; } } }
/* data read of ROM: record coverage */
static uint8_t rdd(uint16_t a){
  last_rd=a;
  if(a>=0xC000 && a<0xFFFF && q_n>=0 && in_q()){ uint16_t i=(a>=0xFF80)?(0x3F80+(a-0xFF80)):((a-0xC000)&0x1FFF); if(qwr[i]){ q_org=qwr[i]; q_org2=qwr2[i]; q_org3=qwr3[i]; } }
  if(a<0x8000){ uint32_t o2=romoff(a); if(!cov_rch1[o2] && rch_on()){ cov_rch1[o2]=0x80000000u|cur_fetch_pc_bank; q_callers(&cov_rch2[o2],&cov_rch3[o2]); } }
  if(a<0x8000 && q_org && in_q()){ uint32_t o=romoff(a); if(!cov_qsite[o]){ cov_qsite[o]=q_org; cov_qsite2[o]=q_org2; cov_qsite3[o]=q_org3; } }
  if(a<0x8000){ uint32_t o=romoff(a); if(organic) org_dread[o]=1; if(!cov_dread[o]){ cov_dread[o]=1; cnt_dread++; }
    if(!(cov_reader[o]&0x80000000u)) cov_reader[o]=0x80000000u|cur_fetch_pc_bank;
    if(site_all<0){ const char*e=getenv("GBCAM_SITE_ALL"); site_all=(e&&*e=='1'); }   /* GBCAM_SITE_ALL=1: modes and call sites of every read, forced runs too */
    if((organic||site_all) && !cov_mode[o]) cov_mode[o]=0x4000|((g.wram[0x15CE]&0x3F)<<8)|g.wram[0x15CF];
    if((organic||site_all) && a>=0x4000 && (g.rombank&0x3F)==site_bank && !cov_site[o] && cur_site && g.sp<=site_sp){ cov_site[o]=cur_site; cov_site2[o]=cur_site2; } }
  return rd(a);
}

static void lcd_stat_eval(void){
  if(!g.lcd_on){ g.stat_line=0; return; }
  uint8_t s=g.io[0x41], m=stat_mode(), l=0;
  if((s&0x40)&&g.ly==g.io[0x45]) l=1;
  if((s&0x08)&&m==0) l=1;
  if((s&0x10)&&m==1) l=1;
  if((s&0x20)&&m==2) l=1;
  if(l&&!g.stat_line) req(1);
  g.stat_line=l;
}

static void wr_io(uint8_t o, uint8_t v){
  switch(o){
    case 0x00: g.p1sel=v&0x30; { uint8_t nl=cur_lines(); if((g.last_p1lines&~nl)&0x0F) req(4); g.last_p1lines=nl; } return;
    case 0x01: g.io[0x01]=v; return;
    case 0x02: g.io[0x02]=v; if((v&0x81)==0x81){ g.serial_cd=4096; g.serial_rx = g.pr_attached? printer_xfer(g.io[0x01]) : 0xFF; } return;
    case 0x04: g.div=0; return;
    case 0x05: case 0x06: g.io[o]=v; return;
    case 0x07: g.io[o]=v&7; return;
    case 0x0F: g.io[0x0F]=v&0x1F; return;
    case 0x40: { uint8_t on=(v&0x80)!=0; if(!on&&g.lcd_on){ g.ly=0; g.line_cycle=0; g.stat_line=0; } if(on&&!g.lcd_on){ g.ly=0; g.line_cycle=0; } g.lcd_on=on; g.io[o]=v; lcd_stat_eval(); return; }
    case 0x41: g.io[o]=v&0x78; lcd_stat_eval(); return;
    case 0x44: return;
    case 0x45: g.io[o]=v; lcd_stat_eval(); return;
    case 0x46: { uint16_t s=(uint16_t)v<<8; for(int i=0;i<0xA0;i++) g.oam[i]=rd(s+i); g.io[o]=v; return; }
    default: g.io[o]=v; return;
  }
}

static int in_q(void);
static void cam_log_capture(void);
static void wr(uint16_t a, uint8_t v){
  if(a>=0xC000 && a<0xFFFF && !(a>=0xE000&&a<0xFF80) && !in_q()){ uint16_t i=(a>=0xFF80)?(0x3F80+(a-0xFF80)):(a-0xC000); if(q_n){ qwr[i]=0x80000000u|cur_fetch_pc_bank; q_callers(&qwr2[i],&qwr3[i]); } }
  if(a<0x2000){ g.ramen=v; return; }
  if(a<0x4000){ uint8_t old=g.rombank; g.rombank=v&0x3F; bsel_add(((cur_fetch_pc_bank>>16)<<24)|((cur_fetch_pc_bank&0xFFFF)<<8)|(v&0x3F),old,g.sp); return; }
  if(a<0x6000){ g.rambank=v; return; }
  if(a<0x8000) return;
  if(a<0xA000){ g.vram[a-0x8000]=v; return; }
  if(a<0xC000){
    if(g.rambank>=0x10){
      uint8_t r=a&0x7F; g.cam[r]=v;
      if(r==0){ if((v&1) && g.cam_cd==0){ uint32_t ex=((uint32_t)g.cam[2]<<8)|g.cam[3]; g.cam_cd=4*(32446+16*ex); g.cam[0]|=1; cam_log_capture(); } else if(!(v&1)){ } }
      return;
    }
    if(g.ramen==0x0A) g.sram[((g.rambank&0xF)<<13)|(a-0xA000)]=v;
    return;
  }
  if(a<0xE000){ g.wram[a-0xC000]=v; return; }
  if(a<0xFE00){ g.wram[a-0xE000]=v; return; }
  if(a<0xFEA0){ g.oam[a-0xFE00]=v; return; }
  if(a<0xFF00) return;
  if(a<0xFF80){ wr_io(a-0xFF00,v); return; }
  if(a<0xFFFF){ g.hram[a-0xFF80]=v; return; }
  g.ie=v;
}

/* ---- time ---- */
static uint32_t vblanks;   /* V-Blank starts (LY reaches 144, LCD on): BGB's demo takes one byte per such frame (tools/jp/bgb_run.py core_demo) */
uint32_t gb_vblanks(void){ return vblanks; }
static void tick_hw(int cyc){
  g.cycles+=cyc;
  /* timer */
  g.div+=cyc;
  if(g.io[0x07]&4){ static const int per[4]={1024,16,64,256}; g.tima_acc+=cyc; int p=per[g.io[0x07]&3];
    while(g.tima_acc>=p){ g.tima_acc-=p; if(++g.io[0x05]==0){ g.io[0x05]=g.io[0x06]; req(2);} } }
  /* serial */
  if(g.serial_cd>0){ g.serial_cd-=cyc; if(g.serial_cd<=0){ g.serial_cd=0; g.io[0x01]=g.serial_rx; g.io[0x02]&=~0x80; req(3);} }
  /* camera */
  if(g.cam_cd>0){ g.cam_cd-=cyc; if(g.cam_cd<=0){ g.cam_cd=0; g.cam[0]&=~1; cam_fill(); } }
  /* lcd */
  if(g.lcd_on){
    g.line_cycle+=cyc;
    while(g.line_cycle>=456){ g.line_cycle-=456; g.ly++; if(g.ly==144){ req(0); vblanks++; } if(g.ly>153){ g.ly=0; g.frame++; } lcd_stat_eval(); }
    lcd_stat_eval();
  } else { /* LCD off: frames still counted by cycle */
    static uint32_t acc=0; acc+=cyc; if(acc>=70224){ acc-=70224; g.frame++; }
  }
}

/* ---- CPU ---- */
#define FZ 0x80
#define FN 0x40
#define FH 0x20
#define FC 0x10
static inline uint16_t BC(void){return (g.b<<8)|g.c;} static inline uint16_t DE(void){return (g.d<<8)|g.e;} static inline uint16_t HL(void){return (g.h<<8)|g.l;}
static inline void setBC(uint16_t v){g.b=v>>8;g.c=v;} static inline void setDE(uint16_t v){g.d=v>>8;g.e=v;} static inline void setHL(uint16_t v){g.h=v>>8;g.l=v;}

static inline void mark_fetch(uint16_t pc, int opcode){
  if(pc<0x8000){ uint32_t o=romoff(pc);
    if(organic){ if(opcode) org_exec[o]=1; else if(!org_exec[o]) org_exec[o]=2; }
    if(cov_exec[o]==0){ cov_exec[o]=opcode?1:2; cnt_exec++; if(!(cov_reader[o]&0x80000000u)) cov_reader[o]=0x80000000u|((uint32_t)cur_bank(pc)<<16)|pc; }
    else if(opcode && cov_exec[o]==2) cov_exec[o]=1;
  } else if(pc>=0x8000){ if(organic) org_ram[pc]=1; if(!cov_ram[pc]){ cov_ram[pc]=1; cnt_ram++; } }
}
static inline uint8_t fetch(int opcode){ mark_fetch(g.pc,opcode); uint8_t v=rd(g.pc); g.pc++; return v; }
static inline uint16_t fetch16(void){ uint8_t l=fetch(0); uint8_t h=fetch(0); return (h<<8)|l; }
static inline void push16(uint16_t v){ g.sp--; wr(g.sp,v>>8); g.sp--; wr(g.sp,v&0xFF); }
static inline uint16_t pop16(void){ uint8_t l=rdd(g.sp++); uint8_t h=rdd(g.sp++); return (h<<8)|l; }

static inline uint8_t getr(int i){ switch(i){case 0:return g.b;case 1:return g.c;case 2:return g.d;case 3:return g.e;case 4:return g.h;case 5:return g.l;case 6:return rdd(HL());default:return g.a;} }
static inline void setr(int i,uint8_t v){ switch(i){case 0:g.b=v;break;case 1:g.c=v;break;case 2:g.d=v;break;case 3:g.e=v;break;case 4:g.h=v;break;case 5:g.l=v;break;case 6:wr(HL(),v);break;default:g.a=v;} }

static void alu(int op,uint8_t v){
  uint8_t a=g.a; int r;
  switch(op){
    case 0: r=a+v; g.f=((r&0xFF)==0?FZ:0)|(((a&15)+(v&15))>15?FH:0)|(r>0xFF?FC:0); g.a=r; break;
    case 1: { int c=(g.f&FC)?1:0; r=a+v+c; g.f=((r&0xFF)==0?FZ:0)|(((a&15)+(v&15)+c)>15?FH:0)|(r>0xFF?FC:0); g.a=r; break; }
    case 2: r=a-v; g.f=FN|((r&0xFF)==0?FZ:0)|(((a&15)<(v&15))?FH:0)|(r<0?FC:0); g.a=r; break;
    case 3: { int c=(g.f&FC)?1:0; r=a-v-c; g.f=FN|((r&0xFF)==0?FZ:0)|(((a&15)<((v&15)+c))?FH:0)|(r<0?FC:0); g.a=r; break; }
    case 4: g.a=a&v; g.f=(g.a==0?FZ:0)|FH; break;
    case 5: g.a=a^v; g.f=(g.a==0?FZ:0); break;
    case 6: g.a=a|v; g.f=(g.a==0?FZ:0); break;
    default: r=a-v; g.f=FN|((r&0xFF)==0?FZ:0)|(((a&15)<(v&15))?FH:0)|(r<0?FC:0); break;
  }
}
static int cc_ok(int cc){ switch(cc){case 0:return !(g.f&FZ);case 1:return g.f&FZ;case 2:return !(g.f&FC);default:return g.f&FC;} }

static int do_cb(void){
  uint8_t op=fetch(0); int r=op&7, y=(op>>3)&7;
  if((op>>6)==1){ if(r==7 && a_src>=0) cmp_log(a_src,1<<y,1,cur_fetch_pc_bank); else if(r==6){ uint16_t hl=HL(); if((hl>=0xA000&&hl<0xC000)||(hl>=0xC000&&hl<0xE000)||hl>=0xFF80) cmp_log(hl,1<<y,1,cur_fetch_pc_bank); } }
  uint8_t v=getr(r); int cyc=(r==6)?16:8;
  switch(op>>6){
    case 0: { uint8_t res, c;
      switch(y){
        case 0: c=v>>7; res=(v<<1)|c; break;
        case 1: c=v&1; res=(v>>1)|(c<<7); break;
        case 2: c=v>>7; res=(v<<1)|((g.f&FC)?1:0); break;
        case 3: c=v&1; res=(v>>1)|((g.f&FC)?0x80:0); break;
        case 4: c=v>>7; res=v<<1; break;
        case 5: c=v&1; res=(v>>1)|(v&0x80); break;
        case 6: c=0; res=(v>>4)|(v<<4); break;
        default: c=v&1; res=v>>1; break; }
      g.f=(res==0?FZ:0)|(c?FC:0); setr(r,res); break; }
    case 1: g.f=(g.f&FC)|FH|(((v>>y)&1)?0:FZ); if(r==6)cyc=12; break;
    case 2: setr(r,v&~(1<<y)); break;
    default: setr(r,v|(1<<y)); break;
  }
  return cyc;
}

static int step_cpu(void){
  /* interrupts */
  uint8_t pend=g.io[0x0F]&g.ie&0x1F;
  if(g.halted){ if(pend) g.halted=0; else return 4; }
  if(g.ime && pend){
    int i=0; while(!(pend&(1<<i))) i++;
    g.ime=0; g.io[0x0F]&=~(1<<i); push16(g.pc); g.pc=0x40+8*i; a_src=-1; site_push(); return 20;
  }
  if(!organic && known_loaded){ int ok; if(g.pc<0x8000) ok=known[romoff(g.pc)]; else ok=(g.pc>=0xFF80&&g.pc<0xFF90); if(!ok){ wild=1; return 4; } }
  int enable_ei=g.ei_delay; 
  cur_fetch_pc_bank=((uint32_t)cur_bank(g.pc)<<16)|g.pc;
  uint8_t op=fetch(1); int cyc=4; uint8_t a0=g.a; last_rd=-1;
  if(op==0xCB){ cyc=do_cb(); }
  else if(op<0x40){
    int lo=op&7, hi=op>>3;
    switch(lo){
      case 0:
        if(op==0x00) cyc=4;
        else if(op==0x08){ uint16_t a=fetch16(); wr(a,g.sp&0xFF); wr(a+1,g.sp>>8); cyc=20; }
        else if(op==0x10){ fetch(0); cyc=4; }
        else if(op==0x18){ int8_t e=(int8_t)fetch(0); g.pc+=e; cyc=12; }
        else { int8_t e=(int8_t)fetch(0); if(cc_ok(hi-4)){ g.pc+=e; cyc=12; } else cyc=8; }
        break;
      case 1:
        if(!(hi&1)){ uint16_t v=fetch16(); switch(hi>>1){case 0:setBC(v);break;case 1:setDE(v);break;case 2:setHL(v);break;default:g.sp=v;} cyc=12; }
        else { uint16_t hl=HL(), v; switch(hi>>1){case 0:v=BC();break;case 1:v=DE();break;case 2:v=hl;break;default:v=g.sp;}
          uint32_t r=hl+v; g.f=(g.f&FZ)|(((hl&0xFFF)+(v&0xFFF))>0xFFF?FH:0)|(r>0xFFFF?FC:0); setHL(r); cyc=8; }
        break;
      case 2:
        switch(hi){
          case 0: wr(BC(),g.a); break; case 1: g.a=rdd(BC()); break;
          case 2: wr(DE(),g.a); break; case 3: g.a=rdd(DE()); break;
          case 4: { uint16_t h=HL(); wr(h,g.a); setHL(h+1); break; } case 5: { uint16_t h=HL(); g.a=rdd(h); setHL(h+1); break; }
          case 6: { uint16_t h=HL(); wr(h,g.a); setHL(h-1); break; } default: { uint16_t h=HL(); g.a=rdd(h); setHL(h-1); break; }
        } cyc=8; break;
      case 3: { int d=(hi&1)?-1:1; switch(hi>>1){case 0:setBC(BC()+d);break;case 1:setDE(DE()+d);break;case 2:setHL(HL()+d);break;default:g.sp+=d;} cyc=8; break; }
      case 4: { uint8_t v=getr(hi)+1; setr(hi,v); g.f=(g.f&FC)|(v==0?FZ:0)|((v&15)==0?FH:0); cyc=(hi==6)?12:4; break; }
      case 5: { uint8_t v=getr(hi)-1; setr(hi,v); g.f=(g.f&FC)|FN|(v==0?FZ:0)|((v&15)==15?FH:0); cyc=(hi==6)?12:4; break; }
      case 6: { uint8_t v=fetch(0); setr(hi,v); cyc=(hi==6)?12:8; break; }
      default:
        switch(hi){
          case 0: { uint8_t c=g.a>>7; g.a=(g.a<<1)|c; g.f=c?FC:0; break; }
          case 1: { uint8_t c=g.a&1; g.a=(g.a>>1)|(c<<7); g.f=c?FC:0; break; }
          case 2: { uint8_t c=g.a>>7; g.a=(g.a<<1)|((g.f&FC)?1:0); g.f=c?FC:0; break; }
          case 3: { uint8_t c=g.a&1; g.a=(g.a>>1)|((g.f&FC)?0x80:0); g.f=c?FC:0; break; }
          case 4: { int a=g.a; if(!(g.f&FN)){ if((g.f&FC)||a>0x99){a+=0x60;g.f|=FC;} if((g.f&FH)||(a&15)>9) a+=6; } else { if(g.f&FC)a-=0x60; if(g.f&FH)a-=6; } g.a=a; g.f=(g.f&(FN|FC))|(g.a==0?FZ:0); break; }
          case 5: g.a=~g.a; g.f|=FN|FH; break;
          case 6: g.f=(g.f&FZ)|FC; break;
          default: g.f=(g.f&FZ)|((g.f&FC)?0:FC); break;
        } cyc=4; break;
    }
  }
  else if(op<0x80){
    if(op==0x76){ if(g.ime||!(g.io[0x0F]&g.ie&0x1F)) g.halted=1; cyc=4; }
    else { int d=(op>>3)&7, s=op&7; setr(d,getr(s)); cyc=(d==6||s==6)?8:4; }
  }
  else if(op<0xC0){ int s=op&7; uint8_t v=getr(s);
    if(a_src>=0){ if(op>=0xB8&&op<0xBF) cmp_log(a_src,v,0,cur_fetch_pc_bank); else if(op==0xA7||op==0xB7) { cmp_log(a_src,0,0,cur_fetch_pc_bank); cmp_log(a_src,1,0,cur_fetch_pc_bank);} }
    alu((op>>3)&7,v); cyc=(s==6)?8:4; }
  else {
    switch(op){
      case 0xC0:case 0xC8:case 0xD0:case 0xD8: if(cc_ok((op>>3)&3)){ g.pc=pop16(); cyc=20; } else cyc=8; break;
      case 0xC9: g.pc=pop16(); cyc=16; break;
      case 0xD9: g.pc=pop16(); g.ime=1; site_pop(); cyc=16; break;
      case 0xC1: setBC(pop16()); cyc=12; break; case 0xD1: setDE(pop16()); cyc=12; break; case 0xE1: setHL(pop16()); cyc=12; break;
      case 0xF1: { uint16_t v=pop16(); g.a=v>>8; g.f=v&0xF0; cyc=12; break; }
      case 0xC5: push16(BC()); cyc=16; break; case 0xD5: push16(DE()); cyc=16; break; case 0xE5: push16(HL()); cyc=16; break;
      case 0xF5: push16((g.a<<8)|g.f); cyc=16; break;
      case 0xC2:case 0xCA:case 0xD2:case 0xDA: { uint16_t a=fetch16(); if(cc_ok((op>>3)&3)){ g.pc=a; cyc=16; } else cyc=12; break; }
      case 0xC3: g.pc=fetch16(); cyc=16; break;
      case 0xE9: g.pc=HL(); cyc=4; break;
      case 0xC4:case 0xCC:case 0xD4:case 0xDC: { uint16_t a=fetch16(); if(cc_ok((op>>3)&3)){ push16(g.pc); g.pc=a; cyc=24; } else cyc=12; break; }
      case 0xCD: { uint16_t a=fetch16(); push16(g.pc); g.pc=a; cyc=24; break; }
      case 0xC7:case 0xCF:case 0xD7:case 0xDF:case 0xE7:case 0xEF:case 0xF7:case 0xFF: push16(g.pc); g.pc=op&0x38; cyc=16; break;
      case 0xC6:case 0xCE:case 0xD6:case 0xDE:case 0xE6:case 0xEE:case 0xF6:case 0xFE: { uint8_t im=fetch(0);
        if(a_src>=0){ if(op==0xFE) cmp_log(a_src,im,0,cur_fetch_pc_bank); else if(op==0xE6) cmp_log(a_src,im,1,cur_fetch_pc_bank); }
        alu((op>>3)&7,im); cyc=8; break; }
      case 0xE0: wr(0xFF00+fetch(0),g.a); cyc=12; break;
      case 0xF0: g.a=rdd(0xFF00+fetch(0)); cyc=12; break;
      case 0xE2: wr(0xFF00+g.c,g.a); cyc=8; break;
      case 0xF2: g.a=rdd(0xFF00+g.c); cyc=8; break;
      case 0xEA: { uint16_t a=fetch16(); wr(a,g.a); cyc=16; break; }
      case 0xFA: { uint16_t a=fetch16(); g.a=rdd(a); cyc=16; break; }
      case 0xE8: { int8_t e=(int8_t)fetch(0); uint16_t sp=g.sp; g.f=(((sp&15)+(e&15))>15?FH:0)|(((sp&0xFF)+(e&0xFF))>0xFF?FC:0); g.sp=sp+e; cyc=16; break; }
      case 0xF8: { int8_t e=(int8_t)fetch(0); uint16_t sp=g.sp; g.f=(((sp&15)+(e&15))>15?FH:0)|(((sp&0xFF)+(e&0xFF))>0xFF?FC:0); setHL(sp+e); cyc=12; break; }
      case 0xF9: g.sp=HL(); cyc=8; break;
      case 0xF3: g.ime=0; g.ei_delay=0; enable_ei=0; cyc=4; break;
      case 0xFB: g.ei_delay=1; enable_ei=0; cyc=4; break;
      default: cyc=4; break; /* invalid opcodes: treated as NOP */
    }
  }
  switch(op){ case 0x0A:case 0x1A:case 0x2A:case 0x3A:case 0x7E:case 0xF0:case 0xF2:case 0xFA:
      a_src=(last_rd>=0xA000&&last_rd<0xE000)||last_rd>=0xFF80?last_rd:-1; if(a_src>=0xC000) rd_log(a_src,g.a); break;
    default: if(g.a!=a0) a_src=-1; }
  if(g.ei_delay && op!=0xFB){ g.ei_delay=0; g.ime=1; }
  (void)enable_ei;
  return cyc;
}

void gb_set_keys(uint8_t k){ uint8_t old=cur_lines(); g.keys=k; uint8_t nl=cur_lines(); if((old&~nl)&0x0F) req(4); g.last_p1lines=nl; }
void gb_attach_printer(int on){ g.pr_attached=on; g.pr_state=0; memset(g.pr_n,0,sizeof g.pr_n); }
void gb_printer_model(int real){ pr_real=real; }
void gb_printer_inject_clear(void){ inj_n=0; plog_n=0; }
int gb_printer_inject(int cmd,int nth,int status,int count){ if(inj_n>=16) return -1; inj_cmd[inj_n]=cmd; inj_nth[inj_n]=nth; inj_st[inj_n]=status; inj_cnt[inj_n]=count; return inj_n++; }
int gb_printer_log(uint8_t*cmds,uint8_t*rxs,int max){ int n=plog_n<max?plog_n:max; memcpy(cmds,plog_cmd,n); memcpy(rxs,plog_rx,n); return plog_n; }

void gb_reset(const uint8_t*sram, size_t n){
  memset(&g,0,sizeof(g));
  g.a=0x01; g.f=0xB0; g.b=0x00; g.c=0x13; g.d=0x00; g.e=0xD8; g.h=0x01; g.l=0x4D; g.sp=0xFFFE; g.pc=0x0100;
  g.io[0x40]=0x91; g.io[0x41]=0x00; g.io[0x47]=0xFC; g.io[0x0F]=0x01; g.lcd_on=1; g.ly=0x91-0x91; g.rombank=1; g.ramen=0; g.rng=0x12345678; g.p1sel=0x30; g.last_p1lines=0x0F;
  g.io[0x26]=0xF1;
  if(sram) memcpy(g.sram,sram,n>sizeof(g.sram)?sizeof(g.sram):n);
}

/* run until the frame counter changes (or max cycles), return executed instructions */
int gb_run_frame(void){
  uint32_t f0=g.frame; int n=0;
  while(g.frame==f0 && n<2000000 && !wild){ int c=step_cpu(); tick_hw(c); n++; }
  return n;
}
/* run exactly this many frames; stops early if pc leaves ROM-resident traced area is not checked here */
void gb_run_frames(int k){ for(int i=0;i<k;i++) gb_run_frame(); }

uint8_t gb_peek(uint16_t a){ return rd(a); }
void gb_poke(uint16_t a,uint8_t v){ if(a>=0xC000&&a<0xE000) g.wram[a-0xC000]=v; else if(a>=0xFF80&&a<0xFFFF) g.hram[a-0xFF80]=v; else if(a>=0xA000&&a<0xC000&&g.rambank<0x10) g.sram[((g.rambank&0xF)<<13)|(a-0xA000)]=v; }
uint16_t gb_pc(void){ return g.pc; } uint8_t gb_rombank(void){ return g.rombank; } uint32_t gb_frame(void){ return g.frame; } uint64_t gb_cycles(void){ return g.cycles; }
uint8_t* gb_sram_ptr(void){ return g.sram; } uint8_t* gb_wram_ptr(void){ return g.wram; }
uint64_t gb_cnt_exec(void){return cnt_exec;} uint64_t gb_cnt_dread(void){return cnt_dread;} uint64_t gb_cnt_ram(void){return cnt_ram;}
const uint8_t* gb_cov_exec_ptr(void){ return cov_exec; } const uint8_t* gb_cov_dread_ptr(void){ return cov_dread; } const uint32_t* gb_cov_reader_ptr(void){ return cov_reader; } const uint8_t* gb_cov_ram_ptr(void){ return cov_ram; }
uint32_t gb_bsel_n(int t){ return bsel_n[t]; }
int gb_bsel_dump(int t,uint32_t*keys,uint32_t*cnts,int max){ int n=0; for(int i=0;i<BSZ&&n<max;i++) if(bsel_cnt[t][i]){ keys[n]=bsel_key[t][i]; cnts[n]=bsel_cnt[t][i]; n++; } return n; }
void gb_cov_clear(void){ memset(cov_exec,0,sizeof cov_exec); memset(cov_dread,0,sizeof cov_dread); memset(cov_reader,0,sizeof cov_reader); memset(cov_ram,0,sizeof cov_ram); cnt_exec=cnt_dread=cnt_ram=0; memset(bsel_cnt,0,sizeof bsel_cnt); bsel_n[0]=bsel_n[1]=bsel_n[2]=bsel_n[3]=0; }
void gb_cov_load(const uint8_t*ex,const uint8_t*dr,const uint32_t*rdr,const uint8_t*ram){ memcpy(cov_exec,ex,ROMSZ); memcpy(cov_dread,dr,ROMSZ); memcpy(cov_reader,rdr,ROMSZ*4); memcpy(cov_ram,ram,0x10000); cnt_exec=cnt_dread=cnt_ram=0; for(int i=0;i<ROMSZ;i++){ cnt_exec+=cov_exec[i]!=0; cnt_dread+=cov_dread[i]!=0; } for(int i=0;i<0x10000;i++) cnt_ram+=cov_ram[i]!=0; }
void gb_bsel_clear(void){ memset(bsel_cnt,0,sizeof bsel_cnt); bsel_n[0]=bsel_n[1]=bsel_n[2]=bsel_n[3]=0; }
void gb_bsel_put(int t,uint32_t key,uint32_t cnt){ bsel_add1(t,key,cnt); }
void gb_set_organic(int v){ organic=v; }
void gb_cmp_clear(void){ cmp_epoch++; cmp_n=0; }
int gb_rd_dump(uint16_t*addrs,uint8_t*vals,int max){ int n=0; for(int i=0;i<0x2080&&n<max;i++) if(rd_ep[i]==cmp_epoch){ addrs[n]=i<0x2000?0xC000+i:0xFF80+(i-0x2000); vals[n]=rd_val[i]; n++; } return n; }
int gb_cmp_dump(uint32_t*keys,uint32_t*pcs,int max){ int n=0; for(int i=0;i<CMPSZ&&n<max;i++) if(cmp_ep[i]==cmp_epoch){ keys[n]=cmp_key[i]; pcs[n]=cmp_pc[i]; n++; } return n; }
const uint8_t* gb_org_exec_ptr(void){ return org_exec; } const uint8_t* gb_org_dread_ptr(void){ return org_dread; }
void gb_org_load(const uint8_t*ex,const uint8_t*dr){ memcpy(org_exec,ex,ROMSZ); memcpy(org_dread,dr,ROMSZ); }
int organic_get(void){ return organic; }
void gb_set_known(const uint8_t*k){ memcpy(known,k,ROMSZ); known_loaded=1; }
int gb_wild(void){ return wild; }
const uint8_t* gb_org_ram_ptr(void){ return org_ram; }
void gb_org_load2(const uint8_t*ex,const uint8_t*dr,const uint8_t*ram){ memcpy(org_exec,ex,ROMSZ); memcpy(org_dread,dr,ROMSZ); memcpy(org_ram,ram,0x10000); }
const uint32_t* gb_rchain_ptr(int k){ return k==0?cov_rch1:(k==1?cov_rch2:cov_rch3); }
const uint32_t* gb_qsite_ptr(int k){ return k==0?cov_qsite:(k==1?cov_qsite2:cov_qsite3); }
const uint32_t* gb_site_ptr(void){ return cov_site; } const uint32_t* gb_site2_ptr(void){ return cov_site2; }
void gb_site_load(const uint32_t*a,const uint32_t*b){ memcpy(cov_site,a,ROMSZ*4); memcpy(cov_site2,b,ROMSZ*4); }
const uint16_t* gb_mode_ptr(void){ return cov_mode; }
void gb_mode_load(const uint16_t*a){ memcpy(cov_mode,a,ROMSZ*2); }

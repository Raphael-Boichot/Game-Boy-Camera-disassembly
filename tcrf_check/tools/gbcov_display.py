"""gbcov_display: ctypes wrapper of gbcov_display.c = the package coverage core (coverage/src/gbcov.c) plus DISPLAY TRACKING (README 16.24).
Build:  cc -O2 -shared -fPIC -o libgbcov_display.so gbcov_display.c   (next to this file, or point GBCOV_LIB at it).
What the instrumentation adds to the core (everything is global, not part of snapshots, except the taint arrays, which are):
  * source taint: every VRAM / WRAM / HRAM byte remembers the ROM offset it was copied from (a ring of the last 8 tainted reads is matched by value
    at each write, values 00 / FF carry no taint), so a tile in VRAM can be traced back to its ROM span even through WRAM staging buffers;
  * display tracking: at cycle 160 of every visible line the BG / window map cells and OBJ entries are evaluated with the current LCDC / SCX / SCY / WX / WY
    (so the V-Blank trick that shows more than 256 tiles is followed per line), and the ROM offsets behind the fetched tile rows and the map cells are marked:
    disp (bit0 any run, bit1 organic run), disp_fr / disp_fro = number of distinct frames in which the byte was on screen (any / organic);
  * sound requests: the values written to the four request mailboxes $DD60 / $DD68 / $DD70 / $DD78 and the started ids $DD61 / $DD69 / $DD71 / $DD79 (snd[8][256],
    bit0 any, bit1 organic)."""
import ctypes as C, numpy as np, os
import sys, platform
HERE = os.path.dirname(os.path.abspath(__file__))
_lib = os.environ.get('GBCOV_LIB') or 'libgbcov_display.so'
L = C.CDLL(os.path.join(HERE, _lib))
L.gb_state_size.restype = C.c_size_t
L.gb_load_rom.argtypes = [C.c_char_p]; L.gb_load_rom.restype = C.c_int
L.gb_reset.argtypes = [C.c_char_p, C.c_size_t]
L.gb_save.argtypes = [C.c_void_p]; L.gb_load.argtypes = [C.c_void_p]
L.gb_set_keys.argtypes = [C.c_uint8]; L.gb_attach_printer.argtypes = [C.c_int]
L.gb_printer_model.argtypes = [C.c_int]; L.gb_printer_inject.argtypes = [C.c_int] * 4; L.gb_printer_inject.restype = C.c_int; L.gb_printer_log.argtypes = [C.c_void_p, C.c_void_p, C.c_int]; L.gb_printer_log.restype = C.c_int
L.gb_run_frames.argtypes = [C.c_int]; L.gb_run_frame.restype = C.c_int
L.gb_peek.argtypes = [C.c_uint16]; L.gb_peek.restype = C.c_uint8
L.gb_poke.argtypes = [C.c_uint16, C.c_uint8]
L.gb_pc.restype = C.c_uint16; L.gb_rombank.restype = C.c_uint8
L.gb_frame.restype = C.c_uint32; L.gb_cycles.restype = C.c_uint64
for n in ('gb_cnt_exec', 'gb_cnt_dread', 'gb_cnt_ram'): getattr(L, n).restype = C.c_uint64
for n in ('gb_cov_exec_ptr', 'gb_cov_dread_ptr', 'gb_cov_ram_ptr', 'gb_cov_reader_ptr', 'gb_sram_ptr', 'gb_wram_ptr'):
    getattr(L, n).restype = C.c_void_p
L.gb_bsel_n.argtypes = [C.c_int]; L.gb_bsel_n.restype = C.c_uint32
L.gb_bsel_dump.argtypes = [C.c_int, C.c_void_p, C.c_void_p, C.c_int]; L.gb_bsel_dump.restype = C.c_int
L.gb_cov_load.argtypes = [C.c_void_p] * 4
L.gb_bsel_put.argtypes = [C.c_int, C.c_uint32, C.c_uint32]
L.gb_set_organic.argtypes = [C.c_int]
L.gb_cmp_dump.argtypes = [C.c_void_p, C.c_void_p, C.c_int]; L.gb_cmp_dump.restype = C.c_int
L.gb_org_load2.argtypes = [C.c_void_p, C.c_void_p, C.c_void_p]
L.gb_set_known.argtypes = [C.c_void_p]; L.gb_wild.restype = C.c_int; L.gb_org_ram_ptr.restype = C.c_void_p
L.gb_org_exec_ptr.restype = C.c_void_p; L.gb_org_dread_ptr.restype = C.c_void_p
ROMSZ = 1 << 20
STATE_SIZE = L.gb_state_size()

# joypad bits
RIGHT, LEFT, UP, DOWN, A, B, SELECT, START = 1, 2, 4, 8, 16, 32, 64, 128

def _arr(ptr, n, dt): return np.ctypeslib.as_array(C.cast(ptr, C.POINTER(dt)), shape=(n,))
def cov_exec():  return _arr(L.gb_cov_exec_ptr(), ROMSZ, C.c_uint8)
def cov_dread(): return _arr(L.gb_cov_dread_ptr(), ROMSZ, C.c_uint8)
def cov_reader(): return _arr(L.gb_cov_reader_ptr(), ROMSZ, C.c_uint32)
def cov_ram():   return _arr(L.gb_cov_ram_ptr(), 0x10000, C.c_uint8)
def wram():      return _arr(L.gb_wram_ptr(), 0x2000, C.c_uint8)
def sram():      return _arr(L.gb_sram_ptr(), 0x20000, C.c_uint8)

def load_rom(path):
    n = L.gb_load_rom(path.encode()); assert n > 0, path; return n
def reset(sram_bytes=b''):
    L.gb_reset(sram_bytes, len(sram_bytes))
def snapshot():
    b = (C.c_uint8 * STATE_SIZE)(); L.gb_save(b); return bytes(b)
def restore(s):
    b = (C.c_uint8 * STATE_SIZE).from_buffer_copy(s); L.gb_load(b)
def run(n): L.gb_run_frames(n)
def keys(k): L.gb_set_keys(k)
def peek(a): return L.gb_peek(a)
def peek16(a): return peek(a) | peek(a + 1) << 8
def tap(k, hold=4, wait=20):
    keys(k); run(hold); keys(0); run(wait)
def bsel(t=0):
    n = L.gb_bsel_n(t); ks = (C.c_uint32 * (n + 1))(); cs = (C.c_uint32 * (n + 1))()
    m = L.gb_bsel_dump(t, ks, cs, n + 1)
    return [(k >> 24, (k >> 8) & 0xFFFF, k & 0xFF, c) for k, c in zip(ks[:m], cs[:m])]
def org_exec(): return _arr(L.gb_org_exec_ptr(), ROMSZ, C.c_uint8)
def org_dread(): return _arr(L.gb_org_dread_ptr(), ROMSZ, C.c_uint8)
def set_organic(v): L.gb_set_organic(1 if v else 0)
def poke(a, v): L.gb_poke(a, v)
def cmp_clear(): L.gb_cmp_clear()
def cmp_dump(maxn=4096):
    ks = (C.c_uint32 * maxn)(); ps = (C.c_uint32 * maxn)()
    n = L.gb_cmp_dump(ks, ps, maxn)
    return [(k >> 16, (k >> 8) & 0xFF, k & 0xFF, p) for k, p in zip(ks[:n], ps[:n])]
L.gb_rd_dump.argtypes = [C.c_void_p, C.c_void_p, C.c_int]; L.gb_rd_dump.restype = C.c_int
def rd_dump(maxn=9000):
    a = (C.c_uint16 * maxn)(); v = (C.c_uint8 * maxn)(); n = L.gb_rd_dump(a, v, maxn)
    return list(zip(a[:n], v[:n]))
def bsel_raw(t):
    n = L.gb_bsel_n(t); ks = (C.c_uint32 * (n + 1))(); cs = (C.c_uint32 * (n + 1))()
    m = L.gb_bsel_dump(t, ks, cs, n + 1)
    return np.array(list(zip(ks[:m], cs[:m])), dtype=np.uint32).reshape(-1, 2)
L.gb_site_ptr.restype = C.c_void_p; L.gb_site2_ptr.restype = C.c_void_p; L.gb_site_load.argtypes = [C.c_void_p, C.c_void_p]
L.gb_mode_ptr.restype = C.c_void_p; L.gb_mode_load.argtypes = [C.c_void_p]
def modes(): return _arr(L.gb_mode_ptr(), ROMSZ, C.c_uint16)
def site(): return _arr(L.gb_site_ptr(), ROMSZ, C.c_uint32)
def site2(): return _arr(L.gb_site2_ptr(), ROMSZ, C.c_uint32)
def org_ram(): return _arr(L.gb_org_ram_ptr(), 0x10000, C.c_uint8)
def set_known(bitmap):
    b = np.ascontiguousarray(bitmap.astype(np.uint8)); L.gb_set_known(b.ctypes.data); return b
def wild(): return L.gb_wild()
def cov_save(path):
    np.savez_compressed(path, oex=org_exec().copy(), odr=org_dread().copy(), oram=org_ram().copy(), ex=cov_exec().copy(),
                        dr=cov_dread().copy(), rdr=cov_reader().copy(), ram=cov_ram().copy(),
                        bsel=np.array(bsel(0), dtype=np.uint32).reshape(-1, 4), bsel_org=np.array(bsel(1), dtype=np.uint32).reshape(-1, 4),
                        csite=bsel_raw(2), csite_org=bsel_raw(3), site=site().copy(), site2=site2().copy(), rmode=modes().copy())
def cov_restore(path):
    d = np.load(path)
    g_ = lambda k, alt: np.ascontiguousarray(d[k] if k in d.files else d[alt])
    ex = g_('ex', 'ex'); dr = g_('dr', 'dr'); rdr = g_('rdr', 'rdr'); ram = g_('ram', 'ram')
    L.gb_cov_load(ex.ctypes.data, dr.ctypes.data, rdr.ctypes.data, ram.ctypes.data)
    oex = g_('oex', 'ex'); odr = g_('odr', 'dr'); oram = g_('oram', 'ram')
    L.gb_org_load2(oex.ctypes.data, odr.ctypes.data, oram.ctypes.data)
    L.gb_bsel_clear()
    for wb, pc, nb, c in d['bsel']: L.gb_bsel_put(0, (int(wb) << 24) | (int(pc) << 8) | int(nb), int(c))
    bo = d['bsel_org'] if 'bsel_org' in d.files else d['bsel']
    for wb, pc, nb, c in bo: L.gb_bsel_put(1, (int(wb) << 24) | (int(pc) << 8) | int(nb), int(c))
    if 'rmode' in d.files:
        m_ = np.ascontiguousarray(d['rmode']); L.gb_mode_load(m_.ctypes.data)
    if 'site' in d.files:
        s1 = np.ascontiguousarray(d['site']); s2 = np.ascontiguousarray(d['site2']); L.gb_site_load(s1.ctypes.data, s2.ctypes.data)
    if 'csite' in d.files:
        for k, c in d['csite']: L.gb_bsel_put(2, int(k), int(c))
        for k, c in d['csite_org']: L.gb_bsel_put(3, int(k), int(c))
    return d['bsel']

# ---- display tracking / sound request accessors
L.gb_disp_ptr.restype = C.c_void_p; L.gb_disp_hits.restype = C.c_uint32; L.gb_disp_new.restype = C.c_uint32
L.gb_dispfr_ptr.restype = C.c_void_p; L.gb_dispfro_ptr.restype = C.c_void_p
L.gb_snd_ptr.restype = C.c_void_p; L.gb_snd_new.restype = C.c_uint32; L.gb_snd_pcb_ptr.restype = C.c_void_p
def disp(): return _arr(L.gb_disp_ptr(), ROMSZ, C.c_uint8)
def disp_fr(): return _arr(L.gb_dispfr_ptr(), ROMSZ, C.c_uint16)
def disp_fro(): return _arr(L.gb_dispfro_ptr(), ROMSZ, C.c_uint16)
def disp_new(): return L.gb_disp_new()
def disp_clear(): L.gb_disp_clear()
def snd(): return _arr(L.gb_snd_ptr(), 8 * 256, C.c_uint8).reshape(8, 256)
def snd_pcb(): return _arr(L.gb_snd_pcb_ptr(), 8 * 256, C.c_uint32).reshape(8, 256)
def snd_new(): return L.gb_snd_new()
def snd_clear(): L.gb_snd_clear()

# ---- forcing (README 16.26): jump the PC, flip a conditional branch, stop at a PC; read the state struct ----
L.gb_force_flip.argtypes = [C.c_uint32, C.c_int]; L.gb_force_hits.argtypes = [C.c_uint32]; L.gb_force_hits.restype = C.c_uint32
L.gb_jump.argtypes = [C.c_uint16, C.c_uint8, C.c_uint16]; L.gb_set_stop.argtypes = [C.c_int32]; L.gb_stop_hit.restype = C.c_int
L.gb_get_regs.argtypes = [C.c_void_p]; L.gb_set_regs.argtypes = [C.c_void_p]
def flat(bank, addr): return addr if addr < 0x4000 else (bank << 14) | (addr - 0x4000)
def force_flip(off, v=1): L.gb_force_flip(off, v)
def force_clear(): L.gb_force_clear()
def force_hits(off): return L.gb_force_hits(off)
def jump(pc, bank, ret): L.gb_jump(pc, bank, ret)
def set_stop(pc): L.gb_set_stop(-1 if pc is None else pc)
def stop_hit(): return L.gb_stop_hit()
def regs():
    r = (C.c_uint16 * 9)(); L.gb_get_regs(r); return dict(zip(('a', 'f', 'bc', 'de', 'hl', 'sp', 'pc', 'bank', 'ime'), r))
def set_regs(a, f, bc, de, hl, sp):
    r = (C.c_uint16 * 6)(a, f, bc, de, hl, sp); L.gb_set_regs(r)
class _State(C.Structure):          # mirror of struct GB in gbcov_display.c (same natural alignment); used to read VRAM / OAM and the VRAM provenance out of a snapshot
    _fields_ = [('a', C.c_uint8), ('f', C.c_uint8), ('b', C.c_uint8), ('c', C.c_uint8), ('d', C.c_uint8), ('e', C.c_uint8), ('h', C.c_uint8), ('l', C.c_uint8),
                ('sp', C.c_uint16), ('pc', C.c_uint16), ('ime', C.c_uint8), ('ei_delay', C.c_uint8), ('halted', C.c_uint8), ('stopped', C.c_uint8),
                ('cycles', C.c_uint64), ('vram', C.c_uint8 * 0x2000), ('wram', C.c_uint8 * 0x2000), ('oam', C.c_uint8 * 0xA0), ('hram', C.c_uint8 * 0x80),
                ('io', C.c_uint8 * 0x80), ('ie', C.c_uint8), ('sram', C.c_uint8 * 0x20000), ('cam', C.c_uint8 * 0x80),
                ('rombank', C.c_uint8), ('rambank', C.c_uint8), ('ramen', C.c_uint8), ('div', C.c_uint16), ('tima_acc', C.c_int32),
                ('line_cycle', C.c_int32), ('ly', C.c_uint8), ('stat_line', C.c_uint8), ('lcd_on', C.c_uint8), ('serial_cd', C.c_int32), ('serial_rx', C.c_uint8),
                ('cam_cd', C.c_int32), ('keys', C.c_uint8), ('p1sel', C.c_uint8), ('last_p1lines', C.c_uint8), ('frame', C.c_uint32), ('rng', C.c_uint32),
                ('pr_state', C.c_uint8), ('pr_len', C.c_uint16), ('pr_cnt', C.c_uint16), ('pr_cmd', C.c_uint8), ('pr_status', C.c_uint8), ('pr_busy', C.c_uint8), ('pr_sum', C.c_uint16),
                ('pr_rx_next', C.c_uint8), ('pr_attached', C.c_uint8), ('pr_bytes', C.c_uint32), ('pr_unproc', C.c_uint8), ('pr_printing', C.c_uint8), ('pr_n', C.c_uint16 * 16),
                ('t_vram', C.c_uint32 * 0x2000), ('t_wram', C.c_uint32 * 0x2000), ('t_hram', C.c_uint32 * 0x80), ('rv', C.c_uint8 * 8), ('rt', C.c_uint32 * 8), ('rp', C.c_uint8)]
def state(s=None):
    """snapshot as a _State copy (fields vram, oam, io, wram, t_vram = ROM flat offset + 1 of the source of each VRAM byte, 0 = none)"""
    s = s or snapshot(); assert len(s) >= C.sizeof(_State) - 8, (len(s), C.sizeof(_State))
    return _State.from_buffer_copy(s + bytes(max(0, C.sizeof(_State) - len(s))))

L.gb_wlog.argtypes = [C.c_void_p, C.c_int]; L.gb_wlog.restype = C.c_int
def wlog(maxn=8192):
    """writes (address, value) made between jump() and the return to the pushed address"""
    b = (C.c_uint32 * maxn)(); n = L.gb_wlog(b, maxn); return [(v >> 8, v & 0xFF) for v in b[:n]]
L.gb_step.argtypes = [C.c_int]
def step(n=1): L.gb_step(n)

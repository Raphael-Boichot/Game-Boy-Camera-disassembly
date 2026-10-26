; Game Boy Camera (USA, Europe), bank $1D. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01d", ROMX[$4000], BANK[$1d]

; I: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup, Mode1F_State0B_PageNoise
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1D_4000_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1d/Gfx_1D_4000_Mode1F_State08_EditPagesSetup.2bpp" ; $4000, 768 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup, Mode1F_State0B_PageNoise
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic
; runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1D_4300_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1d/Gfx_1D_4300_Mode1F_State08_EditPagesSetup.2bpp" ; $4300, 512 bytes
; I: far pointer loaded by Mode1F_State09_PageSound1 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 768
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1D_4500_Mode1F_State09_PageSound1::
    INCBIN "data/bank_1d/Gfx_1D_4500_Mode1F_State09_PageSound1.2bpp" ; $4500, 768 bytes
; C: far pointer loaded by Mode1F_State09_PageSound1 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1D_4800_Mode1F_State09_PageSound1::
    INCBIN "data/bank_1d/Gfx_1D_4800_Mode1F_State09_PageSound1.2bpp" ; $4800, 512 bytes
; I: far pointer loaded by Mode1F_State0A_PageSound2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 768
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise
; 1F:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_1D_4A00_Mode1F_State0A_PageSound2::
    INCBIN "data/bank_1d/Gfx_1D_4A00_Mode1F_State0A_PageSound2.2bpp" ; $4A00, 768 bytes
; C: far pointer loaded by Mode1F_State0A_PageSound2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise
; 1F:0A (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_1D_4D00_Mode1F_State0A_PageSound2::
    INCBIN "data/bank_1d/Gfx_1D_4D00_Mode1F_State0A_PageSound2.2bpp" ; $4D00, 512 bytes
; C: picture 3 of the shared result / error screen 09:7290 (table 09:7332, 0xE00 bytes: $9000 + $8800 + $8000 parts);
; played with tune 2A; seen in BGB (SHOOT parlor RUN)
Gfx_1D_4F00_ResultPic3_Equator_Tune2A::
    INCBIN "data/bank_1d/Gfx_1D_4F00_ResultPic3_Equator_Tune2A.2bpp" ; $4F00, 3584 bytes
; C: copied to VRAM/WRAM by Mode20_State02_GameSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Gfx_1D_5D00_Mode20_State02_GameSetup::
    db $00, $00, $00, $00, $03, $00, $0d, $03, $17, $0f, $1f, $0f, $2f, $1f, $3f, $1f
    db $60, $60, $78, $78, $7f, $7f, $7f, $7f, $3f, $3f, $0f, $0f, $03, $03, $01, $01
    db $03, $03, $0f, $0f, $ff, $ff, $ff, $ff, $fe, $fe, $f8, $f8, $c0, $c0, $e0, $e0
    db $f8, $f8, $7f, $7f, $3f, $3f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $e0, $e0, $f8, $f8, $fe, $fe, $ff, $ff, $3f, $3f, $07, $07
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $0f, $0f, $3f, $3f, $3f, $3f
    db $00, $00, $01, $01, $0f, $0f, $3f, $3f, $ff, $ff, $ff, $ff, $f8, $f8, $00, $00
    db $3f, $3f, $ff, $ff, $ff, $ff, $fe, $fe, $f8, $f8, $c0, $c0, $00, $00, $00, $00
    db $78, $78, $3c, $3c, $3e, $3e, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $07, $07
    db $00, $00, $07, $07, $1f, $1f, $3f, $3f, $7f, $7f, $fe, $fe, $fc, $fc, $f8, $f8
    db $fc, $fc, $3e, $3e, $1f, $1f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00
    db $1f, $1f, $3f, $3f, $7c, $7c, $70, $70, $41, $41, $03, $03, $07, $07, $0f, $0f
    db $e0, $e0, $80, $80, $00, $00, $00, $00, $00, $00, $60, $60, $78, $78, $7c, $7c
    db $ff, $ff, $3f, $3f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $fc, $ff, $ff, $ff, $ff, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $f8, $f8, $fe, $fe, $fe, $fe, $3e, $3e, $00, $00, $00, $00, $00, $00
    db $00, $00, $1f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $3f, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $80, $80, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $07, $00, $7f, $01, $e5, $1b, $bf, $79
    db $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $ff, $00, $ff, $c3, $ed, $f3
    db $00, $00, $00, $00, $00, $00, $07, $00, $ff, $01, $cf, $33, $ff, $33, $f7, $1b
    db $01, $00, $03, $00, $1f, $00, $ff, $0c, $f5, $ce, $af, $77, $ff, $33, $fe, $03
    db $7e, $00, $fd, $0e, $b5, $ce, $ff, $c6, $ff, $66, $fb, $e6, $ff, $e0, $ff, $36
    db $ff, $6d, $ff, $64, $ff, $60, $fb, $66, $fd, $66, $df, $3c, $7f, $00, $3c, $00
    db $7f, $b1, $ff, $99, $ff, $91, $f7, $f8, $bf, $dc, $bf, $c0, $7c, $80, $c0, $00
    db $f7, $19, $7e, $99, $ff, $99, $ff, $98, $e7, $f8, $fe, $00, $00, $00, $00, $00
    db $f7, $fb, $dd, $3b, $ff, $b0, $7c, $e0, $e0, $00, $00, $00, $00, $00, $00, $00
    db $df, $30, $f8, $00, $c0, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $fe, $ff, $c0, $ff, $c0, $ff, $c0
    db $ff, $00, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $c2
    db $ff, $00, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $fe
    db $ff, $00, $ff, $fe, $ff, $c0, $ff, $c0, $ff, $fe, $ff, $02, $ff, $02, $ff, $fe
    db $ff, $00, $ff, $fe, $ff, $c0, $ff, $c0, $ff, $fe, $ff, $c0, $ff, $c0, $ff, $fe
    db $ff, $00, $ff, $fe, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $fe
    db $ff, $00, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $fe
    db $ff, $00, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $fe, $ff, $c4, $ff, $c4, $ff, $c4
    db $ff, $00, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $fe, $ff, $c2, $ff, $c2, $ff, $c2
    db $ff, $00, $ff, $60, $ff, $60, $ff, $60, $ff, $6e, $ff, $60, $ff, $60, $ff, $60
    db $ff, $00, $ff, $c2, $ff, $e6, $ff, $7c, $ff, $38, $ff, $7c, $ff, $e6, $ff, $c2
    db $ff, $00, $ff, $6f, $ff, $63, $ff, $63, $ff, $63, $ff, $63, $ff, $63, $ff, $63
    db $e0, $00, $e0, $c0, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00, $e0, $00
    db $ff, $00, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $fe
    db $ff, $00, $ff, $c2, $ff, $c2, $ff, $c2, $ff, $fe, $ff, $18, $ff, $18, $ff, $18
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $78, $78, $78, $78, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $00, $00, $00, $00, $28, $08, $58, $08, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c
    db $00, $00, $00, $00, $78, $78, $78, $78, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c
    db $00, $00, $00, $00, $78, $78, $78, $78, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c
    db $00, $00, $00, $00, $68, $48, $58, $48, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $00, $00, $00, $00, $78, $78, $78, $78, $c8, $c0, $c4, $c0, $c8, $c0, $c4, $c0
    db $00, $00, $00, $00, $78, $78, $78, $78, $c8, $c0, $c4, $c0, $c8, $c0, $c4, $c0
    db $00, $00, $00, $00, $78, $78, $78, $78, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c
    db $00, $00, $00, $00, $78, $78, $78, $78, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $00, $00, $00, $00, $78, $78, $78, $78, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $00, $00, $00, $00, $28, $00, $50, $00, $88, $00, $44, $00, $88, $00, $44, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ec, $cc, $dc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $78, $78, $78, $78
    db $ac, $0c, $5c, $0c, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $28, $08, $58, $08
    db $f8, $78, $7c, $78, $c8, $c0, $c4, $c0, $c8, $c0, $c4, $c0, $78, $78, $78, $78
    db $fc, $7c, $7c, $7c, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $78, $78, $78, $78
    db $fc, $7c, $7c, $7c, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $28, $08, $58, $08
    db $f8, $78, $7c, $78, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $78, $78, $78, $78
    db $f8, $f8, $fc, $f8, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $78, $78, $78, $78
    db $ac, $0c, $5c, $0c, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $28, $08, $58, $08
    db $fc, $fc, $fc, $fc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $78, $78, $78, $78
    db $fc, $7c, $7c, $7c, $8c, $0c, $4c, $0c, $8c, $0c, $4c, $0c, $28, $08, $58, $08
    db $a8, $00, $54, $00, $88, $00, $44, $00, $88, $00, $44, $00, $28, $00, $50, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $03, $03, $07, $07, $0f, $0f, $0f, $0f, $1f, $1f
    db $07, $07, $07, $07, $07, $07, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $e0, $e0, $e0, $e0, $e0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $e0, $e0, $f0, $f0, $f0, $f0, $f8, $f8
    db $3f, $3f, $3f, $3f, $7f, $7f, $7f, $7f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $fc, $fc, $fc, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $7f, $7f, $3f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $fe, $fe, $fc, $fc
    db $3f, $3f, $9f, $9f, $cf, $cf, $e7, $e7, $f3, $f3, $70, $70, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $3f, $07, $07
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $fc, $e0, $e0
    db $fc, $fc, $f9, $f9, $f3, $f3, $e7, $e7, $cf, $cf, $0e, $0e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $03, $07, $07
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $78, $78, $3c, $3c
    db $07, $07, $0f, $0f, $0f, $0f, $1e, $1e, $1e, $1e, $3e, $3e, $3e, $3e, $7c, $7c
    db $bf, $bf, $1f, $1f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $1f, $1f, $7f, $7f, $ff, $ff
    db $7c, $7c, $fc, $fc, $fc, $fc, $f8, $f8, $fc, $fc, $fe, $fe, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $1e, $1e, $3c, $3c
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0
    db $fd, $fd, $f8, $f8, $f0, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $e0, $f0, $f0, $f0, $f0, $78, $78, $78, $78, $7c, $7c, $7c, $7c, $3e, $3e
    db $3e, $3e, $3f, $3f, $3f, $3f, $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $f8, $f8, $fe, $fe, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $78, $78, $7c, $7c
    db $00, $00, $00, $00, $00, $00, $01, $01, $03, $03, $07, $07, $0f, $0f, $1f, $1f
    db $1e, $1e, $3e, $3e, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c0, $c0, $80, $80
    db $3f, $3f, $1f, $1f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $03, $03, $0f, $0f, $1f, $1f, $00, $00, $00, $00, $00, $00
    db $1f, $1f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $80, $c0, $c0, $e0, $e0, $e0, $e0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $06, $06, $16, $16, $36, $36, $76, $76, $f6, $f6
    db $e6, $e6, $ce, $ce, $cf, $cf, $8f, $8f, $0f, $0f, $1f, $1f, $1f, $1f, $1f, $1f
    db $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $60, $60, $68, $68, $6c, $6c, $6e, $6e, $6f, $6f
    db $67, $67, $73, $73, $f3, $f3, $f1, $f1, $f0, $f0, $f8, $f8, $f8, $f8, $f8, $f8
    db $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $fc, $fc, $fe, $fe, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $1e, $1e, $3e, $3e
    db $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0
    db $fc, $fc, $f8, $f8, $f0, $f0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00
    db $78, $78, $7c, $7c, $3f, $3f, $1f, $1f, $0f, $0f, $07, $07, $03, $03, $01, $01
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8
    db $00, $00, $01, $01, $03, $03, $07, $07, $07, $07, $00, $00, $00, $00, $00, $00
    db $f8, $f8, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $c0, $c0, $f0, $f0, $f8, $f8, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $90, $00

; I: Spriter's Resource sheet "Menus - Shoot Menu", 46 tiles | also inside record 1 of page 0 of Parlor_PageTbl
; (1D:6B00 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_1D_6B10::
    INCBIN "data/bank_1d/Sheet_MenusShootMenu_1D_6B10.bin" ; $6B10, 513 bytes
; I: inside record 1 of page 0 (1D:6B00 +$0800 -> $9000, VRAM $9211 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1D_6D11_Parlor_Page0::
    db $00, $00, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $55
    db $55, $00, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $13
    db $13, $00, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $9c
    db $9c, $00, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $e0
    db $e0, $00, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $30
    db $88, $30, $88, $30, $88, $38, $87, $38, $80, $3f, $80, $3f, $80, $7f, $ff, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $8a
    db $8a, $8a, $8a, $8a, $8a, $8a, $8a, $72, $72, $00, $00, $00, $00, $00, $00, $a0
    db $a0, $60, $60, $60, $60, $20, $20, $20, $20, $00, $00, $00, $00, $00, $00, $44
    db $44, $6d, $6d, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $55, $e3
    db $e3, $14, $14, $14, $14, $14, $14, $f5, $f5, $14, $14, $14, $14, $14, $14, $e0
    db $1f, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $fc, $03, $ff, $00, $ff, $00, $9c
    db $9c, $49, $49, $49, $49, $09, $09, $c9, $c9, $49, $49, $49, $49, $49, $49, $e0
    db $e0, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $22
    db $22, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $72
    db $72, $8a, $8a, $82, $82, $82, $82, $73, $73, $0a, $0a, $0a, $0a, $8a, $8a, $27
    db $27, $28, $28, $28, $28, $28, $28, $e8, $e8, $28, $28, $28, $28, $28, $28, $1c
    db $1c, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $a2, $f8
    db $f8, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $1c
    db $1c, $22, $22, $22, $22, $20, $20, $20, $20, $20, $20, $22, $22, $22, $22, $8b
    db $8b, $8a, $8a, $8a, $8a, $8a, $8a, $fb, $fb, $8a, $8a, $8a, $8a, $8a, $8a, $e7
    db $e7, $08, $08, $08, $08, $08, $08, $c8, $c8, $08, $08, $08, $08, $08, $08, $22
    db $22, $a2, $a2, $a2, $a2, $24, $24, $28, $28, $34, $34, $a2, $a2, $a2, $a2, $72
    db $72, $00, $00, $00, $00, $00, $00, $ef, $ef, $42, $42, $42, $42, $42, $42, $27
    db $27, $00, $00, $00, $00, $00, $00, $be, $be, $20, $20, $20, $20, $20, $20, $1c
    db $1c, $00, $00, $00, $00, $00, $00, $89, $89, $da, $da, $aa, $aa, $aa, $aa, $20
    db $20, $00, $00, $00, $00, $00, $00, $c0, $c0, $20, $20, $00, $00, $00, $00, $1c
    db $1c, $00, $00, $00, $00, $00, $00, $3c, $3c, $22, $22, $22, $22, $22, $22, $ff
    db $03, $e0, $1f, $ff, $00, $ff, $03, $e0, $1f, $ff, $00, $ff, $01, $e0, $1f, $00
    db $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00
    db $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80, $00, $80, $80, $00, $8b
    db $8b, $00, $00, $00, $00, $00, $00, $8a, $8a, $8b, $8b, $8b, $8b, $8a, $8a, $e7
    db $e7, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $20, $20, $a0, $a0, $42
    db $42, $42, $42, $42, $42, $42, $42, $e2, $e2, $00, $00, $00, $00, $00, $00, $3c
    db $3c, $20, $20, $20, $20, $20, $20, $3e, $3e, $00, $00, $00, $00, $00, $00, $a9
    db $a9, $a8, $a8, $a8, $a8, $aa, $aa, $a9, $a9, $00, $00, $00, $00, $00, $00, $c0
    db $c0, $20, $20, $20, $20, $20, $20, $c0, $c0, $00, $00, $00, $00, $00, $00, $3c
    db $3c, $22, $22, $22, $22, $22, $22, $22, $22, $00, $00, $00, $00, $00, $00, $30
    db $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $e0
    db $1f, $ff, $00, $ff, $00, $e0, $1f, $ff, $00, $ff, $01, $e0, $1f, $ff, $00, $00
    db $02, $00, $02, $00, $fe, $00, $00, $ff, $00, $fc, $fe, $00, $02, $00, $02, $00
    db $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $3e
    db $3e, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $71
    db $71, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $9c
    db $9c, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $1c
    db $1c, $10, $10, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $9a
    db $9a, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $46
    db $82, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $c2
    db $c4, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $b9
    db $79, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $20
    db $30, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $fe
    db $fe, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $30
    db $88, $30, $88, $38, $87, $38, $80, $3f, $80, $3f, $87, $30, $88, $30, $88, $ff
    db $00, $ff, $00, $e0, $1f, $ff, $00, $ff, $00, $e0, $1f, $ff, $00, $ff, $00, $fc
    db $fe, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $00, $02, $ff
    db $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $ff, $00, $00, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $ff
    db $ff, $00, $00, $02, $02, $02, $02, $67, $67, $92, $92, $f2, $f2, $82, $82, $ff
    db $ff, $00, $00, $20, $20, $20, $20, $8e, $8e, $10, $10, $1e, $1e, $02, $02, $ff
    db $ff, $00, $00, $00, $00, $00, $00, $1c, $1c, $12, $12, $12, $12, $12, $12, $ff
    db $ff, $00, $00, $80, $80, $80, $80, $98, $98, $a4, $a4, $a4, $a4, $a4, $a4, $ff
    db $ff, $00, $00, $02, $02, $02, $02, $92, $92, $90, $92, $90, $90, $62, $62, $ff
    db $ff, $00, $00, $42, $42, $f2, $f2, $47, $47, $f2, $f2, $42, $42, $f4, $f2, $ff
    db $ff, $00, $00, $10, $10, $11, $11, $7c, $7c, $11, $11, $88, $88, $00, $81, $22
    db $22, $c0, $c0, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00, $00, $00, $00, $ff
    db $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3f
    db $87, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $00
    db $ff, $80, $ff, $f0, $7f, $1c, $0f, $00, $ff, $00, $00, $ff, $00, $ff, $00, $3c
    db $cf, $df, $33, $90, $e0, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $08
    db $ff, $f8, $00, $00, $ff, $fc, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $80
    db $7f, $ef, $00, $7c, $ff, $7f, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $06
    db $ff, $3d, $f9, $f1, $c0, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00
    db $ff, $00, $ff, $01, $ff, $07, $fe, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00, $30
    db $8f, $30, $8f, $38, $87, $3c, $83, $3e, $81, $3f, $80, $3f, $80, $3f, $80, $4f
    db $3f, $70, $ff, $d0, $3f, $10, $3f, $10, $3f, $10, $3f, $18, $3f, $2c, $f7, $00
    db $00, $78, $87, $03, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $f8
    db $00, $88, $ff, $8e, $81, $c0, $80, $c0, $80, $c0, $80, $c0, $80, $b8, $c0, $78
    db $ff, $07, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $02, $ff, $00
    db $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $01, $00, $00, $01, $01, $03, $06, $03, $0c, $07, $c8, $3f, $f0, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0c, $03, $44
    db $38, $00, $7c

    ; padding
    ds $1a, $00

; C: inside record 1 of page 0 (1D:6B00 +$0800 -> $9000, VRAM $974E onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1D_724E_Parlor_Page0::
    INCBIN "data/bank_1d/Gfx_1D_724E_Parlor_Page0.bin" ; $724E, 82 bytes
; C: Spriter's Resource sheet "Menus - Shoot Menu", 69 tiles | also inside record 1 of page 0 of Parlor_PageTbl
; (1D:6B00 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_1D_72A0::
    INCBIN "data/bank_1d/Sheet_MenusShootMenu_1D_72A0.bin" ; $72A0, 913 bytes
; C: inside record 2 of page 0 (1D:7300 +$0800 -> $8800, VRAM $8B31 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1D_7631_Parlor_Page0::
    db $ff, $00, $ff, $01, $ff, $03, $fe, $04, $fc, $0c, $f8, $09, $f9, $1a, $f2, $00
    db $ff, $07, $ff, $fa, $fd, $38, $30, $61, $40, $c3, $81, $03, $02, $06, $04, $78
    db $ff, $07, $ff, $80, $ff, $e0, $ff, $f0, $9f, $90, $1f, $39, $1f, $6e, $27, $f8
    db $00, $88, $ff, $8e, $81, $c0, $80, $c0, $80, $c0, $80, $c0, $80, $b8, $c0, $00
    db $00, $78, $87, $03, $fc, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $4f
    db $3f, $70, $ff, $d0, $3f, $10, $3f, $11, $3f, $11, $3f, $1f, $3f, $2e, $f4, $00
    db $ff, $1c, $ff, $2b, $f7, $e3, $e1, $f0, $20, $38, $10, $98, $08, $cc, $84, $00
    db $ff, $00, $ff, $f0, $ff, $98, $8f, $c4, $47, $66, $23, $12, $13, $0b, $09, $10
    db $f0, $10, $f0, $30, $e0, $30, $e0, $00, $ff, $00, $00, $ff, $00, $ff, $00, $08
    db $00, $00, $00, $01, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $4e
    db $47, $0b, $8b, $13, $12, $26, $22, $00, $ff, $00, $00, $ff, $00, $ff, $00, $80
    db $7f, $ef, $00, $7c, $ff, $7f, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $08
    db $ff, $f8, $00, $00, $ff, $fc, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $3e
    db $cc, $da, $3a, $99, $e9, $0c, $08, $00, $ff, $00, $00, $ff, $00, $ff, $00, $42
    db $40, $00, $20, $10, $00, $80, $80, $00, $ff, $00, $00, $ff, $00, $ff, $00, $01
    db $01, $01, $01, $01, $00, $01, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00
    db $00, $03, $03, $06, $05, $08, $0f, $19, $17, $12, $1f, $34, $2f, $20, $3f, $0e
    db $0e, $f5, $f1, $71, $ef, $c3, $bd, $87, $7a, $06, $fd, $0c, $fb, $10, $ef, $00
    db $00, $00, $00, $c0, $c0, $e0, $20, $20, $e0, $70, $b0, $d8, $68, $9c, $ec, $20
    db $3f, $60, $5f, $60, $5f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fe, $02, $fd, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $14
    db $fc, $24, $fc, $4c, $f4

    ; padding
    ds $10, $00

; C: inside record 2 of page 0 (1D:7300 +$0800 -> $8800, VRAM $8C96 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_1D_7796_Parlor_Page0::
    INCBIN "data/bank_1d/Gfx_1D_7796_Parlor_Page0.bin" ; $7796, 202 bytes
; C: 0x300 bytes from 7860 copied by Mode1F_State08_EditPagesSetup (copy site 05:45D9); the pieces 7940 / 79A0 / 7A00
; / 7A60 / 7AC0 inside it are also loaded one by one through the pointer table 04:539D | also inside record 2 of page
; 0 of Parlor_PageTbl (1D:7300 +$0800 -> $8800, C)
Gfx_1D_7860_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1d/Gfx_1D_7860_Mode1F_State08_EditPagesSetup.2bpp" ; $7860, 128 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 35 tiles | also inside record 2 of page 0 of
; Parlor_PageTbl (1D:7300 +$0800 -> $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus,
; modes 01 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousStampsJpn_1D_78E0::
    INCBIN "data/bank_1d/Sheet_MiscellaneousStampsJpn_1D_78E0.2bpp" ; $78E0, 96 bytes
; I: target 5 of the {lo,hi,bank} table 04:539D | also inside record 2 of page 0 of Parlor_PageTbl (1D:7300 +$0800 ->
; $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Src_1D_7940_Tbl539D_5::
    INCBIN "data/bank_1d/Src_1D_7940_Tbl539D_5.bin" ; $7940, 96 bytes
; I: target 0 of the {lo,hi,bank} table 04:539D | also inside record 2 of page 0 of Parlor_PageTbl (1D:7300 +$0800 ->
; $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01 11
; (tcrf_check/assets/l3_names/)
Src_1D_79A0_Tbl539D_0::
    INCBIN "data/bank_1d/Src_1D_79A0_Tbl539D_0.bin" ; $79A0, 96 bytes
; I: target 16 of the {lo,hi,bank} table 04:539D | also inside record 2 of page 0 of Parlor_PageTbl (1D:7300 +$0800 ->
; $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Src_1D_7A00_Tbl539D_16::
    INCBIN "data/bank_1d/Src_1D_7A00_Tbl539D_16.bin" ; $7A00, 96 bytes
; C: target 17 of the {lo,hi,bank} table 04:539D | also inside record 2 of page 0 of Parlor_PageTbl (1D:7300 +$0800 ->
; $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01 11
; (tcrf_check/assets/l3_names/)
Src_1D_7A60_Tbl539D_17::
    INCBIN "data/bank_1d/Src_1D_7A60_Tbl539D_17.bin" ; $7A60, 96 bytes
; I: target 23 of the {lo,hi,bank} table 04:539D | also inside record 2 of page 0 of Parlor_PageTbl (1D:7300 +$0800 ->
; $8800, C). L3 pass 2026-10-26: read in BGB in 90 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Src_1D_7AC0_Tbl539D_23::
    INCBIN "data/bank_1d/Src_1D_7AC0_Tbl539D_23.bin" ; $7AC0, 129 bytes
; I: tile data with no direct pointer in the code (, same bank/neighbour of Tbl539D); classified from its content -
; see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye; looks like an ennemy in Space fever.
Gfx_1D_7B41_Tbl539D_Aux::
    INCBIN "data/bank_1d/Gfx_1D_7B41_Tbl539D_Aux.bin" ; $7B41, 63 bytes
; I: target 29 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 01 11)
Src_1D_7B80_Tbl539D_29::
    INCBIN "data/bank_1d/Src_1D_7B80_Tbl539D_29.bin" ; $7B80, 186 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 48 tiles
Sheet_MiscellaneousStampsJpn_1D_7C3A::
    INCBIN "data/bank_1d/Sheet_MiscellaneousStampsJpn_1D_7C3A.bin" ; $7C3A, 6 bytes
; I: target 27 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 01 11 20)
Src_1D_7C40_Tbl539D_27::
    INCBIN "data/bank_1d/Src_1D_7C40_Tbl539D_27.bin" ; $7C40, 192 bytes
; C: target 33 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7D00_Tbl539D_33::
    INCBIN "data/bank_1d/Src_1D_7D00_Tbl539D_33.bin" ; $7D00, 96 bytes
; C: target 19 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7D60_Tbl539D_19::
    INCBIN "data/bank_1d/Src_1D_7D60_Tbl539D_19.bin" ; $7D60, 96 bytes
; C: target 31 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7DC0_Tbl539D_31::
    INCBIN "data/bank_1d/Src_1D_7DC0_Tbl539D_31.bin" ; $7DC0, 96 bytes
; I: target 21 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7E20_Tbl539D_21::
    INCBIN "data/bank_1d/Src_1D_7E20_Tbl539D_21.bin" ; $7E20, 96 bytes
; C: target 18 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7E80_Tbl539D_18::
    INCBIN "data/bank_1d/Src_1D_7E80_Tbl539D_18.bin" ; $7E80, 96 bytes
; I: target 25 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_1D_7EE0_Tbl539D_25::
    INCBIN "data/bank_1d/Src_1D_7EE0_Tbl539D_25.bin" ; $7EE0, 96 bytes
; I: target 20 of the {lo,hi,bank} table 04:539D. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB
; scenarios, core organic runs); C from the code: target 20 of the stamp-category icon table 04:539D
; (Stamp_CatIconSrcTbl2)
Src_1D_7F40_Tbl539D_20::
    db $07, $07, $18, $1f, $10, $1f, $0b, $0f, $7e, $7f, $07, $07, $1d, $1d, $21, $21
    db $80, $80, $60, $e0, $1e, $fe, $c1, $ff, $23, $ff, $fe, $fe, $0e, $1e, $59, $59
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $23, $23, $1f, $1f, $04, $04, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00
    db $d1, $d9, $82, $82, $0c, $0c, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $1f, $00, $3f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $15, $00

; C: far pointer loaded by Mode12_State08_ToolsMenu (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 20 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Map_1D_7FC0_Mode12_State08_ToolsMenu::
    INCBIN "data/bank_1d/Map_1D_7FC0_Mode12_State08_ToolsMenu.tilemap" ; $7FC0, 64 bytes

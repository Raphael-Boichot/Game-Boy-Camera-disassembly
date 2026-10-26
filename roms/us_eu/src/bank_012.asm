; Game Boy Camera (USA, Europe), bank $12. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $012", ROMX[$4000], BANK[$12]

; C: loaded by Mem_CopyFromBank at 03:76FD: Gfx $800 bytes to $9000 (this build's trace)
Gfx_12_4000_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_4000_Mode06_State00_Init.2bpp" ; $4000, 16 bytes
; I: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_4010_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_4010_Mode06_State00_Init.2bpp" ; $4010, 2032 bytes
; I: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_4800_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_4800_Mode06_State00_Init.2bpp" ; $4800, 176 bytes
; I: far pointer loaded by LinkMenu_LoadTilesSelected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 1B (tcrf_check/assets/l3_names/)
Gfx_12_48B0_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_48B0_LinkMenu_LoadTilesSelected.2bpp" ; $48B0, 224 bytes
; C: loaded by Vram_CopyFromBank at 03:7902: Gfx $A0 bytes to $8990 (this build's trace)
Gfx_12_4990_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_4990_LinkMenu_LoadTilesDeselected.2bpp" ; $4990, 16 bytes
; I: far pointer loaded by LinkMenu_LoadTilesDeselected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 0E (tcrf_check/assets/l3_names/)
Gfx_12_49A0_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_49A0_LinkMenu_LoadTilesDeselected.2bpp" ; $49A0, 144 bytes
; C: loaded by Vram_CopyFromBank at 03:78EB: Gfx $E0 bytes to $8A30 (this build's trace)
Gfx_12_4A30_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_4A30_LinkMenu_LoadTilesSelected.2bpp" ; $4A30, 16 bytes
; I: far pointer loaded by LinkMenu_LoadTilesDeselected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 1B (tcrf_check/assets/l3_names/)
Gfx_12_4A40_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_4A40_LinkMenu_LoadTilesDeselected.2bpp" ; $4A40, 208 bytes
; C: loaded by Vram_CopyFromBank at 03:78DB: Gfx $A0 bytes to $8990 (this build's trace)
Gfx_12_4B10_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_4B10_LinkMenu_LoadTilesSelected.2bpp" ; $4B10, 32 bytes
; I: far pointer loaded by LinkMenu_LoadTilesSelected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 0E (tcrf_check/assets/l3_names/)
Gfx_12_4B30_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_4B30_LinkMenu_LoadTilesSelected.2bpp" ; $4B30, 128 bytes
; C: loaded by Vram_CopyFromBank at 03:7912: Gfx $20 bytes to $8A30 (this build's trace)
Gfx_12_4BB0_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_4BB0_LinkMenu_LoadTilesDeselected.2bpp" ; $4BB0, 656 bytes
; C: loaded by Vram_CopyFromBank at 03:7920: Gfx $C0 bytes to $8A50 (this build's trace)
Gfx_12_4E40_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_4E40_LinkMenu_LoadTilesDeselected.2bpp" ; $4E40, 448 bytes
; C: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_5000_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_5000_Mode06_State00_Init.2bpp" ; $5000, 2048 bytes
; I: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_5800_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_5800_Mode21_State00_Init.2bpp" ; $5800, 2048 bytes
; I: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_6000_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_6000_Mode21_State00_Init.2bpp" ; $6000, 2048 bytes
; I: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_6800_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_6800_Mode21_State00_Init.2bpp" ; $6800, 2048 bytes
; I: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Gfx_12_7000_Mode03_State00_Init::
    INCBIN "data/bank_12/Gfx_12_7000_Mode03_State00_Init.2bpp" ; $7000, 2048 bytes
; I: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Gfx_12_7800_Mode03_State00_Init::
    db $10, $1f, $10, $1f, $0f, $0f, $03, $07, $1f, $0f, $1f, $1f, $1f, $3f, $7f, $3f
    db $0b, $f1, $2f, $ce, $70, $bf, $c0, $7f, $80, $ff, $06, $f9, $06, $f9, $00, $ff
    db $ac, $df, $f0, $bf, $c0, $7f, $80, $ff, $01, $fe, $f3, $fd, $fe, $0f, $13, $e3
    db $00, $ff, $f0, $ff, $91, $ff, $c7, $7e, $ff, $39, $bf, $7f, $c3, $fc, $f8, $07
    db $0c, $07, $47, $87, $8a, $17, $3d, $1e, $7f, $fc, $bb, $c4, $fd, $03, $f6, $0f
    db $70, $20, $b8, $11, $00, $98, $ba, $dc, $7e, $f3, $27, $f7, $1f, $ff, $0f, $fe
    db $01, $ff, $35, $01, $c1, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $1b, $f1, $f3, $22, $32, $e3, $32, $e3, $32, $e3, $32, $e3, $32, $e3, $32, $e3
    db $80, $ff, $8a, $00, $00, $ff, $00, $ff, $00, $ff, $15, $ff, $15, $ff, $15, $ff
    db $31, $20, $5f, $61, $46, $43, $46, $43, $46, $43, $c6, $43, $c2, $c7, $62, $c7
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $ff, $01, $ff, $00, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $01, $0e, $07, $08, $0f
    db $9c, $08, $18, $10, $40, $00, $ff, $63, $fd, $9e, $e4, $7c, $b8, $7c, $fe, $ff
    db $40, $e0, $80, $e0, $e0, $40, $fd, $fe, $3b, $e7, $3f, $e1, $5f, $e1, $7b, $c7
    db $49, $64, $35, $27, $5b, $36, $ff, $ff, $c0, $ff, $00, $ff, $00, $ff, $00, $ff
    db $d8, $f6, $76, $3e, $96, $1b, $17, $03, $0f, $07, $08, $0f, $88, $0f, $88, $0f
    db $0d, $0b, $ed, $cb, $6f, $ff, $90, $f8, $30, $f0, $50, $f3, $81, $b0, $b0, $23
    db $00, $00, $07, $03, $1f, $0c, $fb, $f1, $60, $c7, $18, $8f, $60, $3f, $81, $ff
    db $20, $60, $e0, $c0, $80, $c0, $ff, $ff, $00, $ff, $51, $ff, $a3, $fe, $4c, $f8
    db $20, $30, $3f, $1f, $1c, $1f, $3f, $61, $c6, $83, $07, $0d, $32, $1f, $25, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $04, $03, $0a, $04, $08, $18
    db $f1, $1f, $08, $1f, $18, $0f, $fc, $3f, $c4, $ff, $0e, $ff, $1b, $f1, $ef, $e6
    db $2e, $15, $17, $1e, $12, $8c, $0c, $80, $fd, $fc, $fd, $f9, $fb, $f1, $f2, $e1
    db $80, $00, $00, $80, $e1, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $4f, $9f, $84, $4f
    db $01, $03, $03, $03, $81, $c3, $a0, $61, $f8, $10, $f8, $c8, $b0, $6c, $2c, $14
    db $00, $00, $00, $00, $03, $01, $03, $06, $0f, $04, $02, $0d, $0d, $0b, $0d, $0b
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0f, $00, $3f, $1f
    db $8b, $29, $89, $2b, $9b, $33, $d1, $e7, $6f, $05, $9d, $0b, $9c, $fe, $60, $fe
    db $7a, $03, $b8, $fb, $e1, $2d, $84, $66, $6b, $c6, $4b, $89, $8a, $91, $97, $13
    db $01, $03, $03, $01, $37, $01, $fd, $7f, $ca, $87, $81, $03, $01, $01, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $01, $01, $03, $01
    db $78, $fc, $07, $fe, $01, $ff, $f0, $ff, $ec, $1f, $fa, $e7, $aa, $13, $09, $ab
    db $00, $00, $1f, $01, $5b, $3f, $e2, $4d, $c6, $ac, $85, $6c, $cf, $a9, $fb, $72
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $00, $01, $01, $02, $03, $03, $02
    db $00, $00, $00, $00, $01, $01, $0f, $0f, $ff, $ff, $fc, $fc, $00, $00, $00, $00
    db $f0, $f0, $f0, $f0, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $cf, $cf, $8f, $8f, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $b3, $b3, $b3, $b3, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $cd, $cd, $8d, $8d, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $3f, $3f, $1f, $1f, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $ff, $ff, $7e, $7e, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $60, $60, $70, $70, $38, $38, $1f, $1f, $0f, $0f, $03, $03, $00, $00, $00, $00
    db $f0, $f0, $f0, $f0, $00, $00, $00, $00, $e0, $e0, $e0, $e0, $00, $00, $00, $00
    db $8f, $8f, $cf, $cf, $cc, $cc, $0c, $0c, $8f, $8f, $cf, $cf, $cc, $cc, $cc, $cc
    db $1f, $1f, $3f, $3f, $30, $30, $30, $30, $3f, $3f, $1f, $1f, $00, $00, $30, $30
    db $7e, $7e, $ff, $ff, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3
    db $f8, $f8, $fc, $fc, $0c, $0c, $0c, $0c, $fc, $fc, $f8, $f8, $00, $00, $00, $00
    db $e3, $e3, $f3, $f3, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $b3, $b3
    db $87, $87, $cf, $cf, $cd, $cd, $cd, $cd, $cd, $cd, $cd, $cd, $cd, $cd, $cd, $cd
    db $1f, $1f, $3f, $3f, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $7e, $7e, $ff, $ff, $c3, $c3, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c3, $c3
    db $70, $70, $60, $60, $e0, $e0, $e0, $e0, $c0, $c0, $c0, $c0, $c0, $c0, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $c0, $c0, $c0, $c0, $c0, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $c0, $c0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $fc, $fc, $ff, $ff, $0f, $0f, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $0f, $0f, $1f, $1f, $38, $38
    db $00, $ff, $01, $ff, $0f, $ff, $ff, $ff, $fc, $fc, $00, $00, $00, $00, $00, $00
    db $30, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $f8, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $8c, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $1f, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $06, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $3f, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $86, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $01, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $70, $7f, $38, $3f, $1f, $1f, $0f, $0f, $03, $03, $00, $00, $00, $00, $00, $00
    db $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $fe, $ff, $30, $ff, $30, $ff, $30, $ff, $30, $ff, $30, $ff, $30, $ff, $30, $ff
    db $fd, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $0c, $ff, $fc, $ff
    db $f3, $ff, $33, $ff, $33, $ff, $f3, $ff, $e3, $ff, $03, $ff, $03, $ff, $03, $ff
    db $cf, $ff, $cc, $ff, $0c, $ff, $8f, $ff, $cf, $ff, $cc, $ff, $cc, $ff, $cc, $ff
    db $3f, $ff, $30, $ff, $30, $ff, $3f, $ff, $1f, $ff, $00, $ff, $30, $ff, $3f, $ff
    db $c0, $ff, $00, $ff, $00, $ff, $0f, $ff, $0f, $ff, $00, $ff, $00, $ff, $00, $ff
    db $bf, $ff, $86, $ff, $86, $ff, $86, $ff, $86, $ff, $86, $ff, $86, $ff, $86, $ff
    db $7f, $ff, $61, $ff, $61, $ff, $61, $ff, $61, $ff, $61, $ff, $61, $ff, $7f, $ff
    db $86, $ff, $86, $ff, $86, $ff, $fe, $ff, $fe, $ff, $86, $ff, $86, $ff, $86, $ff
    db $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff
    db $60, $7f, $e0, $ff, $e0, $ff, $c0, $ff, $c0, $ff, $c0, $ff, $e0, $ff, $60, $7f
    db $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1f, $1f, $7f, $7f, $ff, $ff, $e0, $e0, $c0, $c0, $c0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $ff, $ff, $0f, $ff, $01, $ff, $00, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $fe, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $f9, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $e1, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $8f, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $1f, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $c0, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $3f, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $86, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $01, $ff
    db $00, $00, $00, $00, $00, $00, $03, $03, $0f, $0f, $1f, $1f, $38, $3f, $70, $7f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
    db $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
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

    ; padding
    ds $80, $00

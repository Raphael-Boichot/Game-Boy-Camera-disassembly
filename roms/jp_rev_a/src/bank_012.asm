; Pocket Camera (Japan) (Rev A), bank $12. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $012", ROMX[$4000], BANK[$12]

; C: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_4000_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_4000_Mode06_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_4800_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_4800_Mode06_State00_Init.2bpp" ; $4800, 176 bytes
; C: far pointer loaded by LinkMenu_LoadTilesSelected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 1B (tcrf_check/assets/l3_names/)
Gfx_12_48B0_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_48B0_LinkMenu_LoadTilesSelected.2bpp" ; $48B0, 240 bytes
; C: far pointer loaded by LinkMenu_LoadTilesDeselected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 0E (tcrf_check/assets/l3_names/)
Gfx_12_49A0_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_49A0_LinkMenu_LoadTilesDeselected.2bpp" ; $49A0, 160 bytes
; C: far pointer loaded by LinkMenu_LoadTilesDeselected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 1B (tcrf_check/assets/l3_names/)
Gfx_12_4A40_LinkMenu_LoadTilesDeselected::
    INCBIN "data/bank_12/Gfx_12_4A40_LinkMenu_LoadTilesDeselected.2bpp" ; $4A40, 240 bytes
; C: far pointer loaded by LinkMenu_LoadTilesSelected (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06 0E (tcrf_check/assets/l3_names/)
Gfx_12_4B30_LinkMenu_LoadTilesSelected::
    INCBIN "data/bank_12/Gfx_12_4B30_LinkMenu_LoadTilesSelected.2bpp" ; $4B30, 1232 bytes
; C: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Gfx_12_5000_Mode06_State00_Init::
    INCBIN "data/bank_12/Gfx_12_5000_Mode06_State00_Init.2bpp" ; $5000, 2048 bytes
; C: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_5800_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_5800_Mode21_State00_Init.2bpp" ; $5800, 2048 bytes
; C: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_6000_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_6000_Mode21_State00_Init.2bpp" ; $6000, 2048 bytes
; C: copied to VRAM/WRAM by Mode21_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 21)
Gfx_12_6800_Mode21_State00_Init::
    INCBIN "data/bank_12/Gfx_12_6800_Mode21_State00_Init.2bpp" ; $6800, 2048 bytes
; C: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Gfx_12_7000_Mode03_State00_Init::
    INCBIN "data/bank_12/Gfx_12_7000_Mode03_State00_Init.2bpp" ; $7000, 2048 bytes
; C: copied to VRAM/WRAM by Mode03_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 03 (tcrf_check/assets/l3_names/)
Gfx_12_7800_Mode03_State00_Init::
    db $ff, $ff, $7b, $39, $7b, $39, $7b, $39, $00, $00, $7b, $00, $7b, $39, $7b, $39
    db $7f, $7f, $bf, $3f, $ff, $ff, $3f, $1f, $de, $0e, $ef, $ce, $ef, $cf, $ef, $cf
    db $7e, $3c, $7f, $3e, $ff, $ff, $fc, $f8, $fb, $f0, $f7, $f3, $ff, $ff, $ff, $ff
    db $fb, $f9, $fb, $f9, $03, $01, $fd, $01, $fb, $f9, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $0f, $cf, $0f, $cf, $0f, $cf, $cf, $cf, $0f, $0f, $0f, $0f, $0f, $0f, $cf, $cf
    db $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $c0, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff
    db $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $3f, $ff, $83, $ff, $fc, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff, $3f, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $07, $07, $07, $07, $e7, $e7, $e7, $e7
    db $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $00, $ff, $00, $ff, $7f, $ff, $7f, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $c0, $c0, $c0, $c0, $cf, $cf, $cf, $cf
    db $fc, $fc, $fc, $fc, $fc, $fc, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $f3, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $cf, $cf, $cf, $cf, $cf, $cf, $c0, $c0, $c0, $c0, $ff, $ff, $ff, $ff, $ff, $ff
    db $3c, $3c, $3c, $3c, $7c, $3c, $3c, $7c, $fc, $7c, $fc, $fc, $fc, $fc, $fc, $fc
    db $98, $07, $bf, $ff, $fe, $ff, $ff, $fe, $fe, $fc, $fd, $f8, $eb, $f1, $f3, $e7
    db $b3, $3f, $1b, $b3, $b7, $93, $23, $d7, $e7, $e7, $87, $cf, $8f, $1f, $7f, $3f
    db $99, $3f, $b8, $3d, $be, $3c, $3c, $3e, $7e, $3f, $3f, $7f, $ff, $7f, $fe, $fe
    db $df, $cf, $df, $cf, $ef, $cf, $ef, $cf, $fe, $cf, $fe, $fe, $f4, $f8, $f2, $f9
    db $7f, $ff, $3f, $1f, $4b, $87, $f2, $e1, $fd, $f9, $ff, $ff, $ff, $ff, $ff, $ff
    db $ce, $1c, $9e, $cc, $ce, $9c, $3e, $9c, $7e, $3c, $fe, $7c, $fe, $fc, $fe, $fc
    db $c3, $e0, $e7, $cf, $9f, $cf, $df, $ff, $fe, $ff, $fe, $fc, $fd, $f8, $fb, $f1
    db $d3, $e1, $0b, $07, $df, $3f, $ff, $ff, $ff, $ff, $fa, $fd, $70, $01, $fb, $07
    db $0d, $cc, $cc, $cc, $0c, $0c, $0d, $0c, $0d, $0c, $cc, $cc, $ce, $cc, $cf, $ce
    db $00, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $c0, $ff, $c7, $ff, $00, $00, $00, $00, $00, $00, $c7, $ff, $c7, $ff, $c7, $ff
    db $ff, $ff, $00, $00, $00, $00, $fc, $fc, $fc, $fc, $8c, $dc, $ac, $ac, $5c, $1c
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $ff, $a0, $c0
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $5f, $bf, $9f, $3f
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $cf, $df, $cf
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fc, $3e, $1c
    db $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $eb, $f7, $f6, $e0
    db $7f, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $f1, $fb, $f1, $f5, $e1, $fb
    db $fe, $ff, $c0, $c0, $c0, $c0, $cf, $cf, $cf, $cf, $cf, $cf, $0f, $cc, $0d, $cc
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff
    db $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c0, $ff, $c0, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $7f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff, $c7, $ff
    db $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8, $f8
    db $fe, $ff, $c0, $c0, $c0, $c0, $c0, $cf, $c0, $cf, $c0, $cf, $00, $cc, $00, $cc
    db $7f, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $0a, $f1, $04, $f1, $1a, $e1
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $14, $e3, $00, $e0
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $1c
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $cf, $00, $cf
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $a0, $1f, $20, $1f
    db $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $07, $f8, $40, $80
    db $ff, $ff, $00, $00, $00, $00, $00, $fc, $00, $fc, $50, $8c, $00, $ac, $00, $1c
    db $00, $cc, $c0, $cc, $00, $0c, $00, $0c, $00, $0c, $c0, $cc, $c0, $cc, $c0, $ce
    db $20, $c1, $04, $03, $20, $1f, $00, $ff, $00, $ff, $05, $f8, $01, $00, $04, $03
    db $20, $c0, $08, $c7, $40, $8f, $20, $df, $01, $fe, $00, $fc, $00, $f8, $00, $f1
    db $10, $0c, $40, $8c, $10, $8c, $80, $1c, $00, $3c, $00, $7c, $00, $fc, $00, $fc
    db $80, $7f, $00, $1f, $84, $03, $01, $e0, $00, $f9, $00, $ff, $00, $ff, $00, $ff
    db $00, $cf, $00, $cf, $00, $cf, $00, $cf, $01, $ce, $00, $fe, $08, $f0, $09, $f0
    db $26, $19, $05, $38, $00, $3c, $02, $3c, $01, $3e, $40, $3f, $00, $7f, $00, $fe
    db $0c, $33, $a0, $13, $00, $93, $d4, $03, $00, $e7, $48, $87, $10, $0f, $00, $3f
    db $07, $00, $40, $bf, $01, $fe, $00, $fe, $00, $fc, $00, $f8, $10, $e1, $04, $e3
    db $00, $3c, $00, $3c, $00, $3c, $40, $3c, $00, $7c, $00, $fc, $00, $fc, $00, $fc
    db $c0, $cf, $c0, $cf, $c0, $cf, $c0, $c0, $c0, $c0, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $0c, $f3, $00, $ff, $00, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $01, $fe, $00, $ff, $00, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $80, $7f, $00, $ff, $00, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $fc, $00, $fc, $00, $fc, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $c0, $c0, $c0, $c0, $c0, $cf, $c0, $cf
    db $00, $ff, $00, $ff, $7f, $ff, $7f, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $07, $07, $07, $07, $07, $e7, $07, $e7
    db $00, $cf, $00, $cf, $00, $cf, $c0, $cf, $00, $0f, $00, $0f, $00, $0f, $c0, $cf
    db $00, $ff, $00, $ff, $00, $fe, $00, $fe, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $f9, $00, $f9, $00, $01, $00, $01, $00, $f9, $00, $ff, $00, $ff, $00, $ff
    db $00, $3c, $00, $3e, $00, $ff, $00, $f8, $00, $f0, $00, $f3, $00, $ff, $00, $ff
    db $00, $7f, $00, $3f, $00, $ff, $00, $1f, $00, $0e, $00, $ce, $00, $cf, $00, $cf
    db $00, $ff, $00, $39, $00, $39, $00, $39, $00, $00, $00, $00, $00, $39, $00, $39
    db $00, $ff, $00, $ff, $00, $ff, $00, $e7, $00, $e7, $00, $e7, $00, $e7, $00, $e7
    db $00, $ff, $00, $ff, $00, $ff, $00, $e7, $00, $e3, $00, $f3, $00, $f3, $08, $f3
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $07, $e7, $07, $e7, $07, $e7, $07, $e7, $07, $e7, $07, $e7, $07, $e7, $07, $e7
    db $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $cf, $c0, $c0, $c0, $c0
    db $00, $ff, $01, $fe, $00, $fe, $01, $fe, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $ff, $80, $7f, $00, $01, $02, $01, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $fe, $00, $fe, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $cf, $50, $8f, $00, $1f, $40, $3f, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $39, $00, $3f, $00, $00, $81, $00, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $f3, $00, $f0, $00, $f9, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00
    db $07, $e7, $07, $e7, $00, $e7, $00, $e7, $07, $e7, $07, $e7, $07, $07, $07, $07
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $ff, $fd, $ff, $fd, $ff, $fd, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ff, $f7, $ff, $f6, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $ff, $df, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $cf, $ff, $37, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $ff, $36, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $f7, $ff, $f7, $ff
    db $ff, $ff, $ff, $ff, $ff, $fd, $ff, $fd, $ff, $fd, $ff, $fd, $ff, $fc, $ff, $fd
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $ff, $f7, $ff, $f6, $ff, $06, $ff, $f6
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $ff, $df, $ff, $df, $ff, $df
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $cf, $ff, $37, $ff, $77, $ff, $77
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c7, $ff, $36, $ff, $77, $ff, $77
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $f7, $ff, $f7, $ff, $6f, $ff, $8f
    db $ff, $ff, $ff, $ff, $ff, $1f, $ff, $ef, $ff, $ef, $ff, $ef, $ff, $ef, $ff, $9f
    db $ff, $fd, $ff, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $f6, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $0e, $ff, $ee, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $0e, $ff, $fe, $ff, $fc, $ff, $fd, $ff, $fd, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $0f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $df, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $bf, $ff, $ff, $ff, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $80, $00

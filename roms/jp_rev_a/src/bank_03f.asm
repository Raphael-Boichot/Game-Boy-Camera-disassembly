; Pocket Camera (Japan) (Rev A), bank $3F. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03f", ROMX[$4000], BANK[$3f]

; C: entry 4 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3F_4000_TitleScene::
    INCBIN "data/bank_3f/Gfx_3F_4000_TitleScene.2bpp" ; $4000, 3584 bytes
; C: entry 5 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3F_4E00_TitleScene::
    INCBIN "data/bank_3f/Gfx_3F_4E00_TitleScene.2bpp" ; $4E00, 3584 bytes
; C: entry 6 of the {lo,hi,bank} table 08:74DC, 3584 bytes each (constant pitch)
Gfx_3F_5C00_TitleScene::
    INCBIN "data/bank_3f/Gfx_3F_5C00_TitleScene.2bpp" ; $5C00, 3584 bytes
; C: copied to VRAM/WRAM by Mode19_State01_TitleFirst, Mode19_State02_TitleFromMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic corpus, modes
; 19 (tcrf_check/assets/l3_names/)
Gfx_3F_6A00_Mode19_State01_TitleFirst::
    INCBIN "data/bank_3f/Gfx_3F_6A00_Mode19_State01_TitleFirst.2bpp" ; $6A00, 1792 bytes
; C: copied to VRAM/WRAM by Mode19_State01_TitleFirst, Mode19_State02_TitleFromMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic corpus, modes
; 19 (tcrf_check/assets/l3_names/)
Gfx_3F_7100_Mode19_State01_TitleFirst::
    INCBIN "data/bank_3f/Gfx_3F_7100_Mode19_State01_TitleFirst.2bpp" ; $7100, 384 bytes
; C: copied to VRAM/WRAM by Mode19_State00_CopyrightScreens, Mode19_State01_TitleFirst, Mode19_State02_TitleFromMenu
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic corpus, modes
; 19 (tcrf_check/assets/l3_names/)
Map_3F_7280_Mode19_State00_CopyrightScreens::
    db $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf, $d0, $d1, $d2, $d3, $00, $01, $02, $03, $02, $01, $00, $04, $05, $06, $05, $04
    db $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $b4, $b5, $b6, $b7, $06, $05, $05, $05, $05, $05, $06, $05, $05, $05, $05, $05
    db $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $b8, $b9, $ba, $bb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $b0, $b1, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $bc, $bd, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $b2, $b3, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $be, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d4, $d5, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $d6, $d7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d8, $d9, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $da, $db, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $dc, $dd, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $de, $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $e1, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $e2, $e3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e4, $e5, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $e6, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e8, $e9, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $ea, $eb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ec, $ed, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $ee, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $f1, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $f2, $f3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f4, $f5, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $f6, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $f9, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $fd, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $50, $51, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $52, $53, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $60, $61, $62, $63, $64, $65, $66, $67, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $80, $00

; C: copied to VRAM/WRAM by Mode0C_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0C)
Gfx_3F_7700_Mode0C_State02_Setup::
    db $ff, $00, $ff, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $80, $7f, $80, $7f, $80
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $c0, $00, $bf, $00, $af, $1f, $af, $18
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $0f, $00, $f7, $0c, $fb, $e6, $eb, $06
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $cf, $00, $af, $18, $af, $18, $af, $18
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $c0, $00, $bf, $00, $6f, $1f, $5f, $30
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $1c, $00, $fb, $10, $ff, $e3, $ff, $00
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $01, $00, $ff, $01, $af, $9e, $af, $18
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $e0, $00, $df, $00, $d7, $0f, $d7, $0c
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $07, $00, $fb, $06, $fd, $f3, $f5, $03
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $e7, $00, $d7, $0c, $d7, $0c, $d7, $0c
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $ff, $00, $ff, $00
    db $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $ff, $00, $ff, $00, $ff, $00
    db $a0, $00, $bf, $00, $af, $1f, $af, $18, $af, $18, $ff, $30, $ff, $00, $ff, $00
    db $1b, $06, $f7, $0c, $ff, $f8, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $af, $18, $af, $18, $af, $18, $af, $18, $af, $18, $ff, $30, $ff, $00, $ff, $00
    db $5f, $30, $5f, $30, $5f, $30, $60, $00, $ff, $40, $ff, $3f, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $1f, $00, $ff, $10, $ff, $e0, $ff, $00, $ff, $00
    db $d0, $00, $df, $00, $d7, $0f, $d7, $0c, $d7, $0c, $ff, $18, $ff, $00, $ff, $00
    db $0d, $03, $fb, $06, $f7, $ec, $eb, $06, $f5, $03, $ff, $06, $ff, $00, $ff, $00
    db $d7, $0c, $d7, $0c, $d7, $0c, $d7, $0c, $d7, $0c, $ff, $18, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $fe, $00, $fe, $00
    db $fe, $00, $fe, $00, $fe, $00, $fe, $00, $fe, $00, $ff, $00, $ff, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $410, $00

; C: copied to VRAM/WRAM by Mode0C_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0C)
Map_3F_7D00_Mode0C_State02_Setup::
    db $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $e1, $ff, $ff, $ff, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1a, $1b, $1c, $1d, $1e, $1f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2a, $2b, $2c, $2d, $2e, $2f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3a, $3b, $3c, $3d, $3e, $3f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4a, $4b, $4c, $4d, $4e, $4f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $50, $51, $52, $53, $54, $55, $56, $57, $58, $59, $5a, $5b, $5c, $5d, $5e, $5f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $60, $61, $62, $63, $64, $65, $66, $67, $68, $69, $6a, $6b, $6c, $6d, $6e, $6f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79, $7a, $7b, $7c, $7d, $7e, $7f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8a, $8b, $8c, $8d, $8e, $8f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $a0, $a1, $a2, $a3, $a4, $a5, $a6, $a7, $a8, $a9, $aa, $ab, $ac, $ad, $ae, $af, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $b0, $b1, $b2, $b3, $b4, $b5, $b6, $b7, $b8, $b9, $ba, $bb, $bc, $bd, $be, $bf, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $c0, $c1, $c2, $c3, $c4, $c5, $c6, $c7, $c8, $c9, $ca, $cb, $cc, $cd, $ce, $cf, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e2, $e2, $d0, $d1, $d2, $d3, $d4, $d5, $d6, $d7, $d8, $d9, $da, $db, $dc, $dd, $de, $df, $e2, $e2, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e3, $e3, $e3, $e4, $e5, $e6, $e7, $e8, $e9, $ea, $eb, $ec, $ed, $e5, $e6, $ee, $fa, $e3, $e3, $e3, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ef, $ef, $ef, $f0, $f1, $f2, $f3, $f4, $f5, $f3, $f6, $f7, $f8, $f1, $f2, $f9, $fb, $ef, $ef, $ef, $ff, $ff, $ff, $0f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $c0, $00

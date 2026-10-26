; Pocket Camera (Japan) (Rev A), bank $1E. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01e", ROMX[$4000], BANK[$1e]

; C: picture 2 of the shared result / error screen 09:7290 (table 09:7332, 0xE00 bytes: $9000 + $8800 + $8000 parts);
; played with tune n_Tune30; seen in BGB (SHOOT parlor RUN)
Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30::
    INCBIN "data/bank_1e/Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30.2bpp" ; $4000, 3584 bytes
; C: picture 0 of the shared result / error screen 09:7290 (table 09:7332, 0xE00 bytes: $9000 + $8800 + $8000 parts);
; played with tune n_Tune28; seen in BGB (SHOOT parlor RUN)
Gfx_1E_4E00_ResultPic0_HornedMan_Tune28::
    INCBIN "data/bank_1e/Gfx_1E_4E00_ResultPic0_HornedMan_Tune28.2bpp" ; $4E00, 3584 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Gfx_1E_5C00_Mode17_State00_Init::
    INCBIN "data/bank_1e/Gfx_1E_5C00_Mode17_State00_Init.2bpp" ; $5C00, 768 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Gfx_1E_5F00_Mode17_State00_Init::
    INCBIN "data/bank_1e/Gfx_1E_5F00_Mode17_State00_Init.2bpp" ; $5F00, 1408 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Gfx_1E_6480_Mode17_State00_Init::
    INCBIN "data/bank_1e/Gfx_1E_6480_Mode17_State00_Init.2bpp" ; $6480, 48 bytes
; C: 2 tiles, the letters A and B (rendered): Compose_DrawPhotoNumber (06:569E) copies 16 bytes from $64B0 + (album 0
; / 1) x 16 to VRAM $8030 (the album letter in front of the photo number)
Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter::
    INCBIN "data/bank_1e/Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter.2bpp" ; $64B0, 32 bytes
; C: 10 digit tiles 0-9 (rendered): Compose_DrawPhotoNumber copies 16 bytes from $64D0 + digit x 16 for the tens
; ($8050) and the units ($8060); 64D0-6570
Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits::
    INCBIN "data/bank_1e/Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits.2bpp" ; $64D0, 160 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Gfx_1E_6570_Mode17_State00_Init::
    INCBIN "data/bank_1e/Gfx_1E_6570_Mode17_State00_Init.2bpp" ; $6570, 16 bytes
; C: copied to VRAM/WRAM by Mode17_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Gfx_1E_6580_Mode17_State00_Init::
    INCBIN "data/bank_1e/Gfx_1E_6580_Mode17_State00_Init.2bpp" ; $6580, 16 bytes
; C: 4 tiles (6590, 65A0, 65B0, 65C0) of which Mode17_State00_Init (06:4D3A-4D62) reads only the second 8 bytes (rows
; 4-7): 6598, 65A8, 65B8 and 65C8, because Mem_CopyFromBank (copy site 06:4D45) advances HL and DE by 8 and the loop
; then adds 8 again; the four 8-byte pieces go to $93C8, $93D8, $93E8 and ...
Gfx_1E_6590_Mode17_State00_Init_LowerHalves::
    db $80, $80, $80, $80, $80, $80, $ff, $ff, $0f, $00, $0f, $00, $0f, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $ff, $ff, $ff, $00, $ff, $00, $ff

    ; padding
    ds $33, $00

    ; padding
    ds $20, $ff

; C: TCRF unused graphic "cannot combine the same picture" (prohibition sign + the two lines of Japanese text): exact
; match of the TCRF image, 56 of 56 tiles (the first two are blank, 1E:6600 / 6610), laid out 8 tiles wide; never on
; screen in any replay and never read in an organic run (README 16.24)
Unused_TCRF_CannotCombineSamePicture_Gfx::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fc, $fc, $f8, $f8
    db $ff, $ff, $ff, $ff, $ff, $ff, $f0, $f0, $80, $80, $00, $00, $03, $03, $1f, $1f
    db $ff, $ff, $ff, $ff, $ff, $ff, $1f, $1f, $03, $03, $00, $00, $80, $80, $f0, $f0
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $7f, $3f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $f0, $e0, $e0, $c1, $c1, $83, $83, $87, $87, $0f, $0f, $0f, $0f, $1f, $1f
    db $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $fc, $fe, $fe, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c1, $c1, $83, $83
    db $1f, $1f, $0f, $0f, $07, $07, $03, $03, $43, $43, $e1, $e1, $e1, $e1, $f1, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff
    db $1f, $1f, $1f, $1f, $3f, $3f, $3f, $3f, $3f, $3f, $1f, $1f, $1f, $1f, $1f, $1f
    db $ff, $ff, $fe, $fe, $fc, $fc, $f8, $f8, $f0, $f0, $e0, $e0, $c1, $c1, $83, $83
    db $07, $07, $0f, $0f, $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $f0, $f0, $f0, $f8, $f8, $f8, $f8, $f8, $f8, $f0, $f0, $f0, $f0, $f1, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $0f, $0f, $0e, $0e, $84, $84, $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8
    db $07, $07, $0f, $0f, $1f, $1f, $3f, $3f, $7f, $7f, $ff, $ff, $7f, $7f, $1f, $1f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe, $fc, $fc, $f0, $f0
    db $e1, $e1, $e1, $e1, $c3, $c3, $83, $83, $07, $07, $0f, $0f, $1f, $1f, $3f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0, $e0
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3d, $3d
    db $fc, $fc, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $40, $40
    db $03, $03, $00, $00, $80, $80, $f0, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $7b, $7b
    db $80, $80, $00, $00, $03, $03, $1f, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $dd, $dd
    db $7f, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f1, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fa, $fa
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ef, $ef, $e8, $e8, $ef, $ef, $e8, $e8, $e8, $e8, $ef, $ef, $ff, $ff, $ff, $ff
    db $b5, $b5, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b7, $b8, $b8, $ff, $ff, $ff, $ff
    db $57, $57, $f1, $f1, $f7, $f7, $f1, $f1, $60, $60, $fd, $fd, $ff, $ff, $af, $af
    db $60, $60, $fb, $fb, $f1, $f1, $f5, $f5, $40, $40, $ee, $ee, $ff, $ff, $ff, $ff
    db $d0, $d0, $dd, $dd, $dd, $dd, $d0, $d0, $55, $55, $d1, $d1, $ff, $ff, $ff, $ff
    db $ee, $ee, $d1, $d1, $ff, $ff, $e0, $e0, $ee, $ee, $e0, $e0, $ff, $ff, $ff, $ff
    db $c0, $c0, $5b, $5b, $da, $da, $c5, $c5, $d1, $d1, $d6, $d6, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $f8, $f8, $ff, $ff, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff
    db $ae, $ae, $38, $38, $7e, $7e, $f8, $f8, $ff, $ff, $f7, $f7, $78, $78, $ff, $ff
    db $fd, $fd, $30, $30, $fd, $fd, $30, $30, $7d, $7d, $f0, $f0, $71, $71, $ff, $ff
    db $ed, $ed, $6d, $6d, $c0, $c0, $6d, $6d, $ed, $ed, $6f, $6f, $f0, $f0, $ff, $ff
    db $ef, $ef, $ef, $ef, $ef, $ef, $ef, $ef, $de, $de, $ce, $ce, $b1, $b1, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $df, $df, $af, $af, $df, $df, $ff, $ff

    ; padding
    ds $10, $ff

    ; padding
    ds $80, $00

; C: picture 1 of the shared result / error screen 09:7290 (table 09:7332, 0xE00 bytes: $9000 + $8800 + $8000 parts);
; played with tune 29Totaka; seen in BGB (SHOOT parlor RUN)
Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka::
    INCBIN "data/bank_1e/Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka.2bpp" ; $6A00, 3584 bytes
; C: far pointer loaded by SaveDialog_Substate3_FullInit (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 1264 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Gfx_1E_7800_SaveDialog_Substate3_FullInit::
    db $2c, $1f, $74, $28, $6c, $48, $98, $48, $c2, $79, $52, $21, $00, $00, $00, $00
    db $e3, $c3, $27, $63, $25, $27, $0d, $65, $a1, $c1, $80, $01, $00, $00, $00, $00
    db $81, $02, $81, $02, $83, $02, $82, $06, $ee, $3c, $b8, $00, $00, $00, $00, $00
    db $40, $2c, $60, $38, $08, $30, $00, $00, $04, $03, $05, $02, $00, $00, $00, $00
    db $60, $40, $42, $41, $c1, $46, $06, $c4, $c0, $87, $02, $01, $00, $00, $00, $00
    db $30, $20, $30, $e0, $f4, $38, $76, $2c, $64, $c2, $c0, $00, $00, $00, $00, $00
    db $33, $21, $34, $23, $34, $1f, $1d, $01, $00, $03, $04, $02, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $18, $08, $09, $7e, $0b, $7c, $0c, $08, $03, $0c
    db $00, $00, $00, $00, $01, $00, $81, $01, $03, $c1, $03, $67, $13, $25, $83, $01
    db $00, $00, $00, $00, $00, $00, $80, $00, $24, $98, $28, $f6, $e2, $c2, $03, $82
    db $00, $00, $00, $00, $00, $00, $00, $30, $30, $20, $20, $20, $60, $20, $48, $24
    db $00, $00, $00, $00, $00, $00, $80, $40, $c7, $47, $40, $40, $67, $40, $60, $47
    db $00, $00, $00, $00, $60, $00, $40, $20, $fe, $fe, $60, $20, $fe, $20, $20, $fe
    db $00, $00, $00, $00, $01, $00, $03, $01, $7f, $ff, $ff, $01, $10, $0f, $35, $1b
    db $00, $00, $00, $00, $00, $00, $00, $00, $e0, $f0, $f5, $03, $82, $05, $80, $01
    db $00, $00, $00, $00, $48, $00, $dc, $48, $3e, $c4, $97, $fa, $9c, $88, $0c, $88
    db $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $01, $03, $03, $07, $03, $07
    db $00, $1f, $1f, $7f, $7b, $f1, $e0, $f1, $f5, $e4, $c4, $ee, $ee, $ce, $9f, $c0
    db $00, $00, $00, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $70, $f8, $f8, $7c, $38, $7c
    db $00, $00, $40, $00, $20, $41, $60, $41, $cf, $5f, $c0, $41, $81, $40, $87, $40
    db $00, $00, $00, $00, $00, $86, $02, $84, $f6, $e4, $0c, $84, $08, $84, $08, $84
    db $00, $00, $00, $00, $08, $00, $1c, $08, $00, $0c, $0c, $04, $06, $04, $00, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $01, $07, $07, $0f, $0c, $18, $1b, $38, $1b, $39, $3b, $79, $38, $78
    db $00, $f0, $f0, $fc, $fc, $fe, $0e, $0f, $f7, $07, $fb, $f3, $fb, $f3, $03, $07
    db $00, $00, $00, $00, $00, $06, $02, $04, $06, $84, $0c, $84, $88, $c4, $88, $c4
    db $00, $00, $00, $00, $08, $00, $1c, $08, $00, $0c, $0c, $04, $06, $04, $00, $06
    db $00, $00, $00, $00, $00, $60, $21, $40, $60, $40, $c0, $40, $80, $40, $80, $40
    db $00, $00, $00, $00, $81, $03, $c1, $80, $00, $c0, $c1, $43, $65, $42, $00, $60
    db $00, $00, $00, $00, $f4, $f8, $f0, $08, $c8, $30, $8c, $f8, $08, $18, $48, $30
    db $00, $00, $00, $00, $00, $00, $07, $00, $08, $1f, $68, $30, $20, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $80, $e0, $40, $20, $40, $e0, $40
    db $03, $07, $03, $07, $01, $03, $01, $03, $00, $01, $00, $00, $00, $00, $00, $00
    db $c0, $80, $1f, $bf, $ff, $3f, $3f, $7f, $ff, $ff, $7f, $ff, $1f, $7f, $00, $1f
    db $78, $3c, $18, $bc, $f0, $98, $90, $d8, $e0, $f0, $c0, $e0, $00, $c0, $00, $00
    db $9b, $4f, $d8, $51, $d0, $51, $6a, $5f, $6a, $04, $00, $00, $00, $00, $00, $00
    db $00, $8c, $88, $c4, $8e, $64, $12, $27, $03, $00, $00, $00, $00, $00, $00, $00
    db $06, $02, $03, $02, $81, $42, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3b, $78, $3b, $79, $1b, $39, $1b, $38, $0c, $18, $07, $0f, $01, $07, $00, $01
    db $f9, $03, $fd, $f9, $fd, $f9, $f9, $03, $02, $07, $fc, $fe, $f0, $fc, $00, $f0
    db $80, $cc, $88, $c4, $0e, $84, $02, $87, $03, $00, $00, $00, $00, $00, $00, $00
    db $06, $02, $03, $02, $81, $42, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $c0, $80, $40, $e8, $44, $2c, $78, $30, $00, $00, $00, $00, $00, $00, $00
    db $60, $20, $30, $21, $16, $23, $0c, $06, $04, $00, $00, $00, $00, $00, $00, $00
    db $c0, $60, $a0, $f0, $80, $30, $32, $1e, $1e, $00, $00, $00, $00, $00, $00, $00
    db $02, $01, $06, $03, $04, $02, $04, $00, $06, $04, $04, $00, $00, $00, $00, $00
    db $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0
    db $ff, $ff, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $c0, $00, $c0, $00, $ff, $00, $ff
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $f0, $00, $f0
    db $00, $0f, $00, $0f, $00, $0f, $00, $0e, $00, $0e, $00, $0f, $00, $0f, $00, $0f
    db $00, $ff, $00, $ff, $00, $ff, $00, $73, $00, $23, $00, $07, $00, $8f, $00, $07
    db $00, $ce, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ca, $00, $ca, $00, $ca
    db $00, $70, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $70
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0e
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $f3, $00, $f3, $00, $f3, $00, $03
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $03, $81, $00, $83, $07, $82, $80, $06, $06, $04, $00, $00, $00, $00, $00, $00
    db $84, $08, $04, $08, $0c, $08, $18, $08, $90, $f8, $d0, $20, $00, $00, $00, $00
    db $00, $cf, $00, $cf, $00, $cf, $00, $c0, $00, $c0, $00, $cf, $00, $cf, $00, $cf
    db $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $f0, $00, $f0, $00, $f0
    db $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0f
    db $00, $03, $00, $03, $00, $53, $00, $53, $00, $53, $00, $53, $00, $53, $00, $ff
    db $00, $ff, $00, $ff, $00, $ce, $00, $c4, $00, $e0, $00, $f1, $00, $e0, $00, $c4
    db $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $f0, $00, $f0, $00, $f0, $00, $70
    db $00, $0e, $00, $0e, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0e, $00, $0e
    db $00, $23, $00, $73, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $03, $00, $03
    db $00, $ca, $00, $ca, $00, $c0, $00, $c0, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $70, $00, $70, $00, $70, $00, $70, $00, $f0, $00, $f0, $00, $f0, $00, $f0
    db $00, $0e, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $00, $03, $00, $f3, $00, $f3, $00, $f3, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0

    ; padding
    ds $20, $00

    ; padding
    ds $10, $ff

; C: tile data with no direct pointer in the code (unreferenced); classified from its content - see sym_unconclusive.
; Owner (review page, 2026-10-13): graphic, by eye.
Gfx_1E_7D00_Unref::
    db $00, $00, $00, $00, $00, $00, $00, $01, $00, $02, $00, $02, $00, $04, $00, $04
    db $00, $1f, $00, $60, $04, $8e, $1f, $0e, $0a, $1b, $3b, $11, $11, $31, $60, $3f
    db $00, $00, $00, $c0, $00, $20, $00, $10, $00, $08, $80, $08, $00, $84, $c0, $84
    db $00, $04, $00, $04, $00, $02, $00, $02, $00, $01, $00, $00, $00, $00, $00, $00
    db $3f, $7f, $e0, $40, $00, $c0, $c0, $80, $00, $00, $00, $80, $00, $60, $00, $1f
    db $80, $c4, $e0, $44, $00, $68, $60, $28, $00, $10, $00, $20, $00, $c0, $00, $00
    db $00, $01, $00, $06, $00, $08, $03, $17, $04, $27, $04, $26, $04, $46, $07, $47
    db $00, $f0, $00, $0c, $00, $02, $f0, $f1, $08, $f8, $04, $0c, $04, $0c, $fc, $f8
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $00, $80, $00, $40, $00, $40
    db $04, $47, $04, $46, $04, $26, $04, $27, $03, $17, $00, $08, $00, $06, $00, $01
    db $06, $fc, $02, $06, $02, $06, $06, $fc, $fc, $f9, $00, $02, $00, $0c, $00, $f0
    db $00, $40, $00, $40, $00, $80, $00, $80

    ; padding
    ds $48, $00

; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_1E_7E00_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_1e/Map_1E_7E00_PhotoPicker_PageTransitionPrev.tilemap" ; $7E00, 512 bytes

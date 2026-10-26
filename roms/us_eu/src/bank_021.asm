; Game Boy Camera (USA, Europe), bank $21. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $021", ROMX[$4000], BANK[$21]

; I: copied to VRAM/WRAM by Mode07_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Gfx_21_4000_Mode07_State00_Init::
    INCBIN "data/bank_21/Gfx_21_4000_Mode07_State00_Init.2bpp" ; $4000, 1872 bytes
; C: far pointer loaded by SpaceFever_LoadHudTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Gfx_21_4750_SpaceFever_LoadHudTiles::
    INCBIN "data/bank_21/Gfx_21_4750_SpaceFever_LoadHudTiles.2bpp" ; $4750, 176 bytes
; C: copied to VRAM/WRAM by Mode07_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Gfx_21_4800_Mode07_State00_Init::
    INCBIN "data/bank_21/Gfx_21_4800_Mode07_State00_Init.2bpp" ; $4800, 80 bytes
; C: far pointer loaded by SpaceFever_LoadHudTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Gfx_21_4850_SpaceFever_LoadHudTiles::
    INCBIN "data/bank_21/Gfx_21_4850_SpaceFever_LoadHudTiles.2bpp" ; $4850, 944 bytes
; C: Spriter's Resource sheet "Minigames - Space Fever II", 157 tiles. L3 pass 2026-10-26: read in BGB in 11 replay(s)
; of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00::
    INCBIN "data/bank_21/Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00.2bpp" ; $4C00, 96 bytes
; C: far pointer loaded by SpaceFever_DrawBestHud (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 11 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
Gfx_21_4C60_SpaceFever_DrawBestHud::
    db $17, $08, $10, $0f, $13, $0c, $12, $0c, $12, $0c, $12, $0c, $12, $0c, $1e, $00
    db $db, $24, $18, $e7, $f9, $06, $09, $06, $09, $06, $09, $06, $09, $06, $0f, $00
    db $ed, $12, $0c, $f3, $ec, $13, $2c, $13, $2c, $13, $2c, $13, $2c, $13, $3f, $00
    db $96, $09, $96, $09, $97, $08, $94, $08, $94, $08, $f7, $08, $06, $f9, $ff, $00
    db $fe, $01, $06, $f9, $f6, $09, $16, $09, $16, $09, $f6, $09, $06, $f9, $ff, $00
    db $f8, $00, $08, $f0, $78, $80, $40, $80, $40, $80, $7c, $80, $04, $f8, $fc, $00
    db $ff

    ; padding
    ds $3f, $ff

; I: tens digits 0-3 of the photo number on the comment card: 4 entries of 0x40 bytes (4 tiles each), $4D00 + 0x40 x
; tens; CommentCard_DrawPhotoNumber_Far (09:4775) takes the photo number [$DA95] (+1, minus 30 above 29), counts the
; tens in C and calls CommentCard_DrawDigitC (09:479F: A x 64 + HL, 0x40 ...
Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens::
    INCBIN "data/bank_21/Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens.2bpp" ; $4D00, 256 bytes
; C: units digits 0-9 of the photo number on the comment card: 10 entries of 0x40 bytes, $4E00 + 0x40 x digit; the
; second call of CommentCard_DrawPhotoNumber_Far (09:4796, HL = $4E00) via CommentCard_DrawDigitC (copy site 09:47B2);
; ends where Gfx_21_5080_CommentCard_DrawDigit starts (C)
Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones::
    INCBIN "data/bank_21/Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones.2bpp" ; $4E00, 640 bytes
; C: far pointer loaded by CommentCard_DrawDigit (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_21_5080_CommentCard_DrawDigit::
    INCBIN "data/bank_21/Gfx_21_5080_CommentCard_DrawDigit.2bpp" ; $5080, 1120 bytes
; C: far pointer loaded by CommentCard_DrawBlood_Far (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_21_54E0_CommentCard_DrawBlood_Far::
    INCBIN "data/bank_21/Gfx_21_54E0_CommentCard_DrawBlood_Far.2bpp" ; $54E0, 320 bytes
; C: far pointer loaded by CommentCard_DrawNibble (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 09 0A)
Src_21_5620_CommentCard_DrawNibble::
    INCBIN "data/bank_21/Src_21_5620_CommentCard_DrawNibble.bin" ; $5620, 160 bytes
; C: far pointer loaded by CommentCard_DrawNumber (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_21_56C0_CommentCard_DrawNumber::
    INCBIN "data/bank_21/Gfx_21_56C0_CommentCard_DrawNumber.2bpp" ; $56C0, 16 bytes
; C: far pointer loaded by CommentCard_DrawGender_Far (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_21_56D0_CommentCard_DrawGender_Far::
    INCBIN "data/bank_21/Gfx_21_56D0_CommentCard_DrawGender_Far.2bpp" ; $56D0, 192 bytes
; C: far pointer loaded by CommentCard_DrawCopyBadge_Far (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 224 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 0A
; (tcrf_check/assets/l3_names/)
Gfx_21_5790_CommentCard_DrawCopyBadge_Far::
    INCBIN "data/bank_21/Gfx_21_5790_CommentCard_DrawCopyBadge_Far.2bpp" ; $5790, 224 bytes
; C: far pointer loaded by CommentCard_DrawCopyBadge_Far (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 224 from the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: badge tiles loaded by ...
Gfx_21_5870_CommentCard_DrawCopyBadge_Far::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $10, $01

    ; padding
    ds $c0, $00

; C: Spriter's Resource sheet "Menus - Shoot Menu", 51 tiles | also inside record 1 of page 2 of Parlor_PageTbl
; (21:5A00 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 28 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_21_5A10::
    INCBIN "data/bank_21/Sheet_MenusShootMenu_21_5A10.bin" ; $5A10, 545 bytes
; I: inside record 1 of page 2 (21:5A00 +$0800 -> $9000, VRAM $9231 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_21_5C31_Parlor_Page2::
    INCBIN "data/bank_21/Gfx_21_5C31_Parlor_Page2.bin" ; $5C31, 927 bytes
; I: Spriter's Resource sheet "Menus - Shoot Menu", 90 tiles | also inside record 1 of page 2 of Parlor_PageTbl
; (21:5A00 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 28 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_21_5FD0::
    INCBIN "data/bank_21/Sheet_MenusShootMenu_21_5FD0.bin" ; $5FD0, 1430 bytes
; I: inside record 2 of page 2 (21:6200 +$0800 -> $8800, VRAM $8B66 onward) and record 3 of page 2 (21:6560 +$0010 ->
; $8DF0, VRAM $8DF6 onward) of Parlor_PageTbl (04:7436), loaded by Parlor_LoadPage; load extent from the code and the
; coverage log (every byte of the record is read), content = tile data ...
Gfx_21_6566_Parlor_Page2::
    INCBIN "data/bank_21/Gfx_21_6566_Parlor_Page2.bin" ; $6566, 90 bytes
; I: far pointer loaded by SaveDialog_Substate0_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1264
; from the nearby ld bc | also inside record 2 of page 2 of Parlor_PageTbl (21:6200 +$0800 -> $8800, C). L3 pass
; 2026-10-26: read in BGB in 32 replay(s) of the organic corpus, modes 01 10 ...
Gfx_21_65C0_SaveDialog_Substate0_Init::
    db $07, $07, $01, $03, $00, $00, $0e, $0e, $0e, $0f, $0f, $0f, $07, $0f, $03, $07
    db $fc, $fc, $fc, $fe, $0e, $1e, $0e, $0e, $0e, $1e, $fc, $fe, $fc, $fc, $f0, $f8
    db $1c, $1c, $1c, $1c, $1f, $1f, $1f, $1f, $1f, $1f, $1c, $1c, $1c, $1c, $1c, $1c
    db $1c, $1c, $1c, $1c, $fc, $fc, $fc, $fc, $fc, $fc, $1c, $1c, $1c, $1c, $1c, $1c
    db $38, $38, $38, $3c, $1c, $3c, $1c, $1e, $0e, $1e, $0f, $0f, $07, $0f, $07, $07
    db $38, $38, $38, $78, $70, $78, $70, $f0, $e0, $f0, $e0, $e0, $c0, $e0, $c0, $c0
    db $7f, $7f, $7f, $7f, $7f, $70, $70, $70, $70, $70, $7f, $7f, $7f, $7f, $7f, $7f
    db $c0, $e0, $c0, $e0, $e0, $00, $00, $00, $00, $00, $f0, $f0, $f0, $f0, $f0, $f0
    db $03, $07, $07, $0f, $0e, $0f, $0e, $0e, $00, $00, $0e, $0e, $0e, $0e, $0e, $0e
    db $c0, $e0, $80, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $01, $03, $07, $07, $07, $0f, $0e, $0f, $0e, $0f, $07, $0f
    db $00, $00, $00, $00, $f8, $fc, $fc, $fe, $fe, $fe, $0e, $0e, $00, $00, $f0, $f8
    db $00, $00, $00, $00, $03, $07, $07, $0f, $0f, $1f, $1e, $1f, $1c, $1e, $1c, $1c
    db $00, $00, $00, $00, $e0, $f0, $f0, $f8, $f8, $fc, $3c, $7c, $1c, $3c, $1c, $1c
    db $00, $00, $00, $00, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
    db $00, $00, $00, $00, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38, $38
    db $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $01, $03, $03, $07, $03, $07
    db $00, $1f, $1f, $7f, $7b, $f1, $e0, $f1, $f5, $e4, $c4, $ee, $ee, $ce, $9f, $c0
    db $00, $00, $00, $c0, $c0, $e1, $e0, $f0, $f0, $f8, $70, $f8, $f8, $7c, $38, $7c
    db $00, $00, $00, $00, $80, $80, $40, $c1, $21, $63, $12, $36, $0c, $1c, $08, $18
    db $00, $00, $00, $00, $4f, $df, $88, $9f, $08, $18, $08, $18, $0f, $18, $0f, $1f
    db $00, $00, $00, $00, $f8, $f8, $00, $f9, $01, $03, $01, $03, $f1, $03, $f0, $f1
    db $00, $00, $00, $00, $7c, $fe, $82, $ff, $01, $03, $00, $00, $fc, $00, $fe, $fc
    db $00, $01, $01, $07, $07, $0f, $0c, $18, $1b, $38, $1b, $39, $3b, $79, $38, $78
    db $00, $f0, $f0, $fc, $fc, $fe, $0e, $0f, $f7, $07, $fb, $f3, $fb, $f3, $03, $07
    db $00, $00, $00, $00, $01, $03, $01, $03, $01, $83, $01, $83, $81, $c3, $81, $c3
    db $00, $00, $00, $00, $01, $03, $81, $83, $01, $c3, $41, $63, $71, $23, $19, $33
    db $00, $00, $00, $00, $01, $03, $02, $07, $04, $0c, $04, $0c, $04, $0c, $04, $0c
    db $00, $00, $00, $00, $f0, $f8, $08, $fc, $04, $0c, $04, $0c, $04, $0c, $04, $0c
    db $00, $00, $00, $00, $7f, $7f, $7f, $7f, $7f, $7f, $70, $70, $70, $70, $70, $7f
    db $00, $00, $00, $00, $f0, $f0, $f0, $f0, $f0, $f0, $00, $00, $00, $00, $00, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $07, $03, $07, $01, $03, $01, $03, $00, $01, $00, $00, $00, $00, $00, $00
    db $c0, $80, $1f, $bf, $ff, $3f, $3f, $7f, $ff, $ff, $7f, $ff, $1f, $7f, $00, $1f
    db $78, $3c, $18, $bc, $f0, $98, $90, $d8, $e0, $f0, $c0, $e0, $00, $c0, $00, $00
    db $08, $18, $08, $18, $08, $18, $08, $18, $08, $18, $00, $00, $00, $00, $00, $00
    db $0f, $18, $08, $18, $08, $18, $08, $1f, $0f, $1f, $00, $00, $00, $00, $00, $00
    db $f0, $00, $00, $00, $02, $03, $01, $fb, $f8, $f9, $00, $00, $00, $00, $00, $00
    db $ff, $02, $01, $03, $01, $03, $02, $fe, $fc, $fc, $00, $00, $00, $00, $00, $00
    db $3b, $78, $3b, $79, $1b, $39, $1b, $38, $0c, $18, $07, $0f, $01, $07, $00, $01
    db $f9, $03, $fd, $f9, $fd, $f9, $f9, $03, $02, $07, $fc, $fe, $f0, $fc, $00, $f0
    db $81, $c3, $81, $c3, $01, $83, $01, $83, $01, $03, $00, $00, $00, $00, $00, $00
    db $09, $1b, $05, $0f, $05, $07, $03, $03, $01, $03, $00, $00, $00, $00, $00, $00
    db $04, $0c, $04, $0c, $04, $0c, $02, $07, $01, $03, $00, $00, $00, $00, $00, $00
    db $04, $0c, $04, $0c, $04, $0c, $08, $f8, $f0, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1f, $3f, $7f, $7f, $7f, $ff, $f1, $f1, $e0, $e0, $e1, $e0
    db $00, $00, $00, $00, $00, $80, $c0, $c0, $c0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0
    db $ff, $ff, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $c1, $00, $c0, $00, $fe, $00, $fe, $00, $c0
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $f0
    db $00, $0f, $00, $0f, $00, $0f, $00, $0e, $00, $0e, $00, $0f, $00, $0f, $00, $0e
    db $00, $ff, $00, $ff, $00, $ff, $00, $07, $00, $03, $00, $b3, $00, $b3, $00, $03
    db $00, $c0, $00, $e0, $00, $ff, $00, $ff, $00, $ff, $00, $c8, $00, $c8, $00, $ca
    db $00, $70, $00, $70, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0e, $00, $0e, $00, $0e
    db $00, $03, $00, $83, $00, $ff, $00, $ff, $00, $ff, $00, $03, $00, $03, $00, $53
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ca, $00, $ca, $00, $ca, $00, $ca, $00, $c0, $00, $c0
    db $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $70, $00, $70, $00, $70, $00, $70
    db $00, $0f, $00, $0f, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $00, $0f
    db $00, $ff, $00, $ff, $00, $47, $00, $43, $00, $53, $00, $53, $00, $13, $00, $13
    db $00, $c1, $00, $ff, $00, $ff, $00, $ff, $00, $e0, $00, $c0, $00, $cd, $00, $cd
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $70, $00, $70, $00, $f0, $00, $f0
    db $00, $0e, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0e, $00, $0e
    db $00, $07, $00, $ff, $00, $ff, $00, $ff, $00, $83, $00, $03, $00, $7f, $00, $7f
    db $00, $ca, $00, $c2, $00, $e2, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $70, $00, $70, $00, $70, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0
    db $00, $0e, $00, $0e, $00, $0e, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f
    db $00, $53, $00, $53, $00, $53, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0

    ; padding
    ds $37, $00

; C: tile data with no direct pointer in the code (unreferenced); classified from its content - see sym_unconclusive.
; Owner (review page, 2026-10-13): graphic, by eye.
Gfx_21_6AC7_Unref::
    db $01, $00, $02, $00, $02, $00, $04, $00, $04, $00, $1f, $00, $60, $04, $8e, $1f
    db $0e, $0a, $1b, $3b, $11, $11, $31, $60, $3f, $00, $00, $00, $c0, $00, $20, $00
    db $10, $00, $08, $80, $08, $00, $84, $c0, $84, $00, $04, $00, $04, $00, $02, $00
    db $02, $00, $01, $00, $00, $00, $00, $00, $00, $3f, $7f, $e0, $40, $00, $c0, $c0
    db $80, $00, $00, $00, $80, $00, $60, $00, $1f, $80, $c4, $e0, $44, $00, $68, $60
    db $28, $00, $10, $00, $20, $00, $c0, $00, $00, $00, $01, $00, $06, $00, $08, $03
    db $17, $04, $27, $04, $26, $04, $46, $07, $47, $00, $f0, $00, $0c, $00, $02, $f0
    db $f1, $08, $f8, $04, $0c, $04, $0c, $fc, $f8, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $80, $00, $80, $00, $40, $00, $40, $04, $47, $04, $46, $04, $26, $04
    db $27, $03, $17, $00, $08, $00, $06, $00, $01, $06, $fc, $02, $06, $02, $06, $06
    db $fc, $fc, $f9, $00, $02, $00, $0c, $00, $f0, $00, $40, $00, $40, $00, $80, $00
    db $80

    ; padding
    ds $19, $00

; I: small unread block of 47 bytes (was Data_21_6B91). Owner (review page, 2026-10-13): graphic, by eye.
Gfx_21_6B91_Unref::
    INCBIN "data/bank_21/Gfx_21_6B91_Unref.bin" ; $6B91, 47 bytes
; C: far pointer loaded by Mode19_State00_CopyrightScreens (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 1536 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 136 replay(s) of the organic corpus, modes 19
; (tcrf_check/assets/l3_names/)
Gfx_21_6BC0_Mode19_State00_CopyrightScreens::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $ef
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ab, $ab
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ee, $ee
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $fc, $f3, $fb, $f4, $f6, $f5, $f5, $f5, $f5, $f4, $f6, $f3, $fb, $f8, $fc
    db $1f, $3f, $cf, $df, $2f, $6f, $ef, $ef, $ef, $ef, $2f, $6f, $cf, $df, $1f, $3f
    db $ff, $ff, $83, $83, $f7, $f7, $ff, $ff, $bf, $bf, $7f, $7f, $7f, $7f, $81, $81
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7b, $7b, $7b, $7b, $77, $77, $8f, $8f
    db $bf, $bf, $0f, $0f, $b1, $b1, $bf, $bf, $bf, $bf, $6f, $6f, $6f, $6f, $71, $71
    db $ff, $ff, $01, $01, $ef, $ef, $df, $df, $df, $df, $df, $df, $ef, $ef, $f3, $f3
    db $ff, $ff, $c7, $c7, $3b, $3b, $fd, $fd, $fd, $fd, $fd, $fd, $fb, $fb, $c7, $c7
    db $d7, $d7, $37, $37, $bb, $bb, $79, $79, $7b, $7b, $7b, $7b, $77, $77, $8f, $8f
    db $07, $07, $ef, $ef, $df, $df, $87, $87, $7b, $7b, $fb, $fb, $fb, $fb, $87, $87
    db $ff, $ff, $ff, $ff, $ff, $ff, $cf, $cf, $cf, $cf, $ff, $ff, $ff, $ff, $ff, $ff
    db $ef, $ef, $ef, $ef, $ab, $ab, $ad, $ad, $6d, $6d, $6d, $6d, $ef, $ef, $ef, $ef
    db $00, $00, $7e, $7e, $c3, $c3, $f7, $f7, $81, $81, $f7, $f7, $f7, $f7, $ef, $ef
    db $d0, $d0, $ab, $ab, $c4, $c4, $d5, $d5, $c4, $c4, $c4, $c4, $dd, $dd, $c4, $c4
    db $3f, $3f, $bf, $bf, $7f, $7f, $7f, $7f, $ff, $ff, $7f, $7f, $7f, $7f, $7f, $7f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $fb
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ea, $ea
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $fb
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $bf
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $fc, $f3, $fb, $f4, $f6, $f5, $f5, $f5, $f5, $f4, $f6, $f3, $fb, $f8, $fc
    db $1f, $3f, $cf, $df, $2f, $6f, $ef, $ef, $ee, $ef, $2e, $6e, $cf, $df, $1f, $3f
    db $b2, $b2, $16, $16, $b3, $b3, $12, $12, $1d, $1d, $b0, $b0, $bd, $bd, $a0, $a0
    db $3e, $3e, $a0, $a0, $7e, $7e, $b8, $bc, $f2, $fa, $66, $76, $ec, $ec, $3e, $3e
    db $ff, $ff, $0c, $0c, $fd, $fd, $3f, $7f, $9f, $bf, $cc, $dc, $6f, $6f, $ff, $ff
    db $57, $57, $01, $01, $fd, $fd, $07, $07, $ef, $ef, $01, $01, $ef, $ef, $cf, $df
    db $ea, $ea, $ea, $ef, $01, $01, $7d, $7d, $7d, $7d, $f9, $fd, $f3, $fb, $c7, $c7
    db $ff, $ff, $ff, $ff, $ff, $ff, $f3, $f3, $f3, $f3, $ff, $ff, $ff, $ff, $ff, $ff
    db $fb, $fb, $fb, $fb, $ea, $ea, $eb, $eb, $db, $db, $db, $db, $fb, $fb, $fb, $fb
    db $c0, $c0, $df, $df, $f0, $f0, $7d, $7d, $60, $60, $7d, $7d, $fd, $fd, $fb, $fb
    db $34, $34, $aa, $aa, $f1, $f1, $f5, $f5, $71, $71, $f1, $f1, $f7, $f7, $f1, $f1
    db $0f, $0f, $ef, $ef, $1f, $1f, $5f, $5f, $3f, $3f, $1f, $1f, $5f, $5f, $1f, $1f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $100, $ff

; C: copied to VRAM/WRAM by Mode19_State00_CopyrightScreens (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 205 replay(s) of the organic corpus, modes 19 (tcrf_check/assets/l3_names/)
Gfx_21_71C0_Mode19_State00_CopyrightScreens::
    INCBIN "data/bank_21/Gfx_21_71C0_Mode19_State00_CopyrightScreens.2bpp" ; $71C0, 1536 bytes
; I: copied to VRAM/WRAM by BorderPicker_Substate0_Init, WildFramePicker_Substate0_Init
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 12 replay(s) of the organic corpus, modes
; 09 0A 12 1C (tcrf_check/assets/l3_names/)
Gfx_21_77C0_BorderPicker_Substate0_Init::
    INCBIN "data/bank_21/Gfx_21_77C0_BorderPicker_Substate0_Init.2bpp" ; $77C0, 1008 bytes
; C: far pointer loaded by BorderPicker_AnimateIcon, WildFramePicker_AnimateIcon (ld a,BANK; ld hl,ADDR; call banked
; copy/far call) | frame 0 of the 5-frame icon animation: frames 1-4 are
; Gfx_21_7BC0_BorderPicker_AnimateIcon_Frames1to4. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the organic ...
Src_21_7BB0_BorderPicker_AnimateIcon::
    INCBIN "data/bank_21/Src_21_7BB0_BorderPicker_AnimateIcon.bin" ; $7BB0, 16 bytes
; C: frames 1-4 of the 5-frame icon animation (1 tile = 16 bytes each at $7BB0 + 16 x frame): BorderPicker_AnimateIcon
; (08:4EBB) and WildFramePicker_AnimateIcon (08:5262) copy 16 bytes with Mem_CopyFromBank (copy site 08:4ECF) to a
; Vq_Push packet for VRAM $8FE0 and wrap the frame counter $D500 at 5 (C); ...
Gfx_21_7BC0_BorderPicker_AnimateIcon_Frames1to4::
    db $83, $00, $6f, $00, $01, $00, $98, $00, $63, $00, $f9, $00, $8f, $00, $f0, $00
    db $5f, $00, $9a, $00, $3b, $00, $5d, $00, $45, $00, $d5, $00, $f5, $00, $6e, $00
    db $ee, $00, $ca, $00, $42, $00, $56, $00, $15, $00, $4d, $00, $4d, $00, $97, $00
    db $5f, $00, $9a, $00, $3b, $00, $5d, $00, $45, $00, $d5, $00, $f5, $00, $6e, $00

    ; padding
    ds $c0, $00

; I: copied to VRAM/WRAM by CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Map_21_7CC0_CommentEditor_Sub0_Init::
    INCBIN "data/bank_21/Map_21_7CC0_CommentEditor_Sub0_Init.tilemap" ; $7CC0, 576 bytes
; C: copied to VRAM/WRAM by CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Map_21_7F00_CommentEditor_Sub0_Init::
    INCBIN "data/bank_21/Map_21_7F00_CommentEditor_Sub0_Init.tilemap" ; $7F00, 256 bytes

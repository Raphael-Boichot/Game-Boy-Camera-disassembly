; Pocket Camera (Japan) (Rev A), bank $21. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $021", ROMX[$4000], BANK[$21]

; C: copied to VRAM/WRAM by Mode07_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
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

; C: tens digits 0-3 of the photo number on the comment card: 4 entries of 0x40 bytes (4 tiles each), $4D00 + 0x40 x
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
; C: inside record 1 of page 2 (21:5A00 +$0800 -> $9000, VRAM $9231 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I)
Gfx_21_5C31_Parlor_Page2::
    INCBIN "data/bank_21/Gfx_21_5C31_Parlor_Page2.bin" ; $5C31, 927 bytes
; C: Spriter's Resource sheet "Menus - Shoot Menu", 90 tiles | also inside record 1 of page 2 of Parlor_PageTbl
; (21:5A00 +$0800 -> $9000, C). L3 pass 2026-10-26: read in BGB in 28 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Sheet_MenusShootMenu_21_5FD0::
    db $3f, $87, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88, $30, $88
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $7f, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $c0, $3f, $bc, $c3, $73, $fc, $00, $00, $ff, $00, $ff, $00
    db $37, $0e, $17, $0e, $5e, $3f, $6d, $f3, $e1, $80, $00, $00, $ff, $00, $ff, $00
    db $80, $00, $00, $00, $00, $00, $01, $00, $05, $03, $00, $00, $ff, $00, $ff, $00
    db $01, $c3, $c2, $43, $c0, $43, $c2, $43, $47, $c2, $02, $00, $ff, $00, $ff, $00
    db $ed, $86, $c6, $84, $ce, $84, $86, $c4, $87, $c2, $00, $00, $ff, $00, $ff, $00
    db $00, $01, $00, $01, $01, $00, $01, $00, $40, $80, $00, $00, $ff, $00, $ff, $00
    db $a0, $c0, $40, $80, $d8, $e0, $3a, $fc, $17, $0f, $00, $00, $ff, $00, $ff, $00
    db $03, $fd, $07, $fb, $3f, $c7, $db, $3c, $e8, $f0, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $00, $ff, $01, $fe, $02, $fd, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $00, $ff, $00, $ff, $00
    db $30, $8f, $38, $87, $38, $87, $3c, $83, $3e, $81, $3f, $80, $3f, $80, $3f, $80
    db $40, $bf, $80, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $05, $03, $0f, $06, $2a, $1d, $74, $3b, $58, $e7, $a0, $df, $d8, $e7, $3e, $f9
    db $00, $80, $c0, $80, $c0, $80, $80, $80, $80, $80, $00, $81, $03, $81, $01, $80
    db $67, $9f, $c3, $80, $c0, $80, $c0, $80, $c0, $80, $c0, $c0, $96, $f0, $fb, $b7
    db $e6, $f9, $c0, $00, $00, $00, $01, $00, $01, $00, $03, $06, $5d, $36, $4f, $b1
    db $a0, $5f, $01, $00, $01, $00, $81, $00, $01, $80, $81, $00, $01, $00, $00, $01
    db $ef, $70, $70, $b8, $2e, $dc, $1a, $e7, $0d, $f3, $36, $cf, $da, $3c, $68, $f0
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $3f, $e0, $df, $a0, $df
    db $e0, $df, $a0, $df, $c0, $bf, $80, $7f, $00, $ff, $ff, $00, $ff, $ff, $fa, $01
    db $f9, $78, $18, $19, $7b, $39, $e5, $f3, $0f, $0e, $3d, $38, $e3, $ff, $61, $9e
    db $f9, $fe, $e0, $00, $ff, $ff, $a0, $00, $00, $00, $00, $00, $80, $00, $e6, $f8
    db $c3, $3c, $00, $00, $f0, $e0, $5f, $3f, $07, $00, $00, $00, $05, $03, $6f, $1f
    db $01, $03, $03, $86, $c7, $8f, $c4, $6f, $a0, $70, $78, $98, $e7, $0e, $f9, $ff
    db $07, $fb, $03, $fd, $01, $fe, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe
    db $28, $37, $30, $2f, $30, $2f, $70, $2f, $30, $6f, $70, $6f, $50, $6f, $60, $df
    db $04, $80, $c0, $c0, $70, $f0, $18, $30, $00, $00, $80, $80, $c0, $e0, $f0, $f0
    db $ff, $ff, $07, $03, $00, $00, $28, $10, $fe, $7e, $e3, $c3, $80, $00, $ff, $ff
    db $ff, $ff, $ec, $f0, $00, $00, $00, $00, $3c, $1c, $a7, $7f, $41, $e0, $cb, $87
    db $00, $00, $0f, $07, $0e, $1e, $08, $10, $00, $00, $00, $00, $00, $00, $01, $01
    db $38, $d8, $28, $d8, $1c, $e8, $1c, $ec, $16, $ec, $0c, $f6, $0e, $f6, $0b, $f6
    db $9f, $9e, $9f, $9e, $1d, $9e, $9e, $1d, $1a, $1d, $34, $1b, $18, $37, $38, $37
    db $00, $00, $01, $01, $00, $01, $03, $03, $03, $01, $03, $03, $02, $03, $02, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $fc
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $0c, $08, $04, $00, $00, $0f, $07
    db $a0, $a0, $b0, $a0, $a0, $b0, $b0, $b0, $d0, $b0, $f0, $70, $b8, $70, $50, $b8
    db $03, $fd, $03, $fd, $02, $fd, $01, $fe, $01, $fe, $00, $ff, $00, $ff, $00, $ff
    db $0f, $0e, $0f, $0e, $0f, $0e, $1f, $0e, $0f, $1e, $4f, $1e, $9f, $5e, $5b, $9e
    db $0e, $0c, $1c, $1e, $1e, $1f, $1f, $3f, $1f, $3f, $1f, $3e, $0c, $1e, $00, $00
    db $80, $80, $c0, $c0, $e0, $e0, $e0, $e0, $e0, $e0, $c0, $e0, $c0, $80, $00, $00
    db $00, $01, $01, $01, $03, $03, $07, $03, $07, $07, $07, $03, $01, $01, $00, $00
    db $c0, $c0, $c0, $c0, $e0, $c0, $e0, $c0, $e0, $e0, $e0, $e0, $e0, $e0, $a0, $e0
    db $03, $fd, $03, $fd, $03, $fd, $03, $fd, $02, $fd, $01, $fe, $02, $fd, $03, $fd
    db $0f, $0f, $0f, $0f, $0e, $07, $06, $8f, $ee, $ef, $0f, $0f, $0f, $0f, $0e, $0f
    db $00, $00, $00, $00, $00, $00, $0f, $1f, $ff, $7f, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $07, $03, $06, $06
    db $00, $00, $00, $00, $08, $00, $08, $08, $08, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $e8, $f0, $fe, $fe, $07, $03
    db $80, $80, $80, $80, $80, $80, $80, $80, $c0, $80, $83, $c1, $df, $cf, $cc, $d8
    db $07, $fb, $07, $fb, $07, $fb, $07, $fb, $05, $fb, $03, $fd, $03, $fd, $03, $fd
    db $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f
    db $17, $37, $37, $1f, $1f, $1f, $0f, $1f, $0f, $1f, $1f, $0d, $07, $0f, $07, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $f0, $c0, $e0, $e0, $c0, $80, $c0, $c0, $80, $80, $80, $80, $80, $80, $80
    db $07, $fb, $07, $fb, $07, $fb, $07, $fb, $07, $fb, $07, $fb, $07, $fb, $07, $fb
    db $00, $ff, $00, $ff, $00, $ff, $80, $7f, $80, $7f, $80, $7f, $80, $7f, $80, $7f
    db $fd, $fe, $ff, $fa, $ff, $fe, $7e, $7f, $7d, $ff, $7f, $ff, $3e, $7f, $7f, $2f
    db $ff, $ff, $ff, $ff, $7b, $ff, $16, $0f, $02, $01, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fe, $ff, $ff, $ff, $d8, $e0, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fe, $f0, $e0, $40, $80, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fe, $fc, $f8
    db $01, $fe, $02, $fd, $03, $fd, $05, $fb, $07, $fb, $07, $fb, $07, $fb, $07, $fb
    db $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f
    db $40, $bf, $a0, $df, $e0, $df, $d0, $ef, $f8, $f7, $fc, $fb, $ea, $cd, $fe, $fd
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ef, $ff, $ff, $ff, $fb, $ff, $ff
    db $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $ff, $ff, $ff, $df, $ff, $bf, $ff, $ff, $ff, $ff, $fb, $ff, $ff, $ff, $ff
    db $03, $fc, $05, $fb, $0b, $f7, $17, $ef, $6f, $9f, $bf, $7f, $7f, $ff, $ff, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $fe, $01, $fe
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $3c, $87, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f, $38, $8f
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $80, $7f
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $e0, $1f, $de, $e1, $fd, $fe
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $c0, $ff, $ff, $ff
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $3f, $c0, $df, $3f, $ff, $ff
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $03, $fc, $fd, $03
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $7f, $80, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $c0, $3f, $80, $3f, $80, $3f, $80, $3f, $81, $3e, $83, $3c, $87
    db $00

    ; padding
    ds $45, $00

; C: inside record 2 of page 2 (21:6200 +$0800 -> $8800, VRAM $8B66 onward) and record 3 of page 2 (21:6560 +$0010 ->
; $8DF0, VRAM $8DF6 onward) of Parlor_PageTbl (04:7436), loaded by Parlor_LoadPage; load extent from the code and the
; coverage log (every byte of the record is read), content = tile data ...
Gfx_21_6566_Parlor_Page2::
    db $80, $80, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $f8, $00, $00, $00, $60, $00, $f0
    db $80, $70, $60, $18, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $70
    db $03, $fc, $8c, $70, $70, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $0e
    db $40, $38, $48, $30, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $0e
    db $40, $38, $48, $30, $30

    ; padding
    ds $15, $00

; C: far pointer loaded by SaveDialog_Substate0_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1264
; from the nearby ld bc | also inside record 2 of page 2 of Parlor_PageTbl (21:6200 +$0800 -> $8800, C). L3 pass
; 2026-10-26: read in BGB in 32 replay(s) of the organic corpus, modes 01 10 ...
Gfx_21_65C0_SaveDialog_Substate0_Init::
    db $30, $20, $30, $20, $30, $20, $00, $30, $38, $1f, $08, $07, $00, $00, $00, $00
    db $e8, $47, $80, $40, $00, $00, $20, $00, $c0, $e0, $c0, $00, $00, $00, $00, $00
    db $01, $fe, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $01, $01, $03, $03, $06, $10, $0c, $10, $08, $00, $00, $00, $00
    db $80, $c6, $00, $86, $00, $06, $06, $02, $01, $03, $01, $00, $00, $00, $00, $00
    db $00, $00, $01, $00, $07, $02, $16, $0c, $30, $f8, $20, $c0, $00, $00, $00, $00
    db $03, $02, $23, $1e, $1f, $63, $67, $42, $06, $7c, $2c, $10, $00, $00, $00, $00
    db $03, $02, $03, $02, $43, $81, $61, $c0, $40, $20, $00, $00, $00, $00, $00, $00
    db $30, $18, $40, $38, $40, $f8, $d8, $10, $00, $30, $40, $20, $00, $00, $00, $00
    db $38, $10, $00, $30, $70, $20, $01, $60, $69, $4f, $0d, $02, $00, $00, $00, $00
    db $40, $80, $40, $80, $c0, $80, $80, $80, $00, $80, $00, $00, $00, $00, $00, $00
    db $2c, $18, $60, $30, $40, $20, $40, $00, $60, $40, $40, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $30, $12, $21, $26, $3f, $ac, $70, $b0, $60
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $c0, $30, $e0, $30, $20, $67, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00
    db $00, $00, $00, $00, $00, $00, $08, $07, $98, $7f, $30, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $01, $03, $03, $07, $03, $07
    db $00, $1f, $1f, $7f, $7b, $f1, $e0, $f1, $f5, $e4, $c4, $ee, $ee, $ce, $9f, $c0
    db $00, $00, $00, $c0, $c0, $e0, $e0, $f0, $f0, $f8, $70, $f8, $f8, $7c, $38, $7c
    db $00, $00, $40, $00, $20, $41, $60, $41, $cf, $5f, $c0, $41, $81, $40, $87, $40
    db $00, $00, $00, $00, $00, $86, $02, $84, $f6, $e4, $0c, $84, $08, $84, $08, $84
    db $00, $00, $00, $00, $08, $00, $1c, $08, $00, $0c, $0c, $04, $06, $04, $00, $06
    db $00, $00, $00, $00, $04, $00, $0d, $04, $03, $0c, $59, $3f, $29, $58, $00, $18
    db $00, $01, $01, $07, $07, $0f, $0c, $18, $1b, $38, $1b, $39, $3b, $79, $38, $78
    db $00, $f0, $f0, $fc, $fc, $fe, $0e, $0f, $f7, $07, $fb, $f3, $fb, $f3, $03, $07
    db $00, $00, $00, $00, $00, $06, $02, $04, $06, $84, $0c, $84, $88, $c4, $88, $c4
    db $00, $00, $00, $00, $08, $00, $1c, $08, $00, $0c, $0c, $04, $06, $04, $00, $06
    db $00, $00, $00, $00, $00, $60, $21, $40, $60, $40, $c0, $40, $80, $40, $80, $40
    db $00, $00, $00, $00, $81, $03, $c1, $80, $00, $c0, $c1, $43, $65, $42, $00, $60
    db $00, $00, $00, $00, $f4, $f8, $f0, $08, $c8, $30, $8c, $f8, $08, $18, $48, $30
    db $00, $00, $00, $50, $72, $50, $f3, $52, $e6, $c2, $64, $42, $60, $46, $c0, $46
    db $00, $00, $00, $00, $06, $00, $04, $02, $7f, $7f, $06, $02, $7f, $02, $02, $7f
    db $03, $07, $03, $07, $01, $03, $01, $03, $00, $01, $00, $00, $00, $00, $00, $00
    db $c0, $80, $1f, $bf, $ff, $3f, $3f, $7f, $ff, $ff, $7f, $ff, $1f, $7f, $00, $1f
    db $78, $3c, $18, $bc, $f0, $98, $90, $d8, $e0, $f0, $c0, $e0, $00, $c0, $00, $00
    db $9b, $4f, $d8, $51, $d0, $51, $6a, $5f, $6a, $04, $00, $00, $00, $00, $00, $00
    db $00, $8c, $88, $c4, $8e, $64, $12, $27, $03, $00, $00, $00, $00, $00, $00, $00
    db $06, $02, $03, $02, $81, $42, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $00, $c0, $80, $e0, $41, $76, $a3, $c2, $80, $c0, $80
    db $3b, $78, $3b, $79, $1b, $39, $1b, $38, $0c, $18, $07, $0f, $01, $07, $00, $01
    db $f9, $03, $fd, $f9, $fd, $f9, $f9, $03, $02, $07, $fc, $fe, $f0, $fc, $00, $f0
    db $80, $cc, $88, $c4, $0e, $84, $02, $87, $03, $00, $00, $00, $00, $00, $00, $00
    db $06, $02, $03, $02, $81, $42, $c0, $80, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $c0, $80, $40, $e8, $44, $2c, $78, $30, $00, $00, $00, $00, $00, $00, $00
    db $60, $20, $30, $21, $16, $23, $0c, $06, $04, $00, $00, $00, $00, $00, $00, $00
    db $c0, $60, $a0, $f0, $80, $30, $32, $1e, $1e, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $e7, $ef, $0f, $00, $e1, $00, $03, $e1
    db $00, $00, $00, $00, $10, $00, $30, $10, $fe, $ff, $ff, $10, $08, $f0, $58, $b0
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
    db $00, $00, $00, $00, $00, $00, $70, $00, $8c, $f8, $8e, $04, $02, $04, $0e, $04
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

; C: small unread block of 47 bytes (was Data_21_6B91). Owner (review page, 2026-10-13): graphic, by eye.
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
; C: copied to VRAM/WRAM by BorderPicker_Substate0_Init, WildFramePicker_Substate0_Init
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

; C: copied to VRAM/WRAM by CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Map_21_7CC0_CommentEditor_Sub0_Init::
    INCBIN "data/bank_21/Map_21_7CC0_CommentEditor_Sub0_Init.tilemap" ; $7CC0, 576 bytes
; C: copied to VRAM/WRAM by CommentEditor_Sub0_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Map_21_7F00_CommentEditor_Sub0_Init::
    INCBIN "data/bank_21/Map_21_7F00_CommentEditor_Sub0_Init.tilemap" ; $7F00, 256 bytes

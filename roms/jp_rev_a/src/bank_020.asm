; Pocket Camera (Japan) (Rev A), bank $20. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $020", ROMX[$4000], BANK[$20]

; C: copied to VRAM/WRAM by Mode08_State14_CreditsPageB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_20_4000_Mode08_State14_CreditsPageB::
    INCBIN "data/bank_20/Gfx_20_4000_Mode08_State14_CreditsPageB.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State14_CreditsPageB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_20_4800_Mode08_State14_CreditsPageB::
    INCBIN "data/bank_20/Gfx_20_4800_Mode08_State14_CreditsPageB.2bpp" ; $4800, 1536 bytes
; C: copied to VRAM/WRAM by Mode08_State0C_RecordInit, Mode08_State0F_HiScoreInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes
; 08 (tcrf_check/assets/l3_names/)
Gfx_20_4E00_Mode08_State0C_RecordInit::
    INCBIN "data/bank_20/Gfx_20_4E00_Mode08_State0C_RecordInit.2bpp" ; $4E00, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State0C_RecordInit, Mode08_State0F_HiScoreInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes
; 08 (tcrf_check/assets/l3_names/)
Gfx_20_5600_Mode08_State0C_RecordInit::
    INCBIN "data/bank_20/Gfx_20_5600_Mode08_State0C_RecordInit.2bpp" ; $5600, 1280 bytes
; C: copied to VRAM/WRAM by Mode08_State06_EditorInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_20_5B00_Mode08_State06_EditorInit::
    INCBIN "data/bank_20/Gfx_20_5B00_Mode08_State06_EditorInit.2bpp" ; $5B00, 1408 bytes
; C: copied to VRAM/WRAM by Mode08_State06_EditorInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_20_6080_Mode08_State06_EditorInit::
    INCBIN "data/bank_20/Gfx_20_6080_Mode08_State06_EditorInit.2bpp" ; $6080, 1088 bytes
; C: far pointer loaded by Kb_Page0_Press, OwnerCard_LoadGenderTiles (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 32 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes
; 08 (tcrf_check/assets/l3_names/)
Gfx_20_64C0_OwnerCard_LoadGenderTiles::
    INCBIN "data/bank_20/Gfx_20_64C0_OwnerCard_LoadGenderTiles.2bpp" ; $64C0, 96 bytes
; C: far pointer loaded by OwnerCard_DrawBloodLow (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 32 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Src_20_6520_OwnerCard_DrawBloodLow::
    INCBIN "data/bank_20/Src_20_6520_OwnerCard_DrawBloodLow.bin" ; $6520, 4 bytes
; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 58 tiles. L3 pass 2026-10-26: read in BGB in 3 replay(s)
; of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousStampsJpn_20_6524::
    INCBIN "data/bank_20/Sheet_MiscellaneousStampsJpn_20_6524.bin" ; $6524, 316 bytes
; C: far pointer loaded by OwnerCard_LoadBirthNumberTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Src_20_6660_OwnerCard_LoadBirthNumberTiles::
    INCBIN "data/bank_20/Src_20_6660_OwnerCard_LoadBirthNumberTiles.bin" ; $6660, 32 bytes
; C: far pointer loaded by OwnerCard_LoadBloodTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Gfx_20_6680_OwnerCard_LoadBloodTiles::
    db $00, $00, $00, $00, $00, $00, $07, $07, $0c, $0c, $0c, $0c, $0c, $0c, $01, $01
    db $00, $00, $00, $00, $00, $00, $80, $80, $c0, $c0, $c0, $c0, $c0, $c0, $80, $80
    db $03, $03, $03, $03, $00, $00, $03, $03, $03, $03

    ; padding
    ds $16, $00

; C: inside the 0x300 bytes 64C0-67C0 that Kb_Page0_Press copies to $8800 (copy site 09:5CF9); was Gfx_20_66C0_Unref
Gfx_20_66C0_Kb_Page0_Press::
    INCBIN "data/bank_20/Gfx_20_66C0_Kb_Page0_Press.2bpp" ; $66C0, 256 bytes
; C: copied to VRAM/WRAM by Mode08_State06_EditorInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_20_67C0_Mode08_State06_EditorInit::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $7c, $82, $c6, $fe, $fe
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $fe, $00, $00, $00, $00

    ; padding
    ds $20, $00

; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_6800_Mode15_State01_TimerInit::
    INCBIN "data/bank_20/Gfx_20_6800_Mode15_State01_TimerInit.2bpp" ; $6800, 1600 bytes
; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_6E40_Mode15_State01_TimerInit::
    INCBIN "data/bank_20/Gfx_20_6E40_Mode15_State01_TimerInit.2bpp" ; $6E40, 128 bytes
; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_6EC0_Mode15_State01_TimerInit::
    INCBIN "data/bank_20/Gfx_20_6EC0_Mode15_State01_TimerInit.2bpp" ; $6EC0, 96 bytes
; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_6F20_Mode15_State01_TimerInit::
    INCBIN "data/bank_20/Gfx_20_6F20_Mode15_State01_TimerInit.2bpp" ; $6F20, 448 bytes
; C: digit table: Mode15_DrawTwoDigitsInterval (06:43F3) copies 16 bytes (1 tile) from $70E0 + digit x 16; 10 entries
; = 70E0-7180, rendered as the digits 0-9; was named Map_ and Gfx_20_70F0_..._Aux
Gfx_20_70E0_Mode15_DrawTwoDigitsInterval::
    INCBIN "data/bank_20/Gfx_20_70E0_Mode15_DrawTwoDigitsInterval.2bpp" ; $70E0, 160 bytes
; C: numeral table: Mode15_DrawTwoDigits (06:43BC) splits A into tens and units and copies 32 bytes from $7180 + digit
; x 32; 10 entries = 7180-72C0 (the next asset starts there); was Gfx_20_71A0_..._Aux
Gfx_20_7180_Mode15_DrawTwoDigits::
    INCBIN "data/bank_20/Gfx_20_7180_Mode15_DrawTwoDigits.2bpp" ; $7180, 320 bytes
; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_72C0_Mode15_State01_TimerInit::
    db $07, $07, $19, $1e, $24, $3b, $48, $77, $40, $7f, $90, $ef, $90, $ef, $80, $ff
    db $e0, $e0, $f8, $f8, $fc, $1c, $fe, $8e, $fe, $46, $ff, $a7, $ff, $a7, $ff, $47
    db $07, $07, $1f, $1f, $3e, $2f, $7e, $5f, $7c, $5f, $fc, $9f, $fc, $bf, $fc, $bf
    db $e0, $e0, $18, $f8, $14, $ec, $02, $fe, $22, $de, $21, $df, $01, $ff, $11, $ef
    db $07, $07, $1f, $1f, $3f, $2f, $7f, $4f, $7f, $4f, $ff, $8f, $ff, $9f, $ff, $9f
    db $e0, $e0, $98, $f8, $8c, $f4, $8c, $f4, $82, $fe, $86, $fa, $85, $fb, $85, $fb
    db $07, $07, $1f, $1f, $3f, $23, $7f, $51, $7f, $79, $ff, $a9, $ff, $a9, $ff, $a9
    db $e0, $e0, $d8, $f8, $c4, $fc, $e2, $fe, $e2, $fe, $f1, $ff, $f1, $ff, $f1, $ff
    db $88, $f7, $84, $fb, $81, $fe, $40, $7f, $40, $7f, $30, $3f, $1f, $1f, $07, $07
    db $ff, $8f, $ff, $1f, $f3, $ff, $ca, $fe, $36, $fe, $cc, $fc, $38, $f8, $e0, $e0
    db $fc, $bf, $fc, $ff, $fc, $ff, $6c, $7f, $4e, $7f, $2e, $3f, $1f, $1f, $07, $07
    db $11, $ef, $01, $ff, $07, $f9, $02, $fe, $02, $fe, $04, $fc, $18, $f8, $e0, $e0
    db $ff, $9f, $ff, $bf, $fd, $ff, $71, $7f, $4d, $7f, $33, $3f, $1f, $1f, $07, $07
    db $81, $ff, $83, $fd, $81, $ff, $82, $fe, $82, $fe, $84, $fc, $98, $f8, $e0, $e0
    db $ff, $b3, $ff, $c7, $ff, $ff, $7c, $7f, $43, $7f, $3e, $3f, $19, $1f, $07, $07
    db $f1, $ff, $f1, $ff, $31, $ff, $a2, $fe, $62, $fe, $c4, $fc, $d8, $f8, $e0, $e0
    db $00, $00, $ff, $ff, $ff, $80, $c0, $bf, $c0, $bf, $c4, $bb, $c0, $bf, $c0, $bf
    db $00, $00, $fe, $fe, $fe, $02, $06, $fb, $06, $fb, $46, $bb, $06, $fb, $06, $fb
    db $c8, $b7, $c7, $b8, $c0, $bf, $c0, $bf, $ff, $80, $ff, $ff, $00, $7f, $00, $7f
    db $26, $db, $c6, $3b, $1e, $ff, $1c, $f7, $f8, $1f, $f0, $fe, $00, $fc, $00, $f8
    db $e0, $e0, $f8, $98, $fe, $86, $ff, $81, $fe, $87, $f8, $9e, $e0, $f8, $00, $e0
    db $00, $00, $00, $00, $ef, $f7, $eb, $f7, $eb, $f7, $fe, $f3, $ff, $f0, $df, $e0
    db $00, $00, $00, $00, $ff, $ff, $fb, $fc, $ff, $f8, $3d, $fb, $ff, $3f, $bd, $7e
    db $00, $00, $00, $00, $ff, $0f, $ff, $07, $1f, $e7, $bf, $c7, $ff, $0f, $fb, $07
    db $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $7f, $7f
    db $7b, $87, $ef, $1f, $ff, $3f, $ff, $7f, $bf, $7f, $e3, $1c, $ff, $80, $e3, $ff
    db $f7, $f8, $fe, $f1, $f8, $ff, $fb, $fc, $1a, $fd, $db, $3c, $3d, $fe, $ff, $ff
    db $9d, $63, $f7, $f9, $7f, $f9, $ff, $39, $6d, $93, $7f, $83, $f7, $0f, $1f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $fe

    ; padding
    ds $60, $00

; C: copied to VRAM/WRAM by Mode15_State01_TimerInit, Mode15_State05_IntervalInit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 25 replay(s) of the organic corpus, modes
; 15 (tcrf_check/assets/l3_names/)
Gfx_20_74F0_Mode15_State01_TimerInit::
    INCBIN "data/bank_20/Gfx_20_74F0_Mode15_State01_TimerInit.2bpp" ; $74F0, 16 bytes
; C: copied to VRAM/WRAM by Mode1D_State01_LoadScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 11 replay(s) of the organic corpus, modes 1D (tcrf_check/assets/l3_names/)
Gfx_20_7500_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_20/Gfx_20_7500_Mode1D_State01_LoadScreen.2bpp" ; $7500, 2048 bytes
; C: copied to VRAM/WRAM by Mode1D_State01_LoadScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 11 replay(s) of the organic corpus, modes 1D (tcrf_check/assets/l3_names/)
Gfx_20_7D00_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_20/Gfx_20_7D00_Mode1D_State01_LoadScreen.2bpp" ; $7D00, 768 bytes

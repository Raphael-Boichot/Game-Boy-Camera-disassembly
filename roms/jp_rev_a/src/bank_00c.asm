; Pocket Camera (Japan) (Rev A), bank $0C. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00c", ROMX[$4000], BANK[$c]

; C: copied to VRAM/WRAM by Mode12_State00_Init, Mode12_State13_TestEnd, Mode12_State22_BorderPickerReturn
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes
; 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4000_Mode12_State00_Init::
    INCBIN "data/bank_0c/Gfx_0C_4000_Mode12_State00_Init.2bpp" ; $4000, 1280 bytes
; C: far pointer loaded by Mode12_State1F_SortDialogClose (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4500_Mode12_State1F_SortDialogClose::
    INCBIN "data/bank_0c/Gfx_0C_4500_Mode12_State1F_SortDialogClose.2bpp" ; $4500, 256 bytes
; C: far pointer loaded by Mode12_State16_SaveDialogClose, Mode12_State19_ExitDialogClose,
; Mode12_State1C_ClearDialogClose (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB
; in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4600_Mode12_State16_SaveDialogClose::
    INCBIN "data/bank_0c/Gfx_0C_4600_Mode12_State16_SaveDialogClose.2bpp" ; $4600, 704 bytes
; C: far pointer loaded by Mode12_State03_EditSpeed, Mode12_State0F_ClearAll, Mode12_State10_Pack (ld a,BANK; ld
; hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_48C0_Mode12_State0F_ClearAll::
    INCBIN "data/bank_0c/Gfx_0C_48C0_Mode12_State0F_ClearAll.2bpp" ; $48C0, 96 bytes
; C: far pointer loaded by Mode12_State20_BorderRow (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4920_Mode12_State20_BorderRow::
    INCBIN "data/bank_0c/Gfx_0C_4920_Mode12_State20_BorderRow.2bpp" ; $4920, 48 bytes
; C: far pointer loaded by Mode12_State03_EditSpeed (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4950_Mode12_State03_EditSpeed::
    INCBIN "data/bank_0c/Gfx_0C_4950_Mode12_State03_EditSpeed.2bpp" ; $4950, 784 bytes
; C: far pointer loaded by Mode12_State16_SaveDialogClose, Mode12_State19_ExitDialogClose,
; Mode12_State1C_ClearDialogClose, Mode12_State1F_SortDialogClose (ld a,BANK; ld hl,ADDR; call banked copy/far call).
; L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 ...
Gfx_0C_4C60_Mode12_State16_SaveDialogClose::
    INCBIN "data/bank_0c/Gfx_0C_4C60_Mode12_State16_SaveDialogClose.2bpp" ; $4C60, 240 bytes
; C: far pointer loaded by Mode12_State07_ToolsSlideIn (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4D50_Mode12_State07_ToolsSlideIn::
    INCBIN "data/bank_0c/Gfx_0C_4D50_Mode12_State07_ToolsSlideIn.2bpp" ; $4D50, 672 bytes
; C: far pointer loaded by AnimEd_ShowEntryValue (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_4FF0_AnimEd_ShowEntryValue::
    INCBIN "data/bank_0c/Gfx_0C_4FF0_AnimEd_ShowEntryValue.2bpp" ; $4FF0, 272 bytes
; C: far pointer loaded by AnimEd_LoadEntryThumb, Mode12_State0F_ClearAll, Mode12_State10_Pack (ld a,BANK; ld hl,ADDR;
; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_5100_Mode12_State0F_ClearAll::
    INCBIN "data/bank_0c/Gfx_0C_5100_Mode12_State0F_ClearAll.2bpp" ; $5100, 1024 bytes
; C: far pointer loaded by AnimEd_StartExitTransition, Mode12_State0F_ClearAll, Mode12_State10_Pack (ld a,BANK; ld
; hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_5500_Mode12_State0F_ClearAll::
    INCBIN "data/bank_0c/Gfx_0C_5500_Mode12_State0F_ClearAll.2bpp" ; $5500, 624 bytes
; C: far pointer loaded by AnimEd_ShowLoopFlag (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5770_AnimEd_ShowLoopFlag::
    INCBIN "data/bank_0c/Gfx_0C_5770_AnimEd_ShowLoopFlag.2bpp" ; $5770, 144 bytes
; I: 576 bytes 5800-5A3F, a variant copy of the used block Gfx_0C_4D50_Mode12_State07_ToolsSlideIn (the Animation-
; editor menu labels): 23 of its 36 tiles are exact copies of tiles of 0C:4D50 (tiles 0-3, 5-15 and 20-27 of this span
; = tiles 0-3, 5-15 and 24-31 of the block), 4 tiles (16-19) are blank ...
Gfx_0C_5800_AnimEdMenuLabelsAlt::
    INCBIN "data/bank_0c/Gfx_0C_5800_AnimEdMenuLabelsAlt.2bpp" ; $5800, 576 bytes
; C: entries 0 (5A40 -> $8D50) and 1 (5AC0 -> $8DD0) of AnimEd_LoadMenuTiles_Tbl5DF1: 0x80 bytes each from bank $0C
; (AnimEd_LoadMenuTiles, 03:5DCE; copy site 03:5DED; index $D719); every byte is read in the organic runs (C)
Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1::
    INCBIN "data/bank_0c/Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1.2bpp" ; $5A40, 256 bytes
; C: far pointer loaded by AnimEd_ShowEntryValue (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5B40_AnimEd_ShowEntryValue::
    INCBIN "data/bank_0c/Gfx_0C_5B40_AnimEd_ShowEntryValue.2bpp" ; $5B40, 32 bytes
; C: far pointer loaded by AnimEd_ShowEntryValue (ld a,BANK; ld hl,ADDR; call banked copy/far call) | also entries 3
; (5B80 -> $8ED0) and 4 (5C00 -> $8F50), 0x80 bytes each, of AnimEd_LoadMenuTiles_Tbl5DF1 (03:5DF1). L3 pass
; 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 12 ...
Gfx_0C_5B60_AnimEd_ShowEntryValue::
    INCBIN "data/bank_0c/Gfx_0C_5B60_AnimEd_ShowEntryValue.2bpp" ; $5B60, 288 bytes
; C: far pointer loaded by AnimEd_ShowLoopFlag (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26:
; read in BGB in 1 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5C80_AnimEd_ShowLoopFlag::
    INCBIN "data/bank_0c/Gfx_0C_5C80_AnimEd_ShowLoopFlag.2bpp" ; $5C80, 32 bytes
; C: far pointer loaded by AnimEd_Ctx0_Decor, AnimEd_ShowLoopFlag (ld a,BANK; ld hl,ADDR; call banked copy/far call).
; L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5CA0_AnimEd_Ctx0_Decor::
    INCBIN "data/bank_0c/Gfx_0C_5CA0_AnimEd_Ctx0_Decor.2bpp" ; $5CA0, 32 bytes
; C: far pointer loaded by AnimEd_Ctx0_Decor, AnimEd_ShowLoopFlag (ld a,BANK; ld hl,ADDR; call banked copy/far call).
; L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5CC0_AnimEd_Ctx0_Decor::
    INCBIN "data/bank_0c/Gfx_0C_5CC0_AnimEd_Ctx0_Decor.2bpp" ; $5CC0, 128 bytes
; C: far pointer loaded by Mode12_State03_EditSpeed, Mode12_State22_BorderPickerReturn (ld a,BANK; ld hl,ADDR; call
; banked copy/far call). L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_5D40_Mode12_State22_BorderPickerReturn::
    INCBIN "data/bank_0c/Gfx_0C_5D40_Mode12_State22_BorderPickerReturn.2bpp" ; $5D40, 48 bytes
; C: far pointer loaded by Mode12_State01_Browse, Mode12_State09_RangeBrowse, Mode12_State20_BorderRow (ld a,BANK; ld
; hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_5D70_Mode12_State01_Browse::
    INCBIN "data/bank_0c/Gfx_0C_5D70_Mode12_State01_Browse.2bpp" ; $5D70, 48 bytes
; C: far pointer loaded by Mode12_State01_Browse, Mode12_State09_RangeBrowse, Mode12_State22_BorderPickerReturn (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5DA0_Mode12_State01_Browse::
    INCBIN "data/bank_0c/Gfx_0C_5DA0_Mode12_State01_Browse.2bpp" ; $5DA0, 192 bytes
; C: far pointer loaded by AnimEd_CopyDigitTile (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Src_0C_5E60_AnimEd_CopyDigitTile::
    INCBIN "data/bank_0c/Src_0C_5E60_AnimEd_CopyDigitTile.bin" ; $5E60, 320 bytes
; C: far pointer loaded by AnimEd_ShowEntryValue (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5FA0_AnimEd_ShowEntryValue::
    INCBIN "data/bank_0c/Gfx_0C_5FA0_AnimEd_ShowEntryValue.2bpp" ; $5FA0, 64 bytes
; C: far pointer loaded by Mode12_State04_ToggleLoop (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_5FE0_Mode12_State04_ToggleLoop::
    INCBIN "data/bank_0c/Gfx_0C_5FE0_Mode12_State04_ToggleLoop.2bpp" ; $5FE0, 32 bytes
; C: far pointer loaded by Mode12_State04_ToggleLoop (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 12)
Gfx_0C_6000_Mode12_State04_ToggleLoop::
    INCBIN "data/bank_0c/Gfx_0C_6000_Mode12_State04_ToggleLoop.2bpp" ; $6000, 32 bytes
; C: far pointer loaded by AnimEd_Ctx0_Decor (ld a,BANK; ld hl,ADDR; call banked copy/far call) | also entry 2 (6100
; -> $8E50, 0x80 bytes) of AnimEd_LoadMenuTiles_Tbl5DF1 (03:5DF1). L3 pass 2026-10-26: read in BGB in 23 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_6020_AnimEd_Ctx0_Decor::
    INCBIN "data/bank_0c/Gfx_0C_6020_AnimEd_Ctx0_Decor.2bpp" ; $6020, 352 bytes
; C: far pointer loaded by Mode12_State14_SaveDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 992 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_6180_Mode12_State14_SaveDialogOpen::
    INCBIN "data/bank_0c/Gfx_0C_6180_Mode12_State14_SaveDialogOpen.2bpp" ; $6180, 992 bytes
; C: far pointer loaded by Mode12_State1A_ClearDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 880 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_6560_Mode12_State1A_ClearDialogOpen::
    INCBIN "data/bank_0c/Gfx_0C_6560_Mode12_State1A_ClearDialogOpen.2bpp" ; $6560, 464 bytes
; C: far pointer loaded by Mode12_State17_ExitDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 896 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_6730_Mode12_State17_ExitDialogOpen::
    INCBIN "data/bank_0c/Gfx_0C_6730_Mode12_State17_ExitDialogOpen.2bpp" ; $6730, 416 bytes
; C: kana strips of the Animation-editor dialogs (by eye); 68D0-6AB0 is inside the 0x380 bytes that
; Mode12_State17_ExitDialogOpen copies from 6730 (copy site 03:4F62), so the tiles are loaded. L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Gfx_0C_68D0_AnimEdKanaStrips::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $02, $02
    db $00, $ff, $00, $00, $00, $00, $0f, $0f, $08, $08, $0b, $0b, $fb, $fb, $03, $03
    db $00, $ff, $00, $00, $00, $00, $ef, $e0, $3f, $3f, $80, $80, $af, $8f, $8f, $8f
    db $00, $ff, $00, $00, $00, $00, $ff, $03, $fc, $fc, $01, $01, $fd, $fd, $fd, $fd
    db $00, $ff, $00, $00, $00, $00, $ef, $ef, $10, $10, $c7, $c7, $d7, $c7, $d7, $c7
    db $00, $ff, $00, $00, $00, $00, $c0, $c0, $40, $40, $40, $40, $70, $40, $7c, $40
    db $02, $02, $02, $02, $06, $02, $0e, $02, $1f, $01, $3e, $02, $7c, $04, $fe, $02
    db $ff, $ff, $ff, $ff, $ff, $ff, $1f, $1f, $3f, $3f, $7f, $7f, $fb, $fb, $73, $73
    db $ef, $ef, $ee, $ee, $ee, $ee, $80, $80, $9f, $9f, $bf, $a1, $b2, $a2, $a2, $a2
    db $fd, $fd, $1d, $1d, $dd, $1d, $5d, $1d, $5c, $1c, $1c, $1c, $3c, $3c, $fc, $fc
    db $d7, $c7, $d7, $c7, $d7, $c7, $c7, $c7, $0f, $0f, $1f, $1f, $3e, $3e, $7c, $7c
    db $7e, $40, $7e, $40, $7f, $40, $7f, $40, $7f, $40, $7f, $40, $7f, $40, $fe, $80
    db $00, $00, $01, $00, $01, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00
    db $ff, $01, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fe, $00, $7c, $00, $00, $00
    db $23, $23, $8b, $8b, $d4, $54, $a3, $23, $00, $00, $00, $00, $00, $00, $7f, $7f
    db $a2, $a2, $a2, $a2, $22, $22, $e3, $e3, $00, $00, $03, $00, $0f, $00, $7f, $7f
    db $f9, $f9, $f3, $f2, $07, $04, $ff, $f8, $ff, $00, $ff, $00, $ff, $00, $ff, $10
    db $39, $39, $93, $92, $c7, $44, $ef, $28, $ff, $10, $fc, $00, $fe, $7e, $e6, $66
    db $fe, $00, $fc, $00, $f8, $00, $e0, $00, $80, $00, $00, $00, $00, $00, $00, $00
    db $07, $07, $36, $36, $18, $18, $0e, $0e, $00, $00, $00, $00, $00, $00, $00, $00
    db $7f, $07, $7f, $1c, $ff, $3b, $ff, $73, $ff, $00, $ff, $00, $ff, $00, $7f, $00
    db $ff, $7f, $fb, $13, $f3, $13, $f3, $13, $e0, $00, $e0, $00, $f0, $00, $f0, $00
    db $0e, $0e, $18, $18, $00, $00, $18, $18, $00, $00, $00, $00, $00, $00, $00, $00
    db $7f, $00, $3e, $00, $18, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
    db $0f, $00, $3f, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $00, $1f, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fc, $00, $e0, $00
    db $c0, $00, $e0, $00, $e0, $00, $e0, $00, $c0, $00, $80, $00, $00, $00, $00, $00

    ; padding
    ds $150, $00

; I: 3 tiles (48 B) in front of the block that Mode12_State1D_SortDialogOpen (03:503A, copy site 03:503F) copies from
; 6C30 to $8C70; they would be the ids C4-C6 of that set, which the dialog map 27:6D30 does not use (it uses C7-FB);
; no copy site covers them; identical in the international ROM; no other ...
Gfx_0C_6C00_Mode12_State1D_SortDialogOpen_Aux::
    INCBIN "data/bank_0c/Gfx_0C_6C00_Mode12_State1D_SortDialogOpen_Aux.2bpp" ; $6C00, 48 bytes
; C: far pointer loaded by Mode12_State1D_SortDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 880 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_6C30_Mode12_State1D_SortDialogOpen::
    db $86, $79, $e6, $19, $ee, $11, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $26, $d8, $a6, $58, $0e, $f0, $fe, $00, $fe, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $03, $00, $03, $00, $07, $00, $07, $00
    db $07, $00, $07, $00, $03, $00, $03, $00, $01, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $00, $00, $00, $03, $03, $01, $03, $0f, $0f, $0f, $0f, $08, $0f
    db $00, $ff, $00, $00, $00, $00, $c0, $c0, $c0, $c0, $f5, $fb, $f5, $fb, $77, $f8
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $58, $f8, $58, $f8, $f0, $30
    db $08, $0f, $08, $0f, $08, $0f, $08, $0f, $08, $0f, $0f, $0f, $0f, $0f, $03, $00
    db $77, $f8, $f7, $f0, $f7, $f0, $f7, $f0, $f7, $f0, $e5, $f7, $e5, $f7, $c0, $00
    db $f0, $30, $f0, $30, $f0, $30, $f0, $30, $f0, $30, $58, $f8, $58, $f8, $00, $00
    db $1f, $7f, $46, $79, $40, $01, $00, $01, $00, $01, $02, $01, $43, $7f, $7f, $00
    db $df, $3f, $43, $bc, $c0, $81, $c1, $9b, $ca, $9f, $0d, $8e, $ca, $87, $81, $02
    db $85, $de, $de, $df, $87, $de, $46, $8f, $8e, $1f, $1c, $36, $12, $3d, $3f, $19
    db $41, $83, $61, $c3, $07, $63, $26, $cf, $7a, $cc, $cc, $78, $ec, $df, $4b, $87
    db $8e, $04, $04, $ec, $e4, $ec, $4c, $ac, $0c, $0c, $0c, $1c, $3c, $e7, $63, $87
    db $00, $00, $00, $00, $00, $00, $10, $00, $20, $10, $e0, $30, $50, $e0, $20, $80
    db $00, $00, $04, $c0, $cc, $c4, $06, $6c, $74, $3e, $be, $5e, $bf, $7e, $0f, $3e
    db $08, $06, $00, $00, $07, $06, $19, $19, $27, $27, $2f, $2f, $5f, $5f, $5f, $5f
    db $00, $00, $00, $00, $c0, $c0, $f0, $f0, $f8, $f8, $ec, $ec, $ec, $ec, $9e, $fe
    db $5e, $5e, $7e, $7e, $7d, $7f, $3b, $3b, $3b, $3b, $1f, $1f, $0f, $0f, $03, $03
    db $7e, $7a, $7a, $7a, $fa, $fa, $f1, $f7, $f3, $f4, $ef, $ec, $1f, $1b, $ef, $ef
    db $00, $00, $00, $00, $00, $00, $f8, $fe, $f0, $48, $f8, $48, $f8, $fe, $f8, $fe
    db $00, $00, $00, $00, $00, $00, $0d, $00, $19, $00, $19, $00, $39, $00, $39, $00
    db $00, $00, $00, $00, $00, $00, $fd, $00, $fd, $00, $f0, $00, $f3, $00, $fb, $00
    db $00, $00, $00, $00, $00, $00, $ff, $00, $9d, $00, $cd, $00, $e9, $00, $b9, $00
    db $00, $00, $00, $00, $00, $00, $fc, $00, $9e, $00, $ce, $00, $e7, $00, $e7, $00
    db $39, $00, $39, $00, $1c, $00, $1f, $00, $0f, $00, $00, $00, $00, $00, $00, $00
    db $d2, $00, $92, $00, $3e, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $39, $00, $9c, $00, $2e, $00, $ff, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $67, $00, $6f, $00, $7e, $00, $fe, $00, $fc, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $06, $20, $06, $20, $40, $20, $40, $20, $40, $20
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $00, $02, $2c, $24, $1a, $42, $28
    db $00, $00, $00, $00, $00, $00, $20, $10, $20, $10, $00, $20, $00, $38, $5c, $20
    db $00, $00, $00, $00, $00, $00, $85, $48, $a6, $08, $01, $be, $0c, $80, $24, $98
    db $00, $00, $00, $00, $00, $00, $10, $20, $80, $20, $60, $00, $20, $50, $10, $68
    db $00, $00, $00, $00, $00, $00, $02, $0c, $05, $02, $10, $08, $12, $0c, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $58, $00, $00, $4f, $15, $c8, $42, $89
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $00, $80, $29, $ac, $11, $05, $10
    db $00, $00, $00, $00, $00, $00, $0e, $00, $61, $1e, $63, $00, $01, $02, $00, $02
    db $00, $00, $00, $00, $00, $00, $00, $28, $00, $28, $40, $28, $60, $08, $10, $48
    db $00, $00, $00, $00, $00, $00, $70, $00, $78, $00, $78, $00, $7c, $00, $7c, $00
    db $40, $21, $15, $22, $20, $1c, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $60, $1e, $24, $08, $18, $00, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $2c, $40, $06, $48, $88, $46, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $40, $ac, $80, $6e, $40, $3a, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $90, $48, $56, $88, $02, $8c, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $09, $06, $10, $0c, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $0b, $84, $00, $04, $00, $04, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $10, $02, $0a, $04, $00, $18, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $02, $04, $04, $08, $08, $10, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $10, $48, $d4, $0a, $10, $8c, $00, $00, $ff, $00, $00, $00, $00, $00, $00, $00
    db $7c, $00, $7c, $00, $78, $00, $78, $00, $70, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff

    ; padding
    ds $1e, $00

; C: far pointer loaded by Mode12_State1D_SortDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 656 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Gfx_0C_6FA0_Mode12_State1D_SortDialogOpen::
    db $00, $00, $00, $00, $00, $00, $f7, $08, $01, $fe, $f7, $08, $86, $79, $a7, $58
    db $00, $00, $00, $00, $00, $00, $0e, $f0, $9e, $60, $7e, $80, $0e, $f0, $e6, $18
    db $bf, $40, $3f, $c0, $3e, $c1, $3e, $c1, $3f, $c0, $3a, $c5, $32, $cd, $87, $78
    db $bf, $40, $b3, $4c, $19, $e6, $7d, $82, $77, $88, $47, $b8, $53, $ac, $c5, $3a
    db $ff, $00, $b3, $4c, $b9, $46, $3c, $c3, $3c, $c3, $2c, $d3, $8d, $72, $cf, $30
    db $08, $f7, $fe, $01, $08, $f7, $79, $86, $58, $a7, $79, $86, $19, $e6, $11, $ee
    db $f1, $0e, $61, $9e, $81, $7e, $f1, $0e, $19, $e6, $d9, $26, $59, $a6, $f1, $0e
    db $20, $26, $60, $26, $20, $60, $20, $60, $20, $60, $23, $61, $6a, $37, $1e, $3c
    db $10, $00, $04, $08, $2c, $2e, $5b, $3e, $3d, $6a, $1e, $7e, $48, $2c, $00, $18
    db $10, $30, $10, $30, $30, $20, $7c, $38, $20, $7c, $52, $6c, $e9, $4e, $46, $ce
    db $4a, $cd, $09, $ae, $fe, $bf, $c0, $8c, $d8, $bc, $ac, $ec, $7e, $ee, $bb, $7a
    db $a0, $30, $30, $a0, $00, $60, $58, $70, $e8, $78, $68, $d8, $88, $de, $cc, $8e
    db $0c, $0e, $0a, $07, $0c, $18, $0c, $1e, $00, $00, $03, $01, $16, $0f, $0e, $1c
    db $50, $00, $00, $58, $4f, $4f, $e8, $dd, $9d, $cb, $84, $8f, $04, $04, $06, $04
    db $00, $00, $01, $08, $39, $a9, $11, $bd, $12, $15, $07, $12, $04, $0e, $1c, $18
    db $00, $0e, $1e, $7f, $10, $63, $02, $03, $02, $02, $04, $06, $08, $0c, $30, $18
    db $2c, $28, $2c, $28, $3c, $68, $18, $68, $68, $58, $69, $58, $0a, $de, $cc, $9c
    db $fc, $f8, $f1, $f8, $f8, $f1, $f0, $f1, $f0, $d1, $90, $91, $99, $f0, $78, $98
    db $98, $64, $68, $94, $de, $60, $66, $68, $e6, $e8, $46, $e8, $88, $14, $9c, $64
    db $3e, $bc, $4f, $ef, $93, $cf, $cc, $f4, $f6, $e5, $bf, $7f, $00, $ff, $ff, $00
    db $38, $0c, $f8, $f8, $f0, $f8, $e0, $b0, $c0, $e0, $c0, $80, $08, $f0, $c0, $00
    db $65, $49, $eb, $a9, $56, $5b, $bb, $b2, $d5, $d4, $18, $18, $10, $13, $00, $00
    db $05, $08, $09, $09, $0a, $13, $15, $14, $0d, $18, $10, $19, $18, $11, $31, $25
    db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $07, $06, $0f, $09, $16, $19
    db $00, $00, $00, $00, $00, $00, $02, $01, $05, $06, $0d, $09, $18, $13, $23, $12
    db $05, $03, $0d, $1e, $6f, $30, $ff, $c0, $ff, $80, $67, $9f, $9f, $78, $ff, $f0
    db $fa, $fc, $fb, $06, $fd, $03, $ff, $01, $fe, $01, $fe, $82, $b4, $6c, $d0, $38
    db $fc, $f8, $f0, $f8, $f8, $f0, $f1, $f0, $f1, $f1, $f0, $f0, $f8, $f0, $f8, $f8
    db $78, $04, $02, $04, $04, $02, $0a, $02, $9a, $fa, $f4, $62, $0a, $04, $1c, $04
    db $fe, $fe, $ff, $ff, $f8, $fc, $f7, $f7, $7f, $ff, $5f, $bf, $00, $ff, $1e, $00
    db $38, $1c, $78, $f8, $38, $30, $b0, $e0, $c0, $c0, $90, $60, $40, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $07, $0f, $07, $03, $01, $00, $04, $03
    db $00, $00, $00, $00, $00, $00, $73, $0f, $fa, $fc, $e0, $c0, $f3, $e1, $e7, $ef
    db $00, $00, $05, $03, $4d, $3e, $bf, $f0, $5d, $63, $bf, $fe, $fc, $fc, $fc, $f8
    db $60, $1f, $c4, $fb, $dc, $23, $e1, $1e, $ff, $ff, $00, $00, $70, $60, $19, $8f
    db $04, $f8, $3e, $fe, $fc, $ff, $fe, $3e, $5e, $ac, $68, $f0, $60, $00, $80, $a0
    db $bf, $7f, $9f, $7f, $03, $01, $1f, $0f, $01, $00, $01, $03, $00, $00, $00, $00
    db $ff, $df, $ff, $ff, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $01, $00, $05, $02
    db $bc, $d8, $a8, $0c, $bc, $fe, $8f, $af, $e3, $ea, $8f, $d8, $70, $ff, $f8, $07
    db $17, $9e, $5c, $4e, $1d, $33, $01, $80, $7f, $ff, $f6, $cf, $74, $f8, $fc, $03
    db $60, $00, $80, $a0, $20, $60, $e0, $c0, $c0, $80, $00, $00, $00, $00, $80, $00

    ; padding
    ds $5d0, $00

; C: copied to VRAM/WRAM by Mode09_State00_Init, Album_ShowPageScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 42 replay(s) of the organic corpus, modes 09 (tcrf_check/assets/l3_names/)
Gfx_0C_7800_Mode09_State00_Init::
    INCBIN "data/bank_0c/Gfx_0C_7800_Mode09_State00_Init.2bpp" ; $7800, 256 bytes
; C: far pointer loaded by Album_LoadSliderScreen (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 45 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_0C_7900_Album_LoadSliderScreen::
    INCBIN "data/bank_0c/Gfx_0C_7900_Album_LoadSliderScreen.2bpp" ; $7900, 48 bytes
; C: far pointer loaded by Mode09_State00_Init, Album_ShowPageScreen, Mode0A_State02_Setup, Album_LoadSliderScreen,
; Mode0D_State06_PlayInit (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 75
; replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_0C_7930_Mode09_State00_Init::
    INCBIN "data/bank_0c/Gfx_0C_7930_Mode09_State00_Init.2bpp" ; $7930, 112 bytes
; C: far pointer loaded by Album_LoadSliderScreen, Mode0A_State02_Setup (ld a,BANK; ld hl,ADDR; call banked copy/far
; call). L3 pass 2026-10-26: read in BGB in 75 replay(s) of the organic corpus, modes 09 0A
; (tcrf_check/assets/l3_names/)
Gfx_0C_79A0_Mode0A_State02_Setup::
    INCBIN "data/bank_0c/Gfx_0C_79A0_Mode0A_State02_Setup.2bpp" ; $79A0, 352 bytes
; C: copied to VRAM/WRAM by Mode09_State00_Init, Album_ShowPageScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 42 replay(s) of the organic corpus, modes 09 (tcrf_check/assets/l3_names/)
Gfx_0C_7B00_Mode09_State00_Init::
    INCBIN "data/bank_0c/Gfx_0C_7B00_Mode09_State00_Init.2bpp" ; $7B00, 256 bytes
; C: far pointer loaded by Album_LoadSliderScreen (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 45 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_0C_7C00_Album_LoadSliderScreen::
    INCBIN "data/bank_0c/Gfx_0C_7C00_Album_LoadSliderScreen.2bpp" ; $7C00, 512 bytes
; C: numeral table: Album_LoadNumeralTile (04:6F80) copies 32 bytes (2 tiles, 8 x 16 pixels) from $7E00 + A x 32 (swap
; a / sla c / rl b); entries 0-9 are the digits (rendered); the types extent to 7F80 is 12 entries, entries 10-11 are
; not explained; the second half was ...
Gfx_0C_7E00_Album_LoadNumeralTile::
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $e3, $ff, $d9, $ff, $98, $ff
    db $98, $ff, $98, $ff, $98, $ff, $80, $ff, $98, $ff, $98, $ff, $98, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $01, $ff, $18, $ff, $18, $ff
    db $18, $ff, $01, $ff, $18, $ff, $18, $ff, $18, $ff, $18, $ff, $01, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c1, $ff, $b9, $ff, $b9, $ff
    db $b9, $ff, $b9, $ff, $b9, $ff, $b9, $ff, $b9, $ff, $b9, $ff, $81, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $87, $ff, $e7, $ff, $e7, $ff
    db $e7, $ff, $e7, $ff, $e7, $ff, $e7, $ff, $e7, $ff, $e7, $ff, $81, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c3, $ff, $99, $ff, $99, $ff
    db $99, $ff, $f9, $ff, $f3, $ff, $e7, $ff, $cf, $ff, $9f, $ff, $81, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $83, $ff, $f9, $ff, $f9, $ff
    db $f9, $ff, $c3, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $83, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $d9, $ff, $99, $ff, $99, $ff
    db $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81, $ff, $f9, $ff, $f9, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c1, $ff, $9f, $ff, $9f, $ff
    db $9f, $ff, $83, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $83, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c1, $ff, $9f, $ff, $9f, $ff
    db $9f, $ff, $83, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $c3, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c1, $ff, $99, $ff, $99, $ff
    db $99, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c3, $ff, $99, $ff, $99, $ff
    db $99, $ff, $c3, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $c3, $ff, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $c3, $ff, $99, $ff, $99, $ff
    db $99, $ff, $c1, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $f9, $ff, $ff, $ff

    ; padding
    ds $50, $00

; C: copied to VRAM/WRAM by Mode09_State00_Init, Album_ShowPageScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 42 replay(s) of the organic corpus, modes 09 (tcrf_check/assets/l3_names/)
Gfx_0C_7FD0_Mode09_State00_Init::
    INCBIN "data/bank_0c/Gfx_0C_7FD0_Mode09_State00_Init.2bpp" ; $7FD0, 48 bytes

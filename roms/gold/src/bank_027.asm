; Game Boy Camera Gold (USA), bank $27. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $027", ROMX[$4000], BANK[$27]

; C: loaded by Mem_CopyFromBank at 00:317A: Gfx $800 bytes to $9000 (this build's trace)
Gfx_27_4000_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_27/Gfx_27_4000_Mode1D_State01_LoadScreen.2bpp" ; $4000, 2048 bytes
; C: loaded by Mem_CopyFromBank at 00:3188: Gfx $400 bytes to $8800 (this build's trace)
Gfx_27_4800_Mode1D_State01_LoadScreen::
    INCBIN "data/bank_27/Gfx_27_4800_Mode1D_State01_LoadScreen.2bpp" ; $4800, 1024 bytes
; C: frame 2 of the dancing man (Kentaro Nishimura, credited CORDINATOR (sic) and SOUND COMPOSER; the "Miyamoto"
; attribution found on the web is an error: owner) of the short credits: {lo,hi,bank,duration} table 09:5145 (4
; records, 8 frames each), 0x470 bytes copied to $9000 by ...
Gfx_27_4C00_CreditsNishimuraDanceFrame02::
    INCBIN "data/bank_27/Gfx_27_4C00_CreditsNishimuraDanceFrame02.2bpp" ; $4C00, 1136 bytes
; C: copied to VRAM/WRAM by Album_ShowPageScreen, Album_ShowPageScreenB, Mode0A_State03_SliderBrowse,
; Album_LoadSliderScreen, Album_LoadBorderScreen, Mode0D_State06_PlayInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A ...
Map_27_5070_Mode21_State00_Init::
    INCBIN "data/bank_27/Map_27_5070_Mode21_State00_Init.tilemap" ; $5070, 2 bytes
; C: far pointer loaded by Mode1C_DrawOptionScreen, Mode1C_DrawPrintScreen (ld a,BANK; ld hl,ADDR; call banked
; copy/far call). L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus, modes 09 0A 1C
; (tcrf_check/assets/l3_names/); L3 relabel: loaded here by Mode21_State00_Init (coverage: 64 ...
Map_27_5072_Mode21_State00_Init::
    INCBIN "data/bank_27/Map_27_5072_Mode21_State00_Init.tilemap" ; $5072, 64 bytes
; C: far pointer loaded by Mode17_State08_Split_Build, Mode17_State0E_Fusion_Build, Mode0E_State04_PickDone,
; Mode0E_State0D_PickSecond (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 71
; replay(s), modes 09 0A 1C (states 09:01 0A:03 09:02 1C:03 0A:04), not only by ...
Map_27_50B2_Mode21_State00_Init::
    INCBIN "data/bank_27/Map_27_50B2_Mode21_State00_Init.tilemap" ; $50B2, 81 bytes
; C: BG map: BGB, menu walk node P10 (tcrf_check/tools/guide_nodes.py, the international ROM, same bytes here): its
; first 16 bytes are in VRAM map; read by Mode21_State00_Init
Map_27_5103_Mode21_State00_Init::
    INCBIN "data/bank_27/Map_27_5103_Mode21_State00_Init.tilemap" ; $5103, 45 bytes
; C: loaded by Vram_CopyFromBank at 09:617D: Map $40 bytes to $98C0 (this build's trace)
Map_27_5130_PickCharacter_BlinkRows::
    INCBIN "data/bank_27/Map_27_5130_PickCharacter_BlinkRows.tilemap" ; $5130, 64 bytes
; C: BG map: BGB, menu walk node P10 (tcrf_check/tools/guide_nodes.py, the international ROM, same bytes here): its
; first 16 bytes are in VRAM map; read by Mode21_State00_Init
Map_27_5170_Mode21_State00_Init::
    INCBIN "data/bank_27/Map_27_5170_Mode21_State00_Init.tilemap" ; $5170, 320 bytes
; C: loaded by Vram_CopyFromBank at 09:618C: Map $40 bytes to $98C0 (this build's trace)
Map_27_52B0_PickCharacter_BlinkRows::
    INCBIN "data/bank_27/Map_27_52B0_PickCharacter_BlinkRows.tilemap" ; $52B0, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4E62: Map $240 bytes to $9800 (this build's trace)
Map_27_52F0_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_27/Map_27_52F0_Mode08_State13_CreditsPageA.tilemap" ; $52F0, 128 bytes
; C: loaded by Vram_CopyFromBank at 09:4EBC: Map $40 bytes to $9880 (this build's trace)
Map_27_5370_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_5370_Mode08_State14_CreditsSheriffHelp.tilemap" ; $5370, 256 bytes
; C: loaded by Vram_CopyFromBank at 09:4EE3: Map $40 bytes to $9980 (this build's trace)
Map_27_5470_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_5470_Mode08_State14_CreditsSheriffHelp.tilemap" ; $5470, 32 bytes
; C: tile-map rows read by Mode08_State13_CreditsPageA (66 bytes), ViewMenu_AnimateBackground (34) and
; Mode08_State14_CreditsSheriffHelp; the earlier name Map_27_50B2_Compose_Split_DrawMakeBlink_Part5490 (a part of
; 27:50B2, which another routine loads here)
Map_27_5490_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_27/Map_27_5490_Mode08_State13_CreditsPageA.tilemap" ; $5490, 66 bytes
; I: eight blank rows ($FD) after the 22-row map copied from 27:44B2 and before the map copied from 27:4870; filler;
; L3 copy-descr: copied here by Mode08_State13_CreditsPageA; the descriptive name is kept; bytes equal to us_eu
; 27:54D2; evidence I (2026-11-02): the name says it is unused / never loaded; ...
Map_27_54D2_BlankRows::
    INCBIN "data/bank_27/Map_27_54D2_BlankRows.tilemap" ; $54D2, 94 bytes
; C: loaded by Vram_CopyFromBank at 09:4ECC: Map $40 bytes to $9880 (this build's trace)
Map_27_5530_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_5530_Mode08_State14_CreditsSheriffHelp.tilemap" ; $5530, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4EF3: Map $40 bytes to $9980 (this build's trace)
Map_27_5570_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_5570_Mode08_State14_CreditsSheriffHelp.tilemap" ; $5570, 64 bytes
; C: loaded by Vram_CopyFromBank at 09:4F2D: Map $40 bytes to $9800 (this build's trace)
Map_27_55B0_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_55B0_Mode08_State14_CreditsSheriffHelp.tilemap" ; $55B0, 32 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/); L3 relabel: loaded here by
; Credits_PageB_RowValue (listing: the only routine that names it); the Japanese ...
Map_27_55D0_Credits_PageB_RowValue::
    INCBIN "data/bank_27/Map_27_55D0_Credits_PageB_RowValue.tilemap" ; $55D0, 352 bytes
; C: loaded by Vram_CopyFromBank at 09:4F81: Map $C0 bytes to $9980 (this build's trace)
Map_27_5730_Mode08_State14_CreditsSheriffHelp::
    INCBIN "data/bank_27/Map_27_5730_Mode08_State14_CreditsSheriffHelp.tilemap" ; $5730, 192 bytes
; C: loaded by Vram_CopyFromBank at 09:5004: Map $20 bytes to $9980 (this build's trace)
Map_27_57F0_Mode08_State15_CreditsSheriffBonus::
    INCBIN "data/bank_27/Map_27_57F0_Mode08_State15_CreditsSheriffBonus.tilemap" ; $57F0, 32 bytes
; C: small 2bpp tile set (round shapes, then $FF / $00 filler) read in part only by forced runs; it start. L3 pass
; 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
TileSet_27_5810::
    INCBIN "data/bank_27/TileSet_27_5810.bin" ; $5810, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5A10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5A10_PhotoPicker_PageTransitionPrev.tilemap" ; $5A10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5C10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5C10_PhotoPicker_PageTransitionPrev.tilemap" ; $5C10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_5E10_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_5E10_PhotoPicker_PageTransitionPrev.tilemap" ; $5E10, 512 bytes
; C: far pointer loaded by PhotoPicker_PageTransitionNext, PhotoPicker_PageTransitionPrev, LinkPick_PageTurnNext,
; LinkPick_PageTurnPrev (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from the nearby ld bc. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 0F 11 ...
Map_27_6010_PhotoPicker_PageTransitionPrev::
    INCBIN "data/bank_27/Map_27_6010_PhotoPicker_PageTransitionPrev.tilemap" ; $6010, 512 bytes
; C: 448 bytes = 56 tile masks x 8 bytes (one mask byte per tile row, the same byte for both bit planes), 8 x 7 tiles
; = 64 x 56 pixels; read by Img_AndMaskTiles_Bank27 (00:1569, ld hl,$5BB0) which ANDs it into one quadrant of the
; image buffer ($C000 / $C080 / $C700 / $C780 chosen by $D7E4); drawn as 1 ...
Mask_27_6210_Img_AndMaskTiles_Oval::
    INCBIN "data/bank_27/Mask_27_6210_Img_AndMaskTiles_Oval.bin" ; $6210, 448 bytes
; C: far pointer loaded by Mode1F_State05_Performance (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode ...
Map_27_63D0_Mode1F_State05_Performance::
    INCBIN "data/bank_27/Map_27_63D0_Mode1F_State05_Performance.tilemap" ; $63D0, 224 bytes
; C: far pointer loaded by Mode1F_State06_SavePanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 224
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F); ...
Map_27_64B0_Mode1F_State06_SavePanel::
    INCBIN "data/bank_27/Map_27_64B0_Mode1F_State06_SavePanel.tilemap" ; $64B0, 224 bytes
; C: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 72 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/); C: the bytes changed but
; MainMenu_LoadBackground reads them in this build (coverage call site or ...
Map_27_6590_MainMenu_LoadBackground::
    INCBIN "data/bank_27/Map_27_6590_MainMenu_LoadBackground.tilemap" ; $6590, 448 bytes
; C: target 7 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/); L3 entry:
; entry 7 of the pointer table ViewMenu_AnimateBackground_Map5368 here; the earlier ...
Src_27_6750_ViewMenu_AnimateBackground_7::
    INCBIN "data/bank_27/Src_27_6750_ViewMenu_AnimateBackground_7.bin" ; $6750, 384 bytes
; C: target 6 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 19 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/); L3 entry:
; entry 6 of the pointer table ViewMenu_AnimateBackground_Map5368 here; the earlier ...
Src_27_68D0_ViewMenu_AnimateBackground_6::
    INCBIN "data/bank_27/Src_27_68D0_ViewMenu_AnimateBackground_6.bin" ; $68D0, 384 bytes
; C: target 1 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/); L3 entry:
; entry 1 of the pointer table ViewMenu_AnimateBackground_Map5368 here; the earlier ...
Src_27_6A50_ViewMenu_AnimateBackground_1::
    INCBIN "data/bank_27/Src_27_6A50_ViewMenu_AnimateBackground_1.bin" ; $6A50, 384 bytes
; C: target 2 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/); L3 entry:
; entry 2 of the pointer table ViewMenu_AnimateBackground_Map5368 here; the earlier ...
Src_27_6BD0_ViewMenu_AnimateBackground_2::
    INCBIN "data/bank_27/Src_27_6BD0_ViewMenu_AnimateBackground_2.bin" ; $6BD0, 384 bytes
; C: target 5 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 31 replay(s) of the organic corpus, modes 02 07 (tcrf_check/assets/l3_names/); L3 entry:
; entry 5 of the pointer table ViewMenu_AnimateBackground_Map5368 here; the ...
Src_27_6D50_ViewMenu_AnimateBackground_5::
    INCBIN "data/bank_27/Src_27_6D50_ViewMenu_AnimateBackground_5.bin" ; $6D50, 1002 bytes
; C: read in the coverage run (22 of 22 bytes); call sites ViewMenu_AnimateBackground x8; first-read mode:state 02:01
; x8
Src_27_713A_ViewMenu_AnimateBackground::
    INCBIN "data/bank_27/Src_27_713A_ViewMenu_AnimateBackground.bin" ; $713A, 22 bytes
; C: far pointer loaded by Mode12_State1D_SortDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_7150_Mode12_State1D_SortDialogOpen::
    INCBIN "data/bank_27/Map_27_7150_Mode12_State1D_SortDialogOpen.tilemap" ; $7150, 288 bytes
; C: far pointer loaded by Mode12_State17_ExitDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_7270_Mode12_State17_ExitDialogOpen::
    INCBIN "data/bank_27/Map_27_7270_Mode12_State17_ExitDialogOpen.tilemap" ; $7270, 288 bytes
; C: target 36 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 11)
Src_27_7390_Tbl539D_36::
    INCBIN "data/bank_27/Src_27_7390_Tbl539D_36.bin" ; $7390, 288 bytes
; C: far pointer loaded by SaveDialog_Substate0_Init (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 10 11 1A
; (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_74B0_SaveDialog_Substate0_Init::
    INCBIN "data/bank_27/Map_27_74B0_SaveDialog_Substate0_Init.tilemap" ; $74B0, 288 bytes
; C: far pointer loaded by Stamp_ReloadTilemapIfDifferent (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz, first read in mode ...
Map_27_75D0_Stamp_ReloadTilemapIfDifferent::
    INCBIN "data/bank_27/Map_27_75D0_Stamp_ReloadTilemapIfDifferent.tilemap" ; $75D0, 288 bytes
; C: target 34 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Src_27_76F0_Tbl539D_34::
    INCBIN "data/bank_27/Src_27_76F0_Tbl539D_34.bin" ; $76F0, 288 bytes
; C: target 37 of the {lo,hi,bank} table 04:539D; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: target 37 of
; the stamp-category table 04:539D (Stamp_CatMapSrcTbl)
Src_27_7810_Tbl539D_37::
    INCBIN "data/bank_27/Src_27_7810_Tbl539D_37.bin" ; $7810, 288 bytes
; C: far pointer loaded by Mode12_State14_SaveDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_7930_Mode12_State14_SaveDialogOpen::
    INCBIN "data/bank_27/Map_27_7930_Mode12_State14_SaveDialogOpen.tilemap" ; $7930, 244 bytes
; C: the blocks on both sides are MAP (layout kinds) and the reader is Mode12_State14_SaveDialogOpen: taken as part of
; the same asset; not seen in the BGB menu walk; L3 shared: read here by Mode12_State14_SaveDialogOpen (88); the name
; gives one consumer (read sites of the interrupt-safe coverage replay, ...
Map_27_7A24_Mode12_State14_SaveDialogOpen::
    INCBIN "data/bank_27/Map_27_7A24_Mode12_State14_SaveDialogOpen.tilemap" ; $7A24, 44 bytes
; C: far pointer loaded by Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7A50_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7A50_Mode1A_State09_ExitDialog.tilemap" ; $7A50, 128 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceB (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/); L3 loader: HotSpotEd_DialogChoiceB loads it in this build ...
Map_27_7AD0_HotSpotEd_DialogChoiceB::
    INCBIN "data/bank_27/Map_27_7AD0_HotSpotEd_DialogChoiceB.tilemap" ; $7AD0, 96 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceB, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_7B30_Mode1A_State09_ExitDialog::
    INCBIN "data/bank_27/Map_27_7B30_Mode1A_State09_ExitDialog.tilemap" ; $7B30, 64 bytes
; C: far pointer loaded by Mode1A_State03_Browse (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 288 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7B70_Mode1A_State03_Browse::
    INCBIN "data/bank_27/Map_27_7B70_Mode1A_State03_Browse.tilemap" ; $7B70, 128 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7BF0_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_7BF0_HotSpotEd_DialogChoiceA.tilemap" ; $7BF0, 96 bytes
; C: far pointer loaded by HotSpotEd_DialogChoiceA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Map_27_7C50_HotSpotEd_DialogChoiceA::
    INCBIN "data/bank_27/Map_27_7C50_HotSpotEd_DialogChoiceA.tilemap" ; $7C50, 64 bytes
; C: far pointer loaded by Mode12_State1A_ClearDialogOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call); length
; 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/); C: the bytes changed but ...
Map_27_7C90_Mode12_State1A_ClearDialogOpen::
    INCBIN "data/bank_27/Map_27_7C90_Mode12_State1A_ClearDialogOpen.tilemap" ; $7C90, 244 bytes
; C: the blocks on both sides are MAP (layout kinds) and the reader is PhotoPicker_PageTransitionNext: taken as part
; of the same asset; not seen in the BGB menu walk; L3 relabel-top: read here by Mode12_State1A_ClearDialogOpen (44),
; not by PhotoPicker_PageTransitionNext; the earlier name ...
Map_27_7D84_Mode12_State1A_ClearDialogOpen::
    INCBIN "data/bank_27/Map_27_7D84_Mode12_State1A_ClearDialogOpen.tilemap" ; $7D84, 44 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F); C: the 192 bytes of the Japanese type row ...
Map_27_7DB0_Mode1F_State08_EditPagesSetup::
    db $60, $61, $62, $63, $64, $65, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $66, $67, $68, $69, $6a, $6b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $8d, $8e, $8f, $9d, $9e, $9f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $3b, $3c, $3d, $3e, $fe, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $4b, $4c, $4d, $4e, $4f, $bd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fa, $fa, $fa, $fa, $fa, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $190, $00

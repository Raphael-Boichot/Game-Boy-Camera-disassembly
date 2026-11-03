; Game Boy Camera Gold (USA), bank $15. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

; C: copied to VRAM/WRAM by MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4000_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4000_MainMenu_LoadBackground.2bpp" ; $4000, 1152 bytes
; I: TCRF unused graphic: the circled X tile of the Japanese main-menu bank (copy 1 of 3, same tile at 15:4500 and
; 15:4580); on screen only in forced runs (README 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it
; (read in BGB in 203 replay(s) of the organic corpus, modes 00) but never ...
Unused_TCRF_JapaneseMenuTile_CircledX_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Gfx.2bpp" ; $4480, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4490_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4490_MainMenu_LoadBackground_Cont.2bpp" ; $4490, 112 bytes
; I: TCRF unused graphic: circled X, copy 2 of 3. L3 pass 2026-10-26: copied to VRAM with the block around it (read in
; BGB in 203 replay(s) of the organic corpus, modes 00) but never displayed, as TCRF says; the verdict stays final I;
; L3 unref: no routine of this build names it; bytes equal to us_eu ...
Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy2_Gfx.2bpp" ; $4500, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4510_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4510_MainMenu_LoadBackground_Cont.2bpp" ; $4510, 112 bytes
; I: TCRF unused graphic: circled X, copy 3 of 3. L3 pass 2026-10-26: copied to VRAM with the block around it (read in
; BGB in 203 replay(s) of the organic corpus, modes 00) but never displayed, as TCRF says; the verdict stays final I;
; L3 unref: no routine of this build names it; bytes equal to us_eu ...
Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx::
    INCBIN "data/bank_15/Unused_TCRF_JapaneseMenuTile_CircledX_Copy3_Gfx.2bpp" ; $4580, 16 bytes
; C: continues the span of Gfx_15_4000_MainMenu_LoadBackground (the label before the TCRF-unused block). L3 pass
; 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_4590_MainMenu_LoadBackground_Cont::
    INCBIN "data/bank_15/Gfx_15_4590_MainMenu_LoadBackground_Cont.2bpp" ; $4590, 112 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/); C: the bytes changed but
; Mode00_State00_Init reads them in this build (coverage call site or loader ...
Gfx_15_4600_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4600_Mode00_State00_Init.2bpp" ; $4600, 768 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/); C: the bytes changed but
; Mode00_State00_Init reads them in this build (coverage call site or loader ...
Gfx_15_4900_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_4900_Mode00_State00_Init.2bpp" ; $4900, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 13 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4A00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4A00_MainMenu_LoadBackground.2bpp" ; $4A00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 26 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4B00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4B00_MainMenu_LoadBackground.2bpp" ; $4B00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State04_Item3_Doodle, Mode00_State05_Item4_Link,
; Mode00_State06_Item5_Special, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 33 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4C00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4C00_MainMenu_LoadBackground.2bpp" ; $4C00, 256 bytes
; C: copied to VRAM/WRAM by MainMenu_TransitionToLowerPage, Mode00_State05_Item4_Link, Mode00_State06_Item5_Special,
; Mode00_State07_Item6_Edit, MainMenu_LoadBackground (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 72 replay(s) of the organic corpus, modes 00 ...
Gfx_15_4D00_MainMenu_LoadBackground::
    INCBIN "data/bank_15/Gfx_15_4D00_MainMenu_LoadBackground.2bpp" ; $4D00, 256 bytes
; C: copied to VRAM/WRAM by Mode00_State03_Item2_Arcade, MainMenu_LoadBaseTiles, MainMenu_DrawUpperItem2
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic corpus, modes
; 00 (tcrf_check/assets/l3_names/); C: the bytes changed but MainMenu_LoadBaseTiles ...
Gfx_15_4E00_MainMenu_LoadBaseTiles::
    INCBIN "data/bank_15/Gfx_15_4E00_MainMenu_LoadBaseTiles.2bpp" ; $4E00, 512 bytes
; C: far pointer loaded by MainMenu_DrawUpperItem2 (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 14 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/); C: the bytes changed but MainMenu_DrawUpperItem2 reads ...
Gfx_15_5000_MainMenu_DrawUpperItem2::
    INCBIN "data/bank_15/Gfx_15_5000_MainMenu_DrawUpperItem2.2bpp" ; $5000, 512 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of MainMenu_DrawUpperItem2); classified from
; its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.; L3 shared: read here by
; Mode00_State00_Init (134), Mode04_State00_Init (119), ...
Gfx_15_5200_MainMenu_DrawUpperItem2_Aux::
    INCBIN "data/bank_15/Gfx_15_5200_MainMenu_DrawUpperItem2_Aux.2bpp" ; $5200, 512 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/); C: the bytes changed but
; Mode00_State00_Init reads them in this build (coverage call site or loader ...
Gfx_15_5400_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5400_Mode00_State00_Init.2bpp" ; $5400, 256 bytes
; I: 256 bytes of tiles (4 distinct byte values, drawn by eye: tile graphics) between two copied blocks: the copy of
; 15:5400 ($100 bytes to $9000) ends here and the copy of 15:5600 starts after it; never copied; nothing in the code
; points to it (no instruction operand with its address after a load of ...
Gfx_15_5500_Unref::
    INCBIN "data/bank_15/Gfx_15_5500_Unref.2bpp" ; $5500, 256 bytes
; C: copied to VRAM/WRAM by Mode00_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 203 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Gfx_15_5600_Mode00_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5600_Mode00_State00_Init.2bpp" ; $5600, 256 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_5700_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5700_Mode04_State00_Init.2bpp" ; $5700, 2048 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
Gfx_15_5F00_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_5F00_Mode04_State00_Init.2bpp" ; $5F00, 2048 bytes
; C: copied to VRAM/WRAM by Mode04_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 37 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/); C: the bytes changed but
; Mode04_State00_Init reads them in this build (coverage call site or loader ...
Gfx_15_6700_Mode04_State00_Init::
    INCBIN "data/bank_15/Gfx_15_6700_Mode04_State00_Init.2bpp" ; $6700, 1280 bytes
; C: far pointer loaded by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB (ld a,BANK; ld hl,ADDR; call
; banked copy/far call). L3 pass 2026-10-26: read in BGB in 37 replay(s), modes 04 (states 04:00), not only by the
; consumer the name gives: a shared asset or table; first organic loader in ...
Gfx_15_6C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup.2bpp" ; $6C00, 768 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv); L3 loader: Mode0E_State06_ExchangeSetup ...
Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00::
    INCBIN "data/bank_15/Gfx_15_6C00_Mode0E_State06_ExchangeSetup_Part6F00.2bpp" ; $6F00, 1280 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv); L3 same: the readers here ...
Gfx_15_7400_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_7400_Mode0E_State06_ExchangeSetup.2bpp" ; $7400, 1792 bytes
; C: the blocks on both sides are T_UI (layout kinds) and the reader is Mode0E_State0A_ExchangeSetupB: taken as part
; of the same asset; not seen in the BGB menu walk; L3 shared: read here by Mode0E_State0A_ExchangeSetupB (132),
; Mode0E_State06_ExchangeSetup (68); the name gives one consumer (read sites ...
Gfx_15_7B00_Mode0E_State0A_ExchangeSetupB::
    db $a8, $ff, $00, $ff, $a2, $ff, $01, $ff, $aa, $ff, $55, $ff, $ff, $ff, $55, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $64, $00

; C: 124 bytes typed tiles like the asset before them (layout kind T_UI); was
; Src_15_7B84_Mode0E_State0A_ExchangeSetupB; L3 shared: read here by Mode0E_State06_ExchangeSetup (124),
; Mode0E_State0A_ExchangeSetupB (124); the name gives one consumer (read sites of the interrupt-safe coverage replay,
; bytes ...
Gfx_15_7B84_Mode0E_State0A_ExchangeSetupB::
    INCBIN "data/bank_15/Gfx_15_7B84_Mode0E_State0A_ExchangeSetupB.bin" ; $7B84, 124 bytes
; C: copied to VRAM/WRAM by Mode0E_State06_ExchangeSetup, Mode0E_State0A_ExchangeSetupB
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in the scenarios link_exchange 0E:06,
; link_exchange 0E:0A (tcrf_check/assets/l3_names/scen_hits*.csv); L3 same: the readers here ...
Gfx_15_7C00_Mode0E_State06_ExchangeSetup::
    INCBIN "data/bank_15/Gfx_15_7C00_Mode0E_State06_ExchangeSetup.2bpp" ; $7C00, 1024 bytes

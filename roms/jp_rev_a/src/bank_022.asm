; Pocket Camera (Japan) (Rev A), bank $22. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $022", ROMX[$4000], BANK[$22]

; C: frame 3 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_4000_CreditsGirlFrame03::
    INCBIN "data/bank_22/Gfx_22_4000_CreditsGirlFrame03.2bpp" ; $4000, 1280 bytes
; C: frame 0 of the dancing man (Kentaro Nishimura, credited CORDINATOR (sic) and SOUND COMPOSER; the "Miyamoto"
; attribution found on the web is an error: owner) of the short credits: {lo,hi,bank,duration} table 09:5145 (4
; records, 8 frames each), 0x470 bytes copied to $9000 by ...
Gfx_22_4500_CreditsNishimuraDanceFrame00::
    INCBIN "data/bank_22/Gfx_22_4500_CreditsNishimuraDanceFrame00.2bpp" ; $4500, 1136 bytes
; C: frame 1 of the dancing man (Kentaro Nishimura, credited CORDINATOR (sic) and SOUND COMPOSER; the "Miyamoto"
; attribution found on the web is an error: owner) of the short credits: {lo,hi,bank,duration} table 09:5145 (4
; records, 8 frames each), 0x470 bytes copied to $9000 by ...
Gfx_22_4970_CreditsNishimuraDanceFrame01::
    INCBIN "data/bank_22/Gfx_22_4970_CreditsNishimuraDanceFrame01.2bpp" ; $4970, 1136 bytes
; C: frame 10 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_4DE0_CreditsGirlFrame10::
    INCBIN "data/bank_22/Gfx_22_4DE0_CreditsGirlFrame10.2bpp" ; $4DE0, 1280 bytes
; C: frame 2 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_5240_CreditsGirlFrame02_Part52E0::
    INCBIN "data/bank_22/Gfx_22_5240_CreditsGirlFrame02_Part52E0.2bpp" ; $52E0, 1120 bytes
; C: frame 7 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_56A0_CreditsGirlFrame07_Part5740::
    INCBIN "data/bank_22/Gfx_22_56A0_CreditsGirlFrame07_Part5740.2bpp" ; $5740, 1120 bytes
; C: frame 11 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_5B00_CreditsGirlFrame11_Part5BA0::
    INCBIN "data/bank_22/Gfx_22_5B00_CreditsGirlFrame11_Part5BA0.2bpp" ; $5BA0, 928 bytes
; C: far pointer loaded by Mode20_State02_GameSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 08 20 (tcrf_check/assets/l3_names/)
Map_22_5F40_Mode20_State02_GameSetup::
    INCBIN "data/bank_22/Map_22_5F40_Mode20_State02_GameSetup.tilemap" ; $5F40, 192 bytes
; C: copied to VRAM/WRAM by Ball_MenuLoadRow (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Map_22_5F40_Ball_MenuLoadRow_Part6000::
    INCBIN "data/bank_22/Map_22_5F40_Ball_MenuLoadRow_Part6000.tilemap" ; $6000, 832 bytes
; C: copied to VRAM/WRAM by Mode06_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 06 (tcrf_check/assets/l3_names/)
Map_22_6340_Mode06_State00_Init::
    INCBIN "data/bank_22/Map_22_6340_Mode06_State00_Init.tilemap" ; $6340, 1024 bytes
; C: copied to VRAM/WRAM by Mode11_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 35 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Gfx_22_6740_Mode11_State02_Setup::
    INCBIN "data/bank_22/Gfx_22_6740_Mode11_State02_Setup.2bpp" ; $6740, 208 bytes
; C: copied to VRAM/WRAM by Mode11_State02_Setup, Mode11_State08_SaveResult (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Gfx_22_6810_Mode11_State02_Setup::
    INCBIN "data/bank_22/Gfx_22_6810_Mode11_State02_Setup.2bpp" ; $6810, 640 bytes
; C: far pointer loaded by Mode11_State04_Place (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 35 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Gfx_22_6A90_Mode11_State04_Place::
    INCBIN "data/bank_22/Gfx_22_6A90_Mode11_State04_Place.2bpp" ; $6A90, 16 bytes
; C: far pointer loaded by Mode1A_State02_Setup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 45 replay(s) of the organic corpus, modes 11 1A (tcrf_check/assets/l3_names/)
Gfx_22_6AA0_Mode1A_State02_Setup::
    INCBIN "data/bank_22/Gfx_22_6AA0_Mode1A_State02_Setup.2bpp" ; $6AA0, 16 bytes
; C: copied to VRAM/WRAM by Mode11_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 35 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Gfx_22_6AB0_Mode11_State02_Setup::
    db $00, $00, $fc, $fc, $fc, $84, $fc, $bc, $e0, $a0, $e0, $a0, $e0, $a0, $e0, $e0

    ; padding
    ds $80, $00

; C: copied to VRAM/WRAM by Mode12_State00_Init, Mode12_State0F_ClearAll, Mode12_State10_Pack, Mode12_State13_TestEnd,
; Mode12_State1F_SortDialogClose, Mode12_State22_BorderPickerReturn (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 ...
Map_22_6B40_Mode12_State00_Init::
    INCBIN "data/bank_22/Map_22_6B40_Mode12_State00_Init.tilemap" ; $6B40, 672 bytes
; C: far pointer loaded by Mode12_State06_ToolsOpen (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 23 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
Map_22_6DE0_Mode12_State06_ToolsOpen::
    INCBIN "data/bank_22/Map_22_6DE0_Mode12_State06_ToolsOpen.tilemap" ; $6DE0, 352 bytes
; C: frame 8 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_22_6F40_CreditsGirlFrame08::
    INCBIN "data/bank_22/Gfx_22_6F40_CreditsGirlFrame08.2bpp" ; $6F40, 1024 bytes
; C: far pointer loaded by Mode21_State02_RaceSceneInit, Mode21_State0B_ResultSetup (ld a,BANK; ld hl,ADDR; call
; banked copy/far call). L3 pass 2026-10-26: read in BGB in 1 replay(s), modes 08 (states 08:15), not only by the
; consumer the name gives: a shared asset or table; first organic loader in the ...
Map_22_7340_Mode21_State02_RaceSceneInit::
    INCBIN "data/bank_22/Map_22_7340_Mode21_State02_RaceSceneInit.tilemap" ; $7340, 256 bytes
; C: copied to VRAM/WRAM by Mode21_PickCharacterKeys, Mode21_State07_RaceEnd (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 21)
Map_22_7340_Mode21_PickCharacterKeys_Part7440::
    INCBIN "data/bank_22/Map_22_7340_Mode21_PickCharacterKeys_Part7440.tilemap" ; $7440, 768 bytes
; C: copied to VRAM/WRAM by Mode20_State02_GameSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Map_22_7740_Mode20_State02_GameSetup::
    INCBIN "data/bank_22/Map_22_7740_Mode20_State02_GameSetup.tilemap" ; $7740, 1024 bytes
; C: copied to VRAM/WRAM by Mode1F_State04_PerformanceSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Map_22_7B40_Mode1F_State04_PerformanceSetup::
    INCBIN "data/bank_22/Map_22_7B40_Mode1F_State04_PerformanceSetup.tilemap" ; $7B40, 1024 bytes
; C: 6 rows x 10 tile ids taken with a row stride of 32 (192 bytes to the end of the bank): SpaceFever_LoadHudTiles
; (07:67E3) does ld a,$22 / ld hl,$7F40 / ld de,$98C9 / ld b,6 / call SpaceFever_CopyTextRows (10 tiles per row, both
; pointers advance by $20); the coverage run read exactly the first 10 ...
Map_22_7F40_SpaceFever_LoadHudTiles::
    INCBIN "data/bank_22/Map_22_7F40_SpaceFever_LoadHudTiles.tilemap" ; $7F40, 192 bytes

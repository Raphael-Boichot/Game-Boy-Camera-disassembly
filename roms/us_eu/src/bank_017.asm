; Game Boy Camera (USA, Europe), bank $17. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $017", ROMX[$4000], BANK[$17]

; C: digit table of the SHOOT screens: 10 digits x 32 bytes (2 tiles each), digit n at $4000 + 32 x n;
; Shoot_DrawDigitAt (06:7125) adds digit x 32 to $4000 and copies the two 16-byte halves of bank $17 through
; Shoot_CopyTileSafe (copy sites 06:7150 / 06:7155); all 320 bytes are read in the organic runs; ...
Gfx_17_4000_Shoot_DrawDigitAt_Digits::
    INCBIN "data/bank_17/Gfx_17_4000_Shoot_DrawDigitAt_Digits.2bpp" ; $4000, 320 bytes
; C: copied to VRAM/WRAM by Mode14_State00_Init, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv) | also
; the first sources of lists 1 and 2 of Shoot_LoadTimerScreen (06:6E06, table 06:6E32): 4140 -> $8950 and 4160 ->
; $8A50, 32 bytes each (C). L3 pass 2026-10-26: read in BGB in 72 replay(s) of ...
Gfx_17_4140_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_4140_Mode14_State00_Init.2bpp" ; $4140, 64 bytes
; I: copied to VRAM/WRAM by Mode14_State00_Init, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv) | also
; the first record of every list of Shoot_LoadTimerScreen (06:6E06): 4180 -> $89A0 and 41C0 -> $8AA0, 0x40 bytes each
; (C). L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic ...
Gfx_17_4180_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_4180_Mode14_State00_Init.2bpp" ; $4180, 128 bytes
; C: 18 pieces of 0x40 bytes (two 32-byte halves, to $8900 and $8A00): the clock frames of the self-timer screen.
; Shoot_LoadTimerScreen (06:6E06) indexes Shoot_LoadTimerScreen_Tbl6E32 (22 lists of 7-byte records {src
; lo,hi,bank,dst lo,hi,len lo,hi} ended by $FF) with $D7E3 and copies each record with ...
Gfx_17_4200_Shoot_LoadTimerScreen_Frames::
    INCBIN "data/bank_17/Gfx_17_4200_Shoot_LoadTimerScreen_Frames.2bpp" ; $4200, 1152 bytes
; C: copied to VRAM/WRAM by Mode0F_State05_ConfirmInit, Mode17_State08_Split_Build, Mode17_State0E_Fusion_Build,
; Mode14_State00_Init, Mode14_State0C_Reinit, Mode0E_State04_PickDone, Mode0E_State0D_PickSecond,
; Mode1C_State02_ShowPrintScreen (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read ...
Gfx_17_4680_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_17/Gfx_17_4680_Mode0F_State05_ConfirmInit.2bpp" ; $4680, 16 bytes
; C: copied to VRAM/WRAM by Compose_Fusion_DrawMakeBlink, Compose_Split_DrawMakeBlink, Mode0E_State02_MessageStrip
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 80 replay(s), modes 14 1C (states 14:00
; 1C:02 14:0C 1C:0E), not only by the consumer the name gives: a shared asset ...
Gfx_17_4680_Compose_Split_DrawMakeBlink_Part4690::
    INCBIN "data/bank_17/Gfx_17_4680_Compose_Split_DrawMakeBlink_Part4690.2bpp" ; $4690, 16 bytes
; C: far pointer loaded by Mode0F_State05_ConfirmInit (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 88 replay(s) of the organic corpus, modes 0F 14 1C (tcrf_check/assets/l3_names/)
Gfx_17_46A0_Mode0F_State05_ConfirmInit::
    INCBIN "data/bank_17/Gfx_17_46A0_Mode0F_State05_ConfirmInit.2bpp" ; $46A0, 96 bytes
; I: far pointer loaded by Shoot_LoadBurstIcons (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 256 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_4700_Shoot_LoadBurstIcons::
    INCBIN "data/bank_17/Gfx_17_4700_Shoot_LoadBurstIcons.2bpp" ; $4700, 64 bytes
; I: far pointer loaded by Shoot_LoadBurstIcons (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 192 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_4740_Shoot_LoadBurstIcons::
    INCBIN "data/bank_17/Gfx_17_4740_Shoot_LoadBurstIcons.2bpp" ; $4740, 64 bytes
; I: far pointer loaded by Shoot_LoadBurstIcons (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 128 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_4780_Shoot_LoadBurstIcons::
    INCBIN "data/bank_17/Gfx_17_4780_Shoot_LoadBurstIcons.2bpp" ; $4780, 64 bytes
; I: far pointer loaded by Shoot_LoadBurstIcons (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_47C0_Shoot_LoadBurstIcons::
    INCBIN "data/bank_17/Gfx_17_47C0_Shoot_LoadBurstIcons.2bpp" ; $47C0, 64 bytes
; C: far pointer loaded by Compose_DrawFreeCount, Shoot_DrawShotsLeft, Unused_Link_DrawPhotoNumber (ld a,BANK; ld
; hl,ADDR; call banked copy/far call); length 32 from the nearby ld bc | digit 0 of the second digit table: 4800 + 32
; x digit (digits 0-9 = 4800-493F), used by Compose_DrawFreeCount, ...
Gfx_17_4800_Compose_DrawFreeCount::
    INCBIN "data/bank_17/Gfx_17_4800_Compose_DrawFreeCount.2bpp" ; $4800, 32 bytes
; C: digits 1-9 of the digit table at 4800 (32 bytes each, $4800 + 32 x digit): Shoot_DrawShotsLeft (06:6196) copies
; tens to $8720 (06:61BB) and units to $8700 (06:61D3); Compose_DrawFreeCount (06:5916) reads the same table; all 288
; bytes are read in the organic runs (C); the shapes are numerals (I)
Gfx_17_4820_Shoot_DrawShotsLeft_Digits1to9::
    INCBIN "data/bank_17/Gfx_17_4820_Shoot_DrawShotsLeft_Digits1to9.2bpp" ; $4820, 288 bytes
; C: copied to VRAM/WRAM by Mode14_State00_Init, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Gfx_17_4940_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_4940_Mode14_State00_Init.2bpp" ; $4940, 16 bytes
; C: far pointer loaded by Mode0E_State04_PickDone, Mode0E_State0D_PickSecond, Shoot_DrawTimerMinutes (ld a,BANK; ld
; hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 72 replay(s), modes 14 (states 14:01 14:00
; 14:03 14:0C 14:04), not only by the consumer the name gives: a shared ...
Gfx_17_4950_Shoot_DrawTimerMinutes::
    INCBIN "data/bank_17/Gfx_17_4950_Shoot_DrawTimerMinutes.2bpp" ; $4950, 16 bytes
; C: copied to VRAM/WRAM by Mode14_State00_Init, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Gfx_17_4960_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_4960_Mode14_State00_Init.2bpp" ; $4960, 32 bytes
; I: copied to VRAM/WRAM by Mode17_State08_Split_Build, Mode17_State0E_Fusion_Build, Mode14_State00_Init,
; Shoot_RestoreViewScreen, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Gfx_17_4980_Mode17_State08_Split_Build::
    INCBIN "data/bank_17/Gfx_17_4980_Mode17_State08_Split_Build.2bpp" ; $4980, 224 bytes
; I: far pointer loaded by Mode0E_State04_PickDone, Mode0E_State0D_PickSecond, Mode1C_State02_ShowPrintScreen (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 80 replay(s) of the organic
; corpus, modes 14 1C (tcrf_check/assets/l3_names/)
Gfx_17_4A60_Mode0E_State04_PickDone::
    INCBIN "data/bank_17/Gfx_17_4A60_Mode0E_State04_PickDone.2bpp" ; $4A60, 256 bytes
; I: far pointer loaded by Mode0E_State04_PickDone, Mode0E_State0D_PickSecond, Mode1C_State02_ShowPrintScreen (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 80 replay(s) of the organic
; corpus, modes 14 1C (tcrf_check/assets/l3_names/)
Gfx_17_4B60_Mode0E_State04_PickDone::
    INCBIN "data/bank_17/Gfx_17_4B60_Mode0E_State04_PickDone.2bpp" ; $4B60, 48 bytes
; I: far pointer loaded by Mode0E_State04_PickDone, Mode0E_State0D_PickSecond, Mode1C_State02_ShowPrintScreen (ld
; a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 80 replay(s) of the organic
; corpus, modes 14 1C (tcrf_check/assets/l3_names/)
Gfx_17_4B90_Mode0E_State04_PickDone::
    INCBIN "data/bank_17/Gfx_17_4B90_Mode0E_State04_PickDone.2bpp" ; $4B90, 80 bytes
; I: far pointer loaded by Shoot_DrawTimerMinutes (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 16 from
; the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_17_4BE0_Shoot_DrawTimerMinutes::
    db $db, $ff, $53, $01, $2c, $01, $64, $2d, $64, $2d, $64, $2d, $f6, $2d, $ff, $ff

    ; padding
    ds $10, $00

; I: far pointer loaded by Shoot_DrawOptionPanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_4C00_Shoot_DrawOptionPanel::
    INCBIN "data/bank_17/Gfx_17_4C00_Shoot_DrawOptionPanel.2bpp" ; $4C00, 1024 bytes
; I: far pointer loaded by Mode14_State04_OptionsPage (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_5000_Mode14_State04_OptionsPage::
    INCBIN "data/bank_17/Gfx_17_5000_Mode14_State04_OptionsPage.2bpp" ; $5000, 512 bytes
; C: far pointer loaded by Mode14_State04_OptionsPage (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 512
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Gfx_17_5200_Mode14_State04_OptionsPage::
    db $00, $00, $7f, $00, $78, $03, $60, $0f, $60, $0f, $43, $1e, $43, $1e, $43, $1e
    db $00, $01, $ff, $01, $3f, $e1, $0f, $f9, $0f, $f9, $87, $3d, $87, $3d, $87, $3d
    db $40, $1f, $40, $1f, $43, $1e, $43, $1e, $43, $1e, $43, $1e, $7f, $00, $7f, $ff
    db $07, $fd, $07, $fd, $87, $3d, $87, $3d, $87, $3d, $87, $3d, $ff, $01, $ff, $ff
    db $00, $00, $7f, $00, $40, $1f, $40, $1f, $43, $1e, $43, $1e, $43, $1e, $40, $1f
    db $00, $01, $ff, $01, $0f, $f9, $07, $fd, $87, $3d, $87, $3d, $87, $3d, $0f, $f9
    db $40, $1f, $43, $1e, $43, $1e, $43, $1e, $40, $1f, $40, $1f, $7f, $00, $7f, $ff
    db $0f, $f9, $87, $3d, $87, $3d, $87, $3d, $07, $fd, $0f, $f9, $ff, $01, $ff, $ff
    db $00, $00, $7f, $00, $60, $0f, $40, $1f, $41, $1f, $43, $1e, $43, $1e, $43, $1e
    db $00, $01, $ff, $01, $0f, $f9, $07, $fd, $87, $3d, $87, $3d, $ff, $01, $ff, $01
    db $43, $1e, $43, $1e, $43, $1e, $41, $1f, $40, $1f, $60, $0f, $7f, $00, $7f, $ff
    db $ff, $01, $ff, $01, $87, $3d, $87, $3d, $07, $fd, $0f, $f9, $ff, $01, $ff, $ff
    db $00, $00, $7f, $00, $40, $1f, $40, $1f, $43, $1e, $43, $1e, $43, $1e, $43, $1e
    db $00, $01, $ff, $01, $0f, $f9, $07, $fd, $07, $7d, $87, $3d, $87, $3d, $87, $3d
    db $43, $1e, $43, $1e, $43, $1e, $43, $1e, $40, $1f, $40, $1f, $7f, $00, $7f, $ff
    db $87, $3d, $87, $3d, $87, $3d, $07, $7d, $07, $fd, $0f, $f9, $ff, $01, $ff, $ff

    ; padding
    ds $100, $00

; C: far pointer loaded by Shoot_LoadBurstIcons (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the
; nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 14)
Gfx_17_5400_Shoot_LoadBurstIcons::
    INCBIN "data/bank_17/Gfx_17_5400_Shoot_LoadBurstIcons.2bpp" ; $5400, 64 bytes
; I: copied to VRAM/WRAM by Mode14_State00_Init, Shoot_RestoreViewScreen, Mode14_State0C_Reinit
; (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes
; 14 (tcrf_check/assets/l3_names/)
Gfx_17_5440_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_5440_Mode14_State00_Init.2bpp" ; $5440, 160 bytes
; C: copied to VRAM/WRAM by Mode14_State00_Init, Mode14_State0C_Reinit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: read in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Gfx_17_54E0_Mode14_State00_Init::
    INCBIN "data/bank_17/Gfx_17_54E0_Mode14_State00_Init.2bpp" ; $54E0, 32 bytes
; C: tile block (304 tiles, 4,864 bytes) of an unused one-page main menu: the map 25:7820 uses ids 0-233 of it and BGB
; draws the flow-chart menu with it (README 16.25); tiles 234-303 are line / arc fragments (by eye). Replaces the
; owner's 'glyph strips of the SHOOT option menus' reading (by eye), which ...
Gfx_17_5500_Unused_MainMenuTiles::
    INCBIN "data/bank_17/Gfx_17_5500_Unused_MainMenuTiles.2bpp" ; $5500, 4864 bytes
; I: copied to VRAM/WRAM by Mode13_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 13)
Gfx_17_6800_Mode13_State00_Init::
    INCBIN "data/bank_17/Gfx_17_6800_Mode13_State00_Init.2bpp" ; $6800, 2048 bytes
; I: copied to VRAM/WRAM by Mode13_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 13)
Gfx_17_7000_Mode13_State00_Init::
    INCBIN "data/bank_17/Gfx_17_7000_Mode13_State00_Init.2bpp" ; $7000, 2048 bytes
; I: copied to VRAM/WRAM by Mode13_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 13)
Gfx_17_7800_Mode13_State00_Init::
    INCBIN "data/bank_17/Gfx_17_7800_Mode13_State00_Init.2bpp" ; $7800, 256 bytes
; I: far pointer loaded by Player_CopyDigitTile (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Src_17_7900_Player_CopyDigitTile::
    INCBIN "data/bank_17/Src_17_7900_Player_CopyDigitTile.bin" ; $7900, 64 bytes
; I: Spriter's Resource sheet "Menus - Animation Title", 418 tiles. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 13)
Sheet_MenusAnimationTitle_17_6800_Part7940::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $b5, $00

; C: frame 4 of the staff-roll dancer (a dancing girl, not identified): {lo,hi,bank,duration} table 09:509C (13
; records, 12 frames each), 0x500 bytes copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll
Gfx_17_7B00_CreditsGirlFrame04::
    INCBIN "data/bank_17/Gfx_17_7B00_CreditsGirlFrame04.2bpp" ; $7B00, 1280 bytes

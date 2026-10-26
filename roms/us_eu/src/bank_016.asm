; Game Boy Camera (USA, Europe), bank $16. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $016", ROMX[$4000], BANK[$16]

; I: copied to VRAM/WRAM by Mode0B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0B)
Gfx_16_4000_Mode0B_State00_Init::
    INCBIN "data/bank_16/Gfx_16_4000_Mode0B_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode0B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0B)
Gfx_16_4800_Mode0B_State00_Init::
    INCBIN "data/bank_16/Gfx_16_4800_Mode0B_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode0B_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0B)
Gfx_16_5000_Mode0B_State00_Init::
    INCBIN "data/bank_16/Gfx_16_5000_Mode0B_State00_Init.2bpp" ; $5000, 1408 bytes
; C: frame 0 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl1 step 4; resting tiles when $DA16 < 3
; (MainMenu_LoadIconTilesB, 07:784C)
Gfx_16_5580_MainMenu_IconStripB_F0::
    INCBIN "data/bank_16/Gfx_16_5580_MainMenu_IconStripB_F0.2bpp" ; $5580, 1280 bytes
; C: frame 1 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl0 step 1 and Tbl1 step 3
Gfx_16_5A80_MainMenu_IconStripB_F1::
    INCBIN "data/bank_16/Gfx_16_5A80_MainMenu_IconStripB_F1.2bpp" ; $5A80, 1280 bytes
; C: frame 2 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl0 step 2 and Tbl1 step 2
Gfx_16_5F80_MainMenu_IconStripB_F2::
    INCBIN "data/bank_16/Gfx_16_5F80_MainMenu_IconStripB_F2.2bpp" ; $5F80, 1280 bytes
; C: frame 3 of 7 of the menu strip B (0x500 bytes = 80 tiles, copied to $9200 by the page transition B; frames 0-3 in
; bank $16 at pitch 0x500, frames 4-6 in bank $11): Tbl0 step 3 and Tbl1 step 1
Gfx_16_6480_MainMenu_IconStripB_F3::
    INCBIN "data/bank_16/Gfx_16_6480_MainMenu_IconStripB_F3.2bpp" ; $6480, 1280 bytes
; C: frame 0 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl1 step 4 (the last frame of the backward sweep); resting
; tiles of the menu icons when $DA16 = 0 (MainMenu_LoadIconTilesA, ...
Gfx_16_6980_MainMenu_BallHeadAnim_F0::
    INCBIN "data/bank_16/Gfx_16_6980_MainMenu_BallHeadAnim_F0.2bpp" ; $6980, 512 bytes
; C: frame 1 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl0 step 1 and Tbl1 step 3; read by the organic runs (C)
Gfx_16_6B80_MainMenu_BallHeadAnim_F1::
    INCBIN "data/bank_16/Gfx_16_6B80_MainMenu_BallHeadAnim_F1.2bpp" ; $6B80, 512 bytes
; C: frame 2 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl0 step 2 and Tbl1 step 2; read by the organic runs (C)
Gfx_16_6D80_MainMenu_BallHeadAnim_F2::
    INCBIN "data/bank_16/Gfx_16_6D80_MainMenu_BallHeadAnim_F2.2bpp" ; $6D80, 512 bytes
; C: frame 3 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl0 step 3 and Tbl1 step 1; read by the organic runs (C)
Gfx_16_6F80_MainMenu_BallHeadAnim_F3::
    INCBIN "data/bank_16/Gfx_16_6F80_MainMenu_BallHeadAnim_F3.2bpp" ; $6F80, 512 bytes
; C: frame 4 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl0 step 4 (end of the forward sweep); resting tiles when
; $DA16 = 1 or 2 (MainMenu_LoadIconTilesA, 07:7818); read by the organic ...
Gfx_16_7180_MainMenu_BallHeadAnim_F4::
    INCBIN "data/bank_16/Gfx_16_7180_MainMenu_BallHeadAnim_F4.2bpp" ; $7180, 512 bytes
; C: frame 5 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl3 step 4 only. Owner (2026-10-14): assets of the camera
; ball head animation that plays when Up / Down is pressed on the main ...
Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref::
    INCBIN "data/bank_16/Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref.2bpp" ; $7380, 512 bytes
; C: frame 6 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl2 step 1 and Tbl3 step 3. Owner (2026-10-14): assets of
; the camera ball head animation that plays when Up / Down is pressed on ...
Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref::
    INCBIN "data/bank_16/Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref.2bpp" ; $7580, 512 bytes
; C: frame 7 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl2 step 2 and Tbl3 step 2. Owner (2026-10-14): assets of
; the camera ball head animation that plays when Up / Down is pressed on ...
Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref::
    INCBIN "data/bank_16/Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref.2bpp" ; $7780, 512 bytes
; C: frame 8 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl2 step 3 and Tbl3 step 1. Owner (2026-10-14): assets of
; the camera ball head animation that plays when Up / Down is pressed on ...
Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref::
    INCBIN "data/bank_16/Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref.2bpp" ; $7980, 512 bytes
; C: frame 9 of 10 of the camera ball head animation, the head in the centre of the main menu (0x200 bytes = 32 tiles,
; pitch 0x200, copied to $9100 by the page transition A): Tbl2 step 4 (no caller); resting tiles when $DA16 >= 3
; (MainMenu_LoadIconTilesA, 07:7827, read by the organic runs); read by the ...
Gfx_16_7B80_MainMenu_BallHeadAnim_F9::
    INCBIN "data/bank_16/Gfx_16_7B80_MainMenu_BallHeadAnim_F9.2bpp" ; $7B80, 512 bytes
; I: copied to VRAM/WRAM by Mode18_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 9 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Map_16_7D80_Mode18_State00_Init::
    INCBIN "data/bank_16/Map_16_7D80_Mode18_State00_Init.tilemap" ; $7D80, 576 bytes
; I: copied to VRAM/WRAM by Mode18_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 3 replay(s) of the organic corpus, modes 18 (tcrf_check/assets/l3_names/)
Map_16_7FC0_Mode18_State00_Init::
    INCBIN "data/bank_16/Map_16_7FC0_Mode18_State00_Init.tilemap" ; $7FC0, 64 bytes

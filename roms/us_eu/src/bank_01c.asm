; Game Boy Camera (USA, Europe), bank $1C. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01c", ROMX[$4000], BANK[$1c]

; C: the start of the page-1 record of Parlor_PageTbl ($800 bytes to $9000), read by Parlor_LoadPage; the earlier name
; Gfx_1C_4000_Cont
Gfx_1C_4000_Parlor_Page1::
    INCBIN "data/bank_1c/Gfx_1C_4000_Parlor_Page1.2bpp" ; $4000, 16 bytes
; C: 1 byte of 561 differs from the Japanese block: the same shoot-parlor art (sheet "Menus - Shoot Menu"); record 1
; of Parlor_PageTbl
Sheet_MenusShootMenu_1C_4010::
    INCBIN "data/bank_1c/Sheet_MenusShootMenu_1C_4010.bin" ; $4010, 561 bytes
; C: inside record 1 of page 1 (1C:4000 +$0800 -> $9000, VRAM $9241 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I); L3 module: read here by Parlor_LoadPage (1150), of ...
Gfx_1C_4241_Parlor_Page1::
    INCBIN "data/bank_1c/Gfx_1C_4241_Parlor_Page1.bin" ; $4241, 607 bytes
; C: tiles: BGB, menu walk node H00 (tcrf_check/tools/guide_nodes.py, intl ROM): its first 16 bytes are in VRAM tile
; data; read by Mode01_State03
Gfx_1C_44A0_Mode01_State03::
    INCBIN "data/bank_1c/Gfx_1C_44A0_Mode01_State03.2bpp" ; $44A0, 16 bytes
; C: inside record 1 of page 1 (1C:4000 +$0800 -> $9000, VRAM $94B0 onward) of Parlor_PageTbl (04:7436), loaded by
; Parlor_LoadPage; load extent from the code and the coverage log (every byte of the record is read), content = tile
; data by its look (I); L3 module: read here by Parlor_LoadPage (896), of ...
Gfx_1C_44B0_Parlor_Page1::
    INCBIN "data/bank_1c/Gfx_1C_44B0_Parlor_Page1.2bpp" ; $44B0, 448 bytes
; C: the same shoot-parlor art as in Japan; the last tiles differ (150 bytes): stripes and the English text "Welcome
; to" where the Japanese block has stripes and blanks (sheets_jp_vs_intl.png)
Sheet_MenusShootMenu_1C_4670::
    INCBIN "data/bank_1c/Sheet_MenusShootMenu_1C_4670.bin" ; $4670, 1993 bytes
; C: tiles: BGB, menu walk node H00 (tcrf_check/tools/guide_nodes.py, intl ROM): its first 16 bytes are in VRAM tile
; data; read by Mode01_State03
Gfx_1C_4E39_Mode01_State03::
    db $00, $ff, $ff, $00, $00, $00, $00, $d3, $d3, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $99, $99, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $53, $53, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $81, $81, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $98, $98, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $2a, $2a, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $20, $20, $c0, $c0, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $e3, $e3, $80, $80, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $50, $50, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $99, $99, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff, $00, $00, $00, $00, $08, $08, $00, $00, $00, $ff, $00, $00, $ff
    db $00, $ff, $ff

    ; padding
    ds $14, $00

; C: tiles of the SHOOT parlor (mode $01): all 192 read bytes come from Parlor_LoadPage, the parlor page loader of
; mode $01
Gfx_1C_4F00_Mode01_State03::
    INCBIN "data/bank_1c/Gfx_1C_4F00_Mode01_State03.2bpp" ; $4F00, 96 bytes
; C: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv) | also inside record 2 of page
; 1 of Parlor_PageTbl (1C:4800 +$0800 -> $8800, C). L3 pass 2026-10-26: read in BGB in 24 replay(s) of the organic
; corpus, modes 01 1A (tcrf_check/assets/l3_names/); C: the bytes changed ...
Gfx_1C_4F60_Mode1A_State02_Setup::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $bb, $99, $bb, $99, $bb, $99, $bb, $99, $bb, $81, $83, $81
    db $ff, $ff, $ff, $ff, $e7, $c3, $db, $81, $bd, $99, $bd, $99, $bd, $99, $bd, $99
    db $ff, $ff, $ff, $ff, $ff, $81, $81, $81, $81, $e7, $e7, $e7, $e7, $e7, $e7, $e7
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $e7, $c3, $c3, $81, $93, $99, $9f, $9f, $cb, $87, $e1, $c3
    db $ff, $ff, $ff, $ff, $fd, $03, $83, $01, $bd, $01, $bd, $39, $bd, $39, $83, $01
    db $ff, $ff, $ff, $ff, $e7, $c3, $db, $81, $bd, $99, $bd, $99, $bd, $99, $bd, $99
    db $ff, $ff, $ff, $ff, $ff, $81, $81, $81, $81, $e7, $e7, $e7, $e7, $e7, $e7, $e7
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $bb, $99, $3b, $99, $3b, $99, $3b, $99, $37, $99, $ff, $ff, $ff, $ff, $ff, $ff
    db $bd, $99, $bd, $99, $bd, $99, $db, $81, $e7, $c3, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f1, $f1, $b9, $f9, $99, $81, $81, $83, $a3, $c7, $ff, $ff, $ff, $ff, $ff, $ff
    db $83, $03, $bf, $3f, $bf, $3f, $bf, $3f, $bf, $3f, $ff, $ff, $ff, $ff, $ff, $ff
    db $bd, $99, $bd, $99, $bd, $99, $db, $81, $e7, $c3, $ff, $ff, $ff, $ff, $ff, $ff
    db $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $e7, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc
    db $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $7c, $3c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c
    db $7f, $3f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f
    db $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fd, $fc, $fe, $fd
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff
    db $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $bd, $7c, $3e, $fd
    db $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $bf, $7f, $3f, $ff

    ; padding
    ds $40, $00

; I: tiles of the hot-spot editor: Mode1A_State02_Setup reads all of them in this build (1,216 bytes, read site of the
; coverage replay of 2026-11-02 with the interrupt-safe sites), also Mode1A_State04_PlaceOrDelete and
; Mode1A_State09_ExitDialog; byte-equal to the Japanese block, whose note said no copy ...
Gfx_1C_5160_Mode1A_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_5160_Mode1A_State02_Setup.2bpp" ; $5160, 64 bytes
; C: far pointer loaded by Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 512 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete.2bpp" ; $51A0, 512 bytes
; C: copied to VRAM/WRAM by Mode1A_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_53A0_Mode1A_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_53A0_Mode1A_State02_Setup.2bpp" ; $53A0, 608 bytes
; C: far pointer loaded by Album_ShowPageScreenB, Album_LoadBorderScreen, Shoot_DrawOptionPanel,
; Mode1C_DrawOptionScreen (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read in BGB in 76
; replay(s) of the organic corpus, modes 09 0A 14 1A 1C (tcrf_check/assets/l3_names/)
Gfx_1C_5600_Album_ShowPageScreenB::
    INCBIN "data/bank_1c/Gfx_1C_5600_Album_ShowPageScreenB.2bpp" ; $5600, 32 bytes
; I: 64 bytes of tiles (by eye) between the copied blocks 1C:5600 ($20 bytes) and the digit tiles 1C:5660; bytes equal
; to the Japanese ones; nothing in the code points to it (no instruction operand with its address after a load of its
; bank, no table word, no copy whose range covers it; 2026-11-02); ...
TileGap_1C_5620::
    INCBIN "data/bank_1c/TileGap_1C_5620.2bpp" ; $5620, 64 bytes
; C: digit table: HotSpotEd_CopyNumberTile (03:74C7) copies 16 bytes (1 tile) from $5660 + digit x 16 (+ B, 0 or a
; small offset); 10 entries = 5660-5700; was followed by Gfx_1C_5670_..._Aux
Gfx_1C_5660_HotSpotEd_CopyNumberTile::
    INCBIN "data/bank_1c/Gfx_1C_5660_HotSpotEd_CopyNumberTile.bin" ; $5660, 174 bytes
; I: 18 bytes read by HotSpotEd_ShowJump (from HotSpotEd_PickerSlideIn) and HotSpotEd_CopyNumberTile in this build
; (coverage read sites); byte-equal to Japan (the earlier name TileGap_1C_570E); evidence I (2026-11-02): the Japanese
; label TileGap_1C_570E (1C:570E) is I; that something is never used rests ...
Gfx_1C_570E_HotSpotEd_ShowJump::
    INCBIN "data/bank_1c/Gfx_1C_570E_HotSpotEd_ShowJump.bin" ; $570E, 2 bytes
; C: far pointer loaded by HotSpotEd_ShowJump (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 16 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
Gfx_1C_5710_HotSpotEd_ShowJump::
    INCBIN "data/bank_1c/Gfx_1C_5710_HotSpotEd_ShowJump.2bpp" ; $5710, 16 bytes
; I: 64 bytes (4 tiles) read by HotSpotEd_CopyNumberTile (from HotSpotEd_ShowSound) in this build, all of them
; (coverage read sites): the sound-number tiles of the hot-spot editor; byte-equal to Japan (the earlier name
; TileGap_1C_5720); evidence I (2026-11-02): the Japanese label TileGap_1C_5720 ...
Gfx_1C_5720_HotSpotEd_CopyNumberTile::
    INCBIN "data/bank_1c/Gfx_1C_5720_HotSpotEd_CopyNumberTile.2bpp" ; $5720, 64 bytes
; C: 64-byte entries: 03:74EA-7504 copies 64 bytes from $5760 + A x 64 to $8CF0 (A = byte of the table $D657 indexed
; by $D665, swap a then two shifts left); the icons of the hot-spot editor; the block 57A0-58A0 was
; Gfx_1C_57A0_..._Aux. Extent of the table not known (the extra icons at 5920 are ...
Gfx_1C_5760_HotSpotEd_ShowEffectIcon::
    INCBIN "data/bank_1c/Gfx_1C_5760_HotSpotEd_ShowEffectIcon.2bpp" ; $5760, 320 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F 1A (tcrf_check/assets/l3_names/)
Gfx_1C_58A0_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_58A0_Mode0C_State02_Setup.2bpp" ; $58A0, 128 bytes
; I: TCRF unused graphics: the 8 extra hot-spot effect icons (32 tiles); on screen only in runs that force the effect
; number above 7 (README 16.8, 16.24). L3 pass 2026-10-26: copied to VRAM with the block around it (read in BGB in 33
; replay(s) of the organic corpus, modes 0F) but never displayed, as ...
Unused_TCRF_HotSpotEffectIcons_Extra_Gfx::
    INCBIN "data/bank_1c/Unused_TCRF_HotSpotEffectIcons_Extra_Gfx.2bpp" ; $5920, 512 bytes
; I: continues the span of Gfx_1C_58A0_Mode0C_State02_Setup (the label before the TCRF-unused block); L3 relabel-top:
; read here by Parlor_LoadPage (22), not by Mode0C_State02_Setup; the earlier name
; Gfx_1C_5B20_Mode0C_State02_Setup_Cont; evidence I (2026-11-02): the Japanese label ...
Gfx_1C_5B20_Parlor_LoadPage_Cont::
    INCBIN "data/bank_1c/Gfx_1C_5B20_Parlor_LoadPage_Cont.2bpp" ; $5B20, 64 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_1C_5B60_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_5B60_Mode0C_State02_Setup.2bpp" ; $5B60, 32 bytes
; C: far pointer loaded by Mode1A_State02_Setup, Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows,
; Mode14_State04_OptionsPage, Mode1C_State04_OptionsMenu (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 0F 14 1A ...
Gfx_1C_5B80_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5B80_Mode09_State02_PhotoArrows.2bpp" ; $5B80, 64 bytes
; I: 32 bytes = two tiles of the hand-cursor family of its neighbours (by eye), between the copies of 1C:5B80 and
; 1C:5BE0; bytes equal to the Japanese ones; nothing in the code points to it (no instruction operand with its address
; after a load of its bank, no table word, no copy whose range covers it; ...
TileGap_1C_5BC0::
    INCBIN "data/bank_1c/TileGap_1C_5BC0.2bpp" ; $5BC0, 32 bytes
; C: far pointer loaded by Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows, Mode14_State04_OptionsPage (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 48 replay(s) of the organic corpus, modes 09 0A 14 ...
Gfx_1C_5BE0_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5BE0_Mode09_State02_PhotoArrows.2bpp" ; $5BE0, 64 bytes
; C: tile data with no direct pointer in the code (, same bank/neighbour of Mode09_State02_PhotoArrows); classified
; from its content - see sym_unconclusive. Owner (review page, 2026-10-13): graphic, by eye.
Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux::
    INCBIN "data/bank_1c/Gfx_1C_5C20_Mode09_State02_PhotoArrows_Aux.2bpp" ; $5C20, 64 bytes
; C: copied to VRAM/WRAM by Mode0C_State02_Setup, Mode0F_State05_ConfirmInit (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
Gfx_1C_5C60_Mode0C_State02_Setup::
    INCBIN "data/bank_1c/Gfx_1C_5C60_Mode0C_State02_Setup.2bpp" ; $5C60, 32 bytes
; C: far pointer loaded by Mode1A_State02_Setup, Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows,
; Mode14_State04_OptionsPage, Mode1C_State04_OptionsMenu (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 66 replay(s) of the organic corpus, modes 09 0A 0F 14 1A ...
Gfx_1C_5C80_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5C80_Mode09_State02_PhotoArrows.2bpp" ; $5C80, 64 bytes
; I: 32 bytes = two hand-cursor tiles (by eye) between the copies of 1C:5C80 and 1C:5CE0; bytes equal to the Japanese
; ones; nothing in the code points to it (no instruction operand with its address after a load of its bank, no table
; word, no copy whose range covers it; 2026-11-02); evidence I ...
TileGap_1C_5CC0::
    INCBIN "data/bank_1c/TileGap_1C_5CC0.2bpp" ; $5CC0, 32 bytes
; C: far pointer loaded by Mode09_State02_PhotoArrows, Mode0A_State04_PhotoArrows, Mode14_State04_OptionsPage (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 48 replay(s) of the organic corpus, modes 09 0A 14 ...
Gfx_1C_5CE0_Mode09_State02_PhotoArrows::
    INCBIN "data/bank_1c/Gfx_1C_5CE0_Mode09_State02_PhotoArrows.2bpp" ; $5CE0, 64 bytes
; I: 64 bytes of tiles (by eye) between the copy of 1C:5CE0 and 1C:5D60; bytes equal to the Japanese ones; nothing in
; the code points to it (no instruction operand with its address after a load of its bank, no table word, no copy
; whose range covers it; 2026-11-02); evidence I (2026-11-02): the Japanese ...
TileGap_1C_5D20::
    INCBIN "data/bank_1c/TileGap_1C_5D20.2bpp" ; $5D20, 64 bytes
; C: far pointer loaded by HotSpotEd_ShowJumpThumb, Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 192 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete.2bpp" ; $5D60, 192 bytes
; C: far pointer loaded by HotSpotEd_ShowJumpThumb, Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld
; a,BANK; ld hl,ADDR; call banked copy/far call); length 64 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in
; 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_1c/Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete.2bpp" ; $5E20, 64 bytes
; C: copied to VRAM/WRAM by Link_ShowScreenA, Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tiles loaded
; by Link_ShowScreenA and Link_ShowScreenB (07:4B0F / 4B74, $800 B to $9000); ...
Gfx_1C_5E60_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_5E60_Link_ShowScreenA.2bpp" ; $5E60, 1808 bytes
; C: copied to VRAM/WRAM by Link_ShowScreenA, Link_ShowScreenB (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass
; 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tiles loaded
; by Link_ShowScreenA and Link_ShowScreenB (07:4B1D / 4B82, $700 B to $8800); ...
Gfx_1C_6570_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_6570_Link_ShowScreenA.2bpp" ; $6570, 240 bytes
; C: loaded by Mem_CopyFromBank at 07:4AE3: Gfx $700 bytes to $8800 (this build's trace)
Gfx_1C_6660_Link_ShowScreenA::
    INCBIN "data/bank_1c/Gfx_1C_6660_Link_ShowScreenA.2bpp" ; $6660, 1776 bytes
; C: far pointer loaded by Link_ShowScreenA, Link_ShowScreenB (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3
; pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: tile
; loaded by Link_ShowScreenA and Link_ShowScreenB (07:4B2B / 4B90, 16 B to ...
Gfx_1C_6D50_Link_ShowScreenB::
    INCBIN "data/bank_1c/Gfx_1C_6D50_Link_ShowScreenB.2bpp" ; $6D50, 16 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Data_1C_6D60_Mode1F_State07_QuitPanel::
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $55, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff

; C: copied to VRAM/WRAM by Mode1F_State07_QuitPanel (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0::
    INCBIN "data/bank_1c/Gfx_1C_6D60_Mode1F_State07_QuitPanel_Part6DE0.2bpp" ; $6DE0, 128 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_6E60_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_6E60_Mode1F_State08_EditPagesSetup.bin" ; $6E60, 256 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_6F60_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_6F60_Mode1F_State08_EditPagesSetup.bin" ; $6F60, 256 bytes
; C: far pointer loaded by Mode1F_State08_EditPagesSetup (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Src_1C_7060_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Src_1C_7060_Mode1F_State08_EditPagesSetup.bin" ; $7060, 512 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1C_7260_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Gfx_1C_7260_Mode1F_State08_EditPagesSetup.2bpp" ; $7260, 1536 bytes
; C: copied to VRAM/WRAM by Mode1F_State08_EditPagesSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F); C: the bytes changed but ...
Gfx_1C_7860_Mode1F_State08_EditPagesSetup::
    INCBIN "data/bank_1c/Gfx_1C_7860_Mode1F_State08_EditPagesSetup.2bpp" ; $7860, 1024 bytes
; C: copied to VRAM/WRAM by Mode08_CreditsReal (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_1C_7C60_Mode08_CreditsReal::
    INCBIN "data/bank_1c/Map_1C_7C60_Mode08_CreditsReal.tilemap" ; $7C60, 160 bytes
; C: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Map_1C_7D00_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_1c/Map_1C_7D00_Mode08_State13_CreditsPageA.tilemap" ; $7D00, 416 bytes
; C: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 352
; from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/)
Map_1C_7EA0_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_1c/Map_1C_7EA0_Mode08_State13_CreditsPageA.tilemap" ; $7EA0, 352 bytes

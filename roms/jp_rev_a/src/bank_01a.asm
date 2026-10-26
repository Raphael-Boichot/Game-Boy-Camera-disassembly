; Pocket Camera (Japan) (Rev A), bank $1A. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $01a", ROMX[$4000], BANK[$1a]

; C: copied to VRAM/WRAM by Mode1F_State04_PerformanceSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1A_4000_Mode1F_State04_PerformanceSetup::
    INCBIN "data/bank_1a/Gfx_1A_4000_Mode1F_State04_PerformanceSetup.2bpp" ; $4000, 3424 bytes
; C: digit table: DjPerf_DrawTempo (05:56F4) and DjPerf_DrawLevelDigit copy 16 bytes (1 tile) from $4D60 + digit x 16;
; 10 entries = 4D60-4E00, rendered as the digits 0-9; was followed by Gfx_1A_4D80_DjPerf_DrawTempo_Aux
Gfx_1A_4D60_DjPerf_DrawTempo::
    INCBIN "data/bank_1a/Gfx_1A_4D60_DjPerf_DrawTempo.2bpp" ; $4D60, 160 bytes
; C: far pointer loaded by Mode1F_State05_Performance (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 672
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1A_4E00_Mode1F_State05_Performance::
    INCBIN "data/bank_1a/Gfx_1A_4E00_Mode1F_State05_Performance.2bpp" ; $4E00, 672 bytes
; C: far pointer loaded by Mode1F_State06_SavePanel (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 192
; from the nearby ld bc. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_1A_50A0_Mode1F_State06_SavePanel::
    INCBIN "data/bank_1a/Gfx_1A_50A0_Mode1F_State06_SavePanel.2bpp" ; $50A0, 192 bytes
; I: 49 bytes of tile-like data (starts with 3 zero bytes) after Gfx_1A_50A0 (0xC0 copied by Mode1F_State06_SavePanel)
; and before the owner-reviewed graphic 5182; no copy reads it; was Data_1A_5160 + TileGap_1A_5163
TileGap_1A_5160::
    INCBIN "data/bank_1a/TileGap_1A_5160.bin" ; $5160, 34 bytes
; C: tile data with no direct pointer in the code (unreferenced); classified from its content - see sym_unconclusive.
; Owner (review page, 2026-10-13): graphic, by eye.
Gfx_1A_5182_Unref::
    db $06, $0f, $07, $0f, $1b, $0c, $18, $0c, $0c, $18, $00, $00, $00, $00, $20, $70
    db $60, $f0, $f8, $f0, $b8, $70, $18, $30, $10, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $07, $0f, $0f, $1f, $0f, $1c, $0c, $1c, $04, $0c, $07, $0f, $00, $00
    db $00, $00, $c0, $80, $c0, $e0, $a0, $70, $30, $30, $b0, $60, $e0, $c0, $07, $0f
    db $07, $0c, $04, $0c, $04, $0c, $0f, $1f, $07, $0f, $00, $00, $00, $00, $c0, $f0
    db $b0, $78, $30, $38, $30, $78, $e0, $f0, $40, $80

    ; padding
    ds $24, $00

; C: copied to VRAM/WRAM by Mode08_State03_CardInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_1A_5200_Mode08_State03_CardInit::
    INCBIN "data/bank_1a/Gfx_1A_5200_Mode08_State03_CardInit.2bpp" ; $5200, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State03_CardInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_1A_5A00_Mode08_State03_CardInit::
    INCBIN "data/bank_1a/Gfx_1A_5A00_Mode08_State03_CardInit.2bpp" ; $5A00, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State03_CardInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_1A_6200_Mode08_State03_CardInit::
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $07, $fe, $0f, $fe, $1f, $fc, $1f, $f8, $3f, $f0, $7f, $e0, $ff, $c0, $ff, $80
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $01
    db $fc, $1f, $f8, $3f, $f0, $3f, $f0, $7f, $f0, $7f, $e0, $ff, $c0, $ff, $80, $ff
    db $7f, $e0, $7f, $e0, $3f, $f0, $37, $f8, $3f, $f8, $1f, $f8, $0f, $fc, $0f, $fc
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $07, $ff, $07, $ff, $07, $ff, $07, $fe
    db $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00
    db $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $07, $ff, $07, $ff, $07
    db $ff, $e0, $ff, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $3f, $e0
    db $fb, $07, $ff, $03, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $00, $ff, $00
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $c0, $ff, $c0, $ff, $00, $ff
    db $e0, $7f, $e0, $7f, $f0, $3f, $f0, $3f, $f8, $3f, $f8, $1f, $fc, $0f, $fc, $0f
    db $03, $ff, $03, $ff, $01, $ff, $01, $ff, $01, $ff, $01, $ff, $00, $ff, $00, $ff
    db $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $80, $ff, $c0, $ff, $c0, $ff, $e0
    db $e0, $ff, $e0, $ff, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $7f, $e0, $3f
    db $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $07, $ff, $07, $ff, $07, $fe, $07
    db $fe, $07, $fe, $0f, $fc, $1f, $f8, $1f, $f0, $3f, $e0, $7f, $c0, $ff, $80, $ff
    db $80, $ff, $80, $ff, $80, $ff, $80, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $01, $ff, $01, $ff
    db $1f, $fc, $3f, $f8, $3f, $f0, $7f, $f0, $7f, $f0, $ff, $e0, $ff, $c0, $ff, $80
    db $03, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $ff, $07, $ff, $07, $ff, $07, $ff

    ; padding
    ds $a0, $00

; C: copied to VRAM/WRAM by Mode20_State00_MenuInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Gfx_1A_6400_Mode20_State00_MenuInit::
    INCBIN "data/bank_1a/Gfx_1A_6400_Mode20_State00_MenuInit.2bpp" ; $6400, 2048 bytes
; C: copied to VRAM/WRAM by Mode20_State00_MenuInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Gfx_1A_6C00_Mode20_State00_MenuInit::
    INCBIN "data/bank_1a/Gfx_1A_6C00_Mode20_State00_MenuInit.2bpp" ; $6C00, 2048 bytes
; C: copied to VRAM/WRAM by Mode20_State00_MenuInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Gfx_1A_7400_Mode20_State00_MenuInit::
    INCBIN "data/bank_1a/Gfx_1A_7400_Mode20_State00_MenuInit.2bpp" ; $7400, 512 bytes
; C: far pointer loaded by Album_LoadBorderScreen, Album_ShowPageScreenB (ld a,BANK; ld hl,ADDR; call banked copy/far
; call); length 1792 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic corpus,
; modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_1A_7600_Album_ShowPageScreenB::
    INCBIN "data/bank_1a/Gfx_1A_7600_Album_ShowPageScreenB.2bpp" ; $7600, 1680 bytes
; C: two 8 x 8 tiles that make one 16 x 8 px glyph (a small arrow: a triangle over a dash tail, by eye) between the
; two choice icons of the Right page of the photo-option menu. Album_ShowPageScreenB (04:6E3D, copy site 04:6E61)
; copies 1A:7600-7CFF to $8900, so the two tiles sit in VRAM at $8F90 / $8FA0 ...
Gfx_1A_7C90_Album_ShowPageScreenB_ArrowGlyph::
    INCBIN "data/bank_1a/Gfx_1A_7C90_Album_ShowPageScreenB_ArrowGlyph.2bpp" ; $7C90, 32 bytes
; C: continues Gfx_1A_7600_Album_ShowPageScreenB (after the arrow glyph at 1A:7C90). L3 pass 2026-10-26: read in BGB
; in 71 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
Gfx_1A_7600_Album_ShowPageScreenB_Cont::
    db $8c, $8c, $9f, $9f, $8f, $8f, $c3, $c3, $f0, $f0, $fc, $fc, $e7, $e7, $c0, $c0
    db $ff, $ff, $ff, $ff, $ff, $ff, $02, $02, $fb, $fb, $fb, $fb, $fb, $fb, $fb, $fb
    db $c3, $c3, $e7, $e7, $ff, $ff, $f3, $f3, $f3, $f3, $ff, $ff, $fd, $fd, $ff, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

    ; padding
    ds $10, $ff

    ; padding
    ds $80, $00

; C: TCRF unused graphic "B CANCEL" (circled B + the word CANCEL, 6 tiles): exact match of the TCRF image (2x upscale,
; 0 differing pixels of 384); never on screen in any replay and never read in an organic run (README 16.24)
Unused_TCRF_PhotoOption_BCancel_Gfx::
    db $20, $1f, $40, $23, $80, $6d, $80, $63, $80, $6d, $80, $63, $00, $7f, $3f, $3f
    db $00, $00, $00, $87, $40, $c6, $40, $c6, $40, $c6, $40, $c6, $80, $86, $00, $07
    db $00, $00, $00, $ce, $00, $db, $00, $1b, $00, $1b, $00, $df, $00, $db, $00, $db
    db $00, $00, $00, $66, $00, $76, $00, $76, $00, $7e, $00, $6e, $00, $6e, $00, $66
    db $00, $00, $00, $fb, $00, $db, $00, $c3, $00, $c3, $00, $db, $00, $db, $00, $fb
    db $00, $00, $00, $d8, $00, $18, $00, $18, $00, $d8, $00, $18, $00, $18, $00, $df

    ; padding
    ds $20, $00

; C: tile data with no direct pointer in the code (unreferenced); classified from its content - see sym_unconclusive.
; Owner (review page, 2026-10-13): graphic, by eye.
Gfx_1A_7E00_Unref::
    db $cf, $cf, $cf, $cf, $cf, $cf, $c1, $c0, $c1, $c0, $cf, $cf, $cf, $cf, $cf, $cf
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $03, $7f, $03, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $c1, $c0, $c1, $c0, $ff, $ff, $ff, $ff, $cf, $cf, $c3, $c3
    db $ff, $ff, $ff, $ff, $7f, $03, $7f, $03, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $c3
    db $f1, $f1, $fd, $fc, $fd, $fc, $f1, $f1, $c3, $c3, $cf, $cf, $ff, $ff, $ff, $ff
    db $7f, $0f, $7f, $3f, $7f, $3f, $7f, $0f, $ff, $c3, $ff, $f3, $ff, $ff, $ff, $ff
    db $cf, $ce, $cf, $ce, $cf, $ce, $cf, $ce, $cf, $ce, $c1, $c0, $c1, $c0, $ff, $ff
    db $7f, $73, $7f, $73, $7f, $73, $7f, $73, $7f, $73, $7f, $03, $7f, $03, $ff, $ff
    db $ff, $ff, $fe, $c0, $fe, $c0, $fe, $ce, $fe, $ce, $fe, $ce, $fe, $ce, $fe, $ce
    db $ff, $ff, $83, $03, $83, $03, $f3, $73, $f3, $73, $f3, $73, $f3, $73, $f3, $73
    db $ff, $ff, $ff, $ff, $ff, $cf, $ff, $c3, $fe, $f0, $fe, $fc, $fe, $fc, $fe, $f0
    db $ff, $ff, $ff, $ff, $f3, $f3, $c3, $c3, $8f, $8f, $bf, $3f, $bf, $3f, $8f, $8f
    db $ff, $c3, $ff, $cf, $ff, $ff, $ff, $ff, $fe, $c0, $fe, $c0, $ff, $ff, $ff, $ff
    db $c3, $c3, $f3, $f3, $ff, $ff, $ff, $ff, $83, $03, $83, $03, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $c0, $fe, $c0, $ff, $ff, $ff, $ff, $ff, $ff
    db $f3, $f3, $f3, $f3, $f3, $f3, $83, $03, $83, $03, $f3, $f3, $f3, $f3, $f3, $f3
    db $00, $00, $03, $00, $06, $00, $0c, $00, $38, $00, $e3, $00, $8b, $00, $bb, $00
    db $00, $00, $c0, $00, $60, $00, $60, $00, $e0, $00, $8f, $00, $78, $00, $43, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $b8, $00, $fc, $00, $c7, $00
    db $00, $00, $01, $00, $1f, $00, $10, $00, $11, $00, $7f, $00, $cd, $00, $8f, $00
    db $00, $00, $fc, $00, $0c, $00, $1c, $00, $98, $00, $be, $00, $87, $00, $63, $00
    db $00, $00, $07, $00, $04, $00, $04, $00, $04, $00, $04, $00, $0c, $00, $18, $00
    db $00, $00, $c0, $00, $40, $00, $40, $00, $40, $00, $c0, $00, $de, $00, $97, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fe, $00, $87, $00
    db $fb, $00, $09, $00, $09, $00, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $73, $00, $f3, $00, $c0, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $40, $00, $f8, $00, $8f, $00, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3e, $00, $fe, $00, $c7, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $73, $00, $73, $00, $df, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $31, $00, $e3, $00, $cf, $00, $7c, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $90, $00, $18, $00, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $71, $00, $79, $00, $cf

    ; padding
    ds $b, $00

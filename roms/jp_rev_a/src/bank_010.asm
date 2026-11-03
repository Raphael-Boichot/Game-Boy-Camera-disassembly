; Pocket Camera (Japan) (Rev A), bank $10. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $010", ROMX[$4000], BANK[$10]

; C: entry 16 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_4000_Head::
    INCBIN "data/bank_10/Gfx_10_4000_Head.2bpp" ; $4000, 896 bytes
; C: entry 17 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_4380_Head::
    INCBIN "data/bank_10/Gfx_10_4380_Head.2bpp" ; $4380, 896 bytes
; C: entry 18 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_4700_Head::
    INCBIN "data/bank_10/Gfx_10_4700_Head.2bpp" ; $4700, 896 bytes
; C: entry 19 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_4A80_Head::
    INCBIN "data/bank_10/Gfx_10_4A80_Head.2bpp" ; $4A80, 896 bytes
; C: entry 20 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_4E00_Head::
    INCBIN "data/bank_10/Gfx_10_4E00_Head.2bpp" ; $4E00, 896 bytes
; C: entry 21 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_5180_Head::
    INCBIN "data/bank_10/Gfx_10_5180_Head.2bpp" ; $5180, 896 bytes
; C: entry 22 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_5500_Head::
    INCBIN "data/bank_10/Gfx_10_5500_Head.2bpp" ; $5500, 896 bytes
; C: entry 23 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_10_5880_Head::
    INCBIN "data/bank_10/Gfx_10_5880_Head.2bpp" ; $5880, 896 bytes
; C: copied to VRAM/WRAM by Mode1F_State00_TitleInit (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not
; reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1F)
Gfx_10_5C00_Mode1F_State00_TitleInit::
    INCBIN "data/bank_10/Gfx_10_5C00_Mode1F_State00_TitleInit.2bpp" ; $5C00, 6144 bytes
; C: numeral table: DjTitle_LoadNumeralTile (05:423A) copies 32 bytes from $7400 + A x 32; 10 entries = 7400-7540 (the
; next asset starts there); were Gfx_10_7420_..._Aux, TileGap_10_74A0 and Gfx_10_74A3_Unref
Gfx_10_7400_DjTitle_LoadNumeralTile::
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $99
    db $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81, $ff, $81, $ff, $ff
    db $7e, $7e, $7e, $42, $7e, $42, $7e, $72, $1e, $12, $1e, $12, $1e, $12, $1e, $12
    db $1e, $12, $1e, $12, $1e, $12, $1e, $12, $1e, $12, $1e, $12, $1e, $12, $1e, $1e
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $ff, $f9, $ff, $81
    db $ff, $81, $ff, $9f, $f0, $90, $f0, $90, $ff, $9f, $ff, $81, $ff, $81, $ff, $ff
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $ff, $f9, $ff, $81
    db $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $ff, $f9, $ff, $81, $ff, $81, $ff, $ff
    db $ff, $ff, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81, $ff, $81
    db $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $0f
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $9f, $f0, $90, $f0, $90, $ff, $9f, $ff, $81
    db $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $ff, $f9, $ff, $81, $ff, $81, $ff, $ff
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $9f, $f0, $90, $f0, $90, $ff, $9f, $ff, $81
    db $ff, $81, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81, $ff, $81, $ff, $ff
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $0f, $09, $0f, $09
    db $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $09, $0f, $0f
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81
    db $ff, $81, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81, $ff, $81, $ff, $ff
    db $ff, $ff, $ff, $81, $ff, $81, $ff, $99, $ff, $99, $ff, $99, $ff, $99, $ff, $81
    db $ff, $81, $ff, $f9, $0f, $09, $0f, $09, $ff, $f9, $ff, $81, $ff, $81, $ff, $ff

    ; padding
    ds $c0, $00

; C: tiles 00-2A of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7600_DjPrintFont_Tiles00to2A::
    INCBIN "data/bank_10/Gfx_10_7600_DjPrintFont_Tiles00to2A.bin" ; $7600, 680 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides) | inside the printer text font:
; slots 2A-2B (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by
; Gfx_Copy16FromBank10 but no copy read these bytes in the replays. glyph slots $2A-$2B of ...
DjPrintFont_10_78A8_Slots2Ato2B::
    INCBIN "data/bank_10/DjPrintFont_10_78A8_Slots2Ato2B.2bpp" ; $78A8, 16 bytes
; C: tiles 2B-2C of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_78B8_DjPrintFont_Tiles2Bto2C::
    db $a1, $a1, $bd, $bd, $81, $81, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00
    db $e0, $e0, $a0, $a0, $a0, $a0, $a0, $a0

    ; padding
    ds $18, $00

; C: tile-like bytes between unreferenced tile blocks of bank 10, no copy reads them (the coverage run saw only the
; printer packet sender and forced reads); was Data_10_78E8 | inside the printer text font: slots 2E-30
; (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by ...
DjPrintFont_10_78E8_Slots2Eto30::
    INCBIN "data/bank_10/DjPrintFont_10_78E8_Slots2Eto30.2bpp" ; $78E8, 32 bytes
; C: tiles 30-3F of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7908_DjPrintFont_Tiles30to3F::
    db $30, $30, $30, $30, $10, $10, $20, $20, $76, $76, $76, $76, $66, $66, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $18, $18, $18, $18, $18, $18, $18, $18
    db $18, $18, $3c, $3c, $00, $00, $00, $00, $18, $18, $30, $30, $60, $60, $60, $60
    db $60, $60, $7e, $7e, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $06, $06
    db $06, $06, $06, $06, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $66, $66, $66, $66, $66, $66, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $18, $18, $18, $18, $18, $18, $18, $18
    db $18, $18, $18, $18, $00, $00, $00, $00, $66, $66, $66, $66, $66, $66, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $3e, $3e, $06, $06, $06, $06, $66, $66
    db $66, $66, $3c, $3c, $00, $00, $00, $00, $ff, $ff, $81, $81, $b9, $b9, $a5, $a5
    db $b9, $b9, $a5, $a5, $81, $81, $ff, $ff, $a0, $a0, $a0, $a0, $bf, $bf, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $88, $88, $8f, $8f, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ff, $ff

    ; padding
    ds $12, $00

; C: tile-like bytes between unreferenced tile blocks of bank 10, no copy reads them (the coverage run saw only the
; printer packet sender and forced reads); was Data_10_7A08 | inside the printer text font: slots 40-42
; (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by ...
DjPrintFont_10_7A08_Slots40to42::
    INCBIN "data/bank_10/DjPrintFont_10_7A08_Slots40to42.bin" ; $7A08, 28 bytes
; C: tiles 42-47 of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7A24_DjPrintFont_Tiles42to47::
    INCBIN "data/bank_10/Gfx_10_7A24_DjPrintFont_Tiles42to47.bin" ; $7A24, 92 bytes
; C: TCRF unused "SOUND print modulation" icon, top row (tiles 0-1 of 2x2): exact match of the TCRF image; bottom row
; at 10:7B80; never on screen, never read in an organic run (README 16.24) | slots $48-$49 of the printer text font
; (character codes $48 and $49; bottom halves = slots $58-$59 at 10:7B80): ...
Unused_TCRF_SoundPrintModulationIcon_TopRow_Gfx::
    INCBIN "data/bank_10/Unused_TCRF_SoundPrintModulationIcon_TopRow_Gfx.2bpp" ; $7A80, 32 bytes
; C: tiles 4A-4C of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7AA0_DjPrintFont_Tiles4Ato4C::
    db $00, $00, $00, $00, $03, $03, $04, $04, $08, $08, $08, $08, $00, $00, $00, $00
    db $00, $00, $00, $00, $80, $80, $40, $40, $20, $20, $20, $20, $20, $20, $40, $40
    db $00, $00, $c0, $c0, $40, $40, $40, $40, $40, $40, $40, $40

    ; padding
    ds $12, $00

; C: tiles 4D-57 of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7ADE_DjPrintFont_Tiles4Dto57::
    INCBIN "data/bank_10/Gfx_10_7ADE_DjPrintFont_Tiles4Dto57.bin" ; $7ADE, 162 bytes
; C: TCRF unused "SOUND print modulation" icon, bottom row (tiles 2-3 of 2x2); top row at 10:7A80 (README 16.24) |
; bottom halves (slots $58-$59) of the 2-character icon whose top halves are at 10:7A80: the renderer draws glyph c
; and c + $10 (C, code)
Unused_TCRF_SoundPrintModulationIcon_BottomRow_Gfx::
    INCBIN "data/bank_10/Unused_TCRF_SoundPrintModulationIcon_BottomRow_Gfx.2bpp" ; $7B80, 32 bytes
; C: tiles 5A-5B of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7BA0_DjPrintFont_Tiles5Ato5B::
    db $00, $00, $01, $01, $01, $01, $00, $00, $01, $01, $01, $01, $00, $00, $00, $00
    db $80, $80

    ; padding
    ds $10, $00

; C: tile-like bytes between unreferenced tile blocks of bank 10, no copy reads them (the coverage run saw only the
; printer packet sender and forced reads); was Data_10_7BC2 | inside the printer text font: slots 5C-5E
; (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by ...
DjPrintFont_10_7BC2_Slots5Cto5E::
    INCBIN "data/bank_10/DjPrintFont_10_7BC2_Slots5Cto5E.bin" ; $7BC2, 34 bytes
; C: tile-like bytes between unreferenced tile blocks of bank 10, no copy reads them (the coverage run saw only the
; printer packet sender and forced reads); was Data_10_7BE4 | inside the printer text font: slots 5E-5F
; (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by ...
DjPrintFont_10_7BE4_Slots5Eto5F::
    INCBIN "data/bank_10/DjPrintFont_10_7BE4_Slots5Eto5F.bin" ; $7BE4, 20 bytes
; C: tiles 5F-75 of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7BF8_DjPrintFont_Tiles5Fto75::
    INCBIN "data/bank_10/Gfx_10_7BF8_DjPrintFont_Tiles5Fto75.bin" ; $7BF8, 345 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides) | inside the printer text font:
; slots 75-75 (Gfx_10_7600_DjPrintFont_Tiles00to2A and the neighbours); the glyph is addressable by
; Gfx_Copy16FromBank10 but no copy read these bytes in the replays. L3 pass 2026-10-26: no ...
DjPrintFont_10_7D51_Slot75::
    INCBIN "data/bank_10/DjPrintFont_10_7D51_Slot75.bin" ; $7D51, 1 bytes
; C: tiles 75-8B of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7D52_DjPrintFont_Tiles75to8B::
    db $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $00, $00, $00, $00, $6e, $6e
    db $66, $66, $66, $66, $66, $66, $66, $66, $3e, $3e, $00, $00, $00, $00, $7e, $7e
    db $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00, $18, $18
    db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $00, $00, $00, $00, $06, $06
    db $66, $66, $66, $66, $66, $66, $66, $66, $3c, $3c, $00, $00, $00, $00, $70, $70
    db $78, $78, $6c, $6c, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00, $60, $60
    db $60, $60, $60, $60, $60, $60, $60, $60, $7e, $7e, $00, $00, $00, $00, $6a, $6a
    db $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $00, $00, $00, $00, $7e, $7e
    db $6e, $6e, $6e, $6e, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00, $66, $66
    db $66, $66, $66, $66, $66, $66, $66, $66, $3c, $3c, $00, $00, $00, $00, $60, $60
    db $60, $60, $60, $60, $60, $60, $60, $60, $60, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $3c, $3c, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00
    db $00, $00, $7c, $7c, $66, $66, $66, $66, $66, $66, $66, $66, $7c, $7c, $00, $00
    db $00, $00, $3c, $3c, $66, $66, $66, $66, $60, $60, $60, $60, $3c, $3c, $00, $00
    db $00, $00, $7e, $7e, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $00, $00
    db $00, $00, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00
    db $00, $00, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00
    db $00, $00, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $00, $00
    db $00, $00, $66, $66, $66, $66, $66, $66, $66, $66, $3c, $3c, $18, $18, $00, $00
    db $00, $00, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00
    db $00, $00, $7e, $7e, $06, $06, $06, $06, $0c, $0c, $0c, $0c, $18, $18, $00, $00
    db $00, $00, $00, $00, $32, $32, $3e, $32, $1e, $0c, $04, $04, $6c, $68, $00, $00
    db $00, $00, $00, $00, $10, $10, $92, $10, $92, $d6, $54, $38, $38, $10

    ; padding
    ds $40, $00

; C: tiles 90-9B of the printer text font: slot k = 16 bytes at $7600 + 16 k, read by Gfx_Copy16FromBank10 (00:1615)
; which the D.J. score print renderer (05:60EE, calls 05:610D / 05:611B) feeds with the character codes of the 20-code
; row tables (05:5ABB-5EBE) and the computed codes; read in the forced ...
Gfx_10_7F00_DjPrintFont_Tiles90to9B::
    db $76, $76, $76, $76, $6e, $6e, $6c, $6c, $66, $66, $3a, $3a, $00, $00, $00, $00
    db $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00
    db $06, $06, $06, $06, $06, $06, $66, $66, $66, $66, $3c, $3c, $00, $00, $00, $00
    db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $00, $00, $00, $00
    db $66, $66, $66, $66, $66, $66, $66, $66, $66, $66, $3c, $3c, $00, $00, $00, $00
    db $66, $66, $66, $66, $6c, $6c, $78, $78, $70, $70, $60, $60, $00, $00, $00, $00
    db $6a, $6a, $6a, $6a, $6a, $6a, $6a, $6a, $7e, $7e, $34, $34, $00, $00, $00, $00
    db $18, $18, $3c, $3c, $66, $66, $66, $66, $66, $66, $66, $66, $00, $00, $00, $00
    db $3c, $3c, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $00, $00, $00, $00
    db $18, $18, $30, $30, $30, $30, $60, $60, $60, $60, $7e, $7e, $00, $00, $00, $00
    db $78, $78, $18, $08, $08, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00
    db $54, $38, $92, $d6, $92, $10, $10, $10

    ; padding
    ds $48, $00

; Game Boy Camera (USA, Europe), bank $2A. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02a", ROMX[$4000], BANK[$2a]

; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 226 tiles | start of the 256-slot glyph font table: slot
; k at $4000 + 32 k, read by Kb_LoadGlyphList (index) and Glyph_LoadFromCharCode (code - 1) (C, 09:5424 / 09:4802);
; the $6000 table is the small-kana one. L3 pass 2026-10-26: read in BGB ...
Sheet_MiscellaneousStampsJpn_2A_4000::
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $fc, $fc, $28, $28, $38, $38
    db $6c, $6c, $aa, $aa, $aa, $aa, $b2, $b2, $54, $54, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $84, $84
    db $82, $82, $82, $82, $42, $42, $50, $50, $20, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $78, $78, $00, $00, $38, $38
    db $c4, $c4, $04, $04, $04, $04, $08, $08, $30, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $78, $78, $00, $00, $fc, $fc
    db $08, $08, $10, $10, $38, $38, $48, $48, $8e, $8e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $24, $24, $fa, $fa, $20, $20
    db $3c, $3c, $62, $62, $a2, $a2, $a2, $a2, $64, $64, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $f4, $f4, $2a, $2a
    db $4a, $4a, $4a, $4a, $88, $88, $88, $88, $10, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $14, $14, $78, $78, $0a, $0a
    db $3c, $3c, $04, $04, $42, $42, $40, $40, $3c, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $08, $08, $10, $10, $20, $20
    db $40, $40, $60, $60, $10, $10, $08, $08, $04, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $84, $84, $86, $86, $9c, $9c
    db $84, $84, $84, $84, $84, $84, $84, $84, $48, $48, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $78, $78, $04, $04, $08, $08
    db $00, $00, $40, $40, $80, $80, $82, $82, $7c, $7c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $fc, $fc, $10, $10
    db $08, $08, $08, $08, $84, $84, $80, $80, $78, $78, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $40, $40
    db $80, $80, $80, $80, $82, $82, $44, $44, $38, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $fe, $fe, $08, $08, $38, $38
    db $48, $48, $48, $48, $38, $38, $08, $08, $30, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $44, $44, $44, $fe, $fe
    db $44, $44, $4c, $4c, $40, $40, $40, $40, $3c, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $7c, $18, $18, $20, $20
    db $fe, $fe, $10, $10, $20, $20, $20, $20, $1c, $1c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $f8, $f8, $20, $20
    db $4e, $4e, $40, $40, $40, $40, $90, $90, $8e, $8e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $fc, $fc, $20, $20
    db $3c, $3c, $42, $42, $02, $02, $04, $04, $38, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $3c, $c2, $c2
    db $02, $02, $02, $02, $04, $04, $38, $38, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0e, $0e, $f0, $f0, $10, $10
    db $20, $20, $20, $20, $20, $20, $10, $10, $0c, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $2c, $2c, $30, $30
    db $20, $20, $40, $40, $80, $80, $80, $80, $7e, $7e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $f4, $f4, $22, $22, $4a, $4a
    db $48, $48, $98, $98, $ac, $ac, $2a, $2a, $10, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8e, $8e, $b0, $b0, $80, $80
    db $80, $80, $80, $80, $a0, $a0, $9e, $9e, $40, $40, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $58, $58, $6c, $6c, $4a, $4a
    db $aa, $aa, $92, $92, $ae, $ae, $4a, $4a, $04, $04, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $30, $30, $ec, $ec, $32, $32
    db $22, $22, $62, $62, $66, $66, $aa, $aa, $24, $24, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $54, $54, $92, $92
    db $92, $92, $a2, $a2, $a2, $a2, $44, $44, $18, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $84, $84, $be, $be, $84, $84
    db $84, $84, $84, $84, $9e, $9e, $a4, $a4, $58, $58, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $24, $24, $c4, $c4, $46, $46
    db $84, $84, $84, $84, $88, $88, $88, $88, $70, $70, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $10, $10, $00, $00, $20, $20
    db $14, $14, $92, $92, $92, $92, $92, $92, $20, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $50, $50
    db $88, $88, $04, $04, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $be, $be, $84, $84, $be, $be
    db $84, $84, $84, $84, $9c, $9c, $a6, $a6, $58, $58, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $fe, $fe, $10, $10
    db $7c, $7c, $10, $10, $7c, $7c, $92, $92, $60, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $70, $70, $12, $12, $12, $12
    db $7e, $7e, $92, $92, $a2, $a2, $44, $44, $08, $08, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $20, $20, $20, $20, $f4, $f4, $22, $22
    db $62, $62, $a0, $a0, $a2, $a2, $42, $42, $3c, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $08, $08, $58, $58, $6c, $6c, $4a, $4a
    db $aa, $aa, $92, $92, $a2, $a2, $44, $44, $08, $08, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $f0, $f0, $40, $40
    db $f0, $f0, $42, $42, $42, $42, $44, $44, $38, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $88, $88, $88, $88, $9c, $9c, $6a, $6a
    db $c2, $c2, $4c, $4c, $20, $20, $20, $20, $20, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $08, $08, $9c, $9c, $aa, $aa
    db $ca, $ca, $8a, $8a, $92, $92, $1c, $1c, $20, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $0e, $0e, $08, $08
    db $08, $08, $38, $38, $4c, $4c, $4a, $4a, $30, $30, $00, $00, $00, $00, $00, $00
    db $00

    ; padding
    ds $13, $00

; C: 6 bytes inside slot $26 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by no Kb_LoadGlyphList list (A, B, C) names it: it is read through
; Glyph_LoadFromCharCode (09:4802, char code = slot + 1); content pixel ...
Gfx_2A_44D4_FontSlot26::
    db $60, $40, $60, $20, $20, $20

    ; padding
    ds $1a, $00

; C: 16 bytes inside slots $27-$28 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x
; slot); every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set A, lists at 09:53D3 / 53F5 /
; 5417); content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_44F4_FontSlots27to28::
    INCBIN "data/bank_2a/Gfx_2A_44F4_FontSlots27to28.2bpp" ; $44F4, 16 bytes
; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 256 tiles. L3 pass 2026-10-26: read in BGB in 4
; replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousStampsJpn_2A_4504::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_4504.bin" ; $4504, 1311 bytes
; C: 23 bytes inside slot $51 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set A, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_4A23_FontSlot51::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $48, $48, $44
    db $44, $44, $44, $44, $44, $20, $20

    ; padding
    ds $14, $00

; C: 12 bytes inside slot $52 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set A, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_4A4E_FontSlot52::
    db $20, $20, $10, $10, $38, $38, $44, $44, $04, $04, $18, $18

    ; padding
    ds $10, $00

; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 441 tiles. L3 pass 2026-10-26: read in BGB in 4
; replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousStampsJpn_2A_4A6A::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_4A6A.bin" ; $4A6A, 1782 bytes
; I: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $8C of roms/jp_rev_a/disasm/charset_jp.csv; no organic run typed ...
Font_2A_5160_Glyph8C::
    INCBIN "data/bank_2a/Font_2A_5160_Glyph8C.2bpp" ; $5160, 32 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 441 tiles. glyph bytes of the name / comment font: code
; c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, README 16.27), codes $8D-$94 of
; roms/jp_rev_a/disasm/charset_jp.csv (the stamp sheet of the Spriters Resource reuses these ...
Font_2A_5180_Glyphs8Dto94::
    INCBIN "data/bank_2a/Font_2A_5180_Glyphs8Dto94.2bpp" ; $5180, 256 bytes
; I: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $95, $96 of roms/jp_rev_a/disasm/charset_jp.csv; no organic run ...
Font_2A_5280_Glyphs95to96::
    INCBIN "data/bank_2a/Font_2A_5280_Glyphs95to96.2bpp" ; $5280, 64 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 441 tiles. glyph bytes of the name / comment font: code
; c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, README 16.27), codes $97-$9C of
; roms/jp_rev_a/disasm/charset_jp.csv (the stamp sheet of the Spriters Resource reuses these ...
Font_2A_52C0_Glyphs97to9C::
    INCBIN "data/bank_2a/Font_2A_52C0_Glyphs97to9C.2bpp" ; $52C0, 192 bytes
; I: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $9D, $9E of roms/jp_rev_a/disasm/charset_jp.csv; no organic run ...
Font_2A_5380_Glyphs9Dto9E::
    INCBIN "data/bank_2a/Font_2A_5380_Glyphs9Dto9E.2bpp" ; $5380, 64 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 441 tiles. glyph bytes of the name / comment font: code
; c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, README 16.27), codes $9F-$9F of
; roms/jp_rev_a/disasm/charset_jp.csv (the stamp sheet of the Spriters Resource reuses these ...
Font_2A_53C0_Glyph9F::
    INCBIN "data/bank_2a/Font_2A_53C0_Glyph9F.2bpp" ; $53C0, 32 bytes
; I: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $A0 of roms/jp_rev_a/disasm/charset_jp.csv; no organic run typed ...
Font_2A_53E0_GlyphA0::
    INCBIN "data/bank_2a/Font_2A_53E0_GlyphA0.bin" ; $53E0, 26 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 441 tiles. L3 pass 2026-10-26: not reached by the 206
; BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in
; mode 08)
Sheet_MiscellaneousStampsJpn_2A_4A6A_Part53FA::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_4A6A_Part53FA.bin" ; $53FA, 7 bytes
; I: 25 bytes inside slot $A0 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5401_FontSlotA0::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $7c, $04
    db $04, $08, $08, $10, $10, $20, $20, $7c, $7c

    ; padding
    ds $14, $00

    db $30, $30

; I: 10 bytes inside slot $A1 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5430_FontSlotA1::
    db $30, $30, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $14, $00

    db $4c, $4c, $32, $32

; I: 8 bytes inside slot $A2 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5452_FontSlotA2::
    db $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $a, $00

    db $08, $08, $08, $08, $38, $7c, $44, $44, $44, $44, $7c, $7c

; I: 10 bytes inside slot $A3 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5470_FontSlotA3::
    db $7c, $54, $7c, $7c, $7c, $54, $7c, $7c, $7c, $54

    db $38, $7c

    ; padding
    ds $16, $00

; I: 2 bytes inside slot $A4 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set A/B, lists at 09:53D3 / 53F5 /
; 5417); content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5492_FontSlotA4::
    db $00, $00

    ; padding
    ds $14, $00

    db $08, $08, $10, $10, $00, $00, $18, $18

; I: 10 bytes inside slot $A5 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_54B0_FontSlotA5::
    INCBIN "data/bank_2a/Gfx_2A_54B0_FontSlotA5.2bpp" ; $54B0, 32 bytes
; I: 10 bytes inside slot $A6 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_54D0_FontSlotA6::
    INCBIN "data/bank_2a/Gfx_2A_54D0_FontSlotA6.2bpp" ; $54D0, 32 bytes
; I: 10 bytes inside slot $A7 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_54F0_FontSlotA7::
    db $28, $28, $48, $48, $48, $48, $48, $48, $34, $34

    ; padding
    ds $10, $00

    db $28, $28, $00, $00, $18, $18, $28, $28

; I: 8 bytes inside slot $A8 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set B, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5512_FontSlotA8::
    INCBIN "data/bank_2a/Gfx_2A_5512_FontSlotA8.bin" ; $5512, 24 bytes
; I: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 150 tiles. L3 pass 2026-10-26: not reached by the 206
; BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in
; mode 08)
Sheet_MiscellaneousStampsJpn_2A_552A::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_552A.bin" ; $552A, 817 bytes
; I: 31 bytes inside slots $C2-$C3 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x
; slot); every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 /
; 5417); content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_585B_FontSlotsC2toC3::
    INCBIN "data/bank_2a/Gfx_2A_585B_FontSlotsC2toC3.bin" ; $585B, 61 bytes
; I: 22 bytes inside slots $C4-$C5 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x
; slot); every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 /
; 5417); content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_5898_FontSlotsC4toC5::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $64, $64, $98, $98
    db $00, $00, $00, $00, $00, $00

    ; padding
    ds $14, $00

    db $6c, $6c, $24, $24, $48, $48

    ; padding
    ds $e, $00

; I: 6 bytes inside slot $C6 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_58D6_FontSlotC6::
    db $00, $00, $00, $00, $00, $00

    ; padding
    ds $8, $00

    db $38, $38, $44, $44, $92, $92, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $9c, $9c
    db $40, $40

; I: 4 bytes inside slot $C7 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x slot);
; every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 / 5417);
; content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_58F6_FontSlotC7::
    db $38, $38, $00, $00

    ; padding
    ds $10, $00

; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 41 tiles. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 08)
Sheet_MiscellaneousStampsJpn_2A_590A::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_590A.bin" ; $590A, 245 bytes
; C: 105 bytes inside slots $CF-$D3 of the glyph font at 2A:4000 (32 B = 2 tiles per glyph, address = $4000 + 32 x
; slot); every byte is read in the organic coverage runs, by Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 /
; 5417); content pixel data (the Spriters sheet match stops short of it)
Gfx_2A_59FF_FontSlotsCFtoD3::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $00, $00, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $00, $00, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $44, $44, $38, $38, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40, $40, $40, $40, $44
    db $44, $48, $48, $50, $50, $68, $68, $44, $44, $44, $44, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $12, $10

; C: 12 zero bytes inside slots $D3-$D4 of the glyph font at 2A:4000, read organically by the call to
; Vram_CopyFromBank in Kb_LoadGlyphList (09:5445); Kb_LoadGlyphList (glyph set C, lists at 09:53D3 / 53F5 / 5417);
; blank part of a glyph (was 'a stamp tile load'); was Data_2A_5A7A. L3 pass 2026-10-26: ...
Gfx_2A_5A7A_FontSlotsD3toD4_Blank::
    INCBIN "data/bank_2a/Gfx_2A_5A7A_FontSlotsD3toD4_Blank.bin" ; $5A7A, 12 bytes
; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 131 tiles. L3 pass 2026-10-26: not reached by the 206
; BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in
; mode 08)
Sheet_MiscellaneousStampsJpn_2A_5A86::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_5A86.bin" ; $5A86, 824 bytes
; C: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $EE, $EF, $F0, $F1, $F2, $F3 of ...
Font_2A_5DBE_GlyphsEEtoF3::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $44, $44, $44, $44
    db $38, $38, $44, $44, $44, $44, $44, $44, $44, $44, $38, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $38, $38, $44, $44, $44, $44
    db $44, $44, $44, $44, $3c, $3c, $04, $04, $44, $44, $38, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $04, $04, $04, $04, $08, $08, $08, $08
    db $10, $10, $10, $10, $20, $20, $20, $20, $40, $40, $40, $40, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $00, $00
    db $00, $00, $00, $00, $18, $18, $18, $18, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $64, $64, $98, $98

    ; padding
    ds $1a, $00

; C: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $F4 of roms/jp_rev_a/disasm/charset_jp.csv; no organic run typed ...
Font_2A_5E62_GlyphF4::
    db $6c, $6c, $24, $24, $48, $48

    ; padding
    ds $1c, $00

; C: tiles of the small kana / ASCII font (voiced and semi-voiced kana variants among them). glyph bytes of the name /
; comment font: code c is at 2A:4000 + (c-1) x 32 (Glyph_LoadFromCharCode 09:4802, BGB glyph rule, README 16.27),
; codes $F5 of roms/jp_rev_a/disasm/charset_jp.csv; no organic run typed ...
Font_2A_5E84_GlyphF5::
    db $38, $38, $44, $44, $92, $92, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $aa, $9c, $9c
    db $40, $40, $38, $38

    ; padding
    ds $162, $00

; C: Spriter's Resource sheet "Miscellaneous - Stamps (JPN)", 2379 tiles. L3 pass 2026-10-26: read in BGB in 6
; replay(s) of the organic corpus, modes 08 09 0A (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousStampsJpn_2A_5FFA::
    INCBIN "data/bank_2a/Sheet_MiscellaneousStampsJpn_2A_5FFA.bin" ; $5FFA, 6 bytes
; I: stamp categories 4 and 5 (same graphics, different mask fill): small kana, 245 items x $20 B (2 tiles)
StampCat04_05_SmallKana_Gfx::
    db $00, $00, $00, $00, $20, $30, $fe, $fc, $32, $fc, $24, $30, $36, $3c, $7c, $7e
    db $d7, $fe, $bf, $da, $b3, $fe, $6c, $fe, $00, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $60, $c4, $66, $c6, $66, $62, $c6, $67, $c2, $46, $c3
    db $46, $c3, $74, $c3, $5b, $f2, $a8, $70, $50, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7c, $3e, $7c, $04, $18, $7e, $7c, $e6, $fe, $0a, $c6
    db $06, $06, $04, $0e, $1c, $1c, $38, $38, $30, $20, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7c, $3c, $7c, $1c, $00, $7c, $7c, $0c, $7c, $58, $0c
    db $38, $18, $70, $38, $7a, $f8, $ce, $ee, $04, $ce, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $30, $20, $fe, $ff, $fe, $21, $33, $26, $30, $3e, $3c
    db $f3, $7e, $a2, $f7, $a7, $f2, $7a, $e6, $46, $6c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1e, $34, $1e, $36, $16, $7b, $fa, $7c, $54, $3e, $64, $36
    db $34, $66, $5e, $64, $46, $ec, $dc, $fc, $5c, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $16, $16, $7e, $7a, $7c, $16, $1e, $78, $7e, $08, $7c
    db $04, $0e, $42, $66, $40, $60, $22, $7c, $1e, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $04, $02, $06, $0e, $0e, $1c, $70, $38, $60, $e0, $c0, $c0
    db $70, $e0, $78, $38, $0c, $1e, $06, $06, $02, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $44, $cc, $c4, $cc, $fe, $fe, $84, $fe, $84, $cc, $84, $cc
    db $84, $cc, $c4, $cc, $cc, $cc, $48, $dc, $d8, $08, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $2e, $1c, $7e, $7e, $5a, $66, $06, $0c, $1c, $08, $20, $00
    db $60, $60, $40, $c0, $55, $e2, $fe, $7f, $10, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $30, $16, $3e, $b8, $fe, $d0, $f8, $08, $18, $1c, $0c
    db $cc, $06, $81, $c0, $a0, $c0, $40, $fc, $bc, $7c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $60, $c0, $60, $c0, $80, $c0, $80, $c0, $80, $c0, $80, $c0
    db $81, $c6, $85, $c6, $86, $cc, $48, $fc, $30, $78, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $18, $08, $fe, $fe, $fe, $38, $18, $38, $78, $cc, $78
    db $ec, $58, $3c, $78, $48, $38, $08, $18, $18, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $4e, $64, $4e, $64, $ff, $fe, $45, $fe, $e6, $4c, $e6, $4c
    db $e6, $4c, $e4, $40, $40, $66, $3e, $7e, $38, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $52, $66, $2c, $76, $38, $1c, $31, $7e, $7f, $fe, $5c, $38
    db $20, $70, $60, $60, $50, $60, $26, $7e, $1c, $3e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $30, $21, $fe, $ff, $fe, $32, $6c, $3e, $7e, $7a, $66
    db $74, $6c, $48, $60, $c0, $70, $d0, $7e, $ce, $5e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $60, $20, $21, $fe, $ff, $fe, $40, $60, $7c, $f8, $46, $fc
    db $8c, $c6, $04, $06, $64, $0c, $48, $7c, $30, $78, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $44, $38, $3e, $fc, $de, $e6, $02, $06, $02, $06, $02, $06
    db $06, $06, $06, $0c, $28, $1c, $30, $38, $08, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $ff, $fe, $ff, $ee, $1c, $10, $38, $20, $30, $70, $20
    db $20, $60, $30, $60, $7e, $30, $1e, $3e, $10, $0e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $18, $10, $18, $16, $18, $1e, $1e, $30, $3e, $40, $70
    db $c0, $60, $40, $c0, $60, $c0, $c0, $7e, $7e, $3e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $30, $2c, $f6, $fa, $ff, $a4, $7b, $24, $6c, $44, $6c
    db $46, $6c, $5c, $7e, $6e, $77, $e5, $7e, $5c, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $ee, $5e, $53, $fe, $5a, $e6, $84, $c6, $80, $c0, $a0, $c0
    db $90, $e0, $a0, $f0, $b4, $fb, $de, $7f, $ec, $40, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $30, $10, $78, $d8, $5c, $fc, $f4, $7e, $da, $f6, $a2, $f6
    db $ea, $b6, $bc, $fe, $ff, $f6, $7c, $de, $00, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $60, $2c, $7e, $f2, $fe, $aa, $76, $32, $66, $22, $66
    db $6a, $e6, $de, $fe, $fa, $f6, $5f, $7e, $52, $6c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $1c, $5e, $3c, $2a, $7e, $cb, $7e, $77, $da, $53, $da
    db $57, $da, $5e, $f2, $72, $f6, $ac, $76, $78, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $c4, $4c, $44, $cc, $7f, $fe, $45, $fe, $44, $cc, $44, $cc
    db $64, $dc, $7d, $fe, $7e, $ef, $7f, $fc, $d8, $7c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $e2, $34, $f4, $f6, $27, $f6, $27, $67, $45, $66, $e4, $46
    db $e4, $46, $ec, $46, $44, $6c, $38, $7c, $10, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $28, $70, $50, $38, $78, $18, $cc, $76, $74, $de, $5b, $de
    db $cb, $de, $cb, $de, $9f, $da, $f7, $fa, $ba, $70, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $50, $20, $f0, $70, $50, $f8, $a8, $d8, $58, $8c, $04, $0c
    db $06, $0c, $02, $06, $06, $02, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $c0, $7e, $7e, $fe, $78, $cc, $49, $fe, $7f, $fe, $48, $cc
    db $68, $dc, $7c, $fe, $7f, $ee, $fe, $78, $b0, $58, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $18, $7f, $fe, $89, $7e, $6e, $18, $7f, $fe, $6e, $18
    db $18, $38, $fa, $7c, $6e, $de, $f5, $7a, $20, $70, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $78, $00, $70, $78, $10, $78, $34, $1e, $34, $1e, $14, $3e
    db $fc, $7e, $77, $de, $67, $f7, $c6, $6d, $08, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $28, $30, $24, $f8, $f4, $fe, $76, $26, $34, $62, $70, $e0
    db $f0, $a0, $b4, $e2, $64, $f6, $bc, $7c, $00, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $18, $68, $d8, $58, $fc, $fc, $7e, $f2, $7e, $5f, $f2
    db $f7, $f2, $b2, $f6, $e6, $f6, $7e, $ec, $0c, $48, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $10, $10, $fe, $7e, $fe, $18, $30, $11, $fe, $fe, $ff
    db $de, $30, $1a, $33, $12, $3f, $2d, $1e, $12, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $58, $c8, $59, $ce, $de, $7f, $ee, $7b, $db, $ee, $74, $ee
    db $3c, $6c, $24, $38, $18, $30, $10, $18, $08, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $18, $6c, $5e, $7f, $5e, $7f, $7b, $69, $7b, $ff, $6b
    db $fa, $7f, $fc, $5e, $0c, $58, $18, $18, $18, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $30, $1c, $3c, $10, $3c, $10, $30, $10, $30, $10, $30
    db $30, $78, $7e, $fc, $96, $fe, $60, $f6, $d0, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $30, $10, $38, $18, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $70, $50, $50, $20, $70, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $70, $78, $1c, $78, $14, $c8, $80, $c0, $bc, $f8, $c4, $fc
    db $8c, $c6, $04, $06, $06, $0c, $48, $7c, $30, $78, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $22, $66, $22, $66, $42, $66, $42, $66, $5a, $76, $5a, $76
    db $62, $76, $36, $66, $06, $06, $1e, $0c, $18, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7c, $7c, $7c, $18, $0c, $3c, $18, $3e, $7c, $fe, $e6
    db $02, $c6, $7a, $3e, $3c, $6e, $2c, $7c, $18, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $60, $6c, $6e, $7e, $fe, $f2, $f6, $b2, $66, $a2, $66
    db $e2, $66, $e4, $e6, $e4, $e6, $23, $66, $22, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0c, $7e, $7c, $7e, $0e, $0c, $14, $18, $3c, $3e, $e7, $7e
    db $62, $c3, $00, $03, $5a, $27, $7f, $3e, $18, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $60, $20, $72, $2c, $6c, $fe, $33, $fe, $26, $73, $72, $63
    db $e2, $63, $62, $e3, $3b, $e6, $6e, $3e, $70, $2c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $18, $92, $7c, $fe, $7c, $10, $38, $3b, $7f, $ec, $7f
    db $5a, $7c, $68, $3c, $58, $6c, $40, $7e, $7c, $3e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $20, $30, $60, $30, $30, $60, $20, $60, $70, $78, $f8, $78
    db $58, $e8, $68, $d8, $ca, $d8, $9e, $ce, $cc, $8e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $4c, $32, $7e, $7e
    db $32, $4c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $22, $00, $7e, $37, $7f, $7f, $7f, $7f, $7f, $7f, $3e, $7f, $3f, $3e
    db $1c, $3e, $3e, $1c, $08, $1c, $1c, $08, $00, $08, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $1e, $34, $1e, $36, $16, $7b, $fa, $7c, $54, $3e, $64, $36
    db $34, $66, $5e, $64, $46, $ec, $dc, $fc, $5c, $18, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $38, $16, $16, $7e, $7a, $7c, $16, $1e, $78, $7e, $08, $7c
    db $04, $0e, $42, $66, $40, $60, $22, $7c, $1e, $3c, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $04, $02, $06, $0e, $1e, $1c, $70, $38, $60, $e0, $c0, $c0
    db $f0, $e0, $78, $38, $0c, $1e, $06, $06, $02, $00, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $44, $cc, $c4, $cc, $fe, $fe, $84, $fe, $84, $cc, $84, $cc
    db $84, $cc, $c4, $cc, $cc, $cc, $48, $dc, $d8, $08, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $2e, $1c, $7e, $7e, $5a, $66, $06, $0c, $1c, $08, $20, $00
    db $60, $60, $40, $c0, $55, $e2, $fe, $7f, $10, $3c, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $00, $30, $16, $3e, $b8, $fe, $d0, $f8, $08, $18, $1c, $0c
    db $cc, $06, $81, $c0, $a0, $c0, $40, $fc, $bc, $7c, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $60, $c0, $60, $c0, $80, $c0, $80, $c0, $80, $c0, $80, $c0
    db $81, $c6, $85, $c6, $86, $cc, $48, $fc, $30, $78, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $08, $18, $08, $fe, $fe, $fe, $38, $18, $38, $78, $cc, $78
    db $ec, $58, $3c, $78, $48, $38, $08, $18, $18, $10, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $4e, $64, $4e, $64, $ff, $fe, $c5, $fe, $e4, $46, $e6, $44
    db $f6, $4c, $ec, $5c, $40, $66, $3e, $7e, $38, $3c, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $52, $66, $2e, $76, $38, $1c, $31, $7e, $7f, $fe, $5c, $38
    db $20, $70, $60, $60, $50, $60, $26, $7e, $1c, $3e, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $20, $30, $21, $fe, $ff, $fe, $32, $6c, $3e, $7e, $7a, $66
    db $74, $6c, $48, $60, $c0, $70, $d0, $7e, $ce, $5e, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $60, $20, $21, $fe, $ff, $fe, $40, $60, $7c, $f8, $46, $fc
    db $8c, $c6, $04, $06, $64, $0c, $48, $7c, $30, $78, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $44, $38, $3e, $fc, $de, $e6, $02, $06, $02, $06, $02, $06
    db $06, $06, $06, $0c, $28, $1c, $30, $38, $08, $30, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $00, $ff, $fe, $ff, $ee, $1c, $10, $38, $20, $30, $70, $20
    db $20, $60, $30, $60, $7e, $30, $1e, $3e, $10, $0e, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $10, $18, $10, $18, $16, $18, $1e, $1e, $30, $3e, $40, $70
    db $c0, $60, $40, $c0, $60, $c0, $c0, $7e, $7e, $3e, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $c4, $4c, $46, $cc, $7e, $ff, $47, $fe, $44, $cc, $44, $cc
    db $64, $dc, $7d, $fe, $7e, $ef, $7f, $fc, $d8, $7c, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $62, $34, $f4, $f6, $27, $f6, $27, $67, $45, $66, $e4, $46
    db $e4, $46, $ec, $46, $44, $6c, $38, $7c, $10, $38, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $28, $70, $70, $78, $58, $18, $cc, $76, $74, $de, $5b, $de
    db $cb, $de, $cb, $de, $9f, $da, $f7, $fa, $ba, $70, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $10, $20, $70, $70, $d0, $78, $a8, $d8, $58, $8c, $04, $0c
    db $06, $0c, $02, $06, $06, $02, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00
    db $0f, $05, $0f, $05, $c0, $7e, $7e, $fe, $78, $cc, $49, $fe, $7f, $fe, $48, $cc
    db $68, $dc, $7c, $fe, $7f, $ee, $fe, $78, $b0, $58, $00, $00, $00, $00, $00, $00
    db $02, $07, $05, $05, $c2, $4f, $46, $cc, $7e, $ff, $47, $fe, $44, $cc, $44, $cc
    db $64, $dc, $7d, $fe, $7e, $ef, $7f, $fc, $d8, $7c, $00, $00, $00, $00, $00, $00
    db $02, $07, $05, $05, $62, $37, $f4, $f6, $27, $f6, $27, $67, $45, $66, $e4, $46
    db $e4, $46, $ec, $46, $44, $6c, $38, $7c, $10, $38, $00, $00, $00, $00, $00, $00
    db $02, $07, $05, $05, $2a, $77, $70, $78, $58, $18, $cc, $76, $74, $de, $5b, $de
    db $cb, $de, $cb, $de, $9f, $da, $f7, $fa, $ba, $70, $00, $00, $00, $00, $00, $00
    db $02, $07, $05, $05, $12, $27, $70, $70, $d0, $78, $a8, $d8, $58, $8c, $04, $0c
    db $06, $0c, $02, $06, $06, $02, $02, $02, $00, $00, $00, $00, $00, $00, $00, $00
    db $02, $07, $05, $05, $c2, $7f, $7e, $fe, $78, $cc, $49, $fe, $7f, $fe, $48, $cc
    db $68, $dc, $7c, $fe, $7f, $ee, $fe, $78, $b0, $58, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $fa, $7c
    db $74, $0e, $0e, $06, $0e, $06, $24, $1e, $1e, $1c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $30, $2e, $34
    db $fc, $7e, $6a, $36, $26, $32, $24, $36, $16, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $0c, $a8, $cc
    db $bc, $fe, $ca, $fe, $8e, $da, $0c, $1c, $30, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $18, $1e, $1e
    db $10, $1e, $70, $18, $7c, $fe, $b2, $de, $68, $f0, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $38
    db $38, $38, $10, $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $60, $f8, $f8
    db $24, $6c, $fe, $7c, $be, $ee, $d2, $be, $7e, $ea, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8e, $c4
    db $82, $c6, $82, $c6, $82, $c6, $50, $f0, $20, $70, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $30, $08, $38
    db $fa, $7c, $04, $7e, $0e, $06, $14, $0e, $0e, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $10, $70
    db $fc, $fc, $e8, $1c, $10, $38, $30, $fe, $ce, $de, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $60, $f0, $f8
    db $3a, $66, $fa, $7c, $a2, $fe, $e2, $a6, $66, $ec, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $28, $10, $10, $38, $38, $38, $7c, $38, $28, $7c
    db $38, $6c, $c6, $6c, $fe, $7c, $44, $fe, $c6, $c6, $82, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $78, $f8, $44, $fc, $74, $cc, $44, $cc, $78, $fc
    db $44, $fc, $46, $cc, $46, $cc, $4e, $fc, $78, $fc, $44, $f8, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1c, $38, $3c, $7c, $e4, $7e, $42, $e6, $e0, $c6
    db $80, $c0, $80, $c0, $66, $c2, $d2, $66, $24, $7e, $18, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $70, $f8, $78, $fc, $7e, $cc, $4c, $c6, $46, $c6
    db $42, $c6, $42, $c6, $4e, $c6, $74, $ce, $78, $fc, $70, $f8, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $fe, $7e, $fe, $40, $c0, $40, $c0, $40, $fc
    db $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $7e, $fe, $00, $fe, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $80, $7e, $fe, $7e, $fe, $40, $e0, $40, $fe, $40
    db $fc, $7e, $c0, $7e, $e0, $40, $e0, $40, $e0, $40, $e0, $40, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $38, $38, $7c, $54, $ee, $ac, $c6, $80, $c0
    db $9c, $de, $84, $de, $8c, $c6, $ac, $c6, $46, $fc, $38, $7c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $44, $c6, $44, $c6, $44, $c6, $44, $c6, $44, $fe
    db $7c, $fe, $44, $c6, $44, $c6, $44, $c6, $44, $c6, $40, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $3c, $3c, $10, $3c, $10, $18, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $3c, $3c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $04, $0c, $04, $0c, $04, $0c, $04, $0c, $04, $0c
    db $04, $0c, $04, $0c, $84, $cc, $84, $cc, $48, $fc, $30, $78, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $44, $c2, $4e, $c6, $5e, $cc, $6c, $d8, $58, $f0
    db $70, $f8, $5c, $f8, $4c, $dc, $44, $ce, $42, $c6, $42, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $40, $c0, $40, $c0, $40, $c0, $40, $c0, $40, $c0
    db $40, $c0, $40, $c0, $40, $c0, $7c, $c0, $7c, $fc, $00, $fc, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $42, $c6, $6a, $c6, $46, $ee, $6e, $ee, $7e, $fe
    db $7e, $fe, $7a, $fe, $52, $fe, $7a, $d6, $52, $d6, $42, $d6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $42, $c6, $42, $c6, $42, $e6, $62, $f6, $72, $fe
    db $5a, $de, $4e, $ce, $46, $c6, $42, $c6, $42, $c6, $42, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $7c, $44, $fe, $82, $c6, $82, $c6, $82, $c6
    db $82, $c6, $82, $c6, $82, $c6, $82, $c6, $44, $fe, $38, $7c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $02, $fc, $7c, $fe, $42, $fe, $42, $c6, $42, $c6
    db $7c, $fe, $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $40, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $38, $78, $7c, $4c, $fc, $a6, $cc, $8c, $c6
    db $8c, $c6, $84, $ce, $bc, $de, $ce, $fc, $7c, $fe, $36, $7e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $78, $fc, $44, $fe, $4a, $c6, $42, $c6, $4a, $c6
    db $7c, $fe, $58, $fc, $44, $ce, $44, $c6, $44, $c6, $44, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $7c, $7c, $fe, $cc, $c6, $c0, $c0, $74, $f8
    db $3e, $7c, $0e, $0e, $06, $c6, $c6, $fe, $fe, $fc, $bc, $78, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $fe, $fc, $fe, $de, $30, $18, $30, $18, $30
    db $18, $30, $18, $30, $18, $30, $18, $30, $18, $30, $18, $30, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $42, $c6, $42, $c6, $42, $c6, $42, $c6, $42, $c6
    db $42, $c6, $42, $c6, $42, $c6, $44, $fe, $fc, $7c, $7c, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $aa, $c6, $ee, $c6, $44, $ee, $c6, $6c, $6c, $6c
    db $28, $7c, $38, $7c, $78, $38, $10, $38, $38, $10, $20, $10, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $11, $c6, $df, $d6, $ff, $d6, $d7, $fe, $7e, $fe
    db $7c, $fe, $fe, $7c, $6e, $7c, $7c, $6c, $28, $6c, $00, $6c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $a2, $c6, $ce, $e6, $fe, $6c, $28, $7c, $7c, $38
    db $7c, $38, $28, $7c, $fc, $6c, $44, $ee, $8e, $c6, $82, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $82, $c6, $c6, $c6, $54, $ee, $78, $7c, $74, $38
    db $18, $30, $18, $30, $18, $30, $18, $30, $18, $30, $18, $30, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $fc, $fc, $04, $fc, $18, $0c, $0c, $18, $10, $38
    db $20, $30, $30, $60, $c0, $60, $e0, $c0, $80, $fe, $fe, $fe, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $7c, $00, $7c, $7c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $c0, $e0, $c0, $60, $40, $40, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $60, $60, $20, $20, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $60, $60, $00, $00, $00, $00
    db $08, $08, $10, $10, $00, $00, $28, $10, $10, $38, $38, $38, $7c, $38, $28, $7c
    db $38, $6c, $c6, $6c, $fe, $7c, $44, $fe, $c6, $c6, $82, $c6, $00, $00, $00, $00
    db $10, $38, $6c, $44, $00, $00, $28, $10, $10, $38, $38, $38, $7c, $38, $28, $7c
    db $38, $6c, $c6, $6c, $fe, $7c, $44, $fe, $c6, $c6, $82, $c6, $00, $00, $00, $00
    db $20, $20, $10, $10, $00, $00, $28, $10, $10, $38, $38, $38, $7c, $38, $28, $7c
    db $38, $6c, $c6, $6c, $fe, $7c, $44, $fe, $c6, $c6, $82, $c6, $00, $00, $00, $00
    db $00, $00, $28, $28, $00, $00, $28, $10, $10, $38, $38, $38, $7c, $38, $28, $7c
    db $38, $6c, $c6, $6c, $fe, $7c, $44, $fe, $c6, $c6, $82, $c6, $00, $00, $00, $00
    db $08, $08, $10, $10, $00, $00, $00, $fe, $7e, $fe, $40, $c0, $40, $c0, $40, $fc
    db $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $7e, $fe, $00, $fe, $00, $00, $00, $00
    db $10, $38, $6c, $44, $00, $00, $00, $fe, $7e, $fe, $40, $c0, $40, $c0, $40, $fc
    db $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $7e, $fe, $00, $fe, $00, $00, $00, $00
    db $20, $20, $10, $10, $00, $00, $00, $fe, $7e, $fe, $40, $c0, $40, $c0, $40, $fc
    db $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $7e, $fe, $00, $fe, $00, $00, $00, $00
    db $00, $00, $28, $28, $00, $00, $00, $fe, $7e, $fe, $40, $c0, $40, $c0, $40, $fc
    db $7c, $fc, $40, $c0, $40, $c0, $40, $c0, $7e, $fe, $00, $fe, $00, $00, $00, $00
    db $08, $08, $10, $10, $00, $00, $3c, $3c, $10, $3c, $10, $18, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $3c, $3c, $3c, $00, $00, $00, $00
    db $00, $00, $24, $24, $00, $00, $3c, $3c, $10, $3c, $10, $18, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $3c, $3c, $3c, $00, $00, $00, $00
    db $08, $08, $10, $10, $00, $00, $38, $7c, $44, $fe, $42, $c6, $42, $c6, $42, $c6
    db $42, $c6, $42, $c6, $42, $c6, $42, $c6, $44, $fe, $38, $7c, $00, $00, $00, $00
    db $00, $00, $28, $28, $00, $00, $38, $7c, $44, $fe, $42, $c6, $42, $c6, $42, $c6
    db $42, $c6, $42, $c6, $42, $c6, $42, $c6, $44, $fe, $38, $7c, $00, $00, $00, $00
    db $08, $08, $10, $10, $00, $00, $42, $c6, $42, $c6, $42, $c6, $42, $c6, $42, $c6
    db $42, $c6, $42, $c6, $42, $c6, $44, $fe, $fc, $7c, $7c, $38, $00, $00, $00, $00
    db $00, $00, $28, $28, $00, $00, $42, $c6, $42, $c6, $42, $c6, $42, $c6, $42, $c6
    db $42, $c6, $42, $c6, $42, $c6, $44, $fe, $fc, $7c, $7c, $38, $00, $00, $00, $00
    db $7a, $32, $5e, $4c, $00, $00, $42, $c6, $42, $c6, $42, $e6, $62, $f6, $72, $fe
    db $5a, $de, $4e, $ce, $46, $c6, $42, $c6, $42, $c6, $42, $c6, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $7c, $00, $7c, $7c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $30, $70, $68, $d8, $48, $d8
    db $50, $f0, $20, $70, $56, $da, $44, $ce, $4e, $fc, $36, $72, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $30, $38, $30, $38, $30, $38, $30, $38, $30, $38
    db $18, $30, $18, $30, $00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $1c, $3e, $7c, $44, $7e, $4c, $66, $66, $0c
    db $18, $1c, $14, $18, $10, $18, $18, $00, $18, $18, $18, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $38, $3c, $04, $3c
    db $26, $1c, $7e, $3c, $4e, $64, $5e, $64, $44, $7c, $7c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $20, $30, $20, $30, $20, $22, $3c, $3c, $3e
    db $37, $22, $27, $22, $67, $22, $7a, $26, $66, $3c, $3c, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $24, $66, $20, $60, $20, $60, $20, $66, $66, $3c, $18, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $02, $06, $02, $06, $0a, $06, $2e, $1e, $72, $3e
    db $22, $66, $22, $66, $22, $66, $6a, $36, $12, $3e, $1e, $0e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $3c, $66, $3c, $7e, $20, $60, $7c, $26, $18, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $0e, $0e, $1e, $10, $18, $10, $7e, $7e, $7e
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $08, $10, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1e, $00, $1e, $3e, $22, $7e
    db $42, $66, $42, $66, $62, $3e, $1e, $3e, $0a, $06, $1c, $3e, $02, $3c, $00, $00
    db $00, $00, $00, $00, $00, $00, $60, $00, $40, $60, $50, $60, $5c, $7c, $64, $7e
    db $42, $66, $42, $66, $42, $66, $42, $66, $42, $66, $42, $66, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $18, $10, $18, $00, $00, $10, $38, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $08, $0c, $08, $0c, $00, $00, $08, $0c, $08, $0c
    db $08, $0c, $08, $0c, $08, $0c, $28, $6c, $28, $6c, $18, $7c, $00, $38, $00, $00
    db $00, $00, $00, $00, $00, $00, $20, $60, $20, $60, $20, $66, $24, $66, $26, $6c
    db $28, $7c, $34, $78, $28, $7c, $2c, $66, $22, $66, $26, $62, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $18, $08, $18, $08, $18, $08, $18, $08, $18
    db $08, $18, $08, $18, $08, $18, $08, $18, $08, $18, $08, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $6c, $00, $ac, $fe, $d3, $fe
    db $9b, $d2, $9b, $d2, $9b, $d2, $9b, $d2, $9b, $d2, $9b, $d2, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $2c, $7c, $34, $7e
    db $22, $66, $22, $66, $22, $66, $22, $66, $22, $66, $22, $66, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $1e, $3c, $22, $7e
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $5a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $70, $78, $48, $7c
    db $46, $6c, $4e, $64, $4e, $64, $48, $7c, $70, $78, $50, $60, $40, $60, $40, $60
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $3e, $64, $3e
    db $44, $66, $44, $66, $64, $66, $6c, $3e, $1c, $3e, $0c, $06, $04, $06, $04, $06
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $20, $66, $24, $6e
    db $28, $7c, $30, $78, $20, $70, $20, $60, $20, $60, $20, $60, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $3c, $42, $7e
    db $58, $60, $7e, $3c, $1c, $06, $22, $46, $44, $7e, $38, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $18, $10, $18, $10, $18, $7e, $7e, $76, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $1e, $1e, $0e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $42, $66, $42, $66
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $1a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $66, $44, $66
    db $3e, $64, $68, $3c, $08, $3c, $30, $18, $30, $18, $08, $10, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9a, $c3, $96, $db
    db $b3, $de, $d2, $7e, $ec, $7e, $7e, $6c, $44, $6c, $00, $6c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $42, $66, $3c, $66
    db $3c, $3c, $1c, $38, $7c, $3c, $3c, $66, $42, $66, $42, $66, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $43, $66, $35, $66
    db $56, $3c, $28, $1c, $0c, $18, $30, $18, $18, $30, $20, $30, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $7e, $44, $3e
    db $08, $0c, $10, $18, $10, $30, $6e, $30, $3e, $7e, $00, $7e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $30, $30, $30, $30, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f4, $64, $bc, $98, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $08, $08, $38, $7c, $44, $44, $44, $44, $7c, $7c
    db $7c, $54, $7c, $7c, $7c, $54, $7c, $7c, $7c, $54, $38, $7c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $10, $10, $00, $00, $18, $00, $38, $3c, $04, $3c
    db $26, $1c, $7e, $3c, $4e, $64, $5e, $64, $44, $7c, $7c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $18, $24, $24, $00, $00, $18, $00, $38, $3c, $04, $3c
    db $26, $1c, $7e, $3c, $4e, $64, $5e, $64, $44, $7c, $7c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $10, $08, $08, $00, $00, $18, $00, $38, $3c, $04, $3c
    db $26, $1c, $7e, $3c, $4e, $64, $5e, $64, $44, $7c, $7c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $24, $00, $00, $18, $00, $38, $3c, $04, $3c
    db $26, $1c, $7e, $3c, $4e, $64, $5e, $64, $44, $7c, $7c, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $10, $10, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $3c, $66, $3c, $7e, $20, $60, $7c, $26, $18, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $18, $24, $24, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $3c, $66, $3c, $7e, $20, $60, $7c, $26, $18, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $10, $08, $08, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $3c, $66, $3c, $7e, $20, $60, $7c, $26, $18, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $24, $00, $00, $18, $00, $18, $3c, $66, $3c
    db $3c, $66, $3c, $7e, $20, $60, $7c, $26, $18, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $10, $10, $00, $00, $00, $00, $10, $38, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $24, $00, $00, $00, $00, $10, $38, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $10, $10, $00, $00, $18, $00, $1e, $3c, $22, $7e
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $5a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $24, $00, $00, $18, $00, $1e, $3c, $22, $7e
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $5a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $08, $10, $10, $00, $00, $00, $00, $42, $66, $42, $66
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $1a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $24, $00, $00, $00, $00, $42, $66, $42, $66
    db $42, $66, $42, $66, $42, $66, $42, $66, $24, $7e, $1a, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $30, $1a, $2e, $24, $00, $00, $2c, $7c, $34, $7e
    db $22, $66, $22, $66, $22, $66, $22, $66, $22, $66, $22, $66, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1e, $3c, $6a, $36
    db $40, $60, $40, $60, $6a, $36, $1c, $3c, $0c, $18, $04, $0c, $18, $3c, $24, $18
    db $00, $00, $00, $00, $00, $00, $f8, $78, $44, $fc, $74, $cc, $44, $cc, $58, $dc
    db $44, $dc, $46, $cc, $46, $cc, $46, $cc, $ae, $dc, $d8, $9c, $1c, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $ee, $44, $ee, $aa, $aa, $aa
    db $00, $00, $7c, $7c, $7c, $44, $7c, $44, $38, $6c, $10, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $6c, $28, $ee, $c6, $00, $00, $44, $44
    db $44, $44, $00, $00, $00, $00, $7c, $38, $44, $44, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $6c, $28, $ee, $c6, $00, $00, $44, $ee
    db $aa, $aa, $00, $00, $38, $38, $38, $28, $38, $28, $38, $10, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $18, $1a, $3c, $24, $7e, $42, $66, $42, $66
    db $42, $66, $42, $66, $42, $66, $24, $7e, $1a, $3c, $24, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $10, $18, $10, $38, $30, $38, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $10, $18, $00, $18, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $18, $3c, $3e, $7c, $44, $7e, $4c, $66, $24, $0e
    db $1c, $0c, $3c, $18, $78, $30, $3c, $60, $40, $7e, $7e, $7e, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $3c, $46, $7c, $5c, $66, $4c, $66, $06, $1c
    db $1e, $1c, $04, $6e, $54, $6e, $44, $7e, $3a, $7c, $54, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $0c, $0c, $0c, $0c, $1c, $34, $1c, $54, $3c
    db $34, $6c, $64, $6c, $44, $7e, $7e, $7e, $04, $0c, $04, $0c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $7c, $7c, $40, $7c, $40, $60, $48, $70, $7c, $78
    db $14, $6c, $04, $0c, $04, $0c, $54, $6c, $48, $7c, $70, $38, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $3c, $24, $7e, $44, $66, $40, $60, $40, $60
    db $7a, $7c, $64, $7e, $54, $66, $5c, $66, $24, $7e, $58, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $7e, $7e, $04, $7e, $06, $0c, $08, $0c, $18, $0c
    db $0c, $18, $10, $18, $30, $18, $18, $30, $10, $30, $10, $30, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $18, $3c, $24, $7e, $24, $66, $3c, $66, $5a, $3c
    db $3c, $7e, $66, $7e, $42, $66, $66, $66, $3c, $7e, $00, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $7a, $3c, $44, $7e, $5c, $66, $4c, $66, $24, $7e
    db $5c, $3e, $04, $06, $0c, $06, $0c, $66, $44, $7e, $78, $3c, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $0e, $04, $0c, $0c, $1c, $08
    db $18, $18, $38, $10, $30, $30, $70, $20, $60, $60, $60, $40, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18
    db $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $f4, $64, $bc, $98, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $7e, $6c, $26, $6c, $24, $24, $6c, $48, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $38, $7c, $28, $c6, $d6, $ba, $ba, $aa, $aa, $aa
    db $aa, $aa, $be, $aa, $de, $bc, $20, $c0, $3c, $78, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $38, $3c, $04, $3c, $26, $1c
    db $7e, $3c, $4e, $64, $56, $6c, $3c, $7c, $48, $34, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $20, $30, $20, $30, $20, $22, $3c, $3c, $3e, $37, $22
    db $27, $22, $67, $22, $7e, $26, $7e, $3c, $04, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $18, $3c, $66, $3c, $22, $64
    db $20, $60, $20, $60, $22, $64, $66, $3c, $18, $3c, $18, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $02, $06, $02, $06, $0a, $06, $3e, $1e, $32, $3e, $72, $26
    db $72, $26, $72, $26, $2a, $36, $1e, $3e, $10, $0e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $18, $00, $18, $3c, $66, $3c, $3e, $64
    db $3c, $7c, $24, $60, $7e, $24, $18, $3c, $24, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $0c, $0c, $1c, $14, $18, $10, $3c, $3c, $3c, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $00, $1c, $3c, $24, $7c, $44, $6c
    db $44, $6c, $64, $3c, $1c, $3c, $34, $0c, $18, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $40, $20, $20, $60, $30, $60, $38, $78, $28, $7c, $00, $6c
    db $00, $6c, $40, $6c, $44, $6c, $44, $6c, $6c, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $18, $10, $18, $00, $00, $10, $18, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $08, $0c, $08, $0c, $00, $00, $08, $0c, $08, $0c, $08, $0c
    db $08, $0c, $08, $0c, $28, $6c, $28, $6c, $18, $7c, $00, $38, $00, $00, $00, $00
    db $00, $00, $20, $30, $20, $30, $20, $30, $24, $36, $26, $3c, $28, $3c, $34, $38
    db $38, $3c, $2c, $36, $32, $26, $36, $22, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $18, $08, $18, $08, $18, $08, $18, $08, $18, $08, $18, $08, $18
    db $08, $18, $08, $18, $08, $18, $08, $18, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $24, $00, $ac, $fe, $d3, $fe, $9b, $d2, $9b, $d2
    db $9b, $d2, $9b, $d2, $9b, $d2, $99, $d2, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $2c, $7c, $34, $7e, $22, $66, $22, $66
    db $22, $66, $22, $66, $22, $66, $22, $66, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $18, $00, $1c, $38, $64, $3c, $4c, $64, $4e, $64
    db $4e, $64, $34, $6c, $78, $3c, $28, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $70, $78, $48, $7c, $46, $6c, $4e, $64
    db $4e, $64, $48, $7c, $70, $78, $40, $60, $40, $60, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $1e, $00, $1c, $3e, $64, $3e, $24, $66, $04, $66
    db $24, $66, $6c, $3e, $1c, $3e, $0c, $06, $04, $06, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $36, $14, $3e, $18, $3c, $10, $38
    db $10, $30, $10, $30, $10, $30, $10, $30, $10, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3c, $1c, $22, $3e, $28, $30
    db $3e, $1c, $0c, $06, $1a, $26, $24, $3e, $18, $1c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $18, $10, $18, $10, $18, $3c, $3c, $34, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $1c, $1c, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $22, $36, $22, $36, $22, $36
    db $22, $36, $22, $36, $22, $3e, $1c, $3e, $12, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $66, $44, $66, $3e, $64
    db $68, $3c, $08, $3c, $30, $18, $30, $18, $08, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $9a, $c3, $96, $db, $b3, $de
    db $d4, $7e, $ee, $7c, $7c, $6c, $40, $6c, $6c, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $44, $6c, $28, $7c, $38, $38
    db $18, $30, $78, $38, $78, $6c, $e4, $4c, $cc, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $43, $66, $35, $66, $56, $3c
    db $28, $1c, $0c, $18, $30, $18, $18, $30, $20, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7e, $3c, $0e, $3c, $08, $0c
    db $10, $18, $10, $30, $6c, $30, $3e, $7c, $02, $7c, $00, $00, $00, $00, $00, $00
    db $00, $00, $08, $08, $08, $08, $38, $7c, $44, $44, $44, $44, $7c, $7c, $7c, $54
    db $7c, $7c, $7c, $54, $7c, $7c, $7c, $54, $38, $7c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $6c, $28, $ee, $c6, $00, $00, $44, $ee, $aa, $aa, $00, $00
    db $38, $38, $38, $28, $38, $28, $38, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $ee, $44, $ee, $aa, $aa, $aa, $00, $00, $7c, $7c
    db $7c, $44, $7c, $44, $38, $6c, $10, $38, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $00
    db $7c, $7c, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $24, $18, $1a, $3c, $24, $7e, $42, $66, $42, $66, $42, $66
    db $42, $66, $42, $66, $24, $7e, $1a, $3c, $24, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $10, $18, $10, $38, $30, $38, $10, $18, $10, $18, $10, $18
    db $10, $18, $10, $18, $10, $18, $10, $18, $00, $18, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $3c, $3e, $7c, $44, $7e, $4c, $66, $24, $0e, $1c, $0c
    db $3c, $18, $78, $30, $3c, $60, $40, $7e, $7e, $7e, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $3c, $46, $7c, $5c, $66, $4c, $66, $06, $1c, $1e, $1c
    db $04, $6e, $54, $6e, $44, $7e, $3a, $7c, $54, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $0c, $0c, $0c, $0c, $1c, $34, $1c, $54, $3c, $34, $6c
    db $64, $6c, $44, $7e, $7e, $7e, $04, $0c, $04, $0c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $7c, $7c, $40, $7c, $40, $60, $48, $70, $7c, $78, $14, $6c
    db $04, $0c, $04, $0c, $54, $6c, $48, $7c, $70, $38, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $3c, $24, $7e, $44, $66, $40, $60, $40, $60, $7a, $7c
    db $64, $7e, $54, $66, $5c, $66, $24, $7e, $58, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $7e, $7e, $04, $7e, $06, $0c, $08, $0c, $18, $0c, $0c, $18
    db $10, $18, $30, $18, $18, $30, $10, $30, $10, $30, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $3c, $24, $7e, $24, $66, $3c, $66, $5a, $3c, $3c, $7e
    db $66, $7e, $42, $66, $66, $66, $3c, $7e, $00, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $7a, $3c, $44, $7e, $5c, $66, $4c, $66, $24, $7e, $5c, $3e
    db $04, $06, $0c, $06, $0c, $66, $44, $7e, $78, $3c, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $06, $06, $0e, $04, $0c, $0c, $1c, $08, $18, $18
    db $38, $10, $30, $30, $70, $20, $60, $60, $60, $40, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $00, $00
    db $00, $00, $00, $00, $18, $18, $18, $18, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $f4, $64, $bc, $98, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $7e, $6c, $26, $6c, $24, $24, $6c, $48, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $7c, $28, $c6, $d6, $ba, $ba, $aa, $aa, $aa, $aa, $aa
    db $14, $aa, $42, $bc, $20, $c0, $04, $78, $00, $00, $00, $00, $00, $00, $00, $00

    db $00, $00, $00

    ; padding
    ds $15d, $00

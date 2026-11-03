; Game Boy Camera Gold (USA), bank $2A. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: the small kana ぇ ぉ (end), A-Z, _ ' , .,
; the accented capitals Á Â À Ä É Ê È Ë Í Ï Ó Ö Ú Ü Ñ, -, & ! ?, a blank ...
Gfx_2A_4A6A_FontLatinCapitals::
    INCBIN "data/bank_2a/Gfx_2A_4A6A_FontLatinCapitals.bin" ; $4A6A, 1782 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: e (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_5160_Glyph_e::
    INCBIN "data/bank_2a/Font_2A_5160_Glyph_e.2bpp" ; $5160, 32 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: f-m (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_5180_Glyphs_f_to_m::
    INCBIN "data/bank_2a/Font_2A_5180_Glyphs_f_to_m.2bpp" ; $5180, 256 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: n o (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_5280_Glyphs_n_o::
    INCBIN "data/bank_2a/Font_2A_5280_Glyphs_n_o.2bpp" ; $5280, 64 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: p-u (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_52C0_Glyphs_p_to_u::
    INCBIN "data/bank_2a/Font_2A_52C0_Glyphs_p_to_u.2bpp" ; $52C0, 192 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: v w (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_5380_Glyphs_v_w::
    INCBIN "data/bank_2a/Font_2A_5380_Glyphs_v_w.2bpp" ; $5380, 64 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: x (the Japanese name described the
; katakana slot); same bytes at the same address in the international ROM
Font_2A_53C0_Glyph_x::
    INCBIN "data/bank_2a/Font_2A_53C0_Glyph_x.2bpp" ; $53C0, 32 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: y (first 26 bytes) (the Japanese name
; described the katakana slot); same bytes at the same address in the ...
Font_2A_53E0_Glyph_y::
    INCBIN "data/bank_2a/Font_2A_53E0_Glyph_y.bin" ; $53E0, 26 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: the end of y and the first byte of z
; (the Japanese name described the katakana slot); same bytes at the same ...
Font_2A_53FA_Glyphs_y_z_Part::
    INCBIN "data/bank_2a/Font_2A_53FA_Glyphs_y_z_Part.bin" ; $53FA, 7 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: z and the start of a middle dot (the
; Japanese name described the katakana slot); same bytes at the same address in ...
Font_2A_5401_Glyphs_z_MidDot::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $7c, $7c, $04
    db $04, $08, $08, $10, $10, $20, $20, $7c, $7c

    ; padding
    ds $14, $00

    db $30
    db $30

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: middle dot, start of ~ (the Japanese
; name described the katakana slot); same bytes at the same address in the ...
Font_2A_5430_Glyphs_MidDot_Tilde::
    db $30, $30, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $14, $00

    db $4c
    db $4c
    db $32
    db $32

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: ~ and the start of a telephone icon (the
; Japanese name described the katakana slot); same bytes at the same ...
Font_2A_5452_Glyphs_Tilde_Phone::
    db $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $a, $00

    db $08
    db $08
    db $08
    db $08
    db $38
    db $7c
    db $44
    db $44
    db $44
    db $44
    db $7c
    db $7c

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: the telephone icon, start of a blank
; glyph (the Japanese name described the katakana slot); same bytes at the same ...
Font_2A_5470_Glyphs_Phone_Blank::
    db $7c, $54, $7c, $7c, $7c, $54, $7c, $7c, $7c, $54

    db $38
    db $7c

    ; padding
    ds $16, $00

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: a blank glyph, start of á (the Japanese
; name described the katakana slot); same bytes at the same address in the ...
Font_2A_5492_Glyphs_Blank_aAcute::
    db $00, $00

    ; padding
    ds $14, $00

    db $08
    db $08
    db $10
    db $10
    db $00
    db $00
    db $18
    db $18

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: á, start of â (the Japanese name
; described the katakana slot); same bytes at the same address in the international ...
Font_2A_54B0_Glyphs_aAcute_aCirc::
    INCBIN "data/bank_2a/Font_2A_54B0_Glyphs_aAcute_aCirc.2bpp" ; $54B0, 32 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: â, start of à (the Japanese name
; described the katakana slot); same bytes at the same address in the international ...
Font_2A_54D0_Glyphs_aCirc_aGrave::
    INCBIN "data/bank_2a/Font_2A_54D0_Glyphs_aCirc_aGrave.2bpp" ; $54D0, 32 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: à, start of ä (the Japanese name
; described the katakana slot); same bytes at the same address in the international ...
Font_2A_54F0_Glyphs_aGrave_aUmlaut::
    db $28, $28, $48, $48, $48, $48, $48, $48, $34, $34

    ; padding
    ds $10, $00

    db $28
    db $28
    db $00
    db $00
    db $18
    db $18
    db $28
    db $28

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: ä, start of é (the Japanese name
; described the katakana slot); same bytes at the same address in the international ...
Font_2A_5512_Glyphs_aUmlaut_eAcute::
    INCBIN "data/bank_2a/Font_2A_5512_Glyphs_aUmlaut_eAcute.bin" ; $5512, 24 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: é ê è ë í ï ó ö ú ü ñ ç ß, three small
; faces, 0-9 (the Japanese name described the katakana slot); same bytes at ...
Font_2A_552A_LowerAccentsFacesDigits::
    INCBIN "data/bank_2a/Font_2A_552A_LowerAccentsFacesDigits.bin" ; $552A, 817 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: end of 9, /, start of : (the Japanese
; name described the katakana slot); same bytes at the same address in the ...
Font_2A_585B_Glyphs_9_Slash_Colon::
    INCBIN "data/bank_2a/Font_2A_585B_Glyphs_9_Slash_Colon.bin" ; $585B, 31 bytes
; C: tiles: BGB, menu walk node U00 (tcrf_check/tools/guide_nodes.py, the international ROM, same bytes here): its
; first 16 bytes are in VRAM tile data; read by Kb_LoadGlyphList
Gfx_2A_587A_Kb_LoadGlyphList::
    INCBIN "data/bank_2a/Gfx_2A_587A_Kb_LoadGlyphList.bin" ; $587A, 30 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: end of :, a second ~, start of " (the
; Japanese name described the katakana slot); same bytes at the same address ...
Font_2A_5898_Glyphs_Colon_Tilde_Quote::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $64, $64, $98, $98
    db $00, $00, $00, $00, $00, $00

    ; padding
    ds $14, $00

; C: tiles: BGB, menu walk node U11 (tcrf_check/tools/guide_nodes.py, the international ROM, same bytes here): its
; first 16 bytes are in VRAM tile data; read by Kb_LoadGlyphList
Gfx_2A_58C2_Kb_LoadGlyphList::
    db $6c, $6c, $24, $24, $48, $48

    ; padding
    ds $e, $00

; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: ", start of @ (the Japanese name
; described the katakana slot); same bytes at the same address in the international ...
Font_2A_58D6_Glyphs_Quote_At::
    db $00, $00, $00, $00, $00, $00

    ; padding
    ds $8, $00

; C: tiles: BGB, menu walk node U11 (tcrf_check/tools/guide_nodes.py, the international ROM, same bytes here): its
; first 16 bytes are in VRAM tile data; read by Kb_LoadGlyphList
Gfx_2A_58E4_Kb_LoadGlyphList::
    INCBIN "data/bank_2a/Gfx_2A_58E4_Kb_LoadGlyphList.bin" ; $58E4, 18 bytes
; C: glyph font 2A:4000 (32 B = an 8 x 16 glyph); in this build the Japanese katakana area 2A:4A60-5909 holds the
; Latin set drawn on tcrf_check/assets/l3_by_eye/font_2A_4A60_jp_vs_intl.png: end of @ (the Japanese name described
; the katakana slot); same bytes at the same address in the international ROM
Font_2A_58F6_Glyph_At_Part::
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
    INCBIN "data/bank_2a/Gfx_2A_59FF_FontSlotsCFtoD3.bin" ; $59FF, 123 bytes
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
; C: font base handed to Glyph_LoadFromCharCode at 09:47C7 and 09:55A8 (owner card, keyboard); the Japanese name was
; the small-kana stamp set, but this build's stamp categories 4-5 start at 2A:6AA0 (Stamp_IconSrcGfxTbl); 85 of its
; 32-byte pieces are the Japanese ones at the same address
Font_2A_6000_GlyphBase::
    INCBIN "data/bank_2a/Font_2A_6000_GlyphBase.2bpp" ; $6000, 2720 bytes
; C: stamp category 4/5 (letters, set A): the stamp tiles, 32 bytes per stamp; block to 2A:8000, room for 171 stamps
; (an upper bound)
StampCat04_05_LettersA_Gfx::
    INCBIN "data/bank_2a/StampCat04_05_LettersA_Gfx.2bpp" ; $6AA0, 5472 bytes

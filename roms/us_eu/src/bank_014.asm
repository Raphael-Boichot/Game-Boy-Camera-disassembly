; Game Boy Camera (USA, Europe), bank $14. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $014", ROMX[$4000], BANK[$14]

; I: tile set (259 tiles, ids 0-258) of an unused alternate rendering of the link-exchange stand-by screen (mode 0E
; states 6/10): what looks like the same print (by eye) in a closer crop, the band 'アイデアがいっぱい', the large 任天堂 in the
; background instead of sprites. Its tile map is 23:5CC0 ...
Gfx_14_4000_Mode0E_ExchangeAlt_Tiles::
    INCBIN "data/bank_14/Gfx_14_4000_Mode0E_ExchangeAlt_Tiles.bin" ; $4000, 1364 bytes
; C: tiles 85 (from its 5th byte) to 258 of the same unreferenced screen (tile set 14:4000, map 23:5CC0). Only reader
; seen: the thumbnail reducer (nibble expander 00:289C) from the stray pointer 14:4554 (bytes 54 45 54 at 02:527B =
; AlbumB_SlotTbl[33], past its 30 entries; bank $54 = $14 on the 6-bit ...
Gfx_14_4554_Mode0E_ExchangeAlt_StrayPtr::
    db $f3, $00, $f1, $00, $f9, $00, $fc, $00, $fc, $00, $fc, $00, $7f, $00, $f3, $00
    db $f3, $00, $e3, $00, $e7, $00, $e7, $00, $e7, $00, $e7, $00, $fb, $00, $f9, $00
    db $fd, $00, $f3, $00, $31, $00, $18, $00, $9c, $00, $9c, $00, $ff, $00, $f9, $00
    db $f9, $00, $f9, $00, $c0, $00, $c0, $00, $f9, $00, $f9, $00, $01, $00, $01, $00
    db $01, $00, $f1, $00, $f1, $00, $43, $00, $43, $00, $4f, $00, $c0, $00, $c0, $00
    db $c0, $00, $ff, $00, $ff, $00, $fc, $00, $fc, $00, $fc, $00, $49, $00, $49, $00
    db $7f, $00, $ff, $00, $0f, $00, $0f, $00, $0f, $00, $ff, $00, $c0, $00, $c0, $00
    db $c0, $00, $ff, $00, $00, $00, $00, $00, $00, $00, $f1, $00, $7f, $00, $3f, $00
    db $1f, $00, $3f, $00, $7e, $00, $fe, $00, $fe, $00, $ff, $00, $ff, $00, $ff, $00
    db $fe, $00, $fc, $00, $fc, $00, $f8, $00, $f0, $00, $e1, $00, $0f, $00, $0f, $00
    db $0f, $00, $8f, $00, $8f, $00, $1f, $00, $1f, $00, $7f, $00, $00, $00, $00, $00
    db $00, $00, $ff, $00, $ff, $00, $e2, $00, $e2, $00, $e2, $00, $fe, $00, $fe, $00
    db $fe, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $0f, $ff, $0f
    db $ef, $1f, $df, $1f, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $af, $00, $fb, $00
    db $7f, $00, $fb, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $e7, $00, $78, $00
    db $af, $00, $f6, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $46, $64, $6e, $c4
    db $ce, $84, $16, $84, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $14, $02, $10, $06
    db $15, $06, $09, $07, $00, $ff, $ff, $00, $ff, $00, $7f, $00, $12, $00, $09, $00
    db $04, $00, $23, $00, $00, $ff, $ff, $00, $fe, $00, $fe, $00, $fd, $fc, $ff, $fc
    db $fd, $fc, $f9, $fc, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $8f, $0f, $4f, $1f
    db $3f, $1f, $9f, $1f, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $08, $00, $38, $10
    db $e0, $f0, $42, $e0, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $0e, $04, $82, $87
    db $e1, $c3, $20, $70, $00, $ff, $ff, $00, $c9, $00, $c9, $00, $06, $03, $03, $01
    db $04, $00, $00, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $00, $00, $20, $00
    db $20, $00, $a0, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $20, $30, $32, $30
    db $11, $30, $b8, $10, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $05, $c0, $c5, $40
    db $29, $40, $68, $40, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $42, $00, $08, $00
    db $2a, $00, $40, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $07, $f7, $07
    db $ff, $07, $ff, $07, $ff, $07, $f7, $0f, $f7, $0f, $ff, $0f, $ef, $00, $df, $00
    db $fe, $00, $5f, $00, $bb, $00, $ef, $00, $ab, $00, $ea, $00, $ff, $00, $de, $00
    db $66, $00, $db, $00, $fd, $00, $ae, $00, $f5, $00, $b6, $00, $de, $02, $be, $02
    db $70, $06, $b8, $06, $48, $16, $bd, $16, $74, $36, $36, $24, $4b, $00, $b3, $00
    db $57, $00, $6b, $00, $35, $02, $51, $02, $4d, $02, $40, $02, $11, $00, $de, $00
    db $c1, $00, $96, $00, $09, $00, $53, $00, $10, $00, $c5, $00, $85, $00, $19, $00
    db $e4, $00, $34, $00, $75, $f0, $f1, $f8, $b9, $f8, $f8, $fc, $2a, $00, $10, $00
    db $83, $00, $00, $00, $25, $00, $91, $01, $03, $07, $07, $0f, $73, $3e, $41, $23
    db $09, $01, $81, $01, $0d, $04, $0c, $0c, $08, $0c, $18, $08, $91, $80, $d4, $80
    db $c4, $40, $68, $60, $70, $20, $10, $30, $18, $18, $1c, $08, $08, $01, $08, $00
    db $c0, $80, $60, $c0, $20, $60, $30, $30, $0c, $18, $04, $0c, $8e, $0f, $0f, $03
    db $03, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $24, $00, $10, $00
    db $08, $00, $49, $00, $80, $00, $40, $00, $10, $00, $00, $00, $ea, $40, $c4, $60
    db $46, $60, $68, $60, $26, $60, $21, $60, $79, $20, $a2, $30, $80, $00, $12, $00
    db $11, $00, $22, $00, $4c, $00, $03, $00, $48, $00, $40, $80, $08, $00, $14, $00
    db $22, $00, $08, $00, $48, $00, $09, $00, $04, $00, $00, $00, $ff, $f7, $6f, $f7
    db $ff, $37, $e7, $77, $2f, $77, $ff, $07, $ff, $07, $7b, $07, $be, $83, $8b, $d3
    db $df, $c0, $3f, $c0, $f7, $00, $fe, $00, $ff, $00, $fd, $00, $d3, $18, $3d, $10
    db $dd, $3b, $ff, $1f, $9e, $0c, $d5, $08, $f6, $00, $36, $00, $e5, $03, $9b, $03
    db $56, $03, $fa, $03, $52, $03, $ef, $02, $b3, $02, $bf, $02, $b4, $00, $b5, $00
    db $df, $00, $6f, $00, $d5, $00, $6e, $00, $a6, $00, $aa, $00, $09, $00, $46, $00
    db $09, $00, $0b, $00, $40, $00, $0d, $00, $82, $00, $24, $00, $00, $00, $00, $00
    db $11, $00, $80, $00, $21, $00, $49, $00, $20, $00, $82, $00, $02, $00, $20, $00
    db $4a, $00, $48, $00, $92, $00, $04, $00, $21, $00, $88, $00, $00, $00, $00, $00
    db $46, $00, $a0, $00, $01, $00, $04, $00, $00, $00, $8a, $1c, $90, $00, $40, $00
    db $c0, $00, $00, $00, $84, $00, $44, $00, $40, $00, $00, $00, $24, $30, $90, $18
    db $4d, $08, $85, $0c, $e6, $c4, $c6, $c2, $92, $c3, $23, $81, $00, $00, $00, $00
    db $80, $00, $14, $00, $22, $81, $e7, $c3, $77, $67, $bf, $1f, $98, $3c, $7d, $38
    db $7e, $34, $52, $27, $09, $03, $d1, $00, $08, $00, $50, $00, $84, $80, $9a, $80
    db $84, $80, $c1, $80, $52, $80, $82, $c0, $5c, $c0, $41, $c0, $08, $01, $45, $00
    db $24, $00, $02, $00, $48, $00, $04, $00, $42, $00, $a8, $00, $00, $00, $40, $00
    db $00, $00, $10, $00, $00, $00, $05, $00, $42, $00, $12, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $7f, $ff, $2f, $ff, $ef, $bf, $a7, $ff, $6f, $6f, $27, $37
    db $73, $1f, $5b, $9b, $a9, $8f, $f7, $8d, $fd, $86, $9a, $86, $ff, $e6, $e6, $f3
    db $db, $71, $d7, $79, $e9, $d9, $7c, $99, $15, $18, $55, $18, $73, $01, $9f, $01
    db $8f, $01, $d9, $01, $95, $01, $8e, $01, $33, $01, $40, $03, $5d, $00, $05, $00
    db $11, $00, $40, $00, $1d, $00, $ca, $00, $72, $00, $c5, $00, $46, $00, $81, $00
    db $68, $00, $00, $00, $4c, $00, $32, $00, $15, $00, $44, $00, $0a, $00, $29, $00
    db $80, $00, $05, $00, $01, $00, $01, $00, $00, $00, $01, $00, $16, $00, $01, $00
    db $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $08, $00, $00, $00
    db $20, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $1c, $1e, $1c, $1c
    db $18, $10, $12, $00, $00, $00, $00, $00, $08, $00, $01, $00, $20, $00, $80, $00
    db $00, $00, $00, $00, $21, $00, $80, $00, $80, $c0, $b0, $60, $09, $00, $04, $00
    db $40, $00, $90, $00, $c0, $80, $09, $80, $01, $00, $80, $00, $a2, $00, $10, $00
    db $30, $00, $09, $80, $d5, $83, $cf, $c7, $4e, $6f, $7e, $3c, $4e, $1e, $1e, $0f
    db $0f, $07, $13, $07, $23, $01, $91, $00, $16, $80, $a1, $80, $96, $00, $42, $01
    db $43, $01, $03, $01, $81, $01, $01, $01, $09, $01, $01, $01, $0c, $00, $51, $00
    db $20, $00, $04, $00, $24, $00, $02, $00, $41, $00, $04, $00, $5f, $bf, $ff, $3f
    db $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $00, $be, $01
    db $fb, $04, $fe, $01, $79, $87, $fb, $e7, $ff, $ff, $5f, $ff, $ef, $00, $be, $00
    db $7d, $80, $eb, $fc, $ff, $ff, $33, $77, $fb, $19, $de, $cc, $3d, $70, $9c, $1c
    db $d6, $0f, $31, $03, $fd, $00, $56, $00, $3d, $00, $f4, $01, $27, $00, $98, $00
    db $66, $00, $a5, $00, $97, $00, $60, $00, $4b, $00, $02, $00, $5f, $00, $53, $00
    db $4e, $00, $4d, $00, $9b, $00, $88, $00, $25, $00, $99, $00, $17, $00, $d1, $00
    db $4a, $00, $9a, $00, $bc, $00, $86, $00, $29, $00, $89, $00, $25, $00, $14, $00
    db $13, $00, $0a, $00, $00, $00, $80, $00, $02, $00, $0a, $00, $6b, $80, $85, $80
    db $a8, $80, $01, $80, $14, $80, $00, $00, $00, $00, $00, $00, $9b, $00, $f5, $00
    db $ad, $01, $09, $03, $57, $03, $07, $07, $86, $0f, $1e, $0e, $32, $70, $25, $70
    db $60, $20, $82, $00, $08, $00, $84, $00, $12, $00, $01, $00, $4a, $00, $2b, $00
    db $90, $00, $20, $00, $01, $00, $24, $00, $04, $00, $80, $00, $89, $00, $a5, $00
    db $14, $00, $60, $00, $09, $00, $64, $00, $50, $00, $90, $00, $f3, $f0, $fc, $f0
    db $fb, $f0, $7f, $f8, $78, $7c, $3d, $7c, $3e, $3c, $1c, $3e, $5c, $01, $25, $00
    db $d6, $00, $04, $02, $92, $00, $03, $00, $23, $00, $43, $00, $e6, $70, $c9, $c0
    db $7e, $80, $2a, $00, $e8, $00, $26, $00, $59, $00, $a4, $00, $fe, $01, $f1, $0f
    db $fd, $03, $ed, $13, $db, $27, $6f, $97, $d7, $2f, $ef, $1f, $ff, $fc, $ff, $fc
    db $ff, $f8, $ff, $f0, $f7, $f0, $ff, $f0, $ff, $f0, $ff, $e0, $b7, $0b, $f7, $0f
    db $77, $0d, $ef, $07, $ff, $07, $4f, $03, $89, $03, $7d, $00, $fc, $c0, $fe, $c0
    db $cb, $e0, $f6, $e0, $e3, $e0, $dd, $e0, $c6, $e0, $ff, $e0, $ff, $ff, $ff, $ff
    db $3f, $7f, $9f, $3f, $df, $0f, $2b, $07, $db, $01, $d0, $00, $53, $c7, $ca, $67
    db $27, $62, $bd, $02, $4c, $00, $bb, $00, $54, $00, $ad, $00, $4c, $a0, $b6, $00
    db $99, $00, $52, $00, $1b, $00, $84, $00, $02, $00, $a8, $00, $ce, $01, $7f, $00
    db $d0, $00, $e7, $00, $c8, $00, $7a, $00, $24, $00, $da, $00, $cc, $00, $32, $00
    db $d6, $00, $35, $00, $28, $00, $72, $00, $d1, $00, $00, $00, $7a, $80, $ff, $80
    db $6b, $80, $7d, $00, $fb, $00, $ed, $00, $b2, $00, $49, $00, $29, $00, $93, $07
    db $df, $07, $5e, $0f, $9c, $1e, $1d, $3c, $b9, $38, $3b, $30, $65, $00, $29, $00
    db $c0, $00, $9c, $00, $64, $00, $28, $00, $d3, $00, $30, $00, $a5, $00, $6d, $00
    db $9b, $00, $b6, $00, $ad, $00, $c9, $00, $35, $00, $68, $00, $fb, $fc, $fb, $fc
    db $fb, $fc, $fe, $f8, $f6, $f8, $ff, $f0, $ec, $f0, $f5, $f0, $7f, $07, $bf, $07
    db $5f, $03, $1b, $83, $ab, $03, $39, $03, $5b, $01, $4b, $01, $ff, $00, $f3, $00
    db $ee, $00, $f9, $00, $b3, $01, $ce, $07, $ce, $1c, $31, $38, $eb, $1c, $7f, $98
    db $f5, $7a, $ae, $71, $fd, $02, $fd, $02, $db, $24, $f7, $08, $d3, $cc, $7f, $dc
    db $a3, $5c, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $fa, $fd, $fe, $00, $b3, $00
    db $df, $00, $bb, $00, $ff, $00, $f7, $00, $9d, $00, $fe, $01, $fe, $00, $33, $00
    db $dc, $00, $d7, $00, $a9, $00, $ff, $00, $62, $80, $af, $80, $f7, $f8, $f5, $f8
    db $ff, $f8, $f8, $fd, $fd, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $bf, $7f, $ff, $3f
    db $3f, $ff, $9f, $ff, $ff, $df, $cf, $df, $ff, $cf, $ef, $c7, $b7, $e2, $ba, $b3
    db $d2, $9b, $b4, $c3, $c9, $c3, $ce, $e1, $ce, $e0, $6a, $e0, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ae, $1f, $61, $0f, $ff, $ff, $ff, $ff
    db $ff, $ff, $7f, $ff, $ff, $3f, $ef, $11, $fd, $00, $fa, $00, $ff, $ff, $ff, $ff
    db $df, $ff, $a1, $5e, $ff, $00, $ff, $00, $77, $00, $cf, $00, $bf, $7f, $8f, $3f
    db $fa, $07, $67, $00, $9b, $00, $6c, $00, $87, $00, $5e, $00, $fe, $01, $16, $00
    db $db, $00, $3c, $00, $d9, $00, $3b, $00, $dd, $00, $b5, $00, $ff, $ff, $fd, $fe
    db $fd, $f8, $db, $e0, $bd, $c0, $b6, $c0, $c9, $00, $ba, $00, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $fd, $ef, $17, $ef, $17
    db $f7, $0f, $f7, $0f, $f7, $0f, $f7, $0f, $f7, $0f, $bf, $07, $fa, $fd, $f7, $f8
    db $ff, $f0, $ff, $e0, $d7, $e8, $ff, $c0, $fe, $80, $7d, $80, $ee, $19, $ef, $18
    db $ed, $1a, $ef, $18, $fe, $09, $fb, $0c, $fb, $0c, $ea, $1d, $fb, $00, $df, $00
    db $7f, $00, $eb, $00, $eb, $00, $7d, $00, $7f, $c0, $9f, $c0, $ff, $00, $45, $10
    db $eb, $10, $dd, $00, $ff, $00, $f3, $00, $fb, $00, $2e, $00, $7f, $00, $f7, $00
    db $ee, $00, $ff, $00, $ef, $00, $b5, $00, $fe, $00, $eb, $00, $7f, $80, $ff, $80
    db $bf, $c0, $bf, $c0, $ff, $c0, $df, $e0, $ff, $e0, $e7, $f0, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $7f, $7f, $3f, $c7, $77, $e3
    db $f5, $1b, $ca, $1d, $e5, $0e, $7e, $86, $ff, $02, $9f, $62, $fa, $fd, $fb, $fc
    db $ff, $f8, $fe, $fd, $fc, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $e8, $f7, $d1, $ef
    db $a1, $df, $c9, $b7, $c3, $3f, $ab, $57, $5f, $a7, $ff, $07, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fd, $fe, $f9, $fc, $bf, $31, $de, $31
    db $df, $30, $9f, $30, $ff, $10, $f7, $18, $f7, $18, $d5, $1a, $fe, $01, $7f, $00
    db $df, $00, $ff, $00, $ab, $00, $ff, $00, $ff, $00, $7e, $00, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $fd, $00, $de, $00, $ff, $00, $db, $00, $df, $00, $df, $00
    db $df, $00, $af, $00, $ef, $00, $7f, $00, $de, $00, $bf, $00, $ff, $00, $de, $00
    db $fb, $00, $eb, $00, $ff, $00, $bf, $40, $ff, $00, $7b, $80, $ff, $f8, $f9, $fe
    db $fd, $fe, $fd, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $7f, $3f, $ff, $9f, $ff, $4f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $f9, $ff, $f0, $ed, $f3, $ff, $f0, $ff, $ff, $ff, $ff
    db $df, $ff, $9f, $ff, $bf, $7f, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $f8, $ff, $f6, $f9, $ff, $00, $ff, $00
    db $e6, $19, $cf, $18, $f7, $18, $bf, $10, $df, $30, $cf, $30, $bb, $00, $ed, $00
    db $ff, $00, $fe, $01, $ff, $00, $7f, $80, $fb, $00, $ff, $00, $ff, $00, $ff, $00
    db $83, $7c, $ff, $fe, $ff, $ff, $9f, $7f, $df, $00, $ff, $00, $fb, $00, $ff, $00
    db $ff, $00, $bd, $03, $ff, $03, $ff, $00, $ff, $00, $fb, $00, $f9, $00, $96, $00
    db $73, $00, $56, $00, $be, $00, $6f, $00, $fb, $00, $77, $00, $fd, $ff, $fe, $ff
    db $fc, $ff, $fb, $fc, $f8, $ff, $fa, $fd, $fd, $fe, $f1, $fe, $ff, $00, $ff, $00
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $7f, $80
    db $ef, $80, $bf, $c0, $ff, $00, $ff, $00, $fd, $00, $ff, $00, $af, $50, $fe, $ff
    db $ff, $ff, $8b, $ff, $b7, $00, $ff, $00, $ff, $00, $bf, $00, $ff, $00, $f7, $0f
    db $df, $3f, $3f, $1f, $ec, $00, $d7, $00, $0f, $00, $b5, $00, $cf, $f0, $8f, $f0
    db $bf, $c0, $bf, $c0, $be, $c0, $36, $c0, $f5, $80, $cc, $80, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $bf, $ff, $df, $ff, $df, $ff, $df, $ff, $ef, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3c, $3c, $3c, $24
    db $3c, $24, $7e, $7e, $7f, $43, $7f, $42, $7f, $72, $1f, $12, $ff, $ff, $ff, $80
    db $ff, $f8, $7f, $41, $ff, $e7, $ff, $00, $ff, $66, $ff, $00, $83, $83, $83, $82
    db $83, $82, $07, $04, $9f, $98, $df, $50, $df, $50, $df, $5c, $ff, $ff, $ff, $60
    db $ff, $60, $ff, $7f, $ff, $80, $ff, $80, $ff, $ff, $ff, $c0, $c0, $c0, $c0, $40
    db $c0, $40, $f7, $f7, $f7, $14, $f7, $14, $f7, $f4, $e7, $24, $1e, $1e, $1e, $12
    db $1e, $12, $ff, $f3, $ff, $00, $ff, $00, $ff, $f3, $ff, $f3, $00, $00, $00, $00
    db $00, $00, $f8, $f8, $f8, $08, $f8, $08, $f8, $c8, $f8, $c8, $1f, $12, $1f, $12
    db $1f, $12, $1f, $12, $7f, $73, $7f, $40, $7f, $40, $7f, $7f, $ff, $66, $ff, $00
    db $ff, $66, $ff, $66, $ff, $ff, $ff, $00, $ff, $00, $ff, $ff, $c7, $44, $c7, $44
    db $c7, $44, $c7, $44, $c7, $c4, $c7, $44, $c7, $44, $c7, $c7, $ff, $ff, $ff, $c0
    db $ff, $ff, $ff, $80, $ff, $9f, $ff, $9f, $ff, $80, $ff, $ff, $e7, $e4, $e7, $24
    db $f7, $f4, $f7, $17, $f0, $90, $f0, $90, $f0, $10, $f0, $f0, $ff, $f3, $ff, $00
    db $ff, $00, $ff, $f3, $1e, $12, $1e, $12, $1e, $12, $1e, $1e, $f8, $c8, $f8, $08
    db $f8, $08, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $7d0, $00

; I: copied to VRAM/WRAM by Mode0D_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0D)
Gfx_14_5800_Mode0D_State00_Init::
    INCBIN "data/bank_14/Gfx_14_5800_Mode0D_State00_Init.2bpp" ; $5800, 2048 bytes
; I: copied to VRAM/WRAM by Mode0D_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0D)
Gfx_14_6000_Mode0D_State00_Init::
    INCBIN "data/bank_14/Gfx_14_6000_Mode0D_State00_Init.2bpp" ; $6000, 2048 bytes
; C: copied to VRAM/WRAM by Mode0D_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: not reached
; by the 206 BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first
; read in mode 0D)
Gfx_14_6800_Mode0D_State00_Init::
    INCBIN "data/bank_14/Gfx_14_6800_Mode0D_State00_Init.2bpp" ; $6800, 2048 bytes
; I: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1072 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Gfx_14_7000_PenMenu_Build::
    INCBIN "data/bank_14/Gfx_14_7000_PenMenu_Build.2bpp" ; $7000, 1072 bytes
; C: copied to VRAM/WRAM by Mode10_State02_Setup, Mode10_State0A_SaveResult (roms/jp_rev_a/assets/catalog_jp.csv). L3
; pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Gfx_14_7430_Mode10_State02_Setup::
    INCBIN "data/bank_14/Gfx_14_7430_Mode10_State02_Setup.2bpp" ; $7430, 432 bytes
; C: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read
; in BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Gfx_14_75E0_PenMenu_Build::
    INCBIN "data/bank_14/Gfx_14_75E0_PenMenu_Build.2bpp" ; $75E0, 32 bytes
; I: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1024 from the
; nearby ld bc. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
Gfx_14_7600_PenMenu_Build::
    INCBIN "data/bank_14/Gfx_14_7600_PenMenu_Build.2bpp" ; $7600, 176 bytes
; C: Spriter's Resource sheet "Miscellaneous - Doodle Rips", 70 tiles. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousDoodleRips_14_76B0::
    INCBIN "data/bank_14/Sheet_MiscellaneousDoodleRips_14_76B0.2bpp" ; $76B0, 848 bytes
; I: far pointer loaded by PenMenu_Build (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass 2026-10-26: read
; in BGB in 4 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Gfx_14_7A00_PenMenu_Build::
    INCBIN "data/bank_14/Gfx_14_7A00_PenMenu_Build.2bpp" ; $7A00, 128 bytes
; C: Spriter's Resource sheet "Miscellaneous - Doodle Rips", 63 tiles. L3 pass 2026-10-26: read in BGB in 4 replay(s)
; of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Sheet_MiscellaneousDoodleRips_14_7A80::
    INCBIN "data/bank_14/Sheet_MiscellaneousDoodleRips_14_7A80.2bpp" ; $7A80, 944 bytes
; I: copied to VRAM/WRAM by Mode10_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Gfx_14_7E30_Mode10_State02_Setup::
    INCBIN "data/bank_14/Gfx_14_7E30_Mode10_State02_Setup.2bpp" ; $7E30, 208 bytes
; C: copied to VRAM/WRAM by Mode10_State02_Setup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Gfx_14_7F00_Mode10_State02_Setup::
    db $00, $00, $fc, $fc, $84, $84, $bc, $bc, $a0, $a0, $a0, $a0, $e0, $e0, $00, $00
    db $3c, $3c, $42, $42, $81, $81, $81, $81, $81, $81, $81, $81, $42, $42, $3c, $3c
    db $70, $70, $88, $88, $88, $88, $88, $88, $70, $70, $00, $00, $00, $00, $00, $00
    db $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3c, $00, $42, $00, $81, $00, $81, $00, $81, $00, $81, $00, $42, $00, $3c, $00
    db $70, $00, $88, $00, $88, $00, $88, $00, $70, $00, $00, $00, $00, $00, $00, $00
    db $c0, $00, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $00, $10, $00, $00, $00, $d6, $00, $00, $00, $10, $00, $10, $00, $00, $00
    db $10, $10, $10, $10, $00, $00, $d6, $d6, $00, $00, $10, $10, $10, $10, $00, $00
    db $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

    ; padding
    ds $60, $00

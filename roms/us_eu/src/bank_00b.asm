; Game Boy Camera (USA, Europe), bank $0B. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00b", ROMX[$4000], BANK[$b]

; C: MLT_REQ packets $89 $00 (1 player) and $89 $01 (2 players)
Sgb_MltReqPackets::
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: PAL_SET $51, palette ids $0010 x4
Sgb_PalSetPacket::
    db $51, $10, $00, $10, $00, $10, $00, $10, $00, $80, $00, $00, $00, $00, $00, $00

; C: ATTR_TRN $A9 $00; data window 4040-503F
Sgb_AttrTrnPacket::
    db $a9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: start of the ATTR_TRN window (attribute files; zeros then $40 $90 $E4)
Sgb_AttrTrnData::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $40, $40, $40
    db $90, $90, $90, $e4, $e4, $e4

; C: PAL_TRN $59 $00; data window 40B6-50B5
Sgb_PalTrnPacket::
    db $59, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: SNES system palettes 0-16 (4 BGR555 colours each)
Sgb_PalTrnData::
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $9c, $73, $5a, $6b, $18, $63
    db $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e
    db $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e
    db $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e
    db $ff, $7f, $5a, $6b, $b5, $5a, $31, $46
    db $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d
    db $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d
    db $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d
    db $ff, $7f, $f7, $62, $10, $46, $4a, $29
    db $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c
    db $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c
    db $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c
    db $ff, $7f, $b5, $5a, $6b, $35, $63, $10
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

; C: CHR_TRN $99 $00: border tiles 0-127 follow
Sgb_ChrTrnPacket0::
    db $99, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: SGB border tiles 0-127 (4bpp, 32 bytes each)
Sgb_BorderTiles0::
    INCBIN "data/bank_0b/Sgb_BorderTiles0.bin" ; $4166, 4096 bytes
; C: CHR_TRN $99 $01: border tiles 128-255 follow
Sgb_ChrTrnPacket1::
    db $99, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: SGB border tiles 128-255 (4bpp)
Sgb_BorderTiles1::
    INCBIN "data/bank_0b/Sgb_BorderTiles1.bin" ; $5176, 4096 bytes
; C: PCT_TRN $A1 $00: map and palettes follow
Sgb_PctTrnPacket::
    db $a1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: SGB border map: 32 x 32 words (tile, attribute), 64 bytes per row
Sgb_BorderMap::
    INCBIN "data/bank_0b/Sgb_BorderMap.bin" ; $6186, 2048 bytes
; I: border palettes 4 and 5 (16 BGR555 words each)
Sgb_BorderPalettes::
    db $00, $00, $ff, $7f, $7b, $6f, $99, $26
    db $14, $1e, $8f, $15, $fc, $36, $0a, $11
    db $5c, $5f, $39, $67, $73, $4e, $8c, $31
    db $ba, $2e, $c6, $18, $1b, $47, $00, $00
    db $00, $00, $ff, $7f, $7b, $6f, $67, $4d
    db $26, $3d, $e4, $2c, $ca, $59, $83, $20
    db $5c, $5f, $39, $67, $73, $4e, $8c, $31
    db $0d, $5a, $c6, $18, $92, $62, $00, $00

; C
Sgb_Pad_69C6::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: eight DATA_SND packets ($79, SNES address $085D down to $0810; 11 bytes each)
Sgb_DataSndPackets::
    db $79, $5d, $08, $00, $0b, $8c, $d0, $f4, $60, $00, $00, $00, $00, $00, $00, $00
    db $79, $52, $08, $00, $0b, $a9, $e7, $9f, $01, $c0, $7e, $e8, $e8, $e8, $e8, $e0
    db $79, $47, $08, $00, $0b, $c4, $d0, $16, $a5, $cb, $c9, $05, $d0, $10, $a2, $28
    db $79, $3c, $08, $00, $0b, $f0, $12, $a5, $c9, $c9, $c8, $d0, $1c, $a5, $ca, $c9
    db $79, $31, $08, $00, $0b, $0c, $a5, $ca, $c9, $7e, $d0, $06, $a5, $cb, $c9, $7e
    db $79, $26, $08, $00, $0b, $39, $cd, $48, $0c, $d0, $34, $a5, $c9, $c9, $80, $d0
    db $79, $1b, $08, $00, $0b, $ea, $ea, $ea, $ea, $ea, $a9, $01, $cd, $4f, $0c, $d0
    db $79, $10, $08, $00, $0b, $4c, $20, $08, $ea, $ea, $ea, $ea, $ea, $60, $ea, $ea

; C: MASK_EN freeze $B9 $01 (6A66) and cancel $B9 $00 (6A76)
Sgb_MaskEnPackets::
    db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $b9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $157a, $00

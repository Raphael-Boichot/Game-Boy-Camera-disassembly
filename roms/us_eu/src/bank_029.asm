; Game Boy Camera (USA, Europe), bank $29. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $029", ROMX[$4000], BANK[$29]

; C: 214 records of 32 bytes (5-byte header + tile numbers, $FF/$FE = blank): the English staff roll;
; ScrollEngine_Sub1_FetchRow loads bank $29 at $4000 + row*32 (ScrollEngine_RowToOffset); the Japanese table at the
; same address has 234 rows
Credits_ScrollRowTbl::
    INCBIN "data/bank_29/Credits_ScrollRowTbl.bin" ; $4000, 6848 bytes
; C: 42 zero records after the 214 rows (29:5AC0-6000); read past the end of the table in forced runs, so not padding
Credits_ScrollRowTbl_ZeroRows::
    INCBIN "data/bank_29/Credits_ScrollRowTbl_ZeroRows.bin" ; $5AC0, 1344 bytes
; C: stock face set 6, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/0); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6000_StockFace6_Expr0::
    INCBIN "data/bank_29/Gfx_29_6000_StockFace6_Expr0.2bpp" ; $6000, 896 bytes
; C: stock face set 6, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/1); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6380_StockFace6_Expr1::
    INCBIN "data/bank_29/Gfx_29_6380_StockFace6_Expr1.2bpp" ; $6380, 896 bytes
; C: stock face set 6, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 6/2); not in the Japanese ROM;
; used as: Run! Run! Run!, first face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_29_6700_StockFace6_Expr2::
    INCBIN "data/bank_29/Gfx_29_6700_StockFace6_Expr2.2bpp" ; $6700, 896 bytes
; C: stock face set 6, expression 3 (StockFace_GfxTbl entry 6/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_29_6A80_StockFace6_Expr3::
    INCBIN "data/bank_29/Gfx_29_6A80_StockFace6_Expr3.2bpp" ; $6A80, 896 bytes
; C: stock face set 7, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/0); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_6E00_StockFace7_Expr0::
    INCBIN "data/bank_29/Gfx_29_6E00_StockFace7_Expr0.2bpp" ; $6E00, 896 bytes
; C: stock face set 7, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/1); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_7180_StockFace7_Expr1::
    INCBIN "data/bank_29/Gfx_29_7180_StockFace7_Expr1.2bpp" ; $7180, 896 bytes
; C: stock face set 7, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 7/2); not in the Japanese ROM;
; used as: Ball, second face option, the drawn heads (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8); the owner's "default Ball
; head" in bank $29
Gfx_29_7500_StockFace7_Expr2::
    INCBIN "data/bank_29/Gfx_29_7500_StockFace7_Expr2.2bpp" ; $7500, 896 bytes
; C: stock face set 7, expression 3 (StockFace_GfxTbl entry 7/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_29_7880_StockFace7_Expr3::
    INCBIN "data/bank_29/Gfx_29_7880_StockFace7_Expr3.2bpp" ; $7880, 896 bytes
; C: entry 0 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune0_29_7C00::
    db $09
    db $8f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $09
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $5f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $78

; C: entry 1 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune1_29_7C59::
    db $15
    db $8f
    db $09
    db $00
    db $11
    db $1d
    db $01
    db $19
    db $00
    db $00
    db $1b
    db $00
    db $00
    db $06
    db $0b
    db $0f
    db $12
    db $17
    db $1b
    db $1e
    db $55
    db $55
    db $55
    db $55
    db $00
    db $11
    db $22
    db $33
    db $44
    db $55
    db $66
    db $77
    db $88
    db $99
    db $a4
    db $bb
    db $cc
    db $4d
    db $e4
    db $ff
    db $27
    db $04
    db $81
    db $01
    db $0d
    db $0b
    db $14
    db $01
    db $14
    db $16
    db $0d
    db $01
    db $0b
    db $0d
    db $08
    db $01
    db $12
    db $17
    db $1b
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $4f
    db $16
    db $24
    db $23
    db $16
    db $0a
    db $22
    db $14
    db $0a
    db $24
    db $23
    db $16
    db $00
    db $0a
    db $16
    db $25
    db $24
    db $55
    db $55
    db $55
    db $55
    db $2b
    db $4b
    db $78

; C: entry 4 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune4_29_7CB2::
    db $20
    db $ef
    db $00
    db $00
    db $22
    db $00
    db $1b
    db $00
    db $1d
    db $00
    db $22
    db $00
    db $22
    db $00
    db $1b
    db $00
    db $1d
    db $00
    db $20
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $00
    db $00
    db $ff
    db $ff
    db $27
    db $8f
    db $00
    db $20
    db $1d
    db $00
    db $00
    db $19
    db $1b
    db $00
    db $00
    db $22
    db $1d
    db $00
    db $00
    db $19
    db $1b
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $5f
    db $0e
    db $00
    db $08
    db $00
    db $08
    db $00
    db $1f
    db $00
    db $1d
    db $1a
    db $00
    db $13
    db $1e
    db $1a
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $a8
    db $00
    db $3c

; C: entry 3 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune3_29_7D0B::
    db $17
    db $8f
    db $a5
    db $08
    db $01
    db $00
    db $01
    db $01
    db $20
    db $00
    db $00
    db $00
    db $06
    db $00
    db $00
    db $00
    db $0d
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $19
    db $94
    db $00
    db $0d
    db $00
    db $0d
    db $0d
    db $0d
    db $00
    db $08
    db $00
    db $0b
    db $00
    db $0b
    db $00
    db $0d
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8f
    db $8f
    db $00
    db $00
    db $20
    db $00
    db $00
    db $08
    db $1d
    db $00
    db $00
    db $00
    db $05
    db $00
    db $03
    db $00
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $04
    db $28
    db $3c

; C: entry 2 of DjEd_SetFieldCursor_Tbl6257 (05:6257): an 89-byte D.J. tune record copied to wSettingsPreset and
; played through Dj_LoadTune_FromDE_Far; in the Japanese build these records sit at 29:6000 (Map_29_6000_Map05_62A3
; ...), here they moved to the end of the bank, after the stock faces
DjPresetTune2_29_7D64::
    db $27
    db $af
    db $00
    db $00
    db $01
    db $04
    db $00
    db $13
    db $00
    db $00
    db $07
    db $00
    db $00
    db $00
    db $00
    db $19
    db $00
    db $21
    db $00
    db $00
    db $55
    db $55
    db $55
    db $55
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $17
    db $1c
    db $0d
    db $03
    db $1c
    db $00
    db $00
    db $15
    db $00
    db $00
    db $00
    db $00
    db $1d
    db $00
    db $00
    db $23
    db $00
    db $04
    db $00
    db $55
    db $55
    db $55
    db $55
    db $ff
    db $8d
    db $2f
    db $09
    db $20
    db $00
    db $23
    db $00
    db $21
    db $00
    db $23
    db $12
    db $1c
    db $11
    db $23
    db $20
    db $00
    db $23
    db $25
    db $55
    db $55
    db $55
    db $55
    db $44
    db $a8
    db $78

    ; padding
    ds $243, $00

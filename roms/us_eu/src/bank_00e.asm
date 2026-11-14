; Game Boy Camera (USA, Europe), bank $0E. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00e", ROMX[$4000], BANK[$e]

; C: entry 0 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 0 of this build's table
; points here
Gfx_0E_4000_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4000_MsgStrip.2bpp" ; $4000, 640 bytes
; C: entry 1 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 1 of this build's table
; points here
Gfx_0E_4280_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4280_MsgStrip.2bpp" ; $4280, 640 bytes
; C: entry 2 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 2 of this build's table
; points here
Gfx_0E_4500_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4500_MsgStrip.2bpp" ; $4500, 640 bytes
; C: entry 3 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 3 of this build's table
; points here
Gfx_0E_4780_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4780_MsgStrip.2bpp" ; $4780, 640 bytes
; C: entry 4 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 4 of this build's table
; points here
Gfx_0E_4A00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4A00_MsgStrip.2bpp" ; $4A00, 640 bytes
; C: entry 5 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 5 of this build's table
; points here
Gfx_0E_4C80_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4C80_MsgStrip.2bpp" ; $4C80, 640 bytes
; C: entry 6 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 6 of this build's table
; points here
Gfx_0E_4F00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4F00_MsgStrip.2bpp" ; $4F00, 640 bytes
; C: entry 7 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 7 of this build's table
; points here
Gfx_0E_5180_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5180_MsgStrip.2bpp" ; $5180, 640 bytes
; C: entry 8 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 8 of this build's table
; points here
Gfx_0E_5400_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5400_MsgStrip.2bpp" ; $5400, 640 bytes
; C: entry 9 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 9 of this build's table
; points here
Gfx_0E_5680_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5680_MsgStrip.2bpp" ; $5680, 640 bytes
; C: entry 10 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 10 of this build's table
; points here
Gfx_0E_5900_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5900_MsgStrip.2bpp" ; $5900, 640 bytes
; C: entry 11 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 11 of this build's table
; points here
Gfx_0E_5B80_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5B80_MsgStrip.2bpp" ; $5B80, 640 bytes
; C: entry 12 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch); C: entry 12 of this build's table
; points here
Gfx_0E_5E00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5E00_MsgStrip.2bpp" ; $5E00, 640 bytes
; C: entry 14 of the {lo,hi,bank} table 07:4FAA, 640 bytes each (constant pitch); C: entry 14 of this build's table
; points here
Gfx_0E_6080_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_6080_MsgStrip.2bpp" ; $6080, 640 bytes
; C: stock face set 2, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 2/0); the same bytes as
; Japanese 0E:6300; used as: a Japanese face kept (TCRF: the second D.J. face is identical in both builds)
Gfx_0E_6300_StockFace2_Expr0::
    INCBIN "data/bank_0e/Gfx_0E_6300_StockFace2_Expr0.2bpp" ; $6300, 896 bytes
; C: stock face set 2, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 2/1); the same bytes as
; Japanese 0E:6680; used as: a Japanese face kept (TCRF: the second D.J. face is identical in both builds)
Gfx_0E_6680_StockFace2_Expr1::
    INCBIN "data/bank_0e/Gfx_0E_6680_StockFace2_Expr1.2bpp" ; $6680, 896 bytes
; C: stock face set 2, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 2/2); the same bytes as
; Japanese 0E:6A00; used as: a Japanese face kept (TCRF: the second D.J. face is identical in both builds)
Gfx_0E_6A00_StockFace2_Expr2::
    INCBIN "data/bank_0e/Gfx_0E_6A00_StockFace2_Expr2.2bpp" ; $6A00, 896 bytes
; C: stock face set 2, expression 3 (StockFace_GfxTbl entry 2/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); the same bytes as Japanese 0E:6D80
Gfx_0E_6D80_StockFace2_Expr3::
    INCBIN "data/bank_0e/Gfx_0E_6D80_StockFace2_Expr3.2bpp" ; $6D80, 896 bytes
; C: stock face set 3, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 3/0); not in the Japanese ROM;
; used as: Run! Run! Run!, second face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_0E_7100_StockFace3_Expr0::
    INCBIN "data/bank_0e/Gfx_0E_7100_StockFace3_Expr0.2bpp" ; $7100, 896 bytes
; C: stock face set 3, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 3/1); not in the Japanese ROM;
; used as: Run! Run! Run!, second face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_0E_7480_StockFace3_Expr1::
    INCBIN "data/bank_0e/Gfx_0E_7480_StockFace3_Expr1.2bpp" ; $7480, 896 bytes
; C: stock face set 3, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 3/2); not in the Japanese ROM;
; used as: Run! Run! Run!, second face option (Run_CharacterToGfxIndex_Tbl72C6 = 6, 3, 8)
Gfx_0E_7800_StockFace3_Expr2::
    INCBIN "data/bank_0e/Gfx_0E_7800_StockFace3_Expr2.2bpp" ; $7800, 896 bytes
; C: stock face set 3, expression 3 (StockFace_GfxTbl entry 3/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_0E_7B80_StockFace3_Expr3::
    INCBIN "data/bank_0e/Gfx_0E_7B80_StockFace3_Expr3.2bpp" ; $7B80, 896 bytes
; C: far pointer loaded by Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic
; corpus, modes 1A (roms/jp_rev_a/experiments/l3_names/)
Map_0E_7F00_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_0e/Map_0E_7F00_Mode1A_State04_PlaceOrDelete.tilemap" ; $7F00, 256 bytes

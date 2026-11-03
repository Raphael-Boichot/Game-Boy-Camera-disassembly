; Game Boy Camera (USA, Europe), bank $0F. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00f", ROMX[$4000], BANK[$f]

; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/); C: the bytes changed but
; Mode08_State00_Init reads them in this build (coverage call site or loader ...
Gfx_0F_4000_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_4000_Mode08_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_4800_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_4800_Mode08_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_0F_5000_Mode08_State00_Init::
    INCBIN "data/bank_0f/Gfx_0F_5000_Mode08_State00_Init.2bpp" ; $5000, 1280 bytes
; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/); L3 same: the
; readers here (UserMap_LoadPlanetTiles) are the readers of the same name in ...
Gfx_0F_5500_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5500_UserMap_LoadPlanetTiles.2bpp" ; $5500, 640 bytes
; C: 40 tiles (640 bytes) copied whole to $8500 by UserMap_LoadPlanetTiles (copy site 09:51DC,
; roms/jp_rev_a/assets/copy_sites_jp.csv); the four planet sets are 5500 / 5780 / 5A00 / 5C80; the labels 5800 (Aux),
; 5904 (Unref), 596C and 5984 (Data) inside it were fill-run splits; C: the bytes changed but ...
Gfx_0F_5780_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5780_UserMap_LoadPlanetTiles.2bpp" ; $5780, 640 bytes
; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/); C: the bytes changed but UserMap_LoadPlanetTiles reads ...
Gfx_0F_5A00_UserMap_LoadPlanetTiles::
    INCBIN "data/bank_0f/Gfx_0F_5A00_UserMap_LoadPlanetTiles.bin" ; $5A00, 527 bytes
; C: tiles: BGB, menu walk node U02 (tcrf_check/tools/guide_nodes.py, intl ROM): its first 16 bytes are in VRAM tile
; data; read by UserMap_LoadPlanetTiles
Gfx_0F_5C0F_UserMap_LoadPlanetTiles::
    db $80, $49, $86, $48, $84, $48, $84, $88, $44, $08, $84, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $80, $47, $43, $a4, $a2, $c4, $22, $44, $a2, $c5, $c3
    db $24, $82, $44, $42, $a4, $42, $24, $43, $24, $40, $27, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $e0, $e0, $00, $00, $00, $00, $00, $00, $c0, $c0
    db $00, $00, $00, $00, $00, $00, $00, $e0, $00, $00, $e0

    ; padding
    ds $26, $00

; C: far pointer loaded by UserMap_LoadPlanetTiles (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 08
; (tcrf_check/assets/l3_names/); C: the bytes changed but UserMap_LoadPlanetTiles reads ...
Gfx_0F_5C80_UserMap_LoadPlanetTiles::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0e, $12, $1e, $20, $72, $4d, $21, $52, $70, $13, $40, $20
    db $40, $20, $33, $52, $69, $5a, $12, $2d, $0c, $12, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $3e, $01, $21, $1e, $22, $13, $20, $11, $22, $13, $3f, $00
    db $26, $19, $21, $12, $21, $10, $21, $10, $21, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $1f, $0f, $90, $88, $10, $88, $10, $88, $17, $0f, $90
    db $08, $10, $08, $90, $08, $90, $0f, $90, $00, $9f, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1c, $82, $9e, $01, $17, $0c, $13, $0a, $11, $08, $10, $09
    db $10, $09, $13, $0a, $15, $0e, $96, $09, $0c, $92, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1e, $00, $08, $16, $88, $84, $08, $84, $88, $04, $88, $04
    db $88, $04, $88, $04, $08, $84, $08, $16, $1e, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7e, $7e, $00, $7e, $66, $18, $00, $18, $00, $18, $00
    db $18, $00, $18, $00, $18, $00, $18, $00, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $24, $3c, $42, $6c, $0a, $60, $00, $34, $4c, $1e, $22
    db $0e, $00, $46, $40, $66, $18, $7e, $02, $5c, $64, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $0e, $12, $1e, $20, $72, $4d, $21, $52, $70, $13, $40, $20
    db $40, $20, $33, $52, $69, $5a, $12, $2d, $0c, $12, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $3e, $01, $21, $1e, $22, $13, $20, $11, $22, $13, $3f, $00
    db $26, $19, $21, $12, $21, $10, $21, $10, $21, $10, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $1f, $0f, $90, $88, $10, $88, $10, $88, $17, $0f, $90
    db $08, $10, $08, $90, $08, $90, $0f, $90, $00, $9f, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1c, $82, $9e, $01, $17, $0c, $13, $0a, $11, $08, $10, $09
    db $10, $09, $13, $0a, $15, $0e, $96, $09, $0c, $92, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $1e, $00, $08, $16, $88, $84, $08, $84, $88, $04, $88, $04
    db $88, $04, $88, $04, $08, $84, $08, $16, $1e, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $7e, $7e, $00, $7e, $66, $18, $00, $18, $00, $18, $00
    db $18, $00, $18, $00, $18, $00, $18, $00, $18, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $18, $24, $3c, $42, $6c, $0a, $60, $00, $34, $4c, $1e, $22
    db $0e, $00, $46, $40, $66, $18, $7e, $02, $5c, $64, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $28, $00

; C: stock face set 0, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 0/0); not in the Japanese ROM;
; used as: Ball, first face option (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8)
Gfx_0F_5F00_StockFace0_Expr0::
    INCBIN "data/bank_0f/Gfx_0F_5F00_StockFace0_Expr0.2bpp" ; $5F00, 896 bytes
; C: stock face set 0, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 0/1); not in the Japanese ROM;
; used as: Ball, first face option (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8)
Gfx_0F_6280_StockFace0_Expr1::
    INCBIN "data/bank_0f/Gfx_0F_6280_StockFace0_Expr1.2bpp" ; $6280, 896 bytes
; C: stock face set 0, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 0/2); not in the Japanese ROM;
; used as: Ball, first face option (Ball_PickGfxBank_Tbl7F4E = 0, 7, 8)
Gfx_0F_6600_StockFace0_Expr2::
    INCBIN "data/bank_0f/Gfx_0F_6600_StockFace0_Expr2.2bpp" ; $6600, 896 bytes
; C: stock face set 0, expression 3 (StockFace_GfxTbl entry 0/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_0F_6980_StockFace0_Expr3::
    INCBIN "data/bank_0f/Gfx_0F_6980_StockFace0_Expr3.2bpp" ; $6980, 896 bytes
; C: stock face set 1, expression 0 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 1/0); not in the Japanese ROM;
; used as: D.J., first face option (TCRF: the international D.J. face)
Gfx_0F_6D00_StockFace1_Expr0::
    INCBIN "data/bank_0f/Gfx_0F_6D00_StockFace1_Expr0.2bpp" ; $6D00, 896 bytes
; C: stock face set 1, expression 1 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 1/1); not in the Japanese ROM;
; used as: D.J., first face option (TCRF: the international D.J. face)
Gfx_0F_7080_StockFace1_Expr1::
    INCBIN "data/bank_0f/Gfx_0F_7080_StockFace1_Expr1.2bpp" ; $7080, 896 bytes
; C: stock face set 1, expression 2 of 4 (56 tiles, $380 bytes; StockFace_GfxTbl entry 1/2); not in the Japanese ROM;
; used as: D.J., first face option (TCRF: the international D.J. face)
Gfx_0F_7400_StockFace1_Expr2::
    INCBIN "data/bank_0f/Gfx_0F_7400_StockFace1_Expr2.2bpp" ; $7400, 896 bytes
; C: stock face set 1, expression 3 (StockFace_GfxTbl entry 1/3; $380 B): the face shown when the ball is missed
; (Mode20_State06_GameOver: Ball_LoadGfx8D80 with C = 3); not in the Japanese ROM
Gfx_0F_7780_StockFace1_Expr3::
    INCBIN "data/bank_0f/Gfx_0F_7780_StockFace1_Expr3.2bpp" ; $7780, 896 bytes
; C: copied to VRAM/WRAM by Boot_EraseAllPrompt_Far (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in
; BGB in 2 replay(s) of the organic corpus, modes 00 (tcrf_check/assets/l3_names/); L3 same: the readers here
; (Boot_EraseAllPrompt_Far) are the readers of the same name in the Japanese ...
Gfx_0F_7B00_Boot_EraseAllPrompt_Far::
    INCBIN "data/bank_0f/Gfx_0F_7B00_Boot_EraseAllPrompt_Far.2bpp" ; $7B00, 1280 bytes

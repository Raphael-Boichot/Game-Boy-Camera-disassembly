; Pocket Camera Hello Kitty (Japan), bank $03. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; C: leftover: 100 bytes (03:4000-4063) sprite layout of 25 records (y, x, tile, attribute; bit 0 of the attribute
; ends the list, as Obj_DrawSprite reads it): a 5 x 5 block of tiles $00-$44; nothing points at it, never drawn
Leftover_03_4000_OamList::
    db $10, $08, $00, $00, $10, $10, $01, $00, $10, $18, $02, $00, $10, $20, $03, $00
    db $10, $28, $04, $00, $18, $08, $10, $00, $18, $10, $11, $00, $18, $18, $12, $00
    db $18, $20, $13, $00, $18, $28, $14, $00, $20, $08, $20, $00, $20, $10, $21, $00
    db $20, $18, $22, $00, $20, $20, $23, $00, $20, $28, $24, $00, $28, $08, $30, $00
    db $28, $10, $31, $00, $28, $18, $32, $00, $28, $20, $33, $00, $28, $28, $34, $00
    db $30, $08, $40, $00, $30, $10, $41, $00, $30, $18, $42, $00, $30, $20, $43, $00
    db $30, $28, $44, $01

; C: leftover: 100 bytes (03:4064-40C7) sprite layout of 25 records: the 5 x 5 block of tiles $80-$C4; never drawn
Leftover_03_4064_OamList::
    db $10, $08, $80, $00, $10, $10, $81, $00, $10, $18, $82, $00, $10, $20, $83, $00
    db $10, $28, $84, $00, $18, $08, $90, $00, $18, $10, $91, $00, $18, $18, $92, $00
    db $18, $20, $93, $00, $18, $28, $94, $00, $20, $08, $a0, $00, $20, $10, $a1, $00
    db $20, $18, $a2, $00, $20, $20, $a3, $00, $20, $28, $a4, $00, $28, $08, $b0, $00
    db $28, $10, $b1, $00, $28, $18, $b2, $00, $28, $20, $b3, $00, $28, $28, $b4, $00
    db $30, $08, $c0, $00, $30, $10, $c1, $00, $30, $18, $c2, $00, $30, $20, $c3, $00
    db $30, $28, $c4, $01

; C: leftover: 40 bytes (03:40C8-40EF) sprite layout of 10 records: two rows of five, tiles $00-$14; never drawn
Leftover_03_40C8_OamList::
    db $10, $08, $00, $00, $08, $10, $00, $00, $10, $18, $02, $00, $08, $20, $02, $00
    db $10, $28, $04, $00, $30, $08, $10, $00, $28, $10, $10, $00, $30, $18, $12, $00
    db $28, $20, $12, $00, $30, $28, $14, $01

; C: leftover: 40 bytes (03:40F0-4117) sprite layout of 10 records: two rows of five, tiles $80-$94; never drawn
Leftover_03_40F0_OamList::
    db $10, $08, $80, $00, $08, $10, $80, $00, $10, $18, $82, $00, $08, $20, $82, $00
    db $10, $28, $84, $00, $30, $08, $90, $00, $28, $10, $90, $00, $30, $18, $92, $00
    db $28, $20, $92, $00, $30, $28, $94, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode0E_KittGamesHost_State13
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_4118_Mode0E_KittGamesHost_State13::
    INCBIN "data/bank_03/OamList_03_4118_Mode0E_KittGamesHost_State13.bin" ; $4118, 1920 bytes
; I: leftover: 72 bytes (03:4898-48DF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_4898::
    db $28, $e8, $1a, $10, $28, $e0, $18, $10, $28, $08, $1a, $10, $28, $00, $18, $10
    db $28, $28, $1a, $10, $28, $20, $18, $10, $e8, $28, $1a, $10, $e8, $20, $18, $10
    db $e8, $08, $1a, $10, $e8, $00, $18, $10, $e8, $e8, $1a, $10, $e8, $e0, $18, $10
    db $08, $e8, $1a, $10, $08, $e0, $18, $10, $08, $28, $1a, $10, $08, $20, $18, $10
    db $08, $08, $1a, $10, $08, $00, $18, $11

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode12_SlideShow_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_48E0_Mode12_SlideShow_State01::
    INCBIN "data/bank_03/OamList_03_48E0_Mode12_SlideShow_State01.bin" ; $48E0, 2176 bytes
; I: leftover: 96 bytes (03:5160-51BF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_5160::
    db $10, $08, $11, $00, $10, $00, $10, $00, $08, $08, $01, $00, $08, $00, $00, $01
    db $10, $09, $13, $00, $10, $01, $12, $00, $08, $09, $03, $00, $08, $01, $02, $01
    db $10, $0a, $15, $00, $10, $02, $14, $00, $08, $0a, $05, $00, $08, $02, $04, $01
    db $10, $0b, $17, $00, $10, $03, $16, $00, $08, $0b, $07, $00, $08, $03, $06, $01
    db $08, $0a, $15, $40, $08, $02, $14, $40, $10, $0a, $05, $40, $10, $02, $04, $41
    db $08, $09, $13, $40, $08, $01, $12, $40, $10, $09, $03, $40, $10, $01, $02, $41

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_51C0_Mode02_TakePhotos_State01::
    db $10, $08, $7d, $00, $08, $08, $7c, $00, $10, $00, $7b, $00, $08, $00, $7a, $01
    db $3d, $08, $78, $00, $ed, $08, $78, $00, $15, $08, $78, $01, $51, $08, $78, $00
    db $29, $08, $78, $00, $01, $08, $78, $01, $10, $c6, $79, $00, $10, $e6, $79, $00
    db $10, $06, $79, $00, $10, $26, $79, $01, $10, $36, $79, $00, $10, $16, $79, $00
    db $10, $d6, $79, $00, $10, $f6, $79, $01

; I: leftover: 72 bytes (03:5208-524F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_5208::
    db $04, $2f, $78, $00, $24, $2f, $78, $00, $2f, $14, $79, $00, $2f, $f4, $79, $00
    db $24, $df, $78, $00, $04, $df, $78, $00, $f0, $e4, $79, $00, $f0, $24, $79, $00
    db $f0, $04, $79, $01, $16, $2f, $78, $40, $f6, $2f, $78, $40, $eb, $14, $79, $40
    db $eb, $f4, $79, $40, $f6, $df, $78, $40, $16, $df, $78, $40, $2a, $e4, $79, $40
    db $2a, $24, $79, $40, $2a, $04, $79, $41

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_5250_Mode02_TakePhotos_State01::
    db $14, $08, $c5, $00, $14, $00, $c4, $00, $0c, $08, $c3, $00, $04, $08, $c2, $00
    db $0c, $00, $c1, $00, $04, $00, $c0, $01, $14, $08, $cb, $00, $14, $00, $ca, $00
    db $0c, $08, $c9, $00, $04, $08, $c8, $00, $0c, $00, $c7, $00, $04, $00, $c6, $01

; I: leftover: 96 bytes (03:5280-52DF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_5280::
    db $14, $08, $d1, $00, $14, $00, $d0, $00, $0c, $08, $cf, $00, $04, $08, $ce, $00
    db $0c, $00, $cd, $00, $04, $00, $cc, $01, $14, $08, $d7, $00, $14, $00, $d6, $00
    db $0c, $08, $d5, $00, $04, $08, $d4, $00, $0c, $00, $d3, $00, $04, $00, $d2, $01
    db $14, $08, $dd, $00, $14, $00, $dc, $00, $0c, $08, $db, $00, $04, $08, $da, $00
    db $0c, $00, $d9, $00, $04, $00, $d8, $01, $14, $08, $e3, $00, $14, $00, $e2, $00
    db $0c, $08, $e1, $00, $04, $08, $e0, $00, $0c, $00, $df, $00, $04, $00, $de, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_52E0_Mode02_TakePhotos_State01::
    db $10, $08, $e7, $00, $08, $08, $e6, $00, $10, $00, $e5, $00, $08, $00, $e4, $01

; I: leftover: 104 bytes (03:52F0-5357) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_52F0::
    db $10, $08, $eb, $00, $08, $08, $ea, $00, $10, $00, $e9, $00, $08, $00, $e8, $01
    db $10, $08, $ef, $00, $08, $08, $ee, $00, $10, $00, $ed, $00, $08, $00, $ec, $01
    db $10, $24, $71, $00, $08, $24, $70, $00, $10, $1c, $6f, $00, $08, $1c, $6e, $00
    db $10, $14, $6d, $00, $08, $14, $6c, $00, $10, $0c, $6b, $00, $08, $0c, $6a, $00
    db $10, $04, $69, $00, $08, $04, $68, $00, $10, $fc, $67, $00, $08, $fc, $66, $00
    db $10, $f4, $65, $00, $08, $f4, $64, $00, $10, $ec, $63, $00, $08, $ec, $62, $00
    db $10, $e4, $61, $00, $08, $e4, $60, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode04_PlayMenu_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_5358_Mode04_PlayMenu_State01::
    INCBIN "data/bank_03/OamList_03_5358_Mode04_PlayMenu_State01.bin" ; $5358, 2200 bytes
; I: leftover: 332 bytes (03:5BF0-5D3B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_5BF0::
    INCBIN "data/bank_03/Leftover_03_5BF0.bin" ; $5BF0, 332 bytes
; C: read in the runs by Obj_DrawSprite; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_5D3C_Mode06_Printing_State1F::
    INCBIN "data/bank_03/OamList_03_5D3C_Mode06_Printing_State1F.bin" ; $5D3C, 1536 bytes
; I: leftover: 64 bytes (03:633C-637B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_633C::
    db $08, $0c, $37, $30, $08, $04, $38, $10, $08, $fc, $37, $10, $f8, $08, $21, $10
    db $f8, $00, $20, $10, $00, $0c, $24, $10, $00, $04, $23, $10, $00, $fc, $22, $11
    db $00, $0c, $29, $10, $00, $04, $28, $10, $00, $fc, $27, $10, $f8, $08, $26, $10
    db $f8, $00, $25, $10, $08, $0c, $37, $30, $08, $04, $38, $10, $08, $fc, $37, $11

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode06_Printing_State19
; (trace/read_screens_kitty*.npz)
OamList_03_637C_Mode06_Printing_State19::
    db $0a, $0c, $2d, $30, $0a, $04, $2e, $10, $0a, $fc, $2d, $10, $fa, $08, $21, $10
    db $fa, $00, $20, $10, $02, $0c, $24, $10, $02, $04, $23, $10, $02, $fc, $22, $11

; I: leftover: 64 bytes (03:639C-63DB) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_639C::
    db $08, $04, $2f, $10, $00, $0c, $36, $10, $00, $04, $35, $10, $00, $fc, $34, $10
    db $f8, $08, $3d, $10, $f8, $00, $3c, $10, $08, $0c, $32, $30, $08, $fc, $32, $11
    db $08, $04, $30, $10, $00, $0c, $36, $10, $00, $04, $35, $10, $00, $fc, $34, $10
    db $f8, $08, $3d, $10, $f8, $00, $3c, $10, $08, $0c, $32, $30, $08, $fc, $32, $11

; C: a frame of Kitty in the print fruit game: the loop 02:76CF of her script 02:7686 (PrintGame_ObjKitty, after A)
; shows 03:637C for $70 frames, then this one; read in the core when the printer stays busy as a real one does, at
; least 9 seconds for a regular image, owner 2026-11-22 ...
OamList_03_63DC_PrintGame_Kitty::
    db $02, $04, $2b, $10, $0a, $0c, $2d, $30, $0a, $04, $2e, $10, $0a, $fc, $2d, $10
    db $fa, $08, $21, $10, $fa, $00, $20, $10, $02, $0c, $24, $10, $02, $fc, $22, $11

; C: sprite layouts read by Obj_DrawSprite: 03:63FC first read on the print game's result screen (06:2A;
; ObjScript_02_7725_PrintGame_ShowResult points to it, 02:7747), 03:641E-645B on the main menu (01:02), 03:645C on the
; exchange screens (trace/read_screens_kitty_paths.npz, _rare, _link); a hand label ...
OamList_03_63FC_Mode06_Printing_State2A::
    INCBIN "data/bank_03/OamList_03_63FC_Mode06_Printing_State2A.bin" ; $63FC, 296 bytes
; I: leftover: 712 bytes (03:6524-67EB) that no run reads or executes and that no code names (owner rule 2026-11-11);
; a hand label since the labels 03:63DC / 03:63FC are hand ones (2026-11-22)
Leftover_03_6524::
    INCBIN "data/bank_03/Leftover_03_6524.bin" ; $6524, 712 bytes
; C: read in the runs by Obj_DrawSprite; first read on the screen Mode08_ExchangePhotoTrain_State05
; (trace/read_screens_kitty*.npz)
OamList_03_67EC_Mode08_ExchangePhotoTrain_State05::
    INCBIN "data/bank_03/OamList_03_67EC_Mode08_ExchangePhotoTrain_State05.bin" ; $67EC, 680 bytes
; I: leftover: 296 bytes (03:6A94-6BBB) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_6A94::
    INCBIN "data/bank_03/Leftover_03_6A94.bin" ; $6A94, 296 bytes
; C: read in the runs by Obj_DrawSprite; first read on the screen Mode09_ExchangeCommunicating_State0A
; (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange)
OamList_03_6BBC_Mode09_ExchangeCommunicating_State0A::
    db $08, $10, $58, $70, $08, $f8, $58, $50, $f8, $10, $58, $30, $f8, $f8, $58, $11
    db $09, $11, $58, $70, $09, $f7, $58, $50, $f7, $11, $58, $30, $f7, $f7, $58, $11
    db $0a, $12, $58, $70, $0a, $f6, $58, $50, $f6, $12, $58, $30, $f6, $f6, $58, $11
    db $18, $f0, $30, $10, $10, $f0, $20, $10, $18, $08, $33, $10, $18, $00, $32, $10
    db $18, $f8, $31, $10, $10, $08, $23, $10, $10, $00, $22, $10, $10, $f8, $21, $10
    db $08, $08, $13, $10, $08, $00, $12, $10, $08, $f8, $11, $10, $00, $08, $03, $10
    db $00, $00, $02, $10, $00, $f8, $01, $11

; I: leftover: 56 bytes (03:6C24-6C5B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_6C24::
    db $08, $08, $10, $10, $08, $00, $00, $10, $18, $f0, $30, $10, $10, $f0, $20, $10
    db $18, $08, $33, $10, $18, $00, $32, $10, $18, $f8, $31, $10, $10, $08, $23, $10
    db $10, $00, $22, $10, $10, $f8, $21, $10, $08, $f8, $11, $10, $00, $08, $03, $10
    db $00, $00, $02, $10, $00, $f8, $01, $11

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode09_ExchangeCommunicating_State0A
; (trace/read_screens_kitty*.npz); read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
OamList_03_6C5C_Mode09_ExchangeCommunicating_State0A::
    INCBIN "data/bank_03/OamList_03_6C5C_Mode09_ExchangeCommunicating_State0A.bin" ; $6C5C, 604 bytes
; I: leftover: 48 bytes (03:6EB8-6EE7) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_6EB8::
    db $14, $fc, $77, $20, $04, $fc, $77, $60, $04, $0c, $77, $40, $14, $0c, $77, $01
    db $13, $fd, $77, $20, $05, $fd, $77, $60, $05, $0b, $77, $40, $13, $0b, $77, $01
    db $12, $fe, $77, $20, $06, $0a, $77, $40, $06, $fe, $77, $60, $12, $0a, $77, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode0B_NameCardEdit_State10
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_6EE8_Mode0B_NameCardEdit_State10::
    db $14, $dc, $77, $20, $04, $dc, $77, $60, $04, $2c, $77, $40, $14, $2c, $77, $01
    db $13, $dd, $77, $20, $05, $dd, $77, $60, $05, $2b, $77, $40, $13, $2b, $77, $01
    db $12, $de, $77, $20, $06, $de, $77, $60, $06, $2a, $77, $40, $12, $2a, $77, $01
    db $14, $fe, $77, $20, $04, $fe, $77, $60, $04, $0a, $77, $40, $14, $0a, $77, $01
    db $13, $ff, $77, $20, $05, $ff, $77, $60, $05, $09, $77, $40, $13, $09, $77, $01
    db $12, $00, $77, $20, $06, $00, $77, $60, $06, $08, $77, $40, $12, $08, $77, $01
    db $08, $04, $75, $00, $10, $04, $76, $01, $0c, $04, $7e, $01, $eb, $08, $7b, $40
    db $eb, $00, $7a, $40, $f3, $08, $79, $40, $f3, $00, $78, $40, $2d, $08, $7b, $00
    db $2d, $00, $7a, $00, $25, $08, $79, $00, $25, $00, $78, $01, $ea, $08, $7b, $40
    db $ea, $00, $7a, $40, $f2, $08, $79, $40, $f2, $00, $78, $40, $2e, $08, $7b, $00
    db $2e, $00, $7a, $00, $26, $08, $79, $00, $26, $00, $78, $01, $e9, $08, $7b, $40
    db $e9, $00, $7a, $40, $f1, $08, $79, $40, $f1, $00, $78, $40, $2f, $08, $7b, $00
    db $2f, $00, $7a, $00, $27, $08, $79, $00, $27, $00, $78, $01

; I: leftover: 404 bytes (03:6FB4-7147) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_6FB4::
    INCBIN "data/bank_03/Leftover_03_6FB4.bin" ; $6FB4, 404 bytes
; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_7148_Mode02_TakePhotos_State01::
    db $18, $10, $8f, $00, $10, $10, $8e, $00, $08, $10, $8d, $00, $00, $10, $8c, $00
    db $18, $08, $8b, $00, $10, $08, $8a, $00, $08, $08, $89, $00, $00, $08, $88, $00
    db $18, $00, $87, $00, $10, $00, $86, $00, $08, $00, $85, $00, $00, $00, $84, $00
    db $18, $f8, $83, $00, $10, $f8, $82, $00, $08, $f8, $81, $00, $00, $f8, $80, $01

; I: leftover: 328 bytes (03:7188-72CF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_7188::
    INCBIN "data/bank_03/Leftover_03_7188.bin" ; $7188, 328 bytes
; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_72D0_Mode02_TakePhotos_State06::
    db $08, $14, $88, $00, $08, $0c, $86, $00, $08, $04, $84, $00, $08, $fc, $82, $00
    db $08, $f4, $80, $01

; I: leftover: 204 bytes (03:72E4-73AF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_72E4::
    db $08, $18, $8a, $00, $08, $10, $88, $00, $08, $08, $86, $00, $08, $00, $84, $00
    db $08, $f8, $82, $00, $08, $f0, $80, $01, $08, $1c, $8c, $00, $08, $14, $8a, $00
    db $08, $0c, $88, $00, $08, $04, $86, $00, $08, $fc, $84, $00, $08, $f4, $82, $00
    db $08, $ec, $80, $01, $08, $20, $8e, $00, $08, $18, $8c, $00, $08, $10, $8a, $00
    db $08, $08, $88, $00, $08, $00, $86, $00, $08, $f8, $84, $00, $08, $f0, $82, $00
    db $08, $e8, $80, $01, $10, $04, $82, $00, $00, $04, $80, $01, $10, $08, $86, $00
    db $00, $08, $84, $00, $10, $00, $82, $00, $00, $00, $80, $01, $10, $0c, $8a, $00
    db $00, $0c, $88, $00, $10, $04, $86, $00, $00, $04, $84, $00, $10, $fc, $82, $00
    db $00, $fc, $80, $01, $10, $10, $8e, $00, $00, $10, $8c, $00, $10, $08, $8a, $00
    db $00, $08, $88, $00, $10, $00, $86, $00, $00, $00, $84, $00, $10, $f8, $82, $00
    db $00, $f8, $80, $01, $08, $04, $90, $01, $08, $08, $92, $00, $08, $00, $90, $01
    db $08, $0c, $94, $00, $08, $04, $92, $00, $08, $fc, $90, $01, $08, $10, $96, $00
    db $08, $08, $94, $00, $08, $00, $92, $00, $08, $f8, $90, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_73B0_Mode02_TakePhotos_State06::
    db $08, $14, $98, $00, $08, $0c, $96, $00, $08, $04, $94, $00, $08, $fc, $92, $00
    db $08, $f4, $90, $01

; I: leftover: 84 bytes (03:73C4-7417) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_03_73C4::
    db $08, $18, $9a, $00, $08, $10, $98, $00, $08, $08, $96, $00, $08, $00, $94, $00
    db $08, $f8, $92, $00, $08, $f0, $90, $01, $08, $1c, $9c, $00, $08, $14, $9a, $00
    db $08, $0c, $98, $00, $08, $04, $96, $00, $08, $fc, $94, $00, $08, $f4, $92, $00
    db $08, $ec, $90, $01, $08, $20, $9e, $00, $08, $18, $9c, $00, $08, $10, $9a, $00
    db $08, $08, $98, $00, $08, $00, $96, $00, $08, $f8, $94, $00, $08, $f0, $92, $00
    db $08, $e8, $90, $01

; C: read in the runs by Obj_DrawSprite; first read on the screen Mode06_Printing_State0A
; (trace/read_screens_kitty*.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
OamList_03_7418_Mode06_Printing_State0A::
    db $08, $20, $6e, $00, $08, $18, $6c, $00, $08, $10, $6a, $00, $08, $08, $68, $00
    db $08, $00, $66, $00, $08, $f8, $64, $00, $08, $f0, $62, $00, $08, $e8, $60, $01
    db $08, $20, $ae, $00, $08, $18, $ac, $00, $08, $10, $aa, $00, $08, $08, $a8, $00
    db $08, $00, $a6, $00, $08, $f8, $a4, $00, $08, $f0, $a2, $00, $08, $e8, $a0, $01
    db $08, $24, $b0, $00, $08, $1c, $ae, $00, $08, $14, $ac, $00, $08, $0c, $aa, $00
    db $08, $04, $a8, $00, $08, $fc, $a6, $00, $08, $f4, $a4, $00, $08, $ec, $a2, $00
    db $08, $e4, $a0, $01, $08, $28, $72, $00, $08, $20, $70, $00, $08, $18, $6e, $00
    db $08, $10, $6c, $00, $08, $08, $6a, $00, $08, $00, $68, $00, $08, $f8, $66, $00
    db $08, $f0, $64, $00, $08, $e8, $62, $00, $08, $e0, $60, $01

    ; padding
    ds $b5c, $00

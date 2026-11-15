; Pocket Camera Hello Kitty (Japan), bank $02. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

; C: leftover: 8 bytes (02:4000-4007) an object script of the form of the next one (02:4008): two words, then the
; command $1F1E (ObjCmd_Jump) back to $4000, a loop; nothing points at it and no run reads it
Leftover_02_4000_ObjScript::
    db $10, $80, $1c, $46, $1e, $1f, $00, $40

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode0F_FifteenPuzzle_State0A
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4008_Mode0F_FifteenPuzzle_State0A::
    db $08, $80, $64, $46, $1e, $1f, $08, $40, $10, $80, $18, $41, $1e, $1f, $10, $40
    db $10, $80, $ac, $41, $1e, $1f, $18, $40, $10, $80, $40, $42, $1e, $1f, $20, $40
    db $10, $80, $d4, $42, $1e, $1f, $28, $40, $10, $80, $4c, $43, $1e, $1f, $30, $40
    db $10, $80, $c4, $43, $1e, $1f, $38, $40, $10, $80, $3c, $44, $1e, $1f, $40, $40
    db $10, $80, $b4, $44, $1e, $1f, $48, $40, $10, $80, $2c, $45, $1e, $1f, $50, $40
    db $10, $80, $a4, $45, $1e, $1f, $58, $40, $08, $80, $68, $46, $1e, $1f, $60, $40
    db $10, $80, $6c, $46, $1e, $1f, $68, $40, $10, $80, $00, $47, $1e, $1f, $70, $40
    db $10, $80, $94, $47, $1e, $1f, $78, $40, $10, $80, $28, $48, $10, $80, $30, $48
    db $10, $80, $38, $48, $10, $80, $40, $48, $1e, $1f, $80, $40, $10, $80, $48, $48
    db $10, $80, $4c, $48, $1e, $1f, $94, $40, $0a, $80, $e0, $48, $1e, $1f, $a0, $40
    db $10, $80, $50, $48, $1e, $1f, $a8, $40, $10, $80, $40, $49, $1e, $1f, $b0, $40
    db $10, $80, $68, $49, $1e, $1f, $b8, $40, $10, $80, $a8, $49, $1e, $1f, $c0, $40

; I: leftover: 72 bytes (02:40C8-410F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_40C8::
    db $0a, $80, $f0, $48, $1e, $1f, $c8, $40, $0a, $80, $f8, $48, $1e, $1f, $d0, $40
    db $0a, $80, $04, $49, $1e, $1f, $d8, $40, $0a, $80, $0c, $49, $1e, $1f, $e0, $40
    db $0a, $80, $18, $49, $1e, $1f, $e8, $40, $0a, $80, $24, $49, $1e, $1f, $f0, $40
    db $0a, $80, $2c, $49, $1e, $1f, $f8, $40, $0a, $80, $38, $49, $1e, $1f, $00, $41
    db $10, $80, $04, $4b, $1e, $1f, $08, $41

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4110_Mode00_BootAndTitle_State00::
    INCBIN "data/bank_02/ObjScript_02_4110_Mode00_BootAndTitle_State00.bin" ; $4110, 484 bytes
; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode01_MainMenu_State02
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_42F4_Mode01_MainMenu_State02::
    db $ff, $80, $d8, $50, $1e, $1f, $f4, $42

    db $08, $80, $c0, $50, $28, $80, $a0, $50, $08, $80, $c0, $50, $08, $80, $d8, $50
    db $1e, $1f, $fc, $42

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4310_Mode01_MainMenu_State05::
    db $ff, $80, $20, $51, $1e, $1f, $10, $43, $18, $80, $f0, $50, $18, $80, $08, $51
    db $18, $80, $20, $51, $1e, $1f, $18, $43, $17, $80, $38, $51, $17, $80, $4c, $51
    db $1e, $1f, $28, $43

; I: leftover: 36 bytes (02:4334-4357) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4334::
    db $05, $80, $60, $51, $04, $80, $70, $51, $03, $80, $80, $51, $01, $80, $90, $51
    db $03, $80, $a0, $51, $04, $80, $b0, $51, $1e, $1f, $34, $43, $10, $80, $c0, $51
    db $1e, $1f, $50, $43

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4358_Mode02_TakePhotos_State01::
    db $04, $80, $d0, $51, $04, $80, $dc, $51, $1e, $1f, $58, $43, $04, $80, $e8, $51
    db $04, $80, $f8, $51, $1e, $1f, $64, $43, $04, $80, $08, $52, $04, $80, $2c, $52
    db $1e, $1f, $70, $43, $70, $80, $50, $52, $06, $80, $68, $52

    db $03, $80, $80, $52, $20, $80, $98, $52, $06, $80, $80, $52, $06, $80, $68, $52
    db $1e, $1f, $7c, $43

; C: read in the runs by Object_RunAll; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4398_Mode02_TakePhotos_State01::
    db $12, $80, $50, $52, $0b, $80, $b0, $52, $0e, $80, $c8, $52, $1e, $1f, $98, $43
    db $b0, $80, $e0, $52

    db $08, $80, $00, $53, $05, $80, $e0, $52, $09, $80, $f0, $52, $1e, $1f, $a8, $43
    db $10, $80, $00, $53, $1e, $1f, $bc, $43

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode04_PlayMenu_State01
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_43C4_Mode04_PlayMenu_State01::
    INCBIN "data/bank_02/ObjScript_02_43C4_Mode04_PlayMenu_State01.bin" ; $43C4, 436 bytes
; I: leftover: 72 bytes (02:4578-45BF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4578::
    db $80, $80, $f0, $5b, $06, $80, $10, $5c, $05, $80, $34, $5c, $30, $80, $58, $5c
    db $07, $80, $7c, $5c, $07, $80, $58, $5c, $07, $80, $7c, $5c, $50, $80, $58, $5c
    db $1e, $1f, $78, $45, $80, $80, $9c, $5c, $06, $80, $bc, $5c, $05, $80, $dc, $5c
    db $30, $80, $fc, $5c, $07, $80, $1c, $5d, $07, $80, $fc, $5c, $07, $80, $1c, $5d
    db $50, $80, $fc, $5c, $1e, $1f, $9c, $45

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode06_Printing_State0D
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_45C0_Mode06_Printing_State0D::
    db $0f, $80, $3c, $5d, $0e, $80, $70, $5d, $1e, $1f, $c0, $45, $50, $80, $3c, $5d
    db $07, $80, $a4, $5d, $07, $80, $3c, $5d, $07, $80, $a4, $5d, $1e, $1f, $cc, $45

    db $08, $80, $34, $5e, $08, $80, $70, $5e, $08, $80, $cc, $5e, $08, $80, $d8, $5d
    db $1e, $1f, $e0, $45

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_45F4_Mode06_Printing_State1F::
    db $10, $80, $14, $5f, $10, $80, $78, $5f, $1e, $1f, $f4, $45, $10, $80, $78, $5f
    db $1e, $1f, $00, $46, $10, $80, $d4, $5f, $10, $80, $f4, $5f, $1e, $1f, $08, $46
    db $0c, $80, $14, $60, $0c, $80, $24, $60, $0c, $80, $34, $60, $0c, $80, $44, $60
    db $1e, $1f, $14, $46

; I: leftover: 44 bytes (02:4628-4653) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4628::
    db $06, $80, $54, $60, $06, $80, $58, $60, $05, $80, $54, $60, $05, $80, $58, $60
    db $04, $80, $54, $60, $04, $80, $58, $60, $03, $80, $5c, $60, $03, $80, $6c, $60
    db $03, $80, $7c, $60, $03, $80, $8c, $60, $1e, $1f, $28, $46

; C: read in the runs by Object_RunAll, ObjCmd_Jump
ObjScript_02_4654_Object_RunAll::
    db $10, $80, $9c, $60, $1e, $1f, $54, $46, $10, $80, $ac, $60, $1e, $1f, $5c, $46

    db $0c, $80, $bc, $60, $0c, $80, $c0, $60, $1e, $1f, $64, $46, $01, $80, $c4, $60
    db $01, $80, $c8, $60, $1e, $1f, $70, $46, $01, $80, $cc, $60, $01, $80, $d0, $60
    db $1e, $1f, $7c, $46, $01, $80, $d4, $60, $01, $80, $d8, $60, $1e, $1f, $88, $46
    db $01, $80, $dc, $60, $01, $80, $e0, $60, $1e, $1f, $94, $46

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode07_Exchange_State02
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_46A0_Mode07_Exchange_State02::
    db $10, $80, $e4, $60, $1e, $1f, $a0, $46, $10, $80, $f4, $60, $10, $80, $5c, $61
    db $1e, $1f, $a8, $46, $10, $80, $5c, $64, $1e, $1f, $b4, $46, $10, $80, $74, $64
    db $1e, $1f, $bc, $46, $10, $80, $8c, $64, $1e, $1f, $c4, $46, $10, $80, $9c, $64
    db $1e, $1f, $cc, $46, $10, $80, $b4, $64, $1e, $1f, $d4, $46, $10, $80, $cc, $64
    db $1e, $1f, $dc, $46, $07, $80, $dc, $64, $09, $80, $e4, $64, $0d, $80, $ec, $64
    db $10, $80, $f4, $64, $26, $80, $fc, $64, $10, $80, $f4, $64, $0d, $80, $ec, $64
    db $09, $80, $e4, $64, $07, $80, $dc, $64, $09, $80, $04, $65, $0d, $80, $0c, $65
    db $10, $80, $14, $65, $26, $80, $1c, $65, $10, $80, $14, $65, $0d, $80, $0c, $65
    db $09, $80, $04, $65, $1e, $1f, $e4, $46

; I: leftover: 164 bytes (02:4728-47CB) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4728::
    db $05, $80, $6c, $65, $07, $80, $b4, $65, $11, $80, $fc, $65, $07, $80, $b4, $65
    db $05, $80, $6c, $65, $1e, $1f, $28, $47, $05, $80, $40, $66, $07, $80, $88, $66
    db $11, $80, $d0, $66, $07, $80, $88, $66, $05, $80, $40, $66, $1e, $1f, $40, $47
    db $10, $80, $24, $65, $1e, $1f, $58, $47, $10, $80, $14, $67, $1e, $1f, $60, $47
    db $10, $80, $5c, $67, $1e, $1f, $68, $47, $10, $80, $a4, $67, $10, $80, $24, $65
    db $1e, $1f, $70, $47, $10, $80, $ec, $67, $1e, $1f, $7c, $47, $0c, $80, $5c, $68
    db $80, $80, $cc, $68, $1e, $1f, $84, $47, $05, $80, $6c, $69, $0a, $80, $cc, $69
    db $05, $80, $6c, $69, $0a, $80, $2c, $6a, $1e, $1f, $90, $47, $05, $80, $94, $6a
    db $0a, $80, $f4, $6a, $05, $80, $94, $6a, $0a, $80, $54, $6b, $1e, $1f, $a4, $47
    db $07, $80, $dc, $6b, $05, $80, $cc, $6b, $0a, $80, $bc, $6b, $06, $80, $cc, $6b
    db $1e, $1f, $b8, $47

; C: read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange); the rest of Data_02_46A0 after a leftover
; stretch
Src_02_47CC_Mode07_Exchange_State02::
    INCBIN "data/bank_02/Src_02_47CC_Mode07_Exchange_State02.bin" ; $47CC, 8 bytes
; I: leftover: 60 bytes (02:47D4-480F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_47D4::
    db $03, $80, $24, $6c, $05, $80, $ec, $6b, $03, $80, $24, $6c, $1e, $1f, $d4, $47
    db $03, $80, $24, $6c, $1e, $1f, $e4, $47, $0a, $80, $74, $6c, $0a, $80, $ac, $6c
    db $0a, $80, $74, $6c, $0a, $80, $ac, $6c, $0a, $80, $74, $6c, $0a, $80, $ac, $6c
    db $0a, $80, $74, $6c, $0a, $80, $ac, $6c, $1e, $1f, $ec, $47

; C: read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: exchange); the rest of Data_02_46A0 after a leftover
; stretch
Src_02_4810_Mode07_Exchange_State02::
    INCBIN "data/bank_02/Src_02_4810_Mode07_Exchange_State02.bin" ; $4810, 20 bytes
; I: leftover: 40 bytes (02:4824-484B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4824::
    db $03, $80, $84, $6d, $03, $80, $a4, $6d, $03, $80, $d4, $6d, $50, $80, $e4, $6c
    db $1e, $1f, $24, $48, $03, $80, $84, $6d, $03, $80, $a4, $6d, $03, $80, $d4, $6d
    db $50, $80, $34, $6d, $1e, $1f, $38, $48

; C: named by the code of AlbumText_ObjCursor (02:7816); read in the runs by Object_RunAll, ObjCmd_Jump; first read on
; the screen Mode0B_NameCardEdit_State10 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_484C_AlbumText_ObjCursor::
    db $23, $80, $14, $6e, $20, $80, $24, $6e, $1e, $1f, $4c, $48, $07, $80, $28, $6e
    db $05, $80, $38, $6e, $0a, $80, $48, $6e, $06, $80, $38, $6e, $1e, $1f, $58, $48
    db $07, $80, $58, $6e, $05, $80, $68, $6e, $0a, $80, $78, $6e, $06, $80, $68, $6e
    db $1e, $1f, $6c, $48, $07, $80, $88, $6e, $05, $80, $98, $6e, $0a, $80, $a8, $6e
    db $06, $80, $98, $6e, $1e, $1f, $80, $48

    db $07, $80, $b8, $6e, $05, $80, $c8, $6e, $0a, $80, $d8, $6e, $06, $80, $c8, $6e
    db $1e, $1f, $94, $48

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode0B_NameCardEdit_State10
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_48A8_Mode0B_NameCardEdit_State10::
    db $07, $80, $e8, $6e, $05, $80, $f8, $6e, $0a, $80, $08, $6f, $06, $80, $f8, $6e
    db $1e, $1f, $a8, $48, $07, $80, $18, $6f, $05, $80, $28, $6f, $0a, $80, $38, $6f
    db $06, $80, $28, $6f, $1e, $1f, $bc, $48, $16, $80, $48, $6f, $09, $80, $50, $6f
    db $1e, $1f, $d0, $48, $04, $80, $54, $6f, $03, $80, $74, $6f, $03, $80, $94, $6f
    db $1e, $1f, $dc, $48

; I: leftover: 96 bytes (02:48EC-494B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_48EC::
    db $10, $80, $b4, $6f, $1e, $1f, $ec, $48, $10, $80, $c8, $6f, $1e, $1f, $f4, $48
    db $10, $80, $d0, $6f, $1e, $1f, $fc, $48, $10, $80, $e0, $6f, $1e, $1f, $04, $49
    db $10, $80, $f8, $6f, $1e, $1f, $0c, $49, $10, $80, $18, $70, $1e, $1f, $14, $49
    db $10, $80, $40, $70, $1e, $1f, $1c, $49, $10, $80, $70, $70, $1e, $1f, $24, $49
    db $10, $80, $a8, $70, $1e, $1f, $2c, $49, $10, $80, $e8, $70, $1e, $1f, $34, $49
    db $10, $80, $f8, $70, $1e, $1f, $3c, $49, $10, $80, $18, $71, $1e, $1f, $44, $49

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_494C_Mode02_TakePhotos_State01::
    db $10, $80, $48, $71, $1e, $1f, $4c, $49

; I: leftover: 96 bytes (02:4954-49B3) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_4954::
    db $10, $80, $88, $71, $1e, $1f, $54, $49, $10, $80, $90, $71, $1e, $1f, $5c, $49
    db $10, $80, $a0, $71, $1e, $1f, $64, $49, $10, $80, $b8, $71, $1e, $1f, $6c, $49
    db $10, $80, $d8, $71, $1e, $1f, $74, $49, $10, $80, $00, $72, $1e, $1f, $7c, $49
    db $10, $80, $30, $72, $1e, $1f, $84, $49, $10, $80, $68, $72, $1e, $1f, $8c, $49
    db $10, $80, $a8, $72, $1e, $1f, $94, $49, $10, $80, $ac, $72, $1e, $1f, $9c, $49
    db $10, $80, $b4, $72, $1e, $1f, $a4, $49, $10, $80, $c0, $72, $1e, $1f, $ac, $49

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_49B4_Mode02_TakePhotos_State06::
    db $10, $80, $d0, $72, $1e, $1f, $b4, $49

; I: leftover: 88 bytes (02:49BC-4A13) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_49BC::
    db $10, $80, $e4, $72, $1e, $1f, $bc, $49, $10, $80, $fc, $72, $1e, $1f, $c4, $49
    db $10, $80, $18, $73, $1e, $1f, $cc, $49, $10, $80, $38, $73, $1e, $1f, $d4, $49
    db $10, $80, $40, $73, $1e, $1f, $dc, $49, $10, $80, $50, $73, $1e, $1f, $e4, $49
    db $10, $80, $68, $73, $1e, $1f, $ec, $49, $10, $80, $88, $73, $1e, $1f, $f4, $49
    db $10, $80, $8c, $73, $1e, $1f, $fc, $49, $10, $80, $94, $73, $1e, $1f, $04, $4a
    db $10, $80, $a0, $73, $1e, $1f, $0c, $4a

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4A14_Mode02_TakePhotos_State06::
    db $10, $80, $b0, $73, $1e, $1f, $14, $4a

    db $10, $80, $c4, $73, $1e, $1f, $1c, $4a, $10, $80, $dc, $73, $1e, $1f, $24, $4a
    db $10, $80, $f8, $73, $1e, $1f, $2c, $4a

; C: read in the runs by Object_RunAll, ObjCmd_Jump; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4A34_Mode02_TakePhotos_State06::
    db $10, $80, $18, $74, $1e, $1f, $34, $4a, $10, $80, $38, $74, $1e, $1f, $3c, $4a
    db $10, $80, $58, $74, $1e, $1f, $44, $4a, $10, $80, $7c, $74, $1e, $1f, $4c, $4a

; C: hFFD7 = hFFD4 (script command)
Obj_CopyD4ToD7::
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $4A54
    ldh [hObjCmd_Loop_FFD7], a                    ; $4A56
    scf                                           ; $4A58
    ret                                           ; $4A59


; C: hFFCD-hFFCE + $30: the next animation frame of the object
Obj_AdvanceFrame30::
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $4A5A
    ld l, a                                       ; $4A5C
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $4A5D
    ld h, a                                       ; $4A5F
    ld bc, $0030                                  ; $4A60
    add hl, bc                                    ; $4A63
    ld a, l                                       ; $4A64
    ldh [hCopyReqSrcDstCnt + $2], a               ; $4A65
    ld a, h                                       ; $4A67
    ldh [hCopyReqSrcDstCnt + $3], a               ; $4A68
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $4A6A
    ld b, a                                       ; $4A6C
    ldh a, [hObjCmd_Loop_FFD7]                    ; $4A6D
    cp b                                          ; $4A6F
    jr nc, jr_002_4a7e                            ; $4A70

    xor a                                         ; $4A72
    ldh [hCopyReqSrcDstCnt + $2], a               ; $4A73
    call Rng_Next                                 ; $4A75
    and $01                                       ; $4A78
    cpl                                           ; $4A7A
    inc a                                         ; $4A7B
    ldh [hCopyReqSrcDstCnt + $3], a               ; $4A7C

jr_002_4a7e:
    ret                                           ; $4A7E


; C: stores the key, takes {sound id, channel} at HL ($D8E6 ...) and posts the sound on channel 0-3, then waits 15
; frames (02:4ABB)
KeyPrompt_Accept::
    ldh [hScratch_CursorUpdate_FFD9], a           ; $4A7F
    ld [wKeysNew], a                              ; $4A81
    ld a, [hl+]                                   ; $4A84
    push af                                       ; $4A85
    ld a, [hl]                                    ; $4A86
    call JumpTable_Inline                         ; $4A87

; C: read in the runs by JumpTable_Inline; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz)
KeyPrompt_Accept_JumpTbl4A8A::
    dw KeyPrompt_SoundCh0
    dw KeyPrompt_SoundCh1
    dw KeyPrompt_SoundCh2
    dw KeyPrompt_SoundCh3

; C: channel 0 of KeyPrompt_Accept: sound into $D060
KeyPrompt_SoundCh0::
    pop af                                        ; $4A92
    ld [wSndSfx1], a                              ; $4A93
    jr jr_002_4aa8                                ; $4A96

; C: channel 1 of KeyPrompt_Accept: sound into $D068
KeyPrompt_SoundCh1::
    pop af                                        ; $4A98
    ld [wSndMusicReq], a                          ; $4A99
    jr jr_002_4aa8                                ; $4A9C

; C: channel 2 of KeyPrompt_Accept: sound into $D070
KeyPrompt_SoundCh2::
    pop af                                        ; $4A9E
    ld [wSndSfx3], a                              ; $4A9F
    jr jr_002_4aa8                                ; $4AA2

; C: channel 3 of KeyPrompt_Accept: sound into $D078
KeyPrompt_SoundCh3::
    pop af                                        ; $4AA4
    ld [wSndSfx4], a                              ; $4AA5

jr_002_4aa8:
    xor a                                         ; $4AA8
    ldh [hCopyReqSrcDstCnt], a                    ; $4AA9
    ldh [hCopyReqSrcDstCnt + $1], a               ; $4AAB
    ldh [hCopyReqSrcDstCnt + $2], a               ; $4AAD
    ldh [hCopyReqSrcDstCnt + $3], a               ; $4AAF
    ld a, $0f                                     ; $4AB1
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $4AB3
    ld de, KeyPrompt_Wait                         ; $4AB5
    jp Obj_SetCallback                            ; $4AB8


; C: hFFD8 - 1; at 0 the key into $D8DF and the object ends (00:2212)
KeyPrompt_Wait::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $4ABB
    dec [hl]                                      ; $4ABE
    jr nz, jr_002_4aca                            ; $4ABF

    ldh a, [hScratch_CursorUpdate_FFD9]           ; $4AC1
    ld [wMode06_State0A_D8DF], a                  ; $4AC3
    call Obj_End                                  ; $4AC6
    ret                                           ; $4AC9


jr_002_4aca:
    ldh a, [hFrameCounter]                        ; $4ACA
    and $04                                       ; $4ACC
    jr nz, jr_002_4ad3                            ; $4ACE

    jp Obj_HideSprite                             ; $4AD0


jr_002_4ad3:
    ld a, $01                                     ; $4AD3
    ldh [hObject_RunAll_FFC9], a                  ; $4AD5
    xor a                                         ; $4AD7
    ldh [hObject_RunAll_FFCA], a                  ; $4AD8
    ret                                           ; $4ADA


; C: key check of a button prompt: A accepts with the sound of $D8E6, B ends
KeyPrompt_Keys4ADB::
    ld a, [wKeysNew]                              ; $4ADB
    bit PADB_A, a                                 ; $4ADE
    ld a, $01                                     ; $4AE0
    ld hl, wKeyPrompt_Keys4ADB_D8E6               ; $4AE2
    jr nz, KeyPrompt_Accept                       ; $4AE5

    ld a, [wKeysNew]                              ; $4AE7
    and PADF_B                                    ; $4AEA
    jp nz, Obj_End                                ; $4AEC

    ret                                           ; $4AEF


; C: key check of a button prompt: B accepts with the sound of $D8E8, A ends
KeyPrompt_Keys4AF0::
    ld a, [wKeysNew]                              ; $4AF0
    and PADF_A                                    ; $4AF3
    jp nz, Obj_End                                ; $4AF5

    ld a, [wKeysNew]                              ; $4AF8
    bit PADB_B, a                                 ; $4AFB
    ld a, $02                                     ; $4AFD
    ld hl, wKeyPrompt_Keys4AF0_D8E8               ; $4AFF
    jp nz, KeyPrompt_Accept                       ; $4B02

    ret                                           ; $4B05


; C: key check of a button prompt: A accepts ($D8E6), B or Start end
KeyPrompt_Keys4B06::
    ld a, [wKeysNew]                              ; $4B06
    bit PADB_A, a                                 ; $4B09
    ld a, $01                                     ; $4B0B
    ld hl, wKeyPrompt_Keys4ADB_D8E6               ; $4B0D
    jp nz, KeyPrompt_Accept                       ; $4B10

    ld a, [wKeysNew]                              ; $4B13
    and PADF_B | PADF_START                       ; $4B16
    jp nz, Obj_End                                ; $4B18

    ret                                           ; $4B1B


; C: key check of a button prompt: B accepts ($D8E8), A or Start end
KeyPrompt_Keys4B1C::
    ld a, [wKeysNew]                              ; $4B1C
    and PADF_A                                    ; $4B1F
    jp nz, Obj_End                                ; $4B21

    ld a, [wKeysNew]                              ; $4B24
    bit PADB_B, a                                 ; $4B27
    ld a, $02                                     ; $4B29
    ld hl, wKeyPrompt_Keys4AF0_D8E8               ; $4B2B
    jp nz, KeyPrompt_Accept                       ; $4B2E

    ld a, [wKeysNew]                              ; $4B31
    and PADF_START                                ; $4B34
    jp nz, Obj_End                                ; $4B36

    ret                                           ; $4B39


; C: key check of a button prompt: Start accepts ($D8EA), A or B end
KeyPrompt_Keys4B3A::
    ld a, [wKeysNew]                              ; $4B3A
    and PADF_A | PADF_B                           ; $4B3D
    jp nz, Obj_End                                ; $4B3F

    ld a, [wKeysNew]                              ; $4B42
    bit PADB_START, a                             ; $4B45
    ld a, $08                                     ; $4B47
    ld hl, wKeyPrompt_Keys4B3A_D8EA               ; $4B49
    jp nz, KeyPrompt_Accept                       ; $4B4C

    ret                                           ; $4B4F


; C: key check of a button prompt: A, B or Start end
KeyPrompt_Keys4B50::
    ld a, [wKeysNew]                              ; $4B50
    and PADF_A | PADF_B | PADF_START              ; $4B53
    jp nz, Obj_End                                ; $4B55

    ret                                           ; $4B58


; C: key check of a button prompt: A or B end
KeyPrompt_Keys4B59::
    ld a, [wKeysNew]                              ; $4B59
    and PADF_A | PADF_B                           ; $4B5C
    jp nz, Obj_End                                ; $4B5E

    ret                                           ; $4B61


; C: sets the object callback to 02:4B68 (00:2225)
KeyPrompt_StartA::
    ld de, KeyPrompt_TickA                        ; $4B62
    jp Obj_SetCallback                            ; $4B65


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickA::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4B68
    bit 0, a                                      ; $4B6B
    jp nz, Obj_End                                ; $4B6D

    call Obj_AdvanceFrame30                       ; $4B70
    call KeyPrompt_Keys4ADB                       ; $4B73
    ret                                           ; $4B76


; C: sets the object callback to 02:4B7D (00:2225)
KeyPrompt_StartB::
    ld de, KeyPrompt_TickB                        ; $4B77
    jp Obj_SetCallback                            ; $4B7A


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickB::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4B7D
    bit 0, a                                      ; $4B80
    jp nz, Obj_End                                ; $4B82

    call Obj_AdvanceFrame30                       ; $4B85
    call KeyPrompt_Keys4AF0                       ; $4B88
    ret                                           ; $4B8B


; C: sets the object callback to 02:4B92 (00:2225)
KeyPrompt_StartC::
    ld de, KeyPrompt_TickC                        ; $4B8C
    jp Obj_SetCallback                            ; $4B8F


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickC::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4B92
    bit 0, a                                      ; $4B95
    jp nz, Obj_End                                ; $4B97

    call Obj_AdvanceFrame30                       ; $4B9A
    call KeyPrompt_Keys4B06                       ; $4B9D
    ret                                           ; $4BA0


; C: sets the object callback to 02:4BA7 (00:2225)
KeyPrompt_StartD::
    ld de, KeyPrompt_TickD                        ; $4BA1
    jp Obj_SetCallback                            ; $4BA4


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickD::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4BA7
    bit 0, a                                      ; $4BAA
    jp nz, Obj_End                                ; $4BAC

    call Obj_AdvanceFrame30                       ; $4BAF
    call KeyPrompt_Keys4B1C                       ; $4BB2
    ret                                           ; $4BB5


; C: sets the object callback to 02:4BBC (00:2225)
KeyPrompt_StartE::
    ld de, KeyPrompt_TickE                        ; $4BB6
    jp Obj_SetCallback                            ; $4BB9


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickE::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4BBC
    bit 0, a                                      ; $4BBF
    jp nz, Obj_End                                ; $4BC1

    call Obj_AdvanceFrame30                       ; $4BC4
    call KeyPrompt_Keys4B3A                       ; $4BC7
    ret                                           ; $4BCA


; C: sets the object callback to 02:4BD1 (00:2225)
KeyPrompt_StartF::
    ld de, KeyPrompt_TickF                        ; $4BCB
    jp Obj_SetCallback                            ; $4BCE


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickF::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4BD1
    bit 0, a                                      ; $4BD4
    jp nz, Obj_End                                ; $4BD6

    call Obj_AdvanceFrame30                       ; $4BD9
    call KeyPrompt_Keys4B50                       ; $4BDC
    ret                                           ; $4BDF


; C: sets the object callback to 02:4BE6 (00:2225)
KeyPrompt_StartG::
    ld de, KeyPrompt_TickG                        ; $4BE0
    jp Obj_SetCallback                            ; $4BE3


; C: button prompt frame: ends when $D8E1 bit 0 is set, next animation frame, then its key check
KeyPrompt_TickG::
    ld a, [wKeyPrompt_TickA_D8E1]                 ; $4BE6
    bit 0, a                                      ; $4BE9
    jp nz, Obj_End                                ; $4BEB

    call Obj_AdvanceFrame30                       ; $4BEE
    call KeyPrompt_Keys4B59                       ; $4BF1
    ret                                           ; $4BF4


; C: Photo_DrawNumber with [$D932] + 1 (script callback)
Obj_DrawPhotoCountPlus1::
    push hl                                       ; $4BF5
    ld a, [wAlbum_SlotOp6D18_D932]                ; $4BF6
    inc a                                         ; $4BF9
    ld b, BANK(Photo_DrawNumber)                  ; $4BFA
    ld hl, Photo_DrawNumber                       ; $4BFC
    call Far_CallKeepA                            ; $4BFF
    pop hl                                        ; $4C02
    scf                                           ; $4C03
    ret                                           ; $4C04


; C: Photo_DrawNumber with [$D932] (script callback)
Obj_DrawPhotoCount::
    push hl                                       ; $4C05
    ld a, [wAlbum_SlotOp6D18_D932]                ; $4C06
    ld b, BANK(Photo_DrawNumber)                  ; $4C09
    ld hl, Photo_DrawNumber                       ; $4C0B
    call Far_CallKeepA                            ; $4C0E
    pop hl                                        ; $4C11
    scf                                           ; $4C12
    ret                                           ; $4C13


; C: Photo_DrawNumber with [$D933] (script callback)
Obj_DrawPhotoIndex::
    push hl                                       ; $4C14
    ld a, [wMode03_State02_D933]                  ; $4C15
    ld b, BANK(Photo_DrawNumber)                  ; $4C18
    ld hl, Photo_DrawNumber                       ; $4C1A
    call Far_CallKeepA                            ; $4C1D
    pop hl                                        ; $4C20
    scf                                           ; $4C21
    ret                                           ; $4C22


    db $e5, $fa, $fb, $d9, $06, $05, $21, $5c, $6e, $cd, $65, $01, $e1, $37, $c9, $e5
    db $fa, $fb, $d9, $06, $05, $21, $a0, $6e, $cd, $65, $01, $e1, $37, $c9, $e5, $3e
    db $01, $06, $05, $21, $5c, $6e, $cd, $65, $01, $e1, $37, $c9

; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_Jump; first read on the screen
; Mode02_TakePhotos_State06 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4C4F_Mode02_TakePhotos_State06::
    db $54, $4a, $1e, $1f, $70, $45, $4f, $4c, $e0, $4b, $05, $4c, $4f, $4c, $e0, $4b
    db $14, $4c, $4f, $4c, $e0, $4b, $14, $4c, $4f, $4c, $e0, $4b, $41, $4c, $4f, $4c
    db $cb, $4b, $05, $4c, $4f, $4c, $cb, $4b, $f5, $4b, $4f, $4c, $e0, $4b, $23, $4c
    db $4f, $4c, $e0, $4b, $32, $4c, $54, $4a, $1e, $1f, $b4, $49, $54, $4a, $1e, $1f
    db $14, $4a, $54, $4a, $1e, $1f, $34, $4a, $54, $4a, $1e, $1f, $3c, $4a, $54, $4a
    db $1e, $1f, $44, $4a, $54, $4a, $1e, $1f, $4c, $4a, $85, $4c, $62, $4b, $b9, $7f
    db $8b, $4c, $77, $4b, $b9, $7f, $85, $4c, $8c, $4b, $b9, $7f, $8b, $4c, $a1, $4b
    db $b9, $7f, $91, $4c, $b6, $4b, $b9, $7f, $a3, $4c, $b6, $4b, $b9, $7f, $85, $4c
    db $8c, $4b, $b9, $7f, $8b, $4c, $a1, $4b, $b9, $7f, $9d, $4c, $e0, $4b, $b9, $7f
    db $97, $4c, $e0, $4b, $b9, $7f, $85, $4c, $62, $4b, $b9, $7f, $8b, $4c, $77, $4b
    db $b9, $7f

    db $85, $4c, $62, $4b, $b9, $7f, $8b, $4c, $77, $4b, $b9, $7f

; C: menu cursor object of the Play menu: D-pad through the 8-byte item records (table 02:5AB7), A copies the target
; mode and state into hFF95-hFF96 and sets $D8E0 = 1
PlayMenu_CursorUpdate::
    ld a, [wFadeRunning]                          ; $4CFD
    and a                                         ; $4D00
    jr nz, jr_002_4d24                            ; $4D01

    ld a, [wKeysNewRepeat]                        ; $4D03
    ld de, $0002                                  ; $4D06
    bit 5, a                                      ; $4D09
    jr nz, jr_002_4d44                            ; $4D0B

    inc e                                         ; $4D0D
    bit 4, a                                      ; $4D0E
    jr nz, jr_002_4d44                            ; $4D10

    inc e                                         ; $4D12
    bit 6, a                                      ; $4D13
    jr nz, jr_002_4d44                            ; $4D15

    inc e                                         ; $4D17
    bit 7, a                                      ; $4D18
    jr nz, jr_002_4d44                            ; $4D1A

    inc e                                         ; $4D1C
    ld a, [wKeysNew]                              ; $4D1D
    bit PADB_A, a                                 ; $4D20
    jr nz, jr_002_4d83                            ; $4D22

jr_002_4d24:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4D24
    ld c, a                                       ; $4D26
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4D27
    ld b, a                                       ; $4D29
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4D2A
    ld l, a                                       ; $4D2D
    ld h, $00                                     ; $4D2E
    sla l                                         ; $4D30
    rl h                                          ; $4D32
    sla l                                         ; $4D34
    rl h                                          ; $4D36
    sla l                                         ; $4D38
    rl h                                          ; $4D3A
    add hl, bc                                    ; $4D3C
    ld a, [hl+]                                   ; $4D3D
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $4D3E
    ld a, [hl+]                                   ; $4D40
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4D41
    ret                                           ; $4D43


jr_002_4d44:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4D44
    ld c, a                                       ; $4D46
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4D47
    ld b, a                                       ; $4D49
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4D4A
    ld l, a                                       ; $4D4D
    ld h, $00                                     ; $4D4E
    sla l                                         ; $4D50
    rl h                                          ; $4D52
    sla l                                         ; $4D54
    rl h                                          ; $4D56
    sla l                                         ; $4D58
    rl h                                          ; $4D5A
    add hl, bc                                    ; $4D5C
    add hl, de                                    ; $4D5D
    ld a, [hl]                                    ; $4D5E
    cp $ff                                        ; $4D5F
    jr z, jr_002_4d82                             ; $4D61

    ld [wMenu07_CursorUpdate_D8F4], a             ; $4D63
    ld l, a                                       ; $4D66
    ld h, $00                                     ; $4D67
    sla l                                         ; $4D69
    rl h                                          ; $4D6B
    sla l                                         ; $4D6D
    rl h                                          ; $4D6F
    sla l                                         ; $4D71
    rl h                                          ; $4D73
    add hl, bc                                    ; $4D75
    ld a, [hl+]                                   ; $4D76
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $4D77
    ld a, [hl+]                                   ; $4D79
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4D7A
    ld hl, wObjCmd_SetDC61                        ; $4D7C
    call Obj_Sound                                ; $4D7F

jr_002_4d82:
    ret                                           ; $4D82


jr_002_4d83:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4D83
    ld c, a                                       ; $4D85
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4D86
    ld b, a                                       ; $4D88
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4D89
    ld l, a                                       ; $4D8C
    ld h, $00                                     ; $4D8D
    sla l                                         ; $4D8F
    rl h                                          ; $4D91
    sla l                                         ; $4D93
    rl h                                          ; $4D95
    sla l                                         ; $4D97
    rl h                                          ; $4D99
    add hl, bc                                    ; $4D9B
    add hl, de                                    ; $4D9C
    ld a, [hl+]                                   ; $4D9D
    ldh [hMenuMode], a                            ; $4D9E
    ld a, [hl+]                                   ; $4DA0
    ldh [hMenuState], a                           ; $4DA1
    ld a, $01                                     ; $4DA3
    ld [wMode06_State21_D8E0], a                  ; $4DA5
    call Obj_ClearCallback                        ; $4DA8
    ld hl, wObjCmd_SetDC63                        ; $4DAB
    call Obj_Sound                                ; $4DAE
    ret                                           ; $4DB1


; C: $D8E0 = 0
Obj_ClearD8E0::
    xor a                                         ; $4DB2
    ld [wMode06_State21_D8E0], a                  ; $4DB3
    ret                                           ; $4DB6


; C: read in the runs by PlayMenu_CursorUpdate, Object_RunAll, ObjCmd_Wait; first read on the screen
; Mode01_MainMenu_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4DB7_Mode01_MainMenu_State02::
    db $28, $1b, $ff, $ff, $02, $01, $02, $00, $28, $43, $ff, $ff, $00, $02, $03, $00
    db $28, $6b, $ff, $ff, $01, $00, $04, $00, $10, $1f, $10, $00, $16, $1f, $eb, $4d
    db $e4, $1e, $16, $00, $ee, $1e, $05, $00, $3a, $1f, $16, $2b, $65, $1f, $b7, $4d
    db $1e, $1f, $ba, $7f

; C: 02:5BED then PlayMenu_CursorUpdate (a menu cursor that Start ends); runs on its screen (01:02) in the core
; replays (port/entry_modes_kitty.csv); code read
MainMenu_CursorTick::
    call Menu_EndOnStart                          ; $4DEB
    call PlayMenu_CursorUpdate                    ; $4DEE
    ret                                           ; $4DF1


; C: named by the code of Mode01_State00 (05:4591); read in the runs by PlayMenu_CursorUpdate, Object_RunAll,
; Object_CreateWithParam; first read on the screen Mode01_MainMenu_State05 (trace/read_screens_kitty.npz); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4DF2_Mode01_MainMenu_State00::
    db $d7, $4d, $eb, $4d, $b2, $4d, $cf, $4d, $b9, $7f, $b2, $4d, $30, $2e, $ff, $ff
    db $02, $01, $0a, $00, $30, $46, $ff, $ff, $00, $02, $0c, $00, $30, $5e, $ff, $ff
    db $01, $00, $07, $00, $3a, $1f, $c0, $b0, $10, $1f, $10, $00, $16, $1f, $32, $4e
    db $e4, $1e, $07, $00, $ee, $1e, $05, $00, $65, $1f, $fe, $4d, $1e, $1f, $28, $43

; C: 02:5BFE then PlayMenu_CursorUpdate (a menu cursor that B ends); runs on its screen (01:05) in the core replays
; (port/entry_modes_kitty.csv); code read
MainMenu_CursorTickB::
    call Menu_EndOnB                              ; $4E32
    call PlayMenu_CursorUpdate                    ; $4E35
    ret                                           ; $4E38


; C: named by the code of Mode01_State03 (05:4716); read in the runs by Object_CreateWithParam; first read on the
; screen Mode01_MainMenu_State05 (trace/read_screens_kitty.npz)
ObjScript_02_4E39_Mode01_MainMenu_State03::
    db $22, $4e, $32, $4e, $b2, $4d, $16, $4e, $b9, $7f, $b2, $4d

; C: menu cursor like PlayMenu_CursorUpdate, ignored while Start is held; runs in the album (mode $03 state $02)
Album_CursorUpdate::
    ld a, [wFadeRunning]                          ; $4E45
    and a                                         ; $4E48
    jr nz, jr_002_4e73                            ; $4E49

    ld a, [wKeysHeld]                             ; $4E4B
    bit PADB_START, a                             ; $4E4E
    jr nz, jr_002_4e73                            ; $4E50

    ld a, [wKeysNewRepeat]                        ; $4E52
    ld de, $0002                                  ; $4E55
    bit 5, a                                      ; $4E58
    jr nz, jr_002_4e93                            ; $4E5A

    inc e                                         ; $4E5C
    bit 4, a                                      ; $4E5D
    jr nz, jr_002_4e93                            ; $4E5F

    inc e                                         ; $4E61
    bit 6, a                                      ; $4E62
    jr nz, jr_002_4e93                            ; $4E64

    inc e                                         ; $4E66
    bit 7, a                                      ; $4E67
    jr nz, jr_002_4e93                            ; $4E69

    inc e                                         ; $4E6B
    ld a, [wKeysNew]                              ; $4E6C
    bit PADB_A, a                                 ; $4E6F
    jr nz, jr_002_4eda                            ; $4E71

jr_002_4e73:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4E73
    ld c, a                                       ; $4E75
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4E76
    ld b, a                                       ; $4E78
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4E79
    ld l, a                                       ; $4E7C
    ld h, $00                                     ; $4E7D
    sla l                                         ; $4E7F
    rl h                                          ; $4E81
    sla l                                         ; $4E83
    rl h                                          ; $4E85
    sla l                                         ; $4E87
    rl h                                          ; $4E89
    add hl, bc                                    ; $4E8B
    ld a, [hl+]                                   ; $4E8C
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $4E8D
    ld a, [hl+]                                   ; $4E8F
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4E90
    ret                                           ; $4E92


jr_002_4e93:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4E93
    ld c, a                                       ; $4E95
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4E96
    ld b, a                                       ; $4E98
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4E99
    ld l, a                                       ; $4E9C
    ld h, $00                                     ; $4E9D
    sla l                                         ; $4E9F
    rl h                                          ; $4EA1
    sla l                                         ; $4EA3
    rl h                                          ; $4EA5
    sla l                                         ; $4EA7
    rl h                                          ; $4EA9
    add hl, bc                                    ; $4EAB
    add hl, de                                    ; $4EAC
    ld a, [hl]                                    ; $4EAD
    cp $ff                                        ; $4EAE
    jr z, jr_002_4ed1                             ; $4EB0

    ld [wMenu07_CursorUpdate_D8F4], a             ; $4EB2
    ld l, a                                       ; $4EB5
    ld h, $00                                     ; $4EB6
    sla l                                         ; $4EB8
    rl h                                          ; $4EBA
    sla l                                         ; $4EBC
    rl h                                          ; $4EBE
    sla l                                         ; $4EC0
    rl h                                          ; $4EC2
    add hl, bc                                    ; $4EC4
    ld a, [hl+]                                   ; $4EC5
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $4EC6
    ld a, [hl+]                                   ; $4EC8
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4EC9
    ld hl, wObjCmd_SetDC61                        ; $4ECB
    call Obj_Sound                                ; $4ECE

jr_002_4ed1:
    ret                                           ; $4ED1


jr_002_4ed2:
    push af                                       ; $4ED2
    ld a, SFX1_3C                                 ; $4ED3
    ld [wSndSfx1], a                              ; $4ED5
    pop af                                        ; $4ED8
    ret                                           ; $4ED9


jr_002_4eda:
    ld a, [wMode03_State02_D933]                  ; $4EDA
    and a                                         ; $4EDD
    jr z, jr_002_4ed2                             ; $4EDE

    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $4EE0
    ld c, a                                       ; $4EE2
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $4EE3
    ld b, a                                       ; $4EE5
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4EE6
    ld l, a                                       ; $4EE9
    ld h, $00                                     ; $4EEA
    sla l                                         ; $4EEC
    rl h                                          ; $4EEE
    sla l                                         ; $4EF0
    rl h                                          ; $4EF2
    sla l                                         ; $4EF4
    rl h                                          ; $4EF6
    add hl, bc                                    ; $4EF8
    add hl, de                                    ; $4EF9
    ld a, [hl+]                                   ; $4EFA
    ldh [hMenuMode], a                            ; $4EFB
    ld a, [hl+]                                   ; $4EFD
    ldh [hMenuState], a                           ; $4EFE
    ld a, $01                                     ; $4F00
    ld [wFadeRunning], a                          ; $4F02
    call Obj_ClearCallback                        ; $4F05
    ld de, ObjScript_02_4F99_Album_CursorUpdate   ; $4F08
    call Call_000_2205                            ; $4F0B
    ld hl, wObjCmd_SetDC63                        ; $4F0E
    call Obj_Sound                                ; $4F11
    ret                                           ; $4F14


; C: read in the runs by Album_CursorUpdate, Object_RunAll, ObjCmd_SetDC61; first read on the screen
; Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4F15_Mode03_ViewAlbum_State02::
    db $7a, $0b, $ff, $ff, $05, $01, $03, $04, $7a, $23, $ff, $ff, $00, $02, $05, $00
    db $7a, $3b, $ff, $ff, $01, $03, $06, $00, $7a, $53, $ff, $ff, $02, $04, $03, $06
    db $7a, $6b, $ff, $ff, $03, $05, $03, $0c, $7a, $83, $ff, $ff, $04, $00, $03, $10
    db $e4, $1e, $03, $00, $ee, $1e, $08, $00, $3a, $1f, $70, $0b, $65, $1f, $15, $4f
    db $1e, $1f, $44, $44

; C: the 4-byte record [$D8F4] of 02:4F7A: $C0 bytes of tiles from bank $0D into VRAM (the graphic of the selected
; item; script callback); runs in the album (mode $03)
Album_MenuItemGfx::
    push hl                                       ; $4F59
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4F5A
    sla a                                         ; $4F5D
    sla a                                         ; $4F5F
    ld c, a                                       ; $4F61
    ld b, $00                                     ; $4F62
    ld hl, Album_MenuItemGfx_Tbl4F7A              ; $4F64
    add hl, bc                                    ; $4F67
    ld a, [hl+]                                   ; $4F68
    ld e, a                                       ; $4F69
    ld a, [hl+]                                   ; $4F6A
    ld d, a                                       ; $4F6B
    ld a, [hl+]                                   ; $4F6C
    ld h, [hl]                                    ; $4F6D
    ld l, a                                       ; $4F6E
    ld a, $0d                                     ; $4F6F
    ld bc, $00c0                                  ; $4F71
    call Vram_CopyHBlankFar                       ; $4F74
    pop hl                                        ; $4F77
    scf                                           ; $4F78
    ret                                           ; $4F79


; C: named by the code of Album_MenuItemGfx (02:4F64); read in the runs by Album_MenuItemGfx; first read on the screen
; Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz)
Album_MenuItemGfx_Tbl4F7A::
    dw Gfx_0D_4600_Mode03_ViewAlbum_State02
    db $80, $93
    dw Gfx_0D_4700_Album_LoadTilesBank0D
    db $40, $94
    dw Gfx_0D_4800_Album_LoadTilesBank0D
    db $00, $95
    dw Gfx_0D_4900_Album_LoadTilesBank0D
    db $c0, $84
    dw Gfx_0D_4A00_Album_LoadTilesBank0D
    db $80, $85
    dw Gfx_0D_4B00_Album_LoadTilesBank0D
    db $40, $86

; C: $D8E0 = 1 (script callback)
Obj_SetD8E0One::
    ld a, $01                                     ; $4F92
    ld [wMode06_State21_D8E0], a                  ; $4F94
    scf                                           ; $4F97
    ret                                           ; $4F98


; C: named by the code of Album_CursorUpdate (02:4F08); read in the runs by ObjCmd_CopyAtLine20, Object_RunAll,
; Object_CreateWithParam; first read on the screen Mode11_StrawberryChannel_State02 (trace/read_screens_kitty.npz);
; kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_4F99_Album_CursorUpdate::
    db $59, $4f, $08, $80, $d0, $53, $10, $80, $b8, $53, $92, $4f, $02, $1f, $45, $4f
    db $45, $4e, $b2, $4d, $cc, $1f, $04, $00, $b0, $65, $a0, $8f, $10, $00, $25, $cc
    db $1f, $04, $00, $c0, $65, $a0, $8f, $10, $00, $25, $cc, $1f, $04, $00, $d0, $65
    db $a0, $8f, $10, $00, $25, $1e, $1f, $ad, $4f, $ad, $4f, $b9, $7f, $b9, $7f

; C: hFFD2 = the x of channel [$D92A] (02:4FEB): the dot under the channel; runs on its screen (11:02) in the core
; replays (port/entry_modes_kitty.csv); code read
StrawberryCh_DotPosition::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $4FD8
    sla a                                         ; $4FDB
    ld c, a                                       ; $4FDD
    ld b, $00                                     ; $4FDE
    ld hl, StrawberryCh_DotPosition_Tbl4FEB       ; $4FE0
    add hl, bc                                    ; $4FE3
    ld a, [hl+]                                   ; $4FE4
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $4FE5
    ld a, [hl+]                                   ; $4FE7
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $4FE8
    ret                                           ; $4FEA


; C: named by the code of StrawberryCh_DotPosition (02:4FE0); read in the runs by StrawberryCh_DotPosition; first read
; on the screen Mode11_StrawberryChannel_State04 (trace/read_screens_kitty.npz)
StrawberryCh_DotPosition_Tbl4FEB::
    db $2c, $88, $38, $88, $44, $88, $50, $88, $5c, $88, $68, $88, $74, $88

; C: StrawberryCh_DotPosition; hidden ($C0) while $D92C is set; runs on its screen (11:02) in the core replays
; (port/entry_modes_kitty.csv); code read
StrawberryCh_DotTick::
    call StrawberryCh_DotPosition                 ; $4FF9
    ld a, [wStrawberryCh_DotTick_D92C]            ; $4FFC
    and a                                         ; $4FFF
    ret z                                         ; $5000

    ld a, $c0                                     ; $5001
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5003
    ld de, StrawberryCh_DotHidden                 ; $5005
    jp Obj_SetCallback                            ; $5008


; C: waits for $D92C = 0, then back to 02:4FF9; runs on its screen (11:09) in the core replays
; (port/entry_modes_kitty.csv); code read
StrawberryCh_DotHidden::
    ld a, [wStrawberryCh_DotTick_D92C]            ; $500B
    and a                                         ; $500E
    ret nz                                        ; $500F

    ld de, StrawberryCh_DotTick                   ; $5010
    jp Obj_SetCallback                            ; $5013


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode11_StrawberryChannel_State00
; (trace/read_screens_kitty.npz)
ObjScript_02_5016_Mode11_StrawberryChannel_State00::
    db $94, $41, $f9, $4f, $b9, $7f

; C: hFFD8 - 1 ends it; a key ($D8D9 & $33) ends it early; runs on its screen (11:04 11:07) in the core replays
; (port/entry_modes_kitty.csv); code read
StrawberryCh_HintTick::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $501C
    dec [hl]                                      ; $501F
    jp z, Obj_End                                 ; $5020

    ld a, [wKeysNew]                              ; $5023
    and PADF_A | PADF_B | PADF_RIGHT | PADF_LEFT  ; $5026
    ret z                                         ; $5028

    call Obj_End                                  ; $5029
    ld de, $7fc0                                  ; $502C
    jp Jump_000_2205                              ; $502F


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_JumpByByte; first read on the screen
; Mode11_StrawberryChannel_State04 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_5032_Mode11_StrawberryChannel_State04::
    db $3a, $1f, $28, $31, $16, $1f, $1c, $50, $75, $1f, $78, $09, $20, $2a, $d9, $64
    db $41, $6c, $41, $74, $41, $7c, $41, $84, $41, $8c, $41, $ac, $41, $32, $50, $23
    db $50, $b9, $7f, $3a, $1f, $28, $31, $16, $1f, $1c, $50, $75, $1f, $78, $1e, $1f
    db $a0, $41, $55, $50, $23, $50, $b9, $7f, $80, $40, $b9, $7f, $b9, $7f

; C: hFFD2 = byte [$D97C] of 02:507E
Puzzle15_ObjFrameByD97C::
    ld a, [wScript_SetD97C]                       ; $5070
    ld c, a                                       ; $5073
    ld b, $00                                     ; $5074
    ld hl, Puzzle15_ObjFrameByD97C + $E           ; $5076
    add hl, bc                                    ; $5079
    ld a, [hl]                                    ; $507A
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $507B
    ret                                           ; $507D


    db $c0, $18, $20, $28, $30, $38, $40, $48, $50, $58, $60, $68

; C: read in the runs by Object_CreateWithParam, Puzzle15_ObjFrameByD97C, Object_RunAll; first read on the screen
; Mode0F_FifteenPuzzle_State0A (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_508A_Mode0F_FifteenPuzzle_State0A::
    db $70, $78, $80, $88, $90, $1e, $1f, $94, $40, $8f, $50, $70, $50, $b9, $7f

; C: waits for $D975 bit 0, then 02:50AB; runs on its screen (0F:0A 0F:0B) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_ObjWaitMove::
    ld a, [wPuzzle15_ObjWaitMove_D975]            ; $5099
    bit 0, a                                      ; $509C
    ret z                                         ; $509E

    ld de, Puzzle15_ObjMoving                     ; $509F
    call Obj_SetCallback                          ; $50A2
    ld de, ObjScript_02_7FBA_Puzzle15_ObjWaitMove ; $50A5
    jp Jump_000_2205                              ; $50A8


; C: while $D975 bit 0 is clear counts hFFD8 down, then back to 02:5099; runs on its screen (0F:0A 0F:0B) in the core
; replays (port/entry_modes_kitty.csv); code read
Puzzle15_ObjMoving::
    ld a, [wPuzzle15_ObjWaitMove_D975]            ; $50AB
    bit 0, a                                      ; $50AE
    jr nz, jr_002_50c3                            ; $50B0

    ld hl, hPuzzle15_ObjMoving_FFD8               ; $50B2
    dec [hl]                                      ; $50B5
    ret nz                                        ; $50B6

    ld de, Puzzle15_ObjWaitMove                   ; $50B7
    call Obj_SetCallback                          ; $50BA
    ld de, $40a8                                  ; $50BD
    jp Jump_000_2205                              ; $50C0


jr_002_50c3:
    ld a, $14                                     ; $50C3
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $50C5
    ret                                           ; $50C7


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0F_FifteenPuzzle_State0A
; (trace/read_screens_kitty.npz)
ObjScript_02_50C8_Mode0F_FifteenPuzzle_State0A::
    db $a8, $40, $99, $50, $b9, $7f

; C: ends when $D8E0 bit 2 is set; animates on hFF9D bit 3; runs on its screen (0F:05) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_ObjTick::
    ld a, [wMode06_State21_D8E0]                  ; $50CE
    bit 2, a                                      ; $50D1
    jp nz, Obj_End                                ; $50D3

    ld a, [wFadeRunning]                          ; $50D6
    and a                                         ; $50D9
    ret nz                                        ; $50DA

    ldh a, [hFrameCounter]                        ; $50DB
    and $08                                       ; $50DD
    jr nz, jr_002_50eb                            ; $50DF

    ld b, BANK(Puzzle15_PosRecord)                ; $50E1
    ld hl, Puzzle15_PosRecord                     ; $50E3
    call Far_Call                                 ; $50E6
    jr jr_002_50f0                                ; $50E9

jr_002_50eb:
    xor a                                         ; $50EB
    ldh [hCopyReqSrcDstCnt + $4], a               ; $50EC
    ldh [hObject_RunAll_FFD0], a                  ; $50EE

jr_002_50f0:
    ld a, [wKeysNew]                              ; $50F0
    bit PADB_LEFT, a                              ; $50F3
    jp nz, Jump_002_5115                          ; $50F5

    bit PADB_RIGHT, a                             ; $50F8
    jp nz, Jump_002_5138                          ; $50FA

    bit PADB_UP, a                                ; $50FD
    jp nz, Jump_002_515a                          ; $50FF

    bit PADB_DOWN, a                              ; $5102
    jp nz, Jump_002_517d                          ; $5104

    bit PADB_B, a                                 ; $5107
    jp nz, Jump_002_510d                          ; $5109

    ret                                           ; $510C


Jump_002_510d:
    ld a, $02                                     ; $510D
    ld [wMode06_State21_D8E0], a                  ; $510F
    jp Obj_End                                    ; $5112


Jump_002_5115:
    ld a, [wPuzzleEmptyX]                         ; $5115
    cp $03                                        ; $5118
    ret z                                         ; $511A

    ld b, BANK(Puzzle15_SavePos)                  ; $511B
    ld hl, Puzzle15_SavePos                       ; $511D
    call Far_Call                                 ; $5120
    ld hl, wPuzzleEmptyX                          ; $5123
    inc [hl]                                      ; $5126
    ld b, BANK(Puzzle15_CursorToCell)             ; $5127
    ld hl, Puzzle15_CursorToCell                  ; $5129
    call Far_Call                                 ; $512C
    ld de, ObjScript_02_521E_Puzzle15_ObjTick     ; $512F
    call Call_000_2205                            ; $5132
    jp Jump_002_519c                              ; $5135


Jump_002_5138:
    ld a, [wPuzzleEmptyX]                         ; $5138
    and a                                         ; $513B
    ret z                                         ; $513C

    ld b, BANK(Puzzle15_SavePos)                  ; $513D
    ld hl, Puzzle15_SavePos                       ; $513F
    call Far_Call                                 ; $5142
    ld hl, wPuzzleEmptyX                          ; $5145
    dec [hl]                                      ; $5148
    ld b, BANK(Puzzle15_CursorToCell)             ; $5149
    ld hl, Puzzle15_CursorToCell                  ; $514B
    call Far_Call                                 ; $514E
    ld de, ObjScript_02_5239_Puzzle15_ObjTick     ; $5151
    call Call_000_2205                            ; $5154
    jp Jump_002_519c                              ; $5157


Jump_002_515a:
    ld a, [wPuzzleEmptyY]                         ; $515A
    cp $03                                        ; $515D
    ret z                                         ; $515F

    ld b, BANK(Puzzle15_SavePos)                  ; $5160
    ld hl, Puzzle15_SavePos                       ; $5162
    call Far_Call                                 ; $5165
    ld hl, wPuzzleEmptyY                          ; $5168
    inc [hl]                                      ; $516B
    ld b, BANK(Puzzle15_CursorToCell)             ; $516C
    ld hl, Puzzle15_CursorToCell                  ; $516E
    call Far_Call                                 ; $5171
    ld de, ObjScript_02_5254_Puzzle15_ObjTick     ; $5174
    call Call_000_2205                            ; $5177
    jp Jump_002_519c                              ; $517A


Jump_002_517d:
    ld a, [wPuzzleEmptyY]                         ; $517D
    and a                                         ; $5180
    ret z                                         ; $5181

    ld b, BANK(Puzzle15_SavePos)                  ; $5182
    ld hl, Puzzle15_SavePos                       ; $5184
    call Far_Call                                 ; $5187
    ld hl, wPuzzleEmptyY                          ; $518A
    dec [hl]                                      ; $518D
    ld b, BANK(Puzzle15_CursorToCell)             ; $518E
    ld hl, Puzzle15_CursorToCell                  ; $5190
    call Far_Call                                 ; $5193
    ld de, ObjScript_02_526F_Puzzle15_ObjTick     ; $5196
    call Call_000_2205                            ; $5199

Jump_002_519c:
    ldh a, [hState]                               ; $519C
    cp $05                                        ; $519E
    jr z, jr_002_51a9                             ; $51A0

    push af                                       ; $51A2
    ld a, SFX1_16                                 ; $51A3
    ld [wSndSfx1], a                              ; $51A5
    pop af                                        ; $51A8

jr_002_51a9:
    ret                                           ; $51A9


; C: compares the object position with Puzzle15_ScreenPosPrev (script callback); runs on its screen (0F:05) in the
; core replays (port/entry_modes_kitty.csv); code read
Puzzle15_ObjArrived::
    ld b, BANK(Puzzle15_ScreenPosPrev)            ; $51AA
    ld hl, Puzzle15_ScreenPosPrev                 ; $51AC
    call Far_Call                                 ; $51AF
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $51B2
    cp c                                          ; $51B4
    ret nz                                        ; $51B5

    inc hl                                        ; $51B6
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $51B7
    cp b                                          ; $51B9
    ret nz                                        ; $51BA

    ld de, $50b8                                  ; $51BB
    ld b, BANK(ScriptSlots_Add)                   ; $51BE
    ld hl, ScriptSlots_Add                        ; $51C0
    call Far_Call                                 ; $51C3
    ld b, BANK(Puzzle15_CellAddr)                 ; $51C6
    ld hl, Puzzle15_CellAddr                      ; $51C8
    call Far_Call                                 ; $51CB
    push hl                                       ; $51CE
    ld b, BANK(Puzzle15_CellAddrPrev)             ; $51CF
    ld hl, Puzzle15_CellAddrPrev                  ; $51D1
    call Far_Call                                 ; $51D4
    pop de                                        ; $51D7
    ld c, [hl]                                    ; $51D8
    ld a, [de]                                    ; $51D9
    ld [hl], a                                    ; $51DA
    ld a, c                                       ; $51DB
    ld [de], a                                    ; $51DC
    xor a                                         ; $51DD
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $51DE
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $51E0
    ldh [hCopyReqSrcDstCnt + $4], a               ; $51E2
    ldh [hObject_RunAll_FFD0], a                  ; $51E4
    ld de, ObjScript_02_51EC_Puzzle15_ObjArrived  ; $51E6
    jp Jump_000_2205                              ; $51E9


; C: named by the code of Puzzle15_ObjArrived (02:51E6); read in the runs by Object_RunAll, ObjCmd_SetCallback,
; ObjCmd_SetSpeed; first read on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM from
; the evidence of tools/kitty_layout_kinds.py
ObjScript_02_51EC_Puzzle15_ObjArrived::
    db $16, $1f, $ce, $50, $6d, $1f, $00, $00, $7f, $1f, $00, $00, $fc, $51, $09, $1f

; C: $D975 bit 0 cleared, Puzzle15_CursorToCell (script callback)
Puzzle15_ObjToCell::
    push hl                                       ; $51FC
    ld hl, wPuzzle15_ObjWaitMove_D975             ; $51FD
    res 0, [hl]                                   ; $5200
    ld b, BANK(Puzzle15_CursorToCell)             ; $5202
    ld hl, Puzzle15_CursorToCell                  ; $5204
    call Far_Call                                 ; $5207
    pop hl                                        ; $520A
    scf                                           ; $520B
    ret                                           ; $520C


; C: $D975 bit 0 set, Puzzle15_DrawCell (script callback)
Puzzle15_ObjDrawCell::
    push hl                                       ; $520D
    ld hl, wPuzzle15_ObjWaitMove_D975             ; $520E
    set 0, [hl]                                   ; $5211
    ld b, BANK(Puzzle15_DrawCell)                 ; $5213
    ld hl, Puzzle15_DrawCell                      ; $5215
    call Far_Call                                 ; $5218
    pop hl                                        ; $521B
    scf                                           ; $521C
    ret                                           ; $521D


; C: named by the code of Puzzle15_ObjTick (02:512F); read in the runs by Object_RunAll, ObjCmd_StartSlotScript,
; ObjCmd_SetCallback; first read on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_521E_Puzzle15_ObjTick::
    db $0d, $52, $4a, $20, $74, $50, $16, $1f, $aa, $51, $32, $52, $7f, $1f, $00, $00
    db $1e, $1f, $b8, $40

; C: hFFCC = $D978 (script callback)
Puzzle15_ObjSetCC_D978::
    ld a, [wPuzzle15_ObjSetCC_D978]               ; $5232
    ldh [hCopyReqSrcDstCnt + $1], a               ; $5235
    scf                                           ; $5237
    ret                                           ; $5238


; C: named by the code of Puzzle15_ObjTick (02:5151); read in the runs by Object_RunAll, ObjCmd_StartSlotScript,
; ObjCmd_SetCallback; first read on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5239_Puzzle15_ObjTick::
    db $0d, $52, $4a, $20, $74, $50, $16, $1f, $aa, $51, $4d, $52, $7f, $1f, $00, $00
    db $1e, $1f, $b8, $40

; C: hFFCC = $D977 (script callback)
Puzzle15_ObjSetCC_D977::
    ld a, [wPuzzle15_ObjSetCC_D977]               ; $524D
    ldh [hCopyReqSrcDstCnt + $1], a               ; $5250
    scf                                           ; $5252
    ret                                           ; $5253


; C: named by the code of Puzzle15_ObjTick (02:5174); read in the runs by Object_RunAll, ObjCmd_StartSlotScript,
; ObjCmd_SetCallback; first read on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5254_Puzzle15_ObjTick::
    db $0d, $52, $4a, $20, $74, $50, $16, $1f, $aa, $51, $6d, $1f, $00, $00, $68, $52
    db $1e, $1f, $b8, $40

; C: hFFCE = $D978 (script callback)
Puzzle15_ObjSetCE_D978::
    ld a, [wPuzzle15_ObjSetCC_D978]               ; $5268
    ldh [hCopyReqSrcDstCnt + $3], a               ; $526B
    scf                                           ; $526D
    ret                                           ; $526E


; C: named by the code of Puzzle15_ObjTick (02:5196); read in the runs by Object_RunAll, ObjCmd_StartSlotScript,
; ObjCmd_SetCallback; first read on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM
; from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_526F_Puzzle15_ObjTick::
    db $0d, $52, $4a, $20, $74, $50, $16, $1f, $aa, $51, $6d, $1f, $00, $00, $83, $52
    db $1e, $1f, $b8, $40

; C: hFFCE = $D977 (script callback)
Puzzle15_ObjSetCE_D977::
    ld a, [wPuzzle15_ObjSetCC_D977]               ; $5283
    ldh [hCopyReqSrcDstCnt + $3], a               ; $5286
    scf                                           ; $5288
    ret                                           ; $5289


; C: ret
Puzzle15_ObjRet528A::
    ret                                           ; $528A


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty.npz)
ObjScript_02_528B_Mode0F_FifteenPuzzle_State05::
    db $ec, $51, $b9, $7f, $8a, $52

; C: every 8 frames sound $02 on channel 0 and the next shuffle move; runs on its screen (0F:05) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_ShuffleTick::
    ldh a, [hFrameCounter]                        ; $5291
    and $07                                       ; $5293
    jr nz, jr_002_529e                            ; $5295

    push af                                       ; $5297
    ld a, SFX1_02                                 ; $5298
    ld [wSndSfx1], a                              ; $529A
    pop af                                        ; $529D

jr_002_529e:
    xor a                                         ; $529E
    ld [wKeysNew], a                              ; $529F
    ld [wKeysHeld], a                             ; $52A2
    ret                                           ; $52A5


; C: read in the runs by Object_RunAll, ObjCmd_Wait, ObjCmd_Jump; first read on the screen
; Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_52A6_Mode0F_FifteenPuzzle_State05::
    db $10, $1f, $3c, $00, $e7, $52, $10, $1f, $3c, $00, $16, $1f, $91, $52, $25, $1f
    db $0f, $f6, $52, $10, $1f, $02, $00, $2a, $1f, $b7, $52, $25, $1f, $32, $04, $53
    db $10, $1f, $02, $00, $2a, $1f, $c4, $52, $25, $1f, $32, $04, $53, $10, $1f, $02
    db $00, $2a, $1f, $d1, $52, $16, $1f, $9e, $52, $10, $1f, $3c, $00, $74, $53, $02
    db $1f

; C: ScriptSlots_Add with the script 02:5074 (script callback)
Puzzle15_ShuffleStartScript::
    push hl                                       ; $52E7
    ld de, $5074                                  ; $52E8
    ld b, BANK(ScriptSlots_Add)                   ; $52EB
    ld hl, ScriptSlots_Add                        ; $52ED
    call Far_Call                                 ; $52F0
    pop hl                                        ; $52F3
    scf                                           ; $52F4
    ret                                           ; $52F5


; C: Puzzle15_ScriptedKey with hFFD8 (script callback)
Puzzle15_ShuffleScriptedKey::
    push hl                                       ; $52F6
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $52F7
    ld b, BANK(Puzzle15_ScriptedKey)              ; $52F9
    ld hl, Puzzle15_ScriptedKey                   ; $52FB
    call Far_CallKeepA                            ; $52FE
    pop hl                                        ; $5301
    scf                                           ; $5302
    ret                                           ; $5303


; C: a random direction (Rng_Next & 3) other than the last one ($D976) into $D8D9
Puzzle15_ShuffleRandomDir::
    push hl                                       ; $5304

jr_002_5305:
    call Rng_Next                                 ; $5305
    and $03                                       ; $5308
    call JumpTable_Inline                         ; $530A

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty.npz)
Puzzle15_ShuffleRandomDir_JumpTbl530D::
    dw Puzzle15_ShuffleDirUp
    dw Puzzle15_ShuffleDirDown
    dw Puzzle15_ShuffleDirLeft
    dw Puzzle15_ShuffleDirRight

; C: direction $40 of 02:5304
Puzzle15_ShuffleDirUp::
    ld a, $40                                     ; $5315
    jr jr_002_5323                                ; $5317

; C: direction $80 of 02:5304
Puzzle15_ShuffleDirDown::
    ld a, $80                                     ; $5319
    jr jr_002_5323                                ; $531B

; C: direction $20 of 02:5304
Puzzle15_ShuffleDirLeft::
    ld a, $20                                     ; $531D
    jr jr_002_5323                                ; $531F

; C: direction $10 of 02:5304
Puzzle15_ShuffleDirRight::
    ld a, $10                                     ; $5321

jr_002_5323:
    ld hl, wPuzzle15_ShuffleCheckDir_D976         ; $5323
    cp [hl]                                       ; $5326
    jr z, jr_002_5305                             ; $5327

    ld [wKeysNew], a                              ; $5329
    call Puzzle15_ShuffleCheckDir                 ; $532C
    jr z, jr_002_5305                             ; $532F

    pop hl                                        ; $5331
    scf                                           ; $5332
    ret                                           ; $5333


; C: tests whether the direction in A can move the empty cell; runs on its screen (0F:05) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_ShuffleCheckDir::
    bit 5, a                                      ; $5334
    jr nz, jr_002_5346                            ; $5336

    bit 4, a                                      ; $5338
    jr nz, jr_002_5352                            ; $533A

    bit 6, a                                      ; $533C
    jr nz, jr_002_535d                            ; $533E

    bit 7, a                                      ; $5340
    jr nz, jr_002_5369                            ; $5342

    xor a                                         ; $5344
    ret                                           ; $5345


jr_002_5346:
    ld a, [wPuzzleEmptyX]                         ; $5346
    cp $03                                        ; $5349
    ret z                                         ; $534B

    ld a, $10                                     ; $534C
    ld [wPuzzle15_ShuffleCheckDir_D976], a        ; $534E
    ret                                           ; $5351


jr_002_5352:
    ld a, [wPuzzleEmptyX]                         ; $5352
    and a                                         ; $5355
    ret z                                         ; $5356

    ld a, $20                                     ; $5357
    ld [wPuzzle15_ShuffleCheckDir_D976], a        ; $5359
    ret                                           ; $535C


jr_002_535d:
    ld a, [wPuzzleEmptyY]                         ; $535D
    cp $03                                        ; $5360
    ret z                                         ; $5362

    ld a, $80                                     ; $5363
    ld [wPuzzle15_ShuffleCheckDir_D976], a        ; $5365
    ret                                           ; $5368


jr_002_5369:
    ld a, [wPuzzleEmptyY]                         ; $5369
    and a                                         ; $536C
    ret z                                         ; $536D

    ld a, $40                                     ; $536E
    ld [wPuzzle15_ShuffleCheckDir_D976], a        ; $5370
    ret                                           ; $5373


; C: $D8E0 = 4 (script callback)
Obj_SetD8E0Four::
    ld a, $04                                     ; $5374
    ld [wMode06_State21_D8E0], a                  ; $5376
    scf                                           ; $5379
    ret                                           ; $537A


; C: hFFD8 = Rng_Next & 3, $D979 = 0
Puzzle15_ShuffleInit::
    call Rng_Next                                 ; $537B
    and $03                                       ; $537E
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5380
    xor a                                         ; $5382
    ld [wPuzzle15_ScriptedKey_D979], a            ; $5383
    ret                                           ; $5386


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty.npz)
ObjScript_02_5387_Mode0F_FifteenPuzzle_State05::
    db $a6, $52, $9e, $52, $7b, $53

; C: when hFFD2 reaches $CA: $D8E0 = 1 and the object stops
Puzzle15_ObjEndAtCA::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $538D
    cp $ca                                        ; $538F
    ret nz                                        ; $5391

    ld a, $01                                     ; $5392
    ld [wMode06_State21_D8E0], a                  ; $5394
    xor a                                         ; $5397
    ldh [hCopyReqSrcDstCnt], a                    ; $5398
    ldh [hCopyReqSrcDstCnt + $1], a               ; $539A
    jp Obj_End                                    ; $539C


; C: read in the runs by Object_RunAll, ObjCmd_SetSpeed, Object_CreateWithParam; first read on the screen
; Mode0F_FifteenPuzzle_State07 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_539F_Mode0F_FifteenPuzzle_State07::
    db $6d, $1f, $00, $fe, $38, $80, $40, $49, $6d, $1f, $00, $00, $10, $1f, $3c, $00
    db $6d, $1f, $00, $fe, $1e, $1f, $b0, $40, $9f, $53, $8d, $53, $b2, $4d, $6d, $1f
    db $00, $fe, $38, $80, $a8, $49, $6d, $1f, $00, $00, $10, $1f, $3c, $00, $6d, $1f
    db $00, $fe, $1e, $1f, $c0, $40, $bd, $53, $8d, $53, $b2, $4d

; C: menu cursor like PlayMenu_CursorUpdate (another menu); runs on the scratch card (mode $10 state $02)
Scratch_CursorUpdate::
    ld a, [wFadeRunning]                          ; $53DB
    and a                                         ; $53DE
    jr nz, jr_002_5408                            ; $53DF

    ld a, [wKeysNewRepeat]                        ; $53E1
    ld de, $0002                                  ; $53E4
    bit 5, a                                      ; $53E7
    jr nz, jr_002_542c                            ; $53E9

    inc e                                         ; $53EB
    bit 4, a                                      ; $53EC
    jr nz, jr_002_542c                            ; $53EE

    inc e                                         ; $53F0
    bit 6, a                                      ; $53F1
    jr nz, jr_002_542c                            ; $53F3

    inc e                                         ; $53F5
    bit 7, a                                      ; $53F6
    jr nz, jr_002_542c                            ; $53F8

    inc e                                         ; $53FA
    ld a, [wKeysNew]                              ; $53FB
    bit PADB_A, a                                 ; $53FE
    jp nz, Jump_002_5480                          ; $5400

    bit PADB_B, a                                 ; $5403
    jp nz, Jump_002_54db                          ; $5405

jr_002_5408:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $5408
    ld c, a                                       ; $540A
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $540B
    ld b, a                                       ; $540D
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $540E
    ld l, a                                       ; $5411
    ld h, $00                                     ; $5412
    sla l                                         ; $5414
    rl h                                          ; $5416
    sla l                                         ; $5418
    rl h                                          ; $541A
    sla l                                         ; $541C
    rl h                                          ; $541E
    add hl, bc                                    ; $5420
    ld a, [hl+]                                   ; $5421
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5422
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5424
    ld a, [hl+]                                   ; $5426
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5427
    ldh [hScratch_CursorUpdate_FFD9], a           ; $5429
    ret                                           ; $542B


jr_002_542c:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $542C
    ld c, a                                       ; $542E
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $542F
    ld b, a                                       ; $5431
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5432
    ld l, a                                       ; $5435
    ld h, $00                                     ; $5436
    sla l                                         ; $5438
    rl h                                          ; $543A
    sla l                                         ; $543C
    rl h                                          ; $543E
    sla l                                         ; $5440
    rl h                                          ; $5442
    add hl, bc                                    ; $5444
    add hl, de                                    ; $5445
    ld a, [hl]                                    ; $5446
    cp $ff                                        ; $5447
    jr z, jr_002_547f                             ; $5449

    ld [wMenu07_CursorUpdate_D8F4], a             ; $544B
    ld l, a                                       ; $544E
    ld h, $00                                     ; $544F
    sla l                                         ; $5451
    rl h                                          ; $5453
    sla l                                         ; $5455
    rl h                                          ; $5457
    sla l                                         ; $5459
    rl h                                          ; $545B
    add hl, bc                                    ; $545D
    ld a, [hl+]                                   ; $545E
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $545F
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5461
    ld a, [hl+]                                   ; $5463
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5464
    ldh [hScratch_CursorUpdate_FFD9], a           ; $5466
    inc hl                                        ; $5468
    inc hl                                        ; $5469
    inc hl                                        ; $546A
    inc hl                                        ; $546B
    ld c, [hl]                                    ; $546C
    ld b, $00                                     ; $546D
    ld hl, ObjScript_02_54E3_Scratch_CursorUpdate ; $546F
    add hl, bc                                    ; $5472
    ld e, [hl]                                    ; $5473
    inc hl                                        ; $5474
    ld d, [hl]                                    ; $5475
    call Call_000_2205                            ; $5476
    ld hl, wObjCmd_SetDC61                        ; $5479
    call Obj_Sound                                ; $547C

jr_002_547f:
    ret                                           ; $547F


Jump_002_5480:
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5480
    ld c, a                                       ; $5483
    ld b, $00                                     ; $5484
    ld hl, wScratch_CursorUpdate_D952             ; $5486
    add hl, bc                                    ; $5489
    bit 7, [hl]                                   ; $548A
    jr nz, jr_002_54da                            ; $548C

    set 7, [hl]                                   ; $548E
    ld a, [hl]                                    ; $5490
    and $0f                                       ; $5491
    ld [wScratch_CursorUpdate_D95F], a            ; $5493
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $5496
    ld c, a                                       ; $5498
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $5499
    ld b, a                                       ; $549B
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $549C
    ld l, a                                       ; $549F
    ld h, $00                                     ; $54A0
    sla l                                         ; $54A2
    rl h                                          ; $54A4
    sla l                                         ; $54A6
    rl h                                          ; $54A8
    sla l                                         ; $54AA
    rl h                                          ; $54AC
    add hl, bc                                    ; $54AE
    add hl, de                                    ; $54AF
    ld a, [hl+]                                   ; $54B0
    ldh [hMenuMode], a                            ; $54B1
    ld a, [hl+]                                   ; $54B3
    ldh [hMenuState], a                           ; $54B4
    ld a, $01                                     ; $54B6
    ld [wMode06_State21_D8E0], a                  ; $54B8
    ld de, $5052                                  ; $54BB
    ld b, BANK(ScriptSlots_Add)                   ; $54BE
    ld hl, ScriptSlots_Add                        ; $54C0
    call Far_Call                                 ; $54C3
    call Obj_ClearCallback                        ; $54C6
    ld de, $553d                                  ; $54C9
    call Call_000_2205                            ; $54CC
    ld hl, wObjCmd_SetDC63                        ; $54CF
    call Obj_Sound                                ; $54D2
    ld hl, wScratch_CursorUpdate_D95E             ; $54D5
    inc [hl]                                      ; $54D8
    ret                                           ; $54D9


jr_002_54da:
    ret                                           ; $54DA


Jump_002_54db:
    ld a, $02                                     ; $54DB
    ld [wMode06_State21_D8E0], a                  ; $54DD
    jp Obj_End                                    ; $54E0


; C: named by the code of Scratch_CursorUpdate (02:546F); read in the runs by Object_RunAll, ObjCmd_Wait,
; ObjCmd_SetPosRel; first read on the screen Mode10_ScratchCard_State02 (trace/read_screens_kitty.npz); kind OAM from
; the evidence of tools/kitty_layout_kinds.py
ObjScript_02_54E3_Scratch_CursorUpdate::
    INCBIN "data/bank_02/ObjScript_02_54E3_Scratch_CursorUpdate.bin" ; $54E3, 352 bytes
; C: $D8E0 = 4 (script callback)
Obj_SetD8E0Four_B::
    ld a, $04                                     ; $5643
    ld [wMode06_State21_D8E0], a                  ; $5645
    scf                                           ; $5648
    ret                                           ; $5649


; C: position from the record at [$DC5E] - 8; runs on its screen (10:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Scratch_ObjPlace::
    ld a, [wObject_RunAll_DC5E]                   ; $564A
    ld l, a                                       ; $564D
    ld a, [wObject_RunAll_DC5F]                   ; $564E
    ld h, a                                       ; $5651
    ld bc, hScratch_ObjPlace_FFF8                 ; $5652
    add hl, bc                                    ; $5655
    ld a, [hl+]                                   ; $5656
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5657
    inc hl                                        ; $5659
    ld a, [hl+]                                   ; $565A
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $565B
    ret                                           ; $565D


; C: named by the code of Scratch_ObjTick (02:5676); read in the runs by Object_RunAll, ObjCmd_Jump; first read on the
; screen Mode10_ScratchCard_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_565E_Scratch_ObjTick::
    db $1e, $1f, $10, $41

; C: waits for $D8E0 bit 0, then a $6C-frame countdown (02:567C); runs on its screen (10:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Scratch_ObjTick::
    ld a, [wMode06_State21_D8E0]                  ; $5662
    bit 0, a                                      ; $5665
    jr nz, jr_002_566c                            ; $5667

    jp Scratch_ObjPlace                           ; $5669


jr_002_566c:
    ld a, $6c                                     ; $566C
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $566E
    ld de, Scratch_ObjCountdown                   ; $5670
    call Obj_SetCallback                          ; $5673
    ld de, ObjScript_02_565E_Scratch_ObjTick      ; $5676
    jp Jump_000_2205                              ; $5679


; C: hFFD8 - 1; at 0 $D8E0 = 0 and back to 02:5662; runs on its screen (10:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Scratch_ObjCountdown::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $567C
    dec [hl]                                      ; $567F
    ret nz                                        ; $5680

    xor a                                         ; $5681
    ld [wMode06_State21_D8E0], a                  ; $5682
    ld de, Scratch_ObjTick                        ; $5685
    call Obj_SetCallback                          ; $5688
    ld de, ObjScript_02_7FBA_Puzzle15_ObjWaitMove ; $568B
    jp Jump_000_2205                              ; $568E


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_Jump; first read on the screen
; Mode10_ScratchCard_State03 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5691_Mode10_ScratchCard_State03::
    db $ba, $7f, $62, $56, $b2, $4d, $75, $1f, $78, $1e, $1f, $50, $41

; C: hFFD8 - 1; at 0 $D8E0 = 8; runs on its screen (10:03) in the core replays (port/entry_modes_kitty.csv); code read
Scratch_ObjEndCountdown::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $569E
    dec [hl]                                      ; $56A1
    ret nz                                        ; $56A2

    ld a, $08                                     ; $56A3
    ld [wMode06_State21_D8E0], a                  ; $56A5
    ret                                           ; $56A8


; C: read in the runs by Object_CreateWithParam, ObjCmd_CopyAtLine20, Object_RunAll; first read on the screen
; Mode10_ScratchCard_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_56A9_Mode10_ScratchCard_State02::
    db $97, $56, $9e, $56, $b2, $4d, $75, $1f, $78, $1e, $1f, $5c, $41, $af, $56, $9e
    db $56, $b2, $4d, $cc, $1f, $08, $00, $00, $7c, $00, $99, $34, $00, $13, $cc, $1f
    db $08, $00, $40, $7d, $00, $99, $34, $00, $13, $1e, $1f, $bc, $56, $bc, $56, $b9
    db $7f, $b9, $7f

; I: leftover: 51 bytes (02:56DC-570E) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_56DC::
    db $cc, $1f, $08, $00, $30, $c2, $d0, $95, $e0, $01, $00, $cc, $1f, $08, $00, $60
    db $c4, $d0, $95, $e0, $01, $00, $cc, $1f, $08, $00, $90, $c6, $d0, $95, $e0, $01
    db $00, $1e, $1f, $dc, $56, $c9, $dc, $56, $01, $57, $b9, $7f, $c9, $00, $40, $08
    db $57, $b9, $7f

; C: blinks on hFF9D bit 3 ($C0 = hidden); runs on its screen (0E:05) in the core replays
; (port/entry_modes_kitty.csv); code read
KittHost_ObjBlink::
    ldh a, [hFrameCounter]                        ; $570F
    and $08                                       ; $5711
    jr z, jr_002_5719                             ; $5713

    ld a, $c0                                     ; $5715
    jr jr_002_571b                                ; $5717

jr_002_5719:
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $5719

jr_002_571b:
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $571B
    ld a, [wKeysNew]                              ; $571D
    and PADF_A | PADF_B                           ; $5720
    jp nz, Obj_End                                ; $5722

    ret                                           ; $5725


; C: read in the runs by Object_RunAll, ObjCmd_SetCallback, ObjCmd_Jump; first read on the screen
; Mode0E_KittGamesHost_State05 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_5726_Mode0E_KittGamesHost_State05::
    db $30, $57, $16, $1f, $0f, $57, $1e, $1f, $08, $40

; C: hFFD8 = hFFD2 (script callback)
KittHost_ObjSaveD2::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $5730
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5732
    scf                                           ; $5734
    ret                                           ; $5735


; C: named by the code of Mode0E_State15, Mode0E_State1D (07:6AD6 07:6B94); read in the runs by
; Object_CreateWithParam; first read on the screen Mode0E_KittGamesHost_State05 (trace/read_screens_kitty.npz)
ObjScript_02_5736_Mode0E_KittGamesHost_State15::
    db $26, $57, $b9, $7f, $b9, $7f

; C: hFFD8 - 1; at 0 $D8E0 = 1 and the object ends
KittHost_ObjCountdown::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $573C
    dec [hl]                                      ; $573F
    ret nz                                        ; $5740

    ld a, $01                                     ; $5741
    ld [wMode06_State21_D8E0], a                  ; $5743
    jp Obj_End                                    ; $5746


; C: menu cursor like PlayMenu_CursorUpdate (the yes / no choice of the Kitt games); runs on its screen (0E:13) in the
; core replays (port/entry_modes_kitty.csv); code read
KittHost_YesNoCursor::
    ld a, [wFadeRunning]                          ; $5749
    and a                                         ; $574C
    jr nz, jr_002_577a                            ; $574D

    ld a, [wKeysNewRepeat]                        ; $574F
    ld de, $0002                                  ; $5752
    bit 5, a                                      ; $5755
    jr nz, jr_002_57a5                            ; $5757

    inc e                                         ; $5759
    bit 4, a                                      ; $575A
    jr nz, jr_002_57a5                            ; $575C

    inc e                                         ; $575E
    bit 6, a                                      ; $575F
    jr nz, jr_002_57a5                            ; $5761

    inc e                                         ; $5763
    bit 7, a                                      ; $5764
    jr nz, jr_002_57a5                            ; $5766

    inc e                                         ; $5768
    ld a, [wKeysNew]                              ; $5769
    bit PADB_A, a                                 ; $576C
    jp nz, Jump_002_57e4                          ; $576E

    inc e                                         ; $5771
    ld a, [wKeysNew]                              ; $5772
    bit PADB_B, a                                 ; $5775
    jp nz, Jump_002_57f2                          ; $5777

jr_002_577a:
    ldh a, [hFrameCounter]                        ; $577A
    and $08                                       ; $577C
    jr z, jr_002_5785                             ; $577E

    ld a, $c0                                     ; $5780
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5782
    ret                                           ; $5784


jr_002_5785:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $5785
    ld c, a                                       ; $5787
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $5788
    ld b, a                                       ; $578A
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $578B
    ld l, a                                       ; $578E
    ld h, $00                                     ; $578F
    sla l                                         ; $5791
    rl h                                          ; $5793
    sla l                                         ; $5795
    rl h                                          ; $5797
    sla l                                         ; $5799
    rl h                                          ; $579B
    add hl, bc                                    ; $579D
    ld a, [hl+]                                   ; $579E
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $579F
    ld a, [hl+]                                   ; $57A1
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $57A2
    ret                                           ; $57A4


jr_002_57a5:
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $57A5
    ld c, a                                       ; $57A7
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $57A8
    ld b, a                                       ; $57AA
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $57AB
    ld l, a                                       ; $57AE
    ld h, $00                                     ; $57AF
    sla l                                         ; $57B1
    rl h                                          ; $57B3
    sla l                                         ; $57B5
    rl h                                          ; $57B7
    sla l                                         ; $57B9
    rl h                                          ; $57BB
    add hl, bc                                    ; $57BD
    add hl, de                                    ; $57BE
    ld a, [hl]                                    ; $57BF
    cp $ff                                        ; $57C0
    jr z, jr_002_57e3                             ; $57C2

    ld [wMenu07_CursorUpdate_D8F4], a             ; $57C4
    ld l, a                                       ; $57C7
    ld h, $00                                     ; $57C8
    sla l                                         ; $57CA
    rl h                                          ; $57CC
    sla l                                         ; $57CE
    rl h                                          ; $57D0
    sla l                                         ; $57D2
    rl h                                          ; $57D4
    add hl, bc                                    ; $57D6
    ld a, [hl+]                                   ; $57D7
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $57D8
    ld a, [hl+]                                   ; $57DA
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $57DB
    ld hl, wObjCmd_SetDC61                        ; $57DD
    call Obj_Sound                                ; $57E0

jr_002_57e3:
    ret                                           ; $57E3


Jump_002_57e4:
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $57E4
    and a                                         ; $57E7
    jr nz, jr_002_57f2                            ; $57E8

    ld hl, wObjCmd_SetDC63                        ; $57EA
    call Obj_Sound                                ; $57ED
    jr jr_002_57f8                                ; $57F0

Jump_002_57f2:
jr_002_57f2:
    ld hl, wObjCmd_SetDC65                        ; $57F2
    call Obj_Sound                                ; $57F5

jr_002_57f8:
    call KittHost_ItemRecord                      ; $57F8
    ld a, [hl]                                    ; $57FB
    cp $ff                                        ; $57FC
    ret z                                         ; $57FE

    and $0f                                       ; $57FF
    ldh [hMenuMode], a                            ; $5801
    ld a, [hl]                                    ; $5803
    swap a                                        ; $5804
    and $0f                                       ; $5806
    sla a                                         ; $5808
    ld c, a                                       ; $580A
    ld b, $00                                     ; $580B
    ld hl, ObjScript_02_584A_KittHost_YesNoCursor ; $580D
    add hl, bc                                    ; $5810
    ld a, [hl+]                                   ; $5811
    ld e, a                                       ; $5812
    ld d, [hl]                                    ; $5813
    call Call_000_2205                            ; $5814
    ld a, $3c                                     ; $5817
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5819
    ld de, KittHost_ObjCountdown                  ; $581B
    call Obj_SetCallback                          ; $581E
    ld a, $50                                     ; $5821
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5823
    ld a, $58                                     ; $5825
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5827
    ld a, $04                                     ; $5829
    ld [wMode06_State21_D8E0], a                  ; $582B
    ret                                           ; $582E


; C: the item record [$D8F4] of the table at hFFD1-hFFD3; runs on its screen (0E:13) in the core replays
; (port/entry_modes_kitty.csv); code read
KittHost_ItemRecord::
    ldh a, [hPlayMenu_CursorUpdate_FFD1]          ; $582F
    ld c, a                                       ; $5831
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $5832
    ld b, a                                       ; $5834
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5835
    ld l, a                                       ; $5838
    ld h, $00                                     ; $5839
    sla l                                         ; $583B
    rl h                                          ; $583D
    sla l                                         ; $583F
    rl h                                          ; $5841
    sla l                                         ; $5843
    rl h                                          ; $5845
    add hl, bc                                    ; $5847
    add hl, de                                    ; $5848
    ret                                           ; $5849


; C: named by the code of KittHost_YesNoCursor (02:580D); read in the runs by KittHost_YesNoCursor, Object_RunAll,
; Object_CreateWithParam; first read on the screen Mode0E_KittGamesHost_State13 (trace/read_screens_kitty.npz); kind
; OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_584A_KittHost_YesNoCursor::
    db $28, $40, $30, $40, $38, $40, $40, $40, $48, $40, $50, $40, $58, $40, $50, $58
    db $ff, $ff, $01, $01, $00, $11, $50, $68, $ff, $ff, $00, $00, $11, $11, $65, $1f
    db $58, $58, $ee, $1e, $19, $00, $f8, $1e, $0d, $00, $16, $1f, $49, $57, $e4, $1e
    db $01, $00, $1e, $1f, $60, $40, $68, $58, $b9, $7f, $b2, $4d, $50, $58, $ff, $ff
    db $01, $01, $50, $61, $50, $68, $ff, $ff, $00, $00, $61, $61, $65, $1f, $86, $58
    db $ee, $1e, $0d, $00, $f8, $1e, $19, $00, $1e, $1f, $74, $58, $96, $58, $b9, $7f
    db $b2, $4d, $50, $58, $ff, $ff, $02, $01, $20, $ff, $50, $60, $ff, $ff, $00, $02
    db $31, $ff, $50, $68, $ff, $ff, $01, $00, $42, $ff, $65, $1f, $ac, $58, $ee, $1e
    db $19, $00, $f8, $1e, $19, $00, $1e, $1f, $74, $58, $c4, $58, $b9, $7f, $b2, $4d
    db $50, $58, $ff, $ff, $01, $01, $20, $ff, $50, $68, $ff, $ff, $00, $00, $42, $ff
    db $65, $1f, $da, $58, $ee, $1e, $19, $00, $f8, $1e, $19, $00, $1e, $1f, $74, $58
    db $ea, $58, $b9, $7f, $b2, $4d, $50, $58, $ff, $ff, $01, $01, $20, $ff, $50, $68
    db $ff, $ff, $00, $00, $31, $ff, $65, $1f, $00, $59, $ee, $1e, $19, $00, $f8, $1e
    db $19, $00, $1e, $1f, $74, $58, $10, $59, $b9, $7f, $b2, $4d, $50, $58, $ff, $ff
    db $ff, $ff, $20, $ff, $65, $1f, $26, $59, $ee, $1e, $19, $00, $f8, $1e, $19, $00
    db $1e, $1f, $74, $58, $2e, $59, $b9, $7f, $b2, $4d

; C: ends when $D8E0 bit 2 is set
KittHost_ObjEndOnD8E0Bit2::
    ld a, [wMode06_State21_D8E0]                  ; $5944
    bit 2, a                                      ; $5947
    jp nz, Obj_End                                ; $5949

    ret                                           ; $594C


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0E_KittGamesHost_State13
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_594D_Mode0E_KittGamesHost_State13::
    db $10, $40, $44, $59, $b9, $7f, $20, $40, $44, $59, $b9, $7f, $18, $40, $44, $59
    db $b9, $7f, $68, $40, $44, $59, $b9, $7f, $70, $40, $44, $59, $b9, $7f, $78, $40
    db $44, $59, $b9, $7f

; C: sound $05, then Kitts_DrawAt9420Vram (script callback); runs on its screen (0E:08 0E:14) in the core replays
; (port/entry_modes_kitty.csv); code read
KittHost_ObjShowKitts::
    push hl                                       ; $5971
    push af                                       ; $5972
    ld a, SFX1_05                                 ; $5973
    ld [wSndSfx1], a                              ; $5975
    pop af                                        ; $5978
    ld b, BANK(Kitts_DrawAt9420Vram)              ; $5979
    ld hl, Kitts_DrawAt9420Vram                   ; $597B
    call Far_Call                                 ; $597E
    pop hl                                        ; $5981
    scf                                           ; $5982
    ret                                           ; $5983


; C: $D8E0 = 1 (script callback)
Obj_SetD8E0One_B::
    ld a, $01                                     ; $5984
    ld [wMode06_State21_D8E0], a                  ; $5986
    scf                                           ; $5989
    ret                                           ; $598A


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, PlayMenu_CursorUpdate; first read on the screen
; Mode0E_KittGamesHost_State08 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_598B_Mode0E_KittGamesHost_State08::
    INCBIN "data/bank_02/ObjScript_02_598B_Mode0E_KittGamesHost_State08.bin" ; $598B, 358 bytes
; C: restarts the object script 02:5AFF when $D8F4 changes; runs in the Play menu (mode $04)
PlayMenu_ObjFollowItem::
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $5AF1
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5AF4
    cp [hl]                                       ; $5AF7
    ld de, ObjScript_02_5AFF_PlayMenu_ObjFollowItem; $5AF8
    jp nz, Jump_000_2205                          ; $5AFB

    ret                                           ; $5AFE


; C: named by the code of PlayMenu_ObjFollowItem (02:5AF8); read in the runs by ObjCmd_JumpByByte, Object_RunAll;
; first read on the screen Mode04_PlayMenu_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_5AFF_PlayMenu_ObjFollowItem::
    db $0d, $5b, $09, $20, $f4, $d8, $88, $44, $ac, $44, $64, $44, $d0, $44

; C: hFFD8 = $D8F4, the position from the 4-byte record of that item (02:5B35) and its $240-byte BG map from bank $1A
; into $9800 (the Play menu picture of the item); runs in the Play menu (mode $04)
PlayMenu_ObjItemRecord::
    push hl                                       ; $5B0D
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5B0E
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $5B11
    sla a                                         ; $5B13
    sla a                                         ; $5B15
    ld c, a                                       ; $5B17
    ld b, $00                                     ; $5B18
    ld hl, ObjScript_02_5B35_PlayMenu_ObjItemRecord; $5B1A
    add hl, bc                                    ; $5B1D
    ld a, [hl+]                                   ; $5B1E
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5B1F
    ld a, [hl+]                                   ; $5B21
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5B22
    ld a, [hl+]                                   ; $5B24
    ld e, a                                       ; $5B25
    ld d, [hl]                                    ; $5B26
    ld hl, $9800                                  ; $5B27
    ld bc, $0240                                  ; $5B2A
    ld a, $1a                                     ; $5B2D
    call Vram_CopyHBlankFar                       ; $5B2F
    pop hl                                        ; $5B32
    scf                                           ; $5B33
    ret                                           ; $5B34


; C: named by the code of PlayMenu_ObjItemRecord (02:5B1A); read in the runs by PlayMenu_ObjItemRecord,
; Object_CreateWithParam; first read on the screen Mode04_PlayMenu_State01 (trace/read_screens_kitty.npz)
ObjScript_02_5B35_PlayMenu_ObjItemRecord::
    db $38, $18
    dw Map_1A_7000_Mode04_PlayMenu_State00
    db $2c, $38, $00, $74, $34, $58
    dw Map_1A_7800_Mode04_PlayMenu_State01
    db $38, $78
    dw Map_1A_7C00_Mode04_PlayMenu_State01
    db $ff, $5a, $f1, $5a, $b9, $7f, $a0, $42, $b9, $7f, $b9, $7f

; C: A or Start ($D8D9 & 9): sound $03 and the next step of the title; runs on its screen (00:05 00:08) in the core
; replays (port/entry_modes_kitty.csv); code read
Title_ObjKeys::
    ld a, [wKeysNew]                              ; $5B51
    and PADF_A | PADF_START                       ; $5B54
    jp z, Jump_002_5b66                           ; $5B56

    push af                                       ; $5B59
    ld a, SFX1_03                                 ; $5B5A
    ld [wSndSfx1], a                              ; $5B5C
    pop af                                        ; $5B5F
    ld de, ObjScript_02_5B67_Title_ObjKeys        ; $5B60
    jp Jump_000_2205                              ; $5B63


Jump_002_5b66:
    ret                                           ; $5B66


; C: named by the code of Title_ObjKeys (02:5B60); read in the runs by Object_RunAll, ObjCmd_SetCallback; first read
; on the screen Mode00_BootAndTitle_State08 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_5B67_Title_ObjKeys::
    db $16, $1f, $b9, $7f, $02, $80, $34, $50, $30, $80, $38, $50, $77, $5b, $09, $1f

; C: $D8E0 = 4 (script callback)
Obj_SetD8E0Four_C::
    ld a, $04                                     ; $5B77
    ld [wMode06_State21_D8E0], a                  ; $5B79
    scf                                           ; $5B7C
    ret                                           ; $5B7D


; C: $D8E0 = 0
Obj_ClearD8E0_B::
    xor a                                         ; $5B7E
    ld [wMode06_State21_D8E0], a                  ; $5B7F
    ret                                           ; $5B82


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_Jump; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_5B83_Mode00_BootAndTitle_State00::
    db $8c, $42, $51, $5b, $7e, $5b, $1e, $1f, $14, $42, $89, $5b, $b9, $7f, $b9, $7f
    db $1e, $1f, $20, $42, $93, $5b, $b9, $7f, $b9, $7f, $1e, $1f, $30, $42, $9d, $5b
    db $b9, $7f, $b9, $7f, $1e, $1f, $40, $42, $a7, $5b, $b9, $7f, $b9, $7f, $1e, $1f
    db $50, $42, $b1, $5b, $b9, $7f, $b9, $7f, $1e, $1f, $5c, $42, $bb, $5b, $b9, $7f
    db $b9, $7f, $1e, $1f, $6c, $42, $c5, $5b, $b9, $7f, $b9, $7f, $1e, $1f, $7c, $42
    db $cf, $5b, $b9, $7f, $b9, $7f

; C: skips two script bytes when $D8F4 equals hFFD8; code read; runs on the title and the main menu
Menu_ObjSkipIfSameItem::
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $5BD9
    ld c, a                                       ; $5BDB
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5BDC
    cp c                                          ; $5BDF
    jr nz, jr_002_5be6                            ; $5BE0

    inc hl                                        ; $5BE2
    inc hl                                        ; $5BE3
    scf                                           ; $5BE4
    ret                                           ; $5BE5


jr_002_5be6:
    ld a, [hl+]                                   ; $5BE6
    ld c, a                                       ; $5BE7
    ld a, [hl]                                    ; $5BE8
    ld l, c                                       ; $5BE9
    ld h, a                                       ; $5BEA
    scf                                           ; $5BEB
    ret                                           ; $5BEC


; C: ends the object on Start ($D8D9 bit 3) unless $D8D4 is set
Menu_EndOnStart::
    ld a, [wFadeRunning]                          ; $5BED
    and a                                         ; $5BF0
    jr nz, jr_002_5bfd                            ; $5BF1

    ld a, [wKeysNew]                              ; $5BF3
    bit PADB_START, a                             ; $5BF6
    jr z, jr_002_5bfd                             ; $5BF8

    jp Obj_End                                    ; $5BFA


jr_002_5bfd:
    ret                                           ; $5BFD


; C: ends the object on B ($D8D9 bit 1) unless $D8D4 is set
Menu_EndOnB::
    ld a, [wFadeRunning]                          ; $5BFE
    and a                                         ; $5C01
    jr nz, jr_002_5c0e                            ; $5C02

    ld a, [wKeysNew]                              ; $5C04
    bit PADB_B, a                                 ; $5C07
    jr z, jr_002_5c0e                             ; $5C09

    jp Obj_End                                    ; $5C0B


jr_002_5c0e:
    ret                                           ; $5C0E


; C: Menu_EndOnStart, then follows the selected item; runs on its screen (01:02) in the core replays
; (port/entry_modes_kitty.csv); code read
MainMenu_ObjTick::
    call Menu_EndOnStart                          ; $5C0F
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $5C12
    ld c, a                                       ; $5C14
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5C15
    cp c                                          ; $5C18
    jr nz, jr_002_5c29                            ; $5C19

    sla c                                         ; $5C1B
    ld b, $00                                     ; $5C1D
    ld hl, ObjScript_02_5C2A_MainMenu_ObjTick     ; $5C1F
    add hl, bc                                    ; $5C22
    ld a, [hl+]                                   ; $5C23
    ld e, a                                       ; $5C24
    ld d, [hl]                                    ; $5C25
    jp Jump_000_2205                              ; $5C26


jr_002_5c29:
    ret                                           ; $5C29


; C: named by the code of MainMenu_ObjTick (02:5C1F); read in the runs by Object_RunAll, Object_CreateWithParam,
; ObjCmd_SetCallback; first read on the screen Mode01_MainMenu_State02 (trace/read_screens_kitty.npz); kind OAM from
; the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5C2A_MainMenu_ObjTick::
    db $3b, $5c, $68, $5c, $95, $5c, $75, $1f, $00, $16, $1f, $0f, $5c, $1e, $1f, $d8
    db $42, $16, $1f, $ed, $5b, $08, $80, $70, $50, $28, $80, $58, $50, $08, $80, $70
    db $50, $08, $80, $88, $50, $d9, $5b, $30, $5c, $1e, $1f, $3f, $5c, $30, $5c, $b9
    db $7f, $b9, $7f, $75, $1f, $01, $16, $1f, $0f, $5c, $1e, $1f, $f4, $42, $16, $1f
    db $ed, $5b, $08, $80, $c0, $50, $28, $80, $a0, $50, $08, $80, $c0, $50, $08, $80
    db $d8, $50, $d9, $5b, $5d, $5c, $1e, $1f, $6c, $5c, $5d, $5c, $b9, $7f, $b9, $7f
    db $75, $1f, $02, $16, $1f, $0f, $5c, $1e, $1f, $10, $43, $16, $1f, $ed, $5b, $18
    db $80, $f0, $50, $18, $80, $08, $51, $18, $80, $20, $51, $d9, $5b, $8a, $5c, $1e
    db $1f, $99, $5c, $8a, $5c, $b9, $7f, $b9, $7f

; C: Menu_EndOnStart, then follows the selected item; runs on its screen (01:02) in the core replays
; (port/entry_modes_kitty.csv); code read
MainMenu_ObjTickB::
    call Menu_EndOnStart                          ; $5CB3
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $5CB6
    ld c, a                                       ; $5CB9
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $5CBA
    cp c                                          ; $5CBC
    jr z, jr_002_5ccd                             ; $5CBD

    sla c                                         ; $5CBF
    ld b, $00                                     ; $5CC1
    ld hl, ObjScript_02_5CCE_MainMenu_ObjTickB    ; $5CC3
    add hl, bc                                    ; $5CC6
    ld a, [hl+]                                   ; $5CC7
    ld e, a                                       ; $5CC8
    ld d, [hl]                                    ; $5CC9
    jp Jump_000_2205                              ; $5CCA


jr_002_5ccd:
    ret                                           ; $5CCD


; C: named by the code of MainMenu_ObjTickB (02:5CC3); read in the runs by ObjCmd_CopyAtLine20, Object_RunAll,
; MainMenu_ObjTickB; first read on the screen Mode01_MainMenu_State02 (trace/read_screens_kitty.npz); kind OAM from
; the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5CCE_MainMenu_ObjTickB::
    db $d4, $5c, $07, $5d, $3a, $5d, $75, $1f, $00, $cc, $1f, $01, $00, $30, $7b, $c0
    db $98, $a0, $00, $31, $cc, $1f, $01, $00, $d0, $7b, $60, $99, $a0, $00, $31, $cc
    db $1f, $08, $00, $f0, $72, $20, $98, $a0, $00, $2f, $cc, $1f, $08, $00, $90, $73
    db $20, $98, $a0, $00, $2f, $1e, $1f, $ed, $5c, $75, $1f, $01, $cc, $1f, $01, $00
    db $90, $7a, $20, $98, $a0, $00, $31, $cc, $1f, $01, $00, $d0, $7b, $60, $99, $a0
    db $00, $31, $cc, $1f, $08, $00, $30, $74, $c0, $98, $a0, $00, $2f, $cc, $1f, $08
    db $00, $d0, $74, $c0, $98, $a0, $00, $2f, $1e, $1f, $20, $5d, $75, $1f, $02, $cc
    db $1f, $01, $00, $90, $7a, $20, $98, $a0, $00, $31, $cc, $1f, $01, $00, $30, $7b
    db $c0, $98, $a0, $00, $31, $cc, $1f, $08, $00, $70, $75, $60, $99, $a0, $00, $2f
    db $cc, $1f, $08, $00, $10, $76, $60, $99, $a0, $00, $2f, $1e, $1f, $53, $5d, $d4
    db $5c, $b3, $5c, $b9, $7f

; C: $D8D4 = 1, $D8E0 = 0
Obj_BlockKeys::
    ld a, $01                                     ; $5D73
    ld [wFadeRunning], a                          ; $5D75
    xor a                                         ; $5D78
    ld [wMode06_State21_D8E0], a                  ; $5D79
    ret                                           ; $5D7C


; C: hFF95-hFF96 = mode $01 state $01, $D8E0 = 1
MainMenu_PickMode01::
    ld a, MODE_MAIN_MENU                          ; $5D7D
    ldh [hMenuMode], a                            ; $5D7F
    ld a, $01                                     ; $5D81
    ldh [hMenuState], a                           ; $5D83
    ld a, $01                                     ; $5D85
    ld [wMode06_State21_D8E0], a                  ; $5D87
    xor a                                         ; $5D8A
    ld [wFadeRunning], a                          ; $5D8B
    scf                                           ; $5D8E
    ret                                           ; $5D8F


; C: $D8D4 = 0 (script callback)
Obj_UnblockKeys::
    xor a                                         ; $5D90
    ld [wFadeRunning], a                          ; $5D91
    scf                                           ; $5D94
    ret                                           ; $5D95


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode01_MainMenu_State05 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5D96_Mode01_MainMenu_State05::
    db $cc, $1f, $01, $00, $90, $7a, $20, $98, $a0, $00, $31, $cc, $1f, $01, $00, $30
    db $7b, $c0, $98, $a0, $00, $31, $cc, $1f, $01, $00, $d0, $7b, $60, $99, $a0, $00
    db $31, $cc, $1f, $02, $00, $00, $65, $60, $98, $80, $00, $26, $cc, $1f, $02, $00
    db $80, $65, $60, $98, $c0, $00, $26, $cc, $1f, $02, $00, $40, $66, $60, $98, $00
    db $01, $26, $cc, $1f, $02, $00, $40, $67, $60, $98, $40, $01, $26, $cc, $1f, $02
    db $00, $80, $68, $60, $98, $80, $01, $26, $cc, $1f, $01, $00, $00, $6a, $60, $98
    db $80, $01, $26, $90, $5d, $02, $1f, $96, $5d, $b9, $7f, $73, $5d, $cc, $1f, $02
    db $00, $00, $6a, $60, $98, $80, $01, $26, $cc, $1f, $02, $00, $80, $68, $60, $98
    db $80, $01, $26, $cc, $1f, $02, $00, $40, $67, $60, $98, $40, $01, $26, $cc, $1f
    db $02, $00, $40, $66, $60, $98, $00, $01, $26, $cc, $1f, $02, $00, $80, $65, $60
    db $98, $c0, $00, $26, $cc, $1f, $01, $00, $00, $65, $60, $98, $80, $00, $26, $7d
    db $5d, $02, $1f, $03, $5e, $b9, $7f, $73, $5d

; C: an object of the camera view that moves to y $48 and reads the keys; runs on its screen (02:01) in the core
; replays (port/entry_modes_kitty.csv); code read
TakePhotos_ObjCursor::
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $5E4F
    cp $48                                        ; $5E51
    jr nz, jr_002_5e5a                            ; $5E53

    xor a                                         ; $5E55
    ldh [hCopyReqSrcDstCnt + $2], a               ; $5E56
    ldh [hCopyReqSrcDstCnt + $3], a               ; $5E58

jr_002_5e5a:
    ld a, [wKeysNew]                              ; $5E5A
    and PADF_A | PADF_B | PADF_UP | PADF_DOWN     ; $5E5D
    jp nz, Obj_End                                ; $5E5F

    ld a, [wKeysNewRepeat]                        ; $5E62
    and PADF_UP | PADF_DOWN                       ; $5E65
    jp nz, Obj_End                                ; $5E67

    ret                                           ; $5E6A


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_Jump; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5E6B_Mode02_TakePhotos_State01::
    db $1e, $1f, $4c, $49, $6b, $5e, $4f, $5e, $b9, $7f, $03, $7f, $1f, $00, $08, $1e
    db $1f, $4c, $49, $76, $5e, $4f, $5e, $b9, $7f, $03, $7f, $1f, $00, $f8, $1e, $1f
    db $4c, $49, $85, $5e, $4f, $5e, $b9, $7f

    db $03

; C: ends unless Start is held; the distance to the target position; runs on its screen (02:01 02:0B) in the core
; replays (port/entry_modes_kitty.csv); code read
TakePhotos_ObjPosDelta::
    ld a, [wKeysHeld]                             ; $5E94
    bit PADB_START, a                             ; $5E97
    jp z, Obj_End                                 ; $5E99

    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $5E9C
    xor $ff                                       ; $5E9E
    ld e, a                                       ; $5EA0
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $5EA1
    xor $ff                                       ; $5EA3
    ld d, a                                       ; $5EA5
    inc de                                        ; $5EA6
    ld bc, $054c                                  ; $5EA7
    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $5EAA
    dec a                                         ; $5EAD
    call Mul_8x16                                 ; $5EAE
    ld a, h                                       ; $5EB1
    add $20                                       ; $5EB2
    ld h, a                                       ; $5EB4
    ld l, $00                                     ; $5EB5
    add hl, de                                    ; $5EB7
    sra h                                         ; $5EB8
    rr l                                          ; $5EBA
    sra h                                         ; $5EBC
    rr l                                          ; $5EBE
    sra h                                         ; $5EC0
    rr l                                          ; $5EC2
    ld a, l                                       ; $5EC4
    ldh [hCopyReqSrcDstCnt + $2], a               ; $5EC5
    ld a, h                                       ; $5EC7
    ldh [hCopyReqSrcDstCnt + $3], a               ; $5EC8
    ret                                           ; $5ECA


; C: moves while the distance is not 0 (script 02:5F08); runs on its screen (02:01 02:0B) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_ObjMoveA::
    call TakePhotos_ObjPosDelta                   ; $5ECB
    ld a, l                                       ; $5ECE
    or h                                          ; $5ECF
    jr z, jr_002_5ed8                             ; $5ED0

    ld de, $5f08                                  ; $5ED2
    call Call_000_2205                            ; $5ED5

jr_002_5ed8:
    ret                                           ; $5ED8


; C: moves once the distance is 0 (script 02:5F00); runs on its screen (02:0B) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_ObjMoveB::
    call TakePhotos_ObjPosDelta                   ; $5ED9
    ld a, l                                       ; $5EDC
    or h                                          ; $5EDD
    jr nz, jr_002_5ee6                            ; $5EDE

    ld de, $5f00                                  ; $5EE0
    call Call_000_2205                            ; $5EE3

jr_002_5ee6:
    ret                                           ; $5EE6


; C: position from [$DA1E] - 1 (00:0C25); runs on its screen (02:01 02:0B) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_ObjPosFromDA1E::
    push hl                                       ; $5EE7
    ld bc, $054c                                  ; $5EE8
    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $5EEB
    dec a                                         ; $5EEE
    call Mul_8x16                                 ; $5EEF
    ld a, h                                       ; $5EF2
    add $20                                       ; $5EF3
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5EF5
    ld a, $98                                     ; $5EF7
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5EF9
    pop hl                                        ; $5EFB
    scf                                           ; $5EFC
    ret                                           ; $5EFD


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetCallback; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5EFE_Mode02_TakePhotos_State01::
    db $e7, $5e, $16, $1f, $cb, $5e, $1e, $1f, $7c, $43, $16, $1f, $d9, $5e, $1e, $1f
    db $98, $43, $fe, $5e, $b9, $7f, $b9, $7f

; C: ends unless Start is held; position from [$DA1F] - 1 x $666; runs on its screen (02:01 02:0B) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_ObjPosFromDA1F::
    ld a, [wKeysHeld]                             ; $5F16
    bit PADB_START, a                             ; $5F19
    jp z, Obj_End                                 ; $5F1B

    ld bc, $0666                                  ; $5F1E
    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $5F21
    dec a                                         ; $5F24
    call Mul_8x16                                 ; $5F25
    ld a, h                                       ; $5F28
    add $20                                       ; $5F29
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $5F2B
    ret                                           ; $5F2D


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_SetPos; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5F2E_Mode02_TakePhotos_State01::
    db $3a, $1f, $c0, $88, $1e, $1f, $a8, $43, $2e, $5f, $16, $5f, $b9, $7f

; C: ends at frame $08 ($D8FD); follows $D8FE / $D8FC; runs on its screen (02:01) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_FrameCursorTick::
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $5F3C
    cp $08                                        ; $5F3F
    jp z, Obj_End                                 ; $5F41

    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $5F44
    cp $04                                        ; $5F47
    jr z, jr_002_5f52                             ; $5F49

    ld a, [wMode02_State01_D8FC]                  ; $5F4B
    cp $ff                                        ; $5F4E
    jr nz, jr_002_5f5c                            ; $5F50

jr_002_5f52:
    call Obj_HideSprite                           ; $5F52
    ld a, $20                                     ; $5F55
    ldh [hObject_RunAll_FFC9], a                  ; $5F57
    xor a                                         ; $5F59
    ldh [hObject_RunAll_FFCA], a                  ; $5F5A

jr_002_5f5c:
    ld a, [wKeysHeld]                             ; $5F5C
    bit PADB_START, a                             ; $5F5F
    ret nz                                        ; $5F61

    ld a, [wKeysNew]                              ; $5F62
    and PADF_UP | PADF_DOWN                       ; $5F65
    jp nz, Obj_End                                ; $5F67

    ret                                           ; $5F6A


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz)
ObjScript_02_5F6B_Mode02_TakePhotos_State01::
    db $58, $43, $3c, $5f, $b9, $7f, $c9, $64, $43, $3c, $5f, $b9, $7f

    db $c9, $70, $43, $3c, $5f, $b9, $7f

; C: $D8D3 bit 7 cleared
FramePick_UnhideWindow::
    ld hl, wMode06_State0E_D8D3                   ; $5F7F
    res 7, [hl]                                   ; $5F82
    ret                                           ; $5F84


; C: $D931 - 1, wrapping to $18: 25 frames (script callback)
FramePick_Prev::
    ld a, [wMode06_State00_D931]                  ; $5F85
    dec a                                         ; $5F88
    cp $ff                                        ; $5F89
    jr nz, jr_002_5f8f                            ; $5F8B

    ld a, $18                                     ; $5F8D

jr_002_5f8f:
    ld [wMode06_State00_D931], a                  ; $5F8F
    scf                                           ; $5F92
    ret                                           ; $5F93


; C: $D931 + 1, wrapping to 0 (script callback)
FramePick_Next::
    ld a, [wMode06_State00_D931]                  ; $5F94
    inc a                                         ; $5F97
    cp $19                                        ; $5F98
    jr nz, jr_002_5f9e                            ; $5F9A

    ld a, $00                                     ; $5F9C

jr_002_5f9e:
    ld [wMode06_State00_D931], a                  ; $5F9E
    scf                                           ; $5FA1
    ret                                           ; $5FA2


; C: TakePhotos_DrawRowsLeftBg with $D931 (script callback)
FramePick_DrawLeftBg::
    push hl                                       ; $5FA3
    ld a, [wMode06_State00_D931]                  ; $5FA4
    ld b, BANK(TakePhotos_DrawRowsLeftBg)         ; $5FA7
    ld hl, TakePhotos_DrawRowsLeftBg              ; $5FA9
    call Far_CallKeepA                            ; $5FAC
    pop hl                                        ; $5FAF
    scf                                           ; $5FB0
    ret                                           ; $5FB1


; C: 00:077D with $D931 (script callback); runs on its screen (02:08) in the core replays
; (port/entry_modes_kitty.csv); code read
FramePick_Load::
    push hl                                       ; $5FB2
    ld a, [wMode06_State00_D931]                  ; $5FB3
    call FrameRec_LoadTiles                       ; $5FB6
    pop hl                                        ; $5FB9
    scf                                           ; $5FBA
    ret                                           ; $5FBB


; C: TakePhotos_DrawRowsRightBg with $D931 (script callback)
FramePick_DrawRightBg::
    push hl                                       ; $5FBC
    ld a, [wMode06_State00_D931]                  ; $5FBD
    ld b, BANK(TakePhotos_DrawRowsRightBg)        ; $5FC0
    ld hl, TakePhotos_DrawRowsRightBg             ; $5FC2
    call Far_CallKeepA                            ; $5FC5
    pop hl                                        ; $5FC8
    scf                                           ; $5FC9
    ret                                           ; $5FCA


; C: TakePhotos_DrawRowsLeftWin with $D931 (script callback)
FramePick_DrawLeftWin::
    push hl                                       ; $5FCB
    ld a, [wMode06_State00_D931]                  ; $5FCC
    ld b, BANK(TakePhotos_DrawRowsLeftWin)        ; $5FCF
    ld hl, TakePhotos_DrawRowsLeftWin             ; $5FD1
    call Far_CallKeepA                            ; $5FD4
    pop hl                                        ; $5FD7
    scf                                           ; $5FD8
    ret                                           ; $5FD9


; C: TakePhotos_DrawRowsRightWin with $D931 (script callback)
FramePick_DrawRightWin::
    push hl                                       ; $5FDA
    ld a, [wMode06_State00_D931]                  ; $5FDB
    ld b, BANK(TakePhotos_DrawRowsRightWin)       ; $5FDE
    ld hl, TakePhotos_DrawRowsRightWin            ; $5FE0
    call Far_CallKeepA                            ; $5FE3
    pop hl                                        ; $5FE6
    scf                                           ; $5FE7
    ret                                           ; $5FE8


; C: 00:07CE with $D931, $D8D3 bit 7 set (script callback); runs on its screen (02:08) in the core replays
; (port/entry_modes_kitty.csv); code read
FramePick_LoadAndHide::
    push hl                                       ; $5FE9
    ld a, [wMode06_State00_D931]                  ; $5FEA
    call FrameRec_LoadMap                         ; $5FED
    ld hl, wMode06_State0E_D8D3                   ; $5FF0
    set 7, [hl]                                   ; $5FF3
    pop hl                                        ; $5FF5
    scf                                           ; $5FF6
    ret                                           ; $5FF7


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode02_TakePhotos_State08 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_5FF8_Mode02_TakePhotos_State08::
    db $ba, $1e, $19, $00, $cc, $1f, $00, $00, $00, $70, $00, $9c, $80, $02, $19, $cb
    db $5f, $9f, $1c, $cc, $1f, $00, $00, $00, $74, $00, $98, $80, $02, $19, $a3, $5f
    db $93, $1c, $cc, $1f, $00, $00, $00, $70, $00, $9c, $80, $02, $14, $9f, $1c, $94
    db $5f, $b2, $5f, $cc, $1f, $00, $00, $00, $78, $00, $98, $80, $02, $19, $bc, $5f
    db $93, $1c, $cc, $1f, $00, $00, $00, $7c, $00, $9c, $80, $02, $19, $da, $5f, $9f
    db $1c, $cc, $1f, $00, $00, $f0, $75, $00, $98, $80, $02, $31, $e9, $5f, $93, $1c
    db $02, $1f, $f8, $5f, $b9, $7f, $7f, $5f, $ba, $1e, $19, $00, $cc, $1f, $00, $00
    db $00, $7c, $00, $9c, $80, $02, $19, $da, $5f, $9f, $1c, $cc, $1f, $00, $00, $00
    db $78, $00, $98, $80, $02, $19, $bc, $5f, $93, $1c, $cc, $1f, $00, $00, $00, $70
    db $00, $9c, $80, $02, $14, $9f, $1c, $85, $5f, $b2, $5f, $cc, $1f, $00, $00, $00
    db $74, $00, $98, $80, $02, $19, $a3, $5f, $93, $1c, $cc, $1f, $00, $00, $00, $70
    db $00, $9c, $80, $02, $19, $cb, $5f, $9f, $1c, $cc, $1f, $00, $00, $f0, $75, $00
    db $98, $80, $02, $31, $e9, $5f, $93, $1c, $02, $1f, $60, $60, $b9, $7f, $7f, $5f

; C: hFFD8 + 1; ends at $78 frames or on a key; code read; runs in the camera view
Obj_Timeout78::
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $60C8
    inc a                                         ; $60CA
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $60CB
    cp $78                                        ; $60CD
    jp z, Obj_End                                 ; $60CF

    ld a, [wKeysHeld]                             ; $60D2
    and a                                         ; $60D5
    jp nz, Obj_End                                ; $60D6

    ret                                           ; $60D9


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_SetPos; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_60DA_Mode02_TakePhotos_State01::
    db $3a, $1f, $18, $4c, $1e, $1f, $04, $44, $3a, $1f, $88, $4c, $1e, $1f, $14, $44
    db $3a, $1f, $51, $1a, $1e, $1f, $24, $44, $3a, $1f, $51, $74, $1e, $1f, $34, $44
    db $da, $60, $c8, $60, $b9, $7f, $e2, $60, $c8, $60, $b9, $7f, $ea, $60, $c8, $60
    db $b9, $7f, $f2, $60, $c8, $60, $b9, $7f, $3a, $1f, $18, $4c, $1e, $1f, $c4, $43
    db $3a, $1f, $88, $4c, $1e, $1f, $d4, $43, $3a, $1f, $51, $1a, $1e, $1f, $e4, $43
    db $3a, $1f, $51, $74, $1e, $1f, $f4, $43, $12, $61, $c8, $60, $b9, $7f, $1a, $61
    db $c8, $60, $b9, $7f, $22, $61, $c8, $60, $b9, $7f, $2a, $61, $c8, $60, $b9, $7f

; C: album arrow object: restarts its script when $D933 is not 0; runs on its screen (03:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Album_Arrow614A::
    ld a, [wMode03_State02_D933]                  ; $614A
    and a                                         ; $614D
    ret z                                         ; $614E

    ld de, ObjScript_02_616A_Album_Arrow614A      ; $614F
    jp Jump_000_2205                              ; $6152


; C: named by the code of Album_Arrow615F (02:6164); read in the runs by Object_RunAll, ObjCmd_SetCallback; first read
; on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_6155_Album_Arrow615F::
    db $16, $1f, $4a, $61, $08, $80, $00, $00, $09, $1f

; C: album arrow object: restarts its script when $D933 is 0; runs on its screen (03:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Album_Arrow615F::
    ld a, [wMode03_State02_D933]                  ; $615F
    and a                                         ; $6162
    ret nz                                        ; $6163

    ld de, ObjScript_02_6155_Album_Arrow615F      ; $6164
    jp Jump_000_2205                              ; $6167


; C: named by the code of Album_Arrow614A (02:614F); read in the runs by Object_RunAll, Object_CreateWithParam,
; ObjCmd_SetPos; first read on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the
; evidence of tools/kitty_layout_kinds.py
ObjScript_02_616A_Album_Arrow614A::
    db $3a, $1f, $10, $0c, $16, $1f, $5f, $61, $1e, $1f, $c4, $43, $6a, $61, $b9, $7f
    db $b9, $7f

; C: album arrow object: restarts its script when $D933 differs from $D932; runs on its screen (03:02) in the core
; replays (port/entry_modes_kitty.csv); code read
Album_Arrow617C::
    ld hl, wAlbum_SlotOp6D18_D932                 ; $617C
    ld a, [wMode03_State02_D933]                  ; $617F
    cp [hl]                                       ; $6182
    ret z                                         ; $6183

    ld de, ObjScript_02_61A2_Album_Arrow617C      ; $6184
    jp Jump_000_2205                              ; $6187


; C: named by the code of Album_Arrow6194 (02:619C); read in the runs by Object_RunAll, ObjCmd_SetCallback; first read
; on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_618A_Album_Arrow6194::
    db $16, $1f, $7c, $61, $08, $80, $00, $00, $09, $1f

; C: album arrow object: restarts its script when $D933 equals $D932; runs on its screen (03:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Album_Arrow6194::
    ld hl, wAlbum_SlotOp6D18_D932                 ; $6194
    ld a, [wMode03_State02_D933]                  ; $6197
    cp [hl]                                       ; $619A
    ret nz                                        ; $619B

    ld de, ObjScript_02_618A_Album_Arrow6194      ; $619C
    jp Jump_000_2205                              ; $619F


; C: named by the code of Album_Arrow617C (02:6184); read in the runs by Object_RunAll, Object_CreateWithParam,
; ObjCmd_SetPos; first read on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the
; evidence of tools/kitty_layout_kinds.py
ObjScript_02_61A2_Album_Arrow617C::
    db $3a, $1f, $60, $0c, $16, $1f, $94, $61, $1e, $1f, $d4, $43, $a2, $61, $b9, $7f
    db $b9, $7f

; C: restarts the script 02:61CF on Left / Right ($D8DA & $30)
Album_ObjOnLeftRight::
    ld a, [wKeysNewRepeat]                        ; $61B4
    and PADF_RIGHT | PADF_LEFT                    ; $61B7
    ret z                                         ; $61B9

    ld de, ObjScript_02_61CF_Album_ObjOnLeftRight ; $61BA
    jp Jump_000_2205                              ; $61BD


; C: Photo_DrawNumber with [$D933] (script callback)
Album_ObjDrawIndex::
    push hl                                       ; $61C0
    ld a, [wMode03_State02_D933]                  ; $61C1
    ld b, BANK(Photo_DrawNumber)                  ; $61C4
    ld hl, Photo_DrawNumber                       ; $61C6
    call Far_CallKeepA                            ; $61C9
    pop hl                                        ; $61CC
    scf                                           ; $61CD
    ret                                           ; $61CE


; C: named by the code of Album_ObjOnLeftRight (02:61BA); read in the runs by Object_RunAll, Object_CreateWithParam,
; ObjCmd_SetPos; first read on the screen Mode03_ViewAlbum_State05 (trace/read_screens_kitty.npz); kind OAM from the
; evidence of tools/kitty_layout_kinds.py
ObjScript_02_61CF_Album_ObjOnLeftRight::
    db $10, $1f, $01, $00, $c0, $61, $3a, $1f, $20, $20, $78, $80, $c0, $51, $3a, $1f
    db $c0, $20, $09, $1f, $d5, $61, $b4, $61, $c0, $61

; C: ends on any held key ($D8DA)
Album_ObjEndOnKey::
    ld a, [wKeysNewRepeat]                        ; $61E9
    and PADF_A | PADF_B | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $61EC
    jp nz, Obj_End                                ; $61EE

    ret                                           ; $61F1


; C: read in the runs by Object_RunAll, Object_CreateWithParam; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_61F2_Mode05_StampWindow_State06::
    db $78, $80, $e8, $5b, $02, $1f, $f2, $61, $e9, $61, $c0, $61

; C: album arrow object: restarts its script when $D933 is not 0 (second arrow); runs on its screen (03:02) in the
; core replays (port/entry_modes_kitty.csv); code read
Album_Arrow61FE::
    ld a, [wMode03_State02_D933]                  ; $61FE
    and a                                         ; $6201
    ret z                                         ; $6202

    ld de, ObjScript_02_621E_Album_Arrow61FE      ; $6203
    jp Jump_000_2205                              ; $6206


; C: named by the code of Album_Arrow6213 (02:6218); read in the runs by Object_RunAll, ObjCmd_SetCallback; first read
; on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_6209_Album_Arrow6213::
    db $16, $1f, $fe, $61, $08, $80, $00, $00, $09, $1f

; C: album arrow object: restarts its script when $D933 is 0 (second arrow); runs on its screen (03:02) in the core
; replays (port/entry_modes_kitty.csv); code read
Album_Arrow6213::
    ld a, [wMode03_State02_D933]                  ; $6213
    and a                                         ; $6216
    ret nz                                        ; $6217

    ld de, ObjScript_02_6209_Album_Arrow6213      ; $6218
    jp Jump_000_2205                              ; $621B


; C: named by the code of Album_Arrow61FE (02:6203); read in the runs by Object_RunAll, Object_CreateWithParam,
; ObjCmd_SetCallback; first read on the screen Mode03_ViewAlbum_State02 (trace/read_screens_kitty.npz); kind OAM from
; the evidence of tools/kitty_layout_kinds.py
ObjScript_02_621E_Album_Arrow61FE::
    db $16, $1f, $13, $62, $08, $80, $c0, $51, $09, $1f, $1e, $62, $b9, $7f, $c0, $61

; C: $D8D4 = 1, $D8D3 bit 7 cleared
Obj_BlockKeysHideWindow::
    ld a, $01                                     ; $622E
    ld [wFadeRunning], a                          ; $6230
    ld hl, wMode06_State0E_D8D3                   ; $6233
    res 7, [hl]                                   ; $6236
    ret                                           ; $6238


; C: $D8D4 = 0, $D8D3 bit 7 set (script callback)
Obj_UnblockKeysShowWindow::
    xor a                                         ; $6239
    ld [wFadeRunning], a                          ; $623A
    push hl                                       ; $623D
    ld hl, wMode06_State0E_D8D3                   ; $623E
    set 7, [hl]                                   ; $6241
    pop hl                                        ; $6243
    scf                                           ; $6244
    ret                                           ; $6245


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode03_ViewAlbum_State03 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6246_Mode03_ViewAlbum_State03::
    db $cc, $1f, $01, $00, $00, $7c, $00, $98, $40, $02, $21, $6b, $63, $cc, $1f, $01
    db $00, $00, $78, $00, $98, $40, $02, $21, $cc, $1f, $01, $00, $00, $7c, $00, $98
    db $40, $02, $15, $cc, $1f, $01, $00, $00, $78, $00, $98, $40, $02, $15, $cc, $1f
    db $01, $00, $00, $74, $00, $98, $40, $02, $15, $cc, $1f, $01, $00, $00, $70, $00
    db $98, $40, $02, $15, $cc, $1f, $01, $00, $00, $50, $00, $90, $80, $03, $15, $cc
    db $1f, $01, $00, $40, $5a, $00, $98, $00, $04, $22, $39, $62, $02, $1f, $46, $62
    db $b9, $7f, $2e, $62

; I: leftover: 98 bytes (02:62AA-630B) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_62AA::
    db $cc, $1f, $01, $00, $00, $70, $00, $98, $40, $02, $15, $cc, $1f, $01, $00, $00
    db $50, $00, $90, $80, $03, $15, $cc, $1f, $01, $00, $00, $74, $00, $98, $40, $02
    db $15, $cc, $1f, $01, $00, $00, $78, $00, $98, $40, $02, $15, $cc, $1f, $01, $00
    db $00, $7c, $00, $98, $40, $02, $15, $cc, $1f, $01, $00, $00, $78, $00, $98, $40
    db $02, $21, $cc, $1f, $01, $00, $00, $7c, $00, $98, $40, $02, $21, $cc, $1f, $01
    db $00, $40, $5a, $00, $98, $00, $04, $22, $39, $62, $02, $1f, $aa, $62, $b9, $7f
    db $2e, $62

; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode03_ViewAlbum_State03 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_630C_Mode03_ViewAlbum_State03::
    db $cc, $1f, $01, $00, $00, $70, $00, $98, $40, $02, $15, $6b, $63, $7a, $63, $10
    db $1f, $01, $00, $cc, $1f, $01, $00, $00, $74, $00, $98, $40, $02, $15, $cc, $1f
    db $01, $00, $00, $78, $00, $98, $40, $02, $15, $cc, $1f, $01, $00, $00, $7c, $00
    db $98, $40, $02, $15, $cc, $1f, $01, $00, $00, $78, $00, $98, $40, $02, $21, $cc
    db $1f, $01, $00, $00, $7c, $00, $98, $40, $02, $21, $cc, $1f, $01, $00, $40, $5e
    db $00, $98, $00, $04, $22, $39, $62, $02, $1f, $0c, $63, $b9, $7f, $2e, $62

; C: Photo_DrawNumber with [$D933] (script callback)
Album_ObjDrawIndexB::
    push hl                                       ; $636B
    ld a, [wMode03_State02_D933]                  ; $636C
    ld b, BANK(Photo_DrawNumber)                  ; $636F
    ld hl, Photo_DrawNumber                       ; $6371
    call Far_CallKeepA                            ; $6374
    pop hl                                        ; $6377
    scf                                           ; $6378
    ret                                           ; $6379


; C: Photo_FindSlotA with [$D933], then a photo load (script callback); runs on its screen (03:03) in the core replays
; (port/entry_modes_kitty.csv); code read
Album_ObjLoadSlot::
    push hl                                       ; $637A
    ld a, [wMode03_State02_D933]                  ; $637B
    ld b, BANK(Photo_FindSlotA)                   ; $637E
    ld hl, Photo_FindSlotA                        ; $6380
    call Far_CallKeepA                            ; $6383
    jr c, jr_002_63a1                             ; $6386

    ld b, BANK(Photo_LoadThumbToVram)             ; $6388
    ld hl, Photo_LoadThumbToVram                  ; $638A
    call Far_CallKeepA                            ; $638D
    ld a, [wSlotTagBorder]                        ; $6390
    ld [wMode06_State00_D931], a                  ; $6393
    ld b, BANK(Text_DrawSmallLine)                ; $6396
    ld hl, Text_DrawSmallLine                     ; $6398
    call Far_Call                                 ; $639B
    pop hl                                        ; $639E
    scf                                           ; $639F
    ret                                           ; $63A0


jr_002_63a1:
    ld a, $01                                     ; $63A1
    call Photo_LoadEmptyThumb                     ; $63A3
    ld a, $00                                     ; $63A6
    ld [wMode06_State00_D931], a                  ; $63A8
    ld b, BANK(Text_DrawSmallLine)                ; $63AB
    ld hl, Text_DrawSmallLine                     ; $63AD
    call Far_Call                                 ; $63B0
    pop hl                                        ; $63B3
    scf                                           ; $63B4
    ret                                           ; $63B5


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode03_ViewAlbum_State03 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_63B6_Mode03_ViewAlbum_State03::
    db $cc, $1f, $01, $00, $00, $7c, $00, $98, $40, $02, $1f, $6b, $63, $cc, $1f, $01
    db $00, $00, $78, $00, $98, $40, $02, $1f, $cc, $1f, $01, $00, $40, $7a, $00, $98
    db $40, $02, $1c, $cc, $1f, $01, $00, $40, $76, $00, $98, $40, $02, $1c, $cc, $1f
    db $01, $00, $40, $72, $00, $98, $40, $02, $1c, $cc, $1f, $01, $00, $40, $6e, $00
    db $98, $40, $02, $1c, $7a, $63, $10, $1f, $01, $00, $cc, $1f, $01, $00, $40, $5e
    db $00, $98, $00, $04, $22, $39, $62, $02, $1f, $b6, $63, $b9, $7f, $2e, $62, $cc
    db $1f, $01, $00, $40, $6e, $00, $98, $40, $02, $1c, $6b, $63, $7a, $63, $10, $1f
    db $01, $00, $cc, $1f, $01, $00, $40, $72, $00, $98, $40, $02, $1c, $cc, $1f, $01
    db $00, $40, $76, $00, $98, $40, $02, $1c, $cc, $1f, $01, $00, $40, $7a, $00, $98
    db $40, $02, $1c, $cc, $1f, $01, $00, $00, $78, $00, $98, $40, $02, $1f, $cc, $1f
    db $01, $00, $00, $7c, $00, $98, $40, $02, $1f, $cc, $1f, $01, $00, $40, $5e, $00
    db $98, $00, $04, $22, $39, $62, $02, $1f, $15, $64, $b9, $7f, $2e, $62

; C: ends on Left / Right
Album_ObjEndOnLeftRight::
    ld a, [wKeysNewRepeat]                        ; $6474
    and PADF_RIGHT | PADF_LEFT                    ; $6477
    jp nz, Obj_End                                ; $6479

    ret                                           ; $647C


; C: follows $DAA6 into $D936 and redraws (00:0924); runs on its screen (03:05) in the core replays
; (port/entry_modes_kitty.csv); code read
Album_ObjFollowDAA6::
    push hl                                       ; $647D
    ld hl, wAlbum_ObjFollowDAA6_D936              ; $647E
    ld a, [wSlotTagBorder]                        ; $6481
    cp [hl]                                       ; $6484
    jr z, jr_002_648b                             ; $6485

    ld [hl], a                                    ; $6487
    call FrameRec_LoadDefault                     ; $6488

jr_002_648b:
    pop hl                                        ; $648B
    scf                                           ; $648C
    ret                                           ; $648D


; C: read in the runs by Object_RunAll, Object_CreateWithParam; first read on the screen Mode03_ViewAlbum_State05
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_648E_Mode03_ViewAlbum_State05::
    db $14, $80, $00, $00, $7d, $64, $02, $1f, $8e, $64, $74, $64, $b9, $7f

; C: unless the keys are blocked ($D8D4), A or Start ($D8D9 & 9) ends the wait (hFFC9 = 1, callback cleared); in an
; object script of the printing screens (02:6576), runs in mode $06 state $04
Printing_ObjWaitAorStart::
    ld a, [wFadeRunning]                          ; $649C
    and a                                         ; $649F
    ret nz                                        ; $64A0

    ld a, [wKeysNew]                              ; $64A1
    and PADF_A | PADF_START                       ; $64A4
    jr z, jr_002_64b2                             ; $64A6

    ld a, $01                                     ; $64A8
    ldh [hObject_RunAll_FFC9], a                  ; $64AA
    xor a                                         ; $64AC
    ldh [hObject_RunAll_FFCA], a                  ; $64AD
    jp Obj_ClearCallback                          ; $64AF


jr_002_64b2:
    ld a, [wKeysNewRepeat]                        ; $64B2
    and PADF_UP | PADF_DOWN                       ; $64B5
    ld de, $7fc0                                  ; $64B7
    jp nz, Jump_000_2205                          ; $64BA

    ld a, [wKeysNewRepeat]                        ; $64BD
    and PADF_RIGHT | PADF_LEFT                    ; $64C0
    ld de, $7fc0                                  ; $64C2
    jp nz, Jump_000_2205                          ; $64C5

    ret                                           ; $64C8


; C: $D8D3 bit 6 cleared, $D8E0 = 0
Obj_ShowBgClearD8E0::
    ld hl, wMode06_State0E_D8D3                   ; $64C9
    res 6, [hl]                                   ; $64CC
    xor a                                         ; $64CE
    ld [wMode06_State21_D8E0], a                  ; $64CF
    ret                                           ; $64D2


; C: state 5, $D8E0 = 2 (script callback)
Printing_ObjToState05::
    ld a, $05                                     ; $64D3
    ldh [hState], a                               ; $64D5
    ld a, $02                                     ; $64D7
    ld [wMode06_State21_D8E0], a                  ; $64D9
    scf                                           ; $64DC
    ret                                           ; $64DD


; C: 00:1918 (script callback); runs on its screen (06:05) in the core replays (port/entry_modes_kitty.csv); code read
Printing_ObjCall1918::
    push hl                                       ; $64DE
    call Stat_SetTileToggleAt4F                   ; $64DF
    pop hl                                        ; $64E2
    scf                                           ; $64E3
    ret                                           ; $64E4


; C: $C000 into tiles $9000 ($800) and $C800 into $8000 (script callback)
Printing_ObjPhotoToVram::
    push hl                                       ; $64E5
    ld de, $c000                                  ; $64E6
    ld hl, $9000                                  ; $64E9
    ld bc, $0800                                  ; $64EC
    call Vram_CopyHBlank                          ; $64EF
    ld de, $c800                                  ; $64F2
    ld hl, $8000                                  ; $64F5
    ld bc, $0600                                  ; $64F8
    call Vram_CopyHBlank                          ; $64FB
    ld de, Map_20_7C00_Mode06_Printing_State07    ; $64FE
    ld a, $20                                     ; $6501
    ld hl, $9882                                  ; $6503
    ld bc, $01c0                                  ; $6506
    call Vram_CopyHBlankFar                       ; $6509
    pop hl                                        ; $650C
    scf                                           ; $650D
    ret                                           ; $650E


; C: $D8D3 bit 6 set (script callback)
Obj_SetD8D3Bit6::
    push hl                                       ; $650F
    ld hl, wMode06_State0E_D8D3                   ; $6510
    set 6, [hl]                                   ; $6513
    pop hl                                        ; $6515
    scf                                           ; $6516
    ret                                           ; $6517


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode06_Printing_State05 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6518_Mode06_Printing_State05::
    db $96, $80, $00, $00, $d3, $64, $16, $1f, $bd, $64, $ba, $1e, $01, $02, $cc, $1f
    db $00, $00, $20, $78, $42, $98, $20, $01, $20, $cc, $1f, $01, $00, $20, $7a, $62
    db $99, $20, $01, $20, $cc, $1f, $00, $00, $40, $78, $42, $98, $20, $01, $20, $cc
    db $1f, $01, $00, $e0, $79, $62, $99, $20, $01, $20, $cc, $1f, $00, $00, $60, $78
    db $42, $98, $20, $01, $20, $cc, $1f, $01, $00, $80, $79, $62, $99, $20, $01, $20
    db $de, $64, $10, $1f, $01, $00, $e5, $64, $0f, $65, $02, $1f, $18, $65, $9c, $64
    db $c9, $64

; C: ret
Obj_Ret657A::
    ret                                           ; $657A


; C: 00:1A80 (script callback); runs on its screen (06:08 06:09) in the core replays (port/entry_modes_kitty.csv);
; code read
Printing_ObjCall1A80::
    push hl                                       ; $657B
    call Stat_SetTileToggleAt27                   ; $657C
    pop hl                                        ; $657F
    scf                                           ; $6580
    ret                                           ; $6581


; C: PrintFrame_LoadTiles with [$D935] (script callback)
Printing_ObjFrameTiles::
    push hl                                       ; $6582
    ld a, [wPrintFrame_Next_D935]                 ; $6583
    ld b, BANK(PrintFrame_LoadTiles)              ; $6586
    ld hl, PrintFrame_LoadTiles                   ; $6588
    call Far_CallKeepA                            ; $658B
    pop hl                                        ; $658E
    scf                                           ; $658F
    ret                                           ; $6590


; C: $D8D3 bit 6 cleared (script callback)
Obj_ClearD8D3Bit6::
    push hl                                       ; $6591
    ld hl, wMode06_State0E_D8D3                   ; $6592
    res 6, [hl]                                   ; $6595
    pop hl                                        ; $6597
    scf                                           ; $6598
    ret                                           ; $6599


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode06_Printing_State08 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_659A_Mode06_Printing_State08::
    db $cc, $1f, $00, $00, $a0, $78, $82, $98, $c0, $01, $20, $7b, $65, $10, $1f, $01
    db $00, $82, $65, $10, $1f, $01, $00, $ba, $1e, $04, $03, $cc, $1f, $00, $00, $40
    db $78, $42, $98, $20, $01, $20, $cc, $1f, $01, $00, $e0, $79, $62, $99, $20, $01
    db $20, $cc, $1f, $00, $00, $20, $78, $42, $98, $20, $01, $20, $cc, $1f, $01, $00
    db $20, $7a, $62, $99, $20, $01, $20, $cc, $1f, $00, $00, $00, $78, $42, $98, $20
    db $01, $20, $cc, $1f, $01, $00, $60, $7a, $62, $99, $20, $01, $20, $91, $65, $02
    db $1f, $9a, $65, $b9, $7f, $7a, $65

; C: calls the word at HL, then $D882 bit 4 cleared (script callback)
Obj_CallClearD882Bit4::
    push hl                                       ; $6601
    ld a, [hl+]                                   ; $6602
    ld h, [hl]                                    ; $6603
    ld l, a                                       ; $6604
    call Call_HL                                  ; $6605
    ld hl, wLcdcShadow                            ; $6608
    res 4, [hl]                                   ; $660B
    pop hl                                        ; $660D
    inc hl                                        ; $660E
    inc hl                                        ; $660F
    scf                                           ; $6610
    ret                                           ; $6611


; C: calls the word at HL, then $D882 bit 4 set (script callback)
Obj_CallSetD882Bit4::
    push hl                                       ; $6612
    ld a, [hl+]                                   ; $6613
    ld h, [hl]                                    ; $6614
    ld l, a                                       ; $6615
    call Call_HL                                  ; $6616
    ld hl, wLcdcShadow                            ; $6619
    set 4, [hl]                                   ; $661C
    pop hl                                        ; $661E
    inc hl                                        ; $661F
    inc hl                                        ; $6620
    scf                                           ; $6621
    ret                                           ; $6622


; C: $D935 + 1, wrapping at 6 (script callback)
PrintFrame_Next::
    push hl                                       ; $6623
    ld a, [wPrintFrame_Next_D935]                 ; $6624
    inc a                                         ; $6627
    cp $06                                        ; $6628
    jr nz, jr_002_662d                            ; $662A

    xor a                                         ; $662C

jr_002_662d:
    ld [wPrintFrame_Next_D935], a                 ; $662D
    ld a, [wPrintFrame_Next_D935]                 ; $6630
    ld b, BANK(PrintFrame_LoadTiles)              ; $6633
    ld hl, PrintFrame_LoadTiles                   ; $6635
    call Far_CallKeepA                            ; $6638
    pop hl                                        ; $663B
    scf                                           ; $663C
    ret                                           ; $663D


; C: $D935 - 1, wrapping to 5 (script callback)
PrintFrame_Prev::
    push hl                                       ; $663E
    ld a, [wPrintFrame_Next_D935]                 ; $663F
    dec a                                         ; $6642
    cp $ff                                        ; $6643
    jr nz, jr_002_6649                            ; $6645

    ld a, $05                                     ; $6647

jr_002_6649:
    ld [wPrintFrame_Next_D935], a                 ; $6649
    ld a, [wPrintFrame_Next_D935]                 ; $664C
    ld b, BANK(PrintFrame_LoadTiles)              ; $664F
    ld hl, PrintFrame_LoadTiles                   ; $6651
    call Far_CallKeepA                            ; $6654
    pop hl                                        ; $6657
    scf                                           ; $6658
    ret                                           ; $6659


; C: $D8D3 bit 7 set (script callback)
Obj_SetD8D3Bit7::
    push hl                                       ; $665A
    ld hl, wMode06_State0E_D8D3                   ; $665B
    set 7, [hl]                                   ; $665E
    pop hl                                        ; $6660
    scf                                           ; $6661
    ret                                           ; $6662


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Obj_CallClearD882Bit4; first read on the screen
; Mode06_Printing_State07 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6663_Mode06_Printing_State07::
    INCBIN "data/bank_02/ObjScript_02_6663_Mode06_Printing_State07.bin" ; $6663, 994 bytes
; C: $D8D3 bit 7 cleared, 00:1A80, PrintFrame_LoadTiles with [$D935]; runs on its screen (06:04 06:08) in the core
; replays (port/entry_modes_kitty.csv); code read
PrintFrame_Show::
    ld hl, wMode06_State0E_D8D3                   ; $6A45
    res 7, [hl]                                   ; $6A48
    call Stat_SetTileToggleAt27                   ; $6A4A
    ld a, [wPrintFrame_Next_D935]                 ; $6A4D
    ld b, BANK(PrintFrame_LoadTiles)              ; $6A50
    ld hl, PrintFrame_LoadTiles                   ; $6A52
    call Far_CallKeepA                            ; $6A55
    ret                                           ; $6A58


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode06_Printing_State08
; (trace/read_screens_kitty.npz)
ObjScript_02_6A59_Mode06_Printing_State08::
    db $63, $66, $b9, $7f, $45, $6a, $54, $68, $b9, $7f, $45, $6a

; C: Stamp_LoadSelected, $D993 bit 1 cleared (script callback)
Stamp_ObjLoadSelected::
    push hl                                       ; $6A65
    ld b, BANK(Stamp_LoadSelected)                ; $6A66
    ld hl, Stamp_LoadSelected                     ; $6A68
    call Far_Call                                 ; $6A6B
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $6A6E
    res 1, [hl]                                   ; $6A71
    pop hl                                        ; $6A73
    scf                                           ; $6A74
    ret                                           ; $6A75


; C: Stamp_SelectCategory and Stamp_LoadWindowMapDefault (script callback)
Stamp_ObjSelectCategory::
    push hl                                       ; $6A76
    ld b, BANK(Stamp_SelectCategory)              ; $6A77
    ld hl, Stamp_SelectCategory                   ; $6A79
    call Far_Call                                 ; $6A7C
    ld b, BANK(Stamp_LoadWindowMapDefault)        ; $6A7F
    ld hl, Stamp_LoadWindowMapDefault             ; $6A81
    call Far_Call                                 ; $6A84
    ld b, BANK(Stamp_LoadWindowMap)               ; $6A87
    ld hl, Stamp_LoadWindowMap                    ; $6A89
    call Far_Call                                 ; $6A8C
    ld b, BANK(Stamp_LoadSmallTiles)              ; $6A8F
    ld hl, Stamp_LoadSmallTiles                   ; $6A91
    call Far_Call                                 ; $6A94
    pop hl                                        ; $6A97
    scf                                           ; $6A98
    ret                                           ; $6A99


; C: Stamp_CursorCallback
Stamp_ObjCursorCallback::
    ld b, BANK(Stamp_CursorCallback)              ; $6A9A
    ld hl, Stamp_CursorCallback                   ; $6A9C
    call Far_Call                                 ; $6A9F
    ret                                           ; $6AA2


    db $e5, $e1, $fa, $c2, $d9, $ea, $a9, $d9, $e0, $d2, $fa, $c3, $d9, $ea, $aa, $d9
    db $e0, $d4, $fa, $d8, $d9, $ea, $c4, $d9, $6f, $fa, $d9, $d9, $ea, $c5, $d9, $67
    db $37, $c9, $a3, $6a, $1e, $1f, $40, $45

; C: Stamp_SelectCategory
Stamp_ObjSelectCategoryB::
    ld b, BANK(Stamp_SelectCategory)              ; $6ACB
    ld hl, Stamp_SelectCategory                   ; $6ACD
    call Far_Call                                 ; $6AD0
    ret                                           ; $6AD3


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz)
ObjScript_02_6AD4_Mode05_StampWindow_State06::
    db $c5, $6a, $9a, $6a, $cb, $6a

; C: Start ($D8D9 bit 3): copies the stamp choice $D996-$D997 into $D9AF ...; runs on its screen (05:06) in the core
; replays (port/entry_modes_kitty.csv); code read
Stamp_ObjPlaceOnStart::
    ld a, [wKeysNew]                              ; $6ADA
    bit PADB_START, a                             ; $6ADD
    jr z, jr_002_6b20                             ; $6ADF

Jump_002_6ae1:
    ld a, [wStamp_CursorUpdate_D996]              ; $6AE1
    ld [wStamp_ObjPlaceOnStart_D9AF], a           ; $6AE4
    ld a, [wStamp_CursorUpdate_D997]              ; $6AE7
    ld [wStamp_ObjPlaceOnStart_D9B0], a           ; $6AEA
    ld de, wStamp_CursorUpdate_D998               ; $6AED
    ld hl, wStamp_ObjPlaceOnStart_D9B1            ; $6AF0
    ld bc, $0010                                  ; $6AF3
    call Copy_DEtoHL                              ; $6AF6
    ld a, [wStamp_CursorUpdate_D9A8]              ; $6AF9
    ld [wStamp_ObjPlaceOnStart_D9C1], a           ; $6AFC
    ld a, [wStamp_ObjPlaceOnStart_D9C2]           ; $6AFF
    ld [wStamp_CursorUpdate_D9A9], a              ; $6B02
    ld a, [wStamp_ObjPlaceOnStart_D9C3]           ; $6B05
    ld [wStamp_CursorUpdate_D9AA], a              ; $6B08
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $6B0B
    set 0, [hl]                                   ; $6B0E
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $6B10
    set 1, [hl]                                   ; $6B13
    ld de, $6c5c                                  ; $6B15
    call Call_000_2205                            ; $6B18
    ld a, $06                                     ; $6B1B
    ldh [hState], a                               ; $6B1D
    ret                                           ; $6B1F


jr_002_6b20:
    ld a, [wKeysHeld]                             ; $6B20
    and PADF_A | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $6B23
    jr nz, jr_002_6b39                            ; $6B25

    ld a, [wKeysNew]                              ; $6B27
    bit PADB_B, a                                 ; $6B2A
    jr z, jr_002_6b39                             ; $6B2C

    ld de, Stamp_ObjWaitState06                   ; $6B2E
    call Obj_SetCallback                          ; $6B31
    ld a, $01                                     ; $6B34
    ldh [hState], a                               ; $6B36
    ret                                           ; $6B38


jr_002_6b39:
    ldh a, [hCopyReqSrcDstCnt]                    ; $6B39
    ld l, a                                       ; $6B3B
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $6B3C
    ld h, a                                       ; $6B3E
    ld a, [wKeysHeld]                             ; $6B3F
    bit PADB_LEFT, a                              ; $6B42
    jr nz, jr_002_6b4f                            ; $6B44

    bit PADB_RIGHT, a                             ; $6B46
    jr nz, jr_002_6b5d                            ; $6B48

    ld hl, $0000                                  ; $6B4A
    jr jr_002_6b69                                ; $6B4D

jr_002_6b4f:
    ld bc, hStamp_ObjPlaceOnStart_FFF0            ; $6B4F
    add hl, bc                                    ; $6B52
    ld a, h                                       ; $6B53
    cp $fe                                        ; $6B54
    jr nz, jr_002_6b5b                            ; $6B56

    ld hl, $ff00                                  ; $6B58

jr_002_6b5b:
    jr jr_002_6b69                                ; $6B5B

jr_002_6b5d:
    ld bc, $0010                                  ; $6B5D
    add hl, bc                                    ; $6B60
    ld a, h                                       ; $6B61
    cp $01                                        ; $6B62
    jr nz, jr_002_6b69                            ; $6B64

    ld hl, $0100                                  ; $6B66

jr_002_6b69:
    ld a, l                                       ; $6B69
    ldh [hCopyReqSrcDstCnt], a                    ; $6B6A
    ld a, h                                       ; $6B6C
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6B6D
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $6B6F
    ld l, a                                       ; $6B71
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $6B72
    ld h, a                                       ; $6B74
    ld a, [wKeysHeld]                             ; $6B75
    bit PADB_UP, a                                ; $6B78
    jr nz, jr_002_6b85                            ; $6B7A

    bit PADB_DOWN, a                              ; $6B7C
    jr nz, jr_002_6b93                            ; $6B7E

    ld hl, $0000                                  ; $6B80
    jr jr_002_6b9f                                ; $6B83

jr_002_6b85:
    ld bc, hStamp_ObjPlaceOnStart_FFF0            ; $6B85
    add hl, bc                                    ; $6B88
    ld a, h                                       ; $6B89
    cp $fe                                        ; $6B8A
    jr nz, jr_002_6b91                            ; $6B8C

    ld hl, $ff00                                  ; $6B8E

jr_002_6b91:
    jr jr_002_6b9f                                ; $6B91

jr_002_6b93:
    ld bc, $0010                                  ; $6B93
    add hl, bc                                    ; $6B96
    ld a, h                                       ; $6B97
    cp $01                                        ; $6B98
    jr nz, jr_002_6b9f                            ; $6B9A

    ld hl, $0100                                  ; $6B9C

jr_002_6b9f:
    ld a, l                                       ; $6B9F
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6BA0
    ld a, h                                       ; $6BA2
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6BA3
    ld a, [wStamp_ObjPlaceOnStart_D9AD]           ; $6BA5
    ld e, a                                       ; $6BA8
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6BA9
    sub e                                         ; $6BAB
    jp c, Jump_002_6ae1                           ; $6BAC

    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6BAF
    add e                                         ; $6BB1
    cp $a0                                        ; $6BB2
    jp nc, Jump_002_6ae1                          ; $6BB4

    ld a, [wStamp_ObjPlaceOnStart_D9AE]           ; $6BB7
    ld d, a                                       ; $6BBA
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6BBB
    sub d                                         ; $6BBD
    jp c, Jump_002_6ae1                           ; $6BBE

    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6BC1
    add d                                         ; $6BC3
    cp $90                                        ; $6BC4
    jp nc, Jump_002_6ae1                          ; $6BC6

    ld a, [wKeysNew]                              ; $6BC9
    bit PADB_A, a                                 ; $6BCC
    jr z, jr_002_6bee                             ; $6BCE

    push af                                       ; $6BD0
    ld a, SFX4_0B                                 ; $6BD1
    ld [wSndSfx4], a                              ; $6BD3
    pop af                                        ; $6BD6
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $6BD7
    set 2, [hl]                                   ; $6BDA
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6BDC
    ld [wStamp_ObjPlaceOnStart_D9AB], a           ; $6BDE
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6BE1
    ld [wStamp_ObjPlaceOnStart_D9AC], a           ; $6BE3
    ld b, BANK(Stamp_SetBlitArea)                 ; $6BE6
    ld hl, Stamp_SetBlitArea                      ; $6BE8
    call Far_Call                                 ; $6BEB

jr_002_6bee:
    ret                                           ; $6BEE


; C: moves on to 02:6ADA once the state hFF8E is 6
Stamp_ObjWaitState06::
    ldh a, [hState]                               ; $6BEF
    cp $06                                        ; $6BF1
    jr nz, jr_002_6bfb                            ; $6BF3

    ld de, Stamp_ObjPlaceOnStart                  ; $6BF5
    jp Obj_SetCallback                            ; $6BF8


jr_002_6bfb:
    ret                                           ; $6BFB


; C: restarts the script 02:6C4A when $D994 is 0
Stamp_ObjStep0::
    ld a, [wStamp_ObjSlideIn_D994]                ; $6BFC
    cp $00                                        ; $6BFF
    jr nz, jr_002_6c09                            ; $6C01

    ld de, $6c4a                                  ; $6C03
    jp Jump_000_2205                              ; $6C06


jr_002_6c09:
    ret                                           ; $6C09


; C: keeps the stamp x inside the photo ($D9AD); runs on its screen (05:06) in the core replays
; (port/entry_modes_kitty.csv); code read
Stamp_ObjClampX::
    push hl                                       ; $6C0A
    ld a, [wStamp_ObjPlaceOnStart_D9AD]           ; $6C0B
    ld e, a                                       ; $6C0E
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6C0F
    ld c, a                                       ; $6C11
    sub e                                         ; $6C12
    jr c, jr_002_6c1d                             ; $6C13

    ld a, c                                       ; $6C15
    add e                                         ; $6C16
    sub $9f                                       ; $6C17
    jr nc, jr_002_6c1d                            ; $6C19

    jr jr_002_6c23                                ; $6C1B

jr_002_6c1d:
    xor $ff                                       ; $6C1D
    inc a                                         ; $6C1F
    add c                                         ; $6C20
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $6C21

jr_002_6c23:
    ld a, [wStamp_ObjPlaceOnStart_D9AE]           ; $6C23
    ld d, a                                       ; $6C26
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6C27
    ld b, a                                       ; $6C29
    sub d                                         ; $6C2A
    jr c, jr_002_6c35                             ; $6C2B

    ld a, b                                       ; $6C2D
    add d                                         ; $6C2E
    sub $8f                                       ; $6C2F
    jr nc, jr_002_6c35                            ; $6C31

    jr jr_002_6c3b                                ; $6C33

jr_002_6c35:
    xor $ff                                       ; $6C35
    inc a                                         ; $6C37
    add b                                         ; $6C38
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6C39

jr_002_6c3b:
    pop hl                                        ; $6C3B
    scf                                           ; $6C3C
    ret                                           ; $6C3D


; C: read in the runs by Object_RunAll, ObjCmd_SetCallback, Object_CreateWithParam; first read on the screen
; Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6C3E_Mode05_StampWindow_State06::
    db $3a, $1f, $50, $48, $65, $6a, $16, $1f, $da, $6a, $09, $1f, $16, $1f, $b9, $7f
    db $0a, $6c, $01, $80, $00, $00, $65, $6a, $16, $1f, $da, $6a, $09, $1f, $6d, $1f
    db $00, $00, $7f, $1f, $00, $00, $16, $1f, $b9, $7f, $10, $1f, $04, $00, $76, $6a
    db $01, $80, $00, $00, $16, $1f, $fc, $6b, $08, $80, $00, $00, $09, $1f, $1e, $1f
    db $ba, $7f, $3e, $6c, $b9, $7f, $b9, $7f

; C: restarts the script 02:6D05 when $D994 is not 0
Stamp_ObjStepNot0::
    ld a, [wStamp_ObjSlideIn_D994]                ; $6C86
    cp $00                                        ; $6C89
    jr z, jr_002_6c93                             ; $6C8B

    ld de, $6d05                                  ; $6C8D
    jp Jump_000_2205                              ; $6C90


jr_002_6c93:
    ldh a, [hState]                               ; $6C93
    cp $06                                        ; $6C95
    jr z, jr_002_6ca2                             ; $6C97

    ld de, $6cfb                                  ; $6C99
    call Call_000_2205                            ; $6C9C
    jp Obj_HideSprite                             ; $6C9F


jr_002_6ca2:
    ld a, [wStamp_ObjPlaceOnStart_D9AD]           ; $6CA2
    ld e, a                                       ; $6CA5
    ld a, [wStamp_ObjPlaceOnStart_D9AE]           ; $6CA6
    ld d, a                                       ; $6CA9
    ld a, [wObject_RunAll_DC5E]                   ; $6CAA
    ld l, a                                       ; $6CAD
    ld a, [wObject_RunAll_DC5F]                   ; $6CAE
    ld h, a                                       ; $6CB1
    ld bc, hScratch_ObjPlace_FFF8                 ; $6CB2
    add hl, bc                                    ; $6CB5
    ld a, [hl+]                                   ; $6CB6
    sub e                                         ; $6CB7
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $6CB8
    inc hl                                        ; $6CBA
    ld a, [hl+]                                   ; $6CBB
    sub d                                         ; $6CBC
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6CBD
    ret                                           ; $6CBF


; C: restarts the script 02:6CF3 when the state is 6
Stamp_ObjAtState06::
    ldh a, [hState]                               ; $6CC0
    cp $06                                        ; $6CC2
    jr nz, jr_002_6ccc                            ; $6CC4

    ld de, $6cf3                                  ; $6CC6
    jp Jump_000_2205                              ; $6CC9


jr_002_6ccc:
    ret                                           ; $6CCC


; C: restarts the script 02:6CE3 when $D994 is 0
Stamp_ObjStep0B::
    ld a, [wStamp_ObjSlideIn_D994]                ; $6CCD
    cp $00                                        ; $6CD0
    jr nz, jr_002_6cda                            ; $6CD2

    ld de, $6ce3                                  ; $6CD4
    jp Jump_000_2205                              ; $6CD7


jr_002_6cda:
    ret                                           ; $6CDA


; C: read in the runs by Object_RunAll, ObjCmd_SetCallback, ObjCmd_Jump; first read on the screen
; Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6CDB_Mode05_StampWindow_State06::
    db $16, $1f, $86, $6c, $1e, $1f, $68, $45, $16, $1f, $b9, $7f, $01, $80, $00, $00
    db $16, $1f, $86, $6c, $1e, $1f, $68, $45, $16, $1f, $86, $6c, $1e, $1f, $68, $45
    db $16, $1f, $c0, $6c, $08, $80, $00, $00, $09, $1f, $01, $80, $00, $00, $16, $1f
    db $cd, $6c, $08, $80, $00, $00, $09, $1f, $db, $6c, $b9, $7f, $b9, $7f

; C: $D882 bit 2 cleared, $D994 = 1, slides in until y $F0; runs on its screen (05:06) in the core replays
; (port/entry_modes_kitty.csv); code read
Stamp_ObjSlideIn::
    ld a, [wLcdcShadow]                           ; $6D19
    and LCDCF_ON | LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_BLK01 | LCDCF_BG9C00 | LCDCF_OBJON | LCDCF_BGON ; $6D1C
    ld [wLcdcShadow], a                           ; $6D1E
    ld a, $01                                     ; $6D21
    ld [wStamp_ObjSlideIn_D994], a                ; $6D23
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6D26
    cp $f0                                        ; $6D28
    jr c, jr_002_6d5c                             ; $6D2A

    xor a                                         ; $6D2C
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $6D2D
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6D2F
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $6D31
    xor $ff                                       ; $6D33
    ld c, a                                       ; $6D35
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $6D36
    xor $ff                                       ; $6D38
    ld b, a                                       ; $6D3A
    inc bc                                        ; $6D3B
    sra b                                         ; $6D3C
    rr c                                          ; $6D3E
    ld a, b                                       ; $6D40
    and a                                         ; $6D41
    jr nz, jr_002_6d4e                            ; $6D42

    ld a, $02                                     ; $6D44
    ld [wStamp_ObjSlideIn_D994], a                ; $6D46
    call Obj_ClearCallback                        ; $6D49
    xor a                                         ; $6D4C
    ld c, a                                       ; $6D4D

jr_002_6d4e:
    ld a, c                                       ; $6D4E
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6D4F
    ld a, b                                       ; $6D51
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6D52
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6D54
    add $58                                       ; $6D56
    ld [wDoodleFromShutterbug], a                 ; $6D58
    ret                                           ; $6D5B


jr_002_6d5c:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $6D5C
    ld c, a                                       ; $6D5E
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $6D5F
    ld b, a                                       ; $6D61
    ld hl, $ff40                                  ; $6D62
    add hl, bc                                    ; $6D65
    ld a, l                                       ; $6D66
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6D67
    ld a, h                                       ; $6D69
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6D6A
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6D6C
    add $58                                       ; $6D6E
    ld [wDoodleFromShutterbug], a                 ; $6D70
    ret                                           ; $6D73


; C: $D994 = 3, slides until y $38; runs on its screen (05:06) in the core replays (port/entry_modes_kitty.csv); code
; read
Stamp_ObjSlideOut::
    ld a, $03                                     ; $6D74
    ld [wStamp_ObjSlideIn_D994], a                ; $6D76
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6D79
    cp $38                                        ; $6D7B
    jr c, jr_002_6db8                             ; $6D7D

    xor a                                         ; $6D7F
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $6D80
    ld a, $39                                     ; $6D82
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6D84
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $6D86
    xor $ff                                       ; $6D88
    ld c, a                                       ; $6D8A
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $6D8B
    xor $ff                                       ; $6D8D
    ld b, a                                       ; $6D8F
    inc bc                                        ; $6D90
    sra b                                         ; $6D91
    rr c                                          ; $6D93
    ld a, b                                       ; $6D95
    and a                                         ; $6D96
    jr nz, jr_002_6daa                            ; $6D97

    ld a, [wLcdcShadow]                           ; $6D99
    or $04                                        ; $6D9C
    ld [wLcdcShadow], a                           ; $6D9E
    xor a                                         ; $6DA1
    ld [wStamp_ObjSlideIn_D994], a                ; $6DA2
    call Obj_ClearCallback                        ; $6DA5
    xor a                                         ; $6DA8
    ld c, a                                       ; $6DA9

jr_002_6daa:
    ld a, c                                       ; $6DAA
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6DAB
    ld a, b                                       ; $6DAD
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6DAE
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6DB0
    add $58                                       ; $6DB2
    ld [wDoodleFromShutterbug], a                 ; $6DB4
    ret                                           ; $6DB7


jr_002_6db8:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $6DB8
    ld c, a                                       ; $6DBA
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $6DBB
    ld b, a                                       ; $6DBD
    ld hl, $00c0                                  ; $6DBE
    add hl, bc                                    ; $6DC1
    ld a, l                                       ; $6DC2
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6DC3
    ld a, h                                       ; $6DC5
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6DC6
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6DC8
    add $58                                       ; $6DCA
    ld [wDoodleFromShutterbug], a                 ; $6DCC
    ret                                           ; $6DCF


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetCallback; first read on the screen
; Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6DD0_Mode05_StampWindow_State06::
    db $3a, $1f, $00, $38, $98, $1f, $93, $d9, $01, $ba, $1e, $30, $00, $16, $1f, $19
    db $6d, $7f, $1f, $00, $00, $10, $1f, $01, $00, $a2, $1f, $93, $d9, $01, $16, $1f
    db $74, $6d, $7f, $1f, $00, $00, $10, $1f, $01, $00, $1e, $1f, $d4, $6d, $09, $1f
    db $d0, $6d, $b9, $7f, $b9, $7f

; C: the distance between the object position and its target; runs on its screen (06:0D) in the core replays
; (port/entry_modes_kitty.csv); code read
Printing_ObjPosDelta::
    ldh a, [hPlayMenu_CursorUpdate_FFD3]          ; $6E06
    xor $ff                                       ; $6E08
    ld e, a                                       ; $6E0A
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $6E0B
    xor $ff                                       ; $6E0D
    ld d, a                                       ; $6E0F
    inc de                                        ; $6E10
    ld bc, $00cc                                  ; $6E11
    ld a, [wPrintIntensity]                       ; $6E14
    call Mul_8x16                                 ; $6E17
    ld a, h                                       ; $6E1A
    add $18                                       ; $6E1B
    ld h, a                                       ; $6E1D
    ld l, $00                                     ; $6E1E
    add hl, de                                    ; $6E20
    sra h                                         ; $6E21
    rr l                                          ; $6E23
    sra h                                         ; $6E25
    rr l                                          ; $6E27
    sra h                                         ; $6E29
    rr l                                          ; $6E2B
    ld a, l                                       ; $6E2D
    ldh [hCopyReqSrcDstCnt + $2], a               ; $6E2E
    ld a, h                                       ; $6E30
    ldh [hCopyReqSrcDstCnt + $3], a               ; $6E31
    ld a, [wKeysHeld]                             ; $6E33
    bit PADB_START, a                             ; $6E36
    jr nz, jr_002_6e46                            ; $6E38

    call Obj_ClearCallback                        ; $6E3A
    call Obj_End                                  ; $6E3D
    ld de, $7fc0                                  ; $6E40
    jp Jump_000_2205                              ; $6E43


jr_002_6e46:
    ret                                           ; $6E46


; C: moves while the distance is not 0 (script 02:6E7F); runs on its screen (06:0D) in the core replays
; (port/entry_modes_kitty.csv); code read
Printing_ObjMoveA::
    call Printing_ObjPosDelta                     ; $6E47
    ld a, l                                       ; $6E4A
    or h                                          ; $6E4B
    jr z, jr_002_6e54                             ; $6E4C

    ld de, $6e7f                                  ; $6E4E
    call Call_000_2205                            ; $6E51

jr_002_6e54:
    ret                                           ; $6E54


; C: moves once the distance is 0 (script 02:6E87); runs on its screen (06:0D) in the core replays
; (port/entry_modes_kitty.csv); code read
Printing_ObjMoveB::
    call Printing_ObjPosDelta                     ; $6E55
    ld a, l                                       ; $6E58
    or h                                          ; $6E59
    jr nz, jr_002_6e62                            ; $6E5A

    ld de, $6e87                                  ; $6E5C
    call Call_000_2205                            ; $6E5F

jr_002_6e62:
    ret                                           ; $6E62


; C: y = [$DAD6] x $CC + $18; runs on its screen (06:0D) in the core replays (port/entry_modes_kitty.csv); code read
Printing_ObjPosFromDAD6::
    push hl                                       ; $6E63
    ld bc, $00cc                                  ; $6E64
    ld a, [wPrintIntensity]                       ; $6E67
    call Mul_8x16                                 ; $6E6A
    ld a, h                                       ; $6E6D
    add $18                                       ; $6E6E
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $6E70
    ld a, $90                                     ; $6E72
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $6E74
    pop hl                                        ; $6E76
    scf                                           ; $6E77
    ret                                           ; $6E78


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetCallback; first read on the screen
; Mode06_Printing_State0D (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6E79_Mode06_Printing_State0D::
    db $63, $6e, $02, $80, $00, $00, $16, $1f, $55, $6e, $1e, $1f, $c0, $45, $16, $1f
    db $47, $6e, $1e, $1f, $cc, $45, $79, $6e, $33, $6e, $b9, $7f

; I: leftover: 106 bytes (02:6E95-6EFE) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_6E95::
    db $fa, $d8, $d8, $cb, $5f, $20, $03, $c3, $12, $22, $c9, $cd, $95, $6e, $fa, $d9
    db $d8, $cb, $67, $28, $0b, $21, $fc, $d3, $cb, $c6, $11, $ed, $6e, $c3, $05, $22
    db $c9, $cd, $95, $6e, $fa, $d9, $d8, $cb, $6f, $28, $0b, $21, $fc, $d3, $cb, $86
    db $11, $e1, $6e, $c3, $05, $22, $c9, $fa, $fc, $d3, $cb, $47, $20, $06, $2e, $e1
    db $26, $6e, $37, $c9, $2e, $ed, $26, $6e, $37, $c9, $cc, $6e, $3a, $1f, $28, $88
    db $16, $1f, $a0, $6e, $1e, $1f, $78, $45, $3a, $1f, $78, $88, $16, $1f, $b6, $6e
    db $1e, $1f, $9c, $45, $df, $6e, $b9, $7f, $b9, $7f

; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, ObjCmd_Jump; first read on the screen
; Mode06_Printing_State1F (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6EFF_Mode06_Printing_State1F::
    db $cc, $1f, $08, $00, $70, $69, $00, $9c, $80, $00, $2f, $cc, $1f, $08, $00, $f0
    db $69, $00, $9c, $80, $00, $2f, $1e, $1f, $ff, $6e

; C: ret
Obj_Ret6F19::
    ret                                           ; $6F19


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz)
ObjScript_02_6F1A_Mode06_Printing_State1F::
    db $ff, $6e, $19, $6f, $b9, $7f

; C: hFFCB-hFFCC = $D939-$D93A (script callback)
Printing_ObjSpeedFromD939::
    push hl                                       ; $6F20
    ld a, [wMode06_State1A_D939]                  ; $6F21
    ldh [hCopyReqSrcDstCnt], a                    ; $6F24
    ld a, [wMode06_State1A_D93A]                  ; $6F26
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6F29
    pop hl                                        ; $6F2B
    scf                                           ; $6F2C
    ret                                           ; $6F2D


; C: read in the runs by Object_RunAll, ObjCmd_SetPos, ObjCmd_Jump; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6F2E_Mode06_Printing_State1F::
    db $3a, $1f, $cc, $14, $20, $6f, $1e, $1f, $08, $46

; C: B ($D8D9 bit 1) stops the object (speed 0), ... (the falling-fruit game while printing); runs on its screen
; (06:1B) in the core replays (port/entry_modes_kitty.csv); code read
AppleGame_ObjKeys::
    ld a, [wKeysNew]                              ; $6F38
    bit PADB_B, a                                 ; $6F3B
    jr z, jr_002_6f4d                             ; $6F3D

    xor a                                         ; $6F3F
    ldh [hCopyReqSrcDstCnt], a                    ; $6F40
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6F42
    ld a, $80                                     ; $6F44
    ldh [hObject_RunAll_FFC9], a                  ; $6F46
    ldh [hObject_RunAll_FFCA], a                  ; $6F48
    jp Obj_ClearCallback                          ; $6F4A


jr_002_6f4d:
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6F4D
    cp $d0                                        ; $6F4F
    jr z, jr_002_6f57                             ; $6F51

    cp $d1                                        ; $6F53
    jr nz, jr_002_6f5f                            ; $6F55

jr_002_6f57:
    xor a                                         ; $6F57
    ldh [hCopyReqSrcDstCnt], a                    ; $6F58
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6F5A
    jp Obj_ClearCallback                          ; $6F5C


jr_002_6f5f:
    ret                                           ; $6F5F


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetCallback; first read on the screen
; Mode06_Printing_State1F (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_6F60_Mode06_Printing_State1F::
    db $2e, $6f, $38, $6f, $b9, $7f, $2e, $6f, $4d, $6f, $b9, $7f, $16, $1f, $c8, $6f
    db $3a, $1f, $c0, $4c, $20, $6f, $16, $1f, $c8, $6f, $1e, $1f, $f4, $45, $16, $1f
    db $dc, $6f, $08, $80, $34, $5e, $08, $80, $70, $5e, $08, $80, $cc, $5e, $08, $80
    db $d8, $5d, $1e, $1f, $76, $6f, $16, $1f, $a8, $6f, $1e, $1f, $00, $46

; C: $D886 = $49 - hFFD2; runs on its screen (06:1B) in the core replays (port/entry_modes_kitty.csv); code read
AppleGame_ObjSetD886::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6F9E
    xor $ff                                       ; $6FA0
    add $49                                       ; $6FA2
    ld [wScxShadow], a                            ; $6FA4
    ret                                           ; $6FA7


; C: by the frame hFFD2 ($C0, $C1, $C2 ...); runs on its screen (06:20) in the core replays
; (port/entry_modes_kitty.csv); code read
AppleGame_ObjFruitKind::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6FA8
    cp $c0                                        ; $6FAA
    jr z, jr_002_6fba                             ; $6FAC

    cp $c1                                        ; $6FAE
    jr z, jr_002_6fba                             ; $6FB0

    cp $c2                                        ; $6FB2
    jr z, jr_002_6fba                             ; $6FB4

    cp $c3                                        ; $6FB6
    jr nz, jr_002_6fc7                            ; $6FB8

jr_002_6fba:
    ld a, $04                                     ; $6FBA
    ld [wMode06_State21_D8E0], a                  ; $6FBC
    xor a                                         ; $6FBF
    ldh [hCopyReqSrcDstCnt], a                    ; $6FC0
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6FC2
    jp Obj_ClearCallback                          ; $6FC4


jr_002_6fc7:
    ret                                           ; $6FC7


; C: A ($D8D9 bit 0): sound $03 on channel 2 ...; runs on its screen (06:1B) in the core replays
; (port/entry_modes_kitty.csv); code read
AppleGame_ObjCatch::
    ld a, [wKeysNew]                              ; $6FC8
    bit PADB_A, a                                 ; $6FCB
    jr z, jr_002_6fdc                             ; $6FCD

    push af                                       ; $6FCF
    ld a, SFX3_03                                 ; $6FD0
    ld [wSndSfx3], a                              ; $6FD2
    pop af                                        ; $6FD5
    ld de, $6f7e                                  ; $6FD6
    call Call_000_2205                            ; $6FD9

jr_002_6fdc:
    call AppleGame_ObjSetD886                     ; $6FDC
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $6FDF
    cp $d0                                        ; $6FE1
    jr z, jr_002_6fe9                             ; $6FE3

    cp $d1                                        ; $6FE5
    jr nz, jr_002_6ff6                            ; $6FE7

jr_002_6fe9:
    ld a, $08                                     ; $6FE9
    ld [wMode06_State21_D8E0], a                  ; $6FEB
    xor a                                         ; $6FEE
    ldh [hCopyReqSrcDstCnt], a                    ; $6FEF
    ldh [hCopyReqSrcDstCnt + $1], a               ; $6FF1
    jp Obj_ClearCallback                          ; $6FF3


jr_002_6ff6:
    ld a, [wKeysNew]                              ; $6FF6
    bit PADB_B, a                                 ; $6FF9
    jr z, jr_002_701d                             ; $6FFB

    ld a, $02                                     ; $6FFD
    ld [wMode06_State21_D8E0], a                  ; $6FFF
    push af                                       ; $7002
    ld a, SFX3_09                                 ; $7003
    ld [wSndSfx3], a                              ; $7005
    pop af                                        ; $7008
    ldh a, [hCopyReqSrcDstCnt]                    ; $7009
    cpl                                           ; $700B
    add $01                                       ; $700C
    ldh [hCopyReqSrcDstCnt], a                    ; $700E
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $7010
    cpl                                           ; $7012
    adc $00                                       ; $7013
    ldh [hCopyReqSrcDstCnt + $1], a               ; $7015
    ld de, $6f96                                  ; $7017
    jp Jump_000_2205                              ; $701A


jr_002_701d:
    ret                                           ; $701D


; C: $D8E0 = 0
Obj_ClearD8E0_C::
    xor a                                         ; $701E
    ld [wMode06_State21_D8E0], a                  ; $701F
    ret                                           ; $7022


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz)
ObjScript_02_7023_Mode06_Printing_State1F::
    db $6c, $6f, $b9, $7f, $1e, $70

; C: the falling fruit at the bottom (hFFD2 = $D0 / $D1): $D8E0 = 8, speed 0, callback cleared; first run in the core
; replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06
; states $23 / $24); code read
PrintGame_ObjCheckLanded::
    call AppleGame_ObjSetD886                     ; $7029
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $702C
    cp $d0                                        ; $702E
    jr z, jr_002_7036                             ; $7030

    cp $d1                                        ; $7032
    jr nz, jr_002_7043                            ; $7034

jr_002_7036:
    ld a, $08                                     ; $7036
    ld [wMode06_State21_D8E0], a                  ; $7038
    xor a                                         ; $703B
    ldh [hCopyReqSrcDstCnt], a                    ; $703C
    ldh [hCopyReqSrcDstCnt + $1], a               ; $703E
    jp Obj_ClearCallback                          ; $7040


jr_002_7043:
    ret                                           ; $7043


; C: read in the runs by PrintGame_ObjCheckLanded, Object_RunAll, Object_CreateWithParam
ObjScript_02_7044_PrintGame_ObjCheckLanded::
    db $16, $1f, $29, $70, $3a, $1f, $c0, $4c, $20, $6f, $1e, $1f, $f4, $45, $44, $70
    db $b9, $7f, $1e, $70, $3a, $1f, $08, $10, $1e, $1f, $14, $46, $58, $70, $b9, $7f
    db $b9, $7f

    db $21, $f0, $ff, $09, $4d, $44, $c9, $cd, $a2, $73, $cd, $66, $70, $cd, $a9, $73
    db $f0, $d4, $fe, $f0, $d2, $12, $22, $c9, $e5, $f0, $d4, $d6, $28, $cb, $2f, $cb
    db $2f, $cb, $2f, $e0, $d8, $4f, $06, $00, $21, $a7, $70, $09, $fa, $4f, $d9, $86
    db $ea, $4f, $d9, $11, $a0, $97, $06, $01, $21, $d4, $67, $cd, $65, $01, $e1, $37
    db $c9, $04, $04, $04, $03, $03, $03, $02, $02, $02, $01, $01, $01, $01, $7e, $70
    db $7f, $1f, $00, $01, $09, $20, $d8, $ff, $94, $46, $94, $46, $94, $46, $88, $46
    db $88, $46, $88, $46, $7c, $46, $7c, $46, $7c, $46, $70, $46, $70, $46, $70, $46
    db $70, $46, $b4, $70, $6d, $70, $b9, $7f

; C: is the fruit within 8 pixels of Kitty ($D94D / $D94E); first run in the core replays of tools/kitty_core_paths.py
; (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 / $24); code read
PrintGame_ObjCheckCatch::
    ld a, [wPrintGame_ObjCheckCatch_D94D]         ; $70DE
    add $08                                       ; $70E1
    ld c, a                                       ; $70E3
    sub $10                                       ; $70E4
    ld b, a                                       ; $70E6
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $70E7
    sub $08                                       ; $70E9
    cp c                                          ; $70EB
    ret nc                                        ; $70EC

    add $10                                       ; $70ED
    cp b                                          ; $70EF
    jr c, jr_002_7102                             ; $70F0

    ld a, [wPrintGame_ObjCheckCatch_D94E]         ; $70F2
    sub $10                                       ; $70F5
    ld c, a                                       ; $70F7
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $70F8
    dec a                                         ; $70FA
    cp c                                          ; $70FB
    jr c, jr_002_7102                             ; $70FC

    sub $10                                       ; $70FE
    cp c                                          ; $7100
    ret                                           ; $7101


jr_002_7102:
    and a                                         ; $7102
    ret                                           ; $7103


; C: BC + $20 (the fall speed grows); first run in the core replays of tools/kitty_core_paths.py
; (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 / $24); code read
PrintGame_AddGravity::
    ld hl, $0020                                  ; $7104
    add hl, bc                                    ; $7107
    ld c, l                                       ; $7108
    ld b, h                                       ; $7109
    ret                                           ; $710A


; C: BC kept between -$180 and +$180; first run in the core replays of tools/kitty_core_paths.py
; (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 / $24); code read
PrintGame_ClampSpeed::
    bit 7, b                                      ; $710B
    jr z, jr_002_7118                             ; $710D

    ld hl, $0180                                  ; $710F
    add hl, bc                                    ; $7112
    ret c                                         ; $7113

    ld bc, $fe80                                  ; $7114
    ret                                           ; $7117


jr_002_7118:
    ld hl, $fe80                                  ; $7118
    add hl, bc                                    ; $711B
    ret nc                                        ; $711C

    ld bc, $0180                                  ; $711D
    ret                                           ; $7120


; C: per-frame fall: speed + gravity, clamped; at y $78 the fruit bounces (hFFD8 counts the bounces up to 3); first
; run in the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit
; game, mode $06 states $23 / $24); code read
PrintGame_ObjFall::
    call Obj_GetSpriteBC                          ; $7121
    call PrintGame_AddGravity                     ; $7124
    call PrintGame_ClampSpeed                     ; $7127
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $712A
    cp $78                                        ; $712C
    jr c, jr_002_7156                             ; $712E

    xor a                                         ; $7130
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $7131
    ld a, $78                                     ; $7133
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $7135
    ldh a, [hPuzzle15_ObjMoving_FFD8]             ; $7137
    inc a                                         ; $7139
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $713A
    cp $03                                        ; $713C
    jr nc, jr_002_7153                            ; $713E

    sra b                                         ; $7140
    rr c                                          ; $7142
    ld a, c                                       ; $7144
    cpl                                           ; $7145
    ld c, a                                       ; $7146
    ld a, b                                       ; $7147
    cpl                                           ; $7148
    ld b, a                                       ; $7149
    inc bc                                        ; $714A
    ld de, $71d2                                  ; $714B
    call Call_000_2205                            ; $714E
    jr jr_002_7156                                ; $7151

jr_002_7153:
    ld bc, $0000                                  ; $7153

jr_002_7156:
    call Obj_SetSpriteBC                          ; $7156
    call PrintGame_ObjCheckCatch                  ; $7159
    jr nc, jr_002_7174                            ; $715C

    push af                                       ; $715E
    ld a, SFX1_05                                 ; $715F
    ld [wSndSfx1], a                              ; $7161
    pop af                                        ; $7164
    call Obj_End                                  ; $7165
    ld de, ObjScript_02_7044_PrintGame_ObjCheckLanded + $94 ; $7168
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $716B
    ld c, a                                       ; $716D
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $716E
    ld b, a                                       ; $7170
    call Object_CreateWithParam                   ; $7171

jr_002_7174:
    ret                                           ; $7174


; C: a random start: x = [$D94C] + rnd(0-$7F) + $10, y = $28 + rnd(0-$0F); first run in the core replays of
; tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 /
; $24); code read
PrintGame_ObjRandomStart::
    push hl                                       ; $7175
    call Rng_Next                                 ; $7176
    and $7f                                       ; $7179
    ld c, a                                       ; $717B
    ld a, [wPrintGame_SaveKittyPos_D94C]          ; $717C
    add c                                         ; $717F
    add $10                                       ; $7180
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $7182
    call Rng_Next                                 ; $7184
    and $0f                                       ; $7187
    add $28                                       ; $7189
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $718B
    pop hl                                        ; $718D
    scf                                           ; $718E
    ret                                           ; $718F


; C: read in the runs by Object_RunAll, ObjCmd_JumpRandom, Object_CreateWithParam
ObjScript_02_7190_Object_RunAll::
    db $75, $1f, $00, $7f, $1f, $00, $00, $16, $1f, $b9, $7f, $75, $71, $06, $80, $54
    db $60, $06, $80, $58, $60, $05, $80, $54, $60, $05, $80, $58, $60, $04, $80, $54
    db $60, $04, $80, $58, $60, $03, $80, $5c, $60, $03, $80, $6c, $60, $03, $80, $7c
    db $60, $03, $80, $8c, $60, $16, $1f, $21, $71, $f8, $1f, $03, $54, $46, $5c, $46
    db $a0, $46, $10, $1f, $1e, $00, $02, $1f, $90, $71, $b9, $7f, $b9, $7f, $30, $20
    db $d8, $71, $10, $1f, $28, $00, $1e, $1f, $de, $71

; C: Obj_End when no fruit is left ([$D950] = 0); first run in the core replays of tools/kitty_core_paths.py
; (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 / $24); code read
PrintGame_ObjEndIfNoneLeft::
    ld a, [wMode06_State10_D950]                  ; $71EA
    and a                                         ; $71ED
    jp z, Obj_End                                 ; $71EE

    ret                                           ; $71F1


; C: read in the runs by Object_RunAll, ObjCmd_CopyAtLine20, Vram_CopyHBlank
ObjScript_02_71F2_PrintGame_ObjEndIfNoneLeft::
    INCBIN "data/bank_02/ObjScript_02_71F2_PrintGame_ObjEndIfNoneLeft.bin" ; $71F2, 339 bytes
; C: read in the runs by Object_CreateWithParam
ObjScript_02_7345_Object_CreateWithParam::
    db $0a, $72, $b9, $7f, $b9, $7f

; C: push hl / pop hl, carry set: a script command that does nothing; first run in the core replays of
; tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 /
; $24); code read
Obj_ScriptNop::
    push hl                                       ; $734B
    pop hl                                        ; $734C
    scf                                           ; $734D
    ret                                           ; $734E


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetPos
ObjScript_02_734F_Object_RunAll::
    db $3a, $1f, $50, $38, $4b, $73, $1e, $1f, $a8, $46, $4f, $73, $b9, $7f, $b9, $7f

    db $09, $1f, $f0, $44, $fe, $10, $20, $fa, $fa, $4c, $d9, $e0, $43, $c9, $c9, $5f
    db $73, $61, $73, $6d, $73

; C: BC = hFFCB-hFFCC; first run in the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the
; prints that end with the fruit game, mode $06 states $23 / $24); code read
Obj_GetSpeed::
    ldh a, [hCopyReqSrcDstCnt]                    ; $7374
    ld c, a                                       ; $7376
    ldh a, [hCopyReqSrcDstCnt + $1]               ; $7377
    ld b, a                                       ; $7379
    ret                                           ; $737A


; C: Kitty kept between x $08 and $98 (the fraction cleared at the edges); first run in the core replays of
; tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 /
; $24); code read
PrintGame_ClampX::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $737B
    cp $08                                        ; $737D
    jr nc, jr_002_738c                            ; $737F

    ld bc, $0000                                  ; $7381
    ld a, $00                                     ; $7384
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $7386
    ld a, $08                                     ; $7388
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $738A

jr_002_738c:
    cp $98                                        ; $738C
    jr c, jr_002_739b                             ; $738E

    ld bc, $0000                                  ; $7390
    ld a, $ff                                     ; $7393
    ldh [hPlayMenu_CursorUpdate_FFD1], a          ; $7395
    ld a, $97                                     ; $7397
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $7399

jr_002_739b:
    ld a, c                                       ; $739B
    ldh [hCopyReqSrcDstCnt], a                    ; $739C
    ld a, b                                       ; $739E
    ldh [hCopyReqSrcDstCnt + $1], a               ; $739F
    ret                                           ; $73A1


; C: BC = hFFCD-hFFCE; first run in the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the
; prints that end with the fruit game, mode $06 states $23 / $24); code read
Obj_GetSpriteBC::
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $73A2
    ld c, a                                       ; $73A4
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $73A5
    ld b, a                                       ; $73A7
    ret                                           ; $73A8


; C: hFFCD-hFFCE = BC; first run in the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the
; prints that end with the fruit game, mode $06 states $23 / $24); code read
Obj_SetSpriteBC::
    ld a, c                                       ; $73A9
    ldh [hCopyReqSrcDstCnt + $2], a               ; $73AA
    ld a, b                                       ; $73AC
    ldh [hCopyReqSrcDstCnt + $3], a               ; $73AD
    ret                                           ; $73AF


    db $cb, $78, $28, $09, $21, $80, $01, $09, $d8, $01, $80, $fe, $c9, $21, $80, $fe
    db $09, $d0, $01, $80, $01, $c9

; C: Left / Right held ($D8D8 bits 5 / 4): the speed BC - 8 / + 8, kept in range; first run in the core replays of
; tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states $23 /
; $24); code read
PrintGame_SpeedFromKeys::
    ld a, [wKeysHeld]                             ; $73C6
    bit PADB_LEFT, a                              ; $73C9
    jr z, jr_002_73d8                             ; $73CB

    ld hl, hScratch_ObjPlace_FFF8                 ; $73CD
    add hl, bc                                    ; $73D0
    ld c, l                                       ; $73D1
    ld b, h                                       ; $73D2
    bit 7, b                                      ; $73D3
    jr z, jr_002_73f7                             ; $73D5

    ret                                           ; $73D7


jr_002_73d8:
    ld a, [wKeysHeld]                             ; $73D8
    bit PADB_RIGHT, a                             ; $73DB
    jr z, jr_002_73ea                             ; $73DD

    ld hl, $0008                                  ; $73DF
    add hl, bc                                    ; $73E2
    ld c, l                                       ; $73E3
    ld b, h                                       ; $73E4
    bit 7, b                                      ; $73E5
    jr nz, jr_002_73ee                            ; $73E7

    ret                                           ; $73E9


jr_002_73ea:
    bit 7, b                                      ; $73EA
    jr z, jr_002_73f7                             ; $73EC

jr_002_73ee:
    ld hl, $0010                                  ; $73EE
    add hl, bc                                    ; $73F1
    ld c, l                                       ; $73F2
    ld b, h                                       ; $73F3
    jr c, jr_002_7400                             ; $73F4

    ret                                           ; $73F6


jr_002_73f7:
    ld hl, hStamp_ObjPlaceOnStart_FFF0            ; $73F7
    add hl, bc                                    ; $73FA
    ld c, l                                       ; $73FB
    ld b, h                                       ; $73FC
    jr nc, jr_002_7400                            ; $73FD

    ret                                           ; $73FF


jr_002_7400:
    ld bc, $0000                                  ; $7400
    ret                                           ; $7403


    db $cb, $78, $28, $09, $21, $80, $01, $09, $d8, $01, $80, $fe, $c9, $21, $80, $fe
    db $09, $d0, $01, $80, $01, $c9, $cb, $78, $28, $09, $21, $80, $01, $09, $d8, $01
    db $80, $fe, $c9, $21, $80, $fe, $09, $d0, $01, $80, $01, $c9

Call_002_7430:
    ld a, [wKeysHeld]                             ; $7430
    bit PADB_LEFT, a                              ; $7433
    jr z, jr_002_743e                             ; $7435

    ld hl, hStamp_ObjPlaceOnStart_FFF0            ; $7437
    add hl, bc                                    ; $743A
    ld c, l                                       ; $743B
    ld b, h                                       ; $743C
    ret                                           ; $743D


jr_002_743e:
    ld a, [wKeysHeld]                             ; $743E
    bit PADB_RIGHT, a                             ; $7441
    jr z, jr_002_744c                             ; $7443

    ld hl, $0010                                  ; $7445
    add hl, bc                                    ; $7448
    ld c, l                                       ; $7449
    ld b, h                                       ; $744A
    ret                                           ; $744B


jr_002_744c:
    ret                                           ; $744C


; C: Kitty position into $D94D / $D94E, and [$D94C] = x - $50 kept in 0-$5F (where the next fruit falls); first run in
; the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end with the fruit game,
; mode $06 states $23 / $24); code read
PrintGame_SaveKittyPos::
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $744D
    ld [wPrintGame_ObjCheckCatch_D94D], a         ; $744F
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7452
    ld [wPrintGame_ObjCheckCatch_D94E], a         ; $7454
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $7457
    sub $50                                       ; $7459
    jr c, jr_002_7465                             ; $745B

    cp $60                                        ; $745D
    jr nc, jr_002_746a                            ; $745F

    ld [wPrintGame_SaveKittyPos_D94C], a          ; $7461
    ret                                           ; $7464


jr_002_7465:
    xor a                                         ; $7465
    ld [wPrintGame_SaveKittyPos_D94C], a          ; $7466
    ret                                           ; $7469


jr_002_746a:
    ld a, $60                                     ; $746A
    ld [wPrintGame_SaveKittyPos_D94C], a          ; $746C
    ret                                           ; $746F


    db $cd, $74, $73, $cd, $c6, $73, $cd, $7b, $73, $cd, $4d, $74, $fa, $d9, $d8, $cb
    db $47, $28, $0e, $f5, $3e, $3a, $ea, $60, $d0, $f1, $11, $6e, $76, $cd, $05, $22
    db $c9, $78, $b1, $28, $07, $11, $1e, $76, $cd, $05, $22, $c9, $fa, $d9, $d8, $cb
    db $4f, $28, $07, $11, $53, $77, $cd, $05, $22, $c9, $c9

; C: Kitty: speed from the keys, x clamped, position saved; A ($D8D9 bit 0) jumps (sound $3A on channel 1, script
; 02:7686); first run in the core replays of tools/kitty_core_paths.py (port/cov_kitty_paths.npz: the prints that end
; with the fruit game, mode $06 states $23 / $24); code read
PrintGame_ObjKitty::
    call Obj_GetSpeed                             ; $74AB
    call PrintGame_SpeedFromKeys                  ; $74AE
    call PrintGame_ClampX                         ; $74B1
    call PrintGame_SaveKittyPos                   ; $74B4
    ld a, [wKeysNew]                              ; $74B7
    bit PADB_A, a                                 ; $74BA
    jr z, jr_002_74cc                             ; $74BC

    push af                                       ; $74BE
    ld a, SFX1_3A                                 ; $74BF
    ld [wSndSfx1], a                              ; $74C1
    pop af                                        ; $74C4
    ld de, ObjScript_02_7686_PrintGame_ObjKitty   ; $74C5
    call Call_000_2205                            ; $74C8
    ret                                           ; $74CB


jr_002_74cc:
    ld a, b                                       ; $74CC
    or c                                          ; $74CD
    jr z, jr_002_74d7                             ; $74CE

    ld de, $7646                                  ; $74D0
    call Call_000_2205                            ; $74D3
    ret                                           ; $74D6


jr_002_74d7:
    ld a, [wKeysNew]                              ; $74D7
    bit PADB_B, a                                 ; $74DA
    jr z, jr_002_74e5                             ; $74DC

    ld de, $7753                                  ; $74DE
    call Call_000_2205                            ; $74E1
    ret                                           ; $74E4


jr_002_74e5:
    ret                                           ; $74E5


    db $cd, $74, $73, $cd, $c6, $73, $cd, $b0, $73, $cd, $7b, $73, $cd, $4d, $74, $fa
    db $d9, $d8, $cb, $47, $28, $0e, $f5, $3e, $3a, $ea, $60, $d0, $f1, $11, $6e, $76
    db $cd, $05, $22, $c9, $fa, $d8, $d8, $cb, $67, $28, $07, $11, $46, $76, $cd, $05
    db $22, $c9, $fa, $d8, $d8, $cb, $6f, $20, $0b, $78, $b1, $20, $07, $11, $fe, $75
    db $cd, $05, $22, $c9, $c9, $cd, $74, $73, $cd, $c6, $73, $cd, $b0, $73, $cd, $7b
    db $73, $cd, $4d, $74, $fa, $d9, $d8, $cb, $47, $28, $0e, $f5, $3e, $3a, $ea, $60
    db $d0, $f1, $11, $86, $76, $cd, $05, $22, $c9, $fa, $d8, $d8, $cb, $6f, $28, $07
    db $11, $1e, $76, $cd, $05, $22, $c9, $fa, $d8, $d8, $cb, $67, $20, $0b, $78, $b1
    db $20, $07, $11, $0e, $76, $cd, $05, $22, $c9, $c9

Call_002_7570:
    ld hl, $0040                                  ; $7570
    add hl, bc                                    ; $7573
    ld c, l                                       ; $7574
    ld b, h                                       ; $7575
    ret                                           ; $7576


    db $cd, $a2, $73, $cd, $70, $75, $fa, $d8, $d8, $cb, $47, $20, $07, $cb, $78, $28
    db $03, $01, $00, $00, $f0, $d4, $fe, $78, $38, $0d, $3e, $78, $e0, $d4, $01, $00
    db $00, $11, $fe, $75, $cd, $05, $22, $cd, $a9, $73, $cd, $74, $73, $cd, $30, $74
    db $cd, $7b, $73, $cd, $4d, $74, $c9

    call Obj_GetSpriteBC                          ; $75AE
    call Call_002_7570                            ; $75B1
    ld a, [wKeysHeld]                             ; $75B4
    bit PADB_A, a                                 ; $75B7
    jr nz, jr_002_75c2                            ; $75B9

    bit 7, b                                      ; $75BB
    jr z, jr_002_75c2                             ; $75BD

    ld bc, $0000                                  ; $75BF

jr_002_75c2:
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $75C2
    cp $78                                        ; $75C4
    jr c, PrintGame_ObjKittyJump                  ; $75C6

    ld a, $78                                     ; $75C8
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $75CA
    ld bc, $0000                                  ; $75CC
    ld de, $760e                                  ; $75CF
    call Call_000_2205                            ; $75D2

; C: object callback of Kitty's jump in the fruit game (script 02:7686, started by A in PrintGame_ObjKitty):
; Obj_SetSpriteBC, then the rest of PrintGame_ObjKittyJumpStep; first run in the core path album_print_fruit_A
; (tools/kitty_core_paths.py, 2026-11-15); code read
PrintGame_ObjKittyJump::
    call Obj_SetSpriteBC                          ; $75D5

; C: the jump step: Obj_GetSpeed, 02:7430, PrintGame_ClampX, PrintGame_SaveKittyPos (the moves of PrintGame_ObjKitty
; without the keys), ret; first run in the core path album_print_fruit_A (2026-11-15); code read
PrintGame_ObjKittyJumpStep::
    call Obj_GetSpeed                             ; $75D8
    call Call_002_7430                            ; $75DB
    call PrintGame_ClampX                         ; $75DE
    call PrintGame_SaveKittyPos                   ; $75E1
    ret                                           ; $75E4


; C: $D94D = $80, $D94E = $78 (not run in the core)
Obj_SetD94D::
    ld a, $80                                     ; $75E5
    ld [wPrintGame_ObjCheckCatch_D94D], a         ; $75E7
    ld a, $78                                     ; $75EA
    ld [wPrintGame_ObjCheckCatch_D94E], a         ; $75EC
    ret                                           ; $75EF


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_Jump
ObjScript_02_75F0_Object_RunAll::
    db $f6, $75, $b9, $7f, $e5, $75, $3a, $1f, $50, $78, $1e, $1f, $0e, $76, $16, $1f
    db $70, $74, $0c, $80, $50, $62, $40, $80, $50, $62, $1e, $1f, $9e, $76, $16, $1f
    db $ab, $74, $0c, $80, $c4, $61, $40, $80, $c4, $61, $1e, $1f, $9e, $76

; I: leftover: 104 bytes (02:761E-7685) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_761E::
    db $16, $1f, $e6, $74, $04, $80, $50, $62, $04, $80, $6c, $62, $06, $80, $88, $62
    db $04, $80, $6c, $62, $04, $80, $50, $62, $04, $80, $a4, $62, $06, $80, $c0, $62
    db $04, $80, $a4, $62, $1e, $1f, $22, $76, $16, $1f, $2b, $75, $04, $80, $c4, $61
    db $04, $80, $e0, $61, $06, $80, $fc, $61, $04, $80, $e0, $61, $04, $80, $c4, $61
    db $04, $80, $18, $62, $06, $80, $34, $62, $04, $80, $18, $62, $1e, $1f, $4a, $76
    db $7f, $1f, $00, $fb, $16, $1f, $77, $75, $04, $80, $50, $62, $04, $80, $6c, $62
    db $04, $80, $88, $62, $1e, $1f, $7e, $76

; C: named by the code of PrintGame_ObjKitty (02:74C5); read in the runs by Object_RunAll, ObjCmd_JumpRandom,
; ObjCmd_SetSprite
ObjScript_02_7686_PrintGame_ObjKitty::
    db $7f, $1f, $00, $fb, $16, $1f, $ae, $75, $04, $80, $c4, $61, $04, $80, $e0, $61
    db $04, $80, $fc, $61, $1e, $1f, $96, $76, $10, $80, $dc, $62, $f8, $1f, $05, $af
    db $76, $bb, $76, $cf, $76, $eb, $76, $ff, $76, $04, $80, $fc, $62, $70, $80, $dc
    db $62

    db $1e, $1f, $af, $76, $04, $80, $fc, $62, $04, $80, $dc, $62, $04, $80, $fc, $62
    db $70, $80, $dc, $62, $1e, $1f, $bb, $76

; C: read in the runs by Object_RunAll, ObjCmd_Jump
ObjScript_02_76CF_Object_RunAll::
    db $70, $80, $7c, $63

    db $04, $80, $dc, $63, $04, $80, $7c, $63, $04, $80, $dc, $63, $60, $80, $7c, $63
    db $60, $80, $dc, $62, $1e, $1f, $cf, $76

; C: read in the runs by Object_RunAll
ObjScript_02_76EB_Object_RunAll::
    db $08, $80, $c4, $61, $08, $80, $dc, $62

; I: leftover: 50 bytes (02:76F3-7724) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_76F3::
    db $08, $80, $50, $62, $58, $80, $dc, $62, $1e, $1f, $eb, $76, $08, $80, $1c, $64
    db $08, $80, $dc, $62, $08, $80, $3c, $64, $58, $80, $dc, $62, $1e, $1f, $ff, $76
    db $e5, $fa, $d8, $da, $11, $d0, $97, $06, $01, $21, $d4, $67, $cd, $65, $01, $e1
    db $37, $c9

; C: named by the code of PrintGame_ShowResult (02:77CF); read in the runs by Object_RunAll, ObjCmd_Jump
ObjScript_02_7725_PrintGame_ShowResult::
    db $08, $80, $1c, $63, $08, $80, $dc, $62, $08, $80, $1c, $63, $08, $80, $dc, $62
    db $08, $80, $1c, $63, $08, $80, $dc, $62, $08, $80, $1c, $63, $10, $80, $dc, $62
    db $28, $80, $fc, $63

    db $13, $77, $70, $80, $dc, $62, $1e, $1f, $25, $77, $08, $80, $1c, $63, $08, $80
    db $dc, $62, $08, $80, $1c, $63, $08, $80, $dc, $62, $1e, $1f, $53, $77

; I: leftover: 44 bytes (02:7767-7792) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_7767::
    db $04, $80, $3c, $63, $50, $80, $5c, $63, $b0, $80, $dc, $62, $1e, $1f, $67, $77
    db $06, $80, $50, $62, $56, $80, $9c, $63, $06, $80, $bc, $63, $06, $80, $9c, $63
    db $06, $80, $bc, $63, $f0, $80, $9c, $63, $1e, $1f, $77, $77

; C: the apples caught [$D94F] against the record [$DAD8] (Counters_Load first): a new record, 50 or more, 30 or more,
; or less pick the message (02:7777 ...); first run in the core replays of tools/kitty_core_paths.py
; (port/cov_kitty_paths.npz: the prints that end with the fruit game, mode $06 states ...
PrintGame_ShowResult::
    ld a, [wMode06_State23_D94F]                  ; $7793
    push af                                       ; $7796
    ld b, BANK(Counters_Load)                     ; $7797
    ld hl, Counters_Load                          ; $7799
    call Far_Call                                 ; $779C
    pop af                                        ; $779F
    ld hl, wPrintGameRecord                       ; $77A0
    cp [hl]                                       ; $77A3
    jr nc, jr_002_77b3                            ; $77A4

    cp $32                                        ; $77A6
    jr nc, jr_002_77d4                            ; $77A8

    cp $1e                                        ; $77AA
    jr nc, jr_002_77d4                            ; $77AC

    ld hl, $7777                                  ; $77AE
    scf                                           ; $77B1
    ret                                           ; $77B2


jr_002_77b3:
    push hl                                       ; $77B3
    ld hl, wMode06_State0A_D896                   ; $77B4
    set 0, [hl]                                   ; $77B7
    pop hl                                        ; $77B9
    ld a, [wMode06_State23_D94F]                  ; $77BA
    ld [wPrintGameRecord], a                      ; $77BD
    ld b, BANK(Counters_Store)                    ; $77C0
    ld hl, Counters_Store                         ; $77C2
    call Far_Call                                 ; $77C5
    push hl                                       ; $77C8
    ld hl, wMode06_State0A_D896                   ; $77C9
    res 0, [hl]                                   ; $77CC
    pop hl                                        ; $77CE
    ld hl, ObjScript_02_7725_PrintGame_ShowResult ; $77CF
    scf                                           ; $77D2
    ret                                           ; $77D3


jr_002_77d4:
    ld hl, $7753                                  ; $77D4
    scf                                           ; $77D7
    ret                                           ; $77D8


    db $21, $67, $77, $37, $c9

; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetPos; first read on the screen
; Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_77DE_Mode03_ViewAlbum_State0B::
    db $3a, $1f, $50, $78, $93, $77, $de, $77, $b9, $7f, $b9, $7f, $1e, $1f, $4c, $48

; C: in step 2 ($D994) follows the text cursor $D98C, else hidden at y $A0; runs in the album text window (mode $03
; state $0B)
AlbumText_ObjCursor::
    ld a, [wStamp_ObjSlideIn_D994]                ; $77EE
    cp $02                                        ; $77F1
    jr z, jr_002_77fa                             ; $77F3

    ld a, $a0                                     ; $77F5
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $77F7
    ret                                           ; $77F9


jr_002_77fa:
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $77FA
    sla a                                         ; $77FD
    ld c, a                                       ; $77FF
    ld b, $00                                     ; $7800
    ld hl, AlbumText_ObjCursor_Tbl781D            ; $7802
    add hl, bc                                    ; $7805
    ld a, [hl+]                                   ; $7806
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $7807
    ld a, [hl+]                                   ; $7809
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $780A
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $780C
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $780F
    cp [hl]                                       ; $7812
    ld [hl], a                                    ; $7813
    jr z, jr_002_781c                             ; $7814

    ld de, ObjScript_02_484C_AlbumText_ObjCursor  ; $7816
    jp Jump_000_2205                              ; $7819


jr_002_781c:
    ret                                           ; $781C


; C: named by the code of AlbumText_ObjCursor (02:7802); read in the runs by AlbumText_ObjCursor; first read on the
; screen Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz)
AlbumText_ObjCursor_Tbl781D::
    db $10, $08, $20, $08, $30, $08, $40, $08, $50, $08, $60, $08, $70, $08, $80, $08
    db $90, $08, $10, $20, $20, $20, $30, $20, $40, $20, $50, $20, $60, $20, $70, $20
    db $80, $20, $90, $20, $10, $38, $20, $38, $30, $38, $40, $38, $50, $38, $60, $38
    db $70, $38, $80, $38, $90, $38

; C: ret
Obj_Ret7853::
    ret                                           ; $7853


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz)
ObjScript_02_7854_Mode03_ViewAlbum_State0B::
    db $ea, $77, $ee, $77, $53, $78

; C: $D994 = 1, slides in until y $F0; runs on its screen (03:0B) in the core replays (port/entry_modes_kitty.csv);
; code read
AlbumText_ObjSlideIn::
    ld a, $01                                     ; $785A
    ld [wStamp_ObjSlideIn_D994], a                ; $785C
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $785F
    cp $f0                                        ; $7861
    jr c, jr_002_7895                             ; $7863

    xor a                                         ; $7865
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $7866
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $7868
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $786A
    xor $ff                                       ; $786C
    ld c, a                                       ; $786E
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $786F
    xor $ff                                       ; $7871
    ld b, a                                       ; $7873
    inc bc                                        ; $7874
    sra b                                         ; $7875
    rr c                                          ; $7877
    ld a, b                                       ; $7879
    and a                                         ; $787A
    jr nz, jr_002_7887                            ; $787B

    ld a, $02                                     ; $787D
    ld [wStamp_ObjSlideIn_D994], a                ; $787F
    call Obj_ClearCallback                        ; $7882
    xor a                                         ; $7885
    ld c, a                                       ; $7886

jr_002_7887:
    ld a, c                                       ; $7887
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7888
    ld a, b                                       ; $788A
    ldh [hCopyReqSrcDstCnt + $3], a               ; $788B
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $788D
    add $58                                       ; $788F
    ld [wWyShadow], a                             ; $7891
    ret                                           ; $7894


jr_002_7895:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $7895
    ld c, a                                       ; $7897
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $7898
    ld b, a                                       ; $789A
    ld hl, $ff40                                  ; $789B
    add hl, bc                                    ; $789E
    ld a, l                                       ; $789F
    ldh [hCopyReqSrcDstCnt + $2], a               ; $78A0
    ld a, h                                       ; $78A2
    ldh [hCopyReqSrcDstCnt + $3], a               ; $78A3
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $78A5
    add $58                                       ; $78A7
    ld [wWyShadow], a                             ; $78A9
    ret                                           ; $78AC


; C: $D994 = 3, slides until y $38; runs on its screen (03:0B) in the core replays (port/entry_modes_kitty.csv); code
; read
AlbumText_ObjSlideOut::
    ld a, $03                                     ; $78AD
    ld [wStamp_ObjSlideIn_D994], a                ; $78AF
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $78B2
    cp $38                                        ; $78B4
    jr c, jr_002_78e9                             ; $78B6

    xor a                                         ; $78B8
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $78B9
    ld a, $39                                     ; $78BB
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $78BD
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $78BF
    xor $ff                                       ; $78C1
    ld c, a                                       ; $78C3
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $78C4
    xor $ff                                       ; $78C6
    ld b, a                                       ; $78C8
    inc bc                                        ; $78C9
    sra b                                         ; $78CA
    rr c                                          ; $78CC
    ld a, b                                       ; $78CE
    and a                                         ; $78CF
    jr nz, jr_002_78db                            ; $78D0

    xor a                                         ; $78D2
    ld [wStamp_ObjSlideIn_D994], a                ; $78D3
    call Obj_ClearCallback                        ; $78D6
    xor a                                         ; $78D9
    ld c, a                                       ; $78DA

jr_002_78db:
    ld a, c                                       ; $78DB
    ldh [hCopyReqSrcDstCnt + $2], a               ; $78DC
    ld a, b                                       ; $78DE
    ldh [hCopyReqSrcDstCnt + $3], a               ; $78DF
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $78E1
    add $58                                       ; $78E3
    ld [wWyShadow], a                             ; $78E5
    ret                                           ; $78E8


jr_002_78e9:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $78E9
    ld c, a                                       ; $78EB
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $78EC
    ld b, a                                       ; $78EE
    ld hl, $00c0                                  ; $78EF
    add hl, bc                                    ; $78F2
    ld a, l                                       ; $78F3
    ldh [hCopyReqSrcDstCnt + $2], a               ; $78F4
    ld a, h                                       ; $78F6
    ldh [hCopyReqSrcDstCnt + $3], a               ; $78F7
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $78F9
    add $58                                       ; $78FB
    ld [wWyShadow], a                             ; $78FD
    ret                                           ; $7900


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_Sound; first read on the screen
; Mode03_ViewAlbum_State0B (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7901_Mode03_ViewAlbum_State0B::
    db $3a, $1f, $00, $38, $98, $1f, $8d, $d9, $01, $ba, $1e, $30, $00, $16, $1f, $5a
    db $78, $7f, $1f, $00, $00, $10, $1f, $01, $00, $a2, $1f, $8d, $d9, $01, $ba, $1e
    db $31, $00, $16, $1f, $ad, $78, $7f, $1f, $00, $00, $10, $1f, $01, $00, $1e, $1f
    db $05, $79, $09, $1f, $01, $79, $b9, $7f, $b9, $7f

; C: Cursor_Callback61FF
AlbumText_ObjCursorCallback::
    ld b, BANK(Cursor_Callback61FF)               ; $793B
    ld hl, Cursor_Callback61FF                    ; $793D
    call Far_Call                                 ; $7940
    ret                                           ; $7943


; C: hFFD2 / hFFD4 = $D990 / $D991, HL = 02:4858 (script callback)
AlbumText_ObjPosFromD990::
    ld a, [wAlbumText_ObjPosFromD990]             ; $7944
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $7947
    ld a, [wAlbumText_CursorUpdate_D991]          ; $7949
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $794C
    ld hl, $4858                                  ; $794E
    scf                                           ; $7951
    ret                                           ; $7952


; C: read in the runs by Object_RunAll; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7953_Mode03_ViewAlbum_State0B::
    db $44, $79, $1e, $1f, $40, $45

; C: Text_LoadBigGlyphPage
AlbumText_ObjLoadGlyphPage::
    ld b, BANK(Text_LoadBigGlyphPage)             ; $7959
    ld hl, Text_LoadBigGlyphPage                  ; $795B
    call Far_Call                                 ; $795E
    ret                                           ; $7961


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode0A_NameCard_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7962_Mode0A_NameCard_State01::
    db $53, $79, $3b, $79, $59, $79, $99, $79, $00, $00, $cc, $1f, $08, $00, $30, $c2
    db $b0, $8b, $30, $02, $00, $99, $79, $01, $00, $cc, $1f, $08, $00, $60, $c4, $b0
    db $8b, $30, $02, $00, $99, $79, $02, $00, $cc, $1f, $08, $00, $90, $c6, $b0, $8b
    db $30, $02, $00, $1e, $1f, $68, $79

; C: $D98B = the next byte, skip one (script callback)
Obj_SetD98B::
    ld a, [hl+]                                   ; $7999
    ld [wPrint_LoadItemPicture_D98B], a           ; $799A
    inc hl                                        ; $799D
    xor a                                         ; $799E

jr_002_799f:
    dec a                                         ; $799F
    jr nz, jr_002_799f                            ; $79A0

    scf                                           ; $79A2
    ret                                           ; $79A3


; C: ends on A ($D8D9 bit 0)
Obj_EndOnA::
    ld a, [wKeysNew]                              ; $79A4
    bit PADB_A, a                                 ; $79A7
    jr z, jr_002_79ae                             ; $79A9

    jp Obj_End                                    ; $79AB


jr_002_79ae:
    ret                                           ; $79AE


; C: $D98B = 0
Obj_ClearD98B::
    xor a                                         ; $79AF
    ld [wPrint_LoadItemPicture_D98B], a           ; $79B0
    ret                                           ; $79B3


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0A_NameCard_State01
; (trace/read_screens_kitty.npz)
ObjScript_02_79B4_Mode0A_NameCard_State01::
    db $68, $79, $a4, $79, $af, $79

; C: Menu06_CursorCallback
NameCard_ObjCursorCallback::
    ld b, BANK(Menu06_CursorCallback)             ; $79BA
    ld hl, Menu06_CursorCallback                  ; $79BC
    call Far_Call                                 ; $79BF
    ret                                           ; $79C2


; C: NameCardEdit_CursorPlace (script callback)
NameCard_ObjCursorPlace::
    ld b, BANK(NameCardEdit_CursorPlace)          ; $79C3
    ld hl, NameCardEdit_CursorPlace               ; $79C5
    call Far_Call                                 ; $79C8
    scf                                           ; $79CB
    ret                                           ; $79CC


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_SetFrac; first read on the screen
; Mode0B_NameCardEdit_State10 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_79CD_Mode0B_NameCardEdit_State10::
    db $65, $1f, $81, $47, $16, $1f, $ba, $79, $c3, $79, $cd, $79, $b9, $7f, $b2, $4d

; C: the position of field [$D97E] from 02:7A6B; runs on its screen (0B:04) in the core replays
; (port/entry_modes_kitty.csv); code read
NameCardEdit_ObjFieldPos::
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $79DD
    sla a                                         ; $79E0
    ld c, a                                       ; $79E2
    ld b, $00                                     ; $79E3
    ld hl, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $36 ; $79E5
    add hl, bc                                    ; $79E8
    ld a, [hl+]                                   ; $79E9
    ld h, [hl]                                    ; $79EA
    ld l, a                                       ; $79EB
    scf                                           ; $79EC
    ret                                           ; $79ED


; C: read in the runs by Object_RunAll; first read on the screen Mode0B_NameCardEdit_State04
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_79EE_Mode0B_NameCardEdit_State04::
    db $dd, $79

; C: ends at step 0 ($D994); else follows field [$D97E]; runs on its screen (0B:04) in the core replays
; (port/entry_modes_kitty.csv); code read
NameCardEdit_ObjFieldTick::
    ld a, [wStamp_ObjSlideIn_D994]                ; $79F0
    cp $00                                        ; $79F3
    jp z, Obj_End                                 ; $79F5

    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $79F8
    sla a                                         ; $79FB
    ld c, a                                       ; $79FD
    ld b, $00                                     ; $79FE
    ld hl, ObjScript_02_7A35_NameCardEdit_ObjFieldTick; $7A00
    add hl, bc                                    ; $7A03
    ld c, [hl]                                    ; $7A04
    inc hl                                        ; $7A05
    ld h, [hl]                                    ; $7A06
    ld l, c                                       ; $7A07
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $7A08
    sla a                                         ; $7A0B
    ld c, a                                       ; $7A0D
    ld b, $00                                     ; $7A0E
    add hl, bc                                    ; $7A10
    ld a, [hl+]                                   ; $7A11
    ldh [hKittHost_YesNoCursor_FFD2], a           ; $7A12
    ld a, [hl+]                                   ; $7A14
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $7A15
    ld hl, hPuzzle15_ObjMoving_FFD8               ; $7A17
    ld a, [wNameCardEdit_PhotoCursorUpdate_D97F]  ; $7A1A
    cp [hl]                                       ; $7A1D
    ld [hl], a                                    ; $7A1E
    jr z, jr_002_7a34                             ; $7A1F

    ld a, [wNameCardEdit_PhotoCursorUpdate_D97E]  ; $7A21
    sla a                                         ; $7A24
    ld c, a                                       ; $7A26
    ld b, $00                                     ; $7A27
    ld hl, ObjScript_02_7A35_NameCardEdit_ObjFieldTick + $36 ; $7A29
    add hl, bc                                    ; $7A2C
    ld a, [hl+]                                   ; $7A2D
    ld e, a                                       ; $7A2E
    ld a, [hl+]                                   ; $7A2F
    ld d, a                                       ; $7A30
    jp Jump_000_2205                              ; $7A31


jr_002_7a34:
    ret                                           ; $7A34


; C: named by the code of NameCardEdit_ObjFieldTick (02:7A00); read in the runs by NameCardEdit_ObjFieldTick,
; NameCardEdit_ObjFieldPos, Object_CreateWithParam; first read on the screen Mode0B_NameCardEdit_State08
; (trace/read_screens_kitty.npz)
ObjScript_02_7A35_NameCardEdit_ObjFieldTick::
    db $3f, $7a, $45, $7a, $57, $7a, $59, $7a, $69, $7a, $1c, $2a, $4c, $2a, $7c, $2a
    db $3c, $25, $44, $25, $4c, $25, $54, $25, $5c, $25, $64, $25, $6c, $25, $74, $25
    db $7c, $25, $8c, $25, $3c, $3d, $44, $3d, $4c, $3d, $54, $3d, $64, $3d, $6c, $3d
    db $7c, $3d, $84, $3d, $94, $3d, $dc, $48, $d0, $48, $d0, $48, $d0, $48, $d0, $48
    db $ee, $79, $f0, $79, $b9, $7f

; C: $D994 = 1, slides in until y $F0; runs on its screen (0B:04) in the core replays (port/entry_modes_kitty.csv);
; code read
NameCardEdit_ObjSlideIn::
    ld a, $01                                     ; $7A7B
    ld [wStamp_ObjSlideIn_D994], a                ; $7A7D
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7A80
    cp $f0                                        ; $7A82
    jr c, jr_002_7ab6                             ; $7A84

    xor a                                         ; $7A86
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $7A87
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $7A89
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $7A8B
    xor $ff                                       ; $7A8D
    ld c, a                                       ; $7A8F
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $7A90
    xor $ff                                       ; $7A92
    ld b, a                                       ; $7A94
    inc bc                                        ; $7A95
    sra b                                         ; $7A96
    rr c                                          ; $7A98
    ld a, b                                       ; $7A9A
    and a                                         ; $7A9B
    jr nz, jr_002_7aa8                            ; $7A9C

    ld a, $02                                     ; $7A9E
    ld [wStamp_ObjSlideIn_D994], a                ; $7AA0
    call Obj_ClearCallback                        ; $7AA3
    xor a                                         ; $7AA6
    ld c, a                                       ; $7AA7

jr_002_7aa8:
    ld a, c                                       ; $7AA8
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7AA9
    ld a, b                                       ; $7AAB
    ldh [hCopyReqSrcDstCnt + $3], a               ; $7AAC
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7AAE
    add $58                                       ; $7AB0
    ld [wWyShadow], a                             ; $7AB2
    ret                                           ; $7AB5


jr_002_7ab6:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $7AB6
    ld c, a                                       ; $7AB8
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $7AB9
    ld b, a                                       ; $7ABB
    ld hl, $ff40                                  ; $7ABC
    add hl, bc                                    ; $7ABF
    ld a, l                                       ; $7AC0
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7AC1
    ld a, h                                       ; $7AC3
    ldh [hCopyReqSrcDstCnt + $3], a               ; $7AC4
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7AC6
    add $58                                       ; $7AC8
    ld [wWyShadow], a                             ; $7ACA
    ret                                           ; $7ACD


; C: $D994 = 3, slides until y $38; runs on its screen (0B:04) in the core replays (port/entry_modes_kitty.csv); code
; read
NameCardEdit_ObjSlideOut::
    ld a, $03                                     ; $7ACE
    ld [wStamp_ObjSlideIn_D994], a                ; $7AD0
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7AD3
    cp $38                                        ; $7AD5
    jr c, jr_002_7b0a                             ; $7AD7

    xor a                                         ; $7AD9
    ldh [hPlayMenu_CursorUpdate_FFD3], a          ; $7ADA
    ld a, $39                                     ; $7ADC
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $7ADE
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $7AE0
    xor $ff                                       ; $7AE2
    ld c, a                                       ; $7AE4
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $7AE5
    xor $ff                                       ; $7AE7
    ld b, a                                       ; $7AE9
    inc bc                                        ; $7AEA
    sra b                                         ; $7AEB
    rr c                                          ; $7AED
    ld a, b                                       ; $7AEF
    and a                                         ; $7AF0
    jr nz, jr_002_7afc                            ; $7AF1

    xor a                                         ; $7AF3
    ld [wStamp_ObjSlideIn_D994], a                ; $7AF4
    call Obj_End                                  ; $7AF7
    xor a                                         ; $7AFA
    ld c, a                                       ; $7AFB

jr_002_7afc:
    ld a, c                                       ; $7AFC
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7AFD
    ld a, b                                       ; $7AFF
    ldh [hCopyReqSrcDstCnt + $3], a               ; $7B00
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7B02
    add $58                                       ; $7B04
    ld [wWyShadow], a                             ; $7B06
    ret                                           ; $7B09


jr_002_7b0a:
    ldh a, [hCopyReqSrcDstCnt + $2]               ; $7B0A
    ld c, a                                       ; $7B0C
    ldh a, [hCopyReqSrcDstCnt + $3]               ; $7B0D
    ld b, a                                       ; $7B0F
    ld hl, $00c0                                  ; $7B10
    add hl, bc                                    ; $7B13
    ld a, l                                       ; $7B14
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7B15
    ld a, h                                       ; $7B17
    ldh [hCopyReqSrcDstCnt + $3], a               ; $7B18
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7B1A
    add $58                                       ; $7B1C
    ld [wWyShadow], a                             ; $7B1E
    ret                                           ; $7B21


; C: read in the runs by Object_RunAll, Object_CreateWithParam, ObjCmd_Sound; first read on the screen
; Mode0B_NameCardEdit_State04 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_7B22_Mode0B_NameCardEdit_State04::
    db $3a, $1f, $00, $38, $ba, $1e, $30, $00, $16, $1f, $7b, $7a, $7f, $1f, $00, $00
    db $10, $1f, $01, $00, $a2, $1f, $81, $d9, $01, $ba, $1e, $31, $00, $16, $1f, $ce
    db $7a, $7f, $1f, $00, $00, $10, $1f, $01, $00, $09, $1f, $22, $7b, $b9, $7f, $b9
    db $7f

; C: NameCardEdit_PhotoCursorCallback
NameCardEdit_ObjPhotoCursor::
    ld b, BANK(NameCardEdit_PhotoCursorCallback)  ; $7B53
    ld hl, NameCardEdit_PhotoCursorCallback       ; $7B55
    call Far_Call                                 ; $7B58
    ret                                           ; $7B5B


    db $fa, $7e, $d9, $a7, $20, $05, $21, $6c, $48, $37, $c9, $21, $58, $48, $37, $c9
    db $5c, $7b

; C: $D8E0 = 0, NameCardEdit_LoadFieldGlyphs
NameCardEdit_ObjLoadField::
    xor a                                         ; $7B6E
    ld [wMode06_State21_D8E0], a                  ; $7B6F
    ld b, BANK(NameCardEdit_LoadFieldGlyphs)      ; $7B72
    ld hl, NameCardEdit_LoadFieldGlyphs           ; $7B74
    call Far_Call                                 ; $7B77
    ret                                           ; $7B7A


; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode0B_NameCardEdit_State10 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_7B7B_Mode0B_NameCardEdit_State10::
    db $6c, $7b, $53, $7b, $6e, $7b, $cc, $1f, $01, $00, $30, $c2, $70, $91, $90, $06
    db $00, $cc, $1f, $08, $00, $30, $c2, $b0, $8b, $30, $02, $00, $cc, $1f, $08, $00
    db $60, $c4, $b0, $8b, $30, $02, $00, $cc, $1f, $08, $00, $90, $c6, $b0, $8b, $30
    db $02, $00, $1e, $1f, $8c, $7b

; C: when $D8E0 bit 0 is set: hidden and the script 02:7FC0
Obj_EndOnD8E0Bit0::
    ld a, [wMode06_State21_D8E0]                  ; $7BB1
    bit 0, a                                      ; $7BB4
    jr z, jr_002_7bc1                             ; $7BB6

    call Obj_ClearCallback                        ; $7BB8
    ld de, $7fc0                                  ; $7BBB
    jp Jump_000_2205                              ; $7BBE


jr_002_7bc1:
    ret                                           ; $7BC1


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0B_NameCardEdit_State10
; (trace/read_screens_kitty.npz)
ObjScript_02_7BC2_Mode0B_NameCardEdit_State10::
    db $81, $7b, $b1, $7b, $b9, $7f

; C: Obj_KeyMaskStep
Obj_KeyMaskStepCallback::
    ld b, BANK(Obj_KeyMaskStep)                   ; $7BC8
    ld hl, Obj_KeyMaskStep                        ; $7BCA
    call Far_Call                                 ; $7BCD
    ret                                           ; $7BD0


; C: read in the runs by Object_RunAll; first read on the screen Mode0B_NameCardEdit_State10
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7BD1_Mode0B_NameCardEdit_State10::
    db $09, $1f

; C: ret
Obj_Ret7BD3::
    ret                                           ; $7BD3


; C: read in the runs by Object_CreateWithParam; first read on the screen Mode0B_NameCardEdit_State10
; (trace/read_screens_kitty.npz)
ObjScript_02_7BD4_Mode0B_NameCardEdit_State10::
    db $d1, $7b, $c8, $7b, $d3, $7b

; C: next frame; follows $D9FD (the exchange direction); runs on its screen (07:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Exchange_ObjFollowD9FD::
    call Obj_AdvanceFrame30                       ; $7BDA
    ld a, [wMode07_State02_D9FD]                  ; $7BDD
    ld c, a                                       ; $7BE0
    ldh a, [hScratch_CursorUpdate_FFD9]           ; $7BE1
    cp c                                          ; $7BE3
    jr z, jr_002_7bf6                             ; $7BE4

    ld a, c                                       ; $7BE6
    ldh [hScratch_CursorUpdate_FFD9], a           ; $7BE7
    ldh a, [hObjCmd_End_FFC3]                     ; $7BE9
    ld l, a                                       ; $7BEB
    ldh a, [hObjCmd_End_FFC4]                     ; $7BEC
    ld h, a                                       ; $7BEE
    ld e, [hl]                                    ; $7BEF
    inc hl                                        ; $7BF0
    ld d, [hl]                                    ; $7BF1
    call Call_000_2205                            ; $7BF2
    ret                                           ; $7BF5


jr_002_7bf6:
    ldh a, [hState]                               ; $7BF6
    cp $04                                        ; $7BF8
    jr nz, jr_002_7c0b                            ; $7BFA

    ld de, $7c0c                                  ; $7BFC
    call Obj_SetCallback                          ; $7BFF
    ld a, $17                                     ; $7C02
    ldh [hPuzzle15_ObjMoving_FFD8], a             ; $7C04
    xor a                                         ; $7C06
    ldh [hCopyReqSrcDstCnt + $2], a               ; $7C07
    ldh [hCopyReqSrcDstCnt + $3], a               ; $7C09

jr_002_7c0b:
    ret                                           ; $7C0B


    db $f0, $d8, $a7, $28, $13, $3d, $e0, $d8, $f0, $9d, $e6, $04, $28, $05, $f0, $d7
    db $e0, $d4, $c9, $3e, $c0, $e0, $d4, $c9, $3e, $04, $ea, $e0, $d8, $c9

; C: read in the runs by Object_RunAll, ObjCmd_SetPos, ObjCmd_Jump; first read on the screen Mode07_Exchange_State02
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7C2A_Mode07_Exchange_State02::
    db $36, $7c, $3a, $1f, $14, $20, $54, $4a, $1e, $1f, $b4, $46

; C: $D882 bit 3 cleared (script callback)
Obj_ClearD882Bit3::
    push hl                                       ; $7C36
    ld hl, wLcdcShadow                            ; $7C37
    res 3, [hl]                                   ; $7C3A
    pop hl                                        ; $7C3C
    scf                                           ; $7C3D
    ret                                           ; $7C3E


; C: read in the runs by Object_RunAll, ObjCmd_SetPos, ObjCmd_Jump; first read on the screen Mode07_Exchange_State02
; (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7C3F_Mode07_Exchange_State02::
    db $3a, $1f, $24, $20, $54, $4a, $1e, $1f, $bc, $46, $3a, $1f, $38, $20, $54, $4a
    db $1e, $1f, $c4, $46, $5f, $7c, $3a, $1f, $6c, $20, $54, $4a, $1e, $1f, $cc, $46

; C: $D882 bit 3 set (script callback)
Obj_SetD882Bit3::
    push hl                                       ; $7C5F
    ld hl, wLcdcShadow                            ; $7C60
    set 3, [hl]                                   ; $7C63
    pop hl                                        ; $7C65
    scf                                           ; $7C66
    ret                                           ; $7C67


; C: read in the runs by Object_CreateWithParam, Object_RunAll, ObjCmd_JumpByByte; first read on the screen
; Mode07_Exchange_State02 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7C68_Mode07_Exchange_State02::
    db $3a, $1f, $7c, $20, $54, $4a, $1e, $1f, $d4, $46, $3a, $1f, $90, $20, $54, $4a
    db $1e, $1f, $dc, $46, $09, $20, $fd, $d9, $2a, $7c, $53, $7c, $7c, $7c, $da, $7b
    db $b9, $7f, $09, $20, $fd, $d9, $3f, $7c, $68, $7c, $8a, $7c, $da, $7b, $b9, $7f
    db $09, $20, $fd, $d9, $49, $7c, $72, $7c, $98, $7c, $da, $7b, $b9, $7f, $e4, $46
    db $b9, $7f, $b9, $7f

; I: leftover: 396 bytes (02:7CAC-7E37) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_7CAC::
    INCBIN "data/bank_02/Leftover_02_7CAC.bin" ; $7CAC, 396 bytes
; C: read in the runs by ObjCmd_CopyAtLine20, Object_RunAll, Object_CreateWithParam; first read on the screen
; Mode0C_RecordBook_State01 (trace/read_screens_kitty.npz); kind OAM from the evidence of tools/kitty_layout_kinds.py
ObjScript_02_7E38_Mode0C_RecordBook_State01::
    db $cc, $1f, $10, $00, $10, $71, $30, $90, $10, $00, $25, $cc, $1f, $10, $00, $20
    db $71, $30, $90, $10, $00, $25, $1e, $1f, $38, $7e, $38, $7e, $b9, $7f, $b9, $7f

; C: adds one step of the three palettes $D88C-$D88E (each pair of bits) to the accumulators $D88F-$D894 and writes
; the result into $D883-$D885 (fade in); code read
Fade_StepIn::
    push hl                                       ; $7E58
    ld de, wPaletteTarget                         ; $7E59
    ld hl, wFadeLevel                             ; $7E5C
    ld bc, wBgpShadow                             ; $7E5F
    ld a, $03                                     ; $7E62

jr_002_7e64:
    push af                                       ; $7E64
    push bc                                       ; $7E65
    ld a, [de]                                    ; $7E66
    and $33                                       ; $7E67
    add [hl]                                      ; $7E69
    ld [hl+], a                                   ; $7E6A
    srl a                                         ; $7E6B
    srl a                                         ; $7E6D
    and $33                                       ; $7E6F
    ld c, a                                       ; $7E71
    ld a, [de]                                    ; $7E72
    and $cc                                       ; $7E73
    srl a                                         ; $7E75
    srl a                                         ; $7E77
    add [hl]                                      ; $7E79
    ld [hl+], a                                   ; $7E7A
    and $cc                                       ; $7E7B
    or c                                          ; $7E7D
    pop bc                                        ; $7E7E
    ld [bc], a                                    ; $7E7F
    inc bc                                        ; $7E80
    inc de                                        ; $7E81
    pop af                                        ; $7E82
    dec a                                         ; $7E83
    jr nz, jr_002_7e64                            ; $7E84

    pop hl                                        ; $7E86
    scf                                           ; $7E87
    ret                                           ; $7E88


; C: keys blocked ($D8D4 = 1), the accumulators $D88F-$D894 cleared (the start of a fade in from white); code read
Fade_StartIn::
    ld a, $01                                     ; $7E89
    ld [wFadeRunning], a                          ; $7E8B
    xor a                                         ; $7E8E
    ld [wFadeLevel], a                            ; $7E8F
    ld [wFadeLevel + $1], a                       ; $7E92
    ld [wFadeLevel + $2], a                       ; $7E95
    ld [wFadeLevel + $3], a                       ; $7E98
    ld [wFadeLevel + $4], a                       ; $7E9B
    ld [wFadeLevel + $5], a                       ; $7E9E
    ret                                           ; $7EA1


; C: the fade object at its end: mode hFF8D = hFFD4 and state hFF8E = hFFD2 (its parameters from $0B16 / $0B22); the
; only way a fade changes the mode
Fade_SetModeFromObject::
    push hl                                       ; $7EA2
    xor a                                         ; $7EA3
    ld [wFadeRunning], a                          ; $7EA4
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $7EA7
    ldh [hState], a                               ; $7EA9
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7EAB
    ldh [hMode], a                                ; $7EAD
    pop hl                                        ; $7EAF
    scf                                           ; $7EB0
    ret                                           ; $7EB1


; C: read in the runs by Object_RunAll, ObjCmd_Wait, Object_CreateWithParam; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_7EB2_Mode00_BootAndTitle_State00::
    db $58, $7e, $10, $1f, $04, $00, $58, $7e, $10, $1f, $04, $00, $58, $7e, $10, $1f
    db $04, $00, $58, $7e, $a2, $7e, $02, $1f, $b2, $7e, $b9, $7f, $89, $7e

    db $58, $7e, $10, $1f, $01, $00, $58, $7e, $10, $1f, $01, $00, $58, $7e, $10, $1f
    db $01, $00, $58, $7e, $a2, $7e, $02, $1f, $d0, $7e, $b9, $7f, $89, $7e

; C: the same step subtracted (fade out); code read
Fade_StepOut::
    push hl                                       ; $7EEE
    ld de, wPaletteTarget                         ; $7EEF
    ld hl, wFadeLevel                             ; $7EF2
    ld bc, wBgpShadow                             ; $7EF5
    ld a, $03                                     ; $7EF8

jr_002_7efa:
    push af                                       ; $7EFA
    push bc                                       ; $7EFB
    ld a, [de]                                    ; $7EFC
    and $33                                       ; $7EFD
    ld c, a                                       ; $7EFF
    ld a, [hl]                                    ; $7F00
    sub c                                         ; $7F01
    ld [hl+], a                                   ; $7F02
    srl a                                         ; $7F03
    srl a                                         ; $7F05
    and $33                                       ; $7F07
    ld c, a                                       ; $7F09
    ld a, [de]                                    ; $7F0A
    and $cc                                       ; $7F0B
    srl a                                         ; $7F0D
    srl a                                         ; $7F0F
    ld b, a                                       ; $7F11
    ld a, [hl]                                    ; $7F12
    sub b                                         ; $7F13
    ld [hl+], a                                   ; $7F14
    and $cc                                       ; $7F15
    or c                                          ; $7F17
    pop bc                                        ; $7F18
    ld [bc], a                                    ; $7F19
    inc bc                                        ; $7F1A
    inc de                                        ; $7F1B
    pop af                                        ; $7F1C
    dec a                                         ; $7F1D
    jr nz, jr_002_7efa                            ; $7F1E

    pop hl                                        ; $7F20
    scf                                           ; $7F21
    ret                                           ; $7F22


; C: keys blocked ($D8D4 = 1), the accumulators $D88F-$D894 loaded from the palettes $D883-$D885 (the start of a fade
; out); code read
Fade_StartOut::
    ld a, $01                                     ; $7F23
    ld [wFadeRunning], a                          ; $7F25
    ld a, [wBgpShadow]                            ; $7F28
    and $33                                       ; $7F2B
    sla a                                         ; $7F2D
    sla a                                         ; $7F2F
    ld [wFadeLevel], a                            ; $7F31
    ld a, [wBgpShadow]                            ; $7F34
    and $cc                                       ; $7F37
    ld [wFadeLevel + $1], a                       ; $7F39
    ld a, [wObp0Shadow]                           ; $7F3C
    and $33                                       ; $7F3F
    sla a                                         ; $7F41
    sla a                                         ; $7F43
    ld [wFadeLevel + $2], a                       ; $7F45
    ld a, [wObp0Shadow]                           ; $7F48
    and $cc                                       ; $7F4B
    ld [wFadeLevel + $3], a                       ; $7F4D
    ld a, [wObp1Shadow]                           ; $7F50
    and $33                                       ; $7F53
    sla a                                         ; $7F55
    sla a                                         ; $7F57
    ld [wFadeLevel + $4], a                       ; $7F59
    ld a, [wObp1Shadow]                           ; $7F5C
    and $cc                                       ; $7F5F
    ld [wFadeLevel + $5], a                       ; $7F61
    ret                                           ; $7F64


; C: $D8D4 = 0, mode hFF8D = hFFD4 and state hFF8E = hFFD2 of the fade object (script callback)
Fade_End::
    push hl                                       ; $7F65
    xor a                                         ; $7F66
    ld [wFadeRunning], a                          ; $7F67
    ldh a, [hKittHost_YesNoCursor_FFD2]           ; $7F6A
    ldh [hState], a                               ; $7F6C
    ldh a, [hStamp_ObjSlideIn_FFD4]               ; $7F6E
    ldh [hMode], a                                ; $7F70
    pop hl                                        ; $7F72
    scf                                           ; $7F73
    ret                                           ; $7F74


; C: read in the runs by Object_RunAll, ObjCmd_Wait, Object_CreateWithParam; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind OAM from the evidence of
; tools/kitty_layout_kinds.py
ObjScript_02_7F75_Mode00_BootAndTitle_State00::
    db $ee, $7e, $10, $1f, $04, $00, $ee, $7e, $10, $1f, $04, $00, $ee, $7e, $10, $1f
    db $04, $00, $ee, $7e, $10, $1f, $04, $00, $65, $7f, $02, $1f, $75, $7f, $b9, $7f
    db $23, $7f

; I: leftover: 34 bytes (02:7F97-7FB8) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_02_7F97::
    db $ee, $7e, $10, $1f, $01, $00, $ee, $7e, $10, $1f, $01, $00, $ee, $7e, $10, $1f
    db $01, $00, $ee, $7e, $10, $1f, $01, $00, $65, $7f, $02, $1f, $97, $7f, $b9, $7f
    db $23, $7f

; C: ret: the callback of objects that do nothing each frame
Obj_NullCallback::
    ret                                           ; $7FB9


; C: named by the code of Puzzle15_ObjWaitMove, Scratch_ObjCountdown (02:50A5 02:568B); read in the runs by
; Object_RunAll; first read on the screen Mode01_MainMenu_State02 (trace/read_screens_kitty.npz); kind OAM from the
; evidence of tools/kitty_layout_kinds.py
ObjScript_02_7FBA_Puzzle15_ObjWaitMove::
    db $08, $80, $00, $00, $09, $1f, $02, $1f

; C: 00:20D4, then the 16 object slots at $DAEE cleared (23 bytes each); called by every screen set-up
Objects_ClearAll::
    call Objects_Freeze                           ; $7FC2
    ld hl, wObject_CreateWithParam_DAEE           ; $7FC5
    ld b, $10                                     ; $7FC8
    xor a                                         ; $7FCA
    ld de, $0015                                  ; $7FCB

jr_002_7fce:
    ld [hl+], a                                   ; $7FCE
    ld [hl+], a                                   ; $7FCF
    add hl, de                                    ; $7FD0
    dec b                                         ; $7FD1
    jr nz, jr_002_7fce                            ; $7FD2

    call Objects_Unfreeze                         ; $7FD4
    jp Far_Return                                 ; $7FD7


    ; padding
    ds $26, $00

; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $05. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_05_4000::
    db $05

; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 7 of 10, head turned up (HOI_U in the old
; symbol tables), a 128 x 112 camera picture (3,584 B); pixel match against the TCRF image, 0 differing tiles; never
; read nor run in the L2 runs (trace/cov_proto_runs.npz); no type row, ...
Unused_TCRF_FacePhoto7_HOI_U_Gfx::
    INCBIN "data/bank_05/Unused_TCRF_FacePhoto7_HOI_U_Gfx.2bpp" ; $4001, 3584 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 8 of 10, head turned down (HOI_D), a 128
; x 112 camera picture (3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the L2
; runs (trace/cov_proto_runs.npz); no type row, copy site or pointer of ...
Unused_TCRF_FacePhoto8_HOI_D_Gfx::
    INCBIN "data/bank_05/Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp" ; $4E01, 3584 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 9 of 10, head turned left (HOI_L), a 128
; x 112 camera picture (3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the L2
; runs (trace/cov_proto_runs.npz); no type row, copy site or pointer of ...
Unused_TCRF_FacePhoto9_HOI_L_Gfx::
    INCBIN "data/bank_05/Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp" ; $5C01, 3584 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 10 of 10, head turned right (HOI_R), a
; 128 x 112 camera picture (3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the
; L2 runs (trace/cov_proto_runs.npz); no type row, copy site or pointer ...
Unused_TCRF_FacePhoto10_HOI_R_Gfx::
    INCBIN "data/bank_05/Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp" ; $6A01, 3584 bytes
; I: leftover PC memory: 2046 bytes (05:7801-7FFE) that hold 1 strings of the development PC's RAM
; (C:\WINDOWS\SYSTEM\KERNEL32.DLL ...), and that nothing in this build reads, runs or explains; only those are proven,
; the rest of the run is taken as the same memory
Leftover_05_7801_PcRam::
    db $89, $8a, $04, $cd, $56, $28, $5b, $00, $d1, $e8, $83, $e0, $01, $85, $c0, $0f
    db $84, $dd, $04, $00, $00, $8b, $56, $10, $8b, $4a, $04, $8a, $01, $24, $ff, $33
    db $d2, $8a, $d0, $8b, $ca, $03, $c9, $8d, $0c, $89, $8a, $04, $cd, $56, $28, $5b
    db $00, $d1, $e8, $83, $e0, $01, $85, $c0, $0f, $85, $b4, $04, $00, $00, $83, $7c
    db $24, $4c, $00, $0f, $84, $a9, $04, $00, $00, $ff, $4c, $24, $50, $80, $3d, $54
    db $c0, $5b, $00, $00, $0f, $85, $d5, $00, $00, $00, $83, $3d, $f0, $c3, $5b, $00
    db $00, $0f, $84, $c8, $00, $00, $00, $85, $ff, $0f, $84, $c0, $00, $00, $00, $8b
    db $14, $24, $8b, $4a, $10, $89, $8c, $24, $9c, $00, $00, $00, $8b, $84, $24, $9c
    db $00, $00, $00, $8b, $50, $04, $8a, $0a, $80, $e1, $ff, $33, $c0, $8a, $c1, $8b
    db $d0, $03, $d2, $8d, $14, $92, $8a, $0c, $d5, $4f, $28, $5b, $00, $c1, $e9, $06
    db $83, $e1, $01, $85, $c9, $75, $2b, $8b, $84, $24, $9c, $00, $00, $00, $8b, $50
    db $04, $8a, $0a, $80, $e1, $ff, $33, $c0, $8a, $c1, $8b, $d0, $03, $d2, $8d, $14
    db $92, $8a, $0c, $d5, $4f, $28, $5b, $00, $c1, $e9, $04, $83, $e1, $01, $85, $c9
    db $74, $02, $33, $ff, $85, $ff, $74, $57, $8b, $04, $24, $8b, $50, $10, $89, $94
    db $24, $a0, $00, $00, $00, $8b, $84, $24, $a0, $00, $00, $00, $8b, $8c, $24, $a0
    db $00, $00, $00, $8b, $58, $1c, $8b, $49, $20, $c1, $e3, $02, $03, $d9, $3b, $d9
    db $74, $2d, $8b, $01, $8b, $d0, $8b, $42, $10, $8b, $6a, $0c, $c1, $e5, $02, $03
    db $e8, $3b, $e8, $74, $11, $8b, $10, $83, $7a, $0c, $01, $7e, $04, $33, $ff, $eb
    db $05, $83, $c0, $04, $eb, $eb, $85, $ff, $74, $05, $83, $c1, $04, $eb, $cf, $8b
    db $44, $24, $1c, $8b, $50, $04, $8a, $0a, $80, $e1, $ff, $80, $f9, $49, $75, $6b
    db $8b, $44, $24, $1c, $8b, $50, $04, $33, $c9, $89, $4a, $2c, $8b, $44, $24, $1c
    db $8b, $50, $04, $c7, $42, $30, $01, $00, $00, $00, $83, $3d, $f0, $c3, $5b, $00
    db $00, $74, $23, $8b, $4c, $24, $58, $8b, $41, $10, $50, $e8, $3f, $43, $f7, $ff
    db $59, $48, $75, $04, $85, $ff, $75, $0e, $8b, $54, $24, $1c, $8b, $4a, $04, $c7
    db $41, $2c, $01, $00, $00, $00, $8b, $44, $24, $1c, $50, $e8, $5b, $21, $f8, $ff
    db $59, $50, $8b, $54, $24, $0c, $52, $e8, $27, $24, $f8, $ff, $83, $c4, $08, $8b
    db $4c, $24, $1c, $8b, $69, $10, $e9, $89, $00, $00, $00, $6a, $00, $6a, $00, $6a
    db $49, $e8, $b1, $0c, $f8, $ff, $83, $c4, $0c, $50, $e8, $c0, $20, $f8, $ff, $8b
    db $d8, $59, $33, $d2, $33, $c9, $8b, $43, $04, $c7, $40, $0c, $64, $00, $00, $00
    db $c7, $40, $14, $ff, $ff, $ff, $ff, $c7, $40, $18, $ff, $ff, $ff, $ff, $89, $50
    db $10, $33, $d2, $c7, $40, $1c, $ff, $ff, $ff, $ff, $c7, $40, $20, $ff, $ff, $ff
    db $ff, $89, $48, $24, $89, $50, $34, $33, $c9, $89, $48, $2c, $c7, $40, $30, $00
    db $00, $00, $00, $0c, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $03
    db $00, $00, $00, $00, $00, $00, $00, $78, $92, $cd, $7f, $1c, $ca, $cd, $7f, $1c
    db $ca, $cd, $7f

    ; padding
    ds $10, $00

    db $0c, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $01, $00, $00, $00
    db $00, $00, $00, $00, $78, $92, $cd, $7f, $4c, $ca, $cd, $7f, $4c, $ca, $cd, $7f

    ; padding
    ds $10, $00

    db $0c, $00, $00, $00, $00, $00, $00, $00, $01, $00, $00, $00, $02

    ; padding
    ds $57, $00

    db $ec, $ff, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $90, $01, $00, $00, $00, $00, $00, $80, $00, $00, $00, $00, $82, $6c, $82, $72
    db $20, $82, $6f, $83, $53, $83, $56, $83, $62, $83, $4e, $00, $23, $b1, $56, $81
    db $68, $94, $a6, $81, $00, $00, $00, $00, $ff, $ff, $ff, $ff

    ; padding
    ds $14, $00

    db $fe, $0b, $00, $00, $fa, $0b

    ; padding
    ds $e2, $00

    db $43, $3a, $5c, $57, $49, $4e, $44, $4f, $57, $53, $5c, $53, $59, $53, $54, $45
    db $4d, $5c, $4b, $45, $52, $4e, $45, $4c, $33, $32, $2e, $44, $4c, $4c

    ; padding
    ds $ea, $00

    db $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $8c, $c6, $57, $81
    db $00, $00, $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $58, $c6, $57, $81, $00, $00, $00, $00, $00, $00, $00, $00
    db $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $24, $c6, $57, $81
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $71, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $61, $00, $00, $00, $01, $00
    db $00, $00, $10

    ; padding
    ds $294, $00

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_05_7FFF::
    db $05

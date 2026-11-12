; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $30. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $030", ROMX[$4000], BANK[$30]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_30_4000::
    db $30

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 0 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_30_4001_AsmSource::
    db "//////////////////////////////////////////////", $0d, $0a, $0d, $0a, $0d, $0a, ";=====================================================", $0d, $0a, ";", $0d, $0a, ";   ", $83, "I", $83, "t", $83, "Z", $83, "b", $83, "g", $92, $b2, $90, $ae, $0d, $0a, ";", $0d, $0a, ";  ", $e8, $87, $92, "l", $82, $aa, $95, $cf, $8d, "X", $82, $b3, $82, $ea, $82, $e9, $82, $cc, $82, $c5, $81, "A", $82, $b1, $82, $cc, $8c, $e3, $83, "f", $83, "B", $83, "U", $82, $cc, $90, $dd, $92, $e8, $82, $f0, $82, $b7, $82, $e9, $82, $b1, $82, $c6, $0d, $0a, ";=====================================================", $0d, $0a, "GET_OFFSET"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_30_4100::
    db $00, $00, $65, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 14 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_30_4104_AsmSource::
    db ";-------------------------", $0d, $0a, $09, "LD", $09, "A,$10", $09, $09, "; RAMBK $10", $0d, $0a, $09, "LD", $09, "($4000),A", $0d, $0a, $0d, $0a, $09, "LD", $09, "B,$70", $0d, $0a, $09, "LD", $09, "A,(B_MODE)", $0d, $0a, $09, "AND", $09, "$0F", $0d, $0a, $09, "CP", $09, "$06", $0d, $0a, $09, "JR", $09, "Z,_SET_TH", $0d, $0a, $0d, $0a, $09, "LD", $09, "B,$55", $09, $09, ";", $e8, $87, $92, "l", $82, $f0, "55H(1V)", $82, $c9, $90, $dd, $92, $e8, $82, $b7, $82, $e9, $0d, $0a, "_SET_TH", $0d, $0a, $09, "LD", $09, "HL,TH000", $0d, $0a, $09, "LD", $09, "DE,$30", $0d, $0a, "_TH_LOOP", $0d, $0a, $09, "LD", $09, "(HL),B", $0d, $0a, $09, "DEC", $09, "DE", $0d, $0a, $09, "LD", $09, "A,D", $0d, $0a, $09, "OR", $09, "E", $0d, $0a, $09

    ; padding
    ds $1, $00

; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 6 of 10 (the frown), tile rows 2-13 of a
; 128 x 112 camera picture (224 tiles in row order from 30:4001); its rows 0-1 (30:4001-4200) were overwritten by
; leftover source text, so only 3,072 of the 3,584 bytes survive: 192 of 224 ...
Unused_TCRF_FacePhoto6_Rows2To13_Gfx::
    INCBIN "data/bank_30/Unused_TCRF_FacePhoto6_Rows2To13_Gfx.2bpp" ; $4201, 3072 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 1 of 10, a 128 x 112 camera picture (224
; tiles in row order, 3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the L2
; runs (trace/cov_proto_runs.npz); no type row, copy site or pointer of ...
Unused_TCRF_FacePhoto1_Gfx::
    INCBIN "data/bank_30/Unused_TCRF_FacePhoto1_Gfx.2bpp" ; $4E01, 3584 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 2 of 10, a 128 x 112 camera picture (224
; tiles in row order, 3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the L2
; runs (trace/cov_proto_runs.npz); no type row, copy site or pointer of ...
Unused_TCRF_FacePhoto2_Gfx::
    INCBIN "data/bank_30/Unused_TCRF_FacePhoto2_Gfx.2bpp" ; $5C01, 3584 bytes
; C: TCRF Proto:Game Boy Camera (Debagame Tester) unused graphic: face photo 3 of 10, a 128 x 112 camera picture (224
; tiles in row order, 3,584 B); pixel match against the TCRF image, 0 differing tiles; never read nor run in the L2
; runs (trace/cov_proto_runs.npz); no type row, copy site or pointer of ...
Unused_TCRF_FacePhoto3_Gfx::
    INCBIN "data/bank_30/Unused_TCRF_FacePhoto3_Gfx.2bpp" ; $6A01, 3584 bytes
; I: leftover: 864 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_30_7801::
    INCBIN "data/bank_30/Leftover_30_7801.bin" ; $7801, 2046 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_30_7FFF::
    db $30

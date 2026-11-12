; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $31. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $031", ROMX[$4000], BANK[$31]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_31_4000::
    db $31

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 11 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_31_4001_AsmSource::
    db "_CNTR3),A", $0d, $0a, $0d, $0a, $09, "LD", $09, "DE,$FFDF", $09, $09, "; 21H", $82, $e6, $82, $e8, $89, $ba, $82, $cd, $8e, "g", $82, $a6, $82, $c8, $82, $a2, $82, $cc, $82, $c5, $0d, $0a, $09, "ADD", $09, "HL,DE", $0d, $0a, $09, "JR", $09, "C,_SET_OK", $0d, $0a, $0d, $0a, $09, "LD", $09, "A,$00", $0d, $0a, $09, "LD", $09, "(B_CNTR2),A", $09, $09, "; ", $8b, $ad, $90, $a7, $93, "I", $82, $c9, "21H", $82, $c9, $82, $b7, $82, $e9, $0d, $0a, $09, "LD", $09, "A,$21", $0d, $0a, $09, "LD", $09, "(B_CNTR3),A", $0d, $0a, $0d, $0a, "_SET_OK", $0d, $0a, $09, "LD", $09, "A,$10", $0d, $0a, $09, "LD", $09, "($4000),A", $09, $09, "; RAM BANK", $82, $cc, $95, $cf, $8d, "X", $0d, $0a, $09, $0d, $0a, $09, "LD", $09, "A,(B_CNTR2)", $0d, $0a, $09, "LD", $09, "(CNTR2),A", $09, $09, ";", $8e, $c0, $8d, $db

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_31_4100::
    db $00, $b0, $5d, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 5 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_31_4104_AsmSource::
    db $8d, "X", $82, $b7, $82, $e9, $0d, $0a, $09, "LD", $09, "A,(B_CNTR3)", $0d, $0a, $09, "LD", $09, "(CNTR3),A", $0d, $0a, $0d, $0a, $09, "RET", $0d, $0a, $0d, $0a, $0d, $0a, $0d, $0a, $0d, $0a, $0d, $0a, ";=================================================", $0d, $0a, "; ", $82, "P", $82, $cc, $90, $94, $82, $f0, $90, $94, $82, $a6, $82, $e9, $83, "T", $83, "u", $83, $8b, $81, "[", $83, "`", $83, $93, " ", $82, "P", $8d, "s", $95, $aa, $0d, $0a, ";=================================================", $0d, $0a, "LINE_CHECK", $0d, $0a, $09, "ld", $09, "a,$4", $0d, $0a, $09, "ld", $09, "(r0),a", $09, "; loop counter", $0d, $0a, "_lp", $0d

; I: leftover: an exact copy of 3073 bytes of Unused_TCRF_FacePhoto7_HOI_U_Gfx (from 05:4200, a part of the block)
; that nothing in this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_31_4200_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4200::
    INCBIN "data/bank_31/Leftover_31_4200_Unused_TCRF_FacePhoto7_HOI_U_Gfx_Part4200.bin" ; $4200, 3073 bytes
; I: leftover: an exact copy of Unused_TCRF_FacePhoto8_HOI_D_Gfx (05:4E01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_31_4E01_Unused_TCRF_FacePhoto8_HOI_D_Gfx::
    INCBIN "data/bank_31/Leftover_31_4E01_Unused_TCRF_FacePhoto8_HOI_D_Gfx.2bpp" ; $4E01, 3584 bytes
; I: leftover: an exact copy of Unused_TCRF_FacePhoto9_HOI_L_Gfx (05:5C01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_31_5C01_Unused_TCRF_FacePhoto9_HOI_L_Gfx::
    INCBIN "data/bank_31/Leftover_31_5C01_Unused_TCRF_FacePhoto9_HOI_L_Gfx.2bpp" ; $5C01, 3584 bytes
; I: leftover: an exact copy of Unused_TCRF_FacePhoto10_HOI_R_Gfx (05:6A01, 3584 bytes) that nothing in this build
; reads, runs or explains (never read nor run in the L2 runs)
Leftover_31_6A01_Unused_TCRF_FacePhoto10_HOI_R_Gfx::
    INCBIN "data/bank_31/Leftover_31_6A01_Unused_TCRF_FacePhoto10_HOI_R_Gfx.2bpp" ; $6A01, 3584 bytes
; I: leftover: 864 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_31_7801::
    INCBIN "data/bank_31/Leftover_31_7801.bin" ; $7801, 2046 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_31_7FFF::
    db $31

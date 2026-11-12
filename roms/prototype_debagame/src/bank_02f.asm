; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $2F. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $02f", ROMX[$4000], BANK[$2f]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2F_4000::
    db $2f

; I: leftover text: 255 bytes of the developers' assembler source in clear (0 listing lines, 9 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2F_4001_AsmSource::
    db "8E,$03,$05,$05", $0d, $0a, $09, "DB", $09, "$47,$58,$8B,$03,$05,$05", $0d, $0a, $0d, $0a, $09, "DB", $09, "$48,$58,$88,$02,$04,$05", $0d, $0a, $09, "DB", $09, "$49,$58,$85,$02,$04,$05", $0d, $0a, $09, "DB", $09, "$4A,$58,$82,$02,$04,$05", $0d, $0a, $09, "DB", $09, "$4B,$58,$7F,$02,$04,$05", $0d, $0a, $0d, $0a, $09, "DB", $09, "$4C,$58,$7C,$02,$04,$05", $0d, $0a, $09, "DB", $09, "$4D,$58,$79,$02,$04,$05", $0d, $0a, $09, "DB", $09, "$4E,$58,$76,$02,$03,$05", $0d, $0a, $09, "DB"

; I: leftover: 4 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2F_4100::
    db $00, $b0, $5f, $c2

; I: leftover text: 252 bytes of the developers' assembler source in clear (0 listing lines, 8 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_2F_4104_AsmSource::
    db ",$58,$73,$02,$03,$05", $0d, $0a, $0d, $0a, $09, "DB", $09, "$50,$58,$70,$02,$03,$04", $0d, $0a, $09, "DB", $09, "$51,$58,$6D,$02,$03,$04", $0d, $0a, $09, "DB", $09, "$52,$58,$6A,$02,$03,$04", $0d, $0a, $09, "DB", $09, "$53,$58,$67,$02,$02,$04", $0d, $0a, $0d, $0a, $09, "DB", $09, "$54,$58,$64,$02,$02,$04", $0d, $0a, $09, "DB", $09, "$55,$58,$61,$02,$02,$04", $0d, $0a, $09, "DB", $09, "$56,$58,$5E,$02,$02,$04", $0d, $0a, $09, "DB", $09, "$57,$58,$5B,$02,$02"

; I: leftover: an exact copy of 5633 bytes of Gfx_03_4001_FNTOOE3 (from 03:4200, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_2F_4200_Gfx_03_4001_FNTOOE3_Part4200::
    INCBIN "data/bank_2f/Leftover_2F_4200_Gfx_03_4001_FNTOOE3_Part4200.bin" ; $4200, 5633 bytes
; I: leftover: an exact copy of Map_03_5801_BG_MOVIE (03:5801, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2F_5801_Map_03_5801_BG_MOVIE::
    INCBIN "data/bank_2f/Leftover_2F_5801_Map_03_5801_BG_MOVIE.bin" ; $5801, 576 bytes
; I: leftover: an exact copy of Gfx_03_5A41_CONF2 (03:5A41, 6144 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2F_5A41_Gfx_03_5A41_CONF2::
    INCBIN "data/bank_2f/Leftover_2F_5A41_Gfx_03_5A41_CONF2.bin" ; $5A41, 6144 bytes
; I: leftover: an exact copy of Map_03_7241_BG_CONF (03:7241, 576 bytes) that nothing in this build reads, runs or
; explains (never read nor run in the L2 runs)
Leftover_2F_7241_Map_03_7241_BG_CONF::
    INCBIN "data/bank_2f/Leftover_2F_7241_Map_03_7241_BG_CONF.bin" ; $7241, 576 bytes
; I: leftover: 1760 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_2F_7481::
    INCBIN "data/bank_2f/Leftover_2F_7481.bin" ; $7481, 2942 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_2F_7FFF::
    db $2f

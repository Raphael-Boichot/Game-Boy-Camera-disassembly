; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $0F. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00f", ROMX[$4000], BANK[$f]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0F_4000::
    db $0f

; I: leftover: 511 bytes that nothing in this build reads, runs or explains (no type row, no traced instruction, no
; reader; never read nor run in the L2 runs)
Leftover_0F_4001::
    INCBIN "data/bank_0f/Leftover_0F_4001.bin" ; $4001, 511 bytes
; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_0F_4200_Grid381Binary::
    INCBIN "data/bank_0f/Leftover_0F_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0F_7FFF::
    db $0f

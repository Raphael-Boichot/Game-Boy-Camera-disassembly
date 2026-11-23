; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $09. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $009", ROMX[$4000], BANK[$9]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_09_4000::
    db $09

; I: leftover PC memory: 511 bytes (09:4001-41FF), a leftover run that holds 2 x86 function prologues (55 8B EC: push
; bp / mov bp,sp; $EC is no Game Boy opcode; 2 in the whole leftover run); nothing in this build reads, runs or
; explains it; only those proofs are proven, the rest of the run is taken as ...
Leftover_09_4001_PcRam::
    INCBIN "data/bank_09/Leftover_09_4001_PcRam.bin" ; $4001, 511 bytes
; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_09_4200_Grid381Binary::
    INCBIN "data/bank_09/Leftover_09_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_09_7FFF::
    db $09

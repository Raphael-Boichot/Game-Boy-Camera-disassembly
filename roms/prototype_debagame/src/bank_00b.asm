; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $0B. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00b", ROMX[$4000], BANK[$b]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0B_4000::
    db $0b

; I: leftover PC memory: 511 bytes (0B:4001-41FF), the 512-byte blocks of a leftover run that hold 3 x86 function
; prologues (55 8B EC: push bp / mov bp,sp; $EC is no Game Boy opcode; 3 in the whole leftover run); bytes that read
; as 16-bit x86 code (15 near calls and 6 RET / RETF in a linear decode; no ...
Leftover_0B_4001_PcRam::
    INCBIN "data/bank_0b/Leftover_0B_4001_PcRam.bin" ; $4001, 511 bytes
; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_0B_4200_Grid381Binary::
    INCBIN "data/bank_0b/Leftover_0B_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0B_7FFF::
    db $0b

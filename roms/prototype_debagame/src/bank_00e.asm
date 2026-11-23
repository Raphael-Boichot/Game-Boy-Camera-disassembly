; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $0E. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00e", ROMX[$4000], BANK[$e]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0E_4000::
    db $0e

; I: leftover: an exact copy of 256 bytes of Gfx_01_4001_FNTOOE1 (from 01:4AA0, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_0E_4001_Gfx_01_4001_FNTOOE1_Part4AA0::
    INCBIN "data/bank_0e/Leftover_0E_4001_Gfx_01_4001_FNTOOE1_Part4AA0.bin" ; $4001, 256 bytes
; I: leftover: 87 bytes between two pieces of a copy of Gfx_01_4001_FNTOOE1 at the same shift, where this copy differs
; from the block (01:4BA0; 87 % of the bytes equal): an edited version; nothing in this build reads, runs or explains
; it (never read nor run in the L2 runs)
Leftover_0E_4101_Gfx_01_4001_FNTOOE1_VariantPart4BA0::
    db $80, $64, $c2, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $74
    db $a0, $ff, $03, $d0, $06, $ef, $4b

; I: leftover: an exact copy of 168 bytes of Gfx_01_4001_FNTOOE1 (from 01:4BEF, a part of the block) that nothing in
; this build reads, runs or explains (never read nor run in the L2 runs)
Leftover_0E_4158_Gfx_01_4001_FNTOOE1_Part4BEF::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $38, $3c, $44, $66, $44, $66, $44, $66, $7c, $7e, $44, $66
    db $44, $66, $00, $00, $78, $7c, $44, $66, $44, $66, $78, $7c, $44, $66, $44, $66
    db $78, $7c, $00, $00, $38, $3c, $44, $66, $40, $60, $40, $60, $40, $60, $44, $66
    db $38, $3c, $00, $00, $78, $7c, $44, $66, $44, $66, $44, $66, $44, $66, $44, $66
    db $78, $7c, $00, $00, $78, $7c, $40, $60, $40, $60, $78, $7c, $40, $60, $40, $60
    db $78, $7c, $00, $00, $78, $7c, $40, $60, $40, $60, $78, $7c, $40, $60, $40, $60
    db $40, $60, $00, $00, $38, $3c, $44, $66, $40, $60, $4c, $6e, $44, $66, $44, $66
    db $38, $3c, $00, $00, $44, $66, $44, $66, $44, $66, $7c, $7e, $44, $66, $44, $66
    db $44, $66, $00, $00, $38, $3c, $10, $18

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the first of the two arrays of 381 columns laid through the image before the bank heads (banks $08-$10, one value
; a byte, mostly $00 / $01 / $03 / $80 / $81; tools/proto_grids.py, ...
Leftover_0E_4200_Grid381Binary::
    INCBIN "data/bank_0e/Leftover_0E_4200_Grid381Binary.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_0E_7FFF::
    db $0e

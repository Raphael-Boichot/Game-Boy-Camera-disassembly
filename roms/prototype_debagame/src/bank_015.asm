; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $15. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $015", ROMX[$4000], BANK[$15]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_15_4000::
    db $15

; I: leftover text: 255 bytes of a listing of the developers' source (file.dmg(line) : text) (8 listing lines, 0
; assembler lines) that nothing in this build reads (never read nor run in the L2 runs)
Leftover_15_4001_SrcListing::
    db "ANK33", $09, "GROUP", $09, "33", $0d, $0a, "bk7.dmg(194) : BANK34", $09, "GROUP", $09, "34", $0d, $0a, "bk7.dmg(201) : BANK35", $09, "GROUP", $09, "35", $0d, $0a, "bk7.dmg(208) : BANK36", $09, "GROUP", $09, "36", $0d, $0a, "bk7.dmg(215) : BANK37", $09, "GROUP", $09, "37", $0d, $0a, "bk7.dmg(222) : BANK38", $09, "GROUP", $09, "38", $0d, $0a, "bk7.dmg(229) : BANK39", $09, "GROUP", $09, "39", $0d, $0a, "bk7.dmg(236) : BANK40", $09, "GROUP", $09, "40", $0d, $0a, "bk7.dmg(243) : "

; I: leftover PC memory: 4 bytes (15:4100-4103), a leftover run that holds the dword $C21AA000, a 4 KB-aligned address
; of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other banks that hold one;
; nothing in this build reads, runs or explains it; only those proofs are ...
Leftover_15_4100_PcRam::
    db $00, $a0, $1a, $c2

; I: leftover text: 252 bytes of a listing of the developers' source (file.dmg(line) : text) (8 listing lines, 0
; assembler lines) that nothing in this build reads (never read nor run in the L2 runs)
Leftover_15_4104_SrcListing::
    db "41", $09, "GROUP", $09, "41", $0d, $0a, "bk7.dmg(250) : BANK42", $09, "GROUP", $09, "42", $0d, $0a, "bk7.dmg(257) : BANK43", $09, "GROUP", $09, "43", $0d, $0a, "bk7.dmg(264) : BANK44", $09, "GROUP", $09, "44", $0d, $0a, "bk7.dmg(271) : BANK45", $09, "GROUP", $09, "45", $0d, $0a, "bk7.dmg(278) : BANK46", $09, "GROUP", $09, "46", $0d, $0a, "bk7.dmg(285) : BANK47", $09, "GROUP", $09, "47", $0d, $0a, "bk7.dmg(292) : BANK48", $09, "GROUP", $09, "48", $0d, $0a, "bk7.dmg(299) : "

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the second of the two arrays of 381 columns laid through the image before the bank heads (banks $11-$19, one code
; $30-$3F a byte, the value 0-15; tools/proto_grids.py, README, the two ...
Leftover_15_4200_Grid381Digits::
    INCBIN "data/bank_15/Leftover_15_4200_Grid381Digits.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_15_7FFF::
    db $15

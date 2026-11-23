; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $14. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $014", ROMX[$4000], BANK[$14]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_14_4000::
    db $14

; I: leftover text: 255 bytes of the developers' assembler source in clear (9 listing lines, 9 assembler lines) that
; nothing in this build reads (never read nor run in the L2 runs)
Leftover_14_4001_AsmSource::
    db "c_0d", $09, "equ", $09, "$8d", $0d, $0a, "def.dmg(176) : c_0e", $09, "equ", $09, "$8e", $0d, $0a, "def.dmg(177) : c_0f", $09, "equ", $09, "$8f", $0d, $0a, "def.dmg(178) : c_a", $09, "equ", $09, "$90", $0d, $0a, "def.dmg(179) : c_b", $09, "equ", $09, "$91", $0d, $0a, "def.dmg(180) : c_c", $09, "equ", $09, "$92", $0d, $0a, "def.dmg(181) : c_d", $09, "equ", $09, "$93", $0d, $0a, "def.dmg(182) : c_e", $09, "equ", $09, "$94", $0d, $0a, "def.dmg(183) : c_f", $09, "equ", $09, "$95", $0d, $0a, "def.dmg(184) : "

; I: leftover PC memory: 4 bytes (14:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C25FC000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_14_4100_PcRam::
    db $00, $c0, $5f, $c2

; I: leftover text: 252 bytes of a listing of the developers' source (file.dmg(line) : text) (9 listing lines, 8
; assembler lines) that nothing in this build reads (never read nor run in the L2 runs)
Leftover_14_4104_SrcListing::
    db "equ", $09, "$96", $0d, $0a, "def.dmg(185) : c_h", $09, "equ", $09, "$97", $0d, $0a, "def.dmg(186) : c_i", $09, "equ", $09, "$98", $0d, $0a, "def.dmg(187) : c_j", $09, "equ", $09, "$99", $0d, $0a, "def.dmg(188) : c_k", $09, "equ", $09, "$9a", $0d, $0a, "def.dmg(189) : c_l", $09, "equ", $09, "$9b", $0d, $0a, "def.dmg(190) : c_m", $09, "equ", $09, "$9c", $0d, $0a, "def.dmg(191) : c_n", $09, "equ", $09, "$9d", $0d, $0a, "def.dmg(192) : c_o", $09, "equ", $09, "$9e", $0d, $0a, "def.dmg(193) : c_p", $09

; I: 15871 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the second of the two arrays of 381 columns laid through the image before the bank heads (banks $11-$19, one code
; $30-$3F a byte, the value 0-15; tools/proto_grids.py, README, the two ...
Leftover_14_4200_Grid381Digits::
    INCBIN "data/bank_14/Leftover_14_4200_Grid381Digits.bin" ; $4200, 15871 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_14_7FFF::
    db $14

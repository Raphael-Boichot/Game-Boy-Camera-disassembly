; Pocket Camera Prototype (Japan) ("DEBAGAME"), bank $13. Written by tools/make_source.py from roms/prototype_debagame/pocketcamera_proto.sym and the tables of
; roms/prototype_debagame/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $013", ROMX[$4000], BANK[$13]

; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_13_4000::
    db $13

; I: leftover text: 255 bytes of a listing of the developers' source (file.dmg(line) : text) (8 listing lines, 6
; assembler lines) that nothing in this build reads (never read nor run in the L2 runs)
Leftover_13_4001_SrcListing::
    db ": FB31A", $09, $09, "DS", $09, "1", $0d, $0a, "equ.dmg(307) : FB31B", $09, $09, "DS", $09, "1", $0d, $0a, "equ.dmg(308) : FB32A", $09, $09, "DS", $09, "1", $0d, $0a, "equ.dmg(309) : FB32B", $09, $09, "DS", $09, "1", $0d, $0a, "equ.dmg(310) : FB33A", $09, $09, "DS", $09, "1", $0d, $0a, "equ.dmg(311) : FB33B", $09, $09, "DS", $09, "1", $0d, $0a, "f_screen.dmg(14) : MK_F_SCR", $0d, $0a, "f_screen.dmg(112) : F_SCR_MODE", $0d, $0a, "f_screen.dmg(136) : PRES", $0d, $0a, "f_screen.dmg("

; I: leftover PC memory: 4 bytes (13:4100-4103), the 512-byte blocks of a leftover run that hold the dword $C21E0000,
; a 4 KB-aligned address of the Windows 9x system arena ($C0000000 up), at offset $100 of the bank, as in the other
; banks that hold one; nothing in this build reads, runs or explains them; ...
Leftover_13_4100_PcRam::
    db $00, $00, $1e, $c2

; I: leftover text: 249 bytes of a listing of the developers' source (file.dmg(line) : text) (6 listing lines, 0
; assembler lines) that nothing in this build reads (never read nor run in the L2 runs)
Leftover_13_4104_SrcListing::
    db " : DOING2", $09, $09, $09, $09, "; ", $83, "o", $83, "b", $83, "t", $83, "@", $82, $a9, $82, $e7, "VRAM", $82, $d6, $82, $cc, $93, "]", $91, $97, $82, $f0, $8d, "s", $82, $a4, $0d, $0a, "f_screen.dmg(175) : VB_F_SCR", $0d, $0a, "gallery.dmg(14) : MAKE_GALLERY", $0d, $0a, "gallery.dmg(92) : GALLERY_MODE", $0d, $0a, "gallery.dmg(194) : PUT_PICTURE", $0d, $0a, "gallery.dmg(212) : TENSOU_END", $09, $0d, $0a, "gallery.dmg(218) : H_BLANK_TX2", $0d, $0a, "gallery.dmg("

; I: 15874 bytes: structured array of unknown kind (owner, 2026-11-23: set aside as typed data of unknown kind): part
; of the second of the two arrays of 381 columns laid through the image before the bank heads (banks $11-$19, one code
; $30-$3F a byte, the value 0-15; tools/proto_grids.py, README, the two ...
Leftover_13_41FD_Grid381Digits::
    INCBIN "data/bank_13/Leftover_13_41FD_Grid381Digits.bin" ; $41FD, 15874 bytes
; C: the bank number, compared by the ROM self-test 00:06F5 (BANK_TEST)
BankNumber_13_7FFF::
    db $13

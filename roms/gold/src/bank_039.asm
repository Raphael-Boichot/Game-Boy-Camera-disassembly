; Game Boy Camera Gold (USA), bank $39. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $039", ROMX[$4000], BANK[$39]

; C: 128x112 picture, 14 x 16 tiles; C: slot 11 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo11_Tiles::
    INCBIN "data/bank_39/AlbumB_Photo11_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail; entry 11 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo11_Thumb::
    INCBIN "data/bank_39/AlbumB_Photo11_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3); entry 11 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo11_Footer::
    INCBIN "data/bank_39/AlbumB_Photo11_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 12 of AlbumB_SlotTbl (02:527A); same bytes as the international picture
AlbumB_Photo12_Tiles::
    INCBIN "data/bank_39/AlbumB_Photo12_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail; entry 12 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo12_Thumb::
    INCBIN "data/bank_39/AlbumB_Photo12_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3); entry 12 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo12_Footer::
    INCBIN "data/bank_39/AlbumB_Photo12_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 13 of AlbumB_SlotTbl (02:527A); same bytes as the international picture
AlbumB_Photo13_Tiles::
    INCBIN "data/bank_39/AlbumB_Photo13_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail; entry 13 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo13_Thumb::
    INCBIN "data/bank_39/AlbumB_Photo13_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3); entry 13 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo13_Footer::
    INCBIN "data/bank_39/AlbumB_Photo13_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 14 of AlbumB_SlotTbl (02:527A); same bytes as the international picture
AlbumB_Photo14_Tiles::
    INCBIN "data/bank_39/AlbumB_Photo14_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail; entry 14 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo14_Thumb::
    INCBIN "data/bank_39/AlbumB_Photo14_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3); entry 14 of AlbumB_SlotTbl (02:527A)
AlbumB_Photo14_Footer::
    INCBIN "data/bank_39/AlbumB_Photo14_Footer.bin" ; $7F00, 256 bytes

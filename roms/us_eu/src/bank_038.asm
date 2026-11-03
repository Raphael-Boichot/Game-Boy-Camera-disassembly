; Game Boy Camera (USA, Europe), bank $38. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $038", ROMX[$4000], BANK[$38]

; C: 128x112 picture, 14 x 16 tiles; C: slot 07 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo07_Tiles::
    INCBIN "data/bank_38/AlbumB_Photo07_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail; entry 7 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo07_Thumb::
    INCBIN "data/bank_38/AlbumB_Photo07_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3); entry 7 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo07_Footer::
    INCBIN "data/bank_38/AlbumB_Photo07_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 8 of AlbumB_SlotTbl (02:5263); a picture of this build (no Japanese album B
; picture has these bytes)
AlbumB_Photo08_Tiles::
    INCBIN "data/bank_38/AlbumB_Photo08_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail; entry 8 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo08_Thumb::
    INCBIN "data/bank_38/AlbumB_Photo08_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3); entry 8 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo08_Footer::
    INCBIN "data/bank_38/AlbumB_Photo08_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 9 of AlbumB_SlotTbl (02:5263); the picture is the Japanese album B picture
; 13
AlbumB_Photo09_Tiles::
    INCBIN "data/bank_38/AlbumB_Photo09_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail; entry 9 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo09_Thumb::
    INCBIN "data/bank_38/AlbumB_Photo09_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3); entry 9 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo09_Footer::
    INCBIN "data/bank_38/AlbumB_Photo09_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; entry 10 of AlbumB_SlotTbl (02:5263); the picture is the Japanese album B picture
; 15
AlbumB_Photo10_Tiles::
    INCBIN "data/bank_38/AlbumB_Photo10_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail; entry 10 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo10_Thumb::
    INCBIN "data/bank_38/AlbumB_Photo10_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3); entry 10 of AlbumB_SlotTbl (02:5263)
AlbumB_Photo10_Footer::
    INCBIN "data/bank_38/AlbumB_Photo10_Footer.bin" ; $7F00, 256 bytes

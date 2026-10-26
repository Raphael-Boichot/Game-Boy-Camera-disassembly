; Game Boy Camera (USA, Europe), bank $37. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $037", ROMX[$4000], BANK[$37]

; I: 128x112 picture, 14 x 16 tiles
AlbumB_Photo03_Tiles::
    INCBIN "data/bank_37/AlbumB_Photo03_Tiles.2bpp" ; $4000, 3584 bytes
; I: 32x28 thumbnail
AlbumB_Photo03_Thumb::
    INCBIN "data/bank_37/AlbumB_Photo03_Thumb.bin" ; $4E00, 256 bytes
; I: metadata footer (README 3.3)
AlbumB_Photo03_Footer::
    INCBIN "data/bank_37/AlbumB_Photo03_Footer.bin" ; $4F00, 256 bytes
; I: 128x112 picture, 14 x 16 tiles
AlbumB_Photo04_Tiles::
    INCBIN "data/bank_37/AlbumB_Photo04_Tiles.2bpp" ; $5000, 3584 bytes
; I: 32x28 thumbnail
AlbumB_Photo04_Thumb::
    INCBIN "data/bank_37/AlbumB_Photo04_Thumb.bin" ; $5E00, 256 bytes
; I: metadata footer (README 3.3)
AlbumB_Photo04_Footer::
    INCBIN "data/bank_37/AlbumB_Photo04_Footer.bin" ; $5F00, 256 bytes
; I: 128x112 picture, 14 x 16 tiles
AlbumB_Photo05_Tiles::
    INCBIN "data/bank_37/AlbumB_Photo05_Tiles.2bpp" ; $6000, 3584 bytes
; I: 32x28 thumbnail
AlbumB_Photo05_Thumb::
    INCBIN "data/bank_37/AlbumB_Photo05_Thumb.bin" ; $6E00, 256 bytes
; I: metadata footer (README 3.3)
AlbumB_Photo05_Footer::
    INCBIN "data/bank_37/AlbumB_Photo05_Footer.bin" ; $6F00, 256 bytes
; I: 128x112 picture, 14 x 16 tiles
AlbumB_Photo06_Tiles::
    INCBIN "data/bank_37/AlbumB_Photo06_Tiles.2bpp" ; $7000, 3584 bytes
; I: 32x28 thumbnail
AlbumB_Photo06_Thumb::
    INCBIN "data/bank_37/AlbumB_Photo06_Thumb.bin" ; $7E00, 256 bytes
; I: metadata footer (README 3.3)
AlbumB_Photo06_Footer::
    INCBIN "data/bank_37/AlbumB_Photo06_Footer.bin" ; $7F00, 256 bytes

; Pocket Camera (Japan) (Rev A), bank $3C. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03c", ROMX[$4000], BANK[$3c]

; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo23_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo23_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo23_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo23_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo23_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo23_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo24_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo24_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo24_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo24_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo24_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo24_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo25_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo25_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo25_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo25_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo25_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo25_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo26_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo26_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo26_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo26_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo26_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo26_Footer.bin" ; $7F00, 256 bytes

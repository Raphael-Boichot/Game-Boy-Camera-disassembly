; Pocket Camera (Japan) (Rev A), bank $3B. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03b", ROMX[$4000], BANK[$3b]

; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo19_Tiles::
    INCBIN "data/bank_3b/AlbumB_Photo19_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo19_Thumb::
    INCBIN "data/bank_3b/AlbumB_Photo19_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo19_Footer::
    INCBIN "data/bank_3b/AlbumB_Photo19_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo20_Tiles::
    INCBIN "data/bank_3b/AlbumB_Photo20_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo20_Thumb::
    INCBIN "data/bank_3b/AlbumB_Photo20_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo20_Footer::
    INCBIN "data/bank_3b/AlbumB_Photo20_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo21_Tiles::
    INCBIN "data/bank_3b/AlbumB_Photo21_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo21_Thumb::
    INCBIN "data/bank_3b/AlbumB_Photo21_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo21_Footer::
    INCBIN "data/bank_3b/AlbumB_Photo21_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo22_Tiles::
    INCBIN "data/bank_3b/AlbumB_Photo22_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo22_Thumb::
    INCBIN "data/bank_3b/AlbumB_Photo22_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo22_Footer::
    INCBIN "data/bank_3b/AlbumB_Photo22_Footer.bin" ; $7F00, 256 bytes

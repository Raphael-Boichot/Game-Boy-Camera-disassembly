; Pocket Camera (Japan) (Rev A), bank $3A. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03a", ROMX[$4000], BANK[$3a]

; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo15_Tiles::
    INCBIN "data/bank_3a/AlbumB_Photo15_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo15_Thumb::
    INCBIN "data/bank_3a/AlbumB_Photo15_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo15_Footer::
    INCBIN "data/bank_3a/AlbumB_Photo15_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo16_Tiles::
    INCBIN "data/bank_3a/AlbumB_Photo16_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo16_Thumb::
    INCBIN "data/bank_3a/AlbumB_Photo16_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo16_Footer::
    INCBIN "data/bank_3a/AlbumB_Photo16_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo17_Tiles::
    INCBIN "data/bank_3a/AlbumB_Photo17_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo17_Thumb::
    INCBIN "data/bank_3a/AlbumB_Photo17_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo17_Footer::
    INCBIN "data/bank_3a/AlbumB_Photo17_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo18_Tiles::
    INCBIN "data/bank_3a/AlbumB_Photo18_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo18_Thumb::
    INCBIN "data/bank_3a/AlbumB_Photo18_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo18_Footer::
    INCBIN "data/bank_3a/AlbumB_Photo18_Footer.bin" ; $7F00, 256 bytes

; Game Boy Camera (USA, Europe), bank $3D. Written by tools/make_source.py from roms/us_eu/gbcam_us.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03d", ROMX[$4000], BANK[$3d]

; C: 128x112 picture, 14 x 16 tiles; C: slot 27 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo27_Tiles::
    INCBIN "data/bank_3d/AlbumB_Photo27_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail; C: slot 27 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo27_Thumb::
    INCBIN "data/bank_3d/AlbumB_Photo27_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 27 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo27_Footer::
    INCBIN "data/bank_3d/AlbumB_Photo27_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 28 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo28_Tiles::
    INCBIN "data/bank_3d/AlbumB_Photo28_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail; C: slot 28 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo28_Thumb::
    INCBIN "data/bank_3d/AlbumB_Photo28_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 28 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo28_Footer::
    INCBIN "data/bank_3d/AlbumB_Photo28_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 29 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo29_Tiles::
    INCBIN "data/bank_3d/AlbumB_Photo29_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail; C: slot 29 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo29_Thumb::
    INCBIN "data/bank_3d/AlbumB_Photo29_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 29 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo29_Footer::
    INCBIN "data/bank_3d/AlbumB_Photo29_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 30 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo30_Tiles::
    INCBIN "data/bank_3d/AlbumB_Photo30_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail; C: slot 30 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo30_Thumb::
    INCBIN "data/bank_3d/AlbumB_Photo30_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 30 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo30_Footer::
    INCBIN "data/bank_3d/AlbumB_Photo30_Footer.bin" ; $7F00, 256 bytes

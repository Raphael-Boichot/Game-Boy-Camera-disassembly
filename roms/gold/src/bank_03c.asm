; Game Boy Camera Gold (USA), bank $3C. Written by tools/make_source.py from roms/gold/gbcam_gold.sym and the tables of
; roms/gold/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $03c", ROMX[$4000], BANK[$3c]

; C: 128x112 picture, 14 x 16 tiles; C: slot 23 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo23_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo23_Tiles.2bpp" ; $4000, 3584 bytes
; C: 32x28 thumbnail; C: slot 23 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo23_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo23_Thumb.bin" ; $4E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 23 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo23_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo23_Footer.bin" ; $4F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 24 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo24_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo24_Tiles.2bpp" ; $5000, 3584 bytes
; C: 32x28 thumbnail; C: slot 24 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo24_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo24_Thumb.bin" ; $5E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 24 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo24_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo24_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 25 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo25_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo25_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail; C: slot 25 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo25_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo25_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 25 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo25_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo25_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles; C: slot 26 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo26_Tiles::
    INCBIN "data/bank_3c/AlbumB_Photo26_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail; C: slot 26 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the picture may
; differ, the role holds
AlbumB_Photo26_Thumb::
    INCBIN "data/bank_3c/AlbumB_Photo26_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3); C: slot 26 of AlbumB_SlotTbl points here (thumbnail +$E00, footer +$F00); the
; picture may differ, the role holds
AlbumB_Photo26_Footer::
    INCBIN "data/bank_3c/AlbumB_Photo26_Footer.bin" ; $7F00, 256 bytes

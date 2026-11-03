; Pocket Camera (Japan) (Rev A), bank $28. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $028", ROMX[$4000], BANK[$28]

; C: entry 0 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4000_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4000_MsgStripB.2bpp" ; $4000, 640 bytes
; C: entry 1 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4280_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4280_MsgStripB.2bpp" ; $4280, 640 bytes
; C: entry 2 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4500_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4500_MsgStripB.2bpp" ; $4500, 640 bytes
; C: entry 3 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4780_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4780_MsgStripB.2bpp" ; $4780, 640 bytes
; C: entry 4 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4A00_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4A00_MsgStripB.2bpp" ; $4A00, 640 bytes
; C: entry 5 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4C80_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4C80_MsgStripB.2bpp" ; $4C80, 640 bytes
; C: entry 6 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_4F00_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_4F00_MsgStripB.2bpp" ; $4F00, 640 bytes
; C: entry 7 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5180_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5180_MsgStripB.2bpp" ; $5180, 640 bytes
; C: entry 8 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5400_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5400_MsgStripB.2bpp" ; $5400, 640 bytes
; C: entry 9 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5680_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5680_MsgStripB.2bpp" ; $5680, 640 bytes
; C: entry 10 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5900_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5900_MsgStripB.2bpp" ; $5900, 640 bytes
; C: entry 11 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5B80_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5B80_MsgStripB.2bpp" ; $5B80, 640 bytes
; C: entry 12 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_5E00_MsgStripB::
    INCBIN "data/bank_28/Gfx_28_5E00_MsgStripB.2bpp" ; $5E00, 640 bytes
; C: entry 14 of the {lo,hi,bank} table 09:739E, 640 bytes each (constant pitch)
Gfx_28_6080_MsgStripB::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $d00, $00

; C: ending picture 'Don't butter me up! Be happy!!' (fork and plate on a checkered border): tiles to $9000 by
; Mode08_State15_CreditsScroll; seen in BGB at 08:16
Gfx_28_7000_CreditsEndingPlate_TilesA::
    INCBIN "data/bank_28/Gfx_28_7000_CreditsEndingPlate_TilesA.2bpp" ; $7000, 2048 bytes
; C: second half of the ending picture, tiles to $8800 (BGB screenshot of 08:16)
Gfx_28_7800_CreditsEndingPlate_TilesB::
    INCBIN "data/bank_28/Gfx_28_7800_CreditsEndingPlate_TilesB.2bpp" ; $7800, 2048 bytes

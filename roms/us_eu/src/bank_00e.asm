; Game Boy Camera (USA, Europe), bank $0E. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00e", ROMX[$4000], BANK[$e]

; I: entry 0 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4000_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4000_MsgStrip.2bpp" ; $4000, 640 bytes
; I: entry 1 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4280_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4280_MsgStrip.2bpp" ; $4280, 640 bytes
; I: entry 2 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4500_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4500_MsgStrip.2bpp" ; $4500, 640 bytes
; I: entry 3 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4780_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4780_MsgStrip.2bpp" ; $4780, 640 bytes
; I: entry 4 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4A00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4A00_MsgStrip.2bpp" ; $4A00, 640 bytes
; I: entry 5 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4C80_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4C80_MsgStrip.2bpp" ; $4C80, 640 bytes
; I: entry 6 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_4F00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_4F00_MsgStrip.2bpp" ; $4F00, 640 bytes
; I: entry 7 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5180_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5180_MsgStrip.2bpp" ; $5180, 640 bytes
; I: entry 8 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5400_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5400_MsgStrip.2bpp" ; $5400, 640 bytes
; I: entry 9 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5680_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5680_MsgStrip.2bpp" ; $5680, 640 bytes
; I: entry 10 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5900_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5900_MsgStrip.2bpp" ; $5900, 640 bytes
; I: entry 11 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5B80_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5B80_MsgStrip.2bpp" ; $5B80, 640 bytes
; I: entry 12 of the {lo,hi,bank} table 04:4493, 640 bytes each (constant pitch)
Gfx_0E_5E00_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_5E00_MsgStrip.2bpp" ; $5E00, 640 bytes
; I: entry 14 of the {lo,hi,bank} table 07:4FAA, 640 bytes each (constant pitch)
Gfx_0E_6080_MsgStrip::
    INCBIN "data/bank_0e/Gfx_0E_6080_MsgStrip.2bpp" ; $6080, 640 bytes
; C: entry 8 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_6300_Head::
    INCBIN "data/bank_0e/Gfx_0E_6300_Head.2bpp" ; $6300, 896 bytes
; C: entry 9 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_6680_Head::
    INCBIN "data/bank_0e/Gfx_0E_6680_Head.2bpp" ; $6680, 896 bytes
; C: entry 10 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_6A00_Head::
    INCBIN "data/bank_0e/Gfx_0E_6A00_Head.2bpp" ; $6A00, 896 bytes
; C: entry 11 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_6D80_Head::
    INCBIN "data/bank_0e/Gfx_0E_6D80_Head.2bpp" ; $6D80, 896 bytes
; I: entry 12 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_7100_Head::
    INCBIN "data/bank_0e/Gfx_0E_7100_Head.2bpp" ; $7100, 896 bytes
; I: entry 13 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_7480_Head::
    INCBIN "data/bank_0e/Gfx_0E_7480_Head.2bpp" ; $7480, 896 bytes
; I: entry 14 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_7800_Head::
    INCBIN "data/bank_0e/Gfx_0E_7800_Head.2bpp" ; $7800, 896 bytes
; I: entry 15 of the {lo,hi,bank} table 05:7F8E, 896 bytes each (constant pitch)
Gfx_0E_7B80_Head::
    INCBIN "data/bank_0e/Gfx_0E_7B80_Head.2bpp" ; $7B80, 896 bytes
; C: far pointer loaded by Mode1A_State04_PlaceOrDelete, Mode1A_State09_ExitDialog (ld a,BANK; ld hl,ADDR; call banked
; copy/far call); length 288 from the nearby ld bc. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic
; corpus, modes 1A (tcrf_check/assets/l3_names/)
Map_0E_7F00_Mode1A_State04_PlaceOrDelete::
    INCBIN "data/bank_0e/Map_0E_7F00_Mode1A_State04_PlaceOrDelete.tilemap" ; $7F00, 256 bytes

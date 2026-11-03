; Pocket Camera (Japan) (Rev A), bank $36. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $036", ROMX[$4000], BANK[$36]

; C: slot-sized (4096 B) blank picture: all zero; the slot table 02:5218 starts at 36:6000 so this slot is never
; listed. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1D)
AlbumB_UnusedSlotA_Tiles::
    INCBIN "data/bank_36/AlbumB_UnusedSlotA_Tiles.2bpp" ; $4000, 3584 bytes
; C: blank thumbnail of the unused slot. L3 pass 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes
; 18 (tcrf_check/assets/l3_names/)
AlbumB_UnusedSlotA_Thumb::
    INCBIN "data/bank_36/AlbumB_UnusedSlotA_Thumb.bin" ; $4E00, 256 bytes
; I: footer with the 'Magic' signature and checksum bytes (README 3.3)
AlbumB_UnusedSlotA_Footer::
    INCBIN "data/bank_36/AlbumB_UnusedSlotA_Footer.bin" ; $4F00, 256 bytes
; C: blank picture; second slot before the table range. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic
; corpus, modes 09 0F 1E (tcrf_check/assets/l3_names/)
AlbumB_UnusedSlotB_Tiles::
    INCBIN "data/bank_36/AlbumB_UnusedSlotB_Tiles.2bpp" ; $5000, 3584 bytes
; C: blank thumbnail. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the organic corpus, modes 09 1E
; (tcrf_check/assets/l3_names/)
AlbumB_UnusedSlotB_Thumb::
    INCBIN "data/bank_36/AlbumB_UnusedSlotB_Thumb.bin" ; $5E00, 256 bytes
; C: footer with the 'Magic' signature. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 09
; (tcrf_check/assets/l3_names/)
AlbumB_UnusedSlotB_Footer::
    INCBIN "data/bank_36/AlbumB_UnusedSlotB_Footer.bin" ; $5F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo01_Tiles::
    INCBIN "data/bank_36/AlbumB_Photo01_Tiles.2bpp" ; $6000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo01_Thumb::
    INCBIN "data/bank_36/AlbumB_Photo01_Thumb.bin" ; $6E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo01_Footer::
    INCBIN "data/bank_36/AlbumB_Photo01_Footer.bin" ; $6F00, 256 bytes
; C: 128x112 picture, 14 x 16 tiles
AlbumB_Photo02_Tiles::
    INCBIN "data/bank_36/AlbumB_Photo02_Tiles.2bpp" ; $7000, 3584 bytes
; C: 32x28 thumbnail
AlbumB_Photo02_Thumb::
    INCBIN "data/bank_36/AlbumB_Photo02_Thumb.bin" ; $7E00, 256 bytes
; C: metadata footer (README 3.3)
AlbumB_Photo02_Footer::
    INCBIN "data/bank_36/AlbumB_Photo02_Footer.bin" ; $7F00, 256 bytes

; Pocket Camera (Japan) (Rev A), bank $19. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $019", ROMX[$4000], BANK[$19]

; C: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_4000_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_4000_Mode0E_State00_Init.2bpp" ; $4000, 2048 bytes
; C: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_4800_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_4800_Mode0E_State00_Init.2bpp" ; $4800, 2048 bytes
; C: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_5000_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_5000_Mode0E_State00_Init.2bpp" ; $5000, 608 bytes
; C: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 08 0E (tcrf_check/assets/l3_names/)
Gfx_19_5260_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA.2bpp" ; $5260, 1440 bytes
; C: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800::
    INCBIN "data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800.2bpp" ; $5800, 608 bytes
; C: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_5A60_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_5A60_Mode08_State13_CreditsPageA.2bpp" ; $5A60, 2048 bytes
; C: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_6260_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_6260_Mode08_State13_CreditsPageA.2bpp" ; $6260, 512 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_6460_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_19/Gfx_19_6460_Mode21_State0B_ResultSetup.2bpp" ; $6460, 256 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_6560_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_19/Gfx_19_6560_Mode21_State0B_ResultSetup.2bpp" ; $6560, 2048 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_6D60_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_19/Gfx_19_6D60_Mode21_State0B_ResultSetup.2bpp" ; $6D60, 1024 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: $1B0 bytes copied by Run_PodiumSetup
; (09:6549) when wRunState+$1F = 1
Gfx_19_7160_Run_PodiumSetup::
    INCBIN "data/bank_19/Gfx_19_7160_Run_PodiumSetup.bin" ; $7160, 13 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: inside the $1B0-byte copy 19:7160 of
; Run_PodiumSetup (09:6549); not a gap
Gfx_19_7160_Run_PodiumSetup_Part716D::
    INCBIN "data/bank_19/Gfx_19_7160_Run_PodiumSetup_Part716D.bin" ; $716D, 4 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: inside the $1B0-byte copy 19:7160 of
; Run_PodiumSetup (09:6549)
Gfx_19_7160_Run_PodiumSetup_Part7171::
    INCBIN "data/bank_19/Gfx_19_7160_Run_PodiumSetup_Part7171.bin" ; $7171, 149 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: inside the $1B0-byte copy 19:7160 of
; Run_PodiumSetup (09:6549); not a gap
Gfx_19_7160_Run_PodiumSetup_Part7206::
    INCBIN "data/bank_19/Gfx_19_7160_Run_PodiumSetup_Part7206.bin" ; $7206, 1 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: inside the $1B0-byte copy 19:7160 of
; Run_PodiumSetup (09:6549)
Gfx_19_7160_Run_PodiumSetup_Part7207::
    INCBIN "data/bank_19/Gfx_19_7160_Run_PodiumSetup_Part7207.bin" ; $7207, 265 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; the scenarios run_race_slow 21:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_7310_Run_PodiumSetup::
    INCBIN "data/bank_19/Gfx_19_7310_Run_PodiumSetup.bin" ; $7310, 4 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides). L3 pass 2026-10-26: read in BGB in
; the scenarios run_race_slow 21:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_7310_Run_PodiumSetup_Part7314::
    INCBIN "data/bank_19/Gfx_19_7310_Run_PodiumSetup_Part7314.bin" ; $7314, 3 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; the scenarios run_race_slow 21:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_7310_Run_PodiumSetup_Part7317::
    INCBIN "data/bank_19/Gfx_19_7310_Run_PodiumSetup_Part7317.bin" ; $7317, 33 bytes
; C: bytes of a 2bpp tile block that no copy reads (organic readers on both sides). L3 pass 2026-10-26: read in BGB in
; the scenarios run_race_slow 21:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_7310_Run_PodiumSetup_Part7338::
    INCBIN "data/bank_19/Gfx_19_7310_Run_PodiumSetup_Part7338.bin" ; $7338, 8 bytes
; C: copied to VRAM/WRAM by Run_PodiumSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB in
; the scenarios run_race_slow 21:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_7310_Run_PodiumSetup_Part7340::
    db $87, $fc, $87, $fc, $8f, $f8, $8f, $fb, $9d, $f6, $9f, $f4, $be, $e9, $b4, $fb
    db $e6, $1d, $fb, $07, $ff, $7e, $ff, $80, $ff, $00, $83, $7c, $00, $ff, $7c, $ff
    db $7f, $c1, $fd, $83, $f9, $07, $f9, $07, $e1, $1f, $81, $7f, $01, $ff, $01, $ff
    db $87, $ff, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $83, $83, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c1, $ff, $3f, $3f, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $07, $f8, $ff, $80, $ff, $80, $ff, $80, $ff, $81, $ff, $83, $fe, $83, $fe
    db $c0, $c0, $3c, $fc, $03, $ff, $7c, $ff, $df, $a3, $ff, $00, $fb, $04, $fc, $03
    db $00, $00, $00, $00, $c7, $c7, $39, $ff, $c1, $ff, $f9, $3f, $a9, $5f, $d7, $f9
    db $87, $fc, $8f, $f8, $8f, $fb, $9d, $f6, $9f, $f4, $be, $e9, $b4, $fb, $87, $ff
    db $ff, $00, $e6, $1d, $fb, $c7, $ff, $3e, $ff, $00, $3f, $c0, $03, $fc, $c0, $ff
    db $7f, $e1, $7d, $c3, $f9, $87, $f9, $07, $f9, $07, $e1, $1f, $81, $7f, $01, $ff
    db $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $3c, $3f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $01, $ff, $c7, $ff, $38, $38, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $f0, $8c, $fc, $83, $ff, $80, $ff, $80, $ff, $80, $ff, $81, $ff, $82, $ff
    db $00, $00, $00, $00, $07, $07, $f8, $ff, $07, $ff, $3f, $f8, $df, $e0, $78, $87
    db $00, $00, $f8, $f8, $07, $ff, $f9, $ff, $e9, $1f, $91, $7f, $f9, $e7, $7f, $c1
    db $83, $fe, $87, $fc, $8f, $f8, $97, $f8, $bf, $e7, $b9, $fe, $87, $f8, $f6, $f9
    db $ff, $00, $fe, $01, $ff, $07, $e3, $1e, $ff, $04, $ff, $f8, $ff, $00, $f8, $07
    db $7f, $c1, $fd, $83, $f9, $07, $e1, $1f, $e1, $1f, $81, $7f, $01, $ff, $01, $ff
    db $0c, $0f, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $ff, $07, $ff, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f9, $ff, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $a0, $00

; C: far pointer loaded by Mode0F_State0A_EraseAll (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C
; from the code: tiles loaded by Mode0F_State0A_EraseAll (04:4D3C)
Gfx_19_7560_Mode0F_State0A_EraseAll::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c1, $fe, $e0, $c0, $c1, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $9f, $7f, $1c, $0e, $1f, $7c
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $eb, $eb, $6b, $eb, $0b, $3f, $ff, $9f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $c0, $18, $80, $fb, $f1
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $7e, $b8, $7c, $fb, $f9
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $2e, $1e, $86, $0e, $b6, $26
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $3c, $9e, $00, $82
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fa, $fd, $c0, $c0, $e5, $f8, $e0, $e0
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1f, $1f, $30, $f8, $3a, $3c
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $1f, $0f, $5e, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $40, $2a, $9a, $b1, $60, $e0
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e7, $ef, $e7, $ef, $c7, $ef
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f8, $ff, $f8, $f8, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $07, $bf, $02, $07, $9f, $bf
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $ff, $08, $f3, $00, $00, $08, $f3
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fb, $f8, $f2, $79, $e2, $c0
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3e, $7c, $bd, $18, $5f, $39
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $3f, $1f, $1f, $cf, $c7, $ef
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f0, $f8, $e3, $f6, $e2, $f4, $f9, $f0, $ff, $fe, $fd, $fe, $ff, $ff, $ff, $ff
    db $79, $7d, $3f, $7f, $3f, $7f, $3f, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff
    db $df, $cf, $c7, $ef, $f7, $e7, $ff, $f3, $f1, $fb, $fb, $ff, $ff, $ff, $ff, $ff
    db $f3, $e7, $c7, $ef, $ef, $cf, $c7, $ef, $f3, $e0, $f7, $f8, $ff, $ff, $ff, $ff
    db $f3, $fb, $fe, $f3, $ff, $f2, $f2, $f8, $fd, $78, $7f, $ff, $ff, $ff, $ff, $ff
    db $67, $36, $23, $77, $76, $67, $46, $ee, $1f, $8f, $3f, $ff, $ff, $ff, $ff, $ff
    db $21, $9e, $01, $81, $64, $99, $00, $00, $85, $f9, $e3, $81, $ff, $ff, $ff, $ff
    db $e0, $e7, $e0, $e0, $e0, $e7, $40, $c0, $d5, $e2, $df, $cf, $ff, $ff, $ff, $ff
    db $38, $3c, $30, $39, $34, $3a, $19, $1c, $5c, $39, $df, $9c, $ff, $ff, $ff, $ff
    db $2e, $33, $8b, $07, $3f, $3f, $7f, $3f, $86, $7f, $16, $0f, $ff, $ff, $ff, $ff
    db $20, $6e, $a0, $20, $64, $ae, $60, $a0, $20, $6e, $66, $6c, $ff, $ff, $ff, $ff
    db $4f, $ef, $4f, $ef, $4f, $ef, $47, $ef, $71, $e6, $68, $f0, $ff, $ff, $ff, $ff
    db $f8, $f8, $f8, $ff, $dd, $9e, $3d, $98, $7a, $39, $7a, $fc, $ff, $ff, $ff, $ff
    db $03, $07, $27, $9f, $3f, $1f, $87, $0f, $97, $23, $b3, $7f, $ff, $ff, $ff, $ff
    db $81, $c3, $bb, $91, $03, $b1, $c9, $83, $fb, $f3, $e7, $f7, $ff, $ff, $ff, $ff
    db $c6, $f3, $e2, $f7, $ee, $e7, $e6, $cf, $d6, $c8, $df, $f8, $ff, $ff, $ff, $ff
    db $7f, $7f, $3f, $7f, $3f, $7f, $3f, $7f, $7e, $7f, $fe, $ff, $ff, $ff, $ff, $ff
    db $cf, $ef, $df, $8f, $9f, $3f, $3f, $7f, $ff, $7f, $7f, $7f

    ; padding
    ds $14, $ff

; C: far pointer loaded by Mode0F_State0A_EraseAll (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1536
; from the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: tiles loaded by Mode0F_State0A_EraseAll (04:4D4A)
Gfx_19_77E0_Mode0F_State0A_EraseAll::
    db $00, $00, $00, $00, $00, $00, $01, $01, $07, $07, $0f, $0f, $0f, $0f, $1f, $1f
    db $1f, $1f, $3e, $3f, $3f, $3e, $3f, $3e, $3d, $3e, $3f, $3c, $3f, $3c, $3b, $3c
    db $00, $00, $00, $00, $7f, $7f, $dd, $e3, $ff, $c1, $be, $c1, $ff, $80, $7f, $80
    db $ff, $00, $eb, $1c, $ff, $1c, $ff, $1c, $dd, $3e, $ff, $3e, $ff, $3e, $ff, $00
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $f0, $f8, $f8, $f8, $f8, $7c, $fc
    db $fc, $7c, $be, $7e, $fe, $3e, $fe, $3e, $de, $3e, $fe, $1e, $fe, $1e, $ee, $1e
    db $00, $00, $00, $00, $1e, $1e, $3f, $21, $7f, $5c, $7f, $5c, $df, $bc, $df, $bd
    db $ff, $bd, $fa, $bd, $fb, $bc, $fb, $bc, $fb, $bc, $fb, $bc, $fb, $bc, $fb, $bd
    db $00, $00, $00, $00, $1f, $1f, $ff, $e0, $fe, $0f, $fe, $0f, $ff, $0f, $ff, $ff
    db $ff, $ff, $ff, $ff, $fe, $0f, $fe, $0f, $fe, $0f, $be, $7f, $ff, $ff, $ff, $ff
    db $00, $00, $00, $00, $c0, $c0, $e7, $27, $ff, $18, $ff, $00, $1e, $e1, $dd, $e3
    db $dd, $e3, $ff, $c3, $ff, $03, $ff, $03, $ff, $03, $ff, $03, $7f, $83, $ff, $c3
    db $00, $00, $00, $00, $00, $00, $f0, $f0, $ff, $0f, $1f, $e0, $fe, $e1, $fe, $e1
    db $df, $e0, $ff, $c0, $bf, $c0, $bf, $c0, $bf, $c0, $a7, $d8, $bf, $dc, $ff, $fc
    db $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0, $f8, $08, $dc, $e4, $ec, $f4
    db $fc, $f4, $76, $fa, $fe, $7a, $bf, $79, $fb, $3d, $ff, $3d, $df, $3d, $df, $3d
    db $1b, $1c, $1f, $18, $0f, $08, $0f, $08, $07, $07, $01, $01, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $bf, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $7f, $7f, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ec, $1c, $fc, $0c, $78, $88, $f8, $88, $f0, $f0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fb, $bd, $ff, $bd, $df, $bd, $7f, $5c, $67, $5b, $3c, $24, $18, $18, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $cf, $ef, $df, $fe, $ff, $fd, $fe, $83, $7c, $ff, $83, $7c, $7c, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fd, $e3, $ef, $f1, $de, $e1, $bf, $4e, $f1, $31, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $fc, $ff, $f8, $f7, $f9, $6e, $f6, $f8, $08, $f0, $f0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $c2, $3e, $fc, $04, $f8, $f8, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $01, $07, $07, $0f, $0c, $0f, $0c, $1f, $1c
    db $1f, $1c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c
    db $00, $00, $00, $00, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00
    db $ff, $3f, $ff, $3f, $ff, $3f, $ff, $00, $ff, $00, $ff, $00, $ff, $3f, $ff, $3f
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $f0, $78, $f8, $b8, $78, $dc, $3c
    db $fc, $1c, $fe, $1e, $fe, $1e, $fe, $1e, $de, $3e, $ee, $1e, $fe, $0e, $fe, $0e
    db $00, $00, $00, $00, $00, $00, $1c, $1c, $3f, $23, $71, $4e, $6f, $5e, $df, $be
    db $dd, $be, $ff, $bc, $fb, $bc, $fb, $bc, $fb, $bc, $fa, $bd, $fb, $bd, $ff, $bf
    db $00, $00, $00, $00, $00, $00, $00, $00, $1f, $1f, $ff, $e0, $ed, $1e, $ee, $1f
    db $ef, $1f, $ff, $07, $fb, $07, $fb, $07, $fb, $07, $7d, $83, $fd, $c3, $ff, $c1
    db $00, $00, $00, $00, $00, $00, $0f, $0f, $9f, $90, $fc, $63, $fb, $07, $f7, $0f
    db $ff, $0f, $7f, $8f, $fe, $8f, $fe, $8f, $be, $cf, $fe, $cf, $fe, $cf, $ff, $cf
    db $00, $00, $00, $00, $00, $00, $80, $80, $c7, $47, $7f, $b8, $fb, $87, $fb, $87
    db $7b, $87, $fd, $03, $ff, $01, $fe, $01, $ff, $00, $9f, $60, $7f, $f0, $ff, $f0
    db $00, $00, $00, $00, $00, $00, $00, $00, $c0, $c0, $ff, $3f, $7f, $80, $bf, $c0
    db $ff, $c0, $df, $e0, $ff, $e0, $ff, $e0, $ef, $f0, $ff, $f0, $7f, $f0, $7f, $f0
    db $00, $00, $3f, $3f, $7f, $40, $c7, $b8, $df, $bf, $df, $3f, $ff, $1f, $ff, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $07, $ff, $ff, $0f, $fe, $1f, $bf, $7f, $7f, $ff
    db $00, $00, $e0, $e0, $f0, $10, $30, $d0, $f0, $d0, $f0, $d0, $f8, $c8, $9c, $64
    db $fc, $f4, $fc, $f4, $ec, $f4, $fc, $c4, $78, $88, $f0, $10, $78, $98, $fc, $84
    db $1f, $1c, $1f, $1c, $0f, $0c, $0f, $0c, $07, $07, $01, $01, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $3f, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $7f, $7f, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $0c, $fc, $0c, $e8, $18, $d8, $38, $f0, $f0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $df, $bf, $ff, $9f, $6f, $5f, $76, $4f, $3f, $20, $1f, $1f, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fe, $c1, $bf, $c0, $7f, $9c, $e3, $23, $c0, $40, $80, $80, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $37, $cf, $ff, $07, $fb, $07, $fd, $f3, $0f, $08, $07, $07, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $f0, $ef, $f0, $df, $e0, $bf, $c3, $fc, $0c, $f0, $f0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1e, $e1, $fd, $03, $fb, $07, $ff, $e3, $1f, $19, $07, $04, $03, $03, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $f3, $fd, $e3, $ff, $c1, $ff, $81, $ff, $00, $ff, $3e, $c1, $c1, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $be, $c2, $c3, $fd, $fb, $fd, $fb, $fd, $7f, $f9, $fe, $02, $fc, $fc, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $07, $00, $0f, $00, $0f, $00, $1f, $00
    db $1f, $00, $3e, $01, $3f, $01, $3f, $01, $3d, $03, $3f, $03, $3f, $03, $3b, $07
    db $00, $00, $00, $00, $7f, $00, $dd, $3e, $ff, $3e, $be, $7f, $7f, $ff, $ff, $ff
    db $ff, $ff, $eb, $f7, $ff, $e3, $ff, $e3, $dd, $e3, $ff, $c1, $ff, $c1, $ff, $ff
    db $00, $00, $00, $00, $00, $00, $c0, $00, $f0, $00, $f8, $00, $78, $80, $fc, $80
    db $fc, $80, $be, $c0, $fe, $c0, $fe, $c0, $de, $e0, $fe, $e0, $fe, $e0, $fe, $e0
    db $1f, $07, $1f, $07, $0f, $07, $0f, $07, $07, $00, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $ff, $ff, $ff, $bf, $c0, $ff, $80, $ff, $00, $ff, $00, $7f, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $f0, $fc, $f0, $78, $f0, $f8, $70, $f0, $00, $c0, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $00, $07, $00, $0f, $03, $0f, $03, $1f, $03
    db $1f, $03, $3f, $03, $3f, $03, $3f, $03, $3f, $03, $3f, $03, $3f, $03, $3f, $03
    db $00, $00, $00, $00, $7f, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $c0, $ff, $c0, $ff, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $c0, $ff, $c0
    db $00, $00, $00, $00, $00, $00, $c0, $00, $f0, $00, $78, $80, $b8, $c0, $dc, $e0
    db $fc, $e0, $fe, $e0, $fe, $e0, $fe, $e0, $de, $e0, $ee, $f0, $fe, $f0, $f6, $f8
    db $1f, $03, $1f, $03, $0f, $03, $0f, $03, $07, $00, $01, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $c0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $7f, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f4, $f8, $fc, $f0, $e8, $f0, $d8, $e0, $f0, $00, $c0

    ; padding
    ds $95, $00

; C: target 4 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_19_7E60_Tbl53A6_4::
    INCBIN "data/bank_19/Src_19_7E60_Tbl53A6_4.bin" ; $7E60, 416 bytes

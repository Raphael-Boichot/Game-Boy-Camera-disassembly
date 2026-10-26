; Game Boy Camera (USA, Europe), bank $19. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $019", ROMX[$4000], BANK[$19]

; I: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_4000_Mode0E_State00_Init::
    db $70
    db $80
    db $fe
    db $ff
    db $ff
    db $ff
    db $63
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $70
    db $60
    db $70
    db $60
    db $e0
    db $60
    db $e0
    db $60
    db $e0
    db $60
    db $40
    db $e0
    db $40
    db $e0
    db $40
    db $e0
    db $40
    db $60
    db $e0
    db $40
    db $e0
    db $40
    db $40
    db $c0
    db $44
    db $f8
    db $9e
    db $7e
    db $0e
    db $00
    db $00
    db $00
    db $b8
    db $30
    db $b8
    db $30
    db $78
    db $30
    db $70
    db $30
    db $70
    db $30
    db $20
    db $70
    db $20
    db $70
    db $30
    db $60
    db $36
    db $9f
    db $86
    db $31
    db $60
    db $30
    db $70
    db $20
    db $60
    db $20
    db $2c
    db $70
    db $3f
    db $7e
    db $59
    db $66
    db $00
    db $00
    db $e0
    db $00
    db $f8
    db $f8
    db $f8
    db $f8
    db $d8
    db $38
    db $30
    db $18
    db $10
    db $38
    db $18
    db $30
    db $e0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $f3
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $00
    db $d3
    db $9c
    db $30
    db $ff
    db $30
    db $ff
    db $f0
    db $ff
    db $f0
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $30
    db $ff

    db $3f
    db $f0
    db $30
    db $f0
    db $30
    db $ff
    db $30
    db $ff
    db $30
    db $ff
    db $30
    db $ff
    db $30
    db $ff
    db $31
    db $84
    db $25
    db $90
    db $29
    db $90
    db $21
    db $98
    db $25
    db $98
    db $21
    db $9c
    db $21
    db $9c
    db $63
    db $9c
    db $f0
    db $f0
    db $30
    db $f0
    db $30
    db $f0
    db $30
    db $ff
    db $30
    db $ff
    db $30
    db $ff
    db $30
    db $f0
    db $3f
    db $f0
    db $ff
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $21
    db $9c
    db $01
    db $9c
    db $11
    db $8c
    db $21
    db $8c
    db $29
    db $84
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $f0
    db $c0
    db $e0
    db $e0
    db $c0
    db $e0
    db $c0
    db $c0
    db $c0
    db $40
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $63
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $61
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $e0
    db $f0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $e0
    db $c0
    db $e0
    db $c0
    db $e0
    db $c0
    db $e0
    db $9f
    db $ff
    db $9f
    db $ff
    db $3f
    db $ff
    db $3f
    db $ff
    db $07
    db $ff
    db $01
    db $ff
    db $f1
    db $ff
    db $ff
    db $ff
    db $c3
    db $ff
    db $c3
    db $ff
    db $c7
    db $ff
    db $c7
    db $ff
    db $cf
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $78
    db $f0
    db $78
    db $f0
    db $f8
    db $f0
    db $f0
    db $f0
    db $f0
    db $f0
    db $e0
    db $f0
    db $e0
    db $f0
    db $f0
    db $e0
    db $60
    db $ff
    db $4c
    db $ff
    db $cf
    db $ff
    db $cf
    db $ff
    db $df
    db $ff
    db $83
    db $ff
    db $80
    db $ff
    db $98
    db $ff
    db $9e
    db $ff
    db $8e
    db $ff
    db $8c
    db $ff
    db $8c
    db $ff
    db $c8
    db $ff
    db $c9
    db $ff
    db $c9
    db $ff
    db $c1
    db $ff
    db $00
    db $00
    db $e0
    db $00
    db $f8
    db $f8
    db $f8
    db $f8
    db $f8
    db $f8
    db $f0
    db $f8
    db $f0
    db $f8
    db $f8
    db $f0
    db $e0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $3f
    db $ff
    db $21
    db $ff
    db $fc
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $9f
    db $ff
    db $9f
    db $ff
    db $9e
    db $ff
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00

    ; padding
    ds $f, $00

    db $f8

    db $ff
    db $ff
    db $ff
    db $61
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e7
    db $7f
    db $ff
    db $7f
    db $70
    db $7f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $08
    db $3c
    db $0c
    db $38
    db $10
    db $38
    db $18
    db $30
    db $20
    db $10
    db $00
    db $00
    db $00
    db $00
    db $60
    db $80
    db $08
    db $04
    db $c0
    db $0c
    db $80
    db $cc
    db $c0
    db $0c
    db $00
    db $00
    db $00
    db $00
    db $20
    db $c0
    db $fc
    db $ff
    db $c8
    db $98
    db $88
    db $1f
    db $1f
    db $0f
    db $01
    db $00
    db $00
    db $00
    db $20
    db $c0
    db $fc
    db $ff
    db $ff
    db $ff
    db $19
    db $0f
    db $07
    db $0f
    db $06
    db $00
    db $00
    db $00
    db $e0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $ef
    db $1f
    db $33
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $f3
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $73
    db $0f
    db $00
    db $00
    db $00
    db $00
    db $1c
    db $18
    db $3c
    db $18
    db $3c
    db $1f
    db $3f
    db $1f
    db $23
    db $1f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0e
    db $06
    db $06
    db $06
    db $c6
    db $3e
    db $ff
    db $fe
    db $f9
    db $fe
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $8c
    db $f0
    db $00
    db $00
    db $03
    db $00
    db $8f
    db $7f
    db $ff
    db $ff
    db $e3
    db $fc
    db $80
    db $00
    db $00
    db $00
    db $33
    db $61
    db $30
    db $00
    db $00
    db $00
    db $07
    db $00
    db $1f
    db $ff
    db $ff
    db $ff
    db $c7
    db $f8
    db $00
    db $00
    db $40
    db $c0
    db $40
    db $c0
    db $c0
    db $00
    db $00
    db $00
    db $0f
    db $00
    db $7f
    db $ff
    db $ff
    db $ff
    db $ee
    db $f0
    db $19
    db $00
    db $18
    db $f8
    db $e0
    db $f8
    db $00
    db $00
    db $00
    db $00
    db $30
    db $0f
    db $ff
    db $ff
    db $ff
    db $ff
    db $38
    db $18
    db $3f
    db $18
    db $1f
    db $1f
    db $03
    db $1c
    db $00
    db $00
    db $00
    db $00
    db $61
    db $1f
    db $ff
    db $ff
    db $03
    db $03
    db $07
    db $03
    db $03
    db $06
    db $7c
    db $8e
    db $f8
    db $fc
    db $f8
    db $00
    db $00
    db $00
    db $c3
    db $3f
    db $e6
    db $c0
    db $e4
    db $c6
    db $c6
    db $e7
    db $47
    db $e3
    db $43
    db $e1
    db $40
    db $e0
    db $e0
    db $60
    db $e0
    db $60
    db $20
    db $61
    db $73
    db $21
    db $71
    db $23
    db $72
    db $23
    db $37
    db $22
    db $30
    db $26
    db $04
    db $36
    db $0e
    db $34
    db $05
    db $02
    db $00
    db $06
    db $80
    db $06
    db $c0
    db $c6
    db $02
    db $c4
    db $06
    db $04
    db $0e
    db $04
    db $0e
    db $04
    db $2e
    db $04
    db $04
    db $0c
    db $07
    db $0c
    db $07
    db $0f
    db $0b
    db $0c
    db $6c
    db $08
    db $bc
    db $48
    db $5c
    db $c8
    db $10
    db $18
    db $b8
    db $10
    db $38
    db $10
    db $30
    db $10
    db $30
    db $10
    db $38
    db $10
    db $38
    db $10
    db $10
    db $18
    db $39
    db $1e
    db $13
    db $3f
    db $01
    db $30
    db $20
    db $30
    db $20
    db $30
    db $70
    db $20
    db $68
    db $30
    db $7c
    db $3f
    db $6c
    db $7e
    db $6e
    db $44
    db $64
    db $46
    db $e2
    db $46
    db $c7
    db $42
    db $07
    db $c2
    db $02
    db $c3
    db $00
    db $03
    db $1c
    db $0e
    db $1e
    db $0c
    db $0e
    db $1c
    db $0e
    db $1c
    db $0c
    db $1c
    db $0c
    db $1c
    db $18
    db $1c
    db $18
    db $1c
    db $ce
    db $cc
    db $ce
    db $cc
    db $ce
    db $cc
    db $8e
    db $cc
    db $84
    db $ce
    db $84
    db $8e
    db $84
    db $0e
    db $04
    db $0e
    db $01
    db $00
    db $01
    db $00
    db $01
    db $00
    db $00
    db $01
    db $80
    db $01
    db $81
    db $03
    db $37
    db $8f
    db $ff
    db $fe
    db $62
    db $c7
    db $e2
    db $47
    db $c6
    db $63
    db $47
    db $e3
    db $c7
    db $e3
    db $f3
    db $e3
    db $71
    db $e3
    db $71
    db $e3
    db $b8
    db $9c
    db $de
    db $8c
    db $cf
    db $86
    db $c3
    db $87
    db $c1
    db $83
    db $80
    db $c1
    db $80
    db $c0
    db $80
    db $c0
    db $03
    db $01
    db $03
    db $01
    db $d0
    db $21
    db $f0
    db $e1
    db $e0
    db $01
    db $00
    db $01
    db $01
    db $00
    db $01
    db $00
    db $60
    db $30
    db $70
    db $30
    db $71
    db $30
    db $37
    db $3f
    db $18
    db $3f
    db $18
    db $30
    db $10
    db $38
    db $30
    db $18
    db $06
    db $0c
    db $04
    db $00
    db $00
    db $00
    db $00
    db $00
    db $18
    db $e0
    db $fe
    db $fc
    db $cf
    db $3e
    db $02
    db $07
    db $84
    db $ce
    db $84
    db $ce
    db $84
    db $ce
    db $8e
    db $c6
    db $83
    db $c7
    db $c5
    db $c3
    db $c0
    db $c0
    db $c0
    db $c0
    db $fc
    db $ff
    db $ff
    db $ff
    db $c3
    db $3f
    db $00
    db $00
    db $00
    db $00
    db $60
    db $00
    db $20
    db $60
    db $21
    db $60
    db $ff
    db $ff
    db $c3
    db $3f
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $00
    db $d1
    db $e2
    db $93
    db $62
    db $07
    db $02
    db $43
    db $3f
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $80
    db $e0
    db $c7
    db $47
    db $67
    db $66
    db $24
    db $7e
    db $24
    db $00
    db $00
    db $00
    db $00
    db $c0
    db $00
    db $85
    db $c3
    db $06
    db $07
    db $04
    db $0c
    db $1c
    db $08
    db $00
    db $18
    db $00
    db $00
    db $16
    db $08
    db $8e
    db $1f
    db $0d
    db $9b
    db $90
    db $98
    db $10
    db $98
    db $b8
    db $10
    db $38
    db $10
    db $2e
    db $10
    db $1e
    db $3f
    db $29
    db $37
    db $31
    db $21
    db $70
    db $21
    db $60
    db $21
    db $23
    db $61
    db $32
    db $7f
    db $06
    db $07
    db $0f
    db $06
    db $06
    db $0e
    db $06
    db $0e
    db $06
    db $0e
    db $04
    db $0e
    db $0c
    db $0e
    db $0c
    db $0e
    db $1c
    db $18
    db $1c
    db $18
    db $08
    db $1c
    db $88
    db $1c
    db $c8
    db $9c
    db $cc
    db $9c
    db $9c
    db $cc
    db $dc
    db $cc
    db $78
    db $00
    db $fc
    db $fe
    db $06
    db $ff
    db $07
    db $03
    db $03
    db $01
    db $00
    db $01
    db $00
    db $01
    db $00
    db $01
    db $00
    db $00
    db $c0
    db $07
    db $8f
    db $c7
    db $8f
    db $c6
    db $8f
    db $c6
    db $a7
    db $c6
    db $63
    db $c6
    db $62
    db $c7
    db $00
    db $00
    db $01
    db $00
    db $01
    db $00
    db $c1
    db $80
    db $81
    db $c0
    db $41
    db $e0
    db $20
    db $f0
    db $30
    db $b8
    db $0c
    db $f0
    db $00
    db $00
    db $03
    db $00
    db $23
    db $e1
    db $c1
    db $e3
    db $01
    db $03
    db $01
    db $03
    db $01
    db $03
    db $fe
    db $ff
    db $18
    db $e0
    db $00
    db $00
    db $0e
    db $01
    db $5f
    db $3f
    db $36
    db $78
    db $20
    db $70
    db $60
    db $30
    db $ff
    db $ff
    db $fc
    db $ff
    db $30
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $68
    db $f0
    db $f8
    db $fc
    db $1e
    db $0c
    db $c7
    db $3f
    db $ff
    db $ff
    db $f8
    db $ff
    db $f0
    db $80
    db $80
    db $80
    db $82
    db $81
    db $87
    db $83
    db $cf
    db $86
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $f0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $60
    db $80
    db $f8
    db $ff
    db $ff
    db $ff
    db $c3
    db $3f
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $60
    db $80
    db $f8
    db $ff
    db $ff
    db $ff
    db $e7
    db $1f
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $e0
    db $00
    db $fc
    db $ff
    db $ff
    db $ff
    db $e7
    db $1f
    db $01
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $04
    db $03
    db $03
    db $07
    db $03
    db $07
    db $02
    db $07
    db $06
    db $07
    db $06
    db $07
    db $00
    db $00
    db $00
    db $00
    db $c8
    db $30
    db $f8
    db $f8
    db $f8
    db $f8
    db $f8
    db $18
    db $1c
    db $18
    db $1c
    db $18
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $0f
    db $ff
    db $ff
    db $ff
    db $f8
    db $ff
    db $c0
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $03
    db $00
    db $1f
    db $ff
    db $ff
    db $ff
    db $f1
    db $fe
    db $80
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $00
    db $06
    db $01
    db $3f
    db $ff
    db $ff
    db $ff
    db $87
    db $f8
    db $40
    db $3f
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $10
    db $e0
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $ff
    db $ff
    db $ff
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $30
    db $ff
    db $30
    db $ff
    db $3f
    db $ff
    db $3f
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff
    db $00
    db $ff

    db $02, $f9, $22, $19, $a2, $19, $22, $99, $22, $99, $22, $99, $22, $19, $c6, $39
    db $04, $73, $84, $72, $05, $f2, $04, $f3, $04, $f3, $04, $f3, $28, $10, $e7, $18
    db $80, $70, $87, $30, $24, $93, $24, $93, $24, $93, $24, $93, $20, $10, $cf, $30
    db $00, $f0, $07, $f0, $04, $f3, $04, $f3, $04, $f3, $04, $f3, $00, $f0, $0f, $f0
    db $42, $39, $42, $39, $42, $39, $42, $39, $42, $39, $42, $39, $84, $03, $78, $87
    db $10, $cf, $10, $cf, $10, $cf, $10, $cf, $10, $cf, $10, $cf, $10, $cf, $30, $cf
    db $40, $81, $40, $81, $40, $81, $a2, $41, $20, $43, $64, $03, $08, $07, $10, $0f
    db $09, $10, $00, $1f, $2f, $10, $10, $20, $50, $20, $60, $00, $80, $00, $40, $80
    db $00, $3c, $c0, $1c, $20, $cc, $0a, $e4, $08, $e6, $09, $e6, $10, $0f, $e0, $1f
    db $00, $3e, $c0, $1f, $20, $cf, $08, $e7, $09, $e4, $09, $e4, $12, $0c, $e1, $1e
    db $00, $1e, $e0, $1f, $00, $ff, $00, $ff, $01, $fc, $01, $fc, $0a, $04, $f9, $06
    db $00, $0c, $a1, $1c, $11, $cc, $11, $cc, $29, $c4, $09, $e4, $08, $e4, $0b, $e4
    db $10, $0c, $e1, $1c, $01, $fc, $01, $fc, $01, $fc, $01, $fc, $01, $fc, $03, $fc
    db $30, $fc, $f1, $3c, $31, $3c, $31, $fc, $31, $fc, $31, $fc, $31, $fc, $33, $fc
    db $00, $ff, $ff, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $ff, $ff, $00, $ff, $00, $ff, $42, $39, $a2, $19, $22, $99, $22, $99, $02, $f9
    db $ff, $ff, $00, $ff, $00, $ff, $20, $18, $e7, $10, $04, $f3, $04, $f3, $04, $f3
    db $ff, $ff, $00, $ff, $00, $ff, $80, $70, $47, $30, $44, $33, $44, $33, $44, $33
    db $ff, $ff, $00, $ff, $00, $ff, $00, $f0, $07, $f0, $04, $f3, $04, $f3, $04, $f3
    db $ff, $ff, $00, $ff, $00, $ff, $04, $83, $7a, $01, $42, $39, $42, $39, $42, $39
    db $ff, $ff, $00, $ff, $00, $ff, $00, $03, $dc, $03, $10, $cf, $10, $cf, $10, $cf
    db $ff, $ff, $00, $ff, $40, $3f, $10, $0e, $09, $06, $84, $03, $80, $03, $82, $01
    db $ff, $ff, $00, $ff, $10, $e0, $45, $82, $81, $06, $0a, $05, $04, $09, $14, $09
    db $ff, $ff, $00, $ff, $00, $ff, $10, $0f, $e8, $07, $09, $e6, $18, $e6, $02, $fc
    db $ff, $ff, $00, $ff, $00, $ff, $10, $0e, $e9, $04, $09, $e4, $19, $e4, $01, $fc
    db $ff, $ff, $00, $ff, $00, $ff, $08, $06, $f9, $04, $01, $fc, $01, $fc, $01, $fc
    db $ff, $ff, $00, $ff, $00, $ff, $10, $0c, $e9, $04, $09, $e4, $09, $e4, $09, $e4
    db $3f, $3f, $30, $3f, $30, $3f, $30, $fc, $31, $fc, $31, $fc, $31, $3c, $f1, $3c
    db $00, $00, $00, $00, $00, $00, $00, $ff, $00, $ff, $00, $ff, $00, $00, $ff, $00

; I: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_4760_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_4760_Mode0E_State00_Init.2bpp" ; $4760, 160 bytes
; C: loaded by Mem_CopyFromBank at 07:407B: Gfx $800 bytes to $8800 (this build's trace)
Gfx_19_4800_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_4800_Mode0E_State00_Init.2bpp" ; $4800, 1888 bytes
; C: copied to VRAM/WRAM by Mode0E_State00_Init (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read in BGB
; in 2 replay(s) of the organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Gfx_19_4F60_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_4F60_Mode0E_State00_Init.2bpp" ; $4F60, 160 bytes
; C: loaded by Mem_CopyFromBank at 07:4089: Gfx $800 bytes to $8000 (this build's trace)
Gfx_19_5000_Mode0E_State00_Init::
    INCBIN "data/bank_19/Gfx_19_5000_Mode0E_State00_Init.2bpp" ; $5000, 608 bytes
; I: far pointer loaded by Mode08_State13_CreditsPageA (ld a,BANK; ld hl,ADDR; call banked copy/far call). L3 pass
; 2026-10-26: read in BGB in 6 replay(s) of the organic corpus, modes 08 0E (tcrf_check/assets/l3_names/)
Gfx_19_5260_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA.2bpp" ; $5260, 1440 bytes
; I: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800::
    INCBIN "data/bank_19/Gfx_19_5260_Mode08_State13_CreditsPageA_Part5800.2bpp" ; $5800, 608 bytes
; I: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_5A60_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_5A60_Mode08_State13_CreditsPageA.2bpp" ; $5A60, 2048 bytes
; I: copied to VRAM/WRAM by Mode08_State13_CreditsPageA (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26:
; read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Gfx_19_6260_Mode08_State13_CreditsPageA::
    INCBIN "data/bank_19/Gfx_19_6260_Mode08_State13_CreditsPageA.2bpp" ; $6260, 512 bytes
; C: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
; in BGB in the scenarios run_race_fast 21:0B, run_race_result 21:0B, run_race_slow 21:0B
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Gfx_19_6460_Mode21_State0B_ResultSetup::
    INCBIN "data/bank_19/Gfx_19_6460_Mode21_State0B_ResultSetup.2bpp" ; $6460, 256 bytes
; I: copied to VRAM/WRAM by Mode21_State0B_ResultSetup (roms/jp_rev_a/assets/catalog_jp.csv). L3 pass 2026-10-26: read
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

; I: far pointer loaded by Mode0F_State0A_EraseAll (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 640 from
; the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C
; from the code: tiles loaded by Mode0F_State0A_EraseAll (04:4D3C)
Gfx_19_7560_Mode0F_State0A_EraseAll::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fc, $fe, $fc, $fc, $f8, $fd
    db $ff, $ff, $ff, $ff, $df, $9f, $df, $9f, $5c, $9f, $1c, $18, $d3, $18, $d8, $93
    db $ff, $ff, $ff, $ff, $ff, $e7, $f7, $e7, $f7, $e7, $f7, $66, $34, $66, $36, $64
    db $ff, $ff, $ff, $ff, $fd, $fc, $fd, $fc, $3d, $fc, $38, $18, $c9, $1c, $0d, $dc
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f3, $ff, $73, $61, $4c, $e1, $e0, $cd
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $fc, $ff, $fc, $fd, $fe
    db $ff, $ff, $ff, $ff, $ff, $f3, $fb, $f3, $7b, $f3, $7b, $33, $bb, $33, $9b, $33
    db $ff, $ff, $ff, $ff, $ff, $3f, $bf, $3f, $bf, $3f, $be, $3e, $be, $3e, $be, $3e
    db $ff, $ff, $ff, $ff, $fd, $fe, $fe, $fc, $fe, $fc, $3e, $1c, $de, $0c, $e7, $4c
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7c, $ff, $3c, $38, $bb, $10, $f6, $93
    db $ff, $ff, $ff, $ff, $ef, $e7, $ef, $e7, $ef, $e7, $43, $c3, $4b, $66, $2e, $66
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $9f, $ff, $8c, $1e, $6d, $0c, $c5, $6c
    db $ff, $ff, $ff, $ff, $fe, $ff, $fe, $fc, $fd, $f8, $3b, $39, $d9, $1f, $7f, $ff
    db $ff, $ff, $ff, $ff, $7f, $ff, $3f, $7f, $bf, $3f, $1f, $bf, $1f, $bf, $9f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $fd, $f8, $fd, $fd, $fc, $fe, $fc, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $d8, $90, $db, $93, $50, $9b, $1c, $18, $fb, $1c, $ff, $ff, $ff, $ff, $ff, $ff
    db $76, $64, $76, $e4, $34, $66, $f7, $66, $76, $e7, $ff, $ff, $ff, $ff, $ff, $ff
    db $1d, $1c, $dd, $fc, $0d, $dc, $3d, $1c, $dc, $3e, $ff, $ff, $ff, $ff, $ff, $ff
    db $e1, $c1, $ed, $cf, $c0, $ed, $f3, $61, $6d, $73, $ff, $ff, $ff, $ff, $ff, $ff
    db $f8, $fc, $fb, $f9, $fa, $f9, $fc, $f8, $fb, $fc, $ff, $ff, $ff, $ff, $ff, $ff
    db $1b, $33, $1b, $b3, $9b, $33, $3b, $33, $7b, $b3, $ff, $ff, $ff, $ff, $ff, $ff
    db $be, $3e, $be, $3e, $be, $3e, $be, $3e, $be, $3e, $fe, $fe, $ff, $fe, $ff, $ff
    db $c7, $6c, $c5, $6c, $dd, $0c, $3d, $1c, $fe, $7d, $ff, $7f, $ff, $7f, $ff, $ff
    db $f6, $93, $f6, $93, $d6, $93, $da, $90, $b5, $d8, $ff, $ff, $ff, $ff, $ff, $ff
    db $2e, $66, $2e, $66, $2e, $66, $af, $62, $62, $f3, $ff, $ff, $ff, $ff, $ff, $ff
    db $c4, $6e, $c7, $6f, $c6, $6d, $55, $0c, $ae, $1e, $ff, $ff, $ff, $ff, $ff, $ff
    db $1f, $3e, $3e, $9e, $5e, $9e, $bf, $1f, $7e, $3e, $fe, $fe, $ff, $ff, $ff, $ff
    db $5f, $3f, $bf, $7f, $ff, $7f, $ff, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

    ; padding
    ds $14, $ff

; I: far pointer loaded by Mode0F_State0A_EraseAll (ld a,BANK; ld hl,ADDR; call banked copy/far call); length 1536
; from the nearby ld bc. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: tiles loaded by Mode0F_State0A_EraseAll (04:4D4A)
Gfx_19_77E0_Mode0F_State0A_EraseAll::
    db $00, $00, $00, $00, $00, $00, $01, $01, $07, $07, $0f, $0f, $0f, $0f, $1f, $1f
    db $1f, $1f, $3e, $3f, $3f, $3e, $3f, $3e, $3d, $3e, $3f, $3c, $3f, $3c, $3b, $3c
    db $00, $00, $00, $00, $7f, $7f, $dd, $e3, $ff, $c1, $be, $c1, $ff, $80, $7f, $80
    db $ff, $00, $eb, $1c, $ff, $1c, $ff, $1c, $dd, $3e, $ff, $3e, $ff, $3e, $ff, $00
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $f0, $f8, $f8, $f8, $f8, $7c, $fc
    db $fc, $7c, $be, $7e, $fe, $3e, $fe, $3e, $de, $3e, $fe, $1e, $fe, $1e, $ee, $1e
    db $1e, $1e, $3f, $21, $73, $4c, $6d, $5e, $6e, $5f, $77, $4f, $3b, $27, $1d, $13
    db $0e, $09, $07, $04, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02
    db $03, $03, $07, $04, $8e, $89, $fd, $73, $fb, $07, $77, $8f, $ae, $df, $dd, $fe
    db $fb, $fc, $77, $f8, $ff, $70, $ff, $70, $ff, $70, $ff, $70, $ff, $70, $ff, $70
    db $c0, $c0, $e0, $20, $70, $90, $b0, $d0, $bf, $cf, $7f, $80, $bf, $7f, $7f, $ff
    db $ff, $ff, $ff, $e0, $ff, $e0, $ff, $e0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $e0
    db $01, $01, $03, $02, $07, $04, $0f, $09, $ff, $f3, $ff, $07, $bf, $cf, $ef, $de
    db $bf, $dc, $ff, $1c, $ef, $1e, $ff, $0f, $7f, $87, $ff, $83, $7f, $81, $ff, $00
    db $f0, $f0, $f8, $08, $58, $e8, $d8, $e8, $f8, $c8, $f0, $90, $e0, $20, $c0, $40
    db $80, $80, $80, $80, $c0, $40, $e0, $20, $f0, $90, $f8, $c8, $d8, $e8, $f8, $e8
    db $1b, $1c, $1f, $18, $0f, $08, $0f, $08, $07, $07, $01, $01, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $00, $bf, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $7f, $7f, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ec, $1c, $fc, $0c, $78, $88, $f8, $88, $f0, $f0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $03, $02, $01, $01, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $70, $ff, $70, $ff, $70, $ff, $70, $ff, $70, $ef, $33, $fc, $04, $f8, $f8
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $e0, $ff, $e0, $ff, $ff, $7f, $ff, $bf, $7f, $ff, $00, $ff, $ff, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $00, $ff, $01, $bf, $c3, $ff, $c7, $b7, $cf, $f5, $0e, $ff, $e0, $1f, $1f
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f8, $e8, $d8, $e8, $f8, $c8, $f0, $90, $e0, $20, $c0, $40, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $01, $01, $07, $07, $0f, $0c, $0f, $0c, $1f, $1c
    db $1f, $1c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c, $3f, $3c
    db $00, $00, $00, $00, $7f, $7f, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00
    db $ff, $3f, $ff, $3f, $ff, $3f, $ff, $00, $ff, $00, $ff, $00, $ff, $3f, $ff, $3f
    db $00, $00, $00, $00, $00, $00, $c0, $c0, $f0, $f0, $78, $f8, $b8, $78, $dc, $3c
    db $fc, $1c, $fe, $1e, $fe, $1e, $fe, $1e, $de, $3e, $ee, $1e, $fe, $0e, $fe, $0e
    db $00, $00, $03, $03, $07, $04, $06, $05, $07, $05, $07, $05, $07, $05, $07, $05
    db $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05, $07, $05
    db $00, $00, $e1, $e1, $ff, $1e, $df, $e0, $ff, $e0, $ef, $f0, $ff, $f0, $f7, $f8
    db $ff, $f8, $fb, $fc, $df, $fc, $fd, $de, $ef, $de, $fe, $cf, $f7, $cf, $ff, $c7
    db $00, $00, $f1, $f1, $ff, $0e, $5f, $e0, $ff, $e1, $fd, $e3, $ff, $e3, $ff, $e3
    db $ff, $e3, $ff, $e3, $ff, $e3, $ff, $e3, $ff, $e3, $ff, $e3, $ff, $e3, $ff, $e3
    db $00, $00, $ff, $ff, $ff, $00, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $c3, $ff, $81
    db $ff, $81, $ff, $81, $ff, $81, $ff, $81, $ff, $81, $ff, $81, $ff, $81, $ff, $81
    db $00, $00, $80, $80, $c0, $40, $e0, $20, $f0, $90, $b0, $d0, $f0, $d0, $f0, $d0
    db $f0, $d0, $f0, $d0, $f0, $d0, $f0, $d0, $f0, $d0, $f0, $d0, $f0, $d0, $f0, $d0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $1f, $1c, $1f, $1c, $0f, $0c, $0f, $0c, $07, $07, $01, $01, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $3f, $ff, $00, $ff, $00, $ff, $00, $ff, $ff, $ff, $ff, $7f, $7f, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fc, $0c, $fc, $0c, $e8, $18, $d8, $38, $f0, $f0, $c0, $c0, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $07, $05, $07, $05, $07, $05, $07, $05, $06, $05, $07, $04, $03, $03, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $fb, $c7, $ff, $c3, $fd, $c3, $ff, $c1, $be, $c1, $ff, $1c, $e3, $e3, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $e3, $ff, $e3, $fd, $e3, $ff, $e1, $df, $e0, $ff, $0e, $f1, $f1, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $ff, $81, $ff, $c3, $ff, $ff, $ff, $ff, $7e, $ff, $ff, $00, $ff, $ff, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $f0, $d0, $f0, $d0, $b0, $d0, $f0, $90, $e0, $20, $c0, $40, $80, $80, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
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

; I: target 4 of the {lo,hi,bank} table 07:53A6; extent not known: runs to the next pointer or asset. L3 pass
; 2026-10-26: read in BGB in 34 replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
Src_19_7E60_Tbl53A6_4::
    INCBIN "data/bank_19/Src_19_7E60_Tbl53A6_4.bin" ; $7E60, 416 bytes

; Pocket Camera Hello Kitty (Japan), bank $08. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $008", ROMX[$4000], BANK[$8]

; C: the same 32 bytes as the Japanese Sgb_MltReqPackets (0B:4000); named by the code of Sgb_Detect, Sram_Format
; (01:4974 08:6C7D 08:6C8C); read in the runs by Sgb_SendPacket; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz)
Sgb_MltReqPackets::
    db $89, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $89, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; I: leftover: 176 bytes (08:4020-40CF) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_08_4020::
    db $51, $10, $00, $10, $00, $10, $00, $10, $00, $80, $00, $00, $00, $00, $00, $00
    db $79, $5d, $08, $00, $0b, $8c, $d0, $f4, $60, $00, $00, $00, $00, $00, $00, $00
    db $79, $52, $08, $00, $0b, $a9, $e7, $9f, $01, $c0, $7e, $e8, $e8, $e8, $e8, $e0
    db $79, $47, $08, $00, $0b, $c4, $d0, $16, $a5, $cb, $c9, $05, $d0, $10, $a2, $28
    db $79, $3c, $08, $00, $0b, $f0, $12, $a5, $c9, $c9, $c8, $d0, $1c, $a5, $ca, $c9
    db $79, $31, $08, $00, $0b, $0c, $a5, $ca, $c9, $7e, $d0, $06, $a5, $cb, $c9, $7e
    db $79, $26, $08, $00, $0b, $39, $cd, $48, $0c, $d0, $34, $a5, $c9, $c9, $80, $d0
    db $79, $1b, $08, $00, $0b, $ea, $ea, $ea, $ea, $ea, $a9, $01, $cd, $4f, $0c, $d0
    db $79, $10, $08, $00, $0b, $4c, $20, $08, $ea, $ea, $ea, $ea, $ea, $60, $ea, $ea
    db $b9, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $b9, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: the same 134 bytes as the Japanese Sgb_AttrTrnPacket (0B:4030)
Sgb_AttrTrnPacket::
    db $a9

    ; padding
    ds $6c, $00

    db $40, $40, $40, $90, $90, $90, $e4, $e4, $e4, $59, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: the same 241 bytes as the Japanese Sgb_PalTrnData (0B:40B6)
Sgb_PalTrnData::
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $9c, $73, $5a, $6b, $18, $63, $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e
    db $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e, $f7, $5e
    db $ff, $7f, $5a, $6b, $b5, $5a, $31, $46, $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d
    db $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d, $ef, $3d
    db $ff, $7f, $f7, $62, $10, $46, $4a, $29, $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c
    db $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c, $e7, $1c
    db $ff, $7f, $b5, $5a, $6b, $35, $63, $10

    ; padding
    ds $18, $00

    db $99

    ; padding
    ds $2f, $00

    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff

; C: read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: sgb); kind T_UI from the evidence of
; tools/kitty_layout_kinds.py; the rest of Data_08_4000 after a leftover stretch
Gfx_08_4247_Sgb_VramTransferInline::
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $00
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $0c, $ff, $0c, $ff, $0f, $ff, $0f, $ff, $0e, $f3, $0c, $fd, $02, $fd, $06, $0c
    db $0c, $0c, $0c, $0f, $0f, $0f, $0f, $0e, $0e, $00, $00, $00, $00, $04, $04, $ff
    db $00, $3f, $d0, $df, $b0, $df, $30, $ff, $30, $ff, $30, $ff, $00, $ff, $00, $00
    db $00, $10, $10, $90, $90, $10, $10, $30, $30, $30, $30, $00, $00, $00, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $00
    db $00, $00, $00, $00, $00, $00, $00, $3e, $3e, $30, $30, $00, $00, $04, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $0e, $f3, $0c, $fd, $02, $fd, $06, $00
    db $00, $00, $00, $00, $00, $00, $00, $0e, $0e, $00, $00, $00, $00, $04, $04, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $30, $ff, $30, $ff, $00, $ff, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $30, $30, $30, $30, $00, $00, $00, $00, $ff
    db $0c, $ff, $0c, $ff, $0f, $ff, $0f, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $0c
    db $0c, $0c, $0c, $0f, $0f, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $00, $3f, $d0, $df, $b0, $df, $30, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00
    db $00, $10, $10, $90, $90, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00, $ff
    db $0c, $ff, $0c, $ff, $0f, $ff, $0f, $ff, $0f, $f2, $0f, $fd, $02, $ff, $04, $0c
    db $0c, $0c, $0c, $0f, $0f, $0f, $0f, $0f, $0e, $03, $00, $03, $00, $07, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $df, $fe, $fd, $03, $ff, $00, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $fe, $02, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3f, $f8, $ff, $db, $24, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3f, $3e, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $fb, $3f, $9f, $e0, $e3, $1c, $fd, $3e, $fe, $7f, $0c
    db $0c, $1c, $1c, $9f, $9f, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ff
    db $0c, $3f, $dc, $df, $ff, $2f, $ff, $f5, $0b, $fa, $05, $ff, $00, $8b, $7c, $0c
    db $0c, $1c, $1c, $df, $1f, $ff, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $fc, $bd, $62, $dd, $26, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $f0, $30, $e0, $00, $e4, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3f, $f2, $3f, $fd, $02, $ff, $04, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3f, $3e, $33, $30, $03, $00, $07, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $df, $fe, $fd, $03, $ff, $00, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $fe, $02, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3f, $f8, $ff, $db, $24, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3f, $3e, $ff, $00, $ff, $00, $ff, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $fb, $3f, $9f, $e0, $e3, $1c, $fd, $3e, $fe, $7f, $0c
    db $0c, $1c, $1c, $9f, $9f, $3f, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $38, $ff
    db $0c, $3f, $dc, $df, $ff, $2f, $ff, $f5, $0b, $fa, $05, $ff, $00, $8b, $7c, $0c
    db $0c, $1c, $1c, $df, $1f, $ff, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $3f, $d0, $df, $b0, $df, $30, $ff, $30, $ff, $f0, $bf, $60, $df, $20, $00
    db $00, $10, $10, $90, $90, $10, $10, $30, $30, $f0, $30, $e0, $00, $e0, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3e, $ff, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1e, $3f, $3c, $33, $30, $03, $00, $05, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $be, $f3, $bc, $7d, $82, $7d, $86, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $be, $3e, $b0, $30, $80, $00, $84, $04, $ff
    db $0c, $3f, $ec, $df, $af, $df, $2f, $df, $2e, $d3, $2c, $dd, $22, $dd, $26, $0c
    db $0c, $3c, $0c, $bf, $8f, $3f, $0f, $3e, $0e, $30, $00, $30, $00, $34, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $fb, $24, $ff, $22, $ff, $08, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $3c, $20, $3e, $00, $3e, $00, $ff
    db $08, $ff, $08, $ff, $10, $fe, $11, $ff, $11, $ff, $11, $ff, $11, $ff, $11, $0f
    db $00, $0f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00, $b6
    db $79, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $ff, $78, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7
    db $08, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $ff
    db $00, $ff, $00, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fc, $db
    db $7f, $fd, $db, $ff, $ff, $fb, $ff, $f8, $cc, $db, $fb, $fb, $fb, $b8, $dc, $ff
    db $00, $ff, $00, $ff, $c1, $ff, $c0, $ff, $83, $fc, $87, $fc, $97, $ff, $03, $ff
    db $fe, $a7, $fe, $fe, $ff, $f7, $df, $6f, $b7, $7f, $7f, $7f, $7f, $2e, $f7, $ff
    db $1c, $ff, $06, $ff, $22, $ff, $02, $ff, $02, $ff, $86, $ff, $a6, $ff, $02, $ff
    db $1c, $ff, $1c, $ff, $1f, $ff, $1f, $ef, $1e, $e3, $1c, $fd, $12, $fd, $16, $fc
    db $0c, $fc, $0c, $ff, $0f, $ff, $0f, $fe, $0e, $f0, $00, $f0, $00, $f4, $04, $ff
    db $08, $3f, $d8, $df, $b0, $de, $31, $ff, $31, $ff, $31, $ff, $11, $ff, $11, $0f
    db $00, $1f, $10, $9f, $80, $1f, $00, $3f, $20, $3f, $20, $1f, $00, $1f, $00, $b6
    db $79, $7e, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $ff, $78, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7
    db $08, $1f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $ff
    db $00, $ff, $00, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fc, $db
    db $7f, $fd, $db, $ff, $ff, $fb, $ff, $f8, $cc, $db, $fb, $fb, $fb, $b8, $dc, $ff
    db $00, $ff, $00, $ff, $c1, $ff, $c0, $ff, $83, $fc, $87, $fc, $97, $ff, $03, $ff
    db $fe, $a7, $fe, $fe, $ff, $f7, $df, $6f, $b7, $7f, $7f, $7f, $7f, $2e, $f7, $ff
    db $1c, $ff, $06, $ff, $22, $ff, $02, $ff, $02, $ff, $86, $ff, $a6, $ff, $02, $ff
    db $10, $ff, $10, $ff, $10, $ff, $10, $ef, $10, $ef, $10, $ff, $10, $ff, $10, $f0
    db $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $ff
    db $0c, $3f, $dc, $df, $b8, $d6, $3b, $f7, $3b, $fd, $3a, $ff, $00, $ff, $04, $0d
    db $0c, $1f, $18, $9f, $90, $1f, $10, $3f, $32, $3e, $30, $07, $00, $07, $04, $9f
    db $7c, $ff, $02, $ee, $71, $df, $3c, $be, $7f, $f3, $3c, $fd, $23, $ff, $00, $fc
    db $0c, $fe, $00, $ff, $00, $9f, $18, $ff, $3e, $f0, $30, $e1, $00, $ff, $00, $df
    db $2c, $1f, $ec, $ff, $af, $ff, $2e, $ff, $0c, $f7, $8d, $ff, $8c, $fe, $2d, $3c
    db $0c, $3c, $0c, $bf, $8f, $bf, $0e, $ff, $04, $f7, $00, $be, $00, $bf, $00, $ff
    db $0d, $3e, $cd, $df, $ac, $d7, $2c, $fd, $26, $ed, $b6, $dd, $a2, $f7, $a8, $3f
    db $08, $3f, $0c, $bf, $84, $9f, $04, $ff, $04, $ff, $00, $ef, $00, $ef, $00, $ee
    db $11, $e6, $19, $ff, $21, $ef, $31, $ed, $13, $fd, $23, $ff, $23, $fe, $21, $1f
    db $00, $1f, $00, $3f, $00, $3f, $00, $1f, $01, $3f, $01, $3f, $01, $3f, $01, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1d, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bd
    db $db, $ff, $ff, $fb, $ff, $fd, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fe, $ff
    db $00, $ff, $89, $ff, $e0, $ff, $e0, $ff, $f1, $ff, $f9, $ff, $ff, $ff, $ff, $fe
    db $37, $ff, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $f8, $78, $ff, $ff
    db $02, $ff, $22, $ff, $06, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $1f, $df, $3f, $ff, $1f, $7f, $9f, $7f, $8f, $ff, $8f, $ff, $0f, $77, $8f, $ff
    db $0f, $ff, $0f, $ff, $0f, $ff, $0f, $ff, $07, $ff, $07, $ff, $c7, $ff, $87, $ee
    db $f1, $e6, $f9, $ff, $e1, $ef, $f1, $ed, $f3, $fd, $e3, $ff, $e3, $fe, $e1, $ff
    db $e0, $ff, $e0, $ff, $c0, $ff, $c0, $ff, $e1, $ff, $c1, $ff, $c1, $ff, $c1, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1d, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bd
    db $db, $ff, $ff, $fb, $ff, $fd, $fb, $ff, $ff, $ff, $ff, $ff, $ff, $fd, $fe, $ff
    db $00, $ff, $89, $ff, $e0, $ff, $e0, $ff, $f1, $ff, $f9, $ff, $ff, $ff, $ff, $fe
    db $37, $ff, $ff, $f7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $f7, $f8, $78, $ff, $ff
    db $02, $ff, $22, $ff, $06, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $10, $df, $30, $ff, $10, $7f, $90, $7f, $88, $ff, $88, $ff, $08, $77, $88, $f0
    db $00, $f0, $00, $f0, $00, $f0, $00, $f8, $00, $f8, $00, $f8, $c0, $f8, $80, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $fd
    db $03, $af, $df, $ff, $cf, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $00, $ff, $8f, $ff, $cf, $ff, $cf, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $f7
    db $ec, $ff, $e4, $ff, $e0, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $e4, $ff, $e0, $ff, $e0, $ff, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $38, $ff, $38, $ff, $00, $d7, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $38, $ff, $38, $ff, $00, $ff, $83, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ef
    db $10, $ed, $33, $ed, $33, $ef, $10, $ff, $10, $fc, $13, $f6, $09, $ff, $08, $1f
    db $07, $3f, $01, $3f, $01, $1f, $03, $1f, $07, $1f, $00, $0f, $00, $0f, $01, $df
    db $3c, $ff, $fc, $fd, $fe, $df, $3f, $3f, $ff, $9f, $ff, $ff, $1f, $ff, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $8f, $ff
    db $7f, $ff, $7f, $7d, $fd, $fd, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $ff, $fc, $bd, $be, $bf, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $f8, $7f, $7f, $f8, $ff, $ff, $f3, $ff, $ef, $f0, $fb, $fc, $f9, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $f0, $ff
    db $8e, $ff, $8e, $ff, $0e, $f7, $0e, $6f, $9e, $ef, $1e, $df, $3e, $ff, $3e, $fe
    db $06, $fe, $06, $fe, $c6, $fe, $06, $fe, $06, $fe, $0e, $fe, $8e, $fe, $1e, $6f
    db $f0, $6d, $f3, $6d, $f3, $6f, $f0, $7f, $f0, $7c, $f3, $76, $f9, $7f, $f8, $7f
    db $67, $7f, $41, $7f, $41, $7f, $63, $7f, $67, $7f, $60, $7f, $70, $7f, $71, $df
    db $3c, $ff, $fc, $fd, $fe, $df, $3f, $3f, $ff, $9f, $ff, $ff, $1f, $ff, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $8f, $ff
    db $7f, $ff, $7f, $7d, $fd, $fd, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $ff, $fc, $bd, $be, $bf, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $f8, $7f, $7f, $f8, $ff, $ff, $f3, $ff, $ef, $f0, $fb, $fc, $f9, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $f0, $ff
    db $88, $ff, $88, $ff, $08, $f7, $08, $6f, $98, $ef, $10, $df, $30, $ff, $20, $f8
    db $00, $f8, $00, $f8, $c0, $f8, $00, $f8, $00, $f0, $00, $f0, $80, $e0, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $fb, $0c, $fd, $82, $fd, $b6, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $0e, $78, $00, $f8, $00, $fc, $00, $ff
    db $0c, $3f, $dc, $de, $bf, $df, $3e, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9e, $1f, $1e, $3f, $3e, $31, $30, $01, $00, $05, $04, $ff
    db $0c, $3f, $dc, $5f, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $1f, $9f, $1f, $be, $3e, $b0, $30, $80, $00, $84, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $ff, $2f, $df, $2e, $f3, $0c, $fd, $52, $fd, $07, $0c
    db $0c, $1c, $1c, $9f, $9f, $3f, $0f, $3e, $0e, $30, $00, $70, $00, $65, $04, $fe
    db $0d, $ff, $0e, $ff, $0f, $ff, $0f, $ff, $0e, $f3, $0c, $fd, $02, $fd, $06, $0f
    db $08, $0f, $0c, $0f, $0e, $0f, $0f, $0e, $0e, $00, $00, $00, $00, $04, $04, $1f
    db $ff, $fb, $07, $fe, $01, $9f, $e0, $f0, $3f, $f3, $3f, $fd, $02, $fd, $06, $ff
    db $07, $ff, $00, $ff, $00, $ff, $00, $3f, $00, $33, $30, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $7f, $ff, $fe, $01, $ff, $00, $c0, $ff, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $fe, $ff, $ef, $10, $ff, $00, $08, $ff, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $04, $04, $f7
    db $f8, $df, $e0, $fe, $01, $fb, $07, $cf, $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $e0, $ff, $00, $ff, $00, $ff, $01, $ff, $07, $ff, $3f, $ff, $ff, $ff, $ff, $ff
    db $3e, $ff, $7e, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $fe
    db $1e, $fe, $3e, $fe, $7e, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $7e
    db $fd, $7f, $fe, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $78, $7f, $7c, $7f, $7e, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f, $1f
    db $ff, $fb, $07, $fe, $01, $9f, $e0, $f0, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $07, $ff, $00, $ff, $00, $ff, $00, $ff, $c0, $ff, $fc, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $fe, $01, $ff, $00, $c0, $ff, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $fe, $ff, $ef, $10, $ff, $00, $08, $ff, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $00, $04, $04, $f7
    db $f8, $df, $e0, $fe, $01, $fb, $07, $cf, $3e, $f3, $fc, $fd, $02, $fd, $06, $ff
    db $e0, $ff, $00, $ff, $00, $ff, $01, $fe, $06, $f0, $30, $00, $00, $04, $04, $ff
    db $20, $ff, $50, $df, $b0, $df, $30, $ff, $30, $ff, $30, $ff, $00, $ff, $00, $e0
    db $00, $d0, $10, $90, $10, $10, $10, $30, $30, $30, $30, $00, $00, $00, $00, $ff
    db $a0, $ff, $b0, $d7, $bb, $ff, $9b, $ff, $9a, $bf, $da, $ff, $4b, $fd, $02, $ec
    db $00, $fc, $10, $ff, $11, $ff, $11, $fe, $10, $fe, $00, $7f, $00, $3d, $00, $ff
    db $0c, $3f, $dc, $de, $bf, $df, $3f, $fb, $76, $7f, $80, $fd, $06, $fd, $06, $0d
    db $0c, $1d, $1c, $9f, $9e, $1f, $1e, $7e, $12, $fc, $00, $fc, $00, $fc, $04, $ff
    db $0c, $ff, $44, $fc, $03, $ff, $18, $ff, $18, $ff, $00, $77, $be, $dd, $26, $8c
    db $0c, $fc, $00, $ff, $00, $ff, $18, $ff, $08, $ff, $00, $ff, $00, $65, $04, $df
    db $a8, $ff, $18, $9f, $78, $dd, $3f, $ff, $be, $f3, $bc, $ff, $04, $ff, $44, $ef
    db $08, $df, $10, $df, $18, $9f, $1c, $be, $3e, $b3, $30, $87, $00, $c7, $04, $ff
    db $0c, $ff, $0c, $ff, $0f, $ff, $0f, $fe, $0f, $f1, $0e, $fe, $00, $f8, $04, $0c
    db $0c, $0c, $0c, $0f, $0f, $0f, $0f, $0e, $0f, $00, $03, $00, $03, $00, $07, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $23, $de, $02, $01, $00, $00, $00, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $02, $fe, $00, $ff, $00, $ff, $00, $ff, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $fe, $3f, $07, $f8, $24, $00, $00, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3f, $00, $ff, $00, $ff, $00, $ff, $ff
    db $0c, $3f, $dc, $df, $bf, $c4, $3b, $60, $80, $1c, $00, $02, $3c, $39, $7e, $0c
    db $0c, $1c, $1c, $9f, $9f, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $38, $ff, $ff
    db $ff, $ff, $ff, $3f, $ff, $d3, $2f, $0a, $01, $05, $00, $00, $00, $74, $08, $ff
    db $ff, $ff, $ff, $3f, $ff, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff
    db $fe, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $fe, $3f, $fe, $5f, $3e, $3f, $1e, $fe
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $3e, $fe, $1e, $fe, $1e, $fe, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7e, $ff, $7d, $fe, $7e, $fc, $78, $fc, $7f
    db $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7f, $7c, $7f, $7c, $7f, $78, $7f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $23, $df, $02, $01, $00, $00, $00, $00, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $fe, $3f, $07, $f8, $24, $00, $00, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3f, $00, $ff, $00, $ff, $00, $ff, $ff
    db $0c, $3f, $dc, $df, $bf, $c4, $3b, $60, $80, $1c, $00, $02, $3c, $39, $7e, $0c
    db $0c, $1c, $1c, $9f, $9f, $00, $3f, $00, $ff, $00, $ff, $00, $ff, $38, $ff, $ff
    db $0c, $3f, $dc, $1f, $ff, $d3, $2f, $0a, $01, $05, $00, $00, $00, $74, $08, $0c
    db $0c, $1c, $1c, $1f, $df, $03, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $ff
    db $00, $3f, $d0, $df, $b0, $df, $30, $ff, $30, $3f, $f0, $5f, $20, $3f, $00, $00
    db $00, $10, $10, $90, $90, $10, $10, $30, $30, $30, $f0, $00, $e0, $00, $e0, $ff
    db $e2, $ff, $e2, $ff, $00, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $c2, $ff, $60, $ff, $00, $ff, $09, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $67, $ff, $67, $ff, $0f, $df, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $67, $ff, $27, $ff, $07, $ff, $8f, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $9f, $ef, $df, $ff, $cf, $ff, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $9e, $ff, $8f, $ff, $cf, $ff, $cf, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $3c, $db, $3c, $ff, $81, $db, $e7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $3c, $ff, $18, $ff, $81, $ff, $c3, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $f0
    db $08, $f0, $08, $e0, $10, $e1, $10, $e0, $11, $e0, $11, $e0, $11, $e0, $11, $00
    db $0f, $00, $0f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $00, $1f, $49
    db $30, $f9, $7e, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $ff, $78, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $08
    db $00, $e0, $1f, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fd, $fe, $00
    db $ff, $00, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fc, $ff, $24
    db $5b, $02, $d9, $c1, $ff, $c4, $fb, $84, $c8, $a3, $db, $93, $fb, $44, $98, $00
    db $ff, $00, $ff, $c1, $ff, $c0, $ff, $83, $ff, $84, $ff, $94, $ff, $03, $ff, $1c
    db $fe, $5e, $a6, $23, $fe, $0a, $d7, $92, $27, $06, $7f, $26, $7f, $d3, $26, $1c
    db $ff, $06, $ff, $22, $ff, $02, $ff, $02, $ff, $86, $ff, $a6, $ff, $02, $ff, $0f
    db $1e, $0f, $1e, $0f, $1e, $0f, $1e, $1f, $0e, $1f, $0e, $0f, $1e, $0f, $1e, $0e
    db $fe, $0e, $fe, $0e, $fe, $0e, $fe, $0e, $fe, $0e, $fe, $0e, $fe, $0e, $fe, $70
    db $f8, $70, $f8, $60, $f0, $61, $f0, $60, $f1, $60, $f1, $60, $f1, $60, $f1, $70
    db $7f, $70, $7f, $60, $7f, $60, $7f, $60, $7f, $60, $7f, $60, $7f, $60, $7f, $49
    db $30, $f9, $7e, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00
    db $ff, $78, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $08
    db $00, $e0, $1f, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fd, $fe, $00
    db $ff, $00, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fc, $ff, $fc, $ff, $24
    db $5b, $02, $d9, $c1, $ff, $c4, $fb, $87, $cb, $a7, $dc, $97, $fc, $47, $9b, $00
    db $ff, $00, $ff, $c1, $ff, $c0, $ff, $83, $fc, $87, $f8, $97, $f8, $03, $fc, $1c
    db $fe, $5e, $a6, $23, $fe, $0a, $d7, $92, $27, $86, $ff, $a6, $ff, $d3, $26, $1c
    db $ff, $06, $ff, $22, $ff, $02, $ff, $02, $ff, $86, $7f, $a6, $7f, $02, $ff, $0f
    db $10, $0f, $10, $0f, $10, $0f, $10, $1f, $00, $1f, $00, $0f, $10, $0f, $10, $00
    db $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f0, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $99
    db $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f1
    db $00, $f9, $00, $c0, $21, $d0, $21, $f3, $01, $c3, $21, $c1, $23, $c0, $21, $00
    db $1f, $00, $1f, $00, $3f, $00, $3f, $01, $1f, $01, $3f, $01, $3f, $01, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1d, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $42
    db $99, $89, $ff, $e4, $fb, $e2, $f9, $f1, $ff, $f9, $ff, $ff, $ff, $fd, $fe, $00
    db $ff, $89, $ff, $e0, $ff, $e0, $ff, $f1, $ff, $f9, $ff, $ff, $ff, $ff, $ff, $03
    db $36, $22, $ff, $0e, $f7, $7f, $ff, $ff, $ff, $ff, $ff, $f7, $f8, $78, $ff, $02
    db $ff, $22, $ff, $06, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f
    db $1f, $2f, $1f, $0f, $1f, $8f, $1f, $87, $0f, $07, $8f, $c7, $0f, $0f, $87, $0f
    db $ff, $0f, $ff, $0f, $ff, $0f, $ff, $07, $ff, $07, $ff, $c7, $ff, $87, $ff, $f1
    db $e0, $f9, $e0, $c0, $e1, $d0, $e1, $f3, $e1, $c3, $e1, $c1, $e3, $c0, $e1, $e0
    db $ff, $e0, $ff, $c0, $ff, $c0, $ff, $e1, $ff, $c1, $ff, $c1, $ff, $c1, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $1d, $fe, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $7f, $ff, $fe
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $42
    db $99, $89, $ff, $e4, $fb, $e2, $f9, $f1, $ff, $f9, $ff, $ff, $ff, $fd, $fe, $00
    db $ff, $89, $ff, $e0, $ff, $e0, $ff, $f1, $ff, $f9, $ff, $ff, $ff, $ff, $ff, $03
    db $36, $22, $ff, $0e, $f7, $7f, $ff, $ff, $ff, $ff, $ff, $f7, $f8, $78, $ff, $02
    db $ff, $22, $ff, $06, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f
    db $10, $2f, $10, $0f, $10, $8f, $10, $87, $08, $07, $88, $c7, $08, $0f, $80, $00
    db $f0, $00, $f0, $00, $f0, $00, $f0, $00, $f8, $00, $f8, $c0, $f8, $80, $f8, $ff
    db $8c, $3f, $d0, $df, $b3, $df, $20, $ff, $00, $ff, $30, $f7, $88, $7f, $89, $8c
    db $0c, $9c, $10, $9f, $93, $3f, $00, $3f, $00, $3e, $30, $8e, $00, $8f, $00, $ff
    db $4c, $7f, $9c, $af, $df, $ff, $03, $fe, $07, $f3, $4e, $ff, $0a, $f5, $0e, $6c
    db $0c, $7c, $0c, $ff, $8f, $ff, $03, $ff, $02, $73, $00, $3b, $00, $3f, $04, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $fb, $b6, $ff, $32, $ed, $12, $ff, $00, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $be, $22, $be, $20, $9e, $00, $9e, $00, $ff
    db $0c, $3f, $dc, $df, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $46, $0c
    db $0c, $1c, $1c, $9f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $44, $04, $f7
    db $00, $d3, $21, $d3, $21, $f3, $00, $e7, $10, $e3, $10, $f9, $00, $f1, $08, $07
    db $1f, $01, $3f, $01, $3f, $03, $1f, $07, $1f, $00, $1f, $00, $0f, $01, $0f, $df
    db $3c, $ff, $fc, $fd, $fe, $df, $3f, $7f, $bf, $1f, $ff, $ff, $1f, $8f, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $8f, $ff, $ff
    db $7f, $ff, $7f, $7d, $fd, $fd, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $ff, $fc, $bd, $be, $bf, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $f8, $7f, $7f, $f8, $fe, $ff, $f2, $ff, $ee, $f0, $fb, $fc, $f6, $f8, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $f0, $ff, $07
    db $8c, $07, $8c, $c7, $0f, $0f, $07, $97, $0e, $13, $0c, $ad, $12, $1d, $26, $04
    db $fc, $04, $fc, $c7, $ff, $07, $ff, $06, $fe, $00, $f0, $80, $f0, $04, $e4, $f7
    db $00, $13, $e1, $d3, $a1, $d3, $20, $e7, $30, $e3, $30, $f9, $00, $f1, $08, $07
    db $1f, $01, $3f, $81, $bf, $03, $1f, $27, $3f, $20, $3f, $00, $0f, $01, $0f, $df
    db $3c, $ff, $fc, $fd, $fe, $df, $3f, $7f, $bf, $1f, $ff, $ff, $1f, $8f, $3f, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $bf, $ff, $7f, $ff, $ff, $ff, $8f, $ff, $ff
    db $7f, $ff, $7f, $7d, $fd, $fd, $fd, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $fc, $ff, $fc, $bd, $be, $bf, $bf, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $7f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $7f, $f8, $7f, $7f, $f8, $fe, $ff, $f2, $ff, $ee, $f0, $fb, $fc, $f6, $f8, $ff
    db $ff, $ff, $ff, $ff, $ff, $fe, $ff, $fe, $ff, $fe, $ff, $ff, $ff, $f0, $ff, $07
    db $88, $07, $88, $c7, $08, $0f, $00, $97, $08, $1f, $00, $af, $10, $1f, $20, $00
    db $f8, $00, $f8, $c0, $f8, $00, $f8, $00, $f8, $00, $f0, $80, $f0, $00, $e0, $ff
    db $78, $bf, $70, $7f, $82, $ff, $c7, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $70, $ff, $30, $ff, $00, $ff, $86, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $ff
    db $c4, $ff, $c0, $ef, $11, $3b, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $c4, $ff, $00, $ff, $00, $ff, $11, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $d7
    db $6c, $ff, $08, $9f, $f0, $ff, $f0, $fd, $f2, $ff, $f0, $ff, $fd, $ff, $00, $ff
    db $00, $ff, $08, $ff, $90, $ff, $e0, $ff, $e0, $ff, $f0, $ff, $f8, $00, $00, $ff
    db $3f, $ff, $7f, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $ff
    db $1f, $ff, $3f, $ff, $ff, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $ff, $00, $00, $f9
    db $0c, $fc, $0e, $fe, $0f, $ff, $0f, $ff, $0e, $f3, $0c, $fd, $02, $fd, $06, $08
    db $0f, $0c, $0f, $0e, $0f, $0f, $0f, $0e, $0e, $00, $00, $00, $00, $04, $04, $e7
    db $1f, $04, $03, $01, $00, $60, $80, $cf, $30, $f0, $3f, $fd, $02, $fd, $06, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $3f, $30, $33, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $80, $7f, $01, $00, $00, $00, $3f, $c0, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $01, $fe, $10, $00, $00, $00, $f7, $08, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $04, $04, $e8
    db $f0, $20, $c0, $01, $00, $05, $03, $37, $0e, $33, $fc, $fd, $02, $fd, $06, $e0
    db $ff, $00, $ff, $00, $ff, $01, $ff, $06, $fe, $30, $f0, $00, $00, $04, $04, $1f
    db $2c, $3f, $5c, $5f, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $0c
    db $ec, $1c, $dc, $1f, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $f9
    db $0c, $3c, $de, $de, $bf, $df, $3f, $ff, $3e, $f3, $3c, $fd, $02, $fd, $06, $08
    db $0f, $1c, $1f, $9e, $9f, $1f, $1f, $3e, $3e, $30, $30, $00, $00, $04, $04, $e7
    db $1f, $04, $03, $01, $00, $60, $80, $cf, $30, $f0, $3f, $fd, $02, $fd, $06, $07
    db $ff, $00, $ff, $00, $ff, $00, $ff, $00, $3f, $30, $33, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $80, $7f, $01, $00, $00, $00, $3f, $c0, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $04, $04, $ff
    db $ff, $ff, $ff, $01, $fe, $10, $00, $00, $00, $f7, $08, $fd, $02, $fd, $06, $ff
    db $ff, $ff, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $00, $04, $04, $e8
    db $f0, $20, $c0, $01, $00, $05, $03, $37, $0e, $33, $fc, $fd, $02, $fd, $06, $e0
    db $ff, $00, $ff, $00, $ff, $01, $ff, $06, $fe, $30, $f0, $00, $00, $04, $04, $1f
    db $20, $3f, $50, $5f, $b0, $df, $30, $ff, $30, $ff, $30, $ff, $00, $ff, $00, $00
    db $e0, $10, $d0, $10, $90, $10, $10, $30, $30, $30, $30, $00, $00, $00, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff

    ; padding
    ds $11, $00

    db $ff, $ff, $ff, $bd, $ff, $db, $ff, $e7, $ff, $e7, $ff, $db, $ff, $bd, $ff, $ff
    db $ff, $ff, $bd, $bd, $db, $db, $e7, $e7, $e7, $e7, $db, $db, $bd, $bd, $ff, $ff
    db $ff, $ff, $ff, $bd, $ff, $db, $ff, $e7, $ff, $e7, $ff, $db, $ff, $bd, $ff, $ff
    db $ff, $ff, $bd, $bd, $db, $db, $e7, $e7, $e7, $e7, $db, $db, $bd, $bd, $ff, $ff
    db $ff, $ff, $ff, $bd, $ff, $db, $ff, $e7, $ff, $e7, $ff, $db, $ff, $bd, $ff, $ff
    db $ff, $ff, $bd, $bd, $db, $db, $e7, $e7, $e7, $e7, $db, $db, $bd, $bd, $ff, $ff

    ; padding
    ds $a00, $00

    db $a1, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C: read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: sgb); kind MAP from the evidence of
; tools/kitty_layout_kinds.py; the rest of Data_08_4000 after a leftover stretch
Map_08_6226_Sgb_VramTransferInline::
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $0c, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10
    db $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10
    db $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10
    db $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0a, $10, $0d, $10
    db $10, $10, $11, $10, $12, $10, $13, $10, $14, $10, $15, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $1c, $10, $1d, $10, $1e, $10, $1f, $10, $4c, $10, $4d, $10
    db $4e, $10, $4f, $10, $7c, $10, $7d, $10, $7e, $10, $7f, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $16, $14, $17, $14, $18, $14, $19, $14, $1a, $14, $1b, $14
    db $20, $10, $21, $10, $22, $10, $23, $10, $24, $10, $25, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $2c, $10, $2d, $10, $2e, $10, $2f, $10, $5c, $10, $5d, $10
    db $5e, $10, $5f, $10, $8c, $10, $8d, $10, $8e, $10, $8f, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $26, $14, $27, $14, $28, $14, $29, $14, $2a, $14, $2b, $14
    db $30, $10, $31, $10, $32, $10, $33, $10, $34, $10, $35, $10, $03, $10, $03, $10
    db $03, $10, $03, $10, $3c, $10, $3d, $10, $3e, $10, $3f, $10, $6c, $10, $6d, $10
    db $6e, $10, $6f, $10, $9c, $10, $9d, $10, $9e, $10, $9f, $10, $03, $10, $03, $10
    db $03, $10, $03, $10, $36, $14, $37, $14, $38, $14, $39, $14, $3a, $14, $3b, $14
    db $40, $10, $41, $10, $42, $10, $43, $10, $44, $10, $45, $10

    ; padding
    ds $28, $00

    db $46, $14, $47, $14, $48, $14, $49, $14, $4a, $14, $4b, $14, $50, $10, $51, $10
    db $52, $10, $53, $10, $54, $10, $55, $10

    ; padding
    ds $28, $00

    db $56, $14, $57, $14, $58, $14, $59, $14, $5a, $14, $5b, $14, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $08, $10, $02, $10
    db $02, $10, $02, $10, $07, $10, $04, $10

    ; padding
    ds $28, $00

    db $06, $10, $07, $10, $02, $10, $02, $10, $02, $10, $09, $10, $60, $14, $61, $14
    db $62, $14, $63, $14, $64, $14, $65, $14

    ; padding
    ds $28, $00

    db $66, $10, $67, $10, $68, $10, $69, $10, $6a, $10, $6b, $10, $70, $14, $71, $14
    db $72, $14, $73, $14, $74, $14, $75, $14

    ; padding
    ds $28, $00

    db $76, $10, $77, $10, $78, $10, $79, $10, $7a, $10, $7b, $10, $80, $14, $81, $14
    db $82, $14, $83, $14, $84, $14, $85, $14, $05, $10, $05, $10, $05, $10, $05, $10
    db $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10
    db $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10, $05, $10
    db $86, $10, $87, $10, $88, $10, $89, $10, $8a, $10, $8b, $10, $90, $14, $91, $14
    db $92, $14, $93, $14, $94, $14, $95, $14, $02, $10, $02, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10
    db $96, $10, $97, $10, $98, $10, $99, $10, $9a, $10, $9b, $10, $a0, $14, $a1, $14
    db $a2, $14, $a3, $14, $a4, $14, $a5, $14, $02, $10, $02, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10
    db $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10, $02, $10
    db $a6, $10, $a7, $10, $a8, $10, $a9, $10, $aa, $10, $ab, $10, $0e, $10, $0b, $10
    db $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10
    db $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10
    db $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10
    db $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0b, $10, $0f, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10
    db $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10, $ac, $10

; C: read in BGB by a read watchpoint (trace/bgb_reads_kitty.csv: sgb); kind PALT from the evidence of
; tools/kitty_layout_kinds.py; the rest of Data_08_4000 after a leftover stretch
Pal_08_6A26_Sgb_VramTransferInline_Palettes::
    db $e5, $62, $1f, $7f, $7f, $7f, $5f, $29, $41, $7c, $de, $79, $de, $7a, $3e, $7b
    db $7f, $0f, $7f, $3b, $df, $4f, $1d, $13, $7d, $37, $4a, $29, $f7, $5e, $ff, $7f
    db $e5, $5e, $1f, $7f, $7f, $7f, $5f, $29, $5f, $29, $b2, $7e, $57, $7f, $ba, $7f
    db $f2, $4b, $f7, $63, $fa, $6f, $1d, $13, $7d, $37, $4a, $29, $f7, $5e, $ff, $7f
    db $06, $57, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f
    db $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f, $ff, $7f

; C: same instructions as the Japanese Sgb_Delay (00:1CDE) over the whole routine (9 instructions, to the first ret /
; jp), only the addresses differ; code compared
Sgb_Delay::
    ld de, $1b58                                  ; $6A86

jr_008_6a89:
    nop                                           ; $6A89
    nop                                           ; $6A8A
    nop                                           ; $6A8B
    dec de                                        ; $6A8C
    ld a, d                                       ; $6A8D
    or e                                          ; $6A8E
    jr nz, jr_008_6a89                            ; $6A8F

    ret                                           ; $6A91


; C: inline {address, bank}: Sgb_SendPacket of that packet
Sgb_SendPacketInline::
    pop hl                                        ; $6A92
    ld a, [hl+]                                   ; $6A93
    ld c, a                                       ; $6A94
    ld a, [hl+]                                   ; $6A95
    ld b, a                                       ; $6A96
    ld a, [hl+]                                   ; $6A97
    push hl                                       ; $6A98
    ld l, c                                       ; $6A99
    ld h, b                                       ; $6A9A

; C: the Japanese Sgb_SendPacket (00:1C93), 41 instructions against 41, with 2 small edits (variables moved between
; HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Sgb_SendPacket::
    ld b, a                                       ; $6A9B
    ldh a, [hRomBankShadow]                       ; $6A9C
    push af                                       ; $6A9E
    ld a, b                                       ; $6A9F
    ldh [hRomBankShadow], a                       ; $6AA0
    ld [$2100], a                                 ; $6AA2
    ld a, [hl]                                    ; $6AA5
    and $07                                       ; $6AA6
    jr z, jr_008_6add                             ; $6AA8

    ld b, a                                       ; $6AAA
    ld c, $00                                     ; $6AAB

jr_008_6aad:
    push bc                                       ; $6AAD
    ld a, $00                                     ; $6AAE
    ldh [c], a                                    ; $6AB0
    ld a, $30                                     ; $6AB1
    ldh [c], a                                    ; $6AB3
    ld b, $10                                     ; $6AB4

jr_008_6ab6:
    ld e, $08                                     ; $6AB6
    ld a, [hl+]                                   ; $6AB8
    ld d, a                                       ; $6AB9

jr_008_6aba:
    bit 0, d                                      ; $6ABA
    ld a, $10                                     ; $6ABC
    jr nz, jr_008_6ac2                            ; $6ABE

    ld a, $20                                     ; $6AC0

jr_008_6ac2:
    ldh [c], a                                    ; $6AC2
    ld a, $30                                     ; $6AC3
    ldh [c], a                                    ; $6AC5
    rr d                                          ; $6AC6
    dec e                                         ; $6AC8
    jr nz, jr_008_6aba                            ; $6AC9

    dec b                                         ; $6ACB
    jr nz, jr_008_6ab6                            ; $6ACC

    ld a, $20                                     ; $6ACE
    ldh [c], a                                    ; $6AD0
    ld a, $30                                     ; $6AD1
    ldh [c], a                                    ; $6AD3
    pop bc                                        ; $6AD4
    dec b                                         ; $6AD5
    jr z, jr_008_6add                             ; $6AD6

    call Sgb_Delay                                ; $6AD8
    jr jr_008_6aad                                ; $6ADB

jr_008_6add:
    pop af                                        ; $6ADD
    ldh [hRomBankShadow], a                       ; $6ADE
    ld [$2100], a                                 ; $6AE0
    ret                                           ; $6AE3


; C: SGB VRAM transfer: inline {address, bank}, BGP = $E4, $1000 bytes into $8800, the map $9800 numbered from $80,
; then the packet; code read (runs only on a Super Game Boy, not in the core)
Sgb_VramTransferInline::
    pop hl                                        ; $6AE4
    ld a, [hl+]                                   ; $6AE5
    ld c, a                                       ; $6AE6
    ld a, [hl+]                                   ; $6AE7
    ld b, a                                       ; $6AE8
    ld a, [hl+]                                   ; $6AE9
    push hl                                       ; $6AEA
    ld l, c                                       ; $6AEB
    ld h, b                                       ; $6AEC
    ld b, a                                       ; $6AED
    ldh a, [hRomBankShadow]                       ; $6AEE
    push af                                       ; $6AF0
    ld a, b                                       ; $6AF1
    ldh [hRomBankShadow], a                       ; $6AF2
    ld [$2100], a                                 ; $6AF4
    push af                                       ; $6AF7
    push hl                                       ; $6AF8
    ld a, DMGPAL_0123_NORMAL                      ; $6AF9
    ldh [rBGP], a                                 ; $6AFB
    ld bc, $0010                                  ; $6AFD
    add hl, bc                                    ; $6B00
    ld de, $8800                                  ; $6B01
    ld bc, $1000                                  ; $6B04
    call Mem_Copy                                 ; $6B07
    ld hl, $9800                                  ; $6B0A
    ld de, $000c                                  ; $6B0D
    ld a, $80                                     ; $6B10
    ld c, $0d                                     ; $6B12

jr_008_6b14:
    ld b, $14                                     ; $6B14

jr_008_6b16:
    ld [hl+], a                                   ; $6B16
    inc a                                         ; $6B17
    dec b                                         ; $6B18
    jr nz, jr_008_6b16                            ; $6B19

    add hl, de                                    ; $6B1B
    dec c                                         ; $6B1C
    jr nz, jr_008_6b14                            ; $6B1D

    ld a, LCDCF_ON | LCDCF_BGON                   ; $6B1F
    ldh [rLCDC], a                                ; $6B21
    ld bc, $0005                                  ; $6B23
    call Delay_Frames_Busy                        ; $6B26
    pop hl                                        ; $6B29
    pop af                                        ; $6B2A
    call Sgb_SendPacket                           ; $6B2B
    ld bc, $0006                                  ; $6B2E
    call Delay_Frames_Busy                        ; $6B31
    ld a, [wBgpShadow]                            ; $6B34
    ldh [rBGP], a                                 ; $6B37
    ld a, [wLcdcShadow]                           ; $6B39
    ldh [rLCDC], a                                ; $6B3C
    pop af                                        ; $6B3E
    ldh [hRomBankShadow], a                       ; $6B3F
    ld [$2100], a                                 ; $6B41
    ret                                           ; $6B44


; C: when $D8E3 (SGB found): the DATA_SND packets 08:4030, 08:4040, 08:4050 ... with delays (the standard SGB start-up
; packets)
Sgb_InitDataSnd::
    ld a, [wBoot_D8E3]                            ; $6B45
    and a                                         ; $6B48
    jp z, Jump_008_6bee                           ; $6B49

    call Delay_Inline                             ; $6B4C

    dw $0078

    ld b, BANK(Sgb_FreezeScreen)                  ; $6B51
    ld hl, Sgb_FreezeScreen                       ; $6B53
    call Far_Call                                 ; $6B56
    call Sgb_SendPacketInline                     ; $6B59

    db $30, $40, $08

    call Delay_Inline                             ; $6B5F

    dw $0004

    call Sgb_SendPacketInline                     ; $6B64

    db $40, $40, $08

    call Delay_Inline                             ; $6B6A

    dw $0004

    call Sgb_SendPacketInline                     ; $6B6F

    db $50, $40, $08

    call Delay_Inline                             ; $6B75

    dw $0004

    call Sgb_SendPacketInline                     ; $6B7A

    db $60, $40, $08

    call Delay_Inline                             ; $6B80

    dw $0004

    call Sgb_SendPacketInline                     ; $6B85

    db $70, $40, $08

    call Delay_Inline                             ; $6B8B

    dw $0004

    call Sgb_SendPacketInline                     ; $6B90

    db $80, $40, $08

    call Delay_Inline                             ; $6B96

    dw $0004

    call Sgb_SendPacketInline                     ; $6B9B

    db $90, $40, $08

    call Delay_Inline                             ; $6BA1

    dw $0004

    call Sgb_SendPacketInline                     ; $6BA6

    db $a0, $40, $08

    call Delay_Inline                             ; $6BAC

    dw $0004

    call Sgb_VramTransferInline                   ; $6BB1

    db $46, $41, $08

    call Delay_Inline                             ; $6BB7

    dw $0004

    call Sgb_VramTransferInline                   ; $6BBC

    dwb Sgb_AttrTrnPacket

    call Delay_Inline                             ; $6BC2

    dw $0004

    call Sgb_SendPacketInline                     ; $6BC7

    dwb Leftover_08_4020

    call Delay_Inline                             ; $6BCD

    dw $0004

    call Sgb_VramTransferInline                   ; $6BD2

    db $f6, $41, $08

    call Delay_Inline                             ; $6BD8

    dw $0004

    call Sgb_VramTransferInline                   ; $6BDD

    db $06, $52, $08

    call Delay_Inline                             ; $6BE3

    dw $0004

    call Sgb_VramTransferInline                   ; $6BE8

    db $16, $62, $08

Jump_008_6bee:
    jp Far_Return                                 ; $6BEE


; C: when on an SGB and not frozen: MASK_EN 1 (08:40B0), $D8E4 = $FF
Sgb_FreezeScreen::
    ld a, [wBoot_D8E3]                            ; $6BF1
    and a                                         ; $6BF4
    jr z, jr_008_6c10                             ; $6BF5

    ld a, [wBoot_D8E4]                            ; $6BF7
    and a                                         ; $6BFA
    jr nz, jr_008_6c10                            ; $6BFB

    ld a, BANK(Leftover_08_4020)                  ; $6BFD
    ld hl, Leftover_08_4020 + $90                 ; $6BFF
    call Sgb_SendPacket                           ; $6C02
    ld bc, $0004                                  ; $6C05
    call Delay_Frames_Busy                        ; $6C08
    ld a, $ff                                     ; $6C0B
    ld [wBoot_D8E4], a                            ; $6C0D

jr_008_6c10:
    jp Far_Return                                 ; $6C10


; C: when frozen: MASK_EN 0 (08:40C0), $D8E4 = 0
Sgb_UnfreezeScreen::
    ld a, [wBoot_D8E3]                            ; $6C13
    and a                                         ; $6C16
    jr z, jr_008_6c37                             ; $6C17

    ld bc, $0002                                  ; $6C19
    call Delay_Frames_Busy                        ; $6C1C
    ld a, [wBoot_D8E4]                            ; $6C1F
    and a                                         ; $6C22
    jr z, jr_008_6c37                             ; $6C23

    ld a, BANK(Leftover_08_4020)                  ; $6C25
    ld hl, Leftover_08_4020 + $A0                 ; $6C27
    call Sgb_SendPacket                           ; $6C2A
    ld bc, $0004                                  ; $6C2D
    call Delay_Frames_Busy                        ; $6C30
    xor a                                         ; $6C33
    ld [wBoot_D8E4], a                            ; $6C34

jr_008_6c37:
    jp Far_Return                                 ; $6C37


; C: MLT_REQ 2 players (08:4010), then reads P1: two joypad ids mean a Super Game Boy
Sgb_Detect::
    ld a, BANK(Sgb_MltReqPackets)                 ; $6C3A
    ld hl, Sgb_MltReqPackets + $10                ; $6C3C
    call Sgb_SendPacket                           ; $6C3F
    call Sgb_Delay                                ; $6C42
    ldh a, [rP1]                                  ; $6C45
    and $03                                       ; $6C47
    cp $03                                        ; $6C49
    jr nz, jr_008_6c8a                            ; $6C4B

    ld a, P1F_GET_DPAD                            ; $6C4D
    ldh [rP1], a                                  ; $6C4F
    ldh a, [rP1]                                  ; $6C51
    ldh a, [rP1]                                  ; $6C53
    ld a, P1F_GET_NONE                            ; $6C55
    ldh [rP1], a                                  ; $6C57
    ld a, P1F_GET_BTN                             ; $6C59
    ldh [rP1], a                                  ; $6C5B
    ldh a, [rP1]                                  ; $6C5D
    ldh a, [rP1]                                  ; $6C5F
    ldh a, [rP1]                                  ; $6C61
    ldh a, [rP1]                                  ; $6C63
    ldh a, [rP1]                                  ; $6C65
    ldh a, [rP1]                                  ; $6C67
    ld a, P1F_GET_NONE                            ; $6C69
    ldh [rP1], a                                  ; $6C6B
    ldh a, [rP1]                                  ; $6C6D
    ldh a, [rP1]                                  ; $6C6F
    ldh a, [rP1]                                  ; $6C71
    ldh a, [rP1]                                  ; $6C73
    and $03                                       ; $6C75
    cp $03                                        ; $6C77
    jr nz, jr_008_6c8a                            ; $6C79

    ld a, $08                                     ; $6C7B
    ld hl, Sgb_MltReqPackets                      ; $6C7D
    call Sgb_SendPacket                           ; $6C80
    call Sgb_Delay                                ; $6C83
    and a                                         ; $6C86
    jp Far_ReturnSramBank                         ; $6C87


jr_008_6c8a:
    ld a, $08                                     ; $6C8A
    ld hl, Sgb_MltReqPackets                      ; $6C8C
    call Sgb_SendPacket                           ; $6C8F
    call Sgb_Delay                                ; $6C92
    scf                                           ; $6C95
    jp Far_ReturnSramBank                         ; $6C96


    db $ff, $7f, $be, $32, $d6, $19, $00, $00, $ff, $7f, $be, $32, $d6, $19, $00, $00
    db $ff, $7f, $ff, $7f, $be, $32, $00, $00, $3e, $80, $e0, $68, $21, $99, $6c, $0e
    db $04, $2a, $e0, $69, $2a, $e0, $69, $0d, $20, $f7, $3e, $80, $e0, $6a, $21, $a1
    db $6c, $0e, $08, $2a, $e0, $6b, $2a, $e0, $6b, $0d, $20, $f7, $c3, $73, $01

    ; padding
    ds $1328, $00

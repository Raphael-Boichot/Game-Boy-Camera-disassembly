; Pocket Camera Hello Kitty (Japan), bank $04. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

; C: the same 1536 bytes as the Japanese Cam_PopcountTable256 (0A:7300); named by the code of
; Cam_CalibVector_VerifyChecksum, Cam_Calib_BootMeasureSeq, Cam_CountBrightSamples (04:4A43 04:4AB6 04:4C3F); read in
; the runs by Fx06_StretchH2x, Cam_PopcountSampleLoop_inner, Fx02_MirrorLtoR; first read on the ...
Cam_PopcountTable256::
    ASSERT LOW(Cam_PopcountTable256) == 0 ; read as a page: HIGH(Cam_PopcountTable256) with the index in the low byte
    db $00, $01, $01, $02, $01, $02, $02, $03, $01, $02, $02, $03, $02, $03, $03, $04
    db $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    db $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    db $01, $02, $02, $03, $02, $03, $03, $04, $02, $03, $03, $04, $03, $04, $04, $05
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    db $02, $03, $03, $04, $03, $04, $04, $05, $03, $04, $04, $05, $04, $05, $05, $06
    db $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    db $03, $04, $04, $05, $04, $05, $05, $06, $04, $05, $05, $06, $05, $06, $06, $07
    db $04, $05, $05, $06, $05, $06, $06, $07, $05, $06, $06, $07, $06, $07, $07, $08
    db $00, $80, $40, $c0, $20, $a0, $60, $e0, $10, $90, $50, $d0, $30, $b0, $70, $f0
    db $08, $88, $48, $c8, $28, $a8, $68, $e8, $18, $98, $58, $d8, $38, $b8, $78, $f8
    db $04, $84, $44, $c4, $24, $a4, $64, $e4, $14, $94, $54, $d4, $34, $b4, $74, $f4
    db $0c, $8c, $4c, $cc, $2c, $ac, $6c, $ec, $1c, $9c, $5c, $dc, $3c, $bc, $7c, $fc
    db $02, $82, $42, $c2, $22, $a2, $62, $e2, $12, $92, $52, $d2, $32, $b2, $72, $f2
    db $0a, $8a, $4a, $ca, $2a, $aa, $6a, $ea, $1a, $9a, $5a, $da, $3a, $ba, $7a, $fa
    db $06, $86, $46, $c6, $26, $a6, $66, $e6, $16, $96, $56, $d6, $36, $b6, $76, $f6
    db $0e, $8e, $4e, $ce, $2e, $ae, $6e, $ee, $1e, $9e, $5e, $de, $3e, $be, $7e, $fe
    db $01, $81, $41, $c1, $21, $a1, $61, $e1, $11, $91, $51, $d1, $31, $b1, $71, $f1
    db $09, $89, $49, $c9, $29, $a9, $69, $e9, $19, $99, $59, $d9, $39, $b9, $79, $f9
    db $05, $85, $45, $c5, $25, $a5, $65, $e5, $15, $95, $55, $d5, $35, $b5, $75, $f5
    db $0d, $8d, $4d, $cd, $2d, $ad, $6d, $ed, $1d, $9d, $5d, $dd, $3d, $bd, $7d, $fd
    db $03, $83, $43, $c3, $23, $a3, $63, $e3, $13, $93, $53, $d3, $33, $b3, $73, $f3
    db $0b, $8b, $4b, $cb, $2b, $ab, $6b, $eb, $1b, $9b, $5b, $db, $3b, $bb, $7b, $fb
    db $07, $87, $47, $c7, $27, $a7, $67, $e7, $17, $97, $57, $d7, $37, $b7, $77, $f7
    db $0f, $8f, $4f, $cf, $2f, $af, $6f, $ef, $1f, $9f, $5f, $df, $3f, $bf, $7f, $ff
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
    db $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
    db $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    db $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3
    db $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
    db $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3
    db $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff
    db $00, $03, $0c, $0f, $30, $33, $3c, $3f, $c0, $c3, $cc, $cf, $f0, $f3, $fc, $ff

    ; padding
    ds $10, $00

    db $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0
    db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
    db $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $c0, $0c, $0c
    db $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc
    db $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c, $3c
    db $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc, $fc
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3
    db $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33
    db $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf, $cf
    db $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3f
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff
    db $00, $c0, $30, $f0, $0c, $cc, $3c, $fc, $03, $c3, $33, $f3, $0f, $cf, $3f, $ff

; C: the same 512 bytes as the Japanese Cam_ReduceTbl_Lo (0A:7900); read in the runs by Fx08_Reduce2xTile2x2_GroupTop;
; first read on the screen Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
Cam_ReduceTbl_Lo::
    ASSERT LOW(Cam_ReduceTbl_Lo) == 0 ; read as a page: HIGH(Cam_ReduceTbl_Lo) with the index in the low byte
    INCBIN "data/bank_04/Cam_ReduceTbl_Lo.bin" ; $4600, 512 bytes
; C: the same 160 bytes as the Japanese Cam_ExposureShiftTable (0A:7B00); the camera code of this ROM is the Japanese
; one (owner, 2026-11-22): Cam_PopcountLevel (04:4A3E, the copy of the Japanese code of Cam_MainDispatch that reads it
; at 0A:402F) reads [$4800 + level], level 0-$9F (ld bc, $4800, ...
Cam_ExposureShiftTable::
    db $02, $03, $03, $03, $04, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $05, $04, $05, $05, $05, $05, $05, $06, $05, $06, $06

    db $06, $07, $07, $08, $09, $10, $10, $10, $09

    db $08, $07, $07, $06, $06, $05, $06, $05, $05, $05, $05, $04, $05, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $04, $04, $04, $04, $04, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $03, $03, $03, $03, $03

; C: the same 64 bytes as the Japanese Cam_ORegSAR_Table_Above (0A:7BA0); the camera code of this ROM is the Japanese
; one (owner, 2026-11-22): Cam_ORegister_SAR_Tail (04:564A, the Japanese 0A:4BEC, which reads it at 0A:4C0F) reads
; [$48A0 + (A005 & $3F)] when the picture has bright samples (ld hl, $48a0, ...
Cam_ORegSAR_Table_Above::
    db $b0, $81, $81, $83, $82, $85, $85, $87, $84, $89, $89, $8b, $8a, $8d, $8d, $8f
    db $88, $91, $91, $93, $92, $95, $95, $97, $94, $99, $99, $9b, $9a, $9d, $9d, $9f
    db $b0, $a1, $a3, $a3, $a6, $a5, $a7, $a7, $ac, $a9, $ab, $ab, $ae, $ad, $af, $af
    db $b8, $b1, $b3, $b3, $b6, $b5, $b7, $b7, $bc, $b9, $bb, $bb, $be, $bd, $bf, $bf

; C: the same 64 bytes as the Japanese Cam_ORegSAR_Table_Below (0A:7BE0); the camera code of this ROM is the Japanese
; one (owner, 2026-11-22): Cam_ORegister_SAR_Tail reads [$48E0 + (A005 & $3F)] when it has none (ld hl, $48e0,
; 04:5672)
Cam_ORegSAR_Table_Below::
    db $90, $82, $83, $84, $86, $86, $87, $88, $8c, $8a, $8b, $8c, $8e, $8e, $8f, $90

    db $98, $92, $93, $94, $96, $96, $97, $98, $9c, $9a, $9b, $9c, $9e, $9e, $9f, $9f
    db $90

    db $a0, $a1, $a2, $a2, $a4, $a5, $a6, $a4, $a8, $a9, $aa, $aa, $ac, $ad, $ae, $a8
    db $b0, $b1, $b2, $b2, $b4, $b5, $b6, $b4, $b8, $b9, $ba, $ba, $bc, $bd, $be

; C: the same 64 bytes as the Japanese Cam_DitherRamp_ParamsA (0A:7C20), 16 sets of 4 bytes; the camera code of this
; ROM is the Japanese one (owner, 2026-11-22): Cam_LoadRegisterSet (04:4CF8, the Japanese code that reads it in
; Cam_BuildDitherMatrix at 0A:42C5) copies set C, the contrast row $DA1F (1-16, ...
Cam_DitherRamp_ParamsA::
    db $80, $8f, $d0, $e6, $82, $90, $c8, $e3, $84, $90, $c0, $e0, $85, $91, $b8, $dd
    db $86, $91, $b1, $db, $87, $92, $aa, $d8

    db $88, $92, $a5, $d5, $89, $92, $a2, $d2, $8a, $92, $a1, $c8

    db $8b, $92, $a0, $be, $8c, $92, $9e, $b4, $8d, $92, $9c, $ac, $8e, $92, $9b, $a5
    db $8f, $92, $99, $a0, $90, $92, $97, $9a, $92, $92, $92, $92

; C: the same 64 bytes as the Japanese Cam_DitherRamp_ParamsB (0A:7C60); the camera code of this ROM is the Japanese
; one (owner, 2026-11-22): Cam_LoadRegisterSet takes $4960 + 4 (C - 1) for the other gain ($DA0A)
Cam_DitherRamp_ParamsB::
    db $80, $94, $dc, $ff, $82, $95, $d2, $ff, $84, $96, $ca, $ff, $86, $96, $c4, $ff
    db $88, $97, $be, $ff, $8a, $97, $b8, $ff, $8b, $98, $b2, $f5

    db $8c, $98, $ac, $eb

    db $8d, $98, $aa, $dd, $8e, $98, $a8, $d0, $8f, $98, $a6, $c4, $90, $98, $a4, $ba
    db $92, $98, $a1, $b1, $94, $98, $9d, $a8, $96, $98, $99, $a0, $98, $98, $98, $98

; I: leftover: 64 bytes (04:49A0-49DF) that no run reads and that no code names (owner rule 2026-11-11): the same
; bytes as the Japanese Cam_DitherRamp_ParamsUnused (0A:7CA0), unused there too
Leftover_04_49A0::
    db $87, $98, $b7, $ff, $88, $98, $b6, $ff, $89, $97, $b3, $ff, $8a, $97, $b0, $fa
    db $8b, $97, $ae, $f0, $8c, $96, $ab, $e6, $8d, $96, $aa, $dc, $8e, $96, $a4, $d4
    db $8f, $96, $a2, $c8, $90, $96, $a0, $be, $91, $96, $9e, $b4, $92, $96, $9c, $ac
    db $93, $96, $9b, $a5, $94, $96, $99, $a0, $95, $96, $97, $9a, $96, $96, $96, $96

; C: far wrapper of Cam_CalibSanityCheck_Measure
Cam_CalibSanityCheck_Measure_Far::
    call Cam_CalibSanityCheck_Measure             ; $49E0
    jp Far_Return                                 ; $49E3


    db $cd, $af, $52, $c3, $73, $01, $cd, $bb, $53, $c3, $73, $01

; C: far wrapper of 04:4CF8
Cam_LoadRegisterSet_Far::
    call Cam_LoadRegisterSet                      ; $49F2
    jp Far_Return                                 ; $49F5


; C: level A - 1 of the table 04:4A07 ($0C, $18 ... $48) passed to 04:4A3E; runs on its screen (02:00) in the core
; replays (port/entry_modes_kitty.csv); code read
Cam_PopcountLevelByIndex::
    dec a                                         ; $49F8
    ld c, a                                       ; $49F9
    ld b, $00                                     ; $49FA
    ld hl, Cam_PopcountLevelByIndex + $F          ; $49FC
    add hl, bc                                    ; $49FF
    ld a, [hl]                                    ; $4A00
    call Cam_PopcountLevel                        ; $4A01
    jp Far_Return                                 ; $4A04


    db $0c, $18, $24, $30, $3c, $48

; C: read in the runs by Cam_PopcountLevelByIndex; first read on the screen Mode02_TakePhotos_State00
; (trace/read_screens_kitty*.npz)
Cam_PopcountLevelByIndex_Tbl4A0D::
    db $54, $60

    db $6c, $78, $84, $90, $9c, $a8, $b4, $c0

; C: A bit 7 set: CameraFrame_RunType (bank 7, the camera frames); else Cam_DispatchEffect (the image effects)
Cam_ApplyEffectOrFrame::
    bit 7, a                                      ; $4A17
    jr z, Cam_DispatchEffect_Far                  ; $4A19

    ld b, BANK(CameraFrame_RunType)               ; $4A1B
    ld hl, CameraFrame_RunType                    ; $4A1D
    call Far_CallKeepA                            ; $4A20
    jp Far_Return                                 ; $4A23


; C: far wrapper of Cam_DispatchEffect
Cam_DispatchEffect_Far::
    call Cam_DispatchEffect                       ; $4A26
    jp Far_Return                                 ; $4A29


; C: far wrapper of Cam_Calib_ValidityCheck (keeps the SRAM bank)
Cam_Calib_ValidityCheck_Far::
    call Cam_Calib_ValidityCheck                  ; $4A2C
    jp Far_ReturnSramBank                         ; $4A2F


; C: far wrapper of Cam_FullCalibration
Cam_FullCalibration_Far::
    call Cam_FullCalibration                      ; $4A32
    jp Far_Return                                 ; $4A35


; C: far wrapper of Cam_LiveInit
Cam_LiveInit_Far::
    call Cam_LiveInit                             ; $4A38
    jp Far_Return                                 ; $4A3B


; C: Cam_PopcountSampleLoop over the picture at $A320 (SRAM bank 0), then how many steps of A fit in the count (hFFB3,
; at most $9F); runs on its screen (02:00) in the core replays (port/entry_modes_kitty.csv); code read
Cam_PopcountLevel::
    push af                                       ; $4A3E
    ld a, $00                                     ; $4A3F
    ldh [hSram_Format_FF8C], a                    ; $4A41
    ld [rRAMB], a                                 ; $4A43
    ld bc, $0000                                  ; $4A46
    ld de, $a320                                  ; $4A49
    call Cam_PopcountSampleLoop                   ; $4A4C
    pop af                                        ; $4A4F
    ld e, a                                       ; $4A50
    xor a                                         ; $4A51
    ldh [hScratchA], a                            ; $4A52

jr_004_4a54:
    ld a, c                                       ; $4A54
    sub e                                         ; $4A55
    ld c, a                                       ; $4A56
    jr nc, jr_004_4a5f                            ; $4A57

    dec b                                         ; $4A59
    ld a, b                                       ; $4A5A
    cp $ff                                        ; $4A5B
    jr z, jr_004_4a69                             ; $4A5D

jr_004_4a5f:
    ld a, c                                       ; $4A5F
    ldh a, [hScratchA]                            ; $4A60
    inc a                                         ; $4A62
    ldh [hScratchA], a                            ; $4A63
    cp $9f                                        ; $4A65
    jr nz, jr_004_4a54                            ; $4A67

jr_004_4a69:
    ldh a, [hScratchA]                            ; $4A69
    ld bc, Cam_ExposureShiftTable                 ; $4A6B
    add c                                         ; $4A6E
    ld c, a                                       ; $4A6F
    jr nc, jr_004_4a73                            ; $4A70

    inc b                                         ; $4A72

jr_004_4a73:
    ld a, [bc]                                    ; $4A73
    ldh [hScratchB], a                            ; $4A74
    ld a, [wCamExposureShadow]                    ; $4A76
    ld h, a                                       ; $4A79
    ld d, a                                       ; $4A7A
    ld a, [wCamExposureShadow + $1]               ; $4A7B
    ld l, a                                       ; $4A7E
    ld e, a                                       ; $4A7F
    ldh a, [hScratchA]                            ; $4A80
    sub $24                                       ; $4A82
    jr c, jr_004_4a9d                             ; $4A84

    ldh a, [hScratchB]                            ; $4A86

jr_004_4a88:
    cp $00                                        ; $4A88
    jr z, jr_004_4a93                             ; $4A8A

    srl d                                         ; $4A8C
    rr e                                          ; $4A8E
    dec a                                         ; $4A90
    jr jr_004_4a88                                ; $4A91

jr_004_4a93:
    add hl, de                                    ; $4A93
    jr c, jr_004_4a98                             ; $4A94

    jr jr_004_4ab2                                ; $4A96

jr_004_4a98:
    ld hl, $ffff                                  ; $4A98
    jr jr_004_4ab2                                ; $4A9B

jr_004_4a9d:
    ldh a, [hScratchB]                            ; $4A9D

jr_004_4a9f:
    cp $00                                        ; $4A9F
    jr z, jr_004_4aaa                             ; $4AA1

    srl d                                         ; $4AA3
    rr e                                          ; $4AA5
    dec a                                         ; $4AA7
    jr jr_004_4a9f                                ; $4AA8

jr_004_4aaa:
    ld a, d                                       ; $4AAA
    cpl                                           ; $4AAB
    ld d, a                                       ; $4AAC
    ld a, e                                       ; $4AAD
    cpl                                           ; $4AAE
    ld e, a                                       ; $4AAF
    inc de                                        ; $4AB0
    add hl, de                                    ; $4AB1

jr_004_4ab2:
    ld a, $10                                     ; $4AB2
    ldh [hSram_Format_FF8C], a                    ; $4AB4
    ld [rRAMB], a                                 ; $4AB6
    ld a, h                                       ; $4AB9
    ld [wCamExposureShadow], a                    ; $4ABA
    ld a, l                                       ; $4ABD
    ld [wCamExposureShadow + $1], a               ; $4ABE
    ld a, [wCamGainAlt]                           ; $4AC1
    ld b, a                                       ; $4AC4
    ld a, [wCamGainSel]                           ; $4AC5
    cp b                                          ; $4AC8
    jp z, Cam_MainDispatch_Band2                  ; $4AC9

    cp $08                                        ; $4ACC
    jp z, Cam_MainDispatch_Band3                  ; $4ACE

    cp $0a                                        ; $4AD1
    jp z, Cam_MainDispatch_Band4                  ; $4AD3

    ld b, h                                       ; $4AD6
    ld c, l                                       ; $4AD7
    ld a, [wCamA001Shadow]                        ; $4AD8
    bit 7, a                                      ; $4ADB
    jp nz, Cam_MainDispatch_Band1                 ; $4ADD

    ld de, hMode07_StateTable_FFD0                ; $4AE0
    add hl, de                                    ; $4AE3
    jp c, Cam_MainDispatch_EnterBand1             ; $4AE4

    ld h, b                                       ; $4AE7
    ld l, c                                       ; $4AE8
    ld de, hStamp_ObjPlaceOnStart_FFF0            ; $4AE9
    add hl, de                                    ; $4AEC
    jp c, Jump_004_4ceb                           ; $4AED

    ld a, $10                                     ; $4AF0
    ld [wCamExposureShadow + $1], a               ; $4AF2
    jp Jump_004_4ceb                              ; $4AF5


; C: same code as the Japanese Cam_MainDispatch_EnterBand1 (0A:40BA, 52 bytes, masked match)
Cam_MainDispatch_EnterBand1::
    ld a, [wCamGainCommitted]                     ; $4AF8
    ld [wCamGainSel], a                           ; $4AFB
    or $e0                                        ; $4AFE
    ld [wCamA001Shadow], a                        ; $4B00
    ld [$a001], a                                 ; $4B03
    xor a                                         ; $4B06
    ld [wCamExposureShadow], a                    ; $4B07
    ld [$a002], a                                 ; $4B0A
    ld a, $48                                     ; $4B0D
    ld [wCamExposureShadow + $1], a               ; $4B0F
    ld [$a003], a                                 ; $4B12
    ld a, [wCamBootV + $1]                        ; $4B15
    ld [wCamA004Shadow], a                        ; $4B18
    ld [$a004], a                                 ; $4B1B
    ld a, [wCamBootO + $1]                        ; $4B1E
    set 7, a                                      ; $4B21
    ld [wCamA005Shadow], a                        ; $4B23
    ld [$a005], a                                 ; $4B26
    jp Jump_004_4ceb                              ; $4B29


; C: same code as the Japanese Cam_MainDispatch_Band1 (0A:40EE, 74 bytes, masked match)
Cam_MainDispatch_Band1::
    ld de, hCopyReqSrcDstCnt + $4                 ; $4B2C
    add hl, de                                    ; $4B2F
    jp nc, Cam_MainDispatch_EnterBand0            ; $4B30

    ld h, b                                       ; $4B33
    ld l, c                                       ; $4B34
    ld de, $ee00                                  ; $4B35
    add hl, de                                    ; $4B38
    jp nc, Jump_004_4ceb                          ; $4B39

    ld a, [wCamGainAlt]                           ; $4B3C
    ld [wCamGainSel], a                           ; $4B3F
    or $e0                                        ; $4B42
    ld [wCamA001Shadow], a                        ; $4B44
    ld [$a001], a                                 ; $4B47
    ld a, $0d                                     ; $4B4A
    ld [wCamExposureShadow], a                    ; $4B4C
    ld a, $80                                     ; $4B4F
    ld [wCamExposureShadow + $1], a               ; $4B51
    ld a, [wCamBootV + $2]                        ; $4B54
    ld [wCamA004Shadow], a                        ; $4B57
    ld [$a004], a                                 ; $4B5A
    ld a, [wCamBootO + $2]                        ; $4B5D
    set 7, a                                      ; $4B60
    ld [wCamA005Shadow], a                        ; $4B62
    ld [$a005], a                                 ; $4B65
    ld a, [wCamGainSel]                           ; $4B68
    ld b, a                                       ; $4B6B
    ld a, [wCamContrastRow]                       ; $4B6C
    ld c, a                                       ; $4B6F
    call Cam_LoadRegisterSet                      ; $4B70
    jp Jump_004_4ceb                              ; $4B73


; C: same code as the Japanese Cam_MainDispatch_EnterBand0 (0A:4138, 52 bytes, masked match)
Cam_MainDispatch_EnterBand0::
    ld a, [wCamGainCommitted]                     ; $4B76
    ld [wCamGainSel], a                           ; $4B79
    or $20                                        ; $4B7C
    ld [wCamA001Shadow], a                        ; $4B7E
    ld [$a001], a                                 ; $4B81
    xor a                                         ; $4B84
    ld [wCamExposureShadow], a                    ; $4B85
    ld [$a002], a                                 ; $4B88
    ld a, $1f                                     ; $4B8B
    ld [wCamExposureShadow + $1], a               ; $4B8D
    ld [$a003], a                                 ; $4B90
    ld a, [wCamBootV]                             ; $4B93
    ld [wCamA004Shadow], a                        ; $4B96
    ld [$a004], a                                 ; $4B99
    ld a, [wCamBootO]                             ; $4B9C
    set 7, a                                      ; $4B9F
    ld [wCamA005Shadow], a                        ; $4BA1
    ld [$a005], a                                 ; $4BA4
    jp Jump_004_4ceb                              ; $4BA7


; C: same code as the Japanese Cam_MainDispatch_Band2 (0A:416C, 139 bytes, masked match)
Cam_MainDispatch_Band2::
    ld b, h                                       ; $4BAA
    ld c, l                                       ; $4BAB
    ld de, $f800                                  ; $4BAC
    add hl, de                                    ; $4BAF
    jr nc, jr_004_4bf7                            ; $4BB0

    ld h, b                                       ; $4BB2
    ld l, c                                       ; $4BB3
    ld de, $a000                                  ; $4BB4
    add hl, de                                    ; $4BB7
    jp nc, Jump_004_4ceb                          ; $4BB8

    ld a, $08                                     ; $4BBB
    ld [wCamGainSel], a                           ; $4BBD
    or $e0                                        ; $4BC0
    ld [wCamA001Shadow], a                        ; $4BC2
    ld [$a001], a                                 ; $4BC5
    ld a, $35                                     ; $4BC8
    ld [wCamExposureShadow], a                    ; $4BCA
    ld [$a002], a                                 ; $4BCD
    xor a                                         ; $4BD0
    ld [wCamExposureShadow + $1], a               ; $4BD1
    ld [$a003], a                                 ; $4BD4
    ld a, [wCamBootV + $3]                        ; $4BD7
    ld [wCamA004Shadow], a                        ; $4BDA
    ld [$a004], a                                 ; $4BDD
    ld a, [wCamBootO + $3]                        ; $4BE0
    set 7, a                                      ; $4BE3
    ld [wCamA005Shadow], a                        ; $4BE5
    ld [$a005], a                                 ; $4BE8
    ld a, [wCamGainSel]                           ; $4BEB
    ld b, a                                       ; $4BEE
    ld a, [wCamContrastRow]                       ; $4BEF
    ld c, a                                       ; $4BF2
    call Cam_LoadRegisterSet                      ; $4BF3
    ret                                           ; $4BF6


jr_004_4bf7:
    ld a, [wCamGainCommitted]                     ; $4BF7
    ld [wCamGainSel], a                           ; $4BFA
    or $e0                                        ; $4BFD
    ld [wCamA001Shadow], a                        ; $4BFF
    ld [$a001], a                                 ; $4C02
    ld a, $0b                                     ; $4C05
    ld [wCamExposureShadow], a                    ; $4C07
    ld [$a002], a                                 ; $4C0A
    ld a, $00                                     ; $4C0D
    ld [wCamExposureShadow + $1], a               ; $4C0F
    ld [$a003], a                                 ; $4C12
    ld a, [wCamBootV + $1]                        ; $4C15
    ld [wCamA004Shadow], a                        ; $4C18
    ld [$a004], a                                 ; $4C1B
    ld a, [wCamBootO + $1]                        ; $4C1E
    set 7, a                                      ; $4C21
    ld [wCamA005Shadow], a                        ; $4C23
    ld [$a005], a                                 ; $4C26
    ld a, [wCamGainSel]                           ; $4C29
    ld b, a                                       ; $4C2C
    ld a, [wCamContrastRow]                       ; $4C2D
    ld c, a                                       ; $4C30
    call Cam_LoadRegisterSet                      ; $4C31
    ret                                           ; $4C34


; C: same code as the Japanese Cam_MainDispatch_Band3 (0A:41F7, 125 bytes, masked match)
Cam_MainDispatch_Band3::
    ld b, h                                       ; $4C35
    ld c, l                                       ; $4C36
    ld de, wDoodleFromShutterbug                  ; $4C37
    add hl, de                                    ; $4C3A
    jr nc, jr_004_4c75                            ; $4C3B

    ld h, b                                       ; $4C3D
    ld l, c                                       ; $4C3E
    ld de, Cam_PopcountTable256                   ; $4C3F
    add hl, de                                    ; $4C42
    jp nc, Jump_004_4ceb                          ; $4C43

    ld a, $0a                                     ; $4C46
    ld [wCamGainSel], a                           ; $4C48
    ld [wCamA001Shadow], a                        ; $4C4B
    ld [$a001], a                                 ; $4C4E
    ld a, $85                                     ; $4C51
    ld [wCamExposureShadow], a                    ; $4C53
    ld [$a002], a                                 ; $4C56
    xor a                                         ; $4C59
    ld [wCamExposureShadow + $1], a               ; $4C5A
    ld [$a003], a                                 ; $4C5D
    ld a, [wCamBootV + $4]                        ; $4C60
    ld [wCamA004Shadow], a                        ; $4C63
    ld [$a004], a                                 ; $4C66
    ld a, [wCamBootO + $4]                        ; $4C69
    set 7, a                                      ; $4C6C
    ld [wCamA005Shadow], a                        ; $4C6E
    ld [$a005], a                                 ; $4C71
    ret                                           ; $4C74


jr_004_4c75:
    ld a, [wCamGainAlt]                           ; $4C75
    ld [wCamGainSel], a                           ; $4C78
    or $e0                                        ; $4C7B
    ld [wCamA001Shadow], a                        ; $4C7D
    ld [$a001], a                                 ; $4C80
    ld a, $45                                     ; $4C83
    ld [wCamExposureShadow], a                    ; $4C85
    ld [$a002], a                                 ; $4C88
    xor a                                         ; $4C8B
    ld [wCamExposureShadow + $1], a               ; $4C8C
    ld [$a003], a                                 ; $4C8F
    ld a, [wCamBootV + $2]                        ; $4C92
    ld [wCamA004Shadow], a                        ; $4C95
    ld [$a004], a                                 ; $4C98
    ld a, [wCamBootO + $2]                        ; $4C9B
    set 7, a                                      ; $4C9E
    ld [wCamA005Shadow], a                        ; $4CA0
    ld [$a005], a                                 ; $4CA3
    ld a, [wCamGainSel]                           ; $4CA6
    ld b, a                                       ; $4CA9
    ld a, [wCamContrastRow]                       ; $4CAA
    ld c, a                                       ; $4CAD
    call Cam_LoadRegisterSet                      ; $4CAE
    ret                                           ; $4CB1


; C: same code as the Japanese Cam_MainDispatch_Band4 (0A:4274, 57 bytes, masked match)
Cam_MainDispatch_Band4::
    ld b, h                                       ; $4CB2
    ld c, l                                       ; $4CB3
    ld de, $a000                                  ; $4CB4
    add hl, de                                    ; $4CB7
    jr c, jr_004_4ceb                             ; $4CB8

    ld a, $08                                     ; $4CBA
    ld [wCamGainSel], a                           ; $4CBC
    or $e0                                        ; $4CBF
    ld [wCamA001Shadow], a                        ; $4CC1
    ld [$a001], a                                 ; $4CC4
    ld a, $8c                                     ; $4CC7
    ld [wCamExposureShadow], a                    ; $4CC9
    ld [$a002], a                                 ; $4CCC
    xor a                                         ; $4CCF
    ld [wCamExposureShadow + $1], a               ; $4CD0
    ld [$a003], a                                 ; $4CD3
    ld a, [wCamBootV + $3]                        ; $4CD6
    ld [wCamA004Shadow], a                        ; $4CD9
    ld [$a004], a                                 ; $4CDC
    ld a, [wCamBootO + $3]                        ; $4CDF
    set 7, a                                      ; $4CE2
    ld [wCamA005Shadow], a                        ; $4CE4
    ld [$a005], a                                 ; $4CE7
    ret                                           ; $4CEA


Jump_004_4ceb:
jr_004_4ceb:
    ld a, [wCamExposureShadow]                    ; $4CEB
    ld [$a002], a                                 ; $4CEE
    ld a, [wCamExposureShadow + $1]               ; $4CF1
    ld [$a003], a                                 ; $4CF4
    ret                                           ; $4CF7


; C: camera registers (bank $10): picks the 4-byte register set C of 04:4920 or 04:4960 by B against $DA09 / $DA0A;
; code read; runs at boot (the camera checks)
Cam_LoadRegisterSet::
    ld a, $10                                     ; $4CF8
    ldh [hSram_Format_FF8C], a                    ; $4CFA
    ld [rRAMB], a                                 ; $4CFC
    ld a, [wCamGainCommitted]                     ; $4CFF
    cp b                                          ; $4D02
    jr nz, jr_004_4d0a                            ; $4D03

    ld hl, Cam_DitherRamp_ParamsA                 ; $4D05
    jr jr_004_4d22                                ; $4D08

jr_004_4d0a:
    ld a, [wCamGainAlt]                           ; $4D0A
    cp b                                          ; $4D0D
    jr nz, jr_004_4d15                            ; $4D0E

    ld hl, Cam_DitherRamp_ParamsB                 ; $4D10
    jr jr_004_4d22                                ; $4D13

jr_004_4d15:
    ld a, $08                                     ; $4D15
    cp b                                          ; $4D17
    jr nz, jr_004_4d1f                            ; $4D18

    ld hl, Cam_DitherRamp_ParamsA                 ; $4D1A
    jr jr_004_4d22                                ; $4D1D

jr_004_4d1f:
    ld hl, Cam_DitherRamp_ParamsA                 ; $4D1F

jr_004_4d22:
    ld de, $0004                                  ; $4D22

jr_004_4d25:
    dec c                                         ; $4D25
    jr z, jr_004_4d2b                             ; $4D26

    add hl, de                                    ; $4D28
    jr jr_004_4d25                                ; $4D29

jr_004_4d2b:
    ld de, wDitherParams                          ; $4D2B
    ld a, [hl+]                                   ; $4D2E
    ld [de], a                                    ; $4D2F
    inc de                                        ; $4D30
    ld a, [hl+]                                   ; $4D31
    ld [de], a                                    ; $4D32
    inc de                                        ; $4D33
    ld a, [hl+]                                   ; $4D34
    ld [de], a                                    ; $4D35
    inc de                                        ; $4D36
    ld a, [hl+]                                   ; $4D37
    ld [de], a                                    ; $4D38
    ld a, [wCamDitherMode]                        ; $4D39
    cp $00                                        ; $4D3C
    jp z, Cam_Dither_Flat                         ; $4D3E

    cp $01                                        ; $4D41
    jp z, Cam_Dither_RampA                        ; $4D43

; C: same code as the Japanese Cam_Dither_RampB (0A:4306, 262 bytes, masked match)
Cam_Dither_RampB::
    ld a, [wDitherParams]                         ; $4D46
    ld b, a                                       ; $4D49
    ld a, [wDitherParams + $1]                    ; $4D4A
    sub b                                         ; $4D4D
    swap a                                        ; $4D4E
    ld b, a                                       ; $4D50
    and $f0                                       ; $4D51
    ld c, a                                       ; $4D53
    ld a, b                                       ; $4D54
    and $0f                                       ; $4D55
    ld b, a                                       ; $4D57
    ld l, $00                                     ; $4D58
    ld a, [wDitherParams]                         ; $4D5A
    ld h, a                                       ; $4D5D
    ld [$a006], a                                 ; $4D5E
    ld [$a012], a                                 ; $4D61
    ld [$a009], a                                 ; $4D64
    ld [$a015], a                                 ; $4D67
    add hl, bc                                    ; $4D6A
    add hl, bc                                    ; $4D6B
    add hl, bc                                    ; $4D6C
    add hl, bc                                    ; $4D6D
    ld a, h                                       ; $4D6E
    ld [$a024], a                                 ; $4D6F
    ld [$a030], a                                 ; $4D72
    ld [$a027], a                                 ; $4D75
    ld [$a033], a                                 ; $4D78
    add hl, bc                                    ; $4D7B
    add hl, bc                                    ; $4D7C
    add hl, bc                                    ; $4D7D
    add hl, bc                                    ; $4D7E
    ld a, h                                       ; $4D7F
    ld [$a01e], a                                 ; $4D80
    ld [$a02a], a                                 ; $4D83
    ld [$a021], a                                 ; $4D86
    ld [$a02d], a                                 ; $4D89
    add hl, bc                                    ; $4D8C
    add hl, bc                                    ; $4D8D
    add hl, bc                                    ; $4D8E
    add hl, bc                                    ; $4D8F
    ld a, h                                       ; $4D90
    ld [$a00c], a                                 ; $4D91
    ld [$a018], a                                 ; $4D94
    ld [$a00f], a                                 ; $4D97
    ld [$a01b], a                                 ; $4D9A
    ld a, [wDitherParams + $1]                    ; $4D9D
    ld b, a                                       ; $4DA0
    ld a, [wDitherParams + $2]                    ; $4DA1
    sub b                                         ; $4DA4
    swap a                                        ; $4DA5
    ld b, a                                       ; $4DA7
    and $f0                                       ; $4DA8
    ld c, a                                       ; $4DAA
    ld a, b                                       ; $4DAB
    and $0f                                       ; $4DAC
    ld b, a                                       ; $4DAE
    ld l, $00                                     ; $4DAF
    ld a, [wDitherParams + $1]                    ; $4DB1
    ld h, a                                       ; $4DB4
    ld [$a007], a                                 ; $4DB5
    ld [$a013], a                                 ; $4DB8
    ld [$a00a], a                                 ; $4DBB
    ld [$a016], a                                 ; $4DBE
    add hl, bc                                    ; $4DC1
    add hl, bc                                    ; $4DC2
    add hl, bc                                    ; $4DC3
    add hl, bc                                    ; $4DC4
    ld a, h                                       ; $4DC5
    ld [$a025], a                                 ; $4DC6
    ld [$a031], a                                 ; $4DC9
    ld [$a028], a                                 ; $4DCC
    ld [$a034], a                                 ; $4DCF
    add hl, bc                                    ; $4DD2
    add hl, bc                                    ; $4DD3
    add hl, bc                                    ; $4DD4
    add hl, bc                                    ; $4DD5
    ld a, h                                       ; $4DD6
    ld [$a01f], a                                 ; $4DD7
    ld [$a02b], a                                 ; $4DDA
    ld [$a022], a                                 ; $4DDD
    ld [$a02e], a                                 ; $4DE0
    add hl, bc                                    ; $4DE3
    add hl, bc                                    ; $4DE4
    add hl, bc                                    ; $4DE5
    add hl, bc                                    ; $4DE6
    ld a, h                                       ; $4DE7
    ld [$a00d], a                                 ; $4DE8
    ld [$a019], a                                 ; $4DEB
    ld [$a010], a                                 ; $4DEE
    ld [$a01c], a                                 ; $4DF1
    ld a, [wDitherParams + $2]                    ; $4DF4
    ld b, a                                       ; $4DF7
    ld a, [wDitherParams + $3]                    ; $4DF8
    sub b                                         ; $4DFB
    swap a                                        ; $4DFC
    ld b, a                                       ; $4DFE
    and $f0                                       ; $4DFF
    ld c, a                                       ; $4E01
    ld a, b                                       ; $4E02
    and $0f                                       ; $4E03
    ld b, a                                       ; $4E05
    ld l, $00                                     ; $4E06
    ld a, [wDitherParams + $2]                    ; $4E08
    ld h, a                                       ; $4E0B
    ld [$a008], a                                 ; $4E0C
    ld [$a014], a                                 ; $4E0F
    ld [$a00b], a                                 ; $4E12
    ld [$a017], a                                 ; $4E15
    add hl, bc                                    ; $4E18
    add hl, bc                                    ; $4E19
    add hl, bc                                    ; $4E1A
    add hl, bc                                    ; $4E1B
    ld a, h                                       ; $4E1C
    ld [$a026], a                                 ; $4E1D
    ld [$a032], a                                 ; $4E20
    ld [$a029], a                                 ; $4E23
    ld [$a035], a                                 ; $4E26
    add hl, bc                                    ; $4E29
    add hl, bc                                    ; $4E2A
    add hl, bc                                    ; $4E2B
    add hl, bc                                    ; $4E2C
    ld a, h                                       ; $4E2D
    ld [$a020], a                                 ; $4E2E
    ld [$a02c], a                                 ; $4E31
    ld [$a023], a                                 ; $4E34
    ld [$a02f], a                                 ; $4E37
    add hl, bc                                    ; $4E3A
    add hl, bc                                    ; $4E3B
    add hl, bc                                    ; $4E3C
    add hl, bc                                    ; $4E3D
    ld a, h                                       ; $4E3E
    ld [$a00e], a                                 ; $4E3F
    ld [$a01a], a                                 ; $4E42
    ld [$a011], a                                 ; $4E45
    ld [$a01d], a                                 ; $4E48
    ret                                           ; $4E4B


; C: same code as the Japanese Cam_Dither_Flat (0A:440C, 27 bytes, masked match)
Cam_Dither_Flat::
    ld hl, $a006                                  ; $4E4C
    ld a, [wDitherParams]                         ; $4E4F
    ld b, a                                       ; $4E52
    ld a, [wDitherParams + $1]                    ; $4E53
    ld c, a                                       ; $4E56
    ld a, [wDitherParams + $2]                    ; $4E57
    ld d, a                                       ; $4E5A
    ld e, $10                                     ; $4E5B

jr_004_4e5d:
    ld a, b                                       ; $4E5D
    ld [hl+], a                                   ; $4E5E
    ld a, c                                       ; $4E5F
    ld [hl+], a                                   ; $4E60
    ld a, d                                       ; $4E61
    ld [hl+], a                                   ; $4E62
    dec e                                         ; $4E63
    jr nz, jr_004_4e5d                            ; $4E64

    ret                                           ; $4E66


; C: same code as the Japanese Cam_Dither_RampA (0A:4427, 307 bytes, masked match)
Cam_Dither_RampA::
    ld a, [wDitherParams]                         ; $4E67
    ld b, a                                       ; $4E6A
    ld a, [wDitherParams + $1]                    ; $4E6B
    sub b                                         ; $4E6E
    swap a                                        ; $4E6F
    ld b, a                                       ; $4E71
    and $f0                                       ; $4E72
    ld c, a                                       ; $4E74
    ld a, b                                       ; $4E75
    and $0f                                       ; $4E76
    ld b, a                                       ; $4E78
    ld l, $00                                     ; $4E79
    ld a, [wDitherParams]                         ; $4E7B
    ld h, a                                       ; $4E7E
    ld [$a006], a                                 ; $4E7F
    add hl, bc                                    ; $4E82
    ld a, h                                       ; $4E83
    ld [$a024], a                                 ; $4E84
    add hl, bc                                    ; $4E87
    ld a, h                                       ; $4E88
    ld [$a01e], a                                 ; $4E89
    add hl, bc                                    ; $4E8C
    ld a, h                                       ; $4E8D
    ld [$a00c], a                                 ; $4E8E
    add hl, bc                                    ; $4E91
    ld a, h                                       ; $4E92
    ld [$a015], a                                 ; $4E93
    add hl, bc                                    ; $4E96
    ld a, h                                       ; $4E97
    ld [$a033], a                                 ; $4E98
    add hl, bc                                    ; $4E9B
    ld a, h                                       ; $4E9C
    ld [$a02d], a                                 ; $4E9D
    add hl, bc                                    ; $4EA0
    ld a, h                                       ; $4EA1
    ld [$a01b], a                                 ; $4EA2
    add hl, bc                                    ; $4EA5
    ld a, h                                       ; $4EA6
    ld [$a012], a                                 ; $4EA7
    add hl, bc                                    ; $4EAA
    ld a, h                                       ; $4EAB
    ld [$a030], a                                 ; $4EAC
    add hl, bc                                    ; $4EAF
    ld a, h                                       ; $4EB0
    ld [$a02a], a                                 ; $4EB1
    add hl, bc                                    ; $4EB4
    ld a, h                                       ; $4EB5
    ld [$a018], a                                 ; $4EB6
    add hl, bc                                    ; $4EB9
    ld a, h                                       ; $4EBA
    ld [$a009], a                                 ; $4EBB
    add hl, bc                                    ; $4EBE
    ld a, h                                       ; $4EBF
    ld [$a027], a                                 ; $4EC0
    add hl, bc                                    ; $4EC3
    ld a, h                                       ; $4EC4
    ld [$a021], a                                 ; $4EC5
    add hl, bc                                    ; $4EC8
    ld a, h                                       ; $4EC9
    ld [$a00f], a                                 ; $4ECA
    ld a, [wDitherParams + $1]                    ; $4ECD
    ld b, a                                       ; $4ED0
    ld a, [wDitherParams + $2]                    ; $4ED1
    sub b                                         ; $4ED4
    swap a                                        ; $4ED5
    ld b, a                                       ; $4ED7
    and $f0                                       ; $4ED8
    ld c, a                                       ; $4EDA
    ld a, b                                       ; $4EDB
    and $0f                                       ; $4EDC
    ld b, a                                       ; $4EDE
    ld l, $00                                     ; $4EDF
    ld a, [wDitherParams + $1]                    ; $4EE1
    ld h, a                                       ; $4EE4
    ld [$a007], a                                 ; $4EE5
    add hl, bc                                    ; $4EE8
    ld a, h                                       ; $4EE9
    ld [$a025], a                                 ; $4EEA
    add hl, bc                                    ; $4EED
    ld a, h                                       ; $4EEE
    ld [$a01f], a                                 ; $4EEF
    add hl, bc                                    ; $4EF2
    ld a, h                                       ; $4EF3
    ld [$a00d], a                                 ; $4EF4
    add hl, bc                                    ; $4EF7
    ld a, h                                       ; $4EF8
    ld [$a016], a                                 ; $4EF9
    add hl, bc                                    ; $4EFC
    ld a, h                                       ; $4EFD
    ld [$a034], a                                 ; $4EFE
    add hl, bc                                    ; $4F01
    ld a, h                                       ; $4F02
    ld [$a02e], a                                 ; $4F03
    add hl, bc                                    ; $4F06
    ld a, h                                       ; $4F07
    ld [$a01c], a                                 ; $4F08
    add hl, bc                                    ; $4F0B
    ld a, h                                       ; $4F0C
    ld [$a013], a                                 ; $4F0D
    add hl, bc                                    ; $4F10
    ld a, h                                       ; $4F11
    ld [$a031], a                                 ; $4F12
    add hl, bc                                    ; $4F15
    ld a, h                                       ; $4F16
    ld [$a02b], a                                 ; $4F17
    add hl, bc                                    ; $4F1A
    ld a, h                                       ; $4F1B
    ld [$a019], a                                 ; $4F1C
    add hl, bc                                    ; $4F1F
    ld a, h                                       ; $4F20
    ld [$a00a], a                                 ; $4F21
    add hl, bc                                    ; $4F24
    ld a, h                                       ; $4F25
    ld [$a028], a                                 ; $4F26
    add hl, bc                                    ; $4F29
    ld a, h                                       ; $4F2A
    ld [$a022], a                                 ; $4F2B
    add hl, bc                                    ; $4F2E
    ld a, h                                       ; $4F2F
    ld [$a010], a                                 ; $4F30
    ld a, [wDitherParams + $2]                    ; $4F33
    ld b, a                                       ; $4F36
    ld a, [wDitherParams + $3]                    ; $4F37
    sub b                                         ; $4F3A
    swap a                                        ; $4F3B
    ld b, a                                       ; $4F3D
    and $f0                                       ; $4F3E
    ld c, a                                       ; $4F40
    ld a, b                                       ; $4F41
    and $0f                                       ; $4F42
    ld b, a                                       ; $4F44
    ld l, $00                                     ; $4F45
    ld a, [wDitherParams + $2]                    ; $4F47
    ld h, a                                       ; $4F4A
    ld [$a008], a                                 ; $4F4B
    add hl, bc                                    ; $4F4E
    ld a, h                                       ; $4F4F
    ld [$a026], a                                 ; $4F50
    add hl, bc                                    ; $4F53
    ld a, h                                       ; $4F54
    ld [$a020], a                                 ; $4F55
    add hl, bc                                    ; $4F58
    ld a, h                                       ; $4F59
    ld [$a00e], a                                 ; $4F5A
    add hl, bc                                    ; $4F5D
    ld a, h                                       ; $4F5E
    ld [$a017], a                                 ; $4F5F
    add hl, bc                                    ; $4F62
    ld a, h                                       ; $4F63
    ld [$a035], a                                 ; $4F64
    add hl, bc                                    ; $4F67
    ld a, h                                       ; $4F68
    ld [$a02f], a                                 ; $4F69
    add hl, bc                                    ; $4F6C
    ld a, h                                       ; $4F6D
    ld [$a01d], a                                 ; $4F6E
    add hl, bc                                    ; $4F71
    ld a, h                                       ; $4F72
    ld [$a014], a                                 ; $4F73
    add hl, bc                                    ; $4F76
    ld a, h                                       ; $4F77
    ld [$a032], a                                 ; $4F78
    add hl, bc                                    ; $4F7B
    ld a, h                                       ; $4F7C
    ld [$a02c], a                                 ; $4F7D
    add hl, bc                                    ; $4F80
    ld a, h                                       ; $4F81
    ld [$a01a], a                                 ; $4F82
    add hl, bc                                    ; $4F85
    ld a, h                                       ; $4F86
    ld [$a00b], a                                 ; $4F87
    add hl, bc                                    ; $4F8A
    ld a, h                                       ; $4F8B
    ld [$a029], a                                 ; $4F8C
    add hl, bc                                    ; $4F8F
    ld a, h                                       ; $4F90
    ld [$a023], a                                 ; $4F91
    add hl, bc                                    ; $4F94
    ld a, h                                       ; $4F95
    ld [$a011], a                                 ; $4F96
    ret                                           ; $4F99


; C: the Japanese Cam_CalibSanityCheck_Measure (0A:455A), 23 instructions against 22, with 1 small edits (variables
; moved between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code
; compared
Cam_CalibSanityCheck_Measure::
    ld a, $a0                                     ; $4F9A
    ldh [hScratchC], a                            ; $4F9C
    ld a, $82                                     ; $4F9E
    ldh [hScratchD], a                            ; $4FA0
    call Cam_FactoryMeasure1                      ; $4FA2
    ld a, $a0                                     ; $4FA5
    ldh [hScratchC], a                            ; $4FA7
    ld a, $02                                     ; $4FA9
    ldh [hScratchD], a                            ; $4FAB
    call Cam_FactoryMeasure2                      ; $4FAD
    ld a, $02                                     ; $4FB0
    ldh [hSram_Format_FF8C], a                    ; $4FB2
    ld [rRAMB], a                                 ; $4FB4
    ld a, [wCamCalibVector + $a]                  ; $4FB7
    ld b, a                                       ; $4FBA
    ld a, [$affc]                                 ; $4FBB
    cp b                                          ; $4FBE
    jr c, jr_004_4fca                             ; $4FBF

    sub b                                         ; $4FC1
    ldh [hDiffOrValue], a                         ; $4FC2
    ld a, $24                                     ; $4FC4
    ldh [hScratchD], a                            ; $4FC6
    jr jr_004_4fd3                                ; $4FC8

jr_004_4fca:
    ld c, a                                       ; $4FCA
    ld a, b                                       ; $4FCB
    sub c                                         ; $4FCC
    ldh [hDiffOrValue], a                         ; $4FCD
    ld a, $25                                     ; $4FCF
    ldh [hScratchD], a                            ; $4FD1

jr_004_4fd3:
    ld a, [wCamCalibVector + $b]                  ; $4FD3
    ld b, a                                       ; $4FD6
    ld a, [$affd]                                 ; $4FD7
    cp b                                          ; $4FDA
    jr c, jr_004_4fe6                             ; $4FDB

    sub b                                         ; $4FDD
    ldh [hDiff2], a                               ; $4FDE
    ld a, $24                                     ; $4FE0
    ldh [hPrevOrSign], a                          ; $4FE2
    jr jr_004_4fef                                ; $4FE4

jr_004_4fe6:
    ld c, a                                       ; $4FE6
    ld a, b                                       ; $4FE7
    sub c                                         ; $4FE8
    ldh [hDiff2], a                               ; $4FE9
    ld a, $25                                     ; $4FEB
    ldh [hPrevOrSign], a                          ; $4FED

jr_004_4fef:
    ldh a, [hDiffOrValue]                         ; $4FEF
    ld b, a                                       ; $4FF1
    ld a, [$aff0]                                 ; $4FF2
    sub b                                         ; $4FF5
    jr c, jr_004_5006                             ; $4FF6

    ldh a, [hDiff2]                               ; $4FF8
    ld b, a                                       ; $4FFA
    ld a, [$aff1]                                 ; $4FFB
    sub b                                         ; $4FFE
    jr c, jr_004_5006                             ; $4FFF

    xor a                                         ; $5001
    ldh [hCalibSanityPassFlag], a                 ; $5002
    jr jr_004_500a                                ; $5004

jr_004_5006:
    ld a, $ff                                     ; $5006
    ldh [hCalibSanityPassFlag], a                 ; $5008

jr_004_500a:
    ret                                           ; $500A


; C: same code as the Japanese Cam_Calib_ValidityCheck (0A:45C9, 70 bytes, masked match)
Cam_Calib_ValidityCheck::
    call Cam_CalibVector_VerifyChecksum           ; $500B
    or a                                          ; $500E
    jr z, jr_004_504d                             ; $500F

    ld a, $7e                                     ; $5011
    ld [wCamCalibVector], a                       ; $5013
    ld a, $7f                                     ; $5016
    ld [wCamCalibVector + $1], a                  ; $5018
    ld a, $7f                                     ; $501B
    ld [wCamCalibVector + $2], a                  ; $501D
    ld a, $7f                                     ; $5020
    ld [wCamCalibVector + $3], a                  ; $5022
    ld a, $7e                                     ; $5025
    ld [wCamCalibVector + $4], a                  ; $5027
    ld a, $7d                                     ; $502A
    ld [wCamCalibVector + $5], a                  ; $502C
    ld a, $7e                                     ; $502F
    ld [wCamCalibVector + $6], a                  ; $5031
    ld a, $7e                                     ; $5034
    ld [wCamCalibVector + $7], a                  ; $5036
    ld a, $7d                                     ; $5039
    ld [wCamCalibVector + $8], a                  ; $503B
    ld a, $7e                                     ; $503E
    ld [wCamCalibVector + $9], a                  ; $5040
    ld a, $7d                                     ; $5043
    ld [wCamCalibVector + $a], a                  ; $5045
    ld a, $6a                                     ; $5048
    ld [wCamCalibVector + $b], a                  ; $504A

jr_004_504d:
    call Cam_Calib_BootMeasureSeq                 ; $504D
    ret                                           ; $5050


; C: SRAM bank 2: checksum of the 12 bytes from $AFF2 (sum + $0D, xor + $23) compared with the two bytes after them
Cam_CalibVector_VerifyChecksum::
    ld a, $02                                     ; $5051
    ldh [hSram_Format_FF8C], a                    ; $5053
    ld [rRAMB], a                                 ; $5055
    ld hl, $aff2                                  ; $5058
    ld b, $00                                     ; $505B
    ld c, $00                                     ; $505D
    ld d, $0c                                     ; $505F

jr_004_5061:
    ld a, [hl+]                                   ; $5061
    ld e, a                                       ; $5062
    add b                                         ; $5063
    ld b, a                                       ; $5064
    ld a, e                                       ; $5065
    xor c                                         ; $5066
    ld c, a                                       ; $5067
    dec d                                         ; $5068
    jr nz, jr_004_5061                            ; $5069

    ld a, b                                       ; $506B
    add $0d                                       ; $506C
    ld b, a                                       ; $506E
    ld a, c                                       ; $506F
    add $23                                       ; $5070
    ld c, a                                       ; $5072
    ld a, [hl+]                                   ; $5073
    cp b                                          ; $5074
    jr nz, jr_004_5085                            ; $5075

    ldh [hScratchB], a                            ; $5077
    ld a, [hl+]                                   ; $5079
    cp c                                          ; $507A
    jr nz, jr_004_5085                            ; $507B

    ldh [hScratchC], a                            ; $507D
    ld a, $01                                     ; $507F
    ldh [hScratchA], a                            ; $5081
    jr jr_004_5089                                ; $5083

jr_004_5085:
    ld a, $00                                     ; $5085
    ldh [hScratchA], a                            ; $5087

jr_004_5089:
    ld a, $08                                     ; $5089
    ldh [hSram_Format_FF8C], a                    ; $508B
    ld [rRAMB], a                                 ; $508D
    ld hl, $bff2                                  ; $5090
    ld b, $00                                     ; $5093
    ld c, $00                                     ; $5095
    ld d, $0c                                     ; $5097

jr_004_5099:
    ld a, [hl+]                                   ; $5099
    ld e, a                                       ; $509A
    add b                                         ; $509B
    ld b, a                                       ; $509C
    ld a, e                                       ; $509D
    xor c                                         ; $509E
    ld c, a                                       ; $509F
    dec d                                         ; $50A0
    jr nz, jr_004_5099                            ; $50A1

    ld a, b                                       ; $50A3
    add $0d                                       ; $50A4
    ld b, a                                       ; $50A6
    ld a, c                                       ; $50A7
    add $23                                       ; $50A8
    ld c, a                                       ; $50AA
    ld a, [hl+]                                   ; $50AB
    cp b                                          ; $50AC
    jr nz, jr_004_50be                            ; $50AD

    ldh [hScratchD], a                            ; $50AF
    ld a, [hl+]                                   ; $50B1
    cp c                                          ; $50B2
    jr nz, jr_004_50be                            ; $50B3

    ldh [hDiffOrValue], a                         ; $50B5
    ldh a, [hScratchA]                            ; $50B7
    and a                                         ; $50B9
    jr z, jr_004_5103                             ; $50BA

    jr jr_004_50c5                                ; $50BC

jr_004_50be:
    ldh a, [hScratchA]                            ; $50BE
    and a                                         ; $50C0
    jr z, jr_004_50e4                             ; $50C1

    jr jr_004_50e7                                ; $50C3

jr_004_50c5:
    ldh a, [hScratchB]                            ; $50C5
    ld b, a                                       ; $50C7
    ldh a, [hScratchD]                            ; $50C8
    cp b                                          ; $50CA
    jr nz, jr_004_50e4                            ; $50CB

    ldh a, [hScratchC]                            ; $50CD
    ld b, a                                       ; $50CF
    ldh a, [hDiffOrValue]                         ; $50D0
    cp b                                          ; $50D2
    jr nz, jr_004_50e4                            ; $50D3

    ld a, $02                                     ; $50D5
    ldh [hSram_Format_FF8C], a                    ; $50D7
    ld [rRAMB], a                                 ; $50D9
    ld hl, $aff2                                  ; $50DC
    call Cam_Calib_CopyFromSram                   ; $50DF
    xor a                                         ; $50E2
    ret                                           ; $50E3


jr_004_50e4:
    ld a, $ff                                     ; $50E4
    ret                                           ; $50E6


jr_004_50e7:
    ld a, $02                                     ; $50E7
    ldh [hSram_Format_FF8C], a                    ; $50E9
    ld [rRAMB], a                                 ; $50EB
    ld hl, $aff2                                  ; $50EE
    call Cam_Calib_CopyFromSram                   ; $50F1
    ld a, $08                                     ; $50F4
    ldh [hSram_Format_FF8C], a                    ; $50F6
    ld [rRAMB], a                                 ; $50F8
    ld hl, $bff2                                  ; $50FB
    call Cam_Calib_CopyToSram                     ; $50FE
    xor a                                         ; $5101
    ret                                           ; $5102


jr_004_5103:
    ld a, $08                                     ; $5103
    ldh [hSram_Format_FF8C], a                    ; $5105
    ld [rRAMB], a                                 ; $5107
    ld hl, $bff2                                  ; $510A
    call Cam_Calib_CopyFromSram                   ; $510D
    ld a, $02                                     ; $5110
    ldh [hSram_Format_FF8C], a                    ; $5112
    ld [rRAMB], a                                 ; $5114
    ld hl, $aff2                                  ; $5117
    call Cam_Calib_CopyToSram                     ; $511A
    xor a                                         ; $511D
    ret                                           ; $511E


; C: same code as the Japanese Cam_Calib_CopyFromSram (0A:46CF, 18 bytes, masked match)
Cam_Calib_CopyFromSram::
    ld de, wCamCalibVector                        ; $511F
    ld b, $0c                                     ; $5122

jr_004_5124:
    ld a, [hl+]                                   ; $5124
    ld [de], a                                    ; $5125
    inc de                                        ; $5126
    dec b                                         ; $5127
    jr nz, jr_004_5124                            ; $5128

    ld a, [hl+]                                   ; $512A
    ldh [hScratchB], a                            ; $512B
    ld a, [hl+]                                   ; $512D
    ldh [hScratchC], a                            ; $512E
    ret                                           ; $5130


; C: same code as the Japanese Cam_Calib_CopyToSram (0A:46E1, 28 bytes, masked match)
Cam_Calib_CopyToSram::
    ld a, $0a                                     ; $5131
    ld [rRAMG], a                                 ; $5133
    ld de, wCamCalibVector                        ; $5136
    ld b, $0c                                     ; $5139

jr_004_513b:
    ld a, [de]                                    ; $513B
    ld [hl+], a                                   ; $513C
    inc de                                        ; $513D
    dec b                                         ; $513E
    jr nz, jr_004_513b                            ; $513F

    ldh a, [hScratchB]                            ; $5141
    ld [hl+], a                                   ; $5143
    ldh a, [hScratchC]                            ; $5144
    ld [hl], a                                    ; $5146
    ld a, $00                                     ; $5147
    ld [rRAMG], a                                 ; $5149
    ret                                           ; $514C


; C: boot measurement: first looks for 12 bytes of $AA at $AFF2 of SRAM banks 2 and 8 (returns $FF without measuring
; when both are there), else the measurement sequence of the Japanese Cam_Calib_BootMeasureSeq (0A:4724) with
; Cam_ExposureBandSelect; code read
Cam_Calib_BootMeasureSeq::
    ld a, $02                                     ; $514D
    ldh [hSram_Format_FF8C], a                    ; $514F
    ld [rRAMB], a                                 ; $5151
    ld hl, $aff2                                  ; $5154
    ld b, $aa                                     ; $5157
    ld c, $0c                                     ; $5159

jr_004_515b:
    ld a, [hl+]                                   ; $515B
    cp b                                          ; $515C
    jr nz, jr_004_5178                            ; $515D

    dec c                                         ; $515F
    jr nz, jr_004_515b                            ; $5160

    ld a, $08                                     ; $5162
    ldh [hSram_Format_FF8C], a                    ; $5164
    ld [rRAMB], a                                 ; $5166
    ld hl, $bff2                                  ; $5169
    ld c, $0c                                     ; $516C

jr_004_516e:
    ld a, [hl+]                                   ; $516E
    cp b                                          ; $516F
    jr nz, jr_004_5178                            ; $5170

    dec c                                         ; $5172
    jr nz, jr_004_516e                            ; $5173

    ld a, $ff                                     ; $5175
    ret                                           ; $5177


jr_004_5178:
    ld a, $a0                                     ; $5178
    ldh [hScratchC], a                            ; $517A
    ld a, $02                                     ; $517C
    ldh [hScratchD], a                            ; $517E
    call Cam_ExposureBandSelect                   ; $5180
    ld a, $10                                     ; $5183
    ldh [hSram_Format_FF8C], a                    ; $5185
    ld [rRAMB], a                                 ; $5187
    ld a, [wCamBootMatrixRef]                     ; $518A
    ld b, a                                       ; $518D
    ld hl, $a006                                  ; $518E
    ld de, $0030                                  ; $5191

jr_004_5194:
    ld [hl], b                                    ; $5194
    inc hl                                        ; $5195
    dec de                                        ; $5196
    ld a, d                                       ; $5197
    or e                                          ; $5198
    jr nz, jr_004_5194                            ; $5199

    ld a, $02                                     ; $519B
    ld [wCamA000Shadow], a                        ; $519D
    ld a, [wCamGainCommitted]                     ; $51A0
    or $20                                        ; $51A3
    ld [$a001], a                                 ; $51A5
    ld [wCamA001Shadow], a                        ; $51A8
    xor a                                         ; $51AB
    ld [$a002], a                                 ; $51AC
    ld [wCamExposureShadow], a                    ; $51AF
    ld a, $10                                     ; $51B2
    ld [$a003], a                                 ; $51B4
    ld [wCamExposureShadow + $1], a               ; $51B7
    ld a, $03                                     ; $51BA
    ld [$a004], a                                 ; $51BC
    ld [wCamA004Shadow], a                        ; $51BF
    call Cam_ORegister_SAR_Search                 ; $51C2
    ld a, [wCamA004Shadow]                        ; $51C5
    and $07                                       ; $51C8
    ld [wCamBootV], a                             ; $51CA
    ld a, [wCamA005Shadow]                        ; $51CD
    res 7, a                                      ; $51D0
    ld [wCamBootO], a                             ; $51D2
    ld a, [wCamBootMatrixRef + $1]                ; $51D5
    ld b, a                                       ; $51D8
    ld hl, $a006                                  ; $51D9
    ld de, $0030                                  ; $51DC

jr_004_51df:
    ld [hl], b                                    ; $51DF
    inc hl                                        ; $51E0
    dec de                                        ; $51E1
    ld a, d                                       ; $51E2
    or e                                          ; $51E3
    jr nz, jr_004_51df                            ; $51E4

    ld a, [wCamGainCommitted]                     ; $51E6
    or $20                                        ; $51E9
    ld [$a001], a                                 ; $51EB
    ld [wCamA001Shadow], a                        ; $51EE
    ld a, $23                                     ; $51F1
    ld [$a004], a                                 ; $51F3
    ld [wCamA004Shadow], a                        ; $51F6
    call Cam_ORegister_SAR_Search                 ; $51F9
    ld a, [wCamA004Shadow]                        ; $51FC
    and $07                                       ; $51FF
    ld [wCamBootV + $1], a                        ; $5201
    ld a, [wCamA005Shadow]                        ; $5204
    res 7, a                                      ; $5207
    ld [wCamBootO + $1], a                        ; $5209
    ld a, [wCamBootMatrixRef + $2]                ; $520C
    ld b, a                                       ; $520F
    ld hl, $a006                                  ; $5210
    ld de, $0030                                  ; $5213

jr_004_5216:
    ld [hl], b                                    ; $5216
    inc hl                                        ; $5217
    dec de                                        ; $5218
    ld a, d                                       ; $5219
    or e                                          ; $521A
    jr nz, jr_004_5216                            ; $521B

    ld a, [wCamGainAlt]                           ; $521D
    or $20                                        ; $5220
    ld [$a001], a                                 ; $5222
    ld [wCamA001Shadow], a                        ; $5225
    ld a, $23                                     ; $5228
    ld [$a004], a                                 ; $522A
    ld [wCamA004Shadow], a                        ; $522D
    call Cam_ORegister_SAR_Search                 ; $5230
    ld a, [wCamA004Shadow]                        ; $5233
    and $07                                       ; $5236
    ld [wCamBootV + $2], a                        ; $5238
    ld a, [wCamA005Shadow]                        ; $523B
    res 7, a                                      ; $523E
    ld [wCamBootO + $2], a                        ; $5240
    ld a, [wCamCalibVector + $a]                  ; $5243
    ld b, a                                       ; $5246
    ld hl, $a006                                  ; $5247
    ld de, $0030                                  ; $524A

jr_004_524d:
    ld [hl], b                                    ; $524D
    inc hl                                        ; $524E
    dec de                                        ; $524F
    ld a, d                                       ; $5250
    or e                                          ; $5251
    jr nz, jr_004_524d                            ; $5252

    ld a, $08                                     ; $5254
    or $20                                        ; $5256
    ld [$a001], a                                 ; $5258
    ld [wCamA001Shadow], a                        ; $525B
    ld a, $23                                     ; $525E
    ld [$a004], a                                 ; $5260
    ld [wCamA004Shadow], a                        ; $5263
    call Cam_ORegister_SAR_Search                 ; $5266
    ld a, [wCamA004Shadow]                        ; $5269
    and $07                                       ; $526C
    ld [wCamBootV + $3], a                        ; $526E
    ld a, [wCamA005Shadow]                        ; $5271
    res 7, a                                      ; $5274
    ld [wCamBootO + $3], a                        ; $5276
    ld a, [wCamCalibVector + $b]                  ; $5279
    ld b, a                                       ; $527C
    ld hl, $a006                                  ; $527D
    ld de, $0030                                  ; $5280

jr_004_5283:
    ld [hl], b                                    ; $5283
    inc hl                                        ; $5284
    dec de                                        ; $5285
    ld a, d                                       ; $5286
    or e                                          ; $5287
    jr nz, jr_004_5283                            ; $5288

    ld a, $0a                                     ; $528A
    ld [$a001], a                                 ; $528C
    ld [wCamA001Shadow], a                        ; $528F
    ld a, $03                                     ; $5292
    ld [$a004], a                                 ; $5294
    ld [wCamA004Shadow], a                        ; $5297
    call Cam_ORegister_SAR_Search                 ; $529A
    ld a, [wCamA004Shadow]                        ; $529D
    and $07                                       ; $52A0
    ld [wCamBootV + $4], a                        ; $52A2
    ld a, [wCamA005Shadow]                        ; $52A5
    res 7, a                                      ; $52A8
    ld [wCamBootO + $4], a                        ; $52AA
    xor a                                         ; $52AD
    ret                                           ; $52AE


; C: the Japanese Cam_ExposureBandSelect (0A:4859), 72 instructions against 70, with 2 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Cam_ExposureBandSelect::
    ld a, $10                                     ; $52AF
    ldh [hSram_Format_FF8C], a                    ; $52B1
    ld [rRAMB], a                                 ; $52B3
    xor a                                         ; $52B6
    ld [wCamGainSel], a                           ; $52B7

jr_004_52ba:
    ld a, $02                                     ; $52BA
    ld [wCamA000Shadow], a                        ; $52BC
    ld a, [wCamGainSel]                           ; $52BF
    ld [$a001], a                                 ; $52C2
    xor a                                         ; $52C5
    ld [$a002], a                                 ; $52C6
    ld a, $10                                     ; $52C9
    ld [$a003], a                                 ; $52CB
    ld a, $05                                     ; $52CE
    ld [$a004], a                                 ; $52D0
    ld a, $80                                     ; $52D3
    ld [$a005], a                                 ; $52D5
    ld [wCamA005Shadow], a                        ; $52D8
    ld b, $d5                                     ; $52DB
    ld hl, $a006                                  ; $52DD
    ld de, $0030                                  ; $52E0

jr_004_52e3:
    ld [hl], b                                    ; $52E3
    inc hl                                        ; $52E4
    dec de                                        ; $52E5
    ld a, d                                       ; $52E6
    or e                                          ; $52E7
    jr nz, jr_004_52e3                            ; $52E8

    call Cam_ORegister_SAR_Search                 ; $52EA
    ld a, [wCamA005Shadow]                        ; $52ED
    res 7, a                                      ; $52F0
    ld [$a005], a                                 ; $52F2
    ld [wCamA005Shadow], a                        ; $52F5
    ld b, $80                                     ; $52F8
    ld hl, $a006                                  ; $52FA
    ld de, $0030                                  ; $52FD

jr_004_5300:
    ld [hl], b                                    ; $5300
    inc hl                                        ; $5301
    dec de                                        ; $5302
    ld a, d                                       ; $5303
    or e                                          ; $5304
    jr nz, jr_004_5300                            ; $5305

    ld a, $10                                     ; $5307
    ldh [hSram_Format_FF8C], a                    ; $5309
    ld [rRAMB], a                                 ; $530B
    ld a, [wCamA000Shadow]                        ; $530E
    set 0, a                                      ; $5311
    ld [$a000], a                                 ; $5313

jr_004_5316:
    ld a, [$a000]                                 ; $5316
    bit 0, a                                      ; $5319
    jr nz, jr_004_5316                            ; $531B

    ld a, $09                                     ; $531D
    call Cam_CountBrightSamples                   ; $531F
    or a                                          ; $5322
    jr nz, jr_004_5330                            ; $5323

    ld a, [wCamGainSel]                           ; $5325
    inc a                                         ; $5328
    ld [wCamGainSel], a                           ; $5329
    cp $03                                        ; $532C
    jr nz, jr_004_52ba                            ; $532E

jr_004_5330:
    ld a, [wCamGainSel]                           ; $5330
    ld [wCamGainCommitted], a                     ; $5333
    or a                                          ; $5336
    jr nz, jr_004_5351                            ; $5337

    ld a, $04                                     ; $5339
    ld [wCamGainAlt], a                           ; $533B
    ld a, [wCamCalibVector]                       ; $533E
    ld [wCamBootMatrixRef], a                     ; $5341
    ld a, [wCamCalibVector + $4]                  ; $5344
    ld [wCamBootMatrixRef + $1], a                ; $5347
    ld a, [wCamCalibVector + $8]                  ; $534A
    ld [wCamBootMatrixRef + $2], a                ; $534D
    ret                                           ; $5350


jr_004_5351:
    cp $01                                        ; $5351
    jr nz, jr_004_536d                            ; $5353

    ld a, $04                                     ; $5355
    ld [wCamGainAlt], a                           ; $5357
    ld a, [wCamCalibVector + $1]                  ; $535A
    ld [wCamBootMatrixRef], a                     ; $535D
    ld a, [wCamCalibVector + $5]                  ; $5360
    ld [wCamBootMatrixRef + $1], a                ; $5363
    ld a, [wCamCalibVector + $8]                  ; $5366
    ld [wCamBootMatrixRef + $2], a                ; $5369
    ret                                           ; $536C


jr_004_536d:
    cp $02                                        ; $536D
    jr nz, jr_004_5389                            ; $536F

    ld a, $05                                     ; $5371
    ld [wCamGainAlt], a                           ; $5373
    ld a, [wCamCalibVector + $2]                  ; $5376
    ld [wCamBootMatrixRef], a                     ; $5379
    ld a, [wCamCalibVector + $6]                  ; $537C
    ld [wCamBootMatrixRef + $1], a                ; $537F
    ld a, [wCamCalibVector + $9]                  ; $5382
    ld [wCamBootMatrixRef + $2], a                ; $5385
    ret                                           ; $5388


jr_004_5389:
    ld a, $05                                     ; $5389
    ld [wCamGainAlt], a                           ; $538B
    ld a, [wCamCalibVector + $3]                  ; $538E
    ld [wCamBootMatrixRef], a                     ; $5391
    ld a, [wCamCalibVector + $7]                  ; $5394
    ld [wCamBootMatrixRef + $1], a                ; $5397
    ld a, [wCamCalibVector + $9]                  ; $539A
    ld [wCamBootMatrixRef + $2], a                ; $539D
    ret                                           ; $53A0


; C: same code as the Japanese Cam_FullCalibration (0A:4947, 26 bytes, masked match)
Cam_FullCalibration::
    ld a, $a0                                     ; $53A1
    ldh [hScratchC], a                            ; $53A3
    ld a, $82                                     ; $53A5
    ldh [hScratchD], a                            ; $53A7
    call Cam_FactoryMeasure1                      ; $53A9
    ld a, $a0                                     ; $53AC
    ldh [hScratchC], a                            ; $53AE
    ld a, $02                                     ; $53B0
    ldh [hScratchD], a                            ; $53B2
    call Cam_FactoryMeasure2                      ; $53B4
    call Cam_CommitVectorToSRAM                   ; $53B7
    ret                                           ; $53BA


; C: the Japanese Cam_FactoryMeasure1 (0A:4961), 201 instructions against 200, with 1 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Cam_FactoryMeasure1::
    ld a, $10                                     ; $53BB
    ldh [hSram_Format_FF8C], a                    ; $53BD
    ld [rRAMB], a                                 ; $53BF
    ld b, $80                                     ; $53C2
    ld hl, $a006                                  ; $53C4
    ld de, $0030                                  ; $53C7

jr_004_53ca:
    ld [hl], b                                    ; $53CA
    inc hl                                        ; $53CB
    dec de                                        ; $53CC
    ld a, d                                       ; $53CD
    or e                                          ; $53CE
    jr nz, jr_004_53ca                            ; $53CF

    ld a, $02                                     ; $53D1
    ld [wCamA000Shadow], a                        ; $53D3
    ld a, $20                                     ; $53D6
    ld [$a001], a                                 ; $53D8
    ld [wCamA001Shadow], a                        ; $53DB
    xor a                                         ; $53DE
    ld [$a002], a                                 ; $53DF
    ld [wCamExposureShadow], a                    ; $53E2
    ld a, $30                                     ; $53E5
    ld [$a003], a                                 ; $53E7
    ld [wCamExposureShadow + $1], a               ; $53EA
    ld a, $03                                     ; $53ED
    ld [$a004], a                                 ; $53EF
    ld [wCamA004Shadow], a                        ; $53F2
    call Cam_ORegister_SAR_Search                 ; $53F5
    ld a, [wCamA004Shadow]                        ; $53F8
    and $07                                       ; $53FB
    ld [wCamFactoryVo], a                         ; $53FD
    ld a, [wCamA005Shadow]                        ; $5400
    res 7, a                                      ; $5403
    ld [wCamFactoryVo + $c], a                    ; $5405
    ld a, $21                                     ; $5408
    ld [$a001], a                                 ; $540A
    ld [wCamA001Shadow], a                        ; $540D
    ld a, $03                                     ; $5410
    ld [$a004], a                                 ; $5412
    ld [wCamA004Shadow], a                        ; $5415
    call Cam_ORegister_SAR_Search                 ; $5418
    ld a, [wCamA004Shadow]                        ; $541B
    and $07                                       ; $541E
    ld [wCamFactoryVo + $1], a                    ; $5420
    ld a, [wCamA005Shadow]                        ; $5423
    res 7, a                                      ; $5426
    ld [wCamFactoryVo + $d], a                    ; $5428
    ld a, $22                                     ; $542B
    ld [$a001], a                                 ; $542D
    ld [wCamA001Shadow], a                        ; $5430
    ld a, $03                                     ; $5433
    ld [$a004], a                                 ; $5435
    ld [wCamA004Shadow], a                        ; $5438
    call Cam_ORegister_SAR_Search                 ; $543B
    ld a, [wCamA004Shadow]                        ; $543E
    and $07                                       ; $5441
    ld [wCamFactoryVo + $2], a                    ; $5443
    ld a, [wCamA005Shadow]                        ; $5446
    res 7, a                                      ; $5449
    ld [wCamFactoryVo + $e], a                    ; $544B
    ld a, $23                                     ; $544E
    ld [$a001], a                                 ; $5450
    ld [wCamA001Shadow], a                        ; $5453
    ld a, $03                                     ; $5456
    ld [$a004], a                                 ; $5458
    ld [wCamA004Shadow], a                        ; $545B
    call Cam_ORegister_SAR_Search                 ; $545E
    ld a, [wCamA004Shadow]                        ; $5461
    and $07                                       ; $5464
    ld [wCamFactoryVo + $3], a                    ; $5466
    ld a, [wCamA005Shadow]                        ; $5469
    res 7, a                                      ; $546C
    ld [wCamFactoryVo + $f], a                    ; $546E
    ld a, $e0                                     ; $5471
    ld [$a001], a                                 ; $5473
    ld [wCamA001Shadow], a                        ; $5476
    ld a, $09                                     ; $5479
    ld [$a002], a                                 ; $547B
    ld [wCamExposureShadow], a                    ; $547E
    xor a                                         ; $5481
    ld [$a003], a                                 ; $5482
    ld [wCamExposureShadow + $1], a               ; $5485
    ld a, $03                                     ; $5488
    ld [$a004], a                                 ; $548A
    ld [wCamA004Shadow], a                        ; $548D
    call Cam_ORegister_SAR_Search                 ; $5490
    ld a, [wCamA004Shadow]                        ; $5493
    and $07                                       ; $5496
    ld [wCamFactoryVo + $4], a                    ; $5498
    ld a, [wCamA005Shadow]                        ; $549B
    res 7, a                                      ; $549E
    ld [wCamFactoryVo + $10], a                   ; $54A0
    ld a, $e1                                     ; $54A3
    ld [$a001], a                                 ; $54A5
    ld [wCamA001Shadow], a                        ; $54A8
    ld a, $03                                     ; $54AB
    ld [$a004], a                                 ; $54AD
    ld [wCamA004Shadow], a                        ; $54B0
    call Cam_ORegister_SAR_Search                 ; $54B3
    ld a, [wCamA004Shadow]                        ; $54B6
    and $07                                       ; $54B9
    ld [wCamFactoryVo + $5], a                    ; $54BB
    ld a, [wCamA005Shadow]                        ; $54BE
    res 7, a                                      ; $54C1
    ld [wCamFactoryVo + $11], a                   ; $54C3
    ld a, $e2                                     ; $54C6
    ld [$a001], a                                 ; $54C8
    ld [wCamA001Shadow], a                        ; $54CB
    ld a, $03                                     ; $54CE
    ld [$a004], a                                 ; $54D0
    ld [wCamA004Shadow], a                        ; $54D3
    call Cam_ORegister_SAR_Search                 ; $54D6
    ld a, [wCamA004Shadow]                        ; $54D9
    and $07                                       ; $54DC
    ld [wCamFactoryVo + $6], a                    ; $54DE
    ld a, [wCamA005Shadow]                        ; $54E1
    res 7, a                                      ; $54E4
    ld [wCamFactoryVo + $12], a                   ; $54E6
    ld a, $e3                                     ; $54E9
    ld [$a001], a                                 ; $54EB
    ld [wCamA001Shadow], a                        ; $54EE
    ld a, $03                                     ; $54F1
    ld [$a004], a                                 ; $54F3
    ld [wCamA004Shadow], a                        ; $54F6
    call Cam_ORegister_SAR_Search                 ; $54F9
    ld a, [wCamA004Shadow]                        ; $54FC
    and $07                                       ; $54FF
    ld [wCamFactoryVo + $7], a                    ; $5501
    ld a, [wCamA005Shadow]                        ; $5504
    res 7, a                                      ; $5507
    ld [wCamFactoryVo + $13], a                   ; $5509
    ld a, $e4                                     ; $550C
    ld [$a001], a                                 ; $550E
    ld [wCamA001Shadow], a                        ; $5511
    ld a, $20                                     ; $5514
    ld [$a002], a                                 ; $5516
    ld [wCamExposureShadow], a                    ; $5519
    xor a                                         ; $551C
    ld [$a003], a                                 ; $551D
    ld [wCamExposureShadow + $1], a               ; $5520
    ld a, $03                                     ; $5523
    ld [$a004], a                                 ; $5525
    ld [wCamA004Shadow], a                        ; $5528
    call Cam_ORegister_SAR_Search                 ; $552B
    ld a, [wCamA004Shadow]                        ; $552E
    and $07                                       ; $5531
    ld [wCamFactoryVo + $8], a                    ; $5533
    ld a, [wCamA005Shadow]                        ; $5536
    res 7, a                                      ; $5539
    ld [wCamFactoryVo + $14], a                   ; $553B
    ld a, $e5                                     ; $553E
    ld [$a001], a                                 ; $5540
    ld [wCamA001Shadow], a                        ; $5543
    ld a, $03                                     ; $5546
    ld [$a004], a                                 ; $5548
    ld [wCamA004Shadow], a                        ; $554B
    call Cam_ORegister_SAR_Search                 ; $554E
    ld a, [wCamA004Shadow]                        ; $5551
    and $07                                       ; $5554
    ld [wCamFactoryVo + $9], a                    ; $5556
    ld a, [wCamA005Shadow]                        ; $5559
    res 7, a                                      ; $555C
    ld [wCamFactoryVo + $15], a                   ; $555E
    ld a, $e8                                     ; $5561
    ld [$a001], a                                 ; $5563
    ld [wCamA001Shadow], a                        ; $5566
    ld a, $32                                     ; $5569
    ld [$a002], a                                 ; $556B
    ld [wCamExposureShadow], a                    ; $556E
    xor a                                         ; $5571
    ld [$a003], a                                 ; $5572
    ld [wCamExposureShadow + $1], a               ; $5575
    ld a, $03                                     ; $5578
    ld [$a004], a                                 ; $557A
    ld [wCamA004Shadow], a                        ; $557D
    call Cam_ORegister_SAR_Search                 ; $5580
    ld a, [wCamA004Shadow]                        ; $5583
    and $07                                       ; $5586
    ld [wCamFactoryVo + $a], a                    ; $5588
    ld a, [wCamA005Shadow]                        ; $558B
    res 7, a                                      ; $558E
    ld [wCamFactoryVo + $16], a                   ; $5590
    ld a, $0a                                     ; $5593
    ld [$a001], a                                 ; $5595
    ld [wCamA001Shadow], a                        ; $5598
    ld a, $80                                     ; $559B
    ld [$a002], a                                 ; $559D
    ld [wCamExposureShadow], a                    ; $55A0
    xor a                                         ; $55A3
    ld [$a003], a                                 ; $55A4
    ld [wCamExposureShadow + $1], a               ; $55A7
    ld a, $03                                     ; $55AA
    ld [$a004], a                                 ; $55AC
    ld [wCamA004Shadow], a                        ; $55AF
    call Cam_ORegister_SAR_Search                 ; $55B2
    ld a, [wCamA004Shadow]                        ; $55B5
    and $07                                       ; $55B8
    ld [wCamFactoryVo + $b], a                    ; $55BA
    ld a, [wCamA005Shadow]                        ; $55BD
    res 7, a                                      ; $55C0
    ld [wCamFactoryVo + $17], a                   ; $55C2
    ret                                           ; $55C5


; C: near copy of the Japanese Cam_ORegister_SAR_Search (0A:4B6A, instruction-sequence ratio 0.81); code read; runs at
; boot (the camera checks)
Cam_ORegister_SAR_Search::
    ld a, $10                                     ; $55C6
    ldh [hSram_Format_FF8C], a                    ; $55C8
    ld [rRAMB], a                                 ; $55CA
    xor a                                         ; $55CD
    ldh [hCam_ORegister_SAR_Search_FFBB], a       ; $55CE
    ld a, $bf                                     ; $55D0
    ld [wCamA005Shadow], a                        ; $55D2
    ld [$a005], a                                 ; $55D5

jr_004_55d8:
    ld a, [wCamA000Shadow]                        ; $55D8
    set 0, a                                      ; $55DB
    ld [$a000], a                                 ; $55DD

jr_004_55e0:
    ld a, [$a000]                                 ; $55E0
    bit 0, a                                      ; $55E3
    jr nz, jr_004_55e0                            ; $55E5

    ld a, $09                                     ; $55E7
    call Cam_CountBrightSamples                   ; $55E9
    or a                                          ; $55EC
    jr z, jr_004_560d                             ; $55ED

    ld a, $ff                                     ; $55EF
    ldh [hCam_ORegister_SAR_Search_FFBB], a       ; $55F1
    ld a, [wCamA004Shadow]                        ; $55F3
    ld b, a                                       ; $55F6
    and $07                                       ; $55F7
    inc a                                         ; $55F9
    ld c, a                                       ; $55FA
    ld a, b                                       ; $55FB
    and $f8                                       ; $55FC
    or c                                          ; $55FE
    ld [$a004], a                                 ; $55FF
    ld [wCamA004Shadow], a                        ; $5602
    and $07                                       ; $5605
    cp $07                                        ; $5607
    jr z, Cam_ORegister_SAR_Tail                  ; $5609

    jr jr_004_55d8                                ; $560B

jr_004_560d:
    ldh a, [hCam_ORegister_SAR_Search_FFBB]       ; $560D
    cp $ff                                        ; $560F
    jr z, Cam_ORegister_SAR_Tail                  ; $5611

    ld a, $9f                                     ; $5613
    ld [wCamA005Shadow], a                        ; $5615
    ld [$a005], a                                 ; $5618

jr_004_561b:
    ld a, [wCamA000Shadow]                        ; $561B
    set 0, a                                      ; $561E
    ld [$a000], a                                 ; $5620

jr_004_5623:
    ld a, [$a000]                                 ; $5623
    bit 0, a                                      ; $5626
    jr nz, jr_004_5623                            ; $5628

    ld a, $09                                     ; $562A
    call Cam_CountBrightSamples                   ; $562C
    or a                                          ; $562F
    jr nz, Cam_ORegister_SAR_Tail                 ; $5630

    ld a, [wCamA004Shadow]                        ; $5632
    ld b, a                                       ; $5635
    and $07                                       ; $5636
    dec a                                         ; $5638
    ld c, a                                       ; $5639
    ld a, b                                       ; $563A
    and $f8                                       ; $563B
    or c                                          ; $563D
    ld [$a004], a                                 ; $563E
    ld [wCamA004Shadow], a                        ; $5641
    and $07                                       ; $5644
    cp $01                                        ; $5646
    jr nz, jr_004_561b                            ; $5648

; C: same code as the Japanese Cam_ORegister_SAR_Tail (0A:4BEC, 68 bytes, masked match)
Cam_ORegister_SAR_Tail::
    ld a, $a0                                     ; $564A
    ld [wCamA005Shadow], a                        ; $564C
    ld [$a005], a                                 ; $564F
    ld a, $06                                     ; $5652
    ldh [hScratchB], a                            ; $5654

jr_004_5656:
    ld a, [wCamA000Shadow]                        ; $5656
    set 0, a                                      ; $5659
    ld [$a000], a                                 ; $565B

jr_004_565e:
    ld a, [$a000]                                 ; $565E
    bit 0, a                                      ; $5661
    jr nz, jr_004_565e                            ; $5663

    ld a, $09                                     ; $5665
    call Cam_CountBrightSamples                   ; $5667
    or a                                          ; $566A
    jr z, jr_004_5672                             ; $566B

    ld hl, Cam_ORegSAR_Table_Above                ; $566D
    jr jr_004_5675                                ; $5670

jr_004_5672:
    ld hl, Cam_ORegSAR_Table_Below                ; $5672

jr_004_5675:
    ld a, [wCamA005Shadow]                        ; $5675
    and $3f                                       ; $5678
    add l                                         ; $567A
    ld l, a                                       ; $567B
    jr nc, jr_004_567f                            ; $567C

    inc h                                         ; $567E

jr_004_567f:
    ld a, [hl]                                    ; $567F
    ld [wCamA005Shadow], a                        ; $5680
    ld [$a005], a                                 ; $5683
    ldh a, [hScratchB]                            ; $5686
    dec a                                         ; $5688
    ldh [hScratchB], a                            ; $5689
    jr nz, jr_004_5656                            ; $568B

    ret                                           ; $568D


; C: SRAM bank 0: counts the bits 6-3 set over the samples at [hFFB5-hFFB6]; code read; runs at boot (the camera
; checks)
Cam_CountBrightSamples::
    ld h, a                                       ; $568E
    ld a, $00                                     ; $568F
    ldh [hSram_Format_FF8C], a                    ; $5691
    ld [rRAMB], a                                 ; $5693
    ldh a, [hScratchC]                            ; $5696
    ld d, a                                       ; $5698
    ldh a, [hScratchD]                            ; $5699
    ld e, a                                       ; $569B
    ld b, $00                                     ; $569C
    ld c, $04                                     ; $569E

jr_004_56a0:
    ld a, [de]                                    ; $56A0
    bit 6, a                                      ; $56A1
    jr z, jr_004_56a6                             ; $56A3

    inc b                                         ; $56A5

jr_004_56a6:
    bit 5, a                                      ; $56A6
    jr z, jr_004_56ab                             ; $56A8

    inc b                                         ; $56AA

jr_004_56ab:
    bit 4, a                                      ; $56AB
    jr z, jr_004_56b0                             ; $56AD

    inc b                                         ; $56AF

jr_004_56b0:
    bit 3, a                                      ; $56B0
    jr jr_004_56b5                                ; $56B2

    db $04

jr_004_56b5:
    inc de                                        ; $56B5
    inc de                                        ; $56B6
    dec c                                         ; $56B7
    jr nz, jr_004_56a0                            ; $56B8

    ld a, b                                       ; $56BA
    sub h                                         ; $56BB
    jr c, jr_004_56c8                             ; $56BC

    ld a, $10                                     ; $56BE
    ldh [hSram_Format_FF8C], a                    ; $56C0
    ld [rRAMB], a                                 ; $56C2
    ld a, $01                                     ; $56C5
    ret                                           ; $56C7


jr_004_56c8:
    ld a, $10                                     ; $56C8
    ldh [hSram_Format_FF8C], a                    ; $56CA
    ld [rRAMB], a                                 ; $56CC
    xor a                                         ; $56CF
    ret                                           ; $56D0


; C: the Japanese Cam_FactoryMeasure2 (0A:4C6C), 175 instructions against 174, with 1 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Cam_FactoryMeasure2::
    ld a, $10                                     ; $56D1
    ldh [hSram_Format_FF8C], a                    ; $56D3
    ld [rRAMB], a                                 ; $56D5
    ld a, $02                                     ; $56D8
    ld [wCamA000Shadow], a                        ; $56DA
    ld a, $20                                     ; $56DD
    ld [$a001], a                                 ; $56DF
    ld [wCamA001Shadow], a                        ; $56E2
    xor a                                         ; $56E5
    ld [$a002], a                                 ; $56E6
    ld [wCamExposureShadow], a                    ; $56E9
    ld a, $10                                     ; $56EC
    ld [$a003], a                                 ; $56EE
    ld [wCamExposureShadow + $1], a               ; $56F1
    ld a, [wCamFactoryVo]                         ; $56F4
    ld [$a004], a                                 ; $56F7
    ld [wCamA004Shadow], a                        ; $56FA
    ld a, [wCamFactoryVo + $c]                    ; $56FD
    set 7, a                                      ; $5700
    ld [$a005], a                                 ; $5702
    ld [wCamA005Shadow], a                        ; $5705
    call Cam_ThresholdConverge                    ; $5708
    ldh a, [hDiffOrValue]                         ; $570B
    ld [wCamCalibVector], a                       ; $570D
    ld a, $21                                     ; $5710
    ld [$a001], a                                 ; $5712
    ld [wCamA001Shadow], a                        ; $5715
    ld a, [wCamFactoryVo + $1]                    ; $5718
    ld [$a004], a                                 ; $571B
    ld [wCamA004Shadow], a                        ; $571E
    ld a, [wCamFactoryVo + $d]                    ; $5721
    set 7, a                                      ; $5724
    ld [$a005], a                                 ; $5726
    ld [wCamA005Shadow], a                        ; $5729
    call Cam_ThresholdConverge                    ; $572C
    ldh a, [hDiffOrValue]                         ; $572F
    ld [wCamCalibVector + $1], a                  ; $5731
    ld a, $22                                     ; $5734
    ld [$a001], a                                 ; $5736
    ld [wCamA001Shadow], a                        ; $5739
    ld a, [wCamFactoryVo + $2]                    ; $573C
    ld [$a004], a                                 ; $573F
    ld [wCamA004Shadow], a                        ; $5742
    ld a, [wCamFactoryVo + $e]                    ; $5745
    set 7, a                                      ; $5748
    ld [$a005], a                                 ; $574A
    ld [wCamA005Shadow], a                        ; $574D
    call Cam_ThresholdConverge                    ; $5750
    ldh a, [hDiffOrValue]                         ; $5753
    ld [wCamCalibVector + $2], a                  ; $5755
    ld a, $23                                     ; $5758
    ld [$a001], a                                 ; $575A
    ld [wCamA001Shadow], a                        ; $575D
    ld a, [wCamFactoryVo + $3]                    ; $5760
    ld [$a004], a                                 ; $5763
    ld [wCamA004Shadow], a                        ; $5766
    ld a, [wCamFactoryVo + $f]                    ; $5769
    set 7, a                                      ; $576C
    ld [$a005], a                                 ; $576E
    ld [wCamA005Shadow], a                        ; $5771
    call Cam_ThresholdConverge                    ; $5774
    ldh a, [hDiffOrValue]                         ; $5777
    ld [wCamCalibVector + $3], a                  ; $5779
    ld a, $20                                     ; $577C
    ld [$a001], a                                 ; $577E
    ld [wCamA001Shadow], a                        ; $5781
    ld a, [wCamFactoryVo + $4]                    ; $5784
    or $20                                        ; $5787
    ld [$a004], a                                 ; $5789
    ld [wCamA004Shadow], a                        ; $578C
    ld a, [wCamFactoryVo + $10]                   ; $578F
    set 7, a                                      ; $5792
    ld [$a005], a                                 ; $5794
    ld [wCamA005Shadow], a                        ; $5797
    call Cam_ThresholdConverge                    ; $579A
    ldh a, [hDiffOrValue]                         ; $579D
    ld [wCamCalibVector + $4], a                  ; $579F
    ld a, $21                                     ; $57A2
    ld [$a001], a                                 ; $57A4
    ld [wCamA001Shadow], a                        ; $57A7
    ld a, [wCamFactoryVo + $5]                    ; $57AA
    or $20                                        ; $57AD
    ld [$a004], a                                 ; $57AF
    ld [wCamA004Shadow], a                        ; $57B2
    ld a, [wCamFactoryVo + $11]                   ; $57B5
    set 7, a                                      ; $57B8
    ld [$a005], a                                 ; $57BA
    ld [wCamA005Shadow], a                        ; $57BD
    call Cam_ThresholdConverge                    ; $57C0
    ldh a, [hDiffOrValue]                         ; $57C3
    ld [wCamCalibVector + $5], a                  ; $57C5
    ld a, $22                                     ; $57C8
    ld [$a001], a                                 ; $57CA
    ld [wCamA001Shadow], a                        ; $57CD
    ld a, [wCamFactoryVo + $6]                    ; $57D0
    or $20                                        ; $57D3
    ld [$a004], a                                 ; $57D5
    ld [wCamA004Shadow], a                        ; $57D8
    ld a, [wCamFactoryVo + $12]                   ; $57DB
    set 7, a                                      ; $57DE
    ld [$a005], a                                 ; $57E0
    ld [wCamA005Shadow], a                        ; $57E3
    call Cam_ThresholdConverge                    ; $57E6
    ldh a, [hDiffOrValue]                         ; $57E9
    ld [wCamCalibVector + $6], a                  ; $57EB
    ld a, $23                                     ; $57EE
    ld [$a001], a                                 ; $57F0
    ld [wCamA001Shadow], a                        ; $57F3
    ld a, [wCamFactoryVo + $7]                    ; $57F6
    or $20                                        ; $57F9
    ld [$a004], a                                 ; $57FB
    ld [wCamA004Shadow], a                        ; $57FE
    ld a, [wCamFactoryVo + $13]                   ; $5801
    set 7, a                                      ; $5804
    ld [$a005], a                                 ; $5806
    ld [wCamA005Shadow], a                        ; $5809
    call Cam_ThresholdConverge                    ; $580C
    ldh a, [hDiffOrValue]                         ; $580F
    ld [wCamCalibVector + $7], a                  ; $5811
    ld a, $24                                     ; $5814
    ld [$a001], a                                 ; $5816
    ld [wCamA001Shadow], a                        ; $5819
    ld a, [wCamFactoryVo + $8]                    ; $581C
    or $20                                        ; $581F
    ld [$a004], a                                 ; $5821
    ld [wCamA004Shadow], a                        ; $5824
    ld a, [wCamFactoryVo + $14]                   ; $5827
    set 7, a                                      ; $582A
    ld [$a005], a                                 ; $582C
    ld [wCamA005Shadow], a                        ; $582F
    call Cam_ThresholdConverge                    ; $5832
    ldh a, [hDiffOrValue]                         ; $5835
    ld [wCamCalibVector + $8], a                  ; $5837
    ld a, $25                                     ; $583A
    ld [$a001], a                                 ; $583C
    ld [wCamA001Shadow], a                        ; $583F
    ld a, [wCamFactoryVo + $9]                    ; $5842
    or $20                                        ; $5845
    ld [$a004], a                                 ; $5847
    ld [wCamA004Shadow], a                        ; $584A
    ld a, [wCamFactoryVo + $15]                   ; $584D
    set 7, a                                      ; $5850
    ld [$a005], a                                 ; $5852
    ld [wCamA005Shadow], a                        ; $5855
    call Cam_ThresholdConverge                    ; $5858
    ldh a, [hDiffOrValue]                         ; $585B
    ld [wCamCalibVector + $9], a                  ; $585D
    ld a, $28                                     ; $5860
    ld [$a001], a                                 ; $5862
    ld [wCamA001Shadow], a                        ; $5865
    ld a, [wCamFactoryVo + $a]                    ; $5868
    or $20                                        ; $586B
    ld [$a004], a                                 ; $586D
    ld [wCamA004Shadow], a                        ; $5870
    ld a, [wCamFactoryVo + $16]                   ; $5873
    set 7, a                                      ; $5876
    ld [$a005], a                                 ; $5878
    ld [wCamA005Shadow], a                        ; $587B
    call Cam_ThresholdConverge                    ; $587E
    ldh a, [hDiffOrValue]                         ; $5881
    ld [wCamCalibVector + $a], a                  ; $5883
    ld a, $0a                                     ; $5886
    ld [$a001], a                                 ; $5888
    ld [wCamA001Shadow], a                        ; $588B
    ld a, [wCamFactoryVo + $b]                    ; $588E
    ld [$a004], a                                 ; $5891
    ld [wCamA004Shadow], a                        ; $5894
    ld a, [wCamFactoryVo + $17]                   ; $5897
    set 7, a                                      ; $589A
    ld [$a005], a                                 ; $589C
    ld [wCamA005Shadow], a                        ; $589F
    call Cam_ThresholdConverge                    ; $58A2
    ldh a, [hDiffOrValue]                         ; $58A5
    ld [wCamCalibVector + $b], a                  ; $58A7
    ret                                           ; $58AA


; C: same code as the Japanese Cam_ThresholdConverge (0A:4E44, 159 bytes, masked match)
Cam_ThresholdConverge::
    ld hl, $a006                                  ; $58AB
    ld de, $0030                                  ; $58AE
    ld a, $80                                     ; $58B1
    ldh [hDiffOrValue], a                         ; $58B3
    ld b, a                                       ; $58B5

jr_004_58b6:
    ld [hl], b                                    ; $58B6
    inc hl                                        ; $58B7
    dec de                                        ; $58B8
    ld a, d                                       ; $58B9
    or e                                          ; $58BA
    jr nz, jr_004_58b6                            ; $58BB

    ld a, [wCamA000Shadow]                        ; $58BD
    set 0, a                                      ; $58C0
    ld [$a000], a                                 ; $58C2

jr_004_58c5:
    ld a, [$a000]                                 ; $58C5
    bit 0, a                                      ; $58C8
    jr nz, jr_004_58c5                            ; $58CA

    ld a, $09                                     ; $58CC
    call Cam_CountBrightSamples                   ; $58CE
    and a                                         ; $58D1
    jp z, Cam_ThresholdConverge_Up                ; $58D2

jr_004_58d5:
    ldh a, [hDiffOrValue]                         ; $58D5
    dec a                                         ; $58D7
    ldh [hDiffOrValue], a                         ; $58D8
    cp $01                                        ; $58DA
    jr z, jr_004_5905                             ; $58DC

    ld hl, $a006                                  ; $58DE
    ld de, $0030                                  ; $58E1
    ldh a, [hDiffOrValue]                         ; $58E4
    ld b, a                                       ; $58E6

jr_004_58e7:
    ld [hl], b                                    ; $58E7
    inc hl                                        ; $58E8
    dec de                                        ; $58E9
    ld a, d                                       ; $58EA
    or e                                          ; $58EB
    jr nz, jr_004_58e7                            ; $58EC

    ld a, [wCamA000Shadow]                        ; $58EE
    set 0, a                                      ; $58F1
    ld [$a000], a                                 ; $58F3

jr_004_58f6:
    ld a, [$a000]                                 ; $58F6
    bit 0, a                                      ; $58F9
    jr nz, jr_004_58f6                            ; $58FB

    ld a, $09                                     ; $58FD
    call Cam_CountBrightSamples                   ; $58FF
    and a                                         ; $5902
    jr nz, jr_004_58d5                            ; $5903

jr_004_5905:
    ldh a, [hDiffOrValue]                         ; $5905
    ldh [hPrevOrSign], a                          ; $5907

jr_004_5909:
    ldh a, [hDiffOrValue]                         ; $5909
    dec a                                         ; $590B
    ldh [hDiffOrValue], a                         ; $590C
    jr z, jr_004_5937                             ; $590E

    ld hl, $a006                                  ; $5910
    ld de, $0030                                  ; $5913
    ldh a, [hDiffOrValue]                         ; $5916
    ld b, a                                       ; $5918

jr_004_5919:
    ld [hl], b                                    ; $5919
    inc hl                                        ; $591A
    dec de                                        ; $591B
    ld a, d                                       ; $591C
    or e                                          ; $591D
    jr nz, jr_004_5919                            ; $591E

    ld a, [wCamA000Shadow]                        ; $5920
    set 0, a                                      ; $5923
    ld [$a000], a                                 ; $5925

jr_004_5928:
    ld a, [$a000]                                 ; $5928
    bit 0, a                                      ; $592B
    jr nz, jr_004_5928                            ; $592D

    ld a, $08                                     ; $592F
    call Cam_CountBrightSamples                   ; $5931
    and a                                         ; $5934
    jr nz, jr_004_5909                            ; $5935

jr_004_5937:
    ldh a, [hDiffOrValue]                         ; $5937
    ld c, a                                       ; $5939
    ld b, $00                                     ; $593A
    ldh a, [hPrevOrSign]                          ; $593C
    ld l, a                                       ; $593E
    ld h, $00                                     ; $593F
    add hl, bc                                    ; $5941
    srl h                                         ; $5942
    rr l                                          ; $5944
    ld a, l                                       ; $5946
    ldh [hDiffOrValue], a                         ; $5947
    ret                                           ; $5949


; C: same code as the Japanese Cam_ThresholdConverge_Up (0A:4EE3, 117 bytes, masked match)
Cam_ThresholdConverge_Up::
    ldh a, [hDiffOrValue]                         ; $594A
    inc a                                         ; $594C
    ldh [hDiffOrValue], a                         ; $594D
    cp $ff                                        ; $594F
    jr z, jr_004_597a                             ; $5951

    ld hl, $a006                                  ; $5953
    ld de, $0030                                  ; $5956
    ldh a, [hDiffOrValue]                         ; $5959
    ld b, a                                       ; $595B

jr_004_595c:
    ld [hl], b                                    ; $595C
    inc hl                                        ; $595D
    dec de                                        ; $595E
    ld a, d                                       ; $595F
    or e                                          ; $5960
    jr nz, jr_004_595c                            ; $5961

    ld a, [wCamA000Shadow]                        ; $5963
    set 0, a                                      ; $5966
    ld [$a000], a                                 ; $5968

jr_004_596b:
    ld a, [$a000]                                 ; $596B
    bit 0, a                                      ; $596E
    jr nz, jr_004_596b                            ; $5970

    ld a, $09                                     ; $5972
    call Cam_CountBrightSamples                   ; $5974
    and a                                         ; $5977
    jr z, Cam_ThresholdConverge_Up                ; $5978

jr_004_597a:
    ldh a, [hDiffOrValue]                         ; $597A
    ldh [hPrevOrSign], a                          ; $597C

jr_004_597e:
    ldh a, [hDiffOrValue]                         ; $597E
    dec a                                         ; $5980
    ldh [hDiffOrValue], a                         ; $5981
    jr z, jr_004_59ac                             ; $5983

    ld hl, $a006                                  ; $5985
    ld de, $0030                                  ; $5988
    ldh a, [hDiffOrValue]                         ; $598B
    ld b, a                                       ; $598D

jr_004_598e:
    ld [hl], b                                    ; $598E
    inc hl                                        ; $598F
    dec de                                        ; $5990
    ld a, d                                       ; $5991
    or e                                          ; $5992
    jr nz, jr_004_598e                            ; $5993

    ld a, [wCamA000Shadow]                        ; $5995
    set 0, a                                      ; $5998
    ld [$a000], a                                 ; $599A

jr_004_599d:
    ld a, [$a000]                                 ; $599D
    bit 0, a                                      ; $59A0
    jr nz, jr_004_599d                            ; $59A2

    ld a, $08                                     ; $59A4
    call Cam_CountBrightSamples                   ; $59A6
    and a                                         ; $59A9
    jr nz, jr_004_597e                            ; $59AA

jr_004_59ac:
    ldh a, [hDiffOrValue]                         ; $59AC
    ld c, a                                       ; $59AE
    ld b, $00                                     ; $59AF
    ldh a, [hPrevOrSign]                          ; $59B1
    ld l, a                                       ; $59B3
    ld h, $00                                     ; $59B4
    add hl, bc                                    ; $59B6
    srl h                                         ; $59B7
    rr l                                          ; $59B9
    ld a, l                                       ; $59BB
    ldh [hDiffOrValue], a                         ; $59BC
    ret                                           ; $59BE


; C: the Japanese Cam_CommitVectorToSRAM (0A:4F58), 61 instructions against 59, with 2 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Cam_CommitVectorToSRAM::
    ld a, $0a                                     ; $59BF
    ld [rRAMG], a                                 ; $59C1
    ld a, $02                                     ; $59C4
    ldh [hSram_Format_FF8C], a                    ; $59C6
    ld [rRAMB], a                                 ; $59C8
    ld hl, $aff2                                  ; $59CB
    ld de, wCamCalibVector                        ; $59CE
    ld b, $00                                     ; $59D1
    ld c, $00                                     ; $59D3
    ld a, $0c                                     ; $59D5
    ldh [hScratchA], a                            ; $59D7

jr_004_59d9:
    ld a, [de]                                    ; $59D9
    inc de                                        ; $59DA
    ld [hl+], a                                   ; $59DB
    ldh [hScratchB], a                            ; $59DC
    add b                                         ; $59DE
    ld b, a                                       ; $59DF
    ldh a, [hScratchB]                            ; $59E0
    xor c                                         ; $59E2
    ld c, a                                       ; $59E3
    ldh a, [hScratchA]                            ; $59E4
    dec a                                         ; $59E6
    ldh [hScratchA], a                            ; $59E7
    jr nz, jr_004_59d9                            ; $59E9

    ld a, b                                       ; $59EB
    add $0d                                       ; $59EC
    ld [hl+], a                                   ; $59EE
    ld a, c                                       ; $59EF
    add $23                                       ; $59F0
    ld [hl], a                                    ; $59F2
    ld a, $08                                     ; $59F3
    ldh [hSram_Format_FF8C], a                    ; $59F5
    ld [rRAMB], a                                 ; $59F7
    ld hl, $bff2                                  ; $59FA
    ld de, wCamCalibVector                        ; $59FD
    ld b, $00                                     ; $5A00
    ld c, $00                                     ; $5A02
    ld a, $0c                                     ; $5A04
    ldh [hScratchA], a                            ; $5A06

jr_004_5a08:
    ld a, [de]                                    ; $5A08
    inc de                                        ; $5A09
    ld [hl+], a                                   ; $5A0A
    ldh [hScratchB], a                            ; $5A0B
    add b                                         ; $5A0D
    ld b, a                                       ; $5A0E
    ldh a, [hScratchB]                            ; $5A0F
    xor c                                         ; $5A11
    ld c, a                                       ; $5A12
    ldh a, [hScratchA]                            ; $5A13
    dec a                                         ; $5A15
    ldh [hScratchA], a                            ; $5A16
    jr nz, jr_004_5a08                            ; $5A18

    ld a, b                                       ; $5A1A
    add $0d                                       ; $5A1B
    ld [hl+], a                                   ; $5A1D
    ld a, c                                       ; $5A1E
    add $23                                       ; $5A1F
    ld [hl], a                                    ; $5A21
    ld a, $00                                     ; $5A22
    ld [rRAMG], a                                 ; $5A24
    ret                                           ; $5A27


; C: same code as the Japanese Cam_PopcountSampleLoop (0A:4FBD, 212 bytes, masked match)
Cam_PopcountSampleLoop::
    ld a, $0a                                     ; $5A28
    ldh [hScratchA], a                            ; $5A2A

jr_004_5a2c:
    call Cam_PopcountSampleLoop_inner             ; $5A2C
    ld hl, $0014                                  ; $5A2F
    add hl, de                                    ; $5A32
    ld d, h                                       ; $5A33
    ld e, l                                       ; $5A34
    call Cam_PopcountSampleLoop_inner             ; $5A35
    ld hl, $0014                                  ; $5A38
    add hl, de                                    ; $5A3B
    ld d, h                                       ; $5A3C
    ld e, l                                       ; $5A3D
    call Cam_PopcountSampleLoop_inner             ; $5A3E
    ld hl, $0004                                  ; $5A41
    add hl, de                                    ; $5A44
    ld d, h                                       ; $5A45
    ld e, l                                       ; $5A46
    call Cam_PopcountSampleLoop_inner             ; $5A47
    ld hl, $0014                                  ; $5A4A
    add hl, de                                    ; $5A4D
    ld d, h                                       ; $5A4E
    ld e, l                                       ; $5A4F
    call Cam_PopcountSampleLoop_inner             ; $5A50
    ld hl, $0014                                  ; $5A53
    add hl, de                                    ; $5A56
    ld d, h                                       ; $5A57
    ld e, l                                       ; $5A58
    call Cam_PopcountSampleLoop_inner             ; $5A59
    ld hl, $0004                                  ; $5A5C
    add hl, de                                    ; $5A5F
    ld d, h                                       ; $5A60
    ld e, l                                       ; $5A61
    call Cam_PopcountSampleLoop_inner             ; $5A62
    ld hl, $0014                                  ; $5A65
    add hl, de                                    ; $5A68
    ld d, h                                       ; $5A69
    ld e, l                                       ; $5A6A
    call Cam_PopcountSampleLoop_inner             ; $5A6B
    ld hl, $0004                                  ; $5A6E
    add hl, de                                    ; $5A71
    ld d, h                                       ; $5A72
    ld e, l                                       ; $5A73
    call Cam_PopcountSampleLoop_inner             ; $5A74
    ld hl, $0014                                  ; $5A77
    add hl, de                                    ; $5A7A
    ld d, h                                       ; $5A7B
    ld e, l                                       ; $5A7C
    call Cam_PopcountSampleLoop_inner             ; $5A7D
    ld hl, $0014                                  ; $5A80
    add hl, de                                    ; $5A83
    ld d, h                                       ; $5A84
    ld e, l                                       ; $5A85
    call Cam_PopcountSampleLoop_inner             ; $5A86
    ld hl, $0004                                  ; $5A89
    add hl, de                                    ; $5A8C
    ld d, h                                       ; $5A8D
    ld e, l                                       ; $5A8E
    call Cam_PopcountSampleLoop_inner             ; $5A8F
    ld hl, $004f                                  ; $5A92
    add hl, de                                    ; $5A95
    ld d, h                                       ; $5A96
    ld e, l                                       ; $5A97
    ldh a, [hScratchA]                            ; $5A98
    dec a                                         ; $5A9A
    jr z, jr_004_5aa1                             ; $5A9B

    ldh [hScratchA], a                            ; $5A9D
    jr jr_004_5a2c                                ; $5A9F

jr_004_5aa1:
    sla c                                         ; $5AA1
    rl b                                          ; $5AA3
    ld de, $a540                                  ; $5AA5
    ld a, $06                                     ; $5AA8
    ldh [hScratchA], a                            ; $5AAA

jr_004_5aac:
    call Cam_PopcountSampleLoop_inner             ; $5AAC
    ld hl, $0014                                  ; $5AAF
    add hl, de                                    ; $5AB2
    ld d, h                                       ; $5AB3
    ld e, l                                       ; $5AB4
    call Cam_PopcountSampleLoop_inner             ; $5AB5
    ld hl, $0014                                  ; $5AB8
    add hl, de                                    ; $5ABB
    ld d, h                                       ; $5ABC
    ld e, l                                       ; $5ABD
    call Cam_PopcountSampleLoop_inner             ; $5ABE
    ld hl, $0004                                  ; $5AC1
    add hl, de                                    ; $5AC4
    ld d, h                                       ; $5AC5
    ld e, l                                       ; $5AC6
    call Cam_PopcountSampleLoop_inner             ; $5AC7
    ld hl, $0014                                  ; $5ACA
    add hl, de                                    ; $5ACD
    ld d, h                                       ; $5ACE
    ld e, l                                       ; $5ACF
    call Cam_PopcountSampleLoop_inner             ; $5AD0
    ld hl, $0014                                  ; $5AD3
    add hl, de                                    ; $5AD6
    ld d, h                                       ; $5AD7
    ld e, l                                       ; $5AD8
    call Cam_PopcountSampleLoop_inner             ; $5AD9
    ld hl, $0004                                  ; $5ADC
    add hl, de                                    ; $5ADF
    ld d, h                                       ; $5AE0
    ld e, l                                       ; $5AE1
    call Cam_PopcountSampleLoop_inner             ; $5AE2
    ld hl, $0014                                  ; $5AE5
    add hl, de                                    ; $5AE8
    ld d, h                                       ; $5AE9
    ld e, l                                       ; $5AEA
    call Cam_PopcountSampleLoop_inner             ; $5AEB
    ld hl, $0084                                  ; $5AEE
    add hl, de                                    ; $5AF1
    ld d, h                                       ; $5AF2
    ld e, l                                       ; $5AF3
    ldh a, [hScratchA]                            ; $5AF4
    dec a                                         ; $5AF6
    ret z                                         ; $5AF7

    ldh [hScratchA], a                            ; $5AF8
    jr jr_004_5aac                                ; $5AFA

; C: same instructions as the Japanese Cam_PopcountSampleLoop_inner (0A:5091) over the whole routine (20 instructions,
; to the first ret / jp), only the addresses differ; code compared
Cam_PopcountSampleLoop_inner::
    ld h, HIGH(Cam_PopcountTable256)              ; $5AFC
    ld a, [de]                                    ; $5AFE
    inc de                                        ; $5AFF
    ld l, a                                       ; $5B00
    ld l, [hl]                                    ; $5B01
    ld h, $00                                     ; $5B02
    add hl, bc                                    ; $5B04
    ld b, h                                       ; $5B05
    ld c, l                                       ; $5B06
    ld h, HIGH(Cam_PopcountTable256)              ; $5B07
    ld a, [de]                                    ; $5B09
    inc de                                        ; $5B0A
    ld l, a                                       ; $5B0B
    ld l, [hl]                                    ; $5B0C
    sla l                                         ; $5B0D
    ld h, $00                                     ; $5B0F
    add hl, bc                                    ; $5B11
    ld b, h                                       ; $5B12
    ld c, l                                       ; $5B13
    ret                                           ; $5B14


; C: the Japanese Cam_LiveInit (0A:50AA), 35 instructions against 34, with 1 small edits (variables moved between HRAM
; and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Cam_LiveInit::
    call Cam_ExposureBandSelect                   ; $5B15
    ld a, $10                                     ; $5B18
    ldh [hSram_Format_FF8C], a                    ; $5B1A
    ld [rRAMB], a                                 ; $5B1C
    ld a, $02                                     ; $5B1F
    ld [wCamA000Shadow], a                        ; $5B21
    ld a, [wCamGainAlt]                           ; $5B24
    ld [wCamGainSel], a                           ; $5B27
    or $e0                                        ; $5B2A
    ld [$a001], a                                 ; $5B2C
    ld [wCamA001Shadow], a                        ; $5B2F
    ld a, $10                                     ; $5B32
    ld [$a002], a                                 ; $5B34
    ld [wCamExposureShadow], a                    ; $5B37
    xor a                                         ; $5B3A
    ld [$a003], a                                 ; $5B3B
    ld [wCamExposureShadow + $1], a               ; $5B3E
    ld a, [wCamBootV + $2]                        ; $5B41
    ld [$a004], a                                 ; $5B44
    ld [wCamA004Shadow], a                        ; $5B47
    ld a, [wCamBootO + $2]                        ; $5B4A
    set 7, a                                      ; $5B4D
    ld [$a005], a                                 ; $5B4F
    ld [wCamA005Shadow], a                        ; $5B52
    ld a, $07                                     ; $5B55
    ld [wCamBrightnessSetpoint], a                ; $5B57
    ld a, $01                                     ; $5B5A
    ld [wCamDitherMode], a                        ; $5B5C
    ld a, $08                                     ; $5B5F
    ld [wCamContrastRow], a                       ; $5B61
    ld c, a                                       ; $5B64
    ld a, [wCamGainSel]                           ; $5B65
    ld b, a                                       ; $5B68
    call Cam_LoadRegisterSet                      ; $5B69
    ret                                           ; $5B6C


; C: same code as the Japanese Cam_CopyTileRows (0A:5100, 774 bytes, masked match)
Cam_CopyTileRows::
    REPT 256                                      ; $5B6D
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 256 copies of 3 bytes
    inc d                                         ; $5E6D
    dec b                                         ; $5E6E
    jp nz, Cam_CopyTileRows                       ; $5E6F

    ret                                           ; $5E72


; C: jumps to entry A of the effect table 04:5E8A with SRAM bank 0 (as the Japanese 0A:5406 Cam_DispatchEffect)
Cam_DispatchEffect::
    sla a                                         ; $5E73
    ld c, a                                       ; $5E75
    ld b, $00                                     ; $5E76
    ld hl, Cam_DispatchEffect_JumpTbl5E8A         ; $5E78
    add hl, bc                                    ; $5E7B
    ld a, [hl+]                                   ; $5E7C
    ld b, a                                       ; $5E7D
    ld a, [hl]                                    ; $5E7E
    ld c, a                                       ; $5E7F
    ld l, b                                       ; $5E80
    ld h, c                                       ; $5E81
    ld a, $00                                     ; $5E82
    ldh [hSram_Format_FF8C], a                    ; $5E84
    ld [rRAMB], a                                 ; $5E86
    jp hl                                         ; $5E89


; C: named by the code of Cam_DispatchEffect (04:5E78); read in the runs by Cam_DispatchEffect; first read on the
; screen Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
Cam_DispatchEffect_JumpTbl5E8A::
    dw Fx00_Copy
    dw Fx01_MirrorRtoL
    dw Fx02_MirrorLtoR
    dw Fx03_MirrorBtoT
    dw Fx04_MirrorTtoB
    dw Fx05_StretchV2x
    dw Fx06_StretchH2x
    dw Fx07_Zoom2x_GroupTop
    dw Fx08_Reduce2xTile2x2
    dw Fx09_Reduce2xQuadTL
    dw Fx0A_Reduce2xQuadTR
    dw Fx0B_Reduce2xQuadBL
    dw Fx0C_Reduce2xQuadBR
    dw Fx0D_CopyLeftHalf
    dw Fx0E_CopyRightHalf
    dw Fx0F_CopyTopHalf
    dw Fx10_CopyBottomHalf
    dw Fx11_CopyQuads_TR_BL
    dw Fx12_CopyQuads_TR_BL_BR
    dw Fx13_CopyTop10Rows
    dw Fx14_CopyBottom4Rows
    dw Fx15_CopyTop4Rows
    dw Fx16_CopyBottom10Rows
    dw Fx17_CopyWindow
    dw Fx18_CopyQuadBR
    dw Fx19_Nop
    dw Fx1A_Nop
    dw Fx1B_Nop
    dw Fx1C_Nop
    dw Fx1D_Nop
    dw Fx1E_Nop
    dw Fx1F_Nop
    dw Fx20_FlipH
    dw Fx02_MirrorLtoR
    dw Fx01_MirrorRtoL
    dw Fx23_MirrorBtoT_OnFlipH
    dw Fx24_MirrorTtoB_OnFlipH
    dw Fx25_StretchV2x_OnFlipH
    dw Fx26_StretchH2x_OnFlipH
    dw Fx27_Zoom2x_OnFlipH_GroupTop
    dw Fx28_Reduce2xTile2x2_FlipH
    dw Fx29_Reduce2xQuadTL_FlipH
    dw Fx2A_Reduce2xQuadTR_FlipH
    dw Fx2B_Reduce2xQuadBL_FlipH
    dw Fx2C_Reduce2xQuadBR_FlipH
    dw Fx2D_CopyLeftHalf_OnFlipH
    dw Fx2E_CopyRightHalf_OnFlipH
    dw Fx2F_CopyTopHalf_OnFlipH
    dw Fx30_CopyBottomHalf_OnFlipH
    dw Fx31_CopyQuads_TR_BL_OnFlipH
    dw Fx32_CopyQuads_TR_BL_BR_OnFlipH
    dw Fx33_CopyTop10Rows_OnFlipH
    dw Fx34_CopyBottom4Rows_OnFlipH
    dw Fx35_CopyTop4Rows_OnFlipH
    dw Fx36_CopyBottom10Rows_OnFlipH
    dw Fx37_CopyWindow_OnFlipH
    dw Fx38_CopyQuadBR_OnFlipH
    dw Fx39_Nop
    dw Fx3A_Nop
    dw Fx3B_Nop
    dw Fx3C_Nop
    dw Fx3D_Nop
    dw Fx3E_Nop
    dw Fx3F_Nop
    dw Fx40_FlipV
    dw Fx41_MirrorRtoL_OnFlipV
    dw Fx42_MirrorLtoR_OnFlipV
    dw Fx04_MirrorTtoB
    dw Fx03_MirrorBtoT
    dw Fx45_StretchV2x_FlipV
    dw Fx46_StretchH2x_OnFlipV
    dw Fx47_Zoom2x_FlipV_GroupTop
    dw Fx48_Reduce2xTile2x2_FlipV
    dw Fx49_Reduce2xQuadTL_FlipV
    dw Fx4A_Reduce2xQuadTR_FlipV
    dw Fx4B_Reduce2xQuadBL_FlipV
    dw Fx4C_Reduce2xQuadBR_FlipV
    dw Fx4D_CopyLeftHalf_OnFlipV
    dw Fx4E_CopyRightHalf_OnFlipV
    dw Fx4F_CopyTopHalf_OnFlipV
    dw Fx50_CopyBottomHalf_OnFlipV
    dw Fx51_CopyQuads_TR_BL_OnFlipV
    dw Fx52_CopyQuads_TR_BL_BR_OnFlipV
    dw Fx53_CopyTop10Rows_OnFlipV
    dw Fx54_CopyBottom4Rows_OnFlipV
    dw Fx55_CopyTop4Rows_OnFlipV
    dw Fx56_CopyBottom10Rows_OnFlipV
    dw Fx57_CopyWindow_OnFlipV
    dw Fx58_CopyQuadBR_OnFlipV
    dw Fx59_Nop
    dw Fx5A_Nop
    dw Fx5B_Nop
    dw Fx5C_Nop
    dw Fx5D_Nop
    dw Fx5E_Nop
    dw Fx5F_Nop

; C: same instructions as the Japanese Fx00_Copy (0A:54DA) over the whole routine (5 instructions, to the first ret /
; jp), only the addresses differ; code compared
Fx00_Copy::
    ld hl, $a100                                  ; $5F4A
    ld de, $c000                                  ; $5F4D
    ld b, $0e                                     ; $5F50
    call Cam_CopyTileRows                         ; $5F52
    ret                                           ; $5F55


; C: entry $01 of the effect table 04:5E8A, the same entry as the Japanese 0A:54E6 Fx01_MirrorRtoL (the two tables
; pair one to one); same code shape
Fx01_MirrorRtoL::
    ld hl, $a180                                  ; $5F56
    ld de, wPhotoImage + $80                      ; $5F59
    ld b, $41                                     ; $5F5C
    ld a, $0e                                     ; $5F5E
    ldh [hScratchA], a                            ; $5F60

jr_004_5f62:
    ld a, $08                                     ; $5F62
    ldh [hScratchB], a                            ; $5F64

jr_004_5f66:
    ld a, $08                                     ; $5F66
    ldh [hScratchD], a                            ; $5F68

jr_004_5f6a:
    ld a, [hl+]                                   ; $5F6A
    ld [de], a                                    ; $5F6B
    ld c, a                                       ; $5F6C
    ld a, [bc]                                    ; $5F6D
    ld c, a                                       ; $5F6E
    ld a, e                                       ; $5F6F
    xor $f0                                       ; $5F70
    ld e, a                                       ; $5F72
    ld a, c                                       ; $5F73
    ld [de], a                                    ; $5F74
    inc e                                         ; $5F75
    ld a, [hl+]                                   ; $5F76
    ld c, a                                       ; $5F77
    ld a, [bc]                                    ; $5F78
    ld [de], a                                    ; $5F79
    ld a, e                                       ; $5F7A
    xor $f0                                       ; $5F7B
    ld e, a                                       ; $5F7D
    ld a, c                                       ; $5F7E
    ld [de], a                                    ; $5F7F
    inc e                                         ; $5F80
    ldh a, [hScratchD]                            ; $5F81
    dec a                                         ; $5F83
    ldh [hScratchD], a                            ; $5F84
    jr nz, jr_004_5f6a                            ; $5F86

    ldh a, [hScratchB]                            ; $5F88
    dec a                                         ; $5F8A
    jr z, jr_004_5f91                             ; $5F8B

    ldh [hScratchB], a                            ; $5F8D
    jr jr_004_5f66                                ; $5F8F

jr_004_5f91:
    ldh a, [hScratchA]                            ; $5F91
    dec a                                         ; $5F93
    ret z                                         ; $5F94

    ldh [hScratchA], a                            ; $5F95
    inc d                                         ; $5F97
    ld e, $80                                     ; $5F98
    ld l, $80                                     ; $5F9A
    jr jr_004_5f62                                ; $5F9C

; C: entry $02 of the effect table 04:5E8A, the same entry as the Japanese 0A:552E Fx02_MirrorLtoR (the two tables
; pair one to one); same code shape
Fx02_MirrorLtoR::
    ld hl, $a100                                  ; $5F9E
    ld de, wPhotoImage                            ; $5FA1
    ld b, $41                                     ; $5FA4
    ld a, $0e                                     ; $5FA6
    ldh [hScratchA], a                            ; $5FA8

jr_004_5faa:
    ld a, $08                                     ; $5FAA
    ldh [hScratchB], a                            ; $5FAC

jr_004_5fae:
    ld a, $08                                     ; $5FAE
    ldh [hScratchD], a                            ; $5FB0

jr_004_5fb2:
    ld a, [hl+]                                   ; $5FB2
    ld [de], a                                    ; $5FB3
    ld c, a                                       ; $5FB4
    ld a, [bc]                                    ; $5FB5
    ld c, a                                       ; $5FB6
    ld a, e                                       ; $5FB7
    xor $f0                                       ; $5FB8
    ld e, a                                       ; $5FBA
    ld a, c                                       ; $5FBB
    ld [de], a                                    ; $5FBC
    inc e                                         ; $5FBD
    ld a, [hl+]                                   ; $5FBE
    ld c, a                                       ; $5FBF
    ld a, [bc]                                    ; $5FC0
    ld [de], a                                    ; $5FC1
    ld a, e                                       ; $5FC2
    xor $f0                                       ; $5FC3
    ld e, a                                       ; $5FC5
    ld a, c                                       ; $5FC6
    ld [de], a                                    ; $5FC7
    inc e                                         ; $5FC8
    ldh a, [hScratchD]                            ; $5FC9
    dec a                                         ; $5FCB
    ldh [hScratchD], a                            ; $5FCC
    jr nz, jr_004_5fb2                            ; $5FCE

    ldh a, [hScratchB]                            ; $5FD0
    dec a                                         ; $5FD2
    jr z, jr_004_5fd9                             ; $5FD3

    ldh [hScratchB], a                            ; $5FD5
    jr jr_004_5fae                                ; $5FD7

jr_004_5fd9:
    ldh a, [hScratchA]                            ; $5FD9
    dec a                                         ; $5FDB
    ret z                                         ; $5FDC

    ldh [hScratchA], a                            ; $5FDD
    inc d                                         ; $5FDF
    ld e, $00                                     ; $5FE0
    inc h                                         ; $5FE2
    ld l, $00                                     ; $5FE3
    jr jr_004_5faa                                ; $5FE5

; C: same code as the Japanese Fx03_MirrorBtoT (0A:5577, 67 bytes, masked match)
Fx03_MirrorBtoT::
    ld hl, $a800                                  ; $5FE7
    ld bc, wPhotoImage + $60e                     ; $5FEA
    ld de, wPhotoImage + $700                     ; $5FED
    ld a, $07                                     ; $5FF0
    ldh [hScratchA], a                            ; $5FF2

jr_004_5ff4:
    ld a, $10                                     ; $5FF4
    ldh [hScratchB], a                            ; $5FF6

jr_004_5ff8:
    ld a, $08                                     ; $5FF8
    ldh [hScratchD], a                            ; $5FFA

jr_004_5ffc:
    ld a, [hl+]                                   ; $5FFC
    ld [de], a                                    ; $5FFD
    ld [bc], a                                    ; $5FFE
    inc e                                         ; $5FFF
    inc c                                         ; $6000
    ld a, [hl+]                                   ; $6001
    ld [de], a                                    ; $6002
    ld [bc], a                                    ; $6003
    inc e                                         ; $6004
    dec c                                         ; $6005
    dec c                                         ; $6006
    dec c                                         ; $6007
    ldh a, [hScratchD]                            ; $6008
    dec a                                         ; $600A
    ldh [hScratchD], a                            ; $600B
    jr nz, jr_004_5ffc                            ; $600D

    ldh a, [hScratchB]                            ; $600F
    dec a                                         ; $6011
    jr z, jr_004_601c                             ; $6012

    ldh [hScratchB], a                            ; $6014
    ld a, c                                       ; $6016
    add $20                                       ; $6017
    ld c, a                                       ; $6019
    jr jr_004_5ff8                                ; $601A

jr_004_601c:
    ldh a, [hScratchA]                            ; $601C
    dec a                                         ; $601E
    ret z                                         ; $601F

    ldh [hScratchA], a                            ; $6020
    inc d                                         ; $6022
    ld e, $00                                     ; $6023
    dec b                                         ; $6025
    ld c, $0e                                     ; $6026
    jr jr_004_5ff4                                ; $6028

; C: same code as the Japanese Fx04_MirrorTtoB (0A:55BA, 67 bytes, masked match)
Fx04_MirrorTtoB::
    ld hl, $a100                                  ; $602A
    ld de, wPhotoImage                            ; $602D
    ld bc, wPhotoImage + $d0e                     ; $6030
    ld a, $07                                     ; $6033
    ldh [hScratchA], a                            ; $6035

jr_004_6037:
    ld a, $10                                     ; $6037
    ldh [hScratchB], a                            ; $6039

jr_004_603b:
    ld a, $08                                     ; $603B
    ldh [hScratchD], a                            ; $603D

jr_004_603f:
    ld a, [hl+]                                   ; $603F
    ld [de], a                                    ; $6040
    ld [bc], a                                    ; $6041
    inc e                                         ; $6042
    inc c                                         ; $6043
    ld a, [hl+]                                   ; $6044
    ld [de], a                                    ; $6045
    ld [bc], a                                    ; $6046
    inc e                                         ; $6047
    dec c                                         ; $6048
    dec c                                         ; $6049
    dec c                                         ; $604A
    ldh a, [hScratchD]                            ; $604B
    dec a                                         ; $604D
    ldh [hScratchD], a                            ; $604E
    jr nz, jr_004_603f                            ; $6050

    ldh a, [hScratchB]                            ; $6052
    dec a                                         ; $6054
    jr z, jr_004_605f                             ; $6055

    ldh [hScratchB], a                            ; $6057
    ld a, c                                       ; $6059
    add $20                                       ; $605A
    ld c, a                                       ; $605C
    jr jr_004_603b                                ; $605D

jr_004_605f:
    ldh a, [hScratchA]                            ; $605F
    dec a                                         ; $6061
    ret z                                         ; $6062

    ldh [hScratchA], a                            ; $6063
    inc d                                         ; $6065
    ld e, $00                                     ; $6066
    dec b                                         ; $6068
    ld c, $0e                                     ; $6069
    jr jr_004_6037                                ; $606B

; C: same code as the Japanese Fx05_StretchV2x (0A:55FD, 84 bytes, masked match)
Fx05_StretchV2x::
    ld hl, $a400                                  ; $606D
    ld de, wPhotoImage                            ; $6070
    ld a, $07                                     ; $6073
    ldh [hScratchA], a                            ; $6075

jr_004_6077:
    ld a, $10                                     ; $6077
    ldh [hScratchB], a                            ; $6079

jr_004_607b:
    ld a, $04                                     ; $607B
    ldh [hScratchD], a                            ; $607D

jr_004_607f:
    ld a, [hl+]                                   ; $607F
    ld [de], a                                    ; $6080
    inc e                                         ; $6081
    inc e                                         ; $6082
    ld [de], a                                    ; $6083
    dec e                                         ; $6084
    ld a, [hl+]                                   ; $6085
    ld [de], a                                    ; $6086
    inc e                                         ; $6087
    inc e                                         ; $6088
    ld [de], a                                    ; $6089
    inc e                                         ; $608A
    ldh a, [hScratchD]                            ; $608B
    dec a                                         ; $608D
    ldh [hScratchD], a                            ; $608E
    jr nz, jr_004_607f                            ; $6090

    inc d                                         ; $6092
    ld a, e                                       ; $6093
    sub $10                                       ; $6094
    ld e, a                                       ; $6096
    ld a, $04                                     ; $6097
    ldh [hScratchD], a                            ; $6099

jr_004_609b:
    ld a, [hl+]                                   ; $609B
    ld [de], a                                    ; $609C
    inc e                                         ; $609D
    inc e                                         ; $609E
    ld [de], a                                    ; $609F
    dec e                                         ; $60A0
    ld a, [hl+]                                   ; $60A1
    ld [de], a                                    ; $60A2
    inc e                                         ; $60A3
    inc e                                         ; $60A4
    ld [de], a                                    ; $60A5
    inc e                                         ; $60A6
    ldh a, [hScratchD]                            ; $60A7
    dec a                                         ; $60A9
    ldh [hScratchD], a                            ; $60AA
    jr nz, jr_004_609b                            ; $60AC

    ldh a, [hScratchB]                            ; $60AE
    dec a                                         ; $60B0
    jr z, jr_004_60b8                             ; $60B1

    ldh [hScratchB], a                            ; $60B3
    dec d                                         ; $60B5
    jr jr_004_607b                                ; $60B6

jr_004_60b8:
    ldh a, [hScratchA]                            ; $60B8
    dec a                                         ; $60BA
    ret z                                         ; $60BB

    ldh [hScratchA], a                            ; $60BC
    inc d                                         ; $60BE
    jr jr_004_6077                                ; $60BF

; C: same instructions as the Japanese Fx06_StretchH2x (0A:5651) over the whole routine (34 instructions, to the first
; ret / jp), only the addresses differ; code compared
Fx06_StretchH2x::
    ld hl, $a140                                  ; $60C1
    ld de, wPhotoImage                            ; $60C4
    ld a, $0e                                     ; $60C7
    ldh [hScratchA], a                            ; $60C9

jr_004_60cb:
    ld a, $08                                     ; $60CB
    ldh [hScratchB], a                            ; $60CD

jr_004_60cf:
    ld a, $10                                     ; $60CF
    ldh [hScratchD], a                            ; $60D1

jr_004_60d3:
    ld a, [hl+]                                   ; $60D3
    ld c, a                                       ; $60D4
    ld b, $42                                     ; $60D5
    ld a, [bc]                                    ; $60D7
    ld [de], a                                    ; $60D8
    ld a, e                                       ; $60D9
    add $10                                       ; $60DA
    ld e, a                                       ; $60DC
    ld b, $43                                     ; $60DD
    ld a, [bc]                                    ; $60DF
    ld [de], a                                    ; $60E0
    ld a, e                                       ; $60E1
    sub $0f                                       ; $60E2
    ld e, a                                       ; $60E4
    ldh a, [hScratchD]                            ; $60E5
    dec a                                         ; $60E7
    ldh [hScratchD], a                            ; $60E8
    jr nz, jr_004_60d3                            ; $60EA

    ld a, e                                       ; $60EC
    add $10                                       ; $60ED
    ld e, a                                       ; $60EF
    ldh a, [hScratchB]                            ; $60F0
    dec a                                         ; $60F2
    jr z, jr_004_60f9                             ; $60F3

    ldh [hScratchB], a                            ; $60F5
    jr jr_004_60cf                                ; $60F7

jr_004_60f9:
    ldh a, [hScratchA]                            ; $60F9
    dec a                                         ; $60FB
    ret z                                         ; $60FC

    ldh [hScratchA], a                            ; $60FD
    inc d                                         ; $60FF
    inc h                                         ; $6100
    ld l, $40                                     ; $6101
    jr jr_004_60cb                                ; $6103

; C: the Japanese Fx07_Zoom2x_GroupTop (0A:56A3), 111 instructions against 105, with 1 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Fx07_Zoom2x_GroupTop::
    ld hl, $a440                                  ; $6105
    ld de, $c000                                  ; $6108
    ld a, $07                                     ; $610B
    ldh [hScratchA], a                            ; $610D

Jump_004_610f:
    ld a, $08                                     ; $610F
    ldh [hScratchB], a                            ; $6111

Jump_004_6113:
    ld a, $04                                     ; $6113
    ldh [hScratchD], a                            ; $6115

jr_004_6117:
    ld a, [hl+]                                   ; $6117
    ld c, a                                       ; $6118
    ld b, $42                                     ; $6119
    ld a, [bc]                                    ; $611B
    ld [de], a                                    ; $611C
    inc e                                         ; $611D
    inc e                                         ; $611E
    ld [de], a                                    ; $611F
    ld a, e                                       ; $6120
    add $0e                                       ; $6121
    ld e, a                                       ; $6123
    ld b, $43                                     ; $6124
    ld a, [bc]                                    ; $6126
    ld [de], a                                    ; $6127
    inc e                                         ; $6128
    inc e                                         ; $6129
    ld [de], a                                    ; $612A
    ld a, e                                       ; $612B
    sub $11                                       ; $612C
    ld e, a                                       ; $612E
    ld a, [hl+]                                   ; $612F
    ld c, a                                       ; $6130
    ld b, $42                                     ; $6131
    ld a, [bc]                                    ; $6133
    ld [de], a                                    ; $6134
    inc e                                         ; $6135
    inc e                                         ; $6136
    ld [de], a                                    ; $6137
    ld a, e                                       ; $6138
    add $0e                                       ; $6139
    ld e, a                                       ; $613B
    ld b, $43                                     ; $613C
    ld a, [bc]                                    ; $613E
    ld [de], a                                    ; $613F
    inc e                                         ; $6140
    inc e                                         ; $6141
    ld [de], a                                    ; $6142
    ld a, e                                       ; $6143
    sub $0f                                       ; $6144
    ld e, a                                       ; $6146
    ldh a, [hScratchD]                            ; $6147
    dec a                                         ; $6149
    ldh [hScratchD], a                            ; $614A
    jr nz, jr_004_6117                            ; $614C

    inc d                                         ; $614E
    ld a, e                                       ; $614F
    sub $10                                       ; $6150
    ld e, a                                       ; $6152
    ld a, $04                                     ; $6153
    ldh [hScratchD], a                            ; $6155

jr_004_6157:
    ld a, [hl+]                                   ; $6157
    ld c, a                                       ; $6158
    ld b, $42                                     ; $6159
    ld a, [bc]                                    ; $615B
    ld [de], a                                    ; $615C
    inc e                                         ; $615D
    inc e                                         ; $615E
    ld [de], a                                    ; $615F
    ld a, e                                       ; $6160
    add $0e                                       ; $6161
    ld e, a                                       ; $6163
    ld b, $43                                     ; $6164
    ld a, [bc]                                    ; $6166
    ld [de], a                                    ; $6167
    inc e                                         ; $6168
    inc e                                         ; $6169
    ld [de], a                                    ; $616A
    ld a, e                                       ; $616B
    sub $11                                       ; $616C
    ld e, a                                       ; $616E
    ld a, [hl+]                                   ; $616F
    ld c, a                                       ; $6170
    ld b, $42                                     ; $6171
    ld a, [bc]                                    ; $6173
    ld [de], a                                    ; $6174
    inc e                                         ; $6175
    inc e                                         ; $6176
    ld [de], a                                    ; $6177
    ld a, e                                       ; $6178
    add $0e                                       ; $6179
    ld e, a                                       ; $617B
    ld b, $43                                     ; $617C
    ld a, [bc]                                    ; $617E
    ld [de], a                                    ; $617F
    inc e                                         ; $6180
    inc e                                         ; $6181
    ld [de], a                                    ; $6182
    ld a, e                                       ; $6183
    sub $0f                                       ; $6184
    ld e, a                                       ; $6186
    ldh a, [hScratchD]                            ; $6187
    dec a                                         ; $6189
    ldh [hScratchD], a                            ; $618A
    jr nz, jr_004_6157                            ; $618C

    ldh a, [hScratchB]                            ; $618E
    dec a                                         ; $6190
    jr z, jr_004_619d                             ; $6191

    ldh [hScratchB], a                            ; $6193
    dec d                                         ; $6195
    ld a, e                                       ; $6196
    add $10                                       ; $6197
    ld e, a                                       ; $6199
    jp Jump_004_6113                              ; $619A


jr_004_619d:
    ldh a, [hScratchA]                            ; $619D
    dec a                                         ; $619F
    ret z                                         ; $61A0

    ldh [hScratchA], a                            ; $61A1
    inc h                                         ; $61A3
    ld l, $40                                     ; $61A4
    inc d                                         ; $61A6
    ld e, $00                                     ; $61A7
    jp Jump_004_610f                              ; $61A9


; C: entry $08 of the effect table 04:5E8A, the same entry as the Japanese 0A:573C Fx08_Reduce2xTile2x2 (the two
; tables pair one to one); same code shape
Fx08_Reduce2xTile2x2::
    ld hl, $a100                                  ; $61AC
    ld de, $c000                                  ; $61AF
    ld b, HIGH(Cam_ReduceTbl_Lo)                  ; $61B2
    ld a, $07                                     ; $61B4
    ldh [hScratchA], a                            ; $61B6

Jump_004_61b8:
    ld a, $08                                     ; $61B8
    ldh [hScratchB], a                            ; $61BA

; C: same code as the Japanese Fx08_Reduce2xTile2x2_GroupTop (0A:574C, 239 bytes, masked match)
Fx08_Reduce2xTile2x2_GroupTop::
    ld a, $04                                     ; $61BC
    ldh [hScratchD], a                            ; $61BE

jr_004_61c0:
    ld c, [hl]                                    ; $61C0
    ld a, [bc]                                    ; $61C1
    swap a                                        ; $61C2
    ldh [hScratchC], a                            ; $61C4
    ld a, l                                       ; $61C6
    add $10                                       ; $61C7
    ld l, a                                       ; $61C9
    ld c, [hl]                                    ; $61CA
    ld a, [bc]                                    ; $61CB
    ld c, a                                       ; $61CC
    ldh a, [hScratchC]                            ; $61CD
    or c                                          ; $61CF
    ld c, a                                       ; $61D0
    ld [de], a                                    ; $61D1
    ld a, e                                       ; $61D2
    add $80                                       ; $61D3
    ld e, a                                       ; $61D5
    ld a, c                                       ; $61D6
    ld [de], a                                    ; $61D7
    ld a, d                                       ; $61D8
    add $07                                       ; $61D9
    ld d, a                                       ; $61DB
    ld a, c                                       ; $61DC
    ld [de], a                                    ; $61DD
    ld a, e                                       ; $61DE
    add $80                                       ; $61DF
    ld e, a                                       ; $61E1
    ld a, c                                       ; $61E2
    ld [de], a                                    ; $61E3
    ld a, d                                       ; $61E4
    sub $07                                       ; $61E5
    ld d, a                                       ; $61E7
    inc e                                         ; $61E8
    ld a, l                                       ; $61E9
    sub $0f                                       ; $61EA
    ld l, a                                       ; $61EC
    ld c, [hl]                                    ; $61ED
    ld a, [bc]                                    ; $61EE
    swap a                                        ; $61EF
    ldh [hScratchC], a                            ; $61F1
    ld a, l                                       ; $61F3
    add $10                                       ; $61F4
    ld l, a                                       ; $61F6
    ld c, [hl]                                    ; $61F7
    ld a, [bc]                                    ; $61F8
    ld c, a                                       ; $61F9
    ldh a, [hScratchC]                            ; $61FA
    or c                                          ; $61FC
    ld c, a                                       ; $61FD
    ld [de], a                                    ; $61FE
    ld a, e                                       ; $61FF
    add $80                                       ; $6200
    ld e, a                                       ; $6202
    ld a, c                                       ; $6203
    ld [de], a                                    ; $6204
    ld a, d                                       ; $6205
    add $07                                       ; $6206
    ld d, a                                       ; $6208
    ld a, c                                       ; $6209
    ld [de], a                                    ; $620A
    ld a, e                                       ; $620B
    add $80                                       ; $620C
    ld e, a                                       ; $620E
    ld a, c                                       ; $620F
    ld [de], a                                    ; $6210
    ld a, d                                       ; $6211
    sub $07                                       ; $6212
    ld d, a                                       ; $6214
    inc e                                         ; $6215
    ld a, l                                       ; $6216
    sub $0d                                       ; $6217
    ld l, a                                       ; $6219
    ldh a, [hScratchD]                            ; $621A
    dec a                                         ; $621C
    ldh [hScratchD], a                            ; $621D
    jr nz, jr_004_61c0                            ; $621F

    inc h                                         ; $6221
    ld a, l                                       ; $6222
    sub $10                                       ; $6223
    ld l, a                                       ; $6225
    ld a, $04                                     ; $6226
    ldh [hScratchD], a                            ; $6228

jr_004_622a:
    ld c, [hl]                                    ; $622A
    ld a, [bc]                                    ; $622B
    swap a                                        ; $622C
    ldh [hScratchC], a                            ; $622E
    ld a, l                                       ; $6230
    add $10                                       ; $6231
    ld l, a                                       ; $6233
    ld c, [hl]                                    ; $6234
    ld a, [bc]                                    ; $6235
    ld c, a                                       ; $6236
    ldh a, [hScratchC]                            ; $6237
    or c                                          ; $6239
    ld c, a                                       ; $623A
    ld [de], a                                    ; $623B
    ld a, e                                       ; $623C
    add $80                                       ; $623D
    ld e, a                                       ; $623F
    ld a, c                                       ; $6240
    ld [de], a                                    ; $6241
    ld a, d                                       ; $6242
    add $07                                       ; $6243
    ld d, a                                       ; $6245
    ld a, c                                       ; $6246
    ld [de], a                                    ; $6247
    ld a, e                                       ; $6248
    add $80                                       ; $6249
    ld e, a                                       ; $624B
    ld a, c                                       ; $624C
    ld [de], a                                    ; $624D
    ld a, d                                       ; $624E
    sub $07                                       ; $624F
    ld d, a                                       ; $6251
    inc e                                         ; $6252
    ld a, l                                       ; $6253
    sub $0f                                       ; $6254
    ld l, a                                       ; $6256
    ld c, [hl]                                    ; $6257
    ld a, [bc]                                    ; $6258
    swap a                                        ; $6259
    ldh [hScratchC], a                            ; $625B
    ld a, l                                       ; $625D
    add $10                                       ; $625E
    ld l, a                                       ; $6260
    ld c, [hl]                                    ; $6261
    ld a, [bc]                                    ; $6262
    ld c, a                                       ; $6263
    ldh a, [hScratchC]                            ; $6264
    or c                                          ; $6266
    ld c, a                                       ; $6267
    ld [de], a                                    ; $6268
    ld a, e                                       ; $6269
    add $80                                       ; $626A
    ld e, a                                       ; $626C
    ld a, c                                       ; $626D
    ld [de], a                                    ; $626E
    ld a, d                                       ; $626F
    add $07                                       ; $6270
    ld d, a                                       ; $6272
    ld a, c                                       ; $6273
    ld [de], a                                    ; $6274
    ld a, e                                       ; $6275
    add $80                                       ; $6276
    ld e, a                                       ; $6278
    ld a, c                                       ; $6279
    ld [de], a                                    ; $627A
    ld a, d                                       ; $627B
    sub $07                                       ; $627C
    ld d, a                                       ; $627E
    inc e                                         ; $627F
    ld a, l                                       ; $6280
    sub $0d                                       ; $6281
    ld l, a                                       ; $6283
    ldh a, [hScratchD]                            ; $6284
    dec a                                         ; $6286
    ldh [hScratchD], a                            ; $6287
    jr nz, jr_004_622a                            ; $6289

    ldh a, [hScratchB]                            ; $628B
    dec a                                         ; $628D
    jr z, jr_004_629a                             ; $628E

    ldh [hScratchB], a                            ; $6290
    dec h                                         ; $6292
    ld a, l                                       ; $6293
    add $10                                       ; $6294
    ld l, a                                       ; $6296
    jp Fx08_Reduce2xTile2x2_GroupTop              ; $6297


jr_004_629a:
    ldh a, [hScratchA]                            ; $629A
    dec a                                         ; $629C
    ret z                                         ; $629D

    ldh [hScratchA], a                            ; $629E
    inc d                                         ; $62A0
    ld a, e                                       ; $62A1
    add $80                                       ; $62A2
    ld e, a                                       ; $62A4
    inc h                                         ; $62A5
    ld l, $00                                     ; $62A6
    jp Jump_004_61b8                              ; $62A8


; C: entry $09 of the effect table 04:5E8A, the same entry as the Japanese 0A:583B Fx09_Reduce2xQuadTL (the two tables
; pair one to one); same code shape
Fx09_Reduce2xQuadTL::
    ld de, $c000                                  ; $62AB
    jp Jump_004_72d6                              ; $62AE


; C: entry $0A of the effect table 04:5E8A, the same entry as the Japanese 0A:5841 Fx0A_Reduce2xQuadTR (the two tables
; pair one to one); same code shape
Fx0A_Reduce2xQuadTR::
    ld de, $c080                                  ; $62B1
    jp Jump_004_72d6                              ; $62B4


; C: entry $0B of the effect table 04:5E8A, the same entry as the Japanese 0A:5847 Fx0B_Reduce2xQuadBL (the two tables
; pair one to one); same code shape
Fx0B_Reduce2xQuadBL::
    ld de, $c700                                  ; $62B7
    jp Jump_004_72d6                              ; $62BA


; C: entry $0C of the effect table 04:5E8A, the same entry as the Japanese 0A:584D Fx0C_Reduce2xQuadBR (the two tables
; pair one to one); same code shape
Fx0C_Reduce2xQuadBR::
    ld de, $c780                                  ; $62BD
    jp Jump_004_72d6                              ; $62C0


; C: same code as the Japanese Fx0D_CopyLeftHalf (0A:5853, 87 bytes, masked match)
Fx0D_CopyLeftHalf::
    ld hl, $a100                                  ; $62C3
    ld de, wPhotoImage                            ; $62C6
    ld a, $0e                                     ; $62C9
    ldh [hScratchA], a                            ; $62CB

jr_004_62cd:
    ld a, $08                                     ; $62CD
    ldh [hScratchB], a                            ; $62CF

jr_004_62d1:
    REPT 16                                       ; $62D1
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hScratchB]                            ; $6301
    dec a                                         ; $6303
    jr z, jr_004_630a                             ; $6304

    ldh [hScratchB], a                            ; $6306
    jr jr_004_62d1                                ; $6308

jr_004_630a:
    ldh a, [hScratchA]                            ; $630A
    dec a                                         ; $630C
    ret z                                         ; $630D

    ldh [hScratchA], a                            ; $630E
    ld a, e                                       ; $6310
    add $80                                       ; $6311
    ld e, a                                       ; $6313
    inc d                                         ; $6314
    inc h                                         ; $6315
    ld l, $00                                     ; $6316
    jr jr_004_62cd                                ; $6318

; C: same code as the Japanese Fx0E_CopyRightHalf (0A:58AA, 86 bytes, masked match)
Fx0E_CopyRightHalf::
    ld hl, $a180                                  ; $631A
    ld de, wPhotoImage + $80                      ; $631D
    ld a, $0e                                     ; $6320
    ldh [hScratchA], a                            ; $6322

jr_004_6324:
    ld a, $08                                     ; $6324
    ldh [hScratchB], a                            ; $6326

jr_004_6328:
    REPT 16                                       ; $6328
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hScratchB]                            ; $6358
    dec a                                         ; $635A
    jr z, jr_004_6361                             ; $635B

    ldh [hScratchB], a                            ; $635D
    jr jr_004_6328                                ; $635F

jr_004_6361:
    ldh a, [hScratchA]                            ; $6361
    dec a                                         ; $6363
    ret z                                         ; $6364

    ldh [hScratchA], a                            ; $6365
    inc d                                         ; $6367
    ld a, e                                       ; $6368
    add $80                                       ; $6369
    ld e, a                                       ; $636B
    ld l, $80                                     ; $636C
    jr jr_004_6324                                ; $636E

; C: entry $0F of the effect table 04:5E8A, the same entry as the Japanese 0A:5900 Fx0F_CopyTopHalf (the two tables
; pair one to one); same code shape
Fx0F_CopyTopHalf::
    ld hl, $a100                                  ; $6370
    ld de, wPhotoImage                            ; $6373
    ld b, $07                                     ; $6376
    call Cam_CopyTileRows                         ; $6378
    ret                                           ; $637B


; C: entry $10 of the effect table 04:5E8A, the same entry as the Japanese 0A:590C Fx10_CopyBottomHalf (the two tables
; pair one to one); same code shape
Fx10_CopyBottomHalf::
    ld hl, $a800                                  ; $637C
    ld de, $c700                                  ; $637F
    ld b, $07                                     ; $6382
    call Cam_CopyTileRows                         ; $6384
    ret                                           ; $6387


; C: same code as the Japanese Fx11_CopyQuads_TR_BL (0A:5918, 137 bytes, exact match)
Fx11_CopyQuads_TR_BL::
    ld hl, $a180                                  ; $6388
    ld de, wPhotoImage + $80                      ; $638B
    ld c, $07                                     ; $638E

jr_004_6390:
    ld b, $08                                     ; $6390

jr_004_6392:
    REPT 16                                       ; $6392
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    dec b                                         ; $63C2
    jr nz, jr_004_6392                            ; $63C3

    dec c                                         ; $63C5
    jr z, jr_004_63cf                             ; $63C6

    inc d                                         ; $63C8
    ld e, $80                                     ; $63C9
    ld l, $80                                     ; $63CB
    jr jr_004_6390                                ; $63CD

jr_004_63cf:
    inc d                                         ; $63CF
    ld c, $07                                     ; $63D0

jr_004_63d2:
    ld b, $08                                     ; $63D2

jr_004_63d4:
    REPT 16                                       ; $63D4
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    dec b                                         ; $6404
    jr nz, jr_004_63d4                            ; $6405

    dec c                                         ; $6407
    ret z                                         ; $6408

    inc d                                         ; $6409
    ld e, $00                                     ; $640A
    inc h                                         ; $640C
    ld l, $00                                     ; $640D
    jr jr_004_63d2                                ; $640F

; C: same code as the Japanese Fx12_CopyQuads_TR_BL_BR (0A:59A1, 72 bytes, masked match)
Fx12_CopyQuads_TR_BL_BR::
    ld hl, $a180                                  ; $6411
    ld de, wPhotoImage + $80                      ; $6414
    ld c, $07                                     ; $6417

jr_004_6419:
    ld b, $08                                     ; $6419

jr_004_641b:
    REPT 16                                       ; $641B
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    dec b                                         ; $644B
    jr nz, jr_004_641b                            ; $644C

    dec c                                         ; $644E
    jp z, Fx10_CopyBottomHalf                     ; $644F

    inc d                                         ; $6452
    ld e, $80                                     ; $6453
    ld l, $80                                     ; $6455
    jr jr_004_6419                                ; $6457

; C: entry $13 of the effect table 04:5E8A, the same entry as the Japanese 0A:59E9 Fx13_CopyTop10Rows (the two tables
; pair one to one); same code shape
Fx13_CopyTop10Rows::
    ld hl, $a100                                  ; $6459
    ld de, wPhotoImage                            ; $645C
    ld b, $0a                                     ; $645F
    call Cam_CopyTileRows                         ; $6461
    ret                                           ; $6464


; C: entry $14 of the effect table 04:5E8A, the same entry as the Japanese 0A:59F5 Fx14_CopyBottom4Rows (the two
; tables pair one to one); same code shape
Fx14_CopyBottom4Rows::
    ld hl, $ab00                                  ; $6465
    ld de, $ca00                                  ; $6468
    ld b, $04                                     ; $646B
    call Cam_CopyTileRows                         ; $646D
    ret                                           ; $6470


; C: entry $15 of the effect table 04:5E8A, the same entry as the Japanese 0A:5A01 Fx15_CopyTop4Rows (the two tables
; pair one to one); same code shape
Fx15_CopyTop4Rows::
    ld hl, $a100                                  ; $6471
    ld de, $c000                                  ; $6474
    ld b, $04                                     ; $6477
    call Cam_CopyTileRows                         ; $6479
    ret                                           ; $647C


; C: entry $16 of the effect table 04:5E8A, the same entry as the Japanese 0A:5A0D Fx16_CopyBottom10Rows (the two
; tables pair one to one); same code shape
Fx16_CopyBottom10Rows::
    ld hl, $a500                                  ; $647D
    ld de, $c400                                  ; $6480
    ld b, $0a                                     ; $6483
    call Cam_CopyTileRows                         ; $6485
    ret                                           ; $6488


; C: same code as the Japanese Fx17_CopyWindow (0A:5A19, 87 bytes, masked match)
Fx17_CopyWindow::
    ld hl, $a430                                  ; $6489
    ld de, $c330                                  ; $648C
    ld a, $08                                     ; $648F
    ldh [hScratchA], a                            ; $6491

jr_004_6493:
    ld a, $0a                                     ; $6493
    ldh [hScratchB], a                            ; $6495

jr_004_6497:
    REPT 16                                       ; $6497
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    ldh a, [hScratchB]                            ; $64C7
    dec a                                         ; $64C9
    jr z, jr_004_64d0                             ; $64CA

    ldh [hScratchB], a                            ; $64CC
    jr jr_004_6497                                ; $64CE

jr_004_64d0:
    ldh a, [hScratchA]                            ; $64D0
    dec a                                         ; $64D2
    ret z                                         ; $64D3

    ldh [hScratchA], a                            ; $64D4
    ld a, e                                       ; $64D6
    add $60                                       ; $64D7
    ld e, a                                       ; $64D9
    inc d                                         ; $64DA
    inc h                                         ; $64DB
    ld l, $30                                     ; $64DC
    jr jr_004_6493                                ; $64DE

; C: same code as the Japanese Fx18_CopyQuadBR (0A:5A70, 70 bytes, exact match)
Fx18_CopyQuadBR::
    ld hl, $a880                                  ; $64E0
    ld de, $c780                                  ; $64E3
    ld c, $07                                     ; $64E6

jr_004_64e8:
    ld b, $08                                     ; $64E8

jr_004_64ea:
    REPT 16                                       ; $64EA
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 16 copies of 3 bytes
    dec b                                         ; $651A
    jr nz, jr_004_64ea                            ; $651B

    dec c                                         ; $651D
    ret z                                         ; $651E

    inc d                                         ; $651F
    ld e, $80                                     ; $6520
    ld l, $80                                     ; $6522
    jr jr_004_64e8                                ; $6524

; C: entry $19 of the effect table 04:5E8A, the same entry as the Japanese 0A:5AB6 Fx19_Nop (the two tables pair one
; to one); ret
Fx19_Nop::
    ret                                           ; $6526


; C: entry $1A of the effect table 04:5E8A, the same entry as the Japanese 0A:5AB7 Fx1A_Nop (the two tables pair one
; to one); ret
Fx1A_Nop::
    ret                                           ; $6527


; C: entry $1B of the effect table 04:5E8A, the same entry as the Japanese 0A:5AB8 Fx1B_Nop (the two tables pair one
; to one); ret
Fx1B_Nop::
    ret                                           ; $6528


; C: entry $1C of the effect table 04:5E8A, the same entry as the Japanese 0A:5AB9 Fx1C_Nop (the two tables pair one
; to one); ret
Fx1C_Nop::
    ret                                           ; $6529


; C: entry $1D of the effect table 04:5E8A, the same entry as the Japanese 0A:5ABA Fx1D_Nop (the two tables pair one
; to one); ret
Fx1D_Nop::
    ret                                           ; $652A


; C: entry $1E of the effect table 04:5E8A, the same entry as the Japanese 0A:5ABB Fx1E_Nop (the two tables pair one
; to one); ret
Fx1E_Nop::
    ret                                           ; $652B


; C: entry $1F of the effect table 04:5E8A, the same entry as the Japanese 0A:5ABC Fx1F_Nop (the two tables pair one
; to one); ret
Fx1F_Nop::
    ret                                           ; $652C


; C: entry $20 of the effect table 04:5E8A, the same entry as the Japanese 0A:5ABD Fx20_FlipH (the two tables pair one
; to one); same code shape
Fx20_FlipH::
    ld hl, $a100                                  ; $652D
    ld de, $c0f0                                  ; $6530
    ld b, $41                                     ; $6533
    ld a, $0e                                     ; $6535
    ldh [hScratchA], a                            ; $6537

Jump_004_6539:
    ld a, $10                                     ; $6539
    ldh [hScratchB], a                            ; $653B

; C: same code as the Japanese Fx20_FlipH_GroupTop (0A:5ACD, 106 bytes, masked match)
Fx20_FlipH_GroupTop::
    ld a, [hl+]                                   ; $653D
    ld c, a                                       ; $653E
    ld a, [bc]                                    ; $653F
    ld [de], a                                    ; $6540
    inc e                                         ; $6541
    ld a, [hl+]                                   ; $6542
    ld c, a                                       ; $6543
    ld a, [bc]                                    ; $6544
    ld [de], a                                    ; $6545
    inc e                                         ; $6546
    ld a, [hl+]                                   ; $6547
    ld c, a                                       ; $6548
    ld a, [bc]                                    ; $6549
    ld [de], a                                    ; $654A
    inc e                                         ; $654B
    ld a, [hl+]                                   ; $654C
    ld c, a                                       ; $654D
    ld a, [bc]                                    ; $654E
    ld [de], a                                    ; $654F
    inc e                                         ; $6550
    ld a, [hl+]                                   ; $6551
    ld c, a                                       ; $6552
    ld a, [bc]                                    ; $6553
    ld [de], a                                    ; $6554
    inc e                                         ; $6555
    ld a, [hl+]                                   ; $6556
    ld c, a                                       ; $6557
    ld a, [bc]                                    ; $6558
    ld [de], a                                    ; $6559
    inc e                                         ; $655A
    ld a, [hl+]                                   ; $655B
    ld c, a                                       ; $655C
    ld a, [bc]                                    ; $655D
    ld [de], a                                    ; $655E
    inc e                                         ; $655F
    ld a, [hl+]                                   ; $6560
    ld c, a                                       ; $6561
    ld a, [bc]                                    ; $6562
    ld [de], a                                    ; $6563
    inc e                                         ; $6564
    ld a, [hl+]                                   ; $6565
    ld c, a                                       ; $6566
    ld a, [bc]                                    ; $6567
    ld [de], a                                    ; $6568
    inc e                                         ; $6569
    ld a, [hl+]                                   ; $656A
    ld c, a                                       ; $656B
    ld a, [bc]                                    ; $656C
    ld [de], a                                    ; $656D
    inc e                                         ; $656E
    ld a, [hl+]                                   ; $656F
    ld c, a                                       ; $6570
    ld a, [bc]                                    ; $6571
    ld [de], a                                    ; $6572
    inc e                                         ; $6573
    ld a, [hl+]                                   ; $6574
    ld c, a                                       ; $6575
    ld a, [bc]                                    ; $6576
    ld [de], a                                    ; $6577
    inc e                                         ; $6578
    ld a, [hl+]                                   ; $6579
    ld c, a                                       ; $657A
    ld a, [bc]                                    ; $657B
    ld [de], a                                    ; $657C
    inc e                                         ; $657D
    ld a, [hl+]                                   ; $657E
    ld c, a                                       ; $657F
    ld a, [bc]                                    ; $6580
    ld [de], a                                    ; $6581
    inc e                                         ; $6582
    ld a, [hl+]                                   ; $6583
    ld c, a                                       ; $6584
    ld a, [bc]                                    ; $6585
    ld [de], a                                    ; $6586
    inc e                                         ; $6587
    ld a, [hl+]                                   ; $6588
    ld c, a                                       ; $6589
    ld a, [bc]                                    ; $658A
    ld [de], a                                    ; $658B
    inc e                                         ; $658C
    ldh a, [hScratchB]                            ; $658D
    dec a                                         ; $658F
    jr z, jr_004_659b                             ; $6590

    ldh [hScratchB], a                            ; $6592
    ld a, e                                       ; $6594
    sub $20                                       ; $6595
    ld e, a                                       ; $6597
    jp Fx20_FlipH_GroupTop                        ; $6598


jr_004_659b:
    ldh a, [hScratchA]                            ; $659B
    dec a                                         ; $659D
    ret z                                         ; $659E

    ldh [hScratchA], a                            ; $659F
    inc d                                         ; $65A1
    ld e, $f0                                     ; $65A2
    jp Jump_004_6539                              ; $65A4


; C: entry $23 of the effect table 04:5E8A, the same entry as the Japanese 0A:5B37 Fx23_MirrorBtoT_OnFlipH (the two
; tables pair one to one); same code shape
Fx23_MirrorBtoT_OnFlipH::
    ld hl, $a800                                  ; $65A7
    ld de, $c7f0                                  ; $65AA
    ld bc, $c6fe                                  ; $65AD
    ld a, $07                                     ; $65B0
    ldh [hScratchA], a                            ; $65B2

jr_004_65b4:
    ld a, $10                                     ; $65B4
    ldh [hScratchB], a                            ; $65B6

jr_004_65b8:
    ld a, $08                                     ; $65B8
    ldh [hScratchD], a                            ; $65BA

jr_004_65bc:
    ld a, [hl+]                                   ; $65BC
    push hl                                       ; $65BD
    ld l, a                                       ; $65BE
    ld h, $41                                     ; $65BF
    ld a, [hl]                                    ; $65C1
    pop hl                                        ; $65C2
    ld [de], a                                    ; $65C3
    ld [bc], a                                    ; $65C4
    inc e                                         ; $65C5
    inc c                                         ; $65C6
    ld a, [hl+]                                   ; $65C7
    push hl                                       ; $65C8
    ld l, a                                       ; $65C9
    ld h, $41                                     ; $65CA
    ld a, [hl]                                    ; $65CC
    pop hl                                        ; $65CD
    ld [de], a                                    ; $65CE
    ld [bc], a                                    ; $65CF
    inc e                                         ; $65D0
    dec c                                         ; $65D1
    dec c                                         ; $65D2
    dec c                                         ; $65D3
    ldh a, [hScratchD]                            ; $65D4
    dec a                                         ; $65D6
    ldh [hScratchD], a                            ; $65D7
    jr nz, jr_004_65bc                            ; $65D9

    ldh a, [hScratchB]                            ; $65DB
    dec a                                         ; $65DD
    jr z, jr_004_65e8                             ; $65DE

    ldh [hScratchB], a                            ; $65E0
    ld a, e                                       ; $65E2
    sub $20                                       ; $65E3
    ld e, a                                       ; $65E5
    jr jr_004_65b8                                ; $65E6

jr_004_65e8:
    ldh a, [hScratchA]                            ; $65E8
    dec a                                         ; $65EA
    ret z                                         ; $65EB

    ldh [hScratchA], a                            ; $65EC
    ld e, $f0                                     ; $65EE
    inc d                                         ; $65F0
    ld c, $fe                                     ; $65F1
    dec b                                         ; $65F3
    jr jr_004_65b4                                ; $65F4

; C: entry $24 of the effect table 04:5E8A, the same entry as the Japanese 0A:5B86 Fx24_MirrorTtoB_OnFlipH (the two
; tables pair one to one); same code shape
Fx24_MirrorTtoB_OnFlipH::
    ld hl, $a100                                  ; $65F6
    ld de, $c0f0                                  ; $65F9
    ld bc, $cdfe                                  ; $65FC
    ld a, $07                                     ; $65FF
    ldh [hScratchA], a                            ; $6601

jr_004_6603:
    ld a, $10                                     ; $6603
    ldh [hScratchB], a                            ; $6605

jr_004_6607:
    ld a, $08                                     ; $6607
    ldh [hScratchD], a                            ; $6609

jr_004_660b:
    ld a, [hl+]                                   ; $660B
    push hl                                       ; $660C
    ld l, a                                       ; $660D
    ld h, $41                                     ; $660E
    ld a, [hl]                                    ; $6610
    pop hl                                        ; $6611
    ld [de], a                                    ; $6612
    ld [bc], a                                    ; $6613
    inc e                                         ; $6614
    inc c                                         ; $6615
    ld a, [hl+]                                   ; $6616
    push hl                                       ; $6617
    ld l, a                                       ; $6618
    ld h, $41                                     ; $6619
    ld a, [hl]                                    ; $661B
    pop hl                                        ; $661C
    ld [de], a                                    ; $661D
    ld [bc], a                                    ; $661E
    inc e                                         ; $661F
    dec c                                         ; $6620
    dec c                                         ; $6621
    dec c                                         ; $6622
    ldh a, [hScratchD]                            ; $6623
    dec a                                         ; $6625
    ldh [hScratchD], a                            ; $6626
    jr nz, jr_004_660b                            ; $6628

    ldh a, [hScratchB]                            ; $662A
    dec a                                         ; $662C
    jr z, jr_004_6637                             ; $662D

    ldh [hScratchB], a                            ; $662F
    ld a, e                                       ; $6631
    sub $20                                       ; $6632
    ld e, a                                       ; $6634
    jr jr_004_6607                                ; $6635

jr_004_6637:
    ldh a, [hScratchA]                            ; $6637
    dec a                                         ; $6639
    ret z                                         ; $663A

    ldh [hScratchA], a                            ; $663B
    ld e, $f0                                     ; $663D
    inc d                                         ; $663F
    ld c, $fe                                     ; $6640
    dec b                                         ; $6642
    jr jr_004_6603                                ; $6643

; C: same instructions as the Japanese Fx25_StretchV2x_OnFlipH (0A:5BD5) over the whole routine (64 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx25_StretchV2x_OnFlipH::
    ld hl, $a400                                  ; $6645
    ld de, wPhotoImage + $f0                      ; $6648
    ld b, $41                                     ; $664B
    ld a, $07                                     ; $664D
    ldh [hScratchA], a                            ; $664F

jr_004_6651:
    ld a, $10                                     ; $6651
    ldh [hScratchB], a                            ; $6653

jr_004_6655:
    ld a, $04                                     ; $6655
    ldh [hScratchD], a                            ; $6657

jr_004_6659:
    ld a, [hl+]                                   ; $6659
    ld c, a                                       ; $665A
    ld a, [bc]                                    ; $665B
    ld [de], a                                    ; $665C
    inc e                                         ; $665D
    inc e                                         ; $665E
    ld [de], a                                    ; $665F
    dec e                                         ; $6660
    ld a, [hl+]                                   ; $6661
    ld c, a                                       ; $6662
    ld a, [bc]                                    ; $6663
    ld [de], a                                    ; $6664
    inc e                                         ; $6665
    inc e                                         ; $6666
    ld [de], a                                    ; $6667
    inc e                                         ; $6668
    ldh a, [hScratchD]                            ; $6669
    dec a                                         ; $666B
    ldh [hScratchD], a                            ; $666C
    jr nz, jr_004_6659                            ; $666E

    inc d                                         ; $6670
    ld a, e                                       ; $6671
    sub $10                                       ; $6672
    ld e, a                                       ; $6674
    ld a, $04                                     ; $6675
    ldh [hScratchD], a                            ; $6677

jr_004_6679:
    ld a, [hl+]                                   ; $6679
    ld c, a                                       ; $667A
    ld a, [bc]                                    ; $667B
    ld [de], a                                    ; $667C
    inc e                                         ; $667D
    inc e                                         ; $667E
    ld [de], a                                    ; $667F
    dec e                                         ; $6680
    ld a, [hl+]                                   ; $6681
    ld c, a                                       ; $6682
    ld a, [bc]                                    ; $6683
    ld [de], a                                    ; $6684
    inc e                                         ; $6685
    inc e                                         ; $6686
    ld [de], a                                    ; $6687
    inc e                                         ; $6688
    ldh a, [hScratchD]                            ; $6689
    dec a                                         ; $668B
    ldh [hScratchD], a                            ; $668C
    jr nz, jr_004_6679                            ; $668E

    dec d                                         ; $6690
    ldh a, [hScratchB]                            ; $6691
    dec a                                         ; $6693
    jr z, jr_004_669e                             ; $6694

    ldh [hScratchB], a                            ; $6696
    ld a, e                                       ; $6698
    sub $20                                       ; $6699
    ld e, a                                       ; $669B
    jr jr_004_6655                                ; $669C

jr_004_669e:
    ldh a, [hScratchA]                            ; $669E
    dec a                                         ; $66A0
    ret z                                         ; $66A1

    ldh [hScratchA], a                            ; $66A2
    inc d                                         ; $66A4
    inc d                                         ; $66A5
    ld e, $f0                                     ; $66A6
    jr jr_004_6651                                ; $66A8

; C: same instructions as the Japanese Fx26_StretchH2x_OnFlipH (0A:5C3A) over the whole routine (34 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx26_StretchH2x_OnFlipH::
    ld hl, $a140                                  ; $66AA
    ld de, wPhotoImage + $f0                      ; $66AD
    ld a, $0e                                     ; $66B0
    ldh [hScratchA], a                            ; $66B2

jr_004_66b4:
    ld a, $08                                     ; $66B4
    ldh [hScratchB], a                            ; $66B6

jr_004_66b8:
    ld a, $10                                     ; $66B8
    ldh [hScratchD], a                            ; $66BA

jr_004_66bc:
    ld a, [hl+]                                   ; $66BC
    ld c, a                                       ; $66BD
    ld b, $44                                     ; $66BE
    ld a, [bc]                                    ; $66C0
    ld [de], a                                    ; $66C1
    ld a, e                                       ; $66C2
    sub $10                                       ; $66C3
    ld e, a                                       ; $66C5
    ld b, $45                                     ; $66C6
    ld a, [bc]                                    ; $66C8
    ld [de], a                                    ; $66C9
    ld a, e                                       ; $66CA
    add $11                                       ; $66CB
    ld e, a                                       ; $66CD
    ldh a, [hScratchD]                            ; $66CE
    dec a                                         ; $66D0
    ldh [hScratchD], a                            ; $66D1
    jr nz, jr_004_66bc                            ; $66D3

    ld a, e                                       ; $66D5
    sub $30                                       ; $66D6
    ld e, a                                       ; $66D8
    ldh a, [hScratchB]                            ; $66D9
    dec a                                         ; $66DB
    jr z, jr_004_66e2                             ; $66DC

    ldh [hScratchB], a                            ; $66DE
    jr jr_004_66b8                                ; $66E0

jr_004_66e2:
    ldh a, [hScratchA]                            ; $66E2
    dec a                                         ; $66E4
    ret z                                         ; $66E5

    ldh [hScratchA], a                            ; $66E6
    inc d                                         ; $66E8
    ld e, $f0                                     ; $66E9
    inc h                                         ; $66EB
    ld l, $40                                     ; $66EC
    jr jr_004_66b4                                ; $66EE

; C: the Japanese Fx27_Zoom2x_OnFlipH_GroupTop (0A:5C8E), 111 instructions against 105, with 1 small edits (variables
; moved between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code
; compared
Fx27_Zoom2x_OnFlipH_GroupTop::
    ld hl, $a440                                  ; $66F0
    ld de, $c0f0                                  ; $66F3
    ld a, $07                                     ; $66F6
    ldh [hScratchA], a                            ; $66F8

Jump_004_66fa:
    ld a, $08                                     ; $66FA
    ldh [hScratchB], a                            ; $66FC

Jump_004_66fe:
    ld a, $04                                     ; $66FE
    ldh [hScratchD], a                            ; $6700

jr_004_6702:
    ld a, [hl+]                                   ; $6702
    ld c, a                                       ; $6703
    ld b, $44                                     ; $6704
    ld a, [bc]                                    ; $6706
    ld [de], a                                    ; $6707
    inc e                                         ; $6708
    inc e                                         ; $6709
    ld [de], a                                    ; $670A
    ld a, e                                       ; $670B
    sub $12                                       ; $670C
    ld e, a                                       ; $670E
    ld b, $45                                     ; $670F
    ld a, [bc]                                    ; $6711
    ld [de], a                                    ; $6712
    inc e                                         ; $6713
    inc e                                         ; $6714
    ld [de], a                                    ; $6715
    ld a, e                                       ; $6716
    add $0f                                       ; $6717
    ld e, a                                       ; $6719
    ld a, [hl+]                                   ; $671A
    ld c, a                                       ; $671B
    ld b, $44                                     ; $671C
    ld a, [bc]                                    ; $671E
    ld [de], a                                    ; $671F
    inc e                                         ; $6720
    inc e                                         ; $6721
    ld [de], a                                    ; $6722
    ld a, e                                       ; $6723
    sub $12                                       ; $6724
    ld e, a                                       ; $6726
    ld b, $45                                     ; $6727
    ld a, [bc]                                    ; $6729
    ld [de], a                                    ; $672A
    inc e                                         ; $672B
    inc e                                         ; $672C
    ld [de], a                                    ; $672D
    ld a, e                                       ; $672E
    add $11                                       ; $672F
    ld e, a                                       ; $6731
    ldh a, [hScratchD]                            ; $6732
    dec a                                         ; $6734
    ldh [hScratchD], a                            ; $6735
    jr nz, jr_004_6702                            ; $6737

    inc d                                         ; $6739
    ld a, e                                       ; $673A
    sub $10                                       ; $673B
    ld e, a                                       ; $673D
    ld a, $04                                     ; $673E
    ldh [hScratchD], a                            ; $6740

jr_004_6742:
    ld a, [hl+]                                   ; $6742
    ld c, a                                       ; $6743
    ld b, $44                                     ; $6744
    ld a, [bc]                                    ; $6746
    ld [de], a                                    ; $6747
    inc e                                         ; $6748
    inc e                                         ; $6749
    ld [de], a                                    ; $674A
    ld a, e                                       ; $674B
    sub $12                                       ; $674C
    ld e, a                                       ; $674E
    ld b, $45                                     ; $674F
    ld a, [bc]                                    ; $6751
    ld [de], a                                    ; $6752
    inc e                                         ; $6753
    inc e                                         ; $6754
    ld [de], a                                    ; $6755
    ld a, e                                       ; $6756
    add $0f                                       ; $6757
    ld e, a                                       ; $6759
    ld a, [hl+]                                   ; $675A
    ld c, a                                       ; $675B
    ld b, $44                                     ; $675C
    ld a, [bc]                                    ; $675E
    ld [de], a                                    ; $675F
    inc e                                         ; $6760
    inc e                                         ; $6761
    ld [de], a                                    ; $6762
    ld a, e                                       ; $6763
    sub $12                                       ; $6764
    ld e, a                                       ; $6766
    ld b, $45                                     ; $6767
    ld a, [bc]                                    ; $6769
    ld [de], a                                    ; $676A
    inc e                                         ; $676B
    inc e                                         ; $676C
    ld [de], a                                    ; $676D
    ld a, e                                       ; $676E
    add $11                                       ; $676F
    ld e, a                                       ; $6771
    ldh a, [hScratchD]                            ; $6772
    dec a                                         ; $6774
    ldh [hScratchD], a                            ; $6775
    jr nz, jr_004_6742                            ; $6777

    ldh a, [hScratchB]                            ; $6779
    dec a                                         ; $677B
    jr z, jr_004_6788                             ; $677C

    ldh [hScratchB], a                            ; $677E
    dec d                                         ; $6780
    ld a, e                                       ; $6781
    sub $30                                       ; $6782
    ld e, a                                       ; $6784
    jp Jump_004_66fe                              ; $6785


jr_004_6788:
    ldh a, [hScratchA]                            ; $6788
    dec a                                         ; $678A
    ret z                                         ; $678B

    ldh [hScratchA], a                            ; $678C
    inc h                                         ; $678E
    ld l, $40                                     ; $678F
    inc d                                         ; $6791
    ld e, $f0                                     ; $6792
    jp Jump_004_66fa                              ; $6794


; C: entry $28 of the effect table 04:5E8A, the same entry as the Japanese 0A:5D27 Fx28_Reduce2xTile2x2_FlipH (the two
; tables pair one to one); same code shape
Fx28_Reduce2xTile2x2_FlipH::
    ld hl, $a100                                  ; $6797
    ld de, $c070                                  ; $679A
    ld b, $47                                     ; $679D
    ld a, $07                                     ; $679F
    ldh [hScratchA], a                            ; $67A1

Jump_004_67a3:
    ld a, $08                                     ; $67A3
    ldh [hScratchB], a                            ; $67A5

; C: same code as the Japanese Fx28_Reduce2xTile2x2_FlipH_GroupTop (0A:5D37, 241 bytes, masked match)
Fx28_Reduce2xTile2x2_FlipH_GroupTop::
    ld a, $04                                     ; $67A7
    ldh [hScratchD], a                            ; $67A9

jr_004_67ab:
    ld c, [hl]                                    ; $67AB
    ld a, [bc]                                    ; $67AC
    ldh [hScratchC], a                            ; $67AD
    ld a, l                                       ; $67AF
    add $10                                       ; $67B0
    ld l, a                                       ; $67B2
    ld c, [hl]                                    ; $67B3
    ld a, [bc]                                    ; $67B4
    swap a                                        ; $67B5
    ld c, a                                       ; $67B7
    ldh a, [hScratchC]                            ; $67B8
    or c                                          ; $67BA
    ld c, a                                       ; $67BB
    ld [de], a                                    ; $67BC
    ld a, e                                       ; $67BD
    add $80                                       ; $67BE
    ld e, a                                       ; $67C0
    ld a, c                                       ; $67C1
    ld [de], a                                    ; $67C2
    ld a, d                                       ; $67C3
    add $07                                       ; $67C4
    ld d, a                                       ; $67C6
    ld a, c                                       ; $67C7
    ld [de], a                                    ; $67C8
    ld a, e                                       ; $67C9
    sub $80                                       ; $67CA
    ld e, a                                       ; $67CC
    ld a, c                                       ; $67CD
    ld [de], a                                    ; $67CE
    ld a, d                                       ; $67CF
    sub $07                                       ; $67D0
    ld d, a                                       ; $67D2
    inc e                                         ; $67D3
    ld a, l                                       ; $67D4
    sub $0f                                       ; $67D5
    ld l, a                                       ; $67D7
    ld c, [hl]                                    ; $67D8
    ld a, [bc]                                    ; $67D9
    ldh [hScratchC], a                            ; $67DA
    ld a, l                                       ; $67DC
    add $10                                       ; $67DD
    ld l, a                                       ; $67DF
    ld c, [hl]                                    ; $67E0
    ld a, [bc]                                    ; $67E1
    swap a                                        ; $67E2
    ld c, a                                       ; $67E4
    ldh a, [hScratchC]                            ; $67E5
    or c                                          ; $67E7
    ld c, a                                       ; $67E8
    ld [de], a                                    ; $67E9
    ld a, e                                       ; $67EA
    add $80                                       ; $67EB
    ld e, a                                       ; $67ED
    ld a, c                                       ; $67EE
    ld [de], a                                    ; $67EF
    ld a, d                                       ; $67F0
    add $07                                       ; $67F1
    ld d, a                                       ; $67F3
    ld a, c                                       ; $67F4
    ld [de], a                                    ; $67F5
    ld a, e                                       ; $67F6
    sub $80                                       ; $67F7
    ld e, a                                       ; $67F9
    ld a, c                                       ; $67FA
    ld [de], a                                    ; $67FB
    ld a, d                                       ; $67FC
    sub $07                                       ; $67FD
    ld d, a                                       ; $67FF
    inc e                                         ; $6800
    ld a, l                                       ; $6801
    sub $0d                                       ; $6802
    ld l, a                                       ; $6804
    ldh a, [hScratchD]                            ; $6805
    dec a                                         ; $6807
    ldh [hScratchD], a                            ; $6808
    jr nz, jr_004_67ab                            ; $680A

    inc h                                         ; $680C
    ld a, l                                       ; $680D
    sub $10                                       ; $680E
    ld l, a                                       ; $6810
    ld a, $04                                     ; $6811
    ldh [hScratchD], a                            ; $6813

jr_004_6815:
    ld c, [hl]                                    ; $6815
    ld a, [bc]                                    ; $6816
    ldh [hScratchC], a                            ; $6817
    ld a, l                                       ; $6819
    add $10                                       ; $681A
    ld l, a                                       ; $681C
    ld c, [hl]                                    ; $681D
    ld a, [bc]                                    ; $681E
    swap a                                        ; $681F
    ld c, a                                       ; $6821
    ldh a, [hScratchC]                            ; $6822
    or c                                          ; $6824
    ld c, a                                       ; $6825
    ld [de], a                                    ; $6826
    ld a, e                                       ; $6827
    add $80                                       ; $6828
    ld e, a                                       ; $682A
    ld a, c                                       ; $682B
    ld [de], a                                    ; $682C
    ld a, d                                       ; $682D
    add $07                                       ; $682E
    ld d, a                                       ; $6830
    ld a, c                                       ; $6831
    ld [de], a                                    ; $6832
    ld a, e                                       ; $6833
    sub $80                                       ; $6834
    ld e, a                                       ; $6836
    ld a, c                                       ; $6837
    ld [de], a                                    ; $6838
    ld a, d                                       ; $6839
    sub $07                                       ; $683A
    ld d, a                                       ; $683C
    inc e                                         ; $683D
    ld a, l                                       ; $683E
    sub $0f                                       ; $683F
    ld l, a                                       ; $6841
    ld c, [hl]                                    ; $6842
    ld a, [bc]                                    ; $6843
    ldh [hScratchC], a                            ; $6844
    ld a, l                                       ; $6846
    add $10                                       ; $6847
    ld l, a                                       ; $6849
    ld c, [hl]                                    ; $684A
    ld a, [bc]                                    ; $684B
    swap a                                        ; $684C
    ld c, a                                       ; $684E
    ldh a, [hScratchC]                            ; $684F
    or c                                          ; $6851
    ld c, a                                       ; $6852
    ld [de], a                                    ; $6853
    ld a, e                                       ; $6854
    add $80                                       ; $6855
    ld e, a                                       ; $6857
    ld a, c                                       ; $6858
    ld [de], a                                    ; $6859
    ld a, d                                       ; $685A
    add $07                                       ; $685B
    ld d, a                                       ; $685D
    ld a, c                                       ; $685E
    ld [de], a                                    ; $685F
    ld a, e                                       ; $6860
    sub $80                                       ; $6861
    ld e, a                                       ; $6863
    ld a, c                                       ; $6864
    ld [de], a                                    ; $6865
    ld a, d                                       ; $6866
    sub $07                                       ; $6867
    ld d, a                                       ; $6869
    inc e                                         ; $686A
    ld a, l                                       ; $686B
    sub $0d                                       ; $686C
    ld l, a                                       ; $686E
    ldh a, [hScratchD]                            ; $686F
    dec a                                         ; $6871
    ldh [hScratchD], a                            ; $6872
    jr nz, jr_004_6815                            ; $6874

    ld a, e                                       ; $6876
    sub $20                                       ; $6877
    ld e, a                                       ; $6879
    ldh a, [hScratchB]                            ; $687A
    dec a                                         ; $687C
    jr z, jr_004_6889                             ; $687D

    ldh [hScratchB], a                            ; $687F
    dec h                                         ; $6881
    ld a, l                                       ; $6882
    add $10                                       ; $6883
    ld l, a                                       ; $6885
    jp Fx28_Reduce2xTile2x2_FlipH_GroupTop        ; $6886


jr_004_6889:
    ldh a, [hScratchA]                            ; $6889
    dec a                                         ; $688B
    ret z                                         ; $688C

    ldh [hScratchA], a                            ; $688D
    ld e, $70                                     ; $688F
    inc d                                         ; $6891
    inc h                                         ; $6892
    ld l, $00                                     ; $6893
    jp Jump_004_67a3                              ; $6895


; C: entry $29 of the effect table 04:5E8A, the same entry as the Japanese 0A:5E28 Fx29_Reduce2xQuadTL_FlipH (the two
; tables pair one to one); same code shape
Fx29_Reduce2xQuadTL_FlipH::
    ld de, $c070                                  ; $6898
    jp Jump_004_7376                              ; $689B


; C: entry $2A of the effect table 04:5E8A, the same entry as the Japanese 0A:5E2E Fx2A_Reduce2xQuadTR_FlipH (the two
; tables pair one to one); same code shape
Fx2A_Reduce2xQuadTR_FlipH::
    ld de, $c0f0                                  ; $689E
    jp Jump_004_7376                              ; $68A1


; C: entry $2B of the effect table 04:5E8A, the same entry as the Japanese 0A:5E34 Fx2B_Reduce2xQuadBL_FlipH (the two
; tables pair one to one); same code shape
Fx2B_Reduce2xQuadBL_FlipH::
    ld de, $c770                                  ; $68A4
    jp Jump_004_7376                              ; $68A7


; C: entry $2C of the effect table 04:5E8A, the same entry as the Japanese 0A:5E3A Fx2C_Reduce2xQuadBR_FlipH (the two
; tables pair one to one); same code shape
Fx2C_Reduce2xQuadBR_FlipH::
    ld de, $c7f0                                  ; $68AA
    jp Jump_004_7376                              ; $68AD


; C: same instructions as the Japanese Fx2D_CopyLeftHalf_OnFlipH (0A:5E40) over the whole routine (31 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx2D_CopyLeftHalf_OnFlipH::
    ld hl, $a180                                  ; $68B0
    ld de, wPhotoImage + $70                      ; $68B3
    ld b, $41                                     ; $68B6
    ld a, $0e                                     ; $68B8
    ldh [hScratchA], a                            ; $68BA

jr_004_68bc:
    ld a, $08                                     ; $68BC
    ldh [hScratchB], a                            ; $68BE

jr_004_68c0:
    ld a, $08                                     ; $68C0
    ldh [hScratchD], a                            ; $68C2

jr_004_68c4:
    ld a, [hl+]                                   ; $68C4
    ld c, a                                       ; $68C5
    ld a, [bc]                                    ; $68C6
    ld [de], a                                    ; $68C7
    inc e                                         ; $68C8
    ld a, [hl+]                                   ; $68C9
    ld c, a                                       ; $68CA
    ld a, [bc]                                    ; $68CB
    ld [de], a                                    ; $68CC
    inc e                                         ; $68CD
    ldh a, [hScratchD]                            ; $68CE
    dec a                                         ; $68D0
    ldh [hScratchD], a                            ; $68D1
    jr nz, jr_004_68c4                            ; $68D3

    ldh a, [hScratchB]                            ; $68D5
    dec a                                         ; $68D7
    jr z, jr_004_68e2                             ; $68D8

    ldh [hScratchB], a                            ; $68DA
    ld a, e                                       ; $68DC
    sub $20                                       ; $68DD
    ld e, a                                       ; $68DF
    jr jr_004_68c0                                ; $68E0

jr_004_68e2:
    ldh a, [hScratchA]                            ; $68E2
    dec a                                         ; $68E4
    ret z                                         ; $68E5

    ldh [hScratchA], a                            ; $68E6
    ld l, $80                                     ; $68E8
    inc d                                         ; $68EA
    ld e, $70                                     ; $68EB
    jr jr_004_68bc                                ; $68ED

; C: entry $2E of the effect table 04:5E8A, the same entry as the Japanese 0A:5E7F Fx2E_CopyRightHalf_OnFlipH (the two
; tables pair one to one); same code shape
Fx2E_CopyRightHalf_OnFlipH::
    ld hl, $a100                                  ; $68EF
    ld de, wPhotoImage + $f0                      ; $68F2
    ld b, $41                                     ; $68F5
    ld a, $0e                                     ; $68F7
    ldh [hScratchA], a                            ; $68F9

jr_004_68fb:
    ld a, $08                                     ; $68FB
    ldh [hScratchB], a                            ; $68FD

jr_004_68ff:
    ld a, $08                                     ; $68FF
    ldh [hScratchD], a                            ; $6901

jr_004_6903:
    ld a, [hl+]                                   ; $6903
    ld c, a                                       ; $6904
    ld a, [bc]                                    ; $6905
    ld [de], a                                    ; $6906
    inc e                                         ; $6907
    ld a, [hl+]                                   ; $6908
    ld c, a                                       ; $6909
    ld a, [bc]                                    ; $690A
    ld [de], a                                    ; $690B
    inc e                                         ; $690C
    ldh a, [hScratchD]                            ; $690D
    dec a                                         ; $690F
    ldh [hScratchD], a                            ; $6910
    jr nz, jr_004_6903                            ; $6912

    ldh a, [hScratchB]                            ; $6914
    dec a                                         ; $6916
    jr z, jr_004_6921                             ; $6917

    ldh [hScratchB], a                            ; $6919
    ld a, e                                       ; $691B
    sub $20                                       ; $691C
    ld e, a                                       ; $691E
    jr jr_004_68ff                                ; $691F

jr_004_6921:
    ldh a, [hScratchA]                            ; $6921
    dec a                                         ; $6923
    ret z                                         ; $6924

    ldh [hScratchA], a                            ; $6925
    inc h                                         ; $6927
    ld l, $00                                     ; $6928
    inc d                                         ; $692A
    ld e, $f0                                     ; $692B
    jr jr_004_68fb                                ; $692D

; C: entry $2F of the effect table 04:5E8A, the same entry as the Japanese 0A:5EBF Fx2F_CopyTopHalf_OnFlipH (the two
; tables pair one to one); same code shape
Fx2F_CopyTopHalf_OnFlipH::
    ld hl, $a100                                  ; $692F
    ld de, $c0f0                                  ; $6932
    ld b, $41                                     ; $6935
    ld a, $07                                     ; $6937
    ldh [hScratchA], a                            ; $6939

jr_004_693b:
    ld a, $10                                     ; $693B
    ldh [hScratchB], a                            ; $693D

jr_004_693f:
    ld a, $08                                     ; $693F
    ldh [hScratchD], a                            ; $6941

jr_004_6943:
    ld a, [hl+]                                   ; $6943
    ld c, a                                       ; $6944
    ld a, [bc]                                    ; $6945
    ld [de], a                                    ; $6946
    inc e                                         ; $6947
    ld a, [hl+]                                   ; $6948
    ld c, a                                       ; $6949
    ld a, [bc]                                    ; $694A
    ld [de], a                                    ; $694B
    inc e                                         ; $694C
    ldh a, [hScratchD]                            ; $694D
    dec a                                         ; $694F
    ldh [hScratchD], a                            ; $6950
    jr nz, jr_004_6943                            ; $6952

    ldh a, [hScratchB]                            ; $6954
    dec a                                         ; $6956
    jr z, jr_004_6961                             ; $6957

    ldh [hScratchB], a                            ; $6959
    ld a, e                                       ; $695B
    sub $20                                       ; $695C
    ld e, a                                       ; $695E
    jr jr_004_693f                                ; $695F

jr_004_6961:
    ldh a, [hScratchA]                            ; $6961
    dec a                                         ; $6963
    ret z                                         ; $6964

    ldh [hScratchA], a                            ; $6965
    inc d                                         ; $6967
    ld e, $f0                                     ; $6968
    jr jr_004_693b                                ; $696A

; C: entry $30 of the effect table 04:5E8A, the same entry as the Japanese 0A:5EFC Fx30_CopyBottomHalf_OnFlipH (the
; two tables pair one to one); same code shape
Fx30_CopyBottomHalf_OnFlipH::
    ld hl, $a800                                  ; $696C
    ld de, $c7f0                                  ; $696F
    ld b, $41                                     ; $6972
    ld a, $07                                     ; $6974
    ldh [hScratchA], a                            ; $6976

jr_004_6978:
    ld a, $10                                     ; $6978
    ldh [hScratchB], a                            ; $697A

jr_004_697c:
    ld a, $08                                     ; $697C
    ldh [hScratchD], a                            ; $697E

jr_004_6980:
    ld a, [hl+]                                   ; $6980
    ld c, a                                       ; $6981
    ld a, [bc]                                    ; $6982
    ld [de], a                                    ; $6983
    inc e                                         ; $6984
    ld a, [hl+]                                   ; $6985
    ld c, a                                       ; $6986
    ld a, [bc]                                    ; $6987
    ld [de], a                                    ; $6988
    inc e                                         ; $6989
    ldh a, [hScratchD]                            ; $698A
    dec a                                         ; $698C
    ldh [hScratchD], a                            ; $698D
    jr nz, jr_004_6980                            ; $698F

    ldh a, [hScratchB]                            ; $6991
    dec a                                         ; $6993
    jr z, jr_004_699e                             ; $6994

    ldh [hScratchB], a                            ; $6996
    ld a, e                                       ; $6998
    sub $20                                       ; $6999
    ld e, a                                       ; $699B
    jr jr_004_697c                                ; $699C

jr_004_699e:
    ldh a, [hScratchA]                            ; $699E
    dec a                                         ; $69A0
    ret z                                         ; $69A1

    ldh [hScratchA], a                            ; $69A2
    inc d                                         ; $69A4
    ld e, $f0                                     ; $69A5
    jr jr_004_6978                                ; $69A7

; C: same instructions as the Japanese Fx31_CopyQuads_TR_BL_OnFlipH (0A:5F39) over the whole routine (31 instructions,
; to the first ret / jp), only the addresses differ; code compared
Fx31_CopyQuads_TR_BL_OnFlipH::
    ld hl, $a100                                  ; $69A9
    ld de, wPhotoImage + $f0                      ; $69AC
    ld b, $41                                     ; $69AF
    ld a, $07                                     ; $69B1
    ldh [hScratchA], a                            ; $69B3

jr_004_69b5:
    ld a, $08                                     ; $69B5
    ldh [hScratchB], a                            ; $69B7

jr_004_69b9:
    ld a, $08                                     ; $69B9
    ldh [hScratchD], a                            ; $69BB

jr_004_69bd:
    ld a, [hl+]                                   ; $69BD
    ld c, a                                       ; $69BE
    ld a, [bc]                                    ; $69BF
    ld [de], a                                    ; $69C0
    inc e                                         ; $69C1
    ld a, [hl+]                                   ; $69C2
    ld c, a                                       ; $69C3
    ld a, [bc]                                    ; $69C4
    ld [de], a                                    ; $69C5
    inc e                                         ; $69C6
    ldh a, [hScratchD]                            ; $69C7
    dec a                                         ; $69C9
    ldh [hScratchD], a                            ; $69CA
    jr nz, jr_004_69bd                            ; $69CC

    ldh a, [hScratchB]                            ; $69CE
    dec a                                         ; $69D0
    jr z, jr_004_69db                             ; $69D1

    ldh [hScratchB], a                            ; $69D3
    ld a, e                                       ; $69D5
    sub $20                                       ; $69D6
    ld e, a                                       ; $69D8
    jr jr_004_69b9                                ; $69D9

jr_004_69db:
    ldh a, [hScratchA]                            ; $69DB
    dec a                                         ; $69DD
    jr z, jr_004_69ea                             ; $69DE

    ldh [hScratchA], a                            ; $69E0
    inc h                                         ; $69E2
    ld l, $00                                     ; $69E3
    inc d                                         ; $69E5
    ld e, $f0                                     ; $69E6
    jr jr_004_69b5                                ; $69E8

jr_004_69ea:
    ld hl, $a880                                  ; $69EA
    ld de, $c770                                  ; $69ED
    ld b, $41                                     ; $69F0
    ld a, $07                                     ; $69F2
    ldh [hScratchA], a                            ; $69F4

jr_004_69f6:
    ld a, $08                                     ; $69F6
    ldh [hScratchB], a                            ; $69F8

jr_004_69fa:
    ld a, $08                                     ; $69FA
    ldh [hScratchD], a                            ; $69FC

jr_004_69fe:
    ld a, [hl+]                                   ; $69FE
    ld c, a                                       ; $69FF
    ld a, [bc]                                    ; $6A00
    ld [de], a                                    ; $6A01
    inc e                                         ; $6A02
    ld a, [hl+]                                   ; $6A03
    ld c, a                                       ; $6A04
    ld a, [bc]                                    ; $6A05
    ld [de], a                                    ; $6A06
    inc e                                         ; $6A07
    ldh a, [hScratchD]                            ; $6A08
    dec a                                         ; $6A0A
    ldh [hScratchD], a                            ; $6A0B
    jr nz, jr_004_69fe                            ; $6A0D

    ldh a, [hScratchB]                            ; $6A0F
    dec a                                         ; $6A11
    jr z, jr_004_6a1c                             ; $6A12

    ldh [hScratchB], a                            ; $6A14
    ld a, e                                       ; $6A16
    sub $20                                       ; $6A17
    ld e, a                                       ; $6A19
    jr jr_004_69fa                                ; $6A1A

jr_004_6a1c:
    ldh a, [hScratchA]                            ; $6A1C
    dec a                                         ; $6A1E
    ret z                                         ; $6A1F

    ldh [hScratchA], a                            ; $6A20
    ld l, $80                                     ; $6A22
    inc d                                         ; $6A24
    ld e, $70                                     ; $6A25
    jr jr_004_69f6                                ; $6A27

; C: same instructions as the Japanese Fx32_CopyQuads_TR_BL_BR_OnFlipH (0A:5FB9) over the whole routine (31
; instructions, to the first ret / jp), only the addresses differ; code compared
Fx32_CopyQuads_TR_BL_BR_OnFlipH::
    ld hl, $a100                                  ; $6A29
    ld de, wPhotoImage + $f0                      ; $6A2C
    ld b, $41                                     ; $6A2F
    ld a, $07                                     ; $6A31
    ldh [hScratchA], a                            ; $6A33

jr_004_6a35:
    ld a, $08                                     ; $6A35
    ldh [hScratchB], a                            ; $6A37

jr_004_6a39:
    ld a, $08                                     ; $6A39
    ldh [hScratchD], a                            ; $6A3B

jr_004_6a3d:
    ld a, [hl+]                                   ; $6A3D
    ld c, a                                       ; $6A3E
    ld a, [bc]                                    ; $6A3F
    ld [de], a                                    ; $6A40
    inc e                                         ; $6A41
    ld a, [hl+]                                   ; $6A42
    ld c, a                                       ; $6A43
    ld a, [bc]                                    ; $6A44
    ld [de], a                                    ; $6A45
    inc e                                         ; $6A46
    ldh a, [hScratchD]                            ; $6A47
    dec a                                         ; $6A49
    ldh [hScratchD], a                            ; $6A4A
    jr nz, jr_004_6a3d                            ; $6A4C

    ldh a, [hScratchB]                            ; $6A4E
    dec a                                         ; $6A50
    jr z, jr_004_6a5b                             ; $6A51

    ldh [hScratchB], a                            ; $6A53
    ld a, e                                       ; $6A55
    sub $20                                       ; $6A56
    ld e, a                                       ; $6A58
    jr jr_004_6a39                                ; $6A59

jr_004_6a5b:
    ldh a, [hScratchA]                            ; $6A5B
    dec a                                         ; $6A5D
    jr z, jr_004_6a6a                             ; $6A5E

    ldh [hScratchA], a                            ; $6A60
    inc h                                         ; $6A62
    ld l, $00                                     ; $6A63
    ld e, $f0                                     ; $6A65
    inc d                                         ; $6A67
    jr jr_004_6a35                                ; $6A68

jr_004_6a6a:
    ld hl, $a800                                  ; $6A6A
    ld de, $c7f0                                  ; $6A6D
    ld b, $41                                     ; $6A70
    ld a, $07                                     ; $6A72
    ldh [hScratchA], a                            ; $6A74

jr_004_6a76:
    ld a, $10                                     ; $6A76
    ldh [hScratchB], a                            ; $6A78

jr_004_6a7a:
    ld a, $08                                     ; $6A7A
    ldh [hScratchD], a                            ; $6A7C

jr_004_6a7e:
    ld a, [hl+]                                   ; $6A7E
    ld c, a                                       ; $6A7F
    ld a, [bc]                                    ; $6A80
    ld [de], a                                    ; $6A81
    inc e                                         ; $6A82
    ld a, [hl+]                                   ; $6A83
    ld c, a                                       ; $6A84
    ld a, [bc]                                    ; $6A85
    ld [de], a                                    ; $6A86
    inc e                                         ; $6A87
    ldh a, [hScratchD]                            ; $6A88
    dec a                                         ; $6A8A
    ldh [hScratchD], a                            ; $6A8B
    jr nz, jr_004_6a7e                            ; $6A8D

    ldh a, [hScratchB]                            ; $6A8F
    dec a                                         ; $6A91
    jr z, jr_004_6a9c                             ; $6A92

    ldh [hScratchB], a                            ; $6A94
    ld a, e                                       ; $6A96
    sub $20                                       ; $6A97
    ld e, a                                       ; $6A99
    jr jr_004_6a7a                                ; $6A9A

jr_004_6a9c:
    ldh a, [hScratchA]                            ; $6A9C
    dec a                                         ; $6A9E
    ret z                                         ; $6A9F

    ldh [hScratchA], a                            ; $6AA0
    ld e, $f0                                     ; $6AA2
    inc d                                         ; $6AA4
    jr jr_004_6a76                                ; $6AA5

; C: entry $33 of the effect table 04:5E8A, the same entry as the Japanese 0A:6037 Fx33_CopyTop10Rows_OnFlipH (the two
; tables pair one to one); same code shape
Fx33_CopyTop10Rows_OnFlipH::
    ld hl, $a100                                  ; $6AA7
    ld de, $c0f0                                  ; $6AAA
    ld b, $41                                     ; $6AAD
    ld a, $0a                                     ; $6AAF
    ldh [hScratchA], a                            ; $6AB1

jr_004_6ab3:
    ld a, $10                                     ; $6AB3
    ldh [hScratchB], a                            ; $6AB5

jr_004_6ab7:
    ld a, $08                                     ; $6AB7
    ldh [hScratchD], a                            ; $6AB9

jr_004_6abb:
    ld a, [hl+]                                   ; $6ABB
    ld c, a                                       ; $6ABC
    ld a, [bc]                                    ; $6ABD
    ld [de], a                                    ; $6ABE
    inc e                                         ; $6ABF
    ld a, [hl+]                                   ; $6AC0
    ld c, a                                       ; $6AC1
    ld a, [bc]                                    ; $6AC2
    ld [de], a                                    ; $6AC3
    inc e                                         ; $6AC4
    ldh a, [hScratchD]                            ; $6AC5
    dec a                                         ; $6AC7
    ldh [hScratchD], a                            ; $6AC8
    jr nz, jr_004_6abb                            ; $6ACA

    ldh a, [hScratchB]                            ; $6ACC
    dec a                                         ; $6ACE
    jr z, jr_004_6ad9                             ; $6ACF

    ldh [hScratchB], a                            ; $6AD1
    ld a, e                                       ; $6AD3
    sub $20                                       ; $6AD4
    ld e, a                                       ; $6AD6
    jr jr_004_6ab7                                ; $6AD7

jr_004_6ad9:
    ldh a, [hScratchA]                            ; $6AD9
    dec a                                         ; $6ADB
    ret z                                         ; $6ADC

    ldh [hScratchA], a                            ; $6ADD
    ld e, $f0                                     ; $6ADF
    inc d                                         ; $6AE1
    jr jr_004_6ab3                                ; $6AE2

; C: entry $34 of the effect table 04:5E8A, the same entry as the Japanese 0A:6074 Fx34_CopyBottom4Rows_OnFlipH (the
; two tables pair one to one); same code shape
Fx34_CopyBottom4Rows_OnFlipH::
    ld hl, $ab00                                  ; $6AE4
    ld de, $caf0                                  ; $6AE7
    ld b, $41                                     ; $6AEA
    ld a, $04                                     ; $6AEC
    ldh [hScratchA], a                            ; $6AEE

jr_004_6af0:
    ld a, $10                                     ; $6AF0
    ldh [hScratchB], a                            ; $6AF2

jr_004_6af4:
    ld a, $08                                     ; $6AF4
    ldh [hScratchD], a                            ; $6AF6

jr_004_6af8:
    ld a, [hl+]                                   ; $6AF8
    ld c, a                                       ; $6AF9
    ld a, [bc]                                    ; $6AFA
    ld [de], a                                    ; $6AFB
    inc e                                         ; $6AFC
    ld a, [hl+]                                   ; $6AFD
    ld c, a                                       ; $6AFE
    ld a, [bc]                                    ; $6AFF
    ld [de], a                                    ; $6B00
    inc e                                         ; $6B01
    ldh a, [hScratchD]                            ; $6B02
    dec a                                         ; $6B04
    ldh [hScratchD], a                            ; $6B05
    jr nz, jr_004_6af8                            ; $6B07

    ldh a, [hScratchB]                            ; $6B09
    dec a                                         ; $6B0B
    jr z, jr_004_6b16                             ; $6B0C

    ldh [hScratchB], a                            ; $6B0E
    ld a, e                                       ; $6B10
    sub $20                                       ; $6B11
    ld e, a                                       ; $6B13
    jr jr_004_6af4                                ; $6B14

jr_004_6b16:
    ldh a, [hScratchA]                            ; $6B16
    dec a                                         ; $6B18
    ret z                                         ; $6B19

    ldh [hScratchA], a                            ; $6B1A
    ld e, $f0                                     ; $6B1C
    inc d                                         ; $6B1E
    jr jr_004_6af0                                ; $6B1F

; C: entry $35 of the effect table 04:5E8A, the same entry as the Japanese 0A:60B1 Fx35_CopyTop4Rows_OnFlipH (the two
; tables pair one to one); same code shape
Fx35_CopyTop4Rows_OnFlipH::
    ld hl, $a100                                  ; $6B21
    ld de, $c0f0                                  ; $6B24
    ld b, $41                                     ; $6B27
    ld a, $04                                     ; $6B29
    ldh [hScratchA], a                            ; $6B2B

jr_004_6b2d:
    ld a, $10                                     ; $6B2D
    ldh [hScratchB], a                            ; $6B2F

jr_004_6b31:
    ld a, $08                                     ; $6B31
    ldh [hScratchD], a                            ; $6B33

jr_004_6b35:
    ld a, [hl+]                                   ; $6B35
    ld c, a                                       ; $6B36
    ld a, [bc]                                    ; $6B37
    ld [de], a                                    ; $6B38
    inc e                                         ; $6B39
    ld a, [hl+]                                   ; $6B3A
    ld c, a                                       ; $6B3B
    ld a, [bc]                                    ; $6B3C
    ld [de], a                                    ; $6B3D
    inc e                                         ; $6B3E
    ldh a, [hScratchD]                            ; $6B3F
    dec a                                         ; $6B41
    ldh [hScratchD], a                            ; $6B42
    jr nz, jr_004_6b35                            ; $6B44

    ldh a, [hScratchB]                            ; $6B46
    dec a                                         ; $6B48
    jr z, jr_004_6b53                             ; $6B49

    ldh [hScratchB], a                            ; $6B4B
    ld a, e                                       ; $6B4D
    sub $20                                       ; $6B4E
    ld e, a                                       ; $6B50
    jr jr_004_6b31                                ; $6B51

jr_004_6b53:
    ldh a, [hScratchA]                            ; $6B53
    dec a                                         ; $6B55
    ret z                                         ; $6B56

    ldh [hScratchA], a                            ; $6B57
    ld e, $f0                                     ; $6B59
    inc d                                         ; $6B5B
    jr jr_004_6b2d                                ; $6B5C

; C: entry $36 of the effect table 04:5E8A, the same entry as the Japanese 0A:60EE Fx36_CopyBottom10Rows_OnFlipH (the
; two tables pair one to one); same code shape
Fx36_CopyBottom10Rows_OnFlipH::
    ld hl, $a500                                  ; $6B5E
    ld de, $c4f0                                  ; $6B61
    ld b, $41                                     ; $6B64
    ld a, $0a                                     ; $6B66
    ldh [hScratchA], a                            ; $6B68

jr_004_6b6a:
    ld a, $10                                     ; $6B6A
    ldh [hScratchB], a                            ; $6B6C

jr_004_6b6e:
    ld a, $08                                     ; $6B6E
    ldh [hScratchD], a                            ; $6B70

jr_004_6b72:
    ld a, [hl+]                                   ; $6B72
    ld c, a                                       ; $6B73
    ld a, [bc]                                    ; $6B74
    ld [de], a                                    ; $6B75
    inc e                                         ; $6B76
    ld a, [hl+]                                   ; $6B77
    ld c, a                                       ; $6B78
    ld a, [bc]                                    ; $6B79
    ld [de], a                                    ; $6B7A
    inc e                                         ; $6B7B
    ldh a, [hScratchD]                            ; $6B7C
    dec a                                         ; $6B7E
    ldh [hScratchD], a                            ; $6B7F
    jr nz, jr_004_6b72                            ; $6B81

    ldh a, [hScratchB]                            ; $6B83
    dec a                                         ; $6B85
    jr z, jr_004_6b90                             ; $6B86

    ldh [hScratchB], a                            ; $6B88
    ld a, e                                       ; $6B8A
    sub $20                                       ; $6B8B
    ld e, a                                       ; $6B8D
    jr jr_004_6b6e                                ; $6B8E

jr_004_6b90:
    ldh a, [hScratchA]                            ; $6B90
    dec a                                         ; $6B92
    ret z                                         ; $6B93

    ldh [hScratchA], a                            ; $6B94
    ld e, $f0                                     ; $6B96
    inc d                                         ; $6B98
    jr jr_004_6b6a                                ; $6B99

; C: same instructions as the Japanese Fx37_CopyWindow_OnFlipH (0A:612B) over the whole routine (31 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx37_CopyWindow_OnFlipH::
    ld hl, $a430                                  ; $6B9B
    ld de, wPhotoImage + $3c0                     ; $6B9E
    ld b, $41                                     ; $6BA1
    ld a, $08                                     ; $6BA3
    ldh [hScratchA], a                            ; $6BA5

jr_004_6ba7:
    ld a, $0a                                     ; $6BA7
    ldh [hScratchB], a                            ; $6BA9

jr_004_6bab:
    ld a, $08                                     ; $6BAB
    ldh [hScratchD], a                            ; $6BAD

jr_004_6baf:
    ld a, [hl+]                                   ; $6BAF
    ld c, a                                       ; $6BB0
    ld a, [bc]                                    ; $6BB1
    ld [de], a                                    ; $6BB2
    inc e                                         ; $6BB3
    ld a, [hl+]                                   ; $6BB4
    ld c, a                                       ; $6BB5
    ld a, [bc]                                    ; $6BB6
    ld [de], a                                    ; $6BB7
    inc e                                         ; $6BB8
    ldh a, [hScratchD]                            ; $6BB9
    dec a                                         ; $6BBB
    ldh [hScratchD], a                            ; $6BBC
    jr nz, jr_004_6baf                            ; $6BBE

    ldh a, [hScratchB]                            ; $6BC0
    dec a                                         ; $6BC2
    jr z, jr_004_6bcd                             ; $6BC3

    ldh [hScratchB], a                            ; $6BC5
    ld a, e                                       ; $6BC7
    sub $20                                       ; $6BC8
    ld e, a                                       ; $6BCA
    jr jr_004_6bab                                ; $6BCB

jr_004_6bcd:
    ldh a, [hScratchA]                            ; $6BCD
    dec a                                         ; $6BCF
    ret z                                         ; $6BD0

    ldh [hScratchA], a                            ; $6BD1
    inc h                                         ; $6BD3
    ld l, $30                                     ; $6BD4
    inc d                                         ; $6BD6
    ld e, $c0                                     ; $6BD7
    jr jr_004_6ba7                                ; $6BD9

; C: entry $38 of the effect table 04:5E8A, the same entry as the Japanese 0A:616B Fx38_CopyQuadBR_OnFlipH (the two
; tables pair one to one); same code shape
Fx38_CopyQuadBR_OnFlipH::
    ld hl, $a800                                  ; $6BDB
    ld de, wPhotoImage + $7f0                     ; $6BDE
    ld b, $41                                     ; $6BE1
    ld a, $07                                     ; $6BE3
    ldh [hScratchA], a                            ; $6BE5

jr_004_6be7:
    ld a, $08                                     ; $6BE7
    ldh [hScratchB], a                            ; $6BE9

jr_004_6beb:
    ld a, $08                                     ; $6BEB
    ldh [hScratchD], a                            ; $6BED

jr_004_6bef:
    ld a, [hl+]                                   ; $6BEF
    ld c, a                                       ; $6BF0
    ld a, [bc]                                    ; $6BF1
    ld [de], a                                    ; $6BF2
    inc e                                         ; $6BF3
    ld a, [hl+]                                   ; $6BF4
    ld c, a                                       ; $6BF5
    ld a, [bc]                                    ; $6BF6
    ld [de], a                                    ; $6BF7
    inc e                                         ; $6BF8
    ldh a, [hScratchD]                            ; $6BF9
    dec a                                         ; $6BFB
    ldh [hScratchD], a                            ; $6BFC
    jr nz, jr_004_6bef                            ; $6BFE

    ldh a, [hScratchB]                            ; $6C00
    dec a                                         ; $6C02
    jr z, jr_004_6c0d                             ; $6C03

    ldh [hScratchB], a                            ; $6C05
    ld a, e                                       ; $6C07
    sub $20                                       ; $6C08
    ld e, a                                       ; $6C0A
    jr jr_004_6beb                                ; $6C0B

jr_004_6c0d:
    ldh a, [hScratchA]                            ; $6C0D
    dec a                                         ; $6C0F
    ret z                                         ; $6C10

    ldh [hScratchA], a                            ; $6C11
    inc h                                         ; $6C13
    ld l, $00                                     ; $6C14
    ld e, $f0                                     ; $6C16
    inc d                                         ; $6C18
    jr jr_004_6be7                                ; $6C19

; C: entry $39 of the effect table 04:5E8A, the same entry as the Japanese 0A:61AB Fx39_Nop (the two tables pair one
; to one); ret
Fx39_Nop::
    ret                                           ; $6C1B


; C: entry $3A of the effect table 04:5E8A, the same entry as the Japanese 0A:61AC Fx3A_Nop (the two tables pair one
; to one); ret
Fx3A_Nop::
    ret                                           ; $6C1C


; C: entry $3B of the effect table 04:5E8A, the same entry as the Japanese 0A:61AD Fx3B_Nop (the two tables pair one
; to one); ret
Fx3B_Nop::
    ret                                           ; $6C1D


; C: entry $3C of the effect table 04:5E8A, the same entry as the Japanese 0A:61AE Fx3C_Nop (the two tables pair one
; to one); ret
Fx3C_Nop::
    ret                                           ; $6C1E


; C: entry $3D of the effect table 04:5E8A, the same entry as the Japanese 0A:61AF Fx3D_Nop (the two tables pair one
; to one); ret
Fx3D_Nop::
    ret                                           ; $6C1F


; C: entry $3E of the effect table 04:5E8A, the same entry as the Japanese 0A:61B0 Fx3E_Nop (the two tables pair one
; to one); ret
Fx3E_Nop::
    ret                                           ; $6C20


; C: entry $3F of the effect table 04:5E8A, the same entry as the Japanese 0A:61B1 Fx3F_Nop (the two tables pair one
; to one); ret
Fx3F_Nop::
    ret                                           ; $6C21


; C: same code as the Japanese Fx40_FlipV (0A:61B2, 105 bytes, masked match)
Fx40_FlipV::
    ld hl, $a100                                  ; $6C22
    ld bc, wPhotoImage + $d0e                     ; $6C25
    ld a, $0e                                     ; $6C28
    ldh [hScratchA], a                            ; $6C2A

jr_004_6c2c:
    ld a, $10                                     ; $6C2C
    ldh [hScratchB], a                            ; $6C2E

jr_004_6c30:
    ld a, [hl+]                                   ; $6C30
    ld [bc], a                                    ; $6C31
    inc c                                         ; $6C32
    ld a, [hl+]                                   ; $6C33
    ld [bc], a                                    ; $6C34
    dec c                                         ; $6C35
    dec c                                         ; $6C36
    dec c                                         ; $6C37
    ld a, [hl+]                                   ; $6C38
    ld [bc], a                                    ; $6C39
    inc c                                         ; $6C3A
    ld a, [hl+]                                   ; $6C3B
    ld [bc], a                                    ; $6C3C
    dec c                                         ; $6C3D
    dec c                                         ; $6C3E
    dec c                                         ; $6C3F
    ld a, [hl+]                                   ; $6C40
    ld [bc], a                                    ; $6C41
    inc c                                         ; $6C42
    ld a, [hl+]                                   ; $6C43
    ld [bc], a                                    ; $6C44
    dec c                                         ; $6C45
    dec c                                         ; $6C46
    dec c                                         ; $6C47
    ld a, [hl+]                                   ; $6C48
    ld [bc], a                                    ; $6C49
    inc c                                         ; $6C4A
    ld a, [hl+]                                   ; $6C4B
    ld [bc], a                                    ; $6C4C
    dec c                                         ; $6C4D
    dec c                                         ; $6C4E
    dec c                                         ; $6C4F
    ld a, [hl+]                                   ; $6C50
    ld [bc], a                                    ; $6C51
    inc c                                         ; $6C52
    ld a, [hl+]                                   ; $6C53
    ld [bc], a                                    ; $6C54
    dec c                                         ; $6C55
    dec c                                         ; $6C56
    dec c                                         ; $6C57
    ld a, [hl+]                                   ; $6C58
    ld [bc], a                                    ; $6C59
    inc c                                         ; $6C5A
    ld a, [hl+]                                   ; $6C5B
    ld [bc], a                                    ; $6C5C
    dec c                                         ; $6C5D
    dec c                                         ; $6C5E
    dec c                                         ; $6C5F
    ld a, [hl+]                                   ; $6C60
    ld [bc], a                                    ; $6C61
    inc c                                         ; $6C62
    ld a, [hl+]                                   ; $6C63
    ld [bc], a                                    ; $6C64
    dec c                                         ; $6C65
    dec c                                         ; $6C66
    dec c                                         ; $6C67
    ld a, [hl+]                                   ; $6C68
    ld [bc], a                                    ; $6C69
    inc c                                         ; $6C6A
    ld a, [hl+]                                   ; $6C6B
    ld [bc], a                                    ; $6C6C
    dec c                                         ; $6C6D
    dec c                                         ; $6C6E
    dec c                                         ; $6C6F
    ldh a, [hScratchB]                            ; $6C70
    dec a                                         ; $6C72
    jr z, jr_004_6c7d                             ; $6C73

    ldh [hScratchB], a                            ; $6C75
    ld a, c                                       ; $6C77
    add $20                                       ; $6C78
    ld c, a                                       ; $6C7A
    jr jr_004_6c30                                ; $6C7B

jr_004_6c7d:
    ldh a, [hScratchA]                            ; $6C7D
    dec a                                         ; $6C7F
    ret z                                         ; $6C80

    ldh [hScratchA], a                            ; $6C81
    ld e, $00                                     ; $6C83
    inc d                                         ; $6C85
    ld c, $0e                                     ; $6C86
    dec b                                         ; $6C88
    jr jr_004_6c2c                                ; $6C89

; C: same instructions as the Japanese Fx41_MirrorRtoL_OnFlipV (0A:621B) over the whole routine (44 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx41_MirrorRtoL_OnFlipV::
    ld hl, $a180                                  ; $6C8B
    ld de, wPhotoImage + $d8e                     ; $6C8E
    ld b, $41                                     ; $6C91
    ld a, $0e                                     ; $6C93
    ldh [hScratchA], a                            ; $6C95

jr_004_6c97:
    ld a, $08                                     ; $6C97
    ldh [hScratchB], a                            ; $6C99

jr_004_6c9b:
    ld a, $08                                     ; $6C9B
    ldh [hScratchD], a                            ; $6C9D

jr_004_6c9f:
    ld a, [hl+]                                   ; $6C9F
    ld [de], a                                    ; $6CA0
    ld c, a                                       ; $6CA1
    ld a, [bc]                                    ; $6CA2
    ld c, a                                       ; $6CA3
    ld a, e                                       ; $6CA4
    xor $f0                                       ; $6CA5
    ld e, a                                       ; $6CA7
    ld a, c                                       ; $6CA8
    ld [de], a                                    ; $6CA9
    inc e                                         ; $6CAA
    ld a, [hl+]                                   ; $6CAB
    ld c, a                                       ; $6CAC
    ld a, [bc]                                    ; $6CAD
    ld [de], a                                    ; $6CAE
    ld a, e                                       ; $6CAF
    xor $f0                                       ; $6CB0
    ld e, a                                       ; $6CB2
    ld a, c                                       ; $6CB3
    ld [de], a                                    ; $6CB4
    dec e                                         ; $6CB5
    dec e                                         ; $6CB6
    dec e                                         ; $6CB7
    ldh a, [hScratchD]                            ; $6CB8
    dec a                                         ; $6CBA
    ldh [hScratchD], a                            ; $6CBB
    jr nz, jr_004_6c9f                            ; $6CBD

    ld a, e                                       ; $6CBF
    add $20                                       ; $6CC0
    ld e, a                                       ; $6CC2
    ldh a, [hScratchB]                            ; $6CC3
    dec a                                         ; $6CC5
    jr z, jr_004_6ccc                             ; $6CC6

    ldh [hScratchB], a                            ; $6CC8
    jr jr_004_6c9b                                ; $6CCA

jr_004_6ccc:
    ldh a, [hScratchA]                            ; $6CCC
    dec a                                         ; $6CCE
    ret z                                         ; $6CCF

    ldh [hScratchA], a                            ; $6CD0
    ld e, $8e                                     ; $6CD2
    dec d                                         ; $6CD4
    ld l, $80                                     ; $6CD5
    jr jr_004_6c97                                ; $6CD7

; C: same instructions as the Japanese Fx42_MirrorLtoR_OnFlipV (0A:6269) over the whole routine (44 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx42_MirrorLtoR_OnFlipV::
    ld hl, $a100                                  ; $6CD9
    ld de, wPhotoImage + $d0e                     ; $6CDC
    ld b, $41                                     ; $6CDF
    ld a, $0e                                     ; $6CE1
    ldh [hScratchA], a                            ; $6CE3

jr_004_6ce5:
    ld a, $08                                     ; $6CE5
    ldh [hScratchB], a                            ; $6CE7

jr_004_6ce9:
    ld a, $08                                     ; $6CE9
    ldh [hScratchD], a                            ; $6CEB

jr_004_6ced:
    ld a, [hl+]                                   ; $6CED
    ld [de], a                                    ; $6CEE
    ld c, a                                       ; $6CEF
    ld a, [bc]                                    ; $6CF0
    ld c, a                                       ; $6CF1
    ld a, e                                       ; $6CF2
    xor $f0                                       ; $6CF3
    ld e, a                                       ; $6CF5
    ld a, c                                       ; $6CF6
    ld [de], a                                    ; $6CF7
    inc e                                         ; $6CF8
    ld a, [hl+]                                   ; $6CF9
    ld c, a                                       ; $6CFA
    ld a, [bc]                                    ; $6CFB
    ld [de], a                                    ; $6CFC
    ld a, e                                       ; $6CFD
    xor $f0                                       ; $6CFE
    ld e, a                                       ; $6D00
    ld a, c                                       ; $6D01
    ld [de], a                                    ; $6D02
    dec e                                         ; $6D03
    dec e                                         ; $6D04
    dec e                                         ; $6D05
    ldh a, [hScratchD]                            ; $6D06
    dec a                                         ; $6D08
    ldh [hScratchD], a                            ; $6D09
    jr nz, jr_004_6ced                            ; $6D0B

    ld a, e                                       ; $6D0D
    add $20                                       ; $6D0E
    ld e, a                                       ; $6D10
    ldh a, [hScratchB]                            ; $6D11
    dec a                                         ; $6D13
    jr z, jr_004_6d1a                             ; $6D14

    ldh [hScratchB], a                            ; $6D16
    jr jr_004_6ce9                                ; $6D18

jr_004_6d1a:
    ldh a, [hScratchA]                            ; $6D1A
    dec a                                         ; $6D1C
    ret z                                         ; $6D1D

    ldh [hScratchA], a                            ; $6D1E
    dec d                                         ; $6D20
    ld e, $0e                                     ; $6D21
    inc h                                         ; $6D23
    ld l, $00                                     ; $6D24
    jr jr_004_6ce5                                ; $6D26

; C: same code as the Japanese Fx45_StretchV2x_FlipV (0A:62B8, 96 bytes, masked match)
Fx45_StretchV2x_FlipV::
    ld hl, $a400                                  ; $6D28
    ld de, wPhotoImage + $d0c                     ; $6D2B
    ld a, $07                                     ; $6D2E
    ldh [hScratchA], a                            ; $6D30

jr_004_6d32:
    ld a, $10                                     ; $6D32
    ldh [hScratchB], a                            ; $6D34

jr_004_6d36:
    ld a, $04                                     ; $6D36
    ldh [hScratchD], a                            ; $6D38

jr_004_6d3a:
    ld a, [hl+]                                   ; $6D3A
    ld [de], a                                    ; $6D3B
    inc e                                         ; $6D3C
    inc e                                         ; $6D3D
    ld [de], a                                    ; $6D3E
    dec e                                         ; $6D3F
    ld a, [hl+]                                   ; $6D40
    ld [de], a                                    ; $6D41
    inc e                                         ; $6D42
    inc e                                         ; $6D43
    ld [de], a                                    ; $6D44
    ld a, e                                       ; $6D45
    sub $07                                       ; $6D46
    ld e, a                                       ; $6D48
    ldh a, [hScratchD]                            ; $6D49
    dec a                                         ; $6D4B
    ldh [hScratchD], a                            ; $6D4C
    jr nz, jr_004_6d3a                            ; $6D4E

    dec d                                         ; $6D50
    ld a, e                                       ; $6D51
    add $10                                       ; $6D52
    ld e, a                                       ; $6D54
    ld a, $04                                     ; $6D55
    ldh [hScratchD], a                            ; $6D57

jr_004_6d59:
    ld a, [hl+]                                   ; $6D59
    ld [de], a                                    ; $6D5A
    inc e                                         ; $6D5B
    inc e                                         ; $6D5C
    ld [de], a                                    ; $6D5D
    dec e                                         ; $6D5E
    ld a, [hl+]                                   ; $6D5F
    ld [de], a                                    ; $6D60
    inc e                                         ; $6D61
    inc e                                         ; $6D62
    ld [de], a                                    ; $6D63
    ld a, e                                       ; $6D64
    sub $07                                       ; $6D65
    ld e, a                                       ; $6D67
    ldh a, [hScratchD]                            ; $6D68
    dec a                                         ; $6D6A
    ldh [hScratchD], a                            ; $6D6B
    jr nz, jr_004_6d59                            ; $6D6D

    ld a, e                                       ; $6D6F
    add $20                                       ; $6D70
    ld e, a                                       ; $6D72
    ldh a, [hScratchB]                            ; $6D73
    dec a                                         ; $6D75
    jr z, jr_004_6d7d                             ; $6D76

    ldh [hScratchB], a                            ; $6D78
    inc d                                         ; $6D7A
    jr jr_004_6d36                                ; $6D7B

jr_004_6d7d:
    ldh a, [hScratchA]                            ; $6D7D
    dec a                                         ; $6D7F
    ret z                                         ; $6D80

    ldh [hScratchA], a                            ; $6D81
    dec d                                         ; $6D83
    ld e, $0c                                     ; $6D84
    jr jr_004_6d32                                ; $6D86

; C: same instructions as the Japanese Fx46_StretchH2x_OnFlipV (0A:6318) over the whole routine (46 instructions, to
; the first ret / jp), only the addresses differ; code compared
Fx46_StretchH2x_OnFlipV::
    ld hl, $a140                                  ; $6D88
    ld de, wPhotoImage + $d0e                     ; $6D8B
    ld a, $0e                                     ; $6D8E
    ldh [hScratchA], a                            ; $6D90

jr_004_6d92:
    ld a, $08                                     ; $6D92
    ldh [hScratchB], a                            ; $6D94

jr_004_6d96:
    ld a, $08                                     ; $6D96
    ldh [hScratchD], a                            ; $6D98

jr_004_6d9a:
    ld a, [hl+]                                   ; $6D9A
    ld c, a                                       ; $6D9B
    ld b, $42                                     ; $6D9C
    ld a, [bc]                                    ; $6D9E
    ld [de], a                                    ; $6D9F
    ld a, e                                       ; $6DA0
    add $10                                       ; $6DA1
    ld e, a                                       ; $6DA3
    ld b, $43                                     ; $6DA4
    ld a, [bc]                                    ; $6DA6
    ld [de], a                                    ; $6DA7
    inc e                                         ; $6DA8
    ld a, [hl+]                                   ; $6DA9
    ld c, a                                       ; $6DAA
    ld b, $43                                     ; $6DAB
    ld a, [bc]                                    ; $6DAD
    ld [de], a                                    ; $6DAE
    ld a, e                                       ; $6DAF
    sub $10                                       ; $6DB0
    ld e, a                                       ; $6DB2
    ld b, $42                                     ; $6DB3
    ld a, [bc]                                    ; $6DB5
    ld [de], a                                    ; $6DB6
    dec e                                         ; $6DB7
    dec e                                         ; $6DB8
    dec e                                         ; $6DB9
    ldh a, [hScratchD]                            ; $6DBA
    dec a                                         ; $6DBC
    ldh [hScratchD], a                            ; $6DBD
    jr nz, jr_004_6d9a                            ; $6DBF

    ld a, e                                       ; $6DC1
    add $30                                       ; $6DC2
    ld e, a                                       ; $6DC4
    ldh a, [hScratchB]                            ; $6DC5
    dec a                                         ; $6DC7
    jr z, jr_004_6dce                             ; $6DC8

    ldh [hScratchB], a                            ; $6DCA
    jr jr_004_6d96                                ; $6DCC

jr_004_6dce:
    ldh a, [hScratchA]                            ; $6DCE
    dec a                                         ; $6DD0
    ret z                                         ; $6DD1

    ldh [hScratchA], a                            ; $6DD2
    dec d                                         ; $6DD4
    inc h                                         ; $6DD5
    ld l, $40                                     ; $6DD6
    jr jr_004_6d92                                ; $6DD8

; C: the Japanese Fx47_Zoom2x_FlipV_GroupTop (0A:6378), 111 instructions against 105, with 1 small edits (variables
; moved between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code
; compared
Fx47_Zoom2x_FlipV_GroupTop::
    ld hl, $a440                                  ; $6DDA
    ld de, $cd0c                                  ; $6DDD
    ld a, $07                                     ; $6DE0
    ldh [hScratchA], a                            ; $6DE2

Jump_004_6de4:
    ld a, $08                                     ; $6DE4
    ldh [hScratchB], a                            ; $6DE6

Jump_004_6de8:
    ld a, $04                                     ; $6DE8
    ldh [hScratchD], a                            ; $6DEA

jr_004_6dec:
    ld a, [hl+]                                   ; $6DEC
    ld c, a                                       ; $6DED
    ld b, $42                                     ; $6DEE
    ld a, [bc]                                    ; $6DF0
    ld [de], a                                    ; $6DF1
    inc e                                         ; $6DF2
    inc e                                         ; $6DF3
    ld [de], a                                    ; $6DF4
    ld a, e                                       ; $6DF5
    add $0e                                       ; $6DF6
    ld e, a                                       ; $6DF8
    ld b, $43                                     ; $6DF9
    ld a, [bc]                                    ; $6DFB
    ld [de], a                                    ; $6DFC
    inc e                                         ; $6DFD
    inc e                                         ; $6DFE
    ld [de], a                                    ; $6DFF
    ld a, e                                       ; $6E00
    sub $11                                       ; $6E01
    ld e, a                                       ; $6E03
    ld a, [hl+]                                   ; $6E04
    ld c, a                                       ; $6E05
    ld b, $42                                     ; $6E06
    ld a, [bc]                                    ; $6E08
    ld [de], a                                    ; $6E09
    inc e                                         ; $6E0A
    inc e                                         ; $6E0B
    ld [de], a                                    ; $6E0C
    ld a, e                                       ; $6E0D
    add $0e                                       ; $6E0E
    ld e, a                                       ; $6E10
    ld b, $43                                     ; $6E11
    ld a, [bc]                                    ; $6E13
    ld [de], a                                    ; $6E14
    inc e                                         ; $6E15
    inc e                                         ; $6E16
    ld [de], a                                    ; $6E17
    ld a, e                                       ; $6E18
    sub $17                                       ; $6E19
    ld e, a                                       ; $6E1B
    ldh a, [hScratchD]                            ; $6E1C
    dec a                                         ; $6E1E
    ldh [hScratchD], a                            ; $6E1F
    jr nz, jr_004_6dec                            ; $6E21

    dec d                                         ; $6E23
    ld a, e                                       ; $6E24
    add $10                                       ; $6E25
    ld e, a                                       ; $6E27
    ld a, $04                                     ; $6E28
    ldh [hScratchD], a                            ; $6E2A

jr_004_6e2c:
    ld a, [hl+]                                   ; $6E2C
    ld c, a                                       ; $6E2D
    ld b, $42                                     ; $6E2E
    ld a, [bc]                                    ; $6E30
    ld [de], a                                    ; $6E31
    inc e                                         ; $6E32
    inc e                                         ; $6E33
    ld [de], a                                    ; $6E34
    ld a, e                                       ; $6E35
    add $0e                                       ; $6E36
    ld e, a                                       ; $6E38
    ld b, $43                                     ; $6E39
    ld a, [bc]                                    ; $6E3B
    ld [de], a                                    ; $6E3C
    inc e                                         ; $6E3D
    inc e                                         ; $6E3E
    ld [de], a                                    ; $6E3F
    ld a, e                                       ; $6E40
    sub $11                                       ; $6E41
    ld e, a                                       ; $6E43
    ld a, [hl+]                                   ; $6E44
    ld c, a                                       ; $6E45
    ld b, $42                                     ; $6E46
    ld a, [bc]                                    ; $6E48
    ld [de], a                                    ; $6E49
    inc e                                         ; $6E4A
    inc e                                         ; $6E4B
    ld [de], a                                    ; $6E4C
    ld a, e                                       ; $6E4D
    add $0e                                       ; $6E4E
    ld e, a                                       ; $6E50
    ld b, $43                                     ; $6E51
    ld a, [bc]                                    ; $6E53
    ld [de], a                                    ; $6E54
    inc e                                         ; $6E55
    inc e                                         ; $6E56
    ld [de], a                                    ; $6E57
    ld a, e                                       ; $6E58
    sub $17                                       ; $6E59
    ld e, a                                       ; $6E5B
    ldh a, [hScratchD]                            ; $6E5C
    dec a                                         ; $6E5E
    ldh [hScratchD], a                            ; $6E5F
    jr nz, jr_004_6e2c                            ; $6E61

    ldh a, [hScratchB]                            ; $6E63
    dec a                                         ; $6E65
    jr z, jr_004_6e72                             ; $6E66

    ldh [hScratchB], a                            ; $6E68
    inc d                                         ; $6E6A
    ld a, e                                       ; $6E6B
    add $30                                       ; $6E6C
    ld e, a                                       ; $6E6E
    jp Jump_004_6de8                              ; $6E6F


jr_004_6e72:
    ldh a, [hScratchA]                            ; $6E72
    dec a                                         ; $6E74
    ret z                                         ; $6E75

    ldh [hScratchA], a                            ; $6E76
    inc h                                         ; $6E78
    ld l, $40                                     ; $6E79
    dec d                                         ; $6E7B
    ld e, $0c                                     ; $6E7C
    jp Jump_004_6de4                              ; $6E7E


; C: entry $48 of the effect table 04:5E8A, the same entry as the Japanese 0A:6411 Fx48_Reduce2xTile2x2_FlipV (the two
; tables pair one to one); same code shape
Fx48_Reduce2xTile2x2_FlipV::
    ld hl, $a100                                  ; $6E81
    ld de, $c60e                                  ; $6E84
    ld b, HIGH(Cam_ReduceTbl_Lo)                  ; $6E87
    ld a, $07                                     ; $6E89
    ldh [hScratchA], a                            ; $6E8B

Jump_004_6e8d:
    ld a, $08                                     ; $6E8D
    ldh [hScratchB], a                            ; $6E8F

; C: same code as the Japanese Fx48_Reduce2xTile2x2_FlipV_GroupTop (0A:6421, 245 bytes, masked match)
Fx48_Reduce2xTile2x2_FlipV_GroupTop::
    ld a, $04                                     ; $6E91
    ldh [hScratchD], a                            ; $6E93

jr_004_6e95:
    ld c, [hl]                                    ; $6E95
    ld a, [bc]                                    ; $6E96
    swap a                                        ; $6E97
    ldh [hScratchC], a                            ; $6E99
    ld a, l                                       ; $6E9B
    add $10                                       ; $6E9C
    ld l, a                                       ; $6E9E
    ld c, [hl]                                    ; $6E9F
    ld a, [bc]                                    ; $6EA0
    ld c, a                                       ; $6EA1
    ldh a, [hScratchC]                            ; $6EA2
    or c                                          ; $6EA4
    ld c, a                                       ; $6EA5
    ld [de], a                                    ; $6EA6
    ld a, e                                       ; $6EA7
    add $80                                       ; $6EA8
    ld e, a                                       ; $6EAA
    ld a, c                                       ; $6EAB
    ld [de], a                                    ; $6EAC
    ld a, d                                       ; $6EAD
    add $07                                       ; $6EAE
    ld d, a                                       ; $6EB0
    ld a, c                                       ; $6EB1
    ld [de], a                                    ; $6EB2
    ld a, e                                       ; $6EB3
    add $80                                       ; $6EB4
    ld e, a                                       ; $6EB6
    ld a, c                                       ; $6EB7
    ld [de], a                                    ; $6EB8
    ld a, d                                       ; $6EB9
    sub $07                                       ; $6EBA
    ld d, a                                       ; $6EBC
    inc e                                         ; $6EBD
    ld a, l                                       ; $6EBE
    sub $0f                                       ; $6EBF
    ld l, a                                       ; $6EC1
    ld c, [hl]                                    ; $6EC2
    ld a, [bc]                                    ; $6EC3
    swap a                                        ; $6EC4
    ldh [hScratchC], a                            ; $6EC6
    ld a, l                                       ; $6EC8
    add $10                                       ; $6EC9
    ld l, a                                       ; $6ECB
    ld c, [hl]                                    ; $6ECC
    ld a, [bc]                                    ; $6ECD
    ld c, a                                       ; $6ECE
    ldh a, [hScratchC]                            ; $6ECF
    or c                                          ; $6ED1
    ld c, a                                       ; $6ED2
    ld [de], a                                    ; $6ED3
    ld a, e                                       ; $6ED4
    add $80                                       ; $6ED5
    ld e, a                                       ; $6ED7
    ld a, c                                       ; $6ED8
    ld [de], a                                    ; $6ED9
    ld a, d                                       ; $6EDA
    add $07                                       ; $6EDB
    ld d, a                                       ; $6EDD
    ld a, c                                       ; $6EDE
    ld [de], a                                    ; $6EDF
    ld a, e                                       ; $6EE0
    add $80                                       ; $6EE1
    ld e, a                                       ; $6EE3
    ld a, c                                       ; $6EE4
    ld [de], a                                    ; $6EE5
    ld a, d                                       ; $6EE6
    sub $07                                       ; $6EE7
    ld d, a                                       ; $6EE9
    dec e                                         ; $6EEA
    dec e                                         ; $6EEB
    dec e                                         ; $6EEC
    ld a, l                                       ; $6EED
    sub $0d                                       ; $6EEE
    ld l, a                                       ; $6EF0
    ldh a, [hScratchD]                            ; $6EF1
    dec a                                         ; $6EF3
    ldh [hScratchD], a                            ; $6EF4
    jr nz, jr_004_6e95                            ; $6EF6

    inc h                                         ; $6EF8
    ld a, l                                       ; $6EF9
    sub $10                                       ; $6EFA
    ld l, a                                       ; $6EFC
    ld a, $04                                     ; $6EFD
    ldh [hScratchD], a                            ; $6EFF

jr_004_6f01:
    ld c, [hl]                                    ; $6F01
    ld a, [bc]                                    ; $6F02
    swap a                                        ; $6F03
    ldh [hScratchC], a                            ; $6F05
    ld a, l                                       ; $6F07
    add $10                                       ; $6F08
    ld l, a                                       ; $6F0A
    ld c, [hl]                                    ; $6F0B
    ld a, [bc]                                    ; $6F0C
    ld c, a                                       ; $6F0D
    ldh a, [hScratchC]                            ; $6F0E
    or c                                          ; $6F10
    ld c, a                                       ; $6F11
    ld [de], a                                    ; $6F12
    ld a, e                                       ; $6F13
    add $80                                       ; $6F14
    ld e, a                                       ; $6F16
    ld a, c                                       ; $6F17
    ld [de], a                                    ; $6F18
    ld a, d                                       ; $6F19
    add $07                                       ; $6F1A
    ld d, a                                       ; $6F1C
    ld a, c                                       ; $6F1D
    ld [de], a                                    ; $6F1E
    ld a, e                                       ; $6F1F
    add $80                                       ; $6F20
    ld e, a                                       ; $6F22
    ld a, c                                       ; $6F23
    ld [de], a                                    ; $6F24
    ld a, d                                       ; $6F25
    sub $07                                       ; $6F26
    ld d, a                                       ; $6F28
    inc e                                         ; $6F29
    ld a, l                                       ; $6F2A
    sub $0f                                       ; $6F2B
    ld l, a                                       ; $6F2D
    ld c, [hl]                                    ; $6F2E
    ld a, [bc]                                    ; $6F2F
    swap a                                        ; $6F30
    ldh [hScratchC], a                            ; $6F32
    ld a, l                                       ; $6F34
    add $10                                       ; $6F35
    ld l, a                                       ; $6F37
    ld c, [hl]                                    ; $6F38
    ld a, [bc]                                    ; $6F39
    ld c, a                                       ; $6F3A
    ldh a, [hScratchC]                            ; $6F3B
    or c                                          ; $6F3D
    ld c, a                                       ; $6F3E
    ld [de], a                                    ; $6F3F
    ld a, e                                       ; $6F40
    add $80                                       ; $6F41
    ld e, a                                       ; $6F43
    ld a, c                                       ; $6F44
    ld [de], a                                    ; $6F45
    ld a, d                                       ; $6F46
    add $07                                       ; $6F47
    ld d, a                                       ; $6F49
    ld a, c                                       ; $6F4A
    ld [de], a                                    ; $6F4B
    ld a, e                                       ; $6F4C
    add $80                                       ; $6F4D
    ld e, a                                       ; $6F4F
    ld a, c                                       ; $6F50
    ld [de], a                                    ; $6F51
    ld a, d                                       ; $6F52
    sub $07                                       ; $6F53
    ld d, a                                       ; $6F55
    dec e                                         ; $6F56
    dec e                                         ; $6F57
    dec e                                         ; $6F58
    ld a, l                                       ; $6F59
    sub $0d                                       ; $6F5A
    ld l, a                                       ; $6F5C
    ldh a, [hScratchD]                            ; $6F5D
    dec a                                         ; $6F5F
    ldh [hScratchD], a                            ; $6F60
    jr nz, jr_004_6f01                            ; $6F62

    ldh a, [hScratchB]                            ; $6F64
    dec a                                         ; $6F66
    jr z, jr_004_6f77                             ; $6F67

    ldh [hScratchB], a                            ; $6F69
    dec h                                         ; $6F6B
    ld a, l                                       ; $6F6C
    add $10                                       ; $6F6D
    ld l, a                                       ; $6F6F
    ld a, e                                       ; $6F70
    add $20                                       ; $6F71
    ld e, a                                       ; $6F73
    jp Fx48_Reduce2xTile2x2_FlipV_GroupTop        ; $6F74


jr_004_6f77:
    ldh a, [hScratchA]                            ; $6F77
    dec a                                         ; $6F79
    ret z                                         ; $6F7A

    ldh [hScratchA], a                            ; $6F7B
    dec d                                         ; $6F7D
    ld e, $0e                                     ; $6F7E
    inc h                                         ; $6F80
    ld l, $00                                     ; $6F81
    jp Jump_004_6e8d                              ; $6F83


; C: entry $49 of the effect table 04:5E8A, the same entry as the Japanese 0A:6516 Fx49_Reduce2xQuadTL_FlipV (the two
; tables pair one to one); same code shape
Fx49_Reduce2xQuadTL_FlipV::
    ld de, $c60e                                  ; $6F86
    jp Jump_004_741a                              ; $6F89


; C: entry $4A of the effect table 04:5E8A, the same entry as the Japanese 0A:651C Fx4A_Reduce2xQuadTR_FlipV (the two
; tables pair one to one); same code shape
Fx4A_Reduce2xQuadTR_FlipV::
    ld de, $c68e                                  ; $6F8C
    jp Jump_004_741a                              ; $6F8F


; C: entry $4B of the effect table 04:5E8A, the same entry as the Japanese 0A:6522 Fx4B_Reduce2xQuadBL_FlipV (the two
; tables pair one to one); same code shape
Fx4B_Reduce2xQuadBL_FlipV::
    ld de, $cd0e                                  ; $6F92
    jp Jump_004_741a                              ; $6F95


; C: entry $4C of the effect table 04:5E8A, the same entry as the Japanese 0A:6528 Fx4C_Reduce2xQuadBR_FlipV (the two
; tables pair one to one); same code shape
Fx4C_Reduce2xQuadBR_FlipV::
    ld de, $cd8e                                  ; $6F98
    jp Jump_004_741a                              ; $6F9B


; C: same code as the Japanese Fx4D_CopyLeftHalf_OnFlipV (0A:652E, 60 bytes, masked match)
Fx4D_CopyLeftHalf_OnFlipV::
    ld hl, $a100                                  ; $6F9E
    ld bc, wPhotoImage + $d0e                     ; $6FA1
    ld a, $0e                                     ; $6FA4
    ldh [hScratchA], a                            ; $6FA6

jr_004_6fa8:
    ld a, $08                                     ; $6FA8
    ldh [hScratchB], a                            ; $6FAA

jr_004_6fac:
    ld a, $08                                     ; $6FAC
    ldh [hScratchD], a                            ; $6FAE

jr_004_6fb0:
    ld a, [hl+]                                   ; $6FB0
    ld [bc], a                                    ; $6FB1
    inc c                                         ; $6FB2
    ld a, [hl+]                                   ; $6FB3
    ld [bc], a                                    ; $6FB4
    dec c                                         ; $6FB5
    dec c                                         ; $6FB6
    dec c                                         ; $6FB7
    ldh a, [hScratchD]                            ; $6FB8
    dec a                                         ; $6FBA
    ldh [hScratchD], a                            ; $6FBB
    jr nz, jr_004_6fb0                            ; $6FBD

    ldh a, [hScratchB]                            ; $6FBF
    dec a                                         ; $6FC1
    jr z, jr_004_6fcc                             ; $6FC2

    ldh [hScratchB], a                            ; $6FC4
    ld a, c                                       ; $6FC6
    add $20                                       ; $6FC7
    ld c, a                                       ; $6FC9
    jr jr_004_6fac                                ; $6FCA

jr_004_6fcc:
    ldh a, [hScratchA]                            ; $6FCC
    dec a                                         ; $6FCE
    ret z                                         ; $6FCF

    ldh [hScratchA], a                            ; $6FD0
    dec b                                         ; $6FD2
    ld c, $0e                                     ; $6FD3
    inc h                                         ; $6FD5
    ld l, $00                                     ; $6FD6
    jr jr_004_6fa8                                ; $6FD8

; C: same code as the Japanese Fx4E_CopyRightHalf_OnFlipV (0A:656A, 59 bytes, masked match)
Fx4E_CopyRightHalf_OnFlipV::
    ld hl, $a180                                  ; $6FDA
    ld bc, wPhotoImage + $d8e                     ; $6FDD
    ld a, $0e                                     ; $6FE0
    ldh [hScratchA], a                            ; $6FE2

jr_004_6fe4:
    ld a, $08                                     ; $6FE4
    ldh [hScratchB], a                            ; $6FE6

jr_004_6fe8:
    ld a, $08                                     ; $6FE8
    ldh [hScratchD], a                            ; $6FEA

jr_004_6fec:
    ld a, [hl+]                                   ; $6FEC
    ld [bc], a                                    ; $6FED
    inc c                                         ; $6FEE
    ld a, [hl+]                                   ; $6FEF
    ld [bc], a                                    ; $6FF0
    dec c                                         ; $6FF1
    dec c                                         ; $6FF2
    dec c                                         ; $6FF3
    ldh a, [hScratchD]                            ; $6FF4
    dec a                                         ; $6FF6
    ldh [hScratchD], a                            ; $6FF7
    jr nz, jr_004_6fec                            ; $6FF9

    ldh a, [hScratchB]                            ; $6FFB
    dec a                                         ; $6FFD
    jr z, jr_004_7008                             ; $6FFE

    ldh [hScratchB], a                            ; $7000
    ld a, c                                       ; $7002
    add $20                                       ; $7003
    ld c, a                                       ; $7005
    jr jr_004_6fe8                                ; $7006

jr_004_7008:
    ldh a, [hScratchA]                            ; $7008
    dec a                                         ; $700A
    ret z                                         ; $700B

    ldh [hScratchA], a                            ; $700C
    dec b                                         ; $700E
    ld c, $8e                                     ; $700F
    ld l, $80                                     ; $7011
    jr jr_004_6fe4                                ; $7013

; C: entry $4F of the effect table 04:5E8A, the same entry as the Japanese 0A:65A5 Fx4F_CopyTopHalf_OnFlipV (the two
; tables pair one to one); same code shape
Fx4F_CopyTopHalf_OnFlipV::
    ld hl, $a800                                  ; $7015
    ld bc, wPhotoImage + $60e                     ; $7018
    ld a, $07                                     ; $701B
    ldh [hScratchA], a                            ; $701D

jr_004_701f:
    ld a, $10                                     ; $701F
    ldh [hScratchB], a                            ; $7021

jr_004_7023:
    ld a, $08                                     ; $7023
    ldh [hScratchD], a                            ; $7025

jr_004_7027:
    ld a, [hl+]                                   ; $7027
    ld [bc], a                                    ; $7028
    inc c                                         ; $7029
    ld a, [hl+]                                   ; $702A
    ld [bc], a                                    ; $702B
    dec c                                         ; $702C
    dec c                                         ; $702D
    dec c                                         ; $702E
    ldh a, [hScratchD]                            ; $702F
    dec a                                         ; $7031
    ldh [hScratchD], a                            ; $7032
    jr nz, jr_004_7027                            ; $7034

    ldh a, [hScratchB]                            ; $7036
    dec a                                         ; $7038
    jr z, jr_004_7043                             ; $7039

    ldh [hScratchB], a                            ; $703B
    ld a, c                                       ; $703D
    add $20                                       ; $703E
    ld c, a                                       ; $7040
    jr jr_004_7023                                ; $7041

jr_004_7043:
    ldh a, [hScratchA]                            ; $7043
    dec a                                         ; $7045
    ret z                                         ; $7046

    ldh [hScratchA], a                            ; $7047
    dec b                                         ; $7049
    ld c, $0e                                     ; $704A
    jr jr_004_701f                                ; $704C

; C: entry $50 of the effect table 04:5E8A, the same entry as the Japanese 0A:65DE Fx50_CopyBottomHalf_OnFlipV (the
; two tables pair one to one); same code shape
Fx50_CopyBottomHalf_OnFlipV::
    ld hl, $a100                                  ; $704E
    ld bc, $cd0e                                  ; $7051
    ld a, $07                                     ; $7054
    ldh [hScratchA], a                            ; $7056

jr_004_7058:
    ld a, $10                                     ; $7058
    ldh [hScratchB], a                            ; $705A

jr_004_705c:
    ld a, $08                                     ; $705C
    ldh [hScratchD], a                            ; $705E

jr_004_7060:
    ld a, [hl+]                                   ; $7060
    ld [bc], a                                    ; $7061
    inc c                                         ; $7062
    ld a, [hl+]                                   ; $7063
    ld [bc], a                                    ; $7064
    dec c                                         ; $7065
    dec c                                         ; $7066
    dec c                                         ; $7067
    ldh a, [hScratchD]                            ; $7068
    dec a                                         ; $706A
    ldh [hScratchD], a                            ; $706B
    jr nz, jr_004_7060                            ; $706D

    ldh a, [hScratchB]                            ; $706F
    dec a                                         ; $7071
    jr z, jr_004_707c                             ; $7072

    ldh [hScratchB], a                            ; $7074
    ld a, c                                       ; $7076
    add $20                                       ; $7077
    ld c, a                                       ; $7079
    jr jr_004_705c                                ; $707A

jr_004_707c:
    ldh a, [hScratchA]                            ; $707C
    dec a                                         ; $707E
    ret z                                         ; $707F

    ldh [hScratchA], a                            ; $7080
    dec b                                         ; $7082
    ld c, $0e                                     ; $7083
    jr jr_004_7058                                ; $7085

; C: same code as the Japanese Fx51_CopyQuads_TR_BL_OnFlipV (0A:6617, 120 bytes, masked match)
Fx51_CopyQuads_TR_BL_OnFlipV::
    ld hl, $a100                                  ; $7087
    ld bc, wPhotoImage + $d0e                     ; $708A
    ld a, $07                                     ; $708D
    ldh [hScratchA], a                            ; $708F

jr_004_7091:
    ld a, $08                                     ; $7091
    ldh [hScratchB], a                            ; $7093

jr_004_7095:
    ld a, $08                                     ; $7095
    ldh [hScratchD], a                            ; $7097

jr_004_7099:
    ld a, [hl+]                                   ; $7099
    ld [bc], a                                    ; $709A
    inc c                                         ; $709B
    ld a, [hl+]                                   ; $709C
    ld [bc], a                                    ; $709D
    dec c                                         ; $709E
    dec c                                         ; $709F
    dec c                                         ; $70A0
    ldh a, [hScratchD]                            ; $70A1
    dec a                                         ; $70A3
    ldh [hScratchD], a                            ; $70A4
    jr nz, jr_004_7099                            ; $70A6

    ldh a, [hScratchB]                            ; $70A8
    dec a                                         ; $70AA
    jr z, jr_004_70b5                             ; $70AB

    ldh [hScratchB], a                            ; $70AD
    ld a, c                                       ; $70AF
    add $20                                       ; $70B0
    ld c, a                                       ; $70B2
    jr jr_004_7095                                ; $70B3

jr_004_70b5:
    ldh a, [hScratchA]                            ; $70B5
    dec a                                         ; $70B7
    jr z, jr_004_70c4                             ; $70B8

    ldh [hScratchA], a                            ; $70BA
    dec b                                         ; $70BC
    ld c, $0e                                     ; $70BD
    inc h                                         ; $70BF
    ld l, $00                                     ; $70C0
    jr jr_004_7091                                ; $70C2

jr_004_70c4:
    ld hl, $a880                                  ; $70C4
    ld bc, $c68e                                  ; $70C7
    ld a, $07                                     ; $70CA
    ldh [hScratchA], a                            ; $70CC

jr_004_70ce:
    ld a, $08                                     ; $70CE
    ldh [hScratchB], a                            ; $70D0

jr_004_70d2:
    ld a, $08                                     ; $70D2
    ldh [hScratchD], a                            ; $70D4

jr_004_70d6:
    ld a, [hl+]                                   ; $70D6
    ld [bc], a                                    ; $70D7
    inc c                                         ; $70D8
    ld a, [hl+]                                   ; $70D9
    ld [bc], a                                    ; $70DA
    dec c                                         ; $70DB
    dec c                                         ; $70DC
    dec c                                         ; $70DD
    ldh a, [hScratchD]                            ; $70DE
    dec a                                         ; $70E0
    ldh [hScratchD], a                            ; $70E1
    jr nz, jr_004_70d6                            ; $70E3

    ldh a, [hScratchB]                            ; $70E5
    dec a                                         ; $70E7
    jr z, jr_004_70f2                             ; $70E8

    ldh [hScratchB], a                            ; $70EA
    ld a, c                                       ; $70EC
    add $20                                       ; $70ED
    ld c, a                                       ; $70EF
    jr jr_004_70d2                                ; $70F0

jr_004_70f2:
    ldh a, [hScratchA]                            ; $70F2
    dec a                                         ; $70F4
    ret z                                         ; $70F5

    ldh [hScratchA], a                            ; $70F6
    dec b                                         ; $70F8
    ld c, $8e                                     ; $70F9
    ld l, $80                                     ; $70FB
    jr jr_004_70ce                                ; $70FD

; C: same code as the Japanese Fx52_CopyQuads_TR_BL_BR_OnFlipV (0A:668F, 117 bytes, masked match)
Fx52_CopyQuads_TR_BL_BR_OnFlipV::
    ld hl, $a100                                  ; $70FF
    ld bc, wPhotoImage + $d0e                     ; $7102
    ld a, $07                                     ; $7105
    ldh [hScratchA], a                            ; $7107

jr_004_7109:
    ld a, $10                                     ; $7109
    ldh [hScratchB], a                            ; $710B

jr_004_710d:
    ld a, $08                                     ; $710D
    ldh [hScratchD], a                            ; $710F

jr_004_7111:
    ld a, [hl+]                                   ; $7111
    ld [bc], a                                    ; $7112
    inc c                                         ; $7113
    ld a, [hl+]                                   ; $7114
    ld [bc], a                                    ; $7115
    dec c                                         ; $7116
    dec c                                         ; $7117
    dec c                                         ; $7118
    ldh a, [hScratchD]                            ; $7119
    dec a                                         ; $711B
    ldh [hScratchD], a                            ; $711C
    jr nz, jr_004_7111                            ; $711E

    ldh a, [hScratchB]                            ; $7120
    dec a                                         ; $7122
    jr z, jr_004_712d                             ; $7123

    ldh [hScratchB], a                            ; $7125
    ld a, c                                       ; $7127
    add $20                                       ; $7128
    ld c, a                                       ; $712A
    jr jr_004_710d                                ; $712B

jr_004_712d:
    ldh a, [hScratchA]                            ; $712D
    dec a                                         ; $712F
    jr z, jr_004_7139                             ; $7130

    ldh [hScratchA], a                            ; $7132
    dec b                                         ; $7134
    ld c, $0e                                     ; $7135
    jr jr_004_7109                                ; $7137

jr_004_7139:
    ld hl, $a880                                  ; $7139
    ld bc, $c68e                                  ; $713C
    ld a, $07                                     ; $713F
    ldh [hScratchA], a                            ; $7141

jr_004_7143:
    ld a, $08                                     ; $7143
    ldh [hScratchB], a                            ; $7145

jr_004_7147:
    ld a, $08                                     ; $7147
    ldh [hScratchD], a                            ; $7149

jr_004_714b:
    ld a, [hl+]                                   ; $714B
    ld [bc], a                                    ; $714C
    inc c                                         ; $714D
    ld a, [hl+]                                   ; $714E
    ld [bc], a                                    ; $714F
    dec c                                         ; $7150
    dec c                                         ; $7151
    dec c                                         ; $7152
    ldh a, [hScratchD]                            ; $7153
    dec a                                         ; $7155
    ldh [hScratchD], a                            ; $7156
    jr nz, jr_004_714b                            ; $7158

    ldh a, [hScratchB]                            ; $715A
    dec a                                         ; $715C
    jr z, jr_004_7167                             ; $715D

    ldh [hScratchB], a                            ; $715F
    ld a, c                                       ; $7161
    add $20                                       ; $7162
    ld c, a                                       ; $7164
    jr jr_004_7147                                ; $7165

jr_004_7167:
    ldh a, [hScratchA]                            ; $7167
    dec a                                         ; $7169
    ret z                                         ; $716A

    ldh [hScratchA], a                            ; $716B
    dec b                                         ; $716D
    ld c, $8e                                     ; $716E
    ld l, $80                                     ; $7170
    jr jr_004_7143                                ; $7172

; C: entry $53 of the effect table 04:5E8A, the same entry as the Japanese 0A:6704 Fx53_CopyTop10Rows_OnFlipV (the two
; tables pair one to one); same code shape
Fx53_CopyTop10Rows_OnFlipV::
    ld hl, $a500                                  ; $7174
    ld bc, wPhotoImage + $90e                     ; $7177
    ld a, $0a                                     ; $717A
    ldh [hScratchA], a                            ; $717C

jr_004_717e:
    ld a, $10                                     ; $717E
    ldh [hScratchB], a                            ; $7180

jr_004_7182:
    ld a, $08                                     ; $7182
    ldh [hScratchD], a                            ; $7184

jr_004_7186:
    ld a, [hl+]                                   ; $7186
    ld [bc], a                                    ; $7187
    inc c                                         ; $7188
    ld a, [hl+]                                   ; $7189
    ld [bc], a                                    ; $718A
    dec c                                         ; $718B
    dec c                                         ; $718C
    dec c                                         ; $718D
    ldh a, [hScratchD]                            ; $718E
    dec a                                         ; $7190
    ldh [hScratchD], a                            ; $7191
    jr nz, jr_004_7186                            ; $7193

    ldh a, [hScratchB]                            ; $7195
    dec a                                         ; $7197
    jr z, jr_004_71a2                             ; $7198

    ldh [hScratchB], a                            ; $719A
    ld a, c                                       ; $719C
    add $20                                       ; $719D
    ld c, a                                       ; $719F
    jr jr_004_7182                                ; $71A0

jr_004_71a2:
    ldh a, [hScratchA]                            ; $71A2
    dec a                                         ; $71A4
    ret z                                         ; $71A5

    ldh [hScratchA], a                            ; $71A6
    dec b                                         ; $71A8
    ld c, $0e                                     ; $71A9
    jr jr_004_717e                                ; $71AB

; C: entry $54 of the effect table 04:5E8A, the same entry as the Japanese 0A:673D Fx54_CopyBottom4Rows_OnFlipV (the
; two tables pair one to one); same code shape
Fx54_CopyBottom4Rows_OnFlipV::
    ld hl, $a100                                  ; $71AD
    ld bc, wPhotoImage + $d0e                     ; $71B0
    ld a, $04                                     ; $71B3
    ldh [hScratchA], a                            ; $71B5

jr_004_71b7:
    ld a, $10                                     ; $71B7
    ldh [hScratchB], a                            ; $71B9

jr_004_71bb:
    ld a, $08                                     ; $71BB
    ldh [hScratchD], a                            ; $71BD

jr_004_71bf:
    ld a, [hl+]                                   ; $71BF
    ld [bc], a                                    ; $71C0
    inc c                                         ; $71C1
    ld a, [hl+]                                   ; $71C2
    ld [bc], a                                    ; $71C3
    dec c                                         ; $71C4
    dec c                                         ; $71C5
    dec c                                         ; $71C6
    ldh a, [hScratchD]                            ; $71C7
    dec a                                         ; $71C9
    ldh [hScratchD], a                            ; $71CA
    jr nz, jr_004_71bf                            ; $71CC

    ldh a, [hScratchB]                            ; $71CE
    dec a                                         ; $71D0
    jr z, jr_004_71db                             ; $71D1

    ldh [hScratchB], a                            ; $71D3
    ld a, c                                       ; $71D5
    add $20                                       ; $71D6
    ld c, a                                       ; $71D8
    jr jr_004_71bb                                ; $71D9

jr_004_71db:
    ldh a, [hScratchA]                            ; $71DB
    dec a                                         ; $71DD
    ret z                                         ; $71DE

    ldh [hScratchA], a                            ; $71DF
    dec b                                         ; $71E1
    ld c, $0e                                     ; $71E2
    jr jr_004_71b7                                ; $71E4

; C: entry $55 of the effect table 04:5E8A, the same entry as the Japanese 0A:6776 Fx55_CopyTop4Rows_OnFlipV (the two
; tables pair one to one); same code shape
Fx55_CopyTop4Rows_OnFlipV::
    ld hl, $ab00                                  ; $71E6
    ld bc, $c30e                                  ; $71E9
    ld a, $04                                     ; $71EC
    ldh [hScratchA], a                            ; $71EE

jr_004_71f0:
    ld a, $10                                     ; $71F0
    ldh [hScratchB], a                            ; $71F2

jr_004_71f4:
    ld a, $08                                     ; $71F4
    ldh [hScratchD], a                            ; $71F6

jr_004_71f8:
    ld a, [hl+]                                   ; $71F8
    ld [bc], a                                    ; $71F9
    inc c                                         ; $71FA
    ld a, [hl+]                                   ; $71FB
    ld [bc], a                                    ; $71FC
    dec c                                         ; $71FD
    dec c                                         ; $71FE
    dec c                                         ; $71FF
    ldh a, [hScratchD]                            ; $7200
    dec a                                         ; $7202
    ldh [hScratchD], a                            ; $7203
    jr nz, jr_004_71f8                            ; $7205

    ldh a, [hScratchB]                            ; $7207
    dec a                                         ; $7209
    jr z, jr_004_7214                             ; $720A

    ldh [hScratchB], a                            ; $720C
    ld a, c                                       ; $720E
    add $20                                       ; $720F
    ld c, a                                       ; $7211
    jr jr_004_71f4                                ; $7212

jr_004_7214:
    ldh a, [hScratchA]                            ; $7214
    dec a                                         ; $7216
    ret z                                         ; $7217

    ldh [hScratchA], a                            ; $7218
    dec b                                         ; $721A
    ld c, $0e                                     ; $721B
    jr jr_004_71f0                                ; $721D

; C: entry $56 of the effect table 04:5E8A, the same entry as the Japanese 0A:67AF Fx56_CopyBottom10Rows_OnFlipV (the
; two tables pair one to one); same code shape
Fx56_CopyBottom10Rows_OnFlipV::
    ld hl, $a100                                  ; $721F
    ld bc, $cd0e                                  ; $7222
    ld a, $0a                                     ; $7225
    ldh [hScratchA], a                            ; $7227

jr_004_7229:
    ld a, $10                                     ; $7229
    ldh [hScratchB], a                            ; $722B

jr_004_722d:
    ld a, $08                                     ; $722D
    ldh [hScratchD], a                            ; $722F

jr_004_7231:
    ld a, [hl+]                                   ; $7231
    ld [bc], a                                    ; $7232
    inc c                                         ; $7233
    ld a, [hl+]                                   ; $7234
    ld [bc], a                                    ; $7235
    dec c                                         ; $7236
    dec c                                         ; $7237
    dec c                                         ; $7238
    ldh a, [hScratchD]                            ; $7239
    dec a                                         ; $723B
    ldh [hScratchD], a                            ; $723C
    jr nz, jr_004_7231                            ; $723E

    ldh a, [hScratchB]                            ; $7240
    dec a                                         ; $7242
    jr z, jr_004_724d                             ; $7243

    ldh [hScratchB], a                            ; $7245
    ld a, c                                       ; $7247
    add $20                                       ; $7248
    ld c, a                                       ; $724A
    jr jr_004_722d                                ; $724B

jr_004_724d:
    ldh a, [hScratchA]                            ; $724D
    dec a                                         ; $724F
    ret z                                         ; $7250

    ldh [hScratchA], a                            ; $7251
    dec b                                         ; $7253
    ld c, $0e                                     ; $7254
    jr jr_004_7229                                ; $7256

; C: same code as the Japanese Fx57_CopyWindow_OnFlipV (0A:67E8, 60 bytes, masked match)
Fx57_CopyWindow_OnFlipV::
    ld hl, $a430                                  ; $7258
    ld bc, wPhotoImage + $a3e                     ; $725B
    ld a, $08                                     ; $725E
    ldh [hScratchA], a                            ; $7260

jr_004_7262:
    ld a, $0a                                     ; $7262
    ldh [hScratchB], a                            ; $7264

jr_004_7266:
    ld a, $08                                     ; $7266
    ldh [hScratchD], a                            ; $7268

jr_004_726a:
    ld a, [hl+]                                   ; $726A
    ld [bc], a                                    ; $726B
    inc c                                         ; $726C
    ld a, [hl+]                                   ; $726D
    ld [bc], a                                    ; $726E
    dec c                                         ; $726F
    dec c                                         ; $7270
    dec c                                         ; $7271
    ldh a, [hScratchD]                            ; $7272
    dec a                                         ; $7274
    ldh [hScratchD], a                            ; $7275
    jr nz, jr_004_726a                            ; $7277

    ldh a, [hScratchB]                            ; $7279
    dec a                                         ; $727B
    jr z, jr_004_7286                             ; $727C

    ldh [hScratchB], a                            ; $727E
    ld a, c                                       ; $7280
    add $20                                       ; $7281
    ld c, a                                       ; $7283
    jr jr_004_7266                                ; $7284

jr_004_7286:
    ldh a, [hScratchA]                            ; $7286
    dec a                                         ; $7288
    ret z                                         ; $7289

    ldh [hScratchA], a                            ; $728A
    dec b                                         ; $728C
    ld c, $3e                                     ; $728D
    inc h                                         ; $728F
    ld l, $30                                     ; $7290
    jr jr_004_7262                                ; $7292

; C: entry $58 of the effect table 04:5E8A, the same entry as the Japanese 0A:6824 Fx58_CopyQuadBR_OnFlipV (the two
; tables pair one to one); same code shape
Fx58_CopyQuadBR_OnFlipV::
    ld hl, $a180                                  ; $7294
    ld bc, wPhotoImage + $d8e                     ; $7297
    ld a, $07                                     ; $729A
    ldh [hScratchA], a                            ; $729C

jr_004_729e:
    ld a, $08                                     ; $729E
    ldh [hScratchB], a                            ; $72A0

jr_004_72a2:
    ld a, $08                                     ; $72A2
    ldh [hScratchD], a                            ; $72A4

jr_004_72a6:
    ld a, [hl+]                                   ; $72A6
    ld [bc], a                                    ; $72A7
    inc c                                         ; $72A8
    ld a, [hl+]                                   ; $72A9
    ld [bc], a                                    ; $72AA
    dec c                                         ; $72AB
    dec c                                         ; $72AC
    dec c                                         ; $72AD
    ldh a, [hScratchD]                            ; $72AE
    dec a                                         ; $72B0
    ldh [hScratchD], a                            ; $72B1
    jr nz, jr_004_72a6                            ; $72B3

    ldh a, [hScratchB]                            ; $72B5
    dec a                                         ; $72B7
    jr z, jr_004_72c2                             ; $72B8

    ldh [hScratchB], a                            ; $72BA
    ld a, c                                       ; $72BC
    add $20                                       ; $72BD
    ld c, a                                       ; $72BF
    jr jr_004_72a2                                ; $72C0

jr_004_72c2:
    ldh a, [hScratchA]                            ; $72C2
    dec a                                         ; $72C4
    ret z                                         ; $72C5

    ldh [hScratchA], a                            ; $72C6
    dec b                                         ; $72C8
    ld c, $8e                                     ; $72C9
    ld l, $80                                     ; $72CB
    jr jr_004_729e                                ; $72CD

; C: entry $59 of the effect table 04:5E8A, the same entry as the Japanese 0A:685F Fx59_Nop (the two tables pair one
; to one); ret
Fx59_Nop::
    ret                                           ; $72CF


; C: entry $5A of the effect table 04:5E8A, the same entry as the Japanese 0A:6860 Fx5A_Nop (the two tables pair one
; to one); ret
Fx5A_Nop::
    ret                                           ; $72D0


; C: entry $5B of the effect table 04:5E8A, the same entry as the Japanese 0A:6861 Fx5B_Nop (the two tables pair one
; to one); ret
Fx5B_Nop::
    ret                                           ; $72D1


; C: entry $5C of the effect table 04:5E8A, the same entry as the Japanese 0A:6862 Fx5C_Nop (the two tables pair one
; to one); ret
Fx5C_Nop::
    ret                                           ; $72D2


; C: entry $5D of the effect table 04:5E8A, the same entry as the Japanese 0A:6863 Fx5D_Nop (the two tables pair one
; to one); ret
Fx5D_Nop::
    ret                                           ; $72D3


; C: entry $5E of the effect table 04:5E8A, the same entry as the Japanese 0A:6864 Fx5E_Nop (the two tables pair one
; to one); ret
Fx5E_Nop::
    ret                                           ; $72D4


; C: entry $5F of the effect table 04:5E8A, the same entry as the Japanese 0A:6865 Fx5F_Nop (the two tables pair one
; to one); ret
Fx5F_Nop::
    ret                                           ; $72D5


Jump_004_72d6:
    ld hl, $a100                                  ; $72D6
    ld b, HIGH(Cam_ReduceTbl_Lo)                  ; $72D9
    ld a, $07                                     ; $72DB
    ldh [hScratchA], a                            ; $72DD

Jump_004_72df:
    ld a, $08                                     ; $72DF
    ldh [hScratchB], a                            ; $72E1

; C: same code as the Japanese FxShared_ReduceBody_G0_GroupTop (0A:6873, 147 bytes, masked match)
FxShared_ReduceBody_G0_GroupTop::
    ld a, $04                                     ; $72E3
    ldh [hScratchD], a                            ; $72E5

jr_004_72e7:
    ld c, [hl]                                    ; $72E7
    ld a, [bc]                                    ; $72E8
    swap a                                        ; $72E9
    ldh [hScratchC], a                            ; $72EB
    ld a, l                                       ; $72ED
    add $10                                       ; $72EE
    ld l, a                                       ; $72F0
    ld c, [hl]                                    ; $72F1
    ld a, [bc]                                    ; $72F2
    ld c, a                                       ; $72F3
    ldh a, [hScratchC]                            ; $72F4
    or c                                          ; $72F6
    ld [de], a                                    ; $72F7
    inc e                                         ; $72F8
    ld a, l                                       ; $72F9
    sub $0f                                       ; $72FA
    ld l, a                                       ; $72FC
    ld c, [hl]                                    ; $72FD
    ld a, [bc]                                    ; $72FE
    swap a                                        ; $72FF
    ldh [hScratchC], a                            ; $7301
    ld a, l                                       ; $7303
    add $10                                       ; $7304
    ld l, a                                       ; $7306
    ld c, [hl]                                    ; $7307
    ld a, [bc]                                    ; $7308
    ld c, a                                       ; $7309
    ldh a, [hScratchC]                            ; $730A
    or c                                          ; $730C
    ld [de], a                                    ; $730D
    inc e                                         ; $730E
    ld a, l                                       ; $730F
    sub $0d                                       ; $7310
    ld l, a                                       ; $7312
    ldh a, [hScratchD]                            ; $7313
    dec a                                         ; $7315
    ldh [hScratchD], a                            ; $7316
    jr nz, jr_004_72e7                            ; $7318

    inc h                                         ; $731A
    ld a, l                                       ; $731B
    sub $10                                       ; $731C
    ld l, a                                       ; $731E
    ld a, $04                                     ; $731F
    ldh [hScratchD], a                            ; $7321

jr_004_7323:
    ld c, [hl]                                    ; $7323
    ld a, [bc]                                    ; $7324
    swap a                                        ; $7325
    ldh [hScratchC], a                            ; $7327
    ld a, l                                       ; $7329
    add $10                                       ; $732A
    ld l, a                                       ; $732C
    ld c, [hl]                                    ; $732D
    ld a, [bc]                                    ; $732E
    ld c, a                                       ; $732F
    ldh a, [hScratchC]                            ; $7330
    or c                                          ; $7332
    ld [de], a                                    ; $7333
    inc e                                         ; $7334
    ld a, l                                       ; $7335
    sub $0f                                       ; $7336
    ld l, a                                       ; $7338
    ld c, [hl]                                    ; $7339
    ld a, [bc]                                    ; $733A
    swap a                                        ; $733B
    ldh [hScratchC], a                            ; $733D
    ld a, l                                       ; $733F
    add $10                                       ; $7340
    ld l, a                                       ; $7342
    ld c, [hl]                                    ; $7343
    ld a, [bc]                                    ; $7344
    ld c, a                                       ; $7345
    ldh a, [hScratchC]                            ; $7346
    or c                                          ; $7348
    ld [de], a                                    ; $7349
    inc e                                         ; $734A
    ld a, l                                       ; $734B
    sub $0d                                       ; $734C
    ld l, a                                       ; $734E
    ldh a, [hScratchD]                            ; $734F
    dec a                                         ; $7351
    ldh [hScratchD], a                            ; $7352
    jr nz, jr_004_7323                            ; $7354

    ldh a, [hScratchB]                            ; $7356
    dec a                                         ; $7358
    jr z, jr_004_7365                             ; $7359

    ldh [hScratchB], a                            ; $735B
    dec h                                         ; $735D
    ld a, l                                       ; $735E
    add $10                                       ; $735F
    ld l, a                                       ; $7361
    jp FxShared_ReduceBody_G0_GroupTop            ; $7362


jr_004_7365:
    ldh a, [hScratchA]                            ; $7365
    dec a                                         ; $7367
    ret z                                         ; $7368

    ldh [hScratchA], a                            ; $7369
    inc d                                         ; $736B
    ld a, e                                       ; $736C
    add $80                                       ; $736D
    ld e, a                                       ; $736F
    inc h                                         ; $7370
    ld l, $00                                     ; $7371
    jp Jump_004_72df                              ; $7373


Jump_004_7376:
    ld hl, $a100                                  ; $7376
    ld b, $47                                     ; $7379
    ld a, $07                                     ; $737B
    ldh [hScratchA], a                            ; $737D

Jump_004_737f:
    ld a, $08                                     ; $737F
    ldh [hScratchB], a                            ; $7381

; C: same code as the Japanese FxShared_ReduceBody_G1_GroupTop (0A:6913, 151 bytes, masked match)
FxShared_ReduceBody_G1_GroupTop::
    ld a, $04                                     ; $7383
    ldh [hScratchD], a                            ; $7385

jr_004_7387:
    ld c, [hl]                                    ; $7387
    ld a, [bc]                                    ; $7388
    ldh [hScratchC], a                            ; $7389
    ld a, l                                       ; $738B
    add $10                                       ; $738C
    ld l, a                                       ; $738E
    ld c, [hl]                                    ; $738F
    ld a, [bc]                                    ; $7390
    swap a                                        ; $7391
    ld c, a                                       ; $7393
    ldh a, [hScratchC]                            ; $7394
    or c                                          ; $7396
    ld [de], a                                    ; $7397
    inc e                                         ; $7398
    ld a, l                                       ; $7399
    sub $0f                                       ; $739A
    ld l, a                                       ; $739C
    ld c, [hl]                                    ; $739D
    ld a, [bc]                                    ; $739E
    ldh [hScratchC], a                            ; $739F
    ld a, l                                       ; $73A1
    add $10                                       ; $73A2
    ld l, a                                       ; $73A4
    ld c, [hl]                                    ; $73A5
    ld a, [bc]                                    ; $73A6
    swap a                                        ; $73A7
    ld c, a                                       ; $73A9
    ldh a, [hScratchC]                            ; $73AA
    or c                                          ; $73AC
    ld [de], a                                    ; $73AD
    inc e                                         ; $73AE
    ld a, l                                       ; $73AF
    sub $0d                                       ; $73B0
    ld l, a                                       ; $73B2
    ldh a, [hScratchD]                            ; $73B3
    dec a                                         ; $73B5
    ldh [hScratchD], a                            ; $73B6
    jr nz, jr_004_7387                            ; $73B8

    inc h                                         ; $73BA
    ld a, l                                       ; $73BB
    sub $10                                       ; $73BC
    ld l, a                                       ; $73BE
    ld a, $04                                     ; $73BF
    ldh [hScratchD], a                            ; $73C1

jr_004_73c3:
    ld c, [hl]                                    ; $73C3
    ld a, [bc]                                    ; $73C4
    ldh [hScratchC], a                            ; $73C5
    ld a, l                                       ; $73C7
    add $10                                       ; $73C8
    ld l, a                                       ; $73CA
    ld c, [hl]                                    ; $73CB
    ld a, [bc]                                    ; $73CC
    swap a                                        ; $73CD
    ld c, a                                       ; $73CF
    ldh a, [hScratchC]                            ; $73D0
    or c                                          ; $73D2
    ld [de], a                                    ; $73D3
    inc e                                         ; $73D4
    ld a, l                                       ; $73D5
    sub $0f                                       ; $73D6
    ld l, a                                       ; $73D8
    ld c, [hl]                                    ; $73D9
    ld a, [bc]                                    ; $73DA
    ldh [hScratchC], a                            ; $73DB
    ld a, l                                       ; $73DD
    add $10                                       ; $73DE
    ld l, a                                       ; $73E0
    ld c, [hl]                                    ; $73E1
    ld a, [bc]                                    ; $73E2
    swap a                                        ; $73E3
    ld c, a                                       ; $73E5
    ldh a, [hScratchC]                            ; $73E6
    or c                                          ; $73E8
    ld [de], a                                    ; $73E9
    inc e                                         ; $73EA
    ld a, l                                       ; $73EB
    sub $0d                                       ; $73EC
    ld l, a                                       ; $73EE
    ldh a, [hScratchD]                            ; $73EF
    dec a                                         ; $73F1
    ldh [hScratchD], a                            ; $73F2
    jr nz, jr_004_73c3                            ; $73F4

    ld a, e                                       ; $73F6
    sub $20                                       ; $73F7
    ld e, a                                       ; $73F9
    ldh a, [hScratchB]                            ; $73FA
    dec a                                         ; $73FC
    jr z, jr_004_7409                             ; $73FD

    ldh [hScratchB], a                            ; $73FF
    dec h                                         ; $7401
    ld a, l                                       ; $7402
    add $10                                       ; $7403
    ld l, a                                       ; $7405
    jp FxShared_ReduceBody_G1_GroupTop            ; $7406


jr_004_7409:
    ldh a, [hScratchA]                            ; $7409
    dec a                                         ; $740B
    ret z                                         ; $740C

    ldh [hScratchA], a                            ; $740D
    inc d                                         ; $740F
    ld a, e                                       ; $7410
    add $80                                       ; $7411
    ld e, a                                       ; $7413
    inc h                                         ; $7414
    ld l, $00                                     ; $7415
    jp Jump_004_737f                              ; $7417


Jump_004_741a:
    ld hl, $a100                                  ; $741A
    ld b, HIGH(Cam_ReduceTbl_Lo)                  ; $741D
    ld a, $07                                     ; $741F
    ldh [hScratchA], a                            ; $7421

Jump_004_7423:
    ld a, $08                                     ; $7423
    ldh [hScratchB], a                            ; $7425

; C: same code as the Japanese FxShared_ReduceBody_G2_GroupTop (0A:69B7, 138 bytes, masked match)
FxShared_ReduceBody_G2_GroupTop::
    ld a, $04                                     ; $7427
    ldh [hScratchD], a                            ; $7429

jr_004_742b:
    ld c, [hl]                                    ; $742B
    ld a, [bc]                                    ; $742C
    swap a                                        ; $742D
    ldh [hScratchC], a                            ; $742F
    ld a, l                                       ; $7431
    add $10                                       ; $7432
    ld l, a                                       ; $7434
    ld c, [hl]                                    ; $7435
    ld a, [bc]                                    ; $7436
    ld c, a                                       ; $7437
    ldh a, [hScratchC]                            ; $7438
    or c                                          ; $743A
    ld [de], a                                    ; $743B
    inc e                                         ; $743C
    ld a, l                                       ; $743D
    sub $0f                                       ; $743E
    ld l, a                                       ; $7440
    ld c, [hl]                                    ; $7441
    ld a, [bc]                                    ; $7442
    swap a                                        ; $7443
    ldh [hScratchC], a                            ; $7445
    ld a, l                                       ; $7447
    add $10                                       ; $7448
    ld l, a                                       ; $744A
    ld c, [hl]                                    ; $744B
    ld a, [bc]                                    ; $744C
    ld c, a                                       ; $744D
    ldh a, [hScratchC]                            ; $744E
    or c                                          ; $7450
    ld [de], a                                    ; $7451
    dec e                                         ; $7452
    dec e                                         ; $7453
    dec e                                         ; $7454
    ld a, l                                       ; $7455
    sub $0d                                       ; $7456
    ld l, a                                       ; $7458
    ldh a, [hScratchD]                            ; $7459
    dec a                                         ; $745B
    ldh [hScratchD], a                            ; $745C
    jr nz, jr_004_742b                            ; $745E

    inc h                                         ; $7460
    ld a, l                                       ; $7461
    sub $10                                       ; $7462
    ld l, a                                       ; $7464
    ld a, $04                                     ; $7465
    ldh [hScratchD], a                            ; $7467

jr_004_7469:
    ld c, [hl]                                    ; $7469
    ld a, [bc]                                    ; $746A
    swap a                                        ; $746B
    ldh [hScratchC], a                            ; $746D
    ld a, l                                       ; $746F
    add $10                                       ; $7470
    ld l, a                                       ; $7472
    ld c, [hl]                                    ; $7473
    ld a, [bc]                                    ; $7474
    ld c, a                                       ; $7475
    ldh a, [hScratchC]                            ; $7476
    or c                                          ; $7478
    ld [de], a                                    ; $7479
    inc e                                         ; $747A
    ld a, l                                       ; $747B
    sub $0f                                       ; $747C
    ld l, a                                       ; $747E
    ld c, [hl]                                    ; $747F
    ld a, [bc]                                    ; $7480
    swap a                                        ; $7481
    ldh [hScratchC], a                            ; $7483
    ld a, l                                       ; $7485
    add $10                                       ; $7486
    ld l, a                                       ; $7488
    ld c, [hl]                                    ; $7489
    ld a, [bc]                                    ; $748A
    ld c, a                                       ; $748B
    ldh a, [hScratchC]                            ; $748C
    or c                                          ; $748E
    ld [de], a                                    ; $748F
    dec e                                         ; $7490
    dec e                                         ; $7491
    dec e                                         ; $7492
    ld a, l                                       ; $7493
    sub $0d                                       ; $7494
    ld l, a                                       ; $7496
    ldh a, [hScratchD]                            ; $7497
    dec a                                         ; $7499
    ldh [hScratchD], a                            ; $749A
    jr nz, jr_004_7469                            ; $749C

    ldh a, [hScratchB]                            ; $749E
    dec a                                         ; $74A0
    jr z, FxShared_ReduceBody_G2_OuterLoopTail    ; $74A1

    ldh [hScratchB], a                            ; $74A3
    dec h                                         ; $74A5
    ld a, l                                       ; $74A6
    add $10                                       ; $74A7
    ld l, a                                       ; $74A9
    ld a, e                                       ; $74AA
    add $20                                       ; $74AB
    ld e, a                                       ; $74AD
    jp FxShared_ReduceBody_G2_GroupTop            ; $74AE


; C: same code as the Japanese FxShared_ReduceBody_G2_OuterLoopTail (0A:6A41, 17 bytes, masked match)
FxShared_ReduceBody_G2_OuterLoopTail::
    ldh a, [hScratchA]                            ; $74B1
    dec a                                         ; $74B3
    ret z                                         ; $74B4

    ldh [hScratchA], a                            ; $74B5
    dec d                                         ; $74B7
    ld a, e                                       ; $74B8
    add $a0                                       ; $74B9
    ld e, a                                       ; $74BB
    inc h                                         ; $74BC
    ld l, $00                                     ; $74BD
    jp Jump_004_7423                              ; $74BF


    ; padding
    ds $b3e, $00

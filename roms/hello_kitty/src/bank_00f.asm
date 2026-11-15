; Pocket Camera Hello Kitty (Japan), bank $0F. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00f", ROMX[$4000], BANK[$f]

; C: leftover: 37 bytes (0F:4000-4024) 37 bytes, the same as the Japanese Snd_NoiseNR43Tbl (1F:4000, the NR43 value
; per noise note); this sound engine does not read them
Leftover_0F_4000_Snd_NoiseNR43Tbl::
    db $84, $77, $76, $75, $74, $67, $66, $65, $64, $57, $56, $55, $54, $47, $46, $45
    db $44, $37, $36, $35, $34, $27, $26, $25, $24, $17, $16, $15, $14, $07, $06, $05
    db $04, $03, $02, $01, $00

; C: leftover: 20 bytes (0F:4025-4038) 20 bytes, the same as the Japanese Snd_LengthTbl (1F:4025); not read here;
; 0F:559D adds the note offset to $4037, two bytes before Snd_FreqTbl, so its last two bytes are only the base of a
; 1-based index
Leftover_0F_4025_Snd_LengthTbl::
    db $3d, $3a, $38, $35, $32, $30, $2d, $2a, $20, $3d, $38, $32, $2a, $26, $20, $14
    db $08, $00, $00, $0f

; C: the same 307 bytes as the Japanese Snd_FreqTbl (1F:4039); read in the runs by Snd_Trk_NoteOn, Snd_LoadWaveRam;
; first read on the screen Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz)
Snd_FreqTbl::
    INCBIN "data/bank_0f/Snd_FreqTbl.bin" ; $4039, 307 bytes
; C: read in the runs by Snd_Trk_FetchOp, Snd_Trk_NoteOn; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_416C_Mode00_BootAndTitle_State00::
    db $03, $06, $0c, $18, $30, $09, $12, $24, $04, $08, $02, $01, $02, $04, $08, $10
    db $20, $40, $0c, $18, $30, $05, $03, $01, $03, $05, $0a, $14, $28, $50, $0f, $1e
    db $3c, $06, $0d, $02, $01, $04, $16, $78, $03, $06, $0c, $18, $30, $60, $12, $24
    db $48, $08, $10, $02, $01, $04, $16, $78, $03, $07, $0e, $1c, $38, $70, $15, $2a
    db $54, $09, $12, $02, $01, $09, $05, $04, $04, $08, $10, $20, $40, $80, $18, $30
    db $60, $04, $09, $12, $24, $48, $90, $1b, $36, $6c, $0c, $18, $01

; C: 62 words: channel-1 effect init handlers by sound id 1..$3E (the same layout as the Japanese Sfx1_InitTbl of bank
; $1F)
Sfx1_InitTbl::
    dw Sfx1_Init_01
    dw Sfx1_Init_02
    dw Sfx1_Init_03
    dw Sfx1_Init_04
    dw Sfx1_Init_05
    dw Sfx1_Init_06_0D
    dw Sfx1_Init_07
    dw Sfx1_Init_08
    dw Sfx1_Init_09
    dw Sfx1_Init_0A
    dw Sfx1_Init_0B
    dw Sfx1_Init_0C
    dw Sfx1_Init_06_0D
    dw Sfx1_Init_0E
    dw Sfx1_Init_0F
    dw Sfx1_Init_10
    dw Sfx1_Init_11
    dw Sfx1_Init_12
    dw Sfx1_Init_13
    dw Sfx1_Init_14
    dw Sfx1_Init_15
    dw Sfx1_Init_16
    dw Sfx1_Init_17
    dw Sfx1_Init_18
    dw Sfx1_Init_19_3A
    dw Sfx1_Init_1A
    dw Sfx1_Init_1B
    dw Sfx1_Init_1C
    dw Sfx1_Init_1D
    dw Sfx1_Init_1E_26
    dw Sfx1_Init_1F
    dw Sfx1_Init_20
    dw Sfx1_Init_21
    dw Sfx1_Init_22
    dw Sfx1_Init_23_2B
    dw Sfx1_Init_24
    dw Sfx1_Init_25
    dw Sfx1_Init_1E_26
    dw Sfx1_Init_27
    dw Sfx1_Init_28
    dw Sfx1_Init_29
    dw Sfx1_Init_2A
    dw Sfx1_Init_23_2B
    dw Sfx1_Init_2C
    dw Sfx1_Init_2D
    dw Sfx1_Init_2E
    dw Sfx1_Init_2F
    dw Sfx1_Init_30
    dw Sfx1_Init_31
    dw Sfx1_Init_32
    dw Sfx1_Init_33
    dw Sfx1_Init_34
    dw Sfx1_Init_35
    dw Sfx1_Init_36
    dw Sfx1_Init_37
    dw Sfx1_Init_38
    dw Sfx1_Init_39
    dw Sfx1_Init_19_3A
    dw Sfx1_Init_3B
    dw Sfx1_Init_3C_3D_3E
    dw Sfx1_Init_3C_3D_3E
    dw Sfx1_Init_3C_3D_3E

; C: 62 words: channel-1 effect step handlers by sound id 1..$3E (the same layout as the Japanese Sfx1_StepTbl of bank
; $1F)
Sfx1_StepTbl::
    dw Sfx1_Step_Shared
    dw Sfx1_Step_02
    dw Sfx1_Step_03
    dw Sfx1_Step_Shared
    dw Sfx1_Step_05
    dw Sfx1_Step_06_0D
    dw Sfx1_Step_Shared
    dw Sfx1_Step_08
    dw Sfx1_Step_09
    dw Sfx1_Step_0A
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_06_0D
    dw Sfx1_Step_0E
    dw Sfx1_Step_0F
    dw Sfx1_Step_10
    dw Sfx1_Step_11
    dw Sfx1_Step_Shared
    dw Sfx1_Step_13
    dw Sfx1_Step_14
    dw Sfx1_Step_15
    dw Sfx1_Step_16
    dw Sfx1_Step_17
    dw Sfx1_Step_Shared
    dw Sfx1_Step_19_3A
    dw Sfx1_Step_1A_1E
    dw Sfx1_Step_1B
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_1A_1E
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_24
    dw Sfx1_Step_25
    dw Sfx1_Step_26
    dw Sfx1_Step_Shared
    dw Sfx1_Step_28
    dw Sfx1_Step_29
    dw Sfx1_Step_2A
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_Shared
    dw Sfx1_Step_2F
    dw Sfx1_Step_30
    dw Sfx1_Step_31
    dw Sfx1_Step_32
    dw Sfx1_Step_33
    dw Sfx1_Step_Shared
    dw Sfx1_Step_35
    dw Sfx1_Step_36
    dw Sfx1_Step_37
    dw Sfx1_Step_38
    dw Sfx1_Step_39
    dw Sfx1_Step_19_3A
    dw Sfx1_Step_3B
    dw Sfx1_Step_3C_3D_3E
    dw Sfx1_Step_3C_3D_3E
    dw Sfx1_Step_3C_3D_3E

; C: 10 words: channel-3 effect init handlers by sound id 1..$0A (the same layout as the Japanese Sfx3_InitTbl of bank
; $1F)
Sfx3_InitTbl::
    dw Sfx3_Init_01
    dw Sfx3_Init_02
    dw Sfx3_Init_03
    dw Sfx3_Init_04
    dw Sfx3_Init_05_0A
    dw Sfx3_Init_06
    dw Sfx3_Init_07
    dw Sfx3_Init_08
    dw Sfx3_Init_09
    dw Sfx3_Init_05_0A

; C: 10 words: channel-3 effect step handlers by sound id 1..$0A (the same layout as the Japanese Sfx3_StepTbl of bank
; $1F)
Sfx3_StepTbl::
    dw Sfx3_Step_01
    dw Sfx3_Step_02
    dw Sfx3_Step_03
    dw Sfx3_Step_04
    dw Sfx3_Step_05_0A
    dw Sfx3_Step_06
    dw Sfx3_Step_07
    dw Sfx3_Step_08
    dw Sfx3_Step_09
    dw Sfx3_Step_05_0A

; C: 18 words: channel-4 effect init handlers by sound id 1..$12 (the same layout as the Japanese Sfx4_InitTbl of bank
; $1F)
Sfx4_InitTbl::
    dw Sfx4_Init_01
    dw Sfx4_Init_02
    dw Sfx4_Init_03
    dw Sfx4_Init_04
    dw Sfx4_Init_05
    dw Sfx4_Init_06
    dw Sfx4_Init_07
    dw Sfx4_Init_08
    dw Sfx4_Init_09
    dw Sfx4_Init_0A
    dw Sfx4_Init_0B
    dw Sfx4_Init_0C
    dw Sfx4_Init_0D
    dw Sfx4_Init_0E
    dw Sfx4_Init_0F
    dw Sfx4_Init_10
    dw Sfx4_Init_11
    dw Sfx4_Init_12

; C: 18 words: channel-4 effect step handlers by sound id 1..$12 (the same layout as the Japanese Sfx4_StepTbl of bank
; $1F)
Sfx4_StepTbl::
    dw Sfx4_Step_01
    dw Sfx4_Step_Shared
    dw Sfx4_Step_Shared
    dw Sfx4_Step_04
    dw Sfx4_Step_Shared
    dw Sfx4_Step_06
    dw Sfx4_Step_07
    dw Sfx4_Step_Shared
    dw Sfx4_Step_09
    dw Sfx4_Step_0A
    dw Sfx4_Step_Shared
    dw Sfx4_Step_Shared
    dw Sfx4_Step_Shared
    dw Sfx4_Step_0E
    dw Sfx4_Step_Shared
    dw Sfx4_Step_10
    dw Sfx4_Step_11
    dw Sfx4_Step_12

    db $3e, $00, $c9, $00, $c0, $d0, $20, $85

; C: Sfx1 init handler of the sound ids $04 (entries of Sfx1_InitTbl)
Sfx1_Init_04::
    ld a, $06                                     ; $4339
    ld hl, Sfx4_StepTbl + $27                     ; $433B
    jp Snd_Sfx_Start                              ; $433E


; C: ret (bytes after it are data)
Sfx1_Ret4341::
    ret                                           ; $4341


    db $1e, $00, $7b, $ff, $87

; C: Sfx1 init handler of the sound ids $3B (entries of Sfx1_InitTbl)
Sfx1_Init_3B::
    ld a, $10                                     ; $4347
    ld hl, Sfx1_Ret4341 + $1                      ; $4349
    jp Snd_Sfx_Start                              ; $434C


; C: Sfx1 step handler of the Kitty sound ids $3B; same code as the Japanese Sfx1_Step_3B_EraseAnim (its game role
; belongs to the Japanese ROM)
Sfx1_Step_3B::
    call Snd_Sfx_TickCounter                      ; $434F
    and a                                         ; $4352
    ret nz                                        ; $4353

    ld a, SFX4_06                                 ; $4354
    ld [wSndSfx4], a                              ; $4356
    jp Sfx1_Stop                                  ; $4359


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_435C_Mode02_TakePhotos_State01::
    db $00, $fa, $f0, $a2, $c7, $00, $d0, $f0, $d1, $c7

; C: Sfx1 init handler of the sound ids $28 (entries of Sfx1_InitTbl)
Sfx1_Init_28::
    ld a, $06                                     ; $4366
    ld hl, Snd_0F_435C_Mode02_TakePhotos_State01  ; $4368
    jp Snd_Sfx_Start                              ; $436B


; C: Sfx1 step handler of the sound ids $28 (entries of Sfx1_StepTbl)
Sfx1_Step_28::
    call Snd_Sfx_TickCounter                      ; $436E
    and a                                         ; $4371
    ret nz                                        ; $4372

    ld hl, wSndSfx1 + $4                          ; $4373
    inc [hl]                                      ; $4376
    ld a, [hl]                                    ; $4377
    cp $02                                        ; $4378
    jp z, Sfx1_Stop                               ; $437A

    ld hl, Snd_0F_435C_Mode02_TakePhotos_State01 + $5 ; $437D
    jp Jump_00f_5214                              ; $4380


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4383_Mode02_TakePhotos_State01::
    db $00, $f8, $f0, $f2, $c6, $00, $c0, $a9, $f8, $c5

; C: Sfx1 init handler of the sound ids $2A (entries of Sfx1_InitTbl)
Sfx1_Init_2A::
    ld a, $06                                     ; $438D
    ld hl, Snd_0F_4383_Mode02_TakePhotos_State01  ; $438F
    jp Snd_Sfx_Start                              ; $4392


; C: Sfx1 step handler of the sound ids $2A (entries of Sfx1_StepTbl)
Sfx1_Step_2A::
    call Snd_Sfx_TickCounter                      ; $4395
    and a                                         ; $4398
    ret nz                                        ; $4399

    ld hl, wSndSfx1 + $4                          ; $439A
    inc [hl]                                      ; $439D
    ld a, [hl]                                    ; $439E
    cp $02                                        ; $439F
    jp z, Sfx1_Stop                               ; $43A1

    ld hl, Snd_0F_4383_Mode02_TakePhotos_State01 + $5 ; $43A4
    jp Jump_00f_5214                              ; $43A7


    db $3e, $80, $d0, $70, $87

; C: Sfx1 init handler of the sound ids $24 (entries of Sfx1_InitTbl)
Sfx1_Init_24::
    ld a, $15                                     ; $43AF
    ld hl, Sfx1_Step_2A + $15                     ; $43B1
    jp Snd_Sfx_Start                              ; $43B4


; C: Sfx1 step handler of the sound ids $24 (entries of Sfx1_StepTbl)
Sfx1_Step_24::
    call Snd_Sfx_TickCounter                      ; $43B7
    and a                                         ; $43BA
    ret nz                                        ; $43BB

    ld hl, Sfx1_Step_2A + $15                     ; $43BC
    jp Jump_00f_5214                              ; $43BF


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode07_Exchange_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_43C2_Mode07_Exchange_State02::
    db $4c, $c0, $50, $aa, $87

    db $44, $00, $a0, $70, $86

; C: Sfx1 init handler of the sound ids $1E, $26 (entries of Sfx1_InitTbl)
Sfx1_Init_1E_26::
    ld a, $08                                     ; $43CC
    ld hl, Snd_0F_43C2_Mode07_Exchange_State02    ; $43CE
    jp Snd_Sfx_Start                              ; $43D1


; C: Sfx1 step handler of the Kitty sound ids $26; same code as the Japanese Sfx1_Step_26_SpaceFeverBossDeath (its
; game role belongs to the Japanese ROM)
Sfx1_Step_26::
    call Snd_Sfx_TickCounter                      ; $43D4
    and a                                         ; $43D7
    ret nz                                        ; $43D8

    ld a, SFX4_03                                 ; $43D9
    ld [wSndSfx4], a                              ; $43DB
    ld hl, wSndSfx1 + $4                          ; $43DE
    inc [hl]                                      ; $43E1
    bit 0, [hl]                                   ; $43E2
    jr nz, jr_00f_43ec                            ; $43E4

    ld hl, Snd_0F_43C2_Mode07_Exchange_State02    ; $43E6
    jp Jump_00f_5214                              ; $43E9


jr_00f_43ec:
    ld hl, Snd_0F_43C2_Mode07_Exchange_State02 + $5 ; $43EC
    jp Jump_00f_5214                              ; $43EF


    db $25, $00, $5a, $70, $86, $3b, $00, $8a, $88, $87

; C: Sfx1 init handler of the sound ids $25 (entries of Sfx1_InitTbl)
Sfx1_Init_25::
    ld a, $07                                     ; $43FC
    ld hl, Sfx1_Step_26 + $1E                     ; $43FE
    jp Snd_Sfx_Start                              ; $4401


; C: Sfx1 step handler of the Kitty sound ids $25; same code as the Japanese Sfx1_Step_25_SpaceFeverStart (its game
; role belongs to the Japanese ROM)
Sfx1_Step_25::
    call Snd_Sfx_TickCounter                      ; $4404
    and a                                         ; $4407
    ret nz                                        ; $4408

    ld hl, wSndSfx1 + $4                          ; $4409
    inc [hl]                                      ; $440C
    bit 0, [hl]                                   ; $440D
    jr nz, jr_00f_4417                            ; $440F

    ld hl, Sfx1_Step_26 + $1E                     ; $4411
    jp Jump_00f_5214                              ; $4414


jr_00f_4417:
    ld hl, Sfx1_Step_26 + $23                     ; $4417
    jp Jump_00f_5214                              ; $441A


    db $00, $00, $11, $70, $87

; C: Sfx1 init handler of the sound ids $27 (entries of Sfx1_InitTbl)
Sfx1_Init_27::
    ld a, $02                                     ; $4422
    ld hl, Sfx1_Step_25 + $19                     ; $4424
    jp Snd_Sfx_Start                              ; $4427


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0A_NameCard_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_442A_Mode0A_NameCard_State02::
    db $00, $80, $e0, $01, $87

; C: Sfx1 init handler of the Kitty sound ids $0E; same code as the Japanese Sfx1_Init_0E_ChooseD (its game role
; belongs to the Japanese ROM)
Sfx1_Init_0E::
    call Sfx1_Ret4341                             ; $442F
    ret z                                         ; $4432

    ld a, $01                                     ; $4433
    ld [wSndSfx1 + $6], a                         ; $4435
    ld a, $03                                     ; $4438
    ld hl, Snd_0F_442A_Mode0A_NameCard_State02    ; $443A
    jp Snd_Sfx_Start                              ; $443D


; C: Sfx1 step handler of the Kitty sound ids $0E; same code as the Japanese Sfx1_Step_0E_ChooseD (its game role
; belongs to the Japanese ROM)
Sfx1_Step_0E::
    ld hl, wSndSfx1 + $4                          ; $4440
    ld a, [hl]                                    ; $4443
    inc [hl]                                      ; $4444
    cp $19                                        ; $4445
    jp z, Sfx1_Stop                               ; $4447

    ld hl, wSndSfx1 + $6                          ; $444A
    ld c, $70                                     ; $444D
    bit 2, a                                      ; $444F
    jr nz, jr_00f_4455                            ; $4451

    ld c, $b0                                     ; $4453

jr_00f_4455:
    ld a, c                                       ; $4455
    add [hl]                                      ; $4456
    ldh [rNR13], a                                ; $4457
    ret                                           ; $4459


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode07_Exchange_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_445A_Mode07_Exchange_State02::
    db $00, $00, $99, $4e, $86, $00, $00, $aa, $b5, $86

; C: Sfx1 init handler of the sound ids $1A (entries of Sfx1_InitTbl)
Sfx1_Init_1A::
    ld a, $05                                     ; $4464
    ld hl, Snd_0F_445A_Mode07_Exchange_State02    ; $4466
    jp Snd_Sfx_Start                              ; $4469


; C: Sfx1 step handler of the Kitty sound ids $1A, $1E; same code as the Japanese
; Sfx1_Step_1A_1E_HotspotSound07_Choose (its game role belongs to the Japanese ROM)
Sfx1_Step_1A_1E::
    call Snd_Sfx_TickCounter                      ; $446C
    and a                                         ; $446F
    ret nz                                        ; $4470

    ld hl, wSndSfx1 + $4                          ; $4471
    ld a, [hl]                                    ; $4474
    inc [hl]                                      ; $4475
    cp $04                                        ; $4476
    jp z, Sfx1_Stop                               ; $4478

    bit 0, a                                      ; $447B
    jr nz, jr_00f_4485                            ; $447D

    ld hl, Snd_0F_445A_Mode07_Exchange_State02 + $5 ; $447F
    jp Jump_00f_5214                              ; $4482


jr_00f_4485:
    ld hl, Snd_0F_445A_Mode07_Exchange_State02    ; $4485
    jp Jump_00f_5214                              ; $4488


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode00_BootAndTitle_State08
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_448B_Mode00_BootAndTitle_State08::
    db $00, $bb, $90, $80, $c7, $00, $ba, $a0, $89, $c7

; C: Sfx1 init handler of the sound ids $03 (entries of Sfx1_InitTbl)
Sfx1_Init_03::
    ld a, $04                                     ; $4495
    ld hl, Snd_0F_448B_Mode00_BootAndTitle_State08; $4497
    jp Snd_Sfx_Start                              ; $449A


; C: Sfx1 step handler of the Kitty sound ids $03; same code as the Japanese Sfx1_Step_03_KeyA (its game role belongs
; to the Japanese ROM)
Sfx1_Step_03::
    call Snd_Sfx_TickCounter                      ; $449D
    and a                                         ; $44A0
    ret nz                                        ; $44A1

    ld hl, wSndSfx1 + $4                          ; $44A2
    inc [hl]                                      ; $44A5
    ld a, [hl]                                    ; $44A6
    cp $02                                        ; $44A7
    jp z, Sfx1_Stop                               ; $44A9

    ld hl, Snd_0F_448B_Mode00_BootAndTitle_State08; $44AC
    bit 0, a                                      ; $44AF
    jr z, jr_00f_44b6                             ; $44B1

    ld hl, Snd_0F_448B_Mode00_BootAndTitle_State08 + $5 ; $44B3

jr_00f_44b6:
    jp Jump_00f_5214                              ; $44B6


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State09
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_44B9_Mode02_TakePhotos_State09::
    db $00, $bd, $f0, $dd, $c7

; C: Sfx1 init handler of the sound ids $0B (entries of Sfx1_InitTbl)
Sfx1_Init_0B::
    ld a, $03                                     ; $44BE
    ld hl, Snd_0F_44B9_Mode02_TakePhotos_State09  ; $44C0
    call Snd_Sfx_Start                            ; $44C3
    ret                                           ; $44C6


    db $00, $00, $f0, $20, $81

; C: Sfx1 init handler of the sound ids $1C (entries of Sfx1_InitTbl)
Sfx1_Init_1C::
    ld a, $16                                     ; $44CC
    ld hl, Sfx1_Init_0B + $9                      ; $44CE
    jp Snd_Sfx_Start                              ; $44D1


    db $9b, $12, $00, $00, $00, $f2, $12, $83

; C: Sfx1 init handler of the Kitty sound ids $1B; same code as the Japanese Sfx1_Init_1B_SpaceFeverMenuPickGame (its
; game role belongs to the Japanese ROM)
Sfx1_Init_1B::
    ld a, $83                                     ; $44DC
    ld [wSndSfx1 + $7], a                         ; $44DE
    ld a, $0c                                     ; $44E1
    ld hl, Sfx1_Init_1C + $B                      ; $44E3
    jp Snd_Sfx_Start                              ; $44E6


; C: Sfx1 step handler of the sound ids $1B (entries of Sfx1_StepTbl)
Sfx1_Step_1B::
    call Snd_Sfx_TickCounter                      ; $44E9
    and a                                         ; $44EC
    ret nz                                        ; $44ED

    ld bc, Sfx1_Init_1C + $8                      ; $44EE
    ld a, $0c                                     ; $44F1
    jr jr_00f_4562                                ; $44F3

; C: read in the runs by Sfx1_Step_17; first read on the screen Mode01_MainMenu_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_44F5_Mode01_MainMenu_State02::
    db $9d, $ac, $c1, $ff, $ac, $00

; C: Sfx1 init handler of the Kitty sound ids $16; same code as the Japanese Sfx1_Init_16_OptionChange (its game role
; belongs to the Japanese ROM)
Sfx1_Init_16::
    ld a, $87                                     ; $44FB
    ld [wSndSfx1 + $7], a                         ; $44FD
    ld a, $0c                                     ; $4500
    ld hl, Snd_0F_453D_Mode01_MainMenu_State02    ; $4502
    jp Snd_Sfx_Start                              ; $4505


; C: Sfx1 step handler of the sound ids $16 (entries of Sfx1_StepTbl)
Sfx1_Step_16::
    call Snd_Sfx_TickCounter                      ; $4508
    and a                                         ; $450B
    ret nz                                        ; $450C

    ld bc, Snd_0F_44F5_Mode01_MainMenu_State02    ; $450D
    ld a, $04                                     ; $4510
    jr jr_00f_4562                                ; $4512

; C: read in the runs by Sfx1_Step_17, Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4514_Mode03_ViewAlbum_State02::
    db $ff, $11, $ac, $ff, $11, $00, $00, $00, $f0, $ac, $85

; C: Sfx1 init handler of the Kitty sound ids $3C, $3D, $3E; same code as the Japanese
; Sfx1_Init_3C_3D_3E_SpaceFeverPlayerDeathJingle (its game role belongs to the Japanese ROM)
Sfx1_Init_3C_3D_3E::
    ld a, SFX4_02                                 ; $451F
    ld [wSndSfx4], a                              ; $4521
    ld a, $85                                     ; $4524
    ld [wSndSfx1 + $7], a                         ; $4526
    ld a, $14                                     ; $4529
    ld hl, Snd_0F_4514_Mode03_ViewAlbum_State02 + $6 ; $452B
    jp Snd_Sfx_Start                              ; $452E


; C: Sfx1 step handler of the Kitty sound ids $3C, $3D, $3E; same code as the Japanese
; Sfx1_Step_3C_3D_3E_SpaceFeverPlayerDeathJingle (its game role belongs to the Japanese ROM)
Sfx1_Step_3C_3D_3E::
    call Snd_Sfx_TickCounter                      ; $4531
    and a                                         ; $4534
    ret nz                                        ; $4535

    ld bc, Snd_0F_4514_Mode03_ViewAlbum_State02   ; $4536
    ld a, $14                                     ; $4539
    jr jr_00f_4562                                ; $453B

; C: read in the runs by Sfx1_Step_17, Snd_Sfx_Start; first read on the screen Mode01_MainMenu_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_453D_Mode01_MainMenu_State02::
    db $00, $80, $00, $ff, $87, $21, $90, $21, $90, $21, $90

    db $21, $90, $00

; C: same instructions as the Japanese Sfx1_Init_17 (1F:4583) over the whole routine (5 instructions, to the first ret
; / jp), only the addresses differ; code compared
Sfx1_Init_17::
    ld a, $87                                     ; $454B
    ld [wSndSfx1 + $7], a                         ; $454D
    ld a, $08                                     ; $4550
    ld hl, Snd_0F_453D_Mode01_MainMenu_State02    ; $4552
    jp Snd_Sfx_Start                              ; $4555


; C: same code as the Japanese Sfx1_Step_17 (1F:4590, 39 bytes, masked match)
Sfx1_Step_17::
    call Snd_Sfx_TickCounter                      ; $4558
    and a                                         ; $455B
    ret nz                                        ; $455C

    ld a, $05                                     ; $455D
    ld bc, Snd_0F_453D_Mode01_MainMenu_State02 + $5 ; $455F

jr_00f_4562:
    ld [wSndSfx1 + $3], a                         ; $4562
    ld hl, wSndSfx1 + $4                          ; $4565
    ld a, [hl]                                    ; $4568
    inc [hl]                                      ; $4569
    ld l, a                                       ; $456A
    ld h, $00                                     ; $456B
    add hl, bc                                    ; $456D
    ld a, [hl]                                    ; $456E
    and a                                         ; $456F
    jp z, Sfx1_Stop                               ; $4570

    ldh [rNR13], a                                ; $4573
    ld a, $d2                                     ; $4575
    ldh [rNR12], a                                ; $4577
    ld a, [wSndSfx1 + $7]                         ; $4579
    ldh [rNR14], a                                ; $457C
    ret                                           ; $457E


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_457F_Mode02_TakePhotos_State06::
    db $00, $00, $a9, $8e, $86, $00, $00, $ba, $f5, $86

; C: Sfx1 init handler of the sound ids $29 (entries of Sfx1_InitTbl)
Sfx1_Init_29::
    ld a, $04                                     ; $4589
    ld hl, Snd_0F_457F_Mode02_TakePhotos_State06  ; $458B
    jp Snd_Sfx_Start                              ; $458E


; C: Sfx1 step handler of the Kitty sound ids $29; same code as the Japanese Sfx1_Step_29_ChooseB (its game role
; belongs to the Japanese ROM)
Sfx1_Step_29::
    call Snd_Sfx_TickCounter                      ; $4591
    and a                                         ; $4594
    ret nz                                        ; $4595

    ld hl, wSndSfx1 + $4                          ; $4596
    ld a, [hl]                                    ; $4599
    inc [hl]                                      ; $459A
    cp $06                                        ; $459B
    jp z, Sfx1_Stop                               ; $459D

    bit 0, a                                      ; $45A0
    jr nz, jr_00f_45aa                            ; $45A2

    ld hl, Snd_0F_457F_Mode02_TakePhotos_State06 + $5 ; $45A4
    jp Jump_00f_5214                              ; $45A7


jr_00f_45aa:
    ld hl, Snd_0F_457F_Mode02_TakePhotos_State06  ; $45AA
    jp Jump_00f_5214                              ; $45AD


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State00
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_45B0_Mode02_TakePhotos_State00::
    db $00, $80, $e1, $ac, $c7, $00, $80, $e1, $c1, $c7, $00, $80, $e1, $d6, $c7

; C: Sfx1 init handler of the sound ids $05 (entries of Sfx1_InitTbl)
Sfx1_Init_05::
    ld a, $05                                     ; $45BF
    ld hl, Snd_0F_45B0_Mode02_TakePhotos_State00  ; $45C1
    jp Snd_Sfx_Start                              ; $45C4


; C: Sfx1 step handler of the Kitty sound ids $05; same code as the Japanese Sfx1_Step_05_KeyStart (its game role
; belongs to the Japanese ROM)
Sfx1_Step_05::
    call Snd_Sfx_TickCounter                      ; $45C7
    and a                                         ; $45CA
    ret nz                                        ; $45CB

    ld hl, wSndSfx1 + $4                          ; $45CC
    inc [hl]                                      ; $45CF
    ld a, [hl]                                    ; $45D0
    ld hl, Snd_0F_45B0_Mode02_TakePhotos_State00 + $5 ; $45D1
    cp $01                                        ; $45D4
    jr z, jr_00f_45ec                             ; $45D6

    ld hl, Snd_0F_45B0_Mode02_TakePhotos_State00 + $A ; $45D8
    cp $02                                        ; $45DB
    jr z, jr_00f_45ec                             ; $45DD

    ld hl, Snd_0F_45B0_Mode02_TakePhotos_State00 + $5 ; $45DF
    cp $03                                        ; $45E2
    jr z, jr_00f_45ec                             ; $45E4

    cp $04                                        ; $45E6
    jp z, Sfx1_Stop                               ; $45E8

    ret                                           ; $45EB


jr_00f_45ec:
    jp Jump_00f_5214                              ; $45EC


    db $dc, $80, $80, $f0, $c7, $00, $bc, $c0, $b2, $c7, $b2, $a2, $92, $82, $72, $62
    db $52, $42, $32, $22, $11, $01, $00

; C: Sfx1 init handler of the sound ids $0A (entries of Sfx1_InitTbl)
Sfx1_Init_0A::
    ld a, $04                                     ; $4606
    ld hl, Sfx1_Step_05 + $28                     ; $4608
    jp Snd_Sfx_Start                              ; $460B


; C: Sfx1 step handler of the Kitty sound ids $0A; same code as the Japanese Sfx1_Step_0A_MainMenuPageTurn (its game
; role belongs to the Japanese ROM)
Sfx1_Step_0A::
    call Snd_Sfx_TickCounter                      ; $460E
    and a                                         ; $4611
    ret nz                                        ; $4612

    ld hl, wSndSfx1 + $4                          ; $4613
    ld a, [hl]                                    ; $4616
    inc [hl]                                      ; $4617
    cp $04                                        ; $4618
    jr z, jr_00f_4632                             ; $461A

    cp $04                                        ; $461C
    ret c                                         ; $461E

    ld c, a                                       ; $461F
    ld b, $00                                     ; $4620
    ld hl, Sfx1_Step_05 + $32                     ; $4622
    add hl, bc                                    ; $4625
    ld a, [hl]                                    ; $4626
    and a                                         ; $4627
    jp z, Sfx1_Stop                               ; $4628

    ldh [rNR13], a                                ; $462B
    ld a, $c7                                     ; $462D
    ldh [rNR14], a                                ; $462F
    ret                                           ; $4631


jr_00f_4632:
    ld hl, Sfx1_Step_05 + $2D                     ; $4632
    jp Jump_00f_5214                              ; $4635


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0B_NameCardEdit_State08
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4638_Mode0B_NameCardEdit_State08::
    db $00, $b5, $b0, $44, $c7, $00, $b5, $20, $44, $c7

; C: Sfx1 init handler of the sound ids $02 (entries of Sfx1_InitTbl)
Sfx1_Init_02::
    ld a, $05                                     ; $4642
    ld hl, Snd_0F_4638_Mode0B_NameCardEdit_State08; $4644
    jp Snd_Sfx_Start                              ; $4647


; C: Sfx1 step handler of the sound ids $02 (entries of Sfx1_StepTbl)
Sfx1_Step_02::
    call Snd_Sfx_TickCounter                      ; $464A
    and a                                         ; $464D
    ret nz                                        ; $464E

    ld hl, wSndSfx1 + $4                          ; $464F
    inc [hl]                                      ; $4652
    ld a, [hl]                                    ; $4653
    cp $02                                        ; $4654
    jp z, Sfx1_Stop                               ; $4656

    ld hl, Snd_0F_4638_Mode0B_NameCardEdit_State08 + $5 ; $4659
    jp Jump_00f_5214                              ; $465C


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0B_NameCardEdit_State04
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_465F_Mode0B_NameCardEdit_State04::
    db $00, $ba, $e0, $90, $c7

; C: Sfx1 init handler of the sound ids $20 (entries of Sfx1_InitTbl)
Sfx1_Init_20::
    ld a, $03                                     ; $4664
    ld hl, Snd_0F_465F_Mode0B_NameCardEdit_State04; $4666
    jp Snd_Sfx_Start                              ; $4669


    db $00, $bc, $b0, $a0, $c7

; C: Sfx1 init handler of the sound ids $21 (entries of Sfx1_InitTbl)
Sfx1_Init_21::
    ld a, $03                                     ; $4671
    ld hl, Sfx1_Init_20 + $8                      ; $4673
    jp Snd_Sfx_Start                              ; $4676


    db $00, $bb, $90, $b1, $c7

; C: Sfx1 init handler of the sound ids $22 (entries of Sfx1_InitTbl)
Sfx1_Init_22::
    ld a, $03                                     ; $467E
    ld hl, Sfx1_Init_21 + $8                      ; $4680
    jp Snd_Sfx_Start                              ; $4683


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State03
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4686_Mode03_ViewAlbum_State03::
    db $00, $f9, $f0, $7d, $c7

; C: Sfx1 init handler of the sound ids $23, $2B (entries of Sfx1_InitTbl)
Sfx1_Init_23_2B::
    ld a, $03                                     ; $468B
    ld hl, Snd_0F_4686_Mode03_ViewAlbum_State03   ; $468D
    jp Snd_Sfx_Start                              ; $4690


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode04_PlayMenu_State00
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4693_Mode04_PlayMenu_State00::
    db $00, $ba, $e1, $66, $c7

; C: Sfx1 init handler of the sound ids $01 (entries of Sfx1_InitTbl)
Sfx1_Init_01::
    ld a, $03                                     ; $4698
    ld hl, Snd_0F_4693_Mode04_PlayMenu_State00    ; $469A
    jp Snd_Sfx_Start                              ; $469D


    db $00, $00, $d1, $c1, $87, $3e, $10, $21, $a0, $46, $c3, $da, $51

; C: the same 33 bytes as the Japanese Sfx1_10_DigitRegs (1F:46E5); read in the runs by Snd_Sfx_Start; first read on
; the screen Mode10_ScratchCard_State05 (trace/read_screens_kitty.npz)
Sfx1_10_DigitRegs::
    db $7f, $ae, $e1, $16, $c4

    db $77, $ae, $e1, $b5, $c4, $7f, $ae, $e1, $e5, $c4, $77, $ae, $e1, $63, $c5, $7f
    db $ae, $e1, $ce, $c5, $77, $ae, $e1, $0a, $c6, $7f, $ae, $e1

; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode10_ScratchCard_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_46CE_Mode10_ScratchCard_State05::
    db $5b, $c6, $77, $ae, $e1

; I: leftover: 42 bytes (0F:46D3-46FC) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0F_46D3::
    db $72, $c6, $7f, $ae, $e1, $b2, $c6, $77, $ae, $e1, $e7, $c6, $7f, $ae, $e1, $06
    db $c7, $77, $ae, $e1, $2d, $c7, $7f, $ae, $e1, $39, $c7, $77, $ae, $e1, $59, $c7
    db $7f, $ae, $e1, $73, $c7, $77, $ae, $e1, $83, $c7

; C: the same 16 bytes as the Japanese Sfx1_10_DigitIdx (1F:4735); read in the runs by Sfx1_10_DigitPtr; first read on
; the screen Mode10_ScratchCard_State05 (trace/read_screens_kitty.npz)
Sfx1_10_DigitIdx::
    db $00

    db $05, $0a, $0f, $14, $19, $1e, $23, $28, $2d, $32, $37, $3c, $41, $46, $4b

; C: Sfx1 init handler of the sound ids $10 (entries of Sfx1_InitTbl)
Sfx1_Init_10::
    call Sfx1_Part4731                            ; $470D
    ld a, $08                                     ; $4710
    jp Snd_Sfx_Start                              ; $4712


; C: Sfx1 step handler of the Kitty sound ids $10; same code as the Japanese Sfx1_Step_10_TagDigitsJingle (its game
; role belongs to the Japanese ROM)
Sfx1_Step_10::
    call Snd_Sfx_TickCounter                      ; $4715
    and a                                         ; $4718
    ret nz                                        ; $4719

    ld hl, wSndSfx1 + $4                          ; $471A
    inc [hl]                                      ; $471D
    ld a, [hl]                                    ; $471E
    cp $04                                        ; $471F
    jp z, Sfx1_Stop                               ; $4721

    ld c, [hl]                                    ; $4724
    ld b, $00                                     ; $4725
    ld hl, wSndDurTabHi                           ; $4727
    add hl, bc                                    ; $472A
    call Sfx1_10_DigitPtr                         ; $472B
    jp Jump_00f_5214                              ; $472E


; C: entry inside a channel-1 handler: ld hl,$D003 ...; code read; runs from the first frame (the sound driver)
Sfx1_Part4731::
    ld hl, wSndDurTabHi                           ; $4731

; C: same instructions as the Japanese Sfx1_10_DigitPtr (1F:476C) over the whole routine (9 instructions, to the first
; ret / jp), only the addresses differ; code compared
Sfx1_10_DigitPtr::
    ld c, [hl]                                    ; $4734
    ld b, $00                                     ; $4735
    ld hl, Sfx1_10_DigitIdx                       ; $4737
    add hl, bc                                    ; $473A
    ld c, [hl]                                    ; $473B
    ld b, $00                                     ; $473C
    ld hl, Sfx1_10_DigitRegs                      ; $473E
    add hl, bc                                    ; $4741
    ret                                           ; $4742


    db $00, $80, $e2, $60, $87

; C: same code as the Japanese Sfx1_Init_1F (1F:4780, 17 bytes, masked match)
Sfx1_Init_1F::
    ld a, $06                                     ; $4748
    ld hl, Sfx1_10_DigitPtr + $F                  ; $474A
    call Snd_Sfx_Start                            ; $474D
    ldh a, [rDIV]                                 ; $4750
    and $3f                                       ; $4752
    or $00                                        ; $4754
    ldh [rNR13], a                                ; $4756
    ret                                           ; $4758


; C: Sfx1 step handler of the sound ids $01, $04, $07, $0B, $0C, $12, $18, $1C, $1D, $1F, $20, $21, $22, $23, $27,
; $2B, $2C, $2D, $2E, $34 (entries of Sfx1_StepTbl)
Sfx1_Step_Shared::
    call Snd_Sfx_TickCounter                      ; $4759
    and a                                         ; $475C
    ret nz                                        ; $475D

; C: same code as the Japanese Sfx1_Stop (1F:4796, 20 bytes, masked match)
Sfx1_Stop::
    xor a                                         ; $475E
    ld [wSndSfx1 + $1], a                         ; $475F
    ldh [rNR10], a                                ; $4762
    ld a, $08                                     ; $4764
    ldh [rNR12], a                                ; $4766
    ld a, $80                                     ; $4768
    ldh [rNR14], a                                ; $476A
    ld hl, wSndTrack1 + $f                        ; $476C
    res 7, [hl]                                   ; $476F
    ret                                           ; $4771


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4772_Mode02_TakePhotos_State06::
    db $4b, $80, $e0, $ee, $87, $53, $80, $d0, $37, $87

; C: Sfx1 init handler of the Kitty sound ids $06, $0D; same code as the Japanese
; Sfx1_Init_06_0D_KeySelect_SpaceFeverBigEnemyKill (its game role belongs to the Japanese ROM)
Sfx1_Init_06_0D::
    call Sfx1_Ret4341                             ; $477C
    ret z                                         ; $477F

    ld a, $09                                     ; $4780
    ld hl, Snd_0F_4772_Mode02_TakePhotos_State06  ; $4782
    jp Snd_Sfx_Start                              ; $4785


; C: Sfx1 step handler of the Kitty sound ids $06, $0D; same code as the Japanese
; Sfx1_Step_06_0D_KeySelect_SpaceFeverBigEnemyKill (its game role belongs to the Japanese ROM)
Sfx1_Step_06_0D::
    call Snd_Sfx_TickCounter                      ; $4788
    and a                                         ; $478B
    ret nz                                        ; $478C

    ld hl, wSndSfx1 + $4                          ; $478D
    ld a, [hl]                                    ; $4790
    inc [hl]                                      ; $4791
    cp $00                                        ; $4792
    jr z, jr_00f_479b                             ; $4794

    cp $01                                        ; $4796
    jr z, Sfx1_Stop                               ; $4798

    ret                                           ; $479A


jr_00f_479b:
    ld hl, Snd_0F_4772_Mode02_TakePhotos_State06 + $5 ; $479B
    jp Jump_00f_5214                              ; $479E


; C: the same 19 bytes as the Japanese Sfx1_Data_47D9 (1F:47D9); read in the runs by Sfx1_Step_09, Snd_Sfx_Start;
; first read on the screen Mode06_Printing_State07 (trace/read_screens_kitty.npz)
Sfx1_Data_47A1::
    db $27, $c0, $e0, $80, $87, $90, $80, $70, $60, $50, $40, $00

    db $90, $80, $70, $60, $50, $40, $00

; C: Sfx1 init handler of the sound ids $09 (entries of Sfx1_InitTbl)
Sfx1_Init_09::
    ld a, $04                                     ; $47B4
    ld hl, Sfx1_Data_47A1                         ; $47B6
    jp Snd_Sfx_Start                              ; $47B9


; C: Sfx1 step handler of the Kitty sound ids $09; same code as the Japanese Sfx1_Step_09_MainMenuPageUp (its game
; role belongs to the Japanese ROM)
Sfx1_Step_09::
    call Snd_Sfx_TickCounter                      ; $47BC
    and a                                         ; $47BF
    ret nz                                        ; $47C0

    ld hl, wSndSfx1 + $4                          ; $47C1
    ld c, [hl]                                    ; $47C4
    inc [hl]                                      ; $47C5
    ld b, $00                                     ; $47C6
    ld hl, Sfx1_Data_47A1 + $5                    ; $47C8
    add hl, bc                                    ; $47CB
    ld a, [hl]                                    ; $47CC
    and a                                         ; $47CD
    jp z, Jump_00f_47da                           ; $47CE

    ldh [rNR13], a                                ; $47D1
    ldh [rNR12], a                                ; $47D3
    ld a, $87                                     ; $47D5
    ldh [rNR14], a                                ; $47D7
    ret                                           ; $47D9


Jump_00f_47da:
    ld a, SFX4_04                                 ; $47DA
    ld [wSndSfx4], a                              ; $47DC
    jp Sfx1_Stop                                  ; $47DF


    db $00, $80, $40, $40, $87

; C: Sfx1 init handler of the sound ids $14 (entries of Sfx1_InitTbl)
Sfx1_Init_14::
    ld a, $40                                     ; $47E7
    ld [wSndSfx1 + $6], a                         ; $47E9
    ld a, $02                                     ; $47EC
    ld hl, Sfx1_Step_09 + $26                     ; $47EE
    jp Snd_Sfx_Start                              ; $47F1


; C: Sfx1 step handler of the sound ids $14 (entries of Sfx1_StepTbl)
Sfx1_Step_14::
    call Snd_Sfx_TickCounter                      ; $47F4
    and a                                         ; $47F7
    ret nz                                        ; $47F8

    ld hl, wSndSfx1 + $6                          ; $47F9
    inc [hl]                                      ; $47FC
    inc [hl]                                      ; $47FD
    ld a, [hl]                                    ; $47FE
    cp $60                                        ; $47FF
    jp z, Sfx1_Stop                               ; $4801

    ldh [rNR13], a                                ; $4804
    ret                                           ; $4806


    db $00, $80, $40, $60, $87

; C: Sfx1 init handler of the sound ids $15 (entries of Sfx1_InitTbl)
Sfx1_Init_15::
    ld a, $60                                     ; $480C
    ld [wSndSfx1 + $6], a                         ; $480E
    ld a, $02                                     ; $4811
    ld hl, Sfx1_Step_14 + $13                     ; $4813
    jp Snd_Sfx_Start                              ; $4816


; C: Sfx1 step handler of the sound ids $15 (entries of Sfx1_StepTbl)
Sfx1_Step_15::
    call Snd_Sfx_TickCounter                      ; $4819
    and a                                         ; $481C
    ret nz                                        ; $481D

    ld hl, wSndSfx1 + $6                          ; $481E
    dec [hl]                                      ; $4821
    dec [hl]                                      ; $4822
    ld a, [hl]                                    ; $4823
    cp $40                                        ; $4824
    jp z, Sfx1_Stop                               ; $4826

    ldh [rNR13], a                                ; $4829
    ret                                           ; $482B


    db $9c, $80, $e0, $34, $84

; C: Sfx1 init handler of the sound ids $18 (entries of Sfx1_InitTbl)
Sfx1_Init_18::
    ld a, $09                                     ; $4831
    ld hl, Sfx1_Step_15 + $13                     ; $4833
    jp Snd_Sfx_Start                              ; $4836


; C: Sfx1 init handler of the sound ids $12 (entries of Sfx1_InitTbl)
Sfx1_Init_12::
    ld a, $06                                     ; $4839
    ld hl, Sfx1_Init_12 + $8                      ; $483B
    jp Snd_Sfx_Start                              ; $483E


    db $9e, $00, $50, $ee, $c7

; C: Sfx1 init handler of the sound ids $1D (entries of Sfx1_InitTbl)
Sfx1_Init_1D::
    ld a, $06                                     ; $4846
    ld hl, Snd_0F_4853_Mode02_TakePhotos_State01  ; $4848
    jp Snd_Sfx_Start                              ; $484B


    db $7e, $c0, $90, $aa, $c7

; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4853_Mode02_TakePhotos_State01::
    db $9e, $00, $d0, $ee, $c7

; C: Sfx1 init handler of the Kitty sound ids $0C; same code as the Japanese Sfx1_Init_0C_SpaceFeverEnemyKill (its
; game role belongs to the Japanese ROM)
Sfx1_Init_0C::
    call Sfx1_Ret4341                             ; $4858
    ret z                                         ; $485B

    ld a, $07                                     ; $485C
    ld hl, Snd_0F_4853_Mode02_TakePhotos_State01  ; $485E
    jp Snd_Sfx_Start                              ; $4861


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4864_Mode01_MainMenu_State05::
    db $7f, $c0, $9a, $34, $c4

; C: Sfx1 init handler of the Kitty sound ids $07; same code as the Japanese Sfx1_Init_07_MainMenuMove (its game role
; belongs to the Japanese ROM)
Sfx1_Init_07::
    ld a, $04                                     ; $4869
    ld hl, Snd_0F_4864_Mode01_MainMenu_State05    ; $486B
    call Snd_Sfx_Start                            ; $486E
    ldh a, [rDIV]                                 ; $4871
    or $00                                        ; $4873
    ldh [rNR13], a                                ; $4875
    ldh a, [rDIV]                                 ; $4877
    or $c5                                        ; $4879
    ldh [rNR14], a                                ; $487B
    ret                                           ; $487D


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_487E_Mode10_ScratchCard_State02::
    db $2f, $e9, $f0, $34, $c7

; C: same code as the Japanese Sfx1_Init_2C (1F:48AE, 44 bytes, masked match)
Sfx1_Init_2C::
    ldh a, [rDIV]                                 ; $4883
    and $03                                       ; $4885
    ld c, a                                       ; $4887
    ld b, $00                                     ; $4888
    ld hl, Snd_0F_48B4_Mode10_ScratchCard_State02 + $4 ; $488A
    add hl, bc                                    ; $488D
    ld a, [hl]                                    ; $488E
    ld hl, Snd_0F_487E_Mode10_ScratchCard_State02 ; $488F
    call Snd_Sfx_Start                            ; $4892
    ldh a, [rDIV]                                 ; $4895
    ld e, a                                       ; $4897
    srl a                                         ; $4898
    srl a                                         ; $489A
    and $03                                       ; $489C
    ld c, a                                       ; $489E
    ld b, $00                                     ; $489F
    ld hl, Snd_0F_48B4_Mode10_ScratchCard_State02 ; $48A1
    add hl, bc                                    ; $48A4
    ld a, e                                       ; $48A5
    and $0f                                       ; $48A6
    or [hl]                                       ; $48A8
    ldh [rNR13], a                                ; $48A9
    ld a, $c7                                     ; $48AB
    ldh [rNR14], a                                ; $48AD

Jump_00f_48af:
jr_00f_48af:
    xor a                                         ; $48AF
    ld [wSndSeqIdx], a                            ; $48B0
    ret                                           ; $48B3


; C: read in the runs by Sfx1_Init_2C, Snd_Sfx_Start; first read on the screen Mode10_ScratchCard_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_48B4_Mode10_ScratchCard_State02::
    db $80, $90, $70, $60, $0a, $07, $0f, $0c, $27, $34, $f0, $34, $c7

; C: same code as the Japanese Sfx1_Init_2D (1F:48EC, 24 bytes, masked match)
Sfx1_Init_2D::
    ldh a, [rDIV]                                 ; $48C1
    add $03                                       ; $48C3
    and $0f                                       ; $48C5
    ld hl, Snd_0F_48B4_Mode10_ScratchCard_State02 + $8 ; $48C7
    call Snd_Sfx_Start                            ; $48CA
    ldh a, [rDIV]                                 ; $48CD
    and $bf                                       ; $48CF
    ldh [rNR13], a                                ; $48D1
    ld a, $c7                                     ; $48D3
    ldh [rNR14], a                                ; $48D5
    jr jr_00f_48af                                ; $48D7

; C: read in the runs by Sfx1_Step_2F; first read on the screen Mode10_ScratchCard_State04
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_48D9_Mode10_ScratchCard_State04::
    db $59, $83, $ac, $c1, $d6, $c1, $ac, $83, $59, $00

; C: same instructions as the Japanese Sfx1_Init_2F (1F:490E) over the whole routine (5 instructions, to the first ret
; / jp), only the addresses differ; code compared
Sfx1_Init_2F::
    ld a, $f0                                     ; $48E3
    ld [wSndSfx1 + $7], a                         ; $48E5
    ld a, $04                                     ; $48E8
    ld hl, Snd_0F_4929_Mode10_ScratchCard_State04 ; $48EA
    jp Snd_Sfx_Start                              ; $48ED


; C: same code as the Japanese Sfx1_Step_2F (1F:491B, 57 bytes, masked match)
Sfx1_Step_2F::
    call Snd_Sfx_TickCounter                      ; $48F0
    and a                                         ; $48F3
    ret nz                                        ; $48F4

    ld bc, Snd_0F_48D9_Mode10_ScratchCard_State04 ; $48F5
    ld hl, wSndSfx1 + $4                          ; $48F8
    ld a, [hl]                                    ; $48FB
    inc [hl]                                      ; $48FC
    ld l, a                                       ; $48FD
    ld h, $00                                     ; $48FE
    add hl, bc                                    ; $4900
    ld a, [hl]                                    ; $4901
    and a                                         ; $4902
    jr z, jr_00f_4915                             ; $4903

jr_00f_4905:
    ldh [rNR13], a                                ; $4905
    ld a, [wSndSfx1 + $7]                         ; $4907
    ldh [rNR12], a                                ; $490A
    ld a, $b8                                     ; $490C
    ldh [rNR11], a                                ; $490E
    ld a, $c7                                     ; $4910
    ldh [rNR14], a                                ; $4912
    ret                                           ; $4914


jr_00f_4915:
    xor a                                         ; $4915
    ld [wSndSfx1 + $4], a                         ; $4916
    ld a, [wSndSfx1 + $7]                         ; $4919
    sub $30                                       ; $491C
    ld [wSndSfx1 + $7], a                         ; $491E
    and a                                         ; $4921
    jp z, Sfx1_Stop                               ; $4922

    ld a, $06                                     ; $4925
    jr jr_00f_4905                                ; $4927

; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode10_ScratchCard_State04
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4929_Mode10_ScratchCard_State04::
    db $00, $b8, $f0, $06, $c7

    db $9c, $80, $f0, $10, $87

; C: Sfx1 init handler of the sound ids $2E (entries of Sfx1_InitTbl)
Sfx1_Init_2E::
    ld hl, Snd_0F_4929_Mode10_ScratchCard_State04 + $5 ; $4933
    ld a, $13                                     ; $4936
    jp Snd_Sfx_Start                              ; $4938


    db $6e, $80, $c0, $ff, $87

; C: Sfx1 init handler of the sound ids $32 (entries of Sfx1_InitTbl)
Sfx1_Init_32::
    ld a, $08                                     ; $4940
    ld hl, Sfx1_Init_2E + $8                      ; $4942
    call Snd_Sfx_Start                            ; $4945
    jp Jump_00f_48af                              ; $4948


; C: same code as the Japanese Sfx1_Step_32 (1F:4976, 24 bytes, masked match)
Sfx1_Step_32::
    call Snd_Sfx_TickCounter                      ; $494B
    and a                                         ; $494E
    ret nz                                        ; $494F

    ld hl, wSndSfx1 + $4                          ; $4950
    ld c, [hl]                                    ; $4953
    inc [hl]                                      ; $4954
    ld b, $00                                     ; $4955
    ld hl, Sfx1_Step_32 + $18                     ; $4957
    add hl, bc                                    ; $495A
    ld a, [hl]                                    ; $495B
    ldh [rNR13], a                                ; $495C
    ld a, $87                                     ; $495E
    ldh [rNR14], a                                ; $4960
    ret                                           ; $4962


    db $e0, $d0, $c0, $b0, $a0, $90, $80, $c0, $b0, $a0, $90, $80, $70, $60, $a0, $90
    db $80, $70, $60, $50, $40, $90, $80, $70, $60, $50, $40, $30, $70, $60, $50, $40
    db $30, $20, $10, $65, $80, $e0, $20, $85

; C: same code as the Japanese Sfx1_Init_33 (1F:49B6, 16 bytes, masked match)
Sfx1_Init_33::
    ld a, $85                                     ; $498B
    ld [wSndSfx1 + $6], a                         ; $498D
    ld a, $08                                     ; $4990
    ld hl, Sfx1_Step_32 + $3B                     ; $4992
    call Snd_Sfx_Start                            ; $4995
    jp Jump_00f_48af                              ; $4998


; C: same code as the Japanese Sfx1_Step_33 (1F:49C6, 45 bytes, masked match)
Sfx1_Step_33::
    call Snd_Sfx_TickCounter                      ; $499B
    and a                                         ; $499E
    ret nz                                        ; $499F

    ld hl, wSndSfx1 + $4                          ; $49A0
    ld c, [hl]                                    ; $49A3
    inc [hl]                                      ; $49A4
    ld b, $00                                     ; $49A5
    ld hl, Sfx1_Step_33 + $2D                     ; $49A7
    add hl, bc                                    ; $49AA
    ld a, [hl]                                    ; $49AB
    cp $11                                        ; $49AC
    jr z, jr_00f_49b8                             ; $49AE

jr_00f_49b0:
    ldh [rNR13], a                                ; $49B0
    ld a, [wSndSfx1 + $6]                         ; $49B2
    ldh [rNR14], a                                ; $49B5
    ret                                           ; $49B7


jr_00f_49b8:
    ld hl, wSndSfx1 + $6                          ; $49B8
    inc [hl]                                      ; $49BB
    ld a, [hl]                                    ; $49BC
    and $07                                       ; $49BD
    or $80                                        ; $49BF
    ld [hl], a                                    ; $49C1
    xor a                                         ; $49C2
    ld [wSndSfx1 + $4], a                         ; $49C3
    jr jr_00f_49b0                                ; $49C6

    db $00, $30, $20, $10, $60, $50, $40, $a0, $90, $80, $d0, $c0, $b0, $e0, $11

; C: the same 66 bytes as the Japanese Sfx1_34_SeqRegs (1F:4A02); read in the runs by Snd_Sfx_Start, Sfx1_Init_34,
; Sfx1_Step_33; first read on the screen Mode12_SlideShow_State01 (trace/read_screens_kitty.npz)
Sfx1_34_SeqRegs::
    db $00, $f3, $f0, $06, $c7, $00, $f3, $f0, $21, $c7, $00, $f3, $f0, $39, $c7, $00
    db $f3, $f0, $44, $c7, $00, $f3, $f0, $59, $c7, $00, $f3, $f0, $6b, $c7, $00, $f3
    db $f0, $7b, $c7, $00, $f3, $f0, $72, $c7, $14, $19, $14, $0f, $0a, $0f, $14, $05
    db $0a, $0f, $0a, $0f, $14, $14, $19, $14, $0f, $0a, $0f, $14, $05, $14, $0a, $00

jr_00f_4a17:
    xor a                                         ; $4A17
    ld [hl], a                                    ; $4A18

; C: Sfx1 init handler of the Kitty sound ids $34; same code as the Japanese Sfx1_Init_34_SeqStep (its game role
; belongs to the Japanese ROM)
Sfx1_Init_34::
    ld hl, wSndSeqIdx                             ; $4A19
    ld a, [hl]                                    ; $4A1C
    cp $18                                        ; $4A1D
    jr z, jr_00f_4a17                             ; $4A1F

    inc [hl]                                      ; $4A21
    ld c, a                                       ; $4A22
    ld b, $00                                     ; $4A23
    ld hl, Sfx1_34_SeqRegs + $28                  ; $4A25
    add hl, bc                                    ; $4A28
    ld a, [hl]                                    ; $4A29
    ld c, a                                       ; $4A2A
    ld b, $00                                     ; $4A2B
    ld hl, Sfx1_34_SeqRegs                        ; $4A2D
    add hl, bc                                    ; $4A30
    ld a, $0d                                     ; $4A31
    jp Snd_Sfx_Start                              ; $4A33


    db $cd, $49, $52, $a7, $ca, $5e, $47, $c9

; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0B_NameCardEdit_State04
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4A3E_Mode0B_NameCardEdit_State04::
    db $00, $80, $50, $b0, $87

; C: Sfx1 init handler of the Kitty sound ids $30; same code as the Japanese Sfx1_Init_30_RunCelebration (its game
; role belongs to the Japanese ROM)
Sfx1_Init_30::
    ld a, $b0                                     ; $4A43
    ld [wSndSfx1 + $6], a                         ; $4A45
    ld a, $01                                     ; $4A48
    ld hl, Snd_0F_4A3E_Mode0B_NameCardEdit_State04; $4A4A
    call Snd_Sfx_Start                            ; $4A4D
    jp Jump_00f_48af                              ; $4A50


; C: Sfx1 step handler of the sound ids $30 (entries of Sfx1_StepTbl)
Sfx1_Step_30::
    call Snd_Sfx_TickCounter                      ; $4A53
    and a                                         ; $4A56
    ret nz                                        ; $4A57

    ld hl, wSndSfx1 + $6                          ; $4A58
    dec [hl]                                      ; $4A5B
    ld a, [hl]                                    ; $4A5C
    cp $80                                        ; $4A5D
    jp z, Sfx1_Stop                               ; $4A5F

    ldh [rNR13], a                                ; $4A62
    ret                                           ; $4A64


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0B_NameCardEdit_State04
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4A65_Mode0B_NameCardEdit_State04::
    db $00, $80, $50, $60, $87

; C: same code as the Japanese Sfx1_Init_31 (1F:4A95, 16 bytes, masked match)
Sfx1_Init_31::
    ld a, $60                                     ; $4A6A
    ld [wSndSfx1 + $6], a                         ; $4A6C
    ld a, $01                                     ; $4A6F
    ld hl, Snd_0F_4A65_Mode0B_NameCardEdit_State04; $4A71
    call Snd_Sfx_Start                            ; $4A74
    jp Jump_00f_48af                              ; $4A77


; C: Sfx1 step handler of the sound ids $31 (entries of Sfx1_StepTbl)
Sfx1_Step_31::
    call Snd_Sfx_TickCounter                      ; $4A7A
    and a                                         ; $4A7D
    ret nz                                        ; $4A7E

    ld hl, wSndSfx1 + $6                          ; $4A7F
    inc [hl]                                      ; $4A82
    inc [hl]                                      ; $4A83
    ld a, [hl]                                    ; $4A84
    cp $a0                                        ; $4A85
    jp z, Sfx1_Stop                               ; $4A87

    ldh [rNR13], a                                ; $4A8A
    ret                                           ; $4A8C


; C: read in the runs by Sfx1_StepRegTable, Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State06
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4A8D_Mode02_TakePhotos_State06::
    db $4d, $80, $f5, $70, $87, $e7, $a7, $77, $d7, $87, $57, $77, $47, $27, $00

; C: Sfx1 init handler of the sound ids $38 (entries of Sfx1_InitTbl)
Sfx1_Init_38::
    ld a, $87                                     ; $4A9C
    ld [wSndSfx1 + $7], a                         ; $4A9E
    ld a, $03                                     ; $4AA1
    ld hl, Snd_0F_4A8D_Mode02_TakePhotos_State06  ; $4AA3
    jp Snd_Sfx_Start                              ; $4AA6


; C: Sfx1 step handler of the sound ids $38 (entries of Sfx1_StepTbl)
Sfx1_Step_38::
    call Snd_Sfx_TickCounter                      ; $4AA9
    and a                                         ; $4AAC
    ret nz                                        ; $4AAD

    ld hl, Snd_0F_4A8D_Mode02_TakePhotos_State06 + $5 ; $4AAE
    jp Sfx1_StepRegTable                          ; $4AB1


; C: read in the runs by Sfx1_StepRegTable, Snd_Sfx_Start; first read on the screen Mode05_StampWindow_State03
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4AB4_Mode05_StampWindow_State03::
    db $36, $80, $f5, $e0, $86, $e7, $a7, $77, $d7, $87, $57, $67, $37, $47, $00

; C: Sfx1 init handler of the Kitty sound ids $37; same code as the Japanese Sfx1_Init_37_CopyBrowse (its game role
; belongs to the Japanese ROM)
Sfx1_Init_37::
    ld a, $86                                     ; $4AC3
    ld [wSndSfx1 + $7], a                         ; $4AC5
    ld a, $03                                     ; $4AC8
    ld hl, Snd_0F_4AB4_Mode05_StampWindow_State03 ; $4ACA
    jp Snd_Sfx_Start                              ; $4ACD


; C: Sfx1 step handler of the sound ids $37 (entries of Sfx1_StepTbl)
Sfx1_Step_37::
    call Snd_Sfx_TickCounter                      ; $4AD0
    and a                                         ; $4AD3
    ret nz                                        ; $4AD4

    ld hl, Snd_0F_4AB4_Mode05_StampWindow_State03 + $5 ; $4AD5
    jr Sfx1_StepRegTable                          ; $4AD8

    db $4b, $80, $b7, $10, $87, $87, $67, $47, $47, $37, $27, $37, $27, $17, $27, $27
    db $17, $00

; C: Sfx1 init handler of the sound ids $39 (entries of Sfx1_InitTbl)
Sfx1_Init_39::
    ld a, $87                                     ; $4AEC
    ld [wSndSfx1 + $7], a                         ; $4AEE
    ld a, $04                                     ; $4AF1
    ld hl, Sfx1_Step_37 + $A                      ; $4AF3
    jp Snd_Sfx_Start                              ; $4AF6


; C: Sfx1 step handler of the sound ids $39 (entries of Sfx1_StepTbl)
Sfx1_Step_39::
    call Snd_Sfx_TickCounter                      ; $4AF9
    and a                                         ; $4AFC
    ret nz                                        ; $4AFD

    ld hl, Sfx1_Step_37 + $F                      ; $4AFE
    jr Sfx1_StepRegTable                          ; $4B01

; C: read in the runs by Sfx1_StepRegTable, Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4B03_Mode02_TakePhotos_State01::
    db $4e, $00, $f5, $00, $87, $e7, $a7, $77, $d7, $87, $57, $67, $37, $47, $00

; C: Sfx1 init handler of the sound ids $36 (entries of Sfx1_InitTbl)
Sfx1_Init_36::
    ld a, $87                                     ; $4B12
    ld [wSndSfx1 + $7], a                         ; $4B14
    ld a, $03                                     ; $4B17
    ld hl, Snd_0F_4B03_Mode02_TakePhotos_State01  ; $4B19
    jp Snd_Sfx_Start                              ; $4B1C


; C: Sfx1 step handler of the sound ids $36 (entries of Sfx1_StepTbl)
Sfx1_Step_36::
    call Snd_Sfx_TickCounter                      ; $4B1F
    and a                                         ; $4B22
    ret nz                                        ; $4B23

    ld hl, Snd_0F_4B03_Mode02_TakePhotos_State01 + $5 ; $4B24
    jr Sfx1_StepRegTable                          ; $4B27

; C: the same 16 bytes as the Japanese Sfx1_Data_4B54 (1F:4B54); read in the runs by Sfx1_StepRegTable, Snd_Sfx_Start;
; first read on the screen Mode05_StampWindow_State03 (trace/read_screens_kitty.npz)
Sfx1_Data_4B29::
    db $3d, $c0, $f5, $33, $87, $e7, $b7, $a7, $b7, $77, $57, $47, $37, $37, $27, $00

; C: Sfx1 init handler of the sound ids $35 (entries of Sfx1_InitTbl)
Sfx1_Init_35::
    ld a, $87                                     ; $4B39
    ld [wSndSfx1 + $7], a                         ; $4B3B
    ld a, $04                                     ; $4B3E
    ld hl, Sfx1_Data_4B29                         ; $4B40
    jp Snd_Sfx_Start                              ; $4B43


; C: Sfx1 step handler of the sound ids $35 (entries of Sfx1_StepTbl)
Sfx1_Step_35::
    call Snd_Sfx_TickCounter                      ; $4B46
    and a                                         ; $4B49
    ret nz                                        ; $4B4A

    ld hl, Sfx1_Data_4B29 + $5                    ; $4B4B

; C: same code as the Japanese Sfx1_StepRegTable (1F:4B79, 25 bytes, masked match)
Sfx1_StepRegTable::
    push hl                                       ; $4B4E
    ld hl, wSndSfx1 + $4                          ; $4B4F
    ld c, [hl]                                    ; $4B52
    inc [hl]                                      ; $4B53
    ld b, $00                                     ; $4B54
    pop hl                                        ; $4B56
    add hl, bc                                    ; $4B57
    ld a, [hl]                                    ; $4B58
    and a                                         ; $4B59
    jp z, Sfx1_Stop                               ; $4B5A

    ld c, $12                                     ; $4B5D
    ldh [c], a                                    ; $4B5F
    inc c                                         ; $4B60
    inc c                                         ; $4B61
    ld a, [wSndSfx1 + $7]                         ; $4B62
    ldh [c], a                                    ; $4B65
    ret                                           ; $4B66


; C: the same 20 bytes as the Japanese Sfx1_Data_4B92 (1F:4B92); read in the runs by Sfx1_Step_11, Snd_Sfx_Start
Sfx1_Data_4B67::
    db $4c, $c0, $f5, $ee, $87, $e5, $b5, $a5, $b5, $75, $55, $45, $35, $45, $35, $35
    db $35, $25, $25, $00

; C: Sfx1 init handler of the sound ids $0F (entries of Sfx1_InitTbl)
Sfx1_Init_0F::
    ld a, $03                                     ; $4B7B
    ld hl, Sfx1_Data_4B67                         ; $4B7D
    jp Snd_Sfx_Start                              ; $4B80


; C: Sfx1 step handler of the Kitty sound ids $0F; same code as the Japanese Sfx1_Step_0F_SpaceFeverTargetKill (its
; game role belongs to the Japanese ROM)
Sfx1_Step_0F::
    call Snd_Sfx_TickCounter                      ; $4B83
    and a                                         ; $4B86
    ret nz                                        ; $4B87

    ld hl, wSndSfx1 + $4                          ; $4B88
    ld c, [hl]                                    ; $4B8B
    inc [hl]                                      ; $4B8C
    ld b, $00                                     ; $4B8D
    ld hl, Sfx1_Data_4B67 + $5                    ; $4B8F
    jr jr_00f_4bba                                ; $4B92

; C: read in the runs by Sfx1_Step_11, Snd_Sfx_Start; first read on the screen Mode02_TakePhotos_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4B94_Mode02_TakePhotos_State05::
    db $4a, $00, $f2, $90, $87, $d3, $b3, $a3, $43, $43, $33

    db $33, $23, $23, $00

; C: Sfx1 init handler of the sound ids $11 (entries of Sfx1_InitTbl)
Sfx1_Init_11::
    ld a, $03                                     ; $4BA3
    ld hl, Snd_0F_4B94_Mode02_TakePhotos_State05  ; $4BA5
    jp Snd_Sfx_Start                              ; $4BA8


; C: Sfx1 step handler of the Kitty sound ids $11; same code as the Japanese Sfx1_Step_11_Confirm (its game role
; belongs to the Japanese ROM)
Sfx1_Step_11::
    call Snd_Sfx_TickCounter                      ; $4BAB
    and a                                         ; $4BAE
    ret nz                                        ; $4BAF

    ld hl, wSndSfx1 + $4                          ; $4BB0
    ld c, [hl]                                    ; $4BB3
    inc [hl]                                      ; $4BB4
    ld b, $00                                     ; $4BB5
    ld hl, Snd_0F_4B94_Mode02_TakePhotos_State05 + $5 ; $4BB7

jr_00f_4bba:
    add hl, bc                                    ; $4BBA
    ld a, [hl]                                    ; $4BBB
    and a                                         ; $4BBC
    jr z, jr_00f_4bc9                             ; $4BBD

    ld b, $86                                     ; $4BBF

jr_00f_4bc1:
    ld c, $12                                     ; $4BC1
    ldh [c], a                                    ; $4BC3
    inc c                                         ; $4BC4
    inc c                                         ; $4BC5
    ld a, b                                       ; $4BC6
    ldh [c], a                                    ; $4BC7
    ret                                           ; $4BC8


jr_00f_4bc9:
    jp Sfx1_Stop                                  ; $4BC9


    db $3b, $80, $f4, $dd, $87, $d2, $b2, $a2, $92, $82, $72, $62, $52, $23, $23, $13
    db $13, $00

; C: Sfx1 init handler of the sound ids $13 (entries of Sfx1_InitTbl)
Sfx1_Init_13::
    ld a, $03                                     ; $4BDE
    ld hl, Sfx1_Step_11 + $21                     ; $4BE0
    jp Snd_Sfx_Start                              ; $4BE3


; C: Sfx1 step handler of the Kitty sound ids $13; same code as the Japanese Sfx1_Step_13_PanelClose (its game role
; belongs to the Japanese ROM)
Sfx1_Step_13::
    call Snd_Sfx_TickCounter                      ; $4BE6
    and a                                         ; $4BE9
    ret nz                                        ; $4BEA

    ld hl, wSndSfx1 + $4                          ; $4BEB
    ld c, [hl]                                    ; $4BEE
    inc [hl]                                      ; $4BEF
    ld b, $00                                     ; $4BF0
    ld hl, Sfx1_Step_11 + $26                     ; $4BF2
    add hl, bc                                    ; $4BF5
    ld a, [hl]                                    ; $4BF6
    and a                                         ; $4BF7
    jp z, Sfx1_Stop                               ; $4BF8

    ld b, $87                                     ; $4BFB
    jr jr_00f_4bc1                                ; $4BFD

; C: the same 17 bytes as the Japanese Sfx1_Data_4C2A (1F:4C2A); read in the runs by Sfx1_Step_19_3A, Snd_Sfx_Start;
; first read on the screen Mode02_TakePhotos_State08 (trace/read_screens_kitty.npz)
Sfx1_Data_4BFF::
    db $3b, $80, $f4, $90, $87, $b2, $a2, $82, $72, $62, $43, $43, $33, $23, $23, $13
    db $00

; C: Sfx1 init handler of the sound ids $19, $3A (entries of Sfx1_InitTbl)
Sfx1_Init_19_3A::
    ld a, $02                                     ; $4C10
    ld hl, Sfx1_Data_4BFF                         ; $4C12
    jp Snd_Sfx_Start                              ; $4C15


; C: Sfx1 step handler of the Kitty sound ids $19, $3A; same code as the Japanese
; Sfx1_Step_19_3A_ComposeLayoutKey_PickPhoto (its game role belongs to the Japanese ROM)
Sfx1_Step_19_3A::
    call Snd_Sfx_TickCounter                      ; $4C18
    and a                                         ; $4C1B
    ret nz                                        ; $4C1C

    ld hl, wSndSfx1 + $4                          ; $4C1D
    ld c, [hl]                                    ; $4C20
    inc [hl]                                      ; $4C21
    ld b, $00                                     ; $4C22
    ld hl, Sfx1_Data_4BFF + $5                    ; $4C24
    add hl, bc                                    ; $4C27
    ld a, [hl]                                    ; $4C28
    and a                                         ; $4C29
    jp z, Sfx1_Stop                               ; $4C2A

    ld b, $87                                     ; $4C2D
    jr jr_00f_4bc1                                ; $4C2F

; C: read in the runs by Snd_Sfx_Start, Sfx1_Init_08; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4C31_Mode01_MainMenu_State05::
    db $00, $00, $5b, $0a, $86

; C: Sfx1 init handler of the Kitty sound ids $08; same code as the Japanese Sfx1_Init_08_MainMenuPageDown (its game
; role belongs to the Japanese ROM)
Sfx1_Init_08::
    ld a, [Snd_0F_4C31_Mode01_MainMenu_State05 + $3] ; $4C36
    ld hl, Snd_0F_4C31_Mode01_MainMenu_State05    ; $4C39
    ld [wSndSfx1 + $6], a                         ; $4C3C
    ld a, $04                                     ; $4C3F
    jp Snd_Sfx_Start                              ; $4C41


; C: Sfx1 step handler of the Kitty sound ids $08; same code as the Japanese Sfx1_Step_08_MainMenuPageDown (its game
; role belongs to the Japanese ROM)
Sfx1_Step_08::
    call Snd_Sfx_TickCounter                      ; $4C44
    and a                                         ; $4C47
    ret nz                                        ; $4C48

    ld hl, wSndSfx1 + $4                          ; $4C49
    ld a, [hl]                                    ; $4C4C
    inc [hl]                                      ; $4C4D
    cp $07                                        ; $4C4E
    jr z, jr_00f_4c6e                             ; $4C50

    cp $08                                        ; $4C52
    jr z, jr_00f_4c74                             ; $4C54

    cp $09                                        ; $4C56
    jr z, jr_00f_4c7a                             ; $4C58

    cp $0a                                        ; $4C5A
    jr z, jr_00f_4c80                             ; $4C5C

    cp $0b                                        ; $4C5E
    jp z, Sfx1_Stop                               ; $4C60

    ld hl, wSndSfx1 + $6                          ; $4C63
    inc [hl]                                      ; $4C66
    inc [hl]                                      ; $4C67
    ld a, [wSndSfx1 + $6]                         ; $4C68
    ldh [rNR13], a                                ; $4C6B
    ret                                           ; $4C6D


jr_00f_4c6e:
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05    ; $4C6E
    jp Jump_00f_5214                              ; $4C71


jr_00f_4c74:
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05 + $5 ; $4C74
    jp Jump_00f_5214                              ; $4C77


jr_00f_4c7a:
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05 + $A ; $4C7A
    jp Jump_00f_5214                              ; $4C7D


jr_00f_4c80:
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05 + $F ; $4C80
    jp Jump_00f_5214                              ; $4C83


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode01_MainMenu_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4C86_Mode01_MainMenu_State05::
    db $00, $b9, $72, $9d, $c7, $00, $b9, $92, $a2, $c7, $00, $b9, $c2, $ac, $c7, $00
    db $b9, $e2, $c1, $c7

    db $3e, $08, $e0, $17, $3e, $80, $e0, $19, $21, $2f, $d0, $cb, $be, $c9, $00, $d0
    db $3a, $80, $2c, $2c, $2f, $2d, $3c, $1c, $2d, $3d

; C: Sfx4 init handler of the sound ids $09 (entries of Sfx4_InitTbl)
Sfx4_Init_09::
    ld a, $02                                     ; $4CB4
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05 + $22 ; $4CB6
    jp Snd_Sfx_Start                              ; $4CB9


; C: same code as the Japanese Sfx4_Step_09 (1F:4CE7, 32 bytes, masked match)
Sfx4_Step_09::
    call Snd_Sfx_TickCounter                      ; $4CBC
    and a                                         ; $4CBF
    ret nz                                        ; $4CC0

    ld hl, wSndSfx4 + $4                          ; $4CC1
    ld a, [hl]                                    ; $4CC4
    cp $15                                        ; $4CC5
    jp z, Sfx4_Stop                               ; $4CC7

    and $07                                       ; $4CCA
    ld c, a                                       ; $4CCC
    ld b, $00                                     ; $4CCD
    inc [hl]                                      ; $4CCF
    ld hl, Snd_0F_4C86_Mode01_MainMenu_State05 + $26 ; $4CD0
    add hl, bc                                    ; $4CD3
    ld a, [hl]                                    ; $4CD4
    ldh [rNR43], a                                ; $4CD5
    ld a, $80                                     ; $4CD7
    ldh [rNR44], a                                ; $4CD9
    ret                                           ; $4CDB


    db $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $00, $00, $1f, $0b, $80, $00, $f3, $44
    db $80, $00, $e5, $45, $80, $00, $a4, $46, $80, $00, $d3, $44, $80, $00, $04, $08
    db $0c

; C: Sfx4 init handler of the Kitty sound ids $05; same code as the Japanese Sfx4_Init_05_EraseAnim (its game role
; belongs to the Japanese ROM)
Sfx4_Init_05::
    ldh a, [rDIV]                                 ; $4CFD
    and $03                                       ; $4CFF
    ld c, a                                       ; $4D01
    ld b, $00                                     ; $4D02
    ld hl, Sfx4_Step_09 + $3D                     ; $4D04
    add hl, bc                                    ; $4D07
    ld c, [hl]                                    ; $4D08
    ld b, $00                                     ; $4D09
    ld hl, Sfx4_Step_09 + $2D                     ; $4D0B
    add hl, bc                                    ; $4D0E
    ld a, $a0                                     ; $4D0F
    jp Snd_Sfx_Start                              ; $4D11


; C: Sfx4 init handler of the sound ids $06 (entries of Sfx4_InitTbl)
Sfx4_Init_06::
    ld a, $13                                     ; $4D14
    ld hl, Sfx4_Step_09 + $29                     ; $4D16
    jp Snd_Sfx_Start                              ; $4D19


; C: same code as the Japanese Sfx4_Step_06 (1F:4D47, 31 bytes, masked match)
Sfx4_Step_06::
    ld hl, wSndSfx4 + $4                          ; $4D1C
    ld a, [hl]                                    ; $4D1F
    cp $b0                                        ; $4D20
    jp z, Sfx4_Stop                               ; $4D22

    ld c, [hl]                                    ; $4D25
    ld b, $00                                     ; $4D26
    inc [hl]                                      ; $4D28
    ld hl, wSndSfx4 + $5                          ; $4D29
    ld a, [hl]                                    ; $4D2C
    and a                                         ; $4D2D
    ret nz                                        ; $4D2E

    ld hl, Sfx4_Step_09 + $20                     ; $4D2F
    add hl, bc                                    ; $4D32
    ld a, [hl]                                    ; $4D33
    and a                                         ; $4D34
    jp z, Sfx4_Step_06_LoadNR4x                   ; $4D35

    ldh [rNR43], a                                ; $4D38
    ret                                           ; $4D3A


; C: same instructions as the Japanese Sfx4_Step_06_LoadNR4x (1F:4D66) over the whole routine (5 instructions, to the
; first ret / jp), only the addresses differ; code compared
Sfx4_Step_06_LoadNR4x::
    ld a, $01                                     ; $4D3B
    ld hl, wSndSfx4 + $5                          ; $4D3D
    ld [hl], a                                    ; $4D40
    ld hl, Sfx4_Step_09 + $2D                     ; $4D41
    jp Jump_00f_5229                              ; $4D44


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode05_StampWindow_State06
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4D47_Mode05_StampWindow_State06::
    db $00, $e1, $25, $80

    db $00, $61, $25, $80

; C: Sfx4 init handler of the sound ids $0B (entries of Sfx4_InitTbl)
Sfx4_Init_0B::
    ld a, $18                                     ; $4D4F
    ld hl, Snd_0F_4D47_Mode05_StampWindow_State06 ; $4D51
    jp Snd_Sfx_Start                              ; $4D54


    db $00, $f1, $25, $80

; C: Sfx4 init handler of the sound ids $01 (entries of Sfx4_InitTbl)
Sfx4_Init_01::
    ld a, $07                                     ; $4D5B
    ld hl, Sfx4_Init_0B + $8                      ; $4D5D
    jp Snd_Sfx_Start                              ; $4D60


; C: Sfx4 step handler of the Kitty sound ids $01; same code as the Japanese Sfx4_Step_01_StampCommit (its game role
; belongs to the Japanese ROM)
Sfx4_Step_01::
    call Snd_Sfx_TickCounter                      ; $4D63
    and a                                         ; $4D66
    ret nz                                        ; $4D67

    ld hl, wSndSfx4 + $4                          ; $4D68
    inc [hl]                                      ; $4D6B
    ld a, [hl]                                    ; $4D6C
    cp $01                                        ; $4D6D
    jr z, jr_00f_4d77                             ; $4D6F

    cp $03                                        ; $4D71
    jp z, Sfx4_Stop                               ; $4D73

    ret                                           ; $4D76


jr_00f_4d77:
    ld hl, Snd_0F_4D47_Mode05_StampWindow_State06 + $4 ; $4D77
    jp Jump_00f_5229                              ; $4D7A


    db $00, $e3, $16, $80

; C: Sfx4 init handler of the sound ids $0D (entries of Sfx4_InitTbl)
Sfx4_Init_0D::
    ld a, $50                                     ; $4D81
    ld hl, Sfx4_Step_01 + $1A                     ; $4D83
    jp Snd_Sfx_Start                              ; $4D86


    db $00, $f0, $2e, $80

; C: Sfx4 init handler of the sound ids $0F (entries of Sfx4_InitTbl)
Sfx4_Init_0F::
    ld a, $18                                     ; $4D8D
    ld hl, Sfx4_Init_0D + $8                      ; $4D8F
    jp Snd_Sfx_Start                              ; $4D92


    db $00, $f0, $08, $80, $09, $0a, $0b, $0c, $0d, $0e, $0f, $1c, $1d, $1e, $1f, $24
    db $25, $26, $27, $34, $35, $36, $37, $44, $45, $46, $47, $54, $55, $56, $57, $64
    db $65, $66, $67, $74, $75, $76, $77, $84, $85, $86, $87, $94, $95, $96, $97, $a4
    db $00

; C: Sfx4 init handler of the sound ids $0E (entries of Sfx4_InitTbl)
Sfx4_Init_0E::
    ld a, $02                                     ; $4DC6
    ld hl, Sfx4_Init_0F + $8                      ; $4DC8
    jp Snd_Sfx_Start                              ; $4DCB


; C: same instructions as the Japanese Sfx4_Step_0E (1F:4DF9) over the whole routine (8 instructions, to the first ret
; / jp), only the addresses differ; code compared
Sfx4_Step_0E::
    call Snd_Sfx_TickCounter                      ; $4DCE
    and a                                         ; $4DD1
    ret nz                                        ; $4DD2

    ld hl, wSndSfx4 + $4                          ; $4DD3
    ld c, [hl]                                    ; $4DD6
    inc [hl]                                      ; $4DD7
    ld hl, Sfx4_Init_0F + $C                      ; $4DD8
    jr jr_00f_4e0b                                ; $4DDB

    db $00, $40, $4e, $80, $4c, $3f, $6b, $3d, $3c, $2f, $2e, $2d, $2c, $1f, $1e, $1d
    db $14, $07, $06, $05, $04, $03, $02, $01, $00

; C: Sfx4 init handler of the sound ids $07 (entries of Sfx4_InitTbl)
Sfx4_Init_07::
    ld a, $01                                     ; $4DF6
    ld hl, Sfx4_Step_0E + $F                      ; $4DF8
    jp Snd_Sfx_Start                              ; $4DFB


; C: Sfx4 step handler of the Kitty sound ids $07; same code as the Japanese Sfx4_Step_07_SpaceFeverFireShots (its
; game role belongs to the Japanese ROM)
Sfx4_Step_07::
    call Snd_Sfx_TickCounter                      ; $4DFE
    and a                                         ; $4E01
    ret nz                                        ; $4E02

    ld hl, wSndSfx4 + $4                          ; $4E03
    ld c, [hl]                                    ; $4E06
    inc [hl]                                      ; $4E07
    ld hl, Sfx4_Step_0E + $13                     ; $4E08

jr_00f_4e0b:
    ld b, $00                                     ; $4E0B
    add hl, bc                                    ; $4E0D
    ld a, [hl]                                    ; $4E0E
    and a                                         ; $4E0F
    jp z, Sfx4_Stop                               ; $4E10

    ldh [rNR43], a                                ; $4E13
    ret                                           ; $4E15


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State0D
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4E16_Mode03_ViewAlbum_State0D::
    db $00, $e3, $17, $80, $00, $f4, $64, $c0

; C: Sfx4 init handler of the Kitty sound ids $0A; same code as the Japanese Sfx4_Init_0A_LinkChoose (its game role
; belongs to the Japanese ROM)
Sfx4_Init_0A::
    ld a, $18                                     ; $4E1E
    ld hl, Snd_0F_4E16_Mode03_ViewAlbum_State0D + $4 ; $4E20
    jp Snd_Sfx_Start                              ; $4E23


jr_00f_4e26:
    ld hl, Snd_0F_4E16_Mode03_ViewAlbum_State0D   ; $4E26
    jp Jump_00f_5229                              ; $4E29


; C: Sfx4 step handler of the Kitty sound ids $0A; same code as the Japanese Sfx4_Step_0A_LinkChoose (its game role
; belongs to the Japanese ROM)
Sfx4_Step_0A::
    ld hl, wSndSfx4 + $4                          ; $4E2C
    ld a, [hl]                                    ; $4E2F
    inc [hl]                                      ; $4E30
    cp $08                                        ; $4E31
    jr z, jr_00f_4e26                             ; $4E33

    cp $30                                        ; $4E35
    jp z, Sfx4_Stop                               ; $4E37

    ret                                           ; $4E3A


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4E3B_Mode03_ViewAlbum_State0B::
    db $3a, $b4, $14, $c0, $3d, $90, $24, $c0

; C: Sfx4 init handler of the sound ids $12 (entries of Sfx4_InitTbl)
Sfx4_Init_12::
    ld a, $03                                     ; $4E43
    ld hl, Snd_0F_4E3B_Mode03_ViewAlbum_State0B + $4 ; $4E45
    jp Snd_Sfx_Start                              ; $4E48


; C: Sfx4 step handler of the sound ids $12 (entries of Sfx4_StepTbl)
Sfx4_Step_12::
    call Snd_Sfx_TickCounter                      ; $4E4B
    and a                                         ; $4E4E
    ret nz                                        ; $4E4F

    ld hl, wSndSfx4 + $4                          ; $4E50
    ld a, [hl]                                    ; $4E53
    inc [hl]                                      ; $4E54
    and a                                         ; $4E55
    jr z, jr_00f_4e5e                             ; $4E56

    cp $02                                        ; $4E58
    jp z, Sfx4_Stop                               ; $4E5A

    ret                                           ; $4E5D


jr_00f_4e5e:
    ld hl, Snd_0F_4E3B_Mode03_ViewAlbum_State0B   ; $4E5E
    jp Jump_00f_5229                              ; $4E61


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode0B_NameCardEdit_State08
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4E64_Mode0B_NameCardEdit_State08::
    db $00, $a2, $37, $80, $33, $f0, $5f, $c0

; C: Sfx4 init handler of the sound ids $04 (entries of Sfx4_InitTbl)
Sfx4_Init_04::
    ld a, $08                                     ; $4E6C
    ld hl, Snd_0F_4E64_Mode0B_NameCardEdit_State08 + $4 ; $4E6E
    jp Snd_Sfx_Start                              ; $4E71


; C: Sfx4 step handler of the sound ids $04 (entries of Sfx4_StepTbl)
Sfx4_Step_04::
    call Snd_Sfx_TickCounter                      ; $4E74
    and a                                         ; $4E77
    ret nz                                        ; $4E78

    ld hl, wSndSfx4 + $4                          ; $4E79
    ld a, [hl]                                    ; $4E7C
    inc [hl]                                      ; $4E7D
    and a                                         ; $4E7E
    jr z, jr_00f_4e87                             ; $4E7F

    cp $02                                        ; $4E81
    jp z, Sfx4_Stop                               ; $4E83

    ret                                           ; $4E86


jr_00f_4e87:
    ld hl, Snd_0F_4E64_Mode0B_NameCardEdit_State08; $4E87
    jp Jump_00f_5229                              ; $4E8A


    db $00, $f1, $34, $80

; C: Sfx4 init handler of the sound ids $11 (entries of Sfx4_InitTbl)
Sfx4_Init_11::
    ld a, $0c                                     ; $4E91
    ld hl, Sfx4_Step_04 + $19                     ; $4E93
    jp Snd_Sfx_Start                              ; $4E96


; C: Sfx4 step handler of the Kitty sound ids $11; same code as the Japanese Sfx4_Step_11_RunFlagHeight (its game role
; belongs to the Japanese ROM)
Sfx4_Step_11::
    call Snd_Sfx_TickCounter                      ; $4E99
    and a                                         ; $4E9C
    ret nz                                        ; $4E9D

    ld hl, wSndSfx4 + $4                          ; $4E9E
    ld a, [hl]                                    ; $4EA1
    inc [hl]                                      ; $4EA2
    cp $07                                        ; $4EA3
    jp z, Sfx4_Stop                               ; $4EA5

    ld hl, Sfx4_Step_04 + $19                     ; $4EA8
    jp Jump_00f_5229                              ; $4EAB


    db $00, $f4, $5f, $80

; C: Sfx4 init handler of the sound ids $08 (entries of Sfx4_InitTbl)
Sfx4_Init_08::
    ld a, $60                                     ; $4EB2
    ld hl, Sfx4_Step_11 + $15                     ; $4EB4
    jp Snd_Sfx_Start                              ; $4EB7


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State02
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4EBA_Mode03_ViewAlbum_State02::
    db $00, $74, $5f, $80

; C: Sfx4 init handler of the sound ids $02 (entries of Sfx4_InitTbl)
Sfx4_Init_02::
    ld a, $60                                     ; $4EBE
    ld hl, Snd_0F_4EBA_Mode03_ViewAlbum_State02   ; $4EC0
    jp Snd_Sfx_Start                              ; $4EC3


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode03_ViewAlbum_State0B
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4EC6_Mode03_ViewAlbum_State0B::
    db $00, $f4, $57, $80

; C: Sfx4 init handler of the sound ids $0C (entries of Sfx4_InitTbl)
Sfx4_Init_0C::
    ld a, $40                                     ; $4ECA
    ld hl, Snd_0F_4EC6_Mode03_ViewAlbum_State0B   ; $4ECC
    jp Snd_Sfx_Start                              ; $4ECF


    db $00, $f2, $3c, $80, $2c, $1f, $2e, $4d, $5c, $5d, $4e, $2f, $4f

; C: same code as the Japanese Sfx4_Init_03 (1F:4F0D, 27 bytes, masked match)
Sfx4_Init_03::
    ld a, $38                                     ; $4EDF
    ld hl, Sfx4_Init_0C + $8                      ; $4EE1
    call Snd_Sfx_Start                            ; $4EE4
    ldh a, [rDIV]                                 ; $4EE7
    and $07                                       ; $4EE9
    ld c, a                                       ; $4EEB
    ld b, $00                                     ; $4EEC
    ld hl, Sfx4_Init_0C + $C                      ; $4EEE

jr_00f_4ef1:
    add hl, bc                                    ; $4EF1
    ld a, [hl]                                    ; $4EF2
    ldh [rNR43], a                                ; $4EF3
    ld a, $80                                     ; $4EF5
    ldh [rNR44], a                                ; $4EF7
    ret                                           ; $4EF9


    db $00, $f2, $1c, $80

; C: Sfx4 init handler of the sound ids $10 (entries of Sfx4_InitTbl)
Sfx4_Init_10::
    ld a, $08                                     ; $4EFE
    ld hl, Sfx4_Init_0C + $8                      ; $4F00
    jp Snd_Sfx_Start                              ; $4F03


; C: same code as the Japanese Sfx4_Step_10 (1F:4F34, 25 bytes, masked match)
Sfx4_Step_10::
    call Snd_Sfx_TickCounter                      ; $4F06
    and a                                         ; $4F09
    ret nz                                        ; $4F0A

    ld hl, wSndSfx4 + $4                          ; $4F0B
    ld a, [hl]                                    ; $4F0E
    cp $12                                        ; $4F0F
    jp z, Sfx4_Stop                               ; $4F11

    and $07                                       ; $4F14
    ld c, a                                       ; $4F16
    ld b, $00                                     ; $4F17
    inc [hl]                                      ; $4F19
    ld hl, Sfx4_Step_10 + $19                     ; $4F1A
    jr jr_00f_4ef1                                ; $4F1D

    db $0d, $1d, $0e, $0f, $0b, $1f, $1c, $0a, $1e

; C: Sfx4 step handler of the sound ids $02, $03, $05, $08, $0B, $0C, $0D, $0F (entries of Sfx4_StepTbl)
Sfx4_Step_Shared::
    call Snd_Sfx_TickCounter                      ; $4F28
    and a                                         ; $4F2B
    ret nz                                        ; $4F2C

; C: same code as the Japanese Sfx4_Stop (1F:4F5B, 18 bytes, masked match)
Sfx4_Stop::
    xor a                                         ; $4F2D
    ld [wSndSfx4 + $1], a                         ; $4F2E
    ld a, $08                                     ; $4F31
    ldh [rNR42], a                                ; $4F33
    ld a, $80                                     ; $4F35
    ldh [rNR44], a                                ; $4F37
    ld hl, wSndTrack4 + $f                        ; $4F39
    res 7, [hl]                                   ; $4F3C
    ret                                           ; $4F3E


    db $80, $00, $20, $40, $85

; C: same code as the Japanese Sfx3_Init_07 (1F:4F72, 23 bytes, masked match)
Sfx3_Init_07::
    call Sfx3_Begin_Wave517A                      ; $4F44
    ld a, [Sfx4_Stop + $15]                       ; $4F47
    ld [wSndSfx3 + $5], a                         ; $4F4A
    ld a, [Sfx4_Stop + $16]                       ; $4F4D
    and $0f                                       ; $4F50
    ld [wSndSfx3 + $6], a                         ; $4F52
    ld hl, Sfx4_Stop + $12                        ; $4F55
    jp Jump_00f_5222                              ; $4F58


; C: same instructions as the Japanese Sfx3_StepAdvance (1F:4F89) over the whole routine (9 instructions, to the first
; ret / jp), only the addresses differ; code compared
Sfx3_StepAdvance::
    ld hl, wSndSfx3 + $4                          ; $4F5B
    inc [hl]                                      ; $4F5E
    ld e, [hl]                                    ; $4F5F
    ld a, [wSndSfx3 + $5]                         ; $4F60
    ld l, a                                       ; $4F63
    ld a, [wSndSfx3 + $6]                         ; $4F64
    ld h, a                                       ; $4F67
    ld a, e                                       ; $4F68
    ret                                           ; $4F69


; C: same code as the Japanese Sfx3_Step_07 (1F:4F98, 36 bytes, masked match)
Sfx3_Step_07::
    call Sfx3_StepAdvance                         ; $4F6A
    cp $16                                        ; $4F6D
    jp z, Sfx3_Stop                               ; $4F6F

    cp $06                                        ; $4F72
    jr c, jr_00f_4f89                             ; $4F74

    ld bc, hSfx3_Step_07_FFF3                     ; $4F76

jr_00f_4f79:
    add hl, bc                                    ; $4F79
    ld a, l                                       ; $4F7A
    ldh [rNR33], a                                ; $4F7B
    ld [wSndSfx3 + $5], a                         ; $4F7D
    ld a, h                                       ; $4F80
    ld [wSndSfx3 + $6], a                         ; $4F81
    or $c0                                        ; $4F84
    ldh [rNR34], a                                ; $4F86
    ret                                           ; $4F88


jr_00f_4f89:
    ld bc, $000e                                  ; $4F89
    jr jr_00f_4f79                                ; $4F8C

    db $3e, $01, $ea, $0d, $d0, $c9

; C: read in the runs by Snd_Sfx_Start, Sfx3_Step_08; first read on the screen Mode00_BootAndTitle_State08
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4F94_Mode00_BootAndTitle_State08::
    db $80, $f2, $20, $39, $c7, $21, $06, $06, $00

; C: Sfx3 step handler of the Kitty sound ids $09; same code as the Japanese Sfx3_Step_09_DeleteDialogSecond (its game
; role belongs to the Japanese ROM)
Sfx3_Step_09::
    ld hl, wSndSfx3 + $4                          ; $4F9D
    inc [hl]                                      ; $4FA0
    ld a, [hl]                                    ; $4FA1
    cp $06                                        ; $4FA2
    ret nz                                        ; $4FA4

    xor a                                         ; $4FA5
    ld [hl], a                                    ; $4FA6
    ldh [rNR30], a                                ; $4FA7
    inc l                                         ; $4FA9
    ld c, [hl]                                    ; $4FAA
    inc [hl]                                      ; $4FAB
    ld b, $00                                     ; $4FAC
    ld hl, Snd_0F_4F94_Mode00_BootAndTitle_State08 + $5 ; $4FAE
    jr jr_00f_4fd9                                ; $4FB1

; C: Sfx3 init handler of the sound ids $09 (entries of Sfx3_InitTbl)
Sfx3_Init_09::
    call Sfx3_Begin_Wave51BA                      ; $4FB3
    ld hl, Snd_0F_4F94_Mode00_BootAndTitle_State08; $4FB6
    jp Jump_00f_5222                              ; $4FB9


; C: read in the runs by Snd_Sfx_Start, Sfx3_Step_08; first read on the screen Mode01_MainMenu_State06
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4FBC_Mode01_MainMenu_State06::
    db $80, $f2, $20, $ac, $c7, $b6, $be, $c1, $00

; C: Sfx3 step handler of the Kitty sound ids $08; same code as the Japanese Sfx3_Step_08_DeleteDialogFirst (its game
; role belongs to the Japanese ROM)
Sfx3_Step_08::
    ld hl, wSndSfx3 + $4                          ; $4FC5
    inc [hl]                                      ; $4FC8
    ld a, [hl]                                    ; $4FC9
    cp $04                                        ; $4FCA
    ret nz                                        ; $4FCC

    xor a                                         ; $4FCD
    ld [hl], a                                    ; $4FCE
    ldh [rNR30], a                                ; $4FCF
    inc l                                         ; $4FD1
    ld c, [hl]                                    ; $4FD2
    inc [hl]                                      ; $4FD3
    ld b, $00                                     ; $4FD4
    ld hl, Snd_0F_4FBC_Mode01_MainMenu_State06 + $5 ; $4FD6

jr_00f_4fd9:
    add hl, bc                                    ; $4FD9
    ld a, $80                                     ; $4FDA
    ldh [rNR30], a                                ; $4FDC
    ld a, [hl]                                    ; $4FDE
    and a                                         ; $4FDF
    jp z, Sfx3_Stop                               ; $4FE0

    ldh [rNR33], a                                ; $4FE3
    ld a, $f6                                     ; $4FE5
    ldh [rNR31], a                                ; $4FE7
    ld a, $c7                                     ; $4FE9
    ldh [rNR34], a                                ; $4FEB
    ret                                           ; $4FED


; C: Sfx3 init handler of the sound ids $08 (entries of Sfx3_InitTbl)
Sfx3_Init_08::
    call Sfx3_Begin_Wave51AA                      ; $4FEE
    ld hl, Snd_0F_4FBC_Mode01_MainMenu_State06    ; $4FF1
    jp Jump_00f_5222                              ; $4FF4


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode06_Printing_State1F
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_4FF7_Mode06_Printing_State1F::
    db $80, $50, $20, $f0, $c6

; C: Sfx3 step handler of the Kitty sound ids $03; same code as the Japanese Sfx3_Step_03_SpaceFeverBossHit (its game
; role belongs to the Japanese ROM)
Sfx3_Step_03::
    ld hl, wSndSfx3 + $4                          ; $4FFC
    inc [hl]                                      ; $4FFF
    ld a, [hl]                                    ; $5000
    cp $20                                        ; $5001
    jp z, Sfx3_Stop                               ; $5003

    cp $10                                        ; $5006
    jr c, jr_00f_5013                             ; $5008

    inc l                                         ; $500A
    dec [hl]                                      ; $500B
    dec [hl]                                      ; $500C
    dec [hl]                                      ; $500D

jr_00f_500e:
    ldh a, [rDIV]                                 ; $500E
    ldh [rNR33], a                                ; $5010
    ret                                           ; $5012


jr_00f_5013:
    inc l                                         ; $5013
    jr jr_00f_500e                                ; $5014

; C: Sfx3 init handler of the Kitty sound ids $03; same code as the Japanese Sfx3_Init_03_SpaceFeverBossHit (its game
; role belongs to the Japanese ROM)
Sfx3_Init_03::
    call Sfx3_Begin_Wave519A                      ; $5016
    ld a, $f0                                     ; $5019
    ld [wSndSfx3 + $5], a                         ; $501B
    ld hl, Snd_0F_4FF7_Mode06_Printing_State1F    ; $501E
    jp Jump_00f_5222                              ; $5021


    db $80, $50, $20, $e0, $c7

; C: Sfx3 step handler of the Kitty sound ids $02; same code as the Japanese Sfx3_Step_02_MainMenuViewArcade (its game
; role belongs to the Japanese ROM)
Sfx3_Step_02::
    ld hl, wSndSfx3 + $4                          ; $5029
    inc [hl]                                      ; $502C
    ld a, [hl]                                    ; $502D
    cp $20                                        ; $502E
    jp z, Sfx3_Stop                               ; $5030

    cp $0a                                        ; $5033
    jr c, jr_00f_504a                             ; $5035

    inc l                                         ; $5037
    dec [hl]                                      ; $5038
    dec [hl]                                      ; $5039
    dec [hl]                                      ; $503A
    dec [hl]                                      ; $503B
    dec [hl]                                      ; $503C
    dec [hl]                                      ; $503D

jr_00f_503e:
    ld a, [hl]                                    ; $503E
    and $f8                                       ; $503F
    ld c, a                                       ; $5041
    ldh a, [rDIV]                                 ; $5042
    and $07                                       ; $5044
    or c                                          ; $5046
    ldh [rNR33], a                                ; $5047
    ret                                           ; $5049


jr_00f_504a:
    inc l                                         ; $504A
    jr jr_00f_503e                                ; $504B

; C: Sfx3 init handler of the Kitty sound ids $02; same code as the Japanese Sfx3_Init_02_MainMenuViewArcade (its game
; role belongs to the Japanese ROM)
Sfx3_Init_02::
    call Sfx3_Begin_Wave51CA                      ; $504D
    ld a, $e0                                     ; $5050
    ld [wSndSfx3 + $5], a                         ; $5052
    ld hl, Snd_0F_4FF7_Mode06_Printing_State1F    ; $5055
    jp Jump_00f_5222                              ; $5058


    db $80, $50, $20, $60, $c6

; C: same code as the Japanese Sfx3_Step_04 (1F:5090, 20 bytes, masked match)
Sfx3_Step_04::
    ld hl, wSndSfx3 + $4                          ; $5060
    inc [hl]                                      ; $5063
    ld a, [hl]                                    ; $5064
    cp $13                                        ; $5065
    jp z, Sfx3_Stop                               ; $5067

    cp $04                                        ; $506A
    jr c, jr_00f_5077                             ; $506C

    inc l                                         ; $506E
    inc [hl]                                      ; $506F
    inc [hl]                                      ; $5070
    inc [hl]                                      ; $5071
    inc [hl]                                      ; $5072
    ld a, [hl]                                    ; $5073

Jump_00f_5074:
jr_00f_5074:
    ldh [rNR33], a                                ; $5074
    ret                                           ; $5076


jr_00f_5077:
    ldh a, [rDIV]                                 ; $5077
    jr jr_00f_5074                                ; $5079

; C: same instructions as the Japanese Sfx3_Init_04 (1F:50AB) over the whole routine (5 instructions, to the first ret
; / jp), only the addresses differ; code compared
Sfx3_Init_04::
    call Sfx3_Begin_Wave51AA                      ; $507B
    ld a, $60                                     ; $507E
    ld [wSndSfx3 + $5], a                         ; $5080
    ld hl, Sfx3_Init_02 + $E                      ; $5083
    jp Jump_00f_5222                              ; $5086


; C: read in the runs by Snd_Sfx_Start; first read on the screen Mode06_Printing_State05
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_5089_Mode06_Printing_State05::
    db $80, $50, $20, $10, $c4

; C: Sfx3 step handler of the Kitty sound ids $01; same code as the Japanese Sfx3_Step_01_MainMenuShoot (its game role
; belongs to the Japanese ROM)
Sfx3_Step_01::
    ld hl, wSndSfx3 + $4                          ; $508E
    inc [hl]                                      ; $5091
    ld a, [hl]                                    ; $5092
    cp $16                                        ; $5093
    jp z, Sfx3_Stop                               ; $5095

    cp $05                                        ; $5098
    jr c, jr_00f_5077                             ; $509A

    inc l                                         ; $509C
    inc [hl]                                      ; $509D
    inc [hl]                                      ; $509E
    inc [hl]                                      ; $509F
    inc [hl]                                      ; $50A0
    inc [hl]                                      ; $50A1
    inc [hl]                                      ; $50A2
    ld a, [hl]                                    ; $50A3
    jp Jump_00f_5074                              ; $50A4


; C: Sfx3 init handler of the Kitty sound ids $01; same code as the Japanese Sfx3_Init_01_MainMenuShoot (its game role
; belongs to the Japanese ROM)
Sfx3_Init_01::
    call Sfx3_Begin_Wave51CA                      ; $50A7
    ld a, $10                                     ; $50AA
    ld [wSndSfx3 + $5], a                         ; $50AC
    ld hl, Snd_0F_5089_Mode06_Printing_State05    ; $50AF
    jp Jump_00f_5222                              ; $50B2


    db $80, $50, $20, $40, $c5

; C: same code as the Japanese Sfx3_Step_05_0A (1F:50EA, 24 bytes, masked match)
Sfx3_Step_05_0A::
    ld hl, wSndSfx3 + $4                          ; $50BA
    inc [hl]                                      ; $50BD
    ld a, [hl]                                    ; $50BE
    cp $18                                        ; $50BF
    jr z, Sfx3_Stop                               ; $50C1

    cp $04                                        ; $50C3
    jr c, jr_00f_50d1                             ; $50C5

    inc l                                         ; $50C7
    dec [hl]                                      ; $50C8
    dec [hl]                                      ; $50C9
    dec [hl]                                      ; $50CA
    dec [hl]                                      ; $50CB
    dec [hl]                                      ; $50CC
    dec [hl]                                      ; $50CD
    ld a, [hl]                                    ; $50CE
    ldh [rNR33], a                                ; $50CF

jr_00f_50d1:
    ret                                           ; $50D1


; C: same instructions as the Japanese Sfx3_Init_05_0A (1F:5102) over the whole routine (5 instructions, to the first
; ret / jp), only the addresses differ; code compared
Sfx3_Init_05_0A::
    call Sfx3_Begin_Wave51BA                      ; $50D2
    ld a, $80                                     ; $50D5
    ld [wSndSfx3 + $5], a                         ; $50D7
    ld hl, Sfx3_Init_01 + $E                      ; $50DA
    jp Jump_00f_5222                              ; $50DD


    db $80, $80, $20, $23, $c7

; C: same code as the Japanese Sfx3_Init_06 (1F:5115, 18 bytes, masked match)
Sfx3_Init_06::
    call Sfx3_Begin_Wave518A                      ; $50E5
    ld a, $23                                     ; $50E8
    ld [wSndSfx3 + $6], a                         ; $50EA

jr_00f_50ed:
    ld hl, Sfx3_Init_05_0A + $E                   ; $50ED
    call Call_00f_5222                            ; $50F0
    ret                                           ; $50F3


jr_00f_50f4:
    inc [hl]                                      ; $50F4
    jr jr_00f_50ed                                ; $50F5

; C: same code as the Japanese Sfx3_Step_06 (1F:5127, 36 bytes, masked match)
Sfx3_Step_06::
    ld hl, wSndSfx3 + $4                          ; $50F7
    inc [hl]                                      ; $50FA
    ld a, [hl+]                                   ; $50FB
    cp $0a                                        ; $50FC
    jr z, jr_00f_50f4                             ; $50FE

    cp $22                                        ; $5100
    jr z, jr_00f_5119                             ; $5102

    ld a, [hl+]                                   ; $5104
    and a                                         ; $5105
    jr z, jr_00f_5110                             ; $5106

    dec [hl]                                      ; $5108
    dec [hl]                                      ; $5109
    dec [hl]                                      ; $510A
    dec [hl]                                      ; $510B

jr_00f_510c:
    ld a, [hl]                                    ; $510C
    ldh [rNR33], a                                ; $510D
    ret                                           ; $510F


jr_00f_5110:
    inc [hl]                                      ; $5110
    inc [hl]                                      ; $5111
    inc [hl]                                      ; $5112
    inc [hl]                                      ; $5113
    inc [hl]                                      ; $5114
    inc [hl]                                      ; $5115
    inc [hl]                                      ; $5116
    jr jr_00f_510c                                ; $5117

jr_00f_5119:
    jr Sfx3_Stop                                  ; $5119

; C: same code as the Japanese Sfx3_Stop (1F:514B, 21 bytes, masked match)
Sfx3_Stop::
    xor a                                         ; $511B
    ld [wSndSfx3 + $1], a                         ; $511C
    ldh [rNR30], a                                ; $511F
    ld hl, wSndTrack3 + $f                        ; $5121
    res 7, [hl]                                   ; $5124
    ld a, [wSndTrack3 + $6]                       ; $5126
    ld l, a                                       ; $5129
    ld a, [wSndTrack3 + $7]                       ; $512A
    ld h, a                                       ; $512D
    jr jr_00f_515e                                ; $512E

; C: Sfx3_Begin, then the wave pattern at 0F:51CA (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave51CA::
    call Sfx3_Begin                               ; $5130
    ld hl, Sfx3_Wave_519A + $30                   ; $5133
    jr jr_00f_515e                                ; $5136

; C: Sfx3_Begin, then the wave pattern at 0F:518A (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave518A::
    call Sfx3_Begin                               ; $5138
    ld hl, Sfx3_Begin + $29                       ; $513B
    jr jr_00f_515e                                ; $513E

; C: Sfx3_Begin, then the wave pattern at 0F:519A (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave519A::
    call Sfx3_Begin                               ; $5140
    ld hl, Sfx3_Wave_519A                         ; $5143
    jr jr_00f_515e                                ; $5146

; C: Sfx3_Begin, then the wave pattern at 0F:51AA (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave51AA::
    call Sfx3_Begin                               ; $5148
    ld hl, Sfx3_Wave_519A + $10                   ; $514B
    jr jr_00f_515e                                ; $514E

; C: Sfx3_Begin, then the wave pattern at 0F:51BA (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave51BA::
    call Sfx3_Begin                               ; $5150
    ld hl, Sfx3_Wave_519A + $20                   ; $5153
    jr jr_00f_515e                                ; $5156

; C: Sfx3_Begin, then the wave pattern at 0F:517A (as the Japanese Sfx3_Begin_Wave* of bank $1F)
Sfx3_Begin_Wave517A::
    call Sfx3_Begin                               ; $5158
    ld hl, Sfx3_Begin + $19                       ; $515B

jr_00f_515e:
    jp Snd_LoadWaveRam                            ; $515E


; C: same code as the Japanese Sfx3_Begin (1F:5191, 25 bytes, masked match)
Sfx3_Begin::
    ld de, wSndSfx3 + $1                          ; $5161
    ld a, [wSndTmp]                               ; $5164
    ld [de], a                                    ; $5167
    ld hl, wSndTrack3 + $f                        ; $5168
    set 7, [hl]                                   ; $516B
    xor a                                         ; $516D
    ld [wSndSfx3 + $4], a                         ; $516E
    ld [wSndSfx3 + $5], a                         ; $5171
    ld [wSndSfx3 + $6], a                         ; $5174
    ldh [rNR30], a                                ; $5177
    ret                                           ; $5179


    db $a7, $13, $32, $3f, $ab, $cd, $ef, $a7, $f1, $f1, $f1, $f1, $f1, $f1, $49, $b9
    db $f1, $00, $f1, $f1, $f1, $f1, $f1, $f1, $77, $77, $77, $77, $71, $00, $a0, $00

; C: the same 64 bytes as the Japanese Sfx3_Wave_51CA (1F:51CA); read in the runs by Snd_LoadWaveRam; first read on
; the screen Mode06_Printing_State1F (trace/read_screens_kitty.npz)
Sfx3_Wave_519A::
    db $12, $13, $32, $3f, $89, $cd, $78, $97, $71, $61, $61, $61, $61, $61, $49, $b9
    db $00, $00, $98, $76, $54, $32, $10, $91, $f8, $76, $04, $32, $12, $38, $e9, $19
    db $34, $34, $00, $23, $23, $34, $34, $30, $00, $00, $00, $00, $00, $00, $e9, $00
    db $12, $34, $56, $f0, $77, $00, $77, $00, $77, $00, $77, $00, $76, $54, $32, $11

; C: same code as the Japanese Snd_Sfx_Start (1F:520A, 58 bytes, masked match)
Snd_Sfx_Start::
    push af                                       ; $51DA
    dec e                                         ; $51DB
    ld a, [wSndTmp]                               ; $51DC
    ld [de], a                                    ; $51DF
    inc e                                         ; $51E0
    pop af                                        ; $51E1
    inc e                                         ; $51E2
    ld [de], a                                    ; $51E3
    dec e                                         ; $51E4
    xor a                                         ; $51E5
    ld [de], a                                    ; $51E6
    inc e                                         ; $51E7
    inc e                                         ; $51E8
    ld [de], a                                    ; $51E9
    inc e                                         ; $51EA
    ld [de], a                                    ; $51EB
    push hl                                       ; $51EC
    ld a, e                                       ; $51ED
    cp $65                                        ; $51EE
    jr z, jr_00f_51fc                             ; $51F0

    cp $75                                        ; $51F2
    jr z, jr_00f_5204                             ; $51F4

    cp $7d                                        ; $51F6
    jr z, jr_00f_520c                             ; $51F8

    pop hl                                        ; $51FA
    ret                                           ; $51FB


jr_00f_51fc:
    ld hl, wSndTrack1 + $f                        ; $51FC
    set 7, [hl]                                   ; $51FF
    pop hl                                        ; $5201
    jr jr_00f_5214                                ; $5202

jr_00f_5204:
    ld hl, wSndTrack3 + $f                        ; $5204
    set 7, [hl]                                   ; $5207
    pop hl                                        ; $5209
    jr jr_00f_5222                                ; $520A

jr_00f_520c:
    ld hl, wSndTrack4 + $f                        ; $520C
    set 7, [hl]                                   ; $520F
    pop hl                                        ; $5211
    jr jr_00f_5229                                ; $5212

Jump_00f_5214:
jr_00f_5214:
    push bc                                       ; $5214
    ld c, $10                                     ; $5215
    ld b, $05                                     ; $5217
    jr jr_00f_522e                                ; $5219

    db $c5, $0e, $16, $06, $04, $18, $0c

Call_00f_5222:
Jump_00f_5222:
jr_00f_5222:
    push bc                                       ; $5222
    ld c, $1a                                     ; $5223
    ld b, $05                                     ; $5225
    jr jr_00f_522e                                ; $5227

Jump_00f_5229:
jr_00f_5229:
    push bc                                       ; $5229
    ld c, $20                                     ; $522A
    ld b, $04                                     ; $522C

jr_00f_522e:
    ld a, [hl+]                                   ; $522E
    ldh [c], a                                    ; $522F
    inc c                                         ; $5230
    dec b                                         ; $5231
    jr nz, jr_00f_522e                            ; $5232

    pop bc                                        ; $5234
    ret                                           ; $5235


; C: entry inside a channel-3 handler: inc e, [$D051] = A ...; code read; runs from the first frame (the sound driver)
Sfx3_Part5236::
    inc e                                         ; $5236
    ld [wSndTmp], a                               ; $5237

; C: same instructions as the Japanese Snd_Sfx_Lookup (1F:526A) over the whole routine (13 instructions, to the first
; ret / jp), only the addresses differ; code compared
Snd_Sfx_Lookup::
    inc e                                         ; $523A
    dec a                                         ; $523B
    sla a                                         ; $523C
    ld c, a                                       ; $523E
    ld b, $00                                     ; $523F
    add hl, bc                                    ; $5241
    ld c, [hl]                                    ; $5242
    inc hl                                        ; $5243
    ld b, [hl]                                    ; $5244
    ld l, c                                       ; $5245
    ld h, b                                       ; $5246
    ld a, h                                       ; $5247
    ret                                           ; $5248


; C: same instructions as the Japanese Snd_Sfx_TickCounter (1F:5279) over the whole routine (12 instructions, to the
; first ret / jp), only the addresses differ; code compared
Snd_Sfx_TickCounter::
    push de                                       ; $5249
    ld l, e                                       ; $524A
    ld h, d                                       ; $524B
    inc [hl]                                      ; $524C
    ld a, [hl+]                                   ; $524D
    cp [hl]                                       ; $524E
    jr nz, jr_00f_5254                            ; $524F

    dec l                                         ; $5251
    xor a                                         ; $5252
    ld [hl], a                                    ; $5253

jr_00f_5254:
    pop de                                        ; $5254
    ret                                           ; $5255


; C: same instructions as the Japanese Snd_LoadWaveRam (1F:5286) over the whole routine (10 instructions, to the first
; ret / jp), only the addresses differ; code compared
Snd_LoadWaveRam::
    push bc                                       ; $5256
    ld c, $30                                     ; $5257

jr_00f_5259:
    ld a, [hl+]                                   ; $5259
    ldh [c], a                                    ; $525A
    inc c                                         ; $525B
    ld a, c                                       ; $525C
    cp $40                                        ; $525D
    jr nz, jr_00f_5259                            ; $525F

    pop bc                                        ; $5261
    ret                                           ; $5262


; C: same code as the Japanese Snd_StopSong (1F:5293, 25 bytes, masked match)
Snd_StopSong::
    ld a, $ff                                     ; $5263
    ldh [rNR51], a                                ; $5265
    ld a, $01                                     ; $5267
    ld [wSndU55], a                               ; $5269
    xor a                                         ; $526C
    ld [wSndSong], a                              ; $526D
    ld [wSndU0e], a                               ; $5270
    ld [wSndU09], a                               ; $5273
    ld [wSndU09 + $1], a                          ; $5276
    ld [wSndSeqIdx], a                            ; $5279

; C: same code as the Japanese Snd_SilenceChannels (1F:52AC, 44 bytes, masked match)
Snd_SilenceChannels::
    xor a                                         ; $527C
    ld [wSndSfx1 + $1], a                         ; $527D
    ld [wSndSfx3 + $1], a                         ; $5280
    ld [wSndSfx4 + $1], a                         ; $5283
    ld [wSndTrack1 + $f], a                       ; $5286
    ld [wSndTrack2 + $f], a                       ; $5289
    ld [wSndTrack3 + $f], a                       ; $528C
    ld [wSndTrack4 + $f], a                       ; $528F
    ld a, $08                                     ; $5292
    ldh [rNR12], a                                ; $5294
    ldh [rNR22], a                                ; $5296
    ldh [rNR42], a                                ; $5298
    ld a, $80                                     ; $529A
    ldh [rNR14], a                                ; $529C
    ldh [rNR24], a                                ; $529E
    ldh [rNR44], a                                ; $52A0
    xor a                                         ; $52A2
    ldh [rNR10], a                                ; $52A3
    ldh [rNR30], a                                ; $52A5
    ret                                           ; $52A7


; C: same code as the Japanese Snd_RunSfx3 (1F:52D8, 32 bytes, masked match)
Snd_RunSfx3::
    ld de, wSndSfx3                               ; $52A8
    ld a, [de]                                    ; $52AB
    and a                                         ; $52AC
    jr z, jr_00f_52ba                             ; $52AD

    cp $0b                                        ; $52AF
    jr nc, jr_00f_52ba                            ; $52B1

    ld hl, Sfx3_InitTbl                           ; $52B3
    call Sfx3_Part5236                            ; $52B6
    jp hl                                         ; $52B9


jr_00f_52ba:
    inc e                                         ; $52BA
    ld a, [de]                                    ; $52BB
    and a                                         ; $52BC
    ret z                                         ; $52BD

    cp $0b                                        ; $52BE
    ret nc                                        ; $52C0

    ld hl, Sfx3_StepTbl                           ; $52C1
    call Snd_Sfx_Lookup                           ; $52C4
    jp hl                                         ; $52C7


; C: same code as the Japanese Snd_RunSfx1 (1F:52F8, 32 bytes, masked match)
Snd_RunSfx1::
    ld de, wSndSfx1                               ; $52C8
    ld a, [de]                                    ; $52CB
    and a                                         ; $52CC
    jr z, jr_00f_52da                             ; $52CD

    cp $3f                                        ; $52CF
    jr nc, jr_00f_52da                            ; $52D1

    ld hl, Sfx1_InitTbl                           ; $52D3
    call Sfx3_Part5236                            ; $52D6
    jp hl                                         ; $52D9


jr_00f_52da:
    inc e                                         ; $52DA
    ld a, [de]                                    ; $52DB
    and a                                         ; $52DC
    ret z                                         ; $52DD

    cp $3f                                        ; $52DE
    ret nc                                        ; $52E0

    ld hl, Sfx1_StepTbl                           ; $52E1
    call Snd_Sfx_Lookup                           ; $52E4
    jp hl                                         ; $52E7


; C: same code as the Japanese Snd_RunSfx4 (1F:5318, 32 bytes, masked match)
Snd_RunSfx4::
    ld de, wSndSfx4                               ; $52E8
    ld a, [de]                                    ; $52EB
    and a                                         ; $52EC
    jr z, jr_00f_52fa                             ; $52ED

    cp $13                                        ; $52EF
    jr nc, jr_00f_52fa                            ; $52F1

    ld hl, Sfx4_InitTbl                           ; $52F3
    call Sfx3_Part5236                            ; $52F6
    jp hl                                         ; $52F9


jr_00f_52fa:
    inc e                                         ; $52FA
    ld a, [de]                                    ; $52FB
    and a                                         ; $52FC
    ret z                                         ; $52FD

    cp $13                                        ; $52FE
    ret nc                                        ; $5300

    ld hl, Sfx4_StepTbl                           ; $5301
    call Snd_Sfx_Lookup                           ; $5304
    jp hl                                         ; $5307


; C: NR52 = $80, NR50 = $77, NR51 = $FF, $D000-$D0FF cleared (the Japanese Snd_Init 1F:5338, ratio 0.83)
Snd_Init::
    ld a, $80                                     ; $5308
    ldh [rNR52], a                                ; $530A
    ld a, $77                                     ; $530C
    ldh [rNR50], a                                ; $530E
    ld a, $ff                                     ; $5310
    ldh [rNR51], a                                ; $5312
    ld hl, wSnd_Init_D000                         ; $5314

jr_00f_5317:
    ld [hl], $00                                  ; $5317
    inc l                                         ; $5319
    jr nz, jr_00f_5317                            ; $531A

    ret                                           ; $531C


jr_00f_531d:
    jp Snd_StopSong                               ; $531D


; C: same instructions as the Japanese Snd_RequestSong (1F:5356) over the whole routine (11 instructions, to the first
; ret / jp), only the addresses differ; code compared
Snd_RequestSong::
    cp $ff                                        ; $5320
    jr z, jr_00f_531d                             ; $5322

    cp $30                                        ; $5324
    ret nc                                        ; $5326

    ld [hl], a                                    ; $5327
    ld b, a                                       ; $5328
    ld hl, Snd_0F_572F_Mode00_BootAndTitle_State00; $5329
    and $7f                                       ; $532C
    call Snd_Sfx_Lookup                           ; $532E
    call Snd_SongInit                             ; $5331
    jp Jump_00f_5365                              ; $5334


; C: same code as the Japanese Snd_Tick (1F:537D, 20 bytes, masked match)
Snd_Tick::
    push af                                       ; $5337
    push bc                                       ; $5338
    push de                                       ; $5339
    push hl                                       ; $533A
    ld hl, wSndMusicReq                           ; $533B
    ld a, [hl+]                                   ; $533E
    and a                                         ; $533F
    jr nz, jr_00f_5360                            ; $5340

    call Snd_RunSfx1                              ; $5342
    call Snd_RunSfx3                              ; $5345
    call Snd_RunSfx4                              ; $5348

; C: same code as the Japanese Snd_Tick_RunMusic (1F:5391, 21 bytes, masked match)
Snd_Tick_RunMusic::
    call Snd_MusicTick                            ; $534B
    xor a                                         ; $534E
    ld [wSndSfx1], a                              ; $534F
    ld [wSndMusicReq], a                          ; $5352
    ld [wSndSfx3], a                              ; $5355
    ld [wSndSfx4], a                              ; $5358
    pop hl                                        ; $535B
    pop de                                        ; $535C
    pop bc                                        ; $535D
    pop af                                        ; $535E
    ret                                           ; $535F


jr_00f_5360:
    call Snd_RequestSong                          ; $5360
    jr Snd_Tick_RunMusic                          ; $5363

Jump_00f_5365:
    ld a, $ff                                     ; $5365
    ldh [rNR51], a                                ; $5367
    ld a, $01                                     ; $5369
    ld [wSndU55], a                               ; $536B
    ret                                           ; $536E


; C: same code as the Japanese Snd_Trk_LoadFirstPattern (1F:540F)
Snd_Trk_LoadFirstPattern::
    ld a, [hl+]                                   ; $536F
    ld c, a                                       ; $5370
    ld a, [hl]                                    ; $5371
    ld b, a                                       ; $5372
    ld a, [bc]                                    ; $5373
    ld [de], a                                    ; $5374
    inc e                                         ; $5375
    inc bc                                        ; $5376
    ld a, [bc]                                    ; $5377
    ld [de], a                                    ; $5378
    ret                                           ; $5379


; C: same code as the Japanese Snd_Copy2 (1F:541A): two bytes from [HL+] to [DE]
Snd_Copy2::
    ld a, [hl+]                                   ; $537A
    ld [de], a                                    ; $537B
    inc e                                         ; $537C
    ld a, [hl+]                                   ; $537D
    ld [de], a                                    ; $537E
    ret                                           ; $537F


; C: same code as the Japanese Snd_SongInit (1F:5420, 99 bytes, masked match)
Snd_SongInit::
    call Snd_SilenceChannels                      ; $5380
    ld de, wSndTranspose                          ; $5383
    ld b, $00                                     ; $5386
    ld a, [hl+]                                   ; $5388
    ld [de], a                                    ; $5389
    inc e                                         ; $538A
    call Snd_Copy2                                ; $538B
    ld de, wSndTrack1                             ; $538E
    call Snd_Copy2                                ; $5391
    ld de, wSndTrack2                             ; $5394
    call Snd_Copy2                                ; $5397
    ld de, wSndTrack3                             ; $539A
    call Snd_Copy2                                ; $539D
    ld de, wSndTrack4                             ; $53A0
    call Snd_Copy2                                ; $53A3
    ld hl, wSndTrack1                             ; $53A6
    ld de, wSndTrack1 + $4                        ; $53A9
    call Snd_Trk_LoadFirstPattern                 ; $53AC
    ld hl, wSndTrack2                             ; $53AF
    ld de, wSndTrack2 + $4                        ; $53B2
    call Snd_Trk_LoadFirstPattern                 ; $53B5
    ld hl, wSndTrack3                             ; $53B8
    ld de, wSndTrack3 + $4                        ; $53BB
    call Snd_Trk_LoadFirstPattern                 ; $53BE
    ld hl, wSndTrack4                             ; $53C1
    ld de, wSndTrack4 + $4                        ; $53C4
    call Snd_Trk_LoadFirstPattern                 ; $53C7
    ld bc, $0410                                  ; $53CA
    ld hl, wSndTrack1 + $2                        ; $53CD

jr_00f_53d0:
    ld [hl], $01                                  ; $53D0
    ld a, c                                       ; $53D2
    add l                                         ; $53D3
    ld l, a                                       ; $53D4
    dec b                                         ; $53D5
    jr nz, jr_00f_53d0                            ; $53D6

    xor a                                         ; $53D8
    ld [wSndTrack1 + $e], a                       ; $53D9
    ld [wSndTrack2 + $e], a                       ; $53DC
    ld [wSndTrack3 + $e], a                       ; $53DF
    ret                                           ; $53E2


; C: same instructions as the Japanese Snd_Op9D_LoadWaveTrk3 (1F:5483) over the whole routine (8 instructions, to the
; first ret / jp), only the addresses differ; code compared
Snd_Op9D_LoadWaveTrk3::
    push hl                                       ; $53E3
    xor a                                         ; $53E4
    ldh [rNR30], a                                ; $53E5
    ld l, e                                       ; $53E7
    ld h, d                                       ; $53E8
    call Snd_LoadWaveRam                          ; $53E9
    pop hl                                        ; $53EC
    jr jr_00f_541f                                ; $53ED

; C: same code as the Japanese Snd_Op9D_SetInstrument (1F:548F, 54 bytes, masked match)
Snd_Op9D_SetInstrument::
    call Snd_Trk_PtrInc                           ; $53EF
    call Snd_Trk_FetchByte                        ; $53F2
    ld e, a                                       ; $53F5
    call Snd_Trk_PtrInc                           ; $53F6
    call Snd_Trk_FetchByte                        ; $53F9
    ld d, a                                       ; $53FC
    call Snd_Trk_PtrInc                           ; $53FD
    call Snd_Trk_FetchByte                        ; $5400
    ld c, a                                       ; $5403
    ld a, [wSndFreeze]                            ; $5404
    and a                                         ; $5407
    jr nz, jr_00f_5415                            ; $5408

    inc l                                         ; $540A
    inc l                                         ; $540B
    ld [hl], e                                    ; $540C
    inc l                                         ; $540D
    ld [hl], d                                    ; $540E
    inc l                                         ; $540F
    ld [hl], c                                    ; $5410
    dec l                                         ; $5411
    dec l                                         ; $5412
    dec l                                         ; $5413
    dec l                                         ; $5414

jr_00f_5415:
    push hl                                       ; $5415
    ld hl, wSndCurTrack                           ; $5416
    ld a, [hl]                                    ; $5419
    pop hl                                        ; $541A
    cp $03                                        ; $541B
    jr z, Snd_Op9D_LoadWaveTrk3                   ; $541D

jr_00f_541f:
    call Snd_Trk_PtrInc                           ; $541F
    jp Snd_Trk_FetchOp                            ; $5422


; C: same instructions as the Japanese Snd_Trk_PtrInc (1F:54C5) over the whole routine (12 instructions, to the first
; ret / jp), only the addresses differ; code compared
Snd_Trk_PtrInc::
    push de                                       ; $5425
    ld a, [hl+]                                   ; $5426
    ld e, a                                       ; $5427
    ld a, [hl-]                                   ; $5428
    ld d, a                                       ; $5429
    inc de                                        ; $542A

jr_00f_542b:
    ld a, e                                       ; $542B
    ld [hl+], a                                   ; $542C
    ld a, d                                       ; $542D
    ld [hl-], a                                   ; $542E
    pop de                                        ; $542F
    ret                                           ; $5430


; C: same code as the Japanese Snd_Trk_PtrInc2 (1F:54D1)
Snd_Trk_PtrInc2::
    push de                                       ; $5431
    ld a, [hl+]                                   ; $5432
    ld e, a                                       ; $5433
    ld a, [hl-]                                   ; $5434
    ld d, a                                       ; $5435
    inc de                                        ; $5436
    inc de                                        ; $5437
    jr jr_00f_542b                                ; $5438

; C: B = the byte at the track pointer stored at HL (then the track command loop); code read; runs from the first
; frame (the sound driver)
Snd_Trk_FetchByte::
    ld a, [hl+]                                   ; $543A
    ld c, a                                       ; $543B
    ld a, [hl-]                                   ; $543C
    ld b, a                                       ; $543D
    ld a, [bc]                                    ; $543E
    ld b, a                                       ; $543F
    ret                                           ; $5440


jr_00f_5441:
    pop hl                                        ; $5441
    jr jr_00f_5470                                ; $5442

; C: same code as the Japanese Snd_Trk_Sustain (1F:54E4, 44 bytes, masked match)
Snd_Trk_Sustain::
    ld a, [wSndCurTrack]                          ; $5444
    cp $03                                        ; $5447
    jr nz, jr_00f_545b                            ; $5449

    ld a, [wSndTrack3 + $8]                       ; $544B
    bit 7, a                                      ; $544E
    jr z, jr_00f_545b                             ; $5450

    ld a, [hl]                                    ; $5452
    cp $06                                        ; $5453
    jr nz, jr_00f_545b                            ; $5455

    ld a, $40                                     ; $5457
    ldh [rNR32], a                                ; $5459

jr_00f_545b:
    push hl                                       ; $545B
    ld a, l                                       ; $545C
    add $09                                       ; $545D
    ld l, a                                       ; $545F
    ld a, [hl]                                    ; $5460
    and a                                         ; $5461
    jr nz, jr_00f_5441                            ; $5462

    ld a, l                                       ; $5464
    add $04                                       ; $5465
    ld l, a                                       ; $5467
    bit 7, [hl]                                   ; $5468
    jr nz, jr_00f_5441                            ; $546A

    pop hl                                        ; $546C
    call Snd_Trk_UpdateChannel                    ; $546D

Jump_00f_5470:
jr_00f_5470:
    dec l                                         ; $5470
    dec l                                         ; $5471
    jp Snd_Trk_Next                               ; $5472


; C: same code as the Japanese Snd_Op00_EndPattern (1F:5515, 27 bytes, masked match)
Snd_Op00_EndPattern::
    dec l                                         ; $5475
    dec l                                         ; $5476
    dec l                                         ; $5477
    dec l                                         ; $5478
    call Snd_Trk_PtrInc2                          ; $5479

jr_00f_547c:
    ld a, l                                       ; $547C
    add $04                                       ; $547D
    ld e, a                                       ; $547F
    ld d, h                                       ; $5480
    call Snd_Trk_LoadFirstPattern                 ; $5481
    cp $00                                        ; $5484
    jr z, jr_00f_54a7                             ; $5486

    cp $ff                                        ; $5488
    jr z, Snd_Op00_LoopList                       ; $548A

    inc l                                         ; $548C
    jp Jump_00f_552a                              ; $548D


; C: same code as the Japanese Snd_Op00_LoopList (1F:5530, 23 bytes, masked match)
Snd_Op00_LoopList::
    dec l                                         ; $5490
    push hl                                       ; $5491
    call Snd_Trk_PtrInc2                          ; $5492
    call Snd_Trk_FetchByte                        ; $5495
    ld e, a                                       ; $5498
    call Snd_Trk_PtrInc                           ; $5499
    call Snd_Trk_FetchByte                        ; $549C
    ld d, a                                       ; $549F
    pop hl                                        ; $54A0
    ld a, e                                       ; $54A1
    ld [hl+], a                                   ; $54A2
    ld a, d                                       ; $54A3
    ld [hl-], a                                   ; $54A4
    jr jr_00f_547c                                ; $54A5

jr_00f_54a7:
    ld hl, wSndSong                               ; $54A7
    ld [hl], $00                                  ; $54AA
    call Snd_StopSong                             ; $54AC
    ret                                           ; $54AF


; C: same code as the Japanese Snd_Op9E_SetDurTable (1F:5550, 20 bytes, masked match)
Snd_Op9E_SetDurTable::
    call Snd_Trk_PtrInc                           ; $54B0
    call Snd_Trk_FetchByte                        ; $54B3
    ld [wSndDurTabLo], a                          ; $54B6
    call Snd_Trk_PtrInc                           ; $54B9
    call Snd_Trk_FetchByte                        ; $54BC
    ld [wSndDurTabHi], a                          ; $54BF
    jr jr_00f_54cd                                ; $54C2

; C: same instructions as the Japanese Snd_Op9F_SetTranspose (1F:5564) over the whole routine (5 instructions, to the
; first ret / jp), only the addresses differ; code compared
Snd_Op9F_SetTranspose::
    call Snd_Trk_PtrInc                           ; $54C4
    call Snd_Trk_FetchByte                        ; $54C7
    ld [wSndTranspose], a                         ; $54CA

jr_00f_54cd:
    call Snd_Trk_PtrInc                           ; $54CD
    jr Snd_Trk_FetchOp                            ; $54D0

; C: same code as the Japanese Snd_Op9B_RepeatBegin (1F:5572, 36 bytes, masked match)
Snd_Op9B_RepeatBegin::
    call Snd_Trk_PtrInc                           ; $54D2
    call Snd_Trk_FetchByte                        ; $54D5
    push hl                                       ; $54D8
    ld a, l                                       ; $54D9
    add $0b                                       ; $54DA
    ld l, a                                       ; $54DC
    ld c, [hl]                                    ; $54DD
    ld a, b                                       ; $54DE
    or c                                          ; $54DF
    ld [hl], a                                    ; $54E0
    ld b, h                                       ; $54E1
    ld c, l                                       ; $54E2
    dec c                                         ; $54E3
    dec c                                         ; $54E4
    pop hl                                        ; $54E5
    ld a, [hl+]                                   ; $54E6
    ld e, a                                       ; $54E7
    ld a, [hl-]                                   ; $54E8
    ld d, a                                       ; $54E9
    inc de                                        ; $54EA
    ld a, e                                       ; $54EB
    ld [hl+], a                                   ; $54EC
    ld a, d                                       ; $54ED
    ld [hl-], a                                   ; $54EE
    ld a, d                                       ; $54EF
    ld [bc], a                                    ; $54F0
    dec c                                         ; $54F1
    ld a, e                                       ; $54F2
    ld [bc], a                                    ; $54F3
    jr Snd_Trk_FetchOp                            ; $54F4

; C: same code as the Japanese Snd_Op9C_RepeatEnd (1F:5596, 28 bytes, exact match)
Snd_Op9C_RepeatEnd::
    push hl                                       ; $54F6
    ld a, l                                       ; $54F7
    add $0b                                       ; $54F8
    ld l, a                                       ; $54FA
    ld a, [hl]                                    ; $54FB
    dec [hl]                                      ; $54FC
    ld a, [hl]                                    ; $54FD
    and $7f                                       ; $54FE
    jr z, jr_00f_550f                             ; $5500

    ld b, h                                       ; $5502
    ld c, l                                       ; $5503
    dec c                                         ; $5504
    dec c                                         ; $5505
    dec c                                         ; $5506
    pop hl                                        ; $5507
    ld a, [bc]                                    ; $5508
    ld [hl+], a                                   ; $5509
    inc c                                         ; $550A
    ld a, [bc]                                    ; $550B
    ld [hl-], a                                   ; $550C
    jr Snd_Trk_FetchOp                            ; $550D

jr_00f_550f:
    pop hl                                        ; $550F
    jr jr_00f_54cd                                ; $5510

; C: same instructions as the Japanese Snd_MusicTick (1F:55B2) over the whole routine (87 instructions, to the first
; ret / jp), only the addresses differ; code compared
Snd_MusicTick::
    ld hl, wSndSong                               ; $5512
    ld a, [hl]                                    ; $5515
    and a                                         ; $5516
    ret z                                         ; $5517

    ld a, $01                                     ; $5518
    ld [wSndCurTrack], a                          ; $551A
    ld hl, wSndTrack1                             ; $551D

Jump_00f_5520:
    inc l                                         ; $5520
    ld a, [hl+]                                   ; $5521
    and a                                         ; $5522
    jp z, Jump_00f_5470                           ; $5523

    dec [hl]                                      ; $5526
    jp nz, Snd_Trk_Sustain                        ; $5527

Jump_00f_552a:
    inc l                                         ; $552A
    inc l                                         ; $552B

; C: same code as the Japanese Snd_Trk_FetchOp (1F:55CC, 65 bytes, masked match)
Snd_Trk_FetchOp::
    call Snd_Trk_FetchByte                        ; $552C
    cp $00                                        ; $552F
    jp z, Snd_Op00_EndPattern                     ; $5531

    cp $9d                                        ; $5534
    jp z, Snd_Op9D_SetInstrument                  ; $5536

    cp $9e                                        ; $5539
    jp z, Snd_Op9E_SetDurTable                    ; $553B

    cp $9f                                        ; $553E
    jp z, Snd_Op9F_SetTranspose                   ; $5540

    cp $9b                                        ; $5543
    jp z, Snd_Op9B_RepeatBegin                    ; $5545

    cp $9c                                        ; $5548
    jp z, Snd_Op9C_RepeatEnd                      ; $554A

    and $f0                                       ; $554D
    cp $a0                                        ; $554F
    jr nz, Snd_Trk_NoteOn                         ; $5551

    ld a, b                                       ; $5553
    and $0f                                       ; $5554
    ld c, a                                       ; $5556
    ld b, $00                                     ; $5557
    push hl                                       ; $5559
    ld de, wSndDurTabLo                           ; $555A
    ld a, [de]                                    ; $555D
    ld l, a                                       ; $555E
    inc e                                         ; $555F
    ld a, [de]                                    ; $5560
    ld h, a                                       ; $5561
    add hl, bc                                    ; $5562
    ld a, [hl]                                    ; $5563
    pop hl                                        ; $5564
    dec l                                         ; $5565
    ld [hl+], a                                   ; $5566
    call Snd_Trk_PtrInc                           ; $5567
    call Snd_Trk_FetchByte                        ; $556A

; C: same code as the Japanese Snd_Trk_NoteOn (1F:560D, 66 bytes, masked match)
Snd_Trk_NoteOn::
    ld c, b                                       ; $556D
    ld b, $00                                     ; $556E
    call Snd_Trk_PtrInc                           ; $5570
    ld a, [wSndCurTrack]                          ; $5573
    cp $04                                        ; $5576
    jp z, Jump_00f_55af                           ; $5578

    push hl                                       ; $557B
    ld a, l                                       ; $557C
    add $05                                       ; $557D
    ld l, a                                       ; $557F
    ld e, l                                       ; $5580
    ld d, h                                       ; $5581
    inc l                                         ; $5582
    inc l                                         ; $5583
    ld a, c                                       ; $5584
    cp $01                                        ; $5585
    jr z, jr_00f_55aa                             ; $5587

    ld [hl], $00                                  ; $5589
    ld a, [wSndTranspose]                         ; $558B
    and a                                         ; $558E
    jr z, jr_00f_559d                             ; $558F

    ld l, a                                       ; $5591
    ld h, $00                                     ; $5592
    bit 7, l                                      ; $5594
    jr z, jr_00f_559a                             ; $5596

    ld h, $ff                                     ; $5598

jr_00f_559a:
    add hl, bc                                    ; $559A
    ld b, h                                       ; $559B
    ld c, l                                       ; $559C

jr_00f_559d:
    ld hl, Leftover_0F_4025_Snd_LengthTbl + $12   ; $559D
    add hl, bc                                    ; $55A0
    ld a, [hl+]                                   ; $55A1
    ld [de], a                                    ; $55A2
    inc e                                         ; $55A3
    ld a, [hl]                                    ; $55A4
    ld [de], a                                    ; $55A5
    pop hl                                        ; $55A6
    jp Jump_00f_55c8                              ; $55A7


jr_00f_55aa:
    ld [hl], $01                                  ; $55AA
    pop hl                                        ; $55AC
    jr jr_00f_55c8                                ; $55AD

Jump_00f_55af:
    push hl                                       ; $55AF
    ld de, wSndTrack4 + $6                        ; $55B0
    ld hl, Snd_FreqTbl + $90                      ; $55B3
    add hl, bc                                    ; $55B6

jr_00f_55b7:
    ld a, [hl+]                                   ; $55B7
    ld [de], a                                    ; $55B8
    inc e                                         ; $55B9
    ld a, e                                       ; $55BA
    cp $4b                                        ; $55BB
    jr nz, jr_00f_55b7                            ; $55BD

    ld c, $20                                     ; $55BF
    ld hl, wSndTrack4 + $4                        ; $55C1
    ld b, $00                                     ; $55C4
    jr jr_00f_560e                                ; $55C6

Jump_00f_55c8:
jr_00f_55c8:
    push hl                                       ; $55C8
    ld b, $00                                     ; $55C9
    ld a, [wSndCurTrack]                          ; $55CB
    cp $01                                        ; $55CE
    jr z, jr_00f_55f3                             ; $55D0

    cp $02                                        ; $55D2
    jr z, jr_00f_55ef                             ; $55D4

    ld c, $1a                                     ; $55D6
    ld a, [wSndTrack3 + $f]                       ; $55D8
    bit 7, a                                      ; $55DB
    jr nz, jr_00f_55e4                            ; $55DD

    xor a                                         ; $55DF
    ldh [c], a                                    ; $55E0
    ld a, $80                                     ; $55E1
    ldh [c], a                                    ; $55E3

jr_00f_55e4:
    inc c                                         ; $55E4
    inc l                                         ; $55E5
    inc l                                         ; $55E6
    inc l                                         ; $55E7
    inc l                                         ; $55E8
    ld a, [hl+]                                   ; $55E9
    ld e, a                                       ; $55EA
    ld d, $00                                     ; $55EB
    jr jr_00f_561a                                ; $55ED

jr_00f_55ef:
    ld c, $16                                     ; $55EF
    jr jr_00f_560e                                ; $55F1

jr_00f_55f3:
    ld c, $10                                     ; $55F3
    jr jr_00f_560b                                ; $55F5

    db $fa, $69, $d0, $fe, $01, $28, $06, $fe, $1e, $28, $02, $18, $07, $06, $33, $3e
    db $1d, $e2, $18, $02

jr_00f_560b:
    ld a, $00                                     ; $560B
    inc c                                         ; $560D

jr_00f_560e:
    inc l                                         ; $560E
    inc l                                         ; $560F
    inc l                                         ; $5610
    ld a, [hl-]                                   ; $5611
    and a                                         ; $5612
    jr nz, jr_00f_565f                            ; $5613

    ld a, [hl+]                                   ; $5615
    ld e, a                                       ; $5616

jr_00f_5617:
    inc l                                         ; $5617
    ld a, [hl+]                                   ; $5618
    ld d, a                                       ; $5619

jr_00f_561a:
    push hl                                       ; $561A
    inc l                                         ; $561B
    inc l                                         ; $561C
    ld a, [hl+]                                   ; $561D
    and a                                         ; $561E
    jr z, jr_00f_5623                             ; $561F

    ld e, $08                                     ; $5621

jr_00f_5623:
    inc l                                         ; $5623
    inc l                                         ; $5624
    ld [hl], $00                                  ; $5625
    inc l                                         ; $5627
    ld a, [hl]                                    ; $5628
    pop hl                                        ; $5629
    bit 7, a                                      ; $562A
    jr nz, jr_00f_563c                            ; $562C

    ld a, d                                       ; $562E
    or b                                          ; $562F
    ldh [c], a                                    ; $5630
    inc c                                         ; $5631
    ld a, e                                       ; $5632
    ldh [c], a                                    ; $5633
    inc c                                         ; $5634
    ld a, [hl+]                                   ; $5635
    ldh [c], a                                    ; $5636
    inc c                                         ; $5637
    ld a, [hl]                                    ; $5638
    or $c0                                        ; $5639
    ldh [c], a                                    ; $563B

jr_00f_563c:
    pop hl                                        ; $563C
    dec l                                         ; $563D
    ld a, [hl-]                                   ; $563E
    ld [hl-], a                                   ; $563F
    dec l                                         ; $5640

; C: same code as the Japanese Snd_Trk_Next (1F:56DF, 37 bytes, masked match)
Snd_Trk_Next::
    ld de, wSndCurTrack                           ; $5641
    ld a, [de]                                    ; $5644
    cp $04                                        ; $5645
    jr z, jr_00f_5652                             ; $5647

    inc a                                         ; $5649
    ld [de], a                                    ; $564A
    ld a, $10                                     ; $564B
    add l                                         ; $564D
    ld l, a                                       ; $564E
    jp Jump_00f_5520                              ; $564F


jr_00f_5652:
    ld hl, wSndTrack1 + $e                        ; $5652
    inc [hl]                                      ; $5655
    ld hl, wSndTrack2 + $e                        ; $5656
    inc [hl]                                      ; $5659
    ld hl, wSndTrack3 + $e                        ; $565A
    inc [hl]                                      ; $565D
    ret                                           ; $565E


jr_00f_565f:
    ld b, $00                                     ; $565F
    push hl                                       ; $5661
    pop hl                                        ; $5662
    inc l                                         ; $5663
    jr jr_00f_5617                                ; $5664

; C: same code as the Japanese Snd_Vib_Lookup (1F:5704)
Snd_Vib_Lookup::
    ld a, b                                       ; $5666
    srl a                                         ; $5667
    ld l, a                                       ; $5669
    ld h, $00                                     ; $566A
    add hl, de                                    ; $566C
    ld e, [hl]                                    ; $566D
    ret                                           ; $566E


; C: reads the channel record at HL + 6 into $D051 and updates the hardware channel by $D050; code read; runs from the
; first frame (the sound driver)
Snd_Trk_UpdateChannel::
    push hl                                       ; $566F
    ld a, l                                       ; $5670
    add $06                                       ; $5671
    ld l, a                                       ; $5673
    ld a, [hl]                                    ; $5674
    and $0f                                       ; $5675
    jr z, jr_00f_5691                             ; $5677

    ld [wSndTmp], a                               ; $5679
    ld a, [wSndCurTrack]                          ; $567C
    ld c, $13                                     ; $567F
    cp $01                                        ; $5681
    jr z, jr_00f_5693                             ; $5683

    ld c, $18                                     ; $5685
    cp $02                                        ; $5687
    jr z, jr_00f_5693                             ; $5689

    ld c, $1d                                     ; $568B
    cp $03                                        ; $568D
    jr z, jr_00f_5693                             ; $568F

jr_00f_5691:
    pop hl                                        ; $5691
    ret                                           ; $5692


jr_00f_5693:
    inc l                                         ; $5693
    ld a, [hl+]                                   ; $5694
    ld e, a                                       ; $5695
    ld a, [hl]                                    ; $5696
    ld d, a                                       ; $5697
    push de                                       ; $5698
    ld a, l                                       ; $5699
    add $04                                       ; $569A
    ld l, a                                       ; $569C
    ld b, [hl]                                    ; $569D
    ld a, [wSndTmp]                               ; $569E
    cp $01                                        ; $56A1
    jr z, jr_00f_56b0                             ; $56A3

    cp $03                                        ; $56A5
    jr z, jr_00f_56ab                             ; $56A7

    jr jr_00f_56b0                                ; $56A9

jr_00f_56ab:
    ld hl, hBoot_FFFE                             ; $56AB
    jr jr_00f_56cc                                ; $56AE

jr_00f_56b0:
    ld de, Snd_0F_56D5_Mode00_BootAndTitle_State00; $56B0
    call Snd_Vib_Lookup                           ; $56B3
    bit 0, b                                      ; $56B6
    jr nz, jr_00f_56bc                            ; $56B8

    swap e                                        ; $56BA

jr_00f_56bc:
    ld a, e                                       ; $56BC
    and $0f                                       ; $56BD
    bit 3, a                                      ; $56BF
    jr z, jr_00f_56c9                             ; $56C1

    ld h, $ff                                     ; $56C3
    or $f0                                        ; $56C5
    jr jr_00f_56cb                                ; $56C7

jr_00f_56c9:
    ld h, $00                                     ; $56C9

jr_00f_56cb:
    ld l, a                                       ; $56CB

jr_00f_56cc:
    pop de                                        ; $56CC
    add hl, de                                    ; $56CD
    ld a, l                                       ; $56CE
    ldh [c], a                                    ; $56CF
    inc c                                         ; $56D0
    ld a, h                                       ; $56D1
    ldh [c], a                                    ; $56D2
    jr jr_00f_5691                                ; $56D3

; C: read in the runs by Snd_Vib_Lookup; first read on the screen Mode00_BootAndTitle_State00
; (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_56D5_Mode00_BootAndTitle_State00::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $10, $00, $0f, $00, $00
    db $11, $00, $0f, $f0, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12
    db $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10

    db $ff, $ef, $01, $12, $10, $ff, $ef, $01, $12, $10, $ff, $ef

    ; padding
    ds $1e, $00

; C: read in the runs by Snd_Sfx_Lookup, Snd_Trk_FetchByte, Snd_Copy2; first read on the screen
; Mode00_BootAndTitle_State00 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_572F_Mode00_BootAndTitle_State00::
    db $8d, $57, $6e, $58, $46, $59, $1e, $70, $11, $5a, $ae, $57, $d9, $57, $fa, $76
    db $10, $78, $bc, $78, $61, $7b, $0c, $73, $b2, $7e, $a0, $5a, $7d, $63, $3d, $7a
    db $d0, $73, $c1, $5c, $40, $60, $ef, $60, $f1, $6d, $ff, $74, $07, $5c, $82, $69
    db $99, $71, $7d, $6b, $89, $7e, $c4, $6b, $c7, $7a, $b8, $61, $e4, $65, $e4, $65
    db $e9, $66, $15, $72, $96, $7a, $91, $67, $61, $7b, $ff, $7a, $9d, $6a, $33, $7b
    db $71, $7d, $d9, $57, $f7, $75, $e8, $7d, $9d, $6a, $7c, $75, $ae, $57, $00, $94
    db $41, $9c, $57, $98, $57, $00, $00, $00, $00, $a0, $57, $00, $00, $a7, $57, $00
    db $00, $9d, $81, $00, $80, $a5, $01, $00, $9d, $a2, $00, $80, $a5, $01, $00

; I: never read in the runs, but Snd_0F_572F_Mode00_BootAndTitle_State00 points to it (the word at 0F:5739): 43 bytes
; (0F:57AE-57D8) that no run reads or executes and that no code names (owner rule 2026-11-11)
Snd_0F_57AE_EntryOf572F::
    db $00, $94, $41, $c9, $57, $b9, $57, $00, $00, $00, $00, $bf, $57, $ff, $ff, $b9
    db $57, $9d, $41, $00, $80, $a1, $32, $01, $01, $3a, $00, $1e, $58, $ff, $ff, $e4
    db $57, $9d, $31, $00, $80, $a1, $01, $01, $1e, $22, $00

; C: read in the runs by Snd_Trk_FetchByte, Snd_Trk_LoadFirstPattern, Snd_Copy2; first read on the screen
; Mode04_PlayMenu_State01 (trace/read_screens_kitty.npz); kind SOUND from the evidence of tools/kitty_layout_kinds.py
Snd_0F_57D9_Mode04_PlayMenu_State01::
    INCBIN "data/bank_0f/Snd_0F_57D9_Mode04_PlayMenu_State01.bin" ; $57D9, 568 bytes
; I: never read in the runs, but Snd_0F_572F_Mode00_BootAndTitle_State00 points to it (the word at 0F:5737): 143 bytes
; (0F:5A11-5A9F) that no run reads or executes and that no code names (owner rule 2026-11-11)
Snd_0F_5A11_EntryOf572F::
    db $00, $84, $41, $1c, $5a, $22, $5a, $28, $5a, $00, $00, $2e, $5a, $ff, $ff, $1c
    db $5a, $54, $5a, $ff, $ff, $22, $5a, $7a, $5a, $ff, $ff, $28, $5a, $9d, $a1, $00
    db $c0, $a2, $02, $01, $30, $01, $2c, $01, $28, $01, $24, $01, $28, $01, $2c, $01
    db $30, $01, $02, $01, $30, $01, $2c, $01, $28, $01, $24, $24, $01, $24, $2e, $2e
    db $2e, $01, $00, $9d, $72, $00, $c0, $a2, $1a, $52, $18, $52, $14, $52, $10, $52
    db $0c, $54, $10, $54, $14, $54, $18, $54, $1a, $52, $18, $52, $14, $52, $10, $52
    db $0c, $0c, $01, $0c, $16, $16, $16, $01, $00, $9d, $22, $41, $20, $a2, $32, $70
    db $01, $58, $44, $70, $01, $58, $01, $5c, $40, $5c, $01, $74, $01, $5c, $01, $70
    db $48, $58, $01, $70, $01, $58, $3c, $01, $01, $3c, $01, $2e, $2e, $01, $00

; C: read in the runs by Snd_Trk_FetchByte, Snd_Trk_LoadFirstPattern, Snd_Copy2; first read on the screen
; Mode05_StampWindow_State06 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_5AA0_Mode05_StampWindow_State06::
    INCBIN "data/bank_0f/Snd_0F_5AA0_Mode05_StampWindow_State06.bin" ; $5AA0, 3313 bytes
; I: never read in the runs, but Snd_0F_572F_Mode00_BootAndTitle_State00 points to it (the word at 0F:5775): 497 bytes
; (0F:6791-6981) that no run reads or executes and that no code names (owner rule 2026-11-11)
Snd_0F_6791_EntryOf572F::
    INCBIN "data/bank_0f/Snd_0F_6791_EntryOf572F.bin" ; $6791, 497 bytes
; C: read in the runs by Snd_Trk_FetchByte, Snd_Trk_LoadFirstPattern, Snd_Copy2; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_6982_Mode02_TakePhotos_State01::
    INCBIN "data/bank_0f/Snd_0F_6982_Mode02_TakePhotos_State01.bin" ; $6982, 701 bytes
; C: read in the runs by Snd_Trk_FetchByte
Snd_0F_6C3F_Snd_Trk_FetchByte::
    db $9d, $a7, $00, $00, $9b, $02, $a8, $01, $01, $a9, $01, $01, $a1, $54, $ac, $01
    db $a3, $54, $9c, $9d, $78, $00, $80, $a4, $5e, $5a, $58, $56, $54, $01, $a5, $01
    db $00, $9d, $2d, $7a, $20, $a2, $16, $01, $2e, $01, $2a, $01, $24, $01, $1e, $01
    db $20, $01, $a9, $22, $01, $24, $a2, $0c, $01, $16, $01

    db $2e, $01, $2a, $01, $24, $01, $1e, $01, $20, $01, $a9, $22, $01, $24, $a2, $2a
    db $01, $16, $01, $16, $01, $9d, $1d, $7a, $20, $06, $01, $06, $01, $08, $01, $08
    db $01, $0a, $01, $0a, $01, $a3, $0c, $a5, $01, $a3, $0c, $a9, $01, $01, $0c, $a2
    db $0c, $01, $00

; C: read in the runs by Snd_Trk_FetchByte
Snd_0F_6CAD_Snd_Trk_FetchByte::
    db $9b, $06, $a3, $06, $0b, $06, $0b, $9c

    db $06, $a8, $01, $a3, $01, $0b, $a9, $06, $01, $06, $a3, $10, $00

; I: leftover: 303 bytes (0F:6CC2-6DF0) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0F_6CC2::
    INCBIN "data/bank_0f/Leftover_0F_6CC2.bin" ; $6CC2, 303 bytes
; C: read in the runs by Snd_Trk_FetchByte, Snd_Trk_LoadFirstPattern, Snd_Copy2; first read on the screen
; Mode11_StrawberryChannel_State07 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_6DF1_Mode11_StrawberryChannel_State07::
    INCBIN "data/bank_0f/Snd_0F_6DF1_Mode11_StrawberryChannel_State07.bin" ; $6DF1, 3237 bytes
; I: never read in the runs, but Snd_0F_572F_Mode00_BootAndTitle_State00 points to it (the word at 0F:5773): 49 bytes
; (0F:7A96-7AC6) that no run reads or executes and that no code names (owner rule 2026-11-11)
Snd_0F_7A96_EntryOf572F::
    db $00, $94, $41, $00, $00, $a1, $7a, $00, $00, $00, $00, $a7, $7a, $ff, $ff, $a1
    db $7a, $9d, $93, $00, $80, $a8, $3c, $a2, $3c, $44, $4e, $a4, $4a, $a3, $44, $3c
    db $a7, $3a, $a2, $3c, $40, $a7, $3a, $a3, $36, $a2, $32, $36, $a7, $3c, $a2, $01
    db $00

; C: read in the runs by Snd_Trk_FetchByte, Snd_Copy2, Snd_Trk_LoadFirstPattern; first read on the screen
; Mode0C_RecordBook_State01 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_7AC7_Mode0C_RecordBook_State01::
    db $00, $94, $41, $00, $00, $d2, $7a, $00, $00, $00, $00, $d8, $7a, $ff, $ff, $d2
    db $7a, $9d, $93, $00, $80, $a2, $32, $32, $32, $a3, $32, $a2, $3a, $36, $32, $a3
    db $30, $a2, $30, $a8, $32, $a2, $3a, $3a, $3a, $a3, $3a, $a2, $40, $3c, $3a, $a3
    db $36, $a2, $36, $a4, $32, $a2, $01, $00, $00, $94, $41, $00, $00, $0a, $7b, $00
    db $00, $00, $00, $10, $7b, $ff, $ff, $0a, $7b, $9d, $93, $00, $80, $a2, $40, $40
    db $40, $44, $40, $3c, $3a, $36, $a3, $32, $3a, $a4, $40, $a2, $44, $44, $44, $40
    db $48, $48, $48, $44, $a3, $40, $a2, $44, $48, $a4, $4a, $00, $00, $94, $41, $00
    db $00, $3e, $7b, $00, $00, $00, $00, $44, $7b, $ff, $ff, $3e, $7b, $9d, $93, $00
    db $80, $a3, $4a, $52, $4e, $4a, $a7, $48, $a1, $44, $48, $a4, $4a, $a3, $4a, $52
    db $4e, $4a, $a7, $44, $a1, $44, $48, $a4, $4a, $00, $00, $94, $41, $00, $00, $6c
    db $7b, $00, $00, $00, $00, $74, $7b, $7d, $7b, $ff, $ff, $6e, $7b, $9d, $93, $00
    db $80, $a0, $3a, $40, $4a, $00, $9d, $5d, $00, $81, $a3, $3a, $40, $4a, $a7, $48
    db $a2, $44, $a3, $40, $a7, $44, $a2, $3c, $a3, $44, $a4, $40, $a3, $01, $a3, $3c
    db $a2, $3a, $36, $36, $a7, $40, $a3, $3a, $a2, $32, $36, $3a, $a7, $40, $a3, $3c
    db $3a, $a7, $36, $a2, $40, $a8, $4a, $a3, $01, $00

; I: leftover: 448 bytes (0F:7BB1-7D70) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0F_7BB1::
    INCBIN "data/bank_0f/Leftover_0F_7BB1.bin" ; $7BB1, 448 bytes
; C: read in the runs by Snd_Trk_FetchByte, Snd_Trk_LoadFirstPattern, Snd_Copy2; kind SOUND from the evidence of
; tools/kitty_layout_kinds.py
Snd_0F_7D71_Snd_Trk_FetchByte::
    db $00, $94, $41, $7c, $7d, $84, $7d, $8c, $7d, $00, $00, $94, $7d, $a2, $7d, $ff
    db $ff, $7e, $7d, $b4, $7d, $c2, $7d, $ff, $ff, $86, $7d, $d4, $7d, $e1, $7d, $ff
    db $ff, $8e, $7d, $9d, $93, $00, $80, $a2, $40, $a1, $40, $44, $5c, $60, $a4, $62
    db $00, $9d, $53, $00, $80, $a1, $36, $36, $36, $a6, $44, $a2, $48, $a3, $58, $a2
    db $54, $3a, $00, $9d, $93, $00, $80, $a2, $4a, $a1, $4a, $3c, $44, $48, $a4, $4a
    db $00, $9d, $53, $00, $80, $a1, $44, $44, $44, $a6, $4a, $a2, $4e, $a3, $52, $a2
    db $4e, $4a, $00, $9d, $22, $41, $20, $a3, $3a, $a2, $4a, $a2, $40, $a7, $01, $00
    db $9d, $42, $41, $20, $a5, $01, $00

; I: never read in the runs, but Snd_0F_572F_Mode00_BootAndTitle_State00 points to it (the word at 0F:5785): 91 bytes
; (0F:7DE8-7E42) that no run reads or executes and that no code names (owner rule 2026-11-11)
Snd_0F_7DE8_EntryOf572F::
    db $00, $94, $41, $f3, $7d, $fb, $7d, $03, $7e, $00, $00, $0b, $7e, $1f, $7e, $ff
    db $ff, $f5, $7d, $43, $7e, $57, $7e, $ff, $ff, $fd, $7d, $6d, $7e, $7f, $7e, $ff
    db $ff, $05, $7e, $9d, $93, $00, $80, $a3, $3a, $a2, $3a, $3a, $3c, $a1, $40, $44
    db $a2, $48, $01, $48, $a8, $4a, $00, $9d, $53, $00, $80, $a2, $3a, $3c, $a3, $40
    db $4a, $a2, $48, $44, $40, $3c

    db $a7, $3a, $a2, $3c, $a3, $40, $a2, $4a, $4e, $a3, $52, $4a, $a2, $40, $a7, $4e
    db $a4, $4a, $a3, $01, $00

; I: leftover: 70 bytes (0F:7E43-7E88) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_0F_7E43::
    db $9d, $93, $00, $80, $a2, $32, $32, $32, $32, $36, $a1, $32, $3c, $a2, $40, $01
    db $40, $a8, $40, $00, $9d, $53, $00, $80, $a5, $01, $01, $a2, $40, $44, $a3, $48
    db $40, $a2, $32, $a7, $44, $a4, $40, $a3, $01, $00, $9d, $42, $41, $20, $a4, $01
    db $a3, $01, $a2, $4e, $01, $4e, $a2, $52, $01, $a4, $01, $00, $9d, $42, $41, $20
    db $a5, $01, $01, $01, $01, $00

; C: read in the runs by Snd_Trk_FetchByte, Snd_Copy2, Snd_Trk_LoadFirstPattern; first read on the screen
; Mode12_SlideShow_State01 (trace/read_screens_kitty.npz); kind SOUND from the evidence of
; tools/kitty_layout_kinds.py; the rest of Data_0F_7E43 after a leftover stretch
Snd_0F_7E89_Mode12_SlideShow_State01::
    db $00, $94, $41, $00, $00, $94, $7e, $00, $00, $00, $00, $9a, $7e, $ff, $ff, $94
    db $7e, $9d, $e1, $00, $80, $a2, $4a, $a1, $4a, $a2, $48, $44, $40, $3c, $3a, $36
    db $a3, $32, $a2, $32, $a4, $32, $a3, $01, $00, $00, $94, $41, $00, $00, $bd, $7e
    db $00, $00, $00, $00, $c3, $7e, $ff, $ff, $bd, $7e, $9d, $94, $00, $80, $a3, $52
    db $4a, $a7, $4e, $a2, $58, $52, $4e, $4a, $a4, $4e, $a2, $01, $a7, $48, $a2, $48
    db $48, $4a, $4e, $48, $a5, $4c, $00

    ; padding
    ds $110, $00

    db $c3, $37, $53, $c3, $63, $52, $c3, $08, $53

    ; padding
    ds $7, $00

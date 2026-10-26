; Game Boy Camera (USA, Europe), bank $06. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

; C: mode 15: self-timer (delay) and interval shooting
Mode15_SelfTimerInterval::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; C: 10 states | 10 words 4018, 4027, 40C2, 410A, 4142, 416A, 4222, 42A7, 4308, 434F = the whole table up to 4018 (the
; label that cut it at 4008 was `ld bc,$4008`, a sprite position of Shoot_DrawBurstIcon)
Mode15_StateTable::
    dw Mode15_State00_ReturnToShoot
    dw Mode15_State01_TimerInit
    dw Mode15_State02_TimerChoose
    dw Mode15_State03_TimerConfirm
    dw Mode15_State04_TimerApply
    dw Mode15_State05_IntervalInit
    dw Mode15_State06_IntervalChoose
    dw Mode15_State07_ShotsChoose
    dw Mode15_State08_IntervalConfirm
    dw Mode15_State09_IntervalApply

; C: shoot_variant 0 and back to mode 14
Mode15_State00_ReturnToShoot::
    xor a                                         ; $4018
    ld [wShootVariant], a                         ; $4019
    ld a, MODE_SHOOT_LIVE_VIEW                    ; $401C
    ld [wMode], a                                 ; $401E
    set_state STATE_14_INIT                       ; $4021
    ret                                           ; $4026


; C: self-timer screen
Mode15_State01_TimerInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4027
    ldh [hLcdcShadow], a                          ; $4029
    ld a, $e4                                     ; $402B
    ld [wPaletteTarget], a                        ; $402D
    ld [wPaletteTarget + $1], a                   ; $4030
    ld a, $d2                                     ; $4033
    ld [wPaletteTarget + $2], a                   ; $4035
    xor a                                         ; $4038
    ldh [hScxShadow], a                           ; $4039
    ldh [hScyShadow], a                           ; $403B
    farcopy Mem_CopyFromBank, Gfx_20_6800_Mode15_State01_TimerInit, $9000, $0640 ; $403D
    farcopy Mem_CopyFromBank, Gfx_20_6EC0_Mode15_State01_TimerInit, $97a0, $0060 ; $404B
    farcopy Mem_CopyFromBank, Gfx_20_6F20_Mode15_State01_TimerInit, $8800, $01c0 ; $4059
    farcopy Mem_CopyFromBank, Gfx_20_74F0_Mode15_State01_TimerInit, $8ff0, $0010 ; $4067
    farcopy Mem_CopyFromBank, Gfx_20_72C0_Mode15_State01_TimerInit, $8500, $01d0 ; $4075
    farcopy Mem_CopyFromBank, Gfx_20_6E40_Mode15_State01_TimerInit, $9720, $0080 ; $4083
    farcopy Mem_CopyFromBank, Map_25_63E0_Mode15_State01_TimerInit, $9800, $0240 ; $4091
    screen_on                                     ; $409F
    play_music MUSIC_TIMER_PRINT_OPTIONS          ; $40A8
    ld a, $05                                     ; $40AF
    ld [wSelftimerDelay], a                       ; $40B1
    ld de, $9640                                  ; $40B4
    call Mode15_DrawTwoDigits                     ; $40B7
    call Pal_FadeIn                               ; $40BA
    next_state                                    ; $40BD
    ret                                           ; $40C1


; C: Up / Down changes the delay in seconds
Mode15_State02_TimerChoose::
    ld a, [wSelftimerDelay]                       ; $40C2
    ld bc, $0119                                  ; $40C5
    ld hl, hKeysNewRepeat                         ; $40C8
    call Mode15_StepValue                         ; $40CB
    ld hl, wSelftimerDelay                        ; $40CE
    cp [hl]                                       ; $40D1
    jr z, jr_006_40db                             ; $40D2

    ld [hl], a                                    ; $40D4
    ld de, $9640                                  ; $40D5
    call Mode15_DrawTwoDigits                     ; $40D8

jr_006_40db:
    ld bc, $6832                                  ; $40DB
    call Mode15_DrawArrows                        ; $40DE
    ld a, [wSelftimerDelay]                       ; $40E1
    sla a                                         ; $40E4
    add $46                                       ; $40E6
    ld b, a                                       ; $40E8
    ld c, $48                                     ; $40E9
    ld a, [wSelftimerDelay]                       ; $40EB
    sub $05                                       ; $40EE
    call Mode15_DrawSecondsSprite                 ; $40F0
    ldh a, [hKeysNew]                             ; $40F3
    and PADF_A | PADF_B | PADF_DOWN               ; $40F5
    ret z                                         ; $40F7

    ld [wAbResult], a                             ; $40F8
    bit 1, a                                      ; $40FB
    jr z, jr_006_4105                             ; $40FD

    set_state STATE_15_TIMER_APPLY                ; $40FF
    ret                                           ; $4104


jr_006_4105:
    next_state                                    ; $4105
    ret                                           ; $4109


; C: blinking OK / cancel
Mode15_State03_TimerConfirm::
    call Mode15_DrawBlinkSprite                   ; $410A
    ld a, [wSelftimerDelay]                       ; $410D
    sla a                                         ; $4110
    add $46                                       ; $4112
    ld b, a                                       ; $4114
    ld c, $48                                     ; $4115
    call Mode15_DrawOkSprite                      ; $4117
    ldh a, [hKeysNew]                             ; $411A
    and PADF_A | PADF_B | PADF_UP                 ; $411C
    ret z                                         ; $411E

    ld [wAbResult], a                             ; $411F
    bit 6, a                                      ; $4122
    jr z, jr_006_412b                             ; $4124

    ld hl, wState                                 ; $4126
    dec [hl]                                      ; $4129
    ret                                           ; $412A


jr_006_412b:
    push af                                       ; $412B
    bit 0, a                                      ; $412C
    ld a, SFX1_KEY_START                          ; $412E
    call nz, Snd_Sfx1                             ; $4130
    pop af                                        ; $4133
    push af                                       ; $4134
    bit 1, a                                      ; $4135
    ld a, SFX1_KEY_B                              ; $4137
    call nz, Snd_Sfx1                             ; $4139
    pop af                                        ; $413C
    next_state                                    ; $413D
    ret                                           ; $4141


; C: A: shoot_variant 1 (self-timer) to mode 14
Mode15_State04_TimerApply::
    screen_off                                    ; $4142
    ld a, [wAbResult]                             ; $4148
    bit 0, a                                      ; $414B
    jr nz, jr_006_415a                            ; $414D

    ld a, MODE_SHOOT_PARLOR                       ; $414F
    ld [wMode], a                                 ; $4151
    set_state STATE_01_INTRO_PAGE_C               ; $4154
    ret                                           ; $4159


jr_006_415a:
    ld a, $01                                     ; $415A
    ld [wShootVariant], a                         ; $415C
    ld a, MODE_SHOOT_LIVE_VIEW                    ; $415F
    ld [wMode], a                                 ; $4161
    set_state STATE_14_INIT                       ; $4164
    ret                                           ; $4169


; C: interval screen
Mode15_State05_IntervalInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $416A
    ldh [hLcdcShadow], a                          ; $416C
    ld a, $e4                                     ; $416E
    ld [wPaletteTarget], a                        ; $4170
    ld [wPaletteTarget + $1], a                   ; $4173
    ld a, $d2                                     ; $4176
    ld [wPaletteTarget + $2], a                   ; $4178
    xor a                                         ; $417B
    ldh [hScxShadow], a                           ; $417C
    ldh [hScyShadow], a                           ; $417E
    farcopy Mem_CopyFromBank, Gfx_20_6800_Mode15_State01_TimerInit, $9000, $0640 ; $4180
    farcopy Mem_CopyFromBank, Gfx_20_6EC0_Mode15_State01_TimerInit, $97a0, $0060 ; $418E
    farcopy Mem_CopyFromBank, Gfx_20_6F20_Mode15_State01_TimerInit, $8800, $01c0 ; $419C
    farcopy Mem_CopyFromBank, Gfx_20_74F0_Mode15_State01_TimerInit, $8ff0, $0010 ; $41AA
    farcopy Mem_CopyFromBank, Gfx_20_72C0_Mode15_State01_TimerInit, $8500, $01d0 ; $41B8
    farcopy Mem_CopyFromBank, Gfx_20_6E40_Mode15_State01_TimerInit, $9720, $0080 ; $41C6
    farcopy Mem_CopyFromBank, Map_25_6860_Mode15_State05_IntervalInit, $9800, $0240 ; $41D4
    screen_on                                     ; $41E2
    play_music MUSIC_TIMER_PRINT_OPTIONS          ; $41EB
    ld a, $00                                     ; $41F2
    ld [wIntervalIndex], a                        ; $41F4
    ld de, $9680                                  ; $41F7
    call Mode15_DrawTwoDigits                     ; $41FA
    ld a, [wIntervalIndex]                        ; $41FD
    call Mode15_DrawIntervalText                  ; $4200
    ld a, $1e                                     ; $4203
    ld hl, wPhotoCount                            ; $4205
    sub [hl]                                      ; $4208
    ld [wIntervalShots], a                        ; $4209
    push af                                       ; $420C
    ld de, $96c0                                  ; $420D
    call Mode15_DrawTwoDigits                     ; $4210
    pop af                                        ; $4213
    ld de, $9700                                  ; $4214
    call Mode15_DrawTwoDigitsInterval             ; $4217
    call Pal_FadeIn                               ; $421A
    next_state                                    ; $421D
    ret                                           ; $4221


; C: interval index 0..$18
Mode15_State06_IntervalChoose::
    ld a, [wIntervalIndex]                        ; $4222
    ld bc, $001d                                  ; $4225
    ld hl, hKeysNewRepeat                         ; $4228
    cp $18                                        ; $422B
    jr c, jr_006_4232                             ; $422D

    ld hl, hKeysNew                               ; $422F

jr_006_4232:
    call Mode15_StepValue                         ; $4232
    ld hl, wIntervalIndex                         ; $4235
    cp [hl]                                       ; $4238
    jr z, jr_006_4250                             ; $4239

    ld [hl], a                                    ; $423B
    ld c, a                                       ; $423C
    ld b, $00                                     ; $423D
    ld hl, Mode15_IntervalValueTbl                ; $423F
    add hl, bc                                    ; $4242
    ld a, [hl]                                    ; $4243
    ld de, $9680                                  ; $4244
    call Mode15_DrawTwoDigits                     ; $4247
    ld a, [wIntervalIndex]                        ; $424A
    call Mode15_DrawIntervalText                  ; $424D

jr_006_4250:
    ld bc, $6822                                  ; $4250
    call Mode15_DrawArrows                        ; $4253
    ld a, [wIntervalIndex]                        ; $4256
    add $30                                       ; $4259
    ld b, a                                       ; $425B
    ld c, $30                                     ; $425C
    ld a, [wIntervalIndex]                        ; $425E
    cp $19                                        ; $4261
    jr c, jr_006_426f                             ; $4263

    sub $19                                       ; $4265
    swap a                                        ; $4267
    srl a                                         ; $4269
    add $58                                       ; $426B
    ld b, a                                       ; $426D
    xor a                                         ; $426E

jr_006_426f:
    call Mode15_DrawSecondsSprite                 ; $426F
    ldh a, [hKeysNew]                             ; $4272
    and PADF_A | PADF_B | PADF_DOWN               ; $4274
    ret z                                         ; $4276

    ld [wAbResult], a                             ; $4277
    bit 1, a                                      ; $427A
    jr z, jr_006_4284                             ; $427C

    set_state STATE_15_INTERVAL_APPLY             ; $427E
    ret                                           ; $4283


jr_006_4284:
    next_state                                    ; $4284
    ret                                           ; $4288


; C: 30 numbers shown for the interval choice wIntervalIndex 0-29 (Mode15_StepValue limits B = 0, C = $1D): 0-15,
; 20-60 in steps of 5, then 5 / 10 / 15 / 30 / 60 from index $19 (drawn with the other unit sprite, I); index 0 draws
; a word instead of the number (Mode15_DrawIntervalText); read by ...
Mode15_IntervalValueTbl::
    db $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f
    db $14, $19, $1e, $23, $28, $2d, $32, $37, $3c, $05, $0a, $0f, $1e, $3c

; C: number of exposures (up to free photo slots)
Mode15_State07_ShotsChoose::
    ld a, $1e                                     ; $42A7
    ld hl, wPhotoCount                            ; $42A9
    sub [hl]                                      ; $42AC
    ld c, a                                       ; $42AD
    ld b, $00                                     ; $42AE
    ld a, [wIntervalShots]                        ; $42B0
    ld hl, hKeysNewRepeat                         ; $42B3
    call Mode15_StepValue                         ; $42B6
    ld hl, wIntervalShots                         ; $42B9
    cp [hl]                                       ; $42BC
    jr z, jr_006_42c6                             ; $42BD

    ld [hl], a                                    ; $42BF
    ld de, $96c0                                  ; $42C0
    call Mode15_DrawTwoDigits                     ; $42C3

jr_006_42c6:
    ld bc, $405a                                  ; $42C6
    call Mode15_DrawArrows                        ; $42C9
    ld a, [wIntervalIndex]                        ; $42CC
    add $30                                       ; $42CF
    ld b, a                                       ; $42D1
    ld c, $30                                     ; $42D2
    ld a, [wIntervalIndex]                        ; $42D4
    cp $19                                        ; $42D7
    jr c, jr_006_42e5                             ; $42D9

    sub $19                                       ; $42DB
    swap a                                        ; $42DD
    srl a                                         ; $42DF
    add $58                                       ; $42E1
    ld b, a                                       ; $42E3
    xor a                                         ; $42E4

jr_006_42e5:
    call Mode15_DrawOkSprite                      ; $42E5
    ldh a, [hKeysNew]                             ; $42E8
    and PADF_A | PADF_B | PADF_UP | PADF_DOWN     ; $42EA
    ret z                                         ; $42EC

    ld [wAbResult], a                             ; $42ED
    bit 1, a                                      ; $42F0
    jr z, jr_006_42fa                             ; $42F2

    set_state STATE_15_INTERVAL_APPLY             ; $42F4
    ret                                           ; $42F9


jr_006_42fa:
    bit 6, a                                      ; $42FA
    jr z, jr_006_4303                             ; $42FC

    ld hl, wState                                 ; $42FE
    dec [hl]                                      ; $4301
    ret                                           ; $4302


jr_006_4303:
    next_state                                    ; $4303
    ret                                           ; $4307


; C
Mode15_State08_IntervalConfirm::
    call Mode15_DrawBlinkSprite                   ; $4308
    ld a, [wIntervalIndex]                        ; $430B
    add $30                                       ; $430E
    ld b, a                                       ; $4310
    ld c, $30                                     ; $4311
    ld a, [wIntervalIndex]                        ; $4313
    cp $19                                        ; $4316
    jr c, jr_006_4324                             ; $4318

    sub $19                                       ; $431A
    swap a                                        ; $431C
    srl a                                         ; $431E
    add $58                                       ; $4320
    ld b, a                                       ; $4322
    xor a                                         ; $4323

jr_006_4324:
    call Mode15_DrawOkSprite                      ; $4324
    ldh a, [hKeysNew]                             ; $4327
    and PADF_A | PADF_B | PADF_UP                 ; $4329
    ret z                                         ; $432B

    ld [wAbResult], a                             ; $432C
    bit 6, a                                      ; $432F
    jr z, jr_006_4338                             ; $4331

    ld hl, wState                                 ; $4333
    dec [hl]                                      ; $4336
    ret                                           ; $4337


jr_006_4338:
    push af                                       ; $4338
    bit 0, a                                      ; $4339
    ld a, SFX1_KEY_START                          ; $433B
    call nz, Snd_Sfx1                             ; $433D
    pop af                                        ; $4340
    push af                                       ; $4341
    bit 1, a                                      ; $4342
    ld a, SFX1_KEY_B                              ; $4344
    call nz, Snd_Sfx1                             ; $4346
    pop af                                        ; $4349
    next_state                                    ; $434A
    ret                                           ; $434E


; C: A: shoot_variant 2 (interval) to mode 14
Mode15_State09_IntervalApply::
    screen_off                                    ; $434F
    ld a, [wAbResult]                             ; $4355
    bit 0, a                                      ; $4358
    jr nz, jr_006_4367                            ; $435A

    ld a, MODE_SHOOT_PARLOR                       ; $435C
    ld [wMode], a                                 ; $435E
    set_state STATE_01_INTRO_PAGE_C               ; $4361
    ret                                           ; $4366


jr_006_4367:
    ld a, $02                                     ; $4367
    ld [wShootVariant], a                         ; $4369
    ld a, MODE_SHOOT_LIVE_VIEW                    ; $436C
    ld [wMode], a                                 ; $436E
    set_state STATE_14_INIT                       ; $4371
    ret                                           ; $4376


; C: Left / Right arrow sprites; BGB watchpoint pass 2026-10-25: ran only in mode 15 (5632 hits in 16 runs: 15:02
; x3263 15:06 x1118 15:07 x1251; tcrf_check/assets/mode_state_wp/)
Mode15_DrawArrows::
    ldh a, [hKeysHeld]                            ; $4377
    bit PADB_LEFT, a                              ; $4379
    jr z, jr_006_4381                             ; $437B

    ld a, $02                                     ; $437D
    jr jr_006_438b                                ; $437F

jr_006_4381:
    bit 4, a                                      ; $4381
    jr z, jr_006_4389                             ; $4383

    ld a, $01                                     ; $4385
    jr jr_006_438b                                ; $4387

jr_006_4389:
    ld a, $ff                                     ; $4389

jr_006_438b:
    ld hl, hFrameCounter                          ; $438B
    bit 2, [hl]                                   ; $438E
    jr z, jr_006_4393                             ; $4390

    xor a                                         ; $4392

jr_006_4393:
    bit 7, a                                      ; $4393
    ret nz                                        ; $4395

    add $42                                       ; $4396
    call Oam_AddMeta_B01_5D2B                     ; $4398
    ret                                           ; $439B


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (8762 hits in 16 runs: 15:02 x6526 15:06 x2236;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawSecondsSprite::
    cpl                                           ; $439C
    inc a                                         ; $439D
    and $07                                       ; $439E
    add $45                                       ; $43A0
    call Oam_AddMeta_B01_5D2B                     ; $43A2
    ret                                           ; $43A5


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (6912 hits in 12 runs: 15:03 x3162 15:07 x2502 15:08 x1248;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawOkSprite::
    ld a, $4d                                     ; $43A6
    call Oam_AddMeta_B01_5D2B                     ; $43A8
    ret                                           ; $43AB


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (2205 hits in 12 runs: 15:03 x1581 15:08 x624;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawBlinkSprite::
    ldh a, [hFrameCounter]                        ; $43AC
    and $07                                       ; $43AE
    cp $02                                        ; $43B0
    ret c                                         ; $43B2

    ld bc, $506f                                  ; $43B3
    ld a, $4e                                     ; $43B6
    call Oam_AddMeta_B01_5D2B                     ; $43B8
    ret                                           ; $43BB


; C: A as two numeral tiles
Mode15_DrawTwoDigits::
    ld c, $00                                     ; $43BC

jr_006_43be:
    cp $0a                                        ; $43BE
    jr c, jr_006_43c7                             ; $43C0

    sub $0a                                       ; $43C2
    inc c                                         ; $43C4
    jr jr_006_43be                                ; $43C5

jr_006_43c7:
    push af                                       ; $43C7
    swap c                                        ; $43C8
    ld b, $00                                     ; $43CA
    sla c                                         ; $43CC
    rl b                                          ; $43CE
    ld hl, Gfx_20_7180_Mode15_DrawTwoDigits       ; $43D0
    add hl, bc                                    ; $43D3
    ld a, BANK(Gfx_20_7180_Mode15_DrawTwoDigits)  ; $43D4
    ld bc, $0020                                  ; $43D6
    call Vram_CopyFromBank                        ; $43D9
    pop af                                        ; $43DC
    ld c, a                                       ; $43DD
    swap c                                        ; $43DE
    ld b, $00                                     ; $43E0
    sla c                                         ; $43E2
    rl b                                          ; $43E4
    ld hl, Gfx_20_7180_Mode15_DrawTwoDigits       ; $43E6
    add hl, bc                                    ; $43E9
    ld a, BANK(Gfx_20_7180_Mode15_DrawTwoDigits)  ; $43EA
    ld bc, $0020                                  ; $43EC
    call Vram_CopyFromBank                        ; $43EF
    ret                                           ; $43F2


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (14 hits in 6 runs: 15:05 x14;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawTwoDigitsInterval::
    ld c, $00                                     ; $43F3

jr_006_43f5:
    cp $0a                                        ; $43F5
    jr c, jr_006_43fe                             ; $43F7

    sub $0a                                       ; $43F9
    inc c                                         ; $43FB
    jr jr_006_43f5                                ; $43FC

jr_006_43fe:
    push af                                       ; $43FE
    swap c                                        ; $43FF
    ld b, $00                                     ; $4401
    ld hl, Gfx_20_70E0_Mode15_DrawTwoDigitsInterval ; $4403
    add hl, bc                                    ; $4406
    ld a, BANK(Gfx_20_70E0_Mode15_DrawTwoDigitsInterval) ; $4407
    ld bc, $0010                                  ; $4409
    call Vram_CopyFromBank                        ; $440C
    pop af                                        ; $440F
    ld c, a                                       ; $4410
    swap c                                        ; $4411
    ld b, $00                                     ; $4413
    ld hl, Gfx_20_70E0_Mode15_DrawTwoDigitsInterval ; $4415
    add hl, bc                                    ; $4418
    ld a, BANK(Gfx_20_70E0_Mode15_DrawTwoDigitsInterval) ; $4419
    ld bc, $0010                                  ; $441B
    call Vram_CopyFromBank                        ; $441E
    ret                                           ; $4421


; C: interval text in tile writes; BGB watchpoint pass 2026-10-25: ran only in mode 15 (18 hits in 6 runs: 15:05 x14
; 15:06 x4; tcrf_check/assets/mode_state_wp/)
Mode15_DrawIntervalText::
    and a                                         ; $4422
    jr nz, jr_006_4456                            ; $4423

    ld a, $76                                     ; $4425
    ld hl, $986c                                  ; $4427
    call Vram_WriteByteSafe                       ; $442A
    ld a, $77                                     ; $442D
    ld hl, $988c                                  ; $442F
    call Vram_WriteByteSafe                       ; $4432
    ld a, $78                                     ; $4435
    ld hl, $986d                                  ; $4437
    call Vram_WriteByteSafe                       ; $443A
    ld a, $79                                     ; $443D
    ld hl, $988d                                  ; $443F
    call Vram_WriteByteSafe                       ; $4442
    ld a, $ff                                     ; $4445
    ld hl, $988f                                  ; $4447
    call Vram_WriteByteSafe                       ; $444A
    ld a, $ff                                     ; $444D
    ld hl, $9890                                  ; $444F
    call Vram_WriteByteSafe                       ; $4452
    ret                                           ; $4455


jr_006_4456:
    cp $19                                        ; $4456
    jr nc, jr_006_448b                            ; $4458

    ld a, $68                                     ; $445A
    ld hl, $986c                                  ; $445C
    call Vram_WriteByteSafe                       ; $445F
    ld a, $69                                     ; $4462
    ld hl, $988c                                  ; $4464
    call Vram_WriteByteSafe                       ; $4467
    ld a, $6a                                     ; $446A
    ld hl, $986d                                  ; $446C
    call Vram_WriteByteSafe                       ; $446F
    ld a, $6b                                     ; $4472
    ld hl, $988d                                  ; $4474
    call Vram_WriteByteSafe                       ; $4477
    ld a, $72                                     ; $447A
    ld hl, $988f                                  ; $447C
    call Vram_WriteByteSafe                       ; $447F
    ld a, $73                                     ; $4482
    ld hl, $9890                                  ; $4484
    call Vram_WriteByteSafe                       ; $4487
    ret                                           ; $448A


jr_006_448b:
    ld a, $68                                     ; $448B
    ld hl, $986c                                  ; $448D
    call Vram_WriteByteSafe                       ; $4490
    ld a, $69                                     ; $4493
    ld hl, $988c                                  ; $4495
    call Vram_WriteByteSafe                       ; $4498
    ld a, $6a                                     ; $449B
    ld hl, $986d                                  ; $449D
    call Vram_WriteByteSafe                       ; $44A0
    ld a, $6b                                     ; $44A3
    ld hl, $988d                                  ; $44A5
    call Vram_WriteByteSafe                       ; $44A8
    ld a, $74                                     ; $44AB
    ld hl, $988f                                  ; $44AD
    call Vram_WriteByteSafe                       ; $44B0
    ld a, $75                                     ; $44B3
    ld hl, $9890                                  ; $44B5
    call Vram_WriteByteSafe                       ; $44B8
    ret                                           ; $44BB


; C: Left / Right (bit 5 / 4 of HL) steps A between B and C
Mode15_StepValue::
    bit 5, [hl]                                   ; $44BC
    jr z, jr_006_44cb                             ; $44BE

    cp b                                          ; $44C0
    ret z                                         ; $44C1

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $44C2
    dec a                                         ; $44C9
    ret                                           ; $44CA


jr_006_44cb:
    bit 4, [hl]                                   ; $44CB
    ret z                                         ; $44CD

    cp c                                          ; $44CE
    ret z                                         ; $44CF

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $44D0
    inc a                                         ; $44D7
    ret                                           ; $44D8


; C: mode 16: SHUTTERBUG menu (TRICK LENSES / MONTAGE / PANORAMA / GAME FACE)
Mode16_ShutterbugMagic::
    ld a, [wState]                                ; $44D9
    rst Rst18_JumpTable                           ; $44DC

; I: 10 states
Mode16_StateTable::
    dw Mode16_State00_Init
    dw Mode16_State01_Redraw
    dw Mode16_State02_MainMenu
    dw Mode16_State03_TrickLensesMenu
    dw Mode16_State04_MontageMenu
    dw Mode16_State05_PanoramaMenu
    dw Mode16_State06_GameFaceMenu
    dw Mode16_State07_LeaveToMode01
    dw Mode16_State08_StartShoot
    dw Mode16_State09_ToPanoramaPrint

; I
Mode16_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $44F1
    ldh [hLcdcShadow], a                          ; $44F3
    ld a, $e4                                     ; $44F5
    ld [wPaletteTarget], a                        ; $44F7
    ld [wPaletteTarget + $1], a                   ; $44FA
    ld a, $d2                                     ; $44FD
    ld [wPaletteTarget + $2], a                   ; $44FF
    xor a                                         ; $4502
    ldh [hScxShadow], a                           ; $4503
    ldh [hScyShadow], a                           ; $4505
    ld a, $0d                                     ; $4507
    ld hl, Gfx_0D_4000_Mode16_State00_Init        ; $4509
    ld de, $9000                                  ; $450C
    ld bc, $0800                                  ; $450F
    call Mem_CopyFromBank                         ; $4512
    farcopy Mem_CopyFromBank, Gfx_0D_4800_Mode16_State00_Init, $8800, $0800 ; $4515
    farcopy Mem_CopyFromBank, Gfx_0D_5000_Mode16_State00_Init, $8000, $0300 ; $4523
    farcopy Mem_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $4531
    screen_on                                     ; $453F
    play_music MUSIC_SHUTTERBUG                   ; $4548
    rst Rst08_WaitVBlank                          ; $454F
    ld a, [wOpt1Value]                            ; $4550
    ld hl, Mode16_TrickLensIconSrcTbl             ; $4553
    ld de, $9300                                  ; $4556
    call Mode16_LoadIconTiles                     ; $4559
    ld a, [wOpt2Value]                            ; $455C
    ld hl, Mode16_MontageIconSrcTbl               ; $455F
    ld de, $9400                                  ; $4562
    call Mode16_LoadIconTiles                     ; $4565
    call Pal_FadeIn                               ; $4568
    set_state STATE_16_MAIN_MENU                  ; $456B
    ret                                           ; $4570


; I
Mode16_State01_Redraw::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4571
    ldh [hLcdcShadow], a                          ; $4573
    ld a, $e4                                     ; $4575
    ld [wPaletteTarget], a                        ; $4577
    ld [wPaletteTarget + $1], a                   ; $457A
    ld a, $d2                                     ; $457D
    ld [wPaletteTarget + $2], a                   ; $457F
    xor a                                         ; $4582
    ldh [hScxShadow], a                           ; $4583
    ldh [hScyShadow], a                           ; $4585
    ld a, $0d                                     ; $4587
    ld hl, Gfx_0D_4000_Mode16_State00_Init        ; $4589
    ld de, $9000                                  ; $458C
    ld bc, $0800                                  ; $458F
    call Mem_CopyFromBank                         ; $4592
    farcopy Mem_CopyFromBank, Gfx_0D_4800_Mode16_State00_Init, $8800, $0800 ; $4595
    farcopy Mem_CopyFromBank, Gfx_0D_5000_Mode16_State00_Init, $8000, $0300 ; $45A3
    farcopy Mem_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $45B1
    screen_on                                     ; $45BF
    play_music MUSIC_SHUTTERBUG                   ; $45C8
    rst Rst08_WaitVBlank                          ; $45CF
    ld a, [wOpt1Value]                            ; $45D0
    ld hl, Mode16_TrickLensIconSrcTbl             ; $45D3
    ld de, $9300                                  ; $45D6
    call Mode16_LoadIconTiles                     ; $45D9
    ld a, [wOpt2Value]                            ; $45DC
    ld hl, Mode16_MontageIconSrcTbl               ; $45DF
    ld de, $9400                                  ; $45E2
    call Mode16_LoadIconTiles                     ; $45E5
    call Mode16_BuildOptionList                   ; $45E8
    ld a, [wOptMenuCursor]                        ; $45EB
    ld c, a                                       ; $45EE
    ld b, $00                                     ; $45EF
    ld hl, Mode16_RedrawStateTbl                  ; $45F1
    add hl, bc                                    ; $45F4
    ld a, [hl]                                    ; $45F5
    ld [wState], a                                ; $45F6
    call Pal_FadeIn                               ; $45F9
    ret                                           ; $45FC


; C: 4 bytes: menu item (wOptMenuCursor) -> state that Mode16_State01_Redraw (06:45F7) resumes after rebuilding the
; screen: 03 TRICK LENSES, 04 MONTAGE, 05 PANORAMA, 06 GAME FACE (read 2026-10-25)
Mode16_RedrawStateTbl::
    db $03, $04, $05, $06

; I
Mode16_State02_MainMenu::
    ld hl, wOptMenuCursor                         ; $4601
    ld c, $03                                     ; $4604
    call Mode16_StepRow                           ; $4606
    ld a, [wOptMenuCursor]                        ; $4609
    ld hl, Mode16_MenuCursorPosTbl                ; $460C
    call Mode16_DrawCursorFromTable               ; $460F
    ldh a, [hKeysNew]                             ; $4612
    bit PADB_A, a                                 ; $4614
    jr z, jr_006_4640                             ; $4616

    play_sfx1 SFX1_KEY_A                          ; $4618
    call Oam_ClearShadow                          ; $461F
    ld a, [wOptMenuCursor]                        ; $4622
    ld c, a                                       ; $4625
    ld b, $00                                     ; $4626
    ld hl, Mode16_ItemStateTbl                    ; $4628
    add hl, bc                                    ; $462B
    ld a, [hl]                                    ; $462C
    cp $22                                        ; $462D
    jr c, jr_006_4639                             ; $462F

    play_sfx1 SFX1_BEEP_REFUSED                   ; $4631
    ret                                           ; $4638


jr_006_4639:
    ld [wState], a                                ; $4639
    call Mode16_BuildOptionList                   ; $463C
    ret                                           ; $463F


jr_006_4640:
    bit 1, a                                      ; $4640
    ret z                                         ; $4642

    play_sfx1 SFX1_KEY_B                          ; $4643
    set_state STATE_16_LEAVE_TO_MODE01            ; $464A
    ret                                           ; $464F


; C: 4 bytes: menu item -> state of its sub-screen when A is pressed (03-06), read by Mode16_State02_MainMenu
; (06:4631); a value of $22 or more would be refused with sound $0B, none is (read 2026-10-25)
Mode16_ItemStateTbl::
    db $03, $04, $05, $06

; C: 4 x {y; x} of the cursor of the four MAGIC items: y = $4C / $5C / $6C / $7C, x = $30; Mode16_DrawCursorFromTable
; (06:4A70) from Mode16_State02_MainMenu (read 2026-10-25)
Mode16_MenuCursorPosTbl::
    db $4c, $30, $5c, $30, $6c, $30, $7c, $30

; C: option 1 (opt1_row / opt1_value); BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 03 (6460 hits in
; 14 runs: 16:03 x6460; tcrf_check/assets/mode_state_wp/)
Mode16_State03_TrickLensesMenu::
    call Mode16_DrawCaptionBlink                  ; $465C
    ld hl, wOpt1Row                               ; $465F
    ld c, $00                                     ; $4662
    call Mode16_StepRow                           ; $4664
    ld a, [wOpt1Row]                              ; $4667
    and a                                         ; $466A
    jr nz, jr_006_4681                            ; $466B

    ld hl, wOpt1Value                             ; $466D
    ld c, $08                                     ; $4670
    call Mode16_StepValue                         ; $4672
    ld a, [wOpt1Value]                            ; $4675
    ld hl, Mode16_TrickLensIconSrcTbl             ; $4678
    ld de, $9300                                  ; $467B
    call nz, Mode16_LoadIconTiles                 ; $467E

jr_006_4681:
    ld a, [wOpt1Row]                              ; $4681
    ld hl, Mode16_TrickLensRowPosTbl              ; $4684
    call Mode16_DrawCursorFromTable               ; $4687
    ld a, [wOpt1Value]                            ; $468A
    ld hl, Mode16_TrickLensIconTbl                ; $468D
    call Mode16_DrawIcon                          ; $4690
    ldh a, [hKeysNew]                             ; $4693
    bit PADB_A, a                                 ; $4695
    jr z, jr_006_46ac                             ; $4697

    play_sfx1 SFX1_KEY_A                          ; $4699
    ld a, [wOpt1Row]                              ; $46A0
    and a                                         ; $46A3
    jr nz, jr_006_46ab                            ; $46A4

    set_state STATE_16_START_SHOOT                ; $46A6

jr_006_46ab:
    ret                                           ; $46AB


jr_006_46ac:
    bit 1, a                                      ; $46AC
    ret z                                         ; $46AE

    play_sfx1 SFX1_KEY_B                          ; $46AF
    call Oam_ClearShadow                          ; $46B6
    rst Rst08_WaitVBlank                          ; $46B9
    farcopy Vram_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $46BA
    set_state STATE_16_MAIN_MENU                  ; $46C8
    ret                                           ; $46CD


; I: 3 x {y; x} of the row cursor of the TRICK LENSES sub-screen (y = $60 / $68 / $70, x = $37); only entry 0 is read
; because the row wOpt1Row never leaves 0 (Mode16_StepRow with C = 0) (read 2026-10-25)
Mode16_TrickLensRowPosTbl::
    db $60, $36, $68, $36, $70, $36

; I: 9 x {OAM list id; OAM list id or $FF} drawn at (x, y) = ($60, $60) by Mode16_DrawIcon (06:4AA3) for wOpt1Value
; 0-8, $FF = no second list (read 2026-10-25)
Mode16_TrickLensIconTbl::
    db $35, $ff, $36, $ff, $37, $ff, $38, $ff, $39, $ff, $3a, $ff, $3b, $ff, $3c, $ff
    db $3d, $ff

; C: 9 x {lo; hi; bank} = 0D:6000 6100 6300 6200 6400 6500 6600 6700 6800 (the Gfx_0D_*_Icon06_46EF rows):
; Mode16_LoadIconTiles (06:4B23) copies $100 B of the entry wOpt1Value to $9300; one table of 27 B (read 2026-10-25)
Mode16_TrickLensIconSrcTbl::
    dwb Gfx_0D_6000_Icon06_46E6
    dwb Gfx_0D_6100_Icon06_46E6
    dwb Gfx_0D_6300_Icon06_46E6
    dwb Gfx_0D_6200_Icon06_46E6
    dwb Gfx_0D_6400_Icon06_46E6
    dwb Gfx_0D_6500_Icon06_46E6
    dwb Gfx_0D_6600_Icon06_46E6
    dwb Gfx_0D_6700_Icon06_46E6
    dwb Gfx_0D_6800_Icon06_46E6

; C: option 2 (opt2_row / opt2_value); BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 04 (1914 hits in
; 4 runs: 16:04 x1914; tcrf_check/assets/mode_state_wp/)
Mode16_State04_MontageMenu::
    call Mode16_DrawCaptionBlink                  ; $4701
    ld hl, wOpt2Row                               ; $4704
    ld c, $00                                     ; $4707
    call Mode16_StepRow                           ; $4709
    ld a, [wOpt2Row]                              ; $470C
    and a                                         ; $470F
    jr nz, jr_006_4726                            ; $4710

    ld hl, wOpt2Value                             ; $4712
    ld c, $06                                     ; $4715
    call Mode16_StepValue                         ; $4717
    ld a, [wOpt2Value]                            ; $471A
    ld hl, Mode16_MontageIconSrcTbl               ; $471D
    ld de, $9400                                  ; $4720
    call nz, Mode16_LoadIconTiles                 ; $4723

jr_006_4726:
    ld a, [wOpt2Row]                              ; $4726
    ld hl, Mode16_MontageRowPosTbl                ; $4729
    call Mode16_DrawCursorFromTable               ; $472C
    ld a, [wOpt2Value]                            ; $472F
    ld hl, Mode16_MontageIconTbl                  ; $4732
    call Mode16_DrawIcon                          ; $4735
    ldh a, [hKeysNew]                             ; $4738
    bit PADB_A, a                                 ; $473A
    jr z, jr_006_4750                             ; $473C

    play_sfx1 SFX1_KEY_A                          ; $473E
    ld a, [wOpt2Row]                              ; $4745
    and a                                         ; $4748
    ret nz                                        ; $4749

    set_state STATE_16_START_SHOOT                ; $474A
    ret                                           ; $474F


jr_006_4750:
    bit 1, a                                      ; $4750
    ret z                                         ; $4752

    play_sfx1 SFX1_KEY_B                          ; $4753
    call Oam_ClearShadow                          ; $475A
    rst Rst08_WaitVBlank                          ; $475D
    farcopy Vram_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $475E
    set_state STATE_16_MAIN_MENU                  ; $476C
    ret                                           ; $4771


; I: 3 x {y; x} of the row cursor of the MONTAGE sub-screen (same bytes as Mode16_TrickLensRowPosTbl); only entry 0 is
; read, wOpt2Row never leaves 0 (read 2026-10-25)
Mode16_MontageRowPosTbl::
    db $60, $36, $68, $36, $70, $36

; I: 7 x {OAM list id; OAM list id or $FF} drawn by Mode16_DrawIcon for wOpt2Value 0-6 (read 2026-10-25)
Mode16_MontageIconTbl::
    db $35, $ff, $36, $ff, $37, $ff, $38, $ff, $39, $ff, $3a, $ff, $3b, $ff

; C: 7 x {lo; hi; bank} = 0D:6900-6F00 (the Gfx_0D_*_Icon06_478F rows): Mode16_LoadIconTiles copies $100 B of the
; entry wOpt2Value to $9400 (read 2026-10-25)
Mode16_MontageIconSrcTbl::
    dwb Gfx_0D_6900_Icon06_4786
    dwb Gfx_0D_6A00_Icon06_4786
    dwb Gfx_0D_6B00_Icon06_4786
    dwb Gfx_0D_6C00_Icon06_4786
    dwb Gfx_0D_6D00_Icon06_4786
    dwb Gfx_0D_6E00_Icon06_4786
    dwb Gfx_0D_6F00_Icon06_4786

; C: option 3 (two toggles); BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 05 (22910 hits in 13 runs:
; 16:05 x22910; tcrf_check/assets/mode_state_wp/)
Mode16_State05_PanoramaMenu::
    call Mode16_DrawPanoramaHint                  ; $479B
    ld hl, wOpt3Cursor                            ; $479E
    ld c, $01                                     ; $47A1
    call Mode16_StepRow                           ; $47A3
    ld a, [wOpt3Cursor]                           ; $47A6
    ld c, a                                       ; $47A9
    ld b, $00                                     ; $47AA
    ld hl, wOpt3ToggleA                           ; $47AC
    add hl, bc                                    ; $47AF
    ld c, $01                                     ; $47B0
    call Mode16_StepValue                         ; $47B2
    ld a, [wOpt3Cursor]                           ; $47B5
    ld hl, Mode16_PanoramaRowPosTbl               ; $47B8
    call Mode16_DrawCursorFromTable               ; $47BB
    call Mode16_DrawPanoramaToggles               ; $47BE
    ldh a, [hKeysNew]                             ; $47C1
    bit PADB_A, a                                 ; $47C3
    jr z, jr_006_47e0                             ; $47C5

    play_sfx1 SFX1_KEY_A                          ; $47C7
    ld a, [wOpt3Cursor]                           ; $47CE
    and a                                         ; $47D1
    jr nz, jr_006_47da                            ; $47D2

    set_state STATE_16_START_SHOOT                ; $47D4
    ret                                           ; $47D9


jr_006_47da:
    set_state STATE_16_TO_PANORAMA_PRINT          ; $47DA
    ret                                           ; $47DF


jr_006_47e0:
    bit 1, a                                      ; $47E0
    ret z                                         ; $47E2

    play_sfx1 SFX1_KEY_B                          ; $47E3
    call Oam_ClearShadow                          ; $47EA
    rst Rst08_WaitVBlank                          ; $47ED
    farcopy Vram_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $47EE
    set_state STATE_16_MAIN_MENU                  ; $47FC
    ret                                           ; $4801


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (11455 hits in 13 runs: 16:05 x11455;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawPanoramaHint::
    ldh a, [hFrameCounter]                        ; $4802
    bit 3, a                                      ; $4804
    jr z, jr_006_4819                             ; $4806

    ld a, $47                                     ; $4808
    ld bc, $6a60                                  ; $480A
    call Oam_AddMeta_B02_52BD                     ; $480D
    ld a, $47                                     ; $4810
    ld bc, $6a68                                  ; $4812
    call Oam_AddMeta_B02_52BD                     ; $4815
    ret                                           ; $4818


jr_006_4819:
    ld a, $48                                     ; $4819
    ld bc, $6a60                                  ; $481B
    call Oam_AddMeta_B02_52BD                     ; $481E
    ld a, $48                                     ; $4821
    ld bc, $6a68                                  ; $4823
    call Oam_AddMeta_B02_52BD                     ; $4826
    ret                                           ; $4829


; I: BGB watchpoint pass 2026-10-25: ran only in mode 16 (11455 hits in 13 runs: 16:05 x11455;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawPanoramaToggles::
    ld a, [wOpt3ToggleA]                          ; $482A
    xor $01                                       ; $482D
    add $33                                       ; $482F
    ld bc, $6a60                                  ; $4831
    call Oam_AddMeta_B02_52BD                     ; $4834
    ld a, [wOpt3ToggleB]                          ; $4837
    xor $01                                       ; $483A
    add $33                                       ; $483C
    ld bc, $6a68                                  ; $483E
    call Oam_AddMeta_B02_52BD                     ; $4841
    ldh a, [hFrameCounter]                        ; $4844
    bit 3, a                                      ; $4846
    ret z                                         ; $4848

    ld a, [wOpt3Cursor]                           ; $4849
    ld c, a                                       ; $484C
    ld b, $00                                     ; $484D
    ld hl, wOpt3ToggleA                           ; $484F
    add hl, bc                                    ; $4852
    ld a, [hl]                                    ; $4853
    and a                                         ; $4854
    jr z, jr_006_4860                             ; $4855

    ld bc, $8018                                  ; $4857
    ld a, $44                                     ; $485A
    call Oam_AddMeta_B02_52BD                     ; $485C
    ret                                           ; $485F


jr_006_4860:
    ld bc, $3818                                  ; $4860
    ld a, $43                                     ; $4863
    call Oam_AddMeta_B02_52BD                     ; $4865
    ret                                           ; $4868


; I: 4 x {y; x} of the row cursor of the PANORAMA sub-screen (y = $60 / $68 / $70 / $78, x = $37);
; Mode16_State05_PanoramaMenu (06:47C1) limits the row $D5E8 to 0-1, so entries 2-3 are not read by it (read
; 2026-10-25)
Mode16_PanoramaRowPosTbl::
    db $60, $36, $68, $36, $70, $36, $78, $36

; I: option 4: game or Game Face editor; BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 06 (6704 hits
; in 7 runs: 16:06 x6704; tcrf_check/assets/mode_state_wp/)
Mode16_State06_GameFaceMenu::
    ld hl, wOpt4Cursor                            ; $4871
    ld c, $02                                     ; $4874
    call Mode16_StepRow                           ; $4876
    ld a, [wOpt4Cursor]                           ; $4879
    ld hl, Mode16_GameFaceRowPosTbl               ; $487C
    call Mode16_DrawCursorFromTable               ; $487F
    ldh a, [hKeysNew]                             ; $4882
    bit PADB_A, a                                 ; $4884
    jr z, jr_006_48eb                             ; $4886

    play_sfx1 SFX1_KEY_A                          ; $4888
    ld a, [wOpt4Cursor]                           ; $488F
    and a                                         ; $4892
    jr nz, jr_006_489b                            ; $4893

    set_state STATE_16_START_SHOOT                ; $4895
    ret                                           ; $489A


jr_006_489b:
    cp $01                                        ; $489B
    jr nz, jr_006_48ba                            ; $489D

    screen_off                                    ; $489F
    ld a, $02                                     ; $48A5
    ld [wPickCharacter], a                        ; $48A7
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $48AA
    ld [wMode20Caller], a                         ; $48AC
    ld a, MODE_BALL                               ; $48AF
    ld [wMode], a                                 ; $48B1
    set_state STATE_20_GAME_SETUP                 ; $48B4
    ret                                           ; $48B9


jr_006_48ba:
    cp $02                                        ; $48BA
    ret nz                                        ; $48BC

    ldh [hFarcallAArg], a                         ; $48BD
    farcall GameFace_Load_Far                     ; $48BF
    ld a, [wGamefacePresent]                      ; $48C7
    and a                                         ; $48CA
    jr nz, jr_006_48d5                            ; $48CB

    play_sfx1 SFX1_BEEP_REFUSED                   ; $48CD
    ret                                           ; $48D4


jr_006_48d5:
    screen_off                                    ; $48D5
    ld a, $01                                     ; $48DB
    ld [wDoodleFromShutterbug], a                 ; $48DD
    ld a, MODE_DOODLE_MENU                        ; $48E0
    ld [wMode], a                                 ; $48E2
    set_state STATE_04_INIT                       ; $48E5
    ret                                           ; $48EA


jr_006_48eb:
    bit 1, a                                      ; $48EB
    ret z                                         ; $48ED

    play_sfx1 SFX1_KEY_B                          ; $48EE
    call Oam_ClearShadow                          ; $48F5
    rst Rst08_WaitVBlank                          ; $48F8
    farcopy Vram_CopyFromBank, Map_25_7160_Mode16_State00_Init, $9800, $0240 ; $48F9
    set_state STATE_16_MAIN_MENU                  ; $4907
    ret                                           ; $490C


; I: 3 x {y; x} of the row cursor of the GAME FACE page; row 2 (the hidden third choice) is reachable only while
; Select is held (06:487A, README 16.15) (read 2026-10-25)
Mode16_GameFaceRowPosTbl::
    db $60, $36, $68, $36, $70, $36

; C
Mode16_State07_LeaveToMode01::
    ld a, MODE_SHOOT_PARLOR                       ; $4913
    ld [wMode], a                                 ; $4915
    set_state STATE_01_INTRO                      ; $4918
    screen_off                                    ; $491D
    ret                                           ; $4923


; C: applies the options and goes to mode 14
Mode16_State08_StartShoot::
    ld a, MODE_SHOOT_LIVE_VIEW                    ; $4924
    ld [wMode], a                                 ; $4926
    set_state STATE_14_INIT                       ; $4929
    screen_off                                    ; $492E
    ld a, [wOptMenuCursor]                        ; $4934
    and a                                         ; $4937
    jr nz, jr_006_4941                            ; $4938

    ld a, [wOpt1Value]                            ; $493A
    add $03                                       ; $493D
    jr jr_006_495b                                ; $493F

jr_006_4941:
    cp $01                                        ; $4941
    jr nz, jr_006_494c                            ; $4943

    ld a, [wOpt2Value]                            ; $4945
    add $0c                                       ; $4948
    jr jr_006_495b                                ; $494A

jr_006_494c:
    cp $02                                        ; $494C
    jr nz, jr_006_4959                            ; $494E

    ld a, [wOpt3ToggleA]                          ; $4950
    xor $01                                       ; $4953
    add $13                                       ; $4955
    jr jr_006_495b                                ; $4957

jr_006_4959:
    ld a, $15                                     ; $4959

jr_006_495b:
    ld [wShootVariant], a                         ; $495B
    cp $15                                        ; $495E
    ret nz                                        ; $4960

    ldh [hFarcallAArg], a                         ; $4961
    farcall GameFace_Load_Far                     ; $4963
    ld a, [wGamefacePresent]                      ; $496B
    and a                                         ; $496E
    ret z                                         ; $496F

    ld a, $c6                                     ; $4970
    ld [wPaletteTarget + $2], a                   ; $4972
    farcopy Mem_CopyFromBank, Gfx_23_50C0_Mode16_State08_StartShoot, $8900, $0290 ; $4975
    farcopy Mem_CopyFromBank, Gfx_23_5350_Mode16_State08_StartShoot, $8600, $0140 ; $4983
    farcopy Mem_CopyFromBank, Map_26_6C00_Mode16_State08_StartShoot, $9800, $0240 ; $4991
    ld a, $00                                     ; $499F
    ld hl, wPhotoImage                            ; $49A1
    ld de, $9000                                  ; $49A4
    ld bc, $0800                                  ; $49A7
    call Mem_CopyFromBank                         ; $49AA
    ld a, $00                                     ; $49AD
    ld hl, wPhotoImage + $800                     ; $49AF
    ld de, $8800                                  ; $49B2
    ld bc, $0100                                  ; $49B5
    call Mem_CopyFromBank                         ; $49B8
    ld a, $00                                     ; $49BB
    ld hl, wPhotoImage + $900                     ; $49BD
    ld de, $8000                                  ; $49C0
    ld bc, $0500                                  ; $49C3
    call Mem_CopyFromBank                         ; $49C6
    ld a, $54                                     ; $49C9
    ldh [hLycShadowSplit1], a                     ; $49CB
    ldh [hSplit1Latch], a                         ; $49CD
    ld hl, hStatShadow                            ; $49CF
    set 6, [hl]                                   ; $49D2
    ld hl, rIE                                    ; $49D4
    set 1, [hl]                                   ; $49D7
    ld a, $01                                     ; $49D9
    ldh [hStatHandlerIndex], a                    ; $49DB
    screen_on                                     ; $49DD
    call Pal_FadeIn                               ; $49E6

jr_006_49e9:
    ldh a, [hFrameCounter]                        ; $49E9
    and $01                                       ; $49EB
    jr nz, jr_006_49fb                            ; $49ED

    call Rng_Next                                 ; $49EF
    ld [wJitterX], a                              ; $49F2
    call Rng_Next                                 ; $49F5
    ld [wJitterY], a                              ; $49F8

jr_006_49fb:
    ld a, [wJitterX]                              ; $49FB
    and $01                                       ; $49FE
    add $28                                       ; $4A00
    ld b, a                                       ; $4A02
    ld a, [wJitterY]                              ; $4A03
    and $01                                       ; $4A06
    add $48                                       ; $4A08
    ld c, a                                       ; $4A0A
    ld a, $5e                                     ; $4A0B
    call Oam_AddMeta_B02_52BD                     ; $4A0D
    call Oam_HideUnused                           ; $4A10
    rst Rst08_WaitVBlank                          ; $4A13
    ldh a, [hKeysNew]                             ; $4A14
    and PADF_A | PADF_B                           ; $4A16
    jr z, jr_006_49e9                             ; $4A18

    bit 0, a                                      ; $4A1A
    jr z, jr_006_4a27                             ; $4A1C

    play_sfx1 SFX1_KEY_A                          ; $4A1E
    jr jr_006_4a2e                                ; $4A25

jr_006_4a27:
    play_sfx1 SFX1_KEY_B                          ; $4A27

jr_006_4a2e:
    push af                                       ; $4A2E
    screen_off                                    ; $4A2F
    stat_irq_off                                  ; $4A35
    pop af                                        ; $4A3F
    bit 0, a                                      ; $4A40
    ret nz                                        ; $4A42

    ld a, MODE_SHUTTERBUG_MAGIC                   ; $4A43
    ld [wMode], a                                 ; $4A45
    set_state STATE_16_REDRAW                     ; $4A48
    ret                                           ; $4A4D


; C: mode 18
Mode16_State09_ToPanoramaPrint::
    ld a, MODE_PANORAMA_PRINT                     ; $4A4E
    ld [wMode], a                                 ; $4A50
    set_state STATE_18_INIT                       ; $4A53
    screen_off                                    ; $4A58
    ret                                           ; $4A5E


; C
Mode16_DrawCursorFromTable::
    sla a                                         ; $4A5F
    ld c, a                                       ; $4A61
    ld b, $00                                     ; $4A62
    add hl, bc                                    ; $4A64
    ld c, [hl]                                    ; $4A65
    inc hl                                        ; $4A66
    ld b, [hl]                                    ; $4A67
    ld a, [wCursorAnimFrame]                      ; $4A68
    and $03                                       ; $4A6B
    sla a                                         ; $4A6D
    ld e, a                                       ; $4A6F
    ld d, $00                                     ; $4A70
    ld hl, Mode16_CursorAnimTbl                   ; $4A72
    add hl, de                                    ; $4A75
    ld a, [hl+]                                   ; $4A76
    call Oam_AddMeta_B02_52BD                     ; $4A77
    ld a, [wCursorAnimTick]                       ; $4A7A
    cp [hl]                                       ; $4A7D
    jr c, jr_006_4a85                             ; $4A7E

    ld hl, wCursorAnimFrame                       ; $4A80
    inc [hl]                                      ; $4A83
    xor a                                         ; $4A84

jr_006_4a85:
    inc a                                         ; $4A85
    ld [wCursorAnimTick], a                       ; $4A86
    ret                                           ; $4A89


; C: 4 x {OAM list id; ticks} = $30, $31, $32, $31, 9 ticks each: the animated cursor of Mode16_DrawCursorFromTable,
; frame wCursorAnimFrame and 3, tick wCursorAnimTick (read 2026-10-25)
Mode16_CursorAnimTbl::
    db $30, $09, $31, $09, $32, $09, $31, $09

; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (8374 hits in 17 runs: 16:03 x6460 16:04 x1914;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawIcon::
    sla a                                         ; $4A92
    ld c, a                                       ; $4A94
    ld b, $00                                     ; $4A95
    add hl, bc                                    ; $4A97
    ld a, [hl+]                                   ; $4A98
    ld bc, $5960                                  ; $4A99
    cp $ff                                        ; $4A9C
    call nz, Oam_AddMeta_B02_52BD                 ; $4A9E
    ld a, [hl]                                    ; $4AA1
    ld bc, $5960                                  ; $4AA2
    cp $ff                                        ; $4AA5
    call nz, Oam_AddMeta_B02_52BD                 ; $4AA7
    ret                                           ; $4AAA


; C: Up / Down steps a row cursor (HL) up to C
Mode16_StepRow::
    ldh a, [hKeysNewRepeat]                       ; $4AAB
    ld b, a                                       ; $4AAD
    ld a, [hl]                                    ; $4AAE
    bit 6, b                                      ; $4AAF
    jr z, jr_006_4ab8                             ; $4AB1

    and a                                         ; $4AB3
    ret z                                         ; $4AB4

    dec a                                         ; $4AB5
    jr jr_006_4abe                                ; $4AB6

jr_006_4ab8:
    bit 7, b                                      ; $4AB8
    ret z                                         ; $4ABA

    cp c                                          ; $4ABB
    ret nc                                        ; $4ABC

    inc a                                         ; $4ABD

jr_006_4abe:
    cp [hl]                                       ; $4ABE
    ret z                                         ; $4ABF

    ld [hl], a                                    ; $4AC0
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4AC1
    ret                                           ; $4AC8


; I: Left / Right steps a value
Mode16_StepValue::
    ldh a, [hKeysNewRepeat]                       ; $4AC9
    ld b, a                                       ; $4ACB
    ld a, [hl]                                    ; $4ACC
    bit 5, b                                      ; $4ACD
    jr z, jr_006_4ad6                             ; $4ACF

    and a                                         ; $4AD1
    ret z                                         ; $4AD2

    dec a                                         ; $4AD3
    jr jr_006_4adc                                ; $4AD4

jr_006_4ad6:
    bit 4, b                                      ; $4AD6
    ret z                                         ; $4AD8

    cp c                                          ; $4AD9
    ret z                                         ; $4ADA

    inc a                                         ; $4ADB

jr_006_4adc:
    cp [hl]                                       ; $4ADC
    ret z                                         ; $4ADD

    ld [hl], a                                    ; $4ADE
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4ADF
    ret                                           ; $4AE6


    db $fa, $e3, $d5, $4f, $cb, $27, $81, $4f, $06, $00, $21, $06, $4b, $09, $4e, $23
    db $46, $23, $7e, $69, $60, $11, $00, $90, $01, $80, $02, $cd, $8d, $06, $c9

; C: 4 x {lo; hi; bank} = 0D:5A80 5800 5580 5300 (the Gfx_0D_*_Strip06_4B17 rows): Mode16_LoadPageTiles (06:4AF8)
; copies $280 B of the entry wOptMenuCursor to $9000 (read 2026-10-25)
Mode16_PageTilesSrcTbl::
    dwb Gfx_0D_5A80_Strip06_4B06
    dwb Gfx_0D_5800_Strip06_4B06
    dwb Gfx_0D_5580_Strip06_4B06
    dwb Gfx_0D_5300_Strip06_4B06

; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (172 hits in 24 runs: 16:00 x100 16:01 x56 16:03 x10 16:04
; x6; tcrf_check/assets/mode_state_wp/)
Mode16_LoadIconTiles::
    ld c, a                                       ; $4B12
    sla a                                         ; $4B13
    add c                                         ; $4B15
    ld c, a                                       ; $4B16
    ld b, $00                                     ; $4B17
    add hl, bc                                    ; $4B19
    ld c, [hl]                                    ; $4B1A
    inc hl                                        ; $4B1B
    ld b, [hl]                                    ; $4B1C
    inc hl                                        ; $4B1D
    ld a, [hl]                                    ; $4B1E
    ld l, c                                       ; $4B1F
    ld h, b                                       ; $4B20
    ld bc, $0100                                  ; $4B21
    call Vram_CopyFromBank                        ; $4B24
    ret                                           ; $4B27


; C: jumps through the list builders
Mode16_BuildOptionList::
    ld a, [wOptMenuCursor]                        ; $4B28
    ld c, a                                       ; $4B2B
    sla a                                         ; $4B2C
    add c                                         ; $4B2E
    ld c, a                                       ; $4B2F
    ld b, $00                                     ; $4B30
    ld hl, Mode16_OptionMapSrcTbl                 ; $4B32
    add hl, bc                                    ; $4B35
    ld c, [hl]                                    ; $4B36
    inc hl                                        ; $4B37
    ld b, [hl]                                    ; $4B38
    inc hl                                        ; $4B39
    ld a, [hl]                                    ; $4B3A
    ld l, c                                       ; $4B3B
    ld h, b                                       ; $4B3C
    ld de, $9820                                  ; $4B3D
    ld bc, $0220                                  ; $4B40
    call Vram_CopyFromBank                        ; $4B43
    ld a, [wOptMenuCursor]                        ; $4B46
    sla a                                         ; $4B49
    ld c, a                                       ; $4B4B
    ld b, $00                                     ; $4B4C
    ld hl, Mode16_BuilderTbl                      ; $4B4E
    add hl, bc                                    ; $4B51
    ld a, [hl+]                                   ; $4B52
    ld h, [hl]                                    ; $4B53
    ld l, a                                       ; $4B54
    jp hl                                         ; $4B55


; I: 4 x {lo; hi; bank} = 25:71A0, 25:50C0, 24:63A0, 25:5360 (Map_*_Mode16_OptionPage0-3): Mode16_BuildOptionList
; (06:4B43) copies $200 B of the entry wOptMenuCursor to $9840; far pointers to maps, not a map (read 2026-10-25)
Mode16_OptionMapSrcTbl::
    dw Map_25_6F20_Mode16_OptionPage0_HeadRows + $20
    db BANK(Map_25_6F20_Mode16_OptionPage0_HeadRows)
    dw Map_25_5080_Mode16_OptionPage1_HeadRows + $20
    db BANK(Map_25_5080_Mode16_OptionPage1_HeadRows)
    db $80, $63, $24, $40, $53, $25

; I: 4 code pointers
Mode16_BuilderTbl::
    dw Mode16_BuildList0
    dw Mode16_BuildList2
    dw Mode16_BuildList4
    dw Mode16_BuildList6

; C: nothing to build
Mode16_BuildList0::
    ret                                           ; $4B6A


; C: two rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (8 hits in 4 runs: 16:04 x8;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList2::
    ld bc, $0002                                  ; $4B6B
    call Wait_Frames                              ; $4B6E
    ld hl, Map_25_50C0_Mode16_OptionPage1 + $107  ; $4B71
    ld de, $9927                                  ; $4B74
    ld b, $02                                     ; $4B77

jr_006_4b79:
    push bc                                       ; $4B79
    push de                                       ; $4B7A
    push hl                                       ; $4B7B
    ld b, $03                                     ; $4B7C

jr_006_4b7e:
    push bc                                       ; $4B7E
    push de                                       ; $4B7F
    push hl                                       ; $4B80
    ld a, BANK(Map_25_50C0_Mode16_OptionPage1)    ; $4B81
    ld bc, $0008                                  ; $4B83
    call Vram_CopyFromBank                        ; $4B86
    pop hl                                        ; $4B89
    pop de                                        ; $4B8A
    pop bc                                        ; $4B8B
    ld a, e                                       ; $4B8C
    add $20                                       ; $4B8D
    ld e, a                                       ; $4B8F
    jr nc, jr_006_4b93                            ; $4B90

    inc d                                         ; $4B92

jr_006_4b93:
    ld a, l                                       ; $4B93
    add $20                                       ; $4B94
    ld l, a                                       ; $4B96
    jr nc, jr_006_4b9a                            ; $4B97

    inc h                                         ; $4B99

jr_006_4b9a:
    dec b                                         ; $4B9A
    jr nz, jr_006_4b7e                            ; $4B9B

    ld bc, $0002                                  ; $4B9D
    call Wait_Frames                              ; $4BA0
    pop hl                                        ; $4BA3
    pop de                                        ; $4BA4
    pop bc                                        ; $4BA5
    ld a, e                                       ; $4BA6
    sub $20                                       ; $4BA7
    ld e, a                                       ; $4BA9
    jr nc, jr_006_4bad                            ; $4BAA

    dec d                                         ; $4BAC

jr_006_4bad:
    dec b                                         ; $4BAD
    jr nz, jr_006_4b79                            ; $4BAE

    farcopy Vram_CopyFromBank, Map_25_52C0_Mode16_BuildList2, $9940, $0060 ; $4BB0
    ret                                           ; $4BBE


; C: four rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (34 hits in 13 runs: 16:01 x8 16:05 x26;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList4::
    ld bc, $0002                                  ; $4BBF
    call Wait_Frames                              ; $4BC2
    ld hl, Map_24_63A0_Mode16_OptionPage2 + $147  ; $4BC5
    ld de, $9967                                  ; $4BC8
    ld b, $04                                     ; $4BCB

jr_006_4bcd:
    push bc                                       ; $4BCD
    push de                                       ; $4BCE
    push hl                                       ; $4BCF
    ld b, $03                                     ; $4BD0

jr_006_4bd2:
    push bc                                       ; $4BD2
    push de                                       ; $4BD3
    push hl                                       ; $4BD4
    ld a, BANK(Map_24_63A0_Mode16_OptionPage2)    ; $4BD5
    ld bc, $0008                                  ; $4BD7
    call Vram_CopyFromBank                        ; $4BDA
    pop hl                                        ; $4BDD
    pop de                                        ; $4BDE
    pop bc                                        ; $4BDF
    ld a, e                                       ; $4BE0
    add $20                                       ; $4BE1
    ld e, a                                       ; $4BE3
    jr nc, jr_006_4be7                            ; $4BE4

    inc d                                         ; $4BE6

jr_006_4be7:
    ld a, l                                       ; $4BE7
    add $20                                       ; $4BE8
    ld l, a                                       ; $4BEA
    jr nc, jr_006_4bee                            ; $4BEB

    inc h                                         ; $4BED

jr_006_4bee:
    dec b                                         ; $4BEE
    jr nz, jr_006_4bd2                            ; $4BEF

    ld bc, $0002                                  ; $4BF1
    call Wait_Frames                              ; $4BF4
    pop hl                                        ; $4BF7
    pop de                                        ; $4BF8
    pop bc                                        ; $4BF9
    ld a, e                                       ; $4BFA
    sub $20                                       ; $4BFB
    ld e, a                                       ; $4BFD
    jr nc, jr_006_4c01                            ; $4BFE

    dec d                                         ; $4C00

jr_006_4c01:
    dec b                                         ; $4C01
    jr nz, jr_006_4bcd                            ; $4C02

    farcopy Vram_CopyFromBank, Map_24_65A0_Mode16_BuildList4, $9940, $0080 ; $4C04
    ret                                           ; $4C12


; C: six rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (38 hits in 7 runs: 16:01 x8 16:06 x30;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList6::
    ld bc, $0002                                  ; $4C13
    call Wait_Frames                              ; $4C16
    ld hl, Map_25_5360_Mode16_OptionPage3 + $187  ; $4C19
    ld de, $99a7                                  ; $4C1C
    ld b, $06                                     ; $4C1F

jr_006_4c21:
    push bc                                       ; $4C21
    push de                                       ; $4C22
    push hl                                       ; $4C23
    ld b, $02                                     ; $4C24

jr_006_4c26:
    push bc                                       ; $4C26
    push de                                       ; $4C27
    push hl                                       ; $4C28
    ld a, BANK(Map_25_5360_Mode16_OptionPage3)    ; $4C29
    ld bc, $0008                                  ; $4C2B
    call Vram_CopyFromBank                        ; $4C2E
    pop hl                                        ; $4C31
    pop de                                        ; $4C32
    pop bc                                        ; $4C33
    ld a, e                                       ; $4C34
    add $20                                       ; $4C35
    ld e, a                                       ; $4C37
    jr nc, jr_006_4c3b                            ; $4C38

    inc d                                         ; $4C3A

jr_006_4c3b:
    ld a, l                                       ; $4C3B
    add $20                                       ; $4C3C
    ld l, a                                       ; $4C3E
    jr nc, jr_006_4c42                            ; $4C3F

    inc h                                         ; $4C41

jr_006_4c42:
    dec b                                         ; $4C42
    jr nz, jr_006_4c26                            ; $4C43

    ld a, l                                       ; $4C45
    sub $60                                       ; $4C46
    ld l, a                                       ; $4C48
    jr nc, jr_006_4c4c                            ; $4C49

    dec h                                         ; $4C4B

jr_006_4c4c:
    ld a, $25                                     ; $4C4C
    ld bc, $0008                                  ; $4C4E
    call Vram_CopyFromBank                        ; $4C51
    ld bc, $0002                                  ; $4C54
    call Wait_Frames                              ; $4C57
    pop hl                                        ; $4C5A
    pop de                                        ; $4C5B
    pop bc                                        ; $4C5C
    ld a, e                                       ; $4C5D
    sub $20                                       ; $4C5E
    ld e, a                                       ; $4C60
    jr nc, jr_006_4c64                            ; $4C61

    dec d                                         ; $4C63

jr_006_4c64:
    dec b                                         ; $4C64
    jr nz, jr_006_4c21                            ; $4C65

    farcopy Vram_CopyFromBank, Map_25_5560_Mode16_BuildList6, $9960, $0060 ; $4C67
    ret                                           ; $4C75


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (4187 hits in 17 runs: 16:03 x3230 16:04 x957;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawCaptionBlink::
    ldh a, [hFrameCounter]                        ; $4C76
    bit 3, a                                      ; $4C78
    jr z, jr_006_4c85                             ; $4C7A

    ld a, $45                                     ; $4C7C
    ld bc, $5760                                  ; $4C7E
    call Oam_AddMeta_B02_52BD                     ; $4C81
    ret                                           ; $4C84


jr_006_4c85:
    ld a, $46                                     ; $4C85
    ld bc, $5760                                  ; $4C87
    call Oam_AddMeta_B02_52BD                     ; $4C8A
    ret                                           ; $4C8D


; C: mode 17: COMPOSE (SPLIT 4 pictures / FUSION 2 pictures)
Mode17_SplitFusion::
    ld a, [wState]                                ; $4C8E
    rst Rst18_JumpTable                           ; $4C91

; I: 20 states
Mode17_StateTable::
    dw Mode17_State00_Init
    dw Mode17_State01_LayoutChoose
    dw Mode17_State02_Split_Cursor
    dw Mode17_State03_Split_Pick1
    dw Mode17_State04_Split_Pick2
    dw Mode17_State05_Split_Pick3
    dw Mode17_State06_Split_Pick4
    dw Mode17_State07_Split_Confirm
    dw Mode17_State08_Split_Build
    dw Mode17_State09_Split_Result
    dw Mode17_State0A_Fusion_Cursor
    dw Mode17_State0B_Fusion_Pick1
    dw Mode17_State0C_Fusion_Pick2
    dw Mode17_State0D_Fusion_Confirm
    dw Mode17_State0E_Fusion_Build
    dw Mode17_State0F_Fusion_Result
    dw Mode17_State10_Leave
    dw Mode17_State11_ResultPrepare
    dw Mode17_State12_ResultScreen
    dw Mode17_State13_Restart

; C
Mode17_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4CBA
    ldh [hLcdcShadow], a                          ; $4CBC
    ld a, $e4                                     ; $4CBE
    ld [wPaletteTarget], a                        ; $4CC0
    ld [wPaletteTarget + $1], a                   ; $4CC3
    ld a, $c6                                     ; $4CC6
    ld [wPaletteTarget + $2], a                   ; $4CC8
    xor a                                         ; $4CCB
    ldh [hScxShadow], a                           ; $4CCC
    ldh [hScyShadow], a                           ; $4CCE
    farcopy Mem_CopyFromBank, Gfx_1E_5C00_Mode17_State00_Init, $9000, $0300 ; $4CD0
    farcopy Mem_CopyFromBank, Gfx_1E_5F00_Mode17_State00_Init, $8a80, $0580 ; $4CDE
    farcopy Mem_CopyFromBank, Gfx_1E_6480_Mode17_State00_Init, $8000, $0030 ; $4CEC
    farcopy Mem_CopyFromBank, Gfx_1E_6570_Mode17_State00_Init, $80f0, $0010 ; $4CFA
    farcopy Mem_CopyFromBank, Gfx_1E_6580_Mode17_State00_Init, $8040, $0010 ; $4D08
    farcopy Mem_CopyFromBank, Map_24_68E0_Mode17_State00_Init, $9800, $0240 ; $4D16
    ld de, $93c8                                  ; $4D24
    ld b, $04                                     ; $4D27

jr_006_4d29:
    ld hl, Gfx_1E_6590_Mode17_State00_Init_LowerHalves + $8 ; $4D29
    ld c, $04                                     ; $4D2C

jr_006_4d2e:
    push bc                                       ; $4D2E
    ld a, BANK(Gfx_1E_6590_Mode17_State00_Init_LowerHalves) ; $4D2F
    ld bc, $0008                                  ; $4D31
    call Mem_CopyFromBank                         ; $4D34
    pop bc                                        ; $4D37
    ld a, l                                       ; $4D38
    add $08                                       ; $4D39
    ld l, a                                       ; $4D3B
    jr nc, jr_006_4d3f                            ; $4D3C

    inc h                                         ; $4D3E

jr_006_4d3f:
    ld a, e                                       ; $4D3F
    add $08                                       ; $4D40
    ld e, a                                       ; $4D42
    jr nc, jr_006_4d46                            ; $4D43

    inc d                                         ; $4D45

jr_006_4d46:
    dec c                                         ; $4D46
    jr nz, jr_006_4d2e                            ; $4D47

    ld a, e                                       ; $4D49
    add $c0                                       ; $4D4A
    ld e, a                                       ; $4D4C
    jr nc, jr_006_4d50                            ; $4D4D

    inc d                                         ; $4D4F

jr_006_4d50:
    dec b                                         ; $4D50
    jr nz, jr_006_4d29                            ; $4D51

    screen_on                                     ; $4D53
    play_music MUSIC_COMPOSE                      ; $4D5C
    call Compose_DrawLayoutPreview                ; $4D63
    call Pal_FadeIn                               ; $4D66
    next_state                                    ; $4D69
    ret                                           ; $4D6D


; C
Compose_DrawLayoutPreview::
    ld a, [wComposeLayout]                        ; $4D6E
    and a                                         ; $4D71
    jr nz, jr_006_4db3                            ; $4D72

    ld a, [wCompose4Photos]                       ; $4D74
    ld de, $9300                                  ; $4D77
    call Compose_LoadPhotoThumb                   ; $4D7A
    ld a, [wCompose4Photos + $1]                  ; $4D7D
    ld de, $9400                                  ; $4D80
    call Compose_LoadPhotoThumb                   ; $4D83
    ld a, [wCompose4Photos + $2]                  ; $4D86
    ld de, $9500                                  ; $4D89
    call Compose_LoadPhotoThumb                   ; $4D8C
    ld a, [wCompose4Photos + $3]                  ; $4D8F
    ld de, $9600                                  ; $4D92
    call Compose_LoadPhotoThumb                   ; $4D95
    call Compose_LoadQuad0                        ; $4D98
    call Compose_LoadQuad1                        ; $4D9B
    call Compose_LoadQuad2                        ; $4D9E
    call Compose_LoadQuad3                        ; $4DA1
    farcopy Vram_CopyFromBank, Map_24_6A20_Compose_DrawLayoutPreview, $9940, $0080 ; $4DA4
    ret                                           ; $4DB2


jr_006_4db3:
    ld a, [wCompose2Photos]                       ; $4DB3
    ld de, $9300                                  ; $4DB6
    call Compose_LoadPhotoThumb                   ; $4DB9
    ld a, [wCompose2Photos + $1]                  ; $4DBC
    ld de, $9500                                  ; $4DBF
    call Compose_LoadPhotoThumb                   ; $4DC2
    call Compose_LoadHalf0                        ; $4DC5
    call Compose_LoadHalf1                        ; $4DC8
    farcopy Vram_CopyFromBank, Map_24_6B20_Compose_DrawLayoutPreview, $9940, $0080 ; $4DCB
    ret                                           ; $4DD9


; C: Left = SPLIT (4); Right = FUSION (2)
Mode17_State01_LayoutChoose::
    call Compose_ReadLayoutKeys                   ; $4DDA
    call Compose_DrawLayoutBlink                  ; $4DDD
    ldh a, [hKeysNew]                             ; $4DE0
    ld b, a                                       ; $4DE2
    and PADF_A | PADF_DOWN                        ; $4DE3
    jr z, jr_006_4e03                             ; $4DE5

    play_sfx1 SFX1_MENU_CHOOSE                    ; $4DE7
    call Compose_DrawLayoutPreview                ; $4DEE
    ld a, [wComposeLayout]                        ; $4DF1
    and a                                         ; $4DF4
    jr nz, jr_006_4dfd                            ; $4DF5

    set_state STATE_17_SPLIT_CURSOR               ; $4DF7
    ret                                           ; $4DFC


jr_006_4dfd:
    set_state STATE_17_FUSION_CURSOR              ; $4DFD
    ret                                           ; $4E02


jr_006_4e03:
    bit 1, b                                      ; $4E03
    ret z                                         ; $4E05

    play_sfx1 SFX1_KEY_B                          ; $4E06
    set_state STATE_17_LEAVE                      ; $4E0D
    ret                                           ; $4E12


; C
Compose_ReadLayoutKeys::
    ldh a, [hKeysNew]                             ; $4E13
    bit PADB_LEFT, a                              ; $4E15
    jr z, jr_006_4e1c                             ; $4E17

    xor a                                         ; $4E19
    jr jr_006_4e21                                ; $4E1A

jr_006_4e1c:
    bit 4, a                                      ; $4E1C
    ret z                                         ; $4E1E

    ld a, $01                                     ; $4E1F

jr_006_4e21:
    ld hl, wComposeLayout                         ; $4E21
    cp [hl]                                       ; $4E24
    ret z                                         ; $4E25

    ld [hl], a                                    ; $4E26
    play_sfx1 SFX1_COMPOSE_LAYOUT_KEY             ; $4E27
    ret                                           ; $4E2E


; C: L3 pass 2026-10-26: executed in BGB in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawLayoutBlink::
    ldh a, [hFrameCounter]                        ; $4E2F
    bit 4, a                                      ; $4E31
    ret z                                         ; $4E33

; C
Compose_DrawLayoutCursor::
    ld a, [wComposeLayout]                        ; $4E34
    ld c, a                                       ; $4E37
    sla a                                         ; $4E38
    add c                                         ; $4E3A
    ld c, a                                       ; $4E3B
    ld b, $00                                     ; $4E3C
    ld hl, Compose_DrawLayoutCursor_Tbl4E4B       ; $4E3E
    add hl, bc                                    ; $4E41
    ld c, [hl]                                    ; $4E42
    inc hl                                        ; $4E43
    ld b, [hl]                                    ; $4E44
    inc hl                                        ; $4E45
    ld a, [hl]                                    ; $4E46
    call Oam_AddMeta_B02_52BD                     ; $4E47
    ret                                           ; $4E4A


; C: auto: 6 bytes, bytes; referenced by Compose_DrawLayoutCursor. L3 pass 2026-10-26: read in BGB in 19 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawLayoutCursor_Tbl4E4B::
    db $10, $10, $4c, $10, $60, $4d

; C: four-picture layout: pick a quadrant
Mode17_State02_Split_Cursor::
    call Compose_DrawLayoutCursor                 ; $4E51
    ldh a, [hKeysNew]                             ; $4E54
    bit PADB_DOWN, a                              ; $4E56
    jr z, jr_006_4e6e                             ; $4E58

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4E5A
    ld a, [wCompose4Cursor]                       ; $4E61
    bit 0, a                                      ; $4E64
    jr z, jr_006_4e6e                             ; $4E66

    set_state STATE_17_SPLIT_CONFIRM              ; $4E68
    ret                                           ; $4E6D


jr_006_4e6e:
    ldh a, [hKeysNew]                             ; $4E6E
    bit PADB_UP, a                                ; $4E70
    jr z, jr_006_4e88                             ; $4E72

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4E74
    ld a, [wCompose4Cursor]                       ; $4E7B
    bit 0, a                                      ; $4E7E
    jr nz, jr_006_4e88                            ; $4E80

    set_state STATE_17_LAYOUT_CHOOSE              ; $4E82
    ret                                           ; $4E87


jr_006_4e88:
    call Compose_Split_ReadKeys                   ; $4E88
    call Compose_Split_DrawCursor                 ; $4E8B
    ldh a, [hKeysNew]                             ; $4E8E
    bit PADB_A, a                                 ; $4E90
    jr z, jr_006_4eb8                             ; $4E92

    play_sfx1 SFX1_KEY_A                          ; $4E94
    ld a, [wCompose4Cursor]                       ; $4E9B
    ld c, a                                       ; $4E9E
    ld b, $00                                     ; $4E9F
    ld hl, wCompose4Photos                        ; $4EA1
    add hl, bc                                    ; $4EA4
    ld a, [hl]                                    ; $4EA5
    call Compose_DrawPhotoNumber                  ; $4EA6
    ld a, [wCompose4Cursor]                       ; $4EA9
    ld c, a                                       ; $4EAC
    ld b, $00                                     ; $4EAD
    ld hl, Mode17_State02_Split_Cursor_Tbl4EC8    ; $4EAF
    add hl, bc                                    ; $4EB2
    ld a, [hl]                                    ; $4EB3
    ld [wState], a                                ; $4EB4
    ret                                           ; $4EB7


jr_006_4eb8:
    bit 1, a                                      ; $4EB8
    ret z                                         ; $4EBA

    play_sfx1 SFX1_KEY_B                          ; $4EBB
    set_state STATE_17_LEAVE                      ; $4EC2
    ret                                           ; $4EC7


; C: auto: 4 bytes, bytes; referenced by Mode17_State02_Split_Cursor. L3 pass 2026-10-26: read in BGB in 16 replay(s)
; of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State02_Split_Cursor_Tbl4EC8::
    db $03, $04, $05, $06

; C
Compose_Split_ReadKeys::
    ldh a, [hKeysNew]                             ; $4ECC
    ld b, a                                       ; $4ECE
    ld a, [wCompose4Cursor]                       ; $4ECF
    bit 5, b                                      ; $4ED2
    jr z, jr_006_4ee4                             ; $4ED4

    bit 1, a                                      ; $4ED6
    ret z                                         ; $4ED8

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4ED9
    res 1, a                                      ; $4EE0
    jr jr_006_4f17                                ; $4EE2

jr_006_4ee4:
    bit 4, b                                      ; $4EE4
    jr z, jr_006_4ef6                             ; $4EE6

    bit 1, a                                      ; $4EE8
    ret nz                                        ; $4EEA

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4EEB
    set 1, a                                      ; $4EF2
    jr jr_006_4f17                                ; $4EF4

jr_006_4ef6:
    bit 6, b                                      ; $4EF6
    jr z, jr_006_4f08                             ; $4EF8

    bit 0, a                                      ; $4EFA
    ret z                                         ; $4EFC

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4EFD
    res 0, a                                      ; $4F04
    jr jr_006_4f17                                ; $4F06

jr_006_4f08:
    bit 7, b                                      ; $4F08
    ret z                                         ; $4F0A

    bit 0, a                                      ; $4F0B
    ret nz                                        ; $4F0D

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4F0E
    set 0, a                                      ; $4F15

jr_006_4f17:
    ld [wCompose4Cursor], a                       ; $4F17
    ret                                           ; $4F1A


; C
Compose_Split_DrawCursor::
    ld a, [wCompose4Cursor]                       ; $4F1B
    sla a                                         ; $4F1E
    ld c, a                                       ; $4F20
    ld b, $00                                     ; $4F21
    ld hl, Compose_Split_DrawCursor_Tbl4F3A       ; $4F23
    add hl, bc                                    ; $4F26
    ld c, [hl]                                    ; $4F27
    inc hl                                        ; $4F28
    ld b, [hl]                                    ; $4F29
    ldh a, [hFrameCounter]                        ; $4F2A
    srl a                                         ; $4F2C
    srl a                                         ; $4F2E
    srl a                                         ; $4F30
    and $01                                       ; $4F32
    add $52                                       ; $4F34
    call Oam_AddMeta_B02_52BD                     ; $4F36
    ret                                           ; $4F39


; C: auto: 8 bytes, bytes; referenced by Compose_Split_DrawCursor. L3 pass 2026-10-26: read in BGB in 18 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Split_DrawCursor_Tbl4F3A::
    db $28, $08, $50, $08, $28, $78, $50, $78

; C: choose the picture of quadrant 1
Mode17_State03_Split_Pick1::
    call Compose_DrawLayoutCursor                 ; $4F42
    ld a, [wCompose4Photos]                       ; $4F45
    call Compose_StepPhoto                        ; $4F48
    ld hl, wCompose4Photos                        ; $4F4B
    cp [hl]                                       ; $4F4E
    ld [hl], a                                    ; $4F4F
    jr z, jr_006_4f5b                             ; $4F50

    call Compose_DrawPhotoNumber                  ; $4F52
    ld de, $9300                                  ; $4F55
    call Compose_LoadPhotoThumb                   ; $4F58

jr_006_4f5b:
    ld bc, $102a                                  ; $4F5B
    ld hl, Mode17_State03_Split_Pick1_PtrTbl4F79  ; $4F5E
    call Compose_DrawPhotoCursor                  ; $4F61
    ldh a, [hKeysHeld]                            ; $4F64
    bit PADB_A, a                                 ; $4F66
    ret nz                                        ; $4F68

    play_sfx1 SFX1_KEY_B                          ; $4F69
    call Compose_LoadQuad0                        ; $4F70
    set_state STATE_17_SPLIT_CURSOR               ; $4F73
    ret                                           ; $4F78


; C: auto: 4 bytes, word table; referenced by Mode17_State03_Split_Pick1. L3 pass 2026-10-26: read in BGB in 16
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State03_Split_Pick1_PtrTbl4F79::
    dw $4a49
    dw $4a4b

; C
Mode17_State04_Split_Pick2::
    call Compose_DrawLayoutCursor                 ; $4F7D
    ld a, [wCompose4Photos + $1]                  ; $4F80
    call Compose_StepPhoto                        ; $4F83
    ld hl, wCompose4Photos + $1                   ; $4F86
    cp [hl]                                       ; $4F89
    ld [hl], a                                    ; $4F8A
    jr z, jr_006_4f96                             ; $4F8B

    call Compose_DrawPhotoNumber                  ; $4F8D
    ld de, $9400                                  ; $4F90
    call Compose_LoadPhotoThumb                   ; $4F93

jr_006_4f96:
    ld bc, $1052                                  ; $4F96
    ld hl, Mode17_State04_Split_Pick2_PtrTbl4FB4  ; $4F99
    call Compose_DrawPhotoCursor                  ; $4F9C
    ldh a, [hKeysHeld]                            ; $4F9F
    bit PADB_A, a                                 ; $4FA1
    ret nz                                        ; $4FA3

    play_sfx1 SFX1_KEY_B                          ; $4FA4
    call Compose_LoadQuad1                        ; $4FAB
    set_state STATE_17_SPLIT_CURSOR               ; $4FAE
    ret                                           ; $4FB3


; C: auto: 4 bytes, word table; referenced by Mode17_State04_Split_Pick2. L3 pass 2026-10-26: read in BGB in 2
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State04_Split_Pick2_PtrTbl4FB4::
    dw $4a49
    dw $4a4b

; C
Mode17_State05_Split_Pick3::
    call Compose_DrawLayoutCursor                 ; $4FB8
    ld a, [wCompose4Photos + $2]                  ; $4FBB
    call Compose_StepPhoto                        ; $4FBE
    ld hl, wCompose4Photos + $2                   ; $4FC1
    cp [hl]                                       ; $4FC4
    ld [hl], a                                    ; $4FC5
    jr z, jr_006_4fd1                             ; $4FC6

    call Compose_DrawPhotoNumber                  ; $4FC8
    ld de, $9500                                  ; $4FCB
    call Compose_LoadPhotoThumb                   ; $4FCE

jr_006_4fd1:
    ld bc, $902a                                  ; $4FD1
    ld hl, Mode17_State05_Split_Pick3_PtrTbl4FEF  ; $4FD4
    call Compose_DrawPhotoCursor                  ; $4FD7
    ldh a, [hKeysHeld]                            ; $4FDA
    bit PADB_A, a                                 ; $4FDC
    ret nz                                        ; $4FDE

    play_sfx1 SFX1_KEY_B                          ; $4FDF
    call Compose_LoadQuad2                        ; $4FE6
    set_state STATE_17_SPLIT_CURSOR               ; $4FE9
    ret                                           ; $4FEE


; C: auto: 4 bytes, word table; referenced by Mode17_State05_Split_Pick3. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State05_Split_Pick3_PtrTbl4FEF::
    dw $504f
    dw $5051

; C
Mode17_State06_Split_Pick4::
    call Compose_DrawLayoutCursor                 ; $4FF3
    ld a, [wCompose4Photos + $3]                  ; $4FF6
    call Compose_StepPhoto                        ; $4FF9
    ld hl, wCompose4Photos + $3                   ; $4FFC
    cp [hl]                                       ; $4FFF
    ld [hl], a                                    ; $5000
    jr z, jr_006_500c                             ; $5001

    call Compose_DrawPhotoNumber                  ; $5003
    ld de, $9600                                  ; $5006
    call Compose_LoadPhotoThumb                   ; $5009

jr_006_500c:
    ld bc, $9052                                  ; $500C
    ld hl, Mode17_State06_Split_Pick4_PtrTbl502A  ; $500F
    call Compose_DrawPhotoCursor                  ; $5012
    ldh a, [hKeysHeld]                            ; $5015
    bit PADB_A, a                                 ; $5017
    ret nz                                        ; $5019

    play_sfx1 SFX1_KEY_B                          ; $501A
    call Compose_LoadQuad3                        ; $5021
    set_state STATE_17_SPLIT_CURSOR               ; $5024
    ret                                           ; $5029


; C: auto: 4 bytes, word table; referenced by Mode17_State06_Split_Pick4. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State06_Split_Pick4_PtrTbl502A::
    dw $504f
    dw $5051

; C: Up: make the composite
Mode17_State07_Split_Confirm::
    call Compose_DrawLayoutCursor                 ; $502E
    call Compose_Split_DrawMakeBlink              ; $5031
    ldh a, [hKeysNew]                             ; $5034
    bit PADB_UP, a                                ; $5036
    jr z, jr_006_5047                             ; $5038

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $503A
    set_state STATE_17_SPLIT_CURSOR               ; $5041
    ret                                           ; $5046


jr_006_5047:
    bit 0, a                                      ; $5047
    jr z, jr_006_5065                             ; $5049

    ld a, [wPhotoCount]                           ; $504B
    cp $1e                                        ; $504E
    jr nc, jr_006_505f                            ; $5050

    play_sfx1 SFX1_CHOOSE                         ; $5052
    set_state STATE_17_SPLIT_BUILD                ; $5059
    ret                                           ; $505E


jr_006_505f:
    set_state STATE_17_RESULT_PREPARE             ; $505F
    ret                                           ; $5064


jr_006_5065:
    bit 1, a                                      ; $5065
    ret z                                         ; $5067

    play_sfx1 SFX1_KEY_B                          ; $5068
    set_state STATE_17_LEAVE                      ; $506F
    ret                                           ; $5074


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Split_DrawMakeBlink::
    ldh a, [hFrameCounter]                        ; $5075
    bit 4, a                                      ; $5077
    ret z                                         ; $5079

    ld bc, $3878                                  ; $507A
    ld a, $4e                                     ; $507D
    call Oam_AddMeta_B02_52BD                     ; $507F
    ret                                           ; $5082


; I: reduces the four pictures into the 2x2 composite
Mode17_State08_Split_Build::
    screen_off                                    ; $5083
    ld a, $d2                                     ; $5089
    ld [wPaletteTarget + $2], a                   ; $508B
    ld hl, $8000                                  ; $508E
    ld bc, $0500                                  ; $5091
    call Mem_Zero                                 ; $5094
    ld hl, $8800                                  ; $5097
    ld bc, $0100                                  ; $509A
    call Mem_Zero                                 ; $509D
    ld hl, $9000                                  ; $50A0
    ld bc, $0800                                  ; $50A3
    call Mem_Zero                                 ; $50A6
    farcopy Mem_CopyFromBank, Map_20_7542_Mode17_State08_Split_Build, $9800, $02c0 ; $50A9
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $50B7
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $50C5
    ld a, $54                                     ; $50D3
    ldh [hLycShadowSplit1], a                     ; $50D5
    ldh [hSplit1Latch], a                         ; $50D7
    ld hl, hStatShadow                            ; $50D9
    set 6, [hl]                                   ; $50DC
    ld hl, rIE                                    ; $50DE
    set 1, [hl]                                   ; $50E1
    ld a, $01                                     ; $50E3
    ldh [hStatHandlerIndex], a                    ; $50E5
    call Oam_ClearShadow                          ; $50E7
    call Lcd_On                                   ; $50EA
    call Pal_FadeIn                               ; $50ED
    call Compose_BuildSplit                       ; $50F0
    call Compose_DrawFreeCount                    ; $50F3
    next_state                                    ; $50F6
    ret                                           ; $50FA


; C: A: save the picture; B: cancel
Mode17_State09_Split_Result::
    call Compose_DrawJitter                       ; $50FB
    ldh a, [hKeysNew]                             ; $50FE
    and PADF_A | PADF_B                           ; $5100
    ret z                                         ; $5102

    bit 0, a                                      ; $5103
    jr z, jr_006_5144                             ; $5105

    ld a, $00                                     ; $5107
    ld hl, $9000                                  ; $5109
    ld de, wPhotoImage                            ; $510C
    ld bc, $0800                                  ; $510F
    call Vram_CopyFromBank_4                      ; $5112
    ld a, $00                                     ; $5115
    ld hl, $8800                                  ; $5117
    ld de, wPhotoImage + $800                     ; $511A
    ld bc, $0100                                  ; $511D
    call Vram_CopyFromBank_4                      ; $5120
    ld a, $00                                     ; $5123
    ld hl, $8000                                  ; $5125
    ld de, wPhotoImage + $900                     ; $5128
    ld bc, $0500                                  ; $512B
    call Vram_CopyFromBank_4                      ; $512E
    ldh [hFarcallAArg], a                         ; $5131
    farcall Photo_SaveShot_Far                    ; $5133
    call Snd_PlayTagDigits                        ; $513B
    ld bc, $003c                                  ; $513E
    call Wait_Frames                              ; $5141

jr_006_5144:
    play_sfx1 SFX1_KEY_B                          ; $5144
    screen_off                                    ; $514B
    stat_irq_off                                  ; $5151
    set_state STATE_17_INIT                       ; $515B
    ret                                           ; $5160


; C: two-picture layout
Mode17_State0A_Fusion_Cursor::
    call Compose_DrawLayoutCursor                 ; $5161
    ldh a, [hKeysNew]                             ; $5164
    bit PADB_DOWN, a                              ; $5166
    jr z, jr_006_5177                             ; $5168

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $516A
    set_state STATE_17_FUSION_CONFIRM             ; $5171
    ret                                           ; $5176


jr_006_5177:
    ldh a, [hKeysNew]                             ; $5177
    bit PADB_UP, a                                ; $5179
    jr z, jr_006_518a                             ; $517B

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $517D
    set_state STATE_17_LAYOUT_CHOOSE              ; $5184
    ret                                           ; $5189


jr_006_518a:
    call Compose_Fusion_ReadKeys                  ; $518A
    call Compose_Fusion_DrawCursor                ; $518D
    ldh a, [hKeysNew]                             ; $5190
    bit PADB_A, a                                 ; $5192
    jr z, jr_006_51ba                             ; $5194

    play_sfx1 SFX1_KEY_A                          ; $5196
    ld a, [wCompose2Cursor]                       ; $519D
    ld c, a                                       ; $51A0
    ld b, $00                                     ; $51A1
    ld hl, wCompose2Photos                        ; $51A3
    add hl, bc                                    ; $51A6
    ld a, [hl]                                    ; $51A7
    call Compose_DrawPhotoNumber                  ; $51A8
    ld a, [wCompose2Cursor]                       ; $51AB
    ld c, a                                       ; $51AE
    ld b, $00                                     ; $51AF
    ld hl, Mode17_State0A_Fusion_Cursor_Tbl51CA   ; $51B1
    add hl, bc                                    ; $51B4
    ld a, [hl]                                    ; $51B5
    ld [wState], a                                ; $51B6
    ret                                           ; $51B9


jr_006_51ba:
    bit 1, a                                      ; $51BA
    ret z                                         ; $51BC

    play_sfx1 SFX1_KEY_B                          ; $51BD
    set_state STATE_17_LEAVE                      ; $51C4
    ret                                           ; $51C9


; C: auto: 2 bytes, bytes; referenced by Mode17_State0A_Fusion_Cursor. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State0A_Fusion_Cursor_Tbl51CA::
    dw $0c0b

; C
Compose_Fusion_ReadKeys::
    ldh a, [hKeysNew]                             ; $51CC
    ld b, a                                       ; $51CE
    ld a, [wCompose2Cursor]                       ; $51CF
    bit 5, b                                      ; $51D2
    jr z, jr_006_51e4                             ; $51D4

    bit 0, a                                      ; $51D6
    ret z                                         ; $51D8

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $51D9
    res 0, a                                      ; $51E0
    jr jr_006_51f3                                ; $51E2

jr_006_51e4:
    bit 4, b                                      ; $51E4
    ret z                                         ; $51E6

    bit 0, a                                      ; $51E7
    ret nz                                        ; $51E9

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $51EA
    set 0, a                                      ; $51F1

jr_006_51f3:
    ld [wCompose2Cursor], a                       ; $51F3
    ret                                           ; $51F6


; C
Compose_Fusion_DrawCursor::
    ld a, [wCompose2Cursor]                       ; $51F7
    sla a                                         ; $51FA
    ld c, a                                       ; $51FC
    ld b, $00                                     ; $51FD
    ld hl, Compose_Fusion_DrawCursor_Tbl5216      ; $51FF
    add hl, bc                                    ; $5202
    ld c, [hl]                                    ; $5203
    inc hl                                        ; $5204
    ld b, [hl]                                    ; $5205
    ldh a, [hFrameCounter]                        ; $5206
    srl a                                         ; $5208
    srl a                                         ; $520A
    srl a                                         ; $520C
    and $01                                       ; $520E
    add $52                                       ; $5210
    call Oam_AddMeta_B02_52BD                     ; $5212
    ret                                           ; $5215


; C: auto: 4 bytes, bytes; referenced by Compose_Fusion_DrawCursor. L3 pass 2026-10-26: read in BGB in 4 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Fusion_DrawCursor_Tbl5216::
    db $28, $08, $28, $78

; C
Mode17_State0B_Fusion_Pick1::
    call Compose_DrawLayoutCursor                 ; $521A
    ld a, [wCompose2Photos]                       ; $521D
    call Compose_StepPhoto                        ; $5220
    ld hl, wCompose2Photos                        ; $5223
    cp [hl]                                       ; $5226
    ld [hl], a                                    ; $5227
    jr z, jr_006_5233                             ; $5228

    call Compose_DrawPhotoNumber                  ; $522A
    ld de, $9300                                  ; $522D
    call Compose_LoadPhotoThumb                   ; $5230

jr_006_5233:
    ld bc, $102a                                  ; $5233
    ld hl, Mode17_State0B_Fusion_Pick1_PtrTbl5251 ; $5236
    call Compose_DrawPhotoCursor                  ; $5239
    ldh a, [hKeysHeld]                            ; $523C
    bit PADB_A, a                                 ; $523E
    ret nz                                        ; $5240

    play_sfx1 SFX1_KEY_B                          ; $5241
    call Compose_LoadHalf0                        ; $5248
    set_state STATE_17_FUSION_CURSOR              ; $524B
    ret                                           ; $5250


; C: auto: 4 bytes, word table; referenced by Mode17_State0B_Fusion_Pick1. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State0B_Fusion_Pick1_PtrTbl5251::
    dw $4a49
    dw $4a4b

; C
Mode17_State0C_Fusion_Pick2::
    call Compose_DrawLayoutCursor                 ; $5255
    ld a, [wCompose2Photos + $1]                  ; $5258
    call Compose_StepPhoto                        ; $525B
    ld hl, wCompose2Photos + $1                   ; $525E
    cp [hl]                                       ; $5261
    ld [hl], a                                    ; $5262
    jr z, jr_006_526e                             ; $5263

    call Compose_DrawPhotoNumber                  ; $5265
    ld de, $9500                                  ; $5268
    call Compose_LoadPhotoThumb                   ; $526B

jr_006_526e:
    ld bc, $902a                                  ; $526E
    ld hl, Mode17_State0C_Fusion_Pick2_PtrTbl528C ; $5271
    call Compose_DrawPhotoCursor                  ; $5274
    ldh a, [hKeysHeld]                            ; $5277
    bit PADB_A, a                                 ; $5279
    ret nz                                        ; $527B

    play_sfx1 SFX1_KEY_B                          ; $527C
    call Compose_LoadHalf1                        ; $5283
    set_state STATE_17_FUSION_CURSOR              ; $5286
    ret                                           ; $528B


; C: auto: 4 bytes, word table; referenced by Mode17_State0C_Fusion_Pick2. L3 pass 2026-10-26: not reached by the 206
; BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in
; mode 17)
Mode17_State0C_Fusion_Pick2_PtrTbl528C::
    dw $504f
    dw $5051

; C
Mode17_State0D_Fusion_Confirm::
    call Compose_DrawLayoutCursor                 ; $5290
    call Compose_Fusion_DrawMakeBlink             ; $5293
    ldh a, [hKeysNew]                             ; $5296
    bit PADB_UP, a                                ; $5298
    jr z, jr_006_52a9                             ; $529A

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $529C
    set_state STATE_17_FUSION_CURSOR              ; $52A3
    ret                                           ; $52A8


jr_006_52a9:
    bit 0, a                                      ; $52A9
    jr z, jr_006_52c7                             ; $52AB

    ld a, [wPhotoCount]                           ; $52AD
    cp $1e                                        ; $52B0
    jr nc, jr_006_52c1                            ; $52B2

    play_sfx1 SFX1_CHOOSE                         ; $52B4
    set_state STATE_17_FUSION_BUILD               ; $52BB
    ret                                           ; $52C0


jr_006_52c1:
    set_state STATE_17_RESULT_PREPARE             ; $52C1
    ret                                           ; $52C6


jr_006_52c7:
    bit 1, a                                      ; $52C7
    ret z                                         ; $52C9

    play_sfx1 SFX1_KEY_B                          ; $52CA
    set_state STATE_17_LEAVE                      ; $52D1
    ret                                           ; $52D6


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Fusion_DrawMakeBlink::
    ldh a, [hFrameCounter]                        ; $52D7
    bit 4, a                                      ; $52D9
    ret z                                         ; $52DB

    ld bc, $3878                                  ; $52DC
    ld a, $4e                                     ; $52DF
    call Oam_AddMeta_B02_52BD                     ; $52E1
    ret                                           ; $52E4


; I
Mode17_State0E_Fusion_Build::
    screen_off                                    ; $52E5
    ld a, $d2                                     ; $52EB
    ld [wPaletteTarget + $2], a                   ; $52ED
    ld hl, $8000                                  ; $52F0
    ld bc, $0500                                  ; $52F3
    call Mem_Zero                                 ; $52F6
    ld hl, $8800                                  ; $52F9
    ld bc, $0100                                  ; $52FC
    call Mem_Zero                                 ; $52FF
    ld hl, $9000                                  ; $5302
    ld bc, $0800                                  ; $5305
    call Mem_Zero                                 ; $5308
    farcopy Mem_CopyFromBank, Map_20_7542_Mode17_State08_Split_Build, $9800, $02c0 ; $530B
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $5319
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $5327
    ld a, $54                                     ; $5335
    ldh [hLycShadowSplit1], a                     ; $5337
    ldh [hSplit1Latch], a                         ; $5339
    ld hl, hStatShadow                            ; $533B
    set 6, [hl]                                   ; $533E
    ld hl, rIE                                    ; $5340
    set 1, [hl]                                   ; $5343
    ld a, $01                                     ; $5345
    ldh [hStatHandlerIndex], a                    ; $5347
    call Oam_ClearShadow                          ; $5349
    call Lcd_On                                   ; $534C
    call Pal_FadeIn                               ; $534F
    call Compose_BuildFusion                      ; $5352
    call Compose_DrawFreeCount                    ; $5355
    next_state                                    ; $5358
    ret                                           ; $535C


; C
Mode17_State0F_Fusion_Result::
    call Compose_DrawJitter                       ; $535D
    ldh a, [hKeysNew]                             ; $5360
    and PADF_A | PADF_B                           ; $5362
    ret z                                         ; $5364

    bit 0, a                                      ; $5365
    jr z, jr_006_53a6                             ; $5367

    ld a, $00                                     ; $5369
    ld hl, $9000                                  ; $536B
    ld de, wPhotoImage                            ; $536E
    ld bc, $0800                                  ; $5371
    call Vram_CopyFromBank_4                      ; $5374
    ld a, $00                                     ; $5377
    ld hl, $8800                                  ; $5379
    ld de, wPhotoImage + $800                     ; $537C
    ld bc, $0100                                  ; $537F
    call Vram_CopyFromBank_4                      ; $5382
    ld a, $00                                     ; $5385
    ld hl, $8000                                  ; $5387
    ld de, wPhotoImage + $900                     ; $538A
    ld bc, $0500                                  ; $538D
    call Vram_CopyFromBank_4                      ; $5390
    ldh [hFarcallAArg], a                         ; $5393
    farcall Photo_SaveShot_Far                    ; $5395
    call Snd_PlayTagDigits                        ; $539D
    ld bc, $003c                                  ; $53A0
    call Wait_Frames                              ; $53A3

jr_006_53a6:
    play_sfx1 SFX1_KEY_B                          ; $53A6
    screen_off                                    ; $53AD
    stat_irq_off                                  ; $53B3
    set_state STATE_17_INIT                       ; $53BD
    ret                                           ; $53C2


; C: back to mode 03
Mode17_State10_Leave::
    ld a, MODE_SPECIAL_MENU                       ; $53C3
    ld [wMode], a                                 ; $53C5
    set_state STATE_03_INIT                       ; $53C8
    screen_off                                    ; $53CD
    ret                                           ; $53D3


; C: message for the result screen
Mode17_State11_ResultPrepare::
    screen_off                                    ; $53D4
    stat_irq_off                                  ; $53DA
    xor a                                         ; $53E4
    ld [wSubstate], a                             ; $53E5
    ld a, $09                                     ; $53E8
    ld [wResultMsgId], a                          ; $53EA
    next_state                                    ; $53ED
    ret                                           ; $53F1


; C: far call 09:7290
Mode17_State12_ResultScreen::
    ldh [hFarcallAArg], a                         ; $53F2
    farcall ResultScreen_Far                      ; $53F4
    ret                                           ; $53FC


; C
Mode17_State13_Restart::
    set_state STATE_17_INIT                       ; $53FD
    ret                                           ; $5402


; C: reduces picture 1 into its quadrant tiles
Compose_LoadQuad0::
    ld a, [wCompose4Photos]                       ; $5403
    ldh [hFarcallAArg], a                         ; $5406
    ld a, $02                                     ; $5408
    ld hl, Photo_GetSramAddress_Far               ; $540A
    call Far_Call                                 ; $540D
    ld l, a                                       ; $5410
    push hl                                       ; $5411
    push bc                                       ; $5412
    ld hl, sp+$00                                 ; $5413
    ld bc, wThumbGrid                             ; $5415
    call Img_ReduceQuadrantTo4x4Tiles             ; $5418
    pop bc                                        ; $541B
    pop hl                                        ; $541C
    ld a, $00                                     ; $541D
    ld hl, wThumbGrid                             ; $541F
    ld de, $9700                                  ; $5422
    ld bc, $0040                                  ; $5425
    call Vram_CopyFromBank                        ; $5428
    ld a, $00                                     ; $542B
    ld hl, wThumbGrid + $40                       ; $542D
    ld de, $9780                                  ; $5430
    ld bc, $0040                                  ; $5433
    call Vram_CopyFromBank                        ; $5436
    ld a, $00                                     ; $5439
    ld hl, wThumbGrid + $80                       ; $543B
    ld de, $8800                                  ; $543E
    ld bc, $0040                                  ; $5441
    call Vram_CopyFromBank                        ; $5444
    ld a, $00                                     ; $5447
    ld hl, wThumbGrid + $c0                       ; $5449
    ld de, $8880                                  ; $544C
    ld bc, $0008                                  ; $544F
    call Vram_CopyFromBank                        ; $5452
    ld a, $00                                     ; $5455
    ld hl, wThumbGrid + $d0                       ; $5457
    ld de, $8890                                  ; $545A
    ld bc, $0008                                  ; $545D
    call Vram_CopyFromBank                        ; $5460
    ld a, $00                                     ; $5463
    ld hl, wThumbGrid + $e0                       ; $5465
    ld de, $88a0                                  ; $5468
    ld bc, $0008                                  ; $546B
    call Vram_CopyFromBank                        ; $546E
    ld a, $00                                     ; $5471
    ld hl, wThumbGrid + $f0                       ; $5473
    ld de, $88b0                                  ; $5476
    ld bc, $0008                                  ; $5479
    call Vram_CopyFromBank                        ; $547C
    ret                                           ; $547F


; C
Compose_LoadQuad1::
    ld a, [wCompose4Photos + $1]                  ; $5480
    ldh [hFarcallAArg], a                         ; $5483
    ld a, $02                                     ; $5485
    ld hl, Photo_GetSramAddress_Far               ; $5487
    call Far_Call                                 ; $548A
    ld l, a                                       ; $548D
    push hl                                       ; $548E
    ld hl, $0600                                  ; $548F
    add hl, bc                                    ; $5492
    push hl                                       ; $5493
    ld hl, sp+$00                                 ; $5494
    ld bc, wThumbGrid                             ; $5496
    call Img_ReduceQuadrantTo4x4Tiles             ; $5499
    pop bc                                        ; $549C
    pop hl                                        ; $549D
    ld a, $00                                     ; $549E
    ld hl, wThumbGrid + $8                        ; $54A0
    ld de, $8888                                  ; $54A3
    ld bc, $0008                                  ; $54A6
    call Vram_CopyFromBank                        ; $54A9
    ld a, $00                                     ; $54AC
    ld hl, wThumbGrid + $18                       ; $54AE
    ld de, $8898                                  ; $54B1
    ld bc, $0008                                  ; $54B4
    call Vram_CopyFromBank                        ; $54B7
    ld a, $00                                     ; $54BA
    ld hl, wThumbGrid + $28                       ; $54BC
    ld de, $88a8                                  ; $54BF
    ld bc, $0008                                  ; $54C2
    call Vram_CopyFromBank                        ; $54C5
    ld a, $00                                     ; $54C8
    ld hl, wThumbGrid + $38                       ; $54CA
    ld de, $88b8                                  ; $54CD
    ld bc, $0008                                  ; $54D0
    call Vram_CopyFromBank                        ; $54D3
    ld a, $00                                     ; $54D6
    ld hl, wThumbGrid + $40                       ; $54D8
    ld de, $8900                                  ; $54DB
    ld bc, $0040                                  ; $54DE
    call Vram_CopyFromBank                        ; $54E1
    ld a, $00                                     ; $54E4
    ld hl, wThumbGrid + $80                       ; $54E6
    ld de, $8980                                  ; $54E9
    ld bc, $0040                                  ; $54EC
    call Vram_CopyFromBank                        ; $54EF
    ld a, $00                                     ; $54F2
    ld hl, wThumbGrid + $c0                       ; $54F4
    ld de, $8a00                                  ; $54F7
    ld bc, $0040                                  ; $54FA
    call Vram_CopyFromBank                        ; $54FD
    ret                                           ; $5500


; C
Compose_LoadQuad2::
    ld a, [wCompose4Photos + $2]                  ; $5501
    ldh [hFarcallAArg], a                         ; $5504
    ld a, $02                                     ; $5506
    ld hl, Photo_GetSramAddress_Far               ; $5508
    call Far_Call                                 ; $550B
    ld l, a                                       ; $550E
    push hl                                       ; $550F
    ld hl, $0080                                  ; $5510
    add hl, bc                                    ; $5513
    push hl                                       ; $5514
    ld hl, sp+$00                                 ; $5515
    ld bc, wThumbGrid                             ; $5517
    call Img_ReduceQuadrantTo4x4Tiles             ; $551A
    pop bc                                        ; $551D
    pop hl                                        ; $551E
    ld a, $00                                     ; $551F
    ld hl, wThumbGrid                             ; $5521
    ld de, $9740                                  ; $5524
    ld bc, $0040                                  ; $5527
    call Vram_CopyFromBank                        ; $552A
    ld a, $00                                     ; $552D
    ld hl, wThumbGrid + $40                       ; $552F
    ld de, $97c0                                  ; $5532
    ld bc, $0040                                  ; $5535
    call Vram_CopyFromBank                        ; $5538
    ld a, $00                                     ; $553B
    ld hl, wThumbGrid + $80                       ; $553D
    ld de, $8840                                  ; $5540
    ld bc, $0040                                  ; $5543
    call Vram_CopyFromBank                        ; $5546
    ld a, $00                                     ; $5549
    ld hl, wThumbGrid + $c0                       ; $554B
    ld de, $88c0                                  ; $554E
    ld bc, $0008                                  ; $5551
    call Vram_CopyFromBank                        ; $5554
    ld a, $00                                     ; $5557
    ld hl, wThumbGrid + $d0                       ; $5559
    ld de, $88d0                                  ; $555C
    ld bc, $0008                                  ; $555F
    call Vram_CopyFromBank                        ; $5562
    ld a, $00                                     ; $5565
    ld hl, wThumbGrid + $e0                       ; $5567
    ld de, $88e0                                  ; $556A
    ld bc, $0008                                  ; $556D
    call Vram_CopyFromBank                        ; $5570
    ld a, $00                                     ; $5573
    ld hl, wThumbGrid + $f0                       ; $5575
    ld de, $88f0                                  ; $5578
    ld bc, $0008                                  ; $557B
    call Vram_CopyFromBank                        ; $557E
    ret                                           ; $5581


; C
Compose_LoadQuad3::
    ld a, [wCompose4Photos + $3]                  ; $5582
    ldh [hFarcallAArg], a                         ; $5585
    ld a, $02                                     ; $5587
    ld hl, Photo_GetSramAddress_Far               ; $5589
    call Far_Call                                 ; $558C
    ld l, a                                       ; $558F
    push hl                                       ; $5590
    ld hl, $0680                                  ; $5591
    add hl, bc                                    ; $5594
    push hl                                       ; $5595
    ld hl, sp+$00                                 ; $5596
    ld bc, wThumbGrid                             ; $5598
    call Img_ReduceQuadrantTo4x4Tiles             ; $559B
    pop bc                                        ; $559E
    pop hl                                        ; $559F
    ld a, $00                                     ; $55A0
    ld hl, wThumbGrid + $8                        ; $55A2
    ld de, $88c8                                  ; $55A5
    ld bc, $0008                                  ; $55A8
    call Vram_CopyFromBank                        ; $55AB
    ld a, $00                                     ; $55AE
    ld hl, wThumbGrid + $18                       ; $55B0
    ld de, $88d8                                  ; $55B3
    ld bc, $0008                                  ; $55B6
    call Vram_CopyFromBank                        ; $55B9
    ld a, $00                                     ; $55BC
    ld hl, wThumbGrid + $28                       ; $55BE
    ld de, $88e8                                  ; $55C1
    ld bc, $0008                                  ; $55C4
    call Vram_CopyFromBank                        ; $55C7
    ld a, $00                                     ; $55CA
    ld hl, wThumbGrid + $38                       ; $55CC
    ld de, $88f8                                  ; $55CF
    ld bc, $0008                                  ; $55D2
    call Vram_CopyFromBank                        ; $55D5
    ld a, $00                                     ; $55D8
    ld hl, wThumbGrid + $40                       ; $55DA
    ld de, $8940                                  ; $55DD
    ld bc, $0040                                  ; $55E0
    call Vram_CopyFromBank                        ; $55E3
    ld a, $00                                     ; $55E6
    ld hl, wThumbGrid + $80                       ; $55E8
    ld de, $89c0                                  ; $55EB
    ld bc, $0040                                  ; $55EE
    call Vram_CopyFromBank                        ; $55F1
    ld a, $00                                     ; $55F4
    ld hl, wThumbGrid + $c0                       ; $55F6
    ld de, $8a40                                  ; $55F9
    ld bc, $0040                                  ; $55FC
    call Vram_CopyFromBank                        ; $55FF
    ret                                           ; $5602


; C: reduces picture 1 into the left half of the fusion
Compose_LoadHalf0::
    ld a, [wCompose2Photos]                       ; $5603
    ldh [hFarcallAArg], a                         ; $5606
    ld a, $02                                     ; $5608
    ld hl, Photo_GetSramAddress_Far               ; $560A
    call Far_Call                                 ; $560D
    ld l, a                                       ; $5610
    push hl                                       ; $5611
    push bc                                       ; $5612
    ld hl, sp+$00                                 ; $5613
    ld bc, wReducedRows                           ; $5615
    call Img_ReduceHalfTo224Wide                  ; $5618
    pop bc                                        ; $561B
    pop hl                                        ; $561C
    ld de, wReducedRows                           ; $561D
    ld hl, $9700                                  ; $5620
    ld b, $40                                     ; $5623

jr_006_5625:
    call Compose_WriteTilePair                    ; $5625
    dec b                                         ; $5628
    jr nz, jr_006_5625                            ; $5629

    ld hl, $8800                                  ; $562B
    ld b, $a0                                     ; $562E

jr_006_5630:
    call Compose_WriteTilePair                    ; $5630
    dec b                                         ; $5633
    jr nz, jr_006_5630                            ; $5634

    ret                                           ; $5636


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_WriteTilePair::
    ld a, [de]                                    ; $5637
    call Vram_WriteByteSafe                       ; $5638
    inc de                                        ; $563B
    inc hl                                        ; $563C
    ld a, [de]                                    ; $563D
    call Vram_WriteByteSafe                       ; $563E
    inc de                                        ; $5641
    inc hl                                        ; $5642
    inc hl                                        ; $5643
    inc hl                                        ; $5644
    ret                                           ; $5645


; C
Compose_LoadHalf1::
    ld a, [wCompose2Photos + $1]                  ; $5646
    ldh [hFarcallAArg], a                         ; $5649
    ld a, $02                                     ; $564B
    ld hl, Photo_GetSramAddress_Far               ; $564D
    call Far_Call                                 ; $5650
    ld l, a                                       ; $5653
    push hl                                       ; $5654
    inc bc                                        ; $5655
    inc bc                                        ; $5656
    inc bc                                        ; $5657
    inc bc                                        ; $5658
    push bc                                       ; $5659
    ld hl, sp+$00                                 ; $565A
    ld bc, wReducedRows                           ; $565C
    call Img_ReduceHalfTo224Wide                  ; $565F
    pop bc                                        ; $5662
    pop hl                                        ; $5663
    ld de, wReducedRows                           ; $5664
    ld hl, $9702                                  ; $5667
    ld b, $40                                     ; $566A

jr_006_566c:
    call Compose_WriteTilePairB                   ; $566C
    dec b                                         ; $566F
    jr nz, jr_006_566c                            ; $5670

    ld hl, $8802                                  ; $5672
    ld b, $a0                                     ; $5675

jr_006_5677:
    call Compose_WriteTilePairB                   ; $5677
    dec b                                         ; $567A
    jr nz, jr_006_5677                            ; $567B

    ret                                           ; $567D


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_WriteTilePairB::
    ld a, [de]                                    ; $567E
    call Vram_WriteByteSafe                       ; $567F
    inc de                                        ; $5682
    inc hl                                        ; $5683
    ld a, [de]                                    ; $5684
    call Vram_WriteByteSafe                       ; $5685
    inc de                                        ; $5688
    inc hl                                        ; $5689
    inc hl                                        ; $568A
    inc hl                                        ; $568B
    ret                                           ; $568C


; C
Compose_DrawPhotoNumber::
    push af                                       ; $568D
    ld bc, $0000                                  ; $568E
    cp $1e                                        ; $5691
    jr c, jr_006_5698                             ; $5693

    sub $1e                                       ; $5695
    inc b                                         ; $5697

jr_006_5698:
    inc a                                         ; $5698

jr_006_5699:
    cp $0a                                        ; $5699
    jr c, jr_006_56a2                             ; $569B

    sub $0a                                       ; $569D
    inc c                                         ; $569F
    jr jr_006_5699                                ; $56A0

jr_006_56a2:
    push bc                                       ; $56A2
    swap a                                        ; $56A3
    ld c, a                                       ; $56A5
    ld b, $00                                     ; $56A6
    ld hl, Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits ; $56A8
    add hl, bc                                    ; $56AB
    ld a, BANK(Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits) ; $56AC
    ld de, $8060                                  ; $56AE
    ld bc, $0010                                  ; $56B1
    call Vram_CopyFromBank                        ; $56B4
    pop bc                                        ; $56B7
    push bc                                       ; $56B8
    swap c                                        ; $56B9
    ld b, $00                                     ; $56BB
    ld hl, Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits ; $56BD
    add hl, bc                                    ; $56C0
    ld a, BANK(Gfx_1E_64D0_Compose_DrawPhotoNumber_Digits) ; $56C1
    ld de, $8050                                  ; $56C3
    ld bc, $0010                                  ; $56C6
    call Vram_CopyFromBank                        ; $56C9
    pop bc                                        ; $56CC
    swap b                                        ; $56CD
    ld c, b                                       ; $56CF
    ld b, $00                                     ; $56D0
    ld hl, Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter ; $56D2
    add hl, bc                                    ; $56D5
    ld a, BANK(Gfx_1E_64B0_Compose_DrawPhotoNumber_AlbumLetter) ; $56D6
    ld de, $8030                                  ; $56D8
    ld bc, $0010                                  ; $56DB
    call Vram_CopyFromBank                        ; $56DE
    pop af                                        ; $56E1
    ret                                           ; $56E2


; C: far 02:517B photo to buffer then tiles
Compose_LoadPhotoThumb::
    push de                                       ; $56E3
    ldh [hFarcallAArg], a                         ; $56E4
    ld a, $02                                     ; $56E6
    ld hl, Photo_GetSramAddress_Far               ; $56E8
    call Far_Call                                 ; $56EB
    pop de                                        ; $56EE
    ld hl, $0e00                                  ; $56EF
    add hl, bc                                    ; $56F2
    push af                                       ; $56F3
    ld bc, $00c8                                  ; $56F4
    push de                                       ; $56F7
    push hl                                       ; $56F8
    call Vram_CopyFromBank                        ; $56F9
    pop hl                                        ; $56FC
    pop de                                        ; $56FD
    ld a, e                                       ; $56FE
    add $d0                                       ; $56FF
    ld e, a                                       ; $5701
    jr nc, jr_006_5705                            ; $5702

    inc d                                         ; $5704

jr_006_5705:
    ld bc, $00d0                                  ; $5705
    add hl, bc                                    ; $5708
    pop af                                        ; $5709
    push af                                       ; $570A
    ld bc, $0008                                  ; $570B
    push de                                       ; $570E
    push hl                                       ; $570F
    call Vram_CopyFromBank                        ; $5710
    pop hl                                        ; $5713
    pop de                                        ; $5714
    ld a, e                                       ; $5715
    add $10                                       ; $5716
    ld e, a                                       ; $5718
    jr nc, jr_006_571c                            ; $5719

    inc d                                         ; $571B

jr_006_571c:
    ld bc, $0010                                  ; $571C
    add hl, bc                                    ; $571F
    pop af                                        ; $5720
    push af                                       ; $5721
    ld bc, $0008                                  ; $5722
    push de                                       ; $5725
    push hl                                       ; $5726
    call Vram_CopyFromBank                        ; $5727
    pop hl                                        ; $572A
    pop de                                        ; $572B
    ld a, e                                       ; $572C
    add $10                                       ; $572D
    ld e, a                                       ; $572F
    jr nc, jr_006_5733                            ; $5730

    inc d                                         ; $5732

jr_006_5733:
    ld bc, $0010                                  ; $5733
    add hl, bc                                    ; $5736
    pop af                                        ; $5737
    ld bc, $0008                                  ; $5738
    call Vram_CopyFromBank                        ; $573B
    ret                                           ; $573E


; C: Left / Right steps the picture index (own pictures then stock)
Compose_StepPhoto::
    push af                                       ; $573F
    ld a, [wStockPictureCount]                    ; $5740
    add $1e                                       ; $5743
    ld c, a                                       ; $5745
    pop af                                        ; $5746
    ld hl, hKeysRepeatSticky                      ; $5747
    bit 6, [hl]                                   ; $574A
    jr z, jr_006_575a                             ; $574C

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $574E
    inc a                                         ; $5755
    cp c                                          ; $5756
    ret nz                                        ; $5757

    xor a                                         ; $5758
    ret                                           ; $5759


jr_006_575a:
    bit 7, [hl]                                   ; $575A
    ret z                                         ; $575C

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $575D
    dec a                                         ; $5764
    bit 7, a                                      ; $5765
    ret z                                         ; $5767

    ld a, c                                       ; $5768
    dec a                                         ; $5769
    ret                                           ; $576A


; C: L3 pass 2026-10-26: executed in BGB in 16 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawPhotoCursor::
    ldh a, [hFrameCounter]                        ; $576B
    srl a                                         ; $576D
    srl a                                         ; $576F
    and $03                                       ; $5771
    ld e, a                                       ; $5773
    ld d, $00                                     ; $5774
    add hl, de                                    ; $5776
    ld a, [hl]                                    ; $5777
    call Oam_AddMeta_B02_52BD                     ; $5778
    ret                                           ; $577B


; C
Compose_BuildFusion::
    ld bc, $0e00                                  ; $577C

jr_006_577f:
    push bc                                       ; $577F
    ld h, c                                       ; $5780
    ld l, $00                                     ; $5781
    call Compose_FusionReduceLeft                 ; $5783
    call Compose_FusionMerge                      ; $5786
    pop bc                                        ; $5789
    push bc                                       ; $578A
    ld b, $00                                     ; $578B
    ld hl, Compose_BuildFusion_Tbl57A4            ; $578D
    add hl, bc                                    ; $5790
    ld d, [hl]                                    ; $5791
    ld e, $00                                     ; $5792
    ld hl, wBlendRows                             ; $5794
    xor a                                         ; $5797
    ld bc, $0100                                  ; $5798
    call Vram_CopyFromBank                        ; $579B
    pop bc                                        ; $579E
    inc c                                         ; $579F
    dec b                                         ; $57A0
    jr nz, jr_006_577f                            ; $57A1

    ret                                           ; $57A3


; C: auto: 14 bytes, bytes; referenced by Compose_BuildFusion. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 17)
Compose_BuildFusion_Tbl57A4::
    db $90, $91, $92, $93, $94, $95, $96, $97, $88, $80, $81, $82, $83, $84

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_FusionReduceLeft::
    push hl                                       ; $57B2
    ld a, [wCompose2Photos]                       ; $57B3
    ldh [hFarcallAArg], a                         ; $57B6
    ld a, $02                                     ; $57B8
    ld hl, Photo_GetSramAddress_Far               ; $57BA
    call Far_Call                                 ; $57BD
    pop hl                                        ; $57C0
    push hl                                       ; $57C1
    add hl, bc                                    ; $57C2
    ld de, wBlendRows                             ; $57C3
    ld bc, $0100                                  ; $57C6
    call Mem_CopyFromBank                         ; $57C9
    ld a, [wCompose2Photos + $1]                  ; $57CC
    ldh [hFarcallAArg], a                         ; $57CF
    ld a, $02                                     ; $57D1
    ld hl, Photo_GetSramAddress_Far               ; $57D3
    call Far_Call                                 ; $57D6
    pop hl                                        ; $57D9
    add hl, bc                                    ; $57DA
    ld de, wBlendRows + $100                      ; $57DB
    ld bc, $0100                                  ; $57DE
    call Mem_CopyFromBank                         ; $57E1
    ret                                           ; $57E4


; C: 2:1 reduction of the rows (mask $55 / $80). L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Compose_FusionMerge::
    ld hl, wBlendRows                             ; $57E5
    ld de, wBlendRows + $100                      ; $57E8
    ld a, $55                                     ; $57EB
    ldh [hScratchB], a                            ; $57ED
    ld a, $80                                     ; $57EF

jr_006_57f1:
    ldh [hScratchA], a                            ; $57F1
    ld a, [hl]                                    ; $57F3
    and $55                                       ; $57F4
    ld c, a                                       ; $57F6
    xor [hl]                                      ; $57F7
    ld [hl+], a                                   ; $57F8
    ld a, [de]                                    ; $57F9
    and $55                                       ; $57FA
    add c                                         ; $57FC
    ld c, a                                       ; $57FD
    ldh a, [hScratchB]                            ; $57FE
    and $55                                       ; $5800
    add c                                         ; $5802
    and $aa                                       ; $5803
    srl a                                         ; $5805
    ld c, a                                       ; $5807
    inc e                                         ; $5808
    ld a, [hl]                                    ; $5809
    and $55                                       ; $580A
    ld b, a                                       ; $580C
    xor [hl]                                      ; $580D
    ld [hl], a                                    ; $580E
    ld a, [de]                                    ; $580F
    and $55                                       ; $5810
    add b                                         ; $5812
    add c                                         ; $5813
    ld c, a                                       ; $5814
    and $aa                                       ; $5815
    srl a                                         ; $5817
    or [hl]                                       ; $5819
    ld [hl-], a                                   ; $581A
    ld a, c                                       ; $581B
    and $55                                       ; $581C
    or [hl]                                       ; $581E
    ld [hl], a                                    ; $581F
    dec e                                         ; $5820
    ld a, [hl]                                    ; $5821
    and $aa                                       ; $5822
    ld c, a                                       ; $5824
    xor [hl]                                      ; $5825
    ld [hl+], a                                   ; $5826
    ld a, [de]                                    ; $5827
    and $aa                                       ; $5828
    add c                                         ; $582A
    rr a                                          ; $582B
    ld c, a                                       ; $582D
    ldh a, [hScratchB]                            ; $582E
    and $aa                                       ; $5830
    srl a                                         ; $5832
    add c                                         ; $5834
    and $aa                                       ; $5835
    srl a                                         ; $5837
    ld c, a                                       ; $5839
    inc e                                         ; $583A
    ld a, [hl]                                    ; $583B
    and $aa                                       ; $583C
    ld b, a                                       ; $583E
    xor [hl]                                      ; $583F
    ld [hl-], a                                   ; $5840
    ld a, [de]                                    ; $5841
    and $aa                                       ; $5842
    add b                                         ; $5844
    rr a                                          ; $5845
    add c                                         ; $5847
    ld c, a                                       ; $5848
    and $55                                       ; $5849
    sla a                                         ; $584B
    or [hl]                                       ; $584D
    ld [hl+], a                                   ; $584E
    ld a, c                                       ; $584F
    and $aa                                       ; $5850
    or [hl]                                       ; $5852
    ld [hl+], a                                   ; $5853
    inc e                                         ; $5854
    ldh a, [hScratchB]                            ; $5855
    rlca                                          ; $5857
    ldh [hScratchB], a                            ; $5858
    ldh a, [hScratchA]                            ; $585A
    dec a                                         ; $585C
    jr nz, jr_006_57f1                            ; $585D

    ret                                           ; $585F


; C: four quadrants into the composite buffer
Compose_BuildSplit::
    ld a, [wCompose4Photos]                       ; $5860
    ld hl, $0000                                  ; $5863
    call Compose_SplitQuadrant                    ; $5866
    ld a, [wCompose4Photos + $2]                  ; $5869
    ld hl, $0080                                  ; $586C
    call Compose_SplitQuadrant                    ; $586F
    ld a, [wCompose4Photos + $1]                  ; $5872
    ld hl, $0700                                  ; $5875
    call Compose_SplitQuadrant                    ; $5878
    ld a, [wCompose4Photos + $3]                  ; $587B
    ld hl, $0780                                  ; $587E
    call Compose_SplitQuadrant                    ; $5881
    ld a, $00                                     ; $5884
    ld hl, wPhotoImage                            ; $5886
    ld de, $9000                                  ; $5889
    ld bc, $0800                                  ; $588C
    call Vram_CopyFromBank                        ; $588F
    ld a, $00                                     ; $5892
    ld hl, wPhotoImage + $800                     ; $5894
    ld de, $8800                                  ; $5897
    ld bc, $0100                                  ; $589A
    call Vram_CopyFromBank                        ; $589D
    ld a, $00                                     ; $58A0
    ld hl, wPhotoImage + $900                     ; $58A2
    ld de, $8000                                  ; $58A5
    ld bc, $0500                                  ; $58A8
    call Vram_CopyFromBank                        ; $58AB
    ret                                           ; $58AE


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_SplitQuadrant::
    push hl                                       ; $58AF
    ld de, wPhotoImage                            ; $58B0
    add hl, de                                    ; $58B3
    push hl                                       ; $58B4
    ldh [hFarcallAArg], a                         ; $58B5
    ld a, $02                                     ; $58B7
    ld hl, Photo_GetSramAddress_Far               ; $58B9
    call Far_Call                                 ; $58BC
    pop de                                        ; $58BF
    pop hl                                        ; $58C0
    add hl, bc                                    ; $58C1
    ld b, $07                                     ; $58C2

jr_006_58c4:
    push bc                                       ; $58C4
    ld bc, $0080                                  ; $58C5
    push af                                       ; $58C8
    call Mem_CopyFromBank                         ; $58C9
    ld a, e                                       ; $58CC
    add $80                                       ; $58CD
    ld e, a                                       ; $58CF
    jr nc, jr_006_58d3                            ; $58D0

    inc d                                         ; $58D2

jr_006_58d3:
    ld a, l                                       ; $58D3
    add $80                                       ; $58D4
    ld l, a                                       ; $58D6
    jr nc, jr_006_58da                            ; $58D7

    inc h                                         ; $58D9

jr_006_58da:
    pop af                                        ; $58DA
    pop bc                                        ; $58DB
    dec b                                         ; $58DC
    jr nz, jr_006_58c4                            ; $58DD

    ret                                           ; $58DF


; C: photo_count + 1 as digits. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs
; of the core emulator (coverage/results/merged_state/cov.npz)
Compose_DrawFreeCount::
    ld c, $00                                     ; $58E0
    ld a, [wPhotoCount]                           ; $58E2
    inc a                                         ; $58E5

jr_006_58e6:
    cp $0a                                        ; $58E6
    jr c, jr_006_58ef                             ; $58E8

    sub $0a                                       ; $58EA
    inc c                                         ; $58EC
    jr jr_006_58e6                                ; $58ED

jr_006_58ef:
    push bc                                       ; $58EF
    ld c, a                                       ; $58F0
    ld b, $00                                     ; $58F1
    swap c                                        ; $58F3
    sla c                                         ; $58F5
    rl b                                          ; $58F7
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $58F9
    add hl, bc                                    ; $58FC
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $58FD
    ld de, $8720                                  ; $58FF
    ld bc, $0020                                  ; $5902
    call Vram_CopyFromBank                        ; $5905
    pop bc                                        ; $5908
    ld b, $00                                     ; $5909
    swap c                                        ; $590B
    sla c                                         ; $590D
    rl b                                          ; $590F
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $5911
    add hl, bc                                    ; $5914
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $5915
    ld de, $8700                                  ; $5917
    ld bc, $0020                                  ; $591A
    call Vram_CopyFromBank                        ; $591D
    ret                                           ; $5920


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_DrawJitter::
    ldh a, [hFrameCounter]                        ; $5921
    and $01                                       ; $5923
    jr nz, jr_006_5933                            ; $5925

    call Rng_Next                                 ; $5927
    ld [wJitterX], a                              ; $592A
    call Rng_Next                                 ; $592D
    ld [wJitterY], a                              ; $5930

jr_006_5933:
    ld a, [wJitterX]                              ; $5933
    and $01                                       ; $5936
    add $79                                       ; $5938
    ld b, a                                       ; $593A
    ld a, [wJitterY]                              ; $593B
    and $01                                       ; $593E
    add $7c                                       ; $5940
    ld c, a                                       ; $5942
    ld a, $38                                     ; $5943
    call Oam_AddMeta_B01_5D2B                     ; $5945
    ld a, [wJitterX]                              ; $5948
    and $01                                       ; $594B
    add $79                                       ; $594D
    ld b, a                                       ; $594F
    ld a, [wJitterY]                              ; $5950
    and $01                                       ; $5953
    add $8d                                       ; $5955
    ld c, a                                       ; $5957
    ld a, $39                                     ; $5958
    call Oam_AddMeta_B01_5D2B                     ; $595A
    ld a, [wShootVariant]                         ; $595D
    cp $15                                        ; $5960
    ret z                                         ; $5962

    ld a, [wJitterX]                              ; $5963
    xor $01                                       ; $5966
    and $01                                       ; $5968
    add $34                                       ; $596A
    ld b, a                                       ; $596C
    ld a, [wJitterY]                              ; $596D
    xor $01                                       ; $5970
    and $01                                       ; $5972
    add $33                                       ; $5974
    ld c, a                                       ; $5976
    ld a, $37                                     ; $5977
    call Oam_AddMeta_B01_5D2B                     ; $5979
    ret                                           ; $597C


; C: mode 18: PANORAMA print
Mode18_PanoramaPrint::
    ld a, [wState]                                ; $597D
    rst Rst18_JumpTable                           ; $5980

; I: 4 states
Mode18_StateTable::
    dw Mode18_State00_Init
    dw Mode18_State01_PickFirst
    dw Mode18_State02_PickLast
    dw Mode18_State03_PrintOrCancel

; C
Mode18_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5989
    ldh [hLcdcShadow], a                          ; $598B
    ld a, $e4                                     ; $598D
    ld [wPaletteTarget], a                        ; $598F
    ld [wPaletteTarget + $1], a                   ; $5992
    ld a, $d2                                     ; $5995
    ld [wPaletteTarget + $2], a                   ; $5997
    xor a                                         ; $599A
    ldh [hScxShadow], a                           ; $599B
    ldh [hScyShadow], a                           ; $599D
    ld [wSelCursorTick], a                        ; $599F
    ld [wSelCursorFrame], a                       ; $59A2
    ld [wSelSlot], a                              ; $59A5
    farcopy Mem_CopyFromBank, Gfx_11_7000_Mode18_State00_Init, $9000, $0800 ; $59A8
    farcopy Mem_CopyFromBank, Gfx_11_7800_Mode18_State00_Init, $8800, $0800 ; $59B6
    farcopy Mem_CopyFromBank, Map_16_7D80_Mode18_State00_Init, $9800, $0240 ; $59C4
    ld a, [wOpt3ToggleB]                          ; $59D2
    and a                                         ; $59D5
    jr z, jr_006_59e6                             ; $59D6

    farcopy Mem_CopyFromBank, Map_16_7FC0_Mode18_State00_Init, $9800, $0040 ; $59D8

jr_006_59e6:
    screen_on                                     ; $59E6
    play_music MUSIC_SHUTTERBUG                   ; $59EF
    call Mode18_LoadAllThumbs                     ; $59F6
    ld a, [wBurstPhotos]                          ; $59F9
    call Mode18_DrawThumbFrame                    ; $59FC
    call Mode18_DrawArrows                        ; $59FF
    call Pal_FadeIn                               ; $5A02
    ld a, [wOpt3ToggleB]                          ; $5A05
    and a                                         ; $5A08
    jr nz, jr_006_5a10                            ; $5A09

    next_state                                    ; $5A0B
    ret                                           ; $5A0F


jr_006_5a10:
    set_state STATE_18_PICK_LAST                  ; $5A10
    ret                                           ; $5A15


; C
Mode18_State01_PickFirst::
    call Mode18_Pick1_Input                       ; $5A16
    call Mode18_Pick1_DrawCursor                  ; $5A19
    call Mode18_DrawArrows                        ; $5A1C
    ldh a, [hKeysNew]                             ; $5A1F
    and PADF_A | PADF_B                           ; $5A21
    ret z                                         ; $5A23

    ld [wAbResult], a                             ; $5A24
    push af                                       ; $5A27
    bit 0, a                                      ; $5A28
    ld a, SFX1_KEY_A                              ; $5A2A
    call nz, Snd_Sfx1                             ; $5A2C
    pop af                                        ; $5A2F
    push af                                       ; $5A30
    bit 1, a                                      ; $5A31
    ld a, SFX1_KEY_B                              ; $5A33
    call nz, Snd_Sfx1                             ; $5A35
    pop af                                        ; $5A38
    set_state STATE_18_PRINT_OR_CANCEL            ; $5A39
    ret                                           ; $5A3E


; C
Mode18_State02_PickLast::
    call Mode18_Pick2_Input                       ; $5A3F
    call Mode18_Pick2_DrawCursor                  ; $5A42
    call Mode18_DrawArrows                        ; $5A45
    ldh a, [hKeysNew]                             ; $5A48
    and PADF_A | PADF_B                           ; $5A4A
    ret z                                         ; $5A4C

    ld [wAbResult], a                             ; $5A4D
    push af                                       ; $5A50
    bit 0, a                                      ; $5A51
    ld a, SFX1_KEY_A                              ; $5A53
    call nz, Snd_Sfx1                             ; $5A55
    pop af                                        ; $5A58
    push af                                       ; $5A59
    bit 1, a                                      ; $5A5A
    ld a, SFX1_KEY_B                              ; $5A5C
    call nz, Snd_Sfx1                             ; $5A5E
    pop af                                        ; $5A61
    next_state                                    ; $5A62
    ret                                           ; $5A66


; C: A prints the strip; B cancels
Mode18_State03_PrintOrCancel::
    ld a, [wAbResult]                             ; $5A67
    bit 0, a                                      ; $5A6A
    jr z, jr_006_5a97                             ; $5A6C

    ld b, $0c                                     ; $5A6E

jr_006_5a70:
    push bc                                       ; $5A70
    call Mode18_DrawArrows                        ; $5A71
    ldh a, [hFrameCounter]                        ; $5A74
    bit 2, a                                      ; $5A76
    call nz, Mode18_DrawPrintLabel                ; $5A78
    call Oam_HideUnused                           ; $5A7B
    rst Rst08_WaitVBlank                          ; $5A7E
    pop bc                                        ; $5A7F
    dec b                                         ; $5A80
    jr nz, jr_006_5a70                            ; $5A81

    screen_off                                    ; $5A83
    call Mode18_StartPrint                        ; $5A89
    ld a, MODE_PRINT_JOB                          ; $5A8C
    ld [wMode], a                                 ; $5A8E
    set_state STATE_1D_INIT                       ; $5A91
    ret                                           ; $5A96


jr_006_5a97:
    ld b, $0c                                     ; $5A97

jr_006_5a99:
    push bc                                       ; $5A99
    call Mode18_DrawArrows                        ; $5A9A
    ldh a, [hFrameCounter]                        ; $5A9D
    bit 2, a                                      ; $5A9F
    call nz, Mode18_DrawCancelLabel               ; $5AA1
    call Oam_HideUnused                           ; $5AA4
    rst Rst08_WaitVBlank                          ; $5AA7
    pop bc                                        ; $5AA8
    dec b                                         ; $5AA9
    jr nz, jr_006_5a99                            ; $5AAA

    screen_off                                    ; $5AAC
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $5AB2
    ld [wMode], a                                 ; $5AB4
    set_state STATE_16_REDRAW                     ; $5AB7
    ret                                           ; $5ABC


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (56 hits in 3 runs: 18:03 x56;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawPrintLabel::
    ld bc, $1662                                  ; $5ABD
    ld a, $5c                                     ; $5AC0
    call Oam_AddMeta_B02_52BD                     ; $5AC2
    ret                                           ; $5AC5


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (50 hits in 4 runs: 18:03 x50;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawCancelLabel::
    ld bc, $1673                                  ; $5AC6
    ld a, $5d                                     ; $5AC9
    call Oam_AddMeta_B02_52BD                     ; $5ACB
    ret                                           ; $5ACE


; C: fills print_src_table and calls the print job
Mode18_StartPrint::
    ld hl, wBurstPhotos + $3                      ; $5ACF
    ld de, wPrintSrcTable + $e                    ; $5AD2
    ld bc, $0400                                  ; $5AD5

jr_006_5ad8:
    push bc                                       ; $5AD8
    ld bc, $ffff                                  ; $5AD9
    ld a, [hl]                                    ; $5ADC
    cp $ff                                        ; $5ADD
    jr z, jr_006_5aef                             ; $5ADF

    push de                                       ; $5AE1
    push hl                                       ; $5AE2
    ldh [hFarcallAArg], a                         ; $5AE3
    ld a, $02                                     ; $5AE5
    ld hl, Photo_GetSramAddress_Far               ; $5AE7
    call Far_Call                                 ; $5AEA
    pop hl                                        ; $5AED
    pop de                                        ; $5AEE

jr_006_5aef:
    ld [de], a                                    ; $5AEF
    dec de                                        ; $5AF0
    ld a, b                                       ; $5AF1
    ld [de], a                                    ; $5AF2
    dec de                                        ; $5AF3
    ld a, c                                       ; $5AF4
    ld [de], a                                    ; $5AF5
    dec de                                        ; $5AF6
    dec de                                        ; $5AF7
    pop bc                                        ; $5AF8
    ld a, c                                       ; $5AF9
    and a                                         ; $5AFA
    jr nz, jr_006_5b01                            ; $5AFB

    bit 7, [hl]                                   ; $5AFD
    jr nz, jr_006_5b02                            ; $5AFF

jr_006_5b01:
    inc c                                         ; $5B01

jr_006_5b02:
    dec hl                                        ; $5B02
    dec b                                         ; $5B03
    jr nz, jr_006_5ad8                            ; $5B04

    ld a, c                                       ; $5B06
    ld [wPrintPages], a                           ; $5B07
    ld a, [wOpt3ToggleB]                          ; $5B0A
    xor $01                                       ; $5B0D
    add $02                                       ; $5B0F
    ld [wPrintLayoutType], a                      ; $5B11
    ld [wPrintReturnIdx], a                       ; $5B14
    xor a                                         ; $5B17
    ld [wPrintCustomMargin], a                    ; $5B18
    ret                                           ; $5B1B


; C
Mode18_Pick1_Input::
    ld a, [wStockPictureCount]                    ; $5B1C
    add $1e                                       ; $5B1F
    ld c, a                                       ; $5B21
    ldh a, [hKeysNewRepeat]                       ; $5B22
    ld b, a                                       ; $5B24
    ld hl, wSelSlot                               ; $5B25
    ld a, [hl]                                    ; $5B28
    call Mode18_Pick1_Left                        ; $5B29
    cp [hl]                                       ; $5B2C
    ld [hl], a                                    ; $5B2D
    ld e, a                                       ; $5B2E
    ld d, $00                                     ; $5B2F
    ld hl, wBurstPhotos                           ; $5B31
    add hl, de                                    ; $5B34
    ld a, [hl]                                    ; $5B35
    jr nz, jr_006_5b3d                            ; $5B36

    call Mode18_Pick1_Right                       ; $5B38
    cp [hl]                                       ; $5B3B
    ld [hl], a                                    ; $5B3C

jr_006_5b3d:
    ld c, e                                       ; $5B3D
    call nz, Mode18_DrawThumbFrame                ; $5B3E
    call nz, Mode18_LoadThumb                     ; $5B41
    ret                                           ; $5B44


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (2096 hits in 8 runs: 18:01 x2096;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_Left::
    bit 5, b                                      ; $5B45
    jr z, jr_006_5b54                             ; $5B47

    and a                                         ; $5B49
    ret z                                         ; $5B4A

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5B4B
    dec a                                         ; $5B52
    ret                                           ; $5B53


jr_006_5b54:
    bit 4, b                                      ; $5B54
    ret z                                         ; $5B56

    cp $03                                        ; $5B57
    ret z                                         ; $5B59

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5B5A
    inc a                                         ; $5B61
    ret                                           ; $5B62


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (2096 hits in 8 runs: 18:01 x2096;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_Right::
    bit 7, b                                      ; $5B63
    jr z, jr_006_5b75                             ; $5B65

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5B67
    dec a                                         ; $5B6E
    cp $fe                                        ; $5B6F
    ret nz                                        ; $5B71

    ld a, c                                       ; $5B72
    dec a                                         ; $5B73
    ret                                           ; $5B74


jr_006_5b75:
    bit 6, b                                      ; $5B75
    ret z                                         ; $5B77

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5B78
    inc a                                         ; $5B7F
    cp c                                          ; $5B80
    ret nz                                        ; $5B81

    ld a, $ff                                     ; $5B82
    ret                                           ; $5B84


; C
Mode18_Pick2_Input::
    ld a, [wStockPictureCount]                    ; $5B85
    add $1e                                       ; $5B88
    ld c, a                                       ; $5B8A
    ldh a, [hKeysNewRepeat]                       ; $5B8B
    ld b, a                                       ; $5B8D
    ld hl, wSelSlot                               ; $5B8E
    ld a, [hl]                                    ; $5B91
    call Mode18_Pick2_Up                          ; $5B92
    cp [hl]                                       ; $5B95
    ld [hl], a                                    ; $5B96
    ld e, a                                       ; $5B97
    ld d, $00                                     ; $5B98
    ld hl, wBurstPhotos                           ; $5B9A
    add hl, de                                    ; $5B9D
    ld a, [hl]                                    ; $5B9E
    jr nz, jr_006_5ba6                            ; $5B9F

    call Mode18_Pick2_Down                        ; $5BA1
    cp [hl]                                       ; $5BA4
    ld [hl], a                                    ; $5BA5

jr_006_5ba6:
    ld c, e                                       ; $5BA6
    call nz, Mode18_DrawThumbFrame                ; $5BA7
    call nz, Mode18_LoadThumb                     ; $5BAA
    ret                                           ; $5BAD


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (13800 hits in 3 runs: 18:02 x13800;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick2_Up::
    bit 6, b                                      ; $5BAE
    jr z, jr_006_5bbd                             ; $5BB0

    and a                                         ; $5BB2
    ret z                                         ; $5BB3

    dec a                                         ; $5BB4
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $5BB5
    ret                                           ; $5BBC


jr_006_5bbd:
    bit 7, b                                      ; $5BBD
    ret z                                         ; $5BBF

    cp $03                                        ; $5BC0
    ret z                                         ; $5BC2

    inc a                                         ; $5BC3
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $5BC4
    ret                                           ; $5BCB


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (13800 hits in 3 runs: 18:02 x13800;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick2_Down::
    bit 5, b                                      ; $5BCC
    jr z, jr_006_5bde                             ; $5BCE

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5BD0
    dec a                                         ; $5BD7
    cp $fe                                        ; $5BD8
    ret nz                                        ; $5BDA

    ld a, c                                       ; $5BDB
    dec a                                         ; $5BDC
    ret                                           ; $5BDD


jr_006_5bde:
    bit 4, b                                      ; $5BDE
    ret z                                         ; $5BE0

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5BE1
    inc a                                         ; $5BE8
    cp c                                          ; $5BE9
    ret nz                                        ; $5BEA

    ld a, $ff                                     ; $5BEB
    ret                                           ; $5BED


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (1048 hits in 8 runs: 18:01 x1048;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_DrawCursor::
    ld a, [wSelSlot]                              ; $5BEE
    sla a                                         ; $5BF1
    ld c, a                                       ; $5BF3
    ld b, $00                                     ; $5BF4
    ld hl, Mode18_Pick1_SlotPosTbl                ; $5BF6
    add hl, bc                                    ; $5BF9
    ld c, [hl]                                    ; $5BFA
    inc hl                                        ; $5BFB
    ld b, [hl]                                    ; $5BFC
    ld a, [wSelCursorFrame]                       ; $5BFD
    sla a                                         ; $5C00
    ld e, a                                       ; $5C02
    ld d, $00                                     ; $5C03
    ld hl, Mode18_Pick1_CursorAnimTbl             ; $5C05
    add hl, de                                    ; $5C08
    ld a, [hl+]                                   ; $5C09
    call Oam_AddMeta_B02_52BD                     ; $5C0A
    ld a, [wSelCursorTick]                        ; $5C0D
    cp [hl]                                       ; $5C10
    jr c, jr_006_5c20                             ; $5C11

    inc hl                                        ; $5C13
    ld a, [hl]                                    ; $5C14
    inc a                                         ; $5C15
    jr z, jr_006_5c1c                             ; $5C16

    ld a, [wSelCursorFrame]                       ; $5C18
    inc a                                         ; $5C1B

jr_006_5c1c:
    ld [wSelCursorFrame], a                       ; $5C1C
    xor a                                         ; $5C1F

jr_006_5c20:
    inc a                                         ; $5C20
    ld [wSelCursorTick], a                        ; $5C21
    ret                                           ; $5C24


; C: 4 x {y; x} of the slot cursor of the first panorama pick: one row, y = $18, x = $10 / $30 / $50 / $70, indexed by
; wSelSlot in Mode18_Pick1_DrawCursor (06:5C07) (read 2026-10-25)
Mode18_Pick1_SlotPosTbl::
    db $18, $10, $18, $30, $18, $50, $18, $70

; C: {OAM list id; ticks} x 3 = $54, $55, $56, 5 ticks each, then $FF (loop to frame 0): frame wSelCursorFrame, tick
; wSelCursorTick (06:5C16) (read 2026-10-25)
Mode18_Pick1_CursorAnimTbl::
    db $54, $05, $55, $05, $56, $05, $ff

; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (6900 hits in 3 runs: 18:02 x6900;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick2_DrawCursor::
    ld a, [wSelSlot]                              ; $5C34
    sla a                                         ; $5C37
    ld c, a                                       ; $5C39
    ld b, $00                                     ; $5C3A
    ld hl, Mode18_Pick2_SlotPosTbl                ; $5C3C
    add hl, bc                                    ; $5C3F
    ld c, [hl]                                    ; $5C40
    inc hl                                        ; $5C41
    ld b, [hl]                                    ; $5C42
    ld a, [wSelCursorFrame]                       ; $5C43
    sla a                                         ; $5C46
    ld e, a                                       ; $5C48
    ld d, $00                                     ; $5C49
    ld hl, Mode18_Pick2_CursorAnimTbl             ; $5C4B
    add hl, de                                    ; $5C4E
    ld a, [hl+]                                   ; $5C4F
    call Oam_AddMeta_B02_52BD                     ; $5C50
    ld a, [wSelCursorTick]                        ; $5C53
    cp [hl]                                       ; $5C56
    jr c, jr_006_5c66                             ; $5C57

    inc hl                                        ; $5C59
    ld a, [hl]                                    ; $5C5A
    inc a                                         ; $5C5B
    jr z, jr_006_5c62                             ; $5C5C

    ld a, [wSelCursorFrame]                       ; $5C5E
    inc a                                         ; $5C61

jr_006_5c62:
    ld [wSelCursorFrame], a                       ; $5C62
    xor a                                         ; $5C65

jr_006_5c66:
    inc a                                         ; $5C66
    ld [wSelCursorTick], a                        ; $5C67
    ret                                           ; $5C6A


; C: 4 x {y; x} of the slot cursor of the second panorama pick: one column, x = $70, y = $18 / $34 / $50 / $6C,
; indexed by wSelSlot in Mode18_Pick2_DrawCursor (06:5C4D); byte pairs, not words (read 2026-10-25)
Mode18_Pick2_SlotPosTbl::
    dw $7018
    dw $7034
    dw $7050
    dw $706c

; C: {OAM list id; ticks} x 3 = $57, $58, $59, 5 ticks each, then $FF (loop): read by Mode18_Pick2_DrawCursor
; (06:5C5C) (read 2026-10-25)
Mode18_Pick2_CursorAnimTbl::
    db $57, $05, $58, $05, $59, $05, $ff

; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (16140 hits in 9 runs: 18:00 x28 18:01 x2096 18:02 x13800
; 18:03 x216; tcrf_check/assets/mode_state_wp/)
Mode18_DrawArrows::
    ld bc, $7034                                  ; $5C7A
    ld a, $5a                                     ; $5C7D
    call Oam_AddMeta_B02_52BD                     ; $5C7F
    ld bc, $706c                                  ; $5C82
    ld a, $5b                                     ; $5C85
    call Oam_AddMeta_B02_52BD                     ; $5C87
    ret                                           ; $5C8A


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (28 hits in 9 runs: 18:00 x28;
; tcrf_check/assets/mode_state_wp/)
Mode18_LoadAllThumbs::
    ld hl, wBurstPhotos                           ; $5C8B
    ld c, $00                                     ; $5C8E

jr_006_5c90:
    push bc                                       ; $5C90
    push hl                                       ; $5C91
    bit 7, [hl]                                   ; $5C92
    call z, Mode18_LoadThumb                      ; $5C94
    pop hl                                        ; $5C97
    pop bc                                        ; $5C98
    inc hl                                        ; $5C99
    inc c                                         ; $5C9A
    ld a, c                                       ; $5C9B
    cp $04                                        ; $5C9C
    jr nz, jr_006_5c90                            ; $5C9E

    ret                                           ; $5CA0


; C
Mode18_LoadThumb::
    push bc                                       ; $5CA1
    push hl                                       ; $5CA2
    ld a, [wOpt3ToggleB]                          ; $5CA3
    sla a                                         ; $5CA6
    sla a                                         ; $5CA8
    sla a                                         ; $5CAA
    sla c                                         ; $5CAC
    add c                                         ; $5CAE
    ld c, a                                       ; $5CAF
    ld b, $00                                     ; $5CB0
    ld hl, Mode18_LoadThumb_Tbl5D33               ; $5CB2
    add hl, bc                                    ; $5CB5
    ld e, [hl]                                    ; $5CB6
    inc hl                                        ; $5CB7
    ld d, [hl]                                    ; $5CB8
    pop hl                                        ; $5CB9
    pop bc                                        ; $5CBA
    ld a, [hl]                                    ; $5CBB
    cp $ff                                        ; $5CBC
    jr z, jr_006_5cd0                             ; $5CBE

    ldh [hFarcallAArg], a                         ; $5CC0
    ld a, $02                                     ; $5CC2
    ld hl, Photo_GetSramAddress_Far               ; $5CC4
    call Far_Call                                 ; $5CC7
    ld hl, $0e00                                  ; $5CCA
    add hl, bc                                    ; $5CCD
    jr jr_006_5cea                                ; $5CCE

jr_006_5cd0:
    ld a, [wOpt3ToggleB]                          ; $5CD0
    sla a                                         ; $5CD3
    sla a                                         ; $5CD5
    add c                                         ; $5CD7
    ld c, a                                       ; $5CD8
    sla a                                         ; $5CD9
    add c                                         ; $5CDB
    ld c, a                                       ; $5CDC
    ld b, $00                                     ; $5CDD
    ld hl, Mode18_LoadThumb_Tbl5D43               ; $5CDF
    add hl, bc                                    ; $5CE2
    ld c, [hl]                                    ; $5CE3
    inc hl                                        ; $5CE4
    ld b, [hl]                                    ; $5CE5
    inc hl                                        ; $5CE6
    ld a, [hl]                                    ; $5CE7
    ld h, b                                       ; $5CE8
    ld l, c                                       ; $5CE9

jr_006_5cea:
    ld bc, $00c8                                  ; $5CEA
    push af                                       ; $5CED
    call Vram_CopyFromBank                        ; $5CEE
    ld a, e                                       ; $5CF1
    add $08                                       ; $5CF2
    ld e, a                                       ; $5CF4
    jr nc, jr_006_5cf8                            ; $5CF5

    inc d                                         ; $5CF7

jr_006_5cf8:
    ld a, l                                       ; $5CF8
    add $08                                       ; $5CF9
    ld l, a                                       ; $5CFB
    jr nc, jr_006_5cff                            ; $5CFC

    inc h                                         ; $5CFE

jr_006_5cff:
    pop af                                        ; $5CFF
    push af                                       ; $5D00
    ld bc, $0008                                  ; $5D01
    call Vram_CopyFromBank                        ; $5D04
    ld a, e                                       ; $5D07
    add $08                                       ; $5D08
    ld e, a                                       ; $5D0A
    jr nc, jr_006_5d0e                            ; $5D0B

    inc d                                         ; $5D0D

jr_006_5d0e:
    ld a, l                                       ; $5D0E
    add $08                                       ; $5D0F
    ld l, a                                       ; $5D11
    jr nc, jr_006_5d15                            ; $5D12

    inc h                                         ; $5D14

jr_006_5d15:
    pop af                                        ; $5D15
    push af                                       ; $5D16
    ld bc, $0008                                  ; $5D17
    call Vram_CopyFromBank                        ; $5D1A
    ld a, e                                       ; $5D1D
    add $08                                       ; $5D1E
    ld e, a                                       ; $5D20
    jr nc, jr_006_5d24                            ; $5D21

    inc d                                         ; $5D23

jr_006_5d24:
    ld a, l                                       ; $5D24
    add $08                                       ; $5D25
    ld l, a                                       ; $5D27
    jr nc, jr_006_5d2b                            ; $5D28

    inc h                                         ; $5D2A

jr_006_5d2b:
    pop af                                        ; $5D2B
    ld bc, $0008                                  ; $5D2C
    call Vram_CopyFromBank                        ; $5D2F
    ret                                           ; $5D32


; C: 2 sets x 4 words ([$D5EA] x 8 + 2 x thumbnail): the VRAM destination of each thumbnail, $9200 $9300 $9400 $9500 /
; $9500 $8D00 $9600 $8E00; the sources are the records of Mode18_LoadThumb_Tbl5D54 (read 2026-10-19)
Mode18_LoadThumb_Tbl5D33::
    dw $9200
    dw $9300
    dw $9400
    dw $9500
    dw $9500
    dw $8d00
    dw $9600
    dw $8e00

; C: 2 sets x 4 records {lo; hi; bank} (index [$D5EA] x 4 + thumbnail): $C8 B copied to the matching word of
; Mode18_LoadThumb_Tbl5D44: 11:7200 7300 7400 7500 / 11:7500 7D00 7600 7E00 (the Gfx_11_*_Icon06_5D54 rows)
Mode18_LoadThumb_Tbl5D43::
    dwb Gfx_11_7200_Icon06_5D43
    dwb Gfx_11_7300_Icon06_5D43
    dwb Gfx_11_7400_Icon06_5D43
    dwb Gfx_11_7500_Icon06_5D43
    dwb Gfx_11_7500_Icon06_5D43
    dwb Gfx_11_7D00_Icon06_5D43
    dwb Gfx_11_7600_Icon06_5D43
    dwb Gfx_11_7E00_Icon06_5D43

; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (44 hits in 9 runs: 18:00 x28 18:01 x16;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawThumbFrame::
    push af                                       ; $5D5B
    push bc                                       ; $5D5C
    push hl                                       ; $5D5D
    cp $ff                                        ; $5D5E
    jr nz, jr_006_5d90                            ; $5D60

    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c20, $0010 ; $5D62
    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c50, $0010 ; $5D70
    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c60, $0010 ; $5D7E
    pop hl                                        ; $5D8C
    pop bc                                        ; $5D8D
    pop af                                        ; $5D8E
    ret                                           ; $5D8F


jr_006_5d90:
    ld bc, $0000                                  ; $5D90
    cp $1e                                        ; $5D93
    jr c, jr_006_5d9a                             ; $5D95

    sub $1e                                       ; $5D97
    inc b                                         ; $5D99

jr_006_5d9a:
    inc a                                         ; $5D9A

jr_006_5d9b:
    cp $0a                                        ; $5D9B
    jr c, jr_006_5da4                             ; $5D9D

    sub $0a                                       ; $5D9F
    inc c                                         ; $5DA1
    jr jr_006_5d9b                                ; $5DA2

jr_006_5da4:
    push af                                       ; $5DA4
    push bc                                       ; $5DA5
    ld a, b                                       ; $5DA6
    ld hl, Gfx_11_7800_Mode18_State00_Init + $420 ; $5DA7
    ld de, $8c20                                  ; $5DAA
    call Mode18_LoadTileIndexed                   ; $5DAD
    pop bc                                        ; $5DB0
    ld a, c                                       ; $5DB1
    ld hl, Gfx_11_7C40_Mode18_DrawThumbFrame + $10 ; $5DB2
    ld de, $8c50                                  ; $5DB5
    call Mode18_LoadTileIndexed                   ; $5DB8
    pop af                                        ; $5DBB
    ld hl, Gfx_11_7C40_Mode18_DrawThumbFrame + $10 ; $5DBC
    call Mode18_LoadTileIndexed                   ; $5DBF
    pop hl                                        ; $5DC2
    pop bc                                        ; $5DC3
    pop af                                        ; $5DC4
    ret                                           ; $5DC5


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (78 hits in 3 runs: 18:00 x30 18:01 x48;
; tcrf_check/assets/mode_state_wp/)
Mode18_LoadTileIndexed::
    swap a                                        ; $5DC6
    ld c, a                                       ; $5DC8
    ld b, $00                                     ; $5DC9
    add hl, bc                                    ; $5DCB
    ld a, BANK(Gfx_11_7800_Mode18_State00_Init)   ; $5DCC
    ld bc, $0010                                  ; $5DCE
    call Vram_CopyFromBank                        ; $5DD1
    ret                                           ; $5DD4


; C: mode 14: live view and shutter
Mode14_ShootLiveView::
    ld a, [wState]                                ; $5DD5
    rst Rst18_JumpTable                           ; $5DD8

; I: 13 states
Mode14_StateTable::
    dw Mode14_State00_Init
    dw Mode14_State01_LiveView
    dw Mode14_State02_Shutter
    dw Mode14_State03_Shot
    dw Mode14_State04_OptionsPage
    dw Mode14_State05_OptionDither
    dw Mode14_State06_OptionShutterSound
    dw Mode14_State07_OptionPalette
    dw Mode14_State08_OptionFlipEffect
    dw Mode14_State09_LeaveByVariant
    dw Mode14_State0A_ResultPrepare
    dw Mode14_State0B_ResultScreen
    dw Mode14_State0C_Reinit

; C: sets up the live view; the sensor and the options
Mode14_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5DF3
    ldh [hLcdcShadow], a                          ; $5DF5
    ld a, $e4                                     ; $5DF7
    ld [wPaletteTarget], a                        ; $5DF9
    ld [wPaletteTarget + $1], a                   ; $5DFC
    ld a, $d2                                     ; $5DFF
    ld [wPaletteTarget + $2], a                   ; $5E01
    ld a, $10                                     ; $5E04
    ldh [hScxShadow], a                           ; $5E06
    ldh [hScyShadow], a                           ; $5E08
    ldh [hFarcallAArg], a                         ; $5E0A
    farcall Counters_Load_Far                     ; $5E0C
    xor a                                         ; $5E14
    ld [wShootCaptureSel], a                      ; $5E15
    ld [wShootEffectSel], a                       ; $5E18
    ld [wBurstCount], a                           ; $5E1B
    ld a, [wShootVariant]                         ; $5E1E
    cp $0a                                        ; $5E21
    jr z, jr_006_5e31                             ; $5E23

    cp $0b                                        ; $5E25
    jr z, jr_006_5e31                             ; $5E27

    cp $15                                        ; $5E29
    jr z, jr_006_5e31                             ; $5E2B

    ld a, $01                                     ; $5E2D
    jr jr_006_5e33                                ; $5E2F

jr_006_5e31:
    ld a, $02                                     ; $5E31

jr_006_5e33:
    ld [wShootRampSel], a                         ; $5E33
    ld [wCamDitherMode], a                        ; $5E36
    xor a                                         ; $5E39
    ld [wTimerRunning], a                         ; $5E3A
    ld [wShootPhase], a                           ; $5E3D
    ld a, [wIntervalShots]                        ; $5E40
    ld [wShotsLeft], a                            ; $5E43
    call Shoot_ResetTimer                         ; $5E46
    ld hl, wPhotoImage                            ; $5E49
    ld bc, $1000                                  ; $5E4C
    call Mem_Zero                                 ; $5E4F
    ld hl, $8000                                  ; $5E52
    ld bc, $0500                                  ; $5E55
    call Mem_Zero                                 ; $5E58
    ld hl, $8800                                  ; $5E5B
    ld bc, $0100                                  ; $5E5E
    call Mem_Zero                                 ; $5E61
    ld hl, $9000                                  ; $5E64
    ld bc, $0800                                  ; $5E67
    call Mem_Zero                                 ; $5E6A
    ld a, $00                                     ; $5E6D
    ld [rRAMB], a                                 ; $5E6F
    ld hl, $a000                                  ; $5E72
    ld bc, $1000                                  ; $5E75
    call Mem_Zero                                 ; $5E78
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $5E7B
    farcopy Mem_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $5E89
    farcopy Mem_CopyFromBank, Gfx_17_4940_Mode14_State00_Init, $8fd0, $0020 ; $5E97
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $5EA5
    farcopy Mem_CopyFromBank, Gfx_17_4140_Mode14_State00_Init, $8a00, $0040 ; $5EB3
    farcopy Mem_CopyFromBank, Gfx_17_4180_Mode14_State00_Init, $8a40, $0080 ; $5EC1
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $5ECF
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $5EDD
    farcopy Mem_CopyFromBank, Gfx_17_54E0_Mode14_State00_Init, $8740, $0020 ; $5EEB
    farcopy Mem_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $5EF9
    ld hl, $8ff0                                  ; $5F07
    ld bc, $0010                                  ; $5F0A
    ld de, $00ff                                  ; $5F0D
    call Mem_FillWords                            ; $5F10
    ld hl, $9ac0                                  ; $5F13
    ld bc, $0140                                  ; $5F16
    ld a, $ff                                     ; $5F19
    call Mem_FillBc1                              ; $5F1B
    call Shoot_LoadBurstIcons                     ; $5F1E
    call Shoot_LoadEffectGfx                      ; $5F21
    call Shoot_ClearEffectTiles                   ; $5F24
    ld a, $54                                     ; $5F27
    ldh [hLycShadowSplit1], a                     ; $5F29
    ldh [hSplit1Latch], a                         ; $5F2B
    ld hl, hStatShadow                            ; $5F2D
    set 6, [hl]                                   ; $5F30
    ld hl, rIE                                    ; $5F32
    set 1, [hl]                                   ; $5F35
    ld a, $01                                     ; $5F37
    ldh [hStatHandlerIndex], a                    ; $5F39
    screen_on                                     ; $5F3B
    play_music MUSIC_STOP                         ; $5F44
    rst Rst08_WaitVBlank                          ; $5F4B
    call Pal_FadeIn                               ; $5F4C
    ld a, $01                                     ; $5F4F
    ld [wShootInitFlag], a                        ; $5F51
    ld a, $54                                     ; $5F54
    ld [wCamBrightnessSetpoint], a                ; $5F56
    ld a, $08                                     ; $5F59
    ld [wCamContrastRow], a                       ; $5F5B
    call Cam_SetGainContrast                      ; $5F5E
    ld a, $10                                     ; $5F61
    ld [rRAMB], a                                 ; $5F63
    ld a, [wCamA000Shadow]                        ; $5F66
    set 0, a                                      ; $5F69
    ld [$a000], a                                 ; $5F6B
    ld hl, $a000                                  ; $5F6E

jr_006_5f71:
    bit 0, [hl]                                   ; $5F71
    jr nz, jr_006_5f71                            ; $5F73

    next_state                                    ; $5F75
    ret                                           ; $5F79


; C: A far call to bank 0A with gain and contrast row
Cam_SetGainContrast::
    ld a, [wCamContrastRow]                       ; $5F7A
    ld c, a                                       ; $5F7D
    ld a, [wCamGainSel]                           ; $5F7E
    ld b, a                                       ; $5F81
    ldh [hFarcallAArg], a                         ; $5F82
    farcall Cam_FarStub_BuildDitherMatrix         ; $5F84
    ret                                           ; $5F8C


; C: live view loop: brightness; contrast; shutter; options; timer
Mode14_State01_LiveView::
    call Shoot_SetupCapture                       ; $5F8D
    ld a, $10                                     ; $5F90
    ld [rRAMB], a                                 ; $5F92
    ld a, [wCamA000Shadow]                        ; $5F95
    set 0, a                                      ; $5F98
    ld [$a000], a                                 ; $5F9A
    call Shoot_CallVariantHandler                 ; $5F9D
    ld a, [wShootVariant]                         ; $5FA0
    cp $15                                        ; $5FA3
    call z, Img_AndMaskTiles_Bank27               ; $5FA5
    ld a, $00                                     ; $5FA8
    ld hl, wPhotoImage                            ; $5FAA
    ld de, $9000                                  ; $5FAD
    ld bc, $0800                                  ; $5FB0
    call Vram_CopyFromBank                        ; $5FB3
    ld a, $00                                     ; $5FB6
    ld hl, wPhotoImage + $800                     ; $5FB8
    ld de, $8800                                  ; $5FBB
    ld bc, $0100                                  ; $5FBE
    call Vram_CopyFromBank                        ; $5FC1
    ld a, $00                                     ; $5FC4
    ld hl, wPhotoImage + $900                     ; $5FC6
    ld de, $8000                                  ; $5FC9
    ld bc, $0500                                  ; $5FCC
    call Vram_CopyFromBank                        ; $5FCF
    ld a, $10                                     ; $5FD2
    ld [rRAMB], a                                 ; $5FD4

jr_006_5fd7:
    ld hl, $a000                                  ; $5FD7
    bit 0, [hl]                                   ; $5FDA
    jr nz, jr_006_5fd7                            ; $5FDC

    ld a, [wShootVariant]                         ; $5FDE
    cp $13                                        ; $5FE1
    jr c, jr_006_5fef                             ; $5FE3

    cp $15                                        ; $5FE5
    jr z, jr_006_5fef                             ; $5FE7

    ld a, [wBurstCount]                           ; $5FE9
    and a                                         ; $5FEC
    jr nz, jr_006_5ff5                            ; $5FED

jr_006_5fef:
    call Shoot_BrightnessKeys                     ; $5FEF
    call Shoot_DrawBrightnessMark                 ; $5FF2

jr_006_5ff5:
    call Shoot_ContrastKeys                       ; $5FF5
    call Call_006_6275                            ; $5FF8
    call Shoot_DrawVariantIcon                    ; $5FFB
    call Shoot_DrawBurstIcon                      ; $5FFE
    ld a, [wShootVariant]                         ; $6001
    cp $13                                        ; $6004
    jr c, jr_006_6012                             ; $6006

    cp $15                                        ; $6008
    jr z, jr_006_6012                             ; $600A

    ld a, [wBurstCount]                           ; $600C
    and a                                         ; $600F
    jr nz, jr_006_601f                            ; $6010

jr_006_6012:
    ld a, [wCamBrightnessSetpoint]                ; $6012
    ldh [hFarcallAArg], a                         ; $6015
    farcall Cam_FarStub_MainDispatch              ; $6017

jr_006_601f:
    call Shoot_SetCaptureMode                     ; $601F
    ldh a, [hKeysNewSticky]                       ; $6022
    bit PADB_B, a                                 ; $6024
    jr z, jr_006_6035                             ; $6026

    play_sfx1 SFX1_KEY_B                          ; $6028
    set_state STATE_14_LEAVE_BY_VARIANT           ; $602F
    ret                                           ; $6034


jr_006_6035:
    call Shoot_TimerTick                          ; $6035
    ld a, [wTimerRunning]                         ; $6038
    and a                                         ; $603B
    jr z, jr_006_6062                             ; $603C

    call Shoot_LoadVariantScreen                  ; $603E
    ld hl, wTimerFrames                           ; $6041
    ld a, [hl+]                                   ; $6044
    or [hl]                                       ; $6045
    inc hl                                        ; $6046
    or [hl]                                       ; $6047
    jr nz, jr_006_6062                            ; $6048

    call Shoot_DrawShotsLeft                      ; $604A
    call Shoot_PlayShutterSound                   ; $604D
    ld a, [wShootVariant]                         ; $6050
    cp $02                                        ; $6053
    jr nz, jr_006_605d                            ; $6055

    set_state STATE_14_SHOT                       ; $6057
    ret                                           ; $605C


jr_006_605d:
    next_state                                    ; $605D
    ret                                           ; $6061


jr_006_6062:
    ldh a, [hKeysNewSticky]                       ; $6062
    bit PADB_A, a                                 ; $6064
    jp z, Mode14_State01_LiveView_OptionKey       ; $6066

    ld a, [wShootVariant]                         ; $6069
    cp $15                                        ; $606C
    jr z, jr_006_607d                             ; $606E

    ld a, [wPhotoCount]                           ; $6070
    cp $1e                                        ; $6073
    jr c, jr_006_607d                             ; $6075

    set_state STATE_14_RESULT_PREPARE             ; $6077
    ret                                           ; $607C


jr_006_607d:
    ld a, [wShootVariant]                         ; $607D
    and a                                         ; $6080
    jr nz, jr_006_608e                            ; $6081

    call Shoot_DrawShotsLeft                      ; $6083
    call Shoot_PlayShutterSound                   ; $6086
    next_state                                    ; $6089
    ret                                           ; $608D


jr_006_608e:
    cp $01                                        ; $608E
    jr nz, jr_006_60a1                            ; $6090

    ld a, [wTimerRunning]                         ; $6092
    xor $01                                       ; $6095
    ld [wTimerRunning], a                         ; $6097
    ret z                                         ; $609A

    ldh a, [hVblankCounter]                       ; $609B
    ld [wTimerLastVbl], a                         ; $609D
    ret                                           ; $60A0


jr_006_60a1:
    cp $02                                        ; $60A1
    jr nz, jr_006_60c0                            ; $60A3

    ld a, [wShotsLeft]                            ; $60A5
    and a                                         ; $60A8
    ret z                                         ; $60A9

    ld a, $01                                     ; $60AA
    ld [wTimerRunning], a                         ; $60AC
    ldh a, [hVblankCounter]                       ; $60AF
    ld [wTimerLastVbl], a                         ; $60B1
    call Shoot_DrawShotsLeft                      ; $60B4
    call Shoot_PlayShutterSound                   ; $60B7
    set_state STATE_14_SHOT                       ; $60BA
    ret                                           ; $60BF


jr_006_60c0:
    call Shoot_DrawShotsLeft                      ; $60C0
    call Shoot_PlayShutterSound                   ; $60C3
    next_state                                    ; $60C6
    ret                                           ; $60CA


; C: bit 2 of $FFA8: sfx 6, draws the option panel and goes to state 4 (the options page) (branch target; code read
; 2026-10-19)
Mode14_State01_LiveView_OptionKey::
    bit 2, a                                      ; $60CB
    ret z                                         ; $60CD

    play_sfx1 SFX1_KEY_SELECT                     ; $60CE
    call Shoot_DrawOptionPanel                    ; $60D5
    set_state STATE_14_OPTIONS_PAGE               ; $60D8
    ret                                           ; $60DD


; C: auto: 88 bytes, bytes; referenced by Shoot_CallVariantHandler, Shoot_SetupCapture. L3 pass 2026-10-26: read in
; BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_CallVariantHandler_Tbl60DE::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01
    db $02, $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04, $05, $05, $05, $05
    db $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08, $09, $0a, $0b, $0c
    db $00, $0e, $00, $0e, $00, $10, $00, $10, $00, $11, $00, $11, $00, $12, $10, $18
    db $00, $14, $00, $14, $00, $16, $14, $00, $00, $17, $00, $17, $00, $00, $00, $00
    db $00, $00, $00, $00, $09, $0a, $0b, $0c

; C: Up / Down changes the brightness set point
Shoot_BrightnessKeys::
    ldh a, [hKeysHeldSticky]                      ; $6136
    ld b, a                                       ; $6138
    ld a, [wCamBrightnessSetpoint]                ; $6139
    bit 6, b                                      ; $613C
    jr z, jr_006_614e                             ; $613E

    cp $0c                                        ; $6140
    ret z                                         ; $6142

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $6143
    sub $0c                                       ; $614A
    jr jr_006_615d                                ; $614C

jr_006_614e:
    bit 7, b                                      ; $614E
    ret z                                         ; $6150

    cp $c0                                        ; $6151
    ret z                                         ; $6153

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $6154
    add $0c                                       ; $615B

jr_006_615d:
    ld [wCamBrightnessSetpoint], a                ; $615D
    ret                                           ; $6160


; C: Left / Right changes contrast / gain
Shoot_ContrastKeys::
    ldh a, [hKeysRepeatSticky]                    ; $6161
    ld b, a                                       ; $6163
    ld a, [wCamContrastRow]                       ; $6164
    bit 5, b                                      ; $6167
    jr z, jr_006_6178                             ; $6169

    cp $01                                        ; $616B
    ret z                                         ; $616D

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $616E
    dec a                                         ; $6175
    jr jr_006_6186                                ; $6176

jr_006_6178:
    bit 4, b                                      ; $6178
    ret z                                         ; $617A

    cp $10                                        ; $617B
    ret z                                         ; $617D

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $617E
    inc a                                         ; $6185

jr_006_6186:
    ld [wCamContrastRow], a                       ; $6186
    ld c, a                                       ; $6189
    ld a, [wCamGainSel]                           ; $618A
    ld b, a                                       ; $618D
    ldh [hFarcallAArg], a                         ; $618E
    farcall Cam_FarStub_BuildDitherMatrix         ; $6190
    ret                                           ; $6198


; C: photos left as digits
Shoot_DrawShotsLeft::
    ld c, $00                                     ; $6199
    ld a, [wPhotoCount]                           ; $619B
    inc a                                         ; $619E

jr_006_619f:
    cp $0a                                        ; $619F
    jr c, jr_006_61a8                             ; $61A1

    sub $0a                                       ; $61A3
    inc c                                         ; $61A5
    jr jr_006_619f                                ; $61A6

jr_006_61a8:
    push bc                                       ; $61A8
    ld c, a                                       ; $61A9
    ld b, $00                                     ; $61AA
    swap c                                        ; $61AC
    sla c                                         ; $61AE
    rl b                                          ; $61B0
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $61B2
    add hl, bc                                    ; $61B5
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $61B6
    ld de, $8720                                  ; $61B8
    ld bc, $0020                                  ; $61BB
    call Vram_CopyFromBank                        ; $61BE
    pop bc                                        ; $61C1
    ld b, $00                                     ; $61C2
    swap c                                        ; $61C4
    sla c                                         ; $61C6
    rl b                                          ; $61C8
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $61CA
    add hl, bc                                    ; $61CD
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $61CE
    ld de, $8700                                  ; $61D0
    ld bc, $0020                                  ; $61D3
    call Vram_CopyFromBank                        ; $61D6
    ret                                           ; $61D9


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawOptionPanel::
    call Oam_ClearShadow                          ; $61DA
    rst Rst08_WaitVBlank                          ; $61DD
    farcopy Vram_CopyFromBank, Map_24_7960_Shoot_RestoreViewScreen, $9800, $02c0 ; $61DE
    farcopy Vram_CopyFromBank, Gfx_17_4C00_Shoot_DrawOptionPanel, $8900, $0400 ; $61EC
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $61FA
    farcopy Vram_CopyFromBank, Map_24_6E60_Shoot_DrawOptionPanel, $9800, $02c0 ; $6208
    ret                                           ; $6216


; C: tilemap 24:7960 back to the BG
Shoot_RestoreViewScreen::
    call Oam_ClearShadow                          ; $6217
    rst Rst08_WaitVBlank                          ; $621A
    farcopy Vram_CopyFromBank, Map_24_7960_Shoot_RestoreViewScreen, $9800, $02c0 ; $621B
    farcopy Vram_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $6229
    farcopy Vram_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $6237
    call Shoot_ClearEffectTiles                   ; $6245
    farcopy Vram_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $6248
    ret                                           ; $6256


; I
Shoot_DrawBrightnessMark::
    ld a, [wCamBrightnessSetpoint]                ; $6257
    sub $0c                                       ; $625A
    ld l, $dd                                     ; $625C
    call Math_MulAL                               ; $625E
    ld bc, $0100                                  ; $6261
    add hl, bc                                    ; $6264
    srl h                                         ; $6265
    rr l                                          ; $6267
    ld a, h                                       ; $6269
    add $25                                       ; $626A
    ld c, a                                       ; $626C
    ld b, $92                                     ; $626D
    ld a, $36                                     ; $626F
    call Oam_AddMeta_B01_5D2B                     ; $6271
    ret                                           ; $6274


Call_006_6275:
    ld a, [wCamContrastRow]                       ; $6275
    dec a                                         ; $6278
    ld l, $c8                                     ; $6279
    call Math_MulAL                               ; $627B
    ld bc, $0010                                  ; $627E
    add hl, bc                                    ; $6281
    sla l                                         ; $6282
    rl h                                          ; $6284
    sla l                                         ; $6286
    rl h                                          ; $6288
    sla l                                         ; $628A
    rl h                                          ; $628C
    ld a, h                                       ; $628E
    add $25                                       ; $628F
    ld b, a                                       ; $6291
    ld c, $8a                                     ; $6292
    ld a, $35                                     ; $6294
    call Oam_AddMeta_B01_5D2B                     ; $6296
    ret                                           ; $6299


; C: icon of the effect for variants >= 11
Shoot_DrawVariantIcon::
    ld a, [wShootVariant]                         ; $629A
    cp $0b                                        ; $629D
    ret c                                         ; $629F

    sub $0b                                       ; $62A0
    sla a                                         ; $62A2
    ld c, a                                       ; $62A4
    sla a                                         ; $62A5
    add c                                         ; $62A7
    ld c, a                                       ; $62A8
    ld b, $00                                     ; $62A9
    ld hl, Shoot_DrawVariantIcon_Tbl62D9          ; $62AB
    add hl, bc                                    ; $62AE
    ld d, [hl]                                    ; $62AF
    inc hl                                        ; $62B0
    inc hl                                        ; $62B1
    ldh a, [hFrameCounter]                        ; $62B2
    and $01                                       ; $62B4
    ld e, a                                       ; $62B6
    ld c, $01                                     ; $62B7
    call Shoot_DrawIconBits                       ; $62B9
    inc e                                         ; $62BC
    inc e                                         ; $62BD
    call Shoot_DrawIconBits                       ; $62BE
    call Shoot_DrawIconBits                       ; $62C1
    inc e                                         ; $62C4
    inc e                                         ; $62C5

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawIconBits::
    push bc                                       ; $62C6
    ld a, d                                       ; $62C7
    and c                                         ; $62C8
    jr z, jr_006_62d5                             ; $62C9

    ld c, [hl]                                    ; $62CB
    inc hl                                        ; $62CC
    ld b, [hl]                                    ; $62CD
    inc hl                                        ; $62CE
    ld a, $3c                                     ; $62CF
    add e                                         ; $62D1
    call Oam_AddMeta_B01_5D2B                     ; $62D2

jr_006_62d5:
    pop bc                                        ; $62D5
    sla c                                         ; $62D6
    ret                                           ; $62D8


; C: auto: 66 bytes, bytes; referenced by Shoot_DrawVariantIcon. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawVariantIcon_Tbl62D9::
    db $03, $00, $34, $4f, $46, $57, $01, $00, $34, $4f, $00, $00, $02, $00, $46, $57
    db $00, $00, $03, $00, $34, $4f, $46, $57, $03, $00, $34, $4f, $46, $57, $02, $00
    db $5e, $57, $00, $00, $06, $00, $5e, $57, $2e, $57, $08, $00, $47, $50, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $34, $4f
    db $46, $57

; C: L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawBurstIcon::
    ld a, [wShootVariant]                         ; $631B
    cp $13                                        ; $631E
    jr z, jr_006_6327                             ; $6320

    cp $14                                        ; $6322
    jr z, jr_006_6330                             ; $6324

    ret                                           ; $6326


jr_006_6327:
    ld bc, $0848                                  ; $6327
    ld a, $3b                                     ; $632A
    call Oam_AddMeta_B01_5D2B                     ; $632C
    ret                                           ; $632F


jr_006_6330:
    ld bc, $4008                                  ; $6330
    ld a, $3a                                     ; $6333
    call Oam_AddMeta_B01_5D2B                     ; $6335
    ret                                           ; $6338


; C: shutter button / self-timer countdown
Mode14_State02_Shutter::
    call Shoot_DrawTimerJitter                    ; $6339
    ldh a, [hKeysNew]                             ; $633C
    bit PADB_A, a                                 ; $633E
    jr z, jr_006_6366                             ; $6340

    play_sfx1 SFX1_KEY_A                          ; $6342
    xor a                                         ; $6349
    ld [wShootPhase], a                           ; $634A
    call Oam_ClearShadow                          ; $634D
    rst Rst08_WaitVBlank                          ; $6350
    ld a, [wShootVariant]                         ; $6351
    sub $12                                       ; $6354
    jr nc, jr_006_6359                            ; $6356

    xor a                                         ; $6358

jr_006_6359:
    sla a                                         ; $6359
    ld c, a                                       ; $635B
    ld b, $00                                     ; $635C
    ld hl, Mode14_State02_Shutter_JumpTbl638C     ; $635E
    add hl, bc                                    ; $6361
    ld a, [hl+]                                   ; $6362
    ld h, [hl]                                    ; $6363
    ld l, a                                       ; $6364
    jp hl                                         ; $6365


jr_006_6366:
    bit 1, a                                      ; $6366
    ret z                                         ; $6368

    play_sfx1 SFX1_KEY_B                          ; $6369
    ld a, [wShootVariant]                         ; $6370
    cp $01                                        ; $6373
    jr nz, jr_006_6383                            ; $6375

    call Shoot_ResetTimer                         ; $6377
    ldh a, [hVblankCounter]                       ; $637A
    ld [wTimerLastVbl], a                         ; $637C
    xor a                                         ; $637F
    ld [wTimerRunning], a                         ; $6380

jr_006_6383:
    call Shoot_LoadVariantScreen                  ; $6383
    set_state STATE_14_LIVE_VIEW                  ; $6386
    ret                                           ; $638B


; I: auto: 8 bytes, word table; referenced by Mode14_State02_Shutter. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Mode14_State02_Shutter_JumpTbl638C::
    dw Shoot_ShutterVariant0
    dw Shoot_ShutterVariant1
    dw Shoot_ShutterVariant2
    dw Shoot_ShutterVariant3

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant0::
    ldh [hFarcallAArg], a                         ; $6394
    farcall Photo_SaveShot_Far                    ; $6396
    call Snd_PlayTagDigits                        ; $639E
    call Counters_IncTaken                        ; $63A1
    ld a, [wShootVariant]                         ; $63A4
    cp $01                                        ; $63A7
    jr nz, jr_006_63b7                            ; $63A9

    call Shoot_ResetTimer                         ; $63AB
    ldh a, [hVblankCounter]                       ; $63AE
    ld [wTimerLastVbl], a                         ; $63B0
    xor a                                         ; $63B3
    ld [wTimerRunning], a                         ; $63B4

jr_006_63b7:
    call Shoot_LoadVariantScreen                  ; $63B7
    set_state STATE_14_LIVE_VIEW                  ; $63BA
    ret                                           ; $63BF


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant1::
    ldh [hFarcallAArg], a                         ; $63C0
    farcall Photo_SaveShot_Far                    ; $63C2
    call Snd_PlayTagDigits                        ; $63CA
    call Counters_IncTaken                        ; $63CD
    ld a, [wBurstCount]                           ; $63D0
    ld c, a                                       ; $63D3
    ld b, $00                                     ; $63D4
    ld hl, wBurstPhotos                           ; $63D6
    add hl, bc                                    ; $63D9
    ld a, [wPhotoCount]                           ; $63DA
    dec a                                         ; $63DD
    ld [hl], a                                    ; $63DE
    inc c                                         ; $63DF
    ld a, c                                       ; $63E0
    and $03                                       ; $63E1
    ld [wBurstCount], a                           ; $63E3
    call Shoot_LoadVariantScreen                  ; $63E6
    call Shoot_LoadBurstIcons                     ; $63E9
    ld a, [wBurstCount]                           ; $63EC
    and a                                         ; $63EF
    jr z, jr_006_63f8                             ; $63F0

    set_state STATE_14_LIVE_VIEW                  ; $63F2
    ret                                           ; $63F7


jr_006_63f8:
    set_state STATE_14_LEAVE_BY_VARIANT           ; $63F8
    ret                                           ; $63FD


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant2::
    ldh [hFarcallAArg], a                         ; $63FE
    farcall Photo_SaveShot_Far                    ; $6400
    call Snd_PlayTagDigits                        ; $6408
    call Counters_IncTaken                        ; $640B
    ld a, [wBurstCount]                           ; $640E
    ld c, a                                       ; $6411
    ld b, $00                                     ; $6412
    ld hl, wBurstPhotos                           ; $6414
    add hl, bc                                    ; $6417
    ld a, [wPhotoCount]                           ; $6418
    dec a                                         ; $641B
    ld [hl], a                                    ; $641C
    inc c                                         ; $641D
    ld a, c                                       ; $641E
    and $03                                       ; $641F
    ld [wBurstCount], a                           ; $6421
    call Shoot_LoadVariantScreen                  ; $6424
    call Shoot_LoadBurstIcons                     ; $6427
    ld a, [wBurstCount]                           ; $642A
    and a                                         ; $642D
    jr z, jr_006_6436                             ; $642E

    set_state STATE_14_LIVE_VIEW                  ; $6430
    ret                                           ; $6435


jr_006_6436:
    set_state STATE_14_LEAVE_BY_VARIANT           ; $6436
    ret                                           ; $643B


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant3::
    ldh [hFarcallAArg], a                         ; $643C
    farcall GameFace_Store_Far                    ; $643E
    set_state STATE_14_LEAVE_BY_VARIANT           ; $6446
    ret                                           ; $644B


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTimerJitter::
    ldh a, [hFrameCounter]                        ; $644C
    and $01                                       ; $644E
    jr nz, jr_006_645e                            ; $6450

    call Rng_Next                                 ; $6452
    ld [wJitterX], a                              ; $6455
    call Rng_Next                                 ; $6458
    ld [wJitterY], a                              ; $645B

jr_006_645e:
    ld a, [wJitterX]                              ; $645E
    and $01                                       ; $6461
    add $79                                       ; $6463
    ld b, a                                       ; $6465
    ld a, [wShootVariant]                         ; $6466
    cp $0b                                        ; $6469
    jr c, jr_006_647d                             ; $646B

    cp $13                                        ; $646D
    jr c, jr_006_6475                             ; $646F

    cp $15                                        ; $6471
    jr nz, jr_006_647d                            ; $6473

jr_006_6475:
    ld a, [wJitterX]                              ; $6475
    and $01                                       ; $6478
    add $35                                       ; $647A
    ld b, a                                       ; $647C

jr_006_647d:
    ld a, [wJitterY]                              ; $647D
    and $01                                       ; $6480
    add $7d                                       ; $6482
    ld c, a                                       ; $6484
    ld a, $38                                     ; $6485
    call Oam_AddMeta_B01_5D2B                     ; $6487
    ld a, [wJitterY]                              ; $648A
    and $01                                       ; $648D
    add $8d                                       ; $648F
    ld c, a                                       ; $6491
    ld a, $39                                     ; $6492
    call Oam_AddMeta_B01_5D2B                     ; $6494
    ld a, [wShootVariant]                         ; $6497
    cp $15                                        ; $649A
    ret z                                         ; $649C

    ld a, [wJitterX]                              ; $649D
    xor $01                                       ; $64A0
    and $01                                       ; $64A2
    add $34                                       ; $64A4
    ld b, a                                       ; $64A6
    ld a, [wJitterY]                              ; $64A7
    xor $01                                       ; $64AA
    and $01                                       ; $64AC
    add $33                                       ; $64AE
    ld c, a                                       ; $64B0
    ld a, $37                                     ; $64B1
    call Oam_AddMeta_B01_5D2B                     ; $64B3
    ret                                           ; $64B6


; C: a shot was taken: saves and counts
Mode14_State03_Shot::
    call Shoot_DrawShotJitter                     ; $64B7
    call Oam_HideUnused                           ; $64BA
    ld bc, $000a                                  ; $64BD
    call Wait_Frames                              ; $64C0
    call Oam_ClearShadow                          ; $64C3
    rst Rst08_WaitVBlank                          ; $64C6
    ldh [hFarcallAArg], a                         ; $64C7
    farcall Photo_SaveShot_Far                    ; $64C9
    call Counters_IncTaken                        ; $64D1
    ld a, [wShootVariant]                         ; $64D4
    cp $02                                        ; $64D7
    jr nz, jr_006_64ff                            ; $64D9

    ld hl, wShotsLeft                             ; $64DB
    dec [hl]                                      ; $64DE
    jr nz, jr_006_64f5                            ; $64DF

    xor a                                         ; $64E1
    ld [wTimerRunning], a                         ; $64E2
    ld a, [wPhotoCount]                           ; $64E5
    cpl                                           ; $64E8
    add $1f                                       ; $64E9
    ld hl, wIntervalShots                         ; $64EB
    cp [hl]                                       ; $64EE
    jr c, jr_006_64f2                             ; $64EF

    ld a, [hl]                                    ; $64F1

jr_006_64f2:
    ld [wShotsLeft], a                            ; $64F2

jr_006_64f5:
    call Shoot_ResetTimer                         ; $64F5
    ldh a, [hVblankCounter]                       ; $64F8
    ld [wTimerLastVbl], a                         ; $64FA
    jr jr_006_650b                                ; $64FD

jr_006_64ff:
    call Shoot_ResetTimer                         ; $64FF
    ldh a, [hVblankCounter]                       ; $6502
    ld [wTimerLastVbl], a                         ; $6504
    xor a                                         ; $6507
    ld [wTimerRunning], a                         ; $6508

jr_006_650b:
    call Shoot_LoadVariantScreen                  ; $650B
    set_state STATE_14_LIVE_VIEW                  ; $650E
    ret                                           ; $6513


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawShotJitter::
    ldh a, [hFrameCounter]                        ; $6514
    and $01                                       ; $6516
    jr nz, jr_006_6526                            ; $6518

    call Rng_Next                                 ; $651A
    ld [wJitterX], a                              ; $651D
    call Rng_Next                                 ; $6520
    ld [wJitterY], a                              ; $6523

jr_006_6526:
    ld a, [wShootVariant]                         ; $6526
    cp $15                                        ; $6529
    ret z                                         ; $652B

    ld a, [wJitterX]                              ; $652C
    xor $01                                       ; $652F
    and $01                                       ; $6531
    add $34                                       ; $6533
    ld b, a                                       ; $6535
    ld a, [wJitterY]                              ; $6536
    xor $01                                       ; $6539
    and $01                                       ; $653B
    add $33                                       ; $653D
    ld c, a                                       ; $653F
    ld a, $37                                     ; $6540
    call Oam_AddMeta_B01_5D2B                     ; $6542
    ret                                           ; $6545


; C: Start: the options page (flip / palette / dither / shutter)
Mode14_State04_OptionsPage::
    ld a, [wBlinkCounter]                         ; $6546
    inc a                                         ; $6549
    ld [wBlinkCounter], a                         ; $654A
    bit 4, a                                      ; $654D
    jr z, jr_006_6571                             ; $654F

    ld a, $a3                                     ; $6551
    ld bc, $5078                                  ; $6553
    call Oam_AddMeta_B01_4000                     ; $6556
    ld a, $a2                                     ; $6559
    ld bc, $5018                                  ; $655B
    call Oam_AddMeta_B01_4000                     ; $655E
    ld a, $a5                                     ; $6561
    ld bc, $1848                                  ; $6563
    call Oam_AddMeta_B01_4000                     ; $6566
    ld a, $a4                                     ; $6569
    ld bc, $8848                                  ; $656B
    call Oam_AddMeta_B01_4000                     ; $656E

jr_006_6571:
    ldh a, [hKeysNew]                             ; $6571
    and PADF_B | PADF_SELECT                      ; $6573
    jr z, jr_006_6587                             ; $6575

    play_sfx1 SFX1_KEY_B                          ; $6577
    call Shoot_RestoreViewScreen                  ; $657E
    set_state STATE_14_LIVE_VIEW                  ; $6581
    ret                                           ; $6586


jr_006_6587:
    ldh a, [hKeysNewRepeat]                       ; $6587
    and PADF_DPAD                                 ; $6589
    ret z                                         ; $658B

    xor a                                         ; $658C
    ld [wArrowAnimTick], a                        ; $658D
    ld [wArrowAnimFrame], a                       ; $6590
    ldh a, [hKeysNewRepeat]                       ; $6593
    bit PADB_LEFT, a                              ; $6595
    jr z, jr_006_65ec                             ; $6597

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6599
    call Oam_ClearShadow                          ; $65A0
    farcopy Vram_CopyFromBank, Gfx_17_5200_Mode14_State04_OptionsPage, $8d00, $0200 ; $65A3
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $65B1
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $65BF
    ld a, [wShootRampSel]                         ; $65CD
    ld [wChoiceCursorA], a                        ; $65D0
    ld hl, Slide_ScyDeltaTbl                      ; $65D3
    ld b, $10                                     ; $65D6

jr_006_65d8:
    push bc                                       ; $65D8
    push hl                                       ; $65D9
    ldh a, [hScxShadow]                           ; $65DA
    add [hl]                                      ; $65DC
    ldh [hScxShadow], a                           ; $65DD
    rst Rst08_WaitVBlank                          ; $65DF
    pop hl                                        ; $65E0
    pop bc                                        ; $65E1
    inc hl                                        ; $65E2
    dec b                                         ; $65E3
    jr nz, jr_006_65d8                            ; $65E4

    set_state STATE_14_OPTION_DITHER              ; $65E6
    ret                                           ; $65EB


jr_006_65ec:
    bit 4, a                                      ; $65EC
    jr z, jr_006_6643                             ; $65EE

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $65F0
    call Oam_ClearShadow                          ; $65F7
    farcopy Vram_CopyFromBank, Gfx_17_5200_Mode14_State04_OptionsPage, $8d00, $0200 ; $65FA
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $6608
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $6616
    ld a, [wShutterSound]                         ; $6624
    ld [wChoiceCursorA], a                        ; $6627
    ld hl, Slide_ScyDeltaTbl                      ; $662A
    ld b, $10                                     ; $662D

jr_006_662f:
    push bc                                       ; $662F
    push hl                                       ; $6630
    ldh a, [hScxShadow]                           ; $6631
    sub [hl]                                      ; $6633
    ldh [hScxShadow], a                           ; $6634
    rst Rst08_WaitVBlank                          ; $6636
    pop hl                                        ; $6637
    pop bc                                        ; $6638
    inc hl                                        ; $6639
    dec b                                         ; $663A
    jr nz, jr_006_662f                            ; $663B

    set_state STATE_14_OPTION_SHUTTER_SOUND       ; $663D
    ret                                           ; $6642


jr_006_6643:
    bit 6, a                                      ; $6643
    jr z, jr_006_669f                             ; $6645

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $6647
    call Oam_ClearShadow                          ; $664E
    farcopy Vram_CopyFromBank, Gfx_17_5000_Mode14_State04_OptionsPage, $8d00, $0200 ; $6651
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $665F
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $666D
    ld a, [wShootCaptureSel]                      ; $667B
    ld [wChoiceCursorA], a                        ; $667E
    ld hl, Slide_ScyDeltaTbl                      ; $6681
    ld b, $10                                     ; $6684

jr_006_6686:
    push bc                                       ; $6686
    push hl                                       ; $6687
    ldh a, [hScyShadow]                           ; $6688
    add [hl]                                      ; $668A
    ldh [hScyShadow], a                           ; $668B
    cpl                                           ; $668D
    add $64                                       ; $668E
    ldh [hLycShadowSplit1], a                     ; $6690
    rst Rst08_WaitVBlank                          ; $6692
    pop hl                                        ; $6693
    pop bc                                        ; $6694
    inc hl                                        ; $6695
    dec b                                         ; $6696
    jr nz, jr_006_6686                            ; $6697

    set_state STATE_14_OPTION_PALETTE             ; $6699
    ret                                           ; $669E


jr_006_669f:
    bit 7, a                                      ; $669F
    ret z                                         ; $66A1

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $66A2
    call Oam_ClearShadow                          ; $66A9
    farcopy Vram_CopyFromBank, Gfx_17_5000_Mode14_State04_OptionsPage, $8d00, $0200 ; $66AC
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $66BA
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $66C8
    ld a, [wShootEffectSel]                       ; $66D6
    ld [wChoiceCursorA], a                        ; $66D9
    ld hl, Slide_ScyDeltaTbl                      ; $66DC
    ld b, $10                                     ; $66DF

jr_006_66e1:
    push bc                                       ; $66E1
    push hl                                       ; $66E2
    ldh a, [hScyShadow]                           ; $66E3
    sub [hl]                                      ; $66E5
    ldh [hScyShadow], a                           ; $66E6
    cpl                                           ; $66E8
    add $64                                       ; $66E9
    ldh [hLycShadowSplit1], a                     ; $66EB
    rst Rst08_WaitVBlank                          ; $66ED
    pop hl                                        ; $66EE
    pop bc                                        ; $66EF
    inc hl                                        ; $66F0
    dec b                                         ; $66F1
    jr nz, jr_006_66e1                            ; $66F2

    set_state STATE_14_OPTION_FLIP_EFFECT         ; $66F4
    ret                                           ; $66F9


; C
Mode14_State05_OptionDither::
    call Shoot_Options_ReadKeysA                  ; $66FA
    call Shoot_Options_DrawCursorA                ; $66FD
    ldh a, [hKeysNew]                             ; $6700
    and PADF_A | PADF_B | PADF_RIGHT              ; $6702
    ret z                                         ; $6704

    call Snd_KeyBlips                             ; $6705
    push af                                       ; $6708
    bit 0, a                                      ; $6709
    call nz, Shoot_Options_RedrawArrowA           ; $670B
    call Oam_ClearShadow                          ; $670E
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6711
    ld b, $10                                     ; $6714

jr_006_6716:
    push bc                                       ; $6716
    push hl                                       ; $6717
    ldh a, [hScxShadow]                           ; $6718
    sub [hl]                                      ; $671A
    ldh [hScxShadow], a                           ; $671B
    rst Rst08_WaitVBlank                          ; $671D
    pop hl                                        ; $671E
    pop bc                                        ; $671F
    inc hl                                        ; $6720
    dec b                                         ; $6721
    jr nz, jr_006_6716                            ; $6722

    pop af                                        ; $6724
    bit 0, a                                      ; $6725
    jr nz, jr_006_672f                            ; $6727

    set_state STATE_14_OPTIONS_PAGE               ; $6729
    ret                                           ; $672E


jr_006_672f:
    call Shoot_RestoreViewScreen                  ; $672F
    set_state STATE_14_LIVE_VIEW                  ; $6732
    ret                                           ; $6737


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowA::
    ld hl, wArrowAnimFrame                        ; $6738
    inc [hl]                                      ; $673B
    call Oam_HideUnused                           ; $673C
    rst Rst08_WaitVBlank                          ; $673F

jr_006_6740:
    call Shoot_Options_DrawCursorA                ; $6740
    call Oam_HideUnused                           ; $6743
    rst Rst08_WaitVBlank                          ; $6746
    ld a, [wArrowAnimFrame]                       ; $6747
    cp $02                                        ; $674A
    jr nz, jr_006_6740                            ; $674C

    ld a, [wChoiceCursorA]                        ; $674E
    ld hl, wShootRampSel                          ; $6751
    cp [hl]                                       ; $6754
    ret z                                         ; $6755

    ld [hl], a                                    ; $6756
    ld [wCamDitherMode], a                        ; $6757
    ld a, [wCamContrastRow]                       ; $675A
    ld c, a                                       ; $675D
    ld a, [wCamGainSel]                           ; $675E
    ld b, a                                       ; $6761
    ldh [hFarcallAArg], a                         ; $6762
    farcall Cam_FarStub_BuildDitherMatrix         ; $6764
    ret                                           ; $676C


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_ReadKeysA::
    ldh a, [hKeysNewRepeat]                       ; $676D
    ld b, a                                       ; $676F
    ld a, [wChoiceCursorA]                        ; $6770
    bit 6, b                                      ; $6773
    jr z, jr_006_677a                             ; $6775

    xor a                                         ; $6777
    jr jr_006_6792                                ; $6778

jr_006_677a:
    bit 7, b                                      ; $677A
    ret z                                         ; $677C

    ld a, [wShootVariant]                         ; $677D
    cp $0a                                        ; $6780
    jr z, jr_006_6790                             ; $6782

    cp $0b                                        ; $6784
    jr z, jr_006_6790                             ; $6786

    cp $15                                        ; $6788
    jr z, jr_006_6790                             ; $678A

    ld a, $01                                     ; $678C
    jr jr_006_6792                                ; $678E

jr_006_6790:
    ld a, $02                                     ; $6790

jr_006_6792:
    ld hl, wChoiceCursorA                         ; $6792
    cp [hl]                                       ; $6795
    ret z                                         ; $6796

    ld [hl], a                                    ; $6797
    call Snd_KeyBlips                             ; $6798
    ret                                           ; $679B


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_DrawCursorA::
    ld a, [wChoiceCursorA]                        ; $679C
    sla a                                         ; $679F
    ld c, a                                       ; $67A1
    ld b, $00                                     ; $67A2
    ld hl, Shoot_Options_DrawCursorA_Tbl67DA      ; $67A4
    add hl, bc                                    ; $67A7
    ld c, [hl]                                    ; $67A8
    inc hl                                        ; $67A9
    ld b, [hl]                                    ; $67AA
    ld a, [wArrowAnimFrame]                       ; $67AB
    cp $02                                        ; $67AE
    ret z                                         ; $67B0

    sla a                                         ; $67B1
    push bc                                       ; $67B3
    ld c, a                                       ; $67B4
    ld b, $00                                     ; $67B5
    ld hl, Shoot_Options_DrawCursorA_Tbl67E0      ; $67B7
    add hl, bc                                    ; $67BA
    ld a, [hl+]                                   ; $67BB
    pop bc                                        ; $67BC
    push hl                                       ; $67BD
    call Oam_AddMeta_B01_4000                     ; $67BE
    pop hl                                        ; $67C1
    ld a, [wArrowAnimTick]                        ; $67C2
    cp [hl]                                       ; $67C5
    jr nz, jr_006_67d0                            ; $67C6

    ld hl, wArrowAnimFrame                        ; $67C8
    inc [hl]                                      ; $67CB
    xor a                                         ; $67CC
    ld [wArrowAnimTick], a                        ; $67CD

jr_006_67d0:
    ld a, [wArrowAnimFrame]                       ; $67D0
    and a                                         ; $67D3
    ret z                                         ; $67D4

    ld hl, wArrowAnimTick                         ; $67D5
    inc [hl]                                      ; $67D8
    ret                                           ; $67D9


; I: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorA. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Shoot_Options_DrawCursorA_Tbl67DA::
    db $20, $10, $68, $10, $68, $10

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorA. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Shoot_Options_DrawCursorA_Tbl67E0::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode14_State06_OptionShutterSound::
    call Shoot_Options_ReadKeysB                  ; $67E6
    call Shoot_Options_DrawCursorB                ; $67E9
    ldh a, [hKeysNew]                             ; $67EC
    and PADF_A | PADF_B | PADF_LEFT               ; $67EE
    ret z                                         ; $67F0

    push af                                       ; $67F1
    bit 0, a                                      ; $67F2
    jr z, jr_006_67fe                             ; $67F4

    call Shoot_Options_RedrawArrowB               ; $67F6
    call Shoot_PlayShutterSound                   ; $67F9
    jr jr_006_6801                                ; $67FC

jr_006_67fe:
    call Snd_KeyBlips                             ; $67FE

jr_006_6801:
    call Oam_ClearShadow                          ; $6801
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6804
    ld b, $10                                     ; $6807

jr_006_6809:
    push bc                                       ; $6809
    push hl                                       ; $680A
    ldh a, [hScxShadow]                           ; $680B
    add [hl]                                      ; $680D
    ldh [hScxShadow], a                           ; $680E
    rst Rst08_WaitVBlank                          ; $6810
    pop hl                                        ; $6811
    pop bc                                        ; $6812
    inc hl                                        ; $6813
    dec b                                         ; $6814
    jr nz, jr_006_6809                            ; $6815

    pop af                                        ; $6817
    bit 0, a                                      ; $6818
    jr nz, jr_006_6822                            ; $681A

    set_state STATE_14_OPTIONS_PAGE               ; $681C
    ret                                           ; $6821


jr_006_6822:
    call Shoot_RestoreViewScreen                  ; $6822
    set_state STATE_14_LIVE_VIEW                  ; $6825
    ret                                           ; $682A


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowB::
    ld hl, wArrowAnimFrame                        ; $682B
    inc [hl]                                      ; $682E
    call Oam_HideUnused                           ; $682F
    rst Rst08_WaitVBlank                          ; $6832

jr_006_6833:
    call Shoot_Options_DrawCursorB                ; $6833
    call Oam_HideUnused                           ; $6836
    rst Rst08_WaitVBlank                          ; $6839
    ld a, [wArrowAnimFrame]                       ; $683A
    cp $02                                        ; $683D
    jr nz, jr_006_6833                            ; $683F

    ld a, [wChoiceCursorA]                        ; $6841
    ld hl, wShutterSound                          ; $6844
    cp [hl]                                       ; $6847
    ret z                                         ; $6848

    ld [hl], a                                    ; $6849
    ret                                           ; $684A


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysB::
    ldh a, [hKeysNewRepeat]                       ; $684B
    ld b, a                                       ; $684D
    ld a, [wChoiceCursorA]                        ; $684E
    bit 6, b                                      ; $6851
    jr z, jr_006_685a                             ; $6853

    and a                                         ; $6855
    ret z                                         ; $6856

    dec a                                         ; $6857
    jr jr_006_6861                                ; $6858

jr_006_685a:
    bit 7, b                                      ; $685A
    ret z                                         ; $685C

    cp $04                                        ; $685D
    ret z                                         ; $685F

    inc a                                         ; $6860

jr_006_6861:
    ld [wChoiceCursorA], a                        ; $6861
    call Snd_KeyBlips                             ; $6864
    ret                                           ; $6867


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB::
    ld a, [wChoiceCursorA]                        ; $6868
    sla a                                         ; $686B
    ld c, a                                       ; $686D
    ld b, $00                                     ; $686E
    ld hl, Shoot_Options_DrawCursorB_Tbl68A6      ; $6870
    add hl, bc                                    ; $6873
    ld c, [hl]                                    ; $6874
    inc hl                                        ; $6875
    ld b, [hl]                                    ; $6876
    ld a, [wArrowAnimFrame]                       ; $6877
    cp $02                                        ; $687A
    ret z                                         ; $687C

    sla a                                         ; $687D
    push bc                                       ; $687F
    ld c, a                                       ; $6880
    ld b, $00                                     ; $6881
    ld hl, Shoot_Options_DrawCursorB_Tbl68B0      ; $6883
    add hl, bc                                    ; $6886
    ld a, [hl+]                                   ; $6887
    pop bc                                        ; $6888
    push hl                                       ; $6889
    call Oam_AddMeta_B01_4000                     ; $688A
    pop hl                                        ; $688D
    ld a, [wArrowAnimTick]                        ; $688E
    cp [hl]                                       ; $6891
    jr nz, jr_006_689c                            ; $6892

    ld hl, wArrowAnimFrame                        ; $6894
    inc [hl]                                      ; $6897
    xor a                                         ; $6898
    ld [wArrowAnimTick], a                        ; $6899

jr_006_689c:
    ld a, [wArrowAnimFrame]                       ; $689C
    and a                                         ; $689F
    ret z                                         ; $68A0

    ld hl, wArrowAnimTick                         ; $68A1
    inc [hl]                                      ; $68A4
    ret                                           ; $68A5


; C: auto: 10 bytes, bytes; referenced by Shoot_Options_DrawCursorB. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB_Tbl68A6::
    db $18, $90, $30, $90, $48, $90, $60, $90, $78, $90

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorB. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB_Tbl68B0::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode14_State07_OptionPalette::
    call Shoot_Options_ReadKeysC                  ; $68B6
    call Shoot_Options_DrawCursorC                ; $68B9
    ldh a, [hKeysNew]                             ; $68BC
    and PADF_A | PADF_B | PADF_DOWN               ; $68BE
    ret z                                         ; $68C0

    call Snd_KeyBlips                             ; $68C1
    push af                                       ; $68C4
    bit 0, a                                      ; $68C5
    call nz, Shoot_Options_RedrawArrowC           ; $68C7
    call Oam_ClearShadow                          ; $68CA
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $68CD
    ld b, $10                                     ; $68D0

jr_006_68d2:
    push bc                                       ; $68D2
    push hl                                       ; $68D3
    ldh a, [hScyShadow]                           ; $68D4
    sub [hl]                                      ; $68D6
    ldh [hScyShadow], a                           ; $68D7
    cpl                                           ; $68D9
    add $64                                       ; $68DA
    ldh [hLycShadowSplit1], a                     ; $68DC
    rst Rst08_WaitVBlank                          ; $68DE
    pop hl                                        ; $68DF
    pop bc                                        ; $68E0
    inc hl                                        ; $68E1
    dec b                                         ; $68E2
    jr nz, jr_006_68d2                            ; $68E3

    pop af                                        ; $68E5
    bit 0, a                                      ; $68E6
    jr nz, jr_006_68f0                            ; $68E8

    set_state STATE_14_OPTIONS_PAGE               ; $68EA
    ret                                           ; $68EF


jr_006_68f0:
    call Shoot_RestoreViewScreen                  ; $68F0
    set_state STATE_14_LIVE_VIEW                  ; $68F3
    ret                                           ; $68F8


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowC::
    ld hl, wArrowAnimFrame                        ; $68F9
    inc [hl]                                      ; $68FC
    call Oam_HideUnused                           ; $68FD
    rst Rst08_WaitVBlank                          ; $6900

jr_006_6901:
    call Shoot_Options_DrawCursorC                ; $6901
    call Oam_HideUnused                           ; $6904
    rst Rst08_WaitVBlank                          ; $6907
    ld a, [wArrowAnimFrame]                       ; $6908
    cp $02                                        ; $690B
    jr nz, jr_006_6901                            ; $690D

    ld a, [wChoiceCursorA]                        ; $690F
    ld hl, wShootCaptureSel                       ; $6912
    cp [hl]                                       ; $6915
    ret z                                         ; $6916

    ld [hl], a                                    ; $6917
    ret                                           ; $6918


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysC::
    ldh a, [hKeysNewRepeat]                       ; $6919
    ld b, a                                       ; $691B
    ld a, [wChoiceCursorA]                        ; $691C
    bit 5, b                                      ; $691F
    jr z, jr_006_6928                             ; $6921

    and a                                         ; $6923
    ret z                                         ; $6924

    dec a                                         ; $6925
    jr jr_006_692f                                ; $6926

jr_006_6928:
    bit 4, b                                      ; $6928
    ret z                                         ; $692A

    cp $02                                        ; $692B
    ret z                                         ; $692D

    inc a                                         ; $692E

jr_006_692f:
    ld [wChoiceCursorA], a                        ; $692F
    call Snd_KeyBlips                             ; $6932
    call Shoot_SetupCapture                       ; $6935
    call Shoot_CallVariantHandler                 ; $6938
    ld a, [wShootVariant]                         ; $693B
    cp $15                                        ; $693E
    call z, Img_AndMaskTiles_Bank27               ; $6940
    ld a, $00                                     ; $6943
    ld hl, wPhotoImage                            ; $6945
    ld de, $9000                                  ; $6948
    ld bc, $0800                                  ; $694B
    call Vram_CopyFromBank                        ; $694E
    ld a, $00                                     ; $6951
    ld hl, wPhotoImage + $800                     ; $6953
    ld de, $8800                                  ; $6956
    ld bc, $0100                                  ; $6959
    call Vram_CopyFromBank                        ; $695C
    ld a, $00                                     ; $695F
    ld hl, wPhotoImage + $900                     ; $6961
    ld de, $8000                                  ; $6964
    ld bc, $0500                                  ; $6967
    call Vram_CopyFromBank                        ; $696A
    ret                                           ; $696D


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC::
    ld a, [wChoiceCursorA]                        ; $696E
    sla a                                         ; $6971
    ld c, a                                       ; $6973
    ld b, $00                                     ; $6974
    ld hl, Shoot_Options_DrawCursorC_Gfx69AC      ; $6976
    add hl, bc                                    ; $6979
    ld c, [hl]                                    ; $697A
    inc hl                                        ; $697B
    ld b, [hl]                                    ; $697C
    ld a, [wArrowAnimFrame]                       ; $697D
    cp $02                                        ; $6980
    ret z                                         ; $6982

    sla a                                         ; $6983
    push bc                                       ; $6985
    ld c, a                                       ; $6986
    ld b, $00                                     ; $6987
    ld hl, Shoot_Options_DrawCursorC_Tbl69B2      ; $6989
    add hl, bc                                    ; $698C
    ld a, [hl+]                                   ; $698D
    pop bc                                        ; $698E
    push hl                                       ; $698F
    call Oam_AddMeta_B01_4000                     ; $6990
    pop hl                                        ; $6993
    ld a, [wArrowAnimTick]                        ; $6994
    cp [hl]                                       ; $6997
    jr nz, jr_006_69a2                            ; $6998

    ld hl, wArrowAnimFrame                        ; $699A
    inc [hl]                                      ; $699D
    xor a                                         ; $699E
    ld [wArrowAnimTick], a                        ; $699F

jr_006_69a2:
    ld a, [wArrowAnimFrame]                       ; $69A2
    and a                                         ; $69A5
    ret z                                         ; $69A6

    ld hl, wArrowAnimTick                         ; $69A7
    inc [hl]                                      ; $69AA
    ret                                           ; $69AB


; C: auto: 6 bytes, tile data; referenced by Shoot_Options_DrawCursorC. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC_Gfx69AC::
    db $10, $28, $10, $50, $10, $78

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorC. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC_Tbl69B2::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode14_State08_OptionFlipEffect::
    call Shoot_Options_ReadKeysD                  ; $69B8
    call Shoot_Options_DrawCursorD                ; $69BB
    ldh a, [hKeysNew]                             ; $69BE
    and PADF_A | PADF_B | PADF_UP                 ; $69C0
    ret z                                         ; $69C2

    call Snd_KeyBlips                             ; $69C3
    push af                                       ; $69C6
    bit 0, a                                      ; $69C7
    call nz, Shoot_Options_RedrawArrowD           ; $69C9
    call Oam_ClearShadow                          ; $69CC
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $69CF
    ld b, $10                                     ; $69D2

jr_006_69d4:
    push bc                                       ; $69D4
    push hl                                       ; $69D5
    ldh a, [hScyShadow]                           ; $69D6
    add [hl]                                      ; $69D8
    ldh [hScyShadow], a                           ; $69D9
    cpl                                           ; $69DB
    add $64                                       ; $69DC
    ldh [hLycShadowSplit1], a                     ; $69DE
    rst Rst08_WaitVBlank                          ; $69E0
    pop hl                                        ; $69E1
    pop bc                                        ; $69E2
    inc hl                                        ; $69E3
    dec b                                         ; $69E4
    jr nz, jr_006_69d4                            ; $69E5

    pop af                                        ; $69E7
    bit 0, a                                      ; $69E8
    jr nz, jr_006_6a30                            ; $69EA

    set_state STATE_14_OPTIONS_PAGE               ; $69EC
    ld a, [wShootEffectSel]                       ; $69F1
    call Shoot_LoadEffectGfxA                     ; $69F4
    call Shoot_SetupCapture                       ; $69F7
    call Shoot_CallVariantHandler                 ; $69FA
    ld a, [wShootVariant]                         ; $69FD
    cp $15                                        ; $6A00
    call z, Img_AndMaskTiles_Bank27               ; $6A02
    ld a, $00                                     ; $6A05
    ld hl, wPhotoImage                            ; $6A07
    ld de, $9000                                  ; $6A0A
    ld bc, $0800                                  ; $6A0D
    call Vram_CopyFromBank                        ; $6A10
    ld a, $00                                     ; $6A13
    ld hl, wPhotoImage + $800                     ; $6A15
    ld de, $8800                                  ; $6A18
    ld bc, $0100                                  ; $6A1B
    call Vram_CopyFromBank                        ; $6A1E
    ld a, $00                                     ; $6A21
    ld hl, wPhotoImage + $900                     ; $6A23
    ld de, $8000                                  ; $6A26
    ld bc, $0500                                  ; $6A29
    call Vram_CopyFromBank                        ; $6A2C
    ret                                           ; $6A2F


jr_006_6a30:
    call Shoot_RestoreViewScreen                  ; $6A30
    set_state STATE_14_LIVE_VIEW                  ; $6A33
    ret                                           ; $6A38


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowD::
    ld hl, wArrowAnimFrame                        ; $6A39
    inc [hl]                                      ; $6A3C
    call Oam_HideUnused                           ; $6A3D
    rst Rst08_WaitVBlank                          ; $6A40

jr_006_6a41:
    call Shoot_Options_DrawCursorD                ; $6A41
    call Oam_HideUnused                           ; $6A44
    rst Rst08_WaitVBlank                          ; $6A47
    ld a, [wArrowAnimFrame]                       ; $6A48
    cp $02                                        ; $6A4B
    jr nz, jr_006_6a41                            ; $6A4D

    ld a, [wChoiceCursorA]                        ; $6A4F
    ld hl, wShootEffectSel                        ; $6A52
    cp [hl]                                       ; $6A55
    ret z                                         ; $6A56

    ld [hl], a                                    ; $6A57
    ret                                           ; $6A58


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysD::
    ldh a, [hKeysNewRepeat]                       ; $6A59
    ld b, a                                       ; $6A5B
    ld a, [wChoiceCursorA]                        ; $6A5C
    bit 5, b                                      ; $6A5F
    jr z, jr_006_6a68                             ; $6A61

    and a                                         ; $6A63
    ret z                                         ; $6A64

    dec a                                         ; $6A65
    jr jr_006_6a6f                                ; $6A66

jr_006_6a68:
    bit 4, b                                      ; $6A68
    ret z                                         ; $6A6A

    cp $05                                        ; $6A6B
    ret z                                         ; $6A6D

    inc a                                         ; $6A6E

jr_006_6a6f:
    ld [wChoiceCursorA], a                        ; $6A6F
    call Shoot_LoadEffectGfxA                     ; $6A72
    call Snd_KeyBlips                             ; $6A75
    call Shoot_SetupCapture                       ; $6A78
    call Shoot_CallVariantHandler                 ; $6A7B
    ld a, [wShootVariant]                         ; $6A7E
    cp $15                                        ; $6A81
    call z, Img_AndMaskTiles_Bank27               ; $6A83
    ld a, $00                                     ; $6A86
    ld hl, wPhotoImage                            ; $6A88
    ld de, $9000                                  ; $6A8B
    ld bc, $0800                                  ; $6A8E
    call Vram_CopyFromBank                        ; $6A91
    ld a, $00                                     ; $6A94
    ld hl, wPhotoImage + $800                     ; $6A96
    ld de, $8800                                  ; $6A99
    ld bc, $0100                                  ; $6A9C
    call Vram_CopyFromBank                        ; $6A9F
    ld a, $00                                     ; $6AA2
    ld hl, wPhotoImage + $900                     ; $6AA4
    ld de, $8000                                  ; $6AA7
    ld bc, $0500                                  ; $6AAA
    call Vram_CopyFromBank                        ; $6AAD
    ret                                           ; $6AB0


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD::
    ld a, [wChoiceCursorA]                        ; $6AB1
    sla a                                         ; $6AB4
    ld c, a                                       ; $6AB6
    ld b, $00                                     ; $6AB7
    ld hl, Shoot_Options_DrawCursorD_Gfx6AEF      ; $6AB9
    add hl, bc                                    ; $6ABC
    ld c, [hl]                                    ; $6ABD
    inc hl                                        ; $6ABE
    ld b, [hl]                                    ; $6ABF
    ld a, [wArrowAnimFrame]                       ; $6AC0
    cp $02                                        ; $6AC3
    ret z                                         ; $6AC5

    sla a                                         ; $6AC6
    push bc                                       ; $6AC8
    ld c, a                                       ; $6AC9
    ld b, $00                                     ; $6ACA
    ld hl, Shoot_Options_DrawCursorD_Tbl6B23      ; $6ACC
    add hl, bc                                    ; $6ACF
    ld a, [hl+]                                   ; $6AD0
    pop bc                                        ; $6AD1
    push hl                                       ; $6AD2
    call Oam_AddMeta_B01_4000                     ; $6AD3
    pop hl                                        ; $6AD6
    ld a, [wArrowAnimTick]                        ; $6AD7
    cp [hl]                                       ; $6ADA
    jr nz, jr_006_6ae5                            ; $6ADB

    ld hl, wArrowAnimFrame                        ; $6ADD
    inc [hl]                                      ; $6AE0
    xor a                                         ; $6AE1
    ld [wArrowAnimTick], a                        ; $6AE2

jr_006_6ae5:
    ld a, [wArrowAnimFrame]                       ; $6AE5
    and a                                         ; $6AE8
    ret z                                         ; $6AE9

    ld hl, wArrowAnimTick                         ; $6AEA
    inc [hl]                                      ; $6AED
    ret                                           ; $6AEE


; C: auto: 52 bytes, tile data; referenced by Shoot_Options_DrawCursorD. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD_Gfx6AEF::
    db $80, $10, $80, $28, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorD. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD_Tbl6B23::
    db $bc, $10, $bd, $0b, $bd, $ff

; C: mode chosen by shoot_variant
Mode14_State09_LeaveByVariant::
    ld a, [wShootVariant]                         ; $6B29
    sla a                                         ; $6B2C
    ld c, a                                       ; $6B2E
    ld b, $00                                     ; $6B2F
    ld hl, Mode14_State09_LeaveByVariant_Tbl6B4E  ; $6B31
    add hl, bc                                    ; $6B34
    ld a, [hl+]                                   ; $6B35
    ld [wMode], a                                 ; $6B36
    ld a, [hl]                                    ; $6B39
    ld [wState], a                                ; $6B3A
    screen_off                                    ; $6B3D
    stat_irq_off                                  ; $6B43
    ret                                           ; $6B4D


; C: auto: 44 bytes, bytes; referenced by Mode14_State09_LeaveByVariant. L3 pass 2026-10-26: read in BGB in 62
; replay(s) of the organic corpus, modes 01 14 15 16 (tcrf_check/assets/l3_names/)
Mode14_State09_LeaveByVariant_Tbl6B4E::
    db MODE_SHOOT_PARLOR, STATE_01_INTRO, MODE_SELF_TIMER_INTERVAL, STATE_15_TIMER_INIT, MODE_SELF_TIMER_INTERVAL, STATE_15_INTERVAL_INIT, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW
    db MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW
    db MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW

; C
Shoot_LoadBurstIcons::
    ld a, [wBurstCount]                           ; $6B7A
    and a                                         ; $6B7D
    jr nz, jr_006_6b8f                            ; $6B7E

    farcopy Vram_CopyFromBankAuto, Gfx_17_4700_Shoot_LoadBurstIcons, $8500, $0100 ; $6B80
    ret                                           ; $6B8E


jr_006_6b8f:
    cp $01                                        ; $6B8F
    jr nz, jr_006_6bb0                            ; $6B91

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6B93
    farcopy Vram_CopyFromBankAuto, Gfx_17_4740_Shoot_LoadBurstIcons, $8540, $00c0 ; $6BA1
    ret                                           ; $6BAF


jr_006_6bb0:
    cp $02                                        ; $6BB0
    jr nz, jr_006_6bdf                            ; $6BB2

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6BB4
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6BC2
    farcopy Vram_CopyFromBankAuto, Gfx_17_4780_Shoot_LoadBurstIcons, $8580, $0080 ; $6BD0
    ret                                           ; $6BDE


jr_006_6bdf:
    cp $03                                        ; $6BDF
    jr nz, jr_006_6c1c                            ; $6BE1

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6BE3
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6BF1
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8580, $0040 ; $6BFF
    farcopy Vram_CopyFromBankAuto, Gfx_17_47C0_Shoot_LoadBurstIcons, $85c0, $0040 ; $6C0D
    ret                                           ; $6C1B


jr_006_6c1c:
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6C1C
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6C2A
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8580, $0040 ; $6C38
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $85c0, $0040 ; $6C46
    ret                                           ; $6C54


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfx::
    ld a, [wShootEffectSel]                       ; $6C55

; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfxA::
    ld c, a                                       ; $6C58
    sla a                                         ; $6C59
    sla a                                         ; $6C5B
    add c                                         ; $6C5D
    ld c, a                                       ; $6C5E
    ld b, $00                                     ; $6C5F
    ld hl, Shoot_LoadEffectGfxA_Tbl6C78           ; $6C61
    add hl, bc                                    ; $6C64
    ld de, wShootFxVector                         ; $6C65
    ld a, [hl+]                                   ; $6C68
    ld [de], a                                    ; $6C69
    inc de                                        ; $6C6A
    ld a, [hl+]                                   ; $6C6B
    ld [de], a                                    ; $6C6C
    inc de                                        ; $6C6D
    ld a, [hl+]                                   ; $6C6E
    ld [de], a                                    ; $6C6F
    inc de                                        ; $6C70
    ld a, [hl+]                                   ; $6C71
    ld [de], a                                    ; $6C72
    inc de                                        ; $6C73
    ld a, [hl+]                                   ; $6C74
    ld [de], a                                    ; $6C75
    inc de                                        ; $6C76
    ret                                           ; $6C77


; C: auto: 120 bytes, bytes; referenced by Shoot_LoadEffectGfxA. L3 pass 2026-10-26: read in BGB in 72 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfxA_Tbl6C78::
    db $00, $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $ff, $ff, $00, $00, $ff, $00
    db $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00, $ff
    db $00, $00, $00, $ff, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00
    db $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $ff, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $ff, $ff, $00, $00, $00, $ff, $00, $00, $ff, $ff, $00, $00, $00, $ff
    db $00, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00, $ff, $ff, $ff
    db $ff, $00, $ff, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $ff, $00, $ff

; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_ClearEffectTiles::
    call Shoot_ClearVram8900                      ; $6CF0

; C: tiles of the shoot variant (burst / timer / interval)
Shoot_LoadVariantScreen::
    ld a, [wShootVariant]                         ; $6CF3
    cp $13                                        ; $6CF6
    jr nz, jr_006_6d09                            ; $6CF8

    ld a, [wBurstCount]                           ; $6CFA
    and a                                         ; $6CFD
    jr nz, jr_006_6d05                            ; $6CFE

    call Shoot_ClearVram8900Small                 ; $6D00
    jr jr_006_6d19                                ; $6D03

jr_006_6d05:
    call Shoot_LoadBurstPhoto                     ; $6D05
    ret                                           ; $6D08


jr_006_6d09:
    cp $14                                        ; $6D09
    ld a, [wBurstCount]                           ; $6D0B
    and a                                         ; $6D0E
    jr nz, jr_006_6d16                            ; $6D0F

    call Shoot_ClearVram8B00                      ; $6D11
    jr jr_006_6d19                                ; $6D14

jr_006_6d16:
    call Shoot_LoadBurstPhotoB                    ; $6D16

jr_006_6d19:
    call Shoot_LoadTimerScreen                    ; $6D19
    ld a, [wShootVariant]                         ; $6D1C
    cp $15                                        ; $6D1F
    call nz, Shoot_DrawPhotosLeft                 ; $6D21
    ld a, [wShootVariant]                         ; $6D24
    and a                                         ; $6D27
    jr z, jr_006_6d2f                             ; $6D28

    cp $03                                        ; $6D2A
    call c, Shoot_DrawTimerMinutes                ; $6D2C

jr_006_6d2f:
    ld a, [wShootVariant]                         ; $6D2F
    cp $02                                        ; $6D32
    call z, Shoot_DrawShotsLeftTimer              ; $6D34
    ret                                           ; $6D37


; C: $F0 tiles of $FF. L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Shoot_ClearVram8900::
    ld hl, $ff40                                  ; $6D38
    bit 7, [hl]                                   ; $6D3B
    jr nz, jr_006_6d4e                            ; $6D3D

    ld hl, $8900                                  ; $6D3F
    ld a, $ff                                     ; $6D42
    ld b, $f0                                     ; $6D44

jr_006_6d46:
    ld [hl+], a                                   ; $6D46
    ld [hl+], a                                   ; $6D47
    ld [hl+], a                                   ; $6D48
    ld [hl+], a                                   ; $6D49
    dec b                                         ; $6D4A
    jr nz, jr_006_6d46                            ; $6D4B

    ret                                           ; $6D4D


jr_006_6d4e:
    ld a, $00                                     ; $6D4E
    ld hl, $8900                                  ; $6D50
    ld bc, $03c0                                  ; $6D53
    call Vram_FillFFSafe                          ; $6D56
    ret                                           ; $6D59


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_ClearVram8900Small::
    ld hl, $ff40                                  ; $6D5A
    bit 7, [hl]                                   ; $6D5D
    jr nz, jr_006_6d78                            ; $6D5F

    ld hl, $8900                                  ; $6D61
    ld a, $ff                                     ; $6D64
    ld b, $02                                     ; $6D66

jr_006_6d68:
    ld c, $28                                     ; $6D68

jr_006_6d6a:
    ld [hl+], a                                   ; $6D6A
    ld [hl+], a                                   ; $6D6B
    ld [hl+], a                                   ; $6D6C
    ld [hl+], a                                   ; $6D6D
    dec c                                         ; $6D6E
    jr nz, jr_006_6d6a                            ; $6D6F

    ld hl, $8a00                                  ; $6D71
    dec b                                         ; $6D74
    jr nz, jr_006_6d68                            ; $6D75

    ret                                           ; $6D77


jr_006_6d78:
    ld a, $00                                     ; $6D78
    ld hl, $8900                                  ; $6D7A
    ld bc, $00a0                                  ; $6D7D
    call Vram_FillFFSafe                          ; $6D80
    ld a, $00                                     ; $6D83
    ld hl, $8a00                                  ; $6D85
    ld bc, $00a0                                  ; $6D88
    call Vram_FillFFSafe                          ; $6D8B
    ret                                           ; $6D8E


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_ClearVram8B00::
    ld hl, $ff40                                  ; $6D8F
    bit 7, [hl]                                   ; $6D92
    jr nz, jr_006_6da5                            ; $6D94

    ld hl, $8b00                                  ; $6D96
    ld a, $ff                                     ; $6D99
    ld b, $70                                     ; $6D9B

jr_006_6d9d:
    ld [hl+], a                                   ; $6D9D
    ld [hl+], a                                   ; $6D9E
    ld [hl+], a                                   ; $6D9F
    ld [hl+], a                                   ; $6DA0
    dec b                                         ; $6DA1
    jr nz, jr_006_6d9d                            ; $6DA2

    ret                                           ; $6DA4


jr_006_6da5:
    ld a, $00                                     ; $6DA5
    ld hl, $8b00                                  ; $6DA7
    ld bc, $01c0                                  ; $6DAA
    call Vram_FillFFSafe                          ; $6DAD
    ret                                           ; $6DB0


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_LoadBurstPhoto::
    ld a, [wBurstCount]                           ; $6DB1
    dec a                                         ; $6DB4
    and $03                                       ; $6DB5
    ld c, a                                       ; $6DB7
    ld b, $00                                     ; $6DB8
    ld hl, wBurstPhotos                           ; $6DBA
    add hl, bc                                    ; $6DBD
    ld a, [hl]                                    ; $6DBE
    ldh [hFarcallAArg], a                         ; $6DBF
    ld a, $02                                     ; $6DC1
    ld hl, Photo_GetSramAddress_Far               ; $6DC3
    call Far_Call                                 ; $6DC6
    ld hl, $0c00                                  ; $6DC9
    add hl, bc                                    ; $6DCC
    ld de, $8900                                  ; $6DCD
    ld bc, $0200                                  ; $6DD0
    call Vram_CopyFromBankAuto                    ; $6DD3
    ret                                           ; $6DD6


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_LoadBurstPhotoB::
    ld a, [wBurstCount]                           ; $6DD7
    dec a                                         ; $6DDA
    and $03                                       ; $6DDB
    ld c, a                                       ; $6DDD
    ld b, $00                                     ; $6DDE
    ld hl, wBurstPhotos                           ; $6DE0
    add hl, bc                                    ; $6DE3
    ld a, [hl]                                    ; $6DE4
    ldh [hFarcallAArg], a                         ; $6DE5
    ld a, $02                                     ; $6DE7
    ld hl, Photo_GetSramAddress_Far               ; $6DE9
    call Far_Call                                 ; $6DEC
    ld hl, $00e0                                  ; $6DEF
    add hl, bc                                    ; $6DF2
    ld de, $8b00                                  ; $6DF3
    ld b, $0e                                     ; $6DF6

jr_006_6df8:
    push af                                       ; $6DF8
    push bc                                       ; $6DF9
    ld bc, $0020                                  ; $6DFA
    call Vram_CopyFromBankAuto                    ; $6DFD
    ld bc, $00e0                                  ; $6E00
    add hl, bc                                    ; $6E03
    pop bc                                        ; $6E04
    pop af                                        ; $6E05
    dec b                                         ; $6E06
    jr nz, jr_006_6df8                            ; $6E07

    ret                                           ; $6E09


; C: timer / counter text of the variant
Shoot_LoadTimerScreen::
    ld a, [wShootVariant]                         ; $6E0A
    sla a                                         ; $6E0D
    ld c, a                                       ; $6E0F
    ld b, $00                                     ; $6E10
    ld hl, Shoot_LoadTimerScreen_Tbl6E36          ; $6E12
    add hl, bc                                    ; $6E15
    ld a, [hl+]                                   ; $6E16
    ld h, [hl]                                    ; $6E17
    ld l, a                                       ; $6E18

jr_006_6e19:
    ld a, [hl+]                                   ; $6E19
    cp $ff                                        ; $6E1A
    ret z                                         ; $6E1C

    push hl                                       ; $6E1D
    ld c, a                                       ; $6E1E
    ld b, [hl]                                    ; $6E1F
    inc hl                                        ; $6E20
    push bc                                       ; $6E21
    ld a, [hl+]                                   ; $6E22
    ld e, [hl]                                    ; $6E23
    inc hl                                        ; $6E24
    ld d, [hl]                                    ; $6E25
    inc hl                                        ; $6E26
    ld c, [hl]                                    ; $6E27
    inc hl                                        ; $6E28
    ld b, [hl]                                    ; $6E29
    inc hl                                        ; $6E2A
    pop hl                                        ; $6E2B
    call Vram_CopyFromBankAuto                    ; $6E2C
    pop hl                                        ; $6E2F
    ld bc, $0006                                  ; $6E30
    add hl, bc                                    ; $6E33
    jr jr_006_6e19                                ; $6E34

; I: auto: 514 bytes, bytes; referenced by Shoot_LoadTimerScreen | 22 words 6E5E, 6E6D, 6E8A ... 70A3 (the last two
; words of the old reading, 4180 and A017, belong to the next bytes); the lists they point to run from 6E5E to 70B2
; (the labels at 7034 and 706C were `ld bc` sprite positions of ...
Shoot_LoadTimerScreen_Tbl6E36::
    dw Shoot_LoadTimerScreen_Tbl6E36 + $2C
    dw Shoot_LoadTimerScreen_Tbl6E36 + $3B
    dw Shoot_LoadTimerScreen_Tbl6E36 + $58
    dw Shoot_LoadTimerScreen_Tbl6E36 + $83
    dw Shoot_LoadTimerScreen_Tbl6E36 + $A0
    dw Shoot_LoadTimerScreen_Tbl6E36 + $BD
    dw Shoot_LoadTimerScreen_Tbl6E36 + $DA
    dw Shoot_LoadTimerScreen_Tbl6E36 + $F7
    dw Shoot_LoadTimerScreen_Tbl6E36 + $114
    dw Shoot_LoadTimerScreen_Tbl6E36 + $131
    dw Shoot_LoadTimerScreen_Tbl6E36 + $14E
    dw Shoot_LoadTimerScreen_Tbl6E36 + $16B
    dw Shoot_LoadTimerScreen_Tbl6E36 + $188
    dw Shoot_LoadTimerScreen_Tbl6E36 + $1A5
    dw Shoot_LoadTimerScreen_Tbl6E36 + $1C2
    dw Shoot_LoadTimerScreen_Tbl6E36 + $1DF
    dw Shoot_LoadTimerScreen_Tbl6E36 + $1FC
    dw Shoot_LoadTimerScreen_Tbl6E36 + $219
    dw Shoot_LoadTimerScreen_Tbl6E36 + $236
    dw Shoot_LoadTimerScreen_Tbl6E36 + $253
    dw Shoot_LoadTimerScreen_Tbl6E36 + $262
    dw Shoot_LoadTimerScreen_Tbl6E36 + $271

    db $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $ff, $90
    db $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $40, $41, $17
    db $50, $89, $20, $00, $60, $41, $17, $50, $8a, $20, $00, $ff, $90, $41, $17, $d0
    db $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $40, $41, $17, $50, $89, $20
    db $00, $60, $41, $17, $50, $8a, $20, $00, $00, $42, $17, $00, $89, $20, $00, $20
    db $42, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41
    db $17, $d0, $8a, $30, $00, $40, $42, $17, $00, $89, $20, $00, $60, $42, $17, $00
    db $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a
    db $30, $00, $80, $42, $17, $00, $89, $20, $00, $a0, $42, $17, $00, $8a, $20, $00
    db $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $c0
    db $42, $17, $00, $89, $20, $00, $e0, $42, $17, $00, $8a, $20, $00, $ff, $90, $41
    db $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $00, $43, $17, $00
    db $89, $20, $00, $20, $43, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89
    db $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $40, $43, $17, $00, $89, $20, $00
    db $60, $43, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0
    db $41, $17, $d0, $8a, $30, $00, $80, $43, $17, $00, $89, $20, $00, $a0, $43, $17
    db $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0
    db $8a, $30, $00, $c0, $43, $17, $00, $89, $20, $00, $e0, $43, $17, $00, $8a, $20
    db $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00
    db $00, $44, $17, $00, $89, $20, $00, $20, $44, $17, $00, $8a, $20, $00, $ff, $90
    db $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $40, $44, $17
    db $00, $89, $20, $00, $60, $44, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0
    db $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $80, $44, $17, $00, $89, $20
    db $00, $a0, $44, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00
    db $d0, $41, $17, $d0, $8a, $30, $00, $c0, $44, $17, $00, $89, $20, $00, $e0, $44
    db $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17
    db $d0, $8a, $30, $00, $00, $45, $17, $00, $89, $20, $00, $20, $45, $17, $00, $8a
    db $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30
    db $00, $40, $45, $17, $00, $89, $20, $00, $60, $45, $17, $00, $8a, $20, $00, $ff
    db $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $80, $45
    db $17, $00, $89, $20, $00, $a0, $45, $17, $00, $8a, $20, $00, $ff, $90, $41, $17
    db $d0, $89, $30, $00, $d0, $41, $17, $d0, $8a, $30, $00, $c0, $45, $17, $00, $89
    db $20, $00, $e0, $45, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30
    db $00, $d0, $41, $17, $d0, $8a, $30, $00, $00, $46, $17, $00, $89, $20, $00, $20
    db $46, $17, $00, $8a, $20, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41
    db $17, $d0, $8a, $30, $00, $ff, $90, $41, $17, $d0, $89, $30, $00, $d0, $41, $17
    db $d0, $8a, $30, $00, $ff, $40, $46, $17, $00, $89, $20, $00, $60, $46, $17, $00
    db $8a, $20, $00, $ff

; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawPhotosLeft::
    ld a, [wPhotoCount]                           ; $70B6
    cpl                                           ; $70B9
    add $1f                                       ; $70BA
    ld c, $00                                     ; $70BC

jr_006_70be:
    cp $0a                                        ; $70BE
    jr c, jr_006_70c7                             ; $70C0

    sub $0a                                       ; $70C2
    inc c                                         ; $70C4
    jr jr_006_70be                                ; $70C5

jr_006_70c7:
    ld de, $89b0                                  ; $70C7
    call Shoot_DrawTwoDigitsAt                    ; $70CA
    ret                                           ; $70CD


; C: L3 pass 2026-10-26: executed in BGB in 21 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTimerMinutes::
    ld a, [wTimerMinutes]                         ; $70CE
    and a                                         ; $70D1
    jr nz, jr_006_70e7                            ; $70D2

    farcopy Vram_CopyFromBankAuto, Gfx_17_4950_Shoot_DrawTimerMinutes, $8a90, $0010 ; $70D4
    ld a, [wTimerSeconds]                         ; $70E2
    jr jr_006_70f8                                ; $70E5

jr_006_70e7:
    farcopy Vram_CopyFromBankAuto, Gfx_17_4BE0_Shoot_DrawTimerMinutes, $8a90, $0010 ; $70E7
    ld a, [wTimerMinutes]                         ; $70F5

jr_006_70f8:
    ld c, $00                                     ; $70F8

jr_006_70fa:
    cp $0a                                        ; $70FA
    jr c, jr_006_7103                             ; $70FC

    sub $0a                                       ; $70FE
    inc c                                         ; $7100
    jr jr_006_70fa                                ; $7101

jr_006_7103:
    ld de, $8970                                  ; $7103
    call Shoot_DrawTwoDigitsAt                    ; $7106
    ret                                           ; $7109


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawShotsLeftTimer::
    ld a, [wShotsLeft]                            ; $710A
    ld c, $00                                     ; $710D

jr_006_710f:
    cp $0a                                        ; $710F
    jr c, jr_006_7118                             ; $7111

    sub $0a                                       ; $7113
    inc c                                         ; $7115
    jr jr_006_710f                                ; $7116

jr_006_7118:
    ld de, $8920                                  ; $7118
    call Shoot_DrawTwoDigitsAt                    ; $711B
    ret                                           ; $711E


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTwoDigitsAt::
    push af                                       ; $711F
    ld a, c                                       ; $7120
    call Shoot_DrawDigitAt                        ; $7121
    pop af                                        ; $7124
    call Shoot_DrawDigitAt                        ; $7125
    ret                                           ; $7128


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawDigitAt::
    ld c, a                                       ; $7129
    ld b, $00                                     ; $712A
    swap c                                        ; $712C
    sla c                                         ; $712E
    rl b                                          ; $7130
    ld hl, Gfx_17_4000_Shoot_DrawDigitAt_Digits   ; $7132
    add hl, bc                                    ; $7135
    ld a, BANK(Gfx_17_4000_Shoot_DrawDigitAt_Digits) ; $7136
    ld bc, $0010                                  ; $7138
    push de                                       ; $713B
    call Shoot_CopyTileSafe                       ; $713C
    pop de                                        ; $713F
    inc d                                         ; $7140
    ld a, $17                                     ; $7141
    ld bc, $0010                                  ; $7143
    call Shoot_CopyTileSafe                       ; $7146
    dec d                                         ; $7149
    ret                                           ; $714A


; C: copies when the LCD is on; safe copy otherwise. L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_CopyTileSafe::
    push hl                                       ; $714B
    ld hl, $ff40                                  ; $714C
    bit 7, [hl]                                   ; $714F
    jr nz, jr_006_7158                            ; $7151

    pop hl                                        ; $7153
    call Mem_CopyFromBank                         ; $7154
    ret                                           ; $7157


jr_006_7158:
    pop hl                                        ; $7158
    call Vram_CopyFromBank                        ; $7159
    ret                                           ; $715C


; C: timer frames / seconds / minutes / beep accumulator = 0
Shoot_ResetTimer::
    xor a                                         ; $715D
    ld [wTimerFrames], a                          ; $715E
    ld [wTimerSeconds], a                         ; $7161
    ld [wTimerMinutes], a                         ; $7164
    ld [wTimerBeepAcc], a                         ; $7167
    ld a, [wShootVariant]                         ; $716A
    cp $02                                        ; $716D
    jr z, jr_006_7178                             ; $716F

    ld a, [wSelftimerDelay]                       ; $7171
    ld [wTimerSeconds], a                         ; $7174
    ret                                           ; $7177


jr_006_7178:
    ld a, [wIntervalIndex]                        ; $7178
    cp $19                                        ; $717B
    jr c, jr_006_718d                             ; $717D

    sub $19                                       ; $717F
    ld c, a                                       ; $7181
    ld b, $00                                     ; $7182
    ld hl, Shoot_ResetTimer_Tbl719D               ; $7184
    add hl, bc                                    ; $7187
    ld a, [hl]                                    ; $7188
    ld [wTimerMinutes], a                         ; $7189
    ret                                           ; $718C


jr_006_718d:
    cp $0f                                        ; $718D
    jr c, jr_006_7199                             ; $718F

    ld c, a                                       ; $7191
    sla a                                         ; $7192
    sla a                                         ; $7194
    add c                                         ; $7196
    sub $3c                                       ; $7197

jr_006_7199:
    ld [wTimerSeconds], a                         ; $7199
    ret                                           ; $719C


; C: auto: 5 bytes, bytes; referenced by Shoot_ResetTimer. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 14)
Shoot_ResetTimer_Tbl719D::
    db $05, $0a, $0f, $1e, $3c

; C: L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_SetCaptureMode::
    ld a, [wShootVariant]                         ; $71A2
    ld c, $01                                     ; $71A5
    cp $0c                                        ; $71A7
    jr z, jr_006_71e8                             ; $71A9

    cp $0d                                        ; $71AB
    jr z, jr_006_71e8                             ; $71AD

    cp $0e                                        ; $71AF
    jr z, jr_006_71e8                             ; $71B1

    cp $10                                        ; $71B3
    jr z, jr_006_71e8                             ; $71B5

    cp $12                                        ; $71B7
    jr z, jr_006_71e8                             ; $71B9

    ld c, $02                                     ; $71BB
    cp $11                                        ; $71BD
    jr z, jr_006_71e8                             ; $71BF

    ld c, $03                                     ; $71C1
    cp $0b                                        ; $71C3
    jr z, jr_006_71e8                             ; $71C5

    cp $0f                                        ; $71C7
    jr z, jr_006_71e8                             ; $71C9

    cp $15                                        ; $71CB
    jr z, jr_006_71e8                             ; $71CD

    ret                                           ; $71CF


; I: UNREFERENCED
Unused_Shoot_TimerKeys::
    ldh a, [hVblankCounter]                       ; $71D0
    ld hl, wTimerLastVbl                          ; $71D2
    sub [hl]                                      ; $71D5
    sub $0f                                       ; $71D6
    ret c                                         ; $71D8

    ld c, a                                       ; $71D9
    ldh a, [hVblankCounter]                       ; $71DA
    sub c                                         ; $71DC
    ld [hl], a                                    ; $71DD
    ld a, [wShootPhase]                           ; $71DE
    inc a                                         ; $71E1
    and $03                                       ; $71E2
    ld [wShootPhase], a                           ; $71E4
    ret                                           ; $71E7


jr_006_71e8:
    ldh a, [hKeysNewSticky]                       ; $71E8
    ld b, a                                       ; $71EA
    ld a, [wShootPhase]                           ; $71EB
    bit 1, b                                      ; $71EE
    jr z, jr_006_71fe                             ; $71F0

    and a                                         ; $71F2
    ret z                                         ; $71F3

    play_sfx1 SFX1_KEY_B                          ; $71F4
    dec a                                         ; $71FB
    jr jr_006_7209                                ; $71FC

jr_006_71fe:
    bit 0, b                                      ; $71FE
    ret z                                         ; $7200

    cp c                                          ; $7201
    ret z                                         ; $7202

    push af                                       ; $7203
    call Shoot_PlayShutterSound                   ; $7204
    pop af                                        ; $7207
    inc a                                         ; $7208

jr_006_7209:
    ld [wShootPhase], a                           ; $7209
    xor a                                         ; $720C
    ldh [hKeysNewSticky], a                       ; $720D
    ldh [hKeysNew], a                             ; $720F
    ret                                           ; $7211


; C: counts frames; seconds; minutes and plays the beeps
Shoot_TimerTick::
    ld a, [wTimerRunning]                         ; $7212
    and a                                         ; $7215
    ret z                                         ; $7216

    ldh a, [hVblankCounter]                       ; $7217
    push af                                       ; $7219
    ld hl, wTimerLastVbl                          ; $721A
    sub [hl]                                      ; $721D
    ld c, a                                       ; $721E
    pop af                                        ; $721F
    ld [hl], a                                    ; $7220
    ld hl, wTimerFrames                           ; $7221
    ld a, [hl+]                                   ; $7224
    or [hl]                                       ; $7225
    inc hl                                        ; $7226
    or [hl]                                       ; $7227
    ret z                                         ; $7228

    ld a, [wTimerBeepAcc]                         ; $7229
    add c                                         ; $722C
    cp $0f                                        ; $722D
    jr c, jr_006_7239                             ; $722F

    play_sfx1 SFX1_BEEP_REFUSED                   ; $7231
    xor a                                         ; $7238

jr_006_7239:
    ld [wTimerBeepAcc], a                         ; $7239
    ld hl, wTimerFrames                           ; $723C
    ld a, [hl]                                    ; $723F
    sub c                                         ; $7240
    ld [hl], a                                    ; $7241
    ret nc                                        ; $7242

    add $3c                                       ; $7243
    ld [hl+], a                                   ; $7245
    dec [hl]                                      ; $7246
    bit 7, [hl]                                   ; $7247
    ret z                                         ; $7249

    ld a, [hl]                                    ; $724A
    add $3c                                       ; $724B
    ld [hl+], a                                   ; $724D
    dec [hl]                                      ; $724E
    bit 7, [hl]                                   ; $724F
    ret z                                         ; $7251

    xor a                                         ; $7252
    ld [wTimerFrames], a                          ; $7253
    ld [wTimerSeconds], a                         ; $7256
    ld [wTimerMinutes], a                         ; $7259
    ret                                           ; $725C


; C
Mode14_State0A_ResultPrepare::
    screen_off                                    ; $725D
    stat_irq_off                                  ; $7263
    xor a                                         ; $726D
    ld [wSubstate], a                             ; $726E
    ld a, $0d                                     ; $7271
    ld [wResultMsgId], a                          ; $7273
    next_state                                    ; $7276
    ret                                           ; $727A


; C: far call 09:7290
Mode14_State0B_ResultScreen::
    ldh [hFarcallAArg], a                         ; $727B
    farcall ResultScreen_Far                      ; $727D
    ret                                           ; $7285


; C
Mode14_State0C_Reinit::
    xor a                                         ; $7286
    ld [wTimerRunning], a                         ; $7287
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $728A
    ldh [hLcdcShadow], a                          ; $728C
    ld a, $e4                                     ; $728E
    ld [wPaletteTarget], a                        ; $7290
    ld [wPaletteTarget + $1], a                   ; $7293
    ld a, $d2                                     ; $7296
    ld [wPaletteTarget + $2], a                   ; $7298
    ld a, $10                                     ; $729B
    ldh [hScxShadow], a                           ; $729D
    ldh [hScyShadow], a                           ; $729F
    ld hl, wPhotoImage                            ; $72A1
    ld bc, $0e00                                  ; $72A4
    call Mem_Zero                                 ; $72A7
    ld hl, $8000                                  ; $72AA
    ld bc, $0500                                  ; $72AD
    call Mem_Zero                                 ; $72B0
    ld hl, $8800                                  ; $72B3
    ld bc, $0100                                  ; $72B6
    call Mem_Zero                                 ; $72B9
    ld hl, $9000                                  ; $72BC
    ld bc, $0800                                  ; $72BF
    call Mem_Zero                                 ; $72C2
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $72C5
    farcopy Mem_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $72D3
    farcopy Mem_CopyFromBank, Gfx_17_4940_Mode14_State00_Init, $8fd0, $0020 ; $72E1
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $72EF
    farcopy Mem_CopyFromBank, Gfx_17_4140_Mode14_State00_Init, $8a00, $0040 ; $72FD
    farcopy Mem_CopyFromBank, Gfx_17_4180_Mode14_State00_Init, $8a40, $0080 ; $730B
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $7319
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $7327
    farcopy Mem_CopyFromBank, Gfx_17_54E0_Mode14_State00_Init, $8740, $0020 ; $7335
    farcopy Mem_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $7343
    ld hl, $9ac0                                  ; $7351
    ld bc, $0140                                  ; $7354
    ld a, $ff                                     ; $7357
    call Mem_FillBc1                              ; $7359
    call Shoot_LoadBurstIcons                     ; $735C
    call Shoot_LoadEffectGfx                      ; $735F
    call Shoot_ClearEffectTiles                   ; $7362
    ld a, $54                                     ; $7365
    ldh [hLycShadowSplit1], a                     ; $7367
    ldh [hSplit1Latch], a                         ; $7369
    ld hl, hStatShadow                            ; $736B
    set 6, [hl]                                   ; $736E
    ld hl, rIE                                    ; $7370
    set 1, [hl]                                   ; $7373
    ld a, $01                                     ; $7375
    ldh [hStatHandlerIndex], a                    ; $7377
    screen_on                                     ; $7379
    play_music MUSIC_STOP                         ; $7382
    rst Rst08_WaitVBlank                          ; $7389
    call Pal_FadeIn                               ; $738A
    set_state STATE_14_LIVE_VIEW                  ; $738D
    ret                                           ; $7392


; C: jump through the shoot_variant table at 73EF
Shoot_CallVariantHandler::
    ld a, [wShootVariant]                         ; $7393
    sla a                                         ; $7396
    sla a                                         ; $7398
    ld hl, wShootPhase                            ; $739A
    add [hl]                                      ; $739D
    ld c, a                                       ; $739E
    ld b, $00                                     ; $739F
    ld hl, Shoot_CallVariantHandler_Tbl60DE       ; $73A1
    add hl, bc                                    ; $73A4
    ld a, [hl]                                    ; $73A5
    sla a                                         ; $73A6
    ld c, a                                       ; $73A8
    ld b, $00                                     ; $73A9
    ld hl, Shoot_FxHandlerTbl                     ; $73AB
    add hl, bc                                    ; $73AE
    ld a, [hl+]                                   ; $73AF
    ld h, [hl]                                    ; $73B0
    ld l, a                                       ; $73B1
    jp hl                                         ; $73B2


; I: 40 code pointers indexed by shoot_variant * 4 + shoot_phase
Shoot_FxHandlerTbl::
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion00
    dw Shoot_FxRegion01
    dw Shoot_FxRegion02
    dw Shoot_FxRegion03
    dw Shoot_FxRegion04
    dw Shoot_FxRegion05
    dw Shoot_FxRegion06
    dw Shoot_FxRegion07
    dw Shoot_FxRegion08
    dw Shoot_FxRegion09
    dw Shoot_FxRegion0A
    dw Shoot_FxRegion0B
    dw Shoot_FxRegion0C
    dw Shoot_FxRegion0D
    dw Shoot_FxRegion0E
    dw Shoot_FxRegion0F
    dw Shoot_FxRegion04
    dw Shoot_FxXorRows
    dw Shoot_FxXorRows
    dw Shoot_FxXorRows
    dw Shoot_FxRegion01
    dw Shoot_FxRegion02
    dw Shoot_FxRegion03
    dw Shoot_FxRegion04

; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion00::
    ld hl, wPhotoImage                            ; $73F3
    ld a, $0e                                     ; $73F6
    jp Shoot_FxXorRowsBody                        ; $73F8


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion01::
    ld hl, wPhotoImage                            ; $73FB
    ld a, $07                                     ; $73FE
    jp Shoot_FxXorBlockBody                       ; $7400


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion02::
    ld hl, wPhotoImage + $80                      ; $7403
    ld a, $07                                     ; $7406
    jp Shoot_FxXorBlockBody                       ; $7408


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion03::
    ld hl, wEffRegionRow7                         ; $740B
    ld a, $07                                     ; $740E
    jp Shoot_FxXorBlockBody                       ; $7410


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion04::
    ld hl, wEffRegionRow7Right                    ; $7413
    ld a, $07                                     ; $7416
    jp Shoot_FxXorBlockBody                       ; $7418


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion05::
    ld hl, wPhotoImage                            ; $741B
    ld a, $0e                                     ; $741E
    jp Shoot_FxXorBlockBody                       ; $7420


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion06::
    ld hl, wPhotoImage + $80                      ; $7423
    ld a, $0e                                     ; $7426
    jp Shoot_FxXorBlockBody                       ; $7428


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion07::
    ld hl, wPhotoImage                            ; $742B
    ld a, $07                                     ; $742E
    jp Shoot_FxXorRowsBody                        ; $7430


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion08::
    ld hl, wEffRegionRow7                         ; $7433
    ld a, $07                                     ; $7436
    jp Shoot_FxXorRowsBody                        ; $7438


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion09::
    ld hl, wPhotoImage + $80                      ; $743B
    ld a, $07                                     ; $743E
    call Shoot_FxXorBlockBody                     ; $7440
    ld hl, wEffRegionRow7                         ; $7443
    ld a, $07                                     ; $7446
    jp Shoot_FxXorBlockBody                       ; $7448


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0A::
    ld hl, wPhotoImage + $80                      ; $744B
    ld a, $07                                     ; $744E
    call Shoot_FxXorBlockBody                     ; $7450
    ld hl, wEffRegionRow7                         ; $7453
    ld a, $07                                     ; $7456
    jp Shoot_FxXorRowsBody                        ; $7458


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0B::
    ld hl, wPhotoImage                            ; $745B
    ld a, $0a                                     ; $745E
    jp Shoot_FxXorRowsBody                        ; $7460


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0C::
    ld hl, wEffRegionRow10                        ; $7463
    ld a, $04                                     ; $7466
    jp Shoot_FxXorRowsBody                        ; $7468


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0D::
    ld hl, wPhotoImage                            ; $746B
    ld a, $04                                     ; $746E
    jp Shoot_FxXorRowsBody                        ; $7470


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0E::
    ld hl, wEffRegionRow4                         ; $7473
    ld a, $0a                                     ; $7476
    jp Shoot_FxXorRowsBody                        ; $7478


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0F::
    ld hl, wEffRegionTile33                       ; $747B
    ld a, $08                                     ; $747E
    jp Shoot_FxMaskBlockBody                      ; $7480


; C: ret; then at 7480 the row-wise XOR with shoot_fx_vector over A tile rows (shared body)
Shoot_FxXorRows::
    ret                                           ; $7483


; C: XORs the 16-bit mask shoot_fx_vector over A tile rows at HL
Shoot_FxXorRowsBody::
    swap a                                        ; $7484
    ldh [hScratchA], a                            ; $7486
    ld a, [wShootFxVector]                        ; $7488
    ld c, a                                       ; $748B
    ld a, [wShootFxVector + $1]                   ; $748C
    ld b, a                                       ; $748F
    or c                                          ; $7490
    jr z, jr_006_74cb                             ; $7491

    push hl                                       ; $7493
    ldh a, [hScratchA]                            ; $7494
    ld e, a                                       ; $7496

jr_006_7497:
    ld a, [hl]                                    ; $7497
    xor c                                         ; $7498
    ld [hl+], a                                   ; $7499
    ld a, [hl]                                    ; $749A
    xor b                                         ; $749B
    ld [hl+], a                                   ; $749C
    ld a, [hl]                                    ; $749D
    xor c                                         ; $749E
    ld [hl+], a                                   ; $749F
    ld a, [hl]                                    ; $74A0
    xor b                                         ; $74A1
    ld [hl+], a                                   ; $74A2
    ld a, [hl]                                    ; $74A3
    xor c                                         ; $74A4
    ld [hl+], a                                   ; $74A5
    ld a, [hl]                                    ; $74A6
    xor b                                         ; $74A7
    ld [hl+], a                                   ; $74A8
    ld a, [hl]                                    ; $74A9
    xor c                                         ; $74AA
    ld [hl+], a                                   ; $74AB
    ld a, [hl]                                    ; $74AC
    xor b                                         ; $74AD
    ld [hl+], a                                   ; $74AE
    ld a, [hl]                                    ; $74AF
    xor c                                         ; $74B0
    ld [hl+], a                                   ; $74B1
    ld a, [hl]                                    ; $74B2
    xor b                                         ; $74B3
    ld [hl+], a                                   ; $74B4
    ld a, [hl]                                    ; $74B5
    xor c                                         ; $74B6
    ld [hl+], a                                   ; $74B7
    ld a, [hl]                                    ; $74B8
    xor b                                         ; $74B9
    ld [hl+], a                                   ; $74BA
    ld a, [hl]                                    ; $74BB
    xor c                                         ; $74BC
    ld [hl+], a                                   ; $74BD
    ld a, [hl]                                    ; $74BE
    xor b                                         ; $74BF
    ld [hl+], a                                   ; $74C0
    ld a, [hl]                                    ; $74C1
    xor c                                         ; $74C2
    ld [hl+], a                                   ; $74C3
    ld a, [hl]                                    ; $74C4
    xor b                                         ; $74C5
    ld [hl+], a                                   ; $74C6
    dec e                                         ; $74C7
    jr nz, jr_006_7497                            ; $74C8

    pop hl                                        ; $74CA

jr_006_74cb:
    ld a, [wShootFxVector + $2]                   ; $74CB
    ld c, a                                       ; $74CE
    ld a, [wShootFxVector + $3]                   ; $74CF
    ld b, a                                       ; $74D2
    or c                                          ; $74D3
    jr z, jr_006_7532                             ; $74D4

    push hl                                       ; $74D6
    inc hl                                        ; $74D7
    ldh a, [hScratchA]                            ; $74D8
    ld e, a                                       ; $74DA

jr_006_74db:
    ld a, [hl-]                                   ; $74DB
    and c                                         ; $74DC
    ld d, a                                       ; $74DD
    xor [hl]                                      ; $74DE
    ld [hl+], a                                   ; $74DF
    xor d                                         ; $74E0
    and b                                         ; $74E1
    xor [hl]                                      ; $74E2
    ld [hl+], a                                   ; $74E3
    inc l                                         ; $74E4
    ld a, [hl-]                                   ; $74E5
    and c                                         ; $74E6
    ld d, a                                       ; $74E7
    xor [hl]                                      ; $74E8
    ld [hl+], a                                   ; $74E9
    xor d                                         ; $74EA
    and b                                         ; $74EB
    xor [hl]                                      ; $74EC
    ld [hl+], a                                   ; $74ED
    inc l                                         ; $74EE
    ld a, [hl-]                                   ; $74EF
    and c                                         ; $74F0
    ld d, a                                       ; $74F1
    xor [hl]                                      ; $74F2
    ld [hl+], a                                   ; $74F3
    xor d                                         ; $74F4
    and b                                         ; $74F5
    xor [hl]                                      ; $74F6
    ld [hl+], a                                   ; $74F7
    inc l                                         ; $74F8
    ld a, [hl-]                                   ; $74F9
    and c                                         ; $74FA
    ld d, a                                       ; $74FB
    xor [hl]                                      ; $74FC
    ld [hl+], a                                   ; $74FD
    xor d                                         ; $74FE
    and b                                         ; $74FF
    xor [hl]                                      ; $7500
    ld [hl+], a                                   ; $7501
    inc l                                         ; $7502
    ld a, [hl-]                                   ; $7503
    and c                                         ; $7504
    ld d, a                                       ; $7505
    xor [hl]                                      ; $7506
    ld [hl+], a                                   ; $7507
    xor d                                         ; $7508
    and b                                         ; $7509
    xor [hl]                                      ; $750A
    ld [hl+], a                                   ; $750B
    inc l                                         ; $750C
    ld a, [hl-]                                   ; $750D
    and c                                         ; $750E
    ld d, a                                       ; $750F
    xor [hl]                                      ; $7510
    ld [hl+], a                                   ; $7511
    xor d                                         ; $7512
    and b                                         ; $7513
    xor [hl]                                      ; $7514
    ld [hl+], a                                   ; $7515
    inc l                                         ; $7516
    ld a, [hl-]                                   ; $7517
    and c                                         ; $7518
    ld d, a                                       ; $7519
    xor [hl]                                      ; $751A
    ld [hl+], a                                   ; $751B
    xor d                                         ; $751C
    and b                                         ; $751D
    xor [hl]                                      ; $751E
    ld [hl+], a                                   ; $751F
    inc l                                         ; $7520
    ld a, [hl-]                                   ; $7521
    and c                                         ; $7522
    ld d, a                                       ; $7523
    xor [hl]                                      ; $7524
    ld [hl+], a                                   ; $7525
    xor d                                         ; $7526
    and b                                         ; $7527
    xor [hl]                                      ; $7528
    ld [hl+], a                                   ; $7529
    inc l                                         ; $752A
    jr nz, jr_006_752e                            ; $752B

    inc h                                         ; $752D

jr_006_752e:
    dec e                                         ; $752E
    jr nz, jr_006_74db                            ; $752F

    pop hl                                        ; $7531

jr_006_7532:
    ld a, [wShootFxVector + $4]                   ; $7532
    ld c, a                                       ; $7535
    and a                                         ; $7536
    ret z                                         ; $7537

    inc hl                                        ; $7538
    ldh a, [hScratchA]                            ; $7539
    ld e, a                                       ; $753B

jr_006_753c:
    ld a, [hl-]                                   ; $753C
    xor [hl]                                      ; $753D
    and c                                         ; $753E
    ld d, a                                       ; $753F
    xor [hl]                                      ; $7540
    ld [hl+], a                                   ; $7541
    ld a, d                                       ; $7542
    xor [hl]                                      ; $7543
    ld [hl+], a                                   ; $7544
    inc l                                         ; $7545
    ld a, [hl-]                                   ; $7546
    xor [hl]                                      ; $7547
    and c                                         ; $7548
    ld d, a                                       ; $7549
    xor [hl]                                      ; $754A
    ld [hl+], a                                   ; $754B
    ld a, d                                       ; $754C
    xor [hl]                                      ; $754D
    ld [hl+], a                                   ; $754E
    inc l                                         ; $754F
    ld a, [hl-]                                   ; $7550
    xor [hl]                                      ; $7551
    and c                                         ; $7552
    ld d, a                                       ; $7553
    xor [hl]                                      ; $7554
    ld [hl+], a                                   ; $7555
    ld a, d                                       ; $7556
    xor [hl]                                      ; $7557
    ld [hl+], a                                   ; $7558
    inc l                                         ; $7559
    ld a, [hl-]                                   ; $755A
    xor [hl]                                      ; $755B
    and c                                         ; $755C
    ld d, a                                       ; $755D
    xor [hl]                                      ; $755E
    ld [hl+], a                                   ; $755F
    ld a, d                                       ; $7560
    xor [hl]                                      ; $7561
    ld [hl+], a                                   ; $7562
    inc l                                         ; $7563
    ld a, [hl-]                                   ; $7564
    xor [hl]                                      ; $7565
    and c                                         ; $7566
    ld d, a                                       ; $7567
    xor [hl]                                      ; $7568
    ld [hl+], a                                   ; $7569
    ld a, d                                       ; $756A
    xor [hl]                                      ; $756B
    ld [hl+], a                                   ; $756C
    inc l                                         ; $756D
    ld a, [hl-]                                   ; $756E
    xor [hl]                                      ; $756F
    and c                                         ; $7570
    ld d, a                                       ; $7571
    xor [hl]                                      ; $7572
    ld [hl+], a                                   ; $7573
    ld a, d                                       ; $7574
    xor [hl]                                      ; $7575
    ld [hl+], a                                   ; $7576
    inc l                                         ; $7577
    ld a, [hl-]                                   ; $7578
    xor [hl]                                      ; $7579
    and c                                         ; $757A
    ld d, a                                       ; $757B
    xor [hl]                                      ; $757C
    ld [hl+], a                                   ; $757D
    ld a, d                                       ; $757E
    xor [hl]                                      ; $757F
    ld [hl+], a                                   ; $7580
    inc l                                         ; $7581
    ld a, [hl-]                                   ; $7582
    xor [hl]                                      ; $7583
    and c                                         ; $7584
    ld d, a                                       ; $7585
    xor [hl]                                      ; $7586
    ld [hl+], a                                   ; $7587
    ld a, d                                       ; $7588
    xor [hl]                                      ; $7589
    ld [hl+], a                                   ; $758A
    inc l                                         ; $758B
    jr nz, jr_006_758f                            ; $758C

    inc h                                         ; $758E

jr_006_758f:
    dec e                                         ; $758F
    jr nz, jr_006_753c                            ; $7590

    ret                                           ; $7592


; C: same over a block of 8 tiles
Shoot_FxXorBlockBody::
    ldh [hScratchA], a                            ; $7593
    ld a, [wShootFxVector]                        ; $7595
    ld c, a                                       ; $7598
    ld a, [wShootFxVector + $1]                   ; $7599
    ld b, a                                       ; $759C
    or c                                          ; $759D
    jr z, jr_006_75e4                             ; $759E

    push hl                                       ; $75A0
    ldh a, [hScratchA]                            ; $75A1

jr_006_75a3:
    ldh [hScratchB], a                            ; $75A3
    ld e, $08                                     ; $75A5

jr_006_75a7:
    ld a, [hl]                                    ; $75A7
    xor c                                         ; $75A8
    ld [hl+], a                                   ; $75A9
    ld a, [hl]                                    ; $75AA
    xor b                                         ; $75AB
    ld [hl+], a                                   ; $75AC
    ld a, [hl]                                    ; $75AD
    xor c                                         ; $75AE
    ld [hl+], a                                   ; $75AF
    ld a, [hl]                                    ; $75B0
    xor b                                         ; $75B1
    ld [hl+], a                                   ; $75B2
    ld a, [hl]                                    ; $75B3
    xor c                                         ; $75B4
    ld [hl+], a                                   ; $75B5
    ld a, [hl]                                    ; $75B6
    xor b                                         ; $75B7
    ld [hl+], a                                   ; $75B8
    ld a, [hl]                                    ; $75B9
    xor c                                         ; $75BA
    ld [hl+], a                                   ; $75BB
    ld a, [hl]                                    ; $75BC
    xor b                                         ; $75BD
    ld [hl+], a                                   ; $75BE
    ld a, [hl]                                    ; $75BF
    xor c                                         ; $75C0
    ld [hl+], a                                   ; $75C1
    ld a, [hl]                                    ; $75C2
    xor b                                         ; $75C3
    ld [hl+], a                                   ; $75C4
    ld a, [hl]                                    ; $75C5
    xor c                                         ; $75C6
    ld [hl+], a                                   ; $75C7
    ld a, [hl]                                    ; $75C8
    xor b                                         ; $75C9
    ld [hl+], a                                   ; $75CA
    ld a, [hl]                                    ; $75CB
    xor c                                         ; $75CC
    ld [hl+], a                                   ; $75CD
    ld a, [hl]                                    ; $75CE
    xor b                                         ; $75CF
    ld [hl+], a                                   ; $75D0
    ld a, [hl]                                    ; $75D1
    xor c                                         ; $75D2
    ld [hl+], a                                   ; $75D3
    ld a, [hl]                                    ; $75D4
    xor b                                         ; $75D5
    ld [hl+], a                                   ; $75D6
    dec e                                         ; $75D7
    jr nz, jr_006_75a7                            ; $75D8

    ld de, $0080                                  ; $75DA
    add hl, de                                    ; $75DD
    ldh a, [hScratchB]                            ; $75DE
    dec a                                         ; $75E0
    jr nz, jr_006_75a3                            ; $75E1

    pop hl                                        ; $75E3

jr_006_75e4:
    ld a, [wShootFxVector + $2]                   ; $75E4
    ld c, a                                       ; $75E7
    ld a, [wShootFxVector + $3]                   ; $75E8
    ld b, a                                       ; $75EB
    or c                                          ; $75EC
    jr z, jr_006_7657                             ; $75ED

    push hl                                       ; $75EF
    inc hl                                        ; $75F0
    ldh a, [hScratchA]                            ; $75F1

jr_006_75f3:
    ldh [hScratchB], a                            ; $75F3
    ld e, $08                                     ; $75F5

jr_006_75f7:
    ld a, [hl-]                                   ; $75F7
    and c                                         ; $75F8
    ld d, a                                       ; $75F9
    xor [hl]                                      ; $75FA
    ld [hl+], a                                   ; $75FB
    xor d                                         ; $75FC
    and b                                         ; $75FD
    xor [hl]                                      ; $75FE
    ld [hl+], a                                   ; $75FF
    inc l                                         ; $7600
    ld a, [hl-]                                   ; $7601
    and c                                         ; $7602
    ld d, a                                       ; $7603
    xor [hl]                                      ; $7604
    ld [hl+], a                                   ; $7605
    xor d                                         ; $7606
    and b                                         ; $7607
    xor [hl]                                      ; $7608
    ld [hl+], a                                   ; $7609
    inc l                                         ; $760A
    ld a, [hl-]                                   ; $760B
    and c                                         ; $760C
    ld d, a                                       ; $760D
    xor [hl]                                      ; $760E
    ld [hl+], a                                   ; $760F
    xor d                                         ; $7610
    and b                                         ; $7611
    xor [hl]                                      ; $7612
    ld [hl+], a                                   ; $7613
    inc l                                         ; $7614
    ld a, [hl-]                                   ; $7615
    and c                                         ; $7616
    ld d, a                                       ; $7617
    xor [hl]                                      ; $7618
    ld [hl+], a                                   ; $7619
    xor d                                         ; $761A
    and b                                         ; $761B
    xor [hl]                                      ; $761C
    ld [hl+], a                                   ; $761D
    inc l                                         ; $761E
    ld a, [hl-]                                   ; $761F
    and c                                         ; $7620
    ld d, a                                       ; $7621
    xor [hl]                                      ; $7622
    ld [hl+], a                                   ; $7623
    xor d                                         ; $7624
    and b                                         ; $7625
    xor [hl]                                      ; $7626
    ld [hl+], a                                   ; $7627
    inc l                                         ; $7628
    ld a, [hl-]                                   ; $7629
    and c                                         ; $762A
    ld d, a                                       ; $762B
    xor [hl]                                      ; $762C
    ld [hl+], a                                   ; $762D
    xor d                                         ; $762E
    and b                                         ; $762F
    xor [hl]                                      ; $7630
    ld [hl+], a                                   ; $7631
    inc l                                         ; $7632
    ld a, [hl-]                                   ; $7633
    and c                                         ; $7634
    ld d, a                                       ; $7635
    xor [hl]                                      ; $7636
    ld [hl+], a                                   ; $7637
    xor d                                         ; $7638
    and b                                         ; $7639
    xor [hl]                                      ; $763A
    ld [hl+], a                                   ; $763B
    inc l                                         ; $763C
    ld a, [hl-]                                   ; $763D
    and c                                         ; $763E
    ld d, a                                       ; $763F
    xor [hl]                                      ; $7640
    ld [hl+], a                                   ; $7641
    xor d                                         ; $7642
    and b                                         ; $7643
    xor [hl]                                      ; $7644
    ld [hl+], a                                   ; $7645
    inc l                                         ; $7646
    jr nz, jr_006_764a                            ; $7647

    inc h                                         ; $7649

jr_006_764a:
    dec e                                         ; $764A
    jr nz, jr_006_75f7                            ; $764B

    ld de, $0080                                  ; $764D
    add hl, de                                    ; $7650
    ldh a, [hScratchB]                            ; $7651
    dec a                                         ; $7653
    jr nz, jr_006_75f3                            ; $7654

    pop hl                                        ; $7656

jr_006_7657:
    ld a, [wShootFxVector + $4]                   ; $7657
    ld c, a                                       ; $765A
    and a                                         ; $765B
    ret z                                         ; $765C

    inc hl                                        ; $765D
    ldh a, [hScratchA]                            ; $765E

jr_006_7660:
    ldh [hScratchB], a                            ; $7660
    ld e, $08                                     ; $7662

jr_006_7664:
    ld a, [hl-]                                   ; $7664
    xor [hl]                                      ; $7665
    and c                                         ; $7666
    ld d, a                                       ; $7667
    xor [hl]                                      ; $7668
    ld [hl+], a                                   ; $7669
    ld a, d                                       ; $766A
    xor [hl]                                      ; $766B
    ld [hl+], a                                   ; $766C
    inc l                                         ; $766D
    ld a, [hl-]                                   ; $766E
    xor [hl]                                      ; $766F
    and c                                         ; $7670
    ld d, a                                       ; $7671
    xor [hl]                                      ; $7672
    ld [hl+], a                                   ; $7673
    ld a, d                                       ; $7674
    xor [hl]                                      ; $7675
    ld [hl+], a                                   ; $7676
    inc l                                         ; $7677
    ld a, [hl-]                                   ; $7678
    xor [hl]                                      ; $7679
    and c                                         ; $767A
    ld d, a                                       ; $767B
    xor [hl]                                      ; $767C
    ld [hl+], a                                   ; $767D
    ld a, d                                       ; $767E
    xor [hl]                                      ; $767F
    ld [hl+], a                                   ; $7680
    inc l                                         ; $7681
    ld a, [hl-]                                   ; $7682
    xor [hl]                                      ; $7683
    and c                                         ; $7684
    ld d, a                                       ; $7685
    xor [hl]                                      ; $7686
    ld [hl+], a                                   ; $7687
    ld a, d                                       ; $7688
    xor [hl]                                      ; $7689
    ld [hl+], a                                   ; $768A
    inc l                                         ; $768B
    ld a, [hl-]                                   ; $768C
    xor [hl]                                      ; $768D
    and c                                         ; $768E
    ld d, a                                       ; $768F
    xor [hl]                                      ; $7690
    ld [hl+], a                                   ; $7691
    ld a, d                                       ; $7692
    xor [hl]                                      ; $7693
    ld [hl+], a                                   ; $7694
    inc l                                         ; $7695
    ld a, [hl-]                                   ; $7696
    xor [hl]                                      ; $7697
    and c                                         ; $7698
    ld d, a                                       ; $7699
    xor [hl]                                      ; $769A
    ld [hl+], a                                   ; $769B
    ld a, d                                       ; $769C
    xor [hl]                                      ; $769D
    ld [hl+], a                                   ; $769E
    inc l                                         ; $769F
    ld a, [hl-]                                   ; $76A0
    xor [hl]                                      ; $76A1
    and c                                         ; $76A2
    ld d, a                                       ; $76A3
    xor [hl]                                      ; $76A4
    ld [hl+], a                                   ; $76A5
    ld a, d                                       ; $76A6
    xor [hl]                                      ; $76A7
    ld [hl+], a                                   ; $76A8
    inc l                                         ; $76A9
    ld a, [hl-]                                   ; $76AA
    xor [hl]                                      ; $76AB
    and c                                         ; $76AC
    ld d, a                                       ; $76AD
    xor [hl]                                      ; $76AE
    ld [hl+], a                                   ; $76AF
    ld a, d                                       ; $76B0
    xor [hl]                                      ; $76B1
    ld [hl+], a                                   ; $76B2
    inc l                                         ; $76B3
    jr nz, jr_006_76b7                            ; $76B4

    inc h                                         ; $76B6

jr_006_76b7:
    dec e                                         ; $76B7
    jr nz, jr_006_7664                            ; $76B8

    ld de, $0080                                  ; $76BA
    add hl, de                                    ; $76BD
    ldh a, [hScratchB]                            ; $76BE
    dec a                                         ; $76C0
    jr nz, jr_006_7660                            ; $76C1

    ret                                           ; $76C3


; C: masked variant for the single tile region. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Shoot_FxMaskBlockBody::
    ldh [hScratchA], a                            ; $76C4
    ld a, [wShootFxVector]                        ; $76C6
    ld c, a                                       ; $76C9
    ld a, [wShootFxVector + $1]                   ; $76CA
    ld b, a                                       ; $76CD
    or c                                          ; $76CE
    jr z, jr_006_7715                             ; $76CF

    push hl                                       ; $76D1
    ldh a, [hScratchA]                            ; $76D2

jr_006_76d4:
    ldh [hScratchB], a                            ; $76D4
    ld e, $0a                                     ; $76D6

jr_006_76d8:
    ld a, [hl]                                    ; $76D8
    xor c                                         ; $76D9
    ld [hl+], a                                   ; $76DA
    ld a, [hl]                                    ; $76DB
    xor b                                         ; $76DC
    ld [hl+], a                                   ; $76DD
    ld a, [hl]                                    ; $76DE
    xor c                                         ; $76DF
    ld [hl+], a                                   ; $76E0
    ld a, [hl]                                    ; $76E1
    xor b                                         ; $76E2
    ld [hl+], a                                   ; $76E3
    ld a, [hl]                                    ; $76E4
    xor c                                         ; $76E5
    ld [hl+], a                                   ; $76E6
    ld a, [hl]                                    ; $76E7
    xor b                                         ; $76E8
    ld [hl+], a                                   ; $76E9
    ld a, [hl]                                    ; $76EA
    xor c                                         ; $76EB
    ld [hl+], a                                   ; $76EC
    ld a, [hl]                                    ; $76ED
    xor b                                         ; $76EE
    ld [hl+], a                                   ; $76EF
    ld a, [hl]                                    ; $76F0
    xor c                                         ; $76F1
    ld [hl+], a                                   ; $76F2
    ld a, [hl]                                    ; $76F3
    xor b                                         ; $76F4
    ld [hl+], a                                   ; $76F5
    ld a, [hl]                                    ; $76F6
    xor c                                         ; $76F7
    ld [hl+], a                                   ; $76F8
    ld a, [hl]                                    ; $76F9
    xor b                                         ; $76FA
    ld [hl+], a                                   ; $76FB
    ld a, [hl]                                    ; $76FC
    xor c                                         ; $76FD
    ld [hl+], a                                   ; $76FE
    ld a, [hl]                                    ; $76FF
    xor b                                         ; $7700
    ld [hl+], a                                   ; $7701
    ld a, [hl]                                    ; $7702
    xor c                                         ; $7703
    ld [hl+], a                                   ; $7704
    ld a, [hl]                                    ; $7705
    xor b                                         ; $7706
    ld [hl+], a                                   ; $7707
    dec e                                         ; $7708
    jr nz, jr_006_76d8                            ; $7709

    ld de, $0060                                  ; $770B
    add hl, de                                    ; $770E
    ldh a, [hScratchB]                            ; $770F
    dec a                                         ; $7711
    jr nz, jr_006_76d4                            ; $7712

    pop hl                                        ; $7714

jr_006_7715:
    ld a, [wShootFxVector + $2]                   ; $7715
    ld c, a                                       ; $7718
    ld a, [wShootFxVector + $3]                   ; $7719
    ld b, a                                       ; $771C
    or c                                          ; $771D
    jr z, jr_006_7788                             ; $771E

    push hl                                       ; $7720
    inc hl                                        ; $7721
    ldh a, [hScratchA]                            ; $7722

jr_006_7724:
    ldh [hScratchB], a                            ; $7724
    ld e, $0a                                     ; $7726

jr_006_7728:
    ld a, [hl-]                                   ; $7728
    and c                                         ; $7729
    ld d, a                                       ; $772A
    xor [hl]                                      ; $772B
    ld [hl+], a                                   ; $772C
    xor d                                         ; $772D
    and b                                         ; $772E
    xor [hl]                                      ; $772F
    ld [hl+], a                                   ; $7730
    inc l                                         ; $7731
    ld a, [hl-]                                   ; $7732
    and c                                         ; $7733
    ld d, a                                       ; $7734
    xor [hl]                                      ; $7735
    ld [hl+], a                                   ; $7736
    xor d                                         ; $7737
    and b                                         ; $7738
    xor [hl]                                      ; $7739
    ld [hl+], a                                   ; $773A
    inc l                                         ; $773B
    ld a, [hl-]                                   ; $773C
    and c                                         ; $773D
    ld d, a                                       ; $773E
    xor [hl]                                      ; $773F
    ld [hl+], a                                   ; $7740
    xor d                                         ; $7741
    and b                                         ; $7742
    xor [hl]                                      ; $7743
    ld [hl+], a                                   ; $7744
    inc l                                         ; $7745
    ld a, [hl-]                                   ; $7746
    and c                                         ; $7747
    ld d, a                                       ; $7748
    xor [hl]                                      ; $7749
    ld [hl+], a                                   ; $774A
    xor d                                         ; $774B
    and b                                         ; $774C
    xor [hl]                                      ; $774D
    ld [hl+], a                                   ; $774E
    inc l                                         ; $774F
    ld a, [hl-]                                   ; $7750
    and c                                         ; $7751
    ld d, a                                       ; $7752
    xor [hl]                                      ; $7753
    ld [hl+], a                                   ; $7754
    xor d                                         ; $7755
    and b                                         ; $7756
    xor [hl]                                      ; $7757
    ld [hl+], a                                   ; $7758
    inc l                                         ; $7759
    ld a, [hl-]                                   ; $775A
    and c                                         ; $775B
    ld d, a                                       ; $775C
    xor [hl]                                      ; $775D
    ld [hl+], a                                   ; $775E
    xor d                                         ; $775F
    and b                                         ; $7760
    xor [hl]                                      ; $7761
    ld [hl+], a                                   ; $7762
    inc l                                         ; $7763
    ld a, [hl-]                                   ; $7764
    and c                                         ; $7765
    ld d, a                                       ; $7766
    xor [hl]                                      ; $7767
    ld [hl+], a                                   ; $7768
    xor d                                         ; $7769
    and b                                         ; $776A
    xor [hl]                                      ; $776B
    ld [hl+], a                                   ; $776C
    inc l                                         ; $776D
    ld a, [hl-]                                   ; $776E
    and c                                         ; $776F
    ld d, a                                       ; $7770
    xor [hl]                                      ; $7771
    ld [hl+], a                                   ; $7772
    xor d                                         ; $7773
    and b                                         ; $7774
    xor [hl]                                      ; $7775
    ld [hl+], a                                   ; $7776
    inc l                                         ; $7777
    jr nz, jr_006_777b                            ; $7778

    inc h                                         ; $777A

jr_006_777b:
    dec e                                         ; $777B
    jr nz, jr_006_7728                            ; $777C

    ld de, $0060                                  ; $777E
    add hl, de                                    ; $7781
    ldh a, [hScratchB]                            ; $7782
    dec a                                         ; $7784
    jr nz, jr_006_7724                            ; $7785

    pop hl                                        ; $7787

jr_006_7788:
    ld a, [wShootFxVector + $4]                   ; $7788
    ld c, a                                       ; $778B
    and a                                         ; $778C
    ret z                                         ; $778D

    inc hl                                        ; $778E
    ldh a, [hScratchA]                            ; $778F

jr_006_7791:
    ldh [hScratchB], a                            ; $7791
    ld e, $0a                                     ; $7793

jr_006_7795:
    ld a, [hl-]                                   ; $7795
    xor [hl]                                      ; $7796
    and c                                         ; $7797
    ld d, a                                       ; $7798
    xor [hl]                                      ; $7799
    ld [hl+], a                                   ; $779A
    ld a, d                                       ; $779B
    xor [hl]                                      ; $779C
    ld [hl+], a                                   ; $779D
    inc l                                         ; $779E
    ld a, [hl-]                                   ; $779F
    xor [hl]                                      ; $77A0
    and c                                         ; $77A1
    ld d, a                                       ; $77A2
    xor [hl]                                      ; $77A3
    ld [hl+], a                                   ; $77A4
    ld a, d                                       ; $77A5
    xor [hl]                                      ; $77A6
    ld [hl+], a                                   ; $77A7
    inc l                                         ; $77A8
    ld a, [hl-]                                   ; $77A9
    xor [hl]                                      ; $77AA
    and c                                         ; $77AB
    ld d, a                                       ; $77AC
    xor [hl]                                      ; $77AD
    ld [hl+], a                                   ; $77AE
    ld a, d                                       ; $77AF
    xor [hl]                                      ; $77B0
    ld [hl+], a                                   ; $77B1
    inc l                                         ; $77B2
    ld a, [hl-]                                   ; $77B3
    xor [hl]                                      ; $77B4
    and c                                         ; $77B5
    ld d, a                                       ; $77B6
    xor [hl]                                      ; $77B7
    ld [hl+], a                                   ; $77B8
    ld a, d                                       ; $77B9
    xor [hl]                                      ; $77BA
    ld [hl+], a                                   ; $77BB
    inc l                                         ; $77BC
    ld a, [hl-]                                   ; $77BD
    xor [hl]                                      ; $77BE
    and c                                         ; $77BF
    ld d, a                                       ; $77C0
    xor [hl]                                      ; $77C1
    ld [hl+], a                                   ; $77C2
    ld a, d                                       ; $77C3
    xor [hl]                                      ; $77C4
    ld [hl+], a                                   ; $77C5
    inc l                                         ; $77C6
    ld a, [hl-]                                   ; $77C7
    xor [hl]                                      ; $77C8
    and c                                         ; $77C9
    ld d, a                                       ; $77CA
    xor [hl]                                      ; $77CB
    ld [hl+], a                                   ; $77CC
    ld a, d                                       ; $77CD
    xor [hl]                                      ; $77CE
    ld [hl+], a                                   ; $77CF
    inc l                                         ; $77D0
    ld a, [hl-]                                   ; $77D1
    xor [hl]                                      ; $77D2
    and c                                         ; $77D3
    ld d, a                                       ; $77D4
    xor [hl]                                      ; $77D5
    ld [hl+], a                                   ; $77D6
    ld a, d                                       ; $77D7
    xor [hl]                                      ; $77D8
    ld [hl+], a                                   ; $77D9
    inc l                                         ; $77DA
    ld a, [hl-]                                   ; $77DB
    xor [hl]                                      ; $77DC
    and c                                         ; $77DD
    ld d, a                                       ; $77DE
    xor [hl]                                      ; $77DF
    ld [hl+], a                                   ; $77E0
    ld a, d                                       ; $77E1
    xor [hl]                                      ; $77E2
    ld [hl+], a                                   ; $77E3
    inc l                                         ; $77E4
    jr nz, jr_006_77e8                            ; $77E5

    inc h                                         ; $77E7

jr_006_77e8:
    dec e                                         ; $77E8
    jr nz, jr_006_7795                            ; $77E9

    ld de, $0060                                  ; $77EB
    add hl, de                                    ; $77EE
    ldh a, [hScratchB]                            ; $77EF
    dec a                                         ; $77F1
    jr nz, jr_006_7791                            ; $77F2

    ret                                           ; $77F4


; C
Shoot_SetupCapture::
    ld e, $00                                     ; $77F5
    ld a, [wShootCaptureSel]                      ; $77F7
    cp $01                                        ; $77FA
    jr nz, jr_006_7802                            ; $77FC

    ld e, $20                                     ; $77FE
    jr jr_006_7808                                ; $7800

jr_006_7802:
    cp $02                                        ; $7802
    jr nz, jr_006_7808                            ; $7804

    ld e, $40                                     ; $7806

jr_006_7808:
    ld a, [wShootVariant]                         ; $7808
    sla a                                         ; $780B
    sla a                                         ; $780D
    ld hl, wShootPhase                            ; $780F
    add [hl]                                      ; $7812
    ld c, a                                       ; $7813
    ld b, $00                                     ; $7814
    ld hl, Shoot_CallVariantHandler_Tbl60DE       ; $7816
    add hl, bc                                    ; $7819
    ld a, [hl]                                    ; $781A
    or e                                          ; $781B
    ldh [hFarcallAArg], a                         ; $781C
    farcall Cam_FarStub_DispatchEffect            ; $781E
    ret                                           ; $7826


; C: taken photos + 1 (BCD) and store (02)
Counters_IncTaken::
    ld a, $01                                     ; $7827
    ld hl, wCntTaken                              ; $7829
    ld b, $02                                     ; $782C
    call Bcd_AddSaturate                          ; $782E
    ldh [hFarcallAArg], a                         ; $7831
    farcall Counters_Store_Far                    ; $7833
    ret                                           ; $783B


; C: sound list by shutter_sound
Shoot_PlayShutterSound::
    ld a, [wShutterSound]                         ; $783C
    cp $04                                        ; $783F
    ret nc                                        ; $7841

    ld hl, Shoot_PlayShutterSound_Tbl7849         ; $7842
    call Snd_PlayFromList                         ; $7845
    ret                                           ; $7848


; I: auto: 8 bytes, bytes; referenced by Shoot_PlayShutterSound. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_PlayShutterSound_Tbl7849::
    db SFX1_SHUTTER_SOUND_1, SNDCH_SFX1  ; #1
    db SFX3_SHUTTER_SOUND_2, SNDCH_SFX3  ; #2
    db SFX3_SHUTTER_SOUND_3, SNDCH_SFX3  ; #3
    db SFX4_SHUTTER_SOUND_4, SNDCH_SFX4  ; #4

    ; padding
    ds $7af, $00

; Pocket Camera (Japan) (Rev A), bank $06. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
    farcopy Mem_CopyFromBank, Map_25_6620_Mode15_State01_TimerInit, $9800, $0240 ; $4091
    call Oam_ClearShadow                          ; $409F
    call Pal_AllWhite                             ; $40A2
    call Lcd_On                                   ; $40A5
    push af                                       ; $40A8
    ld a, MUSIC_TIMER_PRINT_OPTIONS               ; $40A9
    call Snd_Music                                ; $40AB
    pop af                                        ; $40AE
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
    call Pal_FadeOut                              ; $4142
    call Lcd_Off                                  ; $4145
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
    farcopy Mem_CopyFromBank, Map_25_6AA0_Mode15_State05_IntervalInit, $9800, $0240 ; $41D4
    call Oam_ClearShadow                          ; $41E2
    call Pal_AllWhite                             ; $41E5
    call Lcd_On                                   ; $41E8
    push af                                       ; $41EB
    ld a, MUSIC_TIMER_PRINT_OPTIONS               ; $41EC
    call Snd_Music                                ; $41EE
    pop af                                        ; $41F1
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
    call Pal_FadeOut                              ; $434F
    call Lcd_Off                                  ; $4352
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
    call Oam_AddMeta_B01_5D47                     ; $4398
    ret                                           ; $439B


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (8762 hits in 16 runs: 15:02 x6526 15:06 x2236;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawSecondsSprite::
    cpl                                           ; $439C
    inc a                                         ; $439D
    and $07                                       ; $439E
    add $45                                       ; $43A0
    call Oam_AddMeta_B01_5D47                     ; $43A2
    ret                                           ; $43A5


; C: BGB watchpoint pass 2026-10-25: ran only in mode 15 (6912 hits in 12 runs: 15:03 x3162 15:07 x2502 15:08 x1248;
; tcrf_check/assets/mode_state_wp/)
Mode15_DrawOkSprite::
    ld a, $4d                                     ; $43A6
    call Oam_AddMeta_B01_5D47                     ; $43A8
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
    call Oam_AddMeta_B01_5D47                     ; $43B8
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
    ld hl, $7180                                  ; $43D0
    add hl, bc                                    ; $43D3
    ld a, $20                                     ; $43D4
    ld bc, $0020                                  ; $43D6
    call Vram_CopyFromBank                        ; $43D9
    pop af                                        ; $43DC
    ld c, a                                       ; $43DD
    swap c                                        ; $43DE
    ld b, $00                                     ; $43E0
    sla c                                         ; $43E2
    rl b                                          ; $43E4
    ld hl, $7180                                  ; $43E6
    add hl, bc                                    ; $43E9
    ld a, $20                                     ; $43EA
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
    ld hl, $70e0                                  ; $4403
    add hl, bc                                    ; $4406
    ld a, $20                                     ; $4407
    ld bc, $0010                                  ; $4409
    call Vram_CopyFromBank                        ; $440C
    pop af                                        ; $440F
    ld c, a                                       ; $4410
    swap c                                        ; $4411
    ld b, $00                                     ; $4413
    ld hl, $70e0                                  ; $4415
    add hl, bc                                    ; $4418
    ld a, $20                                     ; $4419
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

    push af                                       ; $44C2
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $44C3
    call Snd_Sfx1                                 ; $44C5
    pop af                                        ; $44C8
    dec a                                         ; $44C9
    ret                                           ; $44CA


jr_006_44cb:
    bit 4, [hl]                                   ; $44CB
    ret z                                         ; $44CD

    cp c                                          ; $44CE
    ret z                                         ; $44CF

    push af                                       ; $44D0
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $44D1
    call Snd_Sfx1                                 ; $44D3
    pop af                                        ; $44D6
    inc a                                         ; $44D7
    ret                                           ; $44D8


; C: mode 16: SHUTTERBUG menu (TRICK LENSES / MONTAGE / PANORAMA / GAME FACE)
Mode16_ShutterbugMagic::
    ld a, [wState]                                ; $44D9
    rst Rst18_JumpTable                           ; $44DC

; C: 10 states
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

; C
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
    ld a, $0d                                     ; $4523
    ld hl, Gfx_0D_5000_Mode16_State00_Init        ; $4525
    ld de, $8000                                  ; $4528
    ld bc, $0300                                  ; $452B
    call Mem_CopyFromBank                         ; $452E
    farcopy Mem_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $4531
    call Oam_ClearShadow                          ; $453F
    call Pal_AllWhite                             ; $4542
    call Lcd_On                                   ; $4545
    push af                                       ; $4548
    ld a, MUSIC_SHUTTERBUG                        ; $4549
    call Snd_Music                                ; $454B
    pop af                                        ; $454E
    rst Rst08_WaitVBlank                          ; $454F
    call Mode16_LoadPageTiles                     ; $4550
    ld a, [wOpt1Value]                            ; $4553
    ld hl, Mode16_TrickLensIconSrcTbl             ; $4556
    ld de, $9300                                  ; $4559
    call Mode16_LoadIconTiles                     ; $455C
    ld a, [wOpt2Value]                            ; $455F
    ld hl, Mode16_MontageIconSrcTbl               ; $4562
    ld de, $9400                                  ; $4565
    call Mode16_LoadIconTiles                     ; $4568
    call Pal_FadeIn                               ; $456B
    set_state STATE_16_MAIN_MENU                  ; $456E
    ret                                           ; $4573


; C
Mode16_State01_Redraw::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4574
    ldh [hLcdcShadow], a                          ; $4576
    ld a, $e4                                     ; $4578
    ld [wPaletteTarget], a                        ; $457A
    ld [wPaletteTarget + $1], a                   ; $457D
    ld a, $d2                                     ; $4580
    ld [wPaletteTarget + $2], a                   ; $4582
    xor a                                         ; $4585
    ldh [hScxShadow], a                           ; $4586
    ldh [hScyShadow], a                           ; $4588
    ld a, $0d                                     ; $458A
    ld hl, Gfx_0D_4000_Mode16_State00_Init        ; $458C
    ld de, $9000                                  ; $458F
    ld bc, $0800                                  ; $4592
    call Mem_CopyFromBank                         ; $4595
    farcopy Mem_CopyFromBank, Gfx_0D_4800_Mode16_State00_Init, $8800, $0800 ; $4598
    ld a, $0d                                     ; $45A6
    ld hl, Gfx_0D_5000_Mode16_State00_Init        ; $45A8
    ld de, $8000                                  ; $45AB
    ld bc, $0300                                  ; $45AE
    call Mem_CopyFromBank                         ; $45B1
    farcopy Mem_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $45B4
    call Oam_ClearShadow                          ; $45C2
    call Pal_AllWhite                             ; $45C5
    call Lcd_On                                   ; $45C8
    push af                                       ; $45CB
    ld a, MUSIC_SHUTTERBUG                        ; $45CC
    call Snd_Music                                ; $45CE
    pop af                                        ; $45D1
    rst Rst08_WaitVBlank                          ; $45D2
    call Mode16_LoadPageTiles                     ; $45D3
    ld a, [wOpt1Value]                            ; $45D6
    ld hl, Mode16_TrickLensIconSrcTbl             ; $45D9
    ld de, $9300                                  ; $45DC
    call Mode16_LoadIconTiles                     ; $45DF
    ld a, [wOpt2Value]                            ; $45E2
    ld hl, Mode16_MontageIconSrcTbl               ; $45E5
    ld de, $9400                                  ; $45E8
    call Mode16_LoadIconTiles                     ; $45EB
    call Mode16_BuildOptionList                   ; $45EE
    ld a, [wOptMenuCursor]                        ; $45F1
    ld c, a                                       ; $45F4
    ld b, $00                                     ; $45F5
    ld hl, Mode16_RedrawStateTbl                  ; $45F7
    add hl, bc                                    ; $45FA
    ld a, [hl]                                    ; $45FB
    ld [wState], a                                ; $45FC
    call Pal_FadeIn                               ; $45FF
    ret                                           ; $4602


; C: 4 bytes: menu item (wOptMenuCursor) -> state that Mode16_State01_Redraw (06:45F7) resumes after rebuilding the
; screen: 03 TRICK LENSES, 04 MONTAGE, 05 PANORAMA, 06 GAME FACE (read 2026-10-25)
Mode16_RedrawStateTbl::
    db $03, $04, $05, $06

; C
Mode16_State02_MainMenu::
    ld hl, wOptMenuCursor                         ; $4607
    ld c, $03                                     ; $460A
    call Mode16_StepRow                           ; $460C
    call nz, Mode16_LoadPageTiles                 ; $460F
    ld a, [wOptMenuCursor]                        ; $4612
    ld hl, Mode16_MenuCursorPosTbl                ; $4615
    call Mode16_DrawCursorFromTable               ; $4618
    ldh a, [hKeysNew]                             ; $461B
    bit PADB_A, a                                 ; $461D
    jr z, jr_006_4649                             ; $461F

    push af                                       ; $4621
    ld a, SFX1_KEY_A                              ; $4622
    call Snd_Sfx1                                 ; $4624
    pop af                                        ; $4627
    call Oam_ClearShadow                          ; $4628
    ld a, [wOptMenuCursor]                        ; $462B
    ld c, a                                       ; $462E
    ld b, $00                                     ; $462F
    ld hl, Mode16_ItemStateTbl                    ; $4631
    add hl, bc                                    ; $4634
    ld a, [hl]                                    ; $4635
    cp $22                                        ; $4636
    jr c, jr_006_4642                             ; $4638

    push af                                       ; $463A
    ld a, SFX1_BEEP_REFUSED                       ; $463B
    call Snd_Sfx1                                 ; $463D
    pop af                                        ; $4640
    ret                                           ; $4641


jr_006_4642:
    ld [wState], a                                ; $4642
    call Mode16_BuildOptionList                   ; $4645
    ret                                           ; $4648


jr_006_4649:
    bit 1, a                                      ; $4649
    ret z                                         ; $464B

    push af                                       ; $464C
    ld a, SFX1_KEY_B                              ; $464D
    call Snd_Sfx1                                 ; $464F
    pop af                                        ; $4652
    set_state STATE_16_LEAVE_TO_MODE01            ; $4653
    ret                                           ; $4658


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
    call Mode16_DrawCaptionBlink                  ; $4665
    ld hl, wOpt1Row                               ; $4668
    ld c, $00                                     ; $466B
    call Mode16_StepRow                           ; $466D
    ld a, [wOpt1Row]                              ; $4670
    and a                                         ; $4673
    jr nz, jr_006_468a                            ; $4674

    ld hl, wOpt1Value                             ; $4676
    ld c, $08                                     ; $4679
    call Mode16_StepValue                         ; $467B
    ld a, [wOpt1Value]                            ; $467E
    ld hl, Mode16_TrickLensIconSrcTbl             ; $4681
    ld de, $9300                                  ; $4684
    call nz, Mode16_LoadIconTiles                 ; $4687

jr_006_468a:
    ld a, [wOpt1Row]                              ; $468A
    ld hl, Mode16_TrickLensRowPosTbl              ; $468D
    call Mode16_DrawCursorFromTable               ; $4690
    ld a, [wOpt1Value]                            ; $4693
    ld hl, Mode16_TrickLensIconTbl                ; $4696
    call Mode16_DrawIcon                          ; $4699
    ldh a, [hKeysNew]                             ; $469C
    bit PADB_A, a                                 ; $469E
    jr z, jr_006_46b5                             ; $46A0

    push af                                       ; $46A2
    ld a, SFX1_KEY_A                              ; $46A3
    call Snd_Sfx1                                 ; $46A5
    pop af                                        ; $46A8
    ld a, [wOpt1Row]                              ; $46A9
    and a                                         ; $46AC
    jr nz, jr_006_46b4                            ; $46AD

    set_state STATE_16_START_SHOOT                ; $46AF

jr_006_46b4:
    ret                                           ; $46B4


jr_006_46b5:
    bit 1, a                                      ; $46B5
    ret z                                         ; $46B7

    push af                                       ; $46B8
    ld a, SFX1_KEY_B                              ; $46B9
    call Snd_Sfx1                                 ; $46BB
    pop af                                        ; $46BE
    call Oam_ClearShadow                          ; $46BF
    rst Rst08_WaitVBlank                          ; $46C2
    farcopy Vram_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $46C3
    set_state STATE_16_MAIN_MENU                  ; $46D1
    ret                                           ; $46D6


; C: 3 x {y; x} of the row cursor of the TRICK LENSES sub-screen (y = $60 / $68 / $70, x = $37); only entry 0 is read
; because the row wOpt1Row never leaves 0 (Mode16_StepRow with C = 0) (read 2026-10-25)
Mode16_TrickLensRowPosTbl::
    db $60, $37, $68, $37, $70, $37

; C: 9 x {OAM list id; OAM list id or $FF} drawn at (x, y) = ($60, $60) by Mode16_DrawIcon (06:4AA3) for wOpt1Value
; 0-8, $FF = no second list (read 2026-10-25)
Mode16_TrickLensIconTbl::
    db $37, $3f, $37, $40, $37, $41, $37, $42, $38, $3f, $38, $40, $38, $41, $39, $ff
    db $3a, $ff

; C: 9 x {lo; hi; bank} = 0D:6000 6100 6300 6200 6400 6500 6600 6700 6800 (the Gfx_0D_*_Icon06_46EF rows):
; Mode16_LoadIconTiles (06:4B23) copies $100 B of the entry wOpt1Value to $9300; one table of 27 B (read 2026-10-25)
Mode16_TrickLensIconSrcTbl::
    dwb Gfx_0D_6000_Icon06_46EF
    dwb Gfx_0D_6100_Icon06_46EF
    dwb Gfx_0D_6300_Icon06_46EF
    dwb Gfx_0D_6200_Icon06_46EF
    dwb Gfx_0D_6400_Icon06_46EF
    dwb Gfx_0D_6500_Icon06_46EF
    dwb Gfx_0D_6600_Icon06_46EF
    dwb Gfx_0D_6700_Icon06_46EF
    dwb Gfx_0D_6800_Icon06_46EF

; C: option 2 (opt2_row / opt2_value); BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 04 (1914 hits in
; 4 runs: 16:04 x1914; tcrf_check/assets/mode_state_wp/)
Mode16_State04_MontageMenu::
    call Mode16_DrawCaptionBlink                  ; $470A
    ld hl, wOpt2Row                               ; $470D
    ld c, $00                                     ; $4710
    call Mode16_StepRow                           ; $4712
    ld a, [wOpt2Row]                              ; $4715
    and a                                         ; $4718
    jr nz, jr_006_472f                            ; $4719

    ld hl, wOpt2Value                             ; $471B
    ld c, $06                                     ; $471E
    call Mode16_StepValue                         ; $4720
    ld a, [wOpt2Value]                            ; $4723
    ld hl, Mode16_MontageIconSrcTbl               ; $4726
    ld de, $9400                                  ; $4729
    call nz, Mode16_LoadIconTiles                 ; $472C

jr_006_472f:
    ld a, [wOpt2Row]                              ; $472F
    ld hl, Mode16_MontageRowPosTbl                ; $4732
    call Mode16_DrawCursorFromTable               ; $4735
    ld a, [wOpt2Value]                            ; $4738
    ld hl, Mode16_MontageIconTbl                  ; $473B
    call Mode16_DrawIcon                          ; $473E
    ldh a, [hKeysNew]                             ; $4741
    bit PADB_A, a                                 ; $4743
    jr z, jr_006_4759                             ; $4745

    push af                                       ; $4747
    ld a, SFX1_KEY_A                              ; $4748
    call Snd_Sfx1                                 ; $474A
    pop af                                        ; $474D
    ld a, [wOpt2Row]                              ; $474E
    and a                                         ; $4751
    ret nz                                        ; $4752

    set_state STATE_16_START_SHOOT                ; $4753
    ret                                           ; $4758


jr_006_4759:
    bit 1, a                                      ; $4759
    ret z                                         ; $475B

    push af                                       ; $475C
    ld a, SFX1_KEY_B                              ; $475D
    call Snd_Sfx1                                 ; $475F
    pop af                                        ; $4762
    call Oam_ClearShadow                          ; $4763
    rst Rst08_WaitVBlank                          ; $4766
    farcopy Vram_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $4767
    set_state STATE_16_MAIN_MENU                  ; $4775
    ret                                           ; $477A


; C: 3 x {y; x} of the row cursor of the MONTAGE sub-screen (same bytes as Mode16_TrickLensRowPosTbl); only entry 0 is
; read, wOpt2Row never leaves 0 (read 2026-10-25)
Mode16_MontageRowPosTbl::
    db $60, $37, $68, $37, $70, $37

; C: 7 x {OAM list id; OAM list id or $FF} drawn by Mode16_DrawIcon for wOpt2Value 0-6 (read 2026-10-25)
Mode16_MontageIconTbl::
    db $3b, $3f, $3b, $40, $3b, $41, $3b, $42, $3c, $ff, $3d, $ff, $3e, $ff

; C: 7 x {lo; hi; bank} = 0D:6900-6F00 (the Gfx_0D_*_Icon06_478F rows): Mode16_LoadIconTiles copies $100 B of the
; entry wOpt2Value to $9400 (read 2026-10-25)
Mode16_MontageIconSrcTbl::
    dwb Gfx_0D_6900_Icon06_478F
    dwb Gfx_0D_6A00_Icon06_478F
    dwb Gfx_0D_6B00_Icon06_478F
    dwb Gfx_0D_6C00_Icon06_478F
    dwb Gfx_0D_6D00_Icon06_478F
    dwb Gfx_0D_6E00_Icon06_478F
    dwb Gfx_0D_6F00_Icon06_478F

; C: option 3 (two toggles); BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 05 (22910 hits in 13 runs:
; 16:05 x22910; tcrf_check/assets/mode_state_wp/)
Mode16_State05_PanoramaMenu::
    call Mode16_DrawPanoramaHint                  ; $47A4
    ld hl, wOpt3Cursor                            ; $47A7
    ld c, $01                                     ; $47AA
    call Mode16_StepRow                           ; $47AC
    ld a, [wOpt3Cursor]                           ; $47AF
    ld c, a                                       ; $47B2
    ld b, $00                                     ; $47B3
    ld hl, wOpt3ToggleA                           ; $47B5
    add hl, bc                                    ; $47B8
    ld c, $01                                     ; $47B9
    call Mode16_StepValue                         ; $47BB
    ld a, [wOpt3Cursor]                           ; $47BE
    ld hl, Mode16_PanoramaRowPosTbl               ; $47C1
    call Mode16_DrawCursorFromTable               ; $47C4
    call Mode16_DrawPanoramaToggles               ; $47C7
    ldh a, [hKeysNew]                             ; $47CA
    bit PADB_A, a                                 ; $47CC
    jr z, jr_006_47e9                             ; $47CE

    push af                                       ; $47D0
    ld a, SFX1_KEY_A                              ; $47D1
    call Snd_Sfx1                                 ; $47D3
    pop af                                        ; $47D6
    ld a, [wOpt3Cursor]                           ; $47D7
    and a                                         ; $47DA
    jr nz, jr_006_47e3                            ; $47DB

    set_state STATE_16_START_SHOOT                ; $47DD
    ret                                           ; $47E2


jr_006_47e3:
    set_state STATE_16_TO_PANORAMA_PRINT          ; $47E3
    ret                                           ; $47E8


jr_006_47e9:
    bit 1, a                                      ; $47E9
    ret z                                         ; $47EB

    push af                                       ; $47EC
    ld a, SFX1_KEY_B                              ; $47ED
    call Snd_Sfx1                                 ; $47EF
    pop af                                        ; $47F2
    call Oam_ClearShadow                          ; $47F3
    rst Rst08_WaitVBlank                          ; $47F6
    farcopy Vram_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $47F7
    set_state STATE_16_MAIN_MENU                  ; $4805
    ret                                           ; $480A


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (11455 hits in 13 runs: 16:05 x11455;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawPanoramaHint::
    ldh a, [hFrameCounter]                        ; $480B
    bit 3, a                                      ; $480D
    jr z, jr_006_4822                             ; $480F

    ld a, $47                                     ; $4811
    ld bc, $6860                                  ; $4813
    call Oam_AddMeta_B02_5272                     ; $4816
    ld a, $47                                     ; $4819
    ld bc, $6868                                  ; $481B
    call Oam_AddMeta_B02_5272                     ; $481E
    ret                                           ; $4821


jr_006_4822:
    ld a, $48                                     ; $4822
    ld bc, $6860                                  ; $4824
    call Oam_AddMeta_B02_5272                     ; $4827
    ld a, $48                                     ; $482A
    ld bc, $6868                                  ; $482C
    call Oam_AddMeta_B02_5272                     ; $482F
    ret                                           ; $4832


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (11455 hits in 13 runs: 16:05 x11455;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawPanoramaToggles::
    ld a, [wOpt3ToggleA]                          ; $4833
    xor $01                                       ; $4836
    add $35                                       ; $4838
    ld bc, $6860                                  ; $483A
    call Oam_AddMeta_B02_5272                     ; $483D
    ld a, [wOpt3ToggleB]                          ; $4840
    xor $01                                       ; $4843
    add $35                                       ; $4845
    ld bc, $6868                                  ; $4847
    call Oam_AddMeta_B02_5272                     ; $484A
    ldh a, [hFrameCounter]                        ; $484D
    bit 3, a                                      ; $484F
    ret z                                         ; $4851

    ld a, [wOpt3Cursor]                           ; $4852
    ld c, a                                       ; $4855
    ld b, $00                                     ; $4856
    ld hl, wOpt3ToggleA                           ; $4858
    add hl, bc                                    ; $485B
    ld a, [hl]                                    ; $485C
    and a                                         ; $485D
    jr z, jr_006_4869                             ; $485E

    ld bc, $8018                                  ; $4860
    ld a, $44                                     ; $4863
    call Oam_AddMeta_B02_5272                     ; $4865
    ret                                           ; $4868


jr_006_4869:
    ld bc, $3818                                  ; $4869
    ld a, $43                                     ; $486C
    call Oam_AddMeta_B02_5272                     ; $486E
    ret                                           ; $4871


; C: 4 x {y; x} of the row cursor of the PANORAMA sub-screen (y = $60 / $68 / $70 / $78, x = $37);
; Mode16_State05_PanoramaMenu (06:47C1) limits the row $D5E8 to 0-1, so entries 2-3 are not read by it (read
; 2026-10-25)
Mode16_PanoramaRowPosTbl::
    db $60, $37, $68, $37, $70, $37, $78, $37

; C: option 4: game or Game Face editor; BGB watchpoint pass 2026-10-25: ran only in mode 16 and state 06 (6704 hits
; in 7 runs: 16:06 x6704; tcrf_check/assets/mode_state_wp/)
Mode16_State06_GameFaceMenu::
    ld hl, wOpt4Cursor                            ; $487A
    ld c, $01                                     ; $487D
    ldh a, [hKeysHeld]                            ; $487F
    bit PADB_SELECT, a                            ; $4881
    jr z, jr_006_4887                             ; $4883

    ld c, $02                                     ; $4885

jr_006_4887:
    call Mode16_StepRow                           ; $4887
    ld a, [wOpt4Cursor]                           ; $488A
    ld hl, Mode16_GameFaceRowPosTbl               ; $488D
    call Mode16_DrawCursorFromTable               ; $4890
    ldh a, [hKeysNew]                             ; $4893
    bit PADB_A, a                                 ; $4895
    jr z, jr_006_48fc                             ; $4897

    push af                                       ; $4899
    ld a, SFX1_KEY_A                              ; $489A
    call Snd_Sfx1                                 ; $489C
    pop af                                        ; $489F
    ld a, [wOpt4Cursor]                           ; $48A0
    and a                                         ; $48A3
    jr nz, jr_006_48ac                            ; $48A4

    set_state STATE_16_START_SHOOT                ; $48A6
    ret                                           ; $48AB


jr_006_48ac:
    cp $01                                        ; $48AC
    jr nz, jr_006_48cb                            ; $48AE

    call Pal_FadeOut                              ; $48B0
    call Lcd_Off                                  ; $48B3
    ld a, $02                                     ; $48B6
    ld [wPickCharacter], a                        ; $48B8
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $48BB
    ld [wMode20Caller], a                         ; $48BD
    ld a, MODE_BALL                               ; $48C0
    ld [wMode], a                                 ; $48C2
    set_state STATE_20_GAME_SETUP                 ; $48C5
    ret                                           ; $48CA


jr_006_48cb:
    cp $02                                        ; $48CB
    ret nz                                        ; $48CD

    ldh [hFarcallAArg], a                         ; $48CE
    farcall GameFace_Load_Far                     ; $48D0
    ld a, [wGamefacePresent]                      ; $48D8
    and a                                         ; $48DB
    jr nz, jr_006_48e6                            ; $48DC

    push af                                       ; $48DE
    ld a, SFX1_BEEP_REFUSED                       ; $48DF
    call Snd_Sfx1                                 ; $48E1
    pop af                                        ; $48E4
    ret                                           ; $48E5


jr_006_48e6:
    call Pal_FadeOut                              ; $48E6
    call Lcd_Off                                  ; $48E9
    ld a, $01                                     ; $48EC
    ld [wDoodleFromShutterbug], a                 ; $48EE
    ld a, MODE_DOODLE_MENU                        ; $48F1
    ld [wMode], a                                 ; $48F3
    set_state STATE_04_INIT                       ; $48F6
    ret                                           ; $48FB


jr_006_48fc:
    bit 1, a                                      ; $48FC
    ret z                                         ; $48FE

    push af                                       ; $48FF
    ld a, SFX1_KEY_B                              ; $4900
    call Snd_Sfx1                                 ; $4902
    pop af                                        ; $4905
    call Oam_ClearShadow                          ; $4906
    rst Rst08_WaitVBlank                          ; $4909
    farcopy Vram_CopyFromBank, Map_25_73A0_Mode16_State00_Init, $9800, $0240 ; $490A
    set_state STATE_16_MAIN_MENU                  ; $4918
    ret                                           ; $491D


; C: 3 x {y; x} of the row cursor of the GAME FACE page; row 2 (the hidden third choice) is reachable only while
; Select is held (06:487A, README 16.15) (read 2026-10-25)
Mode16_GameFaceRowPosTbl::
    db $60, $37, $68, $37, $70, $37

; C
Mode16_State07_LeaveToMode01::
    ld a, MODE_SHOOT_PARLOR                       ; $4924
    ld [wMode], a                                 ; $4926
    set_state STATE_01_INTRO                      ; $4929
    call Pal_FadeOut                              ; $492E
    call Lcd_Off                                  ; $4931
    ret                                           ; $4934


; C: applies the options and goes to mode 14
Mode16_State08_StartShoot::
    ld a, MODE_SHOOT_LIVE_VIEW                    ; $4935
    ld [wMode], a                                 ; $4937
    set_state STATE_14_INIT                       ; $493A
    call Pal_FadeOut                              ; $493F
    call Lcd_Off                                  ; $4942
    ld a, [wOptMenuCursor]                        ; $4945
    and a                                         ; $4948
    jr nz, jr_006_4952                            ; $4949

    ld a, [wOpt1Value]                            ; $494B
    add $03                                       ; $494E
    jr jr_006_496c                                ; $4950

jr_006_4952:
    cp $01                                        ; $4952
    jr nz, jr_006_495d                            ; $4954

    ld a, [wOpt2Value]                            ; $4956
    add $0c                                       ; $4959
    jr jr_006_496c                                ; $495B

jr_006_495d:
    cp $02                                        ; $495D
    jr nz, jr_006_496a                            ; $495F

    ld a, [wOpt3ToggleA]                          ; $4961
    xor $01                                       ; $4964
    add $13                                       ; $4966
    jr jr_006_496c                                ; $4968

jr_006_496a:
    ld a, $15                                     ; $496A

jr_006_496c:
    ld [wShootVariant], a                         ; $496C
    cp $15                                        ; $496F
    ret nz                                        ; $4971

    ldh [hFarcallAArg], a                         ; $4972
    farcall GameFace_Load_Far                     ; $4974
    ld a, [wGamefacePresent]                      ; $497C
    and a                                         ; $497F
    ret z                                         ; $4980

    ld a, $c6                                     ; $4981
    ld [wPaletteTarget + $2], a                   ; $4983
    farcopy Mem_CopyFromBank, Gfx_23_50C0_Mode16_State08_StartShoot, $8900, $0290 ; $4986
    farcopy Mem_CopyFromBank, Gfx_23_5350_Mode16_State08_StartShoot, $8600, $0140 ; $4994
    farcopy Mem_CopyFromBank, Map_26_6E40_Mode16_State08_StartShoot, $9800, $0240 ; $49A2
    ld a, $00                                     ; $49B0
    ld hl, wPhotoImage                            ; $49B2
    ld de, $9000                                  ; $49B5
    ld bc, $0800                                  ; $49B8
    call Mem_CopyFromBank                         ; $49BB
    ld a, $00                                     ; $49BE
    ld hl, wPhotoImage + $800                     ; $49C0
    ld de, $8800                                  ; $49C3
    ld bc, $0100                                  ; $49C6
    call Mem_CopyFromBank                         ; $49C9
    ld a, $00                                     ; $49CC
    ld hl, wPhotoImage + $900                     ; $49CE
    ld de, $8000                                  ; $49D1
    ld bc, $0500                                  ; $49D4
    call Mem_CopyFromBank                         ; $49D7
    ld a, $54                                     ; $49DA
    ldh [hLycShadowSplit1], a                     ; $49DC
    ldh [hSplit1Latch], a                         ; $49DE
    ld hl, hStatShadow                            ; $49E0
    set 6, [hl]                                   ; $49E3
    ld hl, rIE                                    ; $49E5
    set 1, [hl]                                   ; $49E8
    ld a, $01                                     ; $49EA
    ldh [hStatHandlerIndex], a                    ; $49EC
    call Oam_ClearShadow                          ; $49EE
    call Pal_AllWhite                             ; $49F1
    call Lcd_On                                   ; $49F4
    call Pal_FadeIn                               ; $49F7

jr_006_49fa:
    ldh a, [hFrameCounter]                        ; $49FA
    and $01                                       ; $49FC
    jr nz, jr_006_4a0c                            ; $49FE

    call Rng_Next                                 ; $4A00
    ld [wJitterX], a                              ; $4A03
    call Rng_Next                                 ; $4A06
    ld [wJitterY], a                              ; $4A09

jr_006_4a0c:
    ld a, [wJitterX]                              ; $4A0C
    and $01                                       ; $4A0F
    add $28                                       ; $4A11
    ld b, a                                       ; $4A13
    ld a, [wJitterY]                              ; $4A14
    and $01                                       ; $4A17
    add $48                                       ; $4A19
    ld c, a                                       ; $4A1B
    ld a, $5e                                     ; $4A1C
    call Oam_AddMeta_B02_5272                     ; $4A1E
    call Oam_HideUnused                           ; $4A21
    rst Rst08_WaitVBlank                          ; $4A24
    ldh a, [hKeysNew]                             ; $4A25
    and PADF_A | PADF_B                           ; $4A27
    jr z, jr_006_49fa                             ; $4A29

    bit 0, a                                      ; $4A2B
    jr z, jr_006_4a38                             ; $4A2D

    push af                                       ; $4A2F
    ld a, SFX1_KEY_A                              ; $4A30
    call Snd_Sfx1                                 ; $4A32
    pop af                                        ; $4A35
    jr jr_006_4a3f                                ; $4A36

jr_006_4a38:
    push af                                       ; $4A38
    ld a, SFX1_KEY_B                              ; $4A39
    call Snd_Sfx1                                 ; $4A3B
    pop af                                        ; $4A3E

jr_006_4a3f:
    push af                                       ; $4A3F
    call Pal_FadeOut                              ; $4A40
    call Lcd_Off                                  ; $4A43
    ld hl, hStatShadow                            ; $4A46
    res 6, [hl]                                   ; $4A49
    ld hl, rIE                                    ; $4A4B
    res 1, [hl]                                   ; $4A4E
    pop af                                        ; $4A50
    bit 0, a                                      ; $4A51
    ret nz                                        ; $4A53

    ld a, MODE_SHUTTERBUG_MAGIC                   ; $4A54
    ld [wMode], a                                 ; $4A56
    set_state STATE_16_REDRAW                     ; $4A59
    ret                                           ; $4A5E


; C: mode 18
Mode16_State09_ToPanoramaPrint::
    ld a, MODE_PANORAMA_PRINT                     ; $4A5F
    ld [wMode], a                                 ; $4A61
    set_state STATE_18_INIT                       ; $4A64
    call Pal_FadeOut                              ; $4A69
    call Lcd_Off                                  ; $4A6C
    ret                                           ; $4A6F


; C
Mode16_DrawCursorFromTable::
    sla a                                         ; $4A70
    ld c, a                                       ; $4A72
    ld b, $00                                     ; $4A73
    add hl, bc                                    ; $4A75
    ld c, [hl]                                    ; $4A76
    inc hl                                        ; $4A77
    ld b, [hl]                                    ; $4A78
    ld a, [wCursorAnimFrame]                      ; $4A79
    and $03                                       ; $4A7C
    sla a                                         ; $4A7E
    ld e, a                                       ; $4A80
    ld d, $00                                     ; $4A81
    ld hl, Mode16_CursorAnimTbl                   ; $4A83
    add hl, de                                    ; $4A86
    ld a, [hl+]                                   ; $4A87
    call Oam_AddMeta_B02_5272                     ; $4A88
    ld a, [wCursorAnimTick]                       ; $4A8B
    cp [hl]                                       ; $4A8E
    jr c, jr_006_4a96                             ; $4A8F

    ld hl, wCursorAnimFrame                       ; $4A91
    inc [hl]                                      ; $4A94
    xor a                                         ; $4A95

jr_006_4a96:
    inc a                                         ; $4A96
    ld [wCursorAnimTick], a                       ; $4A97
    ret                                           ; $4A9A


; C: 4 x {OAM list id; ticks} = $30, $31, $32, $31, 9 ticks each: the animated cursor of Mode16_DrawCursorFromTable,
; frame wCursorAnimFrame and 3, tick wCursorAnimTick (read 2026-10-25)
Mode16_CursorAnimTbl::
    db $30, $09, $31, $09, $32, $09, $31, $09

; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (8374 hits in 17 runs: 16:03 x6460 16:04 x1914;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawIcon::
    sla a                                         ; $4AA3
    ld c, a                                       ; $4AA5
    ld b, $00                                     ; $4AA6
    add hl, bc                                    ; $4AA8
    ld a, [hl+]                                   ; $4AA9
    ld bc, $6060                                  ; $4AAA
    cp $ff                                        ; $4AAD
    call nz, Oam_AddMeta_B02_5272                 ; $4AAF
    ld a, [hl]                                    ; $4AB2
    ld bc, $6060                                  ; $4AB3
    cp $ff                                        ; $4AB6
    call nz, Oam_AddMeta_B02_5272                 ; $4AB8
    ret                                           ; $4ABB


; C: Up / Down steps a row cursor (HL) up to C
Mode16_StepRow::
    ldh a, [hKeysNewRepeat]                       ; $4ABC
    ld b, a                                       ; $4ABE
    ld a, [hl]                                    ; $4ABF
    bit 6, b                                      ; $4AC0
    jr z, jr_006_4ac9                             ; $4AC2

    and a                                         ; $4AC4
    ret z                                         ; $4AC5

    dec a                                         ; $4AC6
    jr jr_006_4acf                                ; $4AC7

jr_006_4ac9:
    bit 7, b                                      ; $4AC9
    ret z                                         ; $4ACB

    cp c                                          ; $4ACC
    ret nc                                        ; $4ACD

    inc a                                         ; $4ACE

jr_006_4acf:
    cp [hl]                                       ; $4ACF
    ret z                                         ; $4AD0

    ld [hl], a                                    ; $4AD1
    push af                                       ; $4AD2
    ld a, SFX1_KEY_UP_DOWN                        ; $4AD3
    call Snd_Sfx1                                 ; $4AD5
    pop af                                        ; $4AD8
    ret                                           ; $4AD9


; C: Left / Right steps a value
Mode16_StepValue::
    ldh a, [hKeysNewRepeat]                       ; $4ADA
    ld b, a                                       ; $4ADC
    ld a, [hl]                                    ; $4ADD
    bit 5, b                                      ; $4ADE
    jr z, jr_006_4ae7                             ; $4AE0

    and a                                         ; $4AE2
    ret z                                         ; $4AE3

    dec a                                         ; $4AE4
    jr jr_006_4aed                                ; $4AE5

jr_006_4ae7:
    bit 4, b                                      ; $4AE7
    ret z                                         ; $4AE9

    cp c                                          ; $4AEA
    ret z                                         ; $4AEB

    inc a                                         ; $4AEC

jr_006_4aed:
    cp [hl]                                       ; $4AED
    ret z                                         ; $4AEE

    ld [hl], a                                    ; $4AEF
    push af                                       ; $4AF0
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4AF1
    call Snd_Sfx1                                 ; $4AF3
    pop af                                        ; $4AF6
    ret                                           ; $4AF7


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (98 hits in 24 runs: 16:00 x25 16:01 x14 16:02 x59;
; tcrf_check/assets/mode_state_wp/)
Mode16_LoadPageTiles::
    ld a, [wOptMenuCursor]                        ; $4AF8
    ld c, a                                       ; $4AFB
    sla a                                         ; $4AFC
    add c                                         ; $4AFE
    ld c, a                                       ; $4AFF
    ld b, $00                                     ; $4B00
    ld hl, Mode16_PageTilesSrcTbl                 ; $4B02
    add hl, bc                                    ; $4B05
    ld c, [hl]                                    ; $4B06
    inc hl                                        ; $4B07
    ld b, [hl]                                    ; $4B08
    inc hl                                        ; $4B09
    ld a, [hl]                                    ; $4B0A
    ld l, c                                       ; $4B0B
    ld h, b                                       ; $4B0C
    ld de, $9000                                  ; $4B0D
    ld bc, $0280                                  ; $4B10
    call Vram_CopyFromBank                        ; $4B13
    ret                                           ; $4B16


; C: 4 x {lo; hi; bank} = 0D:5A80 5800 5580 5300 (the Gfx_0D_*_Strip06_4B17 rows): Mode16_LoadPageTiles (06:4AF8)
; copies $280 B of the entry wOptMenuCursor to $9000 (read 2026-10-25)
Mode16_PageTilesSrcTbl::
    dwb Gfx_0D_5A80_Strip06_4B17
    dwb Gfx_0D_5800_Strip06_4B17
    dwb Gfx_0D_5580_Strip06_4B17
    dwb Gfx_0D_5300_Strip06_4B17

; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (172 hits in 24 runs: 16:00 x100 16:01 x56 16:03 x10 16:04
; x6; tcrf_check/assets/mode_state_wp/)
Mode16_LoadIconTiles::
    ld c, a                                       ; $4B23
    sla a                                         ; $4B24
    add c                                         ; $4B26
    ld c, a                                       ; $4B27
    ld b, $00                                     ; $4B28
    add hl, bc                                    ; $4B2A
    ld c, [hl]                                    ; $4B2B
    inc hl                                        ; $4B2C
    ld b, [hl]                                    ; $4B2D
    inc hl                                        ; $4B2E
    ld a, [hl]                                    ; $4B2F
    ld l, c                                       ; $4B30
    ld h, b                                       ; $4B31
    ld bc, $0100                                  ; $4B32
    call Vram_CopyFromBank                        ; $4B35
    ret                                           ; $4B38


; C: jumps through the list builders
Mode16_BuildOptionList::
    ld a, [wOptMenuCursor]                        ; $4B39
    ld c, a                                       ; $4B3C
    sla a                                         ; $4B3D
    add c                                         ; $4B3F
    ld c, a                                       ; $4B40
    ld b, $00                                     ; $4B41
    ld hl, Mode16_OptionMapSrcTbl                 ; $4B43
    add hl, bc                                    ; $4B46
    ld c, [hl]                                    ; $4B47
    inc hl                                        ; $4B48
    ld b, [hl]                                    ; $4B49
    inc hl                                        ; $4B4A
    ld a, [hl]                                    ; $4B4B
    ld l, c                                       ; $4B4C
    ld h, b                                       ; $4B4D
    ld de, $9840                                  ; $4B4E
    ld bc, $0200                                  ; $4B51
    call Vram_CopyFromBank                        ; $4B54
    ld a, [wOptMenuCursor]                        ; $4B57
    sla a                                         ; $4B5A
    ld c, a                                       ; $4B5C
    ld b, $00                                     ; $4B5D
    ld hl, Mode16_BuilderTbl                      ; $4B5F
    add hl, bc                                    ; $4B62
    ld a, [hl+]                                   ; $4B63
    ld h, [hl]                                    ; $4B64
    ld l, a                                       ; $4B65
    jp hl                                         ; $4B66


; C: 4 x {lo; hi; bank} = 25:71A0, 25:50C0, 24:63A0, 25:5360 (Map_*_Mode16_OptionPage0-3): Mode16_BuildOptionList
; (06:4B43) copies $200 B of the entry wOptMenuCursor to $9840; far pointers to maps, not a map (read 2026-10-25)
Mode16_OptionMapSrcTbl::
    dwb Map_25_71A0_Mode16_OptionPage0
    dwb Map_25_50C0_Mode16_OptionPage1
    dwb Map_24_63A0_Mode16_OptionPage2
    dwb Map_25_5360_Mode16_OptionPage3

; C: 4 code pointers
Mode16_BuilderTbl::
    dw Mode16_BuildList0
    dw Mode16_BuildList2
    dw Mode16_BuildList4
    dw Mode16_BuildList6

; C: nothing to build
Mode16_BuildList0::
    ret                                           ; $4B7B


; C: two rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (8 hits in 4 runs: 16:04 x8;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList2::
    ld bc, $0002                                  ; $4B7C
    call Wait_Frames                              ; $4B7F
    ld hl, $51e7                                  ; $4B82
    ld de, $9947                                  ; $4B85
    ld b, $02                                     ; $4B88

jr_006_4b8a:
    push bc                                       ; $4B8A
    push de                                       ; $4B8B
    push hl                                       ; $4B8C
    ld b, $03                                     ; $4B8D

jr_006_4b8f:
    push bc                                       ; $4B8F
    push de                                       ; $4B90
    push hl                                       ; $4B91
    ld a, $25                                     ; $4B92
    ld bc, $0008                                  ; $4B94
    call Vram_CopyFromBank                        ; $4B97
    pop hl                                        ; $4B9A
    pop de                                        ; $4B9B
    pop bc                                        ; $4B9C
    ld a, e                                       ; $4B9D
    add $20                                       ; $4B9E
    ld e, a                                       ; $4BA0
    jr nc, jr_006_4ba4                            ; $4BA1

    inc d                                         ; $4BA3

jr_006_4ba4:
    ld a, l                                       ; $4BA4
    add $20                                       ; $4BA5
    ld l, a                                       ; $4BA7
    jr nc, jr_006_4bab                            ; $4BA8

    inc h                                         ; $4BAA

jr_006_4bab:
    dec b                                         ; $4BAB
    jr nz, jr_006_4b8f                            ; $4BAC

    ld bc, $0002                                  ; $4BAE
    call Wait_Frames                              ; $4BB1
    pop hl                                        ; $4BB4
    pop de                                        ; $4BB5
    pop bc                                        ; $4BB6
    ld a, e                                       ; $4BB7
    sub $20                                       ; $4BB8
    ld e, a                                       ; $4BBA
    jr nc, jr_006_4bbe                            ; $4BBB

    dec d                                         ; $4BBD

jr_006_4bbe:
    dec b                                         ; $4BBE
    jr nz, jr_006_4b8a                            ; $4BBF

    farcopy Vram_CopyFromBank, Map_25_52C0_Mode16_BuildList2, $9980, $0060 ; $4BC1
    ret                                           ; $4BCF


; C: four rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (34 hits in 13 runs: 16:01 x8 16:05 x26;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList4::
    ld bc, $0002                                  ; $4BD0
    call Wait_Frames                              ; $4BD3
    ld hl, $6507                                  ; $4BD6
    ld de, $9987                                  ; $4BD9
    ld b, $04                                     ; $4BDC

jr_006_4bde:
    push bc                                       ; $4BDE
    push de                                       ; $4BDF
    push hl                                       ; $4BE0
    ld b, $03                                     ; $4BE1

jr_006_4be3:
    push bc                                       ; $4BE3
    push de                                       ; $4BE4
    push hl                                       ; $4BE5
    ld a, $24                                     ; $4BE6
    ld bc, $0008                                  ; $4BE8
    call Vram_CopyFromBank                        ; $4BEB
    pop hl                                        ; $4BEE
    pop de                                        ; $4BEF
    pop bc                                        ; $4BF0
    ld a, e                                       ; $4BF1
    add $20                                       ; $4BF2
    ld e, a                                       ; $4BF4
    jr nc, jr_006_4bf8                            ; $4BF5

    inc d                                         ; $4BF7

jr_006_4bf8:
    ld a, l                                       ; $4BF8
    add $20                                       ; $4BF9
    ld l, a                                       ; $4BFB
    jr nc, jr_006_4bff                            ; $4BFC

    inc h                                         ; $4BFE

jr_006_4bff:
    dec b                                         ; $4BFF
    jr nz, jr_006_4be3                            ; $4C00

    ld bc, $0002                                  ; $4C02
    call Wait_Frames                              ; $4C05
    pop hl                                        ; $4C08
    pop de                                        ; $4C09
    pop bc                                        ; $4C0A
    ld a, e                                       ; $4C0B
    sub $20                                       ; $4C0C
    ld e, a                                       ; $4C0E
    jr nc, jr_006_4c12                            ; $4C0F

    dec d                                         ; $4C11

jr_006_4c12:
    dec b                                         ; $4C12
    jr nz, jr_006_4bde                            ; $4C13

    farcopy Vram_CopyFromBank, Map_24_65A0_Mode16_BuildList4, $9980, $0080 ; $4C15
    ret                                           ; $4C23


; C: six rows; BGB watchpoint pass 2026-10-25: ran only in mode 16 (38 hits in 7 runs: 16:01 x8 16:06 x30;
; tcrf_check/assets/mode_state_wp/)
Mode16_BuildList6::
    ld bc, $0002                                  ; $4C24
    call Wait_Frames                              ; $4C27
    ld hl, $5507                                  ; $4C2A
    ld de, $99c7                                  ; $4C2D
    ld b, $06                                     ; $4C30

jr_006_4c32:
    push bc                                       ; $4C32
    push de                                       ; $4C33
    push hl                                       ; $4C34
    ld b, $02                                     ; $4C35

jr_006_4c37:
    push bc                                       ; $4C37
    push de                                       ; $4C38
    push hl                                       ; $4C39
    ld a, $25                                     ; $4C3A
    ld bc, $0008                                  ; $4C3C
    call Vram_CopyFromBank                        ; $4C3F
    pop hl                                        ; $4C42
    pop de                                        ; $4C43
    pop bc                                        ; $4C44
    ld a, e                                       ; $4C45
    add $20                                       ; $4C46
    ld e, a                                       ; $4C48
    jr nc, jr_006_4c4c                            ; $4C49

    inc d                                         ; $4C4B

jr_006_4c4c:
    ld a, l                                       ; $4C4C
    add $20                                       ; $4C4D
    ld l, a                                       ; $4C4F
    jr nc, jr_006_4c53                            ; $4C50

    inc h                                         ; $4C52

jr_006_4c53:
    dec b                                         ; $4C53
    jr nz, jr_006_4c37                            ; $4C54

    ld a, l                                       ; $4C56
    sub $60                                       ; $4C57
    ld l, a                                       ; $4C59
    jr nc, jr_006_4c5d                            ; $4C5A

    dec h                                         ; $4C5C

jr_006_4c5d:
    ld a, $25                                     ; $4C5D
    ld bc, $0008                                  ; $4C5F
    call Vram_CopyFromBank                        ; $4C62
    ld bc, $0002                                  ; $4C65
    call Wait_Frames                              ; $4C68
    pop hl                                        ; $4C6B
    pop de                                        ; $4C6C
    pop bc                                        ; $4C6D
    ld a, e                                       ; $4C6E
    sub $20                                       ; $4C6F
    ld e, a                                       ; $4C71
    jr nc, jr_006_4c75                            ; $4C72

    dec d                                         ; $4C74

jr_006_4c75:
    dec b                                         ; $4C75
    jr nz, jr_006_4c32                            ; $4C76

    farcopy Vram_CopyFromBank, Map_25_5560_Mode16_BuildList6, $9980, $0060 ; $4C78
    ret                                           ; $4C86


; C: BGB watchpoint pass 2026-10-25: ran only in mode 16 (4187 hits in 17 runs: 16:03 x3230 16:04 x957;
; tcrf_check/assets/mode_state_wp/)
Mode16_DrawCaptionBlink::
    ldh a, [hFrameCounter]                        ; $4C87
    bit 3, a                                      ; $4C89
    jr z, jr_006_4c96                             ; $4C8B

    ld a, $45                                     ; $4C8D
    ld bc, $5760                                  ; $4C8F
    call Oam_AddMeta_B02_5272                     ; $4C92
    ret                                           ; $4C95


jr_006_4c96:
    ld a, $46                                     ; $4C96
    ld bc, $5760                                  ; $4C98
    call Oam_AddMeta_B02_5272                     ; $4C9B
    ret                                           ; $4C9E


; C: mode 17: COMPOSE (SPLIT 4 pictures / FUSION 2 pictures)
Mode17_SplitFusion::
    ld a, [wState]                                ; $4C9F
    rst Rst18_JumpTable                           ; $4CA2

; C: 20 states
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4CCB
    ldh [hLcdcShadow], a                          ; $4CCD
    ld a, $e4                                     ; $4CCF
    ld [wPaletteTarget], a                        ; $4CD1
    ld [wPaletteTarget + $1], a                   ; $4CD4
    ld a, $c6                                     ; $4CD7
    ld [wPaletteTarget + $2], a                   ; $4CD9
    xor a                                         ; $4CDC
    ldh [hScxShadow], a                           ; $4CDD
    ldh [hScyShadow], a                           ; $4CDF
    farcopy Mem_CopyFromBank, Gfx_1E_5C00_Mode17_State00_Init, $9000, $0300 ; $4CE1
    farcopy Mem_CopyFromBank, Gfx_1E_5F00_Mode17_State00_Init, $8a80, $0580 ; $4CEF
    farcopy Mem_CopyFromBank, Gfx_1E_6480_Mode17_State00_Init, $8000, $0030 ; $4CFD
    farcopy Mem_CopyFromBank, Gfx_1E_6570_Mode17_State00_Init, $80f0, $0010 ; $4D0B
    farcopy Mem_CopyFromBank, Gfx_1E_6580_Mode17_State00_Init, $8040, $0010 ; $4D19
    farcopy Mem_CopyFromBank, Map_24_68E0_Mode17_State00_Init, $9800, $0240 ; $4D27
    ld de, $93c8                                  ; $4D35
    ld b, $04                                     ; $4D38

jr_006_4d3a:
    ld hl, $6598                                  ; $4D3A
    ld c, $04                                     ; $4D3D

jr_006_4d3f:
    push bc                                       ; $4D3F
    ld a, $1e                                     ; $4D40
    ld bc, $0008                                  ; $4D42
    call Mem_CopyFromBank                         ; $4D45
    pop bc                                        ; $4D48
    ld a, l                                       ; $4D49
    add $08                                       ; $4D4A
    ld l, a                                       ; $4D4C
    jr nc, jr_006_4d50                            ; $4D4D

    inc h                                         ; $4D4F

jr_006_4d50:
    ld a, e                                       ; $4D50
    add $08                                       ; $4D51
    ld e, a                                       ; $4D53
    jr nc, jr_006_4d57                            ; $4D54

    inc d                                         ; $4D56

jr_006_4d57:
    dec c                                         ; $4D57
    jr nz, jr_006_4d3f                            ; $4D58

    ld a, e                                       ; $4D5A
    add $c0                                       ; $4D5B
    ld e, a                                       ; $4D5D
    jr nc, jr_006_4d61                            ; $4D5E

    inc d                                         ; $4D60

jr_006_4d61:
    dec b                                         ; $4D61
    jr nz, jr_006_4d3a                            ; $4D62

    call Oam_ClearShadow                          ; $4D64
    call Pal_AllWhite                             ; $4D67
    call Lcd_On                                   ; $4D6A
    push af                                       ; $4D6D
    ld a, MUSIC_COMPOSE                           ; $4D6E
    call Snd_Music                                ; $4D70
    pop af                                        ; $4D73
    call Compose_DrawLayoutPreview                ; $4D74
    call Pal_FadeIn                               ; $4D77
    next_state                                    ; $4D7A
    ret                                           ; $4D7E


; C
Compose_DrawLayoutPreview::
    ld a, [wComposeLayout]                        ; $4D7F
    and a                                         ; $4D82
    jr nz, jr_006_4dc4                            ; $4D83

    ld a, [wCompose4Photos]                       ; $4D85
    ld de, $9300                                  ; $4D88
    call Compose_LoadPhotoThumb                   ; $4D8B
    ld a, [wCompose4Photos + $1]                  ; $4D8E
    ld de, $9400                                  ; $4D91
    call Compose_LoadPhotoThumb                   ; $4D94
    ld a, [wCompose4Photos + $2]                  ; $4D97
    ld de, $9500                                  ; $4D9A
    call Compose_LoadPhotoThumb                   ; $4D9D
    ld a, [wCompose4Photos + $3]                  ; $4DA0
    ld de, $9600                                  ; $4DA3
    call Compose_LoadPhotoThumb                   ; $4DA6
    call Compose_LoadQuad0                        ; $4DA9
    call Compose_LoadQuad1                        ; $4DAC
    call Compose_LoadQuad2                        ; $4DAF
    call Compose_LoadQuad3                        ; $4DB2
    farcopy Vram_CopyFromBank, Map_24_6A20_Compose_DrawLayoutPreview, $9940, $0080 ; $4DB5
    ret                                           ; $4DC3


jr_006_4dc4:
    ld a, [wCompose2Photos]                       ; $4DC4
    ld de, $9300                                  ; $4DC7
    call Compose_LoadPhotoThumb                   ; $4DCA
    ld a, [wCompose2Photos + $1]                  ; $4DCD
    ld de, $9500                                  ; $4DD0
    call Compose_LoadPhotoThumb                   ; $4DD3
    call Compose_LoadHalf0                        ; $4DD6
    call Compose_LoadHalf1                        ; $4DD9
    farcopy Vram_CopyFromBank, Map_24_6B20_Compose_DrawLayoutPreview, $9940, $0080 ; $4DDC
    ret                                           ; $4DEA


; C: Left = SPLIT (4); Right = FUSION (2)
Mode17_State01_LayoutChoose::
    call Compose_ReadLayoutKeys                   ; $4DEB
    call Compose_DrawLayoutBlink                  ; $4DEE
    ldh a, [hKeysNew]                             ; $4DF1
    ld b, a                                       ; $4DF3
    and PADF_A | PADF_DOWN                        ; $4DF4
    jr z, jr_006_4e14                             ; $4DF6

    push af                                       ; $4DF8
    ld a, SFX1_MENU_CHOOSE                        ; $4DF9
    call Snd_Sfx1                                 ; $4DFB
    pop af                                        ; $4DFE
    call Compose_DrawLayoutPreview                ; $4DFF
    ld a, [wComposeLayout]                        ; $4E02
    and a                                         ; $4E05
    jr nz, jr_006_4e0e                            ; $4E06

    set_state STATE_17_SPLIT_CURSOR               ; $4E08
    ret                                           ; $4E0D


jr_006_4e0e:
    set_state STATE_17_FUSION_CURSOR              ; $4E0E
    ret                                           ; $4E13


jr_006_4e14:
    bit 1, b                                      ; $4E14
    ret z                                         ; $4E16

    push af                                       ; $4E17
    ld a, SFX1_KEY_B                              ; $4E18
    call Snd_Sfx1                                 ; $4E1A
    pop af                                        ; $4E1D
    set_state STATE_17_LEAVE                      ; $4E1E
    ret                                           ; $4E23


; C
Compose_ReadLayoutKeys::
    ldh a, [hKeysNew]                             ; $4E24
    bit PADB_LEFT, a                              ; $4E26
    jr z, jr_006_4e2d                             ; $4E28

    xor a                                         ; $4E2A
    jr jr_006_4e32                                ; $4E2B

jr_006_4e2d:
    bit 4, a                                      ; $4E2D
    ret z                                         ; $4E2F

    ld a, $01                                     ; $4E30

jr_006_4e32:
    ld hl, wComposeLayout                         ; $4E32
    cp [hl]                                       ; $4E35
    ret z                                         ; $4E36

    ld [hl], a                                    ; $4E37
    push af                                       ; $4E38
    ld a, SFX1_COMPOSE_LAYOUT_KEY                 ; $4E39
    call Snd_Sfx1                                 ; $4E3B
    pop af                                        ; $4E3E
    ret                                           ; $4E3F


; C: L3 pass 2026-10-26: executed in BGB in 19 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawLayoutBlink::
    ldh a, [hFrameCounter]                        ; $4E40
    bit 4, a                                      ; $4E42
    ret z                                         ; $4E44

; C
Compose_DrawLayoutCursor::
    ld a, [wComposeLayout]                        ; $4E45
    ld c, a                                       ; $4E48
    sla a                                         ; $4E49
    add c                                         ; $4E4B
    ld c, a                                       ; $4E4C
    ld b, $00                                     ; $4E4D
    ld hl, Compose_DrawLayoutCursor_Tbl4E5C       ; $4E4F
    add hl, bc                                    ; $4E52
    ld c, [hl]                                    ; $4E53
    inc hl                                        ; $4E54
    ld b, [hl]                                    ; $4E55
    inc hl                                        ; $4E56
    ld a, [hl]                                    ; $4E57
    call Oam_AddMeta_B02_5272                     ; $4E58
    ret                                           ; $4E5B


; C: auto: 6 bytes, bytes; referenced by Compose_DrawLayoutCursor. L3 pass 2026-10-26: read in BGB in 19 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawLayoutCursor_Tbl4E5C::
    db $10, $10, $4c, $10, $60, $4d

; C: four-picture layout: pick a quadrant
Mode17_State02_Split_Cursor::
    call Compose_DrawLayoutCursor                 ; $4E62
    ldh a, [hKeysNew]                             ; $4E65
    bit PADB_DOWN, a                              ; $4E67
    jr z, jr_006_4e7f                             ; $4E69

    push af                                       ; $4E6B
    ld a, SFX1_KEY_UP_DOWN                        ; $4E6C
    call Snd_Sfx1                                 ; $4E6E
    pop af                                        ; $4E71
    ld a, [wCompose4Cursor]                       ; $4E72
    bit 0, a                                      ; $4E75
    jr z, jr_006_4e7f                             ; $4E77

    set_state STATE_17_SPLIT_CONFIRM              ; $4E79
    ret                                           ; $4E7E


jr_006_4e7f:
    ldh a, [hKeysNew]                             ; $4E7F
    bit PADB_UP, a                                ; $4E81
    jr z, jr_006_4e99                             ; $4E83

    push af                                       ; $4E85
    ld a, SFX1_KEY_UP_DOWN                        ; $4E86
    call Snd_Sfx1                                 ; $4E88
    pop af                                        ; $4E8B
    ld a, [wCompose4Cursor]                       ; $4E8C
    bit 0, a                                      ; $4E8F
    jr nz, jr_006_4e99                            ; $4E91

    set_state STATE_17_LAYOUT_CHOOSE              ; $4E93
    ret                                           ; $4E98


jr_006_4e99:
    call Compose_Split_ReadKeys                   ; $4E99
    call Compose_Split_DrawCursor                 ; $4E9C
    ldh a, [hKeysNew]                             ; $4E9F
    bit PADB_A, a                                 ; $4EA1
    jr z, jr_006_4ec9                             ; $4EA3

    push af                                       ; $4EA5
    ld a, SFX1_KEY_A                              ; $4EA6
    call Snd_Sfx1                                 ; $4EA8
    pop af                                        ; $4EAB
    ld a, [wCompose4Cursor]                       ; $4EAC
    ld c, a                                       ; $4EAF
    ld b, $00                                     ; $4EB0
    ld hl, wCompose4Photos                        ; $4EB2
    add hl, bc                                    ; $4EB5
    ld a, [hl]                                    ; $4EB6
    call Compose_DrawPhotoNumber                  ; $4EB7
    ld a, [wCompose4Cursor]                       ; $4EBA
    ld c, a                                       ; $4EBD
    ld b, $00                                     ; $4EBE
    ld hl, Mode17_State02_Split_Cursor_Tbl4ED9    ; $4EC0
    add hl, bc                                    ; $4EC3
    ld a, [hl]                                    ; $4EC4
    ld [wState], a                                ; $4EC5
    ret                                           ; $4EC8


jr_006_4ec9:
    bit 1, a                                      ; $4EC9
    ret z                                         ; $4ECB

    push af                                       ; $4ECC
    ld a, SFX1_KEY_B                              ; $4ECD
    call Snd_Sfx1                                 ; $4ECF
    pop af                                        ; $4ED2
    set_state STATE_17_LEAVE                      ; $4ED3
    ret                                           ; $4ED8


; C: auto: 4 bytes, bytes; referenced by Mode17_State02_Split_Cursor. L3 pass 2026-10-26: read in BGB in 16 replay(s)
; of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State02_Split_Cursor_Tbl4ED9::
    db $03, $04, $05, $06

; C
Compose_Split_ReadKeys::
    ldh a, [hKeysNew]                             ; $4EDD
    ld b, a                                       ; $4EDF
    ld a, [wCompose4Cursor]                       ; $4EE0
    bit 5, b                                      ; $4EE3
    jr z, jr_006_4ef5                             ; $4EE5

    bit 1, a                                      ; $4EE7
    ret z                                         ; $4EE9

    push af                                       ; $4EEA
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4EEB
    call Snd_Sfx1                                 ; $4EED
    pop af                                        ; $4EF0
    res 1, a                                      ; $4EF1
    jr jr_006_4f28                                ; $4EF3

jr_006_4ef5:
    bit 4, b                                      ; $4EF5
    jr z, jr_006_4f07                             ; $4EF7

    bit 1, a                                      ; $4EF9
    ret nz                                        ; $4EFB

    push af                                       ; $4EFC
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4EFD
    call Snd_Sfx1                                 ; $4EFF
    pop af                                        ; $4F02
    set 1, a                                      ; $4F03
    jr jr_006_4f28                                ; $4F05

jr_006_4f07:
    bit 6, b                                      ; $4F07
    jr z, jr_006_4f19                             ; $4F09

    bit 0, a                                      ; $4F0B
    ret z                                         ; $4F0D

    push af                                       ; $4F0E
    ld a, SFX1_KEY_UP_DOWN                        ; $4F0F
    call Snd_Sfx1                                 ; $4F11
    pop af                                        ; $4F14
    res 0, a                                      ; $4F15
    jr jr_006_4f28                                ; $4F17

jr_006_4f19:
    bit 7, b                                      ; $4F19
    ret z                                         ; $4F1B

    bit 0, a                                      ; $4F1C
    ret nz                                        ; $4F1E

    push af                                       ; $4F1F
    ld a, SFX1_KEY_UP_DOWN                        ; $4F20
    call Snd_Sfx1                                 ; $4F22
    pop af                                        ; $4F25
    set 0, a                                      ; $4F26

jr_006_4f28:
    ld [wCompose4Cursor], a                       ; $4F28
    ret                                           ; $4F2B


; C
Compose_Split_DrawCursor::
    ld a, [wCompose4Cursor]                       ; $4F2C
    sla a                                         ; $4F2F
    ld c, a                                       ; $4F31
    ld b, $00                                     ; $4F32
    ld hl, Compose_Split_DrawCursor_Tbl4F4B       ; $4F34
    add hl, bc                                    ; $4F37
    ld c, [hl]                                    ; $4F38
    inc hl                                        ; $4F39
    ld b, [hl]                                    ; $4F3A
    ldh a, [hFrameCounter]                        ; $4F3B
    srl a                                         ; $4F3D
    srl a                                         ; $4F3F
    srl a                                         ; $4F41
    and $01                                       ; $4F43
    add $52                                       ; $4F45
    call Oam_AddMeta_B02_5272                     ; $4F47
    ret                                           ; $4F4A


; C: auto: 8 bytes, bytes; referenced by Compose_Split_DrawCursor. L3 pass 2026-10-26: read in BGB in 18 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Split_DrawCursor_Tbl4F4B::
    db $28, $08, $50, $08, $28, $78, $50, $78

; C: choose the picture of quadrant 1
Mode17_State03_Split_Pick1::
    call Compose_DrawLayoutCursor                 ; $4F53
    ld a, [wCompose4Photos]                       ; $4F56
    call Compose_StepPhoto                        ; $4F59
    ld hl, wCompose4Photos                        ; $4F5C
    cp [hl]                                       ; $4F5F
    ld [hl], a                                    ; $4F60
    jr z, jr_006_4f6c                             ; $4F61

    call Compose_DrawPhotoNumber                  ; $4F63
    ld de, $9300                                  ; $4F66
    call Compose_LoadPhotoThumb                   ; $4F69

jr_006_4f6c:
    ld bc, $102a                                  ; $4F6C
    ld hl, Mode17_State03_Split_Pick1_PtrTbl4F8A  ; $4F6F
    call Compose_DrawPhotoCursor                  ; $4F72
    ldh a, [hKeysHeld]                            ; $4F75
    bit PADB_A, a                                 ; $4F77
    ret nz                                        ; $4F79

    push af                                       ; $4F7A
    ld a, SFX1_KEY_B                              ; $4F7B
    call Snd_Sfx1                                 ; $4F7D
    pop af                                        ; $4F80
    call Compose_LoadQuad0                        ; $4F81
    set_state STATE_17_SPLIT_CURSOR               ; $4F84
    ret                                           ; $4F89


; C: auto: 4 bytes, word table; referenced by Mode17_State03_Split_Pick1. L3 pass 2026-10-26: read in BGB in 16
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State03_Split_Pick1_PtrTbl4F8A::
    dw $4a49
    dw $4a4b

; C
Mode17_State04_Split_Pick2::
    call Compose_DrawLayoutCursor                 ; $4F8E
    ld a, [wCompose4Photos + $1]                  ; $4F91
    call Compose_StepPhoto                        ; $4F94
    ld hl, wCompose4Photos + $1                   ; $4F97
    cp [hl]                                       ; $4F9A
    ld [hl], a                                    ; $4F9B
    jr z, jr_006_4fa7                             ; $4F9C

    call Compose_DrawPhotoNumber                  ; $4F9E
    ld de, $9400                                  ; $4FA1
    call Compose_LoadPhotoThumb                   ; $4FA4

jr_006_4fa7:
    ld bc, $1052                                  ; $4FA7
    ld hl, Mode17_State04_Split_Pick2_PtrTbl4FC5  ; $4FAA
    call Compose_DrawPhotoCursor                  ; $4FAD
    ldh a, [hKeysHeld]                            ; $4FB0
    bit PADB_A, a                                 ; $4FB2
    ret nz                                        ; $4FB4

    push af                                       ; $4FB5
    ld a, SFX1_KEY_B                              ; $4FB6
    call Snd_Sfx1                                 ; $4FB8
    pop af                                        ; $4FBB
    call Compose_LoadQuad1                        ; $4FBC
    set_state STATE_17_SPLIT_CURSOR               ; $4FBF
    ret                                           ; $4FC4


; C: auto: 4 bytes, word table; referenced by Mode17_State04_Split_Pick2. L3 pass 2026-10-26: read in BGB in 2
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State04_Split_Pick2_PtrTbl4FC5::
    dw $4a49
    dw $4a4b

; C
Mode17_State05_Split_Pick3::
    call Compose_DrawLayoutCursor                 ; $4FC9
    ld a, [wCompose4Photos + $2]                  ; $4FCC
    call Compose_StepPhoto                        ; $4FCF
    ld hl, wCompose4Photos + $2                   ; $4FD2
    cp [hl]                                       ; $4FD5
    ld [hl], a                                    ; $4FD6
    jr z, jr_006_4fe2                             ; $4FD7

    call Compose_DrawPhotoNumber                  ; $4FD9
    ld de, $9500                                  ; $4FDC
    call Compose_LoadPhotoThumb                   ; $4FDF

jr_006_4fe2:
    ld bc, $902a                                  ; $4FE2
    ld hl, Mode17_State05_Split_Pick3_PtrTbl5000  ; $4FE5
    call Compose_DrawPhotoCursor                  ; $4FE8
    ldh a, [hKeysHeld]                            ; $4FEB
    bit PADB_A, a                                 ; $4FED
    ret nz                                        ; $4FEF

    push af                                       ; $4FF0
    ld a, SFX1_KEY_B                              ; $4FF1
    call Snd_Sfx1                                 ; $4FF3
    pop af                                        ; $4FF6
    call Compose_LoadQuad2                        ; $4FF7
    set_state STATE_17_SPLIT_CURSOR               ; $4FFA
    ret                                           ; $4FFF


; C: auto: 4 bytes, word table; referenced by Mode17_State05_Split_Pick3. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State05_Split_Pick3_PtrTbl5000::
    dw $504f
    dw $5051

; C
Mode17_State06_Split_Pick4::
    call Compose_DrawLayoutCursor                 ; $5004
    ld a, [wCompose4Photos + $3]                  ; $5007
    call Compose_StepPhoto                        ; $500A
    ld hl, wCompose4Photos + $3                   ; $500D
    cp [hl]                                       ; $5010
    ld [hl], a                                    ; $5011
    jr z, jr_006_501d                             ; $5012

    call Compose_DrawPhotoNumber                  ; $5014
    ld de, $9600                                  ; $5017
    call Compose_LoadPhotoThumb                   ; $501A

jr_006_501d:
    ld bc, $9052                                  ; $501D
    ld hl, Mode17_State06_Split_Pick4_PtrTbl503B  ; $5020
    call Compose_DrawPhotoCursor                  ; $5023
    ldh a, [hKeysHeld]                            ; $5026
    bit PADB_A, a                                 ; $5028
    ret nz                                        ; $502A

    push af                                       ; $502B
    ld a, SFX1_KEY_B                              ; $502C
    call Snd_Sfx1                                 ; $502E
    pop af                                        ; $5031
    call Compose_LoadQuad3                        ; $5032
    set_state STATE_17_SPLIT_CURSOR               ; $5035
    ret                                           ; $503A


; C: auto: 4 bytes, word table; referenced by Mode17_State06_Split_Pick4. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State06_Split_Pick4_PtrTbl503B::
    dw $504f
    dw $5051

; C: Up: make the composite
Mode17_State07_Split_Confirm::
    call Compose_DrawLayoutCursor                 ; $503F
    call Compose_Split_DrawMakeBlink              ; $5042
    ldh a, [hKeysNew]                             ; $5045
    bit PADB_UP, a                                ; $5047
    jr z, jr_006_5058                             ; $5049

    push af                                       ; $504B
    ld a, SFX1_KEY_UP_DOWN                        ; $504C
    call Snd_Sfx1                                 ; $504E
    pop af                                        ; $5051
    set_state STATE_17_SPLIT_CURSOR               ; $5052
    ret                                           ; $5057


jr_006_5058:
    bit 0, a                                      ; $5058
    jr z, jr_006_5076                             ; $505A

    ld a, [wPhotoCount]                           ; $505C
    cp $1e                                        ; $505F
    jr nc, jr_006_5070                            ; $5061

    push af                                       ; $5063
    ld a, SFX1_CHOOSE                             ; $5064
    call Snd_Sfx1                                 ; $5066
    pop af                                        ; $5069
    set_state STATE_17_SPLIT_BUILD                ; $506A
    ret                                           ; $506F


jr_006_5070:
    set_state STATE_17_RESULT_PREPARE             ; $5070
    ret                                           ; $5075


jr_006_5076:
    bit 1, a                                      ; $5076
    ret z                                         ; $5078

    push af                                       ; $5079
    ld a, SFX1_KEY_B                              ; $507A
    call Snd_Sfx1                                 ; $507C
    pop af                                        ; $507F
    set_state STATE_17_LEAVE                      ; $5080
    ret                                           ; $5085


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Split_DrawMakeBlink::
    ldh a, [hFrameCounter]                        ; $5086
    bit 4, a                                      ; $5088
    ret z                                         ; $508A

    ld bc, $3878                                  ; $508B
    ld a, $4e                                     ; $508E
    call Oam_AddMeta_B02_5272                     ; $5090
    ret                                           ; $5093


; C: reduces the four pictures into the 2x2 composite
Mode17_State08_Split_Build::
    call Pal_FadeOut                              ; $5094
    call Lcd_Off                                  ; $5097
    ld a, $d2                                     ; $509A
    ld [wPaletteTarget + $2], a                   ; $509C
    ld hl, $8000                                  ; $509F
    ld bc, $0500                                  ; $50A2
    call Mem_Zero                                 ; $50A5
    ld hl, $8800                                  ; $50A8
    ld bc, $0100                                  ; $50AB
    call Mem_Zero                                 ; $50AE
    ld hl, $9000                                  ; $50B1
    ld bc, $0800                                  ; $50B4
    call Mem_Zero                                 ; $50B7
    farcopy Mem_CopyFromBank, Map_27_44B2_Mode17_State08_Split_Build, $9800, $02c0 ; $50BA
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $50C8
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $50D6
    ld a, $54                                     ; $50E4
    ldh [hLycShadowSplit1], a                     ; $50E6
    ldh [hSplit1Latch], a                         ; $50E8
    ld hl, hStatShadow                            ; $50EA
    set 6, [hl]                                   ; $50ED
    ld hl, rIE                                    ; $50EF
    set 1, [hl]                                   ; $50F2
    ld a, $01                                     ; $50F4
    ldh [hStatHandlerIndex], a                    ; $50F6
    call Oam_ClearShadow                          ; $50F8
    call Lcd_On                                   ; $50FB
    call Pal_FadeIn                               ; $50FE
    call Compose_BuildSplit                       ; $5101
    call Compose_DrawFreeCount                    ; $5104
    next_state                                    ; $5107
    ret                                           ; $510B


; C: A: save the picture; B: cancel
Mode17_State09_Split_Result::
    call Compose_DrawJitter                       ; $510C
    ldh a, [hKeysNew]                             ; $510F
    and PADF_A | PADF_B                           ; $5111
    ret z                                         ; $5113

    bit 0, a                                      ; $5114
    jr z, jr_006_5155                             ; $5116

    ld a, $00                                     ; $5118
    ld hl, $9000                                  ; $511A
    ld de, wPhotoImage                            ; $511D
    ld bc, $0800                                  ; $5120
    call Vram_CopyFromBank_4                      ; $5123
    ld a, $00                                     ; $5126
    ld hl, $8800                                  ; $5128
    ld de, wPhotoImage + $800                     ; $512B
    ld bc, $0100                                  ; $512E
    call Vram_CopyFromBank_4                      ; $5131
    ld a, $00                                     ; $5134
    ld hl, $8000                                  ; $5136
    ld de, wPhotoImage + $900                     ; $5139
    ld bc, $0500                                  ; $513C
    call Vram_CopyFromBank_4                      ; $513F
    ldh [hFarcallAArg], a                         ; $5142
    farcall Photo_SaveShot_Far                    ; $5144
    call Snd_PlayTagDigits                        ; $514C
    ld bc, $003c                                  ; $514F
    call Wait_Frames                              ; $5152

jr_006_5155:
    push af                                       ; $5155
    ld a, SFX1_KEY_B                              ; $5156
    call Snd_Sfx1                                 ; $5158
    pop af                                        ; $515B
    call Pal_FadeOut                              ; $515C
    call Lcd_Off                                  ; $515F
    ld hl, hStatShadow                            ; $5162
    res 6, [hl]                                   ; $5165
    ld hl, rIE                                    ; $5167
    res 1, [hl]                                   ; $516A
    set_state STATE_17_INIT                       ; $516C
    ret                                           ; $5171


; C: two-picture layout
Mode17_State0A_Fusion_Cursor::
    call Compose_DrawLayoutCursor                 ; $5172
    ldh a, [hKeysNew]                             ; $5175
    bit PADB_DOWN, a                              ; $5177
    jr z, jr_006_5188                             ; $5179

    push af                                       ; $517B
    ld a, SFX1_KEY_UP_DOWN                        ; $517C
    call Snd_Sfx1                                 ; $517E
    pop af                                        ; $5181
    set_state STATE_17_FUSION_CONFIRM             ; $5182
    ret                                           ; $5187


jr_006_5188:
    ldh a, [hKeysNew]                             ; $5188
    bit PADB_UP, a                                ; $518A
    jr z, jr_006_519b                             ; $518C

    push af                                       ; $518E
    ld a, SFX1_KEY_UP_DOWN                        ; $518F
    call Snd_Sfx1                                 ; $5191
    pop af                                        ; $5194
    set_state STATE_17_LAYOUT_CHOOSE              ; $5195
    ret                                           ; $519A


jr_006_519b:
    call Compose_Fusion_ReadKeys                  ; $519B
    call Compose_Fusion_DrawCursor                ; $519E
    ldh a, [hKeysNew]                             ; $51A1
    bit PADB_A, a                                 ; $51A3
    jr z, jr_006_51cb                             ; $51A5

    push af                                       ; $51A7
    ld a, SFX1_KEY_A                              ; $51A8
    call Snd_Sfx1                                 ; $51AA
    pop af                                        ; $51AD
    ld a, [wCompose2Cursor]                       ; $51AE
    ld c, a                                       ; $51B1
    ld b, $00                                     ; $51B2
    ld hl, wCompose2Photos                        ; $51B4
    add hl, bc                                    ; $51B7
    ld a, [hl]                                    ; $51B8
    call Compose_DrawPhotoNumber                  ; $51B9
    ld a, [wCompose2Cursor]                       ; $51BC
    ld c, a                                       ; $51BF
    ld b, $00                                     ; $51C0
    ld hl, Mode17_State0A_Fusion_Cursor_Tbl51DB   ; $51C2
    add hl, bc                                    ; $51C5
    ld a, [hl]                                    ; $51C6
    ld [wState], a                                ; $51C7
    ret                                           ; $51CA


jr_006_51cb:
    bit 1, a                                      ; $51CB
    ret z                                         ; $51CD

    push af                                       ; $51CE
    ld a, SFX1_KEY_B                              ; $51CF
    call Snd_Sfx1                                 ; $51D1
    pop af                                        ; $51D4
    set_state STATE_17_LEAVE                      ; $51D5
    ret                                           ; $51DA


; C: auto: 2 bytes, bytes; referenced by Mode17_State0A_Fusion_Cursor. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State0A_Fusion_Cursor_Tbl51DB::
    dw $0c0b

; C
Compose_Fusion_ReadKeys::
    ldh a, [hKeysNew]                             ; $51DD
    ld b, a                                       ; $51DF
    ld a, [wCompose2Cursor]                       ; $51E0
    bit 5, b                                      ; $51E3
    jr z, jr_006_51f5                             ; $51E5

    bit 0, a                                      ; $51E7
    ret z                                         ; $51E9

    push af                                       ; $51EA
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $51EB
    call Snd_Sfx1                                 ; $51ED
    pop af                                        ; $51F0
    res 0, a                                      ; $51F1
    jr jr_006_5204                                ; $51F3

jr_006_51f5:
    bit 4, b                                      ; $51F5
    ret z                                         ; $51F7

    bit 0, a                                      ; $51F8
    ret nz                                        ; $51FA

    push af                                       ; $51FB
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $51FC
    call Snd_Sfx1                                 ; $51FE
    pop af                                        ; $5201
    set 0, a                                      ; $5202

jr_006_5204:
    ld [wCompose2Cursor], a                       ; $5204
    ret                                           ; $5207


; C
Compose_Fusion_DrawCursor::
    ld a, [wCompose2Cursor]                       ; $5208
    sla a                                         ; $520B
    ld c, a                                       ; $520D
    ld b, $00                                     ; $520E
    ld hl, Compose_Fusion_DrawCursor_Tbl5227      ; $5210
    add hl, bc                                    ; $5213
    ld c, [hl]                                    ; $5214
    inc hl                                        ; $5215
    ld b, [hl]                                    ; $5216
    ldh a, [hFrameCounter]                        ; $5217
    srl a                                         ; $5219
    srl a                                         ; $521B
    srl a                                         ; $521D
    and $01                                       ; $521F
    add $52                                       ; $5221
    call Oam_AddMeta_B02_5272                     ; $5223
    ret                                           ; $5226


; C: auto: 4 bytes, bytes; referenced by Compose_Fusion_DrawCursor. L3 pass 2026-10-26: read in BGB in 4 replay(s) of
; the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Fusion_DrawCursor_Tbl5227::
    db $28, $08, $28, $78

; C
Mode17_State0B_Fusion_Pick1::
    call Compose_DrawLayoutCursor                 ; $522B
    ld a, [wCompose2Photos]                       ; $522E
    call Compose_StepPhoto                        ; $5231
    ld hl, wCompose2Photos                        ; $5234
    cp [hl]                                       ; $5237
    ld [hl], a                                    ; $5238
    jr z, jr_006_5244                             ; $5239

    call Compose_DrawPhotoNumber                  ; $523B
    ld de, $9300                                  ; $523E
    call Compose_LoadPhotoThumb                   ; $5241

jr_006_5244:
    ld bc, $102a                                  ; $5244
    ld hl, Mode17_State0B_Fusion_Pick1_PtrTbl5262 ; $5247
    call Compose_DrawPhotoCursor                  ; $524A
    ldh a, [hKeysHeld]                            ; $524D
    bit PADB_A, a                                 ; $524F
    ret nz                                        ; $5251

    push af                                       ; $5252
    ld a, SFX1_KEY_B                              ; $5253
    call Snd_Sfx1                                 ; $5255
    pop af                                        ; $5258
    call Compose_LoadHalf0                        ; $5259
    set_state STATE_17_FUSION_CURSOR              ; $525C
    ret                                           ; $5261


; C: auto: 4 bytes, word table; referenced by Mode17_State0B_Fusion_Pick1. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Mode17_State0B_Fusion_Pick1_PtrTbl5262::
    dw $4a49
    dw $4a4b

; C
Mode17_State0C_Fusion_Pick2::
    call Compose_DrawLayoutCursor                 ; $5266
    ld a, [wCompose2Photos + $1]                  ; $5269
    call Compose_StepPhoto                        ; $526C
    ld hl, wCompose2Photos + $1                   ; $526F
    cp [hl]                                       ; $5272
    ld [hl], a                                    ; $5273
    jr z, jr_006_527f                             ; $5274

    call Compose_DrawPhotoNumber                  ; $5276
    ld de, $9500                                  ; $5279
    call Compose_LoadPhotoThumb                   ; $527C

jr_006_527f:
    ld bc, $902a                                  ; $527F
    ld hl, Mode17_State0C_Fusion_Pick2_PtrTbl529D ; $5282
    call Compose_DrawPhotoCursor                  ; $5285
    ldh a, [hKeysHeld]                            ; $5288
    bit PADB_A, a                                 ; $528A
    ret nz                                        ; $528C

    push af                                       ; $528D
    ld a, SFX1_KEY_B                              ; $528E
    call Snd_Sfx1                                 ; $5290
    pop af                                        ; $5293
    call Compose_LoadHalf1                        ; $5294
    set_state STATE_17_FUSION_CURSOR              ; $5297
    ret                                           ; $529C


; C: auto: 4 bytes, word table; referenced by Mode17_State0C_Fusion_Pick2. L3 pass 2026-10-26: not reached by the 206
; BGB replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in
; mode 17)
Mode17_State0C_Fusion_Pick2_PtrTbl529D::
    dw $504f
    dw $5051

; C
Mode17_State0D_Fusion_Confirm::
    call Compose_DrawLayoutCursor                 ; $52A1
    call Compose_Fusion_DrawMakeBlink             ; $52A4
    ldh a, [hKeysNew]                             ; $52A7
    bit PADB_UP, a                                ; $52A9
    jr z, jr_006_52ba                             ; $52AB

    push af                                       ; $52AD
    ld a, SFX1_KEY_UP_DOWN                        ; $52AE
    call Snd_Sfx1                                 ; $52B0
    pop af                                        ; $52B3
    set_state STATE_17_FUSION_CURSOR              ; $52B4
    ret                                           ; $52B9


jr_006_52ba:
    bit 0, a                                      ; $52BA
    jr z, jr_006_52d8                             ; $52BC

    ld a, [wPhotoCount]                           ; $52BE
    cp $1e                                        ; $52C1
    jr nc, jr_006_52d2                            ; $52C3

    push af                                       ; $52C5
    ld a, SFX1_CHOOSE                             ; $52C6
    call Snd_Sfx1                                 ; $52C8
    pop af                                        ; $52CB
    set_state STATE_17_FUSION_BUILD               ; $52CC
    ret                                           ; $52D1


jr_006_52d2:
    set_state STATE_17_RESULT_PREPARE             ; $52D2
    ret                                           ; $52D7


jr_006_52d8:
    bit 1, a                                      ; $52D8
    ret z                                         ; $52DA

    push af                                       ; $52DB
    ld a, SFX1_KEY_B                              ; $52DC
    call Snd_Sfx1                                 ; $52DE
    pop af                                        ; $52E1
    set_state STATE_17_LEAVE                      ; $52E2
    ret                                           ; $52E7


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_Fusion_DrawMakeBlink::
    ldh a, [hFrameCounter]                        ; $52E8
    bit 4, a                                      ; $52EA
    ret z                                         ; $52EC

    ld bc, $3878                                  ; $52ED
    ld a, $4e                                     ; $52F0
    call Oam_AddMeta_B02_5272                     ; $52F2
    ret                                           ; $52F5


; C
Mode17_State0E_Fusion_Build::
    call Pal_FadeOut                              ; $52F6
    call Lcd_Off                                  ; $52F9
    ld a, $d2                                     ; $52FC
    ld [wPaletteTarget + $2], a                   ; $52FE
    ld hl, $8000                                  ; $5301
    ld bc, $0500                                  ; $5304
    call Mem_Zero                                 ; $5307
    ld hl, $8800                                  ; $530A
    ld bc, $0100                                  ; $530D
    call Mem_Zero                                 ; $5310
    ld hl, $9000                                  ; $5313
    ld bc, $0800                                  ; $5316
    call Mem_Zero                                 ; $5319
    farcopy Mem_CopyFromBank, Map_27_44B2_Mode17_State08_Split_Build, $9800, $02c0 ; $531C
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $532A
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $5338
    ld a, $54                                     ; $5346
    ldh [hLycShadowSplit1], a                     ; $5348
    ldh [hSplit1Latch], a                         ; $534A
    ld hl, hStatShadow                            ; $534C
    set 6, [hl]                                   ; $534F
    ld hl, rIE                                    ; $5351
    set 1, [hl]                                   ; $5354
    ld a, $01                                     ; $5356
    ldh [hStatHandlerIndex], a                    ; $5358
    call Oam_ClearShadow                          ; $535A
    call Lcd_On                                   ; $535D
    call Pal_FadeIn                               ; $5360
    call Compose_BuildFusion                      ; $5363
    call Compose_DrawFreeCount                    ; $5366
    next_state                                    ; $5369
    ret                                           ; $536D


; C
Mode17_State0F_Fusion_Result::
    call Compose_DrawJitter                       ; $536E
    ldh a, [hKeysNew]                             ; $5371
    and PADF_A | PADF_B                           ; $5373
    ret z                                         ; $5375

    bit 0, a                                      ; $5376
    jr z, jr_006_53b7                             ; $5378

    ld a, $00                                     ; $537A
    ld hl, $9000                                  ; $537C
    ld de, wPhotoImage                            ; $537F
    ld bc, $0800                                  ; $5382
    call Vram_CopyFromBank_4                      ; $5385
    ld a, $00                                     ; $5388
    ld hl, $8800                                  ; $538A
    ld de, wPhotoImage + $800                     ; $538D
    ld bc, $0100                                  ; $5390
    call Vram_CopyFromBank_4                      ; $5393
    ld a, $00                                     ; $5396
    ld hl, $8000                                  ; $5398
    ld de, wPhotoImage + $900                     ; $539B
    ld bc, $0500                                  ; $539E
    call Vram_CopyFromBank_4                      ; $53A1
    ldh [hFarcallAArg], a                         ; $53A4
    farcall Photo_SaveShot_Far                    ; $53A6
    call Snd_PlayTagDigits                        ; $53AE
    ld bc, $003c                                  ; $53B1
    call Wait_Frames                              ; $53B4

jr_006_53b7:
    push af                                       ; $53B7
    ld a, SFX1_KEY_B                              ; $53B8
    call Snd_Sfx1                                 ; $53BA
    pop af                                        ; $53BD
    call Pal_FadeOut                              ; $53BE
    call Lcd_Off                                  ; $53C1
    ld hl, hStatShadow                            ; $53C4
    res 6, [hl]                                   ; $53C7
    ld hl, rIE                                    ; $53C9
    res 1, [hl]                                   ; $53CC
    set_state STATE_17_INIT                       ; $53CE
    ret                                           ; $53D3


; C: back to mode 03
Mode17_State10_Leave::
    ld a, MODE_SPECIAL_MENU                       ; $53D4
    ld [wMode], a                                 ; $53D6
    set_state STATE_03_INIT                       ; $53D9
    call Pal_FadeOut                              ; $53DE
    call Lcd_Off                                  ; $53E1
    ret                                           ; $53E4


; C: message for the result screen
Mode17_State11_ResultPrepare::
    call Pal_FadeOut                              ; $53E5
    call Lcd_Off                                  ; $53E8
    ld hl, hStatShadow                            ; $53EB
    res 6, [hl]                                   ; $53EE
    ld hl, rIE                                    ; $53F0
    res 1, [hl]                                   ; $53F3
    xor a                                         ; $53F5
    ld [wSubstate], a                             ; $53F6
    ld a, $09                                     ; $53F9
    ld [wResultMsgId], a                          ; $53FB
    next_state                                    ; $53FE
    ret                                           ; $5402


; C: far call 09:7290
Mode17_State12_ResultScreen::
    ldh [hFarcallAArg], a                         ; $5403
    farcall ResultScreen_Far                      ; $5405
    ret                                           ; $540D


; C
Mode17_State13_Restart::
    set_state STATE_17_INIT                       ; $540E
    ret                                           ; $5413


; C: reduces picture 1 into its quadrant tiles
Compose_LoadQuad0::
    ld a, [wCompose4Photos]                       ; $5414
    ldh [hFarcallAArg], a                         ; $5417
    farcall Photo_GetSramAddress_Far              ; $5419
    ld l, a                                       ; $5421
    push hl                                       ; $5422
    push bc                                       ; $5423
    ld hl, sp+$00                                 ; $5424
    ld bc, wThumbGrid                             ; $5426
    call Img_ReduceQuadrantTo4x4Tiles             ; $5429
    pop bc                                        ; $542C
    pop hl                                        ; $542D
    ld a, $00                                     ; $542E
    ld hl, wThumbGrid                             ; $5430
    ld de, $9700                                  ; $5433
    ld bc, $0040                                  ; $5436
    call Vram_CopyFromBank                        ; $5439
    ld a, $00                                     ; $543C
    ld hl, wThumbGrid + $40                       ; $543E
    ld de, $9780                                  ; $5441
    ld bc, $0040                                  ; $5444
    call Vram_CopyFromBank                        ; $5447
    ld a, $00                                     ; $544A
    ld hl, wThumbGrid + $80                       ; $544C
    ld de, $8800                                  ; $544F
    ld bc, $0040                                  ; $5452
    call Vram_CopyFromBank                        ; $5455
    ld a, $00                                     ; $5458
    ld hl, wThumbGrid + $c0                       ; $545A
    ld de, $8880                                  ; $545D
    ld bc, $0008                                  ; $5460
    call Vram_CopyFromBank                        ; $5463
    ld a, $00                                     ; $5466
    ld hl, wThumbGrid + $d0                       ; $5468
    ld de, $8890                                  ; $546B
    ld bc, $0008                                  ; $546E
    call Vram_CopyFromBank                        ; $5471
    ld a, $00                                     ; $5474
    ld hl, wThumbGrid + $e0                       ; $5476
    ld de, $88a0                                  ; $5479
    ld bc, $0008                                  ; $547C
    call Vram_CopyFromBank                        ; $547F
    ld a, $00                                     ; $5482
    ld hl, wThumbGrid + $f0                       ; $5484
    ld de, $88b0                                  ; $5487
    ld bc, $0008                                  ; $548A
    call Vram_CopyFromBank                        ; $548D
    ret                                           ; $5490


; C
Compose_LoadQuad1::
    ld a, [wCompose4Photos + $1]                  ; $5491
    ldh [hFarcallAArg], a                         ; $5494
    farcall Photo_GetSramAddress_Far              ; $5496
    ld l, a                                       ; $549E
    push hl                                       ; $549F
    ld hl, $0600                                  ; $54A0
    add hl, bc                                    ; $54A3
    push hl                                       ; $54A4
    ld hl, sp+$00                                 ; $54A5
    ld bc, wThumbGrid                             ; $54A7
    call Img_ReduceQuadrantTo4x4Tiles             ; $54AA
    pop bc                                        ; $54AD
    pop hl                                        ; $54AE
    ld a, $00                                     ; $54AF
    ld hl, wThumbGrid + $8                        ; $54B1
    ld de, $8888                                  ; $54B4
    ld bc, $0008                                  ; $54B7
    call Vram_CopyFromBank                        ; $54BA
    ld a, $00                                     ; $54BD
    ld hl, wThumbGrid + $18                       ; $54BF
    ld de, $8898                                  ; $54C2
    ld bc, $0008                                  ; $54C5
    call Vram_CopyFromBank                        ; $54C8
    ld a, $00                                     ; $54CB
    ld hl, wThumbGrid + $28                       ; $54CD
    ld de, $88a8                                  ; $54D0
    ld bc, $0008                                  ; $54D3
    call Vram_CopyFromBank                        ; $54D6
    ld a, $00                                     ; $54D9
    ld hl, wThumbGrid + $38                       ; $54DB
    ld de, $88b8                                  ; $54DE
    ld bc, $0008                                  ; $54E1
    call Vram_CopyFromBank                        ; $54E4
    ld a, $00                                     ; $54E7
    ld hl, wThumbGrid + $40                       ; $54E9
    ld de, $8900                                  ; $54EC
    ld bc, $0040                                  ; $54EF
    call Vram_CopyFromBank                        ; $54F2
    ld a, $00                                     ; $54F5
    ld hl, wThumbGrid + $80                       ; $54F7
    ld de, $8980                                  ; $54FA
    ld bc, $0040                                  ; $54FD
    call Vram_CopyFromBank                        ; $5500
    ld a, $00                                     ; $5503
    ld hl, wThumbGrid + $c0                       ; $5505
    ld de, $8a00                                  ; $5508
    ld bc, $0040                                  ; $550B
    call Vram_CopyFromBank                        ; $550E
    ret                                           ; $5511


; C
Compose_LoadQuad2::
    ld a, [wCompose4Photos + $2]                  ; $5512
    ldh [hFarcallAArg], a                         ; $5515
    farcall Photo_GetSramAddress_Far              ; $5517
    ld l, a                                       ; $551F
    push hl                                       ; $5520
    ld hl, $0080                                  ; $5521
    add hl, bc                                    ; $5524
    push hl                                       ; $5525
    ld hl, sp+$00                                 ; $5526
    ld bc, wThumbGrid                             ; $5528
    call Img_ReduceQuadrantTo4x4Tiles             ; $552B
    pop bc                                        ; $552E
    pop hl                                        ; $552F
    ld a, $00                                     ; $5530
    ld hl, wThumbGrid                             ; $5532
    ld de, $9740                                  ; $5535
    ld bc, $0040                                  ; $5538
    call Vram_CopyFromBank                        ; $553B
    ld a, $00                                     ; $553E
    ld hl, wThumbGrid + $40                       ; $5540
    ld de, $97c0                                  ; $5543
    ld bc, $0040                                  ; $5546
    call Vram_CopyFromBank                        ; $5549
    ld a, $00                                     ; $554C
    ld hl, wThumbGrid + $80                       ; $554E
    ld de, $8840                                  ; $5551
    ld bc, $0040                                  ; $5554
    call Vram_CopyFromBank                        ; $5557
    ld a, $00                                     ; $555A
    ld hl, wThumbGrid + $c0                       ; $555C
    ld de, $88c0                                  ; $555F
    ld bc, $0008                                  ; $5562
    call Vram_CopyFromBank                        ; $5565
    ld a, $00                                     ; $5568
    ld hl, wThumbGrid + $d0                       ; $556A
    ld de, $88d0                                  ; $556D
    ld bc, $0008                                  ; $5570
    call Vram_CopyFromBank                        ; $5573
    ld a, $00                                     ; $5576
    ld hl, wThumbGrid + $e0                       ; $5578
    ld de, $88e0                                  ; $557B
    ld bc, $0008                                  ; $557E
    call Vram_CopyFromBank                        ; $5581
    ld a, $00                                     ; $5584
    ld hl, wThumbGrid + $f0                       ; $5586
    ld de, $88f0                                  ; $5589
    ld bc, $0008                                  ; $558C
    call Vram_CopyFromBank                        ; $558F
    ret                                           ; $5592


; C
Compose_LoadQuad3::
    ld a, [wCompose4Photos + $3]                  ; $5593
    ldh [hFarcallAArg], a                         ; $5596
    farcall Photo_GetSramAddress_Far              ; $5598
    ld l, a                                       ; $55A0
    push hl                                       ; $55A1
    ld hl, $0680                                  ; $55A2
    add hl, bc                                    ; $55A5
    push hl                                       ; $55A6
    ld hl, sp+$00                                 ; $55A7
    ld bc, wThumbGrid                             ; $55A9
    call Img_ReduceQuadrantTo4x4Tiles             ; $55AC
    pop bc                                        ; $55AF
    pop hl                                        ; $55B0
    ld a, $00                                     ; $55B1
    ld hl, wThumbGrid + $8                        ; $55B3
    ld de, $88c8                                  ; $55B6
    ld bc, $0008                                  ; $55B9
    call Vram_CopyFromBank                        ; $55BC
    ld a, $00                                     ; $55BF
    ld hl, wThumbGrid + $18                       ; $55C1
    ld de, $88d8                                  ; $55C4
    ld bc, $0008                                  ; $55C7
    call Vram_CopyFromBank                        ; $55CA
    ld a, $00                                     ; $55CD
    ld hl, wThumbGrid + $28                       ; $55CF
    ld de, $88e8                                  ; $55D2
    ld bc, $0008                                  ; $55D5
    call Vram_CopyFromBank                        ; $55D8
    ld a, $00                                     ; $55DB
    ld hl, wThumbGrid + $38                       ; $55DD
    ld de, $88f8                                  ; $55E0
    ld bc, $0008                                  ; $55E3
    call Vram_CopyFromBank                        ; $55E6
    ld a, $00                                     ; $55E9
    ld hl, wThumbGrid + $40                       ; $55EB
    ld de, $8940                                  ; $55EE
    ld bc, $0040                                  ; $55F1
    call Vram_CopyFromBank                        ; $55F4
    ld a, $00                                     ; $55F7
    ld hl, wThumbGrid + $80                       ; $55F9
    ld de, $89c0                                  ; $55FC
    ld bc, $0040                                  ; $55FF
    call Vram_CopyFromBank                        ; $5602
    ld a, $00                                     ; $5605
    ld hl, wThumbGrid + $c0                       ; $5607
    ld de, $8a40                                  ; $560A
    ld bc, $0040                                  ; $560D
    call Vram_CopyFromBank                        ; $5610
    ret                                           ; $5613


; C: reduces picture 1 into the left half of the fusion
Compose_LoadHalf0::
    ld a, [wCompose2Photos]                       ; $5614
    ldh [hFarcallAArg], a                         ; $5617
    farcall Photo_GetSramAddress_Far              ; $5619
    ld l, a                                       ; $5621
    push hl                                       ; $5622
    push bc                                       ; $5623
    ld hl, sp+$00                                 ; $5624
    ld bc, wReducedRows                           ; $5626
    call Img_ReduceHalfTo224Wide                  ; $5629
    pop bc                                        ; $562C
    pop hl                                        ; $562D
    ld de, wReducedRows                           ; $562E
    ld hl, $9700                                  ; $5631
    ld b, $40                                     ; $5634

jr_006_5636:
    call Compose_WriteTilePair                    ; $5636
    dec b                                         ; $5639
    jr nz, jr_006_5636                            ; $563A

    ld hl, $8800                                  ; $563C
    ld b, $a0                                     ; $563F

jr_006_5641:
    call Compose_WriteTilePair                    ; $5641
    dec b                                         ; $5644
    jr nz, jr_006_5641                            ; $5645

    ret                                           ; $5647


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_WriteTilePair::
    ld a, [de]                                    ; $5648
    call Vram_WriteByteSafe                       ; $5649
    inc de                                        ; $564C
    inc hl                                        ; $564D
    ld a, [de]                                    ; $564E
    call Vram_WriteByteSafe                       ; $564F
    inc de                                        ; $5652
    inc hl                                        ; $5653
    inc hl                                        ; $5654
    inc hl                                        ; $5655
    ret                                           ; $5656


; C
Compose_LoadHalf1::
    ld a, [wCompose2Photos + $1]                  ; $5657
    ldh [hFarcallAArg], a                         ; $565A
    farcall Photo_GetSramAddress_Far              ; $565C
    ld l, a                                       ; $5664
    push hl                                       ; $5665
    inc bc                                        ; $5666
    inc bc                                        ; $5667
    inc bc                                        ; $5668
    inc bc                                        ; $5669
    push bc                                       ; $566A
    ld hl, sp+$00                                 ; $566B
    ld bc, wReducedRows                           ; $566D
    call Img_ReduceHalfTo224Wide                  ; $5670
    pop bc                                        ; $5673
    pop hl                                        ; $5674
    ld de, wReducedRows                           ; $5675
    ld hl, $9702                                  ; $5678
    ld b, $40                                     ; $567B

jr_006_567d:
    call Compose_WriteTilePairB                   ; $567D
    dec b                                         ; $5680
    jr nz, jr_006_567d                            ; $5681

    ld hl, $8802                                  ; $5683
    ld b, $a0                                     ; $5686

jr_006_5688:
    call Compose_WriteTilePairB                   ; $5688
    dec b                                         ; $568B
    jr nz, jr_006_5688                            ; $568C

    ret                                           ; $568E


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_WriteTilePairB::
    ld a, [de]                                    ; $568F
    call Vram_WriteByteSafe                       ; $5690
    inc de                                        ; $5693
    inc hl                                        ; $5694
    ld a, [de]                                    ; $5695
    call Vram_WriteByteSafe                       ; $5696
    inc de                                        ; $5699
    inc hl                                        ; $569A
    inc hl                                        ; $569B
    inc hl                                        ; $569C
    ret                                           ; $569D


; C
Compose_DrawPhotoNumber::
    push af                                       ; $569E
    ld bc, $0000                                  ; $569F
    cp $1e                                        ; $56A2
    jr c, jr_006_56a9                             ; $56A4

    sub $1e                                       ; $56A6
    inc b                                         ; $56A8

jr_006_56a9:
    inc a                                         ; $56A9

jr_006_56aa:
    cp $0a                                        ; $56AA
    jr c, jr_006_56b3                             ; $56AC

    sub $0a                                       ; $56AE
    inc c                                         ; $56B0
    jr jr_006_56aa                                ; $56B1

jr_006_56b3:
    push bc                                       ; $56B3
    swap a                                        ; $56B4
    ld c, a                                       ; $56B6
    ld b, $00                                     ; $56B7
    ld hl, $64d0                                  ; $56B9
    add hl, bc                                    ; $56BC
    ld a, $1e                                     ; $56BD
    ld de, $8060                                  ; $56BF
    ld bc, $0010                                  ; $56C2
    call Vram_CopyFromBank                        ; $56C5
    pop bc                                        ; $56C8
    push bc                                       ; $56C9
    swap c                                        ; $56CA
    ld b, $00                                     ; $56CC
    ld hl, $64d0                                  ; $56CE
    add hl, bc                                    ; $56D1
    ld a, $1e                                     ; $56D2
    ld de, $8050                                  ; $56D4
    ld bc, $0010                                  ; $56D7
    call Vram_CopyFromBank                        ; $56DA
    pop bc                                        ; $56DD
    swap b                                        ; $56DE
    ld c, b                                       ; $56E0
    ld b, $00                                     ; $56E1
    ld hl, $64b0                                  ; $56E3
    add hl, bc                                    ; $56E6
    ld a, $1e                                     ; $56E7
    ld de, $8030                                  ; $56E9
    ld bc, $0010                                  ; $56EC
    call Vram_CopyFromBank                        ; $56EF
    pop af                                        ; $56F2
    ret                                           ; $56F3


; C: far 02:517B photo to buffer then tiles
Compose_LoadPhotoThumb::
    push de                                       ; $56F4
    ldh [hFarcallAArg], a                         ; $56F5
    farcall Photo_GetSramAddress_Far              ; $56F7
    pop de                                        ; $56FF
    ld hl, $0e00                                  ; $5700
    add hl, bc                                    ; $5703
    push af                                       ; $5704
    ld bc, $00c8                                  ; $5705
    push de                                       ; $5708
    push hl                                       ; $5709
    call Vram_CopyFromBank                        ; $570A
    pop hl                                        ; $570D
    pop de                                        ; $570E
    ld a, e                                       ; $570F
    add $d0                                       ; $5710
    ld e, a                                       ; $5712
    jr nc, jr_006_5716                            ; $5713

    inc d                                         ; $5715

jr_006_5716:
    ld bc, $00d0                                  ; $5716
    add hl, bc                                    ; $5719
    pop af                                        ; $571A
    push af                                       ; $571B
    ld bc, $0008                                  ; $571C
    push de                                       ; $571F
    push hl                                       ; $5720
    call Vram_CopyFromBank                        ; $5721
    pop hl                                        ; $5724
    pop de                                        ; $5725
    ld a, e                                       ; $5726
    add $10                                       ; $5727
    ld e, a                                       ; $5729
    jr nc, jr_006_572d                            ; $572A

    inc d                                         ; $572C

jr_006_572d:
    ld bc, $0010                                  ; $572D
    add hl, bc                                    ; $5730
    pop af                                        ; $5731
    push af                                       ; $5732
    ld bc, $0008                                  ; $5733
    push de                                       ; $5736
    push hl                                       ; $5737
    call Vram_CopyFromBank                        ; $5738
    pop hl                                        ; $573B
    pop de                                        ; $573C
    ld a, e                                       ; $573D
    add $10                                       ; $573E
    ld e, a                                       ; $5740
    jr nc, jr_006_5744                            ; $5741

    inc d                                         ; $5743

jr_006_5744:
    ld bc, $0010                                  ; $5744
    add hl, bc                                    ; $5747
    pop af                                        ; $5748
    ld bc, $0008                                  ; $5749
    call Vram_CopyFromBank                        ; $574C
    ret                                           ; $574F


; C: Left / Right steps the picture index (own pictures then stock)
Compose_StepPhoto::
    push af                                       ; $5750
    ld a, [wStockPictureCount]                    ; $5751
    add $1e                                       ; $5754
    ld c, a                                       ; $5756
    pop af                                        ; $5757
    ld hl, hKeysRepeatSticky                      ; $5758
    bit 6, [hl]                                   ; $575B
    jr z, jr_006_576b                             ; $575D

    push af                                       ; $575F
    ld a, SFX1_KEY_UP_DOWN                        ; $5760
    call Snd_Sfx1                                 ; $5762
    pop af                                        ; $5765
    inc a                                         ; $5766
    cp c                                          ; $5767
    ret nz                                        ; $5768

    xor a                                         ; $5769
    ret                                           ; $576A


jr_006_576b:
    bit 7, [hl]                                   ; $576B
    ret z                                         ; $576D

    push af                                       ; $576E
    ld a, SFX1_KEY_UP_DOWN                        ; $576F
    call Snd_Sfx1                                 ; $5771
    pop af                                        ; $5774
    dec a                                         ; $5775
    bit 7, a                                      ; $5776
    ret z                                         ; $5778

    ld a, c                                       ; $5779
    dec a                                         ; $577A
    ret                                           ; $577B


; C: L3 pass 2026-10-26: executed in BGB in 16 replay(s) of the organic corpus, modes 17 (tcrf_check/assets/l3_names/)
Compose_DrawPhotoCursor::
    ldh a, [hFrameCounter]                        ; $577C
    srl a                                         ; $577E
    srl a                                         ; $5780
    and $03                                       ; $5782
    ld e, a                                       ; $5784
    ld d, $00                                     ; $5785
    add hl, de                                    ; $5787
    ld a, [hl]                                    ; $5788
    call Oam_AddMeta_B02_5272                     ; $5789
    ret                                           ; $578C


; C
Compose_BuildFusion::
    ld bc, $0e00                                  ; $578D

jr_006_5790:
    push bc                                       ; $5790
    ld h, c                                       ; $5791
    ld l, $00                                     ; $5792
    call Compose_FusionReduceLeft                 ; $5794
    call Compose_FusionMerge                      ; $5797
    pop bc                                        ; $579A
    push bc                                       ; $579B
    ld b, $00                                     ; $579C
    ld hl, Compose_BuildFusion_Tbl57B5            ; $579E
    add hl, bc                                    ; $57A1
    ld d, [hl]                                    ; $57A2
    ld e, $00                                     ; $57A3
    ld hl, wBlendRows                             ; $57A5
    xor a                                         ; $57A8
    ld bc, $0100                                  ; $57A9
    call Vram_CopyFromBank                        ; $57AC
    pop bc                                        ; $57AF
    inc c                                         ; $57B0
    dec b                                         ; $57B1
    jr nz, jr_006_5790                            ; $57B2

    ret                                           ; $57B4


; C: auto: 14 bytes, bytes; referenced by Compose_BuildFusion. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 17)
Compose_BuildFusion_Tbl57B5::
    db $90, $91, $92, $93, $94, $95, $96, $97, $88, $80, $81, $82, $83, $84

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_FusionReduceLeft::
    push hl                                       ; $57C3
    ld a, [wCompose2Photos]                       ; $57C4
    ldh [hFarcallAArg], a                         ; $57C7
    farcall Photo_GetSramAddress_Far              ; $57C9
    pop hl                                        ; $57D1
    push hl                                       ; $57D2
    add hl, bc                                    ; $57D3
    ld de, wBlendRows                             ; $57D4
    ld bc, $0100                                  ; $57D7
    call Mem_CopyFromBank                         ; $57DA
    ld a, [wCompose2Photos + $1]                  ; $57DD
    ldh [hFarcallAArg], a                         ; $57E0
    farcall Photo_GetSramAddress_Far              ; $57E2
    pop hl                                        ; $57EA
    add hl, bc                                    ; $57EB
    ld de, wBlendRows + $100                      ; $57EC
    ld bc, $0100                                  ; $57EF
    call Mem_CopyFromBank                         ; $57F2
    ret                                           ; $57F5


; C: 2:1 reduction of the rows (mask $55 / $80). L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Compose_FusionMerge::
    ld hl, wBlendRows                             ; $57F6
    ld de, wBlendRows + $100                      ; $57F9
    ld a, $55                                     ; $57FC
    ldh [hScratchB], a                            ; $57FE
    ld a, $80                                     ; $5800

jr_006_5802:
    ldh [hScratchA], a                            ; $5802
    ld a, [hl]                                    ; $5804
    and $55                                       ; $5805
    ld c, a                                       ; $5807
    xor [hl]                                      ; $5808
    ld [hl+], a                                   ; $5809
    ld a, [de]                                    ; $580A
    and $55                                       ; $580B
    add c                                         ; $580D
    ld c, a                                       ; $580E
    ldh a, [hScratchB]                            ; $580F
    and $55                                       ; $5811
    add c                                         ; $5813
    and $aa                                       ; $5814
    srl a                                         ; $5816
    ld c, a                                       ; $5818
    inc e                                         ; $5819
    ld a, [hl]                                    ; $581A
    and $55                                       ; $581B
    ld b, a                                       ; $581D
    xor [hl]                                      ; $581E
    ld [hl], a                                    ; $581F
    ld a, [de]                                    ; $5820
    and $55                                       ; $5821
    add b                                         ; $5823
    add c                                         ; $5824
    ld c, a                                       ; $5825
    and $aa                                       ; $5826
    srl a                                         ; $5828
    or [hl]                                       ; $582A
    ld [hl-], a                                   ; $582B
    ld a, c                                       ; $582C
    and $55                                       ; $582D
    or [hl]                                       ; $582F
    ld [hl], a                                    ; $5830
    dec e                                         ; $5831
    ld a, [hl]                                    ; $5832
    and $aa                                       ; $5833
    ld c, a                                       ; $5835
    xor [hl]                                      ; $5836
    ld [hl+], a                                   ; $5837
    ld a, [de]                                    ; $5838
    and $aa                                       ; $5839
    add c                                         ; $583B
    rr a                                          ; $583C
    ld c, a                                       ; $583E
    ldh a, [hScratchB]                            ; $583F
    and $aa                                       ; $5841
    srl a                                         ; $5843
    add c                                         ; $5845
    and $aa                                       ; $5846
    srl a                                         ; $5848
    ld c, a                                       ; $584A
    inc e                                         ; $584B
    ld a, [hl]                                    ; $584C
    and $aa                                       ; $584D
    ld b, a                                       ; $584F
    xor [hl]                                      ; $5850
    ld [hl-], a                                   ; $5851
    ld a, [de]                                    ; $5852
    and $aa                                       ; $5853
    add b                                         ; $5855
    rr a                                          ; $5856
    add c                                         ; $5858
    ld c, a                                       ; $5859
    and $55                                       ; $585A
    sla a                                         ; $585C
    or [hl]                                       ; $585E
    ld [hl+], a                                   ; $585F
    ld a, c                                       ; $5860
    and $aa                                       ; $5861
    or [hl]                                       ; $5863
    ld [hl+], a                                   ; $5864
    inc e                                         ; $5865
    ldh a, [hScratchB]                            ; $5866
    rlca                                          ; $5868
    ldh [hScratchB], a                            ; $5869
    ldh a, [hScratchA]                            ; $586B
    dec a                                         ; $586D
    jr nz, jr_006_5802                            ; $586E

    ret                                           ; $5870


; C: four quadrants into the composite buffer
Compose_BuildSplit::
    ld a, [wCompose4Photos]                       ; $5871
    ld hl, $0000                                  ; $5874
    call Compose_SplitQuadrant                    ; $5877
    ld a, [wCompose4Photos + $2]                  ; $587A
    ld hl, $0080                                  ; $587D
    call Compose_SplitQuadrant                    ; $5880
    ld a, [wCompose4Photos + $1]                  ; $5883
    ld hl, $0700                                  ; $5886
    call Compose_SplitQuadrant                    ; $5889
    ld a, [wCompose4Photos + $3]                  ; $588C
    ld hl, $0780                                  ; $588F
    call Compose_SplitQuadrant                    ; $5892
    ld a, $00                                     ; $5895
    ld hl, wPhotoImage                            ; $5897
    ld de, $9000                                  ; $589A
    ld bc, $0800                                  ; $589D
    call Vram_CopyFromBank                        ; $58A0
    ld a, $00                                     ; $58A3
    ld hl, wPhotoImage + $800                     ; $58A5
    ld de, $8800                                  ; $58A8
    ld bc, $0100                                  ; $58AB
    call Vram_CopyFromBank                        ; $58AE
    ld a, $00                                     ; $58B1
    ld hl, wPhotoImage + $900                     ; $58B3
    ld de, $8000                                  ; $58B6
    ld bc, $0500                                  ; $58B9
    call Vram_CopyFromBank                        ; $58BC
    ret                                           ; $58BF


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_SplitQuadrant::
    push hl                                       ; $58C0
    ld de, wPhotoImage                            ; $58C1
    add hl, de                                    ; $58C4
    push hl                                       ; $58C5
    ldh [hFarcallAArg], a                         ; $58C6
    farcall Photo_GetSramAddress_Far              ; $58C8
    pop de                                        ; $58D0
    pop hl                                        ; $58D1
    add hl, bc                                    ; $58D2
    ld b, $07                                     ; $58D3

jr_006_58d5:
    push bc                                       ; $58D5
    ld bc, $0080                                  ; $58D6
    push af                                       ; $58D9
    call Mem_CopyFromBank                         ; $58DA
    ld a, e                                       ; $58DD
    add $80                                       ; $58DE
    ld e, a                                       ; $58E0
    jr nc, jr_006_58e4                            ; $58E1

    inc d                                         ; $58E3

jr_006_58e4:
    ld a, l                                       ; $58E4
    add $80                                       ; $58E5
    ld l, a                                       ; $58E7
    jr nc, jr_006_58eb                            ; $58E8

    inc h                                         ; $58EA

jr_006_58eb:
    pop af                                        ; $58EB
    pop bc                                        ; $58EC
    dec b                                         ; $58ED
    jr nz, jr_006_58d5                            ; $58EE

    ret                                           ; $58F0


; C: photo_count + 1 as digits. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs
; of the core emulator (coverage/results/merged_state/cov.npz)
Compose_DrawFreeCount::
    ld c, $00                                     ; $58F1
    ld a, [wPhotoCount]                           ; $58F3
    inc a                                         ; $58F6

jr_006_58f7:
    cp $0a                                        ; $58F7
    jr c, jr_006_5900                             ; $58F9

    sub $0a                                       ; $58FB
    inc c                                         ; $58FD
    jr jr_006_58f7                                ; $58FE

jr_006_5900:
    push bc                                       ; $5900
    ld c, a                                       ; $5901
    ld b, $00                                     ; $5902
    swap c                                        ; $5904
    sla c                                         ; $5906
    rl b                                          ; $5908
    ld hl, $4800                                  ; $590A
    add hl, bc                                    ; $590D
    ld a, $17                                     ; $590E
    ld de, $8720                                  ; $5910
    ld bc, $0020                                  ; $5913
    call Vram_CopyFromBank                        ; $5916
    pop bc                                        ; $5919
    ld b, $00                                     ; $591A
    swap c                                        ; $591C
    sla c                                         ; $591E
    rl b                                          ; $5920
    ld hl, $4800                                  ; $5922
    add hl, bc                                    ; $5925
    ld a, $17                                     ; $5926
    ld de, $8700                                  ; $5928
    ld bc, $0020                                  ; $592B
    call Vram_CopyFromBank                        ; $592E
    ret                                           ; $5931


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Compose_DrawJitter::
    ldh a, [hFrameCounter]                        ; $5932
    and $01                                       ; $5934
    jr nz, jr_006_5944                            ; $5936

    call Rng_Next                                 ; $5938
    ld [wJitterX], a                              ; $593B
    call Rng_Next                                 ; $593E
    ld [wJitterY], a                              ; $5941

jr_006_5944:
    ld a, [wJitterX]                              ; $5944
    and $01                                       ; $5947
    add $79                                       ; $5949
    ld b, a                                       ; $594B
    ld a, [wJitterY]                              ; $594C
    and $01                                       ; $594F
    add $7c                                       ; $5951
    ld c, a                                       ; $5953
    ld a, $38                                     ; $5954
    call Oam_AddMeta_B01_5D47                     ; $5956
    ld a, [wJitterX]                              ; $5959
    and $01                                       ; $595C
    add $79                                       ; $595E
    ld b, a                                       ; $5960
    ld a, [wJitterY]                              ; $5961
    and $01                                       ; $5964
    add $8d                                       ; $5966
    ld c, a                                       ; $5968
    ld a, $39                                     ; $5969
    call Oam_AddMeta_B01_5D47                     ; $596B
    ld a, [wShootVariant]                         ; $596E
    cp $15                                        ; $5971
    ret z                                         ; $5973

    ld a, [wJitterX]                              ; $5974
    xor $01                                       ; $5977
    and $01                                       ; $5979
    add $34                                       ; $597B
    ld b, a                                       ; $597D
    ld a, [wJitterY]                              ; $597E
    xor $01                                       ; $5981
    and $01                                       ; $5983
    add $33                                       ; $5985
    ld c, a                                       ; $5987
    ld a, $37                                     ; $5988
    call Oam_AddMeta_B01_5D47                     ; $598A
    ret                                           ; $598D


; C: mode 18: PANORAMA print
Mode18_PanoramaPrint::
    ld a, [wState]                                ; $598E
    rst Rst18_JumpTable                           ; $5991

; C: 4 states
Mode18_StateTable::
    dw Mode18_State00_Init
    dw Mode18_State01_PickFirst
    dw Mode18_State02_PickLast
    dw Mode18_State03_PrintOrCancel

; C
Mode18_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $599A
    ldh [hLcdcShadow], a                          ; $599C
    ld a, $e4                                     ; $599E
    ld [wPaletteTarget], a                        ; $59A0
    ld [wPaletteTarget + $1], a                   ; $59A3
    ld a, $d2                                     ; $59A6
    ld [wPaletteTarget + $2], a                   ; $59A8
    xor a                                         ; $59AB
    ldh [hScxShadow], a                           ; $59AC
    ldh [hScyShadow], a                           ; $59AE
    ld [wSelCursorTick], a                        ; $59B0
    ld [wSelCursorFrame], a                       ; $59B3
    ld [wSelSlot], a                              ; $59B6
    farcopy Mem_CopyFromBank, Gfx_11_7000_Mode18_State00_Init, $9000, $0800 ; $59B9
    farcopy Mem_CopyFromBank, Gfx_11_7800_Mode18_State00_Init, $8800, $0800 ; $59C7
    farcopy Mem_CopyFromBank, Map_16_7D80_Mode18_State00_Init, $9800, $0240 ; $59D5
    ld a, [wOpt3ToggleB]                          ; $59E3
    and a                                         ; $59E6
    jr z, jr_006_59f7                             ; $59E7

    farcopy Mem_CopyFromBank, Map_16_7FC0_Mode18_State00_Init, $9800, $0040 ; $59E9

jr_006_59f7:
    call Oam_ClearShadow                          ; $59F7
    call Pal_AllWhite                             ; $59FA
    call Lcd_On                                   ; $59FD
    push af                                       ; $5A00
    ld a, MUSIC_SHUTTERBUG                        ; $5A01
    call Snd_Music                                ; $5A03
    pop af                                        ; $5A06
    call Mode18_LoadAllThumbs                     ; $5A07
    ld a, [wBurstPhotos]                          ; $5A0A
    call Mode18_DrawThumbFrame                    ; $5A0D
    call Mode18_DrawArrows                        ; $5A10
    call Pal_FadeIn                               ; $5A13
    ld a, [wOpt3ToggleB]                          ; $5A16
    and a                                         ; $5A19
    jr nz, jr_006_5a21                            ; $5A1A

    next_state                                    ; $5A1C
    ret                                           ; $5A20


jr_006_5a21:
    set_state STATE_18_PICK_LAST                  ; $5A21
    ret                                           ; $5A26


; C
Mode18_State01_PickFirst::
    call Mode18_Pick1_Input                       ; $5A27
    call Mode18_Pick1_DrawCursor                  ; $5A2A
    call Mode18_DrawArrows                        ; $5A2D
    ldh a, [hKeysNew]                             ; $5A30
    and PADF_A | PADF_B                           ; $5A32
    ret z                                         ; $5A34

    ld [wAbResult], a                             ; $5A35
    push af                                       ; $5A38
    bit 0, a                                      ; $5A39
    ld a, SFX1_KEY_A                              ; $5A3B
    call nz, Snd_Sfx1                             ; $5A3D
    pop af                                        ; $5A40
    push af                                       ; $5A41
    bit 1, a                                      ; $5A42
    ld a, SFX1_KEY_B                              ; $5A44
    call nz, Snd_Sfx1                             ; $5A46
    pop af                                        ; $5A49
    set_state STATE_18_PRINT_OR_CANCEL            ; $5A4A
    ret                                           ; $5A4F


; C
Mode18_State02_PickLast::
    call Mode18_Pick2_Input                       ; $5A50
    call Mode18_Pick2_DrawCursor                  ; $5A53
    call Mode18_DrawArrows                        ; $5A56
    ldh a, [hKeysNew]                             ; $5A59
    and PADF_A | PADF_B                           ; $5A5B
    ret z                                         ; $5A5D

    ld [wAbResult], a                             ; $5A5E
    push af                                       ; $5A61
    bit 0, a                                      ; $5A62
    ld a, SFX1_KEY_A                              ; $5A64
    call nz, Snd_Sfx1                             ; $5A66
    pop af                                        ; $5A69
    push af                                       ; $5A6A
    bit 1, a                                      ; $5A6B
    ld a, SFX1_KEY_B                              ; $5A6D
    call nz, Snd_Sfx1                             ; $5A6F
    pop af                                        ; $5A72
    next_state                                    ; $5A73
    ret                                           ; $5A77


; C: A prints the strip; B cancels
Mode18_State03_PrintOrCancel::
    ld a, [wAbResult]                             ; $5A78
    bit 0, a                                      ; $5A7B
    jr z, jr_006_5aa8                             ; $5A7D

    ld b, $0c                                     ; $5A7F

jr_006_5a81:
    push bc                                       ; $5A81
    call Mode18_DrawArrows                        ; $5A82
    ldh a, [hFrameCounter]                        ; $5A85
    bit 2, a                                      ; $5A87
    call nz, Mode18_DrawPrintLabel                ; $5A89
    call Oam_HideUnused                           ; $5A8C
    rst Rst08_WaitVBlank                          ; $5A8F
    pop bc                                        ; $5A90
    dec b                                         ; $5A91
    jr nz, jr_006_5a81                            ; $5A92

    call Pal_FadeOut                              ; $5A94
    call Lcd_Off                                  ; $5A97
    call Mode18_StartPrint                        ; $5A9A
    ld a, MODE_PRINT_JOB                          ; $5A9D
    ld [wMode], a                                 ; $5A9F
    set_state STATE_1D_INIT                       ; $5AA2
    ret                                           ; $5AA7


jr_006_5aa8:
    ld b, $0c                                     ; $5AA8

jr_006_5aaa:
    push bc                                       ; $5AAA
    call Mode18_DrawArrows                        ; $5AAB
    ldh a, [hFrameCounter]                        ; $5AAE
    bit 2, a                                      ; $5AB0
    call nz, Mode18_DrawCancelLabel               ; $5AB2
    call Oam_HideUnused                           ; $5AB5
    rst Rst08_WaitVBlank                          ; $5AB8
    pop bc                                        ; $5AB9
    dec b                                         ; $5ABA
    jr nz, jr_006_5aaa                            ; $5ABB

    call Pal_FadeOut                              ; $5ABD
    call Lcd_Off                                  ; $5AC0
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $5AC3
    ld [wMode], a                                 ; $5AC5
    set_state STATE_16_REDRAW                     ; $5AC8
    ret                                           ; $5ACD


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (56 hits in 3 runs: 18:03 x56;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawPrintLabel::
    ld bc, $1662                                  ; $5ACE
    ld a, $5c                                     ; $5AD1
    call Oam_AddMeta_B02_5272                     ; $5AD3
    ret                                           ; $5AD6


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (50 hits in 4 runs: 18:03 x50;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawCancelLabel::
    ld bc, $1673                                  ; $5AD7
    ld a, $5d                                     ; $5ADA
    call Oam_AddMeta_B02_5272                     ; $5ADC
    ret                                           ; $5ADF


; C: fills print_src_table and calls the print job
Mode18_StartPrint::
    ld hl, wBurstPhotos + $3                      ; $5AE0
    ld de, wPrintSrcTable + $e                    ; $5AE3
    ld bc, $0400                                  ; $5AE6

jr_006_5ae9:
    push bc                                       ; $5AE9
    ld bc, $ffff                                  ; $5AEA
    ld a, [hl]                                    ; $5AED
    cp $ff                                        ; $5AEE
    jr z, jr_006_5b00                             ; $5AF0

    push de                                       ; $5AF2
    push hl                                       ; $5AF3
    ldh [hFarcallAArg], a                         ; $5AF4
    farcall Photo_GetSramAddress_Far              ; $5AF6
    pop hl                                        ; $5AFE
    pop de                                        ; $5AFF

jr_006_5b00:
    ld [de], a                                    ; $5B00
    dec de                                        ; $5B01
    ld a, b                                       ; $5B02
    ld [de], a                                    ; $5B03
    dec de                                        ; $5B04
    ld a, c                                       ; $5B05
    ld [de], a                                    ; $5B06
    dec de                                        ; $5B07
    dec de                                        ; $5B08
    pop bc                                        ; $5B09
    ld a, c                                       ; $5B0A
    and a                                         ; $5B0B
    jr nz, jr_006_5b12                            ; $5B0C

    bit 7, [hl]                                   ; $5B0E
    jr nz, jr_006_5b13                            ; $5B10

jr_006_5b12:
    inc c                                         ; $5B12

jr_006_5b13:
    dec hl                                        ; $5B13
    dec b                                         ; $5B14
    jr nz, jr_006_5ae9                            ; $5B15

    ld a, c                                       ; $5B17
    ld [wPrintPages], a                           ; $5B18
    ld a, [wOpt3ToggleB]                          ; $5B1B
    xor $01                                       ; $5B1E
    add $02                                       ; $5B20
    ld [wPrintLayoutType], a                      ; $5B22
    ld [wPrintReturnIdx], a                       ; $5B25
    xor a                                         ; $5B28
    ld [wPrintCustomMargin], a                    ; $5B29
    ret                                           ; $5B2C


; C
Mode18_Pick1_Input::
    ld a, [wStockPictureCount]                    ; $5B2D
    add $1e                                       ; $5B30
    ld c, a                                       ; $5B32
    ldh a, [hKeysNewRepeat]                       ; $5B33
    ld b, a                                       ; $5B35
    ld hl, wSelSlot                               ; $5B36
    ld a, [hl]                                    ; $5B39
    call Mode18_Pick1_Left                        ; $5B3A
    cp [hl]                                       ; $5B3D
    ld [hl], a                                    ; $5B3E
    ld e, a                                       ; $5B3F
    ld d, $00                                     ; $5B40
    ld hl, wBurstPhotos                           ; $5B42
    add hl, de                                    ; $5B45
    ld a, [hl]                                    ; $5B46
    jr nz, jr_006_5b4e                            ; $5B47

    call Mode18_Pick1_Right                       ; $5B49
    cp [hl]                                       ; $5B4C
    ld [hl], a                                    ; $5B4D

jr_006_5b4e:
    ld c, e                                       ; $5B4E
    call nz, Mode18_DrawThumbFrame                ; $5B4F
    call nz, Mode18_LoadThumb                     ; $5B52
    ret                                           ; $5B55


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (2096 hits in 8 runs: 18:01 x2096;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_Left::
    bit 5, b                                      ; $5B56
    jr z, jr_006_5b65                             ; $5B58

    and a                                         ; $5B5A
    ret z                                         ; $5B5B

    push af                                       ; $5B5C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5B5D
    call Snd_Sfx1                                 ; $5B5F
    pop af                                        ; $5B62
    dec a                                         ; $5B63
    ret                                           ; $5B64


jr_006_5b65:
    bit 4, b                                      ; $5B65
    ret z                                         ; $5B67

    cp $03                                        ; $5B68
    ret z                                         ; $5B6A

    push af                                       ; $5B6B
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5B6C
    call Snd_Sfx1                                 ; $5B6E
    pop af                                        ; $5B71
    inc a                                         ; $5B72
    ret                                           ; $5B73


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (2096 hits in 8 runs: 18:01 x2096;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_Right::
    bit 7, b                                      ; $5B74
    jr z, jr_006_5b86                             ; $5B76

    push af                                       ; $5B78
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5B79
    call Snd_Sfx1                                 ; $5B7B
    pop af                                        ; $5B7E
    dec a                                         ; $5B7F
    cp $fe                                        ; $5B80
    ret nz                                        ; $5B82

    ld a, c                                       ; $5B83
    dec a                                         ; $5B84
    ret                                           ; $5B85


jr_006_5b86:
    bit 6, b                                      ; $5B86
    ret z                                         ; $5B88

    push af                                       ; $5B89
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5B8A
    call Snd_Sfx1                                 ; $5B8C
    pop af                                        ; $5B8F
    inc a                                         ; $5B90
    cp c                                          ; $5B91
    ret nz                                        ; $5B92

    ld a, $ff                                     ; $5B93
    ret                                           ; $5B95


; C
Mode18_Pick2_Input::
    ld a, [wStockPictureCount]                    ; $5B96
    add $1e                                       ; $5B99
    ld c, a                                       ; $5B9B
    ldh a, [hKeysNewRepeat]                       ; $5B9C
    ld b, a                                       ; $5B9E
    ld hl, wSelSlot                               ; $5B9F
    ld a, [hl]                                    ; $5BA2
    call Mode18_Pick2_Up                          ; $5BA3
    cp [hl]                                       ; $5BA6
    ld [hl], a                                    ; $5BA7
    ld e, a                                       ; $5BA8
    ld d, $00                                     ; $5BA9
    ld hl, wBurstPhotos                           ; $5BAB
    add hl, de                                    ; $5BAE
    ld a, [hl]                                    ; $5BAF
    jr nz, jr_006_5bb7                            ; $5BB0

    call Mode18_Pick2_Down                        ; $5BB2
    cp [hl]                                       ; $5BB5
    ld [hl], a                                    ; $5BB6

jr_006_5bb7:
    ld c, e                                       ; $5BB7
    call nz, Mode18_DrawThumbFrame                ; $5BB8
    call nz, Mode18_LoadThumb                     ; $5BBB
    ret                                           ; $5BBE


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (13800 hits in 3 runs: 18:02 x13800;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick2_Up::
    bit 6, b                                      ; $5BBF
    jr z, jr_006_5bce                             ; $5BC1

    and a                                         ; $5BC3
    ret z                                         ; $5BC4

    dec a                                         ; $5BC5
    push af                                       ; $5BC6
    ld a, SFX1_KEY_UP_DOWN                        ; $5BC7
    call Snd_Sfx1                                 ; $5BC9
    pop af                                        ; $5BCC
    ret                                           ; $5BCD


jr_006_5bce:
    bit 7, b                                      ; $5BCE
    ret z                                         ; $5BD0

    cp $03                                        ; $5BD1
    ret z                                         ; $5BD3

    inc a                                         ; $5BD4
    push af                                       ; $5BD5
    ld a, SFX1_KEY_UP_DOWN                        ; $5BD6
    call Snd_Sfx1                                 ; $5BD8
    pop af                                        ; $5BDB
    ret                                           ; $5BDC


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (13800 hits in 3 runs: 18:02 x13800;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick2_Down::
    bit 5, b                                      ; $5BDD
    jr z, jr_006_5bef                             ; $5BDF

    push af                                       ; $5BE1
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5BE2
    call Snd_Sfx1                                 ; $5BE4
    pop af                                        ; $5BE7
    dec a                                         ; $5BE8
    cp $fe                                        ; $5BE9
    ret nz                                        ; $5BEB

    ld a, c                                       ; $5BEC
    dec a                                         ; $5BED
    ret                                           ; $5BEE


jr_006_5bef:
    bit 4, b                                      ; $5BEF
    ret z                                         ; $5BF1

    push af                                       ; $5BF2
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $5BF3
    call Snd_Sfx1                                 ; $5BF5
    pop af                                        ; $5BF8
    inc a                                         ; $5BF9
    cp c                                          ; $5BFA
    ret nz                                        ; $5BFB

    ld a, $ff                                     ; $5BFC
    ret                                           ; $5BFE


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (1048 hits in 8 runs: 18:01 x1048;
; tcrf_check/assets/mode_state_wp/)
Mode18_Pick1_DrawCursor::
    ld a, [wSelSlot]                              ; $5BFF
    sla a                                         ; $5C02
    ld c, a                                       ; $5C04
    ld b, $00                                     ; $5C05
    ld hl, Mode18_Pick1_SlotPosTbl                ; $5C07
    add hl, bc                                    ; $5C0A
    ld c, [hl]                                    ; $5C0B
    inc hl                                        ; $5C0C
    ld b, [hl]                                    ; $5C0D
    ld a, [wSelCursorFrame]                       ; $5C0E
    sla a                                         ; $5C11
    ld e, a                                       ; $5C13
    ld d, $00                                     ; $5C14
    ld hl, Mode18_Pick1_CursorAnimTbl             ; $5C16
    add hl, de                                    ; $5C19
    ld a, [hl+]                                   ; $5C1A
    call Oam_AddMeta_B02_5272                     ; $5C1B
    ld a, [wSelCursorTick]                        ; $5C1E
    cp [hl]                                       ; $5C21
    jr c, jr_006_5c31                             ; $5C22

    inc hl                                        ; $5C24
    ld a, [hl]                                    ; $5C25
    inc a                                         ; $5C26
    jr z, jr_006_5c2d                             ; $5C27

    ld a, [wSelCursorFrame]                       ; $5C29
    inc a                                         ; $5C2C

jr_006_5c2d:
    ld [wSelCursorFrame], a                       ; $5C2D
    xor a                                         ; $5C30

jr_006_5c31:
    inc a                                         ; $5C31
    ld [wSelCursorTick], a                        ; $5C32
    ret                                           ; $5C35


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
    ld a, [wSelSlot]                              ; $5C45
    sla a                                         ; $5C48
    ld c, a                                       ; $5C4A
    ld b, $00                                     ; $5C4B
    ld hl, Mode18_Pick2_SlotPosTbl                ; $5C4D
    add hl, bc                                    ; $5C50
    ld c, [hl]                                    ; $5C51
    inc hl                                        ; $5C52
    ld b, [hl]                                    ; $5C53
    ld a, [wSelCursorFrame]                       ; $5C54
    sla a                                         ; $5C57
    ld e, a                                       ; $5C59
    ld d, $00                                     ; $5C5A
    ld hl, Mode18_Pick2_CursorAnimTbl             ; $5C5C
    add hl, de                                    ; $5C5F
    ld a, [hl+]                                   ; $5C60
    call Oam_AddMeta_B02_5272                     ; $5C61
    ld a, [wSelCursorTick]                        ; $5C64
    cp [hl]                                       ; $5C67
    jr c, jr_006_5c77                             ; $5C68

    inc hl                                        ; $5C6A
    ld a, [hl]                                    ; $5C6B
    inc a                                         ; $5C6C
    jr z, jr_006_5c73                             ; $5C6D

    ld a, [wSelCursorFrame]                       ; $5C6F
    inc a                                         ; $5C72

jr_006_5c73:
    ld [wSelCursorFrame], a                       ; $5C73
    xor a                                         ; $5C76

jr_006_5c77:
    inc a                                         ; $5C77
    ld [wSelCursorTick], a                        ; $5C78
    ret                                           ; $5C7B


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
    ld bc, $7034                                  ; $5C8B
    ld a, $5a                                     ; $5C8E
    call Oam_AddMeta_B02_5272                     ; $5C90
    ld bc, $706c                                  ; $5C93
    ld a, $5b                                     ; $5C96
    call Oam_AddMeta_B02_5272                     ; $5C98
    ret                                           ; $5C9B


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (28 hits in 9 runs: 18:00 x28;
; tcrf_check/assets/mode_state_wp/)
Mode18_LoadAllThumbs::
    ld hl, wBurstPhotos                           ; $5C9C
    ld c, $00                                     ; $5C9F

jr_006_5ca1:
    push bc                                       ; $5CA1
    push hl                                       ; $5CA2
    bit 7, [hl]                                   ; $5CA3
    call z, Mode18_LoadThumb                      ; $5CA5
    pop hl                                        ; $5CA8
    pop bc                                        ; $5CA9
    inc hl                                        ; $5CAA
    inc c                                         ; $5CAB
    ld a, c                                       ; $5CAC
    cp $04                                        ; $5CAD
    jr nz, jr_006_5ca1                            ; $5CAF

    ret                                           ; $5CB1


; C
Mode18_LoadThumb::
    push bc                                       ; $5CB2
    push hl                                       ; $5CB3
    ld a, [wOpt3ToggleB]                          ; $5CB4
    sla a                                         ; $5CB7
    sla a                                         ; $5CB9
    sla a                                         ; $5CBB
    sla c                                         ; $5CBD
    add c                                         ; $5CBF
    ld c, a                                       ; $5CC0
    ld b, $00                                     ; $5CC1
    ld hl, Mode18_LoadThumb_Tbl5D44               ; $5CC3
    add hl, bc                                    ; $5CC6
    ld e, [hl]                                    ; $5CC7
    inc hl                                        ; $5CC8
    ld d, [hl]                                    ; $5CC9
    pop hl                                        ; $5CCA
    pop bc                                        ; $5CCB
    ld a, [hl]                                    ; $5CCC
    cp $ff                                        ; $5CCD
    jr z, jr_006_5ce1                             ; $5CCF

    ldh [hFarcallAArg], a                         ; $5CD1
    farcall Photo_GetSramAddress_Far              ; $5CD3
    ld hl, $0e00                                  ; $5CDB
    add hl, bc                                    ; $5CDE
    jr jr_006_5cfb                                ; $5CDF

jr_006_5ce1:
    ld a, [wOpt3ToggleB]                          ; $5CE1
    sla a                                         ; $5CE4
    sla a                                         ; $5CE6
    add c                                         ; $5CE8
    ld c, a                                       ; $5CE9
    sla a                                         ; $5CEA
    add c                                         ; $5CEC
    ld c, a                                       ; $5CED
    ld b, $00                                     ; $5CEE
    ld hl, Mode18_LoadThumb_Tbl5D54               ; $5CF0
    add hl, bc                                    ; $5CF3
    ld c, [hl]                                    ; $5CF4
    inc hl                                        ; $5CF5
    ld b, [hl]                                    ; $5CF6
    inc hl                                        ; $5CF7
    ld a, [hl]                                    ; $5CF8
    ld h, b                                       ; $5CF9
    ld l, c                                       ; $5CFA

jr_006_5cfb:
    ld bc, $00c8                                  ; $5CFB
    push af                                       ; $5CFE
    call Vram_CopyFromBank                        ; $5CFF
    ld a, e                                       ; $5D02
    add $08                                       ; $5D03
    ld e, a                                       ; $5D05
    jr nc, jr_006_5d09                            ; $5D06

    inc d                                         ; $5D08

jr_006_5d09:
    ld a, l                                       ; $5D09
    add $08                                       ; $5D0A
    ld l, a                                       ; $5D0C
    jr nc, jr_006_5d10                            ; $5D0D

    inc h                                         ; $5D0F

jr_006_5d10:
    pop af                                        ; $5D10
    push af                                       ; $5D11
    ld bc, $0008                                  ; $5D12
    call Vram_CopyFromBank                        ; $5D15
    ld a, e                                       ; $5D18
    add $08                                       ; $5D19
    ld e, a                                       ; $5D1B
    jr nc, jr_006_5d1f                            ; $5D1C

    inc d                                         ; $5D1E

jr_006_5d1f:
    ld a, l                                       ; $5D1F
    add $08                                       ; $5D20
    ld l, a                                       ; $5D22
    jr nc, jr_006_5d26                            ; $5D23

    inc h                                         ; $5D25

jr_006_5d26:
    pop af                                        ; $5D26
    push af                                       ; $5D27
    ld bc, $0008                                  ; $5D28
    call Vram_CopyFromBank                        ; $5D2B
    ld a, e                                       ; $5D2E
    add $08                                       ; $5D2F
    ld e, a                                       ; $5D31
    jr nc, jr_006_5d35                            ; $5D32

    inc d                                         ; $5D34

jr_006_5d35:
    ld a, l                                       ; $5D35
    add $08                                       ; $5D36
    ld l, a                                       ; $5D38
    jr nc, jr_006_5d3c                            ; $5D39

    inc h                                         ; $5D3B

jr_006_5d3c:
    pop af                                        ; $5D3C
    ld bc, $0008                                  ; $5D3D
    call Vram_CopyFromBank                        ; $5D40
    ret                                           ; $5D43


; C: 2 sets x 4 words ([$D5EA] x 8 + 2 x thumbnail): the VRAM destination of each thumbnail, $9200 $9300 $9400 $9500 /
; $9500 $8D00 $9600 $8E00; the sources are the records of Mode18_LoadThumb_Tbl5D54 (read 2026-10-19)
Mode18_LoadThumb_Tbl5D44::
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
Mode18_LoadThumb_Tbl5D54::
    dwb Gfx_11_7200_Icon06_5D54
    dwb Gfx_11_7300_Icon06_5D54
    dwb Gfx_11_7400_Icon06_5D54
    dwb Gfx_11_7500_Icon06_5D54
    dwb Gfx_11_7500_Icon06_5D54
    dwb Gfx_11_7D00_Icon06_5D54
    dwb Gfx_11_7600_Icon06_5D54
    dwb Gfx_11_7E00_Icon06_5D54

; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (44 hits in 9 runs: 18:00 x28 18:01 x16;
; tcrf_check/assets/mode_state_wp/)
Mode18_DrawThumbFrame::
    push af                                       ; $5D6C
    push bc                                       ; $5D6D
    push hl                                       ; $5D6E
    cp $ff                                        ; $5D6F
    jr nz, jr_006_5da1                            ; $5D71

    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c20, $0010 ; $5D73
    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c50, $0010 ; $5D81
    farcopy Vram_CopyFromBank, Gfx_11_7C40_Mode18_DrawThumbFrame, $8c60, $0010 ; $5D8F
    pop hl                                        ; $5D9D
    pop bc                                        ; $5D9E
    pop af                                        ; $5D9F
    ret                                           ; $5DA0


jr_006_5da1:
    ld bc, $0000                                  ; $5DA1
    cp $1e                                        ; $5DA4
    jr c, jr_006_5dab                             ; $5DA6

    sub $1e                                       ; $5DA8
    inc b                                         ; $5DAA

jr_006_5dab:
    inc a                                         ; $5DAB

jr_006_5dac:
    cp $0a                                        ; $5DAC
    jr c, jr_006_5db5                             ; $5DAE

    sub $0a                                       ; $5DB0
    inc c                                         ; $5DB2
    jr jr_006_5dac                                ; $5DB3

jr_006_5db5:
    push af                                       ; $5DB5
    push bc                                       ; $5DB6
    ld a, b                                       ; $5DB7
    ld hl, $7c20                                  ; $5DB8
    ld de, $8c20                                  ; $5DBB
    call Mode18_LoadTileIndexed                   ; $5DBE
    pop bc                                        ; $5DC1
    ld a, c                                       ; $5DC2
    ld hl, $7c50                                  ; $5DC3
    ld de, $8c50                                  ; $5DC6
    call Mode18_LoadTileIndexed                   ; $5DC9
    pop af                                        ; $5DCC
    ld hl, $7c50                                  ; $5DCD
    call Mode18_LoadTileIndexed                   ; $5DD0
    pop hl                                        ; $5DD3
    pop bc                                        ; $5DD4
    pop af                                        ; $5DD5
    ret                                           ; $5DD6


; C: BGB watchpoint pass 2026-10-25: ran only in mode 18 (78 hits in 3 runs: 18:00 x30 18:01 x48;
; tcrf_check/assets/mode_state_wp/)
Mode18_LoadTileIndexed::
    swap a                                        ; $5DD7
    ld c, a                                       ; $5DD9
    ld b, $00                                     ; $5DDA
    add hl, bc                                    ; $5DDC
    ld a, $11                                     ; $5DDD
    ld bc, $0010                                  ; $5DDF
    call Vram_CopyFromBank                        ; $5DE2
    ret                                           ; $5DE5


; C: mode 14: live view and shutter
Mode14_ShootLiveView::
    ld a, [wState]                                ; $5DE6
    rst Rst18_JumpTable                           ; $5DE9

; C: 13 states
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5E04
    ldh [hLcdcShadow], a                          ; $5E06
    ld a, $e4                                     ; $5E08
    ld [wPaletteTarget], a                        ; $5E0A
    ld [wPaletteTarget + $1], a                   ; $5E0D
    ld a, $d2                                     ; $5E10
    ld [wPaletteTarget + $2], a                   ; $5E12
    ld a, $10                                     ; $5E15
    ldh [hScxShadow], a                           ; $5E17
    ldh [hScyShadow], a                           ; $5E19
    ldh [hFarcallAArg], a                         ; $5E1B
    ld a, $02                                     ; $5E1D
    ld hl, Counters_Load_Far                      ; $5E1F
    call Far_Call                                 ; $5E22
    xor a                                         ; $5E25
    ld [wShootCaptureSel], a                      ; $5E26
    ld [wShootEffectSel], a                       ; $5E29
    ld [wBurstCount], a                           ; $5E2C
    ld a, [wShootVariant]                         ; $5E2F
    cp $0a                                        ; $5E32
    jr z, jr_006_5e42                             ; $5E34

    cp $0b                                        ; $5E36
    jr z, jr_006_5e42                             ; $5E38

    cp $15                                        ; $5E3A
    jr z, jr_006_5e42                             ; $5E3C

    ld a, $01                                     ; $5E3E
    jr jr_006_5e44                                ; $5E40

jr_006_5e42:
    ld a, $02                                     ; $5E42

jr_006_5e44:
    ld [wShootRampSel], a                         ; $5E44
    ld [wCamDitherMode], a                        ; $5E47
    xor a                                         ; $5E4A
    ld [wTimerRunning], a                         ; $5E4B
    ld [wShootPhase], a                           ; $5E4E
    ld a, [wIntervalShots]                        ; $5E51
    ld [wShotsLeft], a                            ; $5E54
    call Shoot_ResetTimer                         ; $5E57
    ld hl, wPhotoImage                            ; $5E5A
    ld bc, $1000                                  ; $5E5D
    call Mem_Zero                                 ; $5E60
    ld hl, $8000                                  ; $5E63
    ld bc, $0500                                  ; $5E66
    call Mem_Zero                                 ; $5E69
    ld hl, $8800                                  ; $5E6C
    ld bc, $0100                                  ; $5E6F
    call Mem_Zero                                 ; $5E72
    ld hl, $9000                                  ; $5E75
    ld bc, $0800                                  ; $5E78
    call Mem_Zero                                 ; $5E7B
    ld a, $00                                     ; $5E7E
    ld [$4000], a                                 ; $5E80
    ld hl, $a000                                  ; $5E83
    ld bc, $1000                                  ; $5E86
    call Mem_Zero                                 ; $5E89
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $5E8C
    farcopy Mem_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $5E9A
    farcopy Mem_CopyFromBank, Gfx_17_4940_Mode14_State00_Init, $8fd0, $0020 ; $5EA8
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $5EB6
    farcopy Mem_CopyFromBank, Gfx_17_4140_Mode14_State00_Init, $8a00, $0040 ; $5EC4
    farcopy Mem_CopyFromBank, Gfx_17_4180_Mode14_State00_Init, $8a40, $0080 ; $5ED2
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $5EE0
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $5EEE
    farcopy Mem_CopyFromBank, Gfx_17_54E0_Mode14_State00_Init, $8740, $0020 ; $5EFC
    farcopy Mem_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $5F0A
    ld hl, $8ff0                                  ; $5F18
    ld bc, $0010                                  ; $5F1B
    ld de, $00ff                                  ; $5F1E
    call Mem_FillWords                            ; $5F21
    ld hl, $9ac0                                  ; $5F24
    ld bc, $0140                                  ; $5F27
    ld a, $ff                                     ; $5F2A
    call Mem_FillBc1                              ; $5F2C
    call Shoot_LoadBurstIcons                     ; $5F2F
    call Shoot_LoadEffectGfx                      ; $5F32
    call Shoot_ClearEffectTiles                   ; $5F35
    ld a, $54                                     ; $5F38
    ldh [hLycShadowSplit1], a                     ; $5F3A
    ldh [hSplit1Latch], a                         ; $5F3C
    ld hl, hStatShadow                            ; $5F3E
    set 6, [hl]                                   ; $5F41
    ld hl, rIE                                    ; $5F43
    set 1, [hl]                                   ; $5F46
    ld a, $01                                     ; $5F48
    ldh [hStatHandlerIndex], a                    ; $5F4A
    call Oam_ClearShadow                          ; $5F4C
    call Pal_AllWhite                             ; $5F4F
    call Lcd_On                                   ; $5F52
    push af                                       ; $5F55
    ld a, MUSIC_STOP                              ; $5F56
    call Snd_Music                                ; $5F58
    pop af                                        ; $5F5B
    rst Rst08_WaitVBlank                          ; $5F5C
    call Pal_FadeIn                               ; $5F5D
    ld a, $01                                     ; $5F60
    ld [wShootInitFlag], a                        ; $5F62
    ld a, $54                                     ; $5F65
    ld [wCamBrightnessSetpoint], a                ; $5F67
    ld a, $08                                     ; $5F6A
    ld [wCamContrastRow], a                       ; $5F6C
    call Cam_SetGainContrast                      ; $5F6F
    ld a, $10                                     ; $5F72
    ld [$4000], a                                 ; $5F74
    ld a, [wCamA000Shadow]                        ; $5F77
    set 0, a                                      ; $5F7A
    ld [$a000], a                                 ; $5F7C
    ld hl, $a000                                  ; $5F7F

jr_006_5f82:
    bit 0, [hl]                                   ; $5F82
    jr nz, jr_006_5f82                            ; $5F84

    next_state                                    ; $5F86
    ret                                           ; $5F8A


; C: A far call to bank 0A with gain and contrast row
Cam_SetGainContrast::
    ld a, [wCamContrastRow]                       ; $5F8B
    ld c, a                                       ; $5F8E
    ld a, [wCamGainSel]                           ; $5F8F
    ld b, a                                       ; $5F92
    ldh [hFarcallAArg], a                         ; $5F93
    farcall Cam_FarStub_BuildDitherMatrix         ; $5F95
    ret                                           ; $5F9D


; C: live view loop: brightness; contrast; shutter; options; timer
Mode14_State01_LiveView::
    call Shoot_SetupCapture                       ; $5F9E
    ld a, $10                                     ; $5FA1
    ld [$4000], a                                 ; $5FA3
    ld a, [wCamA000Shadow]                        ; $5FA6
    set 0, a                                      ; $5FA9
    ld [$a000], a                                 ; $5FAB
    call Shoot_CallVariantHandler                 ; $5FAE
    ld a, [wShootVariant]                         ; $5FB1
    cp $15                                        ; $5FB4
    call z, Img_AndMaskTiles_Bank27               ; $5FB6
    ld a, $00                                     ; $5FB9
    ld hl, wPhotoImage                            ; $5FBB
    ld de, $9000                                  ; $5FBE
    ld bc, $0800                                  ; $5FC1
    call Vram_CopyFromBank                        ; $5FC4
    ld a, $00                                     ; $5FC7
    ld hl, wPhotoImage + $800                     ; $5FC9
    ld de, $8800                                  ; $5FCC
    ld bc, $0100                                  ; $5FCF
    call Vram_CopyFromBank                        ; $5FD2
    ld a, $00                                     ; $5FD5
    ld hl, wPhotoImage + $900                     ; $5FD7
    ld de, $8000                                  ; $5FDA
    ld bc, $0500                                  ; $5FDD
    call Vram_CopyFromBank                        ; $5FE0
    ld a, $10                                     ; $5FE3
    ld [$4000], a                                 ; $5FE5

jr_006_5fe8:
    ld hl, $a000                                  ; $5FE8
    bit 0, [hl]                                   ; $5FEB
    jr nz, jr_006_5fe8                            ; $5FED

    call Shoot_BrightnessKeys                     ; $5FEF
    call Shoot_ContrastKeys                       ; $5FF2
    call Shoot_DrawBrightnessMark                 ; $5FF5
    call Shoot_DrawVariantIcon                    ; $5FF8
    call Shoot_DrawBurstIcon                      ; $5FFB
    ld a, [wShootVariant]                         ; $5FFE
    cp $13                                        ; $6001
    jr c, jr_006_600f                             ; $6003

    cp $15                                        ; $6005
    jr z, jr_006_600f                             ; $6007

    ld a, [wBurstCount]                           ; $6009
    and a                                         ; $600C
    jr nz, jr_006_601c                            ; $600D

jr_006_600f:
    ld a, [wCamBrightnessSetpoint]                ; $600F
    ldh [hFarcallAArg], a                         ; $6012
    farcall Cam_FarStub_MainDispatch              ; $6014

jr_006_601c:
    call Shoot_SetCaptureMode                     ; $601C
    ldh a, [hKeysNewSticky]                       ; $601F
    bit PADB_B, a                                 ; $6021
    jr z, jr_006_6032                             ; $6023

    push af                                       ; $6025
    ld a, SFX1_KEY_B                              ; $6026
    call Snd_Sfx1                                 ; $6028
    pop af                                        ; $602B
    set_state STATE_14_LEAVE_BY_VARIANT           ; $602C
    ret                                           ; $6031


jr_006_6032:
    call Shoot_TimerTick                          ; $6032
    ld a, [wTimerRunning]                         ; $6035
    and a                                         ; $6038
    jr z, jr_006_605f                             ; $6039

    call Shoot_LoadVariantScreen                  ; $603B
    ld hl, wTimerFrames                           ; $603E
    ld a, [hl+]                                   ; $6041
    or [hl]                                       ; $6042
    inc hl                                        ; $6043
    or [hl]                                       ; $6044
    jr nz, jr_006_605f                            ; $6045

    call Shoot_DrawShotsLeft                      ; $6047
    call Shoot_PlayShutterSound                   ; $604A
    ld a, [wShootVariant]                         ; $604D
    cp $02                                        ; $6050
    jr nz, jr_006_605a                            ; $6052

    set_state STATE_14_SHOT                       ; $6054
    ret                                           ; $6059


jr_006_605a:
    next_state                                    ; $605A
    ret                                           ; $605E


jr_006_605f:
    ldh a, [hKeysNewSticky]                       ; $605F
    bit PADB_A, a                                 ; $6061
    jp z, Mode14_State01_LiveView_OptionKey       ; $6063

    ld a, [wShootVariant]                         ; $6066
    cp $15                                        ; $6069
    jr z, jr_006_607a                             ; $606B

    ld a, [wPhotoCount]                           ; $606D
    cp $1e                                        ; $6070
    jr c, jr_006_607a                             ; $6072

    set_state STATE_14_RESULT_PREPARE             ; $6074
    ret                                           ; $6079


jr_006_607a:
    ld a, [wShootVariant]                         ; $607A
    and a                                         ; $607D
    jr nz, jr_006_608b                            ; $607E

    call Shoot_DrawShotsLeft                      ; $6080
    call Shoot_PlayShutterSound                   ; $6083
    next_state                                    ; $6086
    ret                                           ; $608A


jr_006_608b:
    cp $01                                        ; $608B
    jr nz, jr_006_609e                            ; $608D

    ld a, [wTimerRunning]                         ; $608F
    xor $01                                       ; $6092
    ld [wTimerRunning], a                         ; $6094
    ret z                                         ; $6097

    ldh a, [hVblankCounter]                       ; $6098
    ld [wTimerLastVbl], a                         ; $609A
    ret                                           ; $609D


jr_006_609e:
    cp $02                                        ; $609E
    jr nz, jr_006_60bd                            ; $60A0

    ld a, [wShotsLeft]                            ; $60A2
    and a                                         ; $60A5
    ret z                                         ; $60A6

    ld a, $01                                     ; $60A7
    ld [wTimerRunning], a                         ; $60A9
    ldh a, [hVblankCounter]                       ; $60AC
    ld [wTimerLastVbl], a                         ; $60AE
    call Shoot_DrawShotsLeft                      ; $60B1
    call Shoot_PlayShutterSound                   ; $60B4
    set_state STATE_14_SHOT                       ; $60B7
    ret                                           ; $60BC


jr_006_60bd:
    call Shoot_DrawShotsLeft                      ; $60BD
    call Shoot_PlayShutterSound                   ; $60C0
    next_state                                    ; $60C3
    ret                                           ; $60C7


; C: bit 2 of $FFA8: sfx 6, draws the option panel and goes to state 4 (the options page) (branch target; code read
; 2026-10-19)
Mode14_State01_LiveView_OptionKey::
    bit 2, a                                      ; $60C8
    ret z                                         ; $60CA

    push af                                       ; $60CB
    ld a, SFX1_KEY_SELECT                         ; $60CC
    call Snd_Sfx1                                 ; $60CE
    pop af                                        ; $60D1
    call Shoot_DrawOptionPanel                    ; $60D2
    set_state STATE_14_OPTIONS_PAGE               ; $60D5
    ret                                           ; $60DA


; C: auto: 88 bytes, bytes; referenced by Shoot_CallVariantHandler, Shoot_SetupCapture. L3 pass 2026-10-26: read in
; BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_CallVariantHandler_Tbl60DB::
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01
    db $02, $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04, $05, $05, $05, $05
    db $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08, $09, $0a, $0b, $0c
    db $00, $0e, $00, $0e, $00, $10, $00, $10, $00, $11, $00, $11, $00, $12, $10, $18
    db $00, $14, $00, $14, $00, $16, $14, $00, $00, $17, $00, $17, $00, $00, $00, $00
    db $00, $00, $00, $00, $09, $0a, $0b, $0c

; C: Up / Down changes the brightness set point
Shoot_BrightnessKeys::
    ldh a, [hKeysHeldSticky]                      ; $6133
    ld b, a                                       ; $6135
    ld a, [wCamBrightnessSetpoint]                ; $6136
    bit 6, b                                      ; $6139
    jr z, jr_006_614b                             ; $613B

    cp $0c                                        ; $613D
    ret z                                         ; $613F

    push af                                       ; $6140
    ld a, SFX1_KEY_UP_DOWN                        ; $6141
    call Snd_Sfx1                                 ; $6143
    pop af                                        ; $6146
    sub $0c                                       ; $6147
    jr jr_006_615a                                ; $6149

jr_006_614b:
    bit 7, b                                      ; $614B
    ret z                                         ; $614D

    cp $c0                                        ; $614E
    ret z                                         ; $6150

    push af                                       ; $6151
    ld a, SFX1_KEY_UP_DOWN                        ; $6152
    call Snd_Sfx1                                 ; $6154
    pop af                                        ; $6157
    add $0c                                       ; $6158

jr_006_615a:
    ld [wCamBrightnessSetpoint], a                ; $615A
    ret                                           ; $615D


; C: Left / Right changes contrast / gain
Shoot_ContrastKeys::
    ldh a, [hKeysRepeatSticky]                    ; $615E
    ld b, a                                       ; $6160
    ld a, [wCamContrastRow]                       ; $6161
    bit 5, b                                      ; $6164
    jr z, jr_006_6175                             ; $6166

    cp $01                                        ; $6168
    ret z                                         ; $616A

    push af                                       ; $616B
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $616C
    call Snd_Sfx1                                 ; $616E
    pop af                                        ; $6171
    dec a                                         ; $6172
    jr jr_006_6183                                ; $6173

jr_006_6175:
    bit 4, b                                      ; $6175
    ret z                                         ; $6177

    cp $10                                        ; $6178
    ret z                                         ; $617A

    push af                                       ; $617B
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $617C
    call Snd_Sfx1                                 ; $617E
    pop af                                        ; $6181
    inc a                                         ; $6182

jr_006_6183:
    ld [wCamContrastRow], a                       ; $6183
    ld c, a                                       ; $6186
    ld a, [wCamGainSel]                           ; $6187
    ld b, a                                       ; $618A
    ldh [hFarcallAArg], a                         ; $618B
    farcall Cam_FarStub_BuildDitherMatrix         ; $618D
    ret                                           ; $6195


; C: photos left as digits
Shoot_DrawShotsLeft::
    ld c, $00                                     ; $6196
    ld a, [wPhotoCount]                           ; $6198
    inc a                                         ; $619B

jr_006_619c:
    cp $0a                                        ; $619C
    jr c, jr_006_61a5                             ; $619E

    sub $0a                                       ; $61A0
    inc c                                         ; $61A2
    jr jr_006_619c                                ; $61A3

jr_006_61a5:
    push bc                                       ; $61A5
    ld c, a                                       ; $61A6
    ld b, $00                                     ; $61A7
    swap c                                        ; $61A9
    sla c                                         ; $61AB
    rl b                                          ; $61AD
    ld hl, $4800                                  ; $61AF
    add hl, bc                                    ; $61B2
    ld a, $17                                     ; $61B3
    ld de, $8720                                  ; $61B5
    ld bc, $0020                                  ; $61B8
    call Vram_CopyFromBank                        ; $61BB
    pop bc                                        ; $61BE
    ld b, $00                                     ; $61BF
    swap c                                        ; $61C1
    sla c                                         ; $61C3
    rl b                                          ; $61C5
    ld hl, $4800                                  ; $61C7
    add hl, bc                                    ; $61CA
    ld a, $17                                     ; $61CB
    ld de, $8700                                  ; $61CD
    ld bc, $0020                                  ; $61D0
    call Vram_CopyFromBank                        ; $61D3
    ret                                           ; $61D6


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawOptionPanel::
    call Oam_ClearShadow                          ; $61D7
    rst Rst08_WaitVBlank                          ; $61DA
    farcopy Vram_CopyFromBank, Map_24_7960_Shoot_RestoreViewScreen, $9800, $02c0 ; $61DB
    farcopy Vram_CopyFromBank, Gfx_17_4C00_Shoot_DrawOptionPanel, $8900, $0400 ; $61E9
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $61F7
    farcopy Vram_CopyFromBank, Map_24_6E60_Shoot_DrawOptionPanel, $9800, $02c0 ; $6205
    ret                                           ; $6213


; C: tilemap 24:7960 back to the BG
Shoot_RestoreViewScreen::
    call Oam_ClearShadow                          ; $6214
    rst Rst08_WaitVBlank                          ; $6217
    farcopy Vram_CopyFromBank, Map_24_7960_Shoot_RestoreViewScreen, $9800, $02c0 ; $6218
    farcopy Vram_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $6226
    farcopy Vram_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $6234
    call Shoot_ClearEffectTiles                   ; $6242
    farcopy Vram_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $6245
    ret                                           ; $6253


; C
Shoot_DrawBrightnessMark::
    ld a, [wCamContrastRow]                       ; $6254
    dec a                                         ; $6257
    ld l, $c8                                     ; $6258
    call Math_MulAL                               ; $625A
    ld bc, $0010                                  ; $625D
    add hl, bc                                    ; $6260
    sla l                                         ; $6261
    rl h                                          ; $6263
    sla l                                         ; $6265
    rl h                                          ; $6267
    sla l                                         ; $6269
    rl h                                          ; $626B
    ld a, h                                       ; $626D
    add $25                                       ; $626E
    ld b, a                                       ; $6270
    ld c, $8a                                     ; $6271
    ld a, $35                                     ; $6273
    call Oam_AddMeta_B01_5D47                     ; $6275
    ld a, [wCamBrightnessSetpoint]                ; $6278
    sub $0c                                       ; $627B
    ld l, $dd                                     ; $627D
    call Math_MulAL                               ; $627F
    ld bc, $0100                                  ; $6282
    add hl, bc                                    ; $6285
    srl h                                         ; $6286
    rr l                                          ; $6288
    ld a, h                                       ; $628A
    add $25                                       ; $628B
    ld c, a                                       ; $628D
    ld b, $92                                     ; $628E
    ld a, $36                                     ; $6290
    call Oam_AddMeta_B01_5D47                     ; $6292
    ret                                           ; $6295


; C: icon of the effect for variants >= 11
Shoot_DrawVariantIcon::
    ld a, [wShootVariant]                         ; $6296
    cp $0b                                        ; $6299
    ret c                                         ; $629B

    sub $0b                                       ; $629C
    sla a                                         ; $629E
    ld c, a                                       ; $62A0
    sla a                                         ; $62A1
    add c                                         ; $62A3
    ld c, a                                       ; $62A4
    ld b, $00                                     ; $62A5
    ld hl, Shoot_DrawVariantIcon_Tbl62D5          ; $62A7
    add hl, bc                                    ; $62AA
    ld d, [hl]                                    ; $62AB
    inc hl                                        ; $62AC
    inc hl                                        ; $62AD
    ldh a, [hFrameCounter]                        ; $62AE
    and $01                                       ; $62B0
    ld e, a                                       ; $62B2
    ld c, $01                                     ; $62B3
    call Shoot_DrawIconBits                       ; $62B5
    inc e                                         ; $62B8
    inc e                                         ; $62B9
    call Shoot_DrawIconBits                       ; $62BA
    call Shoot_DrawIconBits                       ; $62BD
    inc e                                         ; $62C0
    inc e                                         ; $62C1

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawIconBits::
    push bc                                       ; $62C2
    ld a, d                                       ; $62C3
    and c                                         ; $62C4
    jr z, jr_006_62d1                             ; $62C5

    ld c, [hl]                                    ; $62C7
    inc hl                                        ; $62C8
    ld b, [hl]                                    ; $62C9
    inc hl                                        ; $62CA
    ld a, $3c                                     ; $62CB
    add e                                         ; $62CD
    call Oam_AddMeta_B01_5D47                     ; $62CE

jr_006_62d1:
    pop bc                                        ; $62D1
    sla c                                         ; $62D2
    ret                                           ; $62D4


; C: auto: 66 bytes, bytes; referenced by Shoot_DrawVariantIcon. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawVariantIcon_Tbl62D5::
    db $03, $00, $34, $4f, $46, $57, $01, $00, $34, $4f, $00, $00, $02, $00, $46, $57
    db $00, $00, $03, $00, $34, $4f, $46, $57, $03, $00, $34, $4f, $46, $57, $02, $00
    db $5e, $57, $00, $00, $06, $00, $5e, $57, $2e, $57, $08, $00, $47, $50, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $00, $34, $4f
    db $46, $57

; C: L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawBurstIcon::
    ld a, [wShootVariant]                         ; $6317
    cp $13                                        ; $631A
    jr z, jr_006_6323                             ; $631C

    cp $14                                        ; $631E
    jr z, jr_006_632c                             ; $6320

    ret                                           ; $6322


jr_006_6323:
    ld bc, $0848                                  ; $6323
    ld a, $3b                                     ; $6326
    call Oam_AddMeta_B01_5D47                     ; $6328
    ret                                           ; $632B


jr_006_632c:
    ld bc, $4008                                  ; $632C
    ld a, $3a                                     ; $632F
    call Oam_AddMeta_B01_5D47                     ; $6331
    ret                                           ; $6334


; C: shutter button / self-timer countdown
Mode14_State02_Shutter::
    call Shoot_DrawTimerJitter                    ; $6335
    ldh a, [hKeysNew]                             ; $6338
    bit PADB_A, a                                 ; $633A
    jr z, jr_006_6362                             ; $633C

    push af                                       ; $633E
    ld a, SFX1_KEY_A                              ; $633F
    call Snd_Sfx1                                 ; $6341
    pop af                                        ; $6344
    xor a                                         ; $6345
    ld [wShootPhase], a                           ; $6346
    call Oam_ClearShadow                          ; $6349
    rst Rst08_WaitVBlank                          ; $634C
    ld a, [wShootVariant]                         ; $634D
    sub $12                                       ; $6350
    jr nc, jr_006_6355                            ; $6352

    xor a                                         ; $6354

jr_006_6355:
    sla a                                         ; $6355
    ld c, a                                       ; $6357
    ld b, $00                                     ; $6358
    ld hl, Mode14_State02_Shutter_JumpTbl6388     ; $635A
    add hl, bc                                    ; $635D
    ld a, [hl+]                                   ; $635E
    ld h, [hl]                                    ; $635F
    ld l, a                                       ; $6360
    jp hl                                         ; $6361


jr_006_6362:
    bit 1, a                                      ; $6362
    ret z                                         ; $6364

    push af                                       ; $6365
    ld a, SFX1_KEY_B                              ; $6366
    call Snd_Sfx1                                 ; $6368
    pop af                                        ; $636B
    ld a, [wShootVariant]                         ; $636C
    cp $01                                        ; $636F
    jr nz, jr_006_637f                            ; $6371

    call Shoot_ResetTimer                         ; $6373
    ldh a, [hVblankCounter]                       ; $6376
    ld [wTimerLastVbl], a                         ; $6378
    xor a                                         ; $637B
    ld [wTimerRunning], a                         ; $637C

jr_006_637f:
    call Shoot_LoadVariantScreen                  ; $637F
    set_state STATE_14_LIVE_VIEW                  ; $6382
    ret                                           ; $6387


; C: auto: 8 bytes, word table; referenced by Mode14_State02_Shutter. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Mode14_State02_Shutter_JumpTbl6388::
    dw Shoot_ShutterVariant0
    dw Shoot_ShutterVariant1
    dw Shoot_ShutterVariant2
    dw Shoot_ShutterVariant3

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant0::
    ldh [hFarcallAArg], a                         ; $6390
    farcall Photo_SaveShot_Far                    ; $6392
    call Snd_PlayTagDigits                        ; $639A
    call Counters_IncTaken                        ; $639D
    ld a, [wShootVariant]                         ; $63A0
    cp $01                                        ; $63A3
    jr nz, jr_006_63b3                            ; $63A5

    call Shoot_ResetTimer                         ; $63A7
    ldh a, [hVblankCounter]                       ; $63AA
    ld [wTimerLastVbl], a                         ; $63AC
    xor a                                         ; $63AF
    ld [wTimerRunning], a                         ; $63B0

jr_006_63b3:
    call Shoot_LoadVariantScreen                  ; $63B3
    set_state STATE_14_LIVE_VIEW                  ; $63B6
    ret                                           ; $63BB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant1::
    ldh [hFarcallAArg], a                         ; $63BC
    farcall Photo_SaveShot_Far                    ; $63BE
    call Snd_PlayTagDigits                        ; $63C6
    call Counters_IncTaken                        ; $63C9
    ld a, [wBurstCount]                           ; $63CC
    ld c, a                                       ; $63CF
    ld b, $00                                     ; $63D0
    ld hl, wBurstPhotos                           ; $63D2
    add hl, bc                                    ; $63D5
    ld a, [wPhotoCount]                           ; $63D6
    dec a                                         ; $63D9
    ld [hl], a                                    ; $63DA
    inc c                                         ; $63DB
    ld a, c                                       ; $63DC
    and $03                                       ; $63DD
    ld [wBurstCount], a                           ; $63DF
    call Shoot_LoadVariantScreen                  ; $63E2
    call Shoot_LoadBurstIcons                     ; $63E5
    ld a, [wBurstCount]                           ; $63E8
    and a                                         ; $63EB
    jr z, jr_006_63f4                             ; $63EC

    set_state STATE_14_LIVE_VIEW                  ; $63EE
    ret                                           ; $63F3


jr_006_63f4:
    set_state STATE_14_LEAVE_BY_VARIANT           ; $63F4
    ret                                           ; $63F9


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant2::
    ldh [hFarcallAArg], a                         ; $63FA
    farcall Photo_SaveShot_Far                    ; $63FC
    call Snd_PlayTagDigits                        ; $6404
    call Counters_IncTaken                        ; $6407
    ld a, [wBurstCount]                           ; $640A
    ld c, a                                       ; $640D
    ld b, $00                                     ; $640E
    ld hl, wBurstPhotos                           ; $6410
    add hl, bc                                    ; $6413
    ld a, [wPhotoCount]                           ; $6414
    dec a                                         ; $6417
    ld [hl], a                                    ; $6418
    inc c                                         ; $6419
    ld a, c                                       ; $641A
    and $03                                       ; $641B
    ld [wBurstCount], a                           ; $641D
    call Shoot_LoadVariantScreen                  ; $6420
    call Shoot_LoadBurstIcons                     ; $6423
    ld a, [wBurstCount]                           ; $6426
    and a                                         ; $6429
    jr z, jr_006_6432                             ; $642A

    set_state STATE_14_LIVE_VIEW                  ; $642C
    ret                                           ; $6431


jr_006_6432:
    set_state STATE_14_LEAVE_BY_VARIANT           ; $6432
    ret                                           ; $6437


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_ShutterVariant3::
    ldh [hFarcallAArg], a                         ; $6438
    farcall GameFace_Store_Far                    ; $643A
    set_state STATE_14_LEAVE_BY_VARIANT           ; $6442
    ret                                           ; $6447


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTimerJitter::
    ldh a, [hFrameCounter]                        ; $6448
    and $01                                       ; $644A
    jr nz, jr_006_645a                            ; $644C

    call Rng_Next                                 ; $644E
    ld [wJitterX], a                              ; $6451
    call Rng_Next                                 ; $6454
    ld [wJitterY], a                              ; $6457

jr_006_645a:
    ld a, [wJitterX]                              ; $645A
    and $01                                       ; $645D
    add $79                                       ; $645F
    ld b, a                                       ; $6461
    ld a, [wShootVariant]                         ; $6462
    cp $0b                                        ; $6465
    jr c, jr_006_6479                             ; $6467

    cp $13                                        ; $6469
    jr c, jr_006_6471                             ; $646B

    cp $15                                        ; $646D
    jr nz, jr_006_6479                            ; $646F

jr_006_6471:
    ld a, [wJitterX]                              ; $6471
    and $01                                       ; $6474
    add $35                                       ; $6476
    ld b, a                                       ; $6478

jr_006_6479:
    ld a, [wJitterY]                              ; $6479
    and $01                                       ; $647C
    add $7d                                       ; $647E
    ld c, a                                       ; $6480
    ld a, $38                                     ; $6481
    call Oam_AddMeta_B01_5D47                     ; $6483
    ld a, [wJitterY]                              ; $6486
    and $01                                       ; $6489
    add $8d                                       ; $648B
    ld c, a                                       ; $648D
    ld a, $39                                     ; $648E
    call Oam_AddMeta_B01_5D47                     ; $6490
    ld a, [wShootVariant]                         ; $6493
    cp $15                                        ; $6496
    ret z                                         ; $6498

    ld a, [wJitterX]                              ; $6499
    xor $01                                       ; $649C
    and $01                                       ; $649E
    add $34                                       ; $64A0
    ld b, a                                       ; $64A2
    ld a, [wJitterY]                              ; $64A3
    xor $01                                       ; $64A6
    and $01                                       ; $64A8
    add $33                                       ; $64AA
    ld c, a                                       ; $64AC
    ld a, $37                                     ; $64AD
    call Oam_AddMeta_B01_5D47                     ; $64AF
    ret                                           ; $64B2


; C: a shot was taken: saves and counts
Mode14_State03_Shot::
    call Shoot_DrawShotJitter                     ; $64B3
    call Oam_HideUnused                           ; $64B6
    ld bc, $000a                                  ; $64B9
    call Wait_Frames                              ; $64BC
    call Oam_ClearShadow                          ; $64BF
    rst Rst08_WaitVBlank                          ; $64C2
    ldh [hFarcallAArg], a                         ; $64C3
    farcall Photo_SaveShot_Far                    ; $64C5
    call Counters_IncTaken                        ; $64CD
    ld a, [wShootVariant]                         ; $64D0
    cp $02                                        ; $64D3
    jr nz, jr_006_64fb                            ; $64D5

    ld hl, wShotsLeft                             ; $64D7
    dec [hl]                                      ; $64DA
    jr nz, jr_006_64f1                            ; $64DB

    xor a                                         ; $64DD
    ld [wTimerRunning], a                         ; $64DE
    ld a, [wPhotoCount]                           ; $64E1
    cpl                                           ; $64E4
    add $1f                                       ; $64E5
    ld hl, wIntervalShots                         ; $64E7
    cp [hl]                                       ; $64EA
    jr c, jr_006_64ee                             ; $64EB

    ld a, [hl]                                    ; $64ED

jr_006_64ee:
    ld [wShotsLeft], a                            ; $64EE

jr_006_64f1:
    call Shoot_ResetTimer                         ; $64F1
    ldh a, [hVblankCounter]                       ; $64F4
    ld [wTimerLastVbl], a                         ; $64F6
    jr jr_006_6507                                ; $64F9

jr_006_64fb:
    call Shoot_ResetTimer                         ; $64FB
    ldh a, [hVblankCounter]                       ; $64FE
    ld [wTimerLastVbl], a                         ; $6500
    xor a                                         ; $6503
    ld [wTimerRunning], a                         ; $6504

jr_006_6507:
    call Shoot_LoadVariantScreen                  ; $6507
    set_state STATE_14_LIVE_VIEW                  ; $650A
    ret                                           ; $650F


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawShotJitter::
    ldh a, [hFrameCounter]                        ; $6510
    and $01                                       ; $6512
    jr nz, jr_006_6522                            ; $6514

    call Rng_Next                                 ; $6516
    ld [wJitterX], a                              ; $6519
    call Rng_Next                                 ; $651C
    ld [wJitterY], a                              ; $651F

jr_006_6522:
    ld a, [wShootVariant]                         ; $6522
    cp $15                                        ; $6525
    ret z                                         ; $6527

    ld a, [wJitterX]                              ; $6528
    xor $01                                       ; $652B
    and $01                                       ; $652D
    add $34                                       ; $652F
    ld b, a                                       ; $6531
    ld a, [wJitterY]                              ; $6532
    xor $01                                       ; $6535
    and $01                                       ; $6537
    add $33                                       ; $6539
    ld c, a                                       ; $653B
    ld a, $37                                     ; $653C
    call Oam_AddMeta_B01_5D47                     ; $653E
    ret                                           ; $6541


; C: Start: the options page (flip / palette / dither / shutter)
Mode14_State04_OptionsPage::
    ld a, [wBlinkCounter]                         ; $6542
    inc a                                         ; $6545
    ld [wBlinkCounter], a                         ; $6546
    bit 4, a                                      ; $6549
    jr z, jr_006_656d                             ; $654B

    ld a, $a3                                     ; $654D
    ld bc, $5078                                  ; $654F
    call Oam_AddMeta_B01_4000                     ; $6552
    ld a, $a2                                     ; $6555
    ld bc, $5018                                  ; $6557
    call Oam_AddMeta_B01_4000                     ; $655A
    ld a, $a5                                     ; $655D
    ld bc, $1848                                  ; $655F
    call Oam_AddMeta_B01_4000                     ; $6562
    ld a, $a4                                     ; $6565
    ld bc, $8848                                  ; $6567
    call Oam_AddMeta_B01_4000                     ; $656A

jr_006_656d:
    ldh a, [hKeysNew]                             ; $656D
    and PADF_B | PADF_SELECT                      ; $656F
    jr z, jr_006_6583                             ; $6571

    push af                                       ; $6573
    ld a, SFX1_KEY_B                              ; $6574
    call Snd_Sfx1                                 ; $6576
    pop af                                        ; $6579
    call Shoot_RestoreViewScreen                  ; $657A
    set_state STATE_14_LIVE_VIEW                  ; $657D
    ret                                           ; $6582


jr_006_6583:
    ldh a, [hKeysNewRepeat]                       ; $6583
    and PADF_DPAD                                 ; $6585
    ret z                                         ; $6587

    xor a                                         ; $6588
    ld [wArrowAnimTick], a                        ; $6589
    ld [wArrowAnimFrame], a                       ; $658C
    ldh a, [hKeysNewRepeat]                       ; $658F
    bit PADB_LEFT, a                              ; $6591
    jr z, jr_006_65e8                             ; $6593

    push af                                       ; $6595
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6596
    call Snd_Sfx1                                 ; $6598
    pop af                                        ; $659B
    call Oam_ClearShadow                          ; $659C
    farcopy Vram_CopyFromBank, Gfx_17_5200_Mode14_State04_OptionsPage, $8d00, $0200 ; $659F
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $65AD
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $65BB
    ld a, [wShootRampSel]                         ; $65C9
    ld [wChoiceCursorA], a                        ; $65CC
    ld hl, Slide_ScyDeltaTbl                      ; $65CF
    ld b, $10                                     ; $65D2

jr_006_65d4:
    push bc                                       ; $65D4
    push hl                                       ; $65D5
    ldh a, [hScxShadow]                           ; $65D6
    add [hl]                                      ; $65D8
    ldh [hScxShadow], a                           ; $65D9
    rst Rst08_WaitVBlank                          ; $65DB
    pop hl                                        ; $65DC
    pop bc                                        ; $65DD
    inc hl                                        ; $65DE
    dec b                                         ; $65DF
    jr nz, jr_006_65d4                            ; $65E0

    set_state STATE_14_OPTION_DITHER              ; $65E2
    ret                                           ; $65E7


jr_006_65e8:
    bit 4, a                                      ; $65E8
    jr z, jr_006_663f                             ; $65EA

    push af                                       ; $65EC
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $65ED
    call Snd_Sfx1                                 ; $65EF
    pop af                                        ; $65F2
    call Oam_ClearShadow                          ; $65F3
    farcopy Vram_CopyFromBank, Gfx_17_5200_Mode14_State04_OptionsPage, $8d00, $0200 ; $65F6
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $6604
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $6612
    ld a, [wShutterSound]                         ; $6620
    ld [wChoiceCursorA], a                        ; $6623
    ld hl, Slide_ScyDeltaTbl                      ; $6626
    ld b, $10                                     ; $6629

jr_006_662b:
    push bc                                       ; $662B
    push hl                                       ; $662C
    ldh a, [hScxShadow]                           ; $662D
    sub [hl]                                      ; $662F
    ldh [hScxShadow], a                           ; $6630
    rst Rst08_WaitVBlank                          ; $6632
    pop hl                                        ; $6633
    pop bc                                        ; $6634
    inc hl                                        ; $6635
    dec b                                         ; $6636
    jr nz, jr_006_662b                            ; $6637

    set_state STATE_14_OPTION_SHUTTER_SOUND       ; $6639
    ret                                           ; $663E


jr_006_663f:
    bit 6, a                                      ; $663F
    jr z, jr_006_669b                             ; $6641

    push af                                       ; $6643
    ld a, SFX1_KEY_UP_DOWN                        ; $6644
    call Snd_Sfx1                                 ; $6646
    pop af                                        ; $6649
    call Oam_ClearShadow                          ; $664A
    ld a, $17                                     ; $664D
    ld hl, Gfx_17_5000_Mode14_State04_OptionsPage ; $664F
    ld de, $8d00                                  ; $6652
    ld bc, $0200                                  ; $6655
    call Vram_CopyFromBank                        ; $6658
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $665B
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6669
    ld a, [wShootCaptureSel]                      ; $6677
    ld [wChoiceCursorA], a                        ; $667A
    ld hl, Slide_ScyDeltaTbl                      ; $667D
    ld b, $10                                     ; $6680

jr_006_6682:
    push bc                                       ; $6682
    push hl                                       ; $6683
    ldh a, [hScyShadow]                           ; $6684
    add [hl]                                      ; $6686
    ldh [hScyShadow], a                           ; $6687
    cpl                                           ; $6689
    add $64                                       ; $668A
    ldh [hLycShadowSplit1], a                     ; $668C
    rst Rst08_WaitVBlank                          ; $668E
    pop hl                                        ; $668F
    pop bc                                        ; $6690
    inc hl                                        ; $6691
    dec b                                         ; $6692
    jr nz, jr_006_6682                            ; $6693

    set_state STATE_14_OPTION_PALETTE             ; $6695
    ret                                           ; $669A


jr_006_669b:
    bit 7, a                                      ; $669B
    ret z                                         ; $669D

    push af                                       ; $669E
    ld a, SFX1_KEY_UP_DOWN                        ; $669F
    call Snd_Sfx1                                 ; $66A1
    pop af                                        ; $66A4
    call Oam_ClearShadow                          ; $66A5
    ld a, $17                                     ; $66A8
    ld hl, Gfx_17_5000_Mode14_State04_OptionsPage ; $66AA
    ld de, $8d00                                  ; $66AD
    ld bc, $0200                                  ; $66B0
    call Vram_CopyFromBank                        ; $66B3
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $66B6
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $66C4
    ld a, [wShootEffectSel]                       ; $66D2
    ld [wChoiceCursorA], a                        ; $66D5
    ld hl, Slide_ScyDeltaTbl                      ; $66D8
    ld b, $10                                     ; $66DB

jr_006_66dd:
    push bc                                       ; $66DD
    push hl                                       ; $66DE
    ldh a, [hScyShadow]                           ; $66DF
    sub [hl]                                      ; $66E1
    ldh [hScyShadow], a                           ; $66E2
    cpl                                           ; $66E4
    add $64                                       ; $66E5
    ldh [hLycShadowSplit1], a                     ; $66E7
    rst Rst08_WaitVBlank                          ; $66E9
    pop hl                                        ; $66EA
    pop bc                                        ; $66EB
    inc hl                                        ; $66EC
    dec b                                         ; $66ED
    jr nz, jr_006_66dd                            ; $66EE

    set_state STATE_14_OPTION_FLIP_EFFECT         ; $66F0
    ret                                           ; $66F5


; C
Mode14_State05_OptionDither::
    call Shoot_Options_ReadKeysA                  ; $66F6
    call Shoot_Options_DrawCursorA                ; $66F9
    ldh a, [hKeysNew]                             ; $66FC
    and PADF_A | PADF_B | PADF_RIGHT              ; $66FE
    ret z                                         ; $6700

    call Snd_KeyBlips                             ; $6701
    push af                                       ; $6704
    bit 0, a                                      ; $6705
    call nz, Shoot_Options_RedrawArrowA           ; $6707
    call Oam_ClearShadow                          ; $670A
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $670D
    ld b, $10                                     ; $6710

jr_006_6712:
    push bc                                       ; $6712
    push hl                                       ; $6713
    ldh a, [hScxShadow]                           ; $6714
    sub [hl]                                      ; $6716
    ldh [hScxShadow], a                           ; $6717
    rst Rst08_WaitVBlank                          ; $6719
    pop hl                                        ; $671A
    pop bc                                        ; $671B
    inc hl                                        ; $671C
    dec b                                         ; $671D
    jr nz, jr_006_6712                            ; $671E

    pop af                                        ; $6720
    bit 0, a                                      ; $6721
    jr nz, jr_006_672b                            ; $6723

    set_state STATE_14_OPTIONS_PAGE               ; $6725
    ret                                           ; $672A


jr_006_672b:
    call Shoot_RestoreViewScreen                  ; $672B
    set_state STATE_14_LIVE_VIEW                  ; $672E
    ret                                           ; $6733


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowA::
    ld hl, wArrowAnimFrame                        ; $6734
    inc [hl]                                      ; $6737
    call Oam_HideUnused                           ; $6738
    rst Rst08_WaitVBlank                          ; $673B

jr_006_673c:
    call Shoot_Options_DrawCursorA                ; $673C
    call Oam_HideUnused                           ; $673F
    rst Rst08_WaitVBlank                          ; $6742
    ld a, [wArrowAnimFrame]                       ; $6743
    cp $02                                        ; $6746
    jr nz, jr_006_673c                            ; $6748

    ld a, [wChoiceCursorA]                        ; $674A
    ld hl, wShootRampSel                          ; $674D
    cp [hl]                                       ; $6750
    ret z                                         ; $6751

    ld [hl], a                                    ; $6752
    ld [wCamDitherMode], a                        ; $6753
    ld a, [wCamContrastRow]                       ; $6756
    ld c, a                                       ; $6759
    ld a, [wCamGainSel]                           ; $675A
    ld b, a                                       ; $675D
    ldh [hFarcallAArg], a                         ; $675E
    farcall Cam_FarStub_BuildDitherMatrix         ; $6760
    ret                                           ; $6768


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_ReadKeysA::
    ldh a, [hKeysNewRepeat]                       ; $6769
    ld b, a                                       ; $676B
    ld a, [wChoiceCursorA]                        ; $676C
    bit 7, b                                      ; $676F
    jr z, jr_006_6776                             ; $6771

    xor a                                         ; $6773
    jr jr_006_678e                                ; $6774

jr_006_6776:
    bit 6, b                                      ; $6776
    ret z                                         ; $6778

    ld a, [wShootVariant]                         ; $6779
    cp $0a                                        ; $677C
    jr z, jr_006_678c                             ; $677E

    cp $0b                                        ; $6780
    jr z, jr_006_678c                             ; $6782

    cp $15                                        ; $6784
    jr z, jr_006_678c                             ; $6786

    ld a, $01                                     ; $6788
    jr jr_006_678e                                ; $678A

jr_006_678c:
    ld a, $02                                     ; $678C

jr_006_678e:
    ld hl, wChoiceCursorA                         ; $678E
    cp [hl]                                       ; $6791
    ret z                                         ; $6792

    ld [hl], a                                    ; $6793
    call Snd_KeyBlips                             ; $6794
    ret                                           ; $6797


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_DrawCursorA::
    ld a, [wChoiceCursorA]                        ; $6798
    sla a                                         ; $679B
    ld c, a                                       ; $679D
    ld b, $00                                     ; $679E
    ld hl, Shoot_Options_DrawCursorA_Tbl67D6      ; $67A0
    add hl, bc                                    ; $67A3
    ld c, [hl]                                    ; $67A4
    inc hl                                        ; $67A5
    ld b, [hl]                                    ; $67A6
    ld a, [wArrowAnimFrame]                       ; $67A7
    cp $02                                        ; $67AA
    ret z                                         ; $67AC

    sla a                                         ; $67AD
    push bc                                       ; $67AF
    ld c, a                                       ; $67B0
    ld b, $00                                     ; $67B1
    ld hl, Shoot_Options_DrawCursorA_Tbl67DC      ; $67B3
    add hl, bc                                    ; $67B6
    ld a, [hl+]                                   ; $67B7
    pop bc                                        ; $67B8
    push hl                                       ; $67B9
    call Oam_AddMeta_B01_4000                     ; $67BA
    pop hl                                        ; $67BD
    ld a, [wArrowAnimTick]                        ; $67BE
    cp [hl]                                       ; $67C1
    jr nz, jr_006_67cc                            ; $67C2

    ld hl, wArrowAnimFrame                        ; $67C4
    inc [hl]                                      ; $67C7
    xor a                                         ; $67C8
    ld [wArrowAnimTick], a                        ; $67C9

jr_006_67cc:
    ld a, [wArrowAnimFrame]                       ; $67CC
    and a                                         ; $67CF
    ret z                                         ; $67D0

    ld hl, wArrowAnimTick                         ; $67D1
    inc [hl]                                      ; $67D4
    ret                                           ; $67D5


; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorA. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Shoot_Options_DrawCursorA_Tbl67D6::
    db $68, $10, $20, $10, $20, $10

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorA. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 14)
Shoot_Options_DrawCursorA_Tbl67DC::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode14_State06_OptionShutterSound::
    call Shoot_Options_ReadKeysB                  ; $67E2
    call Shoot_Options_DrawCursorB                ; $67E5
    ldh a, [hKeysNew]                             ; $67E8
    and PADF_A | PADF_B | PADF_LEFT               ; $67EA
    ret z                                         ; $67EC

    push af                                       ; $67ED
    bit 0, a                                      ; $67EE
    jr z, jr_006_67fa                             ; $67F0

    call Shoot_Options_RedrawArrowB               ; $67F2
    call Shoot_PlayShutterSound                   ; $67F5
    jr jr_006_67fd                                ; $67F8

jr_006_67fa:
    call Snd_KeyBlips                             ; $67FA

jr_006_67fd:
    call Oam_ClearShadow                          ; $67FD
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6800
    ld b, $10                                     ; $6803

jr_006_6805:
    push bc                                       ; $6805
    push hl                                       ; $6806
    ldh a, [hScxShadow]                           ; $6807
    add [hl]                                      ; $6809
    ldh [hScxShadow], a                           ; $680A
    rst Rst08_WaitVBlank                          ; $680C
    pop hl                                        ; $680D
    pop bc                                        ; $680E
    inc hl                                        ; $680F
    dec b                                         ; $6810
    jr nz, jr_006_6805                            ; $6811

    pop af                                        ; $6813
    bit 0, a                                      ; $6814
    jr nz, jr_006_681e                            ; $6816

    set_state STATE_14_OPTIONS_PAGE               ; $6818
    ret                                           ; $681D


jr_006_681e:
    call Shoot_RestoreViewScreen                  ; $681E
    set_state STATE_14_LIVE_VIEW                  ; $6821
    ret                                           ; $6826


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowB::
    ld hl, wArrowAnimFrame                        ; $6827
    inc [hl]                                      ; $682A
    call Oam_HideUnused                           ; $682B
    rst Rst08_WaitVBlank                          ; $682E

jr_006_682f:
    call Shoot_Options_DrawCursorB                ; $682F
    call Oam_HideUnused                           ; $6832
    rst Rst08_WaitVBlank                          ; $6835
    ld a, [wArrowAnimFrame]                       ; $6836
    cp $02                                        ; $6839
    jr nz, jr_006_682f                            ; $683B

    ld a, [wChoiceCursorA]                        ; $683D
    ld hl, wShutterSound                          ; $6840
    cp [hl]                                       ; $6843
    ret z                                         ; $6844

    ld [hl], a                                    ; $6845
    ret                                           ; $6846


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysB::
    ldh a, [hKeysNewRepeat]                       ; $6847
    ld b, a                                       ; $6849
    ld a, [wChoiceCursorA]                        ; $684A
    bit 6, b                                      ; $684D
    jr z, jr_006_6856                             ; $684F

    and a                                         ; $6851
    ret z                                         ; $6852

    dec a                                         ; $6853
    jr jr_006_685d                                ; $6854

jr_006_6856:
    bit 7, b                                      ; $6856
    ret z                                         ; $6858

    cp $04                                        ; $6859
    ret z                                         ; $685B

    inc a                                         ; $685C

jr_006_685d:
    ld [wChoiceCursorA], a                        ; $685D
    call Snd_KeyBlips                             ; $6860
    ret                                           ; $6863


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB::
    ld a, [wChoiceCursorA]                        ; $6864
    sla a                                         ; $6867
    ld c, a                                       ; $6869
    ld b, $00                                     ; $686A
    ld hl, Shoot_Options_DrawCursorB_Tbl68A2      ; $686C
    add hl, bc                                    ; $686F
    ld c, [hl]                                    ; $6870
    inc hl                                        ; $6871
    ld b, [hl]                                    ; $6872
    ld a, [wArrowAnimFrame]                       ; $6873
    cp $02                                        ; $6876
    ret z                                         ; $6878

    sla a                                         ; $6879
    push bc                                       ; $687B
    ld c, a                                       ; $687C
    ld b, $00                                     ; $687D
    ld hl, Shoot_Options_DrawCursorB_Tbl68AC      ; $687F
    add hl, bc                                    ; $6882
    ld a, [hl+]                                   ; $6883
    pop bc                                        ; $6884
    push hl                                       ; $6885
    call Oam_AddMeta_B01_4000                     ; $6886
    pop hl                                        ; $6889
    ld a, [wArrowAnimTick]                        ; $688A
    cp [hl]                                       ; $688D
    jr nz, jr_006_6898                            ; $688E

    ld hl, wArrowAnimFrame                        ; $6890
    inc [hl]                                      ; $6893
    xor a                                         ; $6894
    ld [wArrowAnimTick], a                        ; $6895

jr_006_6898:
    ld a, [wArrowAnimFrame]                       ; $6898
    and a                                         ; $689B
    ret z                                         ; $689C

    ld hl, wArrowAnimTick                         ; $689D
    inc [hl]                                      ; $68A0
    ret                                           ; $68A1


; C: auto: 10 bytes, bytes; referenced by Shoot_Options_DrawCursorB. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB_Tbl68A2::
    db $18, $90, $30, $90, $48, $90, $60, $90, $78, $90

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorB. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorB_Tbl68AC::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode14_State07_OptionPalette::
    call Shoot_Options_ReadKeysC                  ; $68B2
    call Shoot_Options_DrawCursorC                ; $68B5
    ldh a, [hKeysNew]                             ; $68B8
    and PADF_A | PADF_B | PADF_DOWN               ; $68BA
    ret z                                         ; $68BC

    call Snd_KeyBlips                             ; $68BD
    push af                                       ; $68C0
    bit 0, a                                      ; $68C1
    call nz, Shoot_Options_RedrawArrowC           ; $68C3
    call Oam_ClearShadow                          ; $68C6
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $68C9
    ld b, $10                                     ; $68CC

jr_006_68ce:
    push bc                                       ; $68CE
    push hl                                       ; $68CF
    ldh a, [hScyShadow]                           ; $68D0
    sub [hl]                                      ; $68D2
    ldh [hScyShadow], a                           ; $68D3
    cpl                                           ; $68D5
    add $64                                       ; $68D6
    ldh [hLycShadowSplit1], a                     ; $68D8
    rst Rst08_WaitVBlank                          ; $68DA
    pop hl                                        ; $68DB
    pop bc                                        ; $68DC
    inc hl                                        ; $68DD
    dec b                                         ; $68DE
    jr nz, jr_006_68ce                            ; $68DF

    pop af                                        ; $68E1
    bit 0, a                                      ; $68E2
    jr nz, jr_006_68ec                            ; $68E4

    set_state STATE_14_OPTIONS_PAGE               ; $68E6
    ret                                           ; $68EB


jr_006_68ec:
    call Shoot_RestoreViewScreen                  ; $68EC
    set_state STATE_14_LIVE_VIEW                  ; $68EF
    ret                                           ; $68F4


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowC::
    ld hl, wArrowAnimFrame                        ; $68F5
    inc [hl]                                      ; $68F8
    call Oam_HideUnused                           ; $68F9
    rst Rst08_WaitVBlank                          ; $68FC

jr_006_68fd:
    call Shoot_Options_DrawCursorC                ; $68FD
    call Oam_HideUnused                           ; $6900
    rst Rst08_WaitVBlank                          ; $6903
    ld a, [wArrowAnimFrame]                       ; $6904
    cp $02                                        ; $6907
    jr nz, jr_006_68fd                            ; $6909

    ld a, [wChoiceCursorA]                        ; $690B
    ld hl, wShootCaptureSel                       ; $690E
    cp [hl]                                       ; $6911
    ret z                                         ; $6912

    ld [hl], a                                    ; $6913
    ret                                           ; $6914


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysC::
    ldh a, [hKeysNewRepeat]                       ; $6915
    ld b, a                                       ; $6917
    ld a, [wChoiceCursorA]                        ; $6918
    bit 5, b                                      ; $691B
    jr z, jr_006_6924                             ; $691D

    and a                                         ; $691F
    ret z                                         ; $6920

    dec a                                         ; $6921
    jr jr_006_692b                                ; $6922

jr_006_6924:
    bit 4, b                                      ; $6924
    ret z                                         ; $6926

    cp $02                                        ; $6927
    ret z                                         ; $6929

    inc a                                         ; $692A

jr_006_692b:
    ld [wChoiceCursorA], a                        ; $692B
    call Snd_KeyBlips                             ; $692E
    call Shoot_SetupCapture                       ; $6931
    call Shoot_CallVariantHandler                 ; $6934
    ld a, [wShootVariant]                         ; $6937
    cp $15                                        ; $693A
    call z, Img_AndMaskTiles_Bank27               ; $693C
    ld a, $00                                     ; $693F
    ld hl, wPhotoImage                            ; $6941
    ld de, $9000                                  ; $6944
    ld bc, $0800                                  ; $6947
    call Vram_CopyFromBank                        ; $694A
    ld a, $00                                     ; $694D
    ld hl, wPhotoImage + $800                     ; $694F
    ld de, $8800                                  ; $6952
    ld bc, $0100                                  ; $6955
    call Vram_CopyFromBank                        ; $6958
    ld a, $00                                     ; $695B
    ld hl, wPhotoImage + $900                     ; $695D
    ld de, $8000                                  ; $6960
    ld bc, $0500                                  ; $6963
    call Vram_CopyFromBank                        ; $6966
    ret                                           ; $6969


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC::
    ld a, [wChoiceCursorA]                        ; $696A
    sla a                                         ; $696D
    ld c, a                                       ; $696F
    ld b, $00                                     ; $6970
    ld hl, Shoot_Options_DrawCursorC_Gfx69A8      ; $6972
    add hl, bc                                    ; $6975
    ld c, [hl]                                    ; $6976
    inc hl                                        ; $6977
    ld b, [hl]                                    ; $6978
    ld a, [wArrowAnimFrame]                       ; $6979
    cp $02                                        ; $697C
    ret z                                         ; $697E

    sla a                                         ; $697F
    push bc                                       ; $6981
    ld c, a                                       ; $6982
    ld b, $00                                     ; $6983
    ld hl, Shoot_Options_DrawCursorC_Tbl69AE      ; $6985
    add hl, bc                                    ; $6988
    ld a, [hl+]                                   ; $6989
    pop bc                                        ; $698A
    push hl                                       ; $698B
    call Oam_AddMeta_B01_4000                     ; $698C
    pop hl                                        ; $698F
    ld a, [wArrowAnimTick]                        ; $6990
    cp [hl]                                       ; $6993
    jr nz, jr_006_699e                            ; $6994

    ld hl, wArrowAnimFrame                        ; $6996
    inc [hl]                                      ; $6999
    xor a                                         ; $699A
    ld [wArrowAnimTick], a                        ; $699B

jr_006_699e:
    ld a, [wArrowAnimFrame]                       ; $699E
    and a                                         ; $69A1
    ret z                                         ; $69A2

    ld hl, wArrowAnimTick                         ; $69A3
    inc [hl]                                      ; $69A6
    ret                                           ; $69A7


; C: auto: 6 bytes, tile data; referenced by Shoot_Options_DrawCursorC. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC_Gfx69A8::
    db $10, $28, $10, $50, $10, $78

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorC. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorC_Tbl69AE::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode14_State08_OptionFlipEffect::
    call Shoot_Options_ReadKeysD                  ; $69B4
    call Shoot_Options_DrawCursorD                ; $69B7
    ldh a, [hKeysNew]                             ; $69BA
    and PADF_A | PADF_B | PADF_UP                 ; $69BC
    ret z                                         ; $69BE

    call Snd_KeyBlips                             ; $69BF
    push af                                       ; $69C2
    bit 0, a                                      ; $69C3
    call nz, Shoot_Options_RedrawArrowD           ; $69C5
    call Oam_ClearShadow                          ; $69C8
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $69CB
    ld b, $10                                     ; $69CE

jr_006_69d0:
    push bc                                       ; $69D0
    push hl                                       ; $69D1
    ldh a, [hScyShadow]                           ; $69D2
    add [hl]                                      ; $69D4
    ldh [hScyShadow], a                           ; $69D5
    cpl                                           ; $69D7
    add $64                                       ; $69D8
    ldh [hLycShadowSplit1], a                     ; $69DA
    rst Rst08_WaitVBlank                          ; $69DC
    pop hl                                        ; $69DD
    pop bc                                        ; $69DE
    inc hl                                        ; $69DF
    dec b                                         ; $69E0
    jr nz, jr_006_69d0                            ; $69E1

    pop af                                        ; $69E3
    bit 0, a                                      ; $69E4
    jr nz, jr_006_6a2c                            ; $69E6

    set_state STATE_14_OPTIONS_PAGE               ; $69E8
    ld a, [wShootEffectSel]                       ; $69ED
    call Shoot_LoadEffectGfxA                     ; $69F0
    call Shoot_SetupCapture                       ; $69F3
    call Shoot_CallVariantHandler                 ; $69F6
    ld a, [wShootVariant]                         ; $69F9
    cp $15                                        ; $69FC
    call z, Img_AndMaskTiles_Bank27               ; $69FE
    ld a, $00                                     ; $6A01
    ld hl, wPhotoImage                            ; $6A03
    ld de, $9000                                  ; $6A06
    ld bc, $0800                                  ; $6A09
    call Vram_CopyFromBank                        ; $6A0C
    ld a, $00                                     ; $6A0F
    ld hl, wPhotoImage + $800                     ; $6A11
    ld de, $8800                                  ; $6A14
    ld bc, $0100                                  ; $6A17
    call Vram_CopyFromBank                        ; $6A1A
    ld a, $00                                     ; $6A1D
    ld hl, wPhotoImage + $900                     ; $6A1F
    ld de, $8000                                  ; $6A22
    ld bc, $0500                                  ; $6A25
    call Vram_CopyFromBank                        ; $6A28
    ret                                           ; $6A2B


jr_006_6a2c:
    call Shoot_RestoreViewScreen                  ; $6A2C
    set_state STATE_14_LIVE_VIEW                  ; $6A2F
    ret                                           ; $6A34


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_Options_RedrawArrowD::
    ld hl, wArrowAnimFrame                        ; $6A35
    inc [hl]                                      ; $6A38
    call Oam_HideUnused                           ; $6A39
    rst Rst08_WaitVBlank                          ; $6A3C

jr_006_6a3d:
    call Shoot_Options_DrawCursorD                ; $6A3D
    call Oam_HideUnused                           ; $6A40
    rst Rst08_WaitVBlank                          ; $6A43
    ld a, [wArrowAnimFrame]                       ; $6A44
    cp $02                                        ; $6A47
    jr nz, jr_006_6a3d                            ; $6A49

    ld a, [wChoiceCursorA]                        ; $6A4B
    ld hl, wShootEffectSel                        ; $6A4E
    cp [hl]                                       ; $6A51
    ret z                                         ; $6A52

    ld [hl], a                                    ; $6A53
    ret                                           ; $6A54


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_ReadKeysD::
    ldh a, [hKeysNewRepeat]                       ; $6A55
    ld b, a                                       ; $6A57
    ld a, [wChoiceCursorA]                        ; $6A58
    bit 5, b                                      ; $6A5B
    jr z, jr_006_6a64                             ; $6A5D

    and a                                         ; $6A5F
    ret z                                         ; $6A60

    dec a                                         ; $6A61
    jr jr_006_6a6b                                ; $6A62

jr_006_6a64:
    bit 4, b                                      ; $6A64
    ret z                                         ; $6A66

    cp $05                                        ; $6A67
    ret z                                         ; $6A69

    inc a                                         ; $6A6A

jr_006_6a6b:
    ld [wChoiceCursorA], a                        ; $6A6B
    call Shoot_LoadEffectGfxA                     ; $6A6E
    call Snd_KeyBlips                             ; $6A71
    call Shoot_SetupCapture                       ; $6A74
    call Shoot_CallVariantHandler                 ; $6A77
    ld a, [wShootVariant]                         ; $6A7A
    cp $15                                        ; $6A7D
    call z, Img_AndMaskTiles_Bank27               ; $6A7F
    ld a, $00                                     ; $6A82
    ld hl, wPhotoImage                            ; $6A84
    ld de, $9000                                  ; $6A87
    ld bc, $0800                                  ; $6A8A
    call Vram_CopyFromBank                        ; $6A8D
    ld a, $00                                     ; $6A90
    ld hl, wPhotoImage + $800                     ; $6A92
    ld de, $8800                                  ; $6A95
    ld bc, $0100                                  ; $6A98
    call Vram_CopyFromBank                        ; $6A9B
    ld a, $00                                     ; $6A9E
    ld hl, wPhotoImage + $900                     ; $6AA0
    ld de, $8000                                  ; $6AA3
    ld bc, $0500                                  ; $6AA6
    call Vram_CopyFromBank                        ; $6AA9
    ret                                           ; $6AAC


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD::
    ld a, [wChoiceCursorA]                        ; $6AAD
    sla a                                         ; $6AB0
    ld c, a                                       ; $6AB2
    ld b, $00                                     ; $6AB3
    ld hl, Shoot_Options_DrawCursorD_Gfx6AEB      ; $6AB5
    add hl, bc                                    ; $6AB8
    ld c, [hl]                                    ; $6AB9
    inc hl                                        ; $6ABA
    ld b, [hl]                                    ; $6ABB
    ld a, [wArrowAnimFrame]                       ; $6ABC
    cp $02                                        ; $6ABF
    ret z                                         ; $6AC1

    sla a                                         ; $6AC2
    push bc                                       ; $6AC4
    ld c, a                                       ; $6AC5
    ld b, $00                                     ; $6AC6
    ld hl, Shoot_Options_DrawCursorD_Tbl6B1F      ; $6AC8
    add hl, bc                                    ; $6ACB
    ld a, [hl+]                                   ; $6ACC
    pop bc                                        ; $6ACD
    push hl                                       ; $6ACE
    call Oam_AddMeta_B01_4000                     ; $6ACF
    pop hl                                        ; $6AD2
    ld a, [wArrowAnimTick]                        ; $6AD3
    cp [hl]                                       ; $6AD6
    jr nz, jr_006_6ae1                            ; $6AD7

    ld hl, wArrowAnimFrame                        ; $6AD9
    inc [hl]                                      ; $6ADC
    xor a                                         ; $6ADD
    ld [wArrowAnimTick], a                        ; $6ADE

jr_006_6ae1:
    ld a, [wArrowAnimFrame]                       ; $6AE1
    and a                                         ; $6AE4
    ret z                                         ; $6AE5

    ld hl, wArrowAnimTick                         ; $6AE6
    inc [hl]                                      ; $6AE9
    ret                                           ; $6AEA


; C: auto: 52 bytes, tile data; referenced by Shoot_Options_DrawCursorD. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD_Gfx6AEB::
    db $80, $10, $80, $28, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90, $80, $48, $80, $60, $80, $78, $80, $90, $80, $48, $80, $60
    db $80, $78, $80, $90

; C: auto: 6 bytes, bytes; referenced by Shoot_Options_DrawCursorD. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_Options_DrawCursorD_Tbl6B1F::
    db $bc, $10, $bd, $0b, $bd, $ff

; C: mode chosen by shoot_variant
Mode14_State09_LeaveByVariant::
    ld a, [wShootVariant]                         ; $6B25
    sla a                                         ; $6B28
    ld c, a                                       ; $6B2A
    ld b, $00                                     ; $6B2B
    ld hl, Mode14_State09_LeaveByVariant_Tbl6B4A  ; $6B2D
    add hl, bc                                    ; $6B30
    ld a, [hl+]                                   ; $6B31
    ld [wMode], a                                 ; $6B32
    ld a, [hl]                                    ; $6B35
    ld [wState], a                                ; $6B36
    call Pal_FadeOut                              ; $6B39
    call Lcd_Off                                  ; $6B3C
    ld hl, hStatShadow                            ; $6B3F
    res 6, [hl]                                   ; $6B42
    ld hl, rIE                                    ; $6B44
    res 1, [hl]                                   ; $6B47
    ret                                           ; $6B49


; C: auto: 44 bytes, bytes; referenced by Mode14_State09_LeaveByVariant. L3 pass 2026-10-26: read in BGB in 62
; replay(s) of the organic corpus, modes 01 14 15 16 (tcrf_check/assets/l3_names/)
Mode14_State09_LeaveByVariant_Tbl6B4A::
    db MODE_SHOOT_PARLOR, STATE_01_INTRO, MODE_SELF_TIMER_INTERVAL, STATE_15_TIMER_INIT, MODE_SELF_TIMER_INTERVAL, STATE_15_INTERVAL_INIT, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW
    db MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW
    db MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW, MODE_SHUTTERBUG_MAGIC, STATE_16_REDRAW

; C
Shoot_LoadBurstIcons::
    ld a, [wBurstCount]                           ; $6B76
    and a                                         ; $6B79
    jr nz, jr_006_6b8b                            ; $6B7A

    farcopy Vram_CopyFromBankAuto, Gfx_17_4700_Shoot_LoadBurstIcons, $8500, $0100 ; $6B7C
    ret                                           ; $6B8A


jr_006_6b8b:
    cp $01                                        ; $6B8B
    jr nz, jr_006_6bac                            ; $6B8D

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6B8F
    farcopy Vram_CopyFromBankAuto, Gfx_17_4740_Shoot_LoadBurstIcons, $8540, $00c0 ; $6B9D
    ret                                           ; $6BAB


jr_006_6bac:
    cp $02                                        ; $6BAC
    jr nz, jr_006_6bdb                            ; $6BAE

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6BB0
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6BBE
    farcopy Vram_CopyFromBankAuto, Gfx_17_4780_Shoot_LoadBurstIcons, $8580, $0080 ; $6BCC
    ret                                           ; $6BDA


jr_006_6bdb:
    cp $03                                        ; $6BDB
    jr nz, jr_006_6c18                            ; $6BDD

    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6BDF
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6BED
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8580, $0040 ; $6BFB
    farcopy Vram_CopyFromBankAuto, Gfx_17_47C0_Shoot_LoadBurstIcons, $85c0, $0040 ; $6C09
    ret                                           ; $6C17


jr_006_6c18:
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8500, $0040 ; $6C18
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8540, $0040 ; $6C26
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $8580, $0040 ; $6C34
    farcopy Vram_CopyFromBankAuto, Gfx_17_5400_Shoot_LoadBurstIcons, $85c0, $0040 ; $6C42
    ret                                           ; $6C50


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfx::
    ld a, [wShootEffectSel]                       ; $6C51

; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfxA::
    ld c, a                                       ; $6C54
    sla a                                         ; $6C55
    sla a                                         ; $6C57
    add c                                         ; $6C59
    ld c, a                                       ; $6C5A
    ld b, $00                                     ; $6C5B
    ld hl, Shoot_LoadEffectGfxA_Tbl6C74           ; $6C5D
    add hl, bc                                    ; $6C60
    ld de, wShootFxVector                         ; $6C61
    ld a, [hl+]                                   ; $6C64
    ld [de], a                                    ; $6C65
    inc de                                        ; $6C66
    ld a, [hl+]                                   ; $6C67
    ld [de], a                                    ; $6C68
    inc de                                        ; $6C69
    ld a, [hl+]                                   ; $6C6A
    ld [de], a                                    ; $6C6B
    inc de                                        ; $6C6C
    ld a, [hl+]                                   ; $6C6D
    ld [de], a                                    ; $6C6E
    inc de                                        ; $6C6F
    ld a, [hl+]                                   ; $6C70
    ld [de], a                                    ; $6C71
    inc de                                        ; $6C72
    ret                                           ; $6C73


; C: auto: 120 bytes, bytes; referenced by Shoot_LoadEffectGfxA. L3 pass 2026-10-26: read in BGB in 72 replay(s) of
; the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_LoadEffectGfxA_Tbl6C74::
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
    call Shoot_ClearVram8900                      ; $6CEC

; C: tiles of the shoot variant (burst / timer / interval)
Shoot_LoadVariantScreen::
    ld a, [wShootVariant]                         ; $6CEF
    cp $13                                        ; $6CF2
    jr nz, jr_006_6d05                            ; $6CF4

    ld a, [wBurstCount]                           ; $6CF6
    and a                                         ; $6CF9
    jr nz, jr_006_6d01                            ; $6CFA

    call Shoot_ClearVram8900Small                 ; $6CFC
    jr jr_006_6d15                                ; $6CFF

jr_006_6d01:
    call Shoot_LoadBurstPhoto                     ; $6D01
    ret                                           ; $6D04


jr_006_6d05:
    cp $14                                        ; $6D05
    ld a, [wBurstCount]                           ; $6D07
    and a                                         ; $6D0A
    jr nz, jr_006_6d12                            ; $6D0B

    call Shoot_ClearVram8B00                      ; $6D0D
    jr jr_006_6d15                                ; $6D10

jr_006_6d12:
    call Shoot_LoadBurstPhotoB                    ; $6D12

jr_006_6d15:
    call Shoot_LoadTimerScreen                    ; $6D15
    ld a, [wShootVariant]                         ; $6D18
    cp $15                                        ; $6D1B
    call nz, Shoot_DrawPhotosLeft                 ; $6D1D
    ld a, [wShootVariant]                         ; $6D20
    and a                                         ; $6D23
    jr z, jr_006_6d2b                             ; $6D24

    cp $03                                        ; $6D26
    call c, Shoot_DrawTimerMinutes                ; $6D28

jr_006_6d2b:
    ld a, [wShootVariant]                         ; $6D2B
    cp $02                                        ; $6D2E
    call z, Shoot_DrawShotsLeftTimer              ; $6D30
    ret                                           ; $6D33


; C: $F0 tiles of $FF. L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14
; (tcrf_check/assets/l3_names/)
Shoot_ClearVram8900::
    ld hl, $ff40                                  ; $6D34
    bit 7, [hl]                                   ; $6D37
    jr nz, jr_006_6d4a                            ; $6D39

    ld hl, $8900                                  ; $6D3B
    ld a, $ff                                     ; $6D3E
    ld b, $f0                                     ; $6D40

jr_006_6d42:
    ld [hl+], a                                   ; $6D42
    ld [hl+], a                                   ; $6D43
    ld [hl+], a                                   ; $6D44
    ld [hl+], a                                   ; $6D45
    dec b                                         ; $6D46
    jr nz, jr_006_6d42                            ; $6D47

    ret                                           ; $6D49


jr_006_6d4a:
    ld a, $00                                     ; $6D4A
    ld hl, $8900                                  ; $6D4C
    ld bc, $03c0                                  ; $6D4F
    call Vram_FillFFSafe                          ; $6D52
    ret                                           ; $6D55


; C: L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_ClearVram8900Small::
    ld hl, $ff40                                  ; $6D56
    bit 7, [hl]                                   ; $6D59
    jr nz, jr_006_6d74                            ; $6D5B

    ld hl, $8900                                  ; $6D5D
    ld a, $ff                                     ; $6D60
    ld b, $02                                     ; $6D62

jr_006_6d64:
    ld c, $28                                     ; $6D64

jr_006_6d66:
    ld [hl+], a                                   ; $6D66
    ld [hl+], a                                   ; $6D67
    ld [hl+], a                                   ; $6D68
    ld [hl+], a                                   ; $6D69
    dec c                                         ; $6D6A
    jr nz, jr_006_6d66                            ; $6D6B

    ld hl, $8a00                                  ; $6D6D
    dec b                                         ; $6D70
    jr nz, jr_006_6d64                            ; $6D71

    ret                                           ; $6D73


jr_006_6d74:
    ld a, $00                                     ; $6D74
    ld hl, $8900                                  ; $6D76
    ld bc, $00a0                                  ; $6D79
    call Vram_FillFFSafe                          ; $6D7C
    ld a, $00                                     ; $6D7F
    ld hl, $8a00                                  ; $6D81
    ld bc, $00a0                                  ; $6D84
    call Vram_FillFFSafe                          ; $6D87
    ret                                           ; $6D8A


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_ClearVram8B00::
    ld hl, $ff40                                  ; $6D8B
    bit 7, [hl]                                   ; $6D8E
    jr nz, jr_006_6da1                            ; $6D90

    ld hl, $8b00                                  ; $6D92
    ld a, $ff                                     ; $6D95
    ld b, $70                                     ; $6D97

jr_006_6d99:
    ld [hl+], a                                   ; $6D99
    ld [hl+], a                                   ; $6D9A
    ld [hl+], a                                   ; $6D9B
    ld [hl+], a                                   ; $6D9C
    dec b                                         ; $6D9D
    jr nz, jr_006_6d99                            ; $6D9E

    ret                                           ; $6DA0


jr_006_6da1:
    ld a, $00                                     ; $6DA1
    ld hl, $8b00                                  ; $6DA3
    ld bc, $01c0                                  ; $6DA6
    call Vram_FillFFSafe                          ; $6DA9
    ret                                           ; $6DAC


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_LoadBurstPhoto::
    ld a, [wBurstCount]                           ; $6DAD
    dec a                                         ; $6DB0
    and $03                                       ; $6DB1
    ld c, a                                       ; $6DB3
    ld b, $00                                     ; $6DB4
    ld hl, wBurstPhotos                           ; $6DB6
    add hl, bc                                    ; $6DB9
    ld a, [hl]                                    ; $6DBA
    ldh [hFarcallAArg], a                         ; $6DBB
    farcall Photo_GetSramAddress_Far              ; $6DBD
    ld hl, $0c00                                  ; $6DC5
    add hl, bc                                    ; $6DC8
    ld de, $8900                                  ; $6DC9
    ld bc, $0200                                  ; $6DCC
    call Vram_CopyFromBankAuto                    ; $6DCF
    ret                                           ; $6DD2


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Shoot_LoadBurstPhotoB::
    ld a, [wBurstCount]                           ; $6DD3
    dec a                                         ; $6DD6
    and $03                                       ; $6DD7
    ld c, a                                       ; $6DD9
    ld b, $00                                     ; $6DDA
    ld hl, wBurstPhotos                           ; $6DDC
    add hl, bc                                    ; $6DDF
    ld a, [hl]                                    ; $6DE0
    ldh [hFarcallAArg], a                         ; $6DE1
    farcall Photo_GetSramAddress_Far              ; $6DE3
    ld hl, $00e0                                  ; $6DEB
    add hl, bc                                    ; $6DEE
    ld de, $8b00                                  ; $6DEF
    ld b, $0e                                     ; $6DF2

jr_006_6df4:
    push af                                       ; $6DF4
    push bc                                       ; $6DF5
    ld bc, $0020                                  ; $6DF6
    call Vram_CopyFromBankAuto                    ; $6DF9
    ld bc, $00e0                                  ; $6DFC
    add hl, bc                                    ; $6DFF
    pop bc                                        ; $6E00
    pop af                                        ; $6E01
    dec b                                         ; $6E02
    jr nz, jr_006_6df4                            ; $6E03

    ret                                           ; $6E05


; C: timer / counter text of the variant
Shoot_LoadTimerScreen::
    ld a, [wShootVariant]                         ; $6E06
    sla a                                         ; $6E09
    ld c, a                                       ; $6E0B
    ld b, $00                                     ; $6E0C
    ld hl, Shoot_LoadTimerScreen_Tbl6E32          ; $6E0E
    add hl, bc                                    ; $6E11
    ld a, [hl+]                                   ; $6E12
    ld h, [hl]                                    ; $6E13
    ld l, a                                       ; $6E14

jr_006_6e15:
    ld a, [hl+]                                   ; $6E15
    cp $ff                                        ; $6E16
    ret z                                         ; $6E18

    push hl                                       ; $6E19
    ld c, a                                       ; $6E1A
    ld b, [hl]                                    ; $6E1B
    inc hl                                        ; $6E1C
    push bc                                       ; $6E1D
    ld a, [hl+]                                   ; $6E1E
    ld e, [hl]                                    ; $6E1F
    inc hl                                        ; $6E20
    ld d, [hl]                                    ; $6E21
    inc hl                                        ; $6E22
    ld c, [hl]                                    ; $6E23
    inc hl                                        ; $6E24
    ld b, [hl]                                    ; $6E25
    inc hl                                        ; $6E26
    pop hl                                        ; $6E27
    call Vram_CopyFromBankAuto                    ; $6E28
    pop hl                                        ; $6E2B
    ld bc, $0006                                  ; $6E2C
    add hl, bc                                    ; $6E2F
    jr jr_006_6e15                                ; $6E30

; C: auto: 514 bytes, bytes; referenced by Shoot_LoadTimerScreen | 22 words 6E5E, 6E6D, 6E8A ... 70A3 (the last two
; words of the old reading, 4180 and A017, belong to the next bytes); the lists they point to run from 6E5E to 70B2
; (the labels at 7034 and 706C were `ld bc` sprite positions of ...
Shoot_LoadTimerScreen_Tbl6E32::
    dw $6e5e
    dw $6e6d
    dw $6e8a
    dw $6eb5
    dw $6ed2
    dw $6eef
    dw $6f0c
    dw $6f29
    dw $6f46
    dw $6f63
    dw $6f80
    dw $6f9d
    dw $6fba
    dw $6fd7
    dw $6ff4
    dw $7011
    dw $702e
    dw $704b
    dw $7068
    dw $7085
    dw $7094
    dw $70a3

    db $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $ff, $80
    db $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $40, $41, $17
    db $50, $89, $20, $00, $60, $41, $17, $50, $8a, $20, $00, $ff, $80, $41, $17, $a0
    db $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $40, $41, $17, $50, $89, $20
    db $00, $60, $41, $17, $50, $8a, $20, $00, $00, $42, $17, $00, $89, $20, $00, $20
    db $42, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41
    db $17, $a0, $8a, $40, $00, $40, $42, $17, $00, $89, $20, $00, $60, $42, $17, $00
    db $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a
    db $40, $00, $80, $42, $17, $00, $89, $20, $00, $a0, $42, $17, $00, $8a, $20, $00
    db $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $c0
    db $42, $17, $00, $89, $20, $00, $e0, $42, $17, $00, $8a, $20, $00, $ff, $80, $41
    db $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $00, $43, $17, $00
    db $89, $20, $00, $20, $43, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89
    db $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $40, $43, $17, $00, $89, $20, $00
    db $60, $43, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0
    db $41, $17, $a0, $8a, $40, $00, $80, $43, $17, $00, $89, $20, $00, $a0, $43, $17
    db $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0
    db $8a, $40, $00, $c0, $43, $17, $00, $89, $20, $00, $e0, $43, $17, $00, $8a, $20
    db $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00
    db $00, $44, $17, $00, $89, $20, $00, $20, $44, $17, $00, $8a, $20, $00, $ff, $80
    db $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $40, $44, $17
    db $00, $89, $20, $00, $60, $44, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0
    db $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $80, $44, $17, $00, $89, $20
    db $00, $a0, $44, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00
    db $c0, $41, $17, $a0, $8a, $40, $00, $c0, $44, $17, $00, $89, $20, $00, $e0, $44
    db $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17
    db $a0, $8a, $40, $00, $00, $45, $17, $00, $89, $20, $00, $20, $45, $17, $00, $8a
    db $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40
    db $00, $40, $45, $17, $00, $89, $20, $00, $60, $45, $17, $00, $8a, $20, $00, $ff
    db $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $80, $45
    db $17, $00, $89, $20, $00, $a0, $45, $17, $00, $8a, $20, $00, $ff, $80, $41, $17
    db $a0, $89, $40, $00, $c0, $41, $17, $a0, $8a, $40, $00, $c0, $45, $17, $00, $89
    db $20, $00, $e0, $45, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40
    db $00, $c0, $41, $17, $a0, $8a, $40, $00, $00, $46, $17, $00, $89, $20, $00, $20
    db $46, $17, $00, $8a, $20, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41
    db $17, $a0, $8a, $40, $00, $ff, $80, $41, $17, $a0, $89, $40, $00, $c0, $41, $17
    db $a0, $8a, $40, $00, $ff, $40, $46, $17, $00, $89, $20, $00, $60, $46, $17, $00
    db $8a, $20, $00, $ff

; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawPhotosLeft::
    ld a, [wPhotoCount]                           ; $70B2
    cpl                                           ; $70B5
    add $1f                                       ; $70B6
    ld c, $00                                     ; $70B8

jr_006_70ba:
    cp $0a                                        ; $70BA
    jr c, jr_006_70c3                             ; $70BC

    sub $0a                                       ; $70BE
    inc c                                         ; $70C0
    jr jr_006_70ba                                ; $70C1

jr_006_70c3:
    ld de, $89e0                                  ; $70C3
    call Shoot_DrawTwoDigitsAt                    ; $70C6
    ret                                           ; $70C9


; C: L3 pass 2026-10-26: executed in BGB in 21 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTimerMinutes::
    ld a, [wTimerMinutes]                         ; $70CA
    and a                                         ; $70CD
    jr nz, jr_006_70e3                            ; $70CE

    farcopy Vram_CopyFromBankAuto, Gfx_17_4950_Shoot_DrawTimerMinutes, $8a90, $0010 ; $70D0
    ld a, [wTimerSeconds]                         ; $70DE
    jr jr_006_70f4                                ; $70E1

jr_006_70e3:
    farcopy Vram_CopyFromBankAuto, Gfx_17_4BE0_Shoot_DrawTimerMinutes, $8a90, $0010 ; $70E3
    ld a, [wTimerMinutes]                         ; $70F1

jr_006_70f4:
    ld c, $00                                     ; $70F4

jr_006_70f6:
    cp $0a                                        ; $70F6
    jr c, jr_006_70ff                             ; $70F8

    sub $0a                                       ; $70FA
    inc c                                         ; $70FC
    jr jr_006_70f6                                ; $70FD

jr_006_70ff:
    ld de, $8970                                  ; $70FF
    call Shoot_DrawTwoDigitsAt                    ; $7102
    ret                                           ; $7105


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawShotsLeftTimer::
    ld a, [wShotsLeft]                            ; $7106
    ld c, $00                                     ; $7109

jr_006_710b:
    cp $0a                                        ; $710B
    jr c, jr_006_7114                             ; $710D

    sub $0a                                       ; $710F
    inc c                                         ; $7111
    jr jr_006_710b                                ; $7112

jr_006_7114:
    ld de, $8920                                  ; $7114
    call Shoot_DrawTwoDigitsAt                    ; $7117
    ret                                           ; $711A


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawTwoDigitsAt::
    push af                                       ; $711B
    ld a, c                                       ; $711C
    call Shoot_DrawDigitAt                        ; $711D
    pop af                                        ; $7120
    call Shoot_DrawDigitAt                        ; $7121
    ret                                           ; $7124


; C: L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_DrawDigitAt::
    ld c, a                                       ; $7125
    ld b, $00                                     ; $7126
    swap c                                        ; $7128
    sla c                                         ; $712A
    rl b                                          ; $712C
    ld hl, Mode15_SelfTimerInterval               ; $712E
    add hl, bc                                    ; $7131
    ld a, $17                                     ; $7132
    ld bc, $0010                                  ; $7134
    push de                                       ; $7137
    call Shoot_CopyTileSafe                       ; $7138
    pop de                                        ; $713B
    inc d                                         ; $713C
    ld a, $17                                     ; $713D
    ld bc, $0010                                  ; $713F
    call Shoot_CopyTileSafe                       ; $7142
    dec d                                         ; $7145
    ret                                           ; $7146


; C: copies when the LCD is on; safe copy otherwise. L3 pass 2026-10-26: executed in BGB in 72 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_CopyTileSafe::
    push hl                                       ; $7147
    ld hl, $ff40                                  ; $7148
    bit 7, [hl]                                   ; $714B
    jr nz, jr_006_7154                            ; $714D

    pop hl                                        ; $714F
    call Mem_CopyFromBank                         ; $7150
    ret                                           ; $7153


jr_006_7154:
    pop hl                                        ; $7154
    call Vram_CopyFromBank                        ; $7155
    ret                                           ; $7158


; C: timer frames / seconds / minutes / beep accumulator = 0
Shoot_ResetTimer::
    xor a                                         ; $7159
    ld [wTimerFrames], a                          ; $715A
    ld [wTimerSeconds], a                         ; $715D
    ld [wTimerMinutes], a                         ; $7160
    ld [wTimerBeepAcc], a                         ; $7163
    ld a, [wShootVariant]                         ; $7166
    cp $02                                        ; $7169
    jr z, jr_006_7174                             ; $716B

    ld a, [wSelftimerDelay]                       ; $716D
    ld [wTimerSeconds], a                         ; $7170
    ret                                           ; $7173


jr_006_7174:
    ld a, [wIntervalIndex]                        ; $7174
    cp $19                                        ; $7177
    jr c, jr_006_7189                             ; $7179

    sub $19                                       ; $717B
    ld c, a                                       ; $717D
    ld b, $00                                     ; $717E
    ld hl, Shoot_ResetTimer_Tbl7199               ; $7180
    add hl, bc                                    ; $7183
    ld a, [hl]                                    ; $7184
    ld [wTimerMinutes], a                         ; $7185
    ret                                           ; $7188


jr_006_7189:
    cp $0f                                        ; $7189
    jr c, jr_006_7195                             ; $718B

    ld c, a                                       ; $718D
    sla a                                         ; $718E
    sla a                                         ; $7190
    add c                                         ; $7192
    sub $3c                                       ; $7193

jr_006_7195:
    ld [wTimerSeconds], a                         ; $7195
    ret                                           ; $7198


; C: auto: 5 bytes, bytes; referenced by Shoot_ResetTimer. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 14)
Shoot_ResetTimer_Tbl7199::
    db $05, $0a, $0f, $1e, $3c

; C: L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_SetCaptureMode::
    ld a, [wShootVariant]                         ; $719E
    ld c, $01                                     ; $71A1
    cp $0c                                        ; $71A3
    jr z, jr_006_71e4                             ; $71A5

    cp $0d                                        ; $71A7
    jr z, jr_006_71e4                             ; $71A9

    cp $0e                                        ; $71AB
    jr z, jr_006_71e4                             ; $71AD

    cp $10                                        ; $71AF
    jr z, jr_006_71e4                             ; $71B1

    cp $12                                        ; $71B3
    jr z, jr_006_71e4                             ; $71B5

    ld c, $02                                     ; $71B7
    cp $11                                        ; $71B9
    jr z, jr_006_71e4                             ; $71BB

    ld c, $03                                     ; $71BD
    cp $0b                                        ; $71BF
    jr z, jr_006_71e4                             ; $71C1

    cp $0f                                        ; $71C3
    jr z, jr_006_71e4                             ; $71C5

    cp $15                                        ; $71C7
    jr z, jr_006_71e4                             ; $71C9

    ret                                           ; $71CB


; I: UNREFERENCED
Unused_Shoot_TimerKeys::
    ldh a, [hVblankCounter]                       ; $71CC
    ld hl, wTimerLastVbl                          ; $71CE
    sub [hl]                                      ; $71D1
    sub $0f                                       ; $71D2
    ret c                                         ; $71D4

    ld c, a                                       ; $71D5
    ldh a, [hVblankCounter]                       ; $71D6
    sub c                                         ; $71D8
    ld [hl], a                                    ; $71D9
    ld a, [wShootPhase]                           ; $71DA
    inc a                                         ; $71DD
    and $03                                       ; $71DE
    ld [wShootPhase], a                           ; $71E0
    ret                                           ; $71E3


jr_006_71e4:
    ldh a, [hKeysNewSticky]                       ; $71E4
    ld b, a                                       ; $71E6
    ld a, [wShootPhase]                           ; $71E7
    bit 1, b                                      ; $71EA
    jr z, jr_006_71fa                             ; $71EC

    and a                                         ; $71EE
    ret z                                         ; $71EF

    push af                                       ; $71F0
    ld a, SFX1_KEY_B                              ; $71F1
    call Snd_Sfx1                                 ; $71F3
    pop af                                        ; $71F6
    dec a                                         ; $71F7
    jr jr_006_7205                                ; $71F8

jr_006_71fa:
    bit 0, b                                      ; $71FA
    ret z                                         ; $71FC

    cp c                                          ; $71FD
    ret z                                         ; $71FE

    push af                                       ; $71FF
    call Shoot_PlayShutterSound                   ; $7200
    pop af                                        ; $7203
    inc a                                         ; $7204

jr_006_7205:
    ld [wShootPhase], a                           ; $7205
    xor a                                         ; $7208
    ldh [hKeysNewSticky], a                       ; $7209
    ldh [hKeysNew], a                             ; $720B
    ret                                           ; $720D


; C: counts frames; seconds; minutes and plays the beeps
Shoot_TimerTick::
    ld a, [wTimerRunning]                         ; $720E
    and a                                         ; $7211
    ret z                                         ; $7212

    ldh a, [hVblankCounter]                       ; $7213
    push af                                       ; $7215
    ld hl, wTimerLastVbl                          ; $7216
    sub [hl]                                      ; $7219
    ld c, a                                       ; $721A
    pop af                                        ; $721B
    ld [hl], a                                    ; $721C
    ld hl, wTimerFrames                           ; $721D
    ld a, [hl+]                                   ; $7220
    or [hl]                                       ; $7221
    inc hl                                        ; $7222
    or [hl]                                       ; $7223
    ret z                                         ; $7224

    ld a, [wTimerBeepAcc]                         ; $7225
    add c                                         ; $7228
    cp $0f                                        ; $7229
    jr c, jr_006_7235                             ; $722B

    push af                                       ; $722D
    ld a, SFX1_BEEP_REFUSED                       ; $722E
    call Snd_Sfx1                                 ; $7230
    pop af                                        ; $7233
    xor a                                         ; $7234

jr_006_7235:
    ld [wTimerBeepAcc], a                         ; $7235
    ld hl, wTimerFrames                           ; $7238
    ld a, [hl]                                    ; $723B
    sub c                                         ; $723C
    ld [hl], a                                    ; $723D
    ret nc                                        ; $723E

    add $3c                                       ; $723F
    ld [hl+], a                                   ; $7241
    dec [hl]                                      ; $7242
    bit 7, [hl]                                   ; $7243
    ret z                                         ; $7245

    ld a, [hl]                                    ; $7246
    add $3c                                       ; $7247
    ld [hl+], a                                   ; $7249
    dec [hl]                                      ; $724A
    bit 7, [hl]                                   ; $724B
    ret z                                         ; $724D

    xor a                                         ; $724E
    ld [wTimerFrames], a                          ; $724F
    ld [wTimerSeconds], a                         ; $7252
    ld [wTimerMinutes], a                         ; $7255
    ret                                           ; $7258


; C
Mode14_State0A_ResultPrepare::
    call Pal_FadeOut                              ; $7259
    call Lcd_Off                                  ; $725C
    ld hl, hStatShadow                            ; $725F
    res 6, [hl]                                   ; $7262
    ld hl, rIE                                    ; $7264
    res 1, [hl]                                   ; $7267
    xor a                                         ; $7269
    ld [wSubstate], a                             ; $726A
    ld a, $0d                                     ; $726D
    ld [wResultMsgId], a                          ; $726F
    next_state                                    ; $7272
    ret                                           ; $7276


; C: far call 09:7290
Mode14_State0B_ResultScreen::
    ldh [hFarcallAArg], a                         ; $7277
    farcall ResultScreen_Far                      ; $7279
    ret                                           ; $7281


; C
Mode14_State0C_Reinit::
    xor a                                         ; $7282
    ld [wTimerRunning], a                         ; $7283
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7286
    ldh [hLcdcShadow], a                          ; $7288
    ld a, $e4                                     ; $728A
    ld [wPaletteTarget], a                        ; $728C
    ld [wPaletteTarget + $1], a                   ; $728F
    ld a, $d2                                     ; $7292
    ld [wPaletteTarget + $2], a                   ; $7294
    ld a, $10                                     ; $7297
    ldh [hScxShadow], a                           ; $7299
    ldh [hScyShadow], a                           ; $729B
    ld hl, wPhotoImage                            ; $729D
    ld bc, $0e00                                  ; $72A0
    call Mem_Zero                                 ; $72A3
    ld hl, $8000                                  ; $72A6
    ld bc, $0500                                  ; $72A9
    call Mem_Zero                                 ; $72AC
    ld hl, $8800                                  ; $72AF
    ld bc, $0100                                  ; $72B2
    call Mem_Zero                                 ; $72B5
    ld hl, $9000                                  ; $72B8
    ld bc, $0800                                  ; $72BB
    call Mem_Zero                                 ; $72BE
    farcopy Mem_CopyFromBank, Gfx_17_4980_Mode17_State08_Split_Build, $8cc0, $0260 ; $72C1
    farcopy Mem_CopyFromBank, Gfx_17_5440_Mode14_State00_Init, $8f20, $00a0 ; $72CF
    farcopy Mem_CopyFromBank, Gfx_17_4940_Mode14_State00_Init, $8fd0, $0020 ; $72DD
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $72EB
    farcopy Mem_CopyFromBank, Gfx_17_4140_Mode14_State00_Init, $8a00, $0040 ; $72F9
    farcopy Mem_CopyFromBank, Gfx_17_4180_Mode14_State00_Init, $8a40, $0080 ; $7307
    farcopy Mem_CopyFromBank, Gfx_17_4960_Mode14_State00_Init, $86e0, $0020 ; $7315
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8600, $0080 ; $7323
    farcopy Mem_CopyFromBank, Gfx_17_54E0_Mode14_State00_Init, $8740, $0020 ; $7331
    farcopy Mem_CopyFromBank, Map_25_47C0_Mode14_State0C_Reinit, $9800, $02c0 ; $733F
    ld hl, $9ac0                                  ; $734D
    ld bc, $0140                                  ; $7350
    ld a, $ff                                     ; $7353
    call Mem_FillBc1                              ; $7355
    call Shoot_LoadBurstIcons                     ; $7358
    call Shoot_LoadEffectGfx                      ; $735B
    call Shoot_ClearEffectTiles                   ; $735E
    ld a, $54                                     ; $7361
    ldh [hLycShadowSplit1], a                     ; $7363
    ldh [hSplit1Latch], a                         ; $7365
    ld hl, hStatShadow                            ; $7367
    set 6, [hl]                                   ; $736A
    ld hl, rIE                                    ; $736C
    set 1, [hl]                                   ; $736F
    ld a, $01                                     ; $7371
    ldh [hStatHandlerIndex], a                    ; $7373
    call Oam_ClearShadow                          ; $7375
    call Pal_AllWhite                             ; $7378
    call Lcd_On                                   ; $737B
    push af                                       ; $737E
    ld a, MUSIC_STOP                              ; $737F
    call Snd_Music                                ; $7381
    pop af                                        ; $7384
    rst Rst08_WaitVBlank                          ; $7385
    call Pal_FadeIn                               ; $7386
    set_state STATE_14_LIVE_VIEW                  ; $7389
    ret                                           ; $738E


; C: jump through the shoot_variant table at 73EF
Shoot_CallVariantHandler::
    ld a, [wShootVariant]                         ; $738F
    sla a                                         ; $7392
    sla a                                         ; $7394
    ld hl, wShootPhase                            ; $7396
    add [hl]                                      ; $7399
    ld c, a                                       ; $739A
    ld b, $00                                     ; $739B
    ld hl, Shoot_CallVariantHandler_Tbl60DB       ; $739D
    add hl, bc                                    ; $73A0
    ld a, [hl]                                    ; $73A1
    sla a                                         ; $73A2
    ld c, a                                       ; $73A4
    ld b, $00                                     ; $73A5
    ld hl, Shoot_FxHandlerTbl                     ; $73A7
    add hl, bc                                    ; $73AA
    ld a, [hl+]                                   ; $73AB
    ld h, [hl]                                    ; $73AC
    ld l, a                                       ; $73AD
    jp hl                                         ; $73AE


; C: 40 code pointers indexed by shoot_variant * 4 + shoot_phase
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
    ld hl, wPhotoImage                            ; $73EF
    ld a, $0e                                     ; $73F2
    jp Shoot_FxXorRowsBody                        ; $73F4


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion01::
    ld hl, wPhotoImage                            ; $73F7
    ld a, $07                                     ; $73FA
    jp Shoot_FxXorBlockBody                       ; $73FC


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion02::
    ld hl, wPhotoImage + $80                      ; $73FF
    ld a, $07                                     ; $7402
    jp Shoot_FxXorBlockBody                       ; $7404


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion03::
    ld hl, wEffRegionRow7                         ; $7407
    ld a, $07                                     ; $740A
    jp Shoot_FxXorBlockBody                       ; $740C


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion04::
    ld hl, wEffRegionRow7Right                    ; $740F
    ld a, $07                                     ; $7412
    jp Shoot_FxXorBlockBody                       ; $7414


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion05::
    ld hl, wPhotoImage                            ; $7417
    ld a, $0e                                     ; $741A
    jp Shoot_FxXorBlockBody                       ; $741C


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion06::
    ld hl, wPhotoImage + $80                      ; $741F
    ld a, $0e                                     ; $7422
    jp Shoot_FxXorBlockBody                       ; $7424


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion07::
    ld hl, wPhotoImage                            ; $7427
    ld a, $07                                     ; $742A
    jp Shoot_FxXorRowsBody                        ; $742C


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion08::
    ld hl, wEffRegionRow7                         ; $742F
    ld a, $07                                     ; $7432
    jp Shoot_FxXorRowsBody                        ; $7434


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion09::
    ld hl, wPhotoImage + $80                      ; $7437
    ld a, $07                                     ; $743A
    call Shoot_FxXorBlockBody                     ; $743C
    ld hl, wEffRegionRow7                         ; $743F
    ld a, $07                                     ; $7442
    jp Shoot_FxXorBlockBody                       ; $7444


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0A::
    ld hl, wPhotoImage + $80                      ; $7447
    ld a, $07                                     ; $744A
    call Shoot_FxXorBlockBody                     ; $744C
    ld hl, wEffRegionRow7                         ; $744F
    ld a, $07                                     ; $7452
    jp Shoot_FxXorRowsBody                        ; $7454


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0B::
    ld hl, wPhotoImage                            ; $7457
    ld a, $0a                                     ; $745A
    jp Shoot_FxXorRowsBody                        ; $745C


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0C::
    ld hl, wEffRegionRow10                        ; $745F
    ld a, $04                                     ; $7462
    jp Shoot_FxXorRowsBody                        ; $7464


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0D::
    ld hl, wPhotoImage                            ; $7467
    ld a, $04                                     ; $746A
    jp Shoot_FxXorRowsBody                        ; $746C


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0E::
    ld hl, wEffRegionRow4                         ; $746F
    ld a, $0a                                     ; $7472
    jp Shoot_FxXorRowsBody                        ; $7474


; C: entry that sets HL / A and runs the region routine (README: region-entry list 06:73EF-7477)
Shoot_FxRegion0F::
    ld hl, wEffRegionTile33                       ; $7477
    ld a, $08                                     ; $747A
    jp Shoot_FxMaskBlockBody                      ; $747C


; C: ret; then at 7480 the row-wise XOR with shoot_fx_vector over A tile rows (shared body)
Shoot_FxXorRows::
    ret                                           ; $747F


; C: XORs the 16-bit mask shoot_fx_vector over A tile rows at HL
Shoot_FxXorRowsBody::
    swap a                                        ; $7480
    ldh [hScratchA], a                            ; $7482
    ld a, [wShootFxVector]                        ; $7484
    ld c, a                                       ; $7487
    ld a, [wShootFxVector + $1]                   ; $7488
    ld b, a                                       ; $748B
    or c                                          ; $748C
    jr z, jr_006_74c7                             ; $748D

    push hl                                       ; $748F
    ldh a, [hScratchA]                            ; $7490
    ld e, a                                       ; $7492

jr_006_7493:
    ld a, [hl]                                    ; $7493
    xor c                                         ; $7494
    ld [hl+], a                                   ; $7495
    ld a, [hl]                                    ; $7496
    xor b                                         ; $7497
    ld [hl+], a                                   ; $7498
    ld a, [hl]                                    ; $7499
    xor c                                         ; $749A
    ld [hl+], a                                   ; $749B
    ld a, [hl]                                    ; $749C
    xor b                                         ; $749D
    ld [hl+], a                                   ; $749E
    ld a, [hl]                                    ; $749F
    xor c                                         ; $74A0
    ld [hl+], a                                   ; $74A1
    ld a, [hl]                                    ; $74A2
    xor b                                         ; $74A3
    ld [hl+], a                                   ; $74A4
    ld a, [hl]                                    ; $74A5
    xor c                                         ; $74A6
    ld [hl+], a                                   ; $74A7
    ld a, [hl]                                    ; $74A8
    xor b                                         ; $74A9
    ld [hl+], a                                   ; $74AA
    ld a, [hl]                                    ; $74AB
    xor c                                         ; $74AC
    ld [hl+], a                                   ; $74AD
    ld a, [hl]                                    ; $74AE
    xor b                                         ; $74AF
    ld [hl+], a                                   ; $74B0
    ld a, [hl]                                    ; $74B1
    xor c                                         ; $74B2
    ld [hl+], a                                   ; $74B3
    ld a, [hl]                                    ; $74B4
    xor b                                         ; $74B5
    ld [hl+], a                                   ; $74B6
    ld a, [hl]                                    ; $74B7
    xor c                                         ; $74B8
    ld [hl+], a                                   ; $74B9
    ld a, [hl]                                    ; $74BA
    xor b                                         ; $74BB
    ld [hl+], a                                   ; $74BC
    ld a, [hl]                                    ; $74BD
    xor c                                         ; $74BE
    ld [hl+], a                                   ; $74BF
    ld a, [hl]                                    ; $74C0
    xor b                                         ; $74C1
    ld [hl+], a                                   ; $74C2
    dec e                                         ; $74C3
    jr nz, jr_006_7493                            ; $74C4

    pop hl                                        ; $74C6

jr_006_74c7:
    ld a, [wShootFxVector + $2]                   ; $74C7
    ld c, a                                       ; $74CA
    ld a, [wShootFxVector + $3]                   ; $74CB
    ld b, a                                       ; $74CE
    or c                                          ; $74CF
    jr z, jr_006_752e                             ; $74D0

    push hl                                       ; $74D2
    inc hl                                        ; $74D3
    ldh a, [hScratchA]                            ; $74D4
    ld e, a                                       ; $74D6

jr_006_74d7:
    ld a, [hl-]                                   ; $74D7
    and c                                         ; $74D8
    ld d, a                                       ; $74D9
    xor [hl]                                      ; $74DA
    ld [hl+], a                                   ; $74DB
    xor d                                         ; $74DC
    and b                                         ; $74DD
    xor [hl]                                      ; $74DE
    ld [hl+], a                                   ; $74DF
    inc l                                         ; $74E0
    ld a, [hl-]                                   ; $74E1
    and c                                         ; $74E2
    ld d, a                                       ; $74E3
    xor [hl]                                      ; $74E4
    ld [hl+], a                                   ; $74E5
    xor d                                         ; $74E6
    and b                                         ; $74E7
    xor [hl]                                      ; $74E8
    ld [hl+], a                                   ; $74E9
    inc l                                         ; $74EA
    ld a, [hl-]                                   ; $74EB
    and c                                         ; $74EC
    ld d, a                                       ; $74ED
    xor [hl]                                      ; $74EE
    ld [hl+], a                                   ; $74EF
    xor d                                         ; $74F0
    and b                                         ; $74F1
    xor [hl]                                      ; $74F2
    ld [hl+], a                                   ; $74F3
    inc l                                         ; $74F4
    ld a, [hl-]                                   ; $74F5
    and c                                         ; $74F6
    ld d, a                                       ; $74F7
    xor [hl]                                      ; $74F8
    ld [hl+], a                                   ; $74F9
    xor d                                         ; $74FA
    and b                                         ; $74FB
    xor [hl]                                      ; $74FC
    ld [hl+], a                                   ; $74FD
    inc l                                         ; $74FE
    ld a, [hl-]                                   ; $74FF
    and c                                         ; $7500
    ld d, a                                       ; $7501
    xor [hl]                                      ; $7502
    ld [hl+], a                                   ; $7503
    xor d                                         ; $7504
    and b                                         ; $7505
    xor [hl]                                      ; $7506
    ld [hl+], a                                   ; $7507
    inc l                                         ; $7508
    ld a, [hl-]                                   ; $7509
    and c                                         ; $750A
    ld d, a                                       ; $750B
    xor [hl]                                      ; $750C
    ld [hl+], a                                   ; $750D
    xor d                                         ; $750E
    and b                                         ; $750F
    xor [hl]                                      ; $7510
    ld [hl+], a                                   ; $7511
    inc l                                         ; $7512
    ld a, [hl-]                                   ; $7513
    and c                                         ; $7514
    ld d, a                                       ; $7515
    xor [hl]                                      ; $7516
    ld [hl+], a                                   ; $7517
    xor d                                         ; $7518
    and b                                         ; $7519
    xor [hl]                                      ; $751A
    ld [hl+], a                                   ; $751B
    inc l                                         ; $751C
    ld a, [hl-]                                   ; $751D
    and c                                         ; $751E
    ld d, a                                       ; $751F
    xor [hl]                                      ; $7520
    ld [hl+], a                                   ; $7521
    xor d                                         ; $7522
    and b                                         ; $7523
    xor [hl]                                      ; $7524
    ld [hl+], a                                   ; $7525
    inc l                                         ; $7526
    jr nz, jr_006_752a                            ; $7527

    inc h                                         ; $7529

jr_006_752a:
    dec e                                         ; $752A
    jr nz, jr_006_74d7                            ; $752B

    pop hl                                        ; $752D

jr_006_752e:
    ld a, [wShootFxVector + $4]                   ; $752E
    ld c, a                                       ; $7531
    and a                                         ; $7532
    ret z                                         ; $7533

    inc hl                                        ; $7534
    ldh a, [hScratchA]                            ; $7535
    ld e, a                                       ; $7537

jr_006_7538:
    ld a, [hl-]                                   ; $7538
    xor [hl]                                      ; $7539
    and c                                         ; $753A
    ld d, a                                       ; $753B
    xor [hl]                                      ; $753C
    ld [hl+], a                                   ; $753D
    ld a, d                                       ; $753E
    xor [hl]                                      ; $753F
    ld [hl+], a                                   ; $7540
    inc l                                         ; $7541
    ld a, [hl-]                                   ; $7542
    xor [hl]                                      ; $7543
    and c                                         ; $7544
    ld d, a                                       ; $7545
    xor [hl]                                      ; $7546
    ld [hl+], a                                   ; $7547
    ld a, d                                       ; $7548
    xor [hl]                                      ; $7549
    ld [hl+], a                                   ; $754A
    inc l                                         ; $754B
    ld a, [hl-]                                   ; $754C
    xor [hl]                                      ; $754D
    and c                                         ; $754E
    ld d, a                                       ; $754F
    xor [hl]                                      ; $7550
    ld [hl+], a                                   ; $7551
    ld a, d                                       ; $7552
    xor [hl]                                      ; $7553
    ld [hl+], a                                   ; $7554
    inc l                                         ; $7555
    ld a, [hl-]                                   ; $7556
    xor [hl]                                      ; $7557
    and c                                         ; $7558
    ld d, a                                       ; $7559
    xor [hl]                                      ; $755A
    ld [hl+], a                                   ; $755B
    ld a, d                                       ; $755C
    xor [hl]                                      ; $755D
    ld [hl+], a                                   ; $755E
    inc l                                         ; $755F
    ld a, [hl-]                                   ; $7560
    xor [hl]                                      ; $7561
    and c                                         ; $7562
    ld d, a                                       ; $7563
    xor [hl]                                      ; $7564
    ld [hl+], a                                   ; $7565
    ld a, d                                       ; $7566
    xor [hl]                                      ; $7567
    ld [hl+], a                                   ; $7568
    inc l                                         ; $7569
    ld a, [hl-]                                   ; $756A
    xor [hl]                                      ; $756B
    and c                                         ; $756C
    ld d, a                                       ; $756D
    xor [hl]                                      ; $756E
    ld [hl+], a                                   ; $756F
    ld a, d                                       ; $7570
    xor [hl]                                      ; $7571
    ld [hl+], a                                   ; $7572
    inc l                                         ; $7573
    ld a, [hl-]                                   ; $7574
    xor [hl]                                      ; $7575
    and c                                         ; $7576
    ld d, a                                       ; $7577
    xor [hl]                                      ; $7578
    ld [hl+], a                                   ; $7579
    ld a, d                                       ; $757A
    xor [hl]                                      ; $757B
    ld [hl+], a                                   ; $757C
    inc l                                         ; $757D
    ld a, [hl-]                                   ; $757E
    xor [hl]                                      ; $757F
    and c                                         ; $7580
    ld d, a                                       ; $7581
    xor [hl]                                      ; $7582
    ld [hl+], a                                   ; $7583
    ld a, d                                       ; $7584
    xor [hl]                                      ; $7585
    ld [hl+], a                                   ; $7586
    inc l                                         ; $7587
    jr nz, jr_006_758b                            ; $7588

    inc h                                         ; $758A

jr_006_758b:
    dec e                                         ; $758B
    jr nz, jr_006_7538                            ; $758C

    ret                                           ; $758E


; C: same over a block of 8 tiles
Shoot_FxXorBlockBody::
    ldh [hScratchA], a                            ; $758F
    ld a, [wShootFxVector]                        ; $7591
    ld c, a                                       ; $7594
    ld a, [wShootFxVector + $1]                   ; $7595
    ld b, a                                       ; $7598
    or c                                          ; $7599
    jr z, jr_006_75e0                             ; $759A

    push hl                                       ; $759C
    ldh a, [hScratchA]                            ; $759D

jr_006_759f:
    ldh [hScratchB], a                            ; $759F
    ld e, $08                                     ; $75A1

jr_006_75a3:
    ld a, [hl]                                    ; $75A3
    xor c                                         ; $75A4
    ld [hl+], a                                   ; $75A5
    ld a, [hl]                                    ; $75A6
    xor b                                         ; $75A7
    ld [hl+], a                                   ; $75A8
    ld a, [hl]                                    ; $75A9
    xor c                                         ; $75AA
    ld [hl+], a                                   ; $75AB
    ld a, [hl]                                    ; $75AC
    xor b                                         ; $75AD
    ld [hl+], a                                   ; $75AE
    ld a, [hl]                                    ; $75AF
    xor c                                         ; $75B0
    ld [hl+], a                                   ; $75B1
    ld a, [hl]                                    ; $75B2
    xor b                                         ; $75B3
    ld [hl+], a                                   ; $75B4
    ld a, [hl]                                    ; $75B5
    xor c                                         ; $75B6
    ld [hl+], a                                   ; $75B7
    ld a, [hl]                                    ; $75B8
    xor b                                         ; $75B9
    ld [hl+], a                                   ; $75BA
    ld a, [hl]                                    ; $75BB
    xor c                                         ; $75BC
    ld [hl+], a                                   ; $75BD
    ld a, [hl]                                    ; $75BE
    xor b                                         ; $75BF
    ld [hl+], a                                   ; $75C0
    ld a, [hl]                                    ; $75C1
    xor c                                         ; $75C2
    ld [hl+], a                                   ; $75C3
    ld a, [hl]                                    ; $75C4
    xor b                                         ; $75C5
    ld [hl+], a                                   ; $75C6
    ld a, [hl]                                    ; $75C7
    xor c                                         ; $75C8
    ld [hl+], a                                   ; $75C9
    ld a, [hl]                                    ; $75CA
    xor b                                         ; $75CB
    ld [hl+], a                                   ; $75CC
    ld a, [hl]                                    ; $75CD
    xor c                                         ; $75CE
    ld [hl+], a                                   ; $75CF
    ld a, [hl]                                    ; $75D0
    xor b                                         ; $75D1
    ld [hl+], a                                   ; $75D2
    dec e                                         ; $75D3
    jr nz, jr_006_75a3                            ; $75D4

    ld de, $0080                                  ; $75D6
    add hl, de                                    ; $75D9
    ldh a, [hScratchB]                            ; $75DA
    dec a                                         ; $75DC
    jr nz, jr_006_759f                            ; $75DD

    pop hl                                        ; $75DF

jr_006_75e0:
    ld a, [wShootFxVector + $2]                   ; $75E0
    ld c, a                                       ; $75E3
    ld a, [wShootFxVector + $3]                   ; $75E4
    ld b, a                                       ; $75E7
    or c                                          ; $75E8
    jr z, jr_006_7653                             ; $75E9

    push hl                                       ; $75EB
    inc hl                                        ; $75EC
    ldh a, [hScratchA]                            ; $75ED

jr_006_75ef:
    ldh [hScratchB], a                            ; $75EF
    ld e, $08                                     ; $75F1

jr_006_75f3:
    ld a, [hl-]                                   ; $75F3
    and c                                         ; $75F4
    ld d, a                                       ; $75F5
    xor [hl]                                      ; $75F6
    ld [hl+], a                                   ; $75F7
    xor d                                         ; $75F8
    and b                                         ; $75F9
    xor [hl]                                      ; $75FA
    ld [hl+], a                                   ; $75FB
    inc l                                         ; $75FC
    ld a, [hl-]                                   ; $75FD
    and c                                         ; $75FE
    ld d, a                                       ; $75FF
    xor [hl]                                      ; $7600
    ld [hl+], a                                   ; $7601
    xor d                                         ; $7602
    and b                                         ; $7603
    xor [hl]                                      ; $7604
    ld [hl+], a                                   ; $7605
    inc l                                         ; $7606
    ld a, [hl-]                                   ; $7607
    and c                                         ; $7608
    ld d, a                                       ; $7609
    xor [hl]                                      ; $760A
    ld [hl+], a                                   ; $760B
    xor d                                         ; $760C
    and b                                         ; $760D
    xor [hl]                                      ; $760E
    ld [hl+], a                                   ; $760F
    inc l                                         ; $7610
    ld a, [hl-]                                   ; $7611
    and c                                         ; $7612
    ld d, a                                       ; $7613
    xor [hl]                                      ; $7614
    ld [hl+], a                                   ; $7615
    xor d                                         ; $7616
    and b                                         ; $7617
    xor [hl]                                      ; $7618
    ld [hl+], a                                   ; $7619
    inc l                                         ; $761A
    ld a, [hl-]                                   ; $761B
    and c                                         ; $761C
    ld d, a                                       ; $761D
    xor [hl]                                      ; $761E
    ld [hl+], a                                   ; $761F
    xor d                                         ; $7620
    and b                                         ; $7621
    xor [hl]                                      ; $7622
    ld [hl+], a                                   ; $7623
    inc l                                         ; $7624
    ld a, [hl-]                                   ; $7625
    and c                                         ; $7626
    ld d, a                                       ; $7627
    xor [hl]                                      ; $7628
    ld [hl+], a                                   ; $7629
    xor d                                         ; $762A
    and b                                         ; $762B
    xor [hl]                                      ; $762C
    ld [hl+], a                                   ; $762D
    inc l                                         ; $762E
    ld a, [hl-]                                   ; $762F
    and c                                         ; $7630
    ld d, a                                       ; $7631
    xor [hl]                                      ; $7632
    ld [hl+], a                                   ; $7633
    xor d                                         ; $7634
    and b                                         ; $7635
    xor [hl]                                      ; $7636
    ld [hl+], a                                   ; $7637
    inc l                                         ; $7638
    ld a, [hl-]                                   ; $7639
    and c                                         ; $763A
    ld d, a                                       ; $763B
    xor [hl]                                      ; $763C
    ld [hl+], a                                   ; $763D
    xor d                                         ; $763E
    and b                                         ; $763F
    xor [hl]                                      ; $7640
    ld [hl+], a                                   ; $7641
    inc l                                         ; $7642
    jr nz, jr_006_7646                            ; $7643

    inc h                                         ; $7645

jr_006_7646:
    dec e                                         ; $7646
    jr nz, jr_006_75f3                            ; $7647

    ld de, $0080                                  ; $7649
    add hl, de                                    ; $764C
    ldh a, [hScratchB]                            ; $764D
    dec a                                         ; $764F
    jr nz, jr_006_75ef                            ; $7650

    pop hl                                        ; $7652

jr_006_7653:
    ld a, [wShootFxVector + $4]                   ; $7653
    ld c, a                                       ; $7656
    and a                                         ; $7657
    ret z                                         ; $7658

    inc hl                                        ; $7659
    ldh a, [hScratchA]                            ; $765A

jr_006_765c:
    ldh [hScratchB], a                            ; $765C
    ld e, $08                                     ; $765E

jr_006_7660:
    ld a, [hl-]                                   ; $7660
    xor [hl]                                      ; $7661
    and c                                         ; $7662
    ld d, a                                       ; $7663
    xor [hl]                                      ; $7664
    ld [hl+], a                                   ; $7665
    ld a, d                                       ; $7666
    xor [hl]                                      ; $7667
    ld [hl+], a                                   ; $7668
    inc l                                         ; $7669
    ld a, [hl-]                                   ; $766A
    xor [hl]                                      ; $766B
    and c                                         ; $766C
    ld d, a                                       ; $766D
    xor [hl]                                      ; $766E
    ld [hl+], a                                   ; $766F
    ld a, d                                       ; $7670
    xor [hl]                                      ; $7671
    ld [hl+], a                                   ; $7672
    inc l                                         ; $7673
    ld a, [hl-]                                   ; $7674
    xor [hl]                                      ; $7675
    and c                                         ; $7676
    ld d, a                                       ; $7677
    xor [hl]                                      ; $7678
    ld [hl+], a                                   ; $7679
    ld a, d                                       ; $767A
    xor [hl]                                      ; $767B
    ld [hl+], a                                   ; $767C
    inc l                                         ; $767D
    ld a, [hl-]                                   ; $767E
    xor [hl]                                      ; $767F
    and c                                         ; $7680
    ld d, a                                       ; $7681
    xor [hl]                                      ; $7682
    ld [hl+], a                                   ; $7683
    ld a, d                                       ; $7684
    xor [hl]                                      ; $7685
    ld [hl+], a                                   ; $7686
    inc l                                         ; $7687
    ld a, [hl-]                                   ; $7688
    xor [hl]                                      ; $7689
    and c                                         ; $768A
    ld d, a                                       ; $768B
    xor [hl]                                      ; $768C
    ld [hl+], a                                   ; $768D
    ld a, d                                       ; $768E
    xor [hl]                                      ; $768F
    ld [hl+], a                                   ; $7690
    inc l                                         ; $7691
    ld a, [hl-]                                   ; $7692
    xor [hl]                                      ; $7693
    and c                                         ; $7694
    ld d, a                                       ; $7695
    xor [hl]                                      ; $7696
    ld [hl+], a                                   ; $7697
    ld a, d                                       ; $7698
    xor [hl]                                      ; $7699
    ld [hl+], a                                   ; $769A
    inc l                                         ; $769B
    ld a, [hl-]                                   ; $769C
    xor [hl]                                      ; $769D
    and c                                         ; $769E
    ld d, a                                       ; $769F
    xor [hl]                                      ; $76A0
    ld [hl+], a                                   ; $76A1
    ld a, d                                       ; $76A2
    xor [hl]                                      ; $76A3
    ld [hl+], a                                   ; $76A4
    inc l                                         ; $76A5
    ld a, [hl-]                                   ; $76A6
    xor [hl]                                      ; $76A7
    and c                                         ; $76A8
    ld d, a                                       ; $76A9
    xor [hl]                                      ; $76AA
    ld [hl+], a                                   ; $76AB
    ld a, d                                       ; $76AC
    xor [hl]                                      ; $76AD
    ld [hl+], a                                   ; $76AE
    inc l                                         ; $76AF
    jr nz, jr_006_76b3                            ; $76B0

    inc h                                         ; $76B2

jr_006_76b3:
    dec e                                         ; $76B3
    jr nz, jr_006_7660                            ; $76B4

    ld de, $0080                                  ; $76B6
    add hl, de                                    ; $76B9
    ldh a, [hScratchB]                            ; $76BA
    dec a                                         ; $76BC
    jr nz, jr_006_765c                            ; $76BD

    ret                                           ; $76BF


; C: masked variant for the single tile region. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Shoot_FxMaskBlockBody::
    ldh [hScratchA], a                            ; $76C0
    ld a, [wShootFxVector]                        ; $76C2
    ld c, a                                       ; $76C5
    ld a, [wShootFxVector + $1]                   ; $76C6
    ld b, a                                       ; $76C9
    or c                                          ; $76CA
    jr z, jr_006_7711                             ; $76CB

    push hl                                       ; $76CD
    ldh a, [hScratchA]                            ; $76CE

jr_006_76d0:
    ldh [hScratchB], a                            ; $76D0
    ld e, $0a                                     ; $76D2

jr_006_76d4:
    ld a, [hl]                                    ; $76D4
    xor c                                         ; $76D5
    ld [hl+], a                                   ; $76D6
    ld a, [hl]                                    ; $76D7
    xor b                                         ; $76D8
    ld [hl+], a                                   ; $76D9
    ld a, [hl]                                    ; $76DA
    xor c                                         ; $76DB
    ld [hl+], a                                   ; $76DC
    ld a, [hl]                                    ; $76DD
    xor b                                         ; $76DE
    ld [hl+], a                                   ; $76DF
    ld a, [hl]                                    ; $76E0
    xor c                                         ; $76E1
    ld [hl+], a                                   ; $76E2
    ld a, [hl]                                    ; $76E3
    xor b                                         ; $76E4
    ld [hl+], a                                   ; $76E5
    ld a, [hl]                                    ; $76E6
    xor c                                         ; $76E7
    ld [hl+], a                                   ; $76E8
    ld a, [hl]                                    ; $76E9
    xor b                                         ; $76EA
    ld [hl+], a                                   ; $76EB
    ld a, [hl]                                    ; $76EC
    xor c                                         ; $76ED
    ld [hl+], a                                   ; $76EE
    ld a, [hl]                                    ; $76EF
    xor b                                         ; $76F0
    ld [hl+], a                                   ; $76F1
    ld a, [hl]                                    ; $76F2
    xor c                                         ; $76F3
    ld [hl+], a                                   ; $76F4
    ld a, [hl]                                    ; $76F5
    xor b                                         ; $76F6
    ld [hl+], a                                   ; $76F7
    ld a, [hl]                                    ; $76F8
    xor c                                         ; $76F9
    ld [hl+], a                                   ; $76FA
    ld a, [hl]                                    ; $76FB
    xor b                                         ; $76FC
    ld [hl+], a                                   ; $76FD
    ld a, [hl]                                    ; $76FE
    xor c                                         ; $76FF
    ld [hl+], a                                   ; $7700
    ld a, [hl]                                    ; $7701
    xor b                                         ; $7702
    ld [hl+], a                                   ; $7703
    dec e                                         ; $7704
    jr nz, jr_006_76d4                            ; $7705

    ld de, $0060                                  ; $7707
    add hl, de                                    ; $770A
    ldh a, [hScratchB]                            ; $770B
    dec a                                         ; $770D
    jr nz, jr_006_76d0                            ; $770E

    pop hl                                        ; $7710

jr_006_7711:
    ld a, [wShootFxVector + $2]                   ; $7711
    ld c, a                                       ; $7714
    ld a, [wShootFxVector + $3]                   ; $7715
    ld b, a                                       ; $7718
    or c                                          ; $7719
    jr z, jr_006_7784                             ; $771A

    push hl                                       ; $771C
    inc hl                                        ; $771D
    ldh a, [hScratchA]                            ; $771E

jr_006_7720:
    ldh [hScratchB], a                            ; $7720
    ld e, $0a                                     ; $7722

jr_006_7724:
    ld a, [hl-]                                   ; $7724
    and c                                         ; $7725
    ld d, a                                       ; $7726
    xor [hl]                                      ; $7727
    ld [hl+], a                                   ; $7728
    xor d                                         ; $7729
    and b                                         ; $772A
    xor [hl]                                      ; $772B
    ld [hl+], a                                   ; $772C
    inc l                                         ; $772D
    ld a, [hl-]                                   ; $772E
    and c                                         ; $772F
    ld d, a                                       ; $7730
    xor [hl]                                      ; $7731
    ld [hl+], a                                   ; $7732
    xor d                                         ; $7733
    and b                                         ; $7734
    xor [hl]                                      ; $7735
    ld [hl+], a                                   ; $7736
    inc l                                         ; $7737
    ld a, [hl-]                                   ; $7738
    and c                                         ; $7739
    ld d, a                                       ; $773A
    xor [hl]                                      ; $773B
    ld [hl+], a                                   ; $773C
    xor d                                         ; $773D
    and b                                         ; $773E
    xor [hl]                                      ; $773F
    ld [hl+], a                                   ; $7740
    inc l                                         ; $7741
    ld a, [hl-]                                   ; $7742
    and c                                         ; $7743
    ld d, a                                       ; $7744
    xor [hl]                                      ; $7745
    ld [hl+], a                                   ; $7746
    xor d                                         ; $7747
    and b                                         ; $7748
    xor [hl]                                      ; $7749
    ld [hl+], a                                   ; $774A
    inc l                                         ; $774B
    ld a, [hl-]                                   ; $774C
    and c                                         ; $774D
    ld d, a                                       ; $774E
    xor [hl]                                      ; $774F
    ld [hl+], a                                   ; $7750
    xor d                                         ; $7751
    and b                                         ; $7752
    xor [hl]                                      ; $7753
    ld [hl+], a                                   ; $7754
    inc l                                         ; $7755
    ld a, [hl-]                                   ; $7756
    and c                                         ; $7757
    ld d, a                                       ; $7758
    xor [hl]                                      ; $7759
    ld [hl+], a                                   ; $775A
    xor d                                         ; $775B
    and b                                         ; $775C
    xor [hl]                                      ; $775D
    ld [hl+], a                                   ; $775E
    inc l                                         ; $775F
    ld a, [hl-]                                   ; $7760
    and c                                         ; $7761
    ld d, a                                       ; $7762
    xor [hl]                                      ; $7763
    ld [hl+], a                                   ; $7764
    xor d                                         ; $7765
    and b                                         ; $7766
    xor [hl]                                      ; $7767
    ld [hl+], a                                   ; $7768
    inc l                                         ; $7769
    ld a, [hl-]                                   ; $776A
    and c                                         ; $776B
    ld d, a                                       ; $776C
    xor [hl]                                      ; $776D
    ld [hl+], a                                   ; $776E
    xor d                                         ; $776F
    and b                                         ; $7770
    xor [hl]                                      ; $7771
    ld [hl+], a                                   ; $7772
    inc l                                         ; $7773
    jr nz, jr_006_7777                            ; $7774

    inc h                                         ; $7776

jr_006_7777:
    dec e                                         ; $7777
    jr nz, jr_006_7724                            ; $7778

    ld de, $0060                                  ; $777A
    add hl, de                                    ; $777D
    ldh a, [hScratchB]                            ; $777E
    dec a                                         ; $7780
    jr nz, jr_006_7720                            ; $7781

    pop hl                                        ; $7783

jr_006_7784:
    ld a, [wShootFxVector + $4]                   ; $7784
    ld c, a                                       ; $7787
    and a                                         ; $7788
    ret z                                         ; $7789

    inc hl                                        ; $778A
    ldh a, [hScratchA]                            ; $778B

jr_006_778d:
    ldh [hScratchB], a                            ; $778D
    ld e, $0a                                     ; $778F

jr_006_7791:
    ld a, [hl-]                                   ; $7791
    xor [hl]                                      ; $7792
    and c                                         ; $7793
    ld d, a                                       ; $7794
    xor [hl]                                      ; $7795
    ld [hl+], a                                   ; $7796
    ld a, d                                       ; $7797
    xor [hl]                                      ; $7798
    ld [hl+], a                                   ; $7799
    inc l                                         ; $779A
    ld a, [hl-]                                   ; $779B
    xor [hl]                                      ; $779C
    and c                                         ; $779D
    ld d, a                                       ; $779E
    xor [hl]                                      ; $779F
    ld [hl+], a                                   ; $77A0
    ld a, d                                       ; $77A1
    xor [hl]                                      ; $77A2
    ld [hl+], a                                   ; $77A3
    inc l                                         ; $77A4
    ld a, [hl-]                                   ; $77A5
    xor [hl]                                      ; $77A6
    and c                                         ; $77A7
    ld d, a                                       ; $77A8
    xor [hl]                                      ; $77A9
    ld [hl+], a                                   ; $77AA
    ld a, d                                       ; $77AB
    xor [hl]                                      ; $77AC
    ld [hl+], a                                   ; $77AD
    inc l                                         ; $77AE
    ld a, [hl-]                                   ; $77AF
    xor [hl]                                      ; $77B0
    and c                                         ; $77B1
    ld d, a                                       ; $77B2
    xor [hl]                                      ; $77B3
    ld [hl+], a                                   ; $77B4
    ld a, d                                       ; $77B5
    xor [hl]                                      ; $77B6
    ld [hl+], a                                   ; $77B7
    inc l                                         ; $77B8
    ld a, [hl-]                                   ; $77B9
    xor [hl]                                      ; $77BA
    and c                                         ; $77BB
    ld d, a                                       ; $77BC
    xor [hl]                                      ; $77BD
    ld [hl+], a                                   ; $77BE
    ld a, d                                       ; $77BF
    xor [hl]                                      ; $77C0
    ld [hl+], a                                   ; $77C1
    inc l                                         ; $77C2
    ld a, [hl-]                                   ; $77C3
    xor [hl]                                      ; $77C4
    and c                                         ; $77C5
    ld d, a                                       ; $77C6
    xor [hl]                                      ; $77C7
    ld [hl+], a                                   ; $77C8
    ld a, d                                       ; $77C9
    xor [hl]                                      ; $77CA
    ld [hl+], a                                   ; $77CB
    inc l                                         ; $77CC
    ld a, [hl-]                                   ; $77CD
    xor [hl]                                      ; $77CE
    and c                                         ; $77CF
    ld d, a                                       ; $77D0
    xor [hl]                                      ; $77D1
    ld [hl+], a                                   ; $77D2
    ld a, d                                       ; $77D3
    xor [hl]                                      ; $77D4
    ld [hl+], a                                   ; $77D5
    inc l                                         ; $77D6
    ld a, [hl-]                                   ; $77D7
    xor [hl]                                      ; $77D8
    and c                                         ; $77D9
    ld d, a                                       ; $77DA
    xor [hl]                                      ; $77DB
    ld [hl+], a                                   ; $77DC
    ld a, d                                       ; $77DD
    xor [hl]                                      ; $77DE
    ld [hl+], a                                   ; $77DF
    inc l                                         ; $77E0
    jr nz, jr_006_77e4                            ; $77E1

    inc h                                         ; $77E3

jr_006_77e4:
    dec e                                         ; $77E4
    jr nz, jr_006_7791                            ; $77E5

    ld de, $0060                                  ; $77E7
    add hl, de                                    ; $77EA
    ldh a, [hScratchB]                            ; $77EB
    dec a                                         ; $77ED
    jr nz, jr_006_778d                            ; $77EE

    ret                                           ; $77F0


; C
Shoot_SetupCapture::
    ld e, $00                                     ; $77F1
    ld a, [wShootCaptureSel]                      ; $77F3
    cp $01                                        ; $77F6
    jr nz, jr_006_77fe                            ; $77F8

    ld e, $20                                     ; $77FA
    jr jr_006_7804                                ; $77FC

jr_006_77fe:
    cp $02                                        ; $77FE
    jr nz, jr_006_7804                            ; $7800

    ld e, $40                                     ; $7802

jr_006_7804:
    ld a, [wShootVariant]                         ; $7804
    sla a                                         ; $7807
    sla a                                         ; $7809
    ld hl, wShootPhase                            ; $780B
    add [hl]                                      ; $780E
    ld c, a                                       ; $780F
    ld b, $00                                     ; $7810
    ld hl, Shoot_CallVariantHandler_Tbl60DB       ; $7812
    add hl, bc                                    ; $7815
    ld a, [hl]                                    ; $7816
    or e                                          ; $7817
    ldh [hFarcallAArg], a                         ; $7818
    farcall Cam_FarStub_DispatchEffect            ; $781A
    ret                                           ; $7822


; C: taken photos + 1 (BCD) and store (02)
Counters_IncTaken::
    ld a, $01                                     ; $7823
    ld hl, wCntTaken                              ; $7825
    ld b, $02                                     ; $7828
    call Bcd_AddSaturate                          ; $782A
    ldh [hFarcallAArg], a                         ; $782D
    farcall Counters_Store_Far                    ; $782F
    ret                                           ; $7837


; C: sound list by shutter_sound
Shoot_PlayShutterSound::
    ld a, [wShutterSound]                         ; $7838
    cp $04                                        ; $783B
    ret nc                                        ; $783D

    ld hl, Shoot_PlayShutterSound_Tbl7845         ; $783E
    call Snd_PlayFromList                         ; $7841
    ret                                           ; $7844


; C: auto: 8 bytes, bytes; referenced by Shoot_PlayShutterSound. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 14 (tcrf_check/assets/l3_names/)
Shoot_PlayShutterSound_Tbl7845::
    db SFX1_SHUTTER_SOUND_1, SNDCH_SFX1  ; #1
    db SFX3_SHUTTER_SOUND_2, SNDCH_SFX3  ; #2
    db SFX3_SHUTTER_SOUND_3, SNDCH_SFX3  ; #3
    db SFX4_SHUTTER_SOUND_4, SNDCH_SFX4  ; #4

    ; padding
    ds $7b3, $00

; Game Boy Camera (USA, Europe), bank $08. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $008", ROMX[$4000], BANK[$8]

; C: mode 1B: printer menu (Left = mode 1C; Right = mode 1E)
Mode1B_PrintMenu::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; C
Mode1B_StateTable::
    dw Mode1B_State00_Init
    dw Mode1B_State01_Choose
    dw Mode1B_State02_Leave

; C
Mode1B_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $400A
    ldh [hLcdcShadow], a                          ; $400C
    ld a, $e4                                     ; $400E
    ld [wPaletteTarget], a                        ; $4010
    ld [wPaletteTarget + $1], a                   ; $4013
    ld a, $c6                                     ; $4016
    ld [wPaletteTarget + $2], a                   ; $4018
    xor a                                         ; $401B
    ldh [hScxShadow], a                           ; $401C
    ldh [hScyShadow], a                           ; $401E
    farcopy Mem_CopyFromBank, Gfx_18_6470_Mode1B_State00_Init, $9000, $0800 ; $4020
    farcopy Mem_CopyFromBank, Gfx_18_6C70_Mode1B_State00_Init, $8800, $0800 ; $402E
    farcopy Mem_CopyFromBank, Map_25_7A60_Mode1B_State00_Init, $9800, $0240 ; $403C
    screen_on                                     ; $404A
    call Pal_FadeIn                               ; $4053
    next_state                                    ; $4056
    ret                                           ; $405A


; C
Mode1B_State01_Choose::
    call Mode1B_ReadChoice                        ; $405B
    call Mode1B_DrawCursor                        ; $405E
    ldh a, [hKeysNew]                             ; $4061
    and PADF_A | PADF_B                           ; $4063
    ret z                                         ; $4065

    ld [wAbResult], a                             ; $4066
    next_state                                    ; $4069
    ret                                           ; $406D


; C: B -> mode 6; A -> Mode1B_TargetModeTbl[choice]
Mode1B_State02_Leave::
    ld a, [wAbResult]                             ; $406E
    bit 0, a                                      ; $4071
    jr nz, jr_008_4086                            ; $4073

    ld a, MODE_LINK_MENU                          ; $4075
    ld [wMode], a                                 ; $4077
    set_state STATE_06_INIT                       ; $407A
    screen_off                                    ; $407F
    ret                                           ; $4085


jr_008_4086:
    ld a, [wYesnoH8]                              ; $4086
    ld e, a                                       ; $4089
    ld d, $00                                     ; $408A
    ld hl, Mode1B_TargetModeTbl                   ; $408C
    add hl, de                                    ; $408F
    ld a, [hl]                                    ; $4090
    cp MODE_NONE                                  ; $4091
    jr nz, jr_008_409a                            ; $4093

    ld hl, wState                                 ; $4095
    dec [hl]                                      ; $4098
    ret                                           ; $4099


jr_008_409a:
    ld [wMode], a                                 ; $409A
    xor a                                         ; $409D
    ld [wState], a                                ; $409E
    ld hl, wPrintSelectBitmap                     ; $40A1
    ld b, $08                                     ; $40A4

jr_008_40a6:
    ld [hl+], a                                   ; $40A6
    dec b                                         ; $40A7
    jr nz, jr_008_40a6                            ; $40A8

    screen_off                                    ; $40AA
    ret                                           ; $40B0


; C: $1C; $1E
Mode1B_TargetModeTbl::
    db MODE_PRINT_PHOTO_PICKER, MODE_PRINT_OPTION

; C: sprite $F6 at table 40D8; nudged by Up/Down
Mode1B_DrawCursor::
    ld a, [wYesnoH8]                              ; $40B3
    sla a                                         ; $40B6
    ld c, a                                       ; $40B8
    ld b, $00                                     ; $40B9
    ld hl, Mode1B_CursorPosTbl                    ; $40BB
    add hl, bc                                    ; $40BE
    ld c, [hl]                                    ; $40BF
    inc hl                                        ; $40C0
    ld b, [hl]                                    ; $40C1
    ldh a, [hKeysNew]                             ; $40C2
    bit PADB_UP, a                                ; $40C4
    jr z, jr_008_40cc                             ; $40C6

    dec c                                         ; $40C8
    dec c                                         ; $40C9
    jr jr_008_40d2                                ; $40CA

jr_008_40cc:
    bit 7, a                                      ; $40CC
    jr z, jr_008_40d2                             ; $40CE

    inc c                                         ; $40D0
    inc c                                         ; $40D1

jr_008_40d2:
    ld a, $f6                                     ; $40D2
    call Oam_AddMeta_B01_4000                     ; $40D4
    ret                                           ; $40D7


; C: (x;y) = ($08;$30) / ($39;$30)
Mode1B_CursorPosTbl::
    db $30, $08, $30, $39

; C: Left/Right toggles D5FA
Mode1B_ReadChoice::
    ldh a, [hKeysNew]                             ; $40DC
    bit PADB_LEFT, a                              ; $40DE
    jr z, jr_008_40e5                             ; $40E0

    xor a                                         ; $40E2
    jr jr_008_40ea                                ; $40E3

jr_008_40e5:
    bit 4, a                                      ; $40E5
    ret z                                         ; $40E7

    ld a, $01                                     ; $40E8

jr_008_40ea:
    ld hl, wYesnoH8                               ; $40EA
    cp [hl]                                       ; $40ED
    ret z                                         ; $40EE

    ld [hl], a                                    ; $40EF
    play_sfx1 SFX1_CURSOR_MOVE                    ; $40F0
    ret                                           ; $40F7


; C: mode 1C: print one photo (picker; layout; density; border)
Mode1C_PrintPhotoPicker::
    ld a, [wState]                                ; $40F8
    rst Rst18_JumpTable                           ; $40FB

; C: 15 states
Mode1C_StateTable::
    dw Mode1C_State00_Init
    dw Mode1C_State01_PickPhoto
    dw Mode1C_State02_ShowPrintScreen
    dw Mode1C_State03_PrintMain
    dw Mode1C_State04_OptionsMenu
    dw Mode1C_State05_OptionDensity
    dw Mode1C_State06_OptionToggle
    dw Mode1C_State07_Leave
    dw Mode1C_State08_PrintJob
    dw Mode1C_State09_FadeToBorderPicker
    dw Mode1C_State0A_BorderPicker
    dw Mode1C_State0B_AfterBorder
    dw Mode1C_State0C_FadeToWildPicker
    dw Mode1C_State0D_WildFramePicker
    dw Mode1C_State0E_AfterWildFrame

; C: clears the print flags
Mode1C_State00_Init::
    ld a, $09                                     ; $411A
    ld [wMsgStripSel], a                          ; $411C
    ld a, $03                                     ; $411F
    ld [wIconSel], a                              ; $4121
    xor a                                         ; $4124
    ld [wSubstate], a                             ; $4125
    ld [wCallerCode], a                           ; $4128
    ld [wPrintLayoutFlag], a                      ; $412B
    ld [wBorderNormalised], a                     ; $412E
    ld [wPrintExtraFlag], a                       ; $4131
    ld a, $01                                     ; $4134
    ld [wStockNavAllowed], a                      ; $4136
    next_state                                    ; $4139
    ret                                           ; $413D


; C: far call 04:4000 (PhotoPicker_Far)
Mode1C_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $413E
    ld a, $04                                     ; $4140
    ld hl, PhotoPicker_Far                        ; $4142
    call Far_Call                                 ; $4145
    ret                                           ; $4148


; C: loads photo; border and layout; also re-entered from states 0B / 0E
Mode1C_State02_ShowPrintScreen::
    ld a, [wAbResult]                             ; $4149
    bit 0, a                                      ; $414C
    jr nz, jr_008_415b                            ; $414E

    ld a, MODE_PRINT_MENU                         ; $4150
    ld [wMode], a                                 ; $4152
    set_state STATE_1B_INIT                       ; $4155
    ret                                           ; $415A


jr_008_415b:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $415B
    ldh [hLcdcShadow], a                          ; $415D
    ld a, $e4                                     ; $415F
    ld [wPaletteTarget], a                        ; $4161
    ld [wPaletteTarget + $1], a                   ; $4164
    ld a, $d2                                     ; $4167
    ld [wPaletteTarget + $2], a                   ; $4169
    xor a                                         ; $416C
    ldh [hScxShadow], a                           ; $416D
    ld a, $10                                     ; $416F
    ldh [hScyShadow], a                           ; $4171
    ldh [hFarcallAArg], a                         ; $4173
    farcall Counters_Load_Far                     ; $4175
    farcopy Mem_CopyFromBank, Gfx_18_7400_Mode1C_State02_ShowPrintScreen, $8b00, $0500 ; $417D
    farcopy Mem_CopyFromBank, Gfx_18_7F60_Mode1C_State02_ShowPrintScreen, $8f00, $0050 ; $418B
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8500, $0080 ; $4199
    farcopy Mem_CopyFromBank, Gfx_18_7B00_Mode1C_State02_ShowPrintScreen, $8580, $00a0 ; $41A7
    farcopy Mem_CopyFromBank, Gfx_17_4A60_Mode0E_State04_PickDone, $8620, $0020 ; $41B5
    farcopy Mem_CopyFromBank, Gfx_17_4B60_Mode0E_State04_PickDone, $8640, $0030 ; $41C3
    farcopy Mem_CopyFromBank, Gfx_17_4B90_Mode0E_State04_PickDone, $8720, $0050 ; $41D1
    farcopy Mem_CopyFromBank, Gfx_18_7A80_Mode1C_State02_ShowPrintScreen, $86a0, $0080 ; $41DF
    farcopy Mem_CopyFromBank, Map_24_6BA0_Mode1C_State02_ShowPrintScreen, $9800, $02c0 ; $41ED
    ld hl, $8ff0                                  ; $41FB
    ld bc, $0010                                  ; $41FE
    ld de, $ffff                                  ; $4201
    call Mem_FillWords                            ; $4204
    ld hl, $9ac0                                  ; $4207
    ld bc, $0140                                  ; $420A
    ld a, $ff                                     ; $420D
    call Mem_FillBc1                              ; $420F
    ld a, [wPhotoIndex]                           ; $4212
    ld [wCopyPhotoIdxB], a                        ; $4215
    ld a, [wPrintLayoutFlag]                      ; $4218
    and a                                         ; $421B
    jr nz, jr_008_424d                            ; $421C

    ld a, [wBorderNormalised]                     ; $421E
    and a                                         ; $4221
    jr nz, jr_008_4241                            ; $4222

    ld a, [wCopyPhotoIdxB]                        ; $4224
    ldh [hFarcallAArg], a                         ; $4227
    farcall Photo_LoadBorder_Far                  ; $4229
    ld a, [wBorderNumber]                         ; $4231
    cp $12                                        ; $4234
    jr nz, jr_008_4241                            ; $4236

    xor a                                         ; $4238
    ld [wBorderNumber], a                         ; $4239
    ld a, $01                                     ; $423C
    ld [wBorderNormalised], a                     ; $423E

jr_008_4241:
    ldh [hFarcallAArg], a                         ; $4241
    ld a, $08                                     ; $4243
    ld hl, Border_LoadMap_LcdOff                  ; $4245
    call Far_Call                                 ; $4248
    jr jr_008_4257                                ; $424B

jr_008_424d:
    ldh [hFarcallAArg], a                         ; $424D
    ld a, $08                                     ; $424F
    ld hl, WildFrame_LoadForPrintScreen           ; $4251
    call Far_Call                                 ; $4254

jr_008_4257:
    ld a, [wCopyPhotoIdxB]                        ; $4257
    ldh [hFarcallAArg], a                         ; $425A
    farcall Photo_LoadToVram_Far                  ; $425C
    ld a, $54                                     ; $4264
    ldh [hLycShadowSplit1], a                     ; $4266
    ldh [hSplit1Latch], a                         ; $4268
    ld hl, hStatShadow                            ; $426A
    set 6, [hl]                                   ; $426D
    ld hl, rIE                                    ; $426F
    set 1, [hl]                                   ; $4272
    ld a, $01                                     ; $4274
    ldh [hStatHandlerIndex], a                    ; $4276
    screen_on                                     ; $4278
    play_music MUSIC_ALBUM_VIEWER                 ; $4281
    call Pal_FadeIn                               ; $4288
    set_state STATE_1C_PRINT_MAIN                 ; $428B
    ret                                           ; $4290


; C: Select = option page; Start = toggle extra copy; A/B = leave; BGB watchpoint pass 2026-10-25: ran only in mode 1C
; and state 03 (21106 hits in 22 runs: 1C:03 x21106; tcrf_check/assets/mode_state_wp/)
Mode1C_State03_PrintMain::
    call Mode1C_DrawJitterSprite                  ; $4291
    ldh a, [hKeysHeld]                            ; $4294
    and PADF_DPAD                                 ; $4296
    jr nz, jr_008_42af                            ; $4298

    ldh a, [hKeysNew]                             ; $429A
    bit PADB_SELECT, a                            ; $429C
    jr z, jr_008_42af                             ; $429E

    play_sfx1 SFX1_KEY_SELECT                     ; $42A0
    call Mode1C_DrawOptionScreen                  ; $42A7
    next_state                                    ; $42AA
    ret                                           ; $42AE


jr_008_42af:
    ldh a, [hKeysNew]                             ; $42AF
    bit PADB_START, a                             ; $42B1
    jr z, jr_008_42c5                             ; $42B3

    play_sfx1 SFX1_CONFIRM                        ; $42B5
    ld a, [wPrintExtraFlag]                       ; $42BC
    xor $01                                       ; $42BF
    ld [wPrintExtraFlag], a                       ; $42C1
    ret                                           ; $42C4


jr_008_42c5:
    and $03                                       ; $42C5
    ret z                                         ; $42C7

    push af                                       ; $42C8
    bit 0, a                                      ; $42C9
    ld a, SFX1_KEY_A                              ; $42CB
    call nz, Snd_Sfx1                             ; $42CD
    pop af                                        ; $42D0
    push af                                       ; $42D1
    bit 1, a                                      ; $42D2
    ld a, SFX1_KEY_B                              ; $42D4
    call nz, Snd_Sfx1                             ; $42D6
    pop af                                        ; $42D9
    ld [wAbResult], a                             ; $42DA
    set_state STATE_1C_LEAVE                      ; $42DD
    ret                                           ; $42E2


; C: random 1-px jitter of sprite $79/$7A; BGB watchpoint pass 2026-10-25: ran only in mode 1C (10553 hits in 22 runs:
; 1C:03 x10553; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawJitterSprite::
    ldh a, [hFrameCounter]                        ; $42E3
    and $01                                       ; $42E5
    jr nz, jr_008_42f5                            ; $42E7

    call Rng_Next                                 ; $42E9
    ld [wJitterX], a                              ; $42EC
    call Rng_Next                                 ; $42EF
    ld [wJitterY], a                              ; $42F2

jr_008_42f5:
    ld a, [wJitterX]                              ; $42F5
    and $01                                       ; $42F8
    add $79                                       ; $42FA
    ld b, a                                       ; $42FC
    ld a, [wJitterY]                              ; $42FD
    and $01                                       ; $4300
    add $7c                                       ; $4302
    ld c, a                                       ; $4304
    ld a, $5f                                     ; $4305
    call Oam_AddMeta_B02_52BD                     ; $4307
    ld a, [wPrintExtraFlag]                       ; $430A
    and a                                         ; $430D
    ld a, $ca                                     ; $430E
    call nz, Oam_AddMeta_B02_52BD                 ; $4310
    ld a, [wJitterX]                              ; $4313
    and $01                                       ; $4316
    add $79                                       ; $4318
    ld b, a                                       ; $431A
    ld a, [wJitterY]                              ; $431B
    and $01                                       ; $431E
    add $8d                                       ; $4320
    ld c, a                                       ; $4322
    ld a, $60                                     ; $4323
    call Oam_AddMeta_B02_52BD                     ; $4325
    ret                                           ; $4328


; C: Up -> density; Down -> second option; B/Select back; BGB watchpoint pass 2026-10-25: ran only in mode 1C and
; state 04 (5627 hits in 13 runs: 1C:04 x5627; tcrf_check/assets/mode_state_wp/)
Mode1C_State04_OptionsMenu::
    ld a, [wBlinkCounter]                         ; $4329
    inc a                                         ; $432C
    ld [wBlinkCounter], a                         ; $432D
    bit 4, a                                      ; $4330
    jr z, jr_008_4344                             ; $4332

    ld a, $a3                                     ; $4334
    ld bc, $5078                                  ; $4336
    call Oam_AddMeta_B01_4000                     ; $4339
    ld a, $a2                                     ; $433C
    ld bc, $5018                                  ; $433E
    call Oam_AddMeta_B01_4000                     ; $4341

jr_008_4344:
    ldh a, [hKeysNew]                             ; $4344
    and PADF_B | PADF_SELECT                      ; $4346
    jr z, jr_008_4359                             ; $4348

    play_sfx1 SFX1_KEY_B                          ; $434A
    call Mode1C_DrawPrintScreen                   ; $4351
    ld hl, wState                                 ; $4354
    dec [hl]                                      ; $4357
    ret                                           ; $4358


jr_008_4359:
    ldh a, [hKeysNewRepeat]                       ; $4359
    and PADF_DPAD                                 ; $435B
    ret z                                         ; $435D

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $435E
    xor a                                         ; $4365
    ld [wArrowAnimTick], a                        ; $4366
    ld [wArrowAnimFrame], a                       ; $4369
    ldh a, [hKeysNewRepeat]                       ; $436C
    bit PADB_UP, a                                ; $436E
    jr z, jr_008_43a1                             ; $4370

    call Oam_ClearShadow                          ; $4372
    farcopy Vram_CopyFromBank, Gfx_18_7A80_Mode1C_State02_ShowPrintScreen, $86a0, $0080 ; $4375
    ld hl, Slide_ScyDeltaTbl                      ; $4383
    ld b, $10                                     ; $4386

jr_008_4388:
    push bc                                       ; $4388
    push hl                                       ; $4389
    ldh a, [hScyShadow]                           ; $438A
    add [hl]                                      ; $438C
    ldh [hScyShadow], a                           ; $438D
    cpl                                           ; $438F
    add $64                                       ; $4390
    ldh [hLycShadowSplit1], a                     ; $4392
    rst Rst08_WaitVBlank                          ; $4394
    pop hl                                        ; $4395
    pop bc                                        ; $4396
    inc hl                                        ; $4397
    dec b                                         ; $4398
    jr nz, jr_008_4388                            ; $4399

    set_state STATE_1C_OPTION_DENSITY             ; $439B
    ret                                           ; $43A0


jr_008_43a1:
    bit 7, a                                      ; $43A1
    ret z                                         ; $43A3

    call Oam_ClearShadow                          ; $43A4
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $43A7
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $43B5
    ld hl, Slide_ScyDeltaTbl                      ; $43C3
    ld b, $10                                     ; $43C6

jr_008_43c8:
    push bc                                       ; $43C8
    push hl                                       ; $43C9
    ldh a, [hScyShadow]                           ; $43CA
    sub [hl]                                      ; $43CC
    ldh [hScyShadow], a                           ; $43CD
    cpl                                           ; $43CF
    add $64                                       ; $43D0
    ldh [hLycShadowSplit1], a                     ; $43D2
    rst Rst08_WaitVBlank                          ; $43D4
    pop hl                                        ; $43D5
    pop bc                                        ; $43D6
    inc hl                                        ; $43D7
    dec b                                         ; $43D8
    jr nz, jr_008_43c8                            ; $43D9

    set_state STATE_1C_OPTION_TOGGLE              ; $43DB
    ret                                           ; $43E0


; C: Left/Right = print_intensity
Mode1C_State05_OptionDensity::
    call Mode1C_ReadDensityKeys                   ; $43E1
    call Mode1C_DrawDensityMarker                 ; $43E4
    ldh a, [hKeysNew]                             ; $43E7
    and PADF_A | PADF_B | PADF_DOWN               ; $43E9
    ret z                                         ; $43EB

    push af                                       ; $43EC
    bit 0, a                                      ; $43ED
    ld a, SFX1_KEY_A                              ; $43EF
    call nz, Snd_Sfx1                             ; $43F1
    pop af                                        ; $43F4
    push af                                       ; $43F5
    bit 1, a                                      ; $43F6
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $43F8
    call nz, Snd_Sfx1                             ; $43FA
    pop af                                        ; $43FD
    push af                                       ; $43FE
    bit 7, a                                      ; $43FF
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4401
    call nz, Snd_Sfx1                             ; $4403
    pop af                                        ; $4406
    push af                                       ; $4407
    call Oam_ClearShadow                          ; $4408
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $440B
    ld b, $10                                     ; $440E

jr_008_4410:
    push bc                                       ; $4410
    push hl                                       ; $4411
    ldh a, [hScyShadow]                           ; $4412
    sub [hl]                                      ; $4414
    ldh [hScyShadow], a                           ; $4415
    cpl                                           ; $4417
    add $64                                       ; $4418
    ldh [hLycShadowSplit1], a                     ; $441A
    rst Rst08_WaitVBlank                          ; $441C
    pop hl                                        ; $441D
    pop bc                                        ; $441E
    inc hl                                        ; $441F
    dec b                                         ; $4420
    jr nz, jr_008_4410                            ; $4421

    ldh [hFarcallAArg], a                         ; $4423
    farcall Counters_Store_Far                    ; $4425
    pop af                                        ; $442D
    bit 0, a                                      ; $442E
    jr nz, jr_008_4438                            ; $4430

    set_state STATE_1C_OPTIONS_MENU               ; $4432
    ret                                           ; $4437


jr_008_4438:
    call Mode1C_DrawPrintScreen                   ; $4438
    set_state STATE_1C_PRINT_MAIN                 ; $443B
    ret                                           ; $4440


; C: cap $7F; sound $22
Mode1C_ReadDensityKeys::
    ld a, [wPrintIntensity]                       ; $4441
    ld hl, hKeysHeld                              ; $4444
    bit 5, [hl]                                   ; $4447
    jr z, jr_008_4450                             ; $4449

    and a                                         ; $444B
    ret z                                         ; $444C

    dec a                                         ; $444D
    jr jr_008_4457                                ; $444E

jr_008_4450:
    bit 4, [hl]                                   ; $4450
    ret z                                         ; $4452

    cp $7f                                        ; $4453
    ret z                                         ; $4455

    inc a                                         ; $4456

jr_008_4457:
    ld [wPrintIntensity], a                       ; $4457
    ldh a, [hKeysNewRepeat]                       ; $445A
    and PADF_RIGHT | PADF_LEFT                    ; $445C
    ret z                                         ; $445E

    play_sfx1 SFX1_DIRECTION_KEY                  ; $445F
    ret                                           ; $4466


; C
Mode1C_DrawDensityMarker::
    ld a, [wPrintIntensity]                       ; $4467
    ld l, $b7                                     ; $446A
    call Math_MulAL                               ; $446C
    ld bc, $0080                                  ; $446F
    add hl, bc                                    ; $4472
    ld a, h                                       ; $4473
    add $23                                       ; $4474
    ld b, a                                       ; $4476
    ld c, $0b                                     ; $4477
    ldh a, [hKeysHeld]                            ; $4479
    and PADF_RIGHT | PADF_LEFT                    ; $447B
    jr nz, jr_008_4483                            ; $447D

    ld a, $c6                                     ; $447F
    jr jr_008_4485                                ; $4481

jr_008_4483:
    ld a, $c7                                     ; $4483

jr_008_4485:
    call Oam_AddMeta_B02_52BD                     ; $4485
    ret                                           ; $4488


; C: Left/Right toggles D674; two tile variants; BGB watchpoint pass 2026-10-25: ran only in mode 1C and state 06
; (3256 hits in 10 runs: 1C:06 x3256; tcrf_check/assets/mode_state_wp/)
Mode1C_State06_OptionToggle::
    call Mode1C_ReadToggleKeys                    ; $4489
    call Mode1C_DrawToggleArrow                   ; $448C
    ldh a, [hKeysNew]                             ; $448F
    and PADF_A | PADF_B | PADF_UP                 ; $4491
    ret z                                         ; $4493

    push af                                       ; $4494
    bit 0, a                                      ; $4495
    ld a, SFX1_KEY_START                          ; $4497
    call nz, Snd_Sfx1                             ; $4499
    pop af                                        ; $449C
    push af                                       ; $449D
    bit 1, a                                      ; $449E
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $44A0
    call nz, Snd_Sfx1                             ; $44A2
    pop af                                        ; $44A5
    push af                                       ; $44A6
    bit 6, a                                      ; $44A7
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $44A9
    call nz, Snd_Sfx1                             ; $44AB
    pop af                                        ; $44AE
    push af                                       ; $44AF
    bit 0, a                                      ; $44B0
    jr z, jr_008_44cd                             ; $44B2

    ld hl, wArrowAnimFrame                        ; $44B4
    inc [hl]                                      ; $44B7
    call Oam_HideUnused                           ; $44B8
    rst Rst08_WaitVBlank                          ; $44BB
    call Mode1C_LoadToggleTiles                   ; $44BC

jr_008_44bf:
    call Mode1C_DrawToggleArrow                   ; $44BF
    call Oam_HideUnused                           ; $44C2
    rst Rst08_WaitVBlank                          ; $44C5
    ld a, [wArrowAnimFrame]                       ; $44C6
    cp $02                                        ; $44C9
    jr nz, jr_008_44bf                            ; $44CB

jr_008_44cd:
    call Oam_ClearShadow                          ; $44CD
    ld hl, Slide_ScyDeltaTbl                      ; $44D0
    ld b, $10                                     ; $44D3

jr_008_44d5:
    push bc                                       ; $44D5
    push hl                                       ; $44D6
    ldh a, [hScyShadow]                           ; $44D7
    add [hl]                                      ; $44D9
    ldh [hScyShadow], a                           ; $44DA
    cpl                                           ; $44DC
    add $64                                       ; $44DD
    ldh [hLycShadowSplit1], a                     ; $44DF
    call Oam_HideUnused                           ; $44E1
    rst Rst08_WaitVBlank                          ; $44E4
    pop hl                                        ; $44E5
    pop bc                                        ; $44E6
    inc hl                                        ; $44E7
    dec b                                         ; $44E8
    jr nz, jr_008_44d5                            ; $44E9

    pop af                                        ; $44EB
    bit 0, a                                      ; $44EC
    jr nz, jr_008_44f6                            ; $44EE

    set_state STATE_1C_OPTIONS_MENU               ; $44F0
    ret                                           ; $44F5


jr_008_44f6:
    ld a, [wChoiceCursorA]                        ; $44F6
    and a                                         ; $44F9
    jr nz, jr_008_4502                            ; $44FA

    set_state STATE_1C_FADE_TO_BORDER_PICKER      ; $44FC
    ret                                           ; $4501


jr_008_4502:
    set_state STATE_1C_FADE_TO_WILD_PICKER        ; $4502
    ret                                           ; $4507


; C: BGB watchpoint pass 2026-10-25: ran only in mode 1C (7 hits in 7 runs: 1C:06 x7;
; tcrf_check/assets/mode_state_wp/)
Mode1C_LoadToggleTiles::
    ld a, [wChoiceCursorA]                        ; $4508
    and a                                         ; $450B
    jr nz, jr_008_451d                            ; $450C

    farcopy Vram_CopyFromBank, Gfx_18_7900_Mode1C_LoadToggleTiles, $8df0, $00c0 ; $450E
    ret                                           ; $451C


jr_008_451d:
    farcopy Vram_CopyFromBank, Gfx_18_79C0_Mode1C_LoadToggleTiles, $8ef0, $00c0 ; $451D
    ret                                           ; $452B


; C
Mode1C_ReadToggleKeys::
    ldh a, [hKeysNew]                             ; $452C
    bit PADB_LEFT, a                              ; $452E
    jr z, jr_008_4535                             ; $4530

    xor a                                         ; $4532
    jr jr_008_453a                                ; $4533

jr_008_4535:
    bit 4, a                                      ; $4535
    ret z                                         ; $4537

    ld a, $01                                     ; $4538

jr_008_453a:
    ld [wChoiceCursorA], a                        ; $453A
    play_sfx1 SFX1_STEP_VALUE                     ; $453D
    ret                                           ; $4544


; C: BGB watchpoint pass 2026-10-25: ran only in mode 1C (1712 hits in 10 runs: 1C:06 x1712;
; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawToggleArrow::
    ld a, [wChoiceCursorA]                        ; $4545
    sla a                                         ; $4548
    ld c, a                                       ; $454A
    ld b, $00                                     ; $454B
    ld hl, Mode1C_ToggleArrowPosTbl               ; $454D
    add hl, bc                                    ; $4550
    ld c, [hl]                                    ; $4551
    inc hl                                        ; $4552
    ld b, [hl]                                    ; $4553
    ld a, [wArrowAnimFrame]                       ; $4554
    cp $05                                        ; $4557
    ret z                                         ; $4559

    sla a                                         ; $455A
    push bc                                       ; $455C
    ld c, a                                       ; $455D
    ld b, $00                                     ; $455E
    ld hl, Mode1C_ToggleArrowAnimTbl              ; $4560
    add hl, bc                                    ; $4563
    ld a, [hl+]                                   ; $4564
    pop bc                                        ; $4565
    push hl                                       ; $4566
    call Oam_AddMeta_B01_4000                     ; $4567
    pop hl                                        ; $456A
    ld a, [wArrowAnimTick]                        ; $456B
    cp [hl]                                       ; $456E
    jr nz, jr_008_4579                            ; $456F

    ld hl, wArrowAnimFrame                        ; $4571
    inc [hl]                                      ; $4574
    xor a                                         ; $4575
    ld [wArrowAnimTick], a                        ; $4576

jr_008_4579:
    ld a, [wArrowAnimFrame]                       ; $4579
    and a                                         ; $457C
    ret z                                         ; $457D

    ld hl, wArrowAnimTick                         ; $457E
    inc [hl]                                      ; $4581
    ret                                           ; $4582


; C: BGB watchpoint pass 2026-10-25: ran only in mode 1C (710 hits in 2 runs: 1C:06 x710;
; tcrf_check/assets/mode_state_wp/)
Mode1C_ToggleArrowPosTbl::
    db $80, $28, $80, $78

; C: 3 x {OAM list id; ticks}: frame 0 = $BC (resting, no tick), frame 1 = $BD for $0B ticks, frame 2 = $BD, $FF;
; frame wArrowAnimFrame, tick $D51F; Mode1C_DrawToggleArrow (08:4560); the A-press loop of Mode1C_State06_OptionToggle
; (08:44B4) runs frames 1 to 2 (read 2026-10-25)
Mode1C_ToggleArrowAnimTbl::
    db $bc, $10, $bd, $0b, $bd, $ff

; C: A -> print job (state 8); B -> back
Mode1C_State07_Leave::
    screen_off                                    ; $458D
    stat_irq_off                                  ; $4593
    ld a, [wAbResult]                             ; $459D
    bit 0, a                                      ; $45A0
    jr z, jr_008_45b5                             ; $45A2

    xor a                                         ; $45A4
    ld [wPrintJobIndex], a                        ; $45A5
    ld [wPrintAbortFlag], a                       ; $45A8
    ld a, $01                                     ; $45AB
    ld [wPrintFirstPhotoFlag], a                  ; $45AD
    next_state                                    ; $45B0
    ret                                           ; $45B4


jr_008_45b5:
    ld a, [wCallerCode]                           ; $45B5
    and a                                         ; $45B8
    jr nz, jr_008_45c1                            ; $45B9

    set_state STATE_1C_INIT                       ; $45BB
    ret                                           ; $45C0


jr_008_45c1:
    cp $01                                        ; $45C1
    jr nz, jr_008_45d0                            ; $45C3

    ld a, MODE_ALBUM_EDIT                         ; $45C5
    ld [wMode], a                                 ; $45C7
    set_state STATE_09_INIT                       ; $45CA
    ret                                           ; $45CF


jr_008_45d0:
    ld a, $01                                     ; $45D0
    ld [wAbResult], a                             ; $45D2
    ld a, MODE_ALBUM_VIEW                         ; $45D5
    ld [wMode], a                                 ; $45D7
    set_state STATE_0A_SETUP                      ; $45DA
    ret                                           ; $45DF


; C: builds the print job and sends it
Mode1C_State08_PrintJob::
    ld a, [wPrintAbortFlag]                       ; $45E0
    and a                                         ; $45E3
    jr nz, jr_008_45f8                            ; $45E4

    ld a, [wPrintJobIndex]                        ; $45E6
    and a                                         ; $45E9
    jr z, jr_008_45fe                             ; $45EA

    cp $01                                        ; $45EC
    jr nz, jr_008_45f8                            ; $45EE

    ld a, [wPrintExtraFlag]                       ; $45F0
    bit 0, a                                      ; $45F3
    jp nz, Mode1C_State08_PrintJob_CommentCard    ; $45F5

jr_008_45f8:
    set_state STATE_1C_SHOW_PRINT_SCREEN          ; $45F8
    ret                                           ; $45FD


jr_008_45fe:
    ld hl, wPrintJobIndex                         ; $45FE
    inc [hl]                                      ; $4601
    ld a, [wPrintLayoutFlag]                      ; $4602
    and a                                         ; $4605
    jr z, jr_008_460a                             ; $4606

    jr jr_008_4656                                ; $4608

jr_008_460a:
    ld a, [wCopyPhotoIdxB]                        ; $460A
    ldh [hFarcallAArg], a                         ; $460D
    farcall Photo_GetSramAddress_Far              ; $460F
    ld [wPrintSrcTable + $2], a                   ; $4617
    ld a, b                                       ; $461A
    ld [wPrintSrcTable + $1], a                   ; $461B
    ld a, c                                       ; $461E
    ld [wPrintSrcTable], a                        ; $461F
    ldh [hFarcallAArg], a                         ; $4622
    ld a, $08                                     ; $4624
    ld hl, Border_FillPrintSource                 ; $4626
    call Far_Call                                 ; $4629
    xor a                                         ; $462C
    ld [wPrintLayoutType], a                      ; $462D
    ld [wPrintReturnIdx], a                       ; $4630
    xor a                                         ; $4633
    ld [wPrintCustomMargin], a                    ; $4634
    ld [wPrintPages], a                           ; $4637
    ld a, [wPrintExtraFlag]                       ; $463A
    bit 0, a                                      ; $463D
    jr z, jr_008_464b                             ; $463F

    ld a, $01                                     ; $4641
    ld [wPrintCustomMargin], a                    ; $4643
    ld a, $10                                     ; $4646
    ld [wPrintMarginByte], a                      ; $4648

jr_008_464b:
    ld a, MODE_PRINT_JOB                          ; $464B
    ld [wMode], a                                 ; $464D
    set_state STATE_1D_INIT                       ; $4650
    ret                                           ; $4655


jr_008_4656:
    ld a, [wCopyPhotoIdxB]                        ; $4656
    ldh [hFarcallAArg], a                         ; $4659
    farcall Photo_GetSramAddress_Far              ; $465B
    ld [wPrintSrcTable + $2], a                   ; $4663
    ld a, b                                       ; $4666
    ld [wPrintSrcTable + $1], a                   ; $4667
    ld a, c                                       ; $466A
    ld [wPrintSrcTable], a                        ; $466B
    ldh [hFarcallAArg], a                         ; $466E
    ld a, $08                                     ; $4670
    ld hl, WildFrame_LoadForPrintJob              ; $4672
    call Far_Call                                 ; $4675
    ld a, $01                                     ; $4678
    ld [wPrintLayoutType], a                      ; $467A
    ld [wPrintReturnIdx], a                       ; $467D
    xor a                                         ; $4680
    ld [wPrintCustomMargin], a                    ; $4681
    ld [wPrintPages], a                           ; $4684
    ld a, [wPrintExtraFlag]                       ; $4687
    bit 0, a                                      ; $468A
    jr z, jr_008_4698                             ; $468C

    ld a, $01                                     ; $468E
    ld [wPrintCustomMargin], a                    ; $4690
    ld a, $10                                     ; $4693
    ld [wPrintMarginByte], a                      ; $4695

jr_008_4698:
    ld a, MODE_PRINT_JOB                          ; $4698
    ld [wMode], a                                 ; $469A
    set_state STATE_1D_INIT                       ; $469D
    ret                                           ; $46A2


; C: branch taken when $D806 bit 0 is set: the comment-card print job (08:46A3-4777; card layout routines in bank 9)
; (branch target; code read 2026-10-19)
Mode1C_State08_PrintJob_CommentCard::
    ld hl, wPrintJobIndex                         ; $46A3
    inc [hl]                                      ; $46A6
    ld a, [wCopyPhotoIdxB]                        ; $46A7
    ld [wCmtPhotoIndex], a                        ; $46AA
    ldh [hFarcallAArg], a                         ; $46AD
    farcall Photo_LoadTagFields_Far               ; $46AF
    ld a, $1b                                     ; $46B7
    ld hl, Gfx_1B_4000_Mode1C_State08_PrintJob    ; $46B9
    ld de, $9000                                  ; $46BC
    ld bc, $0800                                  ; $46BF
    call Mem_CopyFromBank                         ; $46C2
    farcopy Mem_CopyFromBank, Gfx_1B_4800_Mode1C_State08_PrintJob, $8800, $0800 ; $46C5
    ldh [hFarcallAArg], a                         ; $46D3
    farcall CommentCard_UploadThumbnail_Far       ; $46D5
    ldh [hFarcallAArg], a                         ; $46DD
    farcall CommentCard_DrawComment_Far           ; $46DF
    ldh [hFarcallAArg], a                         ; $46E7
    farcall CommentCard_DrawOwnerName_Far         ; $46E9
    ldh [hFarcallAArg], a                         ; $46F1
    farcall CommentCard_DrawGender_Far            ; $46F3
    ldh [hFarcallAArg], a                         ; $46FB
    farcall CommentCard_DrawBlood_Far             ; $46FD
    ldh [hFarcallAArg], a                         ; $4705
    farcall CommentCard_DrawBirthDate_Far         ; $4707
    ldh [hFarcallAArg], a                         ; $470F
    farcall CommentCard_DrawCounters_Far          ; $4711
    ldh [hFarcallAArg], a                         ; $4719
    farcall CommentCard_DrawTotal_Far             ; $471B
    ldh [hFarcallAArg], a                         ; $4723
    farcall CommentCard_DrawCopyBadge_Far         ; $4725
    ldh [hFarcallAArg], a                         ; $472D
    farcall CommentCard_DrawPhotoNumber_Far       ; $472F
    ld hl, $9000                                  ; $4737
    ld de, wPrintReadback                         ; $473A
    ld bc, $0800                                  ; $473D
    call Mem_Copy                                 ; $4740
    ld hl, $8800                                  ; $4743
    ld de, wPrintReadback + $800                  ; $4746
    ld bc, $0700                                  ; $4749
    call Mem_Copy                                 ; $474C
    xor a                                         ; $474F
    ld [wPrintSrcTable + $2], a                   ; $4750
    ld a, $c0                                     ; $4753
    ld [wPrintSrcTable + $1], a                   ; $4755
    ld a, $00                                     ; $4758
    ld [wPrintSrcTable], a                        ; $475A
    ld a, $04                                     ; $475D
    ld [wPrintLayoutType], a                      ; $475F
    xor a                                         ; $4762
    ld [wPrintReturnIdx], a                       ; $4763
    ld a, $01                                     ; $4766
    ld [wPrintCustomMargin], a                    ; $4768
    ld a, $13                                     ; $476B
    ld [wPrintMarginByte], a                      ; $476D
    xor a                                         ; $4770
    ld [wPrintPages], a                           ; $4771
    ld a, MODE_PRINT_JOB                          ; $4774
    ld [wMode], a                                 ; $4776
    set_state STATE_1D_INIT                       ; $4779
    ret                                           ; $477E


; C
Mode1C_State09_FadeToBorderPicker::
    screen_off                                    ; $477F
    stat_irq_off                                  ; $4785
    xor a                                         ; $478F
    ld [wSubstate], a                             ; $4790
    next_state                                    ; $4793
    ret                                           ; $4797


; C: far call 08:4DF2
Mode1C_State0A_BorderPicker::
    ldh [hFarcallAArg], a                         ; $4798
    ld a, $08                                     ; $479A
    ld hl, BorderPicker_Far                       ; $479C
    call Far_Call                                 ; $479F
    ret                                           ; $47A2


; C: far 02:48F7; then state 2 again
Mode1C_State0B_AfterBorder::
    ld a, [wCopyPhotoIdxB]                        ; $47A3
    ldh [hFarcallAArg], a                         ; $47A6
    farcall Photo_StoreBorder_Far                 ; $47A8
    ld a, $01                                     ; $47B0
    ld [wAbResult], a                             ; $47B2
    xor a                                         ; $47B5
    ld [wPrintLayoutFlag], a                      ; $47B6
    jp Mode1C_State02_ShowPrintScreen             ; $47B9


; C
Mode1C_State0C_FadeToWildPicker::
    screen_off                                    ; $47BC
    stat_irq_off                                  ; $47C2
    xor a                                         ; $47CC
    ld [wSubstate], a                             ; $47CD
    next_state                                    ; $47D0
    ret                                           ; $47D4


; C: far call 08:5191
Mode1C_State0D_WildFramePicker::
    ldh [hFarcallAArg], a                         ; $47D5
    ld a, $08                                     ; $47D7
    ld hl, WildFramePicker_Far                    ; $47D9
    call Far_Call                                 ; $47DC
    ret                                           ; $47DF


; C: print_layout_flag := 1; then state 2
Mode1C_State0E_AfterWildFrame::
    ld a, $01                                     ; $47E0
    ld [wAbResult], a                             ; $47E2
    ld a, $01                                     ; $47E5
    ld [wPrintLayoutFlag], a                      ; $47E7
    jp Mode1C_State02_ShowPrintScreen             ; $47EA


; I: tilemap 27:4472 and border tiles; BGB watchpoint pass 2026-10-25: ran only in mode 1C (4 hits in 2 runs: 1C:05
; x4; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawPrintScreen::
    call Oam_ClearShadow                          ; $47ED
    ld a, $08                                     ; $47F0
    ld hl, Gfx_08_48B1_Mode1C_DrawPrintScreen     ; $47F2
    ld de, $8ff0                                  ; $47F5
    ld bc, $0010                                  ; $47F8
    call Vram_CopyFromBank                        ; $47FB
    farcopy Vram_CopyFromBank, Map_20_7502_Mode1C_DrawPrintScreen, $9800, $02c0 ; $47FE
    farcopy Vram_CopyFromBank, Gfx_18_7F60_Mode1C_State02_ShowPrintScreen, $8f00, $0050 ; $480C
    ld a, [wPrintLayoutFlag]                      ; $481A
    and a                                         ; $481D
    jr nz, jr_008_484e                            ; $481E

    ld a, [wBorderNormalised]                     ; $4820
    and a                                         ; $4823
    jr nz, jr_008_4843                            ; $4824

    ld a, [wCopyPhotoIdxB]                        ; $4826
    ldh [hFarcallAArg], a                         ; $4829
    farcall Photo_LoadBorder_Far                  ; $482B
    ld a, [wBorderNumber]                         ; $4833
    cp $12                                        ; $4836
    jr nz, jr_008_4843                            ; $4838

    xor a                                         ; $483A
    ld [wBorderNumber], a                         ; $483B
    ld a, $01                                     ; $483E
    ld [wBorderNormalised], a                     ; $4840

jr_008_4843:
    ldh [hFarcallAArg], a                         ; $4843
    ld a, $08                                     ; $4845
    ld hl, Border_LoadMap_Safe                    ; $4847
    call Far_Call                                 ; $484A
    ret                                           ; $484D


jr_008_484e:
    ldh [hFarcallAArg], a                         ; $484E
    ld a, $08                                     ; $4850
    ld hl, WildFrame_LoadForOptionScreen          ; $4852
    call Far_Call                                 ; $4855
    ret                                           ; $4858


; I: BGB watchpoint pass 2026-10-25: ran only in mode 1C (30 hits in 13 runs: 1C:03 x30;
; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawOptionScreen::
    call Oam_ClearShadow                          ; $4859
    ld a, $08                                     ; $485C
    ld hl, Gfx_08_48B1_Mode1C_DrawPrintScreen     ; $485E
    ld de, $8ff0                                  ; $4861
    ld bc, $0010                                  ; $4864
    call Vram_CopyFromBank                        ; $4867
    farcopy Vram_CopyFromBank, Map_20_7502_Mode1C_DrawPrintScreen, $9800, $02c0 ; $486A
    farcopy Vram_CopyFromBank, Gfx_18_7400_Mode1C_State02_ShowPrintScreen, $8b00, $0500 ; $4878
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $4886
    farcopy Vram_CopyFromBank, Map_24_6BA0_Mode1C_State02_ShowPrintScreen, $9800, $02c0 ; $4894
    ld a, $08                                     ; $48A2
    ld hl, Gfx_08_48C1_Mode1C_DrawOptionScreen    ; $48A4
    ld de, $8ff0                                  ; $48A7
    ld bc, $0010                                  ; $48AA
    call Vram_CopyFromBank                        ; $48AD
    ret                                           ; $48B0


; C: loaded by Vram_CopyFromBank at 08:47FB: Gfx $10 bytes to $8FF0 (this build's trace)
Gfx_08_48B1_Mode1C_DrawPrintScreen::
    INCBIN "data/bank_08/Gfx_08_48B1_Mode1C_DrawPrintScreen.2bpp" ; $48B1, 16 bytes
; C: loaded by Vram_CopyFromBank at 08:48AD: Gfx $10 bytes to $8FF0 (this build's trace)
Gfx_08_48C1_Mode1C_DrawOptionScreen::
    INCBIN "data/bank_08/Gfx_08_48C1_Mode1C_DrawOptionScreen.2bpp" ; $48C1, 16 bytes
; C: mode 1E: multi-photo print (margin; selection bitmap; job)
Mode1E_PrintOption::
    ld a, [wState]                                ; $48D1
    rst Rst18_JumpTable                           ; $48D4

; I: 6 states
Mode1E_StateTable::
    dw Mode1E_State00_Init
    dw Mode1E_State01_Page1Margin
    dw Mode1E_State02_Page2SelectPhotos
    dw Mode1E_State03_Page3Confirm
    dw Mode1E_State04_Leave
    dw Mode1E_State05_PrintJob

; C
Mode1E_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $48E1
    ldh [hLcdcShadow], a                          ; $48E3
    ld a, $e4                                     ; $48E5
    ld [wPaletteTarget], a                        ; $48E7
    ld [wPaletteTarget + $1], a                   ; $48EA
    ld a, $d2                                     ; $48ED
    ld [wPaletteTarget + $2], a                   ; $48EF
    xor a                                         ; $48F2
    ldh [hScxShadow], a                           ; $48F3
    ldh [hScyShadow], a                           ; $48F5
    ld [wPrintCursor], a                          ; $48F7
    ldh [hFarcallAArg], a                         ; $48FA
    farcall Counters_Load_Far                     ; $48FC
    farcopy Mem_CopyFromBank, Gfx_18_5470_Mode1E_State00_Init, $9000, $0800 ; $4904
    farcopy Mem_CopyFromBank, Gfx_18_5C70_Mode1E_State00_Init, $8800, $0800 ; $4912
    farcopy Mem_CopyFromBank, Map_26_5580_Mode1E_State00_Init, $9800, $0240 ; $4920
    screen_on                                     ; $492E
    play_music MUSIC_TIMER_PRINT_OPTIONS          ; $4937
    call Print_LoadCursorThumbnail                ; $493E
    call Print_LoadSelectedDigit                  ; $4941
    call Print_DrawMarginDigit                    ; $4944
    call Print_DrawSelectedCount                  ; $4947
    call Print_DrawPageNumbers                    ; $494A
    call Print_DrawPageIcon                       ; $494D
    ld e, $00                                     ; $4950
    call Print_DrawPageArrow                      ; $4952
    call Pal_FadeIn                               ; $4955
    next_state                                    ; $4958
    ret                                           ; $495C


; C: margin lines 0..9
Mode1E_State01_Page1Margin::
    call Print_IdleThumbnailRefresh               ; $495D
    call Mode1E_ReadMarginKeys                    ; $4960
    call Print_DrawPageIcon                       ; $4963
    ld e, $01                                     ; $4966
    call Print_DrawPageArrow                      ; $4968
    ld bc, $0000                                  ; $496B
    call Print_DrawBlinkingCursor                 ; $496E
    ldh a, [hKeysNew]                             ; $4971
    ld b, a                                       ; $4973
    ld [wAbResult], a                             ; $4974
    and PADF_A | PADF_DOWN                        ; $4977
    jr z, jr_008_4992                             ; $4979

    push af                                       ; $497B
    bit 0, a                                      ; $497C
    ld a, SFX1_KEY_A                              ; $497E
    call nz, Snd_Sfx1                             ; $4980
    pop af                                        ; $4983
    push af                                       ; $4984
    bit 7, a                                      ; $4985
    ld a, SFX1_KEY_UP_DOWN                        ; $4987
    call nz, Snd_Sfx1                             ; $4989
    pop af                                        ; $498C
    next_state                                    ; $498D
    ret                                           ; $4991


jr_008_4992:
    bit 1, b                                      ; $4992
    ret z                                         ; $4994

    play_sfx1 SFX1_KEY_B                          ; $4995
    set_state STATE_1E_LEAVE                      ; $499C
    ret                                           ; $49A1


; C
Mode1E_ReadMarginKeys::
    ldh a, [hKeysNewRepeat]                       ; $49A2
    ld b, a                                       ; $49A4
    ld a, [wPrintMarginLines]                     ; $49A5
    bit 5, b                                      ; $49A8
    jr z, jr_008_49b1                             ; $49AA

    and a                                         ; $49AC
    ret z                                         ; $49AD

    dec a                                         ; $49AE
    jr jr_008_49b8                                ; $49AF

jr_008_49b1:
    bit 4, b                                      ; $49B1
    ret z                                         ; $49B3

    cp $09                                        ; $49B4
    ret z                                         ; $49B6

    inc a                                         ; $49B7

jr_008_49b8:
    ld hl, wPrintMarginLines                      ; $49B8
    cp [hl]                                       ; $49BB
    ret z                                         ; $49BC

    ld [hl], a                                    ; $49BD
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $49BE
    call Print_DrawMarginDigit                    ; $49C5
    ret                                           ; $49C8


; C: cursor 0..29 and selection bitmap D808
Mode1E_State02_Page2SelectPhotos::
    call Print_IdleThumbnailRefresh               ; $49C9
    call Mode1E_ToggleSelection                   ; $49CC
    call Mode1E_MoveCursor                        ; $49CF
    call Print_DrawPageIcon                       ; $49D2
    call Print_DrawCursorMarker                   ; $49D5
    call Print_DrawSelectedMarker                 ; $49D8
    ld e, $00                                     ; $49DB
    call Print_DrawPageArrow                      ; $49DD
    ld a, [wPrintCursor]                          ; $49E0
    sla a                                         ; $49E3
    sla a                                         ; $49E5
    ld b, a                                       ; $49E7
    ld c, $03                                     ; $49E8
    call Print_DrawBlinkingCursor                 ; $49EA
    ldh a, [hKeysNew]                             ; $49ED
    ld b, a                                       ; $49EF
    ld [wAbResult], a                             ; $49F0
    bit 7, b                                      ; $49F3
    jr z, jr_008_4a03                             ; $49F5

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $49F7
    next_state                                    ; $49FE
    ret                                           ; $4A02


jr_008_4a03:
    bit 6, b                                      ; $4A03
    jr z, jr_008_4a13                             ; $4A05

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4A07
    ld hl, wState                                 ; $4A0E
    dec [hl]                                      ; $4A11
    ret                                           ; $4A12


jr_008_4a13:
    bit 1, b                                      ; $4A13
    ret z                                         ; $4A15

    play_sfx1 SFX1_KEY_B                          ; $4A16
    set_state STATE_1E_LEAVE                      ; $4A1D
    ret                                           ; $4A22


; C: A toggles the photo under the cursor
Mode1E_ToggleSelection::
    ldh a, [hKeysNewSticky]                       ; $4A23
    bit PADB_A, a                                 ; $4A25
    ret z                                         ; $4A27

    ld a, [wPrintCursor]                          ; $4A28
    ld hl, wPhotoCount                            ; $4A2B
    cp [hl]                                       ; $4A2E
    jr c, jr_008_4a39                             ; $4A2F

    play_sfx1 SFX1_KEY_B                          ; $4A31
    ret                                           ; $4A38


jr_008_4a39:
    call Print_ToggleSelectBit                    ; $4A39
    jr nz, jr_008_4a47                            ; $4A3C

    play_sfx1 SFX1_KEY_A                          ; $4A3E
    jr jr_008_4a4e                                ; $4A45

jr_008_4a47:
    play_sfx1 SFX1_MENU_CHOOSE                    ; $4A47

jr_008_4a4e:
    ld a, [wPrintCursor]                          ; $4A4E
    call Print_DrawSelectionDigits                ; $4A51
    call Print_DrawSelectedCount                  ; $4A54
    ret                                           ; $4A57


; C
Mode1E_MoveCursor::
    ldh a, [hKeysRepeatSticky]                    ; $4A58
    ld b, a                                       ; $4A5A
    ld a, [wPrintCursor]                          ; $4A5B
    bit 5, b                                      ; $4A5E
    jr z, jr_008_4a67                             ; $4A60

    and a                                         ; $4A62
    ret z                                         ; $4A63

    dec a                                         ; $4A64
    jr jr_008_4a6e                                ; $4A65

jr_008_4a67:
    bit 4, b                                      ; $4A67
    ret z                                         ; $4A69

    cp $1d                                        ; $4A6A
    ret z                                         ; $4A6C

    inc a                                         ; $4A6D

jr_008_4a6e:
    ld hl, wPrintCursor                           ; $4A6E
    cp [hl]                                       ; $4A71
    ret z                                         ; $4A72

    ld [hl], a                                    ; $4A73
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4A74
    call Print_LoadCursorThumbnail                ; $4A7B
    call Print_LoadSelectedDigit                  ; $4A7E
    ret                                           ; $4A81


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Mode1E_State03_Page3Confirm::
    call Print_IdleThumbnailRefresh               ; $4A82
    call Print_DrawPageIcon                       ; $4A85
    ld e, $00                                     ; $4A88
    call Print_DrawPageArrow                      ; $4A8A
    ld bc, $0006                                  ; $4A8D
    call Print_DrawBlinkingCursor                 ; $4A90
    ldh a, [hKeysNew]                             ; $4A93
    ld b, a                                       ; $4A95
    ld [wAbResult], a                             ; $4A96
    bit 0, b                                      ; $4A99
    jr z, jr_008_4aa9                             ; $4A9B

    play_sfx1 SFX1_KEY_A                          ; $4A9D
    next_state                                    ; $4AA4
    ret                                           ; $4AA8


jr_008_4aa9:
    bit 6, b                                      ; $4AA9
    jr z, jr_008_4ab9                             ; $4AAB

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4AAD
    ld hl, wState                                 ; $4AB4
    dec [hl]                                      ; $4AB7
    ret                                           ; $4AB8


jr_008_4ab9:
    bit 1, b                                      ; $4AB9
    ret z                                         ; $4ABB

    play_sfx1 SFX1_KEY_B                          ; $4ABC
    next_state                                    ; $4AC3
    ret                                           ; $4AC7


; C: A starts the job: print_job_index := 0
Mode1E_State04_Leave::
    screen_off                                    ; $4AC8
    ld a, [wAbResult]                             ; $4ACE
    bit 1, a                                      ; $4AD1
    jr nz, jr_008_4ae6                            ; $4AD3

    xor a                                         ; $4AD5
    ld [wPrintJobIndex], a                        ; $4AD6
    ld [wPrintAbortFlag], a                       ; $4AD9
    ld a, $01                                     ; $4ADC
    ld [wPrintFirstPhotoFlag], a                  ; $4ADE
    next_state                                    ; $4AE1
    ret                                           ; $4AE5


jr_008_4ae6:
    ld a, MODE_PRINT_MENU                         ; $4AE6
    ld [wMode], a                                 ; $4AE8
    set_state STATE_1B_INIT                       ; $4AEB
    ret                                           ; $4AF0


; C
Mode1E_State05_PrintJob::
    ld a, [wPrintAbortFlag]                       ; $4AF1
    and a                                         ; $4AF4
    jr nz, jr_008_4afe                            ; $4AF5

    ld a, [wPrintJobIndex]                        ; $4AF7
    cp $3c                                        ; $4AFA
    jr c, jr_008_4b04                             ; $4AFC

jr_008_4afe:
    set_state STATE_1E_INIT                       ; $4AFE
    ret                                           ; $4B03


jr_008_4b04:
    srl a                                         ; $4B04
    srl a                                         ; $4B06
    srl a                                         ; $4B08
    ld c, a                                       ; $4B0A
    ld b, $00                                     ; $4B0B
    ld hl, wPrintSelectBitmap                     ; $4B0D
    add hl, bc                                    ; $4B10
    push hl                                       ; $4B11
    ld a, [wPrintJobIndex]                        ; $4B12
    and $07                                       ; $4B15
    ld c, a                                       ; $4B17
    ld b, $00                                     ; $4B18
    ld hl, Print_BitMaskTbl                       ; $4B1A
    add hl, bc                                    ; $4B1D
    ld a, [hl]                                    ; $4B1E
    pop hl                                        ; $4B1F
    and [hl]                                      ; $4B20
    jr z, jr_008_4b8d                             ; $4B21

    ld a, [wPrintJobIndex]                        ; $4B23
    ldh [hFarcallAArg], a                         ; $4B26
    farcall Photo_GetSramAddress_Far              ; $4B28
    ld [wPrintSrcTable + $2], a                   ; $4B30
    ld a, b                                       ; $4B33
    ld [wPrintSrcTable + $1], a                   ; $4B34
    ld a, c                                       ; $4B37
    ld [wPrintSrcTable], a                        ; $4B38
    ld a, [wPrintJobIndex]                        ; $4B3B
    ldh [hFarcallAArg], a                         ; $4B3E
    farcall Photo_LoadBorder_Far                  ; $4B40
    ldh [hFarcallAArg], a                         ; $4B48
    ld a, $08                                     ; $4B4A
    ld hl, Border_FillPrintSource                 ; $4B4C
    call Far_Call                                 ; $4B4F
    xor a                                         ; $4B52
    ld [wPrintLayoutType], a                      ; $4B53
    ld a, $04                                     ; $4B56
    ld [wPrintReturnIdx], a                       ; $4B58
    ld a, $01                                     ; $4B5B
    ld [wPrintCustomMargin], a                    ; $4B5D
    ld [wPrintPages], a                           ; $4B60
    ld b, $00                                     ; $4B63
    ld a, [wPrintMarginLines]                     ; $4B65
    ld c, a                                       ; $4B68
    ld a, [wPrintFirstPhotoFlag]                  ; $4B69
    and a                                         ; $4B6C
    jr z, jr_008_4b71                             ; $4B6D

    ld b, $10                                     ; $4B6F

jr_008_4b71:
    push bc                                       ; $4B71
    call Print_TestSelectBit                      ; $4B72
    pop bc                                        ; $4B75
    jr nz, jr_008_4b7a                            ; $4B76

    ld c, $03                                     ; $4B78

jr_008_4b7a:
    ld a, b                                       ; $4B7A
    or c                                          ; $4B7B
    ld [wPrintMarginByte], a                      ; $4B7C
    ld a, MODE_PRINT_JOB                          ; $4B7F
    ld [wMode], a                                 ; $4B81
    set_state STATE_1D_INIT                       ; $4B84
    xor a                                         ; $4B89
    ld [wPrintFirstPhotoFlag], a                  ; $4B8A

jr_008_4b8d:
    ld hl, wPrintJobIndex                         ; $4B8D
    inc [hl]                                      ; $4B90
    ret                                           ; $4B91


; C: $80 $40 .. $01
Print_BitMaskTbl::
    db $80, $40, $20, $10, $08, $04, $02, $01

; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageArrow::
    ld bc, $1c40                                  ; $4B9A
    ld a, $ac                                     ; $4B9D
    add e                                         ; $4B9F
    call Oam_AddMeta_B02_52BD                     ; $4BA0
    ret                                           ; $4BA3


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageIcon::
    ld bc, $5046                                  ; $4BA4
    ld a, $af                                     ; $4BA7
    call Oam_AddMeta_B02_52BD                     ; $4BA9
    ret                                           ; $4BAC


; C: blink phase mod 10; shown while < 6
Print_DrawBlinkingCursor::
    ld a, [wPrintCursorBlink]                     ; $4BAD
    inc a                                         ; $4BB0
    cp $0a                                        ; $4BB1
    jr c, jr_008_4bb6                             ; $4BB3

    xor a                                         ; $4BB5

jr_008_4bb6:
    ld [wPrintCursorBlink], a                     ; $4BB6
    cp $06                                        ; $4BB9
    ret nc                                        ; $4BBB

    push bc                                       ; $4BBC
    ld b, $00                                     ; $4BBD
    ld hl, Print_CursorSpriteTbl                  ; $4BBF
    add hl, bc                                    ; $4BC2
    pop bc                                        ; $4BC3
    ld c, [hl]                                    ; $4BC4
    inc hl                                        ; $4BC5
    ld a, [hl+]                                   ; $4BC6
    add b                                         ; $4BC7
    ld b, a                                       ; $4BC8
    ld a, [hl]                                    ; $4BC9
    call Oam_AddMeta_B02_52BD                     ; $4BCA
    ret                                           ; $4BCD


; C: 3 x (x; y; sprite). L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1E
; (tcrf_check/assets/l3_names/)
Print_CursorSpriteTbl::
    db $40, $19, $b0, $60, $1a, $b0, $74, $65, $b1

; C: A = digit; copies 2 tiles from 20:7180. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 1E (tcrf_check/assets/l3_names/)
Print_DrawDigitTiles::
    swap a                                        ; $4BD7
    ld c, a                                       ; $4BD9
    ld b, $00                                     ; $4BDA
    sla c                                         ; $4BDC
    rl b                                          ; $4BDE
    ld hl, Gfx_20_7180_Mode15_DrawTwoDigits       ; $4BE0
    add hl, bc                                    ; $4BE3
    ld a, BANK(Gfx_20_7180_Mode15_DrawTwoDigits)  ; $4BE4
    ld bc, $0020                                  ; $4BE6
    call Vram_CopyFromBank                        ; $4BE9
    ret                                           ; $4BEC


; C
Print_DrawMarginDigit::
    ld de, $88a0                                  ; $4BED
    ld a, [wPrintMarginLines]                     ; $4BF0
    jp Print_DrawDigitTiles                       ; $4BF3


; C: two-digit count of selected photos
Print_DrawSelectedCount::
    call Print_CountSelectedBits                  ; $4BF6
    ld c, $00                                     ; $4BF9

jr_008_4bfb:
    cp $0a                                        ; $4BFB
    jr c, jr_008_4c04                             ; $4BFD

    sub $0a                                       ; $4BFF
    inc c                                         ; $4C01
    jr jr_008_4bfb                                ; $4C02

jr_008_4c04:
    push af                                       ; $4C04
    ld a, c                                       ; $4C05
    ld de, $88e0                                  ; $4C06
    call Print_DrawDigitTiles                     ; $4C09
    pop af                                        ; $4C0C
    jp Print_DrawDigitTiles                       ; $4C0D


; C: counts the bits of D808..D80F
Print_CountSelectedBits::
    ld hl, wPrintSelectBitmap                     ; $4C10
    ld bc, $0800                                  ; $4C13

jr_008_4c16:
    bit 7, [hl]                                   ; $4C16
    jr z, jr_008_4c1b                             ; $4C18

    inc c                                         ; $4C1A

jr_008_4c1b:
    bit 6, [hl]                                   ; $4C1B
    jr z, jr_008_4c20                             ; $4C1D

    inc c                                         ; $4C1F

jr_008_4c20:
    bit 5, [hl]                                   ; $4C20
    jr z, jr_008_4c25                             ; $4C22

    inc c                                         ; $4C24

jr_008_4c25:
    bit 4, [hl]                                   ; $4C25
    jr z, jr_008_4c2a                             ; $4C27

    inc c                                         ; $4C29

jr_008_4c2a:
    bit 3, [hl]                                   ; $4C2A
    jr z, jr_008_4c2f                             ; $4C2C

    inc c                                         ; $4C2E

jr_008_4c2f:
    bit 2, [hl]                                   ; $4C2F
    jr z, jr_008_4c34                             ; $4C31

    inc c                                         ; $4C33

jr_008_4c34:
    bit 1, [hl]                                   ; $4C34
    jr z, jr_008_4c39                             ; $4C36

    inc c                                         ; $4C38

jr_008_4c39:
    bit 0, [hl]                                   ; $4C39
    jr z, jr_008_4c3e                             ; $4C3B

    inc c                                         ; $4C3D

jr_008_4c3e:
    inc hl                                        ; $4C3E
    dec b                                         ; $4C3F
    jr nz, jr_008_4c16                            ; $4C40

    ld a, c                                       ; $4C42
    ret                                           ; $4C43


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageNumbers::
    ld c, $00                                     ; $4C44
    ld a, [wPrintCursor]                          ; $4C46
    cp $1e                                        ; $4C49
    jr c, jr_008_4c4f                             ; $4C4B

    ld c, $1e                                     ; $4C4D

jr_008_4c4f:
    ld b, $1e                                     ; $4C4F

jr_008_4c51:
    push bc                                       ; $4C51
    ld a, c                                       ; $4C52
    call Print_DrawSelectionDigits                ; $4C53
    pop bc                                        ; $4C56
    inc c                                         ; $4C57
    dec b                                         ; $4C58
    jr nz, jr_008_4c51                            ; $4C59

    ret                                           ; $4C5B


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawSelectionDigits::
    ldh [hScratchA], a                            ; $4C5C
    cp $1e                                        ; $4C5E
    jr c, jr_008_4c64                             ; $4C60

    sub $1e                                       ; $4C62

jr_008_4c64:
    srl a                                         ; $4C64
    ld c, a                                       ; $4C66
    ld b, $00                                     ; $4C67
    ld hl, $9943                                  ; $4C69
    add hl, bc                                    ; $4C6C
    push hl                                       ; $4C6D
    ldh a, [hScratchA]                            ; $4C6E
    srl a                                         ; $4C70
    srl a                                         ; $4C72
    srl a                                         ; $4C74
    ld c, a                                       ; $4C76
    ld b, $00                                     ; $4C77
    ld hl, wPrintSelectBitmap                     ; $4C79
    add hl, bc                                    ; $4C7C
    push hl                                       ; $4C7D
    ldh a, [hScratchA]                            ; $4C7E
    and $07                                       ; $4C80
    ld c, a                                       ; $4C82
    ld b, $00                                     ; $4C83
    ld hl, Print_SelectMarkTbl                    ; $4C85
    add hl, bc                                    ; $4C88
    ld a, [hl]                                    ; $4C89
    pop hl                                        ; $4C8A
    and [hl]                                      ; $4C8B
    ld c, $00                                     ; $4C8C
    ldh [hScratchA], a                            ; $4C8E
    and $aa                                       ; $4C90
    jr z, jr_008_4c95                             ; $4C92

    inc c                                         ; $4C94

jr_008_4c95:
    ldh a, [hScratchA]                            ; $4C95
    and $55                                       ; $4C97
    jr z, jr_008_4c9d                             ; $4C99

    inc c                                         ; $4C9B
    inc c                                         ; $4C9C

jr_008_4c9d:
    ld b, $00                                     ; $4C9D
    ld hl, Print_DrawSelectionDigits_PtrTbl4CB9   ; $4C9F
    add hl, bc                                    ; $4CA2
    ld a, [hl]                                    ; $4CA3
    pop hl                                        ; $4CA4
    call Vram_WriteByteSafe                       ; $4CA5
    ld bc, $0020                                  ; $4CA8
    add hl, bc                                    ; $4CAB
    inc a                                         ; $4CAC
    call Vram_WriteByteSafe                       ; $4CAD
    ret                                           ; $4CB0


; C: L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_SelectMarkTbl::
    db $c0, $c0, $30, $30, $0c, $0c, $03, $03

; C: auto: 4 bytes, word table; referenced by Print_DrawSelectionDigits. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawSelectionDigits_PtrTbl4CB9::
    dw $5256
    dw $5450

; C
Print_ToggleSelectBit::
    ld a, [wPrintCursor]                          ; $4CBD
    srl a                                         ; $4CC0
    srl a                                         ; $4CC2
    srl a                                         ; $4CC4
    ld c, a                                       ; $4CC6
    ld b, $00                                     ; $4CC7
    ld hl, wPrintSelectBitmap                     ; $4CC9
    add hl, bc                                    ; $4CCC
    push hl                                       ; $4CCD
    ld a, [wPrintCursor]                          ; $4CCE
    and $07                                       ; $4CD1
    ld c, a                                       ; $4CD3
    ld b, $00                                     ; $4CD4
    ld hl, Print_BitMaskTbl                       ; $4CD6
    add hl, bc                                    ; $4CD9
    ld a, [hl]                                    ; $4CDA
    pop hl                                        ; $4CDB
    ld c, [hl]                                    ; $4CDC
    xor [hl]                                      ; $4CDD
    ld [hl], a                                    ; $4CDE
    xor c                                         ; $4CDF
    and c                                         ; $4CE0
    ret                                           ; $4CE1


; C
Print_TestSelectBit::
    ld a, [wPrintJobIndex]                        ; $4CE2
    srl a                                         ; $4CE5
    srl a                                         ; $4CE7
    srl a                                         ; $4CE9
    ld c, a                                       ; $4CEB
    ld b, $00                                     ; $4CEC
    ld hl, wPrintSelectBitmap                     ; $4CEE
    add hl, bc                                    ; $4CF1
    push bc                                       ; $4CF2
    push hl                                       ; $4CF3
    ld a, [wPrintJobIndex]                        ; $4CF4
    and $07                                       ; $4CF7
    ld c, a                                       ; $4CF9
    ld b, $00                                     ; $4CFA
    ld hl, Print_ShiftMaskTbl                     ; $4CFC
    add hl, bc                                    ; $4CFF
    ld a, [hl]                                    ; $4D00
    pop hl                                        ; $4D01
    pop bc                                        ; $4D02

jr_008_4d03:
    and [hl]                                      ; $4D03
    ret nz                                        ; $4D04

    ld a, $ff                                     ; $4D05
    inc hl                                        ; $4D07
    inc c                                         ; $4D08
    bit 3, c                                      ; $4D09
    jr z, jr_008_4d03                             ; $4D0B

    xor a                                         ; $4D0D
    ret                                           ; $4D0E


; C: $7F $3F .. $00. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1E)
Print_ShiftMaskTbl::
    db $7f, $3f, $1f, $0f, $07, $03, $01, $00

; C: far call 02:517B; tiles to $8CA0
Print_LoadCursorThumbnail::
    xor a                                         ; $4D17
    ld [wPrintIdleCounter], a                     ; $4D18
    ld a, [wPrintCursor]                          ; $4D1B
    ldh [hFarcallAArg], a                         ; $4D1E
    farcall Photo_GetSramAddress_Far              ; $4D20
    ld hl, $0e00                                  ; $4D28
    add hl, bc                                    ; $4D2B
    ld de, $8ca0                                  ; $4D2C
    ld b, $03                                     ; $4D2F

jr_008_4d31:
    push af                                       ; $4D31
    push bc                                       ; $4D32
    ld bc, $0040                                  ; $4D33
    call Vram_CopyFromBank                        ; $4D36
    ld a, e                                       ; $4D39
    add $40                                       ; $4D3A
    ld e, a                                       ; $4D3C
    jr nc, jr_008_4d40                            ; $4D3D

    inc d                                         ; $4D3F

jr_008_4d40:
    pop bc                                        ; $4D40
    pop af                                        ; $4D41
    dec b                                         ; $4D42
    jr nz, jr_008_4d31                            ; $4D43

    ld b, $04                                     ; $4D45

jr_008_4d47:
    push af                                       ; $4D47
    push bc                                       ; $4D48
    ld bc, $0008                                  ; $4D49
    call Vram_CopyFromBank                        ; $4D4C
    ld a, e                                       ; $4D4F
    add $08                                       ; $4D50
    ld e, a                                       ; $4D52
    jr nc, jr_008_4d56                            ; $4D53

    inc d                                         ; $4D55

jr_008_4d56:
    ld bc, $0008                                  ; $4D56
    add hl, bc                                    ; $4D59
    pop bc                                        ; $4D5A
    pop af                                        ; $4D5B
    dec b                                         ; $4D5C
    jr nz, jr_008_4d47                            ; $4D5D

    ret                                           ; $4D5F


; C: after 10 idle frames the big thumbnail is rebuilt
Print_IdleThumbnailRefresh::
    ldh a, [hKeysHeld]                            ; $4D60
    and PADF_B | PADF_SELECT | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $4D62
    ret nz                                        ; $4D64

    ld a, [wPrintIdleCounter]                     ; $4D65
    cp $0a                                        ; $4D68
    jr z, jr_008_4d74                             ; $4D6A

    cp $ff                                        ; $4D6C
    ret z                                         ; $4D6E

    inc a                                         ; $4D6F
    ld [wPrintIdleCounter], a                     ; $4D70
    ret                                           ; $4D73


jr_008_4d74:
    inc a                                         ; $4D74
    ld [wPrintIdleCounter], a                     ; $4D75
    ld a, [wPrintCursor]                          ; $4D78
    ldh [hFarcallAArg], a                         ; $4D7B
    farcall Photo_GetSramAddress_Far              ; $4D7D
    ld l, a                                       ; $4D85
    push hl                                       ; $4D86
    push bc                                       ; $4D87
    ld hl, sp+$00                                 ; $4D88
    ld bc, wPrintReadback                         ; $4D8A
    call Img_ReduceTo64x56                        ; $4D8D
    pop bc                                        ; $4D90
    pop hl                                        ; $4D91
    jr nc, jr_008_4da5                            ; $4D92

    xor a                                         ; $4D94
    ld [wPrintIdleCounter], a                     ; $4D95
    ldh a, [hKeysHeldSticky]                      ; $4D98
    ldh [hKeysHeld], a                            ; $4D9A
    ldh a, [hKeysNewSticky]                       ; $4D9C
    ldh [hKeysNew], a                             ; $4D9E
    ldh a, [hKeysRepeatSticky]                    ; $4DA0
    ldh [hKeysNewRepeat], a                       ; $4DA2
    ret                                           ; $4DA4


jr_008_4da5:
    ld a, $00                                     ; $4DA5
    ld hl, wPrintReadback                         ; $4DA7
    ld de, $8c00                                  ; $4DAA
    ld bc, $0380                                  ; $4DAD
    call Vram_CopyFromBank                        ; $4DB0
    ret                                           ; $4DB3


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_LoadSelectedDigit::
    xor a                                         ; $4DB4
    ld [wPrintMarkerBlinkA], a                    ; $4DB5
    ld [wPrintMarkerBlinkB], a                    ; $4DB8
    ld a, [wPrintCursor]                          ; $4DBB
    cp $1e                                        ; $4DBE
    jr c, jr_008_4dc4                             ; $4DC0

    sub $1e                                       ; $4DC2

jr_008_4dc4:
    inc a                                         ; $4DC4
    ld c, $00                                     ; $4DC5

jr_008_4dc7:
    cp $0a                                        ; $4DC7
    jr c, jr_008_4dd0                             ; $4DC9

    sub $0a                                       ; $4DCB
    inc c                                         ; $4DCD
    jr jr_008_4dc7                                ; $4DCE

jr_008_4dd0:
    push af                                       ; $4DD0
    ld a, c                                       ; $4DD1
    ld de, $88c0                                  ; $4DD2
    call Print_LoadDigitTile                      ; $4DD5
    pop af                                        ; $4DD8

; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_LoadDigitTile::
    swap a                                        ; $4DD9
    ld c, a                                       ; $4DDB
    ld b, $00                                     ; $4DDC
    ld hl, Gfx_18_5C70_Mode1E_State00_Init        ; $4DDE
    add hl, bc                                    ; $4DE1
    ld a, BANK(Gfx_18_5C70_Mode1E_State00_Init)   ; $4DE2
    ld bc, $0010                                  ; $4DE4
    call Vram_CopyFromBank                        ; $4DE7
    ret                                           ; $4DEA


; C: blinking marker sprite $AE
Print_DrawCursorMarker::
    ld a, [wPrintMarkerBlinkA]                    ; $4DEB
    inc a                                         ; $4DEE
    cp $40                                        ; $4DEF
    jr c, jr_008_4df4                             ; $4DF1

    xor a                                         ; $4DF3

jr_008_4df4:
    ld [wPrintMarkerBlinkA], a                    ; $4DF4
    cp $1e                                        ; $4DF7
    ret nc                                        ; $4DF9

    ld bc, $5046                                  ; $4DFA
    ld a, $ae                                     ; $4DFD
    call Oam_AddMeta_B02_52BD                     ; $4DFF
    ret                                           ; $4E02


; C: marker sprite $B2 when the photo is selected
Print_DrawSelectedMarker::
    ld a, [wPrintCursor]                          ; $4E03
    srl a                                         ; $4E06
    srl a                                         ; $4E08
    srl a                                         ; $4E0A
    ld c, a                                       ; $4E0C
    ld b, $00                                     ; $4E0D
    ld hl, wPrintSelectBitmap                     ; $4E0F
    add hl, bc                                    ; $4E12
    push hl                                       ; $4E13
    ld a, [wPrintCursor]                          ; $4E14
    and $07                                       ; $4E17
    ld c, a                                       ; $4E19
    ld b, $00                                     ; $4E1A
    ld hl, Print_BitMaskTbl                       ; $4E1C
    add hl, bc                                    ; $4E1F
    ld a, [hl]                                    ; $4E20
    pop hl                                        ; $4E21
    and [hl]                                      ; $4E22
    ret z                                         ; $4E23

    ld a, [wPrintMarkerBlinkB]                    ; $4E24
    inc a                                         ; $4E27
    cp $40                                        ; $4E28
    jr c, jr_008_4e2d                             ; $4E2A

    xor a                                         ; $4E2C

jr_008_4e2d:
    ld [wPrintMarkerBlinkB], a                    ; $4E2D
    cp $1e                                        ; $4E30
    ret nc                                        ; $4E32

    ld bc, $4f20                                  ; $4E33
    ld a, $b2                                     ; $4E36
    call Oam_AddMeta_B02_52BD                     ; $4E38
    ret                                           ; $4E3B


; C: print border (frame) chooser; 3 substates
BorderPicker_Far::
    ld a, [wSubstate]                             ; $4E3C
    rst Rst18_JumpTable                           ; $4E3F

; I
BorderPicker_SubstateTbl::
    dw BorderPicker_Substate0_Init
    dw BorderPicker_Substate1_Browse
    dw BorderPicker_Substate2_Exit

; C
BorderPicker_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4E46
    ldh [hLcdcShadow], a                          ; $4E48
    ld a, $e4                                     ; $4E4A
    ld [wPaletteTarget], a                        ; $4E4C
    ld a, $d2                                     ; $4E4F
    ld [wPaletteTarget + $1], a                   ; $4E51
    ld [wPaletteTarget + $2], a                   ; $4E54
    xor a                                         ; $4E57
    ldh [hScxShadow], a                           ; $4E58
    ldh [hScyShadow], a                           ; $4E5A
    ld [wSpriteAnimFrame], a                      ; $4E5C
    ld [wSpriteAnimTick], a                       ; $4E5F
    ld [wSpriteAnimFrame], a                      ; $4E62
    farcopy Mem_CopyFromBank, Gfx_21_77C0_BorderPicker_Substate0_Init, $8400, $0400 ; $4E65
    ld bc, $9800                                  ; $4E73
    ld de, $9c00                                  ; $4E76
    ld a, $12                                     ; $4E79

jr_008_4e7b:
    push af                                       ; $4E7B
    ld hl, BorderPicker_FillPatternTbl            ; $4E7C
    ld a, $20                                     ; $4E7F

jr_008_4e81:
    push af                                       ; $4E81
    ld a, [hl+]                                   ; $4E82
    ld [bc], a                                    ; $4E83
    ld [de], a                                    ; $4E84
    inc bc                                        ; $4E85
    inc de                                        ; $4E86
    pop af                                        ; $4E87
    dec a                                         ; $4E88
    jr nz, jr_008_4e81                            ; $4E89

    pop af                                        ; $4E8B
    dec a                                         ; $4E8C
    jr nz, jr_008_4e7b                            ; $4E8D

    ld l, c                                       ; $4E8F
    ld h, b                                       ; $4E90
    ld bc, $01c0                                  ; $4E91

jr_008_4e94:
    ld a, $ff                                     ; $4E94
    ld [hl+], a                                   ; $4E96
    ld [de], a                                    ; $4E97
    inc de                                        ; $4E98
    dec bc                                        ; $4E99
    ld a, b                                       ; $4E9A
    or c                                          ; $4E9B
    jr nz, jr_008_4e94                            ; $4E9C

    ldh [hFarcallAArg], a                         ; $4E9E
    ld a, $08                                     ; $4EA0
    ld hl, Border_LoadMap_LcdOff                  ; $4EA2
    call Far_Call                                 ; $4EA5
    screen_on                                     ; $4EA8
    call BorderPicker_AnimateIcon                 ; $4EB1
    call Pal_FadeIn                               ; $4EB4
    ld hl, wSubstate                              ; $4EB7
    inc [hl]                                      ; $4EBA
    jp Far_Call_Return                            ; $4EBB


; C: one 32-byte background map row: 20 x $FE then 12 x $FF; Substate0_Init copies it 18 times to $9800 and $9C00 (ld
; a,$20 loop); the 20 + 12 split was a typing artefact
BorderPicker_FillPatternTbl::
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C
BorderPicker_Substate1_Browse::
    call BorderPicker_ReadKeys                    ; $4EDE
    call BorderPicker_AnimateIcon                 ; $4EE1
    call BorderPicker_DrawNumber                  ; $4EE4
    ldh a, [hKeysNew]                             ; $4EE7
    and PADF_A | PADF_B                           ; $4EE9
    jp z, Far_Call_Return                         ; $4EEB

    ld [wAbResult], a                             ; $4EEE
    ld hl, wSubstate                              ; $4EF1
    inc [hl]                                      ; $4EF4
    jp Far_Call_Return                            ; $4EF5


; C
BorderPicker_Substate2_Exit::
    screen_off                                    ; $4EF8
    next_state                                    ; $4EFE
    jp Far_Call_Return                            ; $4F02


; C: 16-byte tile packet from 21:7BB0 to the VRAM queue
BorderPicker_AnimateIcon::
    ld a, [wSpriteAnimFrame]                      ; $4F05
    swap a                                        ; $4F08
    ld c, a                                       ; $4F0A
    ld b, $00                                     ; $4F0B
    ld hl, Src_21_7BB0_BorderPicker_AnimateIcon   ; $4F0D
    add hl, bc                                    ; $4F10
    ld a, BANK(Src_21_7BB0_BorderPicker_AnimateIcon) ; $4F11
    ld de, wPrintAnimPacket + $3                  ; $4F13
    ld bc, $0010                                  ; $4F16
    call Mem_CopyFromBank                         ; $4F19
    ld a, $8f                                     ; $4F1C
    ld [wPrintAnimPacket], a                      ; $4F1E
    ld a, $e0                                     ; $4F21
    ld [wPrintAnimPacket + $1], a                 ; $4F23
    ld a, $10                                     ; $4F26
    ld [wPrintAnimPacket + $2], a                 ; $4F28
    xor a                                         ; $4F2B
    ld [wPrintAnimPacket + $13], a                ; $4F2C
    xor a                                         ; $4F2F
    ld bc, wPrintAnimPacket                       ; $4F30
    call Vq_Push                                  ; $4F33
    ld a, [wSpriteAnimFrame]                      ; $4F36
    inc a                                         ; $4F39
    cp $05                                        ; $4F3A
    jr nz, jr_008_4f3f                            ; $4F3C

    xor a                                         ; $4F3E

jr_008_4f3f:
    ld [wSpriteAnimFrame], a                      ; $4F3F
    ret                                           ; $4F42


; C: D7C1+1 as two digits; sprites $26 / $27
BorderPicker_DrawNumber::
    ld a, [wMode]                                 ; $4F43
    cp MODE_ANIMATION_EDITOR                      ; $4F46
    jr nz, jr_008_4f54                            ; $4F48

    ld bc, $5048                                  ; $4F4A
    ld a, $27                                     ; $4F4D
    call Oam_AddMeta_B01_5D2B                     ; $4F4F
    jr jr_008_4f5c                                ; $4F52

jr_008_4f54:
    ld bc, $5048                                  ; $4F54
    ld a, $26                                     ; $4F57
    call Oam_AddMeta_B01_5D2B                     ; $4F59

jr_008_4f5c:
    ld a, [wBorderNumber]                         ; $4F5C
    inc a                                         ; $4F5F
    ld c, $00                                     ; $4F60

jr_008_4f62:
    cp $0a                                        ; $4F62
    jr c, jr_008_4f6b                             ; $4F64

    sub $0a                                       ; $4F66
    inc c                                         ; $4F68
    jr jr_008_4f62                                ; $4F69

jr_008_4f6b:
    push bc                                       ; $4F6B
    add $28                                       ; $4F6C
    ld bc, $6259                                  ; $4F6E
    call Oam_AddMeta_B01_5D2B                     ; $4F71
    pop bc                                        ; $4F74
    ld a, c                                       ; $4F75
    add $28                                       ; $4F76
    ld bc, $5a59                                  ; $4F78
    call Oam_AddMeta_B01_5D2B                     ; $4F7B
    ldh a, [hFrameCounter]                        ; $4F7E
    srl a                                         ; $4F80
    srl a                                         ; $4F82
    and $01                                       ; $4F84
    add $32                                       ; $4F86
    ld bc, $5048                                  ; $4F88
    call Oam_AddMeta_B01_5D2B                     ; $4F8B
    ret                                           ; $4F8E


; C: Left/Right with repeat; sound $38
BorderPicker_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $4F8F
    ld b, a                                       ; $4F91
    ld a, [wBorderNumber]                         ; $4F92
    bit 5, b                                      ; $4F95
    jr z, jr_008_4fab                             ; $4F97

    play_sfx1 SFX1_CURSOR_MOVE                    ; $4F99
    dec a                                         ; $4FA0
    bit 7, a                                      ; $4FA1
    jr z, jr_008_4fa7                             ; $4FA3

    ld a, $11                                     ; $4FA5

jr_008_4fa7:
    call BorderPicker_SlideToPrevious             ; $4FA7
    ret                                           ; $4FAA


jr_008_4fab:
    bit 4, b                                      ; $4FAB
    ret z                                         ; $4FAD

    play_sfx1 SFX1_CURSOR_MOVE                    ; $4FAE
    inc a                                         ; $4FB5
    cp $12                                        ; $4FB6
    jr nz, jr_008_4fbb                            ; $4FB8

    xor a                                         ; $4FBA

jr_008_4fbb:
    call BorderPicker_SlideToNext                 ; $4FBB
    ret                                           ; $4FBE


; C: page slide. L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 0A 12
; (tcrf_check/assets/l3_names/)
BorderPicker_SlideToPrevious::
    push af                                       ; $4FBF
    ld a, [wBorderNumber]                         ; $4FC0
    call Border_LoadMapRect                       ; $4FC3
    xor a                                         ; $4FC6
    ldh [hWyShadow], a                            ; $4FC7
    ldh a, [hLcdcShadow]                          ; $4FC9
    xor $20                                       ; $4FCB
    ldh [hLcdcShadow], a                          ; $4FCD
    ld a, $07                                     ; $4FCF
    ldh [hWxShadow], a                            ; $4FD1
    call BorderPicker_AnimateIcon                 ; $4FD3
    call BorderPicker_DrawNumber                  ; $4FD6
    call Oam_HideUnused                           ; $4FD9
    rst Rst08_WaitVBlank                          ; $4FDC
    pop af                                        ; $4FDD
    ld [wBorderNumber], a                         ; $4FDE
    ldh [hFarcallAArg], a                         ; $4FE1
    ld a, $08                                     ; $4FE3
    ld hl, Border_LoadMap_Safe                    ; $4FE5
    call Far_Call                                 ; $4FE8
    ld hl, BorderPicker_SlideTblA                 ; $4FEB
    ld b, $07                                     ; $4FEE

jr_008_4ff0:
    push bc                                       ; $4FF0
    ld a, [hl+]                                   ; $4FF1
    ldh [hScxShadow], a                           ; $4FF2
    ldh a, [hLcdcShadow]                          ; $4FF4
    xor [hl]                                      ; $4FF6
    ldh [hLcdcShadow], a                          ; $4FF7
    inc hl                                        ; $4FF9
    ld a, [hl+]                                   ; $4FFA
    ldh [hWxShadow], a                            ; $4FFB
    push hl                                       ; $4FFD
    call BorderPicker_AnimateIcon                 ; $4FFE
    call BorderPicker_DrawNumber                  ; $5001
    call Oam_HideUnused                           ; $5004
    rst Rst08_WaitVBlank                          ; $5007
    pop hl                                        ; $5008
    pop bc                                        ; $5009
    dec b                                         ; $500A
    jr nz, jr_008_4ff0                            ; $500B

    ret                                           ; $500D


; C: L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 0A 12 (tcrf_check/assets/l3_names/)
BorderPicker_SlideTblA::
    db $a8, $00, $3f, $78, $00, $6f, $50, $00, $97, $30, $20, $00, $18, $00, $00, $08
    db $00, $00, $00, $00, $00

; C: page slide. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
BorderPicker_SlideToNext::
    push af                                       ; $5023
    call Border_LoadMapRect                       ; $5024
    xor a                                         ; $5027
    ldh [hWyShadow], a                            ; $5028
    ld hl, BorderPicker_SlideTblB                 ; $502A
    ld b, $07                                     ; $502D

jr_008_502f:
    push bc                                       ; $502F
    ld a, [hl+]                                   ; $5030
    ldh [hScxShadow], a                           ; $5031
    ldh a, [hLcdcShadow]                          ; $5033
    xor [hl]                                      ; $5035
    ldh [hLcdcShadow], a                          ; $5036
    inc hl                                        ; $5038
    ld a, [hl+]                                   ; $5039
    ldh [hWxShadow], a                            ; $503A
    push hl                                       ; $503C
    call BorderPicker_AnimateIcon                 ; $503D
    call BorderPicker_DrawNumber                  ; $5040
    call Oam_HideUnused                           ; $5043
    rst Rst08_WaitVBlank                          ; $5046
    pop hl                                        ; $5047
    pop bc                                        ; $5048
    dec b                                         ; $5049
    jr nz, jr_008_502f                            ; $504A

    ld a, [hl+]                                   ; $504C
    ldh [hScxShadow], a                           ; $504D
    pop af                                        ; $504F
    push hl                                       ; $5050
    ld [wBorderNumber], a                         ; $5051
    ldh [hFarcallAArg], a                         ; $5054
    ld a, $08                                     ; $5056
    ld hl, Border_LoadMap_Safe                    ; $5058
    call Far_Call                                 ; $505B
    pop hl                                        ; $505E
    ldh a, [hLcdcShadow]                          ; $505F
    xor [hl]                                      ; $5061
    ldh [hLcdcShadow], a                          ; $5062
    inc hl                                        ; $5064
    ld a, [hl]                                    ; $5065
    ldh [hWxShadow], a                            ; $5066
    ret                                           ; $5068


; C: 24 bytes = 8 records of 3 bytes (38 00 00 / 68 20 7F / 90 00 57 / B0 00 37 / C8 00 1F / D8 00 17 / E0 00 07 / 00
; 20 00); the last record was cut off by a false label at 5033 (`ld bc,$5033`, a sprite position). L3 pass 2026-10-26:
; not reached by the 206 BGB replays; read in the organic runs of the ...
BorderPicker_SlideTblB::
    db $38, $00, $00, $68, $20, $7f
    db $90, $00, $57, $b0, $00, $37
    db $c8, $00, $1f, $d8, $00, $17
    db $e0, $00, $07, $00, $20, $00

; C: far: border tilemap with the LCD off
Border_LoadMap_LcdOff::
    ld a, [wBorderNumber]                         ; $5081
    sla a                                         ; $5084
    ld c, a                                       ; $5086
    sla a                                         ; $5087
    add c                                         ; $5089
    ld c, a                                       ; $508A
    ld b, $00                                     ; $508B
    ld hl, Border_SrcTbl                          ; $508D
    add hl, bc                                    ; $5090
    ld c, [hl]                                    ; $5091
    inc hl                                        ; $5092
    ld b, [hl]                                    ; $5093
    inc hl                                        ; $5094
    ld a, [hl+]                                   ; $5095
    push hl                                       ; $5096
    ld l, c                                       ; $5097
    ld h, b                                       ; $5098
    ld de, $8900                                  ; $5099
    ld bc, $0600                                  ; $509C
    call Mem_CopyFromBank                         ; $509F
    pop hl                                        ; $50A2
    ld c, [hl]                                    ; $50A3
    inc hl                                        ; $50A4
    ld b, [hl]                                    ; $50A5
    inc hl                                        ; $50A6
    ld a, [hl+]                                   ; $50A7
    ld l, c                                       ; $50A8
    ld h, b                                       ; $50A9
    push af                                       ; $50AA
    ldh a, [hScyShadow]                           ; $50AB
    and $f8                                       ; $50AD
    sla a                                         ; $50AF
    sla a                                         ; $50B1
    ld e, a                                       ; $50B3
    ldh a, [hScxShadow]                           ; $50B4
    srl a                                         ; $50B6
    srl a                                         ; $50B8
    srl a                                         ; $50BA
    add e                                         ; $50BC
    ld e, a                                       ; $50BD
    ld d, $98                                     ; $50BE
    pop af                                        ; $50C0
    ld c, $90                                     ; $50C1
    call Border_CopyFrameAddTile_LcdOff           ; $50C3
    jp Far_Call_Return                            ; $50C6


; C: far: border tilemap during VBlank
Border_LoadMap_Safe::
    ld a, [wBorderNumber]                         ; $50C9
    sla a                                         ; $50CC
    ld c, a                                       ; $50CE
    sla a                                         ; $50CF
    add c                                         ; $50D1
    ld c, a                                       ; $50D2
    ld b, $00                                     ; $50D3
    ld hl, Border_SrcTbl                          ; $50D5
    add hl, bc                                    ; $50D8
    ld c, [hl]                                    ; $50D9
    inc hl                                        ; $50DA
    ld b, [hl]                                    ; $50DB
    inc hl                                        ; $50DC
    ld a, [hl+]                                   ; $50DD
    push hl                                       ; $50DE
    ld l, c                                       ; $50DF
    ld h, b                                       ; $50E0
    ld de, $8900                                  ; $50E1
    ld bc, $0600                                  ; $50E4
    call Vram_CopyFromBank                        ; $50E7
    pop hl                                        ; $50EA
    ld c, [hl]                                    ; $50EB
    inc hl                                        ; $50EC
    ld b, [hl]                                    ; $50ED
    inc hl                                        ; $50EE
    ld a, [hl+]                                   ; $50EF
    ld l, c                                       ; $50F0
    ld h, b                                       ; $50F1
    push af                                       ; $50F2
    ldh a, [hScyShadow]                           ; $50F3
    and $f8                                       ; $50F5
    sla a                                         ; $50F7
    sla a                                         ; $50F9
    ld e, a                                       ; $50FB
    ldh a, [hScxShadow]                           ; $50FC
    srl a                                         ; $50FE
    srl a                                         ; $5100
    srl a                                         ; $5102
    add e                                         ; $5104
    ld e, a                                       ; $5105
    ld d, $98                                     ; $5106
    pop af                                        ; $5108
    ld c, $90                                     ; $5109
    call Border_CopyFrameAddTile_Safe             ; $510B
    jp Far_Call_Return                            ; $510E


; C
Border_LoadMapRect::
    sla a                                         ; $5111
    ld c, a                                       ; $5113
    sla a                                         ; $5114
    add c                                         ; $5116
    ld c, a                                       ; $5117
    ld b, $00                                     ; $5118
    ld hl, Border_SrcTbl                          ; $511A
    add hl, bc                                    ; $511D
    ld c, [hl]                                    ; $511E
    inc hl                                        ; $511F
    ld b, [hl]                                    ; $5120
    inc hl                                        ; $5121
    ld a, [hl+]                                   ; $5122
    push hl                                       ; $5123
    ld l, c                                       ; $5124
    ld h, b                                       ; $5125
    ld de, $9000                                  ; $5126
    ld bc, $0600                                  ; $5129
    call Vram_CopyFromBank                        ; $512C
    pop hl                                        ; $512F
    ld c, [hl]                                    ; $5130
    inc hl                                        ; $5131
    ld b, [hl]                                    ; $5132
    inc hl                                        ; $5133
    ld a, [hl+]                                   ; $5134
    ld l, c                                       ; $5135
    ld h, b                                       ; $5136
    ld de, $9c00                                  ; $5137
    ld c, $00                                     ; $513A
    call Border_CopyFrameAddTile_Safe             ; $513C
    ret                                           ; $513F


; C: far: print_src_table2 from Border_SrcTbl
Border_FillPrintSource::
    ld a, [wBorderNumber]                         ; $5140
    sla a                                         ; $5143
    ld c, a                                       ; $5145
    sla a                                         ; $5146
    add c                                         ; $5148
    ld c, a                                       ; $5149
    ld b, $00                                     ; $514A
    ld hl, Border_SrcTbl                          ; $514C
    add hl, bc                                    ; $514F
    ld de, wPrintSrcTable2 + $4                   ; $5150
    ld a, [hl+]                                   ; $5153
    ld [de], a                                    ; $5154
    inc de                                        ; $5155
    ld a, [hl+]                                   ; $5156
    ld [de], a                                    ; $5157
    inc de                                        ; $5158
    ld a, [hl+]                                   ; $5159
    ld [de], a                                    ; $515A
    ld de, wPrintSrcTable + $4                    ; $515B
    ld a, [hl+]                                   ; $515E
    ld [de], a                                    ; $515F
    inc de                                        ; $5160
    ld a, [hl+]                                   ; $5161
    ld [de], a                                    ; $5162
    inc de                                        ; $5163
    ld a, [hl+]                                   ; $5164
    ld [de], a                                    ; $5165
    jp Far_Call_Return                            ; $5166


; C: 19 entries x 2 {lo;hi;bank}: tiles; map; entry $12 = plain
Border_SrcTbl::
    dwb Border00_Tiles
    dwb Border00_Map
    dwb Border01_Tiles
    dwb Border01_Map
    dwb Border02_Tiles
    dwb Border02_Map
    dwb Border03_Tiles
    dwb Border03_Map
    dwb Border04_Tiles
    dwb Border04_Map
    dwb Border05_Tiles
    dwb Border05_Map
    dwb Border06_Tiles
    dwb Border06_Map
    dwb Border07_Tiles
    dwb Border07_Map
    dwb Border08_Tiles
    dwb Border08_Map
    dwb Border09_Tiles
    dwb Border09_Map
    dwb Border10_Tiles
    dwb Border10_Map
    dwb Border11_Tiles
    dwb Border11_Map
    dwb Border12_Tiles
    dwb Border12_Map
    dwb Border13_Tiles
    dwb Border13_Map
    dwb Border14_Tiles
    dwb Border14_Map
    dwb Border15_Tiles
    dwb Border15_Map
    dwb Border16_Tiles
    dwb Border16_Map
    dwb Border17_Tiles
    dwb Border17_Map
    dwb Border18_Tiles
    dwb Border18_Map

; C: wild-frame page chooser (6 pages; 8 with the CoroCoro flag); 3 substates
WildFramePicker_Far::
    ld a, [wSubstate]                             ; $51DB
    rst Rst18_JumpTable                           ; $51DE

; I
WildFramePicker_SubstateTbl::
    dw WildFramePicker_Substate0_Init
    dw WildFramePicker_Substate1_Browse
    dw WildFramePicker_Substate2_Exit

; C
WildFramePicker_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $51E5
    ldh [hLcdcShadow], a                          ; $51E7
    ld a, $e4                                     ; $51E9
    ld [wPaletteTarget], a                        ; $51EB
    ld a, $d2                                     ; $51EE
    ld [wPaletteTarget + $1], a                   ; $51F0
    ld [wPaletteTarget + $2], a                   ; $51F3
    xor a                                         ; $51F6
    ldh [hScxShadow], a                           ; $51F7
    ldh [hScyShadow], a                           ; $51F9
    ld [wSpriteAnimFrame], a                      ; $51FB
    ld [wSpriteAnimTick], a                       ; $51FE
    ld [wSpriteAnimFrame], a                      ; $5201
    farcopy Mem_CopyFromBank, Gfx_21_77C0_BorderPicker_Substate0_Init, $8400, $0400 ; $5204
    farcopy Mem_CopyFromBank, Map_25_6AA0_WildFramePicker_Substate0_Init, $9800, $0240 ; $5212
    farcopy Mem_CopyFromBank, Map_25_6AA0_WildFramePicker_Substate0_Init, $9c00, $0240 ; $5220
    ld hl, $9c00                                  ; $522E
    ld a, $ff                                     ; $5231
    ld b, $28                                     ; $5233
    call Wild_FillBytes4                          ; $5235
    ld a, $fe                                     ; $5238
    ld b, $20                                     ; $523A
    call Wild_FillBytes4                          ; $523C
    ld a, $ff                                     ; $523F
    ld b, $48                                     ; $5241
    call Wild_FillBytes4                          ; $5243
    ld a, $38                                     ; $5246
    ldh [hLycShadowSplit1], a                     ; $5248
    ldh [hSplit1Latch], a                         ; $524A
    ld hl, hStatShadow                            ; $524C
    set 6, [hl]                                   ; $524F
    ld hl, rIE                                    ; $5251
    set 1, [hl]                                   ; $5254
    ld a, $01                                     ; $5256
    ldh [hStatHandlerIndex], a                    ; $5258
    screen_on                                     ; $525A
    call WildFramePicker_AnimateIcon              ; $5263
    call WildFramePicker_LoadPage                 ; $5266
    call Pal_FadeIn                               ; $5269
    ld hl, wSubstate                              ; $526C
    inc [hl]                                      ; $526F
    jp Far_Call_Return                            ; $5270


; C: fills 4*B bytes with A. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 1C
; (tcrf_check/assets/l3_names/)
Wild_FillBytes4::
    ld [hl+], a                                   ; $5273
    ld [hl+], a                                   ; $5274
    ld [hl+], a                                   ; $5275
    ld [hl+], a                                   ; $5276
    dec b                                         ; $5277
    jr nz, Wild_FillBytes4                        ; $5278

    ret                                           ; $527A


; C
WildFramePicker_Substate1_Browse::
    call WildFramePicker_ReadKeys                 ; $527B
    call WildFramePicker_AnimateIcon              ; $527E
    call WildFramePicker_DrawPageNumber           ; $5281
    ldh a, [hKeysNew]                             ; $5284
    and PADF_A | PADF_B                           ; $5286
    jp z, Far_Call_Return                         ; $5288

    ld [wAbResult], a                             ; $528B
    ld hl, wSubstate                              ; $528E
    inc [hl]                                      ; $5291
    jp Far_Call_Return                            ; $5292


; C
WildFramePicker_Substate2_Exit::
    screen_off                                    ; $5295
    stat_irq_off                                  ; $529B
    next_state                                    ; $52A5
    jp Far_Call_Return                            ; $52A9


; C: same as BorderPicker_AnimateIcon
WildFramePicker_AnimateIcon::
    ld a, [wSpriteAnimFrame]                      ; $52AC
    swap a                                        ; $52AF
    ld c, a                                       ; $52B1
    ld b, $00                                     ; $52B2
    ld hl, Src_21_7BB0_BorderPicker_AnimateIcon   ; $52B4
    add hl, bc                                    ; $52B7
    ld a, BANK(Src_21_7BB0_BorderPicker_AnimateIcon) ; $52B8
    ld de, wPrintAnimPacket + $3                  ; $52BA
    ld bc, $0010                                  ; $52BD
    call Mem_CopyFromBank                         ; $52C0
    ld a, $8f                                     ; $52C3
    ld [wPrintAnimPacket], a                      ; $52C5
    ld a, $e0                                     ; $52C8
    ld [wPrintAnimPacket + $1], a                 ; $52CA
    ld a, $10                                     ; $52CD
    ld [wPrintAnimPacket + $2], a                 ; $52CF
    xor a                                         ; $52D2
    ld [wPrintAnimPacket + $13], a                ; $52D3
    xor a                                         ; $52D6
    ld bc, wPrintAnimPacket                       ; $52D7
    call Vq_Push                                  ; $52DA
    ld a, [wSpriteAnimFrame]                      ; $52DD
    inc a                                         ; $52E0
    cp $05                                        ; $52E1
    jr nz, jr_008_52e6                            ; $52E3

    xor a                                         ; $52E5

jr_008_52e6:
    ld [wSpriteAnimFrame], a                      ; $52E6
    ret                                           ; $52E9


; C
WildFramePicker_DrawPageNumber::
    ld bc, $5033                                  ; $52EA
    ld a, $34                                     ; $52ED
    call Oam_AddMeta_B01_5D2B                     ; $52EF
    ld a, [wPageIndex8]                           ; $52F2
    inc a                                         ; $52F5
    ld c, $00                                     ; $52F6

jr_008_52f8:
    cp $0a                                        ; $52F8
    jr c, jr_008_5301                             ; $52FA

    sub $0a                                       ; $52FC
    inc c                                         ; $52FE
    jr jr_008_52f8                                ; $52FF

jr_008_5301:
    push bc                                       ; $5301
    add $28                                       ; $5302
    ld bc, $6a44                                  ; $5304
    call Oam_AddMeta_B01_5D2B                     ; $5307
    pop bc                                        ; $530A
    ld a, c                                       ; $530B
    add $28                                       ; $530C
    ld bc, $6244                                  ; $530E
    call Oam_AddMeta_B01_5D2B                     ; $5311
    ldh a, [hFrameCounter]                        ; $5314
    srl a                                         ; $5316
    srl a                                         ; $5318
    and $01                                       ; $531A
    add $32                                       ; $531C
    ld bc, $5833                                  ; $531E
    call Oam_AddMeta_B01_5D2B                     ; $5321
    ret                                           ; $5324


; I: pages 6 or 8 (D582)
WildFramePicker_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $5325
    ld b, a                                       ; $5327
    ld c, $06                                     ; $5328
    ld a, [wCoroFlag]                             ; $532A
    cp $01                                        ; $532D
    jr nz, jr_008_5333                            ; $532F

    ld c, $07                                     ; $5331

jr_008_5333:
    ld a, [wPageIndex8]                           ; $5333
    bit 5, b                                      ; $5336
    jr z, jr_008_534c                             ; $5338

    play_sfx1 SFX1_CURSOR_MOVE                    ; $533A
    dec a                                         ; $5341
    bit 7, a                                      ; $5342
    jr z, jr_008_5348                             ; $5344

    ld a, c                                       ; $5346
    dec a                                         ; $5347

jr_008_5348:
    call WildFramePicker_SlideRight               ; $5348
    ret                                           ; $534B


jr_008_534c:
    bit 4, b                                      ; $534C
    ret z                                         ; $534E

    play_sfx1 SFX1_CURSOR_MOVE                    ; $534F
    inc a                                         ; $5356
    cp c                                          ; $5357
    jr nz, jr_008_535b                            ; $5358

    xor a                                         ; $535A

jr_008_535b:
    call WildFramePicker_SlideLeft                ; $535B
    ret                                           ; $535E


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
WildFramePicker_SlideRight::
    ld [wPageIndex8], a                           ; $535F
    xor a                                         ; $5362
    ldh [hWyShadow], a                            ; $5363
    ld hl, WildFramePicker_SlideTblA              ; $5365
    ld b, $0a                                     ; $5368

jr_008_536a:
    push bc                                       ; $536A
    call Wild_WaitLY39                            ; $536B
    ld a, [hl+]                                   ; $536E
    ldh [hScxShadow], a                           ; $536F
    ldh a, [hLcdcShadow]                          ; $5371
    xor [hl]                                      ; $5373
    ldh [hLcdcShadow], a                          ; $5374
    inc hl                                        ; $5376
    ld a, [hl+]                                   ; $5377
    ldh [hWxShadow], a                            ; $5378
    push hl                                       ; $537A
    ld a, b                                       ; $537B
    cp $07                                        ; $537C
    call z, WildFramePicker_LoadPage              ; $537E
    call WildFramePicker_AnimateIcon              ; $5381
    call WildFramePicker_DrawPageNumber           ; $5384
    call Oam_HideUnused                           ; $5387
    rst Rst08_WaitVBlank                          ; $538A
    pop hl                                        ; $538B
    pop bc                                        ; $538C
    dec b                                         ; $538D
    jr nz, jr_008_536a                            ; $538E

    ret                                           ; $5390


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1C)
WildFramePicker_SlideTblA::
    db $00, $68, $57, $00, $00, $9f, $a8, $48, $5f, $a8, $00, $5f, $78, $00, $8f, $50
    db $20, $07, $30, $00, $07, $18, $00, $07, $08, $00, $07, $00, $00, $07

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
WildFramePicker_SlideLeft::
    ld [wPageIndex8], a                           ; $53AF
    xor a                                         ; $53B2
    ldh [hWyShadow], a                            ; $53B3
    ld hl, WildFramePicker_SlideTblB              ; $53B5
    ld b, $0a                                     ; $53B8

jr_008_53ba:
    push bc                                       ; $53BA
    call Wild_WaitLY39                            ; $53BB
    ld a, [hl+]                                   ; $53BE
    ldh [hScxShadow], a                           ; $53BF
    ldh a, [hLcdcShadow]                          ; $53C1
    xor [hl]                                      ; $53C3
    ldh [hLcdcShadow], a                          ; $53C4
    inc hl                                        ; $53C6
    ld a, [hl+]                                   ; $53C7
    ldh [hWxShadow], a                            ; $53C8
    push hl                                       ; $53CA
    ld a, b                                       ; $53CB
    cp $07                                        ; $53CC
    call z, WildFramePicker_LoadPage              ; $53CE
    call WildFramePicker_AnimateIcon              ; $53D1
    call WildFramePicker_DrawPageNumber           ; $53D4
    call Oam_HideUnused                           ; $53D7
    rst Rst08_WaitVBlank                          ; $53DA
    pop hl                                        ; $53DB
    pop bc                                        ; $53DC
    dec b                                         ; $53DD
    jr nz, jr_008_53ba                            ; $53DE

    ret                                           ; $53E0


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1C)
WildFramePicker_SlideTblB::
    db $50, $20, $57, $98, $00, $0f, $00, $68, $07, $00, $00, $07, $00, $20, $7f, $00
    db $00, $57, $00, $00, $37, $00, $00, $1f, $00, $00, $0f, $00, $68, $07

; C: waits for LY >= $39. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
Wild_WaitLY39::
    ldh a, [rLY]                                  ; $53FF
    cp $39                                        ; $5401
    jr c, Wild_WaitLY39                           ; $5403

    ret                                           ; $5405


; C: tiles and map of the current page
WildFramePicker_LoadPage::
    ld a, [wPageIndex8]                           ; $5406
    ld c, a                                       ; $5409
    sla a                                         ; $540A
    add c                                         ; $540C
    ld c, a                                       ; $540D
    ld b, $00                                     ; $540E
    ld hl, WildFrame_PageSrcTbl                   ; $5410
    add hl, bc                                    ; $5413
    ld c, [hl]                                    ; $5414
    inc hl                                        ; $5415
    ld b, [hl]                                    ; $5416
    inc hl                                        ; $5417
    ld a, [hl]                                    ; $5418
    ld l, c                                       ; $5419
    ld h, b                                       ; $541A
    ld de, $9000                                  ; $541B
    ld bc, $0640                                  ; $541E
    call Wild_CopyBlockAdvance                    ; $5421
    ld de, $8000                                  ; $5424
    ld bc, $01c0                                  ; $5427
    call Wild_CopyBlockAdvance                    ; $542A
    ld de, $81c0                                  ; $542D
    ld bc, $0240                                  ; $5430
    call Wild_CopyBlockAdvance                    ; $5433
    ld de, $8800                                  ; $5436
    ld bc, $05c0                                  ; $5439
    call Wild_CopyBlockAdvance                    ; $543C
    ld de, $8dc0                                  ; $543F
    ld bc, $0180                                  ; $5442
    call Wild_CopyBlockAdvance                    ; $5445
    ret                                           ; $5448


; C: Vram_CopyFromBank then bank++ on address wrap. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic
; corpus, modes 1C (tcrf_check/assets/l3_names/)
Wild_CopyBlockAdvance::
    push af                                       ; $5449
    call Vram_CopyFromBank                        ; $544A
    pop af                                        ; $544D
    bit 7, h                                      ; $544E
    ret z                                         ; $5450

    res 7, h                                      ; $5451
    set 6, h                                      ; $5453
    inc a                                         ; $5455
    ret                                           ; $5456


; C: far: called from the print job (08:4675). L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic
; corpus, modes 1C (tcrf_check/assets/l3_names/)
WildFrame_LoadForPrintJob::
    ld a, [wPageIndex8]                           ; $5457
    ld c, a                                       ; $545A
    sla a                                         ; $545B
    add c                                         ; $545D
    ld c, a                                       ; $545E
    ld b, $00                                     ; $545F
    ld hl, WildFrame_PageSrcTbl                   ; $5461
    add hl, bc                                    ; $5464
    ld c, [hl]                                    ; $5465
    inc hl                                        ; $5466
    ld a, [hl]                                    ; $5467
    inc hl                                        ; $5468
    ld b, [hl]                                    ; $5469
    ld hl, wPrintSrcTable + $4                    ; $546A
    ld d, $03                                     ; $546D

jr_008_546f:
    ld [hl], c                                    ; $546F
    inc hl                                        ; $5470
    ld [hl+], a                                   ; $5471
    ld [hl], b                                    ; $5472
    inc hl                                        ; $5473
    inc hl                                        ; $5474
    add $08                                       ; $5475
    bit 7, a                                      ; $5477
    jr z, jr_008_5480                             ; $5479

    res 7, a                                      ; $547B
    set 6, a                                      ; $547D
    inc b                                         ; $547F

jr_008_5480:
    dec d                                         ; $5480
    jr nz, jr_008_546f                            ; $5481

    jp Far_Call_Return                            ; $5483


; C: far: called from state 2 (08:4254). L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 1C (tcrf_check/assets/l3_names/)
WildFrame_LoadForPrintScreen::
    ld a, [wPageIndex8]                           ; $5486
    ld c, a                                       ; $5489
    sla a                                         ; $548A
    add c                                         ; $548C
    ld c, a                                       ; $548D
    ld b, $00                                     ; $548E
    ld hl, WildFrame_PageSrcTbl                   ; $5490
    add hl, bc                                    ; $5493
    ld c, [hl]                                    ; $5494
    inc hl                                        ; $5495
    ld b, [hl]                                    ; $5496
    inc hl                                        ; $5497
    ld a, [hl]                                    ; $5498
    ld hl, $03c0                                  ; $5499
    add hl, bc                                    ; $549C
    ld de, $8900                                  ; $549D
    ld bc, $0440                                  ; $54A0
    call Wild_MemCopyAdvance                      ; $54A3
    ld bc, $00c0                                  ; $54A6
    call Wild_MemCopyAdvance                      ; $54A9
    farcopy Mem_CopyFromBank, Map_26_5E80_WildFrame_LoadForPrintScreen, $9840, $0240 ; $54AC
    jp Far_Call_Return                            ; $54BA


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1C (tcrf_check/assets/l3_names/)
Wild_MemCopyAdvance::
    push af                                       ; $54BD
    call Mem_CopyFromBank                         ; $54BE
    pop af                                        ; $54C1
    bit 7, h                                      ; $54C2
    ret z                                         ; $54C4

    res 7, h                                      ; $54C5
    set 6, h                                      ; $54C7
    inc a                                         ; $54C9
    ret                                           ; $54CA


; C: far: called from 08:4847. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
WildFrame_LoadForOptionScreen::
    ld a, [wPageIndex8]                           ; $54CB
    ld c, a                                       ; $54CE
    sla a                                         ; $54CF
    add c                                         ; $54D1
    ld c, a                                       ; $54D2
    ld b, $00                                     ; $54D3
    ld hl, WildFrame_PageSrcTbl                   ; $54D5
    add hl, bc                                    ; $54D8
    ld c, [hl]                                    ; $54D9
    inc hl                                        ; $54DA
    ld b, [hl]                                    ; $54DB
    inc hl                                        ; $54DC
    ld a, [hl]                                    ; $54DD
    ld hl, $03c0                                  ; $54DE
    add hl, bc                                    ; $54E1
    ld de, $8900                                  ; $54E2
    ld bc, $0440                                  ; $54E5
    call Wild_VramCopyAdvance                     ; $54E8
    ld bc, $00c0                                  ; $54EB
    call Wild_VramCopyAdvance                     ; $54EE
    farcopy Vram_CopyFromBank, Map_26_5E80_WildFrame_LoadForPrintScreen, $9840, $0240 ; $54F1
    jp Far_Call_Return                            ; $54FF


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Wild_VramCopyAdvance::
    push af                                       ; $5502
    call Vram_CopyFromBank                        ; $5503
    pop af                                        ; $5506
    bit 7, h                                      ; $5507
    ret z                                         ; $5509

    res 7, h                                      ; $550A
    set 6, h                                      ; $550C
    inc a                                         ; $550E
    ret                                           ; $550F


; C: 3-byte {lo;hi;bank} per page: $4000 bank $31 ... | 8 x {lo,hi,bank}: 31:4000, 31:5800, 31:7000, 32:4800, 32:6000,
; 32:7800, 33:5000, 33:6800 (24 bytes, a page is 6 KiB = three 2 KiB chunks); Print_ProgressPackets follows
WildFrame_PageSrcTbl::
    dwb WildFrame0_Tiles
    dwb WildFrame1_Tiles
    dwb WildFrame2_Tiles
    dwb WildFrame3_Tiles
    dwb WildFrame4_Tiles
    dwb WildFrame5_Tiles
    dwb WildFrame6_Tiles
    dwb WildFrame7_Tiles

; C: 16 VRAM-queue streams of 5 bytes {dest hi, dest lo, control $01 = 1 byte, tile, $00 end}: cell k of the progress
; bar at $9A22 + k gets tile $A9 (k = 0), $AA (1-14) or $AB (15); Mode1D_AdvanceProgress (00:3515) selects record a =
; min(hi byte of print_progress_acc >> 3, 15) with BC = $54DE + 5 x a ...
Print_ProgressPackets::
    db $9a, $22, $01, $a9, $00
    db $9a, $23, $01, $aa, $00
    db $9a, $24, $01, $aa, $00
    db $9a, $25, $01, $aa, $00
    db $9a, $26, $01, $aa, $00
    db $9a, $27, $01, $aa, $00
    db $9a, $28, $01, $aa, $00
    db $9a, $29, $01, $aa, $00
    db $9a, $2a, $01, $aa, $00
    db $9a, $2b, $01, $aa, $00
    db $9a, $2c, $01, $aa, $00
    db $9a, $2d, $01, $aa, $00
    db $9a, $2e, $01, $aa, $00
    db $9a, $2f, $01, $aa, $00
    db $9a, $30, $01, $aa, $00
    db $9a, $31, $01, $ab, $00

; C: layout script 0 of Mode1D_LayoutScriptPtrs (00:32E8, index print_layout_type $DB6D = 0, the plain print): 360
; two-byte descriptors {tile, flags} = 20 x 18 tiles = 9 bands of 40 = ONE printer page (720 B). Rows 2-15: 16 photo
; tiles $00-$DF of source 0 between two border tiles each side; border tiles ...
Print_Layout0_Plain::
    INCBIN "data/bank_08/Print_Layout0_Plain.bin" ; $5578, 720 bytes
; C: layout script 1 (print_layout_type 1, the framed print): 600 descriptors = 30 tile rows in THREE printer pages of
; 3 / 7 / 5 bands (6 / 14 / 10 rows, 1,200 B; the pages end on the words $8163, $834F, $C800): page 1 = a blank row
; ($4000 = blank tile) and source 1 tiles $00-$63; page 2 = the photo ...
Print_Layout1_Framed::
    INCBIN "data/bank_08/Print_Layout1_Framed.bin" ; $5848, 1200 bytes
; C: layout script 2 (print_layout_type 2 = ($D5EA xor 1) + 2 at 06:5B22, the 4-photo SHOOT print): 4 printer pages of
; 7 bands (14 rows, 560 B each, 2,240 B): page k holds photo k (source k, tiles $00-$DF, 16 per row) between two blank
; tiles ($4000) each side; pages end on $C000, the last on $C800 (last ...
Print_Layout2_FourPhotos::
    INCBIN "data/bank_08/Print_Layout2_FourPhotos.bin" ; $5CF8, 2240 bytes
; C: layout script 3 (print_layout_type 3, the other 4-photo layout): 4 printer pages of 8 bands (16 rows, 640 B each,
; 2,560 B): photo k (source k) turned by 90 degrees, i.e. descriptors with flags $10 | k (bit 4: 00:3249 rotates each
; 8 x 8 tile) in transposed order $x0D0, $x0C0 ... $x000, $x0D1 ..., 14 ...
Print_Layout3_FourPhotosRotated::
    INCBIN "data/bank_08/Print_Layout3_FourPhotosRotated.bin" ; $65B8, 2560 bytes
; I: layout script 4 (print_layout_type 4 = the info page of 08:475F, source 0 = the page built at $C000 of bank 0):
; one page of 9 bands, 360 descriptors (720 B), tiles $00-$BB and $C0 / $C1 (the end word $C8C0 = last band, blank
; tile, last page); progress word $5B at 00:3112 (C); ends at 08:723D, ...
Print_Layout4_InfoPage::
    INCBIN "data/bank_08/Print_Layout4_InfoPage.bin" ; $6FB8, 720 bytes
; C: mode 19: copyright; title scene
Mode19_TitleScreens::
    call Rng_Next                                 ; $7288
    ld a, [wState]                                ; $728B
    rst Rst18_JumpTable                           ; $728E

; I: 5 states
Mode19_StateTable::
    dw Mode19_State00_CopyrightScreens
    dw Mode19_State01_TitleFirst
    dw Mode19_State02_TitleFromMenu
    dw Mode19_State03_TitleWait
    dw Mode19_State04_Leave

; I: 2nd copyright screen if the CoroCoro tag matches
Mode19_State00_CopyrightScreens::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $7299
    ldh [hLcdcShadow], a                          ; $729B
    ld a, $e4                                     ; $729D
    ld [wPaletteTarget], a                        ; $729F
    xor a                                         ; $72A2
    ldh [hScxShadow], a                           ; $72A3
    ldh [hScyShadow], a                           ; $72A5
    xor a                                         ; $72A7
    ld [wCoroFlag], a                             ; $72A8
    ld a, $18                                     ; $72AB
    ld [wStockPictureCount], a                    ; $72AD
    call Oam_ClearShadow                          ; $72B0
    farcopy Mem_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $72B3
    call Title_BuildAnimScript                    ; $72C1
    farcopy Mem_CopyFromBank, Gfx_21_71C0_Mode19_State00_CopyrightScreens, $9000, $0600 ; $72C4
    farcopy Mem_CopyFromBank, Map_26_6780_Mode19_State00_CopyrightScreens, $9800, $0240 ; $72D2
    call Pal_AllWhite                             ; $72E0
    call Lcd_On                                   ; $72E3
    call Sgb_MaskCancel                           ; $72E6
    play_music MUSIC_STOP                         ; $72E9
    call Pal_FadeIn                               ; $72F0
    ld bc, $0058                                  ; $72F3
    call Wait_Frames                              ; $72F6
    call Title_BgpFadeToBlack                     ; $72F9
    call Title_CheckCoroTag                       ; $72FC
    ld a, $01                                     ; $72FF
    ld [wCoroFlag], a                             ; $7301
    ld a, $1e                                     ; $7304
    ld [wStockPictureCount], a                    ; $7306
    next_state                                    ; $7309
    ret                                           ; $730D


; C: SRAM $BFFD-$BFFF vs 56 56 53: carry when >= 2 bytes match
Title_CheckCoroTag::
    ld a, $00                                     ; $730E
    ld [rRAMB], a                                 ; $7310
    ld hl, $bffd                                  ; $7313
    ld de, Title_CoroTagConst                     ; $7316
    ld bc, $0303                                  ; $7319

jr_008_731c:
    ld a, [de]                                    ; $731C
    cp [hl]                                       ; $731D
    jr nz, jr_008_7321                            ; $731E

    dec c                                         ; $7320

jr_008_7321:
    inc de                                        ; $7321
    inc hl                                        ; $7322
    dec b                                         ; $7323
    jr nz, jr_008_731c                            ; $7324

    ld a, c                                       ; $7326
    cp $02                                        ; $7327
    ret nc                                        ; $7329

    push af                                       ; $732A
    ld a, $0a                                     ; $732B
    ld [rRAMG], a                                 ; $732D
    pop af                                        ; $7330
    ld hl, $bffd                                  ; $7331
    ld de, Title_CoroTagConst                     ; $7334
    ld b, $03                                     ; $7337

jr_008_7339:
    ld a, [de]                                    ; $7339
    ld [hl+], a                                   ; $733A
    inc de                                        ; $733B
    dec b                                         ; $733C
    jr nz, jr_008_7339                            ; $733D

    push af                                       ; $733F
    xor a                                         ; $7340
    ld [rRAMG], a                                 ; $7341
    pop af                                        ; $7344
    scf                                           ; $7345
    ret                                           ; $7346


; C: 56 56 53
Title_CoroTagConst::
    db $56, $56, $53

; C: BGP $F9; $FE; $FF
Title_BgpFadeToBlack::
    ld a, $f9                                     ; $734A
    ldh [hBgpShadow], a                           ; $734C
    ld bc, $0004                                  ; $734E
    call Wait_Frames                              ; $7351
    ld a, $fe                                     ; $7354
    ldh [hBgpShadow], a                           ; $7356
    ld bc, $0004                                  ; $7358
    call Wait_Frames                              ; $735B
    ld a, $ff                                     ; $735E
    ldh [hBgpShadow], a                           ; $7360
    ld bc, $0004                                  ; $7362
    call Wait_Frames                              ; $7365
    ret                                           ; $7368


; C: BGP $FE; $F9; $E4
Title_BgpFadeToNormal::
    ld a, $fe                                     ; $7369
    ldh [hBgpShadow], a                           ; $736B
    ld bc, $0004                                  ; $736D
    call Wait_Frames                              ; $7370
    ld a, $f9                                     ; $7373
    ldh [hBgpShadow], a                           ; $7375
    ld bc, $0004                                  ; $7377
    call Wait_Frames                              ; $737A
    ld a, $e4                                     ; $737D
    ldh [hBgpShadow], a                           ; $737F
    ld bc, $0004                                  ; $7381
    call Wait_Frames                              ; $7384
    ret                                           ; $7387


; C: title scene after the copyright screens; music 1
Mode19_State01_TitleFirst::
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $7388
    ldh [hLcdcShadow], a                          ; $738A
    xor a                                         ; $738C
    ldh [hScxShadow], a                           ; $738D
    ldh [hScyShadow], a                           ; $738F
    ld [wSpriteAnimFrame], a                      ; $7391
    ld [wSpriteAnimTick], a                       ; $7394
    ld a, $ff                                     ; $7397
    ld [wTitleSceneId], a                         ; $7399
    call Oam_ClearShadow                          ; $739C
    farcopy Vram_CopyFromBank, Gfx_3F_6A00_Mode19_State01_TitleFirst, $8900, $0700 ; $739F
    farcopy Vram_CopyFromBank, Gfx_3F_7100_Mode19_State01_TitleFirst, $9500, $0180 ; $73AD
    farcopy Vram_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $73BB
    ld a, $5c                                     ; $73C9
    ldh [hLycShadowSplit1], a                     ; $73CB
    ldh [hSplit1Latch], a                         ; $73CD
    ld hl, hStatShadow                            ; $73CF
    set 6, [hl]                                   ; $73D2
    ld hl, rIE                                    ; $73D4
    set 1, [hl]                                   ; $73D7
    ld a, $01                                     ; $73D9
    ldh [hStatHandlerIndex], a                    ; $73DB
    call Title_StepAnimScript                     ; $73DD
    play_music MUSIC_TITLE                        ; $73E0
    call Title_BgpFadeToNormal                    ; $73E7
    ld b, $0c                                     ; $73EA

jr_008_73ec:
    push bc                                       ; $73EC
    call Title_StepAnimScript                     ; $73ED
    rst Rst08_WaitVBlank                          ; $73F0
    pop bc                                        ; $73F1
    dec b                                         ; $73F2
    jr nz, jr_008_73ec                            ; $73F3

    set_state STATE_19_TITLE_WAIT                 ; $73F5
    ret                                           ; $73FA


; C: B in the main menu enters here
Mode19_State02_TitleFromMenu::
    ld a, LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $73FB
    ldh [hLcdcShadow], a                          ; $73FD
    ld a, $e4                                     ; $73FF
    ld [wPaletteTarget], a                        ; $7401
    xor a                                         ; $7404
    ldh [hScxShadow], a                           ; $7405
    ldh [hScyShadow], a                           ; $7407
    ld [wSpriteAnimFrame], a                      ; $7409
    ld [wSpriteAnimTick], a                       ; $740C
    ld a, $ff                                     ; $740F
    ld [wTitleSceneId], a                         ; $7411
    call Oam_ClearShadow                          ; $7414
    farcopy Mem_CopyFromBank, Gfx_3F_6A00_Mode19_State01_TitleFirst, $8900, $0700 ; $7417
    farcopy Mem_CopyFromBank, Gfx_3F_7100_Mode19_State01_TitleFirst, $9500, $0180 ; $7425
    farcopy Mem_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $7433
    call Title_BuildAnimScript                    ; $7441
    ld a, $5c                                     ; $7444
    ldh [hLycShadowSplit1], a                     ; $7446
    ldh [hSplit1Latch], a                         ; $7448
    ld hl, hStatShadow                            ; $744A
    set 6, [hl]                                   ; $744D
    ld hl, rIE                                    ; $744F
    set 1, [hl]                                   ; $7452
    ld a, $01                                     ; $7454
    ldh [hStatHandlerIndex], a                    ; $7456
    screen_on                                     ; $7458
    call Title_StepAnimScript                     ; $7461
    play_music MUSIC_TITLE                        ; $7464
    call Pal_FadeIn                               ; $746B
    next_state                                    ; $746E
    ret                                           ; $7472


; C: Up = faster; Down = slower; any key -> state 4
Mode19_State03_TitleWait::
    call Title_StepAnimScript                     ; $7473
    ldh a, [hKeysHeld]                            ; $7476
    bit PADB_UP, a                                ; $7478
    jr z, jr_008_7483                             ; $747A

    ld a, $ff                                     ; $747C
    ld [wSpriteAnimTick], a                       ; $747E
    jr Mode19_State03_TitleWait                   ; $7481

jr_008_7483:
    bit 7, a                                      ; $7483
    jr z, jr_008_7489                             ; $7485

    rst Rst08_WaitVBlank                          ; $7487
    ret                                           ; $7488


jr_008_7489:
    ldh a, [hKeysNewSticky]                       ; $7489
    and PADF_A | PADF_B | PADF_START              ; $748B
    ret z                                         ; $748D

    ld [wAbResult], a                             ; $748E
    next_state                                    ; $7491
    ret                                           ; $7495


; C: mode := 0
Mode19_State04_Leave::
    screen_off                                    ; $7496
    stat_irq_off                                  ; $749C
    ld a, MODE_MAIN_MENU                          ; $74A6
    ld [wMode], a                                 ; $74A8
    set_state STATE_00_INIT                       ; $74AB
    ret                                           ; $74B0


; C: frame / tick script at $C000
Title_StepAnimScript::
    ld a, [wSpriteAnimFrame]                      ; $74B1
    sla a                                         ; $74B4
    ld c, a                                       ; $74B6
    ld b, $00                                     ; $74B7
    ld hl, wAnimScript                            ; $74B9
    add hl, bc                                    ; $74BC
    ld a, [wTitleSceneId]                         ; $74BD
    cp [hl]                                       ; $74C0
    ld a, [hl+]                                   ; $74C1
    call nz, Title_LoadScene                      ; $74C2
    ld a, [wSpriteAnimTick]                       ; $74C5
    cp [hl]                                       ; $74C8
    jr c, jr_008_74d9                             ; $74C9

    inc hl                                        ; $74CB
    ld a, [hl+]                                   ; $74CC
    inc a                                         ; $74CD
    ld a, [hl]                                    ; $74CE
    jr z, jr_008_74d5                             ; $74CF

    ld a, [wSpriteAnimFrame]                      ; $74D1
    inc a                                         ; $74D4

jr_008_74d5:
    ld [wSpriteAnimFrame], a                      ; $74D5
    xor a                                         ; $74D8

jr_008_74d9:
    inc a                                         ; $74D9
    ld [wSpriteAnimTick], a                       ; $74DA
    ret                                           ; $74DD


; C: tiles of scene D815 from Title_SceneTbl
Title_LoadScene::
    ld [wTitleSceneId], a                         ; $74DE
    push hl                                       ; $74E1
    ld c, a                                       ; $74E2
    sla a                                         ; $74E3
    add c                                         ; $74E5
    ld c, a                                       ; $74E6
    ld b, $00                                     ; $74E7
    ld hl, Title_SceneTbl                         ; $74E9
    add hl, bc                                    ; $74EC
    ld c, [hl]                                    ; $74ED
    inc hl                                        ; $74EE
    ld b, [hl]                                    ; $74EF
    inc hl                                        ; $74F0
    ld a, [hl]                                    ; $74F1
    ld l, c                                       ; $74F2
    ld h, b                                       ; $74F3
    ld de, $8000                                  ; $74F4
    ld bc, $0900                                  ; $74F7
    push af                                       ; $74FA
    call Vram_CopyFromBank                        ; $74FB
    pop af                                        ; $74FE
    ld de, $9000                                  ; $74FF
    ld bc, $0500                                  ; $7502
    call Vram_CopyFromBank                        ; $7505
    pop hl                                        ; $7508
    ret                                           ; $7509


; C: 3-byte {lo;hi;bank}: 3E:4000. L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic corpus, modes 19
; (tcrf_check/assets/l3_names/)
Title_SceneTbl::
    dwb Gfx_3E_4000_TitleScene
    dwb Gfx_3E_4E00_TitleScene
    dwb Gfx_3E_5C00_TitleScene
    dwb Gfx_3E_6A00_TitleScene
    dwb Gfx_3F_4000_TitleScene
    dwb Gfx_3F_4E00_TitleScene
    dwb Gfx_3F_5C00_TitleScene

; C: 12 map entries x 4 rows from VRAM $9814 / $9834 to $C000
Title_BuildAnimScript::
    ld hl, $9814                                  ; $751F
    ld de, wAnimScript                            ; $7522
    ld b, $02                                     ; $7525

jr_008_7527:
    ld c, $02                                     ; $7527

jr_008_7529:
    push bc                                       ; $7529
    ld c, $0c                                     ; $752A

jr_008_752c:
    ld a, [hl+]                                   ; $752C
    ld [de], a                                    ; $752D
    inc de                                        ; $752E
    inc de                                        ; $752F
    dec c                                         ; $7530
    jr nz, jr_008_752c                            ; $7531

    ld bc, $0034                                  ; $7533
    add hl, bc                                    ; $7536
    pop bc                                        ; $7537
    dec c                                         ; $7538
    jr nz, jr_008_7529                            ; $7539

    ld hl, $9834                                  ; $753B
    ld de, wAnimScript + $1                       ; $753E
    dec b                                         ; $7541
    jr nz, jr_008_7527                            ; $7542

    ld a, $ff                                     ; $7544
    ld [wAnimScript + $30], a                     ; $7546
    xor a                                         ; $7549
    ld [wAnimScript + $31], a                     ; $754A
    ret                                           ; $754D


    ; padding
    ds $ab2, $00

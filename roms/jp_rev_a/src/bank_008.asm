; Pocket Camera (Japan) (Rev A), bank $08. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
    farcopy Mem_CopyFromBank, Map_25_7CA0_Mode1B_State00_Init, $9800, $0240 ; $403C
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
    ld de, $00ff                                  ; $4201
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
    call Oam_AddMeta_B02_5272                     ; $4307
    ld a, [wPrintExtraFlag]                       ; $430A
    and a                                         ; $430D
    ld a, $ca                                     ; $430E
    call nz, Oam_AddMeta_B02_5272                 ; $4310
    ld a, [wJitterX]                              ; $4313
    and $01                                       ; $4316
    add $79                                       ; $4318
    ld b, a                                       ; $431A
    ld a, [wJitterY]                              ; $431B
    and $01                                       ; $431E
    add $8d                                       ; $4320
    ld c, a                                       ; $4322
    ld a, $60                                     ; $4323
    call Oam_AddMeta_B02_5272                     ; $4325
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
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $440B
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
    call Oam_AddMeta_B02_5272                     ; $4485
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


; C: tilemap 27:4472 and border tiles; BGB watchpoint pass 2026-10-25: ran only in mode 1C (4 hits in 2 runs: 1C:05
; x4; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawPrintScreen::
    call Oam_ClearShadow                          ; $47ED
    farcopy Vram_CopyFromBank, Map_27_4472_Mode1C_DrawOptionScreen, $9800, $02c0 ; $47F0
    farcopy Vram_CopyFromBank, Gfx_18_7F60_Mode1C_State02_ShowPrintScreen, $8f00, $0050 ; $47FE
    ld a, [wPrintLayoutFlag]                      ; $480C
    and a                                         ; $480F
    jr nz, jr_008_4840                            ; $4810

    ld a, [wBorderNormalised]                     ; $4812
    and a                                         ; $4815
    jr nz, jr_008_4835                            ; $4816

    ld a, [wCopyPhotoIdxB]                        ; $4818
    ldh [hFarcallAArg], a                         ; $481B
    farcall Photo_LoadBorder_Far                  ; $481D
    ld a, [wBorderNumber]                         ; $4825
    cp $12                                        ; $4828
    jr nz, jr_008_4835                            ; $482A

    xor a                                         ; $482C
    ld [wBorderNumber], a                         ; $482D
    ld a, $01                                     ; $4830
    ld [wBorderNormalised], a                     ; $4832

jr_008_4835:
    ldh [hFarcallAArg], a                         ; $4835
    ld a, $08                                     ; $4837
    ld hl, Border_LoadMap_Safe                    ; $4839
    call Far_Call                                 ; $483C
    ret                                           ; $483F


jr_008_4840:
    ldh [hFarcallAArg], a                         ; $4840
    ld a, $08                                     ; $4842
    ld hl, WildFrame_LoadForOptionScreen          ; $4844
    call Far_Call                                 ; $4847
    ret                                           ; $484A


; C: BGB watchpoint pass 2026-10-25: ran only in mode 1C (30 hits in 13 runs: 1C:03 x30;
; tcrf_check/assets/mode_state_wp/)
Mode1C_DrawOptionScreen::
    call Oam_ClearShadow                          ; $484B
    farcopy Vram_CopyFromBank, Map_27_4472_Mode1C_DrawOptionScreen, $9800, $02c0 ; $484E
    farcopy Vram_CopyFromBank, Gfx_18_7400_Mode1C_State02_ShowPrintScreen, $8b00, $0500 ; $485C
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $486A
    farcopy Vram_CopyFromBank, Map_24_6BA0_Mode1C_State02_ShowPrintScreen, $9800, $02c0 ; $4878
    ret                                           ; $4886


; C: mode 1E: multi-photo print (margin; selection bitmap; job)
Mode1E_PrintOption::
    ld a, [wState]                                ; $4887
    rst Rst18_JumpTable                           ; $488A

; C: 6 states
Mode1E_StateTable::
    dw Mode1E_State00_Init
    dw Mode1E_State01_Page1Margin
    dw Mode1E_State02_Page2SelectPhotos
    dw Mode1E_State03_Page3Confirm
    dw Mode1E_State04_Leave
    dw Mode1E_State05_PrintJob

; C
Mode1E_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4897
    ldh [hLcdcShadow], a                          ; $4899
    ld a, $e4                                     ; $489B
    ld [wPaletteTarget], a                        ; $489D
    ld [wPaletteTarget + $1], a                   ; $48A0
    ld a, $d2                                     ; $48A3
    ld [wPaletteTarget + $2], a                   ; $48A5
    xor a                                         ; $48A8
    ldh [hScxShadow], a                           ; $48A9
    ldh [hScyShadow], a                           ; $48AB
    ld [wPrintCursor], a                          ; $48AD
    ldh [hFarcallAArg], a                         ; $48B0
    farcall Counters_Load_Far                     ; $48B2
    farcopy Mem_CopyFromBank, Gfx_18_5470_Mode1E_State00_Init, $9000, $0800 ; $48BA
    farcopy Mem_CopyFromBank, Gfx_18_5C70_Mode1E_State00_Init, $8800, $0800 ; $48C8
    farcopy Mem_CopyFromBank, Map_26_57C0_Mode1E_State00_Init, $9800, $0240 ; $48D6
    screen_on                                     ; $48E4
    play_music MUSIC_TIMER_PRINT_OPTIONS          ; $48ED
    call Print_LoadCursorThumbnail                ; $48F4
    call Print_LoadSelectedDigit                  ; $48F7
    call Print_DrawMarginDigit                    ; $48FA
    call Print_DrawSelectedCount                  ; $48FD
    call Print_DrawPageNumbers                    ; $4900
    call Print_DrawPageIcon                       ; $4903
    ld e, $00                                     ; $4906
    call Print_DrawPageArrow                      ; $4908
    call Pal_FadeIn                               ; $490B
    next_state                                    ; $490E
    ret                                           ; $4912


; C: margin lines 0..9
Mode1E_State01_Page1Margin::
    call Print_IdleThumbnailRefresh               ; $4913
    call Mode1E_ReadMarginKeys                    ; $4916
    call Print_DrawPageIcon                       ; $4919
    ld e, $01                                     ; $491C
    call Print_DrawPageArrow                      ; $491E
    ld bc, $0000                                  ; $4921
    call Print_DrawBlinkingCursor                 ; $4924
    ldh a, [hKeysNew]                             ; $4927
    ld b, a                                       ; $4929
    ld [wAbResult], a                             ; $492A
    and PADF_A | PADF_DOWN                        ; $492D
    jr z, jr_008_4948                             ; $492F

    push af                                       ; $4931
    bit 0, a                                      ; $4932
    ld a, SFX1_KEY_A                              ; $4934
    call nz, Snd_Sfx1                             ; $4936
    pop af                                        ; $4939
    push af                                       ; $493A
    bit 7, a                                      ; $493B
    ld a, SFX1_KEY_UP_DOWN                        ; $493D
    call nz, Snd_Sfx1                             ; $493F
    pop af                                        ; $4942
    next_state                                    ; $4943
    ret                                           ; $4947


jr_008_4948:
    bit 1, b                                      ; $4948
    ret z                                         ; $494A

    play_sfx1 SFX1_KEY_B                          ; $494B
    set_state STATE_1E_LEAVE                      ; $4952
    ret                                           ; $4957


; C
Mode1E_ReadMarginKeys::
    ldh a, [hKeysNewRepeat]                       ; $4958
    ld b, a                                       ; $495A
    ld a, [wPrintMarginLines]                     ; $495B
    bit 5, b                                      ; $495E
    jr z, jr_008_4967                             ; $4960

    and a                                         ; $4962
    ret z                                         ; $4963

    dec a                                         ; $4964
    jr jr_008_496e                                ; $4965

jr_008_4967:
    bit 4, b                                      ; $4967
    ret z                                         ; $4969

    cp $09                                        ; $496A
    ret z                                         ; $496C

    inc a                                         ; $496D

jr_008_496e:
    ld hl, wPrintMarginLines                      ; $496E
    cp [hl]                                       ; $4971
    ret z                                         ; $4972

    ld [hl], a                                    ; $4973
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4974
    call Print_DrawMarginDigit                    ; $497B
    ret                                           ; $497E


; C: cursor 0..29 and selection bitmap D808
Mode1E_State02_Page2SelectPhotos::
    call Print_IdleThumbnailRefresh               ; $497F
    call Mode1E_ToggleSelection                   ; $4982
    call Mode1E_MoveCursor                        ; $4985
    call Print_DrawPageIcon                       ; $4988
    call Print_DrawCursorMarker                   ; $498B
    call Print_DrawSelectedMarker                 ; $498E
    ld e, $00                                     ; $4991
    call Print_DrawPageArrow                      ; $4993
    ld a, [wPrintCursor]                          ; $4996
    sla a                                         ; $4999
    sla a                                         ; $499B
    ld b, a                                       ; $499D
    ld c, $03                                     ; $499E
    call Print_DrawBlinkingCursor                 ; $49A0
    ldh a, [hKeysNew]                             ; $49A3
    ld b, a                                       ; $49A5
    ld [wAbResult], a                             ; $49A6
    bit 7, b                                      ; $49A9
    jr z, jr_008_49b9                             ; $49AB

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $49AD
    next_state                                    ; $49B4
    ret                                           ; $49B8


jr_008_49b9:
    bit 6, b                                      ; $49B9
    jr z, jr_008_49c9                             ; $49BB

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $49BD
    ld hl, wState                                 ; $49C4
    dec [hl]                                      ; $49C7
    ret                                           ; $49C8


jr_008_49c9:
    bit 1, b                                      ; $49C9
    ret z                                         ; $49CB

    play_sfx1 SFX1_KEY_B                          ; $49CC
    set_state STATE_1E_LEAVE                      ; $49D3
    ret                                           ; $49D8


; C: A toggles the photo under the cursor
Mode1E_ToggleSelection::
    ldh a, [hKeysNewSticky]                       ; $49D9
    bit PADB_A, a                                 ; $49DB
    ret z                                         ; $49DD

    ld a, [wPrintCursor]                          ; $49DE
    ld hl, wPhotoCount                            ; $49E1
    cp [hl]                                       ; $49E4
    jr c, jr_008_49ef                             ; $49E5

    play_sfx1 SFX1_KEY_B                          ; $49E7
    ret                                           ; $49EE


jr_008_49ef:
    call Print_ToggleSelectBit                    ; $49EF
    jr nz, jr_008_49fd                            ; $49F2

    play_sfx1 SFX1_KEY_A                          ; $49F4
    jr jr_008_4a04                                ; $49FB

jr_008_49fd:
    play_sfx1 SFX1_MENU_CHOOSE                    ; $49FD

jr_008_4a04:
    ld a, [wPrintCursor]                          ; $4A04
    call Print_DrawSelectionDigits                ; $4A07
    call Print_DrawSelectedCount                  ; $4A0A
    ret                                           ; $4A0D


; C
Mode1E_MoveCursor::
    ldh a, [hKeysRepeatSticky]                    ; $4A0E
    ld b, a                                       ; $4A10
    ld a, [wPrintCursor]                          ; $4A11
    bit 5, b                                      ; $4A14
    jr z, jr_008_4a1d                             ; $4A16

    and a                                         ; $4A18
    ret z                                         ; $4A19

    dec a                                         ; $4A1A
    jr jr_008_4a24                                ; $4A1B

jr_008_4a1d:
    bit 4, b                                      ; $4A1D
    ret z                                         ; $4A1F

    cp $1d                                        ; $4A20
    ret z                                         ; $4A22

    inc a                                         ; $4A23

jr_008_4a24:
    ld hl, wPrintCursor                           ; $4A24
    cp [hl]                                       ; $4A27
    ret z                                         ; $4A28

    ld [hl], a                                    ; $4A29
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4A2A
    call Print_LoadCursorThumbnail                ; $4A31
    call Print_LoadSelectedDigit                  ; $4A34
    ret                                           ; $4A37


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Mode1E_State03_Page3Confirm::
    call Print_IdleThumbnailRefresh               ; $4A38
    call Print_DrawPageIcon                       ; $4A3B
    ld e, $00                                     ; $4A3E
    call Print_DrawPageArrow                      ; $4A40
    ld bc, $0006                                  ; $4A43
    call Print_DrawBlinkingCursor                 ; $4A46
    ldh a, [hKeysNew]                             ; $4A49
    ld b, a                                       ; $4A4B
    ld [wAbResult], a                             ; $4A4C
    bit 0, b                                      ; $4A4F
    jr z, jr_008_4a5f                             ; $4A51

    play_sfx1 SFX1_KEY_A                          ; $4A53
    next_state                                    ; $4A5A
    ret                                           ; $4A5E


jr_008_4a5f:
    bit 6, b                                      ; $4A5F
    jr z, jr_008_4a6f                             ; $4A61

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4A63
    ld hl, wState                                 ; $4A6A
    dec [hl]                                      ; $4A6D
    ret                                           ; $4A6E


jr_008_4a6f:
    bit 1, b                                      ; $4A6F
    ret z                                         ; $4A71

    play_sfx1 SFX1_KEY_B                          ; $4A72
    next_state                                    ; $4A79
    ret                                           ; $4A7D


; C: A starts the job: print_job_index := 0
Mode1E_State04_Leave::
    screen_off                                    ; $4A7E
    ld a, [wAbResult]                             ; $4A84
    bit 1, a                                      ; $4A87
    jr nz, jr_008_4a9c                            ; $4A89

    xor a                                         ; $4A8B
    ld [wPrintJobIndex], a                        ; $4A8C
    ld [wPrintAbortFlag], a                       ; $4A8F
    ld a, $01                                     ; $4A92
    ld [wPrintFirstPhotoFlag], a                  ; $4A94
    next_state                                    ; $4A97
    ret                                           ; $4A9B


jr_008_4a9c:
    ld a, MODE_PRINT_MENU                         ; $4A9C
    ld [wMode], a                                 ; $4A9E
    set_state STATE_1B_INIT                       ; $4AA1
    ret                                           ; $4AA6


; C
Mode1E_State05_PrintJob::
    ld a, [wPrintAbortFlag]                       ; $4AA7
    and a                                         ; $4AAA
    jr nz, jr_008_4ab4                            ; $4AAB

    ld a, [wPrintJobIndex]                        ; $4AAD
    cp $3c                                        ; $4AB0
    jr c, jr_008_4aba                             ; $4AB2

jr_008_4ab4:
    set_state STATE_1E_INIT                       ; $4AB4
    ret                                           ; $4AB9


jr_008_4aba:
    srl a                                         ; $4ABA
    srl a                                         ; $4ABC
    srl a                                         ; $4ABE
    ld c, a                                       ; $4AC0
    ld b, $00                                     ; $4AC1
    ld hl, wPrintSelectBitmap                     ; $4AC3
    add hl, bc                                    ; $4AC6
    push hl                                       ; $4AC7
    ld a, [wPrintJobIndex]                        ; $4AC8
    and $07                                       ; $4ACB
    ld c, a                                       ; $4ACD
    ld b, $00                                     ; $4ACE
    ld hl, Print_BitMaskTbl                       ; $4AD0
    add hl, bc                                    ; $4AD3
    ld a, [hl]                                    ; $4AD4
    pop hl                                        ; $4AD5
    and [hl]                                      ; $4AD6
    jr z, jr_008_4b43                             ; $4AD7

    ld a, [wPrintJobIndex]                        ; $4AD9
    ldh [hFarcallAArg], a                         ; $4ADC
    farcall Photo_GetSramAddress_Far              ; $4ADE
    ld [wPrintSrcTable + $2], a                   ; $4AE6
    ld a, b                                       ; $4AE9
    ld [wPrintSrcTable + $1], a                   ; $4AEA
    ld a, c                                       ; $4AED
    ld [wPrintSrcTable], a                        ; $4AEE
    ld a, [wPrintJobIndex]                        ; $4AF1
    ldh [hFarcallAArg], a                         ; $4AF4
    farcall Photo_LoadBorder_Far                  ; $4AF6
    ldh [hFarcallAArg], a                         ; $4AFE
    ld a, $08                                     ; $4B00
    ld hl, Border_FillPrintSource                 ; $4B02
    call Far_Call                                 ; $4B05
    xor a                                         ; $4B08
    ld [wPrintLayoutType], a                      ; $4B09
    ld a, $04                                     ; $4B0C
    ld [wPrintReturnIdx], a                       ; $4B0E
    ld a, $01                                     ; $4B11
    ld [wPrintCustomMargin], a                    ; $4B13
    ld [wPrintPages], a                           ; $4B16
    ld b, $00                                     ; $4B19
    ld a, [wPrintMarginLines]                     ; $4B1B
    ld c, a                                       ; $4B1E
    ld a, [wPrintFirstPhotoFlag]                  ; $4B1F
    and a                                         ; $4B22
    jr z, jr_008_4b27                             ; $4B23

    ld b, $10                                     ; $4B25

jr_008_4b27:
    push bc                                       ; $4B27
    call Print_TestSelectBit                      ; $4B28
    pop bc                                        ; $4B2B
    jr nz, jr_008_4b30                            ; $4B2C

    ld c, $03                                     ; $4B2E

jr_008_4b30:
    ld a, b                                       ; $4B30
    or c                                          ; $4B31
    ld [wPrintMarginByte], a                      ; $4B32
    ld a, MODE_PRINT_JOB                          ; $4B35
    ld [wMode], a                                 ; $4B37
    set_state STATE_1D_INIT                       ; $4B3A
    xor a                                         ; $4B3F
    ld [wPrintFirstPhotoFlag], a                  ; $4B40

jr_008_4b43:
    ld hl, wPrintJobIndex                         ; $4B43
    inc [hl]                                      ; $4B46
    ret                                           ; $4B47


; C: $80 $40 .. $01
Print_BitMaskTbl::
    db $80, $40, $20, $10, $08, $04, $02, $01

; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageArrow::
    ld bc, $1c40                                  ; $4B50
    ld a, $ac                                     ; $4B53
    add e                                         ; $4B55
    call Oam_AddMeta_B02_5272                     ; $4B56
    ret                                           ; $4B59


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageIcon::
    ld bc, $5046                                  ; $4B5A
    ld a, $af                                     ; $4B5D
    call Oam_AddMeta_B02_5272                     ; $4B5F
    ret                                           ; $4B62


; C: blink phase mod 10; shown while < 6
Print_DrawBlinkingCursor::
    ld a, [wPrintCursorBlink]                     ; $4B63
    inc a                                         ; $4B66
    cp $0a                                        ; $4B67
    jr c, jr_008_4b6c                             ; $4B69

    xor a                                         ; $4B6B

jr_008_4b6c:
    ld [wPrintCursorBlink], a                     ; $4B6C
    cp $06                                        ; $4B6F
    ret nc                                        ; $4B71

    push bc                                       ; $4B72
    ld b, $00                                     ; $4B73
    ld hl, Print_CursorSpriteTbl                  ; $4B75
    add hl, bc                                    ; $4B78
    pop bc                                        ; $4B79
    ld c, [hl]                                    ; $4B7A
    inc hl                                        ; $4B7B
    ld a, [hl+]                                   ; $4B7C
    add b                                         ; $4B7D
    ld b, a                                       ; $4B7E
    ld a, [hl]                                    ; $4B7F
    call Oam_AddMeta_B02_5272                     ; $4B80
    ret                                           ; $4B83


; C: 3 x (x; y; sprite). L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1E
; (tcrf_check/assets/l3_names/)
Print_CursorSpriteTbl::
    db $40, $19, $b0, $60, $1a, $b0, $74, $65, $b1

; C: A = digit; copies 2 tiles from 20:7180. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 1E (tcrf_check/assets/l3_names/)
Print_DrawDigitTiles::
    swap a                                        ; $4B8D
    ld c, a                                       ; $4B8F
    ld b, $00                                     ; $4B90
    sla c                                         ; $4B92
    rl b                                          ; $4B94
    ld hl, $7180                                  ; $4B96
    add hl, bc                                    ; $4B99
    ld a, $20                                     ; $4B9A
    ld bc, $0020                                  ; $4B9C
    call Vram_CopyFromBank                        ; $4B9F
    ret                                           ; $4BA2


; C
Print_DrawMarginDigit::
    ld de, $88a0                                  ; $4BA3
    ld a, [wPrintMarginLines]                     ; $4BA6
    jp Print_DrawDigitTiles                       ; $4BA9


; C: two-digit count of selected photos
Print_DrawSelectedCount::
    call Print_CountSelectedBits                  ; $4BAC
    ld c, $00                                     ; $4BAF

jr_008_4bb1:
    cp $0a                                        ; $4BB1
    jr c, jr_008_4bba                             ; $4BB3

    sub $0a                                       ; $4BB5
    inc c                                         ; $4BB7
    jr jr_008_4bb1                                ; $4BB8

jr_008_4bba:
    push af                                       ; $4BBA
    ld a, c                                       ; $4BBB
    ld de, $88e0                                  ; $4BBC
    call Print_DrawDigitTiles                     ; $4BBF
    pop af                                        ; $4BC2
    jp Print_DrawDigitTiles                       ; $4BC3


; C: counts the bits of D808..D80F
Print_CountSelectedBits::
    ld hl, wPrintSelectBitmap                     ; $4BC6
    ld bc, $0800                                  ; $4BC9

jr_008_4bcc:
    bit 7, [hl]                                   ; $4BCC
    jr z, jr_008_4bd1                             ; $4BCE

    inc c                                         ; $4BD0

jr_008_4bd1:
    bit 6, [hl]                                   ; $4BD1
    jr z, jr_008_4bd6                             ; $4BD3

    inc c                                         ; $4BD5

jr_008_4bd6:
    bit 5, [hl]                                   ; $4BD6
    jr z, jr_008_4bdb                             ; $4BD8

    inc c                                         ; $4BDA

jr_008_4bdb:
    bit 4, [hl]                                   ; $4BDB
    jr z, jr_008_4be0                             ; $4BDD

    inc c                                         ; $4BDF

jr_008_4be0:
    bit 3, [hl]                                   ; $4BE0
    jr z, jr_008_4be5                             ; $4BE2

    inc c                                         ; $4BE4

jr_008_4be5:
    bit 2, [hl]                                   ; $4BE5
    jr z, jr_008_4bea                             ; $4BE7

    inc c                                         ; $4BE9

jr_008_4bea:
    bit 1, [hl]                                   ; $4BEA
    jr z, jr_008_4bef                             ; $4BEC

    inc c                                         ; $4BEE

jr_008_4bef:
    bit 0, [hl]                                   ; $4BEF
    jr z, jr_008_4bf4                             ; $4BF1

    inc c                                         ; $4BF3

jr_008_4bf4:
    inc hl                                        ; $4BF4
    dec b                                         ; $4BF5
    jr nz, jr_008_4bcc                            ; $4BF6

    ld a, c                                       ; $4BF8
    ret                                           ; $4BF9


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawPageNumbers::
    ld c, $00                                     ; $4BFA
    ld a, [wPrintCursor]                          ; $4BFC
    cp $1e                                        ; $4BFF
    jr c, jr_008_4c05                             ; $4C01

    ld c, $1e                                     ; $4C03

jr_008_4c05:
    ld b, $1e                                     ; $4C05

jr_008_4c07:
    push bc                                       ; $4C07
    ld a, c                                       ; $4C08
    call Print_DrawSelectionDigits                ; $4C09
    pop bc                                        ; $4C0C
    inc c                                         ; $4C0D
    dec b                                         ; $4C0E
    jr nz, jr_008_4c07                            ; $4C0F

    ret                                           ; $4C11


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawSelectionDigits::
    ldh [hScratchA], a                            ; $4C12
    cp $1e                                        ; $4C14
    jr c, jr_008_4c1a                             ; $4C16

    sub $1e                                       ; $4C18

jr_008_4c1a:
    srl a                                         ; $4C1A
    ld c, a                                       ; $4C1C
    ld b, $00                                     ; $4C1D
    ld hl, $9943                                  ; $4C1F
    add hl, bc                                    ; $4C22
    push hl                                       ; $4C23
    ldh a, [hScratchA]                            ; $4C24
    srl a                                         ; $4C26
    srl a                                         ; $4C28
    srl a                                         ; $4C2A
    ld c, a                                       ; $4C2C
    ld b, $00                                     ; $4C2D
    ld hl, wPrintSelectBitmap                     ; $4C2F
    add hl, bc                                    ; $4C32
    push hl                                       ; $4C33
    ldh a, [hScratchA]                            ; $4C34
    and $07                                       ; $4C36
    ld c, a                                       ; $4C38
    ld b, $00                                     ; $4C39
    ld hl, Print_SelectMarkTbl                    ; $4C3B
    add hl, bc                                    ; $4C3E
    ld a, [hl]                                    ; $4C3F
    pop hl                                        ; $4C40
    and [hl]                                      ; $4C41
    ld c, $00                                     ; $4C42
    ldh [hScratchA], a                            ; $4C44
    and $aa                                       ; $4C46
    jr z, jr_008_4c4b                             ; $4C48

    inc c                                         ; $4C4A

jr_008_4c4b:
    ldh a, [hScratchA]                            ; $4C4B
    and $55                                       ; $4C4D
    jr z, jr_008_4c53                             ; $4C4F

    inc c                                         ; $4C51
    inc c                                         ; $4C52

jr_008_4c53:
    ld b, $00                                     ; $4C53
    ld hl, Print_DrawSelectionDigits_PtrTbl4C6F   ; $4C55
    add hl, bc                                    ; $4C58
    ld a, [hl]                                    ; $4C59
    pop hl                                        ; $4C5A
    call Vram_WriteByteSafe                       ; $4C5B
    ld bc, $0020                                  ; $4C5E
    add hl, bc                                    ; $4C61
    inc a                                         ; $4C62
    call Vram_WriteByteSafe                       ; $4C63
    ret                                           ; $4C66


; C: L3 pass 2026-10-26: read in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_SelectMarkTbl::
    db $c0, $c0, $30, $30, $0c, $0c, $03, $03

; C: auto: 4 bytes, word table; referenced by Print_DrawSelectionDigits. L3 pass 2026-10-26: read in BGB in 1
; replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_DrawSelectionDigits_PtrTbl4C6F::
    dw $5256
    dw $5450

; C
Print_ToggleSelectBit::
    ld a, [wPrintCursor]                          ; $4C73
    srl a                                         ; $4C76
    srl a                                         ; $4C78
    srl a                                         ; $4C7A
    ld c, a                                       ; $4C7C
    ld b, $00                                     ; $4C7D
    ld hl, wPrintSelectBitmap                     ; $4C7F
    add hl, bc                                    ; $4C82
    push hl                                       ; $4C83
    ld a, [wPrintCursor]                          ; $4C84
    and $07                                       ; $4C87
    ld c, a                                       ; $4C89
    ld b, $00                                     ; $4C8A
    ld hl, Print_BitMaskTbl                       ; $4C8C
    add hl, bc                                    ; $4C8F
    ld a, [hl]                                    ; $4C90
    pop hl                                        ; $4C91
    ld c, [hl]                                    ; $4C92
    xor [hl]                                      ; $4C93
    ld [hl], a                                    ; $4C94
    xor c                                         ; $4C95
    and c                                         ; $4C96
    ret                                           ; $4C97


; C
Print_TestSelectBit::
    ld a, [wPrintJobIndex]                        ; $4C98
    srl a                                         ; $4C9B
    srl a                                         ; $4C9D
    srl a                                         ; $4C9F
    ld c, a                                       ; $4CA1
    ld b, $00                                     ; $4CA2
    ld hl, wPrintSelectBitmap                     ; $4CA4
    add hl, bc                                    ; $4CA7
    push bc                                       ; $4CA8
    push hl                                       ; $4CA9
    ld a, [wPrintJobIndex]                        ; $4CAA
    and $07                                       ; $4CAD
    ld c, a                                       ; $4CAF
    ld b, $00                                     ; $4CB0
    ld hl, Print_ShiftMaskTbl                     ; $4CB2
    add hl, bc                                    ; $4CB5
    ld a, [hl]                                    ; $4CB6
    pop hl                                        ; $4CB7
    pop bc                                        ; $4CB8

jr_008_4cb9:
    and [hl]                                      ; $4CB9
    ret nz                                        ; $4CBA

    ld a, $ff                                     ; $4CBB
    inc hl                                        ; $4CBD
    inc c                                         ; $4CBE
    bit 3, c                                      ; $4CBF
    jr z, jr_008_4cb9                             ; $4CC1

    xor a                                         ; $4CC3
    ret                                           ; $4CC4


; C: $7F $3F .. $00. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz, first read in mode 1E)
Print_ShiftMaskTbl::
    db $7f, $3f, $1f, $0f, $07, $03, $01, $00

; C: far call 02:517B; tiles to $8CA0
Print_LoadCursorThumbnail::
    xor a                                         ; $4CCD
    ld [wPrintIdleCounter], a                     ; $4CCE
    ld a, [wPrintCursor]                          ; $4CD1
    ldh [hFarcallAArg], a                         ; $4CD4
    farcall Photo_GetSramAddress_Far              ; $4CD6
    ld hl, $0e00                                  ; $4CDE
    add hl, bc                                    ; $4CE1
    ld de, $8ca0                                  ; $4CE2
    ld b, $03                                     ; $4CE5

jr_008_4ce7:
    push af                                       ; $4CE7
    push bc                                       ; $4CE8
    ld bc, $0040                                  ; $4CE9
    call Vram_CopyFromBank                        ; $4CEC
    ld a, e                                       ; $4CEF
    add $40                                       ; $4CF0
    ld e, a                                       ; $4CF2
    jr nc, jr_008_4cf6                            ; $4CF3

    inc d                                         ; $4CF5

jr_008_4cf6:
    pop bc                                        ; $4CF6
    pop af                                        ; $4CF7
    dec b                                         ; $4CF8
    jr nz, jr_008_4ce7                            ; $4CF9

    ld b, $04                                     ; $4CFB

jr_008_4cfd:
    push af                                       ; $4CFD
    push bc                                       ; $4CFE
    ld bc, $0008                                  ; $4CFF
    call Vram_CopyFromBank                        ; $4D02
    ld a, e                                       ; $4D05
    add $08                                       ; $4D06
    ld e, a                                       ; $4D08
    jr nc, jr_008_4d0c                            ; $4D09

    inc d                                         ; $4D0B

jr_008_4d0c:
    ld bc, $0008                                  ; $4D0C
    add hl, bc                                    ; $4D0F
    pop bc                                        ; $4D10
    pop af                                        ; $4D11
    dec b                                         ; $4D12
    jr nz, jr_008_4cfd                            ; $4D13

    ret                                           ; $4D15


; C: after 10 idle frames the big thumbnail is rebuilt
Print_IdleThumbnailRefresh::
    ldh a, [hKeysHeld]                            ; $4D16
    and PADF_B | PADF_SELECT | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $4D18
    ret nz                                        ; $4D1A

    ld a, [wPrintIdleCounter]                     ; $4D1B
    cp $0a                                        ; $4D1E
    jr z, jr_008_4d2a                             ; $4D20

    cp $ff                                        ; $4D22
    ret z                                         ; $4D24

    inc a                                         ; $4D25
    ld [wPrintIdleCounter], a                     ; $4D26
    ret                                           ; $4D29


jr_008_4d2a:
    inc a                                         ; $4D2A
    ld [wPrintIdleCounter], a                     ; $4D2B
    ld a, [wPrintCursor]                          ; $4D2E
    ldh [hFarcallAArg], a                         ; $4D31
    farcall Photo_GetSramAddress_Far              ; $4D33
    ld l, a                                       ; $4D3B
    push hl                                       ; $4D3C
    push bc                                       ; $4D3D
    ld hl, sp+$00                                 ; $4D3E
    ld bc, wPrintReadback                         ; $4D40
    call Img_ReduceTo64x56                        ; $4D43
    pop bc                                        ; $4D46
    pop hl                                        ; $4D47
    jr nc, jr_008_4d5b                            ; $4D48

    xor a                                         ; $4D4A
    ld [wPrintIdleCounter], a                     ; $4D4B
    ldh a, [hKeysHeldSticky]                      ; $4D4E
    ldh [hKeysHeld], a                            ; $4D50
    ldh a, [hKeysNewSticky]                       ; $4D52
    ldh [hKeysNew], a                             ; $4D54
    ldh a, [hKeysRepeatSticky]                    ; $4D56
    ldh [hKeysNewRepeat], a                       ; $4D58
    ret                                           ; $4D5A


jr_008_4d5b:
    ld a, $00                                     ; $4D5B
    ld hl, wPrintReadback                         ; $4D5D
    ld de, $8c00                                  ; $4D60
    ld bc, $0380                                  ; $4D63
    call Vram_CopyFromBank                        ; $4D66
    ret                                           ; $4D69


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_LoadSelectedDigit::
    xor a                                         ; $4D6A
    ld [wPrintMarkerBlinkA], a                    ; $4D6B
    ld [wPrintMarkerBlinkB], a                    ; $4D6E
    ld a, [wPrintCursor]                          ; $4D71
    cp $1e                                        ; $4D74
    jr c, jr_008_4d7a                             ; $4D76

    sub $1e                                       ; $4D78

jr_008_4d7a:
    inc a                                         ; $4D7A
    ld c, $00                                     ; $4D7B

jr_008_4d7d:
    cp $0a                                        ; $4D7D
    jr c, jr_008_4d86                             ; $4D7F

    sub $0a                                       ; $4D81
    inc c                                         ; $4D83
    jr jr_008_4d7d                                ; $4D84

jr_008_4d86:
    push af                                       ; $4D86
    ld a, c                                       ; $4D87
    ld de, $88c0                                  ; $4D88
    call Print_LoadDigitTile                      ; $4D8B
    pop af                                        ; $4D8E

; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1E (tcrf_check/assets/l3_names/)
Print_LoadDigitTile::
    swap a                                        ; $4D8F
    ld c, a                                       ; $4D91
    ld b, $00                                     ; $4D92
    ld hl, $5c70                                  ; $4D94
    add hl, bc                                    ; $4D97
    ld a, $18                                     ; $4D98
    ld bc, $0010                                  ; $4D9A
    call Vram_CopyFromBank                        ; $4D9D
    ret                                           ; $4DA0


; C: blinking marker sprite $AE
Print_DrawCursorMarker::
    ld a, [wPrintMarkerBlinkA]                    ; $4DA1
    inc a                                         ; $4DA4
    cp $40                                        ; $4DA5
    jr c, jr_008_4daa                             ; $4DA7

    xor a                                         ; $4DA9

jr_008_4daa:
    ld [wPrintMarkerBlinkA], a                    ; $4DAA
    cp $1e                                        ; $4DAD
    ret nc                                        ; $4DAF

    ld bc, $5046                                  ; $4DB0
    ld a, $ae                                     ; $4DB3
    call Oam_AddMeta_B02_5272                     ; $4DB5
    ret                                           ; $4DB8


; C: marker sprite $B2 when the photo is selected
Print_DrawSelectedMarker::
    ld a, [wPrintCursor]                          ; $4DB9
    srl a                                         ; $4DBC
    srl a                                         ; $4DBE
    srl a                                         ; $4DC0
    ld c, a                                       ; $4DC2
    ld b, $00                                     ; $4DC3
    ld hl, wPrintSelectBitmap                     ; $4DC5
    add hl, bc                                    ; $4DC8
    push hl                                       ; $4DC9
    ld a, [wPrintCursor]                          ; $4DCA
    and $07                                       ; $4DCD
    ld c, a                                       ; $4DCF
    ld b, $00                                     ; $4DD0
    ld hl, Print_BitMaskTbl                       ; $4DD2
    add hl, bc                                    ; $4DD5
    ld a, [hl]                                    ; $4DD6
    pop hl                                        ; $4DD7
    and [hl]                                      ; $4DD8
    ret z                                         ; $4DD9

    ld a, [wPrintMarkerBlinkB]                    ; $4DDA
    inc a                                         ; $4DDD
    cp $40                                        ; $4DDE
    jr c, jr_008_4de3                             ; $4DE0

    xor a                                         ; $4DE2

jr_008_4de3:
    ld [wPrintMarkerBlinkB], a                    ; $4DE3
    cp $1e                                        ; $4DE6
    ret nc                                        ; $4DE8

    ld bc, $4f20                                  ; $4DE9
    ld a, $b2                                     ; $4DEC
    call Oam_AddMeta_B02_5272                     ; $4DEE
    ret                                           ; $4DF1


; C: print border (frame) chooser; 3 substates
BorderPicker_Far::
    ld a, [wSubstate]                             ; $4DF2
    rst Rst18_JumpTable                           ; $4DF5

; C
BorderPicker_SubstateTbl::
    dw BorderPicker_Substate0_Init
    dw BorderPicker_Substate1_Browse
    dw BorderPicker_Substate2_Exit

; C
BorderPicker_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4DFC
    ldh [hLcdcShadow], a                          ; $4DFE
    ld a, $e4                                     ; $4E00
    ld [wPaletteTarget], a                        ; $4E02
    ld a, $d2                                     ; $4E05
    ld [wPaletteTarget + $1], a                   ; $4E07
    ld [wPaletteTarget + $2], a                   ; $4E0A
    xor a                                         ; $4E0D
    ldh [hScxShadow], a                           ; $4E0E
    ldh [hScyShadow], a                           ; $4E10
    ld [wSpriteAnimFrame], a                      ; $4E12
    ld [wSpriteAnimTick], a                       ; $4E15
    ld [wSpriteAnimFrame], a                      ; $4E18
    farcopy Mem_CopyFromBank, Gfx_21_77C0_BorderPicker_Substate0_Init, $8400, $0400 ; $4E1B
    ld bc, $9800                                  ; $4E29
    ld de, $9c00                                  ; $4E2C
    ld a, $12                                     ; $4E2F

jr_008_4e31:
    push af                                       ; $4E31
    ld hl, BorderPicker_FillPatternTbl            ; $4E32
    ld a, $20                                     ; $4E35

jr_008_4e37:
    push af                                       ; $4E37
    ld a, [hl+]                                   ; $4E38
    ld [bc], a                                    ; $4E39
    ld [de], a                                    ; $4E3A
    inc bc                                        ; $4E3B
    inc de                                        ; $4E3C
    pop af                                        ; $4E3D
    dec a                                         ; $4E3E
    jr nz, jr_008_4e37                            ; $4E3F

    pop af                                        ; $4E41
    dec a                                         ; $4E42
    jr nz, jr_008_4e31                            ; $4E43

    ld l, c                                       ; $4E45
    ld h, b                                       ; $4E46
    ld bc, $01c0                                  ; $4E47

jr_008_4e4a:
    ld a, $ff                                     ; $4E4A
    ld [hl+], a                                   ; $4E4C
    ld [de], a                                    ; $4E4D
    inc de                                        ; $4E4E
    dec bc                                        ; $4E4F
    ld a, b                                       ; $4E50
    or c                                          ; $4E51
    jr nz, jr_008_4e4a                            ; $4E52

    ldh [hFarcallAArg], a                         ; $4E54
    ld a, $08                                     ; $4E56
    ld hl, Border_LoadMap_LcdOff                  ; $4E58
    call Far_Call                                 ; $4E5B
    screen_on                                     ; $4E5E
    call BorderPicker_AnimateIcon                 ; $4E67
    call Pal_FadeIn                               ; $4E6A
    ld hl, wSubstate                              ; $4E6D
    inc [hl]                                      ; $4E70
    jp Far_Call_Return                            ; $4E71


; C: one 32-byte background map row: 20 x $FE then 12 x $FF; Substate0_Init copies it 18 times to $9800 and $9C00 (ld
; a,$20 loop); the 20 + 12 split was a typing artefact
BorderPicker_FillPatternTbl::
    db $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff

; C
BorderPicker_Substate1_Browse::
    call BorderPicker_ReadKeys                    ; $4E94
    call BorderPicker_AnimateIcon                 ; $4E97
    call BorderPicker_DrawNumber                  ; $4E9A
    ldh a, [hKeysNew]                             ; $4E9D
    and PADF_A | PADF_B                           ; $4E9F
    jp z, Far_Call_Return                         ; $4EA1

    ld [wAbResult], a                             ; $4EA4
    ld hl, wSubstate                              ; $4EA7
    inc [hl]                                      ; $4EAA
    jp Far_Call_Return                            ; $4EAB


; C
BorderPicker_Substate2_Exit::
    screen_off                                    ; $4EAE
    next_state                                    ; $4EB4
    jp Far_Call_Return                            ; $4EB8


; C: 16-byte tile packet from 21:7BB0 to the VRAM queue
BorderPicker_AnimateIcon::
    ld a, [wSpriteAnimFrame]                      ; $4EBB
    swap a                                        ; $4EBE
    ld c, a                                       ; $4EC0
    ld b, $00                                     ; $4EC1
    ld hl, $7bb0                                  ; $4EC3
    add hl, bc                                    ; $4EC6
    ld a, $21                                     ; $4EC7
    ld de, wPrintAnimPacket + $3                  ; $4EC9
    ld bc, $0010                                  ; $4ECC
    call Mem_CopyFromBank                         ; $4ECF
    ld a, $8f                                     ; $4ED2
    ld [wPrintAnimPacket], a                      ; $4ED4
    ld a, $e0                                     ; $4ED7
    ld [wPrintAnimPacket + $1], a                 ; $4ED9
    ld a, $10                                     ; $4EDC
    ld [wPrintAnimPacket + $2], a                 ; $4EDE
    xor a                                         ; $4EE1
    ld [wPrintAnimPacket + $13], a                ; $4EE2
    xor a                                         ; $4EE5
    ld bc, wPrintAnimPacket                       ; $4EE6
    call Vq_Push                                  ; $4EE9
    ld a, [wSpriteAnimFrame]                      ; $4EEC
    inc a                                         ; $4EEF
    cp $05                                        ; $4EF0
    jr nz, jr_008_4ef5                            ; $4EF2

    xor a                                         ; $4EF4

jr_008_4ef5:
    ld [wSpriteAnimFrame], a                      ; $4EF5
    ret                                           ; $4EF8


; C: D7C1+1 as two digits; sprites $26 / $27
BorderPicker_DrawNumber::
    ld a, [wMode]                                 ; $4EF9
    cp MODE_ANIMATION_EDITOR                      ; $4EFC
    jr nz, jr_008_4f0a                            ; $4EFE

    ld bc, $5048                                  ; $4F00
    ld a, $27                                     ; $4F03
    call Oam_AddMeta_B01_5D47                     ; $4F05
    jr jr_008_4f12                                ; $4F08

jr_008_4f0a:
    ld bc, $5048                                  ; $4F0A
    ld a, $26                                     ; $4F0D
    call Oam_AddMeta_B01_5D47                     ; $4F0F

jr_008_4f12:
    ld a, [wBorderNumber]                         ; $4F12
    inc a                                         ; $4F15
    ld c, $00                                     ; $4F16

jr_008_4f18:
    cp $0a                                        ; $4F18
    jr c, jr_008_4f21                             ; $4F1A

    sub $0a                                       ; $4F1C
    inc c                                         ; $4F1E
    jr jr_008_4f18                                ; $4F1F

jr_008_4f21:
    push bc                                       ; $4F21
    add $28                                       ; $4F22
    ld bc, $6259                                  ; $4F24
    call Oam_AddMeta_B01_5D47                     ; $4F27
    pop bc                                        ; $4F2A
    ld a, c                                       ; $4F2B
    add $28                                       ; $4F2C
    ld bc, $5a59                                  ; $4F2E
    call Oam_AddMeta_B01_5D47                     ; $4F31
    ldh a, [hFrameCounter]                        ; $4F34
    srl a                                         ; $4F36
    srl a                                         ; $4F38
    and $01                                       ; $4F3A
    add $32                                       ; $4F3C
    ld bc, $5048                                  ; $4F3E
    call Oam_AddMeta_B01_5D47                     ; $4F41
    ret                                           ; $4F44


; C: Left/Right with repeat; sound $38
BorderPicker_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $4F45
    ld b, a                                       ; $4F47
    ld a, [wBorderNumber]                         ; $4F48
    bit 5, b                                      ; $4F4B
    jr z, jr_008_4f61                             ; $4F4D

    play_sfx1 SFX1_CURSOR_MOVE                    ; $4F4F
    dec a                                         ; $4F56
    bit 7, a                                      ; $4F57
    jr z, jr_008_4f5d                             ; $4F59

    ld a, $11                                     ; $4F5B

jr_008_4f5d:
    call BorderPicker_SlideToPrevious             ; $4F5D
    ret                                           ; $4F60


jr_008_4f61:
    bit 4, b                                      ; $4F61
    ret z                                         ; $4F63

    play_sfx1 SFX1_CURSOR_MOVE                    ; $4F64
    inc a                                         ; $4F6B
    cp $12                                        ; $4F6C
    jr nz, jr_008_4f71                            ; $4F6E

    xor a                                         ; $4F70

jr_008_4f71:
    call BorderPicker_SlideToNext                 ; $4F71
    ret                                           ; $4F74


; C: page slide. L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 0A 12
; (tcrf_check/assets/l3_names/)
BorderPicker_SlideToPrevious::
    push af                                       ; $4F75
    ld a, [wBorderNumber]                         ; $4F76
    call Border_LoadMapRect                       ; $4F79
    xor a                                         ; $4F7C
    ldh [hWyShadow], a                            ; $4F7D
    ldh a, [hLcdcShadow]                          ; $4F7F
    xor $20                                       ; $4F81
    ldh [hLcdcShadow], a                          ; $4F83
    ld a, $07                                     ; $4F85
    ldh [hWxShadow], a                            ; $4F87
    call BorderPicker_AnimateIcon                 ; $4F89
    call BorderPicker_DrawNumber                  ; $4F8C
    call Oam_HideUnused                           ; $4F8F
    rst Rst08_WaitVBlank                          ; $4F92
    pop af                                        ; $4F93
    ld [wBorderNumber], a                         ; $4F94
    ldh [hFarcallAArg], a                         ; $4F97
    ld a, $08                                     ; $4F99
    ld hl, Border_LoadMap_Safe                    ; $4F9B
    call Far_Call                                 ; $4F9E
    ld hl, BorderPicker_SlideTblA                 ; $4FA1
    ld b, $07                                     ; $4FA4

jr_008_4fa6:
    push bc                                       ; $4FA6
    ld a, [hl+]                                   ; $4FA7
    ldh [hScxShadow], a                           ; $4FA8
    ldh a, [hLcdcShadow]                          ; $4FAA
    xor [hl]                                      ; $4FAC
    ldh [hLcdcShadow], a                          ; $4FAD
    inc hl                                        ; $4FAF
    ld a, [hl+]                                   ; $4FB0
    ldh [hWxShadow], a                            ; $4FB1
    push hl                                       ; $4FB3
    call BorderPicker_AnimateIcon                 ; $4FB4
    call BorderPicker_DrawNumber                  ; $4FB7
    call Oam_HideUnused                           ; $4FBA
    rst Rst08_WaitVBlank                          ; $4FBD
    pop hl                                        ; $4FBE
    pop bc                                        ; $4FBF
    dec b                                         ; $4FC0
    jr nz, jr_008_4fa6                            ; $4FC1

    ret                                           ; $4FC3


; C: L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 0A 12 (tcrf_check/assets/l3_names/)
BorderPicker_SlideTblA::
    db $a8, $00, $3f, $78, $00, $6f, $50, $00, $97, $30, $20, $00, $18, $00, $00, $08
    db $00, $00, $00, $00, $00

; C: page slide. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core
; emulator (coverage/results/merged_state/cov.npz)
BorderPicker_SlideToNext::
    push af                                       ; $4FD9
    call Border_LoadMapRect                       ; $4FDA
    xor a                                         ; $4FDD
    ldh [hWyShadow], a                            ; $4FDE
    ld hl, BorderPicker_SlideTblB                 ; $4FE0
    ld b, $07                                     ; $4FE3

jr_008_4fe5:
    push bc                                       ; $4FE5
    ld a, [hl+]                                   ; $4FE6
    ldh [hScxShadow], a                           ; $4FE7
    ldh a, [hLcdcShadow]                          ; $4FE9
    xor [hl]                                      ; $4FEB
    ldh [hLcdcShadow], a                          ; $4FEC
    inc hl                                        ; $4FEE
    ld a, [hl+]                                   ; $4FEF
    ldh [hWxShadow], a                            ; $4FF0
    push hl                                       ; $4FF2
    call BorderPicker_AnimateIcon                 ; $4FF3
    call BorderPicker_DrawNumber                  ; $4FF6
    call Oam_HideUnused                           ; $4FF9
    rst Rst08_WaitVBlank                          ; $4FFC
    pop hl                                        ; $4FFD
    pop bc                                        ; $4FFE
    dec b                                         ; $4FFF
    jr nz, jr_008_4fe5                            ; $5000

    ld a, [hl+]                                   ; $5002
    ldh [hScxShadow], a                           ; $5003
    pop af                                        ; $5005
    push hl                                       ; $5006
    ld [wBorderNumber], a                         ; $5007
    ldh [hFarcallAArg], a                         ; $500A
    ld a, $08                                     ; $500C
    ld hl, Border_LoadMap_Safe                    ; $500E
    call Far_Call                                 ; $5011
    pop hl                                        ; $5014
    ldh a, [hLcdcShadow]                          ; $5015
    xor [hl]                                      ; $5017
    ldh [hLcdcShadow], a                          ; $5018
    inc hl                                        ; $501A
    ld a, [hl]                                    ; $501B
    ldh [hWxShadow], a                            ; $501C
    ret                                           ; $501E


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
    ld a, [wBorderNumber]                         ; $5037
    sla a                                         ; $503A
    ld c, a                                       ; $503C
    sla a                                         ; $503D
    add c                                         ; $503F
    ld c, a                                       ; $5040
    ld b, $00                                     ; $5041
    ld hl, Border_SrcTbl                          ; $5043
    add hl, bc                                    ; $5046
    ld c, [hl]                                    ; $5047
    inc hl                                        ; $5048
    ld b, [hl]                                    ; $5049
    inc hl                                        ; $504A
    ld a, [hl+]                                   ; $504B
    push hl                                       ; $504C
    ld l, c                                       ; $504D
    ld h, b                                       ; $504E
    ld de, $8900                                  ; $504F
    ld bc, $0600                                  ; $5052
    call Mem_CopyFromBank                         ; $5055
    pop hl                                        ; $5058
    ld c, [hl]                                    ; $5059
    inc hl                                        ; $505A
    ld b, [hl]                                    ; $505B
    inc hl                                        ; $505C
    ld a, [hl+]                                   ; $505D
    ld l, c                                       ; $505E
    ld h, b                                       ; $505F
    push af                                       ; $5060
    ldh a, [hScyShadow]                           ; $5061
    and $f8                                       ; $5063
    sla a                                         ; $5065
    sla a                                         ; $5067
    ld e, a                                       ; $5069
    ldh a, [hScxShadow]                           ; $506A
    srl a                                         ; $506C
    srl a                                         ; $506E
    srl a                                         ; $5070
    add e                                         ; $5072
    ld e, a                                       ; $5073
    ld d, $98                                     ; $5074
    pop af                                        ; $5076
    ld c, $90                                     ; $5077
    call Border_CopyFrameAddTile_LcdOff           ; $5079
    jp Far_Call_Return                            ; $507C


; C: far: border tilemap during VBlank
Border_LoadMap_Safe::
    ld a, [wBorderNumber]                         ; $507F
    sla a                                         ; $5082
    ld c, a                                       ; $5084
    sla a                                         ; $5085
    add c                                         ; $5087
    ld c, a                                       ; $5088
    ld b, $00                                     ; $5089
    ld hl, Border_SrcTbl                          ; $508B
    add hl, bc                                    ; $508E
    ld c, [hl]                                    ; $508F
    inc hl                                        ; $5090
    ld b, [hl]                                    ; $5091
    inc hl                                        ; $5092
    ld a, [hl+]                                   ; $5093
    push hl                                       ; $5094
    ld l, c                                       ; $5095
    ld h, b                                       ; $5096
    ld de, $8900                                  ; $5097
    ld bc, $0600                                  ; $509A
    call Vram_CopyFromBank                        ; $509D
    pop hl                                        ; $50A0
    ld c, [hl]                                    ; $50A1
    inc hl                                        ; $50A2
    ld b, [hl]                                    ; $50A3
    inc hl                                        ; $50A4
    ld a, [hl+]                                   ; $50A5
    ld l, c                                       ; $50A6
    ld h, b                                       ; $50A7
    push af                                       ; $50A8
    ldh a, [hScyShadow]                           ; $50A9
    and $f8                                       ; $50AB
    sla a                                         ; $50AD
    sla a                                         ; $50AF
    ld e, a                                       ; $50B1
    ldh a, [hScxShadow]                           ; $50B2
    srl a                                         ; $50B4
    srl a                                         ; $50B6
    srl a                                         ; $50B8
    add e                                         ; $50BA
    ld e, a                                       ; $50BB
    ld d, $98                                     ; $50BC
    pop af                                        ; $50BE
    ld c, $90                                     ; $50BF
    call Border_CopyFrameAddTile_Safe             ; $50C1
    jp Far_Call_Return                            ; $50C4


; C
Border_LoadMapRect::
    sla a                                         ; $50C7
    ld c, a                                       ; $50C9
    sla a                                         ; $50CA
    add c                                         ; $50CC
    ld c, a                                       ; $50CD
    ld b, $00                                     ; $50CE
    ld hl, Border_SrcTbl                          ; $50D0
    add hl, bc                                    ; $50D3
    ld c, [hl]                                    ; $50D4
    inc hl                                        ; $50D5
    ld b, [hl]                                    ; $50D6
    inc hl                                        ; $50D7
    ld a, [hl+]                                   ; $50D8
    push hl                                       ; $50D9
    ld l, c                                       ; $50DA
    ld h, b                                       ; $50DB
    ld de, $9000                                  ; $50DC
    ld bc, $0600                                  ; $50DF
    call Vram_CopyFromBank                        ; $50E2
    pop hl                                        ; $50E5
    ld c, [hl]                                    ; $50E6
    inc hl                                        ; $50E7
    ld b, [hl]                                    ; $50E8
    inc hl                                        ; $50E9
    ld a, [hl+]                                   ; $50EA
    ld l, c                                       ; $50EB
    ld h, b                                       ; $50EC
    ld de, $9c00                                  ; $50ED
    ld c, $00                                     ; $50F0
    call Border_CopyFrameAddTile_Safe             ; $50F2
    ret                                           ; $50F5


; C: far: print_src_table2 from Border_SrcTbl
Border_FillPrintSource::
    ld a, [wBorderNumber]                         ; $50F6
    sla a                                         ; $50F9
    ld c, a                                       ; $50FB
    sla a                                         ; $50FC
    add c                                         ; $50FE
    ld c, a                                       ; $50FF
    ld b, $00                                     ; $5100
    ld hl, Border_SrcTbl                          ; $5102
    add hl, bc                                    ; $5105
    ld de, wPrintSrcTable2 + $4                   ; $5106
    ld a, [hl+]                                   ; $5109
    ld [de], a                                    ; $510A
    inc de                                        ; $510B
    ld a, [hl+]                                   ; $510C
    ld [de], a                                    ; $510D
    inc de                                        ; $510E
    ld a, [hl+]                                   ; $510F
    ld [de], a                                    ; $5110
    ld de, wPrintSrcTable + $4                    ; $5111
    ld a, [hl+]                                   ; $5114
    ld [de], a                                    ; $5115
    inc de                                        ; $5116
    ld a, [hl+]                                   ; $5117
    ld [de], a                                    ; $5118
    inc de                                        ; $5119
    ld a, [hl+]                                   ; $511A
    ld [de], a                                    ; $511B
    jp Far_Call_Return                            ; $511C


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
    ld a, [wSubstate]                             ; $5191
    rst Rst18_JumpTable                           ; $5194

; C
WildFramePicker_SubstateTbl::
    dw WildFramePicker_Substate0_Init
    dw WildFramePicker_Substate1_Browse
    dw WildFramePicker_Substate2_Exit

; C
WildFramePicker_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $519B
    ldh [hLcdcShadow], a                          ; $519D
    ld a, $e4                                     ; $519F
    ld [wPaletteTarget], a                        ; $51A1
    ld a, $d2                                     ; $51A4
    ld [wPaletteTarget + $1], a                   ; $51A6
    ld [wPaletteTarget + $2], a                   ; $51A9
    xor a                                         ; $51AC
    ldh [hScxShadow], a                           ; $51AD
    ldh [hScyShadow], a                           ; $51AF
    ld [wSpriteAnimFrame], a                      ; $51B1
    ld [wSpriteAnimTick], a                       ; $51B4
    ld [wSpriteAnimFrame], a                      ; $51B7
    farcopy Mem_CopyFromBank, Gfx_21_77C0_BorderPicker_Substate0_Init, $8400, $0400 ; $51BA
    farcopy Mem_CopyFromBank, Map_25_6CE0_WildFramePicker_Substate0_Init, $9800, $0240 ; $51C8
    farcopy Mem_CopyFromBank, Map_25_6CE0_WildFramePicker_Substate0_Init, $9c00, $0240 ; $51D6
    ld hl, $9c00                                  ; $51E4
    ld a, $ff                                     ; $51E7
    ld b, $28                                     ; $51E9
    call Wild_FillBytes4                          ; $51EB
    ld a, $fe                                     ; $51EE
    ld b, $20                                     ; $51F0
    call Wild_FillBytes4                          ; $51F2
    ld a, $ff                                     ; $51F5
    ld b, $48                                     ; $51F7
    call Wild_FillBytes4                          ; $51F9
    ld a, $38                                     ; $51FC
    ldh [hLycShadowSplit1], a                     ; $51FE
    ldh [hSplit1Latch], a                         ; $5200
    ld hl, hStatShadow                            ; $5202
    set 6, [hl]                                   ; $5205
    ld hl, rIE                                    ; $5207
    set 1, [hl]                                   ; $520A
    ld a, $01                                     ; $520C
    ldh [hStatHandlerIndex], a                    ; $520E
    screen_on                                     ; $5210
    call WildFramePicker_AnimateIcon              ; $5219
    call WildFramePicker_LoadPage                 ; $521C
    call Pal_FadeIn                               ; $521F
    ld hl, wSubstate                              ; $5222
    inc [hl]                                      ; $5225
    jp Far_Call_Return                            ; $5226


; C: fills 4*B bytes with A. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 1C
; (tcrf_check/assets/l3_names/)
Wild_FillBytes4::
    ld [hl+], a                                   ; $5229
    ld [hl+], a                                   ; $522A
    ld [hl+], a                                   ; $522B
    ld [hl+], a                                   ; $522C
    dec b                                         ; $522D
    jr nz, Wild_FillBytes4                        ; $522E

    ret                                           ; $5230


; C
WildFramePicker_Substate1_Browse::
    call WildFramePicker_ReadKeys                 ; $5231
    call WildFramePicker_AnimateIcon              ; $5234
    call WildFramePicker_DrawPageNumber           ; $5237
    ldh a, [hKeysNew]                             ; $523A
    and PADF_A | PADF_B                           ; $523C
    jp z, Far_Call_Return                         ; $523E

    ld [wAbResult], a                             ; $5241
    ld hl, wSubstate                              ; $5244
    inc [hl]                                      ; $5247
    jp Far_Call_Return                            ; $5248


; C
WildFramePicker_Substate2_Exit::
    screen_off                                    ; $524B
    stat_irq_off                                  ; $5251
    next_state                                    ; $525B
    jp Far_Call_Return                            ; $525F


; C: same as BorderPicker_AnimateIcon
WildFramePicker_AnimateIcon::
    ld a, [wSpriteAnimFrame]                      ; $5262
    swap a                                        ; $5265
    ld c, a                                       ; $5267
    ld b, $00                                     ; $5268
    ld hl, $7bb0                                  ; $526A
    add hl, bc                                    ; $526D
    ld a, $21                                     ; $526E
    ld de, wPrintAnimPacket + $3                  ; $5270
    ld bc, $0010                                  ; $5273
    call Mem_CopyFromBank                         ; $5276
    ld a, $8f                                     ; $5279
    ld [wPrintAnimPacket], a                      ; $527B
    ld a, $e0                                     ; $527E
    ld [wPrintAnimPacket + $1], a                 ; $5280
    ld a, $10                                     ; $5283
    ld [wPrintAnimPacket + $2], a                 ; $5285
    xor a                                         ; $5288
    ld [wPrintAnimPacket + $13], a                ; $5289
    xor a                                         ; $528C
    ld bc, wPrintAnimPacket                       ; $528D
    call Vq_Push                                  ; $5290
    ld a, [wSpriteAnimFrame]                      ; $5293
    inc a                                         ; $5296
    cp $05                                        ; $5297
    jr nz, jr_008_529c                            ; $5299

    xor a                                         ; $529B

jr_008_529c:
    ld [wSpriteAnimFrame], a                      ; $529C
    ret                                           ; $529F


; C
WildFramePicker_DrawPageNumber::
    ld bc, $5033                                  ; $52A0
    ld a, $34                                     ; $52A3
    call Oam_AddMeta_B01_5D47                     ; $52A5
    ld a, [wPageIndex8]                           ; $52A8
    inc a                                         ; $52AB
    ld c, $00                                     ; $52AC

jr_008_52ae:
    cp $0a                                        ; $52AE
    jr c, jr_008_52b7                             ; $52B0

    sub $0a                                       ; $52B2
    inc c                                         ; $52B4
    jr jr_008_52ae                                ; $52B5

jr_008_52b7:
    push bc                                       ; $52B7
    add $28                                       ; $52B8
    ld bc, $6a44                                  ; $52BA
    call Oam_AddMeta_B01_5D47                     ; $52BD
    pop bc                                        ; $52C0
    ld a, c                                       ; $52C1
    add $28                                       ; $52C2
    ld bc, $6244                                  ; $52C4
    call Oam_AddMeta_B01_5D47                     ; $52C7
    ldh a, [hFrameCounter]                        ; $52CA
    srl a                                         ; $52CC
    srl a                                         ; $52CE
    and $01                                       ; $52D0
    add $32                                       ; $52D2
    ld bc, $5833                                  ; $52D4
    call Oam_AddMeta_B01_5D47                     ; $52D7
    ret                                           ; $52DA


; C: pages 6 or 8 (D582)
WildFramePicker_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $52DB
    ld b, a                                       ; $52DD
    ld c, $06                                     ; $52DE
    ld a, [wCoroFlag]                             ; $52E0
    cp $01                                        ; $52E3
    jr nz, jr_008_52e9                            ; $52E5

    ld c, $08                                     ; $52E7

jr_008_52e9:
    ld a, [wPageIndex8]                           ; $52E9
    bit 5, b                                      ; $52EC
    jr z, jr_008_5302                             ; $52EE

    play_sfx1 SFX1_CURSOR_MOVE                    ; $52F0
    dec a                                         ; $52F7
    bit 7, a                                      ; $52F8
    jr z, jr_008_52fe                             ; $52FA

    ld a, c                                       ; $52FC
    dec a                                         ; $52FD

jr_008_52fe:
    call WildFramePicker_SlideRight               ; $52FE
    ret                                           ; $5301


jr_008_5302:
    bit 4, b                                      ; $5302
    ret z                                         ; $5304

    play_sfx1 SFX1_CURSOR_MOVE                    ; $5305
    inc a                                         ; $530C
    cp c                                          ; $530D
    jr nz, jr_008_5311                            ; $530E

    xor a                                         ; $5310

jr_008_5311:
    call WildFramePicker_SlideLeft                ; $5311
    ret                                           ; $5314


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
WildFramePicker_SlideRight::
    ld [wPageIndex8], a                           ; $5315
    xor a                                         ; $5318
    ldh [hWyShadow], a                            ; $5319
    ld hl, WildFramePicker_SlideTblA              ; $531B
    ld b, $0a                                     ; $531E

jr_008_5320:
    push bc                                       ; $5320
    call Wild_WaitLY39                            ; $5321
    ld a, [hl+]                                   ; $5324
    ldh [hScxShadow], a                           ; $5325
    ldh a, [hLcdcShadow]                          ; $5327
    xor [hl]                                      ; $5329
    ldh [hLcdcShadow], a                          ; $532A
    inc hl                                        ; $532C
    ld a, [hl+]                                   ; $532D
    ldh [hWxShadow], a                            ; $532E
    push hl                                       ; $5330
    ld a, b                                       ; $5331
    cp $07                                        ; $5332
    call z, WildFramePicker_LoadPage              ; $5334
    call WildFramePicker_AnimateIcon              ; $5337
    call WildFramePicker_DrawPageNumber           ; $533A
    call Oam_HideUnused                           ; $533D
    rst Rst08_WaitVBlank                          ; $5340
    pop hl                                        ; $5341
    pop bc                                        ; $5342
    dec b                                         ; $5343
    jr nz, jr_008_5320                            ; $5344

    ret                                           ; $5346


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1C)
WildFramePicker_SlideTblA::
    db $00, $68, $57, $00, $00, $9f, $a8, $48, $5f, $a8, $00, $5f, $78, $00, $8f, $50
    db $20, $07, $30, $00, $07, $18, $00, $07, $08, $00, $07, $00, $00, $07

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
WildFramePicker_SlideLeft::
    ld [wPageIndex8], a                           ; $5365
    xor a                                         ; $5368
    ldh [hWyShadow], a                            ; $5369
    ld hl, WildFramePicker_SlideTblB              ; $536B
    ld b, $0a                                     ; $536E

jr_008_5370:
    push bc                                       ; $5370
    call Wild_WaitLY39                            ; $5371
    ld a, [hl+]                                   ; $5374
    ldh [hScxShadow], a                           ; $5375
    ldh a, [hLcdcShadow]                          ; $5377
    xor [hl]                                      ; $5379
    ldh [hLcdcShadow], a                          ; $537A
    inc hl                                        ; $537C
    ld a, [hl+]                                   ; $537D
    ldh [hWxShadow], a                            ; $537E
    push hl                                       ; $5380
    ld a, b                                       ; $5381
    cp $07                                        ; $5382
    call z, WildFramePicker_LoadPage              ; $5384
    call WildFramePicker_AnimateIcon              ; $5387
    call WildFramePicker_DrawPageNumber           ; $538A
    call Oam_HideUnused                           ; $538D
    rst Rst08_WaitVBlank                          ; $5390
    pop hl                                        ; $5391
    pop bc                                        ; $5392
    dec b                                         ; $5393
    jr nz, jr_008_5370                            ; $5394

    ret                                           ; $5396


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 1C)
WildFramePicker_SlideTblB::
    db $50, $20, $57, $98, $00, $0f, $00, $68, $07, $00, $00, $07, $00, $20, $7f, $00
    db $00, $57, $00, $00, $37, $00, $00, $1f, $00, $00, $0f, $00, $68, $07

; C: waits for LY >= $39. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
Wild_WaitLY39::
    ldh a, [rLY]                                  ; $53B5
    cp $39                                        ; $53B7
    jr c, Wild_WaitLY39                           ; $53B9

    ret                                           ; $53BB


; C: tiles and map of the current page
WildFramePicker_LoadPage::
    ld a, [wPageIndex8]                           ; $53BC
    ld c, a                                       ; $53BF
    sla a                                         ; $53C0
    add c                                         ; $53C2
    ld c, a                                       ; $53C3
    ld b, $00                                     ; $53C4
    ld hl, WildFrame_PageSrcTbl                   ; $53C6
    add hl, bc                                    ; $53C9
    ld c, [hl]                                    ; $53CA
    inc hl                                        ; $53CB
    ld b, [hl]                                    ; $53CC
    inc hl                                        ; $53CD
    ld a, [hl]                                    ; $53CE
    ld l, c                                       ; $53CF
    ld h, b                                       ; $53D0
    ld de, $9000                                  ; $53D1
    ld bc, $0640                                  ; $53D4
    call Wild_CopyBlockAdvance                    ; $53D7
    ld de, $8000                                  ; $53DA
    ld bc, $01c0                                  ; $53DD
    call Wild_CopyBlockAdvance                    ; $53E0
    ld de, $81c0                                  ; $53E3
    ld bc, $0240                                  ; $53E6
    call Wild_CopyBlockAdvance                    ; $53E9
    ld de, $8800                                  ; $53EC
    ld bc, $05c0                                  ; $53EF
    call Wild_CopyBlockAdvance                    ; $53F2
    ld de, $8dc0                                  ; $53F5
    ld bc, $0180                                  ; $53F8
    call Wild_CopyBlockAdvance                    ; $53FB
    ret                                           ; $53FE


; C: Vram_CopyFromBank then bank++ on address wrap. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic
; corpus, modes 1C (tcrf_check/assets/l3_names/)
Wild_CopyBlockAdvance::
    push af                                       ; $53FF
    call Vram_CopyFromBank                        ; $5400
    pop af                                        ; $5403
    bit 7, h                                      ; $5404
    ret z                                         ; $5406

    res 7, h                                      ; $5407
    set 6, h                                      ; $5409
    inc a                                         ; $540B
    ret                                           ; $540C


; C: far: called from the print job (08:4675). L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic
; corpus, modes 1C (tcrf_check/assets/l3_names/)
WildFrame_LoadForPrintJob::
    ld a, [wPageIndex8]                           ; $540D
    ld c, a                                       ; $5410
    sla a                                         ; $5411
    add c                                         ; $5413
    ld c, a                                       ; $5414
    ld b, $00                                     ; $5415
    ld hl, WildFrame_PageSrcTbl                   ; $5417
    add hl, bc                                    ; $541A
    ld c, [hl]                                    ; $541B
    inc hl                                        ; $541C
    ld a, [hl]                                    ; $541D
    inc hl                                        ; $541E
    ld b, [hl]                                    ; $541F
    ld hl, wPrintSrcTable + $4                    ; $5420
    ld d, $03                                     ; $5423

jr_008_5425:
    ld [hl], c                                    ; $5425
    inc hl                                        ; $5426
    ld [hl+], a                                   ; $5427
    ld [hl], b                                    ; $5428
    inc hl                                        ; $5429
    inc hl                                        ; $542A
    add $08                                       ; $542B
    bit 7, a                                      ; $542D
    jr z, jr_008_5436                             ; $542F

    res 7, a                                      ; $5431
    set 6, a                                      ; $5433
    inc b                                         ; $5435

jr_008_5436:
    dec d                                         ; $5436
    jr nz, jr_008_5425                            ; $5437

    jp Far_Call_Return                            ; $5439


; C: far: called from state 2 (08:4254). L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 1C (tcrf_check/assets/l3_names/)
WildFrame_LoadForPrintScreen::
    ld a, [wPageIndex8]                           ; $543C
    ld c, a                                       ; $543F
    sla a                                         ; $5440
    add c                                         ; $5442
    ld c, a                                       ; $5443
    ld b, $00                                     ; $5444
    ld hl, WildFrame_PageSrcTbl                   ; $5446
    add hl, bc                                    ; $5449
    ld c, [hl]                                    ; $544A
    inc hl                                        ; $544B
    ld b, [hl]                                    ; $544C
    inc hl                                        ; $544D
    ld a, [hl]                                    ; $544E
    ld hl, $03c0                                  ; $544F
    add hl, bc                                    ; $5452
    ld de, $8900                                  ; $5453
    ld bc, $0440                                  ; $5456
    call Wild_MemCopyAdvance                      ; $5459
    ld bc, $00c0                                  ; $545C
    call Wild_MemCopyAdvance                      ; $545F
    farcopy Mem_CopyFromBank, Map_26_60C0_WildFrame_LoadForPrintScreen, $9840, $0240 ; $5462
    jp Far_Call_Return                            ; $5470


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1C (tcrf_check/assets/l3_names/)
Wild_MemCopyAdvance::
    push af                                       ; $5473
    call Mem_CopyFromBank                         ; $5474
    pop af                                        ; $5477
    bit 7, h                                      ; $5478
    ret z                                         ; $547A

    res 7, h                                      ; $547B
    set 6, h                                      ; $547D
    inc a                                         ; $547F
    ret                                           ; $5480


; C: far: called from 08:4847. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
WildFrame_LoadForOptionScreen::
    ld a, [wPageIndex8]                           ; $5481
    ld c, a                                       ; $5484
    sla a                                         ; $5485
    add c                                         ; $5487
    ld c, a                                       ; $5488
    ld b, $00                                     ; $5489
    ld hl, WildFrame_PageSrcTbl                   ; $548B
    add hl, bc                                    ; $548E
    ld c, [hl]                                    ; $548F
    inc hl                                        ; $5490
    ld b, [hl]                                    ; $5491
    inc hl                                        ; $5492
    ld a, [hl]                                    ; $5493
    ld hl, $03c0                                  ; $5494
    add hl, bc                                    ; $5497
    ld de, $8900                                  ; $5498
    ld bc, $0440                                  ; $549B
    call Wild_VramCopyAdvance                     ; $549E
    ld bc, $00c0                                  ; $54A1
    call Wild_VramCopyAdvance                     ; $54A4
    farcopy Vram_CopyFromBank, Map_26_60C0_WildFrame_LoadForPrintScreen, $9840, $0240 ; $54A7
    jp Far_Call_Return                            ; $54B5


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Wild_VramCopyAdvance::
    push af                                       ; $54B8
    call Vram_CopyFromBank                        ; $54B9
    pop af                                        ; $54BC
    bit 7, h                                      ; $54BD
    ret z                                         ; $54BF

    res 7, h                                      ; $54C0
    set 6, h                                      ; $54C2
    inc a                                         ; $54C4
    ret                                           ; $54C5


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
    INCBIN "data/bank_08/Print_Layout0_Plain.bin" ; $552E, 720 bytes
; C: layout script 1 (print_layout_type 1, the framed print): 600 descriptors = 30 tile rows in THREE printer pages of
; 3 / 7 / 5 bands (6 / 14 / 10 rows, 1,200 B; the pages end on the words $8163, $834F, $C800): page 1 = a blank row
; ($4000 = blank tile) and source 1 tiles $00-$63; page 2 = the photo ...
Print_Layout1_Framed::
    INCBIN "data/bank_08/Print_Layout1_Framed.bin" ; $57FE, 1200 bytes
; C: layout script 2 (print_layout_type 2 = ($D5EA xor 1) + 2 at 06:5B22, the 4-photo SHOOT print): 4 printer pages of
; 7 bands (14 rows, 560 B each, 2,240 B): page k holds photo k (source k, tiles $00-$DF, 16 per row) between two blank
; tiles ($4000) each side; pages end on $C000, the last on $C800 (last ...
Print_Layout2_FourPhotos::
    INCBIN "data/bank_08/Print_Layout2_FourPhotos.bin" ; $5CAE, 2240 bytes
; C: layout script 3 (print_layout_type 3, the other 4-photo layout): 4 printer pages of 8 bands (16 rows, 640 B each,
; 2,560 B): photo k (source k) turned by 90 degrees, i.e. descriptors with flags $10 | k (bit 4: 00:3249 rotates each
; 8 x 8 tile) in transposed order $x0D0, $x0C0 ... $x000, $x0D1 ..., 14 ...
Print_Layout3_FourPhotosRotated::
    INCBIN "data/bank_08/Print_Layout3_FourPhotosRotated.bin" ; $656E, 2560 bytes
; C: layout script 4 (print_layout_type 4 = the info page of 08:475F, source 0 = the page built at $C000 of bank 0):
; one page of 9 bands, 360 descriptors (720 B), tiles $00-$BB and $C0 / $C1 (the end word $C8C0 = last band, blank
; tile, last page); progress word $5B at 00:3112 (C); ends at 08:723D, ...
Print_Layout4_InfoPage::
    INCBIN "data/bank_08/Print_Layout4_InfoPage.bin" ; $6F6E, 720 bytes
; C: mode 19: copyright; title scene
Mode19_TitleScreens::
    call Rng_Next                                 ; $723E
    ld a, [wState]                                ; $7241
    rst Rst18_JumpTable                           ; $7244

; C: 5 states
Mode19_StateTable::
    dw Mode19_State00_CopyrightScreens
    dw Mode19_State01_TitleFirst
    dw Mode19_State02_TitleFromMenu
    dw Mode19_State03_TitleWait
    dw Mode19_State04_Leave

; C: 2nd copyright screen if the CoroCoro tag matches
Mode19_State00_CopyrightScreens::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $724F
    ldh [hLcdcShadow], a                          ; $7251
    ld a, $e4                                     ; $7253
    ld [wPaletteTarget], a                        ; $7255
    xor a                                         ; $7258
    ldh [hScxShadow], a                           ; $7259
    ldh [hScyShadow], a                           ; $725B
    xor a                                         ; $725D
    ld [wCoroFlag], a                             ; $725E
    ld a, $18                                     ; $7261
    ld [wStockPictureCount], a                    ; $7263
    call Oam_ClearShadow                          ; $7266
    farcopy Mem_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $7269
    call Title_BuildAnimScript                    ; $7277
    farcopy Mem_CopyFromBank, Gfx_21_71C0_Mode19_State00_CopyrightScreens, $9000, $0600 ; $727A
    farcopy Mem_CopyFromBank, Map_26_69C0_Mode19_State00_CopyrightScreens, $9800, $0240 ; $7288
    call Pal_AllWhite                             ; $7296
    call Lcd_On                                   ; $7299
    call Sgb_MaskCancel                           ; $729C
    play_music MUSIC_STOP                         ; $729F
    call Pal_FadeIn                               ; $72A6
    ld bc, $0058                                  ; $72A9
    call Wait_Frames                              ; $72AC
    call Title_BgpFadeToBlack                     ; $72AF
    call Title_CheckCoroTag                       ; $72B2
    jr nc, jr_008_72db                            ; $72B5

    ld a, $01                                     ; $72B7
    ld [wCoroFlag], a                             ; $72B9
    ld a, $1e                                     ; $72BC
    ld [wStockPictureCount], a                    ; $72BE
    farcopy Vram_CopyFromBank, Gfx_21_6BC0_Mode19_State00_CopyrightScreens, $9000, $0600 ; $72C1
    call Title_BgpFadeToNormal                    ; $72CF
    ld bc, $0058                                  ; $72D2
    call Wait_Frames                              ; $72D5
    call Title_BgpFadeToBlack                     ; $72D8

jr_008_72db:
    next_state                                    ; $72DB
    ret                                           ; $72DF


; C: SRAM $BFFD-$BFFF vs 56 56 53: carry when >= 2 bytes match
Title_CheckCoroTag::
    ld a, $00                                     ; $72E0
    ld [$4000], a                                 ; $72E2
    ld hl, $bffd                                  ; $72E5
    ld de, Title_CoroTagConst                     ; $72E8
    ld bc, $0303                                  ; $72EB

jr_008_72ee:
    ld a, [de]                                    ; $72EE
    cp [hl]                                       ; $72EF
    jr nz, jr_008_72f3                            ; $72F0

    dec c                                         ; $72F2

jr_008_72f3:
    inc de                                        ; $72F3
    inc hl                                        ; $72F4
    dec b                                         ; $72F5
    jr nz, jr_008_72ee                            ; $72F6

    ld a, c                                       ; $72F8
    cp $02                                        ; $72F9
    ret nc                                        ; $72FB

    push af                                       ; $72FC
    ld a, $0a                                     ; $72FD
    ld [$0000], a                                 ; $72FF
    pop af                                        ; $7302
    ld hl, $bffd                                  ; $7303
    ld de, Title_CoroTagConst                     ; $7306
    ld b, $03                                     ; $7309

jr_008_730b:
    ld a, [de]                                    ; $730B
    ld [hl+], a                                   ; $730C
    inc de                                        ; $730D
    dec b                                         ; $730E
    jr nz, jr_008_730b                            ; $730F

    push af                                       ; $7311
    xor a                                         ; $7312
    ld [$0000], a                                 ; $7313
    pop af                                        ; $7316
    scf                                           ; $7317
    ret                                           ; $7318


; C: 56 56 53
Title_CoroTagConst::
    db $56, $56, $53

; C: BGP $F9; $FE; $FF
Title_BgpFadeToBlack::
    ld a, $f9                                     ; $731C
    ldh [hBgpShadow], a                           ; $731E
    ld bc, $0004                                  ; $7320
    call Wait_Frames                              ; $7323
    ld a, $fe                                     ; $7326
    ldh [hBgpShadow], a                           ; $7328
    ld bc, $0004                                  ; $732A
    call Wait_Frames                              ; $732D
    ld a, $ff                                     ; $7330
    ldh [hBgpShadow], a                           ; $7332
    ld bc, $0004                                  ; $7334
    call Wait_Frames                              ; $7337
    ret                                           ; $733A


; C: BGP $FE; $F9; $E4
Title_BgpFadeToNormal::
    ld a, $fe                                     ; $733B
    ldh [hBgpShadow], a                           ; $733D
    ld bc, $0004                                  ; $733F
    call Wait_Frames                              ; $7342
    ld a, $f9                                     ; $7345
    ldh [hBgpShadow], a                           ; $7347
    ld bc, $0004                                  ; $7349
    call Wait_Frames                              ; $734C
    ld a, $e4                                     ; $734F
    ldh [hBgpShadow], a                           ; $7351
    ld bc, $0004                                  ; $7353
    call Wait_Frames                              ; $7356
    ret                                           ; $7359


; C: title scene after the copyright screens; music 1
Mode19_State01_TitleFirst::
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $735A
    ldh [hLcdcShadow], a                          ; $735C
    xor a                                         ; $735E
    ldh [hScxShadow], a                           ; $735F
    ldh [hScyShadow], a                           ; $7361
    ld [wSpriteAnimFrame], a                      ; $7363
    ld [wSpriteAnimTick], a                       ; $7366
    ld a, $ff                                     ; $7369
    ld [wTitleSceneId], a                         ; $736B
    call Oam_ClearShadow                          ; $736E
    farcopy Vram_CopyFromBank, Gfx_3F_6A00_Mode19_State01_TitleFirst, $8900, $0700 ; $7371
    farcopy Vram_CopyFromBank, Gfx_3F_7100_Mode19_State01_TitleFirst, $9500, $0180 ; $737F
    farcopy Vram_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $738D
    ld a, $5c                                     ; $739B
    ldh [hLycShadowSplit1], a                     ; $739D
    ldh [hSplit1Latch], a                         ; $739F
    ld hl, hStatShadow                            ; $73A1
    set 6, [hl]                                   ; $73A4
    ld hl, rIE                                    ; $73A6
    set 1, [hl]                                   ; $73A9
    ld a, $01                                     ; $73AB
    ldh [hStatHandlerIndex], a                    ; $73AD
    call Title_StepAnimScript                     ; $73AF
    play_music MUSIC_TITLE                        ; $73B2
    call Title_BgpFadeToNormal                    ; $73B9
    ld b, $0c                                     ; $73BC

jr_008_73be:
    push bc                                       ; $73BE
    call Title_StepAnimScript                     ; $73BF
    rst Rst08_WaitVBlank                          ; $73C2
    pop bc                                        ; $73C3
    dec b                                         ; $73C4
    jr nz, jr_008_73be                            ; $73C5

    set_state STATE_19_TITLE_WAIT                 ; $73C7
    ret                                           ; $73CC


; C: B in the main menu enters here
Mode19_State02_TitleFromMenu::
    ld a, LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $73CD
    ldh [hLcdcShadow], a                          ; $73CF
    ld a, $e4                                     ; $73D1
    ld [wPaletteTarget], a                        ; $73D3
    xor a                                         ; $73D6
    ldh [hScxShadow], a                           ; $73D7
    ldh [hScyShadow], a                           ; $73D9
    ld [wSpriteAnimFrame], a                      ; $73DB
    ld [wSpriteAnimTick], a                       ; $73DE
    ld a, $ff                                     ; $73E1
    ld [wTitleSceneId], a                         ; $73E3
    call Oam_ClearShadow                          ; $73E6
    farcopy Mem_CopyFromBank, Gfx_3F_6A00_Mode19_State01_TitleFirst, $8900, $0700 ; $73E9
    farcopy Mem_CopyFromBank, Gfx_3F_7100_Mode19_State01_TitleFirst, $9500, $0180 ; $73F7
    farcopy Mem_CopyFromBank, Map_3F_7280_Mode19_State00_CopyrightScreens, $9800, $0400 ; $7405
    call Title_BuildAnimScript                    ; $7413
    ld a, $5c                                     ; $7416
    ldh [hLycShadowSplit1], a                     ; $7418
    ldh [hSplit1Latch], a                         ; $741A
    ld hl, hStatShadow                            ; $741C
    set 6, [hl]                                   ; $741F
    ld hl, rIE                                    ; $7421
    set 1, [hl]                                   ; $7424
    ld a, $01                                     ; $7426
    ldh [hStatHandlerIndex], a                    ; $7428
    screen_on                                     ; $742A
    call Title_StepAnimScript                     ; $7433
    play_music MUSIC_TITLE                        ; $7436
    call Pal_FadeIn                               ; $743D
    next_state                                    ; $7440
    ret                                           ; $7444


; C: Up = faster; Down = slower; any key -> state 4
Mode19_State03_TitleWait::
    call Title_StepAnimScript                     ; $7445
    ldh a, [hKeysHeld]                            ; $7448
    bit PADB_UP, a                                ; $744A
    jr z, jr_008_7455                             ; $744C

    ld a, $ff                                     ; $744E
    ld [wSpriteAnimTick], a                       ; $7450
    jr Mode19_State03_TitleWait                   ; $7453

jr_008_7455:
    bit 7, a                                      ; $7455
    jr z, jr_008_745b                             ; $7457

    rst Rst08_WaitVBlank                          ; $7459
    ret                                           ; $745A


jr_008_745b:
    ldh a, [hKeysNewSticky]                       ; $745B
    and PADF_A | PADF_B | PADF_START              ; $745D
    ret z                                         ; $745F

    ld [wAbResult], a                             ; $7460
    next_state                                    ; $7463
    ret                                           ; $7467


; C: mode := 0
Mode19_State04_Leave::
    screen_off                                    ; $7468
    stat_irq_off                                  ; $746E
    ld a, MODE_MAIN_MENU                          ; $7478
    ld [wMode], a                                 ; $747A
    set_state STATE_00_INIT                       ; $747D
    ret                                           ; $7482


; C: frame / tick script at $C000
Title_StepAnimScript::
    ld a, [wSpriteAnimFrame]                      ; $7483
    sla a                                         ; $7486
    ld c, a                                       ; $7488
    ld b, $00                                     ; $7489
    ld hl, wAnimScript                            ; $748B
    add hl, bc                                    ; $748E
    ld a, [wTitleSceneId]                         ; $748F
    cp [hl]                                       ; $7492
    ld a, [hl+]                                   ; $7493
    call nz, Title_LoadScene                      ; $7494
    ld a, [wSpriteAnimTick]                       ; $7497
    cp [hl]                                       ; $749A
    jr c, jr_008_74ab                             ; $749B

    inc hl                                        ; $749D
    ld a, [hl+]                                   ; $749E
    inc a                                         ; $749F
    ld a, [hl]                                    ; $74A0
    jr z, jr_008_74a7                             ; $74A1

    ld a, [wSpriteAnimFrame]                      ; $74A3
    inc a                                         ; $74A6

jr_008_74a7:
    ld [wSpriteAnimFrame], a                      ; $74A7
    xor a                                         ; $74AA

jr_008_74ab:
    inc a                                         ; $74AB
    ld [wSpriteAnimTick], a                       ; $74AC
    ret                                           ; $74AF


; C: tiles of scene D815 from Title_SceneTbl
Title_LoadScene::
    ld [wTitleSceneId], a                         ; $74B0
    push hl                                       ; $74B3
    ld c, a                                       ; $74B4
    sla a                                         ; $74B5
    add c                                         ; $74B7
    ld c, a                                       ; $74B8
    ld b, $00                                     ; $74B9
    ld hl, Title_SceneTbl                         ; $74BB
    add hl, bc                                    ; $74BE
    ld c, [hl]                                    ; $74BF
    inc hl                                        ; $74C0
    ld b, [hl]                                    ; $74C1
    inc hl                                        ; $74C2
    ld a, [hl]                                    ; $74C3
    ld l, c                                       ; $74C4
    ld h, b                                       ; $74C5
    ld de, $8000                                  ; $74C6
    ld bc, $0900                                  ; $74C9
    push af                                       ; $74CC
    call Vram_CopyFromBank                        ; $74CD
    pop af                                        ; $74D0
    ld de, $9000                                  ; $74D1
    ld bc, $0500                                  ; $74D4
    call Vram_CopyFromBank                        ; $74D7
    pop hl                                        ; $74DA
    ret                                           ; $74DB


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
    ld hl, $9814                                  ; $74F1
    ld de, wAnimScript                            ; $74F4
    ld b, $02                                     ; $74F7

jr_008_74f9:
    ld c, $02                                     ; $74F9

jr_008_74fb:
    push bc                                       ; $74FB
    ld c, $0c                                     ; $74FC

jr_008_74fe:
    ld a, [hl+]                                   ; $74FE
    ld [de], a                                    ; $74FF
    inc de                                        ; $7500
    inc de                                        ; $7501
    dec c                                         ; $7502
    jr nz, jr_008_74fe                            ; $7503

    ld bc, $0034                                  ; $7505
    add hl, bc                                    ; $7508
    pop bc                                        ; $7509
    dec c                                         ; $750A
    jr nz, jr_008_74fb                            ; $750B

    ld hl, $9834                                  ; $750D
    ld de, wAnimScript + $1                       ; $7510
    dec b                                         ; $7513
    jr nz, jr_008_74f9                            ; $7514

    ld a, $ff                                     ; $7516
    ld [wAnimScript + $30], a                     ; $7518
    xor a                                         ; $751B
    ld [wAnimScript + $31], a                     ; $751C
    ret                                           ; $751F


    ; padding
    ds $ae0, $00

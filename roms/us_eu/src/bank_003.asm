; Game Boy Camera (USA, Europe), bank $03. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; C: slide-show / animation editor (47-entry list)
Mode12_AnimationEditor::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; I: 35 states, rst $18 table of mode $12
Mode12_StateTable::
    dw Mode12_State00_Init
    dw Mode12_State01_Browse
    dw Mode12_State02_EntryReleased
    dw Mode12_State03_EditSpeed
    dw Mode12_State04_ToggleLoop
    dw Mode12_State05_Exit
    dw Mode12_State06_ToolsOpen
    dw Mode12_State07_ToolsSlideIn
    dw Mode12_State08_ToolsMenu
    dw Mode12_State09_RangeBrowse
    dw Mode12_State0A_RangeAnim
    dw Mode12_State0B_RangeSelect
    dw Mode12_State0C_LoopCount
    dw Mode12_State0D_LoopApply
    dw Mode12_State0E_LoopClear
    dw Mode12_State0F_ClearAll
    dw Mode12_State10_Pack
    dw Mode12_State11_TestStart
    dw Mode12_State12_TestRun
    dw Mode12_State13_TestEnd
    dw Mode12_State14_SaveDialogOpen
    dw Mode12_State15_SaveDialogWait
    dw Mode12_State16_SaveDialogClose
    dw Mode12_State17_ExitDialogOpen
    dw Mode12_State18_ExitDialogWait
    dw Mode12_State19_ExitDialogClose
    dw Mode12_State1A_ClearDialogOpen
    dw Mode12_State1B_ClearDialogWait
    dw Mode12_State1C_ClearDialogClose
    dw Mode12_State1D_SortDialogOpen
    dw Mode12_State1E_SortDialogWait
    dw Mode12_State1F_SortDialogClose
    dw Mode12_State20_BorderRow
    dw Mode12_State21_FarBorderPicker
    dw Mode12_State22_BorderPickerReturn

; C: loads the editor graphics
Mode12_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $404A
    ldh [hLcdcShadow], a                          ; $404C
    ld a, $e4                                     ; $404E
    ld [wPaletteTarget], a                        ; $4050
    ld [wPaletteTarget + $1], a                   ; $4053
    ld a, $d2                                     ; $4056
    ld [wPaletteTarget + $2], a                   ; $4058
    xor a                                         ; $405B
    ldh [hScxShadow], a                           ; $405C
    ld a, $10                                     ; $405E
    ldh [hScyShadow], a                           ; $4060
    ld a, $95                                     ; $4062
    ldh [hWyShadow], a                            ; $4064
    ld a, $07                                     ; $4066
    ldh [hWxShadow], a                            ; $4068
    ld a, $0c                                     ; $406A
    ld hl, Gfx_0C_4000_Mode12_State00_Init        ; $406C
    ld de, $8000                                  ; $406F
    ld bc, $1800                                  ; $4072
    call Mem_CopyFromBank                         ; $4075
    farcopy Mem_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $4078
    screen_on                                     ; $4086
    play_music MUSIC_ANIMATION_EDITOR             ; $408F
    ldh [hFarcallAArg], a                         ; $4096
    farcall Settings_LoadAnimTranslated_Far       ; $4098
    xor a                                         ; $40A0
    ld [wDirtyFlag], a                            ; $40A1
    call AnimEd_InitEditor                        ; $40A4
    call AnimEd_LoadEntryThumb                    ; $40A7
    call AnimEd_ShowBorderDigits                  ; $40AA
    call AnimEd_ShowEntryValue                    ; $40AD
    call AnimEd_ShowEntryIndex                    ; $40B0
    call AnimEd_ShowSpeed                         ; $40B3
    call Pal_FadeIn                               ; $40B6
    call AnimEd_StartDecorations                  ; $40B9
    call AnimEd_DrawTimingMarkers                 ; $40BC
    next_state                                    ; $40BF
    ret                                           ; $40C3


; C: entry cursor: D-pad moves
Mode12_State01_Browse::
    xor a                                         ; $40C4
    ld [wEditorRangeMode], a                      ; $40C5
    call AnimEd_PreviewTick                       ; $40C8
    call AnimEd_MoveEntryCursor                   ; $40CB
    jr nc, jr_003_4100                            ; $40CE

    push af                                       ; $40D0
    call AnimEd_DrawEntryCursor                   ; $40D1
    pop af                                        ; $40D4
    and a                                         ; $40D5
    jr nz, jr_003_40fa                            ; $40D6

    farcopy Vram_CopyFromBank, Gfx_0C_5DA0_Mode12_State01_Browse, $88c0, $0060 ; $40D8
    farcopy Vram_CopyFromBank, Gfx_0C_5D70_Mode12_State01_Browse, $8950, $0030 ; $40E6
    set_state STATE_12_EDIT_SPEED                 ; $40F4
    ret                                           ; $40F9


jr_003_40fa:
    set_state STATE_12_TOGGLE_LOOP                ; $40FA
    ret                                           ; $40FF


jr_003_4100:
    call AnimEd_DrawEntryCursor                   ; $4100
    call AnimEd_DrawHandSprite                    ; $4103
    call AnimEd_UpdateSparks                      ; $4106
    ldh a, [hKeysHeld]                            ; $4109
    bit PADB_A, a                                 ; $410B
    jr z, jr_003_4135                             ; $410D

    ld a, [wCurEntryIndex]                        ; $410F
    ld c, a                                       ; $4112
    ld b, $00                                     ; $4113
    ld hl, wAnimList                              ; $4115
    add hl, bc                                    ; $4118
    ld a, [hl]                                    ; $4119
    cp $fe                                        ; $411A
    jr nz, jr_003_412a                            ; $411C

    ld a, $ff                                     ; $411E
    ld [hl], a                                    ; $4120
    ld [wCurEntryValue], a                        ; $4121
    call AnimEd_LoadEntryThumb                    ; $4124
    call AnimEd_ShowEntryValue                    ; $4127

jr_003_412a:
    ld hl, wCurEntryIndex                         ; $412A
    set 7, [hl]                                   ; $412D
    set_state STATE_12_ENTRY_RELEASED             ; $412F
    ret                                           ; $4134


jr_003_4135:
    ldh a, [hKeysNew]                             ; $4135
    bit PADB_B, a                                 ; $4137
    jr z, jr_003_4150                             ; $4139

    call AnimEd_ClearSparks                       ; $413B
    ld a, [wDirtyFlag]                            ; $413E
    and a                                         ; $4141
    jr nz, jr_003_414a                            ; $4142

    set_state STATE_12_EXIT                       ; $4144
    ret                                           ; $4149


jr_003_414a:
    set_state STATE_12_SAVE_DIALOG_OPEN           ; $414A
    ret                                           ; $414F


jr_003_4150:
    bit 2, a                                      ; $4150
    ret z                                         ; $4152

    call AnimEd_ClearSparks                       ; $4153
    set_state STATE_12_TOOLS_OPEN                 ; $4156
    ret                                           ; $415B


; C: A released: commits the entry value to the grid
Mode12_State02_EntryReleased::
    call AnimEd_PreviewTick                       ; $415C
    call AnimEd_ChangeEntryValue                  ; $415F
    call AnimEd_DrawEntryCursor                   ; $4162
    call AnimEd_DrawHandSprite                    ; $4165
    call AnimEd_UpdateSparks                      ; $4168
    ldh a, [hKeysHeld]                            ; $416B
    bit PADB_A, a                                 ; $416D
    ret nz                                        ; $416F

    ld hl, wCurEntryIndex                         ; $4170
    res 7, [hl]                                   ; $4173
    ld a, [hl]                                    ; $4175
    ld c, a                                       ; $4176
    ld b, $00                                     ; $4177
    ld hl, wAnimList                              ; $4179
    add hl, bc                                    ; $417C
    ld a, [hl]                                    ; $417D
    cp $fe                                        ; $417E
    jr nc, jr_003_4186                            ; $4180

    ld a, $85                                     ; $4182
    jr jr_003_4188                                ; $4184

jr_003_4186:
    ld a, $7e                                     ; $4186

jr_003_4188:
    push af                                       ; $4188
    inc c                                         ; $4189
    ld a, c                                       ; $418A
    and $30                                       ; $418B
    sla a                                         ; $418D
    sla a                                         ; $418F
    ld e, a                                       ; $4191
    ld a, c                                       ; $4192
    and $0f                                       ; $4193
    add e                                         ; $4195
    ld e, a                                       ; $4196
    ld d, $00                                     ; $4197
    ld hl, $99c2                                  ; $4199
    add hl, de                                    ; $419C
    pop af                                        ; $419D
    call Vram_WriteByteSafe                       ; $419E
    call AnimEd_SpawnSpark                        ; $41A1
    call AnimEd_ShowEntryValue                    ; $41A4
    call AnimEd_ShowEntryIndex                    ; $41A7
    set_state STATE_12_BROWSE                     ; $41AA
    ld hl, wDirtyFlag                             ; $41AF
    set 0, [hl]                                   ; $41B2
    ret                                           ; $41B4


; C: A held: Up / Down changes the animation speed
Mode12_State03_EditSpeed::
    call AnimEd_DrawEntryCursor                   ; $41B5
    call AnimEd_UpdateSparks                      ; $41B8
    call AnimEd_DrawSpeedHand                     ; $41BB
    ldh a, [hKeysHeld]                            ; $41BE
    bit PADB_A, a                                 ; $41C0
    jr z, jr_003_41f5                             ; $41C2

    ld a, $02                                     ; $41C4
    ld [wSpriteAnimFrame + $4], a                 ; $41C6
    xor a                                         ; $41C9
    ld [wSpriteAnimTick + $4], a                  ; $41CA
    ldh a, [hKeysNewRepeat]                       ; $41CD
    ld b, a                                       ; $41CF
    ld a, [wAnimSpeed]                            ; $41D0
    bit 6, b                                      ; $41D3
    jr z, jr_003_41e0                             ; $41D5

    dec a                                         ; $41D7
    cp $ff                                        ; $41D8
    jr nz, jr_003_41e9                            ; $41DA

    ld a, $63                                     ; $41DC
    jr jr_003_41e9                                ; $41DE

jr_003_41e0:
    bit 7, b                                      ; $41E0
    ret z                                         ; $41E2

    inc a                                         ; $41E3
    cp $64                                        ; $41E4
    jr nz, jr_003_41e9                            ; $41E6

    xor a                                         ; $41E8

jr_003_41e9:
    ld [wAnimSpeed], a                            ; $41E9
    call AnimEd_ShowSpeed                         ; $41EC
    ld hl, wDirtyFlag                             ; $41EF
    set 0, [hl]                                   ; $41F2
    ret                                           ; $41F4


jr_003_41f5:
    ldh a, [hKeysNew]                             ; $41F5
    bit PADB_DOWN, a                              ; $41F7
    jr z, jr_003_421b                             ; $41F9

    farcopy Vram_CopyFromBank, Gfx_0C_48C0_Mode12_State0F_ClearAll, $88c0, $00c0 ; $41FB
    ld a, [wEditorRangeMode]                      ; $4209
    and a                                         ; $420C
    jr nz, jr_003_4215                            ; $420D

    set_state STATE_12_BROWSE                     ; $420F
    ret                                           ; $4214


jr_003_4215:
    set_state STATE_12_RANGE_BROWSE               ; $4215
    ret                                           ; $421A


jr_003_421b:
    bit 2, a                                      ; $421B
    jr z, jr_003_4228                             ; $421D

    call AnimEd_ClearSparks                       ; $421F
    set_state STATE_12_TOOLS_OPEN                 ; $4222
    ret                                           ; $4227


jr_003_4228:
    bit 6, a                                      ; $4228
    jr z, jr_003_424e                             ; $422A

    farcopy Vram_CopyFromBank, Gfx_0C_4950_Mode12_State03_EditSpeed, $8950, $0030 ; $422C
    farcopy Vram_CopyFromBank, Gfx_0C_5D40_Mode12_State22_BorderPickerReturn, $8920, $0030 ; $423A
    set_state STATE_12_BORDER_ROW                 ; $4248
    ret                                           ; $424D


jr_003_424e:
    bit 1, a                                      ; $424E
    ret z                                         ; $4250

    call AnimEd_ClearSparks                       ; $4251
    ld a, [wDirtyFlag]                            ; $4254
    and a                                         ; $4257
    jr nz, jr_003_4260                            ; $4258

    set_state STATE_12_EXIT                       ; $425A
    ret                                           ; $425F


jr_003_4260:
    set_state STATE_12_SAVE_DIALOG_OPEN           ; $4260
    ret                                           ; $4265


; C: animated hand sprite beside the speed digits. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpeedHand::
    ld a, [wSpriteAnimFrame + $4]                 ; $4266
    sla a                                         ; $4269
    ld e, a                                       ; $426B
    ld d, $00                                     ; $426C
    ld hl, AnimEd_DrawSpeedHand_Gfx429D           ; $426E
    add hl, de                                    ; $4271
    ld a, [hl+]                                   ; $4272
    ld bc, $9448                                  ; $4273
    push hl                                       ; $4276
    cp $ff                                        ; $4277
    jr z, jr_003_427e                             ; $4279

    call Oam_AddMeta_B01_4000                     ; $427B

jr_003_427e:
    pop hl                                        ; $427E
    ld a, [wSpriteAnimTick + $4]                  ; $427F
    cp [hl]                                       ; $4282
    jr nz, jr_003_4295                            ; $4283

    ld a, [wSpriteAnimFrame + $4]                 ; $4285
    inc a                                         ; $4288
    cp $03                                        ; $4289
    jr c, jr_003_428e                             ; $428B

    xor a                                         ; $428D

jr_003_428e:
    ld [wSpriteAnimFrame + $4], a                 ; $428E
    xor a                                         ; $4291
    ld [wSpriteAnimTick + $4], a                  ; $4292

jr_003_4295:
    ld a, [wSpriteAnimTick + $4]                  ; $4295
    inc a                                         ; $4298
    ld [wSpriteAnimTick + $4], a                  ; $4299
    ret                                           ; $429C


; C: auto: 8 bytes, tile data; referenced by AnimEd_DrawSpeedHand. L3 pass 2026-10-26: read in BGB in 9 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpeedHand_Gfx429D::
    db $6e, $04, $6f, $04, $70, $07, $ff, $0a

; I: toggles the loop-at-end flag
Mode12_State04_ToggleLoop::
    call AnimEd_DrawEntryCursor                   ; $42A5
    call AnimEd_UpdateSparks                      ; $42A8
    ldh a, [hKeysNew]                             ; $42AB
    bit PADB_A, a                                 ; $42AD
    jr z, jr_003_4303                             ; $42AF

    play_sfx1 SFX1_CURSOR_MOVE                    ; $42B1
    call Oam_HideUnused                           ; $42B8
    ld a, [wAnimLoopFlag]                         ; $42BB
    and a                                         ; $42BE
    jr nz, jr_003_42d1                            ; $42BF

    farcopy Vram_CopyFromBank, Gfx_0C_5FE0_Mode12_State04_ToggleLoop, $97c0, $0020 ; $42C1
    jr jr_003_42df                                ; $42CF

jr_003_42d1:
    farcopy Vram_CopyFromBank, Gfx_0C_6000_Mode12_State04_ToggleLoop, $97c0, $0020 ; $42D1

jr_003_42df:
    rst Rst08_WaitVBlank                          ; $42DF
    ldh a, [hKeysHeld]                            ; $42E0
    bit PADB_A, a                                 ; $42E2
    jr nz, jr_003_42df                            ; $42E4

    call AnimEd_DrawEntryCursor                   ; $42E6
    ld a, [wAnimLoopFlag]                         ; $42E9
    xor $ff                                       ; $42EC
    ld [wAnimLoopFlag], a                         ; $42EE
    call AnimEd_ShowLoopFlag                      ; $42F1
    ld a, $03                                     ; $42F4
    ld [wSpriteAnimFrame + $5], a                 ; $42F6
    xor a                                         ; $42F9
    ld [wSpriteAnimTick + $5], a                  ; $42FA
    ld hl, wDirtyFlag                             ; $42FD
    set 0, [hl]                                   ; $4300
    ret                                           ; $4302


jr_003_4303:
    call AnimEd_DrawLoopHand                      ; $4303
    ldh a, [hKeysNewRepeat]                       ; $4306
    bit PADB_LEFT, a                              ; $4308
    jr z, jr_003_4310                             ; $430A

    ld a, $2e                                     ; $430C
    jr jr_003_4315                                ; $430E

jr_003_4310:
    bit 4, a                                      ; $4310
    jr z, jr_003_433f                             ; $4312

    xor a                                         ; $4314

jr_003_4315:
    ld hl, wCurEntryIndex                         ; $4315
    ld [hl], a                                    ; $4318
    ld c, a                                       ; $4319
    ld b, $00                                     ; $431A
    ld hl, wAnimList                              ; $431C
    add hl, bc                                    ; $431F
    ld a, [hl]                                    ; $4320
    ld [wCurEntryValue], a                        ; $4321
    call AnimEd_LoadEntryThumb                    ; $4324
    call AnimEd_ShowEntryValue                    ; $4327
    call AnimEd_ShowEntryIndex                    ; $432A
    ld a, [wEditorRangeMode]                      ; $432D
    and a                                         ; $4330
    jr nz, jr_003_4339                            ; $4331

    set_state STATE_12_BROWSE                     ; $4333
    ret                                           ; $4338


jr_003_4339:
    set_state STATE_12_RANGE_BROWSE               ; $4339
    ret                                           ; $433E


jr_003_433f:
    bit 2, a                                      ; $433F
    jr z, jr_003_434c                             ; $4341

    call AnimEd_ClearSparks                       ; $4343
    set_state STATE_12_TOOLS_OPEN                 ; $4346
    ret                                           ; $434B


jr_003_434c:
    bit 1, a                                      ; $434C
    ret z                                         ; $434E

    call AnimEd_ClearSparks                       ; $434F
    ld a, [wDirtyFlag]                            ; $4352
    and a                                         ; $4355
    jr nz, jr_003_435e                            ; $4356

    set_state STATE_12_EXIT                       ; $4358
    ret                                           ; $435D


jr_003_435e:
    set_state STATE_12_SAVE_DIALOG_OPEN           ; $435E
    ret                                           ; $4363


; C: animated hand sprite beside the loop indicator. L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopHand::
    ld a, [wSpriteAnimFrame + $5]                 ; $4364
    sla a                                         ; $4367
    ld e, a                                       ; $4369
    ld d, $00                                     ; $436A
    ld hl, AnimEd_DrawLoopHand_Map439B            ; $436C
    add hl, de                                    ; $436F
    ld a, [hl+]                                   ; $4370
    ld bc, $9a84                                  ; $4371
    push hl                                       ; $4374
    cp $ff                                        ; $4375
    jr z, jr_003_437c                             ; $4377

    call Oam_AddMeta_B01_4000                     ; $4379

jr_003_437c:
    pop hl                                        ; $437C
    ld a, [wSpriteAnimTick + $5]                  ; $437D
    cp [hl]                                       ; $4380
    jr nz, jr_003_4393                            ; $4381

    ld a, [wSpriteAnimFrame + $5]                 ; $4383
    inc a                                         ; $4386
    cp $03                                        ; $4387
    jr c, jr_003_438c                             ; $4389

    xor a                                         ; $438B

jr_003_438c:
    ld [wSpriteAnimFrame + $5], a                 ; $438C
    xor a                                         ; $438F
    ld [wSpriteAnimTick + $5], a                  ; $4390

jr_003_4393:
    ld a, [wSpriteAnimTick + $5]                  ; $4393
    inc a                                         ; $4396
    ld [wSpriteAnimTick + $5], a                  ; $4397
    ret                                           ; $439A


; C: auto: 8 bytes, tile map; referenced by AnimEd_DrawLoopHand. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopHand_Map439B::
    db $71, $04, $72, $04, $73, $07, $ff, $0a

; C: fades out and returns to the edit menu (mode 05)
Mode12_State05_Exit::
    call AnimEd_StartExitTransition               ; $43A3
    call Lcd_Off                                  ; $43A6
    ld a, [wAbResult]                             ; $43A9
    bit 0, a                                      ; $43AC
    jr z, jr_003_43bb                             ; $43AE

    ld a, MODE_EDIT_MENU                          ; $43B0
    ld [wMode], a                                 ; $43B2
    set_state STATE_05_INIT                       ; $43B5
    ret                                           ; $43BA


jr_003_43bb:
    ld a, MODE_EDIT_MENU                          ; $43BB
    ld [wMode], a                                 ; $43BD
    set_state STATE_05_INIT                       ; $43C0
    ret                                           ; $43C5


; C: loads the tools window graphics
Mode12_State06_ToolsOpen::
    play_sfx1 SFX1_KEY_SELECT                     ; $43C6
    farcopy Vram_CopyFromBank, Map_22_6DE0_Mode12_State06_ToolsOpen, $9840, $0040 ; $43CD
    next_state                                    ; $43DB
    ret                                           ; $43DF


; C: slides the tools window in
Mode12_State07_ToolsSlideIn::
    farcopy Vram_CopyFromBank, Gfx_0C_4D50_Mode12_State07_ToolsSlideIn, $8d50, $0280 ; $43E0
    call Oam_ClearShadow                          ; $43EE
    ld a, $75                                     ; $43F1
    ld [wSpriteAnimFrame + $6], a                 ; $43F3
    ld hl, Slide_ScyDeltaTbl                      ; $43F6
    ld b, $10                                     ; $43F9

jr_003_43fb:
    push bc                                       ; $43FB
    push hl                                       ; $43FC
    ldh a, [hScyShadow]                           ; $43FD
    add [hl]                                      ; $43FF
    ldh [hScyShadow], a                           ; $4400
    rst Rst08_WaitVBlank                          ; $4402
    pop hl                                        ; $4403
    pop bc                                        ; $4404
    inc hl                                        ; $4405
    dec b                                         ; $4406
    jr nz, jr_003_43fb                            ; $4407

    next_state                                    ; $4409
    ret                                           ; $440D


; C: LOOP / SORT / PACK / TEST / CLEAR tool menu: choice goes through the table at 449D
Mode12_State08_ToolsMenu::
    call AnimEd_ToolsMenuMove                     ; $440E
    call AnimEd_ToolsMenuCursor                   ; $4411
    ldh a, [hKeysNew]                             ; $4414
    and PADF_A | PADF_B | PADF_DOWN               ; $4416
    ret z                                         ; $4418

    push af                                       ; $4419
    bit 0, a                                      ; $441A
    ld a, SFX1_KEY_A                              ; $441C
    call nz, Snd_Sfx1                             ; $441E
    pop af                                        ; $4421
    push af                                       ; $4422
    bit 1, a                                      ; $4423
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4425
    call nz, Snd_Sfx1                             ; $4427
    pop af                                        ; $442A
    push af                                       ; $442B
    bit 7, a                                      ; $442C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $442E
    call nz, Snd_Sfx1                             ; $4430
    pop af                                        ; $4433
    push af                                       ; $4434
    bit 0, a                                      ; $4435
    jr z, jr_003_4451                             ; $4437

    call Oam_HideUnused                           ; $4439
    rst Rst08_WaitVBlank                          ; $443C
    ld a, $76                                     ; $443D
    ld [wSpriteAnimFrame + $6], a                 ; $443F
    call AnimEd_ToolsMenuCursor                   ; $4442
    call Oam_HideUnused                           ; $4445
    call AnimEd_LoadMenuTiles                     ; $4448
    ld bc, $0019                                  ; $444B
    call Wait_Frames                              ; $444E

jr_003_4451:
    call Oam_ClearShadow                          ; $4451
    ld hl, Slide_ScyDeltaTbl                      ; $4454
    ld b, $10                                     ; $4457

jr_003_4459:
    push bc                                       ; $4459
    push hl                                       ; $445A
    ldh a, [hScyShadow]                           ; $445B
    sub [hl]                                      ; $445D
    ldh [hScyShadow], a                           ; $445E
    rst Rst08_WaitVBlank                          ; $4460
    pop hl                                        ; $4461
    pop bc                                        ; $4462
    inc hl                                        ; $4463
    dec b                                         ; $4464
    jr nz, jr_003_4459                            ; $4465

    xor a                                         ; $4467
    ld [wSpriteAnimFrame + $3], a                 ; $4468
    ld [wSpriteAnimTick + $3], a                  ; $446B
    farcopy Vram_CopyFromBank, Map_1D_7FC0_Mode12_State08_ToolsMenu, $9840, $0040 ; $446E
    pop af                                        ; $447C
    bit 0, a                                      ; $447D
    jr nz, jr_003_4495                            ; $447F

    farcopy Vram_CopyFromBank, Map_1D_7FC0_Mode12_State08_ToolsMenu, $9840, $0040 ; $4481
    set_state STATE_12_BROWSE                     ; $448F
    ret                                           ; $4494


jr_003_4495:
    ld a, [wEditorMenuOption]                     ; $4495
    ld c, a                                       ; $4498
    ld b, $00                                     ; $4499
    ld hl, AnimEd_ToolsStateTbl                   ; $449B
    add hl, bc                                    ; $449E
    ld a, [hl]                                    ; $449F
    ld [wState], a                                ; $44A0
    ret                                           ; $44A3


; C: 5 states reached by the tools menu
AnimEd_ToolsStateTbl::
    db $09, $1d, $10, $11, $1a

; C: Up / Down moves the tool selection (0..4)
AnimEd_ToolsMenuMove::
    ldh a, [hKeysNewRepeat]                       ; $44A9
    ld b, a                                       ; $44AB
    ld a, [wEditorMenuOption]                     ; $44AC
    bit 5, b                                      ; $44AF
    jr z, jr_003_44b8                             ; $44B1

    and a                                         ; $44B3
    ret z                                         ; $44B4

    dec a                                         ; $44B5
    jr jr_003_44bf                                ; $44B6

jr_003_44b8:
    bit 4, b                                      ; $44B8
    ret z                                         ; $44BA

    cp $04                                        ; $44BB
    ret z                                         ; $44BD

    inc a                                         ; $44BE

jr_003_44bf:
    ld [wEditorMenuOption], a                     ; $44BF
    play_sfx1 SFX1_DIRECTION_KEY                  ; $44C2
    ret                                           ; $44C9


; C: draws the tool menu cursor sprite. L3 pass 2026-10-26: executed in BGB in 20 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ToolsMenuCursor::
    ld a, [wEditorMenuOption]                     ; $44CA
    ld c, a                                       ; $44CD
    ld b, $00                                     ; $44CE
    ld hl, AnimEd_ToolsMenuCursor_Tbl44E2         ; $44D0
    add hl, bc                                    ; $44D3
    ld b, [hl]                                    ; $44D4
    ldh a, [hScyShadow]                           ; $44D5
    cpl                                           ; $44D7
    add $0a                                       ; $44D8
    ld c, a                                       ; $44DA
    ld a, [wSpriteAnimFrame + $6]                 ; $44DB
    call Oam_AddMeta_B01_4000                     ; $44DE
    ret                                           ; $44E1


; C: auto: 5 bytes, bytes; referenced by AnimEd_ToolsMenuCursor. L3 pass 2026-10-26: read in BGB in 20 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ToolsMenuCursor_Tbl44E2::
    db $08, $28, $48, $68, $88

; C: range mode (loop markers): cursor moves
Mode12_State09_RangeBrowse::
    ld a, $01                                     ; $44E7
    ld [wEditorRangeMode], a                      ; $44E9
    call AnimEd_PreviewTick                       ; $44EC
    call AnimEd_MoveEntryCursor                   ; $44EF
    jr nc, jr_003_4524                            ; $44F2

    push af                                       ; $44F4
    call AnimEd_DrawEntryCursor                   ; $44F5
    pop af                                        ; $44F8
    and a                                         ; $44F9
    jr nz, jr_003_451e                            ; $44FA

    farcopy Vram_CopyFromBank, Gfx_0C_5DA0_Mode12_State01_Browse, $88c0, $0060 ; $44FC
    farcopy Vram_CopyFromBank, Gfx_0C_5D70_Mode12_State01_Browse, $8950, $0030 ; $450A
    set_state STATE_12_EDIT_SPEED                 ; $4518
    ret                                           ; $451D


jr_003_451e:
    set_state STATE_12_TOGGLE_LOOP                ; $451E
    ret                                           ; $4523


jr_003_4524:
    call AnimEd_DrawEntryCursor                   ; $4524
    call AnimEd_DrawHandSprite                    ; $4527
    ldh a, [hKeysNew]                             ; $452A
    bit PADB_A, a                                 ; $452C
    jr z, jr_003_45a1                             ; $452E

    ld a, [wCurEntryIndex]                        ; $4530
    ld c, a                                       ; $4533
    ld b, $00                                     ; $4534
    ld hl, wAnimTiming                            ; $4536
    add hl, bc                                    ; $4539
    ld a, [hl+]                                   ; $453A
    and a                                         ; $453B
    jr z, jr_003_4570                             ; $453C

jr_003_453e:
    bit 6, a                                      ; $453E
    jr nz, jr_003_4546                            ; $4540

    inc c                                         ; $4542
    ld a, [hl+]                                   ; $4543
    jr jr_003_453e                                ; $4544

jr_003_4546:
    ld a, c                                       ; $4546
    ld [wRangeMovingEnd], a                       ; $4547
    dec hl                                        ; $454A
    dec hl                                        ; $454B
    dec c                                         ; $454C
    ld a, [hl-]                                   ; $454D

jr_003_454e:
    bit 7, a                                      ; $454E
    jr nz, jr_003_4556                            ; $4550

    dec c                                         ; $4552
    ld a, [hl-]                                   ; $4553
    jr jr_003_454e                                ; $4554

jr_003_4556:
    and $3f                                       ; $4556
    ld [wSpriteAnimTick + $9], a                  ; $4558
    ld a, c                                       ; $455B
    ld [wRangeAnchor], a                          ; $455C
    xor a                                         ; $455F
    ld [wRangeDirection], a                       ; $4560
    play_sfx1 SFX1_CHOOSE                         ; $4563
    set_state STATE_12_RANGE_ANIM                 ; $456A
    ret                                           ; $456F


jr_003_4570:
    ld a, c                                       ; $4570
    inc a                                         ; $4571
    ld [wRangeMovingEnd], a                       ; $4572
    xor a                                         ; $4575
    ld [wRangeDirection], a                       ; $4576
    ld a, [hl-]                                   ; $4579
    and a                                         ; $457A
    jr z, jr_003_458b                             ; $457B

    dec hl                                        ; $457D
    ld a, [hl]                                    ; $457E
    and a                                         ; $457F
    ret nz                                        ; $4580

    ld a, c                                       ; $4581
    dec a                                         ; $4582
    ld [wRangeMovingEnd], a                       ; $4583
    ld a, $01                                     ; $4586
    ld [wRangeDirection], a                       ; $4588

jr_003_458b:
    ld a, $02                                     ; $458B
    ld [wSpriteAnimTick + $9], a                  ; $458D
    ld a, c                                       ; $4590
    ld [wRangeAnchor], a                          ; $4591
    play_sfx1 SFX1_CHOOSE                         ; $4594
    set_state STATE_12_RANGE_ANIM                 ; $459B
    ret                                           ; $45A0


jr_003_45a1:
    ldh a, [hKeysNew]                             ; $45A1
    bit PADB_SELECT, a                            ; $45A3
    jr z, jr_003_45ad                             ; $45A5

    set_state STATE_12_TOOLS_OPEN                 ; $45A7
    ret                                           ; $45AC


jr_003_45ad:
    bit 1, a                                      ; $45AD
    ret z                                         ; $45AF

    play_sfx1 SFX1_CHOOSE_C                       ; $45B0
    set_state STATE_12_BROWSE                     ; $45B7
    ret                                           ; $45BC


; C: animated start of a range. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Mode12_State0A_RangeAnim::
    xor a                                         ; $45BD
    ld [wSpriteAnimFrame + $7], a                 ; $45BE
    ld [wSpriteAnimTick + $7], a                  ; $45C1
    ld a, [wRangeAnchor]                          ; $45C4
    inc a                                         ; $45C7
    push af                                       ; $45C8
    and $0f                                       ; $45C9
    sla a                                         ; $45CB
    sla a                                         ; $45CD
    sla a                                         ; $45CF
    add $10                                       ; $45D1
    ld [wRangeCursorXy], a                        ; $45D3
    pop af                                        ; $45D6
    and $f0                                       ; $45D7
    add $5a                                       ; $45D9
    ld [wRangeCursorXy + $2], a                   ; $45DB

jr_003_45de:
    ld c, $00                                     ; $45DE
    ld de, $0000                                  ; $45E0
    call AnimEd_DrawRangeArrow                    ; $45E3
    call AnimEd_StepRangeAnim                     ; $45E6
    call AnimEd_DrawEntryCursor                   ; $45E9
    call Oam_HideUnused                           ; $45EC
    rst Rst08_WaitVBlank                          ; $45EF
    ld a, [wRangeAnimDone]                        ; $45F0
    and a                                         ; $45F3
    jr z, jr_003_45de                             ; $45F4

    ld a, [wRangeDirection]                       ; $45F6
    and a                                         ; $45F9
    jr nz, jr_003_4609                            ; $45FA

    ld a, [wRangeAnchor]                          ; $45FC
    ld e, $a7                                     ; $45FF
    call AnimEd_PutGridTile                       ; $4601
    ld de, $0029                                  ; $4604
    jr jr_003_4614                                ; $4607

jr_003_4609:
    ld a, [wRangeAnchor]                          ; $4609
    ld e, $a9                                     ; $460C
    call AnimEd_PutGridTile                       ; $460E
    ld de, $0036                                  ; $4611

jr_003_4614:
    xor a                                         ; $4614
    ld [wSpriteAnimFrame + $7], a                 ; $4615
    ld [wSpriteAnimTick + $7], a                  ; $4618
    ld c, $00                                     ; $461B
    call AnimEd_StepRangeAnim                     ; $461D
    xor a                                         ; $4620
    ld [wSpriteAnimFrame + $8], a                 ; $4621
    ld [wSpriteAnimTick + $8], a                  ; $4624
    ld a, [wRangeAnchor]                          ; $4627
    inc a                                         ; $462A
    push af                                       ; $462B
    and $0f                                       ; $462C
    sla a                                         ; $462E
    sla a                                         ; $4630
    sla a                                         ; $4632
    add $10                                       ; $4634
    ld [wRangeCursorXy + $1], a                   ; $4636
    pop af                                        ; $4639
    and $f0                                       ; $463A
    add $5e                                       ; $463C
    ld [wRangeCursorXy + $3], a                   ; $463E

jr_003_4641:
    ld a, [wRangeDirection]                       ; $4641
    and a                                         ; $4644
    jr nz, jr_003_4650                            ; $4645

    ld de, $0043                                  ; $4647
    push de                                       ; $464A
    ld de, $0029                                  ; $464B
    jr jr_003_4657                                ; $464E

jr_003_4650:
    ld de, $004c                                  ; $4650
    push de                                       ; $4653
    ld de, $0036                                  ; $4654

jr_003_4657:
    xor a                                         ; $4657
    ld [wSpriteAnimFrame + $7], a                 ; $4658
    ld [wSpriteAnimTick + $7], a                  ; $465B
    ld c, $00                                     ; $465E
    call AnimEd_DrawRangeArrow                    ; $4660
    call AnimEd_StepRangeAnim                     ; $4663
    pop de                                        ; $4666
    ld c, $01                                     ; $4667
    call AnimEd_DrawRangeArrow                    ; $4669
    call AnimEd_StepRangeAnim                     ; $466C
    call AnimEd_DrawEntryCursor                   ; $466F
    call Oam_HideUnused                           ; $4672
    rst Rst08_WaitVBlank                          ; $4675
    ld a, [wRangeAnimDone + $1]                   ; $4676
    and a                                         ; $4679
    jr z, jr_003_4641                             ; $467A

    ld a, [wRangeAnchor]                          ; $467C
    ld b, a                                       ; $467F
    ld a, [wRangeDirection]                       ; $4680
    and a                                         ; $4683
    jr nz, jr_003_468d                            ; $4684

    ld de, $0029                                  ; $4686
    ld c, $01                                     ; $4689
    jr jr_003_4692                                ; $468B

jr_003_468d:
    ld de, $0036                                  ; $468D
    ld c, $ff                                     ; $4690

jr_003_4692:
    ld a, b                                       ; $4692
    add c                                         ; $4693
    ld b, a                                       ; $4694
    push bc                                       ; $4695
    push de                                       ; $4696
    ld e, $a8                                     ; $4697
    call AnimEd_PutGridTile                       ; $4699
    ld a, b                                       ; $469C
    inc a                                         ; $469D
    push af                                       ; $469E
    and $0f                                       ; $469F
    sla a                                         ; $46A1
    sla a                                         ; $46A3
    sla a                                         ; $46A5
    add $10                                       ; $46A7
    ld [wRangeCursorXy + $1], a                   ; $46A9
    pop af                                        ; $46AC
    and $f0                                       ; $46AD
    add $5e                                       ; $46AF
    ld [wRangeCursorXy + $3], a                   ; $46B1
    pop de                                        ; $46B4
    push de                                       ; $46B5
    push bc                                       ; $46B6
    ld c, $00                                     ; $46B7
    call AnimEd_DrawRangeArrow                    ; $46B9
    call AnimEd_StepRangeAnim                     ; $46BC
    call AnimEd_DrawRangeEndCursor                ; $46BF
    pop bc                                        ; $46C2
    ld a, b                                       ; $46C3
    ld [wCurEntryIndex], a                        ; $46C4
    ld c, a                                       ; $46C7
    ld b, $00                                     ; $46C8
    ld hl, wAnimList                              ; $46CA
    add hl, bc                                    ; $46CD
    ld a, [hl]                                    ; $46CE
    ld [wCurEntryValue], a                        ; $46CF
    call AnimEd_LoadEntryThumb                    ; $46D2
    call AnimEd_ShowEntryValue                    ; $46D5
    call AnimEd_ShowEntryIndex                    ; $46D8
    call AnimEd_DrawEntryCursor                   ; $46DB
    call Oam_HideUnused                           ; $46DE
    rst Rst08_WaitVBlank                          ; $46E1
    pop de                                        ; $46E2
    pop bc                                        ; $46E3
    ld a, [wRangeMovingEnd]                       ; $46E4
    cp b                                          ; $46E7
    jr nz, jr_003_4692                            ; $46E8

    ld c, $00                                     ; $46EA
    call AnimEd_DrawRangeArrow                    ; $46EC
    call AnimEd_StepRangeAnim                     ; $46EF
    call AnimEd_DrawRangeEndCursor                ; $46F2
    call AnimEd_DrawEntryCursor                   ; $46F5
    next_state                                    ; $46F8
    ret                                           ; $46FC


; C: draws a range-edit arrow sprite. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes
; 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeArrow::
    push bc                                       ; $46FD
    push de                                       ; $46FE
    ld b, $00                                     ; $46FF
    push bc                                       ; $4701
    ld hl, wSpriteAnimFrame + $7                  ; $4702
    add hl, bc                                    ; $4705
    ld a, [hl]                                    ; $4706
    sla a                                         ; $4707
    sla a                                         ; $4709
    ld c, a                                       ; $470B
    ld b, $00                                     ; $470C
    ld hl, AnimEd_DrawRangeArrow_Tbl4797          ; $470E
    add hl, bc                                    ; $4711
    add hl, de                                    ; $4712
    ld a, [hl]                                    ; $4713
    pop bc                                        ; $4714
    ld hl, wRangeCursorXy                         ; $4715
    add hl, bc                                    ; $4718
    ld b, [hl]                                    ; $4719
    inc hl                                        ; $471A
    inc hl                                        ; $471B
    ld c, [hl]                                    ; $471C
    cp $ff                                        ; $471D
    jr z, jr_003_4724                             ; $471F

    call Oam_AddMeta_B01_4000                     ; $4721

jr_003_4724:
    pop de                                        ; $4724
    pop bc                                        ; $4725
    ret                                           ; $4726


; C: advances the range arrow animation. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StepRangeAnim::
    push bc                                       ; $4727
    push de                                       ; $4728
    ld b, $00                                     ; $4729
    push bc                                       ; $472B
    ld hl, wRangeAnimDone                         ; $472C
    add hl, bc                                    ; $472F
    ld [hl], $00                                  ; $4730
    ld hl, wSpriteAnimFrame + $7                  ; $4732
    add hl, bc                                    ; $4735
    ld a, [hl]                                    ; $4736
    sla a                                         ; $4737
    sla a                                         ; $4739
    ld c, a                                       ; $473B
    ld hl, AnimEd_StepRangeAnim_Tbl4794           ; $473C
    add hl, bc                                    ; $473F
    add hl, de                                    ; $4740
    ld a, [hl]                                    ; $4741
    pop bc                                        ; $4742
    push bc                                       ; $4743
    push hl                                       ; $4744
    ld hl, wSpriteAnimTick + $7                   ; $4745
    add hl, bc                                    ; $4748
    cp [hl]                                       ; $4749
    ld a, [hl]                                    ; $474A
    jr nz, jr_003_4778                            ; $474B

    ld hl, wSpriteAnimFrame + $7                  ; $474D
    add hl, bc                                    ; $4750
    ld a, [hl]                                    ; $4751
    inc a                                         ; $4752
    ld c, a                                       ; $4753
    pop hl                                        ; $4754
    inc hl                                        ; $4755
    inc hl                                        ; $4756
    inc hl                                        ; $4757
    inc hl                                        ; $4758
    ld a, [hl]                                    ; $4759
    and a                                         ; $475A
    jr nz, jr_003_476a                            ; $475B

    pop bc                                        ; $475D
    push bc                                       ; $475E
    ld hl, wRangeAnimDone                         ; $475F
    add hl, bc                                    ; $4762
    inc [hl]                                      ; $4763
    ld c, $00                                     ; $4764
    ld hl, AnimEd_StepRangeAnim_Tbl4794           ; $4766
    add hl, de                                    ; $4769

jr_003_476a:
    pop de                                        ; $476A
    push de                                       ; $476B
    push hl                                       ; $476C
    ld hl, wSpriteAnimFrame + $7                  ; $476D
    add hl, de                                    ; $4770
    ld [hl], c                                    ; $4771
    ld hl, wSpriteAnimTick + $7                   ; $4772
    add hl, de                                    ; $4775
    xor a                                         ; $4776
    ld [hl], a                                    ; $4777

jr_003_4778:
    pop de                                        ; $4778
    and a                                         ; $4779
    jr nz, jr_003_478b                            ; $477A

    inc de                                        ; $477C
    pop bc                                        ; $477D
    push bc                                       ; $477E
    ld hl, wRangeCursorXy                         ; $477F
    add hl, bc                                    ; $4782
    ld a, [de]                                    ; $4783
    add [hl]                                      ; $4784
    ld [hl+], a                                   ; $4785
    inc de                                        ; $4786
    inc hl                                        ; $4787
    ld a, [de]                                    ; $4788
    add [hl]                                      ; $4789
    ld [hl], a                                    ; $478A

jr_003_478b:
    pop bc                                        ; $478B
    ld hl, wSpriteAnimTick + $7                   ; $478C
    add hl, bc                                    ; $478F
    inc [hl]                                      ; $4790
    pop de                                        ; $4791
    pop bc                                        ; $4792
    ret                                           ; $4793


; C: auto: 3 bytes, bytes; referenced by AnimEd_StepRangeAnim. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StepRangeAnim_Tbl4794::
    db $02, $00, $02

; C: auto: 164 bytes, bytes; referenced by AnimEd_DrawRangeArrow. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeArrow_Tbl4797::
    db $63, $02, $00, $02, $63, $05, $00, $00, $63, $01, $fe, $00, $63, $03, $02, $00
    db $63, $01, $02, $00, $63, $02, $fe, $00, $63, $01, $00, $01, $63, $14, $00, $00
    db $63, $04, $00, $00, $64, $00, $07, $00, $00, $69, $07, $00, $00, $6a, $07, $00
    db $00, $6b, $00, $07, $00, $00, $64, $07, $00, $00, $65, $07, $00, $00, $66, $00
    db $0a, $00, $00, $67, $07, $00, $00, $68, $00, $0a, $00, $00, $6c, $07, $00, $00
    db $6d, $00, $14, $00, $00, $63, $01, $00, $ff, $63, $02, $fe, $00, $63, $01, $02
    db $00, $63, $03, $02, $00, $63, $01, $fe, $00, $63, $02, $00, $00, $63, $02, $00
    db $fe, $63, $02, $00, $fe, $63, $14, $00, $05, $ff, $00, $02, $00, $02, $7d, $02
    db $00, $02, $7d, $05, $00, $00, $7d, $01, $fe, $00, $7d, $03, $02, $00, $7d, $01
    db $02, $00, $7d, $02, $fe, $00, $7d, $01, $00, $01, $7d, $14, $00, $00, $7d, $04
    db $00, $00, $69, $00

; C: Left / Right extends the range
Mode12_State0B_RangeSelect::
    call AnimEd_PreviewTick                       ; $483B
    call AnimEd_MoveRangeEnd                      ; $483E
    ld a, [wRangeDirection]                       ; $4841
    and a                                         ; $4844
    jr nz, jr_003_484c                            ; $4845

    ld de, $0029                                  ; $4847
    jr jr_003_4858                                ; $484A

jr_003_484c:
    bit 7, a                                      ; $484C
    jr nz, jr_003_4855                            ; $484E

    ld de, $0036                                  ; $4850
    jr jr_003_4858                                ; $4853

jr_003_4855:
    ld de, $0055                                  ; $4855

jr_003_4858:
    ld c, $00                                     ; $4858
    call AnimEd_DrawRangeArrow                    ; $485A
    call AnimEd_StepRangeAnim                     ; $485D
    ld a, [wRangeDirection]                       ; $4860
    bit 7, a                                      ; $4863
    jr nz, jr_003_486a                            ; $4865

    call AnimEd_DrawRangeEndCursor                ; $4867

jr_003_486a:
    call AnimEd_DrawEntryCursor                   ; $486A
    ldh a, [hKeysNew]                             ; $486D
    bit PADB_A, a                                 ; $486F
    jr z, jr_003_48bc                             ; $4871

    ld a, [wRangeDirection]                       ; $4873
    cp $ff                                        ; $4876
    jr nz, jr_003_4880                            ; $4878

    set_state STATE_12_LOOP_CLEAR                 ; $487A
    ret                                           ; $487F


jr_003_4880:
    call AnimEd_RangeConfirmAnim                  ; $4880
    ld a, [wRangeDirection]                       ; $4883
    and a                                         ; $4886
    jr nz, jr_003_4893                            ; $4887

    ld a, [wRangeAnchor]                          ; $4889
    ld b, a                                       ; $488C
    ld a, [wRangeMovingEnd]                       ; $488D
    ld c, a                                       ; $4890
    jr jr_003_489b                                ; $4891

jr_003_4893:
    ld a, [wRangeAnchor]                          ; $4893
    ld c, a                                       ; $4896
    ld a, [wRangeMovingEnd]                       ; $4897
    ld b, a                                       ; $489A

jr_003_489b:
    ld e, $a4                                     ; $489B
    ld a, b                                       ; $489D
    call AnimEd_PutGridTile                       ; $489E
    inc e                                         ; $48A1

jr_003_48a2:
    inc b                                         ; $48A2
    ld a, b                                       ; $48A3
    cp c                                          ; $48A4
    jr z, jr_003_48ac                             ; $48A5

    call AnimEd_PutGridTile                       ; $48A7
    jr jr_003_48a2                                ; $48AA

jr_003_48ac:
    inc e                                         ; $48AC
    call AnimEd_PutGridTile                       ; $48AD
    play_sfx1 SFX1_CURSOR_MOVE                    ; $48B0
    next_state                                    ; $48B7
    ret                                           ; $48BB


jr_003_48bc:
    bit 1, a                                      ; $48BC
    ret z                                         ; $48BE

    call AnimEd_DrawTimingMarkers                 ; $48BF
    set_state STATE_12_RANGE_BROWSE               ; $48C2
    ret                                           ; $48C7


; C: L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeEndCursor::
    ld a, [wRangeDirection]                       ; $48C8
    and a                                         ; $48CB
    jr nz, jr_003_48d2                            ; $48CC

    ld a, $68                                     ; $48CE
    jr jr_003_48d4                                ; $48D0

jr_003_48d2:
    ld a, $6d                                     ; $48D2

jr_003_48d4:
    ld hl, wRangeCursorXy + $1                    ; $48D4
    ld b, [hl]                                    ; $48D7
    inc hl                                        ; $48D8
    inc hl                                        ; $48D9
    ld c, [hl]                                    ; $48DA
    call Oam_AddMeta_B01_4000                     ; $48DB
    ret                                           ; $48DE


; C: Left / Right moves the moving end of the range
AnimEd_MoveRangeEnd::
    ldh a, [hKeysNewRepeat]                       ; $48DF
    ld b, a                                       ; $48E1
    ld a, [wRangeMovingEnd]                       ; $48E2
    bit 5, b                                      ; $48E5
    jr z, jr_003_4907                             ; $48E7

    and a                                         ; $48E9
    ret z                                         ; $48EA

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $48EB
    ld hl, wRangeAnchor                           ; $48F2
    cp [hl]                                       ; $48F5
    jr z, jr_003_48fa                             ; $48F6

    jr nc, jr_003_4904                            ; $48F8

jr_003_48fa:
    ld e, a                                       ; $48FA
    ld d, $00                                     ; $48FB
    ld hl, wAnimTimingGuardLo                     ; $48FD
    add hl, de                                    ; $4900
    bit 6, [hl]                                   ; $4901
    ret nz                                        ; $4903

jr_003_4904:
    dec a                                         ; $4904
    jr jr_003_4925                                ; $4905

jr_003_4907:
    bit 4, b                                      ; $4907
    ret z                                         ; $4909

    cp $2e                                        ; $490A
    ret z                                         ; $490C

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $490D
    ld hl, wRangeAnchor                           ; $4914
    cp [hl]                                       ; $4917
    jr c, jr_003_4924                             ; $4918

    ld e, a                                       ; $491A
    ld d, $00                                     ; $491B
    ld hl, wAnimTiming + $1                       ; $491D
    add hl, de                                    ; $4920
    bit 7, [hl]                                   ; $4921
    ret nz                                        ; $4923

jr_003_4924:
    inc a                                         ; $4924

jr_003_4925:
    ld c, a                                       ; $4925
    ld hl, wRangeMovingEnd                        ; $4926
    ld a, [wRangeDirection]                       ; $4929
    and a                                         ; $492C
    jr nz, jr_003_4935                            ; $492D

    ld a, c                                       ; $492F
    cp [hl]                                       ; $4930
    jr nc, jr_003_4956                            ; $4931

    jr jr_003_4950                                ; $4933

jr_003_4935:
    dec a                                         ; $4935
    jr nz, jr_003_493e                            ; $4936

    ld a, c                                       ; $4938
    cp [hl]                                       ; $4939
    jr c, jr_003_4956                             ; $493A

    jr jr_003_4950                                ; $493C

jr_003_493e:
    ld a, c                                       ; $493E
    cp [hl]                                       ; $493F
    ld a, [hl]                                    ; $4940
    jr c, jr_003_4947                             ; $4941

    ld e, $a7                                     ; $4943
    jr jr_003_4949                                ; $4945

jr_003_4947:
    ld e, $a9                                     ; $4947

jr_003_4949:
    push bc                                       ; $4949
    call AnimEd_PutGridTile                       ; $494A
    pop bc                                        ; $494D
    jr jr_003_4956                                ; $494E

jr_003_4950:
    ld a, [hl]                                    ; $4950
    ld e, $5c                                     ; $4951
    call AnimEd_PutGridTile                       ; $4953

jr_003_4956:
    ld a, c                                       ; $4956
    ld [wRangeMovingEnd], a                       ; $4957
    ld hl, wRangeAnchor                           ; $495A
    cp [hl]                                       ; $495D
    jr c, jr_003_496a                             ; $495E

    jr z, jr_003_4973                             ; $4960

    ld e, $a8                                     ; $4962
    call AnimEd_PutGridTile                       ; $4964
    xor a                                         ; $4967
    jr jr_003_497a                                ; $4968

jr_003_496a:
    ld e, $a8                                     ; $496A
    call AnimEd_PutGridTile                       ; $496C
    ld a, $01                                     ; $496F
    jr jr_003_497a                                ; $4971

jr_003_4973:
    ld e, $5c                                     ; $4973
    call AnimEd_PutGridTile                       ; $4975
    ld a, $ff                                     ; $4978

jr_003_497a:
    ld hl, wRangeDirection                        ; $497A
    cp [hl]                                       ; $497D
    jr z, jr_003_49a4                             ; $497E

    ld [wRangeDirection], a                       ; $4980
    xor a                                         ; $4983
    ld [wSpriteAnimFrame + $7], a                 ; $4984
    ld [wSpriteAnimTick + $7], a                  ; $4987
    ld a, [wRangeAnchor]                          ; $498A
    inc a                                         ; $498D
    push af                                       ; $498E
    and $0f                                       ; $498F
    sla a                                         ; $4991
    sla a                                         ; $4993
    sla a                                         ; $4995
    add $10                                       ; $4997
    ld [wRangeCursorXy], a                        ; $4999
    pop af                                        ; $499C
    and $f0                                       ; $499D
    add $5f                                       ; $499F
    ld [wRangeCursorXy + $2], a                   ; $49A1

jr_003_49a4:
    ld a, [wRangeMovingEnd]                       ; $49A4
    inc a                                         ; $49A7
    push af                                       ; $49A8
    and $0f                                       ; $49A9
    sla a                                         ; $49AB
    sla a                                         ; $49AD
    sla a                                         ; $49AF
    add $10                                       ; $49B1
    ld [wRangeCursorXy + $1], a                   ; $49B3
    pop af                                        ; $49B6
    and $f0                                       ; $49B7
    add $5e                                       ; $49B9
    ld [wRangeCursorXy + $3], a                   ; $49BB
    ld a, [wRangeMovingEnd]                       ; $49BE
    ld [wCurEntryIndex], a                        ; $49C1
    ld c, a                                       ; $49C4
    ld b, $00                                     ; $49C5
    ld hl, wAnimList                              ; $49C7
    add hl, bc                                    ; $49CA
    ld a, [hl]                                    ; $49CB
    ld [wCurEntryValue], a                        ; $49CC
    call AnimEd_LoadEntryThumb                    ; $49CF
    call AnimEd_ShowEntryValue                    ; $49D2
    call AnimEd_ShowEntryIndex                    ; $49D5
    ret                                           ; $49D8


; C: confirm animation of the range arrows. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_RangeConfirmAnim::
    xor a                                         ; $49D9
    ld [wSpriteAnimFrame + $8], a                 ; $49DA
    ld [wSpriteAnimTick + $8], a                  ; $49DD
    ld a, [wRangeMovingEnd]                       ; $49E0
    inc a                                         ; $49E3
    push af                                       ; $49E4
    and $0f                                       ; $49E5
    sla a                                         ; $49E7
    sla a                                         ; $49E9
    sla a                                         ; $49EB
    add $10                                       ; $49ED
    ld [wRangeCursorXy + $1], a                   ; $49EF
    pop af                                        ; $49F2
    and $f0                                       ; $49F3
    add $5a                                       ; $49F5
    ld [wRangeCursorXy + $3], a                   ; $49F7

jr_003_49fa:
    ld a, [wRangeDirection]                       ; $49FA
    and a                                         ; $49FD
    jr nz, jr_003_4a18                            ; $49FE

    ld de, $0029                                  ; $4A00
    ld c, $00                                     ; $4A03
    call AnimEd_DrawRangeArrow                    ; $4A05
    call AnimEd_StepRangeAnim                     ; $4A08
    ld c, $01                                     ; $4A0B
    ld de, $0000                                  ; $4A0D
    call AnimEd_DrawRangeArrow                    ; $4A10
    call AnimEd_StepRangeAnim                     ; $4A13
    jr jr_003_4a2e                                ; $4A16

jr_003_4a18:
    ld de, $0036                                  ; $4A18
    ld c, $00                                     ; $4A1B
    call AnimEd_DrawRangeArrow                    ; $4A1D
    call AnimEd_StepRangeAnim                     ; $4A20
    ld c, $01                                     ; $4A23
    ld de, $007e                                  ; $4A25
    call AnimEd_DrawRangeArrow                    ; $4A28
    call AnimEd_StepRangeAnim                     ; $4A2B

jr_003_4a2e:
    call AnimEd_DrawEntryCursor                   ; $4A2E
    call Oam_HideUnused                           ; $4A31
    rst Rst08_WaitVBlank                          ; $4A34
    ld a, [wRangeAnimDone + $1]                   ; $4A35
    and a                                         ; $4A38
    jr z, jr_003_49fa                             ; $4A39

    ret                                           ; $4A3B


; C: number of loops 1..50 for the range
Mode12_State0C_LoopCount::
    call AnimEd_DrawLoopCountSprite               ; $4A3C
    ldh a, [hKeysNewRepeat]                       ; $4A3F
    ld b, a                                       ; $4A41
    ld a, [wSpriteAnimTick + $9]                  ; $4A42
    bit 7, b                                      ; $4A45
    jr z, jr_003_4a57                             ; $4A47

    play_sfx1 SFX1_STEP_FAST                      ; $4A49
    cp $02                                        ; $4A50
    jr nz, jr_003_4a56                            ; $4A52

    ld a, $33                                     ; $4A54

jr_003_4a56:
    dec a                                         ; $4A56

jr_003_4a57:
    bit 6, b                                      ; $4A57
    jr z, jr_003_4a69                             ; $4A59

    play_sfx1 SFX1_STEP_FAST                      ; $4A5B
    cp $32                                        ; $4A62
    jr nz, jr_003_4a68                            ; $4A64

    ld a, $01                                     ; $4A66

jr_003_4a68:
    inc a                                         ; $4A68

jr_003_4a69:
    ld [wSpriteAnimTick + $9], a                  ; $4A69
    ldh a, [hKeysHeld]                            ; $4A6C
    and PADF_UP | PADF_DOWN                       ; $4A6E
    jr z, jr_003_4a76                             ; $4A70

    xor a                                         ; $4A72
    ld [wBlinkCounter], a                         ; $4A73

jr_003_4a76:
    ldh a, [hKeysNew]                             ; $4A76
    bit PADB_A, a                                 ; $4A78
    jr z, jr_003_4a89                             ; $4A7A

    play_sfx1 SFX1_OPTION_CHANGE                  ; $4A7C
    set_state STATE_12_LOOP_APPLY                 ; $4A83
    ret                                           ; $4A88


jr_003_4a89:
    bit 1, a                                      ; $4A89
    ret z                                         ; $4A8B

    ld a, [wRangeDirection]                       ; $4A8C
    and a                                         ; $4A8F
    jr nz, jr_003_4a9c                            ; $4A90

    ld a, [wRangeAnchor]                          ; $4A92
    ld b, a                                       ; $4A95
    ld a, [wRangeMovingEnd]                       ; $4A96
    ld c, a                                       ; $4A99
    jr jr_003_4aa4                                ; $4A9A

jr_003_4a9c:
    ld a, [wRangeAnchor]                          ; $4A9C
    ld c, a                                       ; $4A9F
    ld a, [wRangeMovingEnd]                       ; $4AA0
    ld b, a                                       ; $4AA3

jr_003_4aa4:
    ld e, $a7                                     ; $4AA4
    ld a, b                                       ; $4AA6
    call AnimEd_PutGridTile                       ; $4AA7
    inc e                                         ; $4AAA

jr_003_4aab:
    inc b                                         ; $4AAB
    ld a, b                                       ; $4AAC
    cp c                                          ; $4AAD
    jr z, jr_003_4ab5                             ; $4AAE

    call AnimEd_PutGridTile                       ; $4AB0
    jr jr_003_4aab                                ; $4AB3

jr_003_4ab5:
    inc e                                         ; $4AB5
    call AnimEd_PutGridTile                       ; $4AB6
    xor a                                         ; $4AB9
    ld [wSpriteAnimFrame + $8], a                 ; $4ABA
    ld [wSpriteAnimTick + $8], a                  ; $4ABD
    ld a, [wRangeMovingEnd]                       ; $4AC0
    inc a                                         ; $4AC3
    push af                                       ; $4AC4
    and $0f                                       ; $4AC5
    sla a                                         ; $4AC7
    sla a                                         ; $4AC9
    sla a                                         ; $4ACB
    add $10                                       ; $4ACD
    ld [wRangeCursorXy + $1], a                   ; $4ACF
    pop af                                        ; $4AD2
    and $f0                                       ; $4AD3
    add $5e                                       ; $4AD5
    ld [wRangeCursorXy + $3], a                   ; $4AD7
    ld e, $a8                                     ; $4ADA
    ld a, [wRangeMovingEnd]                       ; $4ADC
    call AnimEd_PutGridTile                       ; $4ADF
    set_state STATE_12_RANGE_SELECT               ; $4AE2
    ret                                           ; $4AE7


; C: blinking digits of the loop count. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopCountSprite::
    ld hl, wBlinkCounter                          ; $4AE8
    inc [hl]                                      ; $4AEB
    bit 3, [hl]                                   ; $4AEC
    ret nz                                        ; $4AEE

    ld a, [wSpriteAnimTick + $9]                  ; $4AEF
    ld b, $00                                     ; $4AF2

jr_003_4af4:
    cp $0a                                        ; $4AF4
    jr c, jr_003_4afd                             ; $4AF6

    sub $0a                                       ; $4AF8
    inc b                                         ; $4AFA
    jr jr_003_4af4                                ; $4AFB

jr_003_4afd:
    push af                                       ; $4AFD
    push bc                                       ; $4AFE
    ld a, b                                       ; $4AFF
    ld bc, $1088                                  ; $4B00
    and a                                         ; $4B03
    jr z, jr_003_4b09                             ; $4B04

    ld bc, $0c80                                  ; $4B06

jr_003_4b09:
    ld a, [wRangeAnchor]                          ; $4B09
    ld hl, wRangeMovingEnd                        ; $4B0C
    add [hl]                                      ; $4B0F
    inc a                                         ; $4B10
    inc a                                         ; $4B11
    push af                                       ; $4B12
    and $1f                                       ; $4B13
    sla a                                         ; $4B15
    sla a                                         ; $4B17
    add b                                         ; $4B19
    cp $10                                        ; $4B1A
    jr nc, jr_003_4b22                            ; $4B1C

    ld a, $10                                     ; $4B1E
    jr jr_003_4b26                                ; $4B20

jr_003_4b22:
    cp c                                          ; $4B22
    jr c, jr_003_4b26                             ; $4B23

    ld a, c                                       ; $4B25

jr_003_4b26:
    ld b, a                                       ; $4B26
    pop af                                        ; $4B27
    and $e0                                       ; $4B28
    srl a                                         ; $4B2A
    add $64                                       ; $4B2C
    ld c, a                                       ; $4B2E
    pop af                                        ; $4B2F
    and a                                         ; $4B30
    jr z, jr_003_4b3e                             ; $4B31

    add $7e                                       ; $4B33
    push bc                                       ; $4B35
    call Oam_AddMeta_B01_4000                     ; $4B36
    pop bc                                        ; $4B39
    ld a, b                                       ; $4B3A
    add $08                                       ; $4B3B
    ld b, a                                       ; $4B3D

jr_003_4b3e:
    pop af                                        ; $4B3E
    add $7e                                       ; $4B3F
    call Oam_AddMeta_B01_4000                     ; $4B41
    ret                                           ; $4B44


; C: writes the loop markers into the timing list
Mode12_State0D_LoopApply::
    ld a, [wRangeDirection]                       ; $4B45
    and a                                         ; $4B48
    jr nz, jr_003_4b55                            ; $4B49

    ld a, [wRangeAnchor]                          ; $4B4B
    ld b, a                                       ; $4B4E
    ld a, [wRangeMovingEnd]                       ; $4B4F
    ld c, a                                       ; $4B52
    jr jr_003_4b5d                                ; $4B53

jr_003_4b55:
    ld a, [wRangeAnchor]                          ; $4B55
    ld c, a                                       ; $4B58
    ld a, [wRangeMovingEnd]                       ; $4B59
    ld b, a                                       ; $4B5C

jr_003_4b5d:
    ld de, $05a4                                  ; $4B5D

jr_003_4b60:
    push bc                                       ; $4B60
    push de                                       ; $4B61
    ld a, b                                       ; $4B62
    call AnimEd_PutGridTile                       ; $4B63
    inc e                                         ; $4B66

jr_003_4b67:
    inc b                                         ; $4B67
    ld a, b                                       ; $4B68
    cp c                                          ; $4B69
    jr z, jr_003_4b71                             ; $4B6A

    call AnimEd_PutGridTile                       ; $4B6C
    jr jr_003_4b67                                ; $4B6F

jr_003_4b71:
    inc e                                         ; $4B71
    call AnimEd_PutGridTile                       ; $4B72
    ld bc, $0004                                  ; $4B75
    call Wait_Frames                              ; $4B78
    pop de                                        ; $4B7B
    pop bc                                        ; $4B7C
    ld a, e                                       ; $4B7D
    xor $03                                       ; $4B7E
    ld e, a                                       ; $4B80
    dec d                                         ; $4B81
    jr nz, jr_003_4b60                            ; $4B82

    push bc                                       ; $4B84
    ld a, [wRangeAnchor]                          ; $4B85
    ld c, a                                       ; $4B88
    ld b, $00                                     ; $4B89
    ld hl, wAnimTiming                            ; $4B8B
    add hl, bc                                    ; $4B8E
    ld a, [hl]                                    ; $4B8F
    and a                                         ; $4B90
    jr z, jr_003_4b9a                             ; $4B91

    xor a                                         ; $4B93

jr_003_4b94:
    ld [hl+], a                                   ; $4B94
    bit 6, [hl]                                   ; $4B95
    jr z, jr_003_4b94                             ; $4B97

    ld [hl], a                                    ; $4B99

jr_003_4b9a:
    pop bc                                        ; $4B9A
    ld a, [wSpriteAnimTick + $9]                  ; $4B9B
    set 7, a                                      ; $4B9E
    ld e, a                                       ; $4BA0
    ld a, b                                       ; $4BA1
    call AnimEd_SetTiming                         ; $4BA2
    res 7, e                                      ; $4BA5

jr_003_4ba7:
    inc b                                         ; $4BA7
    ld a, b                                       ; $4BA8
    cp c                                          ; $4BA9
    jr z, jr_003_4bb1                             ; $4BAA

    call AnimEd_SetTiming                         ; $4BAC
    jr jr_003_4ba7                                ; $4BAF

jr_003_4bb1:
    set 6, e                                      ; $4BB1
    call AnimEd_SetTiming                         ; $4BB3
    set_state STATE_12_RANGE_BROWSE               ; $4BB6
    ld hl, wDirtyFlag                             ; $4BBB
    set 0, [hl]                                   ; $4BBE
    ret                                           ; $4BC0


; C: A = entry
AnimEd_SetTiming::
    push bc                                       ; $4BC1
    ld c, a                                       ; $4BC2
    ld b, $00                                     ; $4BC3
    ld hl, wAnimTiming                            ; $4BC5
    add hl, bc                                    ; $4BC8
    ld [hl], e                                    ; $4BC9
    pop bc                                        ; $4BCA
    ret                                           ; $4BCB


; C: removes the loop markers of the range
Mode12_State0E_LoopClear::
    ld a, [wRangeAnchor]                          ; $4BCC
    ld c, a                                       ; $4BCF
    ld b, $00                                     ; $4BD0
    ld hl, wAnimTiming                            ; $4BD2
    add hl, bc                                    ; $4BD5
    ld a, [hl]                                    ; $4BD6
    and a                                         ; $4BD7
    jr z, jr_003_4be1                             ; $4BD8

    xor a                                         ; $4BDA

jr_003_4bdb:
    ld [hl+], a                                   ; $4BDB
    bit 6, [hl]                                   ; $4BDC
    jr z, jr_003_4bdb                             ; $4BDE

    ld [hl], a                                    ; $4BE0

jr_003_4be1:
    set_state STATE_12_RANGE_BROWSE               ; $4BE1
    ld hl, wDirtyFlag                             ; $4BE6
    set 0, [hl]                                   ; $4BE9
    ret                                           ; $4BEB


; C: clears the whole list after the CLEAR dialog
Mode12_State0F_ClearAll::
    call AnimEd_ClearAll                          ; $4BEC
    farcopy Vram_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $4BEF
    call AnimEd_InitEditor                        ; $4BFD
    call AnimEd_DrawFrameSprites                  ; $4C00
    farcopy Vram_CopyFromBank, Gfx_0C_5500_Mode12_State0F_ClearAll, $9500, $0060 ; $4C03
    farcopy Vram_CopyFromBank, Gfx_0C_5100_Mode12_State0F_ClearAll, $9100, $0380 ; $4C11
    farcopy Vram_CopyFromBank, Gfx_0C_48C0_Mode12_State0F_ClearAll, $88c0, $00c0 ; $4C1F
    call AnimEd_StartDecorations                  ; $4C2D
    call AnimEd_DrawTimingMarkers                 ; $4C30
    call AnimEd_LoadEntryThumb                    ; $4C33
    call AnimEd_ShowBorderDigits                  ; $4C36
    call AnimEd_ShowEntryValue                    ; $4C39
    call AnimEd_ShowEntryIndex                    ; $4C3C
    call AnimEd_ShowSpeed                         ; $4C3F
    call AnimEd_ShowLoopFlag                      ; $4C42
    set_state STATE_12_BROWSE                     ; $4C45
    ret                                           ; $4C4A


; C: PACK: reloads the screen and removes the blank entries
Mode12_State10_Pack::
    farcopy Vram_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $4C4B
    call AnimEd_DrawFrameSprites                  ; $4C59
    farcopy Vram_CopyFromBank, Gfx_0C_5500_Mode12_State0F_ClearAll, $9500, $0060 ; $4C5C
    farcopy Vram_CopyFromBank, Gfx_0C_5100_Mode12_State0F_ClearAll, $9100, $0380 ; $4C6A
    farcopy Vram_CopyFromBank, Gfx_0C_48C0_Mode12_State0F_ClearAll, $88c0, $00c0 ; $4C78
    ld hl, wAnimList                              ; $4C86
    ld b, $2f                                     ; $4C89

jr_003_4c8b:
    ld a, [hl]                                    ; $4C8B
    cp $fe                                        ; $4C8C
    jr nz, jr_003_4c92                            ; $4C8E

    inc a                                         ; $4C90
    ld [hl], a                                    ; $4C91

jr_003_4c92:
    inc hl                                        ; $4C92
    dec b                                         ; $4C93
    jr nz, jr_003_4c8b                            ; $4C94

    ld hl, wAnimTiming                            ; $4C96
    ld de, wAnimList                              ; $4C99
    ld b, $2f                                     ; $4C9C

jr_003_4c9e:
    ld a, [hl]                                    ; $4C9E
    and $c0                                       ; $4C9F
    jr z, jr_003_4cac                             ; $4CA1

    ld a, [de]                                    ; $4CA3
    cp $ff                                        ; $4CA4
    jr nz, jr_003_4cbd                            ; $4CA6

    dec a                                         ; $4CA8
    ld [de], a                                    ; $4CA9
    jr jr_003_4cbd                                ; $4CAA

jr_003_4cac:
    ld a, [de]                                    ; $4CAC
    cp $ff                                        ; $4CAD
    jr z, jr_003_4cbb                             ; $4CAF

    ld a, [hl]                                    ; $4CB1
    and $3f                                       ; $4CB2
    jr nz, jr_003_4cbd                            ; $4CB4

    ld a, $ff                                     ; $4CB6
    ld [hl], a                                    ; $4CB8
    jr jr_003_4cbd                                ; $4CB9

jr_003_4cbb:
    xor a                                         ; $4CBB
    ld [hl], a                                    ; $4CBC

jr_003_4cbd:
    inc hl                                        ; $4CBD
    inc de                                        ; $4CBE
    dec b                                         ; $4CBF
    jr nz, jr_003_4c9e                            ; $4CC0

    ld hl, wAnimList                              ; $4CC2
    ld de, wAnimList                              ; $4CC5
    ld b, $2f                                     ; $4CC8

jr_003_4cca:
    ld c, [hl]                                    ; $4CCA
    ld a, $fe                                     ; $4CCB
    ld [hl+], a                                   ; $4CCD
    ld a, c                                       ; $4CCE
    cp $ff                                        ; $4CCF
    jr z, jr_003_4cd5                             ; $4CD1

    ld [de], a                                    ; $4CD3
    inc de                                        ; $4CD4

jr_003_4cd5:
    dec b                                         ; $4CD5
    jr nz, jr_003_4cca                            ; $4CD6

    ld hl, wAnimTiming                            ; $4CD8
    ld de, wAnimTiming                            ; $4CDB
    ld b, $2f                                     ; $4CDE

jr_003_4ce0:
    ld c, [hl]                                    ; $4CE0
    xor a                                         ; $4CE1
    ld [hl+], a                                   ; $4CE2
    ld a, c                                       ; $4CE3
    cp $ff                                        ; $4CE4
    jr nz, jr_003_4ced                            ; $4CE6

    xor a                                         ; $4CE8
    ld [de], a                                    ; $4CE9
    inc de                                        ; $4CEA
    jr jr_003_4cf2                                ; $4CEB

jr_003_4ced:
    and a                                         ; $4CED
    jr z, jr_003_4cf2                             ; $4CEE

    ld [de], a                                    ; $4CF0
    inc de                                        ; $4CF1

jr_003_4cf2:
    dec b                                         ; $4CF2
    jr nz, jr_003_4ce0                            ; $4CF3

    ld a, [wCurEntryIndex]                        ; $4CF5
    ld c, a                                       ; $4CF8
    ld b, $00                                     ; $4CF9
    ld hl, wAnimList                              ; $4CFB
    add hl, bc                                    ; $4CFE
    ld a, [hl]                                    ; $4CFF
    ld [wCurEntryValue], a                        ; $4D00
    call AnimEd_StartDecorations                  ; $4D03
    call AnimEd_DrawTimingMarkers                 ; $4D06
    call AnimEd_LoadEntryThumb                    ; $4D09
    call AnimEd_ShowBorderDigits                  ; $4D0C
    call AnimEd_ShowEntryValue                    ; $4D0F
    call AnimEd_ShowEntryIndex                    ; $4D12
    call AnimEd_ShowSpeed                         ; $4D15
    call AnimEd_ShowLoopFlag                      ; $4D18
    ld hl, wDirtyFlag                             ; $4D1B
    set 0, [hl]                                   ; $4D1E
    set_state STATE_12_BROWSE                     ; $4D20
    ret                                           ; $4D25


; C: TEST: prepares the play variables and fades to the player screen
Mode12_State11_TestStart::
    xor a                                         ; $4D26
    ld [wPlayTick], a                             ; $4D27
    ld [wPlayLoopCount], a                        ; $4D2A
    ld [wPlayDone], a                             ; $4D2D
    ld hl, wAnimList                              ; $4D30
    ld b, $2f                                     ; $4D33

jr_003_4d35:
    ld a, [hl+]                                   ; $4D35
    cp $fe                                        ; $4D36
    jr c, jr_003_4d43                             ; $4D38

    dec b                                         ; $4D3A
    jr nz, jr_003_4d35                            ; $4D3B

    set_state STATE_12_BROWSE                     ; $4D3D
    ret                                           ; $4D42


jr_003_4d43:
    ld [wPlayEntry], a                            ; $4D43
    ld a, $2f                                     ; $4D46
    sub b                                         ; $4D48
    ld [wSpriteAnimTick + $a], a                  ; $4D49
    ld c, a                                       ; $4D4C
    ld b, $00                                     ; $4D4D
    ld hl, wAnimTiming                            ; $4D4F
    add hl, bc                                    ; $4D52
    bit 7, [hl]                                   ; $4D53
    jr z, jr_003_4d62                             ; $4D55

    ld [wPlayLoopStart], a                        ; $4D57
    ld a, $01                                     ; $4D5A
    ld [wPlayLoopCount], a                        ; $4D5C
    xor a                                         ; $4D5F
    jr jr_003_4d64                                ; $4D60

jr_003_4d62:
    ld a, $01                                     ; $4D62

jr_003_4d64:
    ld [wPlayFlags], a                            ; $4D64
    call AnimEd_StartExitTransition               ; $4D67
    screen_off                                    ; $4D6A
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4D70
    ldh [hLcdcShadow], a                          ; $4D72
    ld a, $e4                                     ; $4D74
    ld [wPaletteTarget], a                        ; $4D76
    ld [wPaletteTarget + $1], a                   ; $4D79
    ld [wPaletteTarget + $2], a                   ; $4D7C
    ld a, $10                                     ; $4D7F
    ldh [hScxShadow], a                           ; $4D81
    ldh [hScyShadow], a                           ; $4D83
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $0400 ; $4D85
    ld hl, $8000                                  ; $4D93
    ld bc, $0500                                  ; $4D96
    call Mem_Zero                                 ; $4D99
    ld hl, $8800                                  ; $4D9C
    ld bc, $0100                                  ; $4D9F
    call Mem_Zero                                 ; $4DA2
    ld hl, $9000                                  ; $4DA5
    ld bc, $0800                                  ; $4DA8
    call Mem_Zero                                 ; $4DAB
    ld a, [wAnimBorder]                           ; $4DAE
    ld [wBorderNumber], a                         ; $4DB1
    ldh [hFarcallAArg], a                         ; $4DB4
    farcall Border_LoadMap_LcdOff                 ; $4DB6
    ld a, $54                                     ; $4DBE
    ldh [hLycShadowSplit1], a                     ; $4DC0
    ldh [hSplit1Latch], a                         ; $4DC2
    ld hl, hStatShadow                            ; $4DC4
    set 6, [hl]                                   ; $4DC7
    ld hl, rIE                                    ; $4DC9
    set 1, [hl]                                   ; $4DCC
    ld a, $01                                     ; $4DCE
    ldh [hStatHandlerIndex], a                    ; $4DD0
    screen_on                                     ; $4DD2
    call Pal_FadeIn                               ; $4DDB
    call AnimEd_LoadEntryPhoto                    ; $4DDE
    next_state                                    ; $4DE1
    ret                                           ; $4DE5


; C: TEST: steps the entries at the animation speed
Mode12_State12_TestRun::
    ld a, [wPlayDone]                             ; $4DE6
    and a                                         ; $4DE9
    jr nz, jr_003_4e6a                            ; $4DEA

    ld hl, wPlayTick                              ; $4DEC
    ld a, [wAnimSpeed]                            ; $4DEF
    sub [hl]                                      ; $4DF2
    jr nz, jr_003_4e66                            ; $4DF3

    ld [hl], a                                    ; $4DF5
    ld b, $2f                                     ; $4DF6

jr_003_4df8:
    ld a, [wSpriteAnimTick + $a]                  ; $4DF8
    ld c, a                                       ; $4DFB
    ld b, $00                                     ; $4DFC
    ld hl, wAnimTiming                            ; $4DFE
    add hl, bc                                    ; $4E01
    bit 6, [hl]                                   ; $4E02
    jr z, jr_003_4e1d                             ; $4E04

    ld a, [hl]                                    ; $4E06
    and $3f                                       ; $4E07
    ld hl, wPlayLoopCount                         ; $4E09
    cp [hl]                                       ; $4E0C
    jr z, jr_003_4e15                             ; $4E0D

    inc [hl]                                      ; $4E0F
    ld a, [wPlayLoopStart]                        ; $4E10
    jr jr_003_4e1e                                ; $4E13

jr_003_4e15:
    ld hl, wPlayFlags                             ; $4E15
    set 0, [hl]                                   ; $4E18
    ld a, [wSpriteAnimTick + $a]                  ; $4E1A

jr_003_4e1d:
    inc a                                         ; $4E1D

jr_003_4e1e:
    cp $2f                                        ; $4E1E
    jr nz, jr_003_4e2e                            ; $4E20

    ld a, [wAnimLoopFlag]                         ; $4E22
    and a                                         ; $4E25
    jr nz, jr_003_4e2d                            ; $4E26

    ld hl, wPlayDone                              ; $4E28
    inc [hl]                                      ; $4E2B
    ret                                           ; $4E2C


jr_003_4e2d:
    xor a                                         ; $4E2D

jr_003_4e2e:
    ld [wSpriteAnimTick + $a], a                  ; $4E2E
    ld c, a                                       ; $4E31
    ld b, $00                                     ; $4E32
    ld hl, wAnimTiming                            ; $4E34
    add hl, bc                                    ; $4E37
    bit 7, [hl]                                   ; $4E38
    jr z, jr_003_4e4d                             ; $4E3A

    ld hl, wPlayFlags                             ; $4E3C
    bit 0, [hl]                                   ; $4E3F
    jr z, jr_003_4e4d                             ; $4E41

    res 0, [hl]                                   ; $4E43
    ld [wPlayLoopStart], a                        ; $4E45
    ld a, $01                                     ; $4E48
    ld [wPlayLoopCount], a                        ; $4E4A

jr_003_4e4d:
    ld hl, wAnimList                              ; $4E4D
    add hl, bc                                    ; $4E50
    ld a, [hl]                                    ; $4E51
    ld [wPlayEntry], a                            ; $4E52
    cp $fe                                        ; $4E55
    jr c, jr_003_4e61                             ; $4E57

    dec b                                         ; $4E59
    jr nz, jr_003_4df8                            ; $4E5A

    ld hl, wPlayDone                              ; $4E5C
    inc [hl]                                      ; $4E5F
    ret                                           ; $4E60


jr_003_4e61:
    call AnimEd_LoadEntryPhoto                    ; $4E61
    jr jr_003_4e6a                                ; $4E64

jr_003_4e66:
    ld hl, wPlayTick                              ; $4E66
    inc [hl]                                      ; $4E69

jr_003_4e6a:
    ldh a, [hKeysNewSticky]                       ; $4E6A
    bit PADB_B, a                                 ; $4E6C
    ret z                                         ; $4E6E

    next_state                                    ; $4E6F
    ret                                           ; $4E73


; C: TEST: returns to the editor screen
Mode12_State13_TestEnd::
    screen_off                                    ; $4E74
    stat_irq_off                                  ; $4E7A
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $4E84
    ldh [hLcdcShadow], a                          ; $4E86
    ld a, $e4                                     ; $4E88
    ld [wPaletteTarget], a                        ; $4E8A
    ld [wPaletteTarget + $1], a                   ; $4E8D
    ld a, $d2                                     ; $4E90
    ld [wPaletteTarget + $2], a                   ; $4E92
    xor a                                         ; $4E95
    ldh [hScxShadow], a                           ; $4E96
    ld a, $10                                     ; $4E98
    ldh [hScyShadow], a                           ; $4E9A
    ld a, $95                                     ; $4E9C
    ldh [hWyShadow], a                            ; $4E9E
    ld a, $07                                     ; $4EA0
    ldh [hWxShadow], a                            ; $4EA2
    ld a, $0c                                     ; $4EA4
    ld hl, Gfx_0C_4000_Mode12_State00_Init        ; $4EA6
    ld de, $8000                                  ; $4EA9
    ld bc, $1800                                  ; $4EAC
    call Mem_CopyFromBank                         ; $4EAF
    farcopy Mem_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $4EB2
    screen_on                                     ; $4EC0
    call AnimEd_InitEditor                        ; $4EC9
    call AnimEd_LoadEntryThumb                    ; $4ECC
    call AnimEd_ShowBorderDigits                  ; $4ECF
    call AnimEd_ShowEntryValue                    ; $4ED2
    call AnimEd_ShowEntryIndex                    ; $4ED5
    call AnimEd_ShowSpeed                         ; $4ED8
    call Pal_FadeIn                               ; $4EDB
    call AnimEd_StartDecorations                  ; $4EDE
    call AnimEd_DrawTimingMarkers                 ; $4EE1
    set_state STATE_12_BROWSE                     ; $4EE4
    ret                                           ; $4EE9


; C: SAVE? dialog slides in
Mode12_State14_SaveDialogOpen::
    call Oam_ClearShadow                          ; $4EEA
    farcopy Vram_CopyFromBank, Gfx_0C_6180_Mode12_State14_SaveDialogOpen, $8c00, $03e0 ; $4EED
    farcopy Vram_CopyFromBank, Map_27_7930_Mode12_State14_SaveDialogOpen, $9c00, $0120 ; $4EFB
    xor a                                         ; $4F09
    ld [wSpriteAnimFrame + $b], a                 ; $4F0A
    ld [wSpriteAnimTick + $b], a                  ; $4F0D
    ld de, Mode12_State14_SaveDialogOpen_4F1A     ; $4F10
    call AnimEd_WindowSlideOut                    ; $4F13
    next_state                                    ; $4F16
Mode12_State14_SaveDialogOpen_4F1A:
    ret                                           ; $4F1A


; I: waits for A or B
Mode12_State15_SaveDialogWait::
    ldh a, [hKeysNew]                             ; $4F1B
    and PADF_A | PADF_B                           ; $4F1D
    ld [wAbResult], a                             ; $4F1F
    ret z                                         ; $4F22

    push af                                       ; $4F23
    bit 0, a                                      ; $4F24
    ld a, SFX3_DELETE_DIALOG_FIRST                ; $4F26
    call nz, Snd_Sfx3                             ; $4F28
    pop af                                        ; $4F2B
    push af                                       ; $4F2C
    bit 1, a                                      ; $4F2D
    ld a, SFX3_DELETE_DIALOG_SECOND               ; $4F2F
    call nz, Snd_Sfx3                             ; $4F31
    pop af                                        ; $4F34
    next_state                                    ; $4F35
    ret                                           ; $4F39


; C: A: far call 02:4A07 stores the animation list
Mode12_State16_SaveDialogClose::
    ld de, Mode12_State16_SaveDialogClose_4F71    ; $4F3A
    call AnimEd_WindowSlideIn                     ; $4F3D
    farcopy Vram_CopyFromBank, Gfx_0C_4C60_Mode12_State16_SaveDialogClose, $8c60, $0370 ; $4F40
    farcopy Vram_CopyFromBank, Gfx_0C_4600_Mode12_State16_SaveDialogClose, $8600, $01f0 ; $4F4E
    ld a, [wAbResult]                             ; $4F5C
    bit 0, a                                      ; $4F5F
    jr z, jr_003_4f6d                             ; $4F61

    ldh [hFarcallAArg], a                         ; $4F63
    farcall Settings_StoreAnimTranslated_Far      ; $4F65

jr_003_4f6d:
    next_state                                    ; $4F6D
Mode12_State16_SaveDialogClose_4F71:
    ret                                           ; $4F71


; C: exit dialog slides in
Mode12_State17_ExitDialogOpen::
    call Oam_ClearShadow                          ; $4F72
    farcopy Vram_CopyFromBank, Gfx_0C_6730_Mode12_State17_ExitDialogOpen, $8c00, $0380 ; $4F75
    farcopy Vram_CopyFromBank, Map_27_7270_Mode12_State17_ExitDialogOpen, $9c00, $0120 ; $4F83
    xor a                                         ; $4F91
    ld [wSpriteAnimFrame + $b], a                 ; $4F92
    ld [wSpriteAnimTick + $b], a                  ; $4F95
    ld de, Mode12_State17_ExitDialogOpen_4FA2     ; $4F98
    call AnimEd_WindowSlideOut                    ; $4F9B
    next_state                                    ; $4F9E
Mode12_State17_ExitDialogOpen_4FA2:
    ret                                           ; $4FA2


; I: waits for A or B
Mode12_State18_ExitDialogWait::
    ldh a, [hKeysNew]                             ; $4FA3
    and PADF_A | PADF_B                           ; $4FA5
    ld [wAbResult], a                             ; $4FA7
    ret z                                         ; $4FAA

    push af                                       ; $4FAB
    bit 0, a                                      ; $4FAC
    ld a, SFX3_DELETE_DIALOG_FIRST                ; $4FAE
    call nz, Snd_Sfx3                             ; $4FB0
    pop af                                        ; $4FB3
    push af                                       ; $4FB4
    bit 1, a                                      ; $4FB5
    ld a, SFX3_DELETE_DIALOG_SECOND               ; $4FB7
    call nz, Snd_Sfx3                             ; $4FB9
    pop af                                        ; $4FBC
    next_state                                    ; $4FBD
    ret                                           ; $4FC1


; C: A: leaves the editor (state 05); B: back to browsing
Mode12_State19_ExitDialogClose::
    ld de, Mode12_State19_ExitDialogClose_4FF6    ; $4FC2
    call AnimEd_WindowSlideIn                     ; $4FC5
    farcopy Vram_CopyFromBank, Gfx_0C_4C60_Mode12_State16_SaveDialogClose, $8c60, $0370 ; $4FC8
    farcopy Vram_CopyFromBank, Gfx_0C_4600_Mode12_State16_SaveDialogClose, $8600, $01f0 ; $4FD6
    ld a, [wAbResult]                             ; $4FE4
    bit 0, a                                      ; $4FE7
    jr z, jr_003_4ff1                             ; $4FE9

    set_state STATE_12_EXIT                       ; $4FEB
    ret                                           ; $4FF0


jr_003_4ff1:
    set_state STATE_12_BROWSE                     ; $4FF1
Mode12_State19_ExitDialogClose_4FF6:
    ret                                           ; $4FF6


; C: CLEAR dialog slides in
Mode12_State1A_ClearDialogOpen::
    call Oam_ClearShadow                          ; $4FF7
    farcopy Vram_CopyFromBank, Gfx_0C_6560_Mode12_State1A_ClearDialogOpen, $8c00, $0370 ; $4FFA
    farcopy Vram_CopyFromBank, Map_27_7C90_Mode12_State1A_ClearDialogOpen, $9c00, $0120 ; $5008
    xor a                                         ; $5016
    ld [wSpriteAnimFrame + $c], a                 ; $5017
    ld [wSpriteAnimTick + $c], a                  ; $501A
    ld de, Mode12_State1A_ClearDialogOpen_5027    ; $501D
    call AnimEd_WindowSlideOut                    ; $5020
    next_state                                    ; $5023
Mode12_State1A_ClearDialogOpen_5027:
    ret                                           ; $5027


; C: waits for A or B
Mode12_State1B_ClearDialogWait::
    ldh a, [hKeysNew]                             ; $5028
    and PADF_A | PADF_B                           ; $502A
    ret z                                         ; $502C

    ld [wAbResult], a                             ; $502D
    next_state                                    ; $5030
    ret                                           ; $5034


; C: A: state 0F (clear all)
Mode12_State1C_ClearDialogClose::
    ld de, Mode12_State1C_ClearDialogClose_5069   ; $5035
    call AnimEd_WindowSlideIn                     ; $5038
    farcopy Vram_CopyFromBank, Gfx_0C_4C60_Mode12_State16_SaveDialogClose, $8c60, $0370 ; $503B
    farcopy Vram_CopyFromBank, Gfx_0C_4600_Mode12_State16_SaveDialogClose, $8600, $01f0 ; $5049
    ld a, [wAbResult]                             ; $5057
    bit 0, a                                      ; $505A
    jr z, jr_003_5064                             ; $505C

    set_state STATE_12_CLEAR_ALL                  ; $505E
    ret                                           ; $5063


jr_003_5064:
    set_state STATE_12_BROWSE                     ; $5064
Mode12_State1C_ClearDialogClose_5069:
    ret                                           ; $5069


; C: SORT dialog (CANCEL / Normal / Shuffle) slides in
Mode12_State1D_SortDialogOpen::
    call Oam_ClearShadow                          ; $506A
    farcopy Vram_CopyFromBank, Gfx_0C_6C30_Mode12_State1D_SortDialogOpen, $8c70, $0370 ; $506D
    farcopy Vram_CopyFromBank, Gfx_0C_6FA0_Mode12_State1D_SortDialogOpen, $8570, $0290 ; $507B
    farcopy Vram_CopyFromBank, Map_27_7150_Mode12_State1D_SortDialogOpen, $9c00, $0120 ; $5089
    xor a                                         ; $5097
    ld [wAutofillMode], a                         ; $5098
    ld [wSpriteAnimFrame + $d], a                 ; $509B
    ld [wSpriteAnimTick + $d], a                  ; $509E
    ld de, AnimEd_SortChoiceCursor                ; $50A1
    call AnimEd_WindowSlideOut                    ; $50A4
    next_state                                    ; $50A7
    ret                                           ; $50AB


; C: Left / Right picks the autofill mode
Mode12_State1E_SortDialogWait::
    call AnimEd_SortChoiceMove                    ; $50AC
    call AnimEd_SortChoiceCursor                  ; $50AF
    ret c                                         ; $50B2

    ldh a, [hKeysNew]                             ; $50B3
    and PADF_A | PADF_B                           ; $50B5
    ret z                                         ; $50B7

    push af                                       ; $50B8
    bit 0, a                                      ; $50B9
    ld a, SFX1_KEY_A                              ; $50BB
    call nz, Snd_Sfx1                             ; $50BD
    pop af                                        ; $50C0
    ld [wAbResult], a                             ; $50C1
    next_state                                    ; $50C4
    ret                                           ; $50C8


; C: Left / Right changes autofill_mode 0..2
AnimEd_SortChoiceMove::
    ldh a, [hKeysNew]                             ; $50C9
    ld b, a                                       ; $50CB
    ld a, [wAutofillMode]                         ; $50CC
    bit 5, b                                      ; $50CF
    jr z, jr_003_50d8                             ; $50D1

    and a                                         ; $50D3
    ret z                                         ; $50D4

    dec a                                         ; $50D5
    jr jr_003_50df                                ; $50D6

jr_003_50d8:
    bit 4, b                                      ; $50D8
    ret z                                         ; $50DA

    cp $02                                        ; $50DB
    ret z                                         ; $50DD

    inc a                                         ; $50DE

jr_003_50df:
    ld [wAutofillMode], a                         ; $50DF
    play_sfx1 SFX1_CONFIRM                        ; $50E2
    ret                                           ; $50E9


; C: draws the sort dialog cursor. L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor::
    ld a, [wAutofillMode]                         ; $50EA
    ld hl, wSpriteAnimFrame + $d                  ; $50ED
    cp [hl]                                       ; $50F0
    jr z, jr_003_50f8                             ; $50F1

    ld [hl], a                                    ; $50F3
    xor a                                         ; $50F4
    ld [wSpriteAnimTick + $d], a                  ; $50F5

jr_003_50f8:
    ld a, [wSpriteAnimTick + $d]                  ; $50F8
    cp $06                                        ; $50FB
    jr z, jr_003_511a                             ; $50FD

    inc a                                         ; $50FF
    ld [wSpriteAnimTick + $d], a                  ; $5100
    ldh a, [hWyShadow]                            ; $5103
    add $2b                                       ; $5105
    ld c, a                                       ; $5107
    ld b, $50                                     ; $5108
    ld a, [wSpriteAnimFrame + $d]                 ; $510A
    ld e, a                                       ; $510D
    ld d, $00                                     ; $510E
    ld hl, AnimEd_SortChoiceCursor_Tbl5131        ; $5110
    add hl, de                                    ; $5113
    ld a, [hl]                                    ; $5114
    call Oam_AddMeta_B01_4000                     ; $5115
    scf                                           ; $5118
    ret                                           ; $5119


jr_003_511a:
    ldh a, [hWyShadow]                            ; $511A
    add $2b                                       ; $511C
    ld c, a                                       ; $511E
    ld b, $50                                     ; $511F
    ld a, [wSpriteAnimFrame + $d]                 ; $5121
    ld e, a                                       ; $5124
    ld d, $00                                     ; $5125
    ld hl, AnimEd_SortChoiceCursor_Tbl5134        ; $5127
    add hl, de                                    ; $512A
    ld a, [hl]                                    ; $512B
    call Oam_AddMeta_B01_4000                     ; $512C
    and a                                         ; $512F
    ret                                           ; $5130


; C: auto: 3 bytes, bytes; referenced by AnimEd_SortChoiceCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor_Tbl5131::
    db $9c, $98, $9a

; C: auto: 3 bytes, bytes; referenced by AnimEd_SortChoiceCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor_Tbl5134::
    db $97, $99, $9b

; C: A: fills the list with 0
Mode12_State1F_SortDialogClose::
    ld de, AnimEd_SortChoiceCursor                ; $5137
    call AnimEd_WindowSlideIn                     ; $513A
    farcopy Vram_CopyFromBank, Gfx_0C_4C60_Mode12_State16_SaveDialogClose, $8c60, $0370 ; $513D
    farcopy Vram_CopyFromBank, Gfx_0C_4500_Mode12_State1F_SortDialogClose, $8500, $0300 ; $514B
    ld a, [wAbResult]                             ; $5159
    bit 0, a                                      ; $515C
    jr z, jr_003_51cb                             ; $515E

    ld a, [wAutofillMode]                         ; $5160
    and a                                         ; $5163
    jr z, jr_003_51cb                             ; $5164

    ld a, [wCurEntryIndex]                        ; $5166
    ld c, a                                       ; $5169
    ld b, $00                                     ; $516A
    ld hl, wAnimList                              ; $516C
    add hl, bc                                    ; $516F
    ld a, [wPhotoCount]                           ; $5170
    and a                                         ; $5173
    jr z, jr_003_51cb                             ; $5174

    ld b, a                                       ; $5176
    add c                                         ; $5177
    cp $30                                        ; $5178
    jr c, jr_003_5182                             ; $517A

    sub $2f                                       ; $517C
    cpl                                           ; $517E
    inc a                                         ; $517F
    add b                                         ; $5180
    ld b, a                                       ; $5181

jr_003_5182:
    push bc                                       ; $5182
    xor a                                         ; $5183

jr_003_5184:
    ld [hl+], a                                   ; $5184
    inc a                                         ; $5185
    dec b                                         ; $5186
    jr nz, jr_003_5184                            ; $5187

    pop bc                                        ; $5189
    ld a, [wAutofillMode]                         ; $518A
    cp $02                                        ; $518D
    call z, AnimEd_ShuffleList                    ; $518F
    ld a, [wCurEntryIndex]                        ; $5192
    ld c, a                                       ; $5195
    ld b, $00                                     ; $5196
    ld hl, wAnimList                              ; $5198
    add hl, bc                                    ; $519B
    ld a, [hl]                                    ; $519C
    ld [wCurEntryValue], a                        ; $519D
    farcopy Vram_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $51A0
    call AnimEd_StartDecorations                  ; $51AE
    call AnimEd_DrawTimingMarkers                 ; $51B1
    call AnimEd_LoadEntryThumb                    ; $51B4
    call AnimEd_ShowBorderDigits                  ; $51B7
    call AnimEd_ShowEntryValue                    ; $51BA
    call AnimEd_ShowEntryIndex                    ; $51BD
    call AnimEd_ShowSpeed                         ; $51C0
    call AnimEd_ShowLoopFlag                      ; $51C3
    ld hl, wDirtyFlag                             ; $51C6
    set 0, [hl]                                   ; $51C9

jr_003_51cb:
    set_state STATE_12_BROWSE                     ; $51CB
    ret                                           ; $51D0


; C: 10 random swaps within B entries starting at the cursor
AnimEd_ShuffleList::
    ld a, b                                       ; $51D1
    ldh [hScratchA], a                            ; $51D2
    ld a, [wCurEntryIndex]                        ; $51D4
    ldh [hScratchB], a                            ; $51D7
    ld b, $0a                                     ; $51D9

jr_003_51db:
    push bc                                       ; $51DB
    ldh a, [hScratchA]                            ; $51DC
    call Rng_Scaled                               ; $51DE
    ld e, a                                       ; $51E1
    ldh a, [hScratchB]                            ; $51E2
    add e                                         ; $51E4
    ld e, a                                       ; $51E5
    ld d, $00                                     ; $51E6
    ldh a, [hScratchA]                            ; $51E8
    call Rng_Scaled                               ; $51EA
    ld c, a                                       ; $51ED
    ldh a, [hScratchB]                            ; $51EE
    add c                                         ; $51F0
    ld c, a                                       ; $51F1
    ld b, $00                                     ; $51F2
    ld hl, wAnimList                              ; $51F4
    add hl, de                                    ; $51F7
    ld a, [hl]                                    ; $51F8
    push hl                                       ; $51F9
    ld hl, wAnimList                              ; $51FA
    add hl, bc                                    ; $51FD
    ld c, [hl]                                    ; $51FE
    ld [hl], a                                    ; $51FF
    pop hl                                        ; $5200
    ld [hl], c                                    ; $5201
    pop bc                                        ; $5202
    dec b                                         ; $5203
    jr nz, jr_003_51db                            ; $5204

    ret                                           ; $5206


; C: cursor on the border indicator: A opens the border picker
Mode12_State20_BorderRow::
    call AnimEd_DrawEntryCursor                   ; $5207
    call AnimEd_UpdateSparks                      ; $520A
    call AnimEd_DrawBorderHand                    ; $520D
    ldh a, [hKeysNew]                             ; $5210
    bit PADB_A, a                                 ; $5212
    jr z, jr_003_522b                             ; $5214

    screen_off                                    ; $5216
    ld a, [wAnimBorder]                           ; $521C
    ld [wBorderNumber], a                         ; $521F
    xor a                                         ; $5222
    ld [wSubstate], a                             ; $5223
    next_state                                    ; $5226
    ret                                           ; $522A


jr_003_522b:
    bit 7, a                                      ; $522B
    jr z, jr_003_5251                             ; $522D

    farcopy Vram_CopyFromBank, Gfx_0C_5D70_Mode12_State01_Browse, $8950, $0030 ; $522F
    farcopy Vram_CopyFromBank, Gfx_0C_4920_Mode12_State20_BorderRow, $8920, $0030 ; $523D
    set_state STATE_12_EDIT_SPEED                 ; $524B
    ret                                           ; $5250


jr_003_5251:
    bit 2, a                                      ; $5251
    jr z, jr_003_525b                             ; $5253

    set_state STATE_12_TOOLS_OPEN                 ; $5255
    ret                                           ; $525A


jr_003_525b:
    bit 1, a                                      ; $525B
    ret z                                         ; $525D

    call AnimEd_ClearSparks                       ; $525E
    ld a, [wDirtyFlag]                            ; $5261
    and a                                         ; $5264
    jr nz, jr_003_526d                            ; $5265

    set_state STATE_12_EXIT                       ; $5267
    ret                                           ; $526C


jr_003_526d:
    set_state STATE_12_SAVE_DIALOG_OPEN           ; $526D
    ret                                           ; $5272


; C: animated hand beside the border digits. L3 pass 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawBorderHand::
    ld a, [wSpriteAnimFrame + $4]                 ; $5273
    sla a                                         ; $5276
    ld e, a                                       ; $5278
    ld d, $00                                     ; $5279
    ld hl, AnimEd_DrawBorderHand_Gfx52AA          ; $527B
    add hl, de                                    ; $527E
    ld a, [hl+]                                   ; $527F
    ld bc, $9428                                  ; $5280
    push hl                                       ; $5283
    cp $ff                                        ; $5284
    jr z, jr_003_528b                             ; $5286

    call Oam_AddMeta_B01_4000                     ; $5288

jr_003_528b:
    pop hl                                        ; $528B
    ld a, [wSpriteAnimTick + $4]                  ; $528C
    cp [hl]                                       ; $528F
    jr nz, jr_003_52a2                            ; $5290

    ld a, [wSpriteAnimFrame + $4]                 ; $5292
    inc a                                         ; $5295
    cp $03                                        ; $5296
    jr c, jr_003_529b                             ; $5298

    xor a                                         ; $529A

jr_003_529b:
    ld [wSpriteAnimFrame + $4], a                 ; $529B
    xor a                                         ; $529E
    ld [wSpriteAnimTick + $4], a                  ; $529F

jr_003_52a2:
    ld a, [wSpriteAnimTick + $4]                  ; $52A2
    inc a                                         ; $52A5
    ld [wSpriteAnimTick + $4], a                  ; $52A6
    ret                                           ; $52A9


; C: auto: 8 bytes, tile data; referenced by AnimEd_DrawBorderHand. L3 pass 2026-10-26: read in BGB in 7 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawBorderHand_Gfx52AA::
    db $6e, $04, $6f, $04, $70, $07, $ff, $0a

; C: far call 08:4DF2
Mode12_State21_FarBorderPicker::
    ldh [hFarcallAArg], a                         ; $52B2
    farcall BorderPicker_Far                      ; $52B4
    ret                                           ; $52BC


; C: stores the picked border and rebuilds the editor screen
Mode12_State22_BorderPickerReturn::
    ld a, [wBorderNumber]                         ; $52BD
    ld hl, wAnimBorder                            ; $52C0
    cp [hl]                                       ; $52C3
    jr z, jr_003_52cc                             ; $52C4

    ld [hl], a                                    ; $52C6
    ld hl, wDirtyFlag                             ; $52C7
    set 0, [hl]                                   ; $52CA

jr_003_52cc:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $52CC
    ldh [hLcdcShadow], a                          ; $52CE
    ld a, $e4                                     ; $52D0
    ld [wPaletteTarget], a                        ; $52D2
    ld [wPaletteTarget + $1], a                   ; $52D5
    ld a, $d2                                     ; $52D8
    ld [wPaletteTarget + $2], a                   ; $52DA
    xor a                                         ; $52DD
    ldh [hScxShadow], a                           ; $52DE
    ld a, $10                                     ; $52E0
    ldh [hScyShadow], a                           ; $52E2
    ld a, $95                                     ; $52E4
    ldh [hWyShadow], a                            ; $52E6
    ld a, $07                                     ; $52E8
    ldh [hWxShadow], a                            ; $52EA
    ld a, $0c                                     ; $52EC
    ld hl, Gfx_0C_4000_Mode12_State00_Init        ; $52EE
    ld de, $8000                                  ; $52F1
    ld bc, $1800                                  ; $52F4
    call Mem_CopyFromBank                         ; $52F7
    farcopy Mem_CopyFromBank, Map_22_6B40_Mode12_State00_Init, $9800, $0400 ; $52FA
    farcopy Mem_CopyFromBank, Gfx_0C_5D40_Mode12_State22_BorderPickerReturn, $8920, $0030 ; $5308
    farcopy Mem_CopyFromBank, Gfx_0C_5DA0_Mode12_State01_Browse, $88c0, $0060 ; $5316
    screen_on                                     ; $5324
    call AnimEd_LoadEntryThumb                    ; $532D
    call AnimEd_ShowBorderDigits                  ; $5330
    call AnimEd_ShowEntryValue                    ; $5333
    call AnimEd_ShowEntryIndex                    ; $5336
    call AnimEd_ShowSpeed                         ; $5339
    call AnimEd_LoadMenuTiles                     ; $533C
    call Pal_FadeIn                               ; $533F
    call AnimEd_StartDecorations                  ; $5342
    call AnimEd_DrawTimingMarkers                 ; $5345
    set_state STATE_12_BORDER_ROW                 ; $5348
    ret                                           ; $534D


; C: loads the photo of play_entry into VRAM (far 02:5110)
AnimEd_LoadEntryPhoto::
    ld a, [wPlayEntry]                            ; $534E
    cp $fe                                        ; $5351
    ret nc                                        ; $5353

    bit 7, a                                      ; $5354
    jr z, jr_003_535c                             ; $5356

    res 7, a                                      ; $5358
    add $1e                                       ; $535A

jr_003_535c:
    ldh [hFarcallAArg], a                         ; $535C
    farcall Photo_LoadToVram_Far                  ; $535E
    ret                                           ; $5366


; C: draws the timing / loop markers of the 47 entries on the grid
AnimEd_DrawTimingMarkers::
    ld hl, wAnimTiming                            ; $5367
    ld bc, $002f                                  ; $536A

jr_003_536d:
    ld a, [hl+]                                   ; $536D
    bit 7, a                                      ; $536E
    jr nz, jr_003_537f                            ; $5370

    ld a, b                                       ; $5372
    ld e, $5c                                     ; $5373
    push hl                                       ; $5375
    call AnimEd_PutGridTile                       ; $5376
    pop hl                                        ; $5379
    inc b                                         ; $537A
    dec c                                         ; $537B
    jr nz, jr_003_536d                            ; $537C

    ret                                           ; $537E


jr_003_537f:
    ld a, b                                       ; $537F
    ld e, $a4                                     ; $5380
    push hl                                       ; $5382
    call AnimEd_PutGridTile                       ; $5383
    pop hl                                        ; $5386
    inc b                                         ; $5387
    dec c                                         ; $5388

jr_003_5389:
    ld a, [hl+]                                   ; $5389
    bit 6, a                                      ; $538A
    jr nz, jr_003_539a                            ; $538C

    ld a, b                                       ; $538E
    ld e, $a5                                     ; $538F
    push hl                                       ; $5391
    call AnimEd_PutGridTile                       ; $5392
    pop hl                                        ; $5395
    inc b                                         ; $5396
    dec c                                         ; $5397
    jr jr_003_5389                                ; $5398

jr_003_539a:
    ld a, b                                       ; $539A
    ld e, $a6                                     ; $539B
    push hl                                       ; $539D
    call AnimEd_PutGridTile                       ; $539E
    pop hl                                        ; $53A1
    inc b                                         ; $53A2
    dec c                                         ; $53A3
    jr nz, jr_003_536d                            ; $53A4

    ret                                           ; $53A6


; C: A = entry index
AnimEd_PutGridTile::
    push bc                                       ; $53A7
    inc a                                         ; $53A8
    push af                                       ; $53A9
    and $0f                                       ; $53AA
    ld c, a                                       ; $53AC
    pop af                                        ; $53AD
    and $f0                                       ; $53AE
    sla a                                         ; $53B0
    sla a                                         ; $53B2
    add c                                         ; $53B4
    ld c, a                                       ; $53B5
    ld b, $00                                     ; $53B6
    ld hl, $99e2                                  ; $53B8
    add hl, bc                                    ; $53BB
    ld a, e                                       ; $53BC
    push de                                       ; $53BD
    call Vram_WriteByteSafe                       ; $53BE
    pop de                                        ; $53C1
    pop bc                                        ; $53C2
    ret                                           ; $53C3


; C: animated cursor sprite on the current entry
AnimEd_DrawEntryCursor::
    ld bc, $9404                                  ; $53C4
    ld e, $00                                     ; $53C7
    ld a, [wCurEntryValue]                        ; $53C9
    bit 7, a                                      ; $53CC
    jr nz, jr_003_53d4                            ; $53CE

    ld c, $11                                     ; $53D0
    ld e, $06                                     ; $53D2

jr_003_53d4:
    and $7f                                       ; $53D4
    cp $7e                                        ; $53D6
    jr nc, jr_003_53e1                            ; $53D8

    sla a                                         ; $53DA
    sla a                                         ; $53DC
    add $10                                       ; $53DE
    ld b, a                                       ; $53E0

jr_003_53e1:
    ld a, [wCurEntryIndex]                        ; $53E1
    bit 7, a                                      ; $53E4
    jr nz, jr_003_53ea                            ; $53E6

    ld e, $0c                                     ; $53E8

jr_003_53ea:
    ld a, [wSpriteAnimFrame + $2]                 ; $53EA
    sla a                                         ; $53ED
    add e                                         ; $53EF
    ld e, a                                       ; $53F0
    ld d, $00                                     ; $53F1
    ld hl, AnimEd_DrawEntryCursor_Tbl541B         ; $53F3
    add hl, de                                    ; $53F6
    ld a, [hl+]                                   ; $53F7
    push hl                                       ; $53F8
    call Oam_AddMeta_B01_4000                     ; $53F9
    pop hl                                        ; $53FC
    ld a, [wSpriteAnimTick + $2]                  ; $53FD
    cp [hl]                                       ; $5400
    jr nz, jr_003_5413                            ; $5401

    ld a, [wSpriteAnimFrame + $2]                 ; $5403
    inc a                                         ; $5406
    cp $03                                        ; $5407
    jr nz, jr_003_540c                            ; $5409

    xor a                                         ; $540B

jr_003_540c:
    ld [wSpriteAnimFrame + $2], a                 ; $540C
    xor a                                         ; $540F
    ld [wSpriteAnimTick + $2], a                  ; $5410

jr_003_5413:
    ld a, [wSpriteAnimTick + $2]                  ; $5413
    inc a                                         ; $5416
    ld [wSpriteAnimTick + $2], a                  ; $5417
    ret                                           ; $541A


; C: auto: 18 bytes, bytes; referenced by AnimEd_DrawEntryCursor. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawEntryCursor_Tbl541B::
    db $50, $04, $51, $04, $52, $07, $53, $04, $54, $04, $55, $07, $7a, $04, $7a, $04
    db $7a, $07

; C: animated pointer sprite (position from the table at 5466). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite::
    ld a, [wCurEntryIndex]                        ; $542D
    and $7f                                       ; $5430
    sla a                                         ; $5432
    ld c, a                                       ; $5434
    ld b, $00                                     ; $5435
    ld hl, AnimEd_DrawHandSprite_Tbl5496          ; $5437
    add hl, bc                                    ; $543A
    ld c, [hl]                                    ; $543B
    inc hl                                        ; $543C
    ld b, [hl]                                    ; $543D
    inc hl                                        ; $543E
    ld a, [wCurEntryIndex]                        ; $543F
    cp $0f                                        ; $5442
    jr nc, jr_003_544a                            ; $5444

    ld e, $00                                     ; $5446
    jr jr_003_545c                                ; $5448

jr_003_544a:
    cp $1f                                        ; $544A
    jr nc, jr_003_5452                            ; $544C

    ld e, $06                                     ; $544E
    jr jr_003_545c                                ; $5450

jr_003_5452:
    bit 7, a                                      ; $5452
    jr nz, jr_003_545a                            ; $5454

    ld e, $0c                                     ; $5456
    jr jr_003_545c                                ; $5458

jr_003_545a:
    ld e, $12                                     ; $545A

jr_003_545c:
    ld a, [wSpriteAnimFrame + $3]                 ; $545C
    sla a                                         ; $545F
    add e                                         ; $5461
    ld e, a                                       ; $5462
    ld d, $00                                     ; $5463
    ld hl, AnimEd_DrawHandSprite_Tbl54F4          ; $5465
    ld a, [wEditorRangeMode]                      ; $5468
    and a                                         ; $546B
    jr z, jr_003_5471                             ; $546C

    ld hl, AnimEd_DrawHandSprite_Tbl550C          ; $546E

jr_003_5471:
    add hl, de                                    ; $5471
    ld a, [hl+]                                   ; $5472
    push hl                                       ; $5473
    call Oam_AddMeta_B01_4000                     ; $5474
    pop hl                                        ; $5477
    ld a, [wSpriteAnimTick + $3]                  ; $5478
    cp [hl]                                       ; $547B
    jr nz, jr_003_548e                            ; $547C

    ld a, [wSpriteAnimFrame + $3]                 ; $547E
    inc a                                         ; $5481
    cp $03                                        ; $5482
    jr nz, jr_003_5487                            ; $5484

    xor a                                         ; $5486

jr_003_5487:
    ld [wSpriteAnimFrame + $3], a                 ; $5487
    xor a                                         ; $548A
    ld [wSpriteAnimTick + $3], a                  ; $548B

jr_003_548e:
    ld a, [wSpriteAnimTick + $3]                  ; $548E
    inc a                                         ; $5491
    ld [wSpriteAnimTick + $3], a                  ; $5492
    ret                                           ; $5495


; C: auto: 94 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl5496::
    db $60, $18, $60, $20, $60, $28, $60, $30, $60, $38, $60, $40, $60, $48, $60, $50
    db $60, $58, $60, $60, $60, $68, $60, $70, $60, $78, $60, $80, $60, $88, $70, $10
    db $70, $18, $70, $20, $70, $28, $70, $30, $70, $38, $70, $40, $70, $48, $70, $50
    db $70, $58, $70, $60, $70, $68, $70, $70, $70, $78, $70, $80, $70, $88, $80, $10
    db $80, $18, $80, $20, $80, $28, $80, $30, $80, $38, $80, $40, $80, $48, $80, $50
    db $80, $58, $80, $60, $80, $68, $80, $70, $80, $78, $80, $80, $80, $88

; C: auto: 24 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl54F4::
    db $91, $04, $92, $04, $93, $07, $8e, $04, $8f, $04, $90, $07, $94, $04, $95, $04
    db $96, $07, $74, $04, $74, $04, $74, $04

; C: auto: 24 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 19 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl550C::
    db $88, $07, $89, $04, $8a, $04, $60, $07, $61, $04, $62, $04, $8b, $07, $8c, $04
    db $8d, $04, $74, $04, $74, $04, $74, $04

; C: Up / Down changes the photo of the current entry
AnimEd_ChangeEntryValue::
    ldh a, [hKeysNewRepeat]                       ; $5524
    ld b, a                                       ; $5526
    ld a, [wCurEntryValue]                        ; $5527
    bit 7, a                                      ; $552A
    jr nz, jr_003_5533                            ; $552C

    call AnimEd_StepPhotoValue                    ; $552E
    jr jr_003_5536                                ; $5531

jr_003_5533:
    call AnimEd_StepStockValue                    ; $5533

jr_003_5536:
    ld hl, wCurEntryValue                         ; $5536
    cp [hl]                                       ; $5539
    ret z                                         ; $553A

    ld [wCurEntryValue], a                        ; $553B
    call AnimEd_LoadEntryThumb                    ; $553E
    call AnimEd_ShowEntryValue                    ; $5541
    ld a, [wCurEntryIndex]                        ; $5544
    res 7, a                                      ; $5547
    ld c, a                                       ; $5549
    ld b, $00                                     ; $554A
    ld hl, wAnimList                              ; $554C
    add hl, bc                                    ; $554F
    ld a, [wCurEntryValue]                        ; $5550
    ld [hl], a                                    ; $5553
    ret                                           ; $5554


; C: steps through the album photos
AnimEd_StepPhotoValue::
    call AnimEd_ReadStepKeys                      ; $5555
    ld hl, wPhotoCount                            ; $5558
    bit 7, a                                      ; $555B
    jr z, jr_003_5563                             ; $555D

    ld a, [hl]                                    ; $555F
    dec a                                         ; $5560
    jr jr_003_5567                                ; $5561

jr_003_5563:
    cp [hl]                                       ; $5563
    jr c, jr_003_5567                             ; $5564

    xor a                                         ; $5566

jr_003_5567:
    bit 6, b                                      ; $5567
    ret z                                         ; $5569

    play_sfx1 SFX1_STEP_VALUE                     ; $556A
    ld hl, wPhotoCount                            ; $5571
    cp [hl]                                       ; $5574
    jr c, jr_003_5579                             ; $5575

    ld a, [hl]                                    ; $5577
    dec a                                         ; $5578

jr_003_5579:
    set 7, a                                      ; $5579
    ret                                           ; $557B


; C: steps through the stock pictures
AnimEd_StepStockValue::
    inc a                                         ; $557C
    res 7, a                                      ; $557D
    dec a                                         ; $557F
    call AnimEd_ReadStepKeys                      ; $5580
    ld hl, wStockPictureCount                     ; $5583
    cp $fe                                        ; $5586
    jr nz, jr_003_558e                            ; $5588

    ld a, [hl]                                    ; $558A
    dec a                                         ; $558B
    jr jr_003_5593                                ; $558C

jr_003_558e:
    cp [hl]                                       ; $558E
    jr c, jr_003_5593                             ; $558F

    ld a, $ff                                     ; $5591

jr_003_5593:
    set 7, a                                      ; $5593
    ld c, a                                       ; $5595
    ld a, [wPhotoCount]                           ; $5596
    and a                                         ; $5599
    ld a, c                                       ; $559A
    ret z                                         ; $559B

    bit 7, b                                      ; $559C
    ret z                                         ; $559E

    play_sfx1 SFX1_STEP_VALUE                     ; $559F
    res 7, a                                      ; $55A6
    ld hl, wPhotoCount                            ; $55A8
    cp [hl]                                       ; $55AB
    ret c                                         ; $55AC

    ld a, [hl]                                    ; $55AD
    dec a                                         ; $55AE
    ret                                           ; $55AF


; C: Left / Right repeat -> -1 / +1 with a blip. L3 pass 2026-10-26: executed in BGB in 20 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ReadStepKeys::
    bit 5, b                                      ; $55B0
    jr z, jr_003_55bd                             ; $55B2

    dec a                                         ; $55B4
    play_sfx1 SFX1_STEP_FAST                      ; $55B5
    ret                                           ; $55BC


jr_003_55bd:
    bit 4, b                                      ; $55BD
    ret z                                         ; $55BF

    inc a                                         ; $55C0
    play_sfx1 SFX1_STEP_FAST                      ; $55C1
    ret                                           ; $55C8


; C: D-pad moves the entry cursor; carry at the end of the list
AnimEd_MoveEntryCursor::
    ldh a, [hKeysNewRepeat]                       ; $55C9
    ld b, a                                       ; $55CB
    ld a, [wCurEntryIndex]                        ; $55CC
    call AnimEd_CursorLeftRight                   ; $55CF
    bit 7, a                                      ; $55D2
    jr nz, jr_003_55da                            ; $55D4

    cp $2f                                        ; $55D6
    jr nz, jr_003_55de                            ; $55D8

jr_003_55da:
    ld a, $01                                     ; $55DA
    scf                                           ; $55DC
    ret                                           ; $55DD


jr_003_55de:
    call AnimEd_CursorUpDown                      ; $55DE
    bit 7, a                                      ; $55E1
    jr z, jr_003_55e8                             ; $55E3

    xor a                                         ; $55E5
    scf                                           ; $55E6
    ret                                           ; $55E7


jr_003_55e8:
    ld hl, wCurEntryIndex                         ; $55E8
    cp [hl]                                       ; $55EB
    ret z                                         ; $55EC

    ld [hl], a                                    ; $55ED
    call AnimEd_ShowEntryIndex                    ; $55EE
    ld a, [wCurEntryIndex]                        ; $55F1
    ld c, a                                       ; $55F4
    ld b, $00                                     ; $55F5
    ld hl, wAnimList                              ; $55F7
    add hl, bc                                    ; $55FA
    ld a, [hl]                                    ; $55FB
    ld hl, wCurEntryValue                         ; $55FC
    cp [hl]                                       ; $55FF
    ret z                                         ; $5600

    ld [hl], a                                    ; $5601
    call AnimEd_LoadEntryThumb                    ; $5602
    call AnimEd_ShowEntryValue                    ; $5605
    and a                                         ; $5608
    ret                                           ; $5609


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CursorLeftRight::
    bit 5, b                                      ; $560A
    jr z, jr_003_5617                             ; $560C

    dec a                                         ; $560E
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $560F
    ret                                           ; $5616


jr_003_5617:
    bit 4, b                                      ; $5617
    ret z                                         ; $5619

    inc a                                         ; $561A
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $561B
    ret                                           ; $5622


; C: moves by 16 entries (one row). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes
; 12 (tcrf_check/assets/l3_names/)
AnimEd_CursorUpDown::
    bit 6, b                                      ; $5623
    jr z, jr_003_5634                             ; $5625

    cp $0f                                        ; $5627
    ret z                                         ; $5629

    sub $10                                       ; $562A
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $562C
    ret                                           ; $5633


jr_003_5634:
    bit 7, b                                      ; $5634
    ret z                                         ; $5636

    cp $1f                                        ; $5637
    ret nc                                        ; $5639

    add $10                                       ; $563A
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $563C
    ret                                           ; $5643


; I: sets the three decoration contexts (5691 / 57BE / 5847)
AnimEd_StartDecorations::
    xor a                                         ; $5644
    ld [wSpriteAnimTick], a                       ; $5645
    ld [wSpriteAnimTick + $1], a                  ; $5648
    ld a, $02                                     ; $564B
    ld [wSpriteAnimFrame], a                      ; $564D
    ld [wSpriteAnimFrame + $1], a                 ; $5650
    ld a, LOW(AnimEd_Ctx0_Decor)                  ; $5653
    ld [wCtx0Ret], a                              ; $5655
    ld a, HIGH(AnimEd_Ctx0_Decor)                 ; $5658
    ld [wCtx0Ret + $1], a                         ; $565A
    ld a, LOW(AnimEd_Ctx1_Decor)                  ; $565D
    ld [wCtx1Ret], a                              ; $565F
    ld a, HIGH(AnimEd_Ctx1_Decor)                 ; $5662
    ld [wCtx1Ret + $1], a                         ; $5664
    ld a, LOW(AnimEd_Ctx2_Decor)                  ; $5667
    ld [wCtx2Ret], a                              ; $5669
    ld a, HIGH(AnimEd_Ctx2_Decor)                 ; $566C
    ld [wCtx2Ret + $1], a                         ; $566E
    xor a                                         ; $5671
    ld [wCoroIndex], a                            ; $5672
    call AnimEd_Ctx0_Decor                        ; $5675
    ret                                           ; $5678


; C: saves the registers of the running context and resumes the next of three (rst 08 after the third)
AnimEd_CoroYield::
    push af                                       ; $5679
    push bc                                       ; $567A
    push de                                       ; $567B
    push hl                                       ; $567C
    ld a, [wCoroIndex]                            ; $567D
    swap a                                        ; $5680
    ld c, a                                       ; $5682
    ld b, $00                                     ; $5683
    ld hl, wCoroContext                           ; $5685
    add hl, bc                                    ; $5688
    ld b, $05                                     ; $5689

jr_003_568b:
    pop de                                        ; $568B
    ld [hl], e                                    ; $568C
    inc hl                                        ; $568D
    ld [hl], d                                    ; $568E
    inc hl                                        ; $568F
    dec b                                         ; $5690
    jr nz, jr_003_568b                            ; $5691

    ld a, [wCoroIndex]                            ; $5693
    inc a                                         ; $5696
    cp $03                                        ; $5697
    jr nz, jr_003_56a0                            ; $5699

    call Oam_HideUnused                           ; $569B
    rst Rst08_WaitVBlank                          ; $569E
    xor a                                         ; $569F

jr_003_56a0:
    ld [wCoroIndex], a                            ; $56A0
    swap a                                        ; $56A3
    ld c, a                                       ; $56A5
    ld b, $00                                     ; $56A6
    ld hl, wCtx0Pad                               ; $56A8
    add hl, bc                                    ; $56AB
    ld b, $05                                     ; $56AC

jr_003_56ae:
    dec hl                                        ; $56AE
    ld d, [hl]                                    ; $56AF
    dec hl                                        ; $56B0
    ld e, [hl]                                    ; $56B1
    push de                                       ; $56B2
    dec b                                         ; $56B3
    jr nz, jr_003_56ae                            ; $56B4

    pop hl                                        ; $56B6
    pop de                                        ; $56B7
    pop bc                                        ; $56B8
    pop af                                        ; $56B9
    ret                                           ; $56BA


; I: 3 words 5691 / 57BE / 5847 = entry points of AnimEd_Ctx0/1/2_Decor, the same values AnimEd_StartDecorations
; stores through split immediates; no reader of the table (read in forced runs only)
AnimEd_Decor_CtxEntryTbl::
    dw AnimEd_Ctx0_Decor
    dw AnimEd_Ctx1_Decor
    dw AnimEd_Ctx2_Decor

; C: context 0: draws the tool bar tiles. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx0_Decor::
    ld a, [wAnimLoopFlag]                         ; $56C1
    and a                                         ; $56C4
    jr z, jr_003_56e3                             ; $56C5

    farcopy Vram_CopyFromBank, Gfx_0C_5CA0_AnimEd_Ctx0_Decor, $97c0, $0020 ; $56C7
    farcopy Vram_CopyFromBank, Gfx_0C_5CC0_AnimEd_Ctx0_Decor, $9770, $0010 ; $56D5

jr_003_56e3:
    ld hl, $9a53                                  ; $56E3
    ld de, AnimEd_Ctx0_Decor_Map57D6              ; $56E6
    ld bc, wAnimList + $2e                        ; $56E9
    ld a, $03                                     ; $56EC

; C: row loop top (3 rows) of the decor strip drawn by context 0: two map cells per row from the table at DE, then 16
; columns with a sprite sweep (branch target; code read 2026-10-19)
AnimEd_Ctx0_Decor_RowLoop::
    push af                                       ; $56EE
    swap a                                        ; $56EF
    add $48                                       ; $56F1
    ld [wSprYTmp], a                              ; $56F3
    ld a, $02                                     ; $56F6

jr_003_56f8:
    push af                                       ; $56F8
    ld a, [de]                                    ; $56F9
    call Vram_WriteByteSafe                       ; $56FA
    set 5, l                                      ; $56FD
    inc de                                        ; $56FF
    ld a, [de]                                    ; $5700
    call Vram_WriteByteSafe                       ; $5701
    inc de                                        ; $5704
    res 5, l                                      ; $5705
    dec l                                         ; $5707
    pop af                                        ; $5708
    dec a                                         ; $5709
    jr nz, jr_003_56f8                            ; $570A

    push de                                       ; $570C
    ld a, $10                                     ; $570D

jr_003_570f:
    push af                                       ; $570F
    sla a                                         ; $5710
    sla a                                         ; $5712
    sla a                                         ; $5714
    add $f8                                       ; $5716
    ld [wSprXTmp], a                              ; $5718
    ld a, [bc]                                    ; $571B
    cp $fe                                        ; $571C
    jr nc, jr_003_5724                            ; $571E

    ld a, $85                                     ; $5720
    jr jr_003_5726                                ; $5722

jr_003_5724:
    ld a, $7e                                     ; $5724

jr_003_5726:
    call Vram_WriteByteSafe                       ; $5726
    set 5, l                                      ; $5729
    ld a, $5c                                     ; $572B
    call Vram_WriteByteSafe                       ; $572D
    res 5, l                                      ; $5730
    push bc                                       ; $5732
    ld a, [wSprXTmp]                              ; $5733
    and $10                                       ; $5736
    swap a                                        ; $5738
    add $77                                       ; $573A
    push af                                       ; $573C
    ld a, [wSprXTmp]                              ; $573D
    ld b, a                                       ; $5740
    ld a, [wSprYTmp]                              ; $5741
    ld c, a                                       ; $5744
    pop af                                        ; $5745
    call Oam_AddMeta_B01_4000                     ; $5746
    pop bc                                        ; $5749
    call AnimEd_CoroYield                         ; $574A
    dec bc                                        ; $574D
    dec l                                         ; $574E
    pop af                                        ; $574F
    dec a                                         ; $5750
    jr nz, jr_003_570f                            ; $5751

    pop de                                        ; $5753
    ld a, $02                                     ; $5754

jr_003_5756:
    push af                                       ; $5756
    ld a, [de]                                    ; $5757
    call Vram_WriteByteSafe                       ; $5758
    set 5, l                                      ; $575B
    inc de                                        ; $575D
    ld a, [de]                                    ; $575E
    call Vram_WriteByteSafe                       ; $575F
    inc de                                        ; $5762
    res 5, l                                      ; $5763
    dec l                                         ; $5765
    pop af                                        ; $5766
    dec a                                         ; $5767
    jr nz, jr_003_5756                            ; $5768

    inc l                                         ; $576A
    ld a, l                                       ; $576B
    sub $2d                                       ; $576C
    ld l, a                                       ; $576E
    jr nc, jr_003_5772                            ; $576F

    dec h                                         ; $5771

jr_003_5772:
    pop af                                        ; $5772
    dec a                                         ; $5773
    jp nz, AnimEd_Ctx0_Decor_RowLoop              ; $5774

    ld a, $67                                     ; $5777
    ld hl, $9980                                  ; $5779
    call Vram_WriteByteSafe                       ; $577C
    ld a, $68                                     ; $577F
    ld hl, $9981                                  ; $5781
    call Vram_WriteByteSafe                       ; $5784
    ld a, $72                                     ; $5787
    ld hl, $99a0                                  ; $5789
    call Vram_WriteByteSafe                       ; $578C
    ld a, $73                                     ; $578F
    ld hl, $99a1                                  ; $5791
    call Vram_WriteByteSafe                       ; $5794
    ld a, $82                                     ; $5797
    ld hl, $99c0                                  ; $5799
    call Vram_WriteByteSafe                       ; $579C
    ld a, $83                                     ; $579F
    ld hl, $99c1                                  ; $57A1
    call Vram_WriteByteSafe                       ; $57A4
    ld a, $84                                     ; $57A7
    ld hl, $99c2                                  ; $57A9
    call Vram_WriteByteSafe                       ; $57AC
    ld a, $59                                     ; $57AF
    ld hl, $99e0                                  ; $57B1
    call Vram_WriteByteSafe                       ; $57B4
    ld a, $5a                                     ; $57B7
    ld hl, $99e1                                  ; $57B9
    call Vram_WriteByteSafe                       ; $57BC
    ld a, $5b                                     ; $57BF
    ld hl, $99e2                                  ; $57C1
    call Vram_WriteByteSafe                       ; $57C4
    farcopy Vram_CopyFromBank, Gfx_0C_6020_AnimEd_Ctx0_Decor, $9500, $0060 ; $57C7
    ret                                           ; $57D5


; C: auto: 24 bytes, tile map; referenced by AnimEd_Ctx0_Decor. L3 pass 2026-10-26: read in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx0_Decor_Map57D6::
    db $77, $7d, $79, $7c, $78, $88, $8a, $fe, $7a, $fe, $79, $86, $78, $88, $8a, $fe
    db $7a, $fe, $79, $86, $78, $88, $fe, $fe

; C: context 1: border animation (sprites and tiles). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_Decor::
    ld bc, $1e0a                                  ; $57EE

jr_003_57f1:
    call AnimEd_Ctx1_BorderSprite                 ; $57F1
    call AnimEd_CoroYield                         ; $57F4
    dec c                                         ; $57F7
    jr nz, jr_003_57f1                            ; $57F8

    ld hl, $9842                                  ; $57FA
    ld b, $1e                                     ; $57FD

jr_003_57ff:
    ld a, $a0                                     ; $57FF
    call Vram_WriteByteSafe                       ; $5801
    set 5, l                                      ; $5804
    ld a, $a2                                     ; $5806
    call Vram_WriteByteSafe                       ; $5808
    res 5, l                                      ; $580B
    inc hl                                        ; $580D
    ld a, $a1                                     ; $580E
    call Vram_WriteByteSafe                       ; $5810
    set 5, l                                      ; $5813
    ld a, $a3                                     ; $5815
    call Vram_WriteByteSafe                       ; $5817
    res 5, l                                      ; $581A
    dec hl                                        ; $581C
    call AnimEd_Ctx1_BorderSprite                 ; $581D
    call AnimEd_CoroYield                         ; $5820
    dec b                                         ; $5823
    ld a, $4a                                     ; $5824
    call Vram_WriteByteSafe                       ; $5826
    set 5, l                                      ; $5829
    ld a, $4b                                     ; $582B
    call Vram_WriteByteSafe                       ; $582D
    res 5, l                                      ; $5830
    inc hl                                        ; $5832
    ld a, $4c                                     ; $5833
    call Vram_WriteByteSafe                       ; $5835
    set 5, l                                      ; $5838
    ld a, $4d                                     ; $583A
    call Vram_WriteByteSafe                       ; $583C
    res 5, l                                      ; $583F
    call AnimEd_Ctx1_BorderSprite                 ; $5841
    call AnimEd_CoroYield                         ; $5844
    dec b                                         ; $5847
    jr nz, jr_003_57ff                            ; $5848

jr_003_584a:
    ld a, $42                                     ; $584A
    ld bc, $0200                                  ; $584C
    call Oam_AddMeta_B01_4000                     ; $584F
    call AnimEd_CoroYield                         ; $5852
    jr jr_003_584a                                ; $5855

; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_BorderSprite::
    push bc                                       ; $5857
    push hl                                       ; $5858
    ld a, $21                                     ; $5859
    sub b                                         ; $585B
    and $07                                       ; $585C
    ld c, a                                       ; $585E
    ld b, $00                                     ; $585F
    ld hl, AnimEd_Ctx1_BorderSprite_PtrTbl586F    ; $5861
    add hl, bc                                    ; $5864
    ld a, [hl]                                    ; $5865
    ld bc, $0200                                  ; $5866
    call Oam_AddMeta_B01_4000                     ; $5869
    pop hl                                        ; $586C
    pop bc                                        ; $586D
    ret                                           ; $586E


; C: auto: 8 bytes, word table; referenced by AnimEd_Ctx1_BorderSprite. L3 pass 2026-10-26: read in BGB in 22
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_BorderSprite_PtrTbl586F::
    dw $4342
    dw $4544
    dw $4645
    dw $4847

; C: context 2: second border animation. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_Decor::
    ld bc, $1e0a                                  ; $5877

jr_003_587a:
    call AnimEd_Ctx2_BorderSprite                 ; $587A
    call AnimEd_CoroYield                         ; $587D
    dec c                                         ; $5880
    jr nz, jr_003_587a                            ; $5881

    ld hl, $9882                                  ; $5883
    ld b, $1e                                     ; $5886

jr_003_5888:
    ld a, $9c                                     ; $5888
    call Vram_WriteByteSafe                       ; $588A
    set 5, l                                      ; $588D
    ld a, $49                                     ; $588F
    call AnimEd_Ctx2_InRange                      ; $5891
    jr nc, jr_003_5898                            ; $5894

    ld a, $4e                                     ; $5896

jr_003_5898:
    call Vram_WriteByteSafe                       ; $5898
    res 5, l                                      ; $589B
    inc hl                                        ; $589D
    ld a, $9d                                     ; $589E
    call Vram_WriteByteSafe                       ; $58A0
    set 5, l                                      ; $58A3
    ld a, $9e                                     ; $58A5
    call AnimEd_Ctx2_InRange                      ; $58A7
    jr nc, jr_003_58ae                            ; $58AA

    ld a, $9f                                     ; $58AC

jr_003_58ae:
    call Vram_WriteByteSafe                       ; $58AE
    res 5, l                                      ; $58B1
    dec hl                                        ; $58B3
    call AnimEd_Ctx2_BorderSprite                 ; $58B4
    call AnimEd_CoroYield                         ; $58B7
    dec b                                         ; $58BA
    jr z, jr_003_58f1                             ; $58BB

    ld a, $48                                     ; $58BD
    call Vram_WriteByteSafe                       ; $58BF
    set 5, l                                      ; $58C2
    ld a, $49                                     ; $58C4
    call AnimEd_Ctx2_InRange                      ; $58C6
    jr nc, jr_003_58cd                            ; $58C9

    ld a, $4e                                     ; $58CB

jr_003_58cd:
    call Vram_WriteByteSafe                       ; $58CD
    res 5, l                                      ; $58D0
    inc hl                                        ; $58D2
    ld a, $58                                     ; $58D3
    call Vram_WriteByteSafe                       ; $58D5
    set 5, l                                      ; $58D8
    ld a, $49                                     ; $58DA
    call AnimEd_Ctx2_InRange                      ; $58DC
    jr nc, jr_003_58e3                            ; $58DF

    ld a, $4e                                     ; $58E1

jr_003_58e3:
    call Vram_WriteByteSafe                       ; $58E3
    res 5, l                                      ; $58E6
    call AnimEd_Ctx2_BorderSprite                 ; $58E8
    call AnimEd_CoroYield                         ; $58EB
    dec b                                         ; $58EE
    jr nz, jr_003_5888                            ; $58EF

jr_003_58f1:
    ld a, $49                                     ; $58F1
    ld bc, $020d                                  ; $58F3
    call Oam_AddMeta_B01_4000                     ; $58F6
    call AnimEd_CoroYield                         ; $58F9
    jr jr_003_58f1                                ; $58FC

; C: carry if the tile column is within the inner range. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_InRange::
    push af                                       ; $58FE
    ld a, l                                       ; $58FF
    and $1f                                       ; $5900
    cp $03                                        ; $5902
    jr c, jr_003_590d                             ; $5904

    cp $11                                        ; $5906
    jr nc, jr_003_590d                            ; $5908

    pop af                                        ; $590A
    scf                                           ; $590B
    ret                                           ; $590C


jr_003_590d:
    pop af                                        ; $590D
    and a                                         ; $590E
    ret                                           ; $590F


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_BorderSprite::
    push bc                                       ; $5910
    push hl                                       ; $5911
    ld a, $21                                     ; $5912
    sub b                                         ; $5914
    and $07                                       ; $5915
    ld c, a                                       ; $5917
    ld b, $00                                     ; $5918
    ld hl, AnimEd_Ctx2_BorderSprite_PtrTbl5928    ; $591A
    add hl, bc                                    ; $591D
    ld a, [hl]                                    ; $591E
    ld bc, $020d                                  ; $591F
    call Oam_AddMeta_B01_4000                     ; $5922
    pop hl                                        ; $5925
    pop bc                                        ; $5926
    ret                                           ; $5927


; C: auto: 8 bytes, word table; referenced by AnimEd_Ctx2_BorderSprite. L3 pass 2026-10-26: read in BGB in 22
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_BorderSprite_PtrTbl5928::
    dw $4a49
    dw $4c4b
    dw $4d4d
    dw $4f4e

; I: sets the three exit contexts and draws the transition tiles. L3 pass 2026-10-26: executed in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StartExitTransition::
    ld a, $80                                     ; $5930
    ld [wSpriteAnimTick], a                       ; $5932
    ld [wSpriteAnimTick + $1], a                  ; $5935
    xor a                                         ; $5938
    ld [wSpriteAnimFrame], a                      ; $5939
    ld [wSpriteAnimFrame + $1], a                 ; $593C
    ld a, LOW(AnimEd_ExitCtx0)                    ; $593F
    ld [wCtx0Ret], a                              ; $5941
    ld a, HIGH(AnimEd_ExitCtx0)                   ; $5944
    ld [wCtx0Ret + $1], a                         ; $5946
    ld a, LOW(AnimEd_ExitCtx1)                    ; $5949
    ld [wCtx1Ret], a                              ; $594B
    ld a, HIGH(AnimEd_ExitCtx1)                   ; $594E
    ld [wCtx1Ret + $1], a                         ; $5950
    ld a, LOW(AnimEd_ExitCtx2)                    ; $5953
    ld [wCtx2Ret], a                              ; $5955
    ld a, HIGH(AnimEd_ExitCtx2)                   ; $5958
    ld [wCtx2Ret + $1], a                         ; $595A
    xor a                                         ; $595D
    ld [wCoroIndex], a                            ; $595E
    ld a, $77                                     ; $5961
    ld bc, $0058                                  ; $5963
    call Oam_AddMeta_B01_4000                     ; $5966
    ld a, $42                                     ; $5969
    ld bc, $0200                                  ; $596B
    call Oam_AddMeta_B01_4000                     ; $596E
    ld a, $49                                     ; $5971
    ld bc, $020d                                  ; $5973
    call Oam_AddMeta_B01_4000                     ; $5976
    call Oam_HideUnused                           ; $5979
    rst Rst08_WaitVBlank                          ; $597C
    ld a, $60                                     ; $597D
    ld hl, $9980                                  ; $597F
    call Vram_WriteByteSafe                       ; $5982
    ld a, $61                                     ; $5985
    ld hl, $9981                                  ; $5987
    call Vram_WriteByteSafe                       ; $598A
    ld a, $fe                                     ; $598D
    ld hl, $99a0                                  ; $598F
    call Vram_WriteByteSafe                       ; $5992
    ld a, $fe                                     ; $5995
    ld hl, $99a1                                  ; $5997
    call Vram_WriteByteSafe                       ; $599A
    ld a, $fe                                     ; $599D
    ld hl, $99c0                                  ; $599F
    call Vram_WriteByteSafe                       ; $59A2
    ld a, $fe                                     ; $59A5
    ld hl, $99c1                                  ; $59A7
    call Vram_WriteByteSafe                       ; $59AA
    ld a, $fe                                     ; $59AD
    ld hl, $99c2                                  ; $59AF
    call Vram_WriteByteSafe                       ; $59B2
    ld a, $fe                                     ; $59B5
    ld hl, $99e0                                  ; $59B7
    call Vram_WriteByteSafe                       ; $59BA
    ld a, $fe                                     ; $59BD
    ld hl, $99e1                                  ; $59BF
    call Vram_WriteByteSafe                       ; $59C2
    ld a, $fe                                     ; $59C5
    ld hl, $99e2                                  ; $59C7
    call Vram_WriteByteSafe                       ; $59CA
    farcopy Vram_CopyFromBank, Gfx_0C_5500_Mode12_State0F_ClearAll, $9500, $0060 ; $59CD
    call AnimEd_ExitCtx0                          ; $59DB
    ret                                           ; $59DE


; C: same switch as 5649 for the exit contexts. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CoroYield_B::
    push af                                       ; $59DF
    push bc                                       ; $59E0
    push de                                       ; $59E1
    push hl                                       ; $59E2
    ld a, [wCoroIndex]                            ; $59E3
    swap a                                        ; $59E6
    ld c, a                                       ; $59E8
    ld b, $00                                     ; $59E9
    ld hl, wCoroContext                           ; $59EB
    add hl, bc                                    ; $59EE
    ld b, $05                                     ; $59EF

jr_003_59f1:
    pop de                                        ; $59F1
    ld [hl], e                                    ; $59F2
    inc hl                                        ; $59F3
    ld [hl], d                                    ; $59F4
    inc hl                                        ; $59F5
    dec b                                         ; $59F6
    jr nz, jr_003_59f1                            ; $59F7

    ld a, [wCoroIndex]                            ; $59F9
    inc a                                         ; $59FC
    cp $03                                        ; $59FD
    jr nz, jr_003_5a06                            ; $59FF

    call Oam_HideUnused                           ; $5A01
    rst Rst08_WaitVBlank                          ; $5A04
    xor a                                         ; $5A05

jr_003_5a06:
    ld [wCoroIndex], a                            ; $5A06
    swap a                                        ; $5A09
    ld c, a                                       ; $5A0B
    ld b, $00                                     ; $5A0C
    ld hl, wCtx0Pad                               ; $5A0E
    add hl, bc                                    ; $5A11
    ld b, $05                                     ; $5A12

jr_003_5a14:
    dec hl                                        ; $5A14
    ld d, [hl]                                    ; $5A15
    dec hl                                        ; $5A16
    ld e, [hl]                                    ; $5A17
    push de                                       ; $5A18
    dec b                                         ; $5A19
    jr nz, jr_003_5a14                            ; $5A1A

    pop hl                                        ; $5A1C
    pop de                                        ; $5A1D
    pop bc                                        ; $5A1E
    pop af                                        ; $5A1F
    ret                                           ; $5A20


; I: 3 words 59F7 / 5A7A / 5B00 = entry points of AnimEd_ExitCtx0/1/2, the values AnimEd_StartExitTransition stores
; through split immediates; no reader of the table (read in forced runs only)
AnimEd_Exit_CtxEntryTbl::
    dw AnimEd_ExitCtx0
    dw AnimEd_ExitCtx1
    dw AnimEd_ExitCtx2

; C: exit context 0. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx0::
    ld hl, $99c0                                  ; $5A27
    ld a, $03                                     ; $5A2A

; C: row loop top (3 rows) of the exit sweep of context 0: blanks two cells per row ($FE) and sweeps 16 columns with a
; sprite (branch target; code read 2026-10-19)
AnimEd_ExitCtx0_RowLoop::
    push af                                       ; $5A2C
    cpl                                           ; $5A2D
    add $05                                       ; $5A2E
    swap a                                        ; $5A30
    add $48                                       ; $5A32
    ld [wSprYTmp], a                              ; $5A34
    ld a, $02                                     ; $5A37

jr_003_5a39:
    push af                                       ; $5A39
    ld a, $fe                                     ; $5A3A
    call Vram_WriteByteSafe                       ; $5A3C
    set 5, l                                      ; $5A3F
    call Vram_WriteByteSafe                       ; $5A41
    res 5, l                                      ; $5A44
    inc l                                         ; $5A46
    pop af                                        ; $5A47
    dec a                                         ; $5A48
    jr nz, jr_003_5a39                            ; $5A49

    ld a, $10                                     ; $5A4B

jr_003_5a4d:
    push af                                       ; $5A4D
    cpl                                           ; $5A4E
    add $12                                       ; $5A4F
    sla a                                         ; $5A51
    sla a                                         ; $5A53
    sla a                                         ; $5A55
    add $f8                                       ; $5A57
    ld [wSprXTmp], a                              ; $5A59
    push bc                                       ; $5A5C
    ld a, [wSprXTmp]                              ; $5A5D
    and $10                                       ; $5A60
    swap a                                        ; $5A62
    add $77                                       ; $5A64
    push af                                       ; $5A66
    ld a, [wSprXTmp]                              ; $5A67
    ld b, a                                       ; $5A6A
    ld a, [wSprYTmp]                              ; $5A6B
    ld c, a                                       ; $5A6E
    pop af                                        ; $5A6F
    call Oam_AddMeta_B01_4000                     ; $5A70
    pop bc                                        ; $5A73
    call AnimEd_CoroYield_B                       ; $5A74
    ld a, $fe                                     ; $5A77
    call Vram_WriteByteSafe                       ; $5A79
    set 5, l                                      ; $5A7C
    call Vram_WriteByteSafe                       ; $5A7E
    res 5, l                                      ; $5A81
    dec bc                                        ; $5A83
    inc l                                         ; $5A84
    pop af                                        ; $5A85
    dec a                                         ; $5A86
    jr nz, jr_003_5a4d                            ; $5A87

    ld a, $02                                     ; $5A89

jr_003_5a8b:
    push af                                       ; $5A8B
    ld a, $fe                                     ; $5A8C
    call Vram_WriteByteSafe                       ; $5A8E
    set 5, l                                      ; $5A91
    call Vram_WriteByteSafe                       ; $5A93
    res 5, l                                      ; $5A96
    inc l                                         ; $5A98
    pop af                                        ; $5A99
    dec a                                         ; $5A9A
    jr nz, jr_003_5a8b                            ; $5A9B

    ld a, l                                       ; $5A9D
    add $2c                                       ; $5A9E
    ld l, a                                       ; $5AA0
    jr nc, jr_003_5aa4                            ; $5AA1

    inc h                                         ; $5AA3

jr_003_5aa4:
    pop af                                        ; $5AA4
    dec a                                         ; $5AA5
    jp nz, AnimEd_ExitCtx0_RowLoop                ; $5AA6

    ret                                           ; $5AA9


; C: exit context 1. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1::
    ld bc, $1e0f                                  ; $5AAA

jr_003_5aad:
    call AnimEd_ExitCtx1_Sprite                   ; $5AAD
    call AnimEd_CoroYield_B                       ; $5AB0
    dec c                                         ; $5AB3
    jr nz, jr_003_5aad                            ; $5AB4

    ld hl, $9851                                  ; $5AB6
    ld b, $1e                                     ; $5AB9

jr_003_5abb:
    ld a, $a1                                     ; $5ABB
    call Vram_WriteByteSafe                       ; $5ABD
    set 5, l                                      ; $5AC0
    ld a, $a3                                     ; $5AC2
    call Vram_WriteByteSafe                       ; $5AC4
    res 5, l                                      ; $5AC7
    dec hl                                        ; $5AC9
    ld a, $a0                                     ; $5ACA
    call Vram_WriteByteSafe                       ; $5ACC
    set 5, l                                      ; $5ACF
    ld a, $a2                                     ; $5AD1
    call Vram_WriteByteSafe                       ; $5AD3
    res 5, l                                      ; $5AD6
    inc hl                                        ; $5AD8
    dec b                                         ; $5AD9
    call AnimEd_ExitCtx1_Sprite                   ; $5ADA
    call AnimEd_CoroYield_B                       ; $5ADD
    ld a, $fe                                     ; $5AE0
    call Vram_WriteByteSafe                       ; $5AE2
    set 5, l                                      ; $5AE5
    ld a, $fe                                     ; $5AE7
    call Vram_WriteByteSafe                       ; $5AE9
    res 5, l                                      ; $5AEC
    dec hl                                        ; $5AEE
    ld a, $4c                                     ; $5AEF
    call Vram_WriteByteSafe                       ; $5AF1
    set 5, l                                      ; $5AF4
    ld a, $4d                                     ; $5AF6
    call Vram_WriteByteSafe                       ; $5AF8
    res 5, l                                      ; $5AFB
    dec b                                         ; $5AFD
    call AnimEd_ExitCtx1_Sprite                   ; $5AFE
    call AnimEd_CoroYield_B                       ; $5B01
    ld a, b                                       ; $5B04
    and a                                         ; $5B05
    jr nz, jr_003_5abb                            ; $5B06

jr_003_5b08:
    call AnimEd_ExitCtx1_Sprite                   ; $5B08
    call AnimEd_CoroYield_B                       ; $5B0B
    jr jr_003_5b08                                ; $5B0E

; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1_Sprite::
    push bc                                       ; $5B10
    push hl                                       ; $5B11
    ld a, $02                                     ; $5B12
    add b                                         ; $5B14
    and $07                                       ; $5B15
    ld c, a                                       ; $5B17
    ld b, $00                                     ; $5B18
    ld hl, AnimEd_ExitCtx1_Sprite_PtrTbl5B28      ; $5B1A
    add hl, bc                                    ; $5B1D
    ld a, [hl]                                    ; $5B1E
    ld bc, $0200                                  ; $5B1F
    call Oam_AddMeta_B01_4000                     ; $5B22
    pop hl                                        ; $5B25
    pop bc                                        ; $5B26
    ret                                           ; $5B27


; C: auto: 8 bytes, word table; referenced by AnimEd_ExitCtx1_Sprite. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1_Sprite_PtrTbl5B28::
    dw $4342
    dw $4544
    dw $4645
    dw $4847

; C: exit context 2. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2::
    ld bc, $1e0f                                  ; $5B30

jr_003_5b33:
    call AnimEd_ExitCtx2_Sprite                   ; $5B33
    call AnimEd_CoroYield_B                       ; $5B36
    dec c                                         ; $5B39
    jr nz, jr_003_5b33                            ; $5B3A

    ld hl, $9891                                  ; $5B3C
    ld b, $1e                                     ; $5B3F

jr_003_5b41:
    ld a, $9d                                     ; $5B41
    call Vram_WriteByteSafe                       ; $5B43
    set 5, l                                      ; $5B46
    ld a, $9e                                     ; $5B48
    call AnimEd_ExitCtx2_InRange                  ; $5B4A
    jr nc, jr_003_5b51                            ; $5B4D

    ld a, $9f                                     ; $5B4F

jr_003_5b51:
    call Vram_WriteByteSafe                       ; $5B51
    res 5, l                                      ; $5B54
    dec hl                                        ; $5B56
    ld a, $9c                                     ; $5B57
    call Vram_WriteByteSafe                       ; $5B59
    set 5, l                                      ; $5B5C
    ld a, $49                                     ; $5B5E
    call AnimEd_ExitCtx2_InRange                  ; $5B60
    jr nc, jr_003_5b67                            ; $5B63

    ld a, $4e                                     ; $5B65

jr_003_5b67:
    call Vram_WriteByteSafe                       ; $5B67
    res 5, l                                      ; $5B6A
    inc hl                                        ; $5B6C
    dec b                                         ; $5B6D
    call AnimEd_ExitCtx2_Sprite                   ; $5B6E
    call AnimEd_CoroYield_B                       ; $5B71
    ld a, b                                       ; $5B74
    and a                                         ; $5B75
    jr z, jr_003_5bae                             ; $5B76

    ld a, $fe                                     ; $5B78
    call Vram_WriteByteSafe                       ; $5B7A
    set 5, l                                      ; $5B7D
    ld a, $fe                                     ; $5B7F
    call AnimEd_ExitCtx2_InRange                  ; $5B81
    jr nc, jr_003_5b88                            ; $5B84

    ld a, $4f                                     ; $5B86

jr_003_5b88:
    call Vram_WriteByteSafe                       ; $5B88
    res 5, l                                      ; $5B8B
    dec hl                                        ; $5B8D
    ld a, $58                                     ; $5B8E
    call Vram_WriteByteSafe                       ; $5B90
    set 5, l                                      ; $5B93
    ld a, $49                                     ; $5B95
    call AnimEd_ExitCtx2_InRange                  ; $5B97
    jr nc, jr_003_5b9e                            ; $5B9A

    ld a, $4e                                     ; $5B9C

jr_003_5b9e:
    call Vram_WriteByteSafe                       ; $5B9E
    res 5, l                                      ; $5BA1
    dec b                                         ; $5BA3
    call AnimEd_ExitCtx2_Sprite                   ; $5BA4
    call AnimEd_CoroYield_B                       ; $5BA7
    ld a, b                                       ; $5BAA
    and a                                         ; $5BAB
    jr nz, jr_003_5b41                            ; $5BAC

jr_003_5bae:
    call AnimEd_ExitCtx2_Sprite                   ; $5BAE
    call AnimEd_CoroYield_B                       ; $5BB1
    jr jr_003_5bae                                ; $5BB4

; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_InRange::
    push af                                       ; $5BB6
    ld a, l                                       ; $5BB7
    and $1f                                       ; $5BB8
    cp $03                                        ; $5BBA
    jr c, jr_003_5bc5                             ; $5BBC

    cp $11                                        ; $5BBE
    jr nc, jr_003_5bc5                            ; $5BC0

    pop af                                        ; $5BC2
    scf                                           ; $5BC3
    ret                                           ; $5BC4


jr_003_5bc5:
    pop af                                        ; $5BC5
    and a                                         ; $5BC6
    ret                                           ; $5BC7


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_Sprite::
    push bc                                       ; $5BC8
    push hl                                       ; $5BC9
    ld a, $02                                     ; $5BCA
    add b                                         ; $5BCC
    and $07                                       ; $5BCD
    ld c, a                                       ; $5BCF
    ld b, $00                                     ; $5BD0
    ld hl, AnimEd_ExitCtx2_Sprite_PtrTbl5BE0      ; $5BD2
    add hl, bc                                    ; $5BD5
    ld a, [hl]                                    ; $5BD6
    ld bc, $020d                                  ; $5BD7
    call Oam_AddMeta_B01_4000                     ; $5BDA
    pop hl                                        ; $5BDD
    pop bc                                        ; $5BDE
    ret                                           ; $5BDF


; C: auto: 8 bytes, word table; referenced by AnimEd_ExitCtx2_Sprite. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_Sprite_PtrTbl5BE0::
    dw $4a49
    dw $4c4b
    dw $4d4d
    dw $4f4e

; C: two fixed sprites of the editor frame. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawFrameSprites::
    ld a, $49                                     ; $5BE8
    ld bc, $020d                                  ; $5BEA
    call Oam_AddMeta_B01_4000                     ; $5BED
    ld a, $42                                     ; $5BF0
    ld bc, $0200                                  ; $5BF2
    call Oam_AddMeta_B01_4000                     ; $5BF5
    ret                                           ; $5BF8


; C: loads the thumbnail tiles of the current entry (far 02:517B) or the blank picture tiles
AnimEd_LoadEntryThumb::
    xor a                                         ; $5BF9
    ld [wPreviewWait], a                          ; $5BFA
    ld a, [wCurEntryValue]                        ; $5BFD
    cp $fe                                        ; $5C00
    jr nc, jr_003_5c4e                            ; $5C02

    bit 7, a                                      ; $5C04
    jr z, jr_003_5c0c                             ; $5C06

    res 7, a                                      ; $5C08
    add $1e                                       ; $5C0A

jr_003_5c0c:
    ldh [hFarcallAArg], a                         ; $5C0C
    farcall Photo_GetSramAddress_Far              ; $5C0E
    ld hl, $0e00                                  ; $5C16
    add hl, bc                                    ; $5C19
    ld de, $91a0                                  ; $5C1A
    ld b, $03                                     ; $5C1D

jr_003_5c1f:
    push af                                       ; $5C1F
    push bc                                       ; $5C20
    ld bc, $0040                                  ; $5C21
    call Vram_CopyFromBank                        ; $5C24
    ld a, e                                       ; $5C27
    add $40                                       ; $5C28
    ld e, a                                       ; $5C2A
    jr nc, jr_003_5c2e                            ; $5C2B

    inc d                                         ; $5C2D

jr_003_5c2e:
    pop bc                                        ; $5C2E
    pop af                                        ; $5C2F
    dec b                                         ; $5C30
    jr nz, jr_003_5c1f                            ; $5C31

    ld b, $04                                     ; $5C33

jr_003_5c35:
    push af                                       ; $5C35
    push bc                                       ; $5C36
    ld bc, $0008                                  ; $5C37
    call Vram_CopyFromBank                        ; $5C3A
    ld a, e                                       ; $5C3D
    add $08                                       ; $5C3E
    ld e, a                                       ; $5C40
    jr nc, jr_003_5c44                            ; $5C41

    inc d                                         ; $5C43

jr_003_5c44:
    ld bc, $0008                                  ; $5C44
    add hl, bc                                    ; $5C47
    pop bc                                        ; $5C48
    pop af                                        ; $5C49
    dec b                                         ; $5C4A
    jr nz, jr_003_5c35                            ; $5C4B

    ret                                           ; $5C4D


jr_003_5c4e:
    farcopy Vram_CopyFromBank, Gfx_0C_5100_Mode12_State0F_ClearAll, $9100, $0380 ; $5C4E
    ret                                           ; $5C5C


; C: after 5 frames reduces the entry's photo to 64x56 and copies it to VRAM $9100
AnimEd_PreviewTick::
    ld a, [wPreviewWait]                          ; $5C5D
    cp $05                                        ; $5C60
    jr z, jr_003_5c6c                             ; $5C62

    cp $ff                                        ; $5C64
    ret z                                         ; $5C66

    inc a                                         ; $5C67
    ld [wPreviewWait], a                          ; $5C68
    ret                                           ; $5C6B


jr_003_5c6c:
    inc a                                         ; $5C6C
    ld [wPreviewWait], a                          ; $5C6D
    ld a, [wCurEntryValue]                        ; $5C70
    cp $fe                                        ; $5C73
    ret nc                                        ; $5C75

    bit 7, a                                      ; $5C76
    jr z, jr_003_5c7e                             ; $5C78

    res 7, a                                      ; $5C7A
    add $1e                                       ; $5C7C

jr_003_5c7e:
    ldh [hFarcallAArg], a                         ; $5C7E
    farcall Photo_GetSramAddress_Far              ; $5C80
    ld l, a                                       ; $5C88
    push hl                                       ; $5C89
    push bc                                       ; $5C8A
    ld hl, sp+$00                                 ; $5C8B
    ld bc, wPreviewImage                          ; $5C8D
    call Img_ReduceTo64x56                        ; $5C90
    pop bc                                        ; $5C93
    pop hl                                        ; $5C94
    jr nc, jr_003_5ca8                            ; $5C95

    xor a                                         ; $5C97
    ld [wPreviewWait], a                          ; $5C98
    ldh a, [hKeysHeldSticky]                      ; $5C9B
    ldh [hKeysHeld], a                            ; $5C9D
    ldh a, [hKeysNewSticky]                       ; $5C9F
    ldh [hKeysNew], a                             ; $5CA1
    ldh a, [hKeysRepeatSticky]                    ; $5CA3
    ldh [hKeysNewRepeat], a                       ; $5CA5
    ret                                           ; $5CA7


jr_003_5ca8:
    ld a, $00                                     ; $5CA8
    ld hl, wPreviewImage                          ; $5CAA
    ld de, $9100                                  ; $5CAD
    ld bc, $0380                                  ; $5CB0
    call Vram_CopyFromBank                        ; $5CB3
    ret                                           ; $5CB6


; C: two digit tiles of the border number
AnimEd_ShowBorderDigits::
    ld a, [wAnimBorder]                           ; $5CB7
    call AnimEd_SplitDecimal                      ; $5CBA
    push af                                       ; $5CBD
    ld de, $8b20                                  ; $5CBE
    ld a, c                                       ; $5CC1
    call AnimEd_CopyDigitTile                     ; $5CC2
    pop af                                        ; $5CC5
    call AnimEd_CopyDigitTile                     ; $5CC6
    ret                                           ; $5CC9


; C: digits of the current entry value or the empty marker
AnimEd_ShowEntryValue::
    ld a, [wCurEntryValue]                        ; $5CCA
    cp $fe                                        ; $5CCD
    jr c, jr_003_5cfc                             ; $5CCF

    farcopy Vram_CopyFromBank, Gfx_0C_5FA0_AnimEd_ShowEntryValue, $8aa0, $0040 ; $5CD1
    farcopy Vram_CopyFromBank, Gfx_0C_4FF0_AnimEd_ShowEntryValue, $8be0, $0010 ; $5CDF
    farcopy Vram_CopyFromBank, Gfx_0C_4FF0_AnimEd_ShowEntryValue, $8bf0, $0010 ; $5CED
    ret                                           ; $5CFB


jr_003_5cfc:
    call AnimEd_SplitDecimal                      ; $5CFC
    push af                                       ; $5CFF
    ld de, $8aa0                                  ; $5D00
    ld a, c                                       ; $5D03
    call AnimEd_CopyDigitTile                     ; $5D04
    pop af                                        ; $5D07
    call AnimEd_CopyDigitTile                     ; $5D08
    ld a, [wCurEntryValue]                        ; $5D0B
    bit 7, a                                      ; $5D0E
    jr nz, jr_003_5d21                            ; $5D10

    farcopy Vram_CopyFromBank, Gfx_0C_5B40_AnimEd_ShowEntryValue, $8be0, $0020 ; $5D12
    ret                                           ; $5D20


jr_003_5d21:
    farcopy Vram_CopyFromBank, Gfx_0C_5B60_AnimEd_ShowEntryValue, $8be0, $0020 ; $5D21
    ret                                           ; $5D2F


; C: digits of the entry index
AnimEd_ShowEntryIndex::
    ld a, [wCurEntryIndex]                        ; $5D30
    call AnimEd_SplitDecimal                      ; $5D33
    push af                                       ; $5D36
    ld de, $8ae0                                  ; $5D37
    ld a, c                                       ; $5D3A
    call AnimEd_CopyDigitTile                     ; $5D3B
    pop af                                        ; $5D3E
    call AnimEd_CopyDigitTile                     ; $5D3F
    ret                                           ; $5D42


; C: loop on / off indicator tiles
AnimEd_ShowLoopFlag::
    ld a, [wAnimLoopFlag]                         ; $5D43
    and a                                         ; $5D46
    jr nz, jr_003_5d66                            ; $5D47

    farcopy Vram_CopyFromBank, Gfx_0C_5C80_AnimEd_ShowLoopFlag, $97c0, $0020 ; $5D49
    farcopy Vram_CopyFromBank, Gfx_0C_5770_AnimEd_ShowLoopFlag, $9770, $0010 ; $5D57
    ret                                           ; $5D65


jr_003_5d66:
    farcopy Vram_CopyFromBank, Gfx_0C_5CA0_AnimEd_Ctx0_Decor, $97c0, $0020 ; $5D66
    farcopy Vram_CopyFromBank, Gfx_0C_5CC0_AnimEd_Ctx0_Decor, $9770, $0010 ; $5D74
    ret                                           ; $5D82


; C: digits of the animation speed
AnimEd_ShowSpeed::
    ld a, [wAnimSpeed]                            ; $5D83
    cpl                                           ; $5D86
    add $63                                       ; $5D87
    call AnimEd_SplitDecimal                      ; $5D89
    push af                                       ; $5D8C
    ld de, $8b60                                  ; $5D8D
    ld a, c                                       ; $5D90
    call AnimEd_CopyDigitTile                     ; $5D91
    pop af                                        ; $5D94
    call AnimEd_CopyDigitTile                     ; $5D95
    ret                                           ; $5D98


; C: empties the list ($FE)
AnimEd_ClearAll::
    ld hl, wAnimList                              ; $5D99
    ld a, $fe                                     ; $5D9C
    ld b, $2f                                     ; $5D9E

jr_003_5da0:
    ld [hl+], a                                   ; $5DA0
    dec b                                         ; $5DA1
    jr nz, jr_003_5da0                            ; $5DA2

    xor a                                         ; $5DA4
    ld [hl], a                                    ; $5DA5
    ld hl, wAnimTimingGuardLo                     ; $5DA6
    ld a, $ff                                     ; $5DA9
    ld [hl+], a                                   ; $5DAB
    xor a                                         ; $5DAC
    ld b, $2f                                     ; $5DAD

jr_003_5daf:
    ld [hl+], a                                   ; $5DAF
    dec b                                         ; $5DB0
    jr nz, jr_003_5daf                            ; $5DB1

    ld a, $ff                                     ; $5DB3
    ld [hl], a                                    ; $5DB5
    ld a, $09                                     ; $5DB6
    ld [wAnimSpeed], a                            ; $5DB8
    xor a                                         ; $5DBB
    ld [wAnimBorder], a                           ; $5DBC
    ld hl, wDirtyFlag                             ; $5DBF
    inc [hl]                                      ; $5DC2
    ret                                           ; $5DC3


; C: resets the editor variables and loads the first entry
AnimEd_InitEditor::
    xor a                                         ; $5DC4
    ld [wEditorRangeMode], a                      ; $5DC5
    ld [wCurEntryValue], a                        ; $5DC8
    ld [wCurEntryIndex], a                        ; $5DCB
    ld [wSpriteAnimTick + $2], a                  ; $5DCE
    ld [wSpriteAnimFrame + $2], a                 ; $5DD1
    ld [wSpriteAnimTick + $3], a                  ; $5DD4
    ld [wSpriteAnimFrame + $3], a                 ; $5DD7
    ld [wSpriteAnimTick + $5], a                  ; $5DDA
    ld [wSpriteAnimFrame + $5], a                 ; $5DDD
    ld [wPreviewWait], a                          ; $5DE0
    ld hl, wSparkLife                             ; $5DE3
    ld b, $10                                     ; $5DE6

jr_003_5de8:
    ld [hl+], a                                   ; $5DE8
    dec b                                         ; $5DE9
    jr nz, jr_003_5de8                            ; $5DEA

    ld a, [wCurEntryIndex]                        ; $5DEC
    ld c, a                                       ; $5DEF
    ld b, $00                                     ; $5DF0
    ld hl, wAnimList                              ; $5DF2
    add hl, bc                                    ; $5DF5
    ld a, [hl]                                    ; $5DF6
    ld [wCurEntryValue], a                        ; $5DF7
    call AnimEd_LoadMenuTiles                     ; $5DFA
    ret                                           ; $5DFD


; C: tiles for the highlighted tool menu entry. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_LoadMenuTiles::
    ld a, [wEditorMenuOption]                     ; $5DFE
    sla a                                         ; $5E01
    ld c, a                                       ; $5E03
    sla a                                         ; $5E04
    add c                                         ; $5E06
    ld c, a                                       ; $5E07
    ld b, $00                                     ; $5E08
    ld hl, AnimEd_LoadMenuTiles_Tbl5E21           ; $5E0A
    add hl, bc                                    ; $5E0D
    ld c, [hl]                                    ; $5E0E
    inc hl                                        ; $5E0F
    ld b, [hl]                                    ; $5E10
    inc hl                                        ; $5E11
    push bc                                       ; $5E12
    ld e, [hl]                                    ; $5E13
    inc hl                                        ; $5E14
    ld d, [hl]                                    ; $5E15
    inc hl                                        ; $5E16
    ld c, [hl]                                    ; $5E17
    inc hl                                        ; $5E18
    ld b, [hl]                                    ; $5E19
    pop hl                                        ; $5E1A
    ld a, $0c                                     ; $5E1B
    call Vram_CopyFromBank                        ; $5E1D
    ret                                           ; $5E20


; C: 5 records of 6 bytes {src lo, src hi, dst lo, dst hi, len lo, len hi}, bank $0C: 5A40 -> $8D50, 5AC0 -> $8DD0,
; 6100 -> $8E50, 5B80 -> $8ED0, 5C00 -> $8F50, 0x80 bytes each; AnimEd_LoadMenuTiles (03:5DCE) selects the record with
; $D719
AnimEd_LoadMenuTiles_Tbl5E21::
    dw Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1
    db $50, $8d, $80, $00
    dw Gfx_0C_5A40_AnimEd_LoadMenuTiles_Entries0to1 + $80
    db $d0, $8d, $80, $00
    dw Gfx_0C_6020_AnimEd_Ctx0_Decor + $E0
    db $50, $8e, $80, $00
    dw Gfx_0C_5B60_AnimEd_ShowEntryValue + $20
    db $d0, $8e, $80, $00
    dw Gfx_0C_5B60_AnimEd_ShowEntryValue + $A0
    db $50, $8f, $80, $00

; C: zeroes the 16 spark lifetimes
AnimEd_ClearSparks::
    xor a                                         ; $5E3F
    ld hl, wSparkLife                             ; $5E40
    ld b, $10                                     ; $5E43

jr_003_5e45:
    ld [hl+], a                                   ; $5E45
    dec b                                         ; $5E46
    jr nz, jr_003_5e45                            ; $5E47

    ret                                           ; $5E49


; C: starts a spark sprite at the cursor (sound $36)
AnimEd_SpawnSpark::
    play_sfx1 SFX1_PAGE_STEP                      ; $5E4A
    ld a, [wSparkRingIdx]                         ; $5E51
    inc a                                         ; $5E54
    and $0f                                       ; $5E55
    ld [wSparkRingIdx], a                         ; $5E57
    ld e, a                                       ; $5E5A
    ld d, $00                                     ; $5E5B
    ld a, $20                                     ; $5E5D
    ld hl, wSparkLife                             ; $5E5F
    add hl, de                                    ; $5E62
    ld [hl], a                                    ; $5E63
    sla e                                         ; $5E64
    xor a                                         ; $5E66
    ld hl, wSparkX                                ; $5E67
    add hl, de                                    ; $5E6A
    ld [hl], a                                    ; $5E6B
    ld hl, wSparkY                                ; $5E6C
    add hl, de                                    ; $5E6F
    ld [hl], a                                    ; $5E70
    ld hl, wSparkVx                               ; $5E71
    add hl, de                                    ; $5E74
    ld [hl+], a                                   ; $5E75
    ld [hl], a                                    ; $5E76
    ld hl, wSparkVy                               ; $5E77
    add hl, de                                    ; $5E7A
    ld [hl+], a                                   ; $5E7B
    ld [hl], a                                    ; $5E7C
    ld bc, $9404                                  ; $5E7D
    ld a, [wCurEntryValue]                        ; $5E80
    bit 7, a                                      ; $5E83
    jr nz, jr_003_5e89                            ; $5E85

    ld c, $11                                     ; $5E87

jr_003_5e89:
    and $7f                                       ; $5E89
    cp $7e                                        ; $5E8B
    jr nc, jr_003_5e96                            ; $5E8D

    sla a                                         ; $5E8F
    sla a                                         ; $5E91
    add $10                                       ; $5E93
    ld b, a                                       ; $5E95

jr_003_5e96:
    ld hl, wSparkX + $1                           ; $5E96
    add hl, de                                    ; $5E99
    ld [hl], b                                    ; $5E9A
    ld hl, wSparkY + $1                           ; $5E9B
    add hl, de                                    ; $5E9E
    ld [hl], c                                    ; $5E9F
    ld a, [wCurEntryIndex]                        ; $5EA0
    and $7f                                       ; $5EA3
    inc a                                         ; $5EA5
    push af                                       ; $5EA6
    and $0f                                       ; $5EA7
    swap a                                        ; $5EA9
    srl a                                         ; $5EAB
    add $10                                       ; $5EAD
    ld hl, wSparkX + $1                           ; $5EAF
    add hl, de                                    ; $5EB2
    sub [hl]                                      ; $5EB3
    push af                                       ; $5EB4
    ld hl, wSparkVx                               ; $5EB5
    add hl, de                                    ; $5EB8
    pop af                                        ; $5EB9
    rr a                                          ; $5EBA
    rr [hl]                                       ; $5EBC
    sra a                                         ; $5EBE
    rr [hl]                                       ; $5EC0
    sra a                                         ; $5EC2
    rr [hl]                                       ; $5EC4
    sra a                                         ; $5EC6
    rr [hl]                                       ; $5EC8
    sra a                                         ; $5ECA
    rr [hl]                                       ; $5ECC
    inc hl                                        ; $5ECE
    ld [hl], a                                    ; $5ECF
    pop af                                        ; $5ED0
    and $30                                       ; $5ED1
    add $60                                       ; $5ED3
    ld hl, wSparkY + $1                           ; $5ED5
    add hl, de                                    ; $5ED8
    sub [hl]                                      ; $5ED9
    push af                                       ; $5EDA
    ld hl, wSparkVy                               ; $5EDB
    add hl, de                                    ; $5EDE
    pop af                                        ; $5EDF
    rr a                                          ; $5EE0
    rr [hl]                                       ; $5EE2
    sra a                                         ; $5EE4
    rr [hl]                                       ; $5EE6
    sra a                                         ; $5EE8
    rr [hl]                                       ; $5EEA
    sra a                                         ; $5EEC
    rr [hl]                                       ; $5EEE
    sra a                                         ; $5EF0
    rr [hl]                                       ; $5EF2
    inc hl                                        ; $5EF4
    ld [hl], a                                    ; $5EF5
    ret                                           ; $5EF6


; C: moves the sparks
AnimEd_UpdateSparks::
    ld de, $000f                                  ; $5EF7

jr_003_5efa:
    push de                                       ; $5EFA
    call AnimEd_DrawSpark                         ; $5EFB
    pop de                                        ; $5EFE
    dec e                                         ; $5EFF
    bit 7, e                                      ; $5F00
    jr z, jr_003_5efa                             ; $5F02

    ld de, wSparkX                                ; $5F04
    ld hl, wSparkVx                               ; $5F07
    ld b, $20                                     ; $5F0A

jr_003_5f0c:
    ld a, [de]                                    ; $5F0C
    add [hl]                                      ; $5F0D
    ld [de], a                                    ; $5F0E
    inc de                                        ; $5F0F
    inc hl                                        ; $5F10
    ld a, [de]                                    ; $5F11
    adc [hl]                                      ; $5F12
    ld [de], a                                    ; $5F13
    inc de                                        ; $5F14
    inc hl                                        ; $5F15
    dec b                                         ; $5F16
    jr nz, jr_003_5f0c                            ; $5F17

    ret                                           ; $5F19


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpark::
    ld hl, wSparkLife                             ; $5F1A
    add hl, de                                    ; $5F1D
    ld a, [hl]                                    ; $5F1E
    and a                                         ; $5F1F
    ret z                                         ; $5F20

    dec a                                         ; $5F21
    ld [hl], a                                    ; $5F22
    push af                                       ; $5F23
    sla e                                         ; $5F24
    ld hl, wSparkX + $1                           ; $5F26
    add hl, de                                    ; $5F29
    ld b, [hl]                                    ; $5F2A
    ld hl, wSparkY + $1                           ; $5F2B
    add hl, de                                    ; $5F2E
    ld c, [hl]                                    ; $5F2F
    pop af                                        ; $5F30
    push bc                                       ; $5F31
    srl a                                         ; $5F32
    ld e, a                                       ; $5F34
    ld d, $00                                     ; $5F35
    ld hl, AnimEd_DrawSpark_Tbl5F4B               ; $5F37
    add hl, de                                    ; $5F3A
    ld a, c                                       ; $5F3B
    add [hl]                                      ; $5F3C
    ld c, a                                       ; $5F3D
    dec b                                         ; $5F3E
    ld a, $7b                                     ; $5F3F
    call Oam_AddMeta_B01_4000                     ; $5F41
    pop bc                                        ; $5F44
    ld a, $7c                                     ; $5F45
    call Oam_AddMeta_B01_4000                     ; $5F47
    ret                                           ; $5F4A


; C: auto: 16 bytes, bytes; referenced by AnimEd_DrawSpark. L3 pass 2026-10-26: read in BGB in 20 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpark_Tbl5F4B::
    db $00, $fc, $f9, $f6, $f4, $f2, $f1, $f0, $f0, $f1, $f2, $f4, $f6, $f9, $fc, $00

; C: copies a digit glyph from bank 0C to VRAM. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CopyDigitTile::
    swap a                                        ; $5F5B
    ld c, a                                       ; $5F5D
    ld b, $00                                     ; $5F5E
    sla c                                         ; $5F60
    rl b                                          ; $5F62
    ld hl, Src_0C_5E60_AnimEd_CopyDigitTile       ; $5F64
    add hl, bc                                    ; $5F67
    ld a, BANK(Src_0C_5E60_AnimEd_CopyDigitTile)  ; $5F68
    ld bc, $0020                                  ; $5F6A
    call Vram_CopyFromBank                        ; $5F6D
    ret                                           ; $5F70


; C: A+1 -> C = tens
AnimEd_SplitDecimal::
    inc a                                         ; $5F71
    res 7, a                                      ; $5F72
    ld c, $00                                     ; $5F74

jr_003_5f76:
    cp $0a                                        ; $5F76
    ret c                                         ; $5F78

    sub $0a                                       ; $5F79
    inc c                                         ; $5F7B
    jr jr_003_5f76                                ; $5F7C

; C: moves the window up with the table 00:2FE5 and runs the contexts. L3 pass 2026-10-26: executed in BGB in 6
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideIn::
    play_sfx1 SFX1_PANEL_OPEN                     ; $5F7E
    ld hl, Slide_WyDeltaTbl                       ; $5F85
    ld b, $24                                     ; $5F88

jr_003_5f8a:
    push bc                                       ; $5F8A
    push de                                       ; $5F8B
    push hl                                       ; $5F8C
    ldh a, [hWyShadow]                            ; $5F8D
    add [hl]                                      ; $5F8F
    ldh [hWyShadow], a                            ; $5F90
    ld hl, AnimEd_WindowSlideIn_Resume            ; $5F92
    push hl                                       ; $5F95
    ld h, d                                       ; $5F96
    ld l, e                                       ; $5F97
    jp hl                                         ; $5F98


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideIn_Resume::
    call Oam_HideUnused                           ; $5F99
    rst Rst08_WaitVBlank                          ; $5F9C
    pop hl                                        ; $5F9D
    pop de                                        ; $5F9E
    pop bc                                        ; $5F9F
    inc hl                                        ; $5FA0
    dec b                                         ; $5FA1
    jr nz, jr_003_5f8a                            ; $5FA2

    ld h, d                                       ; $5FA4
    ld l, e                                       ; $5FA5
    jp hl                                         ; $5FA6


; C: reverse slide. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideOut::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $5FA7
    ld hl, Slide_WyDeltaTbl                       ; $5FAE
    ld b, $24                                     ; $5FB1

jr_003_5fb3:
    push bc                                       ; $5FB3
    push de                                       ; $5FB4
    push hl                                       ; $5FB5
    ldh a, [hWyShadow]                            ; $5FB6
    sub [hl]                                      ; $5FB8
    ldh [hWyShadow], a                            ; $5FB9
    ld hl, AnimEd_WindowSlideOut_Resume           ; $5FBB
    push hl                                       ; $5FBE
    ld h, d                                       ; $5FBF
    ld l, e                                       ; $5FC0
    jp hl                                         ; $5FC1


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideOut_Resume::
    call Oam_HideUnused                           ; $5FC2
    rst Rst08_WaitVBlank                          ; $5FC5
    pop hl                                        ; $5FC6
    pop de                                        ; $5FC7
    pop bc                                        ; $5FC8
    inc hl                                        ; $5FC9
    dec b                                         ; $5FCA
    jr nz, jr_003_5fb3                            ; $5FCB

    ld h, d                                       ; $5FCD
    ld l, e                                       ; $5FCE
    jp hl                                         ; $5FCF


; C: plays the show
Mode13_AnimationPlayer::
    ld a, [wState]                                ; $5FD0
    rst Rst18_JumpTable                           ; $5FD3

; I: 9 states, rst $18 table of mode $13
Mode13_StateTable::
    dw Mode13_State00_Init
    dw Mode13_State01_MusicSelect
    dw Mode13_State02_Start
    dw Mode13_State03_PlayPrepare
    dw Mode13_State04_PlayRun
    dw Mode13_State05_Exit
    dw Mode13_State06_EndMessageSetup
    dw Mode13_State07_FarResultScreen
    dw Mode13_State08_Restart

; I: loads the player graphics (bank 17)
Mode13_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5FE6
    ldh [hLcdcShadow], a                          ; $5FE8
    ld a, $e4                                     ; $5FEA
    ld [wPaletteTarget], a                        ; $5FEC
    ld [wPaletteTarget + $1], a                   ; $5FEF
    ld [wPaletteTarget + $2], a                   ; $5FF2
    xor a                                         ; $5FF5
    ldh [hScxShadow], a                           ; $5FF6
    ldh [hScyShadow], a                           ; $5FF8
    farcopy Mem_CopyFromBank, Gfx_17_6800_Mode13_State00_Init, $9000, $0800 ; $5FFA
    farcopy Mem_CopyFromBank, Gfx_17_7000_Mode13_State00_Init, $8800, $0800 ; $6008
    farcopy Mem_CopyFromBank, Gfx_17_7800_Mode13_State00_Init, $8000, $0140 ; $6016
    farcopy Mem_CopyFromBank, Map_23_48C0_Mode13_State00_Init, $9800, $0240 ; $6024
    screen_on                                     ; $6032
    ld a, [wPlayerMusic]                          ; $603B
    call Player_ShowMusicNumber                   ; $603E
    ld a, [wPlayerMusic]                          ; $6041
    ld hl, Mode13_State00_Init_Tbl61F0            ; $6044
    call Snd_PlayFromList                         ; $6047
    call Pal_FadeIn                               ; $604A
    ld a, $16                                     ; $604D
    ldh [hKeyRepeatDelay], a                      ; $604F
    ld a, $08                                     ; $6051
    ldh [hKeyRepeatPeriod], a                     ; $6053
    set_state STATE_13_MUSIC_SELECT               ; $6055
    ret                                           ; $605A


; C: Select cycles the music (0..31); the list is 03:61FD, its n-th entry = BGM n (I: the jofamo article calls the 4th
; entry, song $13, 'BGM 04'); only the international ROM requests song $13 outside this screen and the hot-spot picker
; (RUN title, BGB, README 16.27)
Mode13_State01_MusicSelect::
    ld bc, $7668                                  ; $605B
    ld a, $77                                     ; $605E
    call Oam_AddMeta_B02_6F16                     ; $6060
    ldh a, [hKeysNewRepeat]                       ; $6063
    ld b, a                                       ; $6065
    ld a, [wPlayerMusic]                          ; $6066
    bit 6, b                                      ; $6069
    jr z, jr_003_6077                             ; $606B

    play_sfx4 SFX4_MUSIC_SELECT                   ; $606D
    inc a                                         ; $6074
    jr jr_003_6083                                ; $6075

jr_003_6077:
    bit 7, b                                      ; $6077
    jr z, jr_003_6095                             ; $6079

    play_sfx4 SFX4_MUSIC_SELECT                   ; $607B
    dec a                                         ; $6082

jr_003_6083:
    and $1f                                       ; $6083
    ld [wPlayerMusic], a                          ; $6085
    call Player_ShowMusicNumber                   ; $6088
    ld a, [wPlayerMusic]                          ; $608B
    ld hl, Mode13_State00_Init_Tbl61F0            ; $608E
    call Snd_PlayFromList                         ; $6091
    ret                                           ; $6094


jr_003_6095:
    ldh a, [hKeysNew]                             ; $6095
    and PADF_A | PADF_B                           ; $6097
    ret z                                         ; $6099

    ld [wAbResult], a                             ; $609A
    push af                                       ; $609D
    bit 0, a                                      ; $609E
    ld a, SFX1_KEY_A                              ; $60A0
    call nz, Snd_Sfx1                             ; $60A2
    pop af                                        ; $60A5
    push af                                       ; $60A6
    bit 1, a                                      ; $60A7
    ld a, SFX1_KEY_B                              ; $60A9
    call nz, Snd_Sfx1                             ; $60AB
    pop af                                        ; $60AE
    ld a, $0b                                     ; $60AF
    ldh [hKeyRepeatDelay], a                      ; $60B1
    ld a, $04                                     ; $60B3
    ldh [hKeyRepeatPeriod], a                     ; $60B5
    next_state                                    ; $60B7
    ret                                           ; $60BB


; C: two digit tiles of the music number. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Player_ShowMusicNumber::
    inc a                                         ; $60BC
    ld c, $00                                     ; $60BD

jr_003_60bf:
    cp $0a                                        ; $60BF
    jr c, jr_003_60c8                             ; $60C1

    sub $0a                                       ; $60C3
    inc c                                         ; $60C5
    jr jr_003_60bf                                ; $60C6

jr_003_60c8:
    ld de, $8b90                                  ; $60C8
    push af                                       ; $60CB
    ld a, c                                       ; $60CC
    call Player_CopyDigitTile                     ; $60CD
    pop af                                        ; $60D0

; I: copies a digit glyph from bank 17 to VRAM. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Player_CopyDigitTile::
    swap a                                        ; $60D1
    ld c, a                                       ; $60D3
    ld b, $00                                     ; $60D4
    ld hl, Gfx_17_7000_Mode13_State00_Init + $400 ; $60D6
    add hl, bc                                    ; $60D9
    ld a, BANK(Gfx_17_7000_Mode13_State00_Init)   ; $60DA
    ld bc, $0010                                  ; $60DC
    call Vram_CopyFromBank                        ; $60DF
    ret                                           ; $60E2


; I: B returns to the show menu (mode 0B); A shows the start banner and fades out
Mode13_State02_Start::
    ld a, [wAbResult]                             ; $60E3
    bit 0, a                                      ; $60E6
    jr nz, jr_003_60fb                            ; $60E8

    screen_off                                    ; $60EA
    ld a, MODE_SHOW_MENU                          ; $60F0
    ld [wMode], a                                 ; $60F2
    set_state STATE_0B_INIT                       ; $60F5
    ret                                           ; $60FA


jr_003_60fb:
    call Pal_FadeOut                              ; $60FB
    play_music MUSIC_STOP                         ; $60FE
    call Lcd_Off                                  ; $6105
    next_state                                    ; $6108
    ret                                           ; $610C


; C: loads the animation list (far 02:4EE8)
Mode13_State03_PlayPrepare::
    ldh [hFarcallAArg], a                         ; $610D
    farcall Settings_LoadAnimTranslated_Far       ; $610F
    xor a                                         ; $6117
    ld [wPlayTick], a                             ; $6118
    ld [wPlayLoopCount], a                        ; $611B
    ld [wPlayDone], a                             ; $611E
    ld hl, wAnimList                              ; $6121
    ld b, $2f                                     ; $6124

jr_003_6126:
    ld a, [hl+]                                   ; $6126
    cp $fe                                        ; $6127
    jr c, jr_003_6134                             ; $6129

    dec b                                         ; $612B
    jr nz, jr_003_6126                            ; $612C

    set_state STATE_13_END_MESSAGE_SETUP          ; $612E
    ret                                           ; $6133


jr_003_6134:
    ld [wPlayEntry], a                            ; $6134
    ld a, $2f                                     ; $6137
    sub b                                         ; $6139
    ld [wSpriteAnimTick + $a], a                  ; $613A
    ld c, a                                       ; $613D
    ld b, $00                                     ; $613E
    ld hl, wAnimTiming                            ; $6140
    add hl, bc                                    ; $6143
    bit 7, [hl]                                   ; $6144
    jr z, jr_003_6153                             ; $6146

    ld [wPlayLoopStart], a                        ; $6148
    ld a, $01                                     ; $614B
    ld [wPlayLoopCount], a                        ; $614D
    xor a                                         ; $6150
    jr jr_003_6155                                ; $6151

jr_003_6153:
    ld a, $01                                     ; $6153

jr_003_6155:
    ld [wPlayFlags], a                            ; $6155
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6158
    ldh [hLcdcShadow], a                          ; $615A
    ld a, $e4                                     ; $615C
    ld [wPaletteTarget], a                        ; $615E
    ld [wPaletteTarget + $1], a                   ; $6161
    ld [wPaletteTarget + $2], a                   ; $6164
    ld a, $10                                     ; $6167
    ldh [hScxShadow], a                           ; $6169
    ldh [hScyShadow], a                           ; $616B
    xor a                                         ; $616D
    ld [wPlayerPause], a                          ; $616E
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $0400 ; $6171
    ld hl, $8000                                  ; $617F
    ld bc, $0500                                  ; $6182
    ld de, $ffff                                  ; $6185
    call Mem_FillWords                            ; $6188
    ld hl, $8800                                  ; $618B
    ld bc, $0100                                  ; $618E
    ld de, $ffff                                  ; $6191
    call Mem_FillWords                            ; $6194
    ld hl, $9000                                  ; $6197
    ld bc, $0800                                  ; $619A
    ld de, $ffff                                  ; $619D
    call Mem_FillWords                            ; $61A0
    ld a, [wAnimBorder]                           ; $61A3
    ld [wBorderNumber], a                         ; $61A6
    ldh [hFarcallAArg], a                         ; $61A9
    farcall Border_LoadMap_LcdOff                 ; $61AB
    ld a, $54                                     ; $61B3
    ldh [hLycShadowSplit1], a                     ; $61B5
    ldh [hSplit2Line], a                          ; $61B7
    ld hl, hStatShadow                            ; $61B9
    set 6, [hl]                                   ; $61BC
    ld hl, rIE                                    ; $61BE
    set 1, [hl]                                   ; $61C1
    ld a, $01                                     ; $61C3
    ldh [hStatHandlerIndex], a                    ; $61C5
    screen_on                                     ; $61C7
    call Pal_FadeIn                               ; $61D0
    ld bc, $0050                                  ; $61D3
    call Wait_Frames                              ; $61D6
    ld a, [wPlayerMusic]                          ; $61D9
    ld hl, Mode13_State00_Init_Tbl61F0            ; $61DC
    call Snd_PlayFromList                         ; $61DF
    ld bc, $000a                                  ; $61E2
    call Wait_Frames                              ; $61E5
    call AnimEd_LoadEntryPhoto                    ; $61E8
    next_state                                    ; $61EB
    ret                                           ; $61EF


; C: auto: 64 bytes, bytes; referenced by Mode13_State00_Init, Mode13_State01_MusicSelect, Mode13_State03_PlayPrepare.
; L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Mode13_State00_Init_Tbl61F0::
    db MUSIC_SLIDESHOW_TUNE_01, SNDCH_MUSIC  ; #1
    db MUSIC_JINGLE, SNDCH_MUSIC  ; #2
    db MUSIC_SLIDESHOW_TUNE_03, SNDCH_MUSIC  ; #3
    db MUSIC_SLIDESHOW_TUNE_04, SNDCH_MUSIC  ; #4
    db MUSIC_SLIDESHOW_TUNE_05, SNDCH_MUSIC  ; #5
    db MUSIC_SLIDESHOW_PLAY_ALIAS_15, SNDCH_MUSIC  ; #6
    db MUSIC_RUN_RESULT, SNDCH_MUSIC  ; #7
    db MUSIC_SLIDESHOW_TUNE_08, SNDCH_MUSIC  ; #8
    db MUSIC_SLIDESHOW_TUNE_09, SNDCH_MUSIC  ; #9
    db MUSIC_JAMBO_NINTENDO_ALIAS_19, SNDCH_MUSIC  ; #10
    db MUSIC_TIMER_PRINT_OPTIONS_ALIAS_1A, SNDCH_MUSIC  ; #11
    db MUSIC_SLIDESHOW_TUNE_12, SNDCH_MUSIC  ; #12
    db MUSIC_BEETHOVEN_5TH_INTRO, SNDCH_MUSIC  ; #13
    db MUSIC_SLIDESHOW_TUNE_14, SNDCH_MUSIC  ; #14
    db MUSIC_TITLE_ALIAS_1E, SNDCH_MUSIC  ; #15
    db MUSIC_RUN_RACE_SCENE, SNDCH_MUSIC  ; #16
    db MUSIC_LINK_MENU, SNDCH_MUSIC  ; #17
    db MUSIC_SLIDESHOW_INIT, SNDCH_MUSIC  ; #18
    db MUSIC_ANIMATION_EDITOR, SNDCH_MUSIC  ; #19
    db MUSIC_MAIN_MENU, SNDCH_MUSIC  ; #20
    db MUSIC_BALL_BGM_1, SNDCH_MUSIC  ; #21
    db MUSIC_USER_SCREENS, SNDCH_MUSIC  ; #22
    db MUSIC_SLIDESHOW_TUNE_23, SNDCH_MUSIC  ; #23
    db MUSIC_COMPOSE, SNDCH_MUSIC  ; #24
    db MUSIC_COMMENT_EDITOR, SNDCH_MUSIC  ; #25
    db MUSIC_ALBUM_VIEWER, SNDCH_MUSIC  ; #26
    db MUSIC_OWNER_CARD, SNDCH_MUSIC  ; #27
    db MUSIC_RUN_PICK_CHARACTER, SNDCH_MUSIC  ; #28
    db MUSIC_RUN_RESULT_SETUP, SNDCH_MUSIC  ; #29
    db MUSIC_SPACE_FEVER_BOSS, SNDCH_MUSIC  ; #30
    db MUSIC_SLIDESHOW_TUNE_31, SNDCH_MUSIC  ; #31
    db MUSIC_PAINT, SNDCH_MUSIC  ; #32

; C: steps the entries at the animation speed
Mode13_State04_PlayRun::
    ld a, [wPlayDone]                             ; $6230
    and a                                         ; $6233
    jp nz, Mode13_State04_PlayRun_Keys            ; $6234

    ld a, [wPlayerPause]                          ; $6237
    and a                                         ; $623A
    jr nz, Mode13_State04_PlayRun_Keys            ; $623B

    ld hl, wPlayTick                              ; $623D
    ld a, [wAnimSpeed]                            ; $6240
    sub [hl]                                      ; $6243
    jr nz, jr_003_62b7                            ; $6244

    ld [hl], a                                    ; $6246
    ld b, $2f                                     ; $6247

jr_003_6249:
    ld a, [wSpriteAnimTick + $a]                  ; $6249
    ld c, a                                       ; $624C
    ld b, $00                                     ; $624D
    ld hl, wAnimTiming                            ; $624F
    add hl, bc                                    ; $6252
    bit 6, [hl]                                   ; $6253
    jr z, jr_003_626e                             ; $6255

    ld a, [hl]                                    ; $6257
    and $3f                                       ; $6258
    ld hl, wPlayLoopCount                         ; $625A
    cp [hl]                                       ; $625D
    jr z, jr_003_6266                             ; $625E

    inc [hl]                                      ; $6260
    ld a, [wPlayLoopStart]                        ; $6261
    jr jr_003_626f                                ; $6264

jr_003_6266:
    ld hl, wPlayFlags                             ; $6266
    set 0, [hl]                                   ; $6269
    ld a, [wSpriteAnimTick + $a]                  ; $626B

jr_003_626e:
    inc a                                         ; $626E

jr_003_626f:
    cp $2f                                        ; $626F
    jr nz, jr_003_627f                            ; $6271

    ld a, [wAnimLoopFlag]                         ; $6273
    and a                                         ; $6276
    jr nz, jr_003_627e                            ; $6277

    ld hl, wPlayDone                              ; $6279
    inc [hl]                                      ; $627C
    ret                                           ; $627D


jr_003_627e:
    xor a                                         ; $627E

jr_003_627f:
    ld [wSpriteAnimTick + $a], a                  ; $627F
    ld c, a                                       ; $6282
    ld b, $00                                     ; $6283
    ld hl, wAnimTiming                            ; $6285
    add hl, bc                                    ; $6288
    bit 7, [hl]                                   ; $6289
    jr z, jr_003_629e                             ; $628B

    ld hl, wPlayFlags                             ; $628D
    bit 0, [hl]                                   ; $6290
    jr z, jr_003_629e                             ; $6292

    res 0, [hl]                                   ; $6294
    ld [wPlayLoopStart], a                        ; $6296
    ld a, $01                                     ; $6299
    ld [wPlayLoopCount], a                        ; $629B

jr_003_629e:
    ld hl, wAnimList                              ; $629E
    add hl, bc                                    ; $62A1
    ld a, [hl]                                    ; $62A2
    ld [wPlayEntry], a                            ; $62A3
    cp $fe                                        ; $62A6
    jr c, jr_003_62b2                             ; $62A8

    dec b                                         ; $62AA
    jr nz, jr_003_6249                            ; $62AB

    ld hl, wPlayDone                              ; $62AD
    inc [hl]                                      ; $62B0
    ret                                           ; $62B1


jr_003_62b2:
    call AnimEd_LoadEntryPhoto                    ; $62B2
    jr Mode13_State04_PlayRun_Keys                ; $62B5

jr_003_62b7:
    ld hl, wPlayTick                              ; $62B7
    inc [hl]                                      ; $62BA

; C: key poll of the playback: bit 1 of $FFA8 (B) goes to the next state, bit 3 (Start) toggles the pause flag $D7BD
; (branch target; code read 2026-10-19)
Mode13_State04_PlayRun_Keys::
    ldh a, [hKeysNewSticky]                       ; $62BB
    bit PADB_B, a                                 ; $62BD
    jr z, jr_003_62c6                             ; $62BF

    next_state                                    ; $62C1
    ret                                           ; $62C5


jr_003_62c6:
    bit 3, a                                      ; $62C6
    ret z                                         ; $62C8

    ld a, [wPlayerPause]                          ; $62C9
    cpl                                           ; $62CC
    ld [wPlayerPause], a                          ; $62CD
    ret                                           ; $62D0


; C: fades out and returns to state 0
Mode13_State05_Exit::
    screen_off                                    ; $62D1
    stat_irq_off                                  ; $62D7
    set_state STATE_13_INIT                       ; $62E1
    ret                                           ; $62E6


; C: selects result message 6
Mode13_State06_EndMessageSetup::
    xor a                                         ; $62E7
    ld [wSubstate], a                             ; $62E8
    ld a, $06                                     ; $62EB
    ld [wResultMsgId], a                          ; $62ED
    next_state                                    ; $62F0
    ret                                           ; $62F4


; C: far call 09:7290 (shared result screen)
Mode13_State07_FarResultScreen::
    ldh [hFarcallAArg], a                         ; $62F5
    farcall ResultScreen_Far                      ; $62F7
    ret                                           ; $62FF


; C: jumps to state 0
Mode13_State08_Restart::
    jp Mode13_State00_Init                        ; $6300


; C: photo grid then the photo with the pointer hand
Mode0C_HotSpotViewer::
    ld a, [wState]                                ; $6303
    rst Rst18_JumpTable                           ; $6306

; I: 5 states, rst $18 table of mode $0C
Mode0C_StateTable::
    dw Mode0C_State00_Init
    dw Mode0C_State01_FarPhotoPicker
    dw Mode0C_State02_Setup
    dw Mode0C_State03_Browse
    dw Mode0C_State04_Activate

; C: selects the message strip / icon of the picker
Mode0C_State00_Init::
    ld a, $01                                     ; $6311
    ld [wMsgStripSel], a                          ; $6313
    ld a, $06                                     ; $6316
    ld [wIconSel], a                              ; $6318
    xor a                                         ; $631B
    ld [wSubstate], a                             ; $631C
    ld [wStockNavAllowed], a                      ; $631F
    next_state                                    ; $6322
    ret                                           ; $6326


; C: far call 04:4000 (photo grid)
Mode0C_State01_FarPhotoPicker::
    ldh [hFarcallAArg], a                         ; $6327
    ld a, $04                                     ; $6329
    ld hl, PhotoPicker_Far                        ; $632B
    call Far_Call                                 ; $632E
    ret                                           ; $6331


; C: B returns to the show menu (mode 0B); A builds the viewer screen and loads the photo
Mode0C_State02_Setup::
    ld a, [wAbResult]                             ; $6332
    bit 0, a                                      ; $6335
    jr nz, jr_003_6344                            ; $6337

    ld a, MODE_SHOW_MENU                          ; $6339
    ld [wMode], a                                 ; $633B
    set_state STATE_0B_INIT                       ; $633E
    ret                                           ; $6343


jr_003_6344:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6344
    ldh [hLcdcShadow], a                          ; $6346
    ld a, $e4                                     ; $6348
    ld [wPaletteTarget], a                        ; $634A
    ld [wPaletteTarget + $1], a                   ; $634D
    ld a, $d2                                     ; $6350
    ld [wPaletteTarget + $2], a                   ; $6352
    xor a                                         ; $6355
    ldh [hScxShadow], a                           ; $6356
    ldh [hScyShadow], a                           ; $6358
    ld a, $08                                     ; $635A
    ld [wHsCursorX], a                            ; $635C
    ld a, $07                                     ; $635F
    ld [wHsCursorY], a                            ; $6361
    call Anim_ClearSlots                          ; $6364
    farcopy Mem_CopyFromBank, Gfx_1C_58A0_Mode0C_State02_Setup, $8580, $0280 ; $6367
    farcopy Mem_CopyFromBank, Gfx_1C_5B60_Mode0C_State02_Setup, $8660, $0060 ; $6375
    farcopy Mem_CopyFromBank, Gfx_1C_5C60_Mode0C_State02_Setup, $8760, $0060 ; $6383
    farcopy Mem_CopyFromBank, Gfx_3F_7700_Mode0C_State02_Setup, $8e00, $01f0 ; $6391
    farcopy Mem_CopyFromBank, Map_3F_7D00_Mode0C_State02_Setup, $9800, $0240 ; $639F
    ld hl, $9a40                                  ; $63AD
    ld bc, $01c0                                  ; $63B0
    ld a, $ff                                     ; $63B3
    call Mem_FillBc1                              ; $63B5
    ld hl, $8ff0                                  ; $63B8
    ld bc, $0010                                  ; $63BB
    ld de, $ffff                                  ; $63BE
    call Mem_FillWords                            ; $63C1
    ld a, [wPhotoIndex]                           ; $63C4
    ld [wHotSpotShownPhoto], a                    ; $63C7
    ldh [hFarcallAArg], a                         ; $63CA
    farcall Photo_LoadImage_Far                   ; $63CC
    ld a, $00                                     ; $63D4
    ld hl, wPhotoImage                            ; $63D6
    ld de, $9000                                  ; $63D9
    ld bc, $0800                                  ; $63DC
    call Mem_CopyFromBank                         ; $63DF
    ld a, $00                                     ; $63E2
    ld hl, wPhotoImage + $800                     ; $63E4
    ld de, $8800                                  ; $63E7
    ld bc, $0600                                  ; $63EA
    call Mem_CopyFromBank                         ; $63ED
    ld a, [wHotSpotShownPhoto]                    ; $63F0
    ldh [hFarcallAArg], a                         ; $63F3
    farcall Photo_LoadHotspotsTranslated_Far      ; $63F5
    screen_on                                     ; $63FD
    play_music MUSIC_STOP                         ; $6406
    call Pal_FadeIn                               ; $640D
    next_state                                    ; $6410
    ret                                           ; $6414


; C: pointer hand moves over the photo
Mode0C_State03_Browse::
    call HotSpot_PointerMove                      ; $6415
    call HotSpot_DrawPointer                      ; $6418
    ldh a, [hKeysNew]                             ; $641B
    and PADF_A | PADF_B                           ; $641D
    ret z                                         ; $641F

    ld [wAbResult], a                             ; $6420
    next_state                                    ; $6423
    ret                                           ; $6427


; C: A: looks for a hot spot under the pointer and plays its effect; B leaves
Mode0C_State04_Activate::
    ld a, [wAbResult]                             ; $6428
    bit 0, a                                      ; $642B
    jr z, jr_003_6469                             ; $642D

    ld hl, wSpriteAnimFrame                       ; $642F
    inc [hl]                                      ; $6432
    call HotSpot_FindUnderPointer                 ; $6433
    jr c, jr_003_6443                             ; $6436

    ld e, $02                                     ; $6438
    call HotSpot_PointerAnimWait                  ; $643A
    set_state STATE_0C_BROWSE                     ; $643D
    ret                                           ; $6442


jr_003_6443:
    ld e, $03                                     ; $6443
    call HotSpot_PointerAnimWait                  ; $6445
    ld b, $00                                     ; $6448
    call HotSpot_PlayJingle                       ; $644A
    call HotSpot_LoadTargetPhoto                  ; $644D
    call HotSpot_RunEffect                        ; $6450
    ld a, [wHotSpotShownPhoto]                    ; $6453
    ldh [hFarcallAArg], a                         ; $6456
    farcall Photo_LoadHotspotsTranslated_Far      ; $6458
    ld a, [wHotSpotShownPhoto]                    ; $6460
    set_state STATE_0C_BROWSE                     ; $6463
    ret                                           ; $6468


jr_003_6469:
    screen_off                                    ; $6469
    set_state STATE_0C_INIT                       ; $646F
    ret                                           ; $6474


; C: runs the pointer animation until frame E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
HotSpot_PointerAnimWait::
    push bc                                       ; $6475

jr_003_6476:
    push de                                       ; $6476
    call HotSpot_DrawPointer                      ; $6477
    call Oam_HideUnused                           ; $647A
    rst Rst08_WaitVBlank                          ; $647D
    pop de                                        ; $647E
    ld a, [wSpriteAnimFrame]                      ; $647F
    cp e                                          ; $6482
    jr nz, jr_003_6476                            ; $6483

    xor a                                         ; $6485
    ld [wSpriteAnimFrame], a                      ; $6486
    call HotSpot_DrawPointer                      ; $6489
    pop bc                                        ; $648C
    ret                                           ; $648D


; C: draws the pointer hand at (cursor_x
HotSpot_DrawPointer::
    ld a, [wHsCursorX]                            ; $648E
    sla a                                         ; $6491
    sla a                                         ; $6493
    sla a                                         ; $6495
    add $18                                       ; $6497
    ld b, a                                       ; $6499
    ld a, [wHsCursorY]                            ; $649A
    sla a                                         ; $649D
    sla a                                         ; $649F
    sla a                                         ; $64A1
    add $20                                       ; $64A3
    ld c, a                                       ; $64A5
    ld a, [wSpriteAnimFrame]                      ; $64A6
    sla a                                         ; $64A9
    ld e, a                                       ; $64AB
    ld d, $00                                     ; $64AC
    ld hl, HotSpot_DrawPointer_Tbl64D1            ; $64AE
    add hl, de                                    ; $64B1
    ld a, [hl+]                                   ; $64B2
    call Oam_AddMeta_B01_4000                     ; $64B3
    ld a, [wSpriteAnimTick]                       ; $64B6
    cp [hl]                                       ; $64B9
    jr nz, jr_003_64c4                            ; $64BA

    ld hl, wSpriteAnimFrame                       ; $64BC
    inc [hl]                                      ; $64BF
    xor a                                         ; $64C0
    ld [wSpriteAnimTick], a                       ; $64C1

jr_003_64c4:
    ld a, [wSpriteAnimFrame]                      ; $64C4
    and a                                         ; $64C7
    ret z                                         ; $64C8

    cp $03                                        ; $64C9
    ret z                                         ; $64CB

    ld hl, wSpriteAnimTick                        ; $64CC
    inc [hl]                                      ; $64CF
    ret                                           ; $64D0


; C: auto: 8 bytes, bytes; referenced by HotSpot_DrawPointer. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0C)
HotSpot_DrawPointer_Tbl64D1::
    db $a0, $06, $a1, $06, $9f, $06, $9f, $ff

; C: D-pad moves the pointer (x 0..14
HotSpot_PointerMove::
    ldh a, [hKeysNewRepeat]                       ; $64D9
    ld b, a                                       ; $64DB
    ld a, [wHsCursorX]                            ; $64DC
    call HotSpot_PointerMoveX                     ; $64DF
    ld [wHsCursorX], a                            ; $64E2
    ld a, [wHsCursorY]                            ; $64E5
    call HotSpot_PointerMoveY                     ; $64E8
    ld [wHsCursorY], a                            ; $64EB
    ret                                           ; $64EE


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
HotSpot_PointerMoveX::
    bit 5, b                                      ; $64EF
    jr z, jr_003_64f7                             ; $64F1

    and a                                         ; $64F3
    ret z                                         ; $64F4

    dec a                                         ; $64F5
    ret                                           ; $64F6


jr_003_64f7:
    bit 4, b                                      ; $64F7
    ret z                                         ; $64F9

    cp $0e                                        ; $64FA
    ret z                                         ; $64FC

    inc a                                         ; $64FD
    ret                                           ; $64FE


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
HotSpot_PointerMoveY::
    bit 6, b                                      ; $64FF
    jr z, jr_003_6507                             ; $6501

    and a                                         ; $6503
    ret z                                         ; $6504

    dec a                                         ; $6505
    ret                                           ; $6506


jr_003_6507:
    bit 7, b                                      ; $6507
    ret z                                         ; $6509

    cp $0c                                        ; $650A
    ret z                                         ; $650C

    inc a                                         ; $650D
    ret                                           ; $650E


; C: plays the sound list of the hot spot. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: plays the sound of a hot spot (byte $0F of its record in wHotspotBlock, $FF =
; none) through HotSpotEd_SoundList
HotSpot_PlayJingle::
    ld hl, wHotspotBlock + $f                     ; $650F
    add hl, bc                                    ; $6512
    ld a, [hl]                                    ; $6513
    cp $ff                                        ; $6514
    ret z                                         ; $6516

    ld hl, HotSpotEd_SoundList                    ; $6517
    call Snd_PlayFromList                         ; $651A
    rst Rst08_WaitVBlank                          ; $651D
    rst Rst08_WaitVBlank                          ; $651E
    ret                                           ; $651F


; C: far call 02:4C80 for the JUMP target photo
HotSpot_LoadTargetPhoto::
    ld hl, wHotspotBlock + $19                    ; $6520
    add hl, bc                                    ; $6523
    ld a, [hl]                                    ; $6524
    cp $ff                                        ; $6525
    ret z                                         ; $6527

    push bc                                       ; $6528
    ld [wHotSpotShownPhoto], a                    ; $6529
    ldh [hFarcallAArg], a                         ; $652C
    farcall Photo_LoadImage_Far                   ; $652E
    pop bc                                        ; $6536
    ret                                           ; $6537


; C: dispatches the effect number through the table at 655D
HotSpot_RunEffect::
    ld hl, wHotspotBlock + $14                    ; $6538
    add hl, bc                                    ; $653B
    ld a, [hl]                                    ; $653C
    push bc                                       ; $653D
    ld hl, HotSpot_RunEffect_Return               ; $653E
    push hl                                       ; $6541
    inc a                                         ; $6542
    sla a                                         ; $6543
    ld c, a                                       ; $6545
    ld b, $00                                     ; $6546
    ld hl, HotSpot_EffectTbl                      ; $6548
    add hl, bc                                    ; $654B
    ld a, [hl+]                                   ; $654C
    ld h, [hl]                                    ; $654D
    ld l, a                                       ; $654E
    jp hl                                         ; $654F


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; pop bc / ret tail of HotSpot_RunEffect
HotSpot_RunEffect_Return::
    pop bc                                        ; $6550
    ret                                           ; $6551


; I: 17 words: effect $FF (plain swap)
HotSpot_EffectTbl::
    dw HotSpotFx_FF_PlainSwap
    dw HotSpotFx_00_Checkerboard
    dw HotSpotFx_01_StripeWipe
    dw HotSpotFx_02_FadeThroughBlack
    dw HotSpotFx_03_Negative
    dw HotSpotFx_04_WhiteFlash
    dw HotSpotFx_05_ColumnShear
    dw HotSpotFx_06_CentreWindow
    dw HotSpotFx_07_Wave
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip
    dw HotSpotFx_08_to_0F_PageFlip

; C: rst 08 keeping BC / DE / HL. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core
; organic runs); C from the code: waits one VBlank keeping BC, DE, HL (hot-spot tile effects)
HotSpot_WaitFrame::
    push bc                                       ; $6574
    push de                                       ; $6575
    push hl                                       ; $6576
    rst Rst08_WaitVBlank                          ; $6577
    pop hl                                        ; $6578
    pop de                                        ; $6579
    pop bc                                        ; $657A
    ret                                           ; $657B


; C: A = tile number: copies the 16-byte tile of the working buffer to VRAM. L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: copies tile A of the photo
; (wPhotoImage) to its own VRAM slot ($8000 / $9000 by bit 7), used by the spiral steps of ...
HotSpot_CopyTile::
    push bc                                       ; $657C
    push de                                       ; $657D
    push hl                                       ; $657E
    cp $80                                        ; $657F
    jr nc, jr_003_6588                            ; $6581

    ld hl, $9000                                  ; $6583
    jr jr_003_658b                                ; $6586

jr_003_6588:
    ld hl, $8000                                  ; $6588

jr_003_658b:
    swap a                                        ; $658B
    push af                                       ; $658D
    and $f0                                       ; $658E
    ld c, a                                       ; $6590
    pop af                                        ; $6591
    and $0f                                       ; $6592
    ld b, a                                       ; $6594
    add hl, bc                                    ; $6595
    push hl                                       ; $6596
    ld hl, wPhotoImage                            ; $6597
    add hl, bc                                    ; $659A
    ld a, $00                                     ; $659B
    pop de                                        ; $659D
    ld bc, $0010                                  ; $659E
    call Call_000_05a9                            ; $65A1
    pop hl                                        ; $65A4
    pop de                                        ; $65A5
    pop bc                                        ; $65A6
    ret                                           ; $65A7


; C: A = destination tile. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies photo tile C to the VRAM slot of tile A (hot-spot effects)
HotSpot_CopyTileFrom::
    push de                                       ; $65A8
    push hl                                       ; $65A9
    cp $80                                        ; $65AA
    jr nc, jr_003_65b3                            ; $65AC

    ld hl, $9000                                  ; $65AE
    jr jr_003_65b6                                ; $65B1

jr_003_65b3:
    ld hl, $8000                                  ; $65B3

jr_003_65b6:
    swap a                                        ; $65B6
    push af                                       ; $65B8
    and $f0                                       ; $65B9
    ld e, a                                       ; $65BB
    pop af                                        ; $65BC
    and $0f                                       ; $65BD
    ld d, a                                       ; $65BF
    add hl, de                                    ; $65C0
    push hl                                       ; $65C1
    ld a, c                                       ; $65C2
    swap a                                        ; $65C3
    push af                                       ; $65C5
    and $f0                                       ; $65C6
    ld c, a                                       ; $65C8
    pop af                                        ; $65C9
    and $0f                                       ; $65CA
    ld b, a                                       ; $65CC
    ld hl, wPhotoImage                            ; $65CD
    add hl, bc                                    ; $65D0
    ld a, $00                                     ; $65D1
    pop de                                        ; $65D3
    ld bc, $0010                                  ; $65D4
    call Call_000_05a9                            ; $65D7
    pop hl                                        ; $65DA
    pop de                                        ; $65DB
    ret                                           ; $65DC


; C: A = destination tile. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies VRAM tile C to the slot of tile A (hot-spot effects)
HotSpot_MoveTileInVram::
    push de                                       ; $65DD
    push hl                                       ; $65DE
    cp $80                                        ; $65DF
    jr nc, jr_003_65e8                            ; $65E1

    ld hl, $9000                                  ; $65E3
    jr jr_003_65eb                                ; $65E6

jr_003_65e8:
    ld hl, $8000                                  ; $65E8

jr_003_65eb:
    swap a                                        ; $65EB
    push af                                       ; $65ED
    and $f0                                       ; $65EE
    ld e, a                                       ; $65F0
    pop af                                        ; $65F1
    and $0f                                       ; $65F2
    ld d, a                                       ; $65F4
    add hl, de                                    ; $65F5
    push hl                                       ; $65F6
    ld a, c                                       ; $65F7
    cp $80                                        ; $65F8
    jr nc, jr_003_6601                            ; $65FA

    ld hl, $9000                                  ; $65FC
    jr jr_003_6604                                ; $65FF

jr_003_6601:
    ld hl, $8000                                  ; $6601

jr_003_6604:
    swap a                                        ; $6604
    push af                                       ; $6606
    and $f0                                       ; $6607
    ld c, a                                       ; $6609
    pop af                                        ; $660A
    and $0f                                       ; $660B
    ld b, a                                       ; $660D
    add hl, bc                                    ; $660E
    xor a                                         ; $660F
    pop de                                        ; $6610
    ld bc, $0010                                  ; $6611
    call Call_000_05a9                            ; $6614
    pop hl                                        ; $6617
    pop de                                        ; $6618
    ret                                           ; $6619


; C: no effect: copies the new photo to VRAM
HotSpotFx_FF_PlainSwap::
    ld a, $00                                     ; $661A
    ld hl, wPhotoImage                            ; $661C
    ld de, $9000                                  ; $661F
    ld bc, $0800                                  ; $6622
    call Call_000_05a9                            ; $6625
    ld a, $00                                     ; $6628
    ld hl, wPhotoImage + $800                     ; $662A
    ld de, $8800                                  ; $662D
    ld bc, $0600                                  ; $6630
    call Call_000_05a9                            ; $6633
    ret                                           ; $6636


; C: dissolve through a checkerboard of tiles
HotSpotFx_00_Checkerboard::
    ld de, $c0c0                                  ; $6637
    ld b, $02                                     ; $663A

jr_003_663c:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $663C
    ld c, $10                                     ; $663F

jr_003_6641:
    ld a, [hl+]                                   ; $6641
    add e                                         ; $6642
    call HotSpot_CopyTile                         ; $6643
    dec c                                         ; $6646
    jr nz, jr_003_6641                            ; $6647

    call HotSpot_WaitFrame                        ; $6649
    ld a, e                                       ; $664C
    sub $20                                       ; $664D
    ld e, a                                       ; $664F
    dec b                                         ; $6650
    jr nz, jr_003_663c                            ; $6651

    ld b, $05                                     ; $6653

jr_003_6655:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $6655
    ld c, $10                                     ; $6658

jr_003_665a:
    ld a, [hl+]                                   ; $665A
    push af                                       ; $665B
    add e                                         ; $665C
    call HotSpot_CopyTile                         ; $665D
    pop af                                        ; $6660
    add d                                         ; $6661
    xor $01                                       ; $6662
    call HotSpot_CopyTile                         ; $6664
    dec c                                         ; $6667
    jr nz, jr_003_665a                            ; $6668

    call HotSpot_WaitFrame                        ; $666A
    ld a, e                                       ; $666D
    sub $20                                       ; $666E
    ld e, a                                       ; $6670
    ld a, d                                       ; $6671
    sub $20                                       ; $6672
    ld d, a                                       ; $6674
    dec b                                         ; $6675
    jr nz, jr_003_6655                            ; $6676

    ld b, $02                                     ; $6678

jr_003_667a:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $667A
    ld c, $10                                     ; $667D

jr_003_667f:
    ld a, [hl+]                                   ; $667F
    add d                                         ; $6680
    xor $01                                       ; $6681
    call HotSpot_CopyTile                         ; $6683
    dec c                                         ; $6686
    jr nz, jr_003_667f                            ; $6687

    call HotSpot_WaitFrame                        ; $6689
    ld a, d                                       ; $668C
    sub $20                                       ; $668D
    ld d, a                                       ; $668F
    dec b                                         ; $6690
    jr nz, jr_003_667a                            ; $6691

    ret                                           ; $6693


; C: 16 tile-index offsets $1F,$1D,...,$11,$0E,$0C,...,$00 (not tile graphics): the 16 cells of a checkerboard over
; two tile rows (row 1 odd columns, row 0 even columns); HotSpotFx_00_Checkerboard adds the band base (E or D) to each
; and copies that tile with HotSpot_CopyTile. Code read 2026-10-18
HotSpotFx_00_Checkerboard_CellTbl::
    db $1f, $1d, $1b, $19, $17, $15, $13, $11, $0e, $0c, $0a, $08, $06, $04, $02, $00

; C: ragged stripe wipe
HotSpotFx_01_StripeWipe::
    ld b, $10                                     ; $66A4

jr_003_66a6:
    push bc                                       ; $66A6
    ld a, b                                       ; $66A7
    dec a                                         ; $66A8
    ld d, a                                       ; $66A9
    ld e, $00                                     ; $66AA
    ld a, b                                       ; $66AC
    cpl                                           ; $66AD
    add $12                                       ; $66AE
    ld b, a                                       ; $66B0

jr_003_66b1:
    push de                                       ; $66B1
    ld c, $0e                                     ; $66B2

jr_003_66b4:
    push bc                                       ; $66B4
    ld a, d                                       ; $66B5
    ld c, e                                       ; $66B6
    call HotSpot_CopyTileFrom                     ; $66B7
    ld a, e                                       ; $66BA
    add $10                                       ; $66BB
    ld e, a                                       ; $66BD
    ld a, d                                       ; $66BE
    add $10                                       ; $66BF
    ld d, a                                       ; $66C1
    pop bc                                        ; $66C2
    dec c                                         ; $66C3
    jr nz, jr_003_66b4                            ; $66C4

    pop de                                        ; $66C6
    inc d                                         ; $66C7
    inc e                                         ; $66C8
    dec b                                         ; $66C9
    jr nz, jr_003_66b1                            ; $66CA

    pop bc                                        ; $66CC
    dec b                                         ; $66CD
    jr nz, jr_003_66a6                            ; $66CE

    ret                                           ; $66D0


; C: fade through black
HotSpotFx_02_FadeThroughBlack::
    ld a, $00                                     ; $66D1
    ld hl, $9000                                  ; $66D3
    ld de, wPhotoImage                            ; $66D6
    ld bc, $0800                                  ; $66D9
    call Call_000_05a9                            ; $66DC
    ld a, $00                                     ; $66DF
    ld hl, $8800                                  ; $66E1
    ld de, wPhotoImage + $800                     ; $66E4
    ld bc, $0600                                  ; $66E7
    call Call_000_05a9                            ; $66EA
    ld b, $04                                     ; $66ED

jr_003_66ef:
    push bc                                       ; $66EF
    ld hl, wPhotoImage + $1                       ; $66F0
    ld bc, $0700                                  ; $66F3

jr_003_66f6:
    ld a, [hl-]                                   ; $66F6
    or [hl]                                       ; $66F7
    ld [hl+], a                                   ; $66F8
    push af                                       ; $66F9
    ld a, [hl-]                                   ; $66FA
    cpl                                           ; $66FB
    xor [hl]                                      ; $66FC
    ld [hl+], a                                   ; $66FD
    pop af                                        ; $66FE
    ld [hl+], a                                   ; $66FF
    inc hl                                        ; $6700
    dec bc                                        ; $6701
    ld a, b                                       ; $6702
    or c                                          ; $6703
    jr nz, jr_003_66f6                            ; $6704

    ld a, $00                                     ; $6706
    ld hl, wPhotoImage                            ; $6708
    ld de, $9000                                  ; $670B
    ld bc, $0800                                  ; $670E
    call Call_000_05a9                            ; $6711
    ld a, $00                                     ; $6714
    ld hl, wPhotoImage + $800                     ; $6716
    ld de, $8800                                  ; $6719
    ld bc, $0600                                  ; $671C
    call Call_000_05a9                            ; $671F
    pop bc                                        ; $6722
    dec b                                         ; $6723
    jr nz, jr_003_66ef                            ; $6724

    ld a, [wHotSpotShownPhoto]                    ; $6726
    ldh [hFarcallAArg], a                         ; $6729
    farcall Photo_LoadImage_Far                   ; $672B
    ld hl, wPhotoImage + $1                       ; $6733
    ld bc, $0700                                  ; $6736

jr_003_6739:
    ld a, [hl-]                                   ; $6739
    or [hl]                                       ; $673A
    ld [hl+], a                                   ; $673B
    ld a, $ff                                     ; $673C
    ld [hl+], a                                   ; $673E
    inc hl                                        ; $673F
    dec bc                                        ; $6740
    ld a, b                                       ; $6741
    or c                                          ; $6742
    jr nz, jr_003_6739                            ; $6743

    ld a, $00                                     ; $6745
    ld hl, wPhotoImage                            ; $6747
    ld de, $9000                                  ; $674A
    ld bc, $0800                                  ; $674D
    call Call_000_05a9                            ; $6750
    ld a, $00                                     ; $6753
    ld hl, wPhotoImage + $800                     ; $6755
    ld de, $8800                                  ; $6758
    ld bc, $0600                                  ; $675B
    call Call_000_05a9                            ; $675E
    ld a, [wHotSpotShownPhoto]                    ; $6761
    ldh [hFarcallAArg], a                         ; $6764
    farcall Photo_LoadImage_Far                   ; $6766
    ld hl, wPhotoImage + $1                       ; $676E
    ld bc, $0700                                  ; $6771

jr_003_6774:
    ld a, [hl-]                                   ; $6774
    or [hl]                                       ; $6775
    ld [hl+], a                                   ; $6776
    push af                                       ; $6777
    ld a, [hl-]                                   ; $6778
    cpl                                           ; $6779
    xor [hl]                                      ; $677A
    ld [hl+], a                                   ; $677B
    pop af                                        ; $677C
    ld [hl+], a                                   ; $677D
    inc hl                                        ; $677E
    dec bc                                        ; $677F
    ld a, b                                       ; $6780
    or c                                          ; $6781
    jr nz, jr_003_6774                            ; $6782

    ld a, $00                                     ; $6784
    ld hl, wPhotoImage                            ; $6786
    ld de, $9000                                  ; $6789
    ld bc, $0800                                  ; $678C
    call Call_000_05a9                            ; $678F
    ld a, $00                                     ; $6792
    ld hl, wPhotoImage + $800                     ; $6794
    ld de, $8800                                  ; $6797
    ld bc, $0600                                  ; $679A
    call Call_000_05a9                            ; $679D
    ld a, [wHotSpotShownPhoto]                    ; $67A0
    ldh [hFarcallAArg], a                         ; $67A3
    farcall Photo_LoadImage_Far                   ; $67A5
    ld a, $00                                     ; $67AD
    ld hl, wPhotoImage                            ; $67AF
    ld de, $9000                                  ; $67B2
    ld bc, $0800                                  ; $67B5
    call Call_000_05a9                            ; $67B8
    ld a, $00                                     ; $67BB
    ld hl, wPhotoImage + $800                     ; $67BD
    ld de, $8800                                  ; $67C0
    ld bc, $0600                                  ; $67C3
    call Call_000_05a9                            ; $67C6
    ret                                           ; $67C9


; C: inverts the palette for 60 frames
HotSpotFx_03_Negative::
    ldh a, [hBgpShadow]                           ; $67CA
    push af                                       ; $67CC
    cpl                                           ; $67CD
    ldh [hBgpShadow], a                           ; $67CE
    ld bc, $003c                                  ; $67D0
    call Wait_Frames                              ; $67D3
    ld a, $00                                     ; $67D6
    ld hl, wPhotoImage                            ; $67D8
    ld de, $9000                                  ; $67DB
    ld bc, $0800                                  ; $67DE
    call Call_000_05a9                            ; $67E1
    ld a, $00                                     ; $67E4
    ld hl, wPhotoImage + $800                     ; $67E6
    ld de, $8800                                  ; $67E9
    ld bc, $0600                                  ; $67EC
    call Call_000_05a9                            ; $67EF
    pop af                                        ; $67F2
    ldh [hBgpShadow], a                           ; $67F3
    ret                                           ; $67F5


; C: flash to white
HotSpotFx_04_WhiteFlash::
    ldh a, [hBgpShadow]                           ; $67F6
    push af                                       ; $67F8
    ld a, $90                                     ; $67F9
    ldh [hBgpShadow], a                           ; $67FB
    rst Rst08_WaitVBlank                          ; $67FD
    ld a, $40                                     ; $67FE
    ldh [hBgpShadow], a                           ; $6800
    rst Rst08_WaitVBlank                          ; $6802
    ld a, $00                                     ; $6803
    ldh [hBgpShadow], a                           ; $6805
    ld bc, $000a                                  ; $6807
    call Wait_Frames                              ; $680A
    ld a, $00                                     ; $680D
    ld hl, wPhotoImage                            ; $680F
    ld de, $9000                                  ; $6812
    ld bc, $0800                                  ; $6815
    call Call_000_05a9                            ; $6818
    ld a, $00                                     ; $681B
    ld hl, wPhotoImage + $800                     ; $681D
    ld de, $8800                                  ; $6820
    ld bc, $0600                                  ; $6823
    call Call_000_05a9                            ; $6826
    pop af                                        ; $6829
    ldh [hBgpShadow], a                           ; $682A
    ret                                           ; $682C


; C: columns shear and re-form
HotSpotFx_05_ColumnShear::
    ld b, $08                                     ; $682D

jr_003_682f:
    push bc                                       ; $682F
    ld de, $0001                                  ; $6830
    jr jr_003_6845                                ; $6833

jr_003_6835:
    push bc                                       ; $6835
    call HotSpotFx_MoveColumn14                   ; $6836
    call HotSpotFx_MirrorColumnsDE                ; $6839
    call HotSpotFx_MoveColumn14                   ; $683C
    call HotSpotFx_MirrorColumnsDE                ; $683F
    inc d                                         ; $6842
    inc e                                         ; $6843
    pop bc                                        ; $6844

jr_003_6845:
    dec b                                         ; $6845
    jr nz, jr_003_6835                            ; $6846

    pop bc                                        ; $6848
    dec e                                         ; $6849
    push bc                                       ; $684A
    ld a, b                                       ; $684B
    cpl                                           ; $684C
    add $0a                                       ; $684D
    ld b, a                                       ; $684F

jr_003_6850:
    push bc                                       ; $6850
    call HotSpotFx_CopyColumn14                   ; $6851
    call HotSpotFx_MirrorColumnsDE                ; $6854
    call HotSpotFx_CopyColumn14                   ; $6857
    call HotSpotFx_MirrorColumnsDE                ; $685A
    inc e                                         ; $685D
    pop bc                                        ; $685E
    dec b                                         ; $685F
    jr nz, jr_003_6850                            ; $6860

    pop bc                                        ; $6862
    dec b                                         ; $6863
    jr nz, jr_003_682f                            ; $6864

    ret                                           ; $6866


; C: D ^= $0F, E ^= $0F: mirrors the column (low nibble) of the two tile indices D and E (tile index = row x 16 +
; column, HotSpot_CopyTile: offset = index x 16 from $9000 / $8000); used by HotSpotFx_05_ColumnShear between its
; column passes. Code read 2026-10-18
HotSpotFx_MirrorColumnsDE::
    ld a, d                                       ; $6867
    xor $0f                                       ; $6868
    ld d, a                                       ; $686A
    ld a, e                                       ; $686B
    xor $0f                                       ; $686C
    ld e, a                                       ; $686E
    ret                                           ; $686F


; C: moves the 14 tiles of a column inside VRAM: HotSpot_MoveTileInVram(tile D -> tile E), then D += $10, E += $10, 14
; times. Code read 2026-10-18
HotSpotFx_MoveColumn14::
    push de                                       ; $6870
    ld c, $0e                                     ; $6871

jr_003_6873:
    push bc                                       ; $6873
    ld a, d                                       ; $6874
    ld c, e                                       ; $6875
    call HotSpot_MoveTileInVram                   ; $6876
    ld a, e                                       ; $6879
    add $10                                       ; $687A
    ld e, a                                       ; $687C
    ld a, d                                       ; $687D
    add $10                                       ; $687E
    ld d, a                                       ; $6880
    pop bc                                        ; $6881
    dec c                                         ; $6882
    jr nz, jr_003_6873                            ; $6883

    pop de                                        ; $6885
    ret                                           ; $6886


; C: copies the 14 tiles of column E from the work buffer to VRAM: HotSpot_CopyTile(E), E += $10, 14 times. Code read
; 2026-10-18
HotSpotFx_CopyColumn14::
    push de                                       ; $6887
    ld c, $0e                                     ; $6888

jr_003_688a:
    push bc                                       ; $688A
    ld a, e                                       ; $688B
    call HotSpot_CopyTile                         ; $688C
    ld a, e                                       ; $688F
    add $10                                       ; $6890
    ld e, a                                       ; $6892
    pop bc                                        ; $6893
    dec c                                         ; $6894
    jr nz, jr_003_688a                            ; $6895

    pop de                                        ; $6897
    ret                                           ; $6898


; C: rectangular window opens at the centre
HotSpotFx_06_CentreWindow::
    ld e, $79                                     ; $6899
    ld bc, $0301                                  ; $689B

jr_003_689e:
    ld d, b                                       ; $689E
    call HotSpotFx_SpiralStepLeft                 ; $689F
    inc b                                         ; $68A2
    ld d, c                                       ; $68A3
    call HotSpotFx_SpiralStepUp                   ; $68A4
    inc c                                         ; $68A7
    ld d, b                                       ; $68A8
    call HotSpotFx_SpiralStepRight                ; $68A9
    inc b                                         ; $68AC
    ld a, b                                       ; $68AD
    cp $11                                        ; $68AE
    ret z                                         ; $68B0

    ld d, c                                       ; $68B1
    call HotSpotFx_SpiralStepDown                 ; $68B2
    inc c                                         ; $68B5
    jr jr_003_689e                                ; $68B6

; C: copies D tiles walking left: HotSpot_CopyTile(E), delay, E -= 1 (tile index = row x 16 + column). The old name
; said Up; the four steps of HotSpotFx_06_CentreWindow (left, up, right, down with the lengths 3, 1, 4, 2, ...) draw a
; clockwise spiral out of tile $79. Code read 2026-10-18
HotSpotFx_SpiralStepLeft::
    ld a, e                                       ; $68B8
    call HotSpot_CopyTile                         ; $68B9
    call HotSpotFx_Delay                          ; $68BC
    dec e                                         ; $68BF
    dec d                                         ; $68C0
    jr nz, HotSpotFx_SpiralStepLeft               ; $68C1

    ret                                           ; $68C3


; C: copies D tiles walking right: HotSpot_CopyTile(E), delay, E += 1. Code read 2026-10-18
HotSpotFx_SpiralStepRight::
    ld a, e                                       ; $68C4
    call HotSpot_CopyTile                         ; $68C5
    call HotSpotFx_Delay                          ; $68C8
    inc e                                         ; $68CB
    dec d                                         ; $68CC
    jr nz, HotSpotFx_SpiralStepRight              ; $68CD

    ret                                           ; $68CF


; C: copies D tiles walking up: HotSpot_CopyTile(E), delay, E -= $10 (one tile row up). The old name said Down. Code
; read 2026-10-18
HotSpotFx_SpiralStepUp::
    ld a, e                                       ; $68D0
    call HotSpot_CopyTile                         ; $68D1
    call HotSpotFx_Delay                          ; $68D4
    ld a, e                                       ; $68D7
    sub $10                                       ; $68D8
    ld e, a                                       ; $68DA
    dec d                                         ; $68DB
    jr nz, HotSpotFx_SpiralStepUp                 ; $68DC

    ret                                           ; $68DE


; C: copies D tiles walking down: HotSpot_CopyTile(E), delay, E += $10 (one tile row down). The old name said Left.
; Code read 2026-10-18
HotSpotFx_SpiralStepDown::
    ld a, e                                       ; $68DF
    call HotSpot_CopyTile                         ; $68E0
    call HotSpotFx_Delay                          ; $68E3
    ld a, e                                       ; $68E6
    add $10                                       ; $68E7
    ld e, a                                       ; $68E9
    dec d                                         ; $68EA
    jr nz, HotSpotFx_SpiralStepDown               ; $68EB

    ret                                           ; $68ED


; C: busy wait: 255 passes of dec b / jr nz (about 1,000 cycles) between two tiles of the spiral. Code read 2026-10-18
HotSpotFx_Delay::
    push bc                                       ; $68EE
    ld b, $ff                                     ; $68EF

jr_003_68f1:
    dec b                                         ; $68F1
    jr nz, jr_003_68f1                            ; $68F2

    pop bc                                        ; $68F4
    ret                                           ; $68F5


; C: sinusoidal row displacement (S shape icon)
HotSpotFx_07_Wave::
    ld bc, $4848                                  ; $68F6

jr_003_68f9:
    ldh a, [rLY]                                  ; $68F9
    and a                                         ; $68FB
    jr nz, jr_003_68f9                            ; $68FC

jr_003_68fe:
    ld hl, HotSpotFx_WaveTbl                      ; $68FE

jr_003_6901:
    ldh a, [rLY]                                  ; $6901
    cp b                                          ; $6903
    jr c, jr_003_691b                             ; $6904

    sub b                                         ; $6906
    cp $10                                        ; $6907
    jr nc, jr_003_690e                            ; $6909

    ld a, [hl+]                                   ; $690B
    jr jr_003_691c                                ; $690C

jr_003_690e:
    ldh a, [rLY]                                  ; $690E
    cp c                                          ; $6910
    jr c, jr_003_691b                             ; $6911

    sub c                                         ; $6913
    cp $10                                        ; $6914
    jr nc, jr_003_691b                            ; $6916

    ld a, [hl+]                                   ; $6918
    jr jr_003_691c                                ; $6919

jr_003_691b:
    xor a                                         ; $691B

jr_003_691c:
    ld d, a                                       ; $691C

jr_003_691d:
    ldh a, [rSTAT]                                ; $691D
    and $03                                       ; $691F
    jr nz, jr_003_691d                            ; $6921

    ld a, d                                       ; $6923
    ldh [rSCY], a                                 ; $6924
    call HotSpotFx_Delay2                         ; $6926
    ldh a, [rLY]                                  ; $6929
    cp $8f                                        ; $692B
    jr c, jr_003_6901                             ; $692D

    inc c                                         ; $692F
    inc c                                         ; $6930
    dec b                                         ; $6931
    dec b                                         ; $6932
    jr nz, jr_003_68fe                            ; $6933

    ld a, $00                                     ; $6935
    ld hl, wPhotoImage                            ; $6937
    ld de, $9000                                  ; $693A
    ld bc, $0800                                  ; $693D
    call Call_000_05a9                            ; $6940
    ld a, $00                                     ; $6943
    ld hl, wPhotoImage + $800                     ; $6945
    ld de, $8800                                  ; $6948
    ld bc, $0600                                  ; $694B
    call Call_000_05a9                            ; $694E
    ret                                           ; $6951


; C: SCY offsets of HotSpotFx_07_Wave: 1,2,3,4,5,6,7,7,7,7,6,5,4,3,2,1 twice (read with ld a,[hl+] on the 16-line
; bands at LY = B and C). Code read 2026-10-18
HotSpotFx_WaveTbl::
    db $01, $02, $03, $04, $05, $06, $07, $07, $07, $07, $06, $05, $04, $03, $02, $01
    db $01, $02, $03, $04, $05, $06, $07, $07, $07, $07, $06, $05, $04, $03, $02, $01

; C: busy wait of 4 passes (dec a / jr nz) between two scanlines of the wave. Code read 2026-10-18
HotSpotFx_Delay2::
    ld a, $04                                     ; $6972

jr_003_6974:
    dec a                                         ; $6974
    jr nz, jr_003_6974                            ; $6975

    ret                                           ; $6977


; C: quick page flip used by the eight unused values
HotSpotFx_08_to_0F_PageFlip::
    call HotSpotFx_PageFlipRamp                   ; $6978
    ld a, $00                                     ; $697B
    ld hl, wPhotoImage                            ; $697D
    ld de, $9000                                  ; $6980
    ld bc, $0800                                  ; $6983
    call Call_000_05a9                            ; $6986
    ld a, $00                                     ; $6989
    ld hl, wPhotoImage + $800                     ; $698B
    ld de, $8800                                  ; $698E
    ld bc, $0600                                  ; $6991
    call Call_000_05a9                            ; $6994
    ret                                           ; $6997


; C: raster effect of HotSpotFx_08_to_0F_PageFlip: for c = 1..7, on every scanline LY from $0F to $7E, SCY = b - LY
; with b += 1 every c scanlines, SCY back to 0 afterwards. Code read 2026-10-18
HotSpotFx_PageFlipRamp::
    ld c, $01                                     ; $6998
    ld b, $00                                     ; $699A
    ld hl, Unused_HotSpotFx_PageFlipTbl           ; $699C

jr_003_699f:
    ldh a, [rLY]                                  ; $699F
    cp $0f                                        ; $69A1
    jr c, jr_003_699f                             ; $69A3

    cp $7f                                        ; $69A5
    jr nc, jr_003_699f                            ; $69A7

    ld e, c                                       ; $69A9
    push bc                                       ; $69AA

jr_003_69ab:
    dec e                                         ; $69AB
    jr nz, jr_003_69b0                            ; $69AC

    ld e, c                                       ; $69AE
    inc b                                         ; $69AF

jr_003_69b0:
    ldh a, [rLY]                                  ; $69B0
    cpl                                           ; $69B2
    inc a                                         ; $69B3
    add b                                         ; $69B4
    ld d, a                                       ; $69B5

jr_003_69b6:
    ldh a, [rSTAT]                                ; $69B6
    and $03                                       ; $69B8
    jr nz, jr_003_69b6                            ; $69BA

    ld a, d                                       ; $69BC
    ldh [rSCY], a                                 ; $69BD
    call HotSpotFx_Delay3                         ; $69BF
    ldh a, [rLY]                                  ; $69C2
    cp $7f                                        ; $69C4
    jr c, jr_003_69ab                             ; $69C6

    call HotSpotFx_Delay3                         ; $69C8

jr_003_69cb:
    ldh a, [rSTAT]                                ; $69CB
    and $03                                       ; $69CD
    jr nz, jr_003_69cb                            ; $69CF

    xor a                                         ; $69D1
    ldh [rSCY], a                                 ; $69D2
    pop bc                                        ; $69D4
    inc c                                         ; $69D5
    ld a, c                                       ; $69D6
    cp $08                                        ; $69D7
    jr nz, jr_003_699f                            ; $69D9

    ret                                           ; $69DB


; C: 8 zero bytes that nothing reads: HotSpotFx_PageFlipRamp loads HL with this address (03:69A7) and never uses HL
; again (its loop uses B, C, D, E only), and no other instruction of the ROM holds the address $69E7. Code read
; 2026-10-18
Unused_HotSpotFx_PageFlipTbl::
    db $00, $00, $00, $00, $00, $00, $00, $00

; C: busy wait of 4 passes (dec a / jr nz), the same code as HotSpotFx_Delay2, between two scanlines of the page flip.
; Code read 2026-10-18
HotSpotFx_Delay3::
    ld a, $04                                     ; $69E4

jr_003_69e6:
    dec a                                         ; $69E6
    jr nz, jr_003_69e6                            ; $69E7

    ret                                           ; $69E9


; C: select photo / edit the five hot spots
Mode1A_HotSpotEditor::
    ld a, [wState]                                ; $69EA
    rst Rst18_JumpTable                           ; $69ED

; I: 16 states, rst $18 table of mode $1A
Mode1A_StateTable::
    dw Mode1A_State00_Init
    dw Mode1A_State01_FarPhotoPicker
    dw Mode1A_State02_Setup
    dw Mode1A_State03_Browse
    dw Mode1A_State04_PlaceOrDelete
    dw Mode1A_State05_PickSound
    dw Mode1A_State06_PickEffect
    dw Mode1A_State07_PickJump
    dw Mode1A_State08_PickConfirm
    dw Mode1A_State09_ExitDialog
    dw Mode1A_State0A_DeleteDialog
    dw Mode1A_State0B_Unused
    dw Mode1A_State0C_Exit
    dw Mode1A_State0D_SavePrepare
    dw Mode1A_State0E_FarSaveRoutine
    dw Mode1A_State0F_SaveResult

; C: selects the message strip / icon of the picker
Mode1A_State00_Init::
    ld a, $00                                     ; $6A0E
    ld [wMsgStripSel], a                          ; $6A10
    ld a, $06                                     ; $6A13
    ld [wIconSel], a                              ; $6A15
    xor a                                         ; $6A18
    ld [wSubstate], a                             ; $6A19
    ld [wStockNavAllowed], a                      ; $6A1C
    next_state                                    ; $6A1F
    ret                                           ; $6A23


; C: far call 04:4000 (photo grid)
Mode1A_State01_FarPhotoPicker::
    ldh [hFarcallAArg], a                         ; $6A24
    ld a, $04                                     ; $6A26
    ld hl, PhotoPicker_Far                        ; $6A28
    call Far_Call                                 ; $6A2B
    ret                                           ; $6A2E


; I: B returns to the special menu (mode 03); A builds the editor screen (cursor
Mode1A_State02_Setup::
    ld a, [wAbResult]                             ; $6A2F
    bit 0, a                                      ; $6A32
    jr nz, jr_003_6a41                            ; $6A34

    ld a, MODE_SPECIAL_MENU                       ; $6A36
    ld [wMode], a                                 ; $6A38
    set_state STATE_03_INIT                       ; $6A3B
    ret                                           ; $6A40


jr_003_6a41:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $6A41
    ldh [hLcdcShadow], a                          ; $6A43
    ld a, $e4                                     ; $6A45
    ld [wPaletteTarget], a                        ; $6A47
    ld [wPaletteTarget + $1], a                   ; $6A4A
    ld a, $d2                                     ; $6A4D
    ld [wPaletteTarget + $2], a                   ; $6A4F
    ld a, $10                                     ; $6A52
    ldh [hScxShadow], a                           ; $6A54
    ldh [hScyShadow], a                           ; $6A56
    ld a, $07                                     ; $6A58
    ldh [hWxShadow], a                            ; $6A5A
    ld a, $94                                     ; $6A5C
    ldh [hWyShadow], a                            ; $6A5E
    ld a, $02                                     ; $6A60
    ld [wHsCursorX], a                            ; $6A62
    ld a, $0c                                     ; $6A65
    ld [wHsCursorY], a                            ; $6A67
    ld a, $01                                     ; $6A6A
    ld [wHsCursorMode], a                         ; $6A6C
    call HotSpotEd_ClearAnim                      ; $6A6F
    ld a, $02                                     ; $6A72
    ld [wHsSelected], a                           ; $6A74
    farcopy Mem_CopyFromBank, Gfx_1C_4F60_Mode1A_State02_Setup, $8900, $01c0 ; $6A77
    farcopy Mem_CopyFromBank, Gfx_1C_53A0_Mode1A_State02_Setup, $8580, $0280 ; $6A85
    farcopy Mem_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $6A93
    farcopy Mem_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6AA1
    farcopy Mem_CopyFromBank, Gfx_22_6AA0_Mode1A_State02_Setup, $8ff0, $0010 ; $6AAF
    farcopy Mem_CopyFromBank, Map_24_6620_Mode1A_State02_Setup, $9800, $02c0 ; $6ABD
    ld a, [wPhotoIndex]                           ; $6ACB
    ld [wCopyPhotoIdxE], a                        ; $6ACE
    ldh [hFarcallAArg], a                         ; $6AD1
    farcall Photo_LoadToVram_Far                  ; $6AD3
    xor a                                         ; $6ADB
    ld [wDirtyFlag], a                            ; $6ADC
    ld a, [wCopyPhotoIdxE]                        ; $6ADF
    ldh [hFarcallAArg], a                         ; $6AE2
    farcall Photo_LoadHotspotsTranslated_Far      ; $6AE4
    ld a, $54                                     ; $6AEC
    ldh [hLycShadowSplit1], a                     ; $6AEE
    ldh [hSplit1Latch], a                         ; $6AF0
    ld hl, hStatShadow                            ; $6AF2
    set 6, [hl]                                   ; $6AF5
    ld hl, rIE                                    ; $6AF7
    set 1, [hl]                                   ; $6AFA
    ld a, $01                                     ; $6AFC
    ldh [hStatHandlerIndex], a                    ; $6AFE
    screen_on                                     ; $6B00
    play_music MUSIC_STOP                         ; $6B09
    call Pal_FadeIn                               ; $6B10
    next_state                                    ; $6B13
    ret                                           ; $6B17


; C: pointer / hot-spot slot selection; A edits or places a spot
Mode1A_State03_Browse::
    ld a, [wHsCursorMode]                         ; $6B18
    and a                                         ; $6B1B
    jr nz, jr_003_6b3d                            ; $6B1C

    call HotSpot_FindUnderPointer                 ; $6B1E
    ld a, $ff                                     ; $6B21
    jr nc, jr_003_6b26                            ; $6B23

    ld a, c                                       ; $6B25

jr_003_6b26:
    ld [wHsSelected], a                           ; $6B26
    call HotSpotEd_DrawPointer                    ; $6B29
    call HotSpotEd_DrawSlots                      ; $6B2C
    ldh a, [hKeysNew]                             ; $6B2F
    bit PADB_A, a                                 ; $6B31
    jr nz, jr_003_6b6e                            ; $6B33

    bit PADB_B, a                                 ; $6B35
    jr nz, jr_003_6ba4                            ; $6B37

    call HotSpotEd_PointerMove                    ; $6B39
    ret                                           ; $6B3C


jr_003_6b3d:
    call HotSpotEd_DrawSlotPointer                ; $6B3D
    call HotSpotEd_DrawSlots                      ; $6B40
    ldh a, [hKeysNew]                             ; $6B43
    bit PADB_A, a                                 ; $6B45
    jr z, jr_003_6b66                             ; $6B47

    play_sfx1 SFX1_KEY_A                          ; $6B49
    ld a, [wHsSelected]                           ; $6B50
    ld c, a                                       ; $6B53
    ld b, $00                                     ; $6B54
    ld hl, wHotspotBlock                          ; $6B56
    add hl, bc                                    ; $6B59
    bit 0, [hl]                                   ; $6B5A
    jr nz, jr_003_6b6e                            ; $6B5C

    call HotSpotEd_NewSpot                        ; $6B5E
    next_state                                    ; $6B61
    ret                                           ; $6B65


jr_003_6b66:
    bit 1, a                                      ; $6B66
    jr nz, jr_003_6ba4                            ; $6B68

    call HotSpotEd_SlotMove                       ; $6B6A
    ret                                           ; $6B6D


jr_003_6b6e:
    ld a, [wHsSelected]                           ; $6B6E
    cp $05                                        ; $6B71
    ret nc                                        ; $6B73

    call Oam_ClearShadow                          ; $6B74
    rst Rst08_WaitVBlank                          ; $6B77
    farcopy Vram_CopyFromBank, Gfx_26_4880_Mode1A_State03_Browse, $8b00, $0400 ; $6B78
    farcopy Vram_CopyFromBank, Map_27_7B70_Mode1A_State03_Browse, $9c00, $0120 ; $6B86
    call HotSpotEd_LoadSpotFields                 ; $6B94
    xor a                                         ; $6B97
    ld [wDialogChoice], a                         ; $6B98
    call HotSpotEd_DialogSlideIn                  ; $6B9B
    set_state STATE_1A_EXIT_DIALOG                ; $6B9E
    ret                                           ; $6BA3


jr_003_6ba4:
    ld a, [wDirtyFlag]                            ; $6BA4
    and a                                         ; $6BA7
    jr z, jr_003_6bb0                             ; $6BA8

    set_state STATE_1A_SAVE_PREPARE               ; $6BAA
    ret                                           ; $6BAF


jr_003_6bb0:
    play_sfx1 SFX1_KEY_B                          ; $6BB0
    set_state STATE_1A_EXIT                       ; $6BB7
    ret                                           ; $6BBC


; C: initialises a new hot spot in the block (position 7
HotSpotEd_NewSpot::
    ld a, [wHsSelected]                           ; $6BBD
    ld c, a                                       ; $6BC0
    ld b, $00                                     ; $6BC1
    ld hl, wHotspotBlock + $5                     ; $6BC3
    add hl, bc                                    ; $6BC6
    ld a, $07                                     ; $6BC7
    ld [hl], a                                    ; $6BC9
    ld hl, wHotspotBlock + $a                     ; $6BCA
    add hl, bc                                    ; $6BCD
    ld a, $06                                     ; $6BCE
    ld [hl], a                                    ; $6BD0
    ld hl, wHotspotBlock                          ; $6BD1
    add hl, bc                                    ; $6BD4
    ld a, $01                                     ; $6BD5
    ld [hl], a                                    ; $6BD7
    ld a, $ff                                     ; $6BD8
    ld hl, wHotspotBlock + $f                     ; $6BDA
    add hl, bc                                    ; $6BDD
    ld [hl], a                                    ; $6BDE
    ld [wHsEditSound], a                          ; $6BDF
    ld hl, wHotspotBlock + $14                    ; $6BE2
    add hl, bc                                    ; $6BE5
    ld [hl], a                                    ; $6BE6
    ld [wHsEditEffect], a                         ; $6BE7
    ld hl, wHotspotBlock + $19                    ; $6BEA
    add hl, bc                                    ; $6BED
    ld [hl], a                                    ; $6BEE
    ld [wHsEditJump], a                           ; $6BEF
    xor a                                         ; $6BF2
    ld hl, wSpriteAnimFrame + $1                  ; $6BF3
    add hl, bc                                    ; $6BF6
    ld [hl], a                                    ; $6BF7
    ld hl, wSpriteAnimTick + $1                   ; $6BF8
    add hl, bc                                    ; $6BFB
    ld [hl], a                                    ; $6BFC
    ld a, $01                                     ; $6BFD
    ld [wDirtyFlag], a                            ; $6BFF
    ld [wHsIsNew], a                              ; $6C02
    ret                                           ; $6C05


; C: copies sound / effect / jump of the selected spot to the edit variables
HotSpotEd_LoadSpotFields::
    ld a, [wHsSelected]                           ; $6C06
    ld c, a                                       ; $6C09
    ld b, $00                                     ; $6C0A
    ld hl, wHotspotBlock + $f                     ; $6C0C
    add hl, bc                                    ; $6C0F
    ld a, [hl]                                    ; $6C10
    ld [wHsEditSound], a                          ; $6C11
    ld hl, wHotspotBlock + $14                    ; $6C14
    add hl, bc                                    ; $6C17
    ld a, [hl]                                    ; $6C18
    ld [wHsEditEffect], a                         ; $6C19
    ld hl, wHotspotBlock + $19                    ; $6C1C
    add hl, bc                                    ; $6C1F
    ld a, [hl]                                    ; $6C20
    ld [wHsEditJump], a                           ; $6C21
    xor a                                         ; $6C24
    ld [wHsIsNew], a                              ; $6C25
    ret                                           ; $6C28


; C: A opens the sound picker; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 04 (6412 hits in 16 runs:
; 1A:04 x6412; tcrf_check/assets/mode_state_wp/)
Mode1A_State04_PlaceOrDelete::
    call HotSpotEd_MoveSpot                       ; $6C29
    call HotSpotEd_DrawSlots                      ; $6C2C
    ldh a, [hKeysNew]                             ; $6C2F
    bit PADB_A, a                                 ; $6C31
    jr z, jr_003_6c79                             ; $6C33

    call Oam_ClearShadow                          ; $6C35
    rst Rst08_WaitVBlank                          ; $6C38
    farcopy Vram_CopyFromBank, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete, $8c30, $00c0 ; $6C39
    farcopy Vram_CopyFromBank, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete, $8da0, $0040 ; $6C47
    farcopy Vram_CopyFromBank, Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete, $8de0, $0200 ; $6C55
    farcopy Vram_CopyFromBank, Map_0E_7F00_Mode1A_State04_PlaceOrDelete, $9c00, $0120 ; $6C63
    call HotSpotEd_PickerSlideIn                  ; $6C71
    next_state                                    ; $6C74
    ret                                           ; $6C78


jr_003_6c79:
    bit 1, a                                      ; $6C79
    ret z                                         ; $6C7B

    ld a, [wHsSelected]                           ; $6C7C
    ld c, a                                       ; $6C7F
    ld b, $00                                     ; $6C80
    xor a                                         ; $6C82
    ld hl, wHotspotBlock                          ; $6C83
    add hl, bc                                    ; $6C86
    ld [hl], a                                    ; $6C87
    ld hl, wSpriteAnimFrame + $1                  ; $6C88
    add hl, bc                                    ; $6C8B
    ld [hl], a                                    ; $6C8C
    ld hl, wState                                 ; $6C8D
    dec [hl]                                      ; $6C90
    ret                                           ; $6C91


; C: picks the sound of the hot spot
Mode1A_State05_PickSound::
    ld a, [wHsSelected]                           ; $6C92
    ld c, a                                       ; $6C95
    ld b, $00                                     ; $6C96
    ld hl, wHotspotBlock + $f                     ; $6C98
    add hl, bc                                    ; $6C9B
    ld d, $40                                     ; $6C9C
    call HotSpotEd_PickerScroll                   ; $6C9E
    call nz, HotSpotEd_ShowSound                  ; $6CA1
    ld bc, $1f78                                  ; $6CA4
    call HotSpotEd_DrawArrows                     ; $6CA7
    call HotSpotEd_DrawSoundIcon                  ; $6CAA
    call HotSpotEd_DrawEffectIcon                 ; $6CAD
    call HotSpotEd_DrawJumpIcon                   ; $6CB0
    call HotSpotEd_DrawButtonIcon                 ; $6CB3
    ld a, [wPickerScrollPhase]                    ; $6CB6
    and a                                         ; $6CB9
    ret nz                                        ; $6CBA

    ldh a, [hKeysNew]                             ; $6CBB
    and PADF_A | PADF_RIGHT                       ; $6CBD
    jr z, jr_003_6ccd                             ; $6CBF

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6CC1
    next_state                                    ; $6CC8
    ret                                           ; $6CCC


jr_003_6ccd:
    ldh a, [hKeysNew]                             ; $6CCD
    bit PADB_B, a                                 ; $6CCF
    ret z                                         ; $6CD1

    call HotSpotEd_StoreSpotFields                ; $6CD2
    jr z, jr_003_6cde                             ; $6CD5

    set_state STATE_1A_PLACE_OR_DELETE            ; $6CD7
    jr jr_003_6ce3                                ; $6CDC

jr_003_6cde:
    set_state STATE_1A_BROWSE                     ; $6CDE

jr_003_6ce3:
    call HotSpotEd_PickerSlideOut                 ; $6CE3
    ret                                           ; $6CE6


; C: copies the edit variables back to the block; Z if the spot is not new
HotSpotEd_StoreSpotFields::
    ld a, [wHsSelected]                           ; $6CE7
    ld c, a                                       ; $6CEA
    ld b, $00                                     ; $6CEB
    ld hl, wHotspotBlock + $f                     ; $6CED
    add hl, bc                                    ; $6CF0
    ld a, [wHsEditSound]                          ; $6CF1
    ld [hl], a                                    ; $6CF4
    ld hl, wHotspotBlock + $14                    ; $6CF5
    add hl, bc                                    ; $6CF8
    ld a, [wHsEditEffect]                         ; $6CF9
    ld [hl], a                                    ; $6CFC
    ld hl, wHotspotBlock + $19                    ; $6CFD
    add hl, bc                                    ; $6D00
    ld a, [wHsEditJump]                           ; $6D01
    ld [hl], a                                    ; $6D04
    ld a, [wHsIsNew]                              ; $6D05
    and a                                         ; $6D08
    ret                                           ; $6D09


; C: picks the transition effect 0..7
Mode1A_State06_PickEffect::
    ld a, [wHsSelected]                           ; $6D0A
    ld c, a                                       ; $6D0D
    ld b, $00                                     ; $6D0E
    ld hl, wHotspotBlock + $14                    ; $6D10
    add hl, bc                                    ; $6D13
    ld d, $07                                     ; $6D14
    call HotSpotEd_PickerScroll                   ; $6D16
    call nz, HotSpotEd_ShowEffect                 ; $6D19
    ld bc, $3f78                                  ; $6D1C
    call HotSpotEd_DrawArrows                     ; $6D1F
    call HotSpotEd_DrawSoundIcon                  ; $6D22
    call HotSpotEd_DrawEffectIcon                 ; $6D25
    call HotSpotEd_DrawJumpIcon                   ; $6D28
    call HotSpotEd_DrawButtonIcon                 ; $6D2B
    ld a, [wPickerScrollPhase]                    ; $6D2E
    and a                                         ; $6D31
    ret nz                                        ; $6D32

    ldh a, [hKeysNew]                             ; $6D33
    and PADF_A | PADF_RIGHT                       ; $6D35
    jr z, jr_003_6d45                             ; $6D37

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6D39
    next_state                                    ; $6D40
    ret                                           ; $6D44


jr_003_6d45:
    ldh a, [hKeysNew]                             ; $6D45
    and PADF_B | PADF_LEFT                        ; $6D47
    ret z                                         ; $6D49

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6D4A
    ld hl, wState                                 ; $6D51
    dec [hl]                                      ; $6D54
    ret                                           ; $6D55


; C: picks the JUMP target photo
Mode1A_State07_PickJump::
    ld a, [wHsSelected]                           ; $6D56
    ld c, a                                       ; $6D59
    ld b, $00                                     ; $6D5A
    ld hl, wHotspotBlock + $19                    ; $6D5C
    add hl, bc                                    ; $6D5F
    ld a, [wPhotoCount]                           ; $6D60
    ld d, a                                       ; $6D63
    call HotSpotEd_PickerScroll                   ; $6D64
    call nz, HotSpotEd_ShowJump                   ; $6D67
    ld bc, $6778                                  ; $6D6A
    call HotSpotEd_DrawArrows                     ; $6D6D
    call HotSpotEd_DrawSoundIcon                  ; $6D70
    call HotSpotEd_DrawEffectIcon                 ; $6D73
    call HotSpotEd_DrawJumpIcon                   ; $6D76
    call HotSpotEd_DrawButtonIcon                 ; $6D79
    ld a, [wPickerScrollPhase]                    ; $6D7C
    and a                                         ; $6D7F
    ret nz                                        ; $6D80

    ldh a, [hKeysNew]                             ; $6D81
    and PADF_A | PADF_RIGHT                       ; $6D83
    jr z, jr_003_6d98                             ; $6D85

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6D87
    ld a, $01                                     ; $6D8E
    ld [wPickerButtonAnim], a                     ; $6D90
    next_state                                    ; $6D93
    ret                                           ; $6D97


jr_003_6d98:
    ldh a, [hKeysNew]                             ; $6D98
    and PADF_B | PADF_LEFT                        ; $6D9A
    ret z                                         ; $6D9C

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6D9D
    ld hl, wState                                 ; $6DA4
    dec [hl]                                      ; $6DA7
    ret                                           ; $6DA8


; C: A confirms with the button animation; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 08 (1120 hits
; in 5 runs: 1A:08 x1120; tcrf_check/assets/mode_state_wp/)
Mode1A_State08_PickConfirm::
    call HotSpotEd_DrawSoundIcon                  ; $6DA9
    call HotSpotEd_DrawEffectIcon                 ; $6DAC
    call HotSpotEd_DrawJumpIcon                   ; $6DAF
    call HotSpotEd_DrawButtonIcon                 ; $6DB2
    ldh a, [hKeysNew]                             ; $6DB5
    bit PADB_A, a                                 ; $6DB7
    jr z, jr_003_6deb                             ; $6DB9

    play_sfx1 SFX1_KEY_A                          ; $6DBB
    call Oam_HideUnused                           ; $6DC2
    rst Rst08_WaitVBlank                          ; $6DC5
    ld b, $0c                                     ; $6DC6

jr_003_6dc8:
    push bc                                       ; $6DC8
    ld a, $02                                     ; $6DC9
    ld [wPickerButtonAnim], a                     ; $6DCB
    call HotSpotEd_DrawSoundIcon                  ; $6DCE
    call HotSpotEd_DrawEffectIcon                 ; $6DD1
    call HotSpotEd_DrawJumpIcon                   ; $6DD4
    call HotSpotEd_DrawButtonIcon                 ; $6DD7
    call Oam_HideUnused                           ; $6DDA
    rst Rst08_WaitVBlank                          ; $6DDD
    pop bc                                        ; $6DDE
    dec b                                         ; $6DDF
    jr nz, jr_003_6dc8                            ; $6DE0

    call HotSpotEd_PickerSlideOut                 ; $6DE2
    set_state STATE_1A_BROWSE                     ; $6DE5
    ret                                           ; $6DEA


jr_003_6deb:
    ldh a, [hKeysNew]                             ; $6DEB
    and PADF_B | PADF_LEFT                        ; $6DED
    ret z                                         ; $6DEF

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6DF0
    xor a                                         ; $6DF7
    ld [wPickerButtonAnim], a                     ; $6DF8
    ld hl, wState                                 ; $6DFB
    dec [hl]                                      ; $6DFE
    ret                                           ; $6DFF


; C: keep / discard dialog; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 09 (1368 hits in 2 runs:
; 1A:09 x1368; tcrf_check/assets/mode_state_wp/)
Mode1A_State09_ExitDialog::
    call HotSpotEd_DialogChoiceA                  ; $6E00
    ldh a, [hKeysNew]                             ; $6E03
    bit PADB_A, a                                 ; $6E05
    jp z, Mode1A_State09_ExitDialog_Cancel        ; $6E07

    ld a, [wDialogChoice]                         ; $6E0A
    and a                                         ; $6E0D
    jr nz, jr_003_6e59                            ; $6E0E

    call HotSpotEd_DialogSlideOut                 ; $6E10
    farcopy Vram_CopyFromBank, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete, $8c30, $00c0 ; $6E13
    farcopy Vram_CopyFromBank, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete, $8da0, $0040 ; $6E21
    farcopy Vram_CopyFromBank, Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete, $8de0, $0200 ; $6E2F
    farcopy Vram_CopyFromBank, Map_0E_7F00_Mode1A_State04_PlaceOrDelete, $9c00, $0120 ; $6E3D
    call HotSpotEd_PickerSlideIn                  ; $6E4B
    set_state STATE_1A_PICK_SOUND                 ; $6E4E
    ld a, $01                                     ; $6E53
    ld [wDirtyFlag], a                            ; $6E55
    ret                                           ; $6E58


jr_003_6e59:
    call HotSpotEd_DialogSlideOut                 ; $6E59
    farcopy Vram_CopyFromBank, Gfx_23_60C0_Mode1A_State09_ExitDialog, $8b00, $0400 ; $6E5C
    farcopy Vram_CopyFromBank, Map_27_7A50_Mode1A_State09_ExitDialog, $9c00, $0120 ; $6E6A
    farcopy Vram_CopyFromBank, Map_27_7B30_Mode1A_State09_ExitDialog, $9c80, $0040 ; $6E78
    ld a, $01                                     ; $6E86
    ld [wDialogChoice], a                         ; $6E88
    call HotSpotEd_DialogSlideIn                  ; $6E8B
    set_state STATE_1A_DELETE_DIALOG              ; $6E8E
    ret                                           ; $6E93


; C: bit 1 of $FFA2 (B): slides the dialog out and returns to state 3 (branch target; code read 2026-10-19)
Mode1A_State09_ExitDialog_Cancel::
    bit 1, a                                      ; $6E94
    ret z                                         ; $6E96

    call HotSpotEd_DialogSlideOut                 ; $6E97
    set_state STATE_1A_BROWSE                     ; $6E9A
    ret                                           ; $6E9F


; C: Left / Right toggles dialog_choice and swaps the dialog tiles. L3 pass 2026-10-26: executed in BGB in 2 replay(s)
; of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DialogChoiceA::
    ldh a, [hKeysNew]                             ; $6EA0
    ld b, a                                       ; $6EA2
    bit PADB_LEFT, a                              ; $6EA3
    jr z, jr_003_6eaa                             ; $6EA5

    xor a                                         ; $6EA7
    jr jr_003_6eaf                                ; $6EA8

jr_003_6eaa:
    bit 4, a                                      ; $6EAA
    ret z                                         ; $6EAC

    ld a, $01                                     ; $6EAD

jr_003_6eaf:
    ld hl, wDialogChoice                          ; $6EAF
    cp [hl]                                       ; $6EB2
    ret z                                         ; $6EB3

    ld [hl], a                                    ; $6EB4
    play_sfx1 SFX1_STEP_FAST                      ; $6EB5
    and a                                         ; $6EBC
    jr nz, jr_003_6ece                            ; $6EBD

    farcopy Vram_CopyFromBank, Map_27_7BF0_HotSpotEd_DialogChoiceA, $9c80, $0040 ; $6EBF
    ret                                           ; $6ECD


jr_003_6ece:
    farcopy Vram_CopyFromBank, Map_27_7C50_HotSpotEd_DialogChoiceA, $9c80, $0040 ; $6ECE
    ret                                           ; $6EDC


; C: delete this hot spot? dialog; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 0A (252 hits in 1
; runs: 1A:0A x252; tcrf_check/assets/mode_state_wp/)
Mode1A_State0A_DeleteDialog::
    call HotSpotEd_DialogChoiceB                  ; $6EDD
    ldh a, [hKeysNew]                             ; $6EE0
    bit PADB_A, a                                 ; $6EE2
    jr z, jr_003_6f18                             ; $6EE4

    ld a, [wDialogChoice]                         ; $6EE6
    and a                                         ; $6EE9
    jr nz, jr_003_6f24                            ; $6EEA

    play_sfx3 SFX3_DELETE_DIALOG_FIRST            ; $6EEC
    ld bc, $000a                                  ; $6EF3
    call Wait_Frames                              ; $6EF6
    call HotSpotEd_DialogSlideOut                 ; $6EF9
    ld a, [wHsSelected]                           ; $6EFC
    ld c, a                                       ; $6EFF
    ld b, $00                                     ; $6F00
    xor a                                         ; $6F02
    ld hl, wHotspotBlock                          ; $6F03
    add hl, bc                                    ; $6F06
    ld [hl], a                                    ; $6F07
    ld hl, wSpriteAnimFrame + $1                  ; $6F08
    add hl, bc                                    ; $6F0B
    ld [hl], a                                    ; $6F0C
    set_state STATE_1A_BROWSE                     ; $6F0D
    ld a, $01                                     ; $6F12
    ld [wDirtyFlag], a                            ; $6F14
    ret                                           ; $6F17


jr_003_6f18:
    bit 1, a                                      ; $6F18
    ret z                                         ; $6F1A

    call HotSpotEd_DialogSlideOut                 ; $6F1B
    set_state STATE_1A_BROWSE                     ; $6F1E
    ret                                           ; $6F23


jr_003_6f24:
    play_sfx3 SFX3_DELETE_DIALOG_SECOND           ; $6F24
    ld bc, $000a                                  ; $6F2B
    call Wait_Frames                              ; $6F2E
    call HotSpotEd_DialogSlideOut                 ; $6F31
    set_state STATE_1A_BROWSE                     ; $6F34
    ret                                           ; $6F39


; C: same for the delete dialog. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogChoiceB::
    ldh a, [hKeysNew]                             ; $6F3A
    ld b, a                                       ; $6F3C
    bit PADB_LEFT, a                              ; $6F3D
    jr z, jr_003_6f44                             ; $6F3F

    xor a                                         ; $6F41
    jr jr_003_6f49                                ; $6F42

jr_003_6f44:
    bit 4, a                                      ; $6F44
    ret z                                         ; $6F46

    ld a, $01                                     ; $6F47

jr_003_6f49:
    ld hl, wDialogChoice                          ; $6F49
    cp [hl]                                       ; $6F4C
    ret z                                         ; $6F4D

    ld [hl], a                                    ; $6F4E
    play_sfx1 SFX1_STEP_FAST                      ; $6F4F
    and a                                         ; $6F56
    jr nz, jr_003_6f68                            ; $6F57

    farcopy Vram_CopyFromBank, Map_27_7AD0_HotSpotEd_DialogChoiceB, $9c80, $0040 ; $6F59
    ret                                           ; $6F67


jr_003_6f68:
    farcopy Vram_CopyFromBank, Map_27_7B30_Mode1A_State09_ExitDialog, $9c80, $0040 ; $6F68
    ret                                           ; $6F76


; C: ret
Mode1A_State0B_Unused::
    ret                                           ; $6F77


; C: fades out and returns to state 0
Mode1A_State0C_Exit::
    screen_off                                    ; $6F78
    stat_irq_off                                  ; $6F7E
    set_state STATE_1A_INIT                       ; $6F88
    ret                                           ; $6F8D


; C: selects the save dialog parameters
Mode1A_State0D_SavePrepare::
    ld a, $02                                     ; $6F8E
    ld [wSaveDialogWhat], a                       ; $6F90
    ld a, [wCopyPhotoIdxE]                        ; $6F93
    ld [wSaveTargetPhoto], a                      ; $6F96
    xor a                                         ; $6F99
    ld [wSubstate], a                             ; $6F9A
    next_state                                    ; $6F9D
    ret                                           ; $6FA1


; C: far call 07:699C (save routine)
Mode1A_State0E_FarSaveRoutine::
    ldh [hFarcallAArg], a                         ; $6FA2
    farcall SaveDialog_Far                        ; $6FA4
    ret                                           ; $6FAC


; C: back to browsing or exit
Mode1A_State0F_SaveResult::
    ld a, [wSaveDialogResult]                     ; $6FAD
    and a                                         ; $6FB0
    jr nz, jr_003_6fb9                            ; $6FB1

    set_state STATE_1A_EXIT                       ; $6FB3
    ret                                           ; $6FB8


jr_003_6fb9:
    set_state STATE_1A_BROWSE                     ; $6FB9
    ret                                           ; $6FBE


; C: draws the five hot-spot slot sprites (blinking when not selected)
HotSpotEd_DrawSlots::
    ld a, [wHsSelected]                           ; $6FBF
    cp $ff                                        ; $6FC2
    jr nz, jr_003_6fc7                            ; $6FC4

    xor a                                         ; $6FC6

jr_003_6fc7:
    ld c, a                                       ; $6FC7
    ld b, $05                                     ; $6FC8

; C: per-slot loop top (B counts the slots, C the slot number): draws the slot icon when it is the cursor slot or its
; flag is set (branch target; code read 2026-10-19)
HotSpotEd_DrawSlots_SlotLoop::
    push bc                                       ; $6FCA
    ld b, $00                                     ; $6FCB
    ld de, $0000                                  ; $6FCD
    ld a, [wHsSelected]                           ; $6FD0
    cp c                                          ; $6FD3
    jr z, jr_003_6fdd                             ; $6FD4

    ldh a, [hFrameCounter]                        ; $6FD6
    xor c                                         ; $6FD8
    and $01                                       ; $6FD9
    jr z, jr_003_702e                             ; $6FDB

jr_003_6fdd:
    ld hl, wHotspotBlock                          ; $6FDD
    add hl, bc                                    ; $6FE0
    bit 0, [hl]                                   ; $6FE1
    call nz, HotSpotEd_SlotIconFlags              ; $6FE3
    ld hl, HotSpotEd_SlotAnimTbl                  ; $6FE6
    add hl, de                                    ; $6FE9
    ld e, [hl]                                    ; $6FEA
    add hl, de                                    ; $6FEB
    push hl                                       ; $6FEC
    ld hl, wSpriteAnimFrame + $1                  ; $6FED
    add hl, bc                                    ; $6FF0
    ld e, [hl]                                    ; $6FF1
    sla e                                         ; $6FF2
    pop hl                                        ; $6FF4
    add hl, de                                    ; $6FF5
    ld a, [hl+]                                   ; $6FF6
    push hl                                       ; $6FF7
    push bc                                       ; $6FF8
    push af                                       ; $6FF9
    call HotSpotEd_SlotXY                         ; $6FFA
    pop af                                        ; $6FFD
    call Oam_AddMeta_B01_4000                     ; $6FFE
    pop bc                                        ; $7001
    ld hl, wSpriteAnimTick + $1                   ; $7002
    add hl, bc                                    ; $7005
    ld a, [hl]                                    ; $7006
    pop hl                                        ; $7007
    cp [hl]                                       ; $7008
    jr c, jr_003_7029                             ; $7009

    inc hl                                        ; $700B
    ld a, [hl]                                    ; $700C
    cp $ff                                        ; $700D
    jr nz, jr_003_701e                            ; $700F

    xor a                                         ; $7011
    ld hl, wSpriteAnimFrame + $1                  ; $7012
    add hl, bc                                    ; $7015
    ld [hl], a                                    ; $7016
    ld hl, wSpriteAnimTick + $1                   ; $7017
    add hl, bc                                    ; $701A
    ld [hl], a                                    ; $701B
    jr jr_003_7029                                ; $701C

jr_003_701e:
    ld hl, wSpriteAnimFrame + $1                  ; $701E
    add hl, bc                                    ; $7021
    inc [hl]                                      ; $7022
    xor a                                         ; $7023
    ld hl, wSpriteAnimTick + $1                   ; $7024
    add hl, bc                                    ; $7027
    ld [hl], a                                    ; $7028

jr_003_7029:
    ld hl, wSpriteAnimTick + $1                   ; $7029
    add hl, bc                                    ; $702C
    inc [hl]                                      ; $702D

jr_003_702e:
    pop bc                                        ; $702E
    ld a, c                                       ; $702F
    inc a                                         ; $7030
    cp $05                                        ; $7031
    jr nz, jr_003_7036                            ; $7033

    xor a                                         ; $7035

jr_003_7036:
    ld c, a                                       ; $7036
    dec b                                         ; $7037
    jp nz, HotSpotEd_DrawSlots_SlotLoop           ; $7038

    ret                                           ; $703B


; C: E = bit mask of the fields (sound / effect / jump) that are set. L3 pass 2026-10-26: executed in BGB in 8
; replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotIconFlags::
    ld hl, wHotspotBlock + $f                     ; $703C
    add hl, bc                                    ; $703F
    ld a, [hl]                                    ; $7040
    cp $ff                                        ; $7041
    jr z, jr_003_7047                             ; $7043

    set 0, e                                      ; $7045

jr_003_7047:
    ld hl, wHotspotBlock + $14                    ; $7047
    add hl, bc                                    ; $704A
    ld a, [hl]                                    ; $704B
    cp $ff                                        ; $704C
    jr z, jr_003_7052                             ; $704E

    set 1, e                                      ; $7050

jr_003_7052:
    ld hl, wHotspotBlock + $19                    ; $7052
    add hl, bc                                    ; $7055
    ld a, [hl]                                    ; $7056
    cp $ff                                        ; $7057
    jr z, jr_003_705d                             ; $7059

    set 2, e                                      ; $705B

jr_003_705d:
    ret                                           ; $705D


; C: B / C = screen position of slot C. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus,
; modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotXY::
    ld hl, wHotspotBlock                          ; $705E
    add hl, bc                                    ; $7061
    bit 0, [hl]                                   ; $7062
    jr z, jr_003_7083                             ; $7064

    ld hl, wHotspotBlock + $5                     ; $7066
    add hl, bc                                    ; $7069
    ld a, [hl]                                    ; $706A
    sla a                                         ; $706B
    sla a                                         ; $706D
    sla a                                         ; $706F
    add $18                                       ; $7071
    ld hl, wHotspotBlock + $a                     ; $7073
    add hl, bc                                    ; $7076
    ld b, a                                       ; $7077
    ld a, [hl]                                    ; $7078
    sla a                                         ; $7079
    sla a                                         ; $707B
    sla a                                         ; $707D
    add $18                                       ; $707F
    ld c, a                                       ; $7081
    ret                                           ; $7082


jr_003_7083:
    ld a, c                                       ; $7083
    sla a                                         ; $7084
    add c                                         ; $7086
    sla a                                         ; $7087
    sla a                                         ; $7089
    sla a                                         ; $708B
    add $20                                       ; $708D
    ld b, a                                       ; $708F
    ld c, $88                                     ; $7090
    ret                                           ; $7092


; C: sprite animation lists per slot state. L3 pass 2026-10-26: read in BGB in 10 replay(s) of the organic corpus,
; modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotAnimTbl::
    db $08, $0a, $14, $1e, $28, $36, $4c, $62, $c4, $06, $ff, $be, $06, $c6, $06, $c7
    db $06, $c6, $06, $c7, $06, $ff, $c4, $06, $c5, $06, $c4, $06, $be, $06, $be, $06
    db $ff, $c8, $06, $c9, $06, $be, $06, $c8, $06, $c9, $06, $ff, $be, $1f, $bf, $08
    db $c0, $06, $c1, $06, $c0, $06, $c2, $08, $c3, $08, $ff, $bf, $08, $c0, $06, $c1
    db $06, $c0, $06, $c2, $08, $c3, $08, $be, $06, $c6, $06, $c7, $06, $c6, $06, $c7
    db $06, $ff, $bf, $08, $c0, $06, $c1, $06, $c0, $06, $c2, $08, $c3, $08, $c4, $06
    db $c5, $06, $c4, $06, $be, $06, $be, $06, $ff, $bf, $08, $c0, $06, $c1, $06, $c0
    db $06, $c2, $08, $c3, $08, $c8, $06, $c9, $06, $be, $06, $c8, $06, $c9, $06, $ff

; C: animated pointer at (cursor_x
HotSpotEd_DrawPointer::
    ld a, [wHsCursorX]                            ; $7113
    sla a                                         ; $7116
    sla a                                         ; $7118
    sla a                                         ; $711A
    add $18                                       ; $711C
    ld b, a                                       ; $711E
    ld a, [wHsCursorY]                            ; $711F
    sla a                                         ; $7122
    sla a                                         ; $7124
    sla a                                         ; $7126
    add $20                                       ; $7128
    ld c, a                                       ; $712A
    ld a, [wSpriteAnimFrame]                      ; $712B
    sla a                                         ; $712E
    ld e, a                                       ; $7130
    ld d, $00                                     ; $7131
    ld hl, HotSpotEd_DrawPointer_Tbl7156          ; $7133
    add hl, de                                    ; $7136
    ld a, [hl+]                                   ; $7137
    call Oam_AddMeta_B01_4000                     ; $7138
    ld a, [wSpriteAnimTick]                       ; $713B
    cp [hl]                                       ; $713E
    jr nz, jr_003_7149                            ; $713F

    ld hl, wSpriteAnimFrame                       ; $7141
    inc [hl]                                      ; $7144
    xor a                                         ; $7145
    ld [wSpriteAnimTick], a                       ; $7146

jr_003_7149:
    ld a, [wSpriteAnimFrame]                      ; $7149
    and a                                         ; $714C
    ret z                                         ; $714D

    cp $03                                        ; $714E
    ret z                                         ; $7150

    ld hl, wSpriteAnimTick                        ; $7151
    inc [hl]                                      ; $7154
    ret                                           ; $7155


; C: auto: 8 bytes, bytes; referenced by HotSpotEd_DrawPointer. L3 pass 2026-10-26: read in BGB in 9 replay(s) of the
; organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawPointer_Tbl7156::
    db $a0, $06, $a1, $06, $9f, $06, $9f, $ff

; C: animated pointer in slot-selection mode
HotSpotEd_DrawSlotPointer::
    ld a, [wHsCursorX]                            ; $715E
    ld b, a                                       ; $7161
    sla a                                         ; $7162
    add b                                         ; $7164
    sla a                                         ; $7165
    sla a                                         ; $7167
    sla a                                         ; $7169
    add $20                                       ; $716B
    ld b, a                                       ; $716D
    ld c, $7a                                     ; $716E
    ld a, [wSpriteAnimFrame]                      ; $7170
    sla a                                         ; $7173
    ld e, a                                       ; $7175
    ld d, $00                                     ; $7176
    ld hl, HotSpotEd_DrawSlotPointer_Tbl719B      ; $7178
    add hl, de                                    ; $717B
    ld a, [hl+]                                   ; $717C
    call Oam_AddMeta_B01_4000                     ; $717D
    ld a, [wSpriteAnimTick]                       ; $7180
    cp [hl]                                       ; $7183
    jr nz, jr_003_718e                            ; $7184

    ld hl, wSpriteAnimFrame                       ; $7186
    inc [hl]                                      ; $7189
    xor a                                         ; $718A
    ld [wSpriteAnimTick], a                       ; $718B

jr_003_718e:
    ld a, [wSpriteAnimFrame]                      ; $718E
    and a                                         ; $7191
    ret z                                         ; $7192

    cp $03                                        ; $7193
    ret z                                         ; $7195

    ld hl, wSpriteAnimTick                        ; $7196
    inc [hl]                                      ; $7199
    ret                                           ; $719A


; C: auto: 8 bytes, bytes; referenced by HotSpotEd_DrawSlotPointer. L3 pass 2026-10-26: read in BGB in 10 replay(s) of
; the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawSlotPointer_Tbl719B::
    db $bc, $06, $bd, $06, $bb, $06, $bb, $ff

; C: D-pad moves the pointer; Down at the bottom switches to slot selection
HotSpotEd_PointerMove::
    ldh a, [hKeysNewRepeat]                       ; $71A3
    ld b, a                                       ; $71A5
    ld a, [wHsCursorX]                            ; $71A6
    call HotSpotEd_PointerMoveX                   ; $71A9
    ld [wHsCursorX], a                            ; $71AC
    ld a, [wHsCursorY]                            ; $71AF
    call HotSpotEd_PointerMoveY                   ; $71B2
    ld [wHsCursorY], a                            ; $71B5
    ld a, $ff                                     ; $71B8
    ld [wHsSelected], a                           ; $71BA
    ld a, [wHsCursorMode]                         ; $71BD
    and a                                         ; $71C0
    ret z                                         ; $71C1

    ld a, [wHsCursorX]                            ; $71C2
    ld c, $00                                     ; $71C5

jr_003_71c7:
    cp $03                                        ; $71C7
    jr c, jr_003_71d0                             ; $71C9

    sub $03                                       ; $71CB
    inc c                                         ; $71CD
    jr jr_003_71c7                                ; $71CE

jr_003_71d0:
    ld a, c                                       ; $71D0
    ld [wHsCursorX], a                            ; $71D1
    ret                                           ; $71D4


; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PointerMoveX::
    bit 5, b                                      ; $71D5
    jr z, jr_003_71e4                             ; $71D7

    and a                                         ; $71D9
    ret z                                         ; $71DA

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $71DB
    dec a                                         ; $71E2
    ret                                           ; $71E3


jr_003_71e4:
    bit 4, b                                      ; $71E4
    ret z                                         ; $71E6

    cp $0e                                        ; $71E7
    ret z                                         ; $71E9

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $71EA
    inc a                                         ; $71F1
    ret                                           ; $71F2


; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PointerMoveY::
    bit 6, b                                      ; $71F3
    jr z, jr_003_7202                             ; $71F5

    and a                                         ; $71F7
    ret z                                         ; $71F8

    dec a                                         ; $71F9
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $71FA
    ret                                           ; $7201


jr_003_7202:
    bit 7, b                                      ; $7202
    ret z                                         ; $7204

    cp $0c                                        ; $7205
    jr z, jr_003_7212                             ; $7207

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7209
    inc a                                         ; $7210
    ret                                           ; $7211


jr_003_7212:
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7212
    push af                                       ; $7219
    ld a, $01                                     ; $721A
    ld [wHsCursorMode], a                         ; $721C
    pop af                                        ; $721F
    ret                                           ; $7220


; C: Left / Right selects the slot
HotSpotEd_SlotMove::
    ldh a, [hKeysNewRepeat]                       ; $7221
    ld b, a                                       ; $7223
    ld a, [wHsCursorX]                            ; $7224
    call HotSpotEd_SlotMoveX                      ; $7227
    ld [wHsCursorX], a                            ; $722A
    ld [wHsSelected], a                           ; $722D
    call HotSpotEd_SlotMoveUp                     ; $7230
    ld a, [wHsCursorMode]                         ; $7233
    and a                                         ; $7236
    ret nz                                        ; $7237

    ld a, [wHsCursorX]                            ; $7238
    ld c, a                                       ; $723B
    sla a                                         ; $723C
    add c                                         ; $723E
    inc a                                         ; $723F
    ld [wHsCursorX], a                            ; $7240
    ret                                           ; $7243


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotMoveX::
    bit 5, b                                      ; $7244
    jr z, jr_003_7253                             ; $7246

    and a                                         ; $7248
    ret z                                         ; $7249

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $724A
    dec a                                         ; $7251
    ret                                           ; $7252


jr_003_7253:
    bit 4, b                                      ; $7253
    ret z                                         ; $7255

    cp $04                                        ; $7256
    ret z                                         ; $7258

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7259
    inc a                                         ; $7260
    ret                                           ; $7261


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotMoveUp::
    bit 6, b                                      ; $7262
    ret z                                         ; $7264

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7265
    xor a                                         ; $726C
    ld [wHsCursorMode], a                         ; $726D
    ret                                           ; $7270


; C: D-pad moves the selected spot over the photo
HotSpotEd_MoveSpot::
    ldh a, [hKeysNewRepeat]                       ; $7271
    ld b, a                                       ; $7273
    ld a, [wHsSelected]                           ; $7274
    ld e, a                                       ; $7277
    ld d, $00                                     ; $7278
    ld hl, wHotspotBlock + $5                     ; $727A
    add hl, de                                    ; $727D
    ld a, [hl]                                    ; $727E
    call HotSpotEd_MoveSpotX                      ; $727F
    ld [hl], a                                    ; $7282
    ld hl, wHotspotBlock + $a                     ; $7283
    add hl, de                                    ; $7286
    ld a, [hl]                                    ; $7287
    call HotSpotEd_MoveSpotY                      ; $7288
    ld [hl], a                                    ; $728B
    ret                                           ; $728C


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_MoveSpotX::
    bit 5, b                                      ; $728D
    jr z, jr_003_729c                             ; $728F

    and a                                         ; $7291
    ret z                                         ; $7292

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7293
    dec a                                         ; $729A
    ret                                           ; $729B


jr_003_729c:
    bit 4, b                                      ; $729C
    ret z                                         ; $729E

    cp $0e                                        ; $729F
    ret z                                         ; $72A1

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $72A2
    inc a                                         ; $72A9
    ret                                           ; $72AA


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_MoveSpotY::
    bit 6, b                                      ; $72AB
    jr z, jr_003_72ba                             ; $72AD

    and a                                         ; $72AF
    ret z                                         ; $72B0

    dec a                                         ; $72B1
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $72B2
    ret                                           ; $72B9


jr_003_72ba:
    bit 7, b                                      ; $72BA
    ret z                                         ; $72BC

    cp $0c                                        ; $72BD
    ret z                                         ; $72BF

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $72C0
    inc a                                         ; $72C7
    ret                                           ; $72C8


; C: carry and C = index when a spot is at the pointer position
HotSpot_FindUnderPointer::
    ld bc, $0500                                  ; $72C9

jr_003_72cc:
    push bc                                       ; $72CC
    ld b, $00                                     ; $72CD
    ld hl, wHotspotBlock                          ; $72CF
    add hl, bc                                    ; $72D2
    ld a, [hl]                                    ; $72D3
    and a                                         ; $72D4
    jr z, jr_003_72ee                             ; $72D5

    ld hl, wHotspotBlock + $5                     ; $72D7
    add hl, bc                                    ; $72DA
    ld a, [wHsCursorX]                            ; $72DB
    cp [hl]                                       ; $72DE
    jr nz, jr_003_72ee                            ; $72DF

    ld hl, wHotspotBlock + $a                     ; $72E1
    add hl, bc                                    ; $72E4
    ld a, [wHsCursorY]                            ; $72E5
    cp [hl]                                       ; $72E8
    jr nz, jr_003_72ee                            ; $72E9

    pop bc                                        ; $72EB
    scf                                           ; $72EC
    ret                                           ; $72ED


jr_003_72ee:
    pop bc                                        ; $72EE
    inc c                                         ; $72EF
    dec b                                         ; $72F0
    jr nz, jr_003_72cc                            ; $72F1

    and a                                         ; $72F3
    ret                                           ; $72F4


; C: slides the picker window out (WY table 00:2FE5) keeping the icons drawn
HotSpotEd_PickerSlideOut::
    play_music MUSIC_STOP                         ; $72F5
    rst Rst08_WaitVBlank                          ; $72FC
    play_sfx1 SFX1_PANEL_OPEN                     ; $72FD
    ld hl, Slide_WyDeltaTbl                       ; $7304
    ld b, $24                                     ; $7307

jr_003_7309:
    push bc                                       ; $7309
    push hl                                       ; $730A
    ldh a, [hWyShadow]                            ; $730B
    add [hl]                                      ; $730D
    ldh [hWyShadow], a                            ; $730E
    call HotSpotEd_DrawSoundIcon                  ; $7310
    call HotSpotEd_DrawEffectIcon                 ; $7313
    call HotSpotEd_DrawJumpIcon                   ; $7316
    call HotSpotEd_DrawButtonIcon                 ; $7319
    call Oam_HideUnused                           ; $731C
    rst Rst08_WaitVBlank                          ; $731F
    pop hl                                        ; $7320
    pop bc                                        ; $7321
    inc hl                                        ; $7322
    dec b                                         ; $7323
    jr nz, jr_003_7309                            ; $7324

    call HotSpotEd_ClearAnim                      ; $7326
    ret                                           ; $7329


; I: draws the three pickers and slides the window in
HotSpotEd_PickerSlideIn::
    xor a                                         ; $732A
    ld [wPickerScrollPhase], a                    ; $732B
    ld [wPickerDir], a                            ; $732E
    ld [wPickerButtonAnim], a                     ; $7331
    call Call_003_7467                            ; $7334
    call HotSpotEd_ShowEffect                     ; $7337
    call HotSpotEd_ShowJump                       ; $733A
    play_sfx1 SFX1_PANEL_CLOSE                    ; $733D
    ld hl, Slide_WyDeltaTbl                       ; $7344
    ld b, $24                                     ; $7347

jr_003_7349:
    push bc                                       ; $7349
    push hl                                       ; $734A
    ldh a, [hWyShadow]                            ; $734B
    sub [hl]                                      ; $734D
    ldh [hWyShadow], a                            ; $734E
    call HotSpotEd_DrawSoundIcon                  ; $7350
    call HotSpotEd_DrawEffectIcon                 ; $7353
    call HotSpotEd_DrawJumpIcon                   ; $7356
    call HotSpotEd_DrawButtonIcon                 ; $7359
    call Oam_HideUnused                           ; $735C
    rst Rst08_WaitVBlank                          ; $735F
    pop hl                                        ; $7360
    pop bc                                        ; $7361
    inc hl                                        ; $7362
    dec b                                         ; $7363
    jr nz, jr_003_7349                            ; $7364

    call HotSpotEd_DrawSoundIcon                  ; $7366
    call HotSpotEd_DrawEffectIcon                 ; $7369
    call HotSpotEd_DrawJumpIcon                   ; $736C
    call HotSpotEd_DrawButtonIcon                 ; $736F
    rst Rst08_WaitVBlank                          ; $7372
    jp HotSpotEd_PreviewSound                     ; $7373


; C: slides a dialog out. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogSlideOut::
    play_sfx1 SFX1_PANEL_OPEN                     ; $7376
    ld hl, Slide_WyDeltaTbl                       ; $737D
    ld b, $24                                     ; $7380

jr_003_7382:
    push bc                                       ; $7382
    push hl                                       ; $7383
    ldh a, [hWyShadow]                            ; $7384
    add [hl]                                      ; $7386
    ldh [hWyShadow], a                            ; $7387
    rst Rst08_WaitVBlank                          ; $7389
    pop hl                                        ; $738A
    pop bc                                        ; $738B
    inc hl                                        ; $738C
    dec b                                         ; $738D
    jr nz, jr_003_7382                            ; $738E

    ret                                           ; $7390


; C: slides a dialog in. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogSlideIn::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $7391
    xor a                                         ; $7398
    ld hl, Slide_WyDeltaTbl                       ; $7399
    ld b, $24                                     ; $739C

jr_003_739e:
    push bc                                       ; $739E
    push hl                                       ; $739F
    ldh a, [hWyShadow]                            ; $73A0
    sub [hl]                                      ; $73A2
    ldh [hWyShadow], a                            ; $73A3
    rst Rst08_WaitVBlank                          ; $73A5
    pop hl                                        ; $73A6
    pop bc                                        ; $73A7
    inc hl                                        ; $73A8
    dec b                                         ; $73A9
    jr nz, jr_003_739e                            ; $73AA

    ret                                           ; $73AC


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawSoundIcon::
    ld a, [wHsSelected]                           ; $73AD
    ld c, a                                       ; $73B0
    ld b, $00                                     ; $73B1
    ld hl, wHotspotBlock + $f                     ; $73B3
    add hl, bc                                    ; $73B6
    ld e, $ca                                     ; $73B7
    ld a, [hl]                                    ; $73B9
    cp $20                                        ; $73BA
    jr c, jr_003_73c4                             ; $73BC

    cp $ff                                        ; $73BE
    jr nz, jr_003_73c5                            ; $73C0

    inc e                                         ; $73C2
    inc e                                         ; $73C3

jr_003_73c4:
    inc e                                         ; $73C4

jr_003_73c5:
    ld b, $1f                                     ; $73C5
    ldh a, [hWyShadow]                            ; $73C7
    add $21                                       ; $73C9
    ld c, a                                       ; $73CB
    ld a, e                                       ; $73CC
    call Oam_AddMeta_B01_4000                     ; $73CD
    ret                                           ; $73D0


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawEffectIcon::
    ld a, [wHsSelected]                           ; $73D1
    ld c, a                                       ; $73D4
    ld b, $00                                     ; $73D5
    ld hl, wHotspotBlock + $14                    ; $73D7
    add hl, bc                                    ; $73DA
    ld e, $cc                                     ; $73DB
    ld a, [hl]                                    ; $73DD
    cp $ff                                        ; $73DE
    jr nz, jr_003_73e3                            ; $73E0

    inc e                                         ; $73E2

jr_003_73e3:
    ld b, $3f                                     ; $73E3
    ldh a, [hWyShadow]                            ; $73E5
    add $21                                       ; $73E7
    ld c, a                                       ; $73E9
    ld a, e                                       ; $73EA
    call Oam_AddMeta_B01_4000                     ; $73EB
    ret                                           ; $73EE


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawJumpIcon::
    ld a, [wHsSelected]                           ; $73EF
    ld c, a                                       ; $73F2
    ld b, $00                                     ; $73F3
    ld hl, wHotspotBlock + $19                    ; $73F5
    add hl, bc                                    ; $73F8
    ld e, $ce                                     ; $73F9
    ld a, [hl]                                    ; $73FB
    cp $ff                                        ; $73FC
    jr nz, jr_003_7401                            ; $73FE

    dec e                                         ; $7400

jr_003_7401:
    ld b, $67                                     ; $7401
    ldh a, [hWyShadow]                            ; $7403
    add $21                                       ; $7405
    ld c, a                                       ; $7407
    ld a, e                                       ; $7408
    call Oam_AddMeta_B01_4000                     ; $7409
    ret                                           ; $740C


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawButtonIcon::
    ld b, $82                                     ; $740D
    ldh a, [hWyShadow]                            ; $740F
    add $18                                       ; $7411
    ld c, a                                       ; $7413
    ld a, [wPickerButtonAnim]                     ; $7414
    and a                                         ; $7417
    jr nz, jr_003_7420                            ; $7418

    ld a, $d2                                     ; $741A
    call Oam_AddMeta_B01_4000                     ; $741C
    ret                                           ; $741F


jr_003_7420:
    cp $01                                        ; $7420
    jr nz, jr_003_742a                            ; $7422

    ld a, $d3                                     ; $7424
    call Oam_AddMeta_B01_4000                     ; $7426
    ret                                           ; $7429


jr_003_742a:
    ldh a, [hFrameCounter]                        ; $742A
    srl a                                         ; $742C
    srl a                                         ; $742E
    and $01                                       ; $7430
    add $d2                                       ; $7432
    call Oam_AddMeta_B01_4000                     ; $7434
    ret                                           ; $7437


; C: shows the number of the chosen sound
HotSpotEd_ShowSound::
    ld de, $8d30                                  ; $7438
    ld a, [wHsSelected]                           ; $743B
    ld c, a                                       ; $743E
    ld b, $00                                     ; $743F
    ld hl, wHotspotBlock + $f                     ; $7441
    add hl, bc                                    ; $7444
    ld a, [hl]                                    ; $7445
    cp $1f                                        ; $7446
    jr nz, jr_003_7450                            ; $7448

    ld a, [wPickerScrollPhase]                    ; $744A
    and a                                         ; $744D
    jr nz, jr_003_745f                            ; $744E

jr_003_7450:
    ld a, [hl]                                    ; $7450
    cp $ff                                        ; $7451
    jr z, jr_003_745f                             ; $7453

    cp $20                                        ; $7455
    jr c, jr_003_745b                             ; $7457

    sub $20                                       ; $7459

jr_003_745b:
    inc a                                         ; $745B
    call HotSpotEd_ShowNumber                     ; $745C

jr_003_745f:
    ld a, [wPickerScrollPhase]                    ; $745F
    and a                                         ; $7462
    ret nz                                        ; $7463

    jp HotSpotEd_PreviewSound                     ; $7464


Call_003_7467:
    ld de, $8d30                                  ; $7467
    ld a, [wHsSelected]                           ; $746A
    ld c, a                                       ; $746D
    ld b, $00                                     ; $746E
    ld hl, wHotspotBlock + $f                     ; $7470
    add hl, bc                                    ; $7473
    ld a, [hl]                                    ; $7474
    cp $1f                                        ; $7475
    jr nz, jr_003_747f                            ; $7477

    ld a, [wPickerScrollPhase]                    ; $7479
    and a                                         ; $747C
    jr nz, jr_003_748e                            ; $747D

jr_003_747f:
    ld a, [hl]                                    ; $747F
    cp $ff                                        ; $7480
    jr z, jr_003_748e                             ; $7482

    cp $20                                        ; $7484
    jr c, jr_003_748a                             ; $7486

    sub $20                                       ; $7488

jr_003_748a:
    inc a                                         ; $748A
    call HotSpotEd_ShowNumber                     ; $748B

jr_003_748e:
    ret                                           ; $748E


; C: shows the number and icon of the chosen effect
HotSpotEd_ShowEffect::
    ld de, $8d50                                  ; $748F
    ld a, [wHsSelected]                           ; $7492
    ld c, a                                       ; $7495
    ld b, $00                                     ; $7496
    ld hl, wHotspotBlock + $14                    ; $7498
    add hl, bc                                    ; $749B
    ld a, [hl]                                    ; $749C
    cp $ff                                        ; $749D
    ret z                                         ; $749F

    inc a                                         ; $74A0
    call HotSpotEd_ShowNumber                     ; $74A1
    jp HotSpotEd_ShowEffect_CopyThumb             ; $74A4


; C: shows the chosen jump target
HotSpotEd_ShowJump::
    farcopy Vram_CopyFromBank, Gfx_1C_5710_HotSpotEd_ShowJump, $8d70, $0010 ; $74A7
    ld de, $8d80                                  ; $74B5
    ld a, [wHsSelected]                           ; $74B8
    ld c, a                                       ; $74BB
    ld b, $00                                     ; $74BC
    ld hl, wHotspotBlock + $19                    ; $74BE
    add hl, bc                                    ; $74C1
    ld a, [hl]                                    ; $74C2
    cp $ff                                        ; $74C3
    jr z, jr_003_74cb                             ; $74C5

    inc a                                         ; $74C7
    call HotSpotEd_ShowNumber                     ; $74C8

jr_003_74cb:
    jp HotSpotEd_ShowJumpThumb                    ; $74CB


; C: two digit tiles from bank 1C. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_ShowNumber::
    push af                                       ; $74CE
    ld a, [wPickerScrollPhase]                    ; $74CF
    cp $04                                        ; $74D2
    jr nc, jr_003_74d8                            ; $74D4

    ld a, $04                                     ; $74D6

jr_003_74d8:
    sub $04                                       ; $74D8
    ld b, a                                       ; $74DA
    pop af                                        ; $74DB
    ld c, $00                                     ; $74DC

jr_003_74de:
    cp $0a                                        ; $74DE
    jr c, jr_003_74e7                             ; $74E0

    sub $0a                                       ; $74E2
    inc c                                         ; $74E4
    jr jr_003_74de                                ; $74E5

jr_003_74e7:
    push af                                       ; $74E7
    push bc                                       ; $74E8
    cp $09                                        ; $74E9
    jr z, jr_003_74ef                             ; $74EB

    ld b, $00                                     ; $74ED

jr_003_74ef:
    ld a, c                                       ; $74EF
    call HotSpotEd_CopyNumberTile                 ; $74F0
    pop bc                                        ; $74F3
    pop af                                        ; $74F4

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_CopyNumberTile::
    swap a                                        ; $74F5
    add b                                         ; $74F7
    ld c, a                                       ; $74F8
    ld b, $00                                     ; $74F9
    ld hl, Gfx_1C_5660_HotSpotEd_CopyNumberTile   ; $74FB
    add hl, bc                                    ; $74FE
    ld a, BANK(Gfx_1C_5660_HotSpotEd_CopyNumberTile) ; $74FF
    ld bc, $0010                                  ; $7501
    call Vram_CopyFromBank                        ; $7504
    ret                                           ; $7507


; C: copies the 64-byte effect thumbnail of the current slot ($5760 + 64 x effect id, bank $1C) to $8CF0 (branch
; target; code read 2026-10-19)
HotSpotEd_ShowEffect_CopyThumb::
    ld a, [wHsSelected]                           ; $7508
    ld c, a                                       ; $750B
    ld b, $00                                     ; $750C
    ld hl, wHotspotBlock + $14                    ; $750E
    add hl, bc                                    ; $7511
    ld a, [hl]                                    ; $7512
    cp $ff                                        ; $7513
    ret z                                         ; $7515

    swap a                                        ; $7516
    ld c, a                                       ; $7518
    ld b, $00                                     ; $7519
    sla c                                         ; $751B
    rl b                                          ; $751D
    sla c                                         ; $751F
    rl b                                          ; $7521
    ld hl, Gfx_1C_5760_HotSpotEd_ShowEffectIcon   ; $7523
    add hl, bc                                    ; $7526
    ld a, BANK(Gfx_1C_5760_HotSpotEd_ShowEffectIcon) ; $7527
    ld de, $8cf0                                  ; $7529
    ld bc, $0040                                  ; $752C
    call Vram_CopyFromBank                        ; $752F
    ret                                           ; $7532


; C: thumbnail of the jump target. L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_ShowJumpThumb::
    ld a, [wHsSelected]                           ; $7533
    ld c, a                                       ; $7536
    ld b, $00                                     ; $7537
    ld hl, wHotspotBlock + $19                    ; $7539
    add hl, bc                                    ; $753C
    ld a, [hl]                                    ; $753D
    cp $ff                                        ; $753E
    jr nc, jr_003_7584                            ; $7540

    bit 7, a                                      ; $7542
    jr z, jr_003_754a                             ; $7544

    res 7, a                                      ; $7546
    add $1e                                       ; $7548

jr_003_754a:
    ldh [hFarcallAArg], a                         ; $754A
    farcall Photo_GetSramAddress_Far              ; $754C
    ld hl, $0e00                                  ; $7554
    add hl, bc                                    ; $7557
    ld de, $8c30                                  ; $7558
    push af                                       ; $755B
    ld bc, $00c0                                  ; $755C
    call Vram_CopyFromBank                        ; $755F
    pop af                                        ; $7562
    ld de, $8da0                                  ; $7563
    ld b, $04                                     ; $7566

jr_003_7568:
    push af                                       ; $7568
    push bc                                       ; $7569
    push de                                       ; $756A
    ld bc, $0008                                  ; $756B
    call Vram_CopyFromBank                        ; $756E
    pop de                                        ; $7571
    ld a, e                                       ; $7572
    add $10                                       ; $7573
    ld e, a                                       ; $7575
    ld a, d                                       ; $7576
    adc $00                                       ; $7577
    ld d, a                                       ; $7579
    ld bc, $0008                                  ; $757A
    add hl, bc                                    ; $757D
    pop bc                                        ; $757E
    pop af                                        ; $757F
    dec b                                         ; $7580
    jr nz, jr_003_7568                            ; $7581

    ret                                           ; $7583


jr_003_7584:
    farcopy Vram_CopyFromBank, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete, $8c30, $00c0 ; $7584
    farcopy Vram_CopyFromBank, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete, $8da0, $0040 ; $7592
    ret                                           ; $75A0


; C: scrolls the value picker while Up / Down is held; Z/NZ
HotSpotEd_PickerScroll::
    ldh a, [hKeysHeld]                            ; $75A1
    and PADF_UP | PADF_DOWN                       ; $75A3
    jr z, jr_003_75b7                             ; $75A5

    ld [wPickerDir], a                            ; $75A7
    ld a, [wPickerScrollPhase]                    ; $75AA
    and a                                         ; $75AD
    jr nz, jr_003_75b7                            ; $75AE

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $75B0

jr_003_75b7:
    ld a, [wPickerDir]                            ; $75B7
    ld b, a                                       ; $75BA
    ld a, [wPickerScrollPhase]                    ; $75BB
    ld c, a                                       ; $75BE
    call HotSpotEd_PickerScrollStep               ; $75BF
    cp c                                          ; $75C2
    push af                                       ; $75C3
    ld [wPickerScrollPhase], a                    ; $75C4
    and a                                         ; $75C7
    jr nz, jr_003_75cd                            ; $75C8

    ld [wPickerDir], a                            ; $75CA

jr_003_75cd:
    ld a, [hl]                                    ; $75CD
    cp d                                          ; $75CE
    jr nz, jr_003_75d5                            ; $75CF

    ld a, $ff                                     ; $75D1
    jr jr_003_75db                                ; $75D3

jr_003_75d5:
    cp $fe                                        ; $75D5
    jr nz, jr_003_75db                            ; $75D7

    ld a, d                                       ; $75D9
    dec a                                         ; $75DA

jr_003_75db:
    ld [hl], a                                    ; $75DB
    pop af                                        ; $75DC
    ret                                           ; $75DD


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PickerScrollStep::
    bit 7, b                                      ; $75DE
    jr z, jr_003_75e9                             ; $75E0

    sub $02                                       ; $75E2
    ret nc                                        ; $75E4

    ld a, $12                                     ; $75E5
    dec [hl]                                      ; $75E7
    ret                                           ; $75E8


jr_003_75e9:
    bit 6, b                                      ; $75E9
    ret z                                         ; $75EB

    add $02                                       ; $75EC
    cp $14                                        ; $75EE
    ret nz                                        ; $75F0

    xor a                                         ; $75F1
    inc [hl]                                      ; $75F2
    ret                                           ; $75F3


; C: arrow sprite of the HotSpotEd pickers: the caller puts the position in BC (the effect picker passes x = $3F, y =
; $78 through `ld bc`); the meta is $CF while no key is held, $D1 while Up ($FFA1 bit 6) and $D0 while Down (bit 7) is
; held, drawn by Oam_AddMeta_B01_4000
HotSpotEd_DrawArrows::
    ldh a, [hKeysHeld]                            ; $75F4
    ld d, a                                       ; $75F6
    ld a, $cf                                     ; $75F7
    bit 7, d                                      ; $75F9
    jr nz, jr_003_7602                            ; $75FB

    bit 6, d                                      ; $75FD
    jr z, jr_003_7603                             ; $75FF

    inc a                                         ; $7601

jr_003_7602:
    inc a                                         ; $7602

jr_003_7603:
    call Oam_AddMeta_B01_4000                     ; $7603
    ret                                           ; $7606


; C: zeroes the pointer animation state. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus,
; modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_ClearAnim::
    ld hl, wSpriteAnimFrame                       ; $7607
    ld de, wSpriteAnimTick                        ; $760A
    xor a                                         ; $760D
    ld b, $06                                     ; $760E

jr_003_7610:
    ld [hl+], a                                   ; $7610
    ld [de], a                                    ; $7611
    inc de                                        ; $7612
    dec b                                         ; $7613
    jr nz, jr_003_7610                            ; $7614

    ret                                           ; $7616


; C: plays the chosen sound from the list at 7615
HotSpotEd_PreviewSound::
    ld a, [wHsSelected]                           ; $7617
    ld c, a                                       ; $761A
    ld b, $00                                     ; $761B
    ld hl, wHotspotBlock + $f                     ; $761D
    add hl, bc                                    ; $7620
    ld a, [hl]                                    ; $7621
    cp $ff                                        ; $7622
    jr nz, jr_003_762e                            ; $7624

    play_music MUSIC_STOP                         ; $7626
    ret                                           ; $762D


jr_003_762e:
    cp $20                                        ; $762E
    jr nc, jr_003_763c                            ; $7630

    play_music MUSIC_STOP                         ; $7632
    push af                                       ; $7639
    rst Rst08_WaitVBlank                          ; $763A
    pop af                                        ; $763B

jr_003_763c:
    ld hl, HotSpotEd_SoundList                    ; $763C
    call Snd_PlayFromList                         ; $763F
    ret                                           ; $7642


; I: list of {sound
HotSpotEd_SoundList::
    db SFX1_HOTSPOT_SOUND_01, SNDCH_SFX1  ; #1
    db SFX1_HOTSPOT_SOUND_02, SNDCH_SFX1  ; #2
    db SFX1_OPTION_CHANGE, SNDCH_SFX1  ; #3
    db SFX1_HOTSPOT_SOUND_04, SNDCH_SFX1  ; #4
    db SFX1_HOTSPOT_SOUND_05, SNDCH_SFX1  ; #5
    db SFX1_COMPOSE_LAYOUT_KEY, SNDCH_SFX1  ; #6
    db SFX1_HOTSPOT_SOUND_07, SNDCH_SFX1  ; #7
    db SFX1_SPACE_FEVER_MENU_PICK_GAME, SNDCH_SFX1  ; #8
    db SFX1_HOTSPOT_SOUND_09, SNDCH_SFX1  ; #9
    db SFX1_PANEL_OPEN_ALIAS_1D, SNDCH_SFX1  ; #10
    db SFX1_CHOOSE, SNDCH_SFX1  ; #11
    db SFX1_HOTSPOT_SOUND_12, SNDCH_SFX1  ; #12
    db SFX1_MAIN_MENU_PAGE_DOWN, SNDCH_SFX1  ; #13
    db SFX1_MAIN_MENU_PAGE_UP, SNDCH_SFX1  ; #14
    db SFX1_DJ_PERFORM_SE_3, SNDCH_SFX1  ; #15
    db SFX1_RUN_JUMP, SNDCH_SFX1  ; #16
    db SFX1_CURSOR_MOVE, SNDCH_SFX1  ; #17
    db SFX1_KEY_LEFT_RIGHT, SNDCH_SFX1  ; #18
    db SFX1_KEY_UP_DOWN, SNDCH_SFX1  ; #19
    db SFX1_KEY_A, SNDCH_SFX1  ; #20
    db SFX3_MAIN_MENU_SHOOT, SNDCH_SFX3  ; #21
    db SFX3_MAIN_MENU_VIEW_ARCADE, SNDCH_SFX3  ; #22
    db SFX3_SHUTTER_SOUND_3, SNDCH_SFX3  ; #23
    db SFX3_SHUTTER_SOUND_2, SNDCH_SFX3  ; #24
    db SFX4_HOTSPOT_SOUND_25, SNDCH_SFX4  ; #25
    db SFX4_LINK_CHOOSE, SNDCH_SFX4  ; #26
    db SFX4_HOTSPOT_SOUND_27, SNDCH_SFX4  ; #27
    db SFX4_HOTSPOT_SOUND_28, SNDCH_SFX4  ; #28
    db SFX4_HOTSPOT_SOUND_29, SNDCH_SFX4  ; #29
    db SFX4_HOTSPOT_SOUND_30, SNDCH_SFX4  ; #30
    db SFX4_HOTSPOT_SOUND_31, SNDCH_SFX4  ; #31
    db SFX4_HOTSPOT_SOUND_32, SNDCH_SFX4  ; #32
    db MUSIC_SLIDESHOW_TUNE_31, SNDCH_MUSIC  ; #33
    db MUSIC_JINGLE, SNDCH_MUSIC  ; #34
    db MUSIC_SLIDESHOW_TUNE_03, SNDCH_MUSIC  ; #35
    db MUSIC_SLIDESHOW_TUNE_04, SNDCH_MUSIC  ; #36
    db MUSIC_SLIDESHOW_TUNE_05, SNDCH_MUSIC  ; #37
    db MUSIC_SLIDESHOW_PLAY_ALIAS_15, SNDCH_MUSIC  ; #38
    db MUSIC_FACTORY_DIAG, SNDCH_MUSIC  ; #39
    db MUSIC_SLIDESHOW_TUNE_08, SNDCH_MUSIC  ; #40
    db MUSIC_SLIDESHOW_TUNE_09, SNDCH_MUSIC  ; #41
    db MUSIC_JAMBO_NINTENDO_ALIAS_19, SNDCH_MUSIC  ; #42
    db MUSIC_TIMER_PRINT_OPTIONS_ALIAS_1A, SNDCH_MUSIC  ; #43
    db MUSIC_SLIDESHOW_TUNE_12, SNDCH_MUSIC  ; #44
    db MUSIC_BEETHOVEN_5TH_INTRO, SNDCH_MUSIC  ; #45
    db MUSIC_SLIDESHOW_TUNE_14, SNDCH_MUSIC  ; #46
    db MUSIC_BALL_BGM_2, SNDCH_MUSIC  ; #47
    db MUSIC_SPACE_FEVER_1F, SNDCH_MUSIC  ; #48
    db MUSIC_LINK_MENU, SNDCH_MUSIC  ; #49
    db MUSIC_SLIDESHOW_INIT, SNDCH_MUSIC  ; #50
    db MUSIC_ANIMATION_EDITOR, SNDCH_MUSIC  ; #51
    db MUSIC_MAIN_MENU, SNDCH_MUSIC  ; #52
    db MUSIC_BALL_BGM_1, SNDCH_MUSIC  ; #53
    db MUSIC_USER_SCREENS, SNDCH_MUSIC  ; #54
    db MUSIC_SLIDESHOW_TUNE_23, SNDCH_MUSIC  ; #55
    db MUSIC_COMPOSE, SNDCH_MUSIC  ; #56
    db MUSIC_COMMENT_EDITOR, SNDCH_MUSIC  ; #57
    db MUSIC_ALBUM_VIEWER, SNDCH_MUSIC  ; #58
    db MUSIC_OWNER_CARD, SNDCH_MUSIC  ; #59
    db MUSIC_RUN_PICK_CHARACTER, SNDCH_MUSIC  ; #60
    db MUSIC_RUN_RESULT_SETUP, SNDCH_MUSIC  ; #61
    db MUSIC_SPACE_FEVER_BOSS, SNDCH_MUSIC  ; #62
    db MUSIC_RUN_RACE, SNDCH_MUSIC  ; #63
    db MUSIC_BALL_GAME_OVER, SNDCH_MUSIC  ; #64

; C: ACCESS: PRINT / TRANSFER
Mode06_LinkMenu::
    ld a, [wState]                                ; $76C3
    rst Rst18_JumpTable                           ; $76C6

; I: 3 states, rst $18 table of mode $06
Mode06_StateTable::
    dw Mode06_State00_Init
    dw Mode06_State01_Choose
    dw Mode06_State02_Dispatch

; C: loads the link menu graphics (bank 12)
Mode06_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $76CD
    ldh [hLcdcShadow], a                          ; $76CF
    ld a, $1b                                     ; $76D1
    ld [wPaletteTarget], a                        ; $76D3
    ld [wPaletteTarget + $1], a                   ; $76D6
    ld a, $d2                                     ; $76D9
    ld [wPaletteTarget + $2], a                   ; $76DB
    xor a                                         ; $76DE
    ldh [hScxShadow], a                           ; $76DF
    ldh [hScyShadow], a                           ; $76E1
    ld a, $67                                     ; $76E3
    ldh [hWxShadow], a                            ; $76E5
    ld a, $16                                     ; $76E7
    ldh [hWyShadow], a                            ; $76E9
    xor a                                         ; $76EB
    ld [wSpriteAnimFrame], a                      ; $76EC
    ld [wSpriteAnimTick], a                       ; $76EF
    ld a, $12                                     ; $76F2
    ld hl, Gfx_12_4000_Mode06_State00_Init        ; $76F4
    ld de, $9000                                  ; $76F7
    ld bc, $0800                                  ; $76FA
    call Mem_CopyFromBank                         ; $76FD
    farcopy Mem_CopyFromBank, Gfx_12_4800_Mode06_State00_Init, $8800, $0800 ; $7700
    farcopy Mem_CopyFromBank, Gfx_12_5000_Mode06_State00_Init, $8000, $0800 ; $770E
    farcopy Mem_CopyFromBank, Map_23_44C0_Mode06_State00_Init, $9800, $0400 ; $771C
    farcopy Mem_CopyFromBank, Map_22_6340_Mode06_State00_Init, $9c00, $0400 ; $772A
    ld a, $50                                     ; $7738
    ldh [hLycShadowSplit1], a                     ; $773A
    ldh [hSplit2Line], a                          ; $773C
    ld hl, hStatShadow                            ; $773E
    set 6, [hl]                                   ; $7741
    ld hl, rIE                                    ; $7743
    set 1, [hl]                                   ; $7746
    ld a, $04                                     ; $7748
    ldh [hStatHandlerIndex], a                    ; $774A
    screen_on                                     ; $774C
    play_music MUSIC_LINK_MENU                    ; $7755
    ld a, [wLinkMenuCursor]                       ; $775C
    push af                                       ; $775F
    xor $01                                       ; $7760
    ld [wLinkMenuCursor], a                       ; $7762
    call LinkMenu_LoadTilesDeselected             ; $7765
    pop af                                        ; $7768
    ld [wLinkMenuCursor], a                       ; $7769
    call LinkMenu_LoadTilesSelected               ; $776C
    call Pal_FadeIn                               ; $776F
    next_state                                    ; $7772
    ret                                           ; $7776


; C: Up / Down moves between PRINT and TRANSFER
Mode06_State01_Choose::
    call LinkMenu_DrawCursor                      ; $7777
    call LinkMenu_MoveCursor                      ; $777A
    call LinkMenu_AnimateWindow                   ; $777D
    call LinkMenu_DrawSpark                       ; $7780
    ldh a, [hKeysNew]                             ; $7783
    and PADF_A | PADF_B                           ; $7785
    ret z                                         ; $7787

    ld [wAbResult], a                             ; $7788
    push af                                       ; $778B
    bit 0, a                                      ; $778C
    ld a, SFX1_CHOOSE_B                           ; $778E
    call nz, Snd_Sfx1                             ; $7790
    pop af                                        ; $7793
    push af                                       ; $7794
    bit 1, a                                      ; $7795
    ld a, SFX1_KEY_B                              ; $7797
    call nz, Snd_Sfx1                             ; $7799
    pop af                                        ; $779C
    next_state                                    ; $779D
    ret                                           ; $77A1


; C: moves the window Y following the table at 779E. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic
; corpus, modes 06 (tcrf_check/assets/l3_names/)
LinkMenu_AnimateWindow::
    ld a, [wSpriteAnimFrame]                      ; $77A2
    sla a                                         ; $77A5
    ld c, a                                       ; $77A7
    ld b, $00                                     ; $77A8
    ld hl, LinkMenu_WindowAnimTbl                 ; $77AA
    add hl, bc                                    ; $77AD
    ld a, [hl+]                                   ; $77AE
    ldh [hWyShadow], a                            ; $77AF
    ld a, [wSpriteAnimTick]                       ; $77B1
    sub [hl]                                      ; $77B4
    jr nz, jr_003_77c7                            ; $77B5

    ld [wSpriteAnimTick], a                       ; $77B7
    inc hl                                        ; $77BA
    ld a, [hl]                                    ; $77BB
    sub $ff                                       ; $77BC
    jr z, jr_003_77c4                             ; $77BE

    ld a, [wSpriteAnimFrame]                      ; $77C0
    inc a                                         ; $77C3

jr_003_77c4:
    ld [wSpriteAnimFrame], a                      ; $77C4

jr_003_77c7:
    ld hl, wSpriteAnimTick                        ; $77C7
    inc [hl]                                      ; $77CA
    ret                                           ; $77CB


; C: pairs {wy. L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06
; (tcrf_check/assets/l3_names/)
LinkMenu_WindowAnimTbl::
    db $16, $05, $17, $06, $18, $08, $19, $09, $1a, $0d, $19, $09, $18, $08, $17, $06
    db $16, $05, $15, $06, $14, $08, $13, $09, $12, $0d, $13, $09, $14, $08, $15, $06
    db $ff

; C: B returns to the main menu (mode 00); A goes to the mode of the item (table 77BF+..)
Mode06_State02_Dispatch::
    ld a, [wAbResult]                             ; $77ED
    bit 0, a                                      ; $77F0
    jr nz, jr_003_780f                            ; $77F2

    ld a, MODE_MAIN_MENU                          ; $77F4
    ld [wMode], a                                 ; $77F6
    set_state STATE_00_INIT                       ; $77F9
    screen_off                                    ; $77FE
    stat_irq_off                                  ; $7804
    ret                                           ; $780E


jr_003_780f:
    ld a, [wLinkMenuCursor]                       ; $780F
    ld e, a                                       ; $7812
    ld d, $00                                     ; $7813
    ld hl, LinkMenu_TargetModeTbl                 ; $7815
    add hl, de                                    ; $7818
    ld a, [hl]                                    ; $7819
    cp MODE_COUNT                                 ; $781A
    jr c, jr_003_782a                             ; $781C

    play_sfx1 SFX1_BEEP_REFUSED                   ; $781E
    ld hl, wState                                 ; $7825
    dec [hl]                                      ; $7828
    ret                                           ; $7829


jr_003_782a:
    ld [wMode], a                                 ; $782A
    xor a                                         ; $782D
    ld [wState], a                                ; $782E
    ld b, $18                                     ; $7831

jr_003_7833:
    push bc                                       ; $7833
    ld a, b                                       ; $7834
    and $03                                       ; $7835
    jr nz, jr_003_7845                            ; $7837

    bit 2, b                                      ; $7839
    jr nz, jr_003_7842                            ; $783B

    call LinkMenu_LoadTilesDeselected             ; $783D
    jr jr_003_7845                                ; $7840

jr_003_7842:
    call LinkMenu_LoadTilesSelected               ; $7842

jr_003_7845:
    call LinkMenu_DrawCursor                      ; $7845
    call LinkMenu_DrawSpark                       ; $7848
    call Oam_HideUnused                           ; $784B
    rst Rst08_WaitVBlank                          ; $784E
    pop bc                                        ; $784F
    dec b                                         ; $7850
    jr nz, jr_003_7833                            ; $7851

    screen_off                                    ; $7853
    stat_irq_off                                  ; $7859
    ret                                           ; $7863


; C: 2 bytes: target mode of PRINT / TRANSFER
LinkMenu_TargetModeTbl::
    db MODE_PRINT_MENU, MODE_LINK_TRANSFER

; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_DrawCursor::
    ld bc, $4a36                                  ; $7866
    ld a, [wLinkMenuCursor]                       ; $7869
    add $ee                                       ; $786C
    call Oam_AddMeta_B01_4000                     ; $786E
    ret                                           ; $7871


; C
LinkMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7872
    ld b, a                                       ; $7874
    ld a, [wLinkMenuCursor]                       ; $7875
    bit 6, b                                      ; $7878
    jr nz, jr_003_7880                            ; $787A

    bit 5, b                                      ; $787C
    jr z, jr_003_788c                             ; $787E

jr_003_7880:
    and a                                         ; $7880
    ret z                                         ; $7881

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7882
    dec a                                         ; $7889
    jr jr_003_789e                                ; $788A

jr_003_788c:
    bit 7, b                                      ; $788C
    jr nz, jr_003_7893                            ; $788E

    bit 4, b                                      ; $7890
    ret z                                         ; $7892

jr_003_7893:
    cp $01                                        ; $7893
    ret z                                         ; $7895

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7896
    inc a                                         ; $789D

jr_003_789e:
    call LinkMenu_LoadTilesDeselected             ; $789E
    ld [wLinkMenuCursor], a                       ; $78A1
    call LinkMenu_LoadTilesSelected               ; $78A4
    ret                                           ; $78A7


; C: sweeping spark sprite. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_DrawSpark::
    ld hl, wSweepPos16                            ; $78A8
    ld a, [hl]                                    ; $78AB
    add $03                                       ; $78AC
    ld [hl+], a                                   ; $78AE
    ld a, [hl]                                    ; $78AF
    adc $00                                       ; $78B0
    ld [hl-], a                                   ; $78B2
    and $03                                       ; $78B3
    ret nz                                        ; $78B5

    ld a, [hl]                                    ; $78B6
    cp $5d                                        ; $78B7
    ret nc                                        ; $78B9

    sub $10                                       ; $78BA
    ld b, a                                       ; $78BC
    ld c, $03                                     ; $78BD
    ldh a, [hFrameCounter]                        ; $78BF
    and $01                                       ; $78C1
    add $f0                                       ; $78C3
    call Oam_AddMeta_B01_4000                     ; $78C5
    ret                                           ; $78C8


; C: highlight tiles of the selected item. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus,
; modes 06 0E 1B (tcrf_check/assets/l3_names/)
LinkMenu_LoadTilesSelected::
    push af                                       ; $78C9
    ld a, [wLinkMenuCursor]                       ; $78CA
    and a                                         ; $78CD
    jr nz, jr_003_78e0                            ; $78CE

    farcopy Vram_CopyFromBank, Gfx_12_4B10_LinkMenu_LoadTilesSelected, $8990, $00a0 ; $78D0
    jr jr_003_78ee                                ; $78DE

jr_003_78e0:
    farcopy Vram_CopyFromBank, Gfx_12_4A30_LinkMenu_LoadTilesSelected, $8a30, $00e0 ; $78E0

jr_003_78ee:
    pop af                                        ; $78EE
    ret                                           ; $78EF


; I: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_LoadTilesDeselected::
    push af                                       ; $78F0
    ld a, [wLinkMenuCursor]                       ; $78F1
    and a                                         ; $78F4
    jr nz, jr_003_7907                            ; $78F5

    farcopy Vram_CopyFromBank, Gfx_12_4990_LinkMenu_LoadTilesDeselected, $8990, $00a0 ; $78F7
    jr jr_003_7923                                ; $7905

jr_003_7907:
    farcopy Vram_CopyFromBank, Gfx_12_4BB0_LinkMenu_LoadTilesDeselected, $8a30, $0020 ; $7907
    farcopy Vram_CopyFromBank, Gfx_12_4E40_LinkMenu_LoadTilesDeselected, $8a50, $00c0 ; $7915

jr_003_7923:
    pop af                                        ; $7923
    ret                                           ; $7924


; C: SLIDE SHOW / ANIMATION / HOT-SPOT
Mode0B_ShowMenu::
    ld a, [wState]                                ; $7925
    rst Rst18_JumpTable                           ; $7928

; I: 3 states, rst $18 table of mode $0B
Mode0B_StateTable::
    dw Mode0B_State00_Init
    dw Mode0B_State01_Choose
    dw Mode0B_State02_Dispatch

; C: loads the show menu graphics (bank 16)
Mode0B_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $792F
    ldh [hLcdcShadow], a                          ; $7931
    ld a, $e4                                     ; $7933
    ld [wPaletteTarget], a                        ; $7935
    ld a, $d2                                     ; $7938
    ld [wPaletteTarget + $1], a                   ; $793A
    ld [wPaletteTarget + $2], a                   ; $793D
    xor a                                         ; $7940
    ldh [hScxShadow], a                           ; $7941
    ldh [hScyShadow], a                           ; $7943
    ld [wSpriteAnimFrame], a                      ; $7945
    ld [wSpriteAnimTick], a                       ; $7948
    ld a, $16                                     ; $794B
    ld hl, Gfx_16_4000_Mode0B_State00_Init        ; $794D
    ld de, $9000                                  ; $7950
    ld bc, $0800                                  ; $7953
    call Mem_CopyFromBank                         ; $7956
    farcopy Mem_CopyFromBank, Gfx_16_4800_Mode0B_State00_Init, $8800, $0800 ; $7959
    farcopy Mem_CopyFromBank, Gfx_16_5000_Mode0B_State00_Init, $8000, $0800 ; $7967
    farcopy Mem_CopyFromBank, Map_23_7B00_Mode0B_State00_Init, $9800, $0240 ; $7975
    screen_on                                     ; $7983
    play_music MUSIC_SHOW_MENU                    ; $798C
    call Pal_FadeIn                               ; $7993
    call ShowMenu_LoadHighlightTiles              ; $7996
    next_state                                    ; $7999
    ret                                           ; $799D


; C: Up / Down moves the cursor (3 items)
Mode0B_State01_Choose::
    call ShowMenu_MoveCursor                      ; $799E
    call ShowMenu_DrawCursor                      ; $79A1
    ldh a, [hKeysNew]                             ; $79A4
    and PADF_A | PADF_B                           ; $79A6
    ret z                                         ; $79A8

    ld [wAbResult], a                             ; $79A9
    push af                                       ; $79AC
    bit 0, a                                      ; $79AD
    ld a, SFX1_CHOOSE_D                           ; $79AF
    call nz, Snd_Sfx1                             ; $79B1
    pop af                                        ; $79B4
    push af                                       ; $79B5
    bit 1, a                                      ; $79B6
    ld a, SFX1_KEY_B                              ; $79B8
    call nz, Snd_Sfx1                             ; $79BA
    pop af                                        ; $79BD
    next_state                                    ; $79BE
    ret                                           ; $79C2


; C: B returns to the view menu (mode 02); A goes to the mode of the item (table 79E0)
Mode0B_State02_Dispatch::
    ld a, [wAbResult]                             ; $79C3
    bit 0, a                                      ; $79C6
    jr nz, jr_003_79db                            ; $79C8

    ld a, MODE_VIEW_MENU                          ; $79CA
    ld [wMode], a                                 ; $79CC
    set_state STATE_02_INIT                       ; $79CF
    screen_off                                    ; $79D4
    ret                                           ; $79DA


jr_003_79db:
    ld a, [wShowMenuCursor]                       ; $79DB
    ld e, a                                       ; $79DE
    ld d, $00                                     ; $79DF
    ld hl, ShowMenu_TargetModeTbl                 ; $79E1
    add hl, de                                    ; $79E4
    ld a, [hl]                                    ; $79E5
    cp MODE_NONE                                  ; $79E6
    jr nz, jr_003_79ef                            ; $79E8

    ld hl, wState                                 ; $79EA
    dec [hl]                                      ; $79ED
    ret                                           ; $79EE


jr_003_79ef:
    ld [wMode], a                                 ; $79EF
    xor a                                         ; $79F2
    ld [wState], a                                ; $79F3
    ld b, $18                                     ; $79F6

jr_003_79f8:
    push bc                                       ; $79F8
    ld a, b                                       ; $79F9
    and $03                                       ; $79FA
    jr nz, jr_003_7a0a                            ; $79FC

    bit 2, b                                      ; $79FE
    jr nz, jr_003_7a07                            ; $7A00

    call ShowMenu_LoadNormalTiles                 ; $7A02
    jr jr_003_7a0a                                ; $7A05

jr_003_7a07:
    call ShowMenu_LoadHighlightTiles              ; $7A07

jr_003_7a0a:
    call ShowMenu_DrawCursor                      ; $7A0A
    call Oam_HideUnused                           ; $7A0D
    rst Rst08_WaitVBlank                          ; $7A10
    pop bc                                        ; $7A11
    dec b                                         ; $7A12
    jr nz, jr_003_79f8                            ; $7A13

    screen_off                                    ; $7A15
    ret                                           ; $7A1B


; C: 3 bytes: target mode of the three items ($FF = none)
ShowMenu_TargetModeTbl::
    db MODE_SLIDE_SHOW, MODE_ANIMATION_PLAYER, MODE_HOT_SPOT_VIEWER

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_DrawCursor::
    ld a, [wShowMenuCursor]                       ; $7A1F
    ld e, a                                       ; $7A22
    ld d, $00                                     ; $7A23
    ld hl, ShowMenu_DrawCursor_Tbl7A5D            ; $7A25
    add hl, de                                    ; $7A28
    ld c, [hl]                                    ; $7A29
    ld b, $02                                     ; $7A2A
    ld a, [wSpriteAnimFrame]                      ; $7A2C
    sla a                                         ; $7A2F
    ld e, a                                       ; $7A31
    ld hl, ShowMenu_DrawCursor_Tbl7A60            ; $7A32
    add hl, de                                    ; $7A35
    ld a, [hl+]                                   ; $7A36
    push hl                                       ; $7A37
    call Oam_AddMeta_B01_4000                     ; $7A38
    pop hl                                        ; $7A3B
    ld a, [wSpriteAnimTick]                       ; $7A3C
    cp [hl]                                       ; $7A3F
    jr nz, jr_003_7a58                            ; $7A40

    inc hl                                        ; $7A42
    ld a, [hl]                                    ; $7A43
    sub $ff                                       ; $7A44
    jr z, jr_003_7a51                             ; $7A46

    ld a, [wSpriteAnimFrame]                      ; $7A48
    inc a                                         ; $7A4B
    cp $02                                        ; $7A4C
    jr nz, jr_003_7a51                            ; $7A4E

    xor a                                         ; $7A50

jr_003_7a51:
    ld [wSpriteAnimFrame], a                      ; $7A51
    xor a                                         ; $7A54
    ld [wSpriteAnimTick], a                       ; $7A55

jr_003_7a58:
    ld hl, wSpriteAnimTick                        ; $7A58
    inc [hl]                                      ; $7A5B
    ret                                           ; $7A5C


; C: auto: 3 bytes, bytes; referenced by ShowMenu_DrawCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0B)
ShowMenu_DrawCursor_Tbl7A5D::
    db $4c, $64, $7c

; C: auto: 11 bytes, bytes; referenced by ShowMenu_DrawCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0B)
ShowMenu_DrawCursor_Tbl7A60::
    db $d7, $04, $d8, $04, $d9, $05, $da, $04, $db, $03, $ff

; C
ShowMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7A6B
    ld b, a                                       ; $7A6D
    ld a, [wShowMenuCursor]                       ; $7A6E
    bit 6, b                                      ; $7A71
    jr z, jr_003_7a81                             ; $7A73

    and a                                         ; $7A75
    ret z                                         ; $7A76

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7A77
    dec a                                         ; $7A7E
    jr jr_003_7a8f                                ; $7A7F

jr_003_7a81:
    bit 7, b                                      ; $7A81
    ret z                                         ; $7A83

    cp $02                                        ; $7A84
    ret z                                         ; $7A86

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7A87
    inc a                                         ; $7A8E

jr_003_7a8f:
    call ShowMenu_LoadNormalTiles                 ; $7A8F
    ld [wShowMenuCursor], a                       ; $7A92
    call ShowMenu_LoadHighlightTiles              ; $7A95
    ld a, $02                                     ; $7A98
    ld [wSpriteAnimFrame], a                      ; $7A9A
    ret                                           ; $7A9D


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_LoadHighlightTiles::
    push af                                       ; $7A9E
    ld a, [wShowMenuCursor]                       ; $7A9F
    sla a                                         ; $7AA2
    ld c, a                                       ; $7AA4
    sla a                                         ; $7AA5
    add c                                         ; $7AA7
    swap a                                        ; $7AA8
    ld c, a                                       ; $7AAA
    ld b, $00                                     ; $7AAB
    ld hl, $9900                                  ; $7AAD
    add hl, bc                                    ; $7AB0
    push hl                                       ; $7AB1
    ld hl, Map_23_7D60_ShowMenu_LoadHighlightTiles ; $7AB2
    add hl, bc                                    ; $7AB5
    ld a, BANK(Map_23_7D60_ShowMenu_LoadHighlightTiles) ; $7AB6
    pop de                                        ; $7AB8
    ld bc, $0060                                  ; $7AB9
    call Vram_CopyFromBank                        ; $7ABC
    pop af                                        ; $7ABF
    ret                                           ; $7AC0


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_LoadNormalTiles::
    push af                                       ; $7AC1
    ld a, [wShowMenuCursor]                       ; $7AC2
    sla a                                         ; $7AC5
    ld c, a                                       ; $7AC7
    sla a                                         ; $7AC8
    add c                                         ; $7ACA
    swap a                                        ; $7ACB
    ld c, a                                       ; $7ACD
    ld b, $00                                     ; $7ACE
    ld hl, $9900                                  ; $7AD0
    add hl, bc                                    ; $7AD3
    push hl                                       ; $7AD4
    ld hl, Map_23_7C00_ShowMenu_LoadNormalTiles   ; $7AD5
    add hl, bc                                    ; $7AD8
    ld a, BANK(Map_23_7C00_ShowMenu_LoadNormalTiles) ; $7AD9
    pop de                                        ; $7ADB
    ld bc, $0060                                  ; $7ADC
    call Vram_CopyFromBank                        ; $7ADF
    pop af                                        ; $7AE2
    ret                                           ; $7AE3


; C: STAMP / PAINT tool pick
Mode04_DoodleMenu::
    ld a, [wState]                                ; $7AE4
    rst Rst18_JumpTable                           ; $7AE7

; I: 3 states, rst $18 table of mode $04
Mode04_StateTable::
    dw Mode04_State00_Init
    dw Mode04_State01_Choose
    dw Mode04_State02_Dispatch

; I: loads the doodle menu graphics (bank 15)
Mode04_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7AEE
    ldh [hLcdcShadow], a                          ; $7AF0
    ld a, $e4                                     ; $7AF2
    ld [wPaletteTarget], a                        ; $7AF4
    ld [wPaletteTarget + $1], a                   ; $7AF7
    ld a, $d2                                     ; $7AFA
    ld [wPaletteTarget + $2], a                   ; $7AFC
    xor a                                         ; $7AFF
    ldh [hScxShadow], a                           ; $7B00
    ldh [hScyShadow], a                           ; $7B02
    xor a                                         ; $7B04
    ld [wBlinkHold], a                            ; $7B05
    farcopy Mem_CopyFromBank, Gfx_15_5700_Mode04_State00_Init, $9000, $0800 ; $7B08
    farcopy Mem_CopyFromBank, Gfx_15_5F00_Mode04_State00_Init, $8800, $0800 ; $7B16
    farcopy Mem_CopyFromBank, Gfx_15_6700_Mode04_State00_Init, $8000, $0800 ; $7B24
    farcopy Mem_CopyFromBank, Map_26_7980_Mode04_State00_Init, $9800, $0240 ; $7B32
    screen_on                                     ; $7B40
    play_music MUSIC_DOODLE_MENU                  ; $7B49
    call Pal_FadeIn                               ; $7B50
    next_state                                    ; $7B53
    ret                                           ; $7B57


; C: Left / Right moves between STAMP and PAINT
Mode04_State01_Choose::
    call DoodleMenu_DrawCursor                    ; $7B58
    call DoodleMenu_MoveCursor                    ; $7B5B
    call DoodleMenu_DrawBlinker                   ; $7B5E
    ldh a, [hKeysNew]                             ; $7B61
    and PADF_A | PADF_B                           ; $7B63
    ret z                                         ; $7B65

    ld [wAbResult], a                             ; $7B66
    next_state                                    ; $7B69
    ret                                           ; $7B6D


; C: B returns to the main menu (or the shoot menu when launched from there); A goes to the tool mode (table 7B8E)
Mode04_State02_Dispatch::
    ld a, [wAbResult]                             ; $7B6E
    bit 0, a                                      ; $7B71
    jr nz, jr_003_7b97                            ; $7B73

    screen_off                                    ; $7B75
    ld a, [wDoodleFromShutterbug]                 ; $7B7B
    and a                                         ; $7B7E
    jr nz, jr_003_7b8c                            ; $7B7F

    ld a, MODE_MAIN_MENU                          ; $7B81
    ld [wMode], a                                 ; $7B83
    set_state STATE_00_INIT                       ; $7B86
    ret                                           ; $7B8B


jr_003_7b8c:
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $7B8C
    ld [wMode], a                                 ; $7B8E
    set_state STATE_16_REDRAW                     ; $7B91
    ret                                           ; $7B96


jr_003_7b97:
    ld a, [wDoodleMenuCursor]                     ; $7B97
    ld e, a                                       ; $7B9A
    ld d, $00                                     ; $7B9B
    ld hl, DoodleMenu_TargetModeTbl               ; $7B9D
    add hl, de                                    ; $7BA0
    ld a, [hl]                                    ; $7BA1
    cp MODE_COUNT                                 ; $7BA2
    jr c, jr_003_7bab                             ; $7BA4

    ld hl, wState                                 ; $7BA6
    dec [hl]                                      ; $7BA9
    ret                                           ; $7BAA


jr_003_7bab:
    ld [wMode], a                                 ; $7BAB
    screen_off                                    ; $7BAE
    ld a, [wDoodleFromShutterbug]                 ; $7BB4
    and a                                         ; $7BB7
    jr nz, jr_003_7bbf                            ; $7BB8

    xor a                                         ; $7BBA
    ld [wState], a                                ; $7BBB
    ret                                           ; $7BBE


jr_003_7bbf:
    ld a, $01                                     ; $7BBF
    ld [wAbResult], a                             ; $7BC1
    set_state STATE_04_DISPATCH                   ; $7BC4
    ret                                           ; $7BC9


; C: 2 bytes: target mode of STAMP / PAINT
DoodleMenu_TargetModeTbl::
    db MODE_STAMP, MODE_PAINT

; C: L3 pass 2026-10-26: executed in BGB in 35 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
DoodleMenu_DrawCursor::
    ld a, [wBlinkHold]                            ; $7BCC
    and a                                         ; $7BCF
    jr z, jr_003_7bdb                             ; $7BD0

    dec a                                         ; $7BD2
    ld [wBlinkHold], a                            ; $7BD3
    ldh a, [hFrameCounter]                        ; $7BD6
    bit 3, a                                      ; $7BD8
    ret z                                         ; $7BDA

jr_003_7bdb:
    ld bc, $5030                                  ; $7BDB
    ld a, [wDoodleMenuCursor]                     ; $7BDE
    add $f2                                       ; $7BE1
    call Oam_AddMeta_B01_4000                     ; $7BE3
    ret                                           ; $7BE6


; C
DoodleMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7BE7
    ld b, a                                       ; $7BE9
    ld a, [wDoodleMenuCursor]                     ; $7BEA
    bit 6, b                                      ; $7BED
    jr nz, jr_003_7bf5                            ; $7BEF

    bit 4, b                                      ; $7BF1
    jr z, jr_003_7c01                             ; $7BF3

jr_003_7bf5:
    and a                                         ; $7BF5
    ret z                                         ; $7BF6

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7BF7
    dec a                                         ; $7BFE
    jr jr_003_7c13                                ; $7BFF

jr_003_7c01:
    bit 7, b                                      ; $7C01
    jr nz, jr_003_7c08                            ; $7C03

    bit 5, b                                      ; $7C05
    ret z                                         ; $7C07

jr_003_7c08:
    cp $01                                        ; $7C08
    ret z                                         ; $7C0A

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7C0B
    inc a                                         ; $7C12

jr_003_7c13:
    ld [wDoodleMenuCursor], a                     ; $7C13
    ld a, $20                                     ; $7C16
    ld [wBlinkHold], a                            ; $7C18
    ret                                           ; $7C1B


; C: L3 pass 2026-10-26: executed in BGB in 35 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
DoodleMenu_DrawBlinker::
    ldh a, [hFrameCounter]                        ; $7C1C
    bit 4, a                                      ; $7C1E
    ret z                                         ; $7C20

    ld a, [wDoodleMenuCursor]                     ; $7C21
    and a                                         ; $7C24
    jr nz, jr_003_7c30                            ; $7C25

    ld bc, $0341                                  ; $7C27
    ld a, $f4                                     ; $7C2A
    call Oam_AddMeta_B01_4000                     ; $7C2C
    ret                                           ; $7C2F


jr_003_7c30:
    ld bc, $9441                                  ; $7C30
    ld a, $f5                                     ; $7C33
    call Oam_AddMeta_B01_4000                     ; $7C35
    ret                                           ; $7C38


; C: ALBUM / ANIMATION
Mode05_EditMenu::
    ld a, [wState]                                ; $7C39
    rst Rst18_JumpTable                           ; $7C3C

; I: 3 states, rst $18 table of mode $05
Mode05_StateTable::
    dw Mode05_State00_Init
    dw Mode05_State01_Choose
    dw Mode05_State02_Dispatch

; C: loads the edit menu graphics (bank 18)
Mode05_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7C43
    ldh [hLcdcShadow], a                          ; $7C45
    ld a, $e4                                     ; $7C47
    ld [wPaletteTarget], a                        ; $7C49
    ld a, $d2                                     ; $7C4C
    ld [wPaletteTarget + $1], a                   ; $7C4E
    ld [wPaletteTarget + $2], a                   ; $7C51
    xor a                                         ; $7C54
    ldh [hScxShadow], a                           ; $7C55
    ldh [hScyShadow], a                           ; $7C57
    ld hl, wSpriteAnimFrame                       ; $7C59
    ld b, $08                                     ; $7C5C

jr_003_7c5e:
    ld [hl+], a                                   ; $7C5E
    dec b                                         ; $7C5F
    jr nz, jr_003_7c5e                            ; $7C60

    ld a, $18                                     ; $7C62
    ld hl, Gfx_18_4000_Mode05_State00_Init        ; $7C64
    ld de, $9000                                  ; $7C67
    ld bc, $0800                                  ; $7C6A
    call Mem_CopyFromBank                         ; $7C6D
    farcopy Mem_CopyFromBank, Gfx_18_4800_Mode05_State00_Init, $8800, $0800 ; $7C70
    farcopy Mem_CopyFromBank, Gfx_18_5000_Mode05_State00_Init, $8000, $0470 ; $7C7E
    farcopy Mem_CopyFromBank, Map_25_6CE0_Mode05_State00_Init, $9800, $0240 ; $7C8C
    screen_on                                     ; $7C9A
    play_music MUSIC_EDIT_MENU                    ; $7CA3
    call Pal_FadeIn                               ; $7CAA
    ld a, [wEditMenuCursor]                       ; $7CAD
    call EditMenu_ResetIconAnim                   ; $7CB0
    next_state                                    ; $7CB3
    ret                                           ; $7CB7


; C: Up / Down moves between ALBUM and ANIMATION
Mode05_State01_Choose::
    call EditMenu_AnimateIcons                    ; $7CB8
    call EditMenu_DrawBlinker                     ; $7CBB
    call EditMenu_MoveCursor                      ; $7CBE
    ldh a, [hKeysNew]                             ; $7CC1
    and PADF_A | PADF_B                           ; $7CC3
    ret z                                         ; $7CC5

    ld [wAbResult], a                             ; $7CC6
    push af                                       ; $7CC9
    bit 0, a                                      ; $7CCA
    ld a, SFX1_CHOOSE_B                           ; $7CCC
    call nz, Snd_Sfx1                             ; $7CCE
    pop af                                        ; $7CD1
    push af                                       ; $7CD2
    bit 1, a                                      ; $7CD3
    ld a, SFX1_KEY_B                              ; $7CD5
    call nz, Snd_Sfx1                             ; $7CD7
    pop af                                        ; $7CDA
    next_state                                    ; $7CDB
    ret                                           ; $7CDF


; C: B returns to the main menu; A plays the exit animation and goes to the mode of the item (table 7D17)
Mode05_State02_Dispatch::
    ld a, [wAbResult]                             ; $7CE0
    bit 0, a                                      ; $7CE3
    jr nz, jr_003_7cf8                            ; $7CE5

    ld a, MODE_MAIN_MENU                          ; $7CE7
    ld [wMode], a                                 ; $7CE9
    set_state STATE_00_INIT                       ; $7CEC
    screen_off                                    ; $7CF1
    ret                                           ; $7CF7


jr_003_7cf8:
    ld a, [wEditMenuCursor]                       ; $7CF8
    ld e, a                                       ; $7CFB
    ld d, $00                                     ; $7CFC
    ld hl, EditMenu_TargetModeTbl                 ; $7CFE
    add hl, de                                    ; $7D01
    ld a, [hl]                                    ; $7D02
    cp MODE_COUNT                                 ; $7D03
    jr c, jr_003_7d13                             ; $7D05

    play_sfx1 SFX1_BEEP_REFUSED                   ; $7D07
    ld hl, wState                                 ; $7D0E
    dec [hl]                                      ; $7D11
    ret                                           ; $7D12


jr_003_7d13:
    ld [wMode], a                                 ; $7D13
    xor a                                         ; $7D16
    ld [wState], a                                ; $7D17
    ld a, [wEditMenuCursor]                       ; $7D1A
    and a                                         ; $7D1D
    jr nz, jr_003_7d27                            ; $7D1E

    ld a, $04                                     ; $7D20
    ld [wSpriteAnimFrame], a                      ; $7D22
    jr jr_003_7d2c                                ; $7D25

jr_003_7d27:
    ld a, $04                                     ; $7D27
    ld [wSpriteAnimFrame + $1], a                 ; $7D29

jr_003_7d2c:
    ld a, $02                                     ; $7D2C
    ld [wSpriteAnimFrame + $2], a                 ; $7D2E
    xor a                                         ; $7D31
    ld [wSpriteAnimTick], a                       ; $7D32
    ld [wSpriteAnimTick + $1], a                  ; $7D35
    ld [wSpriteAnimTick + $2], a                  ; $7D38
    ld b, $28                                     ; $7D3B

jr_003_7d3d:
    push bc                                       ; $7D3D
    call EditMenu_AnimateIcons                    ; $7D3E
    call EditMenu_DrawBlinker                     ; $7D41
    call Oam_HideUnused                           ; $7D44
    rst Rst08_WaitVBlank                          ; $7D47
    pop bc                                        ; $7D48
    dec b                                         ; $7D49
    jr nz, jr_003_7d3d                            ; $7D4A

    screen_off                                    ; $7D4C
    ret                                           ; $7D52


; C: 2 bytes: target mode of ALBUM / ANIMATION
EditMenu_TargetModeTbl::
    db MODE_DELETE_PHOTO, MODE_ANIMATION_EDITOR

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 0F 12
; (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons::
    ld bc, $0300                                  ; $7D55

jr_003_7d58:
    push bc                                       ; $7D58
    ld b, $00                                     ; $7D59
    ld hl, wSpriteAnimFrame                       ; $7D5B
    add hl, bc                                    ; $7D5E
    ld e, [hl]                                    ; $7D5F
    ld hl, wSpriteAnimTick                        ; $7D60
    add hl, bc                                    ; $7D63
    ld d, [hl]                                    ; $7D64
    ld hl, EditMenu_AnimateIcons_Tbl7DB0          ; $7D65
    add hl, bc                                    ; $7D68
    ld c, [hl]                                    ; $7D69
    add hl, bc                                    ; $7D6A
    ld c, e                                       ; $7D6B
    sla c                                         ; $7D6C
    add hl, bc                                    ; $7D6E
    ld a, [hl+]                                   ; $7D6F
    pop bc                                        ; $7D70
    push bc                                       ; $7D71
    push de                                       ; $7D72
    push hl                                       ; $7D73
    sla c                                         ; $7D74
    ld b, $00                                     ; $7D76
    ld hl, EditMenu_AnimateIcons_Tbl7DAA          ; $7D78
    add hl, bc                                    ; $7D7B
    ld c, [hl]                                    ; $7D7C
    inc hl                                        ; $7D7D
    ld b, [hl]                                    ; $7D7E
    and a                                         ; $7D7F
    call nz, Oam_AddMeta_B01_4000                 ; $7D80
    pop hl                                        ; $7D83
    pop de                                        ; $7D84
    ld a, d                                       ; $7D85
    cp [hl]                                       ; $7D86
    jr nz, jr_003_7d95                            ; $7D87

    inc hl                                        ; $7D89
    ld a, [hl+]                                   ; $7D8A
    cp $ff                                        ; $7D8B
    jr z, jr_003_7d92                             ; $7D8D

    inc e                                         ; $7D8F
    jr jr_003_7d93                                ; $7D90

jr_003_7d92:
    ld e, [hl]                                    ; $7D92

jr_003_7d93:
    ld d, $00                                     ; $7D93

jr_003_7d95:
    inc d                                         ; $7D95
    pop bc                                        ; $7D96
    push bc                                       ; $7D97
    ld b, $00                                     ; $7D98
    ld hl, wSpriteAnimFrame                       ; $7D9A
    add hl, bc                                    ; $7D9D
    ld [hl], e                                    ; $7D9E
    ld hl, wSpriteAnimTick                        ; $7D9F
    add hl, bc                                    ; $7DA2
    ld [hl], d                                    ; $7DA3
    pop bc                                        ; $7DA4
    inc c                                         ; $7DA5
    dec b                                         ; $7DA6
    jr nz, jr_003_7d58                            ; $7DA7

    ret                                           ; $7DA9


; C: auto: 6 bytes, bytes; referenced by EditMenu_AnimateIcons. L3 pass 2026-10-26: read in BGB in 30 replay(s) of the
; organic corpus, modes 05 0F 12 (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons_Tbl7DAA::
    db $0b, $67, $6e, $08, $19, $36

; C: auto: 43 bytes, bytes; referenced by EditMenu_AnimateIcons. L3 pass 2026-10-26: read in BGB in 30 replay(s) of
; the organic corpus, modes 05 0F 12 (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons_Tbl7DB0::
    db $03, $10, $1d, $e3, $04, $ff, $00, $e4, $04, $ff, $02, $e3, $04, $e4, $04, $ff
    db $04, $e5, $04, $ff, $00, $e6, $04, $ff, $02, $e5, $04, $e6, $04, $ff, $04, $00
    db $04, $ff, $00, $e8, $04, $e9, $04, $ea, $04, $ff, $00

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 0F 12
; (tcrf_check/assets/l3_names/)
EditMenu_DrawBlinker::
    ld hl, wSpriteXCounter                        ; $7DDB
    inc [hl]                                      ; $7DDE
    ldh a, [hFrameCounter]                        ; $7DDF
    bit 3, a                                      ; $7DE1
    ret z                                         ; $7DE3

    ld b, [hl]                                    ; $7DE4
    ld c, $3f                                     ; $7DE5
    ld a, $e7                                     ; $7DE7
    call Oam_AddMeta_B01_4000                     ; $7DE9
    ret                                           ; $7DEC


; C
EditMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7DED
    ld b, a                                       ; $7DEF
    ld a, [wEditMenuCursor]                       ; $7DF0
    bit 6, b                                      ; $7DF3
    jr nz, jr_003_7dfb                            ; $7DF5

    bit 4, b                                      ; $7DF7
    jr z, jr_003_7e07                             ; $7DF9

jr_003_7dfb:
    and a                                         ; $7DFB
    ret z                                         ; $7DFC

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7DFD
    dec a                                         ; $7E04
    jr jr_003_7e19                                ; $7E05

jr_003_7e07:
    bit 7, b                                      ; $7E07
    jr nz, jr_003_7e0e                            ; $7E09

    bit 5, b                                      ; $7E0B
    ret z                                         ; $7E0D

jr_003_7e0e:
    cp $01                                        ; $7E0E
    ret z                                         ; $7E10

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $7E11
    inc a                                         ; $7E18

jr_003_7e19:
    ld [wEditMenuCursor], a                       ; $7E19

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
EditMenu_ResetIconAnim::
    and a                                         ; $7E1C
    jr nz, jr_003_7e2f                            ; $7E1D

    ld a, $02                                     ; $7E1F
    ld [wSpriteAnimFrame], a                      ; $7E21
    xor a                                         ; $7E24
    ld [wSpriteAnimFrame + $1], a                 ; $7E25
    ld [wSpriteAnimTick], a                       ; $7E28
    ld [wSpriteAnimTick + $1], a                  ; $7E2B
    ret                                           ; $7E2E


jr_003_7e2f:
    ld a, $02                                     ; $7E2F
    ld [wSpriteAnimFrame + $1], a                 ; $7E31
    xor a                                         ; $7E34
    ld [wSpriteAnimFrame], a                      ; $7E35
    ld [wSpriteAnimTick], a                       ; $7E38
    ld [wSpriteAnimTick + $1], a                  ; $7E3B
    ret                                           ; $7E3E


    ; padding
    ds $1c1, $00

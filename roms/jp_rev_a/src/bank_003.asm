; Pocket Camera (Japan) (Rev A), bank $03. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; C: slide-show / animation editor (47-entry list)
Mode12_AnimationEditor::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; C: 35 states, rst $18 table of mode $12
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
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $4078
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $407A
    ld de, $9800                                  ; $407D
    ld bc, $0400                                  ; $4080
    call Mem_CopyFromBank                         ; $4083
    call Oam_ClearShadow                          ; $4086
    call Pal_AllWhite                             ; $4089
    call Lcd_On                                   ; $408C
    push af                                       ; $408F
    ld a, MUSIC_ANIMATION_EDITOR                  ; $4090
    call Snd_Music                                ; $4092
    pop af                                        ; $4095
    ldh [hFarcallAArg], a                         ; $4096
    ld a, BANK(Settings_LoadAnimTranslated_Far)   ; $4098
    ld hl, Settings_LoadAnimTranslated_Far        ; $409A
    call Far_Call                                 ; $409D
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
    ld hl, wState                                 ; $40BF
    inc [hl]                                      ; $40C2
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

    ld a, BANK(Gfx_0C_5DA0_Mode12_State01_Browse) ; $40D8
    ld hl, Gfx_0C_5DA0_Mode12_State01_Browse      ; $40DA
    ld de, $88c0                                  ; $40DD
    ld bc, $0060                                  ; $40E0
    call Vram_CopyFromBank                        ; $40E3
    ld a, BANK(Gfx_0C_5D70_Mode12_State01_Browse) ; $40E6
    ld hl, Gfx_0C_5D70_Mode12_State01_Browse      ; $40E8
    ld de, $8950                                  ; $40EB
    ld bc, $0030                                  ; $40EE
    call Vram_CopyFromBank                        ; $40F1
    ld a, STATE_12_EDIT_SPEED                     ; $40F4
    ld [wState], a                                ; $40F6
    ret                                           ; $40F9


jr_003_40fa:
    ld a, STATE_12_TOGGLE_LOOP                    ; $40FA
    ld [wState], a                                ; $40FC
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
    ld a, STATE_12_ENTRY_RELEASED                 ; $412F
    ld [wState], a                                ; $4131
    ret                                           ; $4134


jr_003_4135:
    ldh a, [hKeysNew]                             ; $4135
    bit PADB_B, a                                 ; $4137
    jr z, jr_003_4150                             ; $4139

    call AnimEd_ClearSparks                       ; $413B
    ld a, [wDirtyFlag]                            ; $413E
    and a                                         ; $4141
    jr nz, jr_003_414a                            ; $4142

    ld a, STATE_12_EXIT                           ; $4144
    ld [wState], a                                ; $4146
    ret                                           ; $4149


jr_003_414a:
    ld a, STATE_12_SAVE_DIALOG_OPEN               ; $414A
    ld [wState], a                                ; $414C
    ret                                           ; $414F


jr_003_4150:
    bit 2, a                                      ; $4150
    ret z                                         ; $4152

    call AnimEd_ClearSparks                       ; $4153
    ld a, STATE_12_TOOLS_OPEN                     ; $4156
    ld [wState], a                                ; $4158
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
    ld a, STATE_12_BROWSE                         ; $41AA
    ld [wState], a                                ; $41AC
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

    ld a, BANK(Gfx_0C_48C0_Mode12_State0F_ClearAll); $41FB
    ld hl, Gfx_0C_48C0_Mode12_State0F_ClearAll    ; $41FD
    ld de, $88c0                                  ; $4200
    ld bc, $00c0                                  ; $4203
    call Vram_CopyFromBank                        ; $4206
    ld a, [wEditorRangeMode]                      ; $4209
    and a                                         ; $420C
    jr nz, jr_003_4215                            ; $420D

    ld a, STATE_12_BROWSE                         ; $420F
    ld [wState], a                                ; $4211
    ret                                           ; $4214


jr_003_4215:
    ld a, STATE_12_RANGE_BROWSE                   ; $4215
    ld [wState], a                                ; $4217
    ret                                           ; $421A


jr_003_421b:
    bit 2, a                                      ; $421B
    jr z, jr_003_4228                             ; $421D

    call AnimEd_ClearSparks                       ; $421F
    ld a, STATE_12_TOOLS_OPEN                     ; $4222
    ld [wState], a                                ; $4224
    ret                                           ; $4227


jr_003_4228:
    bit 6, a                                      ; $4228
    jr z, jr_003_424e                             ; $422A

    ld a, BANK(Gfx_0C_4950_Mode12_State03_EditSpeed); $422C
    ld hl, Gfx_0C_4950_Mode12_State03_EditSpeed   ; $422E
    ld de, $8950                                  ; $4231
    ld bc, $0030                                  ; $4234
    call Vram_CopyFromBank                        ; $4237
    ld a, BANK(Gfx_0C_5D40_Mode12_State22_BorderPickerReturn); $423A
    ld hl, Gfx_0C_5D40_Mode12_State22_BorderPickerReturn; $423C
    ld de, $8920                                  ; $423F
    ld bc, $0030                                  ; $4242
    call Vram_CopyFromBank                        ; $4245
    ld a, STATE_12_BORDER_ROW                     ; $4248
    ld [wState], a                                ; $424A
    ret                                           ; $424D


jr_003_424e:
    bit 1, a                                      ; $424E
    ret z                                         ; $4250

    call AnimEd_ClearSparks                       ; $4251
    ld a, [wDirtyFlag]                            ; $4254
    and a                                         ; $4257
    jr nz, jr_003_4260                            ; $4258

    ld a, STATE_12_EXIT                           ; $425A
    ld [wState], a                                ; $425C
    ret                                           ; $425F


jr_003_4260:
    ld a, STATE_12_SAVE_DIALOG_OPEN               ; $4260
    ld [wState], a                                ; $4262
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

; C: toggles the loop-at-end flag
Mode12_State04_ToggleLoop::
    call AnimEd_DrawEntryCursor                   ; $42A5
    call AnimEd_UpdateSparks                      ; $42A8
    ldh a, [hKeysNew]                             ; $42AB
    bit PADB_A, a                                 ; $42AD
    jr z, jr_003_42fc                             ; $42AF

    call Oam_HideUnused                           ; $42B1
    ld a, [wAnimLoopFlag]                         ; $42B4
    and a                                         ; $42B7
    jr nz, jr_003_42ca                            ; $42B8

    ld a, BANK(Gfx_0C_5FE0_Mode12_State04_ToggleLoop); $42BA
    ld hl, Gfx_0C_5FE0_Mode12_State04_ToggleLoop  ; $42BC
    ld de, $97c0                                  ; $42BF
    ld bc, $0020                                  ; $42C2
    call Vram_CopyFromBank                        ; $42C5
    jr jr_003_42d8                                ; $42C8

jr_003_42ca:
    ld a, BANK(Gfx_0C_6000_Mode12_State04_ToggleLoop); $42CA
    ld hl, Gfx_0C_6000_Mode12_State04_ToggleLoop  ; $42CC
    ld de, $97c0                                  ; $42CF
    ld bc, $0020                                  ; $42D2
    call Vram_CopyFromBank                        ; $42D5

jr_003_42d8:
    rst Rst08_WaitVBlank                          ; $42D8
    ldh a, [hKeysHeld]                            ; $42D9
    bit PADB_A, a                                 ; $42DB
    jr nz, jr_003_42d8                            ; $42DD

    call AnimEd_DrawEntryCursor                   ; $42DF
    ld a, [wAnimLoopFlag]                         ; $42E2
    xor $ff                                       ; $42E5
    ld [wAnimLoopFlag], a                         ; $42E7
    call AnimEd_ShowLoopFlag                      ; $42EA
    ld a, $03                                     ; $42ED
    ld [wSpriteAnimFrame + $5], a                 ; $42EF
    xor a                                         ; $42F2
    ld [wSpriteAnimTick + $5], a                  ; $42F3
    ld hl, wDirtyFlag                             ; $42F6
    set 0, [hl]                                   ; $42F9
    ret                                           ; $42FB


jr_003_42fc:
    call AnimEd_DrawLoopHand                      ; $42FC
    ldh a, [hKeysNewRepeat]                       ; $42FF
    bit PADB_LEFT, a                              ; $4301
    jr z, jr_003_4309                             ; $4303

    ld a, $2e                                     ; $4305
    jr jr_003_430e                                ; $4307

jr_003_4309:
    bit 4, a                                      ; $4309
    jr z, jr_003_4338                             ; $430B

    xor a                                         ; $430D

jr_003_430e:
    ld hl, wCurEntryIndex                         ; $430E
    ld [hl], a                                    ; $4311
    ld c, a                                       ; $4312
    ld b, $00                                     ; $4313
    ld hl, wAnimList                              ; $4315
    add hl, bc                                    ; $4318
    ld a, [hl]                                    ; $4319
    ld [wCurEntryValue], a                        ; $431A
    call AnimEd_LoadEntryThumb                    ; $431D
    call AnimEd_ShowEntryValue                    ; $4320
    call AnimEd_ShowEntryIndex                    ; $4323
    ld a, [wEditorRangeMode]                      ; $4326
    and a                                         ; $4329
    jr nz, jr_003_4332                            ; $432A

    ld a, STATE_12_BROWSE                         ; $432C
    ld [wState], a                                ; $432E
    ret                                           ; $4331


jr_003_4332:
    ld a, STATE_12_RANGE_BROWSE                   ; $4332
    ld [wState], a                                ; $4334
    ret                                           ; $4337


jr_003_4338:
    bit 2, a                                      ; $4338
    jr z, jr_003_4345                             ; $433A

    call AnimEd_ClearSparks                       ; $433C
    ld a, STATE_12_TOOLS_OPEN                     ; $433F
    ld [wState], a                                ; $4341
    ret                                           ; $4344


jr_003_4345:
    bit 1, a                                      ; $4345
    ret z                                         ; $4347

    call AnimEd_ClearSparks                       ; $4348
    ld a, [wDirtyFlag]                            ; $434B
    and a                                         ; $434E
    jr nz, jr_003_4357                            ; $434F

    ld a, STATE_12_EXIT                           ; $4351
    ld [wState], a                                ; $4353
    ret                                           ; $4356


jr_003_4357:
    ld a, STATE_12_SAVE_DIALOG_OPEN               ; $4357
    ld [wState], a                                ; $4359
    ret                                           ; $435C


; C: animated hand sprite beside the loop indicator. L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopHand::
    ld a, [wSpriteAnimFrame + $5]                 ; $435D
    sla a                                         ; $4360
    ld e, a                                       ; $4362
    ld d, $00                                     ; $4363
    ld hl, AnimEd_DrawLoopHand_Map4394            ; $4365
    add hl, de                                    ; $4368
    ld a, [hl+]                                   ; $4369
    ld bc, $9a84                                  ; $436A
    push hl                                       ; $436D
    cp $ff                                        ; $436E
    jr z, jr_003_4375                             ; $4370

    call Oam_AddMeta_B01_4000                     ; $4372

jr_003_4375:
    pop hl                                        ; $4375
    ld a, [wSpriteAnimTick + $5]                  ; $4376
    cp [hl]                                       ; $4379
    jr nz, jr_003_438c                            ; $437A

    ld a, [wSpriteAnimFrame + $5]                 ; $437C
    inc a                                         ; $437F
    cp $03                                        ; $4380
    jr c, jr_003_4385                             ; $4382

    xor a                                         ; $4384

jr_003_4385:
    ld [wSpriteAnimFrame + $5], a                 ; $4385
    xor a                                         ; $4388
    ld [wSpriteAnimTick + $5], a                  ; $4389

jr_003_438c:
    ld a, [wSpriteAnimTick + $5]                  ; $438C
    inc a                                         ; $438F
    ld [wSpriteAnimTick + $5], a                  ; $4390
    ret                                           ; $4393


; C: auto: 8 bytes, tile map; referenced by AnimEd_DrawLoopHand. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopHand_Map4394::
    db $71, $04, $72, $04, $73, $07, $ff, $0a

; C: fades out and returns to the edit menu (mode 05)
Mode12_State05_Exit::
    call AnimEd_StartExitTransition               ; $439C
    call Lcd_Off                                  ; $439F
    ld a, [wAbResult]                             ; $43A2
    bit 0, a                                      ; $43A5
    jr z, jr_003_43b4                             ; $43A7

    ld a, MODE_EDIT_MENU                          ; $43A9
    ld [wMode], a                                 ; $43AB
    ld a, STATE_05_INIT                           ; $43AE
    ld [wState], a                                ; $43B0
    ret                                           ; $43B3


jr_003_43b4:
    ld a, MODE_EDIT_MENU                          ; $43B4
    ld [wMode], a                                 ; $43B6
    ld a, STATE_05_INIT                           ; $43B9
    ld [wState], a                                ; $43BB
    ret                                           ; $43BE


; C: loads the tools window graphics
Mode12_State06_ToolsOpen::
    push af                                       ; $43BF
    ld a, SFX1_KEY_SELECT                         ; $43C0
    call Snd_Sfx1                                 ; $43C2
    pop af                                        ; $43C5
    ld a, BANK(Map_22_6DE0_Mode12_State06_ToolsOpen); $43C6
    ld hl, Map_22_6DE0_Mode12_State06_ToolsOpen   ; $43C8
    ld de, $9840                                  ; $43CB
    ld bc, $0040                                  ; $43CE
    call Vram_CopyFromBank                        ; $43D1
    ld hl, wState                                 ; $43D4
    inc [hl]                                      ; $43D7
    ret                                           ; $43D8


; C: slides the tools window in
Mode12_State07_ToolsSlideIn::
    ld a, BANK(Gfx_0C_4D50_Mode12_State07_ToolsSlideIn); $43D9
    ld hl, Gfx_0C_4D50_Mode12_State07_ToolsSlideIn; $43DB
    ld de, $8d50                                  ; $43DE
    ld bc, $0280                                  ; $43E1
    call Vram_CopyFromBank                        ; $43E4
    call Oam_ClearShadow                          ; $43E7
    ld a, $75                                     ; $43EA
    ld [wSpriteAnimFrame + $6], a                 ; $43EC
    ld hl, Slide_ScyDeltaTbl                      ; $43EF
    ld b, $10                                     ; $43F2

jr_003_43f4:
    push bc                                       ; $43F4
    push hl                                       ; $43F5
    ldh a, [hScyShadow]                           ; $43F6
    add [hl]                                      ; $43F8
    ldh [hScyShadow], a                           ; $43F9
    rst Rst08_WaitVBlank                          ; $43FB
    pop hl                                        ; $43FC
    pop bc                                        ; $43FD
    inc hl                                        ; $43FE
    dec b                                         ; $43FF
    jr nz, jr_003_43f4                            ; $4400

    ld hl, wState                                 ; $4402
    inc [hl]                                      ; $4405
    ret                                           ; $4406


; C: LOOP / SORT / PACK / TEST / CLEAR tool menu: choice goes through the table at 449D
Mode12_State08_ToolsMenu::
    call AnimEd_ToolsMenuMove                     ; $4407
    call AnimEd_ToolsMenuCursor                   ; $440A
    ldh a, [hKeysNew]                             ; $440D
    and PADF_A | PADF_B | PADF_DOWN               ; $440F
    ret z                                         ; $4411

    push af                                       ; $4412
    bit 0, a                                      ; $4413
    ld a, SFX1_KEY_A                              ; $4415
    call nz, Snd_Sfx1                             ; $4417
    pop af                                        ; $441A
    push af                                       ; $441B
    bit 1, a                                      ; $441C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $441E
    call nz, Snd_Sfx1                             ; $4420
    pop af                                        ; $4423
    push af                                       ; $4424
    bit 7, a                                      ; $4425
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4427
    call nz, Snd_Sfx1                             ; $4429
    pop af                                        ; $442C
    push af                                       ; $442D
    bit 0, a                                      ; $442E
    jr z, jr_003_444a                             ; $4430

    call Oam_HideUnused                           ; $4432
    rst Rst08_WaitVBlank                          ; $4435
    ld a, $76                                     ; $4436
    ld [wSpriteAnimFrame + $6], a                 ; $4438
    call AnimEd_ToolsMenuCursor                   ; $443B
    call Oam_HideUnused                           ; $443E
    call AnimEd_LoadMenuTiles                     ; $4441
    ld bc, $0019                                  ; $4444
    call Wait_Frames                              ; $4447

jr_003_444a:
    call Oam_ClearShadow                          ; $444A
    ld hl, Slide_ScyDeltaTbl                      ; $444D
    ld b, $10                                     ; $4450

jr_003_4452:
    push bc                                       ; $4452
    push hl                                       ; $4453
    ldh a, [hScyShadow]                           ; $4454
    sub [hl]                                      ; $4456
    ldh [hScyShadow], a                           ; $4457
    rst Rst08_WaitVBlank                          ; $4459
    pop hl                                        ; $445A
    pop bc                                        ; $445B
    inc hl                                        ; $445C
    dec b                                         ; $445D
    jr nz, jr_003_4452                            ; $445E

    xor a                                         ; $4460
    ld [wSpriteAnimFrame + $3], a                 ; $4461
    ld [wSpriteAnimTick + $3], a                  ; $4464
    ld a, BANK(Map_1D_7FC0_Mode12_State08_ToolsMenu); $4467
    ld hl, Map_1D_7FC0_Mode12_State08_ToolsMenu   ; $4469
    ld de, $9840                                  ; $446C
    ld bc, $0040                                  ; $446F
    call Vram_CopyFromBank                        ; $4472
    pop af                                        ; $4475
    bit 0, a                                      ; $4476
    jr nz, jr_003_448e                            ; $4478

    ld a, BANK(Map_1D_7FC0_Mode12_State08_ToolsMenu); $447A
    ld hl, Map_1D_7FC0_Mode12_State08_ToolsMenu   ; $447C
    ld de, $9840                                  ; $447F
    ld bc, $0040                                  ; $4482
    call Vram_CopyFromBank                        ; $4485
    ld a, STATE_12_BROWSE                         ; $4488
    ld [wState], a                                ; $448A
    ret                                           ; $448D


jr_003_448e:
    ld a, [wEditorMenuOption]                     ; $448E
    ld c, a                                       ; $4491
    ld b, $00                                     ; $4492
    ld hl, AnimEd_ToolsStateTbl                   ; $4494
    add hl, bc                                    ; $4497
    ld a, [hl]                                    ; $4498
    ld [wState], a                                ; $4499
    ret                                           ; $449C


; C: 5 states reached by the tools menu
AnimEd_ToolsStateTbl::
    db $09, $1d, $10, $11, $1a

; C: Up / Down moves the tool selection (0..4)
AnimEd_ToolsMenuMove::
    ldh a, [hKeysNewRepeat]                       ; $44A2
    ld b, a                                       ; $44A4
    ld a, [wEditorMenuOption]                     ; $44A5
    bit 5, b                                      ; $44A8
    jr z, jr_003_44b1                             ; $44AA

    and a                                         ; $44AC
    ret z                                         ; $44AD

    dec a                                         ; $44AE
    jr jr_003_44b8                                ; $44AF

jr_003_44b1:
    bit 4, b                                      ; $44B1
    ret z                                         ; $44B3

    cp $04                                        ; $44B4
    ret z                                         ; $44B6

    inc a                                         ; $44B7

jr_003_44b8:
    ld [wEditorMenuOption], a                     ; $44B8
    push af                                       ; $44BB
    ld a, SFX1_DIRECTION_KEY                      ; $44BC
    call Snd_Sfx1                                 ; $44BE
    pop af                                        ; $44C1
    ret                                           ; $44C2


; C: draws the tool menu cursor sprite. L3 pass 2026-10-26: executed in BGB in 20 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ToolsMenuCursor::
    ld a, [wEditorMenuOption]                     ; $44C3
    ld c, a                                       ; $44C6
    ld b, $00                                     ; $44C7
    ld hl, AnimEd_ToolsMenuCursor_Tbl44DB         ; $44C9
    add hl, bc                                    ; $44CC
    ld b, [hl]                                    ; $44CD
    ldh a, [hScyShadow]                           ; $44CE
    cpl                                           ; $44D0
    add $0a                                       ; $44D1
    ld c, a                                       ; $44D3
    ld a, [wSpriteAnimFrame + $6]                 ; $44D4
    call Oam_AddMeta_B01_4000                     ; $44D7
    ret                                           ; $44DA


; C: auto: 5 bytes, bytes; referenced by AnimEd_ToolsMenuCursor. L3 pass 2026-10-26: read in BGB in 20 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ToolsMenuCursor_Tbl44DB::
    db $08, $28, $48, $68, $88

; C: range mode (loop markers): cursor moves
Mode12_State09_RangeBrowse::
    ld a, $01                                     ; $44E0
    ld [wEditorRangeMode], a                      ; $44E2
    call AnimEd_PreviewTick                       ; $44E5
    call AnimEd_MoveEntryCursor                   ; $44E8
    jr nc, jr_003_451d                            ; $44EB

    push af                                       ; $44ED
    call AnimEd_DrawEntryCursor                   ; $44EE
    pop af                                        ; $44F1
    and a                                         ; $44F2
    jr nz, jr_003_4517                            ; $44F3

    ld a, BANK(Gfx_0C_5DA0_Mode12_State01_Browse) ; $44F5
    ld hl, Gfx_0C_5DA0_Mode12_State01_Browse      ; $44F7
    ld de, $88c0                                  ; $44FA
    ld bc, $0060                                  ; $44FD
    call Vram_CopyFromBank                        ; $4500
    ld a, BANK(Gfx_0C_5D70_Mode12_State01_Browse) ; $4503
    ld hl, Gfx_0C_5D70_Mode12_State01_Browse      ; $4505
    ld de, $8950                                  ; $4508
    ld bc, $0030                                  ; $450B
    call Vram_CopyFromBank                        ; $450E
    ld a, STATE_12_EDIT_SPEED                     ; $4511
    ld [wState], a                                ; $4513
    ret                                           ; $4516


jr_003_4517:
    ld a, STATE_12_TOGGLE_LOOP                    ; $4517
    ld [wState], a                                ; $4519
    ret                                           ; $451C


jr_003_451d:
    call AnimEd_DrawEntryCursor                   ; $451D
    call AnimEd_DrawHandSprite                    ; $4520
    ldh a, [hKeysNew]                             ; $4523
    bit PADB_A, a                                 ; $4525
    jr z, jr_003_459a                             ; $4527

    ld a, [wCurEntryIndex]                        ; $4529
    ld c, a                                       ; $452C
    ld b, $00                                     ; $452D
    ld hl, wAnimTiming                            ; $452F
    add hl, bc                                    ; $4532
    ld a, [hl+]                                   ; $4533
    and a                                         ; $4534
    jr z, jr_003_4569                             ; $4535

jr_003_4537:
    bit 6, a                                      ; $4537
    jr nz, jr_003_453f                            ; $4539

    inc c                                         ; $453B
    ld a, [hl+]                                   ; $453C
    jr jr_003_4537                                ; $453D

jr_003_453f:
    ld a, c                                       ; $453F
    ld [wRangeMovingEnd], a                       ; $4540
    dec hl                                        ; $4543
    dec hl                                        ; $4544
    dec c                                         ; $4545
    ld a, [hl-]                                   ; $4546

jr_003_4547:
    bit 7, a                                      ; $4547
    jr nz, jr_003_454f                            ; $4549

    dec c                                         ; $454B
    ld a, [hl-]                                   ; $454C
    jr jr_003_4547                                ; $454D

jr_003_454f:
    and $3f                                       ; $454F
    ld [wSpriteAnimTick + $9], a                  ; $4551
    ld a, c                                       ; $4554
    ld [wRangeAnchor], a                          ; $4555
    xor a                                         ; $4558
    ld [wRangeDirection], a                       ; $4559
    push af                                       ; $455C
    ld a, SFX1_CHOOSE                             ; $455D
    call Snd_Sfx1                                 ; $455F
    pop af                                        ; $4562
    ld a, STATE_12_RANGE_ANIM                     ; $4563
    ld [wState], a                                ; $4565
    ret                                           ; $4568


jr_003_4569:
    ld a, c                                       ; $4569
    inc a                                         ; $456A
    ld [wRangeMovingEnd], a                       ; $456B
    xor a                                         ; $456E
    ld [wRangeDirection], a                       ; $456F
    ld a, [hl-]                                   ; $4572
    and a                                         ; $4573
    jr z, jr_003_4584                             ; $4574

    dec hl                                        ; $4576
    ld a, [hl]                                    ; $4577
    and a                                         ; $4578
    ret nz                                        ; $4579

    ld a, c                                       ; $457A
    dec a                                         ; $457B
    ld [wRangeMovingEnd], a                       ; $457C
    ld a, $01                                     ; $457F
    ld [wRangeDirection], a                       ; $4581

jr_003_4584:
    ld a, $02                                     ; $4584
    ld [wSpriteAnimTick + $9], a                  ; $4586
    ld a, c                                       ; $4589
    ld [wRangeAnchor], a                          ; $458A
    push af                                       ; $458D
    ld a, SFX1_CHOOSE                             ; $458E
    call Snd_Sfx1                                 ; $4590
    pop af                                        ; $4593
    ld a, STATE_12_RANGE_ANIM                     ; $4594
    ld [wState], a                                ; $4596
    ret                                           ; $4599


jr_003_459a:
    ldh a, [hKeysNew]                             ; $459A
    bit PADB_SELECT, a                            ; $459C
    jr z, jr_003_45a6                             ; $459E

    ld a, STATE_12_TOOLS_OPEN                     ; $45A0
    ld [wState], a                                ; $45A2
    ret                                           ; $45A5


jr_003_45a6:
    bit 1, a                                      ; $45A6
    ret z                                         ; $45A8

    push af                                       ; $45A9
    ld a, SFX1_CHOOSE_C                           ; $45AA
    call Snd_Sfx1                                 ; $45AC
    pop af                                        ; $45AF
    ld a, STATE_12_BROWSE                         ; $45B0
    ld [wState], a                                ; $45B2
    ret                                           ; $45B5


; C: animated start of a range. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
Mode12_State0A_RangeAnim::
    xor a                                         ; $45B6
    ld [wSpriteAnimFrame + $7], a                 ; $45B7
    ld [wSpriteAnimTick + $7], a                  ; $45BA
    ld a, [wRangeAnchor]                          ; $45BD
    inc a                                         ; $45C0
    push af                                       ; $45C1
    and $0f                                       ; $45C2
    sla a                                         ; $45C4
    sla a                                         ; $45C6
    sla a                                         ; $45C8
    add $10                                       ; $45CA
    ld [wRangeCursorXy], a                        ; $45CC
    pop af                                        ; $45CF
    and $f0                                       ; $45D0
    add $5a                                       ; $45D2
    ld [wRangeCursorXy + $2], a                   ; $45D4

jr_003_45d7:
    ld c, $00                                     ; $45D7
    ld de, $0000                                  ; $45D9
    call AnimEd_DrawRangeArrow                    ; $45DC
    call AnimEd_StepRangeAnim                     ; $45DF
    call AnimEd_DrawEntryCursor                   ; $45E2
    call Oam_HideUnused                           ; $45E5
    rst Rst08_WaitVBlank                          ; $45E8
    ld a, [wRangeAnimDone]                        ; $45E9
    and a                                         ; $45EC
    jr z, jr_003_45d7                             ; $45ED

    ld a, [wRangeDirection]                       ; $45EF
    and a                                         ; $45F2
    jr nz, jr_003_4602                            ; $45F3

    ld a, [wRangeAnchor]                          ; $45F5
    ld e, $a7                                     ; $45F8
    call AnimEd_PutGridTile                       ; $45FA
    ld de, $0029                                  ; $45FD
    jr jr_003_460d                                ; $4600

jr_003_4602:
    ld a, [wRangeAnchor]                          ; $4602
    ld e, $a9                                     ; $4605
    call AnimEd_PutGridTile                       ; $4607
    ld de, $0036                                  ; $460A

jr_003_460d:
    xor a                                         ; $460D
    ld [wSpriteAnimFrame + $7], a                 ; $460E
    ld [wSpriteAnimTick + $7], a                  ; $4611
    ld c, $00                                     ; $4614
    call AnimEd_StepRangeAnim                     ; $4616
    xor a                                         ; $4619
    ld [wSpriteAnimFrame + $8], a                 ; $461A
    ld [wSpriteAnimTick + $8], a                  ; $461D
    ld a, [wRangeAnchor]                          ; $4620
    inc a                                         ; $4623
    push af                                       ; $4624
    and $0f                                       ; $4625
    sla a                                         ; $4627
    sla a                                         ; $4629
    sla a                                         ; $462B
    add $10                                       ; $462D
    ld [wRangeCursorXy + $1], a                   ; $462F
    pop af                                        ; $4632
    and $f0                                       ; $4633
    add $5e                                       ; $4635
    ld [wRangeCursorXy + $3], a                   ; $4637

jr_003_463a:
    ld a, [wRangeDirection]                       ; $463A
    and a                                         ; $463D
    jr nz, jr_003_4649                            ; $463E

    ld de, $0043                                  ; $4640
    push de                                       ; $4643
    ld de, $0029                                  ; $4644
    jr jr_003_4650                                ; $4647

jr_003_4649:
    ld de, $004c                                  ; $4649
    push de                                       ; $464C
    ld de, $0036                                  ; $464D

jr_003_4650:
    xor a                                         ; $4650
    ld [wSpriteAnimFrame + $7], a                 ; $4651
    ld [wSpriteAnimTick + $7], a                  ; $4654
    ld c, $00                                     ; $4657
    call AnimEd_DrawRangeArrow                    ; $4659
    call AnimEd_StepRangeAnim                     ; $465C
    pop de                                        ; $465F
    ld c, $01                                     ; $4660
    call AnimEd_DrawRangeArrow                    ; $4662
    call AnimEd_StepRangeAnim                     ; $4665
    call AnimEd_DrawEntryCursor                   ; $4668
    call Oam_HideUnused                           ; $466B
    rst Rst08_WaitVBlank                          ; $466E
    ld a, [wRangeAnimDone + $1]                   ; $466F
    and a                                         ; $4672
    jr z, jr_003_463a                             ; $4673

    ld a, [wRangeAnchor]                          ; $4675
    ld b, a                                       ; $4678
    ld a, [wRangeDirection]                       ; $4679
    and a                                         ; $467C
    jr nz, jr_003_4686                            ; $467D

    ld de, $0029                                  ; $467F
    ld c, $01                                     ; $4682
    jr jr_003_468b                                ; $4684

jr_003_4686:
    ld de, $0036                                  ; $4686
    ld c, $ff                                     ; $4689

jr_003_468b:
    ld a, b                                       ; $468B
    add c                                         ; $468C
    ld b, a                                       ; $468D
    push bc                                       ; $468E
    push de                                       ; $468F
    ld e, $a8                                     ; $4690
    call AnimEd_PutGridTile                       ; $4692
    ld a, b                                       ; $4695
    inc a                                         ; $4696
    push af                                       ; $4697
    and $0f                                       ; $4698
    sla a                                         ; $469A
    sla a                                         ; $469C
    sla a                                         ; $469E
    add $10                                       ; $46A0
    ld [wRangeCursorXy + $1], a                   ; $46A2
    pop af                                        ; $46A5
    and $f0                                       ; $46A6
    add $5e                                       ; $46A8
    ld [wRangeCursorXy + $3], a                   ; $46AA
    pop de                                        ; $46AD
    push de                                       ; $46AE
    push bc                                       ; $46AF
    ld c, $00                                     ; $46B0
    call AnimEd_DrawRangeArrow                    ; $46B2
    call AnimEd_StepRangeAnim                     ; $46B5
    call AnimEd_DrawRangeEndCursor                ; $46B8
    pop bc                                        ; $46BB
    ld a, b                                       ; $46BC
    ld [wCurEntryIndex], a                        ; $46BD
    ld c, a                                       ; $46C0
    ld b, $00                                     ; $46C1
    ld hl, wAnimList                              ; $46C3
    add hl, bc                                    ; $46C6
    ld a, [hl]                                    ; $46C7
    ld [wCurEntryValue], a                        ; $46C8
    call AnimEd_LoadEntryThumb                    ; $46CB
    call AnimEd_ShowEntryValue                    ; $46CE
    call AnimEd_ShowEntryIndex                    ; $46D1
    call AnimEd_DrawEntryCursor                   ; $46D4
    call Oam_HideUnused                           ; $46D7
    rst Rst08_WaitVBlank                          ; $46DA
    pop de                                        ; $46DB
    pop bc                                        ; $46DC
    ld a, [wRangeMovingEnd]                       ; $46DD
    cp b                                          ; $46E0
    jr nz, jr_003_468b                            ; $46E1

    ld c, $00                                     ; $46E3
    call AnimEd_DrawRangeArrow                    ; $46E5
    call AnimEd_StepRangeAnim                     ; $46E8
    call AnimEd_DrawRangeEndCursor                ; $46EB
    call AnimEd_DrawEntryCursor                   ; $46EE
    ld hl, wState                                 ; $46F1
    inc [hl]                                      ; $46F4
    ret                                           ; $46F5


; C: draws a range-edit arrow sprite. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes
; 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeArrow::
    push bc                                       ; $46F6
    push de                                       ; $46F7
    ld b, $00                                     ; $46F8
    push bc                                       ; $46FA
    ld hl, wSpriteAnimFrame + $7                  ; $46FB
    add hl, bc                                    ; $46FE
    ld a, [hl]                                    ; $46FF
    sla a                                         ; $4700
    sla a                                         ; $4702
    ld c, a                                       ; $4704
    ld b, $00                                     ; $4705
    ld hl, AnimEd_DrawRangeArrow_Tbl4790          ; $4707
    add hl, bc                                    ; $470A
    add hl, de                                    ; $470B
    ld a, [hl]                                    ; $470C
    pop bc                                        ; $470D
    ld hl, wRangeCursorXy                         ; $470E
    add hl, bc                                    ; $4711
    ld b, [hl]                                    ; $4712
    inc hl                                        ; $4713
    inc hl                                        ; $4714
    ld c, [hl]                                    ; $4715
    cp $ff                                        ; $4716
    jr z, jr_003_471d                             ; $4718

    call Oam_AddMeta_B01_4000                     ; $471A

jr_003_471d:
    pop de                                        ; $471D
    pop bc                                        ; $471E
    ret                                           ; $471F


; C: advances the range arrow animation. L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StepRangeAnim::
    push bc                                       ; $4720
    push de                                       ; $4721
    ld b, $00                                     ; $4722
    push bc                                       ; $4724
    ld hl, wRangeAnimDone                         ; $4725
    add hl, bc                                    ; $4728
    ld [hl], $00                                  ; $4729
    ld hl, wSpriteAnimFrame + $7                  ; $472B
    add hl, bc                                    ; $472E
    ld a, [hl]                                    ; $472F
    sla a                                         ; $4730
    sla a                                         ; $4732
    ld c, a                                       ; $4734
    ld hl, AnimEd_StepRangeAnim_Tbl478D           ; $4735
    add hl, bc                                    ; $4738
    add hl, de                                    ; $4739
    ld a, [hl]                                    ; $473A
    pop bc                                        ; $473B
    push bc                                       ; $473C
    push hl                                       ; $473D
    ld hl, wSpriteAnimTick + $7                   ; $473E
    add hl, bc                                    ; $4741
    cp [hl]                                       ; $4742
    ld a, [hl]                                    ; $4743
    jr nz, jr_003_4771                            ; $4744

    ld hl, wSpriteAnimFrame + $7                  ; $4746
    add hl, bc                                    ; $4749
    ld a, [hl]                                    ; $474A
    inc a                                         ; $474B
    ld c, a                                       ; $474C
    pop hl                                        ; $474D
    inc hl                                        ; $474E
    inc hl                                        ; $474F
    inc hl                                        ; $4750
    inc hl                                        ; $4751
    ld a, [hl]                                    ; $4752
    and a                                         ; $4753
    jr nz, jr_003_4763                            ; $4754

    pop bc                                        ; $4756
    push bc                                       ; $4757
    ld hl, wRangeAnimDone                         ; $4758
    add hl, bc                                    ; $475B
    inc [hl]                                      ; $475C
    ld c, $00                                     ; $475D
    ld hl, AnimEd_StepRangeAnim_Tbl478D           ; $475F
    add hl, de                                    ; $4762

jr_003_4763:
    pop de                                        ; $4763
    push de                                       ; $4764
    push hl                                       ; $4765
    ld hl, wSpriteAnimFrame + $7                  ; $4766
    add hl, de                                    ; $4769
    ld [hl], c                                    ; $476A
    ld hl, wSpriteAnimTick + $7                   ; $476B
    add hl, de                                    ; $476E
    xor a                                         ; $476F
    ld [hl], a                                    ; $4770

jr_003_4771:
    pop de                                        ; $4771
    and a                                         ; $4772
    jr nz, jr_003_4784                            ; $4773

    inc de                                        ; $4775
    pop bc                                        ; $4776
    push bc                                       ; $4777
    ld hl, wRangeCursorXy                         ; $4778
    add hl, bc                                    ; $477B
    ld a, [de]                                    ; $477C
    add [hl]                                      ; $477D
    ld [hl+], a                                   ; $477E
    inc de                                        ; $477F
    inc hl                                        ; $4780
    ld a, [de]                                    ; $4781
    add [hl]                                      ; $4782
    ld [hl], a                                    ; $4783

jr_003_4784:
    pop bc                                        ; $4784
    ld hl, wSpriteAnimTick + $7                   ; $4785
    add hl, bc                                    ; $4788
    inc [hl]                                      ; $4789
    pop de                                        ; $478A
    pop bc                                        ; $478B
    ret                                           ; $478C


; C: auto: 3 bytes, bytes; referenced by AnimEd_StepRangeAnim. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StepRangeAnim_Tbl478D::
    db $02, $00, $02

; C: auto: 164 bytes, bytes; referenced by AnimEd_DrawRangeArrow. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeArrow_Tbl4790::
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
    call AnimEd_PreviewTick                       ; $4834
    call AnimEd_MoveRangeEnd                      ; $4837
    ld a, [wRangeDirection]                       ; $483A
    and a                                         ; $483D
    jr nz, jr_003_4845                            ; $483E

    ld de, $0029                                  ; $4840
    jr jr_003_4851                                ; $4843

jr_003_4845:
    bit 7, a                                      ; $4845
    jr nz, jr_003_484e                            ; $4847

    ld de, $0036                                  ; $4849
    jr jr_003_4851                                ; $484C

jr_003_484e:
    ld de, $0055                                  ; $484E

jr_003_4851:
    ld c, $00                                     ; $4851
    call AnimEd_DrawRangeArrow                    ; $4853
    call AnimEd_StepRangeAnim                     ; $4856
    ld a, [wRangeDirection]                       ; $4859
    bit 7, a                                      ; $485C
    jr nz, jr_003_4863                            ; $485E

    call AnimEd_DrawRangeEndCursor                ; $4860

jr_003_4863:
    call AnimEd_DrawEntryCursor                   ; $4863
    ldh a, [hKeysNew]                             ; $4866
    bit PADB_A, a                                 ; $4868
    jr z, jr_003_48b5                             ; $486A

    ld a, [wRangeDirection]                       ; $486C
    cp $ff                                        ; $486F
    jr nz, jr_003_4879                            ; $4871

    ld a, STATE_12_LOOP_CLEAR                     ; $4873
    ld [wState], a                                ; $4875
    ret                                           ; $4878


jr_003_4879:
    call AnimEd_RangeConfirmAnim                  ; $4879
    ld a, [wRangeDirection]                       ; $487C
    and a                                         ; $487F
    jr nz, jr_003_488c                            ; $4880

    ld a, [wRangeAnchor]                          ; $4882
    ld b, a                                       ; $4885
    ld a, [wRangeMovingEnd]                       ; $4886
    ld c, a                                       ; $4889
    jr jr_003_4894                                ; $488A

jr_003_488c:
    ld a, [wRangeAnchor]                          ; $488C
    ld c, a                                       ; $488F
    ld a, [wRangeMovingEnd]                       ; $4890
    ld b, a                                       ; $4893

jr_003_4894:
    ld e, $a4                                     ; $4894
    ld a, b                                       ; $4896
    call AnimEd_PutGridTile                       ; $4897
    inc e                                         ; $489A

jr_003_489b:
    inc b                                         ; $489B
    ld a, b                                       ; $489C
    cp c                                          ; $489D
    jr z, jr_003_48a5                             ; $489E

    call AnimEd_PutGridTile                       ; $48A0
    jr jr_003_489b                                ; $48A3

jr_003_48a5:
    inc e                                         ; $48A5
    call AnimEd_PutGridTile                       ; $48A6
    push af                                       ; $48A9
    ld a, SFX1_CURSOR_MOVE                        ; $48AA
    call Snd_Sfx1                                 ; $48AC
    pop af                                        ; $48AF
    ld hl, wState                                 ; $48B0
    inc [hl]                                      ; $48B3
    ret                                           ; $48B4


jr_003_48b5:
    bit 1, a                                      ; $48B5
    ret z                                         ; $48B7

    call AnimEd_DrawTimingMarkers                 ; $48B8
    ld a, STATE_12_RANGE_BROWSE                   ; $48BB
    ld [wState], a                                ; $48BD
    ret                                           ; $48C0


; C: L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawRangeEndCursor::
    ld a, [wRangeDirection]                       ; $48C1
    and a                                         ; $48C4
    jr nz, jr_003_48cb                            ; $48C5

    ld a, $68                                     ; $48C7
    jr jr_003_48cd                                ; $48C9

jr_003_48cb:
    ld a, $6d                                     ; $48CB

jr_003_48cd:
    ld hl, wRangeCursorXy + $1                    ; $48CD
    ld b, [hl]                                    ; $48D0
    inc hl                                        ; $48D1
    inc hl                                        ; $48D2
    ld c, [hl]                                    ; $48D3
    call Oam_AddMeta_B01_4000                     ; $48D4
    ret                                           ; $48D7


; C: Left / Right moves the moving end of the range
AnimEd_MoveRangeEnd::
    ldh a, [hKeysNewRepeat]                       ; $48D8
    ld b, a                                       ; $48DA
    ld a, [wRangeMovingEnd]                       ; $48DB
    bit 5, b                                      ; $48DE
    jr z, jr_003_4900                             ; $48E0

    and a                                         ; $48E2
    ret z                                         ; $48E3

    push af                                       ; $48E4
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $48E5
    call Snd_Sfx1                                 ; $48E7
    pop af                                        ; $48EA
    ld hl, wRangeAnchor                           ; $48EB
    cp [hl]                                       ; $48EE
    jr z, jr_003_48f3                             ; $48EF

    jr nc, jr_003_48fd                            ; $48F1

jr_003_48f3:
    ld e, a                                       ; $48F3
    ld d, $00                                     ; $48F4
    ld hl, wAnimTimingGuardLo                     ; $48F6
    add hl, de                                    ; $48F9
    bit 6, [hl]                                   ; $48FA
    ret nz                                        ; $48FC

jr_003_48fd:
    dec a                                         ; $48FD
    jr jr_003_491e                                ; $48FE

jr_003_4900:
    bit 4, b                                      ; $4900
    ret z                                         ; $4902

    cp $2e                                        ; $4903
    ret z                                         ; $4905

    push af                                       ; $4906
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4907
    call Snd_Sfx1                                 ; $4909
    pop af                                        ; $490C
    ld hl, wRangeAnchor                           ; $490D
    cp [hl]                                       ; $4910
    jr c, jr_003_491d                             ; $4911

    ld e, a                                       ; $4913
    ld d, $00                                     ; $4914
    ld hl, wAnimTiming + $1                       ; $4916
    add hl, de                                    ; $4919
    bit 7, [hl]                                   ; $491A
    ret nz                                        ; $491C

jr_003_491d:
    inc a                                         ; $491D

jr_003_491e:
    ld c, a                                       ; $491E
    ld hl, wRangeMovingEnd                        ; $491F
    ld a, [wRangeDirection]                       ; $4922
    and a                                         ; $4925
    jr nz, jr_003_492e                            ; $4926

    ld a, c                                       ; $4928
    cp [hl]                                       ; $4929
    jr nc, jr_003_494f                            ; $492A

    jr jr_003_4949                                ; $492C

jr_003_492e:
    dec a                                         ; $492E
    jr nz, jr_003_4937                            ; $492F

    ld a, c                                       ; $4931
    cp [hl]                                       ; $4932
    jr c, jr_003_494f                             ; $4933

    jr jr_003_4949                                ; $4935

jr_003_4937:
    ld a, c                                       ; $4937
    cp [hl]                                       ; $4938
    ld a, [hl]                                    ; $4939
    jr c, jr_003_4940                             ; $493A

    ld e, $a7                                     ; $493C
    jr jr_003_4942                                ; $493E

jr_003_4940:
    ld e, $a9                                     ; $4940

jr_003_4942:
    push bc                                       ; $4942
    call AnimEd_PutGridTile                       ; $4943
    pop bc                                        ; $4946
    jr jr_003_494f                                ; $4947

jr_003_4949:
    ld a, [hl]                                    ; $4949
    ld e, $5c                                     ; $494A
    call AnimEd_PutGridTile                       ; $494C

jr_003_494f:
    ld a, c                                       ; $494F
    ld [wRangeMovingEnd], a                       ; $4950
    ld hl, wRangeAnchor                           ; $4953
    cp [hl]                                       ; $4956
    jr c, jr_003_4963                             ; $4957

    jr z, jr_003_496c                             ; $4959

    ld e, $a8                                     ; $495B
    call AnimEd_PutGridTile                       ; $495D
    xor a                                         ; $4960
    jr jr_003_4973                                ; $4961

jr_003_4963:
    ld e, $a8                                     ; $4963
    call AnimEd_PutGridTile                       ; $4965
    ld a, $01                                     ; $4968
    jr jr_003_4973                                ; $496A

jr_003_496c:
    ld e, $5c                                     ; $496C
    call AnimEd_PutGridTile                       ; $496E
    ld a, $ff                                     ; $4971

jr_003_4973:
    ld hl, wRangeDirection                        ; $4973
    cp [hl]                                       ; $4976
    jr z, jr_003_499d                             ; $4977

    ld [wRangeDirection], a                       ; $4979
    xor a                                         ; $497C
    ld [wSpriteAnimFrame + $7], a                 ; $497D
    ld [wSpriteAnimTick + $7], a                  ; $4980
    ld a, [wRangeAnchor]                          ; $4983
    inc a                                         ; $4986
    push af                                       ; $4987
    and $0f                                       ; $4988
    sla a                                         ; $498A
    sla a                                         ; $498C
    sla a                                         ; $498E
    add $10                                       ; $4990
    ld [wRangeCursorXy], a                        ; $4992
    pop af                                        ; $4995
    and $f0                                       ; $4996
    add $5f                                       ; $4998
    ld [wRangeCursorXy + $2], a                   ; $499A

jr_003_499d:
    ld a, [wRangeMovingEnd]                       ; $499D
    inc a                                         ; $49A0
    push af                                       ; $49A1
    and $0f                                       ; $49A2
    sla a                                         ; $49A4
    sla a                                         ; $49A6
    sla a                                         ; $49A8
    add $10                                       ; $49AA
    ld [wRangeCursorXy + $1], a                   ; $49AC
    pop af                                        ; $49AF
    and $f0                                       ; $49B0
    add $5e                                       ; $49B2
    ld [wRangeCursorXy + $3], a                   ; $49B4
    ld a, [wRangeMovingEnd]                       ; $49B7
    ld [wCurEntryIndex], a                        ; $49BA
    ld c, a                                       ; $49BD
    ld b, $00                                     ; $49BE
    ld hl, wAnimList                              ; $49C0
    add hl, bc                                    ; $49C3
    ld a, [hl]                                    ; $49C4
    ld [wCurEntryValue], a                        ; $49C5
    call AnimEd_LoadEntryThumb                    ; $49C8
    call AnimEd_ShowEntryValue                    ; $49CB
    call AnimEd_ShowEntryIndex                    ; $49CE
    ret                                           ; $49D1


; C: confirm animation of the range arrows. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_RangeConfirmAnim::
    xor a                                         ; $49D2
    ld [wSpriteAnimFrame + $8], a                 ; $49D3
    ld [wSpriteAnimTick + $8], a                  ; $49D6
    ld a, [wRangeMovingEnd]                       ; $49D9
    inc a                                         ; $49DC
    push af                                       ; $49DD
    and $0f                                       ; $49DE
    sla a                                         ; $49E0
    sla a                                         ; $49E2
    sla a                                         ; $49E4
    add $10                                       ; $49E6
    ld [wRangeCursorXy + $1], a                   ; $49E8
    pop af                                        ; $49EB
    and $f0                                       ; $49EC
    add $5a                                       ; $49EE
    ld [wRangeCursorXy + $3], a                   ; $49F0

jr_003_49f3:
    ld a, [wRangeDirection]                       ; $49F3
    and a                                         ; $49F6
    jr nz, jr_003_4a11                            ; $49F7

    ld de, $0029                                  ; $49F9
    ld c, $00                                     ; $49FC
    call AnimEd_DrawRangeArrow                    ; $49FE
    call AnimEd_StepRangeAnim                     ; $4A01
    ld c, $01                                     ; $4A04
    ld de, $0000                                  ; $4A06
    call AnimEd_DrawRangeArrow                    ; $4A09
    call AnimEd_StepRangeAnim                     ; $4A0C
    jr jr_003_4a27                                ; $4A0F

jr_003_4a11:
    ld de, $0036                                  ; $4A11
    ld c, $00                                     ; $4A14
    call AnimEd_DrawRangeArrow                    ; $4A16
    call AnimEd_StepRangeAnim                     ; $4A19
    ld c, $01                                     ; $4A1C
    ld de, $007e                                  ; $4A1E
    call AnimEd_DrawRangeArrow                    ; $4A21
    call AnimEd_StepRangeAnim                     ; $4A24

jr_003_4a27:
    call AnimEd_DrawEntryCursor                   ; $4A27
    call Oam_HideUnused                           ; $4A2A
    rst Rst08_WaitVBlank                          ; $4A2D
    ld a, [wRangeAnimDone + $1]                   ; $4A2E
    and a                                         ; $4A31
    jr z, jr_003_49f3                             ; $4A32

    ret                                           ; $4A34


; C: number of loops 1..50 for the range
Mode12_State0C_LoopCount::
    call AnimEd_DrawLoopCountSprite               ; $4A35
    ldh a, [hKeysNewRepeat]                       ; $4A38
    ld b, a                                       ; $4A3A
    ld a, [wSpriteAnimTick + $9]                  ; $4A3B
    bit 7, b                                      ; $4A3E
    jr z, jr_003_4a50                             ; $4A40

    push af                                       ; $4A42
    ld a, SFX1_STEP_FAST                          ; $4A43
    call Snd_Sfx1                                 ; $4A45
    pop af                                        ; $4A48
    cp $02                                        ; $4A49
    jr nz, jr_003_4a4f                            ; $4A4B

    ld a, $33                                     ; $4A4D

jr_003_4a4f:
    dec a                                         ; $4A4F

jr_003_4a50:
    bit 6, b                                      ; $4A50
    jr z, jr_003_4a62                             ; $4A52

    push af                                       ; $4A54
    ld a, SFX1_STEP_FAST                          ; $4A55
    call Snd_Sfx1                                 ; $4A57
    pop af                                        ; $4A5A
    cp $32                                        ; $4A5B
    jr nz, jr_003_4a61                            ; $4A5D

    ld a, $01                                     ; $4A5F

jr_003_4a61:
    inc a                                         ; $4A61

jr_003_4a62:
    ld [wSpriteAnimTick + $9], a                  ; $4A62
    ldh a, [hKeysHeld]                            ; $4A65
    and PADF_UP | PADF_DOWN                       ; $4A67
    jr z, jr_003_4a6f                             ; $4A69

    xor a                                         ; $4A6B
    ld [wBlinkCounter], a                         ; $4A6C

jr_003_4a6f:
    ldh a, [hKeysNew]                             ; $4A6F
    bit PADB_A, a                                 ; $4A71
    jr z, jr_003_4a82                             ; $4A73

    push af                                       ; $4A75
    ld a, SFX1_OPTION_CHANGE                      ; $4A76
    call Snd_Sfx1                                 ; $4A78
    pop af                                        ; $4A7B
    ld a, STATE_12_LOOP_APPLY                     ; $4A7C
    ld [wState], a                                ; $4A7E
    ret                                           ; $4A81


jr_003_4a82:
    bit 1, a                                      ; $4A82
    ret z                                         ; $4A84

    ld a, [wRangeDirection]                       ; $4A85
    and a                                         ; $4A88
    jr nz, jr_003_4a95                            ; $4A89

    ld a, [wRangeAnchor]                          ; $4A8B
    ld b, a                                       ; $4A8E
    ld a, [wRangeMovingEnd]                       ; $4A8F
    ld c, a                                       ; $4A92
    jr jr_003_4a9d                                ; $4A93

jr_003_4a95:
    ld a, [wRangeAnchor]                          ; $4A95
    ld c, a                                       ; $4A98
    ld a, [wRangeMovingEnd]                       ; $4A99
    ld b, a                                       ; $4A9C

jr_003_4a9d:
    ld e, $a7                                     ; $4A9D
    ld a, b                                       ; $4A9F
    call AnimEd_PutGridTile                       ; $4AA0
    inc e                                         ; $4AA3

jr_003_4aa4:
    inc b                                         ; $4AA4
    ld a, b                                       ; $4AA5
    cp c                                          ; $4AA6
    jr z, jr_003_4aae                             ; $4AA7

    call AnimEd_PutGridTile                       ; $4AA9
    jr jr_003_4aa4                                ; $4AAC

jr_003_4aae:
    inc e                                         ; $4AAE
    call AnimEd_PutGridTile                       ; $4AAF
    xor a                                         ; $4AB2
    ld [wSpriteAnimFrame + $8], a                 ; $4AB3
    ld [wSpriteAnimTick + $8], a                  ; $4AB6
    ld a, [wRangeMovingEnd]                       ; $4AB9
    inc a                                         ; $4ABC
    push af                                       ; $4ABD
    and $0f                                       ; $4ABE
    sla a                                         ; $4AC0
    sla a                                         ; $4AC2
    sla a                                         ; $4AC4
    add $10                                       ; $4AC6
    ld [wRangeCursorXy + $1], a                   ; $4AC8
    pop af                                        ; $4ACB
    and $f0                                       ; $4ACC
    add $5e                                       ; $4ACE
    ld [wRangeCursorXy + $3], a                   ; $4AD0
    ld e, $a8                                     ; $4AD3
    ld a, [wRangeMovingEnd]                       ; $4AD5
    call AnimEd_PutGridTile                       ; $4AD8
    ld a, STATE_12_RANGE_SELECT                   ; $4ADB
    ld [wState], a                                ; $4ADD
    ret                                           ; $4AE0


; C: blinking digits of the loop count. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawLoopCountSprite::
    ld hl, wBlinkCounter                          ; $4AE1
    inc [hl]                                      ; $4AE4
    bit 3, [hl]                                   ; $4AE5
    ret nz                                        ; $4AE7

    ld a, [wSpriteAnimTick + $9]                  ; $4AE8
    ld b, $00                                     ; $4AEB

jr_003_4aed:
    cp $0a                                        ; $4AED
    jr c, jr_003_4af6                             ; $4AEF

    sub $0a                                       ; $4AF1
    inc b                                         ; $4AF3
    jr jr_003_4aed                                ; $4AF4

jr_003_4af6:
    push af                                       ; $4AF6
    push bc                                       ; $4AF7
    ld a, b                                       ; $4AF8
    ld bc, $1088                                  ; $4AF9
    and a                                         ; $4AFC
    jr z, jr_003_4b02                             ; $4AFD

    ld bc, $0c80                                  ; $4AFF

jr_003_4b02:
    ld a, [wRangeAnchor]                          ; $4B02
    ld hl, wRangeMovingEnd                        ; $4B05
    add [hl]                                      ; $4B08
    inc a                                         ; $4B09
    inc a                                         ; $4B0A
    push af                                       ; $4B0B
    and $1f                                       ; $4B0C
    sla a                                         ; $4B0E
    sla a                                         ; $4B10
    add b                                         ; $4B12
    cp $10                                        ; $4B13
    jr nc, jr_003_4b1b                            ; $4B15

    ld a, $10                                     ; $4B17
    jr jr_003_4b1f                                ; $4B19

jr_003_4b1b:
    cp c                                          ; $4B1B
    jr c, jr_003_4b1f                             ; $4B1C

    ld a, c                                       ; $4B1E

jr_003_4b1f:
    ld b, a                                       ; $4B1F
    pop af                                        ; $4B20
    and $e0                                       ; $4B21
    srl a                                         ; $4B23
    add $64                                       ; $4B25
    ld c, a                                       ; $4B27
    pop af                                        ; $4B28
    and a                                         ; $4B29
    jr z, jr_003_4b37                             ; $4B2A

    add $7e                                       ; $4B2C
    push bc                                       ; $4B2E
    call Oam_AddMeta_B01_4000                     ; $4B2F
    pop bc                                        ; $4B32
    ld a, b                                       ; $4B33
    add $08                                       ; $4B34
    ld b, a                                       ; $4B36

jr_003_4b37:
    pop af                                        ; $4B37
    add $7e                                       ; $4B38
    call Oam_AddMeta_B01_4000                     ; $4B3A
    ret                                           ; $4B3D


; C: writes the loop markers into the timing list
Mode12_State0D_LoopApply::
    ld a, [wRangeDirection]                       ; $4B3E
    and a                                         ; $4B41
    jr nz, jr_003_4b4e                            ; $4B42

    ld a, [wRangeAnchor]                          ; $4B44
    ld b, a                                       ; $4B47
    ld a, [wRangeMovingEnd]                       ; $4B48
    ld c, a                                       ; $4B4B
    jr jr_003_4b56                                ; $4B4C

jr_003_4b4e:
    ld a, [wRangeAnchor]                          ; $4B4E
    ld c, a                                       ; $4B51
    ld a, [wRangeMovingEnd]                       ; $4B52
    ld b, a                                       ; $4B55

jr_003_4b56:
    ld de, $05a4                                  ; $4B56

jr_003_4b59:
    push bc                                       ; $4B59
    push de                                       ; $4B5A
    ld a, b                                       ; $4B5B
    call AnimEd_PutGridTile                       ; $4B5C
    inc e                                         ; $4B5F

jr_003_4b60:
    inc b                                         ; $4B60
    ld a, b                                       ; $4B61
    cp c                                          ; $4B62
    jr z, jr_003_4b6a                             ; $4B63

    call AnimEd_PutGridTile                       ; $4B65
    jr jr_003_4b60                                ; $4B68

jr_003_4b6a:
    inc e                                         ; $4B6A
    call AnimEd_PutGridTile                       ; $4B6B
    ld bc, $0004                                  ; $4B6E
    call Wait_Frames                              ; $4B71
    pop de                                        ; $4B74
    pop bc                                        ; $4B75
    ld a, e                                       ; $4B76
    xor $03                                       ; $4B77
    ld e, a                                       ; $4B79
    dec d                                         ; $4B7A
    jr nz, jr_003_4b59                            ; $4B7B

    push bc                                       ; $4B7D
    ld a, [wRangeAnchor]                          ; $4B7E
    ld c, a                                       ; $4B81
    ld b, $00                                     ; $4B82
    ld hl, wAnimTiming                            ; $4B84
    add hl, bc                                    ; $4B87
    ld a, [hl]                                    ; $4B88
    and a                                         ; $4B89
    jr z, jr_003_4b93                             ; $4B8A

    xor a                                         ; $4B8C

jr_003_4b8d:
    ld [hl+], a                                   ; $4B8D
    bit 6, [hl]                                   ; $4B8E
    jr z, jr_003_4b8d                             ; $4B90

    ld [hl], a                                    ; $4B92

jr_003_4b93:
    pop bc                                        ; $4B93
    ld a, [wSpriteAnimTick + $9]                  ; $4B94
    set 7, a                                      ; $4B97
    ld e, a                                       ; $4B99
    ld a, b                                       ; $4B9A
    call AnimEd_SetTiming                         ; $4B9B
    res 7, e                                      ; $4B9E

jr_003_4ba0:
    inc b                                         ; $4BA0
    ld a, b                                       ; $4BA1
    cp c                                          ; $4BA2
    jr z, jr_003_4baa                             ; $4BA3

    call AnimEd_SetTiming                         ; $4BA5
    jr jr_003_4ba0                                ; $4BA8

jr_003_4baa:
    set 6, e                                      ; $4BAA
    call AnimEd_SetTiming                         ; $4BAC
    ld a, STATE_12_RANGE_BROWSE                   ; $4BAF
    ld [wState], a                                ; $4BB1
    ld hl, wDirtyFlag                             ; $4BB4
    set 0, [hl]                                   ; $4BB7
    ret                                           ; $4BB9


; C: A = entry
AnimEd_SetTiming::
    push bc                                       ; $4BBA
    ld c, a                                       ; $4BBB
    ld b, $00                                     ; $4BBC
    ld hl, wAnimTiming                            ; $4BBE
    add hl, bc                                    ; $4BC1
    ld [hl], e                                    ; $4BC2
    pop bc                                        ; $4BC3
    ret                                           ; $4BC4


; C: removes the loop markers of the range
Mode12_State0E_LoopClear::
    ld a, [wRangeAnchor]                          ; $4BC5
    ld c, a                                       ; $4BC8
    ld b, $00                                     ; $4BC9
    ld hl, wAnimTiming                            ; $4BCB
    add hl, bc                                    ; $4BCE
    ld a, [hl]                                    ; $4BCF
    and a                                         ; $4BD0
    jr z, jr_003_4bda                             ; $4BD1

    xor a                                         ; $4BD3

jr_003_4bd4:
    ld [hl+], a                                   ; $4BD4
    bit 6, [hl]                                   ; $4BD5
    jr z, jr_003_4bd4                             ; $4BD7

    ld [hl], a                                    ; $4BD9

jr_003_4bda:
    ld a, STATE_12_RANGE_BROWSE                   ; $4BDA
    ld [wState], a                                ; $4BDC
    ld hl, wDirtyFlag                             ; $4BDF
    set 0, [hl]                                   ; $4BE2
    ret                                           ; $4BE4


; C: clears the whole list after the CLEAR dialog
Mode12_State0F_ClearAll::
    call AnimEd_ClearAll                          ; $4BE5
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $4BE8
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $4BEA
    ld de, $9800                                  ; $4BED
    ld bc, $0400                                  ; $4BF0
    call Vram_CopyFromBank                        ; $4BF3
    call AnimEd_InitEditor                        ; $4BF6
    call AnimEd_DrawFrameSprites                  ; $4BF9
    ld a, BANK(Gfx_0C_5500_Mode12_State0F_ClearAll); $4BFC
    ld hl, Gfx_0C_5500_Mode12_State0F_ClearAll    ; $4BFE
    ld de, $9500                                  ; $4C01
    ld bc, $0060                                  ; $4C04
    call Vram_CopyFromBank                        ; $4C07
    ld a, BANK(Gfx_0C_5100_Mode12_State0F_ClearAll); $4C0A
    ld hl, Gfx_0C_5100_Mode12_State0F_ClearAll    ; $4C0C
    ld de, $9100                                  ; $4C0F
    ld bc, $0380                                  ; $4C12
    call Vram_CopyFromBank                        ; $4C15
    ld a, BANK(Gfx_0C_48C0_Mode12_State0F_ClearAll); $4C18
    ld hl, Gfx_0C_48C0_Mode12_State0F_ClearAll    ; $4C1A
    ld de, $88c0                                  ; $4C1D
    ld bc, $00c0                                  ; $4C20
    call Vram_CopyFromBank                        ; $4C23
    call AnimEd_StartDecorations                  ; $4C26
    call AnimEd_DrawTimingMarkers                 ; $4C29
    call AnimEd_LoadEntryThumb                    ; $4C2C
    call AnimEd_ShowBorderDigits                  ; $4C2F
    call AnimEd_ShowEntryValue                    ; $4C32
    call AnimEd_ShowEntryIndex                    ; $4C35
    call AnimEd_ShowSpeed                         ; $4C38
    call AnimEd_ShowLoopFlag                      ; $4C3B
    ld a, STATE_12_BROWSE                         ; $4C3E
    ld [wState], a                                ; $4C40
    ret                                           ; $4C43


; C: PACK: reloads the screen and removes the blank entries
Mode12_State10_Pack::
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $4C44
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $4C46
    ld de, $9800                                  ; $4C49
    ld bc, $0400                                  ; $4C4C
    call Vram_CopyFromBank                        ; $4C4F
    call AnimEd_DrawFrameSprites                  ; $4C52
    ld a, BANK(Gfx_0C_5500_Mode12_State0F_ClearAll); $4C55
    ld hl, Gfx_0C_5500_Mode12_State0F_ClearAll    ; $4C57
    ld de, $9500                                  ; $4C5A
    ld bc, $0060                                  ; $4C5D
    call Vram_CopyFromBank                        ; $4C60
    ld a, BANK(Gfx_0C_5100_Mode12_State0F_ClearAll); $4C63
    ld hl, Gfx_0C_5100_Mode12_State0F_ClearAll    ; $4C65
    ld de, $9100                                  ; $4C68
    ld bc, $0380                                  ; $4C6B
    call Vram_CopyFromBank                        ; $4C6E
    ld a, BANK(Gfx_0C_48C0_Mode12_State0F_ClearAll); $4C71
    ld hl, Gfx_0C_48C0_Mode12_State0F_ClearAll    ; $4C73
    ld de, $88c0                                  ; $4C76
    ld bc, $00c0                                  ; $4C79
    call Vram_CopyFromBank                        ; $4C7C
    ld hl, wAnimList                              ; $4C7F
    ld b, $2f                                     ; $4C82

jr_003_4c84:
    ld a, [hl]                                    ; $4C84
    cp $fe                                        ; $4C85
    jr nz, jr_003_4c8b                            ; $4C87

    inc a                                         ; $4C89
    ld [hl], a                                    ; $4C8A

jr_003_4c8b:
    inc hl                                        ; $4C8B
    dec b                                         ; $4C8C
    jr nz, jr_003_4c84                            ; $4C8D

    ld hl, wAnimTiming                            ; $4C8F
    ld de, wAnimList                              ; $4C92
    ld b, $2f                                     ; $4C95

jr_003_4c97:
    ld a, [hl]                                    ; $4C97
    and $c0                                       ; $4C98
    jr z, jr_003_4ca5                             ; $4C9A

    ld a, [de]                                    ; $4C9C
    cp $ff                                        ; $4C9D
    jr nz, jr_003_4cb6                            ; $4C9F

    dec a                                         ; $4CA1
    ld [de], a                                    ; $4CA2
    jr jr_003_4cb6                                ; $4CA3

jr_003_4ca5:
    ld a, [de]                                    ; $4CA5
    cp $ff                                        ; $4CA6
    jr z, jr_003_4cb4                             ; $4CA8

    ld a, [hl]                                    ; $4CAA
    and $3f                                       ; $4CAB
    jr nz, jr_003_4cb6                            ; $4CAD

    ld a, $ff                                     ; $4CAF
    ld [hl], a                                    ; $4CB1
    jr jr_003_4cb6                                ; $4CB2

jr_003_4cb4:
    xor a                                         ; $4CB4
    ld [hl], a                                    ; $4CB5

jr_003_4cb6:
    inc hl                                        ; $4CB6
    inc de                                        ; $4CB7
    dec b                                         ; $4CB8
    jr nz, jr_003_4c97                            ; $4CB9

    ld hl, wAnimList                              ; $4CBB
    ld de, wAnimList                              ; $4CBE
    ld b, $2f                                     ; $4CC1

jr_003_4cc3:
    ld c, [hl]                                    ; $4CC3
    ld a, $fe                                     ; $4CC4
    ld [hl+], a                                   ; $4CC6
    ld a, c                                       ; $4CC7
    cp $ff                                        ; $4CC8
    jr z, jr_003_4cce                             ; $4CCA

    ld [de], a                                    ; $4CCC
    inc de                                        ; $4CCD

jr_003_4cce:
    dec b                                         ; $4CCE
    jr nz, jr_003_4cc3                            ; $4CCF

    ld hl, wAnimTiming                            ; $4CD1
    ld de, wAnimTiming                            ; $4CD4
    ld b, $2f                                     ; $4CD7

jr_003_4cd9:
    ld c, [hl]                                    ; $4CD9
    xor a                                         ; $4CDA
    ld [hl+], a                                   ; $4CDB
    ld a, c                                       ; $4CDC
    cp $ff                                        ; $4CDD
    jr nz, jr_003_4ce6                            ; $4CDF

    xor a                                         ; $4CE1
    ld [de], a                                    ; $4CE2
    inc de                                        ; $4CE3
    jr jr_003_4ceb                                ; $4CE4

jr_003_4ce6:
    and a                                         ; $4CE6
    jr z, jr_003_4ceb                             ; $4CE7

    ld [de], a                                    ; $4CE9
    inc de                                        ; $4CEA

jr_003_4ceb:
    dec b                                         ; $4CEB
    jr nz, jr_003_4cd9                            ; $4CEC

    ld a, [wCurEntryIndex]                        ; $4CEE
    ld c, a                                       ; $4CF1
    ld b, $00                                     ; $4CF2
    ld hl, wAnimList                              ; $4CF4
    add hl, bc                                    ; $4CF7
    ld a, [hl]                                    ; $4CF8
    ld [wCurEntryValue], a                        ; $4CF9
    call AnimEd_StartDecorations                  ; $4CFC
    call AnimEd_DrawTimingMarkers                 ; $4CFF
    call AnimEd_LoadEntryThumb                    ; $4D02
    call AnimEd_ShowBorderDigits                  ; $4D05
    call AnimEd_ShowEntryValue                    ; $4D08
    call AnimEd_ShowEntryIndex                    ; $4D0B
    call AnimEd_ShowSpeed                         ; $4D0E
    call AnimEd_ShowLoopFlag                      ; $4D11
    ld a, STATE_12_BROWSE                         ; $4D14
    ld [wState], a                                ; $4D16
    ret                                           ; $4D19


; C: TEST: prepares the play variables and fades to the player screen
Mode12_State11_TestStart::
    xor a                                         ; $4D1A
    ld [wPlayTick], a                             ; $4D1B
    ld [wPlayLoopCount], a                        ; $4D1E
    ld [wPlayDone], a                             ; $4D21
    ld hl, wAnimList                              ; $4D24
    ld b, $2f                                     ; $4D27

jr_003_4d29:
    ld a, [hl+]                                   ; $4D29
    cp $fe                                        ; $4D2A
    jr c, jr_003_4d37                             ; $4D2C

    dec b                                         ; $4D2E
    jr nz, jr_003_4d29                            ; $4D2F

    ld a, STATE_12_BROWSE                         ; $4D31
    ld [wState], a                                ; $4D33
    ret                                           ; $4D36


jr_003_4d37:
    ld [wPlayEntry], a                            ; $4D37
    ld a, $2f                                     ; $4D3A
    sub b                                         ; $4D3C
    ld [wSpriteAnimTick + $a], a                  ; $4D3D
    ld c, a                                       ; $4D40
    ld b, $00                                     ; $4D41
    ld hl, wAnimTiming                            ; $4D43
    add hl, bc                                    ; $4D46
    bit 7, [hl]                                   ; $4D47
    jr z, jr_003_4d56                             ; $4D49

    ld [wPlayLoopStart], a                        ; $4D4B
    ld a, $01                                     ; $4D4E
    ld [wPlayLoopCount], a                        ; $4D50
    xor a                                         ; $4D53
    jr jr_003_4d58                                ; $4D54

jr_003_4d56:
    ld a, $01                                     ; $4D56

jr_003_4d58:
    ld [wPlayFlags], a                            ; $4D58
    call AnimEd_StartExitTransition               ; $4D5B
    call Pal_FadeOut                              ; $4D5E
    call Lcd_Off                                  ; $4D61
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4D64
    ldh [hLcdcShadow], a                          ; $4D66
    ld a, $e4                                     ; $4D68
    ld [wPaletteTarget], a                        ; $4D6A
    ld [wPaletteTarget + $1], a                   ; $4D6D
    ld [wPaletteTarget + $2], a                   ; $4D70
    ld a, $10                                     ; $4D73
    ldh [hScxShadow], a                           ; $4D75
    ldh [hScyShadow], a                           ; $4D77
    ld a, BANK(Map_24_7C20_Mode12_State11_TestStart); $4D79
    ld hl, Map_24_7C20_Mode12_State11_TestStart   ; $4D7B
    ld de, $9800                                  ; $4D7E
    ld bc, $0400                                  ; $4D81
    call Mem_CopyFromBank                         ; $4D84
    ld hl, $8000                                  ; $4D87
    ld bc, $0500                                  ; $4D8A
    call Mem_Zero                                 ; $4D8D
    ld hl, $8800                                  ; $4D90
    ld bc, $0100                                  ; $4D93
    call Mem_Zero                                 ; $4D96
    ld hl, $9000                                  ; $4D99
    ld bc, $0800                                  ; $4D9C
    call Mem_Zero                                 ; $4D9F
    ld a, [wAnimBorder]                           ; $4DA2
    ld [wBorderNumber], a                         ; $4DA5
    ldh [hFarcallAArg], a                         ; $4DA8
    ld a, BANK(Border_LoadMap_LcdOff)             ; $4DAA
    ld hl, Border_LoadMap_LcdOff                  ; $4DAC
    call Far_Call                                 ; $4DAF
    ld a, $54                                     ; $4DB2
    ldh [hLycShadowSplit1], a                     ; $4DB4
    ldh [hSplit1Latch], a                         ; $4DB6
    ld hl, hStatShadow                            ; $4DB8
    set 6, [hl]                                   ; $4DBB
    ld hl, rIE                                    ; $4DBD
    set 1, [hl]                                   ; $4DC0
    ld a, $01                                     ; $4DC2
    ldh [hStatHandlerIndex], a                    ; $4DC4
    call Oam_ClearShadow                          ; $4DC6
    call Pal_AllWhite                             ; $4DC9
    call Lcd_On                                   ; $4DCC
    call Pal_FadeIn                               ; $4DCF
    call AnimEd_LoadEntryPhoto                    ; $4DD2
    ld hl, wState                                 ; $4DD5
    inc [hl]                                      ; $4DD8
    ret                                           ; $4DD9


; C: TEST: steps the entries at the animation speed
Mode12_State12_TestRun::
    ld a, [wPlayDone]                             ; $4DDA
    and a                                         ; $4DDD
    jr nz, jr_003_4e5e                            ; $4DDE

    ld hl, wPlayTick                              ; $4DE0
    ld a, [wAnimSpeed]                            ; $4DE3
    sub [hl]                                      ; $4DE6
    jr nz, jr_003_4e5a                            ; $4DE7

    ld [hl], a                                    ; $4DE9
    ld b, $2f                                     ; $4DEA

jr_003_4dec:
    ld a, [wSpriteAnimTick + $a]                  ; $4DEC
    ld c, a                                       ; $4DEF
    ld b, $00                                     ; $4DF0
    ld hl, wAnimTiming                            ; $4DF2
    add hl, bc                                    ; $4DF5
    bit 6, [hl]                                   ; $4DF6
    jr z, jr_003_4e11                             ; $4DF8

    ld a, [hl]                                    ; $4DFA
    and $3f                                       ; $4DFB
    ld hl, wPlayLoopCount                         ; $4DFD
    cp [hl]                                       ; $4E00
    jr z, jr_003_4e09                             ; $4E01

    inc [hl]                                      ; $4E03
    ld a, [wPlayLoopStart]                        ; $4E04
    jr jr_003_4e12                                ; $4E07

jr_003_4e09:
    ld hl, wPlayFlags                             ; $4E09
    set 0, [hl]                                   ; $4E0C
    ld a, [wSpriteAnimTick + $a]                  ; $4E0E

jr_003_4e11:
    inc a                                         ; $4E11

jr_003_4e12:
    cp $2f                                        ; $4E12
    jr nz, jr_003_4e22                            ; $4E14

    ld a, [wAnimLoopFlag]                         ; $4E16
    and a                                         ; $4E19
    jr nz, jr_003_4e21                            ; $4E1A

    ld hl, wPlayDone                              ; $4E1C
    inc [hl]                                      ; $4E1F
    ret                                           ; $4E20


jr_003_4e21:
    xor a                                         ; $4E21

jr_003_4e22:
    ld [wSpriteAnimTick + $a], a                  ; $4E22
    ld c, a                                       ; $4E25
    ld b, $00                                     ; $4E26
    ld hl, wAnimTiming                            ; $4E28
    add hl, bc                                    ; $4E2B
    bit 7, [hl]                                   ; $4E2C
    jr z, jr_003_4e41                             ; $4E2E

    ld hl, wPlayFlags                             ; $4E30
    bit 0, [hl]                                   ; $4E33
    jr z, jr_003_4e41                             ; $4E35

    res 0, [hl]                                   ; $4E37
    ld [wPlayLoopStart], a                        ; $4E39
    ld a, $01                                     ; $4E3C
    ld [wPlayLoopCount], a                        ; $4E3E

jr_003_4e41:
    ld hl, wAnimList                              ; $4E41
    add hl, bc                                    ; $4E44
    ld a, [hl]                                    ; $4E45
    ld [wPlayEntry], a                            ; $4E46
    cp $fe                                        ; $4E49
    jr c, jr_003_4e55                             ; $4E4B

    dec b                                         ; $4E4D
    jr nz, jr_003_4dec                            ; $4E4E

    ld hl, wPlayDone                              ; $4E50
    inc [hl]                                      ; $4E53
    ret                                           ; $4E54


jr_003_4e55:
    call AnimEd_LoadEntryPhoto                    ; $4E55
    jr jr_003_4e5e                                ; $4E58

jr_003_4e5a:
    ld hl, wPlayTick                              ; $4E5A
    inc [hl]                                      ; $4E5D

jr_003_4e5e:
    ldh a, [hKeysNewSticky]                       ; $4E5E
    bit PADB_B, a                                 ; $4E60
    ret z                                         ; $4E62

    ld hl, wState                                 ; $4E63
    inc [hl]                                      ; $4E66
    ret                                           ; $4E67


; C: TEST: returns to the editor screen
Mode12_State13_TestEnd::
    call Pal_FadeOut                              ; $4E68
    call Lcd_Off                                  ; $4E6B
    ld hl, hStatShadow                            ; $4E6E
    res 6, [hl]                                   ; $4E71
    ld hl, rIE                                    ; $4E73
    res 1, [hl]                                   ; $4E76
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $4E78
    ldh [hLcdcShadow], a                          ; $4E7A
    ld a, $e4                                     ; $4E7C
    ld [wPaletteTarget], a                        ; $4E7E
    ld [wPaletteTarget + $1], a                   ; $4E81
    ld a, $d2                                     ; $4E84
    ld [wPaletteTarget + $2], a                   ; $4E86
    xor a                                         ; $4E89
    ldh [hScxShadow], a                           ; $4E8A
    ld a, $10                                     ; $4E8C
    ldh [hScyShadow], a                           ; $4E8E
    ld a, $95                                     ; $4E90
    ldh [hWyShadow], a                            ; $4E92
    ld a, $07                                     ; $4E94
    ldh [hWxShadow], a                            ; $4E96
    ld a, $0c                                     ; $4E98
    ld hl, Gfx_0C_4000_Mode12_State00_Init        ; $4E9A
    ld de, $8000                                  ; $4E9D
    ld bc, $1800                                  ; $4EA0
    call Mem_CopyFromBank                         ; $4EA3
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $4EA6
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $4EA8
    ld de, $9800                                  ; $4EAB
    ld bc, $0400                                  ; $4EAE
    call Mem_CopyFromBank                         ; $4EB1
    call Oam_ClearShadow                          ; $4EB4
    call Pal_AllWhite                             ; $4EB7
    call Lcd_On                                   ; $4EBA
    call AnimEd_InitEditor                        ; $4EBD
    call AnimEd_LoadEntryThumb                    ; $4EC0
    call AnimEd_ShowBorderDigits                  ; $4EC3
    call AnimEd_ShowEntryValue                    ; $4EC6
    call AnimEd_ShowEntryIndex                    ; $4EC9
    call AnimEd_ShowSpeed                         ; $4ECC
    call Pal_FadeIn                               ; $4ECF
    call AnimEd_StartDecorations                  ; $4ED2
    call AnimEd_DrawTimingMarkers                 ; $4ED5
    ld a, STATE_12_BROWSE                         ; $4ED8
    ld [wState], a                                ; $4EDA
    ret                                           ; $4EDD


; C: SAVE? dialog slides in
Mode12_State14_SaveDialogOpen::
    call Oam_ClearShadow                          ; $4EDE
    ld a, BANK(Gfx_0C_6180_Mode12_State14_SaveDialogOpen); $4EE1
    ld hl, Gfx_0C_6180_Mode12_State14_SaveDialogOpen; $4EE3
    ld de, $8c00                                  ; $4EE6
    ld bc, $03e0                                  ; $4EE9
    call Vram_CopyFromBank                        ; $4EEC
    ld a, BANK(Map_27_7510_Mode12_State14_SaveDialogOpen); $4EEF
    ld hl, Map_27_7510_Mode12_State14_SaveDialogOpen; $4EF1
    ld de, $9c00                                  ; $4EF4
    ld bc, $0120                                  ; $4EF7
    call Vram_CopyFromBank                        ; $4EFA
    xor a                                         ; $4EFD
    ld [wSpriteAnimFrame + $b], a                 ; $4EFE
    ld [wSpriteAnimTick + $b], a                  ; $4F01
    ld de, $4f0e                                  ; $4F04
    call AnimEd_WindowSlideOut                    ; $4F07
    ld hl, wState                                 ; $4F0A
    inc [hl]                                      ; $4F0D
    ret                                           ; $4F0E


; C: waits for A or B
Mode12_State15_SaveDialogWait::
    ldh a, [hKeysNew]                             ; $4F0F
    and PADF_A | PADF_B                           ; $4F11
    ret z                                         ; $4F13

    ld [wAbResult], a                             ; $4F14
    ld hl, wState                                 ; $4F17
    inc [hl]                                      ; $4F1A
    ret                                           ; $4F1B


; C: A: far call 02:4A07 stores the animation list
Mode12_State16_SaveDialogClose::
    ld de, $4f53                                  ; $4F1C
    call AnimEd_WindowSlideIn                     ; $4F1F
    ld a, BANK(Gfx_0C_4C60_Mode12_State16_SaveDialogClose); $4F22
    ld hl, Gfx_0C_4C60_Mode12_State16_SaveDialogClose; $4F24
    ld de, $8c60                                  ; $4F27
    ld bc, $0370                                  ; $4F2A
    call Vram_CopyFromBank                        ; $4F2D
    ld a, BANK(Gfx_0C_4600_Mode12_State16_SaveDialogClose); $4F30
    ld hl, Gfx_0C_4600_Mode12_State16_SaveDialogClose; $4F32
    ld de, $8600                                  ; $4F35
    ld bc, $01f0                                  ; $4F38
    call Vram_CopyFromBank                        ; $4F3B
    ld a, [wAbResult]                             ; $4F3E
    bit 0, a                                      ; $4F41
    jr z, jr_003_4f4f                             ; $4F43

    ldh [hFarcallAArg], a                         ; $4F45
    ld a, BANK(Settings_StoreAnimTranslated_Far)  ; $4F47
    ld hl, Settings_StoreAnimTranslated_Far       ; $4F49
    call Far_Call                                 ; $4F4C

jr_003_4f4f:
    ld hl, wState                                 ; $4F4F
    inc [hl]                                      ; $4F52
    ret                                           ; $4F53


; C: exit dialog slides in
Mode12_State17_ExitDialogOpen::
    call Oam_ClearShadow                          ; $4F54
    ld a, BANK(Gfx_0C_6730_Mode12_State17_ExitDialogOpen); $4F57
    ld hl, Gfx_0C_6730_Mode12_State17_ExitDialogOpen; $4F59
    ld de, $8c00                                  ; $4F5C
    ld bc, $0380                                  ; $4F5F
    call Vram_CopyFromBank                        ; $4F62
    ld a, BANK(Map_27_6E50_Mode12_State17_ExitDialogOpen); $4F65
    ld hl, Map_27_6E50_Mode12_State17_ExitDialogOpen; $4F67
    ld de, $9c00                                  ; $4F6A
    ld bc, $0120                                  ; $4F6D
    call Vram_CopyFromBank                        ; $4F70
    xor a                                         ; $4F73
    ld [wSpriteAnimFrame + $b], a                 ; $4F74
    ld [wSpriteAnimTick + $b], a                  ; $4F77
    ld de, $4f84                                  ; $4F7A
    call AnimEd_WindowSlideOut                    ; $4F7D
    ld hl, wState                                 ; $4F80
    inc [hl]                                      ; $4F83
    ret                                           ; $4F84


; C: waits for A or B
Mode12_State18_ExitDialogWait::
    ldh a, [hKeysNew]                             ; $4F85
    and PADF_A | PADF_B                           ; $4F87
    ret z                                         ; $4F89

    ld [wAbResult], a                             ; $4F8A
    ld hl, wState                                 ; $4F8D
    inc [hl]                                      ; $4F90
    ret                                           ; $4F91


; C: A: leaves the editor (state 05); B: back to browsing
Mode12_State19_ExitDialogClose::
    ld de, $4fc6                                  ; $4F92
    call AnimEd_WindowSlideIn                     ; $4F95
    ld a, BANK(Gfx_0C_4C60_Mode12_State16_SaveDialogClose); $4F98
    ld hl, Gfx_0C_4C60_Mode12_State16_SaveDialogClose; $4F9A
    ld de, $8c60                                  ; $4F9D
    ld bc, $0370                                  ; $4FA0
    call Vram_CopyFromBank                        ; $4FA3
    ld a, BANK(Gfx_0C_4600_Mode12_State16_SaveDialogClose); $4FA6
    ld hl, Gfx_0C_4600_Mode12_State16_SaveDialogClose; $4FA8
    ld de, $8600                                  ; $4FAB
    ld bc, $01f0                                  ; $4FAE
    call Vram_CopyFromBank                        ; $4FB1
    ld a, [wAbResult]                             ; $4FB4
    bit 0, a                                      ; $4FB7
    jr z, jr_003_4fc1                             ; $4FB9

    ld a, STATE_12_EXIT                           ; $4FBB
    ld [wState], a                                ; $4FBD
    ret                                           ; $4FC0


jr_003_4fc1:
    ld a, STATE_12_BROWSE                         ; $4FC1
    ld [wState], a                                ; $4FC3
    ret                                           ; $4FC6


; C: CLEAR dialog slides in
Mode12_State1A_ClearDialogOpen::
    call Oam_ClearShadow                          ; $4FC7
    ld a, BANK(Gfx_0C_6560_Mode12_State1A_ClearDialogOpen); $4FCA
    ld hl, Gfx_0C_6560_Mode12_State1A_ClearDialogOpen; $4FCC
    ld de, $8c00                                  ; $4FCF
    ld bc, $0370                                  ; $4FD2
    call Vram_CopyFromBank                        ; $4FD5
    ld a, BANK(Map_27_7870_Mode12_State1A_ClearDialogOpen); $4FD8
    ld hl, Map_27_7870_Mode12_State1A_ClearDialogOpen; $4FDA
    ld de, $9c00                                  ; $4FDD
    ld bc, $0120                                  ; $4FE0
    call Vram_CopyFromBank                        ; $4FE3
    xor a                                         ; $4FE6
    ld [wSpriteAnimFrame + $c], a                 ; $4FE7
    ld [wSpriteAnimTick + $c], a                  ; $4FEA
    ld de, $4ff7                                  ; $4FED
    call AnimEd_WindowSlideOut                    ; $4FF0
    ld hl, wState                                 ; $4FF3
    inc [hl]                                      ; $4FF6
    ret                                           ; $4FF7


; C: waits for A or B
Mode12_State1B_ClearDialogWait::
    ldh a, [hKeysNew]                             ; $4FF8
    and PADF_A | PADF_B                           ; $4FFA
    ret z                                         ; $4FFC

    ld [wAbResult], a                             ; $4FFD
    ld hl, wState                                 ; $5000
    inc [hl]                                      ; $5003
    ret                                           ; $5004


; C: A: state 0F (clear all)
Mode12_State1C_ClearDialogClose::
    ld de, $5039                                  ; $5005
    call AnimEd_WindowSlideIn                     ; $5008
    ld a, BANK(Gfx_0C_4C60_Mode12_State16_SaveDialogClose); $500B
    ld hl, Gfx_0C_4C60_Mode12_State16_SaveDialogClose; $500D
    ld de, $8c60                                  ; $5010
    ld bc, $0370                                  ; $5013
    call Vram_CopyFromBank                        ; $5016
    ld a, BANK(Gfx_0C_4600_Mode12_State16_SaveDialogClose); $5019
    ld hl, Gfx_0C_4600_Mode12_State16_SaveDialogClose; $501B
    ld de, $8600                                  ; $501E
    ld bc, $01f0                                  ; $5021
    call Vram_CopyFromBank                        ; $5024
    ld a, [wAbResult]                             ; $5027
    bit 0, a                                      ; $502A
    jr z, jr_003_5034                             ; $502C

    ld a, STATE_12_CLEAR_ALL                      ; $502E
    ld [wState], a                                ; $5030
    ret                                           ; $5033


jr_003_5034:
    ld a, STATE_12_BROWSE                         ; $5034
    ld [wState], a                                ; $5036
    ret                                           ; $5039


; C: SORT dialog (CANCEL / Normal / Shuffle) slides in
Mode12_State1D_SortDialogOpen::
    call Oam_ClearShadow                          ; $503A
    ld a, BANK(Gfx_0C_6C30_Mode12_State1D_SortDialogOpen); $503D
    ld hl, Gfx_0C_6C30_Mode12_State1D_SortDialogOpen; $503F
    ld de, $8c70                                  ; $5042
    ld bc, $0370                                  ; $5045
    call Vram_CopyFromBank                        ; $5048
    ld a, BANK(Gfx_0C_6FA0_Mode12_State1D_SortDialogOpen); $504B
    ld hl, Gfx_0C_6FA0_Mode12_State1D_SortDialogOpen; $504D
    ld de, $8570                                  ; $5050
    ld bc, $0290                                  ; $5053
    call Vram_CopyFromBank                        ; $5056
    ld a, BANK(Map_27_6D30_Mode12_State1D_SortDialogOpen); $5059
    ld hl, Map_27_6D30_Mode12_State1D_SortDialogOpen; $505B
    ld de, $9c00                                  ; $505E
    ld bc, $0120                                  ; $5061
    call Vram_CopyFromBank                        ; $5064
    xor a                                         ; $5067
    ld [wAutofillMode], a                         ; $5068
    ld [wSpriteAnimFrame + $d], a                 ; $506B
    ld [wSpriteAnimTick + $d], a                  ; $506E
    ld de, AnimEd_SortChoiceCursor                ; $5071
    call AnimEd_WindowSlideOut                    ; $5074
    ld hl, wState                                 ; $5077
    inc [hl]                                      ; $507A
    ret                                           ; $507B


; C: Left / Right picks the autofill mode
Mode12_State1E_SortDialogWait::
    call AnimEd_SortChoiceMove                    ; $507C
    call AnimEd_SortChoiceCursor                  ; $507F
    ret c                                         ; $5082

    ldh a, [hKeysNew]                             ; $5083
    and PADF_A | PADF_B                           ; $5085
    ret z                                         ; $5087

    push af                                       ; $5088
    bit 0, a                                      ; $5089
    ld a, SFX1_KEY_A                              ; $508B
    call nz, Snd_Sfx1                             ; $508D
    pop af                                        ; $5090
    ld [wAbResult], a                             ; $5091
    ld hl, wState                                 ; $5094
    inc [hl]                                      ; $5097
    ret                                           ; $5098


; C: Left / Right changes autofill_mode 0..2
AnimEd_SortChoiceMove::
    ldh a, [hKeysNew]                             ; $5099
    ld b, a                                       ; $509B
    ld a, [wAutofillMode]                         ; $509C
    bit 5, b                                      ; $509F
    jr z, jr_003_50a8                             ; $50A1

    and a                                         ; $50A3
    ret z                                         ; $50A4

    dec a                                         ; $50A5
    jr jr_003_50af                                ; $50A6

jr_003_50a8:
    bit 4, b                                      ; $50A8
    ret z                                         ; $50AA

    cp $02                                        ; $50AB
    ret z                                         ; $50AD

    inc a                                         ; $50AE

jr_003_50af:
    ld [wAutofillMode], a                         ; $50AF
    push af                                       ; $50B2
    ld a, SFX1_CONFIRM                            ; $50B3
    call Snd_Sfx1                                 ; $50B5
    pop af                                        ; $50B8
    ret                                           ; $50B9


; C: draws the sort dialog cursor. L3 pass 2026-10-26: executed in BGB in 3 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor::
    ld a, [wAutofillMode]                         ; $50BA
    ld hl, wSpriteAnimFrame + $d                  ; $50BD
    cp [hl]                                       ; $50C0
    jr z, jr_003_50c8                             ; $50C1

    ld [hl], a                                    ; $50C3
    xor a                                         ; $50C4
    ld [wSpriteAnimTick + $d], a                  ; $50C5

jr_003_50c8:
    ld a, [wSpriteAnimTick + $d]                  ; $50C8
    cp $06                                        ; $50CB
    jr z, jr_003_50ea                             ; $50CD

    inc a                                         ; $50CF
    ld [wSpriteAnimTick + $d], a                  ; $50D0
    ldh a, [hWyShadow]                            ; $50D3
    add $2b                                       ; $50D5
    ld c, a                                       ; $50D7
    ld b, $50                                     ; $50D8
    ld a, [wSpriteAnimFrame + $d]                 ; $50DA
    ld e, a                                       ; $50DD
    ld d, $00                                     ; $50DE
    ld hl, AnimEd_SortChoiceCursor_Tbl5101        ; $50E0
    add hl, de                                    ; $50E3
    ld a, [hl]                                    ; $50E4
    call Oam_AddMeta_B01_4000                     ; $50E5
    scf                                           ; $50E8
    ret                                           ; $50E9


jr_003_50ea:
    ldh a, [hWyShadow]                            ; $50EA
    add $2b                                       ; $50EC
    ld c, a                                       ; $50EE
    ld b, $50                                     ; $50EF
    ld a, [wSpriteAnimFrame + $d]                 ; $50F1
    ld e, a                                       ; $50F4
    ld d, $00                                     ; $50F5
    ld hl, AnimEd_SortChoiceCursor_Tbl5104        ; $50F7
    add hl, de                                    ; $50FA
    ld a, [hl]                                    ; $50FB
    call Oam_AddMeta_B01_4000                     ; $50FC
    and a                                         ; $50FF
    ret                                           ; $5100


; C: auto: 3 bytes, bytes; referenced by AnimEd_SortChoiceCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor_Tbl5101::
    db $9c, $98, $9a

; C: auto: 3 bytes, bytes; referenced by AnimEd_SortChoiceCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_SortChoiceCursor_Tbl5104::
    db $97, $99, $9b

; C: A: fills the list with 0
Mode12_State1F_SortDialogClose::
    ld de, AnimEd_SortChoiceCursor                ; $5107
    call AnimEd_WindowSlideIn                     ; $510A
    ld a, BANK(Gfx_0C_4C60_Mode12_State16_SaveDialogClose); $510D
    ld hl, Gfx_0C_4C60_Mode12_State16_SaveDialogClose; $510F
    ld de, $8c60                                  ; $5112
    ld bc, $0370                                  ; $5115
    call Vram_CopyFromBank                        ; $5118
    ld a, BANK(Gfx_0C_4500_Mode12_State1F_SortDialogClose); $511B
    ld hl, Gfx_0C_4500_Mode12_State1F_SortDialogClose; $511D
    ld de, $8500                                  ; $5120
    ld bc, $0300                                  ; $5123
    call Vram_CopyFromBank                        ; $5126
    ld a, [wAbResult]                             ; $5129
    bit 0, a                                      ; $512C
    jr z, jr_003_519b                             ; $512E

    ld a, [wAutofillMode]                         ; $5130
    and a                                         ; $5133
    jr z, jr_003_519b                             ; $5134

    ld a, [wCurEntryIndex]                        ; $5136
    ld c, a                                       ; $5139
    ld b, $00                                     ; $513A
    ld hl, wAnimList                              ; $513C
    add hl, bc                                    ; $513F
    ld a, [wPhotoCount]                           ; $5140
    and a                                         ; $5143
    jr z, jr_003_519b                             ; $5144

    ld b, a                                       ; $5146
    add c                                         ; $5147
    cp $30                                        ; $5148
    jr c, jr_003_5152                             ; $514A

    sub $2f                                       ; $514C
    cpl                                           ; $514E
    inc a                                         ; $514F
    add b                                         ; $5150
    ld b, a                                       ; $5151

jr_003_5152:
    push bc                                       ; $5152
    xor a                                         ; $5153

jr_003_5154:
    ld [hl+], a                                   ; $5154
    inc a                                         ; $5155
    dec b                                         ; $5156
    jr nz, jr_003_5154                            ; $5157

    pop bc                                        ; $5159
    ld a, [wAutofillMode]                         ; $515A
    cp $02                                        ; $515D
    call z, AnimEd_ShuffleList                    ; $515F
    ld a, [wCurEntryIndex]                        ; $5162
    ld c, a                                       ; $5165
    ld b, $00                                     ; $5166
    ld hl, wAnimList                              ; $5168
    add hl, bc                                    ; $516B
    ld a, [hl]                                    ; $516C
    ld [wCurEntryValue], a                        ; $516D
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $5170
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $5172
    ld de, $9800                                  ; $5175
    ld bc, $0400                                  ; $5178
    call Vram_CopyFromBank                        ; $517B
    call AnimEd_StartDecorations                  ; $517E
    call AnimEd_DrawTimingMarkers                 ; $5181
    call AnimEd_LoadEntryThumb                    ; $5184
    call AnimEd_ShowBorderDigits                  ; $5187
    call AnimEd_ShowEntryValue                    ; $518A
    call AnimEd_ShowEntryIndex                    ; $518D
    call AnimEd_ShowSpeed                         ; $5190
    call AnimEd_ShowLoopFlag                      ; $5193
    ld hl, wDirtyFlag                             ; $5196
    set 0, [hl]                                   ; $5199

jr_003_519b:
    ld a, STATE_12_BROWSE                         ; $519B
    ld [wState], a                                ; $519D
    ret                                           ; $51A0


; C: 10 random swaps within B entries starting at the cursor
AnimEd_ShuffleList::
    ld a, b                                       ; $51A1
    ldh [hScratchA], a                            ; $51A2
    ld a, [wCurEntryIndex]                        ; $51A4
    ldh [hScratchB], a                            ; $51A7
    ld b, $0a                                     ; $51A9

jr_003_51ab:
    push bc                                       ; $51AB
    ldh a, [hScratchA]                            ; $51AC
    call Rng_Scaled                               ; $51AE
    ld e, a                                       ; $51B1
    ldh a, [hScratchB]                            ; $51B2
    add e                                         ; $51B4
    ld e, a                                       ; $51B5
    ld d, $00                                     ; $51B6
    ldh a, [hScratchA]                            ; $51B8
    call Rng_Scaled                               ; $51BA
    ld c, a                                       ; $51BD
    ldh a, [hScratchB]                            ; $51BE
    add c                                         ; $51C0
    ld c, a                                       ; $51C1
    ld b, $00                                     ; $51C2
    ld hl, wAnimList                              ; $51C4
    add hl, de                                    ; $51C7
    ld a, [hl]                                    ; $51C8
    push hl                                       ; $51C9
    ld hl, wAnimList                              ; $51CA
    add hl, bc                                    ; $51CD
    ld c, [hl]                                    ; $51CE
    ld [hl], a                                    ; $51CF
    pop hl                                        ; $51D0
    ld [hl], c                                    ; $51D1
    pop bc                                        ; $51D2
    dec b                                         ; $51D3
    jr nz, jr_003_51ab                            ; $51D4

    ret                                           ; $51D6


; C: cursor on the border indicator: A opens the border picker
Mode12_State20_BorderRow::
    call AnimEd_DrawEntryCursor                   ; $51D7
    call AnimEd_UpdateSparks                      ; $51DA
    call AnimEd_DrawBorderHand                    ; $51DD
    ldh a, [hKeysNew]                             ; $51E0
    bit PADB_A, a                                 ; $51E2
    jr z, jr_003_51fb                             ; $51E4

    call Pal_FadeOut                              ; $51E6
    call Lcd_Off                                  ; $51E9
    ld a, [wAnimBorder]                           ; $51EC
    ld [wBorderNumber], a                         ; $51EF
    xor a                                         ; $51F2
    ld [wSubstate], a                             ; $51F3
    ld hl, wState                                 ; $51F6
    inc [hl]                                      ; $51F9
    ret                                           ; $51FA


jr_003_51fb:
    bit 7, a                                      ; $51FB
    jr z, jr_003_5221                             ; $51FD

    ld a, BANK(Gfx_0C_5D70_Mode12_State01_Browse) ; $51FF
    ld hl, Gfx_0C_5D70_Mode12_State01_Browse      ; $5201
    ld de, $8950                                  ; $5204
    ld bc, $0030                                  ; $5207
    call Vram_CopyFromBank                        ; $520A
    ld a, BANK(Gfx_0C_4920_Mode12_State20_BorderRow); $520D
    ld hl, Gfx_0C_4920_Mode12_State20_BorderRow   ; $520F
    ld de, $8920                                  ; $5212
    ld bc, $0030                                  ; $5215
    call Vram_CopyFromBank                        ; $5218
    ld a, STATE_12_EDIT_SPEED                     ; $521B
    ld [wState], a                                ; $521D
    ret                                           ; $5220


jr_003_5221:
    bit 2, a                                      ; $5221
    jr z, jr_003_522b                             ; $5223

    ld a, STATE_12_TOOLS_OPEN                     ; $5225
    ld [wState], a                                ; $5227
    ret                                           ; $522A


jr_003_522b:
    bit 1, a                                      ; $522B
    ret z                                         ; $522D

    call AnimEd_ClearSparks                       ; $522E
    ld a, [wDirtyFlag]                            ; $5231
    and a                                         ; $5234
    jr nz, jr_003_523d                            ; $5235

    ld a, STATE_12_EXIT                           ; $5237
    ld [wState], a                                ; $5239
    ret                                           ; $523C


jr_003_523d:
    ld a, STATE_12_SAVE_DIALOG_OPEN               ; $523D
    ld [wState], a                                ; $523F
    ret                                           ; $5242


; C: animated hand beside the border digits. L3 pass 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawBorderHand::
    ld a, [wSpriteAnimFrame + $4]                 ; $5243
    sla a                                         ; $5246
    ld e, a                                       ; $5248
    ld d, $00                                     ; $5249
    ld hl, AnimEd_DrawBorderHand_Gfx527A          ; $524B
    add hl, de                                    ; $524E
    ld a, [hl+]                                   ; $524F
    ld bc, $9428                                  ; $5250
    push hl                                       ; $5253
    cp $ff                                        ; $5254
    jr z, jr_003_525b                             ; $5256

    call Oam_AddMeta_B01_4000                     ; $5258

jr_003_525b:
    pop hl                                        ; $525B
    ld a, [wSpriteAnimTick + $4]                  ; $525C
    cp [hl]                                       ; $525F
    jr nz, jr_003_5272                            ; $5260

    ld a, [wSpriteAnimFrame + $4]                 ; $5262
    inc a                                         ; $5265
    cp $03                                        ; $5266
    jr c, jr_003_526b                             ; $5268

    xor a                                         ; $526A

jr_003_526b:
    ld [wSpriteAnimFrame + $4], a                 ; $526B
    xor a                                         ; $526E
    ld [wSpriteAnimTick + $4], a                  ; $526F

jr_003_5272:
    ld a, [wSpriteAnimTick + $4]                  ; $5272
    inc a                                         ; $5275
    ld [wSpriteAnimTick + $4], a                  ; $5276
    ret                                           ; $5279


; C: auto: 8 bytes, tile data; referenced by AnimEd_DrawBorderHand. L3 pass 2026-10-26: read in BGB in 7 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawBorderHand_Gfx527A::
    db $6e, $04, $6f, $04, $70, $07, $ff, $0a

; C: far call 08:4DF2
Mode12_State21_FarBorderPicker::
    ldh [hFarcallAArg], a                         ; $5282
    ld a, BANK(BorderPicker_Far)                  ; $5284
    ld hl, BorderPicker_Far                       ; $5286
    call Far_Call                                 ; $5289
    ret                                           ; $528C


; C: stores the picked border and rebuilds the editor screen
Mode12_State22_BorderPickerReturn::
    ld a, [wBorderNumber]                         ; $528D
    ld hl, wAnimBorder                            ; $5290
    cp [hl]                                       ; $5293
    jr z, jr_003_529c                             ; $5294

    ld [hl], a                                    ; $5296
    ld hl, wDirtyFlag                             ; $5297
    set 0, [hl]                                   ; $529A

jr_003_529c:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $529C
    ldh [hLcdcShadow], a                          ; $529E
    ld a, $e4                                     ; $52A0
    ld [wPaletteTarget], a                        ; $52A2
    ld [wPaletteTarget + $1], a                   ; $52A5
    ld a, $d2                                     ; $52A8
    ld [wPaletteTarget + $2], a                   ; $52AA
    xor a                                         ; $52AD
    ldh [hScxShadow], a                           ; $52AE
    ld a, $10                                     ; $52B0
    ldh [hScyShadow], a                           ; $52B2
    ld a, $95                                     ; $52B4
    ldh [hWyShadow], a                            ; $52B6
    ld a, $07                                     ; $52B8
    ldh [hWxShadow], a                            ; $52BA
    ld a, $0c                                     ; $52BC
    ld hl, Gfx_0C_4000_Mode12_State00_Init        ; $52BE
    ld de, $8000                                  ; $52C1
    ld bc, $1800                                  ; $52C4
    call Mem_CopyFromBank                         ; $52C7
    ld a, BANK(Map_22_6B40_Mode12_State00_Init)   ; $52CA
    ld hl, Map_22_6B40_Mode12_State00_Init        ; $52CC
    ld de, $9800                                  ; $52CF
    ld bc, $0400                                  ; $52D2
    call Mem_CopyFromBank                         ; $52D5
    ld a, BANK(Gfx_0C_5D40_Mode12_State22_BorderPickerReturn); $52D8
    ld hl, Gfx_0C_5D40_Mode12_State22_BorderPickerReturn; $52DA
    ld de, $8920                                  ; $52DD
    ld bc, $0030                                  ; $52E0
    call Mem_CopyFromBank                         ; $52E3
    ld a, BANK(Gfx_0C_5DA0_Mode12_State01_Browse) ; $52E6
    ld hl, Gfx_0C_5DA0_Mode12_State01_Browse      ; $52E8
    ld de, $88c0                                  ; $52EB
    ld bc, $0060                                  ; $52EE
    call Mem_CopyFromBank                         ; $52F1
    call Oam_ClearShadow                          ; $52F4
    call Pal_AllWhite                             ; $52F7
    call Lcd_On                                   ; $52FA
    call AnimEd_LoadEntryThumb                    ; $52FD
    call AnimEd_ShowBorderDigits                  ; $5300
    call AnimEd_ShowEntryValue                    ; $5303
    call AnimEd_ShowEntryIndex                    ; $5306
    call AnimEd_ShowSpeed                         ; $5309
    call AnimEd_LoadMenuTiles                     ; $530C
    call Pal_FadeIn                               ; $530F
    call AnimEd_StartDecorations                  ; $5312
    call AnimEd_DrawTimingMarkers                 ; $5315
    ld a, STATE_12_BORDER_ROW                     ; $5318
    ld [wState], a                                ; $531A
    ret                                           ; $531D


; C: loads the photo of play_entry into VRAM (far 02:5110)
AnimEd_LoadEntryPhoto::
    ld a, [wPlayEntry]                            ; $531E
    cp $fe                                        ; $5321
    ret nc                                        ; $5323

    bit 7, a                                      ; $5324
    jr z, jr_003_532c                             ; $5326

    res 7, a                                      ; $5328
    add $1e                                       ; $532A

jr_003_532c:
    ldh [hFarcallAArg], a                         ; $532C
    ld a, BANK(Photo_LoadToVram_Far)              ; $532E
    ld hl, Photo_LoadToVram_Far                   ; $5330
    call Far_Call                                 ; $5333
    ret                                           ; $5336


; C: draws the timing / loop markers of the 47 entries on the grid
AnimEd_DrawTimingMarkers::
    ld hl, wAnimTiming                            ; $5337
    ld bc, $002f                                  ; $533A

jr_003_533d:
    ld a, [hl+]                                   ; $533D
    bit 7, a                                      ; $533E
    jr nz, jr_003_534f                            ; $5340

    ld a, b                                       ; $5342
    ld e, $5c                                     ; $5343
    push hl                                       ; $5345
    call AnimEd_PutGridTile                       ; $5346
    pop hl                                        ; $5349
    inc b                                         ; $534A
    dec c                                         ; $534B
    jr nz, jr_003_533d                            ; $534C

    ret                                           ; $534E


jr_003_534f:
    ld a, b                                       ; $534F
    ld e, $a4                                     ; $5350
    push hl                                       ; $5352
    call AnimEd_PutGridTile                       ; $5353
    pop hl                                        ; $5356
    inc b                                         ; $5357
    dec c                                         ; $5358

jr_003_5359:
    ld a, [hl+]                                   ; $5359
    bit 6, a                                      ; $535A
    jr nz, jr_003_536a                            ; $535C

    ld a, b                                       ; $535E
    ld e, $a5                                     ; $535F
    push hl                                       ; $5361
    call AnimEd_PutGridTile                       ; $5362
    pop hl                                        ; $5365
    inc b                                         ; $5366
    dec c                                         ; $5367
    jr jr_003_5359                                ; $5368

jr_003_536a:
    ld a, b                                       ; $536A
    ld e, $a6                                     ; $536B
    push hl                                       ; $536D
    call AnimEd_PutGridTile                       ; $536E
    pop hl                                        ; $5371
    inc b                                         ; $5372
    dec c                                         ; $5373
    jr nz, jr_003_533d                            ; $5374

    ret                                           ; $5376


; C: A = entry index
AnimEd_PutGridTile::
    push bc                                       ; $5377
    inc a                                         ; $5378
    push af                                       ; $5379
    and $0f                                       ; $537A
    ld c, a                                       ; $537C
    pop af                                        ; $537D
    and $f0                                       ; $537E
    sla a                                         ; $5380
    sla a                                         ; $5382
    add c                                         ; $5384
    ld c, a                                       ; $5385
    ld b, $00                                     ; $5386
    ld hl, $99e2                                  ; $5388
    add hl, bc                                    ; $538B
    ld a, e                                       ; $538C
    push de                                       ; $538D
    call Vram_WriteByteSafe                       ; $538E
    pop de                                        ; $5391
    pop bc                                        ; $5392
    ret                                           ; $5393


; C: animated cursor sprite on the current entry
AnimEd_DrawEntryCursor::
    ld bc, $9404                                  ; $5394
    ld e, $00                                     ; $5397
    ld a, [wCurEntryValue]                        ; $5399
    bit 7, a                                      ; $539C
    jr nz, jr_003_53a4                            ; $539E

    ld c, $11                                     ; $53A0
    ld e, $06                                     ; $53A2

jr_003_53a4:
    and $7f                                       ; $53A4
    cp $7e                                        ; $53A6
    jr nc, jr_003_53b1                            ; $53A8

    sla a                                         ; $53AA
    sla a                                         ; $53AC
    add $10                                       ; $53AE
    ld b, a                                       ; $53B0

jr_003_53b1:
    ld a, [wCurEntryIndex]                        ; $53B1
    bit 7, a                                      ; $53B4
    jr nz, jr_003_53ba                            ; $53B6

    ld e, $0c                                     ; $53B8

jr_003_53ba:
    ld a, [wSpriteAnimFrame + $2]                 ; $53BA
    sla a                                         ; $53BD
    add e                                         ; $53BF
    ld e, a                                       ; $53C0
    ld d, $00                                     ; $53C1
    ld hl, AnimEd_DrawEntryCursor_Tbl53EB         ; $53C3
    add hl, de                                    ; $53C6
    ld a, [hl+]                                   ; $53C7
    push hl                                       ; $53C8
    call Oam_AddMeta_B01_4000                     ; $53C9
    pop hl                                        ; $53CC
    ld a, [wSpriteAnimTick + $2]                  ; $53CD
    cp [hl]                                       ; $53D0
    jr nz, jr_003_53e3                            ; $53D1

    ld a, [wSpriteAnimFrame + $2]                 ; $53D3
    inc a                                         ; $53D6
    cp $03                                        ; $53D7
    jr nz, jr_003_53dc                            ; $53D9

    xor a                                         ; $53DB

jr_003_53dc:
    ld [wSpriteAnimFrame + $2], a                 ; $53DC
    xor a                                         ; $53DF
    ld [wSpriteAnimTick + $2], a                  ; $53E0

jr_003_53e3:
    ld a, [wSpriteAnimTick + $2]                  ; $53E3
    inc a                                         ; $53E6
    ld [wSpriteAnimTick + $2], a                  ; $53E7
    ret                                           ; $53EA


; C: auto: 18 bytes, bytes; referenced by AnimEd_DrawEntryCursor. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawEntryCursor_Tbl53EB::
    db $50, $04, $51, $04, $52, $07, $53, $04, $54, $04, $55, $07, $7a, $04, $7a, $04
    db $7a, $07

; C: animated pointer sprite (position from the table at 5466). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite::
    ld a, [wCurEntryIndex]                        ; $53FD
    and $7f                                       ; $5400
    sla a                                         ; $5402
    ld c, a                                       ; $5404
    ld b, $00                                     ; $5405
    ld hl, AnimEd_DrawHandSprite_Tbl5466          ; $5407
    add hl, bc                                    ; $540A
    ld c, [hl]                                    ; $540B
    inc hl                                        ; $540C
    ld b, [hl]                                    ; $540D
    inc hl                                        ; $540E
    ld a, [wCurEntryIndex]                        ; $540F
    cp $0f                                        ; $5412
    jr nc, jr_003_541a                            ; $5414

    ld e, $00                                     ; $5416
    jr jr_003_542c                                ; $5418

jr_003_541a:
    cp $1f                                        ; $541A
    jr nc, jr_003_5422                            ; $541C

    ld e, $06                                     ; $541E
    jr jr_003_542c                                ; $5420

jr_003_5422:
    bit 7, a                                      ; $5422
    jr nz, jr_003_542a                            ; $5424

    ld e, $0c                                     ; $5426
    jr jr_003_542c                                ; $5428

jr_003_542a:
    ld e, $12                                     ; $542A

jr_003_542c:
    ld a, [wSpriteAnimFrame + $3]                 ; $542C
    sla a                                         ; $542F
    add e                                         ; $5431
    ld e, a                                       ; $5432
    ld d, $00                                     ; $5433
    ld hl, AnimEd_DrawHandSprite_Tbl54C4          ; $5435
    ld a, [wEditorRangeMode]                      ; $5438
    and a                                         ; $543B
    jr z, jr_003_5441                             ; $543C

    ld hl, AnimEd_DrawHandSprite_Tbl54DC          ; $543E

jr_003_5441:
    add hl, de                                    ; $5441
    ld a, [hl+]                                   ; $5442
    push hl                                       ; $5443
    call Oam_AddMeta_B01_4000                     ; $5444
    pop hl                                        ; $5447
    ld a, [wSpriteAnimTick + $3]                  ; $5448
    cp [hl]                                       ; $544B
    jr nz, jr_003_545e                            ; $544C

    ld a, [wSpriteAnimFrame + $3]                 ; $544E
    inc a                                         ; $5451
    cp $03                                        ; $5452
    jr nz, jr_003_5457                            ; $5454

    xor a                                         ; $5456

jr_003_5457:
    ld [wSpriteAnimFrame + $3], a                 ; $5457
    xor a                                         ; $545A
    ld [wSpriteAnimTick + $3], a                  ; $545B

jr_003_545e:
    ld a, [wSpriteAnimTick + $3]                  ; $545E
    inc a                                         ; $5461
    ld [wSpriteAnimTick + $3], a                  ; $5462
    ret                                           ; $5465


; C: auto: 94 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl5466::
    db $60, $18, $60, $20, $60, $28, $60, $30, $60, $38, $60, $40, $60, $48, $60, $50
    db $60, $58, $60, $60, $60, $68, $60, $70, $60, $78, $60, $80, $60, $88, $70, $10
    db $70, $18, $70, $20, $70, $28, $70, $30, $70, $38, $70, $40, $70, $48, $70, $50
    db $70, $58, $70, $60, $70, $68, $70, $70, $70, $78, $70, $80, $70, $88, $80, $10
    db $80, $18, $80, $20, $80, $28, $80, $30, $80, $38, $80, $40, $80, $48, $80, $50
    db $80, $58, $80, $60, $80, $68, $80, $70, $80, $78, $80, $80, $80, $88

; C: auto: 24 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 22 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl54C4::
    db $91, $04, $92, $04, $93, $07, $8e, $04, $8f, $04, $90, $07, $94, $04, $95, $04
    db $96, $07, $74, $04, $74, $04, $74, $04

; C: auto: 24 bytes, bytes; referenced by AnimEd_DrawHandSprite. L3 pass 2026-10-26: read in BGB in 19 replay(s) of
; the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawHandSprite_Tbl54DC::
    db $88, $07, $89, $04, $8a, $04, $60, $07, $61, $04, $62, $04, $8b, $07, $8c, $04
    db $8d, $04, $74, $04, $74, $04, $74, $04

; C: Up / Down changes the photo of the current entry
AnimEd_ChangeEntryValue::
    ldh a, [hKeysNewRepeat]                       ; $54F4
    ld b, a                                       ; $54F6
    ld a, [wCurEntryValue]                        ; $54F7
    bit 7, a                                      ; $54FA
    jr nz, jr_003_5503                            ; $54FC

    call AnimEd_StepPhotoValue                    ; $54FE
    jr jr_003_5506                                ; $5501

jr_003_5503:
    call AnimEd_StepStockValue                    ; $5503

jr_003_5506:
    ld hl, wCurEntryValue                         ; $5506
    cp [hl]                                       ; $5509
    ret z                                         ; $550A

    ld [wCurEntryValue], a                        ; $550B
    call AnimEd_LoadEntryThumb                    ; $550E
    call AnimEd_ShowEntryValue                    ; $5511
    ld a, [wCurEntryIndex]                        ; $5514
    res 7, a                                      ; $5517
    ld c, a                                       ; $5519
    ld b, $00                                     ; $551A
    ld hl, wAnimList                              ; $551C
    add hl, bc                                    ; $551F
    ld a, [wCurEntryValue]                        ; $5520
    ld [hl], a                                    ; $5523
    ret                                           ; $5524


; C: steps through the album photos
AnimEd_StepPhotoValue::
    call AnimEd_ReadStepKeys                      ; $5525
    ld hl, wPhotoCount                            ; $5528
    bit 7, a                                      ; $552B
    jr z, jr_003_5533                             ; $552D

    ld a, [hl]                                    ; $552F
    dec a                                         ; $5530
    jr jr_003_5537                                ; $5531

jr_003_5533:
    cp [hl]                                       ; $5533
    jr c, jr_003_5537                             ; $5534

    xor a                                         ; $5536

jr_003_5537:
    bit 6, b                                      ; $5537
    ret z                                         ; $5539

    push af                                       ; $553A
    ld a, SFX1_STEP_VALUE                         ; $553B
    call Snd_Sfx1                                 ; $553D
    pop af                                        ; $5540
    ld hl, wPhotoCount                            ; $5541
    cp [hl]                                       ; $5544
    jr c, jr_003_5549                             ; $5545

    ld a, [hl]                                    ; $5547
    dec a                                         ; $5548

jr_003_5549:
    set 7, a                                      ; $5549
    ret                                           ; $554B


; C: steps through the stock pictures
AnimEd_StepStockValue::
    inc a                                         ; $554C
    res 7, a                                      ; $554D
    dec a                                         ; $554F
    call AnimEd_ReadStepKeys                      ; $5550
    ld hl, wStockPictureCount                     ; $5553
    cp $fe                                        ; $5556
    jr nz, jr_003_555e                            ; $5558

    ld a, [hl]                                    ; $555A
    dec a                                         ; $555B
    jr jr_003_5563                                ; $555C

jr_003_555e:
    cp [hl]                                       ; $555E
    jr c, jr_003_5563                             ; $555F

    ld a, $ff                                     ; $5561

jr_003_5563:
    set 7, a                                      ; $5563
    ld c, a                                       ; $5565
    ld a, [wPhotoCount]                           ; $5566
    and a                                         ; $5569
    ld a, c                                       ; $556A
    ret z                                         ; $556B

    bit 7, b                                      ; $556C
    ret z                                         ; $556E

    push af                                       ; $556F
    ld a, SFX1_STEP_VALUE                         ; $5570
    call Snd_Sfx1                                 ; $5572
    pop af                                        ; $5575
    res 7, a                                      ; $5576
    ld hl, wPhotoCount                            ; $5578
    cp [hl]                                       ; $557B
    ret c                                         ; $557C

    ld a, [hl]                                    ; $557D
    dec a                                         ; $557E
    ret                                           ; $557F


; C: Left / Right repeat -> -1 / +1 with a blip. L3 pass 2026-10-26: executed in BGB in 20 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ReadStepKeys::
    bit 5, b                                      ; $5580
    jr z, jr_003_558d                             ; $5582

    dec a                                         ; $5584
    push af                                       ; $5585
    ld a, SFX1_STEP_FAST                          ; $5586
    call Snd_Sfx1                                 ; $5588
    pop af                                        ; $558B
    ret                                           ; $558C


jr_003_558d:
    bit 4, b                                      ; $558D
    ret z                                         ; $558F

    inc a                                         ; $5590
    push af                                       ; $5591
    ld a, SFX1_STEP_FAST                          ; $5592
    call Snd_Sfx1                                 ; $5594
    pop af                                        ; $5597
    ret                                           ; $5598


; C: D-pad moves the entry cursor; carry at the end of the list
AnimEd_MoveEntryCursor::
    ldh a, [hKeysNewRepeat]                       ; $5599
    ld b, a                                       ; $559B
    ld a, [wCurEntryIndex]                        ; $559C
    call AnimEd_CursorLeftRight                   ; $559F
    bit 7, a                                      ; $55A2
    jr nz, jr_003_55aa                            ; $55A4

    cp $2f                                        ; $55A6
    jr nz, jr_003_55ae                            ; $55A8

jr_003_55aa:
    ld a, $01                                     ; $55AA
    scf                                           ; $55AC
    ret                                           ; $55AD


jr_003_55ae:
    call AnimEd_CursorUpDown                      ; $55AE
    bit 7, a                                      ; $55B1
    jr z, jr_003_55b8                             ; $55B3

    xor a                                         ; $55B5
    scf                                           ; $55B6
    ret                                           ; $55B7


jr_003_55b8:
    ld hl, wCurEntryIndex                         ; $55B8
    cp [hl]                                       ; $55BB
    ret z                                         ; $55BC

    ld [hl], a                                    ; $55BD
    call AnimEd_ShowEntryIndex                    ; $55BE
    ld a, [wCurEntryIndex]                        ; $55C1
    ld c, a                                       ; $55C4
    ld b, $00                                     ; $55C5
    ld hl, wAnimList                              ; $55C7
    add hl, bc                                    ; $55CA
    ld a, [hl]                                    ; $55CB
    ld hl, wCurEntryValue                         ; $55CC
    cp [hl]                                       ; $55CF
    ret z                                         ; $55D0

    ld [hl], a                                    ; $55D1
    call AnimEd_LoadEntryThumb                    ; $55D2
    call AnimEd_ShowEntryValue                    ; $55D5
    and a                                         ; $55D8
    ret                                           ; $55D9


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CursorLeftRight::
    bit 5, b                                      ; $55DA
    jr z, jr_003_55e7                             ; $55DC

    dec a                                         ; $55DE
    push af                                       ; $55DF
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $55E0
    call Snd_Sfx1                                 ; $55E2
    pop af                                        ; $55E5
    ret                                           ; $55E6


jr_003_55e7:
    bit 4, b                                      ; $55E7
    ret z                                         ; $55E9

    inc a                                         ; $55EA
    push af                                       ; $55EB
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $55EC
    call Snd_Sfx1                                 ; $55EE
    pop af                                        ; $55F1
    ret                                           ; $55F2


; C: moves by 16 entries (one row). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes
; 12 (tcrf_check/assets/l3_names/)
AnimEd_CursorUpDown::
    bit 6, b                                      ; $55F3
    jr z, jr_003_5604                             ; $55F5

    cp $0f                                        ; $55F7
    ret z                                         ; $55F9

    sub $10                                       ; $55FA
    push af                                       ; $55FC
    ld a, SFX1_KEY_UP_DOWN                        ; $55FD
    call Snd_Sfx1                                 ; $55FF
    pop af                                        ; $5602
    ret                                           ; $5603


jr_003_5604:
    bit 7, b                                      ; $5604
    ret z                                         ; $5606

    cp $1f                                        ; $5607
    ret nc                                        ; $5609

    add $10                                       ; $560A
    push af                                       ; $560C
    ld a, SFX1_KEY_UP_DOWN                        ; $560D
    call Snd_Sfx1                                 ; $560F
    pop af                                        ; $5612
    ret                                           ; $5613


; C: sets the three decoration contexts (5691 / 57BE / 5847)
AnimEd_StartDecorations::
    xor a                                         ; $5614
    ld [wSpriteAnimTick], a                       ; $5615
    ld [wSpriteAnimTick + $1], a                  ; $5618
    ld a, $02                                     ; $561B
    ld [wSpriteAnimFrame], a                      ; $561D
    ld [wSpriteAnimFrame + $1], a                 ; $5620
    ld a, $91                                     ; $5623
    ld [wCtx0Ret], a                              ; $5625
    ld a, $56                                     ; $5628
    ld [wCtx0Ret + $1], a                         ; $562A
    ld a, $be                                     ; $562D
    ld [wCtx1Ret], a                              ; $562F
    ld a, $57                                     ; $5632
    ld [wCtx1Ret + $1], a                         ; $5634
    ld a, $47                                     ; $5637
    ld [wCtx2Ret], a                              ; $5639
    ld a, $58                                     ; $563C
    ld [wCtx2Ret + $1], a                         ; $563E
    xor a                                         ; $5641
    ld [wCoroIndex], a                            ; $5642
    call AnimEd_Ctx0_Decor                        ; $5645
    ret                                           ; $5648


; C: saves the registers of the running context and resumes the next of three (rst 08 after the third)
AnimEd_CoroYield::
    push af                                       ; $5649
    push bc                                       ; $564A
    push de                                       ; $564B
    push hl                                       ; $564C
    ld a, [wCoroIndex]                            ; $564D
    swap a                                        ; $5650
    ld c, a                                       ; $5652
    ld b, $00                                     ; $5653
    ld hl, wCoroContext                           ; $5655
    add hl, bc                                    ; $5658
    ld b, $05                                     ; $5659

jr_003_565b:
    pop de                                        ; $565B
    ld [hl], e                                    ; $565C
    inc hl                                        ; $565D
    ld [hl], d                                    ; $565E
    inc hl                                        ; $565F
    dec b                                         ; $5660
    jr nz, jr_003_565b                            ; $5661

    ld a, [wCoroIndex]                            ; $5663
    inc a                                         ; $5666
    cp $03                                        ; $5667
    jr nz, jr_003_5670                            ; $5669

    call Oam_HideUnused                           ; $566B
    rst Rst08_WaitVBlank                          ; $566E
    xor a                                         ; $566F

jr_003_5670:
    ld [wCoroIndex], a                            ; $5670
    swap a                                        ; $5673
    ld c, a                                       ; $5675
    ld b, $00                                     ; $5676
    ld hl, wCtx0Pad                               ; $5678
    add hl, bc                                    ; $567B
    ld b, $05                                     ; $567C

jr_003_567e:
    dec hl                                        ; $567E
    ld d, [hl]                                    ; $567F
    dec hl                                        ; $5680
    ld e, [hl]                                    ; $5681
    push de                                       ; $5682
    dec b                                         ; $5683
    jr nz, jr_003_567e                            ; $5684

    pop hl                                        ; $5686
    pop de                                        ; $5687
    pop bc                                        ; $5688
    pop af                                        ; $5689
    ret                                           ; $568A


; I: 3 words 5691 / 57BE / 5847 = entry points of AnimEd_Ctx0/1/2_Decor, the same values AnimEd_StartDecorations
; stores through split immediates; no reader of the table (read in forced runs only)
AnimEd_Decor_CtxEntryTbl::
    dw AnimEd_Ctx0_Decor
    dw AnimEd_Ctx1_Decor
    dw AnimEd_Ctx2_Decor

; C: context 0: draws the tool bar tiles. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx0_Decor::
    ld a, [wAnimLoopFlag]                         ; $5691
    and a                                         ; $5694
    jr z, jr_003_56b3                             ; $5695

    ld a, BANK(Gfx_0C_5CA0_AnimEd_Ctx0_Decor)     ; $5697
    ld hl, Gfx_0C_5CA0_AnimEd_Ctx0_Decor          ; $5699
    ld de, $97c0                                  ; $569C
    ld bc, $0020                                  ; $569F
    call Vram_CopyFromBank                        ; $56A2
    ld a, BANK(Gfx_0C_5CC0_AnimEd_Ctx0_Decor)     ; $56A5
    ld hl, Gfx_0C_5CC0_AnimEd_Ctx0_Decor          ; $56A7
    ld de, $9770                                  ; $56AA
    ld bc, $0010                                  ; $56AD
    call Vram_CopyFromBank                        ; $56B0

jr_003_56b3:
    ld hl, $9a53                                  ; $56B3
    ld de, AnimEd_Ctx0_Decor_Map57A6              ; $56B6
    ld bc, wAnimList + $2e                        ; $56B9
    ld a, $03                                     ; $56BC

; C: row loop top (3 rows) of the decor strip drawn by context 0: two map cells per row from the table at DE, then 16
; columns with a sprite sweep (branch target; code read 2026-10-19)
AnimEd_Ctx0_Decor_RowLoop::
    push af                                       ; $56BE
    swap a                                        ; $56BF
    add $48                                       ; $56C1
    ld [wSprYTmp], a                              ; $56C3
    ld a, $02                                     ; $56C6

jr_003_56c8:
    push af                                       ; $56C8
    ld a, [de]                                    ; $56C9
    call Vram_WriteByteSafe                       ; $56CA
    set 5, l                                      ; $56CD
    inc de                                        ; $56CF
    ld a, [de]                                    ; $56D0
    call Vram_WriteByteSafe                       ; $56D1
    inc de                                        ; $56D4
    res 5, l                                      ; $56D5
    dec l                                         ; $56D7
    pop af                                        ; $56D8
    dec a                                         ; $56D9
    jr nz, jr_003_56c8                            ; $56DA

    push de                                       ; $56DC
    ld a, $10                                     ; $56DD

jr_003_56df:
    push af                                       ; $56DF
    sla a                                         ; $56E0
    sla a                                         ; $56E2
    sla a                                         ; $56E4
    add $f8                                       ; $56E6
    ld [wSprXTmp], a                              ; $56E8
    ld a, [bc]                                    ; $56EB
    cp $fe                                        ; $56EC
    jr nc, jr_003_56f4                            ; $56EE

    ld a, $85                                     ; $56F0
    jr jr_003_56f6                                ; $56F2

jr_003_56f4:
    ld a, $7e                                     ; $56F4

jr_003_56f6:
    call Vram_WriteByteSafe                       ; $56F6
    set 5, l                                      ; $56F9
    ld a, $5c                                     ; $56FB
    call Vram_WriteByteSafe                       ; $56FD
    res 5, l                                      ; $5700
    push bc                                       ; $5702
    ld a, [wSprXTmp]                              ; $5703
    and $10                                       ; $5706
    swap a                                        ; $5708
    add $77                                       ; $570A
    push af                                       ; $570C
    ld a, [wSprXTmp]                              ; $570D
    ld b, a                                       ; $5710
    ld a, [wSprYTmp]                              ; $5711
    ld c, a                                       ; $5714
    pop af                                        ; $5715
    call Oam_AddMeta_B01_4000                     ; $5716
    pop bc                                        ; $5719
    call AnimEd_CoroYield                         ; $571A
    dec bc                                        ; $571D
    dec l                                         ; $571E
    pop af                                        ; $571F
    dec a                                         ; $5720
    jr nz, jr_003_56df                            ; $5721

    pop de                                        ; $5723
    ld a, $02                                     ; $5724

jr_003_5726:
    push af                                       ; $5726
    ld a, [de]                                    ; $5727
    call Vram_WriteByteSafe                       ; $5728
    set 5, l                                      ; $572B
    inc de                                        ; $572D
    ld a, [de]                                    ; $572E
    call Vram_WriteByteSafe                       ; $572F
    inc de                                        ; $5732
    res 5, l                                      ; $5733
    dec l                                         ; $5735
    pop af                                        ; $5736
    dec a                                         ; $5737
    jr nz, jr_003_5726                            ; $5738

    inc l                                         ; $573A
    ld a, l                                       ; $573B
    sub $2d                                       ; $573C
    ld l, a                                       ; $573E
    jr nc, jr_003_5742                            ; $573F

    dec h                                         ; $5741

jr_003_5742:
    pop af                                        ; $5742
    dec a                                         ; $5743
    jp nz, AnimEd_Ctx0_Decor_RowLoop              ; $5744

    ld a, $67                                     ; $5747
    ld hl, $9980                                  ; $5749
    call Vram_WriteByteSafe                       ; $574C
    ld a, $68                                     ; $574F
    ld hl, $9981                                  ; $5751
    call Vram_WriteByteSafe                       ; $5754
    ld a, $72                                     ; $5757
    ld hl, $99a0                                  ; $5759
    call Vram_WriteByteSafe                       ; $575C
    ld a, $73                                     ; $575F
    ld hl, $99a1                                  ; $5761
    call Vram_WriteByteSafe                       ; $5764
    ld a, $82                                     ; $5767
    ld hl, $99c0                                  ; $5769
    call Vram_WriteByteSafe                       ; $576C
    ld a, $83                                     ; $576F
    ld hl, $99c1                                  ; $5771
    call Vram_WriteByteSafe                       ; $5774
    ld a, $84                                     ; $5777
    ld hl, $99c2                                  ; $5779
    call Vram_WriteByteSafe                       ; $577C
    ld a, $59                                     ; $577F
    ld hl, $99e0                                  ; $5781
    call Vram_WriteByteSafe                       ; $5784
    ld a, $5a                                     ; $5787
    ld hl, $99e1                                  ; $5789
    call Vram_WriteByteSafe                       ; $578C
    ld a, $5b                                     ; $578F
    ld hl, $99e2                                  ; $5791
    call Vram_WriteByteSafe                       ; $5794
    ld a, BANK(Gfx_0C_6020_AnimEd_Ctx0_Decor)     ; $5797
    ld hl, Gfx_0C_6020_AnimEd_Ctx0_Decor          ; $5799
    ld de, $9500                                  ; $579C
    ld bc, $0060                                  ; $579F
    call Vram_CopyFromBank                        ; $57A2
    ret                                           ; $57A5


; C: auto: 24 bytes, tile map; referenced by AnimEd_Ctx0_Decor. L3 pass 2026-10-26: read in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx0_Decor_Map57A6::
    db $77, $7d, $79, $7c, $78, $88, $8a, $fe, $7a, $fe, $79, $86, $78, $88, $8a, $fe
    db $7a, $fe, $79, $86, $78, $88, $fe, $fe

; C: context 1: border animation (sprites and tiles). L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_Decor::
    ld bc, $1e0a                                  ; $57BE

jr_003_57c1:
    call AnimEd_Ctx1_BorderSprite                 ; $57C1
    call AnimEd_CoroYield                         ; $57C4
    dec c                                         ; $57C7
    jr nz, jr_003_57c1                            ; $57C8

    ld hl, $9842                                  ; $57CA
    ld b, $1e                                     ; $57CD

jr_003_57cf:
    ld a, $a0                                     ; $57CF
    call Vram_WriteByteSafe                       ; $57D1
    set 5, l                                      ; $57D4
    ld a, $a2                                     ; $57D6
    call Vram_WriteByteSafe                       ; $57D8
    res 5, l                                      ; $57DB
    inc hl                                        ; $57DD
    ld a, $a1                                     ; $57DE
    call Vram_WriteByteSafe                       ; $57E0
    set 5, l                                      ; $57E3
    ld a, $a3                                     ; $57E5
    call Vram_WriteByteSafe                       ; $57E7
    res 5, l                                      ; $57EA
    dec hl                                        ; $57EC
    call AnimEd_Ctx1_BorderSprite                 ; $57ED
    call AnimEd_CoroYield                         ; $57F0
    dec b                                         ; $57F3
    ld a, $4a                                     ; $57F4
    call Vram_WriteByteSafe                       ; $57F6
    set 5, l                                      ; $57F9
    ld a, $4b                                     ; $57FB
    call Vram_WriteByteSafe                       ; $57FD
    res 5, l                                      ; $5800
    inc hl                                        ; $5802
    ld a, $4c                                     ; $5803
    call Vram_WriteByteSafe                       ; $5805
    set 5, l                                      ; $5808
    ld a, $4d                                     ; $580A
    call Vram_WriteByteSafe                       ; $580C
    res 5, l                                      ; $580F
    call AnimEd_Ctx1_BorderSprite                 ; $5811
    call AnimEd_CoroYield                         ; $5814
    dec b                                         ; $5817
    jr nz, jr_003_57cf                            ; $5818

jr_003_581a:
    ld a, $42                                     ; $581A
    ld bc, $0200                                  ; $581C
    call Oam_AddMeta_B01_4000                     ; $581F
    call AnimEd_CoroYield                         ; $5822
    jr jr_003_581a                                ; $5825

; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_BorderSprite::
    push bc                                       ; $5827
    push hl                                       ; $5828
    ld a, $21                                     ; $5829
    sub b                                         ; $582B
    and $07                                       ; $582C
    ld c, a                                       ; $582E
    ld b, $00                                     ; $582F
    ld hl, AnimEd_Ctx1_BorderSprite_PtrTbl583F    ; $5831
    add hl, bc                                    ; $5834
    ld a, [hl]                                    ; $5835
    ld bc, $0200                                  ; $5836
    call Oam_AddMeta_B01_4000                     ; $5839
    pop hl                                        ; $583C
    pop bc                                        ; $583D
    ret                                           ; $583E


; C: auto: 8 bytes, word table; referenced by AnimEd_Ctx1_BorderSprite. L3 pass 2026-10-26: read in BGB in 22
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx1_BorderSprite_PtrTbl583F::
    dw $4342
    dw $4544
    dw $4645
    dw $4847

; C: context 2: second border animation. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_Decor::
    ld bc, $1e0a                                  ; $5847

jr_003_584a:
    call AnimEd_Ctx2_BorderSprite                 ; $584A
    call AnimEd_CoroYield                         ; $584D
    dec c                                         ; $5850
    jr nz, jr_003_584a                            ; $5851

    ld hl, $9882                                  ; $5853
    ld b, $1e                                     ; $5856

jr_003_5858:
    ld a, $9c                                     ; $5858
    call Vram_WriteByteSafe                       ; $585A
    set 5, l                                      ; $585D
    ld a, $49                                     ; $585F
    call AnimEd_Ctx2_InRange                      ; $5861
    jr nc, jr_003_5868                            ; $5864

    ld a, $4e                                     ; $5866

jr_003_5868:
    call Vram_WriteByteSafe                       ; $5868
    res 5, l                                      ; $586B
    inc hl                                        ; $586D
    ld a, $9d                                     ; $586E
    call Vram_WriteByteSafe                       ; $5870
    set 5, l                                      ; $5873
    ld a, $9e                                     ; $5875
    call AnimEd_Ctx2_InRange                      ; $5877
    jr nc, jr_003_587e                            ; $587A

    ld a, $9f                                     ; $587C

jr_003_587e:
    call Vram_WriteByteSafe                       ; $587E
    res 5, l                                      ; $5881
    dec hl                                        ; $5883
    call AnimEd_Ctx2_BorderSprite                 ; $5884
    call AnimEd_CoroYield                         ; $5887
    dec b                                         ; $588A
    jr z, jr_003_58c1                             ; $588B

    ld a, $48                                     ; $588D
    call Vram_WriteByteSafe                       ; $588F
    set 5, l                                      ; $5892
    ld a, $49                                     ; $5894
    call AnimEd_Ctx2_InRange                      ; $5896
    jr nc, jr_003_589d                            ; $5899

    ld a, $4e                                     ; $589B

jr_003_589d:
    call Vram_WriteByteSafe                       ; $589D
    res 5, l                                      ; $58A0
    inc hl                                        ; $58A2
    ld a, $58                                     ; $58A3
    call Vram_WriteByteSafe                       ; $58A5
    set 5, l                                      ; $58A8
    ld a, $49                                     ; $58AA
    call AnimEd_Ctx2_InRange                      ; $58AC
    jr nc, jr_003_58b3                            ; $58AF

    ld a, $4e                                     ; $58B1

jr_003_58b3:
    call Vram_WriteByteSafe                       ; $58B3
    res 5, l                                      ; $58B6
    call AnimEd_Ctx2_BorderSprite                 ; $58B8
    call AnimEd_CoroYield                         ; $58BB
    dec b                                         ; $58BE
    jr nz, jr_003_5858                            ; $58BF

jr_003_58c1:
    ld a, $49                                     ; $58C1
    ld bc, $020d                                  ; $58C3
    call Oam_AddMeta_B01_4000                     ; $58C6
    call AnimEd_CoroYield                         ; $58C9
    jr jr_003_58c1                                ; $58CC

; C: carry if the tile column is within the inner range. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_InRange::
    push af                                       ; $58CE
    ld a, l                                       ; $58CF
    and $1f                                       ; $58D0
    cp $03                                        ; $58D2
    jr c, jr_003_58dd                             ; $58D4

    cp $11                                        ; $58D6
    jr nc, jr_003_58dd                            ; $58D8

    pop af                                        ; $58DA
    scf                                           ; $58DB
    ret                                           ; $58DC


jr_003_58dd:
    pop af                                        ; $58DD
    and a                                         ; $58DE
    ret                                           ; $58DF


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_BorderSprite::
    push bc                                       ; $58E0
    push hl                                       ; $58E1
    ld a, $21                                     ; $58E2
    sub b                                         ; $58E4
    and $07                                       ; $58E5
    ld c, a                                       ; $58E7
    ld b, $00                                     ; $58E8
    ld hl, AnimEd_Ctx2_BorderSprite_PtrTbl58F8    ; $58EA
    add hl, bc                                    ; $58ED
    ld a, [hl]                                    ; $58EE
    ld bc, $020d                                  ; $58EF
    call Oam_AddMeta_B01_4000                     ; $58F2
    pop hl                                        ; $58F5
    pop bc                                        ; $58F6
    ret                                           ; $58F7


; C: auto: 8 bytes, word table; referenced by AnimEd_Ctx2_BorderSprite. L3 pass 2026-10-26: read in BGB in 22
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_Ctx2_BorderSprite_PtrTbl58F8::
    dw $4a49
    dw $4c4b
    dw $4d4d
    dw $4f4e

; C: sets the three exit contexts and draws the transition tiles. L3 pass 2026-10-26: executed in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_StartExitTransition::
    ld a, $80                                     ; $5900
    ld [wSpriteAnimTick], a                       ; $5902
    ld [wSpriteAnimTick + $1], a                  ; $5905
    xor a                                         ; $5908
    ld [wSpriteAnimFrame], a                      ; $5909
    ld [wSpriteAnimFrame + $1], a                 ; $590C
    ld a, $f7                                     ; $590F
    ld [wCtx0Ret], a                              ; $5911
    ld a, $59                                     ; $5914
    ld [wCtx0Ret + $1], a                         ; $5916
    ld a, $7a                                     ; $5919
    ld [wCtx1Ret], a                              ; $591B
    ld a, $5a                                     ; $591E
    ld [wCtx1Ret + $1], a                         ; $5920
    ld a, $00                                     ; $5923
    ld [wCtx2Ret], a                              ; $5925
    ld a, $5b                                     ; $5928
    ld [wCtx2Ret + $1], a                         ; $592A
    xor a                                         ; $592D
    ld [wCoroIndex], a                            ; $592E
    ld a, $77                                     ; $5931
    ld bc, $0058                                  ; $5933
    call Oam_AddMeta_B01_4000                     ; $5936
    ld a, $42                                     ; $5939
    ld bc, $0200                                  ; $593B
    call Oam_AddMeta_B01_4000                     ; $593E
    ld a, $49                                     ; $5941
    ld bc, $020d                                  ; $5943
    call Oam_AddMeta_B01_4000                     ; $5946
    call Oam_HideUnused                           ; $5949
    rst Rst08_WaitVBlank                          ; $594C
    ld a, $60                                     ; $594D
    ld hl, $9980                                  ; $594F
    call Vram_WriteByteSafe                       ; $5952
    ld a, $61                                     ; $5955
    ld hl, $9981                                  ; $5957
    call Vram_WriteByteSafe                       ; $595A
    ld a, $fe                                     ; $595D
    ld hl, $99a0                                  ; $595F
    call Vram_WriteByteSafe                       ; $5962
    ld a, $fe                                     ; $5965
    ld hl, $99a1                                  ; $5967
    call Vram_WriteByteSafe                       ; $596A
    ld a, $fe                                     ; $596D
    ld hl, $99c0                                  ; $596F
    call Vram_WriteByteSafe                       ; $5972
    ld a, $fe                                     ; $5975
    ld hl, $99c1                                  ; $5977
    call Vram_WriteByteSafe                       ; $597A
    ld a, $fe                                     ; $597D
    ld hl, $99c2                                  ; $597F
    call Vram_WriteByteSafe                       ; $5982
    ld a, $fe                                     ; $5985
    ld hl, $99e0                                  ; $5987
    call Vram_WriteByteSafe                       ; $598A
    ld a, $fe                                     ; $598D
    ld hl, $99e1                                  ; $598F
    call Vram_WriteByteSafe                       ; $5992
    ld a, $fe                                     ; $5995
    ld hl, $99e2                                  ; $5997
    call Vram_WriteByteSafe                       ; $599A
    ld a, BANK(Gfx_0C_5500_Mode12_State0F_ClearAll); $599D
    ld hl, Gfx_0C_5500_Mode12_State0F_ClearAll    ; $599F
    ld de, $9500                                  ; $59A2
    ld bc, $0060                                  ; $59A5
    call Vram_CopyFromBank                        ; $59A8
    call AnimEd_ExitCtx0                          ; $59AB
    ret                                           ; $59AE


; C: same switch as 5649 for the exit contexts. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CoroYield_B::
    push af                                       ; $59AF
    push bc                                       ; $59B0
    push de                                       ; $59B1
    push hl                                       ; $59B2
    ld a, [wCoroIndex]                            ; $59B3
    swap a                                        ; $59B6
    ld c, a                                       ; $59B8
    ld b, $00                                     ; $59B9
    ld hl, wCoroContext                           ; $59BB
    add hl, bc                                    ; $59BE
    ld b, $05                                     ; $59BF

jr_003_59c1:
    pop de                                        ; $59C1
    ld [hl], e                                    ; $59C2
    inc hl                                        ; $59C3
    ld [hl], d                                    ; $59C4
    inc hl                                        ; $59C5
    dec b                                         ; $59C6
    jr nz, jr_003_59c1                            ; $59C7

    ld a, [wCoroIndex]                            ; $59C9
    inc a                                         ; $59CC
    cp $03                                        ; $59CD
    jr nz, jr_003_59d6                            ; $59CF

    call Oam_HideUnused                           ; $59D1
    rst Rst08_WaitVBlank                          ; $59D4
    xor a                                         ; $59D5

jr_003_59d6:
    ld [wCoroIndex], a                            ; $59D6
    swap a                                        ; $59D9
    ld c, a                                       ; $59DB
    ld b, $00                                     ; $59DC
    ld hl, wCtx0Pad                               ; $59DE
    add hl, bc                                    ; $59E1
    ld b, $05                                     ; $59E2

jr_003_59e4:
    dec hl                                        ; $59E4
    ld d, [hl]                                    ; $59E5
    dec hl                                        ; $59E6
    ld e, [hl]                                    ; $59E7
    push de                                       ; $59E8
    dec b                                         ; $59E9
    jr nz, jr_003_59e4                            ; $59EA

    pop hl                                        ; $59EC
    pop de                                        ; $59ED
    pop bc                                        ; $59EE
    pop af                                        ; $59EF
    ret                                           ; $59F0


; I: 3 words 59F7 / 5A7A / 5B00 = entry points of AnimEd_ExitCtx0/1/2, the values AnimEd_StartExitTransition stores
; through split immediates; no reader of the table (read in forced runs only)
AnimEd_Exit_CtxEntryTbl::
    dw AnimEd_ExitCtx0
    dw AnimEd_ExitCtx1
    dw AnimEd_ExitCtx2

; C: exit context 0. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx0::
    ld hl, $99c0                                  ; $59F7
    ld a, $03                                     ; $59FA

; C: row loop top (3 rows) of the exit sweep of context 0: blanks two cells per row ($FE) and sweeps 16 columns with a
; sprite (branch target; code read 2026-10-19)
AnimEd_ExitCtx0_RowLoop::
    push af                                       ; $59FC
    cpl                                           ; $59FD
    add $05                                       ; $59FE
    swap a                                        ; $5A00
    add $48                                       ; $5A02
    ld [wSprYTmp], a                              ; $5A04
    ld a, $02                                     ; $5A07

jr_003_5a09:
    push af                                       ; $5A09
    ld a, $fe                                     ; $5A0A
    call Vram_WriteByteSafe                       ; $5A0C
    set 5, l                                      ; $5A0F
    call Vram_WriteByteSafe                       ; $5A11
    res 5, l                                      ; $5A14
    inc l                                         ; $5A16
    pop af                                        ; $5A17
    dec a                                         ; $5A18
    jr nz, jr_003_5a09                            ; $5A19

    ld a, $10                                     ; $5A1B

jr_003_5a1d:
    push af                                       ; $5A1D
    cpl                                           ; $5A1E
    add $12                                       ; $5A1F
    sla a                                         ; $5A21
    sla a                                         ; $5A23
    sla a                                         ; $5A25
    add $f8                                       ; $5A27
    ld [wSprXTmp], a                              ; $5A29
    push bc                                       ; $5A2C
    ld a, [wSprXTmp]                              ; $5A2D
    and $10                                       ; $5A30
    swap a                                        ; $5A32
    add $77                                       ; $5A34
    push af                                       ; $5A36
    ld a, [wSprXTmp]                              ; $5A37
    ld b, a                                       ; $5A3A
    ld a, [wSprYTmp]                              ; $5A3B
    ld c, a                                       ; $5A3E
    pop af                                        ; $5A3F
    call Oam_AddMeta_B01_4000                     ; $5A40
    pop bc                                        ; $5A43
    call AnimEd_CoroYield_B                       ; $5A44
    ld a, $fe                                     ; $5A47
    call Vram_WriteByteSafe                       ; $5A49
    set 5, l                                      ; $5A4C
    call Vram_WriteByteSafe                       ; $5A4E
    res 5, l                                      ; $5A51
    dec bc                                        ; $5A53
    inc l                                         ; $5A54
    pop af                                        ; $5A55
    dec a                                         ; $5A56
    jr nz, jr_003_5a1d                            ; $5A57

    ld a, $02                                     ; $5A59

jr_003_5a5b:
    push af                                       ; $5A5B
    ld a, $fe                                     ; $5A5C
    call Vram_WriteByteSafe                       ; $5A5E
    set 5, l                                      ; $5A61
    call Vram_WriteByteSafe                       ; $5A63
    res 5, l                                      ; $5A66
    inc l                                         ; $5A68
    pop af                                        ; $5A69
    dec a                                         ; $5A6A
    jr nz, jr_003_5a5b                            ; $5A6B

    ld a, l                                       ; $5A6D
    add $2c                                       ; $5A6E
    ld l, a                                       ; $5A70
    jr nc, jr_003_5a74                            ; $5A71

    inc h                                         ; $5A73

jr_003_5a74:
    pop af                                        ; $5A74
    dec a                                         ; $5A75
    jp nz, AnimEd_ExitCtx0_RowLoop                ; $5A76

    ret                                           ; $5A79


; C: exit context 1. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1::
    ld bc, $1e0f                                  ; $5A7A

jr_003_5a7d:
    call AnimEd_ExitCtx1_Sprite                   ; $5A7D
    call AnimEd_CoroYield_B                       ; $5A80
    dec c                                         ; $5A83
    jr nz, jr_003_5a7d                            ; $5A84

    ld hl, $9851                                  ; $5A86
    ld b, $1e                                     ; $5A89

jr_003_5a8b:
    ld a, $a1                                     ; $5A8B
    call Vram_WriteByteSafe                       ; $5A8D
    set 5, l                                      ; $5A90
    ld a, $a3                                     ; $5A92
    call Vram_WriteByteSafe                       ; $5A94
    res 5, l                                      ; $5A97
    dec hl                                        ; $5A99
    ld a, $a0                                     ; $5A9A
    call Vram_WriteByteSafe                       ; $5A9C
    set 5, l                                      ; $5A9F
    ld a, $a2                                     ; $5AA1
    call Vram_WriteByteSafe                       ; $5AA3
    res 5, l                                      ; $5AA6
    inc hl                                        ; $5AA8
    dec b                                         ; $5AA9
    call AnimEd_ExitCtx1_Sprite                   ; $5AAA
    call AnimEd_CoroYield_B                       ; $5AAD
    ld a, $fe                                     ; $5AB0
    call Vram_WriteByteSafe                       ; $5AB2
    set 5, l                                      ; $5AB5
    ld a, $fe                                     ; $5AB7
    call Vram_WriteByteSafe                       ; $5AB9
    res 5, l                                      ; $5ABC
    dec hl                                        ; $5ABE
    ld a, $4c                                     ; $5ABF
    call Vram_WriteByteSafe                       ; $5AC1
    set 5, l                                      ; $5AC4
    ld a, $4d                                     ; $5AC6
    call Vram_WriteByteSafe                       ; $5AC8
    res 5, l                                      ; $5ACB
    dec b                                         ; $5ACD
    call AnimEd_ExitCtx1_Sprite                   ; $5ACE
    call AnimEd_CoroYield_B                       ; $5AD1
    ld a, b                                       ; $5AD4
    and a                                         ; $5AD5
    jr nz, jr_003_5a8b                            ; $5AD6

jr_003_5ad8:
    call AnimEd_ExitCtx1_Sprite                   ; $5AD8
    call AnimEd_CoroYield_B                       ; $5ADB
    jr jr_003_5ad8                                ; $5ADE

; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1_Sprite::
    push bc                                       ; $5AE0
    push hl                                       ; $5AE1
    ld a, $02                                     ; $5AE2
    add b                                         ; $5AE4
    and $07                                       ; $5AE5
    ld c, a                                       ; $5AE7
    ld b, $00                                     ; $5AE8
    ld hl, AnimEd_ExitCtx1_Sprite_PtrTbl5AF8      ; $5AEA
    add hl, bc                                    ; $5AED
    ld a, [hl]                                    ; $5AEE
    ld bc, $0200                                  ; $5AEF
    call Oam_AddMeta_B01_4000                     ; $5AF2
    pop hl                                        ; $5AF5
    pop bc                                        ; $5AF6
    ret                                           ; $5AF7


; C: auto: 8 bytes, word table; referenced by AnimEd_ExitCtx1_Sprite. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx1_Sprite_PtrTbl5AF8::
    dw $4342
    dw $4544
    dw $4645
    dw $4847

; C: exit context 2. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2::
    ld bc, $1e0f                                  ; $5B00

jr_003_5b03:
    call AnimEd_ExitCtx2_Sprite                   ; $5B03
    call AnimEd_CoroYield_B                       ; $5B06
    dec c                                         ; $5B09
    jr nz, jr_003_5b03                            ; $5B0A

    ld hl, $9891                                  ; $5B0C
    ld b, $1e                                     ; $5B0F

jr_003_5b11:
    ld a, $9d                                     ; $5B11
    call Vram_WriteByteSafe                       ; $5B13
    set 5, l                                      ; $5B16
    ld a, $9e                                     ; $5B18
    call AnimEd_ExitCtx2_InRange                  ; $5B1A
    jr nc, jr_003_5b21                            ; $5B1D

    ld a, $9f                                     ; $5B1F

jr_003_5b21:
    call Vram_WriteByteSafe                       ; $5B21
    res 5, l                                      ; $5B24
    dec hl                                        ; $5B26
    ld a, $9c                                     ; $5B27
    call Vram_WriteByteSafe                       ; $5B29
    set 5, l                                      ; $5B2C
    ld a, $49                                     ; $5B2E
    call AnimEd_ExitCtx2_InRange                  ; $5B30
    jr nc, jr_003_5b37                            ; $5B33

    ld a, $4e                                     ; $5B35

jr_003_5b37:
    call Vram_WriteByteSafe                       ; $5B37
    res 5, l                                      ; $5B3A
    inc hl                                        ; $5B3C
    dec b                                         ; $5B3D
    call AnimEd_ExitCtx2_Sprite                   ; $5B3E
    call AnimEd_CoroYield_B                       ; $5B41
    ld a, b                                       ; $5B44
    and a                                         ; $5B45
    jr z, jr_003_5b7e                             ; $5B46

    ld a, $fe                                     ; $5B48
    call Vram_WriteByteSafe                       ; $5B4A
    set 5, l                                      ; $5B4D
    ld a, $fe                                     ; $5B4F
    call AnimEd_ExitCtx2_InRange                  ; $5B51
    jr nc, jr_003_5b58                            ; $5B54

    ld a, $4f                                     ; $5B56

jr_003_5b58:
    call Vram_WriteByteSafe                       ; $5B58
    res 5, l                                      ; $5B5B
    dec hl                                        ; $5B5D
    ld a, $58                                     ; $5B5E
    call Vram_WriteByteSafe                       ; $5B60
    set 5, l                                      ; $5B63
    ld a, $49                                     ; $5B65
    call AnimEd_ExitCtx2_InRange                  ; $5B67
    jr nc, jr_003_5b6e                            ; $5B6A

    ld a, $4e                                     ; $5B6C

jr_003_5b6e:
    call Vram_WriteByteSafe                       ; $5B6E
    res 5, l                                      ; $5B71
    dec b                                         ; $5B73
    call AnimEd_ExitCtx2_Sprite                   ; $5B74
    call AnimEd_CoroYield_B                       ; $5B77
    ld a, b                                       ; $5B7A
    and a                                         ; $5B7B
    jr nz, jr_003_5b11                            ; $5B7C

jr_003_5b7e:
    call AnimEd_ExitCtx2_Sprite                   ; $5B7E
    call AnimEd_CoroYield_B                       ; $5B81
    jr jr_003_5b7e                                ; $5B84

; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_InRange::
    push af                                       ; $5B86
    ld a, l                                       ; $5B87
    and $1f                                       ; $5B88
    cp $03                                        ; $5B8A
    jr c, jr_003_5b95                             ; $5B8C

    cp $11                                        ; $5B8E
    jr nc, jr_003_5b95                            ; $5B90

    pop af                                        ; $5B92
    scf                                           ; $5B93
    ret                                           ; $5B94


jr_003_5b95:
    pop af                                        ; $5B95
    and a                                         ; $5B96
    ret                                           ; $5B97


; C: L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_Sprite::
    push bc                                       ; $5B98
    push hl                                       ; $5B99
    ld a, $02                                     ; $5B9A
    add b                                         ; $5B9C
    and $07                                       ; $5B9D
    ld c, a                                       ; $5B9F
    ld b, $00                                     ; $5BA0
    ld hl, AnimEd_ExitCtx2_Sprite_PtrTbl5BB0      ; $5BA2
    add hl, bc                                    ; $5BA5
    ld a, [hl]                                    ; $5BA6
    ld bc, $020d                                  ; $5BA7
    call Oam_AddMeta_B01_4000                     ; $5BAA
    pop hl                                        ; $5BAD
    pop bc                                        ; $5BAE
    ret                                           ; $5BAF


; C: auto: 8 bytes, word table; referenced by AnimEd_ExitCtx2_Sprite. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_ExitCtx2_Sprite_PtrTbl5BB0::
    dw $4a49
    dw $4c4b
    dw $4d4d
    dw $4f4e

; C: two fixed sprites of the editor frame. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus,
; modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawFrameSprites::
    ld a, $49                                     ; $5BB8
    ld bc, $020d                                  ; $5BBA
    call Oam_AddMeta_B01_4000                     ; $5BBD
    ld a, $42                                     ; $5BC0
    ld bc, $0200                                  ; $5BC2
    call Oam_AddMeta_B01_4000                     ; $5BC5
    ret                                           ; $5BC8


; C: loads the thumbnail tiles of the current entry (far 02:517B) or the blank picture tiles
AnimEd_LoadEntryThumb::
    xor a                                         ; $5BC9
    ld [wPreviewWait], a                          ; $5BCA
    ld a, [wCurEntryValue]                        ; $5BCD
    cp $fe                                        ; $5BD0
    jr nc, jr_003_5c1e                            ; $5BD2

    bit 7, a                                      ; $5BD4
    jr z, jr_003_5bdc                             ; $5BD6

    res 7, a                                      ; $5BD8
    add $1e                                       ; $5BDA

jr_003_5bdc:
    ldh [hFarcallAArg], a                         ; $5BDC
    ld a, BANK(Photo_GetSramAddress_Far)          ; $5BDE
    ld hl, Photo_GetSramAddress_Far               ; $5BE0
    call Far_Call                                 ; $5BE3
    ld hl, $0e00                                  ; $5BE6
    add hl, bc                                    ; $5BE9
    ld de, $91a0                                  ; $5BEA
    ld b, $03                                     ; $5BED

jr_003_5bef:
    push af                                       ; $5BEF
    push bc                                       ; $5BF0
    ld bc, $0040                                  ; $5BF1
    call Vram_CopyFromBank                        ; $5BF4
    ld a, e                                       ; $5BF7
    add $40                                       ; $5BF8
    ld e, a                                       ; $5BFA
    jr nc, jr_003_5bfe                            ; $5BFB

    inc d                                         ; $5BFD

jr_003_5bfe:
    pop bc                                        ; $5BFE
    pop af                                        ; $5BFF
    dec b                                         ; $5C00
    jr nz, jr_003_5bef                            ; $5C01

    ld b, $04                                     ; $5C03

jr_003_5c05:
    push af                                       ; $5C05
    push bc                                       ; $5C06
    ld bc, $0008                                  ; $5C07
    call Vram_CopyFromBank                        ; $5C0A
    ld a, e                                       ; $5C0D
    add $08                                       ; $5C0E
    ld e, a                                       ; $5C10
    jr nc, jr_003_5c14                            ; $5C11

    inc d                                         ; $5C13

jr_003_5c14:
    ld bc, $0008                                  ; $5C14
    add hl, bc                                    ; $5C17
    pop bc                                        ; $5C18
    pop af                                        ; $5C19
    dec b                                         ; $5C1A
    jr nz, jr_003_5c05                            ; $5C1B

    ret                                           ; $5C1D


jr_003_5c1e:
    ld a, BANK(Gfx_0C_5100_Mode12_State0F_ClearAll); $5C1E
    ld hl, Gfx_0C_5100_Mode12_State0F_ClearAll    ; $5C20
    ld de, $9100                                  ; $5C23
    ld bc, $0380                                  ; $5C26
    call Vram_CopyFromBank                        ; $5C29
    ret                                           ; $5C2C


; C: after 5 frames reduces the entry's photo to 64x56 and copies it to VRAM $9100
AnimEd_PreviewTick::
    ld a, [wPreviewWait]                          ; $5C2D
    cp $05                                        ; $5C30
    jr z, jr_003_5c3c                             ; $5C32

    cp $ff                                        ; $5C34
    ret z                                         ; $5C36

    inc a                                         ; $5C37
    ld [wPreviewWait], a                          ; $5C38
    ret                                           ; $5C3B


jr_003_5c3c:
    inc a                                         ; $5C3C
    ld [wPreviewWait], a                          ; $5C3D
    ld a, [wCurEntryValue]                        ; $5C40
    cp $fe                                        ; $5C43
    ret nc                                        ; $5C45

    bit 7, a                                      ; $5C46
    jr z, jr_003_5c4e                             ; $5C48

    res 7, a                                      ; $5C4A
    add $1e                                       ; $5C4C

jr_003_5c4e:
    ldh [hFarcallAArg], a                         ; $5C4E
    ld a, BANK(Photo_GetSramAddress_Far)          ; $5C50
    ld hl, Photo_GetSramAddress_Far               ; $5C52
    call Far_Call                                 ; $5C55
    ld l, a                                       ; $5C58
    push hl                                       ; $5C59
    push bc                                       ; $5C5A
    ld hl, sp+$00                                 ; $5C5B
    ld bc, wPreviewImage                          ; $5C5D
    call Img_ReduceTo64x56                        ; $5C60
    pop bc                                        ; $5C63
    pop hl                                        ; $5C64
    jr nc, jr_003_5c78                            ; $5C65

    xor a                                         ; $5C67
    ld [wPreviewWait], a                          ; $5C68
    ldh a, [hKeysHeldSticky]                      ; $5C6B
    ldh [hKeysHeld], a                            ; $5C6D
    ldh a, [hKeysNewSticky]                       ; $5C6F
    ldh [hKeysNew], a                             ; $5C71
    ldh a, [hKeysRepeatSticky]                    ; $5C73
    ldh [hKeysNewRepeat], a                       ; $5C75
    ret                                           ; $5C77


jr_003_5c78:
    ld a, $00                                     ; $5C78
    ld hl, wPreviewImage                          ; $5C7A
    ld de, $9100                                  ; $5C7D
    ld bc, $0380                                  ; $5C80
    call Vram_CopyFromBank                        ; $5C83
    ret                                           ; $5C86


; C: two digit tiles of the border number
AnimEd_ShowBorderDigits::
    ld a, [wAnimBorder]                           ; $5C87
    call AnimEd_SplitDecimal                      ; $5C8A
    push af                                       ; $5C8D
    ld de, $8b20                                  ; $5C8E
    ld a, c                                       ; $5C91
    call AnimEd_CopyDigitTile                     ; $5C92
    pop af                                        ; $5C95
    call AnimEd_CopyDigitTile                     ; $5C96
    ret                                           ; $5C99


; C: digits of the current entry value or the empty marker
AnimEd_ShowEntryValue::
    ld a, [wCurEntryValue]                        ; $5C9A
    cp $fe                                        ; $5C9D
    jr c, jr_003_5ccc                             ; $5C9F

    ld a, $0c                                     ; $5CA1
    ld hl, Gfx_0C_5FA0_AnimEd_ShowEntryValue      ; $5CA3
    ld de, $8aa0                                  ; $5CA6
    ld bc, $0040                                  ; $5CA9
    call Vram_CopyFromBank                        ; $5CAC
    ld a, BANK(Gfx_0C_4FF0_AnimEd_ShowEntryValue) ; $5CAF
    ld hl, Gfx_0C_4FF0_AnimEd_ShowEntryValue      ; $5CB1
    ld de, $8be0                                  ; $5CB4
    ld bc, $0010                                  ; $5CB7
    call Vram_CopyFromBank                        ; $5CBA
    ld a, BANK(Gfx_0C_4FF0_AnimEd_ShowEntryValue) ; $5CBD
    ld hl, Gfx_0C_4FF0_AnimEd_ShowEntryValue      ; $5CBF
    ld de, $8bf0                                  ; $5CC2
    ld bc, $0010                                  ; $5CC5
    call Vram_CopyFromBank                        ; $5CC8
    ret                                           ; $5CCB


jr_003_5ccc:
    call AnimEd_SplitDecimal                      ; $5CCC
    push af                                       ; $5CCF
    ld de, $8aa0                                  ; $5CD0
    ld a, c                                       ; $5CD3
    call AnimEd_CopyDigitTile                     ; $5CD4
    pop af                                        ; $5CD7
    call AnimEd_CopyDigitTile                     ; $5CD8
    ld a, [wCurEntryValue]                        ; $5CDB
    bit 7, a                                      ; $5CDE
    jr nz, jr_003_5cf1                            ; $5CE0

    ld a, BANK(Gfx_0C_5B40_AnimEd_ShowEntryValue) ; $5CE2
    ld hl, Gfx_0C_5B40_AnimEd_ShowEntryValue      ; $5CE4
    ld de, $8be0                                  ; $5CE7
    ld bc, $0020                                  ; $5CEA
    call Vram_CopyFromBank                        ; $5CED
    ret                                           ; $5CF0


jr_003_5cf1:
    ld a, BANK(Gfx_0C_5B60_AnimEd_ShowEntryValue) ; $5CF1
    ld hl, Gfx_0C_5B60_AnimEd_ShowEntryValue      ; $5CF3
    ld de, $8be0                                  ; $5CF6
    ld bc, $0020                                  ; $5CF9
    call Vram_CopyFromBank                        ; $5CFC
    ret                                           ; $5CFF


; C: digits of the entry index
AnimEd_ShowEntryIndex::
    ld a, [wCurEntryIndex]                        ; $5D00
    call AnimEd_SplitDecimal                      ; $5D03
    push af                                       ; $5D06
    ld de, $8ae0                                  ; $5D07
    ld a, c                                       ; $5D0A
    call AnimEd_CopyDigitTile                     ; $5D0B
    pop af                                        ; $5D0E
    call AnimEd_CopyDigitTile                     ; $5D0F
    ret                                           ; $5D12


; C: loop on / off indicator tiles
AnimEd_ShowLoopFlag::
    ld a, [wAnimLoopFlag]                         ; $5D13
    and a                                         ; $5D16
    jr nz, jr_003_5d36                            ; $5D17

    ld a, BANK(Gfx_0C_5C80_AnimEd_ShowLoopFlag)   ; $5D19
    ld hl, Gfx_0C_5C80_AnimEd_ShowLoopFlag        ; $5D1B
    ld de, $97c0                                  ; $5D1E
    ld bc, $0020                                  ; $5D21
    call Vram_CopyFromBank                        ; $5D24
    ld a, BANK(Gfx_0C_5770_AnimEd_ShowLoopFlag)   ; $5D27
    ld hl, Gfx_0C_5770_AnimEd_ShowLoopFlag        ; $5D29
    ld de, $9770                                  ; $5D2C
    ld bc, $0010                                  ; $5D2F
    call Vram_CopyFromBank                        ; $5D32
    ret                                           ; $5D35


jr_003_5d36:
    ld a, BANK(Gfx_0C_5CA0_AnimEd_Ctx0_Decor)     ; $5D36
    ld hl, Gfx_0C_5CA0_AnimEd_Ctx0_Decor          ; $5D38
    ld de, $97c0                                  ; $5D3B
    ld bc, $0020                                  ; $5D3E
    call Vram_CopyFromBank                        ; $5D41
    ld a, BANK(Gfx_0C_5CC0_AnimEd_Ctx0_Decor)     ; $5D44
    ld hl, Gfx_0C_5CC0_AnimEd_Ctx0_Decor          ; $5D46
    ld de, $9770                                  ; $5D49
    ld bc, $0010                                  ; $5D4C
    call Vram_CopyFromBank                        ; $5D4F
    ret                                           ; $5D52


; C: digits of the animation speed
AnimEd_ShowSpeed::
    ld a, [wAnimSpeed]                            ; $5D53
    cpl                                           ; $5D56
    add $63                                       ; $5D57
    call AnimEd_SplitDecimal                      ; $5D59
    push af                                       ; $5D5C
    ld de, $8b60                                  ; $5D5D
    ld a, c                                       ; $5D60
    call AnimEd_CopyDigitTile                     ; $5D61
    pop af                                        ; $5D64
    call AnimEd_CopyDigitTile                     ; $5D65
    ret                                           ; $5D68


; C: empties the list ($FE)
AnimEd_ClearAll::
    ld hl, wAnimList                              ; $5D69
    ld a, $fe                                     ; $5D6C
    ld b, $2f                                     ; $5D6E

jr_003_5d70:
    ld [hl+], a                                   ; $5D70
    dec b                                         ; $5D71
    jr nz, jr_003_5d70                            ; $5D72

    xor a                                         ; $5D74
    ld [hl], a                                    ; $5D75
    ld hl, wAnimTimingGuardLo                     ; $5D76
    ld a, $ff                                     ; $5D79
    ld [hl+], a                                   ; $5D7B
    xor a                                         ; $5D7C
    ld b, $2f                                     ; $5D7D

jr_003_5d7f:
    ld [hl+], a                                   ; $5D7F
    dec b                                         ; $5D80
    jr nz, jr_003_5d7f                            ; $5D81

    ld a, $ff                                     ; $5D83
    ld [hl], a                                    ; $5D85
    ld a, $09                                     ; $5D86
    ld [wAnimSpeed], a                            ; $5D88
    xor a                                         ; $5D8B
    ld [wAnimBorder], a                           ; $5D8C
    ld hl, wDirtyFlag                             ; $5D8F
    inc [hl]                                      ; $5D92
    ret                                           ; $5D93


; C: resets the editor variables and loads the first entry
AnimEd_InitEditor::
    xor a                                         ; $5D94
    ld [wEditorRangeMode], a                      ; $5D95
    ld [wCurEntryValue], a                        ; $5D98
    ld [wCurEntryIndex], a                        ; $5D9B
    ld [wSpriteAnimTick + $2], a                  ; $5D9E
    ld [wSpriteAnimFrame + $2], a                 ; $5DA1
    ld [wSpriteAnimTick + $3], a                  ; $5DA4
    ld [wSpriteAnimFrame + $3], a                 ; $5DA7
    ld [wSpriteAnimTick + $5], a                  ; $5DAA
    ld [wSpriteAnimFrame + $5], a                 ; $5DAD
    ld [wPreviewWait], a                          ; $5DB0
    ld hl, wSparkLife                             ; $5DB3
    ld b, $10                                     ; $5DB6

jr_003_5db8:
    ld [hl+], a                                   ; $5DB8
    dec b                                         ; $5DB9
    jr nz, jr_003_5db8                            ; $5DBA

    ld a, [wCurEntryIndex]                        ; $5DBC
    ld c, a                                       ; $5DBF
    ld b, $00                                     ; $5DC0
    ld hl, wAnimList                              ; $5DC2
    add hl, bc                                    ; $5DC5
    ld a, [hl]                                    ; $5DC6
    ld [wCurEntryValue], a                        ; $5DC7
    call AnimEd_LoadMenuTiles                     ; $5DCA
    ret                                           ; $5DCD


; C: tiles for the highlighted tool menu entry. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_LoadMenuTiles::
    ld a, [wEditorMenuOption]                     ; $5DCE
    sla a                                         ; $5DD1
    ld c, a                                       ; $5DD3
    sla a                                         ; $5DD4
    add c                                         ; $5DD6
    ld c, a                                       ; $5DD7
    ld b, $00                                     ; $5DD8
    ld hl, AnimEd_LoadMenuTiles_Tbl5DF1           ; $5DDA
    add hl, bc                                    ; $5DDD
    ld c, [hl]                                    ; $5DDE
    inc hl                                        ; $5DDF
    ld b, [hl]                                    ; $5DE0
    inc hl                                        ; $5DE1
    push bc                                       ; $5DE2
    ld e, [hl]                                    ; $5DE3
    inc hl                                        ; $5DE4
    ld d, [hl]                                    ; $5DE5
    inc hl                                        ; $5DE6
    ld c, [hl]                                    ; $5DE7
    inc hl                                        ; $5DE8
    ld b, [hl]                                    ; $5DE9
    pop hl                                        ; $5DEA
    ld a, $0c                                     ; $5DEB
    call Vram_CopyFromBank                        ; $5DED
    ret                                           ; $5DF0


; C: 5 records of 6 bytes {src lo, src hi, dst lo, dst hi, len lo, len hi}, bank $0C: 5A40 -> $8D50, 5AC0 -> $8DD0,
; 6100 -> $8E50, 5B80 -> $8ED0, 5C00 -> $8F50, 0x80 bytes each; AnimEd_LoadMenuTiles (03:5DCE) selects the record with
; $D719
AnimEd_LoadMenuTiles_Tbl5DF1::
    db $40, $5a, $50, $8d, $80, $00
    db $c0, $5a, $d0, $8d, $80, $00
    db $00, $61, $50, $8e, $80, $00
    db $80, $5b, $d0, $8e, $80, $00
    db $00, $5c, $50, $8f, $80, $00

; C: zeroes the 16 spark lifetimes
AnimEd_ClearSparks::
    xor a                                         ; $5E0F
    ld hl, wSparkLife                             ; $5E10
    ld b, $10                                     ; $5E13

jr_003_5e15:
    ld [hl+], a                                   ; $5E15
    dec b                                         ; $5E16
    jr nz, jr_003_5e15                            ; $5E17

    ret                                           ; $5E19


; C: starts a spark sprite at the cursor (sound $36)
AnimEd_SpawnSpark::
    push af                                       ; $5E1A
    ld a, SFX1_PAGE_STEP                          ; $5E1B
    call Snd_Sfx1                                 ; $5E1D
    pop af                                        ; $5E20
    ld a, [wSparkRingIdx]                         ; $5E21
    inc a                                         ; $5E24
    and $0f                                       ; $5E25
    ld [wSparkRingIdx], a                         ; $5E27
    ld e, a                                       ; $5E2A
    ld d, $00                                     ; $5E2B
    ld a, $20                                     ; $5E2D
    ld hl, wSparkLife                             ; $5E2F
    add hl, de                                    ; $5E32
    ld [hl], a                                    ; $5E33
    sla e                                         ; $5E34
    xor a                                         ; $5E36
    ld hl, wSparkX                                ; $5E37
    add hl, de                                    ; $5E3A
    ld [hl], a                                    ; $5E3B
    ld hl, wSparkY                                ; $5E3C
    add hl, de                                    ; $5E3F
    ld [hl], a                                    ; $5E40
    ld hl, wSparkVx                               ; $5E41
    add hl, de                                    ; $5E44
    ld [hl+], a                                   ; $5E45
    ld [hl], a                                    ; $5E46
    ld hl, wSparkVy                               ; $5E47
    add hl, de                                    ; $5E4A
    ld [hl+], a                                   ; $5E4B
    ld [hl], a                                    ; $5E4C
    ld bc, $9404                                  ; $5E4D
    ld a, [wCurEntryValue]                        ; $5E50
    bit 7, a                                      ; $5E53
    jr nz, jr_003_5e59                            ; $5E55

    ld c, $11                                     ; $5E57

jr_003_5e59:
    and $7f                                       ; $5E59
    cp $7e                                        ; $5E5B
    jr nc, jr_003_5e66                            ; $5E5D

    sla a                                         ; $5E5F
    sla a                                         ; $5E61
    add $10                                       ; $5E63
    ld b, a                                       ; $5E65

jr_003_5e66:
    ld hl, wSparkX + $1                           ; $5E66
    add hl, de                                    ; $5E69
    ld [hl], b                                    ; $5E6A
    ld hl, wSparkY + $1                           ; $5E6B
    add hl, de                                    ; $5E6E
    ld [hl], c                                    ; $5E6F
    ld a, [wCurEntryIndex]                        ; $5E70
    and $7f                                       ; $5E73
    inc a                                         ; $5E75
    push af                                       ; $5E76
    and $0f                                       ; $5E77
    swap a                                        ; $5E79
    srl a                                         ; $5E7B
    add $10                                       ; $5E7D
    ld hl, wSparkX + $1                           ; $5E7F
    add hl, de                                    ; $5E82
    sub [hl]                                      ; $5E83
    push af                                       ; $5E84
    ld hl, wSparkVx                               ; $5E85
    add hl, de                                    ; $5E88
    pop af                                        ; $5E89
    rr a                                          ; $5E8A
    rr [hl]                                       ; $5E8C
    sra a                                         ; $5E8E
    rr [hl]                                       ; $5E90
    sra a                                         ; $5E92
    rr [hl]                                       ; $5E94
    sra a                                         ; $5E96
    rr [hl]                                       ; $5E98
    sra a                                         ; $5E9A
    rr [hl]                                       ; $5E9C
    inc hl                                        ; $5E9E
    ld [hl], a                                    ; $5E9F
    pop af                                        ; $5EA0
    and $30                                       ; $5EA1
    add $60                                       ; $5EA3
    ld hl, wSparkY + $1                           ; $5EA5
    add hl, de                                    ; $5EA8
    sub [hl]                                      ; $5EA9
    push af                                       ; $5EAA
    ld hl, wSparkVy                               ; $5EAB
    add hl, de                                    ; $5EAE
    pop af                                        ; $5EAF
    rr a                                          ; $5EB0
    rr [hl]                                       ; $5EB2
    sra a                                         ; $5EB4
    rr [hl]                                       ; $5EB6
    sra a                                         ; $5EB8
    rr [hl]                                       ; $5EBA
    sra a                                         ; $5EBC
    rr [hl]                                       ; $5EBE
    sra a                                         ; $5EC0
    rr [hl]                                       ; $5EC2
    inc hl                                        ; $5EC4
    ld [hl], a                                    ; $5EC5
    ret                                           ; $5EC6


; C: moves the sparks
AnimEd_UpdateSparks::
    ld de, $000f                                  ; $5EC7

jr_003_5eca:
    push de                                       ; $5ECA
    call AnimEd_DrawSpark                         ; $5ECB
    pop de                                        ; $5ECE
    dec e                                         ; $5ECF
    bit 7, e                                      ; $5ED0
    jr z, jr_003_5eca                             ; $5ED2

    ld de, wSparkX                                ; $5ED4
    ld hl, wSparkVx                               ; $5ED7
    ld b, $20                                     ; $5EDA

jr_003_5edc:
    ld a, [de]                                    ; $5EDC
    add [hl]                                      ; $5EDD
    ld [de], a                                    ; $5EDE
    inc de                                        ; $5EDF
    inc hl                                        ; $5EE0
    ld a, [de]                                    ; $5EE1
    adc [hl]                                      ; $5EE2
    ld [de], a                                    ; $5EE3
    inc de                                        ; $5EE4
    inc hl                                        ; $5EE5
    dec b                                         ; $5EE6
    jr nz, jr_003_5edc                            ; $5EE7

    ret                                           ; $5EE9


; C: L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpark::
    ld hl, wSparkLife                             ; $5EEA
    add hl, de                                    ; $5EED
    ld a, [hl]                                    ; $5EEE
    and a                                         ; $5EEF
    ret z                                         ; $5EF0

    dec a                                         ; $5EF1
    ld [hl], a                                    ; $5EF2
    push af                                       ; $5EF3
    sla e                                         ; $5EF4
    ld hl, wSparkX + $1                           ; $5EF6
    add hl, de                                    ; $5EF9
    ld b, [hl]                                    ; $5EFA
    ld hl, wSparkY + $1                           ; $5EFB
    add hl, de                                    ; $5EFE
    ld c, [hl]                                    ; $5EFF
    pop af                                        ; $5F00
    push bc                                       ; $5F01
    srl a                                         ; $5F02
    ld e, a                                       ; $5F04
    ld d, $00                                     ; $5F05
    ld hl, AnimEd_DrawSpark_Tbl5F1B               ; $5F07
    add hl, de                                    ; $5F0A
    ld a, c                                       ; $5F0B
    add [hl]                                      ; $5F0C
    ld c, a                                       ; $5F0D
    dec b                                         ; $5F0E
    ld a, $7b                                     ; $5F0F
    call Oam_AddMeta_B01_4000                     ; $5F11
    pop bc                                        ; $5F14
    ld a, $7c                                     ; $5F15
    call Oam_AddMeta_B01_4000                     ; $5F17
    ret                                           ; $5F1A


; C: auto: 16 bytes, bytes; referenced by AnimEd_DrawSpark. L3 pass 2026-10-26: read in BGB in 20 replay(s) of the
; organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_DrawSpark_Tbl5F1B::
    db $00, $fc, $f9, $f6, $f4, $f2, $f1, $f0, $f0, $f1, $f2, $f4, $f6, $f9, $fc, $00

; C: copies a digit glyph from bank 0C to VRAM. L3 pass 2026-10-26: executed in BGB in 22 replay(s) of the organic
; corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_CopyDigitTile::
    swap a                                        ; $5F2B
    ld c, a                                       ; $5F2D
    ld b, $00                                     ; $5F2E
    sla c                                         ; $5F30
    rl b                                          ; $5F32
    ld hl, $5e60                                  ; $5F34
    add hl, bc                                    ; $5F37
    ld a, $0c                                     ; $5F38
    ld bc, $0020                                  ; $5F3A
    call Vram_CopyFromBank                        ; $5F3D
    ret                                           ; $5F40


; C: A+1 -> C = tens
AnimEd_SplitDecimal::
    inc a                                         ; $5F41
    res 7, a                                      ; $5F42
    ld c, $00                                     ; $5F44

jr_003_5f46:
    cp $0a                                        ; $5F46
    ret c                                         ; $5F48

    sub $0a                                       ; $5F49
    inc c                                         ; $5F4B
    jr jr_003_5f46                                ; $5F4C

; C: moves the window up with the table 00:2FE5 and runs the contexts. L3 pass 2026-10-26: executed in BGB in 6
; replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideIn::
    push af                                       ; $5F4E
    ld a, SFX1_PANEL_OPEN                         ; $5F4F
    call Snd_Sfx1                                 ; $5F51
    pop af                                        ; $5F54
    ld hl, Slide_WyDeltaTbl                       ; $5F55
    ld b, $24                                     ; $5F58

jr_003_5f5a:
    push bc                                       ; $5F5A
    push de                                       ; $5F5B
    push hl                                       ; $5F5C
    ldh a, [hWyShadow]                            ; $5F5D
    add [hl]                                      ; $5F5F
    ldh [hWyShadow], a                            ; $5F60
    ld hl, AnimEd_WindowSlideIn_Resume            ; $5F62
    push hl                                       ; $5F65
    ld h, d                                       ; $5F66
    ld l, e                                       ; $5F67
    jp hl                                         ; $5F68


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideIn_Resume::
    call Oam_HideUnused                           ; $5F69
    rst Rst08_WaitVBlank                          ; $5F6C
    pop hl                                        ; $5F6D
    pop de                                        ; $5F6E
    pop bc                                        ; $5F6F
    inc hl                                        ; $5F70
    dec b                                         ; $5F71
    jr nz, jr_003_5f5a                            ; $5F72

    ld h, d                                       ; $5F74
    ld l, e                                       ; $5F75
    jp hl                                         ; $5F76


; C: reverse slide. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 12
; (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideOut::
    push af                                       ; $5F77
    ld a, SFX1_PANEL_CLOSE                        ; $5F78
    call Snd_Sfx1                                 ; $5F7A
    pop af                                        ; $5F7D
    ld hl, Slide_WyDeltaTbl                       ; $5F7E
    ld b, $24                                     ; $5F81

jr_003_5f83:
    push bc                                       ; $5F83
    push de                                       ; $5F84
    push hl                                       ; $5F85
    ldh a, [hWyShadow]                            ; $5F86
    sub [hl]                                      ; $5F88
    ldh [hWyShadow], a                            ; $5F89
    ld hl, AnimEd_WindowSlideOut_Resume           ; $5F8B
    push hl                                       ; $5F8E
    ld h, d                                       ; $5F8F
    ld l, e                                       ; $5F90
    jp hl                                         ; $5F91


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 12 (tcrf_check/assets/l3_names/)
AnimEd_WindowSlideOut_Resume::
    call Oam_HideUnused                           ; $5F92
    rst Rst08_WaitVBlank                          ; $5F95
    pop hl                                        ; $5F96
    pop de                                        ; $5F97
    pop bc                                        ; $5F98
    inc hl                                        ; $5F99
    dec b                                         ; $5F9A
    jr nz, jr_003_5f83                            ; $5F9B

    ld h, d                                       ; $5F9D
    ld l, e                                       ; $5F9E
    jp hl                                         ; $5F9F


; C: plays the show
Mode13_AnimationPlayer::
    ld a, [wState]                                ; $5FA0
    rst Rst18_JumpTable                           ; $5FA3

; C: 9 states, rst $18 table of mode $13
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

; C: loads the player graphics (bank 17)
Mode13_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5FB6
    ldh [hLcdcShadow], a                          ; $5FB8
    ld a, $e4                                     ; $5FBA
    ld [wPaletteTarget], a                        ; $5FBC
    ld [wPaletteTarget + $1], a                   ; $5FBF
    ld [wPaletteTarget + $2], a                   ; $5FC2
    xor a                                         ; $5FC5
    ldh [hScxShadow], a                           ; $5FC6
    ldh [hScyShadow], a                           ; $5FC8
    ld a, BANK(Gfx_17_6800_Mode13_State00_Init)   ; $5FCA
    ld hl, Gfx_17_6800_Mode13_State00_Init        ; $5FCC
    ld de, $9000                                  ; $5FCF
    ld bc, $0800                                  ; $5FD2
    call Mem_CopyFromBank                         ; $5FD5
    ld a, BANK(Gfx_17_7000_Mode13_State00_Init)   ; $5FD8
    ld hl, Gfx_17_7000_Mode13_State00_Init        ; $5FDA
    ld de, $8800                                  ; $5FDD
    ld bc, $0800                                  ; $5FE0
    call Mem_CopyFromBank                         ; $5FE3
    ld a, BANK(Gfx_17_7800_Mode13_State00_Init)   ; $5FE6
    ld hl, Gfx_17_7800_Mode13_State00_Init        ; $5FE8
    ld de, $8000                                  ; $5FEB
    ld bc, $0140                                  ; $5FEE
    call Mem_CopyFromBank                         ; $5FF1
    ld a, BANK(Map_23_48C0_Mode13_State00_Init)   ; $5FF4
    ld hl, Map_23_48C0_Mode13_State00_Init        ; $5FF6
    ld de, $9800                                  ; $5FF9
    ld bc, $0240                                  ; $5FFC
    call Mem_CopyFromBank                         ; $5FFF
    ld a, $60                                     ; $6002
    ldh [hLycShadowSplit1], a                     ; $6004
    ldh [hSplit2Line], a                          ; $6006
    ld hl, hStatShadow                            ; $6008
    set 6, [hl]                                   ; $600B
    ld hl, rIE                                    ; $600D
    set 1, [hl]                                   ; $6010
    ld a, $01                                     ; $6012
    ldh [hStatHandlerIndex], a                    ; $6014
    call Oam_ClearShadow                          ; $6016
    call Pal_AllWhite                             ; $6019
    call Lcd_On                                   ; $601C
    ld a, [wPlayerMusic]                          ; $601F
    call Player_ShowMusicNumber                   ; $6022
    ld a, [wPlayerMusic]                          ; $6025
    ld hl, Mode13_State00_Init_Tbl61FD            ; $6028
    call Snd_PlayFromList                         ; $602B
    call Pal_FadeIn                               ; $602E
    ld a, $16                                     ; $6031
    ldh [hKeyRepeatDelay], a                      ; $6033
    ld a, $08                                     ; $6035
    ldh [hKeyRepeatPeriod], a                     ; $6037
    ld a, STATE_13_MUSIC_SELECT                   ; $6039
    ld [wState], a                                ; $603B
    ret                                           ; $603E


; C: Select cycles the music (0..31); the list is 03:61FD, its n-th entry = BGM n (I: the jofamo article calls the 4th
; entry, song $13, 'BGM 04'); only the international ROM requests song $13 outside this screen and the hot-spot picker
; (RUN title, BGB, README 16.27)
Mode13_State01_MusicSelect::
    ldh a, [hKeysNewRepeat]                       ; $603F
    bit PADB_SELECT, a                            ; $6041
    jr z, jr_003_6062                             ; $6043

    push af                                       ; $6045
    ld a, SFX4_MUSIC_SELECT                       ; $6046
    call Snd_Sfx4                                 ; $6048
    pop af                                        ; $604B
    ld a, [wPlayerMusic]                          ; $604C
    inc a                                         ; $604F
    and $1f                                       ; $6050
    ld [wPlayerMusic], a                          ; $6052
    call Player_ShowMusicNumber                   ; $6055
    ld a, [wPlayerMusic]                          ; $6058
    ld hl, Mode13_State00_Init_Tbl61FD            ; $605B
    call Snd_PlayFromList                         ; $605E
    ret                                           ; $6061


jr_003_6062:
    ldh a, [hKeysNew]                             ; $6062
    and PADF_A | PADF_B                           ; $6064
    ret z                                         ; $6066

    ld [wAbResult], a                             ; $6067
    push af                                       ; $606A
    bit 0, a                                      ; $606B
    ld a, SFX1_KEY_A                              ; $606D
    call nz, Snd_Sfx1                             ; $606F
    pop af                                        ; $6072
    push af                                       ; $6073
    bit 1, a                                      ; $6074
    ld a, SFX1_KEY_B                              ; $6076
    call nz, Snd_Sfx1                             ; $6078
    pop af                                        ; $607B
    ld a, $0b                                     ; $607C
    ldh [hKeyRepeatDelay], a                      ; $607E
    ld a, $04                                     ; $6080
    ldh [hKeyRepeatPeriod], a                     ; $6082
    ld hl, wState                                 ; $6084
    inc [hl]                                      ; $6087
    ret                                           ; $6088


; C: two digit tiles of the music number. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Player_ShowMusicNumber::
    inc a                                         ; $6089
    ld c, $00                                     ; $608A

jr_003_608c:
    cp $0a                                        ; $608C
    jr c, jr_003_6095                             ; $608E

    sub $0a                                       ; $6090
    inc c                                         ; $6092
    jr jr_003_608c                                ; $6093

jr_003_6095:
    ld de, $8100                                  ; $6095
    push af                                       ; $6098
    ld a, c                                       ; $6099
    call Player_CopyDigitTile                     ; $609A
    pop af                                        ; $609D

; C: copies a digit glyph from bank 17 to VRAM. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Player_CopyDigitTile::
    swap a                                        ; $609E
    ld c, a                                       ; $60A0
    ld b, $00                                     ; $60A1
    sla c                                         ; $60A3
    rl b                                          ; $60A5
    ld hl, $7900                                  ; $60A7
    add hl, bc                                    ; $60AA
    ld a, $17                                     ; $60AB
    ld bc, $0020                                  ; $60AD
    call Vram_CopyFromBank                        ; $60B0
    ret                                           ; $60B3


; C: B returns to the show menu (mode 0B); A shows the start banner and fades out
Mode13_State02_Start::
    ld a, [wAbResult]                             ; $60B4
    bit 0, a                                      ; $60B7
    jr nz, jr_003_60d6                            ; $60B9

    call Pal_FadeOut                              ; $60BB
    call Lcd_Off                                  ; $60BE
    ld hl, hStatShadow                            ; $60C1
    res 6, [hl]                                   ; $60C4
    ld hl, rIE                                    ; $60C6
    res 1, [hl]                                   ; $60C9
    ld a, MODE_SHOW_MENU                          ; $60CB
    ld [wMode], a                                 ; $60CD
    ld a, STATE_0B_INIT                           ; $60D0
    ld [wState], a                                ; $60D2
    ret                                           ; $60D5


jr_003_60d6:
    ld a, BANK(Map_23_4B00_Mode13_State02_Start)  ; $60D6
    ld hl, Map_23_4B00_Mode13_State02_Start       ; $60D8
    ld de, $9920                                  ; $60DB
    ld bc, $0060                                  ; $60DE
    call Vram_CopyFromBank                        ; $60E1
    ld bc, $001d                                  ; $60E4
    call Wait_Frames                              ; $60E7
    ld a, BANK(Map_23_49E0_Mode13_State02_Start)  ; $60EA
    ld hl, Map_23_49E0_Mode13_State02_Start       ; $60EC
    ld de, $9920                                  ; $60EF
    ld bc, $0060                                  ; $60F2
    call Vram_CopyFromBank                        ; $60F5
    ld bc, $001e                                  ; $60F8
    call Wait_Frames                              ; $60FB
    call Pal_FadeOut                              ; $60FE
    push af                                       ; $6101
    ld a, MUSIC_STOP                              ; $6102
    call Snd_Music                                ; $6104
    pop af                                        ; $6107
    call Lcd_Off                                  ; $6108
    ld hl, hStatShadow                            ; $610B
    res 6, [hl]                                   ; $610E
    ld hl, rIE                                    ; $6110
    res 1, [hl]                                   ; $6113
    ld hl, wState                                 ; $6115
    inc [hl]                                      ; $6118
    ret                                           ; $6119


; C: loads the animation list (far 02:4EE8)
Mode13_State03_PlayPrepare::
    ldh [hFarcallAArg], a                         ; $611A
    ld a, BANK(Settings_LoadAnimTranslated_Far)   ; $611C
    ld hl, Settings_LoadAnimTranslated_Far        ; $611E
    call Far_Call                                 ; $6121
    xor a                                         ; $6124
    ld [wPlayTick], a                             ; $6125
    ld [wPlayLoopCount], a                        ; $6128
    ld [wPlayDone], a                             ; $612B
    ld hl, wAnimList                              ; $612E
    ld b, $2f                                     ; $6131

jr_003_6133:
    ld a, [hl+]                                   ; $6133
    cp $fe                                        ; $6134
    jr c, jr_003_6141                             ; $6136

    dec b                                         ; $6138
    jr nz, jr_003_6133                            ; $6139

    ld a, STATE_13_END_MESSAGE_SETUP              ; $613B
    ld [wState], a                                ; $613D
    ret                                           ; $6140


jr_003_6141:
    ld [wPlayEntry], a                            ; $6141
    ld a, $2f                                     ; $6144
    sub b                                         ; $6146
    ld [wSpriteAnimTick + $a], a                  ; $6147
    ld c, a                                       ; $614A
    ld b, $00                                     ; $614B
    ld hl, wAnimTiming                            ; $614D
    add hl, bc                                    ; $6150
    bit 7, [hl]                                   ; $6151
    jr z, jr_003_6160                             ; $6153

    ld [wPlayLoopStart], a                        ; $6155
    ld a, $01                                     ; $6158
    ld [wPlayLoopCount], a                        ; $615A
    xor a                                         ; $615D
    jr jr_003_6162                                ; $615E

jr_003_6160:
    ld a, $01                                     ; $6160

jr_003_6162:
    ld [wPlayFlags], a                            ; $6162
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6165
    ldh [hLcdcShadow], a                          ; $6167
    ld a, $e4                                     ; $6169
    ld [wPaletteTarget], a                        ; $616B
    ld [wPaletteTarget + $1], a                   ; $616E
    ld [wPaletteTarget + $2], a                   ; $6171
    ld a, $10                                     ; $6174
    ldh [hScxShadow], a                           ; $6176
    ldh [hScyShadow], a                           ; $6178
    xor a                                         ; $617A
    ld [wPlayerPause], a                          ; $617B
    ld a, BANK(Map_24_7C20_Mode12_State11_TestStart); $617E
    ld hl, Map_24_7C20_Mode12_State11_TestStart   ; $6180
    ld de, $9800                                  ; $6183
    ld bc, $0400                                  ; $6186
    call Mem_CopyFromBank                         ; $6189
    ld hl, $8000                                  ; $618C
    ld bc, $0500                                  ; $618F
    ld de, $ffff                                  ; $6192
    call Mem_FillWords                            ; $6195
    ld hl, $8800                                  ; $6198
    ld bc, $0100                                  ; $619B
    ld de, $ffff                                  ; $619E
    call Mem_FillWords                            ; $61A1
    ld hl, $9000                                  ; $61A4
    ld bc, $0800                                  ; $61A7
    ld de, $ffff                                  ; $61AA
    call Mem_FillWords                            ; $61AD
    ld a, [wAnimBorder]                           ; $61B0
    ld [wBorderNumber], a                         ; $61B3
    ldh [hFarcallAArg], a                         ; $61B6
    ld a, BANK(Border_LoadMap_LcdOff)             ; $61B8
    ld hl, Border_LoadMap_LcdOff                  ; $61BA
    call Far_Call                                 ; $61BD
    ld a, $54                                     ; $61C0
    ldh [hLycShadowSplit1], a                     ; $61C2
    ldh [hSplit2Line], a                          ; $61C4
    ld hl, hStatShadow                            ; $61C6
    set 6, [hl]                                   ; $61C9
    ld hl, rIE                                    ; $61CB
    set 1, [hl]                                   ; $61CE
    ld a, $01                                     ; $61D0
    ldh [hStatHandlerIndex], a                    ; $61D2
    call Oam_ClearShadow                          ; $61D4
    call Pal_AllWhite                             ; $61D7
    call Lcd_On                                   ; $61DA
    call Pal_FadeIn                               ; $61DD
    ld bc, $0050                                  ; $61E0
    call Wait_Frames                              ; $61E3
    ld a, [wPlayerMusic]                          ; $61E6
    ld hl, Mode13_State00_Init_Tbl61FD            ; $61E9
    call Snd_PlayFromList                         ; $61EC
    ld bc, $000a                                  ; $61EF
    call Wait_Frames                              ; $61F2
    call AnimEd_LoadEntryPhoto                    ; $61F5
    ld hl, wState                                 ; $61F8
    inc [hl]                                      ; $61FB
    ret                                           ; $61FC


; C: auto: 64 bytes, bytes; referenced by Mode13_State00_Init, Mode13_State01_MusicSelect, Mode13_State03_PlayPrepare.
; L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 13)
Mode13_State00_Init_Tbl61FD::
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
    ld a, [wPlayDone]                             ; $623D
    and a                                         ; $6240
    jp nz, Mode13_State04_PlayRun_Keys            ; $6241

    ld a, [wPlayerPause]                          ; $6244
    and a                                         ; $6247
    jr nz, Mode13_State04_PlayRun_Keys            ; $6248

    ld hl, wPlayTick                              ; $624A
    ld a, [wAnimSpeed]                            ; $624D
    sub [hl]                                      ; $6250
    jr nz, jr_003_62c4                            ; $6251

    ld [hl], a                                    ; $6253
    ld b, $2f                                     ; $6254

jr_003_6256:
    ld a, [wSpriteAnimTick + $a]                  ; $6256
    ld c, a                                       ; $6259
    ld b, $00                                     ; $625A
    ld hl, wAnimTiming                            ; $625C
    add hl, bc                                    ; $625F
    bit 6, [hl]                                   ; $6260
    jr z, jr_003_627b                             ; $6262

    ld a, [hl]                                    ; $6264
    and $3f                                       ; $6265
    ld hl, wPlayLoopCount                         ; $6267
    cp [hl]                                       ; $626A
    jr z, jr_003_6273                             ; $626B

    inc [hl]                                      ; $626D
    ld a, [wPlayLoopStart]                        ; $626E
    jr jr_003_627c                                ; $6271

jr_003_6273:
    ld hl, wPlayFlags                             ; $6273
    set 0, [hl]                                   ; $6276
    ld a, [wSpriteAnimTick + $a]                  ; $6278

jr_003_627b:
    inc a                                         ; $627B

jr_003_627c:
    cp $2f                                        ; $627C
    jr nz, jr_003_628c                            ; $627E

    ld a, [wAnimLoopFlag]                         ; $6280
    and a                                         ; $6283
    jr nz, jr_003_628b                            ; $6284

    ld hl, wPlayDone                              ; $6286
    inc [hl]                                      ; $6289
    ret                                           ; $628A


jr_003_628b:
    xor a                                         ; $628B

jr_003_628c:
    ld [wSpriteAnimTick + $a], a                  ; $628C
    ld c, a                                       ; $628F
    ld b, $00                                     ; $6290
    ld hl, wAnimTiming                            ; $6292
    add hl, bc                                    ; $6295
    bit 7, [hl]                                   ; $6296
    jr z, jr_003_62ab                             ; $6298

    ld hl, wPlayFlags                             ; $629A
    bit 0, [hl]                                   ; $629D
    jr z, jr_003_62ab                             ; $629F

    res 0, [hl]                                   ; $62A1
    ld [wPlayLoopStart], a                        ; $62A3
    ld a, $01                                     ; $62A6
    ld [wPlayLoopCount], a                        ; $62A8

jr_003_62ab:
    ld hl, wAnimList                              ; $62AB
    add hl, bc                                    ; $62AE
    ld a, [hl]                                    ; $62AF
    ld [wPlayEntry], a                            ; $62B0
    cp $fe                                        ; $62B3
    jr c, jr_003_62bf                             ; $62B5

    dec b                                         ; $62B7
    jr nz, jr_003_6256                            ; $62B8

    ld hl, wPlayDone                              ; $62BA
    inc [hl]                                      ; $62BD
    ret                                           ; $62BE


jr_003_62bf:
    call AnimEd_LoadEntryPhoto                    ; $62BF
    jr Mode13_State04_PlayRun_Keys                ; $62C2

jr_003_62c4:
    ld hl, wPlayTick                              ; $62C4
    inc [hl]                                      ; $62C7

; C: key poll of the playback: bit 1 of $FFA8 (B) goes to the next state, bit 3 (Start) toggles the pause flag $D7BD
; (branch target; code read 2026-10-19)
Mode13_State04_PlayRun_Keys::
    ldh a, [hKeysNewSticky]                       ; $62C8
    bit PADB_B, a                                 ; $62CA
    jr z, jr_003_62d3                             ; $62CC

    ld hl, wState                                 ; $62CE
    inc [hl]                                      ; $62D1
    ret                                           ; $62D2


jr_003_62d3:
    bit 3, a                                      ; $62D3
    ret z                                         ; $62D5

    ld a, [wPlayerPause]                          ; $62D6
    cpl                                           ; $62D9
    ld [wPlayerPause], a                          ; $62DA
    ret                                           ; $62DD


; C: fades out and returns to state 0
Mode13_State05_Exit::
    call Pal_FadeOut                              ; $62DE
    call Lcd_Off                                  ; $62E1
    ld hl, hStatShadow                            ; $62E4
    res 6, [hl]                                   ; $62E7
    ld hl, rIE                                    ; $62E9
    res 1, [hl]                                   ; $62EC
    ld a, STATE_13_INIT                           ; $62EE
    ld [wState], a                                ; $62F0
    ret                                           ; $62F3


; C: selects result message 6
Mode13_State06_EndMessageSetup::
    xor a                                         ; $62F4
    ld [wSubstate], a                             ; $62F5
    ld a, $06                                     ; $62F8
    ld [wResultMsgId], a                          ; $62FA
    ld hl, wState                                 ; $62FD
    inc [hl]                                      ; $6300
    ret                                           ; $6301


; C: far call 09:7290 (shared result screen)
Mode13_State07_FarResultScreen::
    ldh [hFarcallAArg], a                         ; $6302
    ld a, BANK(ResultScreen_Far)                  ; $6304
    ld hl, ResultScreen_Far                       ; $6306
    call Far_Call                                 ; $6309
    ret                                           ; $630C


; C: jumps to state 0
Mode13_State08_Restart::
    jp Mode13_State00_Init                        ; $630D


; C: photo grid then the photo with the pointer hand
Mode0C_HotSpotViewer::
    ld a, [wState]                                ; $6310
    rst Rst18_JumpTable                           ; $6313

; C: 5 states, rst $18 table of mode $0C
Mode0C_StateTable::
    dw Mode0C_State00_Init
    dw Mode0C_State01_FarPhotoPicker
    dw Mode0C_State02_Setup
    dw Mode0C_State03_Browse
    dw Mode0C_State04_Activate

; C: selects the message strip / icon of the picker
Mode0C_State00_Init::
    ld a, $01                                     ; $631E
    ld [wMsgStripSel], a                          ; $6320
    ld a, $06                                     ; $6323
    ld [wIconSel], a                              ; $6325
    xor a                                         ; $6328
    ld [wSubstate], a                             ; $6329
    ld [wStockNavAllowed], a                      ; $632C
    ld hl, wState                                 ; $632F
    inc [hl]                                      ; $6332
    ret                                           ; $6333


; C: far call 04:4000 (photo grid)
Mode0C_State01_FarPhotoPicker::
    ldh [hFarcallAArg], a                         ; $6334
    ld a, $04                                     ; $6336
    ld hl, PhotoPicker_Far                        ; $6338
    call Far_Call                                 ; $633B
    ret                                           ; $633E


; C: B returns to the show menu (mode 0B); A builds the viewer screen and loads the photo
Mode0C_State02_Setup::
    ld a, [wAbResult]                             ; $633F
    bit 0, a                                      ; $6342
    jr nz, jr_003_6351                            ; $6344

    ld a, MODE_SHOW_MENU                          ; $6346
    ld [wMode], a                                 ; $6348
    ld a, STATE_0B_INIT                           ; $634B
    ld [wState], a                                ; $634D
    ret                                           ; $6350


jr_003_6351:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6351
    ldh [hLcdcShadow], a                          ; $6353
    ld a, $e4                                     ; $6355
    ld [wPaletteTarget], a                        ; $6357
    ld [wPaletteTarget + $1], a                   ; $635A
    ld a, $d2                                     ; $635D
    ld [wPaletteTarget + $2], a                   ; $635F
    xor a                                         ; $6362
    ldh [hScxShadow], a                           ; $6363
    ldh [hScyShadow], a                           ; $6365
    ld a, $08                                     ; $6367
    ld [wHsCursorX], a                            ; $6369
    ld a, $07                                     ; $636C
    ld [wHsCursorY], a                            ; $636E
    call Anim_ClearSlots                          ; $6371
    ld a, BANK(Gfx_1C_58A0_Mode0C_State02_Setup)  ; $6374
    ld hl, Gfx_1C_58A0_Mode0C_State02_Setup       ; $6376
    ld de, $8580                                  ; $6379
    ld bc, $0280                                  ; $637C
    call Mem_CopyFromBank                         ; $637F
    ld a, BANK(Gfx_1C_5B60_Mode0C_State02_Setup)  ; $6382
    ld hl, Gfx_1C_5B60_Mode0C_State02_Setup       ; $6384
    ld de, $8660                                  ; $6387
    ld bc, $0060                                  ; $638A
    call Mem_CopyFromBank                         ; $638D
    ld a, BANK(Gfx_1C_5C60_Mode0C_State02_Setup)  ; $6390
    ld hl, Gfx_1C_5C60_Mode0C_State02_Setup       ; $6392
    ld de, $8760                                  ; $6395
    ld bc, $0060                                  ; $6398
    call Mem_CopyFromBank                         ; $639B
    ld a, BANK(Gfx_3F_7700_Mode0C_State02_Setup)  ; $639E
    ld hl, Gfx_3F_7700_Mode0C_State02_Setup       ; $63A0
    ld de, $8e00                                  ; $63A3
    ld bc, $01f0                                  ; $63A6
    call Mem_CopyFromBank                         ; $63A9
    ld a, BANK(Map_3F_7D00_Mode0C_State02_Setup)  ; $63AC
    ld hl, Map_3F_7D00_Mode0C_State02_Setup       ; $63AE
    ld de, $9800                                  ; $63B1
    ld bc, $0240                                  ; $63B4
    call Mem_CopyFromBank                         ; $63B7
    ld hl, $9a40                                  ; $63BA
    ld bc, $01c0                                  ; $63BD
    ld a, $ff                                     ; $63C0
    call Mem_FillBc1                              ; $63C2
    ld hl, $8ff0                                  ; $63C5
    ld bc, $0010                                  ; $63C8
    ld de, $ffff                                  ; $63CB
    call Mem_FillWords                            ; $63CE
    ld a, [wPhotoIndex]                           ; $63D1
    ld [wHotSpotShownPhoto], a                    ; $63D4
    ldh [hFarcallAArg], a                         ; $63D7
    ld a, BANK(Photo_LoadImage_Far)               ; $63D9
    ld hl, Photo_LoadImage_Far                    ; $63DB
    call Far_Call                                 ; $63DE
    ld a, $00                                     ; $63E1
    ld hl, wPhotoImage                            ; $63E3
    ld de, $9000                                  ; $63E6
    ld bc, $0800                                  ; $63E9
    call Mem_CopyFromBank                         ; $63EC
    ld a, $00                                     ; $63EF
    ld hl, wPhotoImage + $800                     ; $63F1
    ld de, $8800                                  ; $63F4
    ld bc, $0600                                  ; $63F7
    call Mem_CopyFromBank                         ; $63FA
    ld a, [wHotSpotShownPhoto]                    ; $63FD
    ldh [hFarcallAArg], a                         ; $6400
    ld a, BANK(Photo_LoadHotspotsTranslated_Far)  ; $6402
    ld hl, Photo_LoadHotspotsTranslated_Far       ; $6404
    call Far_Call                                 ; $6407
    call Oam_ClearShadow                          ; $640A
    call Pal_AllWhite                             ; $640D
    call Lcd_On                                   ; $6410
    push af                                       ; $6413
    ld a, MUSIC_STOP                              ; $6414
    call Snd_Music                                ; $6416
    pop af                                        ; $6419
    call Pal_FadeIn                               ; $641A
    ld hl, wState                                 ; $641D
    inc [hl]                                      ; $6420
    ret                                           ; $6421


; C: pointer hand moves over the photo
Mode0C_State03_Browse::
    call HotSpot_PointerMove                      ; $6422
    call HotSpot_DrawPointer                      ; $6425
    ldh a, [hKeysNew]                             ; $6428
    and PADF_A | PADF_B                           ; $642A
    ret z                                         ; $642C

    ld [wAbResult], a                             ; $642D
    ld hl, wState                                 ; $6430
    inc [hl]                                      ; $6433
    ret                                           ; $6434


; C: A: looks for a hot spot under the pointer and plays its effect; B leaves
Mode0C_State04_Activate::
    ld a, [wAbResult]                             ; $6435
    bit 0, a                                      ; $6438
    jr z, jr_003_6476                             ; $643A

    ld hl, wSpriteAnimFrame                       ; $643C
    inc [hl]                                      ; $643F
    call HotSpot_FindUnderPointer                 ; $6440
    jr c, jr_003_6450                             ; $6443

    ld e, $02                                     ; $6445
    call HotSpot_PointerAnimWait                  ; $6447
    ld a, STATE_0C_BROWSE                         ; $644A
    ld [wState], a                                ; $644C
    ret                                           ; $644F


jr_003_6450:
    ld e, $03                                     ; $6450
    call HotSpot_PointerAnimWait                  ; $6452
    ld b, $00                                     ; $6455
    call HotSpot_PlayJingle                       ; $6457
    call HotSpot_LoadTargetPhoto                  ; $645A
    call HotSpot_RunEffect                        ; $645D
    ld a, [wHotSpotShownPhoto]                    ; $6460
    ldh [hFarcallAArg], a                         ; $6463
    ld a, BANK(Photo_LoadHotspotsTranslated_Far)  ; $6465
    ld hl, Photo_LoadHotspotsTranslated_Far       ; $6467
    call Far_Call                                 ; $646A
    ld a, [wHotSpotShownPhoto]                    ; $646D
    ld a, STATE_0C_BROWSE                         ; $6470
    ld [wState], a                                ; $6472
    ret                                           ; $6475


jr_003_6476:
    call Pal_FadeOut                              ; $6476
    call Lcd_Off                                  ; $6479
    ld a, STATE_0C_INIT                           ; $647C
    ld [wState], a                                ; $647E
    ret                                           ; $6481


; C: runs the pointer animation until frame E. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
HotSpot_PointerAnimWait::
    push bc                                       ; $6482

jr_003_6483:
    push de                                       ; $6483
    call HotSpot_DrawPointer                      ; $6484
    call Oam_HideUnused                           ; $6487
    rst Rst08_WaitVBlank                          ; $648A
    pop de                                        ; $648B
    ld a, [wSpriteAnimFrame]                      ; $648C
    cp e                                          ; $648F
    jr nz, jr_003_6483                            ; $6490

    xor a                                         ; $6492
    ld [wSpriteAnimFrame], a                      ; $6493
    call HotSpot_DrawPointer                      ; $6496
    pop bc                                        ; $6499
    ret                                           ; $649A


; C: draws the pointer hand at (cursor_x
HotSpot_DrawPointer::
    ld a, [wHsCursorX]                            ; $649B
    sla a                                         ; $649E
    sla a                                         ; $64A0
    sla a                                         ; $64A2
    add $18                                       ; $64A4
    ld b, a                                       ; $64A6
    ld a, [wHsCursorY]                            ; $64A7
    sla a                                         ; $64AA
    sla a                                         ; $64AC
    sla a                                         ; $64AE
    add $20                                       ; $64B0
    ld c, a                                       ; $64B2
    ld a, [wSpriteAnimFrame]                      ; $64B3
    sla a                                         ; $64B6
    ld e, a                                       ; $64B8
    ld d, $00                                     ; $64B9
    ld hl, HotSpot_DrawPointer_Tbl64DE            ; $64BB
    add hl, de                                    ; $64BE
    ld a, [hl+]                                   ; $64BF
    call Oam_AddMeta_B01_4000                     ; $64C0
    ld a, [wSpriteAnimTick]                       ; $64C3
    cp [hl]                                       ; $64C6
    jr nz, jr_003_64d1                            ; $64C7

    ld hl, wSpriteAnimFrame                       ; $64C9
    inc [hl]                                      ; $64CC
    xor a                                         ; $64CD
    ld [wSpriteAnimTick], a                       ; $64CE

jr_003_64d1:
    ld a, [wSpriteAnimFrame]                      ; $64D1
    and a                                         ; $64D4
    ret z                                         ; $64D5

    cp $03                                        ; $64D6
    ret z                                         ; $64D8

    ld hl, wSpriteAnimTick                        ; $64D9
    inc [hl]                                      ; $64DC
    ret                                           ; $64DD


; C: auto: 8 bytes, bytes; referenced by HotSpot_DrawPointer. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0C)
HotSpot_DrawPointer_Tbl64DE::
    db $a0, $06, $a1, $06, $9f, $06, $9f, $ff

; C: D-pad moves the pointer (x 0..14
HotSpot_PointerMove::
    ldh a, [hKeysNewRepeat]                       ; $64E6
    ld b, a                                       ; $64E8
    ld a, [wHsCursorX]                            ; $64E9
    call HotSpot_PointerMoveX                     ; $64EC
    ld [wHsCursorX], a                            ; $64EF
    ld a, [wHsCursorY]                            ; $64F2
    call HotSpot_PointerMoveY                     ; $64F5
    ld [wHsCursorY], a                            ; $64F8
    ret                                           ; $64FB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
HotSpot_PointerMoveX::
    bit 5, b                                      ; $64FC
    jr z, jr_003_6504                             ; $64FE

    and a                                         ; $6500
    ret z                                         ; $6501

    dec a                                         ; $6502
    ret                                           ; $6503


jr_003_6504:
    bit 4, b                                      ; $6504
    ret z                                         ; $6506

    cp $0e                                        ; $6507
    ret z                                         ; $6509

    inc a                                         ; $650A
    ret                                           ; $650B


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
HotSpot_PointerMoveY::
    bit 6, b                                      ; $650C
    jr z, jr_003_6514                             ; $650E

    and a                                         ; $6510
    ret z                                         ; $6511

    dec a                                         ; $6512
    ret                                           ; $6513


jr_003_6514:
    bit 7, b                                      ; $6514
    ret z                                         ; $6516

    cp $0c                                        ; $6517
    ret z                                         ; $6519

    inc a                                         ; $651A
    ret                                           ; $651B


; C: plays the sound list of the hot spot. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios,
; core organic runs); C from the code: plays the sound of a hot spot (byte $0F of its record in wHotspotBlock, $FF =
; none) through HotSpotEd_SoundList
HotSpot_PlayJingle::
    ld hl, wHotspotBlock + $f                     ; $651C
    add hl, bc                                    ; $651F
    ld a, [hl]                                    ; $6520
    cp $ff                                        ; $6521
    ret z                                         ; $6523

    ld hl, HotSpotEd_SoundList                    ; $6524
    call Snd_PlayFromList                         ; $6527
    ret                                           ; $652A


; C: far call 02:4C80 for the JUMP target photo
HotSpot_LoadTargetPhoto::
    ld hl, wHotspotBlock + $19                    ; $652B
    add hl, bc                                    ; $652E
    ld a, [hl]                                    ; $652F
    cp $ff                                        ; $6530
    ret z                                         ; $6532

    push bc                                       ; $6533
    ld [wHotSpotShownPhoto], a                    ; $6534
    ldh [hFarcallAArg], a                         ; $6537
    ld a, BANK(Photo_LoadImage_Far)               ; $6539
    ld hl, Photo_LoadImage_Far                    ; $653B
    call Far_Call                                 ; $653E
    pop bc                                        ; $6541
    ret                                           ; $6542


; C: dispatches the effect number through the table at 655D
HotSpot_RunEffect::
    ld hl, wHotspotBlock + $14                    ; $6543
    add hl, bc                                    ; $6546
    ld a, [hl]                                    ; $6547
    push bc                                       ; $6548
    ld hl, HotSpot_RunEffect_Return               ; $6549
    push hl                                       ; $654C
    inc a                                         ; $654D
    sla a                                         ; $654E
    ld c, a                                       ; $6550
    ld b, $00                                     ; $6551
    ld hl, HotSpot_EffectTbl                      ; $6553
    add hl, bc                                    ; $6556
    ld a, [hl+]                                   ; $6557
    ld h, [hl]                                    ; $6558
    ld l, a                                       ; $6559
    jp hl                                         ; $655A


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; pop bc / ret tail of HotSpot_RunEffect
HotSpot_RunEffect_Return::
    pop bc                                        ; $655B
    ret                                           ; $655C


; C: 17 words: effect $FF (plain swap)
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
    push bc                                       ; $657F
    push de                                       ; $6580
    push hl                                       ; $6581
    rst Rst08_WaitVBlank                          ; $6582
    pop hl                                        ; $6583
    pop de                                        ; $6584
    pop bc                                        ; $6585
    ret                                           ; $6586


; C: A = tile number: copies the 16-byte tile of the working buffer to VRAM. L3 pass 2026-10-26: no organic run
; reached it (BGB replays, BGB scenarios, core organic runs); C from the code: copies tile A of the photo
; (wPhotoImage) to its own VRAM slot ($8000 / $9000 by bit 7), used by the spiral steps of ...
HotSpot_CopyTile::
    push bc                                       ; $6587
    push de                                       ; $6588
    push hl                                       ; $6589
    cp $80                                        ; $658A
    jr nc, jr_003_6593                            ; $658C

    ld hl, $9000                                  ; $658E
    jr jr_003_6596                                ; $6591

jr_003_6593:
    ld hl, $8000                                  ; $6593

jr_003_6596:
    swap a                                        ; $6596
    push af                                       ; $6598
    and $f0                                       ; $6599
    ld c, a                                       ; $659B
    pop af                                        ; $659C
    and $0f                                       ; $659D
    ld b, a                                       ; $659F
    add hl, bc                                    ; $65A0
    push hl                                       ; $65A1
    ld hl, wPhotoImage                            ; $65A2
    add hl, bc                                    ; $65A5
    ld a, $00                                     ; $65A6
    pop de                                        ; $65A8
    ld bc, $0010                                  ; $65A9
    call Vram_CopyFromBank                        ; $65AC
    pop hl                                        ; $65AF
    pop de                                        ; $65B0
    pop bc                                        ; $65B1
    ret                                           ; $65B2


; C: A = destination tile. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies photo tile C to the VRAM slot of tile A (hot-spot effects)
HotSpot_CopyTileFrom::
    push de                                       ; $65B3
    push hl                                       ; $65B4
    cp $80                                        ; $65B5
    jr nc, jr_003_65be                            ; $65B7

    ld hl, $9000                                  ; $65B9
    jr jr_003_65c1                                ; $65BC

jr_003_65be:
    ld hl, $8000                                  ; $65BE

jr_003_65c1:
    swap a                                        ; $65C1
    push af                                       ; $65C3
    and $f0                                       ; $65C4
    ld e, a                                       ; $65C6
    pop af                                        ; $65C7
    and $0f                                       ; $65C8
    ld d, a                                       ; $65CA
    add hl, de                                    ; $65CB
    push hl                                       ; $65CC
    ld a, c                                       ; $65CD
    swap a                                        ; $65CE
    push af                                       ; $65D0
    and $f0                                       ; $65D1
    ld c, a                                       ; $65D3
    pop af                                        ; $65D4
    and $0f                                       ; $65D5
    ld b, a                                       ; $65D7
    ld hl, wPhotoImage                            ; $65D8
    add hl, bc                                    ; $65DB
    ld a, $00                                     ; $65DC
    pop de                                        ; $65DE
    ld bc, $0010                                  ; $65DF
    call Vram_CopyFromBank                        ; $65E2
    pop hl                                        ; $65E5
    pop de                                        ; $65E6
    ret                                           ; $65E7


; C: A = destination tile. L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic
; runs); C from the code: copies VRAM tile C to the slot of tile A (hot-spot effects)
HotSpot_MoveTileInVram::
    push de                                       ; $65E8
    push hl                                       ; $65E9
    cp $80                                        ; $65EA
    jr nc, jr_003_65f3                            ; $65EC

    ld hl, $9000                                  ; $65EE
    jr jr_003_65f6                                ; $65F1

jr_003_65f3:
    ld hl, $8000                                  ; $65F3

jr_003_65f6:
    swap a                                        ; $65F6
    push af                                       ; $65F8
    and $f0                                       ; $65F9
    ld e, a                                       ; $65FB
    pop af                                        ; $65FC
    and $0f                                       ; $65FD
    ld d, a                                       ; $65FF
    add hl, de                                    ; $6600
    push hl                                       ; $6601
    ld a, c                                       ; $6602
    cp $80                                        ; $6603
    jr nc, jr_003_660c                            ; $6605

    ld hl, $9000                                  ; $6607
    jr jr_003_660f                                ; $660A

jr_003_660c:
    ld hl, $8000                                  ; $660C

jr_003_660f:
    swap a                                        ; $660F
    push af                                       ; $6611
    and $f0                                       ; $6612
    ld c, a                                       ; $6614
    pop af                                        ; $6615
    and $0f                                       ; $6616
    ld b, a                                       ; $6618
    add hl, bc                                    ; $6619
    xor a                                         ; $661A
    pop de                                        ; $661B
    ld bc, $0010                                  ; $661C
    call Vram_CopyFromBank_4                      ; $661F
    pop hl                                        ; $6622
    pop de                                        ; $6623
    ret                                           ; $6624


; C: no effect: copies the new photo to VRAM
HotSpotFx_FF_PlainSwap::
    ld a, $00                                     ; $6625
    ld hl, wPhotoImage                            ; $6627
    ld de, $9000                                  ; $662A
    ld bc, $0800                                  ; $662D
    call Vram_CopyFromBank                        ; $6630
    ld a, $00                                     ; $6633
    ld hl, wPhotoImage + $800                     ; $6635
    ld de, $8800                                  ; $6638
    ld bc, $0600                                  ; $663B
    call Vram_CopyFromBank                        ; $663E
    ret                                           ; $6641


; C: dissolve through a checkerboard of tiles
HotSpotFx_00_Checkerboard::
    ld de, $c0c0                                  ; $6642
    ld b, $02                                     ; $6645

jr_003_6647:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $6647
    ld c, $10                                     ; $664A

jr_003_664c:
    ld a, [hl+]                                   ; $664C
    add e                                         ; $664D
    call HotSpot_CopyTile                         ; $664E
    dec c                                         ; $6651
    jr nz, jr_003_664c                            ; $6652

    call HotSpot_WaitFrame                        ; $6654
    ld a, e                                       ; $6657
    sub $20                                       ; $6658
    ld e, a                                       ; $665A
    dec b                                         ; $665B
    jr nz, jr_003_6647                            ; $665C

    ld b, $05                                     ; $665E

jr_003_6660:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $6660
    ld c, $10                                     ; $6663

jr_003_6665:
    ld a, [hl+]                                   ; $6665
    push af                                       ; $6666
    add e                                         ; $6667
    call HotSpot_CopyTile                         ; $6668
    pop af                                        ; $666B
    add d                                         ; $666C
    xor $01                                       ; $666D
    call HotSpot_CopyTile                         ; $666F
    dec c                                         ; $6672
    jr nz, jr_003_6665                            ; $6673

    call HotSpot_WaitFrame                        ; $6675
    ld a, e                                       ; $6678
    sub $20                                       ; $6679
    ld e, a                                       ; $667B
    ld a, d                                       ; $667C
    sub $20                                       ; $667D
    ld d, a                                       ; $667F
    dec b                                         ; $6680
    jr nz, jr_003_6660                            ; $6681

    ld b, $02                                     ; $6683

jr_003_6685:
    ld hl, HotSpotFx_00_Checkerboard_CellTbl      ; $6685
    ld c, $10                                     ; $6688

jr_003_668a:
    ld a, [hl+]                                   ; $668A
    add d                                         ; $668B
    xor $01                                       ; $668C
    call HotSpot_CopyTile                         ; $668E
    dec c                                         ; $6691
    jr nz, jr_003_668a                            ; $6692

    call HotSpot_WaitFrame                        ; $6694
    ld a, d                                       ; $6697
    sub $20                                       ; $6698
    ld d, a                                       ; $669A
    dec b                                         ; $669B
    jr nz, jr_003_6685                            ; $669C

    ret                                           ; $669E


; C: 16 tile-index offsets $1F,$1D,...,$11,$0E,$0C,...,$00 (not tile graphics): the 16 cells of a checkerboard over
; two tile rows (row 1 odd columns, row 0 even columns); HotSpotFx_00_Checkerboard adds the band base (E or D) to each
; and copies that tile with HotSpot_CopyTile. Code read 2026-10-18
HotSpotFx_00_Checkerboard_CellTbl::
    db $1f, $1d, $1b, $19, $17, $15, $13, $11, $0e, $0c, $0a, $08, $06, $04, $02, $00

; C: ragged stripe wipe
HotSpotFx_01_StripeWipe::
    ld b, $10                                     ; $66AF

jr_003_66b1:
    push bc                                       ; $66B1
    ld a, b                                       ; $66B2
    dec a                                         ; $66B3
    ld d, a                                       ; $66B4
    ld e, $00                                     ; $66B5
    ld a, b                                       ; $66B7
    cpl                                           ; $66B8
    add $12                                       ; $66B9
    ld b, a                                       ; $66BB

jr_003_66bc:
    push de                                       ; $66BC
    ld c, $0e                                     ; $66BD

jr_003_66bf:
    push bc                                       ; $66BF
    ld a, d                                       ; $66C0
    ld c, e                                       ; $66C1
    call HotSpot_CopyTileFrom                     ; $66C2
    ld a, e                                       ; $66C5
    add $10                                       ; $66C6
    ld e, a                                       ; $66C8
    ld a, d                                       ; $66C9
    add $10                                       ; $66CA
    ld d, a                                       ; $66CC
    pop bc                                        ; $66CD
    dec c                                         ; $66CE
    jr nz, jr_003_66bf                            ; $66CF

    pop de                                        ; $66D1
    inc d                                         ; $66D2
    inc e                                         ; $66D3
    dec b                                         ; $66D4
    jr nz, jr_003_66bc                            ; $66D5

    pop bc                                        ; $66D7
    dec b                                         ; $66D8
    jr nz, jr_003_66b1                            ; $66D9

    ret                                           ; $66DB


; C: fade through black
HotSpotFx_02_FadeThroughBlack::
    ld a, $00                                     ; $66DC
    ld hl, $9000                                  ; $66DE
    ld de, wPhotoImage                            ; $66E1
    ld bc, $0800                                  ; $66E4
    call Vram_CopyFromBank_4                      ; $66E7
    ld a, $00                                     ; $66EA
    ld hl, $8800                                  ; $66EC
    ld de, wPhotoImage + $800                     ; $66EF
    ld bc, $0600                                  ; $66F2
    call Vram_CopyFromBank_4                      ; $66F5
    ld b, $04                                     ; $66F8

jr_003_66fa:
    push bc                                       ; $66FA
    ld hl, wPhotoImage + $1                       ; $66FB
    ld bc, $0700                                  ; $66FE

jr_003_6701:
    ld a, [hl-]                                   ; $6701
    or [hl]                                       ; $6702
    ld [hl+], a                                   ; $6703
    push af                                       ; $6704
    ld a, [hl-]                                   ; $6705
    cpl                                           ; $6706
    xor [hl]                                      ; $6707
    ld [hl+], a                                   ; $6708
    pop af                                        ; $6709
    ld [hl+], a                                   ; $670A
    inc hl                                        ; $670B
    dec bc                                        ; $670C
    ld a, b                                       ; $670D
    or c                                          ; $670E
    jr nz, jr_003_6701                            ; $670F

    ld a, $00                                     ; $6711
    ld hl, wPhotoImage                            ; $6713
    ld de, $9000                                  ; $6716
    ld bc, $0800                                  ; $6719
    call Vram_CopyFromBank                        ; $671C
    ld a, $00                                     ; $671F
    ld hl, wPhotoImage + $800                     ; $6721
    ld de, $8800                                  ; $6724
    ld bc, $0600                                  ; $6727
    call Vram_CopyFromBank                        ; $672A
    pop bc                                        ; $672D
    dec b                                         ; $672E
    jr nz, jr_003_66fa                            ; $672F

    ld a, [wHotSpotShownPhoto]                    ; $6731
    ldh [hFarcallAArg], a                         ; $6734
    ld a, BANK(Photo_LoadImage_Far)               ; $6736
    ld hl, Photo_LoadImage_Far                    ; $6738
    call Far_Call                                 ; $673B
    ld hl, wPhotoImage + $1                       ; $673E
    ld bc, $0700                                  ; $6741

jr_003_6744:
    ld a, [hl-]                                   ; $6744
    or [hl]                                       ; $6745
    ld [hl+], a                                   ; $6746
    ld a, $ff                                     ; $6747
    ld [hl+], a                                   ; $6749
    inc hl                                        ; $674A
    dec bc                                        ; $674B
    ld a, b                                       ; $674C
    or c                                          ; $674D
    jr nz, jr_003_6744                            ; $674E

    ld a, $00                                     ; $6750
    ld hl, wPhotoImage                            ; $6752
    ld de, $9000                                  ; $6755
    ld bc, $0800                                  ; $6758
    call Vram_CopyFromBank                        ; $675B
    ld a, $00                                     ; $675E
    ld hl, wPhotoImage + $800                     ; $6760
    ld de, $8800                                  ; $6763
    ld bc, $0600                                  ; $6766
    call Vram_CopyFromBank                        ; $6769
    ld a, [wHotSpotShownPhoto]                    ; $676C
    ldh [hFarcallAArg], a                         ; $676F
    ld a, BANK(Photo_LoadImage_Far)               ; $6771
    ld hl, Photo_LoadImage_Far                    ; $6773
    call Far_Call                                 ; $6776
    ld hl, wPhotoImage + $1                       ; $6779
    ld bc, $0700                                  ; $677C

jr_003_677f:
    ld a, [hl-]                                   ; $677F
    or [hl]                                       ; $6780
    ld [hl+], a                                   ; $6781
    push af                                       ; $6782
    ld a, [hl-]                                   ; $6783
    cpl                                           ; $6784
    xor [hl]                                      ; $6785
    ld [hl+], a                                   ; $6786
    pop af                                        ; $6787
    ld [hl+], a                                   ; $6788
    inc hl                                        ; $6789
    dec bc                                        ; $678A
    ld a, b                                       ; $678B
    or c                                          ; $678C
    jr nz, jr_003_677f                            ; $678D

    ld a, $00                                     ; $678F
    ld hl, wPhotoImage                            ; $6791
    ld de, $9000                                  ; $6794
    ld bc, $0800                                  ; $6797
    call Vram_CopyFromBank                        ; $679A
    ld a, $00                                     ; $679D
    ld hl, wPhotoImage + $800                     ; $679F
    ld de, $8800                                  ; $67A2
    ld bc, $0600                                  ; $67A5
    call Vram_CopyFromBank                        ; $67A8
    ld a, [wHotSpotShownPhoto]                    ; $67AB
    ldh [hFarcallAArg], a                         ; $67AE
    ld a, BANK(Photo_LoadImage_Far)               ; $67B0
    ld hl, Photo_LoadImage_Far                    ; $67B2
    call Far_Call                                 ; $67B5
    ld a, $00                                     ; $67B8
    ld hl, wPhotoImage                            ; $67BA
    ld de, $9000                                  ; $67BD
    ld bc, $0800                                  ; $67C0
    call Vram_CopyFromBank                        ; $67C3
    ld a, $00                                     ; $67C6
    ld hl, wPhotoImage + $800                     ; $67C8
    ld de, $8800                                  ; $67CB
    ld bc, $0600                                  ; $67CE
    call Vram_CopyFromBank                        ; $67D1
    ret                                           ; $67D4


; C: inverts the palette for 60 frames
HotSpotFx_03_Negative::
    ldh a, [hBgpShadow]                           ; $67D5
    push af                                       ; $67D7
    cpl                                           ; $67D8
    ldh [hBgpShadow], a                           ; $67D9
    ld bc, $003c                                  ; $67DB
    call Wait_Frames                              ; $67DE
    ld a, $00                                     ; $67E1
    ld hl, wPhotoImage                            ; $67E3
    ld de, $9000                                  ; $67E6
    ld bc, $0800                                  ; $67E9
    call Vram_CopyFromBank                        ; $67EC
    ld a, $00                                     ; $67EF
    ld hl, wPhotoImage + $800                     ; $67F1
    ld de, $8800                                  ; $67F4
    ld bc, $0600                                  ; $67F7
    call Vram_CopyFromBank                        ; $67FA
    pop af                                        ; $67FD
    ldh [hBgpShadow], a                           ; $67FE
    ret                                           ; $6800


; C: flash to white
HotSpotFx_04_WhiteFlash::
    ldh a, [hBgpShadow]                           ; $6801
    push af                                       ; $6803
    ld a, $90                                     ; $6804
    ldh [hBgpShadow], a                           ; $6806
    rst Rst08_WaitVBlank                          ; $6808
    ld a, $40                                     ; $6809
    ldh [hBgpShadow], a                           ; $680B
    rst Rst08_WaitVBlank                          ; $680D
    ld a, $00                                     ; $680E
    ldh [hBgpShadow], a                           ; $6810
    ld bc, $000a                                  ; $6812
    call Wait_Frames                              ; $6815
    ld a, $00                                     ; $6818
    ld hl, wPhotoImage                            ; $681A
    ld de, $9000                                  ; $681D
    ld bc, $0800                                  ; $6820
    call Vram_CopyFromBank                        ; $6823
    ld a, $00                                     ; $6826
    ld hl, wPhotoImage + $800                     ; $6828
    ld de, $8800                                  ; $682B
    ld bc, $0600                                  ; $682E
    call Vram_CopyFromBank                        ; $6831
    pop af                                        ; $6834
    ldh [hBgpShadow], a                           ; $6835
    ret                                           ; $6837


; C: columns shear and re-form
HotSpotFx_05_ColumnShear::
    ld b, $08                                     ; $6838

jr_003_683a:
    push bc                                       ; $683A
    ld de, $0001                                  ; $683B
    jr jr_003_6850                                ; $683E

jr_003_6840:
    push bc                                       ; $6840
    call HotSpotFx_MoveColumn14                   ; $6841
    call HotSpotFx_MirrorColumnsDE                ; $6844
    call HotSpotFx_MoveColumn14                   ; $6847
    call HotSpotFx_MirrorColumnsDE                ; $684A
    inc d                                         ; $684D
    inc e                                         ; $684E
    pop bc                                        ; $684F

jr_003_6850:
    dec b                                         ; $6850
    jr nz, jr_003_6840                            ; $6851

    pop bc                                        ; $6853
    dec e                                         ; $6854
    push bc                                       ; $6855
    ld a, b                                       ; $6856
    cpl                                           ; $6857
    add $0a                                       ; $6858
    ld b, a                                       ; $685A

jr_003_685b:
    push bc                                       ; $685B
    call HotSpotFx_CopyColumn14                   ; $685C
    call HotSpotFx_MirrorColumnsDE                ; $685F
    call HotSpotFx_CopyColumn14                   ; $6862
    call HotSpotFx_MirrorColumnsDE                ; $6865
    inc e                                         ; $6868
    pop bc                                        ; $6869
    dec b                                         ; $686A
    jr nz, jr_003_685b                            ; $686B

    pop bc                                        ; $686D
    dec b                                         ; $686E
    jr nz, jr_003_683a                            ; $686F

    ret                                           ; $6871


; C: D ^= $0F, E ^= $0F: mirrors the column (low nibble) of the two tile indices D and E (tile index = row x 16 +
; column, HotSpot_CopyTile: offset = index x 16 from $9000 / $8000); used by HotSpotFx_05_ColumnShear between its
; column passes. Code read 2026-10-18
HotSpotFx_MirrorColumnsDE::
    ld a, d                                       ; $6872
    xor $0f                                       ; $6873
    ld d, a                                       ; $6875
    ld a, e                                       ; $6876
    xor $0f                                       ; $6877
    ld e, a                                       ; $6879
    ret                                           ; $687A


; C: moves the 14 tiles of a column inside VRAM: HotSpot_MoveTileInVram(tile D -> tile E), then D += $10, E += $10, 14
; times. Code read 2026-10-18
HotSpotFx_MoveColumn14::
    push de                                       ; $687B
    ld c, $0e                                     ; $687C

jr_003_687e:
    push bc                                       ; $687E
    ld a, d                                       ; $687F
    ld c, e                                       ; $6880
    call HotSpot_MoveTileInVram                   ; $6881
    ld a, e                                       ; $6884
    add $10                                       ; $6885
    ld e, a                                       ; $6887
    ld a, d                                       ; $6888
    add $10                                       ; $6889
    ld d, a                                       ; $688B
    pop bc                                        ; $688C
    dec c                                         ; $688D
    jr nz, jr_003_687e                            ; $688E

    pop de                                        ; $6890
    ret                                           ; $6891


; C: copies the 14 tiles of column E from the work buffer to VRAM: HotSpot_CopyTile(E), E += $10, 14 times. Code read
; 2026-10-18
HotSpotFx_CopyColumn14::
    push de                                       ; $6892
    ld c, $0e                                     ; $6893

jr_003_6895:
    push bc                                       ; $6895
    ld a, e                                       ; $6896
    call HotSpot_CopyTile                         ; $6897
    ld a, e                                       ; $689A
    add $10                                       ; $689B
    ld e, a                                       ; $689D
    pop bc                                        ; $689E
    dec c                                         ; $689F
    jr nz, jr_003_6895                            ; $68A0

    pop de                                        ; $68A2
    ret                                           ; $68A3


; C: rectangular window opens at the centre
HotSpotFx_06_CentreWindow::
    ld e, $79                                     ; $68A4
    ld bc, $0301                                  ; $68A6

jr_003_68a9:
    ld d, b                                       ; $68A9
    call HotSpotFx_SpiralStepLeft                 ; $68AA
    inc b                                         ; $68AD
    ld d, c                                       ; $68AE
    call HotSpotFx_SpiralStepUp                   ; $68AF
    inc c                                         ; $68B2
    ld d, b                                       ; $68B3
    call HotSpotFx_SpiralStepRight                ; $68B4
    inc b                                         ; $68B7
    ld a, b                                       ; $68B8
    cp $11                                        ; $68B9
    ret z                                         ; $68BB

    ld d, c                                       ; $68BC
    call HotSpotFx_SpiralStepDown                 ; $68BD
    inc c                                         ; $68C0
    jr jr_003_68a9                                ; $68C1

; C: copies D tiles walking left: HotSpot_CopyTile(E), delay, E -= 1 (tile index = row x 16 + column). The old name
; said Up; the four steps of HotSpotFx_06_CentreWindow (left, up, right, down with the lengths 3, 1, 4, 2, ...) draw a
; clockwise spiral out of tile $79. Code read 2026-10-18
HotSpotFx_SpiralStepLeft::
    ld a, e                                       ; $68C3
    call HotSpot_CopyTile                         ; $68C4
    call HotSpotFx_Delay                          ; $68C7
    dec e                                         ; $68CA
    dec d                                         ; $68CB
    jr nz, HotSpotFx_SpiralStepLeft               ; $68CC

    ret                                           ; $68CE


; C: copies D tiles walking right: HotSpot_CopyTile(E), delay, E += 1. Code read 2026-10-18
HotSpotFx_SpiralStepRight::
    ld a, e                                       ; $68CF
    call HotSpot_CopyTile                         ; $68D0
    call HotSpotFx_Delay                          ; $68D3
    inc e                                         ; $68D6
    dec d                                         ; $68D7
    jr nz, HotSpotFx_SpiralStepRight              ; $68D8

    ret                                           ; $68DA


; C: copies D tiles walking up: HotSpot_CopyTile(E), delay, E -= $10 (one tile row up). The old name said Down. Code
; read 2026-10-18
HotSpotFx_SpiralStepUp::
    ld a, e                                       ; $68DB
    call HotSpot_CopyTile                         ; $68DC
    call HotSpotFx_Delay                          ; $68DF
    ld a, e                                       ; $68E2
    sub $10                                       ; $68E3
    ld e, a                                       ; $68E5
    dec d                                         ; $68E6
    jr nz, HotSpotFx_SpiralStepUp                 ; $68E7

    ret                                           ; $68E9


; C: copies D tiles walking down: HotSpot_CopyTile(E), delay, E += $10 (one tile row down). The old name said Left.
; Code read 2026-10-18
HotSpotFx_SpiralStepDown::
    ld a, e                                       ; $68EA
    call HotSpot_CopyTile                         ; $68EB
    call HotSpotFx_Delay                          ; $68EE
    ld a, e                                       ; $68F1
    add $10                                       ; $68F2
    ld e, a                                       ; $68F4
    dec d                                         ; $68F5
    jr nz, HotSpotFx_SpiralStepDown               ; $68F6

    ret                                           ; $68F8


; C: busy wait: 255 passes of dec b / jr nz (about 1,000 cycles) between two tiles of the spiral. Code read 2026-10-18
HotSpotFx_Delay::
    push bc                                       ; $68F9
    ld b, $ff                                     ; $68FA

jr_003_68fc:
    dec b                                         ; $68FC
    jr nz, jr_003_68fc                            ; $68FD

    pop bc                                        ; $68FF
    ret                                           ; $6900


; C: sinusoidal row displacement (S shape icon)
HotSpotFx_07_Wave::
    ld bc, $4848                                  ; $6901

jr_003_6904:
    ldh a, [rLY]                                  ; $6904
    and a                                         ; $6906
    jr nz, jr_003_6904                            ; $6907

jr_003_6909:
    ld hl, HotSpotFx_WaveTbl                      ; $6909

jr_003_690c:
    ldh a, [rLY]                                  ; $690C
    cp b                                          ; $690E
    jr c, jr_003_6926                             ; $690F

    sub b                                         ; $6911
    cp $10                                        ; $6912
    jr nc, jr_003_6919                            ; $6914

    ld a, [hl+]                                   ; $6916
    jr jr_003_6927                                ; $6917

jr_003_6919:
    ldh a, [rLY]                                  ; $6919
    cp c                                          ; $691B
    jr c, jr_003_6926                             ; $691C

    sub c                                         ; $691E
    cp $10                                        ; $691F
    jr nc, jr_003_6926                            ; $6921

    ld a, [hl+]                                   ; $6923
    jr jr_003_6927                                ; $6924

jr_003_6926:
    xor a                                         ; $6926

jr_003_6927:
    ld d, a                                       ; $6927

jr_003_6928:
    ldh a, [rSTAT]                                ; $6928
    and $03                                       ; $692A
    jr nz, jr_003_6928                            ; $692C

    ld a, d                                       ; $692E
    ldh [rSCY], a                                 ; $692F
    call HotSpotFx_Delay2                         ; $6931
    ldh a, [rLY]                                  ; $6934
    cp $8f                                        ; $6936
    jr c, jr_003_690c                             ; $6938

    inc c                                         ; $693A
    inc c                                         ; $693B
    dec b                                         ; $693C
    dec b                                         ; $693D
    jr nz, jr_003_6909                            ; $693E

    ld a, $00                                     ; $6940
    ld hl, wPhotoImage                            ; $6942
    ld de, $9000                                  ; $6945
    ld bc, $0800                                  ; $6948
    call Vram_CopyFromBank                        ; $694B
    ld a, $00                                     ; $694E
    ld hl, wPhotoImage + $800                     ; $6950
    ld de, $8800                                  ; $6953
    ld bc, $0600                                  ; $6956
    call Vram_CopyFromBank                        ; $6959
    ret                                           ; $695C


; C: SCY offsets of HotSpotFx_07_Wave: 1,2,3,4,5,6,7,7,7,7,6,5,4,3,2,1 twice (read with ld a,[hl+] on the 16-line
; bands at LY = B and C). Code read 2026-10-18
HotSpotFx_WaveTbl::
    db $01, $02, $03, $04, $05, $06, $07, $07, $07, $07, $06, $05, $04, $03, $02, $01
    db $01, $02, $03, $04, $05, $06, $07, $07, $07, $07, $06, $05, $04, $03, $02, $01

; C: busy wait of 4 passes (dec a / jr nz) between two scanlines of the wave. Code read 2026-10-18
HotSpotFx_Delay2::
    ld a, $04                                     ; $697D

jr_003_697f:
    dec a                                         ; $697F
    jr nz, jr_003_697f                            ; $6980

    ret                                           ; $6982


; C: quick page flip used by the eight unused values
HotSpotFx_08_to_0F_PageFlip::
    call HotSpotFx_PageFlipRamp                   ; $6983
    ld a, $00                                     ; $6986
    ld hl, wPhotoImage                            ; $6988
    ld de, $9000                                  ; $698B
    ld bc, $0800                                  ; $698E
    call Vram_CopyFromBank                        ; $6991
    ld a, $00                                     ; $6994
    ld hl, wPhotoImage + $800                     ; $6996
    ld de, $8800                                  ; $6999
    ld bc, $0600                                  ; $699C
    call Vram_CopyFromBank                        ; $699F
    ret                                           ; $69A2


; C: raster effect of HotSpotFx_08_to_0F_PageFlip: for c = 1..7, on every scanline LY from $0F to $7E, SCY = b - LY
; with b += 1 every c scanlines, SCY back to 0 afterwards. Code read 2026-10-18
HotSpotFx_PageFlipRamp::
    ld c, $01                                     ; $69A3
    ld b, $00                                     ; $69A5
    ld hl, Unused_HotSpotFx_PageFlipTbl           ; $69A7

jr_003_69aa:
    ldh a, [rLY]                                  ; $69AA
    cp $0f                                        ; $69AC
    jr c, jr_003_69aa                             ; $69AE

    cp $7f                                        ; $69B0
    jr nc, jr_003_69aa                            ; $69B2

    ld e, c                                       ; $69B4
    push bc                                       ; $69B5

jr_003_69b6:
    dec e                                         ; $69B6
    jr nz, jr_003_69bb                            ; $69B7

    ld e, c                                       ; $69B9
    inc b                                         ; $69BA

jr_003_69bb:
    ldh a, [rLY]                                  ; $69BB
    cpl                                           ; $69BD
    inc a                                         ; $69BE
    add b                                         ; $69BF
    ld d, a                                       ; $69C0

jr_003_69c1:
    ldh a, [rSTAT]                                ; $69C1
    and $03                                       ; $69C3
    jr nz, jr_003_69c1                            ; $69C5

    ld a, d                                       ; $69C7
    ldh [rSCY], a                                 ; $69C8
    call HotSpotFx_Delay3                         ; $69CA
    ldh a, [rLY]                                  ; $69CD
    cp $7f                                        ; $69CF
    jr c, jr_003_69b6                             ; $69D1

    call HotSpotFx_Delay3                         ; $69D3

jr_003_69d6:
    ldh a, [rSTAT]                                ; $69D6
    and $03                                       ; $69D8
    jr nz, jr_003_69d6                            ; $69DA

    xor a                                         ; $69DC
    ldh [rSCY], a                                 ; $69DD
    pop bc                                        ; $69DF
    inc c                                         ; $69E0
    ld a, c                                       ; $69E1
    cp $08                                        ; $69E2
    jr nz, jr_003_69aa                            ; $69E4

    ret                                           ; $69E6


; C: 8 zero bytes that nothing reads: HotSpotFx_PageFlipRamp loads HL with this address (03:69A7) and never uses HL
; again (its loop uses B, C, D, E only), and no other instruction of the ROM holds the address $69E7. Code read
; 2026-10-18
Unused_HotSpotFx_PageFlipTbl::
    db $00, $00, $00, $00, $00, $00, $00, $00

; C: busy wait of 4 passes (dec a / jr nz), the same code as HotSpotFx_Delay2, between two scanlines of the page flip.
; Code read 2026-10-18
HotSpotFx_Delay3::
    ld a, $04                                     ; $69EF

jr_003_69f1:
    dec a                                         ; $69F1
    jr nz, jr_003_69f1                            ; $69F2

    ret                                           ; $69F4


; C: select photo / edit the five hot spots
Mode1A_HotSpotEditor::
    ld a, [wState]                                ; $69F5
    rst Rst18_JumpTable                           ; $69F8

; C: 16 states, rst $18 table of mode $1A
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
    ld a, $00                                     ; $6A19
    ld [wMsgStripSel], a                          ; $6A1B
    ld a, $06                                     ; $6A1E
    ld [wIconSel], a                              ; $6A20
    xor a                                         ; $6A23
    ld [wSubstate], a                             ; $6A24
    ld [wStockNavAllowed], a                      ; $6A27
    ld hl, wState                                 ; $6A2A
    inc [hl]                                      ; $6A2D
    ret                                           ; $6A2E


; C: far call 04:4000 (photo grid)
Mode1A_State01_FarPhotoPicker::
    ldh [hFarcallAArg], a                         ; $6A2F
    ld a, $04                                     ; $6A31
    ld hl, PhotoPicker_Far                        ; $6A33
    call Far_Call                                 ; $6A36
    ret                                           ; $6A39


; C: B returns to the special menu (mode 03); A builds the editor screen (cursor
Mode1A_State02_Setup::
    ld a, [wAbResult]                             ; $6A3A
    bit 0, a                                      ; $6A3D
    jr nz, jr_003_6a4c                            ; $6A3F

    ld a, MODE_SPECIAL_MENU                       ; $6A41
    ld [wMode], a                                 ; $6A43
    ld a, STATE_03_INIT                           ; $6A46
    ld [wState], a                                ; $6A48
    ret                                           ; $6A4B


jr_003_6a4c:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $6A4C
    ldh [hLcdcShadow], a                          ; $6A4E
    ld a, $e4                                     ; $6A50
    ld [wPaletteTarget], a                        ; $6A52
    ld [wPaletteTarget + $1], a                   ; $6A55
    ld a, $d2                                     ; $6A58
    ld [wPaletteTarget + $2], a                   ; $6A5A
    ld a, $10                                     ; $6A5D
    ldh [hScxShadow], a                           ; $6A5F
    ldh [hScyShadow], a                           ; $6A61
    ld a, $07                                     ; $6A63
    ldh [hWxShadow], a                            ; $6A65
    ld a, $94                                     ; $6A67
    ldh [hWyShadow], a                            ; $6A69
    ld a, $02                                     ; $6A6B
    ld [wHsCursorX], a                            ; $6A6D
    ld a, $0c                                     ; $6A70
    ld [wHsCursorY], a                            ; $6A72
    ld a, $01                                     ; $6A75
    ld [wHsCursorMode], a                         ; $6A77
    call HotSpotEd_ClearAnim                      ; $6A7A
    ld a, $ff                                     ; $6A7D
    ld [wHsSelected], a                           ; $6A7F
    ld a, BANK(Gfx_1C_4F60_Mode1A_State02_Setup)  ; $6A82
    ld hl, Gfx_1C_4F60_Mode1A_State02_Setup       ; $6A84
    ld de, $8900                                  ; $6A87
    ld bc, $01c0                                  ; $6A8A
    call Mem_CopyFromBank                         ; $6A8D
    ld a, BANK(Gfx_1C_53A0_Mode1A_State02_Setup)  ; $6A90
    ld hl, Gfx_1C_53A0_Mode1A_State02_Setup       ; $6A92
    ld de, $8580                                  ; $6A95
    ld bc, $0280                                  ; $6A98
    call Mem_CopyFromBank                         ; $6A9B
    ld a, BANK(Gfx_1C_5B80_Mode09_State02_PhotoArrows); $6A9E
    ld hl, Gfx_1C_5B80_Mode09_State02_PhotoArrows ; $6AA0
    ld de, $8680                                  ; $6AA3
    ld bc, $0040                                  ; $6AA6
    call Mem_CopyFromBank                         ; $6AA9
    ld a, BANK(Gfx_1C_5C80_Mode09_State02_PhotoArrows); $6AAC
    ld hl, Gfx_1C_5C80_Mode09_State02_PhotoArrows ; $6AAE
    ld de, $8780                                  ; $6AB1
    ld bc, $0040                                  ; $6AB4
    call Mem_CopyFromBank                         ; $6AB7
    ld a, BANK(Gfx_22_6AA0_Mode1A_State02_Setup)  ; $6ABA
    ld hl, Gfx_22_6AA0_Mode1A_State02_Setup       ; $6ABC
    ld de, $8ff0                                  ; $6ABF
    ld bc, $0010                                  ; $6AC2
    call Mem_CopyFromBank                         ; $6AC5
    ld a, BANK(Map_24_6620_Mode1A_State02_Setup)  ; $6AC8
    ld hl, Map_24_6620_Mode1A_State02_Setup       ; $6ACA
    ld de, $9800                                  ; $6ACD
    ld bc, $02c0                                  ; $6AD0
    call Mem_CopyFromBank                         ; $6AD3
    ld a, [wPhotoIndex]                           ; $6AD6
    ld [wCopyPhotoIdxE], a                        ; $6AD9
    ldh [hFarcallAArg], a                         ; $6ADC
    ld a, BANK(Photo_LoadToVram_Far)              ; $6ADE
    ld hl, Photo_LoadToVram_Far                   ; $6AE0
    call Far_Call                                 ; $6AE3
    xor a                                         ; $6AE6
    ld [wDirtyFlag], a                            ; $6AE7
    ld a, [wCopyPhotoIdxE]                        ; $6AEA
    ldh [hFarcallAArg], a                         ; $6AED
    ld a, BANK(Photo_LoadHotspotsTranslated_Far)  ; $6AEF
    ld hl, Photo_LoadHotspotsTranslated_Far       ; $6AF1
    call Far_Call                                 ; $6AF4
    ld a, $54                                     ; $6AF7
    ldh [hLycShadowSplit1], a                     ; $6AF9
    ldh [hSplit1Latch], a                         ; $6AFB
    ld hl, hStatShadow                            ; $6AFD
    set 6, [hl]                                   ; $6B00
    ld hl, rIE                                    ; $6B02
    set 1, [hl]                                   ; $6B05
    ld a, $01                                     ; $6B07
    ldh [hStatHandlerIndex], a                    ; $6B09
    call Oam_ClearShadow                          ; $6B0B
    call Pal_AllWhite                             ; $6B0E
    call Lcd_On                                   ; $6B11
    push af                                       ; $6B14
    ld a, MUSIC_STOP                              ; $6B15
    call Snd_Music                                ; $6B17
    pop af                                        ; $6B1A
    call Pal_FadeIn                               ; $6B1B
    ld hl, wState                                 ; $6B1E
    inc [hl]                                      ; $6B21
    ret                                           ; $6B22


; C: pointer / hot-spot slot selection; A edits or places a spot
Mode1A_State03_Browse::
    ld a, [wHsCursorMode]                         ; $6B23
    and a                                         ; $6B26
    jr nz, jr_003_6b48                            ; $6B27

    call HotSpot_FindUnderPointer                 ; $6B29
    ld a, $ff                                     ; $6B2C
    jr nc, jr_003_6b31                            ; $6B2E

    ld a, c                                       ; $6B30

jr_003_6b31:
    ld [wHsSelected], a                           ; $6B31
    call HotSpotEd_DrawPointer                    ; $6B34
    call HotSpotEd_DrawSlots                      ; $6B37
    ldh a, [hKeysNew]                             ; $6B3A
    bit PADB_A, a                                 ; $6B3C
    jr nz, jr_003_6b79                            ; $6B3E

    bit PADB_B, a                                 ; $6B40
    jr nz, jr_003_6baf                            ; $6B42

    call HotSpotEd_PointerMove                    ; $6B44
    ret                                           ; $6B47


jr_003_6b48:
    call HotSpotEd_DrawSlotPointer                ; $6B48
    call HotSpotEd_DrawSlots                      ; $6B4B
    ldh a, [hKeysNew]                             ; $6B4E
    bit PADB_A, a                                 ; $6B50
    jr z, jr_003_6b71                             ; $6B52

    push af                                       ; $6B54
    ld a, SFX1_KEY_A                              ; $6B55
    call Snd_Sfx1                                 ; $6B57
    pop af                                        ; $6B5A
    ld a, [wHsSelected]                           ; $6B5B
    ld c, a                                       ; $6B5E
    ld b, $00                                     ; $6B5F
    ld hl, wHotspotBlock                          ; $6B61
    add hl, bc                                    ; $6B64
    bit 0, [hl]                                   ; $6B65
    jr nz, jr_003_6b79                            ; $6B67

    call HotSpotEd_NewSpot                        ; $6B69
    ld hl, wState                                 ; $6B6C
    inc [hl]                                      ; $6B6F
    ret                                           ; $6B70


jr_003_6b71:
    bit 1, a                                      ; $6B71
    jr nz, jr_003_6baf                            ; $6B73

    call HotSpotEd_SlotMove                       ; $6B75
    ret                                           ; $6B78


jr_003_6b79:
    ld a, [wHsSelected]                           ; $6B79
    cp $05                                        ; $6B7C
    ret nc                                        ; $6B7E

    call Oam_ClearShadow                          ; $6B7F
    rst Rst08_WaitVBlank                          ; $6B82
    ld a, BANK(Gfx_26_4880_Mode1A_State03_Browse) ; $6B83
    ld hl, Gfx_26_4880_Mode1A_State03_Browse      ; $6B85
    ld de, $8b00                                  ; $6B88
    ld bc, $0400                                  ; $6B8B
    call Vram_CopyFromBank                        ; $6B8E
    ld a, BANK(Map_27_7750_Mode1A_State03_Browse) ; $6B91
    ld hl, Map_27_7750_Mode1A_State03_Browse      ; $6B93
    ld de, $9c00                                  ; $6B96
    ld bc, $0120                                  ; $6B99
    call Vram_CopyFromBank                        ; $6B9C
    call HotSpotEd_LoadSpotFields                 ; $6B9F
    xor a                                         ; $6BA2
    ld [wDialogChoice], a                         ; $6BA3
    call HotSpotEd_DialogSlideIn                  ; $6BA6
    ld a, STATE_1A_EXIT_DIALOG                    ; $6BA9
    ld [wState], a                                ; $6BAB
    ret                                           ; $6BAE


jr_003_6baf:
    ld a, [wDirtyFlag]                            ; $6BAF
    and a                                         ; $6BB2
    jr z, jr_003_6bbb                             ; $6BB3

    ld a, STATE_1A_SAVE_PREPARE                   ; $6BB5
    ld [wState], a                                ; $6BB7
    ret                                           ; $6BBA


jr_003_6bbb:
    ld a, STATE_1A_EXIT                           ; $6BBB
    ld [wState], a                                ; $6BBD
    ret                                           ; $6BC0


; C: initialises a new hot spot in the block (position 7
HotSpotEd_NewSpot::
    ld a, [wHsSelected]                           ; $6BC1
    ld c, a                                       ; $6BC4
    ld b, $00                                     ; $6BC5
    ld hl, wHotspotBlock + $5                     ; $6BC7
    add hl, bc                                    ; $6BCA
    ld a, $07                                     ; $6BCB
    ld [hl], a                                    ; $6BCD
    ld hl, wHotspotBlock + $a                     ; $6BCE
    add hl, bc                                    ; $6BD1
    ld a, $06                                     ; $6BD2
    ld [hl], a                                    ; $6BD4
    ld hl, wHotspotBlock                          ; $6BD5
    add hl, bc                                    ; $6BD8
    ld a, $01                                     ; $6BD9
    ld [hl], a                                    ; $6BDB
    ld a, $ff                                     ; $6BDC
    ld hl, wHotspotBlock + $f                     ; $6BDE
    add hl, bc                                    ; $6BE1
    ld [hl], a                                    ; $6BE2
    ld [wHsEditSound], a                          ; $6BE3
    ld hl, wHotspotBlock + $14                    ; $6BE6
    add hl, bc                                    ; $6BE9
    ld [hl], a                                    ; $6BEA
    ld [wHsEditEffect], a                         ; $6BEB
    ld hl, wHotspotBlock + $19                    ; $6BEE
    add hl, bc                                    ; $6BF1
    ld [hl], a                                    ; $6BF2
    ld [wHsEditJump], a                           ; $6BF3
    xor a                                         ; $6BF6
    ld hl, wSpriteAnimFrame + $1                  ; $6BF7
    add hl, bc                                    ; $6BFA
    ld [hl], a                                    ; $6BFB
    ld hl, wSpriteAnimTick + $1                   ; $6BFC
    add hl, bc                                    ; $6BFF
    ld [hl], a                                    ; $6C00
    ld a, $01                                     ; $6C01
    ld [wDirtyFlag], a                            ; $6C03
    ld [wHsIsNew], a                              ; $6C06
    ret                                           ; $6C09


; C: copies sound / effect / jump of the selected spot to the edit variables
HotSpotEd_LoadSpotFields::
    ld a, [wHsSelected]                           ; $6C0A
    ld c, a                                       ; $6C0D
    ld b, $00                                     ; $6C0E
    ld hl, wHotspotBlock + $f                     ; $6C10
    add hl, bc                                    ; $6C13
    ld a, [hl]                                    ; $6C14
    ld [wHsEditSound], a                          ; $6C15
    ld hl, wHotspotBlock + $14                    ; $6C18
    add hl, bc                                    ; $6C1B
    ld a, [hl]                                    ; $6C1C
    ld [wHsEditEffect], a                         ; $6C1D
    ld hl, wHotspotBlock + $19                    ; $6C20
    add hl, bc                                    ; $6C23
    ld a, [hl]                                    ; $6C24
    ld [wHsEditJump], a                           ; $6C25
    xor a                                         ; $6C28
    ld [wHsIsNew], a                              ; $6C29
    ret                                           ; $6C2C


; C: A opens the sound picker; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 04 (6412 hits in 16 runs:
; 1A:04 x6412; tcrf_check/assets/mode_state_wp/)
Mode1A_State04_PlaceOrDelete::
    call HotSpotEd_MoveSpot                       ; $6C2D
    call HotSpotEd_DrawSlots                      ; $6C30
    ldh a, [hKeysNew]                             ; $6C33
    bit PADB_A, a                                 ; $6C35
    jr z, jr_003_6c7d                             ; $6C37

    call Oam_ClearShadow                          ; $6C39
    rst Rst08_WaitVBlank                          ; $6C3C
    ld a, BANK(Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete); $6C3D
    ld hl, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete; $6C3F
    ld de, $8c30                                  ; $6C42
    ld bc, $00c0                                  ; $6C45
    call Vram_CopyFromBank                        ; $6C48
    ld a, BANK(Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete); $6C4B
    ld hl, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete; $6C4D
    ld de, $8da0                                  ; $6C50
    ld bc, $0040                                  ; $6C53
    call Vram_CopyFromBank                        ; $6C56
    ld a, BANK(Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete); $6C59
    ld hl, Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete; $6C5B
    ld de, $8de0                                  ; $6C5E
    ld bc, $0200                                  ; $6C61
    call Vram_CopyFromBank                        ; $6C64
    ld a, BANK(Map_0E_7F00_Mode1A_State04_PlaceOrDelete); $6C67
    ld hl, Map_0E_7F00_Mode1A_State04_PlaceOrDelete; $6C69
    ld de, $9c00                                  ; $6C6C
    ld bc, $0120                                  ; $6C6F
    call Vram_CopyFromBank                        ; $6C72
    call HotSpotEd_PickerSlideIn                  ; $6C75
    ld hl, wState                                 ; $6C78
    inc [hl]                                      ; $6C7B
    ret                                           ; $6C7C


jr_003_6c7d:
    bit 1, a                                      ; $6C7D
    ret z                                         ; $6C7F

    ld a, [wHsSelected]                           ; $6C80
    ld c, a                                       ; $6C83
    ld b, $00                                     ; $6C84
    xor a                                         ; $6C86
    ld hl, wHotspotBlock                          ; $6C87
    add hl, bc                                    ; $6C8A
    ld [hl], a                                    ; $6C8B
    ld hl, wSpriteAnimFrame + $1                  ; $6C8C
    add hl, bc                                    ; $6C8F
    ld [hl], a                                    ; $6C90
    ld hl, wState                                 ; $6C91
    dec [hl]                                      ; $6C94
    ret                                           ; $6C95


; C: picks the sound of the hot spot
Mode1A_State05_PickSound::
    ld a, [wHsSelected]                           ; $6C96
    ld c, a                                       ; $6C99
    ld b, $00                                     ; $6C9A
    ld hl, wHotspotBlock + $f                     ; $6C9C
    add hl, bc                                    ; $6C9F
    ld d, $40                                     ; $6CA0
    call HotSpotEd_PickerScroll                   ; $6CA2
    call nz, HotSpotEd_ShowSound                  ; $6CA5
    ld bc, $1f78                                  ; $6CA8
    call HotSpotEd_DrawArrows                     ; $6CAB
    call HotSpotEd_DrawSoundIcon                  ; $6CAE
    call HotSpotEd_DrawEffectIcon                 ; $6CB1
    call HotSpotEd_DrawJumpIcon                   ; $6CB4
    call HotSpotEd_DrawButtonIcon                 ; $6CB7
    ld a, [wPickerScrollPhase]                    ; $6CBA
    and a                                         ; $6CBD
    ret nz                                        ; $6CBE

    ldh a, [hKeysNew]                             ; $6CBF
    and PADF_A | PADF_RIGHT                       ; $6CC1
    jr z, jr_003_6cd1                             ; $6CC3

    push af                                       ; $6CC5
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6CC6
    call Snd_Sfx1                                 ; $6CC8
    pop af                                        ; $6CCB
    ld hl, wState                                 ; $6CCC
    inc [hl]                                      ; $6CCF
    ret                                           ; $6CD0


jr_003_6cd1:
    ldh a, [hKeysNew]                             ; $6CD1
    bit PADB_B, a                                 ; $6CD3
    ret z                                         ; $6CD5

    call HotSpotEd_StoreSpotFields                ; $6CD6
    jr z, jr_003_6ce2                             ; $6CD9

    ld a, STATE_1A_PLACE_OR_DELETE                ; $6CDB
    ld [wState], a                                ; $6CDD
    jr jr_003_6ce7                                ; $6CE0

jr_003_6ce2:
    ld a, STATE_1A_BROWSE                         ; $6CE2
    ld [wState], a                                ; $6CE4

jr_003_6ce7:
    call HotSpotEd_PickerSlideOut                 ; $6CE7
    ret                                           ; $6CEA


; C: copies the edit variables back to the block; Z if the spot is not new
HotSpotEd_StoreSpotFields::
    ld a, [wHsSelected]                           ; $6CEB
    ld c, a                                       ; $6CEE
    ld b, $00                                     ; $6CEF
    ld hl, wHotspotBlock + $f                     ; $6CF1
    add hl, bc                                    ; $6CF4
    ld a, [wHsEditSound]                          ; $6CF5
    ld [hl], a                                    ; $6CF8
    ld hl, wHotspotBlock + $14                    ; $6CF9
    add hl, bc                                    ; $6CFC
    ld a, [wHsEditEffect]                         ; $6CFD
    ld [hl], a                                    ; $6D00
    ld hl, wHotspotBlock + $19                    ; $6D01
    add hl, bc                                    ; $6D04
    ld a, [wHsEditJump]                           ; $6D05
    ld [hl], a                                    ; $6D08
    ld a, [wHsIsNew]                              ; $6D09
    and a                                         ; $6D0C
    ret                                           ; $6D0D


; C: picks the transition effect 0..7
Mode1A_State06_PickEffect::
    ld a, [wHsSelected]                           ; $6D0E
    ld c, a                                       ; $6D11
    ld b, $00                                     ; $6D12
    ld hl, wHotspotBlock + $14                    ; $6D14
    add hl, bc                                    ; $6D17
    ld d, $07                                     ; $6D18
    call HotSpotEd_PickerScroll                   ; $6D1A
    call nz, HotSpotEd_ShowEffect                 ; $6D1D
    ld bc, $3f78                                  ; $6D20
    call HotSpotEd_DrawArrows                     ; $6D23
    call HotSpotEd_DrawSoundIcon                  ; $6D26
    call HotSpotEd_DrawEffectIcon                 ; $6D29
    call HotSpotEd_DrawJumpIcon                   ; $6D2C
    call HotSpotEd_DrawButtonIcon                 ; $6D2F
    ld a, [wPickerScrollPhase]                    ; $6D32
    and a                                         ; $6D35
    ret nz                                        ; $6D36

    ldh a, [hKeysNew]                             ; $6D37
    and PADF_A | PADF_RIGHT                       ; $6D39
    jr z, jr_003_6d49                             ; $6D3B

    push af                                       ; $6D3D
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6D3E
    call Snd_Sfx1                                 ; $6D40
    pop af                                        ; $6D43
    ld hl, wState                                 ; $6D44
    inc [hl]                                      ; $6D47
    ret                                           ; $6D48


jr_003_6d49:
    ldh a, [hKeysNew]                             ; $6D49
    and PADF_B | PADF_LEFT                        ; $6D4B
    ret z                                         ; $6D4D

    push af                                       ; $6D4E
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6D4F
    call Snd_Sfx1                                 ; $6D51
    pop af                                        ; $6D54
    ld hl, wState                                 ; $6D55
    dec [hl]                                      ; $6D58
    ret                                           ; $6D59


; C: picks the JUMP target photo
Mode1A_State07_PickJump::
    ld a, [wHsSelected]                           ; $6D5A
    ld c, a                                       ; $6D5D
    ld b, $00                                     ; $6D5E
    ld hl, wHotspotBlock + $19                    ; $6D60
    add hl, bc                                    ; $6D63
    ld a, [wPhotoCount]                           ; $6D64
    ld d, a                                       ; $6D67
    call HotSpotEd_PickerScroll                   ; $6D68
    call nz, HotSpotEd_ShowJump                   ; $6D6B
    ld bc, $6778                                  ; $6D6E
    call HotSpotEd_DrawArrows                     ; $6D71
    call HotSpotEd_DrawSoundIcon                  ; $6D74
    call HotSpotEd_DrawEffectIcon                 ; $6D77
    call HotSpotEd_DrawJumpIcon                   ; $6D7A
    call HotSpotEd_DrawButtonIcon                 ; $6D7D
    ld a, [wPickerScrollPhase]                    ; $6D80
    and a                                         ; $6D83
    ret nz                                        ; $6D84

    ldh a, [hKeysNew]                             ; $6D85
    and PADF_A | PADF_RIGHT                       ; $6D87
    jr z, jr_003_6d9c                             ; $6D89

    push af                                       ; $6D8B
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6D8C
    call Snd_Sfx1                                 ; $6D8E
    pop af                                        ; $6D91
    ld a, $01                                     ; $6D92
    ld [wPickerButtonAnim], a                     ; $6D94
    ld hl, wState                                 ; $6D97
    inc [hl]                                      ; $6D9A
    ret                                           ; $6D9B


jr_003_6d9c:
    ldh a, [hKeysNew]                             ; $6D9C
    and PADF_B | PADF_LEFT                        ; $6D9E
    ret z                                         ; $6DA0

    push af                                       ; $6DA1
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6DA2
    call Snd_Sfx1                                 ; $6DA4
    pop af                                        ; $6DA7
    ld hl, wState                                 ; $6DA8
    dec [hl]                                      ; $6DAB
    ret                                           ; $6DAC


; C: A confirms with the button animation; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 08 (1120 hits
; in 5 runs: 1A:08 x1120; tcrf_check/assets/mode_state_wp/)
Mode1A_State08_PickConfirm::
    call HotSpotEd_DrawSoundIcon                  ; $6DAD
    call HotSpotEd_DrawEffectIcon                 ; $6DB0
    call HotSpotEd_DrawJumpIcon                   ; $6DB3
    call HotSpotEd_DrawButtonIcon                 ; $6DB6
    ldh a, [hKeysNew]                             ; $6DB9
    bit PADB_A, a                                 ; $6DBB
    jr z, jr_003_6def                             ; $6DBD

    push af                                       ; $6DBF
    ld a, SFX1_KEY_A                              ; $6DC0
    call Snd_Sfx1                                 ; $6DC2
    pop af                                        ; $6DC5
    call Oam_HideUnused                           ; $6DC6
    rst Rst08_WaitVBlank                          ; $6DC9
    ld b, $0c                                     ; $6DCA

jr_003_6dcc:
    push bc                                       ; $6DCC
    ld a, $02                                     ; $6DCD
    ld [wPickerButtonAnim], a                     ; $6DCF
    call HotSpotEd_DrawSoundIcon                  ; $6DD2
    call HotSpotEd_DrawEffectIcon                 ; $6DD5
    call HotSpotEd_DrawJumpIcon                   ; $6DD8
    call HotSpotEd_DrawButtonIcon                 ; $6DDB
    call Oam_HideUnused                           ; $6DDE
    rst Rst08_WaitVBlank                          ; $6DE1
    pop bc                                        ; $6DE2
    dec b                                         ; $6DE3
    jr nz, jr_003_6dcc                            ; $6DE4

    call HotSpotEd_PickerSlideOut                 ; $6DE6
    ld a, STATE_1A_BROWSE                         ; $6DE9
    ld [wState], a                                ; $6DEB
    ret                                           ; $6DEE


jr_003_6def:
    ldh a, [hKeysNew]                             ; $6DEF
    and PADF_B | PADF_LEFT                        ; $6DF1
    ret z                                         ; $6DF3

    push af                                       ; $6DF4
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6DF5
    call Snd_Sfx1                                 ; $6DF7
    pop af                                        ; $6DFA
    xor a                                         ; $6DFB
    ld [wPickerButtonAnim], a                     ; $6DFC
    ld hl, wState                                 ; $6DFF
    dec [hl]                                      ; $6E02
    ret                                           ; $6E03


; C: keep / discard dialog; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 09 (1368 hits in 2 runs:
; 1A:09 x1368; tcrf_check/assets/mode_state_wp/)
Mode1A_State09_ExitDialog::
    call HotSpotEd_DialogChoiceA                  ; $6E04
    ldh a, [hKeysNew]                             ; $6E07
    bit PADB_A, a                                 ; $6E09
    jp z, Mode1A_State09_ExitDialog_Cancel        ; $6E0B

    ld a, [wDialogChoice]                         ; $6E0E
    and a                                         ; $6E11
    jr nz, jr_003_6e5d                            ; $6E12

    call HotSpotEd_DialogSlideOut                 ; $6E14
    ld a, BANK(Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete); $6E17
    ld hl, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete; $6E19
    ld de, $8c30                                  ; $6E1C
    ld bc, $00c0                                  ; $6E1F
    call Vram_CopyFromBank                        ; $6E22
    ld a, BANK(Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete); $6E25
    ld hl, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete; $6E27
    ld de, $8da0                                  ; $6E2A
    ld bc, $0040                                  ; $6E2D
    call Vram_CopyFromBank                        ; $6E30
    ld a, BANK(Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete); $6E33
    ld hl, Gfx_1C_51A0_Mode1A_State04_PlaceOrDelete; $6E35
    ld de, $8de0                                  ; $6E38
    ld bc, $0200                                  ; $6E3B
    call Vram_CopyFromBank                        ; $6E3E
    ld a, BANK(Map_0E_7F00_Mode1A_State04_PlaceOrDelete); $6E41
    ld hl, Map_0E_7F00_Mode1A_State04_PlaceOrDelete; $6E43
    ld de, $9c00                                  ; $6E46
    ld bc, $0120                                  ; $6E49
    call Vram_CopyFromBank                        ; $6E4C
    call HotSpotEd_PickerSlideIn                  ; $6E4F
    ld a, STATE_1A_PICK_SOUND                     ; $6E52
    ld [wState], a                                ; $6E54
    ld a, $01                                     ; $6E57
    ld [wDirtyFlag], a                            ; $6E59
    ret                                           ; $6E5C


jr_003_6e5d:
    call HotSpotEd_DialogSlideOut                 ; $6E5D
    ld a, BANK(Gfx_23_60C0_Mode1A_State09_ExitDialog); $6E60
    ld hl, Gfx_23_60C0_Mode1A_State09_ExitDialog  ; $6E62
    ld de, $8b00                                  ; $6E65
    ld bc, $0400                                  ; $6E68
    call Vram_CopyFromBank                        ; $6E6B
    ld a, BANK(Map_27_7630_Mode1A_State09_ExitDialog); $6E6E
    ld hl, Map_27_7630_Mode1A_State09_ExitDialog  ; $6E70
    ld de, $9c00                                  ; $6E73
    ld bc, $0120                                  ; $6E76
    call Vram_CopyFromBank                        ; $6E79
    ld a, BANK(Map_27_7710_Mode1A_State09_ExitDialog); $6E7C
    ld hl, Map_27_7710_Mode1A_State09_ExitDialog  ; $6E7E
    ld de, $9c80                                  ; $6E81
    ld bc, $0040                                  ; $6E84
    call Vram_CopyFromBank                        ; $6E87
    ld a, $01                                     ; $6E8A
    ld [wDialogChoice], a                         ; $6E8C
    call HotSpotEd_DialogSlideIn                  ; $6E8F
    ld a, STATE_1A_DELETE_DIALOG                  ; $6E92
    ld [wState], a                                ; $6E94
    ret                                           ; $6E97


; C: bit 1 of $FFA2 (B): slides the dialog out and returns to state 3 (branch target; code read 2026-10-19)
Mode1A_State09_ExitDialog_Cancel::
    bit 1, a                                      ; $6E98
    ret z                                         ; $6E9A

    call HotSpotEd_DialogSlideOut                 ; $6E9B
    ld a, STATE_1A_BROWSE                         ; $6E9E
    ld [wState], a                                ; $6EA0
    ret                                           ; $6EA3


; C: Left / Right toggles dialog_choice and swaps the dialog tiles. L3 pass 2026-10-26: executed in BGB in 2 replay(s)
; of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DialogChoiceA::
    ldh a, [hKeysNew]                             ; $6EA4
    ld b, a                                       ; $6EA6
    bit PADB_LEFT, a                              ; $6EA7
    jr z, jr_003_6eae                             ; $6EA9

    xor a                                         ; $6EAB
    jr jr_003_6eb3                                ; $6EAC

jr_003_6eae:
    bit 4, a                                      ; $6EAE
    ret z                                         ; $6EB0

    ld a, $01                                     ; $6EB1

jr_003_6eb3:
    ld hl, wDialogChoice                          ; $6EB3
    cp [hl]                                       ; $6EB6
    ret z                                         ; $6EB7

    ld [hl], a                                    ; $6EB8
    push af                                       ; $6EB9
    ld a, SFX1_STEP_FAST                          ; $6EBA
    call Snd_Sfx1                                 ; $6EBC
    pop af                                        ; $6EBF
    and a                                         ; $6EC0
    jr nz, jr_003_6ed2                            ; $6EC1

    ld a, BANK(Map_27_77D0_HotSpotEd_DialogChoiceA); $6EC3
    ld hl, Map_27_77D0_HotSpotEd_DialogChoiceA    ; $6EC5
    ld de, $9c80                                  ; $6EC8
    ld bc, $0040                                  ; $6ECB
    call Vram_CopyFromBank                        ; $6ECE
    ret                                           ; $6ED1


jr_003_6ed2:
    ld a, BANK(Map_27_7830_HotSpotEd_DialogChoiceA); $6ED2
    ld hl, Map_27_7830_HotSpotEd_DialogChoiceA    ; $6ED4
    ld de, $9c80                                  ; $6ED7
    ld bc, $0040                                  ; $6EDA
    call Vram_CopyFromBank                        ; $6EDD
    ret                                           ; $6EE0


; C: delete this hot spot? dialog; BGB watchpoint pass 2026-10-25: ran only in mode 1A and state 0A (252 hits in 1
; runs: 1A:0A x252; tcrf_check/assets/mode_state_wp/)
Mode1A_State0A_DeleteDialog::
    call HotSpotEd_DialogChoiceB                  ; $6EE1
    ldh a, [hKeysNew]                             ; $6EE4
    bit PADB_A, a                                 ; $6EE6
    jr z, jr_003_6f1c                             ; $6EE8

    ld a, [wDialogChoice]                         ; $6EEA
    and a                                         ; $6EED
    jr nz, jr_003_6f28                            ; $6EEE

    push af                                       ; $6EF0
    ld a, SFX3_DELETE_DIALOG_FIRST                ; $6EF1
    call Snd_Sfx3                                 ; $6EF3
    pop af                                        ; $6EF6
    ld bc, $000a                                  ; $6EF7
    call Wait_Frames                              ; $6EFA
    call HotSpotEd_DialogSlideOut                 ; $6EFD
    ld a, [wHsSelected]                           ; $6F00
    ld c, a                                       ; $6F03
    ld b, $00                                     ; $6F04
    xor a                                         ; $6F06
    ld hl, wHotspotBlock                          ; $6F07
    add hl, bc                                    ; $6F0A
    ld [hl], a                                    ; $6F0B
    ld hl, wSpriteAnimFrame + $1                  ; $6F0C
    add hl, bc                                    ; $6F0F
    ld [hl], a                                    ; $6F10
    ld a, STATE_1A_BROWSE                         ; $6F11
    ld [wState], a                                ; $6F13
    ld a, $01                                     ; $6F16
    ld [wDirtyFlag], a                            ; $6F18
    ret                                           ; $6F1B


jr_003_6f1c:
    bit 1, a                                      ; $6F1C
    ret z                                         ; $6F1E

    call HotSpotEd_DialogSlideOut                 ; $6F1F
    ld a, STATE_1A_BROWSE                         ; $6F22
    ld [wState], a                                ; $6F24
    ret                                           ; $6F27


jr_003_6f28:
    push af                                       ; $6F28
    ld a, SFX3_DELETE_DIALOG_SECOND               ; $6F29
    call Snd_Sfx3                                 ; $6F2B
    pop af                                        ; $6F2E
    ld bc, $000a                                  ; $6F2F
    call Wait_Frames                              ; $6F32
    call HotSpotEd_DialogSlideOut                 ; $6F35
    ld a, STATE_1A_BROWSE                         ; $6F38
    ld [wState], a                                ; $6F3A
    ret                                           ; $6F3D


; C: same for the delete dialog. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogChoiceB::
    ldh a, [hKeysNew]                             ; $6F3E
    ld b, a                                       ; $6F40
    bit PADB_LEFT, a                              ; $6F41
    jr z, jr_003_6f48                             ; $6F43

    xor a                                         ; $6F45
    jr jr_003_6f4d                                ; $6F46

jr_003_6f48:
    bit 4, a                                      ; $6F48
    ret z                                         ; $6F4A

    ld a, $01                                     ; $6F4B

jr_003_6f4d:
    ld hl, wDialogChoice                          ; $6F4D
    cp [hl]                                       ; $6F50
    ret z                                         ; $6F51

    ld [hl], a                                    ; $6F52
    push af                                       ; $6F53
    ld a, SFX1_STEP_FAST                          ; $6F54
    call Snd_Sfx1                                 ; $6F56
    pop af                                        ; $6F59
    and a                                         ; $6F5A
    jr nz, jr_003_6f6c                            ; $6F5B

    ld a, BANK(Map_27_76B0_HotSpotEd_DialogChoiceB); $6F5D
    ld hl, Map_27_76B0_HotSpotEd_DialogChoiceB    ; $6F5F
    ld de, $9c80                                  ; $6F62
    ld bc, $0040                                  ; $6F65
    call Vram_CopyFromBank                        ; $6F68
    ret                                           ; $6F6B


jr_003_6f6c:
    ld a, BANK(Map_27_7710_Mode1A_State09_ExitDialog); $6F6C
    ld hl, Map_27_7710_Mode1A_State09_ExitDialog  ; $6F6E
    ld de, $9c80                                  ; $6F71
    ld bc, $0040                                  ; $6F74
    call Vram_CopyFromBank                        ; $6F77
    ret                                           ; $6F7A


; C: ret
Mode1A_State0B_Unused::
    ret                                           ; $6F7B


; C: fades out and returns to state 0
Mode1A_State0C_Exit::
    call Pal_FadeOut                              ; $6F7C
    call Lcd_Off                                  ; $6F7F
    ld hl, hStatShadow                            ; $6F82
    res 6, [hl]                                   ; $6F85
    ld hl, rIE                                    ; $6F87
    res 1, [hl]                                   ; $6F8A
    ld a, STATE_1A_INIT                           ; $6F8C
    ld [wState], a                                ; $6F8E
    ret                                           ; $6F91


; C: selects the save dialog parameters
Mode1A_State0D_SavePrepare::
    ld a, $02                                     ; $6F92
    ld [wSaveDialogWhat], a                       ; $6F94
    ld a, [wCopyPhotoIdxE]                        ; $6F97
    ld [wSaveTargetPhoto], a                      ; $6F9A
    xor a                                         ; $6F9D
    ld [wSubstate], a                             ; $6F9E
    ld hl, wState                                 ; $6FA1
    inc [hl]                                      ; $6FA4
    ret                                           ; $6FA5


; C: far call 07:699C (save routine)
Mode1A_State0E_FarSaveRoutine::
    ldh [hFarcallAArg], a                         ; $6FA6
    ld a, BANK(SaveDialog_Far)                    ; $6FA8
    ld hl, SaveDialog_Far                         ; $6FAA
    call Far_Call                                 ; $6FAD
    ret                                           ; $6FB0


; C: back to browsing or exit
Mode1A_State0F_SaveResult::
    ld a, [wSaveDialogResult]                     ; $6FB1
    and a                                         ; $6FB4
    jr nz, jr_003_6fbd                            ; $6FB5

    ld a, STATE_1A_EXIT                           ; $6FB7
    ld [wState], a                                ; $6FB9
    ret                                           ; $6FBC


jr_003_6fbd:
    ld a, STATE_1A_BROWSE                         ; $6FBD
    ld [wState], a                                ; $6FBF
    ret                                           ; $6FC2


; C: draws the five hot-spot slot sprites (blinking when not selected)
HotSpotEd_DrawSlots::
    ld a, [wHsSelected]                           ; $6FC3
    cp $ff                                        ; $6FC6
    jr nz, jr_003_6fcb                            ; $6FC8

    xor a                                         ; $6FCA

jr_003_6fcb:
    ld c, a                                       ; $6FCB
    ld b, $05                                     ; $6FCC

; C: per-slot loop top (B counts the slots, C the slot number): draws the slot icon when it is the cursor slot or its
; flag is set (branch target; code read 2026-10-19)
HotSpotEd_DrawSlots_SlotLoop::
    push bc                                       ; $6FCE
    ld b, $00                                     ; $6FCF
    ld de, $0000                                  ; $6FD1
    ld a, [wHsSelected]                           ; $6FD4
    cp c                                          ; $6FD7
    jr z, jr_003_6fe1                             ; $6FD8

    ldh a, [hFrameCounter]                        ; $6FDA
    xor c                                         ; $6FDC
    and $01                                       ; $6FDD
    jr z, jr_003_7032                             ; $6FDF

jr_003_6fe1:
    ld hl, wHotspotBlock                          ; $6FE1
    add hl, bc                                    ; $6FE4
    bit 0, [hl]                                   ; $6FE5
    call nz, HotSpotEd_SlotIconFlags              ; $6FE7
    ld hl, HotSpotEd_SlotAnimTbl                  ; $6FEA
    add hl, de                                    ; $6FED
    ld e, [hl]                                    ; $6FEE
    add hl, de                                    ; $6FEF
    push hl                                       ; $6FF0
    ld hl, wSpriteAnimFrame + $1                  ; $6FF1
    add hl, bc                                    ; $6FF4
    ld e, [hl]                                    ; $6FF5
    sla e                                         ; $6FF6
    pop hl                                        ; $6FF8
    add hl, de                                    ; $6FF9
    ld a, [hl+]                                   ; $6FFA
    push hl                                       ; $6FFB
    push bc                                       ; $6FFC
    push af                                       ; $6FFD
    call HotSpotEd_SlotXY                         ; $6FFE
    pop af                                        ; $7001
    call Oam_AddMeta_B01_4000                     ; $7002
    pop bc                                        ; $7005
    ld hl, wSpriteAnimTick + $1                   ; $7006
    add hl, bc                                    ; $7009
    ld a, [hl]                                    ; $700A
    pop hl                                        ; $700B
    cp [hl]                                       ; $700C
    jr c, jr_003_702d                             ; $700D

    inc hl                                        ; $700F
    ld a, [hl]                                    ; $7010
    cp $ff                                        ; $7011
    jr nz, jr_003_7022                            ; $7013

    xor a                                         ; $7015
    ld hl, wSpriteAnimFrame + $1                  ; $7016
    add hl, bc                                    ; $7019
    ld [hl], a                                    ; $701A
    ld hl, wSpriteAnimTick + $1                   ; $701B
    add hl, bc                                    ; $701E
    ld [hl], a                                    ; $701F
    jr jr_003_702d                                ; $7020

jr_003_7022:
    ld hl, wSpriteAnimFrame + $1                  ; $7022
    add hl, bc                                    ; $7025
    inc [hl]                                      ; $7026
    xor a                                         ; $7027
    ld hl, wSpriteAnimTick + $1                   ; $7028
    add hl, bc                                    ; $702B
    ld [hl], a                                    ; $702C

jr_003_702d:
    ld hl, wSpriteAnimTick + $1                   ; $702D
    add hl, bc                                    ; $7030
    inc [hl]                                      ; $7031

jr_003_7032:
    pop bc                                        ; $7032
    ld a, c                                       ; $7033
    inc a                                         ; $7034
    cp $05                                        ; $7035
    jr nz, jr_003_703a                            ; $7037

    xor a                                         ; $7039

jr_003_703a:
    ld c, a                                       ; $703A
    dec b                                         ; $703B
    jp nz, HotSpotEd_DrawSlots_SlotLoop           ; $703C

    ret                                           ; $703F


; C: E = bit mask of the fields (sound / effect / jump) that are set. L3 pass 2026-10-26: executed in BGB in 8
; replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotIconFlags::
    ld hl, wHotspotBlock + $f                     ; $7040
    add hl, bc                                    ; $7043
    ld a, [hl]                                    ; $7044
    cp $ff                                        ; $7045
    jr z, jr_003_704b                             ; $7047

    set 0, e                                      ; $7049

jr_003_704b:
    ld hl, wHotspotBlock + $14                    ; $704B
    add hl, bc                                    ; $704E
    ld a, [hl]                                    ; $704F
    cp $ff                                        ; $7050
    jr z, jr_003_7056                             ; $7052

    set 1, e                                      ; $7054

jr_003_7056:
    ld hl, wHotspotBlock + $19                    ; $7056
    add hl, bc                                    ; $7059
    ld a, [hl]                                    ; $705A
    cp $ff                                        ; $705B
    jr z, jr_003_7061                             ; $705D

    set 2, e                                      ; $705F

jr_003_7061:
    ret                                           ; $7061


; C: B / C = screen position of slot C. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus,
; modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotXY::
    ld hl, wHotspotBlock                          ; $7062
    add hl, bc                                    ; $7065
    bit 0, [hl]                                   ; $7066
    jr z, jr_003_7087                             ; $7068

    ld hl, wHotspotBlock + $5                     ; $706A
    add hl, bc                                    ; $706D
    ld a, [hl]                                    ; $706E
    sla a                                         ; $706F
    sla a                                         ; $7071
    sla a                                         ; $7073
    add $18                                       ; $7075
    ld hl, wHotspotBlock + $a                     ; $7077
    add hl, bc                                    ; $707A
    ld b, a                                       ; $707B
    ld a, [hl]                                    ; $707C
    sla a                                         ; $707D
    sla a                                         ; $707F
    sla a                                         ; $7081
    add $18                                       ; $7083
    ld c, a                                       ; $7085
    ret                                           ; $7086


jr_003_7087:
    ld a, c                                       ; $7087
    sla a                                         ; $7088
    add c                                         ; $708A
    sla a                                         ; $708B
    sla a                                         ; $708D
    sla a                                         ; $708F
    add $20                                       ; $7091
    ld b, a                                       ; $7093
    ld c, $88                                     ; $7094
    ret                                           ; $7096


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
    ld a, [wHsCursorX]                            ; $7117
    sla a                                         ; $711A
    sla a                                         ; $711C
    sla a                                         ; $711E
    add $18                                       ; $7120
    ld b, a                                       ; $7122
    ld a, [wHsCursorY]                            ; $7123
    sla a                                         ; $7126
    sla a                                         ; $7128
    sla a                                         ; $712A
    add $20                                       ; $712C
    ld c, a                                       ; $712E
    ld a, [wSpriteAnimFrame]                      ; $712F
    sla a                                         ; $7132
    ld e, a                                       ; $7134
    ld d, $00                                     ; $7135
    ld hl, HotSpotEd_DrawPointer_Tbl715A          ; $7137
    add hl, de                                    ; $713A
    ld a, [hl+]                                   ; $713B
    call Oam_AddMeta_B01_4000                     ; $713C
    ld a, [wSpriteAnimTick]                       ; $713F
    cp [hl]                                       ; $7142
    jr nz, jr_003_714d                            ; $7143

    ld hl, wSpriteAnimFrame                       ; $7145
    inc [hl]                                      ; $7148
    xor a                                         ; $7149
    ld [wSpriteAnimTick], a                       ; $714A

jr_003_714d:
    ld a, [wSpriteAnimFrame]                      ; $714D
    and a                                         ; $7150
    ret z                                         ; $7151

    cp $03                                        ; $7152
    ret z                                         ; $7154

    ld hl, wSpriteAnimTick                        ; $7155
    inc [hl]                                      ; $7158
    ret                                           ; $7159


; C: auto: 8 bytes, bytes; referenced by HotSpotEd_DrawPointer. L3 pass 2026-10-26: read in BGB in 9 replay(s) of the
; organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawPointer_Tbl715A::
    db $a0, $06, $a1, $06, $9f, $06, $9f, $ff

; C: animated pointer in slot-selection mode
HotSpotEd_DrawSlotPointer::
    ld a, [wHsCursorX]                            ; $7162
    ld b, a                                       ; $7165
    sla a                                         ; $7166
    add b                                         ; $7168
    sla a                                         ; $7169
    sla a                                         ; $716B
    sla a                                         ; $716D
    add $20                                       ; $716F
    ld b, a                                       ; $7171
    ld c, $7a                                     ; $7172
    ld a, [wSpriteAnimFrame]                      ; $7174
    sla a                                         ; $7177
    ld e, a                                       ; $7179
    ld d, $00                                     ; $717A
    ld hl, HotSpotEd_DrawSlotPointer_Tbl719F      ; $717C
    add hl, de                                    ; $717F
    ld a, [hl+]                                   ; $7180
    call Oam_AddMeta_B01_4000                     ; $7181
    ld a, [wSpriteAnimTick]                       ; $7184
    cp [hl]                                       ; $7187
    jr nz, jr_003_7192                            ; $7188

    ld hl, wSpriteAnimFrame                       ; $718A
    inc [hl]                                      ; $718D
    xor a                                         ; $718E
    ld [wSpriteAnimTick], a                       ; $718F

jr_003_7192:
    ld a, [wSpriteAnimFrame]                      ; $7192
    and a                                         ; $7195
    ret z                                         ; $7196

    cp $03                                        ; $7197
    ret z                                         ; $7199

    ld hl, wSpriteAnimTick                        ; $719A
    inc [hl]                                      ; $719D
    ret                                           ; $719E


; C: auto: 8 bytes, bytes; referenced by HotSpotEd_DrawSlotPointer. L3 pass 2026-10-26: read in BGB in 10 replay(s) of
; the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawSlotPointer_Tbl719F::
    db $bc, $06, $bd, $06, $bb, $06, $bb, $ff

; C: D-pad moves the pointer; Down at the bottom switches to slot selection
HotSpotEd_PointerMove::
    ldh a, [hKeysNewRepeat]                       ; $71A7
    ld b, a                                       ; $71A9
    ld a, [wHsCursorX]                            ; $71AA
    call HotSpotEd_PointerMoveX                   ; $71AD
    ld [wHsCursorX], a                            ; $71B0
    ld a, [wHsCursorY]                            ; $71B3
    call HotSpotEd_PointerMoveY                   ; $71B6
    ld [wHsCursorY], a                            ; $71B9
    ld a, $ff                                     ; $71BC
    ld [wHsSelected], a                           ; $71BE
    ld a, [wHsCursorMode]                         ; $71C1
    and a                                         ; $71C4
    ret z                                         ; $71C5

    ld a, [wHsCursorX]                            ; $71C6
    ld c, $00                                     ; $71C9

jr_003_71cb:
    cp $03                                        ; $71CB
    jr c, jr_003_71d4                             ; $71CD

    sub $03                                       ; $71CF
    inc c                                         ; $71D1
    jr jr_003_71cb                                ; $71D2

jr_003_71d4:
    ld a, c                                       ; $71D4
    ld [wHsCursorX], a                            ; $71D5
    ret                                           ; $71D8


; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PointerMoveX::
    bit 5, b                                      ; $71D9
    jr z, jr_003_71e8                             ; $71DB

    and a                                         ; $71DD
    ret z                                         ; $71DE

    push af                                       ; $71DF
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $71E0
    call Snd_Sfx1                                 ; $71E2
    pop af                                        ; $71E5
    dec a                                         ; $71E6
    ret                                           ; $71E7


jr_003_71e8:
    bit 4, b                                      ; $71E8
    ret z                                         ; $71EA

    cp $0e                                        ; $71EB
    ret z                                         ; $71ED

    push af                                       ; $71EE
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $71EF
    call Snd_Sfx1                                 ; $71F1
    pop af                                        ; $71F4
    inc a                                         ; $71F5
    ret                                           ; $71F6


; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PointerMoveY::
    bit 6, b                                      ; $71F7
    jr z, jr_003_7206                             ; $71F9

    and a                                         ; $71FB
    ret z                                         ; $71FC

    dec a                                         ; $71FD
    push af                                       ; $71FE
    ld a, SFX1_KEY_UP_DOWN                        ; $71FF
    call Snd_Sfx1                                 ; $7201
    pop af                                        ; $7204
    ret                                           ; $7205


jr_003_7206:
    bit 7, b                                      ; $7206
    ret z                                         ; $7208

    cp $0c                                        ; $7209
    jr z, jr_003_7216                             ; $720B

    push af                                       ; $720D
    ld a, SFX1_KEY_UP_DOWN                        ; $720E
    call Snd_Sfx1                                 ; $7210
    pop af                                        ; $7213
    inc a                                         ; $7214
    ret                                           ; $7215


jr_003_7216:
    push af                                       ; $7216
    ld a, SFX1_KEY_UP_DOWN                        ; $7217
    call Snd_Sfx1                                 ; $7219
    pop af                                        ; $721C
    push af                                       ; $721D
    ld a, $01                                     ; $721E
    ld [wHsCursorMode], a                         ; $7220
    pop af                                        ; $7223
    ret                                           ; $7224


; C: Left / Right selects the slot
HotSpotEd_SlotMove::
    ldh a, [hKeysNewRepeat]                       ; $7225
    ld b, a                                       ; $7227
    ld a, [wHsCursorX]                            ; $7228
    call HotSpotEd_SlotMoveX                      ; $722B
    ld [wHsCursorX], a                            ; $722E
    ld [wHsSelected], a                           ; $7231
    call HotSpotEd_SlotMoveUp                     ; $7234
    ld a, [wHsCursorMode]                         ; $7237
    and a                                         ; $723A
    ret nz                                        ; $723B

    ld a, [wHsCursorX]                            ; $723C
    ld c, a                                       ; $723F
    sla a                                         ; $7240
    add c                                         ; $7242
    inc a                                         ; $7243
    ld [wHsCursorX], a                            ; $7244
    ret                                           ; $7247


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotMoveX::
    bit 5, b                                      ; $7248
    jr z, jr_003_7257                             ; $724A

    and a                                         ; $724C
    ret z                                         ; $724D

    push af                                       ; $724E
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $724F
    call Snd_Sfx1                                 ; $7251
    pop af                                        ; $7254
    dec a                                         ; $7255
    ret                                           ; $7256


jr_003_7257:
    bit 4, b                                      ; $7257
    ret z                                         ; $7259

    cp $04                                        ; $725A
    ret z                                         ; $725C

    push af                                       ; $725D
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $725E
    call Snd_Sfx1                                 ; $7260
    pop af                                        ; $7263
    inc a                                         ; $7264
    ret                                           ; $7265


; C: L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_SlotMoveUp::
    bit 6, b                                      ; $7266
    ret z                                         ; $7268

    push af                                       ; $7269
    ld a, SFX1_KEY_UP_DOWN                        ; $726A
    call Snd_Sfx1                                 ; $726C
    pop af                                        ; $726F
    xor a                                         ; $7270
    ld [wHsCursorMode], a                         ; $7271
    ret                                           ; $7274


; C: D-pad moves the selected spot over the photo
HotSpotEd_MoveSpot::
    ldh a, [hKeysNewRepeat]                       ; $7275
    ld b, a                                       ; $7277
    ld a, [wHsSelected]                           ; $7278
    ld e, a                                       ; $727B
    ld d, $00                                     ; $727C
    ld hl, wHotspotBlock + $5                     ; $727E
    add hl, de                                    ; $7281
    ld a, [hl]                                    ; $7282
    call HotSpotEd_MoveSpotX                      ; $7283
    ld [hl], a                                    ; $7286
    ld hl, wHotspotBlock + $a                     ; $7287
    add hl, de                                    ; $728A
    ld a, [hl]                                    ; $728B
    call HotSpotEd_MoveSpotY                      ; $728C
    ld [hl], a                                    ; $728F
    ret                                           ; $7290


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_MoveSpotX::
    bit 5, b                                      ; $7291
    jr z, jr_003_72a0                             ; $7293

    and a                                         ; $7295
    ret z                                         ; $7296

    push af                                       ; $7297
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7298
    call Snd_Sfx1                                 ; $729A
    pop af                                        ; $729D
    dec a                                         ; $729E
    ret                                           ; $729F


jr_003_72a0:
    bit 4, b                                      ; $72A0
    ret z                                         ; $72A2

    cp $0e                                        ; $72A3
    ret z                                         ; $72A5

    push af                                       ; $72A6
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $72A7
    call Snd_Sfx1                                 ; $72A9
    pop af                                        ; $72AC
    inc a                                         ; $72AD
    ret                                           ; $72AE


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_MoveSpotY::
    bit 6, b                                      ; $72AF
    jr z, jr_003_72be                             ; $72B1

    and a                                         ; $72B3
    ret z                                         ; $72B4

    dec a                                         ; $72B5
    push af                                       ; $72B6
    ld a, SFX1_KEY_UP_DOWN                        ; $72B7
    call Snd_Sfx1                                 ; $72B9
    pop af                                        ; $72BC
    ret                                           ; $72BD


jr_003_72be:
    bit 7, b                                      ; $72BE
    ret z                                         ; $72C0

    cp $0c                                        ; $72C1
    ret z                                         ; $72C3

    push af                                       ; $72C4
    ld a, SFX1_KEY_UP_DOWN                        ; $72C5
    call Snd_Sfx1                                 ; $72C7
    pop af                                        ; $72CA
    inc a                                         ; $72CB
    ret                                           ; $72CC


; C: carry and C = index when a spot is at the pointer position
HotSpot_FindUnderPointer::
    ld bc, $0500                                  ; $72CD

jr_003_72d0:
    push bc                                       ; $72D0
    ld b, $00                                     ; $72D1
    ld hl, wHotspotBlock                          ; $72D3
    add hl, bc                                    ; $72D6
    ld a, [hl]                                    ; $72D7
    and a                                         ; $72D8
    jr z, jr_003_72f2                             ; $72D9

    ld hl, wHotspotBlock + $5                     ; $72DB
    add hl, bc                                    ; $72DE
    ld a, [wHsCursorX]                            ; $72DF
    cp [hl]                                       ; $72E2
    jr nz, jr_003_72f2                            ; $72E3

    ld hl, wHotspotBlock + $a                     ; $72E5
    add hl, bc                                    ; $72E8
    ld a, [wHsCursorY]                            ; $72E9
    cp [hl]                                       ; $72EC
    jr nz, jr_003_72f2                            ; $72ED

    pop bc                                        ; $72EF
    scf                                           ; $72F0
    ret                                           ; $72F1


jr_003_72f2:
    pop bc                                        ; $72F2
    inc c                                         ; $72F3
    dec b                                         ; $72F4
    jr nz, jr_003_72d0                            ; $72F5

    and a                                         ; $72F7
    ret                                           ; $72F8


; C: slides the picker window out (WY table 00:2FE5) keeping the icons drawn
HotSpotEd_PickerSlideOut::
    push af                                       ; $72F9
    ld a, SFX1_PANEL_OPEN                         ; $72FA
    call Snd_Sfx1                                 ; $72FC
    pop af                                        ; $72FF
    ld hl, Slide_WyDeltaTbl                       ; $7300
    ld b, $24                                     ; $7303

jr_003_7305:
    push bc                                       ; $7305
    push hl                                       ; $7306
    ldh a, [hWyShadow]                            ; $7307
    add [hl]                                      ; $7309
    ldh [hWyShadow], a                            ; $730A
    call HotSpotEd_DrawSoundIcon                  ; $730C
    call HotSpotEd_DrawEffectIcon                 ; $730F
    call HotSpotEd_DrawJumpIcon                   ; $7312
    call HotSpotEd_DrawButtonIcon                 ; $7315
    call Oam_HideUnused                           ; $7318
    rst Rst08_WaitVBlank                          ; $731B
    pop hl                                        ; $731C
    pop bc                                        ; $731D
    inc hl                                        ; $731E
    dec b                                         ; $731F
    jr nz, jr_003_7305                            ; $7320

    call HotSpotEd_ClearAnim                      ; $7322
    ret                                           ; $7325


; C: draws the three pickers and slides the window in
HotSpotEd_PickerSlideIn::
    xor a                                         ; $7326
    ld [wPickerScrollPhase], a                    ; $7327
    ld [wPickerDir], a                            ; $732A
    ld [wPickerButtonAnim], a                     ; $732D
    call HotSpotEd_ShowSound                      ; $7330
    call HotSpotEd_ShowEffect                     ; $7333
    call HotSpotEd_ShowJump                       ; $7336
    rst Rst08_WaitVBlank                          ; $7339
    push af                                       ; $733A
    ld a, SFX1_PANEL_CLOSE                        ; $733B
    call Snd_Sfx1                                 ; $733D
    pop af                                        ; $7340
    ld hl, Slide_WyDeltaTbl                       ; $7341
    ld b, $24                                     ; $7344

jr_003_7346:
    push bc                                       ; $7346
    push hl                                       ; $7347
    ldh a, [hWyShadow]                            ; $7348
    sub [hl]                                      ; $734A
    ldh [hWyShadow], a                            ; $734B
    call HotSpotEd_DrawSoundIcon                  ; $734D
    call HotSpotEd_DrawEffectIcon                 ; $7350
    call HotSpotEd_DrawJumpIcon                   ; $7353
    call HotSpotEd_DrawButtonIcon                 ; $7356
    call Oam_HideUnused                           ; $7359
    rst Rst08_WaitVBlank                          ; $735C
    pop hl                                        ; $735D
    pop bc                                        ; $735E
    inc hl                                        ; $735F
    dec b                                         ; $7360
    jr nz, jr_003_7346                            ; $7361

    call HotSpotEd_DrawSoundIcon                  ; $7363
    call HotSpotEd_DrawEffectIcon                 ; $7366
    call HotSpotEd_DrawJumpIcon                   ; $7369
    call HotSpotEd_DrawButtonIcon                 ; $736C
    ret                                           ; $736F


; C: slides a dialog out. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogSlideOut::
    push af                                       ; $7370
    ld a, SFX1_PANEL_OPEN                         ; $7371
    call Snd_Sfx1                                 ; $7373
    pop af                                        ; $7376
    ld hl, Slide_WyDeltaTbl                       ; $7377
    ld b, $24                                     ; $737A

jr_003_737c:
    push bc                                       ; $737C
    push hl                                       ; $737D
    ldh a, [hWyShadow]                            ; $737E
    add [hl]                                      ; $7380
    ldh [hWyShadow], a                            ; $7381
    rst Rst08_WaitVBlank                          ; $7383
    pop hl                                        ; $7384
    pop bc                                        ; $7385
    inc hl                                        ; $7386
    dec b                                         ; $7387
    jr nz, jr_003_737c                            ; $7388

    ret                                           ; $738A


; C: slides a dialog in. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_DialogSlideIn::
    push af                                       ; $738B
    ld a, SFX1_PANEL_CLOSE                        ; $738C
    call Snd_Sfx1                                 ; $738E
    pop af                                        ; $7391
    xor a                                         ; $7392
    ld hl, Slide_WyDeltaTbl                       ; $7393
    ld b, $24                                     ; $7396

jr_003_7398:
    push bc                                       ; $7398
    push hl                                       ; $7399
    ldh a, [hWyShadow]                            ; $739A
    sub [hl]                                      ; $739C
    ldh [hWyShadow], a                            ; $739D
    rst Rst08_WaitVBlank                          ; $739F
    pop hl                                        ; $73A0
    pop bc                                        ; $73A1
    inc hl                                        ; $73A2
    dec b                                         ; $73A3
    jr nz, jr_003_7398                            ; $73A4

    ret                                           ; $73A6


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawSoundIcon::
    ld a, [wHsSelected]                           ; $73A7
    ld c, a                                       ; $73AA
    ld b, $00                                     ; $73AB
    ld hl, wHotspotBlock + $f                     ; $73AD
    add hl, bc                                    ; $73B0
    ld e, $ca                                     ; $73B1
    ld a, [hl]                                    ; $73B3
    cp $20                                        ; $73B4
    jr c, jr_003_73be                             ; $73B6

    cp $ff                                        ; $73B8
    jr nz, jr_003_73bf                            ; $73BA

    inc e                                         ; $73BC
    inc e                                         ; $73BD

jr_003_73be:
    inc e                                         ; $73BE

jr_003_73bf:
    ld b, $1f                                     ; $73BF
    ldh a, [hWyShadow]                            ; $73C1
    add $21                                       ; $73C3
    ld c, a                                       ; $73C5
    ld a, e                                       ; $73C6
    call Oam_AddMeta_B01_4000                     ; $73C7
    ret                                           ; $73CA


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawEffectIcon::
    ld a, [wHsSelected]                           ; $73CB
    ld c, a                                       ; $73CE
    ld b, $00                                     ; $73CF
    ld hl, wHotspotBlock + $14                    ; $73D1
    add hl, bc                                    ; $73D4
    ld e, $cc                                     ; $73D5
    ld a, [hl]                                    ; $73D7
    cp $ff                                        ; $73D8
    jr nz, jr_003_73dd                            ; $73DA

    inc e                                         ; $73DC

jr_003_73dd:
    ld b, $3f                                     ; $73DD
    ldh a, [hWyShadow]                            ; $73DF
    add $21                                       ; $73E1
    ld c, a                                       ; $73E3
    ld a, e                                       ; $73E4
    call Oam_AddMeta_B01_4000                     ; $73E5
    ret                                           ; $73E8


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawJumpIcon::
    ld a, [wHsSelected]                           ; $73E9
    ld c, a                                       ; $73EC
    ld b, $00                                     ; $73ED
    ld hl, wHotspotBlock + $19                    ; $73EF
    add hl, bc                                    ; $73F2
    ld e, $ce                                     ; $73F3
    ld a, [hl]                                    ; $73F5
    cp $ff                                        ; $73F6
    jr nz, jr_003_73fb                            ; $73F8

    dec e                                         ; $73FA

jr_003_73fb:
    ld b, $67                                     ; $73FB
    ldh a, [hWyShadow]                            ; $73FD
    add $21                                       ; $73FF
    ld c, a                                       ; $7401
    ld a, e                                       ; $7402
    call Oam_AddMeta_B01_4000                     ; $7403
    ret                                           ; $7406


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_DrawButtonIcon::
    ld b, $82                                     ; $7407
    ldh a, [hWyShadow]                            ; $7409
    add $18                                       ; $740B
    ld c, a                                       ; $740D
    ld a, [wPickerButtonAnim]                     ; $740E
    and a                                         ; $7411
    jr nz, jr_003_741a                            ; $7412

    ld a, $d2                                     ; $7414
    call Oam_AddMeta_B01_4000                     ; $7416
    ret                                           ; $7419


jr_003_741a:
    cp $01                                        ; $741A
    jr nz, jr_003_7424                            ; $741C

    ld a, $d3                                     ; $741E
    call Oam_AddMeta_B01_4000                     ; $7420
    ret                                           ; $7423


jr_003_7424:
    ldh a, [hFrameCounter]                        ; $7424
    srl a                                         ; $7426
    srl a                                         ; $7428
    and $01                                       ; $742A
    add $d2                                       ; $742C
    call Oam_AddMeta_B01_4000                     ; $742E
    ret                                           ; $7431


; C: shows the number of the chosen sound
HotSpotEd_ShowSound::
    ld de, $8d30                                  ; $7432
    ld a, [wHsSelected]                           ; $7435
    ld c, a                                       ; $7438
    ld b, $00                                     ; $7439
    ld hl, wHotspotBlock + $f                     ; $743B
    add hl, bc                                    ; $743E
    ld a, [hl]                                    ; $743F
    cp $1f                                        ; $7440
    jr nz, jr_003_744a                            ; $7442

    ld a, [wPickerScrollPhase]                    ; $7444
    and a                                         ; $7447
    jr nz, jr_003_7459                            ; $7448

jr_003_744a:
    ld a, [hl]                                    ; $744A
    cp $ff                                        ; $744B
    jr z, jr_003_7459                             ; $744D

    cp $20                                        ; $744F
    jr c, jr_003_7455                             ; $7451

    sub $20                                       ; $7453

jr_003_7455:
    inc a                                         ; $7455
    call HotSpotEd_ShowNumber                     ; $7456

jr_003_7459:
    ld a, [wPickerScrollPhase]                    ; $7459
    and a                                         ; $745C
    ret nz                                        ; $745D

    jp HotSpotEd_PreviewSound                     ; $745E


; C: shows the number and icon of the chosen effect
HotSpotEd_ShowEffect::
    ld de, $8d50                                  ; $7461
    ld a, [wHsSelected]                           ; $7464
    ld c, a                                       ; $7467
    ld b, $00                                     ; $7468
    ld hl, wHotspotBlock + $14                    ; $746A
    add hl, bc                                    ; $746D
    ld a, [hl]                                    ; $746E
    cp $ff                                        ; $746F
    ret z                                         ; $7471

    inc a                                         ; $7472
    call HotSpotEd_ShowNumber                     ; $7473
    jp HotSpotEd_ShowEffect_CopyThumb             ; $7476


; C: shows the chosen jump target
HotSpotEd_ShowJump::
    ld a, BANK(Gfx_1C_5710_HotSpotEd_ShowJump)    ; $7479
    ld hl, Gfx_1C_5710_HotSpotEd_ShowJump         ; $747B
    ld de, $8d70                                  ; $747E
    ld bc, $0010                                  ; $7481
    call Vram_CopyFromBank                        ; $7484
    ld de, $8d80                                  ; $7487
    ld a, [wHsSelected]                           ; $748A
    ld c, a                                       ; $748D
    ld b, $00                                     ; $748E
    ld hl, wHotspotBlock + $19                    ; $7490
    add hl, bc                                    ; $7493
    ld a, [hl]                                    ; $7494
    cp $ff                                        ; $7495
    jr z, jr_003_749d                             ; $7497

    inc a                                         ; $7499
    call HotSpotEd_ShowNumber                     ; $749A

jr_003_749d:
    jp HotSpotEd_ShowJumpThumb                    ; $749D


; C: two digit tiles from bank 1C. L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_ShowNumber::
    push af                                       ; $74A0
    ld a, [wPickerScrollPhase]                    ; $74A1
    cp $04                                        ; $74A4
    jr nc, jr_003_74aa                            ; $74A6

    ld a, $04                                     ; $74A8

jr_003_74aa:
    sub $04                                       ; $74AA
    ld b, a                                       ; $74AC
    pop af                                        ; $74AD
    ld c, $00                                     ; $74AE

jr_003_74b0:
    cp $0a                                        ; $74B0
    jr c, jr_003_74b9                             ; $74B2

    sub $0a                                       ; $74B4
    inc c                                         ; $74B6
    jr jr_003_74b0                                ; $74B7

jr_003_74b9:
    push af                                       ; $74B9
    push bc                                       ; $74BA
    cp $09                                        ; $74BB
    jr z, jr_003_74c1                             ; $74BD

    ld b, $00                                     ; $74BF

jr_003_74c1:
    ld a, c                                       ; $74C1
    call HotSpotEd_CopyNumberTile                 ; $74C2
    pop bc                                        ; $74C5
    pop af                                        ; $74C6

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_CopyNumberTile::
    swap a                                        ; $74C7
    add b                                         ; $74C9
    ld c, a                                       ; $74CA
    ld b, $00                                     ; $74CB
    ld hl, $5660                                  ; $74CD
    add hl, bc                                    ; $74D0
    ld a, $1c                                     ; $74D1
    ld bc, $0010                                  ; $74D3
    call Vram_CopyFromBank                        ; $74D6
    ret                                           ; $74D9


; C: copies the 64-byte effect thumbnail of the current slot ($5760 + 64 x effect id, bank $1C) to $8CF0 (branch
; target; code read 2026-10-19)
HotSpotEd_ShowEffect_CopyThumb::
    ld a, [wHsSelected]                           ; $74DA
    ld c, a                                       ; $74DD
    ld b, $00                                     ; $74DE
    ld hl, wHotspotBlock + $14                    ; $74E0
    add hl, bc                                    ; $74E3
    ld a, [hl]                                    ; $74E4
    cp $ff                                        ; $74E5
    ret z                                         ; $74E7

    swap a                                        ; $74E8
    ld c, a                                       ; $74EA
    ld b, $00                                     ; $74EB
    sla c                                         ; $74ED
    rl b                                          ; $74EF
    sla c                                         ; $74F1
    rl b                                          ; $74F3
    ld hl, $5760                                  ; $74F5
    add hl, bc                                    ; $74F8
    ld a, $1c                                     ; $74F9
    ld de, $8cf0                                  ; $74FB
    ld bc, $0040                                  ; $74FE
    call Vram_CopyFromBank                        ; $7501
    ret                                           ; $7504


; C: thumbnail of the jump target. L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A
; (tcrf_check/assets/l3_names/)
HotSpotEd_ShowJumpThumb::
    ld a, [wHsSelected]                           ; $7505
    ld c, a                                       ; $7508
    ld b, $00                                     ; $7509
    ld hl, wHotspotBlock + $19                    ; $750B
    add hl, bc                                    ; $750E
    ld a, [hl]                                    ; $750F
    cp $ff                                        ; $7510
    jr nc, jr_003_7556                            ; $7512

    bit 7, a                                      ; $7514
    jr z, jr_003_751c                             ; $7516

    res 7, a                                      ; $7518
    add $1e                                       ; $751A

jr_003_751c:
    ldh [hFarcallAArg], a                         ; $751C
    ld a, BANK(Photo_GetSramAddress_Far)          ; $751E
    ld hl, Photo_GetSramAddress_Far               ; $7520
    call Far_Call                                 ; $7523
    ld hl, $0e00                                  ; $7526
    add hl, bc                                    ; $7529
    ld de, $8c30                                  ; $752A
    push af                                       ; $752D
    ld bc, $00c0                                  ; $752E
    call Vram_CopyFromBank                        ; $7531
    pop af                                        ; $7534
    ld de, $8da0                                  ; $7535
    ld b, $04                                     ; $7538

jr_003_753a:
    push af                                       ; $753A
    push bc                                       ; $753B
    push de                                       ; $753C
    ld bc, $0008                                  ; $753D
    call Vram_CopyFromBank                        ; $7540
    pop de                                        ; $7543
    ld a, e                                       ; $7544
    add $10                                       ; $7545
    ld e, a                                       ; $7547
    ld a, d                                       ; $7548
    adc $00                                       ; $7549
    ld d, a                                       ; $754B
    ld bc, $0008                                  ; $754C
    add hl, bc                                    ; $754F
    pop bc                                        ; $7550
    pop af                                        ; $7551
    dec b                                         ; $7552
    jr nz, jr_003_753a                            ; $7553

    ret                                           ; $7555


jr_003_7556:
    ld a, BANK(Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete); $7556
    ld hl, Gfx_1C_5D60_Mode1A_State04_PlaceOrDelete; $7558
    ld de, $8c30                                  ; $755B
    ld bc, $00c0                                  ; $755E
    call Vram_CopyFromBank                        ; $7561
    ld a, BANK(Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete); $7564
    ld hl, Gfx_1C_5E20_Mode1A_State04_PlaceOrDelete; $7566
    ld de, $8da0                                  ; $7569
    ld bc, $0040                                  ; $756C
    call Vram_CopyFromBank                        ; $756F
    ret                                           ; $7572


; C: scrolls the value picker while Up / Down is held; Z/NZ
HotSpotEd_PickerScroll::
    ldh a, [hKeysHeld]                            ; $7573
    and PADF_UP | PADF_DOWN                       ; $7575
    jr z, jr_003_7589                             ; $7577

    ld [wPickerDir], a                            ; $7579
    ld a, [wPickerScrollPhase]                    ; $757C
    and a                                         ; $757F
    jr nz, jr_003_7589                            ; $7580

    push af                                       ; $7582
    ld a, SFX1_KEY_UP_DOWN                        ; $7583
    call Snd_Sfx1                                 ; $7585
    pop af                                        ; $7588

jr_003_7589:
    ld a, [wPickerDir]                            ; $7589
    ld b, a                                       ; $758C
    ld a, [wPickerScrollPhase]                    ; $758D
    ld c, a                                       ; $7590
    call HotSpotEd_PickerScrollStep               ; $7591
    cp c                                          ; $7594
    push af                                       ; $7595
    ld [wPickerScrollPhase], a                    ; $7596
    and a                                         ; $7599
    jr nz, jr_003_759f                            ; $759A

    ld [wPickerDir], a                            ; $759C

jr_003_759f:
    ld a, [hl]                                    ; $759F
    cp d                                          ; $75A0
    jr nz, jr_003_75a7                            ; $75A1

    ld a, $ff                                     ; $75A3
    jr jr_003_75ad                                ; $75A5

jr_003_75a7:
    cp $fe                                        ; $75A7
    jr nz, jr_003_75ad                            ; $75A9

    ld a, d                                       ; $75AB
    dec a                                         ; $75AC

jr_003_75ad:
    ld [hl], a                                    ; $75AD
    pop af                                        ; $75AE
    ret                                           ; $75AF


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_PickerScrollStep::
    bit 7, b                                      ; $75B0
    jr z, jr_003_75bb                             ; $75B2

    sub $02                                       ; $75B4
    ret nc                                        ; $75B6

    ld a, $12                                     ; $75B7
    dec [hl]                                      ; $75B9
    ret                                           ; $75BA


jr_003_75bb:
    bit 6, b                                      ; $75BB
    ret z                                         ; $75BD

    add $02                                       ; $75BE
    cp $14                                        ; $75C0
    ret nz                                        ; $75C2

    xor a                                         ; $75C3
    inc [hl]                                      ; $75C4
    ret                                           ; $75C5


; C: arrow sprite of the HotSpotEd pickers: the caller puts the position in BC (the effect picker passes x = $3F, y =
; $78 through `ld bc`); the meta is $CF while no key is held, $D1 while Up ($FFA1 bit 6) and $D0 while Down (bit 7) is
; held, drawn by Oam_AddMeta_B01_4000
HotSpotEd_DrawArrows::
    ldh a, [hKeysHeld]                            ; $75C6
    ld d, a                                       ; $75C8
    ld a, $cf                                     ; $75C9
    bit 7, d                                      ; $75CB
    jr nz, jr_003_75d4                            ; $75CD

    bit 6, d                                      ; $75CF
    jr z, jr_003_75d5                             ; $75D1

    inc a                                         ; $75D3

jr_003_75d4:
    inc a                                         ; $75D4

jr_003_75d5:
    call Oam_AddMeta_B01_4000                     ; $75D5
    ret                                           ; $75D8


; C: zeroes the pointer animation state. L3 pass 2026-10-26: executed in BGB in 10 replay(s) of the organic corpus,
; modes 1A (tcrf_check/assets/l3_names/)
HotSpotEd_ClearAnim::
    ld hl, wSpriteAnimFrame                       ; $75D9
    ld de, wSpriteAnimTick                        ; $75DC
    xor a                                         ; $75DF
    ld b, $06                                     ; $75E0

jr_003_75e2:
    ld [hl+], a                                   ; $75E2
    ld [de], a                                    ; $75E3
    inc de                                        ; $75E4
    dec b                                         ; $75E5
    jr nz, jr_003_75e2                            ; $75E6

    ret                                           ; $75E8


; C: plays the chosen sound from the list at 7615
HotSpotEd_PreviewSound::
    ld a, [wHsSelected]                           ; $75E9
    ld c, a                                       ; $75EC
    ld b, $00                                     ; $75ED
    ld hl, wHotspotBlock + $f                     ; $75EF
    add hl, bc                                    ; $75F2
    ld a, [hl]                                    ; $75F3
    cp $ff                                        ; $75F4
    jr nz, jr_003_7600                            ; $75F6

    push af                                       ; $75F8
    ld a, MUSIC_STOP                              ; $75F9
    call Snd_Music                                ; $75FB
    pop af                                        ; $75FE
    ret                                           ; $75FF


jr_003_7600:
    cp $20                                        ; $7600
    jr nc, jr_003_760e                            ; $7602

    push af                                       ; $7604
    ld a, MUSIC_STOP                              ; $7605
    call Snd_Music                                ; $7607
    pop af                                        ; $760A
    push af                                       ; $760B
    rst Rst08_WaitVBlank                          ; $760C
    pop af                                        ; $760D

jr_003_760e:
    ld hl, HotSpotEd_SoundList                    ; $760E
    call Snd_PlayFromList                         ; $7611
    ret                                           ; $7614


; C: list of {sound
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
    db MUSIC_TITLE_ALIAS_1E, SNDCH_MUSIC  ; #47
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
    ld a, [wState]                                ; $7695
    rst Rst18_JumpTable                           ; $7698

; C: 3 states, rst $18 table of mode $06
Mode06_StateTable::
    dw Mode06_State00_Init
    dw Mode06_State01_Choose
    dw Mode06_State02_Dispatch

; C: loads the link menu graphics (bank 12)
Mode06_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $769F
    ldh [hLcdcShadow], a                          ; $76A1
    ld a, $1b                                     ; $76A3
    ld [wPaletteTarget], a                        ; $76A5
    ld [wPaletteTarget + $1], a                   ; $76A8
    ld a, $d2                                     ; $76AB
    ld [wPaletteTarget + $2], a                   ; $76AD
    xor a                                         ; $76B0
    ldh [hScxShadow], a                           ; $76B1
    ldh [hScyShadow], a                           ; $76B3
    ld a, $67                                     ; $76B5
    ldh [hWxShadow], a                            ; $76B7
    ld a, $16                                     ; $76B9
    ldh [hWyShadow], a                            ; $76BB
    xor a                                         ; $76BD
    ld [wSpriteAnimFrame], a                      ; $76BE
    ld [wSpriteAnimTick], a                       ; $76C1
    ld a, $12                                     ; $76C4
    ld hl, Gfx_12_4000_Mode06_State00_Init        ; $76C6
    ld de, $9000                                  ; $76C9
    ld bc, $0800                                  ; $76CC
    call Mem_CopyFromBank                         ; $76CF
    ld a, BANK(Gfx_12_4800_Mode06_State00_Init)   ; $76D2
    ld hl, Gfx_12_4800_Mode06_State00_Init        ; $76D4
    ld de, $8800                                  ; $76D7
    ld bc, $0800                                  ; $76DA
    call Mem_CopyFromBank                         ; $76DD
    ld a, BANK(Gfx_12_5000_Mode06_State00_Init)   ; $76E0
    ld hl, Gfx_12_5000_Mode06_State00_Init        ; $76E2
    ld de, $8000                                  ; $76E5
    ld bc, $0800                                  ; $76E8
    call Mem_CopyFromBank                         ; $76EB
    ld a, BANK(Map_23_44C0_Mode06_State00_Init)   ; $76EE
    ld hl, Map_23_44C0_Mode06_State00_Init        ; $76F0
    ld de, $9800                                  ; $76F3
    ld bc, $0400                                  ; $76F6
    call Mem_CopyFromBank                         ; $76F9
    ld a, BANK(Map_22_6340_Mode06_State00_Init)   ; $76FC
    ld hl, Map_22_6340_Mode06_State00_Init        ; $76FE
    ld de, $9c00                                  ; $7701
    ld bc, $0400                                  ; $7704
    call Mem_CopyFromBank                         ; $7707
    ld a, $50                                     ; $770A
    ldh [hLycShadowSplit1], a                     ; $770C
    ldh [hSplit2Line], a                          ; $770E
    ld hl, hStatShadow                            ; $7710
    set 6, [hl]                                   ; $7713
    ld hl, rIE                                    ; $7715
    set 1, [hl]                                   ; $7718
    ld a, $04                                     ; $771A
    ldh [hStatHandlerIndex], a                    ; $771C
    call Oam_ClearShadow                          ; $771E
    call Pal_AllWhite                             ; $7721
    call Lcd_On                                   ; $7724
    push af                                       ; $7727
    ld a, MUSIC_LINK_MENU                         ; $7728
    call Snd_Music                                ; $772A
    pop af                                        ; $772D
    ld a, [wLinkMenuCursor]                       ; $772E
    push af                                       ; $7731
    xor $01                                       ; $7732
    ld [wLinkMenuCursor], a                       ; $7734
    call LinkMenu_LoadTilesDeselected             ; $7737
    pop af                                        ; $773A
    ld [wLinkMenuCursor], a                       ; $773B
    call LinkMenu_LoadTilesSelected               ; $773E
    call Pal_FadeIn                               ; $7741
    ld hl, wState                                 ; $7744
    inc [hl]                                      ; $7747
    ret                                           ; $7748


; C: Up / Down moves between PRINT and TRANSFER
Mode06_State01_Choose::
    call LinkMenu_DrawCursor                      ; $7749
    call LinkMenu_MoveCursor                      ; $774C
    call LinkMenu_AnimateWindow                   ; $774F
    call LinkMenu_DrawSpark                       ; $7752
    ldh a, [hKeysNew]                             ; $7755
    and PADF_A | PADF_B                           ; $7757
    ret z                                         ; $7759

    ld [wAbResult], a                             ; $775A
    push af                                       ; $775D
    bit 0, a                                      ; $775E
    ld a, SFX1_CHOOSE_B                           ; $7760
    call nz, Snd_Sfx1                             ; $7762
    pop af                                        ; $7765
    push af                                       ; $7766
    bit 1, a                                      ; $7767
    ld a, SFX1_KEY_B                              ; $7769
    call nz, Snd_Sfx1                             ; $776B
    pop af                                        ; $776E
    ld hl, wState                                 ; $776F
    inc [hl]                                      ; $7772
    ret                                           ; $7773


; C: moves the window Y following the table at 779E. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic
; corpus, modes 06 (tcrf_check/assets/l3_names/)
LinkMenu_AnimateWindow::
    ld a, [wSpriteAnimFrame]                      ; $7774
    sla a                                         ; $7777
    ld c, a                                       ; $7779
    ld b, $00                                     ; $777A
    ld hl, LinkMenu_WindowAnimTbl                 ; $777C
    add hl, bc                                    ; $777F
    ld a, [hl+]                                   ; $7780
    ldh [hWyShadow], a                            ; $7781
    ld a, [wSpriteAnimTick]                       ; $7783
    sub [hl]                                      ; $7786
    jr nz, jr_003_7799                            ; $7787

    ld [wSpriteAnimTick], a                       ; $7789
    inc hl                                        ; $778C
    ld a, [hl]                                    ; $778D
    sub $ff                                       ; $778E
    jr z, jr_003_7796                             ; $7790

    ld a, [wSpriteAnimFrame]                      ; $7792
    inc a                                         ; $7795

jr_003_7796:
    ld [wSpriteAnimFrame], a                      ; $7796

jr_003_7799:
    ld hl, wSpriteAnimTick                        ; $7799
    inc [hl]                                      ; $779C
    ret                                           ; $779D


; C: pairs {wy. L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 06
; (tcrf_check/assets/l3_names/)
LinkMenu_WindowAnimTbl::
    db $16, $05, $17, $06, $18, $08, $19, $09, $1a, $0d, $19, $09, $18, $08, $17, $06
    db $16, $05, $15, $06, $14, $08, $13, $09, $12, $0d, $13, $09, $14, $08, $15, $06
    db $ff

; C: B returns to the main menu (mode 00); A goes to the mode of the item (table 77BF+..)
Mode06_State02_Dispatch::
    ld a, [wAbResult]                             ; $77BF
    bit 0, a                                      ; $77C2
    jr nz, jr_003_77e1                            ; $77C4

    ld a, MODE_MAIN_MENU                          ; $77C6
    ld [wMode], a                                 ; $77C8
    ld a, STATE_00_INIT                           ; $77CB
    ld [wState], a                                ; $77CD
    call Pal_FadeOut                              ; $77D0
    call Lcd_Off                                  ; $77D3
    ld hl, hStatShadow                            ; $77D6
    res 6, [hl]                                   ; $77D9
    ld hl, rIE                                    ; $77DB
    res 1, [hl]                                   ; $77DE
    ret                                           ; $77E0


jr_003_77e1:
    ld a, [wLinkMenuCursor]                       ; $77E1
    ld e, a                                       ; $77E4
    ld d, $00                                     ; $77E5
    ld hl, LinkMenu_TargetModeTbl                 ; $77E7
    add hl, de                                    ; $77EA
    ld a, [hl]                                    ; $77EB
    cp MODE_COUNT                                 ; $77EC
    jr c, jr_003_77fc                             ; $77EE

    push af                                       ; $77F0
    ld a, SFX1_BEEP_REFUSED                       ; $77F1
    call Snd_Sfx1                                 ; $77F3
    pop af                                        ; $77F6
    ld hl, wState                                 ; $77F7
    dec [hl]                                      ; $77FA
    ret                                           ; $77FB


jr_003_77fc:
    ld [wMode], a                                 ; $77FC
    xor a                                         ; $77FF
    ld [wState], a                                ; $7800
    ld b, $18                                     ; $7803

jr_003_7805:
    push bc                                       ; $7805
    ld a, b                                       ; $7806
    and $03                                       ; $7807
    jr nz, jr_003_7817                            ; $7809

    bit 2, b                                      ; $780B
    jr nz, jr_003_7814                            ; $780D

    call LinkMenu_LoadTilesDeselected             ; $780F
    jr jr_003_7817                                ; $7812

jr_003_7814:
    call LinkMenu_LoadTilesSelected               ; $7814

jr_003_7817:
    call LinkMenu_DrawCursor                      ; $7817
    call LinkMenu_DrawSpark                       ; $781A
    call Oam_HideUnused                           ; $781D
    rst Rst08_WaitVBlank                          ; $7820
    pop bc                                        ; $7821
    dec b                                         ; $7822
    jr nz, jr_003_7805                            ; $7823

    call Pal_FadeOut                              ; $7825
    call Lcd_Off                                  ; $7828
    ld hl, hStatShadow                            ; $782B
    res 6, [hl]                                   ; $782E
    ld hl, rIE                                    ; $7830
    res 1, [hl]                                   ; $7833
    ret                                           ; $7835


; C: 2 bytes: target mode of PRINT / TRANSFER
LinkMenu_TargetModeTbl::
    db MODE_PRINT_MENU, MODE_LINK_TRANSFER

; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_DrawCursor::
    ld bc, $4a36                                  ; $7838
    ld a, [wLinkMenuCursor]                       ; $783B
    add $ee                                       ; $783E
    call Oam_AddMeta_B01_4000                     ; $7840
    ret                                           ; $7843


; C
LinkMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7844
    ld b, a                                       ; $7846
    ld a, [wLinkMenuCursor]                       ; $7847
    bit 6, b                                      ; $784A
    jr nz, jr_003_7852                            ; $784C

    bit 5, b                                      ; $784E
    jr z, jr_003_785e                             ; $7850

jr_003_7852:
    and a                                         ; $7852
    ret z                                         ; $7853

    push af                                       ; $7854
    ld a, SFX1_KEY_UP_DOWN                        ; $7855
    call Snd_Sfx1                                 ; $7857
    pop af                                        ; $785A
    dec a                                         ; $785B
    jr jr_003_7870                                ; $785C

jr_003_785e:
    bit 7, b                                      ; $785E
    jr nz, jr_003_7865                            ; $7860

    bit 4, b                                      ; $7862
    ret z                                         ; $7864

jr_003_7865:
    cp $01                                        ; $7865
    ret z                                         ; $7867

    push af                                       ; $7868
    ld a, SFX1_KEY_UP_DOWN                        ; $7869
    call Snd_Sfx1                                 ; $786B
    pop af                                        ; $786E
    inc a                                         ; $786F

jr_003_7870:
    call LinkMenu_LoadTilesDeselected             ; $7870
    ld [wLinkMenuCursor], a                       ; $7873
    call LinkMenu_LoadTilesSelected               ; $7876
    ret                                           ; $7879


; C: sweeping spark sprite. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_DrawSpark::
    ld hl, wSweepPos16                            ; $787A
    ld a, [hl]                                    ; $787D
    add $03                                       ; $787E
    ld [hl+], a                                   ; $7880
    ld a, [hl]                                    ; $7881
    adc $00                                       ; $7882
    ld [hl-], a                                   ; $7884
    and $03                                       ; $7885
    ret nz                                        ; $7887

    ld a, [hl]                                    ; $7888
    cp $5d                                        ; $7889
    ret nc                                        ; $788B

    sub $10                                       ; $788C
    ld b, a                                       ; $788E
    ld c, $03                                     ; $788F
    ldh a, [hFrameCounter]                        ; $7891
    and $01                                       ; $7893
    add $f0                                       ; $7895
    call Oam_AddMeta_B01_4000                     ; $7897
    ret                                           ; $789A


; C: highlight tiles of the selected item. L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus,
; modes 06 0E 1B (tcrf_check/assets/l3_names/)
LinkMenu_LoadTilesSelected::
    push af                                       ; $789B
    ld a, [wLinkMenuCursor]                       ; $789C
    and a                                         ; $789F
    jr nz, jr_003_78b2                            ; $78A0

    ld a, BANK(Gfx_12_48B0_LinkMenu_LoadTilesSelected); $78A2
    ld hl, Gfx_12_48B0_LinkMenu_LoadTilesSelected ; $78A4
    ld de, $88b0                                  ; $78A7
    ld bc, $00f0                                  ; $78AA
    call Vram_CopyFromBank                        ; $78AD
    jr jr_003_78c0                                ; $78B0

jr_003_78b2:
    ld a, BANK(Gfx_12_4B30_LinkMenu_LoadTilesSelected); $78B2
    ld hl, Gfx_12_4B30_LinkMenu_LoadTilesSelected ; $78B4
    ld de, $89a0                                  ; $78B7
    ld bc, $00a0                                  ; $78BA
    call Vram_CopyFromBank                        ; $78BD

jr_003_78c0:
    pop af                                        ; $78C0
    ret                                           ; $78C1


; C: L3 pass 2026-10-26: executed in BGB in 9 replay(s) of the organic corpus, modes 06 0E 1B
; (tcrf_check/assets/l3_names/)
LinkMenu_LoadTilesDeselected::
    push af                                       ; $78C2
    ld a, [wLinkMenuCursor]                       ; $78C3
    and a                                         ; $78C6
    jr nz, jr_003_78d9                            ; $78C7

    ld a, BANK(Gfx_12_4A40_LinkMenu_LoadTilesDeselected); $78C9
    ld hl, Gfx_12_4A40_LinkMenu_LoadTilesDeselected; $78CB
    ld de, $88b0                                  ; $78CE
    ld bc, $00f0                                  ; $78D1
    call Vram_CopyFromBank                        ; $78D4
    jr jr_003_78e7                                ; $78D7

jr_003_78d9:
    ld a, BANK(Gfx_12_49A0_LinkMenu_LoadTilesDeselected); $78D9
    ld hl, Gfx_12_49A0_LinkMenu_LoadTilesDeselected; $78DB
    ld de, $89a0                                  ; $78DE
    ld bc, $00a0                                  ; $78E1
    call Vram_CopyFromBank                        ; $78E4

jr_003_78e7:
    pop af                                        ; $78E7
    ret                                           ; $78E8


; C: SLIDE SHOW / ANIMATION / HOT-SPOT
Mode0B_ShowMenu::
    ld a, [wState]                                ; $78E9
    rst Rst18_JumpTable                           ; $78EC

; C: 3 states, rst $18 table of mode $0B
Mode0B_StateTable::
    dw Mode0B_State00_Init
    dw Mode0B_State01_Choose
    dw Mode0B_State02_Dispatch

; C: loads the show menu graphics (bank 16)
Mode0B_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $78F3
    ldh [hLcdcShadow], a                          ; $78F5
    ld a, $e4                                     ; $78F7
    ld [wPaletteTarget], a                        ; $78F9
    ld a, $d2                                     ; $78FC
    ld [wPaletteTarget + $1], a                   ; $78FE
    ld [wPaletteTarget + $2], a                   ; $7901
    xor a                                         ; $7904
    ldh [hScxShadow], a                           ; $7905
    ldh [hScyShadow], a                           ; $7907
    ld [wSpriteAnimFrame], a                      ; $7909
    ld [wSpriteAnimTick], a                       ; $790C
    ld a, $16                                     ; $790F
    ld hl, Gfx_16_4000_Mode0B_State00_Init        ; $7911
    ld de, $9000                                  ; $7914
    ld bc, $0800                                  ; $7917
    call Mem_CopyFromBank                         ; $791A
    ld a, BANK(Gfx_16_4800_Mode0B_State00_Init)   ; $791D
    ld hl, Gfx_16_4800_Mode0B_State00_Init        ; $791F
    ld de, $8800                                  ; $7922
    ld bc, $0800                                  ; $7925
    call Mem_CopyFromBank                         ; $7928
    ld a, BANK(Gfx_16_5000_Mode0B_State00_Init)   ; $792B
    ld hl, Gfx_16_5000_Mode0B_State00_Init        ; $792D
    ld de, $8000                                  ; $7930
    ld bc, $0800                                  ; $7933
    call Mem_CopyFromBank                         ; $7936
    ld a, BANK(Map_23_7B00_Mode0B_State00_Init)   ; $7939
    ld hl, Map_23_7B00_Mode0B_State00_Init        ; $793B
    ld de, $9800                                  ; $793E
    ld bc, $0240                                  ; $7941
    call Mem_CopyFromBank                         ; $7944
    call Oam_ClearShadow                          ; $7947
    call Pal_AllWhite                             ; $794A
    call Lcd_On                                   ; $794D
    push af                                       ; $7950
    ld a, MUSIC_SHOW_MENU                         ; $7951
    call Snd_Music                                ; $7953
    pop af                                        ; $7956
    call Pal_FadeIn                               ; $7957
    call ShowMenu_LoadHighlightTiles              ; $795A
    ld hl, wState                                 ; $795D
    inc [hl]                                      ; $7960
    ret                                           ; $7961


; C: Up / Down moves the cursor (3 items)
Mode0B_State01_Choose::
    call ShowMenu_MoveCursor                      ; $7962
    call ShowMenu_DrawCursor                      ; $7965
    ldh a, [hKeysNew]                             ; $7968
    and PADF_A | PADF_B                           ; $796A
    ret z                                         ; $796C

    ld [wAbResult], a                             ; $796D
    push af                                       ; $7970
    bit 0, a                                      ; $7971
    ld a, SFX1_CHOOSE_D                           ; $7973
    call nz, Snd_Sfx1                             ; $7975
    pop af                                        ; $7978
    push af                                       ; $7979
    bit 1, a                                      ; $797A
    ld a, SFX1_KEY_B                              ; $797C
    call nz, Snd_Sfx1                             ; $797E
    pop af                                        ; $7981
    ld hl, wState                                 ; $7982
    inc [hl]                                      ; $7985
    ret                                           ; $7986


; C: B returns to the view menu (mode 02); A goes to the mode of the item (table 79E0)
Mode0B_State02_Dispatch::
    ld a, [wAbResult]                             ; $7987
    bit 0, a                                      ; $798A
    jr nz, jr_003_799f                            ; $798C

    ld a, MODE_VIEW_MENU                          ; $798E
    ld [wMode], a                                 ; $7990
    ld a, STATE_02_INIT                           ; $7993
    ld [wState], a                                ; $7995
    call Pal_FadeOut                              ; $7998
    call Lcd_Off                                  ; $799B
    ret                                           ; $799E


jr_003_799f:
    ld a, [wShowMenuCursor]                       ; $799F
    ld e, a                                       ; $79A2
    ld d, $00                                     ; $79A3
    ld hl, ShowMenu_TargetModeTbl                 ; $79A5
    add hl, de                                    ; $79A8
    ld a, [hl]                                    ; $79A9
    cp MODE_NONE                                  ; $79AA
    jr nz, jr_003_79b3                            ; $79AC

    ld hl, wState                                 ; $79AE
    dec [hl]                                      ; $79B1
    ret                                           ; $79B2


jr_003_79b3:
    ld [wMode], a                                 ; $79B3
    xor a                                         ; $79B6
    ld [wState], a                                ; $79B7
    ld b, $18                                     ; $79BA

jr_003_79bc:
    push bc                                       ; $79BC
    ld a, b                                       ; $79BD
    and $03                                       ; $79BE
    jr nz, jr_003_79ce                            ; $79C0

    bit 2, b                                      ; $79C2
    jr nz, jr_003_79cb                            ; $79C4

    call ShowMenu_LoadNormalTiles                 ; $79C6
    jr jr_003_79ce                                ; $79C9

jr_003_79cb:
    call ShowMenu_LoadHighlightTiles              ; $79CB

jr_003_79ce:
    call ShowMenu_DrawCursor                      ; $79CE
    call Oam_HideUnused                           ; $79D1
    rst Rst08_WaitVBlank                          ; $79D4
    pop bc                                        ; $79D5
    dec b                                         ; $79D6
    jr nz, jr_003_79bc                            ; $79D7

    call Pal_FadeOut                              ; $79D9
    call Lcd_Off                                  ; $79DC
    ret                                           ; $79DF


; C: 3 bytes: target mode of the three items ($FF = none)
ShowMenu_TargetModeTbl::
    db MODE_SLIDE_SHOW, MODE_ANIMATION_PLAYER, MODE_HOT_SPOT_VIEWER

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_DrawCursor::
    ld a, [wShowMenuCursor]                       ; $79E3
    ld e, a                                       ; $79E6
    ld d, $00                                     ; $79E7
    ld hl, ShowMenu_DrawCursor_Tbl7A21            ; $79E9
    add hl, de                                    ; $79EC
    ld c, [hl]                                    ; $79ED
    ld b, $02                                     ; $79EE
    ld a, [wSpriteAnimFrame]                      ; $79F0
    sla a                                         ; $79F3
    ld e, a                                       ; $79F5
    ld hl, ShowMenu_DrawCursor_Tbl7A24            ; $79F6
    add hl, de                                    ; $79F9
    ld a, [hl+]                                   ; $79FA
    push hl                                       ; $79FB
    call Oam_AddMeta_B01_4000                     ; $79FC
    pop hl                                        ; $79FF
    ld a, [wSpriteAnimTick]                       ; $7A00
    cp [hl]                                       ; $7A03
    jr nz, jr_003_7a1c                            ; $7A04

    inc hl                                        ; $7A06
    ld a, [hl]                                    ; $7A07
    sub $ff                                       ; $7A08
    jr z, jr_003_7a15                             ; $7A0A

    ld a, [wSpriteAnimFrame]                      ; $7A0C
    inc a                                         ; $7A0F
    cp $02                                        ; $7A10
    jr nz, jr_003_7a15                            ; $7A12

    xor a                                         ; $7A14

jr_003_7a15:
    ld [wSpriteAnimFrame], a                      ; $7A15
    xor a                                         ; $7A18
    ld [wSpriteAnimTick], a                       ; $7A19

jr_003_7a1c:
    ld hl, wSpriteAnimTick                        ; $7A1C
    inc [hl]                                      ; $7A1F
    ret                                           ; $7A20


; C: auto: 3 bytes, bytes; referenced by ShowMenu_DrawCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0B)
ShowMenu_DrawCursor_Tbl7A21::
    db $4c, $64, $7c

; C: auto: 11 bytes, bytes; referenced by ShowMenu_DrawCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0B)
ShowMenu_DrawCursor_Tbl7A24::
    db $d7, $04, $d8, $04, $d9, $05, $da, $04, $db, $03, $ff

; C
ShowMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7A2F
    ld b, a                                       ; $7A31
    ld a, [wShowMenuCursor]                       ; $7A32
    bit 6, b                                      ; $7A35
    jr z, jr_003_7a45                             ; $7A37

    and a                                         ; $7A39
    ret z                                         ; $7A3A

    push af                                       ; $7A3B
    ld a, SFX1_KEY_UP_DOWN                        ; $7A3C
    call Snd_Sfx1                                 ; $7A3E
    pop af                                        ; $7A41
    dec a                                         ; $7A42
    jr jr_003_7a53                                ; $7A43

jr_003_7a45:
    bit 7, b                                      ; $7A45
    ret z                                         ; $7A47

    cp $02                                        ; $7A48
    ret z                                         ; $7A4A

    push af                                       ; $7A4B
    ld a, SFX1_KEY_UP_DOWN                        ; $7A4C
    call Snd_Sfx1                                 ; $7A4E
    pop af                                        ; $7A51
    inc a                                         ; $7A52

jr_003_7a53:
    call ShowMenu_LoadNormalTiles                 ; $7A53
    ld [wShowMenuCursor], a                       ; $7A56
    call ShowMenu_LoadHighlightTiles              ; $7A59
    ld a, $02                                     ; $7A5C
    ld [wSpriteAnimFrame], a                      ; $7A5E
    ret                                           ; $7A61


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_LoadHighlightTiles::
    push af                                       ; $7A62
    ld a, [wShowMenuCursor]                       ; $7A63
    sla a                                         ; $7A66
    ld c, a                                       ; $7A68
    sla a                                         ; $7A69
    add c                                         ; $7A6B
    swap a                                        ; $7A6C
    ld c, a                                       ; $7A6E
    ld b, $00                                     ; $7A6F
    ld hl, $9900                                  ; $7A71
    add hl, bc                                    ; $7A74
    push hl                                       ; $7A75
    ld hl, $7d60                                  ; $7A76
    add hl, bc                                    ; $7A79
    ld a, $23                                     ; $7A7A
    pop de                                        ; $7A7C
    ld bc, $0060                                  ; $7A7D
    call Vram_CopyFromBank                        ; $7A80
    pop af                                        ; $7A83
    ret                                           ; $7A84


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
ShowMenu_LoadNormalTiles::
    push af                                       ; $7A85
    ld a, [wShowMenuCursor]                       ; $7A86
    sla a                                         ; $7A89
    ld c, a                                       ; $7A8B
    sla a                                         ; $7A8C
    add c                                         ; $7A8E
    swap a                                        ; $7A8F
    ld c, a                                       ; $7A91
    ld b, $00                                     ; $7A92
    ld hl, $9900                                  ; $7A94
    add hl, bc                                    ; $7A97
    push hl                                       ; $7A98
    ld hl, $7c00                                  ; $7A99
    add hl, bc                                    ; $7A9C
    ld a, $23                                     ; $7A9D
    pop de                                        ; $7A9F
    ld bc, $0060                                  ; $7AA0
    call Vram_CopyFromBank                        ; $7AA3
    pop af                                        ; $7AA6
    ret                                           ; $7AA7


; C: STAMP / PAINT tool pick
Mode04_DoodleMenu::
    ld a, [wState]                                ; $7AA8
    rst Rst18_JumpTable                           ; $7AAB

; C: 3 states, rst $18 table of mode $04
Mode04_StateTable::
    dw Mode04_State00_Init
    dw Mode04_State01_Choose
    dw Mode04_State02_Dispatch

; C: loads the doodle menu graphics (bank 15)
Mode04_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7AB2
    ldh [hLcdcShadow], a                          ; $7AB4
    ld a, $e4                                     ; $7AB6
    ld [wPaletteTarget], a                        ; $7AB8
    ld [wPaletteTarget + $1], a                   ; $7ABB
    ld a, $d2                                     ; $7ABE
    ld [wPaletteTarget + $2], a                   ; $7AC0
    xor a                                         ; $7AC3
    ldh [hScxShadow], a                           ; $7AC4
    ldh [hScyShadow], a                           ; $7AC6
    xor a                                         ; $7AC8
    ld [wBlinkHold], a                            ; $7AC9
    ld a, BANK(Gfx_15_5700_Mode04_State00_Init)   ; $7ACC
    ld hl, Gfx_15_5700_Mode04_State00_Init        ; $7ACE
    ld de, $9000                                  ; $7AD1
    ld bc, $0800                                  ; $7AD4
    call Mem_CopyFromBank                         ; $7AD7
    ld a, BANK(Gfx_15_5F00_Mode04_State00_Init)   ; $7ADA
    ld hl, Gfx_15_5F00_Mode04_State00_Init        ; $7ADC
    ld de, $8800                                  ; $7ADF
    ld bc, $0800                                  ; $7AE2
    call Mem_CopyFromBank                         ; $7AE5
    ld a, BANK(Gfx_15_6700_Mode04_State00_Init)   ; $7AE8
    ld hl, Gfx_15_6700_Mode04_State00_Init        ; $7AEA
    ld de, $8000                                  ; $7AED
    ld bc, $0800                                  ; $7AF0
    call Mem_CopyFromBank                         ; $7AF3
    ld a, BANK(Map_27_4870_Mode04_State00_Init)   ; $7AF6
    ld hl, Map_27_4870_Mode04_State00_Init        ; $7AF8
    ld de, $9800                                  ; $7AFB
    ld bc, $0240                                  ; $7AFE
    call Mem_CopyFromBank                         ; $7B01
    call Oam_ClearShadow                          ; $7B04
    call Pal_AllWhite                             ; $7B07
    call Lcd_On                                   ; $7B0A
    push af                                       ; $7B0D
    ld a, MUSIC_DOODLE_MENU                       ; $7B0E
    call Snd_Music                                ; $7B10
    pop af                                        ; $7B13
    call Pal_FadeIn                               ; $7B14
    ld hl, wState                                 ; $7B17
    inc [hl]                                      ; $7B1A
    ret                                           ; $7B1B


; C: Left / Right moves between STAMP and PAINT
Mode04_State01_Choose::
    call DoodleMenu_DrawCursor                    ; $7B1C
    call DoodleMenu_MoveCursor                    ; $7B1F
    call DoodleMenu_DrawBlinker                   ; $7B22
    ldh a, [hKeysNew]                             ; $7B25
    and PADF_A | PADF_B                           ; $7B27
    ret z                                         ; $7B29

    ld [wAbResult], a                             ; $7B2A
    ld hl, wState                                 ; $7B2D
    inc [hl]                                      ; $7B30
    ret                                           ; $7B31


; C: B returns to the main menu (or the shoot menu when launched from there); A goes to the tool mode (table 7B8E)
Mode04_State02_Dispatch::
    ld a, [wAbResult]                             ; $7B32
    bit 0, a                                      ; $7B35
    jr nz, jr_003_7b5b                            ; $7B37

    call Pal_FadeOut                              ; $7B39
    call Lcd_Off                                  ; $7B3C
    ld a, [wDoodleFromShutterbug]                 ; $7B3F
    and a                                         ; $7B42
    jr nz, jr_003_7b50                            ; $7B43

    ld a, MODE_MAIN_MENU                          ; $7B45
    ld [wMode], a                                 ; $7B47
    ld a, STATE_00_INIT                           ; $7B4A
    ld [wState], a                                ; $7B4C
    ret                                           ; $7B4F


jr_003_7b50:
    ld a, MODE_SHUTTERBUG_MAGIC                   ; $7B50
    ld [wMode], a                                 ; $7B52
    ld a, STATE_16_REDRAW                         ; $7B55
    ld [wState], a                                ; $7B57
    ret                                           ; $7B5A


jr_003_7b5b:
    ld a, [wDoodleMenuCursor]                     ; $7B5B
    ld e, a                                       ; $7B5E
    ld d, $00                                     ; $7B5F
    ld hl, DoodleMenu_TargetModeTbl               ; $7B61
    add hl, de                                    ; $7B64
    ld a, [hl]                                    ; $7B65
    cp MODE_COUNT                                 ; $7B66
    jr c, jr_003_7b6f                             ; $7B68

    ld hl, wState                                 ; $7B6A
    dec [hl]                                      ; $7B6D
    ret                                           ; $7B6E


jr_003_7b6f:
    ld [wMode], a                                 ; $7B6F
    call Pal_FadeOut                              ; $7B72
    call Lcd_Off                                  ; $7B75
    ld a, [wDoodleFromShutterbug]                 ; $7B78
    and a                                         ; $7B7B
    jr nz, jr_003_7b83                            ; $7B7C

    xor a                                         ; $7B7E
    ld [wState], a                                ; $7B7F
    ret                                           ; $7B82


jr_003_7b83:
    ld a, $01                                     ; $7B83
    ld [wAbResult], a                             ; $7B85
    ld a, STATE_04_DISPATCH                       ; $7B88
    ld [wState], a                                ; $7B8A
    ret                                           ; $7B8D


; C: 2 bytes: target mode of STAMP / PAINT
DoodleMenu_TargetModeTbl::
    db MODE_STAMP, MODE_PAINT

; C: L3 pass 2026-10-26: executed in BGB in 35 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
DoodleMenu_DrawCursor::
    ld a, [wBlinkHold]                            ; $7B90
    and a                                         ; $7B93
    jr z, jr_003_7b9f                             ; $7B94

    dec a                                         ; $7B96
    ld [wBlinkHold], a                            ; $7B97
    ldh a, [hFrameCounter]                        ; $7B9A
    bit 3, a                                      ; $7B9C
    ret z                                         ; $7B9E

jr_003_7b9f:
    ld bc, $5030                                  ; $7B9F
    ld a, [wDoodleMenuCursor]                     ; $7BA2
    add $f2                                       ; $7BA5
    call Oam_AddMeta_B01_4000                     ; $7BA7
    ret                                           ; $7BAA


; C
DoodleMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7BAB
    ld b, a                                       ; $7BAD
    ld a, [wDoodleMenuCursor]                     ; $7BAE
    bit 6, b                                      ; $7BB1
    jr nz, jr_003_7bb9                            ; $7BB3

    bit 4, b                                      ; $7BB5
    jr z, jr_003_7bc5                             ; $7BB7

jr_003_7bb9:
    and a                                         ; $7BB9
    ret z                                         ; $7BBA

    push af                                       ; $7BBB
    ld a, SFX1_KEY_UP_DOWN                        ; $7BBC
    call Snd_Sfx1                                 ; $7BBE
    pop af                                        ; $7BC1
    dec a                                         ; $7BC2
    jr jr_003_7bd7                                ; $7BC3

jr_003_7bc5:
    bit 7, b                                      ; $7BC5
    jr nz, jr_003_7bcc                            ; $7BC7

    bit 5, b                                      ; $7BC9
    ret z                                         ; $7BCB

jr_003_7bcc:
    cp $01                                        ; $7BCC
    ret z                                         ; $7BCE

    push af                                       ; $7BCF
    ld a, SFX1_KEY_UP_DOWN                        ; $7BD0
    call Snd_Sfx1                                 ; $7BD2
    pop af                                        ; $7BD5
    inc a                                         ; $7BD6

jr_003_7bd7:
    ld [wDoodleMenuCursor], a                     ; $7BD7
    ld a, $20                                     ; $7BDA
    ld [wBlinkHold], a                            ; $7BDC
    ret                                           ; $7BDF


; C: L3 pass 2026-10-26: executed in BGB in 35 replay(s) of the organic corpus, modes 04 (tcrf_check/assets/l3_names/)
DoodleMenu_DrawBlinker::
    ldh a, [hFrameCounter]                        ; $7BE0
    bit 4, a                                      ; $7BE2
    ret z                                         ; $7BE4

    ld a, [wDoodleMenuCursor]                     ; $7BE5
    and a                                         ; $7BE8
    jr nz, jr_003_7bf4                            ; $7BE9

    ld bc, $0341                                  ; $7BEB
    ld a, $f4                                     ; $7BEE
    call Oam_AddMeta_B01_4000                     ; $7BF0
    ret                                           ; $7BF3


jr_003_7bf4:
    ld bc, $9441                                  ; $7BF4
    ld a, $f5                                     ; $7BF7
    call Oam_AddMeta_B01_4000                     ; $7BF9
    ret                                           ; $7BFC


; C: ALBUM / ANIMATION
Mode05_EditMenu::
    ld a, [wState]                                ; $7BFD
    rst Rst18_JumpTable                           ; $7C00

; C: 3 states, rst $18 table of mode $05
Mode05_StateTable::
    dw Mode05_State00_Init
    dw Mode05_State01_Choose
    dw Mode05_State02_Dispatch

; C: loads the edit menu graphics (bank 18)
Mode05_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7C07
    ldh [hLcdcShadow], a                          ; $7C09
    ld a, $e4                                     ; $7C0B
    ld [wPaletteTarget], a                        ; $7C0D
    ld a, $d2                                     ; $7C10
    ld [wPaletteTarget + $1], a                   ; $7C12
    ld [wPaletteTarget + $2], a                   ; $7C15
    xor a                                         ; $7C18
    ldh [hScxShadow], a                           ; $7C19
    ldh [hScyShadow], a                           ; $7C1B
    ld hl, wSpriteAnimFrame                       ; $7C1D
    ld b, $08                                     ; $7C20

jr_003_7c22:
    ld [hl+], a                                   ; $7C22
    dec b                                         ; $7C23
    jr nz, jr_003_7c22                            ; $7C24

    ld a, $18                                     ; $7C26
    ld hl, Gfx_18_4000_Mode05_State00_Init        ; $7C28
    ld de, $9000                                  ; $7C2B
    ld bc, $0800                                  ; $7C2E
    call Mem_CopyFromBank                         ; $7C31
    ld a, BANK(Gfx_18_4800_Mode05_State00_Init)   ; $7C34
    ld hl, Gfx_18_4800_Mode05_State00_Init        ; $7C36
    ld de, $8800                                  ; $7C39
    ld bc, $0800                                  ; $7C3C
    call Mem_CopyFromBank                         ; $7C3F
    ld a, BANK(Gfx_18_5000_Mode05_State00_Init)   ; $7C42
    ld hl, Gfx_18_5000_Mode05_State00_Init        ; $7C44
    ld de, $8000                                  ; $7C47
    ld bc, $0470                                  ; $7C4A
    call Mem_CopyFromBank                         ; $7C4D
    ld a, BANK(Map_25_6F20_Mode05_State00_Init)   ; $7C50
    ld hl, Map_25_6F20_Mode05_State00_Init        ; $7C52
    ld de, $9800                                  ; $7C55
    ld bc, $0240                                  ; $7C58
    call Mem_CopyFromBank                         ; $7C5B
    call Oam_ClearShadow                          ; $7C5E
    call Pal_AllWhite                             ; $7C61
    call Lcd_On                                   ; $7C64
    push af                                       ; $7C67
    ld a, MUSIC_EDIT_MENU                         ; $7C68
    call Snd_Music                                ; $7C6A
    pop af                                        ; $7C6D
    call Pal_FadeIn                               ; $7C6E
    ld a, [wEditMenuCursor]                       ; $7C71
    call EditMenu_ResetIconAnim                   ; $7C74
    ld hl, wState                                 ; $7C77
    inc [hl]                                      ; $7C7A
    ret                                           ; $7C7B


; C: Up / Down moves between ALBUM and ANIMATION
Mode05_State01_Choose::
    call EditMenu_AnimateIcons                    ; $7C7C
    call EditMenu_DrawBlinker                     ; $7C7F
    call EditMenu_MoveCursor                      ; $7C82
    ldh a, [hKeysNew]                             ; $7C85
    and PADF_A | PADF_B                           ; $7C87
    ret z                                         ; $7C89

    ld [wAbResult], a                             ; $7C8A
    push af                                       ; $7C8D
    bit 0, a                                      ; $7C8E
    ld a, SFX1_CHOOSE_B                           ; $7C90
    call nz, Snd_Sfx1                             ; $7C92
    pop af                                        ; $7C95
    push af                                       ; $7C96
    bit 1, a                                      ; $7C97
    ld a, SFX1_KEY_B                              ; $7C99
    call nz, Snd_Sfx1                             ; $7C9B
    pop af                                        ; $7C9E
    ld hl, wState                                 ; $7C9F
    inc [hl]                                      ; $7CA2
    ret                                           ; $7CA3


; C: B returns to the main menu; A plays the exit animation and goes to the mode of the item (table 7D17)
Mode05_State02_Dispatch::
    ld a, [wAbResult]                             ; $7CA4
    bit 0, a                                      ; $7CA7
    jr nz, jr_003_7cbc                            ; $7CA9

    ld a, MODE_MAIN_MENU                          ; $7CAB
    ld [wMode], a                                 ; $7CAD
    ld a, STATE_00_INIT                           ; $7CB0
    ld [wState], a                                ; $7CB2
    call Pal_FadeOut                              ; $7CB5
    call Lcd_Off                                  ; $7CB8
    ret                                           ; $7CBB


jr_003_7cbc:
    ld a, [wEditMenuCursor]                       ; $7CBC
    ld e, a                                       ; $7CBF
    ld d, $00                                     ; $7CC0
    ld hl, EditMenu_TargetModeTbl                 ; $7CC2
    add hl, de                                    ; $7CC5
    ld a, [hl]                                    ; $7CC6
    cp MODE_COUNT                                 ; $7CC7
    jr c, jr_003_7cd7                             ; $7CC9

    push af                                       ; $7CCB
    ld a, SFX1_BEEP_REFUSED                       ; $7CCC
    call Snd_Sfx1                                 ; $7CCE
    pop af                                        ; $7CD1
    ld hl, wState                                 ; $7CD2
    dec [hl]                                      ; $7CD5
    ret                                           ; $7CD6


jr_003_7cd7:
    ld [wMode], a                                 ; $7CD7
    xor a                                         ; $7CDA
    ld [wState], a                                ; $7CDB
    ld a, [wEditMenuCursor]                       ; $7CDE
    and a                                         ; $7CE1
    jr nz, jr_003_7ceb                            ; $7CE2

    ld a, $04                                     ; $7CE4
    ld [wSpriteAnimFrame], a                      ; $7CE6
    jr jr_003_7cf0                                ; $7CE9

jr_003_7ceb:
    ld a, $04                                     ; $7CEB
    ld [wSpriteAnimFrame + $1], a                 ; $7CED

jr_003_7cf0:
    ld a, $02                                     ; $7CF0
    ld [wSpriteAnimFrame + $2], a                 ; $7CF2
    xor a                                         ; $7CF5
    ld [wSpriteAnimTick], a                       ; $7CF6
    ld [wSpriteAnimTick + $1], a                  ; $7CF9
    ld [wSpriteAnimTick + $2], a                  ; $7CFC
    ld b, $28                                     ; $7CFF

jr_003_7d01:
    push bc                                       ; $7D01
    call EditMenu_AnimateIcons                    ; $7D02
    call EditMenu_DrawBlinker                     ; $7D05
    call Oam_HideUnused                           ; $7D08
    rst Rst08_WaitVBlank                          ; $7D0B
    pop bc                                        ; $7D0C
    dec b                                         ; $7D0D
    jr nz, jr_003_7d01                            ; $7D0E

    call Pal_FadeOut                              ; $7D10
    call Lcd_Off                                  ; $7D13
    ret                                           ; $7D16


; C: 2 bytes: target mode of ALBUM / ANIMATION
EditMenu_TargetModeTbl::
    db MODE_DELETE_PHOTO, MODE_ANIMATION_EDITOR

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 0F 12
; (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons::
    ld bc, $0300                                  ; $7D19

jr_003_7d1c:
    push bc                                       ; $7D1C
    ld b, $00                                     ; $7D1D
    ld hl, wSpriteAnimFrame                       ; $7D1F
    add hl, bc                                    ; $7D22
    ld e, [hl]                                    ; $7D23
    ld hl, wSpriteAnimTick                        ; $7D24
    add hl, bc                                    ; $7D27
    ld d, [hl]                                    ; $7D28
    ld hl, EditMenu_AnimateIcons_Tbl7D74          ; $7D29
    add hl, bc                                    ; $7D2C
    ld c, [hl]                                    ; $7D2D
    add hl, bc                                    ; $7D2E
    ld c, e                                       ; $7D2F
    sla c                                         ; $7D30
    add hl, bc                                    ; $7D32
    ld a, [hl+]                                   ; $7D33
    pop bc                                        ; $7D34
    push bc                                       ; $7D35
    push de                                       ; $7D36
    push hl                                       ; $7D37
    sla c                                         ; $7D38
    ld b, $00                                     ; $7D3A
    ld hl, EditMenu_AnimateIcons_Tbl7D6E          ; $7D3C
    add hl, bc                                    ; $7D3F
    ld c, [hl]                                    ; $7D40
    inc hl                                        ; $7D41
    ld b, [hl]                                    ; $7D42
    and a                                         ; $7D43
    call nz, Oam_AddMeta_B01_4000                 ; $7D44
    pop hl                                        ; $7D47
    pop de                                        ; $7D48
    ld a, d                                       ; $7D49
    cp [hl]                                       ; $7D4A
    jr nz, jr_003_7d59                            ; $7D4B

    inc hl                                        ; $7D4D
    ld a, [hl+]                                   ; $7D4E
    cp $ff                                        ; $7D4F
    jr z, jr_003_7d56                             ; $7D51

    inc e                                         ; $7D53
    jr jr_003_7d57                                ; $7D54

jr_003_7d56:
    ld e, [hl]                                    ; $7D56

jr_003_7d57:
    ld d, $00                                     ; $7D57

jr_003_7d59:
    inc d                                         ; $7D59
    pop bc                                        ; $7D5A
    push bc                                       ; $7D5B
    ld b, $00                                     ; $7D5C
    ld hl, wSpriteAnimFrame                       ; $7D5E
    add hl, bc                                    ; $7D61
    ld [hl], e                                    ; $7D62
    ld hl, wSpriteAnimTick                        ; $7D63
    add hl, bc                                    ; $7D66
    ld [hl], d                                    ; $7D67
    pop bc                                        ; $7D68
    inc c                                         ; $7D69
    dec b                                         ; $7D6A
    jr nz, jr_003_7d1c                            ; $7D6B

    ret                                           ; $7D6D


; C: auto: 6 bytes, bytes; referenced by EditMenu_AnimateIcons. L3 pass 2026-10-26: read in BGB in 30 replay(s) of the
; organic corpus, modes 05 0F 12 (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons_Tbl7D6E::
    db $0b, $67, $6e, $08, $19, $36

; C: auto: 43 bytes, bytes; referenced by EditMenu_AnimateIcons. L3 pass 2026-10-26: read in BGB in 30 replay(s) of
; the organic corpus, modes 05 0F 12 (tcrf_check/assets/l3_names/)
EditMenu_AnimateIcons_Tbl7D74::
    db $03, $10, $1d, $e3, $04, $ff, $00, $e4, $04, $ff, $02, $e3, $04, $e4, $04, $ff
    db $04, $e5, $04, $ff, $00, $e6, $04, $ff, $02, $e5, $04, $e6, $04, $ff, $04, $00
    db $04, $ff, $00, $e8, $04, $e9, $04, $ea, $04, $ff, $00

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 0F 12
; (tcrf_check/assets/l3_names/)
EditMenu_DrawBlinker::
    ld hl, wSpriteXCounter                        ; $7D9F
    inc [hl]                                      ; $7DA2
    ldh a, [hFrameCounter]                        ; $7DA3
    bit 3, a                                      ; $7DA5
    ret z                                         ; $7DA7

    ld b, [hl]                                    ; $7DA8
    ld c, $3f                                     ; $7DA9
    ld a, $e7                                     ; $7DAB
    call Oam_AddMeta_B01_4000                     ; $7DAD
    ret                                           ; $7DB0


; C
EditMenu_MoveCursor::
    ldh a, [hKeysNewRepeat]                       ; $7DB1
    ld b, a                                       ; $7DB3
    ld a, [wEditMenuCursor]                       ; $7DB4
    bit 6, b                                      ; $7DB7
    jr nz, jr_003_7dbf                            ; $7DB9

    bit 4, b                                      ; $7DBB
    jr z, jr_003_7dcb                             ; $7DBD

jr_003_7dbf:
    and a                                         ; $7DBF
    ret z                                         ; $7DC0

    push af                                       ; $7DC1
    ld a, SFX1_KEY_UP_DOWN                        ; $7DC2
    call Snd_Sfx1                                 ; $7DC4
    pop af                                        ; $7DC7
    dec a                                         ; $7DC8
    jr jr_003_7ddd                                ; $7DC9

jr_003_7dcb:
    bit 7, b                                      ; $7DCB
    jr nz, jr_003_7dd2                            ; $7DCD

    bit 5, b                                      ; $7DCF
    ret z                                         ; $7DD1

jr_003_7dd2:
    cp $01                                        ; $7DD2
    ret z                                         ; $7DD4

    push af                                       ; $7DD5
    ld a, SFX1_KEY_UP_DOWN                        ; $7DD6
    call Snd_Sfx1                                 ; $7DD8
    pop af                                        ; $7DDB
    inc a                                         ; $7DDC

jr_003_7ddd:
    ld [wEditMenuCursor], a                       ; $7DDD

; C: L3 pass 2026-10-26: executed in BGB in 30 replay(s) of the organic corpus, modes 05 (tcrf_check/assets/l3_names/)
EditMenu_ResetIconAnim::
    and a                                         ; $7DE0
    jr nz, jr_003_7df3                            ; $7DE1

    ld a, $02                                     ; $7DE3
    ld [wSpriteAnimFrame], a                      ; $7DE5
    xor a                                         ; $7DE8
    ld [wSpriteAnimFrame + $1], a                 ; $7DE9
    ld [wSpriteAnimTick], a                       ; $7DEC
    ld [wSpriteAnimTick + $1], a                  ; $7DEF
    ret                                           ; $7DF2


jr_003_7df3:
    ld a, $02                                     ; $7DF3
    ld [wSpriteAnimFrame + $1], a                 ; $7DF5
    xor a                                         ; $7DF8
    ld [wSpriteAnimFrame], a                      ; $7DF9
    ld [wSpriteAnimTick], a                       ; $7DFC
    ld [wSpriteAnimTick + $1], a                  ; $7DFF
    ret                                           ; $7E02


    ; padding
    ds $1fd, $00

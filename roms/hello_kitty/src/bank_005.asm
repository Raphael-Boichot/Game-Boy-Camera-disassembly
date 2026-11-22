; Pocket Camera Hello Kitty (Japan), bank $05. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; C: when the 4 bytes $DADB-$DADE are all 0: fills them with 8 random digits (Rng_Next mod 10, + 1); first run on the
; name card, mode $0B state $01
NameCard_MakeIdNumber::
    ld b, BANK(Sram_LoadIdCard)                   ; $4000
    ld hl, Sram_LoadIdCard                        ; $4002
    call Far_Call                                 ; $4005
    xor a                                         ; $4008
    ld hl, wIdCard                                ; $4009
    ld b, $04                                     ; $400C

jr_005_400e:
    or [hl]                                       ; $400E
    inc hl                                        ; $400F
    dec b                                         ; $4010
    jr nz, jr_005_400e                            ; $4011

    and a                                         ; $4013
    jr nz, jr_005_4050                            ; $4014

    ld hl, wIdCard                                ; $4016
    ld bc, $0800                                  ; $4019

jr_005_401c:
    push bc                                       ; $401C
    call Rng_Next                                 ; $401D
    and $0f                                       ; $4020
    add c                                         ; $4022

jr_005_4023:
    cp $0a                                        ; $4023
    jr c, jr_005_402b                             ; $4025

    sub $0a                                       ; $4027
    jr jr_005_4023                                ; $4029

jr_005_402b:
    ld c, a                                       ; $402B
    inc a                                         ; $402C
    swap [hl]                                     ; $402D
    or [hl]                                       ; $402F
    ld [hl], a                                    ; $4030
    bit 0, b                                      ; $4031
    jr z, jr_005_4036                             ; $4033

    inc hl                                        ; $4035

jr_005_4036:
    ld a, [wNameCard_MakeIdNumber_D8E2]           ; $4036
    and $1f                                       ; $4039
    inc a                                         ; $403B

jr_005_403c:
    push af                                       ; $403C
    call Rng_Next                                 ; $403D
    pop af                                        ; $4040
    dec a                                         ; $4041
    jr nz, jr_005_403c                            ; $4042

    pop bc                                        ; $4044
    dec b                                         ; $4045
    jr nz, jr_005_401c                            ; $4046

    ld b, BANK(Sram_StoreIdCard)                  ; $4048
    ld hl, Sram_StoreIdCard                       ; $404A
    call Far_Call                                 ; $404D

jr_005_4050:
    jp Far_Return                                 ; $4050


; C: handler of state $00 of mode $00 (word 0 of Mode00_StateTable)
Mode00_State00::
    di                                            ; $4053
    call Lcd_Off                                  ; $4054
    ld b, BANK(Objects_ClearAll)                  ; $4057
    ld hl, Objects_ClearAll                       ; $4059
    call Far_Call                                 ; $405C
    ld b, BANK(ScriptSlots_Clear)                 ; $405F
    ld hl, ScriptSlots_Clear                      ; $4061
    call Far_Call                                 ; $4064
    call Serial_SetFarCallback                    ; $4067

    dwb Far_ReturnJump

    call Stat_SetIdle                             ; $406D
    call Lcd_SetupInline                          ; $4070

    db $83, $00, $00, $00, $00, $00, $00, $00, $ff, $00, $01

    push af                                       ; $407E
    ld a, MUSIC_BOOT_AND_TITLE                    ; $407F
    ld [wSndMusicReq], a                          ; $4081
    pop af                                        ; $4084
    ei                                            ; $4085
    ld b, BANK(Sgb_UnfreezeScreen)                ; $4086
    ld hl, Sgb_UnfreezeScreen                     ; $4088
    call Far_Call                                 ; $408B
    rst Rst08_WaitVBlank                          ; $408E
    rst Rst08_WaitVBlank                          ; $408F
    ld a, [wKeysHeld]                             ; $4090
    cp PADF_A | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $4093
    jr nz, jr_005_409f                            ; $4095

    ld b, MODE_FACTORY_CHECK                      ; $4097
    ld c, $00                                     ; $4099
    call ModeState_Set                            ; $409B
    ret                                           ; $409E


jr_005_409f:
    ld a, [wKeysHeld]                             ; $409F
    cp PADF_A | PADF_B | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $40A2
    jr nz, jr_005_40ae                            ; $40A4

    ld b, MODE_FACTORY_CHECK                      ; $40A6
    ld c, $03                                     ; $40A8
    call ModeState_Set                            ; $40AA
    ret                                           ; $40AD


jr_005_40ae:
    ld a, [wBoot_D895]                            ; $40AE
    and a                                         ; $40B1
    jr nz, jr_005_40c3                            ; $40B2

    ld a, [wKeysHeld]                             ; $40B4
    cp PADF_SELECT | PADF_START                   ; $40B7
    jr nz, jr_005_40c3                            ; $40B9

    ld b, MODE_BOOT_AND_TITLE                     ; $40BB
    ld c, $01                                     ; $40BD
    call ModeState_Set                            ; $40BF
    ret                                           ; $40C2


jr_005_40c3:
    ld b, MODE_BOOT_AND_TITLE                     ; $40C3
    ld c, $04                                     ; $40C5
    call ModeState_Set                            ; $40C7
    ret                                           ; $40CA


; C: handler of state $01 of mode $00 (word 1 of Mode00_StateTable)
Mode00_State01::
    di                                            ; $40CB
    call Lcd_Off                                  ; $40CC
    ld b, BANK(Objects_ClearAll)                  ; $40CF
    ld hl, Objects_ClearAll                       ; $40D1
    call Far_Call                                 ; $40D4
    ld b, BANK(ScriptSlots_Clear)                 ; $40D7
    ld hl, ScriptSlots_Clear                      ; $40D9
    call Far_Call                                 ; $40DC
    call Copy_FarInline                           ; $40DF

    db $00, $74, $24, $00, $8e, $00, $0a

    call Copy_FarInline                           ; $40E9

    db $30, $78, $31, $00, $98, $40, $02

    call Serial_SetFarCallback                    ; $40F3

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $40F9

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    push af                                       ; $4107
    ld a, MUSIC_BOOT_AND_TITLE                    ; $4108
    ld [wSndMusicReq], a                          ; $410A
    pop af                                        ; $410D
    ei                                            ; $410E
    ld b, MODE_BOOT_AND_TITLE                     ; $410F
    ld c, STATE_00_BOOT_THROW_AWAY_ALL_SAVE       ; $4111
    call Fade_GoTo                                ; $4113
    ret                                           ; $4116


; C: handler of state $02 of mode $00 (word 2 of Mode00_StateTable)
Mode00_State02::
    ld a, [wKeysNew]                              ; $4117
    bit PADB_A, a                                 ; $411A
    jr z, jr_005_4135                             ; $411C

    push af                                       ; $411E
    ld a, SFX4_0A                                 ; $411F
    ld [wSndSfx4], a                              ; $4121
    pop af                                        ; $4124
    ld b, BANK(Sram_Format)                       ; $4125
    ld hl, Sram_Format                            ; $4127
    call Far_Call                                 ; $412A
    ld b, MODE_BOOT_AND_TITLE                     ; $412D
    ld c, $04                                     ; $412F
    call Fade_GoToB                               ; $4131
    ret                                           ; $4134


jr_005_4135:
    ld a, [wKeysNew]                              ; $4135
    bit PADB_B, a                                 ; $4138
    jr z, jr_005_414b                             ; $413A

    push af                                       ; $413C
    ld a, SFX3_09                                 ; $413D
    ld [wSndSfx3], a                              ; $413F
    pop af                                        ; $4142
    ld b, MODE_BOOT_AND_TITLE                     ; $4143
    ld c, $04                                     ; $4145
    call Fade_GoToB                               ; $4147
    ret                                           ; $414A


jr_005_414b:
    ret                                           ; $414B


; C: handler of state $03 of mode $00 (word 3 of Mode00_StateTable)
Mode00_State03::
    ld b, $00                                     ; $414C

jr_005_414e:
    ld a, b                                       ; $414E
    push bc                                       ; $414F
    ld b, BANK(Sram_VerifyPhotoInfo)              ; $4150
    ld hl, Sram_VerifyPhotoInfo                   ; $4152
    call Far_CallKeepA                            ; $4155
    pop bc                                        ; $4158
    jr nc, jr_005_4166                            ; $4159

    ld a, b                                       ; $415B
    push bc                                       ; $415C
    ld b, BANK(Sram_WritePhotoInfo)               ; $415D
    ld hl, Sram_WritePhotoInfo                    ; $415F
    call Far_CallKeepA                            ; $4162
    pop bc                                        ; $4165

jr_005_4166:
    inc b                                         ; $4166
    ld a, b                                       ; $4167
    cp $1e                                        ; $4168
    jr nz, jr_005_414e                            ; $416A

    ld b, BANK(Sram_VerifyVector)                 ; $416C
    ld hl, Sram_VerifyVector                      ; $416E
    call Far_Call                                 ; $4171
    jr nc, jr_005_417e                            ; $4174

    ld b, BANK(Sram_FormatVector)                 ; $4176
    ld hl, Sram_FormatVector                      ; $4178
    call Far_Call                                 ; $417B

jr_005_417e:
    ld b, BANK(Sram_VerifyIdCard)                 ; $417E
    ld hl, Sram_VerifyIdCard                      ; $4180
    call Far_Call                                 ; $4183
    jr nc, jr_005_4190                            ; $4186

    ld b, BANK(Sram_FormatIdCard)                 ; $4188
    ld hl, Sram_FormatIdCard                      ; $418A
    call Far_Call                                 ; $418D

jr_005_4190:
    ld b, BANK(Sram_CheckCountersMagic)           ; $4190
    ld hl, Sram_CheckCountersMagic                ; $4192
    call Far_Call                                 ; $4195
    jr nc, jr_005_41a2                            ; $4198

    ld b, BANK(Sram_FormatCounters)               ; $419A
    ld hl, Sram_FormatCounters                    ; $419C
    call Far_Call                                 ; $419F

jr_005_41a2:
    ld b, BANK(Counters_Load)                     ; $41A2
    ld hl, Counters_Load                          ; $41A4
    call Far_Call                                 ; $41A7
    ld a, [wNameCardMade]                         ; $41AA
    and a                                         ; $41AD
    jr nz, jr_005_41c0                            ; $41AE

    ld b, BANK(Sram_ClearCardPhotos)              ; $41B0
    ld hl, Sram_ClearCardPhotos                   ; $41B2
    call Far_Call                                 ; $41B5
    ld b, BANK(Sram_FormatIdCard)                 ; $41B8
    ld hl, Sram_FormatIdCard                      ; $41BA
    call Far_Call                                 ; $41BD

jr_005_41c0:
    ld b, BANK(Sram_LoadVector)                   ; $41C0
    ld hl, Sram_LoadVector                        ; $41C2
    call Far_Call                                 ; $41C5
    ld b, BANK(Photo_CountUsed)                   ; $41C8
    ld hl, Photo_CountUsed                        ; $41CA
    call Far_Call                                 ; $41CD
    ld b, BANK(Sram_LoadIdCard)                   ; $41D0
    ld hl, Sram_LoadIdCard                        ; $41D2
    call Far_Call                                 ; $41D5
    di                                            ; $41D8
    ld b, BANK(Cam_Calib_ValidityCheck_Far)       ; $41D9
    ld hl, Cam_Calib_ValidityCheck_Far            ; $41DB
    call Far_Call                                 ; $41DE
    ei                                            ; $41E1
    and a                                         ; $41E2
    jr z, jr_005_41ed                             ; $41E3

    ld b, MODE_FACTORY_CHECK                      ; $41E5
    ld c, $03                                     ; $41E7
    call Fade_GoTo                                ; $41E9
    ret                                           ; $41EC


jr_005_41ed:
    ld b, BANK(Cam_LiveInit_Far)                  ; $41ED
    ld hl, Cam_LiveInit_Far                       ; $41EF
    call Far_Call                                 ; $41F2
    ret                                           ; $41F5


; C: handler of state $04 of mode $00 (word 4 of Mode00_StateTable)
Mode00_State04::
    di                                            ; $41F6
    call Lcd_Off                                  ; $41F7
    ld b, BANK(Objects_ClearAll)                  ; $41FA
    ld hl, Objects_ClearAll                       ; $41FC
    call Far_Call                                 ; $41FF
    ld b, BANK(ScriptSlots_Clear)                 ; $4202
    ld hl, ScriptSlots_Clear                      ; $4204
    call Far_Call                                 ; $4207
    call Copy_FarInline                           ; $420A

    db $00, $78, $1e, $00, $90, $00, $08

    call Copy_FarInline                           ; $4214

    db $70, $67, $31, $00, $98, $40, $02

    call Serial_SetFarCallback                    ; $421E

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $4224

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    xor a                                         ; $4232
    ld [wMode01_State02_D8F5], a                  ; $4233
    ld [wMode01_State05_D8F6], a                  ; $4236
    ld [wMode03_State02_D8F7], a                  ; $4239
    ld [wMode04_State01_D8F8], a                  ; $423C
    ld [wMode0B_State02_D8F9], a                  ; $423F
    push af                                       ; $4242
    ld a, MUSIC_BOOT_AND_TITLE                    ; $4243
    ld [wSndMusicReq], a                          ; $4245
    pop af                                        ; $4248
    ld b, MODE_BOOT_AND_TITLE                     ; $4249
    ld c, STATE_00_BOOT_COPYRIGHT_NOTICE          ; $424B
    call Fade_GoTo                                ; $424D
    ei                                            ; $4250
    ret                                           ; $4251


; C: handler of state $05 of mode $00 (word 5 of Mode00_StateTable)
Mode00_State05::
    call Rng_Next                                 ; $4252
    call Mode00_State03                           ; $4255
    ld a, [wKeysNew]                              ; $4258
    and PADF_A | PADF_START                       ; $425B
    ld b, MODE_BOOT_AND_TITLE                     ; $425D
    ld c, $06                                     ; $425F
    call Fade_GoToB                               ; $4261
    ret                                           ; $4264


; C: handler of state $06 of mode $00 (word 6 of Mode00_StateTable)
Mode00_State06::
    di                                            ; $4265
    call Lcd_Off                                  ; $4266
    ld b, BANK(Objects_ClearAll)                  ; $4269
    ld hl, Objects_ClearAll                       ; $426B
    call Far_Call                                 ; $426E
    ld b, BANK(ScriptSlots_Clear)                 ; $4271
    ld hl, ScriptSlots_Clear                      ; $4273
    call Far_Call                                 ; $4276
    call Copy_FarInline                           ; $4279

    db $00, $58, $15, $00, $80, $00, $18

    call Copy_FarInline                           ; $4283

    db $00, $7c, $2e, $00, $98, $80, $00

    call Copy_FarInline                           ; $428D

    db $40, $7e, $2e, $80, $98, $c0, $01

    call Serial_SetFarCallback                    ; $4297

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $429D

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    push af                                       ; $42AB
    ld a, MUSIC_BOOT_AND_TITLE_00_06              ; $42AC
    ld [wSndMusicReq], a                          ; $42AE
    pop af                                        ; $42B1
    ld b, MODE_BOOT_AND_TITLE                     ; $42B2
    ld c, $07                                     ; $42B4
    call Fade_GoTo                                ; $42B6
    ei                                            ; $42B9
    ret                                           ; $42BA


; C: handler of state $07 of mode $00 (word 7 of Mode00_StateTable)
Mode00_State07::
    call Rng_Next                                 ; $42BB
    ld a, [wFadeRunning]                          ; $42BE
    and a                                         ; $42C1
    jp nz, Jump_005_4357                          ; $42C2

    ld a, $05                                     ; $42C5
    call Rng_Scaled                               ; $42C7
    ld e, $00                                     ; $42CA
    ld d, a                                       ; $42CC
    ld hl, Gfx_1B_6900_Mode00_BootAndTitle_State08 ; $42CD
    add hl, de                                    ; $42D0
    ld e, l                                       ; $42D1
    ld d, h                                       ; $42D2
    ld hl, $8300                                  ; $42D3
    ld bc, $00a0                                  ; $42D6
    ld a, $1b                                     ; $42D9
    call Vram_CopyHBlankFar                       ; $42DB
    ld de, Map_2E_7C80_Mode00_BootAndTitle_State00 ; $42DE
    ld hl, $9880                                  ; $42E1
    ld bc, $01c0                                  ; $42E4
    ld a, $2e                                     ; $42E7
    call Vram_CopyHBlankFar                       ; $42E9
    ld bc, $7250                                  ; $42EC
    ld de, ObjScript_02_5B35_PlayMenu_ObjItemRecord + $16 ; $42EF
    call Object_CreateWithParam                   ; $42F2
    ld bc, $5c3e                                  ; $42F5
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 ; $42F8
    call Object_CreateWithParam                   ; $42FB
    ld bc, $5666                                  ; $42FE
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 ; $4301
    call Object_CreateWithParam                   ; $4304
    ld bc, $3c14                                  ; $4307
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $A ; $430A
    call Object_CreateWithParam                   ; $430D
    ld bc, $5310                                  ; $4310
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $14 ; $4313
    call Object_CreateWithParam                   ; $4316
    ld bc, $6c14                                  ; $4319
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $1E ; $431C
    call Object_CreateWithParam                   ; $431F
    ld bc, $8220                                  ; $4322
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $28 ; $4325
    call Object_CreateWithParam                   ; $4328
    ld bc, $8280                                  ; $432B
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $32 ; $432E
    call Object_CreateWithParam                   ; $4331
    ld bc, $6c8c                                  ; $4334
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $3C ; $4337
    call Object_CreateWithParam                   ; $433A
    ld bc, $5390                                  ; $433D
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $46 ; $4340
    call Object_CreateWithParam                   ; $4343
    ld bc, $3c8c                                  ; $4346
    ld de, ObjScript_02_5B83_Mode00_BootAndTitle_State00 + $50 ; $4349
    call Object_CreateWithParam                   ; $434C
    ld b, MODE_BOOT_AND_TITLE                     ; $434F
    ld c, STATE_00_TITLE_SCREEN                   ; $4351
    call ModeState_Set                            ; $4353
    ret                                           ; $4356


Jump_005_4357:
    ret                                           ; $4357


; C: handler of state $08 of mode $00 (word 8 of Mode00_StateTable)
Mode00_State08::
    call Rng_Next                                 ; $4358
    ld a, [wMode07_StateTable_D8E0]               ; $435B
    bit 2, a                                      ; $435E
    jr z, jr_005_436a                             ; $4360

    ld b, MODE_MAIN_MENU                          ; $4362
    ld c, $00                                     ; $4364
    call Fade_GoToB                               ; $4366
    ret                                           ; $4369


jr_005_436a:
    ret                                           ; $436A


; C: ModeTable entry $00: BGB screens 00:05 (copyright) and 00:08 (title)
Mode00_BootAndTitle::
    ldh a, [hState]                               ; $436B
    ld hl, Mode00_StateTable                      ; $436D
    call JumpTable_ByA                            ; $4370
    jp Far_Return                                 ; $4373


; C: state table of mode $00, read by $0189 with hFF8E
Mode00_StateTable::
    dw Mode00_State00
    dw Mode00_State01
    dw Mode00_State02
    dw Mode00_State03
    dw Mode00_State04
    dw Mode00_State05
    dw Mode00_State06
    dw Mode00_State07
    dw Mode00_State08

; C: handler of state $00 of mode $0D (word 0 of Mode0D_StateTable)
Mode0D_State00::
    di                                            ; $4388
    call Lcd_Off                                  ; $4389
    ld b, BANK(Objects_ClearAll)                  ; $438C
    ld hl, Objects_ClearAll                       ; $438E
    call Far_Call                                 ; $4391
    ld b, BANK(ScriptSlots_Clear)                 ; $4394
    ld hl, ScriptSlots_Clear                      ; $4396
    call Far_Call                                 ; $4399
    call Copy_FarInline                           ; $439C

    db $f0, $64, $31, $00, $80, $00, $03

    call Copy_FarInline                           ; $43A6

    db $f0, $69, $31, $00, $98, $40, $02

    ldh a, [hSram_Format_FF8C]                    ; $43B0
    push af                                       ; $43B2
    ld a, $02                                     ; $43B3
    ldh [hSram_Format_FF8C], a                    ; $43B5
    ld [rRAMB], a                                 ; $43B7
    ld hl, $982f                                  ; $43BA
    ld a, [$aff0]                                 ; $43BD
    call FactoryCheck_PutHexByte                  ; $43C0
    ld hl, $984f                                  ; $43C3
    ld a, [$aff1]                                 ; $43C6
    call FactoryCheck_PutHexByte                  ; $43C9
    ld hl, $9908                                  ; $43CC
    ld a, [$affc]                                 ; $43CF
    call FactoryCheck_PutHexByte                  ; $43D2
    ld hl, $9968                                  ; $43D5
    ld a, [$affd]                                 ; $43D8
    call FactoryCheck_PutHexByte                  ; $43DB
    pop af                                        ; $43DE
    ldh [hSram_Format_FF8C], a                    ; $43DF
    ld [rRAMB], a                                 ; $43E1
    call Serial_SetFarCallback                    ; $43E4

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $43EA

    db $93, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    push af                                       ; $43F8
    ld a, MUSIC_VIEW_ALBUM_03_04                  ; $43F9
    ld [wSndMusicReq], a                          ; $43FB
    pop af                                        ; $43FE
    ld b, MODE_FACTORY_CHECK                      ; $43FF
    ld c, STATE_0D_QUICK_FACTORY_CHECK_PLEASE_WAIT ; $4401
    call Fade_GoTo                                ; $4403
    ei                                            ; $4406
    ret                                           ; $4407


; C: A as two hex digit tiles at [HL+] (the digit value is the tile id); called by Mode0D_State00
FactoryCheck_PutHexByte::
    push af                                       ; $4408
    swap a                                        ; $4409
    and $0f                                       ; $440B
    call FactoryCheck_PutHexDigit                 ; $440D
    pop af                                        ; $4410
    and $0f                                       ; $4411

; C: one digit tile: ld [hl+],a
FactoryCheck_PutHexDigit::
    ld [hl+], a                                   ; $4413
    ret                                           ; $4414


; C: handler of state $01 of mode $0D (word 1 of Mode0D_StateTable)
Mode0D_State01::
    ld b, BANK(Cam_CalibSanityCheck_Measure_Far)  ; $4415
    ld hl, Cam_CalibSanityCheck_Measure_Far       ; $4417
    call Far_Call                                 ; $441A
    ld hl, $990c                                  ; $441D
    ld a, [wCamCalibVector + $a]                  ; $4420
    call FactoryCheck_PutHexByteVram              ; $4423
    ld hl, $996c                                  ; $4426
    ld a, [wCamCalibVector + $b]                  ; $4429
    call FactoryCheck_PutHexByteVram              ; $442C
    ld hl, $9910                                  ; $442F
    ldh a, [hScratchD]                            ; $4432
    call FactoryCheck_PutHexDigitVram             ; $4434
    ldh a, [hDiffOrValue]                         ; $4437
    call FactoryCheck_PutHexByteVram              ; $4439
    ld hl, $9970                                  ; $443C
    ldh a, [hPrevOrSign]                          ; $443F
    call FactoryCheck_PutHexDigitVram             ; $4441
    ldh a, [hDiff2]                               ; $4444
    call FactoryCheck_PutHexByteVram              ; $4446
    ldh a, [hCalibSanityPassFlag]                 ; $4449
    and a                                         ; $444B
    jr nz, jr_005_4468                            ; $444C

    ld de, Map_31_6C30_Cam_CalibSanityCheck_OkRow ; $444E
    ld hl, $98a0                                  ; $4451
    ld bc, $0020                                  ; $4454
    ld a, BANK(Map_31_6C30_Cam_CalibSanityCheck_OkRow) ; $4457
    call Vram_CopyHBlankFar                       ; $4459
    push af                                       ; $445C
    ld a, MUSIC_SCRATCH_CARD                      ; $445D
    ld [wSndMusicReq], a                          ; $445F
    pop af                                        ; $4462
    ld a, $02                                     ; $4463
    ldh [hState], a                               ; $4465
    ret                                           ; $4467


jr_005_4468:
    ld de, Gfx_31_6C50_Mode02_TakePhotos_State01  ; $4468
    ld hl, $98a0                                  ; $446B
    ld bc, $0020                                  ; $446E
    ld a, $31                                     ; $4471
    call Vram_CopyHBlankFar                       ; $4473
    push af                                       ; $4476
    ld a, MUSIC_TAKE_PHOTOS_02_0D                 ; $4477
    ld [wSndMusicReq], a                          ; $4479
    pop af                                        ; $447C
    ld a, $02                                     ; $447D
    ldh [hState], a                               ; $447F
    ret                                           ; $4481


; C: 05:4408 through Vram_WriteByteSafe (screen on); called by Mode0D_State01
FactoryCheck_PutHexByteVram::
    push af                                       ; $4482
    swap a                                        ; $4483
    and $0f                                       ; $4485
    call FactoryCheck_PutHexDigitVram             ; $4487
    pop af                                        ; $448A
    and $0f                                       ; $448B

; C: one digit tile through Vram_WriteByteSafe
FactoryCheck_PutHexDigitVram::
    call Vram_WriteByteSafe                       ; $448D
    inc hl                                        ; $4490
    ret                                           ; $4491


; C: handler of state $02 of mode $0D (word 2 of Mode0D_StateTable)
Mode0D_State02::
    ld a, [wKeysNew]                              ; $4492
    bit PADB_A, a                                 ; $4495
    jr z, jr_005_44a1                             ; $4497

    ld b, MODE_BOOT_AND_TITLE                     ; $4499
    ld c, $01                                     ; $449B
    call Fade_GoToB                               ; $449D
    ret                                           ; $44A0


jr_005_44a1:
    ret                                           ; $44A1


; C: handler of state $03 of mode $0D (word 3 of Mode0D_StateTable)
Mode0D_State03::
    di                                            ; $44A2
    call Lcd_Off                                  ; $44A3
    ld b, BANK(Objects_ClearAll)                  ; $44A6
    ld hl, Objects_ClearAll                       ; $44A8
    call Far_Call                                 ; $44AB
    ld b, BANK(ScriptSlots_Clear)                 ; $44AE
    ld hl, ScriptSlots_Clear                      ; $44B0
    call Far_Call                                 ; $44B3
    call Copy_FarInline                           ; $44B6

    db $f0, $64, $31, $00, $80, $00, $03

    call Copy_FarInline                           ; $44C0

    db $40, $71, $31, $00, $98, $40, $02

    call Serial_SetFarCallback                    ; $44CA

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $44D0

    db $93, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld b, MODE_FACTORY_CHECK                      ; $44DE
    ld c, STATE_0D_FACTORY_CALIBRATION_PLEASE_WAIT ; $44E0
    call Fade_GoTo                                ; $44E2
    ei                                            ; $44E5
    push af                                       ; $44E6
    ld a, MUSIC_VIEW_ALBUM_03_04                  ; $44E7
    ld [wSndMusicReq], a                          ; $44E9
    pop af                                        ; $44EC
    ret                                           ; $44ED


; C: handler of state $04 of mode $0D (word 4 of Mode0D_StateTable)
Mode0D_State04::
    ld b, BANK(Cam_FullCalibration_Far)           ; $44EE
    ld hl, Cam_FullCalibration_Far                ; $44F0
    call Far_Call                                 ; $44F3
    ld de, Map_31_7380_Mode02_TakePhotos_State08  ; $44F6
    ld hl, $9900                                  ; $44F9
    ld bc, $0020                                  ; $44FC
    ld a, $31                                     ; $44FF
    call Vram_CopyHBlankFar                       ; $4501
    push af                                       ; $4504
    ld a, MUSIC_FACTORY_CALIBRATION_PLEASE_WAIT   ; $4505
    ld [wSndMusicReq], a                          ; $4507
    pop af                                        ; $450A
    ld a, $05                                     ; $450B
    ldh [hState], a                               ; $450D
    ret                                           ; $450F


; C: handler of state $05 of mode $0D (word 5 of Mode0D_StateTable)
Mode0D_State05::
    ld a, [wKeysNew]                              ; $4510
    bit PADB_A, a                                 ; $4513
    jr z, jr_005_451f                             ; $4515

    ld b, MODE_BOOT_AND_TITLE                     ; $4517
    ld c, $01                                     ; $4519
    call Fade_GoToB                               ; $451B
    ret                                           ; $451E


jr_005_451f:
    ret                                           ; $451F


; C: ModeTable entry $0D: BGB screens 0D:01-02 (quick factory check) and 0D:04-05 (factory calibration); boot
; conditions
Mode0D_FactoryCheck::
    ldh a, [hState]                               ; $4520
    ld hl, Mode0D_StateTable                      ; $4522
    call JumpTable_ByA                            ; $4525
    jp Far_Return                                 ; $4528


; C: state table of mode $0D, read by $0189 with hFF8E
Mode0D_StateTable::
    dw Mode0D_State00
    dw Mode0D_State01
    dw Mode0D_State02
    dw Mode0D_State03
    dw Mode0D_State04
    dw Mode0D_State05

; C: handler of state $00 of mode $01 (word 0 of Mode01_StateTable)
Mode01_State00::
    di                                            ; $4537
    call Lcd_Off                                  ; $4538
    call Oam_ClearShadow                          ; $453B
    ld b, BANK(Objects_ClearAll)                  ; $453E
    ld hl, Objects_ClearAll                       ; $4540
    call Far_Call                                 ; $4543
    ld b, BANK(ScriptSlots_Clear)                 ; $4546
    ld hl, ScriptSlots_Clear                      ; $4548
    call Far_Call                                 ; $454B
    call Copy_FarInline                           ; $454E

    db $00, $58, $17, $00, $80, $00, $18

    call Copy_FarInline                           ; $4558

    db $70, $7a, $31, $00, $98, $40, $02

    ld a, [wMode01_State02_D8F5]                  ; $4562
    ld [wMenu07_CursorUpdate_D8F4], a             ; $4565
    call Serial_SetFarCallback                    ; $4568

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $456E

    db $87, $e4, $d0, $e4, $00, $00, $00, $00, $ff, $00, $01

    call Keys_SetRepeatInline                     ; $457C

    dw $0a28

    ld b, BANK(Objects_ClearAll)                  ; $4581
    ld hl, Objects_ClearAll                       ; $4583
    call Far_Call                                 ; $4586
    ld b, BANK(ScriptSlots_Clear)                 ; $4589
    ld hl, ScriptSlots_Clear                      ; $458B
    call Far_Call                                 ; $458E
    ld de, ObjScript_02_4DF2_Mode01_MainMenu_State00 ; $4591
    call Object_Create                            ; $4594
    ld de, ObjScript_02_5CCE_MainMenu_ObjTickB + $9F ; $4597
    call Object_Create                            ; $459A
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $2D ; $459D
    ld bc, $1b19                                  ; $45A0
    call Object_CreateWithParam                   ; $45A3
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $2D ; $45A6
    ld bc, $1b89                                  ; $45A9
    call Object_CreateWithParam                   ; $45AC
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $5A ; $45AF
    ld bc, $4318                                  ; $45B2
    call Object_CreateWithParam                   ; $45B5
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $5A ; $45B8
    ld bc, $4387                                  ; $45BB
    call Object_CreateWithParam                   ; $45BE
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $83 ; $45C1
    ld bc, $6b19                                  ; $45C4
    call Object_CreateWithParam                   ; $45C7
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $83 ; $45CA
    ld bc, $6b89                                  ; $45CD
    call Object_CreateWithParam                   ; $45D0
    ld b, MODE_MAIN_MENU                          ; $45D3
    ld c, STATE_01_MAIN_MENU_TAKE_VIEW_PLAY       ; $45D5
    call Fade_GoTo                                ; $45D7
    push af                                       ; $45DA
    ld a, MUSIC_MAIN_MENU                         ; $45DB
    ld [wSndMusicReq], a                          ; $45DD
    pop af                                        ; $45E0
    ei                                            ; $45E1
    ret                                           ; $45E2


; C: handler of state $01 of mode $01 (word 1 of Mode01_StateTable)
Mode01_State01::
    di                                            ; $45E3
    ld a, [wMode01_State02_D8F5]                  ; $45E4
    ld [wMenu07_CursorUpdate_D8F4], a             ; $45E7
    call Oam_ClearShadow                          ; $45EA
    ld b, BANK(Objects_ClearAll)                  ; $45ED
    ld hl, Objects_ClearAll                       ; $45EF
    call Far_Call                                 ; $45F2
    ld b, BANK(ScriptSlots_Clear)                 ; $45F5
    ld hl, ScriptSlots_Clear                      ; $45F7
    call Far_Call                                 ; $45FA
    call Keys_SetRepeatInline                     ; $45FD

    dw $0a28

    ld a, $01                                     ; $4602
    ld [wFadeRunning], a                          ; $4604
    ld de, ObjScript_02_4DF2_Mode01_MainMenu_State00 + $6 ; $4607
    call Object_Create                            ; $460A
    ld de, ObjScript_02_5CCE_MainMenu_ObjTickB + $9F ; $460D
    call Object_Create                            ; $4610
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $2D ; $4613
    ld bc, $1b19                                  ; $4616
    call Object_CreateWithParam                   ; $4619
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $2D ; $461C
    ld bc, $1b89                                  ; $461F
    call Object_CreateWithParam                   ; $4622
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $5A ; $4625
    ld bc, $4318                                  ; $4628
    call Object_CreateWithParam                   ; $462B
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $5A ; $462E
    ld bc, $4387                                  ; $4631
    call Object_CreateWithParam                   ; $4634
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $83 ; $4637
    ld bc, $6b19                                  ; $463A
    call Object_CreateWithParam                   ; $463D
    ld de, ObjScript_02_5C2A_MainMenu_ObjTick + $83 ; $4640
    ld bc, $6b89                                  ; $4643
    call Object_CreateWithParam                   ; $4646
    ld b, MODE_MAIN_MENU                          ; $4649
    ld c, STATE_01_MAIN_MENU_TAKE_VIEW_PLAY       ; $464B
    call ModeState_Set                            ; $464D
    ld a, $00                                     ; $4650
    ld [wFadeRunning], a                          ; $4652
    ei                                            ; $4655
    ret                                           ; $4656


; C: handler of state $02 of mode $01 (word 2 of Mode01_StateTable)
Mode01_State02::
    ld a, [wMode07_StateTable_D8E0]               ; $4657
    bit 0, a                                      ; $465A
    jr z, jr_005_466e                             ; $465C

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $465E
    ld [wMode01_State02_D8F5], a                  ; $4661
    ldh a, [hMenuMode]                            ; $4664
    ld b, a                                       ; $4666
    ldh a, [hMenuState]                           ; $4667
    ld c, a                                       ; $4669
    call Fade_GoToB                               ; $466A
    ret                                           ; $466D


jr_005_466e:
    ld a, [wFadeRunning]                          ; $466E
    and a                                         ; $4671
    jp nz, Jump_005_46ad                          ; $4672

    ld a, [wKeysNew]                              ; $4675
    bit PADB_START, a                             ; $4678
    jr z, jr_005_4691                             ; $467A

    push af                                       ; $467C
    ld a, SFX1_08                                 ; $467D
    ld [wSndSfx1], a                              ; $467F
    pop af                                        ; $4682
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4683
    ld [wMode01_State02_D8F5], a                  ; $4686
    ld b, MODE_MAIN_MENU                          ; $4689
    ld c, $04                                     ; $468B
    call ModeState_Set                            ; $468D
    ret                                           ; $4690


jr_005_4691:
    ld a, [wKeysNew]                              ; $4691
    bit PADB_B, a                                 ; $4694
    jr z, jr_005_46ad                             ; $4696

    push af                                       ; $4698
    ld a, SFX3_09                                 ; $4699
    ld [wSndSfx3], a                              ; $469B
    pop af                                        ; $469E
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $469F
    ld [wMode01_State02_D8F5], a                  ; $46A2
    ld b, MODE_BOOT_AND_TITLE                     ; $46A5
    ld c, $06                                     ; $46A7
    call Fade_GoToB                               ; $46A9
    ret                                           ; $46AC


Jump_005_46ad:
jr_005_46ad:
    ret                                           ; $46AD


; C: handler of state $03 of mode $01 (word 3 of Mode01_StateTable)
Mode01_State03::
    di                                            ; $46AE
    call Lcd_Off                                  ; $46AF
    call Oam_ClearShadow                          ; $46B2
    ld b, BANK(Objects_ClearAll)                  ; $46B5
    ld hl, Objects_ClearAll                       ; $46B7
    call Far_Call                                 ; $46BA
    ld b, BANK(ScriptSlots_Clear)                 ; $46BD
    ld hl, ScriptSlots_Clear                      ; $46BF
    call Far_Call                                 ; $46C2
    call Copy_FarInline                           ; $46C5

    db $00, $58, $17, $00, $80, $00, $18

    call Copy_FarInline                           ; $46CF

    db $70, $7a, $31, $00, $98, $40, $02

    ld a, [wMode01_State05_D8F6]                  ; $46D9
    ld [wMenu07_CursorUpdate_D8F4], a             ; $46DC
    ld de, Map_26_6A00_Mode01_MainMenu_State05    ; $46DF
    ld a, $26                                     ; $46E2
    ld hl, $9860                                  ; $46E4
    ld bc, $0180                                  ; $46E7
    call Copy_FarDEtoHL                           ; $46EA
    call Serial_SetFarCallback                    ; $46ED

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $46F3

    db $87, $e4, $d0, $e4, $00, $00, $00, $00, $ff, $00, $01

    call Keys_SetRepeatInline                     ; $4701

    dw $0a28

    ld b, BANK(Objects_ClearAll)                  ; $4706
    ld hl, Objects_ClearAll                       ; $4708
    call Far_Call                                 ; $470B
    ld b, BANK(ScriptSlots_Clear)                 ; $470E
    ld hl, ScriptSlots_Clear                      ; $4710
    call Far_Call                                 ; $4713
    ld de, ObjScript_02_4E39_Mode01_MainMenu_State03 ; $4716
    call Object_Create                            ; $4719
    push af                                       ; $471C
    ld a, MUSIC_MAIN_MENU                         ; $471D
    ld [wSndMusicReq], a                          ; $471F
    pop af                                        ; $4722
    ld b, MODE_MAIN_MENU                          ; $4723
    ld c, STATE_01_OPTION_MENU_NAME_RECORD_BOOK   ; $4725
    call Fade_GoTo                                ; $4727
    ei                                            ; $472A
    ret                                           ; $472B


; C: handler of state $04 of mode $01 (word 4 of Mode01_StateTable)
Mode01_State04::
    call Oam_ClearShadow                          ; $472C
    ld b, BANK(Objects_ClearAll)                  ; $472F
    ld hl, Objects_ClearAll                       ; $4731
    call Far_Call                                 ; $4734
    ld b, BANK(ScriptSlots_Clear)                 ; $4737
    ld hl, ScriptSlots_Clear                      ; $4739
    call Far_Call                                 ; $473C
    call Keys_SetRepeatInline                     ; $473F

    dw $0a28

    ld a, [wMode01_State05_D8F6]                  ; $4744
    ld [wMenu07_CursorUpdate_D8F4], a             ; $4747
    ld de, ObjScript_02_4E39_Mode01_MainMenu_State03 + $6 ; $474A
    call Object_Create                            ; $474D
    ld de, ObjScript_02_5D96_Mode01_MainMenu_State05 + $67 ; $4750
    call Object_Create                            ; $4753
    ld b, MODE_MAIN_MENU                          ; $4756
    ld c, STATE_01_OPTION_MENU_NAME_RECORD_BOOK   ; $4758
    call ModeState_Set                            ; $475A
    ret                                           ; $475D


; C: handler of state $05 of mode $01 (word 5 of Mode01_StateTable)
Mode01_State05::
    ld a, [wMode07_StateTable_D8E0]               ; $475E
    bit 0, a                                      ; $4761
    jr z, jr_005_4788                             ; $4763

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4765
    ld [wMode01_State05_D8F6], a                  ; $4768
    ldh a, [hMenuMode]                            ; $476B
    ld b, a                                       ; $476D
    cp MODE_NAME_CARD                             ; $476E
    jr nz, jr_005_4780                            ; $4770

    ld a, [wNameCardMade]                         ; $4772
    and a                                         ; $4775
    jr nz, jr_005_4780                            ; $4776

    ld b, MODE_NAME_CARD_EDIT                     ; $4778
    ld c, $0f                                     ; $477A
    call Fade_GoToB                               ; $477C
    ret                                           ; $477F


jr_005_4780:
    ld a, b                                       ; $4780
    ldh a, [hMenuState]                           ; $4781
    ld c, a                                       ; $4783
    call Fade_GoToB                               ; $4784
    ret                                           ; $4787


jr_005_4788:
    ld a, [wFadeRunning]                          ; $4788
    and a                                         ; $478B
    jr nz, jr_005_47b0                            ; $478C

    ld a, [wKeysNew]                              ; $478E
    bit PADB_B, a                                 ; $4791
    jr z, jr_005_47b0                             ; $4793

    push af                                       ; $4795
    ld a, SFX3_08                                 ; $4796
    ld [wSndSfx3], a                              ; $4798
    pop af                                        ; $479B
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $479C
    ld [wMode01_State05_D8F6], a                  ; $479F
    ld de, ObjScript_02_5D96_Mode01_MainMenu_State05 + $B3 ; $47A2
    call Object_Create                            ; $47A5
    ld b, MODE_MAIN_MENU                          ; $47A8
    ld c, $06                                     ; $47AA
    call ModeState_Set                            ; $47AC
    ret                                           ; $47AF


jr_005_47b0:
    ret                                           ; $47B0


; C: handler of state $06 of mode $01 (word 6 of Mode01_StateTable)
Mode01_State06::
    ld a, [wMode07_StateTable_D8E0]               ; $47B1
    bit 0, a                                      ; $47B4
    jr z, jr_005_47cb                             ; $47B6

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $47B8
    ld [wMode01_State05_D8F6], a                  ; $47BB
    xor a                                         ; $47BE
    ld [wMode07_StateTable_D8E0], a               ; $47BF
    ldh a, [hMenuMode]                            ; $47C2
    ldh [hMode], a                                ; $47C4
    ldh a, [hMenuState]                           ; $47C6
    ldh [hState], a                               ; $47C8
    ret                                           ; $47CA


jr_005_47cb:
    ret                                           ; $47CB


; C: ModeTable entry $01: BGB screens 01:02 (Take / View / Play) and 01:05 (option menu)
Mode01_MainMenu::
    ldh a, [hState]                               ; $47CC
    ld hl, Mode01_StateTable                      ; $47CE
    call JumpTable_ByA                            ; $47D1
    jp Far_Return                                 ; $47D4


; C: state table of mode $01, read by $0189 with hFF8E
Mode01_StateTable::
    dw Mode01_State00
    dw Mode01_State01
    dw Mode01_State02
    dw Mode01_State03
    dw Mode01_State04
    dw Mode01_State05
    dw Mode01_State06

; I: A x 5: five bytes of the $00 / $FF table 05:4802 into hFFAE-hFFB2, the masks of the plane-mapping loop that
; follows; called only by Mode02_State0C, a state nothing enters (no store of state $0C for mode $02, no ModeState_Set
; / inline / saved return with (2, $0C): byte search of the ROM)
Unused_TakePhotos_SetPlaneMasks::
    ld c, a                                       ; $47E5
    sla a                                         ; $47E6
    sla a                                         ; $47E8
    add c                                         ; $47EA
    ld c, a                                       ; $47EB
    ld b, $00                                     ; $47EC
    ld hl, Unused_TakePhotos_SetPlaneMasks + $1D  ; $47EE
    add hl, bc                                    ; $47F1
    ld a, [hl+]                                   ; $47F2
    ldh [hUnused_TakePhotos_SetPlaneMasks_FFAE], a ; $47F3
    ld a, [hl+]                                   ; $47F5
    ldh [hUnused_TakePhotos_SetPlaneMasks_FFAF], a ; $47F6
    ld a, [hl+]                                   ; $47F8
    ldh [hUnused_TakePhotos_SetPlaneMasks_FFB0], a ; $47F9
    ld a, [hl+]                                   ; $47FB
    ldh [hUnused_TakePhotos_SetPlaneMasks_FFB1], a ; $47FC
    ld a, [hl+]                                   ; $47FE
    ldh [hUnused_TakePhotos_SetPlaneMasks_FFB2], a ; $47FF
    ret                                           ; $4801


    db $00, $00, $00, $00, $00, $ff, $ff, $00, $00, $00, $ff, $ff, $00, $00, $ff, $00
    db $00, $00, $00, $ff, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $00, $00, $ff
    db $00, $00, $00, $ff, $00, $00, $00, $00, $ff, $00, $00, $ff, $00, $ff, $ff, $00
    db $ff, $00, $00, $00, $ff, $00, $00, $00, $ff, $ff, $00, $00, $ff, $00, $ff, $00
    db $00, $ff, $ff, $ff, $00, $00, $00, $ff, $00, $00, $ff, $ff, $00, $00, $00, $ff
    db $00, $00, $00, $ff, $ff, $00, $ff, $00, $ff, $ff, $ff, $00, $00, $ff, $ff, $ff
    db $ff, $00, $ff, $ff, $00, $00, $ff, $00, $ff, $00, $ff, $ff, $00, $ff, $ff, $00
    db $ff, $00, $ff, $ff, $ff, $ff, $00, $ff, $21, $00, $c0, $3e, $0e, $cd, $83, $48
    db $c9, $cb, $37, $e0, $b3, $f0, $ae, $4f, $f0, $af, $47, $b1, $28, $38, $e5, $f0
    db $b3, $5f, $7e, $a9, $22, $7e, $a8, $22, $7e, $a9, $22, $7e, $a8, $22, $7e, $a9
    db $22, $7e, $a8, $22, $7e, $a9, $22, $7e, $a8, $22, $7e, $a9, $22, $7e, $a8, $22
    db $7e, $a9, $22, $7e, $a8, $22, $7e, $a9, $22, $7e, $a8, $22, $7e, $a9, $22, $7e
    db $a8, $22, $1d, $20, $cd, $e1, $f0, $b0, $4f, $f0, $b1, $47, $b1, $28, $5c, $e5
    db $23, $f0, $b3, $5f, $3a, $a1, $57, $ae, $22, $aa, $a0, $ae, $22, $2c, $3a, $a1
    db $57, $ae, $22, $aa, $a0, $ae, $22, $2c, $3a, $a1, $57, $ae, $22, $aa, $a0, $ae
    db $22, $2c, $3a, $a1, $57, $ae, $22, $aa, $a0, $ae, $22, $2c, $3a, $a1, $57, $ae
    db $22, $aa, $a0, $ae, $22, $2c, $3a, $a1, $57, $ae, $22, $aa, $a0, $ae, $22, $2c
    db $3a, $a1, $57, $ae, $22, $aa, $a0, $ae, $22, $2c, $3a, $a1, $57, $ae, $22, $aa
    db $a0, $ae, $22, $2c, $20, $01, $24, $1d, $20, $aa, $e1, $f0, $b2, $4f, $a7, $28
    db $5a, $23, $f0, $b3, $5f, $3a, $ae, $a1, $57, $ae, $22, $7a, $ae, $22, $2c, $3a
    db $ae, $a1, $57, $ae, $22, $7a, $ae, $22, $2c, $3a, $ae, $a1, $57, $ae, $22, $7a
    db $ae, $22, $2c, $3a, $ae, $a1, $57, $ae, $22, $7a, $ae, $22, $2c, $3a, $ae, $a1
    db $57, $ae, $22, $7a, $ae, $22, $2c, $3a, $ae, $a1, $57, $ae, $22, $7a, $ae, $22
    db $2c, $3a, $ae, $a1, $57, $ae, $22, $7a, $ae, $22, $2c, $3a, $ae, $a1, $57, $ae
    db $22, $7a, $ae, $22, $2c, $20, $01, $24, $1d, $20, $aa, $c9

; C: handler of state $00 of mode $02 (word 0 of Mode02_StateTable)
Mode02_State00::
    di                                            ; $498E
    call Lcd_Off                                  ; $498F
    call Oam_ClearShadow                          ; $4992
    ld b, BANK(Objects_ClearAll)                  ; $4995
    ld hl, Objects_ClearAll                       ; $4997
    call Far_Call                                 ; $499A
    ld b, BANK(ScriptSlots_Clear)                 ; $499D
    ld hl, ScriptSlots_Clear                      ; $499F
    call Far_Call                                 ; $49A2
    ld de, $0000                                  ; $49A5
    ld hl, $8000                                  ; $49A8
    ld bc, $1800                                  ; $49AB
    call Mem_FillWord                             ; $49AE
    call Copy_FarInline                           ; $49B1

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $49BB

    db $f0, $75, $31, $00, $98, $00, $04

    ld a, $07                                     ; $49C5
    ld [wTakePhotos_FrameCallback2_DA1E], a       ; $49C7
    ld a, $08                                     ; $49CA
    ld [wTakePhotos_FrameCallback2_DA1F], a       ; $49CC
    ld a, $01                                     ; $49CF
    ld [wMode02_State00_DA20], a                  ; $49D1
    ld a, $08                                     ; $49D4
    ld [wTakePhotos_FrameCallback_D8FD], a        ; $49D6
    xor a                                         ; $49D9
    ld [wMode02_State01_D8FC], a                  ; $49DA
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $49DD
    ld [wMode06_State00_D931], a                  ; $49E0
    ld b, MODE_TAKE_PHOTOS                        ; $49E3
    ld c, $05                                     ; $49E5
    call Mode_SaveReturnD8F2                      ; $49E7
    call Keys_SetRepeatInline                     ; $49EA

    dw $0a14

    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $49EF
    ld c, a                                       ; $49F2
    ld a, [wCamGainSel]                           ; $49F3
    ld b, a                                       ; $49F6
    ld b, BANK(Cam_LoadRegisterSet_Far)           ; $49F7
    ld hl, Cam_LoadRegisterSet_Far                ; $49F9
    call Far_CallKeepA                            ; $49FC
    call Stat_SetTileToggleAt4F                   ; $49FF
    call Lcd_SetupInline                          ; $4A02

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    ld hl, wLcdcShadow                            ; $4A10
    res 2, [hl]                                   ; $4A13
    ei                                            ; $4A15
    call Mode02_State01                           ; $4A16
    call Mode02_State01                           ; $4A19
    ld a, [wMode06_State00_D931]                  ; $4A1C
    call FrameRec_LoadDefault                     ; $4A1F
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $58 ; $4A22
    call Object_Create                            ; $4A25
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $5E ; $4A28
    call Object_Create                            ; $4A2B
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $64 ; $4A2E
    call Object_Create                            ; $4A31
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $6A ; $4A34
    call Object_Create                            ; $4A37
    ld b, MODE_TAKE_PHOTOS                        ; $4A3A
    ld c, STATE_02_TAKE_PHOTOS_CAMERA_VIEW        ; $4A3C
    call Fade_GoTo                                ; $4A3E
    push af                                       ; $4A41
    ld a, MUSIC_TAKE_PHOTOS                       ; $4A42
    ld [wSndMusicReq], a                          ; $4A44
    pop af                                        ; $4A47
    call Serial_SetFarCallback                    ; $4A48

    dwb TakePhotos_FrameCallback3

    ret                                           ; $4A4E


; C: handler of state $02 of mode $02 (word 2 of Mode02_StateTable)
Mode02_State02::
    ret                                           ; $4A4F


; C: far-called at the start of bank-5 state handlers: Object_RunAll, then 00:21BE and 00:03D5
Bank05_FrameUpdate::
    ld b, $00                                     ; $4A50
    ld hl, Object_RunAll                          ; $4A52
    call Far_Call                                 ; $4A55
    call Objects_DrawAll                          ; $4A58
    call Oam_HideUnused                           ; $4A5B
    jp Far_Return                                 ; $4A5E


; C: handler of state $01 of mode $02 (word 1 of Mode02_StateTable)
Mode02_State01::
    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $4A61
    ld [wCamBrightnessSetpoint], a                ; $4A64
    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $4A67
    ld [wCamContrastRow], a                       ; $4A6A
    ld a, [wMode02_State00_DA20]                  ; $4A6D
    ld [wCamDitherMode], a                        ; $4A70
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4A73
    sla a                                         ; $4A76
    sla a                                         ; $4A78
    ld c, a                                       ; $4A7A
    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $4A7B
    add c                                         ; $4A7E
    ld c, a                                       ; $4A7F
    ld b, $00                                     ; $4A80
    ld hl, Mode02_State01_Tbl4C5F                 ; $4A82
    add hl, bc                                    ; $4A85
    ld a, [hl]                                    ; $4A86
    ld [wMode02_State01_D8FC], a                  ; $4A87
    ld a, [wMode02_State01_D8FC]                  ; $4A8A
    cp $ff                                        ; $4A8D
    jr z, jr_005_4a99                             ; $4A8F

    ld b, BANK(Cam_ApplyEffectOrFrame)            ; $4A91
    ld hl, Cam_ApplyEffectOrFrame                 ; $4A93
    call Far_CallKeepA                            ; $4A96

jr_005_4a99:
    ld a, $10                                     ; $4A99
    ldh [hSram_Format_FF8C], a                    ; $4A9B
    ld [rRAMB], a                                 ; $4A9D
    ld a, [wCamA000Shadow]                        ; $4AA0
    set 0, a                                      ; $4AA3
    ld [$a000], a                                 ; $4AA5
    ld de, $c000                                  ; $4AA8
    ld hl, $9000                                  ; $4AAB
    ld bc, $0800                                  ; $4AAE
    call Vram_CopyHBlank                          ; $4AB1
    ld de, $c800                                  ; $4AB4
    ld hl, $8000                                  ; $4AB7
    ld bc, $0600                                  ; $4ABA
    call Vram_CopyHBlank                          ; $4ABD
    ld a, $10                                     ; $4AC0
    ldh [hSram_Format_FF8C], a                    ; $4AC2
    ld [rRAMB], a                                 ; $4AC4

jr_005_4ac7:
    ld hl, $a000                                  ; $4AC7
    bit 0, [hl]                                   ; $4ACA
    jr nz, jr_005_4ac7                            ; $4ACC

    ld a, [wCamBrightnessSetpoint]                ; $4ACE
    ld b, BANK(Cam_PopcountLevelByIndex)          ; $4AD1
    ld hl, Cam_PopcountLevelByIndex               ; $4AD3
    call Far_CallKeepA                            ; $4AD6
    ld a, [wCamContrastRow]                       ; $4AD9
    ld c, a                                       ; $4ADC
    ld a, [wCamGainSel]                           ; $4ADD
    ld b, a                                       ; $4AE0
    ld b, BANK(Cam_LoadRegisterSet_Far)           ; $4AE1
    ld hl, Cam_LoadRegisterSet_Far                ; $4AE3
    call Far_CallKeepA                            ; $4AE6
    ret                                           ; $4AE9


; C: handler of state $05 of mode $02 (word 5 of Mode02_StateTable)
Mode02_State05::
    di                                            ; $4AEA
    call Lcd_Off                                  ; $4AEB
    call Oam_ClearShadow                          ; $4AEE
    ld b, BANK(Objects_ClearAll)                  ; $4AF1
    ld hl, Objects_ClearAll                       ; $4AF3
    call Far_Call                                 ; $4AF6
    ld b, BANK(ScriptSlots_Clear)                 ; $4AF9
    ld hl, ScriptSlots_Clear                      ; $4AFB
    call Far_Call                                 ; $4AFE
    ld de, wMode0B_State04_D400                   ; $4B01
    ld hl, $c000                                  ; $4B04
    ld bc, $0200                                  ; $4B07
    call Copy_DEtoHL                              ; $4B0A
    ld de, $ce00                                  ; $4B0D
    ld hl, $c200                                  ; $4B10
    ld bc, $0200                                  ; $4B13
    call Copy_DEtoHL                              ; $4B16
    jr jr_005_4b32                                ; $4B19

; C: handler of state $04 of mode $02 (word 4 of Mode02_StateTable)
Mode02_State04::
    di                                            ; $4B1B
    call Lcd_Off                                  ; $4B1C
    call Oam_ClearShadow                          ; $4B1F
    ld b, BANK(Objects_ClearAll)                  ; $4B22
    ld hl, Objects_ClearAll                       ; $4B24
    call Far_Call                                 ; $4B27
    ld b, BANK(ScriptSlots_Clear)                 ; $4B2A
    ld hl, ScriptSlots_Clear                      ; $4B2C
    call Far_Call                                 ; $4B2F

jr_005_4b32:
    call Copy_FarInline                           ; $4B32

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $4B3C

    db $f0, $75, $31, $00, $98, $00, $04

    call Copy_FarInline                           ; $4B46

    db $00, $c0, $00, $00, $90, $00, $08

    call Copy_FarInline                           ; $4B50

    db $00, $c8, $00, $00, $80, $00, $06

    call Stat_SetTileToggleAt4F                   ; $4B5A
    push af                                       ; $4B5D
    ld a, MUSIC_TAKE_PHOTOS                       ; $4B5E
    ld [wSndMusicReq], a                          ; $4B60
    pop af                                        ; $4B63
    call Lcd_SetupInline                          ; $4B64

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    call TakePhotos_PlaceFrameObjects             ; $4B72
    call Keys_SetRepeatInline                     ; $4B75

    dw $0a14

    ei                                            ; $4B7A
    ld a, [wMode06_State00_D931]                  ; $4B7B
    call FrameRec_LoadDefault                     ; $4B7E
    ld b, MODE_TAKE_PHOTOS                        ; $4B81
    ld c, $03                                     ; $4B83
    call Fade_GoTo                                ; $4B85
    ret                                           ; $4B88


; C: handler of state $03 of mode $02 (word 3 of Mode02_StateTable)
Mode02_State03::
    ld hl, wLcdcShadow                            ; $4B89
    set 2, [hl]                                   ; $4B8C
    xor a                                         ; $4B8E
    ld [wKeysNew], a                              ; $4B8F
    ld a, $00                                     ; $4B92
    ld b, BANK(KeyPrompt_LoadSounds)              ; $4B94
    ld hl, KeyPrompt_LoadSounds                   ; $4B96
    call Far_CallKeepA                            ; $4B99
    ld a, $06                                     ; $4B9C
    ldh [hState], a                               ; $4B9E
    ret                                           ; $4BA0


; C: handler of state $06 of mode $02 (word 6 of Mode02_StateTable)
Mode02_State06::
    ld a, [wMode06_State0A_D8DF]                  ; $4BA1
    bit 0, a                                      ; $4BA4
    jp z, Jump_005_4c05                           ; $4BA6

    ld a, [wAlbum_SlotOp6D18_D932]                ; $4BA9
    cp $1e                                        ; $4BAC
    jr nz, jr_005_4bb8                            ; $4BAE

    ld b, MODE_TAKE_PHOTOS                        ; $4BB0
    ld c, $0d                                     ; $4BB2
    call Fade_GoToB                               ; $4BB4
    ret                                           ; $4BB7


jr_005_4bb8:
    push hl                                       ; $4BB8
    ld hl, wMode06_State0A_D896                   ; $4BB9
    set 0, [hl]                                   ; $4BBC
    pop hl                                        ; $4BBE
    xor a                                         ; $4BBF
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $4BC0
    ld b, BANK(Sram_LoadIdCard)                   ; $4BC3
    ld hl, Sram_LoadIdCard                        ; $4BC5
    call Far_Call                                 ; $4BC8
    call Copy_Inline                              ; $4BCB

    db $db, $da, $52, $da, $12, $00

    call Mem_ZeroInline                           ; $4BD4

    db $64, $da, $22, $00

    ld a, [wMode06_State00_D931]                  ; $4BDB
    ld [wSlotTagBorder], a                        ; $4BDE
    ld b, BANK(TakePhotos_StorePhoto)             ; $4BE1
    ld hl, TakePhotos_StorePhoto                  ; $4BE3
    call Far_Call                                 ; $4BE6
    ld b, BANK(Counters_AddTaken)                 ; $4BE9
    ld hl, Counters_AddTaken                      ; $4BEB
    call Far_Call                                 ; $4BEE
    ld de, $0001                                  ; $4BF1
    ld b, BANK(Kitts_Add)                         ; $4BF4
    ld hl, Kitts_Add                              ; $4BF6
    call Far_Call                                 ; $4BF9
    push hl                                       ; $4BFC
    ld hl, wMode06_State0A_D896                   ; $4BFD
    res 0, [hl]                                   ; $4C00
    pop hl                                        ; $4C02
    jr jr_005_4c13                                ; $4C03

Jump_005_4c05:
    ld a, [wMode06_State0A_D8DF]                  ; $4C05
    bit 1, a                                      ; $4C08
    jr z, jr_005_4c23                             ; $4C0A

    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $4C0C
    dec a                                         ; $4C0F
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $4C10

jr_005_4c13:
    ld hl, wLcdcShadow                            ; $4C13
    res 2, [hl]                                   ; $4C16
    call Serial_SetFarCallback                    ; $4C18

    dwb Far_ReturnJump

    ld a, $07                                     ; $4C1E
    ldh [hState], a                               ; $4C20
    ret                                           ; $4C22


jr_005_4c23:
    ld a, [wMode06_State0A_D8DF]                  ; $4C23
    bit 3, a                                      ; $4C26
    jr z, jr_005_4c51                             ; $4C28

    ld de, $c000                                  ; $4C2A
    ld hl, wMode0B_State04_D400                   ; $4C2D
    ld bc, $0200                                  ; $4C30
    call Copy_DEtoHL                              ; $4C33
    ld de, $c200                                  ; $4C36
    ld hl, $ce00                                  ; $4C39
    ld bc, $0200                                  ; $4C3C
    call Copy_DEtoHL                              ; $4C3F
    ld b, MODE_TAKE_PHOTOS                        ; $4C42
    ld c, $05                                     ; $4C44
    call Mode_SaveReturnD93D                      ; $4C46
    ld b, MODE_PRINTING                           ; $4C49
    ld c, $14                                     ; $4C4B
    call Fade_GoToB                               ; $4C4D
    ret                                           ; $4C50


jr_005_4c51:
    ret                                           ; $4C51


; C: handler of state $07 of mode $02 (word 7 of Mode02_StateTable)
Mode02_State07::
    di                                            ; $4C52
    call Serial_SetFarCallback                    ; $4C53

    dwb TakePhotos_FrameCallback3

    ld a, $01                                     ; $4C59
    ldh [hState], a                               ; $4C5B
    ei                                            ; $4C5D
    ret                                           ; $4C5E


; C: named by the code of Mode02_State01, TakePhotos_FrameCallback3 (05:4A82 05:5136); read in the runs by
; TakePhotos_FrameCallback3, Mode02_State01; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty.npz)
Mode02_State01_Tbl4C5F::
    db $08, $ff, $ff, $ff, $07, $ff, $ff, $ff, $06, $ff, $ff, $ff, $05, $ff, $ff, $ff
    db $03, $ff, $ff, $ff, $04, $ff, $ff, $ff, $01, $ff, $ff, $ff, $02, $ff, $ff, $ff
    db $00, $ff, $ff, $ff, $80, $ff, $ff, $ff, $00, $0e, $ff, $ff, $84, $85, $ff, $ff
    db $86, $87, $ff, $ff, $00, $10, $ff, $ff, $88, $89, $ff, $ff, $8a, $8b, $ff, $ff
    db $00, $12, $10, $18, $8c, $8d, $8e, $8f, $90, $91, $92, $93, $94, $95, $96, $97

; C: handler of state $08 of mode $02 (word 8 of Mode02_StateTable)
Mode02_State08::
    ld hl, wMode06_State0E_D8D3                   ; $4CAF
    bit 7, [hl]                                   ; $4CB2
    jr z, jr_005_4cc2                             ; $4CB4

    di                                            ; $4CB6
    call Serial_SetFarCallback                    ; $4CB7

    dwb TakePhotos_FrameCallback3

    ld a, $01                                     ; $4CBD
    ldh [hState], a                               ; $4CBF
    ei                                            ; $4CC1

jr_005_4cc2:
    ret                                           ; $4CC2


; C: handler of state $09 of mode $02 (word 9 of Mode02_StateTable)
Mode02_State09::
    ld a, $21                                     ; $4CC3
    call FrameRec_LoadDefault                     ; $4CC5
    ld de, Gfx_23_7950_Mode02_TakePhotos_State01  ; $4CC8
    ld a, $23                                     ; $4CCB
    ld hl, $8c00                                  ; $4CCD
    ld bc, $0300                                  ; $4CD0
    call Vram_CopyHBlankFar                       ; $4CD3
    call Keys_SetRepeatInline                     ; $4CD6

    dw $0a14

    ld de, ObjScript_02_5EFE_Mode02_TakePhotos_State01 + $12 ; $4CDB
    call Object_Create                            ; $4CDE
    ld de, ObjScript_02_5F2E_Mode02_TakePhotos_State01 + $8 ; $4CE1
    call Object_Create                            ; $4CE4
    di                                            ; $4CE7
    call Serial_SetFarCallback                    ; $4CE8

    dwb TakePhotos_FrameCallback2

    ld a, $01                                     ; $4CEE
    ldh [hState], a                               ; $4CF0
    ei                                            ; $4CF2
    ret                                           ; $4CF3


; C: handler of state $0A of mode $02 (word 10 of Mode02_StateTable)
Mode02_State0A::
    ld a, [wCamBrightnessSetpoint]                ; $4CF4
    ld b, BANK(Cam_PopcountLevelByIndex)          ; $4CF7
    ld hl, Cam_PopcountLevelByIndex               ; $4CF9
    call Far_CallKeepA                            ; $4CFC
    ld a, [wCamContrastRow]                       ; $4CFF
    ld c, a                                       ; $4D02
    ld a, [wCamGainSel]                           ; $4D03
    ld b, a                                       ; $4D06
    ld b, BANK(Cam_LoadRegisterSet_Far)           ; $4D07
    ld hl, Cam_LoadRegisterSet_Far                ; $4D09
    call Far_CallKeepA                            ; $4D0C
    ret                                           ; $4D0F


; I: handler of state $0C of mode $02 (word 12 of Mode02_StateTable): nothing enters it (no store of state $0C for
; mode $02, no ModeState_Set / inline / saved return with (2, $0C): byte search of the ROM)
Unused_Mode02_State0C::
    ld a, [wUnused_Mode02_State0C_D930]           ; $4D10
    call Unused_TakePhotos_SetPlaneMasks          ; $4D13
    call Serial_SetFarCallback                    ; $4D16

    dwb TakePhotos_FrameCallback3

    ld a, $01                                     ; $4D1C
    ldh [hState], a                               ; $4D1E
    ret                                           ; $4D20


; C: named by the code of TakePhotos_LoadFrameTiles (05:4DD4); read in the runs by TakePhotos_LoadFrameTiles; first
; read on the screen Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz)
TakePhotos_LoadFrameTiles_Tbl4D21::
    db $00, $40, $10, $00, $01, $00, $00, $00, $00, $41, $10, $00, $01, $00, $00, $00
    db $00, $42, $10, $00, $01, $00, $00, $00, $00, $43, $10, $00, $01, $00, $00, $00
    db $00, $44, $10, $00, $01, $00, $00, $00, $00, $45, $10, $00, $01, $00, $00, $00
    db $00, $46, $10, $00, $01, $00, $00, $00, $00, $47, $10, $00, $01, $00, $00, $00
    db $00, $48, $10, $00, $01, $00, $00, $00, $00, $49, $10, $00, $01, $00, $00, $00
    db $00, $4a, $10, $00, $01, $00, $00, $00, $00, $4b, $10, $00, $01, $00, $00, $00
    db $00, $4c, $10, $00, $01, $00, $00, $00, $00, $4d, $10, $00, $01, $00, $00, $00
    db $00, $4e, $10, $00, $01, $00, $00, $00, $00, $4f, $10, $00, $01, $00, $00, $00
    db $00, $50, $10, $00, $01, $00, $00, $00, $00, $51, $10, $00, $01, $00, $00, $00
    db $00, $52, $10, $00, $01, $00, $00, $00, $00, $53, $10, $00, $01

    db $00, $00, $00

; C: the tiles of frame [$D8FD] (record 05:4D21 + 8 x index: source, bank, length) into $8800, then a cursor object by
; A; first run in mode $02 state $01 (camera view); runs on its screen (02:01) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_LoadFrameTiles::
    push af                                       ; $4DC1
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4DC2
    ld c, a                                       ; $4DC5
    ld b, $00                                     ; $4DC6
    sla c                                         ; $4DC8
    rl b                                          ; $4DCA
    sla c                                         ; $4DCC
    rl b                                          ; $4DCE
    sla c                                         ; $4DD0
    rl b                                          ; $4DD2
    ld hl, TakePhotos_LoadFrameTiles_Tbl4D21      ; $4DD4
    add hl, bc                                    ; $4DD7
    ld a, [hl+]                                   ; $4DD8
    ld e, a                                       ; $4DD9
    ld a, [hl+]                                   ; $4DDA
    ld d, a                                       ; $4DDB
    ld a, [hl+]                                   ; $4DDC
    push af                                       ; $4DDD
    ld a, [hl+]                                   ; $4DDE
    ld c, a                                       ; $4DDF
    ld a, [hl+]                                   ; $4DE0
    ld b, a                                       ; $4DE1
    pop af                                        ; $4DE2
    ld hl, $8800                                  ; $4DE3
    call Vram_CopyHBlankFar                       ; $4DE6
    pop af                                        ; $4DE9
    cp $01                                        ; $4DEA
    jr z, jr_005_4dfc                             ; $4DEC

    cp $02                                        ; $4DEE
    jr z, jr_005_4e06                             ; $4DF0

    ld de, ObjScript_02_5E6B_Mode02_TakePhotos_State01 + $4 ; $4DF2
    ld bc, $4850                                  ; $4DF5
    call Object_CreateWithParam                   ; $4DF8
    ret                                           ; $4DFB


jr_005_4dfc:
    ld de, ObjScript_02_5E6B_Mode02_TakePhotos_State01 + $13 ; $4DFC
    ld bc, $f050                                  ; $4DFF
    call Object_CreateWithParam                   ; $4E02
    ret                                           ; $4E05


jr_005_4e06:
    ld de, ObjScript_02_5E6B_Mode02_TakePhotos_State01 + $22 ; $4E06
    ld bc, $b050                                  ; $4E09
    call Object_CreateWithParam                   ; $4E0C
    ret                                           ; $4E0F


; C: named by the code of TakePhotos_PlaceFrameObjects (05:4EC2); read in the runs by TakePhotos_PlaceFrameObjects;
; first read on the screen Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz)
TakePhotos_PlaceFrameObjects_Tbl4E10::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    db $4f, $34, $ff, $ff, $ff, $ff, $ff, $ff, $4f, $34, $ff, $ff, $ff, $ff, $ff, $ff
    db $4f, $34, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $57, $46, $ff, $ff, $ff, $ff
    db $ff, $ff, $57, $46, $ff, $ff, $ff, $ff, $ff, $ff, $57, $46, $ff, $ff, $ff, $ff
    db $4f, $34, $57, $46, $ff, $ff, $ff, $ff, $4f, $34, $57, $46, $ff, $ff, $ff, $ff
    db $4f, $34, $57, $46, $ff, $ff, $ff, $ff, $4f, $34, $57, $46, $ff, $ff, $ff, $ff

; C: up to four objects (05:5F6B, 5F72, 5F79) at the positions of record 05:4E10 + 8 x [$D8FD] ($FF = none): the
; decorations of the frame; runs on its screen (02:01 02:05) in the core replays (port/entry_modes_kitty.csv); code
; read
TakePhotos_PlaceFrameObjects::
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4EB0
    ld c, a                                       ; $4EB3
    ld b, $00                                     ; $4EB4
    sla c                                         ; $4EB6
    rl b                                          ; $4EB8
    sla c                                         ; $4EBA
    rl b                                          ; $4EBC
    sla c                                         ; $4EBE
    rl b                                          ; $4EC0
    ld hl, TakePhotos_PlaceFrameObjects_Tbl4E10   ; $4EC2
    add hl, bc                                    ; $4EC5
    ld a, [hl+]                                   ; $4EC6
    ld c, a                                       ; $4EC7
    ld a, [hl+]                                   ; $4EC8
    ld b, a                                       ; $4EC9
    cp $ff                                        ; $4ECA
    jr z, jr_005_4ed6                             ; $4ECC

    push hl                                       ; $4ECE
    ld de, ObjScript_02_5F6B_Mode02_TakePhotos_State01 ; $4ECF
    call Object_CreateWithParam                   ; $4ED2
    pop hl                                        ; $4ED5

jr_005_4ed6:
    ld a, [hl+]                                   ; $4ED6
    ld c, a                                       ; $4ED7
    ld a, [hl+]                                   ; $4ED8
    ld b, a                                       ; $4ED9
    cp $ff                                        ; $4EDA
    jr z, jr_005_4ee6                             ; $4EDC

    push hl                                       ; $4EDE
    ld de, ObjScript_02_5F6B_Mode02_TakePhotos_State01 + $7 ; $4EDF
    call Object_CreateWithParam                   ; $4EE2
    pop hl                                        ; $4EE5

jr_005_4ee6:
    ld a, [hl+]                                   ; $4EE6
    ld c, a                                       ; $4EE7
    ld a, [hl+]                                   ; $4EE8
    ld b, a                                       ; $4EE9
    cp $ff                                        ; $4EEA
    jr z, jr_005_4ef6                             ; $4EEC

    push hl                                       ; $4EEE
    ld de, ObjScript_02_5F6B_Mode02_TakePhotos_State01 + $E ; $4EEF
    call Object_CreateWithParam                   ; $4EF2
    pop hl                                        ; $4EF5

jr_005_4ef6:
    ld a, [hl+]                                   ; $4EF6
    ld c, a                                       ; $4EF7
    ld a, [hl+]                                   ; $4EF8
    ld b, a                                       ; $4EF9
    cp $ff                                        ; $4EFA
    jr z, jr_005_4f06                             ; $4EFC

    push hl                                       ; $4EFE
    ld de, ObjScript_02_5F6B_Mode02_TakePhotos_State01 + $7 ; $4EFF
    call Object_CreateWithParam                   ; $4F02
    pop hl                                        ; $4F05

jr_005_4f06:
    ret                                           ; $4F06


; C: $D8FF-$D902 = $FF, $D903-$D906 = 1, $D92D-$D92E = $41CE (a pointer); runs on its screen (02:01) in the core
; replays (port/entry_modes_kitty.csv); code read
TakePhotos_ResetFrameState::
    ld a, $ff                                     ; $4F07
    ld [wFrameAnim_StepA_D8FF], a                 ; $4F09
    ld [wFrameAnim_StepB_D900], a                 ; $4F0C
    ld [wFrameAnim_StepC_D901], a                 ; $4F0F
    ld [wFrameAnim_StepD_D902], a                 ; $4F12
    ld a, $01                                     ; $4F15
    ld [wFrameAnim_StepA_D903], a                 ; $4F17
    ld [wFrameAnim_StepB_D904], a                 ; $4F1A
    ld [wFrameAnim_StepC_D905], a                 ; $4F1D
    ld [wFrameAnim_StepD_D906], a                 ; $4F20
    ld a, $ce                                     ; $4F23
    ld [wTakePhotos_ResetFrameState_D92D], a      ; $4F25
    ld a, $41                                     ; $4F28
    ld [wTakePhotos_ResetFrameState_D92E], a      ; $4F2A
    ret                                           ; $4F2D


; C: Serial_SetFarCallback with 05:4F3F (inline argument)
TakePhotos_SetFrameCallback::
    call Serial_SetFarCallback                    ; $4F2E

    dwb TakePhotos_FrameCallback

    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4F34
    add $30                                       ; $4F37
    call FrameRec_LoadDefault                     ; $4F39
    jp Far_Return                                 ; $4F3C


; C: the callback set by 05:4F2E: Bank05_FrameUpdate, the sound requests of the keys ($D8D9), ...; mode $02 state $01
TakePhotos_FrameCallback::
    ld b, BANK(Bank05_FrameUpdate)                ; $4F3F
    ld hl, Bank05_FrameUpdate                     ; $4F41
    call Far_Call                                 ; $4F44
    ld a, [wKeysNew]                              ; $4F47
    bit PADB_A, a                                 ; $4F4A
    jr z, jr_005_4f75                             ; $4F4C

    push af                                       ; $4F4E
    ld a, SFX1_05                                 ; $4F4F
    ld [wSndSfx1], a                              ; $4F51
    pop af                                        ; $4F54

jr_005_4f55:
    push af                                       ; $4F55
    ld a, MUSIC_TAKE_PHOTOS                       ; $4F56
    ld [wSndMusicReq], a                          ; $4F58
    pop af                                        ; $4F5B
    ld a, [wMode06_State00_D931]                  ; $4F5C
    call FrameRec_LoadDefault                     ; $4F5F
    call Serial_SetFarCallback                    ; $4F62

    dwb TakePhotos_FrameCallback3

    ld a, $01                                     ; $4F68
    ldh [hState], a                               ; $4F6A
    call TakePhotos_PlaceFrameObjects             ; $4F6C
    call TakePhotos_ResetFrameState               ; $4F6F
    jp Far_Return                                 ; $4F72


jr_005_4f75:
    ld a, [wKeysNew]                              ; $4F75
    bit PADB_B, a                                 ; $4F78
    jr z, jr_005_4f83                             ; $4F7A

    ld a, $08                                     ; $4F7C
    ld [wTakePhotos_FrameCallback_D8FD], a        ; $4F7E
    jr jr_005_4f55                                ; $4F81

jr_005_4f83:
    ld a, [wKeysNewRepeat]                        ; $4F83
    bit PADB_UP, a                                ; $4F86
    jr z, jr_005_4fba                             ; $4F88

    push af                                       ; $4F8A
    ld a, SFX1_TAKE_PHOTOS_36                     ; $4F8B
    ld [wSndSfx1], a                              ; $4F8D
    pop af                                        ; $4F90
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4F91
    and a                                         ; $4F94
    jr z, jr_005_4ff5                             ; $4F95

    dec a                                         ; $4F97
    cp $ff                                        ; $4F98
    jr nz, jr_005_4f9e                            ; $4F9A

    ld a, $13                                     ; $4F9C

jr_005_4f9e:
    ld [wTakePhotos_FrameCallback_D8FD], a        ; $4F9E
    add $30                                       ; $4FA1
    call FrameRec_LoadTilesAndMap                 ; $4FA3
    call Rng_Next                                 ; $4FA6
    and $07                                       ; $4FA9
    xor a                                         ; $4FAB
    ld [wTakePhotos_FrameCallback_D92F], a        ; $4FAC
    ld a, $01                                     ; $4FAF
    call TakePhotos_LoadFrameTiles                ; $4FB1
    call TakePhotos_ResetFrameState               ; $4FB4
    jp Far_Return                                 ; $4FB7


jr_005_4fba:
    ld a, [wKeysNewRepeat]                        ; $4FBA
    bit PADB_DOWN, a                              ; $4FBD
    jr z, jr_005_4ff2                             ; $4FBF

    push af                                       ; $4FC1
    ld a, SFX1_TAKE_PHOTOS_36                     ; $4FC2
    ld [wSndSfx1], a                              ; $4FC4
    pop af                                        ; $4FC7
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $4FC8
    cp $13                                        ; $4FCB
    jr z, jr_005_4ff5                             ; $4FCD

    inc a                                         ; $4FCF
    cp $14                                        ; $4FD0
    jr nz, jr_005_4fd6                            ; $4FD2

    ld a, $00                                     ; $4FD4

jr_005_4fd6:
    ld [wTakePhotos_FrameCallback_D8FD], a        ; $4FD6
    add $30                                       ; $4FD9
    call FrameRec_LoadTilesAndMap                 ; $4FDB
    call Rng_Next                                 ; $4FDE
    and $07                                       ; $4FE1
    xor a                                         ; $4FE3
    ld [wTakePhotos_FrameCallback_D92F], a        ; $4FE4
    ld a, $02                                     ; $4FE7
    call TakePhotos_LoadFrameTiles                ; $4FE9
    call TakePhotos_ResetFrameState               ; $4FEC
    jp Far_Return                                 ; $4FEF


jr_005_4ff2:
    jp Far_Return                                 ; $4FF2


jr_005_4ff5:
    xor a                                         ; $4FF5
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $4FF6
    ld a, $00                                     ; $4FF9
    call TakePhotos_LoadFrameTiles                ; $4FFB
    call TakePhotos_ResetFrameState               ; $4FFE
    jp Far_Return                                 ; $5001


; C: handler of state $0B of mode $02 (word 11 of Mode02_StateTable)
Mode02_State0B::
    ld a, [wMode06_State00_D931]                  ; $5004
    call FrameRec_LoadDefault                     ; $5007
    rst Rst08_WaitVBlank                          ; $500A
    di                                            ; $500B
    call Serial_SetFarCallback                    ; $500C

    dwb TakePhotos_FrameCallback3

    ld a, $01                                     ; $5012
    ldh [hState], a                               ; $5014
    ei                                            ; $5016
    ret                                           ; $5017


; C: another frame callback of the camera view: Bank05_FrameUpdate, then the keys ($D8D8 bit 3) and 00:1680; runs on
; its screen (02:01) in the core replays (port/entry_modes_kitty.csv); code read
TakePhotos_FrameCallback2::
    ld b, BANK(Bank05_FrameUpdate)                ; $5018
    ld hl, Bank05_FrameUpdate                     ; $501A
    call Far_Call                                 ; $501D
    ld a, [wKeysHeld]                             ; $5020
    bit PADB_START, a                             ; $5023
    jr nz, jr_005_5040                            ; $5025

    push af                                       ; $5027
    ld a, SFX1_1D                                 ; $5028
    ld [wSndSfx1], a                              ; $502A
    pop af                                        ; $502D
    call Keys_SetRepeatInline                     ; $502E

    dw $0a14

    call Serial_SetFarCallback                    ; $5033

    dwb Bank05_FrameUpdate

    ld a, $0b                                     ; $5039
    ldh [hState], a                               ; $503B
    jp Far_Return                                 ; $503D


jr_005_5040:
    ld a, [wKeysNewRepeat]                        ; $5040
    bit PADB_UP, a                                ; $5043
    jr z, jr_005_505d                             ; $5045

    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $5047
    cp $01                                        ; $504A
    jr z, jr_005_505a                             ; $504C

    sub $01                                       ; $504E
    ld [wTakePhotos_FrameCallback2_DA1E], a       ; $5050
    push af                                       ; $5053
    ld a, SFX1_02                                 ; $5054
    ld [wSndSfx1], a                              ; $5056
    pop af                                        ; $5059

jr_005_505a:
    jp Far_Return                                 ; $505A


jr_005_505d:
    ld a, [wKeysNewRepeat]                        ; $505D
    bit PADB_DOWN, a                              ; $5060
    jr z, jr_005_507a                             ; $5062

    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $5064
    cp $10                                        ; $5067
    jr z, jr_005_5077                             ; $5069

    add $01                                       ; $506B
    ld [wTakePhotos_FrameCallback2_DA1E], a       ; $506D
    push af                                       ; $5070
    ld a, SFX1_02                                 ; $5071
    ld [wSndSfx1], a                              ; $5073
    pop af                                        ; $5076

jr_005_5077:
    jp Far_Return                                 ; $5077


jr_005_507a:
    ld a, [wKeysNewRepeat]                        ; $507A
    bit PADB_LEFT, a                              ; $507D
    jr z, jr_005_5097                             ; $507F

    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $5081
    cp $01                                        ; $5084
    jr z, jr_005_5094                             ; $5086

    sub $01                                       ; $5088
    ld [wTakePhotos_FrameCallback2_DA1F], a       ; $508A
    push af                                       ; $508D
    ld a, SFX1_01                                 ; $508E
    ld [wSndSfx1], a                              ; $5090
    pop af                                        ; $5093

jr_005_5094:
    jp Far_Return                                 ; $5094


jr_005_5097:
    ld a, [wKeysNewRepeat]                        ; $5097
    bit PADB_RIGHT, a                             ; $509A
    jr z, jr_005_50b4                             ; $509C

    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $509E
    cp $10                                        ; $50A1
    jr z, jr_005_50b1                             ; $50A3

    add $01                                       ; $50A5
    ld [wTakePhotos_FrameCallback2_DA1F], a       ; $50A7
    push af                                       ; $50AA
    ld a, SFX1_01                                 ; $50AB
    ld [wSndSfx1], a                              ; $50AD
    pop af                                        ; $50B0

jr_005_50b1:
    jp Far_Return                                 ; $50B1


jr_005_50b4:
    jp Far_Return                                 ; $50B4


; C: a frame callback that stops while $D8D4 is set, then the keys and the frame index $D8FD ($08 = last); runs on its
; screen (02:01) in the core replays (port/entry_modes_kitty.csv); code read
TakePhotos_FrameCallback3::
    ld b, BANK(Bank05_FrameUpdate)                ; $50B7
    ld hl, Bank05_FrameUpdate                     ; $50B9
    call Far_Call                                 ; $50BC
    ld a, [wFadeRunning]                          ; $50BF
    and a                                         ; $50C2
    jr z, jr_005_50c8                             ; $50C3

    jp Far_Return                                 ; $50C5


jr_005_50c8:
    ld a, [wKeysNew]                              ; $50C8
    bit PADB_B, a                                 ; $50CB
    jr z, jr_005_510d                             ; $50CD

    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $50CF
    and a                                         ; $50D2
    jr nz, jr_005_50f3                            ; $50D3

    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $50D5
    cp $08                                        ; $50D8
    jr nz, jr_005_5101                            ; $50DA

    push af                                       ; $50DC
    ld a, SFX3_08                                 ; $50DD
    ld [wSndSfx3], a                              ; $50DF
    pop af                                        ; $50E2
    call Serial_SetFarCallback                    ; $50E3

    dwb Bank05_FrameUpdate

    ld b, MODE_MAIN_MENU                          ; $50E9
    ld c, $00                                     ; $50EB
    call Fade_GoToB                               ; $50ED
    jp Far_Return                                 ; $50F0


jr_005_50f3:
    dec a                                         ; $50F3
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $50F4
    push af                                       ; $50F7
    ld a, SFX1_2A                                 ; $50F8
    ld [wSndSfx1], a                              ; $50FA
    pop af                                        ; $50FD
    jp Far_Return                                 ; $50FE


jr_005_5101:
    ld a, $08                                     ; $5101
    ld [wTakePhotos_FrameCallback_D8FD], a        ; $5103
    xor a                                         ; $5106
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $5107
    jp Far_Return                                 ; $510A


jr_005_510d:
    ld a, [wKeysNew]                              ; $510D
    bit PADB_A, a                                 ; $5110
    jp z, Jump_005_5159                           ; $5112

    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $5115
    inc a                                         ; $5118
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $5119
    cp $04                                        ; $511C
    jr z, jr_005_5145                             ; $511E

    push af                                       ; $5120
    ld a, SFX1_28                                 ; $5121
    ld [wSndSfx1], a                              ; $5123
    pop af                                        ; $5126
    ld a, [wTakePhotos_FrameCallback_D8FD]        ; $5127
    sla a                                         ; $512A
    sla a                                         ; $512C
    ld c, a                                       ; $512E
    ld a, [wTakePhotos_FrameCallback3_D8FE]       ; $512F
    add c                                         ; $5132
    ld c, a                                       ; $5133
    ld b, $00                                     ; $5134
    ld hl, Mode02_State01_Tbl4C5F                 ; $5136
    add hl, bc                                    ; $5139
    ld a, [hl]                                    ; $513A
    ld [wMode02_State01_D8FC], a                  ; $513B
    cp $ff                                        ; $513E
    jr z, jr_005_5145                             ; $5140

    jp Far_Return                                 ; $5142


jr_005_5145:
    push af                                       ; $5145
    ld a, SFX1_38                                 ; $5146
    ld [wSndSfx1], a                              ; $5148
    pop af                                        ; $514B
    call Serial_SetFarCallback                    ; $514C

    dwb Bank05_FrameUpdate

    ld a, $03                                     ; $5152
    ldh [hState], a                               ; $5154
    jp Far_Return                                 ; $5156


Jump_005_5159:
    ld a, [wKeysNewRepeat]                        ; $5159
    bit PADB_LEFT, a                              ; $515C
    jr z, jr_005_5173                             ; $515E

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $CA ; $5160
    call Object_Create                            ; $5163
    call Serial_SetFarCallback                    ; $5166

    dwb Bank05_FrameUpdate

    ld a, $08                                     ; $516C
    ldh [hState], a                               ; $516E
    jp Far_Return                                 ; $5170


jr_005_5173:
    ld a, [wKeysNewRepeat]                        ; $5173
    bit PADB_RIGHT, a                             ; $5176
    jr z, jr_005_518d                             ; $5178

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $62 ; $517A
    call Object_Create                            ; $517D
    call Serial_SetFarCallback                    ; $5180

    dwb Bank05_FrameUpdate

    ld a, $08                                     ; $5186
    ldh [hState], a                               ; $5188
    jp Far_Return                                 ; $518A


jr_005_518d:
    ld a, [wKeysNew]                              ; $518D
    and PADF_UP | PADF_DOWN                       ; $5190
    jr z, jr_005_51bd                             ; $5192

    push af                                       ; $5194
    ld a, MUSIC_27                                ; $5195
    ld [wSndMusicReq], a                          ; $5197
    pop af                                        ; $519A
    push af                                       ; $519B
    ld a, SFX1_11                                 ; $519C
    ld [wSndSfx1], a                              ; $519E
    pop af                                        ; $51A1
    xor a                                         ; $51A2
    ld [wTakePhotos_FrameCallback3_D8FE], a       ; $51A3
    call Rng_Next                                 ; $51A6
    and $07                                       ; $51A9
    xor a                                         ; $51AB
    ld [wTakePhotos_FrameCallback_D92F], a        ; $51AC
    call Serial_SetFarCallback                    ; $51AF

    dwb TakePhotos_SetFrameCallback

    ld a, $00                                     ; $51B5
    call TakePhotos_LoadFrameTiles                ; $51B7
    jp Far_Return                                 ; $51BA


jr_005_51bd:
    ld a, [wKeysNew]                              ; $51BD
    bit PADB_SELECT, a                            ; $51C0
    jr z, jr_005_51c7                             ; $51C2

    jp Far_Return                                 ; $51C4


jr_005_51c7:
    ld a, [wKeysHeld]                             ; $51C7
    bit PADB_START, a                             ; $51CA
    jr z, jr_005_51e2                             ; $51CC

    push af                                       ; $51CE
    ld a, SFX1_0B                                 ; $51CF
    ld [wSndSfx1], a                              ; $51D1
    pop af                                        ; $51D4
    ld a, $09                                     ; $51D5
    ldh [hState], a                               ; $51D7
    call Serial_SetFarCallback                    ; $51D9

    dwb Bank05_FrameUpdate

    jp Far_Return                                 ; $51DF


jr_005_51e2:
    jp Far_Return                                 ; $51E2


; C: handler of state $0D of mode $02 (word 13 of Mode02_StateTable)
Mode02_State0D::
    di                                            ; $51E5
    call Lcd_Off                                  ; $51E6
    call Oam_ClearShadow                          ; $51E9
    ld b, BANK(Objects_ClearAll)                  ; $51EC
    ld hl, Objects_ClearAll                       ; $51EE
    call Far_Call                                 ; $51F1
    ld b, BANK(ScriptSlots_Clear)                 ; $51F4
    ld hl, ScriptSlots_Clear                      ; $51F6
    call Far_Call                                 ; $51F9
    call Stat_SetTileToggleAt4F                   ; $51FC
    call Serial_SetFarCallback                    ; $51FF

    dwb Bank05_FrameUpdate

    push af                                       ; $5205
    ld a, MUSIC_TAKE_PHOTOS_02_0D                 ; $5206
    ld [wSndMusicReq], a                          ; $5208
    pop af                                        ; $520B
    call Lcd_SetupInline                          ; $520C

    db $87, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    ld a, $01                                     ; $521A
    ld b, BANK(Photo_FindSlotA)                   ; $521C
    ld hl, Photo_FindSlotA                        ; $521E
    call Far_CallKeepA                            ; $5221
    ld b, BANK(Photo_LoadToVram)                  ; $5224
    ld hl, Photo_LoadToVram                       ; $5226
    call Far_CallKeepA                            ; $5229
    ld a, $24                                     ; $522C
    call FrameRec_LoadDefault                     ; $522E
    ld a, $01                                     ; $5231
    ld b, BANK(KeyPrompt_LoadSounds)              ; $5233
    ld hl, KeyPrompt_LoadSounds                   ; $5235
    call Far_CallKeepA                            ; $5238
    ld b, MODE_TAKE_PHOTOS                        ; $523B
    ld c, $0e                                     ; $523D
    call Fade_GoTo                                ; $523F
    ei                                            ; $5242
    ret                                           ; $5243


; C: handler of state $0E of mode $02 (word 14 of Mode02_StateTable)
Mode02_State0E::
    ld a, [wMode06_State0A_D8DF]                  ; $5244
    bit 0, a                                      ; $5247
    jr z, jr_005_5295                             ; $5249

    push hl                                       ; $524B
    ld hl, wMode06_State0A_D896                   ; $524C
    set 0, [hl]                                   ; $524F
    pop hl                                        ; $5251
    ld a, $01                                     ; $5252
    ld b, BANK(Photo_FindSlotA)                   ; $5254
    ld hl, Photo_FindSlotA                        ; $5256
    call Far_CallKeepA                            ; $5259
    jr c, jr_005_5280                             ; $525C

    push af                                       ; $525E
    ld b, BANK(Photo_RemoveFromVector)            ; $525F
    ld hl, Photo_RemoveFromVector                 ; $5261
    call Far_CallKeepA                            ; $5264
    ld b, BANK(Sram_StoreVector)                  ; $5267
    ld hl, Sram_StoreVector                       ; $5269
    call Far_Call                                 ; $526C
    pop af                                        ; $526F
    ld b, BANK(Sram_WritePhotoInfo)               ; $5270
    ld hl, Sram_WritePhotoInfo                    ; $5272
    call Far_CallKeepA                            ; $5275
    ld b, BANK(Counters_AddErased)                ; $5278
    ld hl, Counters_AddErased                     ; $527A
    call Far_Call                                 ; $527D

jr_005_5280:
    push hl                                       ; $5280
    ld hl, wMode06_State0A_D896                   ; $5281
    res 0, [hl]                                   ; $5284
    pop hl                                        ; $5286
    call Serial_SetFarCallback                    ; $5287

    dwb Bank05_FrameUpdate

    ld b, MODE_TAKE_PHOTOS                        ; $528D
    ld c, $04                                     ; $528F
    call Fade_GoToB                               ; $5291
    ret                                           ; $5294


jr_005_5295:
    ld a, [wMode06_State0A_D8DF]                  ; $5295
    bit 1, a                                      ; $5298
    jr z, jr_005_52aa                             ; $529A

    call Serial_SetFarCallback                    ; $529C

    dwb Bank05_FrameUpdate

    ld b, MODE_TAKE_PHOTOS                        ; $52A2
    ld c, $04                                     ; $52A4
    call Fade_GoToB                               ; $52A6
    ret                                           ; $52A9


jr_005_52aa:
    ret                                           ; $52AA


; C: ModeTable entry $02: BGB screens 02:01 (camera view) and 02:06 (photo taken)
Mode02_TakePhotos::
    ldh a, [hState]                               ; $52AB
    ld hl, Mode02_StateTable                      ; $52AD
    call JumpTable_ByA                            ; $52B0
    jp Far_Return                                 ; $52B3


; C: state table of mode $02, read by $0189 with hFF8E
Mode02_StateTable::
    dw Mode02_State00
    dw Mode02_State01
    dw Mode02_State02
    dw Mode02_State03
    dw Mode02_State04
    dw Mode02_State05
    dw Mode02_State06
    dw Mode02_State07
    dw Mode02_State08
    dw Mode02_State09
    dw Mode02_State0A
    dw Mode02_State0B
    dw Unused_Mode02_State0C
    dw Mode02_State0D
    dw Mode02_State0E

    db $00, $1e, $5a, $50, $6b, $c0, $03, $c0, $03, $e0, $01, $04, $45, $05, $06, $00
    db $00, $3e, $5a, $50, $6d, $00, $03, $00, $03, $00, $01, $2c, $45, $04, $04, $00
    db $00, $66, $5a, $50, $6e, $00, $03, $80, $01, $80, $00, $2c, $45, $04, $02, $00
    db $00, $a6, $5a, $50, $6f, $80, $02, $40, $01, $40, $00, $40, $45, $02, $02, $00
    db $00, $06, $5b, $50, $70, $40, $01, $a0, $00, $20, $00, $40, $45, $01, $02, $00
    db $00, $00, $62, $10, $00, $00, $42, $60, $42, $00, $62, $10, $00, $00, $42, $60
    db $42, $00, $62, $10, $00, $00, $42, $60, $42, $00, $62, $10, $00, $00, $42, $60
    db $42, $00, $40, $13, $00, $00, $41, $60, $41, $00, $40, $13, $00, $00, $41, $60
    db $41, $00, $40, $13, $00, $00, $41, $60, $41, $00, $40, $13, $00, $00, $41, $60
    db $41, $00, $6a, $27, $00, $00, $40, $60, $40, $00, $6a, $27, $00, $00, $40, $60
    db $40, $00, $6a, $27, $00, $00, $40, $60, $40, $00, $6a, $27, $00, $00, $40, $60
    db $40, $ff, $ff, $ff, $80, $00, $43, $60, $43, $00, $00, $00, $00, $00, $53, $60
    db $53, $ff, $ff, $ff, $a0, $00, $4e, $60, $4e, $00, $00, $00, $20, $00, $5f, $60
    db $5f, $ff, $ff, $ff, $80, $00, $44, $60, $44, $00, $00, $00, $00, $00, $54, $60
    db $54, $ff, $ff, $ff, $a0, $00, $4f, $60, $4f, $00, $00, $00, $20, $00, $69, $60
    db $69, $ff, $ff, $ff, $80, $00, $45, $60, $45, $00, $00, $00, $00, $00, $5d, $60
    db $5d, $ff, $ff, $ff, $a0, $00, $50, $60, $50, $00, $00, $00, $20, $00, $6a, $60
    db $6a, $ff, $ff, $ff, $80, $00, $4c, $60, $4c, $00, $00, $00, $00, $00, $5e, $60
    db $5e, $ff, $ff, $ff, $a0, $00, $51, $60, $51, $00, $00, $00, $20, $00, $6b, $60
    db $6b, $00, $6c, $0d, $00, $00, $4d, $60, $4d, $00, $6c, $0d, $20, $00, $52, $60
    db $52, $00, $6c, $0d, $00, $00, $4d, $60, $4d, $00, $6c, $0d, $20, $00, $52, $60
    db $52, $00, $40, $0c, $0f, $d5, $52, $25, $53, $00, $40, $0b, $15, $e5, $52, $45
    db $53, $40, $66, $22, $07, $f5, $52, $65, $53, $00, $40, $11, $30, $15, $53, $85
    db $53, $00, $60, $12, $30, $15, $53, $a5, $53, $00, $40, $0a, $30, $05, $53, $c5
    db $53, $00, $40, $1c, $12, $05, $53, $e5, $53, $00, $40, $0e, $1f, $05, $53, $05
    db $54

; C: copies the 8-byte record 05:5425 + 8 x [$D996] into $D9C6 and the 16 bytes at [$D9CA] into $D9CE; runs on its
; screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_SelectCategory::
    ld a, [wStamp_CursorUpdate_D996]              ; $5465
    ld c, a                                       ; $5468
    ld b, $00                                     ; $5469
    sla c                                         ; $546B
    rl b                                          ; $546D
    sla c                                         ; $546F
    rl b                                          ; $5471
    sla c                                         ; $5473
    rl b                                          ; $5475
    ld hl, Mode02_StateTable + $16F               ; $5477
    add hl, bc                                    ; $547A
    ld e, l                                       ; $547B
    ld d, h                                       ; $547C
    ld c, $08                                     ; $547D
    ld hl, wStamp_SelectCategory_D9C6             ; $547F

jr_005_5482:
    ld a, [de]                                    ; $5482
    ld [hl+], a                                   ; $5483
    inc de                                        ; $5484
    dec c                                         ; $5485
    jr nz, jr_005_5482                            ; $5486

    ld c, $10                                     ; $5488
    ld a, [wStamp_SelectCategory_D9CA]            ; $548A
    ld e, a                                       ; $548D
    ld a, [wStamp_SelectCategory_D9CB]            ; $548E
    ld d, a                                       ; $5491
    ld hl, wStamp_SelectCategory_D9CE             ; $5492

jr_005_5495:
    ld a, [de]                                    ; $5495
    ld [hl+], a                                   ; $5496
    inc de                                        ; $5497
    dec c                                         ; $5498
    jr nz, jr_005_5495                            ; $5499

    ld c, $08                                     ; $549B
    ld a, [wStamp_SelectCategory_D9CC]            ; $549D
    ld l, a                                       ; $54A0
    ld a, [wStamp_SelectCategory_D9CD]            ; $54A1
    ld h, a                                       ; $54A4
    ld a, [wStamp_CursorUpdate_D997]              ; $54A5
    sla a                                         ; $54A8
    sla a                                         ; $54AA
    sla a                                         ; $54AC
    ld e, a                                       ; $54AE
    ld d, $00                                     ; $54AF
    add hl, de                                    ; $54B1
    ld e, l                                       ; $54B2
    ld d, h                                       ; $54B3
    ld hl, wStamp_SelectCategory_D9DE             ; $54B4

jr_005_54b7:
    ld a, [de]                                    ; $54B7
    ld [hl+], a                                   ; $54B8
    inc de                                        ; $54B9
    dec c                                         ; $54BA
    jr nz, jr_005_54b7                            ; $54BB

    ld a, [wStamp_SelectCategory_D9DA]            ; $54BD
    sla a                                         ; $54C0
    sla a                                         ; $54C2
    ld [wStamp_ObjPlaceOnStart_D9AD], a           ; $54C4
    ld a, [wStamp_SelectCategory_D9DB]            ; $54C7
    sla a                                         ; $54CA
    sla a                                         ; $54CC
    ld [wStamp_ObjPlaceOnStart_D9AE], a           ; $54CE
    jp Far_Return                                 ; $54D1


; C: $100 bytes of map from [$D9D0] (bank $23) into the window map $9C00 (Vram_CopyHBlankFar); mode $05
Stamp_LoadWindowMap::
    ld a, [wStamp_LoadWindowMap_D9D0]             ; $54D4
    ld e, a                                       ; $54D7
    ld a, [wStamp_LoadWindowMap_D9D1]             ; $54D8
    ld d, a                                       ; $54DB
    ld hl, $9c00                                  ; $54DC
    ld bc, $0100                                  ; $54DF
    ld a, $23                                     ; $54E2
    call Vram_CopyHBlankFar                       ; $54E4
    jp Far_Return                                 ; $54E7


; C: $100 bytes of map from 23:7150 into the window map $9C00; mode $05
Stamp_LoadWindowMapDefault::
    ld de, Map_23_7150_Stamp_LoadWindowMapDefault ; $54EA
    ld hl, $9c00                                  ; $54ED
    ld bc, $0100                                  ; $54F0
    ld a, $23                                     ; $54F3
    call Vram_CopyHBlankFar                       ; $54F5

; C: tiles of stamp [$D998 + $D996] (00:0C25 multiply) from bank [$D9C8] into $8A00, length [$D9D2]; runs on its
; screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_LoadPageTiles::
    ld a, [wStamp_LoadPageTiles_D9D4]             ; $54F8
    ld c, a                                       ; $54FB
    ld a, [wStamp_LoadPageTiles_D9D5]             ; $54FC
    ld b, a                                       ; $54FF
    ld hl, wStamp_CursorUpdate_D998               ; $5500
    ld a, [wStamp_CursorUpdate_D996]              ; $5503
    ld e, a                                       ; $5506
    ld d, $00                                     ; $5507
    add hl, de                                    ; $5509
    ld a, [hl]                                    ; $550A
    call Mul_8x16                                 ; $550B
    ld a, [wStamp_SelectCategory_D9C6]            ; $550E
    ld e, a                                       ; $5511
    ld a, [wStamp_LoadPageTiles_D9C7]             ; $5512
    ld d, a                                       ; $5515
    add hl, de                                    ; $5516
    ld e, l                                       ; $5517
    ld d, h                                       ; $5518
    ld hl, $8a00                                  ; $5519
    ld a, [wStamp_LoadPageTiles_D9D2]             ; $551C
    ld c, a                                       ; $551F
    ld a, [wStamp_LoadPageTiles_D9D3]             ; $5520
    ld b, a                                       ; $5523
    ld a, [wStamp_LoadPageTiles_D9C8]             ; $5524
    call Vram_CopyHBlankFar                       ; $5527
    jp Far_Return                                 ; $552A


; C: two blocks of $60 bytes from [$D9E2] and [$D9E4] (bank $0D) into $8600 and $8660; runs on its screen (05:06) in
; the core replays (port/entry_modes_kitty.csv); code read
Stamp_LoadSmallTiles::
    ld a, [wStamp_LoadSmallTiles_D9E2]            ; $552D
    ld e, a                                       ; $5530
    ld a, [wStamp_LoadSmallTiles_D9E3]            ; $5531
    ld d, a                                       ; $5534
    ld hl, $8600                                  ; $5535
    ld bc, $0060                                  ; $5538
    ld a, $0d                                     ; $553B
    call Vram_CopyHBlankFar                       ; $553D
    ld a, [wStamp_LoadSmallTiles_D9E4]            ; $5540
    ld e, a                                       ; $5543
    ld a, [wStamp_LoadSmallTiles_D9E5]            ; $5544
    ld d, a                                       ; $5547
    ld hl, $8660                                  ; $5548
    ld bc, $0060                                  ; $554B
    ld a, $0d                                     ; $554E
    call Vram_CopyHBlankFar                       ; $5550
    jp Far_Return                                 ; $5553


; C: clears the four stamp buffers (00:01F2 x4), loads graphics and mask (05:559C, 05:55E2), Stamp_ArrangeGfx,
; Stamp_ArrangeMaskInverted, Stamp_MirrorIfFlagged, then copies $C000 to $8A00 and $C1E0 to $8C00
Stamp_LoadSelected::
    call Mem_ZeroInline                           ; $5556

    db $00, $c0, $e0, $01

    call Mem_ZeroInline                           ; $555D

    db $c0, $c3, $e0, $01

    call Mem_ZeroInline                           ; $5564

    db $e0, $c1, $e0, $01

    call Mem_ZeroInline                           ; $556B

    db $a0, $c5, $f0, $00

    call Stamp_LoadGfx                            ; $5572
    call Stamp_LoadMask                           ; $5575
    call Stamp_ArrangeGfx                         ; $5578
    call Stamp_ArrangeMaskInverted                ; $557B
    call Stamp_MirrorIfFlagged                    ; $557E
    ld de, $c000                                  ; $5581
    ld hl, $8a00                                  ; $5584
    ld bc, $01e0                                  ; $5587
    call Vram_CopyHBlank                          ; $558A
    ld de, $c1e0                                  ; $558D
    ld hl, $8c00                                  ; $5590
    ld bc, $01e0                                  ; $5593
    call Vram_CopyHBlank                          ; $5596
    jp Far_Return                                 ; $5599


; C: the graphics of stamp [$D998 + $D996] from bank [$D9C8], offset [$D9C6], into $C3C0 (Copy_FarDEtoHL)
Stamp_LoadGfx::
    ld a, [wStamp_LoadPageTiles_D9D4]             ; $559C
    ld c, a                                       ; $559F
    ld a, [wStamp_LoadPageTiles_D9D5]             ; $55A0
    ld b, a                                       ; $55A3
    ld hl, wStamp_CursorUpdate_D998               ; $55A4
    ld a, [wStamp_CursorUpdate_D996]              ; $55A7
    ld e, a                                       ; $55AA
    ld d, $00                                     ; $55AB
    add hl, de                                    ; $55AD
    ld a, [hl]                                    ; $55AE
    call Mul_8x16                                 ; $55AF
    ld e, l                                       ; $55B2
    ld d, h                                       ; $55B3
    ld a, [wStamp_LoadMask_D9D6]                  ; $55B4
    ld c, a                                       ; $55B7
    ld a, [wStamp_LoadMask_D9D7]                  ; $55B8
    ld b, a                                       ; $55BB
    ld a, [wStamp_CursorUpdate_D9A8]              ; $55BC
    sub $02                                       ; $55BF
    call Mul_8x16                                 ; $55C1
    add hl, de                                    ; $55C4
    ld a, [wStamp_SelectCategory_D9C6]            ; $55C5
    ld e, a                                       ; $55C8
    ld a, [wStamp_LoadPageTiles_D9C7]             ; $55C9
    ld d, a                                       ; $55CC
    add hl, de                                    ; $55CD
    ld e, l                                       ; $55CE
    ld d, h                                       ; $55CF
    ld hl, $c3c0                                  ; $55D0
    ld a, [wStamp_LoadMask_D9D6]                  ; $55D3
    ld c, a                                       ; $55D6
    ld a, [wStamp_LoadMask_D9D7]                  ; $55D7
    ld b, a                                       ; $55DA
    ld a, [wStamp_LoadPageTiles_D9C8]             ; $55DB
    call Copy_FarDEtoHL                           ; $55DE
    ret                                           ; $55E1


; C: the mask of the same stamp into $C5A0 when $D9E0 is neither 0 nor $FF (read in part); runs on its screen (05:06)
; in the core replays (port/entry_modes_kitty.csv); code read
Stamp_LoadMask::
    ld a, [wStamp_LoadMask_D9E0]                  ; $55E2
    and a                                         ; $55E5
    jr z, jr_005_563a                             ; $55E6

    cp $ff                                        ; $55E8
    jr z, jr_005_563a                             ; $55EA

    ld a, [wStamp_LoadPageTiles_D9D4]             ; $55EC
    ld c, a                                       ; $55EF
    ld a, [wStamp_LoadPageTiles_D9D5]             ; $55F0
    ld b, a                                       ; $55F3
    ld hl, wStamp_CursorUpdate_D998               ; $55F4
    ld a, [wStamp_CursorUpdate_D996]              ; $55F7
    ld e, a                                       ; $55FA
    ld d, $00                                     ; $55FB
    add hl, de                                    ; $55FD
    ld a, [hl]                                    ; $55FE
    call Mul_8x16                                 ; $55FF
    ld e, l                                       ; $5602
    ld d, h                                       ; $5603
    ld a, [wStamp_LoadMask_D9D6]                  ; $5604
    ld c, a                                       ; $5607
    ld a, [wStamp_LoadMask_D9D7]                  ; $5608
    ld b, a                                       ; $560B
    ld a, [wStamp_CursorUpdate_D9A8]              ; $560C
    sub $02                                       ; $560F
    call Mul_8x16                                 ; $5611
    add hl, de                                    ; $5614
    sra h                                         ; $5615
    rr l                                          ; $5617
    ld a, [wStamp_SelectCategory_D9DE]            ; $5619
    ld e, a                                       ; $561C
    ld a, [wStamp_LoadMask_D9DF]                  ; $561D
    ld d, a                                       ; $5620
    add hl, de                                    ; $5621
    ld e, l                                       ; $5622
    ld d, h                                       ; $5623
    ld hl, $c5a0                                  ; $5624
    ld a, [wStamp_LoadMask_D9D6]                  ; $5627
    ld c, a                                       ; $562A
    ld a, [wStamp_LoadMask_D9D7]                  ; $562B
    ld b, a                                       ; $562E
    sra b                                         ; $562F
    rr c                                          ; $5631
    ld a, [wStamp_LoadMask_D9E0]                  ; $5633
    call Copy_FarDEtoHL                           ; $5636
    ret                                           ; $5639


jr_005_563a:
    ld e, a                                       ; $563A
    ld hl, $c5a0                                  ; $563B
    ld a, [wStamp_LoadMask_D9D6]                  ; $563E
    ld c, a                                       ; $5641
    ld a, [wStamp_LoadMask_D9D7]                  ; $5642
    ld b, a                                       ; $5645
    sra b                                         ; $5646
    rr c                                          ; $5648
    call Mem_FillByte                             ; $564A
    ret                                           ; $564D


; C: copies the stamp tiles of $C3C0 into the work buffer $C000, [$D9DA] x [$D9DB] tiles, rows interleaved; mode $05
; (stamp window) setup
Stamp_ArrangeGfx::
    ld a, [wStamp_SelectCategory_D9DA]            ; $564E
    ld c, a                                       ; $5651
    ld a, [wStamp_SelectCategory_D9DB]            ; $5652
    ld b, a                                       ; $5655
    xor a                                         ; $5656
    ldh [hScratchA], a                            ; $5657
    ld hl, $c3c0                                  ; $5659
    ld de, $c000                                  ; $565C

jr_005_565f:
    push bc                                       ; $565F
    push de                                       ; $5660

jr_005_5661:
    ld b, $10                                     ; $5661

jr_005_5663:
    ld a, [hl+]                                   ; $5663
    ld [de], a                                    ; $5664
    inc de                                        ; $5665
    dec b                                         ; $5666
    jr nz, jr_005_5663                            ; $5667

    ld a, e                                       ; $5669
    add $10                                       ; $566A
    ld e, a                                       ; $566C
    jr nc, jr_005_5670                            ; $566D

    inc d                                         ; $566F

jr_005_5670:
    dec c                                         ; $5670
    jr nz, jr_005_5661                            ; $5671

    pop de                                        ; $5673
    pop bc                                        ; $5674
    ldh a, [hScratchA]                            ; $5675
    and a                                         ; $5677
    jr nz, jr_005_5687                            ; $5678

    ld a, e                                       ; $567A
    add $10                                       ; $567B
    ld e, a                                       ; $567D
    jr nc, jr_005_5681                            ; $567E

    inc d                                         ; $5680

jr_005_5681:
    ld a, $01                                     ; $5681
    ldh [hScratchA], a                            ; $5683
    jr jr_005_5691                                ; $5685

jr_005_5687:
    ld a, e                                       ; $5687
    add $90                                       ; $5688
    ld e, a                                       ; $568A
    jr nc, jr_005_568e                            ; $568B

    inc d                                         ; $568D

jr_005_568e:
    xor a                                         ; $568E
    ldh [hScratchA], a                            ; $568F

jr_005_5691:
    dec b                                         ; $5691
    jr nz, jr_005_565f                            ; $5692

    ret                                           ; $5694


; C: the same for the mask: $C5A0 into $C1E0, every byte complemented (cpl)
Stamp_ArrangeMaskInverted::
    ld a, [wStamp_SelectCategory_D9DA]            ; $5695
    ld c, a                                       ; $5698
    ld a, [wStamp_SelectCategory_D9DB]            ; $5699
    ld b, a                                       ; $569C
    xor a                                         ; $569D
    ldh [hScratchA], a                            ; $569E
    ld hl, $c5a0                                  ; $56A0
    ld de, $c1e0                                  ; $56A3

jr_005_56a6:
    push bc                                       ; $56A6
    push de                                       ; $56A7

jr_005_56a8:
    ld b, $08                                     ; $56A8

jr_005_56aa:
    ld a, [hl+]                                   ; $56AA
    cpl                                           ; $56AB
    ld [de], a                                    ; $56AC
    inc de                                        ; $56AD
    xor a                                         ; $56AE
    ld [de], a                                    ; $56AF
    inc de                                        ; $56B0
    dec b                                         ; $56B1
    jr nz, jr_005_56aa                            ; $56B2

    ld a, e                                       ; $56B4
    add $10                                       ; $56B5
    ld e, a                                       ; $56B7
    jr nc, jr_005_56bb                            ; $56B8

    inc d                                         ; $56BA

jr_005_56bb:
    dec c                                         ; $56BB
    jr nz, jr_005_56a8                            ; $56BC

    pop de                                        ; $56BE
    pop bc                                        ; $56BF
    ldh a, [hScratchA]                            ; $56C0
    and a                                         ; $56C2
    jr nz, jr_005_56d2                            ; $56C3

    ld a, e                                       ; $56C5
    add $10                                       ; $56C6
    ld e, a                                       ; $56C8
    jr nc, jr_005_56cc                            ; $56C9

    inc d                                         ; $56CB

jr_005_56cc:
    ld a, $01                                     ; $56CC
    ldh [hScratchA], a                            ; $56CE
    jr jr_005_56dc                                ; $56D0

jr_005_56d2:
    ld a, e                                       ; $56D2
    add $90                                       ; $56D3
    ld e, a                                       ; $56D5
    jr nc, jr_005_56d9                            ; $56D6

    inc d                                         ; $56D8

jr_005_56d9:
    xor a                                         ; $56D9
    ldh [hScratchA], a                            ; $56DA

jr_005_56dc:
    dec b                                         ; $56DC
    jr nz, jr_005_56a6                            ; $56DD

    ret                                           ; $56DF


; C: when $D9E1 bit 5 is set: mirrors the four stamp buffers $C000, $C1E0 (05:56FF), $C3C0 (05:5768) and $C5A0
; (05:57D1)
Stamp_MirrorIfFlagged::
    ld a, [wStamp_MirrorIfFlagged_D9E1]           ; $56E0
    and $20                                       ; $56E3
    ret z                                         ; $56E5

    ld hl, $c000                                  ; $56E6
    call Stamp_MirrorGfx                          ; $56E9
    ld hl, $c1e0                                  ; $56EC
    call Stamp_MirrorGfx                          ; $56EF
    ld hl, $c3c0                                  ; $56F2
    call Stamp_MirrorSrcGfx                       ; $56F5
    ld hl, $c5a0                                  ; $56F8
    call Stamp_MirrorSrcMask                      ; $56FB
    ret                                           ; $56FE


; C: horizontal mirror of a buffer [$D9DA] tiles wide: each byte bit-reversed and swapped with its mirror position
Stamp_MirrorGfx::
    push hl                                       ; $56FF
    ld a, [wStamp_SelectCategory_D9DA]            ; $5700
    ld b, a                                       ; $5703
    dec a                                         ; $5704
    sla a                                         ; $5705
    swap a                                        ; $5707
    ld e, a                                       ; $5709
    ld d, $00                                     ; $570A
    add hl, de                                    ; $570C
    ld e, l                                       ; $570D
    ld d, h                                       ; $570E
    ld a, b                                       ; $570F
    inc a                                         ; $5710
    srl a                                         ; $5711
    ld b, a                                       ; $5713
    pop hl                                        ; $5714
    ld a, $03                                     ; $5715

jr_005_5717:
    ldh [hScratchA], a                            ; $5717
    push bc                                       ; $5719
    push de                                       ; $571A
    push hl                                       ; $571B

jr_005_571c:
    ld c, $20                                     ; $571C

jr_005_571e:
    ld a, [de]                                    ; $571E
    srl a                                         ; $571F
    rl [hl]                                       ; $5721
    rr a                                          ; $5723
    rl [hl]                                       ; $5725
    rr a                                          ; $5727
    rl [hl]                                       ; $5729
    rr a                                          ; $572B
    rl [hl]                                       ; $572D
    rr a                                          ; $572F
    rl [hl]                                       ; $5731
    rr a                                          ; $5733
    rl [hl]                                       ; $5735
    rr a                                          ; $5737
    rl [hl]                                       ; $5739
    rr a                                          ; $573B
    rl [hl]                                       ; $573D
    rr a                                          ; $573F
    ld [de], a                                    ; $5741
    inc hl                                        ; $5742
    inc de                                        ; $5743
    dec c                                         ; $5744
    jr nz, jr_005_571e                            ; $5745

    ld a, e                                       ; $5747
    sub $40                                       ; $5748
    ld e, a                                       ; $574A
    jr nc, jr_005_574e                            ; $574B

    dec d                                         ; $574D

jr_005_574e:
    dec b                                         ; $574E
    jr nz, jr_005_571c                            ; $574F

    pop hl                                        ; $5751
    pop de                                        ; $5752
    pop bc                                        ; $5753
    ld a, e                                       ; $5754
    add $a0                                       ; $5755
    ld e, a                                       ; $5757
    jr nc, jr_005_575b                            ; $5758

    inc d                                         ; $575A

jr_005_575b:
    ld a, l                                       ; $575B
    add $a0                                       ; $575C
    ld l, a                                       ; $575E
    jr nc, jr_005_5762                            ; $575F

    inc h                                         ; $5761

jr_005_5762:
    ldh a, [hScratchA]                            ; $5762
    dec a                                         ; $5764
    jr nz, jr_005_5717                            ; $5765

    ret                                           ; $5767


; C: mirror of $C3C0 called beside 05:56FF by Stamp_MirrorIfFlagged (other row size; loop not read in full); runs on
; its screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_MirrorSrcGfx::
    push hl                                       ; $5768
    ld a, [wStamp_SelectCategory_D9DA]            ; $5769
    ld b, a                                       ; $576C
    dec a                                         ; $576D
    swap a                                        ; $576E
    ld e, a                                       ; $5770
    ld d, $00                                     ; $5771
    add hl, de                                    ; $5773
    ld e, l                                       ; $5774
    ld d, h                                       ; $5775
    ld a, b                                       ; $5776
    swap a                                        ; $5777
    ld c, a                                       ; $5779
    ld a, b                                       ; $577A
    inc a                                         ; $577B
    srl a                                         ; $577C
    ld b, a                                       ; $577E
    pop hl                                        ; $577F
    ld a, $06                                     ; $5780

jr_005_5782:
    ldh [hScratchA], a                            ; $5782
    push bc                                       ; $5784
    push de                                       ; $5785
    push hl                                       ; $5786

jr_005_5787:
    ld c, $10                                     ; $5787

jr_005_5789:
    ld a, [de]                                    ; $5789
    srl a                                         ; $578A
    rl [hl]                                       ; $578C
    rr a                                          ; $578E
    rl [hl]                                       ; $5790
    rr a                                          ; $5792
    rl [hl]                                       ; $5794
    rr a                                          ; $5796
    rl [hl]                                       ; $5798
    rr a                                          ; $579A
    rl [hl]                                       ; $579C
    rr a                                          ; $579E
    rl [hl]                                       ; $57A0
    rr a                                          ; $57A2
    rl [hl]                                       ; $57A4
    rr a                                          ; $57A6
    rl [hl]                                       ; $57A8
    rr a                                          ; $57AA
    ld [de], a                                    ; $57AC
    inc hl                                        ; $57AD
    inc de                                        ; $57AE
    dec c                                         ; $57AF
    jr nz, jr_005_5789                            ; $57B0

    ld a, e                                       ; $57B2
    sub $20                                       ; $57B3
    ld e, a                                       ; $57B5
    jr nc, jr_005_57b9                            ; $57B6

    dec d                                         ; $57B8

jr_005_57b9:
    dec b                                         ; $57B9
    jr nz, jr_005_5787                            ; $57BA

    pop hl                                        ; $57BC
    pop de                                        ; $57BD
    pop bc                                        ; $57BE
    ld a, e                                       ; $57BF
    add c                                         ; $57C0
    ld e, a                                       ; $57C1
    jr nc, jr_005_57c5                            ; $57C2

    inc d                                         ; $57C4

jr_005_57c5:
    ld a, l                                       ; $57C5
    add c                                         ; $57C6
    ld l, a                                       ; $57C7
    jr nc, jr_005_57cb                            ; $57C8

    inc h                                         ; $57CA

jr_005_57cb:
    ldh a, [hScratchA]                            ; $57CB
    dec a                                         ; $57CD
    jr nz, jr_005_5782                            ; $57CE

    ret                                           ; $57D0


; C: mirror of $C5A0 called beside 05:56FF by Stamp_MirrorIfFlagged (other row size; loop not read in full); runs on
; its screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_MirrorSrcMask::
    push hl                                       ; $57D1
    ld a, [wStamp_SelectCategory_D9DA]            ; $57D2
    ld b, a                                       ; $57D5
    dec a                                         ; $57D6
    swap a                                        ; $57D7
    srl a                                         ; $57D9
    ld e, a                                       ; $57DB
    ld d, $00                                     ; $57DC
    add hl, de                                    ; $57DE
    ld e, l                                       ; $57DF
    ld d, h                                       ; $57E0
    ld a, b                                       ; $57E1
    swap a                                        ; $57E2
    srl a                                         ; $57E4
    ld c, a                                       ; $57E6
    ld a, b                                       ; $57E7
    inc a                                         ; $57E8
    srl a                                         ; $57E9
    ld b, a                                       ; $57EB
    pop hl                                        ; $57EC
    ld a, $06                                     ; $57ED

jr_005_57ef:
    ldh [hScratchA], a                            ; $57EF
    push bc                                       ; $57F1
    push de                                       ; $57F2
    push hl                                       ; $57F3

jr_005_57f4:
    ld c, $08                                     ; $57F4

jr_005_57f6:
    ld a, [de]                                    ; $57F6
    srl a                                         ; $57F7
    rl [hl]                                       ; $57F9
    rr a                                          ; $57FB
    rl [hl]                                       ; $57FD
    rr a                                          ; $57FF
    rl [hl]                                       ; $5801
    rr a                                          ; $5803
    rl [hl]                                       ; $5805
    rr a                                          ; $5807
    rl [hl]                                       ; $5809
    rr a                                          ; $580B
    rl [hl]                                       ; $580D
    rr a                                          ; $580F
    rl [hl]                                       ; $5811
    rr a                                          ; $5813
    rl [hl]                                       ; $5815
    rr a                                          ; $5817
    ld [de], a                                    ; $5819
    inc hl                                        ; $581A
    inc de                                        ; $581B
    dec c                                         ; $581C
    jr nz, jr_005_57f6                            ; $581D

    ld a, e                                       ; $581F
    sub $10                                       ; $5820
    ld e, a                                       ; $5822
    jr nc, jr_005_5826                            ; $5823

    dec d                                         ; $5825

jr_005_5826:
    dec b                                         ; $5826
    jr nz, jr_005_57f4                            ; $5827

    pop hl                                        ; $5829
    pop de                                        ; $582A
    pop bc                                        ; $582B
    ld a, e                                       ; $582C
    add c                                         ; $582D
    ld e, a                                       ; $582E
    jr nc, jr_005_5832                            ; $582F

    inc d                                         ; $5831

jr_005_5832:
    ld a, l                                       ; $5832
    add c                                         ; $5833
    ld l, a                                       ; $5834
    jr nc, jr_005_5838                            ; $5835

    inc h                                         ; $5837

jr_005_5838:
    ldh a, [hScratchA]                            ; $5838
    dec a                                         ; $583A
    jr nz, jr_005_57ef                            ; $583B

    ret                                           ; $583D


; C: 05:5844 then Far_Return
Stamp_CursorCallback::
    call Stamp_CursorUpdate                       ; $583E
    jp Far_Return                                 ; $5841


; C: object callback: position from $D9A9-$D9AA; in step $D994 = 0 shows it (00:222C), = 2 reads the D-pad ($D8DA) to
; move it; runs on its screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_CursorUpdate::
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5E] ; $5844
    ld l, a                                       ; $5847
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5F] ; $5848
    ld h, a                                       ; $584B
    ld de, hGfx_00_1DAB_Mode12_SlideShow_State00_FFFA ; $584C
    add hl, de                                    ; $584F
    ld a, [wStamp_CursorUpdate_D9A9]              ; $5850
    ldh [hMode07_StateTable_FFD2], a              ; $5853
    ld a, [wStamp_CursorUpdate_D9AA]              ; $5855
    add [hl]                                      ; $5858
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5859
    ld a, [wStamp_ObjSlideIn_D994]                ; $585B
    and a                                         ; $585E
    jr z, jr_005_5866                             ; $585F

    cp $02                                        ; $5861
    jr z, jr_005_587a                             ; $5863

    ret                                           ; $5865


jr_005_5866:
    ld a, [wStamp_CursorUpdate_D9C4]              ; $5866
    ldh [hObject_RunAll_FFC5], a                  ; $5869
    ld a, [wStamp_CursorUpdate_D9C5]              ; $586B
    ldh [hObject_RunAll_FFC6], a                  ; $586E
    ld a, $03                                     ; $5870
    ldh [hObject_RunAll_FFC9], a                  ; $5872
    xor a                                         ; $5874
    ldh [hObject_RunAll_FFCA], a                  ; $5875
    jp Obj_HideSprite                             ; $5877


jr_005_587a:
    ld de, $0002                                  ; $587A
    ld a, [wKeysNewRepeat]                        ; $587D
    bit PADB_LEFT, a                              ; $5880
    jr nz, jr_005_58a2                            ; $5882

    inc e                                         ; $5884
    bit 4, a                                      ; $5885
    jr nz, jr_005_58a2                            ; $5887

    inc e                                         ; $5889
    bit 6, a                                      ; $588A
    jr nz, jr_005_58a2                            ; $588C

    inc e                                         ; $588E
    bit 7, a                                      ; $588F
    jr nz, jr_005_58a2                            ; $5891

    ld a, [wKeysNew]                              ; $5893
    inc e                                         ; $5896
    bit 0, a                                      ; $5897
    jp nz, Jump_005_5996                          ; $5899

    bit 1, a                                      ; $589C
    jp nz, Jump_005_59e1                          ; $589E

    ret                                           ; $58A1


jr_005_58a2:
    ld a, [wStamp_SelectCategory_D9CE]            ; $58A2
    ld c, a                                       ; $58A5
    ld a, [wStamp_CursorUpdate_D9CF]              ; $58A6
    ld b, a                                       ; $58A9
    ld a, [wStamp_CursorUpdate_D9A8]              ; $58AA
    ld l, a                                       ; $58AD
    ld h, $00                                     ; $58AE
    sla l                                         ; $58B0
    rl h                                          ; $58B2
    sla l                                         ; $58B4
    rl h                                          ; $58B6
    sla l                                         ; $58B8
    rl h                                          ; $58BA
    add hl, bc                                    ; $58BC
    add hl, de                                    ; $58BD
    ld a, [hl]                                    ; $58BE
    cp $f0                                        ; $58BF
    jr z, jr_005_5910                             ; $58C1

    cp $f1                                        ; $58C3
    jr z, jr_005_591e                             ; $58C5

    cp $f8                                        ; $58C7
    jp z, Jump_005_5956                           ; $58C9

    cp $f9                                        ; $58CC
    jp z, Jump_005_596a                           ; $58CE

    cp $ff                                        ; $58D1
    jr z, jr_005_590f                             ; $58D3

    ld [wStamp_CursorUpdate_D9A8], a              ; $58D5
    ld l, a                                       ; $58D8
    ld h, $00                                     ; $58D9
    sla l                                         ; $58DB
    rl h                                          ; $58DD
    sla l                                         ; $58DF
    rl h                                          ; $58E1
    sla l                                         ; $58E3
    rl h                                          ; $58E5
    add hl, bc                                    ; $58E7
    ld a, [hl+]                                   ; $58E8
    ldh [hMode07_StateTable_FFD2], a              ; $58E9
    ld [wStamp_CursorUpdate_D9A9], a              ; $58EB
    ld a, [hl+]                                   ; $58EE
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $58EF
    ld [wStamp_CursorUpdate_D9AA], a              ; $58F1
    ld bc, $0004                                  ; $58F4
    add hl, bc                                    ; $58F7
    ld a, [hl]                                    ; $58F8
    sla a                                         ; $58F9
    ld c, a                                       ; $58FB
    ld b, $00                                     ; $58FC
    ld hl, Stamp_CursorUpdate_Tbl5A14             ; $58FE
    add hl, bc                                    ; $5901
    ld a, [hl+]                                   ; $5902
    ld e, a                                       ; $5903
    ld d, [hl]                                    ; $5904
    call Call_000_2205                            ; $5905
    push af                                       ; $5908
    ld a, SFX1_20                                 ; $5909
    ld [wSndSfx1], a                              ; $590B
    pop af                                        ; $590E

jr_005_590f:
    ret                                           ; $590F


jr_005_5910:
    ld a, [wStamp_CursorUpdate_D996]              ; $5910
    dec a                                         ; $5913
    cp $ff                                        ; $5914
    jr nz, jr_005_5919                            ; $5916

    ret                                           ; $5918


jr_005_5919:
    ld [wStamp_CursorUpdate_D996], a              ; $5919
    jr jr_005_592a                                ; $591C

jr_005_591e:
    ld a, [wStamp_CursorUpdate_D996]              ; $591E
    inc a                                         ; $5921
    cp $08                                        ; $5922
    jr nz, jr_005_5927                            ; $5924

    ret                                           ; $5926


jr_005_5927:
    ld [wStamp_CursorUpdate_D996], a              ; $5927

jr_005_592a:
    push af                                       ; $592A
    ld a, SFX1_03                                 ; $592B
    ld [wSndSfx1], a                              ; $592D
    pop af                                        ; $5930
    xor a                                         ; $5931
    ld [wStamp_CursorUpdate_D997], a              ; $5932
    ld b, BANK(Stamp_SelectCategory)              ; $5935
    ld hl, Stamp_SelectCategory                   ; $5937
    call Far_Call                                 ; $593A
    ld b, BANK(Stamp_LoadWindowMapDefault)        ; $593D
    ld hl, Stamp_LoadWindowMapDefault             ; $593F
    call Far_Call                                 ; $5942
    ld b, BANK(Stamp_LoadWindowMap)               ; $5945
    ld hl, Stamp_LoadWindowMap                    ; $5947
    call Far_Call                                 ; $594A
    ld b, BANK(Stamp_LoadSmallTiles)              ; $594D
    ld hl, Stamp_LoadSmallTiles                   ; $594F
    call Far_Call                                 ; $5952
    ret                                           ; $5955


Jump_005_5956:
    ld hl, wStamp_CursorUpdate_D998               ; $5956
    ld a, [wStamp_CursorUpdate_D996]              ; $5959
    ld c, a                                       ; $595C
    ld b, $00                                     ; $595D
    add hl, bc                                    ; $595F
    ld a, [hl]                                    ; $5960
    cp $00                                        ; $5961
    jr z, jr_005_5969                             ; $5963

    dec a                                         ; $5965
    ld [hl], a                                    ; $5966
    jr jr_005_597e                                ; $5967

jr_005_5969:
    ret                                           ; $5969


Jump_005_596a:
    ld a, [wStamp_CursorUpdate_D9C9]              ; $596A
    ld e, a                                       ; $596D
    ld hl, wStamp_CursorUpdate_D998               ; $596E
    ld a, [wStamp_CursorUpdate_D996]              ; $5971
    ld c, a                                       ; $5974
    ld b, $00                                     ; $5975
    add hl, bc                                    ; $5977
    ld a, [hl]                                    ; $5978
    inc a                                         ; $5979
    cp e                                          ; $597A
    jr z, jr_005_5969                             ; $597B

    ld [hl], a                                    ; $597D

jr_005_597e:
    push af                                       ; $597E
    ld a, SFX1_20                                 ; $597F
    ld [wSndSfx1], a                              ; $5981
    pop af                                        ; $5984
    ld b, BANK(Stamp_SelectCategory)              ; $5985
    ld hl, Stamp_SelectCategory                   ; $5987
    call Far_Call                                 ; $598A
    ld b, BANK(Stamp_LoadPageTiles)               ; $598D
    ld hl, Stamp_LoadPageTiles                    ; $598F
    call Far_Call                                 ; $5992
    ret                                           ; $5995


Jump_005_5996:
    ld a, [wStamp_CursorUpdate_D9A8]              ; $5996
    cp $02                                        ; $5999
    jr nc, jr_005_59be                            ; $599B

    ld a, [wStamp_CursorUpdate_D997]              ; $599D
    inc a                                         ; $59A0
    and $03                                       ; $59A1
    ld [wStamp_CursorUpdate_D997], a              ; $59A3
    ld b, BANK(Stamp_SelectCategory)              ; $59A6
    ld hl, Stamp_SelectCategory                   ; $59A8
    call Far_Call                                 ; $59AB
    ld b, BANK(Stamp_LoadSmallTiles)              ; $59AE
    ld hl, Stamp_LoadSmallTiles                   ; $59B0
    call Far_Call                                 ; $59B3
    push af                                       ; $59B6
    ld a, SFX1_23                                 ; $59B7
    ld [wSndSfx1], a                              ; $59B9
    pop af                                        ; $59BC
    ret                                           ; $59BD


jr_005_59be:
    push af                                       ; $59BE
    ld a, SFX1_19                                 ; $59BF
    ld [wSndSfx1], a                              ; $59C1
    pop af                                        ; $59C4
    ld a, [wStamp_CursorUpdate_D9A9]              ; $59C5
    ld [wStamp_ObjPlaceOnStart_D9C2], a           ; $59C8
    ld a, [wStamp_CursorUpdate_D9AA]              ; $59CB
    ld [wStamp_ObjPlaceOnStart_D9C3], a           ; $59CE
    ldh a, [hObject_RunAll_FFC5]                  ; $59D1
    ld [wStamp_CursorUpdate_D9C4], a              ; $59D3
    ldh a, [hObject_RunAll_FFC6]                  ; $59D6
    ld [wStamp_CursorUpdate_D9C5], a              ; $59D8
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $59DB
    res 0, [hl]                                   ; $59DE
    ret                                           ; $59E0


Jump_005_59e1:
    push af                                       ; $59E1
    ld a, SFX1_31                                 ; $59E2
    ld [wSndSfx1], a                              ; $59E4
    pop af                                        ; $59E7
    ld a, [wStamp_ObjPlaceOnStart_D9AF]           ; $59E8
    ld [wStamp_CursorUpdate_D996], a              ; $59EB
    ld a, [wStamp_ObjPlaceOnStart_D9B0]           ; $59EE
    ld [wStamp_CursorUpdate_D997], a              ; $59F1
    ld de, wStamp_ObjPlaceOnStart_D9B1            ; $59F4
    ld hl, wStamp_CursorUpdate_D998               ; $59F7
    ld bc, $0010                                  ; $59FA
    call Copy_DEtoHL                              ; $59FD
    ld a, [wStamp_ObjPlaceOnStart_D9C1]           ; $5A00
    ld [wStamp_CursorUpdate_D9A8], a              ; $5A03
    ld b, BANK(Stamp_SelectCategory)              ; $5A06
    ld hl, Stamp_SelectCategory                   ; $5A08
    call Far_Call                                 ; $5A0B
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $5A0E
    res 0, [hl]                                   ; $5A11
    ret                                           ; $5A13


; C: named by the code of Stamp_CursorUpdate (05:58FE); read in the runs by Blit_MakePatchEntry, Stamp_CursorUpdate;
; first read on the screen Mode05_StampWindow_State06 (trace/read_screens_kitty.npz)
Stamp_CursorUpdate_Tbl5A14::
    INCBIN "data/bank_05/Stamp_CursorUpdate_Tbl5A14.bin" ; $5A14, 1094 bytes
; C: $D9F1-$D9F5 from the stamp position and size ($D9AB-$D9AE) and the buffer $C3C0, before Stamp_BlitOnPhoto; runs
; on its screen (05:06) in the core replays (port/entry_modes_kitty.csv); code read
Stamp_SetBlitArea::
    ldh a, [hRomBankShadow]                       ; $5E5A
    push af                                       ; $5E5C
    ld a, [wStamp_ObjPlaceOnStart_D9AD]           ; $5E5D
    ld b, a                                       ; $5E60
    sla a                                         ; $5E61
    ld [wStamp_SetShiftMasks_D9F1], a             ; $5E63
    ld a, [wStamp_ObjPlaceOnStart_D9AB]           ; $5E66
    sub b                                         ; $5E69
    ld b, a                                       ; $5E6A
    ld a, [wStamp_ObjPlaceOnStart_D9AE]           ; $5E6B
    ld c, a                                       ; $5E6E
    sla a                                         ; $5E6F
    ld [wStamp_SetBlitArea_D9F2], a               ; $5E71
    ld a, [wStamp_ObjPlaceOnStart_D9AC]           ; $5E74
    sub c                                         ; $5E77
    ld c, a                                       ; $5E78
    ld a, $c0                                     ; $5E79
    ld [wBlit_MaskPass_SrcA_D9F3], a              ; $5E7B
    ld a, $c3                                     ; $5E7E
    ld [wBlit_MaskPass_SrcA_D9F4], a              ; $5E80
    ld a, $00                                     ; $5E83
    ld [wBlit_MaskPass_SrcA_D9F5], a              ; $5E85
    ld a, $a0                                     ; $5E88
    ld [wBlit_MaskPass_SrcB_D9F6], a              ; $5E8A
    ld a, $c5                                     ; $5E8D
    ld [wBlit_MaskPass_SrcB_D9F7], a              ; $5E8F
    ld a, $00                                     ; $5E92
    ld [wBlit_MaskPass_SrcB_D9F8], a              ; $5E94
    call Stamp_BlitOnPhoto                        ; $5E97
    pop af                                        ; $5E9A
    ldh [hRomBankShadow], a                       ; $5E9B
    ld [$2100], a                                 ; $5E9D
    jp Far_Return                                 ; $5EA0


; C: Blit_BuildPatchList, the shift masks (05:5F29), Blit_MaskPass_SrcA or _SrcB by $D9E1 bit 7, 00:2BB9,
; Blit_ApplyPatchList; first run in mode $05 state $06 (core)
Stamp_BlitOnPhoto::
    call Blit_BuildPatchList                      ; $5EA3
    push bc                                       ; $5EA6
    call Stamp_SetShiftMasks                      ; $5EA7
    ld a, [wStamp_MirrorIfFlagged_D9E1]           ; $5EAA
    and $80                                       ; $5EAD
    jr nz, jr_005_5eb6                            ; $5EAF

    call Blit_MaskPass_SrcB                       ; $5EB1
    jr jr_005_5eb9                                ; $5EB4

jr_005_5eb6:
    call Blit_MaskPass_SrcA                       ; $5EB6

jr_005_5eb9:
    call Stamp_BlitFromD9F3                       ; $5EB9
    pop bc                                        ; $5EBC
    call Blit_ApplyPatchList                      ; $5EBD
    ret                                           ; $5EC0


; C: same code as the Japanese Blit_MakePatchEntry (00:1EEE, 44 bytes, masked match)
Blit_MakePatchEntry::
    push de                                       ; $5EC1
    ld a, c                                       ; $5EC2
    and $f8                                       ; $5EC3
    srl a                                         ; $5EC5
    srl a                                         ; $5EC7
    ld e, a                                       ; $5EC9
    ld d, $00                                     ; $5ECA
    ld hl, Stamp_CursorUpdate_Tbl5A14 + $152      ; $5ECC
    add hl, de                                    ; $5ECF
    ld a, [hl+]                                   ; $5ED0
    ld h, [hl]                                    ; $5ED1
    ld l, a                                       ; $5ED2
    ld a, b                                       ; $5ED3
    and $f8                                       ; $5ED4
    srl a                                         ; $5ED6
    srl a                                         ; $5ED8
    ld e, a                                       ; $5EDA
    add hl, de                                    ; $5EDB
    pop de                                        ; $5EDC
    ld a, c                                       ; $5EDD
    and $07                                       ; $5EDE
    sla a                                         ; $5EE0
    add [hl]                                      ; $5EE2
    ld [de], a                                    ; $5EE3
    inc hl                                        ; $5EE4
    inc de                                        ; $5EE5
    ld a, [hl]                                    ; $5EE6
    ld [de], a                                    ; $5EE7
    inc de                                        ; $5EE8
    inc de                                        ; $5EE9
    inc de                                        ; $5EEA
    inc de                                        ; $5EEB
    ret                                           ; $5EEC


; C: the Japanese Blit_BuildPatchList (00:1F1A), 37 instructions against 37, with 3 small edits (variables moved
; between HRAM and WRAM, bank shadow hFF8C stores, a ret in place of a jump, parameters set inside); code compared
Blit_BuildPatchList::
    push bc                                       ; $5EED
    ld hl, wStamp_SetShiftMasks_D9F1              ; $5EEE
    ld a, b                                       ; $5EF1
    and $07                                       ; $5EF2
    add [hl]                                      ; $5EF4
    dec a                                         ; $5EF5
    srl a                                         ; $5EF6
    srl a                                         ; $5EF8
    srl a                                         ; $5EFA
    inc a                                         ; $5EFC
    ld [wBlit_BuildPatchList_D9E7], a             ; $5EFD
    ld a, [wStamp_SetBlitArea_D9F2]               ; $5F00
    ld [wBlit_BuildPatchList_D9E6], a             ; $5F03
    ld de, $c800                                  ; $5F06
    ld a, [wBlit_BuildPatchList_D9E6]             ; $5F09

jr_005_5f0c:
    push af                                       ; $5F0C
    push bc                                       ; $5F0D
    ld a, [wBlit_BuildPatchList_D9E7]             ; $5F0E

jr_005_5f11:
    push af                                       ; $5F11
    call Blit_MakePatchEntry                      ; $5F12
    ld a, b                                       ; $5F15
    add $08                                       ; $5F16
    ld b, a                                       ; $5F18
    pop af                                        ; $5F19
    dec a                                         ; $5F1A
    jr nz, jr_005_5f11                            ; $5F1B

    pop bc                                        ; $5F1D
    pop af                                        ; $5F1E
    inc c                                         ; $5F1F
    dec a                                         ; $5F20
    jr nz, jr_005_5f0c                            ; $5F21

    pop bc                                        ; $5F23
    xor a                                         ; $5F24
    ld [de], a                                    ; $5F25
    inc de                                        ; $5F26
    ld [de], a                                    ; $5F27
    ret                                           ; $5F28


; C: for the x offset B & 7: the bit masks of 05:5F86 into $D9ED (and its complement $D9EE), $D9EA = $38 + (B & 7),
; the masks of 05:5F8E
Stamp_SetShiftMasks::
    ld a, b                                       ; $5F29
    and $07                                       ; $5F2A
    add $38                                       ; $5F2C
    ld [wStamp_BlitFromD9F3_D9EA], a              ; $5F2E
    ld a, b                                       ; $5F31
    and $07                                       ; $5F32
    ld e, a                                       ; $5F34
    ld d, $00                                     ; $5F35
    ld hl, Stamp_SetShiftMasks_Tbl5F86            ; $5F37
    add hl, de                                    ; $5F3A
    ld a, [hl]                                    ; $5F3B
    ld [wStamp_BlitFromD9F3_D9ED], a              ; $5F3C
    cpl                                           ; $5F3F
    ld [wBlit_MaskPass_SrcB_D9EE], a              ; $5F40
    ld hl, wStamp_SetShiftMasks_D9F1              ; $5F43
    ld a, b                                       ; $5F46
    add [hl]                                      ; $5F47
    and $07                                       ; $5F48
    ld e, a                                       ; $5F4A
    ld d, $00                                     ; $5F4B
    ld hl, Stamp_SetShiftMasks_Tbl5F86 + $8       ; $5F4D
    add hl, de                                    ; $5F50
    ld a, [hl]                                    ; $5F51
    ld [wStamp_BlitFromD9F3_D9EF], a              ; $5F52
    cpl                                           ; $5F55
    ld [wBlit_MaskPass_SrcB_D9F0], a              ; $5F56
    ld a, [wStamp_SetShiftMasks_D9F1]             ; $5F59
    dec a                                         ; $5F5C
    srl a                                         ; $5F5D
    srl a                                         ; $5F5F
    srl a                                         ; $5F61
    inc a                                         ; $5F63
    ld [wBlit_MaskPass_SrcB_D9E8], a              ; $5F64
    ld a, [wStamp_MirrorIfFlagged_D9E1]           ; $5F67
    and $40                                       ; $5F6A
    jr nz, jr_005_5f80                            ; $5F6C

    ld a, [wStamp_SetShiftMasks_D9F1]             ; $5F6E
    srl a                                         ; $5F71
    srl a                                         ; $5F73
    srl a                                         ; $5F75
    dec a                                         ; $5F77
    swap a                                        ; $5F78
    and $f0                                       ; $5F7A
    ld [wStamp_SetShiftMasks_D9E9], a             ; $5F7C
    ret                                           ; $5F7F


jr_005_5f80:
    ld a, $f0                                     ; $5F80
    ld [wStamp_SetShiftMasks_D9E9], a             ; $5F82
    ret                                           ; $5F85


; C: named by the code of Stamp_SetShiftMasks (05:5F37); read in the runs by Stamp_SetShiftMasks; first read on the
; screen Mode05_StampWindow_State06 (trace/read_screens_kitty.npz)
Stamp_SetShiftMasks_Tbl5F86::
    db $ff, $7f, $3f, $1f, $0f, $07, $03, $01, $ff, $80, $c0, $e0, $f0, $f8, $fc, $fe

; C: same code as the Japanese Blit_ApplyPatchList (00:213D, 51 bytes, exact match)
Blit_ApplyPatchList::
    ld hl, $c800                                  ; $5F96

jr_005_5f99:
    ld a, $04                                     ; $5F99

jr_005_5f9b:
    nop                                           ; $5F9B
    dec a                                         ; $5F9C
    jr nz, jr_005_5f9b                            ; $5F9D

    ld a, [hl+]                                   ; $5F9F
    ld e, a                                       ; $5FA0
    ld d, [hl]                                    ; $5FA1
    or d                                          ; $5FA2
    ret z                                         ; $5FA3

    inc hl                                        ; $5FA4
    ld a, [hl+]                                   ; $5FA5
    ld c, [hl]                                    ; $5FA6
    inc hl                                        ; $5FA7
    ld b, [hl]                                    ; $5FA8
    inc hl                                        ; $5FA9
    push hl                                       ; $5FAA
    ld l, a                                       ; $5FAB

jr_005_5fac:
    ldh a, [rLY]                                  ; $5FAC
    cp $20                                        ; $5FAE
    jr c, jr_005_5fac                             ; $5FB0

    cp $88                                        ; $5FB2
    jr nc, jr_005_5fac                            ; $5FB4

jr_005_5fb6:
    ldh a, [rSTAT]                                ; $5FB6
    and $03                                       ; $5FB8
    jr nz, jr_005_5fb6                            ; $5FBA

    ld a, [de]                                    ; $5FBC
    and l                                         ; $5FBD
    or c                                          ; $5FBE
    ld [de], a                                    ; $5FBF
    inc de                                        ; $5FC0
    ld a, [de]                                    ; $5FC1
    and l                                         ; $5FC2
    or b                                          ; $5FC3
    ld [de], a                                    ; $5FC4
    inc de                                        ; $5FC5
    pop hl                                        ; $5FC6
    jr jr_005_5f99                                ; $5FC7

; C: handler of state $00 of mode $05 (word 0 of Mode05_StateTable)
Mode05_State00::
    di                                            ; $5FC9
    call Lcd_Off                                  ; $5FCA
    call Oam_ClearShadow                          ; $5FCD
    ld b, BANK(Objects_ClearAll)                  ; $5FD0
    ld hl, Objects_ClearAll                       ; $5FD2
    call Far_Call                                 ; $5FD5
    ld b, BANK(ScriptSlots_Clear)                 ; $5FD8
    ld hl, ScriptSlots_Clear                      ; $5FDA
    call Far_Call                                 ; $5FDD
    call Copy_FarInline                           ; $5FE0

    db $00, $66, $25, $00, $86, $00, $0a

    call Copy_FarInline                           ; $5FEA

    db $50, $67, $23, $00, $98, $00, $04

    call Copy_FarInline                           ; $5FF4

    db $50, $6b, $23, $00, $9c, $20, $01

    call Stat_SetTileToggleCAt1F                  ; $5FFE
    ld a, $90                                     ; $6001
    ld [wDoodleFromShutterbug], a                 ; $6003
    ld a, $02                                     ; $6006
    ld [wStamp_ObjPlaceOnStart_D993], a           ; $6008
    call Serial_SetFarCallback                    ; $600B

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6011

    db $e7, $e4, $d0, $e4, $00, $00, $00, $90, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $601F

    dw $0214

    push af                                       ; $6024
    ld a, MUSIC_STAMP_WINDOW                      ; $6025
    ld [wSndMusicReq], a                          ; $6027
    pop af                                        ; $602A
    ei                                            ; $602B
    ld a, [wMode03_State02_D933]                  ; $602C
    ld b, BANK(Photo_FindSlotA)                   ; $602F
    ld hl, Photo_FindSlotA                        ; $6031
    call Far_CallKeepA                            ; $6034
    jr c, jr_005_6043                             ; $6037

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $6039
    ld hl, Photo_LoadToBufferAndVram              ; $603B
    call Far_CallKeepA                            ; $603E
    jr jr_005_6048                                ; $6041

jr_005_6043:
    ld a, $01                                     ; $6043
    call Photo_LoadEmptyPicture                   ; $6045

jr_005_6048:
    ld bc, $2020                                  ; $6048
    ld de, ObjScript_02_61F2_Mode05_StampWindow_State06 + $6 ; $604B
    call Object_CreateWithParam                   ; $604E
    ld bc, $3800                                  ; $6051
    ld de, ObjScript_02_6DD0_Mode05_StampWindow_State06 + $30 ; $6054
    call Object_CreateWithParam                   ; $6057
    ld de, ObjScript_02_6AD4_Mode05_StampWindow_State06 ; $605A
    call Object_Create                            ; $605D
    ld bc, $4850                                  ; $6060
    ld de, ObjScript_02_6C3E_Mode05_StampWindow_State06 + $42 ; $6063
    call Object_CreateWithParam                   ; $6066
    ld bc, $b850                                  ; $6069
    ld de, ObjScript_02_6CDB_Mode05_StampWindow_State06 + $38 ; $606C
    call Object_CreateWithParam                   ; $606F
    ld b, MODE_STAMP_WINDOW                       ; $6072
    ld c, STATE_05_STAMPS_STAMP_SCREEN_PHOTO      ; $6074
    call Fade_GoTo                                ; $6076
    ret                                           ; $6079


; C: handler of state $06 of mode $05 (word 6 of Mode05_StateTable)
Mode05_State06::
    ret                                           ; $607A


; C: handler of state $01 of mode $05 (word 1 of Mode05_StateTable)
Mode05_State01::
    ld a, [wStamp_ObjPlaceOnStart_D993]           ; $607B
    bit 1, a                                      ; $607E
    jr nz, jr_005_60ab                            ; $6080

    ld a, [wKeysNew]                              ; $6082
    bit PADB_B, a                                 ; $6085
    jr z, jr_005_60ab                             ; $6087

    ld a, [wStamp_ObjPlaceOnStart_D993]           ; $6089
    bit 2, a                                      ; $608C
    jr z, jr_005_609c                             ; $608E

    push af                                       ; $6090
    ld a, SFX1_35                                 ; $6091
    ld [wSndSfx1], a                              ; $6093
    pop af                                        ; $6096
    ld a, $02                                     ; $6097
    ldh [hState], a                               ; $6099
    ret                                           ; $609B


jr_005_609c:
    push af                                       ; $609C
    ld a, SFX3_09                                 ; $609D
    ld [wSndSfx3], a                              ; $609F
    pop af                                        ; $60A2
    ld b, MODE_VIEW_ALBUM                         ; $60A3
    ld c, $01                                     ; $60A5
    call Fade_GoToB                               ; $60A7
    ret                                           ; $60AA


jr_005_60ab:
    ld a, $06                                     ; $60AB
    ldh [hState], a                               ; $60AD
    ret                                           ; $60AF


; C: handler of state $02 of mode $05 (word 2 of Mode05_StateTable)
Mode05_State02::
    ld hl, wLcdcShadow                            ; $60B0
    set 2, [hl]                                   ; $60B3
    ld a, $03                                     ; $60B5
    ld b, BANK(KeyPrompt_LoadSounds)              ; $60B7
    ld hl, KeyPrompt_LoadSounds                   ; $60B9
    call Far_CallKeepA                            ; $60BC
    ld a, $03                                     ; $60BF
    ldh [hState], a                               ; $60C1
    ret                                           ; $60C3


; C: handler of state $03 of mode $05 (word 3 of Mode05_StateTable)
Mode05_State03::
    ld a, [wMode06_State0A_D8DF]                  ; $60C4
    bit 0, a                                      ; $60C7
    jr z, jr_005_610e                             ; $60C9

    push hl                                       ; $60CB
    ld hl, wMode06_State0A_D896                   ; $60CC
    set 0, [hl]                                   ; $60CF
    pop hl                                        ; $60D1
    ld hl, wStamp_ObjPlaceOnStart_D993            ; $60D2
    res 2, [hl]                                   ; $60D5
    ld de, $9000                                  ; $60D7
    ld hl, $c000                                  ; $60DA
    ld bc, $0200                                  ; $60DD
    call Vram_CopyBytesSafe                       ; $60E0
    ld de, $8000                                  ; $60E3
    ld hl, $c800                                  ; $60E6
    ld bc, $0180                                  ; $60E9
    call Vram_CopyBytesSafe                       ; $60EC
    ld b, BANK(Sram_ComputeImageChecksums)        ; $60EF
    ld hl, Sram_ComputeImageChecksums             ; $60F1
    call Far_Call                                 ; $60F4
    call Photo_MakeThumbnail                      ; $60F7
    ld b, BANK(Photo_StoreCurrent)                ; $60FA
    ld hl, Photo_StoreCurrent                     ; $60FC
    call Far_Call                                 ; $60FF
    push hl                                       ; $6102
    ld hl, wMode06_State0A_D896                   ; $6103
    res 0, [hl]                                   ; $6106
    pop hl                                        ; $6108
    ld a, $04                                     ; $6109
    ldh [hState], a                               ; $610B
    ret                                           ; $610D


jr_005_610e:
    ld a, [wMode06_State0A_D8DF]                  ; $610E
    bit 1, a                                      ; $6111
    jr z, jr_005_611a                             ; $6113

    ld a, $04                                     ; $6115
    ldh [hState], a                               ; $6117
    ret                                           ; $6119


jr_005_611a:
    ret                                           ; $611A


; C: handler of state $04 of mode $05 (word 4 of Mode05_StateTable)
Mode05_State04::
    ld hl, wLcdcShadow                            ; $611B
    set 2, [hl]                                   ; $611E
    ld a, $04                                     ; $6120
    ld b, BANK(KeyPrompt_LoadSounds)              ; $6122
    ld hl, KeyPrompt_LoadSounds                   ; $6124
    call Far_CallKeepA                            ; $6127
    ld a, $05                                     ; $612A
    ldh [hState], a                               ; $612C
    ret                                           ; $612E


; C: handler of state $05 of mode $05 (word 5 of Mode05_StateTable)
Mode05_State05::
    ld a, [wMode06_State0A_D8DF]                  ; $612F
    bit 0, a                                      ; $6132
    jr z, jr_005_613e                             ; $6134

    ld b, MODE_VIEW_ALBUM                         ; $6136
    ld c, $01                                     ; $6138
    call Fade_GoToB                               ; $613A
    ret                                           ; $613D


jr_005_613e:
    ld a, [wMode06_State0A_D8DF]                  ; $613E
    bit 1, a                                      ; $6141
    jr z, jr_005_6165                             ; $6143

    ld hl, wLcdcShadow                            ; $6145
    set 2, [hl]                                   ; $6148
    ld de, Gfx_25_6800_Mode05_StampWindow_State00 ; $614A
    ld a, BANK(Gfx_25_6800_Mode05_StampWindow_State00) ; $614D
    ld hl, $8800                                  ; $614F
    ld bc, $0200                                  ; $6152
    call Vram_CopyHBlankFar                       ; $6155
    ld b, BANK(Stamp_LoadSelected)                ; $6158
    ld hl, Stamp_LoadSelected                     ; $615A
    call Far_Call                                 ; $615D
    ld a, $06                                     ; $6160
    ldh [hState], a                               ; $6162
    ret                                           ; $6164


jr_005_6165:
    ret                                           ; $6165


; C: ModeTable entry $05: forced BGB screen (stamp window); reached in the core runs (from the album)
Mode05_StampWindow::
    ldh a, [hState]                               ; $6166
    ld hl, Mode05_StateTable                      ; $6168
    call JumpTable_ByA                            ; $616B
    jp Far_Return                                 ; $616E


; C: state table of mode $05, read by $0189 with hFF8E
Mode05_StateTable::
    dw Mode05_State00
    dw Mode05_State01
    dw Mode05_State02
    dw Mode05_State03
    dw Mode05_State04
    dw Mode05_State05
    dw Mode05_State06

    db $58, $48, $04, $45, $18, $45, $2c, $45, $40, $45, $18, $68, $ff, $01, $f8, $05
    db $04, $00, $30, $68, $00, $02, $f8, $06, $04, $00, $48, $68, $01, $03, $f8, $07
    db $04, $00, $60, $68, $02, $04, $f8, $08, $04, $00, $78, $68, $03, $0a, $f8, $09
    db $04, $00, $18, $80, $ff, $06, $00, $f9, $04, $00, $30, $80, $05, $07, $01, $f9
    db $04, $00, $48, $80, $06, $08, $02, $f9, $04, $00, $60, $80, $07, $09, $03, $f9
    db $04, $00, $78, $80, $08, $0d, $04, $f9, $04, $00, $94, $68, $04, $ff, $ff, $0b
    db $00, $00, $94, $78, $04, $ff, $0a, $0d, $00, $00, $94, $78, $09, $ff, $0a, $0d
    db $00, $00, $94, $88, $09, $ff, $0c, $ff, $00

    db $00

; C: 05:61FF then Far_Return
Cursor_Callback61FF::
    call AlbumText_CursorUpdate                   ; $61F9
    jp Far_Return                                 ; $61FC


; C: object callback like Stamp_CursorUpdate with $D991: shows it in step $D994 = 0, moves it with the D-pad in step
; 2; runs in the album text window (mode $03 state $0B)
AlbumText_CursorUpdate::
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5E] ; $61FF
    ld l, a                                       ; $6202
    ld a, [wGfx_00_1DAB_Mode12_SlideShow_State00_DC5F] ; $6203
    ld h, a                                       ; $6206
    ld de, hGfx_00_1DAB_Mode12_SlideShow_State00_FFFA ; $6207
    add hl, de                                    ; $620A
    ld a, [wAlbumText_CursorUpdate_D991]          ; $620B
    add [hl]                                      ; $620E
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $620F
    ld a, [wStamp_ObjSlideIn_D994]                ; $6211
    and a                                         ; $6214
    jr z, jr_005_621c                             ; $6215

    cp $02                                        ; $6217
    jr z, jr_005_622b                             ; $6219

    ret                                           ; $621B


jr_005_621c:
    call Obj_HideSprite                           ; $621C
    ld a, [wKeysNew]                              ; $621F
    bit PADB_A, a                                 ; $6222
    ret z                                         ; $6224

    ld hl, wAlbumText_CursorUpdate_D98D           ; $6225
    set 0, [hl]                                   ; $6228
    ret                                           ; $622A


jr_005_622b:
    ld a, [wKeysNewRepeat]                        ; $622B
    ld de, $0002                                  ; $622E
    bit 5, a                                      ; $6231
    jr nz, jr_005_625d                            ; $6233

    inc e                                         ; $6235
    bit 4, a                                      ; $6236
    jr nz, jr_005_625d                            ; $6238

    inc e                                         ; $623A
    bit 6, a                                      ; $623B
    jp nz, Jump_005_625d                          ; $623D

    inc e                                         ; $6240
    bit 7, a                                      ; $6241
    jp nz, Jump_005_625d                          ; $6243

    inc e                                         ; $6246
    bit 0, a                                      ; $6247
    jp nz, Jump_005_62ee                          ; $6249

    inc e                                         ; $624C
    bit 1, a                                      ; $624D
    jp nz, Jump_005_6354                          ; $624F

    bit 3, a                                      ; $6252
    jp nz, Jump_005_6367                          ; $6254

    bit 2, a                                      ; $6257
    jp nz, Jump_005_6396                          ; $6259

    ret                                           ; $625C


Jump_005_625d:
jr_005_625d:
    ld bc, Mode05_StateTable + $18                ; $625D
    ld a, [wAlbumText_CursorUpdate_D98F]          ; $6260
    ld l, a                                       ; $6263
    ld h, $00                                     ; $6264
    sla l                                         ; $6266
    rl h                                          ; $6268
    sla l                                         ; $626A
    rl h                                          ; $626C
    sla l                                         ; $626E
    rl h                                          ; $6270
    add hl, bc                                    ; $6272
    add hl, de                                    ; $6273
    ld a, [hl]                                    ; $6274
    cp $f8                                        ; $6275
    jp z, Jump_005_62be                           ; $6277

    cp $f9                                        ; $627A
    jp z, Jump_005_62d3                           ; $627C

    cp $ff                                        ; $627F
    jr z, jr_005_62bd                             ; $6281

    ld [wAlbumText_CursorUpdate_D98F], a          ; $6283
    ld l, a                                       ; $6286
    ld h, $00                                     ; $6287
    sla l                                         ; $6289
    rl h                                          ; $628B
    sla l                                         ; $628D
    rl h                                          ; $628F
    sla l                                         ; $6291
    rl h                                          ; $6293
    add hl, bc                                    ; $6295
    ld a, [hl+]                                   ; $6296
    ldh [hMode07_StateTable_FFD2], a              ; $6297
    ld [wAlbumText_ObjPosFromD990], a             ; $6299
    ld a, [hl+]                                   ; $629C
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $629D
    ld [wAlbumText_CursorUpdate_D991], a          ; $629F
    ld bc, $0004                                  ; $62A2
    add hl, bc                                    ; $62A5
    ld a, [hl]                                    ; $62A6
    sla a                                         ; $62A7
    ld c, a                                       ; $62A9
    ld b, $00                                     ; $62AA
    ld hl, Mode05_StateTable + $E                 ; $62AC
    add hl, bc                                    ; $62AF
    ld a, [hl+]                                   ; $62B0
    ld e, a                                       ; $62B1
    ld d, [hl]                                    ; $62B2
    call Call_000_2205                            ; $62B3
    push af                                       ; $62B6
    ld a, SFX1_20                                 ; $62B7
    ld [wSndSfx1], a                              ; $62B9
    pop af                                        ; $62BC

jr_005_62bd:
    ret                                           ; $62BD


Jump_005_62be:
    push af                                       ; $62BE
    ld a, SFX1_20                                 ; $62BF
    ld [wSndSfx1], a                              ; $62C1
    pop af                                        ; $62C4
    ld a, [wAlbumText_CursorUpdate_D992]          ; $62C5
    cp $00                                        ; $62C8
    jr z, jr_005_62d2                             ; $62CA

    dec a                                         ; $62CC
    ld [wAlbumText_CursorUpdate_D992], a          ; $62CD
    jr jr_005_62e5                                ; $62D0

jr_005_62d2:
    ret                                           ; $62D2


Jump_005_62d3:
    push af                                       ; $62D3
    ld a, SFX1_20                                 ; $62D4
    ld [wSndSfx1], a                              ; $62D6
    pop af                                        ; $62D9
    ld a, [wAlbumText_CursorUpdate_D992]          ; $62DA
    inc a                                         ; $62DD
    cp $30                                        ; $62DE
    jr z, jr_005_62d2                             ; $62E0

    ld [wAlbumText_CursorUpdate_D992], a          ; $62E2

jr_005_62e5:
    ld b, BANK(Text_LoadBigGlyphPage)             ; $62E5
    ld hl, Text_LoadBigGlyphPage                  ; $62E7
    call Far_Call                                 ; $62EA
    ret                                           ; $62ED


Jump_005_62ee:
    ld a, [wAlbumText_CursorUpdate_D98F]          ; $62EE
    cp $0a                                        ; $62F1
    jr c, jr_005_6331                             ; $62F3

    jr z, jr_005_6319                             ; $62F5

    cp $0b                                        ; $62F7
    jr z, jr_005_6304                             ; $62F9

    cp $0c                                        ; $62FB
    jr z, jr_005_6304                             ; $62FD

    cp $0d                                        ; $62FF
    jr z, jr_005_630d                             ; $6301

    ret                                           ; $6303


jr_005_6304:
    push af                                       ; $6304
    ld a, SFX1_02                                 ; $6305
    ld [wSndSfx1], a                              ; $6307
    pop af                                        ; $630A
    jr jr_005_6350                                ; $630B

jr_005_630d:
    ld a, [wKeysNew]                              ; $630D
    bit PADB_A, a                                 ; $6310
    ret z                                         ; $6312

    ld hl, wAlbumText_CursorUpdate_D98D           ; $6313
    res 0, [hl]                                   ; $6316
    ret                                           ; $6318


jr_005_6319:
    push af                                       ; $6319
    ld a, SFX4_04                                 ; $631A
    ld [wSndSfx4], a                              ; $631C
    pop af                                        ; $631F
    ld a, $00                                     ; $6320
    call Text_PutCharAtCursor                     ; $6322
    ld b, BANK(Text_DrawBigCharAtCursor)          ; $6325
    ld hl, Text_DrawBigCharAtCursor               ; $6327
    call Far_Call                                 ; $632A
    call Text_CursorRight                         ; $632D
    ret                                           ; $6330


jr_005_6331:
    push af                                       ; $6331
    ld a, SFX1_19                                 ; $6332
    ld [wSndSfx1], a                              ; $6334
    pop af                                        ; $6337
    ld c, $05                                     ; $6338
    ld a, [wAlbumText_CursorUpdate_D992]          ; $633A
    call Mul_8x8                                  ; $633D
    ld a, [wAlbumText_CursorUpdate_D98F]          ; $6340
    add l                                         ; $6343
    inc a                                         ; $6344
    call Text_PutCharAtCursor                     ; $6345
    ld b, BANK(Text_DrawBigCharAtCursor)          ; $6348
    ld hl, Text_DrawBigCharAtCursor               ; $634A
    call Far_Call                                 ; $634D

jr_005_6350:
    call Text_CursorRight                         ; $6350
    ret                                           ; $6353


Jump_005_6354:
    push af                                       ; $6354
    ld a, SFX1_1D                                 ; $6355
    ld [wSndSfx1], a                              ; $6357
    pop af                                        ; $635A
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $635B
    cp $00                                        ; $635E
    jr z, jr_005_6366                             ; $6360

    dec a                                         ; $6362
    ld [wAlbumText_CursorUpdate_D98C], a          ; $6363

jr_005_6366:
    ret                                           ; $6366


Jump_005_6367:
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $6367
    cp $1a                                        ; $636A
    jr z, jr_005_6388                             ; $636C

    push af                                       ; $636E
    ld a, SFX4_12                                 ; $636F
    ld [wSndSfx4], a                              ; $6371
    pop af                                        ; $6374
    ld de, wSlotTagComment + $19                  ; $6375
    ld hl, wSlotTagComment + $1a                  ; $6378
    ld c, $19                                     ; $637B

jr_005_637d:
    ld a, [de]                                    ; $637D
    ld [hl-], a                                   ; $637E
    dec de                                        ; $637F
    dec c                                         ; $6380
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $6381
    dec a                                         ; $6384
    cp c                                          ; $6385
    jr nz, jr_005_637d                            ; $6386

jr_005_6388:
    ld a, $00                                     ; $6388
    call Text_PutCharAtCursor                     ; $638A
    ld b, BANK(Text_CopyBigLineVram)              ; $638D
    ld hl, Text_CopyBigLineVram                   ; $638F
    call Far_Call                                 ; $6392
    ret                                           ; $6395


Jump_005_6396:
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $6396
    cp $1a                                        ; $6399
    jr z, jr_005_63b8                             ; $639B

    push af                                       ; $639D
    ld a, SFX4_0C                                 ; $639E
    ld [wSndSfx4], a                              ; $63A0
    pop af                                        ; $63A3
    ld c, a                                       ; $63A4
    inc c                                         ; $63A5
    ld b, $00                                     ; $63A6
    ld hl, wSlotTagComment                        ; $63A8
    add hl, bc                                    ; $63AB
    ld e, l                                       ; $63AC
    ld d, h                                       ; $63AD
    dec hl                                        ; $63AE

jr_005_63af:
    ld a, [de]                                    ; $63AF
    ld [hl+], a                                   ; $63B0
    inc de                                        ; $63B1
    inc c                                         ; $63B2
    ld a, $1b                                     ; $63B3
    cp c                                          ; $63B5
    jr nz, jr_005_63af                            ; $63B6

jr_005_63b8:
    ld c, $1a                                     ; $63B8
    ld a, $00                                     ; $63BA
    call Text_PutCharAt                           ; $63BC
    ld b, BANK(Text_CopyBigLineVram)              ; $63BF
    ld hl, Text_CopyBigLineVram                   ; $63C1
    call Far_Call                                 ; $63C4
    ret                                           ; $63C7


; C: A into the text buffer $DA67 at the cursor $D98C
Text_PutCharAtCursor::
    push af                                       ; $63C8
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $63C9
    ld c, a                                       ; $63CC
    ld b, $00                                     ; $63CD
    ld hl, wSlotTagComment                        ; $63CF
    add hl, bc                                    ; $63D2
    pop af                                        ; $63D3
    ld [hl], a                                    ; $63D4
    ret                                           ; $63D5


; C: A into the text buffer $DA67 at index C
Text_PutCharAt::
    push af                                       ; $63D6
    ld b, $00                                     ; $63D7
    ld hl, wSlotTagComment                        ; $63D9
    add hl, bc                                    ; $63DC
    pop af                                        ; $63DD
    ld [hl], a                                    ; $63DE
    ret                                           ; $63DF


; C: cursor $D98C + 1, at most $1A (27 characters)
Text_CursorRight::
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $63E0
    cp $1a                                        ; $63E3
    jr z, jr_005_63eb                             ; $63E5

    inc a                                         ; $63E7
    ld [wAlbumText_CursorUpdate_D98C], a          ; $63E8

jr_005_63eb:
    ret                                           ; $63EB


; C: DE = $4000 + 32 x A: an 8x16 glyph of bank $12
Text_SmallGlyphAddr::
    swap a                                        ; $63EC
    push af                                       ; $63EE
    and $f0                                       ; $63EF
    ld c, a                                       ; $63F1
    pop af                                        ; $63F2
    and $0f                                       ; $63F3
    ld b, a                                       ; $63F5
    sla c                                         ; $63F6
    rl b                                          ; $63F8
    ld hl, Font8x16Thin_Bank12                    ; $63FA
    add hl, bc                                    ; $63FD
    ld e, l                                       ; $63FE
    ld d, h                                       ; $63FF
    ret                                           ; $6400


; C: the 30 bytes at $DA67 as 8x16 glyphs of bank $12 into tiles $8100 (Vram_CopyHBlankFar)
Text_DrawSmallLine::
    ld hl, wSlotTagComment                        ; $6401
    ld de, $8100                                  ; $6404
    ld b, $1e                                     ; $6407

jr_005_6409:
    push bc                                       ; $6409
    ld a, [hl+]                                   ; $640A
    dec a                                         ; $640B
    push hl                                       ; $640C
    push de                                       ; $640D
    call Text_SmallGlyphAddr                      ; $640E
    pop hl                                        ; $6411
    ld bc, $0020                                  ; $6412
    ld a, $12                                     ; $6415
    call Vram_CopyHBlankFar                       ; $6417
    ld e, l                                       ; $641A
    ld d, h                                       ; $641B
    pop hl                                        ; $641C
    pop bc                                        ; $641D
    dec b                                         ; $641E
    jr nz, jr_005_6409                            ; $641F

    jp Far_Return                                 ; $6421


; C: DE = $4000 + 64 x A: a 16x16 glyph of bank $09 (Font16x16_Bank09)
Text_BigGlyphAddr::
    swap a                                        ; $6424
    push af                                       ; $6426
    and $f0                                       ; $6427
    ld c, a                                       ; $6429
    pop af                                        ; $642A
    and $0f                                       ; $642B
    ld b, a                                       ; $642D
    sla c                                         ; $642E
    rl b                                          ; $6430
    sla c                                         ; $6432
    rl b                                          ; $6434
    ld hl, Font16x16_Bank09                       ; $6436
    add hl, bc                                    ; $6439
    ld e, l                                       ; $643A
    ld d, h                                       ; $643B
    ret                                           ; $643C


; C: the 27 characters at $DA67 as 16x16 glyphs of bank $09 into $9000, or into $C000 in mode $06 (printing);
; Copy_FarDEtoHL
Text_CopyBigLine::
    ld hl, wSlotTagComment                        ; $643D
    ldh a, [hMode]                                ; $6440
    cp MODE_PRINTING                              ; $6442
    jr nz, jr_005_644b                            ; $6444

    ld de, $c000                                  ; $6446
    jr jr_005_644e                                ; $6449

jr_005_644b:
    ld de, $9000                                  ; $644B

jr_005_644e:
    ld b, $1b                                     ; $644E

jr_005_6450:
    push bc                                       ; $6450
    ld a, [hl+]                                   ; $6451
    dec a                                         ; $6452
    push hl                                       ; $6453
    push de                                       ; $6454
    call Text_BigGlyphAddr                        ; $6455
    pop hl                                        ; $6458
    ld bc, $0040                                  ; $6459
    ld a, $09                                     ; $645C
    call Copy_FarDEtoHL                           ; $645E
    ld e, l                                       ; $6461
    ld d, h                                       ; $6462
    pop hl                                        ; $6463
    pop bc                                        ; $6464
    dec b                                         ; $6465
    jr nz, jr_005_6450                            ; $6466

    jp Far_Return                                 ; $6468


; C: 05:643D through Vram_CopyHBlankFar
Text_CopyBigLineVram::
    ld hl, wSlotTagComment                        ; $646B
    ldh a, [hMode]                                ; $646E
    cp MODE_PRINTING                              ; $6470
    jr nz, jr_005_6479                            ; $6472

    ld de, $c000                                  ; $6474
    jr jr_005_647c                                ; $6477

jr_005_6479:
    ld de, $9000                                  ; $6479

jr_005_647c:
    ld b, $1b                                     ; $647C

jr_005_647e:
    push bc                                       ; $647E
    ld a, [hl+]                                   ; $647F
    dec a                                         ; $6480
    push hl                                       ; $6481
    push de                                       ; $6482
    call Text_BigGlyphAddr                        ; $6483
    pop hl                                        ; $6486
    ld bc, $0040                                  ; $6487
    ld a, $09                                     ; $648A
    call Vram_CopyHBlankFar                       ; $648C
    ld e, l                                       ; $648F
    ld d, h                                       ; $6490
    pop hl                                        ; $6491
    pop bc                                        ; $6492
    dec b                                         ; $6493
    jr nz, jr_005_647e                            ; $6494

    jp Far_Return                                 ; $6496


; C: the 16x16 glyph of the character at the cursor ($DA67 + [$D98C]) into $9000 + 64 x cursor
Text_DrawBigCharAtCursor::
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $6499
    ld c, a                                       ; $649C
    ld b, $00                                     ; $649D
    ld hl, wSlotTagComment                        ; $649F
    add hl, bc                                    ; $64A2
    ld a, [hl+]                                   ; $64A3
    dec a                                         ; $64A4
    call Text_BigGlyphAddr                        ; $64A5
    ld a, [wAlbumText_CursorUpdate_D98C]          ; $64A8
    ld l, a                                       ; $64AB
    ld h, $00                                     ; $64AC
    sla l                                         ; $64AE
    rl h                                          ; $64B0
    sla l                                         ; $64B2
    rl h                                          ; $64B4
    sla l                                         ; $64B6
    rl h                                          ; $64B8
    sla l                                         ; $64BA
    rl h                                          ; $64BC
    sla l                                         ; $64BE
    rl h                                          ; $64C0
    sla l                                         ; $64C2
    rl h                                          ; $64C4
    ld bc, $9000                                  ; $64C6
    add hl, bc                                    ; $64C9
    ld bc, $0040                                  ; $64CA
    ld a, $09                                     ; $64CD
    call Vram_CopyHBlankFar                       ; $64CF
    jp Far_Return                                 ; $64D2


; C: DE = 0C:7B40 + 16 x (low nibble of $DA60[A]); $B gives 0
Digits_LowNibbleTileAddr::
    push hl                                       ; $64D5
    ld c, a                                       ; $64D6
    ld b, $00                                     ; $64D7
    ld hl, wSlotTagOwnerCopy + $e                 ; $64D9
    add hl, bc                                    ; $64DC
    ld a, [hl]                                    ; $64DD
    and $0f                                       ; $64DE
    swap a                                        ; $64E0
    cp $b0                                        ; $64E2
    jr nz, jr_005_64e7                            ; $64E4

    xor a                                         ; $64E6

jr_005_64e7:
    ld c, a                                       ; $64E7
    ld b, $00                                     ; $64E8
    ld hl, $7b40                                  ; $64EA
    add hl, bc                                    ; $64ED
    ld e, l                                       ; $64EE
    ld d, h                                       ; $64EF
    pop hl                                        ; $64F0
    ret                                           ; $64F1


; C: DE = 0C:7B40 + (high nibble of $DA60[A]) x 16; $B gives 0
Digits_HighNibbleTileAddr::
    push hl                                       ; $64F2
    ld c, a                                       ; $64F3
    ld b, $00                                     ; $64F4
    ld hl, wSlotTagOwnerCopy + $e                 ; $64F6
    add hl, bc                                    ; $64F9
    ld a, [hl]                                    ; $64FA
    and $f0                                       ; $64FB
    cp $b0                                        ; $64FD
    jr nz, jr_005_6502                            ; $64FF

    xor a                                         ; $6501

jr_005_6502:
    ld c, a                                       ; $6502
    ld b, $00                                     ; $6503
    ld hl, $7b40                                  ; $6505
    add hl, bc                                    ; $6508
    ld e, l                                       ; $6509
    ld d, h                                       ; $650A
    pop hl                                        ; $650B
    ret                                           ; $650C


; C: DE = $4000 + 32 x ($DA56[A] - 1)
Text_SmallGlyphAddrDA56::
    ld c, a                                       ; $650D
    push hl                                       ; $650E
    ld hl, wSlotTagOwnerCopy + $4                 ; $650F
    add hl, bc                                    ; $6512
    ld a, [hl]                                    ; $6513
    dec a                                         ; $6514
    ld c, a                                       ; $6515
    ld b, $00                                     ; $6516
    sla c                                         ; $6518
    rl b                                          ; $651A
    sla c                                         ; $651C
    rl b                                          ; $651E
    sla c                                         ; $6520
    rl b                                          ; $6522
    sla c                                         ; $6524
    rl b                                          ; $6526
    sla c                                         ; $6528
    rl b                                          ; $652A
    ld hl, Font8x16Thin_Bank12                    ; $652C
    add hl, bc                                    ; $652F
    ld e, l                                       ; $6530
    ld d, h                                       ; $6531
    pop hl                                        ; $6532
    ret                                           ; $6533


; C: the 4 bytes $DA60 as 8 digit tiles of bank $0C into $8600 (into $C600 in mode $06, printing), then more at $84E0
; / $C4E0
Digits_CopyDA60::
    ldh a, [hMode]                                ; $6534
    cp MODE_PRINTING                              ; $6536
    jr nz, jr_005_653f                            ; $6538

    ld hl, $c600                                  ; $653A
    jr jr_005_6542                                ; $653D

jr_005_653f:
    ld hl, $8600                                  ; $653F

jr_005_6542:
    ld a, $00                                     ; $6542

jr_005_6544:
    push af                                       ; $6544
    call Digits_HighNibbleTileAddr                ; $6545
    ld bc, $0010                                  ; $6548
    ld a, $0c                                     ; $654B
    call Copy_FarDEtoHL                           ; $654D
    pop af                                        ; $6550
    push af                                       ; $6551
    call Digits_LowNibbleTileAddr                 ; $6552
    ld bc, $0010                                  ; $6555
    ld a, $0c                                     ; $6558
    call Copy_FarDEtoHL                           ; $655A
    pop af                                        ; $655D
    inc a                                         ; $655E
    cp $04                                        ; $655F
    jr nz, jr_005_6544                            ; $6561

    ldh a, [hMode]                                ; $6563
    cp MODE_PRINTING                              ; $6565
    jr nz, jr_005_656e                            ; $6567

    ld hl, $c4e0                                  ; $6569
    jr jr_005_6571                                ; $656C

jr_005_656e:
    ld hl, $84e0                                  ; $656E

jr_005_6571:
    ld a, $00                                     ; $6571

jr_005_6573:
    push af                                       ; $6573
    call Text_SmallGlyphAddrDA56                  ; $6574
    ld bc, $0020                                  ; $6577
    ld a, $11                                     ; $657A
    call Copy_FarDEtoHL                           ; $657C
    pop af                                        ; $657F
    inc a                                         ; $6580
    cp $09                                        ; $6581
    jr nz, jr_005_6573                            ; $6583

    ld a, [wSlotTagOwnerCopy + $d]                ; $6585
    and $03                                       ; $6588
    swap a                                        ; $658A
    ld c, a                                       ; $658C
    ld b, $00                                     ; $658D
    sla c                                         ; $658F
    rl b                                          ; $6591
    ld hl, Gfx_0C_7AE0_Mode03_ViewAlbum_State0B   ; $6593
    add hl, bc                                    ; $6596
    ld e, l                                       ; $6597
    ld d, h                                       ; $6598
    ldh a, [hMode]                                ; $6599
    cp MODE_PRINTING                              ; $659B
    jr nz, jr_005_65a4                            ; $659D

    ld hl, $c680                                  ; $659F
    jr jr_005_65a7                                ; $65A2

jr_005_65a4:
    ld hl, $8680                                  ; $65A4

jr_005_65a7:
    ld bc, $0020                                  ; $65A7
    ld a, $0c                                     ; $65AA
    call Copy_FarDEtoHL                           ; $65AC
    ld a, [wSlotTagOwnerCopy + $d]                ; $65AF
    srl a                                         ; $65B2
    srl a                                         ; $65B4
    and $07                                       ; $65B6
    swap a                                        ; $65B8
    ld c, a                                       ; $65BA
    ld b, $00                                     ; $65BB
    sla c                                         ; $65BD
    rl b                                          ; $65BF
    ld hl, Gfx_0C_7A40_Mode03_ViewAlbum_State0B   ; $65C1
    add hl, bc                                    ; $65C4
    ld e, l                                       ; $65C5
    ld d, h                                       ; $65C6
    ldh a, [hMode]                                ; $65C7
    cp MODE_PRINTING                              ; $65C9
    jr nz, jr_005_65d2                            ; $65CB

    ld hl, $c6a0                                  ; $65CD
    jr jr_005_65d5                                ; $65D0

jr_005_65d2:
    ld hl, $86a0                                  ; $65D2

jr_005_65d5:
    ld bc, $0020                                  ; $65D5
    ld a, $0c                                     ; $65D8
    call Copy_FarDEtoHL                           ; $65DA
    jp Far_Return                                 ; $65DD


; C: 10 glyphs (640 B) of bank $09 from $4000 + $140 x [$D992] into tiles $8A00
Text_LoadBigGlyphPage::
    ld bc, $0140                                  ; $65E0
    ld a, [wAlbumText_CursorUpdate_D992]          ; $65E3
    call Mul_8x16                                 ; $65E6
    ld de, Font16x16_Bank09                       ; $65E9
    add hl, de                                    ; $65EC
    ld e, l                                       ; $65ED
    ld d, h                                       ; $65EE
    ld hl, $8a00                                  ; $65EF
    ld bc, $0280                                  ; $65F2
    ld a, $09                                     ; $65F5
    call Vram_CopyHBlankFar                       ; $65F7
    jp Far_Return                                 ; $65FA


; C: handler of state $0A of mode $03 (word 10 of Mode03_StateTable)
Mode03_State0A::
    di                                            ; $65FD
    call Lcd_Off                                  ; $65FE
    call Oam_ClearShadow                          ; $6601
    ld b, BANK(Objects_ClearAll)                  ; $6604
    ld hl, Objects_ClearAll                       ; $6606
    call Far_Call                                 ; $6609
    ld b, BANK(ScriptSlots_Clear)                 ; $660C
    ld hl, ScriptSlots_Clear                      ; $660E
    call Far_Call                                 ; $6611
    call Copy_FarInline                           ; $6614

    db $00, $5c, $26, $00, $84, $00, $09

    call Copy_FarInline                           ; $661E

    db $50, $63, $23, $00, $9c, $00, $01

    ld a, [wMode03_State02_D933]                  ; $6628
    and $01                                       ; $662B
    jr nz, jr_005_6645                            ; $662D

    call Copy_FarInline                           ; $662F

    db $00, $60, $0d, $00, $80, $00, $04

    call Copy_FarInline                           ; $6639

    db $50, $5b, $23, $00, $98, $40, $02

    jr jr_005_6659                                ; $6643

jr_005_6645:
    call Copy_FarInline                           ; $6645

    db $00, $64, $0d, $00, $80, $60, $04

    call Copy_FarInline                           ; $664F

    db $50, $5f, $23, $00, $98, $40, $02

jr_005_6659:
    ld b, BANK(Digits_CopyDA60)                   ; $6659
    ld hl, Digits_CopyDA60                        ; $665B
    call Far_Call                                 ; $665E
    ld b, BANK(Text_CopyBigLine)                  ; $6661
    ld hl, Text_CopyBigLine                       ; $6663
    call Far_Call                                 ; $6666
    xor a                                         ; $6669
    ld [wAlbumText_CursorUpdate_D992], a          ; $666A
    ld a, $0d                                     ; $666D
    ld [wAlbumText_CursorUpdate_D98F], a          ; $666F
    ld a, $94                                     ; $6672
    ld [wAlbumText_ObjPosFromD990], a             ; $6674
    ld a, $88                                     ; $6677
    ld [wAlbumText_CursorUpdate_D991], a          ; $6679
    call Stat_SetTileToggleAt47                   ; $667C
    call Serial_SetFarCallback                    ; $667F

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6685

    db $e3, $e4, $e4, $d0, $00, $00, $00, $90, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $6693

    dw $0214

    push af                                       ; $6698
    ld a, MUSIC_VIEW_ALBUM_03_0A                  ; $6699
    ld [wSndMusicReq], a                          ; $669B
    pop af                                        ; $669E
    ei                                            ; $669F
    ld de, ObjScript_02_7854_Mode03_ViewAlbum_State0B ; $66A0
    call Object_Create                            ; $66A3
    ld bc, $3800                                  ; $66A6
    ld de, ObjScript_02_7901_Mode03_ViewAlbum_State0B + $34 ; $66A9
    call Object_CreateWithParam                   ; $66AC
    ld de, ObjScript_02_7962_Mode0A_NameCard_State01 ; $66AF
    call Object_Create                            ; $66B2
    ld b, MODE_VIEW_ALBUM                         ; $66B5
    ld c, $0b                                     ; $66B7
    call Fade_GoTo                                ; $66B9
    ret                                           ; $66BC


; C: handler of state $0B of mode $03 (word 11 of Mode03_StateTable)
Mode03_State0B::
    ld a, [wStamp_ObjSlideIn_D994]                ; $66BD
    cp $00                                        ; $66C0
    jr nz, jr_005_66f6                            ; $66C2

    ld a, [wKeysNew]                              ; $66C4
    bit PADB_B, a                                 ; $66C7
    jr z, jr_005_66f6                             ; $66C9

    push af                                       ; $66CB
    ld a, SFX3_09                                 ; $66CC
    ld [wSndSfx3], a                              ; $66CE
    pop af                                        ; $66D1
    push hl                                       ; $66D2
    ld hl, wMode06_State0A_D896                   ; $66D3
    set 0, [hl]                                   ; $66D6
    pop hl                                        ; $66D8
    ld a, [wMode06_State00_D931]                  ; $66D9
    ld [wSlotTagBorder], a                        ; $66DC
    ld b, BANK(Photo_StoreCurrent)                ; $66DF
    ld hl, Photo_StoreCurrent                     ; $66E1
    call Far_Call                                 ; $66E4
    push hl                                       ; $66E7
    ld hl, wMode06_State0A_D896                   ; $66E8
    res 0, [hl]                                   ; $66EB
    pop hl                                        ; $66ED
    ld b, MODE_VIEW_ALBUM                         ; $66EE
    ld c, $06                                     ; $66F0
    call Fade_GoToB                               ; $66F2
    ret                                           ; $66F5


jr_005_66f6:
    ret                                           ; $66F6


    db $cd, $4e, $0a, $fa, $86, $d3, $5f, $fa, $87, $d3, $57, $6b, $62, $01, $07, $00
    db $09, $5d, $54, $21, $42, $98, $cd, $be, $0a, $6b, $62, $01, $07, $00, $09, $5d
    db $54, $21, $62, $98, $cd, $be, $0a, $6b, $62, $01, $07, $00, $09, $5d, $54, $21
    db $42, $9a, $cd, $be, $0a, $6b, $62, $01, $07, $00, $09, $5d, $54, $21, $62, $9a
    db $cd, $be, $0a, $6b, $62, $01, $02, $00, $09, $5d, $54, $21, $8d, $98, $cd, $82
    db $0a, $c3, $73, $01

; C: four 13-tile rows from the records at [$D386] into the BG map at $9842, $9862, $9A42, $9A62 (00:0ABA), and 2
; tiles at $9887; mode $02 state $08; runs on its screen (02:08) in the core replays (port/entry_modes_kitty.csv);
; code read
TakePhotos_DrawRowsLeftBg::
    call FrameRec_SetRecords                      ; $674B
    ld a, [wPrintSrcTable + $4]                   ; $674E
    ld e, a                                       ; $6751
    ld a, [wPrintSrcTable + $5]                   ; $6752
    ld d, a                                       ; $6755
    ld l, e                                       ; $6756
    ld h, d                                       ; $6757
    ld bc, $000d                                  ; $6758
    add hl, bc                                    ; $675B
    ld e, l                                       ; $675C
    ld d, h                                       ; $675D
    ld hl, $9842                                  ; $675E
    call MapRows_Copy7                            ; $6761
    ld l, e                                       ; $6764
    ld h, d                                       ; $6765
    ld bc, $000d                                  ; $6766
    add hl, bc                                    ; $6769
    ld e, l                                       ; $676A
    ld d, h                                       ; $676B
    ld hl, $9862                                  ; $676C
    call MapRows_Copy7                            ; $676F
    ld l, e                                       ; $6772
    ld h, d                                       ; $6773
    ld bc, $000d                                  ; $6774
    add hl, bc                                    ; $6777
    ld e, l                                       ; $6778
    ld d, h                                       ; $6779
    ld hl, $9a42                                  ; $677A
    call MapRows_Copy7                            ; $677D
    ld l, e                                       ; $6780
    ld h, d                                       ; $6781
    ld bc, $000d                                  ; $6782
    add hl, bc                                    ; $6785
    ld e, l                                       ; $6786
    ld d, h                                       ; $6787
    ld hl, $9a62                                  ; $6788
    call MapRows_Copy7                            ; $678B
    ld l, e                                       ; $678E
    ld h, d                                       ; $678F
    ld bc, $0002                                  ; $6790
    add hl, bc                                    ; $6793
    ld e, l                                       ; $6794
    ld d, h                                       ; $6795
    ld hl, $9887                                  ; $6796
    call MapRows_Copy14                           ; $6799
    jp Far_Return                                 ; $679C


; C: the same at $984F, $986F, $9A4F, $9A6F and $988F; runs on its screen (02:08) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_DrawRowsRightBg::
    call FrameRec_SetRecords                      ; $679F
    ld a, [wPrintSrcTable + $4]                   ; $67A2
    ld e, a                                       ; $67A5
    ld a, [wPrintSrcTable + $5]                   ; $67A6
    ld d, a                                       ; $67A9
    ld hl, $984f                                  ; $67AA
    call MapRows_Copy7                            ; $67AD
    ld l, e                                       ; $67B0
    ld h, d                                       ; $67B1
    ld bc, $000d                                  ; $67B2
    add hl, bc                                    ; $67B5
    ld e, l                                       ; $67B6
    ld d, h                                       ; $67B7
    ld hl, $986f                                  ; $67B8
    call MapRows_Copy7                            ; $67BB
    ld l, e                                       ; $67BE
    ld h, d                                       ; $67BF
    ld bc, $000d                                  ; $67C0
    add hl, bc                                    ; $67C3
    ld e, l                                       ; $67C4
    ld d, h                                       ; $67C5
    ld hl, $9a4f                                  ; $67C6
    call MapRows_Copy7                            ; $67C9
    ld l, e                                       ; $67CC
    ld h, d                                       ; $67CD
    ld bc, $000d                                  ; $67CE
    add hl, bc                                    ; $67D1
    ld e, l                                       ; $67D2
    ld d, h                                       ; $67D3
    ld hl, $9a6f                                  ; $67D4
    call MapRows_Copy7                            ; $67D7
    ld l, e                                       ; $67DA
    ld h, d                                       ; $67DB
    ld bc, $000d                                  ; $67DC
    add hl, bc                                    ; $67DF
    ld e, l                                       ; $67E0
    ld d, h                                       ; $67E1
    ld hl, $988f                                  ; $67E2
    call MapRows_Copy14                           ; $67E5
    jp Far_Return                                 ; $67E8


    db $cd, $4e, $0a, $fa, $86, $d3, $5f, $fa, $87, $d3, $57, $21, $49, $98, $cd, $be
    db $0a, $6b, $62, $01, $07, $00, $09, $5d, $54, $21, $69, $98, $cd, $be, $0a, $6b
    db $62, $01, $07, $00, $09, $5d, $54, $21, $49, $9a, $cd, $be, $0a, $6b, $62, $01
    db $07, $00, $09, $5d, $54, $21, $69, $9a, $cd, $be, $0a, $6b, $62, $01, $07, $00
    db $09, $5d, $54, $21, $89, $98, $cd, $82, $0a, $c3, $73, $01

; C: four 7-tile rows into the window map at $9C42, $9C62, $9E42, $9E62 (00:0ABE), and 2 tiles at $9C8D; runs on its
; screen (02:08) in the core replays (port/entry_modes_kitty.csv); code read
TakePhotos_DrawRowsLeftWin::
    call FrameRec_SetRecords                      ; $6837
    ld a, [wPrintSrcTable + $4]                   ; $683A
    ld e, a                                       ; $683D
    ld a, [wPrintSrcTable + $5]                   ; $683E
    ld d, a                                       ; $6841
    ld l, e                                       ; $6842
    ld h, d                                       ; $6843
    ld bc, $0007                                  ; $6844
    add hl, bc                                    ; $6847
    ld e, l                                       ; $6848
    ld d, h                                       ; $6849
    ld hl, $9c42                                  ; $684A
    call MapRows_Copy13                           ; $684D
    ld l, e                                       ; $6850
    ld h, d                                       ; $6851
    ld bc, $0007                                  ; $6852
    add hl, bc                                    ; $6855
    ld e, l                                       ; $6856
    ld d, h                                       ; $6857
    ld hl, $9c62                                  ; $6858
    call MapRows_Copy13                           ; $685B
    ld l, e                                       ; $685E
    ld h, d                                       ; $685F
    ld bc, $0007                                  ; $6860
    add hl, bc                                    ; $6863
    ld e, l                                       ; $6864
    ld d, h                                       ; $6865
    ld hl, $9e42                                  ; $6866
    call MapRows_Copy13                           ; $6869
    ld l, e                                       ; $686C
    ld h, d                                       ; $686D
    ld bc, $0007                                  ; $686E
    add hl, bc                                    ; $6871
    ld e, l                                       ; $6872
    ld d, h                                       ; $6873
    ld hl, $9e62                                  ; $6874
    call MapRows_Copy13                           ; $6877
    ld l, e                                       ; $687A
    ld h, d                                       ; $687B
    ld bc, $0002                                  ; $687C
    add hl, bc                                    ; $687F
    ld e, l                                       ; $6880
    ld d, h                                       ; $6881
    ld hl, $9c8d                                  ; $6882
    call MapRows_Copy14                           ; $6885
    jp Far_Return                                 ; $6888


; C: the same from $9C49; runs on its screen (02:08) in the core replays (port/entry_modes_kitty.csv); code read
TakePhotos_DrawRowsRightWin::
    call FrameRec_SetRecords                      ; $688B
    ld a, [wPrintSrcTable + $4]                   ; $688E
    ld e, a                                       ; $6891
    ld a, [wPrintSrcTable + $5]                   ; $6892
    ld d, a                                       ; $6895
    ld hl, $9c49                                  ; $6896
    call MapRows_Copy13                           ; $6899
    ld l, e                                       ; $689C
    ld h, d                                       ; $689D
    ld bc, $0007                                  ; $689E
    add hl, bc                                    ; $68A1
    ld e, l                                       ; $68A2
    ld d, h                                       ; $68A3
    ld hl, $9c69                                  ; $68A4
    call MapRows_Copy13                           ; $68A7
    ld l, e                                       ; $68AA
    ld h, d                                       ; $68AB
    ld bc, $0007                                  ; $68AC
    add hl, bc                                    ; $68AF
    ld e, l                                       ; $68B0
    ld d, h                                       ; $68B1
    ld hl, $9e49                                  ; $68B2
    call MapRows_Copy13                           ; $68B5
    ld l, e                                       ; $68B8
    ld h, d                                       ; $68B9
    ld bc, $0007                                  ; $68BA
    add hl, bc                                    ; $68BD
    ld e, l                                       ; $68BE
    ld d, h                                       ; $68BF
    ld hl, $9e69                                  ; $68C0
    call MapRows_Copy13                           ; $68C3
    ld l, e                                       ; $68C6
    ld h, d                                       ; $68C7
    ld bc, $0007                                  ; $68C8
    add hl, bc                                    ; $68CB
    ld e, l                                       ; $68CC
    ld d, h                                       ; $68CD
    ld hl, $9c89                                  ; $68CE
    call MapRows_Copy14                           ; $68D1
    jp Far_Return                                 ; $68D4


; C: read in the runs by Map_Write5PlusA0Safe, FrameRec_LoadMap, FrameRec_LoadTiles; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz)
Src_05_68D7_Mode02_TakePhotos_State01::
    INCBIN "data/bank_05/Src_05_68D7_Mode02_TakePhotos_State01.bin" ; $68D7, 422 bytes
; I: leftover: 48 bytes (05:6A7D-6AAC) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_05_6A7D::
    db $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8
    db $7c, $33, $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8, $7c, $33, $f0, $7f
    db $1d, $c8, $7d, $33, $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8, $7c, $33

; C: read in the runs by FrameRec_LoadTiles, FrameRec_LoadMap; first read on the screen Mode02_TakePhotos_State09
; (trace/read_screens_kitty.npz)
FrameRec_LoadTiles_Tbl6AAD::
    db $20, $7e, $10, $60, $7e, $35

    db $40, $6c, $33, $d8, $7d, $35, $10, $7e, $2f, $e8, $7e, $35, $00, $70, $27, $30
    db $7b, $35

; C: read in the runs by FrameRec_LoadMap, FrameRec_LoadTiles, FrameRec_LoadTilesScreenOff; first read on the screen
; Mode02_TakePhotos_State01 (trace/read_screens_kitty.npz)
FrameRec_LoadMap_Tbl6AC5::
    db $30, $6f, $2f, $a8, $7a, $35, $10, $7b, $27, $b8, $7b, $35, $b0, $76, $2f, $c8
    db $7c, $35, $f0, $5f, $2f, $40, $7c, $35, $10, $62, $31, $30, $7c, $33, $e0, $7f
    db $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $d7, $68, $05
    db $e0, $7f, $1d, $b8, $7c, $33, $e0, $7f, $1d, $b8, $7c, $33, $f0, $7f, $1d, $5f
    db $69, $05, $20, $74, $2b, $40, $7d, $33, $30, $79, $2b, $20, $7b, $33, $10, $6f
    db $2b, $00, $79, $33, $30, $79, $2a, $78, $78, $33, $00, $6a, $2b, $88, $79, $33
    db $10, $6f, $2d, $98, $7a, $33, $00, $6a, $2d, $10, $7a, $33, $10, $53, $2c, $50
    db $7e, $33, $00, $4e, $2c, $a8, $7a, $34, $10, $6f, $28, $20, $7a, $34, $00, $6a
    db $28, $30, $7b, $34, $20, $74, $28, $40, $7c, $34, $00, $6a, $2a, $b8, $7b, $34
    db $30, $79, $29, $98, $79, $34, $20, $74, $2a, $60, $7f, $33, $10, $6f, $2a, $d8
    db $7e, $33, $00, $6a, $29, $00, $78, $34, $30, $79, $28, $10, $79, $34, $20, $74
    db $29, $88, $78, $34, $10, $6f, $29, $a8, $7b, $33

    db $10, $6f, $2a, $d8, $7e, $33, $10, $6f, $2a, $d8, $7e, $33, $10, $6f, $2a, $d8
    db $7e, $33, $10, $6f, $2a, $d8, $7e, $33

; C: handler of state $06 of mode $03 (word 6 of Mode03_StateTable)
Mode03_State06::
    di                                            ; $6B97
    call Lcd_Off                                  ; $6B98
    call Oam_ClearShadow                          ; $6B9B
    ld b, BANK(Objects_ClearAll)                  ; $6B9E
    ld hl, Objects_ClearAll                       ; $6BA0
    call Far_Call                                 ; $6BA3
    ld b, BANK(ScriptSlots_Clear)                 ; $6BA6
    ld hl, ScriptSlots_Clear                      ; $6BA8
    call Far_Call                                 ; $6BAB
    call Copy_FarInline                           ; $6BAE

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $6BB8

    db $f0, $75, $31, $00, $98, $00, $04

    xor a                                         ; $6BC2
    ld [wAlbumText_CursorUpdate_D98C], a          ; $6BC3
    call Stat_SetTileToggleAt4F                   ; $6BC6
    call Serial_SetFarCallback                    ; $6BC9

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6BCF

    db $87, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $6BDD

    dw $0a28

    push af                                       ; $6BE2
    ld a, MUSIC_VIEW_ALBUM_03_06                  ; $6BE3
    ld [wSndMusicReq], a                          ; $6BE5
    pop af                                        ; $6BE8
    ei                                            ; $6BE9
    ld a, [wMode03_State02_D933]                  ; $6BEA
    ld b, BANK(Photo_FindSlotA)                   ; $6BED
    ld hl, Photo_FindSlotA                        ; $6BEF
    call Far_CallKeepA                            ; $6BF2
    jr c, jr_005_6c0a                             ; $6BF5

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $6BF7
    ld hl, Photo_LoadToBufferAndVram              ; $6BF9
    call Far_CallKeepA                            ; $6BFC
    ld a, [wSlotTagBorder]                        ; $6BFF
    ld [wMode06_State00_D931], a                  ; $6C02
    call FrameRec_LoadDefault                     ; $6C05
    jr jr_005_6c14                                ; $6C08

jr_005_6c0a:
    ld a, $01                                     ; $6C0A
    call Photo_LoadEmptyPicture                   ; $6C0C
    ld a, $00                                     ; $6C0F
    call FrameRec_LoadDefault                     ; $6C11

jr_005_6c14:
    ld bc, $2020                                  ; $6C14
    ld de, ObjScript_02_61F2_Mode05_StampWindow_State06 + $6 ; $6C17
    call Object_CreateWithParam                   ; $6C1A
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $20 ; $6C1D
    call Object_Create                            ; $6C20
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $26 ; $6C23
    call Object_Create                            ; $6C26
    ld b, MODE_VIEW_ALBUM                         ; $6C29
    ld c, $07                                     ; $6C2B
    call Fade_GoTo                                ; $6C2D
    ret                                           ; $6C30


; C: handler of state $07 of mode $03 (word 7 of Mode03_StateTable)
Mode03_State07::
    ld a, [wKeysNew]                              ; $6C31
    bit PADB_B, a                                 ; $6C34
    jr z, jr_005_6c63                             ; $6C36

    push af                                       ; $6C38
    ld a, SFX3_09                                 ; $6C39
    ld [wSndSfx3], a                              ; $6C3B
    pop af                                        ; $6C3E
    push hl                                       ; $6C3F
    ld hl, wMode06_State0A_D896                   ; $6C40
    set 0, [hl]                                   ; $6C43
    pop hl                                        ; $6C45
    ld a, [wMode06_State00_D931]                  ; $6C46
    ld [wSlotTagBorder], a                        ; $6C49
    ld b, BANK(Photo_StoreCurrent)                ; $6C4C
    ld hl, Photo_StoreCurrent                     ; $6C4E
    call Far_Call                                 ; $6C51
    push hl                                       ; $6C54
    ld hl, wMode06_State0A_D896                   ; $6C55
    res 0, [hl]                                   ; $6C58
    pop hl                                        ; $6C5A
    ld b, MODE_VIEW_ALBUM                         ; $6C5B
    ld c, $01                                     ; $6C5D
    call Fade_GoToB                               ; $6C5F
    ret                                           ; $6C62


jr_005_6c63:
    ld a, [wKeysNewRepeat]                        ; $6C63
    bit PADB_LEFT, a                              ; $6C66
    jr z, jr_005_6c75                             ; $6C68

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $CA ; $6C6A
    call Object_Create                            ; $6C6D
    ld a, $08                                     ; $6C70
    ldh [hState], a                               ; $6C72
    ret                                           ; $6C74


jr_005_6c75:
    ld a, [wKeysNewRepeat]                        ; $6C75
    bit PADB_RIGHT, a                             ; $6C78
    jr z, jr_005_6c87                             ; $6C7A

    ld de, ObjScript_02_5FF8_Mode02_TakePhotos_State08 + $62 ; $6C7C
    call Object_Create                            ; $6C7F
    ld a, $08                                     ; $6C82
    ldh [hState], a                               ; $6C84
    ret                                           ; $6C86


jr_005_6c87:
    ld a, [wKeysNew]                              ; $6C87
    bit PADB_A, a                                 ; $6C8A
    jr z, jr_005_6ca4                             ; $6C8C

    push af                                       ; $6C8E
    ld a, SFX1_05                                 ; $6C8F
    ld [wSndSfx1], a                              ; $6C91
    pop af                                        ; $6C94
    ld a, $08                                     ; $6C95
    ld b, BANK(KeyPrompt_LoadSounds)              ; $6C97
    ld hl, KeyPrompt_LoadSounds                   ; $6C99
    call Far_CallKeepA                            ; $6C9C
    ld a, $09                                     ; $6C9F
    ldh [hState], a                               ; $6CA1
    ret                                           ; $6CA3


jr_005_6ca4:
    ret                                           ; $6CA4


; C: handler of state $08 of mode $03 (word 8 of Mode03_StateTable)
Mode03_State08::
    ld hl, wMode06_State0E_D8D3                   ; $6CA5
    bit 7, [hl]                                   ; $6CA8
    jr z, jr_005_6cb0                             ; $6CAA

    ld a, $07                                     ; $6CAC
    ldh [hState], a                               ; $6CAE

jr_005_6cb0:
    ret                                           ; $6CB0


; C: handler of state $09 of mode $03 (word 9 of Mode03_StateTable)
Mode03_State09::
    ld a, [wMode06_State0A_D8DF]                  ; $6CB1
    bit 1, a                                      ; $6CB4
    jr z, jr_005_6cbd                             ; $6CB6

    ld a, $07                                     ; $6CB8
    ldh [hState], a                               ; $6CBA
    ret                                           ; $6CBC


jr_005_6cbd:
    ld a, [wMode06_State0A_D8DF]                  ; $6CBD
    bit 0, a                                      ; $6CC0
    jr z, jr_005_6ccc                             ; $6CC2

    ld b, MODE_VIEW_ALBUM                         ; $6CC4
    ld c, $0a                                     ; $6CC6
    call Fade_GoToB                               ; $6CC8
    ret                                           ; $6CCB


jr_005_6ccc:
    ret                                           ; $6CCC


; C: Sram_ComputeImageChecksums, 00:2A8F, a free slot by 01:4D81 with A = $FF, then 01:4D9F, 01:4DE4, 01:4C2B; first
; run in mode $02 state $06 (photo taken); runs on its screen (02:06) in the core replays
; (port/entry_modes_kitty.csv); code read
TakePhotos_StorePhoto::
    ld b, BANK(Sram_ComputeImageChecksums)        ; $6CCD
    ld hl, Sram_ComputeImageChecksums             ; $6CCF
    call Far_Call                                 ; $6CD2
    call Photo_MakeThumbnail                      ; $6CD5
    ld a, $ff                                     ; $6CD8
    ld b, BANK(Photo_FindSlotA)                   ; $6CDA
    ld hl, Photo_FindSlotA                        ; $6CDC
    call Far_CallKeepA                            ; $6CDF
    push af                                       ; $6CE2
    ld b, BANK(Photo_AddToVector)                 ; $6CE3
    ld hl, Photo_AddToVector                      ; $6CE5
    call Far_CallKeepA                            ; $6CE8
    ld b, BANK(Sram_StoreVector)                  ; $6CEB
    ld hl, Sram_StoreVector                       ; $6CED
    call Far_Call                                 ; $6CF0
    pop af                                        ; $6CF3
    ld b, BANK(Photo_Store)                       ; $6CF4
    ld hl, Photo_Store                            ; $6CF6
    call Far_CallKeepA                            ; $6CF9
    jp Far_Return                                 ; $6CFC


; C: Photo_FindSlotA with A = [$D933]; when found, Photo_Store (01:4C2B); runs in the album, the stamp window and
; printing
Photo_StoreCurrent::
    ld a, [wMode03_State02_D933]                  ; $6CFF
    ld b, BANK(Photo_FindSlotA)                   ; $6D02
    ld hl, Photo_FindSlotA                        ; $6D04
    call Far_CallKeepA                            ; $6D07
    jr c, jr_005_6d15                             ; $6D0A

    ld b, BANK(Photo_Store)                       ; $6D0C
    ld hl, Photo_Store                            ; $6D0E
    call Far_CallKeepA                            ; $6D11
    and a                                         ; $6D14

jr_005_6d15:
    jp Far_ReturnSramBank                         ; $6D15


; C: $D933 - 1 when equal to $D932, then 01:4D81, 01:4DCC, 01:4DE4, 01:49BD; mode $03 state $0D; runs on its screen
; (03:0D) in the core replays (port/entry_modes_kitty.csv); code read
Album_SlotOp6D18::
    ld a, [wMode03_State02_D933]                  ; $6D18
    push af                                       ; $6D1B
    ld hl, wAlbum_SlotOp6D18_D932                 ; $6D1C
    cp [hl]                                       ; $6D1F
    jr nz, jr_005_6d26                            ; $6D20

    ld hl, wMode03_State02_D933                   ; $6D22
    dec [hl]                                      ; $6D25

jr_005_6d26:
    ld b, BANK(Photo_FindSlotA)                   ; $6D26
    ld hl, Photo_FindSlotA                        ; $6D28
    call Far_CallKeepA                            ; $6D2B
    jr c, jr_005_6d52                             ; $6D2E

    push af                                       ; $6D30
    ld b, BANK(Photo_RemoveFromVector)            ; $6D31
    ld hl, Photo_RemoveFromVector                 ; $6D33
    call Far_CallKeepA                            ; $6D36
    ld b, BANK(Sram_StoreVector)                  ; $6D39
    ld hl, Sram_StoreVector                       ; $6D3B
    call Far_Call                                 ; $6D3E
    pop af                                        ; $6D41
    ld b, BANK(Sram_WritePhotoInfo)               ; $6D42
    ld hl, Sram_WritePhotoInfo                    ; $6D44
    call Far_CallKeepA                            ; $6D47
    ld b, BANK(Counters_AddErased)                ; $6D4A
    ld hl, Counters_AddErased                     ; $6D4C
    call Far_Call                                 ; $6D4F

jr_005_6d52:
    pop af                                        ; $6D52
    ld c, a                                       ; $6D53
    ld a, [wAlbum_SlotOp6D18_D932]                ; $6D54
    cp c                                          ; $6D57
    jr nc, jr_005_6d5b                            ; $6D58

    ld c, a                                       ; $6D5A

jr_005_6d5b:
    ld a, c                                       ; $6D5B
    ld [wMode03_State02_D933], a                  ; $6D5C
    ret                                           ; $6D5F


; C: 00:2A8F, a free slot by 01:4D81 with A = $FF, 01:4D9F, 01:4DE4, 01:4C2B (05:6CCD without the checksums); mode $03
; state $11; runs on its screen (03:11) in the core replays (port/entry_modes_kitty.csv); code read
Album_StorePhoto6D60::
    call Photo_MakeThumbnail                      ; $6D60
    ld a, $ff                                     ; $6D63
    ld b, BANK(Photo_FindSlotA)                   ; $6D65
    ld hl, Photo_FindSlotA                        ; $6D67
    call Far_CallKeepA                            ; $6D6A
    jr c, jr_005_6d89                             ; $6D6D

    push af                                       ; $6D6F
    ld b, BANK(Photo_AddToVector)                 ; $6D70
    ld hl, Photo_AddToVector                      ; $6D72
    call Far_CallKeepA                            ; $6D75
    ld b, BANK(Sram_StoreVector)                  ; $6D78
    ld hl, Sram_StoreVector                       ; $6D7A
    call Far_Call                                 ; $6D7D
    pop af                                        ; $6D80
    ld b, BANK(Photo_Store)                       ; $6D81
    ld hl, Photo_Store                            ; $6D83
    call Far_CallKeepA                            ; $6D86

jr_005_6d89:
    ret                                           ; $6D89


; C: DE = $6000 + 32 x A: an 8x16 glyph of bank $12
NameCard_NameGlyphAddr::
    ld c, $20                                     ; $6D8A
    call Mul_8x8                                  ; $6D8C
    ld de, $6000                                  ; $6D8F
    add hl, de                                    ; $6D92
    ld e, l                                       ; $6D93
    ld d, h                                       ; $6D94
    ret                                           ; $6D95


; C: the 9 characters at $DADF as 8x16 glyphs of bank $12 into tiles $8A00; mode $03 state $00
NameCard_DrawName::
    ld hl, wIdCard + $4                           ; $6D96
    ld de, $8a00                                  ; $6D99
    ld b, $09                                     ; $6D9C

jr_005_6d9e:
    push bc                                       ; $6D9E
    ld a, [hl+]                                   ; $6D9F
    dec a                                         ; $6DA0
    push hl                                       ; $6DA1
    push de                                       ; $6DA2
    call NameCard_NameGlyphAddr                   ; $6DA3
    pop hl                                        ; $6DA6
    ld bc, $0020                                  ; $6DA7
    ld a, $12                                     ; $6DAA
    call Vram_CopyHBlankFar                       ; $6DAC
    ld e, l                                       ; $6DAF
    ld d, h                                       ; $6DB0
    pop hl                                        ; $6DB1
    pop bc                                        ; $6DB2
    dec b                                         ; $6DB3
    jr nz, jr_005_6d9e                            ; $6DB4

    jp Far_Return                                 ; $6DB6


; C: DE = $6E50 + 32 x A (bank $33)
NameCard_DigitGlyphAddr::
    ld c, $20                                     ; $6DB9
    call Mul_8x8                                  ; $6DBB
    ld de, $6e50                                  ; $6DBE
    add hl, de                                    ; $6DC1
    ld e, l                                       ; $6DC2
    ld d, h                                       ; $6DC3
    ret                                           ; $6DC4


; C: the 4 BCD bytes at $DAE9 as digit glyphs of bank $33 into $8B60 (0 drawn as glyph $0A); the birthday of the ID
; card (I); runs on its screen (03:00) in the core replays (port/entry_modes_kitty.csv); code read
NameCard_DrawBirthday::
    ld hl, wIdCard + $e                           ; $6DC5
    ld de, $8b60                                  ; $6DC8
    ld b, $04                                     ; $6DCB

jr_005_6dcd:
    push bc                                       ; $6DCD
    ld a, [hl]                                    ; $6DCE
    swap a                                        ; $6DCF
    and $0f                                       ; $6DD1
    dec a                                         ; $6DD3
    cp $ff                                        ; $6DD4
    jr nz, jr_005_6dda                            ; $6DD6

    ld a, $0a                                     ; $6DD8

jr_005_6dda:
    push hl                                       ; $6DDA
    push de                                       ; $6DDB
    call NameCard_DigitGlyphAddr                  ; $6DDC
    pop hl                                        ; $6DDF
    ld bc, $0020                                  ; $6DE0
    ld a, $33                                     ; $6DE3
    call Vram_CopyHBlankFar                       ; $6DE5
    ld e, l                                       ; $6DE8
    ld d, h                                       ; $6DE9
    pop hl                                        ; $6DEA
    ld a, [hl]                                    ; $6DEB
    and $0f                                       ; $6DEC
    dec a                                         ; $6DEE
    cp $ff                                        ; $6DEF
    jr nz, jr_005_6df5                            ; $6DF1

    ld a, $0a                                     ; $6DF3

jr_005_6df5:
    push hl                                       ; $6DF5
    push de                                       ; $6DF6
    call NameCard_DigitGlyphAddr                  ; $6DF7
    pop hl                                        ; $6DFA
    ld bc, $0020                                  ; $6DFB
    ld a, $33                                     ; $6DFE
    call Vram_CopyHBlankFar                       ; $6E00
    ld e, l                                       ; $6E03
    ld d, h                                       ; $6E04
    pop hl                                        ; $6E05
    inc hl                                        ; $6E06
    pop bc                                        ; $6E07
    dec b                                         ; $6E08
    jr nz, jr_005_6dcd                            ; $6E09

    jp Far_Return                                 ; $6E0B


; C: glyph ($DAE8 & 3) of 30:7FA0 into $8B20 (0 drawn as glyph 2); the blood type of the ID card (I); runs on its
; screen (03:02) in the core replays (port/entry_modes_kitty.csv); code read
NameCard_DrawBloodType::
    ld a, [wIdCard + $d]                          ; $6E0E
    and $03                                       ; $6E11
    dec a                                         ; $6E13
    cp $ff                                        ; $6E14
    jr nz, jr_005_6e1a                            ; $6E16

    ld a, $02                                     ; $6E18

jr_005_6e1a:
    ld c, $20                                     ; $6E1A
    call Mul_8x8                                  ; $6E1C
    ld de, Gfx_30_7FA0_Mode02_TakePhotos_State08  ; $6E1F
    add hl, de                                    ; $6E22
    ld e, l                                       ; $6E23
    ld d, h                                       ; $6E24
    ld hl, $8b20                                  ; $6E25
    ld bc, $0020                                  ; $6E28
    ld a, $30                                     ; $6E2B
    call Vram_CopyHBlankFar                       ; $6E2D
    jp Far_Return                                 ; $6E30


; C: glyph (($DAE8 >> 2) & 7) of 1D:7F40 into $8B40 (0 drawn as glyph 4); the boy / girl field of the ID card (I);
; runs on its screen (03:02) in the core replays (port/entry_modes_kitty.csv); code read
NameCard_DrawSex::
    ld a, [wIdCard + $d]                          ; $6E33
    sra a                                         ; $6E36
    sra a                                         ; $6E38
    and $07                                       ; $6E3A
    dec a                                         ; $6E3C
    cp $ff                                        ; $6E3D
    jr nz, jr_005_6e43                            ; $6E3F

    ld a, $04                                     ; $6E41

jr_005_6e43:
    ld c, $20                                     ; $6E43
    call Mul_8x8                                  ; $6E45
    ld de, Gfx_1D_7F40_Mode0B_NameCardEdit_State0A ; $6E48
    add hl, de                                    ; $6E4B
    ld e, l                                       ; $6E4C
    ld d, h                                       ; $6E4D
    ld hl, $8b40                                  ; $6E4E
    ld bc, $0020                                  ; $6E51
    ld a, $1d                                     ; $6E54
    call Vram_CopyHBlankFar                       ; $6E56
    jp Far_Return                                 ; $6E59


; C: A (0 taken as 1) as BCD (00:0C9A) with digit tiles of 0C:7840 into $87B0; mode $02 state $03; runs in the camera
; view and the album
Photo_DrawNumber::
    and a                                         ; $6E5C
    jr nz, jr_005_6e61                            ; $6E5D

    ld a, $01                                     ; $6E5F

jr_005_6e61:
    call Bin_ToBcd                                ; $6E61
    ld a, c                                       ; $6E64
    cp $31                                        ; $6E65
    jr nz, jr_005_6e6b                            ; $6E67

    ld c, $aa                                     ; $6E69

jr_005_6e6b:
    push bc                                       ; $6E6B
    ld a, c                                       ; $6E6C
    and $f0                                       ; $6E6D
    ld c, a                                       ; $6E6F
    ld b, $00                                     ; $6E70
    ld hl, Gfx_0C_4000_Mode05_StampWindow_State06 + $3840 ; $6E72
    add hl, bc                                    ; $6E75
    ld e, l                                       ; $6E76
    ld d, h                                       ; $6E77
    ld a, $0c                                     ; $6E78
    ld hl, $87b0                                  ; $6E7A
    ld bc, $0010                                  ; $6E7D
    call Vram_CopyHBlankFar                       ; $6E80
    pop bc                                        ; $6E83
    ld a, c                                       ; $6E84
    and $0f                                       ; $6E85
    swap a                                        ; $6E87
    ld c, a                                       ; $6E89
    ld b, $00                                     ; $6E8A
    ld hl, Gfx_0C_7920_Mode02_TakePhotos_State06 + $20 ; $6E8C
    add hl, bc                                    ; $6E8F
    ld e, l                                       ; $6E90
    ld d, h                                       ; $6E91
    ld a, $0c                                     ; $6E92
    ld hl, $87d0                                  ; $6E94
    ld bc, $0010                                  ; $6E97
    call Vram_CopyHBlankFar                       ; $6E9A
    jp Far_Return                                 ; $6E9D


    and a                                         ; $6EA0
    jr nz, jr_005_6ea5                            ; $6EA1

    ld a, $01                                     ; $6EA3

jr_005_6ea5:
    call Bin_ToBcd                                ; $6EA5
    ld a, c                                       ; $6EA8
    cp $31                                        ; $6EA9
    jr nz, jr_005_6eaf                            ; $6EAB

    ld c, $aa                                     ; $6EAD

jr_005_6eaf:
    push bc                                       ; $6EAF
    ld a, c                                       ; $6EB0
    and $f0                                       ; $6EB1
    ld c, a                                       ; $6EB3
    ld b, $00                                     ; $6EB4
    ld hl, Gfx_0C_4000_Mode05_StampWindow_State06 + $3840 ; $6EB6
    add hl, bc                                    ; $6EB9
    ld e, l                                       ; $6EBA
    ld d, h                                       ; $6EBB
    ld a, $0c                                     ; $6EBC
    ld hl, $87b0                                  ; $6EBE
    ld bc, $0010                                  ; $6EC1
    call Copy_FarDEtoHL                           ; $6EC4
    pop bc                                        ; $6EC7
    ld a, c                                       ; $6EC8
    and $0f                                       ; $6EC9
    swap a                                        ; $6ECB
    ld c, a                                       ; $6ECD
    ld b, $00                                     ; $6ECE
    ld hl, Gfx_0C_7920_Mode02_TakePhotos_State06 + $20 ; $6ED0
    add hl, bc                                    ; $6ED3
    ld e, l                                       ; $6ED4
    ld d, h                                       ; $6ED5
    ld a, $0c                                     ; $6ED6
    ld hl, $87d0                                  ; $6ED8
    ld bc, $0010                                  ; $6EDB
    call Copy_FarDEtoHL                           ; $6EDE
    jp Far_Return                                 ; $6EE1


; C: five blocks of $C0 bytes from bank $0D ($4600-$4A00) into $9380 and $84C0; mode $03 state $00; runs on its screen
; (03:00) in the core replays (port/entry_modes_kitty.csv); code read
Album_LoadTilesBank0D::
    ld de, Gfx_0D_4600_Mode03_ViewAlbum_State02   ; $6EE4
    ld hl, $9380                                  ; $6EE7
    ld bc, $00c0                                  ; $6EEA
    ld a, $0d                                     ; $6EED
    call Vram_CopyHBlankFar                       ; $6EEF
    ld de, Gfx_0D_4700_Album_LoadTilesBank0D      ; $6EF2
    ld bc, $00c0                                  ; $6EF5
    ld a, $0d                                     ; $6EF8
    call Vram_CopyHBlankFar                       ; $6EFA
    ld de, Gfx_0D_4800_Album_LoadTilesBank0D      ; $6EFD
    ld bc, $00c0                                  ; $6F00
    ld a, $0d                                     ; $6F03
    call Vram_CopyHBlankFar                       ; $6F05
    ld de, Gfx_0D_4900_Album_LoadTilesBank0D      ; $6F08
    ld hl, $84c0                                  ; $6F0B
    ld bc, $00c0                                  ; $6F0E
    ld a, $0d                                     ; $6F11
    call Vram_CopyHBlankFar                       ; $6F13
    ld de, Gfx_0D_4A00_Album_LoadTilesBank0D      ; $6F16
    ld bc, $00c0                                  ; $6F19
    ld a, $0d                                     ; $6F1C
    call Vram_CopyHBlankFar                       ; $6F1E
    ld de, Gfx_0D_4B00_Album_LoadTilesBank0D      ; $6F21
    ld bc, $00c0                                  ; $6F24
    ld a, $0d                                     ; $6F27
    call Vram_CopyHBlankFar                       ; $6F29
    jp Far_Return                                 ; $6F2C


; C: five blocks of $C0 bytes from bank $15 ($5380-$5500, $44C0-$4580) into $9380 and $84C0; mode $03 state $03; runs
; on its screen (03:03) in the core replays (port/entry_modes_kitty.csv); code read
Album_LoadTilesBank15::
    ld de, Gfx_15_5380_Mode03_ViewAlbum_State02   ; $6F2F
    ld hl, $9380                                  ; $6F32
    ld bc, $00c0                                  ; $6F35
    ld a, $15                                     ; $6F38
    call Vram_CopyHBlankFar                       ; $6F3A
    ld de, Gfx_15_5440_Album_LoadTilesBank15      ; $6F3D
    ld bc, $00c0                                  ; $6F40
    ld a, $15                                     ; $6F43
    call Vram_CopyHBlankFar                       ; $6F45
    ld de, Gfx_15_5500_Album_LoadTilesBank15      ; $6F48
    ld bc, $00c0                                  ; $6F4B
    ld a, $15                                     ; $6F4E
    call Vram_CopyHBlankFar                       ; $6F50
    ld de, Gfx_15_44C0_Album_LoadTilesBank15      ; $6F53
    ld hl, $84c0                                  ; $6F56
    ld bc, $00c0                                  ; $6F59
    ld a, $15                                     ; $6F5C
    call Vram_CopyHBlankFar                       ; $6F5E
    ld de, Gfx_15_4580_Album_LoadTilesBank15      ; $6F61
    ld bc, $00c0                                  ; $6F64
    ld a, $15                                     ; $6F67
    call Vram_CopyHBlankFar                       ; $6F69
    ld de, Gfx_15_4640_Album_LoadTilesBank15      ; $6F6C
    ld bc, $00c0                                  ; $6F6F
    ld a, $15                                     ; $6F72
    call Vram_CopyHBlankFar                       ; $6F74
    jp Far_Return                                 ; $6F77


; C: handler of state $00 of mode $03 (word 0 of Mode03_StateTable)
Mode03_State00::
    di                                            ; $6F7A
    call Lcd_Off                                  ; $6F7B
    call Oam_ClearShadow                          ; $6F7E
    ld b, BANK(Objects_ClearAll)                  ; $6F81
    ld hl, Objects_ClearAll                       ; $6F83
    call Far_Call                                 ; $6F86
    ld b, BANK(ScriptSlots_Clear)                 ; $6F89
    ld hl, ScriptSlots_Clear                      ; $6F8B
    call Far_Call                                 ; $6F8E
    call Copy_FarInline                           ; $6F91

    db $00, $40, $15, $00, $80, $00, $18

    call Copy_FarInline                           ; $6F9B

    db $40, $62, $22, $00, $9c, $00, $04

    ld a, [wAlbum_SlotOp6D18_D932]                ; $6FA5
    ld [wMode03_State02_D933], a                  ; $6FA8
    and a                                         ; $6FAB
    jr nz, jr_005_6fba                            ; $6FAC

    call Copy_FarInline                           ; $6FAE

    db $40, $5a, $22, $00, $98, $00, $04

    jr jr_005_6fc4                                ; $6FB8

jr_005_6fba:
    call Copy_FarInline                           ; $6FBA

    db $40, $5e, $22, $00, $98, $00, $04

jr_005_6fc4:
    ld a, [wMode03_State02_D8F7]                  ; $6FC4
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6FC7
    xor a                                         ; $6FCA
    ld [wUnused_Mode02_State0C_D930], a           ; $6FCB
    ld b, MODE_VIEW_ALBUM                         ; $6FCE
    ld c, $01                                     ; $6FD0
    call Mode_SaveReturnD8F2                      ; $6FD2
    xor a                                         ; $6FD5
    ld [wStamp_ObjSlideIn_D994], a                ; $6FD6
    ld [wStamp_CursorUpdate_D996], a              ; $6FD9
    ld hl, wStamp_CursorUpdate_D998               ; $6FDC
    ld bc, $0010                                  ; $6FDF
    call Call_000_01fe                            ; $6FE2
    ld a, $02                                     ; $6FE5
    ld [wStamp_CursorUpdate_D9A8], a              ; $6FE7
    xor a                                         ; $6FEA
    ld [wMode03_State00_D995], a                  ; $6FEB
    ld a, $34                                     ; $6FEE
    ld [wStamp_ObjPlaceOnStart_D9C2], a           ; $6FF0
    ld a, $78                                     ; $6FF3
    ld [wStamp_ObjPlaceOnStart_D9C3], a           ; $6FF5
    ld a, $04                                     ; $6FF8
    ld [wStamp_CursorUpdate_D9C4], a              ; $6FFA
    ld a, $45                                     ; $6FFD
    ld [wStamp_CursorUpdate_D9C5], a              ; $6FFF
    call Stat_SetTileToggleAt47                   ; $7002
    call Serial_SetFarCallback                    ; $7005

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $700B

    db $e3, $e4, $d0, $e4, $18, $00, $70, $00, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $7019

    dw $0a0a

    push af                                       ; $701E
    ld a, MUSIC_VIEW_ALBUM                        ; $701F
    ld [wSndMusicReq], a                          ; $7021
    pop af                                        ; $7024
    ei                                            ; $7025
    ld a, [wMode03_State02_D933]                  ; $7026
    and a                                         ; $7029
    jr nz, jr_005_7044                            ; $702A

    ld b, BANK(Album_LoadTilesBank0D)             ; $702C
    ld hl, Album_LoadTilesBank0D                  ; $702E
    call Far_Call                                 ; $7031
    ld de, Gfx_15_5000_Mode03_ViewAlbum_State02   ; $7034
    ld a, $15                                     ; $7037
    ld hl, $9000                                  ; $7039
    ld bc, $0370                                  ; $703C
    call Vram_CopyHBlankFar                       ; $703F
    jr jr_005_706d                                ; $7042

jr_005_7044:
    ld b, BANK(Photo_FindSlotA)                   ; $7044
    ld hl, Photo_FindSlotA                        ; $7046
    call Far_CallKeepA                            ; $7049
    jr c, jr_005_7060                             ; $704C

    ld b, BANK(Photo_LoadThumbToVram)             ; $704E
    ld hl, Photo_LoadThumbToVram                  ; $7050
    call Far_CallKeepA                            ; $7053
    ld b, BANK(Text_DrawSmallLine)                ; $7056
    ld hl, Text_DrawSmallLine                     ; $7058
    call Far_Call                                 ; $705B
    jr jr_005_706d                                ; $705E

jr_005_7060:
    ld a, $01                                     ; $7060
    call Photo_LoadEmptyThumb                     ; $7062
    ld b, BANK(Text_DrawSmallLine)                ; $7065
    ld hl, Text_DrawSmallLine                     ; $7067
    call Far_Call                                 ; $706A

jr_005_706d:
    ld b, BANK(NameCard_DrawName)                 ; $706D
    ld hl, NameCard_DrawName                      ; $706F
    call Far_Call                                 ; $7072
    ld b, BANK(NameCard_DrawBirthday)             ; $7075
    ld hl, NameCard_DrawBirthday                  ; $7077
    call Far_Call                                 ; $707A
    ld b, BANK(NameCard_DrawBloodType)            ; $707D
    ld hl, NameCard_DrawBloodType                 ; $707F
    call Far_Call                                 ; $7082
    ld b, BANK(NameCard_DrawSex)                  ; $7085
    ld hl, NameCard_DrawSex                       ; $7087
    call Far_Call                                 ; $708A
    ld b, MODE_VIEW_ALBUM                         ; $708D
    ld c, STATE_03_VIEW_PHOTOS_ALBUM              ; $708F
    call Fade_GoTo                                ; $7091
    ld bc, $4438                                  ; $7094
    ld de, ObjScript_02_621E_Album_Arrow61FE + $A ; $7097
    call Object_CreateWithParam                   ; $709A
    ld de, ObjScript_02_616A_Album_Arrow614A + $C ; $709D
    call Object_Create                            ; $70A0
    ld de, ObjScript_02_61A2_Album_Arrow617C + $C ; $70A3
    call Object_Create                            ; $70A6
    ld de, ObjScript_02_4F99_Album_CursorUpdate + $E ; $70A9
    call Object_Create                            ; $70AC
    ret                                           ; $70AF


; C: handler of state $01 of mode $03 (word 1 of Mode03_StateTable)
Mode03_State01::
    di                                            ; $70B0
    call Lcd_Off                                  ; $70B1
    call Oam_ClearShadow                          ; $70B4
    ld b, BANK(Objects_ClearAll)                  ; $70B7
    ld hl, Objects_ClearAll                       ; $70B9
    call Far_Call                                 ; $70BC
    ld b, BANK(ScriptSlots_Clear)                 ; $70BF
    ld hl, ScriptSlots_Clear                      ; $70C1
    call Far_Call                                 ; $70C4
    call Copy_FarInline                           ; $70C7

    db $00, $40, $15, $00, $80, $00, $18

    call Copy_FarInline                           ; $70D1

    db $40, $5e, $22, $00, $98, $00, $04

    call Copy_FarInline                           ; $70DB

    db $40, $62, $22, $00, $9c, $00, $04

    ld a, [wMode03_State02_D933]                  ; $70E5
    and a                                         ; $70E8
    jr nz, jr_005_70f7                            ; $70E9

    call Copy_FarInline                           ; $70EB

    db $40, $5a, $22, $00, $98, $00, $04

    jr jr_005_7101                                ; $70F5

jr_005_70f7:
    call Copy_FarInline                           ; $70F7

    db $40, $5e, $22, $00, $98, $00, $04

jr_005_7101:
    ld a, [wMode03_State02_D8F7]                  ; $7101
    ld [wMenu07_CursorUpdate_D8F4], a             ; $7104
    ld b, MODE_VIEW_ALBUM                         ; $7107
    ld c, $01                                     ; $7109
    call Mode_SaveReturnD8F2                      ; $710B
    call Stat_SetTileToggleAt47                   ; $710E
    call Serial_SetFarCallback                    ; $7111

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $7117

    db $e3, $e4, $d0, $e4, $18, $00, $70, $00, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $7125

    dw $0a0a

    push af                                       ; $712A
    ld a, MUSIC_VIEW_ALBUM                        ; $712B
    ld [wSndMusicReq], a                          ; $712D
    pop af                                        ; $7130
    ei                                            ; $7131
    ld a, [wMode03_State02_D933]                  ; $7132
    and a                                         ; $7135
    jr nz, jr_005_7150                            ; $7136

    ld b, BANK(Album_LoadTilesBank0D)             ; $7138
    ld hl, Album_LoadTilesBank0D                  ; $713A
    call Far_Call                                 ; $713D
    ld de, Gfx_15_5000_Mode03_ViewAlbum_State02   ; $7140
    ld a, $15                                     ; $7143
    ld hl, $9000                                  ; $7145
    ld bc, $0370                                  ; $7148
    call Vram_CopyHBlankFar                       ; $714B
    jr jr_005_7179                                ; $714E

jr_005_7150:
    ld b, BANK(Photo_FindSlotA)                   ; $7150
    ld hl, Photo_FindSlotA                        ; $7152
    call Far_CallKeepA                            ; $7155
    jr c, jr_005_716c                             ; $7158

    ld b, BANK(Photo_LoadThumbToVram)             ; $715A
    ld hl, Photo_LoadThumbToVram                  ; $715C
    call Far_CallKeepA                            ; $715F
    ld b, BANK(Text_DrawSmallLine)                ; $7162
    ld hl, Text_DrawSmallLine                     ; $7164
    call Far_Call                                 ; $7167
    jr jr_005_7179                                ; $716A

jr_005_716c:
    ld a, $01                                     ; $716C
    call Photo_LoadEmptyThumb                     ; $716E
    ld b, BANK(Text_DrawSmallLine)                ; $7171
    ld hl, Text_DrawSmallLine                     ; $7173
    call Far_Call                                 ; $7176

jr_005_7179:
    ld b, BANK(NameCard_DrawName)                 ; $7179
    ld hl, NameCard_DrawName                      ; $717B
    call Far_Call                                 ; $717E
    ld b, BANK(NameCard_DrawBirthday)             ; $7181
    ld hl, NameCard_DrawBirthday                  ; $7183
    call Far_Call                                 ; $7186
    ld b, BANK(NameCard_DrawBloodType)            ; $7189
    ld hl, NameCard_DrawBloodType                 ; $718B
    call Far_Call                                 ; $718E
    ld b, BANK(NameCard_DrawSex)                  ; $7191
    ld hl, NameCard_DrawSex                       ; $7193
    call Far_Call                                 ; $7196
    ld b, MODE_VIEW_ALBUM                         ; $7199
    ld c, STATE_03_VIEW_PHOTOS_ALBUM              ; $719B
    call Fade_GoTo                                ; $719D
    ld bc, $4438                                  ; $71A0
    ld de, ObjScript_02_621E_Album_Arrow61FE + $A ; $71A3
    call Object_CreateWithParam                   ; $71A6
    ld de, ObjScript_02_616A_Album_Arrow614A + $C ; $71A9
    call Object_Create                            ; $71AC
    ld de, ObjScript_02_61A2_Album_Arrow617C + $C ; $71AF
    call Object_Create                            ; $71B2
    ld de, ObjScript_02_4F99_Album_CursorUpdate + $E ; $71B5
    call Object_Create                            ; $71B8
    ret                                           ; $71BB


; C: handler of state $02 of mode $03 (word 2 of Mode03_StateTable)
Mode03_State02::
    ld a, [wMode07_StateTable_D8E0]               ; $71BC
    bit 0, a                                      ; $71BF
    jr z, jr_005_71d7                             ; $71C1

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $71C3
    ld [wMode03_State02_D8F7], a                  ; $71C6
    ldh a, [hMenuMode]                            ; $71C9
    ldh [hMode], a                                ; $71CB
    ld b, a                                       ; $71CD
    ldh a, [hMenuState]                           ; $71CE
    ldh [hState], a                               ; $71D0
    ld c, a                                       ; $71D2
    call Fade_GoToB                               ; $71D3
    ret                                           ; $71D6


jr_005_71d7:
    ld a, [wFadeRunning]                          ; $71D7
    and a                                         ; $71DA
    ret nz                                        ; $71DB

    ld a, [wKeysHeld]                             ; $71DC
    bit PADB_START, a                             ; $71DF
    jp z, Jump_005_7269                           ; $71E1

    ld a, [wMode03_State02_D933]                  ; $71E4
    and a                                         ; $71E7
    jp z, Jump_005_7269                           ; $71E8

    ld a, [wKeysNew]                              ; $71EB
    bit PADB_A, a                                 ; $71EE
    jr z, jr_005_7269                             ; $71F0

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $71F2
    cp $04                                        ; $71F5
    jr nz, jr_005_721c                            ; $71F7

    push af                                       ; $71F9
    ld a, SFX4_0A                                 ; $71FA
    ld [wSndSfx4], a                              ; $71FC
    pop af                                        ; $71FF
    push hl                                       ; $7200
    ld hl, wMode06_State0A_D896                   ; $7201
    set 0, [hl]                                   ; $7204
    pop hl                                        ; $7206
    ld [wMode03_State02_D8F7], a                  ; $7207
    call Album_SlotOp6D18                         ; $720A
    push hl                                       ; $720D
    ld hl, wMode06_State0A_D896                   ; $720E
    res 0, [hl]                                   ; $7211
    pop hl                                        ; $7213
    ld b, MODE_VIEW_ALBUM                         ; $7214
    ld c, $01                                     ; $7216
    call Fade_GoToB                               ; $7218
    ret                                           ; $721B


jr_005_721c:
    cp $05                                        ; $721C
    jr nz, jr_005_7269                            ; $721E

    ld [wMode03_State02_D8F7], a                  ; $7220
    ld a, [wAlbum_SlotOp6D18_D932]                ; $7223
    cp $1e                                        ; $7226
    jp z, Jump_005_7263                           ; $7228

    push af                                       ; $722B
    ld a, SFX1_2F                                 ; $722C
    ld [wSndSfx1], a                              ; $722E
    pop af                                        ; $7231
    push hl                                       ; $7232
    ld hl, wMode06_State0A_D896                   ; $7233
    set 0, [hl]                                   ; $7236
    pop hl                                        ; $7238
    ld a, [wMode03_State02_D933]                  ; $7239
    ld b, BANK(Photo_FindSlotA)                   ; $723C
    ld hl, Photo_FindSlotA                        ; $723E
    call Far_CallKeepA                            ; $7241
    ld b, BANK(Photo_LoadToBuffer)                ; $7244
    ld hl, Photo_LoadToBuffer                     ; $7246
    call Far_CallKeepA                            ; $7249
    ld a, $01                                     ; $724C
    ld [wSlotTagCopyFlag], a                      ; $724E
    call Album_StorePhoto6D60                     ; $7251
    push hl                                       ; $7254
    ld hl, wMode06_State0A_D896                   ; $7255
    res 0, [hl]                                   ; $7258
    pop hl                                        ; $725A
    ld b, MODE_VIEW_ALBUM                         ; $725B
    ld c, $01                                     ; $725D
    call Fade_GoToB                               ; $725F
    ret                                           ; $7262


Jump_005_7263:
    ld a, $00                                     ; $7263
    call Message_Show                             ; $7265
    ret                                           ; $7268


Jump_005_7269:
jr_005_7269:
    ld a, [wKeysNew]                              ; $7269
    bit PADB_B, a                                 ; $726C
    jr z, jr_005_7285                             ; $726E

    push af                                       ; $7270
    ld a, SFX3_08                                 ; $7271
    ld [wSndSfx3], a                              ; $7273
    pop af                                        ; $7276
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $7277
    ld [wMode03_State02_D8F7], a                  ; $727A
    ld b, MODE_MAIN_MENU                          ; $727D
    ld c, $00                                     ; $727F
    call Fade_GoToB                               ; $7281
    ret                                           ; $7284


jr_005_7285:
    ld a, [wKeysNewRepeat]                        ; $7285
    bit PADB_LEFT, a                              ; $7288
    jr z, jr_005_72c3                             ; $728A

    ld a, [wMode03_State02_D933]                  ; $728C
    dec a                                         ; $728F
    cp $ff                                        ; $7290
    jr z, jr_005_7309                             ; $7292

    ld [wMode03_State02_D933], a                  ; $7294
    push af                                       ; $7297
    ld a, SFX1_23                                 ; $7298
    ld [wSndSfx1], a                              ; $729A
    pop af                                        ; $729D
    ld a, $01                                     ; $729E
    ld [wFadeRunning], a                          ; $72A0
    ld a, $03                                     ; $72A3
    ldh [hState], a                               ; $72A5
    ld a, [wMode03_State02_D933]                  ; $72A7
    and a                                         ; $72AA
    jr nz, jr_005_72bc                            ; $72AB

    ld b, BANK(Album_LoadTilesBank0D)             ; $72AD
    ld hl, Album_LoadTilesBank0D                  ; $72AF
    call Far_Call                                 ; $72B2
    ld de, ObjScript_02_6246_Mode03_ViewAlbum_State03 + $5E ; $72B5
    call Object_Create                            ; $72B8
    ret                                           ; $72BB


jr_005_72bc:
    ld de, ObjScript_02_63B6_Mode03_ViewAlbum_State03 + $59 ; $72BC
    call Object_Create                            ; $72BF
    ret                                           ; $72C2


jr_005_72c3:
    ld a, [wKeysNewRepeat]                        ; $72C3
    bit PADB_RIGHT, a                             ; $72C6
    jr z, jr_005_7308                             ; $72C8

    push af                                       ; $72CA
    ld a, SFX1_23                                 ; $72CB
    ld [wSndSfx1], a                              ; $72CD
    pop af                                        ; $72D0
    ld hl, wAlbum_SlotOp6D18_D932                 ; $72D1
    ld a, [wMode03_State02_D933]                  ; $72D4
    cp [hl]                                       ; $72D7
    jr z, jr_005_7309                             ; $72D8

    inc a                                         ; $72DA
    cp $1f                                        ; $72DB
    jr z, jr_005_7309                             ; $72DD

    ld [wMode03_State02_D933], a                  ; $72DF
    ld a, $01                                     ; $72E2
    ld [wFadeRunning], a                          ; $72E4
    ld a, $03                                     ; $72E7
    ldh [hState], a                               ; $72E9
    ld a, [wMode03_State02_D933]                  ; $72EB
    cp $01                                        ; $72EE
    jr z, jr_005_72f9                             ; $72F0

    ld de, ObjScript_02_63B6_Mode03_ViewAlbum_State03 + $B8 ; $72F2
    call Object_Create                            ; $72F5
    ret                                           ; $72F8


jr_005_72f9:
    ld b, BANK(Album_LoadTilesBank15)             ; $72F9
    ld hl, Album_LoadTilesBank15                  ; $72FB
    call Far_Call                                 ; $72FE
    ld de, ObjScript_02_630C_Mode03_ViewAlbum_State03 + $59 ; $7301
    call Object_Create                            ; $7304
    ret                                           ; $7307


jr_005_7308:
    ret                                           ; $7308


jr_005_7309:
    push af                                       ; $7309
    ld a, SFX1_3C                                 ; $730A
    ld [wSndSfx1], a                              ; $730C
    pop af                                        ; $730F
    ret                                           ; $7310


; C: handler of state $03 of mode $03 (word 3 of Mode03_StateTable)
Mode03_State03::
    ld hl, wMode06_State0E_D8D3                   ; $7311
    bit 7, [hl]                                   ; $7314
    jr z, jr_005_731c                             ; $7316

    ld a, $02                                     ; $7318
    ldh [hState], a                               ; $731A

jr_005_731c:
    ret                                           ; $731C


; C: handler of state $04 of mode $03 (word 4 of Mode03_StateTable)
Mode03_State04::
    di                                            ; $731D
    call Lcd_Off                                  ; $731E
    call Oam_ClearShadow                          ; $7321
    ld b, BANK(Objects_ClearAll)                  ; $7324
    ld hl, Objects_ClearAll                       ; $7326
    call Far_Call                                 ; $7329
    ld b, BANK(ScriptSlots_Clear)                 ; $732C
    ld hl, ScriptSlots_Clear                      ; $732E
    call Far_Call                                 ; $7331
    call Copy_FarInline                           ; $7334

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $733E

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleAt4F                   ; $7348
    call Serial_SetFarCallback                    ; $734B

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $7351

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    call Keys_SetRepeatInline                     ; $735F

    dw $0a0a

    push af                                       ; $7364
    ld a, MUSIC_VIEW_ALBUM_03_04                  ; $7365
    ld [wSndMusicReq], a                          ; $7367
    pop af                                        ; $736A
    ei                                            ; $736B
    ld a, [wMode03_State02_D933]                  ; $736C
    ld b, BANK(Photo_FindSlotA)                   ; $736F
    ld hl, Photo_FindSlotA                        ; $7371
    call Far_CallKeepA                            ; $7374
    jr c, jr_005_738c                             ; $7377

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $7379
    ld hl, Photo_LoadToBufferAndVram              ; $737B
    call Far_CallKeepA                            ; $737E
    ld a, [wSlotTagBorder]                        ; $7381
    ld [wAlbum_ObjFollowDAA6_D936], a             ; $7384
    call FrameRec_LoadDefault                     ; $7387
    jr jr_005_7396                                ; $738A

jr_005_738c:
    ld a, $01                                     ; $738C
    call Photo_LoadEmptyPicture                   ; $738E
    ld a, $00                                     ; $7391
    call FrameRec_LoadDefault                     ; $7393

jr_005_7396:
    ld de, ObjScript_02_61CF_Album_ObjOnLeftRight + $14 ; $7396
    call Object_Create                            ; $7399
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $20 ; $739C
    call Object_Create                            ; $739F
    ld de, ObjScript_02_60DA_Mode02_TakePhotos_State01 + $26 ; $73A2
    call Object_Create                            ; $73A5
    ld b, MODE_VIEW_ALBUM                         ; $73A8
    ld c, $05                                     ; $73AA
    call Fade_GoTo                                ; $73AC
    ret                                           ; $73AF


; C: handler of state $05 of mode $03 (word 5 of Mode03_StateTable)
Mode03_State05::
    ld a, [wKeysNew]                              ; $73B0
    bit PADB_B, a                                 ; $73B3
    jr z, jr_005_73c6                             ; $73B5

    push af                                       ; $73B7
    ld a, SFX3_09                                 ; $73B8
    ld [wSndSfx3], a                              ; $73BA
    pop af                                        ; $73BD
    ld b, MODE_VIEW_ALBUM                         ; $73BE
    ld c, $01                                     ; $73C0
    call Fade_GoToB                               ; $73C2
    ret                                           ; $73C5


jr_005_73c6:
    ld a, [wKeysNewRepeat]                        ; $73C6
    bit PADB_LEFT, a                              ; $73C9
    jr z, jr_005_7408                             ; $73CB

    ld a, [wMode03_State02_D933]                  ; $73CD
    dec a                                         ; $73D0
    jr nz, jr_005_73d6                            ; $73D1

    ld a, [wAlbum_SlotOp6D18_D932]                ; $73D3

jr_005_73d6:
    ld [wMode03_State02_D933], a                  ; $73D6

jr_005_73d9:
    push af                                       ; $73D9
    ld a, SFX1_03                                 ; $73DA
    ld [wSndSfx1], a                              ; $73DC
    pop af                                        ; $73DF
    ld de, ObjScript_02_648E_Mode03_ViewAlbum_State05 + $8 ; $73E0
    call Object_Create                            ; $73E3
    ld a, [wMode03_State02_D933]                  ; $73E6
    ld b, BANK(Photo_FindSlotA)                   ; $73E9
    ld hl, Photo_FindSlotA                        ; $73EB
    call Far_CallKeepA                            ; $73EE
    jr c, jr_005_73fd                             ; $73F1

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $73F3
    ld hl, Photo_LoadToBufferAndVram              ; $73F5
    call Far_CallKeepA                            ; $73F8
    jr jr_005_7407                                ; $73FB

jr_005_73fd:
    ld a, $01                                     ; $73FD
    call Photo_LoadEmptyPicture                   ; $73FF
    ld a, $00                                     ; $7402
    call FrameRec_LoadDefault                     ; $7404

jr_005_7407:
    ret                                           ; $7407


jr_005_7408:
    ld a, [wKeysNewRepeat]                        ; $7408
    bit PADB_RIGHT, a                             ; $740B
    jr z, jr_005_741f                             ; $740D

    ld hl, wAlbum_SlotOp6D18_D932                 ; $740F
    ld a, [wMode03_State02_D933]                  ; $7412
    cp [hl]                                       ; $7415
    jr nz, jr_005_7419                            ; $7416

    xor a                                         ; $7418

jr_005_7419:
    inc a                                         ; $7419
    ld [wMode03_State02_D933], a                  ; $741A
    jr jr_005_73d9                                ; $741D

jr_005_741f:
    ret                                           ; $741F


    db $f5, $3e, $1b, $ea, $60, $d0, $f1, $c9

; C: handler of state $0C of mode $03 (word 12 of Mode03_StateTable)
Mode03_State0C::
    di                                            ; $7428
    call Lcd_Off                                  ; $7429
    call Oam_ClearShadow                          ; $742C
    ld b, BANK(Objects_ClearAll)                  ; $742F
    ld hl, Objects_ClearAll                       ; $7431
    call Far_Call                                 ; $7434
    ld b, BANK(ScriptSlots_Clear)                 ; $7437
    ld hl, ScriptSlots_Clear                      ; $7439
    call Far_Call                                 ; $743C
    call Copy_FarInline                           ; $743F

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $7449

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleAt4F                   ; $7453
    call Serial_SetFarCallback                    ; $7456

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $745C

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    push af                                       ; $746A
    ld a, MUSIC_VIEW_ALBUM_03_0C                  ; $746B
    ld [wSndMusicReq], a                          ; $746D
    pop af                                        ; $7470
    ei                                            ; $7471
    ld a, [wMode03_State02_D933]                  ; $7472
    ld b, BANK(Photo_FindSlotA)                   ; $7475
    ld hl, Photo_FindSlotA                        ; $7477
    call Far_CallKeepA                            ; $747A
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $747D
    ld hl, Photo_LoadToBufferAndVram              ; $747F
    call Far_CallKeepA                            ; $7482
    ld a, $25                                     ; $7485
    call FrameRec_LoadDefault                     ; $7487
    ld hl, wLcdcShadow                            ; $748A
    set 2, [hl]                                   ; $748D
    ld b, MODE_VIEW_ALBUM                         ; $748F
    ld c, $0d                                     ; $7491
    call Fade_GoTo                                ; $7493
    ld a, $06                                     ; $7496
    ld b, BANK(KeyPrompt_LoadSounds)              ; $7498
    ld hl, KeyPrompt_LoadSounds                   ; $749A
    call Far_CallKeepA                            ; $749D
    ret                                           ; $74A0


; C: handler of state $0D of mode $03 (word 13 of Mode03_StateTable)
Mode03_State0D::
    ld a, [wMode06_State0A_D8DF]                  ; $74A1
    bit 0, a                                      ; $74A4
    jr z, jr_005_74be                             ; $74A6

    push hl                                       ; $74A8
    ld hl, wMode06_State0A_D896                   ; $74A9
    set 0, [hl]                                   ; $74AC
    pop hl                                        ; $74AE
    call Album_SlotOp6D18                         ; $74AF
    push hl                                       ; $74B2
    ld hl, wMode06_State0A_D896                   ; $74B3
    res 0, [hl]                                   ; $74B6
    pop hl                                        ; $74B8
    ld a, $0e                                     ; $74B9
    ldh [hState], a                               ; $74BB
    ret                                           ; $74BD


jr_005_74be:
    ld a, [wMode06_State0A_D8DF]                  ; $74BE
    bit 1, a                                      ; $74C1
    jr z, jr_005_74cd                             ; $74C3

    ld b, MODE_VIEW_ALBUM                         ; $74C5
    ld c, $01                                     ; $74C7
    call Fade_GoToB                               ; $74C9
    ret                                           ; $74CC


jr_005_74cd:
    ret                                           ; $74CD


; C: handler of state $0E of mode $03 (word 14 of Mode03_StateTable)
Mode03_State0E::
    xor a                                         ; $74CE
    ld [wMode07_StateTable_D8E0], a               ; $74CF
    call Rng_Next                                 ; $74D2
    and $06                                       ; $74D5
    ld c, a                                       ; $74D7
    ld b, $00                                     ; $74D8
    ld hl, Mode03_State0E_Tbl74EE                 ; $74DA
    add hl, bc                                    ; $74DD
    ld e, [hl]                                    ; $74DE
    inc hl                                        ; $74DF
    ld d, [hl]                                    ; $74E0
    ld b, BANK(ScriptSlots_Add)                   ; $74E1
    ld hl, ScriptSlots_Add                        ; $74E3
    call Far_Call                                 ; $74E6
    ld a, $0f                                     ; $74E9
    ldh [hState], a                               ; $74EB
    ret                                           ; $74ED


; C: named by the code of Mode03_State0E (05:74DA); read in the runs by Mode03_State0E; first read on the screen
; Mode03_ViewAlbum_State0F (trace/read_screens_kitty.npz)
Mode03_State0E_Tbl74EE::
    db $3f, $58, $64, $58, $89, $58, $ae, $58

; C: handler of state $0F of mode $03 (word 15 of Mode03_StateTable)
Mode03_State0F::
    ld a, [wMode07_StateTable_D8E0]               ; $74F6
    and a                                         ; $74F9
    ret z                                         ; $74FA

    ld b, MODE_VIEW_ALBUM                         ; $74FB
    ld c, $01                                     ; $74FD
    call Fade_GoToB                               ; $74FF
    ret                                           ; $7502


; C: handler of state $10 of mode $03 (word 16 of Mode03_StateTable)
Mode03_State10::
    di                                            ; $7503
    call Lcd_Off                                  ; $7504
    call Oam_ClearShadow                          ; $7507
    ld b, BANK(Objects_ClearAll)                  ; $750A
    ld hl, Objects_ClearAll                       ; $750C
    call Far_Call                                 ; $750F
    ld b, BANK(ScriptSlots_Clear)                 ; $7512
    ld hl, ScriptSlots_Clear                      ; $7514
    call Far_Call                                 ; $7517
    call Copy_FarInline                           ; $751A

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $7524

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleAt4F                   ; $752E
    call Serial_SetFarCallback                    ; $7531

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $7537

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    push af                                       ; $7545
    ld a, MUSIC_VIEW_ALBUM_03_10                  ; $7546
    ld [wSndMusicReq], a                          ; $7548
    pop af                                        ; $754B
    ei                                            ; $754C
    ld a, [wMode03_State02_D933]                  ; $754D
    ld b, BANK(Photo_FindSlotA)                   ; $7550
    ld hl, Photo_FindSlotA                        ; $7552
    call Far_CallKeepA                            ; $7555
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $7558
    ld hl, Photo_LoadToBufferAndVram              ; $755A
    call Far_CallKeepA                            ; $755D
    ld a, $27                                     ; $7560
    call FrameRec_LoadDefault                     ; $7562
    ld a, $27                                     ; $7565
    call FrameRec_LoadMapWin                      ; $7567
    ld hl, wLcdcShadow                            ; $756A
    set 2, [hl]                                   ; $756D
    ld b, MODE_VIEW_ALBUM                         ; $756F
    ld c, $11                                     ; $7571
    call Fade_GoTo                                ; $7573
    ld a, $09                                     ; $7576
    ld b, BANK(KeyPrompt_LoadSounds)              ; $7578
    ld hl, KeyPrompt_LoadSounds                   ; $757A
    call Far_CallKeepA                            ; $757D
    ret                                           ; $7580


; C: handler of state $11 of mode $03 (word 17 of Mode03_StateTable)
Mode03_State11::
    ld a, [wMode06_State0A_D8DF]                  ; $7581
    bit 0, a                                      ; $7584
    jr z, jr_005_75b1                             ; $7586

    ld a, [wAlbum_SlotOp6D18_D932]                ; $7588
    cp $1e                                        ; $758B
    jp z, Jump_005_75ab                           ; $758D

    push hl                                       ; $7590
    ld hl, wMode06_State0A_D896                   ; $7591
    set 0, [hl]                                   ; $7594
    pop hl                                        ; $7596
    ld a, $01                                     ; $7597
    ld [wSlotTagCopyFlag], a                      ; $7599
    call Album_StorePhoto6D60                     ; $759C
    push hl                                       ; $759F
    ld hl, wMode06_State0A_D896                   ; $75A0
    res 0, [hl]                                   ; $75A3
    pop hl                                        ; $75A5
    ld a, $12                                     ; $75A6
    ldh [hState], a                               ; $75A8
    ret                                           ; $75AA


Jump_005_75ab:
    ld a, $00                                     ; $75AB
    call Message_Show                             ; $75AD
    ret                                           ; $75B0


jr_005_75b1:
    ld a, [wMode06_State0A_D8DF]                  ; $75B1
    bit 1, a                                      ; $75B4
    jr z, jr_005_75c0                             ; $75B6

    ld b, MODE_VIEW_ALBUM                         ; $75B8
    ld c, $01                                     ; $75BA
    call Fade_GoToB                               ; $75BC
    ret                                           ; $75BF


jr_005_75c0:
    ret                                           ; $75C0


; C: handler of state $12 of mode $03 (word 18 of Mode03_StateTable)
Mode03_State12::
    xor a                                         ; $75C1
    ld [wMode07_StateTable_D8E0], a               ; $75C2
    ld de, ObjScript_00_1BF5_Mode03_ViewAlbum_State13 + $32 ; $75C5
    call Object_Create                            ; $75C8
    ld de, ObjScript_00_1CAB_Mode03_ViewAlbum_State12; $75CB
    call Object_Create                            ; $75CE
    ld a, $13                                     ; $75D1
    ldh [hState], a                               ; $75D3
    ret                                           ; $75D5


; C: handler of state $13 of mode $03 (word 19 of Mode03_StateTable)
Mode03_State13::
    ld a, [wMode07_StateTable_D8E0]               ; $75D6
    and a                                         ; $75D9
    ret z                                         ; $75DA

    ld b, MODE_VIEW_ALBUM                         ; $75DB
    ld c, $01                                     ; $75DD
    call Fade_GoToB                               ; $75DF
    ret                                           ; $75E2


; C: ModeTable entry $03: BGB screen 03:02 (album binder)
Mode03_ViewAlbum::
    ldh a, [hState]                               ; $75E3
    ld hl, Mode03_StateTable                      ; $75E5
    call JumpTable_ByA                            ; $75E8
    jp Far_Return                                 ; $75EB


; C: state table of mode $03, read by $0189 with hFF8E
Mode03_StateTable::
    dw Mode03_State00
    dw Mode03_State01
    dw Mode03_State02
    dw Mode03_State03
    dw Mode03_State04
    dw Mode03_State05
    dw Mode03_State06
    dw Mode03_State07
    dw Mode03_State08
    dw Mode03_State09
    dw Mode03_State0A
    dw Mode03_State0B
    dw Mode03_State0C
    dw Mode03_State0D
    dw Mode03_State0E
    dw Mode03_State0F
    dw Mode03_State10
    dw Mode03_State11
    dw Mode03_State12
    dw Mode03_State13

    ; padding
    ds $9ea, $00

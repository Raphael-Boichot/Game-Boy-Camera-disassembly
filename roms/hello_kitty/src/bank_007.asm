; Pocket Camera Hello Kitty (Japan), bank $07. Written by tools/make_source.py from roms/hello_kitty/pocketcamera_kitty.sym and the tables of
; roms/hello_kitty/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

; C: handler of state $00 of mode $1A (word 0 of Mode1A_StateTable)
Mode1A_State00::
    di                                            ; $4000
    call Lcd_Off                                  ; $4001
    call Oam_ClearShadow                          ; $4004
    ld b, BANK(Objects_ClearAll)                  ; $4007
    ld hl, Objects_ClearAll                       ; $4009
    call Far_Call                                 ; $400C
    ld b, BANK(ScriptSlots_Clear)                 ; $400F
    ld hl, ScriptSlots_Clear                      ; $4011
    call Far_Call                                 ; $4014
    call Copy_FarInline                           ; $4017

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $4021

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleCAt1F                  ; $402B
    ld bc, $3800                                  ; $402E
    ld de, ObjScript_02_6DD0_Mode05_StampWindow_State06 + $30 ; $4031
    call Object_CreateWithParam                   ; $4034
    call Serial_SetFarCallback                    ; $4037

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $403D

    db $a3, $e4, $e4, $d0, $10, $10, $07, $90, $ff, $40, $03

    ei                                            ; $404B
    ld a, $00                                     ; $404C
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $404E
    ld hl, Photo_LoadToBufferAndVram              ; $4050
    call Far_CallKeepA                            ; $4053
    ld a, [wSlotTagBorder]                        ; $4056
    ld [wMode06_State00_D931], a                  ; $4059
    ld a, [wMode06_State00_D931]                  ; $405C
    call FrameRec_LoadDefault                     ; $405F
    ld b, MODE_EMPTY_FRAME1_A                     ; $4062
    ld c, STATE_1A_EMPTY_PHOTO_FRAME              ; $4064
    call Fade_GoTo                                ; $4066
    ret                                           ; $4069


; C: handler of state $01 of mode $1A (word 1 of Mode1A_StateTable)
Mode1A_State01::
    ld a, [wKeysNew]                              ; $406A
    bit PADB_B, a                                 ; $406D
    jr z, jr_007_4078                             ; $406F

    ld b, MODE_PLAY_MENU                          ; $4071
    ld c, $00                                     ; $4073
    call Fade_GoToB                               ; $4075

jr_007_4078:
    ret                                           ; $4078


; I: ModeTable entry $1A: forced BGB screen (an empty photo frame)
Mode1A_EmptyFrame1A::
    ldh a, [hState]                               ; $4079
    ld hl, Mode1A_StateTable                      ; $407B
    call JumpTable_ByA                            ; $407E
    jp Far_Return                                 ; $4081


; C: state table of mode $1A, read by $0189 with hFF8E
Mode1A_StateTable::
    dw Mode1A_State00
    dw Mode1A_State01

; C: handler of state $00 of mode $1B (word 0 of Mode1B_StateTable)
Mode1B_State00::
    di                                            ; $4088
    call Lcd_Off                                  ; $4089
    call Oam_ClearShadow                          ; $408C
    ld b, BANK(Objects_ClearAll)                  ; $408F
    ld hl, Objects_ClearAll                       ; $4091
    call Far_Call                                 ; $4094
    ld b, BANK(ScriptSlots_Clear)                 ; $4097
    ld hl, ScriptSlots_Clear                      ; $4099
    call Far_Call                                 ; $409C
    xor a                                         ; $409F
    ld [wMode07_StateTable_D8E0], a               ; $40A0
    call Copy_FarInline                           ; $40A3

    db $00, $58, $18, $00, $80, $00, $18

    call Copy_FarInline                           ; $40AD

    db $00, $78, $32, $00, $98, $40, $02

    call Serial_SetFarCallback                    ; $40B7

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $40BD

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $09

    push af                                       ; $40CB
    ld a, MUSIC_PRINTING_06_23                    ; $40CC
    ld [wSndMusicReq], a                          ; $40CE
    pop af                                        ; $40D1
    ei                                            ; $40D2
    xor a                                         ; $40D3
    ld [wMode06_State23_D94F], a                  ; $40D4
    ld a, $07                                     ; $40D7
    ld [wMode06_State10_D950], a                  ; $40D9
    ld a, [wMode06_State23_D94F]                  ; $40DC
    ld de, $97a0                                  ; $40DF
    ld b, BANK(Number_DrawTwoDigits)              ; $40E2
    ld hl, Number_DrawTwoDigits                   ; $40E4
    call Far_CallKeepA                            ; $40E7
    ld a, [wPrintGameRecord]                      ; $40EA
    ld de, $97d0                                  ; $40ED
    ld b, BANK(Number_DrawTwoDigits)              ; $40F0
    ld hl, Number_DrawTwoDigits                   ; $40F2
    call Far_CallKeepA                            ; $40F5
    ld de, ObjScript_02_75F0_Mode06_Printing_State24 ; $40F8
    call Object_Create                            ; $40FB
    ld de, ObjScript_02_7044_Mode06_Printing_State1F + $1C ; $40FE
    call Object_Create                            ; $4101
    ld de, ObjScript_02_7345_Mode06_Printing_State24 ; $4104
    call Object_Create                            ; $4107
    ld de, ObjScript_02_71F2_Mode06_Printing_State24 ; $410A
    call Object_Create                            ; $410D
    ld b, MODE_PRINTING_APPLE_GAME                ; $4110
    ld c, STATE_1B_PRINTING_CATCH_APPLES_GAME_PRINTER ; $4112
    call Fade_GoTo                                ; $4114
    ret                                           ; $4117


; C: handler of state $01 of mode $1B (word 1 of Mode1B_StateTable)
Mode1B_State01::
    ld a, [wMode07_StateTable_D8E0]               ; $4118
    bit 1, a                                      ; $411B
    jr z, jr_007_4127                             ; $411D

    ld b, MODE_PLAY_MENU                          ; $411F
    ld c, $00                                     ; $4121
    call Fade_GoToB                               ; $4123
    ret                                           ; $4126


jr_007_4127:
    ld a, [wKeysNew]                              ; $4127
    bit PADB_SELECT, a                            ; $412A
    jr z, jr_007_4136                             ; $412C

    ld b, MODE_PLAY_MENU                          ; $412E
    ld c, $00                                     ; $4130
    call Fade_GoToB                               ; $4132
    ret                                           ; $4135


jr_007_4136:
    ret                                           ; $4136


; I: ModeTable entry $1B: forced BGB screen (printing: catch the apples while the printer works)
Mode1B_PrintingAppleGame::
    ldh a, [hState]                               ; $4137
    ld hl, Mode1B_StateTable                      ; $4139
    call JumpTable_ByA                            ; $413C
    jp Far_Return                                 ; $413F


; C: state table of mode $1B, read by $0189 with hFF8E
Mode1B_StateTable::
    dw Mode1B_State00
    dw Mode1B_State01

; C: handler of state $00 of mode $1C (word 0 of Mode1C_StateTable)
Mode1C_State00::
    di                                            ; $4146
    call Lcd_Off                                  ; $4147
    call Oam_ClearShadow                          ; $414A
    ld b, BANK(Objects_ClearAll)                  ; $414D
    ld hl, Objects_ClearAll                       ; $414F
    call Far_Call                                 ; $4152
    ld b, BANK(ScriptSlots_Clear)                 ; $4155
    ld hl, ScriptSlots_Clear                      ; $4157
    call Far_Call                                 ; $415A
    call Copy_FarInline                           ; $415D

    db $50, $73, $23, $00, $86, $00, $04

    call Copy_FarInline                           ; $4167

    db $f0, $75, $31, $00, $98, $00, $04

    call Stat_SetTileToggleCAt1F                  ; $4171
    ld bc, $3800                                  ; $4174
    ld de, ObjScript_02_6DD0_Mode05_StampWindow_State06 + $30 ; $4177
    call Object_CreateWithParam                   ; $417A
    call Serial_SetFarCallback                    ; $417D

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $4183

    db $a3, $e4, $e4, $d0, $10, $10, $07, $90, $ff, $40, $03

    ei                                            ; $4191
    ld a, $00                                     ; $4192
    ld b, BANK(Photo_LoadToBufferAndVram)         ; $4194
    ld hl, Photo_LoadToBufferAndVram              ; $4196
    call Far_CallKeepA                            ; $4199
    ld a, [wSlotTagBorder]                        ; $419C
    ld [wMode06_State00_D931], a                  ; $419F
    ld a, [wMode06_State00_D931]                  ; $41A2
    call FrameRec_LoadDefault                     ; $41A5
    ld b, MODE_EMPTY_FRAME1_C                     ; $41A8
    ld c, STATE_1C_EMPTY_PHOTO_FRAME              ; $41AA
    call Fade_GoTo                                ; $41AC
    ret                                           ; $41AF


; C: handler of state $01 of mode $1C (word 1 of Mode1C_StateTable)
Mode1C_State01::
    ld a, [wKeysNew]                              ; $41B0
    bit PADB_B, a                                 ; $41B3
    jr z, jr_007_41be                             ; $41B5

    ld b, MODE_PLAY_MENU                          ; $41B7
    ld c, $00                                     ; $41B9
    call Fade_GoToB                               ; $41BB

jr_007_41be:
    ret                                           ; $41BE


; I: ModeTable entry $1C: forced BGB screen (an empty photo frame)
Mode1C_EmptyFrame1C::
    ldh a, [hState]                               ; $41BF
    ld hl, Mode1C_StateTable                      ; $41C1
    call JumpTable_ByA                            ; $41C4
    jp Far_Return                                 ; $41C7


; C: state table of mode $1C, read by $0189 with hFF8E
Mode1C_StateTable::
    dw Mode1C_State00
    dw Mode1C_State01

; C: read in the runs by FrameCorner_Draw; first read on the screen Mode02_TakePhotos_State01
; (trace/read_screens_kitty*.npz)
FrameCorner_Draw_Tbl41CE::
    INCBIN "data/bank_07/FrameCorner_Draw_Tbl41CE.bin" ; $41CE, 324 bytes
; C: animation channel A of the camera frame: timer $D903 - 1; at 0 the index $D8FF + 1 and the next 5-byte keyframe
; (DE + 5 x index) gives the new timer, $FF loops to 0; HL = the keyframe
FrameAnim_StepA::
    ld hl, wFrameAnim_StepA_D903                  ; $4312
    dec [hl]                                      ; $4315
    jr nz, jr_007_432b                            ; $4316

    ld a, [wFrameAnim_StepA_D8FF]                 ; $4318
    inc a                                         ; $431B
    ld [wFrameAnim_StepA_D8FF], a                 ; $431C

jr_007_431f:
    call FrameAnim_KeyAddrA                       ; $431F
    ld a, [hl+]                                   ; $4322
    cp $ff                                        ; $4323
    jr z, jr_007_4330                             ; $4325

    ld [wFrameAnim_StepA_D903], a                 ; $4327
    ret                                           ; $432A


jr_007_432b:
    call FrameAnim_KeyAddrA                       ; $432B
    inc hl                                        ; $432E
    ret                                           ; $432F


jr_007_4330:
    xor a                                         ; $4330
    ld [wFrameAnim_StepA_D8FF], a                 ; $4331
    jr jr_007_431f                                ; $4334

; C: HL = DE + 5 x [$D8FF]
FrameAnim_KeyAddrA::
    ld a, [wFrameAnim_StepA_D8FF]                 ; $4336
    ld c, $05                                     ; $4339
    call Mul_8x8                                  ; $433B
    add hl, de                                    ; $433E
    ret                                           ; $433F


; C: animation channel B of the camera frame: timer $D904 - 1; at 0 the index $D900 + 1 and the next 5-byte keyframe
; (DE + 5 x index) gives the new timer, $FF loops to 0; HL = the keyframe
FrameAnim_StepB::
    ld hl, wFrameAnim_StepB_D904                  ; $4340
    dec [hl]                                      ; $4343
    jr nz, jr_007_4359                            ; $4344

    ld a, [wFrameAnim_StepB_D900]                 ; $4346
    inc a                                         ; $4349
    ld [wFrameAnim_StepB_D900], a                 ; $434A

jr_007_434d:
    call FrameAnim_KeyAddrB                       ; $434D
    ld a, [hl+]                                   ; $4350
    cp $ff                                        ; $4351
    jr z, jr_007_435e                             ; $4353

    ld [wFrameAnim_StepB_D904], a                 ; $4355
    ret                                           ; $4358


jr_007_4359:
    call FrameAnim_KeyAddrB                       ; $4359
    inc hl                                        ; $435C
    ret                                           ; $435D


jr_007_435e:
    xor a                                         ; $435E
    ld [wFrameAnim_StepB_D900], a                 ; $435F
    jr jr_007_434d                                ; $4362

; C: HL = DE + 5 x [$D900]
FrameAnim_KeyAddrB::
    ld a, [wFrameAnim_StepB_D900]                 ; $4364
    ld c, $05                                     ; $4367
    call Mul_8x8                                  ; $4369
    add hl, de                                    ; $436C
    ret                                           ; $436D


; C: animation channel C of the camera frame: timer $D905 - 1; at 0 the index $D901 + 1 and the next 5-byte keyframe
; (DE + 5 x index) gives the new timer, $FF loops to 0; HL = the keyframe
FrameAnim_StepC::
    ld hl, wFrameAnim_StepC_D905                  ; $436E
    dec [hl]                                      ; $4371
    jr nz, jr_007_4387                            ; $4372

    ld a, [wFrameAnim_StepC_D901]                 ; $4374
    inc a                                         ; $4377
    ld [wFrameAnim_StepC_D901], a                 ; $4378

jr_007_437b:
    call FrameAnim_KeyAddrC                       ; $437B
    ld a, [hl+]                                   ; $437E
    cp $ff                                        ; $437F
    jr z, jr_007_438c                             ; $4381

    ld [wFrameAnim_StepC_D905], a                 ; $4383
    ret                                           ; $4386


jr_007_4387:
    call FrameAnim_KeyAddrC                       ; $4387
    inc hl                                        ; $438A
    ret                                           ; $438B


jr_007_438c:
    xor a                                         ; $438C
    ld [wFrameAnim_StepC_D901], a                 ; $438D
    jr jr_007_437b                                ; $4390

; C: HL = DE + 5 x [$D901]
FrameAnim_KeyAddrC::
    ld a, [wFrameAnim_StepC_D901]                 ; $4392
    ld c, $05                                     ; $4395
    call Mul_8x8                                  ; $4397
    add hl, de                                    ; $439A
    ret                                           ; $439B


; C: animation channel D of the camera frame: timer $D906 - 1; at 0 the index $D902 + 1 and the next 5-byte keyframe
; (DE + 5 x index) gives the new timer, $FF loops to 0; HL = the keyframe
FrameAnim_StepD::
    ld hl, wFrameAnim_StepD_D906                  ; $439C
    dec [hl]                                      ; $439F
    jr nz, jr_007_43b5                            ; $43A0

    ld a, [wFrameAnim_StepD_D902]                 ; $43A2
    inc a                                         ; $43A5
    ld [wFrameAnim_StepD_D902], a                 ; $43A6

jr_007_43a9:
    call FrameAnim_KeyAddrD                       ; $43A9
    ld a, [hl+]                                   ; $43AC
    cp $ff                                        ; $43AD
    jr z, jr_007_43ba                             ; $43AF

    ld [wFrameAnim_StepD_D906], a                 ; $43B1
    ret                                           ; $43B4


jr_007_43b5:
    call FrameAnim_KeyAddrD                       ; $43B5
    inc hl                                        ; $43B8
    ret                                           ; $43B9


jr_007_43ba:
    xor a                                         ; $43BA
    ld [wFrameAnim_StepD_D902], a                 ; $43BB
    jr jr_007_43a9                                ; $43BE

; C: HL = DE + 5 x [$D902]
FrameAnim_KeyAddrD::
    ld a, [wFrameAnim_StepD_D902]                 ; $43C0
    ld c, $05                                     ; $43C3
    call Mul_8x8                                  ; $43C5
    add hl, de                                    ; $43C8
    ret                                           ; $43C9


; C: FrameCorner_Draw at $C000 of the photo buffer
FrameCorner_DrawTopLeft::
    push hl                                       ; $43CA
    ld hl, $c000                                  ; $43CB
    call FrameCorner_Draw                         ; $43CE
    pop hl                                        ; $43D1
    ret                                           ; $43D2


; C: FrameCorner_Draw at $C080 of the photo buffer
FrameCorner_DrawTopRight::
    push hl                                       ; $43D3
    ld hl, $c080                                  ; $43D4
    call FrameCorner_Draw                         ; $43D7
    pop hl                                        ; $43DA
    ret                                           ; $43DB


; C: FrameCorner_Draw at $C700 of the photo buffer
FrameCorner_DrawBottomLeft::
    push hl                                       ; $43DC
    ld hl, $c700                                  ; $43DD
    call FrameCorner_Draw                         ; $43E0
    pop hl                                        ; $43E3
    ret                                           ; $43E4


; C: FrameCorner_Draw at $C780 of the photo buffer
FrameCorner_DrawBottomRight::
    push hl                                       ; $43E5
    ld hl, $c780                                  ; $43E6
    call FrameCorner_Draw                         ; $43E9
    pop hl                                        ; $43EC
    ret                                           ; $43ED


; C: piece A at HL: $FC-$FF fill the corner with shade 0-3 (07:4461), else the 3-byte record A of [$D92D] (address,
; bank) drawn by 00:0B7B
FrameCorner_Draw::
    push hl                                       ; $43EE
    cp $fc                                        ; $43EF
    jp z, Jump_007_441b                           ; $43F1

    cp $fd                                        ; $43F4
    jp z, Jump_007_4423                           ; $43F6

    cp $fe                                        ; $43F9
    jp z, Jump_007_442b                           ; $43FB

    cp $ff                                        ; $43FE
    jp z, Jump_007_4433                           ; $4400

    ld c, $03                                     ; $4403
    call Mul_8x8                                  ; $4405
    ld a, [wTakePhotos_ResetFrameState_D92D]      ; $4408
    ld c, a                                       ; $440B
    ld a, [wTakePhotos_ResetFrameState_D92E]      ; $440C
    ld b, a                                       ; $440F
    add hl, bc                                    ; $4410
    ld a, [hl+]                                   ; $4411
    ld e, a                                       ; $4412
    ld a, [hl+]                                   ; $4413
    ld d, a                                       ; $4414
    ld a, [hl+]                                   ; $4415
    pop hl                                        ; $4416
    call Copy_PictureHalfRows                     ; $4417
    ret                                           ; $441A


Jump_007_441b:
    pop hl                                        ; $441B
    ld de, $0000                                  ; $441C
    call Fill_CornerBlock                         ; $441F
    ret                                           ; $4422


Jump_007_4423:
    pop hl                                        ; $4423
    ld de, $00ff                                  ; $4424
    call Fill_CornerBlock                         ; $4427
    ret                                           ; $442A


Jump_007_442b:
    pop hl                                        ; $442B
    ld de, $ff00                                  ; $442C
    call Fill_CornerBlock                         ; $442F
    ret                                           ; $4432


Jump_007_4433:
    pop hl                                        ; $4433
    ld de, $ffff                                  ; $4434
    call Fill_CornerBlock                         ; $4437
    ret                                           ; $443A


; C: 8 x 16 bytes of the 2-byte pattern DE at HL
Fill_PatternRow::
    ld c, $08                                     ; $443B

jr_007_443d:
    ld a, e                                       ; $443D
    ld [hl+], a                                   ; $443E
    ld a, d                                       ; $443F
    ld [hl+], a                                   ; $4440
    ld a, e                                       ; $4441
    ld [hl+], a                                   ; $4442
    ld a, d                                       ; $4443
    ld [hl+], a                                   ; $4444
    ld a, e                                       ; $4445
    ld [hl+], a                                   ; $4446
    ld a, d                                       ; $4447
    ld [hl+], a                                   ; $4448
    ld a, e                                       ; $4449
    ld [hl+], a                                   ; $444A
    ld a, d                                       ; $444B
    ld [hl+], a                                   ; $444C
    ld a, e                                       ; $444D
    ld [hl+], a                                   ; $444E
    ld a, d                                       ; $444F
    ld [hl+], a                                   ; $4450
    ld a, e                                       ; $4451
    ld [hl+], a                                   ; $4452
    ld a, d                                       ; $4453
    ld [hl+], a                                   ; $4454
    ld a, e                                       ; $4455
    ld [hl+], a                                   ; $4456
    ld a, d                                       ; $4457
    ld [hl+], a                                   ; $4458
    ld a, e                                       ; $4459
    ld [hl+], a                                   ; $445A
    ld a, d                                       ; $445B
    ld [hl+], a                                   ; $445C
    dec c                                         ; $445D
    jr nz, jr_007_443d                            ; $445E

    ret                                           ; $4460


; C: seven Fill_PatternRow, $80 bytes apart
Fill_CornerBlock::
    call Fill_PatternRow                          ; $4461
    ld bc, $0080                                  ; $4464
    add hl, bc                                    ; $4467
    call Fill_PatternRow                          ; $4468
    ld bc, $0080                                  ; $446B
    add hl, bc                                    ; $446E
    call Fill_PatternRow                          ; $446F
    ld bc, $0080                                  ; $4472
    add hl, bc                                    ; $4475
    call Fill_PatternRow                          ; $4476
    ld bc, $0080                                  ; $4479
    add hl, bc                                    ; $447C
    call Fill_PatternRow                          ; $447D
    ld bc, $0080                                  ; $4480
    add hl, bc                                    ; $4483
    call Fill_PatternRow                          ; $4484
    ld bc, $0080                                  ; $4487
    add hl, bc                                    ; $448A
    call Fill_PatternRow                          ; $448B
    ret                                           ; $448E


; C: jump table 07:449C of 31 handlers by A (the frame type)
CameraFrame_RunType::
    sla a                                         ; $448F
    ld c, a                                       ; $4491
    ld b, $00                                     ; $4492
    ld hl, CameraFrame_RunType_JumpTbl449C        ; $4494
    add hl, bc                                    ; $4497
    ld a, [hl+]                                   ; $4498
    ld h, [hl]                                    ; $4499
    ld l, a                                       ; $449A
    jp hl                                         ; $449B


; C: named by the code of CameraFrame_RunType (07:4494); read in the runs by CameraFrame_RunType; first read on the
; screen Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
CameraFrame_RunType_JumpTbl449C::
    dw CameraFrame_Type00to03
    dw CameraFrame_Type00to03
    dw CameraFrame_Type00to03
    dw CameraFrame_Type00to03
    dw CameraFrame_Type04
    dw CameraFrame_Type05
    dw CameraFrame_Type06
    dw CameraFrame_Type07
    dw CameraFrame_Type08
    dw CameraFrame_Type09
    dw CameraFrame_Type10
    dw CameraFrame_Type11
    dw CameraFrame_Type12
    dw CameraFrame_Type13
    dw CameraFrame_Type14
    dw CameraFrame_Type15
    dw CameraFrame_Type16
    dw CameraFrame_Type17
    dw CameraFrame_Type18
    dw CameraFrame_Type19
    dw CameraFrame_Type20
    dw CameraFrame_Type21
    dw CameraFrame_Type22
    dw CameraFrame_Type23
    dw CameraFrame_Type24
    dw CameraFrame_Type25
    dw CameraFrame_Type26
    dw CameraFrame_Type27
    dw CameraFrame_Type28
    dw CameraFrame_Type29
    dw CameraFrame_Type30
    dw CameraFrame_Type31

; C: frame types 0-3: steps channel A over the keyframes of 07:4501 by [$D92F], draws the four corners
CameraFrame_Type00to03::
    ld a, [wTakePhotos_FrameCallback_D92F]        ; $44DC
    sla a                                         ; $44DF
    ld c, a                                       ; $44E1
    ld b, $00                                     ; $44E2
    ld hl, CameraFrame_Type00to03_Tbl4501         ; $44E4
    add hl, bc                                    ; $44E7
    ld e, [hl]                                    ; $44E8
    inc hl                                        ; $44E9
    ld d, [hl]                                    ; $44EA

jr_007_44eb:
    call FrameAnim_StepA                          ; $44EB
    ld a, [hl+]                                   ; $44EE
    call FrameCorner_DrawTopLeft                  ; $44EF
    ld a, [hl+]                                   ; $44F2
    call FrameCorner_DrawTopRight                 ; $44F3
    ld a, [hl+]                                   ; $44F6
    call FrameCorner_DrawBottomLeft               ; $44F7
    ld a, [hl+]                                   ; $44FA
    call FrameCorner_DrawBottomRight              ; $44FB
    jp Far_Return                                 ; $44FE


; C: named by the code of CameraFrame_Type00to03 (07:44E4); read in the runs by CameraFrame_Type00to03; first read on
; the screen Mode02_TakePhotos_State01 (trace/read_screens_kitty*.npz)
CameraFrame_Type00to03_Tbl4501::
    db $d6, $6c

; C: frame type 24: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type24::
    jr jr_007_44eb                                ; $4503

; C: frame type 25: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type25::
    jr jr_007_44eb                                ; $4505

; C: frame type 26: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type26::
    jr jr_007_44eb                                ; $4507

; C: frame type 27: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type27::
    jr jr_007_44eb                                ; $4509

; C: frame type 28: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type28::
    jr jr_007_44eb                                ; $450B

; C: frame type 29: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type29::
    jr jr_007_44eb                                ; $450D

; C: frame type 30: jr back into CameraFrame_Type00to03 (not run in the core)
CameraFrame_Type30::
    jr jr_007_44eb                                ; $450F

; C: entry 31 of the frame type table 07:449C (32 words): a jr into CameraFrame_Type00to03 like types 24-30; code read
CameraFrame_Type31::
    jr jr_007_44eb                                ; $4511

; C: frame type 4 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type04::
    ld de, $6d54                                  ; $4513
    call FrameAnim_StepA                          ; $4516
    ld a, [hl+]                                   ; $4519
    call FrameCorner_DrawTopRight                 ; $451A
    ld a, [hl+]                                   ; $451D
    call FrameCorner_DrawBottomRight              ; $451E
    ld a, $0d                                     ; $4521
    ld b, BANK(Cam_DispatchEffect_Far)            ; $4523
    ld hl, Cam_DispatchEffect_Far                 ; $4525
    call Far_CallKeepA                            ; $4528
    jp Far_Return                                 ; $452B


; C: frame type 5 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type05::
    ld de, $6d54                                  ; $452E
    call FrameAnim_StepA                          ; $4531
    ld a, [hl+]                                   ; $4534
    call FrameCorner_DrawTopRight                 ; $4535
    ld a, [hl+]                                   ; $4538
    call FrameCorner_DrawBottomRight              ; $4539
    jp Far_Return                                 ; $453C


; C: frame type 6 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type06::
    ld de, $6d54                                  ; $453F
    call FrameAnim_StepA                          ; $4542
    ld a, [hl+]                                   ; $4545
    call FrameCorner_DrawTopLeft                  ; $4546
    ld a, [hl+]                                   ; $4549
    call FrameCorner_DrawBottomLeft               ; $454A
    ld a, $0e                                     ; $454D
    ld b, BANK(Cam_DispatchEffect_Far)            ; $454F
    ld hl, Cam_DispatchEffect_Far                 ; $4551
    call Far_CallKeepA                            ; $4554
    jp Far_Return                                 ; $4557


; C: frame type 7 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type07::
    ld a, $0e                                     ; $455A
    ld b, BANK(Cam_DispatchEffect_Far)            ; $455C
    ld hl, Cam_DispatchEffect_Far                 ; $455E
    call Far_CallKeepA                            ; $4561
    jp Far_Return                                 ; $4564


; C: frame type 8 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type08::
    ld de, $6e05                                  ; $4567
    call FrameAnim_StepA                          ; $456A
    ld a, [hl+]                                   ; $456D
    call FrameCorner_DrawBottomLeft               ; $456E
    ld a, [hl+]                                   ; $4571
    call FrameCorner_DrawBottomRight              ; $4572
    ld a, $0f                                     ; $4575
    ld b, BANK(Cam_DispatchEffect_Far)            ; $4577
    ld hl, Cam_DispatchEffect_Far                 ; $4579
    call Far_CallKeepA                            ; $457C
    jp Far_Return                                 ; $457F


; C: frame type 9 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type09::
    ld de, $6e05                                  ; $4582
    call FrameAnim_StepA                          ; $4585
    ld a, [hl+]                                   ; $4588
    call FrameCorner_DrawBottomLeft               ; $4589
    ld a, [hl+]                                   ; $458C
    call FrameCorner_DrawBottomRight              ; $458D
    jp Far_Return                                 ; $4590


; C: frame type 10 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type10::
    ld de, $6daf                                  ; $4593
    call FrameAnim_StepA                          ; $4596
    ld a, [hl+]                                   ; $4599
    call FrameCorner_DrawTopLeft                  ; $459A
    ld a, [hl+]                                   ; $459D
    call FrameCorner_DrawTopRight                 ; $459E
    ld a, $10                                     ; $45A1
    ld b, BANK(Cam_DispatchEffect_Far)            ; $45A3
    ld hl, Cam_DispatchEffect_Far                 ; $45A5
    call Far_CallKeepA                            ; $45A8
    jp Far_Return                                 ; $45AB


; C: frame type 11 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type11::
    ld a, $10                                     ; $45AE
    ld b, BANK(Cam_DispatchEffect_Far)            ; $45B0
    ld hl, Cam_DispatchEffect_Far                 ; $45B2
    call Far_CallKeepA                            ; $45B5
    jp Far_Return                                 ; $45B8


; C: frame type 12 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type12::
    ld a, $00                                     ; $45BB
    ld b, BANK(Cam_DispatchEffect_Far)            ; $45BD
    ld hl, Cam_DispatchEffect_Far                 ; $45BF
    call Far_CallKeepA                            ; $45C2
    ld de, $6e5b                                  ; $45C5
    call FrameAnim_StepA                          ; $45C8
    ld a, [hl+]                                   ; $45CB
    call FrameCorner_DrawTopRight                 ; $45CC
    ld de, $6e5b                                  ; $45CF
    call FrameAnim_StepB                          ; $45D2
    ld a, [hl+]                                   ; $45D5
    call FrameCorner_DrawBottomLeft               ; $45D6
    jp Far_Return                                 ; $45D9


; C: frame type 13 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type13::
    ld de, $6e5b                                  ; $45DC
    call FrameAnim_StepA                          ; $45DF
    ld a, [hl+]                                   ; $45E2
    call FrameCorner_DrawTopRight                 ; $45E3
    ld a, $10                                     ; $45E6
    ld b, BANK(Cam_DispatchEffect_Far)            ; $45E8
    ld hl, Cam_DispatchEffect_Far                 ; $45EA
    call Far_CallKeepA                            ; $45ED
    ld de, $6e5b                                  ; $45F0
    call FrameAnim_StepB                          ; $45F3
    ld a, [hl+]                                   ; $45F6
    call FrameCorner_DrawBottomLeft               ; $45F7
    jp Far_Return                                 ; $45FA


; C: frame type 14 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type14::
    ld de, $6e5b                                  ; $45FD
    call FrameAnim_StepB                          ; $4600
    ld a, [hl+]                                   ; $4603
    call FrameCorner_DrawBottomLeft               ; $4604
    ld a, $18                                     ; $4607
    ld b, BANK(Cam_DispatchEffect_Far)            ; $4609
    ld hl, Cam_DispatchEffect_Far                 ; $460B
    call Far_CallKeepA                            ; $460E
    jp Far_Return                                 ; $4611


; C: frame type 15 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type15::
    ld a, $18                                     ; $4614
    ld b, BANK(Cam_DispatchEffect_Far)            ; $4616
    ld hl, Cam_DispatchEffect_Far                 ; $4618
    call Far_CallKeepA                            ; $461B
    jp Far_Return                                 ; $461E


; C: frame type 16 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type16::
    ld de, $6e5b                                  ; $4621
    call FrameAnim_StepA                          ; $4624
    ld a, [hl+]                                   ; $4627
    call FrameCorner_DrawTopLeft                  ; $4628
    ld de, $6e5b                                  ; $462B
    call FrameAnim_StepB                          ; $462E
    ld a, [hl+]                                   ; $4631
    call FrameCorner_DrawBottomRight              ; $4632
    ld a, $11                                     ; $4635
    ld b, BANK(Cam_DispatchEffect_Far)            ; $4637
    ld hl, Cam_DispatchEffect_Far                 ; $4639
    call Far_CallKeepA                            ; $463C
    jp Far_Return                                 ; $463F


; C: frame type 17 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type17::
    ld de, $6e5b                                  ; $4642
    call FrameAnim_StepB                          ; $4645
    ld a, [hl+]                                   ; $4648
    call FrameCorner_DrawBottomRight              ; $4649
    ld a, $11                                     ; $464C
    ld b, BANK(Cam_DispatchEffect_Far)            ; $464E
    ld hl, Cam_DispatchEffect_Far                 ; $4650
    call Far_CallKeepA                            ; $4653
    jp Far_Return                                 ; $4656


; C: frame type 18 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type18::
    ld a, $10                                     ; $4659
    ld b, BANK(Cam_DispatchEffect_Far)            ; $465B
    ld hl, Cam_DispatchEffect_Far                 ; $465D
    call Far_CallKeepA                            ; $4660
    ld de, $6e5b                                  ; $4663
    call FrameAnim_StepB                          ; $4666
    ld a, [hl+]                                   ; $4669
    call FrameCorner_DrawBottomRight              ; $466A
    jp Far_Return                                 ; $466D


; C: frame type 19 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type19::
    ld de, $6e5b                                  ; $4670
    call FrameAnim_StepB                          ; $4673
    ld a, [hl+]                                   ; $4676
    call FrameCorner_DrawBottomRight              ; $4677
    jp Far_Return                                 ; $467A


; C: frame type 20 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type20::
    ld de, $6e5b                                  ; $467D
    call FrameAnim_StepA                          ; $4680
    ld a, [hl+]                                   ; $4683
    call FrameCorner_DrawTopLeft                  ; $4684
    ld de, $6e5b                                  ; $4687
    call FrameAnim_StepB                          ; $468A
    ld a, [hl+]                                   ; $468D
    call FrameCorner_DrawTopRight                 ; $468E
    ld de, $6e5b                                  ; $4691
    call FrameAnim_StepC                          ; $4694
    ld a, [hl+]                                   ; $4697
    call FrameCorner_DrawBottomLeft               ; $4698
    ld de, $6e5b                                  ; $469B
    call FrameAnim_StepD                          ; $469E
    ld a, [hl+]                                   ; $46A1
    call FrameCorner_DrawBottomRight              ; $46A2
    jp Far_Return                                 ; $46A5


; C: frame type 21 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type21::
    ld de, $6e5b                                  ; $46A8
    call FrameAnim_StepB                          ; $46AB
    ld a, [hl+]                                   ; $46AE
    call FrameCorner_DrawTopRight                 ; $46AF
    ld de, $6e5b                                  ; $46B2
    call FrameAnim_StepC                          ; $46B5
    ld a, [hl+]                                   ; $46B8
    call FrameCorner_DrawBottomLeft               ; $46B9
    ld de, $6e5b                                  ; $46BC
    call FrameAnim_StepD                          ; $46BF
    ld a, [hl+]                                   ; $46C2
    call FrameCorner_DrawBottomRight              ; $46C3
    jp Far_Return                                 ; $46C6


; C: frame type 22 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type22::
    ld de, $6e5b                                  ; $46C9
    call FrameAnim_StepC                          ; $46CC
    ld a, [hl+]                                   ; $46CF
    call FrameCorner_DrawBottomLeft               ; $46D0
    ld de, $6e5b                                  ; $46D3
    call FrameAnim_StepD                          ; $46D6
    ld a, [hl+]                                   ; $46D9
    call FrameCorner_DrawBottomRight              ; $46DA
    jp Far_Return                                 ; $46DD


; C: frame type 23 of CameraFrame_RunType: steps one or two animation channels over a keyframe table of bank 7 and
; draws corners; some call 04:4A26 with an effect number
CameraFrame_Type23::
    ld de, $6e5b                                  ; $46E0
    call FrameAnim_StepD                          ; $46E3
    ld a, [hl+]                                   ; $46E6
    call FrameCorner_DrawBottomRight              ; $46E7
    jp Far_Return                                 ; $46EA


; C: the four corner pieces of record A (4 bytes) of 07:470B; first run in the 15 puzzle
FrameCorner_DrawSet::
    sla a                                         ; $46ED
    sla a                                         ; $46EF
    ld c, a                                       ; $46F1
    ld b, $00                                     ; $46F2
    ld hl, FrameCorner_DrawSet_Tbl470B            ; $46F4
    add hl, bc                                    ; $46F7
    ld a, [hl+]                                   ; $46F8
    call FrameCorner_DrawTopLeft                  ; $46F9
    ld a, [hl+]                                   ; $46FC
    call FrameCorner_DrawTopRight                 ; $46FD
    ld a, [hl+]                                   ; $4700
    call FrameCorner_DrawBottomLeft               ; $4701
    ld a, [hl+]                                   ; $4704
    call FrameCorner_DrawBottomRight              ; $4705
    jp Far_Return                                 ; $4708


; C: named by the code of FrameCorner_DrawSet (07:46F4); read in the runs by FrameCorner_DrawSet; first read on the
; screen Mode0F_FifteenPuzzle_State00 (trace/read_screens_kitty*.npz)
FrameCorner_DrawSet_Tbl470B::
    db $68, $69, $6a, $6b, $4c, $4d, $4e, $4f, $54, $55, $56, $57, $3c, $3d, $3e, $3f
    db $0c, $0d, $0e, $0f

; C: 07:4725 then Far_Return
Menu07_CursorCallback::
    call Menu07_CursorUpdate                      ; $471F
    jp Far_Return                                 ; $4722


; C: menu cursor object: the D-pad picks the next item from the 8-byte item records, A selects (as 02:4CFD)
Menu07_CursorUpdate::
    ld a, [wFadeRunning]                          ; $4725
    and a                                         ; $4728
    jr nz, jr_007_4751                            ; $4729

    ld a, [wKeysNewRepeat]                        ; $472B
    ld de, $0002                                  ; $472E
    bit 5, a                                      ; $4731
    jp nz, Jump_007_4771                          ; $4733

    inc e                                         ; $4736
    bit 4, a                                      ; $4737
    jp nz, Jump_007_4797                          ; $4739

    inc e                                         ; $473C
    bit 6, a                                      ; $473D
    jp nz, Jump_007_47bf                          ; $473F

    inc e                                         ; $4742
    bit 7, a                                      ; $4743
    jp nz, Jump_007_47bf                          ; $4745

    inc e                                         ; $4748
    ld a, [wKeysNew]                              ; $4749
    bit PADB_A, a                                 ; $474C
    jp nz, Jump_007_47fe                          ; $474E

jr_007_4751:
    ldh a, [hMode07_StateTable_FFD1]              ; $4751
    ld c, a                                       ; $4753
    ldh a, [hMode07_StateTable_FFD3]              ; $4754
    ld b, a                                       ; $4756
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4757
    ld l, a                                       ; $475A
    ld h, $00                                     ; $475B
    sla l                                         ; $475D
    rl h                                          ; $475F
    sla l                                         ; $4761
    rl h                                          ; $4763
    sla l                                         ; $4765
    rl h                                          ; $4767
    add hl, bc                                    ; $4769
    ld a, [hl+]                                   ; $476A
    ldh [hMode07_StateTable_FFD2], a              ; $476B
    ld a, [hl+]                                   ; $476D
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $476E
    ret                                           ; $4770


Jump_007_4771:
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4771
    and a                                         ; $4774
    ret z                                         ; $4775

    cp $02                                        ; $4776
    jr z, jr_007_478b                             ; $4778

    push af                                       ; $477A
    ld a, SFX1_MENU07_34                          ; $477B
    ld [wSndSfx1], a                              ; $477D
    pop af                                        ; $4780
    ld a, [wMenu07_CursorUpdate_D907]             ; $4781
    and a                                         ; $4784
    ret z                                         ; $4785

    dec a                                         ; $4786
    ld [wMenu07_CursorUpdate_D907], a             ; $4787
    ret                                           ; $478A


jr_007_478b:
    xor a                                         ; $478B
    ld [wMenu07_CursorUpdate_D908], a             ; $478C
    push af                                       ; $478F
    ld a, SFX1_MENU07_34                          ; $4790
    ld [wSndSfx1], a                              ; $4792
    pop af                                        ; $4795
    ret                                           ; $4796


Jump_007_4797:
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4797
    and a                                         ; $479A
    ret z                                         ; $479B

    cp $02                                        ; $479C
    jr z, jr_007_47b2                             ; $479E

    push af                                       ; $47A0
    ld a, SFX1_MENU07_34                          ; $47A1
    ld [wSndSfx1], a                              ; $47A3
    pop af                                        ; $47A6
    ld a, [wMenu07_CursorUpdate_D907]             ; $47A7
    cp $04                                        ; $47AA
    ret z                                         ; $47AC

    inc a                                         ; $47AD
    ld [wMenu07_CursorUpdate_D907], a             ; $47AE
    ret                                           ; $47B1


jr_007_47b2:
    ld a, $01                                     ; $47B2
    ld [wMenu07_CursorUpdate_D908], a             ; $47B4
    push af                                       ; $47B7
    ld a, SFX1_MENU07_34                          ; $47B8
    ld [wSndSfx1], a                              ; $47BA
    pop af                                        ; $47BD
    ret                                           ; $47BE


Jump_007_47bf:
    ldh a, [hMode07_StateTable_FFD1]              ; $47BF
    ld c, a                                       ; $47C1
    ldh a, [hMode07_StateTable_FFD3]              ; $47C2
    ld b, a                                       ; $47C4
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $47C5
    ld l, a                                       ; $47C8
    ld h, $00                                     ; $47C9
    sla l                                         ; $47CB
    rl h                                          ; $47CD
    sla l                                         ; $47CF
    rl h                                          ; $47D1
    sla l                                         ; $47D3
    rl h                                          ; $47D5
    add hl, bc                                    ; $47D7
    add hl, de                                    ; $47D8
    ld a, [hl]                                    ; $47D9
    cp $ff                                        ; $47DA
    jr z, jr_007_47fd                             ; $47DC

    ld [wMenu07_CursorUpdate_D8F4], a             ; $47DE
    ld l, a                                       ; $47E1
    ld h, $00                                     ; $47E2
    sla l                                         ; $47E4
    rl h                                          ; $47E6
    sla l                                         ; $47E8
    rl h                                          ; $47EA
    sla l                                         ; $47EC
    rl h                                          ; $47EE
    add hl, bc                                    ; $47F0
    ld a, [hl+]                                   ; $47F1
    ldh [hMode07_StateTable_FFD2], a              ; $47F2
    ld a, [hl+]                                   ; $47F4
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $47F5
    ld hl, wObjCmd_SetDC61                        ; $47F7
    call Obj_Sound                                ; $47FA

jr_007_47fd:
    ret                                           ; $47FD


Jump_007_47fe:
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $47FE
    and a                                         ; $4801
    ret nz                                        ; $4802

    ld a, $01                                     ; $4803
    ld [wMode07_StateTable_D8E0], a               ; $4805
    call Obj_ClearCallback                        ; $4808
    ld hl, wObjCmd_SetDC63                        ; $480B
    call Obj_Sound                                ; $480E
    ret                                           ; $4811


; C: read in the runs by Menu07_CursorUpdate; first read on the screen Mode12_SlideShow_State01
; (trace/read_screens_kitty*.npz)
Menu07_CursorUpdate_Tbl4812::
    db $1f, $10, $ff, $ff, $ff, $01, $00, $00, $1f, $27, $ff, $ff, $00, $02, $00, $00
    db $1f, $67, $ff, $ff, $01, $ff

    db $00

; I: leftover: 107 bytes (07:4829-4893) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_07_4829::
    db $00, $21, $09, $d9, $3e, $ff, $0e, $1e, $22, $0d, $20, $fc, $c3, $73, $01, $fa
    db $08, $d9, $a7, $20, $12, $21, $09, $d9, $fa, $32, $d9, $3c, $4f, $3e, $01, $22
    db $3c, $b9, $20, $fb, $c3, $73, $01, $21, $27, $d9, $35, $21, $09, $d9, $fa, $32
    db $d9, $47, $c5, $fa, $32, $d9, $cd, $12, $05, $3c, $4f, $c5, $e5, $cd, $79, $48
    db $e1, $c1, $38, $ef, $79, $22, $c1, $05, $20, $e8, $ea, $29, $d9, $c3, $73, $01
    db $21, $29, $d9, $be, $28, $10, $21, $09, $d9, $06, $1e, $be, $28, $06, $23, $05
    db $20, $f9, $a7, $c9, $37, $c9, $3e, $ff, $77, $37, $c9

; C: $D927 = byte [$D907] of 07:48A5; slide show settings (mode $12 state $02); runs on its screen (12:02) in the core
; replays (port/entry_modes_kitty.csv); code read
SlideShow_SetInterval::
    ld a, [wMenu07_CursorUpdate_D907]             ; $4894
    ld c, a                                       ; $4897
    ld b, $00                                     ; $4898
    ld hl, SlideShow_SetInterval_Tbl48A5          ; $489A
    add hl, bc                                    ; $489D
    ld a, [hl]                                    ; $489E
    ld [wSlideShow_SetInterval_D927], a           ; $489F
    jp Far_Return                                 ; $48A2


; C: named by the code of SlideShow_SetInterval (07:489A); read in the runs by SlideShow_SetInterval; first read on
; the screen Mode12_SlideShow_State02 (trace/read_screens_kitty*.npz)
SlideShow_SetInterval_Tbl48A5::
    db $5b, $41, $29, $15, $03

; C: handler of state $00 of mode $12 (word 0 of Mode12_StateTable)
Mode12_State00::
    di                                            ; $48AA
    call Lcd_Off                                  ; $48AB
    call Oam_ClearShadow                          ; $48AE
    ld b, BANK(Objects_ClearAll)                  ; $48B1
    ld hl, Objects_ClearAll                       ; $48B3
    call Far_Call                                 ; $48B6
    ld b, BANK(ScriptSlots_Clear)                 ; $48B9
    ld hl, ScriptSlots_Clear                      ; $48BB
    call Far_Call                                 ; $48BE
    call Serial_SetFarCallback                    ; $48C1

    dwb Frame_UpdateAll

    call Stat_SetTileToggleEAt4F                  ; $48C7
    xor a                                         ; $48CA
    ld [wMode07_StateTable_D8E0], a               ; $48CB
    ld a, [wMode12_State01_D8FB]                  ; $48CE
    ld [wMenu07_CursorUpdate_D8F4], a             ; $48D1
    call Copy_FarInline                           ; $48D4

    db $00, $40, $1d, $00, $80, $00, $16

    call Copy_FarInline                           ; $48DE

    db $00, $79, $25, $00, $98, $40, $02

    push af                                       ; $48E8
    ld a, MUSIC_SLIDE_SHOW                        ; $48E9
    ld [wSndMusicReq], a                          ; $48EB
    pop af                                        ; $48EE
    call Lcd_SetupInline                          ; $48EF

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $40, $03

    ld de, Gfx_00_1CBA_Mode12_SlideShow_State01 + $14 ; $48FD
    call Object_Create                            ; $4900
    ld de, Gfx_00_1D5C_Mode12_SlideShow_State00   ; $4903
    call Object_Create                            ; $4906
    ld de, Gfx_00_1DAB_Mode12_SlideShow_State00   ; $4909
    call Object_Create                            ; $490C
    ld de, $549f                                  ; $490F
    ld b, BANK(ScriptSlots_Add)                   ; $4912
    ld hl, ScriptSlots_Add                        ; $4914
    call Far_Call                                 ; $4917
    ei                                            ; $491A
    ld b, MODE_SLIDE_SHOW                         ; $491B
    ld c, STATE_12_SLIDE_SHOW_SETTINGS            ; $491D
    call Fade_GoTo                                ; $491F
    ret                                           ; $4922


; C: handler of state $01 of mode $12 (word 1 of Mode12_StateTable)
Mode12_State01::
    ld a, [wMode07_StateTable_D8E0]               ; $4923
    bit 0, a                                      ; $4926
    jr z, jr_007_4938                             ; $4928

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $492A
    ld [wMode12_State01_D8FB], a                  ; $492D
    ld b, MODE_SLIDE_SHOW                         ; $4930
    ld c, $02                                     ; $4932
    call Fade_GoToB                               ; $4934
    ret                                           ; $4937


jr_007_4938:
    ld a, [wKeysNew]                              ; $4938
    bit PADB_B, a                                 ; $493B
    jr z, jr_007_4954                             ; $493D

    push af                                       ; $493F
    ld a, SFX1_01                                 ; $4940
    ld [wSndSfx1], a                              ; $4942
    pop af                                        ; $4945
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $4946
    ld [wMode12_State01_D8FB], a                  ; $4949
    ld b, MODE_PLAY_MENU                          ; $494C
    ld c, $00                                     ; $494E
    call Fade_GoToB                               ; $4950
    ret                                           ; $4953


jr_007_4954:
    ret                                           ; $4954


; C: handler of state $02 of mode $12 (word 2 of Mode12_StateTable)
Mode12_State02::
    di                                            ; $4955
    call Lcd_Off                                  ; $4956
    call Oam_ClearShadow                          ; $4959
    ld b, BANK(Objects_ClearAll)                  ; $495C
    ld hl, Objects_ClearAll                       ; $495E
    call Far_Call                                 ; $4961
    ld b, BANK(ScriptSlots_Clear)                 ; $4964
    ld hl, ScriptSlots_Clear                      ; $4966
    call Far_Call                                 ; $4969
    call Serial_SetFarCallback                    ; $496C

    dwb Far_ReturnJump

    call Stat_SetTileToggleAt4F                   ; $4972
    ld a, [wAlbum_SlotOp6D18_D932]                ; $4975
    dec a                                         ; $4978
    ld [wMode12_State03_D928], a                  ; $4979
    xor a                                         ; $497C
    ld [wMode07_StateTable_D8E0], a               ; $497D
    call Copy_FarInline                           ; $4980

    db $f0, $75, $31, $00, $98, $00, $04

    push af                                       ; $498A
    ld a, MUSIC_SLIDE_SHOW_12_02                  ; $498B
    ld [wSndMusicReq], a                          ; $498D
    pop af                                        ; $4990
    call Lcd_SetupInline                          ; $4991

    db $83, $e4, $e4, $d0, $10, $10, $00, $00, $ff, $40, $03

    ei                                            ; $499F
    ld a, $01                                     ; $49A0
    ld b, BANK(Photo_FindSlotA)                   ; $49A2
    ld hl, Photo_FindSlotA                        ; $49A4
    call Far_CallKeepA                            ; $49A7
    jr c, jr_007_49bc                             ; $49AA

    ld b, BANK(Photo_LoadToBuffer)                ; $49AC
    ld hl, Photo_LoadToBuffer                     ; $49AE
    call Far_CallKeepA                            ; $49B1
    ld a, [wSlotTagBorder]                        ; $49B4
    call FrameRec_LoadDefault                     ; $49B7
    jr jr_007_49c0                                ; $49BA

jr_007_49bc:
    xor a                                         ; $49BC
    call FrameRec_LoadDefault                     ; $49BD

jr_007_49c0:
    call Mode12_State03                           ; $49C0
    ld b, MODE_SLIDE_SHOW                         ; $49C3
    ld c, STATE_12_SLIDE_SHOW_PLAYING             ; $49C5
    call Fade_GoTo                                ; $49C7
    call Serial_SetFarCallback                    ; $49CA

    dwb SlideShow_FrameCallback

    ret                                           ; $49D0


; C: 00:1AC5 then B (sound $1A) leaves; frame callback set during the fade into the slide show; runs on its screen
; (12:04) in the core replays (port/entry_modes_kitty.csv); code read
SlideShow_FrameCallback::
    ld b, $00                                     ; $49D1
    ld hl, Frame_UpdateAll                        ; $49D3
    call Far_Call                                 ; $49D6
    ld a, [wFadeRunning]                          ; $49D9
    and a                                         ; $49DC
    jr nz, jr_007_49fb                            ; $49DD

    ld a, [wKeysNew]                              ; $49DF
    bit PADB_B, a                                 ; $49E2
    jr z, jr_007_49fb                             ; $49E4

    push af                                       ; $49E6
    ld a, SFX1_1A                                 ; $49E7
    ld [wSndSfx1], a                              ; $49E9
    pop af                                        ; $49EC
    call Serial_SetFarCallback                    ; $49ED

    dwb Frame_UpdateAll

    ld a, $02                                     ; $49F3
    ld [wMode07_StateTable_D8E0], a               ; $49F5
    jp Far_Return                                 ; $49F8


jr_007_49fb:
    jp Far_Return                                 ; $49FB


; C: handler of state $03 of mode $12 (word 3 of Mode12_StateTable)
Mode12_State03::
    ld b, BANK(SlideShow_SetInterval)             ; $49FE
    ld hl, SlideShow_SetInterval                  ; $4A00
    call Far_Call                                 ; $4A03
    ld a, [wMenu07_CursorUpdate_D908]             ; $4A06
    and a                                         ; $4A09
    jr nz, jr_007_4a1c                            ; $4A0A

    ld hl, wAlbum_SlotOp6D18_D932                 ; $4A0C
    ld a, [wMode12_State03_D928]                  ; $4A0F
    inc a                                         ; $4A12
    cp [hl]                                       ; $4A13
    jr nz, jr_007_4a17                            ; $4A14

    xor a                                         ; $4A16

jr_007_4a17:
    ld [wMode12_State03_D928], a                  ; $4A17
    jr jr_007_4a2d                                ; $4A1A

jr_007_4a1c:
    ld a, [wAlbum_SlotOp6D18_D932]                ; $4A1C
    cp $01                                        ; $4A1F
    jr z, jr_007_4a2e                             ; $4A21

    call Rng_Scaled                               ; $4A23
    ld hl, wMode12_State03_D929                   ; $4A26
    cp [hl]                                       ; $4A29
    jr z, jr_007_4a1c                             ; $4A2A

    ld [hl], a                                    ; $4A2C

jr_007_4a2d:
    inc a                                         ; $4A2D

jr_007_4a2e:
    ld b, BANK(Photo_FindSlotA)                   ; $4A2E
    ld hl, Photo_FindSlotA                        ; $4A30
    call Far_CallKeepA                            ; $4A33
    jr c, jr_007_4a42                             ; $4A36

    ld b, BANK(Photo_LoadToBufferAndVram)         ; $4A38
    ld hl, Photo_LoadToBufferAndVram              ; $4A3A
    call Far_CallKeepA                            ; $4A3D
    jr jr_007_4a4c                                ; $4A40

jr_007_4a42:
    ld a, $01                                     ; $4A42
    call Photo_LoadEmptyPicture                   ; $4A44
    ld a, $00                                     ; $4A47
    call FrameRec_LoadDefault                     ; $4A49

jr_007_4a4c:
    ld a, [wMode07_StateTable_D8E0]               ; $4A4C
    bit 1, a                                      ; $4A4F
    jr z, jr_007_4a5b                             ; $4A51

    ld b, MODE_SLIDE_SHOW                         ; $4A53
    ld c, $00                                     ; $4A55
    call Fade_GoToB                               ; $4A57
    ret                                           ; $4A5A


jr_007_4a5b:
    ld a, $04                                     ; $4A5B
    ldh [hState], a                               ; $4A5D
    ret                                           ; $4A5F


; C: handler of state $04 of mode $12 (word 4 of Mode12_StateTable)
Mode12_State04::
    ld a, [wMode07_StateTable_D8E0]               ; $4A60
    bit 1, a                                      ; $4A63
    jr z, jr_007_4a6f                             ; $4A65

    ld b, MODE_SLIDE_SHOW                         ; $4A67
    ld c, $00                                     ; $4A69
    call Fade_GoToB                               ; $4A6B
    ret                                           ; $4A6E


jr_007_4a6f:
    ld hl, wSlideShow_SetInterval_D927            ; $4A6F
    dec [hl]                                      ; $4A72
    jr nz, jr_007_4a7d                            ; $4A73

    jp Mode12_State03                             ; $4A75


    db $3e, $03, $e0, $8e, $c9

jr_007_4a7d:
    ret                                           ; $4A7D


; C: ModeTable entry $12: BGB screens 12:01 (settings) and 12:04 (playing)
Mode12_SlideShow::
    ldh a, [hState]                               ; $4A7E
    ld hl, Mode12_StateTable                      ; $4A80
    call JumpTable_ByA                            ; $4A83
    jp Far_Return                                 ; $4A86


; C: state table of mode $12, read by $0189 with hFF8E
Mode12_StateTable::
    dw Mode12_State00
    dw Mode12_State01
    dw Mode12_State02
    dw Mode12_State03
    dw Mode12_State04

; C: handler of state $00 of mode $13 (word 0 of Mode13_StateTable)
Mode13_State00::
    ret                                           ; $4A93


; I: ModeTable entry $13: forced: returns to mode 01 at once (no screen of its own)
Mode13_BackToMainMenu13::
    ldh a, [hState]                               ; $4A94
    ld hl, Mode13_StateTable                      ; $4A96
    call JumpTable_ByA                            ; $4A99
    jp Far_Return                                 ; $4A9C


; C: state table of mode $13, read by $0189 with hFF8E
Mode13_StateTable::
dw Mode13_State00
dw Mode13_State00
    db $00, $6a, $39, $80, $6d, $39, $00, $71, $39, $80, $74, $39
    dwb Gfx_38_4000_Mode11_StrawberryChannel_State04
    db $80, $43, $38, $00, $47, $38, $80, $4a, $38, $00, $4e, $36, $80, $51, $36, $00
    db $55, $36, $80, $58, $36, $00, $5c, $36, $80, $5f, $36, $00, $63, $36, $80, $66
    db $36
    dwb Gfx_35_6A00_Mode11_StrawberryChannel_State07
    db $80, $6d, $35, $00, $71, $35, $80, $74, $35
    dwb Gfx_36_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $36, $00, $47, $36, $80, $4a, $36, $00, $6a, $36, $80, $6d, $36, $00
    db $71, $36, $80, $74, $36, $00, $5c, $37, $80, $5f, $37, $00, $63, $37, $80, $66
    db $37, $00, $6a, $37, $80, $6d, $37, $00, $71, $37, $80, $74, $37
    dwb Gfx_37_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $37, $00, $47, $37, $80, $4a, $37, $00, $4e, $37, $80, $51, $37, $00
    db $55, $37, $80, $58, $37, $00, $4e, $1f, $80, $51, $1f, $00, $55, $1f, $80, $58
    db $1f
    dwb Gfx_1F_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $1f, $00, $47, $1f, $80, $4a, $1f, $00, $5c, $1f, $80, $5f, $1f, $00
    db $63, $1f, $80, $66, $1f
    dwb Gfx_20_4000_IdCard_NameGlyphAddr
    db $80, $43, $20, $00, $47, $20, $80, $4a, $20, $00, $6a, $1f, $80, $6d, $1f, $00
    db $71, $1f, $80, $74, $1f, $00, $6a, $1e, $80, $6d, $1e, $00, $71, $1e, $80, $74
    db $1e, $00, $5c, $1e, $80, $5f, $1e, $00, $63, $1e, $80, $66, $1e, $00, $4e, $1e
    db $80, $51, $1e, $00, $55, $1e, $80, $58, $1e
    dwb Gfx_1E_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $1e, $00, $47, $1e, $80, $4a, $1e
    dwb Gfx_29_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $29, $00, $47, $29, $80, $4a, $29
    dwb Gfx_2A_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $2a, $00, $47, $2a, $80, $4a, $2a
    dwb Gfx_28_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $28, $00, $47, $28, $80, $4a, $28
    dwb Gfx_26_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $26, $00, $47, $26, $80, $4a, $26
    dwb Gfx_27_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $27, $00, $47, $27, $80, $4a, $27
    dwb Gfx_2B_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $2b, $00, $47, $2b, $80, $4a, $2b, $00, $4e, $2e, $80, $51, $2e, $00
    db $55, $2e, $80, $58, $2e, $00, $5c, $2e, $80, $5f, $2e, $00, $63, $2e, $80, $66
    db $2e
    dwb Gfx_2E_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $2e, $00, $47, $2e, $80, $4a, $2e
    dwb Gfx_2C_4000_Mode02_TakePhotos_State01
    db $80, $43, $2c, $00, $47, $2c, $80, $4a, $2c
    dwb Gfx_2D_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $2d, $00, $47, $2d, $80, $4a, $2d
    dwb Gfx_21_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $21, $00, $47, $21, $80, $4a, $21, $00, $4e, $21, $80, $51, $21, $00
    db $55, $21, $80, $58, $21, $00, $6a, $20, $80, $6d, $20, $00, $71, $20, $80, $74
    db $20, $00, $4e, $20, $80, $51, $20, $00, $55, $20, $80, $58, $20, $00, $5c, $20
    db $80, $5f, $20, $00, $63, $20, $80, $66, $20, $00, $5c, $21, $80, $5f, $21, $00
    db $63, $21, $80, $66, $21
    dwb Gfx_24_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $24, $00, $47, $24, $80, $4a, $24
    dwb Gfx_25_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $25, $00, $47, $25, $80, $4a, $25
    dwb Gfx_23_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $23, $00, $47, $23, $80, $4a, $23, $00, $6a, $21, $80, $6d, $21, $00
    db $71, $21, $80, $74, $21
    dwb Gfx_22_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $22, $00, $47, $22, $80, $4a, $22, $00, $5c, $24, $80, $5f, $24, $00
    db $63, $24, $80, $66, $24, $00, $5c, $27, $80, $5f, $27, $00, $63, $27, $80, $66
    db $27, $00, $4e, $25, $80, $51, $25, $00, $55, $25, $80, $58, $25, $00, $4e, $26
    db $80, $51, $26, $00, $55, $26, $80, $58, $26, $00, $5c, $28, $80, $5f, $28, $00
    db $63, $28, $80, $66, $28, $00, $5c, $29, $80, $5f, $29, $00, $63, $29, $80, $66
    db $29, $00, $4e, $24, $80, $51, $24, $00, $55, $24, $80, $58, $24, $00, $4e, $2b
    db $80, $51, $2b, $00, $55, $2b, $80, $58, $2b, $00, $4e, $2a, $80, $51, $2a, $00
    db $55, $2a, $80, $58, $2a, $00, $5c, $2b, $80, $5f, $2b, $00, $63, $2b, $80, $66
    db $2b, $00, $4e, $29, $80, $51, $29, $00, $55, $29, $80, $58, $29, $00, $4e, $27
    db $80, $51, $27, $00, $55, $27, $80, $58, $27, $00, $4e, $28, $80, $51, $28, $00
    db $55, $28, $80, $58, $28, $00, $5c, $2a, $80, $5f, $2a, $00, $63, $2a, $80, $66
    db $2a, $00, $5c, $2d, $80, $5f, $2d, $00, $63, $2d, $80, $66, $2d, $00, $6a, $3c
    db $80, $6d, $3c, $00, $71, $3c, $80, $74, $3c, $00, $5c, $3c, $80, $5f, $3c, $00
    db $63, $3c, $80, $66, $3c, $00, $4e, $3c, $80, $51, $3c, $00, $55, $3c, $80, $58
    db $3c, $00, $5c, $3d, $80, $5f, $3d, $00, $63, $3d, $80, $66, $3d, $00, $4e, $3d
    db $80, $51, $3d, $00, $55, $3d, $80, $58, $3d
    dwb Gfx_3D_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $3d, $00, $47, $3d, $80, $4a, $3d
    dwb Gfx_3C_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $3c, $00, $47, $3c, $80, $4a, $3c
    dwb Gfx_3B_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $3b, $00, $47, $3b, $80, $4a, $3b, $00, $6a, $3a, $80, $6d, $3a, $00
    db $71, $3a, $80, $74, $3a, $00, $5c, $3a, $80, $5f, $3a, $00, $63, $3a, $80, $66
    db $3a, $00, $6a, $3b, $80, $6d, $3b, $00, $71, $3b, $80, $74, $3b, $00, $5c, $3b
    db $80, $5f, $3b, $00, $63, $3b, $80, $66, $3b, $00, $4e, $3b, $80, $51, $3b, $00
    db $55, $3b, $80, $58, $3b, $00, $4e, $33, $80, $51, $33, $00, $55, $33, $80, $58
    db $33, $00, $5c, $3f, $80, $5f, $3f, $00, $63, $3f, $80, $66, $3f, $00, $4e, $2d
    db $80, $51, $2d, $00, $55, $2d, $80, $58, $2d, $00, $4e, $2f, $80, $51, $2f, $00
    db $55, $2f, $80, $58, $2f
    dwb Gfx_31_4E00_Mode11_StrawberryChannel_State07
    db $80, $51, $31, $00, $55, $31, $80, $58, $31, $00, $4e, $3f, $80, $51, $3f, $00
    db $55, $3f, $80, $58, $3f, $00, $4e, $3e, $80, $51, $3e, $00, $55, $3e, $80, $58
    db $3e
    dwb Gfx_3E_4000_Mode11_StrawberryChannel_State07
    db $80, $43, $3e, $00, $47, $3e, $80, $4a, $3e, $b7, $4b, $4b, $4b, $eb, $4a, $7b
    db $4b, $a3, $4a, $17, $4c, $97, $4d


; C: $D92D-$D92E = word [$D92A] (the channel) of 07:4E4B: the corner pieces of the channel
StrawberryCh_SetCornerTable::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $4E59
    sla a                                         ; $4E5C
    ld c, a                                       ; $4E5E
    ld b, $00                                     ; $4E5F
    ld hl, Mode13_StateTable + $3AC               ; $4E61
    add hl, bc                                    ; $4E64
    ld a, [hl+]                                   ; $4E65
    ld [wTakePhotos_ResetFrameState_D92D], a      ; $4E66
    ld a, [hl+]                                   ; $4E69
    ld [wTakePhotos_ResetFrameState_D92E], a      ; $4E6A
    jp Far_Return                                 ; $4E6D


; C: read in the runs by StrawberryCh_PageAddr, StrawberryCh_PickRandomPage; first read on the screen
; Mode11_StrawberryChannel_State04 (trace/read_screens_kitty*.npz)
StrawberryCh_PageAddr_Tbl4E70::
    db $15, $6f, $15, $6f, $15, $6f, $15, $6f, $15, $6f, $15, $6f, $15, $6f, $15, $6f
    db $7f, $6f, $7f, $6f, $7f, $6f, $7f, $6f, $7f, $6f, $7f, $6f, $7f, $6f, $7f, $6f
    db $c6, $6f, $c6, $6f, $db, $6f, $db, $6f, $db, $6f, $db, $6f, $a4, $70, $a4, $70
    db $c3, $70, $c3, $70, $c3, $70, $c3, $70, $c3, $70, $c3, $70, $c3, $70, $c3, $70
    db $e7, $70, $e7, $70, $fc, $70, $fc, $70, $e3, $71, $e3, $71, $b0, $73, $b0, $73
    db $cf, $73, $cf, $73, $cf, $73, $cf, $73, $cf, $73, $cf, $73, $cf, $73, $cf, $73
    db $79, $75, $79, $75, $79, $75, $79, $75, $79, $75, $79, $75, $79, $75, $79, $75
    dw StrawberryCh_PageAddr_Tbl4E70
    db $80, $4e, $90, $4e, $a0, $4e, $b0, $4e, $c0, $4e, $d0, $4e, $08, $08, $08, $08
    db $08, $08, $08

; C: $D92B = Rng_Scaled of byte [$D92A] of 07:4EEE: a random story page of the channel
StrawberryCh_PickRandomPage::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $4EF5
    ld c, a                                       ; $4EF8
    ld b, $00                                     ; $4EF9
    ld hl, StrawberryCh_PageAddr_Tbl4E70 + $7E    ; $4EFB
    add hl, bc                                    ; $4EFE
    ld a, [hl]                                    ; $4EFF
    call Rng_Scaled                               ; $4F00
    ld [wStrawberryCh_PickRandomPage_D92B], a     ; $4F03
    jp Far_Return                                 ; $4F06


; C: HL = word [$D92B] of the page table of channel [$D92A] (07:4EE0)
StrawberryCh_PageAddr::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $4F09
    sla a                                         ; $4F0C
    ld c, a                                       ; $4F0E
    ld b, $00                                     ; $4F0F
    ld hl, StrawberryCh_PageAddr_Tbl4E70 + $70    ; $4F11
    add hl, bc                                    ; $4F14
    ld a, [hl+]                                   ; $4F15
    ld h, [hl]                                    ; $4F16
    ld l, a                                       ; $4F17
    ld a, [wStrawberryCh_PickRandomPage_D92B]     ; $4F18
    sla a                                         ; $4F1B
    ld c, a                                       ; $4F1D
    ld b, $00                                     ; $4F1E
    add hl, bc                                    ; $4F20
    ld e, [hl]                                    ; $4F21
    inc hl                                        ; $4F22
    ld d, [hl]                                    ; $4F23
    call FrameAnim_StepA                          ; $4F24
    ld a, [hl+]                                   ; $4F27
    call FrameCorner_DrawTopLeft                  ; $4F28
    ld a, [hl+]                                   ; $4F2B
    call FrameCorner_DrawTopRight                 ; $4F2C
    ld a, [hl+]                                   ; $4F2F
    call FrameCorner_DrawBottomLeft               ; $4F30
    ld a, [hl+]                                   ; $4F33
    call FrameCorner_DrawBottomRight              ; $4F34
    jp Far_Return                                 ; $4F37


; C: named by the code of StrawberryCh_CheckAfford (07:4F50); read in the runs by StrawberryCh_CheckAfford; first read
; on the screen Mode11_StrawberryChannel_State04 (trace/read_screens_kitty*.npz)
StrawberryCh_CheckAfford_Tbl4F3A::
    db $50, $00, $00, $08, $00, $01, $00, $04, $00, $02, $00, $20, $00, $00

; C: Kitts_CheckAfford with the price of channel [$D92A] (word of 07:4F3A)
StrawberryCh_CheckAfford::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $4F48
    sla a                                         ; $4F4B
    ld c, a                                       ; $4F4D
    ld b, $00                                     ; $4F4E
    ld hl, StrawberryCh_CheckAfford_Tbl4F3A       ; $4F50
    add hl, bc                                    ; $4F53
    ld e, [hl]                                    ; $4F54
    inc hl                                        ; $4F55
    ld d, [hl]                                    ; $4F56
    ld b, BANK(Kitts_CheckAfford)                 ; $4F57
    ld hl, Kitts_CheckAfford                      ; $4F59
    call Far_Call                                 ; $4F5C
    jp Far_ReturnSramBank                         ; $4F5F


; C: handler of state $00 of mode $11 (word 0 of Mode11_StateTable)
Mode11_State00::
    di                                            ; $4F62
    call Lcd_Off                                  ; $4F63
    call Oam_ClearShadow                          ; $4F66
    ld b, BANK(Objects_ClearAll)                  ; $4F69
    ld hl, Objects_ClearAll                       ; $4F6B
    call Far_Call                                 ; $4F6E
    ld b, BANK(ScriptSlots_Clear)                 ; $4F71
    ld hl, ScriptSlots_Clear                      ; $4F73
    call Far_Call                                 ; $4F76
    call Serial_SetFarCallback                    ; $4F79

    dwb Frame_UpdateAll

    xor a                                         ; $4F7F
    ld [wMode07_StateTable_D8E0], a               ; $4F80
    ld [wStrawberryCh_PickRandomPage_D92B], a     ; $4F83
    ld [wStrawberryCh_DotTick_D92C], a            ; $4F86
    ld b, BANK(Counters_Load)                     ; $4F89
    ld hl, Counters_Load                          ; $4F8B
    call Far_Call                                 ; $4F8E
    ld b, MODE_STRAWBERRY_CHANNEL                 ; $4F91
    ld c, $0b                                     ; $4F93
    call Mode_SaveReturnD8F2                      ; $4F95
    call Stat_SetTileToggleAt4F                   ; $4F98
    call Copy_FarInline                           ; $4F9B

    db $00, $5c, $25, $00, $86, $00, $0a

    ld de, wMode11_State00_DFDF                   ; $4FA5
    ld hl, $9800                                  ; $4FA8
    ld bc, $0400                                  ; $4FAB
    call Mem_FillWord                             ; $4FAE
    push af                                       ; $4FB1
    ld a, MUSIC_STOP                              ; $4FB2
    ld [wSndMusicReq], a                          ; $4FB4
    pop af                                        ; $4FB7
    call Lcd_SetupInline                          ; $4FB8

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    ld a, $29                                     ; $4FC6
    call FrameRec_LoadDefault                     ; $4FC8
    ld de, Gfx_25_63F0_Mode11_StrawberryChannel_State00 ; $4FCB
    ld hl, $8df0                                  ; $4FCE
    ld bc, $0210                                  ; $4FD1
    ld a, $25                                     ; $4FD4
    call Vram_CopyHBlankFar                       ; $4FD6
    ld b, BANK(Kitts_DrawAt8F20)                  ; $4FD9
    ld hl, Kitts_DrawAt8F20                       ; $4FDB
    call Far_Call                                 ; $4FDE
    ld de, ObjScript_02_4F99_Album_CursorUpdate + $39 ; $4FE1
    call Object_Create                            ; $4FE4
    ld de, ObjScript_02_5016_Mode11_StrawberryChannel_State00 ; $4FE7
    call Object_Create                            ; $4FEA
    ld a, $ff                                     ; $4FED
    ld [wFrameAnim_StepA_D8FF], a                 ; $4FEF
    ld a, $01                                     ; $4FF2
    ld [wFrameAnim_StepA_D903], a                 ; $4FF4
    ld b, BANK(StrawberryCh_PickRandomPage)       ; $4FF7
    ld hl, StrawberryCh_PickRandomPage            ; $4FF9
    call Far_Call                                 ; $4FFC
    ld b, BANK(StrawberryCh_SetCornerTable)       ; $4FFF
    ld hl, StrawberryCh_SetCornerTable            ; $5001
    call Far_Call                                 ; $5004
    call Mode11_State07                           ; $5007
    ei                                            ; $500A
    ld b, MODE_STRAWBERRY_CHANNEL                 ; $500B
    ld c, $01                                     ; $500D
    call Fade_GoTo                                ; $500F
    ret                                           ; $5012


; C: handler of state $01 of mode $11 (word 1 of Mode11_StateTable)
Mode11_State01::
    ld a, [wFadeRunning]                          ; $5013
    and a                                         ; $5016
    ret nz                                        ; $5017

    di                                            ; $5018
    ld a, $ff                                     ; $5019
    ld [wMode07_StateTable_D8E0], a               ; $501B
    ld b, BANK(StrawberryCh_CheckAfford)          ; $501E
    ld hl, StrawberryCh_CheckAfford               ; $5020
    call Far_Call                                 ; $5023
    jr c, jr_007_503f                             ; $5026

    call Serial_SetFarCallback                    ; $5028

    dwb StrawberryCh_FrameCallbackA

    ld de, $53be                                  ; $502E
    ld b, BANK(ScriptSlots_Add)                   ; $5031
    ld hl, ScriptSlots_Add                        ; $5033
    call Far_Call                                 ; $5036
    ei                                            ; $5039
    ld a, $02                                     ; $503A
    ldh [hState], a                               ; $503C
    ret                                           ; $503E


jr_007_503f:
    call Serial_SetFarCallback                    ; $503F

    dwb StrawberryCh_LockedCallback

    ld de, $5338                                  ; $5045
    ld b, BANK(ScriptSlots_Add)                   ; $5048
    ld hl, ScriptSlots_Add                        ; $504A
    call Far_Call                                 ; $504D
    ei                                            ; $5050
    ld a, $03                                     ; $5051
    ldh [hState], a                               ; $5053
    ret                                           ; $5055


; C: handler of state $02 of mode $11 (word 2 of Mode11_StateTable)
Mode11_State02::
    ld a, [wMode07_StateTable_D8E0]               ; $5056
    and a                                         ; $5059
    ret nz                                        ; $505A

    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $1D ; $505B
    call Object_Create                            ; $505E
    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $32 ; $5061
    call Object_Create                            ; $5064
    ld b, BANK(StrawberryCh_StartMusic)           ; $5067
    ld hl, StrawberryCh_StartMusic                ; $5069
    call Far_Call                                 ; $506C
    ld a, $07                                     ; $506F
    ldh [hState], a                               ; $5071
    ret                                           ; $5073


; C: handler of state $03 of mode $11 (word 3 of Mode11_StateTable)
Mode11_State03::
    ld a, [wMode07_StateTable_D8E0]               ; $5074
    and a                                         ; $5077
    ret nz                                        ; $5078

    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $1D ; $5079
    call Object_Create                            ; $507C
    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $32 ; $507F
    call Object_Create                            ; $5082
    push af                                       ; $5085
    ld a, MUSIC_STRAWBERRY_CHANNEL                ; $5086
    ld [wSndMusicReq], a                          ; $5088
    pop af                                        ; $508B
    ld a, $08                                     ; $508C
    ldh [hState], a                               ; $508E
    ret                                           ; $5090


; C: jump table by channel [$D92A] to the 7 sound requests below
StrawberryCh_StartMusic::
    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $5091
    call JumpTable_Inline                         ; $5094

; C: read in the runs by JumpTable_Inline; first read on the screen Mode11_StrawberryChannel_State04
; (trace/read_screens_kitty*.npz)
StrawberryCh_StartMusic_JumpTbl5097::
    dw StrawberryCh_Music0
    dw StrawberryCh_Music1
    dw StrawberryCh_Music2
    dw StrawberryCh_Music3
    dw StrawberryCh_Music4
    dw StrawberryCh_Music5
    dw StrawberryCh_Music6

; C: channel 0: sound $0C into the request $D068
StrawberryCh_Music0::
    push af                                       ; $50A5
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_0         ; $50A6
    ld [wSndMusicReq], a                          ; $50A8
    pop af                                        ; $50AB
    jp Far_Return                                 ; $50AC


; C: channel 1: sound $0A into the request $D068
StrawberryCh_Music1::
    push af                                       ; $50AF
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_1         ; $50B0
    ld [wSndMusicReq], a                          ; $50B2
    pop af                                        ; $50B5
    jp Far_Return                                 ; $50B6


; C: channel 2: sound $09 into the request $D068
StrawberryCh_Music2::
    push af                                       ; $50B9
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_2         ; $50BA
    ld [wSndMusicReq], a                          ; $50BC
    pop af                                        ; $50BF
    jp Far_Return                                 ; $50C0


; C: channel 3: sound $0B into the request $D068
StrawberryCh_Music3::
    push af                                       ; $50C3
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_3         ; $50C4
    ld [wSndMusicReq], a                          ; $50C6
    pop af                                        ; $50C9
    jp Far_Return                                 ; $50CA


; C: channel 4: sound $08 into the request $D068
StrawberryCh_Music4::
    push af                                       ; $50CD
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_4         ; $50CE
    ld [wSndMusicReq], a                          ; $50D0
    pop af                                        ; $50D3
    jp Far_Return                                 ; $50D4


; C: channel 5: sound $22 into the request $D068
StrawberryCh_Music5::
    push af                                       ; $50D7
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_5         ; $50D8
    ld [wSndMusicReq], a                          ; $50DA
    pop af                                        ; $50DD
    jp Far_Return                                 ; $50DE


; C: channel 6: sound $0F into the request $D068
StrawberryCh_Music6::
    push af                                       ; $50E1
    ld a, MUSIC_STRAWBERRY_CHANNEL_TUNE_6         ; $50E2
    ld [wSndMusicReq], a                          ; $50E4
    pop af                                        ; $50E7
    jp Far_Return                                 ; $50E8


; C: handler of state $05 of mode $11 (word 5 of Mode11_StateTable)
Mode11_State05::
    xor a                                         ; $50EB
    ld [wStrawberryCh_DotTick_D92C], a            ; $50EC
    ld de, Gfx_25_5C00_Mode11_StrawberryChannel_State00 ; $50EF
    ld hl, $8600                                  ; $50F2
    ld bc, $0400                                  ; $50F5
    ld a, $25                                     ; $50F8
    call Vram_CopyHBlankFar                       ; $50FA
    rst Rst08_WaitVBlank                          ; $50FD
    call Serial_SetFarCallback                    ; $50FE

    dwb StrawberryCh_FrameCallbackA

    ld a, $07                                     ; $5104
    ldh [hState], a                               ; $5106
    ret                                           ; $5108


; C: handler of state $04 of mode $11 (word 4 of Mode11_StateTable)
Mode11_State04::
    ld a, $ff                                     ; $5109
    ld [wMode07_StateTable_D8E0], a               ; $510B
    ld a, $ff                                     ; $510E
    ld [wFrameAnim_StepA_D8FF], a                 ; $5110
    ld a, $01                                     ; $5113
    ld [wFrameAnim_StepA_D903], a                 ; $5115
    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $1D ; $5118
    call Object_Create                            ; $511B
    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $32 ; $511E
    call Object_Create                            ; $5121
    ld b, BANK(StrawberryCh_PickRandomPage)       ; $5124
    ld hl, StrawberryCh_PickRandomPage            ; $5126
    call Far_Call                                 ; $5129
    ld b, BANK(StrawberryCh_SetCornerTable)       ; $512C
    ld hl, StrawberryCh_SetCornerTable            ; $512E
    call Far_Call                                 ; $5131
    ld b, BANK(StrawberryCh_CheckAfford)          ; $5134
    ld hl, StrawberryCh_CheckAfford               ; $5136
    call Far_Call                                 ; $5139
    jr c, jr_007_515f                             ; $513C

    ld b, BANK(StrawberryCh_StartMusic)           ; $513E
    ld hl, StrawberryCh_StartMusic                ; $5140
    call Far_Call                                 ; $5143
    call Mode11_State07                           ; $5146
    call Serial_SetFarCallback                    ; $5149

    dwb StrawberryCh_FrameCallbackA

    ld de, $52b2                                  ; $514F
    ld b, BANK(ScriptSlots_Add)                   ; $5152
    ld hl, ScriptSlots_Add                        ; $5154
    call Far_Call                                 ; $5157
    ld a, $07                                     ; $515A
    ldh [hState], a                               ; $515C
    ret                                           ; $515E


jr_007_515f:
    push af                                       ; $515F
    ld a, MUSIC_STRAWBERRY_CHANNEL                ; $5160
    ld [wSndMusicReq], a                          ; $5162
    pop af                                        ; $5165
    call Serial_SetFarCallback                    ; $5166

    dwb StrawberryCh_LockedCallback

    ld de, $527c                                  ; $516C
    ld b, BANK(ScriptSlots_Add)                   ; $516F
    ld hl, ScriptSlots_Add                        ; $5171
    call Far_Call                                 ; $5174
    ld a, $08                                     ; $5177
    ldh [hState], a                               ; $5179
    ret                                           ; $517B


; C: handler of state $07 of mode $11 (word 7 of Mode11_StateTable)
Mode11_State07::
    ld b, BANK(StrawberryCh_PageAddr)             ; $517C
    ld hl, StrawberryCh_PageAddr                  ; $517E
    call Far_Call                                 ; $5181
    ld de, $c000                                  ; $5184
    ld hl, $9000                                  ; $5187
    ld bc, $0800                                  ; $518A
    call Vram_CopyHBlank                          ; $518D
    ld de, $c800                                  ; $5190
    ld hl, $8000                                  ; $5193
    ld bc, $0600                                  ; $5196
    call Vram_CopyHBlank                          ; $5199

; C: handler of state $08 of mode $11 (word 8 of Mode11_StateTable)
Mode11_State08::
    ret                                           ; $519C


; C: handler of state $0B of mode $11 (word 11 of Mode11_StateTable)
Mode11_State0B::
    di                                            ; $519D
    call Lcd_Off                                  ; $519E
    call Oam_ClearShadow                          ; $51A1
    ld b, BANK(Objects_ClearAll)                  ; $51A4
    ld hl, Objects_ClearAll                       ; $51A6
    call Far_Call                                 ; $51A9
    ld b, BANK(ScriptSlots_Clear)                 ; $51AC
    ld hl, ScriptSlots_Clear                      ; $51AE
    call Far_Call                                 ; $51B1
    ld de, wMode0B_State04_D400                   ; $51B4
    ld hl, $c000                                  ; $51B7
    ld bc, $0200                                  ; $51BA
    call Copy_DEtoHL                              ; $51BD
    ld de, $ce00                                  ; $51C0
    ld hl, $c200                                  ; $51C3
    ld bc, $0200                                  ; $51C6
    call Copy_DEtoHL                              ; $51C9
    jr jr_007_51e5                                ; $51CC

; C: handler of state $0A of mode $11 (word 10 of Mode11_StateTable)
Mode11_State0A::
    di                                            ; $51CE
    call Lcd_Off                                  ; $51CF
    call Oam_ClearShadow                          ; $51D2
    ld b, BANK(Objects_ClearAll)                  ; $51D5
    ld hl, Objects_ClearAll                       ; $51D7
    call Far_Call                                 ; $51DA
    ld b, BANK(ScriptSlots_Clear)                 ; $51DD
    ld hl, ScriptSlots_Clear                      ; $51DF
    call Far_Call                                 ; $51E2

jr_007_51e5:
    ld a, $ff                                     ; $51E5
    ld [wStrawberryCh_DotTick_D92C], a            ; $51E7
    call Copy_FarInline                           ; $51EA

    db $00, $5c, $25, $00, $86, $00, $0a

    call Copy_FarInline                           ; $51F4

    db $f0, $75, $31, $00, $98, $40, $02

    call Serial_SetFarCallback                    ; $51FE

    dwb Frame_UpdateAll

    call Stat_SetTileToggleAt4F                   ; $5204
    call Lcd_SetupInline                          ; $5207

    db $83, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    ld de, $c000                                  ; $5215
    ld hl, $9000                                  ; $5218
    ld bc, $0800                                  ; $521B
    call Vram_CopyHBlank                          ; $521E
    ld de, $c800                                  ; $5221
    ld hl, $8000                                  ; $5224
    ld bc, $0600                                  ; $5227
    call Vram_CopyHBlank                          ; $522A
    ld a, $00                                     ; $522D
    ld b, BANK(KeyPrompt_LoadSounds)              ; $522F
    ld hl, KeyPrompt_LoadSounds                   ; $5231
    call Far_CallKeepA                            ; $5234
    ld a, $29                                     ; $5237
    call FrameRec_LoadDefault                     ; $5239
    ld de, ObjScript_02_4F99_Album_CursorUpdate + $39 ; $523C
    call Object_Create                            ; $523F
    ld de, ObjScript_02_5016_Mode11_StrawberryChannel_State00 ; $5242
    call Object_Create                            ; $5245
    ld de, $52b2                                  ; $5248
    ld b, BANK(ScriptSlots_Add)                   ; $524B
    ld hl, ScriptSlots_Add                        ; $524D
    call Far_Call                                 ; $5250
    ld hl, wLcdcShadow                            ; $5253
    set 2, [hl]                                   ; $5256
    ld de, Gfx_25_63F0_Mode11_StrawberryChannel_State00 ; $5258
    ld hl, $8df0                                  ; $525B
    ld bc, $0210                                  ; $525E
    ld a, $25                                     ; $5261
    call Vram_CopyHBlankFar                       ; $5263
    ld b, BANK(Kitts_DrawAt8F20)                  ; $5266
    ld hl, Kitts_DrawAt8F20                       ; $5268
    call Far_Call                                 ; $526B
    ei                                            ; $526E
    ld b, BANK(StrawberryCh_CheckAfford)          ; $526F
    ld hl, StrawberryCh_CheckAfford               ; $5271
    call Far_Call                                 ; $5274
    jr c, jr_007_5283                             ; $5277

    ld b, BANK(StrawberryCh_StartMusic)           ; $5279
    ld hl, StrawberryCh_StartMusic                ; $527B
    call Far_Call                                 ; $527E
    jr jr_007_528a                                ; $5281

jr_007_5283:
    push af                                       ; $5283
    ld a, MUSIC_STRAWBERRY_CHANNEL                ; $5284
    ld [wSndMusicReq], a                          ; $5286
    pop af                                        ; $5289

jr_007_528a:
    ld b, MODE_STRAWBERRY_CHANNEL                 ; $528A
    ld c, STATE_11_STRAWBERRY_CHANNEL_PICTURE_PAUSED ; $528C
    call Fade_GoTo                                ; $528E
    ret                                           ; $5291


; C: handler of state $09 of mode $11 (word 9 of Mode11_StateTable)
Mode11_State09::
    rst Rst08_WaitVBlank                          ; $5292
    ld hl, wLcdcShadow                            ; $5293
    set 2, [hl]                                   ; $5296
    xor a                                         ; $5298
    ld [wKeysNew], a                              ; $5299
    ld a, $00                                     ; $529C
    ld b, BANK(KeyPrompt_LoadSounds)              ; $529E
    ld hl, KeyPrompt_LoadSounds                   ; $52A0
    call Far_CallKeepA                            ; $52A3
    ld a, $0c                                     ; $52A6
    ldh [hState], a                               ; $52A8
    ret                                           ; $52AA


; C: handler of state $0C of mode $11 (word 12 of Mode11_StateTable)
Mode11_State0C::
    ld a, [wMode06_State0A_D8DF]                  ; $52AB
    bit 0, a                                      ; $52AE
    jp z, Jump_007_5309                           ; $52B0

    ld a, [wAlbum_SlotOp6D18_D932]                ; $52B3
    cp $1e                                        ; $52B6
    jr nz, jr_007_52c2                            ; $52B8

    ld b, MODE_STRAWBERRY_CHANNEL                 ; $52BA
    ld c, $0d                                     ; $52BC
    call Fade_GoToB                               ; $52BE
    ret                                           ; $52C1


jr_007_52c2:
    push hl                                       ; $52C2
    ld hl, wMode06_State0A_D896                   ; $52C3
    set 0, [hl]                                   ; $52C6
    pop hl                                        ; $52C8
    ld b, BANK(Sram_LoadIdCard)                   ; $52C9
    ld hl, Sram_LoadIdCard                        ; $52CB
    call Far_Call                                 ; $52CE
    call Copy_Inline                              ; $52D1

    db $db, $da, $52, $da, $12, $00

    call Mem_ZeroInline                           ; $52DA

    db $64, $da, $22, $00

    xor a                                         ; $52E1
    ld [wSlotTagBorder], a                        ; $52E2
    ld b, BANK(TakePhotos_StorePhoto)             ; $52E5
    ld hl, TakePhotos_StorePhoto                  ; $52E7
    call Far_Call                                 ; $52EA
    ld b, BANK(Counters_AddTaken)                 ; $52ED
    ld hl, Counters_AddTaken                      ; $52EF
    call Far_Call                                 ; $52F2
    ld de, $0001                                  ; $52F5
    ld b, BANK(Kitts_Add)                         ; $52F8
    ld hl, Kitts_Add                              ; $52FA
    call Far_Call                                 ; $52FD
    push hl                                       ; $5300
    ld hl, wMode06_State0A_D896                   ; $5301
    res 0, [hl]                                   ; $5304
    pop hl                                        ; $5306
    jr jr_007_5310                                ; $5307

Jump_007_5309:
    ld a, [wMode06_State0A_D8DF]                  ; $5309
    bit 1, a                                      ; $530C
    jr z, jr_007_531a                             ; $530E

jr_007_5310:
    ld hl, wLcdcShadow                            ; $5310
    res 2, [hl]                                   ; $5313
    ld a, $05                                     ; $5315
    ldh [hState], a                               ; $5317
    ret                                           ; $5319


jr_007_531a:
    ld a, [wMode06_State0A_D8DF]                  ; $531A
    bit 3, a                                      ; $531D
    jr z, jr_007_5348                             ; $531F

    ld de, $c000                                  ; $5321
    ld hl, wMode0B_State04_D400                   ; $5324
    ld bc, $0200                                  ; $5327
    call Copy_DEtoHL                              ; $532A
    ld de, $c200                                  ; $532D
    ld hl, $ce00                                  ; $5330
    ld bc, $0200                                  ; $5333
    call Copy_DEtoHL                              ; $5336
    ld b, MODE_STRAWBERRY_CHANNEL                 ; $5339
    ld c, $0b                                     ; $533B
    call Mode_SaveReturnD93D                      ; $533D
    ld b, MODE_PRINTING                           ; $5340
    ld c, $14                                     ; $5342
    call Fade_GoToB                               ; $5344
    ret                                           ; $5347


jr_007_5348:
    ret                                           ; $5348


; C: handler of state $0D of mode $11 (word 13 of Mode11_StateTable)
Mode11_State0D::
    di                                            ; $5349
    call Lcd_Off                                  ; $534A
    call Oam_ClearShadow                          ; $534D
    ld b, BANK(Objects_ClearAll)                  ; $5350
    ld hl, Objects_ClearAll                       ; $5352
    call Far_Call                                 ; $5355
    ld b, BANK(ScriptSlots_Clear)                 ; $5358
    ld hl, ScriptSlots_Clear                      ; $535A
    call Far_Call                                 ; $535D
    call Stat_SetTileToggleAt4F                   ; $5360
    call Serial_SetFarCallback                    ; $5363

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $5369

    db $87, $e4, $d0, $e4, $10, $10, $00, $00, $ff, $40, $03

    push af                                       ; $5377
    ld a, MUSIC_TAKE_PHOTOS_02_0D                 ; $5378
    ld [wSndMusicReq], a                          ; $537A
    pop af                                        ; $537D
    ld a, $01                                     ; $537E
    ld b, BANK(Photo_FindSlotA)                   ; $5380
    ld hl, Photo_FindSlotA                        ; $5382
    call Far_CallKeepA                            ; $5385
    ld b, BANK(Photo_LoadToVram)                  ; $5388
    ld hl, Photo_LoadToVram                       ; $538A
    call Far_CallKeepA                            ; $538D
    ld a, $24                                     ; $5390
    call FrameRec_LoadDefault                     ; $5392
    ld a, $01                                     ; $5395
    ld b, BANK(KeyPrompt_LoadSounds)              ; $5397
    ld hl, KeyPrompt_LoadSounds                   ; $5399
    call Far_CallKeepA                            ; $539C
    ld b, MODE_STRAWBERRY_CHANNEL                 ; $539F
    ld c, $0e                                     ; $53A1
    call Fade_GoTo                                ; $53A3
    ei                                            ; $53A6
    ret                                           ; $53A7


; C: handler of state $0E of mode $11 (word 14 of Mode11_StateTable)
Mode11_State0E::
    ld a, [wMode06_State0A_D8DF]                  ; $53A8
    bit 0, a                                      ; $53AB
    jr z, jr_007_53f9                             ; $53AD

    push hl                                       ; $53AF
    ld hl, wMode06_State0A_D896                   ; $53B0
    set 0, [hl]                                   ; $53B3
    pop hl                                        ; $53B5
    ld a, $01                                     ; $53B6
    ld b, BANK(Photo_FindSlotA)                   ; $53B8
    ld hl, Photo_FindSlotA                        ; $53BA
    call Far_CallKeepA                            ; $53BD
    jr c, jr_007_53e4                             ; $53C0

    push af                                       ; $53C2
    ld b, BANK(Photo_RemoveFromVector)            ; $53C3
    ld hl, Photo_RemoveFromVector                 ; $53C5
    call Far_CallKeepA                            ; $53C8
    ld b, BANK(Sram_StoreVector)                  ; $53CB
    ld hl, Sram_StoreVector                       ; $53CD
    call Far_Call                                 ; $53D0
    pop af                                        ; $53D3
    ld b, BANK(Sram_WritePhotoInfo)               ; $53D4
    ld hl, Sram_WritePhotoInfo                    ; $53D6
    call Far_CallKeepA                            ; $53D9
    ld b, BANK(Counters_AddErased)                ; $53DC
    ld hl, Counters_AddErased                     ; $53DE
    call Far_Call                                 ; $53E1

jr_007_53e4:
    push hl                                       ; $53E4
    ld hl, wMode06_State0A_D896                   ; $53E5
    res 0, [hl]                                   ; $53E8
    pop hl                                        ; $53EA
    call Serial_SetFarCallback                    ; $53EB

    dwb Frame_UpdateAll

    ld b, MODE_STRAWBERRY_CHANNEL                 ; $53F1
    ld c, $0a                                     ; $53F3
    call Fade_GoToB                               ; $53F5
    ret                                           ; $53F8


jr_007_53f9:
    ld a, [wMode06_State0A_D8DF]                  ; $53F9
    bit 1, a                                      ; $53FC
    jr z, jr_007_5413                             ; $53FE

    ld hl, wLcdcShadow                            ; $5400
    res 2, [hl]                                   ; $5403
    call Serial_SetFarCallback                    ; $5405

    dwb Frame_UpdateAll

    ld b, MODE_STRAWBERRY_CHANNEL                 ; $540B
    ld c, $0a                                     ; $540D
    call Fade_GoToB                               ; $540F
    ret                                           ; $5412


jr_007_5413:
    ret                                           ; $5413


; C: ModeTable entry $11: BGB screens 11:07 (photo story) and 11:0C (paused: print / keep / cancel)
Mode11_StrawberryChannel::
    ldh a, [hState]                               ; $5414
    ld hl, Mode11_StateTable                      ; $5416
    call JumpTable_ByA                            ; $5419
    jp Far_Return                                 ; $541C


; C: state table of mode $11, read by $0189 with hFF8E
Mode11_StateTable::
    dw Mode11_State00
    dw Mode11_State01
    dw Mode11_State02
    dw Mode11_State03
    dw Mode11_State04
    dw Mode11_State05
    dw Mode11_State01
    dw Mode11_State07
    dw Mode11_State08
    dw Mode11_State09
    dw Mode11_State0A
    dw Mode11_State0B
    dw Mode11_State0C
    dw Mode11_State0D
    dw Mode11_State0E

; C: 00:1AC5, then the keys unless $D8E0 or $D8D4 is set (A, ...); mode $11 state $02; runs on its screen (11:02) in
; the core replays (port/entry_modes_kitty.csv); code read
StrawberryCh_FrameCallbackA::
    ld b, $00                                     ; $543D
    ld hl, Frame_UpdateAll                        ; $543F
    call Far_Call                                 ; $5442
    ld a, [wMode07_StateTable_D8E0]               ; $5445
    and a                                         ; $5448
    jp nz, Jump_007_5566                          ; $5449

    ld a, [wFadeRunning]                          ; $544C
    and a                                         ; $544F
    jp nz, Jump_007_5566                          ; $5450

    ld a, [wKeysNew]                              ; $5453
    bit PADB_A, a                                 ; $5456
    jp z, Jump_007_5474                           ; $5458

    push af                                       ; $545B
    ld a, SFX1_38                                 ; $545C
    ld [wSndSfx1], a                              ; $545E
    pop af                                        ; $5461
    ld a, $ff                                     ; $5462
    ld [wStrawberryCh_DotTick_D92C], a            ; $5464
    call Serial_SetFarCallback                    ; $5467

    dwb Frame_UpdateAll

    ld a, $09                                     ; $546D
    ldh [hState], a                               ; $546F
    jp Far_Return                                 ; $5471


Jump_007_5474:
    jp Jump_007_54f9                              ; $5474


; C: frame callback of a channel the Kitts do not pay for (StrawberryCh_CheckAfford sets carry; mode $11 states $03 /
; $08): A shows the notice (StrawberryCh_LockedNoticeCallback); BGB 2026-11-08 with 0 Kitts: the snow screen
StrawberryCh_LockedCallback::
    ld b, $00                                     ; $5477
    ld hl, Frame_UpdateAll                        ; $5479
    call Far_Call                                 ; $547C
    ld a, [wMode07_StateTable_D8E0]               ; $547F
    and a                                         ; $5482
    jp nz, Jump_007_5566                          ; $5483

    ld a, [wFadeRunning]                          ; $5486
    and a                                         ; $5489
    jp nz, Jump_007_5566                          ; $548A

    ld a, [wKeysNew]                              ; $548D
    bit PADB_A, a                                 ; $5490
    jp z, Jump_007_54b5                           ; $5492

    push af                                       ; $5495
    ld a, SFX1_0E                                 ; $5496
    ld [wSndSfx1], a                              ; $5498
    pop af                                        ; $549B
    ld a, $ff                                     ; $549C
    ld [wMode07_StateTable_D8E0], a               ; $549E
    ld de, $5430                                  ; $54A1
    ld b, BANK(ScriptSlots_Add)                   ; $54A4
    ld hl, ScriptSlots_Add                        ; $54A6
    call Far_Call                                 ; $54A9
    call Serial_SetFarCallback                    ; $54AC

    dwb StrawberryCh_LockedNoticeCallback

    jp Far_Return                                 ; $54B2


Jump_007_54b5:
    jp Jump_007_54f9                              ; $54B5


; C: frame callback while the notice is shown ("this channel can be watched with 50 Kitts"): a key goes back to
; StrawberryCh_LockedCallback; BGB 2026-11-08 with 0 Kitts
StrawberryCh_LockedNoticeCallback::
    ld b, $00                                     ; $54B8
    ld hl, Frame_UpdateAll                        ; $54BA
    call Far_Call                                 ; $54BD
    ld a, [wMode07_StateTable_D8E0]               ; $54C0
    and a                                         ; $54C3
    jp nz, Jump_007_5566                          ; $54C4

    ld a, [wFadeRunning]                          ; $54C7
    and a                                         ; $54CA
    jp nz, Jump_007_5566                          ; $54CB

    ld a, [wKeysNew]                              ; $54CE
    bit PADB_B, a                                 ; $54D1
    jp z, Jump_007_54f6                           ; $54D3

    push af                                       ; $54D6
    ld a, SFX1_0F                                 ; $54D7
    ld [wSndSfx1], a                              ; $54D9
    pop af                                        ; $54DC
    ld a, $ff                                     ; $54DD
    ld [wMode07_StateTable_D8E0], a               ; $54DF
    ld de, $527c                                  ; $54E2
    ld b, BANK(ScriptSlots_Add)                   ; $54E5
    ld hl, ScriptSlots_Add                        ; $54E7
    call Far_Call                                 ; $54EA
    call Serial_SetFarCallback                    ; $54ED

    dwb StrawberryCh_LockedCallback

    jp Far_Return                                 ; $54F3


Jump_007_54f6:
    jp Jump_007_54f9                              ; $54F6


Jump_007_54f9:
    ld a, [wKeysNew]                              ; $54F9
    bit PADB_B, a                                 ; $54FC
    jr z, jr_007_5517                             ; $54FE

    push af                                       ; $5500
    ld a, SFX1_01                                 ; $5501
    ld [wSndSfx1], a                              ; $5503
    pop af                                        ; $5506
    call Serial_SetFarCallback                    ; $5507

    dwb Frame_UpdateAll

    ld b, MODE_PLAY_MENU                          ; $550D
    ld c, $00                                     ; $550F
    call Fade_GoToB                               ; $5511
    jp Far_Return                                 ; $5514


jr_007_5517:
    ld a, [wKeysNew]                              ; $5517
    bit PADB_LEFT, a                              ; $551A
    jr z, jr_007_553f                             ; $551C

    push af                                       ; $551E
    ld a, SFX1_03                                 ; $551F
    ld [wSndSfx1], a                              ; $5521
    pop af                                        ; $5524
    call Serial_SetFarCallback                    ; $5525

    dwb Frame_UpdateAll

    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $552B
    dec a                                         ; $552E
    cp $ff                                        ; $552F
    jr nz, jr_007_5535                            ; $5531

    ld a, $06                                     ; $5533

jr_007_5535:
    ld [wStrawberryCh_LockedNoticeCallback_D92A], a ; $5535
    ld a, $04                                     ; $5538
    ldh [hState], a                               ; $553A
    jp Far_Return                                 ; $553C


jr_007_553f:
    ld a, [wKeysNew]                              ; $553F
    bit PADB_RIGHT, a                             ; $5542
    jr z, jr_007_5566                             ; $5544

    push af                                       ; $5546
    ld a, SFX1_03                                 ; $5547
    ld [wSndSfx1], a                              ; $5549
    pop af                                        ; $554C
    call Serial_SetFarCallback                    ; $554D

    dwb Frame_UpdateAll

    ld a, [wStrawberryCh_LockedNoticeCallback_D92A] ; $5553
    inc a                                         ; $5556
    cp $07                                        ; $5557
    jr nz, jr_007_555c                            ; $5559

    xor a                                         ; $555B

jr_007_555c:
    ld [wStrawberryCh_LockedNoticeCallback_D92A], a ; $555C
    ld a, $04                                     ; $555F
    ldh [hState], a                               ; $5561
    jp Far_Return                                 ; $5563


Jump_007_5566:
jr_007_5566:
    jp Far_Return                                 ; $5566


; C: the 16 cells $D960-$D96F = 0, 1, ... 15 (solved)
Puzzle15_ResetBoard::
    ld hl, wPuzzleBoard                           ; $5569
    xor a                                         ; $556C

jr_007_556d:
    ld [hl+], a                                   ; $556D
    inc a                                         ; $556E
    cp $10                                        ; $556F
    jr nz, jr_007_556d                            ; $5571

    jp Far_Return                                 ; $5573


; C: Z when $D960-$D96F hold 0 ... 15 in order
Puzzle15_IsSolved::
    ld hl, wPuzzleBoard                           ; $5576
    xor a                                         ; $5579

jr_007_557a:
    cp [hl]                                       ; $557A
    jr nz, jr_007_5583                            ; $557B

    inc hl                                        ; $557D
    inc a                                         ; $557E
    cp $10                                        ; $557F
    jr nz, jr_007_557a                            ; $5581

jr_007_5583:
    jp Far_ReturnSramBank                         ; $5583


; C: $D972-$D973 = $D970-$D971 (x, y of the empty cell)
Puzzle15_SavePos::
    ld a, [wPuzzleEmptyX]                         ; $5586
    ld [wPuzzle15_SavePos_D972], a                ; $5589
    ld a, [wPuzzleEmptyY]                         ; $558C
    ld [wPuzzle15_SavePos_D973], a                ; $558F
    jp Far_Return                                 ; $5592


; C: HL = $D960 + x + 4 y of $D970-$D971
Puzzle15_CellAddr::
    ld a, [wPuzzleEmptyX]                         ; $5595
    ld c, a                                       ; $5598
    ld a, [wPuzzleEmptyY]                         ; $5599
    sla a                                         ; $559C
    sla a                                         ; $559E
    add c                                         ; $55A0
    ld c, a                                       ; $55A1
    ld b, $00                                     ; $55A2
    ld hl, wPuzzleBoard                           ; $55A4
    add hl, bc                                    ; $55A7
    jp Far_Return                                 ; $55A8


; C: HL = $D960 + x + 4 y of $D972-$D973
Puzzle15_CellAddrPrev::
    ld a, [wPuzzle15_SavePos_D972]                ; $55AB
    ld c, a                                       ; $55AE
    ld a, [wPuzzle15_SavePos_D973]                ; $55AF
    sla a                                         ; $55B2
    sla a                                         ; $55B4
    add c                                         ; $55B6
    ld c, a                                       ; $55B7
    ld b, $00                                     ; $55B8
    ld hl, wPuzzleBoard                           ; $55BA
    add hl, bc                                    ; $55BD
    jp Far_Return                                 ; $55BE


; C: the piece of the cell at the cursor (value x 32 into 07:55FB) drawn into the map; runs on its screen (0F:05) in
; the core replays (port/entry_modes_kitty.csv); code read
Puzzle15_DrawCell::
    ld b, BANK(Puzzle15_CellAddr)                 ; $55C1
    ld hl, Puzzle15_CellAddr                      ; $55C3
    call Far_Call                                 ; $55C6
    ld a, [hl]                                    ; $55C9
    ld c, a                                       ; $55CA
    ld b, $00                                     ; $55CB
    swap c                                        ; $55CD
    sla c                                         ; $55CF
    rl b                                          ; $55D1
    ld hl, Puzzle15_DrawCell_Tbl55FB              ; $55D3
    add hl, bc                                    ; $55D6
    ld e, l                                       ; $55D7
    ld d, h                                       ; $55D8
    ld hl, $8700                                  ; $55D9
    ld c, $10                                     ; $55DC

jr_007_55de:
    push bc                                       ; $55DE
    push hl                                       ; $55DF
    ld l, e                                       ; $55E0
    ld h, d                                       ; $55E1
    ld a, [hl+]                                   ; $55E2
    ld c, a                                       ; $55E3
    ld a, [hl+]                                   ; $55E4
    ld b, a                                       ; $55E5
    ld e, l                                       ; $55E6
    ld d, h                                       ; $55E7
    pop hl                                        ; $55E8
    push de                                       ; $55E9
    ld e, c                                       ; $55EA
    ld d, b                                       ; $55EB
    ld bc, $0010                                  ; $55EC
    xor a                                         ; $55EF
    call Vram_CopyHBlankFar                       ; $55F0
    pop de                                        ; $55F3
    pop bc                                        ; $55F4
    dec c                                         ; $55F5
    jr nz, jr_007_55de                            ; $55F6

    jp Far_Return                                 ; $55F8


; C: named by the code of Puzzle15_DrawCell (07:55D3); read in the runs by Puzzle15_DrawCell; first read on the screen
; Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty*.npz)
Puzzle15_DrawCell_Tbl55FB::
    INCBIN "data/bank_07/Puzzle15_DrawCell_Tbl55FB.bin" ; $55FB, 480 bytes
; I: leftover: 32 bytes (07:57DB-57FA) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_07_57DB::
    db $c0, $cb, $c0, $cc, $d0, $cb, $d0, $cc, $e0, $cb, $e0, $cc, $f0, $cb, $f0, $cc
    db $c0, $cd, $00, $cf, $d0, $cd, $10, $cf, $e0, $cd, $30, $cf, $f0, $cd, $80, $cf

; C: named by the code of Puzzle15_PosRecord (07:582E); read in the runs by Puzzle15_PosRecord; first read on the
; screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty*.npz)
Puzzle15_PosRecord_Tbl57FB::
    db $f0, $48, $f8, $48, $f8, $48, $04, $49, $0c, $49, $e0, $48, $e0, $48, $18, $49
    db $0c, $49, $e0, $48, $e0, $48, $18, $49, $24, $49, $2c, $49, $2c, $49, $38, $49

; C: HL = 07:57FB + 2 x + 8 y of $D970-$D971
Puzzle15_PosRecord::
    ld a, [wPuzzleEmptyX]                         ; $581B
    ld c, a                                       ; $581E
    ld a, [wPuzzleEmptyY]                         ; $581F
    sla c                                         ; $5822
    sla a                                         ; $5824
    sla a                                         ; $5826
    sla a                                         ; $5828
    add c                                         ; $582A
    ld c, a                                       ; $582B
    ld b, $00                                     ; $582C
    ld hl, Puzzle15_PosRecord_Tbl57FB             ; $582E
    add hl, bc                                    ; $5831
    ld a, [hl+]                                   ; $5832
    ldh [hCopyReqSrcDstCnt + $4], a               ; $5833
    ld a, [hl+]                                   ; $5835
    ldh [hMode07_StateTable_FFD0], a              ; $5836
    jp Far_Return                                 ; $5838


; C: named by the code of Puzzle15_ScreenPosAddrPrev (07:5877); read in the runs by Puzzle15_CursorToCell; first read
; on the screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty*.npz)
Puzzle15_ScreenPosAddrPrev_Tbl583B::
    db $20, $18, $40, $18, $60, $18, $80, $18, $20, $38, $40, $38, $60, $38, $80, $38
    db $20, $58, $40, $58, $60, $58, $80, $58, $20, $78, $40, $78, $60, $78, $80, $78

; C: HL = 07:583B + 2 x + 8 y of $D970-$D971
Puzzle15_ScreenPosAddr::
    ld a, [wPuzzleEmptyX]                         ; $585B
    ld c, a                                       ; $585E
    ld a, [wPuzzleEmptyY]                         ; $585F
    jr jr_007_586b                                ; $5862

; C: the same of $D972-$D973
Puzzle15_ScreenPosAddrPrev::
    ld a, [wPuzzle15_SavePos_D972]                ; $5864
    ld c, a                                       ; $5867
    ld a, [wPuzzle15_SavePos_D973]                ; $5868

jr_007_586b:
    sla c                                         ; $586B
    sla a                                         ; $586D
    sla a                                         ; $586F
    sla a                                         ; $5871
    add c                                         ; $5873
    ld c, a                                       ; $5874
    ld b, $00                                     ; $5875
    ld hl, Puzzle15_ScreenPosAddrPrev_Tbl583B     ; $5877
    add hl, bc                                    ; $587A
    jp Far_Return                                 ; $587B


; C: hFFD2 / hFFD4 (object position) from Puzzle15_ScreenPosAddr
Puzzle15_CursorToCell::
    ld b, BANK(Puzzle15_ScreenPosAddr)            ; $587E
    ld hl, Puzzle15_ScreenPosAddr                 ; $5880
    call Far_Call                                 ; $5883
    jr jr_007_5890                                ; $5886

    db $06, $07, $21, $64, $58, $cd, $5b, $01

jr_007_5890:
    ld a, [hl+]                                   ; $5890
    ldh [hMode07_StateTable_FFD2], a              ; $5891
    ld a, [hl+]                                   ; $5893
    ldh [hStamp_ObjSlideIn_FFD4], a               ; $5894
    jp Far_Return                                 ; $5896


    db $06, $07, $21, $5b, $58, $cd, $5b, $01, $18, $08

; C: BC from Puzzle15_ScreenPosAddrPrev
Puzzle15_ScreenPosPrev::
    ld b, BANK(Puzzle15_ScreenPosAddrPrev)        ; $58A3
    ld hl, Puzzle15_ScreenPosAddrPrev             ; $58A5
    call Far_Call                                 ; $58A8
    ld a, [hl+]                                   ; $58AB
    ld c, a                                       ; $58AC
    ld b, [hl]                                    ; $58AD
    jp Far_Return                                 ; $58AE


; C: named by the code of Puzzle15_MapAddrPrev, Puzzle15_DrawBoard, Puzzle15_EmptyCellMapAddr (07:58ED 07:5957
; 07:5982); read in the runs by Puzzle15_SetMapPtrPrev; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty*.npz)
Puzzle15_MapAddrPrev_Tbl58B1::
    db $22, $00, $26, $00, $2a, $00, $2e, $00, $a2, $00, $a6, $00, $aa, $00, $ae, $00
    db $22, $01, $26, $01, $2a, $01, $2e, $01, $a2, $01, $a6, $01, $aa, $01, $ae, $01

; C: HL = 07:58B1 + 2 x + 8 y of $D970-$D971
Puzzle15_MapAddr::
    ld a, [wPuzzleEmptyX]                         ; $58D1
    ld c, a                                       ; $58D4
    ld a, [wPuzzleEmptyY]                         ; $58D5
    jr jr_007_58e1                                ; $58D8

; C: the same of $D972-$D973
Puzzle15_MapAddrPrev::
    ld a, [wPuzzle15_SavePos_D972]                ; $58DA
    ld c, a                                       ; $58DD
    ld a, [wPuzzle15_SavePos_D973]                ; $58DE

jr_007_58e1:
    sla c                                         ; $58E1
    sla a                                         ; $58E3
    sla a                                         ; $58E5
    sla a                                         ; $58E7
    add c                                         ; $58E9
    ld c, a                                       ; $58EA
    ld b, $00                                     ; $58EB
    ld hl, Puzzle15_MapAddrPrev_Tbl58B1           ; $58ED
    add hl, bc                                    ; $58F0
    jp Far_Return                                 ; $58F1


; C: hFFE3-hFFE4 from Puzzle15_MapAddr
Puzzle15_SetMapPtr::
    ld b, BANK(Puzzle15_MapAddr)                  ; $58F4
    ld hl, Puzzle15_MapAddr                       ; $58F6
    call Far_Call                                 ; $58F9
    jr jr_007_5906                                ; $58FC

; C: hFFE3-hFFE4 from Puzzle15_MapAddrPrev
Puzzle15_SetMapPtrPrev::
    ld b, BANK(Puzzle15_MapAddrPrev)              ; $58FE
    ld hl, Puzzle15_MapAddrPrev                   ; $5900
    call Far_Call                                 ; $5903

jr_007_5906:
    ld a, [hl+]                                   ; $5906
    ldh [hScriptCmd_AddE3_FFE3], a                ; $5907
    ld a, [hl]                                    ; $5909
    ldh [hScriptCmd_AddE3_B_FFE4], a              ; $590A
    jp Far_Return                                 ; $590C


    db $06, $07, $21, $d1, $58, $cd, $5b, $01, $18, $08, $06, $07, $21, $da, $58, $cd
    db $5b, $01, $2a, $4f, $46, $c3, $73, $01

; C: 4 rows of 4 bytes from bank $26 at DE into the map at HL (rows $20 apart)
Puzzle15_CopyPiece::
    ld c, $04                                     ; $5927

jr_007_5929:
    push bc                                       ; $5929
    ld bc, $0004                                  ; $592A
    ld a, $26                                     ; $592D
    call Copy_FarDEtoHL                           ; $592F
    ld bc, $001c                                  ; $5932
    add hl, bc                                    ; $5935
    pop bc                                        ; $5936
    dec c                                         ; $5937
    jr nz, jr_007_5929                            ; $5938

    ret                                           ; $593A


; C: the tiles of each cell value (7C20 + 32 x value) for the 16 cells of $D960
Puzzle15_DrawBoard::
    ld hl, wPuzzleBoard                           ; $593B
    xor a                                         ; $593E

jr_007_593f:
    push af                                       ; $593F
    ld a, [hl+]                                   ; $5940
    push hl                                       ; $5941
    swap a                                        ; $5942
    ld c, a                                       ; $5944
    ld b, $00                                     ; $5945
    ld hl, $7c20                                  ; $5947
    add hl, bc                                    ; $594A
    add hl, bc                                    ; $594B
    ld e, l                                       ; $594C
    ld d, h                                       ; $594D
    pop hl                                        ; $594E
    pop af                                        ; $594F
    push af                                       ; $5950
    push hl                                       ; $5951
    sla a                                         ; $5952
    ld c, a                                       ; $5954
    ld b, $00                                     ; $5955
    ld hl, Puzzle15_MapAddrPrev_Tbl58B1           ; $5957
    add hl, bc                                    ; $595A
    ld a, [hl+]                                   ; $595B
    ld h, [hl]                                    ; $595C
    ld l, a                                       ; $595D
    ld bc, $9800                                  ; $595E
    add hl, bc                                    ; $5961
    call Puzzle15_CopyPiece                       ; $5962
    pop hl                                        ; $5965
    pop af                                        ; $5966
    inc a                                         ; $5967
    cp $10                                        ; $5968
    jr nz, jr_007_593f                            ; $596A

    jp Far_Return                                 ; $596C


; C: the map address of the empty cell from 07:58B1 by $D970-$D971; runs on its screen (0F:01) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_EmptyCellMapAddr::
    ld a, [wPuzzleEmptyY]                         ; $596F
    sla a                                         ; $5972
    sla a                                         ; $5974
    sla a                                         ; $5976
    ld c, a                                       ; $5978
    ld a, [wPuzzleEmptyX]                         ; $5979
    sla a                                         ; $597C
    add c                                         ; $597E
    ld c, a                                       ; $597F
    ld b, $00                                     ; $5980
    ld hl, Puzzle15_MapAddrPrev_Tbl58B1           ; $5982
    add hl, bc                                    ; $5985
    ld a, [hl+]                                   ; $5986
    ld h, [hl]                                    ; $5987
    ld l, a                                       ; $5988
    ld bc, $9800                                  ; $5989
    add hl, bc                                    ; $598C
    ld de, $7e20                                  ; $598D
    call Puzzle15_CopyPiece                       ; $5990
    jp Far_Return                                 ; $5993


; C: the next key of the shuffle script 07:59AF + 16 x A + [$D979] written into $D8D9 (new keys), $D979 + 1: the board
; is shuffled by played moves
Puzzle15_ScriptedKey::
    swap a                                        ; $5996
    ld c, a                                       ; $5998
    ld b, $00                                     ; $5999
    ld hl, Puzzle15_ScriptedKey_Tbl59AF           ; $599B
    add hl, bc                                    ; $599E
    ld a, [wPuzzle15_ScriptedKey_D979]            ; $599F
    ld c, a                                       ; $59A2
    add hl, bc                                    ; $59A3
    ld a, [hl]                                    ; $59A4
    ld [wKeysNew], a                              ; $59A5
    ld hl, wPuzzle15_ScriptedKey_D979             ; $59A8
    inc [hl]                                      ; $59AB
    jp Far_Return                                 ; $59AC


; C: named by the code of Puzzle15_ScriptedKey (07:599B); read in the runs by Puzzle15_ScriptedKey; first read on the
; screen Mode0F_FifteenPuzzle_State05 (trace/read_screens_kitty*.npz)
Puzzle15_ScriptedKey_Tbl59AF::
    db $80, $80, $80, $10, $40, $40, $40, $10, $80, $80, $80, $10, $40, $40, $40

; I: leftover: 49 bytes (07:59BE-59EE) that no run reads or executes and that no code names (owner rule 2026-11-11)
Leftover_07_59BE::
    db $00, $10, $10, $10, $80, $20, $20, $20, $80, $10, $10, $10, $80, $20, $20, $20
    db $00, $80, $80, $80, $10, $10, $10, $40, $40, $40, $20, $20, $80, $80, $10, $40
    db $00, $10, $10, $10, $80, $80, $80, $20, $20, $20, $40, $40, $10, $10, $80, $20
    db $00

; C: handler of state $02 of mode $0F (word 2 of Mode0F_StateTable)
Mode0F_State02::
    ld b, BANK(Counters_Load)                     ; $59EF
    ld hl, Counters_Load                          ; $59F1
    call Far_Call                                 ; $59F4
    ld a, [wPuzzleDrawingsDone]                   ; $59F7
    cp $05                                        ; $59FA
    jr nz, jr_007_5a03                            ; $59FC

    ld a, $05                                     ; $59FE
    call Rng_Scaled                               ; $5A00

jr_007_5a03:
    ld [wPuzzlePicture], a                        ; $5A03
    ld b, BANK(FrameCorner_DrawSet)               ; $5A06
    ld hl, FrameCorner_DrawSet                    ; $5A08
    call Far_CallKeepA                            ; $5A0B
    jr jr_007_5a1b                                ; $5A0E

; C: FrameCorner_DrawSet with $D97A, then copies; mode $0F state $01; runs on its screen (0F:01) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_LoadPicture::
    ld a, [wPuzzlePicture]                        ; $5A10
    ld b, BANK(FrameCorner_DrawSet)               ; $5A13
    ld hl, FrameCorner_DrawSet                    ; $5A15
    call Far_CallKeepA                            ; $5A18

jr_007_5a1b:
    call Copy_Inline                              ; $5A1B

    db $00, $c0, $00, $88, $00, $0e

    call Lcd_SetupInline                          ; $5A24

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ret                                           ; $5A32


; C: handler of state $03 of mode $0F (word 3 of Mode0F_StateTable)
Mode0F_State03::
    call Lcd_SetupInline                          ; $5A33

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld a, [wAlbum_SlotOp6D18_D932]                ; $5A41
    call Rng_Scaled                               ; $5A44
    inc a                                         ; $5A47
    ld [wPuzzlePicture], a                        ; $5A48
    ld b, BANK(Photo_FindSlotA)                   ; $5A4B
    ld hl, Photo_FindSlotA                        ; $5A4D
    call Far_CallKeepA                            ; $5A50
    ld b, BANK(Photo_LoadTiles8800)               ; $5A53
    ld hl, Photo_LoadTiles8800                    ; $5A55
    call Far_CallKeepA                            ; $5A58
    ret                                           ; $5A5B


; C: Lcd_SetupInline and the screen set-up of the 15 puzzle; runs on its screen (0F:01) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_InitScreen::
    call Lcd_SetupInline                          ; $5A5C

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld a, [wPuzzlePicture]                        ; $5A6A
    ld b, BANK(Photo_FindSlotA)                   ; $5A6D
    ld hl, Photo_FindSlotA                        ; $5A6F
    call Far_CallKeepA                            ; $5A72
    ld b, BANK(Photo_LoadTiles8800)               ; $5A75
    ld hl, Photo_LoadTiles8800                    ; $5A77
    call Far_CallKeepA                            ; $5A7A
    ret                                           ; $5A7D


; C: handler of state $04 of mode $0F (word 4 of Mode0F_StateTable)
Mode0F_State04::
    ld a, $07                                     ; $5A7E
    ld [wTakePhotos_FrameCallback2_DA1E], a       ; $5A80
    ld a, $08                                     ; $5A83
    ld [wTakePhotos_FrameCallback2_DA1F], a       ; $5A85
    ld a, $01                                     ; $5A88
    ld [wMode02_State00_DA20], a                  ; $5A8A
    ld a, $08                                     ; $5A8D
    xor a                                         ; $5A8F
    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $5A90
    ld c, a                                       ; $5A93
    ld a, [wCamGainSel]                           ; $5A94
    ld b, a                                       ; $5A97
    ld b, BANK(Cam_LoadRegisterSet_Far)           ; $5A98
    ld hl, Cam_LoadRegisterSet_Far                ; $5A9A
    call Far_CallKeepA                            ; $5A9D
    call Lcd_SetupInline                          ; $5AA0

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    call Mode0F_State0C                           ; $5AAE
    ret                                           ; $5AB1


; C: jump by $D974 (inline table); runs on its screen (0F:00) in the core replays (port/entry_modes_kitty.csv); code
; read
Puzzle15_DispatchA::
    ld a, [wPuzzleKind]                           ; $5AB2
    call JumpTable_Inline                         ; $5AB5

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0F_FifteenPuzzle_State00
; (trace/read_screens_kitty*.npz)
Puzzle15_DispatchA_JumpTbl5AB8::
    dw Mode0F_State02
    dw Mode0F_State03
    dw Mode0F_State04

; C: jump by $D974 (inline table); runs on its screen (0F:01) in the core replays (port/entry_modes_kitty.csv); code
; read
Puzzle15_DispatchB::
    ld a, [wPuzzleKind]                           ; $5ABE
    call JumpTable_Inline                         ; $5AC1

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0F_FifteenPuzzle_State01
; (trace/read_screens_kitty*.npz)
Puzzle15_DispatchB_JumpTbl5AC4::
    dw Puzzle15_LoadPicture
    dw Puzzle15_InitScreen
    dw Mode0F_State04

; C: Copy_FarInline of the puzzle graphics; runs on its screen (0F:00) in the core replays
; (port/entry_modes_kitty.csv); code read
Puzzle15_LoadGfx::
    call Copy_FarInline                           ; $5ACA

    db $00, $6a, $24, $00, $80, $00, $08

    call Copy_FarInline                           ; $5AD4

    db $00, $70, $24, $c0, $81, $40, $00

    call Copy_FarInline                           ; $5ADE

    db $00, $72, $24, $00, $96, $00, $02

    call Copy_FarInline                           ; $5AE8

    db $00, $72, $24, $00, $ce, $00, $02

    call Copy_FarInline                           ; $5AF2

    db $20, $78, $26, $00, $98, $40, $02

    push af                                       ; $5AFC
    ld a, MUSIC_FIFTEEN_PUZZLE                    ; $5AFD
    ld [wSndMusicReq], a                          ; $5AFF
    pop af                                        ; $5B02
    ret                                           ; $5B03


; C: handler of state $00 of mode $0F (word 0 of Mode0F_StateTable)
Mode0F_State00::
    di                                            ; $5B04
    call Lcd_Off                                  ; $5B05
    call Oam_ClearShadow                          ; $5B08
    ld b, BANK(Objects_ClearAll)                  ; $5B0B
    ld hl, Objects_ClearAll                       ; $5B0D
    call Far_Call                                 ; $5B10
    ld b, BANK(ScriptSlots_Clear)                 ; $5B13
    ld hl, ScriptSlots_Clear                      ; $5B15
    call Far_Call                                 ; $5B18
    call Serial_SetFarCallback                    ; $5B1B

    dwb Frame_UpdateAll

    xor a                                         ; $5B21
    ld [wMode07_StateTable_D8E0], a               ; $5B22
    ld [wMode0F_State0F_D93F], a                  ; $5B25
    ld [wMode10_State03_D940], a                  ; $5B28
    ld a, $03                                     ; $5B2B
    ld [wPuzzleEmptyX], a                         ; $5B2D
    ld [wPuzzleEmptyY], a                         ; $5B30
    ld [wPuzzle15_SavePos_D972], a                ; $5B33
    ld [wPuzzle15_SavePos_D973], a                ; $5B36
    ld a, $20                                     ; $5B39
    ld [wPuzzle15_ObjSetCC_D977], a               ; $5B3B
    ld a, $e0                                     ; $5B3E
    ld [wPuzzle15_ObjSetCC_D978], a               ; $5B40
    ld a, $ce                                     ; $5B43
    ld [wTakePhotos_ResetFrameState_D92D], a      ; $5B45
    ld a, $41                                     ; $5B48
    ld [wTakePhotos_ResetFrameState_D92E], a      ; $5B4A
    ld a, $0f                                     ; $5B4D
    ld [wScript_LoadCounterD97B], a               ; $5B4F
    ld a, $10                                     ; $5B52
    ld [wScript_SetD97C], a                       ; $5B54
    call Puzzle15_LoadGfx                         ; $5B57
    ld b, BANK(Puzzle15_ResetBoard)               ; $5B5A
    ld hl, Puzzle15_ResetBoard                    ; $5B5C
    call Far_Call                                 ; $5B5F
    call Puzzle15_DispatchA                       ; $5B62
    ld bc, $1820                                  ; $5B65
    ld de, ObjScript_02_5387_Mode0F_FifteenPuzzle_State05 ; $5B68
    call Object_CreateWithParam                   ; $5B6B
    ld bc, $1820                                  ; $5B6E
    ld de, ObjScript_02_528B_Mode0F_FifteenPuzzle_State05 ; $5B71
    call Object_CreateWithParam                   ; $5B74
    ld a, [wPuzzleKind]                           ; $5B77
    call JumpTable_Inline                         ; $5B7A

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0F_FifteenPuzzle_State05
; (trace/read_screens_kitty*.npz)
Mode0F_State00_JumpTbl5B7D::
    dw Puzzle15_FadeToState05
    dw Puzzle15_FadeToState05
    dw Puzzle15_FadeToState0C

; C: ei, fade to mode $0F state $05 ($0B16)
Puzzle15_FadeToState05::
    ei                                            ; $5B83
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5B84
    ld c, STATE_0F_15_PUZZLE_DEAL                 ; $5B86
    call Fade_GoTo                                ; $5B88
    ret                                           ; $5B8B


; C: frame callback 07:5BDB, fade to mode $0F state $0C
Puzzle15_FadeToState0C::
    call Serial_SetFarCallback                    ; $5B8C

    dwb Puzzle15_FrameCallback

    ei                                            ; $5B92
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5B93
    ld c, STATE_0F_15_PUZZLE_LIVE_CAMERA          ; $5B95
    call Fade_GoTo                                ; $5B97
    ret                                           ; $5B9A


; C: handler of state $01 of mode $0F (word 1 of Mode0F_StateTable)
Mode0F_State01::
    di                                            ; $5B9B
    call Lcd_Off                                  ; $5B9C
    call Oam_ClearShadow                          ; $5B9F
    ld b, BANK(Objects_ClearAll)                  ; $5BA2
    ld hl, Objects_ClearAll                       ; $5BA4
    call Far_Call                                 ; $5BA7
    ld b, BANK(ScriptSlots_Clear)                 ; $5BAA
    ld hl, ScriptSlots_Clear                      ; $5BAC
    call Far_Call                                 ; $5BAF
    call Serial_SetFarCallback                    ; $5BB2

    dwb Puzzle15_FrameCallback2

    xor a                                         ; $5BB8
    ld [wMode07_StateTable_D8E0], a               ; $5BB9
    call Puzzle15_LoadGfx                         ; $5BBC
    ld b, BANK(Puzzle15_DrawBoard)                ; $5BBF
    ld hl, Puzzle15_DrawBoard                     ; $5BC1
    call Far_Call                                 ; $5BC4
    ld b, BANK(Puzzle15_EmptyCellMapAddr)         ; $5BC7
    ld hl, Puzzle15_EmptyCellMapAddr              ; $5BC9
    call Far_Call                                 ; $5BCC
    call Puzzle15_DispatchB                       ; $5BCF
    ei                                            ; $5BD2
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5BD3
    ld c, $09                                     ; $5BD5
    call Fade_GoTo                                ; $5BD7
    ret                                           ; $5BDA


; C: Object_RunAll, ScriptSlots_Run, 00:21BE, 00:03D5, then a callback change when $D8E0 bit 2 is set
Puzzle15_FrameCallback::
    ld b, $00                                     ; $5BDB
    ld hl, Object_RunAll                          ; $5BDD
    call Far_Call                                 ; $5BE0
    ld b, BANK(ScriptSlots_Run)                   ; $5BE3
    ld hl, ScriptSlots_Run                        ; $5BE5
    call Far_Call                                 ; $5BE8
    call Objects_DrawAll                          ; $5BEB
    call Oam_HideUnused                           ; $5BEE
    ld a, [wMode07_StateTable_D8E0]               ; $5BF1
    bit 2, a                                      ; $5BF4
    jr z, jr_007_5c0f                             ; $5BF6

    call Serial_SetFarCallback                    ; $5BF8

    dwb Frame_UpdateAll

    ld a, $04                                     ; $5BFE
    ld [wPuzzle15_ObjSetCC_D977], a               ; $5C00
    ld a, $fc                                     ; $5C03
    ld [wPuzzle15_ObjSetCC_D978], a               ; $5C05
    ld a, $06                                     ; $5C08
    ldh [hState], a                               ; $5C0A
    jp Far_Return                                 ; $5C0C


jr_007_5c0f:
    jp Far_Return                                 ; $5C0F


; C: handler of state $05 of mode $0F (word 5 of Mode0F_StateTable)
Mode0F_State05::
    ld a, [wMode07_StateTable_D8E0]               ; $5C12
    bit 2, a                                      ; $5C15
    jr z, jr_007_5c28                             ; $5C17

    ld a, $04                                     ; $5C19
    ld [wPuzzle15_ObjSetCC_D977], a               ; $5C1B
    ld a, $fc                                     ; $5C1E
    ld [wPuzzle15_ObjSetCC_D978], a               ; $5C20
    ld a, $06                                     ; $5C23
    ldh [hState], a                               ; $5C25
    ret                                           ; $5C27


jr_007_5c28:
    ret                                           ; $5C28


; C: handler of state $06 of mode $0F (word 6 of Mode0F_StateTable)
Mode0F_State06::
    call Oam_ClearShadow                          ; $5C29
    ld b, BANK(Objects_ClearAll)                  ; $5C2C
    ld hl, Objects_ClearAll                       ; $5C2E
    call Far_Call                                 ; $5C31
    ld bc, $48c0                                  ; $5C34
    ld de, ObjScript_02_539F_Mode0F_FifteenPuzzle_State07 + $18 ; $5C37
    call Object_CreateWithParam                   ; $5C3A
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5C3D
    ld c, $07                                     ; $5C3F
    call ModeState_Set                            ; $5C41
    ret                                           ; $5C44


; C: handler of state $07 of mode $0F (word 7 of Mode0F_StateTable)
Mode0F_State07::
    ld a, [wMode07_StateTable_D8E0]               ; $5C45
    bit 0, a                                      ; $5C48
    jr z, jr_007_5c50                             ; $5C4A

    ld a, $08                                     ; $5C4C
    ldh [hState], a                               ; $5C4E

jr_007_5c50:
    ret                                           ; $5C50


; C: handler of state $08 of mode $0F (word 8 of Mode0F_StateTable)
Mode0F_State08::
    di                                            ; $5C51
    call Oam_ClearShadow                          ; $5C52
    ld b, BANK(Objects_ClearAll)                  ; $5C55
    ld hl, Objects_ClearAll                       ; $5C57
    call Far_Call                                 ; $5C5A
    ld b, BANK(ScriptSlots_Clear)                 ; $5C5D
    ld hl, ScriptSlots_Clear                      ; $5C5F
    call Far_Call                                 ; $5C62
    ld de, $5240                                  ; $5C65
    ld b, BANK(ScriptSlots_Add)                   ; $5C68
    ld hl, ScriptSlots_Add                        ; $5C6A
    call Far_Call                                 ; $5C6D
    ld bc, $0790                                  ; $5C70
    ld de, ObjScript_02_508A_Mode0F_FifteenPuzzle_State0A + $9 ; $5C73
    call Object_CreateWithParam                   ; $5C76
    ld bc, $1008                                  ; $5C79
    ld de, ObjScript_02_5032_Mode11_StrawberryChannel_State04 + $38 ; $5C7C
    call Object_CreateWithParam                   ; $5C7F
    ld bc, $1820                                  ; $5C82
    ld de, ObjScript_02_528B_Mode0F_FifteenPuzzle_State05 ; $5C85
    call Object_CreateWithParam                   ; $5C88
    ld bc, $484f                                  ; $5C8B
    ld de, ObjScript_02_50C8_Mode0F_FifteenPuzzle_State0A ; $5C8E
    call Object_CreateWithParam                   ; $5C91
    ld de, Gfx_24_6BC0_Mode0F_FifteenPuzzle_State00 ; $5C94
    ld hl, $81c0                                  ; $5C97
    ld bc, $0030                                  ; $5C9A
    ld a, $24                                     ; $5C9D
    call Vram_CopyHBlankFar                       ; $5C9F
    call Serial_SetFarCallback                    ; $5CA2

    dwb Puzzle15_FrameCallback2

    ld a, [wPuzzleKind]                           ; $5CA8
    call JumpTable_Inline                         ; $5CAB

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0F_FifteenPuzzle_State0A
; (trace/read_screens_kitty*.npz)
Mode0F_State08_JumpTbl5CAE::
    dw Puzzle15_SetState0A
    dw Puzzle15_SetState0B
    dw Puzzle15_SetState0C

; C: ModeState_Set $0F / $0A
Puzzle15_SetState0A::
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5CB4
    ld c, STATE_0F_15_PUZZLE_DRAWING              ; $5CB6
    call ModeState_Set                            ; $5CB8
    ei                                            ; $5CBB
    ret                                           ; $5CBC


; C: ModeState_Set $0F / $0B
Puzzle15_SetState0B::
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5CBD
    ld c, STATE_0F_15_PUZZLE_PHOTO                ; $5CBF
    call ModeState_Set                            ; $5CC1
    ei                                            ; $5CC4
    ret                                           ; $5CC5


; C: ModeState_Set $0F / $0C
Puzzle15_SetState0C::
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5CC6
    ld c, STATE_0F_15_PUZZLE_LIVE_CAMERA          ; $5CC8
    call ModeState_Set                            ; $5CCA
    ei                                            ; $5CCD
    ret                                           ; $5CCE


; C: Object_RunAll, ScriptSlots_Run, 00:21BE, 00:03D5, then the keys unless $D8D4 is set; runs on its screen (0F:0A
; 0F:0B) in the core replays (port/entry_modes_kitty.csv); code read
Puzzle15_FrameCallback2::
    ld b, $00                                     ; $5CCF
    ld hl, Object_RunAll                          ; $5CD1
    call Far_Call                                 ; $5CD4
    ld b, BANK(ScriptSlots_Run)                   ; $5CD7
    ld hl, ScriptSlots_Run                        ; $5CD9
    call Far_Call                                 ; $5CDC
    call Objects_DrawAll                          ; $5CDF
    call Oam_HideUnused                           ; $5CE2
    ld a, [wFadeRunning]                          ; $5CE5
    and a                                         ; $5CE8
    jr z, jr_007_5cee                             ; $5CE9

    jp Far_Return                                 ; $5CEB


jr_007_5cee:
    ld a, [wPuzzle15_ObjWaitMove_D975]            ; $5CEE
    bit 0, [hl]                                   ; $5CF1
    jr nz, jr_007_5d16                            ; $5CF3

    ld b, BANK(Puzzle15_IsSolved)                 ; $5CF5
    ld hl, Puzzle15_IsSolved                      ; $5CF7
    call Far_Call                                 ; $5CFA
    jr nz, jr_007_5d16                            ; $5CFD

    push af                                       ; $5CFF
    ld a, SFX1_2F                                 ; $5D00
    ld [wSndSfx1], a                              ; $5D02
    pop af                                        ; $5D05
    call Serial_SetFarCallback                    ; $5D06

    dwb Frame_UpdateAll

    ld b, MODE_FIFTEEN_PUZZLE                     ; $5D0C
    ld c, $0d                                     ; $5D0E
    call ModeState_Set                            ; $5D10
    jp Far_Return                                 ; $5D13


jr_007_5d16:
    ld a, [wMode07_StateTable_D8E0]               ; $5D16
    bit 1, a                                      ; $5D19
    jr z, jr_007_5d39                             ; $5D1B

    push af                                       ; $5D1D
    ld a, SFX1_1A                                 ; $5D1E
    ld [wSndSfx1], a                              ; $5D20
    pop af                                        ; $5D23
    call Serial_SetFarCallback                    ; $5D24

    dwb Frame_UpdateAll

    ld a, $2c                                     ; $5D2A
    ld [wMode0E_State1E_D943], a                  ; $5D2C
    ld b, MODE_KITT_GAMES_HOST                    ; $5D2F
    ld c, $00                                     ; $5D31
    call Fade_GoToB                               ; $5D33
    jp Far_Return                                 ; $5D36


jr_007_5d39:
    jp Far_Return                                 ; $5D39


; C: handler of state $0A of mode $0F (word 10 of Mode0F_StateTable)
Mode0F_State0A::
    ret                                           ; $5D3C


; C: handler of state $0C of mode $0F (word 12 of Mode0F_StateTable)
Mode0F_State0C::
    ld a, [wTakePhotos_FrameCallback2_DA1E]       ; $5D3D
    ld [wCamBrightnessSetpoint], a                ; $5D40
    ld a, [wTakePhotos_FrameCallback2_DA1F]       ; $5D43
    ld [wCamContrastRow], a                       ; $5D46
    ld a, [wMode02_State00_DA20]                  ; $5D49
    ld [wCamDitherMode], a                        ; $5D4C
    xor a                                         ; $5D4F
    ld b, BANK(Cam_ApplyEffectOrFrame)            ; $5D50
    ld hl, Cam_ApplyEffectOrFrame                 ; $5D52
    call Far_CallKeepA                            ; $5D55
    ld a, $10                                     ; $5D58
    ldh [hSram_Format_FF8C], a                    ; $5D5A
    ld [rRAMB], a                                 ; $5D5C
    ld a, [wCamA000Shadow]                        ; $5D5F
    set 0, a                                      ; $5D62
    ld [$a000], a                                 ; $5D64
    ld de, $c000                                  ; $5D67
    ld hl, $8800                                  ; $5D6A
    ld bc, $0e00                                  ; $5D6D
    call Vram_CopyHBlank                          ; $5D70
    ld a, $10                                     ; $5D73
    ldh [hSram_Format_FF8C], a                    ; $5D75
    ld [rRAMB], a                                 ; $5D77

jr_007_5d7a:
    ld hl, $a000                                  ; $5D7A
    bit 0, [hl]                                   ; $5D7D
    jr nz, jr_007_5d7a                            ; $5D7F

    ld a, [wCamBrightnessSetpoint]                ; $5D81
    ld b, BANK(Cam_PopcountLevelByIndex)          ; $5D84
    ld hl, Cam_PopcountLevelByIndex               ; $5D86
    call Far_CallKeepA                            ; $5D89
    ld a, [wCamContrastRow]                       ; $5D8C
    ld c, a                                       ; $5D8F
    ld a, [wCamGainSel]                           ; $5D90
    ld b, a                                       ; $5D93
    ld b, BANK(Cam_LoadRegisterSet_Far)           ; $5D94
    ld hl, Cam_LoadRegisterSet_Far                ; $5D96
    call Far_CallKeepA                            ; $5D99
    ret                                           ; $5D9C


; C: handler of state $0D of mode $0F (word 13 of Mode0F_StateTable)
Mode0F_State0D::
    call Oam_ClearShadow                          ; $5D9D
    ld b, BANK(Objects_ClearAll)                  ; $5DA0
    ld hl, Objects_ClearAll                       ; $5DA2
    call Far_Call                                 ; $5DA5
    ld b, BANK(ScriptSlots_Clear)                 ; $5DA8
    ld hl, ScriptSlots_Clear                      ; $5DAA
    call Far_Call                                 ; $5DAD
    push af                                       ; $5DB0
    ld a, MUSIC_FIFTEEN_PUZZLE_0F_0D              ; $5DB1
    ld [wSndMusicReq], a                          ; $5DB3
    pop af                                        ; $5DB6
    ld a, [wScript_SetD97C]                       ; $5DB7
    and a                                         ; $5DBA
    jr z, jr_007_5dd6                             ; $5DBB

    ld c, a                                       ; $5DBD
    ld b, $00                                     ; $5DBE
    ld hl, $9801                                  ; $5DC0
    add hl, bc                                    ; $5DC3
    call Vram_WaitHBlankLine                      ; $5DC4

jr_007_5dc7:
    ldh a, [rSTAT]                                ; $5DC7
    and $03                                       ; $5DC9
    jr z, jr_007_5dc7                             ; $5DCB

jr_007_5dcd:
    ldh a, [rSTAT]                                ; $5DCD
    and $03                                       ; $5DCF
    jr nz, jr_007_5dcd                            ; $5DD1

    ld a, $7e                                     ; $5DD3
    ld [hl+], a                                   ; $5DD5

jr_007_5dd6:
    ld de, Map_26_7840_Mode0F_FifteenPuzzle_State00 ; $5DD6
    ld hl, $9820                                  ; $5DD9
    ld bc, $0220                                  ; $5DDC
    ld a, $26                                     ; $5DDF
    call Vram_CopyHBlankFar                       ; $5DE1
    ld bc, $48c0                                  ; $5DE4
    ld de, ObjScript_02_539F_Mode0F_FifteenPuzzle_State07 + $36 ; $5DE7
    call Object_CreateWithParam                   ; $5DEA
    ld b, MODE_FIFTEEN_PUZZLE                     ; $5DED
    ld c, $0e                                     ; $5DEF
    call ModeState_Set                            ; $5DF1
    ret                                           ; $5DF4


; C: handler of state $0E of mode $0F (word 14 of Mode0F_StateTable)
Mode0F_State0E::
    ld a, [wMode07_StateTable_D8E0]               ; $5DF5
    bit 0, a                                      ; $5DF8
    jr z, jr_007_5e03                             ; $5DFA

    ld b, MODE_FIFTEEN_PUZZLE                     ; $5DFC
    ld c, STATE_0F_15_PUZZLE_SOLVED               ; $5DFE
    call ModeState_Set                            ; $5E00

jr_007_5e03:
    ret                                           ; $5E03


; C: handler of state $0F of mode $0F (word 15 of Mode0F_StateTable)
Mode0F_State0F::
    ld a, [wKeysNew]                              ; $5E04
    and PADF_A | PADF_B                           ; $5E07
    jr z, jr_007_5e3f                             ; $5E09

    push af                                       ; $5E0B
    ld a, SFX1_19                                 ; $5E0C
    ld [wSndSfx1], a                              ; $5E0E
    pop af                                        ; $5E11
    ld de, $0020                                  ; $5E12
    ld hl, wMode0F_State0F_D93F                   ; $5E15
    ld c, $02                                     ; $5E18
    call Bcd_Add                                  ; $5E1A
    ld a, [wScript_SetD97C]                       ; $5E1D
    and a                                         ; $5E20
    jr z, jr_007_5e33                             ; $5E21

jr_007_5e23:
    push af                                       ; $5E23
    ld de, $0005                                  ; $5E24
    ld hl, wMode0F_State0F_D93F                   ; $5E27
    ld c, $02                                     ; $5E2A
    call Bcd_Add                                  ; $5E2C
    pop af                                        ; $5E2F
    dec a                                         ; $5E30
    jr nz, jr_007_5e23                            ; $5E31

jr_007_5e33:
    ld a, $20                                     ; $5E33
    ld [wMode0E_State1E_D943], a                  ; $5E35
    ld b, MODE_KITT_GAMES_HOST                    ; $5E38
    ld c, $00                                     ; $5E3A
    call Fade_GoToB                               ; $5E3C

jr_007_5e3f:
    ret                                           ; $5E3F


; C: ModeTable entry $0F: forced BGB screen (15 puzzle board); reached in the core runs (from the Play menu)
Mode0F_FifteenPuzzle::
    ldh a, [hState]                               ; $5E40
    ld hl, Mode0F_StateTable                      ; $5E42
    call JumpTable_ByA                            ; $5E45
    jp Far_Return                                 ; $5E48


; C: state table of mode $0F, read by $0189 with hFF8E
Mode0F_StateTable::
    dw Mode0F_State00
    dw Mode0F_State01
    dw Mode0F_State02
    dw Mode0F_State03
    dw Mode0F_State04
    dw Mode0F_State05
    dw Mode0F_State06
    dw Mode0F_State07
    dw Mode0F_State08
    dw Mode0F_State08
    dw Mode0F_State0A
    dw Mode0F_State0A
    dw Mode0F_State0C
    dw Mode0F_State0D
    dw Mode0F_State0E
    dw Mode0F_State0F

; C: the 6 spots $D952-$D957 = 0
Scratch_ClearSpots::
    ld hl, wScratch_CursorUpdate_D952             ; $5E6B
    xor a                                         ; $5E6E
    ld c, $06                                     ; $5E6F

jr_007_5e71:
    ld [hl+], a                                   ; $5E71
    dec c                                         ; $5E72
    jr nz, jr_007_5e71                            ; $5E73

    jp Far_Return                                 ; $5E75


; C: looks for a spot whose low nibble is 3; runs on its screen (10:02) in the core replays
; (port/entry_modes_kitty.csv); code read
Scratch_HasPrize3::
    ld hl, wScratch_CursorUpdate_D952             ; $5E78
    ld c, $06                                     ; $5E7B

jr_007_5e7d:
    ld a, [hl+]                                   ; $5E7D
    and $0f                                       ; $5E7E
    cp $03                                        ; $5E80
    jr z, jr_007_5e8b                             ; $5E82

    dec c                                         ; $5E84
    jr nz, jr_007_5e7d                            ; $5E85

    and a                                         ; $5E87
    jp Far_ReturnSramBank                         ; $5E88


jr_007_5e8b:
    scf                                           ; $5E8B
    jp Far_ReturnSramBank                         ; $5E8C


; C: counters loaded, a random prize from the table of 07:5F05 into $D959, then free spots by 07:5EF1; runs on its
; screen (10:00) in the core replays (port/entry_modes_kitty.csv); code read
Scratch_DealSpots::
    ld b, BANK(Counters_Load)                     ; $5E8F
    ld hl, Counters_Load                          ; $5E91
    call Far_Call                                 ; $5E94
    call Rng_Next                                 ; $5E97
    and $0f                                       ; $5E9A
    ld c, a                                       ; $5E9C
    ld b, $00                                     ; $5E9D
    call Scratch_PrizeTable                       ; $5E9F
    add hl, bc                                    ; $5EA2
    ld a, [hl]                                    ; $5EA3
    ld [wScratch_DealSpots_D959], a               ; $5EA4
    call Scratch_PickFreeSpot                     ; $5EA7
    call Scratch_PickFreeSpot                     ; $5EAA

jr_007_5ead:
    call Rng_Next                                 ; $5EAD
    and $0f                                       ; $5EB0
    ld c, a                                       ; $5EB2
    ld b, $00                                     ; $5EB3
    call Scratch_PrizeTable                       ; $5EB5
    add hl, bc                                    ; $5EB8
    ld a, [hl]                                    ; $5EB9
    ld hl, wScratch_DealSpots_D959                ; $5EBA
    cp [hl]                                       ; $5EBD
    jr z, jr_007_5ead                             ; $5EBE

    ld [wScratch_DealSpots_D95A], a               ; $5EC0
    call Scratch_PickFreeSpot                     ; $5EC3
    call Scratch_PickFreeSpot                     ; $5EC6
    call Rng_Next                                 ; $5EC9
    and $0f                                       ; $5ECC
    ld c, a                                       ; $5ECE
    ld b, $00                                     ; $5ECF
    call Scratch_PrizeTableB                      ; $5ED1
    add hl, bc                                    ; $5ED4
    ld a, [hl]                                    ; $5ED5
    cp $14                                        ; $5ED6
    jr nz, jr_007_5ee8                            ; $5ED8

    ld a, [wScratch_DealSpots_D959]               ; $5EDA
    call Scratch_PickFreeSpot                     ; $5EDD
    ld a, [wScratch_DealSpots_D95A]               ; $5EE0
    call Scratch_PickFreeSpot                     ; $5EE3
    jr jr_007_5eee                                ; $5EE6

jr_007_5ee8:
    call Scratch_PickFreeSpot                     ; $5EE8
    call Scratch_PickFreeSpot                     ; $5EEB

jr_007_5eee:
    jp Far_Return                                 ; $5EEE


; C: a random spot (Rng_Scaled 6) of $D952 that is still 0
Scratch_PickFreeSpot::
    push af                                       ; $5EF1

jr_007_5ef2:
    ld a, $06                                     ; $5EF2
    call Rng_Scaled                               ; $5EF4
    ld c, a                                       ; $5EF7
    ld b, $00                                     ; $5EF8
    ld hl, wScratch_CursorUpdate_D952             ; $5EFA
    add hl, bc                                    ; $5EFD
    ld a, [hl]                                    ; $5EFE
    and a                                         ; $5EFF
    jr nz, jr_007_5ef2                            ; $5F00

    pop af                                        ; $5F02
    ld [hl], a                                    ; $5F03
    ret                                           ; $5F04


; C: HL = 07:5F41, or 07:5F21 when $DADA is not 0
Scratch_PrizeTable::
    ld a, [wNameCardMade]                         ; $5F05
    and a                                         ; $5F08
    jr nz, jr_007_5f0f                            ; $5F09

    ld hl, $5f41                                  ; $5F0B
    ret                                           ; $5F0E


jr_007_5f0f:
    ld hl, Scratch_PrizeTable_Tbl5F21             ; $5F0F
    ret                                           ; $5F12


; C: HL = 07:5F51, or 07:5F31 when $DADA is not 0
Scratch_PrizeTableB::
    ld a, [wNameCardMade]                         ; $5F13
    and a                                         ; $5F16
    jr nz, jr_007_5f0f                            ; $5F17

    ld hl, $5f51                                  ; $5F19
    ret                                           ; $5F1C


    db $21, $31, $5f, $c9

; C: named by the code of Scratch_PrizeTable (07:5F0F); read in the runs by Scratch_DealSpots, Scratch_PickCardArt;
; first read on the screen Mode10_ScratchCard_State02 (trace/read_screens_kitty*.npz)
Scratch_PrizeTable_Tbl5F21::
    db $10, $10, $10, $10, $10, $10, $10, $11, $11, $11, $11, $11, $12, $12, $12, $13
    db $10, $10, $10, $10, $10, $10, $10, $11, $11, $11, $11, $12, $12, $13, $14, $14
    db $10, $10, $10, $10, $10, $10, $10, $11, $11, $11, $11, $11, $12, $12, $12, $12
    db $10, $10, $10, $10, $10, $10, $10, $11, $11, $11, $11, $12, $12, $12, $14, $14
    db $00, $5c, $30, $5e, $60, $60, $90, $62, $c0, $64, $f0, $66

; C: one of two card pictures at random ($D95B), $230 bytes of bank $33 into $8F40
Scratch_PickCardArt::
    call Rng_Next                                 ; $5F6D
    and $02                                       ; $5F70
    ld [wScratch_PickCardArt_D95B], a             ; $5F72
    ld c, a                                       ; $5F75
    ld b, $00                                     ; $5F76
    ld hl, Scratch_PrizeTable_Tbl5F21 + $40       ; $5F78
    add hl, bc                                    ; $5F7B
    ld e, [hl]                                    ; $5F7C
    inc hl                                        ; $5F7D
    ld d, [hl]                                    ; $5F7E
    ld hl, $8f40                                  ; $5F7F
    ld bc, $0230                                  ; $5F82
    ld a, $33                                     ; $5F85
    call Copy_FarDEtoHL                           ; $5F87
    call Rng_Next                                 ; $5F8A
    and $02                                       ; $5F8D
    ld [wScratch_PickCardArt_D95C], a             ; $5F8F
    ld c, a                                       ; $5F92
    ld b, $00                                     ; $5F93
    ld hl, Scratch_PrizeTable_Tbl5F21 + $44       ; $5F95
    add hl, bc                                    ; $5F98
    ld e, [hl]                                    ; $5F99
    inc hl                                        ; $5F9A
    ld d, [hl]                                    ; $5F9B
    ld hl, $9170                                  ; $5F9C
    ld bc, $0230                                  ; $5F9F
    ld a, $33                                     ; $5FA2
    call Copy_FarDEtoHL                           ; $5FA4
    call Rng_Next                                 ; $5FA7
    and $02                                       ; $5FAA
    ld [wScratch_PickCardArt_D95D], a             ; $5FAC
    ld c, a                                       ; $5FAF
    ld b, $00                                     ; $5FB0
    ld hl, Scratch_PrizeTable_Tbl5F21 + $48       ; $5FB2
    add hl, bc                                    ; $5FB5
    ld e, [hl]                                    ; $5FB6
    inc hl                                        ; $5FB7
    ld d, [hl]                                    ; $5FB8
    ld hl, $93a0                                  ; $5FB9
    ld bc, $0230                                  ; $5FBC
    ld a, $33                                     ; $5FBF
    call Copy_FarDEtoHL                           ; $5FC1
    jp Far_Return                                 ; $5FC4


; C: the card picture $D95B again into $8F40
Scratch_ReloadCardArt::
    ld a, [wScratch_PickCardArt_D95B]             ; $5FC7
    ld c, a                                       ; $5FCA
    ld b, $00                                     ; $5FCB
    ld hl, Scratch_PrizeTable_Tbl5F21 + $40       ; $5FCD
    add hl, bc                                    ; $5FD0
    ld e, [hl]                                    ; $5FD1
    inc hl                                        ; $5FD2
    ld d, [hl]                                    ; $5FD3
    ld hl, $8f40                                  ; $5FD4
    ld bc, $0230                                  ; $5FD7
    ld a, $33                                     ; $5FDA
    call Copy_FarDEtoHL                           ; $5FDC
    ld a, [wScratch_PickCardArt_D95C]             ; $5FDF
    ld c, a                                       ; $5FE2
    ld b, $00                                     ; $5FE3
    ld hl, Scratch_PrizeTable_Tbl5F21 + $44       ; $5FE5
    add hl, bc                                    ; $5FE8
    ld e, [hl]                                    ; $5FE9
    inc hl                                        ; $5FEA
    ld d, [hl]                                    ; $5FEB
    ld hl, $9170                                  ; $5FEC
    ld bc, $0230                                  ; $5FEF
    ld a, $33                                     ; $5FF2
    call Copy_FarDEtoHL                           ; $5FF4
    ld a, [wScratch_PickCardArt_D95D]             ; $5FF7
    ld c, a                                       ; $5FFA
    ld b, $00                                     ; $5FFB
    ld hl, Scratch_PrizeTable_Tbl5F21 + $48       ; $5FFD
    add hl, bc                                    ; $6000
    ld e, [hl]                                    ; $6001
    inc hl                                        ; $6002
    ld d, [hl]                                    ; $6003
    ld hl, $93a0                                  ; $6004
    ld bc, $0230                                  ; $6007
    ld a, $33                                     ; $600A
    call Copy_FarDEtoHL                           ; $600C
    jp Far_Return                                 ; $600F


; C: the first spot with bit 7 set into $D8F4
Scratch_FirstMarkedSpot::
    xor a                                         ; $6012
    ld hl, wScratch_CursorUpdate_D952             ; $6013

jr_007_6016:
    bit 7, [hl]                                   ; $6016
    jr nz, jr_007_6023                            ; $6018

    inc hl                                        ; $601A
    inc a                                         ; $601B
    cp $06                                        ; $601C
    jr nz, jr_007_6016                            ; $601E

    jp Far_Return                                 ; $6020


jr_007_6023:
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6023
    ld de, $5052                                  ; $6026
    ld b, BANK(ScriptSlots_Add)                   ; $6029
    ld hl, ScriptSlots_Add                        ; $602B
    call Far_Call                                 ; $602E
    jp Far_Return                                 ; $6031


; C: for spot 5 down to 0: the prize (low nibble) into $D95F and its drawing; runs on its screen (10:03) in the core
; replays (port/entry_modes_kitty.csv); code read
Scratch_DrawSpots::
    ld a, $05                                     ; $6034

jr_007_6036:
    push af                                       ; $6036
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6037
    ld c, a                                       ; $603A
    ld b, $00                                     ; $603B
    ld hl, wScratch_CursorUpdate_D952             ; $603D
    add hl, bc                                    ; $6040
    ld a, [hl]                                    ; $6041
    and $0f                                       ; $6042
    ld [wScratch_CursorUpdate_D95F], a            ; $6044
    ld de, $5052                                  ; $6047
    ld b, BANK(ScriptSlots_Add)                   ; $604A
    ld hl, ScriptSlots_Add                        ; $604C
    call Far_Call                                 ; $604F
    rst Rst08_WaitVBlank                          ; $6052
    pop af                                        ; $6053
    dec a                                         ; $6054
    cp $ff                                        ; $6055
    jr nz, jr_007_6036                            ; $6057

    jp Far_Return                                 ; $6059


; C: handler of state $00 of mode $10 (word 0 of Mode10_StateTable)
Mode10_State00::
    di                                            ; $605C
    call Lcd_Off                                  ; $605D
    call Oam_ClearShadow                          ; $6060
    ld b, BANK(Objects_ClearAll)                  ; $6063
    ld hl, Objects_ClearAll                       ; $6065
    call Far_Call                                 ; $6068
    ld b, BANK(ScriptSlots_Clear)                 ; $606B
    ld hl, ScriptSlots_Clear                      ; $606D
    call Far_Call                                 ; $6070
    call Serial_SetFarCallback                    ; $6073

    dwb Frame_UpdateAll

    xor a                                         ; $6079
    ld [wMode07_StateTable_D8E0], a               ; $607A
    ld [wScratch_CursorUpdate_D95E], a            ; $607D
    ld [wMode0F_State0F_D93F], a                  ; $6080
    ld [wMode10_State03_D940], a                  ; $6083
    ld a, $01                                     ; $6086
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6088
    ld b, BANK(Sram_LoadCardPhotos)               ; $608B
    ld hl, Sram_LoadCardPhotos                    ; $608D
    call Far_Call                                 ; $6090
    ld b, BANK(Scratch_ClearSpots)                ; $6093
    ld hl, Scratch_ClearSpots                     ; $6095
    call Far_Call                                 ; $6098
    ld b, BANK(Scratch_DealSpots)                 ; $609B
    ld hl, Scratch_DealSpots                      ; $609D
    call Far_Call                                 ; $60A0
    ld b, BANK(Scratch_PickCardArt)               ; $60A3
    ld hl, Scratch_PickCardArt                    ; $60A5
    call Far_Call                                 ; $60A8
    call Copy_FarInline                           ; $60AB

    db $00, $4e, $23, $00, $80, $50, $0d

    call Copy_FarInline                           ; $60B5

    db $00, $7b, $13, $00, $98, $40, $02

    push af                                       ; $60BF
    ld a, MUSIC_SCRATCH_CARD                      ; $60C0
    ld [wSndMusicReq], a                          ; $60C2
    pop af                                        ; $60C5
    call Lcd_SetupInline                          ; $60C6

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ei                                            ; $60D4
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 + $2D ; $60D5
    call Object_Create                            ; $60D8
    ld b, BANK(Scratch_HasPrize3)                 ; $60DB
    ld hl, Scratch_HasPrize3                      ; $60DD
    call Far_Call                                 ; $60E0
    jr nc, jr_007_60eb                            ; $60E3

    ld de, ObjScript_02_5702_Mode10_ScratchCard_State02 ; $60E5
    call Object_Create                            ; $60E8

jr_007_60eb:
    ld de, ObjScript_02_54E3_Scratch_CursorUpdate + $54 ; $60EB
    call Object_Create                            ; $60EE
    ld de, ObjScript_02_5691_Mode10_ScratchCard_State03 ; $60F1
    call Object_Create                            ; $60F4
    ld b, MODE_SCRATCH_CARD                       ; $60F7
    ld c, STATE_10_SCRATCH_CARD_BOARD             ; $60F9
    call Fade_GoTo                                ; $60FB
    ret                                           ; $60FE


; C: handler of state $01 of mode $10 (word 1 of Mode10_StateTable)
Mode10_State01::
    di                                            ; $60FF
    call Lcd_Off                                  ; $6100
    call Oam_ClearShadow                          ; $6103
    ld b, BANK(Objects_ClearAll)                  ; $6106
    ld hl, Objects_ClearAll                       ; $6108
    call Far_Call                                 ; $610B
    ld b, BANK(ScriptSlots_Clear)                 ; $610E
    ld hl, ScriptSlots_Clear                      ; $6110
    call Far_Call                                 ; $6113
    call Serial_SetFarCallback                    ; $6116

    dwb Frame_UpdateAll

    xor a                                         ; $611C
    ld [wMode07_StateTable_D8E0], a               ; $611D
    ld b, BANK(Sram_LoadCardPhotos)               ; $6120
    ld hl, Sram_LoadCardPhotos                    ; $6122
    call Far_Call                                 ; $6125
    ld b, BANK(Scratch_ReloadCardArt)             ; $6128
    ld hl, Scratch_ReloadCardArt                  ; $612A
    call Far_Call                                 ; $612D
    call Copy_FarInline                           ; $6130

    db $00, $4e, $23, $00, $80, $50, $0d

    call Copy_FarInline                           ; $613A

    db $00, $7b, $13, $00, $98, $40, $02

    ld b, BANK(Scratch_FirstMarkedSpot)           ; $6144
    ld hl, Scratch_FirstMarkedSpot                ; $6146
    call Far_Call                                 ; $6149
    push af                                       ; $614C
    ld a, MUSIC_SCRATCH_CARD                      ; $614D
    ld [wSndMusicReq], a                          ; $614F
    pop af                                        ; $6152
    call Lcd_SetupInline                          ; $6153

    db $87, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $09

    ei                                            ; $6161
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 + $2D ; $6162
    call Object_Create                            ; $6165
    ld b, BANK(Scratch_HasPrize3)                 ; $6168
    ld hl, Scratch_HasPrize3                      ; $616A
    call Far_Call                                 ; $616D
    jr nc, jr_007_6178                            ; $6170

    ld de, ObjScript_02_5702_Mode10_ScratchCard_State02 ; $6172
    call Object_Create                            ; $6175

jr_007_6178:
    ld de, ObjScript_02_54E3_Scratch_CursorUpdate + $54 ; $6178
    call Object_Create                            ; $617B
    ld de, ObjScript_02_5691_Mode10_ScratchCard_State03 ; $617E
    call Object_Create                            ; $6181
    ld b, MODE_SCRATCH_CARD                       ; $6184
    ld c, STATE_10_SCRATCH_CARD_BOARD             ; $6186
    call Fade_GoTo                                ; $6188
    ret                                           ; $618B


; C: handler of state $02 of mode $10 (word 2 of Mode10_StateTable)
Mode10_State02::
    ld a, [wMode07_StateTable_D8E0]               ; $618C
    bit 1, a                                      ; $618F
    jr z, jr_007_61a7                             ; $6191

    push af                                       ; $6193
    ld a, SFX1_1A                                 ; $6194
    ld [wSndSfx1], a                              ; $6196
    pop af                                        ; $6199
    ld a, $1c                                     ; $619A
    ld [wMode0E_State1E_D943], a                  ; $619C
    ld b, MODE_KITT_GAMES_HOST                    ; $619F
    ld c, $01                                     ; $61A1
    call Fade_GoToB                               ; $61A3
    ret                                           ; $61A6


jr_007_61a7:
    ld a, [wMode07_StateTable_D8E0]               ; $61A7
    bit 2, a                                      ; $61AA
    jr z, jr_007_61b2                             ; $61AC

    ld a, $03                                     ; $61AE
    ldh [hState], a                               ; $61B0

jr_007_61b2:
    ret                                           ; $61B2


; C: handler of state $03 of mode $10 (word 3 of Mode10_StateTable)
Mode10_State03::
    call Scratch_FindMarkedFwd                    ; $61B3
    and $0f                                       ; $61B6
    swap a                                        ; $61B8
    or b                                          ; $61BA
    ld e, a                                       ; $61BB
    call Scratch_FindMarkedBack                   ; $61BC
    and $0f                                       ; $61BF
    ld c, a                                       ; $61C1
    swap a                                        ; $61C2
    or b                                          ; $61C4
    ld d, a                                       ; $61C5
    ld a, e                                       ; $61C6
    swap a                                        ; $61C7
    and $0f                                       ; $61C9
    cp c                                          ; $61CB
    jr nz, jr_007_6209                            ; $61CC

    sla a                                         ; $61CE
    ld c, a                                       ; $61D0
    ld b, $00                                     ; $61D1
    ld hl, Mode10_State03_Tbl623A                 ; $61D3
    add hl, bc                                    ; $61D6
    ld a, [hl+]                                   ; $61D7
    ld [wMode0F_State0F_D93F], a                  ; $61D8
    ld a, [hl+]                                   ; $61DB
    ld [wMode10_State03_D940], a                  ; $61DC
    push de                                       ; $61DF
    ld a, e                                       ; $61E0
    call Scratch_PrizeWord                        ; $61E1
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 ; $61E4
    call Object_CreateWithParam                   ; $61E7
    pop de                                        ; $61EA
    ld a, d                                       ; $61EB
    call Scratch_PrizeWord                        ; $61EC
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 ; $61EF
    call Object_CreateWithParam                   ; $61F2
    ld b, BANK(Scratch_DrawSpots)                 ; $61F5
    ld hl, Scratch_DrawSpots                      ; $61F7
    call Far_Call                                 ; $61FA
    push af                                       ; $61FD
    ld a, SFX1_2F                                 ; $61FE
    ld [wSndSfx1], a                              ; $6200
    pop af                                        ; $6203
    ld a, $04                                     ; $6204
    ldh [hState], a                               ; $6206
    ret                                           ; $6208


jr_007_6209:
    xor a                                         ; $6209
    ld [wMode0F_State0F_D93F], a                  ; $620A
    ld [wMode10_State03_D940], a                  ; $620D
    push de                                       ; $6210
    ld a, e                                       ; $6211
    call Scratch_PrizeWord                        ; $6212
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 + $D ; $6215
    call Object_CreateWithParam                   ; $6218
    pop de                                        ; $621B
    ld a, d                                       ; $621C
    call Scratch_PrizeWord                        ; $621D
    ld de, ObjScript_02_56A9_Mode10_ScratchCard_State02 + $D ; $6220
    call Object_CreateWithParam                   ; $6223
    ld b, BANK(Scratch_DrawSpots)                 ; $6226
    ld hl, Scratch_DrawSpots                      ; $6228
    call Far_Call                                 ; $622B
    push af                                       ; $622E
    ld a, SFX1_10                                 ; $622F
    ld [wSndSfx1], a                              ; $6231
    pop af                                        ; $6234
    ld a, $05                                     ; $6235
    ldh [hState], a                               ; $6237
    ret                                           ; $6239


; C: named by the code of Mode10_State03 (07:61D3); read in the runs by Mode10_State03; first read on the screen
; Mode10_ScratchCard_State03 (trace/read_screens_kitty*.npz)
Mode10_State03_Tbl623A::
    db $20, $00, $40, $00, $60, $00, $00, $01

; C: B = index of the first spot of $D952 with bit 7 set (NZ), searching up
Scratch_FindMarkedFwd::
    ld c, $06                                     ; $6242
    ld b, $00                                     ; $6244
    ld hl, wScratch_CursorUpdate_D952             ; $6246

jr_007_6249:
    ld a, [hl+]                                   ; $6249
    bit 7, a                                      ; $624A
    ret nz                                        ; $624C

    inc b                                         ; $624D
    dec c                                         ; $624E
    jr nz, jr_007_6249                            ; $624F

; C: the same searching down from $D957
Scratch_FindMarkedBack::
    ld c, $06                                     ; $6251
    ld b, $05                                     ; $6253
    ld hl, wScratch_FindMarkedBack_D957           ; $6255

jr_007_6258:
    ld a, [hl-]                                   ; $6258
    bit 7, a                                      ; $6259
    ret nz                                        ; $625B

    dec b                                         ; $625C
    dec c                                         ; $625D
    jr nz, jr_007_6258                            ; $625E

; C: BC = word (A & $F) of 07:626F
Scratch_PrizeWord::
    and $0f                                       ; $6260
    sla a                                         ; $6262
    ld c, a                                       ; $6264
    ld b, $00                                     ; $6265
    ld hl, Scratch_PrizeWord_Tbl626F              ; $6267
    add hl, bc                                    ; $626A
    ld c, [hl]                                    ; $626B
    inc hl                                        ; $626C
    ld b, [hl]                                    ; $626D
    ret                                           ; $626E


; C: named by the code of Scratch_PrizeWord (07:6267); read in the runs by Scratch_PrizeWord; first read on the screen
; Mode10_ScratchCard_State03 (trace/read_screens_kitty*.npz)
Scratch_PrizeWord_Tbl626F::
    db $10, $08, $40, $08, $70, $08, $10, $50, $40, $50, $70, $50

; C: handler of state $04 of mode $10 (word 4 of Mode10_StateTable)
Mode10_State04::
    ld a, [wMode07_StateTable_D8E0]               ; $627B
    bit 3, a                                      ; $627E
    jr z, jr_007_62a5                             ; $6280

    ld a, [wMode10_State03_D940]                  ; $6282
    cp $01                                        ; $6285
    jr nz, jr_007_628d                            ; $6287

    ld a, $2c                                     ; $6289
    jr jr_007_629a                                ; $628B

jr_007_628d:
    ld a, [wMode0F_State0F_D93F]                  ; $628D
    cp $60                                        ; $6290
    jr nz, jr_007_6298                            ; $6292

    ld a, $30                                     ; $6294
    jr jr_007_629a                                ; $6296

jr_007_6298:
    ld a, $14                                     ; $6298

jr_007_629a:
    ld [wMode0E_State1E_D943], a                  ; $629A
    ld b, MODE_KITT_GAMES_HOST                    ; $629D
    ld c, $01                                     ; $629F
    call Fade_GoToB                               ; $62A1
    ret                                           ; $62A4


jr_007_62a5:
    ret                                           ; $62A5


; C: handler of state $05 of mode $10 (word 5 of Mode10_StateTable)
Mode10_State05::
    ld a, [wMode07_StateTable_D8E0]               ; $62A6
    bit 3, a                                      ; $62A9
    jr z, jr_007_62ba                             ; $62AB

    ld a, $20                                     ; $62AD
    ld [wMode0E_State1E_D943], a                  ; $62AF
    ld b, MODE_KITT_GAMES_HOST                    ; $62B2
    ld c, $01                                     ; $62B4
    call Fade_GoToB                               ; $62B6
    ret                                           ; $62B9


jr_007_62ba:
    ret                                           ; $62BA


; C: ModeTable entry $10: BGB screen 10:02 (scratch card board)
Mode10_ScratchCard::
    ldh a, [hState]                               ; $62BB
    ld hl, Mode10_StateTable                      ; $62BD
    call JumpTable_ByA                            ; $62C0
    jp Far_Return                                 ; $62C3


; C: state table of mode $10, read by $0189 with hFF8E
Mode10_StateTable::
    dw Mode10_State00
    dw Mode10_State01
    dw Mode10_State02
    dw Mode10_State03
    dw Mode10_State04
    dw Mode10_State05

    db $fd, $25, $02, $09, $0e, $86, $67, $a6, $a0, $9c, $a4, $18, $86, $86, $86, $fd
    db $31, $e7, $eb, $9b, $8e, $7f, $31, $86, $1c, $27, $ff, $fd, $01, $4b, $05, $01
    db $86, $e8, $eb, $b4, $d0, $db, $db, $3c, $25, $27, $fd, $00, $0e, $2f, $3f, $1f
    db $2a, $7c, $ff, $fd, $40, $2b, $3f, $00, $0e, $43, $7c, $86, $86, $86, $86, $86
    db $86, $86, $fd, $ff, $fd, $9b, $6c, $7f, $2e, $86, $02, $36, $05, $0b, $12, $86
    db $86, $86, $86, $fd, $22, $13, $15, $22, $40, $0d, $41, $05, $2f, $0d, $01, $3c
    db $25, $27, $ff, $fd, $19, $23, $07, $3f, $06, $0f, $28, $86, $0f, $07, $0a, $2f
    db $86, $86, $fd, $b4, $d0, $db, $db, $2e, $86, $00, $35, $2a, $25, $27, $ff, $fd
    db $0e, $2b, $38, $4c, $00, $86, $32, $2f, $41, $4b, $12, $7b, $86, $86, $fd, $ff
    db $fd, $04, $23, $4b, $7c, $86, $86, $86, $86, $86, $86, $86, $86, $86, $86, $fd
    db $b4, $d0, $db, $db, $32, $86, $0f, $29, $14, $01, $25, $27, $ff

; C: a text script of the Kitt host, read by KittHost_TextStep (a word of Mode0E_State00_Tbl668C points to it); kept
; as a label since the puzzle runs of 2026-11-14 joined the read spans 07:62C6-6476 into one block
KittHost_TextStep_Tbl637F::
    db $fd, $0e, $2b, $38, $4c, $00, $86, $1e, $0f, $06, $12, $17, $27, $86, $86, $fd
    db $96, $56, $96, $56, $7b, $ff

; C: the 15 puzzle's text script of the Kitt host (the word at 07:669C of Mode0E_State00_Tbl668C), read by
; KittHost_TextStep since the puzzle runs of 2026-11-14 (tools/kitty_puzzle.py); was Mode0E_State00_Tbl668C_Entry6395,
; never read
KittHost_TextStep_Tbl6395::
    db $fd, $04, $21, $3f, $13, $02, $7b, $7b, $86, $86, $86, $86, $86, $86, $86, $fd
    db $fa, $f9, $f8, $b4, $d0, $db, $db, $86, $9d, $80, $8f, $84, $68, $7b, $ff, $fd
    db $0e, $2b, $05, $28, $86, $56, $7d, $61, $68, $eb, $1e, $01, $86, $86, $fd, $05
    db $2f, $0d, $01, $86, $04, $21, $3f, $13, $02, $7b, $ff, $fd, $11, $33, $05, $28
    db $86, $00, $0f, $28, $0b, $07, $86, $86, $86, $86, $fd, $4f, $5a, $76, $7d, $4f
    db $86, $32, $03, $28, $44, $2a, $25, $27, $ff

; C: a text script of the Kitt host, read by KittHost_TextStep; kept as a label since the puzzle runs of 2026-11-14
; joined the read spans
KittHost_TextStep_Tbl63EE::
    db $fd, $1e, $3c, $86, $13, $10, $4d, $02, $3c, $08, $40, $86, $86, $86, $86, $fd
    db $23, $21, $10, $4c, $02, $18, $7c, $ff, $fd, $9d, $7e, $84, $68, $0b, $0f, $29
    db $86, $0b, $4c, $0b, $2f, $2e, $86, $fd, $13, $4b, $0f, $29, $0c, $2a, $13, $86
    db $01, $01, $25, $27, $ff

; C: a text script of the Kitt host, read by KittHost_TextStep; kept as a label since the puzzle runs of 2026-11-14
; joined the read spans
KittHost_TextStep_Tbl6423::
    INCBIN "data/bank_07/KittHost_TextStep_Tbl6423.bin" ; $6423, 344 bytes
; C: when hFF9D bit 0 is clear: the text of entry [$D946] of the pointer table [$D944]; runs on its screen (0E:03) in
; the core replays (port/entry_modes_kitty.csv); code read
KittHost_TextStep::
    ldh a, [hFrameCounter]                        ; $657B
    and $01                                       ; $657D
    ret nz                                        ; $657F

jr_007_6580:
    ld a, [wKittHost_TextStep_D946]               ; $6580
    sla a                                         ; $6583
    ld c, a                                       ; $6585
    ld b, $00                                     ; $6586
    ld a, [wKittHost_TextStep_D944]               ; $6588
    ld l, a                                       ; $658B
    ld a, [wKittHost_TextStep_D945]               ; $658C
    ld h, a                                       ; $658F
    add hl, bc                                    ; $6590
    ld a, [hl+]                                   ; $6591
    ld h, [hl]                                    ; $6592
    ld l, a                                       ; $6593
    ld a, [wKittHost_TextStep_D947]               ; $6594
    ld c, a                                       ; $6597
    ld b, $00                                     ; $6598
    add hl, bc                                    ; $659A
    ld a, [hl]                                    ; $659B
    cp $ff                                        ; $659C
    jp z, Jump_007_65ec                           ; $659E

    cp $fe                                        ; $65A1
    jp z, Jump_007_65c2                           ; $65A3

    cp $fd                                        ; $65A6
    jp z, Jump_007_65d7                           ; $65A8

    cp $fb                                        ; $65AB
    jp z, Jump_007_65ee                           ; $65AD

    cp $fa                                        ; $65B0
    jp z, Jump_007_65f5                           ; $65B2

    cp $f9                                        ; $65B5
    jp z, Jump_007_6600                           ; $65B7

    cp $f8                                        ; $65BA
    jp z, Jump_007_6607                           ; $65BC

    jp Jump_007_660e                              ; $65BF


Jump_007_65c2:
    ld hl, wKittHost_TextStep_D947                ; $65C2
    inc [hl]                                      ; $65C5
    ld a, $00                                     ; $65C6
    ld [wMode14_State01_D8EF], a                  ; $65C8
    ld a, $40                                     ; $65CB
    ld [wMode14_State01_D8F0], a                  ; $65CD
    ld a, $11                                     ; $65D0
    ld [wMode14_State01_D8F1], a                  ; $65D2
    jr jr_007_6580                                ; $65D5

Jump_007_65d7:
    ld hl, wKittHost_TextStep_D947                ; $65D7
    inc [hl]                                      ; $65DA
    ld a, $00                                     ; $65DB
    ld [wMode14_State01_D8EF], a                  ; $65DD
    ld a, $60                                     ; $65E0
    ld [wMode14_State01_D8F0], a                  ; $65E2
    ld a, $12                                     ; $65E5
    ld [wMode14_State01_D8F1], a                  ; $65E7
    jr jr_007_6580                                ; $65EA

Jump_007_65ec:
    xor a                                         ; $65EC
    ret                                           ; $65ED


Jump_007_65ee:
    ld a, [wMode10_State03_D940]                  ; $65EE
    swap a                                        ; $65F1
    jr jr_007_660a                                ; $65F3

Jump_007_65f5:
    ld a, [wMode10_State03_D940]                  ; $65F5
    and $0f                                       ; $65F8
    jr nz, jr_007_660a                            ; $65FA

    ld a, $86                                     ; $65FC
    jr jr_007_660e                                ; $65FE

Jump_007_6600:
    ld a, [wMode0F_State0F_D93F]                  ; $6600
    swap a                                        ; $6603
    jr jr_007_660a                                ; $6605

Jump_007_6607:
    ld a, [wMode0F_State0F_D93F]                  ; $6607

jr_007_660a:
    and $0f                                       ; $660A
    add $e6                                       ; $660C

Jump_007_660e:
jr_007_660e:
    ld c, a                                       ; $660E
    ld b, $00                                     ; $660F
    sla c                                         ; $6611
    rl b                                          ; $6613
    sla c                                         ; $6615
    rl b                                          ; $6617
    sla c                                         ; $6619
    rl b                                          ; $661B
    sla c                                         ; $661D
    rl b                                          ; $661F
    sla c                                         ; $6621
    rl b                                          ; $6623
    ld a, [wMode14_State01_D8EF]                  ; $6625
    ld l, a                                       ; $6628
    ld a, [wMode14_State01_D8F0]                  ; $6629
    ld h, a                                       ; $662C
    add hl, bc                                    ; $662D
    ld e, l                                       ; $662E
    ld d, h                                       ; $662F
    ld a, [wKittHost_TextStep_D948]               ; $6630
    and $1f                                       ; $6633
    ld c, a                                       ; $6635
    ld b, $00                                     ; $6636
    sla c                                         ; $6638
    rl b                                          ; $663A
    sla c                                         ; $663C
    rl b                                          ; $663E
    sla c                                         ; $6640
    rl b                                          ; $6642
    sla c                                         ; $6644
    rl b                                          ; $6646
    sla c                                         ; $6648
    rl b                                          ; $664A
    ld hl, $9480                                  ; $664C
    add hl, bc                                    ; $664F
    ld bc, $0020                                  ; $6650
    ld a, [wMode14_State01_D8F1]                  ; $6653
    call Vram_CopyHBlankFar                       ; $6656
    ld a, [wKittHost_TextStep_D947]               ; $6659
    inc a                                         ; $665C
    ld [wKittHost_TextStep_D947], a               ; $665D
    ld a, [wKittHost_TextStep_D948]               ; $6660
    inc a                                         ; $6663
    ld [wKittHost_TextStep_D948], a               ; $6664
    ret                                           ; $6667


; C: $D941-$D942 = DE
KittHost_SetTextPtr::
    ld a, e                                       ; $6668
    ld [wKittHost_SetTextPtr_D941], a             ; $6669
    ld a, d                                       ; $666C
    ld [wKittHost_SetTextPtr_D942], a             ; $666D
    ret                                           ; $6670


; C: $D944-$D945 = DE
KittHost_SetTablePtr::
    ld a, e                                       ; $6671
    ld [wKittHost_TextStep_D944], a               ; $6672
    ld a, d                                       ; $6675
    ld [wKittHost_TextStep_D945], a               ; $6676
    ret                                           ; $6679


; C: A = byte [$D943] of the text [$D941], $D943 + 1
KittHost_NextTextByte::
    ld hl, wMode0E_State1E_D943                   ; $667A
    ld c, [hl]                                    ; $667D
    ld b, $00                                     ; $667E
    inc [hl]                                      ; $6680
    ld a, [wKittHost_SetTextPtr_D941]             ; $6681
    ld l, a                                       ; $6684
    ld a, [wKittHost_SetTextPtr_D942]             ; $6685
    ld h, a                                       ; $6688
    add hl, bc                                    ; $6689
    ld a, [hl+]                                   ; $668A
    ret                                           ; $668B


; C: named by the code of Mode0E_State00 (07:67A8); read in the runs by KittHost_NextTextByte, KittHost_TextStep;
; first read on the screen Mode0E_KittGamesHost_State03 (trace/read_screens_kitty*.npz)
Mode0E_State00_Tbl668C::
    db $d2, $62, $ed, $62, $05, $63, $16, $63, $35, $63, $51, $63, $62, $63
    dw KittHost_TextStep_Tbl637F
    db $95, $63, $b4, $63, $d0, $63
    dw KittHost_TextStep_Tbl63EE
    db $06, $64
    dw KittHost_TextStep_Tbl6423
    db $41, $64, $58, $64, $76, $64, $93, $64, $ac, $64, $cb, $64, $dc, $64, $f3, $64
    db $04, $65, $20, $65, $3d, $65, $5c, $65, $00, $04, $ff, $04, $01, $06, $ff, $fc
    db $02, $09, $ff, $fc, $03, $04, $ff, $10, $04, $04, $ff, $14, $05, $0b, $ff, $fc
    db $06, $04, $ff, $30, $07, $0c, $ff, $fc, $08, $0d, $ff, $fc, $09, $04, $ff, $28
    db $0a, $04, $ff, $1c, $0b, $10, $ff, $fc, $0c, $04, $ff, $1c, $00, $04, $ff, $04
    db $01, $12, $ff, $fc, $02, $15, $ff, $fc, $03, $04, $ff, $28, $04, $17, $ff, $fc
    db $05, $18, $ff, $fc, $06, $1b, $ff, $fc, $07, $1f, $ff, $fc, $08, $1d, $ff, $fc
    db $09, $15, $ff, $fc, $0a, $04, $ff, $10, $0b, $18, $ff, $fc, $0c, $18, $ff, $fc


; C: screen off, objects and slots cleared, $D8E0 / $D946 / $D947 = 0, ...; mode $0E state $01; runs on its screen
; (0E:01) in the core replays (port/entry_modes_kitty.csv); code read
KittHost_InitScreen::
    di                                            ; $6728
    call Lcd_Off                                  ; $6729
    call Oam_ClearShadow                          ; $672C
    ld b, BANK(Objects_ClearAll)                  ; $672F
    ld hl, Objects_ClearAll                       ; $6731
    call Far_Call                                 ; $6734
    ld b, BANK(ScriptSlots_Clear)                 ; $6737
    ld hl, ScriptSlots_Clear                      ; $6739
    call Far_Call                                 ; $673C
    xor a                                         ; $673F
    ld [wMode07_StateTable_D8E0], a               ; $6740
    ld [wKittHost_TextStep_D946], a               ; $6743
    ld [wKittHost_TextStep_D947], a               ; $6746
    ld [wKittHost_TextStep_D948], a               ; $6749
    ld a, $00                                     ; $674C
    ld [wMode14_State01_D8EF], a                  ; $674E
    ld a, $40                                     ; $6751
    ld [wMode14_State01_D8F0], a                  ; $6753
    ld a, $11                                     ; $6756
    ld [wMode14_State01_D8F1], a                  ; $6758
    call Copy_FarInline                           ; $675B

    db $80, $5f, $13, $00, $80, $00, $18

    ld hl, $9480                                  ; $6765
    ld de, $0000                                  ; $6768
    ld bc, $0380                                  ; $676B
    call Mem_FillWord                             ; $676E
    ld b, BANK(Kitts_DrawAt9420)                  ; $6771
    ld hl, Kitts_DrawAt9420                       ; $6773
    call Far_Call                                 ; $6776
    call Serial_SetFarCallback                    ; $6779

    dwb Frame_UpdateAll

    ret                                           ; $677F


; C: handler of state $00 of mode $0E (word 0 of Mode0E_StateTable)
Mode0E_State00::
    call KittHost_InitScreen                      ; $6780
    push af                                       ; $6783
    ld a, MUSIC_KITT_GAMES_HOST                   ; $6784
    ld [wSndMusicReq], a                          ; $6786
    pop af                                        ; $6789
    call Copy_FarInline                           ; $678A

    db $00, $6e, $1b, $00, $98, $40, $02

    call Lcd_SetupInline                          ; $6794

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld de, $66c0                                  ; $67A2
    call KittHost_SetTextPtr                      ; $67A5
    ld de, Mode0E_State00_Tbl668C                 ; $67A8
    call KittHost_SetTablePtr                     ; $67AB
    ei                                            ; $67AE
    ld b, MODE_KITT_GAMES_HOST                    ; $67AF
    ld c, $02                                     ; $67B1
    call Fade_GoTo                                ; $67B3
    ret                                           ; $67B6


; C: handler of state $01 of mode $0E (word 1 of Mode0E_StateTable)
Mode0E_State01::
    call KittHost_InitScreen                      ; $67B7
    push af                                       ; $67BA
    ld a, MUSIC_KITT_GAMES_HOST_0E_01             ; $67BB
    ld [wSndMusicReq], a                          ; $67BD
    pop af                                        ; $67C0
    call Copy_FarInline                           ; $67C1

    db $80, $77, $13, $00, $88, $80, $03

    call Copy_FarInline                           ; $67CB

    db $00, $76, $1b, $00, $98, $40, $02

    call Lcd_SetupInline                          ; $67D5

    db $83, $e4, $e4, $d0, $00, $00, $00, $00, $ff, $00, $01

    ld de, $66f4                                  ; $67E3
    call KittHost_SetTextPtr                      ; $67E6
    ld de, $66a6                                  ; $67E9
    call KittHost_SetTablePtr                     ; $67EC
    ei                                            ; $67EF
    ld b, MODE_KITT_GAMES_HOST                    ; $67F0
    ld c, $02                                     ; $67F2
    call Fade_GoTo                                ; $67F4
    ret                                           ; $67F7


; C: handler of state $02 of mode $0E (word 2 of Mode0E_StateTable)
Mode0E_State02::
    ld hl, $9480                                  ; $67F8
    ld de, $0000                                  ; $67FB
    ld bc, $0380                                  ; $67FE
    call Vram_FillSafe                            ; $6801
    xor a                                         ; $6804
    ld [wKittHost_TextStep_D947], a               ; $6805
    ld [wKittHost_TextStep_D948], a               ; $6808
    call KittHost_NextTextByte                    ; $680B
    ld [wKittHost_TextStep_D946], a               ; $680E
    ld a, $03                                     ; $6811
    ldh [hState], a                               ; $6813
    ret                                           ; $6815


; C: handler of state $03 of mode $0E (word 3 of Mode0E_StateTable)
Mode0E_State03::
    call KittHost_TextStep                        ; $6816
    ret nz                                        ; $6819

    call KittHost_NextTextByte                    ; $681A
    ldh [hState], a                               ; $681D
    ret                                           ; $681F


; C: handler of state $04 of mode $0E (word 4 of Mode0E_StateTable)
Mode0E_State04::
    ld bc, $4890                                  ; $6820
    ld de, ObjScript_02_5736_Mode0E_KittGamesHost_State15 ; $6823
    call Object_CreateWithParam                   ; $6826
    ld a, $05                                     ; $6829
    ldh [hState], a                               ; $682B
    ret                                           ; $682D


; C: handler of state $05 of mode $0E (word 5 of Mode0E_StateTable)
Mode0E_State05::
    ld a, [wKeysNew]                              ; $682E
    and PADF_A | PADF_B                           ; $6831
    jr z, jr_007_6849                             ; $6833

    push af                                       ; $6835
    ld a, SFX1_03                                 ; $6836
    ld [wSndSfx1], a                              ; $6838
    pop af                                        ; $683B
    call KittHost_NextTextByte                    ; $683C
    call KittHost_NextTextByte                    ; $683F
    ld [wMode0E_State1E_D943], a                  ; $6842
    ld a, $02                                     ; $6845
    ldh [hState], a                               ; $6847

jr_007_6849:
    ret                                           ; $6849


; C: handler of state $06 of mode $0E (word 6 of Mode0E_StateTable)
Mode0E_State06::
    xor a                                         ; $684A
    ld [wMenu07_CursorUpdate_D8F4], a             ; $684B
    ld bc, $5850                                  ; $684E
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $36 ; $6851
    call Object_CreateWithParam                   ; $6854
    ld bc, $5850                                  ; $6857
    ld de, ObjScript_02_594D_Mode0E_KittGamesHost_State13 ; $685A
    call Object_CreateWithParam                   ; $685D
    ld a, $07                                     ; $6860
    ldh [hState], a                               ; $6862
    ret                                           ; $6864


; C: handler of state $07 of mode $0E (word 7 of Mode0E_StateTable)
Mode0E_State07::
    ld a, [wMode07_StateTable_D8E0]               ; $6865
    bit 0, a                                      ; $6868
    jr z, jr_007_68cd                             ; $686A

    ldh a, [hMenuMode]                            ; $686C
    call JumpTable_Inline                         ; $686E

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0E_KittGamesHost_State08
; (trace/read_screens_kitty*.npz)
Mode0E_State07_JumpTbl6871::
    dw KittHost_PayPuzzle
    dw KittHost_Text1C

; C: Kitts_CheckAfford $0025, then Kitts_Subtract $0025 (25 Kitts, the 15 puzzle)
KittHost_PayPuzzle::
    ld de, $0025                                  ; $6875
    ld b, BANK(Kitts_CheckAfford)                 ; $6878
    ld hl, Kitts_CheckAfford                      ; $687A
    call Far_Call                                 ; $687D
    jr c, jr_007_68a9                             ; $6880

    push hl                                       ; $6882
    ld hl, wMode06_State0A_D896                   ; $6883
    set 0, [hl]                                   ; $6886
    pop hl                                        ; $6888
    ld de, $0025                                  ; $6889
    ld b, BANK(Kitts_Subtract)                    ; $688C
    ld hl, Kitts_Subtract                         ; $688E
    call Far_Call                                 ; $6891
    push hl                                       ; $6894
    ld hl, wMode06_State0A_D896                   ; $6895
    res 0, [hl]                                   ; $6898
    pop hl                                        ; $689A
    ld bc, $804d                                  ; $689B
    ld de, ObjScript_02_598B_Mode0E_KittGamesHost_State08 + $45 ; $689E
    call Object_CreateWithParam                   ; $68A1
    ld a, $08                                     ; $68A4
    ldh [hState], a                               ; $68A6
    ret                                           ; $68A8


jr_007_68a9:
    push hl                                       ; $68A9
    ld hl, wMode06_State0A_D896                   ; $68AA
    set 0, [hl]                                   ; $68AD
    pop hl                                        ; $68AF
    ld b, BANK(Counters_Store)                    ; $68B0
    ld hl, Counters_Store                         ; $68B2
    call Far_Call                                 ; $68B5
    push hl                                       ; $68B8
    ld hl, wMode06_State0A_D896                   ; $68B9
    res 0, [hl]                                   ; $68BC
    pop hl                                        ; $68BE
    ld a, $18                                     ; $68BF
    jr jr_007_68c5                                ; $68C1

; C: $D943 = $1C, state 2
KittHost_Text1C::
    ld a, $1c                                     ; $68C3

jr_007_68c5:
    ld [wMode0E_State1E_D943], a                  ; $68C5
    ld a, $02                                     ; $68C8
    ldh [hState], a                               ; $68CA
    ret                                           ; $68CC


jr_007_68cd:
    call Rng_Next                                 ; $68CD
    ret                                           ; $68D0


; C: handler of state $08 of mode $0E (word 8 of Mode0E_StateTable)
Mode0E_State08::
    ld a, [wMode07_StateTable_D8E0]               ; $68D1
    bit 0, a                                      ; $68D4
    jr z, jr_007_68e1                             ; $68D6

    ld a, $08                                     ; $68D8
    ld [wMode0E_State1E_D943], a                  ; $68DA
    ld a, $02                                     ; $68DD
    ldh [hState], a                               ; $68DF

jr_007_68e1:
    ret                                           ; $68E1


; C: handler of state $09 of mode $0E (word 9 of Mode0E_StateTable)
Mode0E_State09::
    xor a                                         ; $68E2
    ld [wMenu07_CursorUpdate_D8F4], a             ; $68E3
    ld b, BANK(Counters_Load)                     ; $68E6
    ld hl, Counters_Load                          ; $68E8
    call Far_Call                                 ; $68EB
    ld a, [wPuzzleDrawingsDone]                   ; $68EE
    cp $05                                        ; $68F1
    jr z, jr_007_690c                             ; $68F3

    ld a, [wAlbum_SlotOp6D18_D932]                ; $68F5
    cp $00                                        ; $68F8
    jr nz, jr_007_6904                            ; $68FA

    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $F4 ; $68FC
    ld bc, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $1E ; $68FF
    jr jr_007_6921                                ; $6902

jr_007_6904:
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $D6 ; $6904
    ld bc, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $18 ; $6907
    jr jr_007_6921                                ; $690A

jr_007_690c:
    ld a, [wAlbum_SlotOp6D18_D932]                ; $690C
    cp $00                                        ; $690F
    jr nz, jr_007_691b                            ; $6911

    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $B0 ; $6913
    ld bc, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $12 ; $6916
    jr jr_007_6921                                ; $6919

jr_007_691b:
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $8A ; $691B
    ld bc, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $C ; $691E

jr_007_6921:
    push bc                                       ; $6921
    ld bc, $5850                                  ; $6922
    call Object_CreateWithParam                   ; $6925
    pop de                                        ; $6928
    ld bc, $5850                                  ; $6929
    call Object_CreateWithParam                   ; $692C
    ld a, $0a                                     ; $692F
    ldh [hState], a                               ; $6931
    ret                                           ; $6933


; C: handler of state $0A of mode $0E (word 10 of Mode0E_StateTable)
Mode0E_State0A::
    ld a, [wMode07_StateTable_D8E0]               ; $6934
    bit 0, a                                      ; $6937
    jr z, jr_007_6949                             ; $6939

    ldh a, [hMenuMode]                            ; $693B
    ld [wPuzzleKind], a                           ; $693D
    ld a, $0c                                     ; $6940
    ld [wMode0E_State1E_D943], a                  ; $6942
    ld a, $02                                     ; $6945
    ldh [hState], a                               ; $6947

jr_007_6949:
    ret                                           ; $6949


; C: handler of state $0B of mode $0E (word 11 of Mode0E_StateTable)
Mode0E_State0B::
    ld b, $3c                                     ; $694A

jr_007_694c:
    rst Rst08_WaitVBlank                          ; $694C
    dec b                                         ; $694D
    jr nz, jr_007_694c                            ; $694E

    ld b, MODE_FIFTEEN_PUZZLE                     ; $6950
    ld c, $00                                     ; $6952
    call Fade_GoToB                               ; $6954
    ret                                           ; $6957


; C: handler of state $0C of mode $0E (word 12 of Mode0E_StateTable)
Mode0E_State0C::
    ld b, $3c                                     ; $6958

jr_007_695a:
    rst Rst08_WaitVBlank                          ; $695A
    dec b                                         ; $695B
    jr nz, jr_007_695a                            ; $695C

    ld b, MODE_PLAY_MENU                          ; $695E
    ld c, $00                                     ; $6960
    call Fade_GoToB                               ; $6962
    ret                                           ; $6965


; C: handler of state $10 of mode $0E (word 16 of Mode0E_StateTable)
Mode0E_State10::
    di                                            ; $6966
    ld a, $01                                     ; $6967
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6969
    ld bc, $5850                                  ; $696C
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $5C ; $696F
    call Object_CreateWithParam                   ; $6972
    ld bc, $5850                                  ; $6975
    ld de, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $6 ; $6978
    call Object_CreateWithParam                   ; $697B
    ei                                            ; $697E
    ld a, $11                                     ; $697F
    ldh [hState], a                               ; $6981
    ret                                           ; $6983


; C: handler of state $11 of mode $0E (word 17 of Mode0E_StateTable)
Mode0E_State11::
    ld a, [wMode07_StateTable_D8E0]               ; $6984
    bit 0, a                                      ; $6987
    jr z, jr_007_69a6                             ; $6989

    ldh a, [hMenuMode]                            ; $698B
    call JumpTable_Inline                         ; $698D

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0E_KittGamesHost_State03
; (trace/read_screens_kitty*.npz)
Mode0E_State11_JumpTbl6990::
    dw KittHost_Text1C_B
    dw KittHost_StartPuzzle

; C: $D943 = $1C, state 2
KittHost_Text1C_B::
    ld a, $1c                                     ; $6994
    ld [wMode0E_State1E_D943], a                  ; $6996
    ld a, $02                                     ; $6999
    ldh [hState], a                               ; $699B
    ret                                           ; $699D


; C: fade to mode $0F state $01 (the 15 puzzle)
KittHost_StartPuzzle::
    ld b, MODE_FIFTEEN_PUZZLE                     ; $699E
    ld c, $01                                     ; $69A0
    call Fade_GoToB                               ; $69A2
    ret                                           ; $69A5


jr_007_69a6:
    ret                                           ; $69A6


; C: handler of state $0D of mode $0E (word 13 of Mode0E_StateTable)
Mode0E_State0D::
    ld bc, $4890                                  ; $69A7
    ld de, ObjScript_02_5736_Mode0E_KittGamesHost_State15 ; $69AA
    call Object_CreateWithParam                   ; $69AD
    ld a, $0e                                     ; $69B0
    ldh [hState], a                               ; $69B2
    ret                                           ; $69B4


; C: handler of state $0E of mode $0E (word 14 of Mode0E_StateTable)
Mode0E_State0E::
    ld a, [wKeysNew]                              ; $69B5
    and PADF_A | PADF_B                           ; $69B8
    jr z, jr_007_69ee                             ; $69BA

    push af                                       ; $69BC
    ld a, SFX1_03                                 ; $69BD
    ld [wSndSfx1], a                              ; $69BF
    pop af                                        ; $69C2
    push hl                                       ; $69C3
    ld hl, wMode06_State0A_D896                   ; $69C4
    set 0, [hl]                                   ; $69C7
    pop hl                                        ; $69C9
    ld a, [wMode0F_State0F_D93F]                  ; $69CA
    ld e, a                                       ; $69CD
    ld a, [wMode10_State03_D940]                  ; $69CE
    ld d, a                                       ; $69D1
    ld b, BANK(Kitts_Add)                         ; $69D2
    ld hl, Kitts_Add                              ; $69D4
    call Far_Call                                 ; $69D7
    push hl                                       ; $69DA
    ld hl, wMode06_State0A_D896                   ; $69DB
    res 0, [hl]                                   ; $69DE
    pop hl                                        ; $69E0
    ld bc, $804d                                  ; $69E1
    ld de, ObjScript_02_598B_Mode0E_KittGamesHost_State08 + $90 ; $69E4
    call Object_CreateWithParam                   ; $69E7
    ld a, $0f                                     ; $69EA
    ldh [hState], a                               ; $69EC

jr_007_69ee:
    ret                                           ; $69EE


; C: handler of state $0F of mode $0E (word 15 of Mode0E_StateTable)
Mode0E_State0F::
    ld a, [wMode07_StateTable_D8E0]               ; $69EF
    bit 0, a                                      ; $69F2
    jr z, jr_007_6a3a                             ; $69F4

    ld a, [wPuzzleKind]                           ; $69F6
    cp $00                                        ; $69F9
    jr nz, jr_007_6a31                            ; $69FB

    ld b, BANK(Counters_Load)                     ; $69FD
    ld hl, Counters_Load                          ; $69FF
    call Far_Call                                 ; $6A02
    ld a, [wPuzzleDrawingsDone]                   ; $6A05
    cp $05                                        ; $6A08
    jr z, jr_007_6a31                             ; $6A0A

    inc a                                         ; $6A0C
    ld [wPuzzleDrawingsDone], a                   ; $6A0D
    push hl                                       ; $6A10
    ld hl, wMode06_State0A_D896                   ; $6A11
    set 0, [hl]                                   ; $6A14
    pop hl                                        ; $6A16
    ld b, BANK(Counters_Store)                    ; $6A17
    ld hl, Counters_Store                         ; $6A19
    call Far_Call                                 ; $6A1C
    push hl                                       ; $6A1F
    ld hl, wMode06_State0A_D896                   ; $6A20
    res 0, [hl]                                   ; $6A23
    pop hl                                        ; $6A25
    ld a, [wPuzzleDrawingsDone]                   ; $6A26
    cp $05                                        ; $6A29
    jr nz, jr_007_6a31                            ; $6A2B

    ld a, $24                                     ; $6A2D
    jr jr_007_6a33                                ; $6A2F

jr_007_6a31:
    ld a, $1c                                     ; $6A31

jr_007_6a33:
    ld [wMode0E_State1E_D943], a                  ; $6A33
    ld a, $02                                     ; $6A36
    ldh [hState], a                               ; $6A38

jr_007_6a3a:
    ret                                           ; $6A3A


; C: handler of state $12 of mode $0E (word 18 of Mode0E_StateTable)
Mode0E_State12::
    xor a                                         ; $6A3B
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6A3C
    ld bc, $5850                                  ; $6A3F
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $36 ; $6A42
    call Object_CreateWithParam                   ; $6A45
    ld bc, $5850                                  ; $6A48
    ld de, ObjScript_02_594D_Mode0E_KittGamesHost_State13 ; $6A4B
    call Object_CreateWithParam                   ; $6A4E
    ld a, $13                                     ; $6A51
    ldh [hState], a                               ; $6A53
    ret                                           ; $6A55


; C: handler of state $13 of mode $0E (word 19 of Mode0E_StateTable)
Mode0E_State13::
    ld a, [wMode07_StateTable_D8E0]               ; $6A56
    bit 0, a                                      ; $6A59
    jr z, jr_007_6abe                             ; $6A5B

    ldh a, [hMenuMode]                            ; $6A5D
    call JumpTable_Inline                         ; $6A5F

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0E_KittGamesHost_State14
; (trace/read_screens_kitty*.npz)
Mode0E_State13_JumpTbl6A62::
    dw KittHost_PayScratch
    dw KittHost_Text10

; C: Kitts_CheckAfford $0010, then Kitts_Subtract $0010 (10 Kitts, the scratch card)
KittHost_PayScratch::
    ld de, $0010                                  ; $6A66
    ld b, BANK(Kitts_CheckAfford)                 ; $6A69
    ld hl, Kitts_CheckAfford                      ; $6A6B
    call Far_Call                                 ; $6A6E
    jr c, jr_007_6a9a                             ; $6A71

    push hl                                       ; $6A73
    ld hl, wMode06_State0A_D896                   ; $6A74
    set 0, [hl]                                   ; $6A77
    pop hl                                        ; $6A79
    ld de, $0010                                  ; $6A7A
    ld b, BANK(Kitts_Subtract)                    ; $6A7D
    ld hl, Kitts_Subtract                         ; $6A7F
    call Far_Call                                 ; $6A82
    push hl                                       ; $6A85
    ld hl, wMode06_State0A_D896                   ; $6A86
    res 0, [hl]                                   ; $6A89
    pop hl                                        ; $6A8B
    ld bc, $804d                                  ; $6A8C
    ld de, ObjScript_02_598B_Mode0E_KittGamesHost_State08 + $DB ; $6A8F
    call Object_CreateWithParam                   ; $6A92
    ld a, $14                                     ; $6A95
    ldh [hState], a                               ; $6A97
    ret                                           ; $6A99


jr_007_6a9a:
    push hl                                       ; $6A9A
    ld hl, wMode06_State0A_D896                   ; $6A9B
    set 0, [hl]                                   ; $6A9E
    pop hl                                        ; $6AA0
    ld b, BANK(Counters_Store)                    ; $6AA1
    ld hl, Counters_Store                         ; $6AA3
    call Far_Call                                 ; $6AA6
    push hl                                       ; $6AA9
    ld hl, wMode06_State0A_D896                   ; $6AAA
    res 0, [hl]                                   ; $6AAD
    pop hl                                        ; $6AAF
    ld a, $0c                                     ; $6AB0
    jr jr_007_6ab6                                ; $6AB2

; C: $D943 = $10, state 2
KittHost_Text10::
    ld a, $10                                     ; $6AB4

jr_007_6ab6:
    ld [wMode0E_State1E_D943], a                  ; $6AB6
    ld a, $02                                     ; $6AB9
    ldh [hState], a                               ; $6ABB
    ret                                           ; $6ABD


jr_007_6abe:
    call Rng_Next                                 ; $6ABE
    ret                                           ; $6AC1


; C: handler of state $14 of mode $0E (word 20 of Mode0E_StateTable)
Mode0E_State14::
    ld a, [wMode07_StateTable_D8E0]               ; $6AC2
    bit 0, a                                      ; $6AC5
    jr z, jr_007_6ad2                             ; $6AC7

    ld a, $08                                     ; $6AC9
    ld [wMode0E_State1E_D943], a                  ; $6ACB
    ld a, $02                                     ; $6ACE
    ldh [hState], a                               ; $6AD0

jr_007_6ad2:
    ret                                           ; $6AD2


; C: handler of state $15 of mode $0E (word 21 of Mode0E_StateTable)
Mode0E_State15::
    ld bc, $4890                                  ; $6AD3
    ld de, ObjScript_02_5736_Mode0E_KittGamesHost_State15 ; $6AD6
    call Object_CreateWithParam                   ; $6AD9
    ld a, $16                                     ; $6ADC
    ldh [hState], a                               ; $6ADE
    ret                                           ; $6AE0


; C: handler of state $16 of mode $0E (word 22 of Mode0E_StateTable)
Mode0E_State16::
    ld a, [wKeysNew]                              ; $6AE1
    and PADF_A | PADF_B                           ; $6AE4
    jr z, jr_007_6af6                             ; $6AE6

    push af                                       ; $6AE8
    ld a, SFX1_03                                 ; $6AE9
    ld [wSndSfx1], a                              ; $6AEB
    pop af                                        ; $6AEE
    ld b, MODE_SCRATCH_CARD                       ; $6AEF
    ld c, $00                                     ; $6AF1
    call Fade_GoToB                               ; $6AF3

jr_007_6af6:
    ret                                           ; $6AF6


; C: handler of state $1F of mode $0E (word 31 of Mode0E_StateTable)
Mode0E_State1F::
    di                                            ; $6AF7
    ld a, $01                                     ; $6AF8
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6AFA
    ld bc, $5850                                  ; $6AFD
    ld de, ObjScript_02_584A_KittHost_YesNoCursor + $5C ; $6B00
    call Object_CreateWithParam                   ; $6B03
    ld bc, $5850                                  ; $6B06
    ld de, ObjScript_02_594D_Mode0E_KittGamesHost_State13 + $6 ; $6B09
    call Object_CreateWithParam                   ; $6B0C
    ei                                            ; $6B0F
    ld a, $20                                     ; $6B10
    ldh [hState], a                               ; $6B12
    ret                                           ; $6B14


; C: handler of state $20 of mode $0E (word 32 of Mode0E_StateTable)
Mode0E_State20::
    ld a, [wMode07_StateTable_D8E0]               ; $6B15
    bit 0, a                                      ; $6B18
    jr z, jr_007_6b37                             ; $6B1A

    ldh a, [hMenuMode]                            ; $6B1C
    call JumpTable_Inline                         ; $6B1E

; C: read in the runs by JumpTable_Inline; first read on the screen Mode0E_KittGamesHost_State03
; (trace/read_screens_kitty*.npz)
Mode0E_State20_JumpTbl6B21::
    dw KittHost_Text10_B
    dw KittHost_StartScratch

; C: $D943 = $10, state 2
KittHost_Text10_B::
    ld a, $10                                     ; $6B25
    ld [wMode0E_State1E_D943], a                  ; $6B27
    ld a, $02                                     ; $6B2A
    ldh [hState], a                               ; $6B2C
    ret                                           ; $6B2E


; C: fade to mode $10 state $01 (the scratch card)
KittHost_StartScratch::
    ld b, MODE_SCRATCH_CARD                       ; $6B2F
    ld c, $01                                     ; $6B31
    call Fade_GoToB                               ; $6B33
    ret                                           ; $6B36


jr_007_6b37:
    ret                                           ; $6B37


; C: handler of state $18 of mode $0E (word 24 of Mode0E_StateTable)
Mode0E_State18::
    ld bc, $4890                                  ; $6B38
    ld de, ObjScript_02_5736_Mode0E_KittGamesHost_State15 ; $6B3B
    call Object_CreateWithParam                   ; $6B3E
    ld a, $19                                     ; $6B41
    ldh [hState], a                               ; $6B43
    ret                                           ; $6B45


; C: handler of state $19 of mode $0E (word 25 of Mode0E_StateTable)
Mode0E_State19::
    ld a, [wKeysNew]                              ; $6B46
    and PADF_A | PADF_B                           ; $6B49
    jr z, jr_007_6b7f                             ; $6B4B

    push af                                       ; $6B4D
    ld a, SFX1_03                                 ; $6B4E
    ld [wSndSfx1], a                              ; $6B50
    pop af                                        ; $6B53
    push hl                                       ; $6B54
    ld hl, wMode06_State0A_D896                   ; $6B55
    set 0, [hl]                                   ; $6B58
    pop hl                                        ; $6B5A
    ld a, [wMode0F_State0F_D93F]                  ; $6B5B
    ld e, a                                       ; $6B5E
    ld a, [wMode10_State03_D940]                  ; $6B5F
    ld d, a                                       ; $6B62
    ld b, BANK(Kitts_Add)                         ; $6B63
    ld hl, Kitts_Add                              ; $6B65
    call Far_Call                                 ; $6B68
    push hl                                       ; $6B6B
    ld hl, wMode06_State0A_D896                   ; $6B6C
    res 0, [hl]                                   ; $6B6F
    pop hl                                        ; $6B71
    ld bc, $804d                                  ; $6B72
    ld de, ObjScript_02_598B_Mode0E_KittGamesHost_State08 + $126 ; $6B75
    call Object_CreateWithParam                   ; $6B78
    ld a, $1a                                     ; $6B7B
    ldh [hState], a                               ; $6B7D

jr_007_6b7f:
    ret                                           ; $6B7F


; C: handler of state $1A of mode $0E (word 26 of Mode0E_StateTable)
Mode0E_State1A::
    ld a, [wMode07_StateTable_D8E0]               ; $6B80
    bit 0, a                                      ; $6B83
    jr z, jr_007_6b90                             ; $6B85

    ld a, $18                                     ; $6B87
    ld [wMode0E_State1E_D943], a                  ; $6B89
    ld a, $02                                     ; $6B8C
    ldh [hState], a                               ; $6B8E

jr_007_6b90:
    ret                                           ; $6B90


; C: handler of state $1D of mode $0E (word 29 of Mode0E_StateTable)
Mode0E_State1D::
    ld bc, $4890                                  ; $6B91
    ld de, ObjScript_02_5736_Mode0E_KittGamesHost_State15 ; $6B94
    call Object_CreateWithParam                   ; $6B97
    ld a, $1e                                     ; $6B9A
    ldh [hState], a                               ; $6B9C
    ret                                           ; $6B9E


; C: handler of state $1E of mode $0E (word 30 of Mode0E_StateTable)
Mode0E_State1E::
    ld a, [wKeysNew]                              ; $6B9F
    and PADF_A | PADF_B                           ; $6BA2
    jr z, jr_007_6bc8                             ; $6BA4

    push af                                       ; $6BA6
    ld a, SFX1_03                                 ; $6BA7
    ld [wSndSfx1], a                              ; $6BA9
    pop af                                        ; $6BAC
    call Rng_Next                                 ; $6BAD
    and $07                                       ; $6BB0
    jr z, jr_007_6bbe                             ; $6BB2

    ld a, $18                                     ; $6BB4
    ld [wMode0E_State1E_D943], a                  ; $6BB6
    ld a, $02                                     ; $6BB9
    ldh [hState], a                               ; $6BBB
    ret                                           ; $6BBD


jr_007_6bbe:
    ld a, $24                                     ; $6BBE
    ld [wMode0E_State1E_D943], a                  ; $6BC0
    ld a, $02                                     ; $6BC3
    ldh [hState], a                               ; $6BC5
    ret                                           ; $6BC7


jr_007_6bc8:
    ret                                           ; $6BC8


; C: ModeTable entry $0E: BGB screens 0E:03-16 (the host who asks for the Kitts of the scratch card and the 15 puzzle)
Mode0E_KittGamesHost::
    ldh a, [hState]                               ; $6BC9
    ld hl, Mode0E_StateTable                      ; $6BCB
    call JumpTable_ByA                            ; $6BCE
    jp Far_Return                                 ; $6BD1


; C: state table of mode $0E, read by $0189 with hFF8E
Mode0E_StateTable::
    dw Mode0E_State00
    dw Mode0E_State01
    dw Mode0E_State02
    dw Mode0E_State03
    dw Mode0E_State04
    dw Mode0E_State05
    dw Mode0E_State06
    dw Mode0E_State07
    dw Mode0E_State08
    dw Mode0E_State09
    dw Mode0E_State0A
    dw Mode0E_State0B
    dw Mode0E_State0C
    dw Mode0E_State0D
    dw Mode0E_State0E
    dw Mode0E_State0F
    dw Mode0E_State10
    dw Mode0E_State11
    dw Mode0E_State12
    dw Mode0E_State13
    dw Mode0E_State14
    dw Mode0E_State15
    dw Mode0E_State16
    dw Mode0E_State0C
    dw Mode0E_State18
    dw Mode0E_State19
    dw Mode0E_State1A
    dw Mode0E_State12
    dw Mode0E_State13
    dw Mode0E_State1D
    dw Mode0E_State1E
    dw Mode0E_State1F
    dw Mode0E_State20

; C: handler of state $00 of mode $04 (word 0 of Mode04_StateTable)
Mode04_State00::
    di                                            ; $6C16
    call Lcd_Off                                  ; $6C17
    call Copy_FarInline                           ; $6C1A

    db $00, $58, $16, $00, $80, $00, $18

    call Copy_FarInline                           ; $6C24

    db $00, $70, $1a, $00, $98, $00, $04

    ld a, [wMode04_State01_D8F8]                  ; $6C2E
    ld [wMenu07_CursorUpdate_D8F4], a             ; $6C31
    ld b, MODE_PLAY_MENU                          ; $6C34
    ld c, $00                                     ; $6C36
    call Mode_SaveReturnD8F2                      ; $6C38
    call Serial_SetFarCallback                    ; $6C3B

    dwb Frame_UpdateAll

    call Lcd_SetupInline                          ; $6C41

    db $87, $e4, $d0, $e4, $00, $00, $00, $00, $ff, $00, $01

    ld b, BANK(Objects_ClearAll)                  ; $6C4F
    ld hl, Objects_ClearAll                       ; $6C51
    call Far_Call                                 ; $6C54
    ld b, BANK(ScriptSlots_Clear)                 ; $6C57
    ld hl, ScriptSlots_Clear                      ; $6C59
    call Far_Call                                 ; $6C5C
    ld de, ObjScript_02_598B_Mode0E_KittGamesHost_State08 + $160 ; $6C5F
    call Object_Create                            ; $6C62
    ld de, ObjScript_02_5B35_PlayMenu_ObjItemRecord + $10 ; $6C65
    call Object_Create                            ; $6C68
    ld b, MODE_PLAY_MENU                          ; $6C6B
    ld c, STATE_04_PLAY_MENU_SCRATCH_CARD_15      ; $6C6D
    call Fade_GoTo                                ; $6C6F
    push af                                       ; $6C72
    ld a, MUSIC_PLAY_MENU                         ; $6C73
    ld [wSndMusicReq], a                          ; $6C75
    pop af                                        ; $6C78
    ei                                            ; $6C79
    ret                                           ; $6C7A


; C: handler of state $01 of mode $04 (word 1 of Mode04_StateTable)
Mode04_State01::
    ld a, [wMode07_StateTable_D8E0]               ; $6C7B
    bit 0, a                                      ; $6C7E
    jr z, jr_007_6caa                             ; $6C80

    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6C82
    ld [wMode04_State01_D8F8], a                  ; $6C85
    cp $02                                        ; $6C88
    jr nz, jr_007_6c98                            ; $6C8A

    ld a, [wAlbum_SlotOp6D18_D932]                ; $6C8C
    and a                                         ; $6C8F
    jr nz, jr_007_6c98                            ; $6C90

    ld a, $09                                     ; $6C92
    call Message_Show                             ; $6C94
    ret                                           ; $6C97


jr_007_6c98:
    xor a                                         ; $6C98
    ld [wMode0E_State1E_D943], a                  ; $6C99
    ldh a, [hMenuMode]                            ; $6C9C
    ldh [hMode], a                                ; $6C9E
    ld b, a                                       ; $6CA0
    ldh a, [hMenuState]                           ; $6CA1
    ldh [hState], a                               ; $6CA3
    ld c, a                                       ; $6CA5
    call Fade_GoToB                               ; $6CA6
    ret                                           ; $6CA9


jr_007_6caa:
    ld a, [wKeysNew]                              ; $6CAA
    bit PADB_B, a                                 ; $6CAD
    jr z, jr_007_6cc6                             ; $6CAF

    push af                                       ; $6CB1
    ld a, SFX3_08                                 ; $6CB2
    ld [wSndSfx3], a                              ; $6CB4
    pop af                                        ; $6CB7
    ld a, [wMenu07_CursorUpdate_D8F4]             ; $6CB8
    ld [wMode04_State01_D8F8], a                  ; $6CBB
    ld b, MODE_MAIN_MENU                          ; $6CBE
    ld c, $00                                     ; $6CC0
    call Fade_GoToB                               ; $6CC2
    ret                                           ; $6CC5


jr_007_6cc6:
    ret                                           ; $6CC6


; C: ModeTable entry $04: BGB screen 04:01 (scratch card / 15 puzzle / slide show / Strawberry Channel)
Mode04_PlayMenu::
    ldh a, [hState]                               ; $6CC7
    ld hl, Mode04_StateTable                      ; $6CC9
    call JumpTable_ByA                            ; $6CCC
    jp Far_Return                                 ; $6CCF


; C: state table of mode $04, read by $0189 with hFF8E
Mode04_StateTable::
    dw Mode04_State00
    dw Mode04_State01

    db $02, $fc, $fc, $fc, $fc, $02, $07, $07, $07, $07, $02, $05, $05, $05, $05, $02
    db $04, $04, $04, $04, $02, $09, $09, $09, $09, $02, $00, $01, $02, $03, $02, $0c
    db $0d, $0e, $0f, $02, $2a, $11, $07, $13, $02, $28, $11, $07, $13, $02, $1a, $1b
    db $07, $07, $02, $14, $15, $05, $05, $02, $05, $05, $14, $15, $02, $06, $06, $22
    db $06, $02, $07, $07, $07, $18, $02, $18, $05, $05, $19, $02, $2a, $05, $05, $20
    db $02, $3c, $3d, $3e, $39, $02, $3c, $3d, $3e, $3f, $02, $40, $41, $42, $43, $02
    db $4c, $4d, $4e, $4f, $02, $54, $55, $56, $57, $02, $58, $59, $5a, $5b, $02, $5c
    db $5d, $5e, $5f, $02, $60, $61, $62, $63, $02, $64, $65, $66, $67, $ff, $02, $fc
    db $fc, $00, $00, $02, $04, $04, $00, $00, $02, $05, $05, $00, $00, $02, $06, $06
    db $00, $00, $02, $07, $07, $00, $00, $02, $09, $09, $00, $00, $02, $11, $13, $00
    db $00, $02, $10, $12, $00, $00, $02, $1c, $1e, $00, $00, $02, $1d, $1f, $00, $00
    db $02, $2a, $07, $00, $00, $02, $2b, $07, $00, $00, $02, $2a, $16, $00, $00, $02
    db $2b, $20, $00, $00, $02, $2d, $2f, $00, $00, $02, $34, $36, $00, $00, $02, $35
    db $37, $00, $00, $02, $48, $4a, $00, $00, $ff, $02, $fc, $fc, $00, $00, $02, $04
    db $04, $00, $00, $02, $05, $05, $00, $00, $02, $06, $06, $00, $00, $02, $07, $07
    db $00, $00, $02, $09, $09, $00, $00, $02, $14, $15, $00, $00, $02, $1a, $1b, $00
    db $00, $02, $22, $07, $00, $00, $02, $1a, $07, $00, $00, $02, $07, $1b, $00, $00
    db $02, $07, $20, $00, $00, $02, $2a, $20, $00, $00, $02, $28, $20, $00, $00, $02
    db $50, $51, $00, $00, $02, $3a, $3b, $00, $00, $02, $32, $33, $00, $00, $ff, $02
    db $fc, $fc, $00, $00, $02, $04, $04, $00, $00, $02, $05, $05, $00, $00, $02, $06
    db $06, $00, $00, $02, $07, $07, $00, $00, $02, $09, $09, $00, $00, $02, $14, $15
    db $00, $00, $02, $1a, $1b, $00, $00, $02, $22, $07, $00, $00, $02, $1a, $07, $00
    db $00, $02, $07, $1b, $00, $00, $02, $07, $20, $00, $00, $02, $2a, $20, $00, $00
    db $02, $28, $20, $00, $00, $02, $50, $51, $00, $00, $02, $52, $53, $00, $00, $02
    db $32, $33, $00, $00, $ff, $02, $fc, $00, $00, $00, $02, $04, $00, $00, $00, $02
    db $05, $00, $00, $00, $02, $06, $00, $00, $00, $02, $07, $00, $00, $00, $02, $08
    db $00, $00, $00, $02, $09, $00, $00, $00, $02, $0a, $00, $00, $00, $02, $0b, $00
    db $00, $00, $02, $16, $00, $00, $00, $02, $17, $00, $00, $00, $02, $18, $00, $00
    db $00, $02, $19, $00, $00, $00, $02, $1a, $00, $00, $00, $02, $1b, $00, $00, $00
    db $02, $20, $00, $00, $00, $02, $21, $00, $00, $00, $02, $22, $00, $00, $00, $02
    db $23, $00, $00, $00, $02, $24, $00, $00, $00, $02, $25, $00, $00, $00, $02, $26
    db $00, $00, $00, $02, $27, $00, $00, $00, $02, $2a, $00, $00, $00, $02, $28, $00
    db $00, $00, $02, $2b, $00, $00, $00, $02, $29, $00, $00, $00, $02, $30, $00, $00
    db $00, $02, $31, $00, $00, $00, $02, $32, $00, $00, $00, $02, $33, $00, $00, $00
    db $02, $38, $00, $00, $00, $02, $44, $00, $00, $00, $02, $45, $00, $00, $00, $02
    db $46, $00, $00, $00, $02, $47, $00, $00, $00, $02, $2e, $00, $00, $00, $ff, $01
    db $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $00
    db $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $00, $01
    db $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e
    db $0f, $01, $10, $11, $12, $13, $01, $14, $15, $16, $17, $01, $18, $19, $1a, $1b
    db $01, $10, $11, $12, $13, $01, $14, $15, $16, $17, $01, $18, $19, $1a, $1b, $01
    db $10, $11, $12, $13, $01, $14, $15, $16, $17, $01, $18, $19, $1a, $1b, $01, $1c
    db $1d, $1e, $1f, $01, $08, $09, $0a, $0b, $ff, $04, $00, $04, $02, $06, $04, $00
    db $01, $02, $03, $04, $00, $04, $02, $06, $04, $00, $01, $02, $03, $04, $00, $04
    db $02, $06, $04, $00, $01, $02, $03, $04, $00, $04, $02, $06, $04, $00, $01, $02
    db $03, $04, $00, $04, $02, $06, $02, $08, $09, $0a, $0b, $05, $00, $09, $0c, $0d
    db $09, $00, $09, $0e, $0f, $08, $05, $09, $07, $0f, $1e, $00, $09, $0e, $0f, $ff
    db $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $00, $01, $02, $03, $01
    db $08, $09, $0a, $0b, $ff, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01
    db $00, $01, $02, $03, $01, $08, $09, $0a, $0b, $01, $00, $01, $02, $03, $01, $04
    db $05, $06, $07, $01, $00, $01, $02, $03, $01, $08, $09, $0a, $0b, $01, $0c, $0d
    db $0e, $0f, $01, $08, $09, $0a, $0b, $01, $10, $11, $12, $13, $02, $14, $15, $16
    db $17, $01, $10, $11, $12, $13, $01, $18, $19, $1a, $1b, $02, $1c, $1d, $1e, $1f
    db $01, $18, $19, $1a, $1b, $01, $10, $11, $12, $13, $02, $14, $15, $16, $17, $01
    db $10, $11, $12, $13, $01, $18, $19, $1a, $1b, $02, $1c, $1d, $1e, $1f, $01, $18
    db $19, $1a, $1b, $01, $10, $11, $12, $13, $02, $14, $15, $16, $17, $01, $10, $11
    db $12, $13, $01, $18, $19, $1a, $1b, $02, $1c, $1d, $1e, $1f, $01, $18, $19, $1a
    db $1b, $01, $10, $11, $12, $13, $02, $14, $15, $16, $17, $01, $10, $11, $12, $13
    db $01, $18, $19, $1a, $1b, $02, $1c, $1d, $1e, $1f, $01, $18, $19, $1a, $1b, $01
    db $10, $11, $12, $13, $02, $14, $15, $16, $17, $01, $10, $11, $12, $13, $01, $18
    db $19, $1a, $1b, $02, $1c, $1d, $1e, $1f, $01, $18, $19, $1a, $1b, $ff, $02, $1c
    db $1d, $1e, $1f, $01, $18, $19, $1a, $1b, $01, $10, $11, $12, $13, $02, $14, $15
    db $16, $17, $01, $10, $11, $12, $13, $01, $18, $19, $1a, $1b, $ff, $04, $00, $01
    db $02, $03, $04, $00, $01, $04, $05, $04, $00, $01, $06, $07, $04, $00, $01, $08
    db $09, $04, $0c, $0d, $0e, $0f, $06, $10, $11, $12, $13, $09, $10, $11, $0a, $0b
    db $ff, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f
    db $01, $08, $09, $0a, $0b, $ff, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b
    db $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01
    db $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04
    db $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11
    db $12, $13, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06
    db $07, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b
    db $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01, $0c, $0d, $0e, $0f, $01
    db $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00, $01, $02, $03, $01, $04
    db $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11
    db $12, $13, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06
    db $07, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b
    db $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01, $0c, $0d, $0e, $0f, $01
    db $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00, $01, $02, $03, $01, $04
    db $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11
    db $12, $13, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $ff, $01, $04, $05
    db $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a
    db $0b, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f
    db $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01
    db $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00
    db $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d
    db $0e, $0f, $01, $10, $11, $12, $13, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a
    db $0b, $01, $04, $05, $06, $07, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07
    db $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01
    db $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00
    db $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d
    db $0e, $0f, $01, $10, $11, $12, $13, $01, $0c, $0d, $0e, $0f, $01, $08, $09, $0a
    db $0b, $01, $04, $05, $06, $07, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07
    db $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01
    db $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00
    db $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d
    db $0e, $0f, $01, $10, $11, $12, $13, $01, $14, $15, $16, $17, $01, $00, $01, $02
    db $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f
    db $01, $10, $11, $12, $13, $01, $14, $15, $16, $17, $01, $00, $01, $02, $03, $01
    db $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10
    db $11, $12, $13, $01, $14, $15, $16, $17, $01, $00, $01, $02, $03, $01, $04, $05
    db $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12
    db $13, $01, $14, $15, $16, $17, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07
    db $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01
    db $14, $15, $16, $17, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $08
    db $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01, $0c, $0d
    db $0e, $0f, $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $00, $01, $02
    db $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f
    db $01, $08, $09, $0a, $0b, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01
    db $0c, $0d, $0e, $0f, $01, $08, $09, $0a, $0b, $ff, $01, $00, $01, $02, $03, $01
    db $04, $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10
    db $11, $12, $13, $01, $14, $15, $16, $17, $ff, $01, $00, $01, $02, $03, $01, $04
    db $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11
    db $12, $13, $01, $14, $15, $16, $17, $01, $18, $19, $1a, $1b, $01, $1c, $1d, $1e
    db $1f, $01, $00, $01, $02, $03, $01, $04, $05, $06, $07, $01, $08, $09, $0a, $0b
    db $01, $0c, $0d, $0e, $0f, $01, $10, $11, $12, $13, $01, $14, $15, $16, $17, $01
    db $18, $19, $1a, $1b, $01, $1c, $1d, $1e, $1f, $01, $00, $01, $02, $03, $01, $04
    db $05, $06, $07, $01, $08, $09, $0a, $0b, $01, $0c, $0d, $0e, $0f, $01, $10, $11
    db $12, $13, $01, $14, $15, $16, $17, $01, $18, $19, $1a, $1b, $01, $1c, $1d, $1e
    db $1f, $01, $20, $21, $22, $23, $01, $24, $25, $26, $27, $01, $28, $29, $2a, $2b
    db $01, $2c, $2d, $2e, $2f, $01, $30, $31, $32, $33, $01, $34, $35, $36, $37, $01
    db $38, $39, $3a, $3b, $01, $3c, $3d, $3e, $3f, $01, $40, $41, $42, $43, $01, $44
    db $45, $46, $47, $01, $48, $49, $4a, $4b, $01, $4c, $4d, $4e, $4f, $01, $50, $51
    db $52, $53, $01, $54, $55, $56, $57, $01, $38, $39, $3a, $3b, $01, $3c, $3d, $3e
    db $3f, $01, $40, $41, $42, $43, $01, $44, $45, $46, $47, $01, $48, $49, $4a, $4b
    db $01, $4c, $4d, $4e, $4f, $01, $50, $51, $52, $53, $01, $54, $55, $56, $57, $01
    db $38, $39, $3a, $3b, $01, $3c, $3d, $3e, $3f, $01, $40, $41, $42, $43, $01, $44
    db $45, $46, $47, $01, $48, $49, $4a, $4b, $01, $4c, $4d, $4e, $4f, $01, $50, $51
    db $52, $53, $01, $54, $55, $56, $57, $01, $38, $39, $3a, $3b, $01, $3c, $3d, $3e
    db $3f, $01, $40, $41, $42, $43, $01, $44, $45, $46, $47, $01, $48, $49, $4a, $4b
    db $01, $4c, $4d, $4e, $4f, $01, $50, $51, $52, $53, $01, $54, $55, $56, $57, $01
    db $58, $59, $5a, $5b, $01, $5c, $5d, $5e, $5f, $01, $60, $61, $62, $63, $01, $64
    db $65, $66, $67, $01, $68, $69, $6a, $6b, $01, $6c, $6d, $6e, $6f, $01, $70, $71
    db $72, $73, $01, $5c, $5d, $5e, $5f, $01, $60, $61, $62, $63, $01, $64, $65, $66
    db $67, $01, $68, $69, $6a, $6b, $01, $6c, $6d, $6e, $6f, $01, $70, $71, $72, $73
    db $01, $5c, $5d, $5e, $5f, $01, $60, $61, $62, $63, $01, $64, $65, $66, $67, $01
    db $68, $69, $6a, $6b, $01, $6c, $6d, $6e, $6f, $01, $70, $71, $72, $73, $01, $5c
    db $5d, $5e, $5f, $01, $74, $75, $76, $77, $01, $78, $79, $7a, $7b, $10, $7c, $7d
    db $7e, $7f, $ff, $05, $fc, $fc, $fc, $fc, $02, $30, $31, $32, $33, $02, $34, $35
    db $36, $37, $02, $38, $39, $3a, $3b, $02, $30, $31, $32, $33, $02, $34, $35, $36
    db $37, $02, $38, $39, $3a, $3b, $02, $30, $31, $32, $33, $02, $34, $35, $36, $37
    db $02, $38, $39, $3a, $3b, $02, $30, $31, $32, $33, $02, $34, $35, $36, $37, $02
    db $38, $39, $3a, $3b, $02, $30, $31, $32, $33, $02, $34, $35, $36, $37, $02, $38
    db $39, $3a, $3b, $02, $fc, $fc, $fc, $fc, $19, $00, $01, $fc, $fc, $02, $fc, $fc
    db $fc, $fc, $19, $04, $05, $fc, $fc, $02, $fc, $fc, $fc, $fc, $19, $06, $07, $fc
    db $fc, $02, $fc, $fc, $fc, $fc, $19, $08, $09, $0a, $0b, $02, $fc, $fc, $fc, $fc
    db $19, $02, $03, $fc, $fc, $02, $fc, $fc, $fc, $fc, $19, $0c, $0d, $0e, $0f, $02
    db $fc, $fc, $fc, $fc, $1e, $10, $11, $12, $13, $02, $fc, $fc, $fc, $fc, $1e, $14
    db $15, $16, $17, $02, $fc, $fc, $fc, $fc, $19, $18, $19, $1a, $1b, $02, $fc, $fc
    db $fc, $fc, $1e, $1c, $1d, $1e, $1f, $02, $fc, $fc, $fc, $fc, $1e, $20, $21, $22
    db $23, $02, $fc, $fc, $fc, $fc, $1e, $24, $25, $26, $27, $02, $fc, $fc, $fc, $fc
    db $1e, $28, $29, $2a, $2b, $02, $fc, $fc, $fc, $fc, $19, $2c, $2d, $fc, $fc, $02
    db $fc, $fc, $fc, $fc, $19, $2e, $2f, $fc, $fc, $19, $2e, $2f, $fc, $fc, $19, $2e
    db $2f, $fc, $fc, $ff

    ; padding
    ds $996, $00

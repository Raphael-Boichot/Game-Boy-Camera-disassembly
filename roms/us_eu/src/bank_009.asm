; Game Boy Camera (USA, Europe), bank $09. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $009", ROMX[$4000], BANK[$9]

; C: credits text scroller: dispatch on C00E (11 substates)
ScrollEngine_Step::
    ld a, [wScrollSubstate]                       ; $4000
    rst Rst18_JumpTable                           ; $4003

; C
ScrollEngine_SubstateTbl::
    dw ScrollEngine_Sub0_Reset
    dw ScrollEngine_Sub1_FetchRow
    dw ScrollEngine_Sub2_ReadRecord
    dw ScrollEngine_Sub3_ScrollUp1
    dw ScrollEngine_Sub4_ScrollUp2
    dw ScrollEngine_Sub5_WaitOrEnd
    dw ScrollEngine_Sub6_ReadRecordB
    dw ScrollEngine_Sub7_ScrollUp1B
    dw ScrollEngine_Sub8_ScrollUp2B
    dw ScrollEngine_SubA_ScanRowTypes
    dw ScrollEngine_Sub9_Nop

; C
ScrollEngine_Sub0_Reset::
    xor a                                         ; $401A
    ld [wScrollSrcRow], a                         ; $401B
    ld [wScrollBufWriteRow], a                    ; $401E
    ld hl, wScrollSubstate                        ; $4021
    inc [hl]                                      ; $4024
    ret                                           ; $4025


; C: copy a band record from the bank-$29 script into the row buffer
ScrollEngine_Sub1_FetchRow::
    ld a, [wScrollBufWriteRow]                    ; $4026
    call ScrollEngine_RowToOffset                 ; $4029
    ld hl, wScrollRowBuf                          ; $402C
    add hl, bc                                    ; $402F
    push hl                                       ; $4030
    ld a, [wScrollSrcRow]                         ; $4031
    call ScrollEngine_RowToOffset                 ; $4034
    ld hl, ScrollEngine_Step                      ; $4037
    add hl, bc                                    ; $403A
    ld a, $29                                     ; $403B
    pop de                                        ; $403D
    call ScrollEngine_CopyRowRecords              ; $403E
    ld a, [wScrollSrcRow]                         ; $4041
    add b                                         ; $4044
    ld [wScrollSrcRow], a                         ; $4045
    ld a, [wScrollBufWriteRow]                    ; $4048
    ld [wScrollDispRow], a                        ; $404B
    ld hl, wScrollSubstate                        ; $404E
    inc [hl]                                      ; $4051
    ret                                           ; $4052


; C
ScrollEngine_Sub2_ReadRecord::
    ld a, [wScrollDispRow]                        ; $4053
    call ScrollEngine_RowToOffset                 ; $4056
    ld hl, wScrollRowBuf                          ; $4059
    add hl, bc                                    ; $405C
    ld a, [hl+]                                   ; $405D
    ld [wScrollRecFlag], a                        ; $405E
    inc hl                                        ; $4061
    ld a, [hl+]                                   ; $4062
    ld [wScrollStopRow], a                        ; $4063
    ld a, [hl+]                                   ; $4066
    ld [wScrollRecPause], a                       ; $4067
    ld a, [hl+]                                   ; $406A
    ld [wScrollRecType], a                        ; $406B
    ld a, $18                                     ; $406E
    ld [wScrollBgRow], a                          ; $4070
    ld a, [wScrollRecFlag]                        ; $4073
    and a                                         ; $4076
    jr nz, jr_009_407e                            ; $4077

    ld hl, wScrollSubstate                        ; $4079
    inc [hl]                                      ; $407C
    ret                                           ; $407D


jr_009_407e:
    ld a, $04                                     ; $407E
    ld [wScrollSubstate], a                       ; $4080
    ret                                           ; $4083


; C
ScrollEngine_Sub3_ScrollUp1::
    call ScrollEngine_DrawRowUp1                  ; $4084
    ret nz                                        ; $4087

    ld a, [wScrollRecType]                        ; $4088
    and a                                         ; $408B
    jr nz, jr_009_409a                            ; $408C

    ld a, [wScrollDispRow]                        ; $408E
    inc a                                         ; $4091
    ld [wScrollDispRow], a                        ; $4092
    ld hl, wScrollSubstate                        ; $4095
    dec [hl]                                      ; $4098
    ret                                           ; $4099


jr_009_409a:
    xor a                                         ; $409A
    ld [wScrollDispRow], a                        ; $409B
    ld a, $05                                     ; $409E
    ld [wScrollSubstate], a                       ; $40A0
    ret                                           ; $40A3


; C
ScrollEngine_Sub4_ScrollUp2::
    call ScrollEngine_DrawRowUp2                  ; $40A4
    ret nz                                        ; $40A7

    ld a, [wScrollRecType]                        ; $40A8
    and a                                         ; $40AB
    jr nz, jr_009_40bc                            ; $40AC

    ld a, [wScrollDispRow]                        ; $40AE
    inc a                                         ; $40B1
    inc a                                         ; $40B2
    ld [wScrollDispRow], a                        ; $40B3
    ld a, $02                                     ; $40B6
    ld [wScrollSubstate], a                       ; $40B8
    ret                                           ; $40BB


jr_009_40bc:
    xor a                                         ; $40BC
    ld [wScrollDispRow], a                        ; $40BD
    ld hl, wScrollSubstate                        ; $40C0
    inc [hl]                                      ; $40C3
    ret                                           ; $40C4


; C: pause counter; script end sets C004
ScrollEngine_Sub5_WaitOrEnd::
    ldh a, [hKeysHeld]                            ; $40C5
    and a                                         ; $40C7
    jr nz, jr_009_40e1                            ; $40C8

    ld a, [wScrollRecPause]                       ; $40CA
    and a                                         ; $40CD
    jr z, jr_009_40e1                             ; $40CE

    ld hl, wScrollRecPause                        ; $40D0
    ld a, [wScrollDispRow]                        ; $40D3
    inc a                                         ; $40D6
    cp $1e                                        ; $40D7
    jr c, jr_009_40dd                             ; $40D9

    dec [hl]                                      ; $40DB
    xor a                                         ; $40DC

jr_009_40dd:
    ld [wScrollDispRow], a                        ; $40DD
    ret                                           ; $40E0


jr_009_40e1:
    xor a                                         ; $40E1
    ld [wScrollDispRow], a                        ; $40E2
    ld a, [wScrollRecType]                        ; $40E5
    cp $01                                        ; $40E8
    jr nz, jr_009_40f1                            ; $40EA

    ld hl, wScrollSubstate                        ; $40EC
    inc [hl]                                      ; $40EF
    ret                                           ; $40F0


jr_009_40f1:
    cp $02                                        ; $40F1
    jr nz, jr_009_40fb                            ; $40F3

    ld a, $09                                     ; $40F5
    ld [wScrollSubstate], a                       ; $40F7
    ret                                           ; $40FA


jr_009_40fb:
    ld a, $01                                     ; $40FB
    ld [wScrollScriptDone], a                     ; $40FD
    ld a, $0a                                     ; $4100
    ld [wScrollSubstate], a                       ; $4102

; C: ret
ScrollEngine_Sub9_Nop::
    ret                                           ; $4105


; C
ScrollEngine_Sub6_ReadRecordB::
    ld a, [wScrollDispRow]                        ; $4106
    call ScrollEngine_RowToOffset                 ; $4109
    ld hl, wScrollRowBuf                          ; $410C
    add hl, bc                                    ; $410F
    ld a, [hl+]                                   ; $4110
    ld [wScrollRecFlag], a                        ; $4111
    inc hl                                        ; $4114
    ld a, [hl+]                                   ; $4115
    ld [wScrollBgRow], a                          ; $4116
    ld a, [hl+]                                   ; $4119
    ld [wScrollRecPause], a                       ; $411A
    ld a, [hl+]                                   ; $411D
    ld [wScrollRecType], a                        ; $411E
    ld a, $fc                                     ; $4121
    ld [wScrollStopRow], a                        ; $4123
    ld a, [wScrollRecFlag]                        ; $4126
    and a                                         ; $4129
    jr nz, jr_009_4131                            ; $412A

    ld hl, wScrollSubstate                        ; $412C
    inc [hl]                                      ; $412F
    ret                                           ; $4130


jr_009_4131:
    ld a, $08                                     ; $4131
    ld [wScrollSubstate], a                       ; $4133
    ret                                           ; $4136


; C
ScrollEngine_Sub7_ScrollUp1B::
    call ScrollEngine_DrawRowUp1                  ; $4137
    ret nz                                        ; $413A

    ld a, [wScrollRecType]                        ; $413B
    and a                                         ; $413E
    jr nz, jr_009_414d                            ; $413F

    ld a, [wScrollDispRow]                        ; $4141
    inc a                                         ; $4144
    ld [wScrollDispRow], a                        ; $4145
    ld hl, wScrollSubstate                        ; $4148
    dec [hl]                                      ; $414B
    ret                                           ; $414C


jr_009_414d:
    xor a                                         ; $414D
    ld [wScrollBufWriteRow], a                    ; $414E
    ld a, $01                                     ; $4151
    ld [wScrollSubstate], a                       ; $4153
    ret                                           ; $4156


; C
ScrollEngine_Sub8_ScrollUp2B::
    call ScrollEngine_DrawRowUp2                  ; $4157
    ret nz                                        ; $415A

    ld a, [wScrollRecType]                        ; $415B
    and a                                         ; $415E
    jr nz, jr_009_416f                            ; $415F

    ld a, [wScrollDispRow]                        ; $4161
    inc a                                         ; $4164
    inc a                                         ; $4165
    ld [wScrollDispRow], a                        ; $4166
    ld a, $06                                     ; $4169
    ld [wScrollSubstate], a                       ; $416B
    ret                                           ; $416E


jr_009_416f:
    xor a                                         ; $416F
    ld [wScrollBufWriteRow], a                    ; $4170
    ld a, $01                                     ; $4173
    ld [wScrollSubstate], a                       ; $4175
    ret                                           ; $4178


; I
ScrollEngine_SubA_ScanRowTypes::
    ld hl, wScrollRowBuf                          ; $4179
    ld d, $00                                     ; $417C
    ld bc, $0000                                  ; $417E

jr_009_4181:
    push hl                                       ; $4181
    ld a, [hl+]                                   ; $4182
    and a                                         ; $4183
    jr z, jr_009_418a                             ; $4184

    ld a, c                                       ; $4186
    xor $80                                       ; $4187
    ld c, a                                       ; $4189

jr_009_418a:
    call ScrollEngine_ScanRowType                 ; $418A
    inc hl                                        ; $418D
    inc hl                                        ; $418E
    ld a, [hl]                                    ; $418F
    and a                                         ; $4190
    jr z, jr_009_4194                             ; $4191

    inc c                                         ; $4193

jr_009_4194:
    pop hl                                        ; $4194
    ld a, l                                       ; $4195
    add $20                                       ; $4196
    ld l, a                                       ; $4198
    jr nc, jr_009_419c                            ; $4199

    inc h                                         ; $419B

jr_009_419c:
    inc b                                         ; $419C
    ld a, c                                       ; $419D
    bit 7, a                                      ; $419E
    jr nz, jr_009_41a6                            ; $41A0

    and $7f                                       ; $41A2
    jr nz, jr_009_41ab                            ; $41A4

jr_009_41a6:
    ld a, b                                       ; $41A6
    cp $12                                        ; $41A7
    jr nz, jr_009_4181                            ; $41A9

jr_009_41ab:
    ld a, [wScrollDispRow]                        ; $41AB
    inc a                                         ; $41AE
    ld [wScrollDispRow], a                        ; $41AF
    cp $14                                        ; $41B2
    ret nz                                        ; $41B4

    ld a, d                                       ; $41B5
    ld [wScrollBufWriteRow], a                    ; $41B6
    ld a, $01                                     ; $41B9
    ld [wScrollSubstate], a                       ; $41BB
    ret                                           ; $41BE


; I
ScrollEngine_ScanRowType::
    ld a, [hl+]                                   ; $41BF
    cp $01                                        ; $41C0
    jr z, jr_009_41e3                             ; $41C2

    cp $02                                        ; $41C4
    jr z, jr_009_41ca                             ; $41C6

    inc d                                         ; $41C8
    ret                                           ; $41C9


jr_009_41ca:
    push bc                                       ; $41CA
    push de                                       ; $41CB
    push hl                                       ; $41CC
    ld a, [hl+]                                   ; $41CD
    call ScrollEngine_RowToOffset                 ; $41CE
    ld a, [wScrollDispRow]                        ; $41D1
    add c                                         ; $41D4
    ld c, a                                       ; $41D5
    ld hl, $9805                                  ; $41D6
    add hl, bc                                    ; $41D9
    ld a, $ff                                     ; $41DA
    call Vram_WriteByteSafe                       ; $41DC
    pop hl                                        ; $41DF
    pop de                                        ; $41E0
    pop bc                                        ; $41E1
    ret                                           ; $41E2


jr_009_41e3:
    push bc                                       ; $41E3
    push de                                       ; $41E4
    push hl                                       ; $41E5
    ld a, [hl+]                                   ; $41E6
    call ScrollEngine_RowToOffset                 ; $41E7
    ld a, [wScrollDispRow]                        ; $41EA
    cpl                                           ; $41ED
    add $14                                       ; $41EE
    add c                                         ; $41F0
    ld c, a                                       ; $41F1
    ld hl, $9805                                  ; $41F2
    add hl, bc                                    ; $41F5
    ld a, $ff                                     ; $41F6
    call Vram_WriteByteSafe                       ; $41F8
    pop hl                                        ; $41FB
    pop de                                        ; $41FC
    pop bc                                        ; $41FD
    ret                                           ; $41FE


; C: BG row $9800 + 32 * ((C012-1) and $1F)
ScrollEngine_DrawRowUp1::
    ld a, [wScrollBgRow]                          ; $41FF
    dec a                                         ; $4202
    ld [wScrollBgRow], a                          ; $4203
    and $1f                                       ; $4206
    call ScrollEngine_RowToOffset                 ; $4208
    ld hl, $9800                                  ; $420B
    add hl, bc                                    ; $420E
    push hl                                       ; $420F
    ld a, [wScrollDispRow]                        ; $4210
    call ScrollEngine_RowToOffset                 ; $4213
    ld hl, wScrollRowBuf                          ; $4216
    add hl, bc                                    ; $4219
    xor a                                         ; $421A
    pop de                                        ; $421B
    ld bc, $0020                                  ; $421C
    call Vram_CopyFromBank                        ; $421F
    ld h, d                                       ; $4222
    ld l, e                                       ; $4223
    res 2, h                                      ; $4224
    ld bc, $0020                                  ; $4226
    call Vram_FillFFSafe                          ; $4229
    ld a, [wScrollBgRow]                          ; $422C
    ld hl, wScrollStopRow                         ; $422F
    cp [hl]                                       ; $4232
    ret                                           ; $4233


; C
ScrollEngine_DrawRowUp2::
    ld a, [wScrollBgRow]                          ; $4234
    dec a                                         ; $4237
    ld [wScrollBgRow], a                          ; $4238
    and $1f                                       ; $423B
    call ScrollEngine_RowToOffset                 ; $423D
    ld hl, $9800                                  ; $4240
    add hl, bc                                    ; $4243
    push hl                                       ; $4244
    ld a, [wScrollDispRow]                        ; $4245
    call ScrollEngine_RowToOffset                 ; $4248
    ld hl, wScrollRowBuf                          ; $424B
    add hl, bc                                    ; $424E
    xor a                                         ; $424F
    pop de                                        ; $4250
    ld bc, $0020                                  ; $4251
    call Vram_CopyFromBank                        ; $4254
    xor a                                         ; $4257
    res 2, d                                      ; $4258
    ld bc, $0020                                  ; $425A
    call Vram_CopyFromBank                        ; $425D
    ld h, d                                       ; $4260
    ld l, e                                       ; $4261
    res 2, h                                      ; $4262
    ld bc, $0020                                  ; $4264
    call Vram_FillFFSafe                          ; $4267
    ld a, [wScrollBgRow]                          ; $426A
    ld hl, wScrollStopRow                         ; $426D
    cp [hl]                                       ; $4270
    ret                                           ; $4271


; C: A * 32 in BC
ScrollEngine_RowToOffset::
    swap a                                        ; $4272
    push af                                       ; $4274
    and $f0                                       ; $4275
    ld c, a                                       ; $4277
    pop af                                        ; $4278
    and $0f                                       ; $4279
    ld b, a                                       ; $427B
    sla c                                         ; $427C
    rl b                                          ; $427E
    ret                                           ; $4280


; C: photo comment / tag editor (4 substates); far call from the album
CommentEditor_Far::
    ld a, [wSubstate]                             ; $4281
    rst Rst18_JumpTable                           ; $4284

; I
CommentEditor_SubstateTbl::
    dw CommentEditor_Sub0_Init
    dw CommentEditor_Sub1_SlideIn
    dw CommentEditor_Sub2_Edit
    dw CommentEditor_Sub3_Exit

; C
CommentEditor_Sub0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $428D
    ldh [hLcdcShadow], a                          ; $428F
    ld a, $e4                                     ; $4291
    ld [wPaletteTarget], a                        ; $4293
    ld a, $d2                                     ; $4296
    ld [wPaletteTarget + $1], a                   ; $4298
    ld [wPaletteTarget + $2], a                   ; $429B
    xor a                                         ; $429E
    ldh [hScxShadow], a                           ; $429F
    ldh [hScyShadow], a                           ; $42A1
    ld [wCmtCursor], a                            ; $42A3
    ld [wCmtCtrl], a                              ; $42A6
    ld a, $11                                     ; $42A9
    ld [wCmtGridRow], a                           ; $42AB
    ld a, $55                                     ; $42AE
    ld [wCmtGridCell], a                          ; $42B0
    ld a, $07                                     ; $42B3
    ldh [hWxShadow], a                            ; $42B5
    ld a, $94                                     ; $42B7
    ldh [hWyShadow], a                            ; $42B9
    ldh [hFarcallAArg], a                         ; $42BB
    farcall Owner_Load_Far                        ; $42BD
    ld a, $1b                                     ; $42C5
    ld hl, Gfx_1B_4000_Mode1C_State08_PrintJob    ; $42C7
    ld de, $9000                                  ; $42CA
    ld bc, $0800                                  ; $42CD
    call Mem_CopyFromBank                         ; $42D0
    farcopy Mem_CopyFromBank, Gfx_1B_4800_Mode1C_State08_PrintJob, $8800, $0800 ; $42D3
    farcopy Mem_CopyFromBank, Gfx_1B_5000_CommentEditor_Sub0_Init, $8000, $0030 ; $42E1
    farcopy Mem_CopyFromBank, Map_21_7CC0_CommentEditor_Sub0_Init, $9800, $0240 ; $42EF
    farcopy Mem_CopyFromBank, Map_21_7F00_CommentEditor_Sub0_Init, $9c00, $0100 ; $42FD
    screen_on                                     ; $430B
    ldh [hFarcallAArg], a                         ; $4314
    ld a, $09                                     ; $4316
    ld hl, CommentCard_UploadThumbnail_Far        ; $4318
    call Far_Call                                 ; $431B
    ldh [hFarcallAArg], a                         ; $431E
    ld a, $09                                     ; $4320
    ld hl, CommentCard_DrawComment_Far            ; $4322
    call Far_Call                                 ; $4325
    ldh [hFarcallAArg], a                         ; $4328
    ld a, $09                                     ; $432A
    ld hl, CommentCard_DrawOwnerName_Far          ; $432C
    call Far_Call                                 ; $432F
    ldh [hFarcallAArg], a                         ; $4332
    ld a, $09                                     ; $4334
    ld hl, CommentCard_DrawGender_Far             ; $4336
    call Far_Call                                 ; $4339
    ldh [hFarcallAArg], a                         ; $433C
    ld a, $09                                     ; $433E
    ld hl, CommentCard_DrawBlood_Far              ; $4340
    call Far_Call                                 ; $4343
    ldh [hFarcallAArg], a                         ; $4346
    ld a, $09                                     ; $4348
    ld hl, CommentCard_DrawBirthDate_Far          ; $434A
    call Far_Call                                 ; $434D
    ldh [hFarcallAArg], a                         ; $4350
    ld a, $09                                     ; $4352
    ld hl, CommentCard_DrawCounters_Far           ; $4354
    call Far_Call                                 ; $4357
    ldh [hFarcallAArg], a                         ; $435A
    ld a, $09                                     ; $435C
    ld hl, CommentCard_DrawTotal_Far              ; $435E
    call Far_Call                                 ; $4361
    ldh [hFarcallAArg], a                         ; $4364
    ld a, $09                                     ; $4366
    ld hl, CommentCard_DrawCopyBadge_Far          ; $4368
    call Far_Call                                 ; $436B
    ldh [hFarcallAArg], a                         ; $436E
    ld a, $09                                     ; $4370
    ld hl, CommentCard_DrawPhotoNumber_Far        ; $4372
    call Far_Call                                 ; $4375
    play_music MUSIC_COMMENT_EDITOR               ; $4378
    call Pal_FadeIn                               ; $437F
    ld hl, wSubstate                              ; $4382
    inc [hl]                                      ; $4385
    jp Far_Call_Return                            ; $4386


; C: Start slides the panel in
CommentEditor_Sub1_SlideIn::
    ldh a, [hKeysNew]                             ; $4389
    bit PADB_START, a                             ; $438B
    jr z, jr_009_439c                             ; $438D

    call CommentEditor_LoadGridPage               ; $438F
    call CommentEditor_SlidePanelIn               ; $4392
    ld hl, wSubstate                              ; $4395
    inc [hl]                                      ; $4398
    jp Far_Call_Return                            ; $4399


jr_009_439c:
    ldh a, [hKeysNew]                             ; $439C
    and PADF_B                                    ; $439E
    jp z, Far_Call_Return                         ; $43A0

    ld [wAbResult], a                             ; $43A3
    ld a, $03                                     ; $43A6
    ld [wSubstate], a                             ; $43A8
    jp Far_Call_Return                            ; $43AB


; C: character grid; cursor; delete and arrows
CommentEditor_Sub2_Edit::
    call CommentEditor_ReadDirections             ; $43AE
    call CommentEditor_DispatchControl            ; $43B1
    call CommentEditor_DrawGridCursor             ; $43B4
    call CommentEditor_DrawCaret                  ; $43B7
    call CommentEditor_DrawTextCursor             ; $43BA
    ldh a, [hKeysNew]                             ; $43BD
    bit PADB_B, a                                 ; $43BF
    jp z, Far_Call_Return                         ; $43C1

    call Oam_ClearShadow                          ; $43C4
    rst Rst08_WaitVBlank                          ; $43C7
    call CommentEditor_SlidePanelOut              ; $43C8
    ld hl, wSubstate                              ; $43CB
    dec [hl]                                      ; $43CE
    jp Far_Call_Return                            ; $43CF


; C
CommentEditor_Sub3_Exit::
    screen_off                                    ; $43D2
    next_state                                    ; $43D8
    jp Far_Call_Return                            ; $43DC


; C: cmt_ctrl: 0 grid; 1 delete; 2 left; 3 right
CommentEditor_DispatchControl::
    ld a, [wCmtCtrl]                              ; $43DF
    sla a                                         ; $43E2
    ld c, a                                       ; $43E4
    ld b, $00                                     ; $43E5
    ld hl, CommentEditor_ControlJumpTbl           ; $43E7
    add hl, bc                                    ; $43EA
    ld a, [hl+]                                   ; $43EB
    ld h, [hl]                                    ; $43EC
    ld l, a                                       ; $43ED
    jp hl                                         ; $43EE


; I
CommentEditor_ControlJumpTbl::
    dw CommentEditor_CtrlGrid
    dw CommentEditor_CtrlDelete
    dw CommentEditor_CtrlLeft
    dw CommentEditor_CtrlRight

; C: A types the character under the cursor
CommentEditor_CtrlGrid::
    ldh a, [hKeysNew]                             ; $43F7
    bit PADB_A, a                                 ; $43F9
    ret z                                         ; $43FB

    play_sfx1 SFX1_KEY_A                          ; $43FC
    ld a, [wCmtCursor]                            ; $4403
    ld c, a                                       ; $4406
    ld b, $00                                     ; $4407
    ld hl, wTagComment                            ; $4409
    add hl, bc                                    ; $440C
    ld a, [wCmtGridCell]                          ; $440D
    inc a                                         ; $4410
    ld [hl], a                                    ; $4411
    call CommentEditor_DrawChar                   ; $4412
    jp CommentEditor_StepCursorRight              ; $4415


; C
CommentEditor_CtrlDelete::
    ldh a, [hKeysNewRepeat]                       ; $4418
    bit PADB_A, a                                 ; $441A
    ret z                                         ; $441C

    play_sfx1 SFX1_CURSOR_MOVE                    ; $441D
    ld a, [wCmtCursor]                            ; $4424
    ld c, a                                       ; $4427
    ld b, $00                                     ; $4428
    ld hl, wTagComment                            ; $442A
    add hl, bc                                    ; $442D
    xor a                                         ; $442E
    ld [hl], a                                    ; $442F
    call CommentEditor_DrawChar                   ; $4430
    ld a, [wCmtCursor]                            ; $4433
    and a                                         ; $4436
    ret z                                         ; $4437

    dec a                                         ; $4438
    ld [wCmtCursor], a                            ; $4439
    ret                                           ; $443C


; C: cursor limit $1A
CommentEditor_CtrlRight::
    ldh a, [hKeysNewRepeat]                       ; $443D
    bit PADB_A, a                                 ; $443F
    ret z                                         ; $4441

; C: moves the text cursor $DA91 one place right (limit $1A, sfx $21); the second half of CommentEditor_CtrlRight,
; also reached after a character was typed (branch target; code read 2026-10-19)
CommentEditor_StepCursorRight::
    ld a, [wCmtCursor]                            ; $4442
    cp $1a                                        ; $4445
    ret z                                         ; $4447

    play_sfx1 SFX1_STEP_VALUE                     ; $4448
    inc a                                         ; $444F
    ld [wCmtCursor], a                            ; $4450
    ret                                           ; $4453


; C
CommentEditor_CtrlLeft::
    ldh a, [hKeysNewRepeat]                       ; $4454
    bit PADB_A, a                                 ; $4456
    ret z                                         ; $4458

    ld a, [wCmtCursor]                            ; $4459
    and a                                         ; $445C
    ret z                                         ; $445D

    play_sfx1 SFX1_KEY_B                          ; $445E
    dec a                                         ; $4465
    ld [wCmtCursor], a                            ; $4466
    ret                                           ; $4469


; C: blinking sprite $7D
CommentEditor_DrawTextCursor::
    ldh a, [hFrameCounter]                        ; $446A
    bit 3, a                                      ; $446C
    ret z                                         ; $446E

    ld bc, $0178                                  ; $446F
    ld a, $7d                                     ; $4472
    call Oam_AddMeta_B02_52BD                     ; $4474
    ret                                           ; $4477


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentEditor_DrawCaret::
    ld a, [wCmtCursor]                            ; $4478
    ld c, $62                                     ; $447B

jr_009_447d:
    cp $09                                        ; $447D
    jr c, jr_009_4486                             ; $447F

    sub $09                                       ; $4481
    inc c                                         ; $4483
    jr jr_009_447d                                ; $4484

jr_009_4486:
    swap c                                        ; $4486
    sla a                                         ; $4488
    sla a                                         ; $448A
    sla a                                         ; $448C
    add $48                                       ; $448E
    ld b, a                                       ; $4490
    ldh a, [hFrameCounter]                        ; $4491
    and $0f                                       ; $4493
    cp $04                                        ; $4495
    ret c                                         ; $4497

    ld a, $7c                                     ; $4498
    call Oam_AddMeta_B02_52BD                     ; $449A
    ret                                           ; $449D


; C
CommentEditor_DrawGridCursor::
    ld a, [wCmtCtrl]                              ; $449E
    and a                                         ; $44A1
    jr z, jr_009_44a7                             ; $44A2

    dec a                                         ; $44A4
    jr jr_009_44c3                                ; $44A5

jr_009_44a7:
    ld a, [wCmtGridCell]                          ; $44A7
    ld c, $00                                     ; $44AA

jr_009_44ac:
    cp $05                                        ; $44AC
    jr c, jr_009_44b5                             ; $44AE

    sub $05                                       ; $44B0
    inc c                                         ; $44B2
    jr jr_009_44ac                                ; $44B3

jr_009_44b5:
    ld b, a                                       ; $44B5
    ld a, [wCmtGridRow]                           ; $44B6
    cp c                                          ; $44B9
    jr z, jr_009_44c0                             ; $44BA

    ld a, b                                       ; $44BC
    add $05                                       ; $44BD
    ld b, a                                       ; $44BF

jr_009_44c0:
    ld a, b                                       ; $44C0
    add $03                                       ; $44C1

jr_009_44c3:
    sla a                                         ; $44C3
    ld c, a                                       ; $44C5
    ld b, $00                                     ; $44C6
    ld hl, CommentEditor_DrawGridCursor_Tbl44DF   ; $44C8
    add hl, bc                                    ; $44CB
    ld c, [hl]                                    ; $44CC
    inc hl                                        ; $44CD
    ld b, [hl]                                    ; $44CE
    ldh a, [hFrameCounter]                        ; $44CF
    srl a                                         ; $44D1
    srl a                                         ; $44D3
    srl a                                         ; $44D5
    and $01                                       ; $44D7
    add $7a                                       ; $44D9
    call Oam_AddMeta_B02_52BD                     ; $44DB
    ret                                           ; $44DE


; C: auto: 26 bytes, bytes; referenced by CommentEditor_DrawGridCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 0A)
CommentEditor_DrawGridCursor_Tbl44DF::
    db $57, $87, $67, $87, $77, $87, $5c, $0f, $5c, $27, $5c, $3f, $5c, $57, $5c, $6f
    db $75, $0f, $75, $27, $75, $3f, $75, $57, $75, $6f

; I: moves the grid cursor; scrolls the grid page
CommentEditor_ReadDirections::
    ldh a, [hKeysNewRepeat]                       ; $44F9
    ld b, a                                       ; $44FB
    ld a, [wCmtCtrl]                              ; $44FC
    and a                                         ; $44FF
    jr z, jr_009_4533                             ; $4500

    bit 5, b                                      ; $4502
    jr z, jr_009_4510                             ; $4504

    play_sfx1 SFX1_DIRECTION_KEY                  ; $4506
    xor a                                         ; $450D
    jr jr_009_452f                                ; $450E

jr_009_4510:
    bit 6, b                                      ; $4510
    jr z, jr_009_4521                             ; $4512

    cp $01                                        ; $4514
    ret z                                         ; $4516

    play_sfx1 SFX1_DIRECTION_KEY                  ; $4517
    dec a                                         ; $451E
    jr jr_009_452f                                ; $451F

jr_009_4521:
    bit 7, b                                      ; $4521
    ret z                                         ; $4523

    cp $03                                        ; $4524
    ret z                                         ; $4526

    play_sfx1 SFX1_DIRECTION_KEY                  ; $4527
    inc a                                         ; $452E

jr_009_452f:
    ld [wCmtCtrl], a                              ; $452F
    ret                                           ; $4532


jr_009_4533:
    ld c, $00                                     ; $4533
    ld a, [wCmtGridCell]                          ; $4535

jr_009_4538:
    cp $05                                        ; $4538
    jr c, jr_009_4541                             ; $453A

    sub $05                                       ; $453C
    inc c                                         ; $453E
    jr jr_009_4538                                ; $453F

jr_009_4541:
    cp $04                                        ; $4541
    jr nz, jr_009_4556                            ; $4543

    bit 4, b                                      ; $4545
    jr z, jr_009_4556                             ; $4547

    play_sfx1 SFX1_DIRECTION_KEY                  ; $4549
    ld a, $01                                     ; $4550
    ld [wCmtCtrl], a                              ; $4552
    ret                                           ; $4555


jr_009_4556:
    and a                                         ; $4556
    jr nz, jr_009_455c                            ; $4557

    bit 5, b                                      ; $4559
    ret nz                                        ; $455B

jr_009_455c:
    ld a, [wCmtGridCell]                          ; $455C
    bit 5, b                                      ; $455F
    jr z, jr_009_4566                             ; $4561

    dec a                                         ; $4563
    jr jr_009_4586                                ; $4564

jr_009_4566:
    bit 4, b                                      ; $4566
    jr z, jr_009_456d                             ; $4568

    inc a                                         ; $456A
    jr jr_009_4586                                ; $456B

jr_009_456d:
    bit 6, b                                      ; $456D
    jr z, jr_009_457b                             ; $456F

    cp $5a                                        ; $4571
    ret c                                         ; $4573

    sub $05                                       ; $4574
    call CommentEditor_GridRowUp                  ; $4576
    jr jr_009_4586                                ; $4579

jr_009_457b:
    bit 7, b                                      ; $457B
    ret z                                         ; $457D

    cp $c3                                        ; $457E
    ret nc                                        ; $4580

    add $05                                       ; $4581
    call CommentEditor_GridRowDown                ; $4583

jr_009_4586:
    ld hl, wCmtGridCell                           ; $4586
    cp [hl]                                       ; $4589
    ret z                                         ; $458A

    ld [hl], a                                    ; $458B
    play_sfx1 SFX1_DIRECTION_KEY                  ; $458C
    ret                                           ; $4593


; C
CommentEditor_GridRowUp::
    push af                                       ; $4594
    ld a, [wCmtGridRow]                           ; $4595
    cp c                                          ; $4598
    jr nz, jr_009_45a2                            ; $4599

    dec a                                         ; $459B
    ld [wCmtGridRow], a                           ; $459C
    call CommentEditor_LoadGridPage               ; $459F

jr_009_45a2:
    pop af                                        ; $45A2
    ret                                           ; $45A3


; C
CommentEditor_GridRowDown::
    push af                                       ; $45A4
    ld a, [wCmtGridRow]                           ; $45A5
    cp c                                          ; $45A8
    jr z, jr_009_45b2                             ; $45A9

    inc a                                         ; $45AB
    ld [wCmtGridRow], a                           ; $45AC
    call CommentEditor_LoadGridPage               ; $45AF

jr_009_45b2:
    pop af                                        ; $45B2
    ret                                           ; $45B3


; C: far: $CE00 thumbnail to VRAM $9600
CommentCard_UploadThumbnail_Far::
    ld a, $00                                     ; $45B4
    ld hl, wThumbnail                             ; $45B6
    ld de, $9600                                  ; $45B9
    ld bc, $00c8                                  ; $45BC
    call Vram_CopyFromBankAuto                    ; $45BF
    ld a, $00                                     ; $45C2
    ld hl, wThumbnail + $d0                       ; $45C4
    ld de, $96d0                                  ; $45C7
    ld bc, $0008                                  ; $45CA
    call Vram_CopyFromBankAuto                    ; $45CD
    ld a, $00                                     ; $45D0
    ld hl, wThumbnail + $e0                       ; $45D2
    ld de, $96e0                                  ; $45D5
    ld bc, $0008                                  ; $45D8
    call Vram_CopyFromBankAuto                    ; $45DB
    ld a, $00                                     ; $45DE
    ld hl, wThumbnail + $f0                       ; $45E0
    ld de, $96f0                                  ; $45E3
    ld bc, $0008                                  ; $45E6
    call Vram_CopyFromBankAuto                    ; $45E9
    jp Far_Call_Return                            ; $45EC


; C
CommentEditor_DrawChar::
    ld a, [wCmtCursor]                            ; $45EF
    ld c, a                                       ; $45F2
    ld b, $00                                     ; $45F3
    ld hl, wTagComment                            ; $45F5
    add hl, bc                                    ; $45F8
    ld a, [hl]                                    ; $45F9
    push af                                       ; $45FA
    ld a, [wCmtCursor]                            ; $45FB
    swap a                                        ; $45FE
    push af                                       ; $4600
    and $f0                                       ; $4601
    ld c, a                                       ; $4603
    pop af                                        ; $4604
    and $0f                                       ; $4605
    ld b, a                                       ; $4607
    sla c                                         ; $4608
    rl b                                          ; $460A
    ld hl, $9700                                  ; $460C
    add hl, bc                                    ; $460F
    ld d, h                                       ; $4610
    ld e, l                                       ; $4611
    bit 3, d                                      ; $4612
    jr z, jr_009_4618                             ; $4614

    res 4, d                                      ; $4616

jr_009_4618:
    pop af                                        ; $4618
    ld c, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $4619
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $461B
    call Glyph_LoadFromCharCode                   ; $461E
    ret                                           ; $4621


; C: far: tag_comment to $9700
CommentCard_DrawComment_Far::
    ld hl, wTagComment                            ; $4622
    ld de, $9700                                  ; $4625
    ld b, $1e                                     ; $4628

jr_009_462a:
    push bc                                       ; $462A
    ld a, [hl+]                                   ; $462B
    push hl                                       ; $462C
    ld c, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $462D
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $462F
    call Glyph_LoadFromCharCode                   ; $4632
    bit 3, d                                      ; $4635
    jr z, jr_009_463b                             ; $4637

    res 4, d                                      ; $4639

jr_009_463b:
    pop hl                                        ; $463B
    pop bc                                        ; $463C
    dec b                                         ; $463D
    jr nz, jr_009_462a                            ; $463E

    jp Far_Call_Return                            ; $4640


; C: far
CommentCard_DrawGender_Far::
    ld a, [wTagGenderBlood]                       ; $4643
    and $03                                       ; $4646
    swap a                                        ; $4648
    ld c, a                                       ; $464A
    ld b, $00                                     ; $464B
    sla c                                         ; $464D
    sla c                                         ; $464F
    ld hl, Gfx_21_56D0_CommentCard_DrawGender_Far ; $4651
    add hl, bc                                    ; $4654
    ld a, BANK(Gfx_21_56D0_CommentCard_DrawGender_Far) ; $4655
    ld de, $8b80                                  ; $4657
    ld bc, $0040                                  ; $465A
    call Vram_CopyFromBankAuto                    ; $465D
    jp Far_Call_Return                            ; $4660


; C: far
CommentCard_DrawBlood_Far::
    ld a, [wTagGenderBlood]                       ; $4663
    srl a                                         ; $4666
    srl a                                         ; $4668
    and $07                                       ; $466A
    swap a                                        ; $466C
    ld c, a                                       ; $466E
    ld b, $00                                     ; $466F
    sla c                                         ; $4671
    rl b                                          ; $4673
    sla c                                         ; $4675
    rl b                                          ; $4677
    ld hl, Gfx_21_54E0_CommentCard_DrawBlood_Far  ; $4679
    add hl, bc                                    ; $467C
    ld a, BANK(Gfx_21_54E0_CommentCard_DrawBlood_Far) ; $467D
    ld de, $9450                                  ; $467F
    ld bc, $0040                                  ; $4682
    call Vram_CopyFromBankAuto                    ; $4685
    jp Far_Call_Return                            ; $4688


; C: far: year; month; day
CommentCard_DrawBirthDate_Far::
    ld de, $93d0                                  ; $468B
    ld hl, wTagBirth                              ; $468E
    ld b, $02                                     ; $4691
    call CommentCard_DrawNumber                   ; $4693
    ld hl, wTagBirth + $2                         ; $4696
    ld b, $01                                     ; $4699
    call CommentCard_DrawNumber                   ; $469B
    ld hl, wTagBirth + $3                         ; $469E
    ld b, $01                                     ; $46A1
    call CommentCard_DrawNumber                   ; $46A3
    jp Far_Call_Return                            ; $46A6


; C: placeholder when all bytes are 0
CommentCard_DrawNumber::
    push bc                                       ; $46A9
    push hl                                       ; $46AA
    xor a                                         ; $46AB

jr_009_46ac:
    or [hl]                                       ; $46AC
    inc hl                                        ; $46AD
    dec b                                         ; $46AE
    jr nz, jr_009_46ac                            ; $46AF

    pop hl                                        ; $46B1
    pop bc                                        ; $46B2
    and a                                         ; $46B3
    jp nz, CommentCard_DrawNumber_NonZero         ; $46B4

    sla b                                         ; $46B7

jr_009_46b9:
    push bc                                       ; $46B9
    ld hl, Gfx_21_56C0_CommentCard_DrawNumber     ; $46BA
    ld a, BANK(Gfx_21_56C0_CommentCard_DrawNumber) ; $46BD
    ld bc, $0010                                  ; $46BF
    call Vram_CopyFromBankAuto                    ; $46C2
    pop bc                                        ; $46C5
    dec b                                         ; $46C6
    jr nz, jr_009_46b9                            ; $46C7

    ret                                           ; $46C9


; C: far: tag_count_a / b as two digits
CommentCard_DrawCounters_Far::
    ld de, $95c0                                  ; $46CA
    ld a, [wTagCountA]                            ; $46CD
    call CommentCard_DivMod10                     ; $46D0
    push af                                       ; $46D3
    ld a, c                                       ; $46D4
    call CommentCard_DrawDigit                    ; $46D5
    pop af                                        ; $46D8
    call CommentCard_DrawDigit                    ; $46D9
    ld a, [wTagCountB]                            ; $46DC
    call CommentCard_DivMod10                     ; $46DF
    push af                                       ; $46E2
    ld a, c                                       ; $46E3
    call CommentCard_DrawDigit                    ; $46E4
    pop af                                        ; $46E7
    call CommentCard_DrawDigit                    ; $46E8
    jp Far_Call_Return                            ; $46EB


; C: A -> C = tens; A = units
CommentCard_DivMod10::
    ld c, $00                                     ; $46EE

jr_009_46f0:
    cp $0a                                        ; $46F0
    ret c                                         ; $46F2

    sub $0a                                       ; $46F3
    inc c                                         ; $46F5
    jr jr_009_46f0                                ; $46F6

; C
CommentCard_DrawDigit::
    swap a                                        ; $46F8
    ld c, a                                       ; $46FA
    ld b, $00                                     ; $46FB
    ld hl, Gfx_21_5080_CommentCard_DrawDigit      ; $46FD
    add hl, bc                                    ; $4700
    ld a, BANK(Gfx_21_5080_CommentCard_DrawDigit) ; $4701
    ld bc, $0010                                  ; $4703
    call Vram_CopyFromBankAuto                    ; $4706
    ret                                           ; $4709


; C: far: tag_count_total
CommentCard_DrawTotal_Far::
    ld de, $9390                                  ; $470A
    ld hl, Gfx_21_5080_CommentCard_DrawDigit + $320 ; $470D
    ld a, [wTagCountTotal]                        ; $4710
    ld c, $00                                     ; $4713

jr_009_4715:
    cp $0a                                        ; $4715
    jr c, jr_009_471e                             ; $4717

    sub $0a                                       ; $4719
    inc c                                         ; $471B
    jr jr_009_4715                                ; $471C

jr_009_471e:
    push af                                       ; $471E
    ld a, [wTagCopyFlag]                          ; $471F
    and a                                         ; $4722
    jr nz, jr_009_4728                            ; $4723

    ld hl, Gfx_21_5080_CommentCard_DrawDigit + $A0 ; $4725

jr_009_4728:
    ld a, c                                       ; $4728
    call CommentCard_DrawDigitB                   ; $4729
    ld a, [wTagCopyFlag]                          ; $472C
    and a                                         ; $472F
    jr nz, jr_009_4735                            ; $4730

    ld hl, Gfx_21_5080_CommentCard_DrawDigit + $1E0 ; $4732

jr_009_4735:
    pop af                                        ; $4735
    call CommentCard_DrawDigitB                   ; $4736
    jp Far_Call_Return                            ; $4739


; C
CommentCard_DrawDigitB::
    push hl                                       ; $473C
    swap a                                        ; $473D
    ld c, a                                       ; $473F
    ld b, $00                                     ; $4740
    sla c                                         ; $4742
    rl b                                          ; $4744
    add hl, bc                                    ; $4746
    ld a, BANK(Gfx_21_5080_CommentCard_DrawDigit) ; $4747
    ld bc, $0020                                  ; $4749
    call Vram_CopyFromBankAuto                    ; $474C
    pop hl                                        ; $474F
    ret                                           ; $4750


; C: far: tag_copy_flag chooses tile set
CommentCard_DrawCopyBadge_Far::
    ld a, [wTagCopyFlag]                          ; $4751
    and a                                         ; $4754
    jr z, jr_009_4768                             ; $4755

    farcopy Vram_CopyFromBankAuto, Gfx_21_5870_CommentCard_DrawCopyBadge_Far, $92b0, $00e0 ; $4757
    jp Far_Call_Return                            ; $4765


jr_009_4768:
    farcopy Vram_CopyFromBankAuto, Gfx_21_5790_CommentCard_DrawCopyBadge_Far, $92b0, $00e0 ; $4768
    jp Far_Call_Return                            ; $4776


; C: far
CommentCard_DrawPhotoNumber_Far::
    ld de, $9540                                  ; $4779
    ld a, [wCmtPhotoIndex]                        ; $477C
    cp $1e                                        ; $477F
    jr c, jr_009_4785                             ; $4781

    sub $1e                                       ; $4783

jr_009_4785:
    inc a                                         ; $4785
    ld c, $00                                     ; $4786

jr_009_4788:
    cp $0a                                        ; $4788
    jr c, jr_009_4791                             ; $478A

    sub $0a                                       ; $478C
    inc c                                         ; $478E
    jr jr_009_4788                                ; $478F

jr_009_4791:
    push af                                       ; $4791
    ld a, c                                       ; $4792
    ld hl, Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens ; $4793
    call CommentCard_DrawDigitC                   ; $4796
    pop af                                        ; $4799
    ld hl, Gfx_21_4E00_CommentCard_DrawPhotoNumber_Ones ; $479A
    call CommentCard_DrawDigitC                   ; $479D
    jp Far_Call_Return                            ; $47A0


; C
CommentCard_DrawDigitC::
    swap a                                        ; $47A3
    ld c, a                                       ; $47A5
    ld b, $00                                     ; $47A6
    sla c                                         ; $47A8
    rl b                                          ; $47AA
    sla c                                         ; $47AC
    rl b                                          ; $47AE
    add hl, bc                                    ; $47B0
    ld a, BANK(Gfx_21_4D00_CommentCard_DrawPhotoNumber_Tens) ; $47B1
    ld bc, $0040                                  ; $47B3
    call Vram_CopyFromBankAuto                    ; $47B6
    ret                                           ; $47B9


; C: far: tag_owner_name
CommentCard_DrawOwnerName_Far::
    ld hl, wTagOwnerName                          ; $47BA
    ld de, $8a60                                  ; $47BD
    ld b, $09                                     ; $47C0

jr_009_47c2:
    push bc                                       ; $47C2
    ld a, [hl+]                                   ; $47C3
    push hl                                       ; $47C4
    ld c, BANK(StampCat04_05_SmallKana_Gfx)       ; $47C5
    ld hl, StampCat04_05_SmallKana_Gfx            ; $47C7
    call Glyph_LoadFromCharCode                   ; $47CA
    pop hl                                        ; $47CD
    pop bc                                        ; $47CE
    dec b                                         ; $47CF
    jr nz, jr_009_47c2                            ; $47D0

    jp Far_Call_Return                            ; $47D2


; C: taken when some byte of the number is non-zero: draws the B bytes at HL one after the other with
; CommentCard_DrawHalfByte (branch target; code read 2026-10-19)
CommentCard_DrawNumber_NonZero::
    ld a, [hl+]                                   ; $47D5
    call CommentCard_DrawHalfByte                 ; $47D6
    dec b                                         ; $47D9
    jr nz, CommentCard_DrawNumber_NonZero         ; $47DA

    ret                                           ; $47DC


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentCard_DrawHalfByte::
    push bc                                       ; $47DD
    push hl                                       ; $47DE
    push af                                       ; $47DF
    swap a                                        ; $47E0
    and $0f                                       ; $47E2
    call CommentCard_DrawNibble                   ; $47E4
    pop af                                        ; $47E7
    and $0f                                       ; $47E8
    call CommentCard_DrawNibble                   ; $47EA
    pop hl                                        ; $47ED
    pop bc                                        ; $47EE
    ret                                           ; $47EF


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentCard_DrawNibble::
    and a                                         ; $47F0
    jr z, jr_009_47f4                             ; $47F1

    dec a                                         ; $47F3

jr_009_47f4:
    swap a                                        ; $47F4
    ld c, a                                       ; $47F6
    ld b, $00                                     ; $47F7
    ld hl, Src_21_5620_CommentCard_DrawNibble     ; $47F9
    add hl, bc                                    ; $47FC
    ld a, BANK(Src_21_5620_CommentCard_DrawNibble) ; $47FD
    ld bc, $0010                                  ; $47FF
    call Vram_CopyFromBankAuto                    ; $4802
    ret                                           ; $4805


; C: character code to glyph (bank in C): copies 32 B from HL + (A - 1) x 32 to DE (HL = font base: $4000 = the
; 256-slot font, $6000 = the small-kana table); advances DE via Vram_CopyFromBankAuto
Glyph_LoadFromCharCode::
    push bc                                       ; $4806
    dec a                                         ; $4807
    swap a                                        ; $4808
    push af                                       ; $480A
    and $f0                                       ; $480B
    ld c, a                                       ; $480D
    pop af                                        ; $480E
    and $0f                                       ; $480F
    ld b, a                                       ; $4811
    sla c                                         ; $4812
    rl b                                          ; $4814
    add hl, bc                                    ; $4816
    pop bc                                        ; $4817
    ld a, c                                       ; $4818
    ld bc, $0020                                  ; $4819
    call Vram_CopyFromBankAuto                    ; $481C
    ret                                           ; $481F


; C: sound $12; WY delta table
CommentEditor_SlidePanelOut::
    play_sfx1 SFX1_PANEL_OPEN                     ; $4820
    ld hl, Slide_WyDeltaTbl                       ; $4827
    ld b, $24                                     ; $482A

jr_009_482c:
    push bc                                       ; $482C
    push hl                                       ; $482D
    ldh a, [hWyShadow]                            ; $482E
    add [hl]                                      ; $4830
    ldh [hWyShadow], a                            ; $4831
    rst Rst08_WaitVBlank                          ; $4833
    pop hl                                        ; $4834
    pop bc                                        ; $4835
    inc hl                                        ; $4836
    ld a, b                                       ; $4837
    cp $1d                                        ; $4838
    jr c, jr_009_4841                             ; $483A

    ldh a, [hScyShadow]                           ; $483C
    dec a                                         ; $483E
    ldh [hScyShadow], a                           ; $483F

jr_009_4841:
    dec b                                         ; $4841
    jr nz, jr_009_482c                            ; $4842

    ret                                           ; $4844


; C: sound $13
CommentEditor_SlidePanelIn::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $4845
    ld hl, Slide_WyDeltaTbl                       ; $484C
    ld b, $24                                     ; $484F

jr_009_4851:
    push bc                                       ; $4851
    push hl                                       ; $4852
    ldh a, [hWyShadow]                            ; $4853
    sub [hl]                                      ; $4855
    ldh [hWyShadow], a                            ; $4856
    rst Rst08_WaitVBlank                          ; $4858
    pop hl                                        ; $4859
    pop bc                                        ; $485A
    inc hl                                        ; $485B
    ld a, b                                       ; $485C
    cp $1d                                        ; $485D
    jr c, jr_009_4866                             ; $485F

    ldh a, [hScyShadow]                           ; $4861
    inc a                                         ; $4863
    ldh [hScyShadow], a                           ; $4864

jr_009_4866:
    dec b                                         ; $4866
    jr nz, jr_009_4851                            ; $4867

    ret                                           ; $4869


; C: $A0 * page bytes from 2A:4000 to $8E60
CommentEditor_LoadGridPage::
    ld a, [wCmtGridRow]                           ; $486A
    ld bc, $00a0                                  ; $486D
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $4870
    and a                                         ; $4873
    jr z, jr_009_487a                             ; $4874

jr_009_4876:
    add hl, bc                                    ; $4876
    dec a                                         ; $4877
    jr nz, jr_009_4876                            ; $4878

jr_009_487a:
    ld a, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $487A
    ld de, $8e60                                  ; $487C
    sla c                                         ; $487F
    rl b                                          ; $4881
    call Vram_CopyFromBankAuto                    ; $4883
    ret                                           ; $4886


; C: mode 8: USER (owner name; record; hi-score; credits)
Mode08_UserScreens::
    ld a, [wState]                                ; $4887
    rst Rst18_JumpTable                           ; $488A

; I: 25 states
Mode08_StateTable::
    dw Mode08_State00_Init
    dw Mode08_State01_PlanetMap
    dw Mode08_State02_PlanetOpen
    dw Mode08_State03_CardInit
    dw Mode08_State04_CardShow
    dw Mode08_State05_CardLeave
    dw Mode08_State06_EditorInit
    dw Mode08_State07_EditName
    dw Mode08_State08_EditSex
    dw Mode08_State09_EditBirthDate
    dw Mode08_State0A_EditBloodType
    dw Mode08_State0B_SaveOwner
    dw Mode08_State0C_RecordInit
    dw Mode08_State0D_RecordWait
    dw Mode08_State0E_RecordLeave
    dw Mode08_State0F_HiScoreInit
    dw Mode08_State10_HiScoreWait
    dw Mode08_State11_HiScoreLeave
    dw Mode08_State12_CreditsEntry
    dw Mode08_State13_CreditsPageA
    dw Mode08_State14_CreditsPageA2
    dw Mode08_State15_CreditsPageB
    dw Mode08_State16_CreditsScroll
    dw Mode08_State17_CreditsWaitA
    dw Mode08_State18_CreditsDancingMan
    dw Mode08_State19_Leave

; C
Mode08_State00_Init::
    ldh a, [rLCDC]                                ; $48BF
    bit 7, a                                      ; $48C1
    jr z, jr_009_48da                             ; $48C3

    call UserMap_ScrollOut                        ; $48C5
    ld a, [wAbResult]                             ; $48C8
    bit 1, a                                      ; $48CB
    jr z, jr_009_48da                             ; $48CD

    ld a, MODE_MAIN_MENU                          ; $48CF
    ld [wMode], a                                 ; $48D1
    set_state STATE_00_INIT                       ; $48D4
    ret                                           ; $48D9


jr_009_48da:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $48DA
    ldh [hLcdcShadow], a                          ; $48DC
    ld a, $e4                                     ; $48DE
    ld [wPaletteTarget], a                        ; $48E0
    ld a, $d3                                     ; $48E3
    ld [wPaletteTarget + $1], a                   ; $48E5
    ld a, $93                                     ; $48E8
    ld [wPaletteTarget + $2], a                   ; $48EA
    xor a                                         ; $48ED
    ldh [hScxShadow], a                           ; $48EE
    ldh [hScyShadow], a                           ; $48F0
    ld a, $0f                                     ; $48F2
    ld hl, Gfx_0F_4000_Mode08_State00_Init        ; $48F4
    ld de, $9000                                  ; $48F7
    ld bc, $0800                                  ; $48FA
    call Mem_CopyFromBank                         ; $48FD
    farcopy Mem_CopyFromBank, Gfx_0F_4800_Mode08_State00_Init, $8800, $0800 ; $4900
    farcopy Mem_CopyFromBank, Gfx_0F_5000_Mode08_State00_Init, $8000, $0800 ; $490E
    farcopy Mem_CopyFromBank, Map_26_4EC0_Mode08_State00_Init, $9800, $0240 ; $491C
    ld hl, $9a40                                  ; $492A
    ld bc, $01c0                                  ; $492D
    ld a, $ff                                     ; $4930
    call Mem_FillBc1                              ; $4932
    screen_on                                     ; $4935
    ld a, [wChoice4Cursor]                        ; $493E
    call UserMap_LoadPlanetTiles                  ; $4941
    call Pal_FadeIn                               ; $4944
    play_music MUSIC_USER_SCREENS                 ; $4947
    next_state                                    ; $494E
    ret                                           ; $4952


; C: four planets; Left/Right moves; A opens
Mode08_State01_PlanetMap::
    call UserMap_ReadKeys                         ; $4953
    call UserMap_DrawSprites                      ; $4956
    ldh a, [hKeysNew]                             ; $4959
    and PADF_A | PADF_B | PADF_START              ; $495B
    ret z                                         ; $495D

    ld [wAbResult], a                             ; $495E
    push af                                       ; $4961
    bit 0, a                                      ; $4962
    ld a, SFX1_PANEL_CLOSE                        ; $4964
    call nz, Snd_Sfx1                             ; $4966
    pop af                                        ; $4969
    push af                                       ; $496A
    bit 1, a                                      ; $496B
    ld a, SFX1_KEY_B                              ; $496D
    call nz, Snd_Sfx1                             ; $496F
    pop af                                        ; $4972
    next_state                                    ; $4973
    ret                                           ; $4977


; C
Mode08_State02_PlanetOpen::
    ld a, [wAbResult]                             ; $4978
    bit 0, a                                      ; $497B
    jr nz, jr_009_499a                            ; $497D

    call UserMap_ScrollOut                        ; $497F
    ld a, [wAbResult]                             ; $4982
    bit 1, a                                      ; $4985
    jr z, jr_009_498f                             ; $4987

    set_state STATE_08_INIT                       ; $4989
    ret                                           ; $498E


jr_009_498f:
    ld a, MODE_MAIN_MENU                          ; $498F
    ld [wMode], a                                 ; $4991
    set_state STATE_00_INIT                       ; $4994
    ret                                           ; $4999


jr_009_499a:
    screen_off                                    ; $499A
    ld a, [wChoice4Cursor]                        ; $49A0
    ld c, a                                       ; $49A3
    ld b, $00                                     ; $49A4
    ld hl, Mode08_State02_PlanetOpen_Tbl49D1      ; $49A6
    add hl, bc                                    ; $49A9
    ld a, [hl]                                    ; $49AA
    ld [wState], a                                ; $49AB
    ld a, [wState]                                ; $49AE
    cp $03                                        ; $49B1
    ret nz                                        ; $49B3

    ldh [hFarcallAArg], a                         ; $49B4
    farcall Owner_Load_Far                        ; $49B6
    xor a                                         ; $49BE
    ld hl, wOwnerName                             ; $49BF
    ld b, $0e                                     ; $49C2

jr_009_49c4:
    or [hl]                                       ; $49C4
    inc hl                                        ; $49C5
    dec b                                         ; $49C6
    jr nz, jr_009_49c4                            ; $49C7

    and a                                         ; $49C9
    ret nz                                        ; $49CA

    set_state STATE_08_EDITOR_INIT                ; $49CB
    ret                                           ; $49D0


; C: auto: 4 bytes, bytes; referenced by Mode08_State02_PlanetOpen. L3 pass 2026-10-26: read in BGB in 14 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Mode08_State02_PlanetOpen_Tbl49D1::
    db $03, $0c, $0f, $12

; I: owner card (far 02:5054)
Mode08_State03_CardInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $49D5
    ldh [hLcdcShadow], a                          ; $49D7
    ld a, $e4                                     ; $49D9
    ld [wPaletteTarget], a                        ; $49DB
    ld [wPaletteTarget + $1], a                   ; $49DE
    ld a, $d2                                     ; $49E1
    ld [wPaletteTarget + $2], a                   ; $49E3
    xor a                                         ; $49E6
    ldh [hScxShadow], a                           ; $49E7
    ldh [hScyShadow], a                           ; $49E9
    ldh [hFarcallAArg], a                         ; $49EB
    farcall Owner_Load_Far                        ; $49ED
    farcopy Mem_CopyFromBank, Gfx_1A_5200_Mode08_State03_CardInit, $9000, $0800 ; $49F5
    farcopy Mem_CopyFromBank, Gfx_1A_5A00_Mode08_State03_CardInit, $8800, $0800 ; $4A03
    farcopy Mem_CopyFromBank, Gfx_1A_6200_Mode08_State03_CardInit, $8000, $0160 ; $4A11
    farcopy Mem_CopyFromBank, Map_24_5AE0_Mode08_State03_CardInit, $9800, $0240 ; $4A1F
    ld hl, $9a40                                  ; $4A2D
    ld bc, $01c0                                  ; $4A30
    ld a, $ff                                     ; $4A33
    call Mem_FillBc1                              ; $4A35
    ld a, $50                                     ; $4A38
    ldh [hLycShadowSplit1], a                     ; $4A3A
    ldh [hSplit1Latch], a                         ; $4A3C
    ld hl, hStatShadow                            ; $4A3E
    set 6, [hl]                                   ; $4A41
    ld hl, rIE                                    ; $4A43
    set 1, [hl]                                   ; $4A46
    ld a, $01                                     ; $4A48
    ldh [hStatHandlerIndex], a                    ; $4A4A
    screen_on                                     ; $4A4C
    play_music MUSIC_OWNER_CARD                   ; $4A55
    call OwnerCard_DrawOwnerId                    ; $4A5C
    call OwnerCard_LoadNameGlyphs                 ; $4A5F
    call OwnerCard_DrawGender                     ; $4A62
    call OwnerCard_DrawBirthDate                  ; $4A65
    call Pal_FadeIn                               ; $4A68
    next_state                                    ; $4A6B
    ret                                           ; $4A6F


; C
Mode08_State04_CardShow::
    call OwnerCard_BlinkTitle                     ; $4A70
    ldh a, [hKeysNew]                             ; $4A73
    and PADF_B | PADF_START                       ; $4A75
    ret z                                         ; $4A77

    ld [wAbResult], a                             ; $4A78
    next_state                                    ; $4A7B
    ret                                           ; $4A7F


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_BlinkTitle::
    ldh a, [hFrameCounter]                        ; $4A80
    and $07                                       ; $4A82
    ret z                                         ; $4A84

jr_009_4a85:
    ldh a, [rLY]                                  ; $4A85
    cp $30                                        ; $4A87
    jr c, jr_009_4a85                             ; $4A89

    ldh a, [hFrameCounter]                        ; $4A8B
    bit 3, a                                      ; $4A8D
    jr nz, jr_009_4aae                            ; $4A8F

    farcopy Vram_CopyFromBank, Map_24_5AE0_Mode08_State03_CardInit, $9800, $0080 ; $4A91
    farcopy Vram_CopyFromBank, Map_24_5D00_OwnerCard_BlinkTitle, $9a20, $0020 ; $4A9F
    ret                                           ; $4AAD


jr_009_4aae:
    farcopy Vram_CopyFromBank, Map_24_5D20_OwnerCard_BlinkTitle, $9800, $0080 ; $4AAE
    farcopy Vram_CopyFromBank, Map_24_5DA0_OwnerCard_BlinkTitle, $9a20, $0020 ; $4ABC
    ret                                           ; $4ACA


; C
Mode08_State05_CardLeave::
    ld a, [wAbResult]                             ; $4ACB
    bit 3, a                                      ; $4ACE
    jr z, jr_009_4ae7                             ; $4AD0

    screen_off                                    ; $4AD2
    stat_irq_off                                  ; $4AD8
    next_state                                    ; $4AE2
    ret                                           ; $4AE6


jr_009_4ae7:
    screen_off                                    ; $4AE7
    stat_irq_off                                  ; $4AED
    set_state STATE_08_INIT                       ; $4AF7
    ret                                           ; $4AFC


; I: on-screen keyboard
Mode08_State06_EditorInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4AFD
    ldh [hLcdcShadow], a                          ; $4AFF
    ld a, $e4                                     ; $4B01
    ld [wPaletteTarget], a                        ; $4B03
    ld [wPaletteTarget + $1], a                   ; $4B06
    ld a, $d2                                     ; $4B09
    ld [wPaletteTarget + $2], a                   ; $4B0B
    ld a, $fc                                     ; $4B0E
    ldh [hScyShadow], a                           ; $4B10
    xor a                                         ; $4B12
    ldh [hScxShadow], a                           ; $4B13
    ld [wKbCursor], a                             ; $4B15
    ld [wKbKey], a                                ; $4B18
    ld [wKbPage], a                               ; $4B1B
    ld [wKbTabFrame], a                           ; $4B1E
    ld [wKbTabFrame + $1], a                      ; $4B21
    ld [wKbTabFrame + $2], a                      ; $4B24
    farcopy Mem_CopyFromBank, Gfx_20_5B00_Mode08_State06_EditorInit, $9000, $0580 ; $4B27
    farcopy Mem_CopyFromBank, Gfx_20_6080_Mode08_State06_EditorInit, $8000, $0440 ; $4B35
    farcopy Mem_CopyFromBank, Gfx_20_67C0_Mode08_State06_EditorInit, $8440, $0020 ; $4B43
    farcopy Mem_CopyFromBank, Map_23_73E0_Mode08_State06_EditorInit, $9800, $0240 ; $4B51
    ld hl, $9a40                                  ; $4B5F
    ld bc, $01c0                                  ; $4B62
    ld a, $ff                                     ; $4B65
    call Mem_FillBc1                              ; $4B67
    screen_on                                     ; $4B6A
    play_music MUSIC_OWNER_CARD                   ; $4B73
    call Kb_LoadGlyphSetA                         ; $4B7A
    call OwnerCard_LoadNameGlyphsB                ; $4B7D
    call OwnerCard_LoadGenderTiles                ; $4B80
    call OwnerCard_LoadBirthTiles                 ; $4B83
    call Pal_FadeIn                               ; $4B86
    next_state                                    ; $4B89
    ret                                           ; $4B8D


; C: tab page 0..2
Mode08_State07_EditName::
    call Kb_Page0_Navigate                        ; $4B8E
    call Kb_Page0_Draw                            ; $4B91
    call Kb_Page0_Press                           ; $4B94
    call Kb_BackspaceOnB                          ; $4B97
    call Kb_BlinkBackground                       ; $4B9A
    ret                                           ; $4B9D


; C
Mode08_State08_EditSex::
    call Kb_Page1_Navigate                        ; $4B9E
    call Kb_Page1_Draw                            ; $4BA1
    call Kb_Page1_PressSex                        ; $4BA4
    call Kb_BlinkBackground                       ; $4BA7
    ret                                           ; $4BAA


; C
Mode08_State09_EditBirthDate::
    call Kb_Page2_Navigate                        ; $4BAB
    call Kb_Page2_Draw                            ; $4BAE
    call Kb_Page2_PressBirthDate                  ; $4BB1
    call Kb_BackspaceOnB                          ; $4BB4
    call Kb_BlinkBackground                       ; $4BB7
    ret                                           ; $4BBA


; C: Japanese ROM only
Mode08_State0A_EditBloodType::
    call Kb_Page3_Navigate                        ; $4BBB
    call Kb_Page3_Draw                            ; $4BBE
    call Kb_Page3_PressBloodType                  ; $4BC1
    call Kb_BlinkBackground                       ; $4BC4
    ret                                           ; $4BC7


; C: far 02:4BF4; then state 3
Mode08_State0B_SaveOwner::
    screen_off                                    ; $4BC8
    ldh [hFarcallAArg], a                         ; $4BCE
    farcall Owner_Store_Far                       ; $4BD0
    set_state STATE_08_CARD_INIT                  ; $4BD8
    ret                                           ; $4BDD


; C: far 02:503F; draws the counters
Mode08_State0C_RecordInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $4BDE
    ldh [hLcdcShadow], a                          ; $4BE0
    ld a, $e4                                     ; $4BE2
    ld [wPaletteTarget], a                        ; $4BE4
    ld [wPaletteTarget + $1], a                   ; $4BE7
    ld a, $d2                                     ; $4BEA
    ld [wPaletteTarget + $2], a                   ; $4BEC
    xor a                                         ; $4BEF
    ldh [hScxShadow], a                           ; $4BF0
    ldh [hScyShadow], a                           ; $4BF2
    ldh [hFarcallAArg], a                         ; $4BF4
    farcall Counters_Load_Far                     ; $4BF6
    farcopy Mem_CopyFromBank, Gfx_20_4E00_Mode08_State0C_RecordInit, $9000, $0800 ; $4BFE
    farcopy Mem_CopyFromBank, Gfx_20_5600_Mode08_State0C_RecordInit, $8800, $0500 ; $4C0C
    farcopy Mem_CopyFromBank, Map_26_60C0_Mode08_State0C_RecordInit, $9800, $0240 ; $4C1A
    ld hl, $9a40                                  ; $4C28
    ld bc, $01c0                                  ; $4C2B
    ld a, $ff                                     ; $4C2E
    call Mem_FillBc1                              ; $4C30
    screen_on                                     ; $4C33
    call Record_DrawCounters                      ; $4C3C
    call Pal_FadeIn                               ; $4C3F
    play_music MUSIC_RECORD_HI_SCORE              ; $4C42
    next_state                                    ; $4C49
    ret                                           ; $4C4D


; C
Mode08_State0D_RecordWait::
    ldh a, [hKeysNew]                             ; $4C4E
    and PADF_A | PADF_B                           ; $4C50
    ret z                                         ; $4C52

    next_state                                    ; $4C53
    ret                                           ; $4C57


; C
Mode08_State0E_RecordLeave::
    screen_off                                    ; $4C58
    set_state STATE_08_INIT                       ; $4C5E
    ret                                           ; $4C63


; C
Mode08_State0F_HiScoreInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $4C64
    ldh [hLcdcShadow], a                          ; $4C66
    ld a, $e4                                     ; $4C68
    ld [wPaletteTarget], a                        ; $4C6A
    ld [wPaletteTarget + $1], a                   ; $4C6D
    ld a, $d2                                     ; $4C70
    ld [wPaletteTarget + $2], a                   ; $4C72
    xor a                                         ; $4C75
    ldh [hScxShadow], a                           ; $4C76
    ldh [hScyShadow], a                           ; $4C78
    ldh [hFarcallAArg], a                         ; $4C7A
    farcall Counters_Load_Far                     ; $4C7C
    farcopy Mem_CopyFromBank, Gfx_20_4E00_Mode08_State0C_RecordInit, $9000, $0800 ; $4C84
    farcopy Mem_CopyFromBank, Gfx_20_5600_Mode08_State0C_RecordInit, $8800, $0500 ; $4C92
    farcopy Mem_CopyFromBank, Map_25_5D20_Mode08_State0F_HiScoreInit, $9800, $0240 ; $4CA0
    ld hl, $9a40                                  ; $4CAE
    ld bc, $01c0                                  ; $4CB1
    ld a, $ff                                     ; $4CB4
    call Mem_FillBc1                              ; $4CB6
    screen_on                                     ; $4CB9
    call HiScore_DrawScores                       ; $4CC2
    call Pal_FadeIn                               ; $4CC5
    play_music MUSIC_RECORD_HI_SCORE              ; $4CC8
    next_state                                    ; $4CCF
    ret                                           ; $4CD3


; C
Mode08_State10_HiScoreWait::
    ldh a, [hKeysNew]                             ; $4CD4
    and PADF_A | PADF_B                           ; $4CD6
    ret z                                         ; $4CD8

    next_state                                    ; $4CD9
    ret                                           ; $4CDD


; C
Mode08_State11_HiScoreLeave::
    screen_off                                    ; $4CDE
    set_state STATE_08_INIT                       ; $4CE4
    ret                                           ; $4CE9


; C: fade out and state 0
Mode08_CreditsAbort::
    screen_off                                    ; $4CEA
    jr jr_009_4d0e                                ; $4CF0

; I: record >= $7799 chooses the real credits
Mode08_State12_CreditsEntry::
    ldh [hFarcallAArg], a                         ; $4CF2
    farcall Counters_Load_Far                     ; $4CF4
    ld a, [wBestRun + $1]                         ; $4CFC
    cp $77                                        ; $4CFF
    jr c, jr_009_4d0e                             ; $4D01

    jp nz, Mode08_CreditsReal                     ; $4D03

    ld a, [wBestRun]                              ; $4D06
    cp $99                                        ; $4D09
    jp z, Mode08_CreditsReal                      ; $4D0B

jr_009_4d0e:
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4D0E
    ldh [hLcdcShadow], a                          ; $4D10
    ld a, $e4                                     ; $4D12
    ld [wPaletteTarget], a                        ; $4D14
    ld [wPaletteTarget + $1], a                   ; $4D17
    ld [wPaletteTarget + $2], a                   ; $4D1A
    xor a                                         ; $4D1D
    ldh [hScxShadow], a                           ; $4D1E
    ldh [hScyShadow], a                           ; $4D20
    ld [wCredAnimPhase], a                        ; $4D22
    ld [wCredFrameTimer], a                       ; $4D25
    ld [wCredSpritePhase], a                      ; $4D28
    ld [wCredSubDivider], a                       ; $4D2B
    farcopy Mem_CopyFromBank, Gfx_22_4500_CreditsNishimuraDanceFrame00, $9000, $0470 ; $4D2E
    farcopy Mem_CopyFromBank, Map_26_5C40_CreditsNishimuraDanceMap0, $9800, $0240 ; $4D3C
    ld hl, $9a40                                  ; $4D4A
    ld bc, $01c0                                  ; $4D4D
    ld a, $ff                                     ; $4D50
    call Mem_FillBc1                              ; $4D52
    ld hl, $8fe0                                  ; $4D55
    ld bc, $0010                                  ; $4D58
    ld de, $ffff                                  ; $4D5B
    call Mem_FillWords                            ; $4D5E
    ld hl, $8ff0                                  ; $4D61
    ld bc, $0010                                  ; $4D64
    ld de, $0000                                  ; $4D67
    call Mem_FillWords                            ; $4D6A
    screen_on                                     ; $4D6D
    call Pal_FadeIn                               ; $4D76
    play_music MUSIC_JINGLE                       ; $4D79
    set_state STATE_08_CREDITS_DANCING_MAN        ; $4D80
    ret                                           ; $4D85


; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Mode08_CreditsReal::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4D86
    ldh [hLcdcShadow], a                          ; $4D88
    ld a, $e4                                     ; $4D8A
    ld [wPaletteTarget], a                        ; $4D8C
    ld [wPaletteTarget + $1], a                   ; $4D8F
    ld [wPaletteTarget + $2], a                   ; $4D92
    xor a                                         ; $4D95
    ldh [hScxShadow], a                           ; $4D96
    ldh [hScyShadow], a                           ; $4D98
    ld [wCredAnimPhase], a                        ; $4D9A
    ld [wCredFrameTimer], a                       ; $4D9D
    ld [wCredStepCounter], a                      ; $4DA0
    farcopy Mem_CopyFromBank, Gfx_13_7000_Mode08_CreditsReal, $9000, $0800 ; $4DA3
    farcopy Mem_CopyFromBank, Gfx_13_7800_Mode08_CreditsReal, $8800, $0800 ; $4DB1
    farcopy Mem_CopyFromBank, Map_1C_7C60_Mode08_CreditsReal, $9800, $0240 ; $4DBF
    call Pal_AllWhite                             ; $4DCD
    call Lcd_On                                   ; $4DD0
    call Pal_FadeIn                               ; $4DD3
    play_music MUSIC_CREDITS                      ; $4DD6
    next_state                                    ; $4DDD
    ret                                           ; $4DE1


; I: CLIP THIS. page
Mode08_State13_CreditsPageA::
    ldh a, [hKeysNew]                             ; $4DE2
    bit PADB_B, a                                 ; $4DE4
    jp nz, Mode08_CreditsAbort                    ; $4DE6

    ld a, [wCredFrameTimer]                       ; $4DE9
    inc a                                         ; $4DEC
    cp $08                                        ; $4DED
    jr c, jr_009_4df2                             ; $4DEF

    xor a                                         ; $4DF1

jr_009_4df2:
    ld [wCredFrameTimer], a                       ; $4DF2
    ret nz                                        ; $4DF5

    ld a, [wCredAnimPhase]                        ; $4DF6
    inc a                                         ; $4DF9
    and $01                                       ; $4DFA
    ld [wCredAnimPhase], a                        ; $4DFC
    jr nz, jr_009_4e11                            ; $4DFF

    farcopy Vram_CopyFromBank, Map_1C_7D00_Mode08_State13_CreditsPageA, $98a0, $0160 ; $4E01
    jr jr_009_4e1f                                ; $4E0F

jr_009_4e11:
    farcopy Vram_CopyFromBank, Map_1C_7EA0_Mode08_State13_CreditsPageA, $98a0, $0160 ; $4E11

jr_009_4e1f:
    ld a, [wCredStepCounter]                      ; $4E1F
    inc a                                         ; $4E22
    ld [wCredStepCounter], a                      ; $4E23
    cp $34                                        ; $4E26
    ret c                                         ; $4E28

    call Call_009_4e6d                            ; $4E29
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4E2C
    ldh [hLcdcShadow], a                          ; $4E2E
    xor a                                         ; $4E30
    ldh [hScxShadow], a                           ; $4E31
    ldh [hScyShadow], a                           ; $4E33
    ld [wCredFrameTimer], a                       ; $4E35
    ld [wCredSubDivider], a                       ; $4E38
    farcopy Vram_CopyFromBank, Gfx_19_5260_Mode08_State13_CreditsPageA, $9000, $0800 ; $4E3B
    farcopy Vram_CopyFromBank, Gfx_19_5A60_Mode08_State13_CreditsPageA, $8800, $0800 ; $4E49
    farcopy Vram_CopyFromBank, Map_27_52F0_Mode08_State13_CreditsPageA, $9800, $0240 ; $4E57
    call Call_009_4e86                            ; $4E65
    next_state                                    ; $4E68
    ret                                           ; $4E6C


Call_009_4e6d:
    ld a, $f9                                     ; $4E6D
    ldh [hBgpShadow], a                           ; $4E6F
    ld bc, $0002                                  ; $4E71
    call Wait_Frames                              ; $4E74
    ld a, $fe                                     ; $4E77
    ldh [hBgpShadow], a                           ; $4E79
    ld bc, $0002                                  ; $4E7B
    call Wait_Frames                              ; $4E7E
    ld a, $ff                                     ; $4E81
    ldh [hBgpShadow], a                           ; $4E83
    ret                                           ; $4E85


Call_009_4e86:
    ld a, $fe                                     ; $4E86
    ldh [hBgpShadow], a                           ; $4E88
    ld bc, $0002                                  ; $4E8A
    call Wait_Frames                              ; $4E8D
    ld a, $f9                                     ; $4E90
    ldh [hBgpShadow], a                           ; $4E92
    ld bc, $0002                                  ; $4E94
    call Wait_Frames                              ; $4E97
    ld a, $e4                                     ; $4E9A
    ldh [hBgpShadow], a                           ; $4E9C
    ret                                           ; $4E9E


; I: credits state $14, new in this build (the Japanese table has 25 states, this one 26): same shape as
; Mode08_State13_CreditsPageA (abort test, VRAM copies from other banks, two timed waits), so a second credits page
; shown between page A and page B; its content not checked in BGB
Mode08_State14_CreditsPageA2::
    ldh a, [hKeysNew]                             ; $4E9F
    bit PADB_B, a                                 ; $4EA1
    jp nz, Mode08_CreditsAbort                    ; $4EA3

    ldh a, [hFrameCounter]                        ; $4EA6
    ld b, a                                       ; $4EA8
    and $1f                                       ; $4EA9
    jr nz, jr_009_4ecf                            ; $4EAB

    bit 5, b                                      ; $4EAD
    jr nz, jr_009_4ec1                            ; $4EAF

    farcopy Vram_CopyFromBank, Map_27_5370_Mode08_State14_CreditsPageA2, $9880, $0040 ; $4EB1
    jr jr_009_4ecf                                ; $4EBF

jr_009_4ec1:
    farcopy Vram_CopyFromBank, Map_27_5530_Mode08_State14_CreditsPageA2, $9880, $0040 ; $4EC1

jr_009_4ecf:
    ld a, b                                       ; $4ECF
    and $0f                                       ; $4ED0
    jr nz, jr_009_4ef6                            ; $4ED2

    bit 4, b                                      ; $4ED4
    jr nz, jr_009_4ee8                            ; $4ED6

    farcopy Vram_CopyFromBank, Map_27_5470_Mode08_State14_CreditsPageA2, $9980, $0040 ; $4ED8
    jr jr_009_4ef6                                ; $4EE6

jr_009_4ee8:
    farcopy Vram_CopyFromBank, Map_27_5570_Mode08_State14_CreditsPageA2, $9980, $0040 ; $4EE8

jr_009_4ef6:
    ld hl, wCredFrameTimer                        ; $4EF6
    ld a, [wCredSubDivider]                       ; $4EF9
    inc a                                         ; $4EFC
    cp $3c                                        ; $4EFD
    jr c, jr_009_4f03                             ; $4EFF

    inc [hl]                                      ; $4F01
    xor a                                         ; $4F02

jr_009_4f03:
    ld [wCredSubDivider], a                       ; $4F03
    ld a, [hl]                                    ; $4F06
    cp $04                                        ; $4F07
    ret c                                         ; $4F09

    call Call_009_4f8c                            ; $4F0A
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4F0D
    ldh [hLcdcShadow], a                          ; $4F0F
    xor a                                         ; $4F11
    ldh [hScxShadow], a                           ; $4F12
    ldh [hScyShadow], a                           ; $4F14
    ld [wCredAnimPhase], a                        ; $4F16
    ld [wCredStepCounter], a                      ; $4F19
    ld [wCredFrameTimer], a                       ; $4F1C
    ld [wCredSubDivider], a                       ; $4F1F
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $9800, $0040 ; $4F22
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $9840, $0040 ; $4F30
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $9880, $0040 ; $4F3E
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $98c0, $0040 ; $4F4C
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $9900, $0040 ; $4F5A
    farcopy Vram_CopyFromBank, Map_27_55B0_Mode08_State14_CreditsPageA2, $9940, $0040 ; $4F68
    farcopy Vram_CopyFromBank, Map_27_5730_Mode08_State14_CreditsPageA2, $9980, $00c0 ; $4F76
    call Call_009_4fa5                            ; $4F84
    next_state                                    ; $4F87
    ret                                           ; $4F8B


Call_009_4f8c:
    ld a, $f9                                     ; $4F8C
    ldh [hBgpShadow], a                           ; $4F8E
    ld bc, $0002                                  ; $4F90
    call Wait_Frames                              ; $4F93
    ld a, $fe                                     ; $4F96
    ldh [hBgpShadow], a                           ; $4F98
    ld bc, $0002                                  ; $4F9A
    call Wait_Frames                              ; $4F9D
    ld a, $ff                                     ; $4FA0
    ldh [hBgpShadow], a                           ; $4FA2
    ret                                           ; $4FA4


Call_009_4fa5:
    ld a, $fe                                     ; $4FA5
    ldh [hBgpShadow], a                           ; $4FA7
    ld bc, $0002                                  ; $4FA9
    call Wait_Frames                              ; $4FAC
    ld a, $f9                                     ; $4FAF
    ldh [hBgpShadow], a                           ; $4FB1
    ld bc, $0002                                  ; $4FB3
    call Wait_Frames                              ; $4FB6
    ld a, $e4                                     ; $4FB9
    ldh [hBgpShadow], a                           ; $4FBB
    ret                                           ; $4FBD


; I: credits state $15 (Japanese state $14, one later because of the new state $14); 25 of its 85 Japanese
; instructions do not pair as the same code (other copies)
Mode08_State15_CreditsPageB::
    ldh a, [hKeysNew]                             ; $4FBE
    bit PADB_B, a                                 ; $4FC0
    jp nz, Mode08_CreditsAbort                    ; $4FC2

    ld a, [wCredStepCounter]                      ; $4FC5
    and a                                         ; $4FC8
    jr nz, jr_009_4fe9                            ; $4FC9

    ld hl, wCredAnimPhase                         ; $4FCB
    inc [hl]                                      ; $4FCE
    ld a, [hl]                                    ; $4FCF
    sub $0a                                       ; $4FD0
    ret c                                         ; $4FD2

    ld b, a                                       ; $4FD3
    and $07                                       ; $4FD4
    ret nz                                        ; $4FD6

    ld a, b                                       ; $4FD7
    cp $50                                        ; $4FD8
    jr c, jr_009_4fe4                             ; $4FDA

    xor a                                         ; $4FDC
    ld [wCredAnimPhase], a                        ; $4FDD
    ld hl, wCredStepCounter                       ; $4FE0
    inc [hl]                                      ; $4FE3

jr_009_4fe4:
    call Call_009_509d                            ; $4FE4
    jr jr_009_5007                                ; $4FE7

jr_009_4fe9:
    cp $01                                        ; $4FE9
    jr nz, jr_009_5007                            ; $4FEB

    ld hl, wCredAnimPhase                         ; $4FED
    inc [hl]                                      ; $4FF0
    ld a, [hl]                                    ; $4FF1
    cp $05                                        ; $4FF2
    ret c                                         ; $4FF4

    ld hl, wCredStepCounter                       ; $4FF5
    inc [hl]                                      ; $4FF8
    farcopy Vram_CopyFromBank, Map_27_57F0_Mode08_State15_CreditsPageB, $9980, $0020 ; $4FF9

jr_009_5007:
    ld hl, wCredFrameTimer                        ; $5007
    ld a, [wCredSubDivider]                       ; $500A
    inc a                                         ; $500D
    cp $3c                                        ; $500E
    jr c, jr_009_5014                             ; $5010

    inc [hl]                                      ; $5012
    xor a                                         ; $5013

jr_009_5014:
    ld [wCredSubDivider], a                       ; $5014
    ld a, [hl]                                    ; $5017
    cp $04                                        ; $5018
    ret c                                         ; $501A

    screen_off                                    ; $501B
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $5021
    ldh [hLcdcShadow], a                          ; $5023
    ld a, $d1                                     ; $5025
    ld [wPaletteTarget], a                        ; $5027
    ld a, $f3                                     ; $502A
    ld [wPaletteTarget + $1], a                   ; $502C
    ld [wPaletteTarget + $2], a                   ; $502F
    ld a, $28                                     ; $5032
    ldh [hScxShadow], a                           ; $5034
    xor a                                         ; $5036
    ldh [hScyShadow], a                           ; $5037
    ld [wCredAnimPhase], a                        ; $5039
    ld [wCredFrameTimer], a                       ; $503C
    ld [wCredStepCounter], a                      ; $503F
    ld [wScrollScriptDone], a                     ; $5042
    ld [wScrollSubstate], a                       ; $5045
    farcopy Mem_CopyFromBank, Gfx_25_4480_Mode08_State14_CreditsPageB, $8000, $0500 ; $5048
    ld a, $20                                     ; $5056
    ld hl, Gfx_20_4000_Mode08_State14_CreditsPageB ; $5058
    ld de, $9000                                  ; $505B
    ld bc, $0800                                  ; $505E
    call Mem_CopyFromBank                         ; $5061
    farcopy Mem_CopyFromBank, Gfx_20_4800_Mode08_State14_CreditsPageB, $8a00, $0600 ; $5064
    ld hl, $9800                                  ; $5072
    ld bc, $0400                                  ; $5075
    ld a, $ff                                     ; $5078
    call Mem_FillBc1                              ; $507A
    call Oam_ClearShadow                          ; $507D
    ld bc, $5048                                  ; $5080
    ld a, $b8                                     ; $5083
    call Oam_AddMeta_B02_52BD                     ; $5085
    call Pal_AllWhite                             ; $5088
    call Lcd_On                                   ; $508B
    call Pal_FadeIn                               ; $508E
    play_music MUSIC_CREDITS_PAGE_B               ; $5091
    next_state                                    ; $5098
    ret                                           ; $509C


Call_009_509d:
    ld a, b                                       ; $509D
    srl a                                         ; $509E
    srl a                                         ; $50A0
    srl a                                         ; $50A2
    cpl                                           ; $50A4
    add $0a                                       ; $50A5
    swap a                                        ; $50A7
    push af                                       ; $50A9
    and $f0                                       ; $50AA
    ld c, a                                       ; $50AC
    pop af                                        ; $50AD
    and $0f                                       ; $50AE
    ld b, a                                       ; $50B0
    sla c                                         ; $50B1
    rl b                                          ; $50B3
    ld hl, $9840                                  ; $50B5
    add hl, bc                                    ; $50B8
    push hl                                       ; $50B9
    ld hl, Map_27_55D0_Mode04_State00_Init + $20  ; $50BA
    add hl, bc                                    ; $50BD
    ld a, BANK(Map_27_55D0_Mode04_State00_Init)   ; $50BE
    pop de                                        ; $50C0
    ld bc, $0020                                  ; $50C1
    call Vram_CopyFromBank                        ; $50C4
    ret                                           ; $50C7


; C: credits state $16 (Japanese $15): staff roll via ScrollEngine_Step; the same code but `ld a, $25` at 09:5174
; (Japanese $26)
Mode08_State16_CreditsScroll::
    ldh a, [hKeysNew]                             ; $50C8
    bit PADB_B, a                                 ; $50CA
    jp nz, Mode08_CreditsAbort                    ; $50CC

    call ScrollEngine_Step                        ; $50CF
    ld a, [wCredAnimPhase]                        ; $50D2
    sla a                                         ; $50D5
    sla a                                         ; $50D7
    ld c, a                                       ; $50D9
    ld b, $00                                     ; $50DA
    ld hl, Credits_ScrollFrameTbl + $3            ; $50DC
    add hl, bc                                    ; $50DF
    ld a, [wCredFrameTimer]                       ; $50E0
    inc a                                         ; $50E3
    cp [hl]                                       ; $50E4
    jr c, jr_009_50e8                             ; $50E5

    xor a                                         ; $50E7

jr_009_50e8:
    ld [wCredFrameTimer], a                       ; $50E8
    and a                                         ; $50EB
    jr nz, jr_009_5126                            ; $50EC

    ld a, [wCredAnimPhase]                        ; $50EE
    inc a                                         ; $50F1
    cp $0d                                        ; $50F2
    jr nz, jr_009_50f7                            ; $50F4

    xor a                                         ; $50F6

jr_009_50f7:
    ld [wCredAnimPhase], a                        ; $50F7
    ld a, [wCredStepCounter]                      ; $50FA
    xor $01                                       ; $50FD
    ld [wCredStepCounter], a                      ; $50FF
    ld de, $8000                                  ; $5102
    and a                                         ; $5105
    jr z, jr_009_510b                             ; $5106

    ld de, $8500                                  ; $5108

jr_009_510b:
    ld a, [wCredAnimPhase]                        ; $510B
    sla a                                         ; $510E
    sla a                                         ; $5110
    ld c, a                                       ; $5112
    ld b, $00                                     ; $5113
    ld hl, Credits_ScrollFrameTbl                 ; $5115
    add hl, bc                                    ; $5118
    ld c, [hl]                                    ; $5119
    inc hl                                        ; $511A
    ld b, [hl]                                    ; $511B
    inc hl                                        ; $511C
    ld a, [hl]                                    ; $511D
    ld h, b                                       ; $511E
    ld l, c                                       ; $511F
    ld bc, $0500                                  ; $5120
    call Vram_CopyFromBank                        ; $5123

jr_009_5126:
    ld a, [wCredStepCounter]                      ; $5126
    ld c, a                                       ; $5129
    ld b, $00                                     ; $512A
    ld hl, Credits_ScrollSpriteTileTbl            ; $512C
    add hl, bc                                    ; $512F
    ld d, [hl]                                    ; $5130
    ld bc, $6048                                  ; $5131
    ld a, [wCredAnimPhase]                        ; $5134
    add $b8                                       ; $5137
    call Oam_AddMetaTile_B02_52BD                 ; $5139
    ld a, [wScrollScriptDone]                     ; $513C
    and a                                         ; $513F
    ret z                                         ; $5140

    call Pal_FadeOut                              ; $5141
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BGON   ; $5144
    ldh [hLcdcShadow], a                          ; $5146
    ld a, $e4                                     ; $5148
    ld [wPaletteTarget], a                        ; $514A
    ld [wPaletteTarget + $1], a                   ; $514D
    ld [wPaletteTarget + $2], a                   ; $5150
    xor a                                         ; $5153
    ldh [hScxShadow], a                           ; $5154
    ldh [hScyShadow], a                           ; $5156
    farcopy Vram_CopyFromBank, Gfx_28_7000_CreditsEndingPlate_TilesA, $9000, $0800 ; $5158
    farcopy Vram_CopyFromBank, Gfx_28_7800_Mode08_State16_CreditsScroll, $8800, $0800 ; $5166
    farcopy Vram_CopyFromBank, Src_25_7CA0_Tbl539D_40, $9800, $0240 ; $5174
    call Pal_AllWhite                             ; $5182
    call Pal_FadeIn                               ; $5185
    next_state                                    ; $5188
    ret                                           ; $518C


; C: 2 bytes: OAM tile-number offset of the dancer sprite, indexed by the buffer toggle $C005. L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Credits_ScrollSpriteTileTbl::
    dw $5000

; C: 13 records {lo,hi,bank,duration}: the staff-roll dancer frames (a dancing girl, not identified) (0x500 bytes
; each, 12 frames per record); copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll; checked by running
; the real credits (core and BGB)
Credits_ScrollFrameTbl::
    dwb Gfx_25_4480_Mode08_State14_CreditsPageB
    db $0c
    dwb Gfx_24_4000_CreditsGirlFrame01
    db $0c
    dw Gfx_22_4DE0_CreditsGirlFrame10 + $460
    db BANK(Gfx_22_4DE0_CreditsGirlFrame10)
    db $0c
    dwb Gfx_22_4000_CreditsGirlFrame03
    db $0c
    dwb Gfx_17_7B00_CreditsGirlFrame04
    db $0c
    dwb Gfx_25_4000_CreditsGirlFrame05
    db $0c
    dwb Gfx_26_4000_CreditsGirlFrame06
    db $0c
    dw Gfx_22_5240_CreditsGirlFrame02_Part52E0 + $3C0
    db BANK(Gfx_22_5240_CreditsGirlFrame02_Part52E0)
    db $0c
    dwb Gfx_22_6F40_CreditsGirlFrame08
    db $0c
    dwb Gfx_23_4000_CreditsGirlFrame09
    db $0c
    dwb Gfx_22_4DE0_CreditsGirlFrame10
    db $0c
    dw Gfx_22_56A0_CreditsGirlFrame07_Part5740 + $3C0
    db BANK(Gfx_22_56A0_CreditsGirlFrame07_Part5740)
    db $0c
    dwb Gfx_23_6C80_CreditsGirlFrame12
    db $0c

; C: credits state $17 (Japanese $16): A -> state $19 (`ld a, $19 / ld [wState], a` at 09:51CD; Japanese $18)
Mode08_State17_CreditsWaitA::
    ldh a, [hKeysNew]                             ; $51C3
    bit PADB_B, a                                 ; $51C5
    jp nz, Mode08_CreditsAbort                    ; $51C7

    bit PADB_A, a                                 ; $51CA
    ret z                                         ; $51CC

    set_state STATE_08_LEAVE                      ; $51CD
    ret                                           ; $51D2


; C: credits state $18 (Japanese $17), same code
Mode08_State18_CreditsDancingMan::
    ld a, [wCredAnimPhase]                        ; $51D3
    sla a                                         ; $51D6
    sla a                                         ; $51D8
    ld c, a                                       ; $51DA
    ld b, $00                                     ; $51DB
    ld hl, Credits_NishimuraDanceFrameTbl + $3    ; $51DD
    add hl, bc                                    ; $51E0
    ld a, [wCredFrameTimer]                       ; $51E1
    inc a                                         ; $51E4
    cp [hl]                                       ; $51E5
    jr c, jr_009_51e9                             ; $51E6

    xor a                                         ; $51E8

jr_009_51e9:
    ld [wCredFrameTimer], a                       ; $51E9
    and a                                         ; $51EC
    jr nz, jr_009_5220                            ; $51ED

    ld a, [wCredAnimPhase]                        ; $51EF
    inc a                                         ; $51F2
    cp $04                                        ; $51F3
    jr nz, jr_009_51ff                            ; $51F5

    ld a, [wCredSubDivider]                       ; $51F7
    inc a                                         ; $51FA
    ld [wCredSubDivider], a                       ; $51FB
    xor a                                         ; $51FE

jr_009_51ff:
    ld [wCredAnimPhase], a                        ; $51FF
    ld de, $9000                                  ; $5202
    ld a, [wCredAnimPhase]                        ; $5205
    sla a                                         ; $5208
    sla a                                         ; $520A
    ld c, a                                       ; $520C
    ld b, $00                                     ; $520D
    ld hl, Credits_NishimuraDanceFrameTbl         ; $520F
    add hl, bc                                    ; $5212
    ld c, [hl]                                    ; $5213
    inc hl                                        ; $5214
    ld b, [hl]                                    ; $5215
    inc hl                                        ; $5216
    ld a, [hl]                                    ; $5217
    ld h, b                                       ; $5218
    ld l, c                                       ; $5219
    ld bc, $0470                                  ; $521A
    call Vram_CopyFromBank                        ; $521D

jr_009_5220:
    ld a, [wCredSubDivider]                       ; $5220
    cp $0a                                        ; $5223
    jr c, jr_009_522b                             ; $5225

    call Credits_NextDancingFrame                 ; $5227
    xor a                                         ; $522A

jr_009_522b:
    ld [wCredSubDivider], a                       ; $522B
    ldh a, [hKeysNew]                             ; $522E
    and PADF_A | PADF_B                           ; $5230
    ret z                                         ; $5232

    next_state                                    ; $5233
    ret                                           ; $5237


; I: 4 records {lo,hi,bank,duration=8}: frames of the dance of Kentaro Nishimura (credited CORDINATOR (sic) and SOUND
; COMPOSER; the 'Miyamoto' attribution found on the web is an error, owner) of the short credits (22:4500, 22:4970,
; 27:4000, 22:4970; 0x470 bytes each) used by ...
Credits_NishimuraDanceFrameTbl::
    dwb Gfx_22_4500_CreditsNishimuraDanceFrame00
    db $08
    dwb Gfx_22_4970_CreditsNishimuraDanceFrame01
    db $08
    dwb Gfx_27_4C00_CreditsNishimuraDanceFrame02
    db $08
    dwb Gfx_22_4970_CreditsNishimuraDanceFrame01
    db $08

; C
Credits_NextDancingFrame::
    ld a, [wCredSpritePhase]                      ; $5248
    inc a                                         ; $524B
    cp $05                                        ; $524C
    jr c, jr_009_5251                             ; $524E

    xor a                                         ; $5250

jr_009_5251:
    ld [wCredSpritePhase], a                      ; $5251
    ld c, a                                       ; $5254
    sla a                                         ; $5255
    add c                                         ; $5257
    ld c, a                                       ; $5258
    ld b, $00                                     ; $5259
    ld hl, Credits_NishimuraDanceMapTbl           ; $525B
    add hl, bc                                    ; $525E
    ld c, [hl]                                    ; $525F
    inc hl                                        ; $5260
    ld b, [hl]                                    ; $5261
    inc hl                                        ; $5262
    ld a, [hl]                                    ; $5263
    ld h, b                                       ; $5264
    ld l, c                                       ; $5265
    ld de, $9800                                  ; $5266
    ld bc, $0240                                  ; $5269
    call Vram_CopyFromBank                        ; $526C
    ret                                           ; $526F


; I: 5 records {lo,hi,bank}: BG maps of the Nishimura dance screen (26:5E80, 25:6860, 26:7500, 26:7740, 26:7980; 0x240
; bytes each) cycled by Credits_NextDancingFrame
Credits_NishimuraDanceMapTbl::
    dwb Map_26_5C40_CreditsNishimuraDanceMap0
    dwb Map_25_6620_CreditsNishimuraDanceMap1
    dwb Map_26_7080_CreditsNishimuraDanceMap2
    dwb Map_26_72C0_CreditsNishimuraDanceMap3
    dwb Map_26_7500_CreditsNishimuraDanceMap4

; C: credits state $19 (Japanese $18), same code
Mode08_State19_Leave::
    screen_off                                    ; $527F
    set_state STATE_08_INIT                       ; $5285
    ret                                           ; $528A


; C: Left/Right moves choice4_cursor
UserMap_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $528B
    ld b, a                                       ; $528D
    ld a, [wChoice4Cursor]                        ; $528E
    bit 5, b                                      ; $5291
    jr z, jr_009_529a                             ; $5293

    and a                                         ; $5295
    ret z                                         ; $5296

    dec a                                         ; $5297
    jr jr_009_52a1                                ; $5298

jr_009_529a:
    bit 4, b                                      ; $529A
    ret z                                         ; $529C

    cp $03                                        ; $529D
    ret z                                         ; $529F

    inc a                                         ; $52A0

jr_009_52a1:
    ld hl, wChoice4Cursor                         ; $52A1
    cp [hl]                                       ; $52A4
    ret z                                         ; $52A5

    ld [hl], a                                    ; $52A6
    play_sfx1 SFX1_CURSOR_MOVE                    ; $52A7

; C
UserMap_LoadPlanetTiles::
    and a                                         ; $52AE
    jr nz, jr_009_52c0                            ; $52AF

    farcopy Vram_CopyFromBank, Gfx_0F_5500_UserMap_LoadPlanetTiles, $8500, $0280 ; $52B1
    ret                                           ; $52BF


jr_009_52c0:
    cp $01                                        ; $52C0
    jr nz, jr_009_52d3                            ; $52C2

    farcopy Vram_CopyFromBank, Gfx_0F_5780_UserMap_LoadPlanetTiles, $8500, $0280 ; $52C4
    ret                                           ; $52D2


jr_009_52d3:
    cp $02                                        ; $52D3
    jr nz, jr_009_52e6                            ; $52D5

    farcopy Vram_CopyFromBank, Gfx_0F_5A00_UserMap_LoadPlanetTiles, $8500, $0280 ; $52D7
    ret                                           ; $52E5


jr_009_52e6:
    farcopy Vram_CopyFromBank, Gfx_0F_5C80_UserMap_LoadPlanetTiles, $8500, $0280 ; $52E6
    ret                                           ; $52F4


; C
UserMap_DrawSprites::
    call UserMap_AnimateDecoSprites               ; $52F5
    call UserMap_DrawCursor                       ; $52F8
    ld bc, $4c24                                  ; $52FB
    ld a, $73                                     ; $52FE
    call Oam_AddMeta_B02_52BD                     ; $5300
    ld bc, $4c9c                                  ; $5303
    ld a, $74                                     ; $5306
    call Oam_AddMeta_B02_52BD                     ; $5308
    ret                                           ; $530B


; C: four decorative sprites: tick; limit; phase
UserMap_AnimateDecoSprites::
    ld bc, wDecoTick                              ; $530C
    ld de, wDecoPhase                             ; $530F
    ld hl, UserMap_DecoLimitTbl                   ; $5312
    ld a, $04                                     ; $5315

jr_009_5317:
    ldh [hScratchA], a                            ; $5317
    ld a, [bc]                                    ; $5319
    inc a                                         ; $531A
    cp [hl]                                       ; $531B
    jr c, jr_009_5324                             ; $531C

    ld a, [de]                                    ; $531E
    inc a                                         ; $531F
    and $03                                       ; $5320
    ld [de], a                                    ; $5322
    xor a                                         ; $5323

jr_009_5324:
    ld [bc], a                                    ; $5324
    inc bc                                        ; $5325
    inc de                                        ; $5326
    inc hl                                        ; $5327
    ldh a, [hScratchA]                            ; $5328
    dec a                                         ; $532A
    jr nz, jr_009_5317                            ; $532B

    ld bc, $4550                                  ; $532D
    ld a, [wDecoPhase]                            ; $5330
    add $61                                       ; $5333
    call Oam_AddMeta_B02_52BD                     ; $5335
    ld bc, $7049                                  ; $5338
    ld a, [wDecoPhase + $1]                       ; $533B
    and $01                                       ; $533E
    add $65                                       ; $5340
    call Oam_AddMeta_B02_52BD                     ; $5342
    ld bc, $6d6c                                  ; $5345
    ld a, [wDecoPhase + $2]                       ; $5348
    add $6b                                       ; $534B
    call Oam_AddMeta_B02_52BD                     ; $534D
    ld bc, $9177                                  ; $5350
    ld a, [wDecoPhase + $3]                       ; $5353
    add $67                                       ; $5356
    call Oam_AddMeta_B02_52BD                     ; $5358
    ret                                           ; $535B


; C: L3 pass 2026-10-26: read in BGB in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
UserMap_DecoLimitTbl::
    db $0d, $10, $07, $17

; C: sprite $6F/$71 at table 09:5293
UserMap_DrawCursor::
    ld a, [wChoice4Cursor]                        ; $5360
    sla a                                         ; $5363
    ld c, a                                       ; $5365
    ld b, $00                                     ; $5366
    ld hl, UserMap_CursorPosTbl                   ; $5368
    add hl, bc                                    ; $536B
    ld c, [hl]                                    ; $536C
    inc hl                                        ; $536D
    ld b, [hl]                                    ; $536E
    ld a, [wChoice4Cursor]                        ; $536F
    ld e, a                                       ; $5372
    ld d, $00                                     ; $5373
    ld hl, UserMap_DrawCursor_PtrTbl538E          ; $5375
    add hl, de                                    ; $5378
    ldh a, [hFrameCounter]                        ; $5379
    srl a                                         ; $537B
    srl a                                         ; $537D
    and $01                                       ; $537F
    add [hl]                                      ; $5381
    call Oam_AddMeta_B02_52BD                     ; $5382
    ret                                           ; $5385


; C
UserMap_CursorPosTbl::
    db $50, $45, $49, $70, $6c, $6d, $77, $91

; C: auto: 4 bytes, word table; referenced by UserMap_DrawCursor. L3 pass 2026-10-26: read in BGB in 15 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
UserMap_DrawCursor_PtrTbl538E::
    dw $6f6f
    dw $716f

; C: music $46; SCY ramp
UserMap_ScrollOut::
    play_music MUSIC_USER_MAP_SCROLL_OUT          ; $5392
    call Oam_ClearShadow                          ; $5399
    rst Rst08_WaitVBlank                          ; $539C
    ld bc, $01c0                                  ; $539D

jr_009_53a0:
    push bc                                       ; $53A0
    sla c                                         ; $53A1
    rl b                                          ; $53A3
    sla c                                         ; $53A5
    rl b                                          ; $53A7
    call Rng_Next                                 ; $53A9
    ld c, a                                       ; $53AC
    call UserMap_ScrollStep                       ; $53AD
    pop bc                                        ; $53B0
    ldh a, [hKeysNew]                             ; $53B1
    and PADF_A | PADF_B                           ; $53B3
    ld [wAbResult], a                             ; $53B5
    jr nz, jr_009_53bf                            ; $53B8

    dec bc                                        ; $53BA
    ld a, c                                       ; $53BB
    or b                                          ; $53BC
    jr nz, jr_009_53a0                            ; $53BD

jr_009_53bf:
    xor a                                         ; $53BF
    ldh [hScyShadow], a                           ; $53C0
    ldh [hBgpShadow], a                           ; $53C2
    ld hl, $ff42                                  ; $53C4

jr_009_53c7:
    ldh a, [rSTAT]                                ; $53C7
    and $03                                       ; $53C9
    jr nz, jr_009_53c7                            ; $53CB

    xor a                                         ; $53CD
    ldh [rSCY], a                                 ; $53CE
    ldh [rBGP], a                                 ; $53D0
    ld bc, $0002                                  ; $53D2
    call Wait_Frames                              ; $53D5
    call Lcd_Off                                  ; $53D8
    ret                                           ; $53DB


; C
UserMap_ScrollStep::
    inc b                                         ; $53DC
    sla b                                         ; $53DD
    sla b                                         ; $53DF

jr_009_53e1:
    ld a, c                                       ; $53E1
    ldh [hScyShadow], a                           ; $53E2

jr_009_53e4:
    ldh a, [rLY]                                  ; $53E4
    cp $90                                        ; $53E6
    jr nc, jr_009_53e4                            ; $53E8

    ldh a, [rSTAT]                                ; $53EA
    and $03                                       ; $53EC
    jr nz, jr_009_53e4                            ; $53EE

    ld a, c                                       ; $53F0
    ldh [rSCY], a                                 ; $53F1
    inc c                                         ; $53F3
    call Record_Delay8                            ; $53F4
    dec b                                         ; $53F7
    jr nz, jr_009_53e1                            ; $53F8

    ret                                           ; $53FA


; C: busy loop of 8 iterations used by the statistics screen. L3 pass 2026-10-26: executed in BGB in 26 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Record_Delay8::
    ld a, $08                                     ; $53FB

jr_009_53fd:
    dec a                                         ; $53FD
    jr nz, jr_009_53fd                            ; $53FE

    ret                                           ; $5400


; C: taken; erased; sent; received m/f; printed
Record_DrawCounters::
    ld hl, $986f                                  ; $5401
    ld a, [wCntTaken + $1]                        ; $5404
    call Record_DrawBcdByte                       ; $5407
    ld a, [wCntTaken]                             ; $540A
    call Record_DrawBcdByte                       ; $540D
    ld hl, $98cf                                  ; $5410
    ld a, [wCntErased + $1]                       ; $5413
    call Record_DrawBcdByte                       ; $5416
    ld a, [wCntErased]                            ; $5419
    call Record_DrawBcdByte                       ; $541C
    ld hl, $992f                                  ; $541F
    ld a, [wCntSent + $1]                         ; $5422
    call Record_DrawBcdByte                       ; $5425
    ld a, [wCntSent]                              ; $5428
    call Record_DrawBcdByte                       ; $542B
    ld hl, $998e                                  ; $542E
    ld a, [wCntRecvA]                             ; $5431
    call Record_DrawBcdByte                       ; $5434
    inc hl                                        ; $5437
    ld a, [wCntRecvB]                             ; $5438
    call Record_DrawBcdByte                       ; $543B
    ld hl, $99ef                                  ; $543E
    ld a, [wCntPrinted + $1]                      ; $5441
    call Record_DrawBcdByte                       ; $5444
    ld a, [wCntPrinted]                           ; $5447

; C: two tall digits
Record_DrawBcdByte::
    push af                                       ; $544A
    swap a                                        ; $544B
    and $0f                                       ; $544D
    call Record_DrawTallDigit                     ; $544F
    pop af                                        ; $5452
    and $0f                                       ; $5453

; C: tile and tile+$10 one row below
Record_DrawTallDigit::
    push hl                                       ; $5455
    call Vram_WriteByteSafe                       ; $5456
    ld bc, $0020                                  ; $5459
    add hl, bc                                    ; $545C
    add $10                                       ; $545D
    call Vram_WriteByteSafe                       ; $545F
    pop hl                                        ; $5462
    inc hl                                        ; $5463
    ret                                           ; $5464


; C: SPACE FEVER II; BALL; RUN
HiScore_DrawScores::
    ld hl, $986b                                  ; $5465
    ld a, [wBestShooter + $3]                     ; $5468
    call HiScore_DrawBcdByte                      ; $546B
    ld a, [wBestShooter + $2]                     ; $546E
    call HiScore_DrawBcdByte                      ; $5471
    ld a, [wBestShooter + $1]                     ; $5474
    call HiScore_DrawBcdByte                      ; $5477
    ld a, [wBestShooter]                          ; $547A
    call HiScore_DrawBcdByte                      ; $547D
    ld hl, $98cf                                  ; $5480
    ld a, [wBestBall + $1]                        ; $5483
    call HiScore_DrawBcdByte                      ; $5486
    ld a, [wBestBall]                             ; $5489
    call HiScore_DrawBcdByte                      ; $548C
    ld hl, $992e                                  ; $548F
    ld a, [wBestRun + $1]                         ; $5492
    cpl                                           ; $5495
    add $9a                                       ; $5496
    call HiScore_DrawBcdByte                      ; $5498
    inc hl                                        ; $549B
    ld a, [wBestRun]                              ; $549C
    cpl                                           ; $549F
    add $9a                                       ; $54A0

; C
HiScore_DrawBcdByte::
    push af                                       ; $54A2
    swap a                                        ; $54A3
    and $0f                                       ; $54A5
    call HiScore_DrawTallDigit                    ; $54A7
    pop af                                        ; $54AA
    and $0f                                       ; $54AB

; C
HiScore_DrawTallDigit::
    push hl                                       ; $54AD
    call Vram_WriteByteSafe                       ; $54AE
    ld bc, $0020                                  ; $54B1
    add hl, bc                                    ; $54B4
    add $10                                       ; $54B5
    call Vram_WriteByteSafe                       ; $54B7
    pop hl                                        ; $54BA
    inc hl                                        ; $54BB
    ret                                           ; $54BC


; C: loads glyph list A (09:53D3) to $8800 with Kb_LoadGlyphList
Kb_LoadGlyphSetA::
    ld de, $8800                                  ; $54BD
    ld hl, Kb_GlyphListA                          ; $54C0
    jp Kb_LoadGlyphList                           ; $54C3


; I: glyph list read by Kb_LoadGlyphList: pairs (n, slot) = n glyphs from slot, ($80+n, slot) = n copies of slot, 0
; ends; slots index the 32-byte glyphs at 2A:4000 (was Kb_LoadGlyphSetA_Gfx53D3)
Kb_GlyphListA::
    db $1a
    db $55
    db $0f
    db $73
    db $89
    db $ff
    db $04
    db $6f
    db $02
    db $84
    db $05
    db $c3
    db $01
    db $ff
    db $00

; C: loads glyph list B (09:53F5) to $8800 with Kb_LoadGlyphList
Kb_LoadGlyphSetB::
    ld de, $8800                                  ; $54D5
    ld hl, Kb_GlyphListB                          ; $54D8
    jp Kb_LoadGlyphList                           ; $54DB


; I: glyph list read by Kb_LoadGlyphList: pairs (n, slot) = n glyphs from slot, ($80+n, slot) = n copies of slot, 0
; ends; slots index the 32-byte glyphs at 2A:4000 (was Kb_LoadGlyphSetB_Gfx53F5)
Kb_GlyphListB::
    dw $871a
    dw $a511
    dw $ff87
    dw $6f04
    dw $8402
    dw $c305
    dw $ff01
    dw $1100
    dw $8800
    dw $f621
    dw $c354
    dw $5503

; C: glyph list read by Kb_LoadGlyphList: pairs (n, slot) = n glyphs from slot, ($80+n, slot) = n copies of slot, 0
; ends; slots index the 32-byte glyphs at 2A:4000 (was Kb_LoadGlyphSetC_Gfx5417)
Kb_GlyphListC::
    dw $aa1a
    dw $c81a
    dw $c404
    dw $7b02
    dw $3101
    dw $ff83
    db $00

; C: list in HL: entry n,g = n glyphs from slot g; entry $80+n,g = n copies of slot g; 0 ends; each glyph = 32 B from
; 2A:$4000 + 32 x slot copied to DE; lists A / B / C at 09:53D3 / 53F5 / 5417
Kb_LoadGlyphList::
    ld a, [hl+]                                   ; $5503
    and a                                         ; $5504
    ret z                                         ; $5505

    ld c, a                                       ; $5506
    ld b, $01                                     ; $5507
    bit 7, c                                      ; $5509
    jr z, jr_009_5512                             ; $550B

    res 7, c                                      ; $550D
    ld b, c                                       ; $550F
    ld c, $01                                     ; $5510

jr_009_5512:
    push hl                                       ; $5512
    ld a, [hl]                                    ; $5513
    push bc                                       ; $5514
    call Kb_GlyphOffset                           ; $5515
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $5518
    add hl, bc                                    ; $551B
    pop bc                                        ; $551C
    push bc                                       ; $551D
    ld a, c                                       ; $551E
    call Kb_GlyphOffset                           ; $551F
    ld a, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $5522
    call Vram_CopyFromBank                        ; $5524
    pop bc                                        ; $5527
    pop hl                                        ; $5528
    dec b                                         ; $5529
    jr nz, jr_009_5512                            ; $552A

    inc hl                                        ; $552C
    jr Kb_LoadGlyphList                           ; $552D

; C: BC = A x 32 (byte offset of glyph slot A)
Kb_GlyphOffset::
    swap a                                        ; $552F
    push af                                       ; $5531
    and $f0                                       ; $5532
    ld c, a                                       ; $5534
    pop af                                        ; $5535
    and $0f                                       ; $5536
    ld b, a                                       ; $5538
    sla c                                         ; $5539
    rl b                                          ; $553B
    ret                                           ; $553D


; C: A = key index ($DA3C), HL = one of the three glyph lists Kb_GlyphListA/B/C (pairs {n, slot}, $80+n = n copies of
; the slot, 0 ends): returns the character code of the key = slot + 1 (0 for the blank run, slot $FF); the only caller
; is Kb_Page0_Press (09:5BE9), which stores it in the name at $DA4D + ...
Kb_FindCharInList::
    ld b, $00                                     ; $553E
    ld c, a                                       ; $5540
    inc c                                         ; $5541

jr_009_5542:
    ld a, [hl]                                    ; $5542
    and a                                         ; $5543
    ret z                                         ; $5544

    ld a, b                                       ; $5545
    cp c                                          ; $5546
    jr nc, jr_009_555f                            ; $5547

    ld a, [hl]                                    ; $5549
    res 7, a                                      ; $554A
    add b                                         ; $554C
    cp c                                          ; $554D
    jr c, jr_009_555f                             ; $554E

    bit 7, [hl]                                   ; $5550
    jr nz, jr_009_555b                            ; $5552

    inc hl                                        ; $5554
    dec c                                         ; $5555
    ld a, c                                       ; $5556
    sub b                                         ; $5557
    add [hl]                                      ; $5558
    inc a                                         ; $5559
    ret                                           ; $555A


jr_009_555b:
    inc hl                                        ; $555B
    ld a, [hl]                                    ; $555C
    inc a                                         ; $555D
    ret                                           ; $555E


jr_009_555f:
    ld a, [hl]                                    ; $555F
    res 7, a                                      ; $5560
    add b                                         ; $5562
    ld b, a                                       ; $5563
    inc hl                                        ; $5564
    inc hl                                        ; $5565
    jr jr_009_5542                                ; $5566

; C: owner_id at $99CA
OwnerCard_DrawOwnerId::
    ld de, $99ca                                  ; $5568
    ld hl, wOwnerId                               ; $556B
    ld b, $04                                     ; $556E
    call OwnerCard_DrawDigits                     ; $5570
    ret                                           ; $5573


; C
OwnerCard_DrawDigits::
    push bc                                       ; $5574
    push hl                                       ; $5575
    xor a                                         ; $5576

jr_009_5577:
    or [hl]                                       ; $5577
    inc hl                                        ; $5578
    dec b                                         ; $5579
    jr nz, jr_009_5577                            ; $557A

    pop hl                                        ; $557C
    pop bc                                        ; $557D
    and a                                         ; $557E
    jp nz, OwnerCard_DrawNumber_NonZero           ; $557F

    sla b                                         ; $5582

jr_009_5584:
    push bc                                       ; $5584
    ld h, d                                       ; $5585
    ld l, e                                       ; $5586
    ld a, $aa                                     ; $5587
    call Vram_WriteByteSafe                       ; $5589
    ld bc, $0020                                  ; $558C
    add hl, bc                                    ; $558F
    ld a, $ab                                     ; $5590
    call Vram_WriteByteSafe                       ; $5592
    inc de                                        ; $5595
    pop bc                                        ; $5596
    dec b                                         ; $5597
    jr nz, jr_009_5584                            ; $5598

    ret                                           ; $559A


; C: owner_name to tiles at $8800
OwnerCard_LoadNameGlyphs::
    ld hl, wOwnerName                             ; $559B
    ld de, $8800                                  ; $559E
    ld b, $09                                     ; $55A1

jr_009_55a3:
    push bc                                       ; $55A3
    ld a, [hl+]                                   ; $55A4
    push hl                                       ; $55A5
    ld c, BANK(StampCat04_05_SmallKana_Gfx)       ; $55A6
    ld hl, StampCat04_05_SmallKana_Gfx            ; $55A8
    call Glyph_LoadFromCharCode                   ; $55AB
    pop hl                                        ; $55AE
    pop bc                                        ; $55AF
    dec b                                         ; $55B0
    jr nz, jr_009_55a3                            ; $55B1

    ret                                           ; $55B3


; C: tiles at $9580
OwnerCard_LoadNameGlyphsB::
    ld hl, wOwnerName                             ; $55B4
    ld de, $9580                                  ; $55B7
    ld b, $09                                     ; $55BA

jr_009_55bc:
    push bc                                       ; $55BC
    ld a, [hl+]                                   ; $55BD
    push hl                                       ; $55BE
    ld c, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $55BF
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $55C1
    call Glyph_LoadFromCharCode                   ; $55C4
    pop hl                                        ; $55C7
    pop bc                                        ; $55C8
    dec b                                         ; $55C9
    jr nz, jr_009_55bc                            ; $55CA

    ret                                           ; $55CC


; C: table 09:5509
OwnerCard_DrawGender::
    ld a, [wOwnerGenderBlood]                     ; $55CD
    and $03                                       ; $55D0
    ld c, a                                       ; $55D2
    ld b, $00                                     ; $55D3
    ld hl, OwnerCard_DrawGender_Map55E8           ; $55D5
    add hl, bc                                    ; $55D8
    ld a, [hl]                                    ; $55D9
    ld hl, $9911                                  ; $55DA
    call Vram_WriteByteSafe                       ; $55DD
    inc a                                         ; $55E0
    ld hl, $9931                                  ; $55E1
    call Vram_WriteByteSafe                       ; $55E4
    ret                                           ; $55E7


; C: auto: 3 bytes, tile map; referenced by OwnerCard_DrawGender. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawGender_Map55E8::
    db $aa, $a6, $a8

; C
OwnerCard_LoadGenderTiles::
    ld a, [wOwnerGenderBlood]                     ; $55EB
    and $03                                       ; $55EE
    swap a                                        ; $55F0
    ld c, a                                       ; $55F2
    ld b, $00                                     ; $55F3
    sla c                                         ; $55F5
    ld hl, Gfx_20_64C0_OwnerCard_LoadGenderTiles  ; $55F7
    add hl, bc                                    ; $55FA
    ld a, BANK(Gfx_20_64C0_OwnerCard_LoadGenderTiles) ; $55FB
    ld de, $96a0                                  ; $55FD
    ld bc, $0020                                  ; $5600
    call Vram_CopyFromBank                        ; $5603
    ret                                           ; $5606


; C
OwnerCard_DrawBirthDate::
    ld de, $996e                                  ; $5607
    ld hl, wOwnerBirthYear                        ; $560A
    ld b, $02                                     ; $560D
    call OwnerCard_DrawBirthNumber                ; $560F
    ld de, $9968                                  ; $5612
    ld hl, wOwnerBirthMonth                       ; $5615
    ld b, $01                                     ; $5618
    call OwnerCard_DrawBirthNumber                ; $561A
    ld de, $996b                                  ; $561D
    ld hl, wOwnerBirthDay                         ; $5620
    ld b, $01                                     ; $5623
    call OwnerCard_DrawBirthNumber                ; $5625
    ret                                           ; $5628


; C
OwnerCard_DrawBirthNumber::
    push bc                                       ; $5629
    push hl                                       ; $562A
    xor a                                         ; $562B

jr_009_562c:
    or [hl]                                       ; $562C
    inc hl                                        ; $562D
    dec b                                         ; $562E
    jr nz, jr_009_562c                            ; $562F

    pop hl                                        ; $5631
    pop bc                                        ; $5632
    and a                                         ; $5633
    jp nz, OwnerCard_DrawNumber_NonZero           ; $5634

    sla b                                         ; $5637

jr_009_5639:
    push bc                                       ; $5639
    ld h, d                                       ; $563A
    ld l, e                                       ; $563B
    ld a, $aa                                     ; $563C
    call Vram_WriteByteSafe                       ; $563E
    ld bc, $0020                                  ; $5641
    add hl, bc                                    ; $5644
    ld a, $ab                                     ; $5645
    call Vram_WriteByteSafe                       ; $5647
    inc de                                        ; $564A
    pop bc                                        ; $564B
    dec b                                         ; $564C
    jr nz, jr_009_5639                            ; $564D

    ret                                           ; $564F


; C
OwnerCard_LoadBirthTiles::
    ld de, $96c0                                  ; $5650
    ld hl, wOwnerBirthYear                        ; $5653
    ld b, $02                                     ; $5656
    call OwnerCard_LoadBirthNumberTiles           ; $5658
    ld hl, wOwnerBirthMonth                       ; $565B
    ld b, $01                                     ; $565E
    call OwnerCard_LoadBirthNumberTiles           ; $5660
    ld hl, wOwnerBirthDay                         ; $5663
    ld b, $01                                     ; $5666
    call OwnerCard_LoadBirthNumberTiles           ; $5668
    ret                                           ; $566B


; C
OwnerCard_LoadBirthNumberTiles::
    push bc                                       ; $566C
    push hl                                       ; $566D
    xor a                                         ; $566E

jr_009_566f:
    or [hl]                                       ; $566F
    inc hl                                        ; $5670
    dec b                                         ; $5671
    jr nz, jr_009_566f                            ; $5672

    pop hl                                        ; $5674
    pop bc                                        ; $5675
    and a                                         ; $5676
    jp nz, OwnerCard_LoadBirthNumberTiles_NonZero ; $5677

    sla b                                         ; $567A

jr_009_567c:
    push bc                                       ; $567C
    ld hl, Src_20_6660_OwnerCard_LoadBirthNumberTiles ; $567D
    ld a, BANK(Src_20_6660_OwnerCard_LoadBirthNumberTiles) ; $5680
    ld bc, $0020                                  ; $5682
    call Vram_CopyFromBank                        ; $5685
    pop bc                                        ; $5688
    dec b                                         ; $5689
    jr nz, jr_009_567c                            ; $568A

    ret                                           ; $568C


    db $fa, $56, $da, $cb, $3f, $e6, $0e, $4f, $06, $00, $21, $ac, $56, $09, $2a, $e5
    db $21, $72, $99, $cd, $d9, $07, $e1, $7e, $21, $92, $99, $cd, $d9, $07, $c9

; C: auto: 10 bytes, tile map; referenced by OwnerCard_DrawBloodType. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodType_Map56AC::
    db $ff, $af, $ff, $ac, $ff, $ad, $ff, $ae, $ac, $ad

; C
OwnerCard_LoadBloodTiles::
    ld a, [wOwnerGenderBlood]                     ; $56B6
    srl a                                         ; $56B9
    srl a                                         ; $56BB
    and $07                                       ; $56BD
    swap a                                        ; $56BF
    ld c, a                                       ; $56C1
    ld b, $00                                     ; $56C2
    sla c                                         ; $56C4
    rl b                                          ; $56C6
    sla c                                         ; $56C8
    rl b                                          ; $56CA
    ld hl, Gfx_20_6680_OwnerCard_LoadBloodTiles   ; $56CC
    add hl, bc                                    ; $56CF
    ld a, BANK(Gfx_20_6680_OwnerCard_LoadBloodTiles) ; $56D0
    ld de, $97c0                                  ; $56D2
    ld bc, $0040                                  ; $56D5
    call Vram_CopyFromBank                        ; $56D8
    ret                                           ; $56DB


; C: non-zero number: loops B bytes at HL through OwnerCard_DrawBloodHigh (the all-zero case draws the placeholder)
; (branch target; code read 2026-10-19)
OwnerCard_LoadBirthNumberTiles_NonZero::
    ld a, [hl+]                                   ; $56DC
    call OwnerCard_DrawBloodHigh                  ; $56DD
    dec b                                         ; $56E0
    jr nz, OwnerCard_LoadBirthNumberTiles_NonZero ; $56E1

    ret                                           ; $56E3


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodHigh::
    push bc                                       ; $56E4
    push hl                                       ; $56E5
    push af                                       ; $56E6
    swap a                                        ; $56E7
    and $0f                                       ; $56E9
    call OwnerCard_DrawBloodLow                   ; $56EB
    pop af                                        ; $56EE
    and $0f                                       ; $56EF
    call OwnerCard_DrawBloodLow                   ; $56F1
    pop hl                                        ; $56F4
    pop bc                                        ; $56F5
    ret                                           ; $56F6


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLow::
    and a                                         ; $56F7
    jr z, jr_009_56fb                             ; $56F8

    dec a                                         ; $56FA

jr_009_56fb:
    swap a                                        ; $56FB
    ld c, a                                       ; $56FD
    ld b, $00                                     ; $56FE
    sla c                                         ; $5700
    rl b                                          ; $5702
    ld hl, Src_20_6520_OwnerCard_DrawBloodLow     ; $5704
    add hl, bc                                    ; $5707
    ld a, BANK(Src_20_6520_OwnerCard_DrawBloodLow) ; $5708
    ld bc, $0020                                  ; $570A
    call Vram_CopyFromBank                        ; $570D
    ret                                           ; $5710


; C: non-zero number, shared by OwnerCard_DrawDigits (54A0) and OwnerCard_DrawBirthNumber (5555): loops B bytes at HL
; through OwnerCard_DrawBloodHighB (branch target; code read 2026-10-19)
OwnerCard_DrawNumber_NonZero::
    ld a, [hl+]                                   ; $5711
    call OwnerCard_DrawBloodHighB                 ; $5712
    dec b                                         ; $5715
    jr nz, OwnerCard_DrawNumber_NonZero           ; $5716

    ret                                           ; $5718


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodHighB::
    push bc                                       ; $5719
    push hl                                       ; $571A
    push af                                       ; $571B
    swap a                                        ; $571C
    and $0f                                       ; $571E
    call OwnerCard_DrawBloodLowB                  ; $5720
    pop af                                        ; $5723
    and $0f                                       ; $5724
    call OwnerCard_DrawBloodLowB                  ; $5726
    pop hl                                        ; $5729
    pop bc                                        ; $572A
    ret                                           ; $572B


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLowB::
    ld h, d                                       ; $572C
    ld l, e                                       ; $572D
    and a                                         ; $572E
    jr z, jr_009_5732                             ; $572F

    dec a                                         ; $5731

jr_009_5732:
    push hl                                       ; $5732
    ld c, a                                       ; $5733
    ld b, $00                                     ; $5734
    ld hl, OwnerCard_DrawBloodLowB_Tbl5749        ; $5736
    add hl, bc                                    ; $5739
    ld a, [hl]                                    ; $573A
    pop hl                                        ; $573B
    call Vram_WriteByteSafe                       ; $573C
    ld bc, $0020                                  ; $573F
    add hl, bc                                    ; $5742
    inc a                                         ; $5743
    call Vram_WriteByteSafe                       ; $5744
    inc de                                        ; $5747
    ret                                           ; $5748


; C: auto: 11 bytes, bytes; referenced by OwnerCard_DrawBloodLowB. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLowB_Tbl5749::
    db $92, $94, $96, $98, $9a, $9c, $9e, $a0, $a2, $a4, $aa

; C: name keyboard; tab page 0
Kb_Page0_Draw::
    call Call_009_5922                            ; $5754
    call Kb_DrawTabs                              ; $5757
    call Kb_DrawCursor                            ; $575A
    ld hl, Kb_Page0_Draw_Tbl5764                  ; $575D
    call Kb_DrawKeyHighlight                      ; $5760
    ret                                           ; $5763


; I: 80 key highlight positions {y, x} (y = 3C, 4C, 5C, 6C, 7C; x from 08 to 90, then 70 / 88 repeated for the wide
; keys), entry n for the key index $DA3C = n; Kb_DrawKeyHighlight (09:58C2) loads C = y, B = x and draws the blinking
; marker $A3 with Oam_AddMeta_B02_5272 when $FFC8 & $0F >= 4 (C). ...
Kb_Page0_Draw_Tbl5764::
    db $3c, $08, $3c, $10, $3c, $18, $3c, $20, $3c, $28, $4c, $08, $4c, $10, $4c, $18
    db $4c, $20, $4c, $28, $5c, $08, $5c, $10, $5c, $18, $5c, $20, $5c, $28, $6c, $08
    db $6c, $10, $6c, $18, $6c, $20, $6c, $28, $7c, $08, $7c, $10, $7c, $18, $7c, $20
    db $7c, $28, $3c, $38, $3c, $40, $3c, $48, $3c, $50, $3c, $58, $4c, $38, $4c, $40
    db $4c, $48, $4c, $50, $4c, $58, $5c, $38, $5c, $40, $5c, $48, $5c, $50, $5c, $58
    db $6c, $38, $6c, $40, $6c, $48, $6c, $50, $6c, $58, $7c, $38, $7c, $40, $7c, $48
    db $7c, $50, $7c, $58, $3c, $68, $3c, $70, $3c, $78, $3c, $80, $3c, $88, $3c, $90
    db $4c, $68, $4c, $70, $4c, $78, $4c, $80, $4c, $88, $4c, $90, $6c, $70, $6c, $70
    db $6c, $70, $6c, $88, $6c, $88, $6c, $88, $6c, $70, $6c, $70, $6c, $70, $6c, $88
    db $6c, $88, $6c, $88, $7c, $70, $7c, $70, $7c, $70, $7c, $88, $7c, $88, $7c, $88

; C
Kb_Page1_Draw::
    call Kb_DrawTabs                              ; $5804
    call Kb_DrawCursor                            ; $5807
    ld hl, Kb_Page1_Draw_Tbl5811                  ; $580A
    call Kb_DrawKeyHighlight                      ; $580D
    ret                                           ; $5810


; C: 10 key highlight positions {y, x} of page 1 of the keyboard, entry n for the key index $DA3C = n (Kb_Page1_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page1_Draw_Tbl5811::
    db $3c, $18, $3c, $30, $3c, $48, $3c, $70, $3c, $88, $7c, $88, $7c, $88, $7c, $88
    db $7c, $88, $7c, $88

; C
Kb_Page2_Draw::
    call Kb_DrawTabs                              ; $5825
    call Kb_DrawCursor                            ; $5828
    ld hl, Kb_Page2_Draw_Tbl5832                  ; $582B
    call Kb_DrawKeyHighlight                      ; $582E
    ret                                           ; $5831


; C: 24 key highlight positions {y, x} of page 2 of the keyboard, entry n for the key index $DA3C = n (Kb_Page2_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page2_Draw_Tbl5832::
    db $3c, $10, $3c, $20, $3c, $30, $3c, $40, $3c, $50, $3c, $60, $3c, $70, $3c, $80
    db $54, $10, $54, $20, $54, $30, $54, $30, $54, $70, $54, $70, $54, $70, $54, $88
    db $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88

; C
Kb_Page3_Draw::
    call Kb_DrawTabs                              ; $5862
    call Kb_DrawCursor                            ; $5865
    ld hl, Kb_Page3_Draw_Tbl586F                  ; $5868
    call Kb_DrawKeyHighlight                      ; $586B
    ret                                           ; $586E


; C: 18 key highlight positions {y, x} of page 3 of the keyboard, entry n for the key index $DA3C = n (Kb_Page3_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page3_Draw_Tbl586F::
    db $3c, $14, $3c, $2c, $3c, $44, $3c, $5c, $3c, $74, $3c, $74, $54, $70, $54, $70
    db $54, $70, $54, $70, $54, $70, $54, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88
    db $7c, $88, $7c, $88

; C
Kb_DrawTabs::
    ld a, [wKbPage]                               ; $5893
    ld c, a                                       ; $5896
    ld b, $00                                     ; $5897
    ld hl, Kb_DrawTabs_Tbl58B6                    ; $5899
    add hl, bc                                    ; $589C
    ld e, [hl]                                    ; $589D
    ldh a, [hFrameCounter]                        ; $589E
    srl a                                         ; $58A0
    srl a                                         ; $58A2
    srl a                                         ; $58A4
    and $03                                       ; $58A6
    ld c, a                                       ; $58A8
    ld hl, Kb_DrawTabs_Tbl58BC                    ; $58A9
    add hl, bc                                    ; $58AC
    ld a, [hl]                                    ; $58AD
    add e                                         ; $58AE
    ld bc, $1d1b                                  ; $58AF
    call Oam_AddMeta_B02_52BD                     ; $58B2
    ret                                           ; $58B5


; C: base meta-sprite id of the page marker, indexed by the page $DA3D (0-5): 97 97 97 9A 9D A0; Kb_DrawTabs adds
; Tbl57DD[($FFC8 >> 3) & 3] and draws it at x = $1D, y = $1B (Oam_AddMeta_B02_5272) (C)
Kb_DrawTabs_Tbl58B6::
    db $97, $97, $97, $9a, $9d, $a0

; C: 4 frame offsets 0, 1, 0, 2 of the page marker, selected by ($FFC8 >> 3) & 3 (Kb_DrawTabs) (C)
Kb_DrawTabs_Tbl58BC::
    db $00, $01, $00, $02

; C
Kb_DrawCursor::
    ld a, [wKbPage]                               ; $58C0
    cp $04                                        ; $58C3
    jr z, jr_009_58ea                             ; $58C5

    sla a                                         ; $58C7
    ld c, a                                       ; $58C9
    ld b, $00                                     ; $58CA
    ld hl, Kb_DrawCursor_Tbl5906                  ; $58CC
    add hl, bc                                    ; $58CF
    ld c, [hl]                                    ; $58D0
    inc hl                                        ; $58D1
    ld a, [wKbCursor]                             ; $58D2
    sla a                                         ; $58D5
    sla a                                         ; $58D7
    sla a                                         ; $58D9
    add [hl]                                      ; $58DB
    ld b, a                                       ; $58DC
    ldh a, [hFrameCounter]                        ; $58DD
    and $0f                                       ; $58DF
    cp $04                                        ; $58E1
    ret c                                         ; $58E3

    ld a, $a4                                     ; $58E4
    call Oam_AddMeta_B02_52BD                     ; $58E6
    ret                                           ; $58E9


jr_009_58ea:
    ld a, [wKbCursor]                             ; $58EA
    sla a                                         ; $58ED
    ld c, a                                       ; $58EF
    ld b, $00                                     ; $58F0
    ld hl, Kb_DrawCursor_Tbl5912                  ; $58F2
    add hl, bc                                    ; $58F5
    ld c, [hl]                                    ; $58F6
    inc hl                                        ; $58F7
    ld b, [hl]                                    ; $58F8
    ldh a, [hFrameCounter]                        ; $58F9
    and $0f                                       ; $58FB
    cp $04                                        ; $58FD
    ret c                                         ; $58FF

    ld a, $a4                                     ; $5900
    call Oam_AddMeta_B02_52BD                     ; $5902
    ret                                           ; $5905


; I: 6 x {y, x of the first character} of the blinking cursor, indexed by the page $DA3D (pages 0-3: 19/28, 19/28,
; 19/28, 19/80; entry 4 = 29/28 is never used because page 4 branches to Kb_DrawCursor_Tbl5833; entry 5 = 29/84); the
; cursor sprite $A4 is drawn at x + 8 x $DA3B (name position) when $FFC8 & ...
Kb_DrawCursor_Tbl5906::
    db $19, $30, $19, $30, $19, $30, $19, $88, $29, $38, $29, $94

; I: 8 x {y, x} cursor positions of page 4 (y = 29; x = 28, 30, 38, 40, 50, 58, 68, 70), indexed by $DA3B:
; Kb_DrawCursor (09:57E1) uses it instead of Kb_DrawCursor_Tbl5827 when $DA3D = 4 (C)
Kb_DrawCursor_Tbl5912::
    db $29, $38, $29, $40, $29, $50, $29, $58, $29, $68, $29, $70, $29, $78, $29, $80

Call_009_5922:
    ld a, [wKbPage]                               ; $5922
    and a                                         ; $5925
    jr nz, jr_009_5936                            ; $5926

    ld c, $02                                     ; $5928
    call Kb_TabAnimFrame                          ; $592A
    add $93                                       ; $592D
    ld bc, $6884                                  ; $592F
    call Oam_AddMeta_B02_52BD                     ; $5932
    ret                                           ; $5935


jr_009_5936:
    ld c, $02                                     ; $5936
    call Kb_TabAnimFrame                          ; $5938
    add $91                                       ; $593B
    ld bc, $6884                                  ; $593D
    call Oam_AddMeta_B02_52BD                     ; $5940
    ret                                           ; $5943


; C
Kb_TabAnimFrame::
    ld b, $00                                     ; $5944
    ld hl, wKbTabFrame                            ; $5946
    add hl, bc                                    ; $5949
    ld e, [hl]                                    ; $594A
    sla e                                         ; $594B
    ld d, $00                                     ; $594D
    ld hl, Kb_TabAnimFrame_Tbl5977                ; $594F
    add hl, de                                    ; $5952
    ld a, [hl+]                                   ; $5953
    push af                                       ; $5954
    push hl                                       ; $5955
    ld hl, wKbTabTick                             ; $5956
    add hl, bc                                    ; $5959
    ld a, [hl]                                    ; $595A
    pop hl                                        ; $595B
    cp [hl]                                       ; $595C
    jr c, jr_009_596f                             ; $595D

    ld hl, wKbTabFrame                            ; $595F
    add hl, bc                                    ; $5962
    ld a, [hl]                                    ; $5963
    and a                                         ; $5964
    jr z, jr_009_596d                             ; $5965

    inc a                                         ; $5967
    cp $07                                        ; $5968
    jr c, jr_009_596d                             ; $596A

    xor a                                         ; $596C

jr_009_596d:
    ld [hl], a                                    ; $596D
    xor a                                         ; $596E

jr_009_596f:
    inc a                                         ; $596F
    ld hl, wKbTabTick                             ; $5970
    add hl, bc                                    ; $5973
    ld [hl], a                                    ; $5974
    pop af                                        ; $5975
    ret                                           ; $5976


; C: 7 phases {frame 0/1, duration in frames}: 00/4, 00/4, 01/4, 00/3, 01/3, 00/2, 01/2 (accelerating blink);
; Kb_TabAnimFrame (09:5881) advances the phase $DA41 + tab when its counter $DA3E + tab reaches the duration, 0 =
; idle, wraps 7 -> 0, and returns the frame added to the tab meta id (C)
Kb_TabAnimFrame_Tbl5977::
    db $00, $04, $00, $04, $01, $04, $00, $03, $01, $03, $00, $02, $01, $02

; C
Kb_DrawKeyHighlight::
    ld a, [wKbKey]                                ; $5985
    ld c, a                                       ; $5988
    ld b, $00                                     ; $5989
    sla c                                         ; $598B
    rl b                                          ; $598D
    add hl, bc                                    ; $598F
    ld c, [hl]                                    ; $5990
    inc hl                                        ; $5991
    ld b, [hl]                                    ; $5992
    ldh a, [hFrameCounter]                        ; $5993
    and $0f                                       ; $5995
    cp $04                                        ; $5997
    ret c                                         ; $5999

    ld a, $a3                                     ; $599A
    call Oam_AddMeta_B02_52BD                     ; $599C
    ret                                           ; $599F


; C: key map tables 09:58EA / 593B / 598B
Kb_Page0_Navigate::
    ld bc, Kb_Page0_NavPosToIndexTbl              ; $59A0
    ld de, Kb_Page0_NavLimitsTbl                  ; $59A3
    ld hl, Kb_Page0_NavIndexToPosTbl              ; $59A6
    call Kb_NavigateGeneric                       ; $59A9
    ret                                           ; $59AC


; I: byte 0 = last row; then one byte per grid position (row<<4|col): steps allowed to the left << 4 | steps allowed
; to the right; read by Kb_NavigateGeneric (DE) from Kb_Page0_Navigate
Kb_Page0_NavLimitsTbl::
    db $04, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
    db $10, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
    db $10, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $1c, $2b, $3a, $28, $38
    db $48, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $94, $a3, $b2, $a0, $b0
    db $c0, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $14, $23, $32, $20, $30
    db $40

; C: cursor index ($DA3C) -> grid position (row<<4|col), 5 rows of 10; read by Kb_NavigateGeneric (HL)
Kb_Page0_NavIndexToPosTbl::
    db $00, $01, $02, $03, $04, $10, $11, $12, $13, $14, $20, $21, $22, $23, $24, $30
    db $31, $32, $33, $34, $40, $41, $42, $43, $44, $05, $06, $07, $08, $09, $15, $16
    db $17, $18, $19, $25, $26, $27, $28, $29, $35, $36, $37, $38, $39, $45, $46, $47
    db $48, $49, $0a, $0b, $0c, $0d, $0e, $0f, $1a, $1b, $1c, $1d, $1e, $1f, $2a, $2b
    db $2c, $2d, $2e, $2f, $3a, $3b, $3c, $3d, $3e, $3f, $4a, $4b, $4c, $4d, $4e, $4f

; C: grid position (row<<4|col) -> cursor index; row stride $10; read by Kb_NavigateGeneric (BC)
Kb_Page0_NavPosToIndexTbl::
    db $00, $01, $02, $03, $04, $19, $1a, $1b, $1c, $1d, $32, $33, $34, $35, $36, $37
    db $05, $06, $07, $08, $09, $1e, $1f, $20, $21, $22, $38, $39, $3a, $3b, $3c, $3d
    db $0a, $0b, $0c, $0d, $0e, $23, $24, $25, $26, $27, $3e, $3f, $40, $41, $42, $43
    db $0f, $10, $11, $12, $13, $28, $29, $2a, $2b, $2c, $44, $45, $46, $47, $48, $49
    db $14, $15, $16, $17, $18, $2d, $2e, $2f, $30, $31, $4a, $4b, $4c, $4d, $4e, $4f

; C
Kb_Page1_Navigate::
    ld bc, Kb_Page1_NavPosToIndexTbl              ; $5A9E
    ld de, Kb_Page1_NavLimitsTbl                  ; $5AA1
    ld hl, Kb_Page1_NavIndexToPosTbl              ; $5AA4
    call Kb_NavigateGeneric                       ; $5AA7
    ret                                           ; $5AAA


; C: byte 0 = last row; then one byte per grid position (row<<4|col): steps allowed to the left << 4 | steps allowed
; to the right; read by Kb_NavigateGeneric (DE); 2 rows
Kb_Page1_NavLimitsTbl::
    db $01, $01, $11, $11, $11, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00

; C: cursor index ($DA3C) -> grid position (row<<4|col); 10 cursor indexes (2 rows of 5); read by Kb_NavigateGeneric
; (HL)
Kb_Page1_NavIndexToPosTbl::
    db $00, $01, $02, $03, $04
    db $10, $11, $12, $13, $14

; C: grid position (row<<4|col) -> cursor index; row stride $10; read by Kb_NavigateGeneric (BC), the result is stored
; in $DA3C
Kb_Page1_NavPosToIndexTbl::
    db $00, $01, $02, $03, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $05, $06, $07, $08, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C
Kb_Page2_Navigate::
    ld bc, Kb_Page2_NavPosToIndexTbl              ; $5AF6
    ld de, Kb_Page2_NavLimitsTbl                  ; $5AF9
    ld hl, Kb_Page2_NavIndexToPosTbl              ; $5AFC
    call Kb_NavigateGeneric                       ; $5AFF
    ret                                           ; $5B02


; C: byte 0 = last row; then one byte per grid position (row<<4|col): steps allowed to the left << 4 | steps allowed
; to the right; read by Kb_NavigateGeneric (DE); 3 rows
Kb_Page2_NavLimitsTbl::
    db $02, $01, $11, $11, $11, $11, $11, $11, $10, $00, $00, $00, $00, $00, $00, $00
    db $00, $01, $11, $13, $22, $23, $32, $41, $10, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00

; C: cursor index ($DA3C) -> grid position (row<<4|col); 24 cursor indexes (3 rows of 8); read by Kb_NavigateGeneric
; (HL)
Kb_Page2_NavIndexToPosTbl::
    db $00, $01, $02, $03, $04, $05, $06, $07
    db $10, $11, $12, $13, $14, $15, $16, $17
    db $20, $21, $22, $23, $24, $25, $26, $27

; C: grid position (row<<4|col) -> cursor index; row stride $10; read by Kb_NavigateGeneric (BC), the result is stored
; in $DA3C
Kb_Page2_NavPosToIndexTbl::
    db $00, $01, $02, $03, $04, $05, $06, $07, $00, $00, $00, $00, $00, $00, $00, $00
    db $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $11, $12, $13, $14, $15, $16, $17, $00, $00, $00, $00, $00, $00, $00, $00

; C
Kb_Page3_Navigate::
    ld bc, Kb_Page3_NavPosToIndexTbl              ; $5B7C
    ld de, Kb_Page3_NavLimitsTbl                  ; $5B7F
    ld hl, Kb_Page3_NavIndexToPosTbl              ; $5B82
    call Kb_NavigateGeneric                       ; $5B85
    ret                                           ; $5B88


; C: byte 0 = last row; then one byte per grid position (row<<4|col): steps allowed to the left << 4 | steps allowed
; to the right; read by Kb_NavigateGeneric (DE); 3 rows
Kb_Page3_NavLimitsTbl::
    db $02, $01, $11, $11, $11, $10, $20, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $05, $04, $03, $02, $01, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00

; C: cursor index ($DA3C) -> grid position (row<<4|col); 18 cursor indexes (3 rows of 6); read by Kb_NavigateGeneric
; (HL)
Kb_Page3_NavIndexToPosTbl::
    db $00, $01, $02, $03, $04, $05
    db $10, $11, $12, $13, $14, $15
    db $20, $21, $22, $23, $24, $25

; C: grid position (row<<4|col) -> cursor index; row stride $10; read by Kb_NavigateGeneric (BC), the result is stored
; in $DA3C
Kb_Page3_NavPosToIndexTbl::
    db $00, $01, $02, $03, $04, $05, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $06, $07, $08, $09, $0a, $0b, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $0d, $0e, $0f, $10, $11, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; C
Kb_NavigateGeneric::
    push bc                                       ; $5BFC
    push de                                       ; $5BFD
    ld a, [wKbKey]                                ; $5BFE
    ld c, a                                       ; $5C01
    ld b, $00                                     ; $5C02
    add hl, bc                                    ; $5C04
    ld a, [hl]                                    ; $5C05
    ld c, a                                       ; $5C06
    ld b, $00                                     ; $5C07
    pop hl                                        ; $5C09
    ld e, [hl]                                    ; $5C0A
    inc hl                                        ; $5C0B
    add hl, bc                                    ; $5C0C
    ld d, [hl]                                    ; $5C0D
    push af                                       ; $5C0E
    and $0f                                       ; $5C0F
    call Kb_NavigateHorizontal                    ; $5C11
    ld c, a                                       ; $5C14
    pop af                                        ; $5C15
    swap a                                        ; $5C16
    and $0f                                       ; $5C18
    call Kb_NavigateVertical                      ; $5C1A
    swap a                                        ; $5C1D
    or c                                          ; $5C1F
    ld c, a                                       ; $5C20
    pop hl                                        ; $5C21
    add hl, bc                                    ; $5C22
    ld a, [hl]                                    ; $5C23
    ld hl, wKbKey                                 ; $5C24
    cp [hl]                                       ; $5C27
    ret z                                         ; $5C28

    ld [hl], a                                    ; $5C29
    play_sfx1 SFX1_STEP_FAST                      ; $5C2A
    ret                                           ; $5C31


; I: grid step up / down: A = row, E = last row; $FFA3 bit 6 (Up newly pressed) decrements unless the row is 0, bit 7
; (Down) increments unless the row is E; returns the new row in A (C)
Kb_NavigateVertical::
    ld hl, hKeysNewRepeat                         ; $5C32
    bit 6, [hl]                                   ; $5C35
    jr z, jr_009_5c41                             ; $5C37

    and a                                         ; $5C39
    ret z                                         ; $5C3A

    dec a                                         ; $5C3B
    bit 7, d                                      ; $5C3C
    ret z                                         ; $5C3E

    dec a                                         ; $5C3F
    ret                                           ; $5C40


jr_009_5c41:
    bit 7, [hl]                                   ; $5C41
    ret z                                         ; $5C43

    cp e                                          ; $5C44
    ret z                                         ; $5C45

    inc a                                         ; $5C46
    bit 3, d                                      ; $5C47
    ret z                                         ; $5C49

    inc a                                         ; $5C4A
    ret                                           ; $5C4B


; I: grid step left / right: A = column, D = step limits of the row (high nibble = left step, low nibble = right
; step); $FFA3 bit 5 (Left) subtracts the high nibble, bit 4 (Right) adds the low nibble; returns A (C)
Kb_NavigateHorizontal::
    ld hl, hKeysNewRepeat                         ; $5C4C
    bit 5, [hl]                                   ; $5C4F
    jr z, jr_009_5c5d                             ; $5C51

    push af                                       ; $5C53
    ld a, d                                       ; $5C54
    swap a                                        ; $5C55
    and $07                                       ; $5C57
    ld d, a                                       ; $5C59
    pop af                                        ; $5C5A
    sub d                                         ; $5C5B
    ret                                           ; $5C5C


jr_009_5c5d:
    bit 4, [hl]                                   ; $5C5D
    ret z                                         ; $5C5F

    push af                                       ; $5C60
    ld a, d                                       ; $5C61
    and $07                                       ; $5C62
    ld d, a                                       ; $5C64
    pop af                                        ; $5C65
    add d                                         ; $5C66
    ret                                           ; $5C67


; I: A on a key; handlers via table 09:5C0E
Kb_Page0_Press::
    ldh a, [hKeysNew]                             ; $5C68
    bit PADB_A, a                                 ; $5C6A
    ret z                                         ; $5C6C

    ld a, [wKbKey]                                ; $5C6D
    cp $4d                                        ; $5C70
    jp nc, Kb_Page0_Press_ToPage1                 ; $5C72

    cp $4a                                        ; $5C75
    jp nc, Jump_009_5d19                          ; $5C77

    cp $47                                        ; $5C7A
    jp nc, Kb_Page0_Press_CursorLeft              ; $5C7C

    cp $44                                        ; $5C7F
    jp nc, Kb_Page0_Press_CursorRight             ; $5C81

    cp $41                                        ; $5C84
    jp nc, Kb_Page0_Press_CursorLeft              ; $5C86

    cp $3e                                        ; $5C89
    jp nc, Kb_Page0_Press_CursorRight             ; $5C8B

    ld a, [wKbPage]                               ; $5C8E
    sla a                                         ; $5C91
    ld c, a                                       ; $5C93
    ld b, $00                                     ; $5C94
    ld hl, Kb_Page0_Press_PtrTbl5CC5              ; $5C96
    add hl, bc                                    ; $5C99
    ld a, [hl+]                                   ; $5C9A
    ld h, [hl]                                    ; $5C9B
    ld l, a                                       ; $5C9C
    ld a, [wKbKey]                                ; $5C9D
    call Kb_FindCharInList                        ; $5CA0
    push af                                       ; $5CA3
    ld a, [wKbCursor]                             ; $5CA4
    ld c, a                                       ; $5CA7
    ld b, $00                                     ; $5CA8
    ld hl, wOwnerName                             ; $5CAA
    add hl, bc                                    ; $5CAD
    pop af                                        ; $5CAE
    ld [hl], a                                    ; $5CAF
    call Kb_WriteNameChar                         ; $5CB0
    play_sfx1 SFX1_KEY_A                          ; $5CB3
    ld a, [wKbCursor]                             ; $5CBA
    cp $08                                        ; $5CBD
    ret z                                         ; $5CBF

    inc a                                         ; $5CC0
    ld [wKbCursor], a                             ; $5CC1
    ret                                           ; $5CC4


; I: 3 pointers to Kb_GlyphListA / B / C (09:53D3, 53F5, 5417) indexed by the page $DA3D (0-2); Kb_Page0_Press passes
; the selected list to Kb_FindCharInList (C)
Kb_Page0_Press_PtrTbl5CC5::
    dw Kb_GlyphListA
    dw Kb_GlyphListB
    dw Kb_GlyphListC

; C: keys $3E-$40 of the name page: name cursor $DA3B + 1 (sfx $21); at the ninth place the page changes
; (Kb_Page0_Press_ToPage1) (branch target; code read 2026-10-19)
Kb_Page0_Press_CursorRight::
    ld a, [wKbCursor]                             ; $5CCB
    cp $08                                        ; $5CCE
    jp z, Kb_Page0_Press_ToPage1                  ; $5CD0

    inc a                                         ; $5CD3
    ld [wKbCursor], a                             ; $5CD4
    play_sfx1 SFX1_STEP_VALUE                     ; $5CD7
    ret                                           ; $5CDE


; C: keys $41-$43 of the name page: name cursor $DA3B - 1 (sfx 4), nothing at 0 (branch target; code read 2026-10-19)
Kb_Page0_Press_CursorLeft::
    ld a, [wKbCursor]                             ; $5CDF
    and a                                         ; $5CE2
    ret z                                         ; $5CE3

    dec a                                         ; $5CE4
    ld [wKbCursor], a                             ; $5CE5
    play_sfx1 SFX1_KEY_B                          ; $5CE8
    ret                                           ; $5CEF


; C: keys $44-$46: glyph set A ($DA41 = 1, $DA3D = 0, Kb_LoadGlyphSetA, sfx $38) (branch target; code read 2026-10-19)
Kb_Page0_Press_GlyphSetA::
    ld a, $01                                     ; $5CF0
    ld [wKbTabFrame + $2], a                      ; $5CF2
    xor a                                         ; $5CF5
    ld [wKbPage], a                               ; $5CF6
    call Kb_LoadGlyphSetA                         ; $5CF9
    play_sfx1 SFX1_CURSOR_MOVE                    ; $5CFC
    ret                                           ; $5D03


; C: keys $47-$49: glyph set B ($DA42 = 1, $DA3D = 1, Kb_LoadGlyphSetB, sfx $38) (branch target; code read 2026-10-19)
Kb_Page0_Press_GlyphSetB::
    ld a, $01                                     ; $5D04
    ld [wKbTabFrame + $2], a                      ; $5D06
    ld a, $01                                     ; $5D09
    ld [wKbPage], a                               ; $5D0B
    call Kb_LoadGlyphSetB                         ; $5D0E
    play_sfx1 SFX1_CURSOR_MOVE                    ; $5D11
    ret                                           ; $5D18


Jump_009_5d19:
    ld a, [wKbPage]                               ; $5D19
    and a                                         ; $5D1C
    jr z, Kb_Page0_Press_GlyphSetB                ; $5D1D

    jr Kb_Page0_Press_GlyphSetA                   ; $5D1F

    db $21, $27, $5d, $c3, $44, $5d

; C: voiced-mark map of the key $30: records {first code, count, new first code} ended by $FF: 06/0F/33, 1A/05/42,
; 58/01/86, 5B/0F/88, 6F/05/97. Kb_Page0_Press jumps to 09:5C77 for the key $30, loads this table and, for the
; character before the cursor, adds (code - first) to the new first code when the ...
Kb_DakutenMapTbl::
    db $06, $0f, $33, $1a, $05, $42, $58, $01, $86, $5b, $0f, $88, $6f, $05, $97, $ff

    db $21, $3d, $5d, $c3, $44, $5d

; C: semi-voiced-mark map of the key $31: records {first code, count, new first code} ended by $FF: 1A/05/47 and
; 6F/05/9C, i.e. the 5 h-row codes of hiragana (ha = 1A) and of katakana (ha = 6F) to the p row; same routine as
; Kb_DakutenMapTbl (09:5C9A) (C; the kana reading is I)
Kb_HandakutenMapTbl::
    db $1a, $05, $47, $6f, $05, $9c, $ff

    db $e5, $fa, $3b, $da, $4f, $06, $00, $21, $4d, $da, $09, $7e, $a7, $20, $08, $2b
    db $0d, $cb, $79, $28, $02, $e1, $c9, $46, $54, $5d, $e1, $78, $96, $d8, $23, $be
    db $30, $1c, $23, $86, $12, $79, $ea, $3b, $da, $cd, $a8, $5f, $f5, $3e, $03, $cd
    db $7e, $2b, $f1, $fa, $3b, $da, $fe, $08, $c8, $3c, $ea, $3b, $da, $c9, $23, $23
    db $7e, $fe, $ff, $20, $d6, $c9

; C: keys $4D and up, or the cursor past the ninth place: loads the sex page (map 23:7620 to $98C0, tiles 20:64C0 to
; $8800), cursor 0, sfx $16, state + 1 (branch target; code read 2026-10-19)
Kb_Page0_Press_ToPage1::
    farcopy Vram_CopyFromBank, Map_23_7620_Kb_Page0_Press, $98c0, $0140 ; $5D8A
    farcopy Vram_CopyFromBank, Gfx_20_64C0_OwnerCard_LoadGenderTiles, $8800, $0300 ; $5D98
    xor a                                         ; $5DA6
    ld [wKbCursor], a                             ; $5DA7
    ld a, [wKbKey]                                ; $5DAA
    cp $3e                                        ; $5DAD
    jr c, jr_009_5db9                             ; $5DAF

    cp $41                                        ; $5DB1
    jr nc, jr_009_5db9                            ; $5DB3

    ld a, $03                                     ; $5DB5
    jr jr_009_5dba                                ; $5DB7

jr_009_5db9:
    xor a                                         ; $5DB9

jr_009_5dba:
    ld [wKbKey], a                                ; $5DBA
    ld a, $03                                     ; $5DBD
    ld [wKbPage], a                               ; $5DBF
    play_sfx1 SFX1_OPTION_CHANGE                  ; $5DC2
    next_state                                    ; $5DC9
    ret                                           ; $5DCD


; C
Kb_Page1_PressSex::
    ldh a, [hKeysNew]                             ; $5DCE
    bit PADB_A, a                                 ; $5DD0
    ret z                                         ; $5DD2

    ld a, [wKbKey]                                ; $5DD3
    cp $05                                        ; $5DD6
    jp nc, Kb_Page1_PressSex_ToPage2              ; $5DD8

    cp $04                                        ; $5DDB
    jp nc, Kb_Page1_PressSex_ToPage0              ; $5DDD

    cp $03                                        ; $5DE0
    jp nc, Kb_Page1_PressSex_ToPage2              ; $5DE2

    ld a, [wOwnerGenderBlood]                     ; $5DE5
    and $fc                                       ; $5DE8
    ld hl, wKbKey                                 ; $5DEA
    or [hl]                                       ; $5DED
    ld [wOwnerGenderBlood], a                     ; $5DEE
    call OwnerCard_LoadGenderTiles                ; $5DF1
    play_sfx1 SFX1_KEY_A                          ; $5DF4
    ret                                           ; $5DFB


; C: key 4 of the sex page: back to the name page (Kb_LoadGlyphSetA, map 23:74A0 to $98C0, key $41, sfx 4) (branch
; target; code read 2026-10-19)
Kb_Page1_PressSex_ToPage0::
    call Kb_LoadGlyphSetA                         ; $5DFC
    farcopy Vram_CopyFromBank, Map_23_74A0_Kb_Page1_PressSex, $98c0, $0140 ; $5DFF
    xor a                                         ; $5E0D
    ld [wKbCursor], a                             ; $5E0E
    ld [wKbPage], a                               ; $5E11
    ld a, $41                                     ; $5E14
    ld [wKbKey], a                                ; $5E16
    play_sfx1 SFX1_KEY_B                          ; $5E19
    ld hl, wState                                 ; $5E20
    dec [hl]                                      ; $5E23
    ret                                           ; $5E24


; C: keys 3 and 5 and up of the sex page: loads the birth-date page (map 24:5DC0 to $98C0), key $0C when it was key 3,
; else 0 (branch target; code read 2026-10-19)
Kb_Page1_PressSex_ToPage2::
    farcopy Vram_CopyFromBank, Map_24_5DC0_Kb_Page1_PressSex, $98c0, $0140 ; $5E25
    xor a                                         ; $5E33
    ld [wKbCursor], a                             ; $5E34
    ld a, [wKbKey]                                ; $5E37
    cp $03                                        ; $5E3A
    jr nz, jr_009_5e42                            ; $5E3C

    ld a, $0c                                     ; $5E3E
    jr jr_009_5e43                                ; $5E40

jr_009_5e42:
    xor a                                         ; $5E42

jr_009_5e43:
    ld [wKbKey], a                                ; $5E43
    ld a, $04                                     ; $5E46
    ld [wKbPage], a                               ; $5E48
    play_sfx1 SFX1_OPTION_CHANGE                  ; $5E4B
    next_state                                    ; $5E52
    ret                                           ; $5E56


; I
Kb_Page2_PressBirthDate::
    ldh a, [hKeysNew]                             ; $5E57
    bit PADB_A, a                                 ; $5E59
    ret z                                         ; $5E5B

    ld a, [wKbKey]                                ; $5E5C
    cp $10                                        ; $5E5F
    jp nc, Kb_Page2_PressBirthDate_ToSave         ; $5E61

    cp $0f                                        ; $5E64
    jp nc, Kb_Page2_PressBirthDate_CursorLeft     ; $5E66

    cp $0c                                        ; $5E69
    jp nc, Kb_Page2_PressBirthDate_CursorRight    ; $5E6B

    ld a, [wKbCursor]                             ; $5E6E
    srl a                                         ; $5E71
    jr nc, jr_009_5e90                            ; $5E73

    xor $02                                       ; $5E75
    ld c, a                                       ; $5E77
    ld b, $00                                     ; $5E78
    ld hl, wOwnerBirthYear                        ; $5E7A
    add hl, bc                                    ; $5E7D
    ld a, [hl]                                    ; $5E7E
    and $f0                                       ; $5E7F
    ld c, a                                       ; $5E81
    ld a, [wKbKey]                                ; $5E82
    cp $0a                                        ; $5E85
    jr c, jr_009_5e8b                             ; $5E87

    ld a, $0a                                     ; $5E89

jr_009_5e8b:
    inc a                                         ; $5E8B
    or c                                          ; $5E8C
    ld [hl], a                                    ; $5E8D
    jr jr_009_5eab                                ; $5E8E

jr_009_5e90:
    xor $02                                       ; $5E90
    ld c, a                                       ; $5E92
    ld b, $00                                     ; $5E93
    ld hl, wOwnerBirthYear                        ; $5E95
    add hl, bc                                    ; $5E98
    ld a, [hl]                                    ; $5E99
    and $0f                                       ; $5E9A
    ld c, a                                       ; $5E9C
    ld a, [wKbKey]                                ; $5E9D
    cp $0a                                        ; $5EA0
    jr c, jr_009_5ea6                             ; $5EA2

    ld a, $0a                                     ; $5EA4

jr_009_5ea6:
    inc a                                         ; $5EA6
    swap a                                        ; $5EA7
    or c                                          ; $5EA9
    ld [hl], a                                    ; $5EAA

jr_009_5eab:
    call OwnerCard_LoadBirthTiles                 ; $5EAB
    play_sfx1 SFX1_KEY_A                          ; $5EAE
    ld a, [wKbCursor]                             ; $5EB5
    cp $07                                        ; $5EB8
    ret z                                         ; $5EBA

    inc a                                         ; $5EBB
    ld [wKbCursor], a                             ; $5EBC
    ret                                           ; $5EBF


; I: keys $0C-$0E: date cursor $DA3B + 1 (sfx $21); past the eighth place goes to the blood-type page (branch target;
; code read 2026-10-19)
Kb_Page2_PressBirthDate_CursorRight::
    ld a, [wKbCursor]                             ; $5EC0
    cp $07                                        ; $5EC3
    ret z                                         ; $5EC5

    inc a                                         ; $5EC6
    ld [wKbCursor], a                             ; $5EC7
    play_sfx1 SFX1_STEP_VALUE                     ; $5ECA
    ret                                           ; $5ED1


; C: key $0F: date cursor $DA3B - 1 (sfx 4), at 0 leaves the page (branch target; code read 2026-10-19)
Kb_Page2_PressBirthDate_CursorLeft::
    ld a, [wKbCursor]                             ; $5ED2
    and a                                         ; $5ED5
    jr z, jr_009_5ee4                             ; $5ED6

    dec a                                         ; $5ED8
    ld [wKbCursor], a                             ; $5ED9
    play_sfx1 SFX1_KEY_B                          ; $5EDC
    ret                                           ; $5EE3


jr_009_5ee4:
    farcopy Vram_CopyFromBank, Map_23_7620_Kb_Page0_Press, $98c0, $0140 ; $5EE4
    xor a                                         ; $5EF2
    ld [wKbCursor], a                             ; $5EF3
    ld a, $04                                     ; $5EF6
    ld [wKbKey], a                                ; $5EF8
    ld a, $03                                     ; $5EFB
    ld [wKbPage], a                               ; $5EFD
    play_sfx1 SFX1_KEY_B                          ; $5F00
    ld hl, wState                                 ; $5F07
    dec [hl]                                      ; $5F0A
    ret                                           ; $5F0B


; C: keys $10 and up on the birth-date page (`cp $10 / jp nc` at 09:5E5F): SFX1_OPTION_CHANGE, waits 10 frames, then
; state $0B (STATE_08_SAVE_OWNER): in this build the birth date is followed by saving the owner card, where the
; Japanese build loads the blood-type page (Kb_Page2_PressBirthDate_ToPage3); ...
Kb_Page2_PressBirthDate_ToSave::
    play_sfx1 SFX1_OPTION_CHANGE                  ; $5F0C
    ld bc, $000a                                  ; $5F13
    call Wait_Frames                              ; $5F16
    set_state STATE_08_SAVE_OWNER                 ; $5F19
    ret                                           ; $5F1E


; C
Kb_Page3_PressBloodType::
    ldh a, [hKeysNew]                             ; $5F1F
    bit PADB_A, a                                 ; $5F21
    ret z                                         ; $5F23

    ld a, [wKbKey]                                ; $5F24
    cp $0c                                        ; $5F27
    jp nc, Kb_Page3_PressBloodType_Confirm        ; $5F29

    cp $0b                                        ; $5F2C
    jp nc, Kb_Page3_PressBloodType_ToPage2        ; $5F2E

    cp $06                                        ; $5F31
    jp nc, Kb_Page3_PressBloodType_Ret            ; $5F33

    ld a, [wOwnerGenderBlood]                     ; $5F36
    and $03                                       ; $5F39
    ld c, a                                       ; $5F3B
    ld a, [wKbKey]                                ; $5F3C
    sla a                                         ; $5F3F
    sla a                                         ; $5F41
    or c                                          ; $5F43
    ld [wOwnerGenderBlood], a                     ; $5F44
    call OwnerCard_LoadBloodTiles                 ; $5F47
    play_sfx1 SFX1_KEY_A                          ; $5F4A
    ret                                           ; $5F51


; C: RET: keys 6-10 of the blood-type page do nothing (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_Ret::
    ret                                           ; $5F52


; C: key $0B: back to the birth-date page (map 24:5DC0, key $0F, set 4, sfx 4) (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_ToPage2::
    farcopy Vram_CopyFromBank, Map_24_5DC0_Kb_Page1_PressSex, $98c0, $0140 ; $5F53
    xor a                                         ; $5F61
    ld [wKbCursor], a                             ; $5F62
    ld a, $0f                                     ; $5F65
    ld [wKbKey], a                                ; $5F67
    ld a, $04                                     ; $5F6A
    ld [wKbPage], a                               ; $5F6C
    play_sfx1 SFX1_KEY_B                          ; $5F6F
    ld hl, wState                                 ; $5F76
    dec [hl]                                      ; $5F79
    ret                                           ; $5F7A


; C: keys $0C and up: sfx $16, 10-frame wait, state + 1 (the owner form is done) (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_Confirm::
    play_sfx1 SFX1_OPTION_CHANGE                  ; $5F7B
    ld bc, $000a                                  ; $5F82
    call Wait_Frames                              ; $5F85
    next_state                                    ; $5F88
    ret                                           ; $5F8C


; C: B (newly pressed, $FFA2 bit 1) moves the name cursor $DA3B back by one unless it is 0: backspace without erasing
; (C)
Kb_BackspaceOnB::
    ldh a, [hKeysNew]                             ; $5F8D
    bit PADB_B, a                                 ; $5F8F
    ret z                                         ; $5F91

    ld a, [wKbCursor]                             ; $5F92
    and a                                         ; $5F95
    ret z                                         ; $5F96

    dec a                                         ; $5F97
    ld [wKbCursor], a                             ; $5F98
    ret                                           ; $5F9B


; C: every 4th frame ($FFC8 & 3 = 0) xor $3C into the BGP shadow $FFB0: the blinking palette of the keyboard
; background (C)
Kb_BlinkBackground::
    ldh a, [hFrameCounter]                        ; $5F9C
    and $03                                       ; $5F9E
    ret nz                                        ; $5FA0

    ldh a, [hBgpShadow]                           ; $5FA1
    xor $3c                                       ; $5FA3
    ldh [hBgpShadow], a                           ; $5FA5
    ret                                           ; $5FA7


; C: owner_name[kb_cursor]
Kb_WriteNameChar::
    ld a, [wKbCursor]                             ; $5FA8
    ld c, a                                       ; $5FAB
    ld b, $00                                     ; $5FAC
    ld hl, wOwnerName                             ; $5FAE
    add hl, bc                                    ; $5FB1
    ld a, [hl]                                    ; $5FB2
    push af                                       ; $5FB3
    ld a, [wKbCursor]                             ; $5FB4
    swap a                                        ; $5FB7
    push af                                       ; $5FB9
    and $f0                                       ; $5FBA
    ld c, a                                       ; $5FBC
    pop af                                        ; $5FBD
    and $0f                                       ; $5FBE
    ld b, a                                       ; $5FC0
    sla c                                         ; $5FC1
    rl b                                          ; $5FC3
    ld hl, $9580                                  ; $5FC5
    add hl, bc                                    ; $5FC8
    ld d, h                                       ; $5FC9
    ld e, l                                       ; $5FCA
    pop af                                        ; $5FCB
    ld c, BANK(Sheet_MiscellaneousStampsJpn_2A_4000) ; $5FCC
    ld hl, Sheet_MiscellaneousStampsJpn_2A_4000   ; $5FCE
    call Glyph_LoadFromCharCode                   ; $5FD1
    ret                                           ; $5FD4


; C: Start+Select at power-on: A erases; B boots (README 16.18)
Boot_EraseAllPrompt_Far::
    push af                                       ; $5FD5
    ld a, $10                                     ; $5FD6
    ld [rRAMB], a                                 ; $5FD8
    ld hl, $a000                                  ; $5FDB

jr_009_5fde:
    bit 0, [hl]                                   ; $5FDE
    jr nz, jr_009_5fde                            ; $5FE0

    pop af                                        ; $5FE2
    and a                                         ; $5FE3
    jp nz, Boot_EraseAllPrompt_Far_Validate       ; $5FE4

    call Joy_Read                                 ; $5FE7
    ldh a, [hKeysHeld]                            ; $5FEA
    cp PADF_SELECT | PADF_START                   ; $5FEC
    jp nz, Boot_EraseAllPrompt_Far_Validate       ; $5FEE

    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $5FF1
    ldh [hLcdcShadow], a                          ; $5FF3
    ld a, $e4                                     ; $5FF5
    ld [wPaletteTarget], a                        ; $5FF7
    xor a                                         ; $5FFA
    ldh [hScxShadow], a                           ; $5FFB
    ldh [hScyShadow], a                           ; $5FFD
    farcopy Mem_CopyFromBank, Gfx_0F_7B00_Boot_EraseAllPrompt_Far, $9000, $0500 ; $5FFF
    farcopy Mem_CopyFromBank, Map_25_7820_Boot_EraseAllPrompt_Far, $9800, $0240 ; $600D
    call Pal_AllWhite                             ; $601B
    call Lcd_On                                   ; $601E
    call Sgb_MaskCancel                           ; $6021
    call Pal_FadeIn                               ; $6024

jr_009_6027:
    rst Rst08_WaitVBlank                          ; $6027
    ldh a, [hKeysNew]                             ; $6028
    bit PADB_B, a                                 ; $602A
    jr nz, jr_009_6050                            ; $602C

    bit PADB_A, a                                 ; $602E
    jr z, jr_009_6027                             ; $6030

    ldh [hFarcallAArg], a                         ; $6032
    farcall Sram_FormatAll_Far                    ; $6034
    ldh [hFarcallAArg], a                         ; $603C
    farcall Sram_ValidateAll_Far                  ; $603E
    ldh [hFarcallAArg], a                         ; $6046
    farcall Photo_RenumberVector                  ; $6048

jr_009_6050:
    screen_off                                    ; $6050

; C: end of the erase prompt (and the path without prompt): far-calls 02:442C Sram_ValidateAll_Far and 02:4466
; Photo_RenumberVector, then Far_Call_Return (the source shows `CommentEditor_DrawTextCursor` for 02:4466 only because
; bank 9 has that name at the same address) (branch target; code read ...
Boot_EraseAllPrompt_Far_Validate::
    ldh [hFarcallAArg], a                         ; $6056
    farcall Sram_ValidateAll_Far                  ; $6058
    ldh [hFarcallAArg], a                         ; $6060
    farcall Photo_RenumberVector                  ; $6062
    jp Far_Call_Return                            ; $606A


; C: mode 21: RUN! RUN! RUN! (three runners; 12 hurdles)
Mode21_RunRunRun::
    ld a, [wState]                                ; $606D
    rst Rst18_JumpTable                           ; $6070

; I: 15 states x 2 B (09:5FE7-6005); a false auto label at 6000 (from the "ld hl,$6000" of the owner-name glyph
; loaders, which points into bank 2A) was removed
Mode21_StateTable::
    dw Mode21_State00_Init
    dw Mode21_State01_PickCharacter
    dw Mode21_State02_RaceSceneInit
    dw Mode21_State03_RaceSetup
    dw Mode21_State04_Countdown
    dw Mode21_State05_ReadySteadyGo
    dw Mode21_State06_RaceLoop
    dw Mode21_State07_RaceEnd
    dw Mode21_State08_Unused
    dw Mode21_State09_Unused
    dw Mode21_State0A_Unused
    dw Mode21_State0B_ResultSetup
    dw Mode21_State0C_ResultScreen
    dw Mode21_State0D_Unused
    dw Mode21_State0E_Leave

; I
Mode21_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $608F
    ldh [hLcdcShadow], a                          ; $6091
    ld a, $e4                                     ; $6093
    ld [wPaletteTarget], a                        ; $6095
    ld [wPaletteTarget + $1], a                   ; $6098
    ld a, $d2                                     ; $609B
    ld [wPaletteTarget + $2], a                   ; $609D
    xor a                                         ; $60A0
    ldh [hScxShadow], a                           ; $60A1
    ldh [hScyShadow], a                           ; $60A3
    ld [wRunPickPose], a                          ; $60A5
    ld [wRunPickAnimCounter], a                   ; $60A8
    ldh [hFarcallAArg], a                         ; $60AB
    farcall GameFace_LoadTiles_Far                ; $60AD
    ld a, [wGamefacePresent]                      ; $60B5
    and a                                         ; $60B8
    jr z, jr_009_60c0                             ; $60B9

    ld a, $02                                     ; $60BB
    ld [wPickCharacter21], a                      ; $60BD

jr_009_60c0:
    farcopy Mem_CopyFromBank, Gfx_12_5800_Mode21_State00_Init, $9000, $0800 ; $60C0
    farcopy Mem_CopyFromBank, Gfx_12_6000_Mode21_State00_Init, $8800, $0800 ; $60CE
    farcopy Mem_CopyFromBank, Gfx_12_6800_Mode21_State00_Init, $8000, $0800 ; $60DC
    farcopy Mem_CopyFromBank, Map_27_5070_Mode0D_State06_PlayInit, $9800, $0240 ; $60EA
    ld a, $68                                     ; $60F8
    ldh [hLycShadowSplit1], a                     ; $60FA
    ldh [hSplit1Latch], a                         ; $60FC
    ld hl, hStatShadow                            ; $60FE
    set 6, [hl]                                   ; $6101
    ld hl, rIE                                    ; $6103
    set 1, [hl]                                   ; $6106
    ld a, $01                                     ; $6108
    ldh [hStatHandlerIndex], a                    ; $610A
    screen_on                                     ; $610C
    play_music MUSIC_SLIDESHOW_TUNE_04            ; $6115
    call Pal_FadeIn                               ; $611C
    next_state                                    ; $611F
    ret                                           ; $6123


; I: Left/Right = D9F8; A confirms; B back
Mode21_State01_PickCharacter::
    call Mode21_PickCharacterKeys                 ; $6124
    call Call_009_70f0                            ; $6127
    call Call_009_6167                            ; $612A
    ld a, [wAbResult]                             ; $612D
    bit 0, a                                      ; $6130
    jr z, jr_009_6149                             ; $6132

    screen_off                                    ; $6134
    stat_irq_off                                  ; $613A
    next_state                                    ; $6144
    ret                                           ; $6148


jr_009_6149:
    bit 1, a                                      ; $6149
    ret z                                         ; $614B

    screen_off                                    ; $614C
    stat_irq_off                                  ; $6152
    ld a, MODE_MAIN_MENU                          ; $615C
    ld [wMode], a                                 ; $615E
    set_state STATE_00_INIT                       ; $6161
    ret                                           ; $6166


Call_009_6167:
    ldh a, [hFrameCounter]                        ; $6167
    and $1f                                       ; $6169
    ret nz                                        ; $616B

    ldh a, [hFrameCounter]                        ; $616C
    bit 5, a                                      ; $616E
    jr nz, jr_009_6181                            ; $6170

    farcopy Vram_CopyFromBank, Map_27_5130_Mode21_State01_PickCharacter, $98c0, $0040 ; $6172
    ret                                           ; $6180


jr_009_6181:
    farcopy Vram_CopyFromBank, Map_27_52B0_Mode21_State01_PickCharacter, $98c0, $0040 ; $6181
    ret                                           ; $618F


; I
Mode21_PickCharacterKeys::
    ldh a, [hKeysNew]                             ; $6190
    and PADF_A | PADF_B                           ; $6192
    ld [wAbResult], a                             ; $6194
    jr z, jr_009_61ac                             ; $6197

    push af                                       ; $6199
    bit 0, a                                      ; $619A
    ld a, SFX1_KEY_A                              ; $619C
    call nz, Snd_Sfx1                             ; $619E
    pop af                                        ; $61A1
    push af                                       ; $61A2
    bit 1, a                                      ; $61A3
    ld a, SFX1_KEY_B                              ; $61A5
    call nz, Snd_Sfx1                             ; $61A7
    pop af                                        ; $61AA
    ret                                           ; $61AB


jr_009_61ac:
    ldh a, [hKeysNewRepeat]                       ; $61AC
    ld b, a                                       ; $61AE
    ld a, [wPickCharacter21]                      ; $61AF
    bit 5, b                                      ; $61B2
    jr z, jr_009_61bb                             ; $61B4

    and a                                         ; $61B6
    ret z                                         ; $61B7

    dec a                                         ; $61B8
    jr jr_009_61c2                                ; $61B9

jr_009_61bb:
    bit 4, b                                      ; $61BB
    ret z                                         ; $61BD

    cp $02                                        ; $61BE
    ret z                                         ; $61C0

    inc a                                         ; $61C1

jr_009_61c2:
    ld [wPickCharacter21], a                      ; $61C2
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $61C5
    ret                                           ; $61CC


; C
Mode21_State02_RaceSceneInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $61CD
    ldh [hLcdcShadow], a                          ; $61CF
    ld a, $e4                                     ; $61D1
    ld [wPaletteTarget], a                        ; $61D3
    ld [wPaletteTarget + $1], a                   ; $61D6
    ld a, $d2                                     ; $61D9
    ld [wPaletteTarget + $2], a                   ; $61DB
    ld a, $b8                                     ; $61DE
    ldh [hScxBand1], a                            ; $61E0
    ld a, $f0                                     ; $61E2
    ldh [hScyShadow], a                           ; $61E4
    ld a, $e0                                     ; $61E6
    ldh [hScyBand1], a                            ; $61E8
    xor a                                         ; $61EA
    ldh [hScxShadow], a                           ; $61EB
    ldh [hScxBand2], a                            ; $61ED
    ldh [hScyBand2], a                            ; $61EF
    ldh [hFarcallAArg], a                         ; $61F1
    farcall Counters_Load_Far                     ; $61F3
    farcopy Mem_CopyFromBank, Gfx_1B_6100_Mode21_State02_RaceSceneInit, $8a80, $0580 ; $61FB
    farcopy Mem_CopyFromBank, Gfx_1B_6680_Mode21_State02_RaceSceneInit, $8000, $0800 ; $6209
    farcopy Mem_CopyFromBank, Map_22_7340_Mode21_State02_RaceSceneInit, $9800, $0400 ; $6217
    farcopy Mem_CopyFromBank, Map_25_5F60_Mode21_State02_RaceSceneInit, $9c00, $0240 ; $6225
    ldh [hFarcallAArg], a                         ; $6233
    farcall GameFace_LoadTiles_Far                ; $6235
    call Run_LoadCharacterGraphicsA               ; $623D
    ld a, $08                                     ; $6240
    ldh [hLycShadowSplit1], a                     ; $6242
    ldh [hSplit1Latch], a                         ; $6244
    ld a, $5b                                     ; $6246
    ldh [hSplit2Line], a                          ; $6248
    ldh [hSplit2Latch], a                         ; $624A
    ld hl, hStatShadow                            ; $624C
    set 6, [hl]                                   ; $624F
    ld hl, rIE                                    ; $6251
    set 1, [hl]                                   ; $6254
    ld a, $07                                     ; $6256
    ldh [hStatHandlerIndex], a                    ; $6258
    screen_on                                     ; $625A
    play_music MUSIC_RUN_RACE_SCENE               ; $6263
    call Pal_FadeIn                               ; $626A
    next_state                                    ; $626D
    ret                                           ; $6271


; C: clears $D000-$D047
Mode21_State03_RaceSetup::
    call Run_ClearRaceState                       ; $6272
    call Run_DrawPlayer                           ; $6275
    call Run_DrawChick                            ; $6278
    call Run_DrawMoleAndScene                     ; $627B
    xor a                                         ; $627E
    ld [wRunTopSpeedFxTimer], a                   ; $627F
    next_state                                    ; $6282
    ret                                           ; $6286


; C: ends with race counter D04F++
Mode21_State04_Countdown::
    call Run_MovePlayerX                          ; $6287
    call Run_MoveChickX                           ; $628A
    call Run_MoveMoleX                            ; $628D
    call Run_MoveRunner3X                         ; $6290
    call Run_DrawPlayer                           ; $6293
    call Run_DrawChick                            ; $6296
    call Run_DrawMoleAndScene                     ; $6299
    call Run_DrawRunner3                          ; $629C
    ld c, $04                                     ; $629F
    call Run_PlaceRunner0                         ; $62A1
    call Run_PlaceRunner1                         ; $62A4
    call Run_PlaceRunner2                         ; $62A7
    call Run_PlaceRunner3                         ; $62AA
    ld a, c                                       ; $62AD
    and a                                         ; $62AE
    ret nz                                        ; $62AF

    ld a, [wRunState + $b]                        ; $62B0
    cp $0d                                        ; $62B3
    ret nz                                        ; $62B5

    play_music MUSIC_RUN_COUNTDOWN                ; $62B6
    xor a                                         ; $62BD
    ld [wRunStartDash], a                         ; $62BE
    ld [wRunPlayerLeads], a                       ; $62C1
    ld a, [wRunRaceCounter]                       ; $62C4
    inc a                                         ; $62C7
    ld [wRunRaceCounter], a                       ; $62C8
    next_state                                    ; $62CB
    ret                                           ; $62CF


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner0::
    ld a, [wRunPlayerPos]                         ; $62D0
    ld hl, wRunPlayerPos + $1                     ; $62D3
    or [hl]                                       ; $62D6
    ret nz                                        ; $62D7

    dec c                                         ; $62D8
    ld a, [wRunPlayerSpeedLevel]                  ; $62D9
    and a                                         ; $62DC
    ret z                                         ; $62DD

    xor a                                         ; $62DE
    ld [wRunPlayerSpeedLevel], a                  ; $62DF
    ld [wRunPlayerAnimCounter], a                 ; $62E2
    ld [wRunState + $c], a                        ; $62E5
    ld a, $05                                     ; $62E8
    ld [wRunPlayerPose], a                        ; $62EA
    ld a, $0d                                     ; $62ED
    ld [wRunState + $b], a                        ; $62EF
    ret                                           ; $62F2


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner1::
    ld a, [wRunChickPos]                          ; $62F3
    ld hl, wRunChickPos + $1                      ; $62F6
    or [hl]                                       ; $62F9
    ret nz                                        ; $62FA

    dec c                                         ; $62FB
    ld a, [wRunChickSpeed]                        ; $62FC
    and a                                         ; $62FF
    ret z                                         ; $6300

    xor a                                         ; $6301
    ld [wRunChickSpeed], a                        ; $6302
    ld [wRunChickAnimCounter], a                  ; $6305
    ld [wRunState + $c], a                        ; $6308
    ld a, $04                                     ; $630B
    ld [wRunChickState], a                        ; $630D
    ld a, $0f                                     ; $6310
    ld [wRunState + $b], a                        ; $6312
    ret                                           ; $6315


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner2::
    ld a, [wRunMolePos]                           ; $6316
    ld hl, wRunMolePos + $1                       ; $6319
    or [hl]                                       ; $631C
    ret nz                                        ; $631D

    dec c                                         ; $631E
    ld a, [wRunMoleSpeed]                         ; $631F
    and a                                         ; $6322
    ret z                                         ; $6323

    xor a                                         ; $6324
    ld [wRunMoleSpeed], a                         ; $6325
    ld [wRunMoleAnimCounter], a                   ; $6328
    ld a, $05                                     ; $632B
    ld [wRunMoleState], a                         ; $632D
    ret                                           ; $6330


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner3::
    ld a, [wRunRunner3Pos]                        ; $6331
    ld hl, wRunRunner3Pos + $1                    ; $6334
    or [hl]                                       ; $6337
    ret nz                                        ; $6338

    dec c                                         ; $6339
    ld a, [wRunRunner3Speed]                      ; $633A
    and a                                         ; $633D
    ret z                                         ; $633E

    xor a                                         ; $633F
    ld [wRunRunner3Speed], a                      ; $6340
    ret                                           ; $6343


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Mode21_State05_ReadySteadyGo::
    call Run_MovePlayerX                          ; $6344
    call Run_MoveChickX                           ; $6347
    call Run_MoveMoleX                            ; $634A
    call Run_DrawPlayer                           ; $634D
    call Run_DrawChick                            ; $6350
    call Run_DrawMoleAndScene                     ; $6353
    call Run_DrawRunner3                          ; $6356
    call Run_DrawPodiumBanner                     ; $6359
    ld a, [wRunBannerState]                       ; $635C
    res 7, a                                      ; $635F
    cp $07                                        ; $6361
    jr nc, jr_009_636f                            ; $6363

    ldh a, [hKeysNew]                             ; $6365
    and a                                         ; $6367
    ret z                                         ; $6368

    ld a, $ff                                     ; $6369
    ld [wRunStartDash], a                         ; $636B
    ret                                           ; $636E


jr_009_636f:
    cp $09                                        ; $636F
    jr nc, jr_009_6383                            ; $6371

    ldh a, [hKeysNew]                             ; $6373
    and a                                         ; $6375
    ret z                                         ; $6376

    ld a, [wRunStartDash]                         ; $6377
    bit 7, a                                      ; $637A
    ret nz                                        ; $637C

    ld a, $01                                     ; $637D
    ld [wRunStartDash], a                         ; $637F
    ret                                           ; $6382


jr_009_6383:
    cp $0c                                        ; $6383
    ret nz                                        ; $6385

    ld a, [wRunStartDash]                         ; $6386
    cp $01                                        ; $6389
    jr nz, jr_009_6397                            ; $638B

    ld a, $33                                     ; $638D
    ld [wRunPlayerRunCounter], a                  ; $638F
    ld a, $03                                     ; $6392
    ld [wRunPlayerStepSize], a                    ; $6394

jr_009_6397:
    xor a                                         ; $6397
    ld [wRunPlayerAnimCounter], a                 ; $6398
    ld [wRunState + $c], a                        ; $639B
    ld [wRunChickAnimCounter], a                  ; $639E
    ld [wRunMoleAnimCounter], a                   ; $63A1
    ld a, $07                                     ; $63A4
    ld [wRunPlayerPose], a                        ; $63A6
    ld a, $03                                     ; $63A9
    ld [wRunState + $b], a                        ; $63AB
    ld a, $06                                     ; $63AE
    ld [wRunChickState], a                        ; $63B0
    ld a, $07                                     ; $63B3
    ld [wRunMoleState], a                         ; $63B5
    farcopy Vram_CopyFromBank_4, Gfx_1B_6FC0_Mode21_State05_ReadySteadyGo, $81a0, $00a0 ; $63B8
    play_music MUSIC_RUN_READY_STEADY_GO          ; $63C6
    next_state                                    ; $63CD
    ret                                           ; $63D1


; C: Start leaves for state 0E
Mode21_State06_RaceLoop::
    ld a, [wRunState + $d]                        ; $63D2
    and a                                         ; $63D5
    call z, Run_RaceTimerTick                     ; $63D6
    call Run_UpdatePlayer                         ; $63D9
    call Run_UpdateChick                          ; $63DC
    call Run_UpdateMole                           ; $63DF
    call Run_HurdleCollision                      ; $63E2
    call Run_MovePlayerX                          ; $63E5
    call Run_MoveChickX                           ; $63E8
    call Run_MoveMoleX                            ; $63EB
    call Run_ScrollCamera                         ; $63EE
    call Run_DrawPlayer                           ; $63F1
    call Run_DrawChick                            ; $63F4
    call Run_DrawMoleAndScene                     ; $63F7
    call Run_DrawRunner3                          ; $63FA
    call Run_DrawBackgroundScroll                 ; $63FD
    call Run_DrawHurdles                          ; $6400
    call Run_DrawFinishLine                       ; $6403
    ldh a, [hKeysNew]                             ; $6406
    bit PADB_START, a                             ; $6408
    jr z, jr_009_6412                             ; $640A

    set_state STATE_21_LEAVE                      ; $640C
    ret                                           ; $6411


jr_009_6412:
    ld a, [wRunState + $d]                        ; $6412
    and a                                         ; $6415
    ret z                                         ; $6416

    call Run_CompareRecord                        ; $6417
    play_music MUSIC_RUN_RACE                     ; $641A
    next_state                                    ; $6421
    ret                                           ; $6425


; C: runner without a place gets 3
Mode21_State07_RaceEnd::
    ld hl, hKeysNew                               ; $6426
    res 0, [hl]                                   ; $6429
    res 1, [hl]                                   ; $642B
    res 6, [hl]                                   ; $642D
    ldh a, [hFrameCounter]                        ; $642F
    and $0f                                       ; $6431
    jr nz, jr_009_6437                            ; $6433

    set 0, [hl]                                   ; $6435

jr_009_6437:
    call Run_UpdatePlayer                         ; $6437
    call Run_UpdateChick                          ; $643A
    call Run_UpdateMole                           ; $643D
    call Run_HurdleCollision                      ; $6440
    call Run_MovePlayerX                          ; $6443
    call Run_MoveChickX                           ; $6446
    call Run_MoveMoleX                            ; $6449
    call Run_ScrollCamera                         ; $644C
    call Run_DrawPlayer                           ; $644F
    call Run_DrawChick                            ; $6452
    call Run_DrawMoleAndScene                     ; $6455
    call Run_DrawRunner3                          ; $6458
    call Run_DrawBackgroundScroll                 ; $645B
    call Run_DrawHurdles                          ; $645E
    call Run_DrawFinishLine                       ; $6461
    ld a, [wRunPlayerPos + $1]                    ; $6464
    bit 7, a                                      ; $6467
    ret nz                                        ; $6469

    cp $15                                        ; $646A
    ret c                                         ; $646C

    jr nz, jr_009_6475                            ; $646D

    ld a, [wRunPlayerPos]                         ; $646F
    cp $80                                        ; $6472
    ret c                                         ; $6474

jr_009_6475:
    ld a, [wRunState + $47]                       ; $6475
    cp $02                                        ; $6478
    ret c                                         ; $647A

    ld a, [wRunState + $d]                        ; $647B
    and a                                         ; $647E
    jr nz, jr_009_6486                            ; $647F

    ld a, $03                                     ; $6481
    ld [wRunState + $d], a                        ; $6483

jr_009_6486:
    ld a, [wRunState + $16]                       ; $6486
    and a                                         ; $6489
    jr nz, jr_009_6491                            ; $648A

    ld a, $03                                     ; $648C
    ld [wRunState + $16], a                       ; $648E

jr_009_6491:
    ld a, [wRunState + $1f]                       ; $6491
    and a                                         ; $6494
    jr nz, jr_009_649c                            ; $6495

    ld a, $03                                     ; $6497
    ld [wRunState + $1f], a                       ; $6499

jr_009_649c:
    screen_off                                    ; $649C
    stat_irq_off                                  ; $64A2
    set_state STATE_21_RESULT_SETUP               ; $64AC
    ret                                           ; $64B1


; C: never selected: state := 3
Mode21_State08_Unused::
    set_state STATE_21_RACE_SETUP                 ; $64B2
    ret                                           ; $64B7


; C: never selected: state := 3
Mode21_State09_Unused::
    set_state STATE_21_RACE_SETUP                 ; $64B8
    ret                                           ; $64BD


; C: never selected: state := 6
Mode21_State0A_Unused::
    set_state STATE_21_RACE_LOOP                  ; $64BE
    ret                                           ; $64C3


; C
Mode21_State0B_ResultSetup::
    ld a, LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON  ; $64C4
    ldh [hLcdcShadow], a                          ; $64C6
    ld a, $e4                                     ; $64C8
    ld [wPaletteTarget], a                        ; $64CA
    ld [wPaletteTarget + $1], a                   ; $64CD
    ld a, $d2                                     ; $64D0
    ld [wPaletteTarget + $2], a                   ; $64D2
    ld a, $10                                     ; $64D5
    ldh [hScxShadow], a                           ; $64D7
    ldh [hScxBand2], a                            ; $64D9
    ld a, $97                                     ; $64DB
    ldh [hWxShadow], a                            ; $64DD
    xor a                                         ; $64DF
    ldh [hScyShadow], a                           ; $64E0
    ldh [hScyBand2], a                            ; $64E2
    ldh [hWyShadow], a                            ; $64E4
    farcopy Mem_CopyFromBank, Gfx_19_6460_Mode21_State0B_ResultSetup, $9700, $0100 ; $64E6
    farcopy Mem_CopyFromBank, Gfx_19_6560_Mode21_State0B_ResultSetup, $8800, $0800 ; $64F4
    farcopy Mem_CopyFromBank, Gfx_19_6D60_Mode21_State0B_ResultSetup, $8000, $0400 ; $6502
    farcopy Mem_CopyFromBank, Map_26_69C0_Mode21_State0B_ResultSetup, $9800, $0240 ; $6510
    farcopy Mem_CopyFromBank, Map_22_7340_Mode21_State02_RaceSceneInit, $9c00, $0400 ; $651E
    call Run_PodiumSetup                          ; $652C
    ld a, $07                                     ; $652F
    ldh [hLycShadowSplit1], a                     ; $6531
    ldh [hSplit1Latch], a                         ; $6533
    ld a, $5a                                     ; $6535
    ldh [hSplit2Line], a                          ; $6537
    ldh [hSplit2Latch], a                         ; $6539
    ld hl, hStatShadow                            ; $653B
    set 6, [hl]                                   ; $653E
    ld hl, rIE                                    ; $6540
    set 1, [hl]                                   ; $6543
    ld a, $03                                     ; $6545
    ldh [hStatHandlerIndex], a                    ; $6547
    screen_on                                     ; $6549
    play_music MUSIC_RUN_RESULT_SETUP             ; $6552
    xor a                                         ; $6559
    ld [wRunResultMusicOn], a                     ; $655A
    call Run_DrawPlayer                           ; $655D
    call Run_DrawChick                            ; $6560
    call Run_DrawMoleAndScene                     ; $6563
    call Run_DrawFlag                             ; $6566
    ld a, [wRunState + $d]                        ; $6569
    cp $01                                        ; $656C
    jr nz, jr_009_6575                            ; $656E

    call Run_DrawConfetti                         ; $6570
    jr jr_009_657f                                ; $6573

jr_009_6575:
    ld c, $02                                     ; $6575
    call Run_LoadCharacterGraphicsB               ; $6577
    ld c, $03                                     ; $657A
    call Run_LoadCharacterGraphicsC               ; $657C

jr_009_657f:
    call Pal_FadeIn                               ; $657F
    next_state                                    ; $6582
    ret                                           ; $6586


; C
Run_PodiumSetup::
    xor a                                         ; $6587
    ld [wRunCameraPos], a                         ; $6588
    ld [wRunCameraPos + $1], a                    ; $658B
    ld [wRunUnusedD04C], a                        ; $658E
    ld [wRunFlagLevel], a                         ; $6591
    ld [wRunFlagCounter], a                       ; $6594
    ld [wRunCelebrationStep], a                   ; $6597
    ld a, $00                                     ; $659A
    ld [wRunFlagState], a                         ; $659C
    ld a, $74                                     ; $659F
    ld [wRunFlagY], a                             ; $65A1
    ld a, $fc                                     ; $65A4
    ld [wRunCrownY], a                            ; $65A6
    ld a, [wRunState + $16]                       ; $65A9
    cp $01                                        ; $65AC
    jr nz, jr_009_65c3                            ; $65AE

    farcopy Mem_CopyFromBank, Gfx_19_7310_Run_PodiumSetup, $8a40, $01b0 ; $65B0
    ld a, $02                                     ; $65BE
    ld [wRunFlagY], a                             ; $65C0

jr_009_65c3:
    ld a, [wRunState + $1f]                       ; $65C3
    cp $01                                        ; $65C6
    jr nz, jr_009_65dd                            ; $65C8

    farcopy Mem_CopyFromBank, Gfx_19_7160_Run_PodiumSetup, $8a40, $01b0 ; $65CA
    ld a, $02                                     ; $65D8
    ld [wRunFlagY], a                             ; $65DA

jr_009_65dd:
    call Run_DrawPodiumPlayer                     ; $65DD
    call Run_DrawPodiumChick                      ; $65E0
    call Run_DrawPodiumMole                       ; $65E3
    call Run_ConfettiInit                         ; $65E6
    ret                                           ; $65E9


; C: tables 09:6596
Run_DrawPodiumPlayer::
    ld a, [wRunState + $d]                        ; $65EA
    dec a                                         ; $65ED
    sla a                                         ; $65EE
    sla a                                         ; $65F0
    ld c, a                                       ; $65F2
    ld b, $00                                     ; $65F3
    ld hl, Run_PodiumPlayerTbl                    ; $65F5
    add hl, bc                                    ; $65F8
    ld a, [hl+]                                   ; $65F9
    ld [wRunPlayerPos], a                         ; $65FA
    ld a, [hl+]                                   ; $65FD
    ld [wRunPlayerJumpHeight], a                  ; $65FE
    ld a, [hl+]                                   ; $6601
    ld [wRunPlayerPose], a                        ; $6602
    ld a, [hl+]                                   ; $6605
    ld [wRunState + $b], a                        ; $6606
    xor a                                         ; $6609
    ld [wRunPlayerPos + $1], a                    ; $660A
    ld [wRunPlayerAnimCounter], a                 ; $660D
    ld [wRunState + $c], a                        ; $6610
    ld a, $01                                     ; $6613
    ld [wRunPlayerTickStep], a                    ; $6615
    ret                                           ; $6618


; C
Run_PodiumPlayerTbl::
    db $70, $2a, $14, $12, $b0, $0a, $17, $12, $30, $fa, $17, $12

; C
Run_DrawPodiumChick::
    ld a, [wRunState + $16]                       ; $6625
    dec a                                         ; $6628
    ld c, a                                       ; $6629
    sla a                                         ; $662A
    add c                                         ; $662C
    ld c, a                                       ; $662D
    ld b, $00                                     ; $662E
    ld hl, Run_PodiumChickTbl                     ; $6630
    add hl, bc                                    ; $6633
    ld a, [hl+]                                   ; $6634
    ld [wRunChickPos], a                          ; $6635
    ld a, [hl+]                                   ; $6638
    ld [wRunState + $13], a                       ; $6639
    ld a, [hl+]                                   ; $663C
    ld [wRunChickState], a                        ; $663D
    xor a                                         ; $6640
    ld [wRunChickPos + $1], a                     ; $6641
    ld [wRunChickAnimCounter], a                  ; $6644
    ld a, $01                                     ; $6647
    ld [wRunChickAnimStep], a                     ; $6649
    ret                                           ; $664C


; C
Run_PodiumChickTbl::
    db $80, $5c, $13
    db $c0, $6c, $13
    db $40, $74, $13

; C
Run_DrawPodiumMole::
    ld a, [wRunState + $1f]                       ; $6656
    dec a                                         ; $6659
    ld c, a                                       ; $665A
    sla a                                         ; $665B
    add c                                         ; $665D
    ld c, a                                       ; $665E
    ld b, $00                                     ; $665F
    ld hl, Run_PodiumMoleTbl                      ; $6661
    add hl, bc                                    ; $6664
    ld a, [hl+]                                   ; $6665
    ld [wRunMolePos], a                           ; $6666
    ld a, [hl+]                                   ; $6669
    ld [wRunState + $1c], a                       ; $666A
    ld a, [hl+]                                   ; $666D
    ld [wRunMoleState], a                         ; $666E
    xor a                                         ; $6671
    ld [wRunMolePos + $1], a                      ; $6672
    ld [wRunMoleAnimCounter], a                   ; $6675
    ld a, $01                                     ; $6678
    ld [wRunMoleAnimStep], a                      ; $667A
    ret                                           ; $667D


; C
Run_PodiumMoleTbl::
    db $78, $5c, $14
    db $b8, $6c, $14
    db $38, $74, $14

; C: initialises the 10 confetti records of 6 bytes at $D052 and clears $D051: {x = (random & $F8) + 4, dx = +2 or -2,
; y = random & $7F, dy = 1, frame = (9 when bit 1 of the loop counter 10..1 is set, else 0) + (random & 7), 0} (C)
Run_ConfettiInit::
    xor a                                         ; $6687
    ld [wRunConfettiFlicker], a                   ; $6688
    ld hl, wRunConfetti                           ; $668B
    ld b, $0a                                     ; $668E

jr_009_6690:
    call Rng_Next                                 ; $6690
    and $f8                                       ; $6693
    add $04                                       ; $6695
    ld [hl+], a                                   ; $6697
    call Rng_Next                                 ; $6698
    bit 0, a                                      ; $669B
    jr nz, jr_009_66a3                            ; $669D

    ld a, $02                                     ; $669F
    jr jr_009_66a5                                ; $66A1

jr_009_66a3:
    ld a, $fe                                     ; $66A3

jr_009_66a5:
    ld [hl+], a                                   ; $66A5
    call Rng_Next                                 ; $66A6
    and $7f                                       ; $66A9
    ld [hl+], a                                   ; $66AB
    ld a, $01                                     ; $66AC
    ld [hl+], a                                   ; $66AE
    ld a, $00                                     ; $66AF
    bit 1, b                                      ; $66B1
    jr z, jr_009_66b7                             ; $66B3

    ld a, $09                                     ; $66B5

jr_009_66b7:
    ld c, a                                       ; $66B7
    call Rng_Next                                 ; $66B8
    and $07                                       ; $66BB
    add c                                         ; $66BD
    ld [hl+], a                                   ; $66BE
    xor a                                         ; $66BF
    ld [hl+], a                                   ; $66C0
    dec b                                         ; $66C1
    jr nz, jr_009_6690                            ; $66C2

    ret                                           ; $66C4


; C: B or Start leaves for 0E
Mode21_State0C_ResultScreen::
    call Run_FlagHoistKeys                        ; $66C5
    call Run_FlagHeight                           ; $66C8
    call Run_ConfettiUpdate                       ; $66CB
    call Run_DrawPlayer                           ; $66CE
    call Run_DrawChick                            ; $66D1
    call Run_DrawMoleAndScene                     ; $66D4
    call Run_DrawFlag                             ; $66D7
    ld a, [wRunState + $d]                        ; $66DA
    cp $01                                        ; $66DD
    jr nz, jr_009_671d                            ; $66DF

    call Run_FlagUpConfettiDone                   ; $66E1
    push af                                       ; $66E4
    call nz, Run_DrawConfetti                     ; $66E5
    pop af                                        ; $66E8
    push af                                       ; $66E9
    call z, Run_Celebration                       ; $66EA
    pop af                                        ; $66ED
    call z, Run_DrawCrown                         ; $66EE
    ld a, [wRunFlagY]                             ; $66F1
    cp $74                                        ; $66F4
    jr nz, jr_009_670b                            ; $66F6

    ld a, [wRunResultMusicOn]                     ; $66F8
    and a                                         ; $66FB
    jr z, jr_009_671d                             ; $66FC

    play_music MUSIC_RUN_RESULT_SETUP             ; $66FE
    xor a                                         ; $6705
    ld [wRunResultMusicOn], a                     ; $6706
    jr jr_009_671d                                ; $6709

jr_009_670b:
    ld a, [wRunResultMusicOn]                     ; $670B
    and a                                         ; $670E
    jr nz, jr_009_671d                            ; $670F

    play_music MUSIC_RUN_RESULT                   ; $6711
    ld a, $01                                     ; $6718
    ld [wRunResultMusicOn], a                     ; $671A

jr_009_671d:
    ldh a, [hKeysNew]                             ; $671D
    and PADF_B | PADF_START                       ; $671F
    ret z                                         ; $6721

    set_state STATE_21_LEAVE                      ; $6722
    ret                                           ; $6727


; C: returns Z when the flag is at the top of the pole (wRunFlagY = 2, where Run_FlagHeight pins it with noise request
; $11 once A presses have hoisted it) and the y byte of all 10 confetti records ($D054, step 6) is 0: once the flag is
; up, Run_ConfettiRespawn retires each piece that falls off the screen ...
Run_FlagUpConfettiDone::
    ld a, [wRunFlagY]                             ; $6728
    cp $02                                        ; $672B
    ret nz                                        ; $672D

    xor a                                         ; $672E
    ld bc, $0006                                  ; $672F
    ld hl, wRunConfetti + $2                      ; $6732
    ld d, $0a                                     ; $6735

jr_009_6737:
    or [hl]                                       ; $6737
    add hl, bc                                    ; $6738
    dec d                                         ; $6739
    jr nz, jr_009_6737                            ; $673A

    and a                                         ; $673C
    ret                                           ; $673D


; C: a lone ret
Mode21_State0D_Unused::
    ret                                           ; $673E


; C: state := 0
Mode21_State0E_Leave::
    screen_off                                    ; $673F
    stat_irq_off                                  ; $6745
    set_state STATE_21_INIT                       ; $674F
    ret                                           ; $6754


; C: copies 72 B from 09:66E1 to $D000
Run_ClearRaceState::
    ld hl, Run_InitialStateTbl                    ; $6755
    ld de, wRunPlayerPos                          ; $6758
    ld b, $48                                     ; $675B

jr_009_675d:
    ld a, [hl+]                                   ; $675D
    ld [de], a                                    ; $675E
    inc de                                        ; $675F
    dec b                                         ; $6760
    jr nz, jr_009_675d                            ; $6761

    ret                                           ; $6763


; C
Run_InitialStateTbl::
    db $60, $ff, $01, $00, $01, $00, $00, $ee, $00, $00, $00, $00, $00, $00, $00, $ff
    db $01, $00, $01, $27, $00, $00, $00, $a0, $ff, $01, $00, $01, $8c, $00, $00, $00
    db $00, $00, $00, $00, $a0, $00, $ff

    ; padding
    ds $21, $00

; C
Run_UpdatePlayer::
    call Run_StumbleTick                          ; $67AC
    call Run_PlayerRun                            ; $67AF
    call Run_PlayerJump                           ; $67B2
    call Run_PlayerAirB                           ; $67B5
    call Run_PlayerLanding                        ; $67B8
    call Run_PlayerSpeedFromCounter               ; $67BB
    call Run_PlayerFrameFromSpeed                 ; $67BE
    ret                                           ; $67C1


; C: D044 counts down
Run_StumbleTick::
    ld a, [wRunStumbleCounter]                    ; $67C2
    and a                                         ; $67C5
    ret z                                         ; $67C6

    dec a                                         ; $67C7
    ld [wRunStumbleCounter], a                    ; $67C8
    ld [wRunPlayerRunCounter], a                  ; $67CB
    ld hl, hKeysNew                               ; $67CE
    res 0, [hl]                                   ; $67D1
    ret                                           ; $67D3


; C: A key = one step; counter D003
Run_PlayerRun::
    ld a, [wRunPlayerPose]                        ; $67D4
    res 7, a                                      ; $67D7
    cp $0c                                        ; $67D9
    ret nc                                        ; $67DB

    ldh a, [hKeysNew]                             ; $67DC
    bit PADB_A, a                                 ; $67DE
    jr nz, jr_009_67ef                            ; $67E0

    bit PADB_UP, a                                ; $67E2
    ret nz                                        ; $67E4

    ld a, [wRunPlayerRunCounter]                  ; $67E5
    and a                                         ; $67E8
    ret z                                         ; $67E9

    dec a                                         ; $67EA
    ld [wRunPlayerRunCounter], a                  ; $67EB
    ret                                           ; $67EE


jr_009_67ef:
    ld a, [wRunPlayerRunCounter]                  ; $67EF
    ld c, a                                       ; $67F2
    ld b, $00                                     ; $67F3
    ld hl, Run_SpeedStepTbl                       ; $67F5
    add hl, bc                                    ; $67F8
    ld a, [hl]                                    ; $67F9
    add c                                         ; $67FA
    ld [wRunPlayerRunCounter], a                  ; $67FB
    ld a, [wRunPlayerSpeedLevel]                  ; $67FE
    ld c, a                                       ; $6801
    ld b, $00                                     ; $6802
    ld hl, Run_PlayerRun_Tbl6841                  ; $6804
    add hl, bc                                    ; $6807
    ld a, [hl]                                    ; $6808
    ld [wRunPlayerStepSize], a                    ; $6809
    ret                                           ; $680C


; C
Run_SpeedStepTbl::
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e
    db $0d, $0d, $0d, $0d, $0c, $0c, $0c, $0c, $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a
    db $09, $09, $09, $09, $08, $08, $08, $08, $07, $06, $05, $04, $03, $02, $01, $00
    db $00, $00, $00, $00

; C: 7 values indexed by the speed level $D002 (0-6): 01 01 01 02 02 03 03, stored to $D008 at every A press of
; Run_PlayerRun (C)
Run_PlayerRun_Tbl6841::
    db $01, $01, $01, $02, $02, $03, $03

; C: Up = jump; sound $35
Run_PlayerJump::
    ld a, [wRunPlayerPose]                        ; $6848
    res 7, a                                      ; $684B
    cp $0c                                        ; $684D
    ret nc                                        ; $684F

    ldh a, [hKeysNew]                             ; $6850
    bit PADB_UP, a                                ; $6852
    ret z                                         ; $6854

    play_sfx1 SFX1_RUN_JUMP                       ; $6855
    ld a, [wRunPlayerRunCounter]                  ; $685C
    ld c, a                                       ; $685F
    ld b, $00                                     ; $6860
    ld hl, Run_PlayerJump_Tbl687F                 ; $6862
    add hl, bc                                    ; $6865
    ld a, [hl]                                    ; $6866
    ld [wRunPlayerJumpHeight], a                  ; $6867
    ld a, [wRunPlayerRunCounter]                  ; $686A
    srl a                                         ; $686D
    ld [wRunPlayerAirIndex], a                    ; $686F
    xor a                                         ; $6872
    ld [wRunPlayerAnimCounter], a                 ; $6873
    ld [wRunTopSpeedFxTimer], a                   ; $6876
    ld a, $0c                                     ; $6879
    ld [wRunPlayerPose], a                        ; $687B
    ret                                           ; $687E


; C: 52 jump heights indexed by the run counter $D003: 24 26 26 26 28 28 28 28 2A x8, 2B x4, 2C x4, 2D x4, 2E x4, 2F
; x8, 30 x12; Run_PlayerJump stores the entry to $D005 (height) when Up is pressed (C)
Run_PlayerJump_Tbl687F::
    db $24, $26, $26, $26, $28, $28, $28, $28, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a
    db $2b, $2b, $2b, $2b, $2c, $2c, $2c, $2c, $2d, $2d, $2d, $2d, $2e, $2e, $2e, $2e
    db $2f, $2f, $2f, $2f, $2f, $2f, $2f, $2f, $30, $30, $30, $30, $30, $30, $30, $30
    db $30, $30, $30, $30

; C: B in the air raises D007
Run_PlayerAirB::
    ld a, [wRunPlayerPose]                        ; $68B3
    res 7, a                                      ; $68B6
    cp $0c                                        ; $68B8
    ret c                                         ; $68BA

    ldh a, [hKeysNew]                             ; $68BB
    bit PADB_B, a                                 ; $68BD
    jr nz, jr_009_68cd                            ; $68BF

    ld a, [wRunPlayerAirIndex]                    ; $68C1
    sub $02                                       ; $68C4
    jr nc, jr_009_68c9                            ; $68C6

    xor a                                         ; $68C8

jr_009_68c9:
    ld [wRunPlayerAirIndex], a                    ; $68C9
    ret                                           ; $68CC


jr_009_68cd:
    ld a, [wRunPlayerAirIndex]                    ; $68CD
    ld c, a                                       ; $68D0
    ld b, $00                                     ; $68D1
    ld hl, Run_PlayerAirB_Tbl68DD                 ; $68D3
    add hl, bc                                    ; $68D6
    ld a, [hl]                                    ; $68D7
    add c                                         ; $68D8
    ld [wRunPlayerAirIndex], a                    ; $68D9
    ret                                           ; $68DC


; C: 32 bytes indexed by $D007 (0-31): 12 12 12 12 11 11 10 10 0F 0F 0E 0E 0D 0D 0C 0C 0B 0B 0A 0A 09 09 08 08 07 06
; 05 04 03 02 01 00; Run_PlayerAirB (09:6830, state >= $0C) adds the entry to $D007 while the jump button is held and
; subtracts 2 otherwise (C). The last 6 bytes (05 04 03 02 01 00) used to ...
Run_PlayerAirB_Tbl68DD::
    db $12, $12, $12, $12, $11, $11, $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c
    db $0b, $0b, $0a, $0a, $09, $09, $08, $08, $07, $06, $05, $04, $03, $02, $01, $00

; C
Run_PlayerSpeedFromCounter::
    ld a, [wRunPlayerPose]                        ; $68FD
    res 7, a                                      ; $6900
    cp $0c                                        ; $6902
    ret nc                                        ; $6904

    ld a, [wRunPlayerRunCounter]                  ; $6905
    ld c, a                                       ; $6908
    ld b, $00                                     ; $6909
    ld hl, Run_SpeedLevelTbl                      ; $690B
    add hl, bc                                    ; $690E
    ld a, [hl]                                    ; $690F
    ld [wRunPlayerSpeedLevel], a                  ; $6910
    ld c, a                                       ; $6913
    ld hl, Run_PlayerSpeedFromCounter_Tbl6976     ; $6914
    add hl, bc                                    ; $6917
    ld a, [hl]                                    ; $6918
    ld [wRunPlayerTickStep], a                    ; $6919
    ld a, [wRunPlayerSpeedLevel]                  ; $691C
    and a                                         ; $691F
    ret nz                                        ; $6920

    ld a, [wRunPlayerPose]                        ; $6921
    cp $87                                        ; $6924
    jr nz, jr_009_6932                            ; $6926

    ld a, [wRunPlayerStepSize]                    ; $6928
    and a                                         ; $692B
    jr z, jr_009_6932                             ; $692C

    dec a                                         ; $692E
    ld [wRunPlayerStepSize], a                    ; $692F

jr_009_6932:
    ld a, [wRunPlayerStepSize]                    ; $6932
    and a                                         ; $6935
    jr nz, jr_009_693c                            ; $6936

    ld [wRunPlayerTickStep], a                    ; $6938
    ret                                           ; $693B


jr_009_693c:
    ld a, $01                                     ; $693C
    ld [wRunPlayerSpeedLevel], a                  ; $693E
    ret                                           ; $6941


; C: 52 entries indexed by the counter $D003: speed level 0-6 (00 01 01 01 02.. 06); read by
; Run_PlayerSpeedFromCounter; the 20 + padding 16 + 16 byte split was a typing artefact
Run_SpeedLevelTbl::
    db $00, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $06, $06
    db $06, $06, $06, $06

; C: 7 values indexed by the speed level $D002: 0E 0E 12 15 20 2A 40, stored to $D004 = the tick step passed to
; Run_DrawMeta by Run_DrawPlayer (the run animation goes faster with the level) (C)
Run_PlayerSpeedFromCounter_Tbl6976::
    db $0e, $0e, $12, $15, $20, $2a, $40

; C: swaps the run frame of $D00B with the counter $D003: below $2F a frame 9 becomes 6, from $2F a frame 4 becomes
; $0B (C)
Run_PlayerFrameFromSpeed::
    ld a, [wRunPlayerRunCounter]                  ; $697D
    cp $2f                                        ; $6980
    ld a, [wRunState + $b]                        ; $6982
    jr nc, jr_009_6990                            ; $6985

    cp $09                                        ; $6987
    ret nz                                        ; $6989

    ld a, $06                                     ; $698A
    ld [wRunState + $b], a                        ; $698C
    ret                                           ; $698F


jr_009_6990:
    cp $04                                        ; $6990
    ret nz                                        ; $6992

    ld a, $0b                                     ; $6993
    ld [wRunState + $b], a                        ; $6995
    ret                                           ; $6998


; C: landing logic of the jump, for the state $D009 (bit 7 ignored) >= $0C (it sets the tick step $D004 := 1): in
; state $0C, when $D00A = 1, it subtracts Run_PlayerLanding_Tbl696E[$D007] from the height $D005 (floor 0) and when
; the height is below $10 clears $D00A and sets the state $10; in state $12 it ...
Run_PlayerLanding::
    ld a, [wRunPlayerPose]                        ; $6999
    res 7, a                                      ; $699C
    cp $0c                                        ; $699E
    ret c                                         ; $69A0

    ld a, $01                                     ; $69A1
    ld [wRunPlayerTickStep], a                    ; $69A3
    jr nz, jr_009_69d4                            ; $69A6

    ld a, $01                                     ; $69A8
    ld [wRunPlayerTickStep], a                    ; $69AA
    ld a, [wRunPlayerAnimCounter]                 ; $69AD
    cp $01                                        ; $69B0
    ret nz                                        ; $69B2

    ld a, [wRunPlayerAirIndex]                    ; $69B3
    ld c, a                                       ; $69B6
    ld b, $00                                     ; $69B7
    ld hl, Run_PlayerLanding_Tbl69F1              ; $69B9
    add hl, bc                                    ; $69BC
    ld a, [wRunPlayerJumpHeight]                  ; $69BD
    sub [hl]                                      ; $69C0
    jr nc, jr_009_69c4                            ; $69C1

    xor a                                         ; $69C3

jr_009_69c4:
    ld [wRunPlayerJumpHeight], a                  ; $69C4
    cp $10                                        ; $69C7
    ret nc                                        ; $69C9

    xor a                                         ; $69CA
    ld [wRunPlayerAnimCounter], a                 ; $69CB
    ld a, $10                                     ; $69CE
    ld [wRunPlayerPose], a                        ; $69D0
    ret                                           ; $69D3


jr_009_69d4:
    ld a, [wRunPlayerPose]                        ; $69D4
    res 7, a                                      ; $69D7
    cp $12                                        ; $69D9
    ret nz                                        ; $69DB

    xor a                                         ; $69DC
    ld [wRunPlayerJumpHeight], a                  ; $69DD
    ld a, [wRunPlayerRunCounter]                  ; $69E0
    sub $20                                       ; $69E3
    jr nc, jr_009_69e8                            ; $69E5

    xor a                                         ; $69E7

jr_009_69e8:
    ld [wRunPlayerRunCounter], a                  ; $69E8
    ld a, $07                                     ; $69EB
    ld a, [wRunPlayerPose]                        ; $69ED
    ret                                           ; $69F0


; C: 32 height steps indexed by $D007 (0-31): 12 12 10 10 0E 0E 0A 0A 08 x12, 07 x4, 06 x8; subtracted from the jump
; height $D005 by Run_PlayerLanding (C)
Run_PlayerLanding_Tbl69F1::
    db $12, $12, $10, $10, $0e, $0e, $0a, $0a, $08, $08, $08, $08, $08, $08, $08, $08
    db $08, $08, $08, $08, $07, $07, $07, $07, $06, $06, $06, $06, $06, $06, $06, $06

; C: table 69AB (3 px/frame) or 69B7 (5 px/frame)
Run_UpdateChick::
    ld hl, Run_ChickPathTblSlow                   ; $6A11
    ld a, [wRunRaceCounter]                       ; $6A14
    and $03                                       ; $6A17
    jr nz, jr_009_6a1e                            ; $6A19

    ld hl, Run_ChickPathTblFast                   ; $6A1B

jr_009_6a1e:
    ld a, [wRunChickState]                        ; $6A1E
    res 7, a                                      ; $6A21
    sub $06                                       ; $6A23
    ld c, a                                       ; $6A25
    ld b, $00                                     ; $6A26
    add hl, bc                                    ; $6A28
    ld a, [hl]                                    ; $6A29
    ld [wRunChickSpeed], a                        ; $6A2A
    ret                                           ; $6A2D


; C
Run_ChickPathTblSlow::
    db $05, $07, $09, $0b, $0b, $09, $07, $05, $03, $03, $03, $03

; C
Run_ChickPathTblFast::
    db $05, $07, $09, $0b, $0b, $09, $07, $05, $05, $05, $05, $05

; C: table 69DF (4 px) or 69E3 (5 px)
Run_UpdateMole::
    ld hl, Run_MolePathTblSlow                    ; $6A46
    ld a, [wRunPlayerLeads]                       ; $6A49
    and a                                         ; $6A4C
    jr z, jr_009_6a52                             ; $6A4D

    ld hl, Run_MolePathTblFast                    ; $6A4F

jr_009_6a52:
    ld a, [wRunMoleState]                         ; $6A52
    res 7, a                                      ; $6A55
    sub $07                                       ; $6A57
    ld c, a                                       ; $6A59
    ld b, $00                                     ; $6A5A
    add hl, bc                                    ; $6A5C
    ld a, [hl]                                    ; $6A5D
    ld [wRunMoleSpeed], a                         ; $6A5E
    ret                                           ; $6A61


; C
Run_MolePathTblSlow::
    db $08, $0d, $10, $12

; C
Run_MolePathTblFast::
    db $12, $10, $0d, $08, $04, $04, $04, $04, $05, $05, $05, $05

; C: 0 < x - hurdle <= 24: stumble; sound $04
Run_HurdleCollision::
    ld a, [wRunPlayerJumpHeight]                  ; $6A72
    cp $01                                        ; $6A75
    ret nc                                        ; $6A77

    ld hl, wRunState + $2c                        ; $6A78
    ld de, Run_HurdleXTbl                         ; $6A7B
    ld b, $0c                                     ; $6A7E

jr_009_6a80:
    push bc                                       ; $6A80
    push de                                       ; $6A81
    push hl                                       ; $6A82
    ld hl, wRunPlayerPos                          ; $6A83
    ld a, [de]                                    ; $6A86
    sub [hl]                                      ; $6A87
    ld c, a                                       ; $6A88
    inc hl                                        ; $6A89
    inc de                                        ; $6A8A
    ld a, [de]                                    ; $6A8B
    sbc [hl]                                      ; $6A8C
    ld b, a                                       ; $6A8D
    ld a, c                                       ; $6A8E
    add $18                                       ; $6A8F
    ld c, a                                       ; $6A91
    jr nc, jr_009_6a95                            ; $6A92

    inc b                                         ; $6A94

jr_009_6a95:
    ld a, b                                       ; $6A95
    and a                                         ; $6A96
    jr nz, jr_009_6ab8                            ; $6A97

    ld a, c                                       ; $6A99
    cp $18                                        ; $6A9A
    jr nc, jr_009_6ab8                            ; $6A9C

    pop hl                                        ; $6A9E
    push hl                                       ; $6A9F
    ld a, [hl]                                    ; $6AA0
    res 7, a                                      ; $6AA1
    cp $02                                        ; $6AA3
    jr nc, jr_009_6ab8                            ; $6AA5

    play_sfx4 SFX4_RUN_HURDLE_HIT                 ; $6AA7
    ld a, $02                                     ; $6AAE
    ld [hl+], a                                   ; $6AB0
    xor a                                         ; $6AB1
    ld [hl], a                                    ; $6AB2
    ld a, $05                                     ; $6AB3
    ld [wRunStumbleCounter], a                    ; $6AB5

jr_009_6ab8:
    pop hl                                        ; $6AB8
    pop de                                        ; $6AB9
    pop bc                                        ; $6ABA
    inc hl                                        ; $6ABB
    inc hl                                        ; $6ABC
    inc de                                        ; $6ABD
    inc de                                        ; $6ABE
    dec b                                         ; $6ABF
    jr nz, jr_009_6a80                            ; $6AC0

    ret                                           ; $6AC2


; C: A presses hoist the flag
Run_FlagHoistKeys::
    ld a, [wRunFlagCounter]                       ; $6AC3
    ld c, a                                       ; $6AC6
    ld b, $00                                     ; $6AC7
    ld hl, Run_FlagHoistKeys_LevelTbl             ; $6AC9
    add hl, bc                                    ; $6ACC
    ld a, [hl]                                    ; $6ACD
    ld [wRunFlagLevel], a                         ; $6ACE
    ldh a, [hKeysNew]                             ; $6AD1
    bit PADB_A, a                                 ; $6AD3
    jr nz, jr_009_6ae1                            ; $6AD5

    ld a, [wRunFlagCounter]                       ; $6AD7
    and a                                         ; $6ADA
    ret z                                         ; $6ADB

    dec a                                         ; $6ADC
    ld [wRunFlagCounter], a                       ; $6ADD
    ret                                           ; $6AE0


jr_009_6ae1:
    ld a, [wRunFlagCounter]                       ; $6AE1
    ld c, a                                       ; $6AE4
    ld b, $00                                     ; $6AE5
    ld hl, Run_FlagHoistKeys_StepTbl              ; $6AE7
    add hl, bc                                    ; $6AEA
    ld a, [hl]                                    ; $6AEB
    add c                                         ; $6AEC
    ld [wRunFlagCounter], a                       ; $6AED
    ret                                           ; $6AF0


; C: 52 entries indexed by the flag counter $D04A: 16 x8, 15 x4, 14 x4 ... 8 x4, 7 6 5 4 3 2 1 0 0 0 0 0; an A press
; adds the entry to the counter (Run_FlagHoistKeys 6A5E-6A6A)
Run_FlagHoistKeys_StepTbl::
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e
    db $0d, $0d, $0d, $0d, $0c, $0c, $0c, $0c, $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a
    db $09, $09, $09, $09, $08, $08, $08, $08, $07, $06, $05, $04, $03, $02, $01, $00
    db $00, $00, $00, $00

; C: 52 entries indexed by the flag counter $D04A: level 0-6 stored to $D049; byte for byte the same as
; Run_SpeedLevelTbl; the 20 + padding 16 + 16 byte split was a typing artefact
Run_FlagHoistKeys_LevelTbl::
    db $00, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $06, $06
    db $06, $06, $06, $06

; C: 16-bit position += speed
Run_MovePlayerX::
    ld hl, wRunPlayerSpeedLevel                   ; $6B59
    ld de, wRunPlayerPos                          ; $6B5C
    call Run_Add16                                ; $6B5F
    ld a, [wRunPlayerPos + $1]                    ; $6B62
    bit 7, a                                      ; $6B65
    ret nz                                        ; $6B67

    cp $14                                        ; $6B68
    ret c                                         ; $6B6A

    jr nz, jr_009_6b73                            ; $6B6B

    ld a, [wRunPlayerPos]                         ; $6B6D
    cp $00                                        ; $6B70
    ret c                                         ; $6B72

jr_009_6b73:
    ld a, [wRunState + $d]                        ; $6B73
    and a                                         ; $6B76
    ret nz                                        ; $6B77

    ld a, [wRunState + $47]                       ; $6B78
    inc a                                         ; $6B7B
    ld [wRunState + $47], a                       ; $6B7C
    ld [wRunState + $d], a                        ; $6B7F
    ret                                           ; $6B82


; C
Run_MoveChickX::
    ld hl, wRunChickSpeed                         ; $6B83
    ld de, wRunChickPos                           ; $6B86
    call Run_Add16                                ; $6B89
    ld a, [wRunChickPos + $1]                     ; $6B8C
    bit 7, a                                      ; $6B8F
    ret nz                                        ; $6B91

    cp $14                                        ; $6B92
    ret c                                         ; $6B94

    jr nz, jr_009_6b9d                            ; $6B95

    ld a, [wRunChickPos]                          ; $6B97
    cp $00                                        ; $6B9A
    ret c                                         ; $6B9C

jr_009_6b9d:
    ld a, [wRunState + $16]                       ; $6B9D
    and a                                         ; $6BA0
    ret nz                                        ; $6BA1

    ld a, [wRunState + $47]                       ; $6BA2
    inc a                                         ; $6BA5
    ld [wRunState + $47], a                       ; $6BA6
    ld [wRunState + $16], a                       ; $6BA9
    ret                                           ; $6BAC


; C: sets D050 when the player leads by $A0
Run_MoveMoleX::
    ld hl, wRunMoleSpeed                          ; $6BAD
    ld de, wRunMolePos                            ; $6BB0
    call Run_Add16                                ; $6BB3
    ld de, wRunPlayerPos                          ; $6BB6
    ld hl, wRunMolePos                            ; $6BB9
    ld a, [de]                                    ; $6BBC
    sub [hl]                                      ; $6BBD
    ld c, a                                       ; $6BBE
    inc de                                        ; $6BBF
    inc hl                                        ; $6BC0
    ld a, [de]                                    ; $6BC1
    sbc [hl]                                      ; $6BC2
    bit 7, a                                      ; $6BC3
    jr nz, jr_009_6bd4                            ; $6BC5

    and a                                         ; $6BC7
    jr nz, jr_009_6bcf                            ; $6BC8

    ld a, c                                       ; $6BCA
    cp $a0                                        ; $6BCB
    jr c, jr_009_6bd4                             ; $6BCD

jr_009_6bcf:
    ld a, $01                                     ; $6BCF
    ld [wRunPlayerLeads], a                       ; $6BD1

jr_009_6bd4:
    ld a, [wRunMolePos + $1]                      ; $6BD4
    bit 7, a                                      ; $6BD7
    ret nz                                        ; $6BD9

    cp $14                                        ; $6BDA
    ret c                                         ; $6BDC

    jr nz, jr_009_6be5                            ; $6BDD

    ld a, [wRunMolePos]                           ; $6BDF
    cp $00                                        ; $6BE2
    ret c                                         ; $6BE4

jr_009_6be5:
    ld a, [wRunState + $1f]                       ; $6BE5
    and a                                         ; $6BE8
    ret nz                                        ; $6BE9

    ld a, [wRunState + $47]                       ; $6BEA
    inc a                                         ; $6BED
    ld [wRunState + $47], a                       ; $6BEE
    ld [wRunState + $1f], a                       ; $6BF1
    ret                                           ; $6BF4


; C: adds the signed speed byte $D026 (sign-extended) to the 16-bit position $D024/$D025 of the fourth runner
; (Run_Add16) (C)
Run_MoveRunner3X::
    ld hl, wRunRunner3Speed                       ; $6BF5
    ld de, wRunRunner3Pos                         ; $6BF8
    call Run_Add16                                ; $6BFB
    ret                                           ; $6BFE


; C: camera: while the player position $D000/$D001 is below $1400 the camera $D020/$D021 follows it
; (Run_CopyPlayerPos); from $1400 (the finish line) the camera is frozen at $1400 (C)
Run_ScrollCamera::
    ld a, [wRunCameraPos]                         ; $6BFF
    cp $00                                        ; $6C02
    jr nz, jr_009_6c0c                            ; $6C04

    ld a, [wRunCameraPos + $1]                    ; $6C06
    cp $14                                        ; $6C09
    ret z                                         ; $6C0B

jr_009_6c0c:
    call Run_CopyPlayerPos                        ; $6C0C
    ld a, [wRunCameraPos + $1]                    ; $6C0F
    cp $14                                        ; $6C12
    ret c                                         ; $6C14

    jr nz, jr_009_6c1d                            ; $6C15

    ld a, [wRunCameraPos]                         ; $6C17
    cp $00                                        ; $6C1A
    ret c                                         ; $6C1C

jr_009_6c1d:
    ld a, $00                                     ; $6C1D
    ld [wRunCameraPos], a                         ; $6C1F
    ld a, $14                                     ; $6C22
    ld [wRunCameraPos + $1], a                    ; $6C24
    ret                                           ; $6C27


; C: copies the 16-bit player position $D000/$D001 into the camera $D020/$D021 (C)
Run_CopyPlayerPos::
    ld hl, wRunCameraPos                          ; $6C28
    ld de, wRunPlayerPos                          ; $6C2B
    ld a, [de]                                    ; $6C2E
    ld [hl+], a                                   ; $6C2F
    inc de                                        ; $6C30
    ld a, [de]                                    ; $6C31
    ld [hl], a                                    ; $6C32
    ret                                           ; $6C33


; C: D048 = min($74; D048 + 5 or 6) - D049
Run_FlagHeight::
    ld c, $05                                     ; $6C34
    call Rng_Next                                 ; $6C36
    and $03                                       ; $6C39
    jr nz, jr_009_6c3e                            ; $6C3B

    inc c                                         ; $6C3D

jr_009_6c3e:
    ld a, [wRunFlagY]                             ; $6C3E
    cp $02                                        ; $6C41
    ret z                                         ; $6C43

    add c                                         ; $6C44
    cp $74                                        ; $6C45
    jr c, jr_009_6c4b                             ; $6C47

    ld a, $74                                     ; $6C49

jr_009_6c4b:
    ld hl, wRunFlagLevel                          ; $6C4B
    sub [hl]                                      ; $6C4E
    jr c, jr_009_6c57                             ; $6C4F

    cp $02                                        ; $6C51
    jr z, jr_009_6c57                             ; $6C53

    jr nc, jr_009_6c60                            ; $6C55

jr_009_6c57:
    play_sfx4 SFX4_RUN_FLAG_HEIGHT                ; $6C57
    ld a, $02                                     ; $6C5E

jr_009_6c60:
    ld [wRunFlagY], a                             ; $6C60
    ret                                           ; $6C63


; C: updates the 10 confetti records: Run_ConfettiParticle for each record, step 6 (C)
Run_ConfettiUpdate::
    ld bc, $0a00                                  ; $6C64

jr_009_6c67:
    call Run_ConfettiParticle                     ; $6C67
    ld a, c                                       ; $6C6A
    add $06                                       ; $6C6B
    ld c, a                                       ; $6C6D
    dec b                                         ; $6C6E
    jr nz, jr_009_6c67                            ; $6C6F

    ret                                           ; $6C71


; C: one confetti record (offset C): by its frame number the sideways speed dx is applied in full (frames 2, 6, $0B,
; $0F), halved (1, 3, 5, 7, $0A, $0C, $0E, $10) or replaced by a new random +-2 when bit 7 is set; x stays within
; 4..$FB; then y += dy and a carry out of y calls Run_ConfettiRespawn (C)
Run_ConfettiParticle::
    push bc                                       ; $6C72
    ld b, $00                                     ; $6C73
    ld hl, wRunConfetti + $4                      ; $6C75
    add hl, bc                                    ; $6C78
    ld a, [hl]                                    ; $6C79
    cp $01                                        ; $6C7A
    jr z, jr_009_6cac                             ; $6C7C

    cp $03                                        ; $6C7E
    jr z, jr_009_6cac                             ; $6C80

    cp $05                                        ; $6C82
    jr z, jr_009_6cac                             ; $6C84

    cp $07                                        ; $6C86
    jr z, jr_009_6cac                             ; $6C88

    cp $0a                                        ; $6C8A
    jr z, jr_009_6cac                             ; $6C8C

    cp $0c                                        ; $6C8E
    jr z, jr_009_6cac                             ; $6C90

    cp $0e                                        ; $6C92
    jr z, jr_009_6cac                             ; $6C94

    cp $10                                        ; $6C96
    jr z, jr_009_6cac                             ; $6C98

    cp $02                                        ; $6C9A
    jr z, jr_009_6cc3                             ; $6C9C

    cp $06                                        ; $6C9E
    jr z, jr_009_6cc3                             ; $6CA0

    cp $0b                                        ; $6CA2
    jr z, jr_009_6cc3                             ; $6CA4

    cp $0f                                        ; $6CA6
    jr z, jr_009_6cc3                             ; $6CA8

    jr jr_009_6cd8                                ; $6CAA

jr_009_6cac:
    ld hl, wRunConfetti + $1                      ; $6CAC
    add hl, bc                                    ; $6CAF
    ld a, [hl]                                    ; $6CB0
    sra a                                         ; $6CB1
    ld hl, wRunConfetti                           ; $6CB3
    add hl, bc                                    ; $6CB6
    add [hl]                                      ; $6CB7
    cp $04                                        ; $6CB8
    jr c, jr_009_6cee                             ; $6CBA

    cp $fc                                        ; $6CBC
    jr nc, jr_009_6cee                            ; $6CBE

    ld [hl], a                                    ; $6CC0
    jr jr_009_6cee                                ; $6CC1

jr_009_6cc3:
    ld hl, wRunConfetti + $1                      ; $6CC3
    add hl, bc                                    ; $6CC6
    ld a, [hl]                                    ; $6CC7
    ld hl, wRunConfetti                           ; $6CC8
    add hl, bc                                    ; $6CCB
    add [hl]                                      ; $6CCC
    cp $04                                        ; $6CCD
    jr c, jr_009_6cee                             ; $6CCF

    cp $fc                                        ; $6CD1
    jr nc, jr_009_6cee                            ; $6CD3

    ld [hl], a                                    ; $6CD5
    jr jr_009_6cee                                ; $6CD6

jr_009_6cd8:
    bit 7, a                                      ; $6CD8
    jr z, jr_009_6cee                             ; $6CDA

    call Rng_Next                                 ; $6CDC
    bit 0, a                                      ; $6CDF
    jr nz, jr_009_6ce7                            ; $6CE1

    ld a, $02                                     ; $6CE3
    jr jr_009_6ce9                                ; $6CE5

jr_009_6ce7:
    ld a, $fe                                     ; $6CE7

jr_009_6ce9:
    ld hl, wRunConfetti + $1                      ; $6CE9
    add hl, bc                                    ; $6CEC
    ld [hl], a                                    ; $6CED

jr_009_6cee:
    ld hl, wRunConfetti + $3                      ; $6CEE
    add hl, bc                                    ; $6CF1
    ld a, [hl]                                    ; $6CF2
    ld hl, wRunConfetti + $2                      ; $6CF3
    add hl, bc                                    ; $6CF6
    add [hl]                                      ; $6CF7
    ld [hl], a                                    ; $6CF8
    call c, Run_ConfettiRespawn                   ; $6CF9
    pop bc                                        ; $6CFC
    ret                                           ; $6CFD


; C: respawn of a confetti record: when $D048 = 2 it sets y and dy to 0 (the piece stays), else a new random x
; ((random & $F8) + 4) and y (random & $0F) (C)
Run_ConfettiRespawn::
    ld a, [wRunFlagY]                             ; $6CFE
    cp $02                                        ; $6D01
    jr z, jr_009_6d1c                             ; $6D03

    call Rng_Next                                 ; $6D05
    and $f8                                       ; $6D08
    add $04                                       ; $6D0A
    ld hl, wRunConfetti                           ; $6D0C
    add hl, bc                                    ; $6D0F
    ld [hl], a                                    ; $6D10
    call Rng_Next                                 ; $6D11
    and $0f                                       ; $6D14
    ld hl, wRunConfetti + $2                      ; $6D16
    add hl, bc                                    ; $6D19
    ld [hl], a                                    ; $6D1A
    ret                                           ; $6D1B


jr_009_6d1c:
    xor a                                         ; $6D1C
    ld hl, wRunConfetti + $2                      ; $6D1D
    add hl, bc                                    ; $6D20
    ld [hl+], a                                   ; $6D21
    ld [hl+], a                                   ; $6D22
    ret                                           ; $6D23


; C: requests $30 then $16; pose table 09:6CE1
Run_Celebration::
    ld a, [wRunCelebrationStep]                   ; $6D24
    inc a                                         ; $6D27
    cp $0d                                        ; $6D28
    jr nc, jr_009_6d51                            ; $6D2A

    ld [wRunCelebrationStep], a                   ; $6D2C
    cp $01                                        ; $6D2F
    jr nz, jr_009_6d3a                            ; $6D31

    play_sfx1 SFX1_RUN_CELEBRATION                ; $6D33

jr_009_6d3a:
    cp $0c                                        ; $6D3A
    jr nz, jr_009_6d45                            ; $6D3C

    play_sfx1 SFX1_OPTION_CHANGE                  ; $6D3E

jr_009_6d45:
    ld c, a                                       ; $6D45
    ld b, $00                                     ; $6D46
    ld hl, Run_CelebrationPoseTbl                 ; $6D48
    add hl, bc                                    ; $6D4B
    ld a, [hl]                                    ; $6D4C
    ld [wRunCrownY], a                            ; $6D4D
    ret                                           ; $6D50


jr_009_6d51:
    ld a, [wRunPlayerPose]                        ; $6D51
    cp $14                                        ; $6D54
    jr nz, jr_009_6d5e                            ; $6D56

    ld a, $0c                                     ; $6D58
    ld [wRunCrownY], a                            ; $6D5A
    ret                                           ; $6D5D


jr_009_6d5e:
    ld a, $0d                                     ; $6D5E
    ld [wRunCrownY], a                            ; $6D60
    ret                                           ; $6D63


; C
Run_CelebrationPoseTbl::
    db $fc, $fd, $fe, $ff, $00, $01, $02, $03, $05, $08, $0c, $0b, $0c

; C: [DE] += [HL] with sign extension
Run_Add16::
    ld a, [de]                                    ; $6D71
    add [hl]                                      ; $6D72
    ld [de], a                                    ; $6D73
    inc de                                        ; $6D74
    bit 7, [hl]                                   ; $6D75
    jr nz, jr_009_6d7e                            ; $6D77

    ld a, [de]                                    ; $6D79
    adc $00                                       ; $6D7A
    ld [de], a                                    ; $6D7C
    ret                                           ; $6D7D


jr_009_6d7e:
    ld a, [de]                                    ; $6D7E
    adc $ff                                       ; $6D7F
    ld [de], a                                    ; $6D81
    ret                                           ; $6D82


; C: UNREFERENCED: 16-bit subtraction helper
Unused_Run_Sub16::
    ld a, [de]                                    ; $6D83
    sub [hl]                                      ; $6D84
    ld [de], a                                    ; $6D85
    inc de                                        ; $6D86
    bit 7, [hl]                                   ; $6D87
    jr nz, jr_009_6d90                            ; $6D89

    ld a, [de]                                    ; $6D8B
    sbc $00                                       ; $6D8C
    ld [de], a                                    ; $6D8E
    ret                                           ; $6D8F


jr_009_6d90:
    ld a, [de]                                    ; $6D90
    sbc $ff                                       ; $6D91
    ld [de], a                                    ; $6D93
    ret                                           ; $6D94


; I
Run_DrawPlayer::
    ld hl, wRunCameraPos                          ; $6D95
    ld a, [wRunPlayerPos]                         ; $6D98
    sub [hl]                                      ; $6D9B
    ld c, a                                       ; $6D9C
    inc hl                                        ; $6D9D
    ld a, [wRunPlayerPos + $1]                    ; $6D9E
    sbc [hl]                                      ; $6DA1
    sra a                                         ; $6DA2
    rr c                                          ; $6DA4
    call Run_OffscreenTest                        ; $6DA6
    jr nc, jr_009_6db0                            ; $6DA9

    ld a, $a0                                     ; $6DAB
    ldh [hScxBand1], a                            ; $6DAD
    ld c, a                                       ; $6DAF

jr_009_6db0:
    ld a, c                                       ; $6DB0
    push af                                       ; $6DB1
    cpl                                           ; $6DB2
    add $79                                       ; $6DB3
    ld b, a                                       ; $6DB5
    ld a, [wRunPlayerJumpHeight]                  ; $6DB6
    sra a                                         ; $6DB9
    cpl                                           ; $6DBB
    add $71                                       ; $6DBC
    ld c, a                                       ; $6DBE
    pop af                                        ; $6DBF
    ldh [hScxBand1], a                            ; $6DC0
    push bc                                       ; $6DC2
    ld hl, Run_DrawPlayer_Tbl6E2B                 ; $6DC3
    ld de, wRunPlayerPose                         ; $6DC6
    ld a, [wRunPlayerTickStep]                    ; $6DC9
    call Run_DrawMeta                             ; $6DCC
    pop bc                                        ; $6DCF
    push af                                       ; $6DD0
    ld a, [wRunPlayerPose]                        ; $6DD1
    cp $8a                                        ; $6DD4
    jr nz, jr_009_6de4                            ; $6DD6

    ld a, [wRunPlayerSpeedLevel]                  ; $6DD8
    cp $04                                        ; $6DDB
    jr c, jr_009_6de4                             ; $6DDD

    ld a, $05                                     ; $6DDF
    ld [wRunTopSpeedFxTimer], a                   ; $6DE1

jr_009_6de4:
    ld a, [wRunTopSpeedFxTimer]                   ; $6DE4
    and a                                         ; $6DE7
    jr z, jr_009_6df3                             ; $6DE8

    dec a                                         ; $6DEA
    ld [wRunTopSpeedFxTimer], a                   ; $6DEB
    ld a, $29                                     ; $6DEE
    call Oam_AddMeta_B02_6F16                     ; $6DF0

jr_009_6df3:
    pop af                                        ; $6DF3
    cp $50                                        ; $6DF4
    jr c, jr_009_6e02                             ; $6DF6

    sub $50                                       ; $6DF8
    ld c, a                                       ; $6DFA
    ld b, $00                                     ; $6DFB
    ld hl, Run_DrawPlayer_Tbl6E27                 ; $6DFD
    jr jr_009_6e0a                                ; $6E00

jr_009_6e02:
    sub $10                                       ; $6E02
    ld c, a                                       ; $6E04
    ld b, $00                                     ; $6E05
    ld hl, Run_DrawPlayer_Tbl6E1F                 ; $6E07

jr_009_6e0a:
    add hl, bc                                    ; $6E0A
    ld a, [wRunPlayerJumpHeight]                  ; $6E0B
    sra a                                         ; $6E0E
    add [hl]                                      ; $6E10
    ld c, a                                       ; $6E11
    ld hl, Run_DrawPlayer_Tbl6E5F                 ; $6E12
    ld de, wRunState + $b                         ; $6E15
    ld a, [wRunPlayerTickStep]                    ; $6E18
    call Run_SplitScreenLine                      ; $6E1B
    ret                                           ; $6E1E


; C: 8 vertical offsets for the metas $13-$1A, added to height/2 by Run_DrawPlayer before the second layer
; (SplitScreenLine): FF FF 00 00 01 04 06 02 (C)
Run_DrawPlayer_Tbl6E1F::
    db $ff, $ff, $00, $00, $01, $04, $06, $02

; C: 4 vertical offsets for the metas $53-$56: 04 03 04 02 (Run_DrawPlayer) (C)
Run_DrawPlayer_Tbl6E27::
    db $04, $03, $04, $02

; I: player animation list ($D009 = pose, step $D004): 13 04 14 04 15 04 16 04 FF 00 (run cycle, loops to 0) / 13 80
; FF 05 / 13 80 14 80 15 80 16 80 FF 07 / 1A 04 17 04 18 04 FF 0C / 19 04 16 03 16 00 FF 07 / 53 0C 54 0C FF 14 / 55
; 20 56 20 FF 17: animation list read by Run_DrawMeta / ...
Run_DrawPlayer_Tbl6E2B::
    db $10, $04, $11, $04, $12, $04, $13, $04, $ff, $00, $10, $80, $ff, $05, $10, $80
    db $11, $80, $12, $80, $13, $80, $ff, $07, $17, $04, $14, $04, $15, $04, $ff, $0c
    db $16, $04, $13, $03, $13, $00, $ff, $07, $50, $0c, $51, $0c, $ff, $14, $52, $20
    db $53, $20, $ff, $17

; C: second layer of the player: list of {value, duration} read by Run_SplitScreenLine with the state $D00B; the value
; plus the vertical offset goes to $FFBA (scroll Y of the LCD split band): E0 20 30 20 FF 00 / E0 C0 30 C0 FF 03 / 30
; 80 FF 03 / 88 D0 30 80 FF 08 / 30 80 FF 08 / E0 80 FF 0D / E0 10 30 ...
Run_DrawPlayer_Tbl6E5F::
    db $e0, $20, $30, $20, $ff, $00, $e0, $c0, $30, $c0, $ff, $03, $30, $80, $ff, $03
    db $88, $d0, $30, $80, $ff, $08, $30, $80, $ff, $08, $e0, $80, $ff, $0d, $e0, $10
    db $30, $40, $ff, $0d, $e0, $0c, $30, $0c, $ff, $12

; C
Run_DrawChick::
    ld hl, wRunCameraPos                          ; $6E89
    ld a, [wRunChickPos]                          ; $6E8C
    sub [hl]                                      ; $6E8F
    ld c, a                                       ; $6E90
    inc hl                                        ; $6E91
    ld a, [wRunChickPos + $1]                     ; $6E92
    sbc [hl]                                      ; $6E95
    sra a                                         ; $6E96
    rr c                                          ; $6E98
    call Run_OffscreenTest                        ; $6E9A
    jr nc, jr_009_6ea1                            ; $6E9D

    ld c, $c0                                     ; $6E9F

jr_009_6ea1:
    ld a, c                                       ; $6EA1
    cpl                                           ; $6EA2
    add $79                                       ; $6EA3
    ld b, a                                       ; $6EA5
    ld a, [wRunState + $13]                       ; $6EA6
    ld c, a                                       ; $6EA9
    ld hl, Run_DrawChick_Tbl6EB7                  ; $6EAA
    ld de, wRunChickState                         ; $6EAD
    ld a, [wRunChickAnimStep]                     ; $6EB0
    call Run_DrawMeta                             ; $6EB3
    ret                                           ; $6EB6


; I: chick animation list ($D014 = state, step $D012): animation list read by Run_DrawMeta / Run_SplitScreenLine:
; pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it receives in A to the
; tick byte each call; the next entry is taken when the tick reaches the ...
Run_DrawChick_Tbl6EB7::
    db $1d, $04, $1e, $04, $1f, $04, $ff, $00, $1c, $80, $ff, $04, $1d, $05, $1e, $05
    db $1f, $05, $1d, $04, $1e, $04, $1f, $04, $1d, $03, $1e, $03, $1f, $03, $1d, $04
    db $1e, $04, $1f, $04, $ff, $0f, $3a, $30, $3b, $04, $3c, $04, $3f, $04, $3a, $34
    db $3e, $04, $3d, $04, $3f, $02, $40, $02, $41, $02, $40, $02, $41, $02, $43, $34
    db $42, $04, $3a, $14, $3b, $04, $3c, $04, $3d, $04, $3b, $04, $3c, $04, $3d, $04
    db $3a, $30, $42, $04, $43, $04, $44, $04, $45, $34, $44, $06, $43, $06, $42, $04
    db $ff, $13

; C
Run_DrawMoleAndScene::
    ld hl, wRunCameraPos                          ; $6F19
    ld a, [wRunMolePos]                           ; $6F1C
    sub [hl]                                      ; $6F1F
    ld c, a                                       ; $6F20
    inc hl                                        ; $6F21
    ld a, [wRunMolePos + $1]                      ; $6F22
    sbc [hl]                                      ; $6F25
    sra a                                         ; $6F26
    rr c                                          ; $6F28
    call Run_OffscreenTest                        ; $6F2A
    jr nc, jr_009_6f31                            ; $6F2D

    ld c, $c0                                     ; $6F2F

jr_009_6f31:
    ld a, c                                       ; $6F31
    cpl                                           ; $6F32
    add $71                                       ; $6F33
    ld b, a                                       ; $6F35
    ld a, [wRunState + $1c]                       ; $6F36
    ld c, a                                       ; $6F39
    ld hl, Run_DrawMoleAndScene_Tbl6F47           ; $6F3A
    ld de, wRunMoleState                          ; $6F3D
    ld a, [wRunMoleAnimStep]                      ; $6F40
    call Run_DrawMeta                             ; $6F43
    ret                                           ; $6F46


; I: mole animation list ($D01D = state, step $D01B): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs
; {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it receives in A to the tick
; byte each call; the next entry is taken when the tick reaches the ...
Run_DrawMoleAndScene_Tbl6F47::
    db $21, $04, $20, $04, $22, $04, $20, $04, $ff, $00, $30, $80, $ff, $05, $21, $04
    db $20, $04, $22, $04, $20, $04, $21, $04, $20, $04, $22, $04, $20, $04, $21, $04
    db $20, $04, $22, $04, $20, $04, $ff, $0f, $35, $30, $36, $06, $35, $17, $36, $06
    db $35, $06, $36, $06, $35, $08, $36, $08, $35, $38, $37, $04, $38, $05, $39, $28
    db $38, $03, $37, $04, $ff, $14

; I: draws the fourth runner (meta $34 at x = -(position / 2), y = 0) when its position $D024/$D025 is on screen
; (Run_ScaledPosition returns NC) (C)
Run_DrawRunner3::
    ld a, [wRunRunner3Pos]                        ; $6F8D
    ld c, a                                       ; $6F90
    ld a, [wRunRunner3Pos + $1]                   ; $6F91
    sra a                                         ; $6F94
    rr c                                          ; $6F96
    call Run_OffscreenTest                        ; $6F98
    ret c                                         ; $6F9B

    ld a, c                                       ; $6F9C
    cpl                                           ; $6F9D
    inc a                                         ; $6F9E
    ld b, a                                       ; $6F9F
    ld c, $00                                     ; $6FA0
    ld a, $31                                     ; $6FA2
    call Oam_AddMeta_B02_6F16                     ; $6FA4
    ret                                           ; $6FA7


; C: draws the podium banner at x = $36, y = $40 with Run_BannerSpriteTbl and the state $D02A (Run_DrawMeta, tick step
; 1) (C)
Run_DrawPodiumBanner::
    ld bc, $3640                                  ; $6FA8
    ld hl, Run_BannerSpriteTbl                    ; $6FAB
    ld de, wRunBannerState                        ; $6FAE
    ld a, $01                                     ; $6FB1
    call Run_DrawMeta                             ; $6FB3
    ret                                           ; $6FB6


; I: banner animation list: 00 50 26 03 27 03 28 20 27 03 26 03 00 30 2A 01 29 01 2A 02 2B 10 00 02 00 80 FF 0C (meta
; 0 = nothing): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n
; jumps to entry n (Run_DrawMeta adds the tick step it receives in A to ...
Run_BannerSpriteTbl::
    db $00, $50, $23, $03, $24, $03, $25, $20, $24, $03, $23, $03, $00, $30, $27, $01
    db $26, $01, $27, $02, $28, $10, $00, $02, $00, $80, $ff, $0c

; C: background scroll: $FFBC := -(camera $D020/$D021 / 2) (C)
Run_DrawBackgroundScroll::
    ld a, [wRunCameraPos]                         ; $6FD3
    ld c, a                                       ; $6FD6
    ld a, [wRunCameraPos + $1]                    ; $6FD7
    sra a                                         ; $6FDA
    rr c                                          ; $6FDC
    ld a, c                                       ; $6FDE
    cpl                                           ; $6FDF
    inc a                                         ; $6FE0
    ldh [hScxBand2], a                            ; $6FE1
    ret                                           ; $6FE3


; C: 12 hurdles from table 09:6F9B
Run_DrawHurdles::
    ld hl, wRunState + $2c                        ; $6FE4
    ld de, Run_HurdleXTbl                         ; $6FE7
    ld b, $0c                                     ; $6FEA

jr_009_6fec:
    push bc                                       ; $6FEC
    push de                                       ; $6FED
    push hl                                       ; $6FEE
    ld hl, wRunCameraPos                          ; $6FEF
    ld a, [de]                                    ; $6FF2
    sub [hl]                                      ; $6FF3
    ld c, a                                       ; $6FF4
    inc hl                                        ; $6FF5
    inc de                                        ; $6FF6
    ld a, [de]                                    ; $6FF7
    sbc [hl]                                      ; $6FF8
    sra a                                         ; $6FF9
    rr c                                          ; $6FFB
    call Run_OffscreenTest                        ; $6FFD
    jr c, jr_009_7013                             ; $7000

    ld a, c                                       ; $7002
    cpl                                           ; $7003
    add $79                                       ; $7004
    ld b, a                                       ; $7006
    ld c, $70                                     ; $7007
    ld hl, Run_DrawHurdles_Tbl7036                ; $7009
    pop de                                        ; $700C
    push de                                       ; $700D
    ld a, $01                                     ; $700E
    call Run_DrawMeta                             ; $7010

jr_009_7013:
    pop hl                                        ; $7013
    pop de                                        ; $7014
    pop bc                                        ; $7015
    inc hl                                        ; $7016
    inc hl                                        ; $7017
    inc de                                        ; $7018
    inc de                                        ; $7019
    dec b                                         ; $701A
    jr nz, jr_009_6fec                            ; $701B

    ret                                           ; $701D


; C: $180 $380 $580 $680 $880 $940 $B40 $C40 $D00 $F00 $1000 $1200
Run_HurdleXTbl::
    db $80, $01, $80, $03, $80, $05, $80, $06, $80, $08, $40, $09, $40, $0b, $40, $0c
    db $00, $0d, $00, $0f, $00, $10, $00, $12

; I: hurdle animation list: 1B 04 FF 00 (still) / 1C 02 1D 02 1E 02 FF 04 (knocked over): animation list read by
; Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds
; the tick step it receives in A to the tick byte each call; the next entry is ...
Run_DrawHurdles_Tbl7036::
    db $18, $04, $ff, $00, $19, $02, $1a, $02, $1b, $02, $ff, $04

; C: draws the finish line at the world position $1400: x = $78 - (($1400 - camera) / 2) (low byte) when on screen, y
; = $70, animation Run_DrawFinishLine_Tbl6FE6 with the state $D045 (C)
Run_DrawFinishLine::
    ld hl, wRunCameraPos                          ; $7042
    ld a, $00                                     ; $7045
    sub [hl]                                      ; $7047
    ld c, a                                       ; $7048
    inc hl                                        ; $7049
    inc de                                        ; $704A
    ld a, $14                                     ; $704B
    sbc [hl]                                      ; $704D
    sra a                                         ; $704E
    rr c                                          ; $7050
    call Run_OffscreenTest                        ; $7052
    ret c                                         ; $7055

    ld a, c                                       ; $7056
    cpl                                           ; $7057
    add $79                                       ; $7058
    ld b, a                                       ; $705A
    ld c, $70                                     ; $705B
    ld hl, Run_DrawFinishLine_Tbl7069             ; $705D
    ld de, wRunFinishLineState                    ; $7060
    ld a, $01                                     ; $7063
    call Run_DrawMeta                             ; $7065
    ret                                           ; $7068


; I: finish line animation list: 2D 06 2E 06 2F 06 FF 00 (loop): animation list read by Run_DrawMeta /
; Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it
; receives in A to the tick byte each call; the next entry is taken when the tick ...
Run_DrawFinishLine_Tbl7069::
    db $2a, $06, $2b, $06, $2c, $06, $ff, $00

; C
Run_DrawFlag::
    ld b, $96                                     ; $7071
    ld a, [wRunFlagY]                             ; $7073
    ld c, a                                       ; $7076
    ld hl, Run_FlagSpriteTbl                      ; $7077
    ld de, wRunFlagState                          ; $707A
    ld a, $01                                     ; $707D
    call Run_DrawMeta                             ; $707F
    ret                                           ; $7082


; I: flag animation list: 35 08 36 08 37 08 FF 00 (loop; Run_DrawFlag draws it at x = $96, y = height $D048 with the
; state $D04B): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n
; jumps to entry n (Run_DrawMeta adds the tick step it receives in A to ...
Run_FlagSpriteTbl::
    db $32, $08, $33, $08, $34, $08, $ff, $00

; I
Run_DrawCrown::
    ld b, $40                                     ; $708B
    ld a, [wRunCrownY]                            ; $708D
    ld c, a                                       ; $7090
    ld a, $54                                     ; $7091
    call Oam_AddMeta_B02_6F16                     ; $7093
    ret                                           ; $7096


; C
Run_DrawConfetti::
    ld hl, wRunConfetti                           ; $7097
    ld b, $0a                                     ; $709A

jr_009_709c:
    ld a, [wRunConfettiFlicker]                   ; $709C
    xor b                                         ; $709F
    bit 0, a                                      ; $70A0
    call nz, Run_DrawConfettiSprite               ; $70A2
    ld de, $0006                                  ; $70A5
    add hl, de                                    ; $70A8
    dec b                                         ; $70A9
    jr nz, jr_009_709c                            ; $70AA

    ld hl, wRunConfettiFlicker                    ; $70AC
    inc [hl]                                      ; $70AF
    ret                                           ; $70B0


; C: draws one confetti piece: x = record x / 2, y = record y / 2 - $10, animation Run_DrawConfettiSprite_AnimTbl7049
; with the frame and tick bytes of the record (Run_DrawMeta) (C)
Run_DrawConfettiSprite::
    push bc                                       ; $70B1
    push hl                                       ; $70B2
    ld a, [hl+]                                   ; $70B3
    srl a                                         ; $70B4
    ld b, a                                       ; $70B6
    inc hl                                        ; $70B7
    ld a, [hl+]                                   ; $70B8
    srl a                                         ; $70B9
    sub $10                                       ; $70BB
    ld c, a                                       ; $70BD
    inc hl                                        ; $70BE
    ld d, h                                       ; $70BF
    ld e, l                                       ; $70C0
    ld hl, Run_DrawConfettiSprite_AnimTbl70CC     ; $70C1
    ld a, $01                                     ; $70C4
    call Run_DrawMeta                             ; $70C6
    pop hl                                        ; $70C9
    pop bc                                        ; $70CA
    ret                                           ; $70CB


; I: animation list {meta id, duration} (the pair 'FF, n' jumps to entry n): 49 04 4A 04 4B 04 4C 04 4D 04 4C 04 4B 04
; 4A 04 FF 00 / 4E 04 4F 04 50 04 51 04 52 04 51 04 50 04 4F 04 FF 09; passed in HL to Run_DrawMeta by
; Run_DrawConfettiSprite (09:702E). It was named UserMap_AnimateDecoSprites_Gfx7049 ...
Run_DrawConfettiSprite_AnimTbl70CC::
    db $46, $04, $47, $04, $48, $04, $49, $04, $4a, $04, $49, $04, $48, $04, $47, $04
    db $ff, $00, $4b, $04, $4c, $04, $4d, $04, $4e, $04, $4f, $04, $4e, $04, $4d, $04
    db $4c, $04, $ff, $09

Call_009_70f0:
    ld a, [wPickCharacter21]                      ; $70F0
    sla a                                         ; $70F3
    ld c, a                                       ; $70F5
    ld b, $00                                     ; $70F6
    ld hl, Run_DrawConfettiSprite_AnimTbl70CC + $3F ; $70F8
    add hl, bc                                    ; $70FB
    ld c, [hl]                                    ; $70FC
    inc hl                                        ; $70FD
    ld b, [hl]                                    ; $70FE
    ld hl, Run_DrawPickCharacterSprite_Tbl7111    ; $70FF
    ld de, wRunPickPose                           ; $7102
    ld a, $01                                     ; $7105
    call Run_DrawMeta                             ; $7107
    ret                                           ; $710A


    db $88
    db $08
    db $88
    db $1b
    db $88
    db $31

; I: animation lists of the character-pick sprite: 00 10 0C 02 0D 02 0E 02 0F 02 10 02 FF 05 / 00 10 0C 02 0D 02 0E 02
; 0F 02 11 02 FF 0C / 00 10 0C 02 0D 02 0E 02 0F 02 12 02 FF 13 / 0F 02 0E 02 0D 02 0C 02 00 10 00 08 FF 1A: animation
; list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, ...
Run_DrawPickCharacterSprite_Tbl7111::
    db $0c
    db $08
    db $0d
    db $08
    db $0e
    db $08
    db $0f
    db $08
    db $0e
    db $08
    db $0d
    db $08
    db $ff
    db $00

; C: sprite list with flip: bc = origin; hl = list
Run_DrawMeta::
    push af                                       ; $711F
    push bc                                       ; $7120
    ld a, [de]                                    ; $7121
    res 7, a                                      ; $7122
    ld [de], a                                    ; $7124
    sla a                                         ; $7125
    ld c, a                                       ; $7127
    ld b, $00                                     ; $7128
    add hl, bc                                    ; $712A
    ld a, [hl+]                                   ; $712B
    pop bc                                        ; $712C
    and a                                         ; $712D
    ldh [hScratchA], a                            ; $712E
    call nz, Oam_AddMeta_B02_6F16                 ; $7130
    inc de                                        ; $7133
    ld a, [de]                                    ; $7134
    cp [hl]                                       ; $7135
    jr c, jr_009_7146                             ; $7136

    dec de                                        ; $7138
    inc hl                                        ; $7139
    ld a, [hl+]                                   ; $713A
    inc a                                         ; $713B
    ld a, [hl]                                    ; $713C
    jr z, jr_009_7141                             ; $713D

    ld a, [de]                                    ; $713F
    inc a                                         ; $7140

jr_009_7141:
    set 7, a                                      ; $7141
    ld [de], a                                    ; $7143
    inc de                                        ; $7144
    xor a                                         ; $7145

jr_009_7146:
    pop bc                                        ; $7146
    add b                                         ; $7147
    ld [de], a                                    ; $7148
    ldh a, [hScratchA]                            ; $7149
    ret                                           ; $714B


; C: sets the LCD split parameters from the player's vertical offset C: $FFB6 (second split line) := $5A - C, $FFAF
; (first split line) := 8 (C < $17), $1F - C ($17 <= C < $1C), 3 ($1C <= C < $80) or 8 (C >= $80), and $FFBA (scroll Y
; of the band) := list value + C with the animation state in DE (same ...
Run_SplitScreenLine::
    push af                                       ; $714C
    ld a, $5a                                     ; $714D
    sub c                                         ; $714F
    ldh [hSplit2Line], a                          ; $7150
    ld a, c                                       ; $7152
    cp $17                                        ; $7153
    jr nc, jr_009_715b                            ; $7155

    ld a, $08                                     ; $7157
    jr jr_009_716e                                ; $7159

jr_009_715b:
    cp $1c                                        ; $715B
    jr nc, jr_009_7164                            ; $715D

    cpl                                           ; $715F
    add $20                                       ; $7160
    jr jr_009_716e                                ; $7162

jr_009_7164:
    cp $80                                        ; $7164
    jr nc, jr_009_716c                            ; $7166

    ld a, $03                                     ; $7168
    jr jr_009_716e                                ; $716A

jr_009_716c:
    ld a, $08                                     ; $716C

jr_009_716e:
    ldh [hLycShadowSplit1], a                     ; $716E
    push bc                                       ; $7170
    ld a, [de]                                    ; $7171
    sla a                                         ; $7172
    ld c, a                                       ; $7174
    ld b, $00                                     ; $7175
    add hl, bc                                    ; $7177
    ld a, [hl+]                                   ; $7178
    pop bc                                        ; $7179
    add c                                         ; $717A
    ldh [hScyBand1], a                            ; $717B
    inc de                                        ; $717D
    ld a, [de]                                    ; $717E
    cp [hl]                                       ; $717F
    jr c, jr_009_718e                             ; $7180

    dec de                                        ; $7182
    inc hl                                        ; $7183
    ld a, [hl+]                                   ; $7184
    inc a                                         ; $7185
    ld a, [hl]                                    ; $7186
    jr z, jr_009_718b                             ; $7187

    ld a, [de]                                    ; $7189
    inc a                                         ; $718A

jr_009_718b:
    ld [de], a                                    ; $718B
    inc de                                        ; $718C
    xor a                                         ; $718D

jr_009_718e:
    pop bc                                        ; $718E
    add b                                         ; $718F
    ld [de], a                                    ; $7190
    ret                                           ; $7191


; C: visibility test of a half-scale position (A = high byte, C = low byte): returns NC when the position is on screen
; (A = 0 and C < $B0, or A = $FF and C >= $B0), carry set when it is off screen; the callers draw only when NC
; (Run_DrawChick, Run_DrawMoleAndScene, Run_DrawRunner3, Run_DrawFinishLine, ...
Run_OffscreenTest::
    and a                                         ; $7192
    jr z, jr_009_71a0                             ; $7193

    cp $ff                                        ; $7195
    jr nz, jr_009_71a7                            ; $7197

    ld a, c                                       ; $7199
    cp $b0                                        ; $719A
    jr c, jr_009_71a7                             ; $719C

    and a                                         ; $719E
    ret                                           ; $719F


jr_009_71a0:
    ld a, c                                       ; $71A0
    cp $b0                                        ; $71A1
    jr nc, jr_009_71a7                            ; $71A3

    and a                                         ; $71A5
    ret                                           ; $71A6


jr_009_71a7:
    scf                                           ; $71A7
    ret                                           ; $71A8


; C: BCD +$000167 per frame until the player is placed
Run_RaceTimerTick::
    ld a, [wRunState + $29]                       ; $71A9
    cp $99                                        ; $71AC
    jr nz, jr_009_71b6                            ; $71AE

    ld a, [wRunState + $28]                       ; $71B0
    cp $99                                        ; $71B3
    ret z                                         ; $71B5

jr_009_71b6:
    ld hl, wRunState + $27                        ; $71B6
    ld a, $67                                     ; $71B9
    add [hl]                                      ; $71BB
    daa                                           ; $71BC
    ld [hl+], a                                   ; $71BD
    ld a, $01                                     ; $71BE
    adc [hl]                                      ; $71C0
    daa                                           ; $71C1
    ld [hl+], a                                   ; $71C2
    ld a, $00                                     ; $71C3
    adc [hl]                                      ; $71C5
    daa                                           ; $71C6
    ld [hl+], a                                   ; $71C7
    jr nc, jr_009_71d2                            ; $71C8

    ld a, $99                                     ; $71CA
    ld [wRunState + $28], a                       ; $71CC
    ld [wRunState + $29], a                       ; $71CF

jr_009_71d2:
    ld de, $8b40                                  ; $71D2
    ld a, [wRunState + $29]                       ; $71D5
    call Run_DrawTimerDigit                       ; $71D8
    ld a, [wRunState + $28]                       ; $71DB

; C: draws a BCD byte as two digits: for the high nibble then the low nibble it calls Run_DrawTimerDigitB (C)
Run_DrawTimerDigit::
    push af                                       ; $71DE
    swap a                                        ; $71DF
    and $0f                                       ; $71E1
    call Run_DrawTimerDigitB                      ; $71E3
    pop af                                        ; $71E6
    and $0f                                       ; $71E7

; C: copies the 32 bytes of the digit (nibble x 32) from 1B:6E80 to VRAM at DE (Vram_CopyFromBank) (C)
Run_DrawTimerDigitB::
    swap a                                        ; $71E9
    ld c, a                                       ; $71EB
    ld b, $00                                     ; $71EC
    sla c                                         ; $71EE
    rl b                                          ; $71F0
    ld hl, Gfx_1B_6E80_Run_DrawTimerDigitB        ; $71F2
    add hl, bc                                    ; $71F5
    ld a, BANK(Gfx_1B_6E80_Run_DrawTimerDigitB)   ; $71F6
    ld bc, $0020                                  ; $71F8
    call Vram_CopyFromBank                        ; $71FB
    ret                                           ; $71FE


; I: toggle D9F9
Run_LoadCharacterGraphicsA::
    ld a, [wPickGfxToggle21]                      ; $71FF
    inc a                                         ; $7202
    and $01                                       ; $7203
    ld [wPickGfxToggle21], a                      ; $7205
    call Run_CharacterToGfxIndex                  ; $7208
    push af                                       ; $720B
    ld c, $00                                     ; $720C
    ldh [hFarcallAArg], a                         ; $720E
    ld a, BANK(Album_LoadNumeralTileB)            ; $7210
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7212
    call Far_Call                                 ; $7215
    ld de, $9000                                  ; $7218
    ld bc, $0380                                  ; $721B
    call Mem_CopyFromBank                         ; $721E
    pop af                                        ; $7221
    push af                                       ; $7222
    ld c, $01                                     ; $7223
    ldh [hFarcallAArg], a                         ; $7225
    ld a, BANK(Album_LoadNumeralTileB)            ; $7227
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7229
    call Far_Call                                 ; $722C
    ld de, $9380                                  ; $722F
    ld bc, $0380                                  ; $7232
    call Mem_CopyFromBank                         ; $7235
    pop af                                        ; $7238
    ld c, $02                                     ; $7239
    ldh [hFarcallAArg], a                         ; $723B
    ld a, BANK(Album_LoadNumeralTileB)            ; $723D
    ld hl, Album_LoadNumeralTileB_7CE3            ; $723F
    call Far_Call                                 ; $7242
    push af                                       ; $7245
    ld de, $9700                                  ; $7246
    ld bc, $0100                                  ; $7249
    call Mem_CopyFromBank                         ; $724C
    pop af                                        ; $724F
    ld de, $8800                                  ; $7250
    ld bc, $0280                                  ; $7253
    call Mem_CopyFromBank                         ; $7256
    ret                                           ; $7259


; I: far 05:7F69
Run_LoadCharacterGraphicsB::
    call Run_CharacterToGfxIndex                  ; $725A
    ldh [hFarcallAArg], a                         ; $725D
    ld a, BANK(Album_LoadNumeralTileB)            ; $725F
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7261
    call Far_Call                                 ; $7264
    ld de, $9000                                  ; $7267
    ld bc, $0380                                  ; $726A
    call Vram_CopyFromBank_4                      ; $726D
    ret                                           ; $7270


; I: far 05:7F69
Run_LoadCharacterGraphicsC::
    call Run_CharacterToGfxIndex                  ; $7271
    ldh [hFarcallAArg], a                         ; $7274
    ld a, BANK(Album_LoadNumeralTileB)            ; $7276
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7278
    call Far_Call                                 ; $727B
    ld de, $9380                                  ; $727E
    ld bc, $0380                                  ; $7281
    call Vram_CopyFromBank_4                      ; $7284
    ret                                           ; $7287


; I: UNREFERENCED: twin of 09:7206
Unused_Run_LoadCharacterGraphicsD::
    call Run_CharacterToGfxIndex                  ; $7288
    ldh [hFarcallAArg], a                         ; $728B
    ld a, BANK(Album_LoadNumeralTileB)            ; $728D
    ld hl, Album_LoadNumeralTileB_7CE3            ; $728F
    call Far_Call                                 ; $7292
    push af                                       ; $7295
    ld de, $9700                                  ; $7296
    ld bc, $0100                                  ; $7299
    call Vram_CopyFromBank_4                      ; $729C
    pop af                                        ; $729F
    ld de, $8800                                  ; $72A0
    ld bc, $0280                                  ; $72A3
    call Vram_CopyFromBank_4                      ; $72A6
    ret                                           ; $72A9


; C: graphics index of the selected character: A = $D9F8 (0-2); when it is 2 and bit 0 of $D581 (Game Face) is clear,
; $D9F9 is used instead; the index is Run_CharacterToGfxIndex_Tbl725B[A] (C)
Run_CharacterToGfxIndex::
    push bc                                       ; $72AA
    ld a, [wPickCharacter21]                      ; $72AB
    cp $02                                        ; $72AE
    jr nz, jr_009_72bc                            ; $72B0

    ld hl, wGamefacePresent                       ; $72B2
    bit 0, [hl]                                   ; $72B5
    jr nz, jr_009_72bc                            ; $72B7

    ld a, [wPickGfxToggle21]                      ; $72B9

jr_009_72bc:
    ld c, a                                       ; $72BC
    ld b, $00                                     ; $72BD
    ld hl, Run_CharacterToGfxIndex_Tbl72C6        ; $72BF
    add hl, bc                                    ; $72C2
    ld a, [hl]                                    ; $72C3
    pop bc                                        ; $72C4
    ret                                           ; $72C5


; I: 3 graphics indices 00 05 06 for the characters 0, 1, 2 (C)
Run_CharacterToGfxIndex_Tbl72C6::
    db $06, $03, $08

; C: time vs record DAA6/7 (nine complement)
Run_CompareRecord::
    ld de, wRunState + $29                        ; $72C9
    ld hl, wBestRun + $1                          ; $72CC
    ld b, $02                                     ; $72CF

jr_009_72d1:
    ld a, [de]                                    ; $72D1
    cpl                                           ; $72D2
    add $9a                                       ; $72D3
    cp [hl]                                       ; $72D5
    ret c                                         ; $72D6

    jr nz, jr_009_72df                            ; $72D7

    dec de                                        ; $72D9
    dec hl                                        ; $72DA
    dec b                                         ; $72DB
    jr nz, jr_009_72d1                            ; $72DC

    ret                                           ; $72DE


jr_009_72df:
    ld de, wRunState + $28                        ; $72DF
    ld hl, wBestRun                               ; $72E2
    ld b, $02                                     ; $72E5

jr_009_72e7:
    ld a, [de]                                    ; $72E7
    cpl                                           ; $72E8
    add $9a                                       ; $72E9
    ld [hl+], a                                   ; $72EB
    inc de                                        ; $72EC
    dec b                                         ; $72ED
    jr nz, jr_009_72e7                            ; $72EE

    ldh [hFarcallAArg], a                         ; $72F0
    farcall Counters_Store_Far                    ; $72F2
    ret                                           ; $72FA


; C: shared result / error screen (3 substates); Totaka tune 1 in 3
ResultScreen_Far::
    ld a, [wSubstate]                             ; $72FB
    rst Rst18_JumpTable                           ; $72FE

; I
ResultScreen_SubstateTbl::
    dw ResultScreen_Substate0_Init
    dw ResultScreen_Substate1_WaitKey
    dw ResultScreen_Substate2_Exit

; I
ResultScreen_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7305
    ldh [hLcdcShadow], a                          ; $7307
    ld a, $e4                                     ; $7309
    ld [wPaletteTarget], a                        ; $730B
    ld [wPaletteTarget + $1], a                   ; $730E
    ld a, $d2                                     ; $7311
    ld [wPaletteTarget + $2], a                   ; $7313
    xor a                                         ; $7316
    ldh [hScxShadow], a                           ; $7317
    ldh [hScyShadow], a                           ; $7319
    call ResultScreen_ChoosePicture               ; $731B
    push af                                       ; $731E
    ld c, a                                       ; $731F
    sla a                                         ; $7320
    add c                                         ; $7322
    ld c, a                                       ; $7323
    ld b, $00                                     ; $7324
    ld hl, ResultScreen_PictureTbl                ; $7326
    add hl, bc                                    ; $7329
    ld c, [hl]                                    ; $732A
    inc hl                                        ; $732B
    ld b, [hl]                                    ; $732C
    inc hl                                        ; $732D
    ld a, [hl]                                    ; $732E
    ld h, b                                       ; $732F
    ld l, c                                       ; $7330
    ld de, $9000                                  ; $7331
    ld bc, $0800                                  ; $7334
    push af                                       ; $7337
    call Mem_CopyFromBank                         ; $7338
    pop af                                        ; $733B
    ld de, $8800                                  ; $733C
    ld bc, $0100                                  ; $733F
    push af                                       ; $7342
    call Mem_CopyFromBank                         ; $7343
    pop af                                        ; $7346
    ld de, $8000                                  ; $7347
    ld bc, $0500                                  ; $734A
    call Mem_CopyFromBank                         ; $734D
    ld hl, $8ff0                                  ; $7350
    ld bc, $0010                                  ; $7353
    ld de, $ffff                                  ; $7356
    call Mem_FillWords                            ; $7359
    farcopy Mem_CopyFromBank, Map_26_4C80_ResultScreen_Substate0_Init, $9800, $0240 ; $735C
    call ResultScreen_LoadMessage                 ; $736A
    ld a, $54                                     ; $736D
    ldh [hLycShadowSplit1], a                     ; $736F
    ldh [hSplit1Latch], a                         ; $7371
    ld hl, hStatShadow                            ; $7373
    set 6, [hl]                                   ; $7376
    ld hl, rIE                                    ; $7378
    set 1, [hl]                                   ; $737B
    ld a, $01                                     ; $737D
    ldh [hStatHandlerIndex], a                    ; $737F
    screen_on                                     ; $7381
    pop af                                        ; $738A
    ld hl, ResultScreen_Substate0_Init_Tbl73A7    ; $738B
    call Snd_PlayFromList                         ; $738E
    call Pal_FadeIn                               ; $7391
    ld hl, wSubstate                              ; $7394
    inc [hl]                                      ; $7397
    jp Far_Call_Return                            ; $7398


; C: 3-byte {ptr; bank}; tiles to $9000 / $8800 / $8000
ResultScreen_PictureTbl::
    dwb Gfx_1E_4E00_ResultPic0_HornedMan_Tune28
    dwb Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka
    dwb Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30
    dwb Gfx_1D_4F00_ResultPic3_Equator_Tune2A

; C: auto: 8 bytes, bytes; referenced by ResultScreen_Substate0_Init. L3 pass 2026-10-26: read in BGB in 31 replay(s)
; of the organic corpus, modes 01 14 17 1D (tcrf_check/assets/l3_names/)
ResultScreen_Substate0_Init_Tbl73A7::
    db MUSIC_WHO_ARE_YOU_RUNNING_FROM_1, SNDCH_MUSIC  ; #1
    db MUSIC_TOTAKA_TUNE, SNDCH_MUSIC  ; #2
    db MUSIC_WHO_ARE_YOU_RUNNING_FROM_2, SNDCH_MUSIC  ; #3
    db MUSIC_JAMBO_NINTENDO, SNDCH_MUSIC  ; #4

; C: id $0E forces picture 3; else random of 3
ResultScreen_ChoosePicture::
    ld a, [wResultMsgId]                          ; $73AF
    cp $0e                                        ; $73B2
    jr nz, jr_009_73b9                            ; $73B4

    ld a, $03                                     ; $73B6
    ret                                           ; $73B8


jr_009_73b9:
    call Rng_Next                                 ; $73B9
    ld l, $03                                     ; $73BC
    call Math_MulAL                               ; $73BE
    ld a, h                                       ; $73C1
    ret                                           ; $73C2


; C
ResultScreen_Substate1_WaitKey::
    ldh a, [hKeysNew]                             ; $73C3
    and PADF_A | PADF_B                           ; $73C5
    jp z, Far_Call_Return                         ; $73C7

    ld hl, wSubstate                              ; $73CA
    inc [hl]                                      ; $73CD
    jp Far_Call_Return                            ; $73CE


; C
ResultScreen_Substate2_Exit::
    screen_off                                    ; $73D1
    stat_irq_off                                  ; $73D7
    next_state                                    ; $73E1
    jp Far_Call_Return                            ; $73E5


; C: message table 09:739E; 3 bytes per entry
ResultScreen_LoadMessage::
    ld a, [wResultMsgId]                          ; $73E8
    ld c, a                                       ; $73EB
    sla a                                         ; $73EC
    add c                                         ; $73EE
    ld c, a                                       ; $73EF
    ld b, $00                                     ; $73F0
    ld hl, ResultScreen_MessageTbl                ; $73F2
    add hl, bc                                    ; $73F5
    ld c, [hl]                                    ; $73F6
    inc hl                                        ; $73F7
    ld b, [hl]                                    ; $73F8
    inc hl                                        ; $73F9
    ld a, [hl]                                    ; $73FA
    ld h, b                                       ; $73FB
    ld l, c                                       ; $73FC
    ld de, $8900                                  ; $73FD
    ld bc, $0280                                  ; $7400
    call Mem_CopyFromBank                         ; $7403
    ret                                           ; $7406


; I
ResultScreen_MessageTbl::
    dwb Gfx_28_4000_MsgStripB
    dwb Gfx_28_4280_MsgStripB
    dwb Gfx_28_4500_MsgStripB
    dwb Gfx_28_4780_MsgStripB
    dwb Gfx_28_4A00_MsgStripB
    dwb Gfx_28_4C80_MsgStripB
    dwb Gfx_28_4F00_MsgStripB
    dwb Gfx_28_5180_MsgStripB
    dwb Gfx_28_5400_MsgStripB
    dwb Gfx_28_5680_MsgStripB
    dwb Gfx_28_5900_MsgStripB
    dwb Gfx_28_5B80_MsgStripB
    dwb Gfx_28_5E00_MsgStripB
    dwb Gfx_0D_5D00_MsgStrip
    dwb Gfx_28_6080_MsgStripB

    ; padding
    ds $bcc, $00

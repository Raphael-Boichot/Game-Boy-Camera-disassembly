; Pocket Camera (Japan) (Rev A), bank $09. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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


; C
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
    cp $10                                        ; $41B2
    ret nz                                        ; $41B4

    ld a, d                                       ; $41B5
    ld [wScrollBufWriteRow], a                    ; $41B6
    ld a, $01                                     ; $41B9
    ld [wScrollSubstate], a                       ; $41BB
    ret                                           ; $41BE


; C
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
    ld hl, $9807                                  ; $41D6
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
    add $10                                       ; $41EE
    add c                                         ; $41F0
    ld c, a                                       ; $41F1
    ld hl, $9807                                  ; $41F2
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

; C
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
    ld [wCmtGridRow], a                           ; $42A3
    ld [wCmtCursor], a                            ; $42A6
    ld [wCmtGridCell], a                          ; $42A9
    ld [wCmtCtrl], a                              ; $42AC
    ld a, $07                                     ; $42AF
    ldh [hWxShadow], a                            ; $42B1
    ld a, $94                                     ; $42B3
    ldh [hWyShadow], a                            ; $42B5
    ldh [hFarcallAArg], a                         ; $42B7
    farcall Owner_Load_Far                        ; $42B9
    ld a, $1b                                     ; $42C1
    ld hl, Gfx_1B_4000_Mode1C_State08_PrintJob    ; $42C3
    ld de, $9000                                  ; $42C6
    ld bc, $0800                                  ; $42C9
    call Mem_CopyFromBank                         ; $42CC
    farcopy Mem_CopyFromBank, Gfx_1B_4800_Mode1C_State08_PrintJob, $8800, $0800 ; $42CF
    farcopy Mem_CopyFromBank, Gfx_1B_5000_CommentEditor_Sub0_Init, $8000, $0030 ; $42DD
    farcopy Mem_CopyFromBank, Map_21_7CC0_CommentEditor_Sub0_Init, $9800, $0240 ; $42EB
    farcopy Mem_CopyFromBank, Map_21_7F00_CommentEditor_Sub0_Init, $9c00, $0100 ; $42F9
    call Oam_ClearShadow                          ; $4307
    call Pal_AllWhite                             ; $430A
    call Lcd_On                                   ; $430D
    ldh [hFarcallAArg], a                         ; $4310
    ld a, $09                                     ; $4312
    ld hl, CommentCard_UploadThumbnail_Far        ; $4314
    call Far_Call                                 ; $4317
    ldh [hFarcallAArg], a                         ; $431A
    ld a, $09                                     ; $431C
    ld hl, CommentCard_DrawComment_Far            ; $431E
    call Far_Call                                 ; $4321
    ldh [hFarcallAArg], a                         ; $4324
    ld a, $09                                     ; $4326
    ld hl, CommentCard_DrawOwnerName_Far          ; $4328
    call Far_Call                                 ; $432B
    ldh [hFarcallAArg], a                         ; $432E
    ld a, $09                                     ; $4330
    ld hl, CommentCard_DrawGender_Far             ; $4332
    call Far_Call                                 ; $4335
    ldh [hFarcallAArg], a                         ; $4338
    ld a, $09                                     ; $433A
    ld hl, CommentCard_DrawBlood_Far              ; $433C
    call Far_Call                                 ; $433F
    ldh [hFarcallAArg], a                         ; $4342
    ld a, $09                                     ; $4344
    ld hl, CommentCard_DrawBirthDate_Far          ; $4346
    call Far_Call                                 ; $4349
    ldh [hFarcallAArg], a                         ; $434C
    ld a, $09                                     ; $434E
    ld hl, CommentCard_DrawCounters_Far           ; $4350
    call Far_Call                                 ; $4353
    ldh [hFarcallAArg], a                         ; $4356
    ld a, $09                                     ; $4358
    ld hl, CommentCard_DrawTotal_Far              ; $435A
    call Far_Call                                 ; $435D
    ldh [hFarcallAArg], a                         ; $4360
    ld a, $09                                     ; $4362
    ld hl, CommentCard_DrawCopyBadge_Far          ; $4364
    call Far_Call                                 ; $4367
    ldh [hFarcallAArg], a                         ; $436A
    ld a, $09                                     ; $436C
    ld hl, CommentCard_DrawPhotoNumber_Far        ; $436E
    call Far_Call                                 ; $4371
    push af                                       ; $4374
    ld a, MUSIC_COMMENT_EDITOR                    ; $4375
    call Snd_Music                                ; $4377
    pop af                                        ; $437A
    call Pal_FadeIn                               ; $437B
    ld hl, wSubstate                              ; $437E
    inc [hl]                                      ; $4381
    jp Far_Call_Return                            ; $4382


; C: Start slides the panel in
CommentEditor_Sub1_SlideIn::
    ldh a, [hKeysNew]                             ; $4385
    bit PADB_START, a                             ; $4387
    jr z, jr_009_4398                             ; $4389

    call CommentEditor_LoadGridPage               ; $438B
    call CommentEditor_SlidePanelIn               ; $438E
    ld hl, wSubstate                              ; $4391
    inc [hl]                                      ; $4394
    jp Far_Call_Return                            ; $4395


jr_009_4398:
    ldh a, [hKeysNew]                             ; $4398
    and PADF_B                                    ; $439A
    jp z, Far_Call_Return                         ; $439C

    ld [wAbResult], a                             ; $439F
    ld a, $03                                     ; $43A2
    ld [wSubstate], a                             ; $43A4
    jp Far_Call_Return                            ; $43A7


; C: character grid; cursor; delete and arrows
CommentEditor_Sub2_Edit::
    call CommentEditor_ReadDirections             ; $43AA
    call CommentEditor_DispatchControl            ; $43AD
    call CommentEditor_DrawGridCursor             ; $43B0
    call CommentEditor_DrawCaret                  ; $43B3
    call CommentEditor_DrawTextCursor             ; $43B6
    ldh a, [hKeysNew]                             ; $43B9
    bit PADB_B, a                                 ; $43BB
    jp z, Far_Call_Return                         ; $43BD

    call Oam_ClearShadow                          ; $43C0
    rst Rst08_WaitVBlank                          ; $43C3
    call CommentEditor_SlidePanelOut              ; $43C4
    ld hl, wSubstate                              ; $43C7
    dec [hl]                                      ; $43CA
    jp Far_Call_Return                            ; $43CB


; C
CommentEditor_Sub3_Exit::
    call Pal_FadeOut                              ; $43CE
    call Lcd_Off                                  ; $43D1
    next_state                                    ; $43D4
    jp Far_Call_Return                            ; $43D8


; C: cmt_ctrl: 0 grid; 1 delete; 2 left; 3 right
CommentEditor_DispatchControl::
    ld a, [wCmtCtrl]                              ; $43DB
    sla a                                         ; $43DE
    ld c, a                                       ; $43E0
    ld b, $00                                     ; $43E1
    ld hl, CommentEditor_ControlJumpTbl           ; $43E3
    add hl, bc                                    ; $43E6
    ld a, [hl+]                                   ; $43E7
    ld h, [hl]                                    ; $43E8
    ld l, a                                       ; $43E9
    jp hl                                         ; $43EA


; C
CommentEditor_ControlJumpTbl::
    dw CommentEditor_CtrlGrid
    dw CommentEditor_CtrlDelete
    dw CommentEditor_CtrlLeft
    dw CommentEditor_CtrlRight

; C: A types the character under the cursor
CommentEditor_CtrlGrid::
    ldh a, [hKeysNew]                             ; $43F3
    bit PADB_A, a                                 ; $43F5
    ret z                                         ; $43F7

    push af                                       ; $43F8
    ld a, SFX1_KEY_A                              ; $43F9
    call Snd_Sfx1                                 ; $43FB
    pop af                                        ; $43FE
    ld a, [wCmtCursor]                            ; $43FF
    ld c, a                                       ; $4402
    ld b, $00                                     ; $4403
    ld hl, wTagComment                            ; $4405
    add hl, bc                                    ; $4408
    ld a, [wCmtGridCell]                          ; $4409
    inc a                                         ; $440C
    ld [hl], a                                    ; $440D
    call CommentEditor_DrawChar                   ; $440E
    jp CommentEditor_StepCursorRight              ; $4411


; C
CommentEditor_CtrlDelete::
    ldh a, [hKeysNewRepeat]                       ; $4414
    bit PADB_A, a                                 ; $4416
    ret z                                         ; $4418

    push af                                       ; $4419
    ld a, SFX1_CURSOR_MOVE                        ; $441A
    call Snd_Sfx1                                 ; $441C
    pop af                                        ; $441F
    ld a, [wCmtCursor]                            ; $4420
    ld c, a                                       ; $4423
    ld b, $00                                     ; $4424
    ld hl, wTagComment                            ; $4426
    add hl, bc                                    ; $4429
    xor a                                         ; $442A
    ld [hl], a                                    ; $442B
    call CommentEditor_DrawChar                   ; $442C
    ld a, [wCmtCursor]                            ; $442F
    and a                                         ; $4432
    ret z                                         ; $4433

    dec a                                         ; $4434
    ld [wCmtCursor], a                            ; $4435
    ret                                           ; $4438


; C: cursor limit $1A
CommentEditor_CtrlRight::
    ldh a, [hKeysNewRepeat]                       ; $4439
    bit PADB_A, a                                 ; $443B
    ret z                                         ; $443D

; C: moves the text cursor $DA91 one place right (limit $1A, sfx $21); the second half of CommentEditor_CtrlRight,
; also reached after a character was typed (branch target; code read 2026-10-19)
CommentEditor_StepCursorRight::
    ld a, [wCmtCursor]                            ; $443E
    cp $1a                                        ; $4441
    ret z                                         ; $4443

    push af                                       ; $4444
    ld a, SFX1_STEP_VALUE                         ; $4445
    call Snd_Sfx1                                 ; $4447
    pop af                                        ; $444A
    inc a                                         ; $444B
    ld [wCmtCursor], a                            ; $444C
    ret                                           ; $444F


; C
CommentEditor_CtrlLeft::
    ldh a, [hKeysNewRepeat]                       ; $4450
    bit PADB_A, a                                 ; $4452
    ret z                                         ; $4454

    ld a, [wCmtCursor]                            ; $4455
    and a                                         ; $4458
    ret z                                         ; $4459

    push af                                       ; $445A
    ld a, SFX1_KEY_B                              ; $445B
    call Snd_Sfx1                                 ; $445D
    pop af                                        ; $4460
    dec a                                         ; $4461
    ld [wCmtCursor], a                            ; $4462
    ret                                           ; $4465


; C: blinking sprite $7D
CommentEditor_DrawTextCursor::
    ldh a, [hFrameCounter]                        ; $4466
    bit 3, a                                      ; $4468
    ret z                                         ; $446A

    ld bc, $0178                                  ; $446B
    ld a, $7d                                     ; $446E
    call Oam_AddMeta_B02_5272                     ; $4470
    ret                                           ; $4473


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentEditor_DrawCaret::
    ld a, [wCmtCursor]                            ; $4474
    ld c, $62                                     ; $4477

jr_009_4479:
    cp $09                                        ; $4479
    jr c, jr_009_4482                             ; $447B

    sub $09                                       ; $447D
    inc c                                         ; $447F
    jr jr_009_4479                                ; $4480

jr_009_4482:
    swap c                                        ; $4482
    sla a                                         ; $4484
    sla a                                         ; $4486
    sla a                                         ; $4488
    add $48                                       ; $448A
    ld b, a                                       ; $448C
    ldh a, [hFrameCounter]                        ; $448D
    and $0f                                       ; $448F
    cp $04                                        ; $4491
    ret c                                         ; $4493

    ld a, $7c                                     ; $4494
    call Oam_AddMeta_B02_5272                     ; $4496
    ret                                           ; $4499


; C
CommentEditor_DrawGridCursor::
    ld a, [wCmtCtrl]                              ; $449A
    and a                                         ; $449D
    jr z, jr_009_44a3                             ; $449E

    dec a                                         ; $44A0
    jr jr_009_44bf                                ; $44A1

jr_009_44a3:
    ld a, [wCmtGridCell]                          ; $44A3
    ld c, $00                                     ; $44A6

jr_009_44a8:
    cp $05                                        ; $44A8
    jr c, jr_009_44b1                             ; $44AA

    sub $05                                       ; $44AC
    inc c                                         ; $44AE
    jr jr_009_44a8                                ; $44AF

jr_009_44b1:
    ld b, a                                       ; $44B1
    ld a, [wCmtGridRow]                           ; $44B2
    cp c                                          ; $44B5
    jr z, jr_009_44bc                             ; $44B6

    ld a, b                                       ; $44B8
    add $05                                       ; $44B9
    ld b, a                                       ; $44BB

jr_009_44bc:
    ld a, b                                       ; $44BC
    add $03                                       ; $44BD

jr_009_44bf:
    sla a                                         ; $44BF
    ld c, a                                       ; $44C1
    ld b, $00                                     ; $44C2
    ld hl, CommentEditor_DrawGridCursor_Tbl44DB   ; $44C4
    add hl, bc                                    ; $44C7
    ld c, [hl]                                    ; $44C8
    inc hl                                        ; $44C9
    ld b, [hl]                                    ; $44CA
    ldh a, [hFrameCounter]                        ; $44CB
    srl a                                         ; $44CD
    srl a                                         ; $44CF
    srl a                                         ; $44D1
    and $01                                       ; $44D3
    add $7a                                       ; $44D5
    call Oam_AddMeta_B02_5272                     ; $44D7
    ret                                           ; $44DA


; C: auto: 26 bytes, bytes; referenced by CommentEditor_DrawGridCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 0A)
CommentEditor_DrawGridCursor_Tbl44DB::
    db $57, $87, $67, $87, $77, $87, $5c, $0f, $5c, $27, $5c, $3f, $5c, $57, $5c, $6f
    db $75, $0f, $75, $27, $75, $3f, $75, $57, $75, $6f

; C: moves the grid cursor; scrolls the grid page
CommentEditor_ReadDirections::
    ldh a, [hKeysNewRepeat]                       ; $44F5
    ld b, a                                       ; $44F7
    ld a, [wCmtCtrl]                              ; $44F8
    and a                                         ; $44FB
    jr z, jr_009_452f                             ; $44FC

    bit 5, b                                      ; $44FE
    jr z, jr_009_450c                             ; $4500

    push af                                       ; $4502
    ld a, SFX1_DIRECTION_KEY                      ; $4503
    call Snd_Sfx1                                 ; $4505
    pop af                                        ; $4508
    xor a                                         ; $4509
    jr jr_009_452b                                ; $450A

jr_009_450c:
    bit 6, b                                      ; $450C
    jr z, jr_009_451d                             ; $450E

    cp $01                                        ; $4510
    ret z                                         ; $4512

    push af                                       ; $4513
    ld a, SFX1_DIRECTION_KEY                      ; $4514
    call Snd_Sfx1                                 ; $4516
    pop af                                        ; $4519
    dec a                                         ; $451A
    jr jr_009_452b                                ; $451B

jr_009_451d:
    bit 7, b                                      ; $451D
    ret z                                         ; $451F

    cp $03                                        ; $4520
    ret z                                         ; $4522

    push af                                       ; $4523
    ld a, SFX1_DIRECTION_KEY                      ; $4524
    call Snd_Sfx1                                 ; $4526
    pop af                                        ; $4529
    inc a                                         ; $452A

jr_009_452b:
    ld [wCmtCtrl], a                              ; $452B
    ret                                           ; $452E


jr_009_452f:
    ld c, $00                                     ; $452F
    ld a, [wCmtGridCell]                          ; $4531

jr_009_4534:
    cp $05                                        ; $4534
    jr c, jr_009_453d                             ; $4536

    sub $05                                       ; $4538
    inc c                                         ; $453A
    jr jr_009_4534                                ; $453B

jr_009_453d:
    cp $04                                        ; $453D
    jr nz, jr_009_4552                            ; $453F

    bit 4, b                                      ; $4541
    jr z, jr_009_4552                             ; $4543

    push af                                       ; $4545
    ld a, SFX1_DIRECTION_KEY                      ; $4546
    call Snd_Sfx1                                 ; $4548
    pop af                                        ; $454B
    ld a, $01                                     ; $454C
    ld [wCmtCtrl], a                              ; $454E
    ret                                           ; $4551


jr_009_4552:
    and a                                         ; $4552
    jr nz, jr_009_4558                            ; $4553

    bit 5, b                                      ; $4555
    ret nz                                        ; $4557

jr_009_4558:
    ld a, [wCmtGridCell]                          ; $4558
    bit 5, b                                      ; $455B
    jr z, jr_009_4562                             ; $455D

    dec a                                         ; $455F
    jr jr_009_4582                                ; $4560

jr_009_4562:
    bit 4, b                                      ; $4562
    jr z, jr_009_4569                             ; $4564

    inc a                                         ; $4566
    jr jr_009_4582                                ; $4567

jr_009_4569:
    bit 6, b                                      ; $4569
    jr z, jr_009_4577                             ; $456B

    cp $05                                        ; $456D
    ret c                                         ; $456F

    sub $05                                       ; $4570
    call CommentEditor_GridRowUp                  ; $4572
    jr jr_009_4582                                ; $4575

jr_009_4577:
    bit 7, b                                      ; $4577
    ret z                                         ; $4579

    cp $f0                                        ; $457A
    ret nc                                        ; $457C

    add $05                                       ; $457D
    call CommentEditor_GridRowDown                ; $457F

jr_009_4582:
    ld hl, wCmtGridCell                           ; $4582
    cp [hl]                                       ; $4585
    ret z                                         ; $4586

    ld [hl], a                                    ; $4587
    push af                                       ; $4588
    ld a, SFX1_DIRECTION_KEY                      ; $4589
    call Snd_Sfx1                                 ; $458B
    pop af                                        ; $458E
    ret                                           ; $458F


; C
CommentEditor_GridRowUp::
    push af                                       ; $4590
    ld a, [wCmtGridRow]                           ; $4591
    cp c                                          ; $4594
    jr nz, jr_009_459e                            ; $4595

    dec a                                         ; $4597
    ld [wCmtGridRow], a                           ; $4598
    call CommentEditor_LoadGridPage               ; $459B

jr_009_459e:
    pop af                                        ; $459E
    ret                                           ; $459F


; C
CommentEditor_GridRowDown::
    push af                                       ; $45A0
    ld a, [wCmtGridRow]                           ; $45A1
    cp c                                          ; $45A4
    jr z, jr_009_45ae                             ; $45A5

    inc a                                         ; $45A7
    ld [wCmtGridRow], a                           ; $45A8
    call CommentEditor_LoadGridPage               ; $45AB

jr_009_45ae:
    pop af                                        ; $45AE
    ret                                           ; $45AF


; C: far: $CE00 thumbnail to VRAM $9600
CommentCard_UploadThumbnail_Far::
    ld a, $00                                     ; $45B0
    ld hl, wThumbnail                             ; $45B2
    ld de, $9600                                  ; $45B5
    ld bc, $00c8                                  ; $45B8
    call Vram_CopyFromBankAuto                    ; $45BB
    ld a, $00                                     ; $45BE
    ld hl, wThumbnail + $d0                       ; $45C0
    ld de, $96d0                                  ; $45C3
    ld bc, $0008                                  ; $45C6
    call Vram_CopyFromBankAuto                    ; $45C9
    ld a, $00                                     ; $45CC
    ld hl, wThumbnail + $e0                       ; $45CE
    ld de, $96e0                                  ; $45D1
    ld bc, $0008                                  ; $45D4
    call Vram_CopyFromBankAuto                    ; $45D7
    ld a, $00                                     ; $45DA
    ld hl, wThumbnail + $f0                       ; $45DC
    ld de, $96f0                                  ; $45DF
    ld bc, $0008                                  ; $45E2
    call Vram_CopyFromBankAuto                    ; $45E5
    jp Far_Call_Return                            ; $45E8


; C
CommentEditor_DrawChar::
    ld a, [wCmtCursor]                            ; $45EB
    ld c, a                                       ; $45EE
    ld b, $00                                     ; $45EF
    ld hl, wTagComment                            ; $45F1
    add hl, bc                                    ; $45F4
    ld a, [hl]                                    ; $45F5
    push af                                       ; $45F6
    ld a, [wCmtCursor]                            ; $45F7
    swap a                                        ; $45FA
    push af                                       ; $45FC
    and $f0                                       ; $45FD
    ld c, a                                       ; $45FF
    pop af                                        ; $4600
    and $0f                                       ; $4601
    ld b, a                                       ; $4603
    sla c                                         ; $4604
    rl b                                          ; $4606
    ld hl, $9700                                  ; $4608
    add hl, bc                                    ; $460B
    ld d, h                                       ; $460C
    ld e, l                                       ; $460D
    bit 3, d                                      ; $460E
    jr z, jr_009_4614                             ; $4610

    res 4, d                                      ; $4612

jr_009_4614:
    pop af                                        ; $4614
    ld c, $2a                                     ; $4615
    ld hl, ScrollEngine_Step                      ; $4617
    call Glyph_LoadFromCharCode                   ; $461A
    ret                                           ; $461D


; C: far: tag_comment to $9700
CommentCard_DrawComment_Far::
    ld hl, wTagComment                            ; $461E
    ld de, $9700                                  ; $4621
    ld b, $1e                                     ; $4624

jr_009_4626:
    push bc                                       ; $4626
    ld a, [hl+]                                   ; $4627
    push hl                                       ; $4628
    ld c, $2a                                     ; $4629
    ld hl, ScrollEngine_Step                      ; $462B
    call Glyph_LoadFromCharCode                   ; $462E
    bit 3, d                                      ; $4631
    jr z, jr_009_4637                             ; $4633

    res 4, d                                      ; $4635

jr_009_4637:
    pop hl                                        ; $4637
    pop bc                                        ; $4638
    dec b                                         ; $4639
    jr nz, jr_009_4626                            ; $463A

    jp Far_Call_Return                            ; $463C


; C: far
CommentCard_DrawGender_Far::
    ld a, [wTagGenderBlood]                       ; $463F
    and $03                                       ; $4642
    swap a                                        ; $4644
    ld c, a                                       ; $4646
    ld b, $00                                     ; $4647
    sla c                                         ; $4649
    sla c                                         ; $464B
    ld hl, $56d0                                  ; $464D
    add hl, bc                                    ; $4650
    ld a, $21                                     ; $4651
    ld de, $8b80                                  ; $4653
    ld bc, $0040                                  ; $4656
    call Vram_CopyFromBankAuto                    ; $4659
    jp Far_Call_Return                            ; $465C


; C: far
CommentCard_DrawBlood_Far::
    ld a, [wTagGenderBlood]                       ; $465F
    srl a                                         ; $4662
    srl a                                         ; $4664
    and $07                                       ; $4666
    swap a                                        ; $4668
    ld c, a                                       ; $466A
    ld b, $00                                     ; $466B
    sla c                                         ; $466D
    rl b                                          ; $466F
    sla c                                         ; $4671
    rl b                                          ; $4673
    ld hl, $54e0                                  ; $4675
    add hl, bc                                    ; $4678
    ld a, $21                                     ; $4679
    ld de, $9450                                  ; $467B
    ld bc, $0040                                  ; $467E
    call Vram_CopyFromBankAuto                    ; $4681
    jp Far_Call_Return                            ; $4684


; C: far: year; month; day
CommentCard_DrawBirthDate_Far::
    ld de, $93d0                                  ; $4687
    ld hl, wTagBirth                              ; $468A
    ld b, $02                                     ; $468D
    call CommentCard_DrawNumber                   ; $468F
    ld hl, wTagBirth + $2                         ; $4692
    ld b, $01                                     ; $4695
    call CommentCard_DrawNumber                   ; $4697
    ld hl, wTagBirth + $3                         ; $469A
    ld b, $01                                     ; $469D
    call CommentCard_DrawNumber                   ; $469F
    jp Far_Call_Return                            ; $46A2


; C: placeholder when all bytes are 0
CommentCard_DrawNumber::
    push bc                                       ; $46A5
    push hl                                       ; $46A6
    xor a                                         ; $46A7

jr_009_46a8:
    or [hl]                                       ; $46A8
    inc hl                                        ; $46A9
    dec b                                         ; $46AA
    jr nz, jr_009_46a8                            ; $46AB

    pop hl                                        ; $46AD
    pop bc                                        ; $46AE
    and a                                         ; $46AF
    jp nz, CommentCard_DrawNumber_NonZero         ; $46B0

    sla b                                         ; $46B3

jr_009_46b5:
    push bc                                       ; $46B5
    ld hl, $56c0                                  ; $46B6
    ld a, $21                                     ; $46B9
    ld bc, $0010                                  ; $46BB
    call Vram_CopyFromBankAuto                    ; $46BE
    pop bc                                        ; $46C1
    dec b                                         ; $46C2
    jr nz, jr_009_46b5                            ; $46C3

    ret                                           ; $46C5


; C: far: tag_count_a / b as two digits
CommentCard_DrawCounters_Far::
    ld de, $95c0                                  ; $46C6
    ld a, [wTagCountA]                            ; $46C9
    call CommentCard_DivMod10                     ; $46CC
    push af                                       ; $46CF
    ld a, c                                       ; $46D0
    call CommentCard_DrawDigit                    ; $46D1
    pop af                                        ; $46D4
    call CommentCard_DrawDigit                    ; $46D5
    ld a, [wTagCountB]                            ; $46D8
    call CommentCard_DivMod10                     ; $46DB
    push af                                       ; $46DE
    ld a, c                                       ; $46DF
    call CommentCard_DrawDigit                    ; $46E0
    pop af                                        ; $46E3
    call CommentCard_DrawDigit                    ; $46E4
    jp Far_Call_Return                            ; $46E7


; C: A -> C = tens; A = units
CommentCard_DivMod10::
    ld c, $00                                     ; $46EA

jr_009_46ec:
    cp $0a                                        ; $46EC
    ret c                                         ; $46EE

    sub $0a                                       ; $46EF
    inc c                                         ; $46F1
    jr jr_009_46ec                                ; $46F2

; C
CommentCard_DrawDigit::
    swap a                                        ; $46F4
    ld c, a                                       ; $46F6
    ld b, $00                                     ; $46F7
    ld hl, $5080                                  ; $46F9
    add hl, bc                                    ; $46FC
    ld a, $21                                     ; $46FD
    ld bc, $0010                                  ; $46FF
    call Vram_CopyFromBankAuto                    ; $4702
    ret                                           ; $4705


; C: far: tag_count_total
CommentCard_DrawTotal_Far::
    ld de, $9390                                  ; $4706
    ld hl, $53a0                                  ; $4709
    ld a, [wTagCountTotal]                        ; $470C
    ld c, $00                                     ; $470F

jr_009_4711:
    cp $0a                                        ; $4711
    jr c, jr_009_471a                             ; $4713

    sub $0a                                       ; $4715
    inc c                                         ; $4717
    jr jr_009_4711                                ; $4718

jr_009_471a:
    push af                                       ; $471A
    ld a, [wTagCopyFlag]                          ; $471B
    and a                                         ; $471E
    jr nz, jr_009_4724                            ; $471F

    ld hl, $5120                                  ; $4721

jr_009_4724:
    ld a, c                                       ; $4724
    call CommentCard_DrawDigitB                   ; $4725
    ld a, [wTagCopyFlag]                          ; $4728
    and a                                         ; $472B
    jr nz, jr_009_4731                            ; $472C

    ld hl, $5260                                  ; $472E

jr_009_4731:
    pop af                                        ; $4731
    call CommentCard_DrawDigitB                   ; $4732
    jp Far_Call_Return                            ; $4735


; C
CommentCard_DrawDigitB::
    push hl                                       ; $4738
    swap a                                        ; $4739
    ld c, a                                       ; $473B
    ld b, $00                                     ; $473C
    sla c                                         ; $473E
    rl b                                          ; $4740
    add hl, bc                                    ; $4742
    ld a, $21                                     ; $4743
    ld bc, $0020                                  ; $4745
    call Vram_CopyFromBankAuto                    ; $4748
    pop hl                                        ; $474B
    ret                                           ; $474C


; C: far: tag_copy_flag chooses tile set
CommentCard_DrawCopyBadge_Far::
    ld a, [wTagCopyFlag]                          ; $474D
    and a                                         ; $4750
    jr z, jr_009_4764                             ; $4751

    farcopy Vram_CopyFromBankAuto, Gfx_21_5870_CommentCard_DrawCopyBadge_Far, $92b0, $00e0 ; $4753
    jp Far_Call_Return                            ; $4761


jr_009_4764:
    ld a, $21                                     ; $4764
    ld hl, Gfx_21_5790_CommentCard_DrawCopyBadge_Far ; $4766
    ld de, $92b0                                  ; $4769
    ld bc, $00e0                                  ; $476C
    call Vram_CopyFromBankAuto                    ; $476F
    jp Far_Call_Return                            ; $4772


; C: far
CommentCard_DrawPhotoNumber_Far::
    ld de, $9540                                  ; $4775
    ld a, [wCmtPhotoIndex]                        ; $4778
    cp $1e                                        ; $477B
    jr c, jr_009_4781                             ; $477D

    sub $1e                                       ; $477F

jr_009_4781:
    inc a                                         ; $4781
    ld c, $00                                     ; $4782

jr_009_4784:
    cp $0a                                        ; $4784
    jr c, jr_009_478d                             ; $4786

    sub $0a                                       ; $4788
    inc c                                         ; $478A
    jr jr_009_4784                                ; $478B

jr_009_478d:
    push af                                       ; $478D
    ld a, c                                       ; $478E
    ld hl, $4d00                                  ; $478F
    call CommentCard_DrawDigitC                   ; $4792
    pop af                                        ; $4795
    ld hl, $4e00                                  ; $4796
    call CommentCard_DrawDigitC                   ; $4799
    jp Far_Call_Return                            ; $479C


; C
CommentCard_DrawDigitC::
    swap a                                        ; $479F
    ld c, a                                       ; $47A1
    ld b, $00                                     ; $47A2
    sla c                                         ; $47A4
    rl b                                          ; $47A6
    sla c                                         ; $47A8
    rl b                                          ; $47AA
    add hl, bc                                    ; $47AC
    ld a, $21                                     ; $47AD
    ld bc, $0040                                  ; $47AF
    call Vram_CopyFromBankAuto                    ; $47B2
    ret                                           ; $47B5


; C: far: tag_owner_name
CommentCard_DrawOwnerName_Far::
    ld hl, wTagOwnerName                          ; $47B6
    ld de, $8a60                                  ; $47B9
    ld b, $09                                     ; $47BC

jr_009_47be:
    push bc                                       ; $47BE
    ld a, [hl+]                                   ; $47BF
    push hl                                       ; $47C0
    ld c, $2a                                     ; $47C1
    ld hl, $6000                                  ; $47C3
    call Glyph_LoadFromCharCode                   ; $47C6
    pop hl                                        ; $47C9
    pop bc                                        ; $47CA
    dec b                                         ; $47CB
    jr nz, jr_009_47be                            ; $47CC

    jp Far_Call_Return                            ; $47CE


; C: taken when some byte of the number is non-zero: draws the B bytes at HL one after the other with
; CommentCard_DrawHalfByte (branch target; code read 2026-10-19)
CommentCard_DrawNumber_NonZero::
    ld a, [hl+]                                   ; $47D1
    call CommentCard_DrawHalfByte                 ; $47D2
    dec b                                         ; $47D5
    jr nz, CommentCard_DrawNumber_NonZero         ; $47D6

    ret                                           ; $47D8


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentCard_DrawHalfByte::
    push bc                                       ; $47D9
    push hl                                       ; $47DA
    push af                                       ; $47DB
    swap a                                        ; $47DC
    and $0f                                       ; $47DE
    call CommentCard_DrawNibble                   ; $47E0
    pop af                                        ; $47E3
    and $0f                                       ; $47E4
    call CommentCard_DrawNibble                   ; $47E6
    pop hl                                        ; $47E9
    pop bc                                        ; $47EA
    ret                                           ; $47EB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
CommentCard_DrawNibble::
    and a                                         ; $47EC
    jr z, jr_009_47f0                             ; $47ED

    dec a                                         ; $47EF

jr_009_47f0:
    swap a                                        ; $47F0
    ld c, a                                       ; $47F2
    ld b, $00                                     ; $47F3
    ld hl, $5620                                  ; $47F5
    add hl, bc                                    ; $47F8
    ld a, $21                                     ; $47F9
    ld bc, $0010                                  ; $47FB
    call Vram_CopyFromBankAuto                    ; $47FE
    ret                                           ; $4801


; C: character code to glyph (bank in C): copies 32 B from HL + (A - 1) x 32 to DE (HL = font base: $4000 = the
; 256-slot font, $6000 = the small-kana table); advances DE via Vram_CopyFromBankAuto
Glyph_LoadFromCharCode::
    push bc                                       ; $4802
    dec a                                         ; $4803
    swap a                                        ; $4804
    push af                                       ; $4806
    and $f0                                       ; $4807
    ld c, a                                       ; $4809
    pop af                                        ; $480A
    and $0f                                       ; $480B
    ld b, a                                       ; $480D
    sla c                                         ; $480E
    rl b                                          ; $4810
    add hl, bc                                    ; $4812
    pop bc                                        ; $4813
    ld a, c                                       ; $4814
    ld bc, $0020                                  ; $4815
    call Vram_CopyFromBankAuto                    ; $4818
    ret                                           ; $481B


; C: sound $12; WY delta table
CommentEditor_SlidePanelOut::
    push af                                       ; $481C
    ld a, SFX1_PANEL_OPEN                         ; $481D
    call Snd_Sfx1                                 ; $481F
    pop af                                        ; $4822
    ld hl, Slide_WyDeltaTbl                       ; $4823
    ld b, $24                                     ; $4826

jr_009_4828:
    push bc                                       ; $4828
    push hl                                       ; $4829
    ldh a, [hWyShadow]                            ; $482A
    add [hl]                                      ; $482C
    ldh [hWyShadow], a                            ; $482D
    rst Rst08_WaitVBlank                          ; $482F
    pop hl                                        ; $4830
    pop bc                                        ; $4831
    inc hl                                        ; $4832
    ld a, b                                       ; $4833
    cp $1d                                        ; $4834
    jr c, jr_009_483d                             ; $4836

    ldh a, [hScyShadow]                           ; $4838
    dec a                                         ; $483A
    ldh [hScyShadow], a                           ; $483B

jr_009_483d:
    dec b                                         ; $483D
    jr nz, jr_009_4828                            ; $483E

    ret                                           ; $4840


; C: sound $13
CommentEditor_SlidePanelIn::
    push af                                       ; $4841
    ld a, SFX1_PANEL_CLOSE                        ; $4842
    call Snd_Sfx1                                 ; $4844
    pop af                                        ; $4847
    ld hl, Slide_WyDeltaTbl                       ; $4848
    ld b, $24                                     ; $484B

jr_009_484d:
    push bc                                       ; $484D
    push hl                                       ; $484E
    ldh a, [hWyShadow]                            ; $484F
    sub [hl]                                      ; $4851
    ldh [hWyShadow], a                            ; $4852
    rst Rst08_WaitVBlank                          ; $4854
    pop hl                                        ; $4855
    pop bc                                        ; $4856
    inc hl                                        ; $4857
    ld a, b                                       ; $4858
    cp $1d                                        ; $4859
    jr c, jr_009_4862                             ; $485B

    ldh a, [hScyShadow]                           ; $485D
    inc a                                         ; $485F
    ldh [hScyShadow], a                           ; $4860

jr_009_4862:
    dec b                                         ; $4862
    jr nz, jr_009_484d                            ; $4863

    ret                                           ; $4865


; C: $A0 * page bytes from 2A:4000 to $8E60
CommentEditor_LoadGridPage::
    ld a, [wCmtGridRow]                           ; $4866
    ld bc, $00a0                                  ; $4869
    ld hl, ScrollEngine_Step                      ; $486C
    and a                                         ; $486F
    jr z, jr_009_4876                             ; $4870

jr_009_4872:
    add hl, bc                                    ; $4872
    dec a                                         ; $4873
    jr nz, jr_009_4872                            ; $4874

jr_009_4876:
    ld a, $2a                                     ; $4876
    ld de, $8e60                                  ; $4878
    sla c                                         ; $487B
    rl b                                          ; $487D
    call Vram_CopyFromBankAuto                    ; $487F
    ret                                           ; $4882


; C: mode 8: USER (owner name; record; hi-score; credits)
Mode08_UserScreens::
    ld a, [wState]                                ; $4883
    rst Rst18_JumpTable                           ; $4886

; C: 25 states
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
    dw Mode08_State14_CreditsPageB
    dw Mode08_State15_CreditsScroll
    dw Mode08_State16_CreditsWaitA
    dw Mode08_State17_CreditsDancingMan
    dw Mode08_State18_Leave

; C
Mode08_State00_Init::
    ldh a, [rLCDC]                                ; $48B9
    bit 7, a                                      ; $48BB
    jr z, jr_009_48d4                             ; $48BD

    call UserMap_ScrollOut                        ; $48BF
    ld a, [wAbResult]                             ; $48C2
    bit 1, a                                      ; $48C5
    jr z, jr_009_48d4                             ; $48C7

    ld a, MODE_MAIN_MENU                          ; $48C9
    ld [wMode], a                                 ; $48CB
    set_state STATE_00_INIT                       ; $48CE
    ret                                           ; $48D3


jr_009_48d4:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $48D4
    ldh [hLcdcShadow], a                          ; $48D6
    ld a, $e4                                     ; $48D8
    ld [wPaletteTarget], a                        ; $48DA
    ld a, $d3                                     ; $48DD
    ld [wPaletteTarget + $1], a                   ; $48DF
    ld a, $93                                     ; $48E2
    ld [wPaletteTarget + $2], a                   ; $48E4
    xor a                                         ; $48E7
    ldh [hScxShadow], a                           ; $48E8
    ldh [hScyShadow], a                           ; $48EA
    ld a, $0f                                     ; $48EC
    ld hl, Gfx_0F_4000_Mode08_State00_Init        ; $48EE
    ld de, $9000                                  ; $48F1
    ld bc, $0800                                  ; $48F4
    call Mem_CopyFromBank                         ; $48F7
    farcopy Mem_CopyFromBank, Gfx_0F_4800_Mode08_State00_Init, $8800, $0800 ; $48FA
    farcopy Mem_CopyFromBank, Gfx_0F_5000_Mode08_State00_Init, $8000, $0800 ; $4908
    farcopy Mem_CopyFromBank, Map_26_5100_Mode08_State00_Init, $9800, $0240 ; $4916
    ld hl, $9a40                                  ; $4924
    ld bc, $01c0                                  ; $4927
    ld a, $ff                                     ; $492A
    call Mem_FillBc1                              ; $492C
    call Oam_ClearShadow                          ; $492F
    call Pal_AllWhite                             ; $4932
    call Lcd_On                                   ; $4935
    ld a, [wChoice4Cursor]                        ; $4938
    call UserMap_LoadPlanetTiles                  ; $493B
    call Pal_FadeIn                               ; $493E
    push af                                       ; $4941
    ld a, MUSIC_USER_SCREENS                      ; $4942
    call Snd_Music                                ; $4944
    pop af                                        ; $4947
    next_state                                    ; $4948
    ret                                           ; $494C


; C: four planets; Left/Right moves; A opens
Mode08_State01_PlanetMap::
    call UserMap_ReadKeys                         ; $494D
    call UserMap_DrawSprites                      ; $4950
    ldh a, [hKeysNew]                             ; $4953
    and PADF_A | PADF_B | PADF_START              ; $4955
    ret z                                         ; $4957

    ld [wAbResult], a                             ; $4958
    push af                                       ; $495B
    bit 0, a                                      ; $495C
    ld a, SFX1_PANEL_CLOSE                        ; $495E
    call nz, Snd_Sfx1                             ; $4960
    pop af                                        ; $4963
    push af                                       ; $4964
    bit 1, a                                      ; $4965
    ld a, SFX1_KEY_B                              ; $4967
    call nz, Snd_Sfx1                             ; $4969
    pop af                                        ; $496C
    next_state                                    ; $496D
    ret                                           ; $4971


; C
Mode08_State02_PlanetOpen::
    ld a, [wAbResult]                             ; $4972
    bit 0, a                                      ; $4975
    jr nz, jr_009_4994                            ; $4977

    call UserMap_ScrollOut                        ; $4979
    ld a, [wAbResult]                             ; $497C
    bit 1, a                                      ; $497F
    jr z, jr_009_4989                             ; $4981

    set_state STATE_08_INIT                       ; $4983
    ret                                           ; $4988


jr_009_4989:
    ld a, MODE_MAIN_MENU                          ; $4989
    ld [wMode], a                                 ; $498B
    set_state STATE_00_INIT                       ; $498E
    ret                                           ; $4993


jr_009_4994:
    call Pal_FadeOut                              ; $4994
    call Lcd_Off                                  ; $4997
    ld a, [wChoice4Cursor]                        ; $499A
    ld c, a                                       ; $499D
    ld b, $00                                     ; $499E
    ld hl, Mode08_State02_PlanetOpen_Tbl49CB      ; $49A0
    add hl, bc                                    ; $49A3
    ld a, [hl]                                    ; $49A4
    ld [wState], a                                ; $49A5
    ld a, [wState]                                ; $49A8
    cp $03                                        ; $49AB
    ret nz                                        ; $49AD

    ldh [hFarcallAArg], a                         ; $49AE
    farcall Owner_Load_Far                        ; $49B0
    xor a                                         ; $49B8
    ld hl, wOwnerName                             ; $49B9
    ld b, $0e                                     ; $49BC

jr_009_49be:
    or [hl]                                       ; $49BE
    inc hl                                        ; $49BF
    dec b                                         ; $49C0
    jr nz, jr_009_49be                            ; $49C1

    and a                                         ; $49C3
    ret nz                                        ; $49C4

    set_state STATE_08_EDITOR_INIT                ; $49C5
    ret                                           ; $49CA


; C: auto: 4 bytes, bytes; referenced by Mode08_State02_PlanetOpen. L3 pass 2026-10-26: read in BGB in 14 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Mode08_State02_PlanetOpen_Tbl49CB::
    db $03, $0c, $0f, $12

; C: owner card (far 02:5054)
Mode08_State03_CardInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $49CF
    ldh [hLcdcShadow], a                          ; $49D1
    ld a, $e4                                     ; $49D3
    ld [wPaletteTarget], a                        ; $49D5
    ld [wPaletteTarget + $1], a                   ; $49D8
    ld a, $d2                                     ; $49DB
    ld [wPaletteTarget + $2], a                   ; $49DD
    xor a                                         ; $49E0
    ldh [hScxShadow], a                           ; $49E1
    ldh [hScyShadow], a                           ; $49E3
    ldh [hFarcallAArg], a                         ; $49E5
    farcall Owner_Load_Far                        ; $49E7
    farcopy Mem_CopyFromBank, Gfx_1A_5200_Mode08_State03_CardInit, $9000, $0800 ; $49EF
    farcopy Mem_CopyFromBank, Gfx_1A_5A00_Mode08_State03_CardInit, $8800, $0800 ; $49FD
    farcopy Mem_CopyFromBank, Gfx_1A_6200_Mode08_State03_CardInit, $8000, $0160 ; $4A0B
    farcopy Mem_CopyFromBank, Map_24_5AE0_Mode08_State03_CardInit, $9800, $0240 ; $4A19
    ld hl, $9a40                                  ; $4A27
    ld bc, $01c0                                  ; $4A2A
    ld a, $ff                                     ; $4A2D
    call Mem_FillBc1                              ; $4A2F
    ld a, $50                                     ; $4A32
    ldh [hLycShadowSplit1], a                     ; $4A34
    ldh [hSplit1Latch], a                         ; $4A36
    ld hl, hStatShadow                            ; $4A38
    set 6, [hl]                                   ; $4A3B
    ld hl, rIE                                    ; $4A3D
    set 1, [hl]                                   ; $4A40
    ld a, $01                                     ; $4A42
    ldh [hStatHandlerIndex], a                    ; $4A44
    call Oam_ClearShadow                          ; $4A46
    call Pal_AllWhite                             ; $4A49
    call Lcd_On                                   ; $4A4C
    push af                                       ; $4A4F
    ld a, MUSIC_OWNER_CARD                        ; $4A50
    call Snd_Music                                ; $4A52
    pop af                                        ; $4A55
    call OwnerCard_DrawOwnerId                    ; $4A56
    call OwnerCard_LoadNameGlyphs                 ; $4A59
    call OwnerCard_DrawGender                     ; $4A5C
    call OwnerCard_DrawBirthDate                  ; $4A5F
    call OwnerCard_DrawBloodType                  ; $4A62
    call Pal_FadeIn                               ; $4A65
    next_state                                    ; $4A68
    ret                                           ; $4A6C


; C
Mode08_State04_CardShow::
    call OwnerCard_BlinkTitle                     ; $4A6D
    ldh a, [hKeysNew]                             ; $4A70
    and PADF_B | PADF_START                       ; $4A72
    ret z                                         ; $4A74

    ld [wAbResult], a                             ; $4A75
    next_state                                    ; $4A78
    ret                                           ; $4A7C


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_BlinkTitle::
    ldh a, [hFrameCounter]                        ; $4A7D
    and $07                                       ; $4A7F
    ret z                                         ; $4A81

jr_009_4a82:
    ldh a, [rLY]                                  ; $4A82
    cp $30                                        ; $4A84
    jr c, jr_009_4a82                             ; $4A86

    ldh a, [hFrameCounter]                        ; $4A88
    bit 3, a                                      ; $4A8A
    jr nz, jr_009_4aab                            ; $4A8C

    farcopy Vram_CopyFromBank, Map_24_5AE0_Mode08_State03_CardInit, $9800, $0080 ; $4A8E
    farcopy Vram_CopyFromBank, Map_24_5D00_OwnerCard_BlinkTitle, $9a20, $0020 ; $4A9C
    ret                                           ; $4AAA


jr_009_4aab:
    farcopy Vram_CopyFromBank, Map_24_5D20_OwnerCard_BlinkTitle, $9800, $0080 ; $4AAB
    farcopy Vram_CopyFromBank, Map_24_5DA0_OwnerCard_BlinkTitle, $9a20, $0020 ; $4AB9
    ret                                           ; $4AC7


; C
Mode08_State05_CardLeave::
    ld a, [wAbResult]                             ; $4AC8
    bit 3, a                                      ; $4ACB
    jr z, jr_009_4ae4                             ; $4ACD

    call Pal_FadeOut                              ; $4ACF
    call Lcd_Off                                  ; $4AD2
    ld hl, hStatShadow                            ; $4AD5
    res 6, [hl]                                   ; $4AD8
    ld hl, rIE                                    ; $4ADA
    res 1, [hl]                                   ; $4ADD
    next_state                                    ; $4ADF
    ret                                           ; $4AE3


jr_009_4ae4:
    call Pal_FadeOut                              ; $4AE4
    call Lcd_Off                                  ; $4AE7
    ld hl, hStatShadow                            ; $4AEA
    res 6, [hl]                                   ; $4AED
    ld hl, rIE                                    ; $4AEF
    res 1, [hl]                                   ; $4AF2
    set_state STATE_08_INIT                       ; $4AF4
    ret                                           ; $4AF9


; C: on-screen keyboard
Mode08_State06_EditorInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4AFA
    ldh [hLcdcShadow], a                          ; $4AFC
    ld a, $e4                                     ; $4AFE
    ld [wPaletteTarget], a                        ; $4B00
    ld [wPaletteTarget + $1], a                   ; $4B03
    ld a, $d2                                     ; $4B06
    ld [wPaletteTarget + $2], a                   ; $4B08
    ld a, $fc                                     ; $4B0B
    ldh [hScyShadow], a                           ; $4B0D
    xor a                                         ; $4B0F
    ldh [hScxShadow], a                           ; $4B10
    ld [wKbCursor], a                             ; $4B12
    ld [wKbKey], a                                ; $4B15
    ld [wKbPage], a                               ; $4B18
    ld [wKbTabFrame], a                           ; $4B1B
    ld [wKbTabFrame + $1], a                      ; $4B1E
    ld [wKbTabFrame + $2], a                      ; $4B21
    farcopy Mem_CopyFromBank, Gfx_20_5B00_Mode08_State06_EditorInit, $9000, $0580 ; $4B24
    farcopy Mem_CopyFromBank, Gfx_20_6080_Mode08_State06_EditorInit, $8000, $0440 ; $4B32
    farcopy Mem_CopyFromBank, Gfx_20_67C0_Mode08_State06_EditorInit, $8440, $0020 ; $4B40
    farcopy Mem_CopyFromBank, Map_23_73E0_Mode08_State06_EditorInit, $9800, $0240 ; $4B4E
    ld hl, $9a40                                  ; $4B5C
    ld bc, $01c0                                  ; $4B5F
    ld a, $ff                                     ; $4B62
    call Mem_FillBc1                              ; $4B64
    call Oam_ClearShadow                          ; $4B67
    call Pal_AllWhite                             ; $4B6A
    call Lcd_On                                   ; $4B6D
    push af                                       ; $4B70
    ld a, MUSIC_OWNER_CARD                        ; $4B71
    call Snd_Music                                ; $4B73
    pop af                                        ; $4B76
    call Kb_LoadGlyphSetA                         ; $4B77
    call OwnerCard_LoadNameGlyphsB                ; $4B7A
    call OwnerCard_LoadGenderTiles                ; $4B7D
    call OwnerCard_LoadBirthTiles                 ; $4B80
    call OwnerCard_LoadBloodTiles                 ; $4B83
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
    call Pal_FadeOut                              ; $4BC8
    call Lcd_Off                                  ; $4BCB
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
    farcopy Mem_CopyFromBank, Map_26_6300_Mode08_State0C_RecordInit, $9800, $0240 ; $4C1A
    ld hl, $9a40                                  ; $4C28
    ld bc, $01c0                                  ; $4C2B
    ld a, $ff                                     ; $4C2E
    call Mem_FillBc1                              ; $4C30
    call Oam_ClearShadow                          ; $4C33
    call Pal_AllWhite                             ; $4C36
    call Lcd_On                                   ; $4C39
    call Record_DrawCounters                      ; $4C3C
    call Pal_FadeIn                               ; $4C3F
    push af                                       ; $4C42
    ld a, MUSIC_RECORD_HI_SCORE                   ; $4C43
    call Snd_Music                                ; $4C45
    pop af                                        ; $4C48
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
    call Pal_FadeOut                              ; $4C58
    call Lcd_Off                                  ; $4C5B
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
    call Oam_ClearShadow                          ; $4CB9
    call Pal_AllWhite                             ; $4CBC
    call Lcd_On                                   ; $4CBF
    call HiScore_DrawScores                       ; $4CC2
    call Pal_FadeIn                               ; $4CC5
    push af                                       ; $4CC8
    ld a, MUSIC_RECORD_HI_SCORE                   ; $4CC9
    call Snd_Music                                ; $4CCB
    pop af                                        ; $4CCE
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
    call Pal_FadeOut                              ; $4CDE
    call Lcd_Off                                  ; $4CE1
    set_state STATE_08_INIT                       ; $4CE4
    ret                                           ; $4CE9


; C: fade out and state 0
Mode08_CreditsAbort::
    call Pal_FadeOut                              ; $4CEA
    call Lcd_Off                                  ; $4CED
    jr jr_009_4d0e                                ; $4CF0

; C: record >= $7799 chooses the real credits
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
    farcopy Mem_CopyFromBank, Map_26_5E80_CreditsNishimuraDanceMap0, $9800, $0240 ; $4D3C
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
    call Oam_ClearShadow                          ; $4D6D
    call Pal_AllWhite                             ; $4D70
    call Lcd_On                                   ; $4D73
    call Pal_FadeIn                               ; $4D76
    push af                                       ; $4D79
    ld a, MUSIC_JINGLE                            ; $4D7A
    call Snd_Music                                ; $4D7C
    pop af                                        ; $4D7F
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
    ld a, $13                                     ; $4DA3
    ld hl, Gfx_13_7000_Mode08_CreditsReal         ; $4DA5
    ld de, $9000                                  ; $4DA8
    ld bc, $0800                                  ; $4DAB
    call Mem_CopyFromBank                         ; $4DAE
    farcopy Mem_CopyFromBank, Gfx_13_7800_Mode08_CreditsReal, $8800, $0800 ; $4DB1
    farcopy Mem_CopyFromBank, Map_1C_7C60_Mode08_CreditsReal, $9800, $0240 ; $4DBF
    call Pal_AllWhite                             ; $4DCD
    call Lcd_On                                   ; $4DD0
    call Pal_FadeIn                               ; $4DD3
    push af                                       ; $4DD6
    ld a, MUSIC_CREDITS                           ; $4DD7
    call Snd_Music                                ; $4DD9
    pop af                                        ; $4DDC
    next_state                                    ; $4DDD
    ret                                           ; $4DE1


; C: CLIP THIS. page
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

    call Pal_FadeOut                              ; $4E29
    call Lcd_Off                                  ; $4E2C
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4E2F
    ldh [hLcdcShadow], a                          ; $4E31
    ld a, $e4                                     ; $4E33
    ld [wPaletteTarget], a                        ; $4E35
    ld [wPaletteTarget + $1], a                   ; $4E38
    ld a, $d2                                     ; $4E3B
    ld [wPaletteTarget + $2], a                   ; $4E3D
    xor a                                         ; $4E40
    ldh [hScxShadow], a                           ; $4E41
    ldh [hScyShadow], a                           ; $4E43
    ld [wCredAnimPhase], a                        ; $4E45
    ld [wCredFrameTimer], a                       ; $4E48
    ld [wCredSpritePhase], a                      ; $4E4B
    ld [wCredSubDivider], a                       ; $4E4E
    ld [wCredStepCounter], a                      ; $4E51
    ld hl, wCredJitter                            ; $4E54
    ld b, $04                                     ; $4E57

jr_009_4e59:
    ld [hl+], a                                   ; $4E59
    ld [hl+], a                                   ; $4E5A
    dec b                                         ; $4E5B
    jr nz, jr_009_4e59                            ; $4E5C

    farcopy Mem_CopyFromBank, Gfx_19_5260_Mode08_State13_CreditsPageA, $9000, $0800 ; $4E5E
    farcopy Mem_CopyFromBank, Gfx_19_5A60_Mode08_State13_CreditsPageA, $8800, $0800 ; $4E6C
    farcopy Mem_CopyFromBank, Gfx_19_6260_Mode08_State13_CreditsPageA, $8000, $0200 ; $4E7A
    farcopy Mem_CopyFromBank, Map_26_72C0_Mode08_State13_CreditsPageA, $9800, $0240 ; $4E88
    call Pal_AllWhite                             ; $4E96
    call Lcd_On                                   ; $4E99
    call Pal_FadeIn                               ; $4E9C
    next_state                                    ; $4E9F
    ret                                           ; $4EA3


; C
Mode08_State14_CreditsPageB::
    ldh a, [hKeysNew]                             ; $4EA4
    bit PADB_B, a                                 ; $4EA6
    jp nz, Mode08_CreditsAbort                    ; $4EA8

    call Credits_DrawJitterSprites                ; $4EAB
    call Credits_DrawAnimSprite                   ; $4EAE
    ld a, [wCredFrameTimer]                       ; $4EB1
    inc a                                         ; $4EB4
    cp $08                                        ; $4EB5
    jr c, jr_009_4eba                             ; $4EB7

    xor a                                         ; $4EB9

jr_009_4eba:
    ld [wCredFrameTimer], a                       ; $4EBA
    ret nz                                        ; $4EBD

    ld a, [wCredAnimPhase]                        ; $4EBE
    inc a                                         ; $4EC1
    and $03                                       ; $4EC2
    ld [wCredAnimPhase], a                        ; $4EC4
    sla a                                         ; $4EC7
    ld c, a                                       ; $4EC9
    ld b, $00                                     ; $4ECA
    ld hl, wCredJitter                            ; $4ECC
    add hl, bc                                    ; $4ECF
    ld a, $03                                     ; $4ED0
    call Rng_Scaled                               ; $4ED2
    dec a                                         ; $4ED5
    ld [hl+], a                                   ; $4ED6
    ld a, $03                                     ; $4ED7
    call Rng_Scaled                               ; $4ED9
    dec a                                         ; $4EDC
    ld [hl], a                                    ; $4EDD
    ld a, [wCredStepCounter]                      ; $4EDE
    inc a                                         ; $4EE1
    ld [wCredStepCounter], a                      ; $4EE2
    cp $43                                        ; $4EE5
    ret c                                         ; $4EE7

    call Pal_FadeOut                              ; $4EE8
    call Lcd_Off                                  ; $4EEB
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $4EEE
    ldh [hLcdcShadow], a                          ; $4EF0
    ld a, $e1                                     ; $4EF2
    ld [wPaletteTarget], a                        ; $4EF4
    ld a, $f3                                     ; $4EF7
    ld [wPaletteTarget + $1], a                   ; $4EF9
    ld [wPaletteTarget + $2], a                   ; $4EFC
    ld a, $28                                     ; $4EFF
    ldh [hScxShadow], a                           ; $4F01
    xor a                                         ; $4F03
    ldh [hScyShadow], a                           ; $4F04
    ld [wCredAnimPhase], a                        ; $4F06
    ld [wCredFrameTimer], a                       ; $4F09
    ld [wCredStepCounter], a                      ; $4F0C
    ld [wScrollScriptDone], a                     ; $4F0F
    ld [wScrollSubstate], a                       ; $4F12
    farcopy Mem_CopyFromBank, Gfx_25_4480_Mode08_State14_CreditsPageB, $8000, $0500 ; $4F15
    ld a, $20                                     ; $4F23
    ld hl, Gfx_20_4000_Mode08_State14_CreditsPageB ; $4F25
    ld de, $9000                                  ; $4F28
    ld bc, $0800                                  ; $4F2B
    call Mem_CopyFromBank                         ; $4F2E
    farcopy Mem_CopyFromBank, Gfx_20_4800_Mode08_State14_CreditsPageB, $8a00, $0600 ; $4F31
    ld hl, $9800                                  ; $4F3F
    ld bc, $0400                                  ; $4F42
    ld a, $ff                                     ; $4F45
    call Mem_FillBc1                              ; $4F47
    call Oam_ClearShadow                          ; $4F4A
    ld bc, $5048                                  ; $4F4D
    ld a, $b8                                     ; $4F50
    call Oam_AddMeta_B02_5272                     ; $4F52
    call Pal_AllWhite                             ; $4F55
    call Lcd_On                                   ; $4F58
    call Pal_FadeIn                               ; $4F5B
    push af                                       ; $4F5E
    ld a, MUSIC_CREDITS_PAGE_B                    ; $4F5F
    call Snd_Music                                ; $4F61
    pop af                                        ; $4F64
    next_state                                    ; $4F65
    ret                                           ; $4F69


; C: 8 sprites with random dx/dy pairs
Credits_DrawJitterSprites::
    ld hl, wCredJitter                            ; $4F6A
    ld de, Credits_JitterPosTbl                   ; $4F6D
    ld b, $08                                     ; $4F70

jr_009_4f72:
    push bc                                       ; $4F72
    ld a, [de]                                    ; $4F73
    add [hl]                                      ; $4F74
    ld b, a                                       ; $4F75
    inc hl                                        ; $4F76
    inc de                                        ; $4F77
    ld a, [de]                                    ; $4F78
    ld c, a                                       ; $4F79
    inc de                                        ; $4F7A
    ld a, [de]                                    ; $4F7B
    inc de                                        ; $4F7C
    call Oam_AddMeta_B02_6E4B                     ; $4F7D
    pop bc                                        ; $4F80
    dec b                                         ; $4F81
    jr nz, jr_009_4f72                            ; $4F82

    ret                                           ; $4F84


; C: L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Credits_JitterPosTbl::
    db $3d, $1d, $71, $59, $18, $72, $5c, $29, $73, $67, $3a, $74, $30, $41, $75, $31
    db $62, $76, $69, $62, $77, $6f, $45, $78

; C: 6 phases from table 09:4FC9
Credits_DrawAnimSprite::
    ld a, [wCredSubDivider]                       ; $4F9D
    inc a                                         ; $4FA0
    and $0f                                       ; $4FA1
    ld [wCredSubDivider], a                       ; $4FA3
    jr nz, jr_009_4fb4                            ; $4FA6

    ld a, [wCredSpritePhase]                      ; $4FA8
    inc a                                         ; $4FAB
    cp $06                                        ; $4FAC
    jr c, jr_009_4fb1                             ; $4FAE

    xor a                                         ; $4FB0

jr_009_4fb1:
    ld [wCredSpritePhase], a                      ; $4FB1

jr_009_4fb4:
    ld a, [wCredSpritePhase]                      ; $4FB4
    sla a                                         ; $4FB7
    ld c, a                                       ; $4FB9
    ld b, $00                                     ; $4FBA
    ld hl, Credits_AnimSpriteTbl                  ; $4FBC
    add hl, bc                                    ; $4FBF
    ld c, [hl]                                    ; $4FC0
    inc hl                                        ; $4FC1
    ld b, [hl]                                    ; $4FC2
    ld a, $79                                     ; $4FC3
    call Oam_AddMeta_B02_6E4B                     ; $4FC5
    ret                                           ; $4FC8


; C
Credits_AnimSpriteTbl::
    db $28, $09, $1d, $0a, $13, $13, $12, $21, $17, $28, $28, $2b

; C: staff roll via ScrollEngine_Step
Mode08_State15_CreditsScroll::
    ldh a, [hKeysNew]                             ; $4FD5
    bit PADB_B, a                                 ; $4FD7
    jp nz, Mode08_CreditsAbort                    ; $4FD9

    call ScrollEngine_Step                        ; $4FDC
    ld a, [wCredAnimPhase]                        ; $4FDF
    sla a                                         ; $4FE2
    sla a                                         ; $4FE4
    ld c, a                                       ; $4FE6
    ld b, $00                                     ; $4FE7
    ld hl, $509f                                  ; $4FE9
    add hl, bc                                    ; $4FEC
    ld a, [wCredFrameTimer]                       ; $4FED
    inc a                                         ; $4FF0
    cp [hl]                                       ; $4FF1
    jr c, jr_009_4ff5                             ; $4FF2

    xor a                                         ; $4FF4

jr_009_4ff5:
    ld [wCredFrameTimer], a                       ; $4FF5
    and a                                         ; $4FF8
    jr nz, jr_009_5033                            ; $4FF9

    ld a, [wCredAnimPhase]                        ; $4FFB
    inc a                                         ; $4FFE
    cp $0d                                        ; $4FFF
    jr nz, jr_009_5004                            ; $5001

    xor a                                         ; $5003

jr_009_5004:
    ld [wCredAnimPhase], a                        ; $5004
    ld a, [wCredStepCounter]                      ; $5007
    xor $01                                       ; $500A
    ld [wCredStepCounter], a                      ; $500C
    ld de, $8000                                  ; $500F
    and a                                         ; $5012
    jr z, jr_009_5018                             ; $5013

    ld de, $8500                                  ; $5015

jr_009_5018:
    ld a, [wCredAnimPhase]                        ; $5018
    sla a                                         ; $501B
    sla a                                         ; $501D
    ld c, a                                       ; $501F
    ld b, $00                                     ; $5020
    ld hl, Credits_ScrollFrameTbl                 ; $5022
    add hl, bc                                    ; $5025
    ld c, [hl]                                    ; $5026
    inc hl                                        ; $5027
    ld b, [hl]                                    ; $5028
    inc hl                                        ; $5029
    ld a, [hl]                                    ; $502A
    ld h, b                                       ; $502B
    ld l, c                                       ; $502C
    ld bc, $0500                                  ; $502D
    call Vram_CopyFromBank                        ; $5030

jr_009_5033:
    ld a, [wCredStepCounter]                      ; $5033
    ld c, a                                       ; $5036
    ld b, $00                                     ; $5037
    ld hl, Credits_ScrollSpriteTileTbl            ; $5039
    add hl, bc                                    ; $503C
    ld d, [hl]                                    ; $503D
    ld bc, $6048                                  ; $503E
    ld a, [wCredAnimPhase]                        ; $5041
    add $b8                                       ; $5044
    call Oam_AddMetaTile_B02_5272                 ; $5046
    ld a, [wScrollScriptDone]                     ; $5049
    and a                                         ; $504C
    ret z                                         ; $504D

    call Pal_FadeOut                              ; $504E
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_BGON   ; $5051
    ldh [hLcdcShadow], a                          ; $5053
    ld a, $e4                                     ; $5055
    ld [wPaletteTarget], a                        ; $5057
    ld [wPaletteTarget + $1], a                   ; $505A
    ld [wPaletteTarget + $2], a                   ; $505D
    xor a                                         ; $5060
    ldh [hScxShadow], a                           ; $5061
    ldh [hScyShadow], a                           ; $5063
    ld a, $28                                     ; $5065
    ld hl, Gfx_28_7000_CreditsEndingPlate_TilesA  ; $5067
    ld de, $9000                                  ; $506A
    ld bc, $0800                                  ; $506D
    call Vram_CopyFromBank                        ; $5070
    farcopy Vram_CopyFromBank, Gfx_28_7800_CreditsEndingPlate_TilesB, $8800, $0800 ; $5073
    farcopy Vram_CopyFromBank, Map_26_4C80_CreditsEndingPlate_Map, $9800, $0240 ; $5081
    call Pal_AllWhite                             ; $508F
    call Pal_FadeIn                               ; $5092
    next_state                                    ; $5095
    ret                                           ; $5099


; C: 2 bytes: OAM tile-number offset of the dancer sprite, indexed by the buffer toggle $C005. L3 pass 2026-10-26:
; read in BGB in 2 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Credits_ScrollSpriteTileTbl::
    dw $5000

; C: 13 records {lo,hi,bank,duration}: the staff-roll dancer frames (a dancing girl, not identified) (0x500 bytes
; each, 12 frames per record); copied alternately to $8000 / $8500 by Mode08_State15_CreditsScroll; checked by running
; the real credits (core and BGB)
Credits_ScrollFrameTbl::
    db $80, $44, $25, $0c
    db $00, $40, $24, $0c
    db $40, $52, $22, $0c
    db $00, $40, $22, $0c
    db $00, $7b, $17, $0c
    db $00, $40, $25, $0c
    db $00, $40, $26, $0c
    db $a0, $56, $22, $0c
    db $40, $6f, $22, $0c
    db $00, $40, $23, $0c
    db $e0, $4d, $22, $0c
    db $00, $5b, $22, $0c
    db $80, $6c, $23, $0c

; C: A -> state $18
Mode08_State16_CreditsWaitA::
    ldh a, [hKeysNew]                             ; $50D0
    bit PADB_B, a                                 ; $50D2
    jp nz, Mode08_CreditsAbort                    ; $50D4

    bit PADB_A, a                                 ; $50D7
    ret z                                         ; $50D9

    set_state STATE_08_LEAVE                      ; $50DA
    ret                                           ; $50DF


; C
Mode08_State17_CreditsDancingMan::
    ld a, [wCredAnimPhase]                        ; $50E0
    sla a                                         ; $50E3
    sla a                                         ; $50E5
    ld c, a                                       ; $50E7
    ld b, $00                                     ; $50E8
    ld hl, $5148                                  ; $50EA
    add hl, bc                                    ; $50ED
    ld a, [wCredFrameTimer]                       ; $50EE
    inc a                                         ; $50F1
    cp [hl]                                       ; $50F2
    jr c, jr_009_50f6                             ; $50F3

    xor a                                         ; $50F5

jr_009_50f6:
    ld [wCredFrameTimer], a                       ; $50F6
    and a                                         ; $50F9
    jr nz, jr_009_512d                            ; $50FA

    ld a, [wCredAnimPhase]                        ; $50FC
    inc a                                         ; $50FF
    cp $04                                        ; $5100
    jr nz, jr_009_510c                            ; $5102

    ld a, [wCredSubDivider]                       ; $5104
    inc a                                         ; $5107
    ld [wCredSubDivider], a                       ; $5108
    xor a                                         ; $510B

jr_009_510c:
    ld [wCredAnimPhase], a                        ; $510C
    ld de, $9000                                  ; $510F
    ld a, [wCredAnimPhase]                        ; $5112
    sla a                                         ; $5115
    sla a                                         ; $5117
    ld c, a                                       ; $5119
    ld b, $00                                     ; $511A
    ld hl, Credits_NishimuraDanceFrameTbl         ; $511C
    add hl, bc                                    ; $511F
    ld c, [hl]                                    ; $5120
    inc hl                                        ; $5121
    ld b, [hl]                                    ; $5122
    inc hl                                        ; $5123
    ld a, [hl]                                    ; $5124
    ld h, b                                       ; $5125
    ld l, c                                       ; $5126
    ld bc, $0470                                  ; $5127
    call Vram_CopyFromBank                        ; $512A

jr_009_512d:
    ld a, [wCredSubDivider]                       ; $512D
    cp $0a                                        ; $5130
    jr c, jr_009_5138                             ; $5132

    call Credits_NextDancingFrame                 ; $5134
    xor a                                         ; $5137

jr_009_5138:
    ld [wCredSubDivider], a                       ; $5138
    ldh a, [hKeysNew]                             ; $513B
    and PADF_A | PADF_B                           ; $513D
    ret z                                         ; $513F

    next_state                                    ; $5140
    ret                                           ; $5144


; C: 4 records {lo,hi,bank,duration=8}: frames of the dance of Kentaro Nishimura (credited CORDINATOR (sic) and SOUND
; COMPOSER; the 'Miyamoto' attribution found on the web is an error, owner) of the short credits (22:4500, 22:4970,
; 27:4000, 22:4970; 0x470 bytes each) used by ...
Credits_NishimuraDanceFrameTbl::
    db $00, $45, $22, $08
    db $70, $49, $22, $08
    db $00, $40, $27, $08
    db $70, $49, $22, $08

; C
Credits_NextDancingFrame::
    ld a, [wCredSpritePhase]                      ; $5155
    inc a                                         ; $5158
    cp $05                                        ; $5159
    jr c, jr_009_515e                             ; $515B

    xor a                                         ; $515D

jr_009_515e:
    ld [wCredSpritePhase], a                      ; $515E
    ld c, a                                       ; $5161
    sla a                                         ; $5162
    add c                                         ; $5164
    ld c, a                                       ; $5165
    ld b, $00                                     ; $5166
    ld hl, Credits_NishimuraDanceMapTbl           ; $5168
    add hl, bc                                    ; $516B
    ld c, [hl]                                    ; $516C
    inc hl                                        ; $516D
    ld b, [hl]                                    ; $516E
    inc hl                                        ; $516F
    ld a, [hl]                                    ; $5170
    ld h, b                                       ; $5171
    ld l, c                                       ; $5172
    ld de, $9800                                  ; $5173
    ld bc, $0240                                  ; $5176
    call Vram_CopyFromBank                        ; $5179
    ret                                           ; $517C


; C: 5 records {lo,hi,bank}: BG maps of the Nishimura dance screen (26:5E80, 25:6860, 26:7500, 26:7740, 26:7980; 0x240
; bytes each) cycled by Credits_NextDancingFrame
Credits_NishimuraDanceMapTbl::
    dwb Map_26_5E80_CreditsNishimuraDanceMap0
    dwb Map_25_6860_CreditsNishimuraDanceMap1
    dwb Map_26_7500_CreditsNishimuraDanceMap2
    dwb Map_26_7740_CreditsNishimuraDanceMap3
    dwb Map_26_7980_CreditsNishimuraDanceMap4

; C
Mode08_State18_Leave::
    call Pal_FadeOut                              ; $518C
    call Lcd_Off                                  ; $518F
    set_state STATE_08_INIT                       ; $5192
    ret                                           ; $5197


; C: Left/Right moves choice4_cursor
UserMap_ReadKeys::
    ldh a, [hKeysNewRepeat]                       ; $5198
    ld b, a                                       ; $519A
    ld a, [wChoice4Cursor]                        ; $519B
    bit 5, b                                      ; $519E
    jr z, jr_009_51a7                             ; $51A0

    and a                                         ; $51A2
    ret z                                         ; $51A3

    dec a                                         ; $51A4
    jr jr_009_51ae                                ; $51A5

jr_009_51a7:
    bit 4, b                                      ; $51A7
    ret z                                         ; $51A9

    cp $03                                        ; $51AA
    ret z                                         ; $51AC

    inc a                                         ; $51AD

jr_009_51ae:
    ld hl, wChoice4Cursor                         ; $51AE
    cp [hl]                                       ; $51B1
    ret z                                         ; $51B2

    ld [hl], a                                    ; $51B3
    push af                                       ; $51B4
    ld a, SFX1_CURSOR_MOVE                        ; $51B5
    call Snd_Sfx1                                 ; $51B7
    pop af                                        ; $51BA

; C
UserMap_LoadPlanetTiles::
    and a                                         ; $51BB
    jr nz, jr_009_51cd                            ; $51BC

    farcopy Vram_CopyFromBank, Gfx_0F_5500_UserMap_LoadPlanetTiles, $8500, $0280 ; $51BE
    ret                                           ; $51CC


jr_009_51cd:
    cp $01                                        ; $51CD
    jr nz, jr_009_51e0                            ; $51CF

    farcopy Vram_CopyFromBank, Gfx_0F_5780_UserMap_LoadPlanetTiles, $8500, $0280 ; $51D1
    ret                                           ; $51DF


jr_009_51e0:
    cp $02                                        ; $51E0
    jr nz, jr_009_51f3                            ; $51E2

    farcopy Vram_CopyFromBank, Gfx_0F_5A00_UserMap_LoadPlanetTiles, $8500, $0280 ; $51E4
    ret                                           ; $51F2


jr_009_51f3:
    farcopy Vram_CopyFromBank, Gfx_0F_5C80_UserMap_LoadPlanetTiles, $8500, $0280 ; $51F3
    ret                                           ; $5201


; C
UserMap_DrawSprites::
    call UserMap_AnimateDecoSprites               ; $5202
    call UserMap_DrawCursor                       ; $5205
    ld bc, $7026                                  ; $5208
    ld a, $73                                     ; $520B
    call Oam_AddMeta_B02_5272                     ; $520D
    ld bc, $4c9c                                  ; $5210
    ld a, $74                                     ; $5213
    call Oam_AddMeta_B02_5272                     ; $5215
    ret                                           ; $5218


; C: four decorative sprites: tick; limit; phase
UserMap_AnimateDecoSprites::
    ld bc, wDecoTick                              ; $5219
    ld de, wDecoPhase                             ; $521C
    ld hl, UserMap_DecoLimitTbl                   ; $521F
    ld a, $04                                     ; $5222

jr_009_5224:
    ldh [hScratchA], a                            ; $5224
    ld a, [bc]                                    ; $5226
    inc a                                         ; $5227
    cp [hl]                                       ; $5228
    jr c, jr_009_5231                             ; $5229

    ld a, [de]                                    ; $522B
    inc a                                         ; $522C
    and $03                                       ; $522D
    ld [de], a                                    ; $522F
    xor a                                         ; $5230

jr_009_5231:
    ld [bc], a                                    ; $5231
    inc bc                                        ; $5232
    inc de                                        ; $5233
    inc hl                                        ; $5234
    ldh a, [hScratchA]                            ; $5235
    dec a                                         ; $5237
    jr nz, jr_009_5224                            ; $5238

    ld bc, $4550                                  ; $523A
    ld a, [wDecoPhase]                            ; $523D
    add $61                                       ; $5240
    call Oam_AddMeta_B02_5272                     ; $5242
    ld bc, $7049                                  ; $5245
    ld a, [wDecoPhase + $1]                       ; $5248
    and $01                                       ; $524B
    add $65                                       ; $524D
    call Oam_AddMeta_B02_5272                     ; $524F
    ld bc, $6d6c                                  ; $5252
    ld a, [wDecoPhase + $2]                       ; $5255
    add $6b                                       ; $5258
    call Oam_AddMeta_B02_5272                     ; $525A
    ld bc, $9177                                  ; $525D
    ld a, [wDecoPhase + $3]                       ; $5260
    add $67                                       ; $5263
    call Oam_AddMeta_B02_5272                     ; $5265
    ret                                           ; $5268


; C: L3 pass 2026-10-26: read in BGB in 15 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
UserMap_DecoLimitTbl::
    db $0d, $10, $07, $17

; C: sprite $6F/$71 at table 09:5293
UserMap_DrawCursor::
    ld a, [wChoice4Cursor]                        ; $526D
    sla a                                         ; $5270
    ld c, a                                       ; $5272
    ld b, $00                                     ; $5273
    ld hl, UserMap_CursorPosTbl                   ; $5275
    add hl, bc                                    ; $5278
    ld c, [hl]                                    ; $5279
    inc hl                                        ; $527A
    ld b, [hl]                                    ; $527B
    ld a, [wChoice4Cursor]                        ; $527C
    ld e, a                                       ; $527F
    ld d, $00                                     ; $5280
    ld hl, UserMap_DrawCursor_PtrTbl529B          ; $5282
    add hl, de                                    ; $5285
    ldh a, [hFrameCounter]                        ; $5286
    srl a                                         ; $5288
    srl a                                         ; $528A
    and $01                                       ; $528C
    add [hl]                                      ; $528E
    call Oam_AddMeta_B02_5272                     ; $528F
    ret                                           ; $5292


; C
UserMap_CursorPosTbl::
    db $50, $45, $49, $70, $6c, $6d, $77, $91

; C: auto: 4 bytes, word table; referenced by UserMap_DrawCursor. L3 pass 2026-10-26: read in BGB in 15 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
UserMap_DrawCursor_PtrTbl529B::
    dw $6f6f
    dw $716f

; C: music $46; SCY ramp
UserMap_ScrollOut::
    push af                                       ; $529F
    ld a, MUSIC_USER_MAP_SCROLL_OUT               ; $52A0
    call Snd_Music                                ; $52A2
    pop af                                        ; $52A5
    call Oam_ClearShadow                          ; $52A6
    rst Rst08_WaitVBlank                          ; $52A9
    ld bc, $01c0                                  ; $52AA

jr_009_52ad:
    push bc                                       ; $52AD
    sla c                                         ; $52AE
    rl b                                          ; $52B0
    sla c                                         ; $52B2
    rl b                                          ; $52B4
    call Rng_Next                                 ; $52B6
    ld c, a                                       ; $52B9
    call UserMap_ScrollStep                       ; $52BA
    pop bc                                        ; $52BD
    ldh a, [hKeysNew]                             ; $52BE
    and PADF_A | PADF_B                           ; $52C0
    ld [wAbResult], a                             ; $52C2
    jr nz, jr_009_52cc                            ; $52C5

    dec bc                                        ; $52C7
    ld a, c                                       ; $52C8
    or b                                          ; $52C9
    jr nz, jr_009_52ad                            ; $52CA

jr_009_52cc:
    xor a                                         ; $52CC
    ldh [hScyShadow], a                           ; $52CD
    ldh [hBgpShadow], a                           ; $52CF
    ld hl, $ff42                                  ; $52D1

jr_009_52d4:
    ldh a, [rSTAT]                                ; $52D4
    and $03                                       ; $52D6
    jr nz, jr_009_52d4                            ; $52D8

    xor a                                         ; $52DA
    ldh [rSCY], a                                 ; $52DB
    ldh [rBGP], a                                 ; $52DD
    ld bc, $0002                                  ; $52DF
    call Wait_Frames                              ; $52E2
    call Lcd_Off                                  ; $52E5
    ret                                           ; $52E8


; C
UserMap_ScrollStep::
    inc b                                         ; $52E9
    sla b                                         ; $52EA
    sla b                                         ; $52EC

jr_009_52ee:
    ld a, c                                       ; $52EE
    ldh [hScyShadow], a                           ; $52EF

jr_009_52f1:
    ldh a, [rLY]                                  ; $52F1
    cp $90                                        ; $52F3
    jr nc, jr_009_52f1                            ; $52F5

    ldh a, [rSTAT]                                ; $52F7
    and $03                                       ; $52F9
    jr nz, jr_009_52f1                            ; $52FB

    ld a, c                                       ; $52FD
    ldh [rSCY], a                                 ; $52FE
    inc c                                         ; $5300
    call Record_Delay8                            ; $5301
    dec b                                         ; $5304
    jr nz, jr_009_52ee                            ; $5305

    ret                                           ; $5307


; C: busy loop of 8 iterations used by the statistics screen. L3 pass 2026-10-26: executed in BGB in 26 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
Record_Delay8::
    ld a, $08                                     ; $5308

jr_009_530a:
    dec a                                         ; $530A
    jr nz, jr_009_530a                            ; $530B

    ret                                           ; $530D


; C: taken; erased; sent; received m/f; printed
Record_DrawCounters::
    ld hl, $986d                                  ; $530E
    ld a, [wCntTaken + $1]                        ; $5311
    call Record_DrawBcdByte                       ; $5314
    ld a, [wCntTaken]                             ; $5317
    call Record_DrawBcdByte                       ; $531A
    ld hl, $98cd                                  ; $531D
    ld a, [wCntErased + $1]                       ; $5320
    call Record_DrawBcdByte                       ; $5323
    ld a, [wCntErased]                            ; $5326
    call Record_DrawBcdByte                       ; $5329
    ld hl, $992d                                  ; $532C
    ld a, [wCntSent + $1]                         ; $532F
    call Record_DrawBcdByte                       ; $5332
    ld a, [wCntSent]                              ; $5335
    call Record_DrawBcdByte                       ; $5338
    ld hl, $998c                                  ; $533B
    ld a, [wCntRecvA]                             ; $533E
    call Record_DrawBcdByte                       ; $5341
    inc hl                                        ; $5344
    ld a, [wCntRecvB]                             ; $5345
    call Record_DrawBcdByte                       ; $5348
    ld hl, $99ed                                  ; $534B
    ld a, [wCntPrinted + $1]                      ; $534E
    call Record_DrawBcdByte                       ; $5351
    ld a, [wCntPrinted]                           ; $5354

; C: two tall digits
Record_DrawBcdByte::
    push af                                       ; $5357
    swap a                                        ; $5358
    and $0f                                       ; $535A
    call Record_DrawTallDigit                     ; $535C
    pop af                                        ; $535F
    and $0f                                       ; $5360

; C: tile and tile+$10 one row below
Record_DrawTallDigit::
    push hl                                       ; $5362
    call Vram_WriteByteSafe                       ; $5363
    ld bc, $0020                                  ; $5366
    add hl, bc                                    ; $5369
    add $10                                       ; $536A
    call Vram_WriteByteSafe                       ; $536C
    pop hl                                        ; $536F
    inc hl                                        ; $5370
    ret                                           ; $5371


; C: SPACE FEVER II; BALL; RUN
HiScore_DrawScores::
    ld hl, $986b                                  ; $5372
    ld a, [wBestShooter + $3]                     ; $5375
    call HiScore_DrawBcdByte                      ; $5378
    ld a, [wBestShooter + $2]                     ; $537B
    call HiScore_DrawBcdByte                      ; $537E
    ld a, [wBestShooter + $1]                     ; $5381
    call HiScore_DrawBcdByte                      ; $5384
    ld a, [wBestShooter]                          ; $5387
    call HiScore_DrawBcdByte                      ; $538A
    ld hl, $98cf                                  ; $538D
    ld a, [wBestBall + $1]                        ; $5390
    call HiScore_DrawBcdByte                      ; $5393
    ld a, [wBestBall]                             ; $5396
    call HiScore_DrawBcdByte                      ; $5399
    ld hl, $992e                                  ; $539C
    ld a, [wBestRun + $1]                         ; $539F
    cpl                                           ; $53A2
    add $9a                                       ; $53A3
    call HiScore_DrawBcdByte                      ; $53A5
    inc hl                                        ; $53A8
    ld a, [wBestRun]                              ; $53A9
    cpl                                           ; $53AC
    add $9a                                       ; $53AD

; C
HiScore_DrawBcdByte::
    push af                                       ; $53AF
    swap a                                        ; $53B0
    and $0f                                       ; $53B2
    call HiScore_DrawTallDigit                    ; $53B4
    pop af                                        ; $53B7
    and $0f                                       ; $53B8

; C
HiScore_DrawTallDigit::
    push hl                                       ; $53BA
    call Vram_WriteByteSafe                       ; $53BB
    ld bc, $0020                                  ; $53BE
    add hl, bc                                    ; $53C1
    add $10                                       ; $53C2
    call Vram_WriteByteSafe                       ; $53C4
    pop hl                                        ; $53C7
    inc hl                                        ; $53C8
    ret                                           ; $53C9


; C: loads glyph list A (09:53D3) to $8800 with Kb_LoadGlyphList
Kb_LoadGlyphSetA::
    ld de, $8800                                  ; $53CA
    ld hl, Kb_GlyphListA                          ; $53CD
    jp Kb_LoadGlyphList                           ; $53D0


; C: glyph list read by Kb_LoadGlyphList: pairs (n, slot) = n glyphs from slot, ($80+n, slot) = n copies of slot, 0
; ends; slots index the 32-byte glyphs at 2A:4000 (was Kb_LoadGlyphSetA_Gfx53D3)
Kb_GlyphListA::
    dw $0024
    dw $ff01
    dw $2401
    dw $ff01
    dw $2501
    dw $2808
    dw $ff82
    dw $4b04
    dw $a401
    dw $3001
    dw $5005
    dw $3101
    db $00

; C: loads glyph list B (09:53F5) to $8800 with Kb_LoadGlyphList
Kb_LoadGlyphSetB::
    ld de, $8800                                  ; $53EC
    ld hl, Kb_GlyphListB                          ; $53EF
    jp Kb_LoadGlyphList                           ; $53F2


; C: glyph list read by Kb_LoadGlyphList: pairs (n, slot) = n glyphs from slot, ($80+n, slot) = n copies of slot, 0
; ends; slots index the 32-byte glyphs at 2A:4000 (was Kb_LoadGlyphSetB_Gfx53F5)
Kb_GlyphListB::
    dw $5524
    dw $ff01
    dw $7901
    dw $ff01
    dw $7a01
    dw $7d08
    dw $ff82
    dw $a004
    dw $a401
    dw $3001
    dw $a505
    dw $3101
    db $00

; C: loads glyph list C (09:5417) to $8800 with Kb_LoadGlyphList
Kb_LoadGlyphSetC::
    ld de, $8800                                  ; $540E
    ld hl, Kb_GlyphListC                          ; $5411
    jp Kb_LoadGlyphList                           ; $5414


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
    ld a, [hl+]                                   ; $5424
    and a                                         ; $5425
    ret z                                         ; $5426

    ld c, a                                       ; $5427
    ld b, $01                                     ; $5428
    bit 7, c                                      ; $542A
    jr z, jr_009_5433                             ; $542C

    res 7, c                                      ; $542E
    ld b, c                                       ; $5430
    ld c, $01                                     ; $5431

jr_009_5433:
    push hl                                       ; $5433
    ld a, [hl]                                    ; $5434
    push bc                                       ; $5435
    call Kb_GlyphOffset                           ; $5436
    ld hl, ScrollEngine_Step                      ; $5439
    add hl, bc                                    ; $543C
    pop bc                                        ; $543D
    push bc                                       ; $543E
    ld a, c                                       ; $543F
    call Kb_GlyphOffset                           ; $5440
    ld a, $2a                                     ; $5443
    call Vram_CopyFromBank                        ; $5445
    pop bc                                        ; $5448
    pop hl                                        ; $5449
    dec b                                         ; $544A
    jr nz, jr_009_5433                            ; $544B

    inc hl                                        ; $544D
    jr Kb_LoadGlyphList                           ; $544E

; C: BC = A x 32 (byte offset of glyph slot A)
Kb_GlyphOffset::
    swap a                                        ; $5450
    push af                                       ; $5452
    and $f0                                       ; $5453
    ld c, a                                       ; $5455
    pop af                                        ; $5456
    and $0f                                       ; $5457
    ld b, a                                       ; $5459
    sla c                                         ; $545A
    rl b                                          ; $545C
    ret                                           ; $545E


; C: A = key index ($DA3C), HL = one of the three glyph lists Kb_GlyphListA/B/C (pairs {n, slot}, $80+n = n copies of
; the slot, 0 ends): returns the character code of the key = slot + 1 (0 for the blank run, slot $FF); the only caller
; is Kb_Page0_Press (09:5BE9), which stores it in the name at $DA4D + ...
Kb_FindCharInList::
    ld b, $00                                     ; $545F
    ld c, a                                       ; $5461
    inc c                                         ; $5462

jr_009_5463:
    ld a, [hl]                                    ; $5463
    and a                                         ; $5464
    ret z                                         ; $5465

    ld a, b                                       ; $5466
    cp c                                          ; $5467
    jr nc, jr_009_5480                            ; $5468

    ld a, [hl]                                    ; $546A
    res 7, a                                      ; $546B
    add b                                         ; $546D
    cp c                                          ; $546E
    jr c, jr_009_5480                             ; $546F

    bit 7, [hl]                                   ; $5471
    jr nz, jr_009_547c                            ; $5473

    inc hl                                        ; $5475
    dec c                                         ; $5476
    ld a, c                                       ; $5477
    sub b                                         ; $5478
    add [hl]                                      ; $5479
    inc a                                         ; $547A
    ret                                           ; $547B


jr_009_547c:
    inc hl                                        ; $547C
    ld a, [hl]                                    ; $547D
    inc a                                         ; $547E
    ret                                           ; $547F


jr_009_5480:
    ld a, [hl]                                    ; $5480
    res 7, a                                      ; $5481
    add b                                         ; $5483
    ld b, a                                       ; $5484
    inc hl                                        ; $5485
    inc hl                                        ; $5486
    jr jr_009_5463                                ; $5487

; C: owner_id at $99CA
OwnerCard_DrawOwnerId::
    ld de, $99ca                                  ; $5489
    ld hl, wOwnerId                               ; $548C
    ld b, $04                                     ; $548F
    call OwnerCard_DrawDigits                     ; $5491
    ret                                           ; $5494


; C
OwnerCard_DrawDigits::
    push bc                                       ; $5495
    push hl                                       ; $5496
    xor a                                         ; $5497

jr_009_5498:
    or [hl]                                       ; $5498
    inc hl                                        ; $5499
    dec b                                         ; $549A
    jr nz, jr_009_5498                            ; $549B

    pop hl                                        ; $549D
    pop bc                                        ; $549E
    and a                                         ; $549F
    jp nz, OwnerCard_DrawNumber_NonZero           ; $54A0

    sla b                                         ; $54A3

jr_009_54a5:
    push bc                                       ; $54A5
    ld h, d                                       ; $54A6
    ld l, e                                       ; $54A7
    ld a, $aa                                     ; $54A8
    call Vram_WriteByteSafe                       ; $54AA
    ld bc, $0020                                  ; $54AD
    add hl, bc                                    ; $54B0
    ld a, $ab                                     ; $54B1
    call Vram_WriteByteSafe                       ; $54B3
    inc de                                        ; $54B6
    pop bc                                        ; $54B7
    dec b                                         ; $54B8
    jr nz, jr_009_54a5                            ; $54B9

    ret                                           ; $54BB


; C: owner_name to tiles at $8800
OwnerCard_LoadNameGlyphs::
    ld hl, wOwnerName                             ; $54BC
    ld de, $8800                                  ; $54BF
    ld b, $09                                     ; $54C2

jr_009_54c4:
    push bc                                       ; $54C4
    ld a, [hl+]                                   ; $54C5
    push hl                                       ; $54C6
    ld c, $2a                                     ; $54C7
    ld hl, $6000                                  ; $54C9
    call Glyph_LoadFromCharCode                   ; $54CC
    pop hl                                        ; $54CF
    pop bc                                        ; $54D0
    dec b                                         ; $54D1
    jr nz, jr_009_54c4                            ; $54D2

    ret                                           ; $54D4


; C: tiles at $9580
OwnerCard_LoadNameGlyphsB::
    ld hl, wOwnerName                             ; $54D5
    ld de, $9580                                  ; $54D8
    ld b, $09                                     ; $54DB

jr_009_54dd:
    push bc                                       ; $54DD
    ld a, [hl+]                                   ; $54DE
    push hl                                       ; $54DF
    ld c, $2a                                     ; $54E0
    ld hl, ScrollEngine_Step                      ; $54E2
    call Glyph_LoadFromCharCode                   ; $54E5
    pop hl                                        ; $54E8
    pop bc                                        ; $54E9
    dec b                                         ; $54EA
    jr nz, jr_009_54dd                            ; $54EB

    ret                                           ; $54ED


; C: table 09:5509
OwnerCard_DrawGender::
    ld a, [wOwnerGenderBlood]                     ; $54EE
    and $03                                       ; $54F1
    ld c, a                                       ; $54F3
    ld b, $00                                     ; $54F4
    ld hl, OwnerCard_DrawGender_Map5509           ; $54F6
    add hl, bc                                    ; $54F9
    ld a, [hl]                                    ; $54FA
    ld hl, $9911                                  ; $54FB
    call Vram_WriteByteSafe                       ; $54FE
    inc a                                         ; $5501
    ld hl, $9931                                  ; $5502
    call Vram_WriteByteSafe                       ; $5505
    ret                                           ; $5508


; C: auto: 3 bytes, tile map; referenced by OwnerCard_DrawGender. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawGender_Map5509::
    db $aa, $a6, $a8

; C
OwnerCard_LoadGenderTiles::
    ld a, [wOwnerGenderBlood]                     ; $550C
    and $03                                       ; $550F
    swap a                                        ; $5511
    ld c, a                                       ; $5513
    ld b, $00                                     ; $5514
    sla c                                         ; $5516
    ld hl, $64c0                                  ; $5518
    add hl, bc                                    ; $551B
    ld a, $20                                     ; $551C
    ld de, $96a0                                  ; $551E
    ld bc, $0020                                  ; $5521
    call Vram_CopyFromBank                        ; $5524
    ret                                           ; $5527


; C
OwnerCard_DrawBirthDate::
    ld de, $9967                                  ; $5528
    ld hl, wOwnerBirthYear                        ; $552B
    ld b, $02                                     ; $552E
    call OwnerCard_DrawBirthNumber                ; $5530
    ld de, $996c                                  ; $5533
    ld hl, wOwnerBirthMonth                       ; $5536
    ld b, $01                                     ; $5539
    call OwnerCard_DrawBirthNumber                ; $553B
    ld de, $996f                                  ; $553E
    ld hl, wOwnerBirthDay                         ; $5541
    ld b, $01                                     ; $5544
    call OwnerCard_DrawBirthNumber                ; $5546
    ret                                           ; $5549


; C
OwnerCard_DrawBirthNumber::
    push bc                                       ; $554A
    push hl                                       ; $554B
    xor a                                         ; $554C

jr_009_554d:
    or [hl]                                       ; $554D
    inc hl                                        ; $554E
    dec b                                         ; $554F
    jr nz, jr_009_554d                            ; $5550

    pop hl                                        ; $5552
    pop bc                                        ; $5553
    and a                                         ; $5554
    jp nz, OwnerCard_DrawNumber_NonZero           ; $5555

    sla b                                         ; $5558

jr_009_555a:
    push bc                                       ; $555A
    ld h, d                                       ; $555B
    ld l, e                                       ; $555C
    ld a, $aa                                     ; $555D
    call Vram_WriteByteSafe                       ; $555F
    ld bc, $0020                                  ; $5562
    add hl, bc                                    ; $5565
    ld a, $ab                                     ; $5566
    call Vram_WriteByteSafe                       ; $5568
    inc de                                        ; $556B
    pop bc                                        ; $556C
    dec b                                         ; $556D
    jr nz, jr_009_555a                            ; $556E

    ret                                           ; $5570


; C
OwnerCard_LoadBirthTiles::
    ld de, $96c0                                  ; $5571
    ld hl, wOwnerBirthYear                        ; $5574
    ld b, $02                                     ; $5577
    call OwnerCard_LoadBirthNumberTiles           ; $5579
    ld hl, wOwnerBirthMonth                       ; $557C
    ld b, $01                                     ; $557F
    call OwnerCard_LoadBirthNumberTiles           ; $5581
    ld hl, wOwnerBirthDay                         ; $5584
    ld b, $01                                     ; $5587
    call OwnerCard_LoadBirthNumberTiles           ; $5589
    ret                                           ; $558C


; C
OwnerCard_LoadBirthNumberTiles::
    push bc                                       ; $558D
    push hl                                       ; $558E
    xor a                                         ; $558F

jr_009_5590:
    or [hl]                                       ; $5590
    inc hl                                        ; $5591
    dec b                                         ; $5592
    jr nz, jr_009_5590                            ; $5593

    pop hl                                        ; $5595
    pop bc                                        ; $5596
    and a                                         ; $5597
    jp nz, OwnerCard_LoadBirthNumberTiles_NonZero ; $5598

    sla b                                         ; $559B

jr_009_559d:
    push bc                                       ; $559D
    ld hl, $6660                                  ; $559E
    ld a, $20                                     ; $55A1
    ld bc, $0020                                  ; $55A3
    call Vram_CopyFromBank                        ; $55A6
    pop bc                                        ; $55A9
    dec b                                         ; $55AA
    jr nz, jr_009_559d                            ; $55AB

    ret                                           ; $55AD


; C: table 09:55CD
OwnerCard_DrawBloodType::
    ld a, [wOwnerGenderBlood]                     ; $55AE
    srl a                                         ; $55B1
    and $0e                                       ; $55B3
    ld c, a                                       ; $55B5
    ld b, $00                                     ; $55B6
    ld hl, OwnerCard_DrawBloodType_Map55CD        ; $55B8
    add hl, bc                                    ; $55BB
    ld a, [hl+]                                   ; $55BC
    push hl                                       ; $55BD
    ld hl, $9972                                  ; $55BE
    call Vram_WriteByteSafe                       ; $55C1
    pop hl                                        ; $55C4
    ld a, [hl]                                    ; $55C5
    ld hl, $9992                                  ; $55C6
    call Vram_WriteByteSafe                       ; $55C9
    ret                                           ; $55CC


; C: auto: 10 bytes, tile map; referenced by OwnerCard_DrawBloodType. L3 pass 2026-10-26: read in BGB in 1 replay(s)
; of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodType_Map55CD::
    db $ff, $af, $ff, $ac, $ff, $ad, $ff, $ae, $ac, $ad

; C
OwnerCard_LoadBloodTiles::
    ld a, [wOwnerGenderBlood]                     ; $55D7
    srl a                                         ; $55DA
    srl a                                         ; $55DC
    and $07                                       ; $55DE
    swap a                                        ; $55E0
    ld c, a                                       ; $55E2
    ld b, $00                                     ; $55E3
    sla c                                         ; $55E5
    rl b                                          ; $55E7
    sla c                                         ; $55E9
    rl b                                          ; $55EB
    ld hl, $6680                                  ; $55ED
    add hl, bc                                    ; $55F0
    ld a, $20                                     ; $55F1
    ld de, $97c0                                  ; $55F3
    ld bc, $0040                                  ; $55F6
    call Vram_CopyFromBank                        ; $55F9
    ret                                           ; $55FC


; C: non-zero number: loops B bytes at HL through OwnerCard_DrawBloodHigh (the all-zero case draws the placeholder)
; (branch target; code read 2026-10-19)
OwnerCard_LoadBirthNumberTiles_NonZero::
    ld a, [hl+]                                   ; $55FD
    call OwnerCard_DrawBloodHigh                  ; $55FE
    dec b                                         ; $5601
    jr nz, OwnerCard_LoadBirthNumberTiles_NonZero ; $5602

    ret                                           ; $5604


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodHigh::
    push bc                                       ; $5605
    push hl                                       ; $5606
    push af                                       ; $5607
    swap a                                        ; $5608
    and $0f                                       ; $560A
    call OwnerCard_DrawBloodLow                   ; $560C
    pop af                                        ; $560F
    and $0f                                       ; $5610
    call OwnerCard_DrawBloodLow                   ; $5612
    pop hl                                        ; $5615
    pop bc                                        ; $5616
    ret                                           ; $5617


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLow::
    and a                                         ; $5618
    jr z, jr_009_561c                             ; $5619

    dec a                                         ; $561B

jr_009_561c:
    swap a                                        ; $561C
    ld c, a                                       ; $561E
    ld b, $00                                     ; $561F
    sla c                                         ; $5621
    rl b                                          ; $5623
    ld hl, $6520                                  ; $5625
    add hl, bc                                    ; $5628
    ld a, $20                                     ; $5629
    ld bc, $0020                                  ; $562B
    call Vram_CopyFromBank                        ; $562E
    ret                                           ; $5631


; C: non-zero number, shared by OwnerCard_DrawDigits (54A0) and OwnerCard_DrawBirthNumber (5555): loops B bytes at HL
; through OwnerCard_DrawBloodHighB (branch target; code read 2026-10-19)
OwnerCard_DrawNumber_NonZero::
    ld a, [hl+]                                   ; $5632
    call OwnerCard_DrawBloodHighB                 ; $5633
    dec b                                         ; $5636
    jr nz, OwnerCard_DrawNumber_NonZero           ; $5637

    ret                                           ; $5639


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodHighB::
    push bc                                       ; $563A
    push hl                                       ; $563B
    push af                                       ; $563C
    swap a                                        ; $563D
    and $0f                                       ; $563F
    call OwnerCard_DrawBloodLowB                  ; $5641
    pop af                                        ; $5644
    and $0f                                       ; $5645
    call OwnerCard_DrawBloodLowB                  ; $5647
    pop hl                                        ; $564A
    pop bc                                        ; $564B
    ret                                           ; $564C


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLowB::
    ld h, d                                       ; $564D
    ld l, e                                       ; $564E
    and a                                         ; $564F
    jr z, jr_009_5653                             ; $5650

    dec a                                         ; $5652

jr_009_5653:
    push hl                                       ; $5653
    ld c, a                                       ; $5654
    ld b, $00                                     ; $5655
    ld hl, OwnerCard_DrawBloodLowB_Tbl566A        ; $5657
    add hl, bc                                    ; $565A
    ld a, [hl]                                    ; $565B
    pop hl                                        ; $565C
    call Vram_WriteByteSafe                       ; $565D
    ld bc, $0020                                  ; $5660
    add hl, bc                                    ; $5663
    inc a                                         ; $5664
    call Vram_WriteByteSafe                       ; $5665
    inc de                                        ; $5668
    ret                                           ; $5669


; C: auto: 11 bytes, bytes; referenced by OwnerCard_DrawBloodLowB. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 08 (tcrf_check/assets/l3_names/)
OwnerCard_DrawBloodLowB_Tbl566A::
    db $92, $94, $96, $98, $9a, $9c, $9e, $a0, $a2, $a4, $aa

; C: name keyboard; tab page 0
Kb_Page0_Draw::
    call Kb_DrawTabPages                          ; $5675
    call Kb_DrawTabs                              ; $5678
    call Kb_DrawCursor                            ; $567B
    ld hl, Kb_Page0_Draw_Tbl5685                  ; $567E
    call Kb_DrawKeyHighlight                      ; $5681
    ret                                           ; $5684


; C: 80 key highlight positions {y, x} (y = 3C, 4C, 5C, 6C, 7C; x from 08 to 90, then 70 / 88 repeated for the wide
; keys), entry n for the key index $DA3C = n; Kb_DrawKeyHighlight (09:58C2) loads C = y, B = x and draws the blinking
; marker $A3 with Oam_AddMeta_B02_5272 when $FFC8 & $0F >= 4 (C). ...
Kb_Page0_Draw_Tbl5685::
    db $3c, $08, $3c, $10, $3c, $18, $3c, $20, $3c, $28, $4c, $08, $4c, $10, $4c, $18
    db $4c, $20, $4c, $28, $5c, $08, $5c, $10, $5c, $18, $5c, $20, $5c, $28, $6c, $08
    db $6c, $10, $6c, $18, $6c, $20, $6c, $28, $7c, $08, $7c, $10, $7c, $18, $7c, $20
    db $7c, $28, $3c, $38, $3c, $40, $3c, $48, $3c, $50, $3c, $58, $4c, $38, $4c, $40
    db $4c, $48, $4c, $50, $4c, $58, $5c, $38, $5c, $40, $5c, $48, $5c, $50, $5c, $58
    db $6c, $38, $6c, $40, $6c, $48, $6c, $50, $6c, $58, $7c, $38, $7c, $40, $7c, $48
    db $7c, $50, $7c, $58, $3c, $68, $3c, $70, $3c, $78, $3c, $80, $3c, $88, $3c, $90
    db $4c, $68, $4c, $70, $4c, $78, $4c, $80, $4c, $88, $4c, $90, $5c, $70, $5c, $70
    db $5c, $70, $5c, $88, $5c, $88, $5c, $88, $6c, $70, $6c, $70, $6c, $70, $6c, $88
    db $6c, $88, $6c, $88, $7c, $70, $7c, $70, $7c, $70, $7c, $88, $7c, $88, $7c, $88

; C
Kb_Page1_Draw::
    call Kb_DrawTabs                              ; $5725
    call Kb_DrawCursor                            ; $5728
    ld hl, Kb_Page1_Draw_Tbl5732                  ; $572B
    call Kb_DrawKeyHighlight                      ; $572E
    ret                                           ; $5731


; C: 10 key highlight positions {y, x} of page 1 of the keyboard, entry n for the key index $DA3C = n (Kb_Page1_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page1_Draw_Tbl5732::
    db $3c, $18, $3c, $30, $3c, $48, $3c, $70, $3c, $88, $7c, $88, $7c, $88, $7c, $88
    db $7c, $88, $7c, $88

; C
Kb_Page2_Draw::
    call Kb_DrawTabs                              ; $5746
    call Kb_DrawCursor                            ; $5749
    ld hl, Kb_Page2_Draw_Tbl5753                  ; $574C
    call Kb_DrawKeyHighlight                      ; $574F
    ret                                           ; $5752


; C: 24 key highlight positions {y, x} of page 2 of the keyboard, entry n for the key index $DA3C = n (Kb_Page2_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page2_Draw_Tbl5753::
    db $3c, $10, $3c, $20, $3c, $30, $3c, $40, $3c, $50, $3c, $60, $3c, $70, $3c, $80
    db $54, $10, $54, $20, $54, $30, $54, $30, $54, $70, $54, $70, $54, $70, $54, $88
    db $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88

; C
Kb_Page3_Draw::
    call Kb_DrawTabs                              ; $5783
    call Kb_DrawCursor                            ; $5786
    ld hl, Kb_Page3_Draw_Tbl5790                  ; $5789
    call Kb_DrawKeyHighlight                      ; $578C
    ret                                           ; $578F


; C: 18 key highlight positions {y, x} of page 3 of the keyboard, entry n for the key index $DA3C = n (Kb_Page3_Draw
; -> Kb_DrawKeyHighlight, marker $A3 blinking with $FFC8 & $0F >= 4) (C)
Kb_Page3_Draw_Tbl5790::
    db $3c, $14, $3c, $2c, $3c, $44, $3c, $5c, $3c, $74, $3c, $74, $54, $70, $54, $70
    db $54, $70, $54, $70, $54, $70, $54, $88, $7c, $88, $7c, $88, $7c, $88, $7c, $88
    db $7c, $88, $7c, $88

; C
Kb_DrawTabs::
    ld a, [wKbPage]                               ; $57B4
    ld c, a                                       ; $57B7
    ld b, $00                                     ; $57B8
    ld hl, Kb_DrawTabs_Tbl57D7                    ; $57BA
    add hl, bc                                    ; $57BD
    ld e, [hl]                                    ; $57BE
    ldh a, [hFrameCounter]                        ; $57BF
    srl a                                         ; $57C1
    srl a                                         ; $57C3
    srl a                                         ; $57C5
    and $03                                       ; $57C7
    ld c, a                                       ; $57C9
    ld hl, Kb_DrawTabs_Tbl57DD                    ; $57CA
    add hl, bc                                    ; $57CD
    ld a, [hl]                                    ; $57CE
    add e                                         ; $57CF
    ld bc, $1d1b                                  ; $57D0
    call Oam_AddMeta_B02_5272                     ; $57D3
    ret                                           ; $57D6


; C: base meta-sprite id of the page marker, indexed by the page $DA3D (0-5): 97 97 97 9A 9D A0; Kb_DrawTabs adds
; Tbl57DD[($FFC8 >> 3) & 3] and draws it at x = $1D, y = $1B (Oam_AddMeta_B02_5272) (C)
Kb_DrawTabs_Tbl57D7::
    db $97, $97, $97, $9a, $9d, $a0

; C: 4 frame offsets 0, 1, 0, 2 of the page marker, selected by ($FFC8 >> 3) & 3 (Kb_DrawTabs) (C)
Kb_DrawTabs_Tbl57DD::
    db $00, $01, $00, $02

; C
Kb_DrawCursor::
    ld a, [wKbPage]                               ; $57E1
    cp $04                                        ; $57E4
    jr z, jr_009_580b                             ; $57E6

    sla a                                         ; $57E8
    ld c, a                                       ; $57EA
    ld b, $00                                     ; $57EB
    ld hl, Kb_DrawCursor_Tbl5827                  ; $57ED
    add hl, bc                                    ; $57F0
    ld c, [hl]                                    ; $57F1
    inc hl                                        ; $57F2
    ld a, [wKbCursor]                             ; $57F3
    sla a                                         ; $57F6
    sla a                                         ; $57F8
    sla a                                         ; $57FA
    add [hl]                                      ; $57FC
    ld b, a                                       ; $57FD
    ldh a, [hFrameCounter]                        ; $57FE
    and $0f                                       ; $5800
    cp $04                                        ; $5802
    ret c                                         ; $5804

    ld a, $a4                                     ; $5805
    call Oam_AddMeta_B02_5272                     ; $5807
    ret                                           ; $580A


jr_009_580b:
    ld a, [wKbCursor]                             ; $580B
    sla a                                         ; $580E
    ld c, a                                       ; $5810
    ld b, $00                                     ; $5811
    ld hl, Kb_DrawCursor_Tbl5833                  ; $5813
    add hl, bc                                    ; $5816
    ld c, [hl]                                    ; $5817
    inc hl                                        ; $5818
    ld b, [hl]                                    ; $5819
    ldh a, [hFrameCounter]                        ; $581A
    and $0f                                       ; $581C
    cp $04                                        ; $581E
    ret c                                         ; $5820

    ld a, $a4                                     ; $5821
    call Oam_AddMeta_B02_5272                     ; $5823
    ret                                           ; $5826


; C: 6 x {y, x of the first character} of the blinking cursor, indexed by the page $DA3D (pages 0-3: 19/28, 19/28,
; 19/28, 19/80; entry 4 = 29/28 is never used because page 4 branches to Kb_DrawCursor_Tbl5833; entry 5 = 29/84); the
; cursor sprite $A4 is drawn at x + 8 x $DA3B (name position) when $FFC8 & ...
Kb_DrawCursor_Tbl5827::
    db $19, $28, $19, $28, $19, $28, $19, $80, $29, $28, $29, $84

; C: 8 x {y, x} cursor positions of page 4 (y = 29; x = 28, 30, 38, 40, 50, 58, 68, 70), indexed by $DA3B:
; Kb_DrawCursor (09:57E1) uses it instead of Kb_DrawCursor_Tbl5827 when $DA3D = 4 (C)
Kb_DrawCursor_Tbl5833::
    db $29, $28, $29, $30, $29, $38, $29, $40, $29, $50, $29, $58, $29, $68, $29, $70

; C: draws the three page tabs (meta $91 + frame / $93 + frame / $95 + frame, frame from Kb_TabAnimFrame, at the
; positions (x,y) $68/$74, $80/$74, $68/$84 given as immediate `ld bc`) and, for pages 0 and 1 only ($DA3D < 2), two
; more sprites: $8F at (x $50, y $7C) and $90 at (x $58, y $7C) (C)
Kb_DrawTabPages::
    ld c, $00                                     ; $5843
    call Kb_TabAnimFrame                          ; $5845
    add $91                                       ; $5848
    ld bc, $6874                                  ; $584A
    call Oam_AddMeta_B02_5272                     ; $584D
    ld c, $01                                     ; $5850
    call Kb_TabAnimFrame                          ; $5852
    add $93                                       ; $5855
    ld bc, $8074                                  ; $5857
    call Oam_AddMeta_B02_5272                     ; $585A
    ld c, $02                                     ; $585D
    call Kb_TabAnimFrame                          ; $585F
    add $95                                       ; $5862
    ld bc, $6884                                  ; $5864
    call Oam_AddMeta_B02_5272                     ; $5867
    ld a, [wKbPage]                               ; $586A
    cp $02                                        ; $586D
    ret nc                                        ; $586F

    ld bc, $507c                                  ; $5870
    ld a, $8f                                     ; $5873
    call Oam_AddMeta_B02_5272                     ; $5875
    ld bc, $587c                                  ; $5878
    ld a, $90                                     ; $587B
    call Oam_AddMeta_B02_5272                     ; $587D
    ret                                           ; $5880


; C
Kb_TabAnimFrame::
    ld b, $00                                     ; $5881
    ld hl, wKbTabFrame                            ; $5883
    add hl, bc                                    ; $5886
    ld e, [hl]                                    ; $5887
    sla e                                         ; $5888
    ld d, $00                                     ; $588A
    ld hl, Kb_TabAnimFrame_Tbl58B4                ; $588C
    add hl, de                                    ; $588F
    ld a, [hl+]                                   ; $5890
    push af                                       ; $5891
    push hl                                       ; $5892
    ld hl, wKbTabTick                             ; $5893
    add hl, bc                                    ; $5896
    ld a, [hl]                                    ; $5897
    pop hl                                        ; $5898
    cp [hl]                                       ; $5899
    jr c, jr_009_58ac                             ; $589A

    ld hl, wKbTabFrame                            ; $589C
    add hl, bc                                    ; $589F
    ld a, [hl]                                    ; $58A0
    and a                                         ; $58A1
    jr z, jr_009_58aa                             ; $58A2

    inc a                                         ; $58A4
    cp $07                                        ; $58A5
    jr c, jr_009_58aa                             ; $58A7

    xor a                                         ; $58A9

jr_009_58aa:
    ld [hl], a                                    ; $58AA
    xor a                                         ; $58AB

jr_009_58ac:
    inc a                                         ; $58AC
    ld hl, wKbTabTick                             ; $58AD
    add hl, bc                                    ; $58B0
    ld [hl], a                                    ; $58B1
    pop af                                        ; $58B2
    ret                                           ; $58B3


; C: 7 phases {frame 0/1, duration in frames}: 00/4, 00/4, 01/4, 00/3, 01/3, 00/2, 01/2 (accelerating blink);
; Kb_TabAnimFrame (09:5881) advances the phase $DA41 + tab when its counter $DA3E + tab reaches the duration, 0 =
; idle, wraps 7 -> 0, and returns the frame added to the tab meta id (C)
Kb_TabAnimFrame_Tbl58B4::
    db $00, $04, $00, $04, $01, $04, $00, $03, $01, $03, $00, $02, $01, $02

; C
Kb_DrawKeyHighlight::
    ld a, [wKbKey]                                ; $58C2
    ld c, a                                       ; $58C5
    ld b, $00                                     ; $58C6
    sla c                                         ; $58C8
    rl b                                          ; $58CA
    add hl, bc                                    ; $58CC
    ld c, [hl]                                    ; $58CD
    inc hl                                        ; $58CE
    ld b, [hl]                                    ; $58CF
    ldh a, [hFrameCounter]                        ; $58D0
    and $0f                                       ; $58D2
    cp $04                                        ; $58D4
    ret c                                         ; $58D6

    ld a, $a3                                     ; $58D7
    call Oam_AddMeta_B02_5272                     ; $58D9
    ret                                           ; $58DC


; C: key map tables 09:58EA / 593B / 598B
Kb_Page0_Navigate::
    ld bc, Kb_Page0_NavPosToIndexTbl              ; $58DD
    ld de, Kb_Page0_NavLimitsTbl                  ; $58E0
    ld hl, Kb_Page0_NavIndexToPosTbl              ; $58E3
    call Kb_NavigateGeneric                       ; $58E6
    ret                                           ; $58E9


; C: byte 0 = last row; then one byte per grid position (row<<4|col): steps allowed to the left << 4 | steps allowed
; to the right; read by Kb_NavigateGeneric (DE) from Kb_Page0_Navigate
Kb_Page0_NavLimitsTbl::
    db $04, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
    db $10, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
    db $10, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $14, $23, $32, $20, $30
    db $40, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $14, $23, $32, $20, $30
    db $40, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $14, $23, $32, $20, $30
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
    ld bc, Kb_Page1_NavPosToIndexTbl              ; $59DB
    ld de, Kb_Page1_NavLimitsTbl                  ; $59DE
    ld hl, Kb_Page1_NavIndexToPosTbl              ; $59E1
    call Kb_NavigateGeneric                       ; $59E4
    ret                                           ; $59E7


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
    ld bc, Kb_Page2_NavPosToIndexTbl              ; $5A33
    ld de, Kb_Page2_NavLimitsTbl                  ; $5A36
    ld hl, Kb_Page2_NavIndexToPosTbl              ; $5A39
    call Kb_NavigateGeneric                       ; $5A3C
    ret                                           ; $5A3F


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
    ld bc, Kb_Page3_NavPosToIndexTbl              ; $5AB9
    ld de, Kb_Page3_NavLimitsTbl                  ; $5ABC
    ld hl, Kb_Page3_NavIndexToPosTbl              ; $5ABF
    call Kb_NavigateGeneric                       ; $5AC2
    ret                                           ; $5AC5


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
    push bc                                       ; $5B39
    push de                                       ; $5B3A
    ld a, [wKbKey]                                ; $5B3B
    ld c, a                                       ; $5B3E
    ld b, $00                                     ; $5B3F
    add hl, bc                                    ; $5B41
    ld a, [hl]                                    ; $5B42
    ld c, a                                       ; $5B43
    ld b, $00                                     ; $5B44
    pop hl                                        ; $5B46
    ld e, [hl]                                    ; $5B47
    inc hl                                        ; $5B48
    add hl, bc                                    ; $5B49
    ld d, [hl]                                    ; $5B4A
    push af                                       ; $5B4B
    and $0f                                       ; $5B4C
    call Kb_NavigateHorizontal                    ; $5B4E
    ld c, a                                       ; $5B51
    pop af                                        ; $5B52
    swap a                                        ; $5B53
    and $0f                                       ; $5B55
    call Kb_NavigateVertical                      ; $5B57
    swap a                                        ; $5B5A
    or c                                          ; $5B5C
    ld c, a                                       ; $5B5D
    pop hl                                        ; $5B5E
    add hl, bc                                    ; $5B5F
    ld a, [hl]                                    ; $5B60
    ld hl, wKbKey                                 ; $5B61
    cp [hl]                                       ; $5B64
    ret z                                         ; $5B65

    ld [hl], a                                    ; $5B66
    push af                                       ; $5B67
    ld a, SFX1_STEP_FAST                          ; $5B68
    call Snd_Sfx1                                 ; $5B6A
    pop af                                        ; $5B6D
    ret                                           ; $5B6E


; C: grid step up / down: A = row, E = last row; $FFA3 bit 6 (Up newly pressed) decrements unless the row is 0, bit 7
; (Down) increments unless the row is E; returns the new row in A (C)
Kb_NavigateVertical::
    ld hl, hKeysNewRepeat                         ; $5B6F
    bit 6, [hl]                                   ; $5B72
    jr z, jr_009_5b7a                             ; $5B74

    and a                                         ; $5B76
    ret z                                         ; $5B77

    dec a                                         ; $5B78
    ret                                           ; $5B79


jr_009_5b7a:
    bit 7, [hl]                                   ; $5B7A
    ret z                                         ; $5B7C

    cp e                                          ; $5B7D
    ret z                                         ; $5B7E

    inc a                                         ; $5B7F
    ret                                           ; $5B80


; C: grid step left / right: A = column, D = step limits of the row (high nibble = left step, low nibble = right
; step); $FFA3 bit 5 (Left) subtracts the high nibble, bit 4 (Right) adds the low nibble; returns A (C)
Kb_NavigateHorizontal::
    ld hl, hKeysNewRepeat                         ; $5B81
    bit 5, [hl]                                   ; $5B84
    jr z, jr_009_5b92                             ; $5B86

    push af                                       ; $5B88
    ld a, d                                       ; $5B89
    swap a                                        ; $5B8A
    and $0f                                       ; $5B8C
    ld d, a                                       ; $5B8E
    pop af                                        ; $5B8F
    sub d                                         ; $5B90
    ret                                           ; $5B91


jr_009_5b92:
    bit 4, [hl]                                   ; $5B92
    ret z                                         ; $5B94

    push af                                       ; $5B95
    ld a, d                                       ; $5B96
    and $0f                                       ; $5B97
    ld d, a                                       ; $5B99
    pop af                                        ; $5B9A
    add d                                         ; $5B9B
    ret                                           ; $5B9C


; C: A on a key; handlers via table 09:5C0E
Kb_Page0_Press::
    ldh a, [hKeysNew]                             ; $5B9D
    bit PADB_A, a                                 ; $5B9F
    ret z                                         ; $5BA1

    ld a, [wKbKey]                                ; $5BA2
    cp $4d                                        ; $5BA5
    jp nc, Kb_Page0_Press_ToPage1                 ; $5BA7

    cp $4a                                        ; $5BAA
    jp nc, Kb_Page0_Press_GlyphSetC               ; $5BAC

    cp $47                                        ; $5BAF
    jp nc, Kb_Page0_Press_GlyphSetB               ; $5BB1

    cp $44                                        ; $5BB4
    jp nc, Kb_Page0_Press_GlyphSetA               ; $5BB6

    cp $41                                        ; $5BB9
    jp nc, Kb_Page0_Press_CursorLeft              ; $5BBB

    cp $3e                                        ; $5BBE
    jp nc, Kb_Page0_Press_CursorRight             ; $5BC0

    ld a, [wKbPage]                               ; $5BC3
    cp $02                                        ; $5BC6
    jr nc, jr_009_5bd7                            ; $5BC8

    ld a, [wKbKey]                                ; $5BCA
    cp $30                                        ; $5BCD
    jp z, Kb_Page0_Press_Dakuten                  ; $5BCF

    cp $31                                        ; $5BD2
    jp z, Kb_Page0_Press_Handakuten               ; $5BD4

jr_009_5bd7:
    ld a, [wKbPage]                               ; $5BD7
    sla a                                         ; $5BDA
    ld c, a                                       ; $5BDC
    ld b, $00                                     ; $5BDD
    ld hl, Kb_Page0_Press_PtrTbl5C0E              ; $5BDF
    add hl, bc                                    ; $5BE2
    ld a, [hl+]                                   ; $5BE3
    ld h, [hl]                                    ; $5BE4
    ld l, a                                       ; $5BE5
    ld a, [wKbKey]                                ; $5BE6
    call Kb_FindCharInList                        ; $5BE9
    push af                                       ; $5BEC
    ld a, [wKbCursor]                             ; $5BED
    ld c, a                                       ; $5BF0
    ld b, $00                                     ; $5BF1
    ld hl, wOwnerName                             ; $5BF3
    add hl, bc                                    ; $5BF6
    pop af                                        ; $5BF7
    ld [hl], a                                    ; $5BF8
    call Kb_WriteNameChar                         ; $5BF9
    push af                                       ; $5BFC
    ld a, SFX1_KEY_A                              ; $5BFD
    call Snd_Sfx1                                 ; $5BFF
    pop af                                        ; $5C02
    ld a, [wKbCursor]                             ; $5C03
    cp $08                                        ; $5C06
    ret z                                         ; $5C08

    inc a                                         ; $5C09
    ld [wKbCursor], a                             ; $5C0A
    ret                                           ; $5C0D


; C: 3 pointers to Kb_GlyphListA / B / C (09:53D3, 53F5, 5417) indexed by the page $DA3D (0-2); Kb_Page0_Press passes
; the selected list to Kb_FindCharInList (C)
Kb_Page0_Press_PtrTbl5C0E::
    dw Kb_GlyphListA
    dw Kb_GlyphListB
    dw Kb_GlyphListC

; C: keys $3E-$40 of the name page: name cursor $DA3B + 1 (sfx $21); at the ninth place the page changes
; (Kb_Page0_Press_ToPage1) (branch target; code read 2026-10-19)
Kb_Page0_Press_CursorRight::
    ld a, [wKbCursor]                             ; $5C14
    cp $08                                        ; $5C17
    jp z, Kb_Page0_Press_ToPage1                  ; $5C19

    inc a                                         ; $5C1C
    ld [wKbCursor], a                             ; $5C1D
    push af                                       ; $5C20
    ld a, SFX1_STEP_VALUE                         ; $5C21
    call Snd_Sfx1                                 ; $5C23
    pop af                                        ; $5C26
    ret                                           ; $5C27


; C: keys $41-$43 of the name page: name cursor $DA3B - 1 (sfx 4), nothing at 0 (branch target; code read 2026-10-19)
Kb_Page0_Press_CursorLeft::
    ld a, [wKbCursor]                             ; $5C28
    and a                                         ; $5C2B
    ret z                                         ; $5C2C

    dec a                                         ; $5C2D
    ld [wKbCursor], a                             ; $5C2E
    push af                                       ; $5C31
    ld a, SFX1_KEY_B                              ; $5C32
    call Snd_Sfx1                                 ; $5C34
    pop af                                        ; $5C37
    ret                                           ; $5C38


; C: keys $44-$46: glyph set A ($DA41 = 1, $DA3D = 0, Kb_LoadGlyphSetA, sfx $38) (branch target; code read 2026-10-19)
Kb_Page0_Press_GlyphSetA::
    ld a, $01                                     ; $5C39
    ld [wKbTabFrame], a                           ; $5C3B
    xor a                                         ; $5C3E
    ld [wKbPage], a                               ; $5C3F
    call Kb_LoadGlyphSetA                         ; $5C42
    push af                                       ; $5C45
    ld a, SFX1_CURSOR_MOVE                        ; $5C46
    call Snd_Sfx1                                 ; $5C48
    pop af                                        ; $5C4B
    ret                                           ; $5C4C


; C: keys $47-$49: glyph set B ($DA42 = 1, $DA3D = 1, Kb_LoadGlyphSetB, sfx $38) (branch target; code read 2026-10-19)
Kb_Page0_Press_GlyphSetB::
    ld a, $01                                     ; $5C4D
    ld [wKbTabFrame + $1], a                      ; $5C4F
    ld a, $01                                     ; $5C52
    ld [wKbPage], a                               ; $5C54
    call Kb_LoadGlyphSetB                         ; $5C57
    push af                                       ; $5C5A
    ld a, SFX1_CURSOR_MOVE                        ; $5C5B
    call Snd_Sfx1                                 ; $5C5D
    pop af                                        ; $5C60
    ret                                           ; $5C61


; C: keys $4A-$4C: glyph set C ($DA43 = 1, $DA3D = 2, Kb_LoadGlyphSetC, sfx $38) (branch target; code read 2026-10-19)
Kb_Page0_Press_GlyphSetC::
    ld a, $01                                     ; $5C62
    ld [wKbTabFrame + $2], a                      ; $5C64
    ld a, $02                                     ; $5C67
    ld [wKbPage], a                               ; $5C69
    call Kb_LoadGlyphSetC                         ; $5C6C
    push af                                       ; $5C6F
    ld a, SFX1_CURSOR_MOVE                        ; $5C70
    call Snd_Sfx1                                 ; $5C72
    pop af                                        ; $5C75
    ret                                           ; $5C76


; C: key $30 with a kana set: HL = Kb_DakutenMapTbl, then Kb_ApplyMarkTable (branch target; code read 2026-10-19)
Kb_Page0_Press_Dakuten::
    ld hl, Kb_DakutenMapTbl                       ; $5C77
    jp Kb_ApplyMarkTable                          ; $5C7A


; C: voiced-mark map of the key $30: records {first code, count, new first code} ended by $FF: 06/0F/33, 1A/05/42,
; 58/01/86, 5B/0F/88, 6F/05/97. Kb_Page0_Press jumps to 09:5C77 for the key $30, loads this table and, for the
; character before the cursor, adds (code - first) to the new first code when the ...
Kb_DakutenMapTbl::
    PUSHC kana
    db "か", 15, "が"
    db "は", 5, "ば"
    db "ウ", 1, "ヴ"
    db "カ", 15, "ガ"
    db "ハ", 5, "バ"
    db $ff
    POPC

; C: key $31 with a kana set: HL = Kb_HandakutenMapTbl, then Kb_ApplyMarkTable (branch target; code read 2026-10-19)
Kb_Page0_Press_Handakuten::
    ld hl, Kb_HandakutenMapTbl                    ; $5C8D
    jp Kb_ApplyMarkTable                          ; $5C90


; C: semi-voiced-mark map of the key $31: records {first code, count, new first code} ended by $FF: 1A/05/47 and
; 6F/05/9C, i.e. the 5 h-row codes of hiragana (ha = 1A) and of katakana (ha = 6F) to the p row; same routine as
; Kb_DakutenMapTbl (09:5C9A) (C; the kana reading is I)
Kb_HandakutenMapTbl::
    PUSHC kana
    db "は", 5, "ぱ"
    db "ハ", 5, "パ"
    db $ff
    POPC

; C: HL = dakuten or handakuten map: looks for the last typed character (this place or the previous one) in the map
; ranges, replaces it, writes it with Kb_WriteNameChar and advances the cursor (branch target; code read 2026-10-19)
Kb_ApplyMarkTable::
    push hl                                       ; $5C9A
    ld a, [wKbCursor]                             ; $5C9B
    ld c, a                                       ; $5C9E
    ld b, $00                                     ; $5C9F
    ld hl, wOwnerName                             ; $5CA1
    add hl, bc                                    ; $5CA4
    ld a, [hl]                                    ; $5CA5
    and a                                         ; $5CA6
    jr nz, jr_009_5cb1                            ; $5CA7

    dec hl                                        ; $5CA9
    dec c                                         ; $5CAA
    bit 7, c                                      ; $5CAB
    jr z, jr_009_5cb1                             ; $5CAD

    pop hl                                        ; $5CAF
    ret                                           ; $5CB0


jr_009_5cb1:
    ld b, [hl]                                    ; $5CB1
    ld d, h                                       ; $5CB2
    ld e, l                                       ; $5CB3
    pop hl                                        ; $5CB4

jr_009_5cb5:
    ld a, b                                       ; $5CB5
    sub [hl]                                      ; $5CB6
    ret c                                         ; $5CB7

    inc hl                                        ; $5CB8
    cp [hl]                                       ; $5CB9
    jr nc, jr_009_5cd8                            ; $5CBA

    inc hl                                        ; $5CBC
    add [hl]                                      ; $5CBD
    ld [de], a                                    ; $5CBE
    ld a, c                                       ; $5CBF
    ld [wKbCursor], a                             ; $5CC0
    call Kb_WriteNameChar                         ; $5CC3
    push af                                       ; $5CC6
    ld a, SFX1_KEY_A                              ; $5CC7
    call Snd_Sfx1                                 ; $5CC9
    pop af                                        ; $5CCC
    ld a, [wKbCursor]                             ; $5CCD
    cp $08                                        ; $5CD0
    ret z                                         ; $5CD2

    inc a                                         ; $5CD3
    ld [wKbCursor], a                             ; $5CD4
    ret                                           ; $5CD7


jr_009_5cd8:
    inc hl                                        ; $5CD8
    inc hl                                        ; $5CD9
    ld a, [hl]                                    ; $5CDA
    cp $ff                                        ; $5CDB
    jr nz, jr_009_5cb5                            ; $5CDD

    ret                                           ; $5CDF


; C: keys $4D and up, or the cursor past the ninth place: loads the sex page (map 23:7620 to $98C0, tiles 20:64C0 to
; $8800), cursor 0, sfx $16, state + 1 (branch target; code read 2026-10-19)
Kb_Page0_Press_ToPage1::
    farcopy Vram_CopyFromBank, Map_23_7620_Kb_Page0_Press, $98c0, $0140 ; $5CE0
    farcopy Vram_CopyFromBank, Gfx_20_64C0_OwnerCard_LoadGenderTiles, $8800, $0300 ; $5CEE
    xor a                                         ; $5CFC
    ld [wKbCursor], a                             ; $5CFD
    ld a, [wKbKey]                                ; $5D00
    cp $3e                                        ; $5D03
    jr c, jr_009_5d0f                             ; $5D05

    cp $41                                        ; $5D07
    jr nc, jr_009_5d0f                            ; $5D09

    ld a, $03                                     ; $5D0B
    jr jr_009_5d10                                ; $5D0D

jr_009_5d0f:
    xor a                                         ; $5D0F

jr_009_5d10:
    ld [wKbKey], a                                ; $5D10
    ld a, $03                                     ; $5D13
    ld [wKbPage], a                               ; $5D15
    push af                                       ; $5D18
    ld a, SFX1_OPTION_CHANGE                      ; $5D19
    call Snd_Sfx1                                 ; $5D1B
    pop af                                        ; $5D1E
    next_state                                    ; $5D1F
    ret                                           ; $5D23


; C
Kb_Page1_PressSex::
    ldh a, [hKeysNew]                             ; $5D24
    bit PADB_A, a                                 ; $5D26
    ret z                                         ; $5D28

    ld a, [wKbKey]                                ; $5D29
    cp $05                                        ; $5D2C
    jp nc, Kb_Page1_PressSex_ToPage2              ; $5D2E

    cp $04                                        ; $5D31
    jp nc, Kb_Page1_PressSex_ToPage0              ; $5D33

    cp $03                                        ; $5D36
    jp nc, Kb_Page1_PressSex_ToPage2              ; $5D38

    ld a, [wOwnerGenderBlood]                     ; $5D3B
    and $fc                                       ; $5D3E
    ld hl, wKbKey                                 ; $5D40
    or [hl]                                       ; $5D43
    ld [wOwnerGenderBlood], a                     ; $5D44
    call OwnerCard_LoadGenderTiles                ; $5D47
    push af                                       ; $5D4A
    ld a, SFX1_KEY_A                              ; $5D4B
    call Snd_Sfx1                                 ; $5D4D
    pop af                                        ; $5D50
    ret                                           ; $5D51


; C: key 4 of the sex page: back to the name page (Kb_LoadGlyphSetA, map 23:74A0 to $98C0, key $41, sfx 4) (branch
; target; code read 2026-10-19)
Kb_Page1_PressSex_ToPage0::
    call Kb_LoadGlyphSetA                         ; $5D52
    farcopy Vram_CopyFromBank, Map_23_74A0_Kb_Page1_PressSex, $98c0, $0140 ; $5D55
    xor a                                         ; $5D63
    ld [wKbCursor], a                             ; $5D64
    ld [wKbPage], a                               ; $5D67
    ld a, $41                                     ; $5D6A
    ld [wKbKey], a                                ; $5D6C
    push af                                       ; $5D6F
    ld a, SFX1_KEY_B                              ; $5D70
    call Snd_Sfx1                                 ; $5D72
    pop af                                        ; $5D75
    ld hl, wState                                 ; $5D76
    dec [hl]                                      ; $5D79
    ret                                           ; $5D7A


; C: keys 3 and 5 and up of the sex page: loads the birth-date page (map 24:5DC0 to $98C0), key $0C when it was key 3,
; else 0 (branch target; code read 2026-10-19)
Kb_Page1_PressSex_ToPage2::
    farcopy Vram_CopyFromBank, Map_24_5DC0_Kb_Page1_PressSex, $98c0, $0140 ; $5D7B
    xor a                                         ; $5D89
    ld [wKbCursor], a                             ; $5D8A
    ld a, [wKbKey]                                ; $5D8D
    cp $03                                        ; $5D90
    jr nz, jr_009_5d98                            ; $5D92

    ld a, $0c                                     ; $5D94
    jr jr_009_5d99                                ; $5D96

jr_009_5d98:
    xor a                                         ; $5D98

jr_009_5d99:
    ld [wKbKey], a                                ; $5D99
    ld a, $04                                     ; $5D9C
    ld [wKbPage], a                               ; $5D9E
    push af                                       ; $5DA1
    ld a, SFX1_OPTION_CHANGE                      ; $5DA2
    call Snd_Sfx1                                 ; $5DA4
    pop af                                        ; $5DA7
    next_state                                    ; $5DA8
    ret                                           ; $5DAC


; C
Kb_Page2_PressBirthDate::
    ldh a, [hKeysNew]                             ; $5DAD
    bit PADB_A, a                                 ; $5DAF
    ret z                                         ; $5DB1

    ld a, [wKbKey]                                ; $5DB2
    cp $10                                        ; $5DB5
    jp nc, Kb_Page2_PressBirthDate_ToPage3        ; $5DB7

    cp $0f                                        ; $5DBA
    jp nc, Kb_Page2_PressBirthDate_CursorLeft     ; $5DBC

    cp $0c                                        ; $5DBF
    jp nc, Kb_Page2_PressBirthDate_CursorRight    ; $5DC1

    ld a, [wKbCursor]                             ; $5DC4
    srl a                                         ; $5DC7
    jr nc, jr_009_5de4                            ; $5DC9

    ld c, a                                       ; $5DCB
    ld b, $00                                     ; $5DCC
    ld hl, wOwnerBirthYear                        ; $5DCE
    add hl, bc                                    ; $5DD1
    ld a, [hl]                                    ; $5DD2
    and $f0                                       ; $5DD3
    ld c, a                                       ; $5DD5
    ld a, [wKbKey]                                ; $5DD6
    cp $0a                                        ; $5DD9
    jr c, jr_009_5ddf                             ; $5DDB

    ld a, $0a                                     ; $5DDD

jr_009_5ddf:
    inc a                                         ; $5DDF
    or c                                          ; $5DE0
    ld [hl], a                                    ; $5DE1
    jr jr_009_5dfd                                ; $5DE2

jr_009_5de4:
    ld c, a                                       ; $5DE4
    ld b, $00                                     ; $5DE5
    ld hl, wOwnerBirthYear                        ; $5DE7
    add hl, bc                                    ; $5DEA
    ld a, [hl]                                    ; $5DEB
    and $0f                                       ; $5DEC
    ld c, a                                       ; $5DEE
    ld a, [wKbKey]                                ; $5DEF
    cp $0a                                        ; $5DF2
    jr c, jr_009_5df8                             ; $5DF4

    ld a, $0a                                     ; $5DF6

jr_009_5df8:
    inc a                                         ; $5DF8
    swap a                                        ; $5DF9
    or c                                          ; $5DFB
    ld [hl], a                                    ; $5DFC

jr_009_5dfd:
    call OwnerCard_LoadBirthTiles                 ; $5DFD
    push af                                       ; $5E00
    ld a, SFX1_KEY_A                              ; $5E01
    call Snd_Sfx1                                 ; $5E03
    pop af                                        ; $5E06
    ld a, [wKbCursor]                             ; $5E07
    cp $07                                        ; $5E0A
    ret z                                         ; $5E0C

    inc a                                         ; $5E0D
    ld [wKbCursor], a                             ; $5E0E
    ret                                           ; $5E11


; C: keys $0C-$0E: date cursor $DA3B + 1 (sfx $21); past the eighth place goes to the blood-type page (branch target;
; code read 2026-10-19)
Kb_Page2_PressBirthDate_CursorRight::
    ld a, [wKbCursor]                             ; $5E12
    cp $07                                        ; $5E15
    jr z, Kb_Page2_PressBirthDate_ToPage3         ; $5E17

    inc a                                         ; $5E19
    ld [wKbCursor], a                             ; $5E1A
    push af                                       ; $5E1D
    ld a, SFX1_STEP_VALUE                         ; $5E1E
    call Snd_Sfx1                                 ; $5E20
    pop af                                        ; $5E23
    ret                                           ; $5E24


; C: key $0F: date cursor $DA3B - 1 (sfx 4), at 0 leaves the page (branch target; code read 2026-10-19)
Kb_Page2_PressBirthDate_CursorLeft::
    ld a, [wKbCursor]                             ; $5E25
    and a                                         ; $5E28
    jr z, jr_009_5e37                             ; $5E29

    dec a                                         ; $5E2B
    ld [wKbCursor], a                             ; $5E2C
    push af                                       ; $5E2F
    ld a, SFX1_KEY_B                              ; $5E30
    call Snd_Sfx1                                 ; $5E32
    pop af                                        ; $5E35
    ret                                           ; $5E36


jr_009_5e37:
    farcopy Vram_CopyFromBank, Map_23_7620_Kb_Page0_Press, $98c0, $0140 ; $5E37
    xor a                                         ; $5E45
    ld [wKbCursor], a                             ; $5E46
    ld a, $04                                     ; $5E49
    ld [wKbKey], a                                ; $5E4B
    ld a, $03                                     ; $5E4E
    ld [wKbPage], a                               ; $5E50
    push af                                       ; $5E53
    ld a, SFX1_KEY_B                              ; $5E54
    call Snd_Sfx1                                 ; $5E56
    pop af                                        ; $5E59
    ld hl, wState                                 ; $5E5A
    dec [hl]                                      ; $5E5D
    ret                                           ; $5E5E


; C: keys $10 and up, or the cursor past the eighth place: loads the blood-type page (map 24:5F40 to $98C0) (branch
; target; code read 2026-10-19)
Kb_Page2_PressBirthDate_ToPage3::
    farcopy Vram_CopyFromBank, Map_24_5F40_Kb_Page2_PressBirthDate, $98c0, $0140 ; $5E5F
    xor a                                         ; $5E6D
    ld [wKbCursor], a                             ; $5E6E
    ld a, [wKbKey]                                ; $5E71
    cp $0c                                        ; $5E74
    jr c, jr_009_5e80                             ; $5E76

    cp $0f                                        ; $5E78
    jr nc, jr_009_5e80                            ; $5E7A

    ld a, $06                                     ; $5E7C
    jr jr_009_5e81                                ; $5E7E

jr_009_5e80:
    xor a                                         ; $5E80

jr_009_5e81:
    ld [wKbKey], a                                ; $5E81
    ld a, $05                                     ; $5E84
    ld [wKbPage], a                               ; $5E86
    push af                                       ; $5E89
    ld a, SFX1_OPTION_CHANGE                      ; $5E8A
    call Snd_Sfx1                                 ; $5E8C
    pop af                                        ; $5E8F
    next_state                                    ; $5E90
    ret                                           ; $5E94


; C
Kb_Page3_PressBloodType::
    ldh a, [hKeysNew]                             ; $5E95
    bit PADB_A, a                                 ; $5E97
    ret z                                         ; $5E99

    ld a, [wKbKey]                                ; $5E9A
    cp $0c                                        ; $5E9D
    jp nc, Kb_Page3_PressBloodType_Confirm        ; $5E9F

    cp $0b                                        ; $5EA2
    jp nc, Kb_Page3_PressBloodType_ToPage2        ; $5EA4

    cp $06                                        ; $5EA7
    jp nc, Kb_Page3_PressBloodType_Ret            ; $5EA9

    ld a, [wOwnerGenderBlood]                     ; $5EAC
    and $03                                       ; $5EAF
    ld c, a                                       ; $5EB1
    ld a, [wKbKey]                                ; $5EB2
    sla a                                         ; $5EB5
    sla a                                         ; $5EB7
    or c                                          ; $5EB9
    ld [wOwnerGenderBlood], a                     ; $5EBA
    call OwnerCard_LoadBloodTiles                 ; $5EBD
    push af                                       ; $5EC0
    ld a, SFX1_KEY_A                              ; $5EC1
    call Snd_Sfx1                                 ; $5EC3
    pop af                                        ; $5EC6
    ret                                           ; $5EC7


; C: RET: keys 6-10 of the blood-type page do nothing (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_Ret::
    ret                                           ; $5EC8


; C: key $0B: back to the birth-date page (map 24:5DC0, key $0F, set 4, sfx 4) (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_ToPage2::
    farcopy Vram_CopyFromBank, Map_24_5DC0_Kb_Page1_PressSex, $98c0, $0140 ; $5EC9
    xor a                                         ; $5ED7
    ld [wKbCursor], a                             ; $5ED8
    ld a, $0f                                     ; $5EDB
    ld [wKbKey], a                                ; $5EDD
    ld a, $04                                     ; $5EE0
    ld [wKbPage], a                               ; $5EE2
    push af                                       ; $5EE5
    ld a, SFX1_KEY_B                              ; $5EE6
    call Snd_Sfx1                                 ; $5EE8
    pop af                                        ; $5EEB
    ld hl, wState                                 ; $5EEC
    dec [hl]                                      ; $5EEF
    ret                                           ; $5EF0


; C: keys $0C and up: sfx $16, 10-frame wait, state + 1 (the owner form is done) (branch target; code read 2026-10-19)
Kb_Page3_PressBloodType_Confirm::
    push af                                       ; $5EF1
    ld a, SFX1_OPTION_CHANGE                      ; $5EF2
    call Snd_Sfx1                                 ; $5EF4
    pop af                                        ; $5EF7
    ld bc, $000a                                  ; $5EF8
    call Wait_Frames                              ; $5EFB
    next_state                                    ; $5EFE
    ret                                           ; $5F02


; C: B (newly pressed, $FFA2 bit 1) moves the name cursor $DA3B back by one unless it is 0: backspace without erasing
; (C)
Kb_BackspaceOnB::
    ldh a, [hKeysNew]                             ; $5F03
    bit PADB_B, a                                 ; $5F05
    ret z                                         ; $5F07

    ld a, [wKbCursor]                             ; $5F08
    and a                                         ; $5F0B
    ret z                                         ; $5F0C

    dec a                                         ; $5F0D
    ld [wKbCursor], a                             ; $5F0E
    ret                                           ; $5F11


; C: every 4th frame ($FFC8 & 3 = 0) xor $3C into the BGP shadow $FFB0: the blinking palette of the keyboard
; background (C)
Kb_BlinkBackground::
    ldh a, [hFrameCounter]                        ; $5F12
    and $03                                       ; $5F14
    ret nz                                        ; $5F16

    ldh a, [hBgpShadow]                           ; $5F17
    xor $3c                                       ; $5F19
    ldh [hBgpShadow], a                           ; $5F1B
    ret                                           ; $5F1D


; C: owner_name[kb_cursor]
Kb_WriteNameChar::
    ld a, [wKbCursor]                             ; $5F1E
    ld c, a                                       ; $5F21
    ld b, $00                                     ; $5F22
    ld hl, wOwnerName                             ; $5F24
    add hl, bc                                    ; $5F27
    ld a, [hl]                                    ; $5F28
    push af                                       ; $5F29
    ld a, [wKbCursor]                             ; $5F2A
    swap a                                        ; $5F2D
    push af                                       ; $5F2F
    and $f0                                       ; $5F30
    ld c, a                                       ; $5F32
    pop af                                        ; $5F33
    and $0f                                       ; $5F34
    ld b, a                                       ; $5F36
    sla c                                         ; $5F37
    rl b                                          ; $5F39
    ld hl, $9580                                  ; $5F3B
    add hl, bc                                    ; $5F3E
    ld d, h                                       ; $5F3F
    ld e, l                                       ; $5F40
    pop af                                        ; $5F41
    ld c, $2a                                     ; $5F42
    ld hl, ScrollEngine_Step                      ; $5F44
    call Glyph_LoadFromCharCode                   ; $5F47
    ret                                           ; $5F4A


; C: Start+Select at power-on: A erases; B boots (README 16.18)
Boot_EraseAllPrompt_Far::
    push af                                       ; $5F4B
    ld a, $10                                     ; $5F4C
    ld [$4000], a                                 ; $5F4E
    ld hl, $a000                                  ; $5F51

jr_009_5f54:
    bit 0, [hl]                                   ; $5F54
    jr nz, jr_009_5f54                            ; $5F56

    pop af                                        ; $5F58
    and a                                         ; $5F59
    jp nz, Boot_EraseAllPrompt_Far_Validate       ; $5F5A

    call Joy_Read                                 ; $5F5D
    ldh a, [hKeysHeld]                            ; $5F60
    cp PADF_SELECT | PADF_START                   ; $5F62
    jp nz, Boot_EraseAllPrompt_Far_Validate       ; $5F64

    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $5F67
    ldh [hLcdcShadow], a                          ; $5F69
    ld a, $e4                                     ; $5F6B
    ld [wPaletteTarget], a                        ; $5F6D
    xor a                                         ; $5F70
    ldh [hScxShadow], a                           ; $5F71
    ldh [hScyShadow], a                           ; $5F73
    farcopy Mem_CopyFromBank, Gfx_0F_7B00_Boot_EraseAllPrompt_Far, $9000, $0500 ; $5F75
    farcopy Mem_CopyFromBank, Map_25_7A60_Boot_EraseAllPrompt_Far, $9800, $0240 ; $5F83
    call Pal_AllWhite                             ; $5F91
    call Lcd_On                                   ; $5F94
    call Sgb_MaskCancel                           ; $5F97
    call Pal_FadeIn                               ; $5F9A

jr_009_5f9d:
    rst Rst08_WaitVBlank                          ; $5F9D
    ldh a, [hKeysNew]                             ; $5F9E
    bit PADB_B, a                                 ; $5FA0
    jr nz, jr_009_5fc6                            ; $5FA2

    bit PADB_A, a                                 ; $5FA4
    jr z, jr_009_5f9d                             ; $5FA6

    ldh [hFarcallAArg], a                         ; $5FA8
    farcall Sram_FormatAll_Far                    ; $5FAA
    ldh [hFarcallAArg], a                         ; $5FB2
    farcall Sram_ValidateAll_Far                  ; $5FB4
    ldh [hFarcallAArg], a                         ; $5FBC
    ld a, $02                                     ; $5FBE
    ld hl, Photo_RenumberVector                   ; $5FC0
    call Far_Call                                 ; $5FC3

jr_009_5fc6:
    call Pal_FadeOut                              ; $5FC6
    call Lcd_Off                                  ; $5FC9

; C: end of the erase prompt (and the path without prompt): far-calls 02:442C Sram_ValidateAll_Far and 02:4466
; Photo_RenumberVector, then Far_Call_Return (the source shows `CommentEditor_DrawTextCursor` for 02:4466 only because
; bank 9 has that name at the same address) (branch target; code read ...
Boot_EraseAllPrompt_Far_Validate::
    ldh [hFarcallAArg], a                         ; $5FCC
    farcall Sram_ValidateAll_Far                  ; $5FCE
    ldh [hFarcallAArg], a                         ; $5FD6
    ld a, $02                                     ; $5FD8
    ld hl, Photo_RenumberVector                   ; $5FDA
    call Far_Call                                 ; $5FDD
    jp Far_Call_Return                            ; $5FE0


; C: mode 21: RUN! RUN! RUN! (three runners; 12 hurdles)
Mode21_RunRunRun::
    ld a, [wState]                                ; $5FE3
    rst Rst18_JumpTable                           ; $5FE6

; C: 15 states x 2 B (09:5FE7-6005); a false auto label at 6000 (from the "ld hl,$6000" of the owner-name glyph
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

; C
Mode21_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6005
    ldh [hLcdcShadow], a                          ; $6007
    ld a, $e4                                     ; $6009
    ld [wPaletteTarget], a                        ; $600B
    ld [wPaletteTarget + $1], a                   ; $600E
    ld a, $d2                                     ; $6011
    ld [wPaletteTarget + $2], a                   ; $6013
    xor a                                         ; $6016
    ldh [hScxShadow], a                           ; $6017
    ldh [hScyShadow], a                           ; $6019
    ld [wRunPickAnimCounter], a                   ; $601B
    ldh [hFarcallAArg], a                         ; $601E
    farcall GameFace_LoadTiles_Far                ; $6020
    ld a, [wGamefacePresent]                      ; $6028
    and a                                         ; $602B
    jr z, jr_009_6033                             ; $602C

    ld a, $02                                     ; $602E
    ld [wPickCharacter21], a                      ; $6030

jr_009_6033:
    ld a, [wPickCharacter21]                      ; $6033
    ld c, a                                       ; $6036
    ld b, $00                                     ; $6037
    ld hl, Mode21_PickCharacterTbl2               ; $6039

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Mode21_PickCharacterTbl::
    add hl, bc                                    ; $603C
    ld a, [hl]                                    ; $603D
    ld [wRunPickPose], a                          ; $603E
    farcopy Mem_CopyFromBank, Gfx_12_5800_Mode21_State00_Init, $9000, $0800 ; $6041
    farcopy Mem_CopyFromBank, Gfx_12_6000_Mode21_State00_Init, $8800, $0800 ; $604F
    farcopy Mem_CopyFromBank, Gfx_12_6800_Mode21_State00_Init, $8000, $0800 ; $605D
    farcopy Mem_CopyFromBank, Map_25_5F60_Mode21_State00_Init, $9800, $0240 ; $606B
    ld a, $48                                     ; $6079
    ldh [hLycShadowSplit1], a                     ; $607B
    ldh [hSplit1Latch], a                         ; $607D
    ld hl, hStatShadow                            ; $607F
    set 6, [hl]                                   ; $6082
    ld hl, rIE                                    ; $6084
    set 1, [hl]                                   ; $6087
    ld a, $01                                     ; $6089
    ldh [hStatHandlerIndex], a                    ; $608B
    call Oam_ClearShadow                          ; $608D
    call Pal_AllWhite                             ; $6090
    call Lcd_On                                   ; $6093
    push af                                       ; $6096
    ld a, MUSIC_RUN_PICK_CHARACTER                ; $6097
    call Snd_Music                                ; $6099
    pop af                                        ; $609C
    call Pal_FadeIn                               ; $609D
    next_state                                    ; $60A0
    ret                                           ; $60A4


; C: table of 09:603C (README 2.7)
Mode21_PickCharacterTbl2::
    db $00, $07, $0e

; C: Left/Right = D9F8; A confirms; B back
Mode21_State01_PickCharacter::
    call Run_DrawPickCharacterSprite              ; $60A8
    cp $10                                        ; $60AB
    call nc, Mode21_PickCharacterKeys             ; $60AD
    ld a, [wRunPickPose]                          ; $60B0
    res 7, a                                      ; $60B3
    cp $1a                                        ; $60B5
    ret c                                         ; $60B7

    ld a, [wAbResult]                             ; $60B8
    bit 0, a                                      ; $60BB
    jr z, jr_009_60d4                             ; $60BD

    call Pal_FadeOut                              ; $60BF
    call Lcd_Off                                  ; $60C2
    ld hl, hStatShadow                            ; $60C5
    res 6, [hl]                                   ; $60C8
    ld hl, rIE                                    ; $60CA
    res 1, [hl]                                   ; $60CD
    next_state                                    ; $60CF
    ret                                           ; $60D3


jr_009_60d4:
    bit 1, a                                      ; $60D4
    ret z                                         ; $60D6

    call Pal_FadeOut                              ; $60D7
    call Lcd_Off                                  ; $60DA
    ld hl, hStatShadow                            ; $60DD
    res 6, [hl]                                   ; $60E0
    ld hl, rIE                                    ; $60E2
    res 1, [hl]                                   ; $60E5
    ld a, MODE_MAIN_MENU                          ; $60E7
    ld [wMode], a                                 ; $60E9
    set_state STATE_00_INIT                       ; $60EC
    ret                                           ; $60F1


; C
Mode21_PickCharacterKeys::
    ldh a, [hKeysNew]                             ; $60F2
    and PADF_A | PADF_B                           ; $60F4
    jr z, jr_009_6117                             ; $60F6

    ld [wAbResult], a                             ; $60F8
    push af                                       ; $60FB
    bit 0, a                                      ; $60FC
    ld a, SFX1_KEY_A                              ; $60FE
    call nz, Snd_Sfx1                             ; $6100
    pop af                                        ; $6103
    push af                                       ; $6104
    bit 1, a                                      ; $6105
    ld a, SFX1_KEY_B                              ; $6107
    call nz, Snd_Sfx1                             ; $6109
    pop af                                        ; $610C
    ld a, $15                                     ; $610D
    ld [wRunPickPose], a                          ; $610F
    xor a                                         ; $6112
    ld [wRunPickAnimCounter], a                   ; $6113
    ret                                           ; $6116


jr_009_6117:
    ldh a, [hKeysNewRepeat]                       ; $6117
    ld b, a                                       ; $6119
    ld a, [wPickCharacter21]                      ; $611A
    bit 5, b                                      ; $611D
    jr z, jr_009_6126                             ; $611F

    and a                                         ; $6121
    ret z                                         ; $6122

    dec a                                         ; $6123
    jr jr_009_612d                                ; $6124

jr_009_6126:
    bit 4, b                                      ; $6126
    ret z                                         ; $6128

    cp $02                                        ; $6129
    ret z                                         ; $612B

    inc a                                         ; $612C

jr_009_612d:
    ld [wPickCharacter21], a                      ; $612D
    push af                                       ; $6130
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6131
    call Snd_Sfx1                                 ; $6133
    pop af                                        ; $6136
    ld c, a                                       ; $6137
    ld b, $00                                     ; $6138
    ld hl, Mode21_PickCharacterTbl3               ; $613A
    add hl, bc                                    ; $613D
    ld a, [hl]                                    ; $613E
    ld [wRunPickPose], a                          ; $613F
    xor a                                         ; $6142
    ld [wRunPickAnimCounter], a                   ; $6143
    ret                                           ; $6146


; C
Mode21_PickCharacterTbl3::
    db $05, $0c, $13

; C
Mode21_State02_RaceSceneInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $614A
    ldh [hLcdcShadow], a                          ; $614C
    ld a, $e4                                     ; $614E
    ld [wPaletteTarget], a                        ; $6150
    ld [wPaletteTarget + $1], a                   ; $6153
    ld a, $d2                                     ; $6156
    ld [wPaletteTarget + $2], a                   ; $6158
    ld a, $b8                                     ; $615B
    ldh [hScxBand1], a                            ; $615D
    ld a, $f0                                     ; $615F
    ldh [hScyShadow], a                           ; $6161
    ld a, $e0                                     ; $6163
    ldh [hScyBand1], a                            ; $6165
    xor a                                         ; $6167
    ldh [hScxShadow], a                           ; $6168
    ldh [hScxBand2], a                            ; $616A
    ldh [hScyBand2], a                            ; $616C
    ldh [hFarcallAArg], a                         ; $616E
    farcall Counters_Load_Far                     ; $6170
    farcopy Mem_CopyFromBank, Gfx_1B_6100_Mode21_State02_RaceSceneInit, $8a80, $0580 ; $6178
    farcopy Mem_CopyFromBank, Gfx_1B_6680_Mode21_State02_RaceSceneInit, $8000, $0800 ; $6186
    farcopy Mem_CopyFromBank, Map_22_7340_Mode21_State02_RaceSceneInit, $9800, $0400 ; $6194
    farcopy Mem_CopyFromBank, Map_25_61A0_Mode21_State02_RaceSceneInit, $9c00, $0240 ; $61A2
    ldh [hFarcallAArg], a                         ; $61B0
    farcall GameFace_LoadTiles_Far                ; $61B2
    call Run_LoadCharacterGraphicsA               ; $61BA
    ld a, $08                                     ; $61BD
    ldh [hLycShadowSplit1], a                     ; $61BF
    ldh [hSplit1Latch], a                         ; $61C1
    ld a, $5b                                     ; $61C3
    ldh [hSplit2Line], a                          ; $61C5
    ldh [hSplit2Latch], a                         ; $61C7
    ld hl, hStatShadow                            ; $61C9
    set 6, [hl]                                   ; $61CC
    ld hl, rIE                                    ; $61CE
    set 1, [hl]                                   ; $61D1
    ld a, $07                                     ; $61D3
    ldh [hStatHandlerIndex], a                    ; $61D5
    call Oam_ClearShadow                          ; $61D7
    call Pal_AllWhite                             ; $61DA
    call Lcd_On                                   ; $61DD
    push af                                       ; $61E0
    ld a, MUSIC_RUN_RACE_SCENE                    ; $61E1
    call Snd_Music                                ; $61E3
    pop af                                        ; $61E6
    call Pal_FadeIn                               ; $61E7
    next_state                                    ; $61EA
    ret                                           ; $61EE


; C: clears $D000-$D047
Mode21_State03_RaceSetup::
    call Run_ClearRaceState                       ; $61EF
    call Run_DrawPlayer                           ; $61F2
    call Run_DrawChick                            ; $61F5
    call Run_DrawMoleAndScene                     ; $61F8
    xor a                                         ; $61FB
    ld [wRunTopSpeedFxTimer], a                   ; $61FC
    next_state                                    ; $61FF
    ret                                           ; $6203


; C: ends with race counter D04F++
Mode21_State04_Countdown::
    call Run_MovePlayerX                          ; $6204
    call Run_MoveChickX                           ; $6207
    call Run_MoveMoleX                            ; $620A
    call Run_MoveRunner3X                         ; $620D
    call Run_DrawPlayer                           ; $6210
    call Run_DrawChick                            ; $6213
    call Run_DrawMoleAndScene                     ; $6216
    call Run_DrawRunner3                          ; $6219
    ld c, $04                                     ; $621C
    call Run_PlaceRunner0                         ; $621E
    call Run_PlaceRunner1                         ; $6221
    call Run_PlaceRunner2                         ; $6224
    call Run_PlaceRunner3                         ; $6227
    ld a, c                                       ; $622A
    and a                                         ; $622B
    ret nz                                        ; $622C

    ld a, [wRunState + $b]                        ; $622D
    cp $0d                                        ; $6230
    ret nz                                        ; $6232

    push af                                       ; $6233
    ld a, MUSIC_RUN_COUNTDOWN                     ; $6234
    call Snd_Music                                ; $6236
    pop af                                        ; $6239
    xor a                                         ; $623A
    ld [wRunStartDash], a                         ; $623B
    ld [wRunPlayerLeads], a                       ; $623E
    ld a, [wRunRaceCounter]                       ; $6241
    inc a                                         ; $6244
    ld [wRunRaceCounter], a                       ; $6245
    next_state                                    ; $6248
    ret                                           ; $624C


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner0::
    ld a, [wRunPlayerPos]                         ; $624D
    ld hl, wRunPlayerPos + $1                     ; $6250
    or [hl]                                       ; $6253
    ret nz                                        ; $6254

    dec c                                         ; $6255
    ld a, [wRunPlayerSpeedLevel]                  ; $6256
    and a                                         ; $6259
    ret z                                         ; $625A

    xor a                                         ; $625B
    ld [wRunPlayerSpeedLevel], a                  ; $625C
    ld [wRunPlayerAnimCounter], a                 ; $625F
    ld [wRunState + $c], a                        ; $6262
    ld a, $05                                     ; $6265
    ld [wRunPlayerPose], a                        ; $6267
    ld a, $0d                                     ; $626A
    ld [wRunState + $b], a                        ; $626C
    ret                                           ; $626F


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner1::
    ld a, [wRunChickPos]                          ; $6270
    ld hl, wRunChickPos + $1                      ; $6273
    or [hl]                                       ; $6276
    ret nz                                        ; $6277

    dec c                                         ; $6278
    ld a, [wRunChickSpeed]                        ; $6279
    and a                                         ; $627C
    ret z                                         ; $627D

    xor a                                         ; $627E
    ld [wRunChickSpeed], a                        ; $627F
    ld [wRunChickAnimCounter], a                  ; $6282
    ld [wRunState + $c], a                        ; $6285
    ld a, $04                                     ; $6288
    ld [wRunChickState], a                        ; $628A
    ld a, $0f                                     ; $628D
    ld [wRunState + $b], a                        ; $628F
    ret                                           ; $6292


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner2::
    ld a, [wRunMolePos]                           ; $6293
    ld hl, wRunMolePos + $1                       ; $6296
    or [hl]                                       ; $6299
    ret nz                                        ; $629A

    dec c                                         ; $629B
    ld a, [wRunMoleSpeed]                         ; $629C
    and a                                         ; $629F
    ret z                                         ; $62A0

    xor a                                         ; $62A1
    ld [wRunMoleSpeed], a                         ; $62A2
    ld [wRunMoleAnimCounter], a                   ; $62A5
    ld a, $05                                     ; $62A8
    ld [wRunMoleState], a                         ; $62AA
    ret                                           ; $62AD


; C: line-up of the four runners during Mode21_State04_Countdown (the countdown before the race): the runners start at
; x = $FF60 (player), $FF00 (chick), $FFA0 (mole) and $00A0 (fourth runner, speed $FF = -1, coming from the right) and
; Run_MovePlayerX/ChickX/MoleX/MoveRunner3X add the speed each frame; ...
Run_PlaceRunner3::
    ld a, [wRunRunner3Pos]                        ; $62AE
    ld hl, wRunRunner3Pos + $1                    ; $62B1
    or [hl]                                       ; $62B4
    ret nz                                        ; $62B5

    dec c                                         ; $62B6
    ld a, [wRunRunner3Speed]                      ; $62B7
    and a                                         ; $62BA
    ret z                                         ; $62BB

    xor a                                         ; $62BC
    ld [wRunRunner3Speed], a                      ; $62BD
    ret                                           ; $62C0


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Mode21_State05_ReadySteadyGo::
    call Run_MovePlayerX                          ; $62C1
    call Run_MoveChickX                           ; $62C4
    call Run_MoveMoleX                            ; $62C7
    call Run_DrawPlayer                           ; $62CA
    call Run_DrawChick                            ; $62CD
    call Run_DrawMoleAndScene                     ; $62D0
    call Run_DrawRunner3                          ; $62D3
    call Run_DrawPodiumBanner                     ; $62D6
    ld a, [wRunBannerState]                       ; $62D9
    res 7, a                                      ; $62DC
    cp $07                                        ; $62DE
    jr nc, jr_009_62ec                            ; $62E0

    ldh a, [hKeysNew]                             ; $62E2
    and a                                         ; $62E4
    ret z                                         ; $62E5

    ld a, $ff                                     ; $62E6
    ld [wRunStartDash], a                         ; $62E8
    ret                                           ; $62EB


jr_009_62ec:
    cp $09                                        ; $62EC
    jr nc, jr_009_6300                            ; $62EE

    ldh a, [hKeysNew]                             ; $62F0
    and a                                         ; $62F2
    ret z                                         ; $62F3

    ld a, [wRunStartDash]                         ; $62F4
    bit 7, a                                      ; $62F7
    ret nz                                        ; $62F9

    ld a, $01                                     ; $62FA
    ld [wRunStartDash], a                         ; $62FC
    ret                                           ; $62FF


jr_009_6300:
    cp $0c                                        ; $6300
    ret nz                                        ; $6302

    ld a, [wRunStartDash]                         ; $6303
    cp $01                                        ; $6306
    jr nz, jr_009_6314                            ; $6308

    ld a, $33                                     ; $630A
    ld [wRunPlayerRunCounter], a                  ; $630C
    ld a, $03                                     ; $630F
    ld [wRunPlayerStepSize], a                    ; $6311

jr_009_6314:
    xor a                                         ; $6314
    ld [wRunPlayerAnimCounter], a                 ; $6315
    ld [wRunState + $c], a                        ; $6318
    ld [wRunChickAnimCounter], a                  ; $631B
    ld [wRunMoleAnimCounter], a                   ; $631E
    ld a, $07                                     ; $6321
    ld [wRunPlayerPose], a                        ; $6323
    ld a, $03                                     ; $6326
    ld [wRunState + $b], a                        ; $6328
    ld a, $06                                     ; $632B
    ld [wRunChickState], a                        ; $632D
    ld a, $07                                     ; $6330
    ld [wRunMoleState], a                         ; $6332
    farcopy Vram_CopyFromBank_4, Gfx_1B_6FC0_Mode21_State05_ReadySteadyGo, $81a0, $00a0 ; $6335
    push af                                       ; $6343
    ld a, MUSIC_RUN_READY_STEADY_GO               ; $6344
    call Snd_Music                                ; $6346
    pop af                                        ; $6349
    next_state                                    ; $634A
    ret                                           ; $634E


; C: Start leaves for state 0E
Mode21_State06_RaceLoop::
    ld a, [wRunState + $d]                        ; $634F
    and a                                         ; $6352
    call z, Run_RaceTimerTick                     ; $6353
    call Run_UpdatePlayer                         ; $6356
    call Run_UpdateChick                          ; $6359
    call Run_UpdateMole                           ; $635C
    call Run_HurdleCollision                      ; $635F
    call Run_MovePlayerX                          ; $6362
    call Run_MoveChickX                           ; $6365
    call Run_MoveMoleX                            ; $6368
    call Run_ScrollCamera                         ; $636B
    call Run_DrawPlayer                           ; $636E
    call Run_DrawChick                            ; $6371
    call Run_DrawMoleAndScene                     ; $6374
    call Run_DrawRunner3                          ; $6377
    call Run_DrawBackgroundScroll                 ; $637A
    call Run_DrawHurdles                          ; $637D
    call Run_DrawFinishLine                       ; $6380
    ldh a, [hKeysNew]                             ; $6383
    bit PADB_START, a                             ; $6385
    jr z, jr_009_638f                             ; $6387

    set_state STATE_21_LEAVE                      ; $6389
    ret                                           ; $638E


jr_009_638f:
    ld a, [wRunState + $d]                        ; $638F
    and a                                         ; $6392
    ret z                                         ; $6393

    call Run_CompareRecord                        ; $6394
    push af                                       ; $6397
    ld a, MUSIC_RUN_RACE                          ; $6398
    call Snd_Music                                ; $639A
    pop af                                        ; $639D
    next_state                                    ; $639E
    ret                                           ; $63A2


; C: runner without a place gets 3
Mode21_State07_RaceEnd::
    ld hl, hKeysNew                               ; $63A3
    res 0, [hl]                                   ; $63A6
    res 1, [hl]                                   ; $63A8
    res 6, [hl]                                   ; $63AA
    ldh a, [hFrameCounter]                        ; $63AC
    and $0f                                       ; $63AE
    jr nz, jr_009_63b4                            ; $63B0

    set 0, [hl]                                   ; $63B2

jr_009_63b4:
    call Run_UpdatePlayer                         ; $63B4
    call Run_UpdateChick                          ; $63B7
    call Run_UpdateMole                           ; $63BA
    call Run_HurdleCollision                      ; $63BD
    call Run_MovePlayerX                          ; $63C0
    call Run_MoveChickX                           ; $63C3
    call Run_MoveMoleX                            ; $63C6
    call Run_ScrollCamera                         ; $63C9
    call Run_DrawPlayer                           ; $63CC
    call Run_DrawChick                            ; $63CF
    call Run_DrawMoleAndScene                     ; $63D2
    call Run_DrawRunner3                          ; $63D5
    call Run_DrawBackgroundScroll                 ; $63D8
    call Run_DrawHurdles                          ; $63DB
    call Run_DrawFinishLine                       ; $63DE
    ld a, [wRunPlayerPos + $1]                    ; $63E1
    bit 7, a                                      ; $63E4
    ret nz                                        ; $63E6

    cp $15                                        ; $63E7
    ret c                                         ; $63E9

    jr nz, jr_009_63f2                            ; $63EA

    ld a, [wRunPlayerPos]                         ; $63EC
    cp $80                                        ; $63EF
    ret c                                         ; $63F1

jr_009_63f2:
    ld a, [wRunState + $47]                       ; $63F2
    cp $02                                        ; $63F5
    ret c                                         ; $63F7

    ld a, [wRunState + $d]                        ; $63F8
    and a                                         ; $63FB
    jr nz, jr_009_6403                            ; $63FC

    ld a, $03                                     ; $63FE
    ld [wRunState + $d], a                        ; $6400

jr_009_6403:
    ld a, [wRunState + $16]                       ; $6403
    and a                                         ; $6406
    jr nz, jr_009_640e                            ; $6407

    ld a, $03                                     ; $6409
    ld [wRunState + $16], a                       ; $640B

jr_009_640e:
    ld a, [wRunState + $1f]                       ; $640E
    and a                                         ; $6411
    jr nz, jr_009_6419                            ; $6412

    ld a, $03                                     ; $6414
    ld [wRunState + $1f], a                       ; $6416

jr_009_6419:
    call Pal_FadeOut                              ; $6419
    call Lcd_Off                                  ; $641C
    ld hl, hStatShadow                            ; $641F
    res 6, [hl]                                   ; $6422
    ld hl, rIE                                    ; $6424
    res 1, [hl]                                   ; $6427
    set_state STATE_21_RESULT_SETUP               ; $6429
    ret                                           ; $642E


; C: never selected: state := 3
Mode21_State08_Unused::
    set_state STATE_21_RACE_SETUP                 ; $642F
    ret                                           ; $6434


; C: never selected: state := 3
Mode21_State09_Unused::
    set_state STATE_21_RACE_SETUP                 ; $6435
    ret                                           ; $643A


; C: never selected: state := 6
Mode21_State0A_Unused::
    set_state STATE_21_RACE_LOOP                  ; $643B
    ret                                           ; $6440


; C
Mode21_State0B_ResultSetup::
    ld a, LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON  ; $6441
    ldh [hLcdcShadow], a                          ; $6443
    ld a, $e4                                     ; $6445
    ld [wPaletteTarget], a                        ; $6447
    ld [wPaletteTarget + $1], a                   ; $644A
    ld a, $d2                                     ; $644D
    ld [wPaletteTarget + $2], a                   ; $644F
    ld a, $10                                     ; $6452
    ldh [hScxShadow], a                           ; $6454
    ldh [hScxBand2], a                            ; $6456
    ld a, $97                                     ; $6458
    ldh [hWxShadow], a                            ; $645A
    xor a                                         ; $645C
    ldh [hScyShadow], a                           ; $645D
    ldh [hScyBand2], a                            ; $645F
    ldh [hWyShadow], a                            ; $6461
    farcopy Mem_CopyFromBank, Gfx_19_6460_Mode21_State0B_ResultSetup, $9700, $0100 ; $6463
    farcopy Mem_CopyFromBank, Gfx_19_6560_Mode21_State0B_ResultSetup, $8800, $0800 ; $6471
    farcopy Mem_CopyFromBank, Gfx_19_6D60_Mode21_State0B_ResultSetup, $8000, $0400 ; $647F
    farcopy Mem_CopyFromBank, Map_26_6C00_Mode21_State0B_ResultSetup, $9800, $0240 ; $648D
    farcopy Mem_CopyFromBank, Map_22_7340_Mode21_State02_RaceSceneInit, $9c00, $0400 ; $649B
    call Run_PodiumSetup                          ; $64A9
    ld a, $07                                     ; $64AC
    ldh [hLycShadowSplit1], a                     ; $64AE
    ldh [hSplit1Latch], a                         ; $64B0
    ld a, $5a                                     ; $64B2
    ldh [hSplit2Line], a                          ; $64B4
    ldh [hSplit2Latch], a                         ; $64B6
    ld hl, hStatShadow                            ; $64B8
    set 6, [hl]                                   ; $64BB
    ld hl, rIE                                    ; $64BD
    set 1, [hl]                                   ; $64C0
    ld a, $03                                     ; $64C2
    ldh [hStatHandlerIndex], a                    ; $64C4
    call Oam_ClearShadow                          ; $64C6
    call Pal_AllWhite                             ; $64C9
    call Lcd_On                                   ; $64CC
    push af                                       ; $64CF
    ld a, MUSIC_RUN_RESULT_SETUP                  ; $64D0
    call Snd_Music                                ; $64D2
    pop af                                        ; $64D5
    xor a                                         ; $64D6
    ld [wRunResultMusicOn], a                     ; $64D7
    call Run_DrawPlayer                           ; $64DA
    call Run_DrawChick                            ; $64DD
    call Run_DrawMoleAndScene                     ; $64E0
    call Run_DrawFlag                             ; $64E3
    ld a, [wRunState + $d]                        ; $64E6
    cp $01                                        ; $64E9
    jr nz, jr_009_64f2                            ; $64EB

    call Run_DrawConfetti                         ; $64ED
    jr jr_009_64fc                                ; $64F0

jr_009_64f2:
    ld c, $02                                     ; $64F2
    call Run_LoadCharacterGraphicsB               ; $64F4
    ld c, $03                                     ; $64F7
    call Run_LoadCharacterGraphicsC               ; $64F9

jr_009_64fc:
    call Pal_FadeIn                               ; $64FC
    next_state                                    ; $64FF
    ret                                           ; $6503


; C
Run_PodiumSetup::
    xor a                                         ; $6504
    ld [wRunCameraPos], a                         ; $6505
    ld [wRunCameraPos + $1], a                    ; $6508
    ld [wRunUnusedD04C], a                        ; $650B
    ld [wRunFlagLevel], a                         ; $650E
    ld [wRunFlagCounter], a                       ; $6511
    ld [wRunCelebrationStep], a                   ; $6514
    ld a, $00                                     ; $6517
    ld [wRunFlagState], a                         ; $6519
    ld a, $74                                     ; $651C
    ld [wRunFlagY], a                             ; $651E
    ld a, $fc                                     ; $6521
    ld [wRunCrownY], a                            ; $6523
    ld a, [wRunState + $16]                       ; $6526
    cp $01                                        ; $6529
    jr nz, jr_009_6540                            ; $652B

    farcopy Mem_CopyFromBank, Gfx_19_7310_Run_PodiumSetup, $8a40, $01b0 ; $652D
    ld a, $02                                     ; $653B
    ld [wRunFlagY], a                             ; $653D

jr_009_6540:
    ld a, [wRunState + $1f]                       ; $6540
    cp $01                                        ; $6543
    jr nz, jr_009_655a                            ; $6545

    farcopy Mem_CopyFromBank, Gfx_19_7160_Run_PodiumSetup, $8a40, $01b0 ; $6547
    ld a, $02                                     ; $6555
    ld [wRunFlagY], a                             ; $6557

jr_009_655a:
    call Run_DrawPodiumPlayer                     ; $655A
    call Run_DrawPodiumChick                      ; $655D
    call Run_DrawPodiumMole                       ; $6560
    call Run_ConfettiInit                         ; $6563
    ret                                           ; $6566


; C: tables 09:6596
Run_DrawPodiumPlayer::
    ld a, [wRunState + $d]                        ; $6567
    dec a                                         ; $656A
    sla a                                         ; $656B
    sla a                                         ; $656D
    ld c, a                                       ; $656F
    ld b, $00                                     ; $6570
    ld hl, Run_PodiumPlayerTbl                    ; $6572
    add hl, bc                                    ; $6575
    ld a, [hl+]                                   ; $6576
    ld [wRunPlayerPos], a                         ; $6577
    ld a, [hl+]                                   ; $657A
    ld [wRunPlayerJumpHeight], a                  ; $657B
    ld a, [hl+]                                   ; $657E
    ld [wRunPlayerPose], a                        ; $657F
    ld a, [hl+]                                   ; $6582
    ld [wRunState + $b], a                        ; $6583
    xor a                                         ; $6586
    ld [wRunPlayerPos + $1], a                    ; $6587
    ld [wRunPlayerAnimCounter], a                 ; $658A
    ld [wRunState + $c], a                        ; $658D
    ld a, $01                                     ; $6590
    ld [wRunPlayerTickStep], a                    ; $6592
    ret                                           ; $6595


; C
Run_PodiumPlayerTbl::
    db $70, $2a, $14, $12, $b0, $0a, $17, $12, $30, $fa, $17, $12

; C
Run_DrawPodiumChick::
    ld a, [wRunState + $16]                       ; $65A2
    dec a                                         ; $65A5
    ld c, a                                       ; $65A6
    sla a                                         ; $65A7
    add c                                         ; $65A9
    ld c, a                                       ; $65AA
    ld b, $00                                     ; $65AB
    ld hl, Run_PodiumChickTbl                     ; $65AD
    add hl, bc                                    ; $65B0
    ld a, [hl+]                                   ; $65B1
    ld [wRunChickPos], a                          ; $65B2
    ld a, [hl+]                                   ; $65B5
    ld [wRunState + $13], a                       ; $65B6
    ld a, [hl+]                                   ; $65B9
    ld [wRunChickState], a                        ; $65BA
    xor a                                         ; $65BD
    ld [wRunChickPos + $1], a                     ; $65BE
    ld [wRunChickAnimCounter], a                  ; $65C1
    ld a, $01                                     ; $65C4
    ld [wRunChickAnimStep], a                     ; $65C6
    ret                                           ; $65C9


; C
Run_PodiumChickTbl::
    db $80, $5c, $13
    db $c0, $6c, $13
    db $40, $74, $13

; C
Run_DrawPodiumMole::
    ld a, [wRunState + $1f]                       ; $65D3
    dec a                                         ; $65D6
    ld c, a                                       ; $65D7
    sla a                                         ; $65D8
    add c                                         ; $65DA
    ld c, a                                       ; $65DB
    ld b, $00                                     ; $65DC
    ld hl, Run_PodiumMoleTbl                      ; $65DE
    add hl, bc                                    ; $65E1
    ld a, [hl+]                                   ; $65E2
    ld [wRunMolePos], a                           ; $65E3
    ld a, [hl+]                                   ; $65E6
    ld [wRunState + $1c], a                       ; $65E7
    ld a, [hl+]                                   ; $65EA
    ld [wRunMoleState], a                         ; $65EB
    xor a                                         ; $65EE
    ld [wRunMolePos + $1], a                      ; $65EF
    ld [wRunMoleAnimCounter], a                   ; $65F2
    ld a, $01                                     ; $65F5
    ld [wRunMoleAnimStep], a                      ; $65F7
    ret                                           ; $65FA


; C
Run_PodiumMoleTbl::
    db $78, $5c, $14
    db $b8, $6c, $14
    db $38, $74, $14

; C: initialises the 10 confetti records of 6 bytes at $D052 and clears $D051: {x = (random & $F8) + 4, dx = +2 or -2,
; y = random & $7F, dy = 1, frame = (9 when bit 1 of the loop counter 10..1 is set, else 0) + (random & 7), 0} (C)
Run_ConfettiInit::
    xor a                                         ; $6604
    ld [wRunConfettiFlicker], a                   ; $6605
    ld hl, wRunConfetti                           ; $6608
    ld b, $0a                                     ; $660B

jr_009_660d:
    call Rng_Next                                 ; $660D
    and $f8                                       ; $6610
    add $04                                       ; $6612
    ld [hl+], a                                   ; $6614
    call Rng_Next                                 ; $6615
    bit 0, a                                      ; $6618
    jr nz, jr_009_6620                            ; $661A

    ld a, $02                                     ; $661C
    jr jr_009_6622                                ; $661E

jr_009_6620:
    ld a, $fe                                     ; $6620

jr_009_6622:
    ld [hl+], a                                   ; $6622
    call Rng_Next                                 ; $6623
    and $7f                                       ; $6626
    ld [hl+], a                                   ; $6628
    ld a, $01                                     ; $6629
    ld [hl+], a                                   ; $662B
    ld a, $00                                     ; $662C
    bit 1, b                                      ; $662E
    jr z, jr_009_6634                             ; $6630

    ld a, $09                                     ; $6632

jr_009_6634:
    ld c, a                                       ; $6634
    call Rng_Next                                 ; $6635
    and $07                                       ; $6638
    add c                                         ; $663A
    ld [hl+], a                                   ; $663B
    xor a                                         ; $663C
    ld [hl+], a                                   ; $663D
    dec b                                         ; $663E
    jr nz, jr_009_660d                            ; $663F

    ret                                           ; $6641


; C: B or Start leaves for 0E
Mode21_State0C_ResultScreen::
    call Run_FlagHoistKeys                        ; $6642
    call Run_FlagHeight                           ; $6645
    call Run_ConfettiUpdate                       ; $6648
    call Run_DrawPlayer                           ; $664B
    call Run_DrawChick                            ; $664E
    call Run_DrawMoleAndScene                     ; $6651
    call Run_DrawFlag                             ; $6654
    ld a, [wRunState + $d]                        ; $6657
    cp $01                                        ; $665A
    jr nz, jr_009_669a                            ; $665C

    call Run_FlagUpConfettiDone                   ; $665E
    push af                                       ; $6661
    call nz, Run_DrawConfetti                     ; $6662
    pop af                                        ; $6665
    push af                                       ; $6666
    call z, Run_Celebration                       ; $6667
    pop af                                        ; $666A
    call z, Run_DrawCrown                         ; $666B
    ld a, [wRunFlagY]                             ; $666E
    cp $74                                        ; $6671
    jr nz, jr_009_6688                            ; $6673

    ld a, [wRunResultMusicOn]                     ; $6675
    and a                                         ; $6678
    jr z, jr_009_669a                             ; $6679

    push af                                       ; $667B
    ld a, MUSIC_RUN_RESULT_SETUP                  ; $667C
    call Snd_Music                                ; $667E
    pop af                                        ; $6681
    xor a                                         ; $6682
    ld [wRunResultMusicOn], a                     ; $6683
    jr jr_009_669a                                ; $6686

jr_009_6688:
    ld a, [wRunResultMusicOn]                     ; $6688
    and a                                         ; $668B
    jr nz, jr_009_669a                            ; $668C

    push af                                       ; $668E
    ld a, MUSIC_RUN_RESULT                        ; $668F
    call Snd_Music                                ; $6691
    pop af                                        ; $6694
    ld a, $01                                     ; $6695
    ld [wRunResultMusicOn], a                     ; $6697

jr_009_669a:
    ldh a, [hKeysNew]                             ; $669A
    and PADF_B | PADF_START                       ; $669C
    ret z                                         ; $669E

    set_state STATE_21_LEAVE                      ; $669F
    ret                                           ; $66A4


; C: returns Z when the flag is at the top of the pole (wRunFlagY = 2, where Run_FlagHeight pins it with noise request
; $11 once A presses have hoisted it) and the y byte of all 10 confetti records ($D054, step 6) is 0: once the flag is
; up, Run_ConfettiRespawn retires each piece that falls off the screen ...
Run_FlagUpConfettiDone::
    ld a, [wRunFlagY]                             ; $66A5
    cp $02                                        ; $66A8
    ret nz                                        ; $66AA

    xor a                                         ; $66AB
    ld bc, $0006                                  ; $66AC
    ld hl, wRunConfetti + $2                      ; $66AF
    ld d, $0a                                     ; $66B2

jr_009_66b4:
    or [hl]                                       ; $66B4
    add hl, bc                                    ; $66B5
    dec d                                         ; $66B6
    jr nz, jr_009_66b4                            ; $66B7

    and a                                         ; $66B9
    ret                                           ; $66BA


; C: a lone ret
Mode21_State0D_Unused::
    ret                                           ; $66BB


; C: state := 0
Mode21_State0E_Leave::
    call Pal_FadeOut                              ; $66BC
    call Lcd_Off                                  ; $66BF
    ld hl, hStatShadow                            ; $66C2
    res 6, [hl]                                   ; $66C5
    ld hl, rIE                                    ; $66C7
    res 1, [hl]                                   ; $66CA
    set_state STATE_21_INIT                       ; $66CC
    ret                                           ; $66D1


; C: copies 72 B from 09:66E1 to $D000
Run_ClearRaceState::
    ld hl, Run_InitialStateTbl                    ; $66D2
    ld de, wRunPlayerPos                          ; $66D5
    ld b, $48                                     ; $66D8

jr_009_66da:
    ld a, [hl+]                                   ; $66DA
    ld [de], a                                    ; $66DB
    inc de                                        ; $66DC
    dec b                                         ; $66DD
    jr nz, jr_009_66da                            ; $66DE

    ret                                           ; $66E0


; C
Run_InitialStateTbl::
    db $60, $ff, $01, $00, $01, $00, $00, $ee, $00, $00, $00, $00, $00, $00, $00, $ff
    db $01, $00, $01, $27, $00, $00, $00, $a0, $ff, $01, $00, $01, $8c, $00, $00, $00
    db $00, $00, $00, $00, $a0, $00, $ff

    ; padding
    ds $21, $00

; C
Run_UpdatePlayer::
    call Run_StumbleTick                          ; $6729
    call Run_PlayerRun                            ; $672C
    call Run_PlayerJump                           ; $672F
    call Run_PlayerAirB                           ; $6732
    call Run_PlayerLanding                        ; $6735
    call Run_PlayerSpeedFromCounter               ; $6738
    call Run_PlayerFrameFromSpeed                 ; $673B
    ret                                           ; $673E


; C: D044 counts down
Run_StumbleTick::
    ld a, [wRunStumbleCounter]                    ; $673F
    and a                                         ; $6742
    ret z                                         ; $6743

    dec a                                         ; $6744
    ld [wRunStumbleCounter], a                    ; $6745
    ld [wRunPlayerRunCounter], a                  ; $6748
    ld hl, hKeysNew                               ; $674B
    res 0, [hl]                                   ; $674E
    ret                                           ; $6750


; C: A key = one step; counter D003
Run_PlayerRun::
    ld a, [wRunPlayerPose]                        ; $6751
    res 7, a                                      ; $6754
    cp $0c                                        ; $6756
    ret nc                                        ; $6758

    ldh a, [hKeysNew]                             ; $6759
    bit PADB_A, a                                 ; $675B
    jr nz, jr_009_676c                            ; $675D

    bit PADB_UP, a                                ; $675F
    ret nz                                        ; $6761

    ld a, [wRunPlayerRunCounter]                  ; $6762
    and a                                         ; $6765
    ret z                                         ; $6766

    dec a                                         ; $6767
    ld [wRunPlayerRunCounter], a                  ; $6768
    ret                                           ; $676B


jr_009_676c:
    ld a, [wRunPlayerRunCounter]                  ; $676C
    ld c, a                                       ; $676F
    ld b, $00                                     ; $6770
    ld hl, Run_SpeedStepTbl                       ; $6772
    add hl, bc                                    ; $6775
    ld a, [hl]                                    ; $6776
    add c                                         ; $6777
    ld [wRunPlayerRunCounter], a                  ; $6778
    ld a, [wRunPlayerSpeedLevel]                  ; $677B
    ld c, a                                       ; $677E
    ld b, $00                                     ; $677F
    ld hl, Run_PlayerRun_Tbl67BE                  ; $6781
    add hl, bc                                    ; $6784
    ld a, [hl]                                    ; $6785
    ld [wRunPlayerStepSize], a                    ; $6786
    ret                                           ; $6789


; C
Run_SpeedStepTbl::
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e
    db $0d, $0d, $0d, $0d, $0c, $0c, $0c, $0c, $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a
    db $09, $09, $09, $09, $08, $08, $08, $08, $07, $06, $05, $04, $03, $02, $01, $00
    db $00, $00, $00, $00

; C: 7 values indexed by the speed level $D002 (0-6): 01 01 01 02 02 03 03, stored to $D008 at every A press of
; Run_PlayerRun (C)
Run_PlayerRun_Tbl67BE::
    db $01, $01, $01, $02, $02, $03, $03

; C: Up = jump; sound $35
Run_PlayerJump::
    ld a, [wRunPlayerPose]                        ; $67C5
    res 7, a                                      ; $67C8
    cp $0c                                        ; $67CA
    ret nc                                        ; $67CC

    ldh a, [hKeysNew]                             ; $67CD
    bit PADB_UP, a                                ; $67CF
    ret z                                         ; $67D1

    push af                                       ; $67D2
    ld a, SFX1_RUN_JUMP                           ; $67D3
    call Snd_Sfx1                                 ; $67D5
    pop af                                        ; $67D8
    ld a, [wRunPlayerRunCounter]                  ; $67D9
    ld c, a                                       ; $67DC
    ld b, $00                                     ; $67DD
    ld hl, Run_PlayerJump_Tbl67FC                 ; $67DF
    add hl, bc                                    ; $67E2
    ld a, [hl]                                    ; $67E3
    ld [wRunPlayerJumpHeight], a                  ; $67E4
    ld a, [wRunPlayerRunCounter]                  ; $67E7
    srl a                                         ; $67EA
    ld [wRunPlayerAirIndex], a                    ; $67EC
    xor a                                         ; $67EF
    ld [wRunPlayerAnimCounter], a                 ; $67F0
    ld [wRunTopSpeedFxTimer], a                   ; $67F3
    ld a, $0c                                     ; $67F6
    ld [wRunPlayerPose], a                        ; $67F8
    ret                                           ; $67FB


; C: 52 jump heights indexed by the run counter $D003: 24 26 26 26 28 28 28 28 2A x8, 2B x4, 2C x4, 2D x4, 2E x4, 2F
; x8, 30 x12; Run_PlayerJump stores the entry to $D005 (height) when Up is pressed (C)
Run_PlayerJump_Tbl67FC::
    db $24, $26, $26, $26, $28, $28, $28, $28, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a
    db $2b, $2b, $2b, $2b, $2c, $2c, $2c, $2c, $2d, $2d, $2d, $2d, $2e, $2e, $2e, $2e
    db $2f, $2f, $2f, $2f, $2f, $2f, $2f, $2f, $30, $30, $30, $30, $30, $30, $30, $30
    db $30, $30, $30, $30

; C: B in the air raises D007
Run_PlayerAirB::
    ld a, [wRunPlayerPose]                        ; $6830
    res 7, a                                      ; $6833
    cp $0c                                        ; $6835
    ret c                                         ; $6837

    ldh a, [hKeysNew]                             ; $6838
    bit PADB_B, a                                 ; $683A
    jr nz, jr_009_684a                            ; $683C

    ld a, [wRunPlayerAirIndex]                    ; $683E
    sub $02                                       ; $6841
    jr nc, jr_009_6846                            ; $6843

    xor a                                         ; $6845

jr_009_6846:
    ld [wRunPlayerAirIndex], a                    ; $6846
    ret                                           ; $6849


jr_009_684a:
    ld a, [wRunPlayerAirIndex]                    ; $684A
    ld c, a                                       ; $684D
    ld b, $00                                     ; $684E
    ld hl, Run_PlayerAirB_Tbl685A                 ; $6850
    add hl, bc                                    ; $6853
    ld a, [hl]                                    ; $6854
    add c                                         ; $6855
    ld [wRunPlayerAirIndex], a                    ; $6856
    ret                                           ; $6859


; C: 32 bytes indexed by $D007 (0-31): 12 12 12 12 11 11 10 10 0F 0F 0E 0E 0D 0D 0C 0C 0B 0B 0A 0A 09 09 08 08 07 06
; 05 04 03 02 01 00; Run_PlayerAirB (09:6830, state >= $0C) adds the entry to $D007 while the jump button is held and
; subtracts 2 otherwise (C). The last 6 bytes (05 04 03 02 01 00) used to ...
Run_PlayerAirB_Tbl685A::
    db $12, $12, $12, $12, $11, $11, $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c
    db $0b, $0b, $0a, $0a, $09, $09, $08, $08, $07, $06, $05, $04, $03, $02, $01, $00

; C
Run_PlayerSpeedFromCounter::
    ld a, [wRunPlayerPose]                        ; $687A
    res 7, a                                      ; $687D
    cp $0c                                        ; $687F
    ret nc                                        ; $6881

    ld a, [wRunPlayerRunCounter]                  ; $6882
    ld c, a                                       ; $6885
    ld b, $00                                     ; $6886
    ld hl, Run_SpeedLevelTbl                      ; $6888
    add hl, bc                                    ; $688B
    ld a, [hl]                                    ; $688C
    ld [wRunPlayerSpeedLevel], a                  ; $688D
    ld c, a                                       ; $6890
    ld hl, Run_PlayerSpeedFromCounter_Tbl68F3     ; $6891
    add hl, bc                                    ; $6894
    ld a, [hl]                                    ; $6895
    ld [wRunPlayerTickStep], a                    ; $6896
    ld a, [wRunPlayerSpeedLevel]                  ; $6899
    and a                                         ; $689C
    ret nz                                        ; $689D

    ld a, [wRunPlayerPose]                        ; $689E
    cp $87                                        ; $68A1
    jr nz, jr_009_68af                            ; $68A3

    ld a, [wRunPlayerStepSize]                    ; $68A5
    and a                                         ; $68A8
    jr z, jr_009_68af                             ; $68A9

    dec a                                         ; $68AB
    ld [wRunPlayerStepSize], a                    ; $68AC

jr_009_68af:
    ld a, [wRunPlayerStepSize]                    ; $68AF
    and a                                         ; $68B2
    jr nz, jr_009_68b9                            ; $68B3

    ld [wRunPlayerTickStep], a                    ; $68B5
    ret                                           ; $68B8


jr_009_68b9:
    ld a, $01                                     ; $68B9
    ld [wRunPlayerSpeedLevel], a                  ; $68BB
    ret                                           ; $68BE


; C: 52 entries indexed by the counter $D003: speed level 0-6 (00 01 01 01 02.. 06); read by
; Run_PlayerSpeedFromCounter; the 20 + padding 16 + 16 byte split was a typing artefact
Run_SpeedLevelTbl::
    db $00, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $03
    db $03, $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $04, $05, $05, $05, $05, $05, $05, $05, $05, $05, $06, $06, $06
    db $06, $06, $06, $06

; C: 7 values indexed by the speed level $D002: 0E 0E 12 15 20 2A 40, stored to $D004 = the tick step passed to
; Run_DrawMeta by Run_DrawPlayer (the run animation goes faster with the level) (C)
Run_PlayerSpeedFromCounter_Tbl68F3::
    db $0e, $0e, $12, $15, $20, $2a, $40

; C: swaps the run frame of $D00B with the counter $D003: below $2F a frame 9 becomes 6, from $2F a frame 4 becomes
; $0B (C)
Run_PlayerFrameFromSpeed::
    ld a, [wRunPlayerRunCounter]                  ; $68FA
    cp $2f                                        ; $68FD
    ld a, [wRunState + $b]                        ; $68FF
    jr nc, jr_009_690d                            ; $6902

    cp $09                                        ; $6904
    ret nz                                        ; $6906

    ld a, $06                                     ; $6907
    ld [wRunState + $b], a                        ; $6909
    ret                                           ; $690C


jr_009_690d:
    cp $04                                        ; $690D
    ret nz                                        ; $690F

    ld a, $0b                                     ; $6910
    ld [wRunState + $b], a                        ; $6912
    ret                                           ; $6915


; C: landing logic of the jump, for the state $D009 (bit 7 ignored) >= $0C (it sets the tick step $D004 := 1): in
; state $0C, when $D00A = 1, it subtracts Run_PlayerLanding_Tbl696E[$D007] from the height $D005 (floor 0) and when
; the height is below $10 clears $D00A and sets the state $10; in state $12 it ...
Run_PlayerLanding::
    ld a, [wRunPlayerPose]                        ; $6916
    res 7, a                                      ; $6919
    cp $0c                                        ; $691B
    ret c                                         ; $691D

    ld a, $01                                     ; $691E
    ld [wRunPlayerTickStep], a                    ; $6920
    jr nz, jr_009_6951                            ; $6923

    ld a, $01                                     ; $6925
    ld [wRunPlayerTickStep], a                    ; $6927
    ld a, [wRunPlayerAnimCounter]                 ; $692A
    cp $01                                        ; $692D
    ret nz                                        ; $692F

    ld a, [wRunPlayerAirIndex]                    ; $6930
    ld c, a                                       ; $6933
    ld b, $00                                     ; $6934
    ld hl, Run_PlayerLanding_Tbl696E              ; $6936
    add hl, bc                                    ; $6939
    ld a, [wRunPlayerJumpHeight]                  ; $693A
    sub [hl]                                      ; $693D
    jr nc, jr_009_6941                            ; $693E

    xor a                                         ; $6940

jr_009_6941:
    ld [wRunPlayerJumpHeight], a                  ; $6941
    cp $10                                        ; $6944
    ret nc                                        ; $6946

    xor a                                         ; $6947
    ld [wRunPlayerAnimCounter], a                 ; $6948
    ld a, $10                                     ; $694B
    ld [wRunPlayerPose], a                        ; $694D
    ret                                           ; $6950


jr_009_6951:
    ld a, [wRunPlayerPose]                        ; $6951
    res 7, a                                      ; $6954
    cp $12                                        ; $6956
    ret nz                                        ; $6958

    xor a                                         ; $6959
    ld [wRunPlayerJumpHeight], a                  ; $695A
    ld a, [wRunPlayerRunCounter]                  ; $695D
    sub $20                                       ; $6960
    jr nc, jr_009_6965                            ; $6962

    xor a                                         ; $6964

jr_009_6965:
    ld [wRunPlayerRunCounter], a                  ; $6965
    ld a, $07                                     ; $6968
    ld a, [wRunPlayerPose]                        ; $696A
    ret                                           ; $696D


; C: 32 height steps indexed by $D007 (0-31): 12 12 10 10 0E 0E 0A 0A 08 x12, 07 x4, 06 x8; subtracted from the jump
; height $D005 by Run_PlayerLanding (C)
Run_PlayerLanding_Tbl696E::
    db $12, $12, $10, $10, $0e, $0e, $0a, $0a, $08, $08, $08, $08, $08, $08, $08, $08
    db $08, $08, $08, $08, $07, $07, $07, $07, $06, $06, $06, $06, $06, $06, $06, $06

; C: table 69AB (3 px/frame) or 69B7 (5 px/frame)
Run_UpdateChick::
    ld hl, Run_ChickPathTblSlow                   ; $698E
    ld a, [wRunRaceCounter]                       ; $6991
    and $03                                       ; $6994
    jr nz, jr_009_699b                            ; $6996

    ld hl, Run_ChickPathTblFast                   ; $6998

jr_009_699b:
    ld a, [wRunChickState]                        ; $699B
    res 7, a                                      ; $699E
    sub $06                                       ; $69A0
    ld c, a                                       ; $69A2
    ld b, $00                                     ; $69A3
    add hl, bc                                    ; $69A5
    ld a, [hl]                                    ; $69A6
    ld [wRunChickSpeed], a                        ; $69A7
    ret                                           ; $69AA


; C
Run_ChickPathTblSlow::
    db $05, $07, $09, $0b, $0b, $09, $07, $05, $03, $03, $03, $03

; C
Run_ChickPathTblFast::
    db $05, $07, $09, $0b, $0b, $09, $07, $05, $05, $05, $05, $05

; C: table 69DF (4 px) or 69E3 (5 px)
Run_UpdateMole::
    ld hl, Run_MolePathTblSlow                    ; $69C3
    ld a, [wRunPlayerLeads]                       ; $69C6
    and a                                         ; $69C9
    jr z, jr_009_69cf                             ; $69CA

    ld hl, Run_MolePathTblFast                    ; $69CC

jr_009_69cf:
    ld a, [wRunMoleState]                         ; $69CF
    res 7, a                                      ; $69D2
    sub $07                                       ; $69D4
    ld c, a                                       ; $69D6
    ld b, $00                                     ; $69D7
    add hl, bc                                    ; $69D9
    ld a, [hl]                                    ; $69DA
    ld [wRunMoleSpeed], a                         ; $69DB
    ret                                           ; $69DE


; C
Run_MolePathTblSlow::
    db $08, $0d, $10, $12

; C
Run_MolePathTblFast::
    db $12, $10, $0d, $08, $04, $04, $04, $04, $05, $05, $05, $05

; C: 0 < x - hurdle <= 24: stumble; sound $04
Run_HurdleCollision::
    ld a, [wRunPlayerJumpHeight]                  ; $69EF
    cp $01                                        ; $69F2
    ret nc                                        ; $69F4

    ld hl, wRunState + $2c                        ; $69F5
    ld de, Run_HurdleXTbl                         ; $69F8
    ld b, $0c                                     ; $69FB

jr_009_69fd:
    push bc                                       ; $69FD
    push de                                       ; $69FE
    push hl                                       ; $69FF
    ld hl, wRunPlayerPos                          ; $6A00
    ld a, [de]                                    ; $6A03
    sub [hl]                                      ; $6A04
    ld c, a                                       ; $6A05
    inc hl                                        ; $6A06
    inc de                                        ; $6A07
    ld a, [de]                                    ; $6A08
    sbc [hl]                                      ; $6A09
    ld b, a                                       ; $6A0A
    ld a, c                                       ; $6A0B
    add $18                                       ; $6A0C
    ld c, a                                       ; $6A0E
    jr nc, jr_009_6a12                            ; $6A0F

    inc b                                         ; $6A11

jr_009_6a12:
    ld a, b                                       ; $6A12
    and a                                         ; $6A13
    jr nz, jr_009_6a35                            ; $6A14

    ld a, c                                       ; $6A16
    cp $18                                        ; $6A17
    jr nc, jr_009_6a35                            ; $6A19

    pop hl                                        ; $6A1B
    push hl                                       ; $6A1C
    ld a, [hl]                                    ; $6A1D
    res 7, a                                      ; $6A1E
    cp $02                                        ; $6A20
    jr nc, jr_009_6a35                            ; $6A22

    push af                                       ; $6A24
    ld a, SFX4_RUN_HURDLE_HIT                     ; $6A25
    call Snd_Sfx4                                 ; $6A27
    pop af                                        ; $6A2A
    ld a, $02                                     ; $6A2B
    ld [hl+], a                                   ; $6A2D
    xor a                                         ; $6A2E
    ld [hl], a                                    ; $6A2F
    ld a, $05                                     ; $6A30
    ld [wRunStumbleCounter], a                    ; $6A32

jr_009_6a35:
    pop hl                                        ; $6A35
    pop de                                        ; $6A36
    pop bc                                        ; $6A37
    inc hl                                        ; $6A38
    inc hl                                        ; $6A39
    inc de                                        ; $6A3A
    inc de                                        ; $6A3B
    dec b                                         ; $6A3C
    jr nz, jr_009_69fd                            ; $6A3D

    ret                                           ; $6A3F


; C: A presses hoist the flag
Run_FlagHoistKeys::
    ld a, [wRunFlagCounter]                       ; $6A40
    ld c, a                                       ; $6A43
    ld b, $00                                     ; $6A44
    ld hl, Run_FlagHoistKeys_LevelTbl             ; $6A46
    add hl, bc                                    ; $6A49
    ld a, [hl]                                    ; $6A4A
    ld [wRunFlagLevel], a                         ; $6A4B
    ldh a, [hKeysNew]                             ; $6A4E
    bit PADB_A, a                                 ; $6A50
    jr nz, jr_009_6a5e                            ; $6A52

    ld a, [wRunFlagCounter]                       ; $6A54
    and a                                         ; $6A57
    ret z                                         ; $6A58

    dec a                                         ; $6A59
    ld [wRunFlagCounter], a                       ; $6A5A
    ret                                           ; $6A5D


jr_009_6a5e:
    ld a, [wRunFlagCounter]                       ; $6A5E
    ld c, a                                       ; $6A61
    ld b, $00                                     ; $6A62
    ld hl, Run_FlagHoistKeys_StepTbl              ; $6A64
    add hl, bc                                    ; $6A67
    ld a, [hl]                                    ; $6A68
    add c                                         ; $6A69
    ld [wRunFlagCounter], a                       ; $6A6A
    ret                                           ; $6A6D


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
    ld hl, wRunPlayerSpeedLevel                   ; $6AD6
    ld de, wRunPlayerPos                          ; $6AD9
    call Run_Add16                                ; $6ADC
    ld a, [wRunPlayerPos + $1]                    ; $6ADF
    bit 7, a                                      ; $6AE2
    ret nz                                        ; $6AE4

    cp $14                                        ; $6AE5
    ret c                                         ; $6AE7

    jr nz, jr_009_6af0                            ; $6AE8

    ld a, [wRunPlayerPos]                         ; $6AEA
    cp $00                                        ; $6AED
    ret c                                         ; $6AEF

jr_009_6af0:
    ld a, [wRunState + $d]                        ; $6AF0
    and a                                         ; $6AF3
    ret nz                                        ; $6AF4

    ld a, [wRunState + $47]                       ; $6AF5
    inc a                                         ; $6AF8
    ld [wRunState + $47], a                       ; $6AF9
    ld [wRunState + $d], a                        ; $6AFC
    ret                                           ; $6AFF


; C
Run_MoveChickX::
    ld hl, wRunChickSpeed                         ; $6B00
    ld de, wRunChickPos                           ; $6B03
    call Run_Add16                                ; $6B06
    ld a, [wRunChickPos + $1]                     ; $6B09
    bit 7, a                                      ; $6B0C
    ret nz                                        ; $6B0E

    cp $14                                        ; $6B0F
    ret c                                         ; $6B11

    jr nz, jr_009_6b1a                            ; $6B12

    ld a, [wRunChickPos]                          ; $6B14
    cp $00                                        ; $6B17
    ret c                                         ; $6B19

jr_009_6b1a:
    ld a, [wRunState + $16]                       ; $6B1A
    and a                                         ; $6B1D
    ret nz                                        ; $6B1E

    ld a, [wRunState + $47]                       ; $6B1F
    inc a                                         ; $6B22
    ld [wRunState + $47], a                       ; $6B23
    ld [wRunState + $16], a                       ; $6B26
    ret                                           ; $6B29


; C: sets D050 when the player leads by $A0
Run_MoveMoleX::
    ld hl, wRunMoleSpeed                          ; $6B2A
    ld de, wRunMolePos                            ; $6B2D
    call Run_Add16                                ; $6B30
    ld de, wRunPlayerPos                          ; $6B33
    ld hl, wRunMolePos                            ; $6B36
    ld a, [de]                                    ; $6B39
    sub [hl]                                      ; $6B3A
    ld c, a                                       ; $6B3B
    inc de                                        ; $6B3C
    inc hl                                        ; $6B3D
    ld a, [de]                                    ; $6B3E
    sbc [hl]                                      ; $6B3F
    bit 7, a                                      ; $6B40
    jr nz, jr_009_6b51                            ; $6B42

    and a                                         ; $6B44
    jr nz, jr_009_6b4c                            ; $6B45

    ld a, c                                       ; $6B47
    cp $a0                                        ; $6B48
    jr c, jr_009_6b51                             ; $6B4A

jr_009_6b4c:
    ld a, $01                                     ; $6B4C
    ld [wRunPlayerLeads], a                       ; $6B4E

jr_009_6b51:
    ld a, [wRunMolePos + $1]                      ; $6B51
    bit 7, a                                      ; $6B54
    ret nz                                        ; $6B56

    cp $14                                        ; $6B57
    ret c                                         ; $6B59

    jr nz, jr_009_6b62                            ; $6B5A

    ld a, [wRunMolePos]                           ; $6B5C
    cp $00                                        ; $6B5F
    ret c                                         ; $6B61

jr_009_6b62:
    ld a, [wRunState + $1f]                       ; $6B62
    and a                                         ; $6B65
    ret nz                                        ; $6B66

    ld a, [wRunState + $47]                       ; $6B67
    inc a                                         ; $6B6A
    ld [wRunState + $47], a                       ; $6B6B
    ld [wRunState + $1f], a                       ; $6B6E
    ret                                           ; $6B71


; C: adds the signed speed byte $D026 (sign-extended) to the 16-bit position $D024/$D025 of the fourth runner
; (Run_Add16) (C)
Run_MoveRunner3X::
    ld hl, wRunRunner3Speed                       ; $6B72
    ld de, wRunRunner3Pos                         ; $6B75
    call Run_Add16                                ; $6B78
    ret                                           ; $6B7B


; C: camera: while the player position $D000/$D001 is below $1400 the camera $D020/$D021 follows it
; (Run_CopyPlayerPos); from $1400 (the finish line) the camera is frozen at $1400 (C)
Run_ScrollCamera::
    ld a, [wRunCameraPos]                         ; $6B7C
    cp $00                                        ; $6B7F
    jr nz, jr_009_6b89                            ; $6B81

    ld a, [wRunCameraPos + $1]                    ; $6B83
    cp $14                                        ; $6B86
    ret z                                         ; $6B88

jr_009_6b89:
    call Run_CopyPlayerPos                        ; $6B89
    ld a, [wRunCameraPos + $1]                    ; $6B8C
    cp $14                                        ; $6B8F
    ret c                                         ; $6B91

    jr nz, jr_009_6b9a                            ; $6B92

    ld a, [wRunCameraPos]                         ; $6B94
    cp $00                                        ; $6B97
    ret c                                         ; $6B99

jr_009_6b9a:
    ld a, $00                                     ; $6B9A
    ld [wRunCameraPos], a                         ; $6B9C
    ld a, $14                                     ; $6B9F
    ld [wRunCameraPos + $1], a                    ; $6BA1
    ret                                           ; $6BA4


; C: copies the 16-bit player position $D000/$D001 into the camera $D020/$D021 (C)
Run_CopyPlayerPos::
    ld hl, wRunCameraPos                          ; $6BA5
    ld de, wRunPlayerPos                          ; $6BA8
    ld a, [de]                                    ; $6BAB
    ld [hl+], a                                   ; $6BAC
    inc de                                        ; $6BAD
    ld a, [de]                                    ; $6BAE
    ld [hl], a                                    ; $6BAF
    ret                                           ; $6BB0


; C: D048 = min($74; D048 + 5 or 6) - D049
Run_FlagHeight::
    ld c, $05                                     ; $6BB1
    call Rng_Next                                 ; $6BB3
    and $03                                       ; $6BB6
    jr nz, jr_009_6bbb                            ; $6BB8

    inc c                                         ; $6BBA

jr_009_6bbb:
    ld a, [wRunFlagY]                             ; $6BBB
    cp $02                                        ; $6BBE
    ret z                                         ; $6BC0

    add c                                         ; $6BC1
    cp $74                                        ; $6BC2
    jr c, jr_009_6bc8                             ; $6BC4

    ld a, $74                                     ; $6BC6

jr_009_6bc8:
    ld hl, wRunFlagLevel                          ; $6BC8
    sub [hl]                                      ; $6BCB
    jr c, jr_009_6bd4                             ; $6BCC

    cp $02                                        ; $6BCE
    jr z, jr_009_6bd4                             ; $6BD0

    jr nc, jr_009_6bdd                            ; $6BD2

jr_009_6bd4:
    push af                                       ; $6BD4
    ld a, SFX4_RUN_FLAG_HEIGHT                    ; $6BD5
    call Snd_Sfx4                                 ; $6BD7
    pop af                                        ; $6BDA
    ld a, $02                                     ; $6BDB

jr_009_6bdd:
    ld [wRunFlagY], a                             ; $6BDD
    ret                                           ; $6BE0


; C: updates the 10 confetti records: Run_ConfettiParticle for each record, step 6 (C)
Run_ConfettiUpdate::
    ld bc, $0a00                                  ; $6BE1

jr_009_6be4:
    call Run_ConfettiParticle                     ; $6BE4
    ld a, c                                       ; $6BE7
    add $06                                       ; $6BE8
    ld c, a                                       ; $6BEA
    dec b                                         ; $6BEB
    jr nz, jr_009_6be4                            ; $6BEC

    ret                                           ; $6BEE


; C: one confetti record (offset C): by its frame number the sideways speed dx is applied in full (frames 2, 6, $0B,
; $0F), halved (1, 3, 5, 7, $0A, $0C, $0E, $10) or replaced by a new random +-2 when bit 7 is set; x stays within
; 4..$FB; then y += dy and a carry out of y calls Run_ConfettiRespawn (C)
Run_ConfettiParticle::
    push bc                                       ; $6BEF
    ld b, $00                                     ; $6BF0
    ld hl, wRunConfetti + $4                      ; $6BF2
    add hl, bc                                    ; $6BF5
    ld a, [hl]                                    ; $6BF6
    cp $01                                        ; $6BF7
    jr z, jr_009_6c29                             ; $6BF9

    cp $03                                        ; $6BFB
    jr z, jr_009_6c29                             ; $6BFD

    cp $05                                        ; $6BFF
    jr z, jr_009_6c29                             ; $6C01

    cp $07                                        ; $6C03
    jr z, jr_009_6c29                             ; $6C05

    cp $0a                                        ; $6C07
    jr z, jr_009_6c29                             ; $6C09

    cp $0c                                        ; $6C0B
    jr z, jr_009_6c29                             ; $6C0D

    cp $0e                                        ; $6C0F
    jr z, jr_009_6c29                             ; $6C11

    cp $10                                        ; $6C13
    jr z, jr_009_6c29                             ; $6C15

    cp $02                                        ; $6C17
    jr z, jr_009_6c40                             ; $6C19

    cp $06                                        ; $6C1B
    jr z, jr_009_6c40                             ; $6C1D

    cp $0b                                        ; $6C1F
    jr z, jr_009_6c40                             ; $6C21

    cp $0f                                        ; $6C23
    jr z, jr_009_6c40                             ; $6C25

    jr jr_009_6c55                                ; $6C27

jr_009_6c29:
    ld hl, wRunConfetti + $1                      ; $6C29
    add hl, bc                                    ; $6C2C
    ld a, [hl]                                    ; $6C2D
    sra a                                         ; $6C2E
    ld hl, wRunConfetti                           ; $6C30
    add hl, bc                                    ; $6C33
    add [hl]                                      ; $6C34
    cp $04                                        ; $6C35
    jr c, jr_009_6c6b                             ; $6C37

    cp $fc                                        ; $6C39
    jr nc, jr_009_6c6b                            ; $6C3B

    ld [hl], a                                    ; $6C3D
    jr jr_009_6c6b                                ; $6C3E

jr_009_6c40:
    ld hl, wRunConfetti + $1                      ; $6C40
    add hl, bc                                    ; $6C43
    ld a, [hl]                                    ; $6C44
    ld hl, wRunConfetti                           ; $6C45
    add hl, bc                                    ; $6C48
    add [hl]                                      ; $6C49
    cp $04                                        ; $6C4A
    jr c, jr_009_6c6b                             ; $6C4C

    cp $fc                                        ; $6C4E
    jr nc, jr_009_6c6b                            ; $6C50

    ld [hl], a                                    ; $6C52
    jr jr_009_6c6b                                ; $6C53

jr_009_6c55:
    bit 7, a                                      ; $6C55
    jr z, jr_009_6c6b                             ; $6C57

    call Rng_Next                                 ; $6C59
    bit 0, a                                      ; $6C5C
    jr nz, jr_009_6c64                            ; $6C5E

    ld a, $02                                     ; $6C60
    jr jr_009_6c66                                ; $6C62

jr_009_6c64:
    ld a, $fe                                     ; $6C64

jr_009_6c66:
    ld hl, wRunConfetti + $1                      ; $6C66
    add hl, bc                                    ; $6C69
    ld [hl], a                                    ; $6C6A

jr_009_6c6b:
    ld hl, wRunConfetti + $3                      ; $6C6B
    add hl, bc                                    ; $6C6E
    ld a, [hl]                                    ; $6C6F
    ld hl, wRunConfetti + $2                      ; $6C70
    add hl, bc                                    ; $6C73
    add [hl]                                      ; $6C74
    ld [hl], a                                    ; $6C75
    call c, Run_ConfettiRespawn                   ; $6C76
    pop bc                                        ; $6C79
    ret                                           ; $6C7A


; C: respawn of a confetti record: when $D048 = 2 it sets y and dy to 0 (the piece stays), else a new random x
; ((random & $F8) + 4) and y (random & $0F) (C)
Run_ConfettiRespawn::
    ld a, [wRunFlagY]                             ; $6C7B
    cp $02                                        ; $6C7E
    jr z, jr_009_6c99                             ; $6C80

    call Rng_Next                                 ; $6C82
    and $f8                                       ; $6C85
    add $04                                       ; $6C87
    ld hl, wRunConfetti                           ; $6C89
    add hl, bc                                    ; $6C8C
    ld [hl], a                                    ; $6C8D
    call Rng_Next                                 ; $6C8E
    and $0f                                       ; $6C91
    ld hl, wRunConfetti + $2                      ; $6C93
    add hl, bc                                    ; $6C96
    ld [hl], a                                    ; $6C97
    ret                                           ; $6C98


jr_009_6c99:
    xor a                                         ; $6C99
    ld hl, wRunConfetti + $2                      ; $6C9A
    add hl, bc                                    ; $6C9D
    ld [hl+], a                                   ; $6C9E
    ld [hl+], a                                   ; $6C9F
    ret                                           ; $6CA0


; C: requests $30 then $16; pose table 09:6CE1
Run_Celebration::
    ld a, [wRunCelebrationStep]                   ; $6CA1
    inc a                                         ; $6CA4
    cp $0d                                        ; $6CA5
    jr nc, jr_009_6cce                            ; $6CA7

    ld [wRunCelebrationStep], a                   ; $6CA9
    cp $01                                        ; $6CAC
    jr nz, jr_009_6cb7                            ; $6CAE

    push af                                       ; $6CB0
    ld a, SFX1_RUN_CELEBRATION                    ; $6CB1
    call Snd_Sfx1                                 ; $6CB3
    pop af                                        ; $6CB6

jr_009_6cb7:
    cp $0c                                        ; $6CB7
    jr nz, jr_009_6cc2                            ; $6CB9

    push af                                       ; $6CBB
    ld a, SFX1_OPTION_CHANGE                      ; $6CBC
    call Snd_Sfx1                                 ; $6CBE
    pop af                                        ; $6CC1

jr_009_6cc2:
    ld c, a                                       ; $6CC2
    ld b, $00                                     ; $6CC3
    ld hl, Run_CelebrationPoseTbl                 ; $6CC5
    add hl, bc                                    ; $6CC8
    ld a, [hl]                                    ; $6CC9
    ld [wRunCrownY], a                            ; $6CCA
    ret                                           ; $6CCD


jr_009_6cce:
    ld a, [wRunPlayerPose]                        ; $6CCE
    cp $14                                        ; $6CD1
    jr nz, jr_009_6cdb                            ; $6CD3

    ld a, $0c                                     ; $6CD5
    ld [wRunCrownY], a                            ; $6CD7
    ret                                           ; $6CDA


jr_009_6cdb:
    ld a, $0d                                     ; $6CDB
    ld [wRunCrownY], a                            ; $6CDD
    ret                                           ; $6CE0


; C
Run_CelebrationPoseTbl::
    db $fc, $fd, $fe, $ff, $00, $01, $02, $03, $05, $08, $0c, $0b, $0c

; C: [DE] += [HL] with sign extension
Run_Add16::
    ld a, [de]                                    ; $6CEE
    add [hl]                                      ; $6CEF
    ld [de], a                                    ; $6CF0
    inc de                                        ; $6CF1
    bit 7, [hl]                                   ; $6CF2
    jr nz, jr_009_6cfb                            ; $6CF4

    ld a, [de]                                    ; $6CF6
    adc $00                                       ; $6CF7
    ld [de], a                                    ; $6CF9
    ret                                           ; $6CFA


jr_009_6cfb:
    ld a, [de]                                    ; $6CFB
    adc $ff                                       ; $6CFC
    ld [de], a                                    ; $6CFE
    ret                                           ; $6CFF


; C: UNREFERENCED: 16-bit subtraction helper
Unused_Run_Sub16::
    ld a, [de]                                    ; $6D00
    sub [hl]                                      ; $6D01
    ld [de], a                                    ; $6D02
    inc de                                        ; $6D03
    bit 7, [hl]                                   ; $6D04
    jr nz, jr_009_6d0d                            ; $6D06

    ld a, [de]                                    ; $6D08
    sbc $00                                       ; $6D09
    ld [de], a                                    ; $6D0B
    ret                                           ; $6D0C


jr_009_6d0d:
    ld a, [de]                                    ; $6D0D
    sbc $ff                                       ; $6D0E
    ld [de], a                                    ; $6D10
    ret                                           ; $6D11


; C
Run_DrawPlayer::
    ld hl, wRunCameraPos                          ; $6D12
    ld a, [wRunPlayerPos]                         ; $6D15
    sub [hl]                                      ; $6D18
    ld c, a                                       ; $6D19
    inc hl                                        ; $6D1A
    ld a, [wRunPlayerPos + $1]                    ; $6D1B
    sbc [hl]                                      ; $6D1E
    sra a                                         ; $6D1F
    rr c                                          ; $6D21
    call Run_OffscreenTest                        ; $6D23
    jr nc, jr_009_6d2d                            ; $6D26

    ld a, $a0                                     ; $6D28
    ldh [hScxBand1], a                            ; $6D2A
    ld c, a                                       ; $6D2C

jr_009_6d2d:
    ld a, c                                       ; $6D2D
    push af                                       ; $6D2E
    cpl                                           ; $6D2F
    add $79                                       ; $6D30
    ld b, a                                       ; $6D32
    ld a, [wRunPlayerJumpHeight]                  ; $6D33
    sra a                                         ; $6D36
    cpl                                           ; $6D38
    add $71                                       ; $6D39
    ld c, a                                       ; $6D3B
    pop af                                        ; $6D3C
    ldh [hScxBand1], a                            ; $6D3D
    push bc                                       ; $6D3F
    ld hl, Run_DrawPlayer_Tbl6DA8                 ; $6D40
    ld de, wRunPlayerPose                         ; $6D43
    ld a, [wRunPlayerTickStep]                    ; $6D46
    call Run_DrawMeta                             ; $6D49
    pop bc                                        ; $6D4C
    push af                                       ; $6D4D
    ld a, [wRunPlayerPose]                        ; $6D4E
    cp $8a                                        ; $6D51
    jr nz, jr_009_6d61                            ; $6D53

    ld a, [wRunPlayerSpeedLevel]                  ; $6D55
    cp $04                                        ; $6D58
    jr c, jr_009_6d61                             ; $6D5A

    ld a, $05                                     ; $6D5C
    ld [wRunTopSpeedFxTimer], a                   ; $6D5E

jr_009_6d61:
    ld a, [wRunTopSpeedFxTimer]                   ; $6D61
    and a                                         ; $6D64
    jr z, jr_009_6d70                             ; $6D65

    dec a                                         ; $6D67
    ld [wRunTopSpeedFxTimer], a                   ; $6D68
    ld a, $2c                                     ; $6D6B
    call Oam_AddMeta_B02_6E4B                     ; $6D6D

jr_009_6d70:
    pop af                                        ; $6D70
    cp $53                                        ; $6D71
    jr c, jr_009_6d7f                             ; $6D73

    sub $53                                       ; $6D75
    ld c, a                                       ; $6D77
    ld b, $00                                     ; $6D78
    ld hl, Run_DrawPlayer_Tbl6DA4                 ; $6D7A
    jr jr_009_6d87                                ; $6D7D

jr_009_6d7f:
    sub $13                                       ; $6D7F
    ld c, a                                       ; $6D81
    ld b, $00                                     ; $6D82
    ld hl, Run_DrawPlayer_Tbl6D9C                 ; $6D84

jr_009_6d87:
    add hl, bc                                    ; $6D87
    ld a, [wRunPlayerJumpHeight]                  ; $6D88
    sra a                                         ; $6D8B
    add [hl]                                      ; $6D8D
    ld c, a                                       ; $6D8E
    ld hl, Run_DrawPlayer_Tbl6DDC                 ; $6D8F
    ld de, wRunState + $b                         ; $6D92
    ld a, [wRunPlayerTickStep]                    ; $6D95
    call Run_SplitScreenLine                      ; $6D98
    ret                                           ; $6D9B


; C: 8 vertical offsets for the metas $13-$1A, added to height/2 by Run_DrawPlayer before the second layer
; (SplitScreenLine): FF FF 00 00 01 04 06 02 (C)
Run_DrawPlayer_Tbl6D9C::
    db $ff, $ff, $00, $00, $01, $04, $06, $02

; C: 4 vertical offsets for the metas $53-$56: 04 03 04 02 (Run_DrawPlayer) (C)
Run_DrawPlayer_Tbl6DA4::
    db $04, $03, $04, $02

; C: player animation list ($D009 = pose, step $D004): 13 04 14 04 15 04 16 04 FF 00 (run cycle, loops to 0) / 13 80
; FF 05 / 13 80 14 80 15 80 16 80 FF 07 / 1A 04 17 04 18 04 FF 0C / 19 04 16 03 16 00 FF 07 / 53 0C 54 0C FF 14 / 55
; 20 56 20 FF 17: animation list read by Run_DrawMeta / ...
Run_DrawPlayer_Tbl6DA8::
    db $13, $04, $14, $04, $15, $04, $16, $04, $ff, $00, $13, $80, $ff, $05, $13, $80
    db $14, $80, $15, $80, $16, $80, $ff, $07, $1a, $04, $17, $04, $18, $04, $ff, $0c
    db $19, $04, $16, $03, $16, $00, $ff, $07, $53, $0c, $54, $0c, $ff, $14, $55, $20
    db $56, $20, $ff, $17

; C: second layer of the player: list of {value, duration} read by Run_SplitScreenLine with the state $D00B; the value
; plus the vertical offset goes to $FFBA (scroll Y of the LCD split band): E0 20 30 20 FF 00 / E0 C0 30 C0 FF 03 / 30
; 80 FF 03 / 88 D0 30 80 FF 08 / 30 80 FF 08 / E0 80 FF 0D / E0 10 30 ...
Run_DrawPlayer_Tbl6DDC::
    db $e0, $20, $30, $20, $ff, $00, $e0, $c0, $30, $c0, $ff, $03, $30, $80, $ff, $03
    db $88, $d0, $30, $80, $ff, $08, $30, $80, $ff, $08, $e0, $80, $ff, $0d, $e0, $10
    db $30, $40, $ff, $0d, $e0, $0c, $30, $0c, $ff, $12

; C
Run_DrawChick::
    ld hl, wRunCameraPos                          ; $6E06
    ld a, [wRunChickPos]                          ; $6E09
    sub [hl]                                      ; $6E0C
    ld c, a                                       ; $6E0D
    inc hl                                        ; $6E0E
    ld a, [wRunChickPos + $1]                     ; $6E0F
    sbc [hl]                                      ; $6E12
    sra a                                         ; $6E13
    rr c                                          ; $6E15
    call Run_OffscreenTest                        ; $6E17
    jr nc, jr_009_6e1e                            ; $6E1A

    ld c, $c0                                     ; $6E1C

jr_009_6e1e:
    ld a, c                                       ; $6E1E
    cpl                                           ; $6E1F
    add $79                                       ; $6E20
    ld b, a                                       ; $6E22
    ld a, [wRunState + $13]                       ; $6E23
    ld c, a                                       ; $6E26
    ld hl, Run_DrawChick_Tbl6E34                  ; $6E27
    ld de, wRunChickState                         ; $6E2A
    ld a, [wRunChickAnimStep]                     ; $6E2D
    call Run_DrawMeta                             ; $6E30
    ret                                           ; $6E33


; C: chick animation list ($D014 = state, step $D012): animation list read by Run_DrawMeta / Run_SplitScreenLine:
; pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it receives in A to the
; tick byte each call; the next entry is taken when the tick reaches the ...
Run_DrawChick_Tbl6E34::
    db $20, $04, $21, $04, $22, $04, $ff, $00, $1f, $80, $ff, $04, $20, $05, $21, $05
    db $22, $05, $20, $04, $21, $04, $22, $04, $20, $03, $21, $03, $22, $03, $20, $04
    db $21, $04, $22, $04, $ff, $0f, $3d, $30, $3e, $04, $3f, $04, $42, $04, $3d, $34
    db $41, $04, $40, $04, $42, $02, $43, $02, $44, $02, $43, $02, $44, $02, $46, $34
    db $45, $04, $3d, $14, $3e, $04, $3f, $04, $40, $04, $3e, $04, $3f, $04, $40, $04
    db $3d, $30, $45, $04, $46, $04, $47, $04, $48, $34, $47, $06, $46, $06, $45, $04
    db $ff, $13

; C
Run_DrawMoleAndScene::
    ld hl, wRunCameraPos                          ; $6E96
    ld a, [wRunMolePos]                           ; $6E99
    sub [hl]                                      ; $6E9C
    ld c, a                                       ; $6E9D
    inc hl                                        ; $6E9E
    ld a, [wRunMolePos + $1]                      ; $6E9F
    sbc [hl]                                      ; $6EA2
    sra a                                         ; $6EA3
    rr c                                          ; $6EA5
    call Run_OffscreenTest                        ; $6EA7
    jr nc, jr_009_6eae                            ; $6EAA

    ld c, $c0                                     ; $6EAC

jr_009_6eae:
    ld a, c                                       ; $6EAE
    cpl                                           ; $6EAF
    add $71                                       ; $6EB0
    ld b, a                                       ; $6EB2
    ld a, [wRunState + $1c]                       ; $6EB3
    ld c, a                                       ; $6EB6
    ld hl, Run_DrawMoleAndScene_Tbl6EC4           ; $6EB7
    ld de, wRunMoleState                          ; $6EBA
    ld a, [wRunMoleAnimStep]                      ; $6EBD
    call Run_DrawMeta                             ; $6EC0
    ret                                           ; $6EC3


; C: mole animation list ($D01D = state, step $D01B): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs
; {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it receives in A to the tick
; byte each call; the next entry is taken when the tick reaches the ...
Run_DrawMoleAndScene_Tbl6EC4::
    db $24, $04, $23, $04, $25, $04, $23, $04, $ff, $00, $33, $80, $ff, $05, $24, $04
    db $23, $04, $25, $04, $23, $04, $24, $04, $23, $04, $25, $04, $23, $04, $24, $04
    db $23, $04, $25, $04, $23, $04, $ff, $0f, $38, $30, $39, $06, $38, $17, $39, $06
    db $38, $06, $39, $06, $38, $08, $39, $08, $38, $38, $3a, $04, $3b, $05, $3c, $28
    db $3b, $03, $3a, $04, $ff, $14

; C: draws the fourth runner (meta $34 at x = -(position / 2), y = 0) when its position $D024/$D025 is on screen
; (Run_ScaledPosition returns NC) (C)
Run_DrawRunner3::
    ld a, [wRunRunner3Pos]                        ; $6F0A
    ld c, a                                       ; $6F0D
    ld a, [wRunRunner3Pos + $1]                   ; $6F0E
    sra a                                         ; $6F11
    rr c                                          ; $6F13
    call Run_OffscreenTest                        ; $6F15
    ret c                                         ; $6F18

    ld a, c                                       ; $6F19
    cpl                                           ; $6F1A
    inc a                                         ; $6F1B
    ld b, a                                       ; $6F1C
    ld c, $00                                     ; $6F1D
    ld a, $34                                     ; $6F1F
    call Oam_AddMeta_B02_6E4B                     ; $6F21
    ret                                           ; $6F24


; C: draws the podium banner at x = $36, y = $40 with Run_BannerSpriteTbl and the state $D02A (Run_DrawMeta, tick step
; 1) (C)
Run_DrawPodiumBanner::
    ld bc, $3640                                  ; $6F25
    ld hl, Run_BannerSpriteTbl                    ; $6F28
    ld de, wRunBannerState                        ; $6F2B
    ld a, $01                                     ; $6F2E
    call Run_DrawMeta                             ; $6F30
    ret                                           ; $6F33


; C: banner animation list: 00 50 26 03 27 03 28 20 27 03 26 03 00 30 2A 01 29 01 2A 02 2B 10 00 02 00 80 FF 0C (meta
; 0 = nothing): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n
; jumps to entry n (Run_DrawMeta adds the tick step it receives in A to ...
Run_BannerSpriteTbl::
    db $00, $50, $26, $03, $27, $03, $28, $20, $27, $03, $26, $03, $00, $30, $2a, $01
    db $29, $01, $2a, $02, $2b, $10, $00, $02, $00, $80, $ff, $0c

; C: background scroll: $FFBC := -(camera $D020/$D021 / 2) (C)
Run_DrawBackgroundScroll::
    ld a, [wRunCameraPos]                         ; $6F50
    ld c, a                                       ; $6F53
    ld a, [wRunCameraPos + $1]                    ; $6F54
    sra a                                         ; $6F57
    rr c                                          ; $6F59
    ld a, c                                       ; $6F5B
    cpl                                           ; $6F5C
    inc a                                         ; $6F5D
    ldh [hScxBand2], a                            ; $6F5E
    ret                                           ; $6F60


; C: 12 hurdles from table 09:6F9B
Run_DrawHurdles::
    ld hl, wRunState + $2c                        ; $6F61
    ld de, Run_HurdleXTbl                         ; $6F64
    ld b, $0c                                     ; $6F67

jr_009_6f69:
    push bc                                       ; $6F69
    push de                                       ; $6F6A
    push hl                                       ; $6F6B
    ld hl, wRunCameraPos                          ; $6F6C
    ld a, [de]                                    ; $6F6F
    sub [hl]                                      ; $6F70
    ld c, a                                       ; $6F71
    inc hl                                        ; $6F72
    inc de                                        ; $6F73
    ld a, [de]                                    ; $6F74
    sbc [hl]                                      ; $6F75
    sra a                                         ; $6F76
    rr c                                          ; $6F78
    call Run_OffscreenTest                        ; $6F7A
    jr c, jr_009_6f90                             ; $6F7D

    ld a, c                                       ; $6F7F
    cpl                                           ; $6F80
    add $79                                       ; $6F81
    ld b, a                                       ; $6F83
    ld c, $70                                     ; $6F84
    ld hl, Run_DrawHurdles_Tbl6FB3                ; $6F86
    pop de                                        ; $6F89
    push de                                       ; $6F8A
    ld a, $01                                     ; $6F8B
    call Run_DrawMeta                             ; $6F8D

jr_009_6f90:
    pop hl                                        ; $6F90
    pop de                                        ; $6F91
    pop bc                                        ; $6F92
    inc hl                                        ; $6F93
    inc hl                                        ; $6F94
    inc de                                        ; $6F95
    inc de                                        ; $6F96
    dec b                                         ; $6F97
    jr nz, jr_009_6f69                            ; $6F98

    ret                                           ; $6F9A


; C: $180 $380 $580 $680 $880 $940 $B40 $C40 $D00 $F00 $1000 $1200
Run_HurdleXTbl::
    db $80, $01, $80, $03, $80, $05, $80, $06, $80, $08, $40, $09, $40, $0b, $40, $0c
    db $00, $0d, $00, $0f, $00, $10, $00, $12

; C: hurdle animation list: 1B 04 FF 00 (still) / 1C 02 1D 02 1E 02 FF 04 (knocked over): animation list read by
; Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds
; the tick step it receives in A to the tick byte each call; the next entry is ...
Run_DrawHurdles_Tbl6FB3::
    db $1b, $04, $ff, $00, $1c, $02, $1d, $02, $1e, $02, $ff, $04

; C: draws the finish line at the world position $1400: x = $78 - (($1400 - camera) / 2) (low byte) when on screen, y
; = $70, animation Run_DrawFinishLine_Tbl6FE6 with the state $D045 (C)
Run_DrawFinishLine::
    ld hl, wRunCameraPos                          ; $6FBF
    ld a, $00                                     ; $6FC2
    sub [hl]                                      ; $6FC4
    ld c, a                                       ; $6FC5
    inc hl                                        ; $6FC6
    inc de                                        ; $6FC7
    ld a, $14                                     ; $6FC8
    sbc [hl]                                      ; $6FCA
    sra a                                         ; $6FCB
    rr c                                          ; $6FCD
    call Run_OffscreenTest                        ; $6FCF
    ret c                                         ; $6FD2

    ld a, c                                       ; $6FD3
    cpl                                           ; $6FD4
    add $79                                       ; $6FD5
    ld b, a                                       ; $6FD7
    ld c, $70                                     ; $6FD8
    ld hl, Run_DrawFinishLine_Tbl6FE6             ; $6FDA
    ld de, wRunFinishLineState                    ; $6FDD
    ld a, $01                                     ; $6FE0
    call Run_DrawMeta                             ; $6FE2
    ret                                           ; $6FE5


; C: finish line animation list: 2D 06 2E 06 2F 06 FF 00 (loop): animation list read by Run_DrawMeta /
; Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n jumps to entry n (Run_DrawMeta adds the tick step it
; receives in A to the tick byte each call; the next entry is taken when the tick ...
Run_DrawFinishLine_Tbl6FE6::
    db $2d, $06, $2e, $06, $2f, $06, $ff, $00

; C
Run_DrawFlag::
    ld b, $96                                     ; $6FEE
    ld a, [wRunFlagY]                             ; $6FF0
    ld c, a                                       ; $6FF3
    ld hl, Run_FlagSpriteTbl                      ; $6FF4
    ld de, wRunFlagState                          ; $6FF7
    ld a, $01                                     ; $6FFA
    call Run_DrawMeta                             ; $6FFC
    ret                                           ; $6FFF


; C: flag animation list: 35 08 36 08 37 08 FF 00 (loop; Run_DrawFlag draws it at x = $96, y = height $D048 with the
; state $D04B): animation list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, duration}, the pair $FF,n
; jumps to entry n (Run_DrawMeta adds the tick step it receives in A to ...
Run_FlagSpriteTbl::
    db $35, $08, $36, $08, $37, $08, $ff, $00

; C
Run_DrawCrown::
    ld b, $40                                     ; $7008
    ld a, [wRunCrownY]                            ; $700A
    ld c, a                                       ; $700D
    ld a, $57                                     ; $700E
    call Oam_AddMeta_B02_6E4B                     ; $7010
    ret                                           ; $7013


; C
Run_DrawConfetti::
    ld hl, wRunConfetti                           ; $7014
    ld b, $0a                                     ; $7017

jr_009_7019:
    ld a, [wRunConfettiFlicker]                   ; $7019
    xor b                                         ; $701C
    bit 0, a                                      ; $701D
    call nz, Run_DrawConfettiSprite               ; $701F
    ld de, $0006                                  ; $7022
    add hl, de                                    ; $7025
    dec b                                         ; $7026
    jr nz, jr_009_7019                            ; $7027

    ld hl, wRunConfettiFlicker                    ; $7029
    inc [hl]                                      ; $702C
    ret                                           ; $702D


; C: draws one confetti piece: x = record x / 2, y = record y / 2 - $10, animation Run_DrawConfettiSprite_AnimTbl7049
; with the frame and tick bytes of the record (Run_DrawMeta) (C)
Run_DrawConfettiSprite::
    push bc                                       ; $702E
    push hl                                       ; $702F
    ld a, [hl+]                                   ; $7030
    srl a                                         ; $7031
    ld b, a                                       ; $7033
    inc hl                                        ; $7034
    ld a, [hl+]                                   ; $7035
    srl a                                         ; $7036
    sub $10                                       ; $7038
    ld c, a                                       ; $703A
    inc hl                                        ; $703B
    ld d, h                                       ; $703C
    ld e, l                                       ; $703D
    ld hl, Run_DrawConfettiSprite_AnimTbl7049     ; $703E
    ld a, $01                                     ; $7041
    call Run_DrawMeta                             ; $7043
    pop hl                                        ; $7046
    pop bc                                        ; $7047
    ret                                           ; $7048


; C: animation list {meta id, duration} (the pair 'FF, n' jumps to entry n): 49 04 4A 04 4B 04 4C 04 4D 04 4C 04 4B 04
; 4A 04 FF 00 / 4E 04 4F 04 50 04 51 04 52 04 51 04 50 04 4F 04 FF 09; passed in HL to Run_DrawMeta by
; Run_DrawConfettiSprite (09:702E). It was named UserMap_AnimateDecoSprites_Gfx7049 ...
Run_DrawConfettiSprite_AnimTbl7049::
    db $49, $04, $4a, $04, $4b, $04, $4c, $04, $4d, $04, $4c, $04, $4b, $04, $4a, $04
    db $ff, $00, $4e, $04, $4f, $04, $50, $04, $51, $04, $52, $04, $51, $04, $50, $04
    db $4f, $04, $ff, $09

; C
Run_DrawPickCharacterSprite::
    ld bc, $5685                                  ; $706D
    ld hl, Run_DrawPickCharacterSprite_Tbl707C    ; $7070
    ld de, wRunPickPose                           ; $7073
    ld a, $01                                     ; $7076
    call Run_DrawMeta                             ; $7078
    ret                                           ; $707B


; C: animation lists of the character-pick sprite: 00 10 0C 02 0D 02 0E 02 0F 02 10 02 FF 05 / 00 10 0C 02 0D 02 0E 02
; 0F 02 11 02 FF 0C / 00 10 0C 02 0D 02 0E 02 0F 02 12 02 FF 13 / 0F 02 0E 02 0D 02 0C 02 00 10 00 08 FF 1A: animation
; list read by Run_DrawMeta / Run_SplitScreenLine: pairs {meta id, ...
Run_DrawPickCharacterSprite_Tbl707C::
    db $00, $10, $0c, $02, $0d, $02, $0e, $02, $0f, $02, $10, $02, $ff, $05, $00, $10
    db $0c, $02, $0d, $02, $0e, $02, $0f, $02, $11, $02, $ff, $0c, $00, $10, $0c, $02
    db $0d, $02, $0e, $02, $0f, $02, $12, $02, $ff, $13, $0f, $02, $0e, $02, $0d, $02
    db $0c, $02, $00, $10, $00, $08, $ff, $1a

; C: sprite list with flip: bc = origin; hl = list
Run_DrawMeta::
    push af                                       ; $70B4
    push bc                                       ; $70B5
    ld a, [de]                                    ; $70B6
    res 7, a                                      ; $70B7
    ld [de], a                                    ; $70B9
    sla a                                         ; $70BA
    ld c, a                                       ; $70BC
    ld b, $00                                     ; $70BD
    add hl, bc                                    ; $70BF
    ld a, [hl+]                                   ; $70C0
    pop bc                                        ; $70C1
    and a                                         ; $70C2
    ldh [hScratchA], a                            ; $70C3
    call nz, Oam_AddMeta_B02_6E4B                 ; $70C5
    inc de                                        ; $70C8
    ld a, [de]                                    ; $70C9
    cp [hl]                                       ; $70CA
    jr c, jr_009_70db                             ; $70CB

    dec de                                        ; $70CD
    inc hl                                        ; $70CE
    ld a, [hl+]                                   ; $70CF
    inc a                                         ; $70D0
    ld a, [hl]                                    ; $70D1
    jr z, jr_009_70d6                             ; $70D2

    ld a, [de]                                    ; $70D4
    inc a                                         ; $70D5

jr_009_70d6:
    set 7, a                                      ; $70D6
    ld [de], a                                    ; $70D8
    inc de                                        ; $70D9
    xor a                                         ; $70DA

jr_009_70db:
    pop bc                                        ; $70DB
    add b                                         ; $70DC
    ld [de], a                                    ; $70DD
    ldh a, [hScratchA]                            ; $70DE
    ret                                           ; $70E0


; C: sets the LCD split parameters from the player's vertical offset C: $FFB6 (second split line) := $5A - C, $FFAF
; (first split line) := 8 (C < $17), $1F - C ($17 <= C < $1C), 3 ($1C <= C < $80) or 8 (C >= $80), and $FFBA (scroll Y
; of the band) := list value + C with the animation state in DE (same ...
Run_SplitScreenLine::
    push af                                       ; $70E1
    ld a, $5a                                     ; $70E2
    sub c                                         ; $70E4
    ldh [hSplit2Line], a                          ; $70E5
    ld a, c                                       ; $70E7
    cp $17                                        ; $70E8
    jr nc, jr_009_70f0                            ; $70EA

    ld a, $08                                     ; $70EC
    jr jr_009_7103                                ; $70EE

jr_009_70f0:
    cp $1c                                        ; $70F0
    jr nc, jr_009_70f9                            ; $70F2

    cpl                                           ; $70F4
    add $20                                       ; $70F5
    jr jr_009_7103                                ; $70F7

jr_009_70f9:
    cp $80                                        ; $70F9
    jr nc, jr_009_7101                            ; $70FB

    ld a, $03                                     ; $70FD
    jr jr_009_7103                                ; $70FF

jr_009_7101:
    ld a, $08                                     ; $7101

jr_009_7103:
    ldh [hLycShadowSplit1], a                     ; $7103
    push bc                                       ; $7105
    ld a, [de]                                    ; $7106
    sla a                                         ; $7107
    ld c, a                                       ; $7109
    ld b, $00                                     ; $710A
    add hl, bc                                    ; $710C
    ld a, [hl+]                                   ; $710D
    pop bc                                        ; $710E
    add c                                         ; $710F
    ldh [hScyBand1], a                            ; $7110
    inc de                                        ; $7112
    ld a, [de]                                    ; $7113
    cp [hl]                                       ; $7114
    jr c, jr_009_7123                             ; $7115

    dec de                                        ; $7117
    inc hl                                        ; $7118
    ld a, [hl+]                                   ; $7119
    inc a                                         ; $711A
    ld a, [hl]                                    ; $711B
    jr z, jr_009_7120                             ; $711C

    ld a, [de]                                    ; $711E
    inc a                                         ; $711F

jr_009_7120:
    ld [de], a                                    ; $7120
    inc de                                        ; $7121
    xor a                                         ; $7122

jr_009_7123:
    pop bc                                        ; $7123
    add b                                         ; $7124
    ld [de], a                                    ; $7125
    ret                                           ; $7126


; C: visibility test of a half-scale position (A = high byte, C = low byte): returns NC when the position is on screen
; (A = 0 and C < $B0, or A = $FF and C >= $B0), carry set when it is off screen; the callers draw only when NC
; (Run_DrawChick, Run_DrawMoleAndScene, Run_DrawRunner3, Run_DrawFinishLine, ...
Run_OffscreenTest::
    and a                                         ; $7127
    jr z, jr_009_7135                             ; $7128

    cp $ff                                        ; $712A
    jr nz, jr_009_713c                            ; $712C

    ld a, c                                       ; $712E
    cp $b0                                        ; $712F
    jr c, jr_009_713c                             ; $7131

    and a                                         ; $7133
    ret                                           ; $7134


jr_009_7135:
    ld a, c                                       ; $7135
    cp $b0                                        ; $7136
    jr nc, jr_009_713c                            ; $7138

    and a                                         ; $713A
    ret                                           ; $713B


jr_009_713c:
    scf                                           ; $713C
    ret                                           ; $713D


; C: BCD +$000167 per frame until the player is placed
Run_RaceTimerTick::
    ld a, [wRunState + $29]                       ; $713E
    cp $99                                        ; $7141
    jr nz, jr_009_714b                            ; $7143

    ld a, [wRunState + $28]                       ; $7145
    cp $99                                        ; $7148
    ret z                                         ; $714A

jr_009_714b:
    ld hl, wRunState + $27                        ; $714B
    ld a, $67                                     ; $714E
    add [hl]                                      ; $7150
    daa                                           ; $7151
    ld [hl+], a                                   ; $7152
    ld a, $01                                     ; $7153
    adc [hl]                                      ; $7155
    daa                                           ; $7156
    ld [hl+], a                                   ; $7157
    ld a, $00                                     ; $7158
    adc [hl]                                      ; $715A
    daa                                           ; $715B
    ld [hl+], a                                   ; $715C
    jr nc, jr_009_7167                            ; $715D

    ld a, $99                                     ; $715F
    ld [wRunState + $28], a                       ; $7161
    ld [wRunState + $29], a                       ; $7164

jr_009_7167:
    ld de, $8b40                                  ; $7167
    ld a, [wRunState + $29]                       ; $716A
    call Run_DrawTimerDigit                       ; $716D
    ld a, [wRunState + $28]                       ; $7170

; C: draws a BCD byte as two digits: for the high nibble then the low nibble it calls Run_DrawTimerDigitB (C)
Run_DrawTimerDigit::
    push af                                       ; $7173
    swap a                                        ; $7174
    and $0f                                       ; $7176
    call Run_DrawTimerDigitB                      ; $7178
    pop af                                        ; $717B
    and $0f                                       ; $717C

; C: copies the 32 bytes of the digit (nibble x 32) from 1B:6E80 to VRAM at DE (Vram_CopyFromBank) (C)
Run_DrawTimerDigitB::
    swap a                                        ; $717E
    ld c, a                                       ; $7180
    ld b, $00                                     ; $7181
    sla c                                         ; $7183
    rl b                                          ; $7185
    ld hl, $6e80                                  ; $7187
    add hl, bc                                    ; $718A
    ld a, $1b                                     ; $718B
    ld bc, $0020                                  ; $718D
    call Vram_CopyFromBank                        ; $7190
    ret                                           ; $7193


; C: toggle D9F9
Run_LoadCharacterGraphicsA::
    ld a, [wPickGfxToggle21]                      ; $7194
    inc a                                         ; $7197
    and $01                                       ; $7198
    ld [wPickGfxToggle21], a                      ; $719A
    call Run_CharacterToGfxIndex                  ; $719D
    push af                                       ; $71A0
    ld c, $00                                     ; $71A1
    ldh [hFarcallAArg], a                         ; $71A3
    farcall Photo_FarGetAddress                   ; $71A5
    ld de, $9000                                  ; $71AD
    ld bc, $0380                                  ; $71B0
    call Mem_CopyFromBank                         ; $71B3
    pop af                                        ; $71B6
    push af                                       ; $71B7
    ld c, $01                                     ; $71B8
    ldh [hFarcallAArg], a                         ; $71BA
    farcall Photo_FarGetAddress                   ; $71BC
    ld de, $9380                                  ; $71C4
    ld bc, $0380                                  ; $71C7
    call Mem_CopyFromBank                         ; $71CA
    pop af                                        ; $71CD
    ld c, $02                                     ; $71CE
    ldh [hFarcallAArg], a                         ; $71D0
    farcall Photo_FarGetAddress                   ; $71D2
    push af                                       ; $71DA
    ld de, $9700                                  ; $71DB
    ld bc, $0100                                  ; $71DE
    call Mem_CopyFromBank                         ; $71E1
    pop af                                        ; $71E4
    ld de, $8800                                  ; $71E5
    ld bc, $0280                                  ; $71E8
    call Mem_CopyFromBank                         ; $71EB
    ret                                           ; $71EE


; C: far 05:7F69
Run_LoadCharacterGraphicsB::
    call Run_CharacterToGfxIndex                  ; $71EF
    ldh [hFarcallAArg], a                         ; $71F2
    farcall Photo_FarGetAddress                   ; $71F4
    ld de, $9000                                  ; $71FC
    ld bc, $0380                                  ; $71FF
    call Vram_CopyFromBank_4                      ; $7202
    ret                                           ; $7205


; C: far 05:7F69
Run_LoadCharacterGraphicsC::
    call Run_CharacterToGfxIndex                  ; $7206
    ldh [hFarcallAArg], a                         ; $7209
    farcall Photo_FarGetAddress                   ; $720B
    ld de, $9380                                  ; $7213
    ld bc, $0380                                  ; $7216
    call Vram_CopyFromBank_4                      ; $7219
    ret                                           ; $721C


; C: UNREFERENCED: twin of 09:7206
Unused_Run_LoadCharacterGraphicsD::
    call Run_CharacterToGfxIndex                  ; $721D
    ldh [hFarcallAArg], a                         ; $7220
    farcall Photo_FarGetAddress                   ; $7222
    push af                                       ; $722A
    ld de, $9700                                  ; $722B
    ld bc, $0100                                  ; $722E
    call Vram_CopyFromBank_4                      ; $7231
    pop af                                        ; $7234
    ld de, $8800                                  ; $7235
    ld bc, $0280                                  ; $7238
    call Vram_CopyFromBank_4                      ; $723B
    ret                                           ; $723E


; C: graphics index of the selected character: A = $D9F8 (0-2); when it is 2 and bit 0 of $D581 (Game Face) is clear,
; $D9F9 is used instead; the index is Run_CharacterToGfxIndex_Tbl725B[A] (C)
Run_CharacterToGfxIndex::
    push bc                                       ; $723F
    ld a, [wPickCharacter21]                      ; $7240
    cp $02                                        ; $7243
    jr nz, jr_009_7251                            ; $7245

    ld hl, wGamefacePresent                       ; $7247
    bit 0, [hl]                                   ; $724A
    jr nz, jr_009_7251                            ; $724C

    ld a, [wPickGfxToggle21]                      ; $724E

jr_009_7251:
    ld c, a                                       ; $7251
    ld b, $00                                     ; $7252
    ld hl, Run_CharacterToGfxIndex_Tbl725B        ; $7254
    add hl, bc                                    ; $7257
    ld a, [hl]                                    ; $7258
    pop bc                                        ; $7259
    ret                                           ; $725A


; C: 3 graphics indices 00 05 06 for the characters 0, 1, 2 (C)
Run_CharacterToGfxIndex_Tbl725B::
    db $00, $05, $06

; C: time vs record DAA6/7 (nine complement)
Run_CompareRecord::
    ld de, wRunState + $29                        ; $725E
    ld hl, wBestRun + $1                          ; $7261
    ld b, $02                                     ; $7264

jr_009_7266:
    ld a, [de]                                    ; $7266
    cpl                                           ; $7267
    add $9a                                       ; $7268
    cp [hl]                                       ; $726A
    ret c                                         ; $726B

    jr nz, jr_009_7274                            ; $726C

    dec de                                        ; $726E
    dec hl                                        ; $726F
    dec b                                         ; $7270
    jr nz, jr_009_7266                            ; $7271

    ret                                           ; $7273


jr_009_7274:
    ld de, wRunState + $28                        ; $7274
    ld hl, wBestRun                               ; $7277
    ld b, $02                                     ; $727A

jr_009_727c:
    ld a, [de]                                    ; $727C
    cpl                                           ; $727D
    add $9a                                       ; $727E
    ld [hl+], a                                   ; $7280
    inc de                                        ; $7281
    dec b                                         ; $7282
    jr nz, jr_009_727c                            ; $7283

    ldh [hFarcallAArg], a                         ; $7285
    farcall Counters_Store_Far                    ; $7287
    ret                                           ; $728F


; C: shared result / error screen (3 substates); Totaka tune 1 in 3
ResultScreen_Far::
    ld a, [wSubstate]                             ; $7290
    rst Rst18_JumpTable                           ; $7293

; C
ResultScreen_SubstateTbl::
    dw ResultScreen_Substate0_Init
    dw ResultScreen_Substate1_WaitKey
    dw ResultScreen_Substate2_Exit

; C
ResultScreen_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $729A
    ldh [hLcdcShadow], a                          ; $729C
    ld a, $e4                                     ; $729E
    ld [wPaletteTarget], a                        ; $72A0
    ld [wPaletteTarget + $1], a                   ; $72A3
    ld a, $d2                                     ; $72A6
    ld [wPaletteTarget + $2], a                   ; $72A8
    xor a                                         ; $72AB
    ldh [hScxShadow], a                           ; $72AC
    ldh [hScyShadow], a                           ; $72AE
    call ResultScreen_ChoosePicture               ; $72B0
    push af                                       ; $72B3
    ld c, a                                       ; $72B4
    sla a                                         ; $72B5
    add c                                         ; $72B7
    ld c, a                                       ; $72B8
    ld b, $00                                     ; $72B9
    ld hl, ResultScreen_PictureTbl                ; $72BB
    add hl, bc                                    ; $72BE
    ld c, [hl]                                    ; $72BF
    inc hl                                        ; $72C0
    ld b, [hl]                                    ; $72C1
    inc hl                                        ; $72C2
    ld a, [hl]                                    ; $72C3
    ld h, b                                       ; $72C4
    ld l, c                                       ; $72C5
    ld de, $9000                                  ; $72C6
    ld bc, $0800                                  ; $72C9
    push af                                       ; $72CC
    call Mem_CopyFromBank                         ; $72CD
    pop af                                        ; $72D0
    ld de, $8800                                  ; $72D1
    ld bc, $0100                                  ; $72D4
    push af                                       ; $72D7
    call Mem_CopyFromBank                         ; $72D8
    pop af                                        ; $72DB
    ld de, $8000                                  ; $72DC
    ld bc, $0500                                  ; $72DF
    call Mem_CopyFromBank                         ; $72E2
    farcopy Mem_CopyFromBank, Gfx_0D_5D00_MsgStrip, $8ff0, $0010 ; $72E5
    farcopy Mem_CopyFromBank, Map_26_4EC0_ResultScreen_Substate0_Init, $9800, $0240 ; $72F3
    call ResultScreen_LoadMessage                 ; $7301
    ld a, $54                                     ; $7304
    ldh [hLycShadowSplit1], a                     ; $7306
    ldh [hSplit1Latch], a                         ; $7308
    ld hl, hStatShadow                            ; $730A
    set 6, [hl]                                   ; $730D
    ld hl, rIE                                    ; $730F
    set 1, [hl]                                   ; $7312
    ld a, $01                                     ; $7314
    ldh [hStatHandlerIndex], a                    ; $7316
    call Oam_ClearShadow                          ; $7318
    call Pal_AllWhite                             ; $731B
    call Lcd_On                                   ; $731E
    pop af                                        ; $7321
    ld hl, ResultScreen_Substate0_Init_Tbl733E    ; $7322
    call Snd_PlayFromList                         ; $7325
    call Pal_FadeIn                               ; $7328
    ld hl, wSubstate                              ; $732B
    inc [hl]                                      ; $732E
    jp Far_Call_Return                            ; $732F


; C: 3-byte {ptr; bank}; tiles to $9000 / $8800 / $8000
ResultScreen_PictureTbl::
    dwb Gfx_1E_4E00_ResultPic0_HornedMan_Tune28
    dwb Gfx_1E_6A00_ResultPic1_BaldMan_Tune29Totaka
    dwb Gfx_1E_4000_ResultPic2_RibbonWoman_Tune30
    dwb Gfx_1D_4F00_ResultPic3_Equator_Tune2A

; C: auto: 8 bytes, bytes; referenced by ResultScreen_Substate0_Init. L3 pass 2026-10-26: read in BGB in 31 replay(s)
; of the organic corpus, modes 01 14 17 1D (tcrf_check/assets/l3_names/)
ResultScreen_Substate0_Init_Tbl733E::
    db MUSIC_WHO_ARE_YOU_RUNNING_FROM_1, SNDCH_MUSIC  ; #1
    db MUSIC_TOTAKA_TUNE, SNDCH_MUSIC  ; #2
    db MUSIC_WHO_ARE_YOU_RUNNING_FROM_2, SNDCH_MUSIC  ; #3
    db MUSIC_JAMBO_NINTENDO, SNDCH_MUSIC  ; #4

; C: id $0E forces picture 3; else random of 3
ResultScreen_ChoosePicture::
    ld a, [wResultMsgId]                          ; $7346
    cp $0e                                        ; $7349
    jr nz, jr_009_7350                            ; $734B

    ld a, $03                                     ; $734D
    ret                                           ; $734F


jr_009_7350:
    call Rng_Next                                 ; $7350
    ld l, $03                                     ; $7353
    call Math_MulAL                               ; $7355
    ld a, h                                       ; $7358
    ret                                           ; $7359


; C
ResultScreen_Substate1_WaitKey::
    ldh a, [hKeysNew]                             ; $735A
    and PADF_A | PADF_B                           ; $735C
    jp z, Far_Call_Return                         ; $735E

    ld hl, wSubstate                              ; $7361
    inc [hl]                                      ; $7364
    jp Far_Call_Return                            ; $7365


; C
ResultScreen_Substate2_Exit::
    call Pal_FadeOut                              ; $7368
    call Lcd_Off                                  ; $736B
    ld hl, hStatShadow                            ; $736E
    res 6, [hl]                                   ; $7371
    ld hl, rIE                                    ; $7373
    res 1, [hl]                                   ; $7376
    next_state                                    ; $7378
    jp Far_Call_Return                            ; $737C


; C: message table 09:739E; 3 bytes per entry
ResultScreen_LoadMessage::
    ld a, [wResultMsgId]                          ; $737F
    ld c, a                                       ; $7382
    sla a                                         ; $7383
    add c                                         ; $7385
    ld c, a                                       ; $7386
    ld b, $00                                     ; $7387
    ld hl, ResultScreen_MessageTbl                ; $7389
    add hl, bc                                    ; $738C
    ld c, [hl]                                    ; $738D
    inc hl                                        ; $738E
    ld b, [hl]                                    ; $738F
    inc hl                                        ; $7390
    ld a, [hl]                                    ; $7391
    ld h, b                                       ; $7392
    ld l, c                                       ; $7393
    ld de, $8900                                  ; $7394
    ld bc, $0280                                  ; $7397
    call Mem_CopyFromBank                         ; $739A
    ret                                           ; $739D


; C
ResultScreen_MessageTbl::
    db $00, $40, $28, $80, $42, $28, $00, $45, $28, $80, $47, $28, $00, $4a, $28, $80
    db $4c, $28, $00, $4f, $28, $80, $51, $28, $00, $54, $28, $80, $56, $28, $00, $59
    db $28, $80, $5b, $28, $00, $5e, $28, $00, $5d, $0d, $80, $60, $28

    ; padding
    ds $c35, $00

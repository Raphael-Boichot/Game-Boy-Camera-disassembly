; Pocket Camera (Japan) (Rev A), bank $07. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

; C: mode 0E: link-cable exchange (SEND / RECEIVE)
Mode0E_LinkTransfer::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; C: 21 states
Mode0E_StateTable::
    dw Mode0E_State00_Init
    dw Mode0E_State01_Handshake
    dw Mode0E_State02_MessageStrip
    dw Mode0E_State03_PickPhoto
    dw Mode0E_State04_PickDone
    dw Mode0E_State05_InitiatorConfirmSend
    dw Mode0E_State06_ExchangeSetup
    dw Mode0E_State07_ExchangeBarsA
    dw Mode0E_State08_ExchangeWaitA
    dw Mode0E_State09_ExchangeDoneA
    dw Mode0E_State0A_ExchangeSetupB
    dw Mode0E_State0B_ExchangeBarsB
    dw Mode0E_State0C_ExchangeWaitB
    dw Mode0E_State0D_PickSecond
    dw Mode0E_State0E_ResponderConfirmSend
    dw Mode0E_State0F_Ready
    dw Mode0E_State10_ExchangeWaitC
    dw Mode0E_State11_ExchangeDoneB
    dw Mode0E_State12_ResultPrepare
    dw Mode0E_State13_ResultScreen
    dw Mode0E_State14_Abort

; C
Mode0E_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $402E
    ldh [hLcdcShadow], a                          ; $4030
    ld a, $e4                                     ; $4032
    ld [wPaletteTarget], a                        ; $4034
    ld [wPaletteTarget + $1], a                   ; $4037
    ld a, $d2                                     ; $403A
    ld [wPaletteTarget + $2], a                   ; $403C
    xor a                                         ; $403F
    ldh [hScxShadow], a                           ; $4040
    ldh [hScyShadow], a                           ; $4042
    ld [wLinkAnimTickA], a                        ; $4044
    ld [wLinkAnimTickA + $1], a                   ; $4047
    ld [wLinkAnimTickB], a                        ; $404A
    ld [wLinkAnimTickB + $1], a                   ; $404D
    ld [wLinkAnimIdxA], a                         ; $4050
    ld a, $03                                     ; $4053
    ld [wLinkAnimIdxA + $1], a                    ; $4055
    ld a, $0a                                     ; $4058
    ld [wLinkAnim2Frame], a                       ; $405A
    ld a, $0c                                     ; $405D
    ld [wLinkAnim3Frame], a                       ; $405F
    ld a, $19                                     ; $4062
    ld hl, Gfx_19_4000_Mode0E_State00_Init        ; $4064
    ld de, $9000                                  ; $4067
    ld bc, $0800                                  ; $406A
    call Mem_CopyFromBank                         ; $406D
    ld a, BANK(Gfx_19_4800_Mode0E_State00_Init)   ; $4070
    ld hl, Gfx_19_4800_Mode0E_State00_Init        ; $4072
    ld de, $8800                                  ; $4075
    ld bc, $0800                                  ; $4078
    call Mem_CopyFromBank                         ; $407B
    ld a, BANK(Gfx_19_5000_Mode0E_State00_Init)   ; $407E
    ld hl, Gfx_19_5000_Mode0E_State00_Init        ; $4080
    ld de, $8000                                  ; $4083
    ld bc, $0800                                  ; $4086
    call Mem_CopyFromBank                         ; $4089
    ld a, BANK(Map_23_7780_Mode0E_State00_Init)   ; $408C
    ld hl, Map_23_7780_Mode0E_State00_Init        ; $408E
    ld de, $9800                                  ; $4091
    ld bc, $0240                                  ; $4094
    call Mem_CopyFromBank                         ; $4097
    call Oam_ClearShadow                          ; $409A
    call Pal_AllWhite                             ; $409D
    ld a, $01                                     ; $40A0
    ldh [hSerialHandlerIndex], a                  ; $40A2
    xor a                                         ; $40A4
    ld [wLinkSetupDone], a                        ; $40A5
    call Lcd_On                                   ; $40A8
    ld a, [wSavedDc52]                            ; $40AB
    and a                                         ; $40AE
    jr nz, jr_007_40cb                            ; $40AF

    ld a, $0a                                     ; $40B1
    ld [wLinkAnim2Frame], a                       ; $40B3
    ld a, $10                                     ; $40B6
    ld [wLinkAnim3Frame], a                       ; $40B8
    ld a, BANK(Map_23_77A0_Mode0E_State00_Init)   ; $40BB
    ld hl, Map_23_77A0_Mode0E_State00_Init        ; $40BD
    ld de, $9820                                  ; $40C0
    ld bc, $00a0                                  ; $40C3
    call Vram_CopyFromBank                        ; $40C6
    jr jr_007_40e3                                ; $40C9

jr_007_40cb:
    ld a, $0e                                     ; $40CB
    ld [wLinkAnim2Frame], a                       ; $40CD
    ld a, $0c                                     ; $40D0
    ld [wLinkAnim3Frame], a                       ; $40D2
    ld a, BANK(Map_23_79C0_Mode0E_State00_Init)   ; $40D5
    ld hl, Map_23_79C0_Mode0E_State00_Init        ; $40D7
    ld de, $9820                                  ; $40DA
    ld bc, $00a0                                  ; $40DD
    call Vram_CopyFromBank                        ; $40E0

jr_007_40e3:
    call Link_DrawAnimators                       ; $40E3
    call Pal_FadeIn                               ; $40E6
    ld hl, wState                                 ; $40E9
    inc [hl]                                      ; $40EC
    ret                                           ; $40ED


; C: shared abort / leave tail of mode $0E: waits one frame, Link_Stop until done, clears $DC44, mode $06 state 0
; (link menu); jumped to by states 03, 0C-0D and 14 (branch target; code read 2026-10-19)
Mode0E_LeaveToLinkMenu::
    ld bc, $0001                                  ; $40EE
    call Delay_Frames_Busy                        ; $40F1
    call Link_Stop                                ; $40F4
    jr nz, Mode0E_LeaveToLinkMenu                 ; $40F7

    xor a                                         ; $40F9
    ld [wLnkConnected], a                         ; $40FA
    ld a, MODE_LINK_MENU                          ; $40FD
    ld [wMode], a                                 ; $40FF
    ld a, STATE_06_INIT                           ; $4102
    ld [wState], a                                ; $4104
    ret                                           ; $4107


; C: Left / Right choice; hello; role negotiation
Mode0E_State01_Handshake::
    call Link_ChooseSendReceive                   ; $4108
    call Link_DrawAnimators                       ; $410B
    ld a, [wLinkSetupDone]                        ; $410E
    and a                                         ; $4111
    jr nz, jr_007_4130                            ; $4112

    inc a                                         ; $4114
    ld [wLinkSetupDone], a                        ; $4115
    di                                            ; $4118
    call Link_Init                                ; $4119
    ld a, [wPhotoCount]                           ; $411C
    cp $1e                                        ; $411F
    ccf                                           ; $4121
    rl a                                          ; $4122
    and $01                                       ; $4124
    ld [wLnkAlbumFull], a                         ; $4126
    ld a, [wPhotoCount]                           ; $4129
    ld [wLnkOwnCount], a                          ; $412C
    ei                                            ; $412F

jr_007_4130:
    call Link_UpdateInfoByte                      ; $4130
    jr nz, jr_007_418a                            ; $4133

    call Link_DrawPressAText                      ; $4135
    ldh a, [hKeysNew]                             ; $4138
    cp PADF_A                                     ; $413A
    jr nz, jr_007_4151                            ; $413C

    ld a, [wSavedDc52]                            ; $413E
    and a                                         ; $4141
    jr z, jr_007_4146                             ; $4142

    ld a, $80                                     ; $4144

jr_007_4146:
    ld hl, wLnkOwnCount                           ; $4146
    res 7, [hl]                                   ; $4149
    or [hl]                                       ; $414B
    ld [hl], a                                    ; $414C
    call Link_SendHello29                         ; $414D
    ret                                           ; $4150


jr_007_4151:
    cp $02                                        ; $4151
    jr nz, jr_007_416f                            ; $4153

    call Link_Stop                                ; $4155
    jr nz, jr_007_416f                            ; $4158

    call Pal_FadeOut                              ; $415A
    call Lcd_Off                                  ; $415D
    xor a                                         ; $4160
    ld [wLnkConnected], a                         ; $4161
    ld a, MODE_LINK_MENU                          ; $4164
    ld [wMode], a                                 ; $4166
    ld a, STATE_06_INIT                           ; $4169
    ld [wState], a                                ; $416B
    ret                                           ; $416E


jr_007_416f:
    ld a, [wLnkAbortReason]                       ; $416F
    and a                                         ; $4172
    ret z                                         ; $4173

    dec a                                         ; $4174
    ld c, a                                       ; $4175
    ld b, $00                                     ; $4176
    ld hl, Mode0E_AbortReasonMsgTbl               ; $4178
    add hl, bc                                    ; $417B
    ld a, [hl]                                    ; $417C
    ld [wResultMsgId], a                          ; $417D
    ld a, STATE_0E_RESULT_PREPARE                 ; $4180
    ld [wState], a                                ; $4182
    ret                                           ; $4185


; C: 4 bytes: wLnkAbortReason 1-4 -> message id wResultMsgId of the result / error screen = $09, $09, $0A, $0B (album
; full; peer album full; peer has no photo; own album empty), then state $12; Mode0E_State01_Handshake (07:4178),
; README 14 (read 2026-10-25)
Mode0E_AbortReasonMsgTbl::
    db $09, $09, $0a, $0b

jr_007_418a:
    ld a, [wLnkRoleRx]                            ; $418A
    ld [wSavedDc52], a                            ; $418D
    push af                                       ; $4190
    ld a, SFX1_CHOOSE                             ; $4191
    call Snd_Sfx1                                 ; $4193
    pop af                                        ; $4196
    call Link_AnimateLamps                        ; $4197
    call Oam_HideUnused                           ; $419A
    rst Rst08_WaitVBlank                          ; $419D
    ld b, $28                                     ; $419E

jr_007_41a0:
    push bc                                       ; $41A0
    call Link_DrawAnimators                       ; $41A1
    call Link_AnimateStep3                        ; $41A4
    call Oam_HideUnused                           ; $41A7
    rst Rst08_WaitVBlank                          ; $41AA
    pop bc                                        ; $41AB
    dec b                                         ; $41AC
    jr nz, jr_007_41a0                            ; $41AD

    call Pal_FadeOut                              ; $41AF
    call Lcd_Off                                  ; $41B2
    ld a, [wLnkInitiator]                         ; $41B5
    cp $01                                        ; $41B8
    jr nz, jr_007_41c2                            ; $41BA

    ld a, STATE_0E_MESSAGE_STRIP                  ; $41BC
    ld [wState], a                                ; $41BE
    ret                                           ; $41C1


jr_007_41c2:
    ld a, STATE_0E_EXCHANGE_SETUP_B               ; $41C2
    ld [wState], a                                ; $41C4
    ret                                           ; $41C7


; I: UNREFERENCED: state := $12
Unused_Mode0E_GotoState12::
    ld a, STATE_0E_RESULT_PREPARE                 ; $41C8
    ld [wState], a                                ; $41CA
    ret                                           ; $41CD


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:01
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_AnimateLamps::
    ld a, [wSavedDc52]                            ; $41CE
    and a                                         ; $41D1
    jr nz, jr_007_41e6                            ; $41D2

    ld a, $08                                     ; $41D4
    ld [wLinkAnimIdxA + $1], a                    ; $41D6
    ld a, $15                                     ; $41D9
    ld [wLinkAnim3Frame], a                       ; $41DB
    xor a                                         ; $41DE
    ld [wLinkAnimTickA + $1], a                   ; $41DF
    ld [wLinkAnimTickB + $1], a                   ; $41E2
    ret                                           ; $41E5


jr_007_41e6:
    ld a, $06                                     ; $41E6
    ld [wLinkAnimIdxA], a                         ; $41E8
    ld a, $12                                     ; $41EB
    ld [wLinkAnim2Frame], a                       ; $41ED
    xor a                                         ; $41F0
    ld [wLinkAnimTickA], a                        ; $41F1
    ld [wLinkAnimTickB], a                        ; $41F4
    ret                                           ; $41F7


; C: blinking text. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 0E
; (tcrf_check/assets/l3_names/)
Link_DrawPressAText::
    ldh a, [hFrameCounter]                        ; $41F8
    bit 4, a                                      ; $41FA
    jr nz, jr_007_420d                            ; $41FC

    ld a, BANK(Map_23_7A60_Link_DrawPressAText)   ; $41FE
    ld hl, Map_23_7A60_Link_DrawPressAText        ; $4200
    ld de, $9820                                  ; $4203
    ld bc, $00a0                                  ; $4206
    call Vram_CopyFromBank                        ; $4209
    ret                                           ; $420C


jr_007_420d:
    ld a, [wSavedDc52]                            ; $420D
    and a                                         ; $4210
    jr nz, jr_007_4222                            ; $4211

    ld a, BANK(Map_23_77A0_Mode0E_State00_Init)   ; $4213
    ld hl, Map_23_77A0_Mode0E_State00_Init        ; $4215
    ld de, $9820                                  ; $4218
    ld bc, $00a0                                  ; $421B
    call Vram_CopyFromBank                        ; $421E
    ret                                           ; $4221


jr_007_4222:
    ld a, BANK(Map_23_79C0_Mode0E_State00_Init)   ; $4222
    ld hl, Map_23_79C0_Mode0E_State00_Init        ; $4224
    ld de, $9820                                  ; $4227
    ld bc, $00a0                                  ; $422A
    call Vram_CopyFromBank                        ; $422D
    ret                                           ; $4230


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:01
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_AnimateStep3::
    ld a, [wSavedDc52]                            ; $4231
    and a                                         ; $4234
    jr nz, jr_007_424d                            ; $4235

    ld a, [wLinkAnim3Frame]                       ; $4237
    cp $15                                        ; $423A
    jr z, jr_007_4263                             ; $423C

    ld a, BANK(Map_23_77A0_Mode0E_State00_Init)   ; $423E
    ld hl, Map_23_77A0_Mode0E_State00_Init        ; $4240
    ld de, $9820                                  ; $4243
    ld bc, $00a0                                  ; $4246
    call Vram_CopyFromBank                        ; $4249
    ret                                           ; $424C


jr_007_424d:
    ld a, [wLinkAnim2Frame]                       ; $424D
    cp $12                                        ; $4250
    jr z, jr_007_4263                             ; $4252

    ld a, BANK(Map_23_79C0_Mode0E_State00_Init)   ; $4254
    ld hl, Map_23_79C0_Mode0E_State00_Init        ; $4256
    ld de, $9820                                  ; $4259
    ld bc, $00a0                                  ; $425C
    call Vram_CopyFromBank                        ; $425F
    ret                                           ; $4262


jr_007_4263:
    ld a, BANK(Map_23_7A60_Link_DrawPressAText)   ; $4263
    ld hl, Map_23_7A60_Link_DrawPressAText        ; $4265
    ld de, $9820                                  ; $4268
    ld bc, $00a0                                  ; $426B
    call Vram_CopyFromBank                        ; $426E
    ret                                           ; $4271


; C: Left -> D5F5 = 0; Right -> D5F5 = 1
Link_ChooseSendReceive::
    ldh a, [hKeysNew]                             ; $4272
    bit PADB_LEFT, a                              ; $4274
    jr z, jr_007_427b                             ; $4276

    xor a                                         ; $4278
    jr jr_007_4280                                ; $4279

jr_007_427b:
    bit 4, a                                      ; $427B
    ret z                                         ; $427D

    ld a, $01                                     ; $427E

jr_007_4280:
    ld hl, wSavedDc52                             ; $4280
    cp [hl]                                       ; $4283
    ret z                                         ; $4284

    ld [hl], a                                    ; $4285
    push af                                       ; $4286
    ld a, SFX4_LINK_CHOOSE                        ; $4287
    call Snd_Sfx4                                 ; $4289
    pop af                                        ; $428C
    and a                                         ; $428D
    jr nz, jr_007_42b0                            ; $428E

    ld a, $0a                                     ; $4290
    ld [wLinkAnim2Frame], a                       ; $4292
    ld a, $10                                     ; $4295
    ld [wLinkAnim3Frame], a                       ; $4297
    xor a                                         ; $429A
    ld [wLinkAnimTickB], a                        ; $429B
    ld [wLinkAnimTickB + $1], a                   ; $429E
    ld a, BANK(Map_23_77A0_Mode0E_State00_Init)   ; $42A1
    ld hl, Map_23_77A0_Mode0E_State00_Init        ; $42A3
    ld de, $9820                                  ; $42A6
    ld bc, $00a0                                  ; $42A9
    call Vram_CopyFromBank                        ; $42AC
    ret                                           ; $42AF


jr_007_42b0:
    ld a, $0e                                     ; $42B0
    ld [wLinkAnim2Frame], a                       ; $42B2
    ld a, $0c                                     ; $42B5
    ld [wLinkAnim3Frame], a                       ; $42B7
    xor a                                         ; $42BA
    ld [wLinkAnimTickB], a                        ; $42BB
    ld [wLinkAnimTickB + $1], a                   ; $42BE
    ld a, BANK(Map_23_79C0_Mode0E_State00_Init)   ; $42C1
    ld hl, Map_23_79C0_Mode0E_State00_Init        ; $42C3
    ld de, $9820                                  ; $42C6
    ld bc, $00a0                                  ; $42C9
    call Vram_CopyFromBank                        ; $42CC
    ret                                           ; $42CF


; C: four animator slots
Link_DrawAnimators::
    ld a, [wLinkAnimIdxA]                         ; $42D0
    ld e, a                                       ; $42D3
    ld a, [wLinkAnimTickA]                        ; $42D4
    ld d, a                                       ; $42D7
    ld bc, $3353                                  ; $42D8
    call Link_DrawAnimatorSlot                    ; $42DB
    ld a, e                                       ; $42DE
    ld [wLinkAnimIdxA], a                         ; $42DF
    ld a, d                                       ; $42E2
    ld [wLinkAnimTickA], a                        ; $42E3
    ld a, [wLinkAnimIdxA + $1]                    ; $42E6
    ld e, a                                       ; $42E9
    ld a, [wLinkAnimTickA + $1]                   ; $42EA
    ld d, a                                       ; $42ED
    ld bc, $6d52                                  ; $42EE
    call Link_DrawAnimatorSlot                    ; $42F1
    ld a, e                                       ; $42F4
    ld [wLinkAnimIdxA + $1], a                    ; $42F5
    ld a, d                                       ; $42F8
    ld [wLinkAnimTickA + $1], a                   ; $42F9
    ld a, [wLinkAnim2Frame]                       ; $42FC
    ld e, a                                       ; $42FF
    ld a, [wLinkAnimTickB]                        ; $4300
    ld d, a                                       ; $4303
    ld bc, $3353                                  ; $4304
    call Link_DrawAnimatorSlot                    ; $4307
    ld a, e                                       ; $430A
    ld [wLinkAnim2Frame], a                       ; $430B
    ld a, d                                       ; $430E
    ld [wLinkAnimTickB], a                        ; $430F
    ld a, [wLinkAnim3Frame]                       ; $4312
    ld e, a                                       ; $4315
    ld a, [wLinkAnimTickB + $1]                   ; $4316
    ld d, a                                       ; $4319
    ld bc, $6d52                                  ; $431A
    call Link_DrawAnimatorSlot                    ; $431D
    ld a, e                                       ; $4320
    ld [wLinkAnim3Frame], a                       ; $4321
    ld a, d                                       ; $4324
    ld [wLinkAnimTickB + $1], a                   ; $4325
    ret                                           ; $4328


; C
Link_DrawAnimatorSlot::
    push de                                       ; $4329
    ld a, e                                       ; $432A
    sla a                                         ; $432B
    add e                                         ; $432D
    ld e, a                                       ; $432E
    ld d, $00                                     ; $432F
    ld hl, Link_DrawAnimatorSlot_Tbl4354          ; $4331
    add hl, de                                    ; $4334
    ld a, [hl+]                                   ; $4335
    and a                                         ; $4336
    call nz, Oam_AddMeta_B01_5D47                 ; $4337
    ld a, [hl+]                                   ; $433A
    and a                                         ; $433B
    call nz, Oam_AddMeta_B01_5D47                 ; $433C
    pop de                                        ; $433F
    ld a, d                                       ; $4340
    cp [hl]                                       ; $4341
    jr c, jr_007_4352                             ; $4342

    inc hl                                        ; $4344
    ld a, [hl+]                                   ; $4345
    cp $ff                                        ; $4346
    jr z, jr_007_434f                             ; $4348

    inc e                                         ; $434A
    ld d, $00                                     ; $434B
    jr jr_007_4352                                ; $434D

jr_007_434f:
    ld e, [hl]                                    ; $434F
    ld d, $00                                     ; $4350

jr_007_4352:
    inc d                                         ; $4352
    ret                                           ; $4353


; C: auto: 72 bytes, bytes; referenced by Link_DrawAnimatorSlot. L3 pass 2026-10-26: read in BGB in 2 replay(s) of the
; organic corpus, modes 0E (tcrf_check/assets/l3_names/)
Link_DrawAnimatorSlot_Tbl4354::
    db $c0, $c1, $20, $bf, $c2, $20, $ff, $00, $00, $c6, $c7, $20, $c5, $c8, $20, $ff
    db $03, $00, $c0, $c2, $20, $ff, $06, $00, $c6, $c8, $20, $ff, $08, $00, $bd, $00
    db $20, $ff, $0a, $00, $c3, $00, $20, $ff, $0c, $00, $be, $00, $20, $ff, $0e, $00
    db $c4, $00, $20, $ff, $10, $00, $be, $00, $04, $bd, $00, $04, $ff, $12, $00, $c4
    db $00, $04, $c3, $00, $04, $ff, $15, $00

; C: message strip A or B by role
Mode0E_State02_MessageStrip::
    ld a, [wSavedDc52]                            ; $439C
    and a                                         ; $439F
    jr nz, jr_007_43b5                            ; $43A0

    ld a, $0a                                     ; $43A2
    ld [wMsgStripSel], a                          ; $43A4
    ld a, $04                                     ; $43A7
    ld [wIconSel], a                              ; $43A9
    xor a                                         ; $43AC
    ld [wSubstate], a                             ; $43AD
    ld hl, wState                                 ; $43B0
    inc [hl]                                      ; $43B3
    ret                                           ; $43B4


jr_007_43b5:
    ld a, $0e                                     ; $43B5
    ld [wMsgStripSel], a                          ; $43B7
    ld a, $04                                     ; $43BA
    ld [wIconSel], a                              ; $43BC
    xor a                                         ; $43BF
    ld [wSubstate], a                             ; $43C0
    ld [wAbResult], a                             ; $43C3
    ld hl, wState                                 ; $43C6
    inc [hl]                                      ; $43C9
    ret                                           ; $43CA


; C: far call 07:4C08 (photo choose dialog)
Mode0E_State03_PickPhoto::
    ldh [hFarcallAArg], a                         ; $43CB
    ld a, $07                                     ; $43CD
    ld hl, LinkPick_Far                           ; $43CF
    call Far_Call                                 ; $43D2
    ret                                           ; $43D5


; C: after the dialog: loads the chosen photo into the link buffer; BGB watchpoint pass 2026-10-25: ran only in mode
; 0E and state 04 (2 hits in 2 runs: 0E:04 x2; tcrf_check/assets/mode_state_wp/)
Mode0E_State04_PickDone::
    ld a, [wAbResult]                             ; $43D6
    cp $02                                        ; $43D9
    jp z, Mode0E_LeaveToLinkMenu                  ; $43DB

    ld a, [wSavedDc52]                            ; $43DE
    and a                                         ; $43E1
    jp nz, Mode0E_State06_ExchangeSetup           ; $43E2

    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $43E5
    ldh [hLcdcShadow], a                          ; $43E7
    ld hl, wLinkBuffer                            ; $43E9
    ld bc, $1000                                  ; $43EC
    call Mem_Zero                                 ; $43EF
    ld a, [wPhotoIndex]                           ; $43F2
    ldh [hFarcallAArg], a                         ; $43F5
    ld a, BANK(Photo_LoadImage_Far)               ; $43F7
    ld hl, Photo_LoadImage_Far                    ; $43F9
    call Far_Call                                 ; $43FC
    ldh [hFarcallAArg], a                         ; $43FF
    ld a, BANK(Owner_Load_Far)                    ; $4401
    ld hl, Owner_Load_Far                         ; $4403
    call Far_Call                                 ; $4406
    ld a, [wOwnerGenderBlood]                     ; $4409
    ld [wLinkPeerGenderBlood], a                  ; $440C
    ld a, $00                                     ; $440F
    ld hl, wPhotoImage                            ; $4411
    ld de, $9000                                  ; $4414
    ld bc, $0800                                  ; $4417
    call Mem_CopyFromBank                         ; $441A
    ld a, $00                                     ; $441D
    ld hl, wPhotoImage + $800                     ; $441F
    ld de, $8800                                  ; $4422
    ld bc, $0100                                  ; $4425
    call Mem_CopyFromBank                         ; $4428
    ld a, $00                                     ; $442B
    ld hl, wPhotoImage + $900                     ; $442D
    ld de, $8000                                  ; $4430
    ld bc, $0500                                  ; $4433
    call Mem_CopyFromBank                         ; $4436
    ld a, BANK(Map_27_44B2_Mode17_State08_Split_Build); $4439
    ld hl, Map_27_44B2_Mode17_State08_Split_Build ; $443B
    ld de, $9800                                  ; $443E
    ld bc, $02c0                                  ; $4441
    call Mem_CopyFromBank                         ; $4444
    ld a, BANK(Gfx_17_4950_Shoot_DrawTimerMinutes); $4447
    ld hl, Gfx_17_4950_Shoot_DrawTimerMinutes     ; $4449
    ld de, $8ff0                                  ; $444C
    ld bc, $0010                                  ; $444F
    call Mem_CopyFromBank                         ; $4452
    ld a, BANK(Gfx_17_4680_Mode0F_State05_ConfirmInit); $4455
    ld hl, Gfx_17_4680_Mode0F_State05_ConfirmInit ; $4457
    ld de, $8500                                  ; $445A
    ld bc, $0080                                  ; $445D
    call Mem_CopyFromBank                         ; $4460
    ld a, BANK(Gfx_18_7BA0_Mode0E_State04_PickDone); $4463
    ld hl, Gfx_18_7BA0_Mode0E_State04_PickDone    ; $4465
    ld de, $8580                                  ; $4468
    ld bc, $00a0                                  ; $446B
    call Mem_CopyFromBank                         ; $446E
    ld a, BANK(Gfx_17_4A60_Mode0E_State04_PickDone); $4471
    ld hl, Gfx_17_4A60_Mode0E_State04_PickDone    ; $4473
    ld de, $8620                                  ; $4476
    ld bc, $0020                                  ; $4479
    call Mem_CopyFromBank                         ; $447C
    ld a, BANK(Gfx_17_4B60_Mode0E_State04_PickDone); $447F
    ld hl, Gfx_17_4B60_Mode0E_State04_PickDone    ; $4481
    ld de, $8640                                  ; $4484
    ld bc, $0030                                  ; $4487
    call Mem_CopyFromBank                         ; $448A
    ld a, BANK(Gfx_17_4B90_Mode0E_State04_PickDone); $448D
    ld hl, Gfx_17_4B90_Mode0E_State04_PickDone    ; $448F
    ld de, $8720                                  ; $4492
    ld bc, $0050                                  ; $4495
    call Mem_CopyFromBank                         ; $4498
    ld a, $54                                     ; $449B
    ldh [hLycShadowSplit1], a                     ; $449D
    ldh [hSplit1Latch], a                         ; $449F
    ld hl, hStatShadow                            ; $44A1
    set 6, [hl]                                   ; $44A4
    ld hl, rIE                                    ; $44A6
    set 1, [hl]                                   ; $44A9
    ld a, $01                                     ; $44AB
    ldh [hStatHandlerIndex], a                    ; $44AD
    call Oam_ClearShadow                          ; $44AF
    call Lcd_On                                   ; $44B2
    call Pal_FadeIn                               ; $44B5
    ld hl, wState                                 ; $44B8
    inc [hl]                                      ; $44BB
    ret                                           ; $44BC


; C: the initiator-sender's confirmation dialog (README 14.3; the counterpart of Mode0E_State0E_ResponderConfirmSend
; on the responder, same dialog sprite Link_DrawAbortJitter): A -> state 06 (exchange set-up, the photo is sent), B ->
; state 02 (choose another photo, code only); was ...
Mode0E_State05_InitiatorConfirmSend::
    call Link_DrawAbortJitter                     ; $44BD
    ldh a, [hKeysNew]                             ; $44C0
    bit PADB_A, a                                 ; $44C2
    jr z, jr_007_44db                             ; $44C4

    call Pal_FadeOut                              ; $44C6
    call Lcd_Off                                  ; $44C9
    ld hl, hStatShadow                            ; $44CC
    res 6, [hl]                                   ; $44CF
    ld hl, rIE                                    ; $44D1
    res 1, [hl]                                   ; $44D4
    ld hl, wState                                 ; $44D6
    inc [hl]                                      ; $44D9
    ret                                           ; $44DA


jr_007_44db:
    bit 1, a                                      ; $44DB
    ret z                                         ; $44DD

    call Pal_FadeOut                              ; $44DE
    call Lcd_Off                                  ; $44E1
    ld hl, hStatShadow                            ; $44E4
    res 6, [hl]                                   ; $44E7
    ld hl, rIE                                    ; $44E9
    res 1, [hl]                                   ; $44EC
    ld a, STATE_0E_MESSAGE_STRIP                  ; $44EE
    ld [wState], a                                ; $44F0
    ret                                           ; $44F3


; C: bars and lamps for the exchange (first direction); BGB watchpoint pass 2026-10-25: ran only in mode 0E and state
; 06 (4 hits in 2 runs: 0E:06 x4; tcrf_check/assets/mode_state_wp/)
Mode0E_State06_ExchangeSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $44F4
    ldh [hLcdcShadow], a                          ; $44F6
    xor a                                         ; $44F8
    ld [wLinkBarX], a                             ; $44F9
    ld [wLinkBarPhase], a                         ; $44FC
    ld [wLinkLampScript], a                       ; $44FF
    ld [wLinkLampScript + $1], a                  ; $4502
    ld a, $07                                     ; $4505
    ldh [hWxShadow], a                            ; $4507
    ld a, $90                                     ; $4509
    ldh [hWyShadow], a                            ; $450B
    ld a, BANK(Gfx_15_6C00_Mode0E_State06_ExchangeSetup); $450D
    ld hl, Gfx_15_6C00_Mode0E_State06_ExchangeSetup; $450F
    ld de, $9000                                  ; $4512
    ld bc, $0800                                  ; $4515
    call Mem_CopyFromBank                         ; $4518
    ld a, BANK(Gfx_15_7400_Mode0E_State06_ExchangeSetup); $451B
    ld hl, Gfx_15_7400_Mode0E_State06_ExchangeSetup; $451D
    ld de, $8800                                  ; $4520
    ld bc, $0700                                  ; $4523
    call Mem_CopyFromBank                         ; $4526
    ld a, BANK(Gfx_15_7C00_Mode0E_State06_ExchangeSetup); $4529
    ld hl, Gfx_15_7C00_Mode0E_State06_ExchangeSetup; $452B
    ld de, $8000                                  ; $452E
    ld bc, $0400                                  ; $4531
    call Mem_CopyFromBank                         ; $4534
    ld a, BANK(Map_24_5180_Mode0E_State06_ExchangeSetup); $4537
    ld hl, Map_24_5180_Mode0E_State06_ExchangeSetup; $4539
    ld de, $9800                                  ; $453C
    ld bc, $0240                                  ; $453F
    call Mem_CopyFromBank                         ; $4542
    ld a, BANK(Map_24_53C0_Mode0E_State06_ExchangeSetup); $4545
    ld hl, Map_24_53C0_Mode0E_State06_ExchangeSetup; $4547
    ld de, $9c00                                  ; $454A
    ld bc, $0100                                  ; $454D
    call Mem_CopyFromBank                         ; $4550
    call Oam_ClearShadow                          ; $4553
    call Pal_AllWhite                             ; $4556
    call Lcd_On                                   ; $4559
    push af                                       ; $455C
    ld a, MUSIC_LINK_EXCHANGE_SETUP               ; $455D
    call Snd_Music                                ; $455F
    pop af                                        ; $4562
    call Pal_FadeIn                               ; $4563
    ld a, $00                                     ; $4566
    ld [wLinkTimeout], a                          ; $4568
    ld a, $02                                     ; $456B
    ld [wLinkTimeout + $1], a                     ; $456D
    ld a, [wSavedDc52]                            ; $4570
    and a                                         ; $4573
    jr nz, jr_007_458a                            ; $4574

    ld a, [wPhotoIndex]                           ; $4576
    ld [wLnkSlot], a                              ; $4579
    ld a, $01                                     ; $457C
    ld [wLnkReadyTx], a                           ; $457E
    call Link_QueueCommand                        ; $4581
    ld a, STATE_0E_EXCHANGE_WAIT_A                ; $4584
    ld [wState], a                                ; $4586
    ret                                           ; $4589


jr_007_458a:
    ld a, [wPhotoIndex]                           ; $458A
    ld [wLnkSlot], a                              ; $458D
    call Link_QueueCommand                        ; $4590
    ld a, STATE_0E_EXCHANGE_BARS_A                ; $4593
    ld [wState], a                                ; $4595
    ret                                           ; $4598


; C: progress bars; direction 1; ran only in mode 0E and state 07 on the initiator that receives (872 hits); FORCED
; run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two BGB instances with
; the link deadline disabled (07:4ACE dec [hl] -> nop; without it every ...
Mode0E_State07_ExchangeBarsA::
    ld a, $01                                     ; $4599
    ld [wLinkBarDir], a                           ; $459B
    call Link_DrawLamps                           ; $459E
    call Link_DrawProgressBars                    ; $45A1
    ld a, [wLnkHalfDone]                          ; $45A4
    cp $01                                        ; $45A7
    jr nz, jr_007_45c4                            ; $45A9

    push af                                       ; $45AB
    ld a, SFX3_MAIN_MENU_VIEW_ARCADE              ; $45AC
    call Snd_Sfx3                                 ; $45AE
    pop af                                        ; $45B1
    ld bc, $0014                                  ; $45B2
    call Wait_Frames                              ; $45B5
    call Pal_FadeOut                              ; $45B8
    call Lcd_Off                                  ; $45BB
    ld a, STATE_0E_MESSAGE_STRIP                  ; $45BE
    ld [wState], a                                ; $45C0
    ret                                           ; $45C3


jr_007_45c4:
    ld a, [wLnkIndex + $1]                        ; $45C4
    bit 7, a                                      ; $45C7
    ret nz                                        ; $45C9

    cp $04                                        ; $45CA
    ret c                                         ; $45CC

    ld hl, wState                                 ; $45CD
    inc [hl]                                      ; $45D0
    ret                                           ; $45D1


; C: bars; direction 0; watchdog; BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 08 (1640 hits in 2
; runs: 0E:08 x1640; tcrf_check/assets/mode_state_wp/)
Mode0E_State08_ExchangeWaitA::
    xor a                                         ; $45D2
    ld [wLinkBarDir], a                           ; $45D3
    call Link_DrawLamps                           ; $45D6
    call Link_DrawProgressBars                    ; $45D9
    ldh [hFarcallAArg], a                         ; $45DC
    ld a, $07                                     ; $45DE
    ld hl, Link_TimeoutTick                       ; $45E0
    call Far_Call                                 ; $45E3
    jr nz, jr_007_45f3                            ; $45E6

    ld a, $0c                                     ; $45E8
    ld [wResultMsgId], a                          ; $45EA
    ld a, STATE_0E_RESULT_PREPARE                 ; $45ED
    ld [wState], a                                ; $45EF
    ret                                           ; $45F2


jr_007_45f3:
    ld a, [wLnkEnded]                             ; $45F3
    and a                                         ; $45F6
    ret z                                         ; $45F7

    ld hl, wState                                 ; $45F8
    inc [hl]                                      ; $45FB
    ret                                           ; $45FC


; C: counts the transfer and shows the received picture
Mode0E_State09_ExchangeDoneA::
    call Pal_FadeOut                              ; $45FD
    call Lcd_Off                                  ; $4600
    call Counters_IncTransferred                  ; $4603
    ld a, [wSavedDc52]                            ; $4606
    and a                                         ; $4609
    jr z, jr_007_4622                             ; $460A

    call Counters_IncReceivedBySender             ; $460C
    ldh [hFarcallAArg], a                         ; $460F
    ld a, BANK(Photo_SaveReceived_Far)            ; $4611
    ld hl, Photo_SaveReceived_Far                 ; $4613
    call Far_Call                                 ; $4616
    ld a, STATE_0E_INIT                           ; $4619
    ld [wState], a                                ; $461B
    call Link_ShowScreenB                         ; $461E
    ret                                           ; $4621


jr_007_4622:
    ld a, [wPhotoIndex]                           ; $4622
    ldh [hFarcallAArg], a                         ; $4625
    ld a, BANK(Photo_Erase_UnlinkAll_Far)         ; $4627
    ld hl, Photo_Erase_UnlinkAll_Far              ; $4629
    call Far_Call                                 ; $462C
    ld a, [wPhotoIndex]                           ; $462F
    ldh [hFarcallAArg], a                         ; $4632
    ld a, BANK(Photo_Erase_Far)                   ; $4634
    ld hl, Photo_Erase_Far                        ; $4636
    call Far_Call                                 ; $4639
    ld a, STATE_0E_INIT                           ; $463C
    ld [wState], a                                ; $463E
    call Link_ShowScreenA                         ; $4641
    ret                                           ; $4644


; C: second direction; BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 0A (4 hits in 2 runs: 0E:0A x4;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State0A_ExchangeSetupB::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $4645
    ldh [hLcdcShadow], a                          ; $4647
    xor a                                         ; $4649
    ld [wLinkBarX], a                             ; $464A
    ld [wLinkBarPhase], a                         ; $464D
    ld [wLinkLampScript], a                       ; $4650
    ld [wLinkLampScript + $1], a                  ; $4653
    ld a, $07                                     ; $4656
    ldh [hWxShadow], a                            ; $4658
    ld a, $90                                     ; $465A
    ldh [hWyShadow], a                            ; $465C
    ld a, BANK(Gfx_15_6C00_Mode0E_State06_ExchangeSetup); $465E
    ld hl, Gfx_15_6C00_Mode0E_State06_ExchangeSetup; $4660
    ld de, $9000                                  ; $4663
    ld bc, $0800                                  ; $4666
    call Mem_CopyFromBank                         ; $4669
    ld a, BANK(Gfx_15_7400_Mode0E_State06_ExchangeSetup); $466C
    ld hl, Gfx_15_7400_Mode0E_State06_ExchangeSetup; $466E
    ld de, $8800                                  ; $4671
    ld bc, $0700                                  ; $4674
    call Mem_CopyFromBank                         ; $4677
    ld a, BANK(Gfx_15_7C00_Mode0E_State06_ExchangeSetup); $467A
    ld hl, Gfx_15_7C00_Mode0E_State06_ExchangeSetup; $467C
    ld de, $8000                                  ; $467F
    ld bc, $0400                                  ; $4682
    call Mem_CopyFromBank                         ; $4685
    ld a, BANK(Map_24_5180_Mode0E_State06_ExchangeSetup); $4688
    ld hl, Map_24_5180_Mode0E_State06_ExchangeSetup; $468A
    ld de, $9800                                  ; $468D
    ld bc, $0240                                  ; $4690
    call Mem_CopyFromBank                         ; $4693
    ld a, BANK(Map_24_53C0_Mode0E_State06_ExchangeSetup); $4696
    ld hl, Map_24_53C0_Mode0E_State06_ExchangeSetup; $4698
    ld de, $9c00                                  ; $469B
    ld bc, $0100                                  ; $469E
    call Mem_CopyFromBank                         ; $46A1
    call Oam_ClearShadow                          ; $46A4
    call Pal_AllWhite                             ; $46A7
    call Lcd_On                                   ; $46AA
    push af                                       ; $46AD
    ld a, MUSIC_LINK_EXCHANGE_SETUP               ; $46AE
    call Snd_Music                                ; $46B0
    pop af                                        ; $46B3
    call Pal_FadeIn                               ; $46B4
    ld hl, wState                                 ; $46B7
    inc [hl]                                      ; $46BA
    ret                                           ; $46BB


; C: BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 0B (2352 hits in 2 runs: 0E:0B x2352;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State0B_ExchangeBarsB::
    ld a, $01                                     ; $46BC
    ld [wLinkBarDir], a                           ; $46BE
    call Link_DrawLamps                           ; $46C1
    call Link_DrawProgressBars                    ; $46C4
    ld a, [wLnkCmdRx]                             ; $46C7
    bit 7, a                                      ; $46CA
    jr z, jr_007_46fb                             ; $46CC

    cp $ef                                        ; $46CE
    jr z, jr_007_4725                             ; $46D0

    and $03                                       ; $46D2
    sla a                                         ; $46D4
    sla a                                         ; $46D6
    sla a                                         ; $46D8
    ldh [hFarcallAArg], a                         ; $46DA
    ld a, BANK(Album_LoadThumbPage_Far)           ; $46DC
    ld hl, Album_LoadThumbPage_Far                ; $46DE
    call Far_Call                                 ; $46E1
    ld a, $01                                     ; $46E4
    ld [wLnkReadyTx], a                           ; $46E6
    xor a                                         ; $46E9
    ld [wLnkHalfDone], a                          ; $46EA
    ld a, $b4                                     ; $46ED
    ld [wLinkTimeout], a                          ; $46EF
    xor a                                         ; $46F2
    ld [wLinkTimeout + $1], a                     ; $46F3
    ld hl, wState                                 ; $46F6
    inc [hl]                                      ; $46F9
    ret                                           ; $46FA


jr_007_46fb:
    bit 6, a                                      ; $46FB
    ret z                                         ; $46FD

    and $1f                                       ; $46FE
    ld [wPhotoIndex], a                           ; $4700
    ld a, $00                                     ; $4703
    ld [wLinkTimeout], a                          ; $4705
    ld a, $02                                     ; $4708
    ld [wLinkTimeout + $1], a                     ; $470A
    ld a, [wSavedDc52]                            ; $470D
    and a                                         ; $4710
    jr nz, jr_007_471f                            ; $4711

    call Pal_FadeOut                              ; $4713
    call Lcd_Off                                  ; $4716
    ld a, STATE_0E_PICK_SECOND                    ; $4719
    ld [wState], a                                ; $471B
    ret                                           ; $471E


jr_007_471f:
    ld a, STATE_0E_EXCHANGE_WAIT_C                ; $471F
    ld [wState], a                                ; $4721
    ret                                           ; $4724


jr_007_4725:
    call Pal_FadeOut                              ; $4725
    call Lcd_Off                                  ; $4728
    jp Mode0E_LeaveToLinkMenu                     ; $472B


; C: receiver-initiated link exchange in BGB (tcrf_check/tools/bgb_link_rx.py, 2026-10-25): ran only in mode 0E and
; state 0C (720 hits in 2 runs, responder that sends, JP-JP and international initiator;
; tcrf_check/assets/mode_state_wp/): waits for wLnkHalfDone after a thumbnail page is armed, 180-frame ...
Mode0E_State0C_ExchangeWaitB::
    xor a                                         ; $472E
    ld [wLinkBarDir], a                           ; $472F
    call Link_DrawLamps                           ; $4732
    call Link_DrawProgressBars                    ; $4735
    ldh [hFarcallAArg], a                         ; $4738
    ld a, $07                                     ; $473A
    ld hl, Link_TimeoutTick                       ; $473C
    call Far_Call                                 ; $473F
    jr nz, jr_007_474f                            ; $4742

    ld a, $0c                                     ; $4744
    ld [wResultMsgId], a                          ; $4746
    ld a, STATE_0E_RESULT_PREPARE                 ; $4749
    ld [wState], a                                ; $474B
    ret                                           ; $474E


jr_007_474f:
    ld a, [wLnkHalfDone]                          ; $474F
    and a                                         ; $4752
    ret z                                         ; $4753

    ld hl, wState                                 ; $4754
    dec [hl]                                      ; $4757
    ret                                           ; $4758


; C: clears the slot buffer and prepares the second photo; ran only in mode 0E and state 0D on the responder that
; sends (2 hits): it builds the confirmation screen of the photo the initiator asked for; FORCED run (2026-10-25,
; tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two ...
Mode0E_State0D_PickSecond::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4759
    ldh [hLcdcShadow], a                          ; $475B
    ld hl, wLinkBuffer                            ; $475D
    ld bc, $1000                                  ; $4760
    call Mem_Zero                                 ; $4763
    ld a, [wPhotoIndex]                           ; $4766
    ldh [hFarcallAArg], a                         ; $4769
    ld a, BANK(Photo_LoadImage_Far)               ; $476B
    ld hl, Photo_LoadImage_Far                    ; $476D
    call Far_Call                                 ; $4770
    ldh [hFarcallAArg], a                         ; $4773
    ld a, BANK(Owner_Load_Far)                    ; $4775
    ld hl, Owner_Load_Far                         ; $4777
    call Far_Call                                 ; $477A
    ld a, [wOwnerGenderBlood]                     ; $477D
    ld [wLinkPeerGenderBlood], a                  ; $4780
    ld a, $00                                     ; $4783
    ld hl, wPhotoImage                            ; $4785
    ld de, $9000                                  ; $4788
    ld bc, $0800                                  ; $478B
    call Mem_CopyFromBank                         ; $478E
    ld a, $00                                     ; $4791
    ld hl, wPhotoImage + $800                     ; $4793
    ld de, $8800                                  ; $4796
    ld bc, $0100                                  ; $4799
    call Mem_CopyFromBank                         ; $479C
    ld a, $00                                     ; $479F
    ld hl, wPhotoImage + $900                     ; $47A1
    ld de, $8000                                  ; $47A4
    ld bc, $0500                                  ; $47A7
    call Mem_CopyFromBank                         ; $47AA
    ld a, BANK(Map_27_44B2_Mode17_State08_Split_Build); $47AD
    ld hl, Map_27_44B2_Mode17_State08_Split_Build ; $47AF
    ld de, $9800                                  ; $47B2
    ld bc, $02c0                                  ; $47B5
    call Mem_CopyFromBank                         ; $47B8
    ld a, BANK(Gfx_17_4950_Shoot_DrawTimerMinutes); $47BB
    ld hl, Gfx_17_4950_Shoot_DrawTimerMinutes     ; $47BD
    ld de, $8ff0                                  ; $47C0
    ld bc, $0010                                  ; $47C3
    call Mem_CopyFromBank                         ; $47C6
    ld a, BANK(Gfx_17_4680_Mode0F_State05_ConfirmInit); $47C9
    ld hl, Gfx_17_4680_Mode0F_State05_ConfirmInit ; $47CB
    ld de, $8500                                  ; $47CE
    ld bc, $0080                                  ; $47D1
    call Mem_CopyFromBank                         ; $47D4
    ld a, BANK(Gfx_18_7BA0_Mode0E_State04_PickDone); $47D7
    ld hl, Gfx_18_7BA0_Mode0E_State04_PickDone    ; $47D9
    ld de, $8580                                  ; $47DC
    ld bc, $00a0                                  ; $47DF
    call Mem_CopyFromBank                         ; $47E2
    ld a, BANK(Gfx_17_4A60_Mode0E_State04_PickDone); $47E5
    ld hl, Gfx_17_4A60_Mode0E_State04_PickDone    ; $47E7
    ld de, $8620                                  ; $47EA
    ld bc, $0020                                  ; $47ED
    call Mem_CopyFromBank                         ; $47F0
    ld a, BANK(Gfx_17_4B60_Mode0E_State04_PickDone); $47F3
    ld hl, Gfx_17_4B60_Mode0E_State04_PickDone    ; $47F5
    ld de, $8640                                  ; $47F8
    ld bc, $0030                                  ; $47FB
    call Mem_CopyFromBank                         ; $47FE
    ld a, BANK(Gfx_17_4B90_Mode0E_State04_PickDone); $4801
    ld hl, Gfx_17_4B90_Mode0E_State04_PickDone    ; $4803
    ld de, $8720                                  ; $4806
    ld bc, $0050                                  ; $4809
    call Mem_CopyFromBank                         ; $480C
    ld a, $54                                     ; $480F
    ldh [hLycShadowSplit1], a                     ; $4811
    ldh [hSplit1Latch], a                         ; $4813
    ld hl, hStatShadow                            ; $4815
    set 6, [hl]                                   ; $4818
    ld hl, rIE                                    ; $481A
    set 1, [hl]                                   ; $481D
    ld a, $01                                     ; $481F
    ldh [hStatHandlerIndex], a                    ; $4821
    call Oam_ClearShadow                          ; $4823
    call Lcd_On                                   ; $4826
    call Pal_FadeIn                               ; $4829
    ld hl, wState                                 ; $482C
    inc [hl]                                      ; $482F
    ret                                           ; $4830


; C: the sending responder's confirmation dialog (README 14.3, 14.7): A -> state 0F (ready, the photo is sent), B ->
; wLnkReadyTx = $EF (refuse) and state 0A; ran only in mode 0E and state 0E (778 hits) and the confirm A took it to
; 0F; FORCED run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): ...
Mode0E_State0E_ResponderConfirmSend::
    call Link_DrawAbortJitter                     ; $4831
    ldh a, [hKeysNew]                             ; $4834
    bit PADB_A, a                                 ; $4836
    jr z, jr_007_484f                             ; $4838

    call Pal_FadeOut                              ; $483A
    call Lcd_Off                                  ; $483D
    ld hl, hStatShadow                            ; $4840
    res 6, [hl]                                   ; $4843
    ld hl, rIE                                    ; $4845
    res 1, [hl]                                   ; $4848
    ld hl, wState                                 ; $484A
    inc [hl]                                      ; $484D
    ret                                           ; $484E


jr_007_484f:
    bit 1, a                                      ; $484F
    ret z                                         ; $4851

    call Pal_FadeOut                              ; $4852
    call Lcd_Off                                  ; $4855
    ld hl, hStatShadow                            ; $4858
    res 6, [hl]                                   ; $485B
    ld hl, rIE                                    ; $485D
    res 1, [hl]                                   ; $4860
    ld a, $ef                                     ; $4862
    ld [wLnkReadyTx], a                           ; $4864
    ld a, STATE_0E_EXCHANGE_SETUP_B               ; $4867
    ld [wState], a                                ; $4869
    ret                                           ; $486C


; C: lnk_ready_tx := 1; ran only in mode 0E and state 0F (2 hits): wLnkReadyTx := 1 after the A of the confirmation
; dialog; FORCED run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two BGB
; instances with the link deadline disabled (07:4ACE dec [hl] -> nop; ...
Mode0E_State0F_Ready::
    call Mode0E_State0A_ExchangeSetupB            ; $486D
    ld a, $01                                     ; $4870
    ld [wLnkReadyTx], a                           ; $4872
    ret                                           ; $4875


; C: BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 10 (1640 hits in 2 runs: 0E:10 x1640;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State10_ExchangeWaitC::
    xor a                                         ; $4876
    ld [wLinkBarDir], a                           ; $4877
    call Link_DrawLamps                           ; $487A
    call Link_DrawProgressBars                    ; $487D
    ldh [hFarcallAArg], a                         ; $4880
    ld a, $07                                     ; $4882
    ld hl, Link_TimeoutTick                       ; $4884
    call Far_Call                                 ; $4887
    jr nz, jr_007_4897                            ; $488A

    ld a, $0c                                     ; $488C
    ld [wResultMsgId], a                          ; $488E
    ld a, STATE_0E_RESULT_PREPARE                 ; $4891
    ld [wState], a                                ; $4893
    ret                                           ; $4896


jr_007_4897:
    ld a, [wLnkEnded]                             ; $4897
    and a                                         ; $489A
    ret z                                         ; $489B

    ld hl, wState                                 ; $489C
    inc [hl]                                      ; $489F
    ret                                           ; $48A0


; C: counts the transfer and shows the received picture
Mode0E_State11_ExchangeDoneB::
    call Pal_FadeOut                              ; $48A1
    call Lcd_Off                                  ; $48A4
    call Counters_IncTransferred                  ; $48A7
    ld a, [wSavedDc52]                            ; $48AA
    and a                                         ; $48AD
    jr z, jr_007_48c6                             ; $48AE

    call Counters_IncReceivedBySender             ; $48B0
    ldh [hFarcallAArg], a                         ; $48B3
    ld a, BANK(Photo_SaveReceived_Far)            ; $48B5
    ld hl, Photo_SaveReceived_Far                 ; $48B7
    call Far_Call                                 ; $48BA
    ld a, STATE_0E_INIT                           ; $48BD
    ld [wState], a                                ; $48BF
    call Link_ShowScreenB                         ; $48C2
    ret                                           ; $48C5


jr_007_48c6:
    ld a, [wPhotoIndex]                           ; $48C6
    ldh [hFarcallAArg], a                         ; $48C9
    ld a, BANK(Photo_Erase_UnlinkAll_Far)         ; $48CB
    ld hl, Photo_Erase_UnlinkAll_Far              ; $48CD
    call Far_Call                                 ; $48D0
    ld a, [wPhotoIndex]                           ; $48D3
    ldh [hFarcallAArg], a                         ; $48D6
    ld a, BANK(Photo_Erase_Far)                   ; $48D8
    ld hl, Photo_Erase_Far                        ; $48DA
    call Far_Call                                 ; $48DD
    ld a, STATE_0E_INIT                           ; $48E0
    ld [wState], a                                ; $48E2
    call Link_ShowScreenA                         ; $48E5
    ret                                           ; $48E8


; C
Mode0E_State12_ResultPrepare::
    call Pal_FadeOut                              ; $48E9
    call Lcd_Off                                  ; $48EC
    xor a                                         ; $48EF
    ld [wSubstate], a                             ; $48F0
    ld hl, wState                                 ; $48F3
    inc [hl]                                      ; $48F6
    ret                                           ; $48F7


; C: far call 09:7290
Mode0E_State13_ResultScreen::
    ldh [hFarcallAArg], a                         ; $48F8
    ld a, BANK(ResultScreen_Far)                  ; $48FA
    ld hl, ResultScreen_Far                       ; $48FC
    call Far_Call                                 ; $48FF
    ret                                           ; $4902


; C: jp 07:40EE
Mode0E_State14_Abort::
    jp Mode0E_LeaveToLinkMenu                     ; $4903


; C: lamp script at 07:499E
Link_DrawLamps::
    ld a, [wLinkLampScript]                       ; $4906
    sla a                                         ; $4909
    ld c, a                                       ; $490B
    ld b, $00                                     ; $490C
    ld hl, Link_LampScriptTbl                     ; $490E
    add hl, bc                                    ; $4911
    ld e, [hl]                                    ; $4912
    ld bc, $358c                                  ; $4913
    ld a, $a5                                     ; $4916
    bit 2, e                                      ; $4918
    call nz, Oam_AddMeta_B02_5272                 ; $491A
    ld bc, $658c                                  ; $491D
    ld a, $a6                                     ; $4920
    bit 1, e                                      ; $4922
    call nz, Oam_AddMeta_B02_5272                 ; $4924
    ld bc, $958c                                  ; $4927
    ld a, $a7                                     ; $492A
    call Link_FlickerLamp3                        ; $492C
    inc hl                                        ; $492F
    ld a, [wLinkLampScript + $1]                  ; $4930
    cp [hl]                                       ; $4933
    jr c, jr_007_4943                             ; $4934

    inc hl                                        ; $4936
    ld a, [hl]                                    ; $4937
    inc a                                         ; $4938
    jr z, jr_007_493f                             ; $4939

    ld a, [wLinkLampScript]                       ; $493B
    inc a                                         ; $493E

jr_007_493f:
    ld [wLinkLampScript], a                       ; $493F
    xor a                                         ; $4942

jr_007_4943:
    inc a                                         ; $4943
    ld [wLinkLampScript + $1], a                  ; $4944
    ret                                           ; $4947


; C: random flicker of lamp 3
Link_FlickerLamp3::
    push af                                       ; $4948
    push bc                                       ; $4949
    push hl                                       ; $494A
    bit 0, e                                      ; $494B
    jr nz, jr_007_4955                            ; $494D

    xor a                                         ; $494F
    ld [wLinkFlicker + $1], a                     ; $4950
    jr jr_007_498e                                ; $4953

jr_007_4955:
    ld a, [wLinkFlicker + $1]                     ; $4955
    add $09                                       ; $4958
    jr nc, jr_007_495e                            ; $495A

    ld a, $ff                                     ; $495C

jr_007_495e:
    ld [wLinkFlicker + $1], a                     ; $495E
    ld a, [wLinkFlicker + $1]                     ; $4961
    ld hl, wLinkFlicker                           ; $4964
    cp [hl]                                       ; $4967
    jr c, jr_007_498e                             ; $4968

    ld a, [wLinkFlicker + $1]                     ; $496A
    sub $23                                       ; $496D
    jr nc, jr_007_4972                            ; $496F

    xor a                                         ; $4971

jr_007_4972:
    ld [wLinkFlicker + $1], a                     ; $4972
    call Rng_Next                                 ; $4975
    and $03                                       ; $4978
    add $0a                                       ; $497A
    ld c, a                                       ; $497C
    ld a, [wLinkFlicker]                          ; $497D
    sub c                                         ; $4980
    jr nc, jr_007_4984                            ; $4981

    xor a                                         ; $4983

jr_007_4984:
    ld [wLinkFlicker], a                          ; $4984
    pop hl                                        ; $4987
    pop bc                                        ; $4988
    pop af                                        ; $4989
    call Oam_AddMeta_B02_5272                     ; $498A
    ret                                           ; $498D


jr_007_498e:
    ld a, [wLinkFlicker]                          ; $498E
    add $08                                       ; $4991
    jr nc, jr_007_4997                            ; $4993

    ld a, $80                                     ; $4995

jr_007_4997:
    ld [wLinkFlicker], a                          ; $4997
    pop hl                                        ; $499A
    pop bc                                        ; $499B
    pop af                                        ; $499C
    ret                                           ; $499D


; C: 2-byte steps {flags; duration}; $FF loops
Link_LampScriptTbl::
    db $07, $f0, $07, $f0, $07, $f0, $00, $78, $04, $3c, $00, $50, $02, $3c, $00, $50
    db $01, $3c, $00, $50, $04, $1e, $02, $1e, $01, $1e, $00, $14, $07, $1e, $00, $14
    db $07, $1e, $00, $3c, $ff

; C: the two bars that cross the screen (X in D A02)
Link_DrawProgressBars::
    ld hl, wLinkBarX                              ; $49C3
    ld a, [wLinkBarDir]                           ; $49C6
    and a                                         ; $49C9
    jr nz, jr_007_49cf                            ; $49CA

    inc [hl]                                      ; $49CC
    jr jr_007_49d0                                ; $49CD

jr_007_49cf:
    dec [hl]                                      ; $49CF

jr_007_49d0:
    ld a, [wLinkBarPhase]                         ; $49D0
    inc a                                         ; $49D3
    cp $38                                        ; $49D4
    jr c, jr_007_49d9                             ; $49D6

    xor a                                         ; $49D8

jr_007_49d9:
    ld [wLinkBarPhase], a                         ; $49D9
    cp $08                                        ; $49DC
    jr nc, jr_007_49ef                            ; $49DE

    ld a, [wLinkBarDir]                           ; $49E0
    and a                                         ; $49E3
    jr nz, jr_007_49ef                            ; $49E4

    ld a, $e4                                     ; $49E6
    ldh [hBgpShadow], a                           ; $49E8
    ld a, $90                                     ; $49EA
    ldh [hWyShadow], a                            ; $49EC
    ret                                           ; $49EE


jr_007_49ef:
    ld a, $1b                                     ; $49EF
    ldh [hBgpShadow], a                           ; $49F1
    ld a, $50                                     ; $49F3
    ldh [hWyShadow], a                            ; $49F5
    ld a, [wLinkBarX]                             ; $49F7
    ld b, a                                       ; $49FA
    ld c, $24                                     ; $49FB
    ld a, [wLinkBarDir]                           ; $49FD
    add $a8                                       ; $4A00
    call Oam_AddMeta_B02_5272                     ; $4A02
    ld a, [wLinkBarX]                             ; $4A05
    cpl                                           ; $4A08
    add $a1                                       ; $4A09
    ld b, a                                       ; $4A0B
    ld c, $54                                     ; $4A0C
    ld a, [wLinkBarDir]                           ; $4A0E
    add $a8                                       ; $4A11
    call Oam_AddMeta_B02_5272                     ; $4A13
    ret                                           ; $4A16


; C: received photos: counter chosen by the sender gender bit (CFFF bit 0)
Counters_IncReceivedBySender::
    ldh [hFarcallAArg], a                         ; $4A17
    ld a, BANK(Counters_Load_Far)                 ; $4A19
    ld hl, Counters_Load_Far                      ; $4A1B
    call Far_Call                                 ; $4A1E
    ld hl, wCntRecvA                              ; $4A21
    ld a, [wLinkPeerGenderBlood]                  ; $4A24
    ld b, a                                       ; $4A27
    ld a, [hl]                                    ; $4A28
    bit 0, b                                      ; $4A29
    jr z, jr_007_4a34                             ; $4A2B

    cp $99                                        ; $4A2D
    jr z, jr_007_4a34                             ; $4A2F

    add $01                                       ; $4A31
    daa                                           ; $4A33

jr_007_4a34:
    ld [hl+], a                                   ; $4A34
    ld a, [hl]                                    ; $4A35
    bit 1, b                                      ; $4A36
    jr z, jr_007_4a41                             ; $4A38

    cp $99                                        ; $4A3A
    jr z, jr_007_4a41                             ; $4A3C

    add $01                                       ; $4A3E
    daa                                           ; $4A40

jr_007_4a41:
    ld [hl], a                                    ; $4A41
    ldh [hFarcallAArg], a                         ; $4A42
    ld a, BANK(Counters_Store_Far)                ; $4A44
    ld hl, Counters_Store_Far                     ; $4A46
    call Far_Call                                 ; $4A49
    ret                                           ; $4A4C


; I: UNREFERENCED
Unused_Link_DrawPhotoNumber::
    ld c, $00                                     ; $4A4D
    ld a, [wPhotoIndex]                           ; $4A4F
    inc a                                         ; $4A52

jr_007_4a53:
    cp $0a                                        ; $4A53
    jr c, jr_007_4a5c                             ; $4A55

    sub $0a                                       ; $4A57
    inc c                                         ; $4A59
    jr jr_007_4a53                                ; $4A5A

jr_007_4a5c:
    push bc                                       ; $4A5C
    ld c, a                                       ; $4A5D
    ld b, $00                                     ; $4A5E
    swap c                                        ; $4A60
    sla c                                         ; $4A62
    rl b                                          ; $4A64
    ld hl, $4800                                  ; $4A66
    add hl, bc                                    ; $4A69
    ld a, $17                                     ; $4A6A
    ld de, $8720                                  ; $4A6C
    ld bc, $0020                                  ; $4A6F
    call Vram_CopyFromBank                        ; $4A72
    pop bc                                        ; $4A75
    ld b, $00                                     ; $4A76
    swap c                                        ; $4A78
    sla c                                         ; $4A7A
    rl b                                          ; $4A7C
    ld hl, $4800                                  ; $4A7E
    add hl, bc                                    ; $4A81
    ld a, $17                                     ; $4A82
    ld de, $8700                                  ; $4A84
    ld bc, $0020                                  ; $4A87
    call Vram_CopyFromBank                        ; $4A8A
    ret                                           ; $4A8D


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_DrawAbortJitter::
    ldh a, [hFrameCounter]                        ; $4A8E
    and $01                                       ; $4A90
    jr nz, jr_007_4aa0                            ; $4A92

    call Rng_Next                                 ; $4A94
    ld [wJitterX], a                              ; $4A97
    call Rng_Next                                 ; $4A9A
    ld [wJitterY], a                              ; $4A9D

jr_007_4aa0:
    ld a, [wJitterX]                              ; $4AA0
    and $01                                       ; $4AA3
    add $79                                       ; $4AA5
    ld b, a                                       ; $4AA7
    ld a, [wJitterY]                              ; $4AA8
    and $01                                       ; $4AAB
    add $7c                                       ; $4AAD
    ld c, a                                       ; $4AAF
    ld a, $5f                                     ; $4AB0
    call Oam_AddMeta_B02_5272                     ; $4AB2
    ld a, [wJitterX]                              ; $4AB5
    and $01                                       ; $4AB8
    add $79                                       ; $4ABA
    ld b, a                                       ; $4ABC
    ld a, [wJitterY]                              ; $4ABD
    and $01                                       ; $4AC0
    add $8d                                       ; $4AC2
    ld c, a                                       ; $4AC4
    ld a, $60                                     ; $4AC5
    call Oam_AddMeta_B02_5272                     ; $4AC7
    ret                                           ; $4ACA


; C: far-return helper: watchdog of the waiting states; Z when 0
Link_TimeoutTick::
    ld hl, wLinkTimeout                           ; $4ACB
    dec [hl]                                      ; $4ACE
    ld a, [hl+]                                   ; $4ACF
    cp $ff                                        ; $4AD0
    jr nz, jr_007_4ad5                            ; $4AD2

    dec [hl]                                      ; $4AD4

jr_007_4ad5:
    ld a, [hl-]                                   ; $4AD5
    or [hl]                                       ; $4AD6
    jp Far_Call_Return                            ; $4AD7


; C: transferred photos + 1
Counters_IncTransferred::
    ldh [hFarcallAArg], a                         ; $4ADA
    ld a, BANK(Counters_Load_Far)                 ; $4ADC
    ld hl, Counters_Load_Far                      ; $4ADE
    call Far_Call                                 ; $4AE1
    ld a, $01                                     ; $4AE4
    ld hl, wCntSent                               ; $4AE6
    ld b, $02                                     ; $4AE9
    call Bcd_AddSaturate                          ; $4AEB
    ldh [hFarcallAArg], a                         ; $4AEE
    ld a, BANK(Counters_Store_Far)                ; $4AF0
    ld hl, Counters_Store_Far                     ; $4AF2
    call Far_Call                                 ; $4AF5
    ret                                           ; $4AF8


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the link result screen A: tiles 1C:5E60 / 6660 / 6D50 and map 26:5340 (Mode0E paths jr_007_4622 / jr_007_48C6)
Link_ShowScreenA::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4AF9
    ldh [hLcdcShadow], a                          ; $4AFB
    ld a, $e4                                     ; $4AFD
    ld [wPaletteTarget], a                        ; $4AFF
    ld [wPaletteTarget + $1], a                   ; $4B02
    ld [wPaletteTarget + $2], a                   ; $4B05
    xor a                                         ; $4B08
    ldh [hScxShadow], a                           ; $4B09
    ldh [hScyShadow], a                           ; $4B0B
    ld a, BANK(Gfx_1C_5E60_Link_ShowScreenA)      ; $4B0D
    ld hl, Gfx_1C_5E60_Link_ShowScreenA           ; $4B0F
    ld de, $9000                                  ; $4B12
    ld bc, $0800                                  ; $4B15
    call Mem_CopyFromBank                         ; $4B18
    ld a, BANK(Gfx_1C_6660_Link_ShowScreenA)      ; $4B1B
    ld hl, Gfx_1C_6660_Link_ShowScreenA           ; $4B1D
    ld de, $8800                                  ; $4B20
    ld bc, $0700                                  ; $4B23
    call Mem_CopyFromBank                         ; $4B26
    ld a, BANK(Gfx_1C_6D50_Link_ShowScreenB)      ; $4B29
    ld hl, Gfx_1C_6D50_Link_ShowScreenB           ; $4B2B
    ld de, $8ff0                                  ; $4B2E
    ld bc, $0010                                  ; $4B31
    call Mem_CopyFromBank                         ; $4B34
    ld a, $26                                     ; $4B37
    ld hl, Map_26_5340_Link_ShowScreenA           ; $4B39
    ld de, $9800                                  ; $4B3C
    ld bc, $0240                                  ; $4B3F
    call Mem_CopyFromBank                         ; $4B42
    call Oam_ClearShadow                          ; $4B45
    call Pal_AllWhite                             ; $4B48
    call Lcd_On                                   ; $4B4B
    call Pal_FadeIn                               ; $4B4E

jr_007_4b51:
    rst Rst08_WaitVBlank                          ; $4B51
    ldh a, [hKeysNew]                             ; $4B52
    and a                                         ; $4B54
    jr z, jr_007_4b51                             ; $4B55

    call Pal_FadeOut                              ; $4B57
    call Lcd_Off                                  ; $4B5A
    ret                                           ; $4B5D


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the link result screen B: the same tiles and map 26:6540 (Mode0E_State09_ExchangeDoneA, State11_ExchangeDoneB)
Link_ShowScreenB::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4B5E
    ldh [hLcdcShadow], a                          ; $4B60
    ld a, $e4                                     ; $4B62
    ld [wPaletteTarget], a                        ; $4B64
    ld [wPaletteTarget + $1], a                   ; $4B67
    ld [wPaletteTarget + $2], a                   ; $4B6A
    xor a                                         ; $4B6D
    ldh [hScxShadow], a                           ; $4B6E
    ldh [hScyShadow], a                           ; $4B70
    ld a, BANK(Gfx_1C_5E60_Link_ShowScreenA)      ; $4B72
    ld hl, Gfx_1C_5E60_Link_ShowScreenA           ; $4B74
    ld de, $9000                                  ; $4B77
    ld bc, $0800                                  ; $4B7A
    call Mem_CopyFromBank                         ; $4B7D
    ld a, BANK(Gfx_1C_6660_Link_ShowScreenA)      ; $4B80
    ld hl, Gfx_1C_6660_Link_ShowScreenA           ; $4B82
    ld de, $8800                                  ; $4B85
    ld bc, $0700                                  ; $4B88
    call Mem_CopyFromBank                         ; $4B8B
    ld a, BANK(Gfx_1C_6D50_Link_ShowScreenB)      ; $4B8E
    ld hl, Gfx_1C_6D50_Link_ShowScreenB           ; $4B90
    ld de, $8ff0                                  ; $4B93
    ld bc, $0010                                  ; $4B96
    call Mem_CopyFromBank                         ; $4B99
    ld a, BANK(Map_26_6540_Link_ShowScreenB)      ; $4B9C
    ld hl, Map_26_6540_Link_ShowScreenB           ; $4B9E
    ld de, $9800                                  ; $4BA1
    ld bc, $0240                                  ; $4BA4
    call Mem_CopyFromBank                         ; $4BA7
    call Oam_ClearShadow                          ; $4BAA
    call Pal_AllWhite                             ; $4BAD
    call Lcd_On                                   ; $4BB0
    call Pal_FadeIn                               ; $4BB3

jr_007_4bb6:
    rst Rst08_WaitVBlank                          ; $4BB6
    ldh a, [hKeysNew]                             ; $4BB7
    and a                                         ; $4BB9
    jr z, jr_007_4bb6                             ; $4BBA

    call Pal_FadeOut                              ; $4BBC
    call Lcd_Off                                  ; $4BBF
    ret                                           ; $4BC2


; I: UNREFERENCED
Unused_Link_LoadTiles::
    ld a, BANK(Gfx_24_57E0_Unused_Link_LoadTiles) ; $4BC3
    ld hl, Gfx_24_57E0_Unused_Link_LoadTiles      ; $4BC5
    ld de, $8ef0                                  ; $4BC8
    ld bc, $0100                                  ; $4BCB
    call Mem_CopyFromBank                         ; $4BCE
    ld hl, $9a30                                  ; $4BD1
    ld a, [wUnusedLinkBufSum]                     ; $4BD4
    call Unused_Link_WriteHexByte                 ; $4BD7
    ld a, [wUnusedLinkBufXor]                     ; $4BDA

; I: UNREFERENCED
Unused_Link_WriteHexByte::
    push af                                       ; $4BDD
    swap a                                        ; $4BDE
    call Unused_Link_WriteHexNibble               ; $4BE0
    pop af                                        ; $4BE3

; I: UNREFERENCED
Unused_Link_WriteHexNibble::
    and $0f                                       ; $4BE4
    add $ef                                       ; $4BE6
    ld [hl+], a                                   ; $4BE8
    ret                                           ; $4BE9


; I: UNREFERENCED: 16-bit sum of the $1000 byte buffer
Unused_Link_SumSlotBuffer::
    ld hl, wPhotoImage                            ; $4BEA
    ld bc, $1000                                  ; $4BED
    ld de, $0000                                  ; $4BF0

jr_007_4bf3:
    ld a, d                                       ; $4BF3
    add [hl]                                      ; $4BF4
    ld d, a                                       ; $4BF5
    ld a, e                                       ; $4BF6
    xor [hl]                                      ; $4BF7
    ld e, a                                       ; $4BF8
    dec bc                                        ; $4BF9
    ld a, b                                       ; $4BFA
    or c                                          ; $4BFB
    inc hl                                        ; $4BFC
    jr nz, jr_007_4bf3                            ; $4BFD

    ld a, e                                       ; $4BFF
    ld [wUnusedLinkBufXor], a                     ; $4C00
    ld a, d                                       ; $4C03
    ld [wUnusedLinkBufSum], a                     ; $4C04
    ret                                           ; $4C07


; C: photo choose dialog (3 substates)
LinkPick_Far::
    ld a, [wSubstate]                             ; $4C08
    rst Rst18_JumpTable                           ; $4C0B

; C
LinkPick_SubstateTbl::
    dw LinkPick_Substate0_Init
    dw LinkPick_Substate1_Browse
    dw LinkPick_Substate2_Exit

; C
LinkPick_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4C12
    ldh [hLcdcShadow], a                          ; $4C14
    ld a, $e4                                     ; $4C16
    ld [wPaletteTarget], a                        ; $4C18
    ld [wPaletteTarget + $1], a                   ; $4C1B
    ld a, $d2                                     ; $4C1E
    ld [wPaletteTarget + $2], a                   ; $4C20
    xor a                                         ; $4C23
    ldh [hScxShadow], a                           ; $4C24
    ldh [hScyShadow], a                           ; $4C26
    ldh [hScxBand1], a                            ; $4C28
    ldh [hScyBand1], a                            ; $4C2A
    ld [wLinkCancelLatch], a                      ; $4C2C
    ld hl, $9000                                  ; $4C2F
    ld bc, $0800                                  ; $4C32
    call Mem_Zero                                 ; $4C35
    ld a, BANK(Gfx_13_5800_Mode0F_State00_Init)   ; $4C38
    ld hl, Gfx_13_5800_Mode0F_State00_Init        ; $4C3A
    ld de, $8000                                  ; $4C3D
    ld bc, $1000                                  ; $4C40
    call Mem_CopyFromBank                         ; $4C43
    ld a, BANK(Map_24_54C0_Mode0F_State00_Init)   ; $4C46
    ld hl, Map_24_54C0_Mode0F_State00_Init        ; $4C48
    ld de, $9800                                  ; $4C4B
    ld bc, $0240                                  ; $4C4E
    call Mem_CopyFromBank                         ; $4C51
    ld hl, $8ff0                                  ; $4C54
    ld a, $ff                                     ; $4C57
    ld b, $04                                     ; $4C59

jr_007_4c5b:
    ld [hl+], a                                   ; $4C5B
    ld [hl+], a                                   ; $4C5C
    ld [hl+], a                                   ; $4C5D
    ld [hl+], a                                   ; $4C5E
    dec b                                         ; $4C5F
    jr nz, jr_007_4c5b                            ; $4C60

    ld hl, $9be0                                  ; $4C62
    ld a, $ff                                     ; $4C65
    ld b, $08                                     ; $4C67

jr_007_4c69:
    ld [hl+], a                                   ; $4C69
    ld [hl+], a                                   ; $4C6A
    ld [hl+], a                                   ; $4C6B
    ld [hl+], a                                   ; $4C6C
    dec b                                         ; $4C6D
    jr nz, jr_007_4c69                            ; $4C6E

    call LinkPick_SetBrowseLimit                  ; $4C70
    call Oam_ClearShadow                          ; $4C73
    call Pal_AllWhite                             ; $4C76
    call Lcd_On                                   ; $4C79
    push af                                       ; $4C7C
    ld a, MUSIC_PHOTO_PICKER                      ; $4C7D
    call Snd_Music                                ; $4C7F
    pop af                                        ; $4C82
    call Pal_FadeIn                               ; $4C83
    ld a, [wPhotoIndex]                           ; $4C86
    cp $1e                                        ; $4C89
    jr c, jr_007_4c91                             ; $4C8B

    xor a                                         ; $4C8D
    ld [wPhotoIndex], a                           ; $4C8E

jr_007_4c91:
    ld a, [wPhotoIndex]                           ; $4C91
    call LinkPick_RequestRemotePage               ; $4C94
    ld a, [wPhotoIndex]                           ; $4C97
    call LinkPick_LoadPageThumbs                  ; $4C9A
    call LinkPick_NoPhotoHere                     ; $4C9D
    jr c, jr_007_4ccb                             ; $4CA0

    ld a, $11                                     ; $4CA2
    ld [wCursorSpriteVar], a                      ; $4CA4
    call LinkPick_DrawCursor                      ; $4CA7
    call Oam_HideUnused                           ; $4CAA
    rst Rst08_WaitVBlank                          ; $4CAD
    call LinkPick_LoadBigThumb                    ; $4CAE
    xor a                                         ; $4CB1
    ld [wCursorSpriteVar], a                      ; $4CB2
    call LinkPick_DrawCursor                      ; $4CB5
    call Oam_HideUnused                           ; $4CB8
    ld bc, $0004                                  ; $4CBB
    call Wait_Frames                              ; $4CBE
    call LinkPick_ClearThumbSlot                  ; $4CC1
    ld a, $01                                     ; $4CC4
    ld [wCursorSpriteVar], a                      ; $4CC6
    jr jr_007_4cd0                                ; $4CC9

jr_007_4ccb:
    ld a, $11                                     ; $4CCB
    ld [wCursorSpriteVar], a                      ; $4CCD

jr_007_4cd0:
    call LinkPick_DrawCursor                      ; $4CD0
    call LinkPick_LoadPhotoIndex                  ; $4CD3
    call LinkPick_LoadMessageStrip                ; $4CD6
    call LinkPick_LoadIcon                        ; $4CD9
    call LinkPick_DrawCursor                      ; $4CDC
    ld hl, wSubstate                              ; $4CDF
    inc [hl]                                      ; $4CE2
    jp Far_Call_Return                            ; $4CE3


; C: number of photos that can be chosen
LinkPick_SetBrowseLimit::
    ld a, [wLnkRoleRx]                            ; $4CE6
    and a                                         ; $4CE9
    jr nz, jr_007_4cf5                            ; $4CEA

    ld a, [wLnkOwnCount]                          ; $4CEC
    res 7, a                                      ; $4CEF
    ld [wLinkPickCount], a                        ; $4CF1
    ret                                           ; $4CF4


jr_007_4cf5:
    ld a, [wLnkPeerCount]                         ; $4CF5
    ld [wLinkPickCount], a                        ; $4CF8
    ret                                           ; $4CFB


; C
LinkPick_Substate1_Browse::
    ld a, [wLinkCancelLatch]                      ; $4CFC
    and a                                         ; $4CFF
    jr z, jr_007_4d18                             ; $4D00

    ld a, [wLnkCmdRx]                             ; $4D02
    cp $ef                                        ; $4D05
    jr nz, jr_007_4d55                            ; $4D07

    ld a, $02                                     ; $4D09
    ld [wAbResult], a                             ; $4D0B
    call LinkPick_DrawCursor                      ; $4D0E
    ld hl, wSubstate                              ; $4D11
    inc [hl]                                      ; $4D14
    jp Far_Call_Return                            ; $4D15


jr_007_4d18:
    ldh a, [hKeysNew]                             ; $4D18
    cp PADF_B                                     ; $4D1A
    jr nz, jr_007_4d36                            ; $4D1C

    push af                                       ; $4D1E
    ld a, SFX1_KEY_B                              ; $4D1F
    call Snd_Sfx1                                 ; $4D21
    pop af                                        ; $4D24
    ld a, $ef                                     ; $4D25
    ld [wLnkCmdTx], a                             ; $4D27
    ld [wLinkCancelLatch], a                      ; $4D2A
    call Link_QueueCommand                        ; $4D2D
    call LinkPick_DrawCursor                      ; $4D30
    jp Far_Call_Return                            ; $4D33


jr_007_4d36:
    ldh a, [hKeysNew]                             ; $4D36
    cp PADF_A                                     ; $4D38
    jr nz, jr_007_4d55                            ; $4D3A

    ld [wAbResult], a                             ; $4D3C
    call LinkPick_NoPhotoHere                     ; $4D3F
    jr c, jr_007_4d55                             ; $4D42

    push af                                       ; $4D44
    ld a, SFX1_PICK_PHOTO                         ; $4D45
    call Snd_Sfx1                                 ; $4D47
    pop af                                        ; $4D4A
    call LinkPick_DrawCursor                      ; $4D4B
    ld hl, wSubstate                              ; $4D4E
    inc [hl]                                      ; $4D51
    jp Far_Call_Return                            ; $4D52


jr_007_4d55:
    call LinkPick_DrawCursor                      ; $4D55
    call LinkPick_Navigate                        ; $4D58
    jp Far_Call_Return                            ; $4D5B


; C
LinkPick_Substate2_Exit::
    ld a, [wAbResult]                             ; $4D5E
    and $01                                       ; $4D61
    jr nz, jr_007_4d72                            ; $4D63

    call Pal_FadeOut                              ; $4D65
    call Lcd_Off                                  ; $4D68
    ld hl, wState                                 ; $4D6B
    inc [hl]                                      ; $4D6E
    jp Far_Call_Return                            ; $4D6F


jr_007_4d72:
    ld b, $04                                     ; $4D72

jr_007_4d74:
    ld c, $09                                     ; $4D74

jr_007_4d76:
    push bc                                       ; $4D76
    call LinkPick_DrawCursor                      ; $4D77
    call Oam_HideUnused                           ; $4D7A
    rst Rst08_WaitVBlank                          ; $4D7D
    pop bc                                        ; $4D7E
    dec c                                         ; $4D7F
    jr nz, jr_007_4d76                            ; $4D80

    ld hl, wCursorSpriteVar                       ; $4D82
    inc [hl]                                      ; $4D85
    dec b                                         ; $4D86
    jr nz, jr_007_4d74                            ; $4D87

    call Pal_FadeOut                              ; $4D89
    call Lcd_Off                                  ; $4D8C
    ld hl, wState                                 ; $4D8F
    inc [hl]                                      ; $4D92
    jp Far_Call_Return                            ; $4D93


; C
LinkPick_DrawCursor::
    ld a, [wPhotoIndex]                           ; $4D96
    and $07                                       ; $4D99
    sla a                                         ; $4D9B
    ld e, a                                       ; $4D9D
    ld d, $00                                     ; $4D9E
    ld hl, LinkPick_DrawCursor_Tbl4DB0            ; $4DA0
    add hl, de                                    ; $4DA3
    ld b, [hl]                                    ; $4DA4
    inc hl                                        ; $4DA5
    ld c, [hl]                                    ; $4DA6
    ld a, [wCursorSpriteVar]                      ; $4DA7
    add $0f                                       ; $4DAA
    call Oam_AddMeta_B01_4000                     ; $4DAC
    ret                                           ; $4DAF


; C: auto: 16 bytes, bytes; referenced by LinkPick_DrawCursor. L3 pass 2026-10-26: read in BGB in the scenarios
; link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_DrawCursor_Tbl4DB0::
    db $48, $18, $70, $18, $20, $40, $48, $40, $70, $40, $20, $68, $48, $68, $70, $68

; C: D-pad moves in the page; page turns
LinkPick_Navigate::
    call LinkPick_ReadDirection                   ; $4DC0
    ret z                                         ; $4DC3

    dec a                                         ; $4DC4
    ld c, a                                       ; $4DC5
    ld a, [wPhotoIndex]                           ; $4DC6
    and $3f                                       ; $4DC9
    sla a                                         ; $4DCB
    sla a                                         ; $4DCD
    add c                                         ; $4DCF
    ld e, a                                       ; $4DD0
    ld d, $00                                     ; $4DD1
    ld hl, LinkPick_Navigate_Tbl4E5D              ; $4DD3
    add hl, de                                    ; $4DD6
    ld a, [hl]                                    ; $4DD7
    cp $ff                                        ; $4DD8
    ret z                                         ; $4DDA

    ld [wPickerCursorTarget], a                   ; $4DDB
    call Oam_HideUnused                           ; $4DDE
    rst Rst08_WaitVBlank                          ; $4DE1
    call LinkPick_NoPhotoHere                     ; $4DE2
    jr c, jr_007_4e01                             ; $4DE5

    xor a                                         ; $4DE7
    ld [wCursorSpriteVar], a                      ; $4DE8
    call LinkPick_DrawCursor                      ; $4DEB
    call Oam_HideUnused                           ; $4DEE
    call LinkPick_LoadThumbOfCursor               ; $4DF1
    rst Rst08_WaitVBlank                          ; $4DF4
    ld a, $11                                     ; $4DF5
    ld [wCursorSpriteVar], a                      ; $4DF7
    call LinkPick_DrawCursor                      ; $4DFA
    call Oam_HideUnused                           ; $4DFD
    rst Rst08_WaitVBlank                          ; $4E00

jr_007_4e01:
    ld hl, wPickerCursorTarget                    ; $4E01
    bit 7, [hl]                                   ; $4E04
    jr z, jr_007_4e1a                             ; $4E06

    bit 6, [hl]                                   ; $4E08
    jr z, jr_007_4e14                             ; $4E0A

    call Oam_ClearShadow                          ; $4E0C
    call LinkPick_PageTurnNext                    ; $4E0F
    jr jr_007_4e1a                                ; $4E12

jr_007_4e14:
    call Oam_ClearShadow                          ; $4E14
    call LinkPick_PageTurnPrev                    ; $4E17

jr_007_4e1a:
    ld a, [wPickerCursorTarget]                   ; $4E1A
    and $3f                                       ; $4E1D
    ld [wPhotoIndex], a                           ; $4E1F
    call LinkPick_NoPhotoHere                     ; $4E22
    jr c, jr_007_4e51                             ; $4E25

    call LinkPick_LoadBigThumb                    ; $4E27
    rst Rst08_WaitVBlank                          ; $4E2A
    xor a                                         ; $4E2B
    ld [wCursorSpriteVar], a                      ; $4E2C
    call LinkPick_DrawCursor                      ; $4E2F
    call Oam_HideUnused                           ; $4E32
    ld bc, $0004                                  ; $4E35
    call Wait_Frames                              ; $4E38
    call LinkPick_ClearThumbSlot                  ; $4E3B
    ld a, $01                                     ; $4E3E
    ld [wCursorSpriteVar], a                      ; $4E40
    call LinkPick_DrawCursor                      ; $4E43
    call Oam_HideUnused                           ; $4E46
    rst Rst08_WaitVBlank                          ; $4E49
    call LinkPick_DrawCursor                      ; $4E4A
    call LinkPick_LoadPhotoIndex                  ; $4E4D
    ret                                           ; $4E50


jr_007_4e51:
    ld a, $11                                     ; $4E51
    ld [wCursorSpriteVar], a                      ; $4E53
    call LinkPick_DrawCursor                      ; $4E56
    call LinkPick_LoadPhotoIndex                  ; $4E59
    ret                                           ; $4E5C


; C: auto: 120 bytes, bytes; referenced by LinkPick_Navigate. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: the cursor graph of the link photo picker read by
; LinkPick_Navigate (120 bytes)
LinkPick_Navigate_Tbl4E5D::
    db $ff, $01, $ff, $03, $00, $c8, $ff, $04, $ff, $03, $00, $05, $02, $04, $00, $06
    db $03, $ca, $01, $07, $ff, $06, $02, $ff, $05, $07, $03, $ff, $06, $cd, $04, $ff
    db $81, $09, $ff, $0b, $08, $d0, $ff, $0c, $84, $0b, $08, $0d, $0a, $0c, $08, $0e
    db $0b, $d2, $09, $0f, $87, $0e, $0a, $ff, $0d, $0f, $0b, $ff, $0e, $d5, $0c, $ff
    db $89, $11, $ff, $13, $10, $d8, $ff, $14, $8c, $13, $10, $15, $12, $14, $10, $16
    db $13, $da, $11, $17, $8f, $16, $12, $ff, $15, $17, $13, $ff, $16, $dd, $14, $ff
    db $91, $19, $ff, $1b, $18, $ff, $ff, $1c, $94, $1b, $18, $1d, $1a, $1c, $18, $1d
    db $1b, $ff, $19, $1d, $97, $ff, $1a, $ff

; C
LinkPick_ReadDirection::
    ldh a, [hKeysNewRepeat]                       ; $4ED5
    bit PADB_LEFT, a                              ; $4ED7
    jr z, jr_007_4ee6                             ; $4ED9

    push af                                       ; $4EDB
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4EDC
    call Snd_Sfx1                                 ; $4EDE
    pop af                                        ; $4EE1
    ld a, $01                                     ; $4EE2
    jr jr_007_4f10                                ; $4EE4

jr_007_4ee6:
    bit 4, a                                      ; $4EE6
    jr z, jr_007_4ef5                             ; $4EE8

    push af                                       ; $4EEA
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4EEB
    call Snd_Sfx1                                 ; $4EED
    pop af                                        ; $4EF0
    ld a, $02                                     ; $4EF1
    jr jr_007_4f10                                ; $4EF3

jr_007_4ef5:
    bit 6, a                                      ; $4EF5
    jr z, jr_007_4f04                             ; $4EF7

    push af                                       ; $4EF9
    ld a, SFX1_KEY_UP_DOWN                        ; $4EFA
    call Snd_Sfx1                                 ; $4EFC
    pop af                                        ; $4EFF
    ld a, $03                                     ; $4F00
    jr jr_007_4f10                                ; $4F02

jr_007_4f04:
    bit 7, a                                      ; $4F04
    ret z                                         ; $4F06

    push af                                       ; $4F07
    ld a, SFX1_KEY_UP_DOWN                        ; $4F08
    call Snd_Sfx1                                 ; $4F0A
    pop af                                        ; $4F0D
    ld a, $04                                     ; $4F0E

jr_007_4f10:
    and a                                         ; $4F10
    ret                                           ; $4F11


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; copies the thumbnail of wPhotoIndex to its VRAM slot $9000 + (index & 7) x $100 (LinkPick_Navigate)
LinkPick_LoadThumbOfCursor::
    ld a, [wPhotoIndex]                           ; $4F12
    call LinkPick_ThumbBufferAddress              ; $4F15
    push af                                       ; $4F18
    ld a, [wPhotoIndex]                           ; $4F19
    and $07                                       ; $4F1C
    add $90                                       ; $4F1E
    ld d, a                                       ; $4F20
    ld e, $00                                     ; $4F21
    ld bc, $0100                                  ; $4F23
    pop af                                        ; $4F26
    call Vram_CopyFromBank                        ; $4F27
    ret                                           ; $4F2A


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadBigThumb::
    ld a, [wPhotoIndex]                           ; $4F2B
    call LinkPick_ThumbBufferAddress              ; $4F2E
    ld de, $8700                                  ; $4F31
    ld bc, $0100                                  ; $4F34
    call Vram_CopyFromBank                        ; $4F37
    ret                                           ; $4F3A


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_ClearThumbSlot::
    ld a, [wPhotoIndex]                           ; $4F3B
    and $07                                       ; $4F3E
    add $90                                       ; $4F40
    ld h, a                                       ; $4F42
    ld l, $00                                     ; $4F43
    xor a                                         ; $4F45
    ld bc, $0100                                  ; $4F46
    call Vram_FillViaVBlank                       ; $4F49
    ret                                           ; $4F4C


; C
LinkPick_LoadPageThumbs::
    ld de, $9000                                  ; $4F4D
    and $18                                       ; $4F50
    ld c, a                                       ; $4F52
    ld b, $08                                     ; $4F53

jr_007_4f55:
    push bc                                       ; $4F55
    push de                                       ; $4F56
    ld a, c                                       ; $4F57
    ld hl, wLinkPickCount                         ; $4F58
    cp [hl]                                       ; $4F5B
    jr c, jr_007_4f7a                             ; $4F5C

    cp $1e                                        ; $4F5E
    jr c, jr_007_4f6d                             ; $4F60

    ld l, e                                       ; $4F62
    ld h, d                                       ; $4F63
    xor a                                         ; $4F64
    ld bc, $0100                                  ; $4F65
    call Vram_FillViaVBlank                       ; $4F68
    jr jr_007_4f83                                ; $4F6B

jr_007_4f6d:
    ld a, BANK(Src_13_6400_PhotoPicker_LoadPageThumbs); $4F6D
    ld hl, Src_13_6400_PhotoPicker_LoadPageThumbs ; $4F6F
    ld bc, $0100                                  ; $4F72
    call Vram_CopyFromBank                        ; $4F75
    jr jr_007_4f83                                ; $4F78

jr_007_4f7a:
    call LinkPick_ThumbBufferAddress              ; $4F7A
    ld bc, $0100                                  ; $4F7D
    call Vram_CopyFromBank                        ; $4F80

jr_007_4f83:
    pop de                                        ; $4F83
    pop bc                                        ; $4F84
    inc d                                         ; $4F85
    inc c                                         ; $4F86
    dec b                                         ; $4F87
    jr nz, jr_007_4f55                            ; $4F88

    ret                                           ; $4F8A


; C
LinkPick_LoadMessageStrip::
    ld a, [wMsgStripSel]                          ; $4F8B
    ld e, a                                       ; $4F8E
    sla a                                         ; $4F8F
    add e                                         ; $4F91
    ld e, a                                       ; $4F92
    ld d, $00                                     ; $4F93
    ld hl, LinkPick_LoadMessageStrip_Gfx4FAA      ; $4F95
    add hl, de                                    ; $4F98
    ld e, [hl]                                    ; $4F99
    inc hl                                        ; $4F9A
    ld d, [hl]                                    ; $4F9B
    inc hl                                        ; $4F9C
    ld a, [hl]                                    ; $4F9D
    ld h, d                                       ; $4F9E
    ld l, e                                       ; $4F9F
    ld de, $8800                                  ; $4FA0
    ld bc, $0280                                  ; $4FA3
    call Vram_CopyFromBank                        ; $4FA6
    ret                                           ; $4FA9


; C: auto: 45 bytes, tile data; referenced by LinkPick_LoadMessageStrip. L3 pass 2026-10-26: read in BGB in the
; scenarios link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadMessageStrip_Gfx4FAA::
    db $00, $40, $0e, $80, $42, $0e, $00, $45, $0e, $80, $47, $0e, $00, $4a, $0e, $80
    db $4c, $0e, $00, $4f, $0e, $80, $51, $0e, $00, $54, $0e, $80, $56, $0e, $00, $59
    db $0e, $80, $5b, $0e, $00, $5e, $0e, $00, $5d, $0d, $80, $60, $0e

; C
LinkPick_LoadIcon::
    ld a, [wIconSel]                              ; $4FD7
    ld e, a                                       ; $4FDA
    sla a                                         ; $4FDB
    add e                                         ; $4FDD
    ld e, a                                       ; $4FDE
    ld d, $00                                     ; $4FDF
    ld hl, LinkPick_LoadIcon_Gfx4FF6              ; $4FE1
    add hl, de                                    ; $4FE4
    ld e, [hl]                                    ; $4FE5
    inc hl                                        ; $4FE6
    ld d, [hl]                                    ; $4FE7
    inc hl                                        ; $4FE8
    ld a, [hl]                                    ; $4FE9
    ld h, d                                       ; $4FEA
    ld l, e                                       ; $4FEB
    ld de, $8b00                                  ; $4FEC
    ld bc, $0100                                  ; $4FEF
    call Vram_CopyFromBank                        ; $4FF2
    ret                                           ; $4FF5


; C: auto: 21 bytes, tile data; referenced by LinkPick_LoadIcon. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: icon tiles copied by LinkPick_LoadIcon
LinkPick_LoadIcon_Gfx4FF6::
    dw Gfx_13_6800_Icon04_44DC
    db BANK(Gfx_13_6800_Icon04_44DC)
    dw Gfx_13_6900_Icon04_44DC
    db BANK(Gfx_13_6900_Icon04_44DC)
    dw Gfx_13_6A00_Icon04_44DC
    db BANK(Gfx_13_6A00_Icon04_44DC)

    db $00, $6b, $13

    dw Gfx_13_6C00_Icon04_44DC
    db BANK(Gfx_13_6C00_Icon04_44DC)
    dw Gfx_13_6D00_Icon04_44DC
    db BANK(Gfx_13_6D00_Icon04_44DC)
    dw Gfx_13_6E00_Icon04_44DC
    db BANK(Gfx_13_6E00_Icon04_44DC)

; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadPhotoIndex::
    ld a, [wPhotoIndex]                           ; $500B

; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_PageTilesRight::
    push af                                       ; $500E
    and $18                                       ; $500F
    sla a                                         ; $5011
    ld c, a                                       ; $5013
    ld b, $00                                     ; $5014
    ld hl, $5830                                  ; $5016
    add hl, bc                                    ; $5019
    ld a, $13                                     ; $501A
    ld de, $8df0                                  ; $501C
    ld bc, $0010                                  ; $501F
    call Vram_CopyFromBank                        ; $5022
    pop af                                        ; $5025
    and $20                                       ; $5026
    srl a                                         ; $5028
    ld c, a                                       ; $502A
    ld b, $00                                     ; $502B
    ld hl, $5800                                  ; $502D
    add hl, bc                                    ; $5030
    ld a, $13                                     ; $5031
    ld de, $8de0                                  ; $5033
    ld bc, $0010                                  ; $5036
    call Vram_CopyFromBank                        ; $5039
    ret                                           ; $503C


; I: entry of arbitrary address (README 16.14)
Unused_LinkPick_LoadPhotoIndexB::
    ld a, [wPhotoIndex]                           ; $503D

; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the two page-tab tiles of the left page from 13:5800 / 13:5830 (LinkPick_PageTurnNext / Prev)
LinkPick_PageTilesLeft::
    push af                                       ; $5040
    and $18                                       ; $5041
    sla a                                         ; $5043
    ld c, a                                       ; $5045
    ld b, $00                                     ; $5046
    ld hl, $5830                                  ; $5048
    add hl, bc                                    ; $504B
    ld a, $13                                     ; $504C
    ld de, $8ed0                                  ; $504E
    ld bc, $0010                                  ; $5051
    call Vram_CopyFromBank                        ; $5054
    pop af                                        ; $5057
    and $20                                       ; $5058
    srl a                                         ; $505A
    ld c, a                                       ; $505C
    ld b, $00                                     ; $505D
    ld hl, $5800                                  ; $505F
    add hl, bc                                    ; $5062
    ld a, $13                                     ; $5063
    ld de, $8ec0                                  ; $5065
    ld bc, $0010                                  ; $5068
    call Vram_CopyFromBank                        ; $506B
    ret                                           ; $506E


; C
LinkPick_PageTurnNext::
    ld a, [wPickerCursorTarget]                   ; $506F
    call LinkPick_PageTilesLeft                   ; $5072
    ld a, BANK(Map_27_4EB0_PhotoPicker_PageTransitionPrev); $5075
    ld hl, Map_27_4EB0_PhotoPicker_PageTransitionPrev; $5077
    ld de, $9840                                  ; $507A
    ld bc, $0200                                  ; $507D
    call Vram_CopyFromBank                        ; $5080
    rst Rst08_WaitVBlank                          ; $5083
    ld a, [wPickerCursorTarget]                   ; $5084
    call LinkPick_RequestRemotePage               ; $5087
    ld a, [wPickerCursorTarget]                   ; $508A
    call LinkPick_LoadPageThumbs                  ; $508D
    rst Rst08_WaitVBlank                          ; $5090
    ld a, BANK(Map_27_4CB0_PhotoPicker_PageTransitionPrev); $5091
    ld hl, Map_27_4CB0_PhotoPicker_PageTransitionPrev; $5093
    ld de, $9840                                  ; $5096
    ld bc, $0200                                  ; $5099
    call Vram_CopyFromBank                        ; $509C
    rst Rst08_WaitVBlank                          ; $509F
    ld a, BANK(Map_27_52B0_PhotoPicker_PageTransitionPrev); $50A0
    ld hl, Map_27_52B0_PhotoPicker_PageTransitionPrev; $50A2
    ld de, $9840                                  ; $50A5
    ld bc, $0200                                  ; $50A8
    call Vram_CopyFromBank                        ; $50AB
    rst Rst08_WaitVBlank                          ; $50AE
    ld a, BANK(Map_1E_7E00_PhotoPicker_PageTransitionPrev); $50AF
    ld hl, Map_1E_7E00_PhotoPicker_PageTransitionPrev; $50B1
    ld de, $9840                                  ; $50B4
    ld bc, $0200                                  ; $50B7
    call Vram_CopyFromBank                        ; $50BA
    rst Rst08_WaitVBlank                          ; $50BD
    ld a, BANK(Map_27_50B0_PhotoPicker_PageTransitionPrev); $50BE
    ld hl, Map_27_50B0_PhotoPicker_PageTransitionPrev; $50C0
    ld de, $9840                                  ; $50C3
    ld bc, $0200                                  ; $50C6
    call Vram_CopyFromBank                        ; $50C9
    rst Rst08_WaitVBlank                          ; $50CC
    ld a, [wPickerCursorTarget]                   ; $50CD
    call LinkPick_PageTilesRight                  ; $50D0
    ld a, BANK(Map_24_5500_PhotoPicker_PageTransitionPrev); $50D3
    ld hl, Map_24_5500_PhotoPicker_PageTransitionPrev; $50D5
    ld de, $9840                                  ; $50D8
    ld bc, $0200                                  ; $50DB
    call Vram_CopyFromBank                        ; $50DE
    rst Rst08_WaitVBlank                          ; $50E1
    ret                                           ; $50E2


; C
LinkPick_PageTurnPrev::
    ld a, [wPickerCursorTarget]                   ; $50E3
    call LinkPick_PageTilesLeft                   ; $50E6
    ld a, BANK(Map_27_50B0_PhotoPicker_PageTransitionPrev); $50E9
    ld hl, Map_27_50B0_PhotoPicker_PageTransitionPrev; $50EB
    ld de, $9840                                  ; $50EE
    ld bc, $0200                                  ; $50F1
    call Vram_CopyFromBank                        ; $50F4
    rst Rst08_WaitVBlank                          ; $50F7
    ld a, [wPickerCursorTarget]                   ; $50F8
    call LinkPick_PageTilesRight                  ; $50FB
    ld a, BANK(Map_1E_7E00_PhotoPicker_PageTransitionPrev); $50FE
    ld hl, Map_1E_7E00_PhotoPicker_PageTransitionPrev; $5100
    ld de, $9840                                  ; $5103
    ld bc, $0200                                  ; $5106
    call Vram_CopyFromBank                        ; $5109
    rst Rst08_WaitVBlank                          ; $510C
    ld a, BANK(Map_27_52B0_PhotoPicker_PageTransitionPrev); $510D
    ld hl, Map_27_52B0_PhotoPicker_PageTransitionPrev; $510F
    ld de, $9840                                  ; $5112
    ld bc, $0200                                  ; $5115
    call Vram_CopyFromBank                        ; $5118
    rst Rst08_WaitVBlank                          ; $511B
    ld a, BANK(Map_27_4CB0_PhotoPicker_PageTransitionPrev); $511C
    ld hl, Map_27_4CB0_PhotoPicker_PageTransitionPrev; $511E
    ld de, $9840                                  ; $5121
    ld bc, $0200                                  ; $5124
    call Vram_CopyFromBank                        ; $5127
    rst Rst08_WaitVBlank                          ; $512A
    ld a, BANK(Map_27_4EB0_PhotoPicker_PageTransitionPrev); $512B
    ld hl, Map_27_4EB0_PhotoPicker_PageTransitionPrev; $512D
    ld de, $9840                                  ; $5130
    ld bc, $0200                                  ; $5133
    call Vram_CopyFromBank                        ; $5136
    rst Rst08_WaitVBlank                          ; $5139
    ld a, [wPickerCursorTarget]                   ; $513A
    call LinkPick_RequestRemotePage               ; $513D
    ld a, [wPickerCursorTarget]                   ; $5140
    call LinkPick_LoadPageThumbs                  ; $5143
    rst Rst08_WaitVBlank                          ; $5146
    ld a, BANK(Map_24_5500_PhotoPicker_PageTransitionPrev); $5147
    ld hl, Map_24_5500_PhotoPicker_PageTransitionPrev; $5149
    ld de, $9840                                  ; $514C
    ld bc, $0200                                  ; $514F
    call Vram_CopyFromBank                        ; $5152
    rst Rst08_WaitVBlank                          ; $5155
    ret                                           ; $5156


; C: carry when photo_index >= link_pick_count
LinkPick_NoPhotoHere::
    ld a, [wPhotoIndex]                           ; $5157
    ld hl, wLinkPickCount                         ; $515A
    cp [hl]                                       ; $515D
    ccf                                           ; $515E
    ret                                           ; $515F


; C: H = $C0 + (A and 7). L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_ThumbBufferAddress::
    and $07                                       ; $5160
    add $c0                                       ; $5162
    ld h, a                                       ; $5164
    ld l, $00                                     ; $5165
    xor a                                         ; $5167
    ret                                           ; $5168


; C: asks the peer for a page of thumbnails (Link_QueuePageRequest)
LinkPick_RequestRemotePage::
    push af                                       ; $5169
    ld a, [wSavedDc52]                            ; $516A
    and a                                         ; $516D
    jr nz, jr_007_517c                            ; $516E

    pop af                                        ; $5170
    ldh [hFarcallAArg], a                         ; $5171
    ld a, BANK(Album_LoadThumbPage_Far)           ; $5173
    ld hl, Album_LoadThumbPage_Far                ; $5175
    call Far_Call                                 ; $5178
    ret                                           ; $517B


jr_007_517c:
    pop af                                        ; $517C
    srl a                                         ; $517D
    srl a                                         ; $517F
    srl a                                         ; $5181
    ld [wLnkSlot], a                              ; $5183
    call Link_QueuePageRequest                    ; $5186
    ld a, $b4                                     ; $5189
    ld [wLinkTimeout], a                          ; $518B
    xor a                                         ; $518E
    ld [wLinkTimeout + $1], a                     ; $518F

jr_007_5192:
    ldh [hFarcallAArg], a                         ; $5192
    ld a, $07                                     ; $5194
    ld hl, Link_TimeoutTick                       ; $5196
    call Far_Call                                 ; $5199
    jr nz, jr_007_51a4                            ; $519C

    ld a, STATE_0E_RESULT_PREPARE                 ; $519E
    ld [wState], a                                ; $51A0
    ret                                           ; $51A3


jr_007_51a4:
    rst Rst08_WaitVBlank                          ; $51A4
    ld a, [wLnkHalfDone]                          ; $51A5
    and a                                         ; $51A8
    jr z, jr_007_5192                             ; $51A9

    ret                                           ; $51AB


; C: mode 2 VIEW menu: Left/Right choice -> album grid (mode 0A) or slide-show menu (mode 0B)
Mode02_ViewMenu::
    ld a, [wState]                                ; $51AC
    rst Rst18_JumpTable                           ; $51AF

; C: 3 states, rst $18 table of mode $02
Mode02_StateTable::
    dw Mode02_State00_Init
    dw Mode02_State01_Choose
    dw Mode02_State02_Leave

; C
Mode02_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $51B6
    ldh [hLcdcShadow], a                          ; $51B8
    ld a, $e4                                     ; $51BA
    ld [wPaletteTarget], a                        ; $51BC
    ld [wPaletteTarget + $1], a                   ; $51BF
    ld a, $d2                                     ; $51C2
    ld [wPaletteTarget + $2], a                   ; $51C4
    xor a                                         ; $51C7
    ldh [hScxShadow], a                           ; $51C8
    ldh [hScyShadow], a                           ; $51CA
    ld [wBgAnimFrame], a                          ; $51CC
    ld a, $07                                     ; $51CF
    ld [wBgAnimMask], a                           ; $51D1
    ld a, $13                                     ; $51D4
    ld hl, Gfx_13_4000_Mode02_State00_Init        ; $51D6
    ld de, $9000                                  ; $51D9
    ld bc, $0800                                  ; $51DC
    call Mem_CopyFromBank                         ; $51DF
    ld a, BANK(Gfx_13_4800_Mode02_State00_Init)   ; $51E2
    ld hl, Gfx_13_4800_Mode02_State00_Init        ; $51E4
    ld de, $8800                                  ; $51E7
    ld bc, $0800                                  ; $51EA
    call Mem_CopyFromBank                         ; $51ED
    ld a, BANK(Gfx_13_5000_Mode02_State00_Init)   ; $51F0
    ld hl, Gfx_13_5000_Mode02_State00_Init        ; $51F2
    ld de, $8000                                  ; $51F5
    ld bc, $0800                                  ; $51F8
    call Mem_CopyFromBank                         ; $51FB
    ld a, BANK(Map_26_5580_Mode02_State00_Init)   ; $51FE
    ld hl, Map_26_5580_Mode02_State00_Init        ; $5200
    ld de, $9800                                  ; $5203
    ld bc, $02c0                                  ; $5206
    call Mem_CopyFromBank                         ; $5209
    ld a, $50                                     ; $520C
    ldh [hLycShadowSplit1], a                     ; $520E
    ldh [hSplit2Line], a                          ; $5210
    ld hl, hStatShadow                            ; $5212
    set 6, [hl]                                   ; $5215
    ld hl, rIE                                    ; $5217
    set 1, [hl]                                   ; $521A
    ld a, $01                                     ; $521C
    ldh [hStatHandlerIndex], a                    ; $521E
    call Oam_ClearShadow                          ; $5220
    call Pal_AllWhite                             ; $5223
    call Lcd_On                                   ; $5226
    push af                                       ; $5229
    ld a, MUSIC_VIEW_MENU                         ; $522A
    call Snd_Music                                ; $522C
    pop af                                        ; $522F
    call Pal_FadeIn                               ; $5230
    ld hl, wState                                 ; $5233
    inc [hl]                                      ; $5236
    ret                                           ; $5237


; C
Mode02_State01_Choose::
    call ViewMenu_AnimateBackground               ; $5238
    call ViewMenu_ReadChoice                      ; $523B
    call ViewMenu_DrawCursor                      ; $523E
    ldh a, [hKeysNew]                             ; $5241
    and PADF_A | PADF_B                           ; $5243
    ret z                                         ; $5245

    ld [wAbResult], a                             ; $5246
    push af                                       ; $5249
    bit 0, a                                      ; $524A
    ld a, SFX1_CHOOSE_C                           ; $524C
    call nz, Snd_Sfx1                             ; $524E
    pop af                                        ; $5251
    push af                                       ; $5252
    bit 1, a                                      ; $5253
    ld a, SFX1_KEY_B                              ; $5255
    call nz, Snd_Sfx1                             ; $5257
    pop af                                        ; $525A
    ld hl, wState                                 ; $525B
    inc [hl]                                      ; $525E
    ret                                           ; $525F


; C: mode := table 07:52E5 [choice]
Mode02_State02_Leave::
    ld a, [wAbResult]                             ; $5260
    bit 0, a                                      ; $5263
    jr nz, jr_007_5282                            ; $5265

    call Pal_FadeOut                              ; $5267
    call Lcd_Off                                  ; $526A
    ld hl, hStatShadow                            ; $526D
    res 6, [hl]                                   ; $5270
    ld hl, rIE                                    ; $5272
    res 1, [hl]                                   ; $5275
    ld a, MODE_MAIN_MENU                          ; $5277
    ld [wMode], a                                 ; $5279
    ld a, STATE_00_INIT                           ; $527C
    ld [wState], a                                ; $527E
    ret                                           ; $5281


jr_007_5282:
    ld a, [wYesnoH]                               ; $5282
    ld e, a                                       ; $5285
    ld d, $00                                     ; $5286
    ld hl, ViewMenu_TargetModeTbl                 ; $5288
    add hl, de                                    ; $528B
    ld a, [hl]                                    ; $528C
    cp MODE_NONE                                  ; $528D
    jr nz, jr_007_5296                            ; $528F

    ld hl, wState                                 ; $5291
    dec [hl]                                      ; $5294
    ret                                           ; $5295


jr_007_5296:
    ld [wMode], a                                 ; $5296
    ld a, STATE_02_INIT                           ; $5299
    ld [wState], a                                ; $529B
    ld b, $18                                     ; $529E

jr_007_52a0:
    push bc                                       ; $52A0
    call ViewMenu_DrawCursorOnce                  ; $52A1
    ld a, [wYesnoH]                               ; $52A4
    and a                                         ; $52A7
    jr nz, jr_007_52bc                            ; $52A8

    ld a, $fc                                     ; $52AA
    ld hl, $98e1                                  ; $52AC
    call Vram_WriteByteSafe                       ; $52AF
    ld a, $fd                                     ; $52B2
    ld hl, $98e2                                  ; $52B4
    call Vram_WriteByteSafe                       ; $52B7
    jr jr_007_52cc                                ; $52BA

jr_007_52bc:
    ld a, $fc                                     ; $52BC
    ld hl, $98f1                                  ; $52BE
    call Vram_WriteByteSafe                       ; $52C1
    ld a, $fd                                     ; $52C4
    ld hl, $98f2                                  ; $52C6
    call Vram_WriteByteSafe                       ; $52C9

jr_007_52cc:
    call Oam_HideUnused                           ; $52CC
    rst Rst08_WaitVBlank                          ; $52CF
    pop bc                                        ; $52D0
    dec b                                         ; $52D1
    jr nz, jr_007_52a0                            ; $52D2

    call Pal_FadeOut                              ; $52D4
    call Lcd_Off                                  ; $52D7
    ld hl, hStatShadow                            ; $52DA
    res 6, [hl]                                   ; $52DD
    ld hl, rIE                                    ; $52DF
    res 1, [hl]                                   ; $52E2
    ret                                           ; $52E4


; C: $0A; $0B
ViewMenu_TargetModeTbl::
    db MODE_ALBUM_VIEW, MODE_SHOW_MENU

; C: Left/Right toggles D5EC
ViewMenu_ReadChoice::
    ldh a, [hKeysNew]                             ; $52E7
    bit PADB_LEFT, a                              ; $52E9
    jr z, jr_007_52f0                             ; $52EB

    xor a                                         ; $52ED
    jr jr_007_52f6                                ; $52EE

jr_007_52f0:
    bit 4, a                                      ; $52F0
    jr z, jr_007_5304                             ; $52F2

    ld a, $01                                     ; $52F4

jr_007_52f6:
    ld hl, wYesnoH                                ; $52F6
    cp [hl]                                       ; $52F9
    jr z, jr_007_5304                             ; $52FA

    ld [hl], a                                    ; $52FC
    push af                                       ; $52FD
    ld a, SFX1_CURSOR_MOVE                        ; $52FE
    call Snd_Sfx1                                 ; $5300
    pop af                                        ; $5303

jr_007_5304:
    ldh a, [hKeysHeld]                            ; $5304
    ld b, a                                       ; $5306
    ld a, $07                                     ; $5307
    bit 6, b                                      ; $5309
    jr z, jr_007_5311                             ; $530B

    ld a, $03                                     ; $530D
    jr jr_007_5317                                ; $530F

jr_007_5311:
    bit 7, b                                      ; $5311
    jr z, jr_007_5317                             ; $5313

    ld a, $0f                                     ; $5315

jr_007_5317:
    ld [wBgAnimMask], a                           ; $5317
    ret                                           ; $531A


; C
ViewMenu_DrawCursor::
    ld a, [wYesnoH]                               ; $531B
    sla a                                         ; $531E
    ld c, a                                       ; $5320
    ld b, $00                                     ; $5321
    ld hl, ViewMenu_DrawCursor_Tbl5340            ; $5323
    add hl, bc                                    ; $5326
    ld c, [hl]                                    ; $5327
    inc hl                                        ; $5328
    ld b, [hl]                                    ; $5329
    ldh a, [hFrameCounter]                        ; $532A
    srl a                                         ; $532C
    srl a                                         ; $532E
    srl a                                         ; $5330
    and $03                                       ; $5332
    ld e, a                                       ; $5334
    ld d, $00                                     ; $5335
    ld hl, ViewMenu_DrawCursor_PtrTbl5344         ; $5337
    add hl, de                                    ; $533A
    ld a, [hl]                                    ; $533B
    call Oam_AddMeta_B02_5272                     ; $533C
    ret                                           ; $533F


; C: auto: 4 bytes, bytes; referenced by ViewMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the
; organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursor_Tbl5340::
    db $54, $09, $54, $89

; C: auto: 4 bytes, word table; referenced by ViewMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 35 replay(s) of
; the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursor_PtrTbl5344::
    dw $7577
    dw $7578

; C: L3 pass 2026-10-26: executed in BGB in 33 replay(s) of the organic corpus, modes 0A (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursorOnce::
    ld a, [wYesnoH]                               ; $5348
    sla a                                         ; $534B
    ld c, a                                       ; $534D
    ld b, $00                                     ; $534E
    ld hl, ViewMenu_DrawCursorOnce_Tbl5365        ; $5350
    add hl, bc                                    ; $5353
    ld c, [hl]                                    ; $5354
    inc hl                                        ; $5355
    ld b, [hl]                                    ; $5356
    ld a, $76                                     ; $5357
    call Oam_AddMeta_B02_5272                     ; $5359
    dec b                                         ; $535C
    ld c, $50                                     ; $535D
    ld a, $79                                     ; $535F
    call Oam_AddMeta_B02_5272                     ; $5361
    ret                                           ; $5364


; C: auto: 4 bytes, bytes; referenced by ViewMenu_DrawCursorOnce. L3 pass 2026-10-26: read in BGB in 33 replay(s) of
; the organic corpus, modes 0A (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursorOnce_Tbl5365::
    db $53, $09, $53, $89

; C: speed set at 07:5304 from Up/Down (README 16.18)
ViewMenu_AnimateBackground::
    ldh a, [hFrameCounter]                        ; $5369
    ld hl, wBgAnimMask                            ; $536B
    and [hl]                                      ; $536E
    ret nz                                        ; $536F

    ld a, [wYesnoH]                               ; $5370
    and a                                         ; $5373
    jr nz, jr_007_5381                            ; $5374

    ld a, [wBgAnimFrame]                          ; $5376
    inc a                                         ; $5379
    and $07                                       ; $537A
    ld [wBgAnimFrame], a                          ; $537C
    jr jr_007_538a                                ; $537F

jr_007_5381:
    ld a, [wBgAnimFrame]                          ; $5381
    dec a                                         ; $5384
    and $07                                       ; $5385
    ld [wBgAnimFrame], a                          ; $5387

jr_007_538a:
    ld c, a                                       ; $538A
    sla a                                         ; $538B
    add c                                         ; $538D
    ld c, a                                       ; $538E
    ld b, $00                                     ; $538F
    ld hl, ViewMenu_AnimateBackground_Map53A6     ; $5391
    add hl, bc                                    ; $5394
    ld c, [hl]                                    ; $5395
    inc hl                                        ; $5396
    ld b, [hl]                                    ; $5397
    inc hl                                        ; $5398
    ld a, [hl]                                    ; $5399
    ld h, b                                       ; $539A
    ld l, c                                       ; $539B
    ld de, $9840                                  ; $539C
    ld bc, $0180                                  ; $539F
    call Vram_CopyFromBank                        ; $53A2
    ret                                           ; $53A5


; C: auto: 24 bytes, tile map; referenced by ViewMenu_AnimateBackground. L3 pass 2026-10-26: read in BGB in 35
; replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_AnimateBackground_Map53A6::
    dw Src_26_55C0_Tbl53A6_0
    db BANK(Src_26_55C0_Tbl53A6_0)
    dw Src_27_63F0_Tbl53A6_1
    db BANK(Src_27_63F0_Tbl53A6_1)
    dw Src_27_6570_Tbl53A6_2
    db BANK(Src_27_6570_Tbl53A6_2)
    dw Src_23_7E80_Tbl53A6_3
    db BANK(Src_23_7E80_Tbl53A6_3)
    dw Src_19_7E60_Tbl53A6_4
    db BANK(Src_19_7E60_Tbl53A6_4)
    dw Src_27_66F0_Tbl53A6_5
    db BANK(Src_27_66F0_Tbl53A6_5)
    dw Src_27_6270_Tbl53A6_6
    db BANK(Src_27_6270_Tbl53A6_6)
    dw Src_27_60F0_Tbl53A6_7
    db BANK(Src_27_60F0_Tbl53A6_7)

; C: mode 3 Special menu: vertical 2-way choice -> mode 1A or 17
Mode03_SpecialMenu::
    ld a, [wState]                                ; $53BE
    rst Rst18_JumpTable                           ; $53C1

; C: 3 states, rst $18 table of mode $03
Mode03_StateTable::
    dw Mode03_State00_Init
    dw Mode03_State01_Choose
    dw Mode03_State02_Leave

; C
Mode03_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $53C8
    ldh [hLcdcShadow], a                          ; $53CA
    ld a, $e4                                     ; $53CC
    ld [wPaletteTarget], a                        ; $53CE
    ld a, $d2                                     ; $53D1
    ld [wPaletteTarget + $1], a                   ; $53D3
    ld [wPaletteTarget + $2], a                   ; $53D6
    xor a                                         ; $53D9
    ldh [hScxShadow], a                           ; $53DA
    ldh [hScyShadow], a                           ; $53DC
    ld a, BANK(Gfx_12_7000_Mode03_State00_Init)   ; $53DE
    ld hl, Gfx_12_7000_Mode03_State00_Init        ; $53E0
    ld de, $9000                                  ; $53E3
    ld bc, $0800                                  ; $53E6
    call Mem_CopyFromBank                         ; $53E9
    ld a, BANK(Gfx_12_7800_Mode03_State00_Init)   ; $53EC
    ld hl, Gfx_12_7800_Mode03_State00_Init        ; $53EE
    ld de, $8800                                  ; $53F1
    ld bc, $0780                                  ; $53F4
    call Mem_CopyFromBank                         ; $53F7
    ld a, BANK(Map_23_64C0_Mode03_State00_Init)   ; $53FA
    ld hl, Map_23_64C0_Mode03_State00_Init        ; $53FC
    ld de, $9800                                  ; $53FF
    ld bc, $0240                                  ; $5402
    call Mem_CopyFromBank                         ; $5405
    call Oam_ClearShadow                          ; $5408
    call Pal_AllWhite                             ; $540B
    call Lcd_On                                   ; $540E
    push af                                       ; $5411
    ld a, MUSIC_SPECIAL_MENU                      ; $5412
    call Snd_Music                                ; $5414
    pop af                                        ; $5417
    call SpecialMenu_DrawCursor                   ; $5418
    call Pal_FadeIn                               ; $541B
    ld hl, wState                                 ; $541E
    inc [hl]                                      ; $5421
    ret                                           ; $5422


; C
Mode03_State01_Choose::
    call SpecialMenu_ReadChoice                   ; $5423
    ldh a, [hFrameCounter]                        ; $5426
    bit 4, a                                      ; $5428
    call SpecialMenu_DrawCursor                   ; $542A
    ldh a, [hKeysNew]                             ; $542D
    and PADF_A | PADF_B                           ; $542F
    ret z                                         ; $5431

    ld [wAbResult], a                             ; $5432
    push af                                       ; $5435
    bit 0, a                                      ; $5436
    ld a, SFX1_CHOOSE                             ; $5438
    call nz, Snd_Sfx1                             ; $543A
    pop af                                        ; $543D
    push af                                       ; $543E
    bit 1, a                                      ; $543F
    ld a, SFX1_KEY_B                              ; $5441
    call nz, Snd_Sfx1                             ; $5443
    pop af                                        ; $5446
    ld hl, wState                                 ; $5447
    inc [hl]                                      ; $544A
    ret                                           ; $544B


; C
Mode03_State02_Leave::
    ld a, [wAbResult]                             ; $544C
    bit 0, a                                      ; $544F
    jr nz, jr_007_5464                            ; $5451

    ld a, MODE_MAIN_MENU                          ; $5453
    ld [wMode], a                                 ; $5455
    ld a, STATE_00_INIT                           ; $5458
    ld [wState], a                                ; $545A
    call Pal_FadeOut                              ; $545D
    call Lcd_Off                                  ; $5460
    ret                                           ; $5463


jr_007_5464:
    ld a, [wYesnoV7]                              ; $5464
    ld e, a                                       ; $5467
    ld d, $00                                     ; $5468
    ld hl, SpecialMenu_TargetModeTbl              ; $546A
    add hl, de                                    ; $546D
    ld a, [hl]                                    ; $546E
    cp MODE_NONE                                  ; $546F
    jr nz, jr_007_5478                            ; $5471

    ld hl, wState                                 ; $5473
    dec [hl]                                      ; $5476
    ret                                           ; $5477


jr_007_5478:
    ld [wMode], a                                 ; $5478
    xor a                                         ; $547B
    ld [wState], a                                ; $547C
    ld b, $14                                     ; $547F

jr_007_5481:
    push bc                                       ; $5481
    ldh a, [hFrameCounter]                        ; $5482
    bit 2, a                                      ; $5484
    call SpecialMenu_DrawCursor                   ; $5486
    rst Rst08_WaitVBlank                          ; $5489
    pop bc                                        ; $548A
    dec b                                         ; $548B
    jr nz, jr_007_5481                            ; $548C

    call Pal_FadeOut                              ; $548E
    call Lcd_Off                                  ; $5491
    ret                                           ; $5494


; C: $1A; $17
SpecialMenu_TargetModeTbl::
    db MODE_HOT_SPOT_EDITOR, MODE_SPLIT_FUSION

; C: Up/Down toggles D5FE
SpecialMenu_ReadChoice::
    ldh a, [hKeysNewRepeat]                       ; $5497
    ld b, a                                       ; $5499
    ld a, [wYesnoV7]                              ; $549A
    bit 6, b                                      ; $549D
    jr z, jr_007_54a6                             ; $549F

    and a                                         ; $54A1
    ret z                                         ; $54A2

    dec a                                         ; $54A3
    jr jr_007_54ad                                ; $54A4

jr_007_54a6:
    bit 7, b                                      ; $54A6
    ret z                                         ; $54A8

    cp $01                                        ; $54A9
    ret z                                         ; $54AB

    inc a                                         ; $54AC

jr_007_54ad:
    ld [wYesnoV7], a                              ; $54AD
    push af                                       ; $54B0
    ld a, SFX1_CURSOR_MOVE                        ; $54B1
    call Snd_Sfx1                                 ; $54B3
    pop af                                        ; $54B6
    ret                                           ; $54B7


; C
SpecialMenu_DrawCursor::
    jr z, jr_007_54c9                             ; $54B8

    ld a, BANK(Map_23_67E0_SpecialMenu_DrawCursor); $54BA
    ld hl, Map_23_67E0_SpecialMenu_DrawCursor     ; $54BC
    ld de, $9820                                  ; $54BF
    ld bc, $00e0                                  ; $54C2
    call Vram_CopyFromBank                        ; $54C5
    ret                                           ; $54C8


jr_007_54c9:
    ld a, [wYesnoV7]                              ; $54C9
    and a                                         ; $54CC
    jr nz, jr_007_54de                            ; $54CD

    ld a, BANK(Map_23_64E0_SpecialMenu_DrawCursor); $54CF
    ld hl, Map_23_64E0_SpecialMenu_DrawCursor     ; $54D1
    ld de, $9820                                  ; $54D4
    ld bc, $00e0                                  ; $54D7
    call Vram_CopyFromBank                        ; $54DA
    ret                                           ; $54DD


jr_007_54de:
    ld a, BANK(Map_23_6700_SpecialMenu_DrawCursor); $54DE
    ld hl, Map_23_6700_SpecialMenu_DrawCursor     ; $54E0
    ld de, $9820                                  ; $54E3
    ld bc, $00e0                                  ; $54E6
    call Vram_CopyFromBank                        ; $54E9
    ret                                           ; $54EC


; C: mode 7: Space Fever II (README 2.7)
Mode07_ArcadeSpaceFever::
    ld a, [wState]                                ; $54ED
    rst Rst18_JumpTable                           ; $54F0

; C: 9 states, rst $18 table of mode $07
Mode07_StateTable::
    dw Mode07_State00_Init
    dw Mode07_State01_Start
    dw Mode07_State02_Play
    dw Mode07_State03_TargetMenuA
    dw Mode07_State04_TargetMenuB
    dw Mode07_State05_GotoDj
    dw Mode07_State06_GotoBall
    dw Mode07_State07_GotoRun
    dw Mode07_State08_Leave

; C: score and wave reset; far call
Mode07_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $5503
    ldh [hLcdcShadow], a                          ; $5505
    ld a, $e4                                     ; $5507
    ld [wPaletteTarget], a                        ; $5509
    ld [wPaletteTarget + $1], a                   ; $550C
    ld [wPaletteTarget + $2], a                   ; $550F
    xor a                                         ; $5512
    ldh [hScxShadow], a                           ; $5513
    ldh [hScyShadow], a                           ; $5515
    ld [wShootScoreBcd], a                        ; $5517
    ld [wShootScoreBcd + $1], a                   ; $551A
    ld [wShootScoreBcd + $2], a                   ; $551D
    ld [wShootScoreBcd + $3], a                   ; $5520
    ld [wShootWaveState], a                       ; $5523
    ldh [hFarcallAArg], a                         ; $5526
    ld a, BANK(Counters_Load_Far)                 ; $5528
    ld hl, Counters_Load_Far                      ; $552A
    call Far_Call                                 ; $552D
    ld a, $21                                     ; $5530
    ld hl, Gfx_21_4000_Mode07_State00_Init        ; $5532
    ld de, $9000                                  ; $5535
    ld bc, $0800                                  ; $5538
    call Mem_CopyFromBank                         ; $553B
    ld a, BANK(Gfx_21_4800_Mode07_State00_Init)   ; $553E
    ld hl, Gfx_21_4800_Mode07_State00_Init        ; $5540
    ld de, $8800                                  ; $5543
    ld bc, $0400                                  ; $5546
    call Mem_CopyFromBank                         ; $5549
    ld a, BANK(Map_25_55C0_Mode07_State00_Init)   ; $554C
    ld hl, Map_25_55C0_Mode07_State00_Init        ; $554E
    ld de, $9800                                  ; $5551
    ld bc, $0240                                  ; $5554
    call Mem_CopyFromBank                         ; $5557
    ldh [hFarcallAArg], a                         ; $555A
    ld a, BANK(GameFace_LoadTiles_Far)            ; $555C
    ld hl, GameFace_LoadTiles_Far                 ; $555E
    call Far_Call                                 ; $5561
    call Oam_ClearShadow                          ; $5564
    call Pal_AllWhite                             ; $5567
    call Lcd_On                                   ; $556A
    xor a                                         ; $556D
    call SpaceFever_AddScore                      ; $556E
    call Pal_FadeIn                               ; $5571
    ld hl, wState                                 ; $5574
    inc [hl]                                      ; $5577
    ret                                           ; $5578


; C: music $31; field and sprites reset
Mode07_State01_Start::
    push af                                       ; $5579
    ld a, MUSIC_SPACE_FEVER_START                 ; $557A
    call Snd_Music                                ; $557C
    pop af                                        ; $557F
    call SpaceFever_ResetGame                     ; $5580
    xor a                                         ; $5583
    call SpaceFever_AddScore                      ; $5584
    ld a, [wShootWaveState]                       ; $5587
    ld a, $00                                     ; $558A
    ld [wShootWaveState], a                       ; $558C
    call Anim_ClearSlots                          ; $558F
    call SpaceFever_LoadHudTiles                  ; $5592
    ld b, $64                                     ; $5595

jr_007_5597:
    ldh a, [hKeysNew]                             ; $5597
    bit PADB_B, a                                 ; $5599
    jr nz, jr_007_55b4                            ; $559B

    push bc                                       ; $559D
    call SpaceFever_UpdateStars                   ; $559E
    call Oam_HideUnused                           ; $55A1
    rst Rst08_WaitVBlank                          ; $55A4
    pop bc                                        ; $55A5
    dec b                                         ; $55A6
    jr nz, jr_007_5597                            ; $55A7

    call SpaceFever_DrawChoiceText                ; $55A9
    call SpaceFever_UpdateStars                   ; $55AC
    ld hl, wState                                 ; $55AF
    inc [hl]                                      ; $55B2
    ret                                           ; $55B3


jr_007_55b4:
    ld a, STATE_07_LEAVE                          ; $55B4
    ld [wState], a                                ; $55B6
    ret                                           ; $55B9


; C: player; shot; wave; stars; hit by enemy -> state 3
Mode07_State02_Play::
    call SpaceFever_MovePlayer                    ; $55BA
    call SpaceFever_DrawPlayer                    ; $55BD
    ld a, [wSpriteAnimFrame]                      ; $55C0
    cp $02                                        ; $55C3
    call c, SpaceFever_FireShots                  ; $55C5
    call SpaceFever_DrawShots                     ; $55C8
    call SpaceFever_DrawHitFlash                  ; $55CB
    call SpaceFever_WaveStep                      ; $55CE
    ld a, [wShootWaveState]                       ; $55D1
    cp $09                                        ; $55D4
    jr nz, jr_007_55dd                            ; $55D6

    call SpaceFever_Collide_Boss                  ; $55D8
    jr jr_007_55e3                                ; $55DB

jr_007_55dd:
    call SpaceFever_Collide_Waves                 ; $55DD
    call SpaceFever_UpdateStars                   ; $55E0

jr_007_55e3:
    ldh a, [hKeysNew]                             ; $55E3
    bit PADB_START, a                             ; $55E5
    jr z, jr_007_560d                             ; $55E7

    ld a, [wSpriteAnimFrame + $2]                 ; $55E9
    cp $05                                        ; $55EC
    ret nc                                        ; $55EE

    call Oam_HideUnused                           ; $55EF
    rst Rst08_WaitVBlank                          ; $55F2
    call SpaceFever_UpdateStars                   ; $55F3
    call Oam_HideUnused                           ; $55F6
    rst Rst08_WaitVBlank                          ; $55F9
    call SpaceFever_UpdateStars                   ; $55FA
    call SpaceFever_DrawBestHud                   ; $55FD
    xor a                                         ; $5600
    ld [wShootChoice], a                          ; $5601
    ld [wShootChoiceBob], a                       ; $5604
    ld a, STATE_07_TARGET_MENU_B                  ; $5607
    ld [wState], a                                ; $5609
    ret                                           ; $560C


jr_007_560d:
    bit 1, a                                      ; $560D
    jr z, jr_007_562d                             ; $560F

    ld a, [wSpriteAnimFrame]                      ; $5611
    cp $02                                        ; $5614
    ret nc                                        ; $5616

    ld a, $02                                     ; $5617
    ld [wSpriteAnimFrame], a                      ; $5619
    xor a                                         ; $561C
    ld [wSpriteAnimTick], a                       ; $561D
    push af                                       ; $5620
    ld a, SFX1_SPACE_FEVER_PLAYER_DEATH_JINGLE    ; $5621
    call Snd_Sfx1                                 ; $5623
    pop af                                        ; $5626
    ld a, $01                                     ; $5627
    ld [wShootPlayerDied], a                      ; $5629
    ret                                           ; $562C


jr_007_562d:
    ld a, [wSpriteAnimFrame]                      ; $562D
    cp $0b                                        ; $5630
    ret nz                                        ; $5632

    ld a, [wShootWaveState]                       ; $5633
    cp $09                                        ; $5636
    jr nz, jr_007_5640                            ; $5638

    ld a, [wSpriteAnimFrame + $2]                 ; $563A
    cp $03                                        ; $563D
    ret nc                                        ; $563F

jr_007_5640:
    call SpaceFever_DrawGameOverHud               ; $5640
    xor a                                         ; $5643
    ld [wShootChoice], a                          ; $5644
    ld [wShootChoiceBob], a                       ; $5647
    ld a, STATE_07_TARGET_MENU_A                  ; $564A
    ld [wState], a                                ; $564C
    ret                                           ; $564F


; C: game over: choice menu (wave still drawn). L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
Mode07_State03_TargetMenuA::
    call SpaceFever_DrawShots                     ; $5650
    call SpaceFever_WaveStep                      ; $5653
    call SpaceFever_ReadChoice                    ; $5656
    call SpaceFever_DrawChoiceCursor              ; $5659
    ld a, [wShootWaveState]                       ; $565C
    cp $09                                        ; $565F
    call nz, SpaceFever_UpdateStars               ; $5661
    ldh a, [hKeysNew]                             ; $5664
    bit PADB_START, a                             ; $5666
    jr nz, jr_007_5677                            ; $5668

    bit PADB_B, a                                 ; $566A
    jr nz, jr_007_5683                            ; $566C

    bit PADB_A, a                                 ; $566E
    ret z                                         ; $5670

    ld a, [wShootChoice]                          ; $5671
    and a                                         ; $5674
    jr nz, jr_007_5683                            ; $5675

jr_007_5677:
    call Oam_ClearShadow                          ; $5677
    call SpaceFever_DrawChoiceText                ; $567A
    ld a, STATE_07_START                          ; $567D
    ld [wState], a                                ; $567F
    ret                                           ; $5682


jr_007_5683:
    ld a, STATE_07_LEAVE                          ; $5683
    ld [wState], a                                ; $5685
    ret                                           ; $5688


; C: choice menu (Up/Down; A = go; B = leave). L3 pass 2026-10-26: executed in BGB in 11 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
Mode07_State04_TargetMenuB::
    call SpaceFever_ReadChoice                    ; $5689
    call SpaceFever_DrawChoiceCursor              ; $568C
    call SpaceFever_UpdateStars                   ; $568F
    ldh a, [hKeysNew]                             ; $5692
    bit PADB_START, a                             ; $5694
    jr nz, jr_007_56a1                            ; $5696

    bit PADB_A, a                                 ; $5698
    ret z                                         ; $569A

    ld a, [wShootChoice]                          ; $569B
    and a                                         ; $569E
    jr nz, jr_007_56b9                            ; $569F

jr_007_56a1:
    push af                                       ; $56A1
    ld a, SFX1_KEY_B                              ; $56A2
    call Snd_Sfx1                                 ; $56A4
    pop af                                        ; $56A7
    call Oam_ClearShadow                          ; $56A8
    call SpaceFever_DrawChoiceText                ; $56AB
    ld c, $02                                     ; $56AE
    call z, SpaceFever_LoadBossTilesC             ; $56B0
    ld a, STATE_07_PLAY                           ; $56B3
    ld [wState], a                                ; $56B5
    ret                                           ; $56B8


jr_007_56b9:
    push af                                       ; $56B9
    ld a, SFX1_SPACE_FEVER_MENU_PICK_GAME         ; $56BA
    call Snd_Sfx1                                 ; $56BC
    pop af                                        ; $56BF
    ld a, STATE_07_LEAVE                          ; $56C0
    ld [wState], a                                ; $56C2
    ret                                           ; $56C5


; C: mode := $1F
Mode07_State05_GotoDj::
    call SpaceFever_UpdateStars                   ; $56C6
    ld a, MODE_DJ_EDITOR                          ; $56C9
    ld [wMode], a                                 ; $56CB
    ld a, STATE_1F_TITLE_INIT                     ; $56CE
    ld [wState], a                                ; $56D0
    ldh [hFarcallAArg], a                         ; $56D3
    ld a, BANK(Counters_Store_Far)                ; $56D5
    ld hl, Counters_Store_Far                     ; $56D7
    call Far_Call                                 ; $56DA
    call Pal_FadeOut                              ; $56DD
    call Lcd_Off                                  ; $56E0
    ret                                           ; $56E3


; C: mode := $20
Mode07_State06_GotoBall::
    call SpaceFever_UpdateStars                   ; $56E4
    ld a, MODE_BALL                               ; $56E7
    ld [wMode], a                                 ; $56E9
    ld a, STATE_20_MENU_INIT                      ; $56EC
    ld [wState], a                                ; $56EE
    ldh [hFarcallAArg], a                         ; $56F1
    ld a, BANK(Counters_Store_Far)                ; $56F3
    ld hl, Counters_Store_Far                     ; $56F5
    call Far_Call                                 ; $56F8
    call Pal_FadeOut                              ; $56FB
    call Lcd_Off                                  ; $56FE
    ret                                           ; $5701


; C: mode := $21
Mode07_State07_GotoRun::
    call SpaceFever_UpdateStars                   ; $5702
    ld a, MODE_RUN_RUN_RUN                        ; $5705
    ld [wMode], a                                 ; $5707
    ld a, STATE_21_INIT                           ; $570A
    ld [wState], a                                ; $570C
    ldh [hFarcallAArg], a                         ; $570F
    ld a, BANK(Counters_Store_Far)                ; $5711
    ld hl, Counters_Store_Far                     ; $5713
    call Far_Call                                 ; $5716
    call Pal_FadeOut                              ; $5719
    call Lcd_Off                                  ; $571C
    ret                                           ; $571F


; C: sprite $60 with bob (5747/5749)
SpaceFever_DrawChoiceCursor::
    ld a, [wShootChoice]                          ; $5720
    ld e, a                                       ; $5723
    ld d, $00                                     ; $5724
    ld hl, SpaceFever_ChoiceCursorXTbl            ; $5726
    add hl, de                                    ; $5729
    ld b, [hl]                                    ; $572A
    ld a, [wShootChoiceBob]                       ; $572B
    ld e, a                                       ; $572E
    inc a                                         ; $572F
    cp $0c                                        ; $5730
    jr nz, jr_007_5735                            ; $5732

    xor a                                         ; $5734

jr_007_5735:
    ld [wShootChoiceBob], a                       ; $5735
    ld hl, SpaceFever_DrawChoiceCursor_Tbl5749    ; $5738
    add hl, de                                    ; $573B
    ld a, [hl]                                    ; $573C
    add b                                         ; $573D
    ld b, a                                       ; $573E
    ld c, $60                                     ; $573F
    ld a, $60                                     ; $5741
    call Oam_AddMeta_B01_5D47                     ; $5743
    ret                                           ; $5746


; C
SpaceFever_ChoiceCursorXTbl::
    dw $8050

; C: auto: 12 bytes, bytes; referenced by SpaceFever_DrawChoiceCursor. L3 pass 2026-10-26: read in BGB in 12 replay(s)
; of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DrawChoiceCursor_Tbl5749::
    db $00, $04, $08, $0c, $10, $14, $18, $14, $10, $0c, $08, $04

; C: Up/Down changes shoot_choice
SpaceFever_ReadChoice::
    ldh a, [hKeysNew]                             ; $5755
    bit PADB_LEFT, a                              ; $5757
    jr z, jr_007_575e                             ; $5759

    xor a                                         ; $575B
    jr jr_007_5763                                ; $575C

jr_007_575e:
    bit 4, a                                      ; $575E
    ret z                                         ; $5760

    ld a, $01                                     ; $5761

jr_007_5763:
    ld hl, wShootChoice                           ; $5763
    cp [hl]                                       ; $5766
    ret z                                         ; $5767

    ld [hl], a                                    ; $5768
    push af                                       ; $5769
    ld a, SFX1_KEY_UP_DOWN                        ; $576A
    call Snd_Sfx1                                 ; $576C
    pop af                                        ; $576F
    ret                                           ; $5770


; C: Left/Right with limits
SpaceFever_MovePlayer::
    ld a, [wSpriteAnimFrame]                      ; $5771
    cp $02                                        ; $5774
    ret nc                                        ; $5776

    ld a, [wShootPlayerX]                         ; $5777
    ld hl, hKeysHeld                              ; $577A
    bit 5, [hl]                                   ; $577D
    jr z, jr_007_5787                             ; $577F

    and a                                         ; $5781
    ret z                                         ; $5782

    dec a                                         ; $5783
    dec a                                         ; $5784
    jr jr_007_5790                                ; $5785

jr_007_5787:
    bit 4, [hl]                                   ; $5787
    jr z, jr_007_5790                             ; $5789

    cp $50                                        ; $578B
    ret z                                         ; $578D

    inc a                                         ; $578E
    inc a                                         ; $578F

jr_007_5790:
    ld [wShootPlayerX], a                         ; $5790
    ret                                           ; $5793


; C
SpaceFever_DrawPlayer::
    ld a, [wSpriteAnimFrame]                      ; $5794
    sla a                                         ; $5797
    ld c, a                                       ; $5799
    ld b, $00                                     ; $579A
    ld hl, SpaceFever_DrawPlayer_Tbl57CA          ; $579C
    add hl, bc                                    ; $579F
    ld a, [hl+]                                   ; $57A0
    push af                                       ; $57A1
    ld a, [wShootPlayerX]                         ; $57A2
    add $48                                       ; $57A5
    ld b, a                                       ; $57A7
    ld c, $88                                     ; $57A8
    pop af                                        ; $57AA
    push hl                                       ; $57AB
    and a                                         ; $57AC
    call nz, Oam_AddMeta_B01_5D47                 ; $57AD
    pop hl                                        ; $57B0
    ld a, [wSpriteAnimTick]                       ; $57B1
    cp [hl]                                       ; $57B4
    jr nz, jr_007_57c5                            ; $57B5

    inc hl                                        ; $57B7
    ld a, [hl+]                                   ; $57B8
    inc a                                         ; $57B9
    ld a, [hl]                                    ; $57BA
    jr z, jr_007_57c1                             ; $57BB

    ld a, [wSpriteAnimFrame]                      ; $57BD
    inc a                                         ; $57C0

jr_007_57c1:
    ld [wSpriteAnimFrame], a                      ; $57C1
    xor a                                         ; $57C4

jr_007_57c5:
    inc a                                         ; $57C5
    ld [wSpriteAnimTick], a                       ; $57C6
    ret                                           ; $57C9


; C: auto: 26 bytes, bytes; referenced by SpaceFever_DrawPlayer. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DrawPlayer_Tbl57CA::
    db $4f, $10, $ff, $00, $50, $04, $51, $04, $52, $04, $53, $04, $52, $04, $53, $04
    db $52, $02, $53, $02, $00, $60, $00, $10, $ff, $0b

; C: single / rapid fire; up to 8 shot slots
SpaceFever_FireShots::
    ld a, [wShootRapidFlag]                       ; $57E4
    and a                                         ; $57E7
    jr nz, jr_007_583a                            ; $57E8

    ld hl, wShootShotY                            ; $57EA
    ld a, [hl+]                                   ; $57ED
    cp $fc                                        ; $57EE
    ret c                                         ; $57F0

    ld a, [hl+]                                   ; $57F1
    cp $fc                                        ; $57F2
    ret c                                         ; $57F4

    ld a, [hl+]                                   ; $57F5
    cp $fc                                        ; $57F6
    ret c                                         ; $57F8

    ldh a, [hKeysNew]                             ; $57F9
    bit PADB_A, a                                 ; $57FB
    ret z                                         ; $57FD

    ld hl, wShootFireCount                        ; $57FE
    inc [hl]                                      ; $5801
    bit 0, [hl]                                   ; $5802
    jr nz, jr_007_5819                            ; $5804

    ld a, [wShootPlayerX]                         ; $5806
    ld [wShootShotX], a                           ; $5809
    ld a, $88                                     ; $580C
    ld [wShootShotY], a                           ; $580E
    push af                                       ; $5811
    ld a, SFX4_SPACE_FEVER_FIRE_SHOTS             ; $5812
    call Snd_Sfx4                                 ; $5814
    pop af                                        ; $5817
    ret                                           ; $5818


jr_007_5819:
    ld a, [wShootPlayerX]                         ; $5819
    sub $04                                       ; $581C
    ld [wShootShotX + $1], a                      ; $581E
    add $08                                       ; $5821
    ld [wShootShotX + $2], a                      ; $5823
    ld a, $88                                     ; $5826
    ld [wShootShotY + $1], a                      ; $5828
    ld [wShootShotY + $2], a                      ; $582B
    xor a                                         ; $582E
    ld [wShootDoubleHits], a                      ; $582F
    push af                                       ; $5832
    ld a, SFX4_SPACE_FEVER_FIRE_SHOTS             ; $5833
    call Snd_Sfx4                                 ; $5835
    pop af                                        ; $5838
    ret                                           ; $5839


jr_007_583a:
    ld hl, wShootFireCount                        ; $583A
    ld a, [hl]                                    ; $583D
    and $07                                       ; $583E
    ld c, a                                       ; $5840
    ld b, $00                                     ; $5841
    ld hl, wShootShotY                            ; $5843
    add hl, bc                                    ; $5846
    ld a, [hl]                                    ; $5847
    cp $fc                                        ; $5848
    ret c                                         ; $584A

    ldh a, [hKeysHeld]                            ; $584B
    bit PADB_A, a                                 ; $584D
    ret z                                         ; $584F

    ldh a, [hFrameCounter]                        ; $5850
    and $03                                       ; $5852
    ret nz                                        ; $5854

    ld a, [wShootPlayerX]                         ; $5855
    ld hl, wShootShotX                            ; $5858
    add hl, bc                                    ; $585B
    ld [hl], a                                    ; $585C
    ld hl, wShootShotY                            ; $585D
    add hl, bc                                    ; $5860
    ld [hl], $88                                  ; $5861
    ld hl, wShootFireCount                        ; $5863
    inc [hl]                                      ; $5866
    ret                                           ; $5867


; C: sprite $5D; 4 px up per frame
SpaceFever_DrawShots::
    ld de, $0007                                  ; $5868

jr_007_586b:
    ld hl, wShootShotY                            ; $586B
    add hl, de                                    ; $586E
    ld a, [hl]                                    ; $586F
    cp $fc                                        ; $5870
    jr nc, jr_007_5889                            ; $5872

    dec a                                         ; $5874
    dec a                                         ; $5875
    dec a                                         ; $5876
    dec a                                         ; $5877
    ld [hl], a                                    ; $5878
    ld c, a                                       ; $5879
    ld hl, wShootShotX                            ; $587A
    add hl, de                                    ; $587D
    ld a, [hl]                                    ; $587E
    add $48                                       ; $587F
    ld b, a                                       ; $5881
    ld a, $5d                                     ; $5882
    push de                                       ; $5884
    call Oam_AddMeta_B01_5D47                     ; $5885
    pop de                                        ; $5888

jr_007_5889:
    dec e                                         ; $5889
    bit 7, e                                      ; $588A
    jr z, jr_007_586b                             ; $588C

    ret                                           ; $588E


; C: sprite $61; sound $0E
SpaceFever_DrawHitFlash::
    ld a, [wShootFlashTimer]                      ; $588F
    and a                                         ; $5892
    ret z                                         ; $5893

    dec a                                         ; $5894
    ld [wShootFlashTimer], a                      ; $5895
    cp $23                                        ; $5898
    jr nz, jr_007_58a3                            ; $589A

    push af                                       ; $589C
    ld a, SFX1_CHOOSE_D                           ; $589D
    call Snd_Sfx1                                 ; $589F
    pop af                                        ; $58A2

jr_007_58a3:
    ld a, [wShootFlashXy]                         ; $58A3
    add $48                                       ; $58A6
    ld b, a                                       ; $58A8
    ld a, [wShootFlashXy + $1]                    ; $58A9
    ld c, a                                       ; $58AC
    ld a, $61                                     ; $58AD
    call Oam_AddMeta_B01_5D47                     ; $58AF
    ret                                           ; $58B2


; C: background stars; sprite $5E + type
SpaceFever_UpdateStars::
    ld de, $0009                                  ; $58B3

jr_007_58b6:
    ld hl, wShootStarY                            ; $58B6
    add hl, de                                    ; $58B9
    ld a, [hl]                                    ; $58BA
    cp $d0                                        ; $58BB
    jr nc, jr_007_58e4                            ; $58BD

    push af                                       ; $58BF
    ldh a, [hFrameCounter]                        ; $58C0
    or e                                          ; $58C2
    ld c, a                                       ; $58C3
    pop af                                        ; $58C4
    bit 0, c                                      ; $58C5
    jr z, jr_007_58cb                             ; $58C7

    inc a                                         ; $58C9
    ld [hl], a                                    ; $58CA

jr_007_58cb:
    sub $40                                       ; $58CB
    ld c, a                                       ; $58CD
    ld hl, wShootStarX                            ; $58CE
    add hl, de                                    ; $58D1
    ld a, [hl]                                    ; $58D2
    add $48                                       ; $58D3
    ld b, a                                       ; $58D5
    ld hl, wShootStarType                         ; $58D6
    add hl, de                                    ; $58D9
    ld a, [hl]                                    ; $58DA
    add $5e                                       ; $58DB
    push de                                       ; $58DD
    call Oam_AddMeta_B01_5D47                     ; $58DE
    pop de                                        ; $58E1
    jr jr_007_590a                                ; $58E2

jr_007_58e4:
    call Rng_Next                                 ; $58E4
    and $0f                                       ; $58E7
    sla a                                         ; $58E9
    sla a                                         ; $58EB
    add $0c                                       ; $58ED
    ld hl, wShootStarX                            ; $58EF
    add hl, de                                    ; $58F2
    ld [hl], a                                    ; $58F3
    call Rng_Next                                 ; $58F4
    and $03                                       ; $58F7
    swap a                                        ; $58F9
    ld hl, wShootStarY                            ; $58FB
    add hl, de                                    ; $58FE
    ld [hl], a                                    ; $58FF
    call Rng_Next                                 ; $5900
    and $01                                       ; $5903
    ld hl, wShootStarType                         ; $5905
    add hl, de                                    ; $5908
    ld [hl], a                                    ; $5909

jr_007_590a:
    dec e                                         ; $590A
    bit 7, e                                      ; $590B
    jr z, jr_007_58b6                             ; $590D

    ret                                           ; $590F


; C: mode := 0
Mode07_State08_Leave::
    ld a, MODE_MAIN_MENU                          ; $5910
    ld [wMode], a                                 ; $5912
    ld a, STATE_00_INIT                           ; $5915
    ld [wState], a                                ; $5917
    ldh [hFarcallAArg], a                         ; $591A
    ld a, BANK(Counters_Store_Far)                ; $591C
    ld hl, Counters_Store_Far                     ; $591E
    call Far_Call                                 ; $5921
    call Pal_FadeOut                              ; $5924
    call Lcd_Off                                  ; $5927
    ret                                           ; $592A


; C: shots; enemies; score; best score copy
SpaceFever_ResetGame::
    ld a, $28                                     ; $592B
    ld [wShootPlayerX], a                         ; $592D
    ld a, $fc                                     ; $5930
    ld [wShootShotY], a                           ; $5932
    ld [wShootShotY + $1], a                      ; $5935
    ld [wShootShotY + $2], a                      ; $5938
    ld [wShootFlashXy + $1], a                    ; $593B
    ld a, $a0                                     ; $593E
    ld hl, wShootEnemyY                           ; $5940
    ld b, $03                                     ; $5943

jr_007_5945:
    ld [hl+], a                                   ; $5945
    dec b                                         ; $5946
    jr nz, jr_007_5945                            ; $5947

    ld hl, wShootBulletY                          ; $5949
    ld b, $08                                     ; $594C

jr_007_594e:
    ld [hl+], a                                   ; $594E
    dec b                                         ; $594F
    jr nz, jr_007_594e                            ; $5950

    ld a, $01                                     ; $5952
    ld [wShootFireCount], a                       ; $5954
    xor a                                         ; $5957
    ld [wShootShotX], a                           ; $5958
    ld [wShootShotX + $1], a                      ; $595B
    ld [wShootShotX + $2], a                      ; $595E
    ld [wShootScoreBcd], a                        ; $5961
    ld [wShootScoreBcd + $1], a                   ; $5964
    ld [wShootScoreBcd + $2], a                   ; $5967
    ld [wShootScoreBcd + $3], a                   ; $596A
    ld [wShootNewBestFlag], a                     ; $596D
    ld [wShootPlayerDied], a                      ; $5970
    ld [wShootRound], a                           ; $5973
    ld [wShootBossVariant], a                     ; $5976
    ld [wShootRapidFlag], a                       ; $5979
    ld de, $0009                                  ; $597C

jr_007_597f:
    call Rng_Next                                 ; $597F
    and $38                                       ; $5982
    add $0c                                       ; $5984
    ld hl, wShootStarX                            ; $5986
    add hl, de                                    ; $5989
    ld [hl], a                                    ; $598A
    call Rng_Next                                 ; $598B
    and $c4                                       ; $598E
    ld hl, wShootStarY                            ; $5990
    add hl, de                                    ; $5993
    ld [hl], a                                    ; $5994
    call Rng_Next                                 ; $5995
    and $00                                       ; $5998
    ld hl, wShootStarType                         ; $599A
    add hl, de                                    ; $599D
    ld [hl], a                                    ; $599E
    dec e                                         ; $599F
    bit 7, e                                      ; $59A0
    jr z, jr_007_597f                             ; $59A2

    ret                                           ; $59A4


; C: rst18 over shoot_wave_state
SpaceFever_WaveStep::
    ld a, [wShootWaveState]                       ; $59A5
    rst Rst18_JumpTable                           ; $59A8

; C: 12 entries: even = init; odd = play (README 2.7)
SpaceFever_WaveJumpTbl::
    dw SpaceFever_Wave0_Init
    dw SpaceFever_Wave0_Play
    dw SpaceFever_Wave1_Init
    dw SpaceFever_Wave1_Play
    dw SpaceFever_Wave2_Init
    dw SpaceFever_Wave2_Play
    dw SpaceFever_Wave3_Init
    dw SpaceFever_Wave3_Play
    dw SpaceFever_Boss_Init
    dw SpaceFever_Boss_Play
    dw SpaceFever_Boss_EndA
    dw SpaceFever_Boss_EndB

; C: opening wave: the three game targets
SpaceFever_Wave0_Init::
    ld a, $ec                                     ; $59C1
    ld [wShootEnemyBaseX], a                      ; $59C3
    ld a, $14                                     ; $59C6
    ld [wShootEnemyBaseX + $1], a                 ; $59C8
    xor a                                         ; $59CB
    ld [wShootEnemyBaseX + $2], a                 ; $59CC
    ld [wShootEnemyBaseY], a                      ; $59CF
    ld [wShootEnemyBaseY + $1], a                 ; $59D2
    ld [wShootEnemyBaseY + $2], a                 ; $59D5
    ld a, [SpaceFever_Wave0_PathEnd]              ; $59D8
    ld [wShootPathEnd], a                         ; $59DB
    ld [wShootPathEnd + $1], a                    ; $59DE
    ld [wShootPathEnd + $2], a                    ; $59E1
    ld a, $80                                     ; $59E4
    ld [wShootPathSpeed], a                       ; $59E6
    ld [wShootPathSpeed + $1], a                  ; $59E9
    ld [wShootPathSpeed + $2], a                  ; $59EC
    xor a                                         ; $59EF
    ld [wShootPathMirror], a                      ; $59F0
    ld [wShootPathMirror + $1], a                 ; $59F3
    ld [wShootPathMirror + $2], a                 ; $59F6
    ld a, [wBestShooter + $3]                     ; $59F9
    and a                                         ; $59FC
    jr nz, jr_007_5a11                            ; $59FD

    ld a, [wBestShooter + $2]                     ; $59FF
    and a                                         ; $5A02
    jr nz, jr_007_5a11                            ; $5A03

    ld a, [wBestShooter + $1]                     ; $5A05
    cp $20                                        ; $5A08
    jr nc, jr_007_5a11                            ; $5A0A

    ld a, $40                                     ; $5A0C
    ld [wShootEnemyBaseX + $2], a                 ; $5A0E

jr_007_5a11:
    call SpaceFever_ResetEnemies                  ; $5A11
    ld hl, SpaceFever_Wave0_Init_Tbl5A39          ; $5A14
    ld de, wMotionPath                            ; $5A17
    call SpaceFever_DecodePath                    ; $5A1A
    call SpaceFever_ClearBullets                  ; $5A1D
    ld a, $03                                     ; $5A20
    ld [wShootWaveEnemies], a                     ; $5A22
    xor a                                         ; $5A25
    ld [wShootWaveDone], a                        ; $5A26
    ld [wShootWavePass], a                        ; $5A29
    push af                                       ; $5A2C
    ld a, SFX1_SPACE_FEVER_START                  ; $5A2D
    call Snd_Sfx1                                 ; $5A2F
    pop af                                        ; $5A32
    ld hl, wShootWaveState                        ; $5A33
    inc [hl]                                      ; $5A36
    ret                                           ; $5A37


; C: path length byte. L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07
; (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_PathEnd::
    db $ff

; C: auto: 18 bytes, bytes; referenced by SpaceFever_Wave0_Init. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_Init_Tbl5A39::
    db $01, $27, $cd, $00, $de, $00, $cd, $00, $00, $01, $e0, $cd, $01, $de, $00, $cd
    db $ff, $00

; C: enemies off screen; path pos 0
SpaceFever_ResetEnemies::
    ld hl, wShootEnemyX                           ; $5A4B
    ld a, $60                                     ; $5A4E
    ld [hl+], a                                   ; $5A50
    ld [hl+], a                                   ; $5A51
    ld [hl], a                                    ; $5A52
    ld hl, wShootEnemyY                           ; $5A53
    ld a, $e0                                     ; $5A56
    ld [hl+], a                                   ; $5A58
    ld [hl+], a                                   ; $5A59
    ld [hl], a                                    ; $5A5A
    ld hl, wShootPathPos                          ; $5A5B
    xor a                                         ; $5A5E
    ld b, $06                                     ; $5A5F

jr_007_5a61:
    ld [hl+], a                                   ; $5A61
    dec b                                         ; $5A62
    jr nz, jr_007_5a61                            ; $5A63

    ld hl, wShootEnemyState                       ; $5A65
    ld [hl+], a                                   ; $5A68
    ld [hl+], a                                   ; $5A69
    ld [hl], a                                    ; $5A6A
    ld hl, wSpriteAnimTick + $2                   ; $5A6B
    ld [hl+], a                                   ; $5A6E
    ld [hl+], a                                   ; $5A6F
    ld [hl], a                                    ; $5A70
    ld [wShootFinishedMask], a                    ; $5A71
    ld a, $0a                                     ; $5A74
    ld [wShootStartDelay], a                      ; $5A76
    ld a, $00                                     ; $5A79
    ld [wSpriteAnimFrame + $2], a                 ; $5A7B
    ld a, $02                                     ; $5A7E
    ld [wSpriteAnimFrame + $3], a                 ; $5A80
    ld a, $04                                     ; $5A83
    ld [wSpriteAnimFrame + $4], a                 ; $5A85
    ld hl, wShootWavePass                         ; $5A88
    ld a, [hl]                                    ; $5A8B
    inc [hl]                                      ; $5A8C
    and a                                         ; $5A8D
    ret nz                                        ; $5A8E

    ld hl, wShootWaveDone                         ; $5A8F
    inc [hl]                                      ; $5A92
    ret                                           ; $5A93


; C
SpaceFever_Wave0_Play::
    call SpaceFever_Wave0_ReapKilled              ; $5A94
    ld bc, wMotionPath                            ; $5A97
    ld de, $0002                                  ; $5A9A
    call SpaceFever_MoveEnemies                   ; $5A9D
    ld bc, SpaceFever_Wave0_Play_Tbl5B20          ; $5AA0
    ld de, $0002                                  ; $5AA3
    call SpaceFever_DrawEnemies                   ; $5AA6
    call SpaceFever_Wave0_CheckTargetHit          ; $5AA9
    ld a, [wShootFinishedMask]                    ; $5AAC
    and $07                                       ; $5AAF
    cp $07                                        ; $5AB1
    call z, SpaceFever_ResetEnemies               ; $5AB3
    ld hl, wShootWaveDone                         ; $5AB6
    bit 0, [hl]                                   ; $5AB9
    ret z                                         ; $5ABB

    push af                                       ; $5ABC
    ld a, SFX1_SPACE_FEVER_WAVE0_END              ; $5ABD
    call Snd_Sfx1                                 ; $5ABF
    pop af                                        ; $5AC2
    ld a, $02                                     ; $5AC3
    ld [wShootWaveState], a                       ; $5AC5
    ret                                           ; $5AC8


; C: starts the death animation of a hit target. L3 pass 2026-10-26: executed in BGB in 13 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_ReapKilled::
    ld de, $0002                                  ; $5AC9

jr_007_5acc:
    ld hl, wShootEnemyState                       ; $5ACC
    add hl, de                                    ; $5ACF
    bit 0, [hl]                                   ; $5AD0
    jr z, jr_007_5af4                             ; $5AD2

    sla [hl]                                      ; $5AD4
    push af                                       ; $5AD6
    ld hl, wSpriteAnimFrame + $2                  ; $5AD7
    add hl, de                                    ; $5ADA
    ld [hl], $06                                  ; $5ADB
    ld hl, wSpriteAnimTick + $2                   ; $5ADD
    add hl, de                                    ; $5AE0
    ld [hl], $00                                  ; $5AE1
    pop af                                        ; $5AE3
    ld a, $00                                     ; $5AE4
    jr nc, jr_007_5aea                            ; $5AE6

    add a                                         ; $5AE8
    daa                                           ; $5AE9

jr_007_5aea:
    call SpaceFever_AddScore                      ; $5AEA
    push af                                       ; $5AED
    ld a, SFX1_SPACE_FEVER_TARGET_KILL            ; $5AEE
    call Snd_Sfx1                                 ; $5AF0
    pop af                                        ; $5AF3

jr_007_5af4:
    dec e                                         ; $5AF4
    bit 7, e                                      ; $5AF5
    jr z, jr_007_5acc                             ; $5AF7

    ret                                           ; $5AF9


; C: $D502/$D503/$D504 = $0A selects mode $20/$1F/$21 (state 6/5/7)
SpaceFever_Wave0_CheckTargetHit::
    ld a, [wSpriteAnimFrame + $2]                 ; $5AFA
    cp $0a                                        ; $5AFD
    jr nz, jr_007_5b07                            ; $5AFF

    ld a, STATE_07_GOTO_BALL                      ; $5B01
    ld [wState], a                                ; $5B03
    ret                                           ; $5B06


jr_007_5b07:
    ld a, [wSpriteAnimFrame + $3]                 ; $5B07
    cp $0a                                        ; $5B0A
    jr nz, jr_007_5b14                            ; $5B0C

    ld a, STATE_07_GOTO_DJ                        ; $5B0E
    ld [wState], a                                ; $5B10
    ret                                           ; $5B13


jr_007_5b14:
    ld a, [wSpriteAnimFrame + $4]                 ; $5B14
    cp $0a                                        ; $5B17
    ret nz                                        ; $5B19

    ld a, STATE_07_GOTO_RUN                       ; $5B1A
    ld [wState], a                                ; $5B1C
    ret                                           ; $5B1F


; C: auto: 24 bytes, bytes; referenced by SpaceFever_Wave0_Play. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_Play_Tbl5B20::
    db $56, $10, $ff, $00, $55, $10, $ff, $02, $54, $10, $ff, $04, $5a, $03, $5b, $04
    db $5c, $04, $00, $10, $00, $10, $ff, $0a

; C
SpaceFever_Wave1_Init::
    xor a                                         ; $5B38
    ld [wShootEnemyBaseY], a                      ; $5B39
    ld [wShootEnemyBaseY + $1], a                 ; $5B3C
    ld a, [$5b8a]                                 ; $5B3F
    ld [wShootPathEnd], a                         ; $5B42
    ld [wShootPathEnd + $1], a                    ; $5B45
    ld a, [wShootRound]                           ; $5B48
    ld c, a                                       ; $5B4B
    ld b, $00                                     ; $5B4C
    ld hl, SpaceFever_Wave1_Init_Tbl5B82          ; $5B4E
    add hl, bc                                    ; $5B51
    ld a, [hl]                                    ; $5B52
    ld [wShootPathSpeed], a                       ; $5B53
    ld [wShootPathSpeed + $1], a                  ; $5B56
    xor a                                         ; $5B59
    ld [wShootPathMirror], a                      ; $5B5A
    xor $ff                                       ; $5B5D
    ld [wShootPathMirror + $1], a                 ; $5B5F
    call SpaceFever_Wave1_RandomBase              ; $5B62
    ld hl, SpaceFever_Wave1_Init_Tbl5B8B          ; $5B65
    ld de, wMotionPath                            ; $5B68
    call SpaceFever_DecodePath                    ; $5B6B
    call SpaceFever_ClearBullets                  ; $5B6E
    ld a, $02                                     ; $5B71
    ld [wShootWaveEnemies], a                     ; $5B73
    xor a                                         ; $5B76
    ld [wShootWaveDone], a                        ; $5B77
    ld [wShootWavePass], a                        ; $5B7A
    ld hl, wShootWaveState                        ; $5B7D
    inc [hl]                                      ; $5B80
    ret                                           ; $5B81


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave1_Init. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Init_Tbl5B82::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $e0

; C: auto: 221 bytes, bytes; referenced by SpaceFever_Wave1_Init. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Init_Tbl5B8B::
    db $02, $28, $01, $80, $00, $02, $01, $00, $80, $01, $05, $00, $01, $00, $01, $00
    db $80, $01, $05, $00, $01, $00, $01, $00, $80, $01, $05, $00, $01, $00, $01, $00
    db $80, $01, $80, $00, $01, $01, $81, $00, $01, $01, $81, $00, $01, $01, $83, $00
    db $01, $01, $8d, $00, $01, $ff, $86, $00, $01, $ff, $80, $00, $03, $ff, $00, $ff
    db $80, $00, $01, $ff, $81, $00, $01, $ff, $80, $00, $02, $ff, $00, $80, $ff, $02
    db $00, $ff, $80, $00, $02, $ff, $00, $80, $ff, $04, $00, $ff, $00, $ff, $80, $00
    db $02, $ff, $00, $80, $ff, $22, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff, $00, $ff
    db $00, $ff, $00, $ff, $00, $ff, $00, $ff, $80, $00, $01, $ff, $80, $00, $01, $ff
    db $80, $00, $01, $ff, $81, $00, $01, $ff, $80, $00, $01, $ff, $86, $00, $01, $ff
    db $87, $00, $01, $01, $86, $00, $01, $01, $80, $00, $01, $01, $81, $00, $01, $01
    db $81, $00, $03, $01, $00, $01, $80, $00, $80, $01, $02, $00, $01, $80, $00, $02
    db $01, $00, $80, $01, $03, $00, $01, $00, $80, $01, $01, $00, $80, $01, $01, $00
    db $80, $01, $02, $00, $01, $00, $01, $e0, $ff, $01, $dc, $01, $00

; C: random base offsets and enemy reset
SpaceFever_Wave1_RandomBase::
    ld hl, wShootEnemyBaseX                       ; $5C68
    call Rng_Next                                 ; $5C6B
    and $1f                                       ; $5C6E
    sub $10                                       ; $5C70
    ld [hl+], a                                   ; $5C72
    call Rng_Next                                 ; $5C73
    and $1f                                       ; $5C76
    sub $10                                       ; $5C78
    ld [hl], a                                    ; $5C7A
    ld hl, wShootEnemyX                           ; $5C7B
    ld a, $60                                     ; $5C7E
    ld [hl+], a                                   ; $5C80
    ld [hl], a                                    ; $5C81
    ld hl, wShootEnemyY                           ; $5C82
    ld a, $e0                                     ; $5C85
    ld [hl+], a                                   ; $5C87
    ld [hl], a                                    ; $5C88
    ld hl, wShootPathPos                          ; $5C89
    xor a                                         ; $5C8C
    ld b, $04                                     ; $5C8D

jr_007_5c8f:
    ld [hl+], a                                   ; $5C8F
    dec b                                         ; $5C90
    jr nz, jr_007_5c8f                            ; $5C91

    ld hl, wShootEnemyState                       ; $5C93
    ld [hl+], a                                   ; $5C96
    ld [hl], a                                    ; $5C97
    ld hl, wSpriteAnimTick + $2                   ; $5C98
    ld [hl+], a                                   ; $5C9B
    ld [hl], a                                    ; $5C9C
    ld [wShootFinishedMask], a                    ; $5C9D
    ld a, $0a                                     ; $5CA0
    ld [wShootStartDelay], a                      ; $5CA2
    ld hl, wSpriteAnimFrame + $2                  ; $5CA5
    ld a, $00                                     ; $5CA8
    ld [hl+], a                                   ; $5CAA
    ld [hl], a                                    ; $5CAB
    ld hl, wShootWavePass                         ; $5CAC
    ld a, [hl]                                    ; $5CAF
    inc [hl]                                      ; $5CB0
    cp $02                                        ; $5CB1
    ret nz                                        ; $5CB3

    ld hl, wShootWaveDone                         ; $5CB4
    inc [hl]                                      ; $5CB7
    ret                                           ; $5CB8


; C
SpaceFever_Wave1_Play::
    call SpaceFever_Wave1_ReapKilled              ; $5CB9
    ld bc, wMotionPath                            ; $5CBC
    ld de, $0001                                  ; $5CBF
    call SpaceFever_MoveEnemies                   ; $5CC2
    ld bc, SpaceFever_Wave1_Play_Tbl5D15          ; $5CC5
    ld de, $0001                                  ; $5CC8
    call SpaceFever_DrawEnemies                   ; $5CCB
    ld a, [wShootFinishedMask]                    ; $5CCE
    and $03                                       ; $5CD1
    cp $03                                        ; $5CD3
    call z, SpaceFever_Wave1_RandomBase           ; $5CD5
    ld hl, wShootWaveDone                         ; $5CD8
    bit 0, [hl]                                   ; $5CDB
    ret z                                         ; $5CDD

    ld a, $04                                     ; $5CDE
    ld [wShootWaveState], a                       ; $5CE0
    ret                                           ; $5CE3


; C: L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_ReapKilled::
    ld de, $0001                                  ; $5CE4

jr_007_5ce7:
    ld hl, wShootEnemyState                       ; $5CE7
    add hl, de                                    ; $5CEA
    bit 0, [hl]                                   ; $5CEB
    jr z, jr_007_5d0f                             ; $5CED

    sla [hl]                                      ; $5CEF
    push af                                       ; $5CF1
    ld hl, wSpriteAnimFrame + $2                  ; $5CF2
    add hl, de                                    ; $5CF5
    ld [hl], $02                                  ; $5CF6
    ld hl, wSpriteAnimTick + $2                   ; $5CF8
    add hl, de                                    ; $5CFB
    ld [hl], $00                                  ; $5CFC
    pop af                                        ; $5CFE
    ld a, $05                                     ; $5CFF
    jr nc, jr_007_5d05                            ; $5D01

    add a                                         ; $5D03
    daa                                           ; $5D04

jr_007_5d05:
    call SpaceFever_AddScore                      ; $5D05
    push af                                       ; $5D08
    ld a, SFX1_SPACE_FEVER_ENEMY_KILL             ; $5D09
    call Snd_Sfx1                                 ; $5D0B
    pop af                                        ; $5D0E

jr_007_5d0f:
    dec e                                         ; $5D0F
    bit 7, e                                      ; $5D10
    jr z, jr_007_5ce7                             ; $5D12

    ret                                           ; $5D14


; C: auto: 12 bytes, bytes; referenced by SpaceFever_Wave1_Play. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Play_Tbl5D15::
    db $59, $10, $ff, $00, $5a, $04, $5b, $06, $00, $10, $ff, $04

; C
SpaceFever_Wave2_Init::
    xor a                                         ; $5D21
    ld [wShootEnemyBaseY], a                      ; $5D22
    ld [wShootEnemyBaseY + $1], a                 ; $5D25
    ld a, [$5d73]                                 ; $5D28
    ld [wShootPathEnd], a                         ; $5D2B
    ld [wShootPathEnd + $1], a                    ; $5D2E
    ld a, [wShootRound]                           ; $5D31
    ld c, a                                       ; $5D34
    ld b, $00                                     ; $5D35
    ld hl, SpaceFever_Wave2_Init_Tbl5D6B          ; $5D37
    add hl, bc                                    ; $5D3A
    ld a, [hl]                                    ; $5D3B
    ld [wShootPathSpeed], a                       ; $5D3C
    ld [wShootPathSpeed + $1], a                  ; $5D3F
    xor a                                         ; $5D42
    ld [wShootPathMirror], a                      ; $5D43
    xor $ff                                       ; $5D46
    ld [wShootPathMirror + $1], a                 ; $5D48
    call SpaceFever_Wave2_RandomBase              ; $5D4B
    ld hl, SpaceFever_Wave2_Init_Tbl5D74          ; $5D4E
    ld de, wMotionPath                            ; $5D51
    call SpaceFever_DecodePath                    ; $5D54
    call SpaceFever_ClearBullets                  ; $5D57
    ld a, $02                                     ; $5D5A
    ld [wShootWaveEnemies], a                     ; $5D5C
    xor a                                         ; $5D5F
    ld [wShootWaveDone], a                        ; $5D60
    ld [wShootWavePass], a                        ; $5D63
    ld hl, wShootWaveState                        ; $5D66
    inc [hl]                                      ; $5D69
    ret                                           ; $5D6A


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave2_Init. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Init_Tbl5D6B::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $a4

; C: auto: 152 bytes, bytes; referenced by SpaceFever_Wave2_Init. L3 pass 2026-10-26: read in BGB in 8 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Init_Tbl5D74::
    db $01, $3f, $85, $00, $01, $ff, $84, $00, $01, $ff, $85, $00, $01, $ff, $85, $00
    db $01, $ff, $85, $00, $01, $ff, $81, $00, $01, $ff, $81, $00, $01, $ff, $81, $00
    db $01, $ff, $81, $00, $01, $ff, $80, $00, $01, $ff, $80, $00, $01, $ff, $80, $00
    db $01, $ff, $80, $00, $03, $ff, $00, $ff, $80, $00, $07, $ff, $00, $ff, $00, $ff
    db $00, $ff, $80, $00, $02, $ff, $00, $80, $ff, $03, $00, $ff, $00, $81, $ff, $01
    db $00, $81, $ff, $01, $00, $81, $ff, $01, $00, $be, $ff, $00, $01, $e0, $e8, $01
    db $01, $00, $81, $01, $01, $00, $80, $01, $01, $00, $81, $01, $01, $00, $80, $01
    db $02, $00, $01, $80, $00, $07, $01, $00, $01, $00, $01, $00, $01, $80, $00, $01
    db $01, $80, $00, $01, $01, $83, $00, $01, $01, $82, $00, $01, $01, $83, $00, $01
    db $01, $82, $00, $01, $01, $82, $00, $00

; C
SpaceFever_Wave2_RandomBase::
    ld hl, wShootEnemyBaseX                       ; $5E0C
    call Rng_Next                                 ; $5E0F
    and $1f                                       ; $5E12
    sub $10                                       ; $5E14
    ld [hl+], a                                   ; $5E16
    call Rng_Next                                 ; $5E17
    and $1f                                       ; $5E1A
    sub $10                                       ; $5E1C
    ld [hl], a                                    ; $5E1E
    ld hl, wShootEnemyX                           ; $5E1F
    ld a, $60                                     ; $5E22
    ld [hl+], a                                   ; $5E24
    ld [hl], a                                    ; $5E25
    ld hl, wShootEnemyY                           ; $5E26
    ld a, $e0                                     ; $5E29
    ld [hl+], a                                   ; $5E2B
    ld [hl], a                                    ; $5E2C
    ld hl, wShootPathPos                          ; $5E2D
    xor a                                         ; $5E30
    ld b, $04                                     ; $5E31

jr_007_5e33:
    ld [hl+], a                                   ; $5E33
    dec b                                         ; $5E34
    jr nz, jr_007_5e33                            ; $5E35

    ld hl, wShootEnemyState                       ; $5E37
    ld [hl+], a                                   ; $5E3A
    ld [hl], a                                    ; $5E3B
    ld hl, wSpriteAnimTick + $2                   ; $5E3C
    ld [hl+], a                                   ; $5E3F
    ld [hl], a                                    ; $5E40
    ld [wShootFinishedMask], a                    ; $5E41
    ld a, $0a                                     ; $5E44
    ld [wShootStartDelay], a                      ; $5E46
    ld hl, wSpriteAnimFrame + $2                  ; $5E49
    ld a, $00                                     ; $5E4C
    ld [hl+], a                                   ; $5E4E
    ld [hl], a                                    ; $5E4F
    ld hl, wShootWavePass                         ; $5E50
    ld a, [hl]                                    ; $5E53
    inc [hl]                                      ; $5E54
    cp $02                                        ; $5E55
    ret nz                                        ; $5E57

    ld hl, wShootWaveDone                         ; $5E58
    inc [hl]                                      ; $5E5B
    ret                                           ; $5E5C


; C
SpaceFever_Wave2_Play::
    call SpaceFever_Wave2_ReapKilled              ; $5E5D
    call SpaceFever_Wave2_EnemyFire               ; $5E60
    ld bc, wMotionPath                            ; $5E63
    ld de, $0001                                  ; $5E66
    call SpaceFever_MoveEnemies                   ; $5E69
    ld bc, SpaceFever_Wave2_Play_Tbl5EF3          ; $5E6C
    ld de, $0001                                  ; $5E6F
    call SpaceFever_DrawEnemies                   ; $5E72
    call SpaceFever_DrawBullets                   ; $5E75
    call SpaceFever_CountBullets                  ; $5E78
    and a                                         ; $5E7B
    ret nz                                        ; $5E7C

    ld a, [wShootFinishedMask]                    ; $5E7D
    and $03                                       ; $5E80
    cp $03                                        ; $5E82
    call z, SpaceFever_Wave2_RandomBase           ; $5E84
    ld hl, wShootWaveDone                         ; $5E87
    bit 0, [hl]                                   ; $5E8A
    ret z                                         ; $5E8C

    ld a, $06                                     ; $5E8D
    ld [wShootWaveState], a                       ; $5E8F
    ret                                           ; $5E92


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_ReapKilled::
    ld de, $0001                                  ; $5E93

jr_007_5e96:
    ld hl, wShootEnemyState                       ; $5E96
    add hl, de                                    ; $5E99
    bit 0, [hl]                                   ; $5E9A
    jr z, jr_007_5ebe                             ; $5E9C

    sla [hl]                                      ; $5E9E
    push af                                       ; $5EA0
    ld hl, wSpriteAnimFrame + $2                  ; $5EA1
    add hl, de                                    ; $5EA4
    ld [hl], $02                                  ; $5EA5
    ld hl, wSpriteAnimTick + $2                   ; $5EA7
    add hl, de                                    ; $5EAA
    ld [hl], $00                                  ; $5EAB
    pop af                                        ; $5EAD
    ld a, $10                                     ; $5EAE
    jr nc, jr_007_5eb4                            ; $5EB0

    add a                                         ; $5EB2
    daa                                           ; $5EB3

jr_007_5eb4:
    call SpaceFever_AddScore                      ; $5EB4
    push af                                       ; $5EB7
    ld a, SFX1_SPACE_FEVER_ENEMY_KILL             ; $5EB8
    call Snd_Sfx1                                 ; $5EBA
    pop af                                        ; $5EBD

jr_007_5ebe:
    dec e                                         ; $5EBE
    bit 7, e                                      ; $5EBF
    jr z, jr_007_5e96                             ; $5EC1

    ret                                           ; $5EC3


; C: enemy shoots when low enough and fewer than 5 bullets are up. L3 pass 2026-10-26: executed in BGB in 8 replay(s)
; of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_EnemyFire::
    ld de, $0001                                  ; $5EC4

jr_007_5ec7:
    ld hl, wShootEnemyState                       ; $5EC7
    add hl, de                                    ; $5ECA
    ld a, [hl]                                    ; $5ECB
    and a                                         ; $5ECC
    jr nz, jr_007_5eed                            ; $5ECD

    ld hl, wShootEnemyY                           ; $5ECF
    add hl, de                                    ; $5ED2
    ld a, [hl]                                    ; $5ED3
    cp $20                                        ; $5ED4
    jr c, jr_007_5eed                             ; $5ED6

    call SpaceFever_CountBullets                  ; $5ED8
    cp $05                                        ; $5EDB
    jr nc, jr_007_5eed                            ; $5EDD

    ldh a, [hFrameCounter]                        ; $5EDF
    and $0f                                       ; $5EE1
    jr nz, jr_007_5eed                            ; $5EE3

    call Rng_Next                                 ; $5EE5
    cp $80                                        ; $5EE8
    call c, SpaceFever_FireBullet                 ; $5EEA

jr_007_5eed:
    dec e                                         ; $5EED
    bit 7, e                                      ; $5EEE
    jr z, jr_007_5ec7                             ; $5EF0

    ret                                           ; $5EF2


; C: auto: 12 bytes, bytes; referenced by SpaceFever_Wave2_Play. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Play_Tbl5EF3::
    db $58, $10, $ff, $00, $5a, $04, $5b, $06, $00, $10, $ff, $04

; C
SpaceFever_Wave3_Init::
    xor a                                         ; $5EFF
    ld [wShootEnemyBaseY], a                      ; $5F00
    ld a, $08                                     ; $5F03
    ld [wShootEnemyBaseY + $1], a                 ; $5F05
    ld [wShootEnemyBaseY + $2], a                 ; $5F08
    ld a, [$5f5d]                                 ; $5F0B
    ld [wShootPathEnd], a                         ; $5F0E
    ld [wShootPathEnd + $1], a                    ; $5F11
    ld [wShootPathEnd + $2], a                    ; $5F14
    ld a, [wShootRound]                           ; $5F17
    ld c, a                                       ; $5F1A
    ld b, $00                                     ; $5F1B
    ld hl, SpaceFever_Wave3_Init_Tbl5F55          ; $5F1D
    add hl, bc                                    ; $5F20
    ld a, [hl]                                    ; $5F21
    ld [wShootPathSpeed], a                       ; $5F22
    ld [wShootPathSpeed + $1], a                  ; $5F25
    ld [wShootPathSpeed + $2], a                  ; $5F28
    xor a                                         ; $5F2B
    ld [wShootPathMirror], a                      ; $5F2C
    ld [wShootPathMirror + $1], a                 ; $5F2F
    ld [wShootPathMirror + $2], a                 ; $5F32
    call SpaceFever_Wave3_RandomBase              ; $5F35
    ld hl, SpaceFever_Wave3_Init_Tbl5F5E          ; $5F38
    ld de, wMotionPath                            ; $5F3B
    call SpaceFever_DecodePath                    ; $5F3E
    call SpaceFever_ClearBullets                  ; $5F41
    ld a, $03                                     ; $5F44
    ld [wShootWaveEnemies], a                     ; $5F46
    xor a                                         ; $5F49
    ld [wShootWaveDone], a                        ; $5F4A
    ld [wShootWavePass], a                        ; $5F4D
    ld hl, wShootWaveState                        ; $5F50
    inc [hl]                                      ; $5F53
    ret                                           ; $5F54


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave3_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00
; 07 12)
SpaceFever_Wave3_Init_Tbl5F55::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $ea

; C: auto: 151 bytes, bytes; referenced by SpaceFever_Wave3_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 07)
SpaceFever_Wave3_Init_Tbl5F5E::
    db $01, $4f, $ac, $ff, $01, $00, $81, $ff, $01, $00, $80, $ff, $01, $00, $81, $ff
    db $81, $00, $01, $ff, $81, $00, $01, $ff, $83, $00, $01, $01, $81, $00, $80, $01
    db $03, $00, $01, $00, $85, $01, $01, $00, $8b, $01, $01, $00, $86, $01, $04, $00
    db $01, $00, $01, $80, $00, $02, $01, $ff, $82, $00, $80, $ff, $01, $00, $80, $ff
    db $01, $00, $8b, $ff, $01, $00, $8b, $ff, $01, $00, $80, $ff, $04, $00, $ff, $00
    db $ff, $83, $00, $02, $ff, $01, $81, $00, $01, $01, $81, $00, $06, $01, $00, $01
    db $00, $01, $00, $81, $01, $01, $00, $ae, $01, $00, $03, $e0, $01, $00, $83, $01
    db $01, $00, $84, $01, $01, $00, $81, $01, $01, $00, $83, $01, $01, $00, $ff, $01
    db $b3, $01, $01, $00, $81, $01, $01, $00, $83, $01, $01, $00, $82, $01, $01, $00
    db $83, $01, $01, $00, $82, $01, $00

; C
SpaceFever_Wave3_RandomBase::
    ld hl, wShootEnemyBaseX                       ; $5FF5
    call Rng_Next                                 ; $5FF8
    and $1f                                       ; $5FFB
    sub $10                                       ; $5FFD
    ld [hl+], a                                   ; $5FFF
    sub $05                                       ; $6000
    ld [hl+], a                                   ; $6002
    add $0a                                       ; $6003
    ld [hl], a                                    ; $6005
    ld hl, wShootEnemyX                           ; $6006
    ld a, $60                                     ; $6009
    ld [hl+], a                                   ; $600B
    ld [hl+], a                                   ; $600C
    ld [hl], a                                    ; $600D
    ld hl, wShootEnemyY                           ; $600E
    ld a, $e0                                     ; $6011
    ld [hl+], a                                   ; $6013
    ld [hl+], a                                   ; $6014
    ld [hl], a                                    ; $6015
    ld hl, wShootPathPos                          ; $6016
    xor a                                         ; $6019
    ld b, $06                                     ; $601A

jr_007_601c:
    ld [hl+], a                                   ; $601C
    dec b                                         ; $601D
    jr nz, jr_007_601c                            ; $601E

    ld hl, wShootEnemyState                       ; $6020
    ld [hl+], a                                   ; $6023
    ld [hl+], a                                   ; $6024
    ld [hl], a                                    ; $6025
    ld hl, wSpriteAnimTick + $2                   ; $6026
    ld [hl+], a                                   ; $6029
    ld [hl+], a                                   ; $602A
    ld [hl], a                                    ; $602B
    ld [wShootFinishedMask], a                    ; $602C
    ld a, $0a                                     ; $602F
    ld [wShootStartDelay], a                      ; $6031
    ld hl, wSpriteAnimFrame + $2                  ; $6034
    ld a, $00                                     ; $6037
    ld [hl+], a                                   ; $6039
    ld a, $02                                     ; $603A
    ld [hl+], a                                   ; $603C
    ld [hl], a                                    ; $603D
    ld hl, wShootWavePass                         ; $603E
    ld a, [hl]                                    ; $6041
    inc [hl]                                      ; $6042
    cp $02                                        ; $6043
    ret nz                                        ; $6045

    ld hl, wShootWaveDone                         ; $6046
    inc [hl]                                      ; $6049
    ret                                           ; $604A


; C
SpaceFever_Wave3_Play::
    call SpaceFever_Wave3_ReapKilled              ; $604B
    ld bc, wMotionPath                            ; $604E
    ld de, $0002                                  ; $6051
    call SpaceFever_MoveEnemies                   ; $6054
    ld bc, SpaceFever_Wave3_Play_Tbl60C1          ; $6057
    ld de, $0002                                  ; $605A
    call SpaceFever_DrawEnemies                   ; $605D
    call SpaceFever_DrawBullets                   ; $6060
    ld a, [wShootFinishedMask]                    ; $6063
    and $07                                       ; $6066
    cp $07                                        ; $6068
    call z, SpaceFever_Wave3_RandomBase           ; $606A
    ld hl, wShootWaveDone                         ; $606D
    bit 0, [hl]                                   ; $6070
    ret z                                         ; $6072

    ld a, $08                                     ; $6073
    ld [wShootWaveState], a                       ; $6075
    ret                                           ; $6078


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SpaceFever_Wave3_ReapKilled::
    ld de, $0002                                  ; $6079

jr_007_607c:
    ld hl, wShootEnemyState                       ; $607C
    add hl, de                                    ; $607F
    bit 0, [hl]                                   ; $6080
    jr z, jr_007_60bb                             ; $6082

    sla [hl]                                      ; $6084
    push af                                       ; $6086
    ld hl, wSpriteAnimFrame + $2                  ; $6087
    add hl, de                                    ; $608A
    ld [hl], $04                                  ; $608B
    ld hl, wSpriteAnimTick + $2                   ; $608D
    add hl, de                                    ; $6090
    ld [hl], $00                                  ; $6091
    ld a, e                                       ; $6093
    and a                                         ; $6094
    jr nz, jr_007_60aa                            ; $6095

    pop af                                        ; $6097
    ld a, $30                                     ; $6098
    jr nc, jr_007_609e                            ; $609A

    add a                                         ; $609C
    daa                                           ; $609D

jr_007_609e:
    call SpaceFever_AddScore                      ; $609E
    push af                                       ; $60A1
    ld a, SFX1_SPACE_FEVER_BIG_ENEMY_KILL         ; $60A2
    call Snd_Sfx1                                 ; $60A4
    pop af                                        ; $60A7
    jr jr_007_60bb                                ; $60A8

jr_007_60aa:
    pop af                                        ; $60AA
    ld a, $05                                     ; $60AB
    jr nc, jr_007_60b1                            ; $60AD

    add a                                         ; $60AF
    daa                                           ; $60B0

jr_007_60b1:
    call SpaceFever_AddScore                      ; $60B1
    push af                                       ; $60B4
    ld a, SFX1_SPACE_FEVER_ENEMY_KILL             ; $60B5
    call Snd_Sfx1                                 ; $60B7
    pop af                                        ; $60BA

jr_007_60bb:
    dec e                                         ; $60BB
    bit 7, e                                      ; $60BC
    jr z, jr_007_607c                             ; $60BE

    ret                                           ; $60C0


; C: auto: 16 bytes, bytes; referenced by SpaceFever_Wave3_Play. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 07)
SpaceFever_Wave3_Play_Tbl60C1::
    db $57, $10, $ff, $00, $59, $10, $ff, $02, $5a, $04, $5b, $06, $00, $10, $ff, $06

; C: boss graphics; speed table 07:6130; music
SpaceFever_Boss_Init::
    xor a                                         ; $60D1
    ld [wShootEnemyBaseX], a                      ; $60D2
    ld a, [$6138]                                 ; $60D5
    ld [wShootPathEnd], a                         ; $60D8
    ld a, [wShootRound]                           ; $60DB
    ld c, a                                       ; $60DE
    ld b, $00                                     ; $60DF
    ld hl, SpaceFever_Boss_Init_Tbl6130           ; $60E1
    add hl, bc                                    ; $60E4
    ld a, [hl]                                    ; $60E5
    ld [wShootPathSpeed], a                       ; $60E6
    xor a                                         ; $60E9
    ld [wShootPathMirror], a                      ; $60EA
    ld c, $00                                     ; $60ED
    call SpaceFever_LoadBossTilesA                ; $60EF
    ld c, $01                                     ; $60F2
    call SpaceFever_LoadBossTilesB                ; $60F4
    ld a, [wShootPlayerDied]                      ; $60F7
    and a                                         ; $60FA
    ld c, $02                                     ; $60FB
    call z, SpaceFever_LoadBossTilesC             ; $60FD
    call Sf2_BuildBossMasks                       ; $6100
    call SpaceFever_Boss_ResetPass                ; $6103
    ld hl, SpaceFever_Boss_Init_Tbl6139           ; $6106
    ld de, wMotionPath                            ; $6109
    call SpaceFever_DecodePath                    ; $610C
    call SpaceFever_ClearBullets                  ; $610F
    ld a, $01                                     ; $6112
    ld [wShootWaveEnemies], a                     ; $6114
    xor a                                         ; $6117
    ld [wShootWaveDone], a                        ; $6118
    ld [wShootWavePass], a                        ; $611B
    ld a, [wShootPlayerDied]                      ; $611E
    and a                                         ; $6121
    jr nz, jr_007_612b                            ; $6122

    push af                                       ; $6124
    ld a, MUSIC_SPACE_FEVER_BOSS                  ; $6125
    call Snd_Music                                ; $6127
    pop af                                        ; $612A

jr_007_612b:
    ld hl, wShootWaveState                        ; $612B
    inc [hl]                                      ; $612E
    ret                                           ; $612F


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Boss_Init. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00 07 12)
SpaceFever_Boss_Init_Tbl6130::
    db $50, $60, $70, $80, $90, $a0, $b0, $c0, $d6

; C: auto: 154 bytes, bytes; referenced by SpaceFever_Boss_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 07
; 12)
SpaceFever_Boss_Init_Tbl6139::
    db $01, $28, $c3, $00, $82, $01, $07, $00, $01, $00, $01, $00, $01, $00, $80, $01
    db $07, $00, $01, $00, $01, $00, $01, $00, $86, $01, $06, $00, $01, $00, $01, $00
    db $01, $82, $00, $06, $ff, $00, $ff, $00, $ff, $00, $86, $ff, $07, $00, $ff, $00
    db $ff, $00, $ff, $00, $80, $ff, $07, $00, $ff, $00, $ff, $00, $ff, $00, $87, $ff
    db $07, $00, $ff, $00, $ff, $00, $ff, $00, $80, $ff, $07, $00, $ff, $00, $ff, $00
    db $ff, $00, $86, $ff, $06, $00, $ff, $00, $ff, $00, $ff, $82, $00, $06, $01, $00
    db $01, $00, $01, $00, $86, $01, $07, $00, $01, $00, $01, $00, $01, $00, $80, $01
    db $07, $00, $01, $00, $01, $00, $01, $00, $82, $01, $00, $01, $e0, $c3, $01, $01
    db $00, $94, $01, $80, $00, $94, $ff, $80, $00, $94, $01, $81, $00, $94, $ff, $80
    db $00, $94, $01, $80, $00, $94, $ff, $00, $45, $00

; C
SpaceFever_Boss_ResetPass::
    call Rng_Next                                 ; $61D3
    and $0f                                       ; $61D6
    sub $08                                       ; $61D8
    ld [wShootEnemyBaseY], a                      ; $61DA
    ld a, $60                                     ; $61DD
    ld [wShootEnemyX], a                          ; $61DF
    ld a, $e0                                     ; $61E2
    ld [wShootEnemyY], a                          ; $61E4
    ld hl, wShootPathPos                          ; $61E7
    xor a                                         ; $61EA
    ld [hl+], a                                   ; $61EB
    ld [hl], a                                    ; $61EC
    ld [wShootEnemyState], a                      ; $61ED
    ld [wSpriteAnimTick + $2], a                  ; $61F0
    ld [wShootFinishedMask], a                    ; $61F3
    ld [wShootBossHits], a                        ; $61F6
    ld a, $14                                     ; $61F9
    ld [wShootStartDelay], a                      ; $61FB
    ld a, $00                                     ; $61FE
    ld [wSpriteAnimFrame + $2], a                 ; $6200
    ld hl, wShootWavePass                         ; $6203
    ld a, [hl]                                    ; $6206
    inc [hl]                                      ; $6207
    and a                                         ; $6208
    ret nz                                        ; $6209

    ld hl, wShootWaveDone                         ; $620A
    inc [hl]                                      ; $620D
    ret                                           ; $620E


; C
SpaceFever_Boss_Play::
    ld a, [wSpriteAnimFrame + $2]                 ; $620F
    cp $05                                        ; $6212
    jr nc, jr_007_6222                            ; $6214

    call SpaceFever_Boss_EnemyFire                ; $6216
    ld bc, wMotionPath                            ; $6219
    ld de, $0000                                  ; $621C
    call SpaceFever_MoveEnemies                   ; $621F

jr_007_6222:
    ld bc, SpaceFever_Boss_Play_Tbl62A9           ; $6222
    ld de, $0000                                  ; $6225
    call SpaceFever_DrawEnemies                   ; $6228
    ld a, [wSpriteAnimFrame + $2]                 ; $622B
    cp $05                                        ; $622E
    jr nz, jr_007_624b                            ; $6230

    ld a, [wShootBossTimer]                       ; $6232
    inc a                                         ; $6235
    cp $32                                        ; $6236
    jr nz, jr_007_6248                            ; $6238

    ld a, $0c                                     ; $623A
    ld [wSpriteAnimFrame + $2], a                 ; $623C
    push af                                       ; $623F
    ld a, SFX1_CURSOR_MOVE                        ; $6240
    call Snd_Sfx1                                 ; $6242
    pop af                                        ; $6245
    jr jr_007_624b                                ; $6246

jr_007_6248:
    ld [wShootBossTimer], a                       ; $6248

jr_007_624b:
    call SpaceFever_DrawBullets                   ; $624B
    ld a, [wShootFinishedMask]                    ; $624E
    and $01                                       ; $6251
    cp $01                                        ; $6253
    call z, SpaceFever_Boss_StartFinalPass        ; $6255
    ld a, [wSpriteAnimFrame + $2]                 ; $6258
    cp $14                                        ; $625B
    ret c                                         ; $625D

    ld a, $0a                                     ; $625E
    ld [wShootWaveState], a                       ; $6260
    ld a, [wShootRound]                           ; $6263
    cp $07                                        ; $6266
    jr z, jr_007_626e                             ; $6268

    inc a                                         ; $626A
    ld [wShootRound], a                           ; $626B

jr_007_626e:
    ld a, [wShootBossVariant]                     ; $626E
    inc a                                         ; $6271
    cp $03                                        ; $6272
    jr nz, jr_007_6277                            ; $6274

    xor a                                         ; $6276

jr_007_6277:
    ld [wShootBossVariant], a                     ; $6277
    ret                                           ; $627A


; C: path pos := $4500. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
SpaceFever_Boss_StartFinalPass::
    ld hl, wShootPathPos                          ; $627B
    xor a                                         ; $627E
    ld [hl+], a                                   ; $627F
    ld a, $45                                     ; $6280
    ld [hl], a                                    ; $6282
    ld hl, wShootFinishedMask                     ; $6283
    res 0, [hl]                                   ; $6286
    ret                                           ; $6288


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SpaceFever_Boss_EnemyFire::
    ld de, $0000                                  ; $6289
    ld hl, wShootEnemyState                       ; $628C
    ld a, [hl]                                    ; $628F
    and a                                         ; $6290
    jr nz, jr_007_62a8                            ; $6291

    call SpaceFever_CountBullets                  ; $6293
    cp $03                                        ; $6296
    jr nc, jr_007_62a8                            ; $6298

    ldh a, [hFrameCounter]                        ; $629A
    and $0f                                       ; $629C
    jr nz, jr_007_62a8                            ; $629E

    call Rng_Next                                 ; $62A0
    cp $50                                        ; $62A3
    call c, SpaceFever_FireBulletPair             ; $62A5

jr_007_62a8:
    ret                                           ; $62A8


; C: auto: 44 bytes, bytes; referenced by SpaceFever_Boss_Play. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00
; 07 12)
SpaceFever_Boss_Play_Tbl62A9::
    db $63, $20, $64, $20, $ff, $00, $62, $08, $ff, $00, $62, $01, $68, $01, $69, $01
    db $6a, $01, $69, $01, $68, $01, $ff, $05, $62, $01, $68, $01, $69, $01, $6a, $01
    db $5a, $03, $5b, $04, $5c, $04, $00, $10, $00, $10, $ff, $14

; C: state 10: boss gone; back to wave state 2 (README 16.18)
SpaceFever_Boss_EndA::
    ld a, [wSpriteAnimFrame]                      ; $62D5
    cp $02                                        ; $62D8
    jr c, jr_007_62e2                             ; $62DA

    ld a, $02                                     ; $62DC
    ld [wShootWaveState], a                       ; $62DE
    ret                                           ; $62E1


jr_007_62e2:
    ld a, [wShootBossVariant]                     ; $62E2
    and a                                         ; $62E5
    jr z, jr_007_62f5                             ; $62E6

    push af                                       ; $62E8
    ld a, MUSIC_SPACE_FEVER_MAIN                  ; $62E9
    call Snd_Music                                ; $62EB
    pop af                                        ; $62EE
    ld a, $02                                     ; $62EF
    ld [wShootWaveState], a                       ; $62F1
    ret                                           ; $62F4


jr_007_62f5:
    push af                                       ; $62F5
    ld a, MUSIC_SPACE_FEVER_MAIN                  ; $62F6
    call Snd_Music                                ; $62F8
    pop af                                        ; $62FB
    xor a                                         ; $62FC
    ld [wSpriteAnimFrame + $2], a                 ; $62FD
    ld [wSpriteAnimTick + $2], a                  ; $6300
    ld a, BANK(Map_25_5820_SpaceFever_Boss_EndB)  ; $6303
    ld hl, Map_25_5820_SpaceFever_Boss_EndB       ; $6305
    ld de, $98c0                                  ; $6308
    ld bc, $0014                                  ; $630B
    call Vram_CopyFromBank                        ; $630E
    ld hl, wShootWaveState                        ; $6311
    inc [hl]                                      ; $6314
    ret                                           ; $6315


; C: state 11
SpaceFever_Boss_EndB::
    ld a, [wSpriteAnimFrame]                      ; $6316
    cp $02                                        ; $6319
    jr c, jr_007_6323                             ; $631B

    ld a, $02                                     ; $631D
    ld [wShootWaveState], a                       ; $631F
    ret                                           ; $6322


jr_007_6323:
    ld a, [wSpriteAnimFrame + $2]                 ; $6323
    ld c, a                                       ; $6326
    ld b, $00                                     ; $6327
    ld hl, SpaceFever_Boss_EndFrameLimitTbl       ; $6329
    add hl, bc                                    ; $632C
    ld a, [wSpriteAnimTick + $2]                  ; $632D
    cp [hl]                                       ; $6330
    jr c, jr_007_6360                             ; $6331

    inc hl                                        ; $6333
    ld a, [hl]                                    ; $6334
    and a                                         ; $6335
    jr z, jr_007_6365                             ; $6336

    inc c                                         ; $6338
    ld a, c                                       ; $6339
    ld [wSpriteAnimFrame + $2], a                 ; $633A
    bit 0, a                                      ; $633D
    jr nz, jr_007_6351                            ; $633F

    ld a, BANK(Map_25_5820_SpaceFever_Boss_EndB)  ; $6341
    ld hl, Map_25_5820_SpaceFever_Boss_EndB       ; $6343
    ld de, $98c0                                  ; $6346
    ld bc, $0014                                  ; $6349
    call Vram_CopyFromBank                        ; $634C
    jr jr_007_635f                                ; $634F

jr_007_6351:
    ld a, BANK(Map_25_5680_SpaceFever_Boss_EndB)  ; $6351
    ld hl, Map_25_5680_SpaceFever_Boss_EndB       ; $6353
    ld de, $98c0                                  ; $6356
    ld bc, $0014                                  ; $6359
    call Vram_CopyFromBank                        ; $635C

jr_007_635f:
    xor a                                         ; $635F

jr_007_6360:
    inc a                                         ; $6360
    ld [wSpriteAnimTick + $2], a                  ; $6361
    ret                                           ; $6364


jr_007_6365:
    ld a, BANK(Map_25_5680_SpaceFever_Boss_EndB)  ; $6365
    ld hl, Map_25_5680_SpaceFever_Boss_EndB       ; $6367
    ld de, $98c0                                  ; $636A
    ld bc, $0014                                  ; $636D
    call Vram_CopyFromBank                        ; $6370
    ld a, $02                                     ; $6373
    ld [wShootWaveState], a                       ; $6375
    ret                                           ; $6378


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; frame limits of the boss end sequence (read at jr_007_6323)
SpaceFever_Boss_EndFrameLimitTbl::
    db $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $f0, $00

; C: steps the path of each enemy
SpaceFever_MoveEnemies::
    ld hl, wShootStartDelay                       ; $6387
    ld a, [hl]                                    ; $638A
    and a                                         ; $638B
    jr z, jr_007_6390                             ; $638C

    dec [hl]                                      ; $638E
    ret                                           ; $638F


jr_007_6390:
    push bc                                       ; $6390
    ld hl, wShootPathSpeed                        ; $6391
    add hl, de                                    ; $6394
    ld c, [hl]                                    ; $6395
    ld b, $00                                     ; $6396
    sla c                                         ; $6398
    rl b                                          ; $639A
    ld hl, wShootPathPos                          ; $639C
    add hl, de                                    ; $639F
    add hl, de                                    ; $63A0
    ld a, c                                       ; $63A1
    add [hl]                                      ; $63A2
    ld [hl], a                                    ; $63A3
    inc hl                                        ; $63A4
    ld a, b                                       ; $63A5
    adc [hl]                                      ; $63A6
    ld [hl], a                                    ; $63A7
    pop bc                                        ; $63A8
    call SpaceFever_MoveEnemy                     ; $63A9
    dec e                                         ; $63AC
    bit 7, e                                      ; $63AD
    jr z, SpaceFever_MoveEnemies                  ; $63AF

    ret                                           ; $63B1


; C: path point to screen x;y with offsets and mirror
SpaceFever_MoveEnemy::
    ld hl, wShootPathPos + $1                     ; $63B2
    add hl, de                                    ; $63B5
    add hl, de                                    ; $63B6
    ld a, [hl]                                    ; $63B7
    ld hl, wShootPathEnd                          ; $63B8
    add hl, de                                    ; $63BB
    cp [hl]                                       ; $63BC
    jr c, jr_007_63ca                             ; $63BD

    ld hl, SpaceFever_MoveEnemy_Tbl641C           ; $63BF
    add hl, de                                    ; $63C2
    ld a, [hl]                                    ; $63C3
    ld hl, wShootFinishedMask                     ; $63C4
    or [hl]                                       ; $63C7
    ld [hl], a                                    ; $63C8
    ret                                           ; $63C9


jr_007_63ca:
    ld hl, wShootEnemyState                       ; $63CA
    add hl, de                                    ; $63CD
    ld a, [hl]                                    ; $63CE
    and a                                         ; $63CF
    ret nz                                        ; $63D0

    ld hl, wShootPathMirror                       ; $63D1
    add hl, de                                    ; $63D4
    ld a, [hl]                                    ; $63D5
    ld hl, wShootPathPos + $1                     ; $63D6
    add hl, de                                    ; $63D9
    add hl, de                                    ; $63DA
    ld l, [hl]                                    ; $63DB
    ld h, $00                                     ; $63DC
    sla l                                         ; $63DE
    rl h                                          ; $63E0
    add hl, bc                                    ; $63E2
    bit 7, a                                      ; $63E3
    jr nz, jr_007_6400                            ; $63E5

    ld a, [hl+]                                   ; $63E7
    push hl                                       ; $63E8
    ld hl, wShootEnemyBaseX                       ; $63E9
    add hl, de                                    ; $63EC
    add [hl]                                      ; $63ED
    ld hl, wShootEnemyX                           ; $63EE
    add hl, de                                    ; $63F1
    ld [hl], a                                    ; $63F2
    pop hl                                        ; $63F3
    ld a, [hl]                                    ; $63F4
    ld hl, wShootEnemyBaseY                       ; $63F5
    add hl, de                                    ; $63F8
    add [hl]                                      ; $63F9
    ld hl, wShootEnemyY                           ; $63FA
    add hl, de                                    ; $63FD
    ld [hl], a                                    ; $63FE
    ret                                           ; $63FF


jr_007_6400:
    ld a, [hl+]                                   ; $6400
    push hl                                       ; $6401
    ld hl, wShootEnemyBaseX                       ; $6402
    add hl, de                                    ; $6405
    add [hl]                                      ; $6406
    ld hl, wShootEnemyX                           ; $6407
    add hl, de                                    ; $640A
    cpl                                           ; $640B
    add $51                                       ; $640C
    ld [hl], a                                    ; $640E
    pop hl                                        ; $640F
    ld a, [hl]                                    ; $6410
    ld hl, wShootEnemyBaseY                       ; $6411
    add hl, de                                    ; $6414
    add [hl]                                      ; $6415
    ld hl, wShootEnemyY                           ; $6416
    add hl, de                                    ; $6419
    ld [hl], a                                    ; $641A
    ret                                           ; $641B


; C: auto: 8 bytes, bytes; referenced by SpaceFever_MoveEnemy. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_MoveEnemy_Tbl641C::
    db $01, $02, $04, $08, $10, $20, $40, $80

; C: sprite x = value + $48
SpaceFever_DrawEnemies::
    push bc                                       ; $6424
    ld hl, wSpriteAnimFrame + $2                  ; $6425
    add hl, de                                    ; $6428
    ld l, [hl]                                    ; $6429
    sla l                                         ; $642A
    ld h, $00                                     ; $642C
    add hl, bc                                    ; $642E
    ld a, [hl+]                                   ; $642F
    push hl                                       ; $6430
    push af                                       ; $6431
    ld hl, wShootEnemyX                           ; $6432
    add hl, de                                    ; $6435
    ld a, [hl]                                    ; $6436
    cp $b0                                        ; $6437
    jr c, jr_007_643d                             ; $6439

    ld a, $60                                     ; $643B

jr_007_643d:
    add $48                                       ; $643D
    ld b, a                                       ; $643F
    ld hl, wShootEnemyY                           ; $6440
    add hl, de                                    ; $6443
    ld c, [hl]                                    ; $6444
    pop af                                        ; $6445
    push de                                       ; $6446
    and a                                         ; $6447
    call nz, SpaceFever_DrawEnemySprite           ; $6448
    pop de                                        ; $644B
    ld hl, wSpriteAnimTick + $2                   ; $644C
    add hl, de                                    ; $644F
    ld a, [hl]                                    ; $6450
    pop hl                                        ; $6451
    cp [hl]                                       ; $6452
    jr c, jr_007_6463                             ; $6453

    inc hl                                        ; $6455
    ld a, [hl+]                                   ; $6456
    inc a                                         ; $6457
    ld a, [hl]                                    ; $6458
    ld hl, wSpriteAnimFrame + $2                  ; $6459
    add hl, de                                    ; $645C
    jr z, jr_007_6461                             ; $645D

    ld a, [hl]                                    ; $645F
    inc a                                         ; $6460

jr_007_6461:
    ld [hl], a                                    ; $6461
    xor a                                         ; $6462

jr_007_6463:
    inc a                                         ; $6463
    ld hl, wSpriteAnimTick + $2                   ; $6464
    add hl, de                                    ; $6467
    ld [hl], a                                    ; $6468
    pop bc                                        ; $6469
    dec e                                         ; $646A
    bit 7, e                                      ; $646B
    jr z, SpaceFever_DrawEnemies                  ; $646D

    ret                                           ; $646F


; C: sprite ids from $62 up are boss pieces
SpaceFever_DrawEnemySprite::
    cp $62                                        ; $6470
    jp c, Oam_AddMeta_B01_5D47                    ; $6472

    push af                                       ; $6475
    sub $62                                       ; $6476
    ld [wShootBossMaskIdx], a                     ; $6478
    ld a, b                                       ; $647B
    cp $60                                        ; $647C
    jr c, jr_007_6484                             ; $647E

    pop af                                        ; $6480
    jp Oam_AddMeta_B01_5D47                       ; $6481


jr_007_6484:
    pop af                                        ; $6484
    add $03                                       ; $6485
    jp Oam_AddMeta_B01_5D47                       ; $6487


; C: round-robin of 8 bullet slots
SpaceFever_FireBullet::
    ld hl, wShootBulletRr                         ; $648A
    inc [hl]                                      ; $648D
    ld a, [hl]                                    ; $648E
    and $07                                       ; $648F
    ld c, a                                       ; $6491
    ld b, $00                                     ; $6492
    ld hl, wShootBulletY                          ; $6494
    add hl, bc                                    ; $6497
    ld a, [hl]                                    ; $6498
    cp $a0                                        ; $6499
    ret c                                         ; $649B

    ld hl, wShootEnemyY                           ; $649C
    add hl, de                                    ; $649F
    ld a, [hl]                                    ; $64A0
    cp $a0                                        ; $64A1
    ret nc                                        ; $64A3

    ld hl, wShootEnemyX                           ; $64A4
    add hl, de                                    ; $64A7
    ld a, [hl]                                    ; $64A8
    cp $50                                        ; $64A9
    ret nc                                        ; $64AB

    ld hl, wShootEnemyX                           ; $64AC
    add hl, de                                    ; $64AF
    ld a, [hl]                                    ; $64B0
    ld hl, wShootBulletX                          ; $64B1
    add hl, bc                                    ; $64B4
    ld [hl], a                                    ; $64B5
    ld hl, wShootEnemyY                           ; $64B6
    add hl, de                                    ; $64B9
    ld a, [hl]                                    ; $64BA
    ld hl, wShootBulletY                          ; $64BB
    add hl, bc                                    ; $64BE
    ld [hl], a                                    ; $64BF
    ret                                           ; $64C0


; C
SpaceFever_ClearBullets::
    ld a, $a0                                     ; $64C1
    ld hl, wShootBulletY                          ; $64C3
    ld b, $08                                     ; $64C6

jr_007_64c8:
    ld [hl+], a                                   ; $64C8
    dec b                                         ; $64C9
    jr nz, jr_007_64c8                            ; $64CA

    ret                                           ; $64CC


; C: A = bullets on screen
SpaceFever_CountBullets::
    ld hl, wShootBulletY                          ; $64CD
    ld bc, $0800                                  ; $64D0

jr_007_64d3:
    ld a, [hl+]                                   ; $64D3
    cp $a0                                        ; $64D4
    jr nc, jr_007_64d9                            ; $64D6

    inc c                                         ; $64D8

jr_007_64d9:
    dec b                                         ; $64D9
    jr nz, jr_007_64d3                            ; $64DA

    ld a, c                                       ; $64DC
    ret                                           ; $64DD


; C: alternates single / pair at x-16; x+16
SpaceFever_FireBulletPair::
    xor a                                         ; $64DE
    ldh [hScratchA], a                            ; $64DF
    ld a, [wShootBulletPairToggle]                ; $64E1
    inc a                                         ; $64E4
    and $01                                       ; $64E5
    ld [wShootBulletPairToggle], a                ; $64E7
    jr z, SpaceFever_FireBulletAt                 ; $64EA

    ld a, $f0                                     ; $64EC
    ldh [hScratchA], a                            ; $64EE
    call SpaceFever_FireBulletAt                  ; $64F0
    ld a, $10                                     ; $64F3
    ldh [hScratchA], a                            ; $64F5

; C: spawns one bullet slot from enemy DE with the x offset in scratch_a ($FF8A); called twice by
; SpaceFever_FireBulletPair (single bullet: falls through from the toggle). L3 pass 2026-10-26: not reached by the 206
; BGB replays; executed in the organic runs of the core emulator ...
SpaceFever_FireBulletAt::
    ld hl, wShootBulletRr                         ; $64F7
    inc [hl]                                      ; $64FA
    ld a, [hl]                                    ; $64FB
    and $07                                       ; $64FC
    ld c, a                                       ; $64FE
    ld b, $00                                     ; $64FF
    ld hl, wShootBulletY                          ; $6501
    add hl, bc                                    ; $6504
    ld a, [hl]                                    ; $6505
    cp $a0                                        ; $6506
    ret c                                         ; $6508

    ld hl, wShootEnemyY                           ; $6509
    add hl, de                                    ; $650C
    ld a, [hl]                                    ; $650D
    cp $a0                                        ; $650E
    ret nc                                        ; $6510

    ld hl, wShootEnemyX                           ; $6511
    add hl, de                                    ; $6514
    ld a, [hl]                                    ; $6515
    cp $50                                        ; $6516
    ret nc                                        ; $6518

    ld hl, wShootEnemyX                           ; $6519
    add hl, de                                    ; $651C
    ld a, [hl]                                    ; $651D
    ld hl, hScratchA                              ; $651E
    add [hl]                                      ; $6521
    ld hl, wShootBulletX                          ; $6522
    add hl, bc                                    ; $6525
    ld [hl], a                                    ; $6526
    ld hl, wShootEnemyY                           ; $6527
    add hl, de                                    ; $652A
    ld a, [hl]                                    ; $652B
    ld hl, wShootBulletY                          ; $652C
    add hl, bc                                    ; $652F
    ld [hl], a                                    ; $6530
    ret                                           ; $6531


; C: 2 px down per frame; sprite $5D
SpaceFever_DrawBullets::
    ld de, $0007                                  ; $6532

jr_007_6535:
    ld hl, wShootBulletY                          ; $6535
    add hl, de                                    ; $6538
    ld a, [hl]                                    ; $6539
    cp $a0                                        ; $653A
    jr nc, jr_007_6551                            ; $653C

    inc a                                         ; $653E
    inc a                                         ; $653F
    ld [hl], a                                    ; $6540
    ld c, a                                       ; $6541
    ld hl, wShootBulletX                          ; $6542
    add hl, de                                    ; $6545
    ld a, [hl]                                    ; $6546
    add $48                                       ; $6547
    ld b, a                                       ; $6549
    ld a, $5d                                     ; $654A
    push de                                       ; $654C
    call Oam_AddMeta_B01_5D47                     ; $654D
    pop de                                        ; $6550

jr_007_6551:
    dec e                                         ; $6551
    bit 7, e                                      ; $6552
    jr z, jr_007_6535                             ; $6554

    ret                                           ; $6556


; C: run-length delta list to $CE00 x;y pairs (README 2.4)
SpaceFever_DecodePath::
    xor a                                         ; $6557
    ld b, $02                                     ; $6558
    push de                                       ; $655A

jr_007_655b:
    ld c, [hl]                                    ; $655B
    inc hl                                        ; $655C
    inc c                                         ; $655D
    dec c                                         ; $655E
    jr z, jr_007_657d                             ; $655F

    bit 7, c                                      ; $6561
    jr nz, jr_007_656f                            ; $6563

jr_007_6565:
    add [hl]                                      ; $6565
    ld [de], a                                    ; $6566
    inc hl                                        ; $6567
    inc de                                        ; $6568
    inc de                                        ; $6569
    dec c                                         ; $656A
    jr nz, jr_007_6565                            ; $656B

    jr jr_007_655b                                ; $656D

jr_007_656f:
    res 7, c                                      ; $656F
    inc c                                         ; $6571
    inc c                                         ; $6572

jr_007_6573:
    add [hl]                                      ; $6573
    ld [de], a                                    ; $6574
    inc de                                        ; $6575
    inc de                                        ; $6576
    dec c                                         ; $6577
    jr nz, jr_007_6573                            ; $6578

    inc hl                                        ; $657A
    jr jr_007_655b                                ; $657B

jr_007_657d:
    pop de                                        ; $657D
    inc de                                        ; $657E
    push de                                       ; $657F
    xor a                                         ; $6580
    dec b                                         ; $6581
    jr nz, jr_007_655b                            ; $6582

    pop de                                        ; $6584
    ret                                           ; $6585


; C: shots vs enemies; enemies vs player; bullets vs player/shots
SpaceFever_Collide_Waves::
    call SpaceFever_ShotVsEnemy                   ; $6586
    call SpaceFever_EnemyVsPlayer                 ; $6589
    call SpaceFever_BulletVsPlayer                ; $658C
    call SpaceFever_ShotVsBullet                  ; $658F
    ret                                           ; $6592


; C: shots vs boss; player collisions
SpaceFever_Collide_Boss::
    call SpaceFever_ShotVsBoss                    ; $6593
    call SpaceFever_EnemyVsPlayer                 ; $6596
    call SpaceFever_BulletVsPlayer                ; $6599
    call SpaceFever_ShotVsBullet                  ; $659C
    ret                                           ; $659F


; C
SpaceFever_ShotVsEnemy::
    ld de, $0007                                  ; $65A0

jr_007_65a3:
    ld hl, wShootShotY                            ; $65A3
    add hl, de                                    ; $65A6
    ld a, [hl]                                    ; $65A7
    cp $fc                                        ; $65A8
    jr nc, jr_007_65d2                            ; $65AA

    ld bc, $0002                                  ; $65AC

jr_007_65af:
    push af                                       ; $65AF
    ld hl, wShootEnemyY                           ; $65B0
    add hl, bc                                    ; $65B3
    sub [hl]                                      ; $65B4
    add $08                                       ; $65B5
    cp $10                                        ; $65B7
    jr nc, jr_007_65cc                            ; $65B9

    ld hl, wShootShotX                            ; $65BB
    add hl, de                                    ; $65BE
    ld a, [hl]                                    ; $65BF
    ld hl, wShootEnemyX                           ; $65C0
    add hl, bc                                    ; $65C3
    sub [hl]                                      ; $65C4
    add $06                                       ; $65C5
    cp $0c                                        ; $65C7
    call c, SpaceFever_EnemyHit                   ; $65C9

jr_007_65cc:
    pop af                                        ; $65CC
    dec c                                         ; $65CD
    bit 7, c                                      ; $65CE
    jr z, jr_007_65af                             ; $65D0

jr_007_65d2:
    dec e                                         ; $65D2
    bit 7, e                                      ; $65D3
    jr z, jr_007_65a3                             ; $65D5

    ret                                           ; $65D7


; C: double-shot bonus
SpaceFever_EnemyHit::
    ld hl, wShootEnemyState                       ; $65D8
    add hl, bc                                    ; $65DB
    ld a, [hl]                                    ; $65DC
    and a                                         ; $65DD
    ret nz                                        ; $65DE

    ld [hl], $01                                  ; $65DF
    ld hl, wShootShotY                            ; $65E1
    add hl, de                                    ; $65E4
    ld [hl], $fc                                  ; $65E5
    ld a, [wShootFireCount]                       ; $65E7
    bit 0, a                                      ; $65EA
    jr z, jr_007_6614                             ; $65EC

    ld a, [wShootDoubleHits]                      ; $65EE
    inc a                                         ; $65F1
    ld [wShootDoubleHits], a                      ; $65F2
    cp $02                                        ; $65F5
    jr nz, jr_007_6614                            ; $65F7

    ld hl, wShootEnemyState                       ; $65F9
    add hl, bc                                    ; $65FC
    set 7, [hl]                                   ; $65FD
    ld a, $2d                                     ; $65FF
    ld [wShootFlashTimer], a                      ; $6601
    ld hl, wShootEnemyX                           ; $6604
    add hl, bc                                    ; $6607
    ld a, [hl]                                    ; $6608
    ld [wShootFlashXy], a                         ; $6609
    ld hl, wShootEnemyY                           ; $660C
    add hl, bc                                    ; $660F
    ld a, [hl]                                    ; $6610
    ld [wShootFlashXy + $1], a                    ; $6611

jr_007_6614:
    ld c, $00                                     ; $6614
    ret                                           ; $6616


; C
SpaceFever_EnemyVsPlayer::
    ld a, [wSpriteAnimFrame]                      ; $6617
    cp $02                                        ; $661A
    ret nc                                        ; $661C

    ld a, $88                                     ; $661D
    ld bc, $0002                                  ; $661F

jr_007_6622:
    push af                                       ; $6622
    ld hl, wShootEnemyY                           ; $6623
    add hl, bc                                    ; $6626
    sub [hl]                                      ; $6627
    add $06                                       ; $6628
    cp $0c                                        ; $662A
    jr nc, jr_007_663d                            ; $662C

    ld a, [wShootPlayerX]                         ; $662E
    ld hl, wShootEnemyX                           ; $6631
    add hl, bc                                    ; $6634
    sub [hl]                                      ; $6635
    add $06                                       ; $6636
    cp $0c                                        ; $6638
    call c, SpaceFever_PlayerDie                  ; $663A

jr_007_663d:
    pop af                                        ; $663D
    dec c                                         ; $663E
    bit 7, c                                      ; $663F
    jr z, jr_007_6622                             ; $6641

    ret                                           ; $6643


; C
SpaceFever_PlayerDie::
    ld a, $02                                     ; $6644
    ld [wSpriteAnimFrame], a                      ; $6646
    xor a                                         ; $6649
    ld [wSpriteAnimTick], a                       ; $664A
    ld a, $01                                     ; $664D
    ld [wShootPlayerDied], a                      ; $664F
    push af                                       ; $6652
    ld a, SFX4_SPACE_FEVER_PLAYER_DEATH           ; $6653
    call Snd_Sfx4                                 ; $6655
    pop af                                        ; $6658
    ret                                           ; $6659


; C
SpaceFever_BulletVsPlayer::
    ld a, [wSpriteAnimFrame]                      ; $665A
    cp $02                                        ; $665D
    ret nc                                        ; $665F

    ld a, $88                                     ; $6660
    ld bc, $0007                                  ; $6662

jr_007_6665:
    push af                                       ; $6665
    ld hl, wShootBulletY                          ; $6666
    add hl, bc                                    ; $6669
    sub [hl]                                      ; $666A
    add $08                                       ; $666B
    cp $10                                        ; $666D
    jr nc, jr_007_6680                            ; $666F

    ld a, [wShootPlayerX]                         ; $6671
    ld hl, wShootBulletX                          ; $6674
    add hl, bc                                    ; $6677
    sub [hl]                                      ; $6678
    add $04                                       ; $6679
    cp $08                                        ; $667B
    call c, SpaceFever_PlayerDieB                 ; $667D

jr_007_6680:
    pop af                                        ; $6680
    dec c                                         ; $6681
    bit 7, c                                      ; $6682
    jr z, jr_007_6665                             ; $6684

    ret                                           ; $6686


; C: duplicate of 6644
SpaceFever_PlayerDieB::
    ld a, $02                                     ; $6687
    ld [wSpriteAnimFrame], a                      ; $6689
    xor a                                         ; $668C
    ld [wSpriteAnimTick], a                       ; $668D
    ld a, $01                                     ; $6690
    ld [wShootPlayerDied], a                      ; $6692
    push af                                       ; $6695
    ld a, SFX4_SPACE_FEVER_PLAYER_DEATH           ; $6696
    call Snd_Sfx4                                 ; $6698
    pop af                                        ; $669B
    ret                                           ; $669C


; C
SpaceFever_ShotVsBullet::
    ld de, $0007                                  ; $669D

jr_007_66a0:
    ld hl, wShootShotY                            ; $66A0
    add hl, de                                    ; $66A3
    ld a, [hl]                                    ; $66A4
    cp $fc                                        ; $66A5
    jr nc, jr_007_66cf                            ; $66A7

    ld bc, $0007                                  ; $66A9

jr_007_66ac:
    push af                                       ; $66AC
    ld hl, wShootBulletY                          ; $66AD
    add hl, bc                                    ; $66B0
    sub [hl]                                      ; $66B1
    add $03                                       ; $66B2
    cp $06                                        ; $66B4
    jr nc, jr_007_66c9                            ; $66B6

    ld hl, wShootShotX                            ; $66B8
    add hl, de                                    ; $66BB
    ld a, [hl]                                    ; $66BC
    ld hl, wShootBulletX                          ; $66BD
    add hl, bc                                    ; $66C0
    sub [hl]                                      ; $66C1
    add $03                                       ; $66C2
    cp $06                                        ; $66C4
    call c, SpaceFever_ShotCancelsBullet          ; $66C6

jr_007_66c9:
    pop af                                        ; $66C9
    dec c                                         ; $66CA
    bit 7, c                                      ; $66CB
    jr z, jr_007_66ac                             ; $66CD

jr_007_66cf:
    dec e                                         ; $66CF
    bit 7, e                                      ; $66D0
    jr z, jr_007_66a0                             ; $66D2

    ret                                           ; $66D4


; C
SpaceFever_ShotCancelsBullet::
    push bc                                       ; $66D5
    ld a, $01                                     ; $66D6
    call SpaceFever_AddScore                      ; $66D8
    pop bc                                        ; $66DB
    ld hl, wShootBulletY                          ; $66DC
    add hl, bc                                    ; $66DF
    ld [hl], $a0                                  ; $66E0
    ld hl, wShootShotY                            ; $66E2
    add hl, de                                    ; $66E5
    ld [hl], $fc                                  ; $66E6
    ret                                           ; $66E8


; C: only in wave state 9
SpaceFever_ShotVsBoss::
    ld a, [wSpriteAnimFrame + $2]                 ; $66E9
    cp $05                                        ; $66EC
    ret nc                                        ; $66EE

    ld bc, $0007                                  ; $66EF

jr_007_66f2:
    ld hl, wShootShotY                            ; $66F2
    add hl, bc                                    ; $66F5
    ld a, [hl]                                    ; $66F6
    cp $fc                                        ; $66F7
    jr nc, jr_007_6735                            ; $66F9

    ld hl, wShootEnemyY                           ; $66FB
    sub [hl]                                      ; $66FE
    add $20                                       ; $66FF
    cp $38                                        ; $6701
    jr nc, jr_007_6735                            ; $6703

    and $f8                                       ; $6705
    ld e, a                                       ; $6707
    ld hl, wShootShotX                            ; $6708
    add hl, bc                                    ; $670B
    ld a, [hl]                                    ; $670C
    ld hl, wShootEnemyX                           ; $670D
    sub [hl]                                      ; $6710
    add $20                                       ; $6711
    cp $40                                        ; $6713
    jr nc, jr_007_6735                            ; $6715

    srl a                                         ; $6717
    srl a                                         ; $6719
    srl a                                         ; $671B
    add e                                         ; $671D
    ld e, a                                       ; $671E
    ld a, [wShootBossMaskIdx]                     ; $671F
    sla a                                         ; $6722
    sla a                                         ; $6724
    swap a                                        ; $6726
    add e                                         ; $6728
    ld e, a                                       ; $6729
    ld d, $00                                     ; $672A
    ld hl, wCollisionMask0                        ; $672C
    add hl, de                                    ; $672F
    ld a, [hl]                                    ; $6730
    and a                                         ; $6731
    call nz, SpaceFever_BossHit                   ; $6732

jr_007_6735:
    dec c                                         ; $6735
    bit 7, c                                      ; $6736
    jr z, jr_007_66f2                             ; $6738

    ret                                           ; $673A


; C: 50 hits kill it; bonus 50 x table[D88F]
SpaceFever_BossHit::
    ld hl, wShootBossHits                         ; $673B
    inc [hl]                                      ; $673E
    ld a, [wShootBossHits]                        ; $673F
    cp $32                                        ; $6742
    jr nc, jr_007_6759                            ; $6744

    push af                                       ; $6746
    ld a, SFX3_SPACE_FEVER_BOSS_HIT               ; $6747
    call Snd_Sfx3                                 ; $6749
    pop af                                        ; $674C
    ld hl, wSpriteAnimFrame + $2                  ; $674D
    ld [hl], $03                                  ; $6750
    ld hl, wSpriteAnimTick + $2                   ; $6752
    ld [hl], $00                                  ; $6755
    jr jr_007_678b                                ; $6757

jr_007_6759:
    push af                                       ; $6759
    ld a, SFX1_SPACE_FEVER_BOSS_DEATH             ; $675A
    call Snd_Sfx1                                 ; $675C
    pop af                                        ; $675F
    push bc                                       ; $6760
    push de                                       ; $6761
    ld c, $03                                     ; $6762
    call SpaceFever_LoadBossTilesC                ; $6764
    pop de                                        ; $6767
    pop bc                                        ; $6768
    ld hl, wSpriteAnimFrame + $2                  ; $6769
    ld [hl], $05                                  ; $676C
    ld hl, wSpriteAnimTick + $2                   ; $676E
    ld [hl], $00                                  ; $6771
    xor a                                         ; $6773
    ld [wShootBossTimer], a                       ; $6774
    push bc                                       ; $6777
    ld a, [wShootBossVariant]                     ; $6778
    ld c, a                                       ; $677B
    ld b, $00                                     ; $677C
    ld hl, SpaceFever_BossHit_Tbl6792             ; $677E
    add hl, bc                                    ; $6781
    ld c, [hl]                                    ; $6782
    ld a, $50                                     ; $6783
    call SpaceFever_AddScoreRepeat                ; $6785
    pop bc                                        ; $6788
    ld c, $00                                     ; $6789

jr_007_678b:
    ld hl, wShootShotY                            ; $678B
    add hl, bc                                    ; $678E
    ld [hl], $fc                                  ; $678F
    ret                                           ; $6791


; C: auto: 5 bytes, bytes; referenced by SpaceFever_BossHit. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: table read when the boss is hit (jr_007_6759)
SpaceFever_BossHit_Tbl6792::
    db $04, $08, $10, $20, $40

; C: compares the score with DAA0-DAA3 (SRAM $10C5)
SpaceFever_UpdateBest::
    ld de, wShootScoreBcd + $3                    ; $6797
    ld hl, wBestShooter + $3                      ; $679A
    ld b, $04                                     ; $679D

jr_007_679f:
    ld a, [de]                                    ; $679F
    cp [hl]                                       ; $67A0
    ret c                                         ; $67A1

    jr nz, jr_007_67aa                            ; $67A2

    dec de                                        ; $67A4
    dec hl                                        ; $67A5
    dec b                                         ; $67A6
    jr nz, jr_007_679f                            ; $67A7

    ret                                           ; $67A9


jr_007_67aa:
    ld de, wShootScoreBcd                         ; $67AA
    ld hl, wBestShooter                           ; $67AD
    ld b, $04                                     ; $67B0

jr_007_67b2:
    ld a, [de]                                    ; $67B2
    ld [hl+], a                                   ; $67B3
    inc de                                        ; $67B4
    dec b                                         ; $67B5
    jr nz, jr_007_67b2                            ; $67B6

    ld a, $01                                     ; $67B8
    ld [wShootNewBestFlag], a                     ; $67BA
    ret                                           ; $67BD


; C: repeated Bcd_AddSaturate
SpaceFever_AddScoreRepeat::
    dec c                                         ; $67BE

jr_007_67bf:
    push af                                       ; $67BF
    ld hl, wShootScoreBcd                         ; $67C0
    ld b, $04                                     ; $67C3
    call Bcd_AddSaturate                          ; $67C5
    pop af                                        ; $67C8
    dec c                                         ; $67C9
    jr nz, jr_007_67bf                            ; $67CA

; C: A = points (BCD) to $D868-$D86B; then draws at $980A
SpaceFever_AddScore::
    push de                                       ; $67CC
    ld hl, wShootScoreBcd                         ; $67CD
    ld b, $04                                     ; $67D0
    call Bcd_AddSaturate                          ; $67D2
    call SpaceFever_UpdateBest                    ; $67D5
    ld de, wShootScoreBcd + $3                    ; $67D8
    ld hl, $980a                                  ; $67DB
    call SpaceFever_DrawScore                     ; $67DE
    pop de                                        ; $67E1
    ret                                           ; $67E2


; C
SpaceFever_LoadHudTiles::
    ld a, BANK(Gfx_21_4750_SpaceFever_LoadHudTiles); $67E3
    ld hl, Gfx_21_4750_SpaceFever_LoadHudTiles    ; $67E5
    ld de, $9750                                  ; $67E8
    ld bc, $0060                                  ; $67EB
    call Vram_CopyFromBank                        ; $67EE
    ld a, BANK(Gfx_21_4850_SpaceFever_LoadHudTiles); $67F1
    ld hl, Gfx_21_4850_SpaceFever_LoadHudTiles    ; $67F3
    ld de, $8850                                  ; $67F6
    ld bc, $0060                                  ; $67F9
    call Vram_CopyFromBank                        ; $67FC
    ld a, BANK(Map_22_7F40_SpaceFever_LoadHudTiles); $67FF
    ld hl, Map_22_7F40_SpaceFever_LoadHudTiles    ; $6801
    ld de, $98c9                                  ; $6804
    ld b, $06                                     ; $6807
    call SpaceFever_CopyTextRows                  ; $6809
    ret                                           ; $680C


; C
SpaceFever_DrawGameOverHud::
    ld a, $27                                     ; $680D
    ld hl, $6870                                  ; $680F
    ld de, $9889                                  ; $6812
    ld b, $05                                     ; $6815
    call SpaceFever_CopyTextRows                  ; $6817
    ld de, wShootScoreBcd + $3                    ; $681A
    ld hl, $992a                                  ; $681D
    call SpaceFever_DrawScore                     ; $6820
    ld a, $27                                     ; $6823
    ld hl, SpaceFever_CopyBossTiles               ; $6825
    ld de, $9969                                  ; $6828
    ld b, $03                                     ; $682B
    call SpaceFever_CopyTextRows                  ; $682D
    ret                                           ; $6830


; C
SpaceFever_DrawBestHud::
    ld a, BANK(Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00); $6831
    ld hl, Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00; $6833
    ld de, $9750                                  ; $6836
    ld bc, $0060                                  ; $6839
    call Vram_CopyFromBank                        ; $683C
    ld a, BANK(Gfx_21_4C60_SpaceFever_DrawBestHud); $683F
    ld hl, Gfx_21_4C60_SpaceFever_DrawBestHud     ; $6841
    ld de, $8850                                  ; $6844
    ld bc, $0060                                  ; $6847
    call Vram_CopyFromBank                        ; $684A
    ld a, $27                                     ; $684D
    ld hl, $69b0                                  ; $684F
    ld de, $9889                                  ; $6852
    ld b, $05                                     ; $6855
    call SpaceFever_CopyTextRows                  ; $6857
    ld de, wBestShooter + $3                      ; $685A
    ld hl, $992a                                  ; $685D
    call SpaceFever_DrawScore                     ; $6860
    ld a, $27                                     ; $6863
    ld hl, $6a90                                  ; $6865
    ld de, $9969                                  ; $6868
    ld b, $03                                     ; $686B
    call SpaceFever_CopyTextRows                  ; $686D
    ret                                           ; $6870


; C: 8 BCD digits with leading zeros skipped
SpaceFever_DrawScore::
    ld bc, $040a                                  ; $6871

jr_007_6874:
    ld a, [de]                                    ; $6874
    swap a                                        ; $6875
    call SpaceFever_DrawDigit                     ; $6877
    ld a, b                                       ; $687A
    cp $01                                        ; $687B
    jr nz, jr_007_6881                            ; $687D

    ld c, $00                                     ; $687F

jr_007_6881:
    ld a, [de]                                    ; $6881
    call SpaceFever_DrawDigit                     ; $6882
    dec de                                        ; $6885
    dec b                                         ; $6886
    jr nz, jr_007_6874                            ; $6887

    ret                                           ; $6889


; C
SpaceFever_DrawDigit::
    push de                                       ; $688A
    push hl                                       ; $688B
    and $0f                                       ; $688C
    jr z, jr_007_6892                             ; $688E

    ld c, $00                                     ; $6890

jr_007_6892:
    or c                                          ; $6892
    sla a                                         ; $6893
    ld e, a                                       ; $6895
    ld d, $00                                     ; $6896
    ld hl, SpaceFever_DigitTileTbl                ; $6898
    add hl, de                                    ; $689B
    ld a, [hl+]                                   ; $689C
    ld e, [hl]                                    ; $689D
    pop hl                                        ; $689E
    push hl                                       ; $689F
    call Vram_WriteByteSafe                       ; $68A0
    ld a, l                                       ; $68A3
    add $20                                       ; $68A4
    ld l, a                                       ; $68A6
    jr nc, jr_007_68aa                            ; $68A7

    inc h                                         ; $68A9

jr_007_68aa:
    ld a, e                                       ; $68AA
    call Vram_WriteByteSafe                       ; $68AB
    pop hl                                        ; $68AE
    pop de                                        ; $68AF
    inc hl                                        ; $68B0
    ret                                           ; $68B1


; C: L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DigitTileTbl::
    db $60, $61, $62, $63, $64, $65, $64, $66, $67, $68, $69, $6a, $69, $57, $64, $63
    db $60, $58, $60, $68, $bf, $bf

; C
SpaceFever_DrawChoiceText::
    ld a, $25                                     ; $68C8
    ld hl, $5649                                  ; $68CA
    ld de, $9889                                  ; $68CD
    ld b, $0a                                     ; $68D0
    call SpaceFever_CopyTextRows                  ; $68D2
    ret                                           ; $68D5


; C: B rows of 10 tiles from bank A to HL
SpaceFever_CopyTextRows::
    push af                                       ; $68D6
    push bc                                       ; $68D7
    push de                                       ; $68D8
    push hl                                       ; $68D9
    ld bc, $000a                                  ; $68DA
    call Vram_CopyFromBank                        ; $68DD
    pop hl                                        ; $68E0
    pop de                                        ; $68E1
    pop bc                                        ; $68E2
    ld a, l                                       ; $68E3
    add $20                                       ; $68E4
    ld l, a                                       ; $68E6
    jr nc, jr_007_68ea                            ; $68E7

    inc h                                         ; $68E9

jr_007_68ea:
    ld a, e                                       ; $68EA
    add $20                                       ; $68EB
    ld e, a                                       ; $68ED
    jr nc, jr_007_68f1                            ; $68EE

    inc d                                         ; $68F0

jr_007_68f1:
    pop af                                        ; $68F1
    dec b                                         ; $68F2
    jr nz, SpaceFever_CopyTextRows                ; $68F3

    ret                                           ; $68F5


; C: VRAM $8000
SpaceFever_LoadBossTilesA::
    call SpaceFever_GetBossGfxBank                ; $68F6
    ldh [hFarcallAArg], a                         ; $68F9
    ld a, BANK(Photo_FarGetAddress)               ; $68FB
    ld hl, Photo_FarGetAddress                    ; $68FD
    call Far_Call                                 ; $6900
    ld de, $8000                                  ; $6903
    call SpaceFever_CopyBossTiles                 ; $6906
    ret                                           ; $6909


; C: VRAM $8400
SpaceFever_LoadBossTilesB::
    call SpaceFever_GetBossGfxBank                ; $690A
    ldh [hFarcallAArg], a                         ; $690D
    ld a, BANK(Photo_FarGetAddress)               ; $690F
    ld hl, Photo_FarGetAddress                    ; $6911
    call Far_Call                                 ; $6914
    ld de, $8400                                  ; $6917
    call SpaceFever_CopyBossTiles                 ; $691A
    ret                                           ; $691D


; C: VRAM $8C00
SpaceFever_LoadBossTilesC::
    call SpaceFever_GetBossGfxBank                ; $691E
    ldh [hFarcallAArg], a                         ; $6921
    ld a, BANK(Photo_FarGetAddress)               ; $6923
    ld hl, Photo_FarGetAddress                    ; $6925
    call Far_Call                                 ; $6928
    ld de, $8c00                                  ; $692B
    call SpaceFever_CopyBossTiles                 ; $692E
    ret                                           ; $6931


; C
SpaceFever_GetBossGfxBank::
    push bc                                       ; $6932
    ld a, [wShootBossVariant]                     ; $6933
    cp $02                                        ; $6936
    jr nz, jr_007_6942                            ; $6938

    ld hl, wGamefacePresent                       ; $693A
    bit 0, [hl]                                   ; $693D
    jr nz, jr_007_6942                            ; $693F

    inc a                                         ; $6941

jr_007_6942:
    ld c, a                                       ; $6942
    ld b, $00                                     ; $6943
    ld hl, SpaceFever_BossGfxBankTbl              ; $6945
    add hl, bc                                    ; $6948
    ld a, [hl]                                    ; $6949
    pop bc                                        ; $694A
    ret                                           ; $694B


; C: 05 04 06 01
SpaceFever_BossGfxBankTbl::
    db $05, $04, $06, $01

; C
SpaceFever_CopyBossTiles::
    ldh [hScratchA], a                            ; $6950
    ld b, $03                                     ; $6952

jr_007_6954:
    push bc                                       ; $6954
    ld c, $08                                     ; $6955

jr_007_6957:
    push bc                                       ; $6957
    ld bc, $0010                                  ; $6958
    ldh a, [hScratchA]                            ; $695B
    call Vram_CopyFromBank_4                      ; $695D
    ld bc, $0070                                  ; $6960
    add hl, bc                                    ; $6963
    ld bc, $0010                                  ; $6964
    ldh a, [hScratchA]                            ; $6967
    call Vram_CopyFromBank_4                      ; $6969
    ld bc, $ff80                                  ; $696C
    add hl, bc                                    ; $696F
    pop bc                                        ; $6970
    dec c                                         ; $6971
    jr nz, jr_007_6957                            ; $6972

    ld bc, $0080                                  ; $6974
    add hl, bc                                    ; $6977
    pop bc                                        ; $6978
    dec b                                         ; $6979
    jr nz, jr_007_6954                            ; $697A

    ld b, $08                                     ; $697C

jr_007_697e:
    push bc                                       ; $697E
    ld bc, $0010                                  ; $697F
    ldh a, [hScratchA]                            ; $6982
    call Vram_CopyFromBank_4                      ; $6984
    call SpaceFever_ClearVramBlock                ; $6987
    pop bc                                        ; $698A
    dec b                                         ; $698B
    jr nz, jr_007_697e                            ; $698C

    ret                                           ; $698E


; C: L3 pass 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_ClearVramBlock::
    push hl                                       ; $698F
    ld h, d                                       ; $6990
    ld l, e                                       ; $6991
    ld bc, $0010                                  ; $6992
    call Vram_ClearSafe                           ; $6995
    ld d, h                                       ; $6998
    ld e, l                                       ; $6999
    pop hl                                        ; $699A
    ret                                           ; $699B


; C: save-photo dialog (far call from banks 3/4; 6 substates)
SaveDialog_Far::
    ld a, [wSubstate]                             ; $699C
    rst Rst18_JumpTable                           ; $699F

; C
SaveDialog_SubstateTbl::
    dw SaveDialog_Substate0_Init
    dw SaveDialog_Substate1_WaitKey
    dw SaveDialog_Substate2_Answer
    dw SaveDialog_Substate3_FullInit
    dw SaveDialog_Substate4_WaitKey
    dw SaveDialog_Substate5_Finish

; C: album full (>= $1E) goes to substate 3
SaveDialog_Substate0_Init::
    ld a, [wSaveTargetPhoto]                      ; $69AC
    cp $1e                                        ; $69AF
    jr c, jr_007_69bb                             ; $69B1

    ld a, $03                                     ; $69B3
    ld [wSubstate], a                             ; $69B5
    jp Far_Call_Return                            ; $69B8


jr_007_69bb:
    ld a, BANK(Gfx_21_65C0_SaveDialog_Substate0_Init); $69BB
    ld hl, Gfx_21_65C0_SaveDialog_Substate0_Init  ; $69BD
    ld de, $8b00                                  ; $69C0
    ld bc, $04f0                                  ; $69C3
    call Vram_CopyFromBank                        ; $69C6
    ld a, BANK(Map_27_7090_SaveDialog_Substate0_Init); $69C9
    ld hl, Map_27_7090_SaveDialog_Substate0_Init  ; $69CB
    ld de, $9c00                                  ; $69CE
    ld bc, $0120                                  ; $69D1
    call Vram_CopyFromBank                        ; $69D4
    xor a                                         ; $69D7
    ld [wSaveDialogScratch], a                    ; $69D8
    call Oam_ClearShadow                          ; $69DB
    call SaveDialog_SlideIn                       ; $69DE
    ld hl, wSubstate                              ; $69E1
    inc [hl]                                      ; $69E4
    jp Far_Call_Return                            ; $69E5


; C
SaveDialog_Substate1_WaitKey::
    ldh a, [hKeysNew]                             ; $69E8
    and PADF_A | PADF_B                           ; $69EA
    ld [wAbResult], a                             ; $69EC
    jp z, Far_Call_Return                         ; $69EF

    ld hl, wSubstate                              ; $69F2
    inc [hl]                                      ; $69F5
    jp Far_Call_Return                            ; $69F6


; C: A saves the photo
SaveDialog_Substate2_Answer::
    call SaveDialog_SlideOut                      ; $69F9
    ld a, [wAbResult]                             ; $69FC
    bit 0, a                                      ; $69FF
    jr z, jr_007_6a0b                             ; $6A01

    ld a, [wSaveTargetPhoto]                      ; $6A03
    cp $1e                                        ; $6A06
    call c, SaveDialog_StoreEditedPhoto           ; $6A08

jr_007_6a0b:
    ld hl, wSubstate                              ; $6A0B
    inc [hl]                                      ; $6A0E
    jp Far_Call_Return                            ; $6A0F


; C: VRAM to $C000 buffer; far calls 02:47C4 / 02:4C37 / 02:488F
SaveDialog_StoreEditedPhoto::
    ld a, [wSaveDialogWhat]                       ; $6A12
    bit 0, a                                      ; $6A15
    jr z, jr_007_6a62                             ; $6A17

    ld a, $00                                     ; $6A19
    ld hl, $9000                                  ; $6A1B
    ld de, wPhotoImage                            ; $6A1E
    ld bc, $0800                                  ; $6A21
    call Vram_CopyFromBank_4                      ; $6A24
    ld a, $00                                     ; $6A27
    ld hl, $8800                                  ; $6A29
    ld de, wPhotoImage + $800                     ; $6A2C
    ld bc, $0100                                  ; $6A2F
    call Vram_CopyFromBank_4                      ; $6A32
    ld a, $00                                     ; $6A35
    ld hl, $8000                                  ; $6A37
    ld de, wPhotoImage + $900                     ; $6A3A
    ld bc, $0500                                  ; $6A3D
    call Vram_CopyFromBank_4                      ; $6A40
    ld a, [wDoodleFromShutterbug]                 ; $6A43
    and a                                         ; $6A46
    jr nz, jr_007_6a58                            ; $6A47

    ld a, [wSaveTargetPhoto]                      ; $6A49
    ldh [hFarcallAArg], a                         ; $6A4C
    ld a, BANK(Photo_StoreImage_Far)              ; $6A4E
    ld hl, Photo_StoreImage_Far                   ; $6A50
    call Far_Call                                 ; $6A53
    jr jr_007_6a62                                ; $6A56

jr_007_6a58:
    ldh [hFarcallAArg], a                         ; $6A58
    ld a, BANK(GameFace_Store_Far)                ; $6A5A
    ld hl, GameFace_Store_Far                     ; $6A5C
    call Far_Call                                 ; $6A5F

jr_007_6a62:
    ld a, [wSaveDialogWhat]                       ; $6A62
    bit 1, a                                      ; $6A65
    ret z                                         ; $6A67

    ld a, [wSaveTargetPhoto]                      ; $6A68
    ldh [hFarcallAArg], a                         ; $6A6B
    ld a, BANK(Photo_StoreHotspotsTranslated_Far) ; $6A6D
    ld hl, Photo_StoreHotspotsTranslated_Far      ; $6A6F
    call Far_Call                                 ; $6A72
    ret                                           ; $6A75


; C: album-full message. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
SaveDialog_Substate3_FullInit::
    ld a, BANK(Gfx_1E_7800_SaveDialog_Substate3_FullInit); $6A76
    ld hl, Gfx_1E_7800_SaveDialog_Substate3_FullInit; $6A78
    ld de, $8b00                                  ; $6A7B
    ld bc, $04f0                                  ; $6A7E
    call Vram_CopyFromBank                        ; $6A81
    ld a, BANK(Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0); $6A84
    ld hl, Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0; $6A86
    ld de, $9c00                                  ; $6A89
    ld bc, $0120                                  ; $6A8C
    call Vram_CopyFromBank                        ; $6A8F
    xor a                                         ; $6A92
    ld [wSaveDialogScratch], a                    ; $6A93
    call Oam_ClearShadow                          ; $6A96
    call SaveDialog_SlideIn                       ; $6A99
    ld hl, wSubstate                              ; $6A9C
    inc [hl]                                      ; $6A9F
    jp Far_Call_Return                            ; $6AA0


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
SaveDialog_Substate4_WaitKey::
    ldh a, [hKeysNew]                             ; $6AA3
    and PADF_A | PADF_B                           ; $6AA5
    ld [wAbResult], a                             ; $6AA7
    jp z, Far_Call_Return                         ; $6AAA

    ld hl, wSubstate                              ; $6AAD
    inc [hl]                                      ; $6AB0
    jp Far_Call_Return                            ; $6AB1


; C: save_dialog_result := 0 (A) or $FF
SaveDialog_Substate5_Finish::
    call SaveDialog_SlideOut                      ; $6AB4
    ld a, [wAbResult]                             ; $6AB7
    bit 0, a                                      ; $6ABA
    jr z, jr_007_6ac1                             ; $6ABC

    xor a                                         ; $6ABE
    jr jr_007_6ac3                                ; $6ABF

jr_007_6ac1:
    ld a, $ff                                     ; $6AC1

jr_007_6ac3:
    ld [wSaveDialogResult], a                     ; $6AC3
    ld hl, wState                                 ; $6AC6
    inc [hl]                                      ; $6AC9
    jp Far_Call_Return                            ; $6ACA


; C: window moves down with the WY delta table; sound $12
SaveDialog_SlideOut::
    push af                                       ; $6ACD
    ld a, SFX1_PANEL_OPEN                         ; $6ACE
    call Snd_Sfx1                                 ; $6AD0
    pop af                                        ; $6AD3
    ld hl, Slide_WyDeltaTbl                       ; $6AD4
    ld b, $24                                     ; $6AD7

jr_007_6ad9:
    push bc                                       ; $6AD9
    push hl                                       ; $6ADA
    ldh a, [hWyShadow]                            ; $6ADB
    add [hl]                                      ; $6ADD
    ldh [hWyShadow], a                            ; $6ADE
    rst Rst08_WaitVBlank                          ; $6AE0
    pop hl                                        ; $6AE1
    pop bc                                        ; $6AE2
    inc hl                                        ; $6AE3
    dec b                                         ; $6AE4
    jr nz, jr_007_6ad9                            ; $6AE5

    ret                                           ; $6AE7


; C: sound $13
SaveDialog_SlideIn::
    push af                                       ; $6AE8
    ld a, SFX1_PANEL_CLOSE                        ; $6AE9
    call Snd_Sfx1                                 ; $6AEB
    pop af                                        ; $6AEE
    ld hl, Slide_WyDeltaTbl                       ; $6AEF
    ld b, $24                                     ; $6AF2

jr_007_6af4:
    push bc                                       ; $6AF4
    push hl                                       ; $6AF5
    ldh a, [hWyShadow]                            ; $6AF6
    sub [hl]                                      ; $6AF8
    ldh [hWyShadow], a                            ; $6AF9
    rst Rst08_WaitVBlank                          ; $6AFB
    pop hl                                        ; $6AFC
    pop bc                                        ; $6AFD
    inc hl                                        ; $6AFE
    dec b                                         ; $6AFF
    jr nz, jr_007_6af4                            ; $6B00

    ret                                           ; $6B02


; C: mode 0D: slide-show hub; options and auto-play viewer
Mode0D_SlideShow::
    ld a, [wState]                                ; $6B03
    rst Rst18_JumpTable                           ; $6B06

; C: 12 states
Mode0D_StateTable::
    dw Mode0D_State00_Init
    dw Mode0D_State01_Hub
    dw Mode0D_State02_OptionsMenu
    dw Mode0D_State03_OptionA
    dw Mode0D_State04_OptionB
    dw Mode0D_State05_FadeOutHub
    dw Mode0D_State06_PlayInit
    dw Mode0D_State07_Play
    dw Mode0D_State08_PlayExit
    dw Mode0D_State09_NoPhotosMessage
    dw Mode0D_State0A_ResultScreen
    dw Mode0D_State0B_Restart

; C: hub screen
Mode0D_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6B1F
    ldh [hLcdcShadow], a                          ; $6B21
    ld a, $e4                                     ; $6B23
    ld [wPaletteTarget], a                        ; $6B25
    ld a, $d2                                     ; $6B28
    ld [wPaletteTarget + $1], a                   ; $6B2A
    ld [wPaletteTarget + $2], a                   ; $6B2D
    ld a, $10                                     ; $6B30
    ldh [hScyShadow], a                           ; $6B32
    xor a                                         ; $6B34
    ldh [hScxShadow], a                           ; $6B35
    ld hl, wActorFrame                            ; $6B37
    ld b, $08                                     ; $6B3A

jr_007_6b3c:
    ld [hl+], a                                   ; $6B3C
    dec b                                         ; $6B3D
    jr nz, jr_007_6b3c                            ; $6B3E

    ld de, Mode0D_State00_Init_Gfx6BB3            ; $6B40
    ld b, $08                                     ; $6B43

jr_007_6b45:
    ld a, [de]                                    ; $6B45
    ld [hl+], a                                   ; $6B46
    inc de                                        ; $6B47
    dec b                                         ; $6B48
    jr nz, jr_007_6b45                            ; $6B49

    ld a, BANK(Gfx_14_5800_Mode0D_State00_Init)   ; $6B4B
    ld hl, Gfx_14_5800_Mode0D_State00_Init        ; $6B4D
    ld de, $9000                                  ; $6B50
    ld bc, $0800                                  ; $6B53
    call Mem_CopyFromBank                         ; $6B56
    ld a, BANK(Gfx_14_6000_Mode0D_State00_Init)   ; $6B59
    ld hl, Gfx_14_6000_Mode0D_State00_Init        ; $6B5B
    ld de, $8800                                  ; $6B5E
    ld bc, $0800                                  ; $6B61
    call Mem_CopyFromBank                         ; $6B64
    ld a, BANK(Gfx_14_6800_Mode0D_State00_Init)   ; $6B67
    ld hl, Gfx_14_6800_Mode0D_State00_Init        ; $6B69
    ld de, $8000                                  ; $6B6C
    ld bc, $0800                                  ; $6B6F
    call Mem_CopyFromBank                         ; $6B72
    ld a, BANK(Map_24_4840_Mode0D_State00_Init)   ; $6B75
    ld hl, Map_24_4840_Mode0D_State00_Init        ; $6B77
    ld de, $9840                                  ; $6B7A
    ld bc, $0240                                  ; $6B7D
    call Mem_CopyFromBank                         ; $6B80
    ld hl, $8f00                                  ; $6B83
    ld bc, $0010                                  ; $6B86
    ld de, $ffff                                  ; $6B89
    call Mem_FillWords                            ; $6B8C
    ld hl, $9ac0                                  ; $6B8F
    ld bc, $0140                                  ; $6B92
    ld a, $f0                                     ; $6B95
    call Mem_FillBc1                              ; $6B97
    call Oam_ClearShadow                          ; $6B9A
    call Pal_AllWhite                             ; $6B9D
    call Lcd_On                                   ; $6BA0
    push af                                       ; $6BA3
    ld a, MUSIC_SLIDESHOW_INIT                    ; $6BA4
    call Snd_Music                                ; $6BA6
    pop af                                        ; $6BA9
    call Pal_FadeIn                               ; $6BAA
    ld a, STATE_0D_HUB                            ; $6BAD
    ld [wState], a                                ; $6BAF
    ret                                           ; $6BB2


; C: auto: 8 bytes, tile data; referenced by Mode0D_State00_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 0D)
Mode0D_State00_Init_Gfx6BB3::
    db $20, $70, $36, $36, $55, $55, $05, $05

; C: two wandering sprites; Select = options; A/B = leave
Mode0D_State01_Hub::
    call SlideHub_UpdateActors                    ; $6BBB
    call SlideHub_RandomizeSpeed                  ; $6BBE
    call SlideHub_WalkActors                      ; $6BC1
    ldh a, [hKeysNewSticky]                       ; $6BC4
    bit PADB_SELECT, a                            ; $6BC6
    jr z, jr_007_6bf2                             ; $6BC8

    push af                                       ; $6BCA
    ld a, SFX1_KEY_SELECT                         ; $6BCB
    call Snd_Sfx1                                 ; $6BCD
    pop af                                        ; $6BD0
    ld a, BANK(Map_24_47C0_Mode0D_State01_Hub)    ; $6BD1
    ld hl, Map_24_47C0_Mode0D_State01_Hub         ; $6BD3
    ld de, $9800                                  ; $6BD6
    ld bc, $0080                                  ; $6BD9
    call Vram_CopyFromBank                        ; $6BDC
    ld a, BANK(Map_24_4A80_Mode0D_State01_Hub)    ; $6BDF
    ld hl, Map_24_4A80_Mode0D_State01_Hub         ; $6BE1
    ld de, $9a40                                  ; $6BE4
    ld bc, $0080                                  ; $6BE7
    call Vram_CopyFromBank                        ; $6BEA
    ld hl, wState                                 ; $6BED
    inc [hl]                                      ; $6BF0
    ret                                           ; $6BF1


jr_007_6bf2:
    and $03                                       ; $6BF2
    ret z                                         ; $6BF4

    ld [wAbResult], a                             ; $6BF5
    push af                                       ; $6BF8
    bit 0, a                                      ; $6BF9
    ld a, SFX1_KEY_A                              ; $6BFB
    call nz, Snd_Sfx1                             ; $6BFD
    pop af                                        ; $6C00
    push af                                       ; $6C01
    bit 1, a                                      ; $6C02
    ld a, SFX1_KEY_B                              ; $6C04
    call nz, Snd_Sfx1                             ; $6C06
    pop af                                        ; $6C09
    ld a, STATE_0D_FADE_OUT_HUB                   ; $6C0A
    ld [wState], a                                ; $6C0C
    ret                                           ; $6C0F


; C
SlideHub_UpdateActors::
    ld bc, $0001                                  ; $6C10

jr_007_6c13:
    push bc                                       ; $6C13
    ld hl, wActorCycleFlag                        ; $6C14
    add hl, bc                                    ; $6C17
    xor a                                         ; $6C18
    ld [hl], a                                    ; $6C19
    ld hl, wActorFrame                            ; $6C1A
    add hl, bc                                    ; $6C1D
    ld e, [hl]                                    ; $6C1E
    ld hl, wActorTick                             ; $6C1F
    add hl, bc                                    ; $6C22
    ld d, [hl]                                    ; $6C23
    push de                                       ; $6C24
    sla e                                         ; $6C25
    ld d, $00                                     ; $6C27
    ld hl, SlideHub_ActorAnimTbl                  ; $6C29
    add hl, de                                    ; $6C2C
    ld a, [hl+]                                   ; $6C2D
    push hl                                       ; $6C2E
    ld hl, wActorX                                ; $6C2F
    add hl, bc                                    ; $6C32
    ld b, [hl]                                    ; $6C33
    inc hl                                        ; $6C34
    inc hl                                        ; $6C35
    ld c, [hl]                                    ; $6C36
    call Oam_AddMeta_B01_5D47                     ; $6C37
    pop hl                                        ; $6C3A
    pop de                                        ; $6C3B

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideHub_ActorDurations::
    ld a, d                                       ; $6C3C
    cp [hl]                                       ; $6C3D
    jr nz, jr_007_6c5a                            ; $6C3E

    inc e                                         ; $6C40
    inc hl                                        ; $6C41
    ld a, [hl+]                                   ; $6C42
    cp $ff                                        ; $6C43
    jr nz, jr_007_6c58                            ; $6C45

    ld e, [hl]                                    ; $6C47
    pop bc                                        ; $6C48
    push bc                                       ; $6C49
    ld hl, wActorCycleFlag                        ; $6C4A
    add hl, bc                                    ; $6C4D
    inc [hl]                                      ; $6C4E
    call Rng_Next                                 ; $6C4F
    cp $32                                        ; $6C52
    jr c, jr_007_6c58                             ; $6C54

    ld e, $00                                     ; $6C56

jr_007_6c58:
    ld d, $00                                     ; $6C58

jr_007_6c5a:
    pop bc                                        ; $6C5A
    push bc                                       ; $6C5B
    ld hl, wActorSpeed                            ; $6C5C
    add hl, bc                                    ; $6C5F
    ld a, [hl]                                    ; $6C60
    ld hl, wActorPhase                            ; $6C61
    add hl, bc                                    ; $6C64
    add [hl]                                      ; $6C65
    ld [hl], a                                    ; $6C66
    jr nc, jr_007_6c6a                            ; $6C67

    inc d                                         ; $6C69

jr_007_6c6a:
    ld hl, wActorFrame                            ; $6C6A
    add hl, bc                                    ; $6C6D
    ld [hl], e                                    ; $6C6E
    ld hl, wActorTick                             ; $6C6F
    add hl, bc                                    ; $6C72
    ld [hl], d                                    ; $6C73
    pop bc                                        ; $6C74
    dec c                                         ; $6C75
    bit 7, c                                      ; $6C76
    jr z, jr_007_6c13                             ; $6C78

    ret                                           ; $6C7A


; C: pairs: sprite id; duration
SlideHub_ActorAnimTbl::
    db $0f, $01, $10, $01, $11, $01, $12, $01, $00, $01, $01, $01, $02, $01, $03, $01
    db $04, $01, $05, $01, $06, $01, $07, $01, $08, $01, $09, $01, $0a, $01, $0b, $01
    db $0c, $01, $0d, $01, $0e, $01, $ff, $14, $22, $01, $23, $01, $24, $01, $25, $01
    db $13, $01, $14, $01, $15, $01, $16, $01, $17, $01, $18, $01, $19, $01, $1a, $01
    db $1b, $01, $1c, $01, $1d, $01, $1e, $01, $1f, $01, $20, $01, $21, $01, $ff, $14

; C
SlideHub_RandomizeSpeed::
    ld bc, $0001                                  ; $6CCB

jr_007_6cce:
    ld hl, wActorCycleFlag                        ; $6CCE
    add hl, bc                                    ; $6CD1
    bit 0, [hl]                                   ; $6CD2
    jr z, jr_007_6cf3                             ; $6CD4

    ld hl, wActorSpeedTimer                       ; $6CD6
    add hl, bc                                    ; $6CD9
    dec [hl]                                      ; $6CDA
    jr nz, jr_007_6cf3                            ; $6CDB

    call Rng_Next                                 ; $6CDD
    and $07                                       ; $6CE0
    add $02                                       ; $6CE2
    ld [hl], a                                    ; $6CE4
    call Rng_Next                                 ; $6CE5
    cp $55                                        ; $6CE8
    jr nc, jr_007_6cee                            ; $6CEA

    ld a, $55                                     ; $6CEC

jr_007_6cee:
    ld hl, wActorSpeed                            ; $6CEE
    add hl, bc                                    ; $6CF1
    ld [hl], a                                    ; $6CF2

jr_007_6cf3:
    dec c                                         ; $6CF3
    bit 7, c                                      ; $6CF4
    jr z, jr_007_6cce                             ; $6CF6

    ret                                           ; $6CF8


; C: random walk -1;0;0;+1 per frame inside limits
SlideHub_WalkActors::
    ld bc, $0001                                  ; $6CF9

jr_007_6cfc:
    call Rng_Next                                 ; $6CFC
    and $03                                       ; $6CFF
    sub $02                                       ; $6D01
    jr nc, jr_007_6d06                            ; $6D03

    inc a                                         ; $6D05

jr_007_6d06:
    ld hl, wActorX                                ; $6D06
    add hl, bc                                    ; $6D09
    add [hl]                                      ; $6D0A
    ld hl, SlideHub_ActorLimitTbl                 ; $6D0B
    add hl, bc                                    ; $6D0E
    cp [hl]                                       ; $6D0F
    jr c, jr_007_6d1e                             ; $6D10

    ld hl, SlideHub_WalkActors_Tbl6D42            ; $6D12
    add hl, bc                                    ; $6D15
    cp [hl]                                       ; $6D16
    jr nc, jr_007_6d1e                            ; $6D17

    ld hl, wActorX                                ; $6D19
    add hl, bc                                    ; $6D1C
    ld [hl], a                                    ; $6D1D

jr_007_6d1e:
    call Rng_Next                                 ; $6D1E
    and $03                                       ; $6D21
    sub $02                                       ; $6D23
    jr nc, jr_007_6d28                            ; $6D25

    inc a                                         ; $6D27

jr_007_6d28:
    ld hl, wActorY                                ; $6D28
    add hl, bc                                    ; $6D2B
    add [hl]                                      ; $6D2C
    cp $2e                                        ; $6D2D
    jr c, jr_007_6d3a                             ; $6D2F

    cp $3e                                        ; $6D31
    jr nc, jr_007_6d3a                            ; $6D33

    ld hl, wActorY                                ; $6D35
    add hl, bc                                    ; $6D38
    ld [hl], a                                    ; $6D39

jr_007_6d3a:
    dec c                                         ; $6D3A
    bit 7, c                                      ; $6D3B
    jr z, jr_007_6cfc                             ; $6D3D

    ret                                           ; $6D3F


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideHub_ActorLimitTbl::
    dw $6010

; C: auto: 2 bytes, bytes; referenced by SlideHub_WalkActors. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideHub_WalkActors_Tbl6D42::
    dw $8030

; C: blinking arrows; Up/Down picks option row
Mode0D_State02_OptionsMenu::
    ld a, [wBlinkCounter]                         ; $6D44
    inc a                                         ; $6D47
    ld [wBlinkCounter], a                         ; $6D48
    bit 4, a                                      ; $6D4B
    jr z, jr_007_6d5f                             ; $6D4D

    ld a, $00                                     ; $6D4F
    ld bc, $5010                                  ; $6D51
    call Oam_AddMeta_B02_6E4B                     ; $6D54
    ld a, $01                                     ; $6D57
    ld bc, $5080                                  ; $6D59
    call Oam_AddMeta_B02_6E4B                     ; $6D5C

jr_007_6d5f:
    ldh a, [hKeysNewSticky]                       ; $6D5F
    and PADF_B | PADF_SELECT                      ; $6D61
    jr z, jr_007_6d8d                             ; $6D63

    push af                                       ; $6D65
    ld a, SFX1_KEY_B                              ; $6D66
    call Snd_Sfx1                                 ; $6D68
    pop af                                        ; $6D6B
    ld a, BANK(Map_24_4840_Mode0D_State00_Init)   ; $6D6C
    ld hl, Map_24_4840_Mode0D_State00_Init        ; $6D6E
    ld de, $9840                                  ; $6D71
    ld bc, $0040                                  ; $6D74
    call Vram_CopyFromBank                        ; $6D77
    ld a, BANK(Map_24_4A40_Mode0D_State02_OptionsMenu); $6D7A
    ld hl, Map_24_4A40_Mode0D_State02_OptionsMenu ; $6D7C
    ld de, $9a40                                  ; $6D7F
    ld bc, $0040                                  ; $6D82
    call Vram_CopyFromBank                        ; $6D85
    ld hl, wState                                 ; $6D88
    dec [hl]                                      ; $6D8B
    ret                                           ; $6D8C


jr_007_6d8d:
    ldh a, [hKeysRepeatSticky]                    ; $6D8D
    and PADF_UP | PADF_DOWN                       ; $6D8F
    ret z                                         ; $6D91

    push af                                       ; $6D92
    ld a, SFX1_STEP_FAST                          ; $6D93
    call Snd_Sfx1                                 ; $6D95
    pop af                                        ; $6D98
    xor a                                         ; $6D99
    ld [wArrowAnimTick], a                        ; $6D9A
    ld [wArrowAnimFrame], a                       ; $6D9D
    ld a, [wPlayOptA]                             ; $6DA0
    ld [wChoiceCursorA], a                        ; $6DA3
    ld a, [wPlayOptB]                             ; $6DA6
    ld [wChoiceCursorB], a                        ; $6DA9
    ldh a, [hKeysRepeatSticky]                    ; $6DAC
    bit PADB_UP, a                                ; $6DAE
    jr z, jr_007_6dce                             ; $6DB0

    call Oam_ClearShadow                          ; $6DB2
    ld hl, Slide_ScyDeltaTbl                      ; $6DB5
    ld b, $10                                     ; $6DB8

jr_007_6dba:
    push bc                                       ; $6DBA
    push hl                                       ; $6DBB
    ldh a, [hScyShadow]                           ; $6DBC
    add [hl]                                      ; $6DBE
    ldh [hScyShadow], a                           ; $6DBF
    rst Rst08_WaitVBlank                          ; $6DC1
    pop hl                                        ; $6DC2
    pop bc                                        ; $6DC3
    inc hl                                        ; $6DC4
    dec b                                         ; $6DC5
    jr nz, jr_007_6dba                            ; $6DC6

    ld a, STATE_0D_OPTION_A                       ; $6DC8
    ld [wState], a                                ; $6DCA
    ret                                           ; $6DCD


jr_007_6dce:
    bit 7, a                                      ; $6DCE
    ret z                                         ; $6DD0

    call Oam_ClearShadow                          ; $6DD1
    ld hl, Slide_ScyDeltaTbl                      ; $6DD4
    ld b, $10                                     ; $6DD7

jr_007_6dd9:
    push bc                                       ; $6DD9
    push hl                                       ; $6DDA
    ldh a, [hScyShadow]                           ; $6DDB
    sub [hl]                                      ; $6DDD
    ldh [hScyShadow], a                           ; $6DDE
    rst Rst08_WaitVBlank                          ; $6DE0
    pop hl                                        ; $6DE1
    pop bc                                        ; $6DE2
    inc hl                                        ; $6DE3
    dec b                                         ; $6DE4
    jr nz, jr_007_6dd9                            ; $6DE5

    ld a, STATE_0D_OPTION_B                       ; $6DE7
    ld [wState], a                                ; $6DE9
    ret                                           ; $6DEC


; C: option A ($D7D2): 0 = BGM (song $21), 1 = P.VOICE (music off; after each photo its four checksum digits are
; spoken, sfx1 $10); the earlier note 'photo number shown on/off' was wrong (README 16.27)
Mode0D_State03_OptionA::
    call SlideOptA_ReadKeys                       ; $6DED
    call SlideOptA_DrawArrow                      ; $6DF0
    call SlideOptA_DrawValue                      ; $6DF3
    ldh a, [hKeysNew]                             ; $6DF6
    and PADF_A | PADF_B | PADF_DOWN               ; $6DF8
    ret z                                         ; $6DFA

    push af                                       ; $6DFB
    bit 0, a                                      ; $6DFC
    ld a, SFX1_OPTION_CHANGE                      ; $6DFE
    call nz, Snd_Sfx1                             ; $6E00
    pop af                                        ; $6E03
    push af                                       ; $6E04
    bit 1, a                                      ; $6E05
    ld a, SFX1_KEY_B                              ; $6E07
    call nz, Snd_Sfx1                             ; $6E09
    pop af                                        ; $6E0C
    push af                                       ; $6E0D
    bit 7, a                                      ; $6E0E
    ld a, SFX1_STEP_FAST                          ; $6E10
    call nz, Snd_Sfx1                             ; $6E12
    pop af                                        ; $6E15
    push af                                       ; $6E16
    bit 0, a                                      ; $6E17
    jr z, jr_007_6e3a                             ; $6E19

    ld hl, wArrowAnimFrame                        ; $6E1B
    inc [hl]                                      ; $6E1E
    ld a, [wChoiceCursorA]                        ; $6E1F
    ld [wPlayOptA], a                             ; $6E22
    call Oam_HideUnused                           ; $6E25
    rst Rst08_WaitVBlank                          ; $6E28

jr_007_6e29:
    call SlideOptA_DrawArrow                      ; $6E29
    call SlideOptA_DrawValue                      ; $6E2C
    call Oam_HideUnused                           ; $6E2F
    rst Rst08_WaitVBlank                          ; $6E32
    ld a, [wArrowAnimFrame]                       ; $6E33
    cp $02                                        ; $6E36
    jr nz, jr_007_6e29                            ; $6E38

jr_007_6e3a:
    call Oam_ClearShadow                          ; $6E3A
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6E3D
    ld b, $10                                     ; $6E40

jr_007_6e42:
    push bc                                       ; $6E42
    push hl                                       ; $6E43
    ldh a, [hScyShadow]                           ; $6E44
    sub [hl]                                      ; $6E46
    ldh [hScyShadow], a                           ; $6E47
    rst Rst08_WaitVBlank                          ; $6E49
    pop hl                                        ; $6E4A
    pop bc                                        ; $6E4B
    inc hl                                        ; $6E4C
    dec b                                         ; $6E4D
    jr nz, jr_007_6e42                            ; $6E4E

    pop af                                        ; $6E50
    bit 0, a                                      ; $6E51
    jr nz, jr_007_6e5b                            ; $6E53

    ld a, STATE_0D_OPTIONS_MENU                   ; $6E55
    ld [wState], a                                ; $6E57
    ret                                           ; $6E5A


jr_007_6e5b:
    ld a, BANK(Map_24_4840_Mode0D_State00_Init)   ; $6E5B
    ld hl, Map_24_4840_Mode0D_State00_Init        ; $6E5D
    ld de, $9840                                  ; $6E60
    ld bc, $0040                                  ; $6E63
    call Vram_CopyFromBank                        ; $6E66
    ld a, BANK(Map_24_4A40_Mode0D_State02_OptionsMenu); $6E69
    ld hl, Map_24_4A40_Mode0D_State02_OptionsMenu ; $6E6B
    ld de, $9a40                                  ; $6E6E
    ld bc, $0040                                  ; $6E71
    call Vram_CopyFromBank                        ; $6E74
    ld a, STATE_0D_HUB                            ; $6E77
    ld [wState], a                                ; $6E79
    ret                                           ; $6E7C


; C: Left/Right toggle D674. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
SlideOptA_ReadKeys::
    ldh a, [hKeysNew]                             ; $6E7D
    bit PADB_LEFT, a                              ; $6E7F
    jr z, jr_007_6e86                             ; $6E81

    xor a                                         ; $6E83
    jr jr_007_6e8b                                ; $6E84

jr_007_6e86:
    bit 4, a                                      ; $6E86
    ret z                                         ; $6E88

    ld a, $01                                     ; $6E89

jr_007_6e8b:
    ld hl, wChoiceCursorA                         ; $6E8B
    cp [hl]                                       ; $6E8E
    ret z                                         ; $6E8F

    ld [hl], a                                    ; $6E90
    push af                                       ; $6E91
    ld a, SFX1_STEP_FAST                          ; $6E92
    call Snd_Sfx1                                 ; $6E94
    pop af                                        ; $6E97
    ret                                           ; $6E98


; C: draws the arrow of option A: position = SlideOptA_ArrowPosTbl[$D674] ({y,x} in C,B); animation phase $D50F (2 =
; finished, nothing drawn), tick $D51F: meta and duration come from SlideOptA_DrawArrow_Tbl6EDA[phase]; the phase
; advances when the tick equals the duration and the tick counts only while ...
SlideOptA_DrawArrow::
    ld a, [wChoiceCursorA]                        ; $6E99
    sla a                                         ; $6E9C
    ld c, a                                       ; $6E9E
    ld b, $00                                     ; $6E9F
    ld hl, SlideOptA_ArrowPosTbl                  ; $6EA1
    add hl, bc                                    ; $6EA4
    ld c, [hl]                                    ; $6EA5
    inc hl                                        ; $6EA6
    ld b, [hl]                                    ; $6EA7
    ld a, [wArrowAnimFrame]                       ; $6EA8
    cp $02                                        ; $6EAB
    ret z                                         ; $6EAD

    ld a, [wArrowAnimFrame]                       ; $6EAE
    sla a                                         ; $6EB1
    ld e, a                                       ; $6EB3
    ld d, $00                                     ; $6EB4
    ld hl, SlideOptA_DrawArrow_Tbl6EDA            ; $6EB6
    add hl, de                                    ; $6EB9
    ld a, [hl+]                                   ; $6EBA
    call Oam_AddMeta_B02_6E4B                     ; $6EBB
    ld a, [wArrowAnimTick]                        ; $6EBE
    cp [hl]                                       ; $6EC1
    jr nz, jr_007_6ecc                            ; $6EC2

    ld hl, wArrowAnimFrame                        ; $6EC4
    inc [hl]                                      ; $6EC7
    xor a                                         ; $6EC8
    ld [wArrowAnimTick], a                        ; $6EC9

jr_007_6ecc:
    ld a, [wArrowAnimFrame]                       ; $6ECC
    and a                                         ; $6ECF
    ret z                                         ; $6ED0

    ld hl, wArrowAnimTick                         ; $6ED1
    inc [hl]                                      ; $6ED4
    ret                                           ; $6ED5


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptA_ArrowPosTbl::
    db $10, $24, $10, $70

; C: 3 x {meta, duration}: 08/10, 09/0B, 09/FF (the third entry is never used: phase 2 returns before the table is
; read); read by SlideOptA_DrawArrow with $D50F x 2 (C)
SlideOptA_DrawArrow_Tbl6EDA::
    db $08, $10, $09, $0b, $09, $ff

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideOptA_DrawValue::
    ld a, [wPlayOptA]                             ; $6EE0
    sla a                                         ; $6EE3
    ld c, a                                       ; $6EE5
    ld b, $00                                     ; $6EE6
    ld hl, SlideOptA_ValuePosTbl                  ; $6EE8
    add hl, bc                                    ; $6EEB
    ld c, [hl]                                    ; $6EEC
    inc hl                                        ; $6EED
    ld b, [hl]                                    ; $6EEE
    ldh a, [hFrameCounter]                        ; $6EEF
    swap a                                        ; $6EF1
    and $01                                       ; $6EF3
    add $02                                       ; $6EF5
    call Oam_AddMeta_B02_6E4B                     ; $6EF7
    ret                                           ; $6EFA


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptA_ValuePosTbl::
    db $00, $0a, $00, $55

; C: option B (D7D3): random / in order. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Mode0D_State04_OptionB::
    call SlideOptB_ReadKeys                       ; $6EFF
    call SlideOptB_DrawArrow                      ; $6F02
    call SlideOptB_DrawValue                      ; $6F05
    ldh a, [hKeysNew]                             ; $6F08
    and PADF_A | PADF_B | PADF_UP                 ; $6F0A
    ret z                                         ; $6F0C

    push af                                       ; $6F0D
    bit 0, a                                      ; $6F0E
    ld a, SFX1_OPTION_CHANGE                      ; $6F10
    call nz, Snd_Sfx1                             ; $6F12
    pop af                                        ; $6F15
    push af                                       ; $6F16
    bit 1, a                                      ; $6F17
    ld a, SFX1_KEY_B                              ; $6F19
    call nz, Snd_Sfx1                             ; $6F1B
    pop af                                        ; $6F1E
    push af                                       ; $6F1F
    bit 6, a                                      ; $6F20
    ld a, SFX1_STEP_FAST                          ; $6F22
    call nz, Snd_Sfx1                             ; $6F24
    pop af                                        ; $6F27
    push af                                       ; $6F28
    bit 0, a                                      ; $6F29
    jr z, jr_007_6f4c                             ; $6F2B

    ld hl, wArrowAnimFrame                        ; $6F2D
    inc [hl]                                      ; $6F30
    ld a, [wChoiceCursorB]                        ; $6F31
    ld [wPlayOptB], a                             ; $6F34
    call Oam_HideUnused                           ; $6F37
    rst Rst08_WaitVBlank                          ; $6F3A

jr_007_6f3b:
    call SlideOptB_DrawArrow                      ; $6F3B
    call SlideOptB_DrawValue                      ; $6F3E
    call Oam_HideUnused                           ; $6F41
    rst Rst08_WaitVBlank                          ; $6F44
    ld a, [wArrowAnimFrame]                       ; $6F45
    cp $02                                        ; $6F48
    jr nz, jr_007_6f3b                            ; $6F4A

jr_007_6f4c:
    call Oam_ClearShadow                          ; $6F4C
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6F4F
    ld b, $10                                     ; $6F52

jr_007_6f54:
    push bc                                       ; $6F54
    push hl                                       ; $6F55
    ldh a, [hScyShadow]                           ; $6F56
    add [hl]                                      ; $6F58
    ldh [hScyShadow], a                           ; $6F59
    cpl                                           ; $6F5B
    add $64                                       ; $6F5C
    ldh [hLycShadowSplit1], a                     ; $6F5E
    rst Rst08_WaitVBlank                          ; $6F60
    pop hl                                        ; $6F61
    pop bc                                        ; $6F62
    inc hl                                        ; $6F63
    dec b                                         ; $6F64
    jr nz, jr_007_6f54                            ; $6F65

    pop af                                        ; $6F67
    bit 0, a                                      ; $6F68
    jr nz, jr_007_6f72                            ; $6F6A

    ld a, STATE_0D_OPTIONS_MENU                   ; $6F6C
    ld [wState], a                                ; $6F6E
    ret                                           ; $6F71


jr_007_6f72:
    ld a, BANK(Map_24_4840_Mode0D_State00_Init)   ; $6F72
    ld hl, Map_24_4840_Mode0D_State00_Init        ; $6F74
    ld de, $9840                                  ; $6F77
    ld bc, $0040                                  ; $6F7A
    call Vram_CopyFromBank                        ; $6F7D
    ld a, BANK(Map_24_4A40_Mode0D_State02_OptionsMenu); $6F80
    ld hl, Map_24_4A40_Mode0D_State02_OptionsMenu ; $6F82
    ld de, $9a40                                  ; $6F85
    ld bc, $0040                                  ; $6F88
    call Vram_CopyFromBank                        ; $6F8B
    ld a, STATE_0D_HUB                            ; $6F8E
    ld [wState], a                                ; $6F90
    ret                                           ; $6F93


; C: Left/Right toggle D675. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
SlideOptB_ReadKeys::
    ldh a, [hKeysNew]                             ; $6F94
    bit PADB_LEFT, a                              ; $6F96
    jr z, jr_007_6f9d                             ; $6F98

    xor a                                         ; $6F9A
    jr jr_007_6fa2                                ; $6F9B

jr_007_6f9d:
    bit 4, a                                      ; $6F9D
    ret z                                         ; $6F9F

    ld a, $01                                     ; $6FA0

jr_007_6fa2:
    ld hl, wChoiceCursorB                         ; $6FA2
    cp [hl]                                       ; $6FA5
    ret z                                         ; $6FA6

    ld [hl], a                                    ; $6FA7
    push af                                       ; $6FA8
    ld a, SFX1_STEP_FAST                          ; $6FA9
    call Snd_Sfx1                                 ; $6FAB
    pop af                                        ; $6FAE
    ret                                           ; $6FAF


; C: draws the arrow of option B: same routine as SlideOptA_DrawArrow with $D675, SlideOptB_ArrowPosTbl and
; SlideOptB_DrawArrow_Tbl6FF1 (C)
SlideOptB_DrawArrow::
    ld a, [wChoiceCursorB]                        ; $6FB0
    sla a                                         ; $6FB3
    ld c, a                                       ; $6FB5
    ld b, $00                                     ; $6FB6
    ld hl, SlideOptB_ArrowPosTbl                  ; $6FB8
    add hl, bc                                    ; $6FBB
    ld c, [hl]                                    ; $6FBC
    inc hl                                        ; $6FBD
    ld b, [hl]                                    ; $6FBE
    ld a, [wArrowAnimFrame]                       ; $6FBF
    cp $02                                        ; $6FC2
    ret z                                         ; $6FC4

    ld a, [wArrowAnimFrame]                       ; $6FC5
    sla a                                         ; $6FC8
    ld e, a                                       ; $6FCA
    ld d, $00                                     ; $6FCB
    ld hl, SlideOptB_DrawArrow_Tbl6FF1            ; $6FCD
    add hl, de                                    ; $6FD0
    ld a, [hl+]                                   ; $6FD1
    call Oam_AddMeta_B02_6E4B                     ; $6FD2
    ld a, [wArrowAnimTick]                        ; $6FD5
    cp [hl]                                       ; $6FD8
    jr nz, jr_007_6fe3                            ; $6FD9

    ld hl, wArrowAnimFrame                        ; $6FDB
    inc [hl]                                      ; $6FDE
    xor a                                         ; $6FDF
    ld [wArrowAnimTick], a                        ; $6FE0

jr_007_6fe3:
    ld a, [wArrowAnimFrame]                       ; $6FE3
    and a                                         ; $6FE6
    ret z                                         ; $6FE7

    ld hl, wArrowAnimTick                         ; $6FE8
    inc [hl]                                      ; $6FEB
    ret                                           ; $6FEC


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptB_ArrowPosTbl::
    db $70, $24, $70, $70

; C: 3 x {meta, duration}: 0A/10, 0B/0B, 0B/FF (the third entry is never used); read by SlideOptB_DrawArrow (C)
SlideOptB_DrawArrow_Tbl6FF1::
    db $0a, $10, $0b, $0b, $0b, $ff

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideOptB_DrawValue::
    ld a, [wPlayOptB]                             ; $6FF7
    sla a                                         ; $6FFA
    ld c, a                                       ; $6FFC
    ld b, $00                                     ; $6FFD
    ld hl, SlideOptB_ValuePosTbl                  ; $6FFF
    add hl, bc                                    ; $7002
    ld c, [hl]                                    ; $7003
    inc hl                                        ; $7004
    ld b, [hl]                                    ; $7005
    ldh a, [hFrameCounter]                        ; $7006
    srl a                                         ; $7008
    srl a                                         ; $700A
    srl a                                         ; $700C
    and $03                                       ; $700E
    add $04                                       ; $7010
    call Oam_AddMeta_B02_6E4B                     ; $7012
    ret                                           ; $7015


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptB_ValuePosTbl::
    db $84, $15, $84, $60

; C: B -> mode 0B; A -> next state
Mode0D_State05_FadeOutHub::
    call Pal_FadeOut                              ; $701A
    call Lcd_Off                                  ; $701D
    ld a, [wAbResult]                             ; $7020
    bit 0, a                                      ; $7023
    jr nz, jr_007_7032                            ; $7025

    ld a, MODE_SHOW_MENU                          ; $7027
    ld [wMode], a                                 ; $7029
    ld a, STATE_0B_INIT                           ; $702C
    ld [wState], a                                ; $702E
    ret                                           ; $7031


jr_007_7032:
    ld hl, wState                                 ; $7032
    inc [hl]                                      ; $7035
    ret                                           ; $7036


; C: no photo -> state 9
Mode0D_State06_PlayInit::
    ld a, [wPhotoCount]                           ; $7037
    and a                                         ; $703A
    jr nz, jr_007_7043                            ; $703B

    ld a, STATE_0D_NO_PHOTOS_MESSAGE              ; $703D
    ld [wState], a                                ; $703F
    ret                                           ; $7042


jr_007_7043:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7043
    ldh [hLcdcShadow], a                          ; $7045
    ld a, $e4                                     ; $7047
    ld [wPaletteTarget], a                        ; $7049
    ld [wPaletteTarget + $1], a                   ; $704C
    ld [wPaletteTarget + $2], a                   ; $704F
    ld a, $10                                     ; $7052
    ldh [hScxShadow], a                           ; $7054
    ldh [hScyShadow], a                           ; $7056
    ld a, BANK(Gfx_0C_7930_Mode09_State00_Init)   ; $7058
    ld hl, Gfx_0C_7930_Mode09_State00_Init        ; $705A
    ld de, $8ff0                                  ; $705D
    ld bc, $0010                                  ; $7060
    call Mem_CopyFromBank                         ; $7063
    ld a, BANK(Map_27_4470_Mode0D_State06_PlayInit); $7066
    ld hl, Map_27_4470_Mode0D_State06_PlayInit    ; $7068
    ld de, $9800                                  ; $706B
    ld bc, $02c0                                  ; $706E
    call Mem_CopyFromBank                         ; $7071
    xor a                                         ; $7074
    ld [wSlideshowIdx], a                         ; $7075
    ld a, [wPlayOptB]                             ; $7078
    and a                                         ; $707B
    jr nz, jr_007_7087                            ; $707C

    ld a, [wPhotoCount]                           ; $707E
    call Rng_Scaled                               ; $7081
    ld [wSlideshowIdx], a                         ; $7084

jr_007_7087:
    ld a, $3c                                     ; $7087
    ld [wPlayInterval], a                         ; $7089
    ld [wPlayCountdown], a                        ; $708C
    ld a, $01                                     ; $708F
    ld [wPlayDirection], a                        ; $7091
    ld a, [wSlideshowIdx]                         ; $7094
    ldh [hFarcallAArg], a                         ; $7097
    ld a, BANK(Photo_LoadToVram_Far)              ; $7099
    ld hl, Photo_LoadToVram_Far                   ; $709B
    call Far_Call                                 ; $709E
    ld a, $54                                     ; $70A1
    ldh [hLycShadowSplit1], a                     ; $70A3
    ldh [hSplit1Latch], a                         ; $70A5
    ld hl, hStatShadow                            ; $70A7
    set 6, [hl]                                   ; $70AA
    ld hl, rIE                                    ; $70AC
    set 1, [hl]                                   ; $70AF
    ld a, $01                                     ; $70B1
    ldh [hStatHandlerIndex], a                    ; $70B3
    call Oam_ClearShadow                          ; $70B5
    call Pal_AllWhite                             ; $70B8
    call Lcd_On                                   ; $70BB
    ld a, [wPlayOptA]                             ; $70BE
    and a                                         ; $70C1
    jr nz, jr_007_70cd                            ; $70C2

    push af                                       ; $70C4
    ld a, MUSIC_SLIDESHOW_PLAY                    ; $70C5
    call Snd_Music                                ; $70C7
    pop af                                        ; $70CA
    jr jr_007_70d4                                ; $70CB

jr_007_70cd:
    push af                                       ; $70CD
    ld a, MUSIC_STOP                              ; $70CE
    call Snd_Music                                ; $70D0
    pop af                                        ; $70D3

jr_007_70d4:
    call Pal_FadeIn                               ; $70D4
    ld hl, wState                                 ; $70D7
    inc [hl]                                      ; $70DA
    ret                                           ; $70DB


; C: countdown; next photo; Left/Right = direction; Up/Down = interval
Mode0D_State07_Play::
    ld hl, wPlayCountdown                         ; $70DC
    dec [hl]                                      ; $70DF
    jr nz, jr_007_70e9                            ; $70E0

    ld a, [wPlayInterval]                         ; $70E2
    ld [hl], a                                    ; $70E5
    call SlidePlay_ShowNext                       ; $70E6

jr_007_70e9:
    call SlidePlay_ReadKeys                       ; $70E9
    ldh a, [hKeysNewSticky]                       ; $70EC
    and PADF_A | PADF_B                           ; $70EE
    ret z                                         ; $70F0

    ld [wAbResult], a                             ; $70F1
    ld hl, wState                                 ; $70F4
    inc [hl]                                      ; $70F7
    ret                                           ; $70F8


; C
Mode0D_State08_PlayExit::
    call Pal_FadeOut                              ; $70F9
    call Lcd_Off                                  ; $70FC
    ld hl, hStatShadow                            ; $70FF
    res 6, [hl]                                   ; $7102
    ld hl, rIE                                    ; $7104
    res 1, [hl]                                   ; $7107
    ld a, [wAbResult]                             ; $7109
    bit 0, a                                      ; $710C
    jr nz, jr_007_7116                            ; $710E

    ld a, STATE_0D_INIT                           ; $7110
    ld [wState], a                                ; $7112
    ret                                           ; $7115


jr_007_7116:
    ld a, STATE_0D_INIT                           ; $7116
    ld [wState], a                                ; $7118
    ret                                           ; $711B


; C: result_msg_id := 5
Mode0D_State09_NoPhotosMessage::
    xor a                                         ; $711C
    ld [wSubstate], a                             ; $711D
    ld a, $05                                     ; $7120
    ld [wResultMsgId], a                          ; $7122
    ld hl, wState                                 ; $7125
    inc [hl]                                      ; $7128
    ret                                           ; $7129


; C: far call 09:7290
Mode0D_State0A_ResultScreen::
    ldh [hFarcallAArg], a                         ; $712A
    ld a, BANK(ResultScreen_Far)                  ; $712C
    ld hl, ResultScreen_Far                       ; $712E
    call Far_Call                                 ; $7131
    ret                                           ; $7134


; C: jp state 0
Mode0D_State0B_Restart::
    jp Mode0D_State00_Init                        ; $7135


; C: random (Rng_Scaled) or next/previous; far calls 02:5110 and 02:4E5F; with the P.VOICE option ($D7D2 = 1) also
; Snd_PlayTagDigits (07:7169-717E)
SlidePlay_ShowNext::
    ld a, [wPlayOptB]                             ; $7138
    and a                                         ; $713B
    jr z, jr_007_7156                             ; $713C

    ld a, [wSlideshowIdx]                         ; $713E
    ld hl, wPlayDirection                         ; $7141
    add [hl]                                      ; $7144
    ld hl, wPhotoCount                            ; $7145
    bit 7, a                                      ; $7148
    jr z, jr_007_7150                             ; $714A

    ld a, [hl]                                    ; $714C
    dec a                                         ; $714D
    jr jr_007_7154                                ; $714E

jr_007_7150:
    cp [hl]                                       ; $7150
    jr nz, jr_007_7154                            ; $7151

    xor a                                         ; $7153

jr_007_7154:
    jr jr_007_715c                                ; $7154

jr_007_7156:
    ld a, [wPhotoCount]                           ; $7156
    call Rng_Scaled                               ; $7159

jr_007_715c:
    ld [wSlideshowIdx], a                         ; $715C
    ldh [hFarcallAArg], a                         ; $715F
    ld a, BANK(Photo_LoadToVram_Far)              ; $7161
    ld hl, Photo_LoadToVram_Far                   ; $7163
    call Far_Call                                 ; $7166
    ld a, [wPlayOptA]                             ; $7169
    and a                                         ; $716C
    ret z                                         ; $716D

    ld a, [wSlideshowIdx]                         ; $716E
    ldh [hFarcallAArg], a                         ; $7171
    ld a, BANK(Photo_LoadTagFields_Far)           ; $7173
    ld hl, Photo_LoadTagFields_Far                ; $7175
    call Far_Call                                 ; $7178
    call Snd_PlayTagDigits                        ; $717B
    ret                                           ; $717E


; C: Left/Right = direction; Up/Down = interval 1..$FA
SlidePlay_ReadKeys::
    ldh a, [hKeysNewSticky]                       ; $717F
    ld b, a                                       ; $7181
    bit 5, b                                      ; $7182
    jr z, jr_007_718a                             ; $7184

    ld a, $ff                                     ; $7186
    jr jr_007_7190                                ; $7188

jr_007_718a:
    bit 4, b                                      ; $718A
    jr z, jr_007_7193                             ; $718C

    ld a, $01                                     ; $718E

jr_007_7190:
    ld [wPlayDirection], a                        ; $7190

jr_007_7193:
    ldh a, [hKeysHeldSticky]                      ; $7193
    ld b, a                                       ; $7195
    ld a, [wPlayInterval]                         ; $7196
    bit 6, b                                      ; $7199
    jr z, jr_007_71a3                             ; $719B

    cp $01                                        ; $719D
    ret z                                         ; $719F

    dec a                                         ; $71A0
    jr jr_007_71ab                                ; $71A1

jr_007_71a3:
    bit 7, b                                      ; $71A3
    jr z, jr_007_71ab                             ; $71A5

    cp $fa                                        ; $71A7
    ret z                                         ; $71A9

    inc a                                         ; $71AA

jr_007_71ab:
    ld [wPlayInterval], a                         ; $71AB
    ret                                           ; $71AE


; C: mode 0: main menu (two pages: SHOOT/VIEW/Arcade; Doodle/LINK/Special/Edit)
Mode00_MainMenu::
    ld a, [wState]                                ; $71AF
    rst Rst18_JumpTable                           ; $71B2

; C: 9 states
Mode00_StateTable::
    dw Mode00_State00_Init
    dw Mode00_State01_Item0_Shoot
    dw Mode00_State02_Item1_View
    dw Mode00_State03_Item2_Arcade
    dw Mode00_State04_Item3_Doodle
    dw Mode00_State05_Item4_Link
    dw Mode00_State06_Item5_Special
    dw Mode00_State07_Item6_Edit
    dw Mode00_State08_Launch

; C
Mode00_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $71C5
    ldh [hLcdcShadow], a                          ; $71C7
    ld a, $e4                                     ; $71C9
    ld [wPaletteTarget], a                        ; $71CB
    ld [wPaletteTarget + $1], a                   ; $71CE
    ld a, $d2                                     ; $71D1
    ld [wPaletteTarget + $2], a                   ; $71D3
    xor a                                         ; $71D6
    ldh [hScxShadow], a                           ; $71D7
    ldh [hScyShadow], a                           ; $71D9
    ld [wMenuUpCol], a                            ; $71DB
    ldh [hFarcallAArg], a                         ; $71DE
    ld a, BANK(Owner_GenerateId_Far)              ; $71E0
    ld hl, Owner_GenerateId_Far                   ; $71E2
    call Far_Call                                 ; $71E5
    call MainMenu_LoadIconTilesB                  ; $71E8
    call MainMenu_LoadIconTilesA                  ; $71EB
    call MainMenu_LoadBaseTiles                   ; $71EE
    call MainMenu_LoadBackground                  ; $71F1
    ld a, BANK(Gfx_15_5400_Mode00_State00_Init)   ; $71F4
    ld hl, Gfx_15_5400_Mode00_State00_Init        ; $71F6
    ld de, $9000                                  ; $71F9
    ld bc, $0100                                  ; $71FC
    call Mem_CopyFromBank                         ; $71FF
    ld a, BANK(Gfx_15_4600_Mode00_State00_Init)   ; $7202
    ld hl, Gfx_15_4600_Mode00_State00_Init        ; $7204
    ld de, $8e00                                  ; $7207
    ld bc, $0300                                  ; $720A
    call Mem_CopyFromBank                         ; $720D
    ld a, BANK(Gfx_15_4900_Mode00_State00_Init)   ; $7210
    ld hl, Gfx_15_4900_Mode00_State00_Init        ; $7212
    ld de, $9700                                  ; $7215
    ld bc, $0100                                  ; $7218
    call Mem_CopyFromBank                         ; $721B
    ld a, BANK(Gfx_15_5600_Mode00_State00_Init)   ; $721E
    ld hl, Gfx_15_5600_Mode00_State00_Init        ; $7220
    ld de, $8500                                  ; $7223
    ld bc, $0100                                  ; $7226
    call Mem_CopyFromBank                         ; $7229
    ld hl, $9a40                                  ; $722C
    ld bc, $01c0                                  ; $722F
    ld a, $7f                                     ; $7232
    call Mem_FillBc1                              ; $7234
    call Oam_ClearShadow                          ; $7237
    call Pal_AllWhite                             ; $723A
    call Lcd_On                                   ; $723D
    call Pal_FadeIn                               ; $7240
    push af                                       ; $7243
    ld a, MUSIC_MAIN_MENU                         ; $7244
    call Snd_Music                                ; $7246
    pop af                                        ; $7249
    ld a, [wMenuItem]                             ; $724A
    ld c, a                                       ; $724D
    ld b, $00                                     ; $724E
    ld hl, Mode00_State00_Init_Tbl7259            ; $7250
    add hl, bc                                    ; $7253
    ld a, [hl]                                    ; $7254
    ld [wState], a                                ; $7255
    ret                                           ; $7258


; C: auto: 7 bytes, bytes; referenced by Mode00_State00_Init. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the
; organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Mode00_State00_Init_Tbl7259::
    db $01, $02, $03, $04, $05, $06, $07

; C: upper page item 0 selected
Mode00_State01_Item0_Shoot::
    call MainMenu_DrawUpperItem0                  ; $7260
    ldh a, [hKeysNew]                             ; $7263
    and PADF_A | PADF_B | PADF_START              ; $7265
    jr z, jr_007_728a                             ; $7267

    ld [wAbResult], a                             ; $7269
    ld a, [wState]                                ; $726C
    ld [wMenuStateCopy], a                        ; $726F
    push af                                       ; $7272
    bit 0, a                                      ; $7273
    ld a, SFX1_KEY_A                              ; $7275
    call nz, Snd_Sfx1                             ; $7277
    pop af                                        ; $727A
    push af                                       ; $727B
    bit 1, a                                      ; $727C
    ld a, SFX1_KEY_B                              ; $727E
    call nz, Snd_Sfx1                             ; $7280
    pop af                                        ; $7283
    ld a, STATE_00_LAUNCH                         ; $7284
    ld [wState], a                                ; $7286
    ret                                           ; $7289


jr_007_728a:
    ldh a, [hKeysNew]                             ; $728A
    bit PADB_LEFT, a                              ; $728C
    jr z, jr_007_72ab                             ; $728E

    push af                                       ; $7290
    ld a, SFX3_MAIN_MENU_SHOOT                    ; $7291
    call Snd_Sfx3                                 ; $7293
    pop af                                        ; $7296
    ld de, MainMenu_SlideA_Tbl0                   ; $7297
    ld hl, MainMenu_DrawUpperItem0                ; $729A
    call MainMenu_SlideA_Begin                    ; $729D
    ld a, $01                                     ; $72A0
    ld [wMenuItem], a                             ; $72A2
    ld a, STATE_00_ITEM1_VIEW                     ; $72A5
    ld [wState], a                                ; $72A7
    ret                                           ; $72AA


jr_007_72ab:
    bit 7, a                                      ; $72AB
    jr z, jr_007_72ce                             ; $72AD

    push af                                       ; $72AF
    ld a, SFX3_MAIN_MENU_SHOOT                    ; $72B0
    call Snd_Sfx3                                 ; $72B2
    pop af                                        ; $72B5
    ld de, MainMenu_SlideA_Tbl0                   ; $72B6
    ld hl, MainMenu_DrawUpperItem0                ; $72B9
    call MainMenu_SlideA_Begin                    ; $72BC
    xor a                                         ; $72BF
    ld [wMenuUpCol], a                            ; $72C0
    ld a, $02                                     ; $72C3
    ld [wMenuItem], a                             ; $72C5
    ld a, STATE_00_ITEM2_ARCADE                   ; $72C8
    ld [wState], a                                ; $72CA
    ret                                           ; $72CD


jr_007_72ce:
    bit 2, a                                      ; $72CE
    ret z                                         ; $72D0

    push af                                       ; $72D1
    ld a, SFX3_MAIN_MENU_SHOOT                    ; $72D2
    call Snd_Sfx3                                 ; $72D4
    pop af                                        ; $72D7
    ld de, MainMenu_SlideA_Tbl0                   ; $72D8
    ld hl, MainMenu_DrawUpperItem0                ; $72DB
    call MainMenu_SlideA_Begin                    ; $72DE
    call MainMenu_TransitionToLowerPage           ; $72E1
    ld a, $00                                     ; $72E4
    ld [wMenuSelUpper], a                         ; $72E6
    ret                                           ; $72E9


; C: upper page item 1 selected
Mode00_State02_Item1_View::
    call MainMenu_DrawUpperItem1                  ; $72EA
    ldh a, [hKeysNew]                             ; $72ED
    and PADF_A | PADF_B | PADF_START              ; $72EF
    jr z, jr_007_7314                             ; $72F1

    ld [wAbResult], a                             ; $72F3
    ld a, [wState]                                ; $72F6
    ld [wMenuStateCopy], a                        ; $72F9
    push af                                       ; $72FC
    bit 0, a                                      ; $72FD
    ld a, SFX1_KEY_A                              ; $72FF
    call nz, Snd_Sfx1                             ; $7301
    pop af                                        ; $7304
    push af                                       ; $7305
    bit 1, a                                      ; $7306
    ld a, SFX1_KEY_B                              ; $7308
    call nz, Snd_Sfx1                             ; $730A
    pop af                                        ; $730D
    ld a, STATE_00_LAUNCH                         ; $730E
    ld [wState], a                                ; $7310
    ret                                           ; $7313


jr_007_7314:
    ldh a, [hKeysNew]                             ; $7314
    bit PADB_RIGHT, a                             ; $7316
    jr z, jr_007_7334                             ; $7318

    push af                                       ; $731A
    ld a, SFX3_MAIN_MENU_VIEW_ARCADE              ; $731B
    call Snd_Sfx3                                 ; $731D
    pop af                                        ; $7320
    ld de, MainMenu_SlideA_Tbl1                   ; $7321
    ld hl, MainMenu_DrawUpperItem1                ; $7324
    call MainMenu_SlideA_Begin                    ; $7327
    xor a                                         ; $732A
    ld [wMenuItem], a                             ; $732B
    ld a, STATE_00_ITEM0_SHOOT                    ; $732E
    ld [wState], a                                ; $7330
    ret                                           ; $7333


jr_007_7334:
    bit 7, a                                      ; $7334
    jr z, jr_007_734f                             ; $7336

    ld a, $01                                     ; $7338
    ld [wMenuUpCol], a                            ; $733A
    ld a, $02                                     ; $733D
    ld [wMenuItem], a                             ; $733F
    push af                                       ; $7342
    ld a, SFX1_KEY_START                          ; $7343
    call Snd_Sfx1                                 ; $7345
    pop af                                        ; $7348
    ld a, STATE_00_ITEM2_ARCADE                   ; $7349
    ld [wState], a                                ; $734B
    ret                                           ; $734E


jr_007_734f:
    bit 2, a                                      ; $734F
    ret z                                         ; $7351

    call MainMenu_TransitionToLowerPage           ; $7352
    ld a, $01                                     ; $7355
    ld [wMenuSelUpper], a                         ; $7357
    ret                                           ; $735A


; C: upper page item 2 selected
Mode00_State03_Item2_Arcade::
    call MainMenu_DrawUpperItem2                  ; $735B
    ldh a, [hKeysNew]                             ; $735E
    and PADF_A | PADF_B | PADF_START              ; $7360
    jr z, jr_007_7385                             ; $7362

    ld [wAbResult], a                             ; $7364
    ld a, [wState]                                ; $7367
    ld [wMenuStateCopy], a                        ; $736A
    push af                                       ; $736D
    bit 0, a                                      ; $736E
    ld a, SFX1_KEY_A                              ; $7370
    call nz, Snd_Sfx1                             ; $7372
    pop af                                        ; $7375
    push af                                       ; $7376
    bit 1, a                                      ; $7377
    ld a, SFX1_KEY_B                              ; $7379
    call nz, Snd_Sfx1                             ; $737B
    pop af                                        ; $737E
    ld a, STATE_00_LAUNCH                         ; $737F
    ld [wState], a                                ; $7381
    ret                                           ; $7384


jr_007_7385:
    ldh a, [hKeysNew]                             ; $7385
    bit PADB_SELECT, a                            ; $7387
    jr z, jr_007_7394                             ; $7389

    call MainMenu_TransitionToLowerPage           ; $738B
    ld a, $02                                     ; $738E
    ld [wMenuSelUpper], a                         ; $7390
    ret                                           ; $7393


jr_007_7394:
    bit 4, a                                      ; $7394
    jr z, jr_007_73c0                             ; $7396

jr_007_7398:
    ld a, BANK(Gfx_15_4E00_MainMenu_LoadBaseTiles); $7398
    ld hl, Gfx_15_4E00_MainMenu_LoadBaseTiles     ; $739A
    ld de, $8300                                  ; $739D
    ld bc, $0200                                  ; $73A0
    call Vram_CopyFromBank                        ; $73A3
    push af                                       ; $73A6
    ld a, SFX3_MAIN_MENU_VIEW_ARCADE              ; $73A7
    call Snd_Sfx3                                 ; $73A9
    pop af                                        ; $73AC
    ld de, MainMenu_SlideA_Tbl1                   ; $73AD
    ld hl, MainMenu_DrawUpperItem2                ; $73B0
    call MainMenu_SlideA_Begin                    ; $73B3
    xor a                                         ; $73B6
    ld [wMenuItem], a                             ; $73B7
    ld a, STATE_00_ITEM0_SHOOT                    ; $73BA
    ld [wState], a                                ; $73BC
    ret                                           ; $73BF


jr_007_73c0:
    bit 5, a                                      ; $73C0
    jr z, jr_007_73e4                             ; $73C2

jr_007_73c4:
    ld a, BANK(Gfx_15_4E00_MainMenu_LoadBaseTiles); $73C4
    ld hl, Gfx_15_4E00_MainMenu_LoadBaseTiles     ; $73C6
    ld de, $8300                                  ; $73C9
    ld bc, $0200                                  ; $73CC
    call Vram_CopyFromBank                        ; $73CF
    ld a, $01                                     ; $73D2
    ld [wMenuItem], a                             ; $73D4
    push af                                       ; $73D7
    ld a, SFX1_KEY_START                          ; $73D8
    call Snd_Sfx1                                 ; $73DA
    pop af                                        ; $73DD
    ld a, STATE_00_ITEM1_VIEW                     ; $73DE
    ld [wState], a                                ; $73E0
    ret                                           ; $73E3


jr_007_73e4:
    bit 6, a                                      ; $73E4
    ret z                                         ; $73E6

    ld a, [wMenuUpCol]                            ; $73E7
    and a                                         ; $73EA
    jr z, jr_007_7398                             ; $73EB

    jr jr_007_73c4                                ; $73ED

; C: screen shake and page slide
MainMenu_TransitionToLowerPage::
    push af                                       ; $73EF
    ld a, SFX1_MAIN_MENU_PAGE_TURN                ; $73F0
    call Snd_Sfx1                                 ; $73F2
    pop af                                        ; $73F5
    ld de, MainMenu_SlideB_Tbl0                   ; $73F6
    ld hl, $74a8                                  ; $73F9
    call MainMenu_SlideB_Begin                    ; $73FC
    ld a, $03                                     ; $73FF

jr_007_7401:
    push af                                       ; $7401
    call Rng_Next                                 ; $7402
    and $03                                       ; $7405
    sub $01                                       ; $7407
    ldh [hScxShadow], a                           ; $7409
    call Rng_Next                                 ; $740B
    and $03                                       ; $740E
    sub $01                                       ; $7410
    ldh [hScyShadow], a                           ; $7412
    rst Rst08_WaitVBlank                          ; $7414
    pop af                                        ; $7415
    dec a                                         ; $7416
    jr nz, jr_007_7401                            ; $7417

    xor a                                         ; $7419
    ldh [hScxShadow], a                           ; $741A
    ldh [hScyShadow], a                           ; $741C
    push af                                       ; $741E
    ld a, SFX1_MAIN_MENU_PAGE_DOWN                ; $741F
    call Snd_Sfx1                                 ; $7421
    pop af                                        ; $7424
    ld de, MainMenu_SlideB_Tbl2                   ; $7425
    ld hl, $74a8                                  ; $7428
    call MainMenu_SlideB_Begin                    ; $742B
    ld de, MainMenu_SlideC_Tbl0                   ; $742E
    ld hl, $74a8                                  ; $7431
    call MainMenu_SlideC_Begin                    ; $7434
    ld a, [wMenuSelLower]                         ; $7437
    and a                                         ; $743A
    jr nz, jr_007_7456                            ; $743B

    ld a, BANK(Gfx_15_4D00_MainMenu_LoadBackground); $743D
    ld hl, Gfx_15_4D00_MainMenu_LoadBackground    ; $743F
    ld de, $8700                                  ; $7442
    ld bc, $0100                                  ; $7445
    call Vram_CopyFromBank                        ; $7448
    ld a, $03                                     ; $744B
    ld [wMenuItem], a                             ; $744D
    ld a, STATE_00_ITEM3_DOODLE                   ; $7450
    ld [wState], a                                ; $7452
    ret                                           ; $7455


jr_007_7456:
    cp $01                                        ; $7456
    jr nz, jr_007_7473                            ; $7458

    ld a, BANK(Gfx_15_4A00_MainMenu_LoadBackground); $745A
    ld hl, Gfx_15_4A00_MainMenu_LoadBackground    ; $745C
    ld de, $8700                                  ; $745F
    ld bc, $0100                                  ; $7462
    call Vram_CopyFromBank                        ; $7465
    ld a, $04                                     ; $7468
    ld [wMenuItem], a                             ; $746A
    ld a, STATE_00_ITEM4_LINK                     ; $746D
    ld [wState], a                                ; $746F
    ret                                           ; $7472


jr_007_7473:
    cp $02                                        ; $7473
    jr nz, jr_007_7490                            ; $7475

    ld a, BANK(Gfx_15_4B00_MainMenu_LoadBackground); $7477
    ld hl, Gfx_15_4B00_MainMenu_LoadBackground    ; $7479
    ld de, $8700                                  ; $747C
    ld bc, $0100                                  ; $747F
    call Vram_CopyFromBank                        ; $7482
    ld a, $05                                     ; $7485
    ld [wMenuItem], a                             ; $7487
    ld a, STATE_00_ITEM5_SPECIAL                  ; $748A
    ld [wState], a                                ; $748C
    ret                                           ; $748F


jr_007_7490:
    ld a, BANK(Gfx_15_4C00_MainMenu_LoadBackground); $7490
    ld hl, Gfx_15_4C00_MainMenu_LoadBackground    ; $7492
    ld de, $8700                                  ; $7495
    ld bc, $0100                                  ; $7498
    call Vram_CopyFromBank                        ; $749B
    ld a, $06                                     ; $749E
    ld [wMenuItem], a                             ; $74A0
    ld a, STATE_00_ITEM6_EDIT                     ; $74A3
    ld [wState], a                                ; $74A5
    ret                                           ; $74A8


; C: lower page item 3 selected
Mode00_State04_Item3_Doodle::
    call MainMenu_DrawLowerItem3                  ; $74A9
    ldh a, [hKeysNew]                             ; $74AC
    bit PADB_A, a                                 ; $74AE
    jr z, jr_007_74c8                             ; $74B0

    ld [wAbResult], a                             ; $74B2
    ld a, [wState]                                ; $74B5
    ld [wMenuStateCopy], a                        ; $74B8
    push af                                       ; $74BB
    ld a, SFX1_KEY_A                              ; $74BC
    call Snd_Sfx1                                 ; $74BE
    pop af                                        ; $74C1
    ld a, STATE_00_LAUNCH                         ; $74C2
    ld [wState], a                                ; $74C4
    ret                                           ; $74C7


jr_007_74c8:
    ldh a, [hKeysNew]                             ; $74C8
    bit PADB_UP, a                                ; $74CA
    jr z, jr_007_74f2                             ; $74CC

    push af                                       ; $74CE
    ld a, SFX1_MAIN_MENU_MOVE                     ; $74CF
    call Snd_Sfx1                                 ; $74D1
    pop af                                        ; $74D4
    call Oam_ClearShadow                          ; $74D5
    rst Rst08_WaitVBlank                          ; $74D8
    ld a, BANK(Gfx_15_4A00_MainMenu_LoadBackground); $74D9
    ld hl, Gfx_15_4A00_MainMenu_LoadBackground    ; $74DB
    ld de, $8700                                  ; $74DE
    ld bc, $0100                                  ; $74E1
    call Vram_CopyFromBank                        ; $74E4
    ld a, $04                                     ; $74E7
    ld [wMenuItem], a                             ; $74E9
    ld a, STATE_00_ITEM4_LINK                     ; $74EC
    ld [wState], a                                ; $74EE
    ret                                           ; $74F1


jr_007_74f2:
    bit 4, a                                      ; $74F2
    jr z, jr_007_751a                             ; $74F4

    push af                                       ; $74F6
    ld a, SFX1_MAIN_MENU_MOVE                     ; $74F7
    call Snd_Sfx1                                 ; $74F9
    pop af                                        ; $74FC
    call Oam_ClearShadow                          ; $74FD
    rst Rst08_WaitVBlank                          ; $7500
    ld a, BANK(Gfx_15_4B00_MainMenu_LoadBackground); $7501
    ld hl, Gfx_15_4B00_MainMenu_LoadBackground    ; $7503
    ld de, $8700                                  ; $7506
    ld bc, $0100                                  ; $7509
    call Vram_CopyFromBank                        ; $750C
    ld a, $05                                     ; $750F
    ld [wMenuItem], a                             ; $7511
    ld a, STATE_00_ITEM5_SPECIAL                  ; $7514
    ld [wState], a                                ; $7516
    ret                                           ; $7519


jr_007_751a:
    bit 7, a                                      ; $751A
    jr z, jr_007_7542                             ; $751C

    push af                                       ; $751E
    ld a, SFX1_MAIN_MENU_MOVE                     ; $751F
    call Snd_Sfx1                                 ; $7521
    pop af                                        ; $7524
    call Oam_ClearShadow                          ; $7525
    rst Rst08_WaitVBlank                          ; $7528
    ld a, BANK(Gfx_15_4C00_MainMenu_LoadBackground); $7529
    ld hl, Gfx_15_4C00_MainMenu_LoadBackground    ; $752B
    ld de, $8700                                  ; $752E
    ld bc, $0100                                  ; $7531
    call Vram_CopyFromBank                        ; $7534
    ld a, $06                                     ; $7537
    ld [wMenuItem], a                             ; $7539
    ld a, STATE_00_ITEM6_EDIT                     ; $753C
    ld [wState], a                                ; $753E
    ret                                           ; $7541


jr_007_7542:
    bit 2, a                                      ; $7542
    jr nz, jr_007_7549                            ; $7544

    bit 1, a                                      ; $7546
    ret z                                         ; $7548

jr_007_7549:
    xor a                                         ; $7549
    ld [wMenuSelLower], a                         ; $754A
    call MainMenu_TransitionToUpperPage           ; $754D
    ret                                           ; $7550


; C: lower page item 4 selected
Mode00_State05_Item4_Link::
    call MainMenu_DrawLowerItem4                  ; $7551
    ldh a, [hKeysNew]                             ; $7554
    bit PADB_A, a                                 ; $7556
    jr z, jr_007_7570                             ; $7558

    ld [wAbResult], a                             ; $755A
    ld a, [wState]                                ; $755D
    ld [wMenuStateCopy], a                        ; $7560
    push af                                       ; $7563
    ld a, SFX1_KEY_A                              ; $7564
    call Snd_Sfx1                                 ; $7566
    pop af                                        ; $7569
    ld a, STATE_00_LAUNCH                         ; $756A
    ld [wState], a                                ; $756C
    ret                                           ; $756F


jr_007_7570:
    ldh a, [hKeysNew]                             ; $7570
    bit PADB_LEFT, a                              ; $7572
    jr z, jr_007_759a                             ; $7574

    push af                                       ; $7576
    ld a, SFX1_MAIN_MENU_MOVE                     ; $7577
    call Snd_Sfx1                                 ; $7579
    pop af                                        ; $757C
    call Oam_ClearShadow                          ; $757D
    rst Rst08_WaitVBlank                          ; $7580
    ld a, BANK(Gfx_15_4D00_MainMenu_LoadBackground); $7581
    ld hl, Gfx_15_4D00_MainMenu_LoadBackground    ; $7583
    ld de, $8700                                  ; $7586
    ld bc, $0100                                  ; $7589
    call Vram_CopyFromBank                        ; $758C
    ld a, $03                                     ; $758F
    ld [wMenuItem], a                             ; $7591
    ld a, STATE_00_ITEM3_DOODLE                   ; $7594
    ld [wState], a                                ; $7596
    ret                                           ; $7599


jr_007_759a:
    bit 4, a                                      ; $759A
    jr z, jr_007_75c2                             ; $759C

    push af                                       ; $759E
    ld a, SFX1_MAIN_MENU_MOVE                     ; $759F
    call Snd_Sfx1                                 ; $75A1
    pop af                                        ; $75A4
    call Oam_ClearShadow                          ; $75A5
    rst Rst08_WaitVBlank                          ; $75A8
    ld a, BANK(Gfx_15_4B00_MainMenu_LoadBackground); $75A9
    ld hl, Gfx_15_4B00_MainMenu_LoadBackground    ; $75AB
    ld de, $8700                                  ; $75AE
    ld bc, $0100                                  ; $75B1
    call Vram_CopyFromBank                        ; $75B4
    ld a, $05                                     ; $75B7
    ld [wMenuItem], a                             ; $75B9
    ld a, STATE_00_ITEM5_SPECIAL                  ; $75BC
    ld [wState], a                                ; $75BE
    ret                                           ; $75C1


jr_007_75c2:
    bit 7, a                                      ; $75C2
    jr z, jr_007_75ea                             ; $75C4

    push af                                       ; $75C6
    ld a, SFX1_MAIN_MENU_MOVE                     ; $75C7
    call Snd_Sfx1                                 ; $75C9
    pop af                                        ; $75CC
    call Oam_ClearShadow                          ; $75CD
    rst Rst08_WaitVBlank                          ; $75D0
    ld a, BANK(Gfx_15_4C00_MainMenu_LoadBackground); $75D1
    ld hl, Gfx_15_4C00_MainMenu_LoadBackground    ; $75D3
    ld de, $8700                                  ; $75D6
    ld bc, $0100                                  ; $75D9
    call Vram_CopyFromBank                        ; $75DC
    ld a, $06                                     ; $75DF
    ld [wMenuItem], a                             ; $75E1
    ld a, STATE_00_ITEM6_EDIT                     ; $75E4
    ld [wState], a                                ; $75E6
    ret                                           ; $75E9


jr_007_75ea:
    bit 2, a                                      ; $75EA
    jr nz, jr_007_75f1                            ; $75EC

    bit 1, a                                      ; $75EE
    ret z                                         ; $75F0

jr_007_75f1:
    ld a, $01                                     ; $75F1
    ld [wMenuSelLower], a                         ; $75F3
    call MainMenu_TransitionToUpperPage           ; $75F6
    ret                                           ; $75F9


; C: lower page item 5 selected
Mode00_State06_Item5_Special::
    call MainMenu_DrawLowerItem5                  ; $75FA
    ldh a, [hKeysNew]                             ; $75FD
    bit PADB_A, a                                 ; $75FF
    jr z, jr_007_7619                             ; $7601

    ld [wAbResult], a                             ; $7603
    ld a, [wState]                                ; $7606
    ld [wMenuStateCopy], a                        ; $7609
    push af                                       ; $760C
    ld a, SFX1_KEY_A                              ; $760D
    call Snd_Sfx1                                 ; $760F
    pop af                                        ; $7612
    ld a, STATE_00_LAUNCH                         ; $7613
    ld [wState], a                                ; $7615
    ret                                           ; $7618


jr_007_7619:
    ldh a, [hKeysNew]                             ; $7619
    bit PADB_UP, a                                ; $761B
    jr z, jr_007_7643                             ; $761D

    push af                                       ; $761F
    ld a, SFX1_MAIN_MENU_MOVE                     ; $7620
    call Snd_Sfx1                                 ; $7622
    pop af                                        ; $7625
    call Oam_ClearShadow                          ; $7626
    rst Rst08_WaitVBlank                          ; $7629
    ld a, BANK(Gfx_15_4A00_MainMenu_LoadBackground); $762A
    ld hl, Gfx_15_4A00_MainMenu_LoadBackground    ; $762C
    ld de, $8700                                  ; $762F
    ld bc, $0100                                  ; $7632
    call Vram_CopyFromBank                        ; $7635
    ld a, $04                                     ; $7638
    ld [wMenuItem], a                             ; $763A
    ld a, STATE_00_ITEM4_LINK                     ; $763D
    ld [wState], a                                ; $763F
    ret                                           ; $7642


jr_007_7643:
    bit 5, a                                      ; $7643
    jr z, jr_007_766b                             ; $7645

    push af                                       ; $7647
    ld a, SFX1_MAIN_MENU_MOVE                     ; $7648
    call Snd_Sfx1                                 ; $764A
    pop af                                        ; $764D
    call Oam_ClearShadow                          ; $764E
    rst Rst08_WaitVBlank                          ; $7651
    ld a, BANK(Gfx_15_4D00_MainMenu_LoadBackground); $7652
    ld hl, Gfx_15_4D00_MainMenu_LoadBackground    ; $7654
    ld de, $8700                                  ; $7657
    ld bc, $0100                                  ; $765A
    call Vram_CopyFromBank                        ; $765D
    ld a, $03                                     ; $7660
    ld [wMenuItem], a                             ; $7662
    ld a, STATE_00_ITEM3_DOODLE                   ; $7665
    ld [wState], a                                ; $7667
    ret                                           ; $766A


jr_007_766b:
    bit 7, a                                      ; $766B
    jr z, jr_007_7693                             ; $766D

    push af                                       ; $766F
    ld a, SFX1_MAIN_MENU_MOVE                     ; $7670
    call Snd_Sfx1                                 ; $7672
    pop af                                        ; $7675
    call Oam_ClearShadow                          ; $7676
    rst Rst08_WaitVBlank                          ; $7679
    ld a, BANK(Gfx_15_4C00_MainMenu_LoadBackground); $767A
    ld hl, Gfx_15_4C00_MainMenu_LoadBackground    ; $767C
    ld de, $8700                                  ; $767F
    ld bc, $0100                                  ; $7682
    call Vram_CopyFromBank                        ; $7685
    ld a, $06                                     ; $7688
    ld [wMenuItem], a                             ; $768A
    ld a, STATE_00_ITEM6_EDIT                     ; $768D
    ld [wState], a                                ; $768F
    ret                                           ; $7692


jr_007_7693:
    bit 2, a                                      ; $7693
    jr nz, jr_007_769a                            ; $7695

    bit 1, a                                      ; $7697
    ret z                                         ; $7699

jr_007_769a:
    ld a, $02                                     ; $769A
    ld [wMenuSelLower], a                         ; $769C
    call MainMenu_TransitionToUpperPage           ; $769F
    ret                                           ; $76A2


; C: lower page item 6 selected
Mode00_State07_Item6_Edit::
    call MainMenu_DrawLowerItem6                  ; $76A3
    ldh a, [hKeysNew]                             ; $76A6
    bit PADB_A, a                                 ; $76A8
    jr z, jr_007_76c2                             ; $76AA

    ld [wAbResult], a                             ; $76AC
    ld a, [wState]                                ; $76AF
    ld [wMenuStateCopy], a                        ; $76B2
    push af                                       ; $76B5
    ld a, SFX1_KEY_A                              ; $76B6
    call Snd_Sfx1                                 ; $76B8
    pop af                                        ; $76BB
    ld a, STATE_00_LAUNCH                         ; $76BC
    ld [wState], a                                ; $76BE
    ret                                           ; $76C1


jr_007_76c2:
    ldh a, [hKeysNew]                             ; $76C2
    bit PADB_UP, a                                ; $76C4
    jr z, jr_007_76ec                             ; $76C6

    push af                                       ; $76C8
    ld a, SFX1_MAIN_MENU_MOVE                     ; $76C9
    call Snd_Sfx1                                 ; $76CB
    pop af                                        ; $76CE
    call Oam_ClearShadow                          ; $76CF
    rst Rst08_WaitVBlank                          ; $76D2
    ld a, BANK(Gfx_15_4A00_MainMenu_LoadBackground); $76D3
    ld hl, Gfx_15_4A00_MainMenu_LoadBackground    ; $76D5
    ld de, $8700                                  ; $76D8
    ld bc, $0100                                  ; $76DB
    call Vram_CopyFromBank                        ; $76DE
    ld a, $04                                     ; $76E1
    ld [wMenuItem], a                             ; $76E3
    ld a, STATE_00_ITEM4_LINK                     ; $76E6
    ld [wState], a                                ; $76E8
    ret                                           ; $76EB


jr_007_76ec:
    bit 4, a                                      ; $76EC
    jr z, jr_007_7714                             ; $76EE

    push af                                       ; $76F0
    ld a, SFX1_MAIN_MENU_MOVE                     ; $76F1
    call Snd_Sfx1                                 ; $76F3
    pop af                                        ; $76F6
    call Oam_ClearShadow                          ; $76F7
    rst Rst08_WaitVBlank                          ; $76FA
    ld a, BANK(Gfx_15_4B00_MainMenu_LoadBackground); $76FB
    ld hl, Gfx_15_4B00_MainMenu_LoadBackground    ; $76FD
    ld de, $8700                                  ; $7700
    ld bc, $0100                                  ; $7703
    call Vram_CopyFromBank                        ; $7706
    ld a, $05                                     ; $7709
    ld [wMenuItem], a                             ; $770B
    ld a, STATE_00_ITEM5_SPECIAL                  ; $770E
    ld [wState], a                                ; $7710
    ret                                           ; $7713


jr_007_7714:
    bit 5, a                                      ; $7714
    jr z, jr_007_773c                             ; $7716

    push af                                       ; $7718
    ld a, SFX1_MAIN_MENU_MOVE                     ; $7719
    call Snd_Sfx1                                 ; $771B
    pop af                                        ; $771E
    call Oam_ClearShadow                          ; $771F
    rst Rst08_WaitVBlank                          ; $7722
    ld a, BANK(Gfx_15_4D00_MainMenu_LoadBackground); $7723
    ld hl, Gfx_15_4D00_MainMenu_LoadBackground    ; $7725
    ld de, $8700                                  ; $7728
    ld bc, $0100                                  ; $772B
    call Vram_CopyFromBank                        ; $772E
    ld a, $03                                     ; $7731
    ld [wMenuItem], a                             ; $7733
    ld a, STATE_00_ITEM3_DOODLE                   ; $7736
    ld [wState], a                                ; $7738
    ret                                           ; $773B


jr_007_773c:
    bit 2, a                                      ; $773C
    jr nz, jr_007_7743                            ; $773E

    bit 1, a                                      ; $7740
    ret z                                         ; $7742

jr_007_7743:
    ld a, $03                                     ; $7743
    ld [wMenuSelLower], a                         ; $7745
    call MainMenu_TransitionToUpperPage           ; $7748
    ret                                           ; $774B


; C
MainMenu_TransitionToUpperPage::
    push af                                       ; $774C
    ld a, SFX1_MAIN_MENU_PAGE_UP                  ; $774D
    call Snd_Sfx1                                 ; $774F
    pop af                                        ; $7752
    ld de, MainMenu_SlideC_Tbl1                   ; $7753
    ld hl, MainMenu_NoDrawCallback                ; $7756
    call MainMenu_SlideC_Begin                    ; $7759
    ld de, MainMenu_SlideB_Tbl3                   ; $775C
    ld hl, MainMenu_NoDrawCallback                ; $775F
    call MainMenu_SlideB_Begin                    ; $7762
    push af                                       ; $7765
    ld a, SFX1_MAIN_MENU_PAGE_TURN                ; $7766
    call Snd_Sfx1                                 ; $7768
    pop af                                        ; $776B
    ld de, MainMenu_SlideB_Tbl1                   ; $776C
    ld hl, MainMenu_NoDrawCallback                ; $776F
    call MainMenu_SlideB_Begin                    ; $7772
    ld a, [wMenuSelUpper]                         ; $7775
    and a                                         ; $7778
    jr nz, MainMenu_ReturnToUpperItem             ; $7779

    push af                                       ; $777B
    ld a, SFX3_MAIN_MENU_VIEW_ARCADE              ; $777C
    call Snd_Sfx3                                 ; $777E
    pop af                                        ; $7781
    ld de, MainMenu_SlideA_Tbl1                   ; $7782
    ld hl, MainMenu_NoDrawCallback                ; $7785
    call MainMenu_SlideA_Begin                    ; $7788
    xor a                                         ; $778B
    ld [wMenuItem], a                             ; $778C
    ld a, STATE_00_ITEM0_SHOOT                    ; $778F
    ld [wState], a                                ; $7791

; C: a bare ret used as the draw callback
MainMenu_NoDrawCallback::
    ret                                           ; $7794


; C: state 1 / 2 / 3 by menu_sel_upper. L3 pass 2026-10-26: executed in BGB in 33 replay(s) of the organic corpus,
; modes 00 (tcrf_check/assets/l3_names/)
MainMenu_ReturnToUpperItem::
    cp $01                                        ; $7795
    jr nz, jr_007_77a4                            ; $7797

    ld a, $01                                     ; $7799
    ld [wMenuItem], a                             ; $779B
    ld a, STATE_00_ITEM1_VIEW                     ; $779E
    ld [wState], a                                ; $77A0
    ret                                           ; $77A3


jr_007_77a4:
    ld a, $02                                     ; $77A4
    ld [wMenuItem], a                             ; $77A6
    ld a, STATE_00_ITEM2_ARCADE                   ; $77A9
    ld [wState], a                                ; $77AB
    ret                                           ; $77AE


; C: mode := ItemModeTbl [menu_item]; B -> mode $19; Start -> mode 8
Mode00_State08_Launch::
    ld a, [wAbResult]                             ; $77AF
    bit 0, a                                      ; $77B2
    jr z, jr_007_77e4                             ; $77B4

    ld a, [wMenuItem]                             ; $77B6
    ld e, a                                       ; $77B9
    ld d, $00                                     ; $77BA
    ld hl, MainMenu_ItemModeTbl                   ; $77BC
    add hl, de                                    ; $77BF
    ld a, [hl]                                    ; $77C0
    cp MODE_COUNT                                 ; $77C1
    jr c, jr_007_77d3                             ; $77C3

    push af                                       ; $77C5
    ld a, SFX1_BEEP_REFUSED                       ; $77C6
    call Snd_Sfx1                                 ; $77C8
    pop af                                        ; $77CB
    ld a, [wMenuStateCopy]                        ; $77CC
    ld [wState], a                                ; $77CF
    ret                                           ; $77D2


jr_007_77d3:
    ld [wMode], a                                 ; $77D3
    xor a                                         ; $77D6
    ld [wState], a                                ; $77D7
    ld [wDoodleFromShutterbug], a                 ; $77DA
    call Pal_FadeOut                              ; $77DD
    call Lcd_Off                                  ; $77E0
    ret                                           ; $77E3


jr_007_77e4:
    bit 1, a                                      ; $77E4
    jr z, jr_007_77f9                             ; $77E6

    ld a, MODE_TITLE_SCREENS                      ; $77E8
    ld [wMode], a                                 ; $77EA
    ld a, STATE_19_TITLE_FROM_MENU                ; $77ED
    ld [wState], a                                ; $77EF
    call Pal_FadeOut                              ; $77F2
    call Lcd_Off                                  ; $77F5
    ret                                           ; $77F8


jr_007_77f9:
    ld a, MODE_USER_SCREENS                       ; $77F9
    ld [wMode], a                                 ; $77FB
    ld a, STATE_08_INIT                           ; $77FE
    ld [wState], a                                ; $7800
    ret                                           ; $7803


; C: $01 $02 $07 $04 $06 $03 $05
MainMenu_ItemModeTbl::
    db MODE_SHOOT_PARLOR, MODE_VIEW_MENU, MODE_ARCADE_SPACE_FEVER, MODE_DOODLE_MENU, MODE_LINK_MENU, MODE_SPECIAL_MENU, MODE_EDIT_MENU, MODE_NONE

; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadIconTilesA::
    ld a, [wMenuItem]                             ; $780C
    and a                                         ; $780F
    jr z, jr_007_7834                             ; $7810

    cp $03                                        ; $7812
    jr nc, jr_007_7825                            ; $7814

    ld a, BANK(Gfx_16_7180_MainMenu_BallHeadAnim_F4); $7816
    ld hl, Gfx_16_7180_MainMenu_BallHeadAnim_F4   ; $7818
    ld de, $9100                                  ; $781B
    ld bc, $0200                                  ; $781E
    call Mem_CopyFromBank                         ; $7821
    ret                                           ; $7824


jr_007_7825:
    ld a, BANK(Gfx_16_7B80_MainMenu_BallHeadAnim_F9); $7825
    ld hl, Gfx_16_7B80_MainMenu_BallHeadAnim_F9   ; $7827
    ld de, $9100                                  ; $782A
    ld bc, $0200                                  ; $782D
    call Mem_CopyFromBank                         ; $7830
    ret                                           ; $7833


jr_007_7834:
    ld a, BANK(Gfx_16_6980_MainMenu_BallHeadAnim_F0); $7834
    ld hl, Gfx_16_6980_MainMenu_BallHeadAnim_F0   ; $7836
    ld de, $9100                                  ; $7839
    ld bc, $0200                                  ; $783C
    call Mem_CopyFromBank                         ; $783F
    ret                                           ; $7842


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadIconTilesB::
    ld a, [wMenuItem]                             ; $7843
    cp $03                                        ; $7846
    jr nc, jr_007_7859                            ; $7848

    ld a, BANK(Gfx_16_5580_MainMenu_IconStripB_F0); $784A
    ld hl, Gfx_16_5580_MainMenu_IconStripB_F0     ; $784C
    ld de, $9200                                  ; $784F
    ld bc, $0500                                  ; $7852
    call Mem_CopyFromBank                         ; $7855
    ret                                           ; $7858


jr_007_7859:
    ld a, BANK(Gfx_11_4A00_MainMenu_IconStripB_F6); $7859
    ld hl, Gfx_11_4A00_MainMenu_IconStripB_F6     ; $785B
    ld de, $9200                                  ; $785E
    ld bc, $0500                                  ; $7861
    call Mem_CopyFromBank                         ; $7864
    ret                                           ; $7867


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadBaseTiles::
    ld a, BANK(Gfx_11_4F00_MainMenu_LoadBaseTiles); $7868
    ld hl, Gfx_11_4F00_MainMenu_LoadBaseTiles     ; $786A
    ld de, $8000                                  ; $786D
    ld bc, $0300                                  ; $7870
    call Mem_CopyFromBank                         ; $7873
    ld a, BANK(Gfx_15_4E00_MainMenu_LoadBaseTiles); $7876
    ld hl, Gfx_15_4E00_MainMenu_LoadBaseTiles     ; $7878
    ld de, $8300                                  ; $787B
    ld bc, $0200                                  ; $787E
    call Mem_CopyFromBank                         ; $7881
    ret                                           ; $7884


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadBackground::
    ld a, BANK(Map_26_5A00_MainMenu_LoadBackground); $7885
    ld hl, Map_26_5A00_MainMenu_LoadBackground    ; $7887
    ld de, $9800                                  ; $788A
    ld bc, $0240                                  ; $788D
    call Mem_CopyFromBank                         ; $7890
    ld a, $15                                     ; $7893
    ld hl, Gfx_15_4000_MainMenu_LoadBackground    ; $7895
    ld de, $8800                                  ; $7898
    ld bc, $0600                                  ; $789B
    call Mem_CopyFromBank                         ; $789E
    ld a, [wMenuItem]                             ; $78A1
    cp $03                                        ; $78A4
    ret c                                         ; $78A6

    ld a, BANK(Map_27_5F30_MainMenu_LoadBackground); $78A7
    ld hl, Map_27_5F30_MainMenu_LoadBackground    ; $78A9
    ld de, $9860                                  ; $78AC
    ld bc, $01c0                                  ; $78AF
    call Mem_CopyFromBank                         ; $78B2
    ld a, [wMenuItem]                             ; $78B5
    cp $03                                        ; $78B8
    jr nz, jr_007_78cb                            ; $78BA

    ld a, BANK(Gfx_15_4D00_MainMenu_LoadBackground); $78BC
    ld hl, Gfx_15_4D00_MainMenu_LoadBackground    ; $78BE
    ld de, $8700                                  ; $78C1
    ld bc, $0100                                  ; $78C4
    call Mem_CopyFromBank                         ; $78C7
    ret                                           ; $78CA


jr_007_78cb:
    cp $04                                        ; $78CB
    jr nz, jr_007_78de                            ; $78CD

    ld a, BANK(Gfx_15_4A00_MainMenu_LoadBackground); $78CF
    ld hl, Gfx_15_4A00_MainMenu_LoadBackground    ; $78D1
    ld de, $8700                                  ; $78D4
    ld bc, $0100                                  ; $78D7
    call Mem_CopyFromBank                         ; $78DA
    ret                                           ; $78DD


jr_007_78de:
    cp $05                                        ; $78DE
    jr nz, jr_007_78f1                            ; $78E0

    ld a, BANK(Gfx_15_4B00_MainMenu_LoadBackground); $78E2
    ld hl, Gfx_15_4B00_MainMenu_LoadBackground    ; $78E4
    ld de, $8700                                  ; $78E7
    ld bc, $0100                                  ; $78EA
    call Mem_CopyFromBank                         ; $78ED
    ret                                           ; $78F0


jr_007_78f1:
    ld a, BANK(Gfx_15_4C00_MainMenu_LoadBackground); $78F1
    ld hl, Gfx_15_4C00_MainMenu_LoadBackground    ; $78F3
    ld de, $8700                                  ; $78F6
    ld bc, $0100                                  ; $78F9
    call Mem_CopyFromBank                         ; $78FC
    ret                                           ; $78FF


; C: B animators of 6-byte entries at HL
MainMenu_StepIconAnimators::
    ld de, wMenuAnimFrame                         ; $7900

jr_007_7903:
    push bc                                       ; $7903
    push de                                       ; $7904
    ld a, [de]                                    ; $7905
    cp [hl]                                       ; $7906
    jr c, jr_007_790e                             ; $7907

    inc hl                                        ; $7909
    cp [hl]                                       ; $790A
    jr c, jr_007_7911                             ; $790B

    dec hl                                        ; $790D

jr_007_790e:
    ld a, [hl]                                    ; $790E
    ld [de], a                                    ; $790F
    inc hl                                        ; $7910

jr_007_7911:
    inc hl                                        ; $7911
    ld a, e                                       ; $7912
    add $05                                       ; $7913
    ld e, a                                       ; $7915
    jr nc, jr_007_7919                            ; $7916

    inc d                                         ; $7918

jr_007_7919:
    ld a, [hl+]                                   ; $7919
    ld [de], a                                    ; $791A
    ld a, e                                       ; $791B
    add $05                                       ; $791C
    ld e, a                                       ; $791E
    jr nc, jr_007_7922                            ; $791F

    inc d                                         ; $7921

jr_007_7922:
    ld a, [hl+]                                   ; $7922
    ld [de], a                                    ; $7923
    push hl                                       ; $7924
    ld bc, MainMenu_StepIconAnimators_Next        ; $7925
    push bc                                       ; $7928
    ld a, [hl+]                                   ; $7929
    ld h, [hl]                                    ; $792A
    ld l, a                                       ; $792B
    jp hl                                         ; $792C


; C: loop tail. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_StepIconAnimators_Next::
    pop hl                                        ; $792D
    pop de                                        ; $792E
    pop bc                                        ; $792F
    inc hl                                        ; $7930
    inc hl                                        ; $7931
    inc de                                        ; $7932
    dec b                                         ; $7933
    jr nz, jr_007_7903                            ; $7934

    ret                                           ; $7936


; C
MainMenu_DrawUpperItem0::
    ld hl, MainMenu_UpperItem0_AnimTbl            ; $7937
    ld b, $03                                     ; $793A
    call MainMenu_StepIconAnimators               ; $793C
    ld bc, $5081                                  ; $793F
    ld a, $21                                     ; $7942
    call Oam_AddMeta_B02_5272                     ; $7944
    ld a, [wMenuAnimTick]                         ; $7947
    cp $01                                        ; $794A
    ret nz                                        ; $794C

    ld a, [wMenuAnimFrame]                        ; $794D
    cp $39                                        ; $7950
    jr nz, jr_007_7963                            ; $7952

    ld a, BANK(Gfx_11_4F00_MainMenu_LoadBaseTiles); $7954
    ld hl, Gfx_11_4F00_MainMenu_LoadBaseTiles     ; $7956
    ld de, $8000                                  ; $7959
    ld bc, $0200                                  ; $795C
    call Vram_CopyFromBank                        ; $795F
    ret                                           ; $7962


jr_007_7963:
    cp $3b                                        ; $7963
    jr nz, jr_007_7976                            ; $7965

    ld a, BANK(Gfx_11_5500_MainMenu_DrawUpperItem0); $7967
    ld hl, Gfx_11_5500_MainMenu_DrawUpperItem0    ; $7969
    ld de, $8000                                  ; $796C
    ld bc, $0200                                  ; $796F
    call Vram_CopyFromBank                        ; $7972
    ret                                           ; $7975


jr_007_7976:
    ld a, BANK(Gfx_11_5200_MainMenu_DrawUpperItem0); $7976
    ld hl, Gfx_11_5200_MainMenu_DrawUpperItem0    ; $7978
    ld de, $8000                                  ; $797B
    ld bc, $0200                                  ; $797E
    call Vram_CopyFromBank                        ; $7981
    ret                                           ; $7984


; C
MainMenu_UpperItem0_AnimTbl::
    db $39, $3e, $29, $8d, $f1, $7a, $03, $08, $14, $64, $f6, $7a, $0d, $12, $5f, $7c
    db $fb, $7a

; C
MainMenu_DrawUpperItem1::
    ld hl, MainMenu_UpperItem1_AnimTbl            ; $7997
    ld b, $03                                     ; $799A
    call MainMenu_StepIconAnimators               ; $799C
    ld bc, $5081                                  ; $799F
    ld a, $21                                     ; $79A2
    call Oam_AddMeta_B02_5272                     ; $79A4
    ld a, [wMenuAnimTick]                         ; $79A7
    cp $01                                        ; $79AA
    ret nz                                        ; $79AC

    ld a, [wMenuAnimFrame]                        ; $79AD
    cp $3e                                        ; $79B0
    jr nz, jr_007_79c3                            ; $79B2

    ld a, BANK(Gfx_11_5000_MainMenu_DrawUpperItem1); $79B4
    ld hl, Gfx_11_5000_MainMenu_DrawUpperItem1    ; $79B6
    ld de, $8100                                  ; $79B9
    ld bc, $0200                                  ; $79BC
    call Vram_CopyFromBank                        ; $79BF
    ret                                           ; $79C2


jr_007_79c3:
    cp $40                                        ; $79C3
    jr nz, jr_007_79d6                            ; $79C5

    ld a, BANK(Gfx_11_5600_MainMenu_DrawUpperItem1); $79C7
    ld hl, Gfx_11_5600_MainMenu_DrawUpperItem1    ; $79C9
    ld de, $8100                                  ; $79CC
    ld bc, $0200                                  ; $79CF
    call Vram_CopyFromBank                        ; $79D2
    ret                                           ; $79D5


jr_007_79d6:
    ld a, BANK(Gfx_11_5300_MainMenu_DrawUpperItem1); $79D6
    ld hl, Gfx_11_5300_MainMenu_DrawUpperItem1    ; $79D8
    ld de, $8100                                  ; $79DB
    ld bc, $0200                                  ; $79DE
    call Vram_CopyFromBank                        ; $79E1
    ret                                           ; $79E4


; C
MainMenu_UpperItem1_AnimTbl::
    db $3e, $43, $29, $13, $f1, $7a, $08, $0d, $14, $3d, $f6, $7a, $12, $17, $5f, $24
    db $fb, $7a

; C: phase counter D A2F mod $28
MainMenu_DrawUpperItem2::
    ld a, [wMenuItem3Phase]                       ; $79F7
    inc a                                         ; $79FA
    cp $28                                        ; $79FB
    jr c, jr_007_7a00                             ; $79FD

    xor a                                         ; $79FF

jr_007_7a00:
    ld [wMenuItem3Phase], a                       ; $7A00
    and a                                         ; $7A03
    jr z, jr_007_7a2c                             ; $7A04

    cp $18                                        ; $7A06
    jr z, jr_007_7a1c                             ; $7A08

    cp $1c                                        ; $7A0A
    jr z, jr_007_7a2c                             ; $7A0C

    cp $20                                        ; $7A0E
    jr z, jr_007_7a1c                             ; $7A10

    cp $24                                        ; $7A12
    jr z, jr_007_7a2c                             ; $7A14

    cp $26                                        ; $7A16
    jr z, jr_007_7a1c                             ; $7A18

    jr jr_007_7a3a                                ; $7A1A

jr_007_7a1c:
    ld a, BANK(Gfx_15_4E00_MainMenu_LoadBaseTiles); $7A1C
    ld hl, Gfx_15_4E00_MainMenu_LoadBaseTiles     ; $7A1E
    ld de, $8300                                  ; $7A21
    ld bc, $0200                                  ; $7A24
    call Vram_CopyFromBank                        ; $7A27
    jr jr_007_7a3a                                ; $7A2A

jr_007_7a2c:
    ld a, BANK(Gfx_15_5000_MainMenu_DrawUpperItem2); $7A2C
    ld hl, Gfx_15_5000_MainMenu_DrawUpperItem2    ; $7A2E
    ld de, $8300                                  ; $7A31
    ld bc, $0200                                  ; $7A34
    call Vram_CopyFromBank                        ; $7A37

jr_007_7a3a:
    ld hl, MainMenu_DrawUpperItem2_Gfx7A43        ; $7A3A
    ld b, $03                                     ; $7A3D
    call MainMenu_StepIconAnimators               ; $7A3F
    ret                                           ; $7A42


; C: auto: 18 bytes, tile data; referenced by MainMenu_DrawUpperItem2. L3 pass 2026-10-26: read in BGB in 14 replay(s)
; of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
MainMenu_DrawUpperItem2_Gfx7A43::
    db $2d, $2f, $81, $50, $f1, $7a, $2f, $34, $5e, $2d, $f6, $7a, $34, $39, $5e, $73
    db $fb, $7a

; C
MainMenu_DrawLowerItem3::
    ld hl, MainMenu_LowerItem3_AnimTbl            ; $7A55
    ld b, $05                                     ; $7A58
    call MainMenu_StepIconAnimators               ; $7A5A
    ret                                           ; $7A5D


; C
MainMenu_LowerItem3_AnimTbl::
    db $00, $05, $57, $20, $f1, $7a, $21, $24, $50, $60, $f6, $7a, $24, $27, $5e, $50
    db $fb, $7a, $2a, $2d, $38, $50, $00, $7b, $43, $4c, $3c, $1c, $05, $7b

; C
MainMenu_DrawLowerItem4::
    ld hl, MainMenu_LowerItem4_AnimTbl            ; $7A7C
    ld b, $05                                     ; $7A7F
    call MainMenu_StepIconAnimators               ; $7A81
    ret                                           ; $7A84


; C
MainMenu_LowerItem4_AnimTbl::
    db $00, $05, $2f, $50, $f1, $7a, $21, $24, $50, $60, $f6, $7a, $24, $27, $5e, $50
    db $fb, $7a, $27, $2a, $50, $45, $00, $7b, $43, $4c, $14, $4c, $05, $7b

; C
MainMenu_DrawLowerItem5::
    ld hl, MainMenu_LowerItem5_AnimTbl            ; $7AA3
    ld b, $05                                     ; $7AA6
    call MainMenu_StepIconAnimators               ; $7AA8
    ret                                           ; $7AAB


; C
MainMenu_LowerItem5_AnimTbl::
    db $00, $05, $57, $80, $f1, $7a, $24, $27, $5e, $50, $f6, $7a, $27, $2a, $50, $45
    db $fb, $7a, $2a, $2d, $38, $50, $00, $7b, $43, $4c, $3c, $7c, $05, $7b

; C
MainMenu_DrawLowerItem6::
    ld hl, MainMenu_LowerItem6_AnimTbl            ; $7ACA
    ld b, $05                                     ; $7ACD
    call MainMenu_StepIconAnimators               ; $7ACF
    ret                                           ; $7AD2


; C
MainMenu_LowerItem6_AnimTbl::
    db $00, $05, $7f, $50, $f1, $7a, $21, $24, $50, $60, $f6, $7a, $27, $2a, $50, $45
    db $fb, $7a, $2a, $2d, $38, $50, $00, $7b, $43, $4c, $64, $4c, $05, $7b

; C: animator callback (hand-decoded; README 2.0)
MainMenu_IconCallback0::
    ld de, $0000                                  ; $7AF1
    jr jr_007_7b08                                ; $7AF4

; C
MainMenu_IconCallback1::
    ld de, $0001                                  ; $7AF6
    jr jr_007_7b08                                ; $7AF9

; C
MainMenu_IconCallback2::
    ld de, $0002                                  ; $7AFB
    jr jr_007_7b08                                ; $7AFE

; C
MainMenu_IconCallback3::
    ld de, $0003                                  ; $7B00
    jr jr_007_7b08                                ; $7B03

; C: falls into the common body at 7B08
MainMenu_IconCallback4::
    ld de, $0004                                  ; $7B05

jr_007_7b08:
    ld hl, wMenuAnimFrame                         ; $7B08
    add hl, de                                    ; $7B0B
    ld a, [hl]                                    ; $7B0C
    sla a                                         ; $7B0D
    ld c, a                                       ; $7B0F
    ld b, $00                                     ; $7B10
    ld hl, MainMenu_IconFrameTbl                  ; $7B12
    add hl, bc                                    ; $7B15
    ld a, [hl+]                                   ; $7B16
    push hl                                       ; $7B17
    ld hl, wMenuAnimX                             ; $7B18
    add hl, de                                    ; $7B1B
    ld b, [hl]                                    ; $7B1C
    ld hl, wMenuAnimY                             ; $7B1D
    add hl, de                                    ; $7B20
    ld c, [hl]                                    ; $7B21
    call Oam_AddMeta_B02_5272                     ; $7B22
    ld hl, wMenuAnimTick                          ; $7B25
    add hl, de                                    ; $7B28
    ld a, [hl]                                    ; $7B29
    pop hl                                        ; $7B2A
    cp [hl]                                       ; $7B2B
    jr c, jr_007_7b3d                             ; $7B2C

    inc hl                                        ; $7B2E
    ld a, [hl+]                                   ; $7B2F
    cp $ff                                        ; $7B30
    ld a, [hl]                                    ; $7B32
    ld hl, wMenuAnimFrame                         ; $7B33
    add hl, de                                    ; $7B36
    jr z, jr_007_7b3b                             ; $7B37

    ld a, [hl]                                    ; $7B39
    inc a                                         ; $7B3A

jr_007_7b3b:
    ld [hl], a                                    ; $7B3B
    xor a                                         ; $7B3C

jr_007_7b3d:
    inc a                                         ; $7B3D
    ld hl, wMenuAnimTick                          ; $7B3E
    add hl, de                                    ; $7B41
    ld [hl], a                                    ; $7B42
    ret                                           ; $7B43


; C: 2-byte entries: sprite; duration; $FF = loop target in the next byte
MainMenu_IconFrameTbl::
    db $00, $04, $01, $04, $ff, $00, $02, $04, $03, $04, $04, $04, $05, $04, $ff, $03
    db $06, $04, $07, $04, $08, $04, $09, $04, $ff, $08, $0a, $04, $0b, $04, $0c, $04
    db $0d, $04, $ff, $0d, $0e, $04, $0f, $04, $10, $04, $11, $04, $ff, $12, $12, $04
    db $13, $03, $14, $03, $15, $03, $ff, $17, $16, $04, $17, $03, $18, $03, $19, $03
    db $ff, $1c, $12, $10, $13, $04, $ff, $21, $1a, $10, $1b, $04, $ff, $24, $18, $10
    db $19, $04, $ff, $27, $1c, $10, $1d, $04, $ff, $2a, $20, $03, $ff, $2d, $28, $04
    db $29, $04, $2a, $04, $2b, $04, $ff, $2f, $2c, $04, $2d, $04, $2e, $04, $2f, $04
    db $ff, $34, $22, $04, $23, $04, $24, $04, $23, $04, $ff, $39, $25, $04, $26, $04
    db $27, $04, $26, $04, $ff, $3e, $1e, $08, $1f, $08, $1e, $06, $1f, $06, $1e, $04
    db $1f, $03, $1e, $02, $1f, $02, $ff, $43

; C: page transition A, entry (BC = $0400): HL = draw callback (the caller loads MainMenu_DrawUpperItem0 or a
; sibling), DE = a table of 4 records {src lo, src hi, bank}. It hides the unused sprites, waits one VBlank, then runs
; 4 steps (B counts 4 down, C = step 0..3): each step stamps $FFC8 into $DA2E, ...
MainMenu_SlideA_Begin::
    push de                                       ; $7BDC
    push hl                                       ; $7BDD
    call Oam_HideUnused                           ; $7BDE
    rst Rst08_WaitVBlank                          ; $7BE1
    pop hl                                        ; $7BE2
    pop de                                        ; $7BE3
    ld bc, $0400                                  ; $7BE4

jr_007_7be7:
    ldh a, [hFrameCounter]                        ; $7BE7
    ld [wMenuTransStamp], a                       ; $7BE9
    push hl                                       ; $7BEC
    push de                                       ; $7BED
    push bc                                       ; $7BEE
    ld bc, MainMenu_SlideA_Step                   ; $7BEF
    push bc                                       ; $7BF2
    jp hl                                         ; $7BF3


; C: step of page transition A: record number C (3 x C added to the table) gives {src lo, hi, bank}; Vram_CopyFromBank
; copies 0x200 bytes (32 tiles) to $9100, then MainMenu_SlideWait paces the step to 4 frames; the callback is called
; every frame during the wait
MainMenu_SlideA_Step::
    pop bc                                        ; $7BF4
    pop hl                                        ; $7BF5
    push hl                                       ; $7BF6
    push bc                                       ; $7BF7
    ld a, c                                       ; $7BF8
    sla a                                         ; $7BF9
    add c                                         ; $7BFB
    ld c, a                                       ; $7BFC
    ld b, $00                                     ; $7BFD
    add hl, bc                                    ; $7BFF
    ld c, [hl]                                    ; $7C00
    inc hl                                        ; $7C01
    ld b, [hl]                                    ; $7C02
    inc hl                                        ; $7C03
    ld a, [hl]                                    ; $7C04
    ld l, c                                       ; $7C05
    ld h, b                                       ; $7C06
    ld de, $9100                                  ; $7C07
    ld bc, $0200                                  ; $7C0A
    call Vram_CopyFromBank                        ; $7C0D
    call MainMenu_SlideWait                       ; $7C10
    pop bc                                        ; $7C13
    pop de                                        ; $7C14
    pop hl                                        ; $7C15
    inc c                                         ; $7C16
    dec b                                         ; $7C17
    jr nz, jr_007_7be7                            ; $7C18

    jp hl                                         ; $7C1A


; C: 4 x {lo,hi,bank} = 16:6B80, 6D80, 6F80, 7180 (frames 1-4 of the 10-frame camera ball head animation 16:6980-7D7F,
; forward sweep; owner, 2026-10-14: the animation shown when Up / Down is pressed on the main camera menu); used by
; the callers 07:7297, 72B6, 72D8
MainMenu_SlideA_Tbl0::
    dw Gfx_16_6B80_MainMenu_BallHeadAnim_F1
    db BANK(Gfx_16_6B80_MainMenu_BallHeadAnim_F1)
    dw Gfx_16_6D80_MainMenu_BallHeadAnim_F2
    db BANK(Gfx_16_6D80_MainMenu_BallHeadAnim_F2)
    dw Gfx_16_6F80_MainMenu_BallHeadAnim_F3
    db BANK(Gfx_16_6F80_MainMenu_BallHeadAnim_F3)
    dw Gfx_16_7180_MainMenu_BallHeadAnim_F4
    db BANK(Gfx_16_7180_MainMenu_BallHeadAnim_F4)

; C: 4 x {lo,hi,bank} = 16:6F80, 6D80, 6B80, 6980 (the same frames backwards, frame 0 last); used by the callers
; 07:7321, 73AD, 7782
MainMenu_SlideA_Tbl1::
    dw Gfx_16_6F80_MainMenu_BallHeadAnim_F3
    db BANK(Gfx_16_6F80_MainMenu_BallHeadAnim_F3)
    dw Gfx_16_6D80_MainMenu_BallHeadAnim_F2
    db BANK(Gfx_16_6D80_MainMenu_BallHeadAnim_F2)
    dw Gfx_16_6B80_MainMenu_BallHeadAnim_F1
    db BANK(Gfx_16_6B80_MainMenu_BallHeadAnim_F1)
    dw Gfx_16_6980_MainMenu_BallHeadAnim_F0
    db BANK(Gfx_16_6980_MainMenu_BallHeadAnim_F0)

; I: 4 x {lo,hi,bank} = 16:7580, 7780, 7980, 7B80 (frames 6-9 of the camera ball head animation, forward; the second
; set 16:7380-7B7F, which differs from frames 0-4 in the lower rows). NO caller: only Tbl0 and Tbl1 are ever loaded
; into DE ('ld de,Tbl' sites 07:7297-7782) and the step code never adds an ...
MainMenu_SlideA_Tbl2::
    dw Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref
    db BANK(Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref)
    dw Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref
    db BANK(Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref)
    dw Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref
    db BANK(Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref)
    dw Gfx_16_7B80_MainMenu_BallHeadAnim_F9
    db BANK(Gfx_16_7B80_MainMenu_BallHeadAnim_F9)

; I: 4 x {lo,hi,bank} = 16:7980, 7780, 7580, 7380 (frames 8, 7, 6, 5 of the camera ball head animation, backward). NO
; caller (see Tbl2); 16:7380 is read by no organic run and no code (I)
MainMenu_SlideA_Tbl3::
    dw Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref
    db BANK(Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref)
    dw Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref
    db BANK(Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref)
    dw Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref
    db BANK(Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref)
    dw Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref
    db BANK(Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref)

; C: page transition B, entry: same loop as MainMenu_SlideA_Begin (4 steps, 3-byte records {lo,hi,bank} from DE, draw
; callback in HL); callers load Tbl0 (07:73F6), Tbl1 (07:776C), Tbl2 (07:7425) or Tbl3 (07:775C)
MainMenu_SlideB_Begin::
    push de                                       ; $7C4B
    push hl                                       ; $7C4C
    call Oam_HideUnused                           ; $7C4D
    rst Rst08_WaitVBlank                          ; $7C50
    pop hl                                        ; $7C51
    pop de                                        ; $7C52
    ld bc, $0400                                  ; $7C53

jr_007_7c56:
    ldh a, [hFrameCounter]                        ; $7C56
    ld [wMenuTransStamp], a                       ; $7C58
    push hl                                       ; $7C5B
    push de                                       ; $7C5C
    push bc                                       ; $7C5D
    ld bc, MainMenu_SlideB_Step                   ; $7C5E
    push bc                                       ; $7C61
    jp hl                                         ; $7C62


; C: step of page transition B: record C of the table, Vram_CopyFromBank copies 0x500 bytes (80 tiles) to $9200, then
; MainMenu_SlideWait
MainMenu_SlideB_Step::
    pop bc                                        ; $7C63
    pop hl                                        ; $7C64
    push hl                                       ; $7C65
    push bc                                       ; $7C66
    ld a, c                                       ; $7C67
    sla a                                         ; $7C68
    add c                                         ; $7C6A
    ld c, a                                       ; $7C6B
    ld b, $00                                     ; $7C6C
    add hl, bc                                    ; $7C6E
    ld c, [hl]                                    ; $7C6F
    inc hl                                        ; $7C70
    ld b, [hl]                                    ; $7C71
    inc hl                                        ; $7C72
    ld a, [hl]                                    ; $7C73
    ld l, c                                       ; $7C74
    ld h, b                                       ; $7C75
    ld de, $9200                                  ; $7C76
    ld bc, $0500                                  ; $7C79
    call Vram_CopyFromBank                        ; $7C7C
    call MainMenu_SlideWait                       ; $7C7F
    pop bc                                        ; $7C82
    pop de                                        ; $7C83
    pop hl                                        ; $7C84
    inc c                                         ; $7C85
    dec b                                         ; $7C86
    jr nz, jr_007_7c56                            ; $7C87

    jp hl                                         ; $7C89


; C: 4 x {lo,hi,bank} = 16:5A80, 5F80, 6480, 11:4000 (0x500 bytes each, frames 1-4 of the 7-frame strip 16:5580-697F +
; 11:4000-4EFF, forward); used by the caller 07:73F6
MainMenu_SlideB_Tbl0::
    db $80, $5a, $16, $80, $5f, $16, $80, $64, $16, $00, $40, $11

; C: 4 x {lo,hi,bank} = 16:6480, 5F80, 5A80, 5580 (backward); used by the caller 07:776C
MainMenu_SlideB_Tbl1::
    db $80, $64, $16, $80, $5f, $16, $80, $5a, $16, $80, $55, $16

; C: 4 x {lo,hi,bank} = 11:4500, 4500, 4A00, 4A00 (each frame twice); used by the caller 07:7425
MainMenu_SlideB_Tbl2::
    db $00, $45, $11, $00, $45, $11, $00, $4a, $11, $00, $4a, $11

; C: 4 x {lo,hi,bank} = 11:4500, 4500, 4000, 4000 (each frame twice, backward); used by the caller 07:775C
MainMenu_SlideB_Tbl3::
    db $00, $45, $11, $00, $45, $11, $00, $40, $11, $00, $40, $11

; C: page transition C, entry: same loop (4 steps, records {lo,hi,bank}); callers load Tbl0 (07:742E) or Tbl1
; (07:7753)
MainMenu_SlideC_Begin::
    push de                                       ; $7CBA
    push hl                                       ; $7CBB
    call Oam_HideUnused                           ; $7CBC
    rst Rst08_WaitVBlank                          ; $7CBF
    pop hl                                        ; $7CC0
    pop de                                        ; $7CC1
    ld bc, $0400                                  ; $7CC2

jr_007_7cc5:
    ldh a, [hFrameCounter]                        ; $7CC5
    ld [wMenuTransStamp], a                       ; $7CC7
    push hl                                       ; $7CCA
    push de                                       ; $7CCB
    push bc                                       ; $7CCC
    ld bc, MainMenu_SlideC_Step                   ; $7CCD
    push bc                                       ; $7CD0
    jp hl                                         ; $7CD1


; C: step of page transition C: record C, Vram_CopyFromBank copies 0x1C0 bytes (14 map rows of 32) to $9860 = the
; background map strip from row 3, then MainMenu_SlideWait
MainMenu_SlideC_Step::
    pop bc                                        ; $7CD2
    pop hl                                        ; $7CD3
    push hl                                       ; $7CD4
    push bc                                       ; $7CD5
    ld a, c                                       ; $7CD6
    sla a                                         ; $7CD7
    add c                                         ; $7CD9
    ld c, a                                       ; $7CDA
    ld b, $00                                     ; $7CDB
    add hl, bc                                    ; $7CDD
    ld c, [hl]                                    ; $7CDE
    inc hl                                        ; $7CDF
    ld b, [hl]                                    ; $7CE0
    inc hl                                        ; $7CE1
    ld a, [hl]                                    ; $7CE2
    ld l, c                                       ; $7CE3
    ld h, b                                       ; $7CE4
    ld de, $9860                                  ; $7CE5
    ld bc, $01c0                                  ; $7CE8
    call Vram_CopyFromBank                        ; $7CEB
    call MainMenu_SlideWait                       ; $7CEE
    pop bc                                        ; $7CF1
    pop de                                        ; $7CF2
    pop hl                                        ; $7CF3
    inc c                                         ; $7CF4
    dec b                                         ; $7CF5
    jr nz, jr_007_7cc5                            ; $7CF6

    jp hl                                         ; $7CF8


; C: 4 x {lo,hi,bank} = 27:54B0, 5830, 5670, 5F30 (map strips of 0x1C0 bytes to $9860); used by the caller 07:742E
MainMenu_SlideC_Tbl0::
    dw Src_27_54B0_Tbl7CF9_0
    db BANK(Src_27_54B0_Tbl7CF9_0)
    dw Src_27_5830_Tbl7CF9_1
    db BANK(Src_27_5830_Tbl7CF9_1)
    dw Src_27_5670_Tbl7CF9_2
    db BANK(Src_27_5670_Tbl7CF9_2)
    dw Map_27_5F30_MainMenu_LoadBackground
    db BANK(Map_27_5F30_MainMenu_LoadBackground)

; C: 4 x {lo,hi,bank} = 27:5670, 5830, 54B0, 26:5A60 (map strips of 0x1C0 bytes to $9860, backward); used by the
; caller 07:7753
MainMenu_SlideC_Tbl1::
    dw Src_27_5670_Tbl7CF9_2
    db BANK(Src_27_5670_Tbl7CF9_2)
    dw Src_27_5830_Tbl7CF9_1
    db BANK(Src_27_5830_Tbl7CF9_1)
    dw Src_27_54B0_Tbl7CF9_0
    db BANK(Src_27_54B0_Tbl7CF9_0)
    dw Src_26_5A60_Tbl7CF9_7
    db BANK(Src_26_5A60_Tbl7CF9_7)

; C: shared wait of the three transitions: waits ($DA2E - $FFC8 + 4) VBlanks, i.e. one step takes 4 frames counted
; from the stamp taken at the start of the step; the caller's draw callback (found on the stack) is called once per
; frame through MainMenu_SlideWaitLoop
MainMenu_SlideWait::
    call Oam_HideUnused                           ; $7D11
    ld a, [wMenuTransStamp]                       ; $7D14
    ld hl, hFrameCounter                          ; $7D17
    sub [hl]                                      ; $7D1A
    add $04                                       ; $7D1B

jr_007_7d1d:
    push af                                       ; $7D1D
    ld hl, sp+$08                                 ; $7D1E
    ld a, [hl+]                                   ; $7D20
    ld h, [hl]                                    ; $7D21
    ld l, a                                       ; $7D22
    ld bc, MainMenu_SlideWaitLoop                 ; $7D23
    push bc                                       ; $7D26
    jp hl                                         ; $7D27


; C: one frame of the wait: hides the unused sprites, waits for VBlank, decrements the count and loops back into
; MainMenu_SlideWait (ret when 0)
MainMenu_SlideWaitLoop::
    call Oam_HideUnused                           ; $7D28
    rst Rst08_WaitVBlank                          ; $7D2B
    pop af                                        ; $7D2C
    dec a                                         ; $7D2D
    jr nz, jr_007_7d1d                            ; $7D2E

    ret                                           ; $7D30


    ; padding
    ds $2cf, $00

; Game Boy Camera (USA, Europe), bank $07. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

; C: mode 0E: link-cable exchange (SEND / RECEIVE)
Mode0E_LinkTransfer::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; I: 21 states
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
    farcopy Mem_CopyFromBank, Gfx_19_4800_Mode0E_State00_Init, $8800, $0800 ; $4070
    farcopy Mem_CopyFromBank, Gfx_19_5000_Mode0E_State00_Init, $8000, $0800 ; $407E
    farcopy Mem_CopyFromBank, Map_23_7780_Mode0E_State00_Init, $9800, $0240 ; $408C
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
    farcopy Vram_CopyFromBank, Map_23_77A0_Mode0E_State00_Init, $9820, $00a0 ; $40BB
    jr jr_007_40e3                                ; $40C9

jr_007_40cb:
    ld a, $0e                                     ; $40CB
    ld [wLinkAnim2Frame], a                       ; $40CD
    ld a, $0c                                     ; $40D0
    ld [wLinkAnim3Frame], a                       ; $40D2
    farcopy Vram_CopyFromBank, Map_23_79C0_Mode0E_State00_Init, $9820, $00a0 ; $40D5

jr_007_40e3:
    call Link_DrawAnimators                       ; $40E3
    call Pal_FadeIn                               ; $40E6
    next_state                                    ; $40E9
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
    set_state STATE_06_INIT                       ; $4102
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

    screen_off                                    ; $415A
    xor a                                         ; $4160
    ld [wLnkConnected], a                         ; $4161
    ld a, MODE_LINK_MENU                          ; $4164
    ld [wMode], a                                 ; $4166
    set_state STATE_06_INIT                       ; $4169
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
    set_state STATE_0E_RESULT_PREPARE             ; $4180
    ret                                           ; $4185


; I: 4 bytes: wLnkAbortReason 1-4 -> message id wResultMsgId of the result / error screen = $09, $09, $0A, $0B (album
; full; peer album full; peer has no photo; own album empty), then state $12; Mode0E_State01_Handshake (07:4178),
; README 14 (read 2026-10-25)
Mode0E_AbortReasonMsgTbl::
    db $09, $09, $0a, $0b

jr_007_418a:
    ld a, [wLnkRoleRx]                            ; $418A
    ld [wSavedDc52], a                            ; $418D
    play_sfx1 SFX1_CHOOSE                         ; $4190
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

    screen_off                                    ; $41AF
    ld a, [wLnkInitiator]                         ; $41B5
    cp $01                                        ; $41B8
    jr nz, jr_007_41c2                            ; $41BA

    set_state STATE_0E_MESSAGE_STRIP              ; $41BC
    ret                                           ; $41C1


jr_007_41c2:
    set_state STATE_0E_EXCHANGE_SETUP_B           ; $41C2
    ret                                           ; $41C7


; I: UNREFERENCED: state := $12
Unused_Mode0E_GotoState12::
    set_state STATE_0E_RESULT_PREPARE             ; $41C8
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

    farcopy Vram_CopyFromBank, Map_23_7A60_Link_DrawPressAText, $9820, $00a0 ; $41FE
    ret                                           ; $420C


jr_007_420d:
    ld a, [wSavedDc52]                            ; $420D
    and a                                         ; $4210
    jr nz, jr_007_4222                            ; $4211

    farcopy Vram_CopyFromBank, Map_23_77A0_Mode0E_State00_Init, $9820, $00a0 ; $4213
    ret                                           ; $4221


jr_007_4222:
    farcopy Vram_CopyFromBank, Map_23_79C0_Mode0E_State00_Init, $9820, $00a0 ; $4222
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

    farcopy Vram_CopyFromBank, Map_23_77A0_Mode0E_State00_Init, $9820, $00a0 ; $423E
    ret                                           ; $424C


jr_007_424d:
    ld a, [wLinkAnim2Frame]                       ; $424D
    cp $12                                        ; $4250
    jr z, jr_007_4263                             ; $4252

    farcopy Vram_CopyFromBank, Map_23_79C0_Mode0E_State00_Init, $9820, $00a0 ; $4254
    ret                                           ; $4262


jr_007_4263:
    farcopy Vram_CopyFromBank, Map_23_7A60_Link_DrawPressAText, $9820, $00a0 ; $4263
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
    play_sfx4 SFX4_LINK_CHOOSE                    ; $4286
    and a                                         ; $428D
    jr nz, jr_007_42b0                            ; $428E

    ld a, $0a                                     ; $4290
    ld [wLinkAnim2Frame], a                       ; $4292
    ld a, $10                                     ; $4295
    ld [wLinkAnim3Frame], a                       ; $4297
    xor a                                         ; $429A
    ld [wLinkAnimTickB], a                        ; $429B
    ld [wLinkAnimTickB + $1], a                   ; $429E
    farcopy Vram_CopyFromBank, Map_23_77A0_Mode0E_State00_Init, $9820, $00a0 ; $42A1
    ret                                           ; $42AF


jr_007_42b0:
    ld a, $0e                                     ; $42B0
    ld [wLinkAnim2Frame], a                       ; $42B2
    ld a, $0c                                     ; $42B5
    ld [wLinkAnim3Frame], a                       ; $42B7
    xor a                                         ; $42BA
    ld [wLinkAnimTickB], a                        ; $42BB
    ld [wLinkAnimTickB + $1], a                   ; $42BE
    farcopy Vram_CopyFromBank, Map_23_79C0_Mode0E_State00_Init, $9820, $00a0 ; $42C1
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
    call nz, Oam_AddMeta_B01_5D2B                 ; $4337
    ld a, [hl+]                                   ; $433A
    and a                                         ; $433B
    call nz, Oam_AddMeta_B01_5D2B                 ; $433C
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
    next_state                                    ; $43B0
    ret                                           ; $43B4


jr_007_43b5:
    ld a, $0e                                     ; $43B5
    ld [wMsgStripSel], a                          ; $43B7
    ld a, $04                                     ; $43BA
    ld [wIconSel], a                              ; $43BC
    xor a                                         ; $43BF
    ld [wSubstate], a                             ; $43C0
    ld [wAbResult], a                             ; $43C3
    next_state                                    ; $43C6
    ret                                           ; $43CA


; C: far call 07:4C08 (photo choose dialog)
Mode0E_State03_PickPhoto::
    ldh [hFarcallAArg], a                         ; $43CB
    ld a, $07                                     ; $43CD
    ld hl, LinkPick_Far                           ; $43CF
    call Far_Call                                 ; $43D2
    ret                                           ; $43D5


; I: after the dialog: loads the chosen photo into the link buffer; BGB watchpoint pass 2026-10-25: ran only in mode
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
    farcall Photo_LoadImage_Far                   ; $43F7
    ldh [hFarcallAArg], a                         ; $43FF
    farcall Owner_Load_Far                        ; $4401
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
    farcopy Mem_CopyFromBank, Map_20_7542_Mode17_State08_Split_Build, $9800, $02c0 ; $4439
    farcopy Mem_CopyFromBank, Gfx_17_4950_Shoot_DrawTimerMinutes, $8ff0, $0010 ; $4447
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8500, $0080 ; $4455
    farcopy Mem_CopyFromBank, Gfx_18_7BA0_Mode0E_State04_PickDone, $8580, $00a0 ; $4463
    farcopy Mem_CopyFromBank, Gfx_17_4A60_Mode0E_State04_PickDone, $8620, $0020 ; $4471
    farcopy Mem_CopyFromBank, Gfx_17_4B60_Mode0E_State04_PickDone, $8640, $0030 ; $447F
    farcopy Mem_CopyFromBank, Gfx_17_4B90_Mode0E_State04_PickDone, $8720, $0050 ; $448D
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
    next_state                                    ; $44B8
    ret                                           ; $44BC


; C: the initiator-sender's confirmation dialog (README 14.3; the counterpart of Mode0E_State0E_ResponderConfirmSend
; on the responder, same dialog sprite Link_DrawAbortJitter): A -> state 06 (exchange set-up, the photo is sent), B ->
; state 02 (choose another photo, code only); was ...
Mode0E_State05_InitiatorConfirmSend::
    call Link_DrawAbortJitter                     ; $44BD
    ldh a, [hKeysNew]                             ; $44C0
    bit PADB_A, a                                 ; $44C2
    jr z, jr_007_44db                             ; $44C4

    screen_off                                    ; $44C6
    stat_irq_off                                  ; $44CC
    next_state                                    ; $44D6
    ret                                           ; $44DA


jr_007_44db:
    bit 1, a                                      ; $44DB
    ret z                                         ; $44DD

    screen_off                                    ; $44DE
    stat_irq_off                                  ; $44E4
    set_state STATE_0E_MESSAGE_STRIP              ; $44EE
    ret                                           ; $44F3


; I: bars and lamps for the exchange (first direction); BGB watchpoint pass 2026-10-25: ran only in mode 0E and state
; 06 (4 hits in 2 runs: 0E:06 x4; tcrf_check/assets/mode_state_wp/)
Mode0E_State06_ExchangeSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $44F4
    ldh [hLcdcShadow], a                          ; $44F6
    xor a                                         ; $44F8
    ld [wLinkBarX], a                             ; $44F9
    ld [wLinkBarPhase], a                         ; $44FC
    ld [wLinkLampScript], a                       ; $44FF
    ld [wLinkLampScript + $1], a                  ; $4502
    farcopy Mem_CopyFromBank, Gfx_15_6C00_Mode0E_State06_ExchangeSetup, $9000, $0800 ; $4505
    farcopy Mem_CopyFromBank, Gfx_15_7400_Mode0E_State06_ExchangeSetup, $8800, $0800 ; $4513
    farcopy Mem_CopyFromBank, Gfx_15_7C00_Mode0E_State06_ExchangeSetup, $8000, $0400 ; $4521
    farcopy Mem_CopyFromBank, Map_24_5180_Mode0E_State06_ExchangeSetup, $9800, $0260 ; $452F
    screen_on                                     ; $453D
    play_music MUSIC_LINK_EXCHANGE_SETUP          ; $4546
    call Pal_FadeIn                               ; $454D
    ld a, $00                                     ; $4550
    ld [wLinkTimeout], a                          ; $4552
    ld a, $02                                     ; $4555
    ld [wLinkTimeout + $1], a                     ; $4557
    ld a, [wSavedDc52]                            ; $455A
    and a                                         ; $455D
    jr nz, jr_007_4574                            ; $455E

    ld a, [wPhotoIndex]                           ; $4560
    ld [wLnkSlot], a                              ; $4563
    ld a, $01                                     ; $4566
    ld [wLnkReadyTx], a                           ; $4568
    call Link_QueueCommand                        ; $456B
    set_state STATE_0E_EXCHANGE_WAIT_A            ; $456E
    ret                                           ; $4573


jr_007_4574:
    ld a, [wPhotoIndex]                           ; $4574
    ld [wLnkSlot], a                              ; $4577
    call Link_QueueCommand                        ; $457A
    set_state STATE_0E_EXCHANGE_BARS_A            ; $457D
    ret                                           ; $4582


; I: progress bars; direction 1; ran only in mode 0E and state 07 on the initiator that receives (872 hits); FORCED
; run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two BGB instances with
; the link deadline disabled (07:4ACE dec [hl] -> nop; without it every ...
Mode0E_State07_ExchangeBarsA::
    ld a, $01                                     ; $4583
    ld [wLinkBarDir], a                           ; $4585
    call Link_DrawProgressBars                    ; $4588
    ld a, [wLnkHalfDone]                          ; $458B
    cp $01                                        ; $458E
    jr nz, jr_007_45ab                            ; $4590

    play_sfx3 SFX3_MAIN_MENU_VIEW_ARCADE          ; $4592
    ld bc, $0014                                  ; $4599
    call Wait_Frames                              ; $459C
    screen_off                                    ; $459F
    set_state STATE_0E_MESSAGE_STRIP              ; $45A5
    ret                                           ; $45AA


jr_007_45ab:
    ld a, [wLnkIndex + $1]                        ; $45AB
    bit 7, a                                      ; $45AE
    ret nz                                        ; $45B0

    cp $04                                        ; $45B1
    ret c                                         ; $45B3

    next_state                                    ; $45B4
    ret                                           ; $45B8


; I: bars; direction 0; watchdog; BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 08 (1640 hits in 2
; runs: 0E:08 x1640; tcrf_check/assets/mode_state_wp/)
Mode0E_State08_ExchangeWaitA::
    xor a                                         ; $45B9
    ld [wLinkBarDir], a                           ; $45BA
    call Link_DrawProgressBars                    ; $45BD
    ldh [hFarcallAArg], a                         ; $45C0
    ld a, $07                                     ; $45C2
    ld hl, Link_TimeoutTick                       ; $45C4
    call Far_Call                                 ; $45C7
    jr nz, jr_007_45d7                            ; $45CA

    ld a, $0c                                     ; $45CC
    ld [wResultMsgId], a                          ; $45CE
    set_state STATE_0E_RESULT_PREPARE             ; $45D1
    ret                                           ; $45D6


jr_007_45d7:
    ld a, [wLnkEnded]                             ; $45D7
    and a                                         ; $45DA
    ret z                                         ; $45DB

    next_state                                    ; $45DC
    ret                                           ; $45E0


; C: counts the transfer and shows the received picture
Mode0E_State09_ExchangeDoneA::
    screen_off                                    ; $45E1
    call Counters_IncTransferred                  ; $45E7
    ld a, [wSavedDc52]                            ; $45EA
    and a                                         ; $45ED
    jr z, jr_007_4606                             ; $45EE

    call Counters_IncReceivedBySender             ; $45F0
    ldh [hFarcallAArg], a                         ; $45F3
    farcall Photo_SaveReceived_Far                ; $45F5
    set_state STATE_0E_INIT                       ; $45FD
    call Link_ShowScreenB                         ; $4602
    ret                                           ; $4605


jr_007_4606:
    ld a, [wPhotoIndex]                           ; $4606
    ldh [hFarcallAArg], a                         ; $4609
    farcall Photo_Erase_UnlinkAll_Far             ; $460B
    ld a, [wPhotoIndex]                           ; $4613
    ldh [hFarcallAArg], a                         ; $4616
    farcall Photo_Erase_Far                       ; $4618
    set_state STATE_0E_INIT                       ; $4620
    call Link_ShowScreenA                         ; $4625
    ret                                           ; $4628


; I: second direction; BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 0A (4 hits in 2 runs: 0E:0A x4;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State0A_ExchangeSetupB::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $4629
    ldh [hLcdcShadow], a                          ; $462B
    xor a                                         ; $462D
    ld [wLinkBarX], a                             ; $462E
    ld [wLinkBarPhase], a                         ; $4631
    ld [wLinkLampScript], a                       ; $4634
    ld [wLinkLampScript + $1], a                  ; $4637
    farcopy Mem_CopyFromBank, Gfx_15_6C00_Mode0E_State06_ExchangeSetup, $9000, $0800 ; $463A
    farcopy Mem_CopyFromBank, Gfx_15_7400_Mode0E_State06_ExchangeSetup, $8800, $0800 ; $4648
    farcopy Mem_CopyFromBank, Gfx_15_7C00_Mode0E_State06_ExchangeSetup, $8000, $0400 ; $4656
    farcopy Mem_CopyFromBank, Map_24_5180_Mode0E_State06_ExchangeSetup, $9800, $0260 ; $4664
    screen_on                                     ; $4672
    play_music MUSIC_LINK_EXCHANGE_SETUP          ; $467B
    call Pal_FadeIn                               ; $4682
    next_state                                    ; $4685
    ret                                           ; $4689


; I: BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 0B (2352 hits in 2 runs: 0E:0B x2352;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State0B_ExchangeBarsB::
    ld a, $01                                     ; $468A
    ld [wLinkBarDir], a                           ; $468C
    call Link_DrawProgressBars                    ; $468F
    ld a, [wLnkCmdRx]                             ; $4692
    bit 7, a                                      ; $4695
    jr z, jr_007_46c6                             ; $4697

    cp $ef                                        ; $4699
    jr z, jr_007_46f0                             ; $469B

    and $03                                       ; $469D
    sla a                                         ; $469F
    sla a                                         ; $46A1
    sla a                                         ; $46A3
    ldh [hFarcallAArg], a                         ; $46A5
    farcall Album_LoadThumbPage_Far               ; $46A7
    ld a, $01                                     ; $46AF
    ld [wLnkReadyTx], a                           ; $46B1
    xor a                                         ; $46B4
    ld [wLnkHalfDone], a                          ; $46B5
    ld a, $b4                                     ; $46B8
    ld [wLinkTimeout], a                          ; $46BA
    xor a                                         ; $46BD
    ld [wLinkTimeout + $1], a                     ; $46BE
    next_state                                    ; $46C1
    ret                                           ; $46C5


jr_007_46c6:
    bit 6, a                                      ; $46C6
    ret z                                         ; $46C8

    and $1f                                       ; $46C9
    ld [wPhotoIndex], a                           ; $46CB
    ld a, $00                                     ; $46CE
    ld [wLinkTimeout], a                          ; $46D0
    ld a, $02                                     ; $46D3
    ld [wLinkTimeout + $1], a                     ; $46D5
    ld a, [wSavedDc52]                            ; $46D8
    and a                                         ; $46DB
    jr nz, jr_007_46ea                            ; $46DC

    screen_off                                    ; $46DE
    set_state STATE_0E_PICK_SECOND                ; $46E4
    ret                                           ; $46E9


jr_007_46ea:
    set_state STATE_0E_EXCHANGE_WAIT_C            ; $46EA
    ret                                           ; $46EF


jr_007_46f0:
    screen_off                                    ; $46F0
    jp Mode0E_LeaveToLinkMenu                     ; $46F6


; I: receiver-initiated link exchange in BGB (tcrf_check/tools/bgb_link_rx.py, 2026-10-25): ran only in mode 0E and
; state 0C (720 hits in 2 runs, responder that sends, JP-JP and international initiator;
; tcrf_check/assets/mode_state_wp/): waits for wLnkHalfDone after a thumbnail page is armed, 180-frame ...
Mode0E_State0C_ExchangeWaitB::
    xor a                                         ; $46F9
    ld [wLinkBarDir], a                           ; $46FA
    call Link_DrawProgressBars                    ; $46FD
    ldh [hFarcallAArg], a                         ; $4700
    ld a, $07                                     ; $4702
    ld hl, Link_TimeoutTick                       ; $4704
    call Far_Call                                 ; $4707
    jr nz, jr_007_4717                            ; $470A

    ld a, $0c                                     ; $470C
    ld [wResultMsgId], a                          ; $470E
    set_state STATE_0E_RESULT_PREPARE             ; $4711
    ret                                           ; $4716


jr_007_4717:
    ld a, [wLnkHalfDone]                          ; $4717
    and a                                         ; $471A
    ret z                                         ; $471B

    ld hl, wState                                 ; $471C
    dec [hl]                                      ; $471F
    ret                                           ; $4720


; I: clears the slot buffer and prepares the second photo; ran only in mode 0E and state 0D on the responder that
; sends (2 hits): it builds the confirmation screen of the photo the initiator asked for; FORCED run (2026-10-25,
; tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two ...
Mode0E_State0D_PickSecond::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4721
    ldh [hLcdcShadow], a                          ; $4723
    ld hl, wLinkBuffer                            ; $4725
    ld bc, $1000                                  ; $4728
    call Mem_Zero                                 ; $472B
    ld a, [wPhotoIndex]                           ; $472E
    ldh [hFarcallAArg], a                         ; $4731
    farcall Photo_LoadImage_Far                   ; $4733
    ldh [hFarcallAArg], a                         ; $473B
    farcall Owner_Load_Far                        ; $473D
    ld a, [wOwnerGenderBlood]                     ; $4745
    ld [wLinkPeerGenderBlood], a                  ; $4748
    ld a, $00                                     ; $474B
    ld hl, wPhotoImage                            ; $474D
    ld de, $9000                                  ; $4750
    ld bc, $0800                                  ; $4753
    call Mem_CopyFromBank                         ; $4756
    ld a, $00                                     ; $4759
    ld hl, wPhotoImage + $800                     ; $475B
    ld de, $8800                                  ; $475E
    ld bc, $0100                                  ; $4761
    call Mem_CopyFromBank                         ; $4764
    ld a, $00                                     ; $4767
    ld hl, wPhotoImage + $900                     ; $4769
    ld de, $8000                                  ; $476C
    ld bc, $0500                                  ; $476F
    call Mem_CopyFromBank                         ; $4772
    farcopy Mem_CopyFromBank, Map_20_7542_Mode17_State08_Split_Build, $9800, $02c0 ; $4775
    farcopy Mem_CopyFromBank, Gfx_17_4950_Shoot_DrawTimerMinutes, $8ff0, $0010 ; $4783
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8500, $0080 ; $4791
    farcopy Mem_CopyFromBank, Gfx_18_7BA0_Mode0E_State04_PickDone, $8580, $00a0 ; $479F
    farcopy Mem_CopyFromBank, Gfx_17_4A60_Mode0E_State04_PickDone, $8620, $0020 ; $47AD
    farcopy Mem_CopyFromBank, Gfx_17_4B60_Mode0E_State04_PickDone, $8640, $0030 ; $47BB
    farcopy Mem_CopyFromBank, Gfx_17_4B90_Mode0E_State04_PickDone, $8720, $0050 ; $47C9
    ld a, $54                                     ; $47D7
    ldh [hLycShadowSplit1], a                     ; $47D9
    ldh [hSplit1Latch], a                         ; $47DB
    ld hl, hStatShadow                            ; $47DD
    set 6, [hl]                                   ; $47E0
    ld hl, rIE                                    ; $47E2
    set 1, [hl]                                   ; $47E5
    ld a, $01                                     ; $47E7
    ldh [hStatHandlerIndex], a                    ; $47E9
    call Oam_ClearShadow                          ; $47EB
    call Lcd_On                                   ; $47EE
    call Pal_FadeIn                               ; $47F1
    next_state                                    ; $47F4
    ret                                           ; $47F8


; C: the sending responder's confirmation dialog (README 14.3, 14.7): A -> state 0F (ready, the photo is sent), B ->
; wLnkReadyTx = $EF (refuse) and state 0A; ran only in mode 0E and state 0E (778 hits) and the confirm A took it to
; 0F; FORCED run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): ...
Mode0E_State0E_ResponderConfirmSend::
    call Link_DrawAbortJitter                     ; $47F9
    ldh a, [hKeysNew]                             ; $47FC
    bit PADB_A, a                                 ; $47FE
    jr z, jr_007_4817                             ; $4800

    screen_off                                    ; $4802
    stat_irq_off                                  ; $4808
    next_state                                    ; $4812
    ret                                           ; $4816


jr_007_4817:
    bit 1, a                                      ; $4817
    ret z                                         ; $4819

    screen_off                                    ; $481A
    stat_irq_off                                  ; $4820
    ld a, $ef                                     ; $482A
    ld [wLnkReadyTx], a                           ; $482C
    set_state STATE_0E_EXCHANGE_SETUP_B           ; $482F
    ret                                           ; $4834


; C: lnk_ready_tx := 1; ran only in mode 0E and state 0F (2 hits): wLnkReadyTx := 1 after the A of the confirmation
; dialog; FORCED run (2026-10-25, tcrf_check/tools/bgb_link_rx.py): receiver-initiated link exchange between two BGB
; instances with the link deadline disabled (07:4ACE dec [hl] -> nop; ...
Mode0E_State0F_Ready::
    call Mode0E_State0A_ExchangeSetupB            ; $4835
    ld a, $01                                     ; $4838
    ld [wLnkReadyTx], a                           ; $483A
    ret                                           ; $483D


; I: BGB watchpoint pass 2026-10-25: ran only in mode 0E and state 10 (1640 hits in 2 runs: 0E:10 x1640;
; tcrf_check/assets/mode_state_wp/)
Mode0E_State10_ExchangeWaitC::
    xor a                                         ; $483E
    ld [wLinkBarDir], a                           ; $483F
    call Link_DrawProgressBars                    ; $4842
    ldh [hFarcallAArg], a                         ; $4845
    ld a, $07                                     ; $4847
    ld hl, Link_TimeoutTick                       ; $4849
    call Far_Call                                 ; $484C
    jr nz, jr_007_485c                            ; $484F

    ld a, $0c                                     ; $4851
    ld [wResultMsgId], a                          ; $4853
    set_state STATE_0E_RESULT_PREPARE             ; $4856
    ret                                           ; $485B


jr_007_485c:
    ld a, [wLnkEnded]                             ; $485C
    and a                                         ; $485F
    ret z                                         ; $4860

    next_state                                    ; $4861
    ret                                           ; $4865


; C: counts the transfer and shows the received picture
Mode0E_State11_ExchangeDoneB::
    screen_off                                    ; $4866
    call Counters_IncTransferred                  ; $486C
    ld a, [wSavedDc52]                            ; $486F
    and a                                         ; $4872
    jr z, jr_007_488b                             ; $4873

    call Counters_IncReceivedBySender             ; $4875
    ldh [hFarcallAArg], a                         ; $4878
    farcall Photo_SaveReceived_Far                ; $487A
    set_state STATE_0E_INIT                       ; $4882
    call Link_ShowScreenB                         ; $4887
    ret                                           ; $488A


jr_007_488b:
    ld a, [wPhotoIndex]                           ; $488B
    ldh [hFarcallAArg], a                         ; $488E
    farcall Photo_Erase_UnlinkAll_Far             ; $4890
    ld a, [wPhotoIndex]                           ; $4898
    ldh [hFarcallAArg], a                         ; $489B
    farcall Photo_Erase_Far                       ; $489D
    set_state STATE_0E_INIT                       ; $48A5
    call Link_ShowScreenA                         ; $48AA
    ret                                           ; $48AD


; C
Mode0E_State12_ResultPrepare::
    screen_off                                    ; $48AE
    xor a                                         ; $48B4
    ld [wSubstate], a                             ; $48B5
    next_state                                    ; $48B8
    ret                                           ; $48BC


; C: far call 09:7290
Mode0E_State13_ResultScreen::
    ldh [hFarcallAArg], a                         ; $48BD
    farcall ResultScreen_Far                      ; $48BF
    ret                                           ; $48C7


; C: jp 07:40EE
Mode0E_State14_Abort::
    jp Mode0E_LeaveToLinkMenu                     ; $48C8


    db $fa, $05, $da, $cb, $27, $4f, $06, $00, $21, $63, $49, $09, $5e, $01, $8c, $35
    db $3e, $a5, $cb, $53, $c4, $7f, $25, $01, $8c, $65, $3e, $a6, $cb, $4b, $c4, $7f
    db $25, $01, $8c, $95, $3e, $a7, $cd, $0d, $49, $23, $fa, $06, $da, $be, $38, $0d
    db $23, $7e, $3c, $28, $04, $fa, $05, $da, $3c, $ea, $05, $da, $af, $3c, $ea, $06
    db $da, $c9, $f5, $c5, $e5, $cb, $43, $20, $06, $af, $ea, $08, $da, $18, $39, $fa
    db $08, $da, $c6, $09, $30, $02, $3e, $ff, $ea, $08, $da, $fa, $08, $da, $21, $07
    db $da, $be, $38, $24, $fa, $08, $da, $d6, $23, $30, $01, $af, $ea, $08, $da, $cd
    db $8e, $09, $e6, $03, $c6, $0a, $4f, $fa, $07, $da, $91, $30, $01, $af, $ea, $07
    db $da, $e1, $c1, $f1, $cd, $7f, $25, $c9, $fa, $07, $da, $c6, $08, $30, $02, $3e
    db $80, $ea, $07, $da, $e1, $c1, $f1, $c9

; C: 2-byte steps {flags; duration}; $FF loops
Link_LampScriptTbl::
    db $07, $f0, $07, $f0, $07, $f0, $00, $78, $04, $3c, $00, $50, $02, $3c, $00, $50
    db $01, $3c, $00, $50, $04, $1e, $02, $1e, $01, $1e, $00, $14, $07, $1e, $00, $14
    db $07, $1e, $00, $3c, $ff

; I: the two bars that cross the screen (X in D A02)
Link_DrawProgressBars::
    ld hl, wLinkBarX                              ; $4988
    ld a, [wLinkBarDir]                           ; $498B
    and a                                         ; $498E
    jr nz, jr_007_4994                            ; $498F

    inc [hl]                                      ; $4991
    jr jr_007_4995                                ; $4992

jr_007_4994:
    dec [hl]                                      ; $4994

jr_007_4995:
    ld a, [wLinkBarPhase]                         ; $4995
    inc a                                         ; $4998
    cp $38                                        ; $4999
    jr c, jr_007_499e                             ; $499B

    xor a                                         ; $499D

jr_007_499e:
    ld [wLinkBarPhase], a                         ; $499E
    cp $08                                        ; $49A1
    jr nc, jr_007_49b0                            ; $49A3

    ld a, [wLinkBarDir]                           ; $49A5
    and a                                         ; $49A8
    jr nz, jr_007_49b0                            ; $49A9

    ld a, $1b                                     ; $49AB
    ldh [hBgpShadow], a                           ; $49AD
    ret                                           ; $49AF


jr_007_49b0:
    ld a, $e4                                     ; $49B0
    ldh [hBgpShadow], a                           ; $49B2
    ld a, [wLinkBarX]                             ; $49B4
    ld b, a                                       ; $49B7
    ld c, $24                                     ; $49B8
    ld a, [wLinkBarDir]                           ; $49BA
    add $a8                                       ; $49BD
    call Oam_AddMeta_B02_52BD                     ; $49BF
    ld a, [wLinkBarX]                             ; $49C2
    cpl                                           ; $49C5
    add $a1                                       ; $49C6
    ld b, a                                       ; $49C8
    ld c, $54                                     ; $49C9
    ld a, [wLinkBarDir]                           ; $49CB
    add $a8                                       ; $49CE
    call Oam_AddMeta_B02_52BD                     ; $49D0
    ret                                           ; $49D3


; C: received photos: counter chosen by the sender gender bit (CFFF bit 0)
Counters_IncReceivedBySender::
    ldh [hFarcallAArg], a                         ; $49D4
    farcall Counters_Load_Far                     ; $49D6
    ld hl, wCntRecvA                              ; $49DE
    ld a, [wLinkPeerGenderBlood]                  ; $49E1
    ld b, a                                       ; $49E4
    ld a, [hl]                                    ; $49E5
    bit 0, b                                      ; $49E6
    jr z, jr_007_49f1                             ; $49E8

    cp $99                                        ; $49EA
    jr z, jr_007_49f1                             ; $49EC

    add $01                                       ; $49EE
    daa                                           ; $49F0

jr_007_49f1:
    ld [hl+], a                                   ; $49F1
    ld a, [hl]                                    ; $49F2
    bit 1, b                                      ; $49F3
    jr z, jr_007_49fe                             ; $49F5

    cp $99                                        ; $49F7
    jr z, jr_007_49fe                             ; $49F9

    add $01                                       ; $49FB
    daa                                           ; $49FD

jr_007_49fe:
    ld [hl], a                                    ; $49FE
    ldh [hFarcallAArg], a                         ; $49FF
    farcall Counters_Store_Far                    ; $4A01
    ret                                           ; $4A09


; I: UNREFERENCED
Unused_Link_DrawPhotoNumber::
    ld c, $00                                     ; $4A0A
    ld a, [wPhotoIndex]                           ; $4A0C
    inc a                                         ; $4A0F

jr_007_4a10:
    cp $0a                                        ; $4A10
    jr c, jr_007_4a19                             ; $4A12

    sub $0a                                       ; $4A14
    inc c                                         ; $4A16
    jr jr_007_4a10                                ; $4A17

jr_007_4a19:
    push bc                                       ; $4A19
    ld c, a                                       ; $4A1A
    ld b, $00                                     ; $4A1B
    swap c                                        ; $4A1D
    sla c                                         ; $4A1F
    rl b                                          ; $4A21
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $4A23
    add hl, bc                                    ; $4A26
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $4A27
    ld de, $8720                                  ; $4A29
    ld bc, $0020                                  ; $4A2C
    call Vram_CopyFromBank                        ; $4A2F
    pop bc                                        ; $4A32
    ld b, $00                                     ; $4A33
    swap c                                        ; $4A35
    sla c                                         ; $4A37
    rl b                                          ; $4A39
    ld hl, Gfx_17_4800_Compose_DrawFreeCount      ; $4A3B
    add hl, bc                                    ; $4A3E
    ld a, BANK(Gfx_17_4800_Compose_DrawFreeCount) ; $4A3F
    ld de, $8700                                  ; $4A41
    ld bc, $0020                                  ; $4A44
    call Vram_CopyFromBank                        ; $4A47
    ret                                           ; $4A4A


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
Link_DrawAbortJitter::
    ldh a, [hFrameCounter]                        ; $4A4B
    and $01                                       ; $4A4D
    jr nz, jr_007_4a5d                            ; $4A4F

    call Rng_Next                                 ; $4A51
    ld [wJitterX], a                              ; $4A54
    call Rng_Next                                 ; $4A57
    ld [wJitterY], a                              ; $4A5A

jr_007_4a5d:
    ld a, [wJitterX]                              ; $4A5D
    and $01                                       ; $4A60
    add $79                                       ; $4A62
    ld b, a                                       ; $4A64
    ld a, [wJitterY]                              ; $4A65
    and $01                                       ; $4A68
    add $7c                                       ; $4A6A
    ld c, a                                       ; $4A6C
    ld a, $5f                                     ; $4A6D
    call Oam_AddMeta_B02_52BD                     ; $4A6F
    ld a, [wJitterX]                              ; $4A72
    and $01                                       ; $4A75
    add $79                                       ; $4A77
    ld b, a                                       ; $4A79
    ld a, [wJitterY]                              ; $4A7A
    and $01                                       ; $4A7D
    add $8d                                       ; $4A7F
    ld c, a                                       ; $4A81
    ld a, $60                                     ; $4A82
    call Oam_AddMeta_B02_52BD                     ; $4A84
    ret                                           ; $4A87


; C: far-return helper: watchdog of the waiting states; Z when 0
Link_TimeoutTick::
    ld hl, wLinkTimeout                           ; $4A88
    dec [hl]                                      ; $4A8B
    ld a, [hl+]                                   ; $4A8C
    cp $ff                                        ; $4A8D
    jr nz, jr_007_4a92                            ; $4A8F

    dec [hl]                                      ; $4A91

jr_007_4a92:
    ld a, [hl-]                                   ; $4A92
    or [hl]                                       ; $4A93
    jp Far_Call_Return                            ; $4A94


; C: transferred photos + 1
Counters_IncTransferred::
    ldh [hFarcallAArg], a                         ; $4A97
    farcall Counters_Load_Far                     ; $4A99
    ld a, $01                                     ; $4AA1
    ld hl, wCntSent                               ; $4AA3
    ld b, $02                                     ; $4AA6
    call Bcd_AddSaturate                          ; $4AA8
    ldh [hFarcallAArg], a                         ; $4AAB
    farcall Counters_Store_Far                    ; $4AAD
    ret                                           ; $4AB5


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the link result screen A: tiles 1C:5E60 / 6660 / 6D50 and map 26:5340 (Mode0E paths jr_007_4622 / jr_007_48C6)
Link_ShowScreenA::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4AB6
    ldh [hLcdcShadow], a                          ; $4AB8
    ld a, $e4                                     ; $4ABA
    ld [wPaletteTarget], a                        ; $4ABC
    ld [wPaletteTarget + $1], a                   ; $4ABF
    ld [wPaletteTarget + $2], a                   ; $4AC2
    xor a                                         ; $4AC5
    ldh [hScxShadow], a                           ; $4AC6
    ldh [hScyShadow], a                           ; $4AC8
    farcopy Mem_CopyFromBank, Gfx_1C_5E60_Link_ShowScreenA, $9000, $0800 ; $4ACA
    farcopy Mem_CopyFromBank, Gfx_1C_6660_Link_ShowScreenA, $8800, $0700 ; $4AD8
    farcopy Mem_CopyFromBank, Gfx_1C_6D50_Link_ShowScreenB, $8ff0, $0010 ; $4AE6
    farcopy Mem_CopyFromBank, Map_26_5100_Link_ShowScreenA, $9800, $0240 ; $4AF4
    screen_on                                     ; $4B02
    call Pal_FadeIn                               ; $4B0B

jr_007_4b0e:
    rst Rst08_WaitVBlank                          ; $4B0E
    ldh a, [hKeysNew]                             ; $4B0F
    and a                                         ; $4B11
    jr z, jr_007_4b0e                             ; $4B12

    screen_off                                    ; $4B14
    ret                                           ; $4B1A


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the link result screen B: the same tiles and map 26:6540 (Mode0E_State09_ExchangeDoneA, State11_ExchangeDoneB)
Link_ShowScreenB::
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $4B1B
    ldh [hLcdcShadow], a                          ; $4B1D
    ld a, $e4                                     ; $4B1F
    ld [wPaletteTarget], a                        ; $4B21
    ld [wPaletteTarget + $1], a                   ; $4B24
    ld [wPaletteTarget + $2], a                   ; $4B27
    xor a                                         ; $4B2A
    ldh [hScxShadow], a                           ; $4B2B
    ldh [hScyShadow], a                           ; $4B2D
    farcopy Mem_CopyFromBank, Gfx_1C_5E60_Link_ShowScreenA, $9000, $0800 ; $4B2F
    farcopy Mem_CopyFromBank, Gfx_1C_6660_Link_ShowScreenA, $8800, $0700 ; $4B3D
    farcopy Mem_CopyFromBank, Gfx_1C_6D50_Link_ShowScreenB, $8ff0, $0010 ; $4B4B
    farcopy Mem_CopyFromBank, Map_26_6300_Link_ShowScreenB, $9800, $0240 ; $4B59
    screen_on                                     ; $4B67
    call Pal_FadeIn                               ; $4B70

jr_007_4b73:
    rst Rst08_WaitVBlank                          ; $4B73
    ldh a, [hKeysNew]                             ; $4B74
    and a                                         ; $4B76
    jr z, jr_007_4b73                             ; $4B77

    screen_off                                    ; $4B79
    ret                                           ; $4B7F


; I: UNREFERENCED
Unused_Link_LoadTiles::
    farcopy Mem_CopyFromBank, Gfx_24_57E0_Unused_Link_LoadTiles, $8ef0, $0100 ; $4B80
    ld hl, $9a30                                  ; $4B8E
    ld a, [wUnusedLinkBufSum]                     ; $4B91
    call Unused_Link_WriteHexByte                 ; $4B94
    ld a, [wUnusedLinkBufXor]                     ; $4B97

; I: UNREFERENCED
Unused_Link_WriteHexByte::
    push af                                       ; $4B9A
    swap a                                        ; $4B9B
    call Unused_Link_WriteHexNibble               ; $4B9D
    pop af                                        ; $4BA0

; I: UNREFERENCED
Unused_Link_WriteHexNibble::
    and $0f                                       ; $4BA1
    add $ef                                       ; $4BA3
    ld [hl+], a                                   ; $4BA5
    ret                                           ; $4BA6


; I: UNREFERENCED: 16-bit sum of the $1000 byte buffer
Unused_Link_SumSlotBuffer::
    ld hl, wPhotoImage                            ; $4BA7
    ld bc, $1000                                  ; $4BAA
    ld de, $0000                                  ; $4BAD

jr_007_4bb0:
    ld a, d                                       ; $4BB0
    add [hl]                                      ; $4BB1
    ld d, a                                       ; $4BB2
    ld a, e                                       ; $4BB3
    xor [hl]                                      ; $4BB4
    ld e, a                                       ; $4BB5
    dec bc                                        ; $4BB6
    ld a, b                                       ; $4BB7
    or c                                          ; $4BB8
    inc hl                                        ; $4BB9
    jr nz, jr_007_4bb0                            ; $4BBA

    ld a, e                                       ; $4BBC
    ld [wUnusedLinkBufXor], a                     ; $4BBD
    ld a, d                                       ; $4BC0
    ld [wUnusedLinkBufSum], a                     ; $4BC1
    ret                                           ; $4BC4


; C: photo choose dialog (3 substates)
LinkPick_Far::
    ld a, [wSubstate]                             ; $4BC5
    rst Rst18_JumpTable                           ; $4BC8

; I
LinkPick_SubstateTbl::
    dw LinkPick_Substate0_Init
    dw LinkPick_Substate1_Browse
    dw LinkPick_Substate2_Exit

; C
LinkPick_Substate0_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4BCF
    ldh [hLcdcShadow], a                          ; $4BD1
    ld a, $e4                                     ; $4BD3
    ld [wPaletteTarget], a                        ; $4BD5
    ld [wPaletteTarget + $1], a                   ; $4BD8
    ld a, $d2                                     ; $4BDB
    ld [wPaletteTarget + $2], a                   ; $4BDD
    xor a                                         ; $4BE0
    ldh [hScxShadow], a                           ; $4BE1
    ldh [hScyShadow], a                           ; $4BE3
    ldh [hScxBand1], a                            ; $4BE5
    ldh [hScyBand1], a                            ; $4BE7
    ld [wLinkCancelLatch], a                      ; $4BE9
    ld hl, $9000                                  ; $4BEC
    ld bc, $0800                                  ; $4BEF
    call Mem_Zero                                 ; $4BF2
    farcopy Mem_CopyFromBank, Gfx_13_5800_Mode0F_State00_Init, $8000, $1000 ; $4BF5
    farcopy Mem_CopyFromBank, Map_24_54C0_Mode0F_State00_Init, $9800, $0240 ; $4C03
    ld hl, $8ff0                                  ; $4C11
    ld a, $ff                                     ; $4C14
    ld b, $04                                     ; $4C16

jr_007_4c18:
    ld [hl+], a                                   ; $4C18
    ld [hl+], a                                   ; $4C19
    ld [hl+], a                                   ; $4C1A
    ld [hl+], a                                   ; $4C1B
    dec b                                         ; $4C1C
    jr nz, jr_007_4c18                            ; $4C1D

    ld hl, $9be0                                  ; $4C1F
    ld a, $ff                                     ; $4C22
    ld b, $08                                     ; $4C24

jr_007_4c26:
    ld [hl+], a                                   ; $4C26
    ld [hl+], a                                   ; $4C27
    ld [hl+], a                                   ; $4C28
    ld [hl+], a                                   ; $4C29
    dec b                                         ; $4C2A
    jr nz, jr_007_4c26                            ; $4C2B

    call LinkPick_SetBrowseLimit                  ; $4C2D
    screen_on                                     ; $4C30
    play_music MUSIC_PHOTO_PICKER                 ; $4C39
    call Pal_FadeIn                               ; $4C40
    ld a, [wPhotoIndex]                           ; $4C43
    cp $1e                                        ; $4C46
    jr c, jr_007_4c4e                             ; $4C48

    xor a                                         ; $4C4A
    ld [wPhotoIndex], a                           ; $4C4B

jr_007_4c4e:
    ld a, [wPhotoIndex]                           ; $4C4E
    call LinkPick_RequestRemotePage               ; $4C51
    ld a, [wPhotoIndex]                           ; $4C54
    call LinkPick_LoadPageThumbs                  ; $4C57
    call LinkPick_NoPhotoHere                     ; $4C5A
    jr c, jr_007_4c88                             ; $4C5D

    ld a, $11                                     ; $4C5F
    ld [wCursorSpriteVar], a                      ; $4C61
    call LinkPick_DrawCursor                      ; $4C64
    call Oam_HideUnused                           ; $4C67
    rst Rst08_WaitVBlank                          ; $4C6A
    call LinkPick_LoadBigThumb                    ; $4C6B
    xor a                                         ; $4C6E
    ld [wCursorSpriteVar], a                      ; $4C6F
    call LinkPick_DrawCursor                      ; $4C72
    call Oam_HideUnused                           ; $4C75
    ld bc, $0004                                  ; $4C78
    call Wait_Frames                              ; $4C7B
    call LinkPick_ClearThumbSlot                  ; $4C7E
    ld a, $01                                     ; $4C81
    ld [wCursorSpriteVar], a                      ; $4C83
    jr jr_007_4c8d                                ; $4C86

jr_007_4c88:
    ld a, $11                                     ; $4C88
    ld [wCursorSpriteVar], a                      ; $4C8A

jr_007_4c8d:
    call LinkPick_DrawCursor                      ; $4C8D
    call LinkPick_LoadPhotoIndex                  ; $4C90
    call LinkPick_LoadMessageStrip                ; $4C93
    call LinkPick_LoadIcon                        ; $4C96
    call LinkPick_DrawCursor                      ; $4C99
    ld hl, wSubstate                              ; $4C9C
    inc [hl]                                      ; $4C9F
    jp Far_Call_Return                            ; $4CA0


; C: number of photos that can be chosen
LinkPick_SetBrowseLimit::
    ld a, [wLnkRoleRx]                            ; $4CA3
    and a                                         ; $4CA6
    jr nz, jr_007_4cb2                            ; $4CA7

    ld a, [wLnkOwnCount]                          ; $4CA9
    res 7, a                                      ; $4CAC
    ld [wLinkPickCount], a                        ; $4CAE
    ret                                           ; $4CB1


jr_007_4cb2:
    ld a, [wLnkPeerCount]                         ; $4CB2
    ld [wLinkPickCount], a                        ; $4CB5
    ret                                           ; $4CB8


; C
LinkPick_Substate1_Browse::
    ld a, [wLinkCancelLatch]                      ; $4CB9
    and a                                         ; $4CBC
    jr z, jr_007_4cd5                             ; $4CBD

    ld a, [wLnkCmdRx]                             ; $4CBF
    cp $ef                                        ; $4CC2
    jr nz, jr_007_4d12                            ; $4CC4

    ld a, $02                                     ; $4CC6
    ld [wAbResult], a                             ; $4CC8
    call LinkPick_DrawCursor                      ; $4CCB
    ld hl, wSubstate                              ; $4CCE
    inc [hl]                                      ; $4CD1
    jp Far_Call_Return                            ; $4CD2


jr_007_4cd5:
    ldh a, [hKeysNew]                             ; $4CD5
    cp PADF_B                                     ; $4CD7
    jr nz, jr_007_4cf3                            ; $4CD9

    play_sfx1 SFX1_KEY_B                          ; $4CDB
    ld a, $ef                                     ; $4CE2
    ld [wLnkCmdTx], a                             ; $4CE4
    ld [wLinkCancelLatch], a                      ; $4CE7
    call Link_QueueCommand                        ; $4CEA
    call LinkPick_DrawCursor                      ; $4CED
    jp Far_Call_Return                            ; $4CF0


jr_007_4cf3:
    ldh a, [hKeysNew]                             ; $4CF3
    cp PADF_A                                     ; $4CF5
    jr nz, jr_007_4d12                            ; $4CF7

    ld [wAbResult], a                             ; $4CF9
    call LinkPick_NoPhotoHere                     ; $4CFC
    jr c, jr_007_4d12                             ; $4CFF

    play_sfx1 SFX1_PICK_PHOTO                     ; $4D01
    call LinkPick_DrawCursor                      ; $4D08
    ld hl, wSubstate                              ; $4D0B
    inc [hl]                                      ; $4D0E
    jp Far_Call_Return                            ; $4D0F


jr_007_4d12:
    call LinkPick_DrawCursor                      ; $4D12
    call LinkPick_Navigate                        ; $4D15
    jp Far_Call_Return                            ; $4D18


; C
LinkPick_Substate2_Exit::
    ld a, [wAbResult]                             ; $4D1B
    and $01                                       ; $4D1E
    jr nz, jr_007_4d2f                            ; $4D20

    screen_off                                    ; $4D22
    next_state                                    ; $4D28
    jp Far_Call_Return                            ; $4D2C


jr_007_4d2f:
    ld b, $04                                     ; $4D2F

jr_007_4d31:
    ld c, $09                                     ; $4D31

jr_007_4d33:
    push bc                                       ; $4D33
    call LinkPick_DrawCursor                      ; $4D34
    call Oam_HideUnused                           ; $4D37
    rst Rst08_WaitVBlank                          ; $4D3A
    pop bc                                        ; $4D3B
    dec c                                         ; $4D3C
    jr nz, jr_007_4d33                            ; $4D3D

    ld hl, wCursorSpriteVar                       ; $4D3F
    inc [hl]                                      ; $4D42
    dec b                                         ; $4D43
    jr nz, jr_007_4d31                            ; $4D44

    screen_off                                    ; $4D46
    next_state                                    ; $4D4C
    jp Far_Call_Return                            ; $4D50


; C
LinkPick_DrawCursor::
    ld a, [wPhotoIndex]                           ; $4D53
    and $07                                       ; $4D56
    sla a                                         ; $4D58
    ld e, a                                       ; $4D5A
    ld d, $00                                     ; $4D5B
    ld hl, LinkPick_DrawCursor_Tbl4D6D            ; $4D5D
    add hl, de                                    ; $4D60
    ld b, [hl]                                    ; $4D61
    inc hl                                        ; $4D62
    ld c, [hl]                                    ; $4D63
    ld a, [wCursorSpriteVar]                      ; $4D64
    add $0f                                       ; $4D67
    call Oam_AddMeta_B01_4000                     ; $4D69
    ret                                           ; $4D6C


; C: auto: 16 bytes, bytes; referenced by LinkPick_DrawCursor. L3 pass 2026-10-26: read in BGB in the scenarios
; link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_DrawCursor_Tbl4D6D::
    db $48, $18, $70, $18, $20, $40, $48, $40, $70, $40, $20, $68, $48, $68, $70, $68

; C: D-pad moves in the page; page turns
LinkPick_Navigate::
    call LinkPick_ReadDirection                   ; $4D7D
    ret z                                         ; $4D80

    dec a                                         ; $4D81
    ld c, a                                       ; $4D82
    ld a, [wPhotoIndex]                           ; $4D83
    and $3f                                       ; $4D86
    sla a                                         ; $4D88
    sla a                                         ; $4D8A
    add c                                         ; $4D8C
    ld e, a                                       ; $4D8D
    ld d, $00                                     ; $4D8E
    ld hl, LinkPick_Navigate_Tbl4E1A              ; $4D90
    add hl, de                                    ; $4D93
    ld a, [hl]                                    ; $4D94
    cp $ff                                        ; $4D95
    ret z                                         ; $4D97

    ld [wPickerCursorTarget], a                   ; $4D98
    call Oam_HideUnused                           ; $4D9B
    rst Rst08_WaitVBlank                          ; $4D9E
    call LinkPick_NoPhotoHere                     ; $4D9F
    jr c, jr_007_4dbe                             ; $4DA2

    xor a                                         ; $4DA4
    ld [wCursorSpriteVar], a                      ; $4DA5
    call LinkPick_DrawCursor                      ; $4DA8
    call Oam_HideUnused                           ; $4DAB
    call LinkPick_LoadThumbOfCursor               ; $4DAE
    rst Rst08_WaitVBlank                          ; $4DB1
    ld a, $11                                     ; $4DB2
    ld [wCursorSpriteVar], a                      ; $4DB4
    call LinkPick_DrawCursor                      ; $4DB7
    call Oam_HideUnused                           ; $4DBA
    rst Rst08_WaitVBlank                          ; $4DBD

jr_007_4dbe:
    ld hl, wPickerCursorTarget                    ; $4DBE
    bit 7, [hl]                                   ; $4DC1
    jr z, jr_007_4dd7                             ; $4DC3

    bit 6, [hl]                                   ; $4DC5
    jr z, jr_007_4dd1                             ; $4DC7

    call Oam_ClearShadow                          ; $4DC9
    call LinkPick_PageTurnNext                    ; $4DCC
    jr jr_007_4dd7                                ; $4DCF

jr_007_4dd1:
    call Oam_ClearShadow                          ; $4DD1
    call LinkPick_PageTurnPrev                    ; $4DD4

jr_007_4dd7:
    ld a, [wPickerCursorTarget]                   ; $4DD7
    and $3f                                       ; $4DDA
    ld [wPhotoIndex], a                           ; $4DDC
    call LinkPick_NoPhotoHere                     ; $4DDF
    jr c, jr_007_4e0e                             ; $4DE2

    call LinkPick_LoadBigThumb                    ; $4DE4
    rst Rst08_WaitVBlank                          ; $4DE7
    xor a                                         ; $4DE8
    ld [wCursorSpriteVar], a                      ; $4DE9
    call LinkPick_DrawCursor                      ; $4DEC
    call Oam_HideUnused                           ; $4DEF
    ld bc, $0004                                  ; $4DF2
    call Wait_Frames                              ; $4DF5
    call LinkPick_ClearThumbSlot                  ; $4DF8
    ld a, $01                                     ; $4DFB
    ld [wCursorSpriteVar], a                      ; $4DFD
    call LinkPick_DrawCursor                      ; $4E00
    call Oam_HideUnused                           ; $4E03
    rst Rst08_WaitVBlank                          ; $4E06
    call LinkPick_DrawCursor                      ; $4E07
    call LinkPick_LoadPhotoIndex                  ; $4E0A
    ret                                           ; $4E0D


jr_007_4e0e:
    ld a, $11                                     ; $4E0E
    ld [wCursorSpriteVar], a                      ; $4E10
    call LinkPick_DrawCursor                      ; $4E13
    call LinkPick_LoadPhotoIndex                  ; $4E16
    ret                                           ; $4E19


; C: auto: 120 bytes, bytes; referenced by LinkPick_Navigate. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: the cursor graph of the link photo picker read by
; LinkPick_Navigate (120 bytes)
LinkPick_Navigate_Tbl4E1A::
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
    ldh a, [hKeysNewRepeat]                       ; $4E92
    bit PADB_LEFT, a                              ; $4E94
    jr z, jr_007_4ea3                             ; $4E96

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4E98
    ld a, $01                                     ; $4E9F
    jr jr_007_4ecd                                ; $4EA1

jr_007_4ea3:
    bit 4, a                                      ; $4EA3
    jr z, jr_007_4eb2                             ; $4EA5

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4EA7
    ld a, $02                                     ; $4EAE
    jr jr_007_4ecd                                ; $4EB0

jr_007_4eb2:
    bit 6, a                                      ; $4EB2
    jr z, jr_007_4ec1                             ; $4EB4

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4EB6
    ld a, $03                                     ; $4EBD
    jr jr_007_4ecd                                ; $4EBF

jr_007_4ec1:
    bit 7, a                                      ; $4EC1
    ret z                                         ; $4EC3

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4EC4
    ld a, $04                                     ; $4ECB

jr_007_4ecd:
    and a                                         ; $4ECD
    ret                                           ; $4ECE


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; copies the thumbnail of wPhotoIndex to its VRAM slot $9000 + (index & 7) x $100 (LinkPick_Navigate)
LinkPick_LoadThumbOfCursor::
    ld a, [wPhotoIndex]                           ; $4ECF
    call LinkPick_ThumbBufferAddress              ; $4ED2
    push af                                       ; $4ED5
    ld a, [wPhotoIndex]                           ; $4ED6
    and $07                                       ; $4ED9
    add $90                                       ; $4EDB
    ld d, a                                       ; $4EDD
    ld e, $00                                     ; $4EDE
    ld bc, $0100                                  ; $4EE0
    pop af                                        ; $4EE3
    call Vram_CopyFromBank                        ; $4EE4
    ret                                           ; $4EE7


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadBigThumb::
    ld a, [wPhotoIndex]                           ; $4EE8
    call LinkPick_ThumbBufferAddress              ; $4EEB
    ld de, $8700                                  ; $4EEE
    ld bc, $0100                                  ; $4EF1
    call Vram_CopyFromBank                        ; $4EF4
    ret                                           ; $4EF7


; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_ClearThumbSlot::
    ld a, [wPhotoIndex]                           ; $4EF8
    and $07                                       ; $4EFB
    add $90                                       ; $4EFD
    ld h, a                                       ; $4EFF
    ld l, $00                                     ; $4F00
    xor a                                         ; $4F02
    ld bc, $0100                                  ; $4F03
    call Vram_FillViaVBlank                       ; $4F06
    ret                                           ; $4F09


; C
LinkPick_LoadPageThumbs::
    ld de, $9000                                  ; $4F0A
    and $18                                       ; $4F0D
    ld c, a                                       ; $4F0F
    ld b, $08                                     ; $4F10

jr_007_4f12:
    push bc                                       ; $4F12
    push de                                       ; $4F13
    ld a, c                                       ; $4F14
    ld hl, wLinkPickCount                         ; $4F15
    cp [hl]                                       ; $4F18
    jr c, jr_007_4f37                             ; $4F19

    cp $1e                                        ; $4F1B
    jr c, jr_007_4f2a                             ; $4F1D

    ld l, e                                       ; $4F1F
    ld h, d                                       ; $4F20
    xor a                                         ; $4F21
    ld bc, $0100                                  ; $4F22
    call Vram_FillViaVBlank                       ; $4F25
    jr jr_007_4f40                                ; $4F28

jr_007_4f2a:
    ld a, BANK(Src_13_6400_PhotoPicker_LoadPageThumbs); $4F2A
    ld hl, Src_13_6400_PhotoPicker_LoadPageThumbs ; $4F2C
    ld bc, $0100                                  ; $4F2F
    call Vram_CopyFromBank                        ; $4F32
    jr jr_007_4f40                                ; $4F35

jr_007_4f37:
    call LinkPick_ThumbBufferAddress              ; $4F37
    ld bc, $0100                                  ; $4F3A
    call Vram_CopyFromBank                        ; $4F3D

jr_007_4f40:
    pop de                                        ; $4F40
    pop bc                                        ; $4F41
    inc d                                         ; $4F42
    inc c                                         ; $4F43
    dec b                                         ; $4F44
    jr nz, jr_007_4f12                            ; $4F45

    ret                                           ; $4F47


; C
LinkPick_LoadMessageStrip::
    ld a, [wMsgStripSel]                          ; $4F48
    ld e, a                                       ; $4F4B
    sla a                                         ; $4F4C
    add e                                         ; $4F4E
    ld e, a                                       ; $4F4F
    ld d, $00                                     ; $4F50
    ld hl, LinkPick_LoadMessageStrip_Gfx4F67      ; $4F52
    add hl, de                                    ; $4F55
    ld e, [hl]                                    ; $4F56
    inc hl                                        ; $4F57
    ld d, [hl]                                    ; $4F58
    inc hl                                        ; $4F59
    ld a, [hl]                                    ; $4F5A
    ld h, d                                       ; $4F5B
    ld l, e                                       ; $4F5C
    ld de, $8800                                  ; $4F5D
    ld bc, $0280                                  ; $4F60
    call Vram_CopyFromBank                        ; $4F63
    ret                                           ; $4F66


; C: auto: 45 bytes, tile data; referenced by LinkPick_LoadMessageStrip. L3 pass 2026-10-26: read in BGB in the
; scenarios link_exchange 0E:03 (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadMessageStrip_Gfx4F67::
    dwb Gfx_0E_4000_MsgStrip
    dwb Gfx_0E_4280_MsgStrip
    dwb Gfx_0E_4500_MsgStrip
    dwb Gfx_0E_4780_MsgStrip
    dwb Gfx_0E_4A00_MsgStrip
    dwb Gfx_0E_4C80_MsgStrip
    dwb Gfx_0E_4F00_MsgStrip
    dwb Gfx_0E_5180_MsgStrip
    dwb Gfx_0E_5400_MsgStrip
    dwb Gfx_0E_5680_MsgStrip
    dwb Gfx_0E_5900_MsgStrip
    dwb Gfx_0E_5B80_MsgStrip
    dwb Gfx_0E_5E00_MsgStrip
    dwb Gfx_0D_5D00_MsgStrip
    dwb Gfx_0E_6080_MsgStrip

; C
LinkPick_LoadIcon::
    ld a, [wIconSel]                              ; $4F94
    ld e, a                                       ; $4F97
    sla a                                         ; $4F98
    add e                                         ; $4F9A
    ld e, a                                       ; $4F9B
    ld d, $00                                     ; $4F9C
    ld hl, LinkPick_LoadIcon_Gfx4FB3              ; $4F9E
    add hl, de                                    ; $4FA1
    ld e, [hl]                                    ; $4FA2
    inc hl                                        ; $4FA3
    ld d, [hl]                                    ; $4FA4
    inc hl                                        ; $4FA5
    ld a, [hl]                                    ; $4FA6
    ld h, d                                       ; $4FA7
    ld l, e                                       ; $4FA8
    ld de, $8b00                                  ; $4FA9
    ld bc, $0100                                  ; $4FAC
    call Vram_CopyFromBank                        ; $4FAF
    ret                                           ; $4FB2


; C: auto: 21 bytes, tile data; referenced by LinkPick_LoadIcon. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: icon tiles copied by LinkPick_LoadIcon
LinkPick_LoadIcon_Gfx4FB3::
    dwb Gfx_13_6800_Icon04_44DC
    dwb Gfx_13_6900_Icon04_44DC
    dwb Gfx_13_6A00_Icon04_44DC

    db $00, $6b, $13

    dwb Gfx_13_6C00_Icon04_44DC
    dwb Gfx_13_6D00_Icon04_44DC
    dwb Gfx_13_6E00_Icon04_44DC

; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_LoadPhotoIndex::
    ld a, [wPhotoIndex]                           ; $4FC8

; C: L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_PageTilesRight::
    push af                                       ; $4FCB
    and $18                                       ; $4FCC
    sla a                                         ; $4FCE
    ld c, a                                       ; $4FD0
    ld b, $00                                     ; $4FD1
    ld hl, Gfx_13_5830_PhotoPicker_LoadPageTabsFor ; $4FD3
    add hl, bc                                    ; $4FD6
    ld a, BANK(Gfx_13_5830_PhotoPicker_LoadPageTabsFor) ; $4FD7
    ld de, $8df0                                  ; $4FD9
    ld bc, $0010                                  ; $4FDC
    call Vram_CopyFromBank                        ; $4FDF
    pop af                                        ; $4FE2
    and $20                                       ; $4FE3
    srl a                                         ; $4FE5
    ld c, a                                       ; $4FE7
    ld b, $00                                     ; $4FE8
    ld hl, Gfx_13_5800_Mode0F_State00_Init        ; $4FEA
    add hl, bc                                    ; $4FED
    ld a, BANK(Gfx_13_5800_Mode0F_State00_Init)   ; $4FEE
    ld de, $8de0                                  ; $4FF0
    ld bc, $0010                                  ; $4FF3
    call Vram_CopyFromBank                        ; $4FF6
    ret                                           ; $4FF9


; I: entry of arbitrary address (README 16.14)
Unused_LinkPick_LoadPhotoIndexB::
    ld a, [wPhotoIndex]                           ; $4FFA

; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; loads the two page-tab tiles of the left page from 13:5800 / 13:5830 (LinkPick_PageTurnNext / Prev)
LinkPick_PageTilesLeft::
    push af                                       ; $4FFD
    and $18                                       ; $4FFE
    sla a                                         ; $5000
    ld c, a                                       ; $5002
    ld b, $00                                     ; $5003
    ld hl, Gfx_13_5830_PhotoPicker_LoadPageTabsFor ; $5005
    add hl, bc                                    ; $5008
    ld a, BANK(Gfx_13_5830_PhotoPicker_LoadPageTabsFor) ; $5009
    ld de, $8ed0                                  ; $500B
    ld bc, $0010                                  ; $500E
    call Vram_CopyFromBank                        ; $5011
    pop af                                        ; $5014
    and $20                                       ; $5015
    srl a                                         ; $5017
    ld c, a                                       ; $5019
    ld b, $00                                     ; $501A
    ld hl, Gfx_13_5800_Mode0F_State00_Init        ; $501C
    add hl, bc                                    ; $501F
    ld a, BANK(Gfx_13_5800_Mode0F_State00_Init)   ; $5020
    ld de, $8ec0                                  ; $5022
    ld bc, $0010                                  ; $5025
    call Vram_CopyFromBank                        ; $5028
    ret                                           ; $502B


; C
LinkPick_PageTurnNext::
    ld a, [wPickerCursorTarget]                   ; $502C
    call LinkPick_PageTilesLeft                   ; $502F
    farcopy Vram_CopyFromBank, Map_27_5C10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $5032
    rst Rst08_WaitVBlank                          ; $5040
    ld a, [wPickerCursorTarget]                   ; $5041
    call LinkPick_RequestRemotePage               ; $5044
    ld a, [wPickerCursorTarget]                   ; $5047
    call LinkPick_LoadPageThumbs                  ; $504A
    rst Rst08_WaitVBlank                          ; $504D
    farcopy Vram_CopyFromBank, Map_27_5A10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $504E
    rst Rst08_WaitVBlank                          ; $505C
    farcopy Vram_CopyFromBank, Map_27_6010_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $505D
    rst Rst08_WaitVBlank                          ; $506B
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $506C
    rst Rst08_WaitVBlank                          ; $507A
    farcopy Vram_CopyFromBank, Map_27_5E10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $507B
    rst Rst08_WaitVBlank                          ; $5089
    ld a, [wPickerCursorTarget]                   ; $508A
    call LinkPick_PageTilesRight                  ; $508D
    farcopy Vram_CopyFromBank, Map_24_5500_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $5090
    rst Rst08_WaitVBlank                          ; $509E
    ret                                           ; $509F


; C
LinkPick_PageTurnPrev::
    ld a, [wPickerCursorTarget]                   ; $50A0
    call LinkPick_PageTilesLeft                   ; $50A3
    farcopy Vram_CopyFromBank, Map_27_5E10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $50A6
    rst Rst08_WaitVBlank                          ; $50B4
    ld a, [wPickerCursorTarget]                   ; $50B5
    call LinkPick_PageTilesRight                  ; $50B8
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $50BB
    rst Rst08_WaitVBlank                          ; $50C9
    farcopy Vram_CopyFromBank, Map_27_6010_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $50CA
    rst Rst08_WaitVBlank                          ; $50D8
    farcopy Vram_CopyFromBank, Map_27_5A10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $50D9
    rst Rst08_WaitVBlank                          ; $50E7
    farcopy Vram_CopyFromBank, Map_27_5C10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $50E8
    rst Rst08_WaitVBlank                          ; $50F6
    ld a, [wPickerCursorTarget]                   ; $50F7
    call LinkPick_RequestRemotePage               ; $50FA
    ld a, [wPickerCursorTarget]                   ; $50FD
    call LinkPick_LoadPageThumbs                  ; $5100
    rst Rst08_WaitVBlank                          ; $5103
    farcopy Vram_CopyFromBank, Map_24_5500_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $5104
    rst Rst08_WaitVBlank                          ; $5112
    ret                                           ; $5113


; C: carry when photo_index >= link_pick_count
LinkPick_NoPhotoHere::
    ld a, [wPhotoIndex]                           ; $5114
    ld hl, wLinkPickCount                         ; $5117
    cp [hl]                                       ; $511A
    ccf                                           ; $511B
    ret                                           ; $511C


; C: H = $C0 + (A and 7). L3 pass 2026-10-26: executed in BGB in the scenarios link_exchange 0E:03
; (tcrf_check/assets/l3_names/scen_hits*.csv)
LinkPick_ThumbBufferAddress::
    and $07                                       ; $511D
    add $c0                                       ; $511F
    ld h, a                                       ; $5121
    ld l, $00                                     ; $5122
    xor a                                         ; $5124
    ret                                           ; $5125


; I: asks the peer for a page of thumbnails (Link_QueuePageRequest)
LinkPick_RequestRemotePage::
    push af                                       ; $5126
    ld a, [wSavedDc52]                            ; $5127
    and a                                         ; $512A
    jr nz, jr_007_5139                            ; $512B

    pop af                                        ; $512D
    ldh [hFarcallAArg], a                         ; $512E
    farcall Album_LoadThumbPage_Far               ; $5130
    ret                                           ; $5138


jr_007_5139:
    pop af                                        ; $5139
    srl a                                         ; $513A
    srl a                                         ; $513C
    srl a                                         ; $513E
    ld [wLnkSlot], a                              ; $5140
    call Link_QueuePageRequest                    ; $5143
    ld a, $b4                                     ; $5146
    ld [wLinkTimeout], a                          ; $5148
    xor a                                         ; $514B
    ld [wLinkTimeout + $1], a                     ; $514C

jr_007_514f:
    ldh [hFarcallAArg], a                         ; $514F
    ld a, $07                                     ; $5151
    ld hl, Link_TimeoutTick                       ; $5153
    call Far_Call                                 ; $5156
    jr nz, jr_007_5166                            ; $5159

    ld a, $0c                                     ; $515B
    ld [wResultMsgId], a                          ; $515D
    set_state STATE_0E_RESULT_PREPARE             ; $5160
    ret                                           ; $5165


jr_007_5166:
    rst Rst08_WaitVBlank                          ; $5166
    ld a, [wLnkHalfDone]                          ; $5167
    and a                                         ; $516A
    jr z, jr_007_514f                             ; $516B

    ret                                           ; $516D


; C: mode 2 VIEW menu: Left/Right choice -> album grid (mode 0A) or slide-show menu (mode 0B)
Mode02_ViewMenu::
    ld a, [wState]                                ; $516E
    rst Rst18_JumpTable                           ; $5171

; I: 3 states, rst $18 table of mode $02
Mode02_StateTable::
    dw Mode02_State00_Init
    dw Mode02_State01_Choose
    dw Mode02_State02_Leave

; C
Mode02_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $5178
    ldh [hLcdcShadow], a                          ; $517A
    ld a, $e4                                     ; $517C
    ld [wPaletteTarget], a                        ; $517E
    ld [wPaletteTarget + $1], a                   ; $5181
    ld a, $d2                                     ; $5184
    ld [wPaletteTarget + $2], a                   ; $5186
    xor a                                         ; $5189
    ldh [hScxShadow], a                           ; $518A
    ldh [hScyShadow], a                           ; $518C
    ld [wBgAnimFrame], a                          ; $518E
    ld a, $07                                     ; $5191
    ld [wBgAnimMask], a                           ; $5193
    ld a, $13                                     ; $5196
    ld hl, Gfx_13_4000_Mode02_State00_Init        ; $5198
    ld de, $9000                                  ; $519B
    ld bc, $0800                                  ; $519E
    call Mem_CopyFromBank                         ; $51A1
    farcopy Mem_CopyFromBank, Gfx_13_4800_Mode02_State00_Init, $8800, $0800 ; $51A4
    farcopy Mem_CopyFromBank, Gfx_13_5000_Mode02_State00_Init, $8000, $0800 ; $51B2
    farcopy Mem_CopyFromBank, Map_26_5340_Mode02_State00_Init, $9800, $02c0 ; $51C0
    ld a, $50                                     ; $51CE
    ldh [hLycShadowSplit1], a                     ; $51D0
    ldh [hSplit2Line], a                          ; $51D2
    ld hl, hStatShadow                            ; $51D4
    set 6, [hl]                                   ; $51D7
    ld hl, rIE                                    ; $51D9
    set 1, [hl]                                   ; $51DC
    ld a, $01                                     ; $51DE
    ldh [hStatHandlerIndex], a                    ; $51E0
    screen_on                                     ; $51E2
    play_music MUSIC_VIEW_MENU                    ; $51EB
    call Pal_FadeIn                               ; $51F2
    next_state                                    ; $51F5
    ret                                           ; $51F9


; C
Mode02_State01_Choose::
    call ViewMenu_AnimateBackground               ; $51FA
    call ViewMenu_ReadChoice                      ; $51FD
    call ViewMenu_DrawCursor                      ; $5200
    ldh a, [hKeysNew]                             ; $5203
    and PADF_A | PADF_B                           ; $5205
    ret z                                         ; $5207

    ld [wAbResult], a                             ; $5208
    push af                                       ; $520B
    bit 0, a                                      ; $520C
    ld a, SFX1_CHOOSE_C                           ; $520E
    call nz, Snd_Sfx1                             ; $5210
    pop af                                        ; $5213
    push af                                       ; $5214
    bit 1, a                                      ; $5215
    ld a, SFX1_KEY_B                              ; $5217
    call nz, Snd_Sfx1                             ; $5219
    pop af                                        ; $521C
    next_state                                    ; $521D
    ret                                           ; $5221


; C: mode := table 07:52E5 [choice]
Mode02_State02_Leave::
    ld a, [wAbResult]                             ; $5222
    bit 0, a                                      ; $5225
    jr nz, jr_007_5244                            ; $5227

    screen_off                                    ; $5229
    stat_irq_off                                  ; $522F
    ld a, MODE_MAIN_MENU                          ; $5239
    ld [wMode], a                                 ; $523B
    set_state STATE_00_INIT                       ; $523E
    ret                                           ; $5243


jr_007_5244:
    ld a, [wYesnoH]                               ; $5244
    ld e, a                                       ; $5247
    ld d, $00                                     ; $5248
    ld hl, ViewMenu_TargetModeTbl                 ; $524A
    add hl, de                                    ; $524D
    ld a, [hl]                                    ; $524E
    cp MODE_NONE                                  ; $524F
    jr nz, jr_007_5258                            ; $5251

    ld hl, wState                                 ; $5253
    dec [hl]                                      ; $5256
    ret                                           ; $5257


jr_007_5258:
    ld [wMode], a                                 ; $5258
    set_state STATE_02_INIT                       ; $525B
    ld b, $18                                     ; $5260

jr_007_5262:
    push bc                                       ; $5262
    call ViewMenu_DrawCursorOnce                  ; $5263
    ld a, [wYesnoH]                               ; $5266
    and a                                         ; $5269
    jr nz, jr_007_527e                            ; $526A

    ld a, $fc                                     ; $526C
    ld hl, $98e1                                  ; $526E
    call Vram_WriteByteSafe                       ; $5271
    ld a, $fd                                     ; $5274
    ld hl, $98e2                                  ; $5276
    call Vram_WriteByteSafe                       ; $5279
    jr jr_007_528e                                ; $527C

jr_007_527e:
    ld a, $fc                                     ; $527E
    ld hl, $98f1                                  ; $5280
    call Vram_WriteByteSafe                       ; $5283
    ld a, $fd                                     ; $5286
    ld hl, $98f2                                  ; $5288
    call Vram_WriteByteSafe                       ; $528B

jr_007_528e:
    call Oam_HideUnused                           ; $528E
    rst Rst08_WaitVBlank                          ; $5291
    pop bc                                        ; $5292
    dec b                                         ; $5293
    jr nz, jr_007_5262                            ; $5294

    screen_off                                    ; $5296
    stat_irq_off                                  ; $529C
    ret                                           ; $52A6


; C: $0A; $0B
ViewMenu_TargetModeTbl::
    db MODE_ALBUM_VIEW, MODE_SHOW_MENU

; C: Left/Right toggles D5EC
ViewMenu_ReadChoice::
    ldh a, [hKeysNew]                             ; $52A9
    bit PADB_LEFT, a                              ; $52AB
    jr z, jr_007_52b2                             ; $52AD

    xor a                                         ; $52AF
    jr jr_007_52b8                                ; $52B0

jr_007_52b2:
    bit 4, a                                      ; $52B2
    jr z, jr_007_52c6                             ; $52B4

    ld a, $01                                     ; $52B6

jr_007_52b8:
    ld hl, wYesnoH                                ; $52B8
    cp [hl]                                       ; $52BB
    jr z, jr_007_52c6                             ; $52BC

    ld [hl], a                                    ; $52BE
    play_sfx1 SFX1_CURSOR_MOVE                    ; $52BF

jr_007_52c6:
    ldh a, [hKeysHeld]                            ; $52C6
    ld b, a                                       ; $52C8
    ld a, $07                                     ; $52C9
    bit 6, b                                      ; $52CB
    jr z, jr_007_52d3                             ; $52CD

    ld a, $03                                     ; $52CF
    jr jr_007_52d9                                ; $52D1

jr_007_52d3:
    bit 7, b                                      ; $52D3
    jr z, jr_007_52d9                             ; $52D5

    ld a, $0f                                     ; $52D7

jr_007_52d9:
    ld [wBgAnimMask], a                           ; $52D9
    ret                                           ; $52DC


; C
ViewMenu_DrawCursor::
    ld a, [wYesnoH]                               ; $52DD
    sla a                                         ; $52E0
    ld c, a                                       ; $52E2
    ld b, $00                                     ; $52E3
    ld hl, ViewMenu_DrawCursor_Tbl5302            ; $52E5
    add hl, bc                                    ; $52E8
    ld c, [hl]                                    ; $52E9
    inc hl                                        ; $52EA
    ld b, [hl]                                    ; $52EB
    ldh a, [hFrameCounter]                        ; $52EC
    srl a                                         ; $52EE
    srl a                                         ; $52F0
    srl a                                         ; $52F2
    and $03                                       ; $52F4
    ld e, a                                       ; $52F6
    ld d, $00                                     ; $52F7
    ld hl, ViewMenu_DrawCursor_PtrTbl5306         ; $52F9
    add hl, de                                    ; $52FC
    ld a, [hl]                                    ; $52FD
    call Oam_AddMeta_B02_52BD                     ; $52FE
    ret                                           ; $5301


; C: auto: 4 bytes, bytes; referenced by ViewMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the
; organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursor_Tbl5302::
    db $54, $09, $54, $89

; C: auto: 4 bytes, word table; referenced by ViewMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 35 replay(s) of
; the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursor_PtrTbl5306::
    dw $7577
    dw $7578

; C: L3 pass 2026-10-26: executed in BGB in 33 replay(s) of the organic corpus, modes 0A (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursorOnce::
    ld a, [wYesnoH]                               ; $530A
    sla a                                         ; $530D
    ld c, a                                       ; $530F
    ld b, $00                                     ; $5310
    ld hl, ViewMenu_DrawCursorOnce_Tbl5327        ; $5312
    add hl, bc                                    ; $5315
    ld c, [hl]                                    ; $5316
    inc hl                                        ; $5317
    ld b, [hl]                                    ; $5318
    ld a, $76                                     ; $5319
    call Oam_AddMeta_B02_52BD                     ; $531B
    dec b                                         ; $531E
    ld c, $50                                     ; $531F
    ld a, $79                                     ; $5321
    call Oam_AddMeta_B02_52BD                     ; $5323
    ret                                           ; $5326


; C: auto: 4 bytes, bytes; referenced by ViewMenu_DrawCursorOnce. L3 pass 2026-10-26: read in BGB in 33 replay(s) of
; the organic corpus, modes 0A (tcrf_check/assets/l3_names/)
ViewMenu_DrawCursorOnce_Tbl5327::
    db $53, $09, $53, $89

; C: speed set at 07:5304 from Up/Down (README 16.18)
ViewMenu_AnimateBackground::
    ldh a, [hFrameCounter]                        ; $532B
    ld hl, wBgAnimMask                            ; $532D
    and [hl]                                      ; $5330
    ret nz                                        ; $5331

    ld a, [wYesnoH]                               ; $5332
    and a                                         ; $5335
    jr nz, jr_007_5343                            ; $5336

    ld a, [wBgAnimFrame]                          ; $5338
    inc a                                         ; $533B
    and $07                                       ; $533C
    ld [wBgAnimFrame], a                          ; $533E
    jr jr_007_534c                                ; $5341

jr_007_5343:
    ld a, [wBgAnimFrame]                          ; $5343
    dec a                                         ; $5346
    and $07                                       ; $5347
    ld [wBgAnimFrame], a                          ; $5349

jr_007_534c:
    ld c, a                                       ; $534C
    sla a                                         ; $534D
    add c                                         ; $534F
    ld c, a                                       ; $5350
    ld b, $00                                     ; $5351
    ld hl, ViewMenu_AnimateBackground_Map5368     ; $5353
    add hl, bc                                    ; $5356
    ld c, [hl]                                    ; $5357
    inc hl                                        ; $5358
    ld b, [hl]                                    ; $5359
    inc hl                                        ; $535A
    ld a, [hl]                                    ; $535B
    ld h, b                                       ; $535C
    ld l, c                                       ; $535D
    ld de, $9840                                  ; $535E
    ld bc, $0180                                  ; $5361
    call Vram_CopyFromBank                        ; $5364
    ret                                           ; $5367


; I: auto: 24 bytes, tile map; referenced by ViewMenu_AnimateBackground. L3 pass 2026-10-26: read in BGB in 35
; replay(s) of the organic corpus, modes 02 (tcrf_check/assets/l3_names/)
ViewMenu_AnimateBackground_Map5368::
    dwb Src_26_5380_Tbl53A6_0
    dwb Src_27_6A50_Tbl53A6_1
    dwb Src_27_6BD0_Tbl53A6_2
    dwb Src_23_7E80_Tbl53A6_3
    dwb Src_19_7E60_Tbl53A6_4
    dwb Src_27_6D50_Tbl53A6_5
    dwb Src_27_68D0_Tbl53A6_6
    dwb Src_27_6750_Tbl53A6_7

; C: mode 3 Special menu: vertical 2-way choice -> mode 1A or 17
Mode03_SpecialMenu::
    ld a, [wState]                                ; $5380
    rst Rst18_JumpTable                           ; $5383

; I: 3 states, rst $18 table of mode $03
Mode03_StateTable::
    dw Mode03_State00_Init
    dw Mode03_State01_Choose
    dw Mode03_State02_Leave

; C
Mode03_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $538A
    ldh [hLcdcShadow], a                          ; $538C
    ld a, $e4                                     ; $538E
    ld [wPaletteTarget], a                        ; $5390
    ld a, $d2                                     ; $5393
    ld [wPaletteTarget + $1], a                   ; $5395
    ld [wPaletteTarget + $2], a                   ; $5398
    xor a                                         ; $539B
    ldh [hScxShadow], a                           ; $539C
    ldh [hScyShadow], a                           ; $539E
    ld a, $12                                     ; $53A0
    ld hl, Gfx_12_7000_Mode03_State00_Init        ; $53A2
    ld de, $9000                                  ; $53A5
    ld bc, $0800                                  ; $53A8
    call Mem_CopyFromBank                         ; $53AB
    farcopy Mem_CopyFromBank, Gfx_12_7800_Mode03_State00_Init, $8800, $0780 ; $53AE
    farcopy Mem_CopyFromBank, Map_23_64C0_Mode03_State00_Init, $9800, $0240 ; $53BC
    screen_on                                     ; $53CA
    play_music MUSIC_SPECIAL_MENU                 ; $53D3
    call SpecialMenu_DrawCursor                   ; $53DA
    call Pal_FadeIn                               ; $53DD
    next_state                                    ; $53E0
    ret                                           ; $53E4


; C
Mode03_State01_Choose::
    call SpecialMenu_ReadChoice                   ; $53E5
    ldh a, [hFrameCounter]                        ; $53E8
    bit 4, a                                      ; $53EA
    call SpecialMenu_DrawCursor                   ; $53EC
    ldh a, [hKeysNew]                             ; $53EF
    and PADF_A | PADF_B                           ; $53F1
    ret z                                         ; $53F3

    ld [wAbResult], a                             ; $53F4
    push af                                       ; $53F7
    bit 0, a                                      ; $53F8
    ld a, SFX1_CHOOSE                             ; $53FA
    call nz, Snd_Sfx1                             ; $53FC
    pop af                                        ; $53FF
    push af                                       ; $5400
    bit 1, a                                      ; $5401
    ld a, SFX1_KEY_B                              ; $5403
    call nz, Snd_Sfx1                             ; $5405
    pop af                                        ; $5408
    next_state                                    ; $5409
    ret                                           ; $540D


; C
Mode03_State02_Leave::
    ld a, [wAbResult]                             ; $540E
    bit 0, a                                      ; $5411
    jr nz, jr_007_5426                            ; $5413

    ld a, MODE_MAIN_MENU                          ; $5415
    ld [wMode], a                                 ; $5417
    set_state STATE_00_INIT                       ; $541A
    screen_off                                    ; $541F
    ret                                           ; $5425


jr_007_5426:
    ld a, [wYesnoV7]                              ; $5426
    ld e, a                                       ; $5429
    ld d, $00                                     ; $542A
    ld hl, SpecialMenu_TargetModeTbl              ; $542C
    add hl, de                                    ; $542F
    ld a, [hl]                                    ; $5430
    cp MODE_NONE                                  ; $5431
    jr nz, jr_007_543a                            ; $5433

    ld hl, wState                                 ; $5435
    dec [hl]                                      ; $5438
    ret                                           ; $5439


jr_007_543a:
    ld [wMode], a                                 ; $543A
    xor a                                         ; $543D
    ld [wState], a                                ; $543E
    ld b, $14                                     ; $5441

jr_007_5443:
    push bc                                       ; $5443
    ldh a, [hFrameCounter]                        ; $5444
    bit 2, a                                      ; $5446
    call SpecialMenu_DrawCursor                   ; $5448
    rst Rst08_WaitVBlank                          ; $544B
    pop bc                                        ; $544C
    dec b                                         ; $544D
    jr nz, jr_007_5443                            ; $544E

    screen_off                                    ; $5450
    ret                                           ; $5456


; C: $1A; $17
SpecialMenu_TargetModeTbl::
    db MODE_HOT_SPOT_EDITOR, MODE_SPLIT_FUSION

; C: Up/Down toggles D5FE
SpecialMenu_ReadChoice::
    ldh a, [hKeysNewRepeat]                       ; $5459
    ld b, a                                       ; $545B
    ld a, [wYesnoV7]                              ; $545C
    bit 6, b                                      ; $545F
    jr z, jr_007_5468                             ; $5461

    and a                                         ; $5463
    ret z                                         ; $5464

    dec a                                         ; $5465
    jr jr_007_546f                                ; $5466

jr_007_5468:
    bit 7, b                                      ; $5468
    ret z                                         ; $546A

    cp $01                                        ; $546B
    ret z                                         ; $546D

    inc a                                         ; $546E

jr_007_546f:
    ld [wYesnoV7], a                              ; $546F
    play_sfx1 SFX1_CURSOR_MOVE                    ; $5472
    ret                                           ; $5479


; C
SpecialMenu_DrawCursor::
    jr z, jr_007_548b                             ; $547A

    farcopy Vram_CopyFromBank, Map_23_67E0_SpecialMenu_DrawCursor, $9820, $00e0 ; $547C
    ret                                           ; $548A


jr_007_548b:
    ld a, [wYesnoV7]                              ; $548B
    and a                                         ; $548E
    jr nz, jr_007_54a0                            ; $548F

    farcopy Vram_CopyFromBank, Map_23_64E0_SpecialMenu_DrawCursor, $9820, $00e0 ; $5491
    ret                                           ; $549F


jr_007_54a0:
    farcopy Vram_CopyFromBank, Map_23_6700_SpecialMenu_DrawCursor, $9820, $00e0 ; $54A0
    ret                                           ; $54AE


; C: mode 7: Space Fever II (README 2.7)
Mode07_ArcadeSpaceFever::
    ld a, [wState]                                ; $54AF
    rst Rst18_JumpTable                           ; $54B2

; I: 9 states, rst $18 table of mode $07
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $54C5
    ldh [hLcdcShadow], a                          ; $54C7
    ld a, $e4                                     ; $54C9
    ld [wPaletteTarget], a                        ; $54CB
    ld [wPaletteTarget + $1], a                   ; $54CE
    ld [wPaletteTarget + $2], a                   ; $54D1
    xor a                                         ; $54D4
    ldh [hScxShadow], a                           ; $54D5
    ldh [hScyShadow], a                           ; $54D7
    ld [wShootScoreBcd], a                        ; $54D9
    ld [wShootScoreBcd + $1], a                   ; $54DC
    ld [wShootScoreBcd + $2], a                   ; $54DF
    ld [wShootScoreBcd + $3], a                   ; $54E2
    ld [wShootWaveState], a                       ; $54E5
    ldh [hFarcallAArg], a                         ; $54E8
    farcall Counters_Load_Far                     ; $54EA
    ld a, $21                                     ; $54F2
    ld hl, Gfx_21_4000_Mode07_State00_Init        ; $54F4
    ld de, $9000                                  ; $54F7
    ld bc, $0800                                  ; $54FA
    call Mem_CopyFromBank                         ; $54FD
    farcopy Mem_CopyFromBank, Gfx_21_4800_Mode07_State00_Init, $8800, $0400 ; $5500
    farcopy Mem_CopyFromBank, Map_25_55C0_Mode07_State00_Init, $9800, $0240 ; $550E
    ldh [hFarcallAArg], a                         ; $551C
    farcall GameFace_LoadTiles_Far                ; $551E
    screen_on                                     ; $5526
    xor a                                         ; $552F
    call SpaceFever_AddScore                      ; $5530
    call Pal_FadeIn                               ; $5533
    next_state                                    ; $5536
    ret                                           ; $553A


; C: music $31; field and sprites reset
Mode07_State01_Start::
    play_music MUSIC_SPACE_FEVER_START            ; $553B
    call SpaceFever_ResetGame                     ; $5542
    xor a                                         ; $5545
    call SpaceFever_AddScore                      ; $5546
    ld a, [wShootWaveState]                       ; $5549
    ld a, $00                                     ; $554C
    ld [wShootWaveState], a                       ; $554E
    call Anim_ClearSlots                          ; $5551
    call SpaceFever_LoadHudTiles                  ; $5554
    ld b, $64                                     ; $5557

jr_007_5559:
    ldh a, [hKeysNew]                             ; $5559
    bit PADB_B, a                                 ; $555B
    jr nz, jr_007_5576                            ; $555D

    push bc                                       ; $555F
    call SpaceFever_UpdateStars                   ; $5560
    call Oam_HideUnused                           ; $5563
    rst Rst08_WaitVBlank                          ; $5566
    pop bc                                        ; $5567
    dec b                                         ; $5568
    jr nz, jr_007_5559                            ; $5569

    call SpaceFever_DrawChoiceText                ; $556B
    call SpaceFever_UpdateStars                   ; $556E
    next_state                                    ; $5571
    ret                                           ; $5575


jr_007_5576:
    set_state STATE_07_LEAVE                      ; $5576
    ret                                           ; $557B


; C: player; shot; wave; stars; hit by enemy -> state 3
Mode07_State02_Play::
    call SpaceFever_MovePlayer                    ; $557C
    call SpaceFever_DrawPlayer                    ; $557F
    ld a, [wSpriteAnimFrame]                      ; $5582
    cp $02                                        ; $5585
    call c, SpaceFever_FireShots                  ; $5587
    call SpaceFever_DrawShots                     ; $558A
    call SpaceFever_DrawHitFlash                  ; $558D
    call SpaceFever_WaveStep                      ; $5590
    ld a, [wShootWaveState]                       ; $5593
    cp $09                                        ; $5596
    jr nz, jr_007_559f                            ; $5598

    call SpaceFever_Collide_Boss                  ; $559A
    jr jr_007_55a5                                ; $559D

jr_007_559f:
    call SpaceFever_Collide_Waves                 ; $559F
    call SpaceFever_UpdateStars                   ; $55A2

jr_007_55a5:
    ldh a, [hKeysNew]                             ; $55A5
    bit PADB_START, a                             ; $55A7
    jr z, jr_007_55cf                             ; $55A9

    ld a, [wSpriteAnimFrame + $2]                 ; $55AB
    cp $05                                        ; $55AE
    ret nc                                        ; $55B0

    call Oam_HideUnused                           ; $55B1
    rst Rst08_WaitVBlank                          ; $55B4
    call SpaceFever_UpdateStars                   ; $55B5
    call Oam_HideUnused                           ; $55B8
    rst Rst08_WaitVBlank                          ; $55BB
    call SpaceFever_UpdateStars                   ; $55BC
    call SpaceFever_DrawBestHud                   ; $55BF
    xor a                                         ; $55C2
    ld [wShootChoice], a                          ; $55C3
    ld [wShootChoiceBob], a                       ; $55C6
    set_state STATE_07_TARGET_MENU_B              ; $55C9
    ret                                           ; $55CE


jr_007_55cf:
    bit 1, a                                      ; $55CF
    jr z, jr_007_55ef                             ; $55D1

    ld a, [wSpriteAnimFrame]                      ; $55D3
    cp $02                                        ; $55D6
    ret nc                                        ; $55D8

    ld a, $02                                     ; $55D9
    ld [wSpriteAnimFrame], a                      ; $55DB
    xor a                                         ; $55DE
    ld [wSpriteAnimTick], a                       ; $55DF
    play_sfx1 SFX1_SPACE_FEVER_PLAYER_DEATH_JINGLE ; $55E2
    ld a, $01                                     ; $55E9
    ld [wShootPlayerDied], a                      ; $55EB
    ret                                           ; $55EE


jr_007_55ef:
    ld a, [wSpriteAnimFrame]                      ; $55EF
    cp $0b                                        ; $55F2
    ret nz                                        ; $55F4

    ld a, [wShootWaveState]                       ; $55F5
    cp $09                                        ; $55F8
    jr nz, jr_007_5602                            ; $55FA

    ld a, [wSpriteAnimFrame + $2]                 ; $55FC
    cp $03                                        ; $55FF
    ret nc                                        ; $5601

jr_007_5602:
    call SpaceFever_DrawGameOverHud               ; $5602
    xor a                                         ; $5605
    ld [wShootChoice], a                          ; $5606
    ld [wShootChoiceBob], a                       ; $5609
    set_state STATE_07_TARGET_MENU_A              ; $560C
    ret                                           ; $5611


; C: game over: choice menu (wave still drawn). L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
Mode07_State03_TargetMenuA::
    call SpaceFever_DrawShots                     ; $5612
    call SpaceFever_WaveStep                      ; $5615
    call SpaceFever_ReadChoice                    ; $5618
    call SpaceFever_DrawChoiceCursor              ; $561B
    ld a, [wShootWaveState]                       ; $561E
    cp $09                                        ; $5621
    call nz, SpaceFever_UpdateStars               ; $5623
    ldh a, [hKeysNew]                             ; $5626
    bit PADB_START, a                             ; $5628
    jr nz, jr_007_5639                            ; $562A

    bit PADB_B, a                                 ; $562C
    jr nz, jr_007_5645                            ; $562E

    bit PADB_A, a                                 ; $5630
    ret z                                         ; $5632

    ld a, [wShootChoice]                          ; $5633
    and a                                         ; $5636
    jr nz, jr_007_5645                            ; $5637

jr_007_5639:
    call Oam_ClearShadow                          ; $5639
    call SpaceFever_DrawChoiceText                ; $563C
    set_state STATE_07_START                      ; $563F
    ret                                           ; $5644


jr_007_5645:
    set_state STATE_07_LEAVE                      ; $5645
    ret                                           ; $564A


; C: choice menu (Up/Down; A = go; B = leave). L3 pass 2026-10-26: executed in BGB in 11 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
Mode07_State04_TargetMenuB::
    call SpaceFever_ReadChoice                    ; $564B
    call SpaceFever_DrawChoiceCursor              ; $564E
    call SpaceFever_UpdateStars                   ; $5651
    ldh a, [hKeysNew]                             ; $5654
    bit PADB_START, a                             ; $5656
    jr nz, jr_007_5663                            ; $5658

    bit PADB_A, a                                 ; $565A
    ret z                                         ; $565C

    ld a, [wShootChoice]                          ; $565D
    and a                                         ; $5660
    jr nz, jr_007_567b                            ; $5661

jr_007_5663:
    play_sfx1 SFX1_KEY_B                          ; $5663
    call Oam_ClearShadow                          ; $566A
    call SpaceFever_DrawChoiceText                ; $566D
    ld c, $02                                     ; $5670
    call z, SpaceFever_LoadBossTilesC             ; $5672
    set_state STATE_07_PLAY                       ; $5675
    ret                                           ; $567A


jr_007_567b:
    play_sfx1 SFX1_SPACE_FEVER_MENU_PICK_GAME     ; $567B
    set_state STATE_07_LEAVE                      ; $5682
    ret                                           ; $5687


; C: mode := $1F
Mode07_State05_GotoDj::
    call SpaceFever_UpdateStars                   ; $5688
    ld a, MODE_DJ_EDITOR                          ; $568B
    ld [wMode], a                                 ; $568D
    set_state STATE_1F_TITLE_INIT                 ; $5690
    ldh [hFarcallAArg], a                         ; $5695
    farcall Counters_Store_Far                    ; $5697
    screen_off                                    ; $569F
    ret                                           ; $56A5


; C: mode := $20
Mode07_State06_GotoBall::
    call SpaceFever_UpdateStars                   ; $56A6
    ld a, MODE_BALL                               ; $56A9
    ld [wMode], a                                 ; $56AB
    set_state STATE_20_MENU_INIT                  ; $56AE
    ldh [hFarcallAArg], a                         ; $56B3
    farcall Counters_Store_Far                    ; $56B5
    screen_off                                    ; $56BD
    ret                                           ; $56C3


; C: mode := $21
Mode07_State07_GotoRun::
    call SpaceFever_UpdateStars                   ; $56C4
    ld a, MODE_RUN_RUN_RUN                        ; $56C7
    ld [wMode], a                                 ; $56C9
    set_state STATE_21_INIT                       ; $56CC
    ldh [hFarcallAArg], a                         ; $56D1
    farcall Counters_Store_Far                    ; $56D3
    screen_off                                    ; $56DB
    ret                                           ; $56E1


; C: sprite $60 with bob (5747/5749)
SpaceFever_DrawChoiceCursor::
    ld a, [wShootChoice]                          ; $56E2
    ld e, a                                       ; $56E5
    ld d, $00                                     ; $56E6
    ld hl, SpaceFever_ChoiceCursorXTbl            ; $56E8
    add hl, de                                    ; $56EB
    ld b, [hl]                                    ; $56EC
    ld a, [wShootChoiceBob]                       ; $56ED
    ld e, a                                       ; $56F0
    inc a                                         ; $56F1
    cp $0c                                        ; $56F2
    jr nz, jr_007_56f7                            ; $56F4

    xor a                                         ; $56F6

jr_007_56f7:
    ld [wShootChoiceBob], a                       ; $56F7
    ld hl, SpaceFever_DrawChoiceCursor_Tbl570B    ; $56FA
    add hl, de                                    ; $56FD
    ld a, [hl]                                    ; $56FE
    add b                                         ; $56FF
    ld b, a                                       ; $5700
    ld c, $60                                     ; $5701
    ld a, $60                                     ; $5703
    call Oam_AddMeta_B01_5D2B                     ; $5705
    ret                                           ; $5708


; C
SpaceFever_ChoiceCursorXTbl::
    dw $8050

; C: auto: 12 bytes, bytes; referenced by SpaceFever_DrawChoiceCursor. L3 pass 2026-10-26: read in BGB in 12 replay(s)
; of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DrawChoiceCursor_Tbl570B::
    db $00, $04, $08, $0c, $10, $14, $18, $14, $10, $0c, $08, $04

; C: Up/Down changes shoot_choice
SpaceFever_ReadChoice::
    ldh a, [hKeysNew]                             ; $5717
    bit PADB_LEFT, a                              ; $5719
    jr z, jr_007_5720                             ; $571B

    xor a                                         ; $571D
    jr jr_007_5725                                ; $571E

jr_007_5720:
    bit 4, a                                      ; $5720
    ret z                                         ; $5722

    ld a, $01                                     ; $5723

jr_007_5725:
    ld hl, wShootChoice                           ; $5725
    cp [hl]                                       ; $5728
    ret z                                         ; $5729

    ld [hl], a                                    ; $572A
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $572B
    ret                                           ; $5732


; C: Left/Right with limits
SpaceFever_MovePlayer::
    ld a, [wSpriteAnimFrame]                      ; $5733
    cp $02                                        ; $5736
    ret nc                                        ; $5738

    ld a, [wShootPlayerX]                         ; $5739
    ld hl, hKeysHeld                              ; $573C
    bit 5, [hl]                                   ; $573F
    jr z, jr_007_5749                             ; $5741

    and a                                         ; $5743
    ret z                                         ; $5744

    dec a                                         ; $5745
    dec a                                         ; $5746
    jr jr_007_5752                                ; $5747

jr_007_5749:
    bit 4, [hl]                                   ; $5749
    jr z, jr_007_5752                             ; $574B

    cp $50                                        ; $574D
    ret z                                         ; $574F

    inc a                                         ; $5750
    inc a                                         ; $5751

jr_007_5752:
    ld [wShootPlayerX], a                         ; $5752
    ret                                           ; $5755


; C
SpaceFever_DrawPlayer::
    ld a, [wSpriteAnimFrame]                      ; $5756
    sla a                                         ; $5759
    ld c, a                                       ; $575B
    ld b, $00                                     ; $575C
    ld hl, SpaceFever_DrawPlayer_Tbl578C          ; $575E
    add hl, bc                                    ; $5761
    ld a, [hl+]                                   ; $5762
    push af                                       ; $5763
    ld a, [wShootPlayerX]                         ; $5764
    add $48                                       ; $5767
    ld b, a                                       ; $5769
    ld c, $88                                     ; $576A
    pop af                                        ; $576C
    push hl                                       ; $576D
    and a                                         ; $576E
    call nz, Oam_AddMeta_B01_5D2B                 ; $576F
    pop hl                                        ; $5772
    ld a, [wSpriteAnimTick]                       ; $5773
    cp [hl]                                       ; $5776
    jr nz, jr_007_5787                            ; $5777

    inc hl                                        ; $5779
    ld a, [hl+]                                   ; $577A
    inc a                                         ; $577B
    ld a, [hl]                                    ; $577C
    jr z, jr_007_5783                             ; $577D

    ld a, [wSpriteAnimFrame]                      ; $577F
    inc a                                         ; $5782

jr_007_5783:
    ld [wSpriteAnimFrame], a                      ; $5783
    xor a                                         ; $5786

jr_007_5787:
    inc a                                         ; $5787
    ld [wSpriteAnimTick], a                       ; $5788
    ret                                           ; $578B


; C: auto: 26 bytes, bytes; referenced by SpaceFever_DrawPlayer. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DrawPlayer_Tbl578C::
    db $4f, $10, $ff, $00, $50, $04, $51, $04, $52, $04, $53, $04, $52, $04, $53, $04
    db $52, $02, $53, $02, $00, $60, $00, $10, $ff, $0b

; C: single / rapid fire; up to 8 shot slots
SpaceFever_FireShots::
    ld a, [wShootRapidFlag]                       ; $57A6
    and a                                         ; $57A9
    jr nz, jr_007_57fc                            ; $57AA

    ld hl, wShootShotY                            ; $57AC
    ld a, [hl+]                                   ; $57AF
    cp $fc                                        ; $57B0
    ret c                                         ; $57B2

    ld a, [hl+]                                   ; $57B3
    cp $fc                                        ; $57B4
    ret c                                         ; $57B6

    ld a, [hl+]                                   ; $57B7
    cp $fc                                        ; $57B8
    ret c                                         ; $57BA

    ldh a, [hKeysNew]                             ; $57BB
    bit PADB_A, a                                 ; $57BD
    ret z                                         ; $57BF

    ld hl, wShootFireCount                        ; $57C0
    inc [hl]                                      ; $57C3
    bit 0, [hl]                                   ; $57C4
    jr nz, jr_007_57db                            ; $57C6

    ld a, [wShootPlayerX]                         ; $57C8
    ld [wShootShotX], a                           ; $57CB
    ld a, $88                                     ; $57CE
    ld [wShootShotY], a                           ; $57D0
    play_sfx4 SFX4_SPACE_FEVER_FIRE_SHOTS         ; $57D3
    ret                                           ; $57DA


jr_007_57db:
    ld a, [wShootPlayerX]                         ; $57DB
    sub $04                                       ; $57DE
    ld [wShootShotX + $1], a                      ; $57E0
    add $08                                       ; $57E3
    ld [wShootShotX + $2], a                      ; $57E5
    ld a, $88                                     ; $57E8
    ld [wShootShotY + $1], a                      ; $57EA
    ld [wShootShotY + $2], a                      ; $57ED
    xor a                                         ; $57F0
    ld [wShootDoubleHits], a                      ; $57F1
    play_sfx4 SFX4_SPACE_FEVER_FIRE_SHOTS         ; $57F4
    ret                                           ; $57FB


jr_007_57fc:
    ld hl, wShootFireCount                        ; $57FC
    ld a, [hl]                                    ; $57FF
    and $07                                       ; $5800
    ld c, a                                       ; $5802
    ld b, $00                                     ; $5803
    ld hl, wShootShotY                            ; $5805
    add hl, bc                                    ; $5808
    ld a, [hl]                                    ; $5809
    cp $fc                                        ; $580A
    ret c                                         ; $580C

    ldh a, [hKeysHeld]                            ; $580D
    bit PADB_A, a                                 ; $580F
    ret z                                         ; $5811

    ldh a, [hFrameCounter]                        ; $5812
    and $03                                       ; $5814
    ret nz                                        ; $5816

    ld a, [wShootPlayerX]                         ; $5817
    ld hl, wShootShotX                            ; $581A
    add hl, bc                                    ; $581D
    ld [hl], a                                    ; $581E
    ld hl, wShootShotY                            ; $581F
    add hl, bc                                    ; $5822
    ld [hl], $88                                  ; $5823
    ld hl, wShootFireCount                        ; $5825
    inc [hl]                                      ; $5828
    ret                                           ; $5829


; C: sprite $5D; 4 px up per frame
SpaceFever_DrawShots::
    ld de, $0007                                  ; $582A

jr_007_582d:
    ld hl, wShootShotY                            ; $582D
    add hl, de                                    ; $5830
    ld a, [hl]                                    ; $5831
    cp $fc                                        ; $5832
    jr nc, jr_007_584b                            ; $5834

    dec a                                         ; $5836
    dec a                                         ; $5837
    dec a                                         ; $5838
    dec a                                         ; $5839
    ld [hl], a                                    ; $583A
    ld c, a                                       ; $583B
    ld hl, wShootShotX                            ; $583C
    add hl, de                                    ; $583F
    ld a, [hl]                                    ; $5840
    add $48                                       ; $5841
    ld b, a                                       ; $5843
    ld a, $5d                                     ; $5844
    push de                                       ; $5846
    call Oam_AddMeta_B01_5D2B                     ; $5847
    pop de                                        ; $584A

jr_007_584b:
    dec e                                         ; $584B
    bit 7, e                                      ; $584C
    jr z, jr_007_582d                             ; $584E

    ret                                           ; $5850


; C: sprite $61; sound $0E
SpaceFever_DrawHitFlash::
    ld a, [wShootFlashTimer]                      ; $5851
    and a                                         ; $5854
    ret z                                         ; $5855

    dec a                                         ; $5856
    ld [wShootFlashTimer], a                      ; $5857
    cp $23                                        ; $585A
    jr nz, jr_007_5865                            ; $585C

    play_sfx1 SFX1_CHOOSE_D                       ; $585E

jr_007_5865:
    ld a, [wShootFlashXy]                         ; $5865
    add $48                                       ; $5868
    ld b, a                                       ; $586A
    ld a, [wShootFlashXy + $1]                    ; $586B
    ld c, a                                       ; $586E
    ld a, $61                                     ; $586F
    call Oam_AddMeta_B01_5D2B                     ; $5871
    ret                                           ; $5874


; C: background stars; sprite $5E + type
SpaceFever_UpdateStars::
    ld de, $0009                                  ; $5875

jr_007_5878:
    ld hl, wShootStarY                            ; $5878
    add hl, de                                    ; $587B
    ld a, [hl]                                    ; $587C
    cp $d0                                        ; $587D
    jr nc, jr_007_58a6                            ; $587F

    push af                                       ; $5881
    ldh a, [hFrameCounter]                        ; $5882
    or e                                          ; $5884
    ld c, a                                       ; $5885
    pop af                                        ; $5886
    bit 0, c                                      ; $5887
    jr z, jr_007_588d                             ; $5889

    inc a                                         ; $588B
    ld [hl], a                                    ; $588C

jr_007_588d:
    sub $40                                       ; $588D
    ld c, a                                       ; $588F
    ld hl, wShootStarX                            ; $5890
    add hl, de                                    ; $5893
    ld a, [hl]                                    ; $5894
    add $48                                       ; $5895
    ld b, a                                       ; $5897
    ld hl, wShootStarType                         ; $5898
    add hl, de                                    ; $589B
    ld a, [hl]                                    ; $589C
    add $5e                                       ; $589D
    push de                                       ; $589F
    call Oam_AddMeta_B01_5D2B                     ; $58A0
    pop de                                        ; $58A3
    jr jr_007_58cc                                ; $58A4

jr_007_58a6:
    call Rng_Next                                 ; $58A6
    and $0f                                       ; $58A9
    sla a                                         ; $58AB
    sla a                                         ; $58AD
    add $0c                                       ; $58AF
    ld hl, wShootStarX                            ; $58B1
    add hl, de                                    ; $58B4
    ld [hl], a                                    ; $58B5
    call Rng_Next                                 ; $58B6
    and $03                                       ; $58B9
    swap a                                        ; $58BB
    ld hl, wShootStarY                            ; $58BD
    add hl, de                                    ; $58C0
    ld [hl], a                                    ; $58C1
    call Rng_Next                                 ; $58C2
    and $01                                       ; $58C5
    ld hl, wShootStarType                         ; $58C7
    add hl, de                                    ; $58CA
    ld [hl], a                                    ; $58CB

jr_007_58cc:
    dec e                                         ; $58CC
    bit 7, e                                      ; $58CD
    jr z, jr_007_5878                             ; $58CF

    ret                                           ; $58D1


; C: mode := 0
Mode07_State08_Leave::
    ld a, MODE_MAIN_MENU                          ; $58D2
    ld [wMode], a                                 ; $58D4
    set_state STATE_00_INIT                       ; $58D7
    ldh [hFarcallAArg], a                         ; $58DC
    farcall Counters_Store_Far                    ; $58DE
    screen_off                                    ; $58E6
    ret                                           ; $58EC


; C: shots; enemies; score; best score copy
SpaceFever_ResetGame::
    ld a, $28                                     ; $58ED
    ld [wShootPlayerX], a                         ; $58EF
    ld a, $fc                                     ; $58F2
    ld [wShootShotY], a                           ; $58F4
    ld [wShootShotY + $1], a                      ; $58F7
    ld [wShootShotY + $2], a                      ; $58FA
    ld [wShootFlashXy + $1], a                    ; $58FD
    ld a, $a0                                     ; $5900
    ld hl, wShootEnemyY                           ; $5902
    ld b, $03                                     ; $5905

jr_007_5907:
    ld [hl+], a                                   ; $5907
    dec b                                         ; $5908
    jr nz, jr_007_5907                            ; $5909

    ld hl, wShootBulletY                          ; $590B
    ld b, $08                                     ; $590E

jr_007_5910:
    ld [hl+], a                                   ; $5910
    dec b                                         ; $5911
    jr nz, jr_007_5910                            ; $5912

    ld a, $01                                     ; $5914
    ld [wShootFireCount], a                       ; $5916
    xor a                                         ; $5919
    ld [wShootShotX], a                           ; $591A
    ld [wShootShotX + $1], a                      ; $591D
    ld [wShootShotX + $2], a                      ; $5920
    ld [wShootScoreBcd], a                        ; $5923
    ld [wShootScoreBcd + $1], a                   ; $5926
    ld [wShootScoreBcd + $2], a                   ; $5929
    ld [wShootScoreBcd + $3], a                   ; $592C
    ld [wShootNewBestFlag], a                     ; $592F
    ld [wShootPlayerDied], a                      ; $5932
    ld [wShootRound], a                           ; $5935
    ld [wShootBossVariant], a                     ; $5938
    ld [wShootRapidFlag], a                       ; $593B
    ld de, $0009                                  ; $593E

jr_007_5941:
    call Rng_Next                                 ; $5941
    and $38                                       ; $5944
    add $0c                                       ; $5946
    ld hl, wShootStarX                            ; $5948
    add hl, de                                    ; $594B
    ld [hl], a                                    ; $594C
    call Rng_Next                                 ; $594D
    and $c4                                       ; $5950
    ld hl, wShootStarY                            ; $5952
    add hl, de                                    ; $5955
    ld [hl], a                                    ; $5956
    call Rng_Next                                 ; $5957
    and $00                                       ; $595A
    ld hl, wShootStarType                         ; $595C
    add hl, de                                    ; $595F
    ld [hl], a                                    ; $5960
    dec e                                         ; $5961
    bit 7, e                                      ; $5962
    jr z, jr_007_5941                             ; $5964

    ret                                           ; $5966


; C: rst18 over shoot_wave_state
SpaceFever_WaveStep::
    ld a, [wShootWaveState]                       ; $5967
    rst Rst18_JumpTable                           ; $596A

; I: 12 entries: even = init; odd = play (README 2.7)
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
    ld a, $ec                                     ; $5983
    ld [wShootEnemyBaseX], a                      ; $5985
    ld a, $14                                     ; $5988
    ld [wShootEnemyBaseX + $1], a                 ; $598A
    xor a                                         ; $598D
    ld [wShootEnemyBaseX + $2], a                 ; $598E
    ld [wShootEnemyBaseY], a                      ; $5991
    ld [wShootEnemyBaseY + $1], a                 ; $5994
    ld [wShootEnemyBaseY + $2], a                 ; $5997
    ld a, [SpaceFever_Wave0_PathEnd]              ; $599A
    ld [wShootPathEnd], a                         ; $599D
    ld [wShootPathEnd + $1], a                    ; $59A0
    ld [wShootPathEnd + $2], a                    ; $59A3
    ld a, $80                                     ; $59A6
    ld [wShootPathSpeed], a                       ; $59A8
    ld [wShootPathSpeed + $1], a                  ; $59AB
    ld [wShootPathSpeed + $2], a                  ; $59AE
    xor a                                         ; $59B1
    ld [wShootPathMirror], a                      ; $59B2
    ld [wShootPathMirror + $1], a                 ; $59B5
    ld [wShootPathMirror + $2], a                 ; $59B8
    ld a, [wBestShooter + $3]                     ; $59BB
    and a                                         ; $59BE
    jr nz, jr_007_59d3                            ; $59BF

    ld a, [wBestShooter + $2]                     ; $59C1
    and a                                         ; $59C4
    jr nz, jr_007_59d3                            ; $59C5

    ld a, [wBestShooter + $1]                     ; $59C7
    cp $20                                        ; $59CA
    jr nc, jr_007_59d3                            ; $59CC

    ld a, $40                                     ; $59CE
    ld [wShootEnemyBaseX + $2], a                 ; $59D0

jr_007_59d3:
    call SpaceFever_ResetEnemies                  ; $59D3
    ld hl, SpaceFever_Wave0_Init_Tbl59FB          ; $59D6
    ld de, wMotionPath                            ; $59D9
    call SpaceFever_DecodePath                    ; $59DC
    call SpaceFever_ClearBullets                  ; $59DF
    ld a, $03                                     ; $59E2
    ld [wShootWaveEnemies], a                     ; $59E4
    xor a                                         ; $59E7
    ld [wShootWaveDone], a                        ; $59E8
    ld [wShootWavePass], a                        ; $59EB
    play_sfx1 SFX1_SPACE_FEVER_START              ; $59EE
    ld hl, wShootWaveState                        ; $59F5
    inc [hl]                                      ; $59F8
    ret                                           ; $59F9


; C: path length byte. L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07
; (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_PathEnd::
    db $ff

; C: auto: 18 bytes, bytes; referenced by SpaceFever_Wave0_Init. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_Init_Tbl59FB::
    db $01, $27, $cd, $00, $de, $00, $cd, $00, $00, $01, $e0, $cd, $01, $de, $00, $cd
    db $ff, $00

; C: enemies off screen; path pos 0
SpaceFever_ResetEnemies::
    ld hl, wShootEnemyX                           ; $5A0D
    ld a, $60                                     ; $5A10
    ld [hl+], a                                   ; $5A12
    ld [hl+], a                                   ; $5A13
    ld [hl], a                                    ; $5A14
    ld hl, wShootEnemyY                           ; $5A15
    ld a, $e0                                     ; $5A18
    ld [hl+], a                                   ; $5A1A
    ld [hl+], a                                   ; $5A1B
    ld [hl], a                                    ; $5A1C
    ld hl, wShootPathPos                          ; $5A1D
    xor a                                         ; $5A20
    ld b, $06                                     ; $5A21

jr_007_5a23:
    ld [hl+], a                                   ; $5A23
    dec b                                         ; $5A24
    jr nz, jr_007_5a23                            ; $5A25

    ld hl, wShootEnemyState                       ; $5A27
    ld [hl+], a                                   ; $5A2A
    ld [hl+], a                                   ; $5A2B
    ld [hl], a                                    ; $5A2C
    ld hl, wSpriteAnimTick + $2                   ; $5A2D
    ld [hl+], a                                   ; $5A30
    ld [hl+], a                                   ; $5A31
    ld [hl], a                                    ; $5A32
    ld [wShootFinishedMask], a                    ; $5A33
    ld a, $0a                                     ; $5A36
    ld [wShootStartDelay], a                      ; $5A38
    ld a, $00                                     ; $5A3B
    ld [wSpriteAnimFrame + $2], a                 ; $5A3D
    ld a, $02                                     ; $5A40
    ld [wSpriteAnimFrame + $3], a                 ; $5A42
    ld a, $04                                     ; $5A45
    ld [wSpriteAnimFrame + $4], a                 ; $5A47
    ld hl, wShootWavePass                         ; $5A4A
    ld a, [hl]                                    ; $5A4D
    inc [hl]                                      ; $5A4E
    and a                                         ; $5A4F
    ret nz                                        ; $5A50

    ld hl, wShootWaveDone                         ; $5A51
    inc [hl]                                      ; $5A54
    ret                                           ; $5A55


; C
SpaceFever_Wave0_Play::
    call SpaceFever_Wave0_ReapKilled              ; $5A56
    ld bc, wMotionPath                            ; $5A59
    ld de, $0002                                  ; $5A5C
    call SpaceFever_MoveEnemies                   ; $5A5F
    ld bc, SpaceFever_Wave0_Play_Tbl5AE2          ; $5A62
    ld de, $0002                                  ; $5A65
    call SpaceFever_DrawEnemies                   ; $5A68
    call SpaceFever_Wave0_CheckTargetHit          ; $5A6B
    ld a, [wShootFinishedMask]                    ; $5A6E
    and $07                                       ; $5A71
    cp $07                                        ; $5A73
    call z, SpaceFever_ResetEnemies               ; $5A75
    ld hl, wShootWaveDone                         ; $5A78
    bit 0, [hl]                                   ; $5A7B
    ret z                                         ; $5A7D

    play_sfx1 SFX1_SPACE_FEVER_WAVE0_END          ; $5A7E
    ld a, $02                                     ; $5A85
    ld [wShootWaveState], a                       ; $5A87
    ret                                           ; $5A8A


; C: starts the death animation of a hit target. L3 pass 2026-10-26: executed in BGB in 13 replay(s) of the organic
; corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_ReapKilled::
    ld de, $0002                                  ; $5A8B

jr_007_5a8e:
    ld hl, wShootEnemyState                       ; $5A8E
    add hl, de                                    ; $5A91
    bit 0, [hl]                                   ; $5A92
    jr z, jr_007_5ab6                             ; $5A94

    sla [hl]                                      ; $5A96
    push af                                       ; $5A98
    ld hl, wSpriteAnimFrame + $2                  ; $5A99
    add hl, de                                    ; $5A9C
    ld [hl], $06                                  ; $5A9D
    ld hl, wSpriteAnimTick + $2                   ; $5A9F
    add hl, de                                    ; $5AA2
    ld [hl], $00                                  ; $5AA3
    pop af                                        ; $5AA5
    ld a, $00                                     ; $5AA6
    jr nc, jr_007_5aac                            ; $5AA8

    add a                                         ; $5AAA
    daa                                           ; $5AAB

jr_007_5aac:
    call SpaceFever_AddScore                      ; $5AAC
    play_sfx1 SFX1_SPACE_FEVER_TARGET_KILL        ; $5AAF

jr_007_5ab6:
    dec e                                         ; $5AB6
    bit 7, e                                      ; $5AB7
    jr z, jr_007_5a8e                             ; $5AB9

    ret                                           ; $5ABB


; C: $D502/$D503/$D504 = $0A selects mode $20/$1F/$21 (state 6/5/7)
SpaceFever_Wave0_CheckTargetHit::
    ld a, [wSpriteAnimFrame + $2]                 ; $5ABC
    cp $0a                                        ; $5ABF
    jr nz, jr_007_5ac9                            ; $5AC1

    set_state STATE_07_GOTO_BALL                  ; $5AC3
    ret                                           ; $5AC8


jr_007_5ac9:
    ld a, [wSpriteAnimFrame + $3]                 ; $5AC9
    cp $0a                                        ; $5ACC
    jr nz, jr_007_5ad6                            ; $5ACE

    set_state STATE_07_GOTO_DJ                    ; $5AD0
    ret                                           ; $5AD5


jr_007_5ad6:
    ld a, [wSpriteAnimFrame + $4]                 ; $5AD6
    cp $0a                                        ; $5AD9
    ret nz                                        ; $5ADB

    set_state STATE_07_GOTO_RUN                   ; $5ADC
    ret                                           ; $5AE1


; C: auto: 24 bytes, bytes; referenced by SpaceFever_Wave0_Play. L3 pass 2026-10-26: read in BGB in 13 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave0_Play_Tbl5AE2::
    db $56, $10, $ff, $00, $55, $10, $ff, $02, $54, $10, $ff, $04, $5a, $03, $5b, $04
    db $5c, $04, $00, $10, $00, $10, $ff, $0a

; C
SpaceFever_Wave1_Init::
    xor a                                         ; $5AFA
    ld [wShootEnemyBaseY], a                      ; $5AFB
    ld [wShootEnemyBaseY + $1], a                 ; $5AFE
    ld a, [SpaceFever_Wave1_Init_Tbl5B44 + $8]    ; $5B01
    ld [wShootPathEnd], a                         ; $5B04
    ld [wShootPathEnd + $1], a                    ; $5B07
    ld a, [wShootRound]                           ; $5B0A
    ld c, a                                       ; $5B0D
    ld b, $00                                     ; $5B0E
    ld hl, SpaceFever_Wave1_Init_Tbl5B44          ; $5B10
    add hl, bc                                    ; $5B13
    ld a, [hl]                                    ; $5B14
    ld [wShootPathSpeed], a                       ; $5B15
    ld [wShootPathSpeed + $1], a                  ; $5B18
    xor a                                         ; $5B1B
    ld [wShootPathMirror], a                      ; $5B1C
    xor $ff                                       ; $5B1F
    ld [wShootPathMirror + $1], a                 ; $5B21
    call SpaceFever_Wave1_RandomBase              ; $5B24
    ld hl, SpaceFever_Wave1_Init_Tbl5B4D          ; $5B27
    ld de, wMotionPath                            ; $5B2A
    call SpaceFever_DecodePath                    ; $5B2D
    call SpaceFever_ClearBullets                  ; $5B30
    ld a, $02                                     ; $5B33
    ld [wShootWaveEnemies], a                     ; $5B35
    xor a                                         ; $5B38
    ld [wShootWaveDone], a                        ; $5B39
    ld [wShootWavePass], a                        ; $5B3C
    ld hl, wShootWaveState                        ; $5B3F
    inc [hl]                                      ; $5B42
    ret                                           ; $5B43


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave1_Init. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Init_Tbl5B44::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $e0

; C: auto: 221 bytes, bytes; referenced by SpaceFever_Wave1_Init. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Init_Tbl5B4D::
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
    ld hl, wShootEnemyBaseX                       ; $5C2A
    call Rng_Next                                 ; $5C2D
    and $1f                                       ; $5C30
    sub $10                                       ; $5C32
    ld [hl+], a                                   ; $5C34
    call Rng_Next                                 ; $5C35
    and $1f                                       ; $5C38
    sub $10                                       ; $5C3A
    ld [hl], a                                    ; $5C3C
    ld hl, wShootEnemyX                           ; $5C3D
    ld a, $60                                     ; $5C40
    ld [hl+], a                                   ; $5C42
    ld [hl], a                                    ; $5C43
    ld hl, wShootEnemyY                           ; $5C44
    ld a, $e0                                     ; $5C47
    ld [hl+], a                                   ; $5C49
    ld [hl], a                                    ; $5C4A
    ld hl, wShootPathPos                          ; $5C4B
    xor a                                         ; $5C4E
    ld b, $04                                     ; $5C4F

jr_007_5c51:
    ld [hl+], a                                   ; $5C51
    dec b                                         ; $5C52
    jr nz, jr_007_5c51                            ; $5C53

    ld hl, wShootEnemyState                       ; $5C55
    ld [hl+], a                                   ; $5C58
    ld [hl], a                                    ; $5C59
    ld hl, wSpriteAnimTick + $2                   ; $5C5A
    ld [hl+], a                                   ; $5C5D
    ld [hl], a                                    ; $5C5E
    ld [wShootFinishedMask], a                    ; $5C5F
    ld a, $0a                                     ; $5C62
    ld [wShootStartDelay], a                      ; $5C64
    ld hl, wSpriteAnimFrame + $2                  ; $5C67
    ld a, $00                                     ; $5C6A
    ld [hl+], a                                   ; $5C6C
    ld [hl], a                                    ; $5C6D
    ld hl, wShootWavePass                         ; $5C6E
    ld a, [hl]                                    ; $5C71
    inc [hl]                                      ; $5C72
    cp $02                                        ; $5C73
    ret nz                                        ; $5C75

    ld hl, wShootWaveDone                         ; $5C76
    inc [hl]                                      ; $5C79
    ret                                           ; $5C7A


; C
SpaceFever_Wave1_Play::
    call SpaceFever_Wave1_ReapKilled              ; $5C7B
    ld bc, wMotionPath                            ; $5C7E
    ld de, $0001                                  ; $5C81
    call SpaceFever_MoveEnemies                   ; $5C84
    ld bc, SpaceFever_Wave1_Play_Tbl5CD7          ; $5C87
    ld de, $0001                                  ; $5C8A
    call SpaceFever_DrawEnemies                   ; $5C8D
    ld a, [wShootFinishedMask]                    ; $5C90
    and $03                                       ; $5C93
    cp $03                                        ; $5C95
    call z, SpaceFever_Wave1_RandomBase           ; $5C97
    ld hl, wShootWaveDone                         ; $5C9A
    bit 0, [hl]                                   ; $5C9D
    ret z                                         ; $5C9F

    ld a, $04                                     ; $5CA0
    ld [wShootWaveState], a                       ; $5CA2
    ret                                           ; $5CA5


; C: L3 pass 2026-10-26: executed in BGB in 12 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_ReapKilled::
    ld de, $0001                                  ; $5CA6

jr_007_5ca9:
    ld hl, wShootEnemyState                       ; $5CA9
    add hl, de                                    ; $5CAC
    bit 0, [hl]                                   ; $5CAD
    jr z, jr_007_5cd1                             ; $5CAF

    sla [hl]                                      ; $5CB1
    push af                                       ; $5CB3
    ld hl, wSpriteAnimFrame + $2                  ; $5CB4
    add hl, de                                    ; $5CB7
    ld [hl], $02                                  ; $5CB8
    ld hl, wSpriteAnimTick + $2                   ; $5CBA
    add hl, de                                    ; $5CBD
    ld [hl], $00                                  ; $5CBE
    pop af                                        ; $5CC0
    ld a, $05                                     ; $5CC1
    jr nc, jr_007_5cc7                            ; $5CC3

    add a                                         ; $5CC5
    daa                                           ; $5CC6

jr_007_5cc7:
    call SpaceFever_AddScore                      ; $5CC7
    play_sfx1 SFX1_SPACE_FEVER_ENEMY_KILL         ; $5CCA

jr_007_5cd1:
    dec e                                         ; $5CD1
    bit 7, e                                      ; $5CD2
    jr z, jr_007_5ca9                             ; $5CD4

    ret                                           ; $5CD6


; C: auto: 12 bytes, bytes; referenced by SpaceFever_Wave1_Play. L3 pass 2026-10-26: read in BGB in 12 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave1_Play_Tbl5CD7::
    db $59, $10, $ff, $00, $5a, $04, $5b, $06, $00, $10, $ff, $04

; C
SpaceFever_Wave2_Init::
    xor a                                         ; $5CE3
    ld [wShootEnemyBaseY], a                      ; $5CE4
    ld [wShootEnemyBaseY + $1], a                 ; $5CE7
    ld a, [SpaceFever_Wave2_Init_Tbl5D2D + $8]    ; $5CEA
    ld [wShootPathEnd], a                         ; $5CED
    ld [wShootPathEnd + $1], a                    ; $5CF0
    ld a, [wShootRound]                           ; $5CF3
    ld c, a                                       ; $5CF6
    ld b, $00                                     ; $5CF7
    ld hl, SpaceFever_Wave2_Init_Tbl5D2D          ; $5CF9
    add hl, bc                                    ; $5CFC
    ld a, [hl]                                    ; $5CFD
    ld [wShootPathSpeed], a                       ; $5CFE
    ld [wShootPathSpeed + $1], a                  ; $5D01
    xor a                                         ; $5D04
    ld [wShootPathMirror], a                      ; $5D05
    xor $ff                                       ; $5D08
    ld [wShootPathMirror + $1], a                 ; $5D0A
    call SpaceFever_Wave2_RandomBase              ; $5D0D
    ld hl, SpaceFever_Wave2_Init_Tbl5D36          ; $5D10
    ld de, wMotionPath                            ; $5D13
    call SpaceFever_DecodePath                    ; $5D16
    call SpaceFever_ClearBullets                  ; $5D19
    ld a, $02                                     ; $5D1C
    ld [wShootWaveEnemies], a                     ; $5D1E
    xor a                                         ; $5D21
    ld [wShootWaveDone], a                        ; $5D22
    ld [wShootWavePass], a                        ; $5D25
    ld hl, wShootWaveState                        ; $5D28
    inc [hl]                                      ; $5D2B
    ret                                           ; $5D2C


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave2_Init. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Init_Tbl5D2D::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $a4

; C: auto: 152 bytes, bytes; referenced by SpaceFever_Wave2_Init. L3 pass 2026-10-26: read in BGB in 8 replay(s) of
; the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Init_Tbl5D36::
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
    ld hl, wShootEnemyBaseX                       ; $5DCE
    call Rng_Next                                 ; $5DD1
    and $1f                                       ; $5DD4
    sub $10                                       ; $5DD6
    ld [hl+], a                                   ; $5DD8
    call Rng_Next                                 ; $5DD9
    and $1f                                       ; $5DDC
    sub $10                                       ; $5DDE
    ld [hl], a                                    ; $5DE0
    ld hl, wShootEnemyX                           ; $5DE1
    ld a, $60                                     ; $5DE4
    ld [hl+], a                                   ; $5DE6
    ld [hl], a                                    ; $5DE7
    ld hl, wShootEnemyY                           ; $5DE8
    ld a, $e0                                     ; $5DEB
    ld [hl+], a                                   ; $5DED
    ld [hl], a                                    ; $5DEE
    ld hl, wShootPathPos                          ; $5DEF
    xor a                                         ; $5DF2
    ld b, $04                                     ; $5DF3

jr_007_5df5:
    ld [hl+], a                                   ; $5DF5
    dec b                                         ; $5DF6
    jr nz, jr_007_5df5                            ; $5DF7

    ld hl, wShootEnemyState                       ; $5DF9
    ld [hl+], a                                   ; $5DFC
    ld [hl], a                                    ; $5DFD
    ld hl, wSpriteAnimTick + $2                   ; $5DFE
    ld [hl+], a                                   ; $5E01
    ld [hl], a                                    ; $5E02
    ld [wShootFinishedMask], a                    ; $5E03
    ld a, $0a                                     ; $5E06
    ld [wShootStartDelay], a                      ; $5E08
    ld hl, wSpriteAnimFrame + $2                  ; $5E0B
    ld a, $00                                     ; $5E0E
    ld [hl+], a                                   ; $5E10
    ld [hl], a                                    ; $5E11
    ld hl, wShootWavePass                         ; $5E12
    ld a, [hl]                                    ; $5E15
    inc [hl]                                      ; $5E16
    cp $02                                        ; $5E17
    ret nz                                        ; $5E19

    ld hl, wShootWaveDone                         ; $5E1A
    inc [hl]                                      ; $5E1D
    ret                                           ; $5E1E


; C
SpaceFever_Wave2_Play::
    call SpaceFever_Wave2_ReapKilled              ; $5E1F
    call SpaceFever_Wave2_EnemyFire               ; $5E22
    ld bc, wMotionPath                            ; $5E25
    ld de, $0001                                  ; $5E28
    call SpaceFever_MoveEnemies                   ; $5E2B
    ld bc, SpaceFever_Wave2_Play_Tbl5EB5          ; $5E2E
    ld de, $0001                                  ; $5E31
    call SpaceFever_DrawEnemies                   ; $5E34
    call SpaceFever_DrawBullets                   ; $5E37
    call SpaceFever_CountBullets                  ; $5E3A
    and a                                         ; $5E3D
    ret nz                                        ; $5E3E

    ld a, [wShootFinishedMask]                    ; $5E3F
    and $03                                       ; $5E42
    cp $03                                        ; $5E44
    call z, SpaceFever_Wave2_RandomBase           ; $5E46
    ld hl, wShootWaveDone                         ; $5E49
    bit 0, [hl]                                   ; $5E4C
    ret z                                         ; $5E4E

    ld a, $06                                     ; $5E4F
    ld [wShootWaveState], a                       ; $5E51
    ret                                           ; $5E54


; C: L3 pass 2026-10-26: executed in BGB in 8 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_ReapKilled::
    ld de, $0001                                  ; $5E55

jr_007_5e58:
    ld hl, wShootEnemyState                       ; $5E58
    add hl, de                                    ; $5E5B
    bit 0, [hl]                                   ; $5E5C
    jr z, jr_007_5e80                             ; $5E5E

    sla [hl]                                      ; $5E60
    push af                                       ; $5E62
    ld hl, wSpriteAnimFrame + $2                  ; $5E63
    add hl, de                                    ; $5E66
    ld [hl], $02                                  ; $5E67
    ld hl, wSpriteAnimTick + $2                   ; $5E69
    add hl, de                                    ; $5E6C
    ld [hl], $00                                  ; $5E6D
    pop af                                        ; $5E6F
    ld a, $10                                     ; $5E70
    jr nc, jr_007_5e76                            ; $5E72

    add a                                         ; $5E74
    daa                                           ; $5E75

jr_007_5e76:
    call SpaceFever_AddScore                      ; $5E76
    play_sfx1 SFX1_SPACE_FEVER_ENEMY_KILL         ; $5E79

jr_007_5e80:
    dec e                                         ; $5E80
    bit 7, e                                      ; $5E81
    jr z, jr_007_5e58                             ; $5E83

    ret                                           ; $5E85


; C: enemy shoots when low enough and fewer than 5 bullets are up. L3 pass 2026-10-26: executed in BGB in 8 replay(s)
; of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_EnemyFire::
    ld de, $0001                                  ; $5E86

jr_007_5e89:
    ld hl, wShootEnemyState                       ; $5E89
    add hl, de                                    ; $5E8C
    ld a, [hl]                                    ; $5E8D
    and a                                         ; $5E8E
    jr nz, jr_007_5eaf                            ; $5E8F

    ld hl, wShootEnemyY                           ; $5E91
    add hl, de                                    ; $5E94
    ld a, [hl]                                    ; $5E95
    cp $20                                        ; $5E96
    jr c, jr_007_5eaf                             ; $5E98

    call SpaceFever_CountBullets                  ; $5E9A
    cp $05                                        ; $5E9D
    jr nc, jr_007_5eaf                            ; $5E9F

    ldh a, [hFrameCounter]                        ; $5EA1
    and $0f                                       ; $5EA3
    jr nz, jr_007_5eaf                            ; $5EA5

    call Rng_Next                                 ; $5EA7
    cp $80                                        ; $5EAA
    call c, SpaceFever_FireBullet                 ; $5EAC

jr_007_5eaf:
    dec e                                         ; $5EAF
    bit 7, e                                      ; $5EB0
    jr z, jr_007_5e89                             ; $5EB2

    ret                                           ; $5EB4


; C: auto: 12 bytes, bytes; referenced by SpaceFever_Wave2_Play. L3 pass 2026-10-26: read in BGB in 8 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_Wave2_Play_Tbl5EB5::
    db $58, $10, $ff, $00, $5a, $04, $5b, $06, $00, $10, $ff, $04

; C
SpaceFever_Wave3_Init::
    xor a                                         ; $5EC1
    ld [wShootEnemyBaseY], a                      ; $5EC2
    ld a, $08                                     ; $5EC5
    ld [wShootEnemyBaseY + $1], a                 ; $5EC7
    ld [wShootEnemyBaseY + $2], a                 ; $5ECA
    ld a, [SpaceFever_Wave3_Init_Tbl5F17 + $8]    ; $5ECD
    ld [wShootPathEnd], a                         ; $5ED0
    ld [wShootPathEnd + $1], a                    ; $5ED3
    ld [wShootPathEnd + $2], a                    ; $5ED6
    ld a, [wShootRound]                           ; $5ED9
    ld c, a                                       ; $5EDC
    ld b, $00                                     ; $5EDD
    ld hl, SpaceFever_Wave3_Init_Tbl5F17          ; $5EDF
    add hl, bc                                    ; $5EE2
    ld a, [hl]                                    ; $5EE3
    ld [wShootPathSpeed], a                       ; $5EE4
    ld [wShootPathSpeed + $1], a                  ; $5EE7
    ld [wShootPathSpeed + $2], a                  ; $5EEA
    xor a                                         ; $5EED
    ld [wShootPathMirror], a                      ; $5EEE
    ld [wShootPathMirror + $1], a                 ; $5EF1
    ld [wShootPathMirror + $2], a                 ; $5EF4
    call SpaceFever_Wave3_RandomBase              ; $5EF7
    ld hl, SpaceFever_Wave3_Init_Tbl5F20          ; $5EFA
    ld de, wMotionPath                            ; $5EFD
    call SpaceFever_DecodePath                    ; $5F00
    call SpaceFever_ClearBullets                  ; $5F03
    ld a, $03                                     ; $5F06
    ld [wShootWaveEnemies], a                     ; $5F08
    xor a                                         ; $5F0B
    ld [wShootWaveDone], a                        ; $5F0C
    ld [wShootWavePass], a                        ; $5F0F
    ld hl, wShootWaveState                        ; $5F12
    inc [hl]                                      ; $5F15
    ret                                           ; $5F16


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Wave3_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00
; 07 12)
SpaceFever_Wave3_Init_Tbl5F17::
    db $80, $90, $a0, $b0, $c0, $e0, $f0, $ff, $ea

; C: auto: 151 bytes, bytes; referenced by SpaceFever_Wave3_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 07)
SpaceFever_Wave3_Init_Tbl5F20::
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
    ld hl, wShootEnemyBaseX                       ; $5FB7
    call Rng_Next                                 ; $5FBA
    and $1f                                       ; $5FBD
    sub $10                                       ; $5FBF
    ld [hl+], a                                   ; $5FC1
    sub $05                                       ; $5FC2
    ld [hl+], a                                   ; $5FC4
    add $0a                                       ; $5FC5
    ld [hl], a                                    ; $5FC7
    ld hl, wShootEnemyX                           ; $5FC8
    ld a, $60                                     ; $5FCB
    ld [hl+], a                                   ; $5FCD
    ld [hl+], a                                   ; $5FCE
    ld [hl], a                                    ; $5FCF
    ld hl, wShootEnemyY                           ; $5FD0
    ld a, $e0                                     ; $5FD3
    ld [hl+], a                                   ; $5FD5
    ld [hl+], a                                   ; $5FD6
    ld [hl], a                                    ; $5FD7
    ld hl, wShootPathPos                          ; $5FD8
    xor a                                         ; $5FDB
    ld b, $06                                     ; $5FDC

jr_007_5fde:
    ld [hl+], a                                   ; $5FDE
    dec b                                         ; $5FDF
    jr nz, jr_007_5fde                            ; $5FE0

    ld hl, wShootEnemyState                       ; $5FE2
    ld [hl+], a                                   ; $5FE5
    ld [hl+], a                                   ; $5FE6
    ld [hl], a                                    ; $5FE7
    ld hl, wSpriteAnimTick + $2                   ; $5FE8
    ld [hl+], a                                   ; $5FEB
    ld [hl+], a                                   ; $5FEC
    ld [hl], a                                    ; $5FED
    ld [wShootFinishedMask], a                    ; $5FEE
    ld a, $0a                                     ; $5FF1
    ld [wShootStartDelay], a                      ; $5FF3
    ld hl, wSpriteAnimFrame + $2                  ; $5FF6
    ld a, $00                                     ; $5FF9
    ld [hl+], a                                   ; $5FFB
    ld a, $02                                     ; $5FFC
    ld [hl+], a                                   ; $5FFE
    ld [hl], a                                    ; $5FFF
    ld hl, wShootWavePass                         ; $6000
    ld a, [hl]                                    ; $6003
    inc [hl]                                      ; $6004
    cp $02                                        ; $6005
    ret nz                                        ; $6007

    ld hl, wShootWaveDone                         ; $6008
    inc [hl]                                      ; $600B
    ret                                           ; $600C


; C
SpaceFever_Wave3_Play::
    call SpaceFever_Wave3_ReapKilled              ; $600D
    ld bc, wMotionPath                            ; $6010
    ld de, $0002                                  ; $6013
    call SpaceFever_MoveEnemies                   ; $6016
    ld bc, SpaceFever_Wave3_Play_Tbl6083          ; $6019
    ld de, $0002                                  ; $601C
    call SpaceFever_DrawEnemies                   ; $601F
    call SpaceFever_DrawBullets                   ; $6022
    ld a, [wShootFinishedMask]                    ; $6025
    and $07                                       ; $6028
    cp $07                                        ; $602A
    call z, SpaceFever_Wave3_RandomBase           ; $602C
    ld hl, wShootWaveDone                         ; $602F
    bit 0, [hl]                                   ; $6032
    ret z                                         ; $6034

    ld a, $08                                     ; $6035
    ld [wShootWaveState], a                       ; $6037
    ret                                           ; $603A


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SpaceFever_Wave3_ReapKilled::
    ld de, $0002                                  ; $603B

jr_007_603e:
    ld hl, wShootEnemyState                       ; $603E
    add hl, de                                    ; $6041
    bit 0, [hl]                                   ; $6042
    jr z, jr_007_607d                             ; $6044

    sla [hl]                                      ; $6046
    push af                                       ; $6048
    ld hl, wSpriteAnimFrame + $2                  ; $6049
    add hl, de                                    ; $604C
    ld [hl], $04                                  ; $604D
    ld hl, wSpriteAnimTick + $2                   ; $604F
    add hl, de                                    ; $6052
    ld [hl], $00                                  ; $6053
    ld a, e                                       ; $6055
    and a                                         ; $6056
    jr nz, jr_007_606c                            ; $6057

    pop af                                        ; $6059
    ld a, $30                                     ; $605A
    jr nc, jr_007_6060                            ; $605C

    add a                                         ; $605E
    daa                                           ; $605F

jr_007_6060:
    call SpaceFever_AddScore                      ; $6060
    play_sfx1 SFX1_SPACE_FEVER_BIG_ENEMY_KILL     ; $6063
    jr jr_007_607d                                ; $606A

jr_007_606c:
    pop af                                        ; $606C
    ld a, $05                                     ; $606D
    jr nc, jr_007_6073                            ; $606F

    add a                                         ; $6071
    daa                                           ; $6072

jr_007_6073:
    call SpaceFever_AddScore                      ; $6073
    play_sfx1 SFX1_SPACE_FEVER_ENEMY_KILL         ; $6076

jr_007_607d:
    dec e                                         ; $607D
    bit 7, e                                      ; $607E
    jr z, jr_007_603e                             ; $6080

    ret                                           ; $6082


; C: auto: 16 bytes, bytes; referenced by SpaceFever_Wave3_Play. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 07)
SpaceFever_Wave3_Play_Tbl6083::
    db $57, $10, $ff, $00, $59, $10, $ff, $02, $5a, $04, $5b, $06, $00, $10, $ff, $06

; C: boss graphics; speed table 07:6130; music
SpaceFever_Boss_Init::
    xor a                                         ; $6093
    ld [wShootEnemyBaseX], a                      ; $6094
    ld a, [SpaceFever_Boss_Init_Tbl60F2 + $8]     ; $6097
    ld [wShootPathEnd], a                         ; $609A
    ld a, [wShootRound]                           ; $609D
    ld c, a                                       ; $60A0
    ld b, $00                                     ; $60A1
    ld hl, SpaceFever_Boss_Init_Tbl60F2           ; $60A3
    add hl, bc                                    ; $60A6
    ld a, [hl]                                    ; $60A7
    ld [wShootPathSpeed], a                       ; $60A8
    xor a                                         ; $60AB
    ld [wShootPathMirror], a                      ; $60AC
    ld c, $00                                     ; $60AF
    call SpaceFever_LoadBossTilesA                ; $60B1
    ld c, $01                                     ; $60B4
    call SpaceFever_LoadBossTilesB                ; $60B6
    ld a, [wShootPlayerDied]                      ; $60B9
    and a                                         ; $60BC
    ld c, $02                                     ; $60BD
    call z, SpaceFever_LoadBossTilesC             ; $60BF
    call Sf2_BuildBossMasks                       ; $60C2
    call SpaceFever_Boss_ResetPass                ; $60C5
    ld hl, SpaceFever_Boss_Init_Tbl60FB           ; $60C8
    ld de, wMotionPath                            ; $60CB
    call SpaceFever_DecodePath                    ; $60CE
    call SpaceFever_ClearBullets                  ; $60D1
    ld a, $01                                     ; $60D4
    ld [wShootWaveEnemies], a                     ; $60D6
    xor a                                         ; $60D9
    ld [wShootWaveDone], a                        ; $60DA
    ld [wShootWavePass], a                        ; $60DD
    ld a, [wShootPlayerDied]                      ; $60E0
    and a                                         ; $60E3
    jr nz, jr_007_60ed                            ; $60E4

    play_music MUSIC_SPACE_FEVER_BOSS             ; $60E6

jr_007_60ed:
    ld hl, wShootWaveState                        ; $60ED
    inc [hl]                                      ; $60F0
    ret                                           ; $60F1


; C: auto: 9 bytes, bytes; referenced by SpaceFever_Boss_Init. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00 07 12)
SpaceFever_Boss_Init_Tbl60F2::
    db $50, $60, $70, $80, $90, $a0, $b0, $c0, $d6

; C: auto: 154 bytes, bytes; referenced by SpaceFever_Boss_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 07
; 12)
SpaceFever_Boss_Init_Tbl60FB::
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
    call Rng_Next                                 ; $6195
    and $0f                                       ; $6198
    sub $08                                       ; $619A
    ld [wShootEnemyBaseY], a                      ; $619C
    ld a, $60                                     ; $619F
    ld [wShootEnemyX], a                          ; $61A1
    ld a, $e0                                     ; $61A4
    ld [wShootEnemyY], a                          ; $61A6
    ld hl, wShootPathPos                          ; $61A9
    xor a                                         ; $61AC
    ld [hl+], a                                   ; $61AD
    ld [hl], a                                    ; $61AE
    ld [wShootEnemyState], a                      ; $61AF
    ld [wSpriteAnimTick + $2], a                  ; $61B2
    ld [wShootFinishedMask], a                    ; $61B5
    ld [wShootBossHits], a                        ; $61B8
    ld a, $14                                     ; $61BB
    ld [wShootStartDelay], a                      ; $61BD
    ld a, $00                                     ; $61C0
    ld [wSpriteAnimFrame + $2], a                 ; $61C2
    ld hl, wShootWavePass                         ; $61C5
    ld a, [hl]                                    ; $61C8
    inc [hl]                                      ; $61C9
    and a                                         ; $61CA
    ret nz                                        ; $61CB

    ld hl, wShootWaveDone                         ; $61CC
    inc [hl]                                      ; $61CF
    ret                                           ; $61D0


; C
SpaceFever_Boss_Play::
    ld a, [wSpriteAnimFrame + $2]                 ; $61D1
    cp $05                                        ; $61D4
    jr nc, jr_007_61e4                            ; $61D6

    call SpaceFever_Boss_EnemyFire                ; $61D8
    ld bc, wMotionPath                            ; $61DB
    ld de, $0000                                  ; $61DE
    call SpaceFever_MoveEnemies                   ; $61E1

jr_007_61e4:
    ld bc, SpaceFever_Boss_Play_Tbl626B           ; $61E4
    ld de, $0000                                  ; $61E7
    call SpaceFever_DrawEnemies                   ; $61EA
    ld a, [wSpriteAnimFrame + $2]                 ; $61ED
    cp $05                                        ; $61F0
    jr nz, jr_007_620d                            ; $61F2

    ld a, [wShootBossTimer]                       ; $61F4
    inc a                                         ; $61F7
    cp $32                                        ; $61F8
    jr nz, jr_007_620a                            ; $61FA

    ld a, $0c                                     ; $61FC
    ld [wSpriteAnimFrame + $2], a                 ; $61FE
    play_sfx1 SFX1_CURSOR_MOVE                    ; $6201
    jr jr_007_620d                                ; $6208

jr_007_620a:
    ld [wShootBossTimer], a                       ; $620A

jr_007_620d:
    call SpaceFever_DrawBullets                   ; $620D
    ld a, [wShootFinishedMask]                    ; $6210
    and $01                                       ; $6213
    cp $01                                        ; $6215
    call z, SpaceFever_Boss_StartFinalPass        ; $6217
    ld a, [wSpriteAnimFrame + $2]                 ; $621A
    cp $14                                        ; $621D
    ret c                                         ; $621F

    ld a, $0a                                     ; $6220
    ld [wShootWaveState], a                       ; $6222
    ld a, [wShootRound]                           ; $6225
    cp $07                                        ; $6228
    jr z, jr_007_6230                             ; $622A

    inc a                                         ; $622C
    ld [wShootRound], a                           ; $622D

jr_007_6230:
    ld a, [wShootBossVariant]                     ; $6230
    inc a                                         ; $6233
    cp $03                                        ; $6234
    jr nz, jr_007_6239                            ; $6236

    xor a                                         ; $6238

jr_007_6239:
    ld [wShootBossVariant], a                     ; $6239
    ret                                           ; $623C


; C: path pos := $4500. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the
; core emulator (coverage/results/merged_state/cov.npz)
SpaceFever_Boss_StartFinalPass::
    ld hl, wShootPathPos                          ; $623D
    xor a                                         ; $6240
    ld [hl+], a                                   ; $6241
    ld a, $45                                     ; $6242
    ld [hl], a                                    ; $6244
    ld hl, wShootFinishedMask                     ; $6245
    res 0, [hl]                                   ; $6248
    ret                                           ; $624A


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SpaceFever_Boss_EnemyFire::
    ld de, $0000                                  ; $624B
    ld hl, wShootEnemyState                       ; $624E
    ld a, [hl]                                    ; $6251
    and a                                         ; $6252
    jr nz, jr_007_626a                            ; $6253

    call SpaceFever_CountBullets                  ; $6255
    cp $03                                        ; $6258
    jr nc, jr_007_626a                            ; $625A

    ldh a, [hFrameCounter]                        ; $625C
    and $0f                                       ; $625E
    jr nz, jr_007_626a                            ; $6260

    call Rng_Next                                 ; $6262
    cp $50                                        ; $6265
    call c, SpaceFever_FireBulletPair             ; $6267

jr_007_626a:
    ret                                           ; $626A


; C: auto: 44 bytes, bytes; referenced by SpaceFever_Boss_Play. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 00
; 07 12)
SpaceFever_Boss_Play_Tbl626B::
    db $63, $20, $64, $20, $ff, $00, $62, $08, $ff, $00, $62, $01, $68, $01, $69, $01
    db $6a, $01, $69, $01, $68, $01, $ff, $05, $62, $01, $68, $01, $69, $01, $6a, $01
    db $5a, $03, $5b, $04, $5c, $04, $00, $10, $00, $10, $ff, $14

; C: state 10: boss gone; back to wave state 2 (README 16.18)
SpaceFever_Boss_EndA::
    ld a, [wSpriteAnimFrame]                      ; $6297
    cp $02                                        ; $629A
    jr c, jr_007_62a4                             ; $629C

    ld a, $02                                     ; $629E
    ld [wShootWaveState], a                       ; $62A0
    ret                                           ; $62A3


jr_007_62a4:
    ld a, [wShootBossVariant]                     ; $62A4
    and a                                         ; $62A7
    jr z, jr_007_62b7                             ; $62A8

    play_music MUSIC_SPACE_FEVER_MAIN             ; $62AA
    ld a, $02                                     ; $62B1
    ld [wShootWaveState], a                       ; $62B3
    ret                                           ; $62B6


jr_007_62b7:
    play_music MUSIC_SPACE_FEVER_MAIN             ; $62B7
    xor a                                         ; $62BE
    ld [wSpriteAnimFrame + $2], a                 ; $62BF
    ld [wSpriteAnimTick + $2], a                  ; $62C2
    farcopy Vram_CopyFromBank, Map_25_5820_SpaceFever_Boss_EndB, $98c0, $0014 ; $62C5
    ld hl, wShootWaveState                        ; $62D3
    inc [hl]                                      ; $62D6
    ret                                           ; $62D7


; C: state 11
SpaceFever_Boss_EndB::
    ld a, [wSpriteAnimFrame]                      ; $62D8
    cp $02                                        ; $62DB
    jr c, jr_007_62e5                             ; $62DD

    ld a, $02                                     ; $62DF
    ld [wShootWaveState], a                       ; $62E1
    ret                                           ; $62E4


jr_007_62e5:
    ld a, [wSpriteAnimFrame + $2]                 ; $62E5
    ld c, a                                       ; $62E8
    ld b, $00                                     ; $62E9
    ld hl, SpaceFever_Boss_EndFrameLimitTbl       ; $62EB
    add hl, bc                                    ; $62EE
    ld a, [wSpriteAnimTick + $2]                  ; $62EF
    cp [hl]                                       ; $62F2
    jr c, jr_007_6322                             ; $62F3

    inc hl                                        ; $62F5
    ld a, [hl]                                    ; $62F6
    and a                                         ; $62F7
    jr z, jr_007_6327                             ; $62F8

    inc c                                         ; $62FA
    ld a, c                                       ; $62FB
    ld [wSpriteAnimFrame + $2], a                 ; $62FC
    bit 0, a                                      ; $62FF
    jr nz, jr_007_6313                            ; $6301

    farcopy Vram_CopyFromBank, Map_25_5820_SpaceFever_Boss_EndB, $98c0, $0014 ; $6303
    jr jr_007_6321                                ; $6311

jr_007_6313:
    farcopy Vram_CopyFromBank, Map_25_5680_SpaceFever_Boss_EndB, $98c0, $0014 ; $6313

jr_007_6321:
    xor a                                         ; $6321

jr_007_6322:
    inc a                                         ; $6322
    ld [wSpriteAnimTick + $2], a                  ; $6323
    ret                                           ; $6326


jr_007_6327:
    farcopy Vram_CopyFromBank, Map_25_5680_SpaceFever_Boss_EndB, $98c0, $0014 ; $6327
    ld a, $02                                     ; $6335
    ld [wShootWaveState], a                       ; $6337
    ret                                           ; $633A


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; frame limits of the boss end sequence (read at jr_007_6323)
SpaceFever_Boss_EndFrameLimitTbl::
    db $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $f0, $00

; C: steps the path of each enemy
SpaceFever_MoveEnemies::
    ld hl, wShootStartDelay                       ; $6349
    ld a, [hl]                                    ; $634C
    and a                                         ; $634D
    jr z, jr_007_6352                             ; $634E

    dec [hl]                                      ; $6350
    ret                                           ; $6351


jr_007_6352:
    push bc                                       ; $6352
    ld hl, wShootPathSpeed                        ; $6353
    add hl, de                                    ; $6356
    ld c, [hl]                                    ; $6357
    ld b, $00                                     ; $6358
    sla c                                         ; $635A
    rl b                                          ; $635C
    ld hl, wShootPathPos                          ; $635E
    add hl, de                                    ; $6361
    add hl, de                                    ; $6362
    ld a, c                                       ; $6363
    add [hl]                                      ; $6364
    ld [hl], a                                    ; $6365
    inc hl                                        ; $6366
    ld a, b                                       ; $6367
    adc [hl]                                      ; $6368
    ld [hl], a                                    ; $6369
    pop bc                                        ; $636A
    call SpaceFever_MoveEnemy                     ; $636B
    dec e                                         ; $636E
    bit 7, e                                      ; $636F
    jr z, SpaceFever_MoveEnemies                  ; $6371

    ret                                           ; $6373


; C: path point to screen x;y with offsets and mirror
SpaceFever_MoveEnemy::
    ld hl, wShootPathPos + $1                     ; $6374
    add hl, de                                    ; $6377
    add hl, de                                    ; $6378
    ld a, [hl]                                    ; $6379
    ld hl, wShootPathEnd                          ; $637A
    add hl, de                                    ; $637D
    cp [hl]                                       ; $637E
    jr c, jr_007_638c                             ; $637F

    ld hl, SpaceFever_MoveEnemy_Tbl63DE           ; $6381
    add hl, de                                    ; $6384
    ld a, [hl]                                    ; $6385
    ld hl, wShootFinishedMask                     ; $6386
    or [hl]                                       ; $6389
    ld [hl], a                                    ; $638A
    ret                                           ; $638B


jr_007_638c:
    ld hl, wShootEnemyState                       ; $638C
    add hl, de                                    ; $638F
    ld a, [hl]                                    ; $6390
    and a                                         ; $6391
    ret nz                                        ; $6392

    ld hl, wShootPathMirror                       ; $6393
    add hl, de                                    ; $6396
    ld a, [hl]                                    ; $6397
    ld hl, wShootPathPos + $1                     ; $6398
    add hl, de                                    ; $639B
    add hl, de                                    ; $639C
    ld l, [hl]                                    ; $639D
    ld h, $00                                     ; $639E
    sla l                                         ; $63A0
    rl h                                          ; $63A2
    add hl, bc                                    ; $63A4
    bit 7, a                                      ; $63A5
    jr nz, jr_007_63c2                            ; $63A7

    ld a, [hl+]                                   ; $63A9
    push hl                                       ; $63AA
    ld hl, wShootEnemyBaseX                       ; $63AB
    add hl, de                                    ; $63AE
    add [hl]                                      ; $63AF
    ld hl, wShootEnemyX                           ; $63B0
    add hl, de                                    ; $63B3
    ld [hl], a                                    ; $63B4
    pop hl                                        ; $63B5
    ld a, [hl]                                    ; $63B6
    ld hl, wShootEnemyBaseY                       ; $63B7
    add hl, de                                    ; $63BA
    add [hl]                                      ; $63BB
    ld hl, wShootEnemyY                           ; $63BC
    add hl, de                                    ; $63BF
    ld [hl], a                                    ; $63C0
    ret                                           ; $63C1


jr_007_63c2:
    ld a, [hl+]                                   ; $63C2
    push hl                                       ; $63C3
    ld hl, wShootEnemyBaseX                       ; $63C4
    add hl, de                                    ; $63C7
    add [hl]                                      ; $63C8
    ld hl, wShootEnemyX                           ; $63C9
    add hl, de                                    ; $63CC
    cpl                                           ; $63CD
    add $51                                       ; $63CE
    ld [hl], a                                    ; $63D0
    pop hl                                        ; $63D1
    ld a, [hl]                                    ; $63D2
    ld hl, wShootEnemyBaseY                       ; $63D3
    add hl, de                                    ; $63D6
    add [hl]                                      ; $63D7
    ld hl, wShootEnemyY                           ; $63D8
    add hl, de                                    ; $63DB
    ld [hl], a                                    ; $63DC
    ret                                           ; $63DD


; C: auto: 8 bytes, bytes; referenced by SpaceFever_MoveEnemy. L3 pass 2026-10-26: read in BGB in 12 replay(s) of the
; organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_MoveEnemy_Tbl63DE::
    db $01, $02, $04, $08, $10, $20, $40, $80

; C: sprite x = value + $48
SpaceFever_DrawEnemies::
    push bc                                       ; $63E6
    ld hl, wSpriteAnimFrame + $2                  ; $63E7
    add hl, de                                    ; $63EA
    ld l, [hl]                                    ; $63EB
    sla l                                         ; $63EC
    ld h, $00                                     ; $63EE
    add hl, bc                                    ; $63F0
    ld a, [hl+]                                   ; $63F1
    push hl                                       ; $63F2
    push af                                       ; $63F3
    ld hl, wShootEnemyX                           ; $63F4
    add hl, de                                    ; $63F7
    ld a, [hl]                                    ; $63F8
    cp $b0                                        ; $63F9
    jr c, jr_007_63ff                             ; $63FB

    ld a, $60                                     ; $63FD

jr_007_63ff:
    add $48                                       ; $63FF
    ld b, a                                       ; $6401
    ld hl, wShootEnemyY                           ; $6402
    add hl, de                                    ; $6405
    ld c, [hl]                                    ; $6406
    pop af                                        ; $6407
    push de                                       ; $6408
    and a                                         ; $6409
    call nz, SpaceFever_DrawEnemySprite           ; $640A
    pop de                                        ; $640D
    ld hl, wSpriteAnimTick + $2                   ; $640E
    add hl, de                                    ; $6411
    ld a, [hl]                                    ; $6412
    pop hl                                        ; $6413
    cp [hl]                                       ; $6414
    jr c, jr_007_6425                             ; $6415

    inc hl                                        ; $6417
    ld a, [hl+]                                   ; $6418
    inc a                                         ; $6419
    ld a, [hl]                                    ; $641A
    ld hl, wSpriteAnimFrame + $2                  ; $641B
    add hl, de                                    ; $641E
    jr z, jr_007_6423                             ; $641F

    ld a, [hl]                                    ; $6421
    inc a                                         ; $6422

jr_007_6423:
    ld [hl], a                                    ; $6423
    xor a                                         ; $6424

jr_007_6425:
    inc a                                         ; $6425
    ld hl, wSpriteAnimTick + $2                   ; $6426
    add hl, de                                    ; $6429
    ld [hl], a                                    ; $642A
    pop bc                                        ; $642B
    dec e                                         ; $642C
    bit 7, e                                      ; $642D
    jr z, SpaceFever_DrawEnemies                  ; $642F

    ret                                           ; $6431


; C: sprite ids from $62 up are boss pieces
SpaceFever_DrawEnemySprite::
    cp $62                                        ; $6432
    jp c, Oam_AddMeta_B01_5D2B                    ; $6434

    push af                                       ; $6437
    sub $62                                       ; $6438
    ld [wShootBossMaskIdx], a                     ; $643A
    ld a, b                                       ; $643D
    cp $60                                        ; $643E
    jr c, jr_007_6446                             ; $6440

    pop af                                        ; $6442
    jp Oam_AddMeta_B01_5D2B                       ; $6443


jr_007_6446:
    pop af                                        ; $6446
    add $03                                       ; $6447
    jp Oam_AddMeta_B01_5D2B                       ; $6449


; C: round-robin of 8 bullet slots
SpaceFever_FireBullet::
    ld hl, wShootBulletRr                         ; $644C
    inc [hl]                                      ; $644F
    ld a, [hl]                                    ; $6450
    and $07                                       ; $6451
    ld c, a                                       ; $6453
    ld b, $00                                     ; $6454
    ld hl, wShootBulletY                          ; $6456
    add hl, bc                                    ; $6459
    ld a, [hl]                                    ; $645A
    cp $a0                                        ; $645B
    ret c                                         ; $645D

    ld hl, wShootEnemyY                           ; $645E
    add hl, de                                    ; $6461
    ld a, [hl]                                    ; $6462
    cp $a0                                        ; $6463
    ret nc                                        ; $6465

    ld hl, wShootEnemyX                           ; $6466
    add hl, de                                    ; $6469
    ld a, [hl]                                    ; $646A
    cp $50                                        ; $646B
    ret nc                                        ; $646D

    ld hl, wShootEnemyX                           ; $646E
    add hl, de                                    ; $6471
    ld a, [hl]                                    ; $6472
    ld hl, wShootBulletX                          ; $6473
    add hl, bc                                    ; $6476
    ld [hl], a                                    ; $6477
    ld hl, wShootEnemyY                           ; $6478
    add hl, de                                    ; $647B
    ld a, [hl]                                    ; $647C
    ld hl, wShootBulletY                          ; $647D
    add hl, bc                                    ; $6480
    ld [hl], a                                    ; $6481
    ret                                           ; $6482


; C
SpaceFever_ClearBullets::
    ld a, $a0                                     ; $6483
    ld hl, wShootBulletY                          ; $6485
    ld b, $08                                     ; $6488

jr_007_648a:
    ld [hl+], a                                   ; $648A
    dec b                                         ; $648B
    jr nz, jr_007_648a                            ; $648C

    ret                                           ; $648E


; C: A = bullets on screen
SpaceFever_CountBullets::
    ld hl, wShootBulletY                          ; $648F
    ld bc, $0800                                  ; $6492

jr_007_6495:
    ld a, [hl+]                                   ; $6495
    cp $a0                                        ; $6496
    jr nc, jr_007_649b                            ; $6498

    inc c                                         ; $649A

jr_007_649b:
    dec b                                         ; $649B
    jr nz, jr_007_6495                            ; $649C

    ld a, c                                       ; $649E
    ret                                           ; $649F


; C: alternates single / pair at x-16; x+16
SpaceFever_FireBulletPair::
    xor a                                         ; $64A0
    ldh [hScratchA], a                            ; $64A1
    ld a, [wShootBulletPairToggle]                ; $64A3
    inc a                                         ; $64A6
    and $01                                       ; $64A7
    ld [wShootBulletPairToggle], a                ; $64A9
    jr z, SpaceFever_FireBulletAt                 ; $64AC

    ld a, $f0                                     ; $64AE
    ldh [hScratchA], a                            ; $64B0
    call SpaceFever_FireBulletAt                  ; $64B2
    ld a, $10                                     ; $64B5
    ldh [hScratchA], a                            ; $64B7

; C: spawns one bullet slot from enemy DE with the x offset in scratch_a ($FF8A); called twice by
; SpaceFever_FireBulletPair (single bullet: falls through from the toggle). L3 pass 2026-10-26: not reached by the 206
; BGB replays; executed in the organic runs of the core emulator ...
SpaceFever_FireBulletAt::
    ld hl, wShootBulletRr                         ; $64B9
    inc [hl]                                      ; $64BC
    ld a, [hl]                                    ; $64BD
    and $07                                       ; $64BE
    ld c, a                                       ; $64C0
    ld b, $00                                     ; $64C1
    ld hl, wShootBulletY                          ; $64C3
    add hl, bc                                    ; $64C6
    ld a, [hl]                                    ; $64C7
    cp $a0                                        ; $64C8
    ret c                                         ; $64CA

    ld hl, wShootEnemyY                           ; $64CB
    add hl, de                                    ; $64CE
    ld a, [hl]                                    ; $64CF
    cp $a0                                        ; $64D0
    ret nc                                        ; $64D2

    ld hl, wShootEnemyX                           ; $64D3
    add hl, de                                    ; $64D6
    ld a, [hl]                                    ; $64D7
    cp $50                                        ; $64D8
    ret nc                                        ; $64DA

    ld hl, wShootEnemyX                           ; $64DB
    add hl, de                                    ; $64DE
    ld a, [hl]                                    ; $64DF
    ld hl, hScratchA                              ; $64E0
    add [hl]                                      ; $64E3
    ld hl, wShootBulletX                          ; $64E4
    add hl, bc                                    ; $64E7
    ld [hl], a                                    ; $64E8
    ld hl, wShootEnemyY                           ; $64E9
    add hl, de                                    ; $64EC
    ld a, [hl]                                    ; $64ED
    ld hl, wShootBulletY                          ; $64EE
    add hl, bc                                    ; $64F1
    ld [hl], a                                    ; $64F2
    ret                                           ; $64F3


; C: 2 px down per frame; sprite $5D
SpaceFever_DrawBullets::
    ld de, $0007                                  ; $64F4

jr_007_64f7:
    ld hl, wShootBulletY                          ; $64F7
    add hl, de                                    ; $64FA
    ld a, [hl]                                    ; $64FB
    cp $a0                                        ; $64FC
    jr nc, jr_007_6513                            ; $64FE

    inc a                                         ; $6500
    inc a                                         ; $6501
    ld [hl], a                                    ; $6502
    ld c, a                                       ; $6503
    ld hl, wShootBulletX                          ; $6504
    add hl, de                                    ; $6507
    ld a, [hl]                                    ; $6508
    add $48                                       ; $6509
    ld b, a                                       ; $650B
    ld a, $5d                                     ; $650C
    push de                                       ; $650E
    call Oam_AddMeta_B01_5D2B                     ; $650F
    pop de                                        ; $6512

jr_007_6513:
    dec e                                         ; $6513
    bit 7, e                                      ; $6514
    jr z, jr_007_64f7                             ; $6516

    ret                                           ; $6518


; C: run-length delta list to $CE00 x;y pairs (README 2.4)
SpaceFever_DecodePath::
    xor a                                         ; $6519
    ld b, $02                                     ; $651A
    push de                                       ; $651C

jr_007_651d:
    ld c, [hl]                                    ; $651D
    inc hl                                        ; $651E
    inc c                                         ; $651F
    dec c                                         ; $6520
    jr z, jr_007_653f                             ; $6521

    bit 7, c                                      ; $6523
    jr nz, jr_007_6531                            ; $6525

jr_007_6527:
    add [hl]                                      ; $6527
    ld [de], a                                    ; $6528
    inc hl                                        ; $6529
    inc de                                        ; $652A
    inc de                                        ; $652B
    dec c                                         ; $652C
    jr nz, jr_007_6527                            ; $652D

    jr jr_007_651d                                ; $652F

jr_007_6531:
    res 7, c                                      ; $6531
    inc c                                         ; $6533
    inc c                                         ; $6534

jr_007_6535:
    add [hl]                                      ; $6535
    ld [de], a                                    ; $6536
    inc de                                        ; $6537
    inc de                                        ; $6538
    dec c                                         ; $6539
    jr nz, jr_007_6535                            ; $653A

    inc hl                                        ; $653C
    jr jr_007_651d                                ; $653D

jr_007_653f:
    pop de                                        ; $653F
    inc de                                        ; $6540
    push de                                       ; $6541
    xor a                                         ; $6542
    dec b                                         ; $6543
    jr nz, jr_007_651d                            ; $6544

    pop de                                        ; $6546
    ret                                           ; $6547


; C: shots vs enemies; enemies vs player; bullets vs player/shots
SpaceFever_Collide_Waves::
    call SpaceFever_ShotVsEnemy                   ; $6548
    call SpaceFever_EnemyVsPlayer                 ; $654B
    call SpaceFever_BulletVsPlayer                ; $654E
    call SpaceFever_ShotVsBullet                  ; $6551
    ret                                           ; $6554


; C: shots vs boss; player collisions
SpaceFever_Collide_Boss::
    call SpaceFever_ShotVsBoss                    ; $6555
    call SpaceFever_EnemyVsPlayer                 ; $6558
    call SpaceFever_BulletVsPlayer                ; $655B
    call SpaceFever_ShotVsBullet                  ; $655E
    ret                                           ; $6561


; C
SpaceFever_ShotVsEnemy::
    ld de, $0007                                  ; $6562

jr_007_6565:
    ld hl, wShootShotY                            ; $6565
    add hl, de                                    ; $6568
    ld a, [hl]                                    ; $6569
    cp $fc                                        ; $656A
    jr nc, jr_007_6594                            ; $656C

    ld bc, $0002                                  ; $656E

jr_007_6571:
    push af                                       ; $6571
    ld hl, wShootEnemyY                           ; $6572
    add hl, bc                                    ; $6575
    sub [hl]                                      ; $6576
    add $08                                       ; $6577
    cp $10                                        ; $6579
    jr nc, jr_007_658e                            ; $657B

    ld hl, wShootShotX                            ; $657D
    add hl, de                                    ; $6580
    ld a, [hl]                                    ; $6581
    ld hl, wShootEnemyX                           ; $6582
    add hl, bc                                    ; $6585
    sub [hl]                                      ; $6586
    add $06                                       ; $6587
    cp $0c                                        ; $6589
    call c, SpaceFever_EnemyHit                   ; $658B

jr_007_658e:
    pop af                                        ; $658E
    dec c                                         ; $658F
    bit 7, c                                      ; $6590
    jr z, jr_007_6571                             ; $6592

jr_007_6594:
    dec e                                         ; $6594
    bit 7, e                                      ; $6595
    jr z, jr_007_6565                             ; $6597

    ret                                           ; $6599


; C: double-shot bonus
SpaceFever_EnemyHit::
    ld hl, wShootEnemyState                       ; $659A
    add hl, bc                                    ; $659D
    ld a, [hl]                                    ; $659E
    and a                                         ; $659F
    ret nz                                        ; $65A0

    ld [hl], $01                                  ; $65A1
    ld hl, wShootShotY                            ; $65A3
    add hl, de                                    ; $65A6
    ld [hl], $fc                                  ; $65A7
    ld a, [wShootFireCount]                       ; $65A9
    bit 0, a                                      ; $65AC
    jr z, jr_007_65d6                             ; $65AE

    ld a, [wShootDoubleHits]                      ; $65B0
    inc a                                         ; $65B3
    ld [wShootDoubleHits], a                      ; $65B4
    cp $02                                        ; $65B7
    jr nz, jr_007_65d6                            ; $65B9

    ld hl, wShootEnemyState                       ; $65BB
    add hl, bc                                    ; $65BE
    set 7, [hl]                                   ; $65BF
    ld a, $2d                                     ; $65C1
    ld [wShootFlashTimer], a                      ; $65C3
    ld hl, wShootEnemyX                           ; $65C6
    add hl, bc                                    ; $65C9
    ld a, [hl]                                    ; $65CA
    ld [wShootFlashXy], a                         ; $65CB
    ld hl, wShootEnemyY                           ; $65CE
    add hl, bc                                    ; $65D1
    ld a, [hl]                                    ; $65D2
    ld [wShootFlashXy + $1], a                    ; $65D3

jr_007_65d6:
    ld c, $00                                     ; $65D6
    ret                                           ; $65D8


; C
SpaceFever_EnemyVsPlayer::
    ld a, [wSpriteAnimFrame]                      ; $65D9
    cp $02                                        ; $65DC
    ret nc                                        ; $65DE

    ld a, $88                                     ; $65DF
    ld bc, $0002                                  ; $65E1

jr_007_65e4:
    push af                                       ; $65E4
    ld hl, wShootEnemyY                           ; $65E5
    add hl, bc                                    ; $65E8
    sub [hl]                                      ; $65E9
    add $06                                       ; $65EA
    cp $0c                                        ; $65EC
    jr nc, jr_007_65ff                            ; $65EE

    ld a, [wShootPlayerX]                         ; $65F0
    ld hl, wShootEnemyX                           ; $65F3
    add hl, bc                                    ; $65F6
    sub [hl]                                      ; $65F7
    add $06                                       ; $65F8
    cp $0c                                        ; $65FA
    call c, SpaceFever_PlayerDie                  ; $65FC

jr_007_65ff:
    pop af                                        ; $65FF
    dec c                                         ; $6600
    bit 7, c                                      ; $6601
    jr z, jr_007_65e4                             ; $6603

    ret                                           ; $6605


; C
SpaceFever_PlayerDie::
    ld a, $02                                     ; $6606
    ld [wSpriteAnimFrame], a                      ; $6608
    xor a                                         ; $660B
    ld [wSpriteAnimTick], a                       ; $660C
    ld a, $01                                     ; $660F
    ld [wShootPlayerDied], a                      ; $6611
    play_sfx4 SFX4_SPACE_FEVER_PLAYER_DEATH       ; $6614
    ret                                           ; $661B


; C
SpaceFever_BulletVsPlayer::
    ld a, [wSpriteAnimFrame]                      ; $661C
    cp $02                                        ; $661F
    ret nc                                        ; $6621

    ld a, $88                                     ; $6622
    ld bc, $0007                                  ; $6624

jr_007_6627:
    push af                                       ; $6627
    ld hl, wShootBulletY                          ; $6628
    add hl, bc                                    ; $662B
    sub [hl]                                      ; $662C
    add $08                                       ; $662D
    cp $10                                        ; $662F
    jr nc, jr_007_6642                            ; $6631

    ld a, [wShootPlayerX]                         ; $6633
    ld hl, wShootBulletX                          ; $6636
    add hl, bc                                    ; $6639
    sub [hl]                                      ; $663A
    add $04                                       ; $663B
    cp $08                                        ; $663D
    call c, SpaceFever_PlayerDieB                 ; $663F

jr_007_6642:
    pop af                                        ; $6642
    dec c                                         ; $6643
    bit 7, c                                      ; $6644
    jr z, jr_007_6627                             ; $6646

    ret                                           ; $6648


; C: duplicate of 6644
SpaceFever_PlayerDieB::
    ld a, $02                                     ; $6649
    ld [wSpriteAnimFrame], a                      ; $664B
    xor a                                         ; $664E
    ld [wSpriteAnimTick], a                       ; $664F
    ld a, $01                                     ; $6652
    ld [wShootPlayerDied], a                      ; $6654
    play_sfx4 SFX4_SPACE_FEVER_PLAYER_DEATH       ; $6657
    ret                                           ; $665E


; C
SpaceFever_ShotVsBullet::
    ld de, $0007                                  ; $665F

jr_007_6662:
    ld hl, wShootShotY                            ; $6662
    add hl, de                                    ; $6665
    ld a, [hl]                                    ; $6666
    cp $fc                                        ; $6667
    jr nc, jr_007_6691                            ; $6669

    ld bc, $0007                                  ; $666B

jr_007_666e:
    push af                                       ; $666E
    ld hl, wShootBulletY                          ; $666F
    add hl, bc                                    ; $6672
    sub [hl]                                      ; $6673
    add $03                                       ; $6674
    cp $06                                        ; $6676
    jr nc, jr_007_668b                            ; $6678

    ld hl, wShootShotX                            ; $667A
    add hl, de                                    ; $667D
    ld a, [hl]                                    ; $667E
    ld hl, wShootBulletX                          ; $667F
    add hl, bc                                    ; $6682
    sub [hl]                                      ; $6683
    add $03                                       ; $6684
    cp $06                                        ; $6686
    call c, SpaceFever_ShotCancelsBullet          ; $6688

jr_007_668b:
    pop af                                        ; $668B
    dec c                                         ; $668C
    bit 7, c                                      ; $668D
    jr z, jr_007_666e                             ; $668F

jr_007_6691:
    dec e                                         ; $6691
    bit 7, e                                      ; $6692
    jr z, jr_007_6662                             ; $6694

    ret                                           ; $6696


; C
SpaceFever_ShotCancelsBullet::
    push bc                                       ; $6697
    ld a, $01                                     ; $6698
    call SpaceFever_AddScore                      ; $669A
    pop bc                                        ; $669D
    ld hl, wShootBulletY                          ; $669E
    add hl, bc                                    ; $66A1
    ld [hl], $a0                                  ; $66A2
    ld hl, wShootShotY                            ; $66A4
    add hl, de                                    ; $66A7
    ld [hl], $fc                                  ; $66A8
    ret                                           ; $66AA


; C: only in wave state 9
SpaceFever_ShotVsBoss::
    ld a, [wSpriteAnimFrame + $2]                 ; $66AB
    cp $05                                        ; $66AE
    ret nc                                        ; $66B0

    ld bc, $0007                                  ; $66B1

jr_007_66b4:
    ld hl, wShootShotY                            ; $66B4
    add hl, bc                                    ; $66B7
    ld a, [hl]                                    ; $66B8
    cp $fc                                        ; $66B9
    jr nc, jr_007_66f7                            ; $66BB

    ld hl, wShootEnemyY                           ; $66BD
    sub [hl]                                      ; $66C0
    add $20                                       ; $66C1
    cp $38                                        ; $66C3
    jr nc, jr_007_66f7                            ; $66C5

    and $f8                                       ; $66C7
    ld e, a                                       ; $66C9
    ld hl, wShootShotX                            ; $66CA
    add hl, bc                                    ; $66CD
    ld a, [hl]                                    ; $66CE
    ld hl, wShootEnemyX                           ; $66CF
    sub [hl]                                      ; $66D2
    add $20                                       ; $66D3
    cp $40                                        ; $66D5
    jr nc, jr_007_66f7                            ; $66D7

    srl a                                         ; $66D9
    srl a                                         ; $66DB
    srl a                                         ; $66DD
    add e                                         ; $66DF
    ld e, a                                       ; $66E0
    ld a, [wShootBossMaskIdx]                     ; $66E1
    sla a                                         ; $66E4
    sla a                                         ; $66E6
    swap a                                        ; $66E8
    add e                                         ; $66EA
    ld e, a                                       ; $66EB
    ld d, $00                                     ; $66EC
    ld hl, wCollisionMask0                        ; $66EE
    add hl, de                                    ; $66F1
    ld a, [hl]                                    ; $66F2
    and a                                         ; $66F3
    call nz, SpaceFever_BossHit                   ; $66F4

jr_007_66f7:
    dec c                                         ; $66F7
    bit 7, c                                      ; $66F8
    jr z, jr_007_66b4                             ; $66FA

    ret                                           ; $66FC


; C: 50 hits kill it; bonus 50 x table[D88F]
SpaceFever_BossHit::
    ld hl, wShootBossHits                         ; $66FD
    inc [hl]                                      ; $6700
    ld a, [wShootBossHits]                        ; $6701
    cp $32                                        ; $6704
    jr nc, jr_007_671b                            ; $6706

    play_sfx3 SFX3_SPACE_FEVER_BOSS_HIT           ; $6708
    ld hl, wSpriteAnimFrame + $2                  ; $670F
    ld [hl], $03                                  ; $6712
    ld hl, wSpriteAnimTick + $2                   ; $6714
    ld [hl], $00                                  ; $6717
    jr jr_007_674d                                ; $6719

jr_007_671b:
    play_sfx1 SFX1_SPACE_FEVER_BOSS_DEATH         ; $671B
    push bc                                       ; $6722
    push de                                       ; $6723
    ld c, $03                                     ; $6724
    call SpaceFever_LoadBossTilesC                ; $6726
    pop de                                        ; $6729
    pop bc                                        ; $672A
    ld hl, wSpriteAnimFrame + $2                  ; $672B
    ld [hl], $05                                  ; $672E
    ld hl, wSpriteAnimTick + $2                   ; $6730
    ld [hl], $00                                  ; $6733
    xor a                                         ; $6735
    ld [wShootBossTimer], a                       ; $6736
    push bc                                       ; $6739
    ld a, [wShootBossVariant]                     ; $673A
    ld c, a                                       ; $673D
    ld b, $00                                     ; $673E
    ld hl, SpaceFever_BossHit_Tbl6754             ; $6740
    add hl, bc                                    ; $6743
    ld c, [hl]                                    ; $6744
    ld a, $50                                     ; $6745
    call SpaceFever_AddScoreRepeat                ; $6747
    pop bc                                        ; $674A
    ld c, $00                                     ; $674B

jr_007_674d:
    ld hl, wShootShotY                            ; $674D
    add hl, bc                                    ; $6750
    ld [hl], $fc                                  ; $6751
    ret                                           ; $6753


; C: auto: 5 bytes, bytes; referenced by SpaceFever_BossHit. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: table read when the boss is hit (jr_007_6759)
SpaceFever_BossHit_Tbl6754::
    db $04, $08, $10, $20, $40

; C: compares the score with DAA0-DAA3 (SRAM $10C5)
SpaceFever_UpdateBest::
    ld de, wShootScoreBcd + $3                    ; $6759
    ld hl, wBestShooter + $3                      ; $675C
    ld b, $04                                     ; $675F

jr_007_6761:
    ld a, [de]                                    ; $6761
    cp [hl]                                       ; $6762
    ret c                                         ; $6763

    jr nz, jr_007_676c                            ; $6764

    dec de                                        ; $6766
    dec hl                                        ; $6767
    dec b                                         ; $6768
    jr nz, jr_007_6761                            ; $6769

    ret                                           ; $676B


jr_007_676c:
    ld de, wShootScoreBcd                         ; $676C
    ld hl, wBestShooter                           ; $676F
    ld b, $04                                     ; $6772

jr_007_6774:
    ld a, [de]                                    ; $6774
    ld [hl+], a                                   ; $6775
    inc de                                        ; $6776
    dec b                                         ; $6777
    jr nz, jr_007_6774                            ; $6778

    ld a, $01                                     ; $677A
    ld [wShootNewBestFlag], a                     ; $677C
    ret                                           ; $677F


; C: repeated Bcd_AddSaturate
SpaceFever_AddScoreRepeat::
    dec c                                         ; $6780

jr_007_6781:
    push af                                       ; $6781
    ld hl, wShootScoreBcd                         ; $6782
    ld b, $04                                     ; $6785
    call Bcd_AddSaturate                          ; $6787
    pop af                                        ; $678A
    dec c                                         ; $678B
    jr nz, jr_007_6781                            ; $678C

; C: A = points (BCD) to $D868-$D86B; then draws at $980A
SpaceFever_AddScore::
    push de                                       ; $678E
    ld hl, wShootScoreBcd                         ; $678F
    ld b, $04                                     ; $6792
    call Bcd_AddSaturate                          ; $6794
    call SpaceFever_UpdateBest                    ; $6797
    ld de, wShootScoreBcd + $3                    ; $679A
    ld hl, $980a                                  ; $679D
    call SpaceFever_DrawScore                     ; $67A0
    pop de                                        ; $67A3
    ret                                           ; $67A4


; C
SpaceFever_LoadHudTiles::
    farcopy Vram_CopyFromBank, Gfx_21_4750_SpaceFever_LoadHudTiles, $9750, $0060 ; $67A5
    farcopy Vram_CopyFromBank, Gfx_21_4850_SpaceFever_LoadHudTiles, $8850, $0060 ; $67B3
    ld a, BANK(Map_22_7F40_SpaceFever_LoadHudTiles); $67C1
    ld hl, Map_22_7F40_SpaceFever_LoadHudTiles    ; $67C3
    ld de, $98c9                                  ; $67C6
    ld b, $06                                     ; $67C9
    call SpaceFever_CopyTextRows                  ; $67CB
    ret                                           ; $67CE


; C
SpaceFever_DrawGameOverHud::
    ld a, BANK(Src_27_6D50_Tbl53A6_5)             ; $67CF
    ld hl, Src_27_6D50_Tbl53A6_5 + $180           ; $67D1
    ld de, $9889                                  ; $67D4
    ld b, $05                                     ; $67D7
    call SpaceFever_CopyTextRows                  ; $67D9
    ld de, wShootScoreBcd + $3                    ; $67DC
    ld hl, $992a                                  ; $67DF
    call SpaceFever_DrawScore                     ; $67E2
    ld a, BANK(Src_27_6D50_Tbl53A6_5)             ; $67E5
    ld hl, Src_27_6D50_Tbl53A6_5 + $260           ; $67E7
    ld de, $9969                                  ; $67EA
    ld b, $03                                     ; $67ED
    call SpaceFever_CopyTextRows                  ; $67EF
    ret                                           ; $67F2


; C
SpaceFever_DrawBestHud::
    farcopy Vram_CopyFromBank, Sheet_MinigamesSpaceFeverIi_21_49FC_Part4C00, $9750, $0060 ; $67F3
    farcopy Vram_CopyFromBank, Gfx_21_4C60_SpaceFever_DrawBestHud, $8850, $0060 ; $6801
    ld a, BANK(Src_27_6D50_Tbl53A6_5)             ; $680F
    ld hl, Src_27_6D50_Tbl53A6_5 + $2C0           ; $6811
    ld de, $9889                                  ; $6814
    ld b, $05                                     ; $6817
    call SpaceFever_CopyTextRows                  ; $6819
    ld de, wBestShooter + $3                      ; $681C
    ld hl, $992a                                  ; $681F
    call SpaceFever_DrawScore                     ; $6822
    ld a, BANK(Src_27_6D50_Tbl53A6_5)             ; $6825
    ld hl, Src_27_6D50_Tbl53A6_5 + $3A0           ; $6827
    ld de, $9969                                  ; $682A
    ld b, $03                                     ; $682D
    call SpaceFever_CopyTextRows                  ; $682F
    ret                                           ; $6832


; C: 8 BCD digits with leading zeros skipped
SpaceFever_DrawScore::
    ld bc, $040a                                  ; $6833

jr_007_6836:
    ld a, [de]                                    ; $6836
    swap a                                        ; $6837
    call SpaceFever_DrawDigit                     ; $6839
    ld a, b                                       ; $683C
    cp $01                                        ; $683D
    jr nz, jr_007_6843                            ; $683F

    ld c, $00                                     ; $6841

jr_007_6843:
    ld a, [de]                                    ; $6843
    call SpaceFever_DrawDigit                     ; $6844
    dec de                                        ; $6847
    dec b                                         ; $6848
    jr nz, jr_007_6836                            ; $6849

    ret                                           ; $684B


; C
SpaceFever_DrawDigit::
    push de                                       ; $684C
    push hl                                       ; $684D
    and $0f                                       ; $684E
    jr z, jr_007_6854                             ; $6850

    ld c, $00                                     ; $6852

jr_007_6854:
    or c                                          ; $6854
    sla a                                         ; $6855
    ld e, a                                       ; $6857
    ld d, $00                                     ; $6858
    ld hl, SpaceFever_DigitTileTbl                ; $685A
    add hl, de                                    ; $685D
    ld a, [hl+]                                   ; $685E
    ld e, [hl]                                    ; $685F
    pop hl                                        ; $6860
    push hl                                       ; $6861
    call Vram_WriteByteSafe                       ; $6862
    ld a, l                                       ; $6865
    add $20                                       ; $6866
    ld l, a                                       ; $6868
    jr nc, jr_007_686c                            ; $6869

    inc h                                         ; $686B

jr_007_686c:
    ld a, e                                       ; $686C
    call Vram_WriteByteSafe                       ; $686D
    pop hl                                        ; $6870
    pop de                                        ; $6871
    inc hl                                        ; $6872
    ret                                           ; $6873


; C: L3 pass 2026-10-26: read in BGB in 13 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_DigitTileTbl::
    db $60, $61, $62, $63, $64, $65, $64, $66, $67, $68, $69, $6a, $69, $57, $64, $63
    db $60, $58, $60, $68, $bf, $bf

; C
SpaceFever_DrawChoiceText::
    ld a, BANK(Map_25_55C0_Mode07_State00_Init)   ; $688A
    ld hl, Map_25_55C0_Mode07_State00_Init + $89  ; $688C
    ld de, $9889                                  ; $688F
    ld b, $0a                                     ; $6892
    call SpaceFever_CopyTextRows                  ; $6894
    ret                                           ; $6897


; C: B rows of 10 tiles from bank A to HL
SpaceFever_CopyTextRows::
    push af                                       ; $6898
    push bc                                       ; $6899
    push de                                       ; $689A
    push hl                                       ; $689B
    ld bc, $000a                                  ; $689C
    call Vram_CopyFromBank                        ; $689F
    pop hl                                        ; $68A2
    pop de                                        ; $68A3
    pop bc                                        ; $68A4
    ld a, l                                       ; $68A5
    add $20                                       ; $68A6
    ld l, a                                       ; $68A8
    jr nc, jr_007_68ac                            ; $68A9

    inc h                                         ; $68AB

jr_007_68ac:
    ld a, e                                       ; $68AC
    add $20                                       ; $68AD
    ld e, a                                       ; $68AF
    jr nc, jr_007_68b3                            ; $68B0

    inc d                                         ; $68B2

jr_007_68b3:
    pop af                                        ; $68B3
    dec b                                         ; $68B4
    jr nz, SpaceFever_CopyTextRows                ; $68B5

    ret                                           ; $68B7


; I: VRAM $8000
SpaceFever_LoadBossTilesA::
    call SpaceFever_GetBossGfxBank                ; $68B8
    ldh [hFarcallAArg], a                         ; $68BB
    ld a, BANK(Album_LoadNumeralTileB)            ; $68BD
    ld hl, Album_LoadNumeralTileB_7CE3            ; $68BF
    call Far_Call                                 ; $68C2
    ld de, $8000                                  ; $68C5
    call SpaceFever_CopyBossTiles                 ; $68C8
    ret                                           ; $68CB


; I: VRAM $8400
SpaceFever_LoadBossTilesB::
    call SpaceFever_GetBossGfxBank                ; $68CC
    ldh [hFarcallAArg], a                         ; $68CF
    ld a, BANK(Album_LoadNumeralTileB)            ; $68D1
    ld hl, Album_LoadNumeralTileB_7CE3            ; $68D3
    call Far_Call                                 ; $68D6
    ld de, $8400                                  ; $68D9
    call SpaceFever_CopyBossTiles                 ; $68DC
    ret                                           ; $68DF


; I: VRAM $8C00
SpaceFever_LoadBossTilesC::
    call SpaceFever_GetBossGfxBank                ; $68E0
    ldh [hFarcallAArg], a                         ; $68E3
    ld a, BANK(Album_LoadNumeralTileB)            ; $68E5
    ld hl, Album_LoadNumeralTileB_7CE3            ; $68E7
    call Far_Call                                 ; $68EA
    ld de, $8c00                                  ; $68ED
    call SpaceFever_CopyBossTiles                 ; $68F0
    ret                                           ; $68F3


; C
SpaceFever_GetBossGfxBank::
    push bc                                       ; $68F4
    ld a, [wShootBossVariant]                     ; $68F5
    cp $02                                        ; $68F8
    jr nz, jr_007_6904                            ; $68FA

    ld hl, wGamefacePresent                       ; $68FC
    bit 0, [hl]                                   ; $68FF
    jr nz, jr_007_6904                            ; $6901

    inc a                                         ; $6903

jr_007_6904:
    ld c, a                                       ; $6904
    ld b, $00                                     ; $6905
    ld hl, SpaceFever_BossGfxBankTbl              ; $6907
    add hl, bc                                    ; $690A
    ld a, [hl]                                    ; $690B
    pop bc                                        ; $690C
    ret                                           ; $690D


; I: 05 04 06 01
SpaceFever_BossGfxBankTbl::
    db $05, $04, $08, $04

; C
SpaceFever_CopyBossTiles::
    ldh [hScratchA], a                            ; $6912
    ld b, $03                                     ; $6914

jr_007_6916:
    push bc                                       ; $6916
    ld c, $08                                     ; $6917

jr_007_6919:
    push bc                                       ; $6919
    ld bc, $0010                                  ; $691A
    ldh a, [hScratchA]                            ; $691D
    call Vram_CopyFromBank_4                      ; $691F
    ld bc, $0070                                  ; $6922
    add hl, bc                                    ; $6925
    ld bc, $0010                                  ; $6926
    ldh a, [hScratchA]                            ; $6929
    call Vram_CopyFromBank_4                      ; $692B
    ld bc, $ff80                                  ; $692E
    add hl, bc                                    ; $6931
    pop bc                                        ; $6932
    dec c                                         ; $6933
    jr nz, jr_007_6919                            ; $6934

    ld bc, $0080                                  ; $6936
    add hl, bc                                    ; $6939
    pop bc                                        ; $693A
    dec b                                         ; $693B
    jr nz, jr_007_6916                            ; $693C

    ld b, $08                                     ; $693E

jr_007_6940:
    push bc                                       ; $6940
    ld bc, $0010                                  ; $6941
    ldh a, [hScratchA]                            ; $6944
    call Vram_CopyFromBank_4                      ; $6946
    call SpaceFever_ClearVramBlock                ; $6949
    pop bc                                        ; $694C
    dec b                                         ; $694D
    jr nz, jr_007_6940                            ; $694E

    ret                                           ; $6950


; C: L3 pass 2026-10-26: executed in BGB in 7 replay(s) of the organic corpus, modes 07 (tcrf_check/assets/l3_names/)
SpaceFever_ClearVramBlock::
    push hl                                       ; $6951
    ld h, d                                       ; $6952
    ld l, e                                       ; $6953
    ld bc, $0010                                  ; $6954
    call Vram_ClearSafe                           ; $6957
    ld d, h                                       ; $695A
    ld e, l                                       ; $695B
    pop hl                                        ; $695C
    ret                                           ; $695D


; C: save-photo dialog (far call from banks 3/4; 6 substates)
SaveDialog_Far::
    ld a, [wSubstate]                             ; $695E
    rst Rst18_JumpTable                           ; $6961

; I
SaveDialog_SubstateTbl::
    dw SaveDialog_Substate0_Init
    dw SaveDialog_Substate1_WaitKey
    dw SaveDialog_Substate2_Answer
    dw SaveDialog_Substate3_FullInit
    dw SaveDialog_Substate4_WaitKey
    dw SaveDialog_Substate5_Finish

; C: album full (>= $1E) goes to substate 3
SaveDialog_Substate0_Init::
    ld a, [wSaveTargetPhoto]                      ; $696E
    cp $1e                                        ; $6971
    jr c, jr_007_697d                             ; $6973

    ld a, $03                                     ; $6975
    ld [wSubstate], a                             ; $6977
    jp Far_Call_Return                            ; $697A


jr_007_697d:
    farcopy Vram_CopyFromBank, Gfx_21_65C0_SaveDialog_Substate0_Init, $8b00, $04f0 ; $697D
    farcopy Vram_CopyFromBank, Map_27_74B0_SaveDialog_Substate0_Init, $9c00, $0120 ; $698B
    xor a                                         ; $6999
    ld [wSaveDialogScratch], a                    ; $699A
    call Oam_ClearShadow                          ; $699D
    call SaveDialog_SlideIn                       ; $69A0
    ld hl, wSubstate                              ; $69A3
    inc [hl]                                      ; $69A6
    jp Far_Call_Return                            ; $69A7


; C
SaveDialog_Substate1_WaitKey::
    ldh a, [hKeysNew]                             ; $69AA
    and PADF_A | PADF_B                           ; $69AC
    ld [wAbResult], a                             ; $69AE
    jp z, Far_Call_Return                         ; $69B1

    push af                                       ; $69B4
    bit 0, a                                      ; $69B5
    ld a, SFX3_DELETE_DIALOG_FIRST                ; $69B7
    call nz, Snd_Sfx3                             ; $69B9
    pop af                                        ; $69BC
    push af                                       ; $69BD
    bit 1, a                                      ; $69BE
    ld a, SFX3_DELETE_DIALOG_SECOND               ; $69C0
    call nz, Snd_Sfx3                             ; $69C2
    pop af                                        ; $69C5
    ld hl, wSubstate                              ; $69C6
    inc [hl]                                      ; $69C9
    jp Far_Call_Return                            ; $69CA


; C: A saves the photo
SaveDialog_Substate2_Answer::
    call SaveDialog_SlideOut                      ; $69CD
    ld a, [wAbResult]                             ; $69D0
    bit 0, a                                      ; $69D3
    jr z, jr_007_69df                             ; $69D5

    ld a, [wSaveTargetPhoto]                      ; $69D7
    cp $1e                                        ; $69DA
    call c, SaveDialog_StoreEditedPhoto           ; $69DC

jr_007_69df:
    ld hl, wSubstate                              ; $69DF
    inc [hl]                                      ; $69E2
    jp Far_Call_Return                            ; $69E3


; C: VRAM to $C000 buffer; far calls 02:47C4 / 02:4C37 / 02:488F
SaveDialog_StoreEditedPhoto::
    ld a, [wSaveDialogWhat]                       ; $69E6
    bit 0, a                                      ; $69E9
    jr z, jr_007_6a36                             ; $69EB

    ld a, $00                                     ; $69ED
    ld hl, $9000                                  ; $69EF
    ld de, wPhotoImage                            ; $69F2
    ld bc, $0800                                  ; $69F5
    call Vram_CopyFromBank_4                      ; $69F8
    ld a, $00                                     ; $69FB
    ld hl, $8800                                  ; $69FD
    ld de, wPhotoImage + $800                     ; $6A00
    ld bc, $0100                                  ; $6A03
    call Vram_CopyFromBank_4                      ; $6A06
    ld a, $00                                     ; $6A09
    ld hl, $8000                                  ; $6A0B
    ld de, wPhotoImage + $900                     ; $6A0E
    ld bc, $0500                                  ; $6A11
    call Vram_CopyFromBank_4                      ; $6A14
    ld a, [wDoodleFromShutterbug]                 ; $6A17
    and a                                         ; $6A1A
    jr nz, jr_007_6a2c                            ; $6A1B

    ld a, [wSaveTargetPhoto]                      ; $6A1D
    ldh [hFarcallAArg], a                         ; $6A20
    farcall Photo_StoreImage_Far                  ; $6A22
    jr jr_007_6a36                                ; $6A2A

jr_007_6a2c:
    ldh [hFarcallAArg], a                         ; $6A2C
    farcall GameFace_Store_Far                    ; $6A2E

jr_007_6a36:
    ld a, [wSaveDialogWhat]                       ; $6A36
    bit 1, a                                      ; $6A39
    ret z                                         ; $6A3B

    ld a, [wSaveTargetPhoto]                      ; $6A3C
    ldh [hFarcallAArg], a                         ; $6A3F
    farcall Photo_StoreHotspotsTranslated_Far     ; $6A41
    ret                                           ; $6A49


; C: album-full message. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 10
; (tcrf_check/assets/l3_names/)
SaveDialog_Substate3_FullInit::
    farcopy Vram_CopyFromBank, Gfx_1E_7800_SaveDialog_Substate3_FullInit, $8b00, $04f0 ; $6A4A
    farcopy Vram_CopyFromBank, Map_24_7C20_SaveDialog_Substate3_FullInit_Part7EE0, $9c00, $0120 ; $6A58
    xor a                                         ; $6A66
    ld [wSaveDialogScratch], a                    ; $6A67
    call Oam_ClearShadow                          ; $6A6A
    call SaveDialog_SlideIn                       ; $6A6D
    ld hl, wSubstate                              ; $6A70
    inc [hl]                                      ; $6A73
    jp Far_Call_Return                            ; $6A74


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
SaveDialog_Substate4_WaitKey::
    ldh a, [hKeysNew]                             ; $6A77
    and PADF_A | PADF_B                           ; $6A79
    ld [wAbResult], a                             ; $6A7B
    jp z, Far_Call_Return                         ; $6A7E

    push af                                       ; $6A81
    bit 0, a                                      ; $6A82
    ld a, SFX3_DELETE_DIALOG_FIRST                ; $6A84
    call nz, Snd_Sfx3                             ; $6A86
    pop af                                        ; $6A89
    push af                                       ; $6A8A
    bit 1, a                                      ; $6A8B
    ld a, SFX3_DELETE_DIALOG_SECOND               ; $6A8D
    call nz, Snd_Sfx3                             ; $6A8F
    pop af                                        ; $6A92
    ld hl, wSubstate                              ; $6A93
    inc [hl]                                      ; $6A96
    jp Far_Call_Return                            ; $6A97


; C: save_dialog_result := 0 (A) or $FF
SaveDialog_Substate5_Finish::
    call SaveDialog_SlideOut                      ; $6A9A
    ld a, [wAbResult]                             ; $6A9D
    bit 0, a                                      ; $6AA0
    jr z, jr_007_6aa7                             ; $6AA2

    xor a                                         ; $6AA4
    jr jr_007_6aa9                                ; $6AA5

jr_007_6aa7:
    ld a, $ff                                     ; $6AA7

jr_007_6aa9:
    ld [wSaveDialogResult], a                     ; $6AA9
    next_state                                    ; $6AAC
    jp Far_Call_Return                            ; $6AB0


; C: window moves down with the WY delta table; sound $12
SaveDialog_SlideOut::
    play_sfx1 SFX1_PANEL_OPEN                     ; $6AB3
    ld hl, Slide_WyDeltaTbl                       ; $6ABA
    ld b, $24                                     ; $6ABD

jr_007_6abf:
    push bc                                       ; $6ABF
    push hl                                       ; $6AC0
    ldh a, [hWyShadow]                            ; $6AC1
    add [hl]                                      ; $6AC3
    ldh [hWyShadow], a                            ; $6AC4
    rst Rst08_WaitVBlank                          ; $6AC6
    pop hl                                        ; $6AC7
    pop bc                                        ; $6AC8
    inc hl                                        ; $6AC9
    dec b                                         ; $6ACA
    jr nz, jr_007_6abf                            ; $6ACB

    ret                                           ; $6ACD


; C: sound $13
SaveDialog_SlideIn::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $6ACE
    ld hl, Slide_WyDeltaTbl                       ; $6AD5
    ld b, $24                                     ; $6AD8

jr_007_6ada:
    push bc                                       ; $6ADA
    push hl                                       ; $6ADB
    ldh a, [hWyShadow]                            ; $6ADC
    sub [hl]                                      ; $6ADE
    ldh [hWyShadow], a                            ; $6ADF
    rst Rst08_WaitVBlank                          ; $6AE1
    pop hl                                        ; $6AE2
    pop bc                                        ; $6AE3
    inc hl                                        ; $6AE4
    dec b                                         ; $6AE5
    jr nz, jr_007_6ada                            ; $6AE6

    ret                                           ; $6AE8


; C: mode 0D: slide-show hub; options and auto-play viewer
Mode0D_SlideShow::
    ld a, [wState]                                ; $6AE9
    rst Rst18_JumpTable                           ; $6AEC

; I: 12 states
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $6B05
    ldh [hLcdcShadow], a                          ; $6B07
    ld a, $e4                                     ; $6B09
    ld [wPaletteTarget], a                        ; $6B0B
    ld a, $d2                                     ; $6B0E
    ld [wPaletteTarget + $1], a                   ; $6B10
    ld [wPaletteTarget + $2], a                   ; $6B13
    ld a, $10                                     ; $6B16
    ldh [hScyShadow], a                           ; $6B18
    xor a                                         ; $6B1A
    ldh [hScxShadow], a                           ; $6B1B
    ld hl, wActorFrame                            ; $6B1D
    ld b, $08                                     ; $6B20

jr_007_6b22:
    ld [hl+], a                                   ; $6B22
    dec b                                         ; $6B23
    jr nz, jr_007_6b22                            ; $6B24

    ld de, Mode0D_State00_Init_Gfx6B99            ; $6B26
    ld b, $08                                     ; $6B29

jr_007_6b2b:
    ld a, [de]                                    ; $6B2B
    ld [hl+], a                                   ; $6B2C
    inc de                                        ; $6B2D
    dec b                                         ; $6B2E
    jr nz, jr_007_6b2b                            ; $6B2F

    farcopy Mem_CopyFromBank, Gfx_14_5800_Mode0D_State00_Init, $9000, $0800 ; $6B31
    farcopy Mem_CopyFromBank, Gfx_14_6000_Mode0D_State00_Init, $8800, $0800 ; $6B3F
    farcopy Mem_CopyFromBank, Gfx_14_6800_Mode0D_State00_Init, $8000, $0800 ; $6B4D
    farcopy Mem_CopyFromBank, Map_24_4840_Mode0D_State00_Init, $9840, $0240 ; $6B5B
    ld hl, $8f00                                  ; $6B69
    ld bc, $0010                                  ; $6B6C
    ld de, $ffff                                  ; $6B6F
    call Mem_FillWords                            ; $6B72
    ld hl, $9ac0                                  ; $6B75
    ld bc, $0140                                  ; $6B78
    ld a, $f0                                     ; $6B7B
    call Mem_FillBc1                              ; $6B7D
    screen_on                                     ; $6B80
    play_music MUSIC_SLIDESHOW_INIT               ; $6B89
    call Pal_FadeIn                               ; $6B90
    set_state STATE_0D_HUB                        ; $6B93
    ret                                           ; $6B98


; C: auto: 8 bytes, tile data; referenced by Mode0D_State00_Init. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 0D)
Mode0D_State00_Init_Gfx6B99::
    db $20, $70, $36, $36, $55, $55, $05, $05

; C: two wandering sprites; Select = options; A/B = leave
Mode0D_State01_Hub::
    call SlideHub_UpdateActors                    ; $6BA1
    call SlideHub_RandomizeSpeed                  ; $6BA4
    call SlideHub_WalkActors                      ; $6BA7
    ldh a, [hKeysNewSticky]                       ; $6BAA
    bit PADB_SELECT, a                            ; $6BAC
    jr z, jr_007_6bd8                             ; $6BAE

    play_sfx1 SFX1_KEY_SELECT                     ; $6BB0
    farcopy Vram_CopyFromBank, Map_24_47C0_Mode0D_State01_Hub, $9800, $0080 ; $6BB7
    farcopy Vram_CopyFromBank, Map_24_4A80_Mode0D_State01_Hub, $9a40, $0080 ; $6BC5
    next_state                                    ; $6BD3
    ret                                           ; $6BD7


jr_007_6bd8:
    and $03                                       ; $6BD8
    ret z                                         ; $6BDA

    ld [wAbResult], a                             ; $6BDB
    push af                                       ; $6BDE
    bit 0, a                                      ; $6BDF
    ld a, SFX1_KEY_A                              ; $6BE1
    call nz, Snd_Sfx1                             ; $6BE3
    pop af                                        ; $6BE6
    push af                                       ; $6BE7
    bit 1, a                                      ; $6BE8
    ld a, SFX1_KEY_B                              ; $6BEA
    call nz, Snd_Sfx1                             ; $6BEC
    pop af                                        ; $6BEF
    set_state STATE_0D_FADE_OUT_HUB               ; $6BF0
    ret                                           ; $6BF5


; C
SlideHub_UpdateActors::
    ld bc, $0001                                  ; $6BF6

jr_007_6bf9:
    push bc                                       ; $6BF9
    ld hl, wActorCycleFlag                        ; $6BFA
    add hl, bc                                    ; $6BFD
    xor a                                         ; $6BFE
    ld [hl], a                                    ; $6BFF
    ld hl, wActorFrame                            ; $6C00
    add hl, bc                                    ; $6C03
    ld e, [hl]                                    ; $6C04
    ld hl, wActorTick                             ; $6C05
    add hl, bc                                    ; $6C08
    ld d, [hl]                                    ; $6C09
    push de                                       ; $6C0A
    sla e                                         ; $6C0B
    ld d, $00                                     ; $6C0D
    ld hl, SlideHub_ActorAnimTbl                  ; $6C0F
    add hl, de                                    ; $6C12
    ld a, [hl+]                                   ; $6C13
    push hl                                       ; $6C14
    ld hl, wActorX                                ; $6C15
    add hl, bc                                    ; $6C18
    ld b, [hl]                                    ; $6C19
    inc hl                                        ; $6C1A
    inc hl                                        ; $6C1B
    ld c, [hl]                                    ; $6C1C
    call Oam_AddMeta_B01_5D2B                     ; $6C1D
    pop hl                                        ; $6C20
    pop de                                        ; $6C21

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideHub_ActorDurations::
    ld a, d                                       ; $6C22
    cp [hl]                                       ; $6C23
    jr nz, jr_007_6c40                            ; $6C24

    inc e                                         ; $6C26
    inc hl                                        ; $6C27
    ld a, [hl+]                                   ; $6C28
    cp $ff                                        ; $6C29
    jr nz, jr_007_6c3e                            ; $6C2B

    ld e, [hl]                                    ; $6C2D
    pop bc                                        ; $6C2E
    push bc                                       ; $6C2F
    ld hl, wActorCycleFlag                        ; $6C30
    add hl, bc                                    ; $6C33
    inc [hl]                                      ; $6C34
    call Rng_Next                                 ; $6C35
    cp $32                                        ; $6C38
    jr c, jr_007_6c3e                             ; $6C3A

    ld e, $00                                     ; $6C3C

jr_007_6c3e:
    ld d, $00                                     ; $6C3E

jr_007_6c40:
    pop bc                                        ; $6C40
    push bc                                       ; $6C41
    ld hl, wActorSpeed                            ; $6C42
    add hl, bc                                    ; $6C45
    ld a, [hl]                                    ; $6C46
    ld hl, wActorPhase                            ; $6C47
    add hl, bc                                    ; $6C4A
    add [hl]                                      ; $6C4B
    ld [hl], a                                    ; $6C4C
    jr nc, jr_007_6c50                            ; $6C4D

    inc d                                         ; $6C4F

jr_007_6c50:
    ld hl, wActorFrame                            ; $6C50
    add hl, bc                                    ; $6C53
    ld [hl], e                                    ; $6C54
    ld hl, wActorTick                             ; $6C55
    add hl, bc                                    ; $6C58
    ld [hl], d                                    ; $6C59
    pop bc                                        ; $6C5A
    dec c                                         ; $6C5B
    bit 7, c                                      ; $6C5C
    jr z, jr_007_6bf9                             ; $6C5E

    ret                                           ; $6C60


; C: pairs: sprite id; duration
SlideHub_ActorAnimTbl::
    db $0f, $01, $10, $01, $11, $01, $12, $01, $00, $01, $01, $01, $02, $01, $03, $01
    db $04, $01, $05, $01, $06, $01, $07, $01, $08, $01, $09, $01, $0a, $01, $0b, $01
    db $0c, $01, $0d, $01, $0e, $01, $ff, $14, $22, $01, $23, $01, $24, $01, $25, $01
    db $13, $01, $14, $01, $15, $01, $16, $01, $17, $01, $18, $01, $19, $01, $1a, $01
    db $1b, $01, $1c, $01, $1d, $01, $1e, $01, $1f, $01, $20, $01, $21, $01, $ff, $14

; C
SlideHub_RandomizeSpeed::
    ld bc, $0001                                  ; $6CB1

jr_007_6cb4:
    ld hl, wActorCycleFlag                        ; $6CB4
    add hl, bc                                    ; $6CB7
    bit 0, [hl]                                   ; $6CB8
    jr z, jr_007_6cd9                             ; $6CBA

    ld hl, wActorSpeedTimer                       ; $6CBC
    add hl, bc                                    ; $6CBF
    dec [hl]                                      ; $6CC0
    jr nz, jr_007_6cd9                            ; $6CC1

    call Rng_Next                                 ; $6CC3
    and $07                                       ; $6CC6
    add $02                                       ; $6CC8
    ld [hl], a                                    ; $6CCA
    call Rng_Next                                 ; $6CCB
    cp $55                                        ; $6CCE
    jr nc, jr_007_6cd4                            ; $6CD0

    ld a, $55                                     ; $6CD2

jr_007_6cd4:
    ld hl, wActorSpeed                            ; $6CD4
    add hl, bc                                    ; $6CD7
    ld [hl], a                                    ; $6CD8

jr_007_6cd9:
    dec c                                         ; $6CD9
    bit 7, c                                      ; $6CDA
    jr z, jr_007_6cb4                             ; $6CDC

    ret                                           ; $6CDE


; C: random walk -1;0;0;+1 per frame inside limits
SlideHub_WalkActors::
    ld bc, $0001                                  ; $6CDF

jr_007_6ce2:
    call Rng_Next                                 ; $6CE2
    and $03                                       ; $6CE5
    sub $02                                       ; $6CE7
    jr nc, jr_007_6cec                            ; $6CE9

    inc a                                         ; $6CEB

jr_007_6cec:
    ld hl, wActorX                                ; $6CEC
    add hl, bc                                    ; $6CEF
    add [hl]                                      ; $6CF0
    ld hl, SlideHub_ActorLimitTbl                 ; $6CF1
    add hl, bc                                    ; $6CF4
    cp [hl]                                       ; $6CF5
    jr c, jr_007_6d04                             ; $6CF6

    ld hl, SlideHub_WalkActors_Tbl6D28            ; $6CF8
    add hl, bc                                    ; $6CFB
    cp [hl]                                       ; $6CFC
    jr nc, jr_007_6d04                            ; $6CFD

    ld hl, wActorX                                ; $6CFF
    add hl, bc                                    ; $6D02
    ld [hl], a                                    ; $6D03

jr_007_6d04:
    call Rng_Next                                 ; $6D04
    and $03                                       ; $6D07
    sub $02                                       ; $6D09
    jr nc, jr_007_6d0e                            ; $6D0B

    inc a                                         ; $6D0D

jr_007_6d0e:
    ld hl, wActorY                                ; $6D0E
    add hl, bc                                    ; $6D11
    add [hl]                                      ; $6D12
    cp $2e                                        ; $6D13
    jr c, jr_007_6d20                             ; $6D15

    cp $3e                                        ; $6D17
    jr nc, jr_007_6d20                            ; $6D19

    ld hl, wActorY                                ; $6D1B
    add hl, bc                                    ; $6D1E
    ld [hl], a                                    ; $6D1F

jr_007_6d20:
    dec c                                         ; $6D20
    bit 7, c                                      ; $6D21
    jr z, jr_007_6ce2                             ; $6D23

    ret                                           ; $6D25


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideHub_ActorLimitTbl::
    dw $6010

; C: auto: 2 bytes, bytes; referenced by SlideHub_WalkActors. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideHub_WalkActors_Tbl6D28::
    dw $8030

; C: blinking arrows; Up/Down picks option row
Mode0D_State02_OptionsMenu::
    ld a, [wBlinkCounter]                         ; $6D2A
    inc a                                         ; $6D2D
    ld [wBlinkCounter], a                         ; $6D2E
    bit 4, a                                      ; $6D31
    jr z, jr_007_6d45                             ; $6D33

    ld a, $00                                     ; $6D35
    ld bc, $5010                                  ; $6D37
    call Oam_AddMeta_B02_6F16                     ; $6D3A
    ld a, $01                                     ; $6D3D
    ld bc, $5080                                  ; $6D3F
    call Oam_AddMeta_B02_6F16                     ; $6D42

jr_007_6d45:
    ldh a, [hKeysNewSticky]                       ; $6D45
    and PADF_B | PADF_SELECT                      ; $6D47
    jr z, jr_007_6d73                             ; $6D49

    play_sfx1 SFX1_KEY_B                          ; $6D4B
    farcopy Vram_CopyFromBank, Map_24_4840_Mode0D_State00_Init, $9840, $0040 ; $6D52
    farcopy Vram_CopyFromBank, Map_24_4A40_Mode0D_State02_OptionsMenu, $9a40, $0040 ; $6D60
    ld hl, wState                                 ; $6D6E
    dec [hl]                                      ; $6D71
    ret                                           ; $6D72


jr_007_6d73:
    ldh a, [hKeysRepeatSticky]                    ; $6D73
    and PADF_UP | PADF_DOWN                       ; $6D75
    ret z                                         ; $6D77

    play_sfx1 SFX1_STEP_FAST                      ; $6D78
    xor a                                         ; $6D7F
    ld [wArrowAnimTick], a                        ; $6D80
    ld [wArrowAnimFrame], a                       ; $6D83
    ld a, [wPlayOptA]                             ; $6D86
    ld [wChoiceCursorA], a                        ; $6D89
    ld a, [wPlayOptB]                             ; $6D8C
    ld [wChoiceCursorB], a                        ; $6D8F
    ldh a, [hKeysRepeatSticky]                    ; $6D92
    bit PADB_UP, a                                ; $6D94
    jr z, jr_007_6db4                             ; $6D96

    call Oam_ClearShadow                          ; $6D98
    ld hl, Slide_ScyDeltaTbl                      ; $6D9B
    ld b, $10                                     ; $6D9E

jr_007_6da0:
    push bc                                       ; $6DA0
    push hl                                       ; $6DA1
    ldh a, [hScyShadow]                           ; $6DA2
    add [hl]                                      ; $6DA4
    ldh [hScyShadow], a                           ; $6DA5
    rst Rst08_WaitVBlank                          ; $6DA7
    pop hl                                        ; $6DA8
    pop bc                                        ; $6DA9
    inc hl                                        ; $6DAA
    dec b                                         ; $6DAB
    jr nz, jr_007_6da0                            ; $6DAC

    set_state STATE_0D_OPTION_A                   ; $6DAE
    ret                                           ; $6DB3


jr_007_6db4:
    bit 7, a                                      ; $6DB4
    ret z                                         ; $6DB6

    call Oam_ClearShadow                          ; $6DB7
    ld hl, Slide_ScyDeltaTbl                      ; $6DBA
    ld b, $10                                     ; $6DBD

jr_007_6dbf:
    push bc                                       ; $6DBF
    push hl                                       ; $6DC0
    ldh a, [hScyShadow]                           ; $6DC1
    sub [hl]                                      ; $6DC3
    ldh [hScyShadow], a                           ; $6DC4
    rst Rst08_WaitVBlank                          ; $6DC6
    pop hl                                        ; $6DC7
    pop bc                                        ; $6DC8
    inc hl                                        ; $6DC9
    dec b                                         ; $6DCA
    jr nz, jr_007_6dbf                            ; $6DCB

    set_state STATE_0D_OPTION_B                   ; $6DCD
    ret                                           ; $6DD2


; C: option A ($D7D2): 0 = BGM (song $21), 1 = P.VOICE (music off; after each photo its four checksum digits are
; spoken, sfx1 $10); the earlier note 'photo number shown on/off' was wrong (README 16.27)
Mode0D_State03_OptionA::
    call SlideOptA_ReadKeys                       ; $6DD3
    call SlideOptA_DrawArrow                      ; $6DD6
    call SlideOptA_DrawValue                      ; $6DD9
    ldh a, [hKeysNew]                             ; $6DDC
    and PADF_A | PADF_B | PADF_DOWN               ; $6DDE
    ret z                                         ; $6DE0

    push af                                       ; $6DE1
    bit 0, a                                      ; $6DE2
    ld a, SFX1_OPTION_CHANGE                      ; $6DE4
    call nz, Snd_Sfx1                             ; $6DE6
    pop af                                        ; $6DE9
    push af                                       ; $6DEA
    bit 1, a                                      ; $6DEB
    ld a, SFX1_KEY_B                              ; $6DED
    call nz, Snd_Sfx1                             ; $6DEF
    pop af                                        ; $6DF2
    push af                                       ; $6DF3
    bit 7, a                                      ; $6DF4
    ld a, SFX1_STEP_FAST                          ; $6DF6
    call nz, Snd_Sfx1                             ; $6DF8
    pop af                                        ; $6DFB
    push af                                       ; $6DFC
    bit 0, a                                      ; $6DFD
    jr z, jr_007_6e20                             ; $6DFF

    ld hl, wArrowAnimFrame                        ; $6E01
    inc [hl]                                      ; $6E04
    ld a, [wChoiceCursorA]                        ; $6E05
    ld [wPlayOptA], a                             ; $6E08
    call Oam_HideUnused                           ; $6E0B
    rst Rst08_WaitVBlank                          ; $6E0E

jr_007_6e0f:
    call SlideOptA_DrawArrow                      ; $6E0F
    call SlideOptA_DrawValue                      ; $6E12
    call Oam_HideUnused                           ; $6E15
    rst Rst08_WaitVBlank                          ; $6E18
    ld a, [wArrowAnimFrame]                       ; $6E19
    cp $02                                        ; $6E1C
    jr nz, jr_007_6e0f                            ; $6E1E

jr_007_6e20:
    call Oam_ClearShadow                          ; $6E20
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6E23
    ld b, $10                                     ; $6E26

jr_007_6e28:
    push bc                                       ; $6E28
    push hl                                       ; $6E29
    ldh a, [hScyShadow]                           ; $6E2A
    sub [hl]                                      ; $6E2C
    ldh [hScyShadow], a                           ; $6E2D
    rst Rst08_WaitVBlank                          ; $6E2F
    pop hl                                        ; $6E30
    pop bc                                        ; $6E31
    inc hl                                        ; $6E32
    dec b                                         ; $6E33
    jr nz, jr_007_6e28                            ; $6E34

    pop af                                        ; $6E36
    bit 0, a                                      ; $6E37
    jr nz, jr_007_6e41                            ; $6E39

    set_state STATE_0D_OPTIONS_MENU               ; $6E3B
    ret                                           ; $6E40


jr_007_6e41:
    farcopy Vram_CopyFromBank, Map_24_4840_Mode0D_State00_Init, $9840, $0040 ; $6E41
    farcopy Vram_CopyFromBank, Map_24_4A40_Mode0D_State02_OptionsMenu, $9a40, $0040 ; $6E4F
    set_state STATE_0D_HUB                        ; $6E5D
    ret                                           ; $6E62


; C: Left/Right toggle D674. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
SlideOptA_ReadKeys::
    ldh a, [hKeysNew]                             ; $6E63
    bit PADB_LEFT, a                              ; $6E65
    jr z, jr_007_6e6c                             ; $6E67

    xor a                                         ; $6E69
    jr jr_007_6e71                                ; $6E6A

jr_007_6e6c:
    bit 4, a                                      ; $6E6C
    ret z                                         ; $6E6E

    ld a, $01                                     ; $6E6F

jr_007_6e71:
    ld hl, wChoiceCursorA                         ; $6E71
    cp [hl]                                       ; $6E74
    ret z                                         ; $6E75

    ld [hl], a                                    ; $6E76
    play_sfx1 SFX1_STEP_FAST                      ; $6E77
    ret                                           ; $6E7E


; C: draws the arrow of option A: position = SlideOptA_ArrowPosTbl[$D674] ({y,x} in C,B); animation phase $D50F (2 =
; finished, nothing drawn), tick $D51F: meta and duration come from SlideOptA_DrawArrow_Tbl6EDA[phase]; the phase
; advances when the tick equals the duration and the tick counts only while ...
SlideOptA_DrawArrow::
    ld a, [wChoiceCursorA]                        ; $6E7F
    sla a                                         ; $6E82
    ld c, a                                       ; $6E84
    ld b, $00                                     ; $6E85
    ld hl, SlideOptA_ArrowPosTbl                  ; $6E87
    add hl, bc                                    ; $6E8A
    ld c, [hl]                                    ; $6E8B
    inc hl                                        ; $6E8C
    ld b, [hl]                                    ; $6E8D
    ld a, [wArrowAnimFrame]                       ; $6E8E
    cp $02                                        ; $6E91
    ret z                                         ; $6E93

    ld a, [wArrowAnimFrame]                       ; $6E94
    sla a                                         ; $6E97
    ld e, a                                       ; $6E99
    ld d, $00                                     ; $6E9A
    ld hl, SlideOptA_DrawArrow_Tbl6EC0            ; $6E9C
    add hl, de                                    ; $6E9F
    ld a, [hl+]                                   ; $6EA0
    call Oam_AddMeta_B02_6F16                     ; $6EA1
    ld a, [wArrowAnimTick]                        ; $6EA4
    cp [hl]                                       ; $6EA7
    jr nz, jr_007_6eb2                            ; $6EA8

    ld hl, wArrowAnimFrame                        ; $6EAA
    inc [hl]                                      ; $6EAD
    xor a                                         ; $6EAE
    ld [wArrowAnimTick], a                        ; $6EAF

jr_007_6eb2:
    ld a, [wArrowAnimFrame]                       ; $6EB2
    and a                                         ; $6EB5
    ret z                                         ; $6EB6

    ld hl, wArrowAnimTick                         ; $6EB7
    inc [hl]                                      ; $6EBA
    ret                                           ; $6EBB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptA_ArrowPosTbl::
    db $10, $24, $10, $70

; C: 3 x {meta, duration}: 08/10, 09/0B, 09/FF (the third entry is never used: phase 2 returns before the table is
; read); read by SlideOptA_DrawArrow with $D50F x 2 (C)
SlideOptA_DrawArrow_Tbl6EC0::
    db $08, $10, $09, $0b, $09, $ff

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideOptA_DrawValue::
    ld a, [wPlayOptA]                             ; $6EC6
    sla a                                         ; $6EC9
    ld c, a                                       ; $6ECB
    ld b, $00                                     ; $6ECC
    ld hl, SlideOptA_ValuePosTbl                  ; $6ECE
    add hl, bc                                    ; $6ED1
    ld c, [hl]                                    ; $6ED2
    inc hl                                        ; $6ED3
    ld b, [hl]                                    ; $6ED4
    ldh a, [hFrameCounter]                        ; $6ED5
    swap a                                        ; $6ED7
    and $01                                       ; $6ED9
    add $02                                       ; $6EDB
    call Oam_AddMeta_B02_6F16                     ; $6EDD
    ret                                           ; $6EE0


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptA_ValuePosTbl::
    db $00, $0a, $00, $55

; C: option B (D7D3): random / in order. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Mode0D_State04_OptionB::
    call SlideOptB_ReadKeys                       ; $6EE5
    call SlideOptB_DrawArrow                      ; $6EE8
    call SlideOptB_DrawValue                      ; $6EEB
    ldh a, [hKeysNew]                             ; $6EEE
    and PADF_A | PADF_B | PADF_UP                 ; $6EF0
    ret z                                         ; $6EF2

    push af                                       ; $6EF3
    bit 0, a                                      ; $6EF4
    ld a, SFX1_OPTION_CHANGE                      ; $6EF6
    call nz, Snd_Sfx1                             ; $6EF8
    pop af                                        ; $6EFB
    push af                                       ; $6EFC
    bit 1, a                                      ; $6EFD
    ld a, SFX1_KEY_B                              ; $6EFF
    call nz, Snd_Sfx1                             ; $6F01
    pop af                                        ; $6F04
    push af                                       ; $6F05
    bit 6, a                                      ; $6F06
    ld a, SFX1_STEP_FAST                          ; $6F08
    call nz, Snd_Sfx1                             ; $6F0A
    pop af                                        ; $6F0D
    push af                                       ; $6F0E
    bit 0, a                                      ; $6F0F
    jr z, jr_007_6f32                             ; $6F11

    ld hl, wArrowAnimFrame                        ; $6F13
    inc [hl]                                      ; $6F16
    ld a, [wChoiceCursorB]                        ; $6F17
    ld [wPlayOptB], a                             ; $6F1A
    call Oam_HideUnused                           ; $6F1D
    rst Rst08_WaitVBlank                          ; $6F20

jr_007_6f21:
    call SlideOptB_DrawArrow                      ; $6F21
    call SlideOptB_DrawValue                      ; $6F24
    call Oam_HideUnused                           ; $6F27
    rst Rst08_WaitVBlank                          ; $6F2A
    ld a, [wArrowAnimFrame]                       ; $6F2B
    cp $02                                        ; $6F2E
    jr nz, jr_007_6f21                            ; $6F30

jr_007_6f32:
    call Oam_ClearShadow                          ; $6F32
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6F35
    ld b, $10                                     ; $6F38

jr_007_6f3a:
    push bc                                       ; $6F3A
    push hl                                       ; $6F3B
    ldh a, [hScyShadow]                           ; $6F3C
    add [hl]                                      ; $6F3E
    ldh [hScyShadow], a                           ; $6F3F
    cpl                                           ; $6F41
    add $64                                       ; $6F42
    ldh [hLycShadowSplit1], a                     ; $6F44
    rst Rst08_WaitVBlank                          ; $6F46
    pop hl                                        ; $6F47
    pop bc                                        ; $6F48
    inc hl                                        ; $6F49
    dec b                                         ; $6F4A
    jr nz, jr_007_6f3a                            ; $6F4B

    pop af                                        ; $6F4D
    bit 0, a                                      ; $6F4E
    jr nz, jr_007_6f58                            ; $6F50

    set_state STATE_0D_OPTIONS_MENU               ; $6F52
    ret                                           ; $6F57


jr_007_6f58:
    farcopy Vram_CopyFromBank, Map_24_4840_Mode0D_State00_Init, $9840, $0040 ; $6F58
    farcopy Vram_CopyFromBank, Map_24_4A40_Mode0D_State02_OptionsMenu, $9a40, $0040 ; $6F66
    set_state STATE_0D_HUB                        ; $6F74
    ret                                           ; $6F79


; C: Left/Right toggle D675. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
SlideOptB_ReadKeys::
    ldh a, [hKeysNew]                             ; $6F7A
    bit PADB_LEFT, a                              ; $6F7C
    jr z, jr_007_6f83                             ; $6F7E

    xor a                                         ; $6F80
    jr jr_007_6f88                                ; $6F81

jr_007_6f83:
    bit 4, a                                      ; $6F83
    ret z                                         ; $6F85

    ld a, $01                                     ; $6F86

jr_007_6f88:
    ld hl, wChoiceCursorB                         ; $6F88
    cp [hl]                                       ; $6F8B
    ret z                                         ; $6F8C

    ld [hl], a                                    ; $6F8D
    play_sfx1 SFX1_STEP_FAST                      ; $6F8E
    ret                                           ; $6F95


; C: draws the arrow of option B: same routine as SlideOptA_DrawArrow with $D675, SlideOptB_ArrowPosTbl and
; SlideOptB_DrawArrow_Tbl6FF1 (C)
SlideOptB_DrawArrow::
    ld a, [wChoiceCursorB]                        ; $6F96
    sla a                                         ; $6F99
    ld c, a                                       ; $6F9B
    ld b, $00                                     ; $6F9C
    ld hl, SlideOptB_ArrowPosTbl                  ; $6F9E
    add hl, bc                                    ; $6FA1
    ld c, [hl]                                    ; $6FA2
    inc hl                                        ; $6FA3
    ld b, [hl]                                    ; $6FA4
    ld a, [wArrowAnimFrame]                       ; $6FA5
    cp $02                                        ; $6FA8
    ret z                                         ; $6FAA

    ld a, [wArrowAnimFrame]                       ; $6FAB
    sla a                                         ; $6FAE
    ld e, a                                       ; $6FB0
    ld d, $00                                     ; $6FB1
    ld hl, SlideOptB_DrawArrow_Tbl6FD7            ; $6FB3
    add hl, de                                    ; $6FB6
    ld a, [hl+]                                   ; $6FB7
    call Oam_AddMeta_B02_6F16                     ; $6FB8
    ld a, [wArrowAnimTick]                        ; $6FBB
    cp [hl]                                       ; $6FBE
    jr nz, jr_007_6fc9                            ; $6FBF

    ld hl, wArrowAnimFrame                        ; $6FC1
    inc [hl]                                      ; $6FC4
    xor a                                         ; $6FC5
    ld [wArrowAnimTick], a                        ; $6FC6

jr_007_6fc9:
    ld a, [wArrowAnimFrame]                       ; $6FC9
    and a                                         ; $6FCC
    ret z                                         ; $6FCD

    ld hl, wArrowAnimTick                         ; $6FCE
    inc [hl]                                      ; $6FD1
    ret                                           ; $6FD2


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptB_ArrowPosTbl::
    db $70, $24, $70, $70

; C: 3 x {meta, duration}: 0A/10, 0B/0B, 0B/FF (the third entry is never used); read by SlideOptB_DrawArrow (C)
SlideOptB_DrawArrow_Tbl6FD7::
    db $0a, $10, $0b, $0b, $0b, $ff

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
SlideOptB_DrawValue::
    ld a, [wPlayOptB]                             ; $6FDD
    sla a                                         ; $6FE0
    ld c, a                                       ; $6FE2
    ld b, $00                                     ; $6FE3
    ld hl, SlideOptB_ValuePosTbl                  ; $6FE5
    add hl, bc                                    ; $6FE8
    ld c, [hl]                                    ; $6FE9
    inc hl                                        ; $6FEA
    ld b, [hl]                                    ; $6FEB
    ldh a, [hFrameCounter]                        ; $6FEC
    srl a                                         ; $6FEE
    srl a                                         ; $6FF0
    srl a                                         ; $6FF2
    and $03                                       ; $6FF4
    add $04                                       ; $6FF6
    call Oam_AddMeta_B02_6F16                     ; $6FF8
    ret                                           ; $6FFB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0D)
SlideOptB_ValuePosTbl::
    db $84, $15, $84, $60

; C: B -> mode 0B; A -> next state
Mode0D_State05_FadeOutHub::
    screen_off                                    ; $7000
    ld a, [wAbResult]                             ; $7006
    bit 0, a                                      ; $7009
    jr nz, jr_007_7018                            ; $700B

    ld a, MODE_SHOW_MENU                          ; $700D
    ld [wMode], a                                 ; $700F
    set_state STATE_0B_INIT                       ; $7012
    ret                                           ; $7017


jr_007_7018:
    next_state                                    ; $7018
    ret                                           ; $701C


; I: no photo -> state 9
Mode0D_State06_PlayInit::
    ld a, [wPhotoCount]                           ; $701D
    and a                                         ; $7020
    jr nz, jr_007_7029                            ; $7021

    set_state STATE_0D_NO_PHOTOS_MESSAGE          ; $7023
    ret                                           ; $7028


jr_007_7029:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7029
    ldh [hLcdcShadow], a                          ; $702B
    ld a, $e4                                     ; $702D
    ld [wPaletteTarget], a                        ; $702F
    ld [wPaletteTarget + $1], a                   ; $7032
    ld [wPaletteTarget + $2], a                   ; $7035
    ld a, $10                                     ; $7038
    ldh [hScxShadow], a                           ; $703A
    ldh [hScyShadow], a                           ; $703C
    farcopy Mem_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $703E
    farcopy Mem_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $704C
    xor a                                         ; $705A
    ld [wSlideshowIdx], a                         ; $705B
    ld a, [wPlayOptB]                             ; $705E
    and a                                         ; $7061
    jr nz, jr_007_706d                            ; $7062

    ld a, [wPhotoCount]                           ; $7064
    call Rng_Scaled                               ; $7067
    ld [wSlideshowIdx], a                         ; $706A

jr_007_706d:
    ld a, $3c                                     ; $706D
    ld [wPlayInterval], a                         ; $706F
    ld [wPlayCountdown], a                        ; $7072
    ld a, $01                                     ; $7075
    ld [wPlayDirection], a                        ; $7077
    ld a, [wSlideshowIdx]                         ; $707A
    ldh [hFarcallAArg], a                         ; $707D
    farcall Photo_LoadToVram_Far                  ; $707F
    ld a, $54                                     ; $7087
    ldh [hLycShadowSplit1], a                     ; $7089
    ldh [hSplit1Latch], a                         ; $708B
    ld hl, hStatShadow                            ; $708D
    set 6, [hl]                                   ; $7090
    ld hl, rIE                                    ; $7092
    set 1, [hl]                                   ; $7095
    ld a, $01                                     ; $7097
    ldh [hStatHandlerIndex], a                    ; $7099
    screen_on                                     ; $709B
    ld a, [wPlayOptA]                             ; $70A4
    and a                                         ; $70A7
    jr nz, jr_007_70b3                            ; $70A8

    play_music MUSIC_SLIDESHOW_PLAY               ; $70AA
    jr jr_007_70ba                                ; $70B1

jr_007_70b3:
    play_music MUSIC_STOP                         ; $70B3

jr_007_70ba:
    call Pal_FadeIn                               ; $70BA
    next_state                                    ; $70BD
    ld a, [wPlayOptA]                             ; $70C1
    and a                                         ; $70C4
    ret z                                         ; $70C5

    ld a, [wSlideshowIdx]                         ; $70C6
    ldh [hFarcallAArg], a                         ; $70C9
    farcall Photo_LoadTagFields_Far               ; $70CB
    call Snd_PlayTagDigits                        ; $70D3
    ret                                           ; $70D6


; I: countdown; next photo; Left/Right = direction; Up/Down = interval
Mode0D_State07_Play::
    ld hl, wPlayCountdown                         ; $70D7
    dec [hl]                                      ; $70DA
    jr nz, jr_007_70e4                            ; $70DB

    ld a, [wPlayInterval]                         ; $70DD
    ld [hl], a                                    ; $70E0
    call SlidePlay_ShowNext                       ; $70E1

jr_007_70e4:
    call SlidePlay_ReadKeys                       ; $70E4
    ldh a, [hKeysNewSticky]                       ; $70E7
    and PADF_B                                    ; $70E9
    ret z                                         ; $70EB

    ld [wAbResult], a                             ; $70EC
    next_state                                    ; $70EF
    ret                                           ; $70F3


; C
Mode0D_State08_PlayExit::
    screen_off                                    ; $70F4
    stat_irq_off                                  ; $70FA
    ld a, [wAbResult]                             ; $7104
    bit 0, a                                      ; $7107
    jr nz, jr_007_7111                            ; $7109

    set_state STATE_0D_INIT                       ; $710B
    ret                                           ; $7110


jr_007_7111:
    set_state STATE_0D_INIT                       ; $7111
    ret                                           ; $7116


; C: result_msg_id := 5
Mode0D_State09_NoPhotosMessage::
    xor a                                         ; $7117
    ld [wSubstate], a                             ; $7118
    ld a, $05                                     ; $711B
    ld [wResultMsgId], a                          ; $711D
    next_state                                    ; $7120
    ret                                           ; $7124


; C: far call 09:7290
Mode0D_State0A_ResultScreen::
    ldh [hFarcallAArg], a                         ; $7125
    farcall ResultScreen_Far                      ; $7127
    ret                                           ; $712F


; C: jp state 0
Mode0D_State0B_Restart::
    jp Mode0D_State00_Init                        ; $7130


; C: random (Rng_Scaled) or next/previous; far calls 02:5110 and 02:4E5F; with the P.VOICE option ($D7D2 = 1) also
; Snd_PlayTagDigits (07:7169-717E)
SlidePlay_ShowNext::
    ld a, [wPlayOptB]                             ; $7133
    and a                                         ; $7136
    jr z, jr_007_7151                             ; $7137

    ld a, [wSlideshowIdx]                         ; $7139
    ld hl, wPlayDirection                         ; $713C
    add [hl]                                      ; $713F
    ld hl, wPhotoCount                            ; $7140
    bit 7, a                                      ; $7143
    jr z, jr_007_714b                             ; $7145

    ld a, [hl]                                    ; $7147
    dec a                                         ; $7148
    jr jr_007_714f                                ; $7149

jr_007_714b:
    cp [hl]                                       ; $714B
    jr nz, jr_007_714f                            ; $714C

    xor a                                         ; $714E

jr_007_714f:
    jr jr_007_7157                                ; $714F

jr_007_7151:
    ld a, [wPhotoCount]                           ; $7151
    call Rng_Scaled                               ; $7154

jr_007_7157:
    ld [wSlideshowIdx], a                         ; $7157
    ldh [hFarcallAArg], a                         ; $715A
    farcall Photo_LoadToVram_Far                  ; $715C
    ld a, [wPlayOptA]                             ; $7164
    and a                                         ; $7167
    ret z                                         ; $7168

    ld a, [wSlideshowIdx]                         ; $7169
    ldh [hFarcallAArg], a                         ; $716C
    farcall Photo_LoadTagFields_Far               ; $716E
    call Snd_PlayTagDigits                        ; $7176
    ret                                           ; $7179


; C: Left/Right = direction; Up/Down = interval 1..$FA
SlidePlay_ReadKeys::
    ldh a, [hKeysNewSticky]                       ; $717A
    ld b, a                                       ; $717C
    bit 5, b                                      ; $717D
    jr z, jr_007_7185                             ; $717F

    ld a, $ff                                     ; $7181
    jr jr_007_718b                                ; $7183

jr_007_7185:
    bit 4, b                                      ; $7185
    jr z, jr_007_718e                             ; $7187

    ld a, $01                                     ; $7189

jr_007_718b:
    ld [wPlayDirection], a                        ; $718B

jr_007_718e:
    ldh a, [hKeysHeldSticky]                      ; $718E
    ld b, a                                       ; $7190
    ld a, [wPlayInterval]                         ; $7191
    bit 6, b                                      ; $7194
    jr z, jr_007_719e                             ; $7196

    cp $01                                        ; $7198
    ret z                                         ; $719A

    dec a                                         ; $719B
    jr jr_007_71a6                                ; $719C

jr_007_719e:
    bit 7, b                                      ; $719E
    jr z, jr_007_71a6                             ; $71A0

    cp $fa                                        ; $71A2
    ret z                                         ; $71A4

    inc a                                         ; $71A5

jr_007_71a6:
    ld [wPlayInterval], a                         ; $71A6
    ret                                           ; $71A9


; C: mode 0: main menu (two pages: SHOOT/VIEW/Arcade; Doodle/LINK/Special/Edit)
Mode00_MainMenu::
    ld a, [wState]                                ; $71AA
    rst Rst18_JumpTable                           ; $71AD

; I: 9 states
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $71C0
    ldh [hLcdcShadow], a                          ; $71C2
    ld a, $e4                                     ; $71C4
    ld [wPaletteTarget], a                        ; $71C6
    ld [wPaletteTarget + $1], a                   ; $71C9
    ld a, $d2                                     ; $71CC
    ld [wPaletteTarget + $2], a                   ; $71CE
    xor a                                         ; $71D1
    ldh [hScxShadow], a                           ; $71D2
    ldh [hScyShadow], a                           ; $71D4
    ld [wMenuUpCol], a                            ; $71D6
    ldh [hFarcallAArg], a                         ; $71D9
    farcall Owner_GenerateId_Far                  ; $71DB
    call MainMenu_LoadIconTilesB                  ; $71E3
    call MainMenu_LoadIconTilesA                  ; $71E6
    call MainMenu_LoadBaseTiles                   ; $71E9
    call MainMenu_LoadBackground                  ; $71EC
    farcopy Mem_CopyFromBank, Gfx_15_5400_Mode00_State00_Init, $9000, $0100 ; $71EF
    farcopy Mem_CopyFromBank, Gfx_15_4600_Mode00_State00_Init, $8e00, $0300 ; $71FD
    farcopy Mem_CopyFromBank, Gfx_15_4900_Mode00_State00_Init, $9700, $0100 ; $720B
    farcopy Mem_CopyFromBank, Gfx_15_5600_Mode00_State00_Init, $8500, $0100 ; $7219
    farcopy Mem_CopyFromBank, Gfx_11_4F00_MainMenu_LoadBaseTiles, $8000, $0300 ; $7227
    farcopy Mem_CopyFromBank, Gfx_11_5200_MainMenu_DrawUpperItem0, $8600, $0100 ; $7235
    ld hl, $9a40                                  ; $7243
    ld bc, $01c0                                  ; $7246
    ld a, $7f                                     ; $7249
    call Mem_FillBc1                              ; $724B
    screen_on                                     ; $724E
    call Pal_FadeIn                               ; $7257
    play_music MUSIC_MAIN_MENU                    ; $725A
    ld a, [wMenuItem]                             ; $7261
    ld c, a                                       ; $7264
    ld b, $00                                     ; $7265
    ld hl, Mode00_State00_Init_Tbl7270            ; $7267
    add hl, bc                                    ; $726A
    ld a, [hl]                                    ; $726B
    ld [wState], a                                ; $726C
    ret                                           ; $726F


; C: auto: 7 bytes, bytes; referenced by Mode00_State00_Init. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the
; organic corpus, modes 00 (tcrf_check/assets/l3_names/)
Mode00_State00_Init_Tbl7270::
    db $01, $02, $03, $04, $05, $06, $07

; I: upper page item 0 selected
Mode00_State01_Item0_Shoot::
    call MainMenu_DrawUpperItem1                  ; $7277
    ldh a, [hKeysNew]                             ; $727A
    and PADF_A | PADF_B | PADF_START              ; $727C
    jr z, jr_007_72a1                             ; $727E

    ld [wAbResult], a                             ; $7280
    ld a, [wState]                                ; $7283
    ld [wMenuStateCopy], a                        ; $7286
    push af                                       ; $7289
    bit 0, a                                      ; $728A
    ld a, SFX1_KEY_A                              ; $728C
    call nz, Snd_Sfx1                             ; $728E
    pop af                                        ; $7291
    push af                                       ; $7292
    bit 1, a                                      ; $7293
    ld a, SFX1_KEY_B                              ; $7295
    call nz, Snd_Sfx1                             ; $7297
    pop af                                        ; $729A
    set_state STATE_00_LAUNCH                     ; $729B
    ret                                           ; $72A0


jr_007_72a1:
    ldh a, [hKeysNew]                             ; $72A1
    bit PADB_RIGHT, a                             ; $72A3
    jr z, jr_007_72c2                             ; $72A5

    play_sfx3 SFX3_MAIN_MENU_SHOOT                ; $72A7
    ld de, MainMenu_SlideA_Tbl0                   ; $72AE
    ld hl, MainMenu_DrawUpperItem1                ; $72B1
    call MainMenu_SlideA_Begin                    ; $72B4
    ld a, $01                                     ; $72B7
    ld [wMenuItem], a                             ; $72B9
    set_state STATE_00_ITEM1_VIEW                 ; $72BC
    ret                                           ; $72C1


jr_007_72c2:
    bit 7, a                                      ; $72C2
    jr z, jr_007_72e5                             ; $72C4

    play_sfx3 SFX3_MAIN_MENU_SHOOT                ; $72C6
    ld de, MainMenu_SlideA_Tbl0                   ; $72CD
    ld hl, MainMenu_DrawUpperItem1                ; $72D0
    call MainMenu_SlideA_Begin                    ; $72D3
    xor a                                         ; $72D6
    ld [wMenuUpCol], a                            ; $72D7
    ld a, $02                                     ; $72DA
    ld [wMenuItem], a                             ; $72DC
    set_state STATE_00_ITEM2_ARCADE               ; $72DF
    ret                                           ; $72E4


jr_007_72e5:
    bit 2, a                                      ; $72E5
    ret z                                         ; $72E7

    play_sfx3 SFX3_MAIN_MENU_SHOOT                ; $72E8
    ld de, MainMenu_SlideA_Tbl0                   ; $72EF
    ld hl, MainMenu_DrawUpperItem1                ; $72F2
    call MainMenu_SlideA_Begin                    ; $72F5
    call MainMenu_TransitionToLowerPage           ; $72F8
    ld a, $00                                     ; $72FB
    ld [wMenuSelUpper], a                         ; $72FD
    ret                                           ; $7300


; I: upper page item 1 selected
Mode00_State02_Item1_View::
    call MainMenu_DrawUpperItem0                  ; $7301
    ldh a, [hKeysNew]                             ; $7304
    and PADF_A | PADF_B | PADF_START              ; $7306
    jr z, jr_007_732b                             ; $7308

    ld [wAbResult], a                             ; $730A
    ld a, [wState]                                ; $730D
    ld [wMenuStateCopy], a                        ; $7310
    push af                                       ; $7313
    bit 0, a                                      ; $7314
    ld a, SFX1_KEY_A                              ; $7316
    call nz, Snd_Sfx1                             ; $7318
    pop af                                        ; $731B
    push af                                       ; $731C
    bit 1, a                                      ; $731D
    ld a, SFX1_KEY_B                              ; $731F
    call nz, Snd_Sfx1                             ; $7321
    pop af                                        ; $7324
    set_state STATE_00_LAUNCH                     ; $7325
    ret                                           ; $732A


jr_007_732b:
    ldh a, [hKeysNew]                             ; $732B
    bit PADB_LEFT, a                              ; $732D
    jr z, jr_007_734b                             ; $732F

    play_sfx3 SFX3_MAIN_MENU_VIEW_ARCADE          ; $7331
    ld de, MainMenu_SlideA_Tbl1                   ; $7338
    ld hl, MainMenu_DrawUpperItem0                ; $733B
    call MainMenu_SlideA_Begin                    ; $733E
    xor a                                         ; $7341
    ld [wMenuItem], a                             ; $7342
    set_state STATE_00_ITEM0_SHOOT                ; $7345
    ret                                           ; $734A


jr_007_734b:
    bit 7, a                                      ; $734B
    jr z, jr_007_7366                             ; $734D

    ld a, $01                                     ; $734F
    ld [wMenuUpCol], a                            ; $7351
    ld a, $02                                     ; $7354
    ld [wMenuItem], a                             ; $7356
    play_sfx1 SFX1_KEY_START                      ; $7359
    set_state STATE_00_ITEM2_ARCADE               ; $7360
    ret                                           ; $7365


jr_007_7366:
    bit 2, a                                      ; $7366
    ret z                                         ; $7368

    call MainMenu_TransitionToLowerPage           ; $7369
    ld a, $01                                     ; $736C
    ld [wMenuSelUpper], a                         ; $736E
    ret                                           ; $7371


; I: upper page item 2 selected
Mode00_State03_Item2_Arcade::
    call MainMenu_DrawUpperItem2                  ; $7372
    ldh a, [hKeysNew]                             ; $7375
    and PADF_A | PADF_B | PADF_START              ; $7377
    jr z, jr_007_739c                             ; $7379

    ld [wAbResult], a                             ; $737B
    ld a, [wState]                                ; $737E
    ld [wMenuStateCopy], a                        ; $7381
    push af                                       ; $7384
    bit 0, a                                      ; $7385
    ld a, SFX1_KEY_A                              ; $7387
    call nz, Snd_Sfx1                             ; $7389
    pop af                                        ; $738C
    push af                                       ; $738D
    bit 1, a                                      ; $738E
    ld a, SFX1_KEY_B                              ; $7390
    call nz, Snd_Sfx1                             ; $7392
    pop af                                        ; $7395
    set_state STATE_00_LAUNCH                     ; $7396
    ret                                           ; $739B


jr_007_739c:
    ldh a, [hKeysNew]                             ; $739C
    bit PADB_SELECT, a                            ; $739E
    jr z, jr_007_73ab                             ; $73A0

    call MainMenu_TransitionToLowerPage           ; $73A2
    ld a, $02                                     ; $73A5
    ld [wMenuSelUpper], a                         ; $73A7
    ret                                           ; $73AA


jr_007_73ab:
    bit 5, a                                      ; $73AB
    jr z, jr_007_73d7                             ; $73AD

jr_007_73af:
    farcopy Vram_CopyFromBank, Gfx_15_4E00_MainMenu_LoadBaseTiles, $8300, $0200 ; $73AF
    play_sfx3 SFX3_MAIN_MENU_VIEW_ARCADE          ; $73BD
    ld de, MainMenu_SlideA_Tbl1                   ; $73C4
    ld hl, MainMenu_DrawUpperItem2                ; $73C7
    call MainMenu_SlideA_Begin                    ; $73CA
    xor a                                         ; $73CD
    ld [wMenuItem], a                             ; $73CE
    set_state STATE_00_ITEM0_SHOOT                ; $73D1
    ret                                           ; $73D6


jr_007_73d7:
    bit 4, a                                      ; $73D7
    jr z, jr_007_73fb                             ; $73D9

jr_007_73db:
    farcopy Vram_CopyFromBank, Gfx_15_4E00_MainMenu_LoadBaseTiles, $8300, $0200 ; $73DB
    ld a, $01                                     ; $73E9
    ld [wMenuItem], a                             ; $73EB
    play_sfx1 SFX1_KEY_START                      ; $73EE
    set_state STATE_00_ITEM1_VIEW                 ; $73F5
    ret                                           ; $73FA


jr_007_73fb:
    bit 6, a                                      ; $73FB
    ret z                                         ; $73FD

    ld a, [wMenuUpCol]                            ; $73FE
    and a                                         ; $7401
    jr z, jr_007_73af                             ; $7402

    jr jr_007_73db                                ; $7404

; C: screen shake and page slide
MainMenu_TransitionToLowerPage::
    play_sfx1 SFX1_MAIN_MENU_PAGE_TURN            ; $7406
    ld de, MainMenu_SlideB_Tbl0                   ; $740D
    ld hl, MainMenu_TransitionToLowerPage_74BF    ; $7410
    call MainMenu_SlideB_Begin                    ; $7413
    ld a, $03                                     ; $7416

jr_007_7418:
    push af                                       ; $7418
    call Rng_Next                                 ; $7419
    and $03                                       ; $741C
    sub $01                                       ; $741E
    ldh [hScxShadow], a                           ; $7420
    call Rng_Next                                 ; $7422
    and $03                                       ; $7425
    sub $01                                       ; $7427
    ldh [hScyShadow], a                           ; $7429
    rst Rst08_WaitVBlank                          ; $742B
    pop af                                        ; $742C
    dec a                                         ; $742D
    jr nz, jr_007_7418                            ; $742E

    xor a                                         ; $7430
    ldh [hScxShadow], a                           ; $7431
    ldh [hScyShadow], a                           ; $7433
    play_sfx1 SFX1_MAIN_MENU_PAGE_DOWN            ; $7435
    ld de, MainMenu_SlideB_Tbl2                   ; $743C
    ld hl, MainMenu_TransitionToLowerPage_74BF    ; $743F
    call MainMenu_SlideB_Begin                    ; $7442
    ld de, MainMenu_SlideC_Tbl0                   ; $7445
    ld hl, MainMenu_TransitionToLowerPage_74BF    ; $7448
    call MainMenu_SlideC_Begin                    ; $744B
    ld a, [wMenuSelLower]                         ; $744E
    and a                                         ; $7451
    jr nz, jr_007_746d                            ; $7452

    farcopy Vram_CopyFromBank, Gfx_15_4D00_MainMenu_LoadBackground, $8700, $0100 ; $7454
    ld a, $03                                     ; $7462
    ld [wMenuItem], a                             ; $7464
    set_state STATE_00_ITEM3_DOODLE               ; $7467
    ret                                           ; $746C


jr_007_746d:
    cp $01                                        ; $746D
    jr nz, jr_007_748a                            ; $746F

    farcopy Vram_CopyFromBank, Gfx_15_4A00_MainMenu_LoadBackground, $8700, $0100 ; $7471
    ld a, $04                                     ; $747F
    ld [wMenuItem], a                             ; $7481
    set_state STATE_00_ITEM4_LINK                 ; $7484
    ret                                           ; $7489


jr_007_748a:
    cp $02                                        ; $748A
    jr nz, jr_007_74a7                            ; $748C

    farcopy Vram_CopyFromBank, Gfx_15_4B00_MainMenu_LoadBackground, $8700, $0100 ; $748E
    ld a, $05                                     ; $749C
    ld [wMenuItem], a                             ; $749E
    set_state STATE_00_ITEM5_SPECIAL              ; $74A1
    ret                                           ; $74A6


jr_007_74a7:
    farcopy Vram_CopyFromBank, Gfx_15_4C00_MainMenu_LoadBackground, $8700, $0100 ; $74A7
    ld a, $06                                     ; $74B5
    ld [wMenuItem], a                             ; $74B7
    set_state STATE_00_ITEM6_EDIT                 ; $74BA
MainMenu_TransitionToLowerPage_74BF:
    ret                                           ; $74BF


; C: lower page item 3 selected
Mode00_State04_Item3_Doodle::
    call MainMenu_DrawLowerItem3                  ; $74C0
    ldh a, [hKeysNew]                             ; $74C3
    bit PADB_A, a                                 ; $74C5
    jr z, jr_007_74df                             ; $74C7

    ld [wAbResult], a                             ; $74C9
    ld a, [wState]                                ; $74CC
    ld [wMenuStateCopy], a                        ; $74CF
    play_sfx1 SFX1_KEY_A                          ; $74D2
    set_state STATE_00_LAUNCH                     ; $74D9
    ret                                           ; $74DE


jr_007_74df:
    ldh a, [hKeysNew]                             ; $74DF
    bit PADB_UP, a                                ; $74E1
    jr z, jr_007_7509                             ; $74E3

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $74E5
    call Oam_ClearShadow                          ; $74EC
    rst Rst08_WaitVBlank                          ; $74EF
    farcopy Vram_CopyFromBank, Gfx_15_4A00_MainMenu_LoadBackground, $8700, $0100 ; $74F0
    ld a, $04                                     ; $74FE
    ld [wMenuItem], a                             ; $7500
    set_state STATE_00_ITEM4_LINK                 ; $7503
    ret                                           ; $7508


jr_007_7509:
    bit 4, a                                      ; $7509
    jr z, jr_007_7531                             ; $750B

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $750D
    call Oam_ClearShadow                          ; $7514
    rst Rst08_WaitVBlank                          ; $7517
    farcopy Vram_CopyFromBank, Gfx_15_4B00_MainMenu_LoadBackground, $8700, $0100 ; $7518
    ld a, $05                                     ; $7526
    ld [wMenuItem], a                             ; $7528
    set_state STATE_00_ITEM5_SPECIAL              ; $752B
    ret                                           ; $7530


jr_007_7531:
    bit 7, a                                      ; $7531
    jr z, jr_007_7559                             ; $7533

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $7535
    call Oam_ClearShadow                          ; $753C
    rst Rst08_WaitVBlank                          ; $753F
    farcopy Vram_CopyFromBank, Gfx_15_4C00_MainMenu_LoadBackground, $8700, $0100 ; $7540
    ld a, $06                                     ; $754E
    ld [wMenuItem], a                             ; $7550
    set_state STATE_00_ITEM6_EDIT                 ; $7553
    ret                                           ; $7558


jr_007_7559:
    bit 2, a                                      ; $7559
    jr nz, jr_007_7560                            ; $755B

    bit 1, a                                      ; $755D
    ret z                                         ; $755F

jr_007_7560:
    xor a                                         ; $7560
    ld [wMenuSelLower], a                         ; $7561
    call MainMenu_TransitionToUpperPage           ; $7564
    ret                                           ; $7567


; C: lower page item 4 selected
Mode00_State05_Item4_Link::
    call MainMenu_DrawLowerItem4                  ; $7568
    ldh a, [hKeysNew]                             ; $756B
    bit PADB_A, a                                 ; $756D
    jr z, jr_007_7587                             ; $756F

    ld [wAbResult], a                             ; $7571
    ld a, [wState]                                ; $7574
    ld [wMenuStateCopy], a                        ; $7577
    play_sfx1 SFX1_KEY_A                          ; $757A
    set_state STATE_00_LAUNCH                     ; $7581
    ret                                           ; $7586


jr_007_7587:
    ldh a, [hKeysNew]                             ; $7587
    bit PADB_LEFT, a                              ; $7589
    jr z, jr_007_75b1                             ; $758B

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $758D
    call Oam_ClearShadow                          ; $7594
    rst Rst08_WaitVBlank                          ; $7597
    farcopy Vram_CopyFromBank, Gfx_15_4D00_MainMenu_LoadBackground, $8700, $0100 ; $7598
    ld a, $03                                     ; $75A6
    ld [wMenuItem], a                             ; $75A8
    set_state STATE_00_ITEM3_DOODLE               ; $75AB
    ret                                           ; $75B0


jr_007_75b1:
    bit 4, a                                      ; $75B1
    jr z, jr_007_75d9                             ; $75B3

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $75B5
    call Oam_ClearShadow                          ; $75BC
    rst Rst08_WaitVBlank                          ; $75BF
    farcopy Vram_CopyFromBank, Gfx_15_4B00_MainMenu_LoadBackground, $8700, $0100 ; $75C0
    ld a, $05                                     ; $75CE
    ld [wMenuItem], a                             ; $75D0
    set_state STATE_00_ITEM5_SPECIAL              ; $75D3
    ret                                           ; $75D8


jr_007_75d9:
    bit 7, a                                      ; $75D9
    jr z, jr_007_7601                             ; $75DB

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $75DD
    call Oam_ClearShadow                          ; $75E4
    rst Rst08_WaitVBlank                          ; $75E7
    farcopy Vram_CopyFromBank, Gfx_15_4C00_MainMenu_LoadBackground, $8700, $0100 ; $75E8
    ld a, $06                                     ; $75F6
    ld [wMenuItem], a                             ; $75F8
    set_state STATE_00_ITEM6_EDIT                 ; $75FB
    ret                                           ; $7600


jr_007_7601:
    bit 2, a                                      ; $7601
    jr nz, jr_007_7608                            ; $7603

    bit 1, a                                      ; $7605
    ret z                                         ; $7607

jr_007_7608:
    ld a, $01                                     ; $7608
    ld [wMenuSelLower], a                         ; $760A
    call MainMenu_TransitionToUpperPage           ; $760D
    ret                                           ; $7610


; C: lower page item 5 selected
Mode00_State06_Item5_Special::
    call MainMenu_DrawLowerItem5                  ; $7611
    ldh a, [hKeysNew]                             ; $7614
    bit PADB_A, a                                 ; $7616
    jr z, jr_007_7630                             ; $7618

    ld [wAbResult], a                             ; $761A
    ld a, [wState]                                ; $761D
    ld [wMenuStateCopy], a                        ; $7620
    play_sfx1 SFX1_KEY_A                          ; $7623
    set_state STATE_00_LAUNCH                     ; $762A
    ret                                           ; $762F


jr_007_7630:
    ldh a, [hKeysNew]                             ; $7630
    bit PADB_UP, a                                ; $7632
    jr z, jr_007_765a                             ; $7634

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $7636
    call Oam_ClearShadow                          ; $763D
    rst Rst08_WaitVBlank                          ; $7640
    farcopy Vram_CopyFromBank, Gfx_15_4A00_MainMenu_LoadBackground, $8700, $0100 ; $7641
    ld a, $04                                     ; $764F
    ld [wMenuItem], a                             ; $7651
    set_state STATE_00_ITEM4_LINK                 ; $7654
    ret                                           ; $7659


jr_007_765a:
    bit 5, a                                      ; $765A
    jr z, jr_007_7682                             ; $765C

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $765E
    call Oam_ClearShadow                          ; $7665
    rst Rst08_WaitVBlank                          ; $7668
    farcopy Vram_CopyFromBank, Gfx_15_4D00_MainMenu_LoadBackground, $8700, $0100 ; $7669
    ld a, $03                                     ; $7677
    ld [wMenuItem], a                             ; $7679
    set_state STATE_00_ITEM3_DOODLE               ; $767C
    ret                                           ; $7681


jr_007_7682:
    bit 7, a                                      ; $7682
    jr z, jr_007_76aa                             ; $7684

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $7686
    call Oam_ClearShadow                          ; $768D
    rst Rst08_WaitVBlank                          ; $7690
    farcopy Vram_CopyFromBank, Gfx_15_4C00_MainMenu_LoadBackground, $8700, $0100 ; $7691
    ld a, $06                                     ; $769F
    ld [wMenuItem], a                             ; $76A1
    set_state STATE_00_ITEM6_EDIT                 ; $76A4
    ret                                           ; $76A9


jr_007_76aa:
    bit 2, a                                      ; $76AA
    jr nz, jr_007_76b1                            ; $76AC

    bit 1, a                                      ; $76AE
    ret z                                         ; $76B0

jr_007_76b1:
    ld a, $02                                     ; $76B1
    ld [wMenuSelLower], a                         ; $76B3
    call MainMenu_TransitionToUpperPage           ; $76B6
    ret                                           ; $76B9


; C: lower page item 6 selected
Mode00_State07_Item6_Edit::
    call MainMenu_DrawLowerItem6                  ; $76BA
    ldh a, [hKeysNew]                             ; $76BD
    bit PADB_A, a                                 ; $76BF
    jr z, jr_007_76d9                             ; $76C1

    ld [wAbResult], a                             ; $76C3
    ld a, [wState]                                ; $76C6
    ld [wMenuStateCopy], a                        ; $76C9
    play_sfx1 SFX1_KEY_A                          ; $76CC
    set_state STATE_00_LAUNCH                     ; $76D3
    ret                                           ; $76D8


jr_007_76d9:
    ldh a, [hKeysNew]                             ; $76D9
    bit PADB_UP, a                                ; $76DB
    jr z, jr_007_7703                             ; $76DD

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $76DF
    call Oam_ClearShadow                          ; $76E6
    rst Rst08_WaitVBlank                          ; $76E9
    farcopy Vram_CopyFromBank, Gfx_15_4A00_MainMenu_LoadBackground, $8700, $0100 ; $76EA
    ld a, $04                                     ; $76F8
    ld [wMenuItem], a                             ; $76FA
    set_state STATE_00_ITEM4_LINK                 ; $76FD
    ret                                           ; $7702


jr_007_7703:
    bit 4, a                                      ; $7703
    jr z, jr_007_772b                             ; $7705

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $7707
    call Oam_ClearShadow                          ; $770E
    rst Rst08_WaitVBlank                          ; $7711
    farcopy Vram_CopyFromBank, Gfx_15_4B00_MainMenu_LoadBackground, $8700, $0100 ; $7712
    ld a, $05                                     ; $7720
    ld [wMenuItem], a                             ; $7722
    set_state STATE_00_ITEM5_SPECIAL              ; $7725
    ret                                           ; $772A


jr_007_772b:
    bit 5, a                                      ; $772B
    jr z, jr_007_7753                             ; $772D

    play_sfx1 SFX1_MAIN_MENU_MOVE                 ; $772F
    call Oam_ClearShadow                          ; $7736
    rst Rst08_WaitVBlank                          ; $7739
    farcopy Vram_CopyFromBank, Gfx_15_4D00_MainMenu_LoadBackground, $8700, $0100 ; $773A
    ld a, $03                                     ; $7748
    ld [wMenuItem], a                             ; $774A
    set_state STATE_00_ITEM3_DOODLE               ; $774D
    ret                                           ; $7752


jr_007_7753:
    bit 2, a                                      ; $7753
    jr nz, jr_007_775a                            ; $7755

    bit 1, a                                      ; $7757
    ret z                                         ; $7759

jr_007_775a:
    ld a, $03                                     ; $775A
    ld [wMenuSelLower], a                         ; $775C
    call MainMenu_TransitionToUpperPage           ; $775F
    ret                                           ; $7762


; C
MainMenu_TransitionToUpperPage::
    play_sfx1 SFX1_MAIN_MENU_PAGE_UP              ; $7763
    ld de, MainMenu_SlideC_Tbl1                   ; $776A
    ld hl, MainMenu_NoDrawCallback                ; $776D
    call MainMenu_SlideC_Begin                    ; $7770
    ld de, MainMenu_SlideB_Tbl3                   ; $7773
    ld hl, MainMenu_NoDrawCallback                ; $7776
    call MainMenu_SlideB_Begin                    ; $7779
    play_sfx1 SFX1_MAIN_MENU_PAGE_TURN            ; $777C
    ld de, MainMenu_SlideB_Tbl1                   ; $7783
    ld hl, MainMenu_NoDrawCallback                ; $7786
    call MainMenu_SlideB_Begin                    ; $7789
    ld a, [wMenuSelUpper]                         ; $778C
    and a                                         ; $778F
    jr nz, MainMenu_ReturnToUpperItem             ; $7790

    play_sfx3 SFX3_MAIN_MENU_VIEW_ARCADE          ; $7792
    ld de, MainMenu_SlideA_Tbl1                   ; $7799
    ld hl, MainMenu_NoDrawCallback                ; $779C
    call MainMenu_SlideA_Begin                    ; $779F
    xor a                                         ; $77A2
    ld [wMenuItem], a                             ; $77A3
    set_state STATE_00_ITEM0_SHOOT                ; $77A6

; C: a bare ret used as the draw callback
MainMenu_NoDrawCallback::
    ret                                           ; $77AB


; C: state 1 / 2 / 3 by menu_sel_upper. L3 pass 2026-10-26: executed in BGB in 33 replay(s) of the organic corpus,
; modes 00 (tcrf_check/assets/l3_names/)
MainMenu_ReturnToUpperItem::
    cp $01                                        ; $77AC
    jr nz, jr_007_77bb                            ; $77AE

    ld a, $01                                     ; $77B0
    ld [wMenuItem], a                             ; $77B2
    set_state STATE_00_ITEM1_VIEW                 ; $77B5
    ret                                           ; $77BA


jr_007_77bb:
    ld a, $02                                     ; $77BB
    ld [wMenuItem], a                             ; $77BD
    set_state STATE_00_ITEM2_ARCADE               ; $77C0
    ret                                           ; $77C5


; C: mode := ItemModeTbl [menu_item]; B -> mode $19; Start -> mode 8
Mode00_State08_Launch::
    ld a, [wAbResult]                             ; $77C6
    bit 0, a                                      ; $77C9
    jr z, jr_007_77fb                             ; $77CB

    ld a, [wMenuItem]                             ; $77CD
    ld e, a                                       ; $77D0
    ld d, $00                                     ; $77D1
    ld hl, MainMenu_ItemModeTbl                   ; $77D3
    add hl, de                                    ; $77D6
    ld a, [hl]                                    ; $77D7
    cp MODE_COUNT                                 ; $77D8
    jr c, jr_007_77ea                             ; $77DA

    play_sfx1 SFX1_BEEP_REFUSED                   ; $77DC
    ld a, [wMenuStateCopy]                        ; $77E3
    ld [wState], a                                ; $77E6
    ret                                           ; $77E9


jr_007_77ea:
    ld [wMode], a                                 ; $77EA
    xor a                                         ; $77ED
    ld [wState], a                                ; $77EE
    ld [wDoodleFromShutterbug], a                 ; $77F1
    screen_off                                    ; $77F4
    ret                                           ; $77FA


jr_007_77fb:
    bit 1, a                                      ; $77FB
    jr z, jr_007_7810                             ; $77FD

    ld a, MODE_TITLE_SCREENS                      ; $77FF
    ld [wMode], a                                 ; $7801
    set_state STATE_19_TITLE_FROM_MENU            ; $7804
    screen_off                                    ; $7809
    ret                                           ; $780F


jr_007_7810:
    ld a, MODE_USER_SCREENS                       ; $7810
    ld [wMode], a                                 ; $7812
    set_state STATE_08_INIT                       ; $7815
    ret                                           ; $781A


; C: $01 $02 $07 $04 $06 $03 $05
MainMenu_ItemModeTbl::
    db MODE_SHOOT_PARLOR, MODE_VIEW_MENU, MODE_ARCADE_SPACE_FEVER, MODE_DOODLE_MENU, MODE_LINK_MENU, MODE_SPECIAL_MENU, MODE_EDIT_MENU, MODE_NONE

; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadIconTilesA::
    ld a, [wMenuItem]                             ; $7823
    and a                                         ; $7826
    jr z, jr_007_784b                             ; $7827

    cp $03                                        ; $7829
    jr nc, jr_007_783c                            ; $782B

    farcopy Mem_CopyFromBank, Gfx_16_7180_MainMenu_BallHeadAnim_F4, $9100, $0200 ; $782D
    ret                                           ; $783B


jr_007_783c:
    farcopy Mem_CopyFromBank, Gfx_16_7B80_MainMenu_BallHeadAnim_F9, $9100, $0200 ; $783C
    ret                                           ; $784A


jr_007_784b:
    farcopy Mem_CopyFromBank, Gfx_16_6980_MainMenu_BallHeadAnim_F0, $9100, $0200 ; $784B
    ret                                           ; $7859


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadIconTilesB::
    ld a, [wMenuItem]                             ; $785A
    cp $03                                        ; $785D
    jr nc, jr_007_7870                            ; $785F

    farcopy Mem_CopyFromBank, Gfx_16_5580_MainMenu_IconStripB_F0, $9200, $0500 ; $7861
    ret                                           ; $786F


jr_007_7870:
    farcopy Mem_CopyFromBank, Gfx_11_4A00_MainMenu_IconStripB_F6, $9200, $0500 ; $7870
    ret                                           ; $787E


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadBaseTiles::
    farcopy Mem_CopyFromBank, Gfx_11_4F00_MainMenu_LoadBaseTiles, $8000, $0300 ; $787F
    farcopy Mem_CopyFromBank, Gfx_15_4E00_MainMenu_LoadBaseTiles, $8300, $0200 ; $788D
    ret                                           ; $789B


; C: L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_LoadBackground::
    farcopy Mem_CopyFromBank, Map_26_57C0_MainMenu_LoadBackground, $9800, $0240 ; $789C
    ld a, $15                                     ; $78AA
    ld hl, Gfx_15_4000_MainMenu_LoadBackground    ; $78AC
    ld de, $8800                                  ; $78AF
    ld bc, $0600                                  ; $78B2
    call Mem_CopyFromBank                         ; $78B5
    ld a, [wMenuItem]                             ; $78B8
    cp $03                                        ; $78BB
    ret c                                         ; $78BD

    farcopy Mem_CopyFromBank, Map_27_6590_MainMenu_LoadBackground, $9860, $01c0 ; $78BE
    ld a, [wMenuItem]                             ; $78CC
    cp $03                                        ; $78CF
    jr nz, jr_007_78e2                            ; $78D1

    farcopy Mem_CopyFromBank, Gfx_15_4D00_MainMenu_LoadBackground, $8700, $0100 ; $78D3
    ret                                           ; $78E1


jr_007_78e2:
    cp $04                                        ; $78E2
    jr nz, jr_007_78f5                            ; $78E4

    farcopy Mem_CopyFromBank, Gfx_15_4A00_MainMenu_LoadBackground, $8700, $0100 ; $78E6
    ret                                           ; $78F4


jr_007_78f5:
    cp $05                                        ; $78F5
    jr nz, jr_007_7908                            ; $78F7

    farcopy Mem_CopyFromBank, Gfx_15_4B00_MainMenu_LoadBackground, $8700, $0100 ; $78F9
    ret                                           ; $7907


jr_007_7908:
    farcopy Mem_CopyFromBank, Gfx_15_4C00_MainMenu_LoadBackground, $8700, $0100 ; $7908
    ret                                           ; $7916


; C: B animators of 6-byte entries at HL
MainMenu_StepIconAnimators::
    ld de, wMenuAnimFrame                         ; $7917

jr_007_791a:
    push bc                                       ; $791A
    push de                                       ; $791B
    ld a, [de]                                    ; $791C
    cp [hl]                                       ; $791D
    jr c, jr_007_7925                             ; $791E

    inc hl                                        ; $7920
    cp [hl]                                       ; $7921
    jr c, jr_007_7928                             ; $7922

    dec hl                                        ; $7924

jr_007_7925:
    ld a, [hl]                                    ; $7925
    ld [de], a                                    ; $7926
    inc hl                                        ; $7927

jr_007_7928:
    inc hl                                        ; $7928
    ld a, e                                       ; $7929
    add $05                                       ; $792A
    ld e, a                                       ; $792C
    jr nc, jr_007_7930                            ; $792D

    inc d                                         ; $792F

jr_007_7930:
    ld a, [hl+]                                   ; $7930
    ld [de], a                                    ; $7931
    ld a, e                                       ; $7932
    add $05                                       ; $7933
    ld e, a                                       ; $7935
    jr nc, jr_007_7939                            ; $7936

    inc d                                         ; $7938

jr_007_7939:
    ld a, [hl+]                                   ; $7939
    ld [de], a                                    ; $793A
    push hl                                       ; $793B
    ld bc, MainMenu_StepIconAnimators_Next        ; $793C
    push bc                                       ; $793F
    ld a, [hl+]                                   ; $7940
    ld h, [hl]                                    ; $7941
    ld l, a                                       ; $7942
    jp hl                                         ; $7943


; C: loop tail. L3 pass 2026-10-26: executed in BGB in 203 replay(s) of the organic corpus, modes 00
; (tcrf_check/assets/l3_names/)
MainMenu_StepIconAnimators_Next::
    pop hl                                        ; $7944
    pop de                                        ; $7945
    pop bc                                        ; $7946
    inc hl                                        ; $7947
    inc hl                                        ; $7948
    inc de                                        ; $7949
    dec b                                         ; $794A
    jr nz, jr_007_791a                            ; $794B

    ret                                           ; $794D


; I
MainMenu_DrawUpperItem0::
    ld hl, MainMenu_UpperItem0_AnimTbl            ; $794E
    ld b, $03                                     ; $7951
    call MainMenu_StepIconAnimators               ; $7953
    ld bc, $5081                                  ; $7956
    ld a, $21                                     ; $7959
    call Oam_AddMeta_B02_52BD                     ; $795B
    ld a, [wMenuAnimTick]                         ; $795E
    cp $01                                        ; $7961
    ret nz                                        ; $7963

    ld a, [wMenuAnimFrame]                        ; $7964
    cp $39                                        ; $7967
    jr nz, jr_007_796c                            ; $7969

    ret                                           ; $796B


jr_007_796c:
    cp $3b                                        ; $796C
    jr nz, jr_007_7971                            ; $796E

    ret                                           ; $7970


jr_007_7971:
    ret                                           ; $7971


; I
MainMenu_UpperItem0_AnimTbl::
    db $39, $3e, $24, $7a, $b4, $7a, $03, $08, $14, $64, $b9, $7a, $0d, $12, $5f, $7c
    db $be, $7a

; I
MainMenu_DrawUpperItem1::
    ld hl, MainMenu_UpperItem1_AnimTbl            ; $7984
    ld b, $03                                     ; $7987
    call MainMenu_StepIconAnimators               ; $7989
    ld bc, $5081                                  ; $798C
    ld a, $21                                     ; $798F
    call Oam_AddMeta_B02_52BD                     ; $7991
    ld a, [wMenuAnimTick]                         ; $7994
    cp $01                                        ; $7997
    ret nz                                        ; $7999

    ld a, [wMenuAnimFrame]                        ; $799A
    cp $3e                                        ; $799D
    jr nz, jr_007_79a2                            ; $799F

    ret                                           ; $79A1


jr_007_79a2:
    cp $40                                        ; $79A2
    jr nz, jr_007_79a7                            ; $79A4

    ret                                           ; $79A6


jr_007_79a7:
    ret                                           ; $79A7


; I
MainMenu_UpperItem1_AnimTbl::
    db $3e, $43, $24, $28
    dw MainMenu_IconCallback0
    db $08, $0d, $14, $3d
    dw MainMenu_IconCallback1
    db $12, $17, $5f, $24
    dw MainMenu_IconCallback2

; C: phase counter D A2F mod $28
MainMenu_DrawUpperItem2::
    ld a, [wMenuItem3Phase]                       ; $79BA
    inc a                                         ; $79BD
    cp $28                                        ; $79BE
    jr c, jr_007_79c3                             ; $79C0

    xor a                                         ; $79C2

jr_007_79c3:
    ld [wMenuItem3Phase], a                       ; $79C3
    and a                                         ; $79C6
    jr z, jr_007_79ef                             ; $79C7

    cp $18                                        ; $79C9
    jr z, jr_007_79df                             ; $79CB

    cp $1c                                        ; $79CD
    jr z, jr_007_79ef                             ; $79CF

    cp $20                                        ; $79D1
    jr z, jr_007_79df                             ; $79D3

    cp $24                                        ; $79D5
    jr z, jr_007_79ef                             ; $79D7

    cp $26                                        ; $79D9
    jr z, jr_007_79df                             ; $79DB

    jr jr_007_79fd                                ; $79DD

jr_007_79df:
    farcopy Vram_CopyFromBank, Gfx_15_4E00_MainMenu_LoadBaseTiles, $8300, $0200 ; $79DF
    jr jr_007_79fd                                ; $79ED

jr_007_79ef:
    farcopy Vram_CopyFromBank, Gfx_15_5000_MainMenu_DrawUpperItem2, $8300, $0200 ; $79EF

jr_007_79fd:
    ld hl, MainMenu_DrawUpperItem2_Gfx7A06        ; $79FD
    ld b, $03                                     ; $7A00
    call MainMenu_StepIconAnimators               ; $7A02
    ret                                           ; $7A05


; I: auto: 18 bytes, tile data; referenced by MainMenu_DrawUpperItem2. L3 pass 2026-10-26: read in BGB in 14 replay(s)
; of the organic corpus, modes 00 (tcrf_check/assets/l3_names/)
MainMenu_DrawUpperItem2_Gfx7A06::
    db $2d, $2f, $81, $50
    dw MainMenu_IconCallback0
    db $2f, $34, $5e, $2d
    dw MainMenu_IconCallback1
    db $34, $39, $5e, $73
    dw MainMenu_IconCallback2

; C
MainMenu_DrawLowerItem3::
    ld hl, MainMenu_LowerItem3_AnimTbl            ; $7A18
    ld b, $05                                     ; $7A1B
    call MainMenu_StepIconAnimators               ; $7A1D
    ret                                           ; $7A20


; I
MainMenu_LowerItem3_AnimTbl::
    db $00, $05, $57, $20
    dw MainMenu_IconCallback0
    db $21, $24, $50, $60
    dw MainMenu_IconCallback1
    db $24, $27, $5e, $50
    dw MainMenu_IconCallback2
    db $2a, $2d, $38, $50
    dw MainMenu_IconCallback3
    db $43, $4c, $3c, $1c
    dw MainMenu_IconCallback4

; C
MainMenu_DrawLowerItem4::
    ld hl, MainMenu_LowerItem4_AnimTbl            ; $7A3F
    ld b, $05                                     ; $7A42
    call MainMenu_StepIconAnimators               ; $7A44
    ret                                           ; $7A47


; I
MainMenu_LowerItem4_AnimTbl::
    db $00, $05, $2f, $50
    dw MainMenu_IconCallback0
    db $21, $24, $50, $60
    dw MainMenu_IconCallback1
    db $24, $27, $5e, $50
    dw MainMenu_IconCallback2
    db $27, $2a, $50, $45
    dw MainMenu_IconCallback3
    db $43, $4c, $14, $4c
    dw MainMenu_IconCallback4

; C
MainMenu_DrawLowerItem5::
    ld hl, MainMenu_LowerItem5_AnimTbl            ; $7A66
    ld b, $05                                     ; $7A69
    call MainMenu_StepIconAnimators               ; $7A6B
    ret                                           ; $7A6E


; I
MainMenu_LowerItem5_AnimTbl::
    db $00, $05, $57, $80
    dw MainMenu_IconCallback0
    db $24, $27, $5e, $50
    dw MainMenu_IconCallback1
    db $27, $2a, $50, $45
    dw MainMenu_IconCallback2
    db $2a, $2d, $38, $50
    dw MainMenu_IconCallback3
    db $43, $4c, $3c, $7c
    dw MainMenu_IconCallback4

; C
MainMenu_DrawLowerItem6::
    ld hl, MainMenu_LowerItem6_AnimTbl            ; $7A8D
    ld b, $05                                     ; $7A90
    call MainMenu_StepIconAnimators               ; $7A92
    ret                                           ; $7A95


; I
MainMenu_LowerItem6_AnimTbl::
    db $00, $05, $7f, $50
    dw MainMenu_IconCallback0
    db $21, $24, $50, $60
    dw MainMenu_IconCallback1
    db $27, $2a, $50, $45
    dw MainMenu_IconCallback2
    db $2a, $2d, $38, $50
    dw MainMenu_IconCallback3
    db $43, $4c, $64, $4c
    dw MainMenu_IconCallback4

; C: animator callback (hand-decoded; README 2.0)
MainMenu_IconCallback0::
    ld de, $0000                                  ; $7AB4
    jr jr_007_7acb                                ; $7AB7

; C
MainMenu_IconCallback1::
    ld de, $0001                                  ; $7AB9
    jr jr_007_7acb                                ; $7ABC

; C
MainMenu_IconCallback2::
    ld de, $0002                                  ; $7ABE
    jr jr_007_7acb                                ; $7AC1

; C
MainMenu_IconCallback3::
    ld de, $0003                                  ; $7AC3
    jr jr_007_7acb                                ; $7AC6

; C: falls into the common body at 7B08
MainMenu_IconCallback4::
    ld de, $0004                                  ; $7AC8

jr_007_7acb:
    ld hl, wMenuAnimFrame                         ; $7ACB
    add hl, de                                    ; $7ACE
    ld a, [hl]                                    ; $7ACF
    sla a                                         ; $7AD0
    ld c, a                                       ; $7AD2
    ld b, $00                                     ; $7AD3
    ld hl, MainMenu_IconFrameTbl                  ; $7AD5
    add hl, bc                                    ; $7AD8
    ld a, [hl+]                                   ; $7AD9
    push hl                                       ; $7ADA
    ld hl, wMenuAnimX                             ; $7ADB
    add hl, de                                    ; $7ADE
    ld b, [hl]                                    ; $7ADF
    ld hl, wMenuAnimY                             ; $7AE0
    add hl, de                                    ; $7AE3
    ld c, [hl]                                    ; $7AE4
    call Oam_AddMeta_B02_52BD                     ; $7AE5
    ld hl, wMenuAnimTick                          ; $7AE8
    add hl, de                                    ; $7AEB
    ld a, [hl]                                    ; $7AEC
    pop hl                                        ; $7AED
    cp [hl]                                       ; $7AEE
    jr c, jr_007_7b00                             ; $7AEF

    inc hl                                        ; $7AF1
    ld a, [hl+]                                   ; $7AF2
    cp $ff                                        ; $7AF3
    ld a, [hl]                                    ; $7AF5
    ld hl, wMenuAnimFrame                         ; $7AF6
    add hl, de                                    ; $7AF9
    jr z, jr_007_7afe                             ; $7AFA

    ld a, [hl]                                    ; $7AFC
    inc a                                         ; $7AFD

jr_007_7afe:
    ld [hl], a                                    ; $7AFE
    xor a                                         ; $7AFF

jr_007_7b00:
    inc a                                         ; $7B00
    ld hl, wMenuAnimTick                          ; $7B01
    add hl, de                                    ; $7B04
    ld [hl], a                                    ; $7B05
    ret                                           ; $7B06


; I: 2-byte entries: sprite; duration; $FF = loop target in the next byte
MainMenu_IconFrameTbl::
    db $00, $04, $01, $04, $ff, $00, $02, $04, $03, $04, $04, $04, $05, $04, $ff, $03
    db $06, $04, $07, $04, $08, $04, $09, $04, $ff, $08, $0a, $04, $0b, $04, $0c, $04
    db $0d, $04, $ff, $0d, $0e, $04, $0f, $04, $10, $04, $11, $04, $ff, $12, $12, $04
    db $13, $03, $14, $03, $15, $03, $ff, $17, $16, $04, $17, $03, $18, $03, $19, $03
    db $ff, $1c, $12, $10, $13, $04, $ff, $21, $1a, $10, $1b, $04, $ff, $24, $18, $10
    db $19, $04, $ff, $27, $1c, $10, $1d, $04, $ff, $2a, $20, $03, $ff, $2d, $28, $04
    db $29, $04, $2a, $04, $2b, $04, $ff, $2f, $2c, $04, $2d, $04, $2e, $04, $2f, $04
    db $ff, $34, $25, $04, $26, $04, $27, $04, $26, $04, $ff, $39, $22, $04, $23, $04
    db $24, $04, $23, $04, $ff, $3e, $1e, $08, $1f, $08, $1e, $06, $1f, $06, $1e, $04
    db $1f, $03, $1e, $02, $1f, $02, $ff, $43

; C: page transition A, entry (BC = $0400): HL = draw callback (the caller loads MainMenu_DrawUpperItem0 or a
; sibling), DE = a table of 4 records {src lo, src hi, bank}. It hides the unused sprites, waits one VBlank, then runs
; 4 steps (B counts 4 down, C = step 0..3): each step stamps $FFC8 into $DA2E, ...
MainMenu_SlideA_Begin::
    push de                                       ; $7B9F
    push hl                                       ; $7BA0
    call Oam_HideUnused                           ; $7BA1
    rst Rst08_WaitVBlank                          ; $7BA4
    pop hl                                        ; $7BA5
    pop de                                        ; $7BA6
    ld bc, $0400                                  ; $7BA7

jr_007_7baa:
    ldh a, [hFrameCounter]                        ; $7BAA
    ld [wMenuTransStamp], a                       ; $7BAC
    push hl                                       ; $7BAF
    push de                                       ; $7BB0
    push bc                                       ; $7BB1
    ld bc, MainMenu_SlideA_Step                   ; $7BB2
    push bc                                       ; $7BB5
    jp hl                                         ; $7BB6


; C: step of page transition A: record number C (3 x C added to the table) gives {src lo, hi, bank}; Vram_CopyFromBank
; copies 0x200 bytes (32 tiles) to $9100, then MainMenu_SlideWait paces the step to 4 frames; the callback is called
; every frame during the wait
MainMenu_SlideA_Step::
    pop bc                                        ; $7BB7
    pop hl                                        ; $7BB8
    push hl                                       ; $7BB9
    push bc                                       ; $7BBA
    ld a, c                                       ; $7BBB
    sla a                                         ; $7BBC
    add c                                         ; $7BBE
    ld c, a                                       ; $7BBF
    ld b, $00                                     ; $7BC0
    add hl, bc                                    ; $7BC2
    ld c, [hl]                                    ; $7BC3
    inc hl                                        ; $7BC4
    ld b, [hl]                                    ; $7BC5
    inc hl                                        ; $7BC6
    ld a, [hl]                                    ; $7BC7
    ld l, c                                       ; $7BC8
    ld h, b                                       ; $7BC9
    ld de, $9100                                  ; $7BCA
    ld bc, $0200                                  ; $7BCD
    call Vram_CopyFromBank                        ; $7BD0
    call MainMenu_SlideWait                       ; $7BD3
    pop bc                                        ; $7BD6
    pop de                                        ; $7BD7
    pop hl                                        ; $7BD8
    inc c                                         ; $7BD9
    dec b                                         ; $7BDA
    jr nz, jr_007_7baa                            ; $7BDB

    jp hl                                         ; $7BDD


; C: 4 x {lo,hi,bank} = 16:6B80, 6D80, 6F80, 7180 (frames 1-4 of the 10-frame camera ball head animation 16:6980-7D7F,
; forward sweep; owner, 2026-10-14: the animation shown when Up / Down is pressed on the main camera menu); used by
; the callers 07:7297, 72B6, 72D8
MainMenu_SlideA_Tbl0::
    dwb Gfx_16_6B80_MainMenu_BallHeadAnim_F1
    dwb Gfx_16_6D80_MainMenu_BallHeadAnim_F2
    dwb Gfx_16_6F80_MainMenu_BallHeadAnim_F3
    dwb Gfx_16_7180_MainMenu_BallHeadAnim_F4

; C: 4 x {lo,hi,bank} = 16:6F80, 6D80, 6B80, 6980 (the same frames backwards, frame 0 last); used by the callers
; 07:7321, 73AD, 7782
MainMenu_SlideA_Tbl1::
    dwb Gfx_16_6F80_MainMenu_BallHeadAnim_F3
    dwb Gfx_16_6D80_MainMenu_BallHeadAnim_F2
    dwb Gfx_16_6B80_MainMenu_BallHeadAnim_F1
    dwb Gfx_16_6980_MainMenu_BallHeadAnim_F0

; I: 4 x {lo,hi,bank} = 16:7580, 7780, 7980, 7B80 (frames 6-9 of the camera ball head animation, forward; the second
; set 16:7380-7B7F, which differs from frames 0-4 in the lower rows). NO caller: only Tbl0 and Tbl1 are ever loaded
; into DE ('ld de,Tbl' sites 07:7297-7782) and the step code never adds an ...
MainMenu_SlideA_Tbl2::
    dwb Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref
    dwb Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref
    dwb Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref
    dwb Gfx_16_7B80_MainMenu_BallHeadAnim_F9

; I: 4 x {lo,hi,bank} = 16:7980, 7780, 7580, 7380 (frames 8, 7, 6, 5 of the camera ball head animation, backward). NO
; caller (see Tbl2); 16:7380 is read by no organic run and no code (I)
MainMenu_SlideA_Tbl3::
    dwb Gfx_16_7980_MainMenu_BallHeadAnim_F8_Unref
    dwb Gfx_16_7780_MainMenu_BallHeadAnim_F7_Unref
    dwb Gfx_16_7580_MainMenu_BallHeadAnim_F6_Unref
    dwb Gfx_16_7380_MainMenu_BallHeadAnim_F5_Unref

; C: page transition B, entry: same loop as MainMenu_SlideA_Begin (4 steps, 3-byte records {lo,hi,bank} from DE, draw
; callback in HL); callers load Tbl0 (07:73F6), Tbl1 (07:776C), Tbl2 (07:7425) or Tbl3 (07:775C)
MainMenu_SlideB_Begin::
    push de                                       ; $7C0E
    push hl                                       ; $7C0F
    call Oam_HideUnused                           ; $7C10
    rst Rst08_WaitVBlank                          ; $7C13
    pop hl                                        ; $7C14
    pop de                                        ; $7C15
    ld bc, $0400                                  ; $7C16

jr_007_7c19:
    ldh a, [hFrameCounter]                        ; $7C19
    ld [wMenuTransStamp], a                       ; $7C1B
    push hl                                       ; $7C1E
    push de                                       ; $7C1F
    push bc                                       ; $7C20
    ld bc, MainMenu_SlideB_Step                   ; $7C21
    push bc                                       ; $7C24
    jp hl                                         ; $7C25


; C: step of page transition B: record C of the table, Vram_CopyFromBank copies 0x500 bytes (80 tiles) to $9200, then
; MainMenu_SlideWait
MainMenu_SlideB_Step::
    pop bc                                        ; $7C26
    pop hl                                        ; $7C27
    push hl                                       ; $7C28
    push bc                                       ; $7C29
    ld a, c                                       ; $7C2A
    sla a                                         ; $7C2B
    add c                                         ; $7C2D
    ld c, a                                       ; $7C2E
    ld b, $00                                     ; $7C2F
    add hl, bc                                    ; $7C31
    ld c, [hl]                                    ; $7C32
    inc hl                                        ; $7C33
    ld b, [hl]                                    ; $7C34
    inc hl                                        ; $7C35
    ld a, [hl]                                    ; $7C36
    ld l, c                                       ; $7C37
    ld h, b                                       ; $7C38
    ld de, $9200                                  ; $7C39
    ld bc, $0500                                  ; $7C3C
    call Vram_CopyFromBank                        ; $7C3F
    call MainMenu_SlideWait                       ; $7C42
    pop bc                                        ; $7C45
    pop de                                        ; $7C46
    pop hl                                        ; $7C47
    inc c                                         ; $7C48
    dec b                                         ; $7C49
    jr nz, jr_007_7c19                            ; $7C4A

    jp hl                                         ; $7C4C


; C: 4 x {lo,hi,bank} = 16:5A80, 5F80, 6480, 11:4000 (0x500 bytes each, frames 1-4 of the 7-frame strip 16:5580-697F +
; 11:4000-4EFF, forward); used by the caller 07:73F6
MainMenu_SlideB_Tbl0::
    dwb Gfx_16_5A80_MainMenu_IconStripB_F1
    dwb Gfx_16_5F80_MainMenu_IconStripB_F2
    dwb Gfx_16_6480_MainMenu_IconStripB_F3
    dwb Gfx_11_4000_MainMenu_IconStripB_F4

; C: 4 x {lo,hi,bank} = 16:6480, 5F80, 5A80, 5580 (backward); used by the caller 07:776C
MainMenu_SlideB_Tbl1::
    dwb Gfx_16_6480_MainMenu_IconStripB_F3
    dwb Gfx_16_5F80_MainMenu_IconStripB_F2
    dwb Gfx_16_5A80_MainMenu_IconStripB_F1
    dwb Gfx_16_5580_MainMenu_IconStripB_F0

; C: 4 x {lo,hi,bank} = 11:4500, 4500, 4A00, 4A00 (each frame twice); used by the caller 07:7425
MainMenu_SlideB_Tbl2::
    dwb Gfx_11_4500_MainMenu_IconStripB_F5
    dwb Gfx_11_4500_MainMenu_IconStripB_F5
    dwb Gfx_11_4A00_MainMenu_IconStripB_F6
    dwb Gfx_11_4A00_MainMenu_IconStripB_F6

; C: 4 x {lo,hi,bank} = 11:4500, 4500, 4000, 4000 (each frame twice, backward); used by the caller 07:775C
MainMenu_SlideB_Tbl3::
    dwb Gfx_11_4500_MainMenu_IconStripB_F5
    dwb Gfx_11_4500_MainMenu_IconStripB_F5
    dwb Gfx_11_4000_MainMenu_IconStripB_F4
    dwb Gfx_11_4000_MainMenu_IconStripB_F4

; C: page transition C, entry: same loop (4 steps, records {lo,hi,bank}); callers load Tbl0 (07:742E) or Tbl1
; (07:7753)
MainMenu_SlideC_Begin::
    push de                                       ; $7C7D
    push hl                                       ; $7C7E
    call Oam_HideUnused                           ; $7C7F
    rst Rst08_WaitVBlank                          ; $7C82
    pop hl                                        ; $7C83
    pop de                                        ; $7C84
    ld bc, $0400                                  ; $7C85

jr_007_7c88:
    ldh a, [hFrameCounter]                        ; $7C88
    ld [wMenuTransStamp], a                       ; $7C8A
    push hl                                       ; $7C8D
    push de                                       ; $7C8E
    push bc                                       ; $7C8F
    ld bc, MainMenu_SlideC_Step                   ; $7C90
    push bc                                       ; $7C93
    jp hl                                         ; $7C94


; C: step of page transition C: record C, Vram_CopyFromBank copies 0x1C0 bytes (14 map rows of 32) to $9860 = the
; background map strip from row 3, then MainMenu_SlideWait
MainMenu_SlideC_Step::
    pop bc                                        ; $7C95
    pop hl                                        ; $7C96
    push hl                                       ; $7C97
    push bc                                       ; $7C98
    ld a, c                                       ; $7C99
    sla a                                         ; $7C9A
    add c                                         ; $7C9C
    ld c, a                                       ; $7C9D
    ld b, $00                                     ; $7C9E
    add hl, bc                                    ; $7CA0
    ld c, [hl]                                    ; $7CA1
    inc hl                                        ; $7CA2
    ld b, [hl]                                    ; $7CA3
    inc hl                                        ; $7CA4
    ld a, [hl]                                    ; $7CA5
    ld l, c                                       ; $7CA6
    ld h, b                                       ; $7CA7
    ld de, $9860                                  ; $7CA8
    ld bc, $01c0                                  ; $7CAB
    call Vram_CopyFromBank                        ; $7CAE
    call MainMenu_SlideWait                       ; $7CB1
    pop bc                                        ; $7CB4
    pop de                                        ; $7CB5
    pop hl                                        ; $7CB6
    inc c                                         ; $7CB7
    dec b                                         ; $7CB8
    jr nz, jr_007_7c88                            ; $7CB9

    jp hl                                         ; $7CBB


; I: 4 x {lo,hi,bank} = 27:54B0, 5830, 5670, 5F30 (map strips of 0x1C0 bytes to $9860); used by the caller 07:742E
MainMenu_SlideC_Tbl0::
    db $00, $79, $20
    db $80, $7c, $20
    db $c0, $7a, $20
    dwb Map_27_6590_MainMenu_LoadBackground

; I: 4 x {lo,hi,bank} = 27:5670, 5830, 54B0, 26:5A60 (map strips of 0x1C0 bytes to $9860, backward); used by the
; caller 07:7753
MainMenu_SlideC_Tbl1::
    db $c0, $7a, $20
    db $80, $7c, $20
    db $00, $79, $20
    dwb Src_26_5820_Tbl7CF9_7

; C: shared wait of the three transitions: waits ($DA2E - $FFC8 + 4) VBlanks, i.e. one step takes 4 frames counted
; from the stamp taken at the start of the step; the caller's draw callback (found on the stack) is called once per
; frame through MainMenu_SlideWaitLoop
MainMenu_SlideWait::
    call Oam_HideUnused                           ; $7CD4
    ld a, [wMenuTransStamp]                       ; $7CD7
    ld hl, hFrameCounter                          ; $7CDA
    sub [hl]                                      ; $7CDD
    add $04                                       ; $7CDE

jr_007_7ce0:
    push af                                       ; $7CE0
    ld hl, sp+$08                                 ; $7CE1
    ld a, [hl+]                                   ; $7CE3
    ld h, [hl]                                    ; $7CE4
    ld l, a                                       ; $7CE5
    ld bc, MainMenu_SlideWaitLoop                 ; $7CE6
    push bc                                       ; $7CE9
    jp hl                                         ; $7CEA


; C: one frame of the wait: hides the unused sprites, waits for VBlank, decrements the count and loops back into
; MainMenu_SlideWait (ret when 0)
MainMenu_SlideWaitLoop::
    call Oam_HideUnused                           ; $7CEB
    rst Rst08_WaitVBlank                          ; $7CEE
    pop af                                        ; $7CEF
    dec a                                         ; $7CF0
    jr nz, jr_007_7ce0                            ; $7CF1

    ret                                           ; $7CF3


    ; padding
    ds $30c, $00

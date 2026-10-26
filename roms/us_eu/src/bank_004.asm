; Game Boy Camera (USA, Europe), bank $04. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

; C: photo grid shared by the modes (substate table at 4004): far call with message strip / icon chosen in $D5D6 /
; $D5D7
PhotoPicker_Far::
    ld a, [wSubstate]                             ; $4000
    rst Rst18_JumpTable                           ; $4003

; C: 3 substates
PhotoPicker_SubstateTbl::
    dw PhotoPicker_Init
    dw PhotoPicker_Choose
    dw PhotoPicker_Finish

; C: loads the grid graphics (banks 13 / 24) and the first page of thumbnails
PhotoPicker_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $400A
    ldh [hLcdcShadow], a                          ; $400C
    ld a, $e4                                     ; $400E
    ld [wPaletteTarget], a                        ; $4010
    ld [wPaletteTarget + $1], a                   ; $4013
    ld a, $d2                                     ; $4016
    ld [wPaletteTarget + $2], a                   ; $4018
    xor a                                         ; $401B
    ldh [hScxShadow], a                           ; $401C
    ldh [hScyShadow], a                           ; $401E
    ldh [hScxBand1], a                            ; $4020
    ldh [hScyBand1], a                            ; $4022
    ld [wScrollWobblePhase], a                    ; $4024
    ld hl, $9000                                  ; $4027
    ld bc, $0800                                  ; $402A
    call Mem_Zero                                 ; $402D
    farcopy Mem_CopyFromBank, Gfx_13_5800_Mode0F_State00_Init, $8000, $1000 ; $4030
    farcopy Mem_CopyFromBank, Map_24_54C0_Mode0F_State00_Init, $9800, $0240 ; $403E
    ld hl, $8ff0                                  ; $404C
    ld a, $ff                                     ; $404F
    ld b, $04                                     ; $4051

jr_004_4053:
    ld [hl+], a                                   ; $4053
    ld [hl+], a                                   ; $4054
    ld [hl+], a                                   ; $4055
    ld [hl+], a                                   ; $4056
    dec b                                         ; $4057
    jr nz, jr_004_4053                            ; $4058

    ld hl, $9be0                                  ; $405A
    ld a, $ff                                     ; $405D
    ld b, $08                                     ; $405F

jr_004_4061:
    ld [hl+], a                                   ; $4061
    ld [hl+], a                                   ; $4062
    ld [hl+], a                                   ; $4063
    ld [hl+], a                                   ; $4064
    dec b                                         ; $4065
    jr nz, jr_004_4061                            ; $4066

    ld a, $0f                                     ; $4068
    ldh [hLycShadowSplit1], a                     ; $406A
    ldh [hSplit1Latch], a                         ; $406C
    ld hl, hStatShadow                            ; $406E
    set 6, [hl]                                   ; $4071
    ld hl, rIE                                    ; $4073
    set 1, [hl]                                   ; $4076
    ld a, $02                                     ; $4078
    ldh [hStatHandlerIndex], a                    ; $407A
    screen_on                                     ; $407C
    play_music MUSIC_PHOTO_PICKER                 ; $4085
    ld a, [wPhotoIndex]                           ; $408C
    cp $1e                                        ; $408F
    jr c, jr_004_409c                             ; $4091

    ld a, [wStockNavAllowed]                      ; $4093
    and a                                         ; $4096
    jr nz, jr_004_409c                            ; $4097

    ld [wPhotoIndex], a                           ; $4099

jr_004_409c:
    ld a, [wPhotoIndex]                           ; $409C
    call PhotoPicker_LoadPageThumbs               ; $409F
    call PhotoPicker_NoPhotoHere                  ; $40A2
    jr c, jr_004_40b4                             ; $40A5

    call PhotoPicker_LoadBigThumb                 ; $40A7
    call PhotoPicker_ClearThumbSlot               ; $40AA
    ld a, $01                                     ; $40AD
    ld [wCursorSpriteVar], a                      ; $40AF
    jr jr_004_40b9                                ; $40B2

jr_004_40b4:
    ld a, $11                                     ; $40B4
    ld [wCursorSpriteVar], a                      ; $40B6

jr_004_40b9:
    call PhotoPicker_LoadPageTabs                 ; $40B9
    call PhotoPicker_LoadMessageStrip             ; $40BC
    call PhotoPicker_LoadIcon                     ; $40BF
    call PhotoPicker_DrawCursor                   ; $40C2
    call Pal_FadeIn                               ; $40C5
    ld hl, wSubstate                              ; $40C8
    inc [hl]                                      ; $40CB
    jp Far_Call_Return                            ; $40CC


; C: A / B ends
PhotoPicker_Choose::
    call PhotoPicker_Wobble                       ; $40CF
    ldh a, [hKeysNew]                             ; $40D2
    and PADF_A | PADF_B                           ; $40D4
    jr z, jr_004_4104                             ; $40D6

    cp $03                                        ; $40D8
    jr nz, jr_004_40de                            ; $40DA

    ld a, $01                                     ; $40DC

jr_004_40de:
    ld [wAbResult], a                             ; $40DE
    push af                                       ; $40E1
    bit 1, a                                      ; $40E2
    ld a, SFX1_KEY_B                              ; $40E4
    call nz, Snd_Sfx1                             ; $40E6
    pop af                                        ; $40E9
    bit 1, a                                      ; $40EA
    jr nz, jr_004_40fa                            ; $40EC

    call PhotoPicker_NoPhotoHere                  ; $40EE
    jr c, jr_004_4104                             ; $40F1

    play_sfx1 SFX1_PICK_PHOTO                     ; $40F3

jr_004_40fa:
    call PhotoPicker_DrawCursor                   ; $40FA
    ld hl, wSubstate                              ; $40FD
    inc [hl]                                      ; $4100
    jp Far_Call_Return                            ; $4101


jr_004_4104:
    call PhotoPicker_DrawCursor                   ; $4104
    call PhotoPicker_MoveCursor                   ; $4107
    jp Far_Call_Return                            ; $410A


; C: B: fade out and next state; A: cursor blink then fade out
PhotoPicker_Finish::
    ld a, [wAbResult]                             ; $410D
    and $01                                       ; $4110
    jr nz, jr_004_412b                            ; $4112

    screen_off                                    ; $4114
    stat_irq_off                                  ; $411A
    next_state                                    ; $4124
    jp Far_Call_Return                            ; $4128


jr_004_412b:
    ld b, $04                                     ; $412B

jr_004_412d:
    ld c, $09                                     ; $412D

jr_004_412f:
    push bc                                       ; $412F
    call PhotoPicker_Wobble                       ; $4130
    call PhotoPicker_DrawCursor                   ; $4133
    call Oam_HideUnused                           ; $4136
    rst Rst08_WaitVBlank                          ; $4139
    pop bc                                        ; $413A
    dec c                                         ; $413B
    jr nz, jr_004_412f                            ; $413C

    ld hl, wCursorSpriteVar                       ; $413E
    inc [hl]                                      ; $4141
    dec b                                         ; $4142
    jr nz, jr_004_412d                            ; $4143

    screen_off                                    ; $4145
    stat_irq_off                                  ; $414B
    next_state                                    ; $4155
    jp Far_Call_Return                            ; $4159


; C: background scroll wobble from the table at 417D. L3 pass 2026-10-26: executed in BGB in 81 replay(s) of the
; organic corpus, modes 0A 0F 11 1A 1C (tcrf_check/assets/l3_names/)
PhotoPicker_Wobble::
    ldh a, [hFrameCounter]                        ; $415C
    bit 1, a                                      ; $415E
    ret z                                         ; $4160

    ld a, [wScrollWobblePhase]                    ; $4161
    ld c, a                                       ; $4164
    sla c                                         ; $4165
    ld b, $00                                     ; $4167
    inc a                                         ; $4169
    cp $10                                        ; $416A
    jr nz, jr_004_416f                            ; $416C

    xor a                                         ; $416E

jr_004_416f:
    ld [wScrollWobblePhase], a                    ; $416F
    ld hl, PhotoPicker_WobbleTbl                  ; $4172
    add hl, bc                                    ; $4175
    ld a, [hl+]                                   ; $4176
    ldh [hScxShadow], a                           ; $4177
    ld a, [hl]                                    ; $4179
    ldh [hScyShadow], a                           ; $417A
    ret                                           ; $417C


; C: 16 {scx. L3 pass 2026-10-26: read in BGB in 81 replay(s) of the organic corpus, modes 0A 0F 11 1A 1C
; (tcrf_check/assets/l3_names/)
PhotoPicker_WobbleTbl::
    db $00, $00, $00, $00, $01, $00, $01, $00, $00, $00, $00, $00, $01, $00, $01, $00
    db $00, $00, $00, $00, $01, $00, $01, $00, $00, $fe, $ff, $ff, $00, $00, $01, $01

; C: cursor sprite on the current photo of the page
PhotoPicker_DrawCursor::
    ld a, [wPhotoIndex]                           ; $419D
    cp $1e                                        ; $41A0
    jr c, jr_004_41a6                             ; $41A2

    inc a                                         ; $41A4
    inc a                                         ; $41A5

jr_004_41a6:
    and $07                                       ; $41A6
    sla a                                         ; $41A8
    ld e, a                                       ; $41AA
    ld d, $00                                     ; $41AB
    ld hl, PhotoPicker_CursorPosTbl               ; $41AD
    add hl, de                                    ; $41B0
    ld b, [hl]                                    ; $41B1
    inc hl                                        ; $41B2
    ld c, [hl]                                    ; $41B3
    ld a, [wCursorSpriteVar]                      ; $41B4
    add $0f                                       ; $41B7
    call Oam_AddMeta_B01_4000                     ; $41B9
    ret                                           ; $41BC


; C: 8 {y. L3 pass 2026-10-26: read in BGB in 81 replay(s) of the organic corpus, modes 0A 0F 10 11 1A 1C
; (tcrf_check/assets/l3_names/)
PhotoPicker_CursorPosTbl::
    db $48, $18, $70, $18, $20, $40, $48, $40, $70, $40, $20, $68, $48, $68, $70, $68

; C: D-pad moves inside the page; leaving the page changes the page with a transition
PhotoPicker_MoveCursor::
    call PhotoPicker_ReadDirection                ; $41CD
    ret z                                         ; $41D0

    dec a                                         ; $41D1
    ld c, a                                       ; $41D2
    ld a, [wPhotoIndex]                           ; $41D3
    and $3f                                       ; $41D6
    sla a                                         ; $41D8
    sla a                                         ; $41DA
    add c                                         ; $41DC
    ld e, a                                       ; $41DD
    ld d, $00                                     ; $41DE
    ld hl, PhotoPicker_NeighborTbl                ; $41E0
    add hl, de                                    ; $41E3
    ld a, [hl]                                    ; $41E4
    cp $ff                                        ; $41E5
    ret z                                         ; $41E7

    ld [wPickerCursorTarget], a                   ; $41E8
    and $3f                                       ; $41EB
    cp $1e                                        ; $41ED
    jr c, jr_004_4202                             ; $41EF

    ld a, [wStockNavAllowed]                      ; $41F1
    and a                                         ; $41F4
    ret z                                         ; $41F5

    ld a, [wPickerCursorTarget]                   ; $41F6
    and $3f                                       ; $41F9
    sub $1e                                       ; $41FB
    ld hl, wStockPictureCount                     ; $41FD
    cp [hl]                                       ; $4200
    ret nc                                        ; $4201

jr_004_4202:
    call Oam_HideUnused                           ; $4202
    rst Rst08_WaitVBlank                          ; $4205
    call PhotoPicker_NoPhotoHere                  ; $4206
    jr c, jr_004_4225                             ; $4209

    xor a                                         ; $420B
    ld [wCursorSpriteVar], a                      ; $420C
    call PhotoPicker_DrawCursor                   ; $420F
    call Oam_HideUnused                           ; $4212
    call PhotoPicker_LoadThumbToVram              ; $4215
    rst Rst08_WaitVBlank                          ; $4218
    ld a, $11                                     ; $4219
    ld [wCursorSpriteVar], a                      ; $421B
    call PhotoPicker_DrawCursor                   ; $421E
    call Oam_HideUnused                           ; $4221
    rst Rst08_WaitVBlank                          ; $4224

jr_004_4225:
    ld hl, wPickerCursorTarget                    ; $4225
    bit 7, [hl]                                   ; $4228
    jr z, jr_004_423e                             ; $422A

    bit 6, [hl]                                   ; $422C
    jr z, jr_004_4238                             ; $422E

    call Oam_ClearShadow                          ; $4230
    call PhotoPicker_PageTransitionNext           ; $4233
    jr jr_004_423e                                ; $4236

jr_004_4238:
    call Oam_ClearShadow                          ; $4238
    call PhotoPicker_PageTransitionPrev           ; $423B

jr_004_423e:
    ld a, [wPickerCursorTarget]                   ; $423E
    and $3f                                       ; $4241
    ld [wPhotoIndex], a                           ; $4243
    call PhotoPicker_NoPhotoHere                  ; $4246
    jr c, jr_004_4275                             ; $4249

    call PhotoPicker_LoadBigThumb                 ; $424B
    rst Rst08_WaitVBlank                          ; $424E
    xor a                                         ; $424F
    ld [wCursorSpriteVar], a                      ; $4250
    call PhotoPicker_DrawCursor                   ; $4253
    call Oam_HideUnused                           ; $4256
    ld bc, $0004                                  ; $4259
    call Wait_Frames                              ; $425C
    call PhotoPicker_ClearThumbSlot               ; $425F
    ld a, $01                                     ; $4262
    ld [wCursorSpriteVar], a                      ; $4264
    call PhotoPicker_DrawCursor                   ; $4267
    call Oam_HideUnused                           ; $426A
    rst Rst08_WaitVBlank                          ; $426D
    call PhotoPicker_DrawCursor                   ; $426E
    call PhotoPicker_LoadPageTabs                 ; $4271
    ret                                           ; $4274


jr_004_4275:
    ld a, $11                                     ; $4275
    ld [wCursorSpriteVar], a                      ; $4277
    call PhotoPicker_DrawCursor                   ; $427A
    call PhotoPicker_LoadPageTabs                 ; $427D
    ret                                           ; $4280


; C: 4 neighbours (left
PhotoPicker_NeighborTbl::
    db $ff, $01, $ff, $03, $00, $c8, $ff, $04, $ff, $03, $00, $05, $02, $04, $00, $06
    db $03, $ca, $01, $07, $ff, $06, $02, $ff, $05, $07, $03, $ff, $06, $cd, $04, $ff
    db $81, $09, $ff, $0b, $08, $d0, $ff, $0c, $84, $0b, $08, $0d, $0a, $0c, $08, $0e
    db $0b, $d2, $09, $0f, $87, $0e, $0a, $ff, $0d, $0f, $0b, $ff, $0e, $d5, $0c, $ff
    db $89, $11, $ff, $13, $10, $d8, $ff, $14, $8c, $13, $10, $15, $12, $14, $10, $16
    db $13, $da, $11, $17, $8f, $16, $12, $ff, $15, $17, $13, $ff, $16, $dd, $14, $ff
    db $91, $19, $ff, $1b, $18, $de, $ff, $1c, $94, $1b, $18, $1d, $1a, $1c, $18, $1d
    db $1b, $e0, $19, $1d, $97, $e3, $1a, $ff, $99, $1f, $ff, $21, $1e, $e6, $ff, $22
    db $9c, $21, $1e, $23, $20, $22, $1e, $24, $21, $e8, $1f, $25, $9d, $24, $20, $ff
    db $23, $25, $21, $ff, $24, $eb, $22, $ff, $9f, $27, $ff, $29, $26, $ee, $ff, $2a
    db $a2, $29, $26, $2b, $28, $2a, $26, $2c, $29, $f0, $27, $2d, $a5, $2c, $28, $ff
    db $2b, $2d, $29, $ff, $2c, $f3, $2a, $ff, $a7, $2f, $ff, $31, $2e, $f6, $ff, $32
    db $aa, $31, $2e, $33, $30, $32, $2e, $34, $31, $f8, $2f, $35, $ad, $34, $30, $ff
    db $33, $35, $31, $ff, $34, $fb, $32, $ff, $af, $37, $ff, $39, $36, $ff, $ff, $3a
    db $b2, $39, $36, $3b, $38, $3a, $36, $3b, $39, $ff, $37, $3b, $b5, $ff, $38, $ff

; C: A = 1 left
PhotoPicker_ReadDirection::
    ldh a, [hKeysNewRepeat]                       ; $4371
    bit PADB_LEFT, a                              ; $4373
    jr z, jr_004_4382                             ; $4375

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4377
    ld a, $01                                     ; $437E
    jr jr_004_43ac                                ; $4380

jr_004_4382:
    bit 4, a                                      ; $4382
    jr z, jr_004_4391                             ; $4384

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4386
    ld a, $02                                     ; $438D
    jr jr_004_43ac                                ; $438F

jr_004_4391:
    bit 6, a                                      ; $4391
    jr z, jr_004_43a0                             ; $4393

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $4395
    ld a, $03                                     ; $439C
    jr jr_004_43ac                                ; $439E

jr_004_43a0:
    bit 7, a                                      ; $43A0
    ret z                                         ; $43A2

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $43A3
    ld a, $04                                     ; $43AA

jr_004_43ac:
    and a                                         ; $43AC
    ret                                           ; $43AD


; C: loads the thumbnail of the current photo into its tile slot
PhotoPicker_LoadThumbToVram::
    ld a, [wPhotoIndex]                           ; $43AE
    ldh [hFarcallAArg], a                         ; $43B1
    farcall Photo_GetSramAddress_Far              ; $43B3
    push af                                       ; $43BB
    ld hl, $0e00                                  ; $43BC
    add hl, bc                                    ; $43BF
    ld a, [wPhotoIndex]                           ; $43C0
    cp $1e                                        ; $43C3
    jr c, jr_004_43c9                             ; $43C5

    inc a                                         ; $43C7
    inc a                                         ; $43C8

jr_004_43c9:
    and $07                                       ; $43C9
    add $90                                       ; $43CB
    ld d, a                                       ; $43CD
    ld e, $00                                     ; $43CE
    ld bc, $0100                                  ; $43D0
    pop af                                        ; $43D3
    call Vram_CopyFromBank                        ; $43D4
    ret                                           ; $43D7


; C: loads the 16-tile thumbnail to $8700. L3 pass 2026-10-26: executed in BGB in 76 replay(s) of the organic corpus,
; modes 0A 0F 10 11 1A (tcrf_check/assets/l3_names/)
PhotoPicker_LoadBigThumb::
    ld a, [wPhotoIndex]                           ; $43D8
    ldh [hFarcallAArg], a                         ; $43DB
    farcall Photo_GetSramAddress_Far              ; $43DD
    ld hl, $0e00                                  ; $43E5
    add hl, bc                                    ; $43E8
    ld de, $8700                                  ; $43E9
    ld bc, $0100                                  ; $43EC
    call Vram_CopyFromBank                        ; $43EF
    ret                                           ; $43F2


; C: clears the tile slot of the current photo. L3 pass 2026-10-26: executed in BGB in 76 replay(s) of the organic
; corpus, modes 0A 0F 10 11 1A (tcrf_check/assets/l3_names/)
PhotoPicker_ClearThumbSlot::
    ld a, [wPhotoIndex]                           ; $43F3
    cp $1e                                        ; $43F6
    jr c, jr_004_43fc                             ; $43F8

    inc a                                         ; $43FA
    inc a                                         ; $43FB

jr_004_43fc:
    and $07                                       ; $43FC
    add $90                                       ; $43FE
    ld h, a                                       ; $4400
    ld l, $00                                     ; $4401
    xor a                                         ; $4403
    ld bc, $0100                                  ; $4404
    call Vram_ClearSafe                           ; $4407
    ret                                           ; $440A


; C: loads the eight thumbnails of a page (own photos
PhotoPicker_LoadPageThumbs::
    ld hl, wPageIsStock                           ; $440B
    ld de, $9000                                  ; $440E
    and $3f                                       ; $4411
    cp $1e                                        ; $4413
    jr c, jr_004_4421                             ; $4415

    sub $1e                                       ; $4417
    and $18                                       ; $4419
    add $1e                                       ; $441B
    ld [hl], $01                                  ; $441D
    jr jr_004_4425                                ; $441F

jr_004_4421:
    and $18                                       ; $4421
    ld [hl], $00                                  ; $4423

jr_004_4425:
    ld c, a                                       ; $4425
    ld b, $08                                     ; $4426

jr_004_4428:
    push bc                                       ; $4428
    push de                                       ; $4429
    ld a, c                                       ; $442A
    ld hl, wPhotoCount                            ; $442B
    cp [hl]                                       ; $442E
    jr c, jr_004_4458                             ; $442F

    cp $1e                                        ; $4431
    jr c, jr_004_444b                             ; $4433

    ld hl, wPageIsStock                           ; $4435
    bit 0, [hl]                                   ; $4438
    jr z, jr_004_4440                             ; $443A

    cp $3c                                        ; $443C
    jr c, jr_004_4458                             ; $443E

jr_004_4440:
    ld l, e                                       ; $4440
    ld h, d                                       ; $4441
    xor a                                         ; $4442
    ld bc, $0100                                  ; $4443
    call Vram_ClearSafe                           ; $4446
    jr jr_004_446c                                ; $4449

jr_004_444b:
    ld a, BANK(Src_13_6400_PhotoPicker_LoadPageThumbs); $444B
    ld hl, Src_13_6400_PhotoPicker_LoadPageThumbs ; $444D
    ld bc, $0100                                  ; $4450
    call Vram_CopyFromBank                        ; $4453
    jr jr_004_446c                                ; $4456

jr_004_4458:
    ldh [hFarcallAArg], a                         ; $4458
    farcall Photo_GetSramAddress_Far              ; $445A
    ld hl, $0e00                                  ; $4462
    add hl, bc                                    ; $4465
    ld bc, $0100                                  ; $4466
    call Vram_CopyFromBank                        ; $4469

jr_004_446c:
    pop de                                        ; $446C
    pop bc                                        ; $446D
    inc d                                         ; $446E
    inc c                                         ; $446F
    dec b                                         ; $4470
    jr nz, jr_004_4428                            ; $4471

    ret                                           ; $4473


; C: message strip tiles chosen by msg_strip_sel
PhotoPicker_LoadMessageStrip::
    ld a, [wMsgStripSel]                          ; $4474
    ld e, a                                       ; $4477
    sla a                                         ; $4478
    add e                                         ; $447A
    ld e, a                                       ; $447B
    ld d, $00                                     ; $447C
    ld hl, PhotoPicker_MessageStripTbl            ; $447E
    add hl, de                                    ; $4481
    ld e, [hl]                                    ; $4482
    inc hl                                        ; $4483
    ld d, [hl]                                    ; $4484
    inc hl                                        ; $4485
    ld a, [hl]                                    ; $4486
    ld h, d                                       ; $4487
    ld l, e                                       ; $4488
    ld de, $8800                                  ; $4489
    ld bc, $0280                                  ; $448C
    call Vram_CopyFromBank                        ; $448F
    ret                                           ; $4492


; C: {addr
PhotoPicker_MessageStripTbl::
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

; C: icon tiles chosen by icon_sel
PhotoPicker_LoadIcon::
    ld a, [wIconSel]                              ; $44BD
    ld e, a                                       ; $44C0
    sla a                                         ; $44C1
    add e                                         ; $44C3
    ld e, a                                       ; $44C4
    ld d, $00                                     ; $44C5
    ld hl, PhotoPicker_IconTbl                    ; $44C7
    add hl, de                                    ; $44CA
    ld e, [hl]                                    ; $44CB
    inc hl                                        ; $44CC
    ld d, [hl]                                    ; $44CD
    inc hl                                        ; $44CE
    ld a, [hl]                                    ; $44CF
    ld h, d                                       ; $44D0
    ld l, e                                       ; $44D1
    ld de, $8b00                                  ; $44D2
    ld bc, $0100                                  ; $44D5
    call Vram_CopyFromBank                        ; $44D8
    ret                                           ; $44DB


; C: {addr
PhotoPicker_IconTbl::
    dwb Gfx_13_6800_Icon04_44DC
    dwb Gfx_13_6900_Icon04_44DC
    dwb Gfx_13_6A00_Icon04_44DC
    dwb Gfx_13_6B00_Icon04_44DC
    dwb Gfx_13_6C00_Icon04_44DC
    dwb Gfx_13_6D00_Icon04_44DC
    dwb Gfx_13_6E00_Icon04_44DC

; C: page tab tiles of the current photo. L3 pass 2026-10-26: executed in BGB in 81 replay(s) of the organic corpus,
; modes 0A 0F 10 11 1A 1C (tcrf_check/assets/l3_names/)
PhotoPicker_LoadPageTabs::
    ld a, [wPhotoIndex]                           ; $44F1

; C: same for the photo in A. L3 pass 2026-10-26: executed in BGB in 81 replay(s) of the organic corpus, modes 0A 0F
; 10 11 1A 1C (tcrf_check/assets/l3_names/)
PhotoPicker_LoadPageTabsFor::
    cp $1e                                        ; $44F4
    jr c, jr_004_44fa                             ; $44F6

    inc a                                         ; $44F8
    inc a                                         ; $44F9

jr_004_44fa:
    push af                                       ; $44FA
    and $18                                       ; $44FB
    sla a                                         ; $44FD
    ld c, a                                       ; $44FF
    ld b, $00                                     ; $4500
    ld hl, Gfx_13_5830_PhotoPicker_LoadPageTabsFor ; $4502
    add hl, bc                                    ; $4505
    ld a, BANK(Gfx_13_5830_PhotoPicker_LoadPageTabsFor) ; $4506
    ld de, $8df0                                  ; $4508
    ld bc, $0010                                  ; $450B
    call Vram_CopyFromBank                        ; $450E
    pop af                                        ; $4511
    and $20                                       ; $4512
    srl a                                         ; $4514
    ld c, a                                       ; $4516
    ld b, $00                                     ; $4517
    ld hl, Gfx_13_5800_Mode0F_State00_Init        ; $4519
    add hl, bc                                    ; $451C
    ld a, BANK(Gfx_13_5800_Mode0F_State00_Init)   ; $451D
    ld de, $8de0                                  ; $451F
    ld bc, $0010                                  ; $4522
    call Vram_CopyFromBank                        ; $4525
    ret                                           ; $4528


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 0F (tcrf_check/assets/l3_names/)
PhotoPicker_LoadPageTabs2::
    ld a, [wPhotoIndex]                           ; $4529

; C: L3 pass 2026-10-26: executed in BGB in 29 replay(s) of the organic corpus, modes 0F 11
; (tcrf_check/assets/l3_names/)
PhotoPicker_LoadPageTabs2For::
    cp $1e                                        ; $452C
    jr c, jr_004_4532                             ; $452E

    inc a                                         ; $4530
    inc a                                         ; $4531

jr_004_4532:
    push af                                       ; $4532
    and $18                                       ; $4533
    sla a                                         ; $4535
    ld c, a                                       ; $4537
    ld b, $00                                     ; $4538
    ld hl, Gfx_13_5830_PhotoPicker_LoadPageTabsFor ; $453A
    add hl, bc                                    ; $453D
    ld a, BANK(Gfx_13_5830_PhotoPicker_LoadPageTabsFor) ; $453E
    ld de, $8ed0                                  ; $4540
    ld bc, $0010                                  ; $4543
    call Vram_CopyFromBank                        ; $4546
    pop af                                        ; $4549
    and $20                                       ; $454A
    srl a                                         ; $454C
    ld c, a                                       ; $454E
    ld b, $00                                     ; $454F
    ld hl, Gfx_13_5800_Mode0F_State00_Init        ; $4551
    add hl, bc                                    ; $4554
    ld a, BANK(Gfx_13_5800_Mode0F_State00_Init)   ; $4555
    ld de, $8ec0                                  ; $4557
    ld bc, $0010                                  ; $455A
    call Vram_CopyFromBank                        ; $455D
    ret                                           ; $4560


; C: tile-map transition to the next page. L3 pass 2026-10-26: executed in BGB in 29 replay(s) of the organic corpus,
; modes 11 (tcrf_check/assets/l3_names/)
PhotoPicker_PageTransitionNext::
    ld a, [wPickerCursorTarget]                   ; $4561
    call PhotoPicker_LoadPageTabs2For             ; $4564
    farcopy Vram_CopyFromBank, Map_27_5C10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4567
    rst Rst08_WaitVBlank                          ; $4575
    ld a, [wPickerCursorTarget]                   ; $4576
    call PhotoPicker_LoadPageThumbs               ; $4579
    rst Rst08_WaitVBlank                          ; $457C
    farcopy Vram_CopyFromBank, Map_27_5A10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $457D
    rst Rst08_WaitVBlank                          ; $458B
    farcopy Vram_CopyFromBank, Map_27_6010_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $458C
    rst Rst08_WaitVBlank                          ; $459A
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $459B
    rst Rst08_WaitVBlank                          ; $45A9
    farcopy Vram_CopyFromBank, Map_27_5E10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45AA
    rst Rst08_WaitVBlank                          ; $45B8
    ld a, [wPickerCursorTarget]                   ; $45B9
    call PhotoPicker_LoadPageTabsFor              ; $45BC
    farcopy Vram_CopyFromBank, Map_24_5500_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45BF
    rst Rst08_WaitVBlank                          ; $45CD
    ret                                           ; $45CE


; C: tile-map transition to the previous page. L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic
; corpus, modes 0F (tcrf_check/assets/l3_names/)
PhotoPicker_PageTransitionPrev::
    ld a, [wPickerCursorTarget]                   ; $45CF
    call PhotoPicker_LoadPageTabs2                ; $45D2
    farcopy Vram_CopyFromBank, Map_27_5E10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45D5
    rst Rst08_WaitVBlank                          ; $45E3
    ld a, [wPickerCursorTarget]                   ; $45E4
    call PhotoPicker_LoadPageTabsFor              ; $45E7
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45EA
    rst Rst08_WaitVBlank                          ; $45F8
    farcopy Vram_CopyFromBank, Map_27_6010_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45F9
    rst Rst08_WaitVBlank                          ; $4607
    farcopy Vram_CopyFromBank, Map_27_5A10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4608
    rst Rst08_WaitVBlank                          ; $4616
    farcopy Vram_CopyFromBank, Map_27_5C10_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4617
    rst Rst08_WaitVBlank                          ; $4625
    ld a, [wPickerCursorTarget]                   ; $4626
    call PhotoPicker_LoadPageThumbs               ; $4629
    rst Rst08_WaitVBlank                          ; $462C
    farcopy Vram_CopyFromBank, Map_24_5500_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $462D
    rst Rst08_WaitVBlank                          ; $463B
    ret                                           ; $463C


; C: carry when the cursor is on an empty slot
PhotoPicker_NoPhotoHere::
    ld a, [wPhotoIndex]                           ; $463D
    cp $1e                                        ; $4640
    ret nc                                        ; $4642

    ld hl, wPhotoCount                            ; $4643
    cp [hl]                                       ; $4646
    ccf                                           ; $4647
    ret                                           ; $4648


; C: mode 0F: delete which photo? (also used for the Copy item of the Album editor: states 0C / 0E)
Mode0F_DeletePhoto::
    ld a, [wState]                                ; $4649
    rst Rst18_JumpTable                           ; $464C

; C: 15 states, rst $18 table of mode $0F
Mode0F_StateTable::
    dw Mode0F_State00_Init
    dw Mode0F_State01_ReInit
    dw Mode0F_State02_Browse
    dw Mode0F_State03_Selected
    dw Mode0F_State04_LeaveSelected
    dw Mode0F_State05_ConfirmInit
    dw Mode0F_State06_ConfirmChoose
    dw Mode0F_State07_ConfirmApply
    dw Mode0F_State01_ReInit
    dw Mode0F_State09_EraseOne
    dw Mode0F_State0A_EraseAll
    dw Mode0F_State01_ReInit
    dw Mode0F_State0C_CopyBrowse
    dw Mode0F_State03_Selected
    dw Mode0F_State0E_CopyDo

; C: first entry: sets strip / icon and the photo grid
Mode0F_State00_Init::
    ld a, $02                                     ; $466B
    ld [wMsgStripSel], a                          ; $466D
    xor a                                         ; $4670
    ld [wIconSel], a                              ; $4671
    ld [wCallerCode], a                           ; $4674
    ld [wStockNavAllowed], a                      ; $4677
    ld a, [wPhotoIndex]                           ; $467A
    cp $1e                                        ; $467D
    jr c, jr_004_4685                             ; $467F

    xor a                                         ; $4681
    ld [wPhotoIndex], a                           ; $4682

jr_004_4685:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4685
    ldh [hLcdcShadow], a                          ; $4687
    ld a, $e4                                     ; $4689
    ld [wPaletteTarget], a                        ; $468B
    ld [wPaletteTarget + $1], a                   ; $468E
    ld a, $d2                                     ; $4691
    ld [wPaletteTarget + $2], a                   ; $4693
    xor a                                         ; $4696
    ldh [hScxShadow], a                           ; $4697
    ldh [hScyShadow], a                           ; $4699
    ldh [hScxBand1], a                            ; $469B
    ldh [hScyBand1], a                            ; $469D
    ld [wScrollWobblePhase], a                    ; $469F
    ld [wCopiesOfPhoto], a                        ; $46A2
    ld [wCopiedMarkerTimer], a                    ; $46A5
    ld a, [wPhotoIndex]                           ; $46A8
    ld [wLastPhotoSeen], a                        ; $46AB
    ld hl, $9000                                  ; $46AE
    ld bc, $0800                                  ; $46B1
    call Mem_Zero                                 ; $46B4
    farcopy Mem_CopyFromBank, Gfx_13_5800_Mode0F_State00_Init, $8000, $1000 ; $46B7
    farcopy Mem_CopyFromBank, Map_24_54C0_Mode0F_State00_Init, $9800, $0240 ; $46C5
    ld hl, $8ff0                                  ; $46D3
    ld a, $ff                                     ; $46D6
    ld b, $04                                     ; $46D8

jr_004_46da:
    ld [hl+], a                                   ; $46DA
    ld [hl+], a                                   ; $46DB
    ld [hl+], a                                   ; $46DC
    ld [hl+], a                                   ; $46DD
    dec b                                         ; $46DE
    jr nz, jr_004_46da                            ; $46DF

    ld hl, $9be0                                  ; $46E1
    ld a, $ff                                     ; $46E4
    ld b, $08                                     ; $46E6

jr_004_46e8:
    ld [hl+], a                                   ; $46E8
    ld [hl+], a                                   ; $46E9
    ld [hl+], a                                   ; $46EA
    ld [hl+], a                                   ; $46EB
    dec b                                         ; $46EC
    jr nz, jr_004_46e8                            ; $46ED

    ld a, $0f                                     ; $46EF
    ldh [hLycShadowSplit1], a                     ; $46F1
    ldh [hSplit1Latch], a                         ; $46F3
    ld hl, hStatShadow                            ; $46F5
    set 6, [hl]                                   ; $46F8
    ld hl, rIE                                    ; $46FA
    set 1, [hl]                                   ; $46FD
    ld a, $02                                     ; $46FF
    ldh [hStatHandlerIndex], a                    ; $4701
    screen_on                                     ; $4703
    play_music MUSIC_PHOTO_PICKER                 ; $470C
    ld a, [wPhotoIndex]                           ; $4713
    call PhotoPicker_LoadPageThumbs               ; $4716
    ld a, $0f                                     ; $4719
    ld [wCursorSpriteVar], a                      ; $471B
    call PhotoPicker_LoadPageTabs                 ; $471E
    call PhotoPicker_LoadMessageStrip             ; $4721
    call PhotoPicker_LoadIcon                     ; $4724
    call Pal_FadeIn                               ; $4727
    set_state STATE_0F_SELECTED                   ; $472A
    ret                                           ; $472F


; C: redraws the grid after a fade (states 01 / 08 / 0B)
Mode0F_State01_ReInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4730
    ldh [hLcdcShadow], a                          ; $4732
    ld a, $e4                                     ; $4734
    ld [wPaletteTarget], a                        ; $4736
    ld [wPaletteTarget + $1], a                   ; $4739
    ld a, $d2                                     ; $473C
    ld [wPaletteTarget + $2], a                   ; $473E
    xor a                                         ; $4741
    ldh [hScxShadow], a                           ; $4742
    ldh [hScyShadow], a                           ; $4744
    ldh [hScxBand1], a                            ; $4746
    ldh [hScyBand1], a                            ; $4748
    ld [wScrollWobblePhase], a                    ; $474A
    ld [wCopiesOfPhoto], a                        ; $474D
    ld [wCopiedMarkerTimer], a                    ; $4750
    ld a, [wPhotoIndex]                           ; $4753
    ld [wLastPhotoSeen], a                        ; $4756
    ld hl, $9000                                  ; $4759
    ld bc, $0800                                  ; $475C
    call Mem_Zero                                 ; $475F
    farcopy Mem_CopyFromBank, Gfx_13_5800_Mode0F_State00_Init, $8000, $1000 ; $4762
    farcopy Mem_CopyFromBank, Map_24_54C0_Mode0F_State00_Init, $9800, $0240 ; $4770
    ld hl, $8ff0                                  ; $477E
    ld a, $ff                                     ; $4781
    ld b, $04                                     ; $4783

jr_004_4785:
    ld [hl+], a                                   ; $4785
    ld [hl+], a                                   ; $4786
    ld [hl+], a                                   ; $4787
    ld [hl+], a                                   ; $4788
    dec b                                         ; $4789
    jr nz, jr_004_4785                            ; $478A

    ld hl, $9be0                                  ; $478C
    ld a, $ff                                     ; $478F
    ld b, $08                                     ; $4791

jr_004_4793:
    ld [hl+], a                                   ; $4793
    ld [hl+], a                                   ; $4794
    ld [hl+], a                                   ; $4795
    ld [hl+], a                                   ; $4796
    dec b                                         ; $4797
    jr nz, jr_004_4793                            ; $4798

    ld a, $0f                                     ; $479A
    ldh [hLycShadowSplit1], a                     ; $479C
    ldh [hSplit1Latch], a                         ; $479E
    ld hl, hStatShadow                            ; $47A0
    set 6, [hl]                                   ; $47A3
    ld hl, rIE                                    ; $47A5
    set 1, [hl]                                   ; $47A8
    ld a, $02                                     ; $47AA
    ldh [hStatHandlerIndex], a                    ; $47AC
    screen_on                                     ; $47AE
    play_music MUSIC_PHOTO_PICKER                 ; $47B7
    ld a, [wPhotoIndex]                           ; $47BE
    call PhotoPicker_LoadPageThumbs               ; $47C1
    call PhotoPicker_NoPhotoHere                  ; $47C4
    jr c, jr_004_47d6                             ; $47C7

    call PhotoPicker_LoadBigThumb                 ; $47C9
    call PhotoPicker_ClearThumbSlot               ; $47CC
    ld a, $01                                     ; $47CF
    ld [wCursorSpriteVar], a                      ; $47D1
    jr jr_004_47db                                ; $47D4

jr_004_47d6:
    ld a, $11                                     ; $47D6
    ld [wCursorSpriteVar], a                      ; $47D8

jr_004_47db:
    call PhotoPicker_LoadPageTabs                 ; $47DB
    call PhotoPicker_LoadMessageStrip             ; $47DE
    call PhotoPicker_LoadIcon                     ; $47E1
    call Pal_FadeIn                               ; $47E4
    next_state                                    ; $47E7
    ret                                           ; $47EB


; C: cursor moves over the grid; A picks the photo
Mode0F_State02_Browse::
    call PhotoPicker_Wobble                       ; $47EC
    call PhotoPicker_DrawCursor                   ; $47EF
    ld a, [wMsgStripSel]                          ; $47F2
    cp $0b                                        ; $47F5
    jr nz, jr_004_480b                            ; $47F7

    ldh a, [hKeysNew]                             ; $47F9
    and PADF_DPAD                                 ; $47FB
    jr z, jr_004_480b                             ; $47FD

    push af                                       ; $47FF
    ld a, $02                                     ; $4800
    ld [wMsgStripSel], a                          ; $4802
    call PhotoPicker_LoadMessageStrip             ; $4805
    pop af                                        ; $4808
    ldh [hKeysNewRepeat], a                       ; $4809

jr_004_480b:
    ldh a, [hKeysNew]                             ; $480B
    ld [wAbResult], a                             ; $480D
    bit PADB_A, a                                 ; $4810
    jr z, jr_004_4846                             ; $4812

    ld a, [wPhotoIndex]                           ; $4814
    cp $1e                                        ; $4817
    jr c, jr_004_482b                             ; $4819

    play_sfx1 SFX1_BEEP_REFUSED                   ; $481B
    ld a, $0b                                     ; $4822
    ld [wMsgStripSel], a                          ; $4824
    call PhotoPicker_LoadMessageStrip             ; $4827
    ret                                           ; $482A


jr_004_482b:
    ld hl, wPhotoCount                            ; $482B
    cp [hl]                                       ; $482E
    jr c, jr_004_4839                             ; $482F

    play_sfx1 SFX1_BEEP_REFUSED                   ; $4831
    ret                                           ; $4838


jr_004_4839:
    play_sfx1 SFX1_PICK_PHOTO                     ; $4839
    set_state STATE_0F_LEAVE_SELECTED             ; $4840
    ret                                           ; $4845


jr_004_4846:
    ldh a, [hKeysNew]                             ; $4846
    bit PADB_B, a                                 ; $4848
    jr z, jr_004_4859                             ; $484A

    play_sfx1 SFX1_KEY_B                          ; $484C
    set_state STATE_0F_LEAVE_SELECTED             ; $4853
    ret                                           ; $4858


jr_004_4859:
    ldh a, [hKeysHeld]                            ; $4859
    cp PADF_SELECT | PADF_START | PADF_UP         ; $485B
    jr nz, jr_004_4877                            ; $485D

    ldh a, [hKeysNew]                             ; $485F
    and PADF_SELECT | PADF_START | PADF_UP        ; $4861
    jr z, jr_004_4877                             ; $4863

    ld a, [wPhotoCount]                           ; $4865
    and a                                         ; $4868
    ret z                                         ; $4869

    play_sfx1 SFX1_KEY_A                          ; $486A
    set_state STATE_0F_ERASE_ALL                  ; $4871
    ret                                           ; $4876


jr_004_4877:
    ld a, [wPhotoIndex]                           ; $4877
    cp $1e                                        ; $487A
    jr c, jr_004_4880                             ; $487C

    inc a                                         ; $487E
    inc a                                         ; $487F

jr_004_4880:
    and $07                                       ; $4880
    jr nz, jr_004_488c                            ; $4882

    ldh a, [hKeysNewRepeat]                       ; $4884
    bit PADB_LEFT, a                              ; $4886
    jr z, jr_004_48ad                             ; $4888

    jr jr_004_4896                                ; $488A

jr_004_488c:
    cp $02                                        ; $488C
    jr nz, jr_004_48ad                            ; $488E

    ldh a, [hKeysNewRepeat]                       ; $4890
    bit PADB_UP, a                                ; $4892
    jr z, jr_004_48ad                             ; $4894

jr_004_4896:
    ld a, $0f                                     ; $4896
    ld [wCursorSpriteVar], a                      ; $4898
    call Oam_HideUnused                           ; $489B
    rst Rst08_WaitVBlank                          ; $489E
    call Oam_ClearShadow                          ; $489F
    call PhotoPicker_NoPhotoHere                  ; $48A2
    call nc, PhotoPicker_LoadThumbToVram          ; $48A5
    next_state                                    ; $48A8
    ret                                           ; $48AC


jr_004_48ad:
    call PhotoPicker_MoveCursor                   ; $48AD
    ret                                           ; $48B0


; C: photo picked: arrows go to the neighbour page; A asks DELETE??; B back (states 03 / 0D)
Mode0F_State03_Selected::
    call PhotoPicker_Wobble                       ; $48B1
    call Mode0F_DrawBigCursor                     ; $48B4
    ldh a, [hKeysNewRepeat]                       ; $48B7
    bit PADB_LEFT, a                              ; $48B9
    jr z, jr_004_48c3                             ; $48BB

    call Mode0F_TargetLeft                        ; $48BD
    ret c                                         ; $48C0

    jr jr_004_4930                                ; $48C1

jr_004_48c3:
    bit 4, a                                      ; $48C3
    jr z, jr_004_48cd                             ; $48C5

    call Mode0F_TargetRight                       ; $48C7
    ret c                                         ; $48CA

    jr jr_004_4930                                ; $48CB

jr_004_48cd:
    bit 7, a                                      ; $48CD
    jr z, jr_004_48d7                             ; $48CF

    call Mode0F_TargetDown                        ; $48D1
    ret c                                         ; $48D4

    jr jr_004_4930                                ; $48D5

jr_004_48d7:
    ldh a, [hKeysNew]                             ; $48D7
    bit PADB_A, a                                 ; $48D9
    jr z, jr_004_48e8                             ; $48DB

    play_sfx1 SFX1_MENU_CHOOSE                    ; $48DD
    call Mode0F_PressA                            ; $48E4
    ret                                           ; $48E7


jr_004_48e8:
    bit 1, a                                      ; $48E8
    jr z, jr_004_490e                             ; $48EA

    play_sfx1 SFX1_KEY_B                          ; $48EC
    screen_off                                    ; $48F3
    stat_irq_off                                  ; $48F9
    ld a, MODE_EDIT_MENU                          ; $4903
    ld [wMode], a                                 ; $4905
    set_state STATE_05_INIT                       ; $4908
    ret                                           ; $490D


jr_004_490e:
    ld a, [wState]                                ; $490E
    cp $03                                        ; $4911
    ret nz                                        ; $4913

    ldh a, [hKeysHeld]                            ; $4914
    cp PADF_SELECT | PADF_START | PADF_UP         ; $4916
    ret nz                                        ; $4918

    ldh a, [hKeysNew]                             ; $4919
    and PADF_SELECT | PADF_START | PADF_UP        ; $491B
    ret z                                         ; $491D

    ld a, [wPhotoCount]                           ; $491E
    and a                                         ; $4921
    ret z                                         ; $4922

    play_sfx1 SFX1_KEY_A                          ; $4923
    set_state STATE_0F_ERASE_ALL                  ; $492A
    ret                                           ; $492F


jr_004_4930:
    call Oam_ClearShadow                          ; $4930
    rst Rst08_WaitVBlank                          ; $4933
    ld hl, wPickerCursorTarget                    ; $4934
    bit 7, [hl]                                   ; $4937
    jr z, jr_004_493e                             ; $4939

    call PhotoPicker_PageTransitionPrev           ; $493B

jr_004_493e:
    ld a, [wPickerCursorTarget]                   ; $493E
    and $3f                                       ; $4941
    ld [wPhotoIndex], a                           ; $4943
    call PhotoPicker_NoPhotoHere                  ; $4946
    jr nc, jr_004_4952                            ; $4949

    ld a, $11                                     ; $494B
    ld [wCursorSpriteVar], a                      ; $494D
    jr jr_004_496a                                ; $4950

jr_004_4952:
    call PhotoPicker_LoadBigThumb                 ; $4952
    rst Rst08_WaitVBlank                          ; $4955
    xor a                                         ; $4956
    ld [wCursorSpriteVar], a                      ; $4957
    call PhotoPicker_DrawCursor                   ; $495A
    call Oam_HideUnused                           ; $495D
    rst Rst08_WaitVBlank                          ; $4960
    call PhotoPicker_ClearThumbSlot               ; $4961
    rst Rst08_WaitVBlank                          ; $4964
    ld a, $01                                     ; $4965
    ld [wCursorSpriteVar], a                      ; $4967

jr_004_496a:
    call PhotoPicker_DrawCursor                   ; $496A
    ld hl, wState                                 ; $496D
    dec [hl]                                      ; $4970
    ret                                           ; $4971


; C: Left key: page start - 8 | 1 with bit 7 set; carry when already on the first page
Mode0F_TargetLeft::
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4972
    ld a, [wPhotoIndex]                           ; $4979
    cp $1e                                        ; $497C
    jr c, jr_004_4982                             ; $497E

    inc a                                         ; $4980
    inc a                                         ; $4981

jr_004_4982:
    and $f8                                       ; $4982
    jr z, jr_004_4997                             ; $4984

    sub $08                                       ; $4986
    or $01                                        ; $4988
    cp $20                                        ; $498A
    jr c, jr_004_4990                             ; $498C

    dec a                                         ; $498E
    dec a                                         ; $498F

jr_004_4990:
    set 7, a                                      ; $4990
    ld [wPickerCursorTarget], a                   ; $4992
    xor a                                         ; $4995
    ret                                           ; $4996


jr_004_4997:
    scf                                           ; $4997
    ret                                           ; $4998


; C: Right key: target = first photo of the page
Mode0F_TargetRight::
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $4999
    ld a, [wPhotoIndex]                           ; $49A0
    cp $1e                                        ; $49A3
    jr c, jr_004_49a9                             ; $49A5

    inc a                                         ; $49A7
    inc a                                         ; $49A8

jr_004_49a9:
    and $f8                                       ; $49A9
    cp $20                                        ; $49AB
    jr c, jr_004_49b1                             ; $49AD

    dec a                                         ; $49AF
    dec a                                         ; $49B0

jr_004_49b1:
    ld [wPickerCursorTarget], a                   ; $49B1
    xor a                                         ; $49B4
    ret                                           ; $49B5


; C: Down key: target = first photo of the page | 2
Mode0F_TargetDown::
    play_sfx1 SFX1_KEY_UP_DOWN                    ; $49B6
    ld a, [wPhotoIndex]                           ; $49BD
    cp $1e                                        ; $49C0
    jr c, jr_004_49c6                             ; $49C2

    inc a                                         ; $49C4
    inc a                                         ; $49C5

jr_004_49c6:
    and $f8                                       ; $49C6
    or $02                                        ; $49C8
    cp $20                                        ; $49CA
    jr c, jr_004_49d0                             ; $49CC

    dec a                                         ; $49CE
    dec a                                         ; $49CF

jr_004_49d0:
    ld [wPickerCursorTarget], a                   ; $49D0
    xor a                                         ; $49D3
    ret                                           ; $49D4


; C: A in the picked state: strip 4 + icon 1 (DELETE??) or strip 2
Mode0F_PressA::
    play_sfx1 SFX1_KEY_A                          ; $49D5
    ld a, [wState]                                ; $49DC
    cp $03                                        ; $49DF
    jr nz, jr_004_4a19                            ; $49E1

    call Oam_HideUnused                           ; $49E3
    rst Rst08_WaitVBlank                          ; $49E6
    ld a, $10                                     ; $49E7
    ld [wCursorSpriteVar], a                      ; $49E9
    call Mode0F_DrawBigCursor                     ; $49EC
    call Oam_HideUnused                           ; $49EF
    ld bc, $000a                                  ; $49F2
    call Wait_Frames                              ; $49F5
    ld a, $04                                     ; $49F8
    ld [wMsgStripSel], a                          ; $49FA
    ld a, $01                                     ; $49FD
    ld [wIconSel], a                              ; $49FF
    ld [wStockNavAllowed], a                      ; $4A02
    call PhotoPicker_LoadMessageStrip             ; $4A05
    call PhotoPicker_LoadIcon                     ; $4A08
    set_state STATE_0F_COPY_SELECTED              ; $4A0B
    ld a, $0f                                     ; $4A10
    ld [wCursorSpriteVar], a                      ; $4A12
    call Mode0F_DrawBigCursor                     ; $4A15
    ret                                           ; $4A18


jr_004_4a19:
    ld a, [wPhotoIndex]                           ; $4A19
    cp $1e                                        ; $4A1C
    ret nc                                        ; $4A1E

    call Oam_HideUnused                           ; $4A1F
    rst Rst08_WaitVBlank                          ; $4A22
    ld a, $10                                     ; $4A23
    ld [wCursorSpriteVar], a                      ; $4A25
    call Mode0F_DrawBigCursor                     ; $4A28
    call Oam_HideUnused                           ; $4A2B
    ld bc, $000a                                  ; $4A2E
    call Wait_Frames                              ; $4A31
    ld a, $02                                     ; $4A34
    ld [wMsgStripSel], a                          ; $4A36
    xor a                                         ; $4A39
    ld [wIconSel], a                              ; $4A3A
    ld [wStockNavAllowed], a                      ; $4A3D
    call PhotoPicker_LoadMessageStrip             ; $4A40
    call PhotoPicker_LoadIcon                     ; $4A43
    set_state STATE_0F_SELECTED                   ; $4A46
    ld a, $0f                                     ; $4A4B
    ld [wCursorSpriteVar], a                      ; $4A4D
    call Mode0F_DrawBigCursor                     ; $4A50
    ret                                           ; $4A53


; C: B leaves to mode 05; A blinks the cursor and fades
Mode0F_State04_LeaveSelected::
    ld a, [wAbResult]                             ; $4A54
    bit 0, a                                      ; $4A57
    jr nz, jr_004_4a76                            ; $4A59

    screen_off                                    ; $4A5B
    stat_irq_off                                  ; $4A61
    ld a, MODE_EDIT_MENU                          ; $4A6B
    ld [wMode], a                                 ; $4A6D
    set_state STATE_05_INIT                       ; $4A70
    ret                                           ; $4A75


jr_004_4a76:
    ld b, $04                                     ; $4A76

jr_004_4a78:
    ld c, $09                                     ; $4A78

jr_004_4a7a:
    push bc                                       ; $4A7A
    call PhotoPicker_Wobble                       ; $4A7B
    call PhotoPicker_DrawCursor                   ; $4A7E
    call Oam_HideUnused                           ; $4A81
    rst Rst08_WaitVBlank                          ; $4A84
    pop bc                                        ; $4A85
    dec c                                         ; $4A86
    jr nz, jr_004_4a7a                            ; $4A87

    ld hl, wCursorSpriteVar                       ; $4A89
    inc [hl]                                      ; $4A8C
    dec b                                         ; $4A8D
    jr nz, jr_004_4a78                            ; $4A8E

    screen_off                                    ; $4A90
    stat_irq_off                                  ; $4A96
    next_state                                    ; $4AA0
    ret                                           ; $4AA4


; C: loads the DELETE?? YES / NO screen
Mode0F_State05_ConfirmInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $4AA5
    ldh [hLcdcShadow], a                          ; $4AA7
    ld a, $e4                                     ; $4AA9
    ld [wPaletteTarget], a                        ; $4AAB
    ld [wPaletteTarget + $1], a                   ; $4AAE
    ld a, $d2                                     ; $4AB1
    ld [wPaletteTarget + $2], a                   ; $4AB3
    ld a, $10                                     ; $4AB6
    ldh [hScxShadow], a                           ; $4AB8
    ldh [hScyShadow], a                           ; $4ABA
    ld a, $0d                                     ; $4ABC
    ld hl, Gfx_0D_7900_Mode0F_State05_ConfirmInit ; $4ABE
    ld de, $8900                                  ; $4AC1
    ld bc, $0700                                  ; $4AC4
    call Mem_CopyFromBank                         ; $4AC7
    farcopy Mem_CopyFromBank, Gfx_1C_58A0_Mode0C_State02_Setup, $8580, $0280 ; $4ACA
    farcopy Mem_CopyFromBank, Gfx_1C_5B60_Mode0C_State02_Setup, $8660, $0060 ; $4AD8
    farcopy Mem_CopyFromBank, Gfx_1C_5C60_Mode0C_State02_Setup, $8760, $0060 ; $4AE6
    farcopy Mem_CopyFromBank, Gfx_17_4680_Mode0F_State05_ConfirmInit, $8500, $0010 ; $4AF4
    farcopy Mem_CopyFromBank, Gfx_17_46A0_Mode0F_State05_ConfirmInit, $8510, $0010 ; $4B02
    farcopy Mem_CopyFromBank, Gfx_18_7E80_Mode0F_State05_ConfirmInit, $8660, $00e0 ; $4B10
    farcopy Mem_CopyFromBank, Gfx_18_7D60_Mode0F_State05_ConfirmInit, $8640, $0020 ; $4B1E
    farcopy Mem_CopyFromBank, Gfx_18_7C40_Mode0F_State05_ConfirmInit, $8520, $0120 ; $4B2C
    farcopy Mem_CopyFromBank, Map_23_54C0_Mode0F_State05_ConfirmInit, $9800, $0400 ; $4B3A
    ld a, [wPhotoIndex]                           ; $4B48
    ld [wCopyPhotoIdxC], a                        ; $4B4B
    ldh [hFarcallAArg], a                         ; $4B4E
    farcall Photo_LoadToVram_Far                  ; $4B50
    ld a, [wCopyPhotoIdxC]                        ; $4B58
    ldh [hFarcallAArg], a                         ; $4B5B
    ld a, $02                                     ; $4B5D
    ld hl, Photo_LoadHotspotsTranslated_Far       ; $4B5F
    call Far_Call                                 ; $4B62
    ld a, [wCopyPhotoIdxC]                        ; $4B65
    ldh [hFarcallAArg], a                         ; $4B68
    farcall Photo_LoadBorder_Far                  ; $4B6A
    ldh [hFarcallAArg], a                         ; $4B72
    farcall Border_LoadMap_LcdOff                 ; $4B74
    ld a, $54                                     ; $4B7C
    ldh [hLycShadowSplit1], a                     ; $4B7E
    ldh [hSplit1Latch], a                         ; $4B80
    ld hl, hStatShadow                            ; $4B82
    set 6, [hl]                                   ; $4B85
    ld hl, rIE                                    ; $4B87
    set 1, [hl]                                   ; $4B8A
    ld a, $01                                     ; $4B8C
    ldh [hStatHandlerIndex], a                    ; $4B8E
    screen_on                                     ; $4B90
    play_music MUSIC_ALBUM_VIEWER                 ; $4B99
    call Pal_FadeIn                               ; $4BA0
    next_state                                    ; $4BA3
    ret                                           ; $4BA7


; C: YES (A) or NO (B) with a jittering cursor
Mode0F_State06_ConfirmChoose::
    call Mode0F_DrawYesNoJitter                   ; $4BA8
    ldh a, [hKeysNew]                             ; $4BAB
    and PADF_A | PADF_B                           ; $4BAD
    ret z                                         ; $4BAF

    push af                                       ; $4BB0
    bit 0, a                                      ; $4BB1
    ld a, SFX1_KEY_A                              ; $4BB3
    call nz, Snd_Sfx1                             ; $4BB5
    pop af                                        ; $4BB8
    push af                                       ; $4BB9
    bit 1, a                                      ; $4BBA
    ld a, SFX1_KEY_B                              ; $4BBC
    call nz, Snd_Sfx1                             ; $4BBE
    pop af                                        ; $4BC1
    ld [wAbResult], a                             ; $4BC2
    next_state                                    ; $4BC5
    ret                                           ; $4BC9


; I: yes / no cursor sprite $C5 that shakes by one pixel
Mode0F_DrawYesNoJitter::
    ldh a, [hFrameCounter]                        ; $4BCA
    and $01                                       ; $4BCC
    jr nz, jr_004_4bdc                            ; $4BCE

    call Rng_Next                                 ; $4BD0
    ld [wJitterX], a                              ; $4BD3
    call Rng_Next                                 ; $4BD6
    ld [wJitterY], a                              ; $4BD9

jr_004_4bdc:
    ld a, [wJitterX]                              ; $4BDC
    and $01                                       ; $4BDF
    add $58                                       ; $4BE1
    ld b, a                                       ; $4BE3
    ld a, [wJitterY]                              ; $4BE4
    and $01                                       ; $4BE7
    add $60                                       ; $4BE9
    ld c, a                                       ; $4BEB
    ld a, $c5                                     ; $4BEC
    call Oam_AddMeta_B02_52BD                     ; $4BEE
    ld a, [wJitterX]                              ; $4BF1
    xor $01                                       ; $4BF4
    and $01                                       ; $4BF6
    add $4c                                       ; $4BF8
    ld b, a                                       ; $4BFA
    ld a, [wJitterY]                              ; $4BFB
    xor $01                                       ; $4BFE
    and $01                                       ; $4C00
    add $30                                       ; $4C02
    ld c, a                                       ; $4C04
    ld a, $c9                                     ; $4C05
    call Oam_AddMeta_B02_52BD                     ; $4C07
    ret                                           ; $4C0A


; C: YES: erases the photo and its references; then back to mode 09 or 0A
Mode0F_State07_ConfirmApply::
    ld a, [wCallerCode]                           ; $4C0B
    and a                                         ; $4C0E
    jr nz, jr_004_4c30                            ; $4C0F

    call Mode0F_LeaveScreen                       ; $4C11
    ld a, [wAbResult]                             ; $4C14
    and $01                                       ; $4C17
    jr nz, jr_004_4c26                            ; $4C19

    ld a, $01                                     ; $4C1B
    ld [wCursorSpriteVar], a                      ; $4C1D
    set_state STATE_0F_RE_INIT                    ; $4C20
    ret                                           ; $4C25


jr_004_4c26:
    ld a, $03                                     ; $4C26
    ld [wMsgStripSel], a                          ; $4C28
    next_state                                    ; $4C2B
    ret                                           ; $4C2F


jr_004_4c30:
    ld a, [wAbResult]                             ; $4C30
    and $01                                       ; $4C33
    jr z, jr_004_4c57                             ; $4C35

    call Mode0F_EraseJingleTiles                  ; $4C37
    ld a, [wPhotoIndex]                           ; $4C3A
    ldh [hFarcallAArg], a                         ; $4C3D
    farcall Photo_Erase_UnlinkAll_Far             ; $4C3F
    ld a, [wPhotoIndex]                           ; $4C47
    ldh [hFarcallAArg], a                         ; $4C4A
    farcall Photo_Erase_Far                       ; $4C4C
    call Counters_IncErased                       ; $4C54

jr_004_4c57:
    call Mode0F_LeaveScreen                       ; $4C57
    ld a, [wCallerCode]                           ; $4C5A
    cp $01                                        ; $4C5D
    jr nz, jr_004_4c6c                            ; $4C5F

    ld a, MODE_ALBUM_EDIT                         ; $4C61
    ld [wMode], a                                 ; $4C63
    set_state STATE_09_INIT                       ; $4C66
    ret                                           ; $4C6B


jr_004_4c6c:
    ld a, $01                                     ; $4C6C
    ld [wAbResult], a                             ; $4C6E
    ld a, MODE_ALBUM_VIEW                         ; $4C71
    ld [wMode], a                                 ; $4C73
    set_state STATE_0A_SETUP                      ; $4C76
    ret                                           ; $4C7B


; C: fade out + LCD off + clear STAT mode-0 IRQ bits
Mode0F_LeaveScreen::
    screen_off                                    ; $4C7C
    stat_irq_off                                  ; $4C82
    ret                                           ; $4C8C


; C: single photo erase after YES (animation then counters)
Mode0F_State09_EraseOne::
    xor a                                         ; $4C8D
    ld [wDelVariant], a                           ; $4C8E
    ld a, [wPhotoIndex]                           ; $4C91
    ld c, $00                                     ; $4C94
    call EraseAnim_Run                            ; $4C96
    ld a, [wPhotoIndex]                           ; $4C99
    ldh [hFarcallAArg], a                         ; $4C9C
    farcall Photo_Erase_UnlinkAll_Far             ; $4C9E
    ld a, [wPhotoIndex]                           ; $4CA6
    ldh [hFarcallAArg], a                         ; $4CA9
    farcall Photo_Erase_Far                       ; $4CAB
    call Counters_IncErased                       ; $4CB3
    xor a                                         ; $4CB6
    ld [wCursorSpriteVar], a                      ; $4CB7
    call Oam_ClearShadow                          ; $4CBA
    ld a, [wPhotoIndex]                           ; $4CBD
    call PhotoPicker_LoadPageThumbs               ; $4CC0
    ld a, $00                                     ; $4CC3
    ld hl, $8700                                  ; $4CC5
    ld bc, $0100                                  ; $4CC8
    call Vram_ClearSafe                           ; $4CCB
    rst Rst08_WaitVBlank                          ; $4CCE
    ld a, [wPhotoIndex]                           ; $4CCF
    ld hl, wPhotoCount                            ; $4CD2
    cp [hl]                                       ; $4CD5
    jr c, jr_004_4ce1                             ; $4CD6

    and $07                                       ; $4CD8
    jr z, jr_004_4cfb                             ; $4CDA

    ld a, [hl]                                    ; $4CDC
    dec a                                         ; $4CDD
    ld [wPhotoIndex], a                           ; $4CDE

jr_004_4ce1:
    call PhotoPicker_LoadBigThumb                 ; $4CE1
    xor a                                         ; $4CE4
    ld [wCursorSpriteVar], a                      ; $4CE5
    call PhotoPicker_DrawCursor                   ; $4CE8
    call Oam_HideUnused                           ; $4CEB
    rst Rst08_WaitVBlank                          ; $4CEE
    call PhotoPicker_ClearThumbSlot               ; $4CEF
    rst Rst08_WaitVBlank                          ; $4CF2
    ld a, $01                                     ; $4CF3
    ld [wCursorSpriteVar], a                      ; $4CF5
    call PhotoPicker_DrawCursor                   ; $4CF8

jr_004_4cfb:
    ld a, $02                                     ; $4CFB
    ld [wMsgStripSel], a                          ; $4CFD
    call PhotoPicker_LoadMessageStrip             ; $4D00
    set_state STATE_0F_BROWSE                     ; $4D03
    ret                                           ; $4D08


; I: 18 bytes 05 0F 06 05 07 05 06 05 07 05 08 05 0B 05 0C 05 0E 14 right after the ret of Mode0F_State09_EraseOne;
; they read as 9 {frame,duration} pairs (frames 5 6 7 6 7 8 11 12 14, durations 15 5 5 5 5 5 5 5 20) but nothing reads
; them. Evidence: no instruction loads an address in 04:4D09-4D1A; BGB ...
Unused_Mode0F_State09_EraseOne_Tbl4D09::
    db $05, $0f, $06, $05, $07, $05
    db $06, $05, $07, $05, $08, $05
    db $0b, $05, $0c, $05, $0e, $14

; C: erase-all branch: A erases every photo, B cancels (130 instructions, never played until §16.14)
Mode0F_State0A_EraseAll::
    call Oam_ClearShadow                          ; $4D1B
    ld a, [wPhotoIndex]                           ; $4D1E
    call PhotoPicker_LoadPageThumbs               ; $4D21
    ld a, $00                                     ; $4D24
    ld hl, $8700                                  ; $4D26
    ld bc, $0100                                  ; $4D29
    call Vram_ClearSafe                           ; $4D2C
    rst Rst08_WaitVBlank                          ; $4D2F
    xor a                                         ; $4D30
    ld [wPhotoIndex], a                           ; $4D31
    call PhotoPicker_LoadPageThumbs               ; $4D34
    call PhotoPicker_LoadPageTabs                 ; $4D37
    farcopy Vram_CopyFromBank, Gfx_19_7560_Mode0F_State0A_EraseAll, $8800, $0280 ; $4D3A
    farcopy Vram_CopyFromBank, Gfx_19_77E0_Mode0F_State0A_EraseAll, $8080, $0600 ; $4D48
    ld hl, hLcdcShadow                            ; $4D56
    set 2, [hl]                                   ; $4D59
    rst Rst08_WaitVBlank                          ; $4D5B

jr_004_4d5c:
    call Mode0F_DrawEraseAllJitter                ; $4D5C
    call Oam_HideUnused                           ; $4D5F
    rst Rst08_WaitVBlank                          ; $4D62
    ldh a, [hKeysNew]                             ; $4D63
    bit PADB_B, a                                 ; $4D65
    jr z, jr_004_4d72                             ; $4D67

    play_sfx1 SFX1_KEY_B                          ; $4D69
    jr jr_004_4d97                                ; $4D70

jr_004_4d72:
    bit 0, a                                      ; $4D72
    jr z, jr_004_4d5c                             ; $4D74

    ld a, $01                                     ; $4D76
    ld [wDelVariant], a                           ; $4D78
    call Mode0F_EraseOneAnimated                  ; $4D7B
    call Mode0F_ForgetAllAnimations               ; $4D7E
    jr jr_004_4d91                                ; $4D81

jr_004_4d83:
    xor a                                         ; $4D83
    ldh [hFarcallAArg], a                         ; $4D84
    farcall Photo_Erase_Far                       ; $4D86
    call Counters_IncErased                       ; $4D8E

jr_004_4d91:
    ld a, [wPhotoCount]                           ; $4D91
    and a                                         ; $4D94
    jr nz, jr_004_4d83                            ; $4D95

jr_004_4d97:
    call Oam_ClearShadow                          ; $4D97
    rst Rst08_WaitVBlank                          ; $4D9A
    ld hl, hLcdcShadow                            ; $4D9B
    res 2, [hl]                                   ; $4D9E
    rst Rst08_WaitVBlank                          ; $4DA0
    farcopy Vram_CopyFromBank, Gfx_0E_4500_MsgStrip, $8800, $0280 ; $4DA1
    farcopy Vram_CopyFromBank, Gfx_13_5880_Mode0F_State0A_EraseAll, $8080, $0600 ; $4DAF
    xor a                                         ; $4DBD
    ld [wPhotoIndex], a                           ; $4DBE
    call PhotoPicker_LoadPageThumbs               ; $4DC1
    call PhotoPicker_NoPhotoHere                  ; $4DC4
    jr c, jr_004_4de5                             ; $4DC7

    call PhotoPicker_LoadBigThumb                 ; $4DC9
    xor a                                         ; $4DCC
    ld [wCursorSpriteVar], a                      ; $4DCD
    call PhotoPicker_DrawCursor                   ; $4DD0
    call Oam_HideUnused                           ; $4DD3
    rst Rst08_WaitVBlank                          ; $4DD6
    call PhotoPicker_ClearThumbSlot               ; $4DD7
    rst Rst08_WaitVBlank                          ; $4DDA
    ld a, $01                                     ; $4DDB
    ld [wCursorSpriteVar], a                      ; $4DDD
    call PhotoPicker_DrawCursor                   ; $4DE0
    jr jr_004_4dea                                ; $4DE3

jr_004_4de5:
    ld a, $11                                     ; $4DE5
    ld [wCursorSpriteVar], a                      ; $4DE7

jr_004_4dea:
    call PhotoPicker_LoadPageTabs                 ; $4DEA
    call PhotoPicker_LoadMessageStrip             ; $4DED
    call PhotoPicker_LoadIcon                     ; $4DF0
    set_state STATE_0F_BROWSE                     ; $4DF3
    ret                                           ; $4DF8


; C: two sprites $B4 / $B5 that shake by one pixel (erase-all prompt)
Mode0F_DrawEraseAllJitter::
    ldh a, [hFrameCounter]                        ; $4DF9
    and $01                                       ; $4DFB
    jr nz, jr_004_4e0b                            ; $4DFD

    call Rng_Next                                 ; $4DFF
    ld [wJitterX], a                              ; $4E02
    call Rng_Next                                 ; $4E05
    ld [wJitterY], a                              ; $4E08

jr_004_4e0b:
    ld a, [wJitterX]                              ; $4E0B
    and $01                                       ; $4E0E
    add $30                                       ; $4E10
    ld b, a                                       ; $4E12
    ld a, [wJitterY]                              ; $4E13
    and $01                                       ; $4E16
    add $40                                       ; $4E18
    ld c, a                                       ; $4E1A
    ld a, $b4                                     ; $4E1B
    call Oam_AddMeta_B02_52BD                     ; $4E1D
    ld a, $b5                                     ; $4E20
    call Oam_AddMeta_B02_52BD                     ; $4E22
    ret                                           ; $4E25


; C: far 02:4EE8 then marks every animation entry $FE and stores it (02:4A07)
Mode0F_ForgetAllAnimations::
    ldh [hFarcallAArg], a                         ; $4E26
    farcall Settings_LoadAnimTranslated_Far       ; $4E28
    ld hl, wAnimList                              ; $4E30
    ld a, $fe                                     ; $4E33
    ld b, $2f                                     ; $4E35

jr_004_4e37:
    bit 7, [hl]                                   ; $4E37
    jr nz, jr_004_4e3c                            ; $4E39

    ld [hl], a                                    ; $4E3B

jr_004_4e3c:
    inc hl                                        ; $4E3C
    dec b                                         ; $4E3D
    jr nz, jr_004_4e37                            ; $4E3E

    ldh [hFarcallAArg], a                         ; $4E40
    farcall Settings_StoreAnimTranslated_Far      ; $4E42
    ret                                           ; $4E4A


; C: Album Copy: grid browse with the copy counter
Mode0F_State0C_CopyBrowse::
    call Mode0F_DrawCopiedMarker                  ; $4E4B
    call PhotoPicker_Wobble                       ; $4E4E
    call PhotoPicker_DrawCursor                   ; $4E51
    ld a, [wPhotoIndex]                           ; $4E54
    ld hl, wLastPhotoSeen                         ; $4E57
    cp [hl]                                       ; $4E5A
    jr z, jr_004_4e65                             ; $4E5B

    ld [hl], a                                    ; $4E5D
    xor a                                         ; $4E5E
    ld [wCopiesOfPhoto], a                        ; $4E5F
    ld [wCopiedMarkerTimer], a                    ; $4E62

jr_004_4e65:
    ld a, [wMsgStripSel]                          ; $4E65
    cp $0d                                        ; $4E68
    jr nz, jr_004_4e7e                            ; $4E6A

    ldh a, [hKeysNew]                             ; $4E6C
    and PADF_DPAD                                 ; $4E6E
    jr z, jr_004_4e7e                             ; $4E70

    push af                                       ; $4E72
    ld a, $04                                     ; $4E73
    ld [wMsgStripSel], a                          ; $4E75
    call PhotoPicker_LoadMessageStrip             ; $4E78
    pop af                                        ; $4E7B
    ldh [hKeysNewRepeat], a                       ; $4E7C

jr_004_4e7e:
    ldh a, [hKeysNew]                             ; $4E7E
    and PADF_A                                    ; $4E80
    jr z, jr_004_4ec1                             ; $4E82

    ld [wAbResult], a                             ; $4E84
    ld a, [wPhotoCount]                           ; $4E87
    cp $1e                                        ; $4E8A
    jr c, jr_004_4e9e                             ; $4E8C

    play_sfx1 SFX1_BEEP_REFUSED                   ; $4E8E
    ld a, $0d                                     ; $4E95
    ld [wMsgStripSel], a                          ; $4E97
    call PhotoPicker_LoadMessageStrip             ; $4E9A
    ret                                           ; $4E9D


jr_004_4e9e:
    ld a, [wPhotoIndex]                           ; $4E9E
    cp $1e                                        ; $4EA1
    jr nc, jr_004_4eb4                            ; $4EA3

    ld hl, wPhotoCount                            ; $4EA5
    cp [hl]                                       ; $4EA8
    jr c, jr_004_4eb4                             ; $4EA9

    play_sfx1 SFX1_BEEP_REFUSED                   ; $4EAB
    jr jr_004_4ec1                                ; $4EB2

jr_004_4eb4:
    play_sfx1 SFX1_COPY_BROWSE                    ; $4EB4
    set_state STATE_0F_COPY_DO                    ; $4EBB
    ret                                           ; $4EC0


jr_004_4ec1:
    ldh a, [hKeysNew]                             ; $4EC1
    and PADF_B                                    ; $4EC3
    jr z, jr_004_4ed7                             ; $4EC5

    ld [wAbResult], a                             ; $4EC7
    play_sfx1 SFX1_KEY_B                          ; $4ECA
    set_state STATE_0F_COPY_DO                    ; $4ED1
    ret                                           ; $4ED6


jr_004_4ed7:
    ld a, [wPhotoIndex]                           ; $4ED7
    cp $1e                                        ; $4EDA
    jr c, jr_004_4ee0                             ; $4EDC

    inc a                                         ; $4EDE
    inc a                                         ; $4EDF

jr_004_4ee0:
    and $07                                       ; $4EE0
    jr nz, jr_004_4eec                            ; $4EE2

    ldh a, [hKeysNewRepeat]                       ; $4EE4
    bit PADB_LEFT, a                              ; $4EE6
    jr z, jr_004_4f14                             ; $4EE8

    jr jr_004_4ef6                                ; $4EEA

jr_004_4eec:
    cp $02                                        ; $4EEC
    jr nz, jr_004_4f14                            ; $4EEE

    ldh a, [hKeysNewRepeat]                       ; $4EF0
    bit PADB_UP, a                                ; $4EF2
    jr z, jr_004_4f14                             ; $4EF4

jr_004_4ef6:
    ld a, [wPhotoIndex]                           ; $4EF6
    cp $1e                                        ; $4EF9
    jr nc, jr_004_4f14                            ; $4EFB

    ld a, $0f                                     ; $4EFD
    ld [wCursorSpriteVar], a                      ; $4EFF
    call Oam_HideUnused                           ; $4F02
    rst Rst08_WaitVBlank                          ; $4F05
    call Oam_ClearShadow                          ; $4F06
    call PhotoPicker_NoPhotoHere                  ; $4F09
    call nc, PhotoPicker_LoadThumbToVram          ; $4F0C
    next_state                                    ; $4F0F
    ret                                           ; $4F13


jr_004_4f14:
    call PhotoPicker_MoveCursor                   ; $4F14
    ret                                           ; $4F17


; C: copy the picked photo into a free slot (02:45A1)
Mode0F_State0E_CopyDo::
    ld a, [wAbResult]                             ; $4F18
    bit 0, a                                      ; $4F1B
    jr nz, jr_004_4f3a                            ; $4F1D

    screen_off                                    ; $4F1F
    stat_irq_off                                  ; $4F25
    ld a, MODE_EDIT_MENU                          ; $4F2F
    ld [wMode], a                                 ; $4F31
    set_state STATE_05_INIT                       ; $4F34
    ret                                           ; $4F39


jr_004_4f3a:
    ld a, $05                                     ; $4F3A
    ld [wMsgStripSel], a                          ; $4F3C
    call PhotoPicker_LoadMessageStrip             ; $4F3F
    ld hl, wCopiesOfPhoto                         ; $4F42
    inc [hl]                                      ; $4F45
    call Mode0F_DrawCopyCount                     ; $4F46
    ld a, [wPhotoIndex]                           ; $4F49
    ldh [hFarcallAArg], a                         ; $4F4C
    farcall Photo_LoadImage_Far                   ; $4F4E
    ld a, [wPhotoIndex]                           ; $4F56
    ldh [hFarcallAArg], a                         ; $4F59
    farcall Photo_SaveCopy_Far                    ; $4F5B
    call Oam_HideUnused                           ; $4F63
    ld a, [wPhotoIndex]                           ; $4F66
    call PhotoPicker_LoadPageThumbs               ; $4F69
    ld a, $00                                     ; $4F6C
    ld hl, $8700                                  ; $4F6E
    ld bc, $0100                                  ; $4F71
    call Vram_ClearSafe                           ; $4F74
    rst Rst08_WaitVBlank                          ; $4F77
    call Mode0F_DrawCopiedMarker                  ; $4F78
    call PhotoPicker_LoadBigThumb                 ; $4F7B
    xor a                                         ; $4F7E
    ld [wCursorSpriteVar], a                      ; $4F7F
    call PhotoPicker_DrawCursor                   ; $4F82
    call Oam_HideUnused                           ; $4F85
    rst Rst08_WaitVBlank                          ; $4F88
    call PhotoPicker_ClearThumbSlot               ; $4F89
    rst Rst08_WaitVBlank                          ; $4F8C
    ld a, $01                                     ; $4F8D
    ld [wCursorSpriteVar], a                      ; $4F8F
    call PhotoPicker_DrawCursor                   ; $4F92
    ld a, $04                                     ; $4F95
    ld [wMsgStripSel], a                          ; $4F97
    call PhotoPicker_LoadMessageStrip             ; $4F9A
    set_state STATE_0F_COPY_BROWSE                ; $4F9D
    ret                                           ; $4FA2


; C: cursor metasprite at (50
Mode0F_DrawBigCursor::
    ld bc, $3032                                  ; $4FA3
    ld a, [wCursorSpriteVar]                      ; $4FA6
    add $0f                                       ; $4FA9
    call Oam_AddMeta_B01_4000                     ; $4FAB
    ret                                           ; $4FAE


; C: two decimal digits of copies_of_photo as tile copies
Mode0F_DrawCopyCount::
    ld b, $00                                     ; $4FAF
    ld a, [wCopiesOfPhoto]                        ; $4FB1

jr_004_4fb4:
    cp $0a                                        ; $4FB4
    jr c, jr_004_4fbd                             ; $4FB6

    sub $0a                                       ; $4FB8
    inc b                                         ; $4FBA
    jr jr_004_4fb4                                ; $4FBB

jr_004_4fbd:
    push bc                                       ; $4FBD
    swap a                                        ; $4FBE
    ld c, a                                       ; $4FC0
    ld b, $00                                     ; $4FC1
    ld a, BANK(Gfx_13_5950_Mode0F_DrawCopyCount)  ; $4FC3
    ld hl, Gfx_13_5950_Mode0F_DrawCopyCount       ; $4FC5
    add hl, bc                                    ; $4FC8
    ld de, $8140                                  ; $4FC9
    ld bc, $0010                                  ; $4FCC
    call Vram_CopyFromBank                        ; $4FCF
    pop af                                        ; $4FD2
    swap a                                        ; $4FD3
    ld c, a                                       ; $4FD5
    ld b, $00                                     ; $4FD6
    ld a, BANK(Gfx_13_5950_Mode0F_DrawCopyCount)  ; $4FD8
    ld hl, Gfx_13_5950_Mode0F_DrawCopyCount       ; $4FDA
    add hl, bc                                    ; $4FDD
    ld de, $8130                                  ; $4FDE
    ld bc, $0010                                  ; $4FE1
    call Vram_CopyFromBank                        ; $4FE4
    ld a, [wPhotoIndex]                           ; $4FE7
    cp $1e                                        ; $4FEA
    jr c, jr_004_4ff0                             ; $4FEC

    inc a                                         ; $4FEE
    inc a                                         ; $4FEF

jr_004_4ff0:
    and $07                                       ; $4FF0
    sla a                                         ; $4FF2
    ld c, a                                       ; $4FF4
    ld b, $00                                     ; $4FF5
    ld hl, Mode0F_CopiedMarkerPosTbl              ; $4FF7
    add hl, bc                                    ; $4FFA
    ld a, [hl+]                                   ; $4FFB
    ld [wCopiedMarkerXy], a                       ; $4FFC
    ld a, [hl]                                    ; $4FFF
    ld [wCopiedMarkerXy + $1], a                  ; $5000
    ld a, $26                                     ; $5003
    ld [wCopiedMarkerTimer], a                    ; $5005
    ret                                           ; $5008


; C: 8 x {x; y} of the copied-marker sprite (wCopiedMarkerXy): Mode0F_DrawCopyCount (04:4FF7) indexes it by
; (wPhotoIndex, +2 from photo 30) and 7, x 2; three rows x = $23 / $4B / $73, y = $0B / $33 / $5B, the first slot of
; the top row not used (read 2026-10-25)
Mode0F_CopiedMarkerPosTbl::
    db $4b, $0b, $73, $0b, $23, $33, $4b, $33, $73, $33, $23, $5b, $4b, $5b, $73, $5b

; C: sprite showing that a copy was made; counts down copied_marker_timer
Mode0F_DrawCopiedMarker::
    ld a, [wCopiedMarkerTimer]                    ; $5019
    and a                                         ; $501C
    ret z                                         ; $501D

    dec a                                         ; $501E
    ld [wCopiedMarkerTimer], a                    ; $501F
    ld hl, wCopiedMarkerXy + $1                   ; $5022
    cp $24                                        ; $5025
    jr nz, jr_004_502b                            ; $5027

    dec [hl]                                      ; $5029
    dec [hl]                                      ; $502A

jr_004_502b:
    cp $21                                        ; $502B
    jr nz, jr_004_5031                            ; $502D

    dec [hl]                                      ; $502F
    dec [hl]                                      ; $5030

jr_004_5031:
    cp $1c                                        ; $5031
    jr nz, jr_004_5036                            ; $5033

    dec [hl]                                      ; $5035

jr_004_5036:
    ld a, [wCopiedMarkerXy]                       ; $5036
    ld b, a                                       ; $5039
    ld a, [wCopiedMarkerXy + $1]                  ; $503A
    ld c, a                                       ; $503D
    ld a, $22                                     ; $503E
    call Oam_AddMeta_B01_4000                     ; $5040
    ret                                           ; $5043


; C: plays sound $45 and builds four quadrant tiles of the erase animation; BGB watchpoint pass 2026-10-25: ran only
; in mode 0F (18 hits in 9 runs: 0F:07 x18; tcrf_check/assets/mode_state_wp/)
Mode0F_EraseJingleTiles::
    play_music MUSIC_ERASE_JINGLE                 ; $5044
    ld de, $c0c0                                  ; $504B
    ld b, $02                                     ; $504E

jr_004_5050:
    ld hl, Mode0F_EraseTileTbl                    ; $5050
    ld c, $10                                     ; $5053

jr_004_5055:
    ld a, [hl+]                                   ; $5055
    add e                                         ; $5056
    call Mode0F_CopyPieceToVram                   ; $5057
    dec c                                         ; $505A
    jr nz, jr_004_5055                            ; $505B

    ld a, e                                       ; $505D
    sub $20                                       ; $505E
    ld e, a                                       ; $5060
    dec b                                         ; $5061
    jr nz, jr_004_5050                            ; $5062

    ld b, $05                                     ; $5064

jr_004_5066:
    ld hl, Mode0F_EraseTileTbl                    ; $5066
    ld c, $10                                     ; $5069

jr_004_506b:
    ld a, [hl+]                                   ; $506B
    push af                                       ; $506C
    add e                                         ; $506D
    call Mode0F_CopyPieceToVram                   ; $506E
    pop af                                        ; $5071
    add d                                         ; $5072
    xor $01                                       ; $5073
    call Mode0F_CopyPieceToVram                   ; $5075
    dec c                                         ; $5078
    jr nz, jr_004_506b                            ; $5079

    ld a, e                                       ; $507B
    sub $20                                       ; $507C
    ld e, a                                       ; $507E
    ld a, d                                       ; $507F
    sub $20                                       ; $5080
    ld d, a                                       ; $5082
    dec b                                         ; $5083
    jr nz, jr_004_5066                            ; $5084

    ld b, $02                                     ; $5086

jr_004_5088:
    ld hl, Mode0F_EraseTileTbl                    ; $5088
    ld c, $10                                     ; $508B

jr_004_508d:
    ld a, [hl+]                                   ; $508D
    add d                                         ; $508E
    xor $01                                       ; $508F
    call Mode0F_CopyPieceToVram                   ; $5091
    dec c                                         ; $5094
    jr nz, jr_004_508d                            ; $5095

    ld a, d                                       ; $5097
    sub $20                                       ; $5098
    ld d, a                                       ; $509A
    dec b                                         ; $509B
    jr nz, jr_004_5088                            ; $509C

    ret                                           ; $509E


; C: table read by 5044; BGB watchpoint pass 2026-10-25: ran only in mode 0F (144 hits in 1 runs: 0F:07 x144;
; tcrf_check/assets/mode_state_wp/)
Mode0F_EraseTileTbl::
    db $1f, $1d, $1b, $19, $17, $15, $13, $11, $0e, $0c, $0a, $08, $06, $04, $02, $00

; C: copies one tile piece from a bank to VRAM (A bit 7 selects $9000 or $8800); BGB watchpoint pass 2026-10-25: ran
; only in mode 0F (3806 hits in 9 runs: 0F:07 x3806; tcrf_check/assets/mode_state_wp/)
Mode0F_CopyPieceToVram::
    push bc                                       ; $50AF
    push de                                       ; $50B0
    push hl                                       ; $50B1
    cp $80                                        ; $50B2
    jr nc, jr_004_50bb                            ; $50B4

    ld hl, $9000                                  ; $50B6
    jr jr_004_50c7                                ; $50B9

jr_004_50bb:
    cp $90                                        ; $50BB
    jr nc, jr_004_50c4                            ; $50BD

    ld hl, $8000                                  ; $50BF
    jr jr_004_50c7                                ; $50C2

jr_004_50c4:
    ld hl, $7700                                  ; $50C4

jr_004_50c7:
    swap a                                        ; $50C7
    push af                                       ; $50C9
    and $f0                                       ; $50CA
    ld c, a                                       ; $50CC
    pop af                                        ; $50CD
    and $0f                                       ; $50CE
    ld b, a                                       ; $50D0
    add hl, bc                                    ; $50D1
    push hl                                       ; $50D2
    ld hl, AlbumB_UnusedSlotB_Tiles               ; $50D3
    add hl, bc                                    ; $50D6
    ld a, BANK(AlbumB_UnusedSlotB_Tiles)          ; $50D7
    pop de                                        ; $50D9
    ld bc, $0010                                  ; $50DA
    call Vram_CopyFromBank                        ; $50DD
    rst Rst08_WaitVBlank                          ; $50E0
    pop hl                                        ; $50E1
    pop de                                        ; $50E2
    pop bc                                        ; $50E3
    ret                                           ; $50E4


; C: counters block: erased photos + 1 (BCD) and store
Counters_IncErased::
    ldh [hFarcallAArg], a                         ; $50E5
    farcall Counters_Load_Far                     ; $50E7
    ld a, $01                                     ; $50EF
    ld hl, wCntErased                             ; $50F1
    ld b, $02                                     ; $50F4
    call Bcd_AddSaturate                          ; $50F6
    ldh [hFarcallAArg], a                         ; $50F9
    farcall Counters_Store_Far                    ; $50FB
    ret                                           ; $5103


; C: load the big thumbnail then run the erase animation (A = photo)
Mode0F_EraseOneAnimated::
    call PhotoPicker_NoPhotoHere                  ; $5104
    jr c, jr_004_5117                             ; $5107

    call PhotoPicker_LoadBigThumb                 ; $5109
    call PhotoPicker_ClearThumbSlot               ; $510C
    ld a, [wPhotoIndex]                           ; $510F
    ld c, $01                                     ; $5112
    call EraseAnim_Run                            ; $5114

jr_004_5117:
    ld hl, wPhotoIndex                            ; $5117
    inc [hl]                                      ; $511A
    ld a, [hl]                                    ; $511B
    cp $08                                        ; $511C
    jr nz, Mode0F_EraseOneAnimated                ; $511E

    ret                                           ; $5120


; C: photo shatters into 16 sprites that fly out and fall (del_* variables)
EraseAnim_Run::
    push bc                                       ; $5121
    and $07                                       ; $5122
    sla a                                         ; $5124
    ld c, a                                       ; $5126
    ld b, $00                                     ; $5127
    ld hl, EraseAnim_StartAngleTbl                ; $5129
    add hl, bc                                    ; $512C
    ld a, [hl+]                                   ; $512D
    ld h, [hl]                                    ; $512E
    ld l, a                                       ; $512F
    ld bc, wDelCx                                 ; $5130
    ld de, wDelCy                                 ; $5133
    ld a, $10                                     ; $5136

jr_004_5138:
    ldh [hScratchA], a                            ; $5138
    ld a, h                                       ; $513A
    ld [bc], a                                    ; $513B
    ld a, l                                       ; $513C
    ld [de], a                                    ; $513D
    inc bc                                        ; $513E
    inc de                                        ; $513F
    ldh a, [hScratchA]                            ; $5140
    dec a                                         ; $5142
    jr nz, jr_004_5138                            ; $5143

    ld hl, EraseAnim_Run_Tbl51CD                  ; $5145
    ld de, wDelAngle                              ; $5148
    ld b, $60                                     ; $514B

jr_004_514d:
    ld a, [hl+]                                   ; $514D
    ld [de], a                                    ; $514E
    inc de                                        ; $514F
    dec b                                         ; $5150
    jr nz, jr_004_514d                            ; $5151

    ld a, [wDelVariant]                           ; $5153
    and a                                         ; $5156
    jr nz, jr_004_5162                            ; $5157

    play_sfx1 SFX1_ERASE_ANIM                     ; $5159
    jr jr_004_5169                                ; $5160

jr_004_5162:
    play_sfx4 SFX4_ERASE_ANIM                     ; $5162

jr_004_5169:
    xor a                                         ; $5169
    ld [wDelDone], a                              ; $516A
    call Oam_HideUnused                           ; $516D
    rst Rst08_WaitVBlank                          ; $5170
    pop bc                                        ; $5171

jr_004_5172:
    push bc                                       ; $5172
    call EraseAnim_Spin                           ; $5173
    call EraseAnim_DrawParticles                  ; $5176
    call Oam_HideUnused                           ; $5179
    rst Rst08_WaitVBlank                          ; $517C
    pop bc                                        ; $517D
    ld a, [wDelDone]                              ; $517E
    or c                                          ; $5181
    jr z, jr_004_5172                             ; $5182

    xor a                                         ; $5184
    ld [wDelDone], a                              ; $5185
    call Oam_HideUnused                           ; $5188
    rst Rst08_WaitVBlank                          ; $518B

jr_004_518c:
    call EraseAnim_Fall                           ; $518C
    call EraseAnim_DrawParticles                  ; $518F
    call Oam_HideUnused                           ; $5192
    rst Rst08_WaitVBlank                          ; $5195
    ld a, [wDelDone]                              ; $5196
    and a                                         ; $5199
    jr z, jr_004_518c                             ; $519A

    ret                                           ; $519C


; C: start angles per photo position (8 words). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 01 0F 15)
EraseAnim_StartAngleTbl::
    db $28, $58, $28, $80, $50, $30, $50, $58, $50, $80, $78, $30, $78, $58, $78, $80
    db $00, $00, $00, $08, $00, $10, $00, $18, $08, $00, $08, $08, $08, $10, $08, $18
    db $10, $00, $10, $08, $10, $10, $10, $18, $18, $00, $18, $08, $18, $10, $18, $18

; C: auto: 64 bytes, bytes; referenced by EraseAnim_Run. L3 pass 2026-10-26: not reached by the 206 BGB replays; read
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0F)
EraseAnim_Run_Tbl51CD::
    db $a0, $b3, $cd, $e0, $8d, $a0, $e0, $f3, $73, $60, $20, $0d, $60, $4d, $33, $20
    db $11, $0c, $0c, $11, $0c, $08, $08, $0c, $0c, $08, $08, $0c, $11, $0c, $0c, $11
    db $fc, $fe, $02, $04, $fc, $fe, $02, $04, $fc, $fe, $02, $04, $fc, $fe, $02, $04
    db $f8, $f8, $f8, $f8, $fc, $fc, $fc, $fc, $fe, $fe, $fe, $fe, $ff, $ff, $ff, $ff

    ; padding
    ds $10, $00

    ; padding
    ds $10, $02

; C: adds 2 to the 16 angles
EraseAnim_Spin::
    ld hl, wDelAngle                              ; $522D
    ld b, $10                                     ; $5230

jr_004_5232:
    inc [hl]                                      ; $5232
    inc [hl]                                      ; $5233
    inc hl                                        ; $5234
    dec b                                         ; $5235
    jr nz, jr_004_5232                            ; $5236

    ld hl, wDelRadius                             ; $5238
    ld bc, $1000                                  ; $523B

jr_004_523e:
    ld a, [hl]                                    ; $523E
    and a                                         ; $523F
    jr z, jr_004_5244                             ; $5240

    dec [hl]                                      ; $5242
    inc c                                         ; $5243

jr_004_5244:
    inc hl                                        ; $5244
    dec b                                         ; $5245
    jr nz, jr_004_523e                            ; $5246

    ld a, c                                       ; $5248
    and a                                         ; $5249
    jr nz, jr_004_5251                            ; $524A

    ld a, $01                                     ; $524C
    ld [wDelDone], a                              ; $524E

jr_004_5251:
    ld de, $1000                                  ; $5251

jr_004_5254:
    call EraseAnim_Particle                       ; $5254
    inc e                                         ; $5257
    dec d                                         ; $5258
    jr nz, jr_004_5254                            ; $5259

    ret                                           ; $525B


; C: x = cx + cos * radius; y = cy + sin * radius
EraseAnim_Particle::
    push de                                       ; $525C
    ld d, $00                                     ; $525D
    ld hl, wDelAngle                              ; $525F
    add hl, de                                    ; $5262
    ld a, [hl]                                    ; $5263
    call Math_Cos                                 ; $5264
    push af                                       ; $5267
    ld hl, wDelRadius                             ; $5268
    add hl, de                                    ; $526B
    ld l, [hl]                                    ; $526C
    call Math_MulAL                               ; $526D
    pop af                                        ; $5270
    call nz, Math_NegHL                           ; $5271
    ld a, h                                       ; $5274
    ld hl, wDelCx                                 ; $5275
    add hl, de                                    ; $5278
    add [hl]                                      ; $5279
    ld hl, wDelX                                  ; $527A
    add hl, de                                    ; $527D
    ld [hl], a                                    ; $527E
    ld hl, wDelAngle                              ; $527F
    add hl, de                                    ; $5282
    ld a, [hl]                                    ; $5283
    call Math_Sin                                 ; $5284
    push af                                       ; $5287
    ld hl, wDelRadius                             ; $5288
    add hl, de                                    ; $528B
    ld l, [hl]                                    ; $528C
    call Math_MulAL                               ; $528D
    pop af                                        ; $5290
    call nz, Math_NegHL                           ; $5291
    ld a, h                                       ; $5294
    ld hl, wDelCy                                 ; $5295
    add hl, de                                    ; $5298
    add [hl]                                      ; $5299
    ld hl, wDelY                                  ; $529A
    add hl, de                                    ; $529D
    ld [hl], a                                    ; $529E
    pop de                                        ; $529F
    ret                                           ; $52A0


; C: HL = -HL
Math_NegHL::
    ld a, h                                       ; $52A1
    cpl                                           ; $52A2
    ld h, a                                       ; $52A3
    ld a, l                                       ; $52A4
    cpl                                           ; $52A5
    ld l, a                                       ; $52A6
    inc l                                         ; $52A7
    ret nz                                        ; $52A8

    inc h                                         ; $52A9
    ret                                           ; $52AA


; C: phase 2: gravity on the 16 sprites
EraseAnim_Fall::
    ld a, [wDelVariant]                           ; $52AB
    and a                                         ; $52AE
    jr nz, jr_004_52b6                            ; $52AF

    ldh a, [hFrameCounter]                        ; $52B1
    and $01                                       ; $52B3
    ret z                                         ; $52B5

jr_004_52b6:
    ld hl, wDelAcc                                ; $52B6
    ld de, wDelVel                                ; $52B9
    ld b, $20                                     ; $52BC

jr_004_52be:
    ld a, [de]                                    ; $52BE
    add [hl]                                      ; $52BF
    ld [de], a                                    ; $52C0
    inc de                                        ; $52C1
    inc hl                                        ; $52C2
    dec b                                         ; $52C3
    jr nz, jr_004_52be                            ; $52C4

    ld hl, wDelVel                                ; $52C6
    ld de, wDelX                                  ; $52C9
    ld bc, $1000                                  ; $52CC

jr_004_52cf:
    ld a, [de]                                    ; $52CF
    cp $a4                                        ; $52D0
    jr c, jr_004_52d8                             ; $52D2

    cp $fc                                        ; $52D4
    jr c, jr_004_52db                             ; $52D6

jr_004_52d8:
    add [hl]                                      ; $52D8
    ld [de], a                                    ; $52D9
    inc c                                         ; $52DA

jr_004_52db:
    inc de                                        ; $52DB
    inc hl                                        ; $52DC
    dec b                                         ; $52DD
    jr nz, jr_004_52cf                            ; $52DE

    ld a, c                                       ; $52E0
    and a                                         ; $52E1
    jr nz, jr_004_52e9                            ; $52E2

    ld a, $01                                     ; $52E4
    ld [wDelDone], a                              ; $52E6

jr_004_52e9:
    ld bc, $1000                                  ; $52E9

jr_004_52ec:
    ld a, [de]                                    ; $52EC
    cp $94                                        ; $52ED
    jr c, jr_004_52f5                             ; $52EF

    cp $fc                                        ; $52F1
    jr c, jr_004_52f8                             ; $52F3

jr_004_52f5:
    add [hl]                                      ; $52F5
    ld [de], a                                    ; $52F6
    inc c                                         ; $52F7

jr_004_52f8:
    inc de                                        ; $52F8
    inc hl                                        ; $52F9
    dec b                                         ; $52FA
    jr nz, jr_004_52ec                            ; $52FB

    ld a, c                                       ; $52FD
    and a                                         ; $52FE
    jr nz, jr_004_5306                            ; $52FF

    ld a, $01                                     ; $5301
    ld [wDelDone], a                              ; $5303

jr_004_5306:
    ret                                           ; $5306


; C: writes 16 OAM entries from del_x / del_y at $D4xx (04:530A)
EraseAnim_DrawParticles::
    ldh a, [hOamCursor]                           ; $5307
    ld c, a                                       ; $5309
    ld b, HIGH(wOamShadow)                        ; $530A
    ld de, $1000                                  ; $530C

jr_004_530f:
    call EraseAnim_DrawOne                        ; $530F
    inc e                                         ; $5312
    dec d                                         ; $5313
    jr nz, jr_004_530f                            ; $5314

    ld a, c                                       ; $5316
    ldh [hOamCursor], a                           ; $5317
    ret                                           ; $5319


; C: one OAM entry: y + 8
EraseAnim_DrawOne::
    push de                                       ; $531A
    ld d, $00                                     ; $531B
    ld hl, wDelY                                  ; $531D
    add hl, de                                    ; $5320
    ld a, [hl]                                    ; $5321
    add $08                                       ; $5322
    ld [bc], a                                    ; $5324
    inc c                                         ; $5325
    ld hl, wDelX                                  ; $5326
    add hl, de                                    ; $5329
    ld a, [hl]                                    ; $532A
    ld [bc], a                                    ; $532B
    inc c                                         ; $532C
    ld a, e                                       ; $532D
    add $70                                       ; $532E
    ld [bc], a                                    ; $5330
    inc c                                         ; $5331
    xor a                                         ; $5332
    ld [bc], a                                    ; $5333
    inc c                                         ; $5334
    pop de                                        ; $5335
    ret                                           ; $5336


; I: 17 records x 6 B, one per stamp category ([$D63D] x 6): {sheet pointer lo; hi; bank; block bytes lo; hi; blocks}.
; Stamp_LoadPageGfx (04:589E) steps the pointer by [$D63E] blocks and copies `blocks` consecutive blocks to VRAM $8A00
; (categories 2 and 3 have code of their own: $190 + $190 B to $8A00 / ...
Stamp_PageGfxTbl::
    dwb StampCat00_Face_Gfx
    db $80, $01, $02, $00, $40, $2d, $00, $03, $01
    dwb StampCat02_Pokemon_Gfx
    db $20, $03, $01
    dwb StampCat03_CoroCoro_Gfx
    db $c0, $03, $01
    dw StampCat04_05_SmallKana_Gfx + $AA0
    db BANK(StampCat04_05_SmallKana_Gfx)
    db $a0, $00, $02
    dw StampCat04_05_SmallKana_Gfx + $AA0
    db BANK(StampCat04_05_SmallKana_Gfx)
    db $a0, $00, $02, $00, $40, $2e, $40, $01, $02, $00, $40, $2e, $40, $01, $02
    dw StampCat08_09_Katakana_Gfx + $2000
    db BANK(StampCat08_09_Katakana_Gfx)
    db $40, $01, $02
    dw StampCat08_09_Katakana_Gfx + $2000
    db BANK(StampCat08_09_Katakana_Gfx)
    db $40, $01, $02
    dwb StampCat08_09_Katakana_Gfx
    db $40, $01, $02
    dwb StampCat08_09_Katakana_Gfx
    db $40, $01, $02
    dwb StampCat14_15_Kanji_Gfx
    db $40, $01, $02
    dwb StampCat14_15_Kanji_Gfx
    db $40, $01, $02
    dwb StampCat16_Symbols_Gfx
    db $40, $01, $02

; I: 17 x {lo; hi; bank} by category ([$D63D] x 3): $60 B of icon tiles copied to VRAM $8F00 by
; Stamp_LoadCategoryIcons; the pointers are the Src_*_Tbl539D_* rows
Stamp_CatIconSrcTbl1::
    dwb Src_1D_79A0_Tbl539D_0
    dwb Src_1D_79A0_Tbl539D_0
    dwb Src_1D_79A0_Tbl539D_0
    dwb Src_1D_79A0_Tbl539D_0
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    db $20, $7b, $1d
    dwb Src_1D_7C40_Tbl539D_27
    dwb Src_1D_7A00_Tbl539D_16

; I: 17 x {lo; hi; bank} by category: $60 B of icon tiles copied to VRAM $8F60 by Stamp_LoadCategoryIcons; the
; pointers are the Src_*_Tbl539D_* rows
Stamp_CatIconSrcTbl2::
    dwb Src_1D_7A60_Tbl539D_17
    dwb Src_1D_7E80_Tbl539D_18
    dwb Src_1D_7D60_Tbl539D_19
    dwb Src_1D_7F40_Tbl539D_20
    dwb Src_1D_7E20_Tbl539D_21
    dwb Src_1D_7E20_Tbl539D_21
    dwb Src_1D_7AC0_Tbl539D_23
    dwb Src_1D_7AC0_Tbl539D_23
    dwb Src_1D_7EE0_Tbl539D_25
    dwb Src_1D_7EE0_Tbl539D_25
    dwb Src_1D_7B80_Tbl539D_29
    dwb Src_1D_7B80_Tbl539D_29
    db $e0, $7b, $1d, $e0, $7b, $1d
    dwb Src_1D_7D00_Tbl539D_33

; I: 17 x {lo; hi; bank} by category: the $120 B BG map (9 rows) copied to VRAM $9C00 by Stamp_LoadCategoryIcons; read
; again by Stamp_ReloadTilemapIfDifferent; the pointers are the Src_*_Tbl539D_* rows
Stamp_CatMapSrcTbl::
    db $f0, $76, $27, $e0, $7e, $26, $90, $73, $27, $10, $78, $27, $c0, $7d, $26, $c0
    db $7d, $26, $e0, $7e, $25, $e0, $7e, $25, $e0, $7e, $25, $e0, $7e, $25, $e0, $7e
    db $25, $e0, $7e, $25, $e0, $7e, $25, $e0, $7e, $25, $e0, $7e, $25

; I: 17 records x 5 B by category ([$D63D] x 5): {sheet pointer lo; hi; bank; bytes per stamp lo; hi};
; Stamp_CopyStampTiles (04:5A73) steps the pointer by [$D63F] stamps and copies one stamp to wIconSrcGfx ($C3C0) in
; Stamp_PrepareBuffers. Pointers = the StampCat*_Gfx rows. Decoded 2026-10-19
Stamp_IconSrcGfxTbl::
    db $00, $40, $2c, $80, $00, $00

    db $40, $2d, $00
    db $01, $00, $60
    db $2c, $90, $01
    dwb StampCat03_CoroCoro_Gfx

    db $e0, $01, $a0, $6a, $2a
    db $20, $00, $a0, $6a, $2a
    db $20, $00, $00, $40, $2e
    db $40, $00, $00, $40, $2e
    db $40, $00, $00, $60, $30
    db $40, $00, $00, $60, $30
    db $40, $00, $00, $40, $30
    db $40, $00, $00, $40, $30
    db $40, $00, $00, $60, $2e
    db $40, $00, $00, $60, $2e
    db $40, $00, $00, $58, $2f
    db $40, $00

; I: 17 records x 5 B by category: {mask pointer lo; hi; bank; bytes per stamp lo; hi}: the 1bpp mask of the stamp,
; copied to wIconSrcMask ($C5A0) in Stamp_PrepareBuffers. Not tile data: records 0-3 and 16 point to the
; StampCat*_Mask rows, records 4-15 have bank $00 / $FF (no mask: Stamp_CopyStampTiles ...
Stamp_IconSrcMaskTbl::
    dwb StampCat00_Mask
    db $40, $00, $00, $40, $2f, $80, $00
    dwb StampCat03_Mask
    db $c8, $00
    dw StampCat03_Mask + $1000
    db BANK(StampCat03_Mask)
    db $f0, $00, $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20
    db $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00
    db $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20, $00, $00
    db $00, $00, $20, $00
    dw StampCat03_Mask + $1C00
    db BANK(StampCat03_Mask)
    db $20, $00

; I: auto: 11 bytes, bytes; referenced by Stamp_BuildGraphicsLayer, Stamp_BuildMaskLayer. L3 pass 2026-10-26: read in
; BGB in 33 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_BuildGraphicsLayer_Tbl54AE::
    db $04, $02, $04, $04, $05, $05, $05, $06, $01, $02, $01

    ; padding
    ds $7, $02

    dw $0202
    dw $0202
    dw $0202
    dw $0202
    dw $0202
    dw $0202

; I: auto: 96 bytes, word table; referenced by Stamp_DrawPaletteCursor. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_DrawPaletteCursor_PtrTbl54CC::
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $1E
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $52
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $58
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $58
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $3E
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $3E
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw Stamp_DrawPaletteCursor_PtrTbl54CC + $2A
    dw $5918
    dw $5938
    dw $5958
    dw $7118
    dw $7138
    dw $7158
    dw $5b0e
    dw $5b26
    dw $5b3e
    dw $5b56
    dw $5b6e
    dw $720e
    dw $7226
    dw $723e
    dw $7256
    dw $726e
    dw $5b12
    dw $5b2a
    dw $5b42
    dw $5b5a
    dw $5b72
    dw $7212
    dw $722a
    dw $7242
    dw $725a
    dw $7272
    dw $6419
    dw $6439
    dw $6459
    dw $6021
    dw $6051

; I: auto: 17 bytes, bytes; referenced by Stamp_DrawPaletteCursor. L3 pass 2026-10-26: read in BGB in 2 replay(s) of
; the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_DrawPaletteCursor_Tbl5528::
    db $33, $3b, $3d, $3f, $37, $37, $37, $37, $37

; I: auto: 17 bytes, bytes; referenced by Main_Entry. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic
; corpus, modes 19 (tcrf_check/assets/l3_names/)
Main_Entry_Tbl5531::
    db $37, $37, $37, $37, $37, $37

; C: loaded by Mem_CopyFromBank at 00:3018: Src $14 bytes to $D615 (this build's trace)
Src_04_5537_Main_Entry::
    INCBIN "data/bank_04/Src_04_5537_Main_Entry.bin" ; $5537, 15 bytes
; I: auto: 118 bytes, bytes; referenced by Stamp_PaletteInput. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the
; organic corpus, modes 11 19 (tcrf_check/assets/l3_names/)
Stamp_PaletteInput_Tbl5546::
    dw Stamp_PaletteInput_Tbl5546 + $1E
    dw Stamp_PaletteInput_Tbl5546 + $5E
    dw Stamp_PaletteInput_Tbl5546 + $6A
    dw Stamp_PaletteInput_Tbl5546 + $6A
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    dw Stamp_PaletteInput_Tbl5546 + $36
    db $00, $04, $f5, $0c, $fc, $04, $f5, $0c, $fc, $03, $f5, $0c, $00, $04, $f4, $0e
    db $fc, $04, $f4, $0e, $fc, $03, $f4, $0e, $00, $04, $ed, $14, $fc, $04, $ed, $14
    db $fc, $04, $ed, $14, $fc, $04, $ed, $14, $fc, $03, $ed, $14, $00, $04, $ec, $16
    db $fc, $04, $ec, $16, $fc, $04, $ec, $16, $fc, $04, $ec, $16, $fc, $03, $ec, $16
    db $00, $04, $f5, $0e, $fc, $04, $f5, $0e, $fc, $03, $f5, $0e, $00, $04, $f9, $0a
    db $fc, $03, $f9, $0a


; I: auto: 17 bytes, bytes; referenced by Stamp_PaletteInput. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the
; organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_PaletteInput_Tbl55B8::
    db $13, $09, $02, $02

    db $15
    db $15
    db $12
    db $12
    db $12
    db $12
    db $12

    dw $1012
    dw $0d10

; I: 17 code pointers (5634 / 562D / 563D) selected by category
Stamp_PageStrideJmpTbl::
    dw Stamp_PageTimes3
    dw Stamp_PageTimes3
    dw Stamp_PageTimes2
    dw Stamp_PageTimes2
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5

; C: A = stamp_page * 2
Stamp_PageTimes2::
    ld a, [wStampPage]                            ; $55E5
    sla a                                         ; $55E8
    pop hl                                        ; $55EA
    ret                                           ; $55EB


; C: A = stamp_page * 3
Stamp_PageTimes3::
    ld a, [wStampPage]                            ; $55EC
    ld c, a                                       ; $55EF
    sla a                                         ; $55F0
    add c                                         ; $55F2
    pop hl                                        ; $55F3
    ret                                           ; $55F4


; C: A = stamp_page * 5
Stamp_PageTimes5::
    ld a, [wStampPage]                            ; $55F5
    ld c, a                                       ; $55F8
    sla a                                         ; $55F9
    sla a                                         ; $55FB
    add c                                         ; $55FD
    pop hl                                        ; $55FE
    ret                                           ; $55FF


; C: 17 {F0. L3 pass 2026-10-26: read in BGB in 33 replay(s) of the organic corpus, modes 11
; (tcrf_check/assets/l3_names/)
Stamp_PaletteCursorTbl::
    db $f0, $70, $f0, $70, $f0, $70, $f0, $60, $f0, $68, $f0, $58, $f0, $68, $f0, $50
    db $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70
    db $f0, $80

; C: 17 page counts per category. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz, first read in mode 0F 11)
Stamp_PageCountTbl::
    db $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80
    db $f0

; I: 17 code pointers to 56BF / 56E1 / 56E9 / 56F1 / 56C7 / 56CC / 56D4 / 56D9 (OAM metasprite lists). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0F 11)
Stamp_PaletteCursorFnTbl::
    db $70
    db $f0
    db $80
    db $f0
    db $70
    db $f0
    db $80
    db $f0
    db $70

; I: auto: 17 bytes, tile data; referenced by Stamp_MirrorBuffer, Stamp_MirrorGfxBuffer, Stamp_MirrorMaskBuffer. L3
; pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: table
; read by Stamp_MirrorBuffer / Stamp_MirrorGfxBuffer / ...
Stamp_MirrorBuffer_Gfx563C::
    db $04, $04, $05, $05, $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02

; I: auto: 92 bytes, bytes; referenced by Stamp_Commit. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic
; corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_Commit_Tbl564B::
    dw Stamp_Commit_Tbl564B + $1E
    dw Stamp_Commit_Tbl564B + $40
    dw Stamp_Commit_Tbl564B + $48
    dw Stamp_Commit_Tbl564B + $50
    dw Stamp_Commit_Tbl564B + $26
    dw Stamp_Commit_Tbl564B + $2B
    dw Stamp_Commit_Tbl564B + $33
    dw Stamp_Commit_Tbl564B + $38
    dw Stamp_Commit_Tbl564B + $33
    dw Stamp_Commit_Tbl564B + $38
    dw Stamp_Commit_Tbl564B + $33
    dw Stamp_Commit_Tbl564B + $38
    dw Stamp_Commit_Tbl564B + $33
    dw Stamp_Commit_Tbl564B + $38
    dw Stamp_Commit_Tbl564B + $38
    db $20, $10, $c0, $c3, $00, $a0, $c5, $00, $88, $10, $c0, $c3, $00, $08, $10, $c0
    db $c3, $00, $a0, $c5, $00, $90, $10, $c0, $c3, $00, $10, $10, $c0, $c3, $00, $a0
    db $c5, $00, $20, $20, $c0, $c3, $00, $a0, $c5, $00, $28, $28, $c0, $c3, $00, $a0
    db $c5, $00, $28, $30, $c0, $c3, $00, $a0, $c5, $00

; C: mode 11: STAMP tool
Mode11_Stamp::
    ld a, [wState]                                ; $56A3
    rst Rst18_JumpTable                           ; $56A6

; I: 9 states, rst $18 table of mode $11
Mode11_StateTable::
    dw Mode11_State00_Init
    dw Mode11_State01_PickPhoto
    dw Mode11_State02_Setup
    dw Mode11_State03_Palette
    dw Mode11_State04_Place
    dw Mode11_State05_Leave
    dw Mode11_State06_SaveInit
    dw Mode11_State07_SaveDialog
    dw Mode11_State08_SaveResult

; C
Mode11_State00_Init::
    ld a, $00                                     ; $56B9
    ld [wMsgStripSel], a                          ; $56BB
    ld a, $05                                     ; $56BE
    ld [wIconSel], a                              ; $56C0
    xor a                                         ; $56C3
    ld [wSubstate], a                             ; $56C4
    ld [wStockNavAllowed], a                      ; $56C7
    ld [wCallerCode], a                           ; $56CA
    next_state                                    ; $56CD
    ret                                           ; $56D1


; C: far call to the photo grid picker
Mode11_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $56D2
    ld a, $04                                     ; $56D4
    ld hl, PhotoPicker_Far                        ; $56D6
    call Far_Call                                 ; $56D9
    ret                                           ; $56DC


; C: loads the stamp palette screen and the 17 categories
Mode11_State02_Setup::
    ld a, [wAbResult]                             ; $56DD
    bit 0, a                                      ; $56E0
    jr nz, jr_004_56ef                            ; $56E2

    ld a, MODE_DOODLE_MENU                        ; $56E4
    ld [wMode], a                                 ; $56E6
    set_state STATE_04_INIT                       ; $56E9
    ret                                           ; $56EE


jr_004_56ef:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $56EF
    ldh [hLcdcShadow], a                          ; $56F1
    ld a, $e4                                     ; $56F3
    ld [wPaletteTarget], a                        ; $56F5
    ld [wPaletteTarget + $2], a                   ; $56F8
    ld a, $d2                                     ; $56FB
    ld [wPaletteTarget + $1], a                   ; $56FD
    ld a, $10                                     ; $5700
    ldh [hScxShadow], a                           ; $5702
    ldh [hScyShadow], a                           ; $5704
    ld a, $07                                     ; $5706
    ldh [hWxShadow], a                            ; $5708
    ld a, $94                                     ; $570A
    ldh [hWyShadow], a                            ; $570C
    ld a, $40                                     ; $570E
    ld [wCursorX], a                              ; $5710
    ld a, $38                                     ; $5713
    ld [wCursorY], a                              ; $5715
    xor a                                         ; $5718
    ld [wCursorXFrac], a                          ; $5719
    ld [wCursorYFrac], a                          ; $571C
    ld [wCursorVx], a                             ; $571F
    ld [wCursorVy], a                             ; $5722
    xor a                                         ; $5725
    ld [wStampPaletteFocus], a                    ; $5726
    farcopy Mem_CopyFromBank, Gfx_22_6740_Mode11_State02_Setup, $8900, $00d0 ; $5729
    farcopy Mem_CopyFromBank, Gfx_22_6810_Mode11_State02_Setup, $8d60, $02a0 ; $5737
    farcopy Mem_CopyFromBank, Gfx_22_6AB0_Mode11_State02_Setup, $8500, $0010 ; $5745
    farcopy Mem_CopyFromBank, Map_25_4DC0_Mode11_State02_Setup, $9800, $02c0 ; $5753
    ld a, [wCategoryIndex]                        ; $5761
    ld c, a                                       ; $5764
    ld b, $00                                     ; $5765
    ld hl, wCategoryPosB                          ; $5767
    add hl, bc                                    ; $576A
    ld a, [hl]                                    ; $576B
    ld [wStampPage], a                            ; $576C
    ld hl, wCategoryPosA                          ; $576F
    add hl, bc                                    ; $5772
    ld a, [hl]                                    ; $5773
    ld [wStampItem], a                            ; $5774
    ld a, [wDoodleFromShutterbug]                 ; $5777
    and a                                         ; $577A
    jr nz, jr_004_578f                            ; $577B

    ld a, [wPhotoIndex]                           ; $577D
    ld [wCopyPhotoIdxD], a                        ; $5780
    ldh [hFarcallAArg], a                         ; $5783
    farcall Photo_LoadToVram_Far                  ; $5785
    jr jr_004_57c3                                ; $578D

jr_004_578f:
    ldh [hFarcallAArg], a                         ; $578F
    farcall GameFace_Load_Far                     ; $5791
    ld a, $00                                     ; $5799
    ld hl, wPhotoImage                            ; $579B
    ld de, $9000                                  ; $579E
    ld bc, $0800                                  ; $57A1
    call Mem_CopyFromBank                         ; $57A4
    ld a, $00                                     ; $57A7
    ld hl, wPhotoImage + $800                     ; $57A9
    ld de, $8800                                  ; $57AC
    ld bc, $0100                                  ; $57AF
    call Mem_CopyFromBank                         ; $57B2
    ld a, $00                                     ; $57B5
    ld hl, wPhotoImage + $900                     ; $57B7
    ld de, $8000                                  ; $57BA
    ld bc, $0500                                  ; $57BD
    call Mem_CopyFromBank                         ; $57C0

jr_004_57c3:
    xor a                                         ; $57C3
    ld [wDirtyFlag], a                            ; $57C4
    ldh [hFarcallAArg], a                         ; $57C7
    farcall Counters_Load_Far                     ; $57C9
    ld a, [wBestBall + $1]                        ; $57D1
    cp $05                                        ; $57D4
    jr c, jr_004_57da                             ; $57D6

    ld a, $05                                     ; $57D8

jr_004_57da:
    add $04                                       ; $57DA
    ld [wStampPageLimitC2], a                     ; $57DC
    ld a, $54                                     ; $57DF
    ldh [hLycShadowSplit1], a                     ; $57E1
    ldh [hSplit1Latch], a                         ; $57E3
    ld hl, hStatShadow                            ; $57E5
    set 6, [hl]                                   ; $57E8
    ld hl, rIE                                    ; $57EA
    set 1, [hl]                                   ; $57ED
    ld a, $01                                     ; $57EF
    ldh [hStatHandlerIndex], a                    ; $57F1
    screen_on                                     ; $57F3
    play_music MUSIC_STAMP                        ; $57FC
    call Pal_FadeIn                               ; $5803
    call Stamp_PrepareBuffers                     ; $5806
    ld hl, hLcdcShadow                            ; $5809
    set 2, [hl]                                   ; $580C
    set_state STATE_11_PLACE                      ; $580E
    ret                                           ; $5813


; C: loads the fallback tilemap (bank 27) when the pointers of two categories differ
Stamp_ReloadTilemapIfDifferent::
    ld a, c                                       ; $5814
    sla a                                         ; $5815
    add c                                         ; $5817
    ld c, a                                       ; $5818
    ld hl, Stamp_CatMapSrcTbl                     ; $5819
    add hl, bc                                    ; $581C
    ld c, l                                       ; $581D
    ld b, h                                       ; $581E
    ld a, e                                       ; $581F
    sla a                                         ; $5820
    add e                                         ; $5822
    ld e, a                                       ; $5823
    ld hl, Stamp_CatMapSrcTbl                     ; $5824
    add hl, de                                    ; $5827
    ld a, [bc]                                    ; $5828
    cp [hl]                                       ; $5829
    jr nz, jr_004_5839                            ; $582A

    inc hl                                        ; $582C
    inc bc                                        ; $582D
    ld a, [bc]                                    ; $582E
    cp [hl]                                       ; $582F
    jr nz, jr_004_5839                            ; $5830

    inc hl                                        ; $5832
    inc bc                                        ; $5833
    ld a, [bc]                                    ; $5834
    cp [hl]                                       ; $5835
    jr nz, jr_004_5839                            ; $5836

    ret                                           ; $5838


jr_004_5839:
    farcopy Vram_CopyFromBank, Map_27_75D0_Stamp_ReloadTilemapIfDifferent, $9c00, $0120 ; $5839
    ret                                           ; $5847


; C: page graphics of the current category to $8A00 / $8510
Stamp_LoadPageGfx::
    ld a, [wCategoryIndex]                        ; $5848
    sla a                                         ; $584B
    ld c, a                                       ; $584D
    sla a                                         ; $584E
    add c                                         ; $5850
    ld c, a                                       ; $5851
    ld b, $00                                     ; $5852
    ld hl, Stamp_PageGfxTbl                       ; $5854
    add hl, bc                                    ; $5857
    ld c, [hl]                                    ; $5858
    inc hl                                        ; $5859
    ld b, [hl]                                    ; $585A
    inc hl                                        ; $585B
    ld a, [hl+]                                   ; $585C
    ldh [hScratchA], a                            ; $585D
    push bc                                       ; $585F
    ld c, [hl]                                    ; $5860
    inc hl                                        ; $5861
    ld b, [hl]                                    ; $5862
    inc hl                                        ; $5863
    ld a, [hl]                                    ; $5864
    ldh [hScratchB], a                            ; $5865
    pop hl                                        ; $5867
    ld a, [wStampPage]                            ; $5868
    and a                                         ; $586B
    jr z, jr_004_5872                             ; $586C

jr_004_586e:
    add hl, bc                                    ; $586E
    dec a                                         ; $586F
    jr nz, jr_004_586e                            ; $5870

jr_004_5872:
    ld a, [wCategoryIndex]                        ; $5872
    cp $02                                        ; $5875
    jr z, jr_004_5897                             ; $5877

    cp $03                                        ; $5879
    jr z, jr_004_58b0                             ; $587B

    ld de, $8a00                                  ; $587D
    ldh a, [hScratchB]                            ; $5880

jr_004_5882:
    push af                                       ; $5882
    push hl                                       ; $5883
    push de                                       ; $5884
    push bc                                       ; $5885
    ldh a, [hScratchA]                            ; $5886
    call Vram_CopyFromBank                        ; $5888
    pop bc                                        ; $588B
    pop hl                                        ; $588C
    add hl, bc                                    ; $588D
    ld e, l                                       ; $588E
    ld d, h                                       ; $588F
    pop hl                                        ; $5890
    add hl, bc                                    ; $5891
    pop af                                        ; $5892
    dec a                                         ; $5893
    jr nz, jr_004_5882                            ; $5894

    ret                                           ; $5896


jr_004_5897:
    ld de, $8a00                                  ; $5897
    ld bc, $0190                                  ; $589A
    push hl                                       ; $589D
    push bc                                       ; $589E
    ldh a, [hScratchA]                            ; $589F
    call Vram_CopyFromBank                        ; $58A1
    pop bc                                        ; $58A4
    pop hl                                        ; $58A5
    add hl, bc                                    ; $58A6
    ld de, $8510                                  ; $58A7
    ldh a, [hScratchA]                            ; $58AA
    call Vram_CopyFromBank                        ; $58AC
    ret                                           ; $58AF


jr_004_58b0:
    ld de, $8a00                                  ; $58B0
    ld bc, $0360                                  ; $58B3
    push hl                                       ; $58B6
    push bc                                       ; $58B7
    ldh a, [hScratchA]                            ; $58B8
    call Vram_CopyFromBank                        ; $58BA
    pop bc                                        ; $58BD
    pop hl                                        ; $58BE
    add hl, bc                                    ; $58BF
    ld bc, $0060                                  ; $58C0
    ld de, $8510                                  ; $58C3
    ldh a, [hScratchA]                            ; $58C6
    call Vram_CopyFromBank                        ; $58C8
    ret                                           ; $58CB


; C: two 96-byte tile sets ($8F00
Stamp_LoadCategoryIcons::
    ld a, [wCategoryIndex]                        ; $58CC
    ld c, a                                       ; $58CF
    sla a                                         ; $58D0
    add c                                         ; $58D2
    ld c, a                                       ; $58D3
    ld b, $00                                     ; $58D4
    push bc                                       ; $58D6
    ld hl, Stamp_CatIconSrcTbl1                   ; $58D7
    add hl, bc                                    ; $58DA
    ld a, [hl+]                                   ; $58DB
    ld c, a                                       ; $58DC
    ld a, [hl+]                                   ; $58DD
    ld b, a                                       ; $58DE
    ld a, [hl]                                    ; $58DF
    ld l, c                                       ; $58E0
    ld h, b                                       ; $58E1
    ld de, $8f00                                  ; $58E2
    ld bc, $0060                                  ; $58E5
    call Vram_CopyFromBank                        ; $58E8
    pop bc                                        ; $58EB
    push bc                                       ; $58EC
    ld hl, Stamp_CatIconSrcTbl2                   ; $58ED
    add hl, bc                                    ; $58F0
    ld a, [hl+]                                   ; $58F1
    ld c, a                                       ; $58F2
    ld a, [hl+]                                   ; $58F3
    ld b, a                                       ; $58F4
    ld a, [hl]                                    ; $58F5
    ld l, c                                       ; $58F6
    ld h, b                                       ; $58F7
    ld de, $8f60                                  ; $58F8
    ld bc, $0060                                  ; $58FB
    call Vram_CopyFromBank                        ; $58FE
    pop bc                                        ; $5901
    ld hl, Stamp_CatMapSrcTbl                     ; $5902
    add hl, bc                                    ; $5905
    ld a, [hl+]                                   ; $5906
    ld c, a                                       ; $5907
    ld a, [hl+]                                   ; $5908
    ld b, a                                       ; $5909
    ld a, [hl]                                    ; $590A
    ld l, c                                       ; $590B
    ld h, b                                       ; $590C
    ld de, $9c00                                  ; $590D
    ld bc, $0120                                  ; $5910
    call Vram_CopyFromBank                        ; $5913
    ret                                           ; $5916


; I: category column / stamp grid; A takes a stamp (slides the palette away)
Mode11_State03_Palette::
    call Stamp_DrawPaletteCursor                  ; $5917
    call Stamp_PaletteInput                       ; $591A
    ld a, [wStampPaletteFocus]                    ; $591D
    and a                                         ; $5920
    jr z, jr_004_599b                             ; $5921

    ldh a, [hKeysNewRepeat]                       ; $5923
    and PADF_UP | PADF_DOWN                       ; $5925
    jr z, jr_004_599b                             ; $5927

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $5929
    ld a, [wCategoryIndex]                        ; $5930
    ld c, a                                       ; $5933
    ld b, $00                                     ; $5934
    ld hl, wCategoryPosB                          ; $5936
    add hl, bc                                    ; $5939
    ld a, [wStampPage]                            ; $593A
    ld [hl], a                                    ; $593D
    ld hl, wCategoryPosA                          ; $593E
    add hl, bc                                    ; $5941
    ld a, [wStampItem]                            ; $5942
    ld [hl], a                                    ; $5945
    ldh a, [hKeysNewRepeat]                       ; $5946
    ld b, a                                       ; $5948
    ld a, [wCategoryIndex]                        ; $5949
    ld e, a                                       ; $594C
    ld d, $00                                     ; $594D
    bit 6, b                                      ; $594F
    jr z, jr_004_5966                             ; $5951

    and a                                         ; $5953
    ret z                                         ; $5954

    dec a                                         ; $5955
    cp $03                                        ; $5956
    jr nz, jr_004_597b                            ; $5958

    ld c, a                                       ; $595A
    ld a, [wCoroFlag]                             ; $595B
    cp $01                                        ; $595E
    ld a, c                                       ; $5960
    jr z, jr_004_597b                             ; $5961

    dec a                                         ; $5963
    jr jr_004_597b                                ; $5964

jr_004_5966:
    bit 7, b                                      ; $5966
    ret z                                         ; $5968

    cp $0e                                        ; $5969
    ret z                                         ; $596B

    inc a                                         ; $596C
    cp $03                                        ; $596D
    jr nz, jr_004_597b                            ; $596F

    ld c, a                                       ; $5971
    ld a, [wCoroFlag]                             ; $5972
    cp $01                                        ; $5975
    ld a, c                                       ; $5977
    jr z, jr_004_597b                             ; $5978

    inc a                                         ; $597A

jr_004_597b:
    ld [wCategoryIndex], a                        ; $597B
    ld c, a                                       ; $597E
    ld b, $00                                     ; $597F
    ld hl, wCategoryPosB                          ; $5981
    add hl, bc                                    ; $5984
    ld a, [hl]                                    ; $5985
    ld [wStampPage], a                            ; $5986
    ld hl, wCategoryPosA                          ; $5989
    add hl, bc                                    ; $598C
    ld a, [hl]                                    ; $598D
    ld [wStampItem], a                            ; $598E
    call Stamp_ReloadTilemapIfDifferent           ; $5991
    call Stamp_LoadPageGfx                        ; $5994
    call Stamp_LoadCategoryIcons                  ; $5997
    ret                                           ; $599A


jr_004_599b:
    ldh a, [hKeysNew]                             ; $599B
    bit PADB_A, a                                 ; $599D
    jr z, jr_004_59a8                             ; $599F

    ld a, [wStampPaletteFocus]                    ; $59A1
    and a                                         ; $59A4
    ret nz                                        ; $59A5

    jr jr_004_59ab                                ; $59A6

jr_004_59a8:
    bit 1, a                                      ; $59A8
    ret z                                         ; $59AA

jr_004_59ab:
    call Oam_ClearShadow                          ; $59AB
    call Stamp_PaletteSlideIn                     ; $59AE
    call Stamp_PrepareBuffers                     ; $59B1
    ld hl, hLcdcShadow                            ; $59B4
    set 2, [hl]                                   ; $59B7
    set_state STATE_11_PLACE                      ; $59B9
    ret                                           ; $59BE


; C: clears the four work buffers and rebuilds graphics and mask of the current stamp
Stamp_PrepareBuffers::
    ld a, $b4                                     ; $59BF
    ld [wStampRotateTimer], a                     ; $59C1
    ld hl, wIconTiles1                            ; $59C4
    ld bc, $01e0                                  ; $59C7
    call Mem_Zero                                 ; $59CA
    ld hl, wIconSrcGfx                            ; $59CD
    ld bc, $01e0                                  ; $59D0
    call Mem_Zero                                 ; $59D3
    ld hl, wIconTiles2                            ; $59D6
    ld bc, $01e0                                  ; $59D9
    call Mem_Zero                                 ; $59DC
    ld hl, wIconSrcMask                           ; $59DF
    ld bc, $00f0                                  ; $59E2
    call Mem_Zero                                 ; $59E5
    ld hl, Stamp_IconSrcGfxTbl                    ; $59E8
    ld de, wIconSrcGfx                            ; $59EB
    call Stamp_CopyStampTiles                     ; $59EE
    ld hl, Stamp_IconSrcMaskTbl                   ; $59F1
    ld de, wIconSrcMask                           ; $59F4
    call Stamp_CopyStampTiles                     ; $59F7
    call Stamp_BuildGraphicsLayer                 ; $59FA
    call Stamp_BuildMaskLayer                     ; $59FD
    ld a, $00                                     ; $5A00
    ld hl, wIconTiles1                            ; $5A02
    ld de, $8a00                                  ; $5A05
    ld bc, $01e0                                  ; $5A08
    call Vram_CopyFromBank                        ; $5A0B
    ld a, $00                                     ; $5A0E
    ld hl, wIconTiles2                            ; $5A10
    ld de, $8520                                  ; $5A13
    ld bc, $01e0                                  ; $5A16
    call Vram_CopyFromBank                        ; $5A19
    ret                                           ; $5A1C


; C: copies the graphics of the current stamp into a buffer
Stamp_CopyStampTiles::
    ld a, [wCategoryIndex]                        ; $5A1D
    ld c, a                                       ; $5A20
    sla a                                         ; $5A21
    sla a                                         ; $5A23
    add c                                         ; $5A25
    ld c, a                                       ; $5A26
    ld b, $00                                     ; $5A27
    add hl, bc                                    ; $5A29
    ld c, [hl]                                    ; $5A2A
    inc hl                                        ; $5A2B
    ld b, [hl]                                    ; $5A2C
    inc hl                                        ; $5A2D
    ld a, [hl+]                                   ; $5A2E
    push af                                       ; $5A2F
    push bc                                       ; $5A30
    ld c, [hl]                                    ; $5A31
    inc hl                                        ; $5A32
    ld b, [hl]                                    ; $5A33
    pop hl                                        ; $5A34
    ld a, [wStampItem]                            ; $5A35
    and a                                         ; $5A38
    jr z, jr_004_5a3f                             ; $5A39

jr_004_5a3b:
    add hl, bc                                    ; $5A3B
    dec a                                         ; $5A3C
    jr nz, jr_004_5a3b                            ; $5A3D

jr_004_5a3f:
    pop af                                        ; $5A3F
    and a                                         ; $5A40
    jr z, jr_004_5a4b                             ; $5A41

    cp $ff                                        ; $5A43
    jr z, jr_004_5a4b                             ; $5A45

    call Mem_CopyFromBank                         ; $5A47
    ret                                           ; $5A4A


jr_004_5a4b:
    ldh [hScratchA], a                            ; $5A4B

jr_004_5a4d:
    ldh a, [hScratchA]                            ; $5A4D
    ld [de], a                                    ; $5A4F
    inc de                                        ; $5A50
    dec bc                                        ; $5A51
    ld a, c                                       ; $5A52
    or b                                          ; $5A53
    jr nz, jr_004_5a4d                            ; $5A54

    ret                                           ; $5A56


; C
Stamp_BuildGraphicsLayer::
    ld a, [wCategoryIndex]                        ; $5A57
    sla a                                         ; $5A5A
    ld c, a                                       ; $5A5C
    ld b, $00                                     ; $5A5D
    ld hl, Stamp_BuildGraphicsLayer_Tbl54AE       ; $5A5F
    add hl, bc                                    ; $5A62
    ld c, [hl]                                    ; $5A63
    inc hl                                        ; $5A64
    ld b, [hl]                                    ; $5A65
    xor a                                         ; $5A66
    ldh [hScratchA], a                            ; $5A67
    ld hl, wIconSrcGfx                            ; $5A69
    ld de, wIconTiles1                            ; $5A6C

jr_004_5a6f:
    push bc                                       ; $5A6F
    push de                                       ; $5A70

jr_004_5a71:
    ld b, $10                                     ; $5A71

jr_004_5a73:
    ld a, [hl+]                                   ; $5A73
    ld [de], a                                    ; $5A74
    inc de                                        ; $5A75
    dec b                                         ; $5A76
    jr nz, jr_004_5a73                            ; $5A77

    ld a, e                                       ; $5A79
    add $10                                       ; $5A7A
    ld e, a                                       ; $5A7C
    jr nc, jr_004_5a80                            ; $5A7D

    inc d                                         ; $5A7F

jr_004_5a80:
    dec c                                         ; $5A80
    jr nz, jr_004_5a71                            ; $5A81

    pop de                                        ; $5A83
    pop bc                                        ; $5A84
    ldh a, [hScratchA]                            ; $5A85
    and a                                         ; $5A87
    jr nz, jr_004_5a97                            ; $5A88

    ld a, e                                       ; $5A8A
    add $10                                       ; $5A8B
    ld e, a                                       ; $5A8D
    jr nc, jr_004_5a91                            ; $5A8E

    inc d                                         ; $5A90

jr_004_5a91:
    ld a, $01                                     ; $5A91
    ldh [hScratchA], a                            ; $5A93
    jr jr_004_5aa1                                ; $5A95

jr_004_5a97:
    ld a, e                                       ; $5A97
    add $90                                       ; $5A98
    ld e, a                                       ; $5A9A
    jr nc, jr_004_5a9e                            ; $5A9B

    inc d                                         ; $5A9D

jr_004_5a9e:
    xor a                                         ; $5A9E
    ldh [hScratchA], a                            ; $5A9F

jr_004_5aa1:
    dec b                                         ; $5AA1
    jr nz, jr_004_5a6f                            ; $5AA2

    ret                                           ; $5AA4


; C
Stamp_BuildMaskLayer::
    ld a, [wCategoryIndex]                        ; $5AA5
    sla a                                         ; $5AA8
    ld c, a                                       ; $5AAA
    ld b, $00                                     ; $5AAB
    ld hl, Stamp_BuildGraphicsLayer_Tbl54AE       ; $5AAD
    add hl, bc                                    ; $5AB0
    ld c, [hl]                                    ; $5AB1
    inc hl                                        ; $5AB2
    ld b, [hl]                                    ; $5AB3
    xor a                                         ; $5AB4
    ldh [hScratchA], a                            ; $5AB5
    ld hl, wIconSrcMask                           ; $5AB7
    ld de, wIconTiles2                            ; $5ABA

jr_004_5abd:
    push bc                                       ; $5ABD
    push de                                       ; $5ABE

jr_004_5abf:
    ld b, $08                                     ; $5ABF

jr_004_5ac1:
    ld a, [hl+]                                   ; $5AC1
    cpl                                           ; $5AC2
    ld [de], a                                    ; $5AC3
    inc de                                        ; $5AC4
    xor a                                         ; $5AC5
    ld [de], a                                    ; $5AC6
    inc de                                        ; $5AC7
    dec b                                         ; $5AC8
    jr nz, jr_004_5ac1                            ; $5AC9

    ld a, e                                       ; $5ACB
    add $10                                       ; $5ACC
    ld e, a                                       ; $5ACE
    jr nc, jr_004_5ad2                            ; $5ACF

    inc d                                         ; $5AD1

jr_004_5ad2:
    dec c                                         ; $5AD2
    jr nz, jr_004_5abf                            ; $5AD3

    pop de                                        ; $5AD5
    pop bc                                        ; $5AD6
    ldh a, [hScratchA]                            ; $5AD7
    and a                                         ; $5AD9
    jr nz, jr_004_5ae9                            ; $5ADA

    ld a, e                                       ; $5ADC
    add $10                                       ; $5ADD
    ld e, a                                       ; $5ADF
    jr nc, jr_004_5ae3                            ; $5AE0

    inc d                                         ; $5AE2

jr_004_5ae3:
    ld a, $01                                     ; $5AE3
    ldh [hScratchA], a                            ; $5AE5
    jr jr_004_5af3                                ; $5AE7

jr_004_5ae9:
    ld a, e                                       ; $5AE9
    add $90                                       ; $5AEA
    ld e, a                                       ; $5AEC
    jr nc, jr_004_5af0                            ; $5AED

    inc d                                         ; $5AEF

jr_004_5af0:
    xor a                                         ; $5AF0
    ldh [hScratchA], a                            ; $5AF1

jr_004_5af3:
    dec b                                         ; $5AF3
    jr nz, jr_004_5abd                            ; $5AF4

    ret                                           ; $5AF6


; C: blinking cursor on the category or on the stamp
Stamp_DrawPaletteCursor::
    ld a, [wStampPaletteFocus]                    ; $5AF7
    and a                                         ; $5AFA
    jr z, jr_004_5b10                             ; $5AFB

    ld bc, $8563                                  ; $5AFD
    ldh a, [hFrameCounter]                        ; $5B00
    srl a                                         ; $5B02
    srl a                                         ; $5B04
    srl a                                         ; $5B06
    and $01                                       ; $5B08
    add $35                                       ; $5B0A
    call Oam_AddMeta_B01_4000                     ; $5B0C
    ret                                           ; $5B0F


jr_004_5b10:
    ld a, [wCategoryIndex]                        ; $5B10
    sla a                                         ; $5B13
    ld c, a                                       ; $5B15
    ld b, $00                                     ; $5B16
    ld hl, Stamp_DrawPaletteCursor_PtrTbl54CC     ; $5B18
    add hl, bc                                    ; $5B1B
    ld a, [hl+]                                   ; $5B1C
    ld h, [hl]                                    ; $5B1D
    ld l, a                                       ; $5B1E
    call Stamp_PageStrideCall                     ; $5B1F
    ld c, a                                       ; $5B22
    ld a, [wStampItem]                            ; $5B23
    sub c                                         ; $5B26
    sla a                                         ; $5B27
    ld c, a                                       ; $5B29
    ld b, $00                                     ; $5B2A
    add hl, bc                                    ; $5B2C
    ld a, [hl+]                                   ; $5B2D
    ld b, a                                       ; $5B2E
    ld c, [hl]                                    ; $5B2F
    push bc                                       ; $5B30
    ld a, [wCategoryIndex]                        ; $5B31
    ld c, a                                       ; $5B34
    ld b, $00                                     ; $5B35
    ld hl, Stamp_DrawPaletteCursor_Tbl5528        ; $5B37
    add hl, bc                                    ; $5B3A
    ldh a, [hFrameCounter]                        ; $5B3B
    srl a                                         ; $5B3D
    srl a                                         ; $5B3F
    srl a                                         ; $5B41
    and $01                                       ; $5B43
    add [hl]                                      ; $5B45
    pop bc                                        ; $5B46
    call Oam_AddMeta_B01_4000                     ; $5B47
    ret                                           ; $5B4A


; I: D-pad moves in the grid or changes page; A / B changes the focus
Stamp_PaletteInput::
    ld a, [wStampPaletteFocus]                    ; $5B4B
    and a                                         ; $5B4E
    jr z, jr_004_5b62                             ; $5B4F

    ldh a, [hKeysNew]                             ; $5B51
    and PADF_B | PADF_LEFT                        ; $5B53
    ret z                                         ; $5B55

    play_sfx1 SFX1_KEY_A                          ; $5B56
    xor a                                         ; $5B5D
    ld [wStampPaletteFocus], a                    ; $5B5E
    ret                                           ; $5B61


jr_004_5b62:
    ld a, [wCategoryIndex]                        ; $5B62
    sla a                                         ; $5B65
    ld c, a                                       ; $5B67
    ld b, $00                                     ; $5B68
    ld hl, Stamp_PaletteInput_Tbl5546             ; $5B6A
    add hl, bc                                    ; $5B6D
    ld a, [hl+]                                   ; $5B6E
    ld h, [hl]                                    ; $5B6F
    ld l, a                                       ; $5B70
    call Stamp_PageStrideCall                     ; $5B71
    ld c, a                                       ; $5B74
    ld a, [wStampItem]                            ; $5B75
    sub c                                         ; $5B78
    sla a                                         ; $5B79
    sla a                                         ; $5B7B
    ld c, a                                       ; $5B7D
    ldh a, [hKeysNewRepeat]                       ; $5B7E
    call Joy_DpadBitToIndex                       ; $5B80
    ret z                                         ; $5B83

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5B84
    dec a                                         ; $5B8B
    add c                                         ; $5B8C
    ld c, a                                       ; $5B8D
    ld b, $00                                     ; $5B8E
    add hl, bc                                    ; $5B90
    ld a, [hl]                                    ; $5B91
    ld c, a                                       ; $5B92
    and $03                                       ; $5B93
    cp $01                                        ; $5B95
    jr nz, jr_004_5ba2                            ; $5B97

    ld hl, wStampPage                             ; $5B99
    ld a, [hl]                                    ; $5B9C
    and a                                         ; $5B9D
    ret z                                         ; $5B9E

    dec [hl]                                      ; $5B9F
    jr jr_004_5bc7                                ; $5BA0

jr_004_5ba2:
    cp $02                                        ; $5BA2
    jr nz, jr_004_5bbd                            ; $5BA4

    push bc                                       ; $5BA6
    ld a, [wCategoryIndex]                        ; $5BA7
    ld c, a                                       ; $5BAA
    ld b, $00                                     ; $5BAB
    ld hl, Stamp_PaletteInput_Tbl55B8             ; $5BAD
    add hl, bc                                    ; $5BB0
    pop bc                                        ; $5BB1
    ld a, [wStampPage]                            ; $5BB2
    cp [hl]                                       ; $5BB5
    ret z                                         ; $5BB6

    inc a                                         ; $5BB7
    ld [wStampPage], a                            ; $5BB8
    jr jr_004_5bc7                                ; $5BBB

jr_004_5bbd:
    cp $03                                        ; $5BBD
    jr nz, jr_004_5bcc                            ; $5BBF

    ld a, $01                                     ; $5BC1
    ld [wStampPaletteFocus], a                    ; $5BC3
    ret                                           ; $5BC6


jr_004_5bc7:
    push bc                                       ; $5BC7
    call Stamp_LoadPageGfx                        ; $5BC8
    pop bc                                        ; $5BCB

jr_004_5bcc:
    ld a, c                                       ; $5BCC
    sra a                                         ; $5BCD
    sra a                                         ; $5BCF
    ld hl, wStampItem                             ; $5BD1
    add [hl]                                      ; $5BD4
    ld [hl], a                                    ; $5BD5
    ret                                           ; $5BD6


; C: jumps through the 17-entry table at 560B
Stamp_PageStrideCall::
    push hl                                       ; $5BD7
    ld a, [wCategoryIndex]                        ; $5BD8
    sla a                                         ; $5BDB
    ld c, a                                       ; $5BDD
    ld b, $00                                     ; $5BDE
    ld hl, Stamp_PageStrideJmpTbl                 ; $5BE0
    add hl, bc                                    ; $5BE3
    ld a, [hl+]                                   ; $5BE4
    ld h, [hl]                                    ; $5BE5
    ld l, a                                       ; $5BE6
    jp hl                                         ; $5BE7


; I: cursor moves the stamp; A stamps (hold A mirrors); Start back to the palette; B asks to save
Mode11_State04_Place::
    call Stamp_DrawCursor                         ; $5BE8
    call Stamp_MoveCursor                         ; $5BEB
    call Stamp_HoldAMirror                        ; $5BEE
    call Stamp_Commit                             ; $5BF1
    ldh a, [hKeysHeld]                            ; $5BF4
    ld hl, wEdgeDir                               ; $5BF6
    and [hl]                                      ; $5BF9
    jr nz, jr_004_5bff                            ; $5BFA

    ld [wEdgeCount], a                            ; $5BFC

jr_004_5bff:
    ldh a, [hKeysNew]                             ; $5BFF
    bit PADB_START, a                             ; $5C01
    jr nz, jr_004_5c16                            ; $5C03

    ld a, [wEdgeDir]                              ; $5C05
    and a                                         ; $5C08
    jr z, jr_004_5c3c                             ; $5C09

    ld a, [wEdgeCount]                            ; $5C0B
    inc a                                         ; $5C0E
    ld [wEdgeCount], a                            ; $5C0F
    cp $0a                                        ; $5C12
    jr c, jr_004_5c3c                             ; $5C14

jr_004_5c16:
    call Oam_ClearShadow                          ; $5C16
    rst Rst08_WaitVBlank                          ; $5C19
    call Stamp_LoadPageGfx                        ; $5C1A
    call Stamp_LoadCategoryIcons                  ; $5C1D
    farcopy Vram_CopyFromBank, Gfx_22_6A90_Mode11_State04_Place, $8fe0, $0020 ; $5C20
    call Stamp_PaletteSlideOut                    ; $5C2E
    ld hl, hLcdcShadow                            ; $5C31
    res 2, [hl]                                   ; $5C34
    set_state STATE_11_PALETTE                    ; $5C36
    ret                                           ; $5C3B


jr_004_5c3c:
    ldh a, [hKeysNew]                             ; $5C3C
    bit PADB_B, a                                 ; $5C3E
    ret z                                         ; $5C40

    ld a, [wDirtyFlag]                            ; $5C41
    and a                                         ; $5C44
    jr nz, jr_004_5c54                            ; $5C45

    play_sfx1 SFX1_KEY_B                          ; $5C47
    set_state STATE_11_LEAVE                      ; $5C4E
    ret                                           ; $5C53


jr_004_5c54:
    call Oam_ClearShadow                          ; $5C54
    rst Rst08_WaitVBlank                          ; $5C57
    ld hl, hLcdcShadow                            ; $5C58
    res 2, [hl]                                   ; $5C5B
    ld a, [wState]                                ; $5C5D
    ld [wStampReturnState], a                     ; $5C60
    set_state STATE_11_SAVE_INIT                  ; $5C63
    ret                                           ; $5C68


; C: stores the palette position and returns to the caller or mode 04
Mode11_State05_Leave::
    screen_off                                    ; $5C69
    ld a, [wCategoryIndex]                        ; $5C6F
    ld c, a                                       ; $5C72
    ld b, $00                                     ; $5C73
    ld hl, wCategoryPosB                          ; $5C75
    add hl, bc                                    ; $5C78
    ld a, [wStampPage]                            ; $5C79
    ld [hl+], a                                   ; $5C7C
    ld hl, wCategoryPosA                          ; $5C7D
    add hl, bc                                    ; $5C80
    ld a, [wStampItem]                            ; $5C81
    ld [hl], a                                    ; $5C84
    stat_irq_off                                  ; $5C85
    ld a, [wDoodleFromShutterbug]                 ; $5C8F
    and a                                         ; $5C92
    jr z, jr_004_5ca0                             ; $5C93

    ld a, MODE_DOODLE_MENU                        ; $5C95
    ld [wMode], a                                 ; $5C97
    set_state STATE_04_INIT                       ; $5C9A
    ret                                           ; $5C9F


jr_004_5ca0:
    ld a, [wCallerCode]                           ; $5CA0
    and a                                         ; $5CA3
    jr nz, jr_004_5cac                            ; $5CA4

    set_state STATE_11_INIT                       ; $5CA6
    ret                                           ; $5CAB


jr_004_5cac:
    cp $01                                        ; $5CAC
    jr nz, jr_004_5cbb                            ; $5CAE

    ld a, MODE_ALBUM_EDIT                         ; $5CB0
    ld [wMode], a                                 ; $5CB2
    set_state STATE_09_INIT                       ; $5CB5
    ret                                           ; $5CBA


jr_004_5cbb:
    ld a, $01                                     ; $5CBB
    ld [wAbResult], a                             ; $5CBD
    ld a, MODE_ALBUM_VIEW                         ; $5CC0
    ld [wMode], a                                 ; $5CC2
    set_state STATE_0A_SETUP                      ; $5CC5
    ret                                           ; $5CCA


; C: save dialog id 1 and the target photo
Mode11_State06_SaveInit::
    ld a, $01                                     ; $5CCB
    ld [wSaveDialogWhat], a                       ; $5CCD
    ld a, [wCopyPhotoIdxD]                        ; $5CD0
    ld [wSaveTargetPhoto], a                      ; $5CD3
    xor a                                         ; $5CD6
    ld [wSubstate], a                             ; $5CD7
    next_state                                    ; $5CDA
    ret                                           ; $5CDE


; C: far call 07:699C
Mode11_State07_SaveDialog::
    ldh [hFarcallAArg], a                         ; $5CDF
    farcall SaveDialog_Far                        ; $5CE1
    ret                                           ; $5CE9


; C: YES: save done and back to the palette or placement; NO: leave
Mode11_State08_SaveResult::
    ld a, [wSaveDialogResult]                     ; $5CEA
    and a                                         ; $5CED
    jr nz, jr_004_5cf6                            ; $5CEE

    set_state STATE_11_LEAVE                      ; $5CF0
    ret                                           ; $5CF5


jr_004_5cf6:
    farcopy Vram_CopyFromBank, Gfx_22_6810_Mode11_State02_Setup, $8d60, $02a0 ; $5CF6
    ld a, [wStampReturnState]                     ; $5D04
    cp $03                                        ; $5D07
    jr nz, jr_004_5d1a                            ; $5D09

    call Stamp_LoadPageGfx                        ; $5D0B
    call Stamp_LoadCategoryIcons                  ; $5D0E
    call Stamp_PaletteSlideOut                    ; $5D11
    set_state STATE_11_PALETTE                    ; $5D14
    ret                                           ; $5D19


jr_004_5d1a:
    call Stamp_PrepareBuffers                     ; $5D1A
    ld hl, hLcdcShadow                            ; $5D1D
    set 2, [hl]                                   ; $5D20
    set_state STATE_11_PLACE                      ; $5D22
    ret                                           ; $5D27


; C: cursor metasprite $41 at (x + 16
Stamp_DrawCursor::
    ld a, [wCursorX]                              ; $5D28
    add $10                                       ; $5D2B
    ld b, a                                       ; $5D2D
    ld a, [wCursorY]                              ; $5D2E
    add $10                                       ; $5D31
    ld c, a                                       ; $5D33
    ld a, $41                                     ; $5D34
    call Oam_AddMeta_B01_4000                     ; $5D36
    ret                                           ; $5D39


; I: D-pad movement with edge detection and velocity
Stamp_MoveCursor::
    xor a                                         ; $5D3A
    ld [wEdgeDir], a                              ; $5D3B
    ld b, $ff                                     ; $5D3E
    ldh a, [hKeysHeld]                            ; $5D40
    and PADF_RIGHT | PADF_LEFT                    ; $5D42
    swap a                                        ; $5D44
    ld hl, wCursorVx                              ; $5D46
    ld e, $02                                     ; $5D49

jr_004_5d4b:
    and a                                         ; $5D4B
    ld c, a                                       ; $5D4C
    ld a, [hl]                                    ; $5D4D
    jr z, jr_004_5d5b                             ; $5D4E

    and $fc                                       ; $5D50
    or c                                          ; $5D52
    add b                                         ; $5D53
    jr nc, jr_004_5d5f                            ; $5D54

    ld a, $fc                                     ; $5D56
    or c                                          ; $5D58
    jr jr_004_5d5f                                ; $5D59

jr_004_5d5b:
    sub b                                         ; $5D5B
    jr nc, jr_004_5d5f                            ; $5D5C

    xor a                                         ; $5D5E

jr_004_5d5f:
    ld [hl+], a                                   ; $5D5F
    inc hl                                        ; $5D60
    ldh a, [hKeysHeld]                            ; $5D61
    and PADF_UP | PADF_DOWN                       ; $5D63
    sla a                                         ; $5D65
    rr d                                          ; $5D67
    rlca                                          ; $5D69
    sla d                                         ; $5D6A
    rla                                           ; $5D6C
    dec e                                         ; $5D6D
    jr nz, jr_004_5d4b                            ; $5D6E

    ld hl, wCursorXFrac                           ; $5D70
    ld a, [wCursorVx]                             ; $5D73
    ld e, $02                                     ; $5D76

jr_004_5d78:
    bit 0, a                                      ; $5D78
    jr z, jr_004_5d88                             ; $5D7A

    or $03                                        ; $5D7C
    ld b, a                                       ; $5D7E
    ld a, [hl]                                    ; $5D7F
    add b                                         ; $5D80
    ld [hl+], a                                   ; $5D81
    ld a, [hl]                                    ; $5D82
    adc $00                                       ; $5D83
    ld [hl], a                                    ; $5D85
    jr jr_004_5d96                                ; $5D86

jr_004_5d88:
    bit 1, a                                      ; $5D88
    jr z, jr_004_5d96                             ; $5D8A

    or $03                                        ; $5D8C
    ld b, a                                       ; $5D8E
    ld a, [hl]                                    ; $5D8F
    sub b                                         ; $5D90
    ld [hl+], a                                   ; $5D91
    ld a, [hl]                                    ; $5D92
    sbc $00                                       ; $5D93
    ld [hl], a                                    ; $5D95

jr_004_5d96:
    ld hl, wCursorYFrac                           ; $5D96
    ld a, [wCursorVy]                             ; $5D99
    dec e                                         ; $5D9C
    jr nz, jr_004_5d78                            ; $5D9D

    ld a, [wCategoryIndex]                        ; $5D9F
    sla a                                         ; $5DA2
    sla a                                         ; $5DA4
    ld c, a                                       ; $5DA6
    ld b, $00                                     ; $5DA7
    ld hl, Stamp_PaletteCursorTbl                 ; $5DA9
    add hl, bc                                    ; $5DAC
    ld de, wCursorX                               ; $5DAD
    ld a, $30                                     ; $5DB0
    ldh [hScratchA], a                            ; $5DB2
    ld b, $02                                     ; $5DB4

jr_004_5db6:
    push hl                                       ; $5DB6
    ld a, [de]                                    ; $5DB7
    cp $c0                                        ; $5DB8
    jr c, jr_004_5dc9                             ; $5DBA

    cp [hl]                                       ; $5DBC
    jr nc, jr_004_5dd7                            ; $5DBD

    ldh a, [hScratchA]                            ; $5DBF
    and $60                                       ; $5DC1
    ld [wEdgeDir], a                              ; $5DC3
    ld a, [hl]                                    ; $5DC6
    jr jr_004_5dd7                                ; $5DC7

jr_004_5dc9:
    inc hl                                        ; $5DC9
    cp [hl]                                       ; $5DCA
    jr c, jr_004_5dd7                             ; $5DCB

    jr z, jr_004_5dd7                             ; $5DCD

    ldh a, [hScratchA]                            ; $5DCF
    and $90                                       ; $5DD1
    ld [wEdgeDir], a                              ; $5DD3
    ld a, [hl]                                    ; $5DD6

jr_004_5dd7:
    pop hl                                        ; $5DD7
    ld [de], a                                    ; $5DD8
    ld a, $c0                                     ; $5DD9
    ldh [hScratchA], a                            ; $5DDB
    inc hl                                        ; $5DDD
    inc hl                                        ; $5DDE
    inc de                                        ; $5DDF
    inc de                                        ; $5DE0
    dec b                                         ; $5DE1
    jr nz, jr_004_5db6                            ; $5DE2

    ret                                           ; $5DE4


; C: A held: every 100 frames mirrors the stamp horizontally
Stamp_HoldAMirror::
    ldh a, [hKeysHeld]                            ; $5DE5
    bit PADB_A, a                                 ; $5DE7
    ret z                                         ; $5DE9

    ld a, [wStampRotateTimer]                     ; $5DEA
    dec a                                         ; $5DED
    jr nz, jr_004_5df2                            ; $5DEE

    ld a, $64                                     ; $5DF0

jr_004_5df2:
    ld [wStampRotateTimer], a                     ; $5DF2
    ret nz                                        ; $5DF5

    ld hl, wIconTiles1                            ; $5DF6
    call Stamp_MirrorBuffer                       ; $5DF9
    ld hl, wIconTiles2                            ; $5DFC
    call Stamp_MirrorBuffer                       ; $5DFF
    ld hl, wIconSrcGfx                            ; $5E02
    call Stamp_MirrorGfxBuffer                    ; $5E05
    ld hl, wIconSrcMask                           ; $5E08
    call Stamp_MirrorMaskBuffer                   ; $5E0B
    call Oam_ClearShadow                          ; $5E0E
    rst Rst08_WaitVBlank                          ; $5E11
    ld a, $00                                     ; $5E12
    ld hl, wIconTiles1                            ; $5E14
    ld de, $8a00                                  ; $5E17
    ld bc, $01e0                                  ; $5E1A
    call Vram_CopyFromBank                        ; $5E1D
    ld a, $00                                     ; $5E20
    ld hl, wIconTiles2                            ; $5E22
    ld de, $8520                                  ; $5E25
    ld bc, $01e0                                  ; $5E28
    call Vram_CopyFromBank                        ; $5E2B
    ret                                           ; $5E2E


; C: bit-reverses the rows of a 2 bpp buffer
Stamp_MirrorBuffer::
    push hl                                       ; $5E2F
    ld a, [wCategoryIndex]                        ; $5E30
    ld c, a                                       ; $5E33
    ld b, $00                                     ; $5E34
    ld hl, Stamp_MirrorBuffer_Gfx563C             ; $5E36
    add hl, bc                                    ; $5E39
    ld b, [hl]                                    ; $5E3A
    pop hl                                        ; $5E3B
    push hl                                       ; $5E3C
    ld a, b                                       ; $5E3D
    dec a                                         ; $5E3E
    sla a                                         ; $5E3F
    swap a                                        ; $5E41
    ld e, a                                       ; $5E43
    ld d, $00                                     ; $5E44
    add hl, de                                    ; $5E46
    ld e, l                                       ; $5E47
    ld d, h                                       ; $5E48
    ld a, b                                       ; $5E49
    inc a                                         ; $5E4A
    srl a                                         ; $5E4B
    ld b, a                                       ; $5E4D
    pop hl                                        ; $5E4E
    ld a, $03                                     ; $5E4F

jr_004_5e51:
    ldh [hScratchA], a                            ; $5E51
    push bc                                       ; $5E53
    push de                                       ; $5E54
    push hl                                       ; $5E55

jr_004_5e56:
    ld c, $20                                     ; $5E56

jr_004_5e58:
    ld a, [de]                                    ; $5E58
    srl a                                         ; $5E59
    rl [hl]                                       ; $5E5B
    rr a                                          ; $5E5D
    rl [hl]                                       ; $5E5F
    rr a                                          ; $5E61
    rl [hl]                                       ; $5E63
    rr a                                          ; $5E65
    rl [hl]                                       ; $5E67
    rr a                                          ; $5E69
    rl [hl]                                       ; $5E6B
    rr a                                          ; $5E6D
    rl [hl]                                       ; $5E6F
    rr a                                          ; $5E71
    rl [hl]                                       ; $5E73
    rr a                                          ; $5E75
    rl [hl]                                       ; $5E77
    rr a                                          ; $5E79
    ld [de], a                                    ; $5E7B
    inc hl                                        ; $5E7C
    inc de                                        ; $5E7D
    dec c                                         ; $5E7E
    jr nz, jr_004_5e58                            ; $5E7F

    ld a, e                                       ; $5E81
    sub $40                                       ; $5E82
    ld e, a                                       ; $5E84
    jr nc, jr_004_5e88                            ; $5E85

    dec d                                         ; $5E87

jr_004_5e88:
    dec b                                         ; $5E88
    jr nz, jr_004_5e56                            ; $5E89

    pop hl                                        ; $5E8B
    pop de                                        ; $5E8C
    pop bc                                        ; $5E8D
    ld a, e                                       ; $5E8E
    add $a0                                       ; $5E8F
    ld e, a                                       ; $5E91
    jr nc, jr_004_5e95                            ; $5E92

    inc d                                         ; $5E94

jr_004_5e95:
    ld a, l                                       ; $5E95
    add $a0                                       ; $5E96
    ld l, a                                       ; $5E98
    jr nc, jr_004_5e9c                            ; $5E99

    inc h                                         ; $5E9B

jr_004_5e9c:
    ldh a, [hScratchA]                            ; $5E9C
    dec a                                         ; $5E9E
    jr nz, jr_004_5e51                            ; $5E9F

    ret                                           ; $5EA1


; C: same for the graphics layer
Stamp_MirrorGfxBuffer::
    push hl                                       ; $5EA2
    ld a, [wCategoryIndex]                        ; $5EA3
    ld c, a                                       ; $5EA6
    ld b, $00                                     ; $5EA7
    ld hl, Stamp_MirrorBuffer_Gfx563C             ; $5EA9
    add hl, bc                                    ; $5EAC
    ld b, [hl]                                    ; $5EAD
    pop hl                                        ; $5EAE
    push hl                                       ; $5EAF
    ld a, b                                       ; $5EB0
    dec a                                         ; $5EB1
    swap a                                        ; $5EB2
    ld e, a                                       ; $5EB4
    ld d, $00                                     ; $5EB5
    add hl, de                                    ; $5EB7
    ld e, l                                       ; $5EB8
    ld d, h                                       ; $5EB9
    ld a, b                                       ; $5EBA
    swap a                                        ; $5EBB
    ld c, a                                       ; $5EBD
    ld a, b                                       ; $5EBE
    inc a                                         ; $5EBF
    srl a                                         ; $5EC0
    ld b, a                                       ; $5EC2
    pop hl                                        ; $5EC3
    ld a, $06                                     ; $5EC4

jr_004_5ec6:
    ldh [hScratchA], a                            ; $5EC6
    push bc                                       ; $5EC8
    push de                                       ; $5EC9
    push hl                                       ; $5ECA

jr_004_5ecb:
    ld c, $10                                     ; $5ECB

jr_004_5ecd:
    ld a, [de]                                    ; $5ECD
    srl a                                         ; $5ECE
    rl [hl]                                       ; $5ED0
    rr a                                          ; $5ED2
    rl [hl]                                       ; $5ED4
    rr a                                          ; $5ED6
    rl [hl]                                       ; $5ED8
    rr a                                          ; $5EDA
    rl [hl]                                       ; $5EDC
    rr a                                          ; $5EDE
    rl [hl]                                       ; $5EE0
    rr a                                          ; $5EE2
    rl [hl]                                       ; $5EE4
    rr a                                          ; $5EE6
    rl [hl]                                       ; $5EE8
    rr a                                          ; $5EEA
    rl [hl]                                       ; $5EEC
    rr a                                          ; $5EEE
    ld [de], a                                    ; $5EF0
    inc hl                                        ; $5EF1
    inc de                                        ; $5EF2
    dec c                                         ; $5EF3
    jr nz, jr_004_5ecd                            ; $5EF4

    ld a, e                                       ; $5EF6
    sub $20                                       ; $5EF7
    ld e, a                                       ; $5EF9
    jr nc, jr_004_5efd                            ; $5EFA

    dec d                                         ; $5EFC

jr_004_5efd:
    dec b                                         ; $5EFD
    jr nz, jr_004_5ecb                            ; $5EFE

    pop hl                                        ; $5F00
    pop de                                        ; $5F01
    pop bc                                        ; $5F02
    ld a, e                                       ; $5F03
    add c                                         ; $5F04
    ld e, a                                       ; $5F05
    jr nc, jr_004_5f09                            ; $5F06

    inc d                                         ; $5F08

jr_004_5f09:
    ld a, l                                       ; $5F09
    add c                                         ; $5F0A
    ld l, a                                       ; $5F0B
    jr nc, jr_004_5f0f                            ; $5F0C

    inc h                                         ; $5F0E

jr_004_5f0f:
    ldh a, [hScratchA]                            ; $5F0F
    dec a                                         ; $5F11
    jr nz, jr_004_5ec6                            ; $5F12

    ret                                           ; $5F14


; C: same for the mask layer
Stamp_MirrorMaskBuffer::
    push hl                                       ; $5F15
    ld a, [wCategoryIndex]                        ; $5F16
    ld c, a                                       ; $5F19
    ld b, $00                                     ; $5F1A
    ld hl, Stamp_MirrorBuffer_Gfx563C             ; $5F1C
    add hl, bc                                    ; $5F1F
    ld b, [hl]                                    ; $5F20
    pop hl                                        ; $5F21
    push hl                                       ; $5F22
    ld a, b                                       ; $5F23
    dec a                                         ; $5F24
    swap a                                        ; $5F25
    srl a                                         ; $5F27
    ld e, a                                       ; $5F29
    ld d, $00                                     ; $5F2A
    add hl, de                                    ; $5F2C
    ld e, l                                       ; $5F2D
    ld d, h                                       ; $5F2E
    ld a, b                                       ; $5F2F
    swap a                                        ; $5F30
    srl a                                         ; $5F32
    ld c, a                                       ; $5F34
    ld a, b                                       ; $5F35
    inc a                                         ; $5F36
    srl a                                         ; $5F37
    ld b, a                                       ; $5F39
    pop hl                                        ; $5F3A
    ld a, $06                                     ; $5F3B

jr_004_5f3d:
    ldh [hScratchA], a                            ; $5F3D
    push bc                                       ; $5F3F
    push de                                       ; $5F40
    push hl                                       ; $5F41

jr_004_5f42:
    ld c, $08                                     ; $5F42

jr_004_5f44:
    ld a, [de]                                    ; $5F44
    srl a                                         ; $5F45
    rl [hl]                                       ; $5F47
    rr a                                          ; $5F49
    rl [hl]                                       ; $5F4B
    rr a                                          ; $5F4D
    rl [hl]                                       ; $5F4F
    rr a                                          ; $5F51
    rl [hl]                                       ; $5F53
    rr a                                          ; $5F55
    rl [hl]                                       ; $5F57
    rr a                                          ; $5F59
    rl [hl]                                       ; $5F5B
    rr a                                          ; $5F5D
    rl [hl]                                       ; $5F5F
    rr a                                          ; $5F61
    rl [hl]                                       ; $5F63
    rr a                                          ; $5F65
    ld [de], a                                    ; $5F67
    inc hl                                        ; $5F68
    inc de                                        ; $5F69
    dec c                                         ; $5F6A
    jr nz, jr_004_5f44                            ; $5F6B

    ld a, e                                       ; $5F6D
    sub $10                                       ; $5F6E
    ld e, a                                       ; $5F70
    jr nc, jr_004_5f74                            ; $5F71

    dec d                                         ; $5F73

jr_004_5f74:
    dec b                                         ; $5F74
    jr nz, jr_004_5f42                            ; $5F75

    pop hl                                        ; $5F77
    pop de                                        ; $5F78
    pop bc                                        ; $5F79
    ld a, e                                       ; $5F7A
    add c                                         ; $5F7B
    ld e, a                                       ; $5F7C
    jr nc, jr_004_5f80                            ; $5F7D

    inc d                                         ; $5F7F

jr_004_5f80:
    ld a, l                                       ; $5F80
    add c                                         ; $5F81
    ld l, a                                       ; $5F82
    jr nc, jr_004_5f86                            ; $5F83

    inc h                                         ; $5F85

jr_004_5f86:
    ldh a, [hScratchA]                            ; $5F86
    dec a                                         ; $5F88
    jr nz, jr_004_5f3d                            ; $5F89

    ret                                           ; $5F8B


; C: A released: blits the stamp into the picture and sets dirty_flag
Stamp_Commit::
    ldh a, [hKeysReleased]                        ; $5F8C
    bit PADB_A, a                                 ; $5F8E
    ret z                                         ; $5F90

    ld a, $b4                                     ; $5F91
    ld [wStampRotateTimer], a                     ; $5F93
    play_sfx4 SFX4_STAMP_COMMIT                   ; $5F96
    ld [wDirtyFlag], a                            ; $5F9D
    ld a, [wCursorX]                              ; $5FA0
    add $10                                       ; $5FA3
    ld b, a                                       ; $5FA5
    ld a, [wCursorY]                              ; $5FA6
    add $10                                       ; $5FA9
    ld c, a                                       ; $5FAB
    ld a, [wCategoryIndex]                        ; $5FAC
    sla a                                         ; $5FAF
    ld e, a                                       ; $5FB1
    ld d, $00                                     ; $5FB2
    ld hl, Stamp_Commit_Tbl564B                   ; $5FB4
    add hl, de                                    ; $5FB7
    ld a, [hl+]                                   ; $5FB8
    ld h, [hl]                                    ; $5FB9
    ld l, a                                       ; $5FBA
    call Blit_SpriteToBg                          ; $5FBB
    ret                                           ; $5FBE


; C: sound $12 and window slide with Slide_WyDeltaTbl
Stamp_PaletteSlideIn::
    play_sfx1 SFX1_PANEL_OPEN                     ; $5FBF
    ld hl, Slide_WyDeltaTbl                       ; $5FC6
    ld b, $24                                     ; $5FC9

jr_004_5fcb:
    push bc                                       ; $5FCB
    push hl                                       ; $5FCC
    ldh a, [hWyShadow]                            ; $5FCD
    add [hl]                                      ; $5FCF
    ldh [hWyShadow], a                            ; $5FD0
    rst Rst08_WaitVBlank                          ; $5FD2
    pop hl                                        ; $5FD3
    pop bc                                        ; $5FD4
    inc hl                                        ; $5FD5
    dec b                                         ; $5FD6
    jr nz, jr_004_5fcb                            ; $5FD7

    ret                                           ; $5FD9


; C: sound $13 and window slide back
Stamp_PaletteSlideOut::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $5FDA
    ld hl, Slide_WyDeltaTbl                       ; $5FE1
    ld b, $24                                     ; $5FE4

jr_004_5fe6:
    push bc                                       ; $5FE6
    push hl                                       ; $5FE7
    ldh a, [hWyShadow]                            ; $5FE8
    sub [hl]                                      ; $5FEA
    ldh [hWyShadow], a                            ; $5FEB
    rst Rst08_WaitVBlank                          ; $5FED
    pop hl                                        ; $5FEE
    pop bc                                        ; $5FEF
    inc hl                                        ; $5FF0
    dec b                                         ; $5FF1
    jr nz, jr_004_5fe6                            ; $5FF2

    ret                                           ; $5FF4


; C: mode 10: PAINT tool
Mode10_Paint::
    ld a, [wState]                                ; $5FF5
    rst Rst18_JumpTable                           ; $5FF8

; I: 11 states, rst $18 table of mode $10
Mode10_StateTable::
    dw Mode10_State00_Init
    dw Mode10_State01_PickPhoto
    dw Mode10_State02_Setup
    dw Mode10_State03_Draw
    dw Mode10_State04_MenuSize
    dw Mode10_State05_MenuPattern
    dw Mode10_State06_MenuSpeed
    dw Mode10_State07_Leave
    dw Mode10_State08_SaveInit
    dw Mode10_State09_SaveDialog
    dw Mode10_State0A_SaveResult

; C
Mode10_State00_Init::
    ld a, $00                                     ; $600F
    ld [wMsgStripSel], a                          ; $6011
    ld a, $05                                     ; $6014
    ld [wIconSel], a                              ; $6016
    xor a                                         ; $6019
    ld [wSubstate], a                             ; $601A
    ld [wCallerCode], a                           ; $601D
    ld [wStockNavAllowed], a                      ; $6020
    next_state                                    ; $6023
    ret                                           ; $6027


; C: far call to the photo grid picker
Mode10_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $6028
    ld a, $04                                     ; $602A
    ld hl, PhotoPicker_Far                        ; $602C
    call Far_Call                                 ; $602F
    ret                                           ; $6032


; C: loads the paint screen
Mode10_State02_Setup::
    ld a, [wAbResult]                             ; $6033
    bit 0, a                                      ; $6036
    jr nz, jr_004_6045                            ; $6038

    ld a, MODE_DOODLE_MENU                        ; $603A
    ld [wMode], a                                 ; $603C
    set_state STATE_04_INIT                       ; $603F
    ret                                           ; $6044


jr_004_6045:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $6045
    ldh [hLcdcShadow], a                          ; $6047
    ld a, $e4                                     ; $6049
    ld [wPaletteTarget], a                        ; $604B
    ld [wPaletteTarget + $1], a                   ; $604E
    ld a, $d2                                     ; $6051
    ld [wPaletteTarget + $2], a                   ; $6053
    ld a, $10                                     ; $6056
    ldh [hScxShadow], a                           ; $6058
    ldh [hScyShadow], a                           ; $605A
    ld a, $07                                     ; $605C
    ldh [hWxShadow], a                            ; $605E
    ld a, $95                                     ; $6060
    ldh [hWyShadow], a                            ; $6062
    ld a, $40                                     ; $6064
    ld [wCursorX], a                              ; $6066
    ld a, $38                                     ; $6069
    ld [wCursorY], a                              ; $606B
    xor a                                         ; $606E
    ld [wCursorXFrac], a                          ; $606F
    ld [wCursorYFrac], a                          ; $6072
    ld [wCursorVx], a                             ; $6075
    ld [wCursorVy], a                             ; $6078
    ld [wPenMenuRow], a                           ; $607B
    ld a, $38                                     ; $607E
    ld [wPenRampIndex], a                         ; $6080
    farcopy Mem_CopyFromBank, Gfx_14_7E30_Mode10_State02_Setup, $8900, $00d0 ; $6083
    farcopy Mem_CopyFromBank, Gfx_14_7430_Mode10_State02_Setup, $8e30, $01d0 ; $6091
    farcopy Mem_CopyFromBank, Gfx_14_7F00_Mode10_State02_Setup, $8500, $00a0 ; $609F
    farcopy Mem_CopyFromBank, Map_24_7120_Mode10_State02_Setup, $9800, $02c0 ; $60AD
    ld a, [wDoodleFromShutterbug]                 ; $60BB
    and a                                         ; $60BE
    jr nz, jr_004_60d3                            ; $60BF

    ld a, [wPhotoIndex]                           ; $60C1
    ld [wCopyPhotoIdxF], a                        ; $60C4
    ldh [hFarcallAArg], a                         ; $60C7
    farcall Photo_LoadToVram_Far                  ; $60C9
    jr jr_004_6107                                ; $60D1

jr_004_60d3:
    ldh [hFarcallAArg], a                         ; $60D3
    farcall GameFace_Load_Far                     ; $60D5
    ld a, $00                                     ; $60DD
    ld hl, wPhotoImage                            ; $60DF
    ld de, $9000                                  ; $60E2
    ld bc, $0800                                  ; $60E5
    call Mem_CopyFromBank                         ; $60E8
    ld a, $00                                     ; $60EB
    ld hl, wPhotoImage + $800                     ; $60ED
    ld de, $8800                                  ; $60F0
    ld bc, $0100                                  ; $60F3
    call Mem_CopyFromBank                         ; $60F6
    ld a, $00                                     ; $60F9
    ld hl, wPhotoImage + $900                     ; $60FB
    ld de, $8000                                  ; $60FE
    ld bc, $0500                                  ; $6101
    call Mem_CopyFromBank                         ; $6104

jr_004_6107:
    xor a                                         ; $6107
    ld [wDirtyFlag], a                            ; $6108
    ld a, $54                                     ; $610B
    ldh [hLycShadowSplit1], a                     ; $610D
    ldh [hSplit1Latch], a                         ; $610F
    ld hl, hStatShadow                            ; $6111
    set 6, [hl]                                   ; $6114
    ld hl, rIE                                    ; $6116
    set 1, [hl]                                   ; $6119
    ld a, $01                                     ; $611B
    ldh [hStatHandlerIndex], a                    ; $611D
    screen_on                                     ; $611F
    play_music MUSIC_PAINT                        ; $6128
    call Pal_FadeIn                               ; $612F
    next_state                                    ; $6132
    ret                                           ; $6136


; C: pen moves; A draws; Start opens the pen menu
Mode10_State03_Draw::
    call Pen_Update                               ; $6137
    call Pen_DrawCursor                           ; $613A
    call Pen_Draw                                 ; $613D
    ldh a, [hKeysHeld]                            ; $6140
    ld hl, wEdgeDir                               ; $6142
    and [hl]                                      ; $6145
    jr nz, jr_004_614b                            ; $6146

    ld [wEdgeCount], a                            ; $6148

jr_004_614b:
    ldh a, [hKeysNew]                             ; $614B
    bit PADB_START, a                             ; $614D
    jr nz, jr_004_6162                            ; $614F

    ld a, [wEdgeDir]                              ; $6151
    and a                                         ; $6154
    jr z, jr_004_616a                             ; $6155

    ld a, [wEdgeCount]                            ; $6157
    inc a                                         ; $615A
    ld [wEdgeCount], a                            ; $615B
    cp $0a                                        ; $615E
    jr c, jr_004_616a                             ; $6160

jr_004_6162:
    call Oam_ClearShadow                          ; $6162
    rst Rst08_WaitVBlank                          ; $6165
    call PenMenu_SlideClose                       ; $6166
    ret                                           ; $6169


jr_004_616a:
    ldh a, [hKeysNew]                             ; $616A
    bit PADB_B, a                                 ; $616C
    ret z                                         ; $616E

    ld a, [wDirtyFlag]                            ; $616F
    and a                                         ; $6172
    jr nz, jr_004_6182                            ; $6173

    play_sfx1 SFX1_KEY_B                          ; $6175
    set_state STATE_10_LEAVE                      ; $617C
    ret                                           ; $6181


jr_004_6182:
    set_state STATE_10_SAVE_INIT                  ; $6182
    ret                                           ; $6187


; C: pen menu: size
Mode10_State04_MenuSize::
    call PenMenu_Input                            ; $6188
    call PenMenu_DrawCursor                       ; $618B
    ldh a, [hKeysNew]                             ; $618E
    bit PADB_A, a                                 ; $6190
    jr z, jr_004_61b1                             ; $6192

    ld a, [wPenMenuFocus]                         ; $6194
    and a                                         ; $6197
    ret nz                                        ; $6198

    play_sfx1 SFX1_KEY_A                          ; $6199
    ld a, [wPenMenuItem]                          ; $61A0
    ld [wPenSize], a                              ; $61A3
    call PenMenu_BuildSize                        ; $61A6
    ld bc, $0014                                  ; $61A9
    call Wait_Frames                              ; $61AC
    jr jr_004_61b4                                ; $61AF

jr_004_61b1:
    bit 1, a                                      ; $61B1
    ret z                                         ; $61B3

jr_004_61b4:
    call PenMenu_SlideOpen                        ; $61B4
    set_state STATE_10_DRAW                       ; $61B7
    ret                                           ; $61BC


; C: pen menu: pattern
Mode10_State05_MenuPattern::
    call PenMenu_Input                            ; $61BD
    call PenMenu_DrawCursor                       ; $61C0
    ldh a, [hKeysNew]                             ; $61C3
    bit PADB_A, a                                 ; $61C5
    jr z, jr_004_61e6                             ; $61C7

    ld a, [wPenMenuFocus]                         ; $61C9
    and a                                         ; $61CC
    ret nz                                        ; $61CD

    play_sfx1 SFX1_KEY_A                          ; $61CE
    ld a, [wPenMenuItem]                          ; $61D5
    ld [wPenPattern], a                           ; $61D8
    call PenMenu_BuildPattern                     ; $61DB
    ld bc, $0014                                  ; $61DE
    call Wait_Frames                              ; $61E1
    jr jr_004_61e9                                ; $61E4

jr_004_61e6:
    bit 1, a                                      ; $61E6
    ret z                                         ; $61E8

jr_004_61e9:
    call PenMenu_SlideOpen                        ; $61E9
    set_state STATE_10_DRAW                       ; $61EC
    ret                                           ; $61F1


; C: pen menu: speed
Mode10_State06_MenuSpeed::
    call PenMenu_Input                            ; $61F2
    call PenMenu_DrawCursor                       ; $61F5
    ldh a, [hKeysNew]                             ; $61F8
    bit PADB_A, a                                 ; $61FA
    jr z, jr_004_621b                             ; $61FC

    ld a, [wPenMenuFocus]                         ; $61FE
    and a                                         ; $6201
    ret nz                                        ; $6202

    play_sfx1 SFX1_KEY_A                          ; $6203
    ld a, [wPenMenuItem]                          ; $620A
    ld [wPenSpeed], a                             ; $620D
    call PenMenu_BuildSpeed                       ; $6210
    ld bc, $0014                                  ; $6213
    call Wait_Frames                              ; $6216
    jr jr_004_621e                                ; $6219

jr_004_621b:
    bit 1, a                                      ; $621B
    ret z                                         ; $621D

jr_004_621e:
    call PenMenu_SlideOpen                        ; $621E
    set_state STATE_10_DRAW                       ; $6221
    ret                                           ; $6226


; C: D-pad changes the item or the row
PenMenu_Input::
    ld a, [wPenMenuFocus]                         ; $6227
    and a                                         ; $622A
    jr nz, jr_004_6266                            ; $622B

    ld a, [wPenMenuPage]                          ; $622D
    ld c, a                                       ; $6230
    ld b, $00                                     ; $6231
    ld hl, PenMenu_ItemCountTbl                   ; $6233
    add hl, bc                                    ; $6236
    ld c, [hl]                                    ; $6237
    ldh a, [hKeysNewRepeat]                       ; $6238
    ld b, a                                       ; $623A
    ld a, [wPenMenuItem]                          ; $623B
    bit 5, b                                      ; $623E
    jr z, jr_004_624e                             ; $6240

    and a                                         ; $6242
    ret z                                         ; $6243

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6244
    dec a                                         ; $624B
    jr jr_004_625c                                ; $624C

jr_004_624e:
    bit 4, b                                      ; $624E
    ret z                                         ; $6250

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6251
    cp c                                          ; $6258
    jr z, jr_004_6260                             ; $6259

    inc a                                         ; $625B

jr_004_625c:
    ld [wPenMenuItem], a                          ; $625C
    ret                                           ; $625F


jr_004_6260:
    ld a, $01                                     ; $6260
    ld [wPenMenuFocus], a                         ; $6262
    ret                                           ; $6265


jr_004_6266:
    ldh a, [hKeysNewRepeat]                       ; $6266
    ld b, a                                       ; $6268
    ld a, [wPenMenuRow]                           ; $6269
    bit 5, b                                      ; $626C
    jr z, jr_004_628a                             ; $626E

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6270
    xor a                                         ; $6277
    ld [wPenMenuFocus], a                         ; $6278
    ld a, [wPenMenuPage]                          ; $627B
    ld c, a                                       ; $627E
    ld b, $00                                     ; $627F
    ld hl, PenMenu_ItemCountTbl                   ; $6281
    add hl, bc                                    ; $6284
    ld a, [hl]                                    ; $6285
    ld [wPenMenuItem], a                          ; $6286
    ret                                           ; $6289


jr_004_628a:
    bit 6, b                                      ; $628A
    jr z, jr_004_629a                             ; $628C

    and a                                         ; $628E
    ret z                                         ; $628F

    play_sfx1 SFX1_CURSOR_MOVE                    ; $6290
    dec a                                         ; $6297
    jr jr_004_62a8                                ; $6298

jr_004_629a:
    bit 7, b                                      ; $629A
    ret z                                         ; $629C

    cp $02                                        ; $629D
    ret z                                         ; $629F

    play_sfx1 SFX1_CURSOR_MOVE                    ; $62A0
    inc a                                         ; $62A7

jr_004_62a8:
    ld [wPenMenuRow], a                           ; $62A8
    call Oam_ClearShadow                          ; $62AB
    rst Rst08_WaitVBlank                          ; $62AE
    call PenMenu_Build                            ; $62AF
    ret                                           ; $62B2


; C: items per row 3 / 3 / 2
PenMenu_ItemCountTbl::
    db $03, $03, $02

; C: blinking cursor on the current item
PenMenu_DrawCursor::
    ld a, [wPenMenuFocus]                         ; $62B6
    and a                                         ; $62B9
    jr nz, jr_004_62eb                            ; $62BA

    ld a, [wPenMenuPage]                          ; $62BC
    ld c, a                                       ; $62BF
    ld b, $00                                     ; $62C0
    ld hl, PenMenu_CursorPosTbl                   ; $62C2
    add hl, bc                                    ; $62C5
    ld c, [hl]                                    ; $62C6
    add hl, bc                                    ; $62C7
    ld a, [wPenMenuItem]                          ; $62C8
    sla a                                         ; $62CB
    ld c, a                                       ; $62CD
    add hl, bc                                    ; $62CE
    ld c, [hl]                                    ; $62CF
    inc hl                                        ; $62D0
    ld b, [hl]                                    ; $62D1
    ld a, [wPenMenuPage]                          ; $62D2
    ld e, a                                       ; $62D5
    ld d, $00                                     ; $62D6
    ld hl, PenMenu_DrawCursor_Tbl630F             ; $62D8
    add hl, de                                    ; $62DB
    ldh a, [hFrameCounter]                        ; $62DC
    srl a                                         ; $62DE
    srl a                                         ; $62E0
    srl a                                         ; $62E2
    and $01                                       ; $62E4
    add [hl]                                      ; $62E6
    call Oam_AddMeta_B01_4000                     ; $62E7
    ret                                           ; $62EA


jr_004_62eb:
    ldh a, [hFrameCounter]                        ; $62EB
    srl a                                         ; $62ED
    srl a                                         ; $62EF
    srl a                                         ; $62F1
    and $01                                       ; $62F3
    add $25                                       ; $62F5
    ld bc, $8864                                  ; $62F7
    call Oam_AddMeta_B01_4000                     ; $62FA
    ret                                           ; $62FD


; C: L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_CursorPosTbl::
    db $03, $02, $09, $5b, $14, $5b, $2d, $5b, $45, $5b, $5e, $58, $1d, $58, $3b, $58
    db $5e

; C: auto: 3 bytes, bytes; referenced by PenMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_DrawCursor_Tbl630F::
    db $23, $23, $29

; C: returns to mode 04 or the extras caller
Mode10_State07_Leave::
    screen_off                                    ; $6312
    stat_irq_off                                  ; $6318
    ld a, [wDoodleFromShutterbug]                 ; $6322
    and a                                         ; $6325
    jr z, jr_004_6333                             ; $6326

    ld a, MODE_DOODLE_MENU                        ; $6328
    ld [wMode], a                                 ; $632A
    set_state STATE_04_INIT                       ; $632D
    ret                                           ; $6332


jr_004_6333:
    ld a, [wCallerCode]                           ; $6333
    and a                                         ; $6336
    jr nz, jr_004_633f                            ; $6337

    set_state STATE_10_INIT                       ; $6339
    ret                                           ; $633E


jr_004_633f:
    cp $01                                        ; $633F
    jr nz, jr_004_634e                            ; $6341

    ld a, MODE_ALBUM_EDIT                         ; $6343
    ld [wMode], a                                 ; $6345
    set_state STATE_09_INIT                       ; $6348
    ret                                           ; $634D


jr_004_634e:
    ld a, $01                                     ; $634E
    ld [wAbResult], a                             ; $6350
    ld a, MODE_ALBUM_VIEW                         ; $6353
    ld [wMode], a                                 ; $6355
    set_state STATE_0A_SETUP                      ; $6358
    ret                                           ; $635D


; C: save dialog id 1 and the target photo
Mode10_State08_SaveInit::
    ld a, $95                                     ; $635E
    ldh [hWyShadow], a                            ; $6360
    ld a, $07                                     ; $6362
    ldh [hWxShadow], a                            ; $6364
    ld hl, hLcdcShadow                            ; $6366
    set 5, [hl]                                   ; $6369
    call Oam_ClearShadow                          ; $636B
    ld a, $01                                     ; $636E
    ld [wSaveDialogWhat], a                       ; $6370
    ld a, [wCopyPhotoIdxF]                        ; $6373
    ld [wSaveTargetPhoto], a                      ; $6376
    xor a                                         ; $6379
    ld [wSubstate], a                             ; $637A
    next_state                                    ; $637D
    ret                                           ; $6381


; C: far call 07:699C
Mode10_State09_SaveDialog::
    ldh [hFarcallAArg], a                         ; $6382
    farcall SaveDialog_Far                        ; $6384
    ret                                           ; $638C


; C
Mode10_State0A_SaveResult::
    ld a, [wSaveDialogResult]                     ; $638D
    and a                                         ; $6390
    jr nz, jr_004_6399                            ; $6391

    set_state STATE_10_LEAVE                      ; $6393
    ret                                           ; $6398


jr_004_6399:
    farcopy Vram_CopyFromBank, Gfx_14_7430_Mode10_State02_Setup, $8e30, $01d0 ; $6399
    set_state STATE_10_DRAW                       ; $63A7
    ret                                           ; $63AC


; I: dead code: copies the tilemap 24:7120 to $9800 (UNREFERENCED, README 16.15)
Unused_LoadTilemap24_7120::
    farcopy Vram_CopyFromBank, Map_24_7120_Mode10_State02_Setup, $9800, $02c0 ; $63AD
    ret                                           ; $63BB


; I: dead code: copies the tilemap 25:4B00 to $9800 (UNREFERENCED, README 16.15)
Unused_LoadTilemap25_4B00::
    farcopy Vram_CopyFromBank, BgMap_25_4B00, $9800, $02c0 ; $63BC
    ret                                           ; $63CA


; C: pen cursor sprite by size with a 16-frame blink
Pen_DrawCursor::
    ld a, [wPenSize]                              ; $63CB
    sla a                                         ; $63CE
    ld c, a                                       ; $63D0
    ldh a, [hFrameCounter]                        ; $63D1
    srl a                                         ; $63D3
    srl a                                         ; $63D5
    srl a                                         ; $63D7
    and $01                                       ; $63D9
    add c                                         ; $63DB
    ld c, a                                       ; $63DC
    ld b, $00                                     ; $63DD
    ld hl, Pen_CursorSpriteTbl                    ; $63DF
    add hl, bc                                    ; $63E2
    ld a, [hl]                                    ; $63E3
    push af                                       ; $63E4
    ld a, [wCursorX]                              ; $63E5
    add $10                                       ; $63E8
    ld b, a                                       ; $63EA
    ld a, [wCursorY]                              ; $63EB
    add $10                                       ; $63EE
    ld c, a                                       ; $63F0
    pop af                                        ; $63F1
    call Oam_AddMeta_B01_4000                     ; $63F2
    ret                                           ; $63F5


; C: L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_CursorSpriteTbl::
    db $2b, $2c, $2d, $2e, $2f, $30, $31, $32

; I: cursor movement with acceleration ramp, edge counting and the pen speed
Pen_Update::
    ld a, [wPenSpeed]                             ; $63FE
    cp $02                                        ; $6401
    jr nz, jr_004_640c                            ; $6403

    ldh a, [hFrameCounter]                        ; $6405
    and $03                                       ; $6407
    ret nz                                        ; $6409

    jr jr_004_6415                                ; $640A

jr_004_640c:
    cp $01                                        ; $640C
    jr c, jr_004_6415                             ; $640E

    ldh a, [hFrameCounter]                        ; $6410
    and $01                                       ; $6412
    ret nz                                        ; $6414

jr_004_6415:
    xor a                                         ; $6415
    ld [wEdgeDir], a                              ; $6416
    ld a, [wPenRampIndex]                         ; $6419
    sla a                                         ; $641C
    ld c, a                                       ; $641E
    ld b, $00                                     ; $641F
    ld hl, Pen_Update_Tbl6538                     ; $6421
    add hl, bc                                    ; $6424
    ld c, [hl]                                    ; $6425
    inc hl                                        ; $6426
    ld b, [hl]                                    ; $6427
    ldh a, [hKeysHeld]                            ; $6428
    ld [wPenKeys], a                              ; $642A
    ld hl, wCursorVx                              ; $642D
    ld a, [wPenKeys]                              ; $6430
    and $30                                       ; $6433
    swap a                                        ; $6435
    ld e, $02                                     ; $6437

jr_004_6439:
    bit 1, a                                      ; $6439
    jr z, jr_004_644e                             ; $643B

    ld a, [hl]                                    ; $643D
    sub b                                         ; $643E
    ld [hl+], a                                   ; $643F
    ld a, [hl]                                    ; $6440
    sbc $00                                       ; $6441
    ld [hl], a                                    ; $6443
    cp $fe                                        ; $6444
    jr nz, jr_004_648d                            ; $6446

    inc a                                         ; $6448
    ld [hl-], a                                   ; $6449
    xor a                                         ; $644A
    ld [hl], a                                    ; $644B
    jr jr_004_648d                                ; $644C

jr_004_644e:
    bit 0, a                                      ; $644E
    jr z, jr_004_6463                             ; $6450

    ld a, [hl]                                    ; $6452
    add b                                         ; $6453
    ld [hl+], a                                   ; $6454
    ld a, [hl]                                    ; $6455
    adc $00                                       ; $6456
    ld [hl], a                                    ; $6458
    cp $01                                        ; $6459
    jr nz, jr_004_648d                            ; $645B

    xor a                                         ; $645D
    ld [hl-], a                                   ; $645E
    dec a                                         ; $645F
    ld [hl], a                                    ; $6460
    jr jr_004_648d                                ; $6461

jr_004_6463:
    push de                                       ; $6463
    ld e, [hl]                                    ; $6464
    inc hl                                        ; $6465
    ld d, [hl]                                    ; $6466
    ld a, d                                       ; $6467
    and a                                         ; $6468
    push af                                       ; $6469
    jr z, jr_004_6473                             ; $646A

    ld a, e                                       ; $646C
    cpl                                           ; $646D
    ld e, a                                       ; $646E
    ld a, d                                       ; $646F
    cpl                                           ; $6470
    ld d, a                                       ; $6471
    inc de                                        ; $6472

jr_004_6473:
    ld a, e                                       ; $6473
    sub c                                         ; $6474
    ld e, a                                       ; $6475
    ld a, d                                       ; $6476
    sbc $00                                       ; $6477
    ld d, a                                       ; $6479
    jr nc, jr_004_647f                            ; $647A

    ld de, $0000                                  ; $647C

jr_004_647f:
    pop af                                        ; $647F
    jr z, jr_004_6489                             ; $6480

    ld a, e                                       ; $6482
    cpl                                           ; $6483
    ld e, a                                       ; $6484
    ld a, d                                       ; $6485
    cpl                                           ; $6486
    ld d, a                                       ; $6487
    inc de                                        ; $6488

jr_004_6489:
    ld [hl], d                                    ; $6489
    dec hl                                        ; $648A
    ld [hl], e                                    ; $648B
    pop de                                        ; $648C

jr_004_648d:
    ld hl, wCursorVy                              ; $648D
    ld a, [wPenKeys]                              ; $6490
    and $c0                                       ; $6493
    sla a                                         ; $6495
    rr d                                          ; $6497
    rlca                                          ; $6499
    sla d                                         ; $649A
    rla                                           ; $649C
    dec e                                         ; $649D
    jr nz, jr_004_6439                            ; $649E

    ldh a, [hKeysHeld]                            ; $64A0
    and PADF_DPAD                                 ; $64A2
    jr z, jr_004_64ad                             ; $64A4

    ld a, $03                                     ; $64A6
    ld [wPenIdleTimer], a                         ; $64A8
    jr jr_004_64c1                                ; $64AB

jr_004_64ad:
    ld a, [wPenIdleTimer]                         ; $64AD
    and a                                         ; $64B0
    jr z, jr_004_64b9                             ; $64B1

    dec a                                         ; $64B3
    ld [wPenIdleTimer], a                         ; $64B4
    jr jr_004_64c1                                ; $64B7

jr_004_64b9:
    xor a                                         ; $64B9
    ld hl, wCursorVx                              ; $64BA
    ld [hl+], a                                   ; $64BD
    ld [hl+], a                                   ; $64BE
    ld [hl+], a                                   ; $64BF
    ld [hl], a                                    ; $64C0

jr_004_64c1:
    ld hl, wCursorXFrac                           ; $64C1
    ld a, [wCursorVx + $1]                        ; $64C4
    ld d, a                                       ; $64C7
    ld a, [wCursorVx]                             ; $64C8
    ld e, a                                       ; $64CB
    ld c, $02                                     ; $64CC

jr_004_64ce:
    ld a, [hl]                                    ; $64CE
    add e                                         ; $64CF
    ld [hl+], a                                   ; $64D0
    ld a, [hl]                                    ; $64D1
    adc d                                         ; $64D2
    ld [hl], a                                    ; $64D3
    ld hl, wCursorYFrac                           ; $64D4
    ld a, [wCursorVy + $1]                        ; $64D7
    ld d, a                                       ; $64DA
    ld a, [wCursorVy]                             ; $64DB
    ld e, a                                       ; $64DE
    dec c                                         ; $64DF
    jr nz, jr_004_64ce                            ; $64E0

    ld a, [wPenSize]                              ; $64E2
    sla a                                         ; $64E5
    sla a                                         ; $64E7
    ld c, a                                       ; $64E9
    ld b, $00                                     ; $64EA
    ld hl, Pen_Update_Tbl6528                     ; $64EC
    add hl, bc                                    ; $64EF
    ld de, wCursorX                               ; $64F0
    ld a, $30                                     ; $64F3
    ldh [hScratchA], a                            ; $64F5
    ld b, $02                                     ; $64F7

jr_004_64f9:
    push hl                                       ; $64F9
    ld a, [de]                                    ; $64FA
    cp $c0                                        ; $64FB
    jr c, jr_004_650c                             ; $64FD

    cp [hl]                                       ; $64FF
    jr nc, jr_004_651a                            ; $6500

    ldh a, [hScratchA]                            ; $6502
    and $60                                       ; $6504
    ld [wEdgeDir], a                              ; $6506
    ld a, [hl]                                    ; $6509
    jr jr_004_651a                                ; $650A

jr_004_650c:
    inc hl                                        ; $650C
    cp [hl]                                       ; $650D
    jr c, jr_004_651a                             ; $650E

    jr z, jr_004_651a                             ; $6510

    ldh a, [hScratchA]                            ; $6512
    and $90                                       ; $6514
    ld [wEdgeDir], a                              ; $6516
    ld a, [hl]                                    ; $6519

jr_004_651a:
    pop hl                                        ; $651A
    ld [de], a                                    ; $651B
    ld a, $c0                                     ; $651C
    ldh [hScratchA], a                            ; $651E
    inc hl                                        ; $6520
    inc hl                                        ; $6521
    inc de                                        ; $6522
    inc de                                        ; $6523
    dec b                                         ; $6524
    jr nz, jr_004_64f9                            ; $6525

    ret                                           ; $6527


; C: auto: 16 bytes, bytes; referenced by Pen_Update. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Update_Tbl6528::
    db $ff, $81, $ff, $71, $ff, $81, $ff, $71, $fd, $82, $fd, $72, $fc, $84, $fc, $74

; C: auto: 114 bytes, bytes; referenced by Pen_Update. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Update_Tbl6538::
    db $ff, $ff, $bc, $bf, $ab, $af, $9f, $a4, $95, $9a, $8d, $93, $86, $8c, $80, $86
    db $7a, $80, $74, $7b, $6f, $77, $6b, $72, $67, $6e, $62, $6a, $5e, $66, $5b, $63
    db $57, $60, $54, $5c, $51, $59, $4d, $56, $4a, $53, $47, $50, $44, $4e, $42, $4b
    db $3f, $49, $3c, $46, $3a, $44, $37, $41, $35, $3f, $33, $3d, $30, $3b, $2e, $38
    db $2c, $36, $2a, $34, $27, $32, $25, $30, $23, $2e, $21, $2c, $1f, $2a, $1d, $29
    db $1b, $27, $1a, $25, $18, $23, $16, $22, $14, $20, $12, $1e, $11, $1d, $0f, $1b
    db $0d, $19, $0c, $18, $0a, $16, $08, $15, $07, $13, $05, $12, $04, $10, $02, $0f
    db $01, $0d

; C: A held: blits the pen pattern into the picture; sound every 32 frames
Pen_Draw::
    ldh a, [hKeysHeld]                            ; $65AA
    bit PADB_A, a                                 ; $65AC
    ret z                                         ; $65AE

    ldh a, [hFrameCounter]                        ; $65AF
    and $1f                                       ; $65B1
    jr nz, jr_004_65bc                            ; $65B3

    play_sfx1 SFX1_KEY_A                          ; $65B5

jr_004_65bc:
    ld a, $01                                     ; $65BC
    ld [wDirtyFlag], a                            ; $65BE
    ld a, [wPenSize]                              ; $65C1
    sla a                                         ; $65C4
    ld c, a                                       ; $65C6
    ld b, $00                                     ; $65C7
    ld hl, Pen_Draw_Tbl65F4                       ; $65C9
    add hl, bc                                    ; $65CC
    ld a, [wCursorX]                              ; $65CD
    add [hl]                                      ; $65D0
    add $10                                       ; $65D1
    ld b, a                                       ; $65D3
    inc hl                                        ; $65D4
    ld a, [wCursorY]                              ; $65D5
    add [hl]                                      ; $65D8
    add $10                                       ; $65D9
    ld c, a                                       ; $65DB
    ld hl, wPenPattern                            ; $65DC
    ld a, [wPenSize]                              ; $65DF
    sla a                                         ; $65E2
    sla a                                         ; $65E4
    add [hl]                                      ; $65E6
    ld e, a                                       ; $65E7
    ld d, $00                                     ; $65E8
    ld hl, Pen_Draw_Tbl65FC                       ; $65EA
    add hl, de                                    ; $65ED
    ld e, [hl]                                    ; $65EE
    add hl, de                                    ; $65EF
    call Blit_SpriteToBg                          ; $65F0
    ret                                           ; $65F3


; C: auto: 8 bytes, bytes; referenced by Pen_Draw. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Draw_Tbl65F4::
    db $00, $00, $00, $00, $fe, $fe, $fc, $fc

; I: auto: 108 bytes, bytes; referenced by Pen_Draw. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Draw_Tbl65FC::
    db $10, $14, $18, $1c, $23, $27, $2b, $2f, $36, $3a, $3e, $42, $49, $4d, $51, $55
    db $88, $08
    dw TileSet_27_5810 + $20
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $10
    db BANK(TileSet_27_5810)
    db $88, $08
    dwb TileSet_27_5810
    db $08, $08
    dw TileSet_27_5810 + $30
    db BANK(TileSet_27_5810)
    dw Src_19_7E60_Tbl53A6_4 + $180
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_5810 + $60
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $50
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $40
    db BANK(TileSet_27_5810)
    db $08, $08
    dw TileSet_27_5810 + $70
    db BANK(TileSet_27_5810)
    dw Src_19_7E60_Tbl53A6_4 + $188
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_5810 + $A0
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $90
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $80
    db BANK(TileSet_27_5810)
    db $08, $08
    dw TileSet_27_5810 + $B0
    db BANK(TileSet_27_5810)
    dw Src_19_7E60_Tbl53A6_4 + $190
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_5810 + $E0
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $D0
    db BANK(TileSet_27_5810)
    db $88, $08
    dw TileSet_27_5810 + $C0
    db BANK(TileSet_27_5810)
    db $08, $08
    dw TileSet_27_5810 + $F0
    db BANK(TileSet_27_5810)
    dw Src_19_7E60_Tbl53A6_4 + $198
    db BANK(Src_19_7E60_Tbl53A6_4)

; C: sound $12 and window slide
PenMenu_SlideOpen::
    play_sfx1 SFX1_PANEL_OPEN                     ; $6668
    call Oam_ClearShadow                          ; $666F
    rst Rst08_WaitVBlank                          ; $6672
    ld hl, Slide_WyDeltaTbl                       ; $6673
    ld b, $24                                     ; $6676

jr_004_6678:
    push bc                                       ; $6678
    push hl                                       ; $6679
    ldh a, [hWyShadow]                            ; $667A
    add [hl]                                      ; $667C
    ldh [hWyShadow], a                            ; $667D
    rst Rst08_WaitVBlank                          ; $667F
    pop hl                                        ; $6680
    pop bc                                        ; $6681
    inc hl                                        ; $6682
    dec b                                         ; $6683
    jr nz, jr_004_6678                            ; $6684

    ret                                           ; $6686


; C: build the panel then sound $13 and slide back
PenMenu_SlideClose::
    call PenMenu_Build                            ; $6687
    play_sfx1 SFX1_PANEL_CLOSE                    ; $668A
    ld hl, Slide_WyDeltaTbl                       ; $6691
    ld b, $24                                     ; $6694

jr_004_6696:
    push bc                                       ; $6696
    push hl                                       ; $6697
    ldh a, [hWyShadow]                            ; $6698
    sub [hl]                                      ; $669A
    ldh [hWyShadow], a                            ; $669B
    rst Rst08_WaitVBlank                          ; $669D
    pop hl                                        ; $669E
    pop bc                                        ; $669F
    inc hl                                        ; $66A0
    dec b                                         ; $66A1
    jr nz, jr_004_6696                            ; $66A2

    ret                                           ; $66A4


; C: loads the panel graphics and builds the page of the current row
PenMenu_Build::
    farcopy Vram_CopyFromBank, Gfx_14_75E0_PenMenu_Build, $8fe0, $0020 ; $66A5
    farcopy Vram_CopyFromBank, Map_24_7860_PenMenu_Build, $9c00, $0100 ; $66B3
    ld a, [wPenMenuRow]                           ; $66C1
    and a                                         ; $66C4
    jr nz, jr_004_66de                            ; $66C5

    farcopy Vram_CopyFromBank, Gfx_14_7A00_PenMenu_Build, $8a00, $0430 ; $66C7
    call PenMenu_BuildSize                        ; $66D5
    set_state STATE_10_MENU_SIZE                  ; $66D8
    ret                                           ; $66DD


jr_004_66de:
    cp $01                                        ; $66DE
    jr nz, jr_004_66f9                            ; $66E0

    farcopy Vram_CopyFromBank, Gfx_14_7600_PenMenu_Build, $8a00, $0400 ; $66E2
    call PenMenu_BuildPattern                     ; $66F0
    set_state STATE_10_MENU_PATTERN               ; $66F3
    ret                                           ; $66F8


jr_004_66f9:
    farcopy Vram_CopyFromBank, Gfx_14_7000_PenMenu_Build, $8a00, $0430 ; $66F9
    call PenMenu_BuildSpeed                       ; $6707
    set_state STATE_10_MENU_SPEED                 ; $670A
    ret                                           ; $670F


; C
PenMenu_BuildSize::
    farcopy Vram_CopyFromBank, Map_24_4B00_PenMenu_BuildSize, $9c00, $0020 ; $6710
    ld a, [wPenSize]                              ; $671E
    sla a                                         ; $6721
    ld c, a                                       ; $6723
    ld b, $00                                     ; $6724
    ld hl, PenMenu_BuildSize_PtrTbl6751           ; $6726
    add hl, bc                                    ; $6729
    ld a, [hl+]                                   ; $672A
    ld h, [hl]                                    ; $672B
    ld l, a                                       ; $672C
    ld a, $24                                     ; $672D
    ld de, $9c20                                  ; $672F
    ld bc, $00c0                                  ; $6732
    call Vram_CopyFromBank                        ; $6735
    farcopy Vram_CopyFromBank, Map_24_4BE0_PenMenu_BuildSize, $9ce0, $0020 ; $6738
    ld a, [wPenSize]                              ; $6746
    ld [wPenMenuItem], a                          ; $6749
    xor a                                         ; $674C
    ld [wPenMenuPage], a                          ; $674D
    ret                                           ; $6750


; C: auto: 8 bytes, word table; referenced by PenMenu_BuildSize. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildSize_PtrTbl6751::
    dw Map_24_4B20_PenMenuSizePanel0
    dw Map_24_4C00_PenMenuSizePanel1
    dw Map_24_4CC0_PenMenuSizePanel2
    dw Map_24_4D80_PenMenuSizePanel3

; C
PenMenu_BuildPattern::
    farcopy Vram_CopyFromBank, Map_24_4B00_PenMenu_BuildSize, $9c00, $0020 ; $6759
    ld a, [wPenPattern]                           ; $6767
    sla a                                         ; $676A
    ld c, a                                       ; $676C
    ld b, $00                                     ; $676D
    ld hl, PenMenu_BuildPattern_PtrTbl679B        ; $676F
    add hl, bc                                    ; $6772
    ld a, [hl+]                                   ; $6773
    ld h, [hl]                                    ; $6774
    ld l, a                                       ; $6775
    ld a, $24                                     ; $6776
    ld de, $9c20                                  ; $6778
    ld bc, $00c0                                  ; $677B
    call Vram_CopyFromBank                        ; $677E
    farcopy Vram_CopyFromBank, Map_24_4BE0_PenMenu_BuildSize, $9ce0, $0020 ; $6781
    ld a, [wPenPattern]                           ; $678F
    ld [wPenMenuItem], a                          ; $6792
    ld a, $01                                     ; $6795
    ld [wPenMenuPage], a                          ; $6797
    ret                                           ; $679A


; C: auto: 8 bytes, word table; referenced by PenMenu_BuildPattern. L3 pass 2026-10-26: read in BGB in 2 replay(s) of
; the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildPattern_PtrTbl679B::
    dw Map_24_4E60_PenMenuPatternPanel0
    dw Map_24_4F40_PenMenuPatternPanel1
    dw Map_24_5000_PenMenuPatternPanel2
    dw Map_24_50C0_PenMenuPatternPanel3

; C
PenMenu_BuildSpeed::
    farcopy Vram_CopyFromBank, Map_24_76A0_PenMenu_BuildSpeed, $9c00, $0020 ; $67A3
    ld a, [wPenSpeed]                             ; $67B1
    sla a                                         ; $67B4
    ld c, a                                       ; $67B6
    ld b, $00                                     ; $67B7
    ld hl, PenMenu_BuildSpeed_PtrTbl67E5          ; $67B9
    add hl, bc                                    ; $67BC
    ld a, [hl+]                                   ; $67BD
    ld h, [hl]                                    ; $67BE
    ld l, a                                       ; $67BF
    ld a, $24                                     ; $67C0
    ld de, $9c20                                  ; $67C2
    ld bc, $0060                                  ; $67C5
    call Vram_CopyFromBank                        ; $67C8
    farcopy Vram_CopyFromBank, Map_24_7720_PenMenu_BuildSpeed, $9c80, $0080 ; $67CB
    ld a, [wPenSpeed]                             ; $67D9
    ld [wPenMenuItem], a                          ; $67DC
    ld a, $02                                     ; $67DF
    ld [wPenMenuPage], a                          ; $67E1
    ret                                           ; $67E4


; C: auto: 6 bytes, word table; referenced by PenMenu_BuildSpeed. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildSpeed_PtrTbl67E5::
    dw Map_24_76C0_PenMenuSpeedPanel0
    dw Map_24_77A0_PenMenuSpeedPanel1
    dw Map_24_7800_PenMenuSpeedPanel2

; C: mode 09: album viewer with the edit pages (the guide's Album: Paint / Stamp / Frame / Comment / Print / Delete)
Mode09_AlbumEdit::
    ld a, [wState]                                ; $67EB
    rst Rst18_JumpTable                           ; $67EE

; I: 14 states, rst $18 table of mode $09
Mode09_StateTable::
    dw Mode09_State00_Init
    dw Mode09_State01_SliderBrowse
    dw Mode09_State02_PhotoArrows
    dw Mode09_State03_PageLeft
    dw Mode09_State04_PageRight
    dw Mode09_State05_PageUp
    dw Mode09_State06_PageDown
    dw Mode09_State07_LeaveToShoot
    dw Mode09_State08_FrameInit
    dw Mode09_State09_FrameEdit
    dw Mode09_State0A_FrameSave
    dw Mode09_State0B_CommentInit
    dw Mode09_State0C_CommentEdit
    dw Mode09_State0D_CommentSave

; C
Mode09_State00_Init::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $680B
    ldh [hLcdcShadow], a                          ; $680D
    ld a, $e4                                     ; $680F
    ld [wPaletteTarget], a                        ; $6811
    ld [wPaletteTarget + $1], a                   ; $6814
    ld a, $c6                                     ; $6817
    ld [wPaletteTarget + $2], a                   ; $6819
    ld a, $10                                     ; $681C
    ldh [hScxShadow], a                           ; $681E
    ldh [hScyShadow], a                           ; $6820
    xor a                                         ; $6822
    ld [wChoiceCursorA], a                        ; $6823
    ld [wChoiceCursorB], a                        ; $6826
    ld [wSliderRedraw], a                         ; $6829
    ld [wSliderTimer], a                          ; $682C
    farcopy Mem_CopyFromBank, Gfx_0C_7800_Mode09_State00_Init, $8900, $0300 ; $682F
    farcopy Mem_CopyFromBank, Gfx_0C_7B00_Mode09_State00_Init, $8500, $0300 ; $683D
    farcopy Mem_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $684B
    farcopy Mem_CopyFromBank, Gfx_0C_7FD0_Mode09_State00_Init, $8f70, $0030 ; $6859
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $6867
    ld hl, $9ac0                                  ; $6875
    ld bc, $0140                                  ; $6878
    ld a, $ff                                     ; $687B
    call Mem_FillBc1                              ; $687D
    ld a, [wPhotoNumberSel]                       ; $6880
    ldh [hFarcallAArg], a                         ; $6883
    farcall Photo_LoadToVram_Far                  ; $6885
    ld a, $54                                     ; $688D
    ldh [hLycShadowSplit1], a                     ; $688F
    ldh [hSplit1Latch], a                         ; $6891
    ld hl, hStatShadow                            ; $6893
    set 6, [hl]                                   ; $6896
    ld hl, rIE                                    ; $6898
    set 1, [hl]                                   ; $689B
    ld a, $01                                     ; $689D
    ldh [hStatHandlerIndex], a                    ; $689F
    screen_on                                     ; $68A1
    play_music MUSIC_ALBUM_VIEWER                 ; $68AA
    call Album_DrawPhotoNumber                    ; $68B1
    call Pal_FadeIn                               ; $68B4
    set_state STATE_09_SLIDER_BROWSE              ; $68B7
    ret                                           ; $68BC


; C: photo number slider at the bottom; Left / Right moves it
Mode09_State01_SliderBrowse::
    call Slider_Input                             ; $68BD
    call Slider_Update                            ; $68C0
    call Slider_DrawBar                           ; $68C3
    ld a, [wSliderRedraw]                         ; $68C6
    and a                                         ; $68C9
    jr z, jr_004_68ef                             ; $68CA

    call Oam_HideUnused                           ; $68CC
    ld a, [wPhotoNumberSel]                       ; $68CF
    ldh [hFarcallAArg], a                         ; $68D2
    farcall Photo_LoadToVram_Far                  ; $68D4
    call Album_DrawPhotoNumber                    ; $68DC
    ldh a, [hKeysHeld]                            ; $68DF
    bit PADB_A, a                                 ; $68E1
    jr nz, jr_004_68e5                            ; $68E3

jr_004_68e5:
    call Slider_Update                            ; $68E5
    call Slider_DrawBar                           ; $68E8
    xor a                                         ; $68EB
    ld [wSliderRedraw], a                         ; $68EC

jr_004_68ef:
    ldh a, [hKeysNewSticky]                       ; $68EF
    and PADF_A | PADF_SELECT                      ; $68F1
    jr z, jr_004_690c                             ; $68F3

    play_sfx1 SFX1_KEY_SELECT                     ; $68F5
    ld a, [wPhotoNumberSel]                       ; $68FC
    ld hl, wPhotoCount                            ; $68FF
    cp [hl]                                       ; $6902
    ret nc                                        ; $6903

    call Album_ShowPageScreenB                    ; $6904
    next_state                                    ; $6907
    ret                                           ; $690B


jr_004_690c:
    ldh a, [hKeysNewSticky]                       ; $690C
    bit PADB_B, a                                 ; $690E
    ret z                                         ; $6910

    play_sfx1 SFX1_KEY_B                          ; $6911
    set_state STATE_09_LEAVE_TO_SHOOT             ; $6918
    ret                                           ; $691D


; C: photo with four blinking arrows: each direction opens an edit page
Mode09_State02_PhotoArrows::
    ld a, [wBlinkCounter]                         ; $691E
    inc a                                         ; $6921
    ld [wBlinkCounter], a                         ; $6922
    bit 4, a                                      ; $6925
    jr z, jr_004_6949                             ; $6927

    ld a, $a3                                     ; $6929
    ld bc, $5078                                  ; $692B
    call Oam_AddMeta_B01_4000                     ; $692E
    ld a, $a2                                     ; $6931
    ld bc, $5018                                  ; $6933
    call Oam_AddMeta_B01_4000                     ; $6936
    ld a, $a5                                     ; $6939
    ld bc, $1848                                  ; $693B
    call Oam_AddMeta_B01_4000                     ; $693E
    ld a, $a4                                     ; $6941
    ld bc, $8848                                  ; $6943
    call Oam_AddMeta_B01_4000                     ; $6946

jr_004_6949:
    ldh a, [hKeysNew]                             ; $6949
    and PADF_B | PADF_SELECT                      ; $694B
    jr z, jr_004_695e                             ; $694D

    play_sfx1 SFX1_KEY_B                          ; $694F
    call Album_ShowPageScreen                     ; $6956
    ld hl, wState                                 ; $6959
    dec [hl]                                      ; $695C
    ret                                           ; $695D


jr_004_695e:
    ldh a, [hKeysNewRepeat]                       ; $695E
    and PADF_DPAD                                 ; $6960
    ret z                                         ; $6962

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6963
    xor a                                         ; $696A
    ld [wArrowAnimTick], a                        ; $696B
    ld [wArrowAnimFrame], a                       ; $696E
    ldh a, [hKeysNewRepeat]                       ; $6971
    bit PADB_LEFT, a                              ; $6973
    jr z, jr_004_69af                             ; $6975

    call Oam_ClearShadow                          ; $6977
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $697A
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $6988
    ld hl, Slide_ScyDeltaTbl                      ; $6996
    ld b, $10                                     ; $6999

jr_004_699b:
    push bc                                       ; $699B
    push hl                                       ; $699C
    ldh a, [hScxShadow]                           ; $699D
    add [hl]                                      ; $699F
    ldh [hScxShadow], a                           ; $69A0
    rst Rst08_WaitVBlank                          ; $69A2
    pop hl                                        ; $69A3
    pop bc                                        ; $69A4
    inc hl                                        ; $69A5
    dec b                                         ; $69A6
    jr nz, jr_004_699b                            ; $69A7

    set_state STATE_09_PAGE_LEFT                  ; $69A9
    ret                                           ; $69AE


jr_004_69af:
    bit 4, a                                      ; $69AF
    jr z, jr_004_69eb                             ; $69B1

    call Oam_ClearShadow                          ; $69B3
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $69B6
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $69C4
    ld hl, Slide_ScyDeltaTbl                      ; $69D2
    ld b, $10                                     ; $69D5

jr_004_69d7:
    push bc                                       ; $69D7
    push hl                                       ; $69D8
    ldh a, [hScxShadow]                           ; $69D9
    sub [hl]                                      ; $69DB
    ldh [hScxShadow], a                           ; $69DC
    rst Rst08_WaitVBlank                          ; $69DE
    pop hl                                        ; $69DF
    pop bc                                        ; $69E0
    inc hl                                        ; $69E1
    dec b                                         ; $69E2
    jr nz, jr_004_69d7                            ; $69E3

    set_state STATE_09_PAGE_RIGHT                 ; $69E5
    ret                                           ; $69EA


jr_004_69eb:
    bit 6, a                                      ; $69EB
    jr z, jr_004_6a2c                             ; $69ED

    call Oam_ClearShadow                          ; $69EF
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $69F2
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6A00
    ld hl, Slide_ScyDeltaTbl                      ; $6A0E
    ld b, $10                                     ; $6A11

jr_004_6a13:
    push bc                                       ; $6A13
    push hl                                       ; $6A14
    ldh a, [hScyShadow]                           ; $6A15
    add [hl]                                      ; $6A17
    ldh [hScyShadow], a                           ; $6A18
    cpl                                           ; $6A1A
    add $64                                       ; $6A1B
    ldh [hLycShadowSplit1], a                     ; $6A1D
    rst Rst08_WaitVBlank                          ; $6A1F
    pop hl                                        ; $6A20
    pop bc                                        ; $6A21
    inc hl                                        ; $6A22
    dec b                                         ; $6A23
    jr nz, jr_004_6a13                            ; $6A24

    set_state STATE_09_PAGE_UP                    ; $6A26
    ret                                           ; $6A2B


jr_004_6a2c:
    bit 7, a                                      ; $6A2C
    ret z                                         ; $6A2E

    call Oam_ClearShadow                          ; $6A2F
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $6A32
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6A40
    ld hl, Slide_ScyDeltaTbl                      ; $6A4E
    ld b, $10                                     ; $6A51

jr_004_6a53:
    push bc                                       ; $6A53
    push hl                                       ; $6A54
    ldh a, [hScyShadow]                           ; $6A55
    sub [hl]                                      ; $6A57
    ldh [hScyShadow], a                           ; $6A58
    cpl                                           ; $6A5A
    add $64                                       ; $6A5B
    ldh [hLycShadowSplit1], a                     ; $6A5D
    rst Rst08_WaitVBlank                          ; $6A5F
    pop hl                                        ; $6A60
    pop bc                                        ; $6A61
    inc hl                                        ; $6A62
    dec b                                         ; $6A63
    jr nz, jr_004_6a53                            ; $6A64

    set_state STATE_09_PAGE_DOWN                  ; $6A66
    ret                                           ; $6A6B


; C: left page: choice A (Paint / Stamp)
Mode09_State03_PageLeft::
    call AlbumPage_ReadChoiceA                    ; $6A6C
    call AlbumPage_DrawChoiceA                    ; $6A6F
    ldh a, [hKeysNew]                             ; $6A72
    and PADF_A | PADF_B | PADF_RIGHT              ; $6A74
    ret z                                         ; $6A76

    push af                                       ; $6A77
    bit 0, a                                      ; $6A78
    ld a, SFX1_PAGE_STEP                          ; $6A7A
    call nz, Snd_Sfx1                             ; $6A7C
    pop af                                        ; $6A7F
    push af                                       ; $6A80
    bit 1, a                                      ; $6A81
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6A83
    call nz, Snd_Sfx1                             ; $6A85
    pop af                                        ; $6A88
    push af                                       ; $6A89
    bit 4, a                                      ; $6A8A
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6A8C
    call nz, Snd_Sfx1                             ; $6A8E
    pop af                                        ; $6A91
    push af                                       ; $6A92
    bit 0, a                                      ; $6A93
    jp z, Mode09_State03_PageLeft_SlideOut        ; $6A95

    ld hl, wArrowAnimFrame                        ; $6A98
    inc [hl]                                      ; $6A9B
    call Oam_HideUnused                           ; $6A9C
    rst Rst08_WaitVBlank                          ; $6A9F
    ld hl, $9880                                  ; $6AA0
    ld a, [wChoiceCursorA]                        ; $6AA3
    and a                                         ; $6AA6
    jr z, jr_004_6aac                             ; $6AA7

    ld hl, $9980                                  ; $6AA9

jr_004_6aac:
    call Album_DrawChoiceMarker                   ; $6AAC

jr_004_6aaf:
    call AlbumPage_DrawChoiceA                    ; $6AAF
    call Oam_HideUnused                           ; $6AB2
    rst Rst08_WaitVBlank                          ; $6AB5
    ld a, [wArrowAnimFrame]                       ; $6AB6
    cp $02                                        ; $6AB9
    jr nz, jr_004_6aaf                            ; $6ABB

; C: tail of the page-left key: clears the OAM shadow and slides the page with the 16-step table Tbl2FB5 (rSCX -
; table), then state 2 or the fade-out (branch target; code read 2026-10-19)
Mode09_State03_PageLeft_SlideOut::
    call Oam_ClearShadow                          ; $6ABD
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6AC0
    ld b, $10                                     ; $6AC3

jr_004_6ac5:
    push bc                                       ; $6AC5
    push hl                                       ; $6AC6
    ldh a, [hScxShadow]                           ; $6AC7
    sub [hl]                                      ; $6AC9
    ldh [hScxShadow], a                           ; $6ACA
    rst Rst08_WaitVBlank                          ; $6ACC
    pop hl                                        ; $6ACD
    pop bc                                        ; $6ACE
    inc hl                                        ; $6ACF
    dec b                                         ; $6AD0
    jr nz, jr_004_6ac5                            ; $6AD1

    pop af                                        ; $6AD3
    bit 0, a                                      ; $6AD4
    jr nz, jr_004_6ade                            ; $6AD6

    set_state STATE_09_PHOTO_ARROWS               ; $6AD8
    ret                                           ; $6ADD


jr_004_6ade:
    screen_off                                    ; $6ADE
    stat_irq_off                                  ; $6AE4
    ld a, [wPhotoNumberSel]                       ; $6AEE
    ld [wPhotoIndex], a                           ; $6AF1
    ld a, $01                                     ; $6AF4
    ld [wAbResult], a                             ; $6AF6
    ld a, $01                                     ; $6AF9
    ld [wCallerCode], a                           ; $6AFB
    xor a                                         ; $6AFE
    ld [wDoodleFromShutterbug], a                 ; $6AFF
    ld a, [wChoiceCursorA]                        ; $6B02
    and a                                         ; $6B05
    jr nz, jr_004_6b13                            ; $6B06

    ld a, MODE_PAINT                              ; $6B08
    ld [wMode], a                                 ; $6B0A
    set_state STATE_10_SETUP                      ; $6B0D
    ret                                           ; $6B12


jr_004_6b13:
    ld a, MODE_STAMP                              ; $6B13
    ld [wMode], a                                 ; $6B15
    set_state STATE_11_SETUP                      ; $6B18
    ret                                           ; $6B1D


; C: right page: choice B (Frame / Comment)
Mode09_State04_PageRight::
    call AlbumPage_ReadChoiceB                    ; $6B1E
    call AlbumPage_DrawChoiceB                    ; $6B21
    ldh a, [hKeysNew]                             ; $6B24
    and PADF_A | PADF_B | PADF_LEFT               ; $6B26
    ret z                                         ; $6B28

    push af                                       ; $6B29
    bit 0, a                                      ; $6B2A
    ld a, SFX1_PAGE_STEP                          ; $6B2C
    call nz, Snd_Sfx1                             ; $6B2E
    pop af                                        ; $6B31
    push af                                       ; $6B32
    bit 1, a                                      ; $6B33
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6B35
    call nz, Snd_Sfx1                             ; $6B37
    pop af                                        ; $6B3A
    push af                                       ; $6B3B
    bit 5, a                                      ; $6B3C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6B3E
    call nz, Snd_Sfx1                             ; $6B40
    pop af                                        ; $6B43
    push af                                       ; $6B44
    bit 0, a                                      ; $6B45
    jr z, jr_004_6b6e                             ; $6B47

    ld hl, wArrowAnimFrame                        ; $6B49
    inc [hl]                                      ; $6B4C
    call Oam_HideUnused                           ; $6B4D
    rst Rst08_WaitVBlank                          ; $6B50
    ld hl, $9896                                  ; $6B51
    ld a, [wChoiceCursorB]                        ; $6B54
    and a                                         ; $6B57
    jr z, jr_004_6b5d                             ; $6B58

    ld hl, $9996                                  ; $6B5A

jr_004_6b5d:
    call Album_DrawChoiceMarker                   ; $6B5D

jr_004_6b60:
    call AlbumPage_DrawChoiceB                    ; $6B60
    call Oam_HideUnused                           ; $6B63
    rst Rst08_WaitVBlank                          ; $6B66
    ld a, [wArrowAnimFrame]                       ; $6B67
    cp $02                                        ; $6B6A
    jr nz, jr_004_6b60                            ; $6B6C

jr_004_6b6e:
    call Oam_ClearShadow                          ; $6B6E
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6B71
    ld b, $10                                     ; $6B74

jr_004_6b76:
    push bc                                       ; $6B76
    push hl                                       ; $6B77
    ldh a, [hScxShadow]                           ; $6B78
    add [hl]                                      ; $6B7A
    ldh [hScxShadow], a                           ; $6B7B
    rst Rst08_WaitVBlank                          ; $6B7D
    pop hl                                        ; $6B7E
    pop bc                                        ; $6B7F
    inc hl                                        ; $6B80
    dec b                                         ; $6B81
    jr nz, jr_004_6b76                            ; $6B82

    pop af                                        ; $6B84
    bit 0, a                                      ; $6B85
    jr nz, jr_004_6b8f                            ; $6B87

    set_state STATE_09_PHOTO_ARROWS               ; $6B89
    ret                                           ; $6B8E


jr_004_6b8f:
    ld a, [wChoiceCursorB]                        ; $6B8F
    and a                                         ; $6B92
    jr nz, jr_004_6b9b                            ; $6B93

    set_state STATE_09_FRAME_INIT                 ; $6B95
    ret                                           ; $6B9A


jr_004_6b9b:
    set_state STATE_09_COMMENT_INIT               ; $6B9B
    ret                                           ; $6BA0


; C: up page: Print (mode 1C)
Mode09_State05_PageUp::
    call AlbumPage_DrawUp                         ; $6BA1
    ldh a, [hKeysNew]                             ; $6BA4
    and PADF_A | PADF_B | PADF_DOWN               ; $6BA6
    ret z                                         ; $6BA8

    push af                                       ; $6BA9
    bit 0, a                                      ; $6BAA
    ld a, SFX1_PAGE_STEP                          ; $6BAC
    call nz, Snd_Sfx1                             ; $6BAE
    pop af                                        ; $6BB1
    push af                                       ; $6BB2
    bit 1, a                                      ; $6BB3
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6BB5
    call nz, Snd_Sfx1                             ; $6BB7
    pop af                                        ; $6BBA
    push af                                       ; $6BBB
    bit 7, a                                      ; $6BBC
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6BBE
    call nz, Snd_Sfx1                             ; $6BC0
    pop af                                        ; $6BC3
    push af                                       ; $6BC4
    bit 0, a                                      ; $6BC5
    jr z, jr_004_6be5                             ; $6BC7

    ld hl, wArrowAnimFrame                        ; $6BC9
    inc [hl]                                      ; $6BCC
    call Oam_HideUnused                           ; $6BCD
    rst Rst08_WaitVBlank                          ; $6BD0
    ld hl, $9808                                  ; $6BD1
    call Album_DrawChoiceMarker                   ; $6BD4

jr_004_6bd7:
    call AlbumPage_DrawUp                         ; $6BD7
    call Oam_HideUnused                           ; $6BDA
    rst Rst08_WaitVBlank                          ; $6BDD
    ld a, [wArrowAnimFrame]                       ; $6BDE
    cp $02                                        ; $6BE1
    jr nz, jr_004_6bd7                            ; $6BE3

jr_004_6be5:
    call Oam_ClearShadow                          ; $6BE5
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6BE8
    ld b, $10                                     ; $6BEB

jr_004_6bed:
    push bc                                       ; $6BED
    push hl                                       ; $6BEE
    ldh a, [hScyShadow]                           ; $6BEF
    sub [hl]                                      ; $6BF1
    ldh [hScyShadow], a                           ; $6BF2
    cpl                                           ; $6BF4
    add $64                                       ; $6BF5
    ldh [hLycShadowSplit1], a                     ; $6BF7
    rst Rst08_WaitVBlank                          ; $6BF9
    pop hl                                        ; $6BFA
    pop bc                                        ; $6BFB
    inc hl                                        ; $6BFC
    dec b                                         ; $6BFD
    jr nz, jr_004_6bed                            ; $6BFE

    pop af                                        ; $6C00
    bit 0, a                                      ; $6C01
    jr nz, jr_004_6c0b                            ; $6C03

    set_state STATE_09_PHOTO_ARROWS               ; $6C05
    ret                                           ; $6C0A


jr_004_6c0b:
    screen_off                                    ; $6C0B
    stat_irq_off                                  ; $6C11
    ld a, [wPhotoNumberSel]                       ; $6C1B
    ld [wPhotoIndex], a                           ; $6C1E
    ld a, $01                                     ; $6C21
    ld [wAbResult], a                             ; $6C23
    ld a, $01                                     ; $6C26
    ld [wCallerCode], a                           ; $6C28
    xor a                                         ; $6C2B
    ld [wPrintLayoutFlag], a                      ; $6C2C
    ld [wBorderNormalised], a                     ; $6C2F
    ld [wPrintExtraFlag], a                       ; $6C32
    ld a, MODE_PRINT_PHOTO_PICKER                 ; $6C35
    ld [wMode], a                                 ; $6C37
    set_state STATE_1C_SHOW_PRINT_SCREEN          ; $6C3A
    ret                                           ; $6C3F


; C: down page: Delete (mode 0F with caller_code 1)
Mode09_State06_PageDown::
    call AlbumPage_DrawDown                       ; $6C40
    ldh a, [hKeysNew]                             ; $6C43
    and PADF_A | PADF_B | PADF_UP                 ; $6C45
    ret z                                         ; $6C47

    push af                                       ; $6C48
    bit 0, a                                      ; $6C49
    ld a, SFX1_PAGE_STEP                          ; $6C4B
    call nz, Snd_Sfx1                             ; $6C4D
    pop af                                        ; $6C50
    push af                                       ; $6C51
    bit 1, a                                      ; $6C52
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6C54
    call nz, Snd_Sfx1                             ; $6C56
    pop af                                        ; $6C59
    push af                                       ; $6C5A
    bit 6, a                                      ; $6C5B
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6C5D
    call nz, Snd_Sfx1                             ; $6C5F
    pop af                                        ; $6C62
    push af                                       ; $6C63
    bit 0, a                                      ; $6C64
    jr z, jr_004_6c84                             ; $6C66

    ld hl, wArrowAnimFrame                        ; $6C68
    inc [hl]                                      ; $6C6B
    call Oam_HideUnused                           ; $6C6C
    rst Rst08_WaitVBlank                          ; $6C6F
    ld hl, $9a88                                  ; $6C70
    call Album_DrawChoiceMarker                   ; $6C73

jr_004_6c76:
    call AlbumPage_DrawDown                       ; $6C76
    call Oam_HideUnused                           ; $6C79
    rst Rst08_WaitVBlank                          ; $6C7C
    ld a, [wArrowAnimFrame]                       ; $6C7D
    cp $02                                        ; $6C80
    jr nz, jr_004_6c76                            ; $6C82

jr_004_6c84:
    call Oam_ClearShadow                          ; $6C84
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $6C87
    ld b, $10                                     ; $6C8A

jr_004_6c8c:
    push bc                                       ; $6C8C
    push hl                                       ; $6C8D
    ldh a, [hScyShadow]                           ; $6C8E
    add [hl]                                      ; $6C90
    ldh [hScyShadow], a                           ; $6C91
    cpl                                           ; $6C93
    add $64                                       ; $6C94
    ldh [hLycShadowSplit1], a                     ; $6C96
    rst Rst08_WaitVBlank                          ; $6C98
    pop hl                                        ; $6C99
    pop bc                                        ; $6C9A
    inc hl                                        ; $6C9B
    dec b                                         ; $6C9C
    jr nz, jr_004_6c8c                            ; $6C9D

    pop af                                        ; $6C9F
    bit 0, a                                      ; $6CA0
    jr nz, jr_004_6caa                            ; $6CA2

    set_state STATE_09_PHOTO_ARROWS               ; $6CA4
    ret                                           ; $6CA9


jr_004_6caa:
    screen_off                                    ; $6CAA
    stat_irq_off                                  ; $6CB0
    ld a, [wPhotoNumberSel]                       ; $6CBA
    ld [wPhotoIndex], a                           ; $6CBD
    ld a, $01                                     ; $6CC0
    ld [wAbResult], a                             ; $6CC2
    ld a, $02                                     ; $6CC5
    ld [wMsgStripSel], a                          ; $6CC7
    ld a, $00                                     ; $6CCA
    ld [wIconSel], a                              ; $6CCC
    ld a, $01                                     ; $6CCF
    ld [wCallerCode], a                           ; $6CD1
    ld a, MODE_DELETE_PHOTO                       ; $6CD4
    ld [wMode], a                                 ; $6CD6
    set_state STATE_0F_CONFIRM_INIT               ; $6CD9
    ret                                           ; $6CDE


; C: B: back to mode 01
Mode09_State07_LeaveToShoot::
    screen_off                                    ; $6CDF
    stat_irq_off                                  ; $6CE5
    ld a, MODE_SHOOT_PARLOR                       ; $6CEF
    ld [wMode], a                                 ; $6CF1
    set_state STATE_01_INTRO                      ; $6CF4
    ret                                           ; $6CF9


; C: loads the frame of the photo (02:4E31)
Mode09_State08_FrameInit::
    screen_off                                    ; $6CFA
    stat_irq_off                                  ; $6D00
    ld a, [wPhotoNumberSel]                       ; $6D0A
    ldh [hFarcallAArg], a                         ; $6D0D
    farcall Photo_LoadBorder_Far                  ; $6D0F
    xor a                                         ; $6D17
    ld [wSubstate], a                             ; $6D18
    next_state                                    ; $6D1B
    ret                                           ; $6D1F


; C: far call 08:4DF2
Mode09_State09_FrameEdit::
    ldh [hFarcallAArg], a                         ; $6D20
    farcall BorderPicker_Far                      ; $6D22
    ret                                           ; $6D2A


; C: stores the frame (02:48F7) then restarts the viewer
Mode09_State0A_FrameSave::
    ld a, [wPhotoNumberSel]                       ; $6D2B
    ldh [hFarcallAArg], a                         ; $6D2E
    farcall Photo_StoreBorder_Far                 ; $6D30
    jp Mode09_State00_Init                        ; $6D38


; C: loads the tag fields of the photo (02:4E5F)
Mode09_State0B_CommentInit::
    screen_off                                    ; $6D3B
    stat_irq_off                                  ; $6D41
    ld a, [wPhotoNumberSel]                       ; $6D4B
    ld [wCmtPhotoIndex], a                        ; $6D4E
    ldh [hFarcallAArg], a                         ; $6D51
    farcall Photo_LoadTagFields_Far               ; $6D53
    xor a                                         ; $6D5B
    ld [wSubstate], a                             ; $6D5C
    next_state                                    ; $6D5F
    ret                                           ; $6D63


; C: far call 09:4281
Mode09_State0C_CommentEdit::
    ldh [hFarcallAArg], a                         ; $6D64
    ld a, $09                                     ; $6D66
    ld hl, CommentEditor_Far                      ; $6D68
    call Far_Call                                 ; $6D6B
    ret                                           ; $6D6E


; C: stores the comment (02:494B) then restarts the viewer
Mode09_State0D_CommentSave::
    ld a, [wPhotoNumberSel]                       ; $6D6F
    ldh [hFarcallAArg], a                         ; $6D72
    farcall Photo_StoreTagFields_Far              ; $6D74
    ld a, $01                                     ; $6D7C
    ld [wAbResult], a                             ; $6D7E
    jp Mode09_State00_Init                        ; $6D81


; I: tilemap 27:4470 and the number tiles
Album_ShowPageScreen::
    call Oam_ClearShadow                          ; $6D84
    ld a, $e4                                     ; $6D87
    ldh [hBgpShadow], a                           ; $6D89
    ldh [hObp0Shadow], a                          ; $6D8B
    ld a, $c6                                     ; $6D8D
    ldh [hObp1Shadow], a                          ; $6D8F
    farcopy Vram_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $6D91
    call Album_DrawPhotoNumber                    ; $6D9F
    farcopy Vram_CopyFromBank, Gfx_0C_7800_Mode09_State00_Init, $8900, $0300 ; $6DA2
    farcopy Vram_CopyFromBank, Gfx_0C_7B00_Mode09_State00_Init, $8500, $0300 ; $6DB0
    farcopy Vram_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $6DBE
    farcopy Vram_CopyFromBank, Gfx_0C_7FD0_Mode09_State00_Init, $8f70, $0030 ; $6DCC
    farcopy Vram_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $6DDA
    ret                                           ; $6DE8


; I: same with other palettes. L3 pass 2026-10-26: executed in BGB in 41 replay(s) of the organic corpus, modes 09
; (tcrf_check/assets/l3_names/)
Album_ShowPageScreenB::
    call Oam_ClearShadow                          ; $6DE9
    ld a, $e4                                     ; $6DEC
    ldh [hObp0Shadow], a                          ; $6DEE
    ld a, $d2                                     ; $6DF0
    ldh [hObp1Shadow], a                          ; $6DF2
    farcopy Vram_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $6DF4
    farcopy Vram_CopyFromBank, Gfx_1A_7600_Album_ShowPageScreenB, $8900, $0700 ; $6E02
    ld a, $1c                                     ; $6E10
    ld hl, Gfx_1C_5600_Album_ShowPageScreenB      ; $6E12
    ld de, $87e0                                  ; $6E15
    ld bc, $0020                                  ; $6E18
    call Vram_CopyFromBank                        ; $6E1B
    farcopy Vram_CopyFromBank, Map_24_73E0_Album_ShowPageScreenB, $9800, $02c0 ; $6E1E
    ret                                           ; $6E2C


; C: slides the knob to the target photo (slider_pos -> slider_target)
Slider_Update::
    ld a, [wSliderTarget]                         ; $6E2D
    ld hl, wSliderPos                             ; $6E30
    cp [hl]                                       ; $6E33
    jr z, jr_004_6e55                             ; $6E34

    jr c, jr_004_6e3c                             ; $6E36

    ld a, $01                                     ; $6E38
    jr jr_004_6e3e                                ; $6E3A

jr_004_6e3c:
    ld a, $ff                                     ; $6E3C

jr_004_6e3e:
    add [hl]                                      ; $6E3E
    ld [hl], a                                    ; $6E3F
    ld hl, wSliderTarget                          ; $6E40
    cp [hl]                                       ; $6E43
    jr nz, jr_004_6e80                            ; $6E44

    srl a                                         ; $6E46
    ld [wPhotoNumberSel], a                       ; $6E48
    ld a, $01                                     ; $6E4B
    ld [wSliderRedraw], a                         ; $6E4D
    ld a, $40                                     ; $6E50
    ld [wSliderTimer], a                          ; $6E52

jr_004_6e55:
    ld a, [wSliderTimer]                          ; $6E55
    and a                                         ; $6E58
    jr nz, jr_004_6e77                            ; $6E59

    ld a, [wPhotoNumberSel]                       ; $6E5B
    sla a                                         ; $6E5E
    sla a                                         ; $6E60
    add $17                                       ; $6E62
    ld b, a                                       ; $6E64
    ld c, $86                                     ; $6E65
    ldh a, [hFrameCounter]                        ; $6E67
    srl a                                         ; $6E69
    srl a                                         ; $6E6B
    srl a                                         ; $6E6D
    and $03                                       ; $6E6F
    add $09                                       ; $6E71
    call Oam_AddMeta_B01_4000                     ; $6E73
    ret                                           ; $6E76


jr_004_6e77:
    dec a                                         ; $6E77
    ld [wSliderTimer], a                          ; $6E78
    ld a, [wPhotoNumberSel]                       ; $6E7B
    sla a                                         ; $6E7E

jr_004_6e80:
    cp $3a                                        ; $6E80
    jr z, jr_004_6e97                             ; $6E82

    push af                                       ; $6E84
    and $fc                                       ; $6E85
    sla a                                         ; $6E87
    add $10                                       ; $6E89
    ld b, a                                       ; $6E8B
    ld c, $80                                     ; $6E8C
    pop af                                        ; $6E8E
    and $03                                       ; $6E8F
    add $04                                       ; $6E91
    call Oam_AddMeta_B01_4000                     ; $6E93
    ret                                           ; $6E96


jr_004_6e97:
    ld bc, $8080                                  ; $6E97
    ld a, $08                                     ; $6E9A
    call Oam_AddMeta_B01_4000                     ; $6E9C
    ret                                           ; $6E9F


; C: metasprite $0D at (0. L3 pass 2026-10-26: executed in BGB in 42 replay(s) of the organic corpus, modes 09
; (tcrf_check/assets/l3_names/)
Slider_DrawBar::
    ld bc, $0800                                  ; $6EA0
    ld a, $0d                                     ; $6EA3
    call Oam_AddMeta_B01_4000                     ; $6EA5
    ret                                           ; $6EA8


; C: Left / Right (also held) changes the target photo with wrap
Slider_Input::
    ld a, [wSliderTarget]                         ; $6EA9
    ld hl, wSliderPos                             ; $6EAC
    cp [hl]                                       ; $6EAF
    ret nz                                        ; $6EB0

    ldh a, [hKeysHeldSticky]                      ; $6EB1
    bit PADB_A, a                                 ; $6EB3
    jr nz, jr_004_6eb7                            ; $6EB5

jr_004_6eb7:
    ld b, a                                       ; $6EB7
    ld a, [wPhotoNumberSel]                       ; $6EB8
    sla a                                         ; $6EBB
    bit 5, b                                      ; $6EBD
    jr z, jr_004_6ed2                             ; $6EBF

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6EC1
    dec a                                         ; $6EC8
    dec a                                         ; $6EC9
    bit 7, a                                      ; $6ECA
    jr z, jr_004_6ee3                             ; $6ECC

    ld a, $3a                                     ; $6ECE
    jr jr_004_6ee3                                ; $6ED0

jr_004_6ed2:
    bit 4, b                                      ; $6ED2
    ret z                                         ; $6ED4

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6ED5
    inc a                                         ; $6EDC
    inc a                                         ; $6EDD
    cp $3c                                        ; $6EDE
    jr nz, jr_004_6ee3                            ; $6EE0

    xor a                                         ; $6EE2

jr_004_6ee3:
    ld [wSliderTarget], a                         ; $6EE3
    ld a, [wPhotoNumberSel]                       ; $6EE6
    sla a                                         ; $6EE9
    ld [wSliderPos], a                            ; $6EEB
    ldh a, [hKeysHeld]                            ; $6EEE
    bit PADB_A, a                                 ; $6EF0
    ld a, [wSliderTarget]                         ; $6EF2
    ld [wSliderPos], a                            ; $6EF5
    srl a                                         ; $6EF8
    ld [wPhotoNumberSel], a                       ; $6EFA
    ld a, $01                                     ; $6EFD
    ld [wSliderRedraw], a                         ; $6EFF
    ld a, $40                                     ; $6F02
    ld [wSliderTimer], a                          ; $6F04
    ret                                           ; $6F07


; C: photo number +1 as two decimal digits (stock pictures count from 1 again)
Album_DrawPhotoNumber::
    ld a, [wPhotoNumberSel]                       ; $6F08
    inc a                                         ; $6F0B
    ld bc, $0000                                  ; $6F0C
    cp $1f                                        ; $6F0F
    jr c, jr_004_6f16                             ; $6F11

    sub $1e                                       ; $6F13
    inc c                                         ; $6F15

jr_004_6f16:
    cp $0a                                        ; $6F16
    jr c, jr_004_6f1f                             ; $6F18

    sub $0a                                       ; $6F1A
    inc b                                         ; $6F1C
    jr jr_004_6f16                                ; $6F1D

jr_004_6f1f:
    push af                                       ; $6F1F
    ld de, $8fa0                                  ; $6F20
    ld a, b                                       ; $6F23
    inc a                                         ; $6F24
    inc a                                         ; $6F25
    call Album_LoadNumeralTile                    ; $6F26
    pop af                                        ; $6F29
    inc a                                         ; $6F2A
    inc a                                         ; $6F2B

; C: loads one numeral tile (32 bytes) from bank 0C:7E00
Album_LoadNumeralTile::
    swap a                                        ; $6F2C
    ld c, a                                       ; $6F2E
    ld b, $00                                     ; $6F2F
    sla c                                         ; $6F31
    rl b                                          ; $6F33
    ld hl, Gfx_0C_7E00_Album_LoadNumeralTile      ; $6F35
    add hl, bc                                    ; $6F38
    ld a, BANK(Gfx_0C_7E00_Album_LoadNumeralTile) ; $6F39
    ld bc, $0020                                  ; $6F3B
    call Vram_CopyFromBank                        ; $6F3E
    ret                                           ; $6F41


; C: mode 01: SHOOT parlor (RPG battle window)
Mode01_ShootParlor::
    ld a, [wState]                                ; $6F42
    rst Rst18_JumpTable                           ; $6F45

; I: 12 states, rst $18 table of mode $01
Mode01_StateTable::
    dw Mode01_State00_Intro
    dw Mode01_State01_MenuPageA
    dw Mode01_State02_ApplyPageA
    dw Mode01_State03_IntroPageB
    dw Mode01_State04_MenuPageB
    dw Mode01_State05_ApplyPageB
    dw Mode01_State06_IntroPageC
    dw Mode01_State07_MenuPageC
    dw Mode01_State08_ApplyPageC
    dw Mode01_State09_RunInit
    dw Mode01_State0A_RunResult
    dw Mode01_State0B_RunEnd

; C: one chance in four to start on the second page, else page A with music 6
Mode01_State00_Intro::
    call Rng_Next                                 ; $6F5E
    and $03                                       ; $6F61
    jr nz, jr_004_6f6b                            ; $6F63

    set_state STATE_01_INTRO_PAGE_B               ; $6F65
    ret                                           ; $6F6A


jr_004_6f6b:
    call Parlor_ScreenOn                          ; $6F6B
    play_music MUSIC_SHOOT_INTRO_A                ; $6F6E
    xor a                                         ; $6F75
    ld [wMenuPageShadow], a                       ; $6F76
    call Parlor_LoadPage                          ; $6F79
    call Parlor_SpiralWipeIn                      ; $6F7C
    call Parlor_DrawPortraits                     ; $6F7F
    call Oam_HideUnused                           ; $6F82
    rst Rst08_WaitVBlank                          ; $6F85
    farcopy Vram_CopyFromBank, Map_24_6320_Mode01_State00_Intro, $9920, $0040 ; $6F86
    call Parlor_DrawPortraits                     ; $6F94
    next_state                                    ; $6F97
    ret                                           ; $6F9B


; C: command menu, caption page A ("Welcome to my parlor!")
Mode01_State01_MenuPageA::
    ld de, wMode1CursorA                          ; $6F9C
    ld hl, Parlor_PageAB_NavTbl                   ; $6F9F
    call Parlor_MenuInput                         ; $6FA2
    ld hl, Parlor_PageA_CursorPosTbl              ; $6FA5
    ld a, $dc                                     ; $6FA8
    call Parlor_DrawCursor                        ; $6FAA
    call Parlor_Animate                           ; $6FAD
    ldh a, [hKeysNew]                             ; $6FB0
    and PADF_A | PADF_B                           ; $6FB2
    ret z                                         ; $6FB4

    ld [wAbResult], a                             ; $6FB5
    push af                                       ; $6FB8
    bit 0, a                                      ; $6FB9
    ld a, SFX1_MENU_CHOOSE                        ; $6FBB
    call nz, Snd_Sfx1                             ; $6FBD
    pop af                                        ; $6FC0
    push af                                       ; $6FC1
    bit 1, a                                      ; $6FC2
    ld a, SFX1_KEY_B                              ; $6FC4
    call nz, Snd_Sfx1                             ; $6FC6
    pop af                                        ; $6FC9
    next_state                                    ; $6FCA
    ret                                           ; $6FCE


; I: 5 x {y; x} of the cursor sprite $DC of parlor page A, indexed by wMode1CursorA: Parlor_DrawCursor (04:7279) loads
; C = y, B = x for Oam_AddMeta_B01_4000; items 0-2 (SHOOT / ITEMS / MAGIC) at x = $09, items 3-4 (CHECK / RUN) at x =
; $41 (read 2026-10-25)
Parlor_PageA_CursorPosTbl::
    db $65, $09, $71, $09, $7d, $09, $65, $42, $71, $42

; C: spiral wipe then the chosen mode
Mode01_State02_ApplyPageA::
    call Oam_ClearShadow                          ; $6FD9
    farcopy Vram_CopyFromBank, Map_24_61C0_Mode01_State02_ApplyPageA, $9920, $0040 ; $6FDC
    call Map_SpiralWipeOut                        ; $6FEA
    ld a, [wAbResult]                             ; $6FED
    bit 0, a                                      ; $6FF0
    jr nz, jr_004_7005                            ; $6FF2

    screen_off                                    ; $6FF4
    ld a, MODE_MAIN_MENU                          ; $6FFA
    ld [wMode], a                                 ; $6FFC
    set_state STATE_00_INIT                       ; $6FFF
    ret                                           ; $7004


jr_004_7005:
    ld a, [wPhotoCount]                           ; $7005
    and a                                         ; $7008
    jr z, jr_004_700c                             ; $7009

    dec a                                         ; $700B

jr_004_700c:
    ld [wPhotoNumberSel], a                       ; $700C
    ld a, [wMode1CursorA]                         ; $700F
    sla a                                         ; $7012
    ld c, a                                       ; $7014
    ld b, $00                                     ; $7015
    ld hl, Parlor_PageA_TargetTbl                 ; $7017
    add hl, bc                                    ; $701A
    ld a, [hl+]                                   ; $701B
    ld [wMode], a                                 ; $701C
    ld a, [hl]                                    ; $701F
    ld [wState], a                                ; $7020
    ld a, [wMode]                                 ; $7023
    cp MODE_SHOOT_PARLOR                          ; $7026
    ret z                                         ; $7028

    screen_off                                    ; $7029
    ret                                           ; $702F


; C: 5 x {mode; state} of parlor page A (SHOOT / ITEMS / MAGIC / CHECK / RUN): $15:00, $01:06, $16:00, $09:00, $01:09;
; Mode01_State02_ApplyPageA (04:706B) writes them to wMode / wState when the choice is A (also in const_tables_jp.csv)
; (read 2026-10-25)
Parlor_PageA_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_RETURN_TO_SHOOT, MODE_SHOOT_PARLOR, STATE_01_INTRO_PAGE_C, MODE_SHUTTERBUG_MAGIC, STATE_16_INIT, MODE_ALBUM_EDIT, STATE_09_INIT, MODE_SHOOT_PARLOR, STATE_01_RUN_INIT

; C: music 7
Mode01_State03_IntroPageB::
    call Parlor_ScreenOn                          ; $703A
    play_music MUSIC_SHOOT_INTRO_B                ; $703D
    ld a, $01                                     ; $7044
    ld [wMenuPageShadow], a                       ; $7046
    call Parlor_LoadPage                          ; $7049
    call Parlor_SpiralWipeIn                      ; $704C
    next_state                                    ; $704F
    ret                                           ; $7053


; C
Mode01_State04_MenuPageB::
    ld de, wMode1CursorA                          ; $7054
    ld hl, Parlor_PageAB_NavTbl                   ; $7057
    call Parlor_MenuInput                         ; $705A
    ld hl, Parlor_PageB_CursorPosTbl              ; $705D
    ld a, $df                                     ; $7060
    call Parlor_DrawCursor                        ; $7062
    call Parlor_AnimateB                          ; $7065
    ldh a, [hKeysNew]                             ; $7068
    and PADF_A | PADF_B                           ; $706A
    ret z                                         ; $706C

    ld [wAbResult], a                             ; $706D
    push af                                       ; $7070
    bit 0, a                                      ; $7071
    ld a, SFX1_MENU_CHOOSE                        ; $7073
    call nz, Snd_Sfx1                             ; $7075
    pop af                                        ; $7078
    push af                                       ; $7079
    bit 1, a                                      ; $707A
    ld a, SFX1_KEY_B                              ; $707C
    call nz, Snd_Sfx1                             ; $707E
    pop af                                        ; $7081
    next_state                                    ; $7082
    ret                                           ; $7086


; I: 5 x {y; x} of the cursor sprite $DF of parlor page B (same bytes as Parlor_PageA_CursorPosTbl), read by
; Parlor_DrawCursor from Mode01_State04_MenuPageB (read 2026-10-25)
Parlor_PageB_CursorPosTbl::
    db $65, $09, $71, $09, $7d, $09, $65, $42, $71, $42

; C
Mode01_State05_ApplyPageB::
    call Map_SpiralWipeOut                        ; $7091
    ld a, [wAbResult]                             ; $7094
    bit 0, a                                      ; $7097
    jr nz, jr_004_70ac                            ; $7099

    screen_off                                    ; $709B
    ld a, MODE_MAIN_MENU                          ; $70A1
    ld [wMode], a                                 ; $70A3
    set_state STATE_00_INIT                       ; $70A6
    ret                                           ; $70AB


jr_004_70ac:
    ld a, [wPhotoCount]                           ; $70AC
    and a                                         ; $70AF
    jr z, jr_004_70b3                             ; $70B0

    dec a                                         ; $70B2

jr_004_70b3:
    ld [wPhotoNumberSel], a                       ; $70B3
    ld a, [wMode1CursorA]                         ; $70B6
    sla a                                         ; $70B9
    ld c, a                                       ; $70BB
    ld b, $00                                     ; $70BC
    ld hl, Parlor_PageB_TargetTbl                 ; $70BE
    add hl, bc                                    ; $70C1
    ld a, [hl+]                                   ; $70C2
    ld [wMode], a                                 ; $70C3
    ld a, [hl]                                    ; $70C6
    ld [wState], a                                ; $70C7
    ld a, [wMode]                                 ; $70CA
    cp MODE_SHOOT_PARLOR                          ; $70CD
    ret z                                         ; $70CF

    screen_off                                    ; $70D0
    ret                                           ; $70D6


; C: 5 x {mode; state} of parlor page B, the same five targets as page A; Mode01_State05_ApplyPageB (04:7112) (read
; 2026-10-25)
Parlor_PageB_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_RETURN_TO_SHOOT, MODE_SHOOT_PARLOR, STATE_01_INTRO_PAGE_C, MODE_SHUTTERBUG_MAGIC, STATE_16_INIT, MODE_ALBUM_EDIT, STATE_09_INIT, MODE_SHOOT_PARLOR, STATE_01_RUN_INIT

; C: music $0E
Mode01_State06_IntroPageC::
    call Parlor_ScreenOn                          ; $70E1
    play_music MUSIC_SHOOT_INTRO_C                ; $70E4
    ld a, $02                                     ; $70EB
    ld [wMenuPageShadow], a                       ; $70ED
    call Parlor_LoadPage                          ; $70F0
    call Parlor_SpiralWipeIn                      ; $70F3
    next_state                                    ; $70F6
    ret                                           ; $70FA


; C: second cursor and table
Mode01_State07_MenuPageC::
    ld de, wMode1CursorB                          ; $70FB
    ld hl, Parlor_PageC_NavTbl                    ; $70FE
    call Parlor_MenuInput                         ; $7101
    ld hl, Parlor_PageC_CursorPosTbl              ; $7104
    ld a, $df                                     ; $7107
    call Parlor_DrawCursor                        ; $7109
    call Parlor_AnimateC                          ; $710C
    ldh a, [hKeysNew]                             ; $710F
    and PADF_A | PADF_B                           ; $7111
    ret z                                         ; $7113

    ld [wAbResult], a                             ; $7114
    push af                                       ; $7117
    bit 0, a                                      ; $7118
    ld a, SFX1_MENU_CHOOSE                        ; $711A
    call nz, Snd_Sfx1                             ; $711C
    pop af                                        ; $711F
    push af                                       ; $7120
    bit 1, a                                      ; $7121
    ld a, SFX1_KEY_B                              ; $7123
    call nz, Snd_Sfx1                             ; $7125
    pop af                                        ; $7128
    next_state                                    ; $7129
    ret                                           ; $712D


; I: 2 x {y; x} of the cursor sprite $DF of parlor page C (the ITEMS sub-menu, cursor $D5E1): y = $6A / $79, x = $09;
; read by Parlor_DrawCursor from Mode01_State07_MenuPageC (read 2026-10-25)
Parlor_PageC_CursorPosTbl::
    db $6a, $0a, $78, $0a

; C
Mode01_State08_ApplyPageC::
    call Map_SpiralWipeOut                        ; $7132
    ld a, [wAbResult]                             ; $7135
    bit 0, a                                      ; $7138
    jr nz, jr_004_7142                            ; $713A

    set_state STATE_01_INTRO                      ; $713C
    ret                                           ; $7141


jr_004_7142:
    screen_off                                    ; $7142
    ld a, [wMode1CursorB]                         ; $7148
    sla a                                         ; $714B
    ld c, a                                       ; $714D
    ld b, $00                                     ; $714E
    ld hl, Parlor_PageC_TargetTbl                 ; $7150
    add hl, bc                                    ; $7153
    ld a, [hl+]                                   ; $7154
    ld [wMode], a                                 ; $7155
    ld a, [hl]                                    ; $7158
    ld [wState], a                                ; $7159
    ret                                           ; $715C


; C: 2 x {mode; state} of the ITEMS sub-menu: $15:01 (self-timer, Mode15_State01_TimerInit) and $15:05 (interval,
; Mode15_State05_IntervalInit); Mode01_State08_ApplyPageC (04:71A4) (read 2026-10-25)
Parlor_PageC_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_TIMER_INIT, MODE_SELF_TIMER_INTERVAL, STATE_15_INTERVAL_INIT

; C: RUN: picks the message 0E or, 30 % of the time, 04
Mode01_State09_RunInit::
    screen_off                                    ; $7161
    ld a, $0e                                     ; $7167
    ld [wResultMsgId], a                          ; $7169
    call Rng_Next                                 ; $716C
    cp $4c                                        ; $716F
    jr nc, jr_004_7178                            ; $7171

    ld a, $04                                     ; $7173
    ld [wResultMsgId], a                          ; $7175

jr_004_7178:
    xor a                                         ; $7178
    ld [wSubstate], a                             ; $7179
    next_state                                    ; $717C
    ret                                           ; $7180


; C: far call 09:7290 (result screen)
Mode01_State0A_RunResult::
    ldh [hFarcallAArg], a                         ; $7181
    farcall ResultScreen_Far                      ; $7183
    ret                                           ; $718B


; C
Mode01_State0B_RunEnd::
    ld a, [wResultMsgId]                          ; $718C
    cp $0e                                        ; $718F
    jr nz, jr_004_7199                            ; $7191

    set_state STATE_01_INTRO                      ; $7193
    ret                                           ; $7198


jr_004_7199:
    cp $04                                        ; $7199
    jr nz, jr_004_71b3                            ; $719B

    call Rng_Next                                 ; $719D
    cp $4c                                        ; $71A0
    jr nc, jr_004_71b3                            ; $71A2

    ld a, $08                                     ; $71A4
    ld [wResultMsgId], a                          ; $71A6
    xor a                                         ; $71A9
    ld [wSubstate], a                             ; $71AA
    set_state STATE_01_RUN_RESULT                 ; $71AD
    ret                                           ; $71B2


jr_004_71b3:
    set_state STATE_01_INTRO                      ; $71B3
    ret                                           ; $71B8


; C: Up / Down moves the cursor in a table of items
Parlor_MenuInput::
    push de                                       ; $71B9
    ld a, [de]                                    ; $71BA
    ld c, a                                       ; $71BB
    ld b, $00                                     ; $71BC
    add hl, bc                                    ; $71BE
    ld c, [hl]                                    ; $71BF
    add hl, bc                                    ; $71C0
    ldh a, [hKeysNewRepeat]                       ; $71C1
    ld b, a                                       ; $71C3
    ld a, [hl+]                                   ; $71C4

jr_004_71c5:
    and b                                         ; $71C5
    jr z, jr_004_71cb                             ; $71C6

    ld c, [hl]                                    ; $71C8
    jr jr_004_71d3                                ; $71C9

jr_004_71cb:
    inc hl                                        ; $71CB
    ld a, [hl+]                                   ; $71CC
    and a                                         ; $71CD
    jr nz, jr_004_71c5                            ; $71CE

    pop hl                                        ; $71D0
    ld c, [hl]                                    ; $71D1
    ret                                           ; $71D2


jr_004_71d3:
    ld a, b                                       ; $71D3
    push af                                       ; $71D4
    bit 5, a                                      ; $71D5
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $71D7
    call nz, Snd_Sfx1                             ; $71D9
    pop af                                        ; $71DC
    push af                                       ; $71DD
    bit 4, a                                      ; $71DE
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $71E0
    call nz, Snd_Sfx1                             ; $71E2
    pop af                                        ; $71E5
    push af                                       ; $71E6
    bit 6, a                                      ; $71E7
    ld a, SFX1_KEY_UP_DOWN                        ; $71E9
    call nz, Snd_Sfx1                             ; $71EB
    pop af                                        ; $71EE
    push af                                       ; $71EF
    bit 7, a                                      ; $71F0
    ld a, SFX1_KEY_UP_DOWN                        ; $71F2
    call nz, Snd_Sfx1                             ; $71F4
    pop af                                        ; $71F7
    pop hl                                        ; $71F8
    ld [hl], c                                    ; $71F9
    ret                                           ; $71FA


; C: cursor graph of parlor pages A and B for Parlor_MenuInput (04:720D): 5 offset bytes (one per item, relative to
; the byte itself), then per item a list of {new-key mask; next item} ended by 0; Down / Right / Up / Left between
; SHOOT, ITEMS, MAGIC (left column) and CHECK, RUN (right column); 34 B, not ...
Parlor_PageAB_NavTbl::
    db $05, $09, $0f, $13, $17, $80, $01, $10, $03, $00, $40, $00, $80, $02, $10, $04
    db $00, $40, $01, $10, $04, $00, $80, $04, $20, $00, $00, $40, $03, $80, $02, $20
    db $01, $00

; C: cursor graph of parlor page C for Parlor_MenuInput (same format as Parlor_PageAB_NavTbl): 2 items, Down 0 -> 1,
; Up 1 -> 0; 8 B (read 2026-10-25)
Parlor_PageC_NavTbl::
    db $02, $04, $80, $01, $00, $40, $00, $00

; C
Parlor_DrawCursor::
    sla c                                         ; $7225
    ld b, $00                                     ; $7227
    add hl, bc                                    ; $7229
    ld c, [hl]                                    ; $722A
    inc hl                                        ; $722B
    ld b, [hl]                                    ; $722C
    call Oam_AddMeta_B01_4000                     ; $722D
    ret                                           ; $7230


; C: animates the queen tiles and sprite
Parlor_Animate::
    call Parlor_AnimQueenTiles                    ; $7231
    call Parlor_AnimQueenSprite                   ; $7234
    ret                                           ; $7237


; C
Parlor_AnimQueenTiles::
    ld a, [wSpriteAnimFrame]                      ; $7238
    sla a                                         ; $723B
    sla a                                         ; $723D
    ld c, a                                       ; $723F
    ld b, $00                                     ; $7240
    ld hl, Parlor_AnimQueenTiles_Tbl7276          ; $7242
    add hl, bc                                    ; $7245
    ld c, [hl]                                    ; $7246
    inc hl                                        ; $7247
    ld b, [hl]                                    ; $7248
    inc hl                                        ; $7249
    push hl                                       ; $724A
    ld l, c                                       ; $724B
    ld h, b                                       ; $724C
    ld a, $24                                     ; $724D
    ld de, $98a0                                  ; $724F
    ld bc, $0040                                  ; $7252
    call Vram_CopyFromBank                        ; $7255
    pop hl                                        ; $7258
    ld a, [wSpriteAnimTick]                       ; $7259
    cp [hl]                                       ; $725C
    jr nz, jr_004_7271                            ; $725D

    inc hl                                        ; $725F
    inc hl                                        ; $7260
    ld a, [hl]                                    ; $7261
    inc a                                         ; $7262
    jr z, jr_004_7269                             ; $7263

    ld a, [wSpriteAnimFrame]                      ; $7265
    inc a                                         ; $7268

jr_004_7269:
    ld [wSpriteAnimFrame], a                      ; $7269
    call Rng_Next                                 ; $726C
    and $07                                       ; $726F

jr_004_7271:
    inc a                                         ; $7271
    ld [wSpriteAnimTick], a                       ; $7272
    ret                                           ; $7275


; C: 4-byte records {src lo, src hi, duration, flag}: 24:6140 for $10 ticks, 24:62E0 for $0E, ... flag $FF wraps the
; frame index; the record is read by Parlor_AnimQueenTiles (04:728C) with the frame index $D500 x 4; 6 records + end
Parlor_AnimQueenTiles_Tbl7276::
    dw Map_24_6140_Parlor_Page0_QueenFrameA
    db $10, $00, $e0, $62, $0e, $00
    dw Map_24_6140_Parlor_Page0_QueenFrameA
    db $0e, $00, $e0, $62, $0e, $00, $40, $61, $0e, $00, $e0, $62, $0e, $00, $ff

; C
Parlor_AnimQueenSprite::
    ld a, [wSpriteAnimFrame + $1]                 ; $728F
    ld c, a                                       ; $7292
    sla a                                         ; $7293
    sla a                                         ; $7295
    add c                                         ; $7297
    ld c, a                                       ; $7298
    ld b, $00                                     ; $7299
    ld hl, Parlor_AnimQueenSprite_Tbl72CD         ; $729B
    add hl, bc                                    ; $729E
    ld b, [hl]                                    ; $729F
    inc hl                                        ; $72A0
    ld c, [hl]                                    ; $72A1
    inc hl                                        ; $72A2
    ld a, $dd                                     ; $72A3
    call Oam_AddMeta_B01_4000                     ; $72A5
    ld b, [hl]                                    ; $72A8
    inc hl                                        ; $72A9
    ld c, [hl]                                    ; $72AA
    inc hl                                        ; $72AB
    ld a, $de                                     ; $72AC
    call Oam_AddMeta_B01_4000                     ; $72AE
    ld a, [wSpriteAnimTick + $1]                  ; $72B1
    cp [hl]                                       ; $72B4
    jr c, jr_004_72c8                             ; $72B5

    inc hl                                        ; $72B7
    ld a, [hl+]                                   ; $72B8
    inc a                                         ; $72B9
    jr z, jr_004_72c0                             ; $72BA

    ld a, [wSpriteAnimFrame + $1]                 ; $72BC
    inc a                                         ; $72BF

jr_004_72c0:
    ld [wSpriteAnimFrame + $1], a                 ; $72C0
    call Rng_Next                                 ; $72C3
    and $07                                       ; $72C6

jr_004_72c8:
    inc a                                         ; $72C8
    ld [wSpriteAnimTick + $1], a                  ; $72C9
    ret                                           ; $72CC


; C: auto: 31 bytes, bytes; referenced by Parlor_AnimQueenSprite. L3 pass 2026-10-26: read in BGB in 88 replay(s) of
; the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimQueenSprite_Tbl72CD::
    db $31, $51, $62, $51, $12, $32, $51, $61, $51, $0c, $31, $51, $62, $51, $0a, $32
    db $51, $61, $51, $0c, $31, $51, $62, $51, $0a, $32, $51, $61, $51, $0e, $ff

; C: L3 pass 2026-10-26: executed in BGB in 24 replay(s) of the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateB::
    ld a, [wSpriteAnimTick]                       ; $72EC
    inc a                                         ; $72EF
    cp $14                                        ; $72F0
    jr c, jr_004_731a                             ; $72F2

    ld a, [wSpriteAnimFrame]                      ; $72F4
    xor $01                                       ; $72F7
    ld [wSpriteAnimFrame], a                      ; $72F9
    sla a                                         ; $72FC
    ld c, a                                       ; $72FE
    ld b, $00                                     ; $72FF
    ld hl, Parlor_AnimateB_PtrTbl731E             ; $7301
    add hl, bc                                    ; $7304
    ld c, [hl]                                    ; $7305
    inc hl                                        ; $7306
    ld b, [hl]                                    ; $7307
    ld l, c                                       ; $7308
    ld h, b                                       ; $7309
    ld a, $23                                     ; $730A
    ld de, $9800                                  ; $730C
    ld bc, $0160                                  ; $730F
    call Vram_CopyFromBank                        ; $7312
    call Rng_Next                                 ; $7315
    and $03                                       ; $7318

jr_004_731a:
    ld [wSpriteAnimTick], a                       ; $731A
    ret                                           ; $731D


; C: word table: the two 11-row map pieces 23:7040 and 23:7280 copied by Parlor_AnimateB (04:7340), index $D500 xor 1
; every $14 frames
Parlor_AnimateB_PtrTbl731E::
    dw Map_23_7040_Parlor_Page1
    dw Map_23_7280_Parlor_Page1_AltTopRows

; C: L3 pass 2026-10-26: executed in BGB in 27 replay(s) of the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateC::
    ld a, [wSpriteAnimFrame]                      ; $7322
    sla a                                         ; $7325
    ld c, a                                       ; $7327
    ld b, $00                                     ; $7328
    ld hl, Parlor_AnimateC_Tbl734E                ; $732A
    add hl, bc                                    ; $732D
    ld a, [hl+]                                   ; $732E
    ld bc, $1f12                                  ; $732F
    and a                                         ; $7332
    call nz, Oam_AddMeta_B01_4000                 ; $7333
    ld a, [wSpriteAnimTick]                       ; $7336
    cp [hl]                                       ; $7339
    jr c, jr_004_7349                             ; $733A

    inc hl                                        ; $733C
    ld a, [hl]                                    ; $733D
    inc a                                         ; $733E
    jr z, jr_004_7345                             ; $733F

    ld a, [wSpriteAnimFrame]                      ; $7341
    inc a                                         ; $7344

jr_004_7345:
    ld [wSpriteAnimFrame], a                      ; $7345
    xor a                                         ; $7348

jr_004_7349:
    inc a                                         ; $7349
    ld [wSpriteAnimTick], a                       ; $734A
    ret                                           ; $734D


; C: auto: 9 bytes, bytes; referenced by Parlor_AnimateC. L3 pass 2026-10-26: read in BGB in 27 replay(s) of the
; organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateC_Tbl734E::
    db $e0, $04, $e1, $04, $e2, $04, $00, $08, $ff

; C: metasprites $DD / $DE. L3 pass 2026-10-26: executed in BGB in 88 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Parlor_DrawPortraits::
    ld bc, $3151                                  ; $7357
    ld a, $dd                                     ; $735A
    call Oam_AddMeta_B01_4000                     ; $735C
    ld bc, $6251                                  ; $735F
    ld a, $de                                     ; $7362
    call Oam_AddMeta_B01_4000                     ; $7364
    ret                                           ; $7367


; C: clears OAM and fades the screen in once; sets lcdc and palettes
Parlor_ScreenOn::
    call Oam_ClearShadow                          ; $7368
    ldh a, [hLcdcShadow]                          ; $736B
    bit 7, a                                      ; $736D
    jr nz, jr_004_737f                            ; $736F

    ld a, $ff                                     ; $7371
    ld [wPaletteTarget], a                        ; $7373
    call Pal_AllWhite                             ; $7376
    call Lcd_On                                   ; $7379
    call Pal_FadeIn                               ; $737C

jr_004_737f:
    rst Rst08_WaitVBlank                          ; $737F
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7380
    ldh [hLcdcShadow], a                          ; $7382
    ld a, $e4                                     ; $7384
    ld [wPaletteTarget], a                        ; $7386
    ld a, $ff                                     ; $7389
    ldh [hBgpShadow], a                           ; $738B
    ld a, $e4                                     ; $738D
    ldh [hObp0Shadow], a                          ; $738F
    ld a, $c6                                     ; $7391
    ldh [hObp1Shadow], a                          ; $7393
    xor a                                         ; $7395
    ldh [hScxShadow], a                           ; $7396
    ldh [hScyShadow], a                           ; $7398
    ret                                           ; $739A


; C: graphics and map of page A in the table at 7436 (A = page)
Parlor_LoadPage::
    sla a                                         ; $739B
    ld c, a                                       ; $739D
    ld b, $00                                     ; $739E
    ld hl, Parlor_PageTbl                         ; $73A0
    add hl, bc                                    ; $73A3
    ld a, [hl+]                                   ; $73A4
    ld h, [hl]                                    ; $73A5
    ld l, a                                       ; $73A6

jr_004_73a7:
    ld a, [hl+]                                   ; $73A7
    cp $ff                                        ; $73A8
    jr z, jr_004_73c5                             ; $73AA

    push hl                                       ; $73AC
    ld c, a                                       ; $73AD
    ld b, [hl]                                    ; $73AE
    inc hl                                        ; $73AF
    push bc                                       ; $73B0
    ld a, [hl+]                                   ; $73B1
    ld e, [hl]                                    ; $73B2
    inc hl                                        ; $73B3
    ld d, [hl]                                    ; $73B4
    inc hl                                        ; $73B5
    ld c, [hl]                                    ; $73B6
    inc hl                                        ; $73B7
    ld b, [hl]                                    ; $73B8
    inc hl                                        ; $73B9
    pop hl                                        ; $73BA
    call Vram_CopyFromBank                        ; $73BB
    pop hl                                        ; $73BE
    ld bc, $0006                                  ; $73BF
    add hl, bc                                    ; $73C2
    jr jr_004_73a7                                ; $73C3

jr_004_73c5:
    ld a, [hl+]                                   ; $73C5
    ld [wMenuMapPtr], a                           ; $73C6
    ld a, [hl+]                                   ; $73C9
    ld [wMenuMapPtr + $1], a                      ; $73CA
    ld a, [hl]                                    ; $73CD
    ld [wMenuMapPtr + $2], a                      ; $73CE
    xor a                                         ; $73D1
    ld [wSpriteAnimFrame], a                      ; $73D2
    ld [wSpriteAnimTick], a                       ; $73D5
    ld [wSpriteAnimFrame + $1], a                 ; $73D8
    ld [wSpriteAnimTick + $1], a                  ; $73DB
    ld [wSpriteAnimFrame], a                      ; $73DE
    ret                                           ; $73E1


; I: 3 pointers to lists of 7-byte records {src lo, src hi, bank, dst lo, dst hi, len lo, len hi} ended by $FF; the
; tail of each list is {lo,hi,bank} of the page map: page 0 -> 24:60A0, page 1 -> 23:7040, page 2 -> 26:7BC0 (C, read
; from the ROM)
Parlor_PageTbl::
    dw Parlor_PageTbl + $6
    dw Parlor_PageTbl + $18
    dw Parlor_PageTbl + $2A
    dw Gfx_1D_5D00_Mode20_State02_GameSetup + $E00
    db BANK(Gfx_1D_5D00_Mode20_State02_GameSetup)
    db $00, $90, $00, $08
    dw Sheet_MenusShootMenu_1D_72A0 + $60
    db BANK(Sheet_MenusShootMenu_1D_72A0)
    db $00, $88, $00, $08, $ff
    dwb Map_24_60A0_Parlor_Page0
    db $00, $40, $1c, $00, $90, $00, $08
    dw Sheet_MenusShootMenu_1C_4670 + $190
    db BANK(Sheet_MenusShootMenu_1C_4670)
    db $00, $88, $00, $08, $ff
    dwb Map_23_7040_Parlor_Page1
    dw Gfx_21_5870_CommentCard_DrawCopyBadge_Far + $190
    db BANK(Gfx_21_5870_CommentCard_DrawCopyBadge_Far)
    db $00, $90, $00, $08
    dw Sheet_MenusShootMenu_21_5FD0 + $230
    db BANK(Sheet_MenusShootMenu_21_5FD0)
    db $00, $88, $00, $08
    dw Sheet_MenusShootMenu_21_5FD0 + $590
    db BANK(Sheet_MenusShootMenu_21_5FD0)
    db $f0, $8d, $10, $00, $ff
    dwb Map_26_7740_Parlor_Page2

; C: spiral wipe in of the map saved in menu_map_ptr
Parlor_SpiralWipeIn::
    ld a, [wMenuMapPtr]                           ; $7425
    ld l, a                                       ; $7428
    ld a, [wMenuMapPtr + $1]                      ; $7429
    ld h, a                                       ; $742C
    ld a, [wMenuMapPtr + $2]                      ; $742D
    call Map_SpiralWipeIn                         ; $7430
    ret                                           ; $7433


; C: mode 0A: VIEW album: pick a photo then browse with a slider and edit pages
Mode0A_AlbumView::
    ld a, [wState]                                ; $7434
    rst Rst18_JumpTable                           ; $7437

; I: 16 states, rst $18 table of mode $0A
Mode0A_StateTable::
    dw Mode0A_State00_Init
    dw Mode0A_State01_PickPhoto
    dw Mode0A_State02_Setup
    dw Mode0A_State03_SliderBrowse
    dw Mode0A_State04_PhotoArrows
    dw Mode0A_State05_PageLeft
    dw Mode0A_State06_PageRight
    dw Mode0A_State07_PageUp
    dw Mode0A_State08_PageDown
    dw Mode0A_State09_Leave
    dw Mode0A_State0A_FrameInit
    dw Mode0A_State0B_FrameEdit
    dw Mode0A_State0C_FrameSave
    dw Mode0A_State0D_CommentInit
    dw Mode0A_State0E_CommentEdit
    dw Mode0A_State0F_CommentSave

; C
Mode0A_State00_Init::
    ld a, $01                                     ; $7458
    ld [wMsgStripSel], a                          ; $745A
    ld a, $02                                     ; $745D
    ld [wIconSel], a                              ; $745F
    xor a                                         ; $7462
    ld [wSubstate], a                             ; $7463
    ld a, $01                                     ; $7466
    ld [wStockNavAllowed], a                      ; $7468
    next_state                                    ; $746B
    ret                                           ; $746F


; C: far call to the photo grid picker
Mode0A_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $7470
    ld a, $04                                     ; $7472
    ld hl, PhotoPicker_Far                        ; $7474
    call Far_Call                                 ; $7477
    ret                                           ; $747A


; C
Mode0A_State02_Setup::
    ld a, [wAbResult]                             ; $747B
    bit 0, a                                      ; $747E
    jr nz, jr_004_748d                            ; $7480

    ld a, MODE_VIEW_MENU                          ; $7482
    ld [wMode], a                                 ; $7484
    set_state STATE_02_INIT                       ; $7487
    ret                                           ; $748C


jr_004_748d:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $748D
    ldh [hLcdcShadow], a                          ; $748F
    ld a, $e4                                     ; $7491
    ld [wPaletteTarget], a                        ; $7493
    ld [wPaletteTarget + $1], a                   ; $7496
    ld a, $d2                                     ; $7499
    ld [wPaletteTarget + $2], a                   ; $749B
    ld a, $10                                     ; $749E
    ldh [hScxShadow], a                           ; $74A0
    ldh [hScyShadow], a                           ; $74A2
    xor a                                         ; $74A4
    ld [wChoiceCursorA], a                        ; $74A5
    ld [wChoiceCursorB], a                        ; $74A8
    ld [wSliderRedraw], a                         ; $74AB
    ld a, $b4                                     ; $74AE
    ld [wSliderTimer], a                          ; $74B0
    farcopy Mem_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $74B3
    farcopy Mem_CopyFromBank, Gfx_0C_79A0_Mode0A_State02_Setup, $8f70, $0010 ; $74C1
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $74CF
    ld hl, $9ac0                                  ; $74DD
    ld bc, $0140                                  ; $74E0
    ld a, $ff                                     ; $74E3
    call Mem_FillBc1                              ; $74E5
    ld a, [wPhotoIndex]                           ; $74E8
    ld [wCopyPhotoIdxA], a                        ; $74EB
    ldh [hFarcallAArg], a                         ; $74EE
    farcall Photo_LoadToVram_Far                  ; $74F0
    ld a, [wCopyPhotoIdxA]                        ; $74F8
    ldh [hFarcallAArg], a                         ; $74FB
    farcall Photo_LoadBorder_Far                  ; $74FD
    ldh [hFarcallAArg], a                         ; $7505
    farcall Border_LoadMap_LcdOff                 ; $7507
    ld a, $54                                     ; $750F
    ldh [hLycShadowSplit1], a                     ; $7511
    ldh [hSplit1Latch], a                         ; $7513
    ld hl, hStatShadow                            ; $7515
    set 6, [hl]                                   ; $7518
    ld hl, rIE                                    ; $751A
    set 1, [hl]                                   ; $751D
    ld a, $01                                     ; $751F
    ldh [hStatHandlerIndex], a                    ; $7521
    screen_on                                     ; $7523
    play_music MUSIC_ALBUM_VIEWER                 ; $752C
    call Album_DrawSliderNumber                   ; $7533
    call Pal_FadeIn                               ; $7536
    set_state STATE_0A_SLIDER_BROWSE              ; $7539
    ret                                           ; $753E


; I
Mode0A_State03_SliderBrowse::
    call Slider_DrawTimerSpark                    ; $753F
    ld a, [wSliderRedraw]                         ; $7542
    and a                                         ; $7545
    jr z, jr_004_7594                             ; $7546

    call Oam_HideUnused                           ; $7548
    ld a, [wCopyPhotoIdxA]                        ; $754B
    ldh [hFarcallAArg], a                         ; $754E
    farcall Photo_LoadToVram_Far                  ; $7550
    ld a, [wBorderNumber]                         ; $7558
    ld c, a                                       ; $755B
    push bc                                       ; $755C
    ld a, [wCopyPhotoIdxA]                        ; $755D
    ldh [hFarcallAArg], a                         ; $7560
    farcall Photo_LoadBorder_Far                  ; $7562
    pop bc                                        ; $756A
    ld a, [wBorderNumber]                         ; $756B
    cp c                                          ; $756E
    jr z, jr_004_7589                             ; $756F

    farcopy Vram_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $7571
    ldh [hFarcallAArg], a                         ; $757F
    farcall Border_LoadMap_Safe                   ; $7581

jr_004_7589:
    call Album_DrawSliderNumber                   ; $7589
    rst Rst08_WaitVBlank                          ; $758C
    call Slider_DrawTimerSpark                    ; $758D
    xor a                                         ; $7590
    ld [wSliderRedraw], a                         ; $7591

jr_004_7594:
    ldh a, [hKeysNewSticky]                       ; $7594
    and PADF_A | PADF_SELECT                      ; $7596
    jr z, jr_004_75b1                             ; $7598

    play_sfx1 SFX1_KEY_SELECT                     ; $759A
    ld a, [wCopyPhotoIdxA]                        ; $75A1
    ld hl, wPhotoCount                            ; $75A4
    cp [hl]                                       ; $75A7
    ret nc                                        ; $75A8

    call Album_LoadBorderScreen                   ; $75A9
    next_state                                    ; $75AC
    ret                                           ; $75B0


jr_004_75b1:
    ldh a, [hKeysNewSticky]                       ; $75B1
    bit PADB_B, a                                 ; $75B3
    ret z                                         ; $75B5

    play_sfx1 SFX1_KEY_B                          ; $75B6
    set_state STATE_0A_LEAVE                      ; $75BD
    ret                                           ; $75C2


; C
Mode0A_State04_PhotoArrows::
    ld a, [wBlinkCounter]                         ; $75C3
    inc a                                         ; $75C6
    ld [wBlinkCounter], a                         ; $75C7
    bit 4, a                                      ; $75CA
    jr z, jr_004_75ee                             ; $75CC

    ld a, $a3                                     ; $75CE
    ld bc, $5078                                  ; $75D0
    call Oam_AddMeta_B01_4000                     ; $75D3
    ld a, $a2                                     ; $75D6
    ld bc, $5018                                  ; $75D8
    call Oam_AddMeta_B01_4000                     ; $75DB
    ld a, $a5                                     ; $75DE
    ld bc, $1848                                  ; $75E0
    call Oam_AddMeta_B01_4000                     ; $75E3
    ld a, $a4                                     ; $75E6
    ld bc, $8848                                  ; $75E8
    call Oam_AddMeta_B01_4000                     ; $75EB

jr_004_75ee:
    ldh a, [hKeysNew]                             ; $75EE
    and PADF_B | PADF_SELECT                      ; $75F0
    jr z, jr_004_7603                             ; $75F2

    play_sfx1 SFX1_KEY_B                          ; $75F4
    call Album_LoadSliderScreen                   ; $75FB
    ld hl, wState                                 ; $75FE
    dec [hl]                                      ; $7601
    ret                                           ; $7602


jr_004_7603:
    ldh a, [hKeysNewRepeat]                       ; $7603
    and PADF_DPAD                                 ; $7605
    ret z                                         ; $7607

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7608
    xor a                                         ; $760F
    ld [wArrowAnimTick], a                        ; $7610
    ld [wArrowAnimFrame], a                       ; $7613
    ldh a, [hKeysNewRepeat]                       ; $7616
    bit PADB_LEFT, a                              ; $7618
    jr z, jr_004_7654                             ; $761A

    call Oam_ClearShadow                          ; $761C
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $761F
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $762D
    ld hl, Slide_ScyDeltaTbl                      ; $763B
    ld b, $10                                     ; $763E

jr_004_7640:
    push bc                                       ; $7640
    push hl                                       ; $7641
    ldh a, [hScxShadow]                           ; $7642
    add [hl]                                      ; $7644
    ldh [hScxShadow], a                           ; $7645
    rst Rst08_WaitVBlank                          ; $7647
    pop hl                                        ; $7648
    pop bc                                        ; $7649
    inc hl                                        ; $764A
    dec b                                         ; $764B
    jr nz, jr_004_7640                            ; $764C

    set_state STATE_0A_PAGE_LEFT                  ; $764E
    ret                                           ; $7653


jr_004_7654:
    bit 4, a                                      ; $7654
    jr z, jr_004_7690                             ; $7656

    call Oam_ClearShadow                          ; $7658
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $765B
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $7669
    ld hl, Slide_ScyDeltaTbl                      ; $7677
    ld b, $10                                     ; $767A

jr_004_767c:
    push bc                                       ; $767C
    push hl                                       ; $767D
    ldh a, [hScxShadow]                           ; $767E
    sub [hl]                                      ; $7680
    ldh [hScxShadow], a                           ; $7681
    rst Rst08_WaitVBlank                          ; $7683
    pop hl                                        ; $7684
    pop bc                                        ; $7685
    inc hl                                        ; $7686
    dec b                                         ; $7687
    jr nz, jr_004_767c                            ; $7688

    set_state STATE_0A_PAGE_RIGHT                 ; $768A
    ret                                           ; $768F


jr_004_7690:
    bit 6, a                                      ; $7690
    jr z, jr_004_76d1                             ; $7692

    call Oam_ClearShadow                          ; $7694
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $7697
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $76A5
    ld hl, Slide_ScyDeltaTbl                      ; $76B3
    ld b, $10                                     ; $76B6

jr_004_76b8:
    push bc                                       ; $76B8
    push hl                                       ; $76B9
    ldh a, [hScyShadow]                           ; $76BA
    add [hl]                                      ; $76BC
    ldh [hScyShadow], a                           ; $76BD
    cpl                                           ; $76BF
    add $64                                       ; $76C0
    ldh [hLycShadowSplit1], a                     ; $76C2
    rst Rst08_WaitVBlank                          ; $76C4
    pop hl                                        ; $76C5
    pop bc                                        ; $76C6
    inc hl                                        ; $76C7
    dec b                                         ; $76C8
    jr nz, jr_004_76b8                            ; $76C9

    set_state STATE_0A_PAGE_UP                    ; $76CB
    ret                                           ; $76D0


jr_004_76d1:
    bit 7, a                                      ; $76D1
    ret z                                         ; $76D3

    call Oam_ClearShadow                          ; $76D4
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $76D7
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $76E5
    ld hl, Slide_ScyDeltaTbl                      ; $76F3
    ld b, $10                                     ; $76F6

jr_004_76f8:
    push bc                                       ; $76F8
    push hl                                       ; $76F9
    ldh a, [hScyShadow]                           ; $76FA
    sub [hl]                                      ; $76FC
    ldh [hScyShadow], a                           ; $76FD
    cpl                                           ; $76FF
    add $64                                       ; $7700
    ldh [hLycShadowSplit1], a                     ; $7702
    rst Rst08_WaitVBlank                          ; $7704
    pop hl                                        ; $7705
    pop bc                                        ; $7706
    inc hl                                        ; $7707
    dec b                                         ; $7708
    jr nz, jr_004_76f8                            ; $7709

    set_state STATE_0A_PAGE_DOWN                  ; $770B
    ret                                           ; $7710


; C
Mode0A_State05_PageLeft::
    call AlbumPage_ReadChoiceA                    ; $7711
    call AlbumPage_DrawChoiceA                    ; $7714
    ldh a, [hKeysNew]                             ; $7717
    and PADF_A | PADF_B | PADF_RIGHT              ; $7719
    ret z                                         ; $771B

    push af                                       ; $771C
    bit 0, a                                      ; $771D
    ld a, SFX1_PAGE_STEP                          ; $771F
    call nz, Snd_Sfx1                             ; $7721
    pop af                                        ; $7724
    push af                                       ; $7725
    bit 1, a                                      ; $7726
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7728
    call nz, Snd_Sfx1                             ; $772A
    pop af                                        ; $772D
    push af                                       ; $772E
    bit 4, a                                      ; $772F
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7731
    call nz, Snd_Sfx1                             ; $7733
    pop af                                        ; $7736
    push af                                       ; $7737
    bit 0, a                                      ; $7738
    jp z, Mode0A_State05_PageLeft_SlideOut        ; $773A

    ld hl, wArrowAnimFrame                        ; $773D
    inc [hl]                                      ; $7740
    call Oam_HideUnused                           ; $7741
    rst Rst08_WaitVBlank                          ; $7744
    ld hl, $9880                                  ; $7745
    ld a, [wChoiceCursorA]                        ; $7748
    and a                                         ; $774B
    jr z, jr_004_7751                             ; $774C

    ld hl, $9980                                  ; $774E

jr_004_7751:
    call Album_DrawChoiceMarker                   ; $7751

jr_004_7754:
    call AlbumPage_DrawChoiceA                    ; $7754
    call Oam_HideUnused                           ; $7757
    rst Rst08_WaitVBlank                          ; $775A
    ld a, [wArrowAnimFrame]                       ; $775B
    cp $02                                        ; $775E
    jr nz, jr_004_7754                            ; $7760

; C: same tail as Mode09_State03_PageLeft_SlideOut in mode $0A (shares the table Tbl2FB5) (branch target; code read
; 2026-10-19)
Mode0A_State05_PageLeft_SlideOut::
    call Oam_ClearShadow                          ; $7762
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $7765
    ld b, $10                                     ; $7768

jr_004_776a:
    push bc                                       ; $776A
    push hl                                       ; $776B
    ldh a, [hScxShadow]                           ; $776C
    sub [hl]                                      ; $776E
    ldh [hScxShadow], a                           ; $776F
    rst Rst08_WaitVBlank                          ; $7771
    pop hl                                        ; $7772
    pop bc                                        ; $7773
    inc hl                                        ; $7774
    dec b                                         ; $7775
    jr nz, jr_004_776a                            ; $7776

    pop af                                        ; $7778
    bit 0, a                                      ; $7779
    jr nz, jr_004_7783                            ; $777B

    set_state STATE_0A_PHOTO_ARROWS               ; $777D
    ret                                           ; $7782


jr_004_7783:
    screen_off                                    ; $7783
    stat_irq_off                                  ; $7789
    ld a, [wCopyPhotoIdxA]                        ; $7793
    ld [wPhotoIndex], a                           ; $7796
    ld a, $01                                     ; $7799
    ld [wAbResult], a                             ; $779B
    ld a, $02                                     ; $779E
    ld [wCallerCode], a                           ; $77A0
    xor a                                         ; $77A3
    ld [wDoodleFromShutterbug], a                 ; $77A4
    ld a, [wChoiceCursorA]                        ; $77A7
    and a                                         ; $77AA
    jr nz, jr_004_77b8                            ; $77AB

    ld a, MODE_PAINT                              ; $77AD
    ld [wMode], a                                 ; $77AF
    set_state STATE_10_SETUP                      ; $77B2
    ret                                           ; $77B7


jr_004_77b8:
    ld a, MODE_STAMP                              ; $77B8
    ld [wMode], a                                 ; $77BA
    set_state STATE_11_SETUP                      ; $77BD
    ret                                           ; $77C2


; C: Up / Down toggles choice_cursor_a with a blip
AlbumPage_ReadChoiceA::
    ldh a, [hKeysNew]                             ; $77C3
    bit PADB_UP, a                                ; $77C5
    jr z, jr_004_77cc                             ; $77C7

    xor a                                         ; $77C9
    jr jr_004_77d1                                ; $77CA

jr_004_77cc:
    bit 7, a                                      ; $77CC
    ret z                                         ; $77CE

    ld a, $01                                     ; $77CF

jr_004_77d1:
    ld hl, wChoiceCursorA                         ; $77D1
    cp [hl]                                       ; $77D4
    ld [hl], a                                    ; $77D5
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $77D6
    ret                                           ; $77DD


; C: arrow sprite at the choice A position
AlbumPage_DrawChoiceA::
    ld a, [wChoiceCursorA]                        ; $77DE
    sla a                                         ; $77E1
    ld c, a                                       ; $77E3
    ld b, $00                                     ; $77E4
    ld hl, AlbumPage_ChoiceAPosTbl                ; $77E6
    add hl, bc                                    ; $77E9
    ld c, [hl]                                    ; $77EA
    inc hl                                        ; $77EB
    ld b, [hl]                                    ; $77EC
    ld a, [wArrowAnimFrame]                       ; $77ED
    cp $02                                        ; $77F0
    ret z                                         ; $77F2

    ld a, [wArrowAnimFrame]                       ; $77F3
    sla a                                         ; $77F6
    ld e, a                                       ; $77F8
    ld d, $00                                     ; $77F9
    ld hl, AlbumPage_ArrowAnimTbl                 ; $77FB
    add hl, de                                    ; $77FE
    ld a, [hl+]                                   ; $77FF
    call Oam_AddMeta_B01_4000                     ; $7800
    ld a, [wArrowAnimTick]                        ; $7803
    cp [hl]                                       ; $7806
    jr nz, jr_004_7811                            ; $7807

    ld hl, wArrowAnimFrame                        ; $7809
    inc [hl]                                      ; $780C
    xor a                                         ; $780D
    ld [wArrowAnimTick], a                        ; $780E

jr_004_7811:
    ld a, [wArrowAnimFrame]                       ; $7811
    and a                                         ; $7814
    ret z                                         ; $7815

    ld hl, wArrowAnimTick                         ; $7816
    inc [hl]                                      ; $7819
    ret                                           ; $781A


; C: L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_ChoiceAPosTbl::
    db $17, $10, $57, $10

; C: L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_ArrowAnimTbl::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode0A_State06_PageRight::
    call AlbumPage_ReadChoiceB                    ; $7825
    call AlbumPage_DrawChoiceB                    ; $7828
    ldh a, [hKeysNew]                             ; $782B
    and PADF_A | PADF_B | PADF_LEFT               ; $782D
    ret z                                         ; $782F

    push af                                       ; $7830
    bit 0, a                                      ; $7831
    ld a, SFX1_PAGE_STEP                          ; $7833
    call nz, Snd_Sfx1                             ; $7835
    pop af                                        ; $7838
    push af                                       ; $7839
    bit 1, a                                      ; $783A
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $783C
    call nz, Snd_Sfx1                             ; $783E
    pop af                                        ; $7841
    push af                                       ; $7842
    bit 5, a                                      ; $7843
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7845
    call nz, Snd_Sfx1                             ; $7847
    pop af                                        ; $784A
    push af                                       ; $784B
    bit 0, a                                      ; $784C
    jr z, jr_004_7875                             ; $784E

    ld hl, wArrowAnimFrame                        ; $7850
    inc [hl]                                      ; $7853
    call Oam_HideUnused                           ; $7854
    rst Rst08_WaitVBlank                          ; $7857
    ld hl, $9896                                  ; $7858
    ld a, [wChoiceCursorB]                        ; $785B
    and a                                         ; $785E
    jr z, jr_004_7864                             ; $785F

    ld hl, $9996                                  ; $7861

jr_004_7864:
    call Album_DrawChoiceMarker                   ; $7864

jr_004_7867:
    call AlbumPage_DrawChoiceB                    ; $7867
    call Oam_HideUnused                           ; $786A
    rst Rst08_WaitVBlank                          ; $786D
    ld a, [wArrowAnimFrame]                       ; $786E
    cp $02                                        ; $7871
    jr nz, jr_004_7867                            ; $7873

jr_004_7875:
    call Oam_ClearShadow                          ; $7875
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $7878
    ld b, $10                                     ; $787B

jr_004_787d:
    push bc                                       ; $787D
    push hl                                       ; $787E
    ldh a, [hScxShadow]                           ; $787F
    add [hl]                                      ; $7881
    ldh [hScxShadow], a                           ; $7882
    rst Rst08_WaitVBlank                          ; $7884
    pop hl                                        ; $7885
    pop bc                                        ; $7886
    inc hl                                        ; $7887
    dec b                                         ; $7888
    jr nz, jr_004_787d                            ; $7889

    pop af                                        ; $788B
    bit 0, a                                      ; $788C
    jr nz, jr_004_7896                            ; $788E

    set_state STATE_0A_PHOTO_ARROWS               ; $7890
    ret                                           ; $7895


jr_004_7896:
    ld a, [wChoiceCursorB]                        ; $7896
    and a                                         ; $7899
    jr nz, jr_004_78a2                            ; $789A

    set_state STATE_0A_FRAME_INIT                 ; $789C
    ret                                           ; $78A1


jr_004_78a2:
    set_state STATE_0A_COMMENT_INIT               ; $78A2
    ret                                           ; $78A7


; C
AlbumPage_ReadChoiceB::
    ldh a, [hKeysNew]                             ; $78A8
    bit PADB_UP, a                                ; $78AA
    jr z, jr_004_78b1                             ; $78AC

    xor a                                         ; $78AE
    jr jr_004_78b6                                ; $78AF

jr_004_78b1:
    bit 7, a                                      ; $78B1
    ret z                                         ; $78B3

    ld a, $01                                     ; $78B4

jr_004_78b6:
    ld hl, wChoiceCursorB                         ; $78B6
    cp [hl]                                       ; $78B9
    ld [hl], a                                    ; $78BA
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $78BB
    ret                                           ; $78C2


; C
AlbumPage_DrawChoiceB::
    ld a, [wChoiceCursorB]                        ; $78C3
    sla a                                         ; $78C6
    ld c, a                                       ; $78C8
    ld b, $00                                     ; $78C9
    ld hl, AlbumPage_DrawChoiceB_Tbl7900          ; $78CB
    add hl, bc                                    ; $78CE
    ld c, [hl]                                    ; $78CF
    inc hl                                        ; $78D0
    ld b, [hl]                                    ; $78D1
    ld a, [wArrowAnimFrame]                       ; $78D2
    cp $02                                        ; $78D5
    ret z                                         ; $78D7

    ld a, [wArrowAnimFrame]                       ; $78D8
    sla a                                         ; $78DB
    ld e, a                                       ; $78DD
    ld d, $00                                     ; $78DE
    ld hl, AlbumPage_DrawChoiceB_Tbl7904          ; $78E0
    add hl, de                                    ; $78E3
    ld a, [hl+]                                   ; $78E4
    call Oam_AddMeta_B01_4000                     ; $78E5
    ld a, [wArrowAnimTick]                        ; $78E8
    cp [hl]                                       ; $78EB
    jr nz, jr_004_78f6                            ; $78EC

    ld hl, wArrowAnimFrame                        ; $78EE
    inc [hl]                                      ; $78F1
    xor a                                         ; $78F2
    ld [wArrowAnimTick], a                        ; $78F3

jr_004_78f6:
    ld a, [wArrowAnimFrame]                       ; $78F6
    and a                                         ; $78F9
    ret z                                         ; $78FA

    ld hl, wArrowAnimTick                         ; $78FB
    inc [hl]                                      ; $78FE
    ret                                           ; $78FF


; C: auto: 4 bytes, bytes; referenced by AlbumPage_DrawChoiceB. L3 pass 2026-10-26: read in BGB in 43 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawChoiceB_Tbl7900::
    db $19, $90, $59, $90

; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawChoiceB. L3 pass 2026-10-26: read in BGB in 43 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawChoiceB_Tbl7904::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode0A_State07_PageUp::
    call AlbumPage_DrawUp                         ; $790A
    ldh a, [hKeysNew]                             ; $790D
    and PADF_A | PADF_B | PADF_DOWN               ; $790F
    ret z                                         ; $7911

    push af                                       ; $7912
    bit 0, a                                      ; $7913
    ld a, SFX1_PAGE_STEP                          ; $7915
    call nz, Snd_Sfx1                             ; $7917
    pop af                                        ; $791A
    push af                                       ; $791B
    bit 1, a                                      ; $791C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $791E
    call nz, Snd_Sfx1                             ; $7920
    pop af                                        ; $7923
    push af                                       ; $7924
    bit 7, a                                      ; $7925
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7927
    call nz, Snd_Sfx1                             ; $7929
    pop af                                        ; $792C
    push af                                       ; $792D
    bit 0, a                                      ; $792E
    jr z, jr_004_794e                             ; $7930

    ld hl, wArrowAnimFrame                        ; $7932
    inc [hl]                                      ; $7935
    call Oam_HideUnused                           ; $7936
    rst Rst08_WaitVBlank                          ; $7939
    ld hl, $9808                                  ; $793A
    call Album_DrawChoiceMarker                   ; $793D

jr_004_7940:
    call AlbumPage_DrawUp                         ; $7940
    call Oam_HideUnused                           ; $7943
    rst Rst08_WaitVBlank                          ; $7946
    ld a, [wArrowAnimFrame]                       ; $7947
    cp $02                                        ; $794A
    jr nz, jr_004_7940                            ; $794C

jr_004_794e:
    call Oam_ClearShadow                          ; $794E
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $7951
    ld b, $10                                     ; $7954

jr_004_7956:
    push bc                                       ; $7956
    push hl                                       ; $7957
    ldh a, [hScyShadow]                           ; $7958
    sub [hl]                                      ; $795A
    ldh [hScyShadow], a                           ; $795B
    cpl                                           ; $795D
    add $64                                       ; $795E
    ldh [hLycShadowSplit1], a                     ; $7960
    rst Rst08_WaitVBlank                          ; $7962
    pop hl                                        ; $7963
    pop bc                                        ; $7964
    inc hl                                        ; $7965
    dec b                                         ; $7966
    jr nz, jr_004_7956                            ; $7967

    pop af                                        ; $7969
    bit 0, a                                      ; $796A
    jr nz, jr_004_7974                            ; $796C

    set_state STATE_0A_PHOTO_ARROWS               ; $796E
    ret                                           ; $7973


jr_004_7974:
    screen_off                                    ; $7974
    stat_irq_off                                  ; $797A
    ld a, [wCopyPhotoIdxA]                        ; $7984
    ld [wPhotoIndex], a                           ; $7987
    ld a, $01                                     ; $798A
    ld [wAbResult], a                             ; $798C
    ld a, $02                                     ; $798F
    ld [wCallerCode], a                           ; $7991
    xor a                                         ; $7994
    ld [wPrintLayoutFlag], a                      ; $7995
    ld [wBorderNormalised], a                     ; $7998
    ld [wPrintExtraFlag], a                       ; $799B
    ld a, MODE_PRINT_PHOTO_PICKER                 ; $799E
    ld [wMode], a                                 ; $79A0
    set_state STATE_1C_SHOW_PRINT_SCREEN          ; $79A3
    ret                                           ; $79A8


; C: single item page (Print)
AlbumPage_DrawUp::
    ld bc, $3910                                  ; $79A9
    ld a, [wArrowAnimFrame]                       ; $79AC
    cp $02                                        ; $79AF
    ret z                                         ; $79B1

    ld a, [wArrowAnimFrame]                       ; $79B2
    sla a                                         ; $79B5
    ld e, a                                       ; $79B7
    ld d, $00                                     ; $79B8
    ld hl, AlbumPage_DrawUp_Tbl79DA               ; $79BA
    add hl, de                                    ; $79BD
    ld a, [hl+]                                   ; $79BE
    call Oam_AddMeta_B01_4000                     ; $79BF
    ld a, [wArrowAnimTick]                        ; $79C2
    cp [hl]                                       ; $79C5
    jr nz, jr_004_79d0                            ; $79C6

    ld hl, wArrowAnimFrame                        ; $79C8
    inc [hl]                                      ; $79CB
    xor a                                         ; $79CC
    ld [wArrowAnimTick], a                        ; $79CD

jr_004_79d0:
    ld a, [wArrowAnimFrame]                       ; $79D0
    and a                                         ; $79D3
    ret z                                         ; $79D4

    ld hl, wArrowAnimTick                         ; $79D5
    inc [hl]                                      ; $79D8
    ret                                           ; $79D9


; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawUp. L3 pass 2026-10-26: read in BGB in 63 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawUp_Tbl79DA::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode0A_State08_PageDown::
    call AlbumPage_DrawDown                       ; $79E0
    ldh a, [hKeysNew]                             ; $79E3
    and PADF_A | PADF_B | PADF_UP                 ; $79E5
    ret z                                         ; $79E7

    push af                                       ; $79E8
    bit 0, a                                      ; $79E9
    ld a, SFX1_PAGE_STEP                          ; $79EB
    call nz, Snd_Sfx1                             ; $79ED
    pop af                                        ; $79F0
    push af                                       ; $79F1
    bit 1, a                                      ; $79F2
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $79F4
    call nz, Snd_Sfx1                             ; $79F6
    pop af                                        ; $79F9
    push af                                       ; $79FA
    bit 6, a                                      ; $79FB
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $79FD
    call nz, Snd_Sfx1                             ; $79FF
    pop af                                        ; $7A02
    push af                                       ; $7A03
    bit 0, a                                      ; $7A04
    jr z, jr_004_7a24                             ; $7A06

    ld hl, wArrowAnimFrame                        ; $7A08
    inc [hl]                                      ; $7A0B
    call Oam_HideUnused                           ; $7A0C
    rst Rst08_WaitVBlank                          ; $7A0F
    ld hl, $9a88                                  ; $7A10
    call Album_DrawChoiceMarker                   ; $7A13

jr_004_7a16:
    call AlbumPage_DrawDown                       ; $7A16
    call Oam_HideUnused                           ; $7A19
    rst Rst08_WaitVBlank                          ; $7A1C
    ld a, [wArrowAnimFrame]                       ; $7A1D
    cp $02                                        ; $7A20
    jr nz, jr_004_7a16                            ; $7A22

jr_004_7a24:
    call Oam_ClearShadow                          ; $7A24
    ld hl, Mode09_State03_PageLeft_Tbl30B7        ; $7A27
    ld b, $10                                     ; $7A2A

jr_004_7a2c:
    push bc                                       ; $7A2C
    push hl                                       ; $7A2D
    ldh a, [hScyShadow]                           ; $7A2E
    add [hl]                                      ; $7A30
    ldh [hScyShadow], a                           ; $7A31
    cpl                                           ; $7A33
    add $64                                       ; $7A34
    ldh [hLycShadowSplit1], a                     ; $7A36
    rst Rst08_WaitVBlank                          ; $7A38
    pop hl                                        ; $7A39
    pop bc                                        ; $7A3A
    inc hl                                        ; $7A3B
    dec b                                         ; $7A3C
    jr nz, jr_004_7a2c                            ; $7A3D

    pop af                                        ; $7A3F
    bit 0, a                                      ; $7A40
    jr nz, jr_004_7a4a                            ; $7A42

    set_state STATE_0A_PHOTO_ARROWS               ; $7A44
    ret                                           ; $7A49


jr_004_7a4a:
    screen_off                                    ; $7A4A
    stat_irq_off                                  ; $7A50
    ld a, [wCopyPhotoIdxA]                        ; $7A5A
    ld [wPhotoIndex], a                           ; $7A5D
    ld a, $01                                     ; $7A60
    ld [wAbResult], a                             ; $7A62
    ld a, $02                                     ; $7A65
    ld [wMsgStripSel], a                          ; $7A67
    ld a, $00                                     ; $7A6A
    ld [wIconSel], a                              ; $7A6C
    ld a, $02                                     ; $7A6F
    ld [wCallerCode], a                           ; $7A71
    ld a, MODE_DELETE_PHOTO                       ; $7A74
    ld [wMode], a                                 ; $7A76
    set_state STATE_0F_CONFIRM_INIT               ; $7A79
    ret                                           ; $7A7E


; C: single item page (Delete)
AlbumPage_DrawDown::
    ld bc, $3780                                  ; $7A7F
    ld a, [wArrowAnimFrame]                       ; $7A82
    cp $02                                        ; $7A85
    ret z                                         ; $7A87

    ld a, [wArrowAnimFrame]                       ; $7A88
    sla a                                         ; $7A8B
    ld e, a                                       ; $7A8D
    ld d, $00                                     ; $7A8E
    ld hl, AlbumPage_DrawDown_Tbl7AB0             ; $7A90
    add hl, de                                    ; $7A93
    ld a, [hl+]                                   ; $7A94
    call Oam_AddMeta_B01_4000                     ; $7A95
    ld a, [wArrowAnimTick]                        ; $7A98
    cp [hl]                                       ; $7A9B
    jr nz, jr_004_7aa6                            ; $7A9C

    ld hl, wArrowAnimFrame                        ; $7A9E
    inc [hl]                                      ; $7AA1
    xor a                                         ; $7AA2
    ld [wArrowAnimTick], a                        ; $7AA3

jr_004_7aa6:
    ld a, [wArrowAnimFrame]                       ; $7AA6
    and a                                         ; $7AA9
    ret z                                         ; $7AAA

    ld hl, wArrowAnimTick                         ; $7AAB
    inc [hl]                                      ; $7AAE
    ret                                           ; $7AAF


; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawDown. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawDown_Tbl7AB0::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode0A_State09_Leave::
    screen_off                                    ; $7AB6
    stat_irq_off                                  ; $7ABC
    set_state STATE_0A_INIT                       ; $7AC6
    ret                                           ; $7ACB


; C
Mode0A_State0A_FrameInit::
    screen_off                                    ; $7ACC
    stat_irq_off                                  ; $7AD2
    xor a                                         ; $7ADC
    ld [wSubstate], a                             ; $7ADD
    next_state                                    ; $7AE0
    ret                                           ; $7AE4


; C: far call 08:4DF2
Mode0A_State0B_FrameEdit::
    ldh [hFarcallAArg], a                         ; $7AE5
    farcall BorderPicker_Far                      ; $7AE7
    ret                                           ; $7AEF


; C
Mode0A_State0C_FrameSave::
    ld a, [wCopyPhotoIdxA]                        ; $7AF0
    ldh [hFarcallAArg], a                         ; $7AF3
    farcall Photo_StoreBorder_Far                 ; $7AF5
    ld a, $01                                     ; $7AFD
    ld [wAbResult], a                             ; $7AFF
    jp Mode0A_State02_Setup                       ; $7B02


; C
Mode0A_State0D_CommentInit::
    screen_off                                    ; $7B05
    stat_irq_off                                  ; $7B0B
    ld a, [wCopyPhotoIdxA]                        ; $7B15
    ld [wCmtPhotoIndex], a                        ; $7B18
    ldh [hFarcallAArg], a                         ; $7B1B
    farcall Photo_LoadTagFields_Far               ; $7B1D
    xor a                                         ; $7B25
    ld [wSubstate], a                             ; $7B26
    next_state                                    ; $7B29
    ret                                           ; $7B2D


; C: far call 09:4281
Mode0A_State0E_CommentEdit::
    ldh [hFarcallAArg], a                         ; $7B2E
    ld a, $09                                     ; $7B30
    ld hl, CommentEditor_Far                      ; $7B32
    call Far_Call                                 ; $7B35
    ret                                           ; $7B38


; C
Mode0A_State0F_CommentSave::
    ld a, [wCopyPhotoIdxA]                        ; $7B39
    ldh [hFarcallAArg], a                         ; $7B3C
    farcall Photo_StoreTagFields_Far              ; $7B3E
    ld a, $01                                     ; $7B46
    ld [wAbResult], a                             ; $7B48
    jp Mode0A_State02_Setup                       ; $7B4B


; C: writes the 2x2 marker tiles $AC..$AF at HL
Album_DrawChoiceMarker::
    ld a, $ac                                     ; $7B4E
    call Vram_WriteByteSafe                       ; $7B50
    inc a                                         ; $7B53
    inc hl                                        ; $7B54
    call Vram_WriteByteSafe                       ; $7B55
    inc a                                         ; $7B58
    ld bc, $001f                                  ; $7B59
    add hl, bc                                    ; $7B5C
    call Vram_WriteByteSafe                       ; $7B5D
    inc a                                         ; $7B60
    inc hl                                        ; $7B61
    call Vram_WriteByteSafe                       ; $7B62
    ret                                           ; $7B65


; I
Album_LoadSliderScreen::
    call Oam_ClearShadow                          ; $7B66
    ld a, $e4                                     ; $7B69
    ldh [hBgpShadow], a                           ; $7B6B
    ldh [hObp0Shadow], a                          ; $7B6D
    ld a, $d2                                     ; $7B6F
    ldh [hObp1Shadow], a                          ; $7B71
    farcopy Vram_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $7B73
    call Album_DrawSliderNumber                   ; $7B81
    farcopy Vram_CopyFromBank, Gfx_0C_7C00_Album_LoadSliderScreen, $8900, $0200 ; $7B84
    ld a, $0c                                     ; $7B92
    ld hl, Gfx_0C_7900_Album_LoadSliderScreen     ; $7B94
    ld de, $8600                                  ; $7B97
    ld bc, $0200                                  ; $7B9A
    call Vram_CopyFromBank                        ; $7B9D
    farcopy Vram_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $7BA0
    farcopy Vram_CopyFromBank, Gfx_0C_79A0_Mode0A_State02_Setup, $8f70, $0010 ; $7BAE
    ld a, [wCopyPhotoIdxA]                        ; $7BBC
    ldh [hFarcallAArg], a                         ; $7BBF
    farcall Photo_LoadBorder_Far                  ; $7BC1
    ldh [hFarcallAArg], a                         ; $7BC9
    farcall Border_LoadMap_Safe                   ; $7BCB
    ret                                           ; $7BD3


; I
Album_LoadBorderScreen::
    call Oam_ClearShadow                          ; $7BD4
    ld a, $e4                                     ; $7BD7
    ldh [hObp0Shadow], a                          ; $7BD9
    ld a, $d2                                     ; $7BDB
    ldh [hObp1Shadow], a                          ; $7BDD
    farcopy Vram_CopyFromBank, Gfx_20_7500_Mode1D_State01_LoadScreen, $9800, $02c0 ; $7BDF
    farcopy Vram_CopyFromBank, Gfx_1A_7600_Album_ShowPageScreenB, $8900, $0700 ; $7BED
    ld a, $1c                                     ; $7BFB
    ld hl, Gfx_1C_5600_Album_ShowPageScreenB      ; $7BFD
    ld de, $87e0                                  ; $7C00
    ld bc, $0020                                  ; $7C03
    call Vram_CopyFromBank                        ; $7C06
    farcopy Vram_CopyFromBank, Map_24_73E0_Album_ShowPageScreenB, $9800, $02c0 ; $7C09
    ret                                           ; $7C17


; C: jittering metasprite $0E while slider_timer runs
Slider_DrawTimerSpark::
    ld a, [wSliderTimer]                          ; $7C18
    and a                                         ; $7C1B
    ret z                                         ; $7C1C

    dec a                                         ; $7C1D
    ld [wSliderTimer], a                          ; $7C1E
    ldh a, [hFrameCounter]                        ; $7C21
    and $01                                       ; $7C23
    jr nz, jr_004_7c33                            ; $7C25

    call Rng_Next                                 ; $7C27
    ld [wJitterX], a                              ; $7C2A
    call Rng_Next                                 ; $7C2D
    ld [wJitterY], a                              ; $7C30

jr_004_7c33:
    ld a, [wJitterX]                              ; $7C33
    and $01                                       ; $7C36
    add $14                                       ; $7C38
    ld b, a                                       ; $7C3A
    ld a, [wJitterY]                              ; $7C3B
    and $01                                       ; $7C3E
    add $14                                       ; $7C40
    ld c, a                                       ; $7C42
    ld a, $0e                                     ; $7C43
    call Oam_AddMeta_B01_4000                     ; $7C45
    ret                                           ; $7C48


; I: UNREFERENCED: Left / Right steps copy_photo_idx_a with wrap in 0..29 / 30..59
Unused_Mode0A_PhotoStepWrap::
    ld hl, hKeysRepeatSticky                      ; $7C49
    ld a, [wCopyPhotoIdxA]                        ; $7C4C
    cp $1e                                        ; $7C4F
    jr nc, jr_004_7c5b                            ; $7C51

    ld bc, $001d                                  ; $7C53
    call Photo_StepWrap                           ; $7C56
    jr jr_004_7c61                                ; $7C59

jr_004_7c5b:
    ld bc, $1e3b                                  ; $7C5B
    call Photo_StepWrap                           ; $7C5E

jr_004_7c61:
    bit 6, [hl]                                   ; $7C61
    jr nz, jr_004_7c69                            ; $7C63

    bit 7, [hl]                                   ; $7C65
    jr z, jr_004_7c6f                             ; $7C67

jr_004_7c69:
    sub $1e                                       ; $7C69
    jr nc, jr_004_7c6f                            ; $7C6B

    add $3c                                       ; $7C6D

jr_004_7c6f:
    ld hl, wCopyPhotoIdxA                         ; $7C6F
    cp [hl]                                       ; $7C72
    ret z                                         ; $7C73

    ld [hl], a                                    ; $7C74
    ld a, $b4                                     ; $7C75
    ld [wSliderTimer], a                          ; $7C77
    ld a, $01                                     ; $7C7A
    ld [wSliderRedraw], a                         ; $7C7C
    ret                                           ; $7C7F


; C: B = first C = last: Left/Right (bit 5 / 4 of HL) step A
Photo_StepWrap::
    bit 5, [hl]                                   ; $7C80
    jr z, jr_004_7c92                             ; $7C82

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7C84
    cp b                                          ; $7C8B
    jr nz, jr_004_7c90                            ; $7C8C

    ld a, c                                       ; $7C8E
    ret                                           ; $7C8F


jr_004_7c90:
    dec a                                         ; $7C90
    ret                                           ; $7C91


jr_004_7c92:
    bit 4, [hl]                                   ; $7C92
    ret z                                         ; $7C94

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7C95
    cp c                                          ; $7C9C
    jr nz, jr_004_7ca1                            ; $7C9D

    ld a, b                                       ; $7C9F
    ret                                           ; $7CA0


jr_004_7ca1:
    inc a                                         ; $7CA1
    ret                                           ; $7CA2


; C
Album_DrawSliderNumber::
    ld a, [wCopyPhotoIdxA]                        ; $7CA3
    inc a                                         ; $7CA6
    ld bc, $0000                                  ; $7CA7
    cp $1f                                        ; $7CAA
    jr c, jr_004_7cb1                             ; $7CAC

    sub $1e                                       ; $7CAE
    inc c                                         ; $7CB0

jr_004_7cb1:
    cp $0a                                        ; $7CB1
    jr c, jr_004_7cba                             ; $7CB3

    sub $0a                                       ; $7CB5
    inc b                                         ; $7CB7
    jr jr_004_7cb1                                ; $7CB8

jr_004_7cba:
    push af                                       ; $7CBA
    push bc                                       ; $7CBB
    ld de, $8f80                                  ; $7CBC
    ld a, c                                       ; $7CBF
    call Album_LoadNumeralTileB                   ; $7CC0
    pop bc                                        ; $7CC3
    ld a, b                                       ; $7CC4
    inc a                                         ; $7CC5
    inc a                                         ; $7CC6
    call Album_LoadNumeralTileB                   ; $7CC7
    pop af                                        ; $7CCA
    inc a                                         ; $7CCB
    inc a                                         ; $7CCC

; C: numeral tile (32 bytes) from bank 26:7E00
Album_LoadNumeralTileB::
    swap a                                        ; $7CCD
    ld c, a                                       ; $7CCF
    ld b, $00                                     ; $7CD0
    sla c                                         ; $7CD2
    rl b                                          ; $7CD4
    ld hl, Gfx_26_7BC0_Album_LoadNumeralTileB     ; $7CD6
    add hl, bc                                    ; $7CD9
    ld a, BANK(Gfx_26_7BC0_Album_LoadNumeralTileB) ; $7CDA
    ld bc, $0020                                  ; $7CDC
    call Vram_CopyFromBank                        ; $7CDF
    ret                                           ; $7CE2


Album_LoadNumeralTileB_7CE3:
    push bc                                       ; $7CE3
    ld c, a                                       ; $7CE4
    ld b, $00                                     ; $7CE5
    ld hl, Album_LoadNumeralTileB + $33           ; $7CE7
    add hl, bc                                    ; $7CEA
    ld c, [hl]                                    ; $7CEB
    add hl, bc                                    ; $7CEC
    pop bc                                        ; $7CED
    ld a, c                                       ; $7CEE
    sla a                                         ; $7CEF
    add c                                         ; $7CF1
    ld c, a                                       ; $7CF2
    ld b, $00                                     ; $7CF3
    add hl, bc                                    ; $7CF5
    ld c, [hl]                                    ; $7CF6
    inc hl                                        ; $7CF7
    ld b, [hl]                                    ; $7CF8
    inc hl                                        ; $7CF9
    ld a, [hl]                                    ; $7CFA
    ld l, c                                       ; $7CFB
    ld h, b                                       ; $7CFC
    jp Far_Call_Return                            ; $7CFD


    db $09, $14, $1f, $2a, $35, $40, $4b, $56, $61, $00, $5f, $0f, $80, $62, $0f, $00
    db $66, $0f, $80, $69, $0f, $00, $6d, $0f, $80, $70, $0f, $00, $74, $0f, $80, $77
    db $0f, $00, $63, $0e, $80, $66, $0e, $00, $6a, $0e, $80, $6d, $0e, $00, $71, $0e
    db $80, $74, $0e, $00, $78, $0e, $80, $7b, $0e, $00, $40, $10, $80, $43, $10, $00
    db $47, $10, $80, $4a, $10, $00, $4e, $10, $80, $51, $10, $00, $55, $10, $80, $58
    db $10, $00, $60, $29, $80, $63, $29, $00, $67, $29, $80, $6a, $29, $00, $6e, $29
    db $80, $71, $29, $00, $75, $29, $80, $78, $29, $00, $c0, $00, $80, $c3, $00, $00
    db $c7, $00, $80, $ca

    ; padding
    ds $28c, $00

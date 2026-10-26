; Pocket Camera (Japan) (Rev A), bank $04. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


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
    farcopy Vram_CopyFromBank, Map_27_4EB0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4567
    rst Rst08_WaitVBlank                          ; $4575
    ld a, [wPickerCursorTarget]                   ; $4576
    call PhotoPicker_LoadPageThumbs               ; $4579
    rst Rst08_WaitVBlank                          ; $457C
    farcopy Vram_CopyFromBank, Map_27_4CB0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $457D
    rst Rst08_WaitVBlank                          ; $458B
    farcopy Vram_CopyFromBank, Map_27_52B0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $458C
    rst Rst08_WaitVBlank                          ; $459A
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $459B
    rst Rst08_WaitVBlank                          ; $45A9
    farcopy Vram_CopyFromBank, Map_27_50B0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45AA
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
    farcopy Vram_CopyFromBank, Map_27_50B0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45D5
    rst Rst08_WaitVBlank                          ; $45E3
    ld a, [wPickerCursorTarget]                   ; $45E4
    call PhotoPicker_LoadPageTabsFor              ; $45E7
    farcopy Vram_CopyFromBank, Map_1E_7E00_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45EA
    rst Rst08_WaitVBlank                          ; $45F8
    farcopy Vram_CopyFromBank, Map_27_52B0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $45F9
    rst Rst08_WaitVBlank                          ; $4607
    farcopy Vram_CopyFromBank, Map_27_4CB0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4608
    rst Rst08_WaitVBlank                          ; $4616
    farcopy Vram_CopyFromBank, Map_27_4EB0_PhotoPicker_PageTransitionPrev, $9840, $0200 ; $4617
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
    farcopy Mem_CopyFromBank, Gfx_0D_7900_Mode0F_State05_ConfirmInit, $8900, $0700 ; $4ABC
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
    farcall Photo_LoadHotspotsTranslated_Far      ; $4B5D
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


; C: yes / no cursor sprite $C5 that shakes by one pixel
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
    add $50                                       ; $4BE1
    ld b, a                                       ; $4BE3
    ld a, [wJitterY]                              ; $4BE4
    and $01                                       ; $4BE7
    add $6b                                       ; $4BE9
    ld c, a                                       ; $4BEB
    ld a, $c5                                     ; $4BEC
    call Oam_AddMeta_B02_5272                     ; $4BEE
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
    call Oam_AddMeta_B02_5272                     ; $4C07
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
    call Oam_AddMeta_B02_5272                     ; $4E1D
    ld a, $b5                                     ; $4E20
    call Oam_AddMeta_B02_5272                     ; $4E22
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


; C: 17 records x 6 B, one per stamp category ([$D63D] x 6): {sheet pointer lo; hi; bank; block bytes lo; hi; blocks}.
; Stamp_LoadPageGfx (04:589E) steps the pointer by [$D63E] blocks and copies `blocks` consecutive blocks to VRAM $8A00
; (categories 2 and 3 have code of their own: $190 + $190 B to $8A00 / ...
Stamp_PageGfxTbl::
    dwb StampCat00_Face_Gfx
    db $80, $01, $02
    dwb StampCat01_Icons_Gfx
    db $00, $03, $01
    dwb StampCat02_Pokemon_Gfx
    db $20, $03, $01
    dwb StampCat03_CoroCoro_Gfx
    db $c0, $03, $01
    dwb StampCat04_05_SmallKana_Gfx
    db $a0, $00, $02
    dwb StampCat04_05_SmallKana_Gfx
    db $a0, $00, $02
    dwb StampCat06_07_Hiragana_Gfx
    db $40, $01, $02
    dwb StampCat06_07_Hiragana_Gfx
    db $40, $01, $02
    dwb StampCat08_09_Katakana_Gfx
    db $40, $01, $02
    dwb StampCat08_09_Katakana_Gfx
    db $40, $01, $02
    dwb StampCat10_11_Digits_Gfx
    db $40, $01, $02
    dwb StampCat10_11_Digits_Gfx
    db $40, $01, $02
    dwb StampCat12_13_Latin_Gfx
    db $40, $01, $02
    dwb StampCat12_13_Latin_Gfx
    db $40, $01, $02
    dwb StampCat14_15_Kanji_Gfx
    db $40, $01, $02
    dwb StampCat14_15_Kanji_Gfx
    db $40, $01, $02
    dwb StampCat16_Symbols_Gfx
    db $40, $01, $02

; C: 17 x {lo; hi; bank} by category ([$D63D] x 3): $60 B of icon tiles copied to VRAM $8F00 by
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
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    dwb Sheet_MiscellaneousStampsJpn_1D_78E0
    dwb Src_1D_7940_Tbl539D_5
    dwb Src_1D_7A00_Tbl539D_16

; C: 17 x {lo; hi; bank} by category: $60 B of icon tiles copied to VRAM $8F60 by Stamp_LoadCategoryIcons; the
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
    dwb Src_1D_7C40_Tbl539D_27
    dwb Src_1D_7C40_Tbl539D_27
    dwb Src_1D_7B80_Tbl539D_29
    dwb Src_1D_7B80_Tbl539D_29
    dwb Src_1D_7DC0_Tbl539D_31
    dwb Src_1D_7DC0_Tbl539D_31
    dwb Src_1D_7D00_Tbl539D_33

; C: 17 x {lo; hi; bank} by category: the $120 B BG map (9 rows) copied to VRAM $9C00 by Stamp_LoadCategoryIcons; read
; again by Stamp_ReloadTilemapIfDifferent; the pointers are the Src_*_Tbl539D_* rows
Stamp_CatMapSrcTbl::
    dwb Src_27_72D0_Tbl539D_34
    dwb Src_27_6C10_Tbl539D_35
    dwb Src_27_6F70_Tbl539D_36
    dwb Src_27_73F0_Tbl539D_37
    dwb Src_27_6AF0_Tbl539D_38
    dwb Src_27_6AF0_Tbl539D_38
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40
    dwb Src_25_7EE0_Tbl539D_40

; C: 17 records x 5 B by category ([$D63D] x 5): {sheet pointer lo; hi; bank; bytes per stamp lo; hi};
; Stamp_CopyStampTiles (04:5A73) steps the pointer by [$D63F] stamps and copies one stamp to wIconSrcGfx ($C3C0) in
; Stamp_PrepareBuffers. Pointers = the StampCat*_Gfx rows. Decoded 2026-10-19
Stamp_IconSrcGfxTbl::
    dwb StampCat00_Face_Gfx
    db $80, $00
    dwb StampCat01_Icons_Gfx
    db $00, $01
    dwb StampCat02_Pokemon_Gfx
    db $90, $01
    dwb StampCat03_CoroCoro_Gfx
    db $e0, $01
    dwb StampCat04_05_SmallKana_Gfx
    db $20, $00
    dwb StampCat04_05_SmallKana_Gfx
    db $20, $00
    dwb StampCat06_07_Hiragana_Gfx
    db $40, $00
    dwb StampCat06_07_Hiragana_Gfx
    db $40, $00
    dwb StampCat08_09_Katakana_Gfx
    db $40, $00
    dwb StampCat08_09_Katakana_Gfx
    db $40, $00
    dwb StampCat10_11_Digits_Gfx
    db $40, $00
    dwb StampCat10_11_Digits_Gfx
    db $40, $00
    dwb StampCat12_13_Latin_Gfx
    db $40, $00
    dwb StampCat12_13_Latin_Gfx
    db $40, $00
    dwb StampCat14_15_Kanji_Gfx
    db $40, $00
    dwb StampCat14_15_Kanji_Gfx
    db $40, $00
    dwb StampCat16_Symbols_Gfx
    db $40, $00

; C: 17 records x 5 B by category: {mask pointer lo; hi; bank; bytes per stamp lo; hi}: the 1bpp mask of the stamp,
; copied to wIconSrcMask ($C5A0) in Stamp_PrepareBuffers. Not tile data: records 0-3 and 16 point to the
; StampCat*_Mask rows, records 4-15 have bank $00 / $FF (no mask: Stamp_CopyStampTiles ...
Stamp_IconSrcMaskTbl::
    dwb StampCat00_Mask
    db $40, $00
    dwb StampCat01_Mask
    db $80, $00
    dwb StampCat02_Mask
    db $c8, $00
    dwb StampCat03_Mask
    db $f0, $00, $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20
    db $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00
    db $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00, $ff, $ff, $ff, $20, $00, $00
    db $00, $00, $20, $00, $ff, $ff, $ff, $20, $00, $00, $00, $00, $20, $00
    dwb StampCat16_Mask
    db $20, $00

; C: auto: 11 bytes, bytes; referenced by Stamp_BuildGraphicsLayer, Stamp_BuildMaskLayer. L3 pass 2026-10-26: read in
; BGB in 33 replay(s) of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_BuildGraphicsLayer_Tbl54E0::
    db $04, $02, $04, $04, $05, $05, $05, $06, $01, $02, $01

    ; padding
    ds $17, $02

; C: auto: 96 bytes, word table; referenced by Stamp_DrawPaletteCursor. L3 pass 2026-10-26: read in BGB in 2 replay(s)
; of the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_DrawPaletteCursor_PtrTbl5502::
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $22
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $56
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $5C
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $5C
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $42
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $42
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
    dw Stamp_DrawPaletteCursor_PtrTbl5502 + $2E
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

; C: auto: 17 bytes, bytes; referenced by Stamp_DrawPaletteCursor. L3 pass 2026-10-26: read in BGB in 2 replay(s) of
; the organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_DrawPaletteCursor_Tbl5562::
    db $33, $3b, $3d, $3f, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37, $37
    db $37

; C: auto: 17 bytes, bytes; referenced by Main_Entry. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the organic
; corpus, modes 19 (tcrf_check/assets/l3_names/)
Main_Entry_Tbl5573::
    db $00, $02, $01, $01, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04

; C: auto: 118 bytes, bytes; referenced by Stamp_PaletteInput. L3 pass 2026-10-26: read in BGB in 203 replay(s) of the
; organic corpus, modes 11 19 (tcrf_check/assets/l3_names/)
Stamp_PaletteInput_Tbl5584::
    dw Stamp_PaletteInput_Tbl5584 + $22
    dw Stamp_PaletteInput_Tbl5584 + $62
    dw Stamp_PaletteInput_Tbl5584 + $6E
    dw Stamp_PaletteInput_Tbl5584 + $6E
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    dw Stamp_PaletteInput_Tbl5584 + $3A
    db $00, $04, $f5, $0c, $fc, $04, $f5, $0c, $fc, $03, $f5, $0c, $00, $04, $f4, $0e
    db $fc, $04, $f4, $0e, $fc, $03, $f4, $0e, $00, $04, $ed, $14, $fc, $04, $ed, $14
    db $fc, $04, $ed, $14, $fc, $04, $ed, $14, $fc, $03, $ed, $14, $00, $04, $ec, $16
    db $fc, $04, $ec, $16, $fc, $04, $ec, $16, $fc, $04, $ec, $16, $fc, $03, $ec, $16
    db $00, $04, $f5, $0e, $fc, $04, $f5, $0e, $fc, $03, $f5, $0e, $00, $04, $f9, $0a
    db $fc, $03, $f9, $0a

; C: auto: 17 bytes, bytes; referenced by Stamp_PaletteInput. L3 pass 2026-10-26: read in BGB in 1 replay(s) of the
; organic corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_PaletteInput_Tbl55FA::
    db $13, $0e, $09, $04, $2f, $2f, $10, $10, $0f, $0f, $02, $02, $0a, $0a, $10, $10
    db $0b

; C: 17 code pointers (5634 / 562D / 563D) selected by category
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
    dw Stamp_PageTimes5
    dw Stamp_PageTimes5

; C: A = stamp_page * 2
Stamp_PageTimes2::
    ld a, [wStampPage]                            ; $562D
    sla a                                         ; $5630
    pop hl                                        ; $5632
    ret                                           ; $5633


; C: A = stamp_page * 3
Stamp_PageTimes3::
    ld a, [wStampPage]                            ; $5634
    ld c, a                                       ; $5637
    sla a                                         ; $5638
    add c                                         ; $563A
    pop hl                                        ; $563B
    ret                                           ; $563C


; C: A = stamp_page * 5
Stamp_PageTimes5::
    ld a, [wStampPage]                            ; $563D
    ld c, a                                       ; $5640
    sla a                                         ; $5641
    sla a                                         ; $5643
    add c                                         ; $5645
    pop hl                                        ; $5646
    ret                                           ; $5647


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

; C: 17 code pointers to 56BF / 56E1 / 56E9 / 56F1 / 56C7 / 56CC / 56D4 / 56D9 (OAM metasprite lists). L3 pass
; 2026-10-26: not reached by the 206 BGB replays; read in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz, first read in mode 0F 11)
Stamp_PaletteCursorFnTbl::
    db $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0, $70, $f0, $80, $f0
    db $70

; C: auto: 17 bytes, tile data; referenced by Stamp_MirrorBuffer, Stamp_MirrorGfxBuffer, Stamp_MirrorMaskBuffer. L3
; pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code: table
; read by Stamp_MirrorBuffer / Stamp_MirrorGfxBuffer / ...
Stamp_MirrorBuffer_Gfx568C::
    db $04, $04, $05, $05, $01, $01, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02

; C: auto: 92 bytes, bytes; referenced by Stamp_Commit. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic
; corpus, modes 11 (tcrf_check/assets/l3_names/)
Stamp_Commit_Tbl569D::
    dw Stamp_Commit_Tbl569D + $22
    dw Stamp_Commit_Tbl569D + $44
    dw Stamp_Commit_Tbl569D + $4C
    dw Stamp_Commit_Tbl569D + $54
    dw Stamp_Commit_Tbl569D + $2A
    dw Stamp_Commit_Tbl569D + $2F
    dw Stamp_Commit_Tbl569D + $37
    dw Stamp_Commit_Tbl569D + $3C
    dw Stamp_Commit_Tbl569D + $37
    dw Stamp_Commit_Tbl569D + $3C
    dw Stamp_Commit_Tbl569D + $37
    dw Stamp_Commit_Tbl569D + $3C
    dw Stamp_Commit_Tbl569D + $37
    dw Stamp_Commit_Tbl569D + $3C
    dw Stamp_Commit_Tbl569D + $37
    dw Stamp_Commit_Tbl569D + $3C
    dw Stamp_Commit_Tbl569D + $3C
    db $20, $10, $c0, $c3, $00, $a0, $c5, $00, $88, $10, $c0, $c3, $00, $08, $10, $c0
    db $c3, $00, $a0, $c5, $00, $90, $10, $c0, $c3, $00, $10, $10, $c0, $c3, $00, $a0
    db $c5, $00, $20, $20, $c0, $c3, $00, $a0, $c5, $00, $28, $28, $c0, $c3, $00, $a0
    db $c5, $00, $28, $30, $c0, $c3, $00, $a0, $c5, $00

; C: mode 11: STAMP tool
Mode11_Stamp::
    ld a, [wState]                                ; $56F9
    rst Rst18_JumpTable                           ; $56FC

; C: 9 states, rst $18 table of mode $11
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
    ld a, $00                                     ; $570F
    ld [wMsgStripSel], a                          ; $5711
    ld a, $05                                     ; $5714
    ld [wIconSel], a                              ; $5716
    xor a                                         ; $5719
    ld [wSubstate], a                             ; $571A
    ld [wStockNavAllowed], a                      ; $571D
    ld [wCallerCode], a                           ; $5720
    next_state                                    ; $5723
    ret                                           ; $5727


; C: far call to the photo grid picker
Mode11_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $5728
    ld a, $04                                     ; $572A
    ld hl, PhotoPicker_Far                        ; $572C
    call Far_Call                                 ; $572F
    ret                                           ; $5732


; C: loads the stamp palette screen and the 17 categories
Mode11_State02_Setup::
    ld a, [wAbResult]                             ; $5733
    bit 0, a                                      ; $5736
    jr nz, jr_004_5745                            ; $5738

    ld a, MODE_DOODLE_MENU                        ; $573A
    ld [wMode], a                                 ; $573C
    set_state STATE_04_INIT                       ; $573F
    ret                                           ; $5744


jr_004_5745:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $5745
    ldh [hLcdcShadow], a                          ; $5747
    ld a, $e4                                     ; $5749
    ld [wPaletteTarget], a                        ; $574B
    ld [wPaletteTarget + $2], a                   ; $574E
    ld a, $d2                                     ; $5751
    ld [wPaletteTarget + $1], a                   ; $5753
    ld a, $10                                     ; $5756
    ldh [hScxShadow], a                           ; $5758
    ldh [hScyShadow], a                           ; $575A
    ld a, $07                                     ; $575C
    ldh [hWxShadow], a                            ; $575E
    ld a, $94                                     ; $5760
    ldh [hWyShadow], a                            ; $5762
    ld a, $40                                     ; $5764
    ld [wCursorX], a                              ; $5766
    ld a, $38                                     ; $5769
    ld [wCursorY], a                              ; $576B
    xor a                                         ; $576E
    ld [wCursorXFrac], a                          ; $576F
    ld [wCursorYFrac], a                          ; $5772
    ld [wCursorVx], a                             ; $5775
    ld [wCursorVy], a                             ; $5778
    xor a                                         ; $577B
    ld [wStampPaletteFocus], a                    ; $577C
    farcopy Mem_CopyFromBank, Gfx_22_6740_Mode11_State02_Setup, $8900, $00d0 ; $577F
    farcopy Mem_CopyFromBank, Gfx_22_6810_Mode11_State02_Setup, $8d60, $02a0 ; $578D
    farcopy Mem_CopyFromBank, Gfx_22_6AB0_Mode11_State02_Setup, $8500, $0010 ; $579B
    farcopy Mem_CopyFromBank, Map_25_4DC0_Mode11_State02_Setup, $9800, $02c0 ; $57A9
    ld a, [wCategoryIndex]                        ; $57B7
    ld c, a                                       ; $57BA
    ld b, $00                                     ; $57BB
    ld hl, wCategoryPosB                          ; $57BD
    add hl, bc                                    ; $57C0
    ld a, [hl]                                    ; $57C1
    ld [wStampPage], a                            ; $57C2
    ld hl, wCategoryPosA                          ; $57C5
    add hl, bc                                    ; $57C8
    ld a, [hl]                                    ; $57C9
    ld [wStampItem], a                            ; $57CA
    ld a, [wDoodleFromShutterbug]                 ; $57CD
    and a                                         ; $57D0
    jr nz, jr_004_57e5                            ; $57D1

    ld a, [wPhotoIndex]                           ; $57D3
    ld [wCopyPhotoIdxD], a                        ; $57D6
    ldh [hFarcallAArg], a                         ; $57D9
    farcall Photo_LoadToVram_Far                  ; $57DB
    jr jr_004_5819                                ; $57E3

jr_004_57e5:
    ldh [hFarcallAArg], a                         ; $57E5
    farcall GameFace_Load_Far                     ; $57E7
    ld a, $00                                     ; $57EF
    ld hl, wPhotoImage                            ; $57F1
    ld de, $9000                                  ; $57F4
    ld bc, $0800                                  ; $57F7
    call Mem_CopyFromBank                         ; $57FA
    ld a, $00                                     ; $57FD
    ld hl, wPhotoImage + $800                     ; $57FF
    ld de, $8800                                  ; $5802
    ld bc, $0100                                  ; $5805
    call Mem_CopyFromBank                         ; $5808
    ld a, $00                                     ; $580B
    ld hl, wPhotoImage + $900                     ; $580D
    ld de, $8000                                  ; $5810
    ld bc, $0500                                  ; $5813
    call Mem_CopyFromBank                         ; $5816

jr_004_5819:
    xor a                                         ; $5819
    ld [wDirtyFlag], a                            ; $581A
    ldh [hFarcallAArg], a                         ; $581D
    farcall Counters_Load_Far                     ; $581F
    ld a, [wBestBall + $1]                        ; $5827
    cp $05                                        ; $582A
    jr c, jr_004_5830                             ; $582C

    ld a, $05                                     ; $582E

jr_004_5830:
    add $04                                       ; $5830
    ld [wStampPageLimitC2], a                     ; $5832
    ld a, $54                                     ; $5835
    ldh [hLycShadowSplit1], a                     ; $5837
    ldh [hSplit1Latch], a                         ; $5839
    ld hl, hStatShadow                            ; $583B
    set 6, [hl]                                   ; $583E
    ld hl, rIE                                    ; $5840
    set 1, [hl]                                   ; $5843
    ld a, $01                                     ; $5845
    ldh [hStatHandlerIndex], a                    ; $5847
    screen_on                                     ; $5849
    play_music MUSIC_STAMP                        ; $5852
    call Pal_FadeIn                               ; $5859
    call Stamp_PrepareBuffers                     ; $585C
    ld hl, hLcdcShadow                            ; $585F
    set 2, [hl]                                   ; $5862
    set_state STATE_11_PLACE                      ; $5864
    ret                                           ; $5869


; C: loads the fallback tilemap (bank 27) when the pointers of two categories differ
Stamp_ReloadTilemapIfDifferent::
    ld a, c                                       ; $586A
    sla a                                         ; $586B
    add c                                         ; $586D
    ld c, a                                       ; $586E
    ld hl, Stamp_CatMapSrcTbl                     ; $586F
    add hl, bc                                    ; $5872
    ld c, l                                       ; $5873
    ld b, h                                       ; $5874
    ld a, e                                       ; $5875
    sla a                                         ; $5876
    add e                                         ; $5878
    ld e, a                                       ; $5879
    ld hl, Stamp_CatMapSrcTbl                     ; $587A
    add hl, de                                    ; $587D
    ld a, [bc]                                    ; $587E
    cp [hl]                                       ; $587F
    jr nz, jr_004_588f                            ; $5880

    inc hl                                        ; $5882
    inc bc                                        ; $5883
    ld a, [bc]                                    ; $5884
    cp [hl]                                       ; $5885
    jr nz, jr_004_588f                            ; $5886

    inc hl                                        ; $5888
    inc bc                                        ; $5889
    ld a, [bc]                                    ; $588A
    cp [hl]                                       ; $588B
    jr nz, jr_004_588f                            ; $588C

    ret                                           ; $588E


jr_004_588f:
    farcopy Vram_CopyFromBank, Map_27_71B0_Stamp_ReloadTilemapIfDifferent, $9c00, $0120 ; $588F
    ret                                           ; $589D


; C: page graphics of the current category to $8A00 / $8510
Stamp_LoadPageGfx::
    ld a, [wCategoryIndex]                        ; $589E
    sla a                                         ; $58A1
    ld c, a                                       ; $58A3
    sla a                                         ; $58A4
    add c                                         ; $58A6
    ld c, a                                       ; $58A7
    ld b, $00                                     ; $58A8
    ld hl, Stamp_PageGfxTbl                       ; $58AA
    add hl, bc                                    ; $58AD
    ld c, [hl]                                    ; $58AE
    inc hl                                        ; $58AF
    ld b, [hl]                                    ; $58B0
    inc hl                                        ; $58B1
    ld a, [hl+]                                   ; $58B2
    ldh [hScratchA], a                            ; $58B3
    push bc                                       ; $58B5
    ld c, [hl]                                    ; $58B6
    inc hl                                        ; $58B7
    ld b, [hl]                                    ; $58B8
    inc hl                                        ; $58B9
    ld a, [hl]                                    ; $58BA
    ldh [hScratchB], a                            ; $58BB
    pop hl                                        ; $58BD
    ld a, [wStampPage]                            ; $58BE
    and a                                         ; $58C1
    jr z, jr_004_58c8                             ; $58C2

jr_004_58c4:
    add hl, bc                                    ; $58C4
    dec a                                         ; $58C5
    jr nz, jr_004_58c4                            ; $58C6

jr_004_58c8:
    ld a, [wCategoryIndex]                        ; $58C8
    cp $02                                        ; $58CB
    jr z, jr_004_58ed                             ; $58CD

    cp $03                                        ; $58CF
    jr z, jr_004_5906                             ; $58D1

    ld de, $8a00                                  ; $58D3
    ldh a, [hScratchB]                            ; $58D6

jr_004_58d8:
    push af                                       ; $58D8
    push hl                                       ; $58D9
    push de                                       ; $58DA
    push bc                                       ; $58DB
    ldh a, [hScratchA]                            ; $58DC
    call Vram_CopyFromBank                        ; $58DE
    pop bc                                        ; $58E1
    pop hl                                        ; $58E2
    add hl, bc                                    ; $58E3
    ld e, l                                       ; $58E4
    ld d, h                                       ; $58E5
    pop hl                                        ; $58E6
    add hl, bc                                    ; $58E7
    pop af                                        ; $58E8
    dec a                                         ; $58E9
    jr nz, jr_004_58d8                            ; $58EA

    ret                                           ; $58EC


jr_004_58ed:
    ld de, $8a00                                  ; $58ED
    ld bc, $0190                                  ; $58F0
    push hl                                       ; $58F3
    push bc                                       ; $58F4
    ldh a, [hScratchA]                            ; $58F5
    call Vram_CopyFromBank                        ; $58F7
    pop bc                                        ; $58FA
    pop hl                                        ; $58FB
    add hl, bc                                    ; $58FC
    ld de, $8510                                  ; $58FD
    ldh a, [hScratchA]                            ; $5900
    call Vram_CopyFromBank                        ; $5902
    ret                                           ; $5905


jr_004_5906:
    ld de, $8a00                                  ; $5906
    ld bc, $0360                                  ; $5909
    push hl                                       ; $590C
    push bc                                       ; $590D
    ldh a, [hScratchA]                            ; $590E
    call Vram_CopyFromBank                        ; $5910
    pop bc                                        ; $5913
    pop hl                                        ; $5914
    add hl, bc                                    ; $5915
    ld bc, $0060                                  ; $5916
    ld de, $8510                                  ; $5919
    ldh a, [hScratchA]                            ; $591C
    call Vram_CopyFromBank                        ; $591E
    ret                                           ; $5921


; C: two 96-byte tile sets ($8F00
Stamp_LoadCategoryIcons::
    ld a, [wCategoryIndex]                        ; $5922
    ld c, a                                       ; $5925
    sla a                                         ; $5926
    add c                                         ; $5928
    ld c, a                                       ; $5929
    ld b, $00                                     ; $592A
    push bc                                       ; $592C
    ld hl, Stamp_CatIconSrcTbl1                   ; $592D
    add hl, bc                                    ; $5930
    ld a, [hl+]                                   ; $5931
    ld c, a                                       ; $5932
    ld a, [hl+]                                   ; $5933
    ld b, a                                       ; $5934
    ld a, [hl]                                    ; $5935
    ld l, c                                       ; $5936
    ld h, b                                       ; $5937
    ld de, $8f00                                  ; $5938
    ld bc, $0060                                  ; $593B
    call Vram_CopyFromBank                        ; $593E
    pop bc                                        ; $5941
    push bc                                       ; $5942
    ld hl, Stamp_CatIconSrcTbl2                   ; $5943
    add hl, bc                                    ; $5946
    ld a, [hl+]                                   ; $5947
    ld c, a                                       ; $5948
    ld a, [hl+]                                   ; $5949
    ld b, a                                       ; $594A
    ld a, [hl]                                    ; $594B
    ld l, c                                       ; $594C
    ld h, b                                       ; $594D
    ld de, $8f60                                  ; $594E
    ld bc, $0060                                  ; $5951
    call Vram_CopyFromBank                        ; $5954
    pop bc                                        ; $5957
    ld hl, Stamp_CatMapSrcTbl                     ; $5958
    add hl, bc                                    ; $595B
    ld a, [hl+]                                   ; $595C
    ld c, a                                       ; $595D
    ld a, [hl+]                                   ; $595E
    ld b, a                                       ; $595F
    ld a, [hl]                                    ; $5960
    ld l, c                                       ; $5961
    ld h, b                                       ; $5962
    ld de, $9c00                                  ; $5963
    ld bc, $0120                                  ; $5966
    call Vram_CopyFromBank                        ; $5969
    ret                                           ; $596C


; C: category column / stamp grid; A takes a stamp (slides the palette away)
Mode11_State03_Palette::
    call Stamp_DrawPaletteCursor                  ; $596D
    call Stamp_PaletteInput                       ; $5970
    ld a, [wStampPaletteFocus]                    ; $5973
    and a                                         ; $5976
    jr z, jr_004_59f1                             ; $5977

    ldh a, [hKeysNewRepeat]                       ; $5979
    and PADF_UP | PADF_DOWN                       ; $597B
    jr z, jr_004_59f1                             ; $597D

    play_sfx1 SFX1_KEY_UP_DOWN                    ; $597F
    ld a, [wCategoryIndex]                        ; $5986
    ld c, a                                       ; $5989
    ld b, $00                                     ; $598A
    ld hl, wCategoryPosB                          ; $598C
    add hl, bc                                    ; $598F
    ld a, [wStampPage]                            ; $5990
    ld [hl], a                                    ; $5993
    ld hl, wCategoryPosA                          ; $5994
    add hl, bc                                    ; $5997
    ld a, [wStampItem]                            ; $5998
    ld [hl], a                                    ; $599B
    ldh a, [hKeysNewRepeat]                       ; $599C
    ld b, a                                       ; $599E
    ld a, [wCategoryIndex]                        ; $599F
    ld e, a                                       ; $59A2
    ld d, $00                                     ; $59A3
    bit 6, b                                      ; $59A5
    jr z, jr_004_59bc                             ; $59A7

    and a                                         ; $59A9
    ret z                                         ; $59AA

    dec a                                         ; $59AB
    cp $03                                        ; $59AC
    jr nz, jr_004_59d1                            ; $59AE

    ld c, a                                       ; $59B0
    ld a, [wCoroFlag]                             ; $59B1
    cp $01                                        ; $59B4
    ld a, c                                       ; $59B6
    jr z, jr_004_59d1                             ; $59B7

    dec a                                         ; $59B9
    jr jr_004_59d1                                ; $59BA

jr_004_59bc:
    bit 7, b                                      ; $59BC
    ret z                                         ; $59BE

    cp $10                                        ; $59BF
    ret z                                         ; $59C1

    inc a                                         ; $59C2
    cp $03                                        ; $59C3
    jr nz, jr_004_59d1                            ; $59C5

    ld c, a                                       ; $59C7
    ld a, [wCoroFlag]                             ; $59C8
    cp $01                                        ; $59CB
    ld a, c                                       ; $59CD
    jr z, jr_004_59d1                             ; $59CE

    inc a                                         ; $59D0

jr_004_59d1:
    ld [wCategoryIndex], a                        ; $59D1
    ld c, a                                       ; $59D4
    ld b, $00                                     ; $59D5
    ld hl, wCategoryPosB                          ; $59D7
    add hl, bc                                    ; $59DA
    ld a, [hl]                                    ; $59DB
    ld [wStampPage], a                            ; $59DC
    ld hl, wCategoryPosA                          ; $59DF
    add hl, bc                                    ; $59E2
    ld a, [hl]                                    ; $59E3
    ld [wStampItem], a                            ; $59E4
    call Stamp_ReloadTilemapIfDifferent           ; $59E7
    call Stamp_LoadPageGfx                        ; $59EA
    call Stamp_LoadCategoryIcons                  ; $59ED
    ret                                           ; $59F0


jr_004_59f1:
    ldh a, [hKeysNew]                             ; $59F1
    bit PADB_A, a                                 ; $59F3
    jr z, jr_004_59fe                             ; $59F5

    ld a, [wStampPaletteFocus]                    ; $59F7
    and a                                         ; $59FA
    ret nz                                        ; $59FB

    jr jr_004_5a01                                ; $59FC

jr_004_59fe:
    bit 1, a                                      ; $59FE
    ret z                                         ; $5A00

jr_004_5a01:
    call Oam_ClearShadow                          ; $5A01
    call Stamp_PaletteSlideIn                     ; $5A04
    call Stamp_PrepareBuffers                     ; $5A07
    ld hl, hLcdcShadow                            ; $5A0A
    set 2, [hl]                                   ; $5A0D
    set_state STATE_11_PLACE                      ; $5A0F
    ret                                           ; $5A14


; C: clears the four work buffers and rebuilds graphics and mask of the current stamp
Stamp_PrepareBuffers::
    ld a, $b4                                     ; $5A15
    ld [wStampRotateTimer], a                     ; $5A17
    ld hl, wIconTiles1                            ; $5A1A
    ld bc, $01e0                                  ; $5A1D
    call Mem_Zero                                 ; $5A20
    ld hl, wIconSrcGfx                            ; $5A23
    ld bc, $01e0                                  ; $5A26
    call Mem_Zero                                 ; $5A29
    ld hl, wIconTiles2                            ; $5A2C
    ld bc, $01e0                                  ; $5A2F
    call Mem_Zero                                 ; $5A32
    ld hl, wIconSrcMask                           ; $5A35
    ld bc, $00f0                                  ; $5A38
    call Mem_Zero                                 ; $5A3B
    ld hl, Stamp_IconSrcGfxTbl                    ; $5A3E
    ld de, wIconSrcGfx                            ; $5A41
    call Stamp_CopyStampTiles                     ; $5A44
    ld hl, Stamp_IconSrcMaskTbl                   ; $5A47
    ld de, wIconSrcMask                           ; $5A4A
    call Stamp_CopyStampTiles                     ; $5A4D
    call Stamp_BuildGraphicsLayer                 ; $5A50
    call Stamp_BuildMaskLayer                     ; $5A53
    ld a, $00                                     ; $5A56
    ld hl, wIconTiles1                            ; $5A58
    ld de, $8a00                                  ; $5A5B
    ld bc, $01e0                                  ; $5A5E
    call Vram_CopyFromBank                        ; $5A61
    ld a, $00                                     ; $5A64
    ld hl, wIconTiles2                            ; $5A66
    ld de, $8520                                  ; $5A69
    ld bc, $01e0                                  ; $5A6C
    call Vram_CopyFromBank                        ; $5A6F
    ret                                           ; $5A72


; C: copies the graphics of the current stamp into a buffer
Stamp_CopyStampTiles::
    ld a, [wCategoryIndex]                        ; $5A73
    ld c, a                                       ; $5A76
    sla a                                         ; $5A77
    sla a                                         ; $5A79
    add c                                         ; $5A7B
    ld c, a                                       ; $5A7C
    ld b, $00                                     ; $5A7D
    add hl, bc                                    ; $5A7F
    ld c, [hl]                                    ; $5A80
    inc hl                                        ; $5A81
    ld b, [hl]                                    ; $5A82
    inc hl                                        ; $5A83
    ld a, [hl+]                                   ; $5A84
    push af                                       ; $5A85
    push bc                                       ; $5A86
    ld c, [hl]                                    ; $5A87
    inc hl                                        ; $5A88
    ld b, [hl]                                    ; $5A89
    pop hl                                        ; $5A8A
    ld a, [wStampItem]                            ; $5A8B
    and a                                         ; $5A8E
    jr z, jr_004_5a95                             ; $5A8F

jr_004_5a91:
    add hl, bc                                    ; $5A91
    dec a                                         ; $5A92
    jr nz, jr_004_5a91                            ; $5A93

jr_004_5a95:
    pop af                                        ; $5A95
    and a                                         ; $5A96
    jr z, jr_004_5aa1                             ; $5A97

    cp $ff                                        ; $5A99
    jr z, jr_004_5aa1                             ; $5A9B

    call Mem_CopyFromBank                         ; $5A9D
    ret                                           ; $5AA0


jr_004_5aa1:
    ldh [hScratchA], a                            ; $5AA1

jr_004_5aa3:
    ldh a, [hScratchA]                            ; $5AA3
    ld [de], a                                    ; $5AA5
    inc de                                        ; $5AA6
    dec bc                                        ; $5AA7
    ld a, c                                       ; $5AA8
    or b                                          ; $5AA9
    jr nz, jr_004_5aa3                            ; $5AAA

    ret                                           ; $5AAC


; C
Stamp_BuildGraphicsLayer::
    ld a, [wCategoryIndex]                        ; $5AAD
    sla a                                         ; $5AB0
    ld c, a                                       ; $5AB2
    ld b, $00                                     ; $5AB3
    ld hl, Stamp_BuildGraphicsLayer_Tbl54E0       ; $5AB5
    add hl, bc                                    ; $5AB8
    ld c, [hl]                                    ; $5AB9
    inc hl                                        ; $5ABA
    ld b, [hl]                                    ; $5ABB
    xor a                                         ; $5ABC
    ldh [hScratchA], a                            ; $5ABD
    ld hl, wIconSrcGfx                            ; $5ABF
    ld de, wIconTiles1                            ; $5AC2

jr_004_5ac5:
    push bc                                       ; $5AC5
    push de                                       ; $5AC6

jr_004_5ac7:
    ld b, $10                                     ; $5AC7

jr_004_5ac9:
    ld a, [hl+]                                   ; $5AC9
    ld [de], a                                    ; $5ACA
    inc de                                        ; $5ACB
    dec b                                         ; $5ACC
    jr nz, jr_004_5ac9                            ; $5ACD

    ld a, e                                       ; $5ACF
    add $10                                       ; $5AD0
    ld e, a                                       ; $5AD2
    jr nc, jr_004_5ad6                            ; $5AD3

    inc d                                         ; $5AD5

jr_004_5ad6:
    dec c                                         ; $5AD6
    jr nz, jr_004_5ac7                            ; $5AD7

    pop de                                        ; $5AD9
    pop bc                                        ; $5ADA
    ldh a, [hScratchA]                            ; $5ADB
    and a                                         ; $5ADD
    jr nz, jr_004_5aed                            ; $5ADE

    ld a, e                                       ; $5AE0
    add $10                                       ; $5AE1
    ld e, a                                       ; $5AE3
    jr nc, jr_004_5ae7                            ; $5AE4

    inc d                                         ; $5AE6

jr_004_5ae7:
    ld a, $01                                     ; $5AE7
    ldh [hScratchA], a                            ; $5AE9
    jr jr_004_5af7                                ; $5AEB

jr_004_5aed:
    ld a, e                                       ; $5AED
    add $90                                       ; $5AEE
    ld e, a                                       ; $5AF0
    jr nc, jr_004_5af4                            ; $5AF1

    inc d                                         ; $5AF3

jr_004_5af4:
    xor a                                         ; $5AF4
    ldh [hScratchA], a                            ; $5AF5

jr_004_5af7:
    dec b                                         ; $5AF7
    jr nz, jr_004_5ac5                            ; $5AF8

    ret                                           ; $5AFA


; C
Stamp_BuildMaskLayer::
    ld a, [wCategoryIndex]                        ; $5AFB
    sla a                                         ; $5AFE
    ld c, a                                       ; $5B00
    ld b, $00                                     ; $5B01
    ld hl, Stamp_BuildGraphicsLayer_Tbl54E0       ; $5B03
    add hl, bc                                    ; $5B06
    ld c, [hl]                                    ; $5B07
    inc hl                                        ; $5B08
    ld b, [hl]                                    ; $5B09
    xor a                                         ; $5B0A
    ldh [hScratchA], a                            ; $5B0B
    ld hl, wIconSrcMask                           ; $5B0D
    ld de, wIconTiles2                            ; $5B10

jr_004_5b13:
    push bc                                       ; $5B13
    push de                                       ; $5B14

jr_004_5b15:
    ld b, $08                                     ; $5B15

jr_004_5b17:
    ld a, [hl+]                                   ; $5B17
    cpl                                           ; $5B18
    ld [de], a                                    ; $5B19
    inc de                                        ; $5B1A
    xor a                                         ; $5B1B
    ld [de], a                                    ; $5B1C
    inc de                                        ; $5B1D
    dec b                                         ; $5B1E
    jr nz, jr_004_5b17                            ; $5B1F

    ld a, e                                       ; $5B21
    add $10                                       ; $5B22
    ld e, a                                       ; $5B24
    jr nc, jr_004_5b28                            ; $5B25

    inc d                                         ; $5B27

jr_004_5b28:
    dec c                                         ; $5B28
    jr nz, jr_004_5b15                            ; $5B29

    pop de                                        ; $5B2B
    pop bc                                        ; $5B2C
    ldh a, [hScratchA]                            ; $5B2D
    and a                                         ; $5B2F
    jr nz, jr_004_5b3f                            ; $5B30

    ld a, e                                       ; $5B32
    add $10                                       ; $5B33
    ld e, a                                       ; $5B35
    jr nc, jr_004_5b39                            ; $5B36

    inc d                                         ; $5B38

jr_004_5b39:
    ld a, $01                                     ; $5B39
    ldh [hScratchA], a                            ; $5B3B
    jr jr_004_5b49                                ; $5B3D

jr_004_5b3f:
    ld a, e                                       ; $5B3F
    add $90                                       ; $5B40
    ld e, a                                       ; $5B42
    jr nc, jr_004_5b46                            ; $5B43

    inc d                                         ; $5B45

jr_004_5b46:
    xor a                                         ; $5B46
    ldh [hScratchA], a                            ; $5B47

jr_004_5b49:
    dec b                                         ; $5B49
    jr nz, jr_004_5b13                            ; $5B4A

    ret                                           ; $5B4C


; C: blinking cursor on the category or on the stamp
Stamp_DrawPaletteCursor::
    ld a, [wStampPaletteFocus]                    ; $5B4D
    and a                                         ; $5B50
    jr z, jr_004_5b66                             ; $5B51

    ld bc, $8563                                  ; $5B53
    ldh a, [hFrameCounter]                        ; $5B56
    srl a                                         ; $5B58
    srl a                                         ; $5B5A
    srl a                                         ; $5B5C
    and $01                                       ; $5B5E
    add $35                                       ; $5B60
    call Oam_AddMeta_B01_4000                     ; $5B62
    ret                                           ; $5B65


jr_004_5b66:
    ld a, [wCategoryIndex]                        ; $5B66
    sla a                                         ; $5B69
    ld c, a                                       ; $5B6B
    ld b, $00                                     ; $5B6C
    ld hl, Stamp_DrawPaletteCursor_PtrTbl5502     ; $5B6E
    add hl, bc                                    ; $5B71
    ld a, [hl+]                                   ; $5B72
    ld h, [hl]                                    ; $5B73
    ld l, a                                       ; $5B74
    call Stamp_PageStrideCall                     ; $5B75
    ld c, a                                       ; $5B78
    ld a, [wStampItem]                            ; $5B79
    sub c                                         ; $5B7C
    sla a                                         ; $5B7D
    ld c, a                                       ; $5B7F
    ld b, $00                                     ; $5B80
    add hl, bc                                    ; $5B82
    ld a, [hl+]                                   ; $5B83
    ld b, a                                       ; $5B84
    ld c, [hl]                                    ; $5B85
    push bc                                       ; $5B86
    ld a, [wCategoryIndex]                        ; $5B87
    ld c, a                                       ; $5B8A
    ld b, $00                                     ; $5B8B
    ld hl, Stamp_DrawPaletteCursor_Tbl5562        ; $5B8D
    add hl, bc                                    ; $5B90
    ldh a, [hFrameCounter]                        ; $5B91
    srl a                                         ; $5B93
    srl a                                         ; $5B95
    srl a                                         ; $5B97
    and $01                                       ; $5B99
    add [hl]                                      ; $5B9B
    pop bc                                        ; $5B9C
    call Oam_AddMeta_B01_4000                     ; $5B9D
    ret                                           ; $5BA0


; C: D-pad moves in the grid or changes page; A / B changes the focus
Stamp_PaletteInput::
    ld a, [wStampPaletteFocus]                    ; $5BA1
    and a                                         ; $5BA4
    jr z, jr_004_5bb8                             ; $5BA5

    ldh a, [hKeysNew]                             ; $5BA7
    and PADF_B | PADF_LEFT                        ; $5BA9
    ret z                                         ; $5BAB

    play_sfx1 SFX1_KEY_A                          ; $5BAC
    xor a                                         ; $5BB3
    ld [wStampPaletteFocus], a                    ; $5BB4
    ret                                           ; $5BB7


jr_004_5bb8:
    ld a, [wCategoryIndex]                        ; $5BB8
    sla a                                         ; $5BBB
    ld c, a                                       ; $5BBD
    ld b, $00                                     ; $5BBE
    ld hl, Stamp_PaletteInput_Tbl5584             ; $5BC0
    add hl, bc                                    ; $5BC3
    ld a, [hl+]                                   ; $5BC4
    ld h, [hl]                                    ; $5BC5
    ld l, a                                       ; $5BC6
    call Stamp_PageStrideCall                     ; $5BC7
    ld c, a                                       ; $5BCA
    ld a, [wStampItem]                            ; $5BCB
    sub c                                         ; $5BCE
    sla a                                         ; $5BCF
    sla a                                         ; $5BD1
    ld c, a                                       ; $5BD3
    ldh a, [hKeysNewRepeat]                       ; $5BD4
    call Joy_DpadBitToIndex                       ; $5BD6
    ret z                                         ; $5BD9

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $5BDA
    dec a                                         ; $5BE1
    add c                                         ; $5BE2
    ld c, a                                       ; $5BE3
    ld b, $00                                     ; $5BE4
    add hl, bc                                    ; $5BE6
    ld a, [hl]                                    ; $5BE7
    ld c, a                                       ; $5BE8
    and $03                                       ; $5BE9
    cp $01                                        ; $5BEB
    jr nz, jr_004_5bf8                            ; $5BED

    ld hl, wStampPage                             ; $5BEF
    ld a, [hl]                                    ; $5BF2
    and a                                         ; $5BF3
    ret z                                         ; $5BF4

    dec [hl]                                      ; $5BF5
    jr jr_004_5c26                                ; $5BF6

jr_004_5bf8:
    cp $02                                        ; $5BF8
    jr nz, jr_004_5c1c                            ; $5BFA

    push bc                                       ; $5BFC
    ld a, [wCategoryIndex]                        ; $5BFD
    cp $02                                        ; $5C00
    jr nz, jr_004_5c09                            ; $5C02

    ld hl, wStampPageLimitC2                      ; $5C04
    jr jr_004_5c10                                ; $5C07

jr_004_5c09:
    ld c, a                                       ; $5C09
    ld b, $00                                     ; $5C0A
    ld hl, Stamp_PaletteInput_Tbl55FA             ; $5C0C
    add hl, bc                                    ; $5C0F

jr_004_5c10:
    pop bc                                        ; $5C10
    ld a, [wStampPage]                            ; $5C11
    cp [hl]                                       ; $5C14
    ret z                                         ; $5C15

    inc a                                         ; $5C16
    ld [wStampPage], a                            ; $5C17
    jr jr_004_5c26                                ; $5C1A

jr_004_5c1c:
    cp $03                                        ; $5C1C
    jr nz, jr_004_5c2b                            ; $5C1E

    ld a, $01                                     ; $5C20
    ld [wStampPaletteFocus], a                    ; $5C22
    ret                                           ; $5C25


jr_004_5c26:
    push bc                                       ; $5C26
    call Stamp_LoadPageGfx                        ; $5C27
    pop bc                                        ; $5C2A

jr_004_5c2b:
    ld a, c                                       ; $5C2B
    sra a                                         ; $5C2C
    sra a                                         ; $5C2E
    ld hl, wStampItem                             ; $5C30
    add [hl]                                      ; $5C33
    ld [hl], a                                    ; $5C34
    ret                                           ; $5C35


; C: jumps through the 17-entry table at 560B
Stamp_PageStrideCall::
    push hl                                       ; $5C36
    ld a, [wCategoryIndex]                        ; $5C37
    sla a                                         ; $5C3A
    ld c, a                                       ; $5C3C
    ld b, $00                                     ; $5C3D
    ld hl, Stamp_PageStrideJmpTbl                 ; $5C3F
    add hl, bc                                    ; $5C42
    ld a, [hl+]                                   ; $5C43
    ld h, [hl]                                    ; $5C44
    ld l, a                                       ; $5C45
    jp hl                                         ; $5C46


; C: cursor moves the stamp; A stamps (hold A mirrors); Start back to the palette; B asks to save
Mode11_State04_Place::
    call Stamp_DrawCursor                         ; $5C47
    call Stamp_MoveCursor                         ; $5C4A
    call Stamp_HoldAMirror                        ; $5C4D
    call Stamp_Commit                             ; $5C50
    ldh a, [hKeysHeld]                            ; $5C53
    ld hl, wEdgeDir                               ; $5C55
    and [hl]                                      ; $5C58
    jr nz, jr_004_5c5e                            ; $5C59

    ld [wEdgeCount], a                            ; $5C5B

jr_004_5c5e:
    ldh a, [hKeysNew]                             ; $5C5E
    bit PADB_START, a                             ; $5C60
    jr nz, jr_004_5c75                            ; $5C62

    ld a, [wEdgeDir]                              ; $5C64
    and a                                         ; $5C67
    jr z, jr_004_5c9b                             ; $5C68

    ld a, [wEdgeCount]                            ; $5C6A
    inc a                                         ; $5C6D
    ld [wEdgeCount], a                            ; $5C6E
    cp $0a                                        ; $5C71
    jr c, jr_004_5c9b                             ; $5C73

jr_004_5c75:
    call Oam_ClearShadow                          ; $5C75
    rst Rst08_WaitVBlank                          ; $5C78
    call Stamp_LoadPageGfx                        ; $5C79
    call Stamp_LoadCategoryIcons                  ; $5C7C
    farcopy Vram_CopyFromBank, Gfx_22_6A90_Mode11_State04_Place, $8fe0, $0020 ; $5C7F
    call Stamp_PaletteSlideOut                    ; $5C8D
    ld hl, hLcdcShadow                            ; $5C90
    res 2, [hl]                                   ; $5C93
    set_state STATE_11_PALETTE                    ; $5C95
    ret                                           ; $5C9A


jr_004_5c9b:
    ldh a, [hKeysNew]                             ; $5C9B
    bit PADB_B, a                                 ; $5C9D
    ret z                                         ; $5C9F

    ld a, [wDirtyFlag]                            ; $5CA0
    and a                                         ; $5CA3
    jr nz, jr_004_5cac                            ; $5CA4

    set_state STATE_11_LEAVE                      ; $5CA6
    ret                                           ; $5CAB


jr_004_5cac:
    call Oam_ClearShadow                          ; $5CAC
    rst Rst08_WaitVBlank                          ; $5CAF
    ld hl, hLcdcShadow                            ; $5CB0
    res 2, [hl]                                   ; $5CB3
    ld a, [wState]                                ; $5CB5
    ld [wStampReturnState], a                     ; $5CB8
    set_state STATE_11_SAVE_INIT                  ; $5CBB
    ret                                           ; $5CC0


; C: stores the palette position and returns to the caller or mode 04
Mode11_State05_Leave::
    screen_off                                    ; $5CC1
    ld a, [wCategoryIndex]                        ; $5CC7
    ld c, a                                       ; $5CCA
    ld b, $00                                     ; $5CCB
    ld hl, wCategoryPosB                          ; $5CCD
    add hl, bc                                    ; $5CD0
    ld a, [wStampPage]                            ; $5CD1
    ld [hl+], a                                   ; $5CD4
    ld hl, wCategoryPosA                          ; $5CD5
    add hl, bc                                    ; $5CD8
    ld a, [wStampItem]                            ; $5CD9
    ld [hl], a                                    ; $5CDC
    stat_irq_off                                  ; $5CDD
    ld a, [wDoodleFromShutterbug]                 ; $5CE7
    and a                                         ; $5CEA
    jr z, jr_004_5cf8                             ; $5CEB

    ld a, MODE_DOODLE_MENU                        ; $5CED
    ld [wMode], a                                 ; $5CEF
    set_state STATE_04_INIT                       ; $5CF2
    ret                                           ; $5CF7


jr_004_5cf8:
    ld a, [wCallerCode]                           ; $5CF8
    and a                                         ; $5CFB
    jr nz, jr_004_5d04                            ; $5CFC

    set_state STATE_11_INIT                       ; $5CFE
    ret                                           ; $5D03


jr_004_5d04:
    cp $01                                        ; $5D04
    jr nz, jr_004_5d13                            ; $5D06

    ld a, MODE_ALBUM_EDIT                         ; $5D08
    ld [wMode], a                                 ; $5D0A
    set_state STATE_09_INIT                       ; $5D0D
    ret                                           ; $5D12


jr_004_5d13:
    ld a, $01                                     ; $5D13
    ld [wAbResult], a                             ; $5D15
    ld a, MODE_ALBUM_VIEW                         ; $5D18
    ld [wMode], a                                 ; $5D1A
    set_state STATE_0A_SETUP                      ; $5D1D
    ret                                           ; $5D22


; C: save dialog id 1 and the target photo
Mode11_State06_SaveInit::
    ld a, $01                                     ; $5D23
    ld [wSaveDialogWhat], a                       ; $5D25
    ld a, [wCopyPhotoIdxD]                        ; $5D28
    ld [wSaveTargetPhoto], a                      ; $5D2B
    xor a                                         ; $5D2E
    ld [wSubstate], a                             ; $5D2F
    next_state                                    ; $5D32
    ret                                           ; $5D36


; C: far call 07:699C
Mode11_State07_SaveDialog::
    ldh [hFarcallAArg], a                         ; $5D37
    farcall SaveDialog_Far                        ; $5D39
    ret                                           ; $5D41


; C: YES: save done and back to the palette or placement; NO: leave
Mode11_State08_SaveResult::
    ld a, [wSaveDialogResult]                     ; $5D42
    and a                                         ; $5D45
    jr nz, jr_004_5d4e                            ; $5D46

    set_state STATE_11_LEAVE                      ; $5D48
    ret                                           ; $5D4D


jr_004_5d4e:
    farcopy Vram_CopyFromBank, Gfx_22_6810_Mode11_State02_Setup, $8d60, $02a0 ; $5D4E
    ld a, [wStampReturnState]                     ; $5D5C
    cp $03                                        ; $5D5F
    jr nz, jr_004_5d72                            ; $5D61

    call Stamp_LoadPageGfx                        ; $5D63
    call Stamp_LoadCategoryIcons                  ; $5D66
    call Stamp_PaletteSlideOut                    ; $5D69
    set_state STATE_11_PALETTE                    ; $5D6C
    ret                                           ; $5D71


jr_004_5d72:
    call Stamp_PrepareBuffers                     ; $5D72
    ld hl, hLcdcShadow                            ; $5D75
    set 2, [hl]                                   ; $5D78
    set_state STATE_11_PLACE                      ; $5D7A
    ret                                           ; $5D7F


; C: cursor metasprite $41 at (x + 16
Stamp_DrawCursor::
    ld a, [wCursorX]                              ; $5D80
    add $10                                       ; $5D83
    ld b, a                                       ; $5D85
    ld a, [wCursorY]                              ; $5D86
    add $10                                       ; $5D89
    ld c, a                                       ; $5D8B
    ld a, $41                                     ; $5D8C
    call Oam_AddMeta_B01_4000                     ; $5D8E
    ret                                           ; $5D91


; C: D-pad movement with edge detection and velocity
Stamp_MoveCursor::
    xor a                                         ; $5D92
    ld [wEdgeDir], a                              ; $5D93
    ld b, $ff                                     ; $5D96
    ldh a, [hKeysHeld]                            ; $5D98
    and PADF_RIGHT | PADF_LEFT                    ; $5D9A
    swap a                                        ; $5D9C
    ld hl, wCursorVx                              ; $5D9E
    ld e, $02                                     ; $5DA1

jr_004_5da3:
    and a                                         ; $5DA3
    ld c, a                                       ; $5DA4
    ld a, [hl]                                    ; $5DA5
    jr z, jr_004_5db3                             ; $5DA6

    and $fc                                       ; $5DA8
    or c                                          ; $5DAA
    add b                                         ; $5DAB
    jr nc, jr_004_5db7                            ; $5DAC

    ld a, $fc                                     ; $5DAE
    or c                                          ; $5DB0
    jr jr_004_5db7                                ; $5DB1

jr_004_5db3:
    sub b                                         ; $5DB3
    jr nc, jr_004_5db7                            ; $5DB4

    xor a                                         ; $5DB6

jr_004_5db7:
    ld [hl+], a                                   ; $5DB7
    inc hl                                        ; $5DB8
    ldh a, [hKeysHeld]                            ; $5DB9
    and PADF_UP | PADF_DOWN                       ; $5DBB
    sla a                                         ; $5DBD
    rr d                                          ; $5DBF
    rlca                                          ; $5DC1
    sla d                                         ; $5DC2
    rla                                           ; $5DC4
    dec e                                         ; $5DC5
    jr nz, jr_004_5da3                            ; $5DC6

    ld hl, wCursorXFrac                           ; $5DC8
    ld a, [wCursorVx]                             ; $5DCB
    ld e, $02                                     ; $5DCE

jr_004_5dd0:
    bit 0, a                                      ; $5DD0
    jr z, jr_004_5de0                             ; $5DD2

    or $03                                        ; $5DD4
    ld b, a                                       ; $5DD6
    ld a, [hl]                                    ; $5DD7
    add b                                         ; $5DD8
    ld [hl+], a                                   ; $5DD9
    ld a, [hl]                                    ; $5DDA
    adc $00                                       ; $5DDB
    ld [hl], a                                    ; $5DDD
    jr jr_004_5dee                                ; $5DDE

jr_004_5de0:
    bit 1, a                                      ; $5DE0
    jr z, jr_004_5dee                             ; $5DE2

    or $03                                        ; $5DE4
    ld b, a                                       ; $5DE6
    ld a, [hl]                                    ; $5DE7
    sub b                                         ; $5DE8
    ld [hl+], a                                   ; $5DE9
    ld a, [hl]                                    ; $5DEA
    sbc $00                                       ; $5DEB
    ld [hl], a                                    ; $5DED

jr_004_5dee:
    ld hl, wCursorYFrac                           ; $5DEE
    ld a, [wCursorVy]                             ; $5DF1
    dec e                                         ; $5DF4
    jr nz, jr_004_5dd0                            ; $5DF5

    ld a, [wCategoryIndex]                        ; $5DF7
    sla a                                         ; $5DFA
    sla a                                         ; $5DFC
    ld c, a                                       ; $5DFE
    ld b, $00                                     ; $5DFF
    ld hl, Stamp_PaletteCursorTbl                 ; $5E01
    add hl, bc                                    ; $5E04
    ld de, wCursorX                               ; $5E05
    ld a, $30                                     ; $5E08
    ldh [hScratchA], a                            ; $5E0A
    ld b, $02                                     ; $5E0C

jr_004_5e0e:
    push hl                                       ; $5E0E
    ld a, [de]                                    ; $5E0F
    cp $c0                                        ; $5E10
    jr c, jr_004_5e21                             ; $5E12

    cp [hl]                                       ; $5E14
    jr nc, jr_004_5e2d                            ; $5E15

    ldh a, [hScratchA]                            ; $5E17
    and $60                                       ; $5E19
    ld [wEdgeDir], a                              ; $5E1B
    ld a, [hl]                                    ; $5E1E
    jr jr_004_5e2d                                ; $5E1F

jr_004_5e21:
    inc hl                                        ; $5E21
    cp [hl]                                       ; $5E22
    jr c, jr_004_5e2d                             ; $5E23

    ldh a, [hScratchA]                            ; $5E25
    and $90                                       ; $5E27
    ld [wEdgeDir], a                              ; $5E29
    ld a, [hl]                                    ; $5E2C

jr_004_5e2d:
    pop hl                                        ; $5E2D
    ld [de], a                                    ; $5E2E
    ld a, $c0                                     ; $5E2F
    ldh [hScratchA], a                            ; $5E31
    inc hl                                        ; $5E33
    inc hl                                        ; $5E34
    inc de                                        ; $5E35
    inc de                                        ; $5E36
    dec b                                         ; $5E37
    jr nz, jr_004_5e0e                            ; $5E38

    ret                                           ; $5E3A


; C: A held: every 100 frames mirrors the stamp horizontally
Stamp_HoldAMirror::
    ldh a, [hKeysHeld]                            ; $5E3B
    bit PADB_A, a                                 ; $5E3D
    ret z                                         ; $5E3F

    ld a, [wStampRotateTimer]                     ; $5E40
    dec a                                         ; $5E43
    jr nz, jr_004_5e48                            ; $5E44

    ld a, $64                                     ; $5E46

jr_004_5e48:
    ld [wStampRotateTimer], a                     ; $5E48
    ret nz                                        ; $5E4B

    ld hl, wIconTiles1                            ; $5E4C
    call Stamp_MirrorBuffer                       ; $5E4F
    ld hl, wIconTiles2                            ; $5E52
    call Stamp_MirrorBuffer                       ; $5E55
    ld hl, wIconSrcGfx                            ; $5E58
    call Stamp_MirrorGfxBuffer                    ; $5E5B
    ld hl, wIconSrcMask                           ; $5E5E
    call Stamp_MirrorMaskBuffer                   ; $5E61
    call Oam_ClearShadow                          ; $5E64
    rst Rst08_WaitVBlank                          ; $5E67
    ld a, $00                                     ; $5E68
    ld hl, wIconTiles1                            ; $5E6A
    ld de, $8a00                                  ; $5E6D
    ld bc, $01e0                                  ; $5E70
    call Vram_CopyFromBank                        ; $5E73
    ld a, $00                                     ; $5E76
    ld hl, wIconTiles2                            ; $5E78
    ld de, $8520                                  ; $5E7B
    ld bc, $01e0                                  ; $5E7E
    call Vram_CopyFromBank                        ; $5E81
    ret                                           ; $5E84


; C: bit-reverses the rows of a 2 bpp buffer
Stamp_MirrorBuffer::
    push hl                                       ; $5E85
    ld a, [wCategoryIndex]                        ; $5E86
    ld c, a                                       ; $5E89
    ld b, $00                                     ; $5E8A
    ld hl, Stamp_MirrorBuffer_Gfx568C             ; $5E8C
    add hl, bc                                    ; $5E8F
    ld b, [hl]                                    ; $5E90
    pop hl                                        ; $5E91
    push hl                                       ; $5E92
    ld a, b                                       ; $5E93
    dec a                                         ; $5E94
    sla a                                         ; $5E95
    swap a                                        ; $5E97
    ld e, a                                       ; $5E99
    ld d, $00                                     ; $5E9A
    add hl, de                                    ; $5E9C
    ld e, l                                       ; $5E9D
    ld d, h                                       ; $5E9E
    ld a, b                                       ; $5E9F
    inc a                                         ; $5EA0
    srl a                                         ; $5EA1
    ld b, a                                       ; $5EA3
    pop hl                                        ; $5EA4
    ld a, $03                                     ; $5EA5

jr_004_5ea7:
    ldh [hScratchA], a                            ; $5EA7
    push bc                                       ; $5EA9
    push de                                       ; $5EAA
    push hl                                       ; $5EAB

jr_004_5eac:
    ld c, $20                                     ; $5EAC

jr_004_5eae:
    ld a, [de]                                    ; $5EAE
    srl a                                         ; $5EAF
    rl [hl]                                       ; $5EB1
    rr a                                          ; $5EB3
    rl [hl]                                       ; $5EB5
    rr a                                          ; $5EB7
    rl [hl]                                       ; $5EB9
    rr a                                          ; $5EBB
    rl [hl]                                       ; $5EBD
    rr a                                          ; $5EBF
    rl [hl]                                       ; $5EC1
    rr a                                          ; $5EC3
    rl [hl]                                       ; $5EC5
    rr a                                          ; $5EC7
    rl [hl]                                       ; $5EC9
    rr a                                          ; $5ECB
    rl [hl]                                       ; $5ECD
    rr a                                          ; $5ECF
    ld [de], a                                    ; $5ED1
    inc hl                                        ; $5ED2
    inc de                                        ; $5ED3
    dec c                                         ; $5ED4
    jr nz, jr_004_5eae                            ; $5ED5

    ld a, e                                       ; $5ED7
    sub $40                                       ; $5ED8
    ld e, a                                       ; $5EDA
    jr nc, jr_004_5ede                            ; $5EDB

    dec d                                         ; $5EDD

jr_004_5ede:
    dec b                                         ; $5EDE
    jr nz, jr_004_5eac                            ; $5EDF

    pop hl                                        ; $5EE1
    pop de                                        ; $5EE2
    pop bc                                        ; $5EE3
    ld a, e                                       ; $5EE4
    add $a0                                       ; $5EE5
    ld e, a                                       ; $5EE7
    jr nc, jr_004_5eeb                            ; $5EE8

    inc d                                         ; $5EEA

jr_004_5eeb:
    ld a, l                                       ; $5EEB
    add $a0                                       ; $5EEC
    ld l, a                                       ; $5EEE
    jr nc, jr_004_5ef2                            ; $5EEF

    inc h                                         ; $5EF1

jr_004_5ef2:
    ldh a, [hScratchA]                            ; $5EF2
    dec a                                         ; $5EF4
    jr nz, jr_004_5ea7                            ; $5EF5

    ret                                           ; $5EF7


; C: same for the graphics layer
Stamp_MirrorGfxBuffer::
    push hl                                       ; $5EF8
    ld a, [wCategoryIndex]                        ; $5EF9
    ld c, a                                       ; $5EFC
    ld b, $00                                     ; $5EFD
    ld hl, Stamp_MirrorBuffer_Gfx568C             ; $5EFF
    add hl, bc                                    ; $5F02
    ld b, [hl]                                    ; $5F03
    pop hl                                        ; $5F04
    push hl                                       ; $5F05
    ld a, b                                       ; $5F06
    dec a                                         ; $5F07
    swap a                                        ; $5F08
    ld e, a                                       ; $5F0A
    ld d, $00                                     ; $5F0B
    add hl, de                                    ; $5F0D
    ld e, l                                       ; $5F0E
    ld d, h                                       ; $5F0F
    ld a, b                                       ; $5F10
    swap a                                        ; $5F11
    ld c, a                                       ; $5F13
    ld a, b                                       ; $5F14
    inc a                                         ; $5F15
    srl a                                         ; $5F16
    ld b, a                                       ; $5F18
    pop hl                                        ; $5F19
    ld a, $06                                     ; $5F1A

jr_004_5f1c:
    ldh [hScratchA], a                            ; $5F1C
    push bc                                       ; $5F1E
    push de                                       ; $5F1F
    push hl                                       ; $5F20

jr_004_5f21:
    ld c, $10                                     ; $5F21

jr_004_5f23:
    ld a, [de]                                    ; $5F23
    srl a                                         ; $5F24
    rl [hl]                                       ; $5F26
    rr a                                          ; $5F28
    rl [hl]                                       ; $5F2A
    rr a                                          ; $5F2C
    rl [hl]                                       ; $5F2E
    rr a                                          ; $5F30
    rl [hl]                                       ; $5F32
    rr a                                          ; $5F34
    rl [hl]                                       ; $5F36
    rr a                                          ; $5F38
    rl [hl]                                       ; $5F3A
    rr a                                          ; $5F3C
    rl [hl]                                       ; $5F3E
    rr a                                          ; $5F40
    rl [hl]                                       ; $5F42
    rr a                                          ; $5F44
    ld [de], a                                    ; $5F46
    inc hl                                        ; $5F47
    inc de                                        ; $5F48
    dec c                                         ; $5F49
    jr nz, jr_004_5f23                            ; $5F4A

    ld a, e                                       ; $5F4C
    sub $20                                       ; $5F4D
    ld e, a                                       ; $5F4F
    jr nc, jr_004_5f53                            ; $5F50

    dec d                                         ; $5F52

jr_004_5f53:
    dec b                                         ; $5F53
    jr nz, jr_004_5f21                            ; $5F54

    pop hl                                        ; $5F56
    pop de                                        ; $5F57
    pop bc                                        ; $5F58
    ld a, e                                       ; $5F59
    add c                                         ; $5F5A
    ld e, a                                       ; $5F5B
    jr nc, jr_004_5f5f                            ; $5F5C

    inc d                                         ; $5F5E

jr_004_5f5f:
    ld a, l                                       ; $5F5F
    add c                                         ; $5F60
    ld l, a                                       ; $5F61
    jr nc, jr_004_5f65                            ; $5F62

    inc h                                         ; $5F64

jr_004_5f65:
    ldh a, [hScratchA]                            ; $5F65
    dec a                                         ; $5F67
    jr nz, jr_004_5f1c                            ; $5F68

    ret                                           ; $5F6A


; C: same for the mask layer
Stamp_MirrorMaskBuffer::
    push hl                                       ; $5F6B
    ld a, [wCategoryIndex]                        ; $5F6C
    ld c, a                                       ; $5F6F
    ld b, $00                                     ; $5F70
    ld hl, Stamp_MirrorBuffer_Gfx568C             ; $5F72
    add hl, bc                                    ; $5F75
    ld b, [hl]                                    ; $5F76
    pop hl                                        ; $5F77
    push hl                                       ; $5F78
    ld a, b                                       ; $5F79
    dec a                                         ; $5F7A
    swap a                                        ; $5F7B
    srl a                                         ; $5F7D
    ld e, a                                       ; $5F7F
    ld d, $00                                     ; $5F80
    add hl, de                                    ; $5F82
    ld e, l                                       ; $5F83
    ld d, h                                       ; $5F84
    ld a, b                                       ; $5F85
    swap a                                        ; $5F86
    srl a                                         ; $5F88
    ld c, a                                       ; $5F8A
    ld a, b                                       ; $5F8B
    inc a                                         ; $5F8C
    srl a                                         ; $5F8D
    ld b, a                                       ; $5F8F
    pop hl                                        ; $5F90
    ld a, $06                                     ; $5F91

jr_004_5f93:
    ldh [hScratchA], a                            ; $5F93
    push bc                                       ; $5F95
    push de                                       ; $5F96
    push hl                                       ; $5F97

jr_004_5f98:
    ld c, $08                                     ; $5F98

jr_004_5f9a:
    ld a, [de]                                    ; $5F9A
    srl a                                         ; $5F9B
    rl [hl]                                       ; $5F9D
    rr a                                          ; $5F9F
    rl [hl]                                       ; $5FA1
    rr a                                          ; $5FA3
    rl [hl]                                       ; $5FA5
    rr a                                          ; $5FA7
    rl [hl]                                       ; $5FA9
    rr a                                          ; $5FAB
    rl [hl]                                       ; $5FAD
    rr a                                          ; $5FAF
    rl [hl]                                       ; $5FB1
    rr a                                          ; $5FB3
    rl [hl]                                       ; $5FB5
    rr a                                          ; $5FB7
    rl [hl]                                       ; $5FB9
    rr a                                          ; $5FBB
    ld [de], a                                    ; $5FBD
    inc hl                                        ; $5FBE
    inc de                                        ; $5FBF
    dec c                                         ; $5FC0
    jr nz, jr_004_5f9a                            ; $5FC1

    ld a, e                                       ; $5FC3
    sub $10                                       ; $5FC4
    ld e, a                                       ; $5FC6
    jr nc, jr_004_5fca                            ; $5FC7

    dec d                                         ; $5FC9

jr_004_5fca:
    dec b                                         ; $5FCA
    jr nz, jr_004_5f98                            ; $5FCB

    pop hl                                        ; $5FCD
    pop de                                        ; $5FCE
    pop bc                                        ; $5FCF
    ld a, e                                       ; $5FD0
    add c                                         ; $5FD1
    ld e, a                                       ; $5FD2
    jr nc, jr_004_5fd6                            ; $5FD3

    inc d                                         ; $5FD5

jr_004_5fd6:
    ld a, l                                       ; $5FD6
    add c                                         ; $5FD7
    ld l, a                                       ; $5FD8
    jr nc, jr_004_5fdc                            ; $5FD9

    inc h                                         ; $5FDB

jr_004_5fdc:
    ldh a, [hScratchA]                            ; $5FDC
    dec a                                         ; $5FDE
    jr nz, jr_004_5f93                            ; $5FDF

    ret                                           ; $5FE1


; C: A released: blits the stamp into the picture and sets dirty_flag
Stamp_Commit::
    ldh a, [hKeysReleased]                        ; $5FE2
    bit PADB_A, a                                 ; $5FE4
    ret z                                         ; $5FE6

    ld a, $b4                                     ; $5FE7
    ld [wStampRotateTimer], a                     ; $5FE9
    play_sfx4 SFX4_STAMP_COMMIT                   ; $5FEC
    ld [wDirtyFlag], a                            ; $5FF3
    ld a, [wCursorX]                              ; $5FF6
    add $10                                       ; $5FF9
    ld b, a                                       ; $5FFB
    ld a, [wCursorY]                              ; $5FFC
    add $10                                       ; $5FFF
    ld c, a                                       ; $6001
    ld a, [wCategoryIndex]                        ; $6002
    sla a                                         ; $6005
    ld e, a                                       ; $6007
    ld d, $00                                     ; $6008
    ld hl, Stamp_Commit_Tbl569D                   ; $600A
    add hl, de                                    ; $600D
    ld a, [hl+]                                   ; $600E
    ld h, [hl]                                    ; $600F
    ld l, a                                       ; $6010
    call Blit_SpriteToBg                          ; $6011
    ret                                           ; $6014


; C: sound $12 and window slide with Slide_WyDeltaTbl
Stamp_PaletteSlideIn::
    play_sfx1 SFX1_PANEL_OPEN                     ; $6015
    ld hl, Slide_WyDeltaTbl                       ; $601C
    ld b, $24                                     ; $601F

jr_004_6021:
    push bc                                       ; $6021
    push hl                                       ; $6022
    ldh a, [hWyShadow]                            ; $6023
    add [hl]                                      ; $6025
    ldh [hWyShadow], a                            ; $6026
    rst Rst08_WaitVBlank                          ; $6028
    pop hl                                        ; $6029
    pop bc                                        ; $602A
    inc hl                                        ; $602B
    dec b                                         ; $602C
    jr nz, jr_004_6021                            ; $602D

    ret                                           ; $602F


; C: sound $13 and window slide back
Stamp_PaletteSlideOut::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $6030
    ld hl, Slide_WyDeltaTbl                       ; $6037
    ld b, $24                                     ; $603A

jr_004_603c:
    push bc                                       ; $603C
    push hl                                       ; $603D
    ldh a, [hWyShadow]                            ; $603E
    sub [hl]                                      ; $6040
    ldh [hWyShadow], a                            ; $6041
    rst Rst08_WaitVBlank                          ; $6043
    pop hl                                        ; $6044
    pop bc                                        ; $6045
    inc hl                                        ; $6046
    dec b                                         ; $6047
    jr nz, jr_004_603c                            ; $6048

    ret                                           ; $604A


; C: mode 10: PAINT tool
Mode10_Paint::
    ld a, [wState]                                ; $604B
    rst Rst18_JumpTable                           ; $604E

; C: 11 states, rst $18 table of mode $10
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
    ld a, $00                                     ; $6065
    ld [wMsgStripSel], a                          ; $6067
    ld a, $05                                     ; $606A
    ld [wIconSel], a                              ; $606C
    xor a                                         ; $606F
    ld [wSubstate], a                             ; $6070
    ld [wCallerCode], a                           ; $6073
    ld [wStockNavAllowed], a                      ; $6076
    next_state                                    ; $6079
    ret                                           ; $607D


; C: far call to the photo grid picker
Mode10_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $607E
    ld a, $04                                     ; $6080
    ld hl, PhotoPicker_Far                        ; $6082
    call Far_Call                                 ; $6085
    ret                                           ; $6088


; C: loads the paint screen
Mode10_State02_Setup::
    ld a, [wAbResult]                             ; $6089
    bit 0, a                                      ; $608C
    jr nz, jr_004_609b                            ; $608E

    ld a, MODE_DOODLE_MENU                        ; $6090
    ld [wMode], a                                 ; $6092
    set_state STATE_04_INIT                       ; $6095
    ret                                           ; $609A


jr_004_609b:
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $609B
    ldh [hLcdcShadow], a                          ; $609D
    ld a, $e4                                     ; $609F
    ld [wPaletteTarget], a                        ; $60A1
    ld [wPaletteTarget + $1], a                   ; $60A4
    ld a, $d2                                     ; $60A7
    ld [wPaletteTarget + $2], a                   ; $60A9
    ld a, $10                                     ; $60AC
    ldh [hScxShadow], a                           ; $60AE
    ldh [hScyShadow], a                           ; $60B0
    ld a, $07                                     ; $60B2
    ldh [hWxShadow], a                            ; $60B4
    ld a, $95                                     ; $60B6
    ldh [hWyShadow], a                            ; $60B8
    ld a, $40                                     ; $60BA
    ld [wCursorX], a                              ; $60BC
    ld a, $38                                     ; $60BF
    ld [wCursorY], a                              ; $60C1
    xor a                                         ; $60C4
    ld [wCursorXFrac], a                          ; $60C5
    ld [wCursorYFrac], a                          ; $60C8
    ld [wCursorVx], a                             ; $60CB
    ld [wCursorVy], a                             ; $60CE
    ld [wPenMenuRow], a                           ; $60D1
    ld a, $38                                     ; $60D4
    ld [wPenRampIndex], a                         ; $60D6
    farcopy Mem_CopyFromBank, Gfx_14_7E30_Mode10_State02_Setup, $8900, $00d0 ; $60D9
    farcopy Mem_CopyFromBank, Gfx_14_7430_Mode10_State02_Setup, $8e30, $01d0 ; $60E7
    farcopy Mem_CopyFromBank, Gfx_14_7F00_Mode10_State02_Setup, $8500, $00a0 ; $60F5
    farcopy Mem_CopyFromBank, Map_24_7120_Mode10_State02_Setup, $9800, $02c0 ; $6103
    ld a, [wDoodleFromShutterbug]                 ; $6111
    and a                                         ; $6114
    jr nz, jr_004_6129                            ; $6115

    ld a, [wPhotoIndex]                           ; $6117
    ld [wCopyPhotoIdxF], a                        ; $611A
    ldh [hFarcallAArg], a                         ; $611D
    farcall Photo_LoadToVram_Far                  ; $611F
    jr jr_004_615d                                ; $6127

jr_004_6129:
    ldh [hFarcallAArg], a                         ; $6129
    farcall GameFace_Load_Far                     ; $612B
    ld a, $00                                     ; $6133
    ld hl, wPhotoImage                            ; $6135
    ld de, $9000                                  ; $6138
    ld bc, $0800                                  ; $613B
    call Mem_CopyFromBank                         ; $613E
    ld a, $00                                     ; $6141
    ld hl, wPhotoImage + $800                     ; $6143
    ld de, $8800                                  ; $6146
    ld bc, $0100                                  ; $6149
    call Mem_CopyFromBank                         ; $614C
    ld a, $00                                     ; $614F
    ld hl, wPhotoImage + $900                     ; $6151
    ld de, $8000                                  ; $6154
    ld bc, $0500                                  ; $6157
    call Mem_CopyFromBank                         ; $615A

jr_004_615d:
    xor a                                         ; $615D
    ld [wDirtyFlag], a                            ; $615E
    ld a, $54                                     ; $6161
    ldh [hLycShadowSplit1], a                     ; $6163
    ldh [hSplit1Latch], a                         ; $6165
    ld hl, hStatShadow                            ; $6167
    set 6, [hl]                                   ; $616A
    ld hl, rIE                                    ; $616C
    set 1, [hl]                                   ; $616F
    ld a, $01                                     ; $6171
    ldh [hStatHandlerIndex], a                    ; $6173
    screen_on                                     ; $6175
    play_music MUSIC_PAINT                        ; $617E
    call Pal_FadeIn                               ; $6185
    next_state                                    ; $6188
    ret                                           ; $618C


; C: pen moves; A draws; Start opens the pen menu
Mode10_State03_Draw::
    call Pen_Update                               ; $618D
    call Pen_DrawCursor                           ; $6190
    call Pen_Draw                                 ; $6193
    ldh a, [hKeysHeld]                            ; $6196
    ld hl, wEdgeDir                               ; $6198
    and [hl]                                      ; $619B
    jr nz, jr_004_61a1                            ; $619C

    ld [wEdgeCount], a                            ; $619E

jr_004_61a1:
    ldh a, [hKeysNew]                             ; $61A1
    bit PADB_START, a                             ; $61A3
    jr nz, jr_004_61b8                            ; $61A5

    ld a, [wEdgeDir]                              ; $61A7
    and a                                         ; $61AA
    jr z, jr_004_61c0                             ; $61AB

    ld a, [wEdgeCount]                            ; $61AD
    inc a                                         ; $61B0
    ld [wEdgeCount], a                            ; $61B1
    cp $0a                                        ; $61B4
    jr c, jr_004_61c0                             ; $61B6

jr_004_61b8:
    call Oam_ClearShadow                          ; $61B8
    rst Rst08_WaitVBlank                          ; $61BB
    call PenMenu_SlideClose                       ; $61BC
    ret                                           ; $61BF


jr_004_61c0:
    ldh a, [hKeysNew]                             ; $61C0
    bit PADB_B, a                                 ; $61C2
    ret z                                         ; $61C4

    ld a, [wDirtyFlag]                            ; $61C5
    and a                                         ; $61C8
    jr nz, jr_004_61d8                            ; $61C9

    play_sfx1 SFX1_KEY_B                          ; $61CB
    set_state STATE_10_LEAVE                      ; $61D2
    ret                                           ; $61D7


jr_004_61d8:
    set_state STATE_10_SAVE_INIT                  ; $61D8
    ret                                           ; $61DD


; C: pen menu: size
Mode10_State04_MenuSize::
    call PenMenu_Input                            ; $61DE
    call PenMenu_DrawCursor                       ; $61E1
    ldh a, [hKeysNew]                             ; $61E4
    bit PADB_A, a                                 ; $61E6
    jr z, jr_004_6207                             ; $61E8

    ld a, [wPenMenuFocus]                         ; $61EA
    and a                                         ; $61ED
    ret nz                                        ; $61EE

    play_sfx1 SFX1_KEY_A                          ; $61EF
    ld a, [wPenMenuItem]                          ; $61F6
    ld [wPenSize], a                              ; $61F9
    call PenMenu_BuildSize                        ; $61FC
    ld bc, $0014                                  ; $61FF
    call Wait_Frames                              ; $6202
    jr jr_004_620a                                ; $6205

jr_004_6207:
    bit 1, a                                      ; $6207
    ret z                                         ; $6209

jr_004_620a:
    call PenMenu_SlideOpen                        ; $620A
    set_state STATE_10_DRAW                       ; $620D
    ret                                           ; $6212


; C: pen menu: pattern
Mode10_State05_MenuPattern::
    call PenMenu_Input                            ; $6213
    call PenMenu_DrawCursor                       ; $6216
    ldh a, [hKeysNew]                             ; $6219
    bit PADB_A, a                                 ; $621B
    jr z, jr_004_623c                             ; $621D

    ld a, [wPenMenuFocus]                         ; $621F
    and a                                         ; $6222
    ret nz                                        ; $6223

    play_sfx1 SFX1_KEY_A                          ; $6224
    ld a, [wPenMenuItem]                          ; $622B
    ld [wPenPattern], a                           ; $622E
    call PenMenu_BuildPattern                     ; $6231
    ld bc, $0014                                  ; $6234
    call Wait_Frames                              ; $6237
    jr jr_004_623f                                ; $623A

jr_004_623c:
    bit 1, a                                      ; $623C
    ret z                                         ; $623E

jr_004_623f:
    call PenMenu_SlideOpen                        ; $623F
    set_state STATE_10_DRAW                       ; $6242
    ret                                           ; $6247


; C: pen menu: speed
Mode10_State06_MenuSpeed::
    call PenMenu_Input                            ; $6248
    call PenMenu_DrawCursor                       ; $624B
    ldh a, [hKeysNew]                             ; $624E
    bit PADB_A, a                                 ; $6250
    jr z, jr_004_6271                             ; $6252

    ld a, [wPenMenuFocus]                         ; $6254
    and a                                         ; $6257
    ret nz                                        ; $6258

    play_sfx1 SFX1_KEY_A                          ; $6259
    ld a, [wPenMenuItem]                          ; $6260
    ld [wPenSpeed], a                             ; $6263
    call PenMenu_BuildSpeed                       ; $6266
    ld bc, $0014                                  ; $6269
    call Wait_Frames                              ; $626C
    jr jr_004_6274                                ; $626F

jr_004_6271:
    bit 1, a                                      ; $6271
    ret z                                         ; $6273

jr_004_6274:
    call PenMenu_SlideOpen                        ; $6274
    set_state STATE_10_DRAW                       ; $6277
    ret                                           ; $627C


; C: D-pad changes the item or the row
PenMenu_Input::
    ld a, [wPenMenuFocus]                         ; $627D
    and a                                         ; $6280
    jr nz, jr_004_62bc                            ; $6281

    ld a, [wPenMenuPage]                          ; $6283
    ld c, a                                       ; $6286
    ld b, $00                                     ; $6287
    ld hl, PenMenu_ItemCountTbl                   ; $6289
    add hl, bc                                    ; $628C
    ld c, [hl]                                    ; $628D
    ldh a, [hKeysNewRepeat]                       ; $628E
    ld b, a                                       ; $6290
    ld a, [wPenMenuItem]                          ; $6291
    bit 5, b                                      ; $6294
    jr z, jr_004_62a4                             ; $6296

    and a                                         ; $6298
    ret z                                         ; $6299

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $629A
    dec a                                         ; $62A1
    jr jr_004_62b2                                ; $62A2

jr_004_62a4:
    bit 4, b                                      ; $62A4
    ret z                                         ; $62A6

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $62A7
    cp c                                          ; $62AE
    jr z, jr_004_62b6                             ; $62AF

    inc a                                         ; $62B1

jr_004_62b2:
    ld [wPenMenuItem], a                          ; $62B2
    ret                                           ; $62B5


jr_004_62b6:
    ld a, $01                                     ; $62B6
    ld [wPenMenuFocus], a                         ; $62B8
    ret                                           ; $62BB


jr_004_62bc:
    ldh a, [hKeysNewRepeat]                       ; $62BC
    ld b, a                                       ; $62BE
    ld a, [wPenMenuRow]                           ; $62BF
    bit 5, b                                      ; $62C2
    jr z, jr_004_62e0                             ; $62C4

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $62C6
    xor a                                         ; $62CD
    ld [wPenMenuFocus], a                         ; $62CE
    ld a, [wPenMenuPage]                          ; $62D1
    ld c, a                                       ; $62D4
    ld b, $00                                     ; $62D5
    ld hl, PenMenu_ItemCountTbl                   ; $62D7
    add hl, bc                                    ; $62DA
    ld a, [hl]                                    ; $62DB
    ld [wPenMenuItem], a                          ; $62DC
    ret                                           ; $62DF


jr_004_62e0:
    bit 6, b                                      ; $62E0
    jr z, jr_004_62f0                             ; $62E2

    and a                                         ; $62E4
    ret z                                         ; $62E5

    play_sfx1 SFX1_CURSOR_MOVE                    ; $62E6
    dec a                                         ; $62ED
    jr jr_004_62fe                                ; $62EE

jr_004_62f0:
    bit 7, b                                      ; $62F0
    ret z                                         ; $62F2

    cp $02                                        ; $62F3
    ret z                                         ; $62F5

    play_sfx1 SFX1_CURSOR_MOVE                    ; $62F6
    inc a                                         ; $62FD

jr_004_62fe:
    ld [wPenMenuRow], a                           ; $62FE
    call Oam_ClearShadow                          ; $6301
    rst Rst08_WaitVBlank                          ; $6304
    call PenMenu_Build                            ; $6305
    ret                                           ; $6308


; C: items per row 3 / 3 / 2
PenMenu_ItemCountTbl::
    db $03, $03, $02

; C: blinking cursor on the current item
PenMenu_DrawCursor::
    ld a, [wPenMenuFocus]                         ; $630C
    and a                                         ; $630F
    jr nz, jr_004_6341                            ; $6310

    ld a, [wPenMenuPage]                          ; $6312
    ld c, a                                       ; $6315
    ld b, $00                                     ; $6316
    ld hl, PenMenu_CursorPosTbl                   ; $6318
    add hl, bc                                    ; $631B
    ld c, [hl]                                    ; $631C
    add hl, bc                                    ; $631D
    ld a, [wPenMenuItem]                          ; $631E
    sla a                                         ; $6321
    ld c, a                                       ; $6323
    add hl, bc                                    ; $6324
    ld c, [hl]                                    ; $6325
    inc hl                                        ; $6326
    ld b, [hl]                                    ; $6327
    ld a, [wPenMenuPage]                          ; $6328
    ld e, a                                       ; $632B
    ld d, $00                                     ; $632C
    ld hl, PenMenu_DrawCursor_Tbl6365             ; $632E
    add hl, de                                    ; $6331
    ldh a, [hFrameCounter]                        ; $6332
    srl a                                         ; $6334
    srl a                                         ; $6336
    srl a                                         ; $6338
    and $01                                       ; $633A
    add [hl]                                      ; $633C
    call Oam_AddMeta_B01_4000                     ; $633D
    ret                                           ; $6340


jr_004_6341:
    ldh a, [hFrameCounter]                        ; $6341
    srl a                                         ; $6343
    srl a                                         ; $6345
    srl a                                         ; $6347
    and $01                                       ; $6349
    add $25                                       ; $634B
    ld bc, $8864                                  ; $634D
    call Oam_AddMeta_B01_4000                     ; $6350
    ret                                           ; $6353


; C: L3 pass 2026-10-26: read in BGB in 3 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_CursorPosTbl::
    db $03, $02, $09, $5b, $14, $5b, $2d, $5b, $45, $5b, $5e, $58, $1d, $58, $3b, $58
    db $5e

; C: auto: 3 bytes, bytes; referenced by PenMenu_DrawCursor. L3 pass 2026-10-26: read in BGB in 3 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_DrawCursor_Tbl6365::
    db $23, $23, $29

; C: returns to mode 04 or the extras caller
Mode10_State07_Leave::
    screen_off                                    ; $6368
    stat_irq_off                                  ; $636E
    ld a, [wDoodleFromShutterbug]                 ; $6378
    and a                                         ; $637B
    jr z, jr_004_6389                             ; $637C

    ld a, MODE_DOODLE_MENU                        ; $637E
    ld [wMode], a                                 ; $6380
    set_state STATE_04_INIT                       ; $6383
    ret                                           ; $6388


jr_004_6389:
    ld a, [wCallerCode]                           ; $6389
    and a                                         ; $638C
    jr nz, jr_004_6395                            ; $638D

    set_state STATE_10_INIT                       ; $638F
    ret                                           ; $6394


jr_004_6395:
    cp $01                                        ; $6395
    jr nz, jr_004_63a4                            ; $6397

    ld a, MODE_ALBUM_EDIT                         ; $6399
    ld [wMode], a                                 ; $639B
    set_state STATE_09_INIT                       ; $639E
    ret                                           ; $63A3


jr_004_63a4:
    ld a, $01                                     ; $63A4
    ld [wAbResult], a                             ; $63A6
    ld a, MODE_ALBUM_VIEW                         ; $63A9
    ld [wMode], a                                 ; $63AB
    set_state STATE_0A_SETUP                      ; $63AE
    ret                                           ; $63B3


; C: save dialog id 1 and the target photo
Mode10_State08_SaveInit::
    ld a, $95                                     ; $63B4
    ldh [hWyShadow], a                            ; $63B6
    ld a, $07                                     ; $63B8
    ldh [hWxShadow], a                            ; $63BA
    ld hl, hLcdcShadow                            ; $63BC
    set 5, [hl]                                   ; $63BF
    call Oam_ClearShadow                          ; $63C1
    ld a, $01                                     ; $63C4
    ld [wSaveDialogWhat], a                       ; $63C6
    ld a, [wCopyPhotoIdxF]                        ; $63C9
    ld [wSaveTargetPhoto], a                      ; $63CC
    xor a                                         ; $63CF
    ld [wSubstate], a                             ; $63D0
    next_state                                    ; $63D3
    ret                                           ; $63D7


; C: far call 07:699C
Mode10_State09_SaveDialog::
    ldh [hFarcallAArg], a                         ; $63D8
    farcall SaveDialog_Far                        ; $63DA
    ret                                           ; $63E2


; C
Mode10_State0A_SaveResult::
    ld a, [wSaveDialogResult]                     ; $63E3
    and a                                         ; $63E6
    jr nz, jr_004_63ef                            ; $63E7

    set_state STATE_10_LEAVE                      ; $63E9
    ret                                           ; $63EE


jr_004_63ef:
    farcopy Vram_CopyFromBank, Gfx_14_7430_Mode10_State02_Setup, $8e30, $01d0 ; $63EF
    set_state STATE_10_DRAW                       ; $63FD
    ret                                           ; $6402


; I: dead code: copies the tilemap 24:7120 to $9800 (UNREFERENCED, README 16.15)
Unused_LoadTilemap24_7120::
    farcopy Vram_CopyFromBank, Map_24_7120_Mode10_State02_Setup, $9800, $02c0 ; $6403
    ret                                           ; $6411


; I: dead code: copies the tilemap 25:4B00 to $9800 (UNREFERENCED, README 16.15)
Unused_LoadTilemap25_4B00::
    farcopy Vram_CopyFromBank, BgMap_25_4B00, $9800, $02c0 ; $6412
    ret                                           ; $6420


; C: pen cursor sprite by size with a 16-frame blink
Pen_DrawCursor::
    ld a, [wPenSize]                              ; $6421
    sla a                                         ; $6424
    ld c, a                                       ; $6426
    ldh a, [hFrameCounter]                        ; $6427
    srl a                                         ; $6429
    srl a                                         ; $642B
    srl a                                         ; $642D
    and $01                                       ; $642F
    add c                                         ; $6431
    ld c, a                                       ; $6432
    ld b, $00                                     ; $6433
    ld hl, Pen_CursorSpriteTbl                    ; $6435
    add hl, bc                                    ; $6438
    ld a, [hl]                                    ; $6439
    push af                                       ; $643A
    ld a, [wCursorX]                              ; $643B
    add $10                                       ; $643E
    ld b, a                                       ; $6440
    ld a, [wCursorY]                              ; $6441
    add $10                                       ; $6444
    ld c, a                                       ; $6446
    pop af                                        ; $6447
    call Oam_AddMeta_B01_4000                     ; $6448
    ret                                           ; $644B


; C: L3 pass 2026-10-26: read in BGB in 7 replay(s) of the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_CursorSpriteTbl::
    db $2b, $2c, $2d, $2e, $2f, $30, $31, $32

; C: cursor movement with acceleration ramp, edge counting and the pen speed
Pen_Update::
    ld a, [wPenSpeed]                             ; $6454
    cp $02                                        ; $6457
    jr nz, jr_004_6462                            ; $6459

    ldh a, [hFrameCounter]                        ; $645B
    and $03                                       ; $645D
    ret nz                                        ; $645F

    jr jr_004_646b                                ; $6460

jr_004_6462:
    cp $01                                        ; $6462
    jr c, jr_004_646b                             ; $6464

    ldh a, [hFrameCounter]                        ; $6466
    and $01                                       ; $6468
    ret nz                                        ; $646A

jr_004_646b:
    xor a                                         ; $646B
    ld [wEdgeDir], a                              ; $646C
    ld a, [wPenRampIndex]                         ; $646F
    sla a                                         ; $6472
    ld c, a                                       ; $6474
    ld b, $00                                     ; $6475
    ld hl, Pen_Update_Tbl658C                     ; $6477
    add hl, bc                                    ; $647A
    ld c, [hl]                                    ; $647B
    inc hl                                        ; $647C
    ld b, [hl]                                    ; $647D
    ldh a, [hKeysHeld]                            ; $647E
    ld [wPenKeys], a                              ; $6480
    ld hl, wCursorVx                              ; $6483
    ld a, [wPenKeys]                              ; $6486
    and $30                                       ; $6489
    swap a                                        ; $648B
    ld e, $02                                     ; $648D

jr_004_648f:
    bit 1, a                                      ; $648F
    jr z, jr_004_64a4                             ; $6491

    ld a, [hl]                                    ; $6493
    sub b                                         ; $6494
    ld [hl+], a                                   ; $6495
    ld a, [hl]                                    ; $6496
    sbc $00                                       ; $6497
    ld [hl], a                                    ; $6499
    cp $fe                                        ; $649A
    jr nz, jr_004_64e3                            ; $649C

    inc a                                         ; $649E
    ld [hl-], a                                   ; $649F
    xor a                                         ; $64A0
    ld [hl], a                                    ; $64A1
    jr jr_004_64e3                                ; $64A2

jr_004_64a4:
    bit 0, a                                      ; $64A4
    jr z, jr_004_64b9                             ; $64A6

    ld a, [hl]                                    ; $64A8
    add b                                         ; $64A9
    ld [hl+], a                                   ; $64AA
    ld a, [hl]                                    ; $64AB
    adc $00                                       ; $64AC
    ld [hl], a                                    ; $64AE
    cp $01                                        ; $64AF
    jr nz, jr_004_64e3                            ; $64B1

    xor a                                         ; $64B3
    ld [hl-], a                                   ; $64B4
    dec a                                         ; $64B5
    ld [hl], a                                    ; $64B6
    jr jr_004_64e3                                ; $64B7

jr_004_64b9:
    push de                                       ; $64B9
    ld e, [hl]                                    ; $64BA
    inc hl                                        ; $64BB
    ld d, [hl]                                    ; $64BC
    ld a, d                                       ; $64BD
    and a                                         ; $64BE
    push af                                       ; $64BF
    jr z, jr_004_64c9                             ; $64C0

    ld a, e                                       ; $64C2
    cpl                                           ; $64C3
    ld e, a                                       ; $64C4
    ld a, d                                       ; $64C5
    cpl                                           ; $64C6
    ld d, a                                       ; $64C7
    inc de                                        ; $64C8

jr_004_64c9:
    ld a, e                                       ; $64C9
    sub c                                         ; $64CA
    ld e, a                                       ; $64CB
    ld a, d                                       ; $64CC
    sbc $00                                       ; $64CD
    ld d, a                                       ; $64CF
    jr nc, jr_004_64d5                            ; $64D0

    ld de, $0000                                  ; $64D2

jr_004_64d5:
    pop af                                        ; $64D5
    jr z, jr_004_64df                             ; $64D6

    ld a, e                                       ; $64D8
    cpl                                           ; $64D9
    ld e, a                                       ; $64DA
    ld a, d                                       ; $64DB
    cpl                                           ; $64DC
    ld d, a                                       ; $64DD
    inc de                                        ; $64DE

jr_004_64df:
    ld [hl], d                                    ; $64DF
    dec hl                                        ; $64E0
    ld [hl], e                                    ; $64E1
    pop de                                        ; $64E2

jr_004_64e3:
    ld hl, wCursorVy                              ; $64E3
    ld a, [wPenKeys]                              ; $64E6
    and $c0                                       ; $64E9
    sla a                                         ; $64EB
    rr d                                          ; $64ED
    rlca                                          ; $64EF
    sla d                                         ; $64F0
    rla                                           ; $64F2
    dec e                                         ; $64F3
    jr nz, jr_004_648f                            ; $64F4

    ldh a, [hKeysHeld]                            ; $64F6
    and PADF_DPAD                                 ; $64F8
    jr z, jr_004_6503                             ; $64FA

    ld a, $03                                     ; $64FC
    ld [wPenIdleTimer], a                         ; $64FE
    jr jr_004_6517                                ; $6501

jr_004_6503:
    ld a, [wPenIdleTimer]                         ; $6503
    and a                                         ; $6506
    jr z, jr_004_650f                             ; $6507

    dec a                                         ; $6509
    ld [wPenIdleTimer], a                         ; $650A
    jr jr_004_6517                                ; $650D

jr_004_650f:
    xor a                                         ; $650F
    ld hl, wCursorVx                              ; $6510
    ld [hl+], a                                   ; $6513
    ld [hl+], a                                   ; $6514
    ld [hl+], a                                   ; $6515
    ld [hl], a                                    ; $6516

jr_004_6517:
    ld hl, wCursorXFrac                           ; $6517
    ld a, [wCursorVx + $1]                        ; $651A
    ld d, a                                       ; $651D
    ld a, [wCursorVx]                             ; $651E
    ld e, a                                       ; $6521
    ld c, $02                                     ; $6522

jr_004_6524:
    ld a, [hl]                                    ; $6524
    add e                                         ; $6525
    ld [hl+], a                                   ; $6526
    ld a, [hl]                                    ; $6527
    adc d                                         ; $6528
    ld [hl], a                                    ; $6529
    ld hl, wCursorYFrac                           ; $652A
    ld a, [wCursorVy + $1]                        ; $652D
    ld d, a                                       ; $6530
    ld a, [wCursorVy]                             ; $6531
    ld e, a                                       ; $6534
    dec c                                         ; $6535
    jr nz, jr_004_6524                            ; $6536

    ld a, [wPenSize]                              ; $6538
    sla a                                         ; $653B
    sla a                                         ; $653D
    ld c, a                                       ; $653F
    ld b, $00                                     ; $6540
    ld hl, Pen_Update_Tbl657C                     ; $6542
    add hl, bc                                    ; $6545
    ld de, wCursorX                               ; $6546
    ld a, $30                                     ; $6549
    ldh [hScratchA], a                            ; $654B
    ld b, $02                                     ; $654D

jr_004_654f:
    push hl                                       ; $654F
    ld a, [de]                                    ; $6550
    cp $c0                                        ; $6551
    jr c, jr_004_6562                             ; $6553

    cp [hl]                                       ; $6555
    jr nc, jr_004_656e                            ; $6556

    ldh a, [hScratchA]                            ; $6558
    and $60                                       ; $655A
    ld [wEdgeDir], a                              ; $655C
    ld a, [hl]                                    ; $655F
    jr jr_004_656e                                ; $6560

jr_004_6562:
    inc hl                                        ; $6562
    cp [hl]                                       ; $6563
    jr c, jr_004_656e                             ; $6564

    ldh a, [hScratchA]                            ; $6566
    and $90                                       ; $6568
    ld [wEdgeDir], a                              ; $656A
    ld a, [hl]                                    ; $656D

jr_004_656e:
    pop hl                                        ; $656E
    ld [de], a                                    ; $656F
    ld a, $c0                                     ; $6570
    ldh [hScratchA], a                            ; $6572
    inc hl                                        ; $6574
    inc hl                                        ; $6575
    inc de                                        ; $6576
    inc de                                        ; $6577
    dec b                                         ; $6578
    jr nz, jr_004_654f                            ; $6579

    ret                                           ; $657B


; C: auto: 16 bytes, bytes; referenced by Pen_Update. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Update_Tbl657C::
    db $ff, $81, $ff, $71, $ff, $81, $ff, $71, $fd, $82, $fd, $72, $fc, $84, $fc, $74

; C: auto: 114 bytes, bytes; referenced by Pen_Update. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Update_Tbl658C::
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
    ldh a, [hKeysHeld]                            ; $65FE
    bit PADB_A, a                                 ; $6600
    ret z                                         ; $6602

    ldh a, [hFrameCounter]                        ; $6603
    and $1f                                       ; $6605
    jr nz, jr_004_6610                            ; $6607

    play_sfx1 SFX1_KEY_A                          ; $6609

jr_004_6610:
    ld a, $01                                     ; $6610
    ld [wDirtyFlag], a                            ; $6612
    ld a, [wPenSize]                              ; $6615
    sla a                                         ; $6618
    ld c, a                                       ; $661A
    ld b, $00                                     ; $661B
    ld hl, Pen_Draw_Tbl6648                       ; $661D
    add hl, bc                                    ; $6620
    ld a, [wCursorX]                              ; $6621
    add [hl]                                      ; $6624
    add $10                                       ; $6625
    ld b, a                                       ; $6627
    inc hl                                        ; $6628
    ld a, [wCursorY]                              ; $6629
    add [hl]                                      ; $662C
    add $10                                       ; $662D
    ld c, a                                       ; $662F
    ld hl, wPenPattern                            ; $6630
    ld a, [wPenSize]                              ; $6633
    sla a                                         ; $6636
    sla a                                         ; $6638
    add [hl]                                      ; $663A
    ld e, a                                       ; $663B
    ld d, $00                                     ; $663C
    ld hl, Pen_Draw_Tbl6650                       ; $663E
    add hl, de                                    ; $6641
    ld e, [hl]                                    ; $6642
    add hl, de                                    ; $6643
    call Blit_SpriteToBg                          ; $6644
    ret                                           ; $6647


; C: auto: 8 bytes, bytes; referenced by Pen_Draw. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Draw_Tbl6648::
    db $00, $00, $00, $00, $fe, $fe, $fc, $fc

; C: auto: 108 bytes, bytes; referenced by Pen_Draw. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 10 (tcrf_check/assets/l3_names/)
Pen_Draw_Tbl6650::
    db $10, $14, $18, $1c, $23, $27, $2b, $2f, $36, $3a, $3e, $42, $49, $4d, $51, $55
    db $88, $08
    dw TileSet_27_4AB0 + $20
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $10
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dwb TileSet_27_4AB0
    db $08, $08
    dw TileSet_27_4AB0 + $30
    db BANK(TileSet_27_4AB0)
    dw Src_19_7E60_Tbl53A6_4 + $180
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_4AB0 + $60
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $50
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $40
    db BANK(TileSet_27_4AB0)
    db $08, $08
    dw TileSet_27_4AB0 + $70
    db BANK(TileSet_27_4AB0)
    dw Src_19_7E60_Tbl53A6_4 + $188
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_4AB0 + $A0
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $90
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $80
    db BANK(TileSet_27_4AB0)
    db $08, $08
    dw TileSet_27_4AB0 + $B0
    db BANK(TileSet_27_4AB0)
    dw Src_19_7E60_Tbl53A6_4 + $190
    db BANK(Src_19_7E60_Tbl53A6_4)
    db $88, $08
    dw TileSet_27_4AB0 + $E0
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $D0
    db BANK(TileSet_27_4AB0)
    db $88, $08
    dw TileSet_27_4AB0 + $C0
    db BANK(TileSet_27_4AB0)
    db $08, $08
    dw TileSet_27_4AB0 + $F0
    db BANK(TileSet_27_4AB0)
    dw Src_19_7E60_Tbl53A6_4 + $198
    db BANK(Src_19_7E60_Tbl53A6_4)

; C: sound $12 and window slide
PenMenu_SlideOpen::
    play_sfx1 SFX1_PANEL_OPEN                     ; $66BC
    call Oam_ClearShadow                          ; $66C3
    rst Rst08_WaitVBlank                          ; $66C6
    ld hl, Slide_WyDeltaTbl                       ; $66C7
    ld b, $24                                     ; $66CA

jr_004_66cc:
    push bc                                       ; $66CC
    push hl                                       ; $66CD
    ldh a, [hWyShadow]                            ; $66CE
    add [hl]                                      ; $66D0
    ldh [hWyShadow], a                            ; $66D1
    rst Rst08_WaitVBlank                          ; $66D3
    pop hl                                        ; $66D4
    pop bc                                        ; $66D5
    inc hl                                        ; $66D6
    dec b                                         ; $66D7
    jr nz, jr_004_66cc                            ; $66D8

    ret                                           ; $66DA


; C: build the panel then sound $13 and slide back
PenMenu_SlideClose::
    call PenMenu_Build                            ; $66DB
    play_sfx1 SFX1_PANEL_CLOSE                    ; $66DE
    ld hl, Slide_WyDeltaTbl                       ; $66E5
    ld b, $24                                     ; $66E8

jr_004_66ea:
    push bc                                       ; $66EA
    push hl                                       ; $66EB
    ldh a, [hWyShadow]                            ; $66EC
    sub [hl]                                      ; $66EE
    ldh [hWyShadow], a                            ; $66EF
    rst Rst08_WaitVBlank                          ; $66F1
    pop hl                                        ; $66F2
    pop bc                                        ; $66F3
    inc hl                                        ; $66F4
    dec b                                         ; $66F5
    jr nz, jr_004_66ea                            ; $66F6

    ret                                           ; $66F8


; C: loads the panel graphics and builds the page of the current row
PenMenu_Build::
    farcopy Vram_CopyFromBank, Gfx_14_75E0_PenMenu_Build, $8fe0, $0020 ; $66F9
    farcopy Vram_CopyFromBank, Map_24_7860_PenMenu_Build, $9c00, $0100 ; $6707
    ld a, [wPenMenuRow]                           ; $6715
    and a                                         ; $6718
    jr nz, jr_004_6732                            ; $6719

    farcopy Vram_CopyFromBank, Gfx_14_7A00_PenMenu_Build, $8a00, $0430 ; $671B
    call PenMenu_BuildSize                        ; $6729
    set_state STATE_10_MENU_SIZE                  ; $672C
    ret                                           ; $6731


jr_004_6732:
    cp $01                                        ; $6732
    jr nz, jr_004_674d                            ; $6734

    farcopy Vram_CopyFromBank, Gfx_14_7600_PenMenu_Build, $8a00, $0400 ; $6736
    call PenMenu_BuildPattern                     ; $6744
    set_state STATE_10_MENU_PATTERN               ; $6747
    ret                                           ; $674C


jr_004_674d:
    farcopy Vram_CopyFromBank, Gfx_14_7000_PenMenu_Build, $8a00, $0430 ; $674D
    call PenMenu_BuildSpeed                       ; $675B
    set_state STATE_10_MENU_SPEED                 ; $675E
    ret                                           ; $6763


; C
PenMenu_BuildSize::
    farcopy Vram_CopyFromBank, Map_24_4B00_PenMenu_BuildSize, $9c00, $0020 ; $6764
    ld a, [wPenSize]                              ; $6772
    sla a                                         ; $6775
    ld c, a                                       ; $6777
    ld b, $00                                     ; $6778
    ld hl, PenMenu_BuildSize_PtrTbl67A5           ; $677A
    add hl, bc                                    ; $677D
    ld a, [hl+]                                   ; $677E
    ld h, [hl]                                    ; $677F
    ld l, a                                       ; $6780
    ld a, $24                                     ; $6781
    ld de, $9c20                                  ; $6783
    ld bc, $00c0                                  ; $6786
    call Vram_CopyFromBank                        ; $6789
    farcopy Vram_CopyFromBank, Map_24_4BE0_PenMenu_BuildSize, $9ce0, $0020 ; $678C
    ld a, [wPenSize]                              ; $679A
    ld [wPenMenuItem], a                          ; $679D
    xor a                                         ; $67A0
    ld [wPenMenuPage], a                          ; $67A1
    ret                                           ; $67A4


; C: auto: 8 bytes, word table; referenced by PenMenu_BuildSize. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildSize_PtrTbl67A5::
    dw Map_24_4B20_PenMenuSizePanel0
    dw Map_24_4C00_PenMenuSizePanel1
    dw Map_24_4CC0_PenMenuSizePanel2
    dw Map_24_4D80_PenMenuSizePanel3

; C
PenMenu_BuildPattern::
    farcopy Vram_CopyFromBank, Map_24_4B00_PenMenu_BuildSize, $9c00, $0020 ; $67AD
    ld a, [wPenPattern]                           ; $67BB
    sla a                                         ; $67BE
    ld c, a                                       ; $67C0
    ld b, $00                                     ; $67C1
    ld hl, PenMenu_BuildPattern_PtrTbl67EF        ; $67C3
    add hl, bc                                    ; $67C6
    ld a, [hl+]                                   ; $67C7
    ld h, [hl]                                    ; $67C8
    ld l, a                                       ; $67C9
    ld a, $24                                     ; $67CA
    ld de, $9c20                                  ; $67CC
    ld bc, $00c0                                  ; $67CF
    call Vram_CopyFromBank                        ; $67D2
    farcopy Vram_CopyFromBank, Map_24_4BE0_PenMenu_BuildSize, $9ce0, $0020 ; $67D5
    ld a, [wPenPattern]                           ; $67E3
    ld [wPenMenuItem], a                          ; $67E6
    ld a, $01                                     ; $67E9
    ld [wPenMenuPage], a                          ; $67EB
    ret                                           ; $67EE


; C: auto: 8 bytes, word table; referenced by PenMenu_BuildPattern. L3 pass 2026-10-26: read in BGB in 2 replay(s) of
; the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildPattern_PtrTbl67EF::
    dw Map_24_4E60_PenMenuPatternPanel0
    dw Map_24_4F40_PenMenuPatternPanel1
    dw Map_24_5000_PenMenuPatternPanel2
    dw Map_24_50C0_PenMenuPatternPanel3

; C
PenMenu_BuildSpeed::
    farcopy Vram_CopyFromBank, Map_24_76A0_PenMenu_BuildSpeed, $9c00, $0020 ; $67F7
    ld a, [wPenSpeed]                             ; $6805
    sla a                                         ; $6808
    ld c, a                                       ; $680A
    ld b, $00                                     ; $680B
    ld hl, PenMenu_BuildSpeed_PtrTbl6839          ; $680D
    add hl, bc                                    ; $6810
    ld a, [hl+]                                   ; $6811
    ld h, [hl]                                    ; $6812
    ld l, a                                       ; $6813
    ld a, $24                                     ; $6814
    ld de, $9c20                                  ; $6816
    ld bc, $0060                                  ; $6819
    call Vram_CopyFromBank                        ; $681C
    farcopy Vram_CopyFromBank, Map_24_7720_PenMenu_BuildSpeed, $9c80, $0080 ; $681F
    ld a, [wPenSpeed]                             ; $682D
    ld [wPenMenuItem], a                          ; $6830
    ld a, $02                                     ; $6833
    ld [wPenMenuPage], a                          ; $6835
    ret                                           ; $6838


; C: auto: 6 bytes, word table; referenced by PenMenu_BuildSpeed. L3 pass 2026-10-26: read in BGB in 1 replay(s) of
; the organic corpus, modes 10 (tcrf_check/assets/l3_names/)
PenMenu_BuildSpeed_PtrTbl6839::
    dw Map_24_76C0_PenMenuSpeedPanel0
    dw Map_24_77A0_PenMenuSpeedPanel1
    dw Map_24_7800_PenMenuSpeedPanel2

; C: mode 09: album viewer with the edit pages (the guide's Album: Paint / Stamp / Frame / Comment / Print / Delete)
Mode09_AlbumEdit::
    ld a, [wState]                                ; $683F
    rst Rst18_JumpTable                           ; $6842

; C: 14 states, rst $18 table of mode $09
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $685F
    ldh [hLcdcShadow], a                          ; $6861
    ld a, $e4                                     ; $6863
    ld [wPaletteTarget], a                        ; $6865
    ld [wPaletteTarget + $1], a                   ; $6868
    ld a, $c6                                     ; $686B
    ld [wPaletteTarget + $2], a                   ; $686D
    ld a, $10                                     ; $6870
    ldh [hScxShadow], a                           ; $6872
    ldh [hScyShadow], a                           ; $6874
    xor a                                         ; $6876
    ld [wChoiceCursorA], a                        ; $6877
    ld [wChoiceCursorB], a                        ; $687A
    ld [wSliderRedraw], a                         ; $687D
    ld [wSliderTimer], a                          ; $6880
    farcopy Mem_CopyFromBank, Gfx_0C_7800_Mode09_State00_Init, $8900, $0300 ; $6883
    farcopy Mem_CopyFromBank, Gfx_0C_7B00_Mode09_State00_Init, $8500, $0300 ; $6891
    farcopy Mem_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $689F
    farcopy Mem_CopyFromBank, Gfx_0C_7FD0_Mode09_State00_Init, $8f70, $0030 ; $68AD
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $68BB
    ld hl, $9ac0                                  ; $68C9
    ld bc, $0140                                  ; $68CC
    ld a, $ff                                     ; $68CF
    call Mem_FillBc1                              ; $68D1
    ld a, [wPhotoNumberSel]                       ; $68D4
    ldh [hFarcallAArg], a                         ; $68D7
    farcall Photo_LoadToVram_Far                  ; $68D9
    ld a, $54                                     ; $68E1
    ldh [hLycShadowSplit1], a                     ; $68E3
    ldh [hSplit1Latch], a                         ; $68E5
    ld hl, hStatShadow                            ; $68E7
    set 6, [hl]                                   ; $68EA
    ld hl, rIE                                    ; $68EC
    set 1, [hl]                                   ; $68EF
    ld a, $01                                     ; $68F1
    ldh [hStatHandlerIndex], a                    ; $68F3
    screen_on                                     ; $68F5
    play_music MUSIC_ALBUM_VIEWER                 ; $68FE
    call Album_DrawPhotoNumber                    ; $6905
    call Pal_FadeIn                               ; $6908
    set_state STATE_09_SLIDER_BROWSE              ; $690B
    ret                                           ; $6910


; C: photo number slider at the bottom; Left / Right moves it
Mode09_State01_SliderBrowse::
    call Slider_Input                             ; $6911
    call Slider_Update                            ; $6914
    call Slider_DrawBar                           ; $6917
    ld a, [wSliderRedraw]                         ; $691A
    and a                                         ; $691D
    jr z, jr_004_6943                             ; $691E

    call Oam_HideUnused                           ; $6920
    ld a, [wPhotoNumberSel]                       ; $6923
    ldh [hFarcallAArg], a                         ; $6926
    farcall Photo_LoadToVram_Far                  ; $6928
    call Album_DrawPhotoNumber                    ; $6930
    ldh a, [hKeysHeld]                            ; $6933
    bit PADB_A, a                                 ; $6935
    jr nz, jr_004_6939                            ; $6937

jr_004_6939:
    call Slider_Update                            ; $6939
    call Slider_DrawBar                           ; $693C
    xor a                                         ; $693F
    ld [wSliderRedraw], a                         ; $6940

jr_004_6943:
    ldh a, [hKeysNewSticky]                       ; $6943
    and PADF_A | PADF_SELECT                      ; $6945
    jr z, jr_004_6960                             ; $6947

    play_sfx1 SFX1_KEY_SELECT                     ; $6949
    ld a, [wPhotoNumberSel]                       ; $6950
    ld hl, wPhotoCount                            ; $6953
    cp [hl]                                       ; $6956
    ret nc                                        ; $6957

    call Album_ShowPageScreenB                    ; $6958
    next_state                                    ; $695B
    ret                                           ; $695F


jr_004_6960:
    ldh a, [hKeysNewSticky]                       ; $6960
    bit PADB_B, a                                 ; $6962
    ret z                                         ; $6964

    play_sfx1 SFX1_KEY_B                          ; $6965
    set_state STATE_09_LEAVE_TO_SHOOT             ; $696C
    ret                                           ; $6971


; C: photo with four blinking arrows: each direction opens an edit page
Mode09_State02_PhotoArrows::
    ld a, [wBlinkCounter]                         ; $6972
    inc a                                         ; $6975
    ld [wBlinkCounter], a                         ; $6976
    bit 4, a                                      ; $6979
    jr z, jr_004_699d                             ; $697B

    ld a, $a3                                     ; $697D
    ld bc, $5078                                  ; $697F
    call Oam_AddMeta_B01_4000                     ; $6982
    ld a, $a2                                     ; $6985
    ld bc, $5018                                  ; $6987
    call Oam_AddMeta_B01_4000                     ; $698A
    ld a, $a5                                     ; $698D
    ld bc, $1848                                  ; $698F
    call Oam_AddMeta_B01_4000                     ; $6992
    ld a, $a4                                     ; $6995
    ld bc, $8848                                  ; $6997
    call Oam_AddMeta_B01_4000                     ; $699A

jr_004_699d:
    ldh a, [hKeysNew]                             ; $699D
    and PADF_B | PADF_SELECT                      ; $699F
    jr z, jr_004_69b2                             ; $69A1

    play_sfx1 SFX1_KEY_B                          ; $69A3
    call Album_ShowPageScreen                     ; $69AA
    ld hl, wState                                 ; $69AD
    dec [hl]                                      ; $69B0
    ret                                           ; $69B1


jr_004_69b2:
    ldh a, [hKeysNewRepeat]                       ; $69B2
    and PADF_DPAD                                 ; $69B4
    ret z                                         ; $69B6

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $69B7
    xor a                                         ; $69BE
    ld [wArrowAnimTick], a                        ; $69BF
    ld [wArrowAnimFrame], a                       ; $69C2
    ldh a, [hKeysNewRepeat]                       ; $69C5
    bit PADB_LEFT, a                              ; $69C7
    jr z, jr_004_6a03                             ; $69C9

    call Oam_ClearShadow                          ; $69CB
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $69CE
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $69DC
    ld hl, Slide_ScyDeltaTbl                      ; $69EA
    ld b, $10                                     ; $69ED

jr_004_69ef:
    push bc                                       ; $69EF
    push hl                                       ; $69F0
    ldh a, [hScxShadow]                           ; $69F1
    add [hl]                                      ; $69F3
    ldh [hScxShadow], a                           ; $69F4
    rst Rst08_WaitVBlank                          ; $69F6
    pop hl                                        ; $69F7
    pop bc                                        ; $69F8
    inc hl                                        ; $69F9
    dec b                                         ; $69FA
    jr nz, jr_004_69ef                            ; $69FB

    set_state STATE_09_PAGE_LEFT                  ; $69FD
    ret                                           ; $6A02


jr_004_6a03:
    bit 4, a                                      ; $6A03
    jr z, jr_004_6a3f                             ; $6A05

    call Oam_ClearShadow                          ; $6A07
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $6A0A
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $6A18
    ld hl, Slide_ScyDeltaTbl                      ; $6A26
    ld b, $10                                     ; $6A29

jr_004_6a2b:
    push bc                                       ; $6A2B
    push hl                                       ; $6A2C
    ldh a, [hScxShadow]                           ; $6A2D
    sub [hl]                                      ; $6A2F
    ldh [hScxShadow], a                           ; $6A30
    rst Rst08_WaitVBlank                          ; $6A32
    pop hl                                        ; $6A33
    pop bc                                        ; $6A34
    inc hl                                        ; $6A35
    dec b                                         ; $6A36
    jr nz, jr_004_6a2b                            ; $6A37

    set_state STATE_09_PAGE_RIGHT                 ; $6A39
    ret                                           ; $6A3E


jr_004_6a3f:
    bit 6, a                                      ; $6A3F
    jr z, jr_004_6a80                             ; $6A41

    call Oam_ClearShadow                          ; $6A43
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $6A46
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6A54
    ld hl, Slide_ScyDeltaTbl                      ; $6A62
    ld b, $10                                     ; $6A65

jr_004_6a67:
    push bc                                       ; $6A67
    push hl                                       ; $6A68
    ldh a, [hScyShadow]                           ; $6A69
    add [hl]                                      ; $6A6B
    ldh [hScyShadow], a                           ; $6A6C
    cpl                                           ; $6A6E
    add $64                                       ; $6A6F
    ldh [hLycShadowSplit1], a                     ; $6A71
    rst Rst08_WaitVBlank                          ; $6A73
    pop hl                                        ; $6A74
    pop bc                                        ; $6A75
    inc hl                                        ; $6A76
    dec b                                         ; $6A77
    jr nz, jr_004_6a67                            ; $6A78

    set_state STATE_09_PAGE_UP                    ; $6A7A
    ret                                           ; $6A7F


jr_004_6a80:
    bit 7, a                                      ; $6A80
    ret z                                         ; $6A82

    call Oam_ClearShadow                          ; $6A83
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $6A86
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $6A94
    ld hl, Slide_ScyDeltaTbl                      ; $6AA2
    ld b, $10                                     ; $6AA5

jr_004_6aa7:
    push bc                                       ; $6AA7
    push hl                                       ; $6AA8
    ldh a, [hScyShadow]                           ; $6AA9
    sub [hl]                                      ; $6AAB
    ldh [hScyShadow], a                           ; $6AAC
    cpl                                           ; $6AAE
    add $64                                       ; $6AAF
    ldh [hLycShadowSplit1], a                     ; $6AB1
    rst Rst08_WaitVBlank                          ; $6AB3
    pop hl                                        ; $6AB4
    pop bc                                        ; $6AB5
    inc hl                                        ; $6AB6
    dec b                                         ; $6AB7
    jr nz, jr_004_6aa7                            ; $6AB8

    set_state STATE_09_PAGE_DOWN                  ; $6ABA
    ret                                           ; $6ABF


; C: left page: choice A (Paint / Stamp)
Mode09_State03_PageLeft::
    call AlbumPage_ReadChoiceA                    ; $6AC0
    call AlbumPage_DrawChoiceA                    ; $6AC3
    ldh a, [hKeysNew]                             ; $6AC6
    and PADF_A | PADF_B | PADF_RIGHT              ; $6AC8
    ret z                                         ; $6ACA

    push af                                       ; $6ACB
    bit 0, a                                      ; $6ACC
    ld a, SFX1_PAGE_STEP                          ; $6ACE
    call nz, Snd_Sfx1                             ; $6AD0
    pop af                                        ; $6AD3
    push af                                       ; $6AD4
    bit 1, a                                      ; $6AD5
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6AD7
    call nz, Snd_Sfx1                             ; $6AD9
    pop af                                        ; $6ADC
    push af                                       ; $6ADD
    bit 4, a                                      ; $6ADE
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6AE0
    call nz, Snd_Sfx1                             ; $6AE2
    pop af                                        ; $6AE5
    push af                                       ; $6AE6
    bit 0, a                                      ; $6AE7
    jp z, Mode09_State03_PageLeft_SlideOut        ; $6AE9

    ld hl, wArrowAnimFrame                        ; $6AEC
    inc [hl]                                      ; $6AEF
    call Oam_HideUnused                           ; $6AF0
    rst Rst08_WaitVBlank                          ; $6AF3
    ld hl, $9880                                  ; $6AF4
    ld a, [wChoiceCursorA]                        ; $6AF7
    and a                                         ; $6AFA
    jr z, jr_004_6b00                             ; $6AFB

    ld hl, $9980                                  ; $6AFD

jr_004_6b00:
    call Album_DrawChoiceMarker                   ; $6B00

jr_004_6b03:
    call AlbumPage_DrawChoiceA                    ; $6B03
    call Oam_HideUnused                           ; $6B06
    rst Rst08_WaitVBlank                          ; $6B09
    ld a, [wArrowAnimFrame]                       ; $6B0A
    cp $02                                        ; $6B0D
    jr nz, jr_004_6b03                            ; $6B0F

; C: tail of the page-left key: clears the OAM shadow and slides the page with the 16-step table Tbl2FB5 (rSCX -
; table), then state 2 or the fade-out (branch target; code read 2026-10-19)
Mode09_State03_PageLeft_SlideOut::
    call Oam_ClearShadow                          ; $6B11
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6B14
    ld b, $10                                     ; $6B17

jr_004_6b19:
    push bc                                       ; $6B19
    push hl                                       ; $6B1A
    ldh a, [hScxShadow]                           ; $6B1B
    sub [hl]                                      ; $6B1D
    ldh [hScxShadow], a                           ; $6B1E
    rst Rst08_WaitVBlank                          ; $6B20
    pop hl                                        ; $6B21
    pop bc                                        ; $6B22
    inc hl                                        ; $6B23
    dec b                                         ; $6B24
    jr nz, jr_004_6b19                            ; $6B25

    pop af                                        ; $6B27
    bit 0, a                                      ; $6B28
    jr nz, jr_004_6b32                            ; $6B2A

    set_state STATE_09_PHOTO_ARROWS               ; $6B2C
    ret                                           ; $6B31


jr_004_6b32:
    screen_off                                    ; $6B32
    stat_irq_off                                  ; $6B38
    ld a, [wPhotoNumberSel]                       ; $6B42
    ld [wPhotoIndex], a                           ; $6B45
    ld a, $01                                     ; $6B48
    ld [wAbResult], a                             ; $6B4A
    ld a, $01                                     ; $6B4D
    ld [wCallerCode], a                           ; $6B4F
    xor a                                         ; $6B52
    ld [wDoodleFromShutterbug], a                 ; $6B53
    ld a, [wChoiceCursorA]                        ; $6B56
    and a                                         ; $6B59
    jr nz, jr_004_6b67                            ; $6B5A

    ld a, MODE_PAINT                              ; $6B5C
    ld [wMode], a                                 ; $6B5E
    set_state STATE_10_SETUP                      ; $6B61
    ret                                           ; $6B66


jr_004_6b67:
    ld a, MODE_STAMP                              ; $6B67
    ld [wMode], a                                 ; $6B69
    set_state STATE_11_SETUP                      ; $6B6C
    ret                                           ; $6B71


; C: right page: choice B (Frame / Comment)
Mode09_State04_PageRight::
    call AlbumPage_ReadChoiceB                    ; $6B72
    call AlbumPage_DrawChoiceB                    ; $6B75
    ldh a, [hKeysNew]                             ; $6B78
    and PADF_A | PADF_B | PADF_LEFT               ; $6B7A
    ret z                                         ; $6B7C

    push af                                       ; $6B7D
    bit 0, a                                      ; $6B7E
    ld a, SFX1_PAGE_STEP                          ; $6B80
    call nz, Snd_Sfx1                             ; $6B82
    pop af                                        ; $6B85
    push af                                       ; $6B86
    bit 1, a                                      ; $6B87
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6B89
    call nz, Snd_Sfx1                             ; $6B8B
    pop af                                        ; $6B8E
    push af                                       ; $6B8F
    bit 5, a                                      ; $6B90
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6B92
    call nz, Snd_Sfx1                             ; $6B94
    pop af                                        ; $6B97
    push af                                       ; $6B98
    bit 0, a                                      ; $6B99
    jr z, jr_004_6bc2                             ; $6B9B

    ld hl, wArrowAnimFrame                        ; $6B9D
    inc [hl]                                      ; $6BA0
    call Oam_HideUnused                           ; $6BA1
    rst Rst08_WaitVBlank                          ; $6BA4
    ld hl, $9896                                  ; $6BA5
    ld a, [wChoiceCursorB]                        ; $6BA8
    and a                                         ; $6BAB
    jr z, jr_004_6bb1                             ; $6BAC

    ld hl, $9996                                  ; $6BAE

jr_004_6bb1:
    call Album_DrawChoiceMarker                   ; $6BB1

jr_004_6bb4:
    call AlbumPage_DrawChoiceB                    ; $6BB4
    call Oam_HideUnused                           ; $6BB7
    rst Rst08_WaitVBlank                          ; $6BBA
    ld a, [wArrowAnimFrame]                       ; $6BBB
    cp $02                                        ; $6BBE
    jr nz, jr_004_6bb4                            ; $6BC0

jr_004_6bc2:
    call Oam_ClearShadow                          ; $6BC2
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6BC5
    ld b, $10                                     ; $6BC8

jr_004_6bca:
    push bc                                       ; $6BCA
    push hl                                       ; $6BCB
    ldh a, [hScxShadow]                           ; $6BCC
    add [hl]                                      ; $6BCE
    ldh [hScxShadow], a                           ; $6BCF
    rst Rst08_WaitVBlank                          ; $6BD1
    pop hl                                        ; $6BD2
    pop bc                                        ; $6BD3
    inc hl                                        ; $6BD4
    dec b                                         ; $6BD5
    jr nz, jr_004_6bca                            ; $6BD6

    pop af                                        ; $6BD8
    bit 0, a                                      ; $6BD9
    jr nz, jr_004_6be3                            ; $6BDB

    set_state STATE_09_PHOTO_ARROWS               ; $6BDD
    ret                                           ; $6BE2


jr_004_6be3:
    ld a, [wChoiceCursorB]                        ; $6BE3
    and a                                         ; $6BE6
    jr nz, jr_004_6bef                            ; $6BE7

    set_state STATE_09_FRAME_INIT                 ; $6BE9
    ret                                           ; $6BEE


jr_004_6bef:
    set_state STATE_09_COMMENT_INIT               ; $6BEF
    ret                                           ; $6BF4


; C: up page: Print (mode 1C)
Mode09_State05_PageUp::
    call AlbumPage_DrawUp                         ; $6BF5
    ldh a, [hKeysNew]                             ; $6BF8
    and PADF_A | PADF_B | PADF_DOWN               ; $6BFA
    ret z                                         ; $6BFC

    push af                                       ; $6BFD
    bit 0, a                                      ; $6BFE
    ld a, SFX1_PAGE_STEP                          ; $6C00
    call nz, Snd_Sfx1                             ; $6C02
    pop af                                        ; $6C05
    push af                                       ; $6C06
    bit 1, a                                      ; $6C07
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6C09
    call nz, Snd_Sfx1                             ; $6C0B
    pop af                                        ; $6C0E
    push af                                       ; $6C0F
    bit 7, a                                      ; $6C10
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6C12
    call nz, Snd_Sfx1                             ; $6C14
    pop af                                        ; $6C17
    push af                                       ; $6C18
    bit 0, a                                      ; $6C19
    jr z, jr_004_6c39                             ; $6C1B

    ld hl, wArrowAnimFrame                        ; $6C1D
    inc [hl]                                      ; $6C20
    call Oam_HideUnused                           ; $6C21
    rst Rst08_WaitVBlank                          ; $6C24
    ld hl, $9808                                  ; $6C25
    call Album_DrawChoiceMarker                   ; $6C28

jr_004_6c2b:
    call AlbumPage_DrawUp                         ; $6C2B
    call Oam_HideUnused                           ; $6C2E
    rst Rst08_WaitVBlank                          ; $6C31
    ld a, [wArrowAnimFrame]                       ; $6C32
    cp $02                                        ; $6C35
    jr nz, jr_004_6c2b                            ; $6C37

jr_004_6c39:
    call Oam_ClearShadow                          ; $6C39
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6C3C
    ld b, $10                                     ; $6C3F

jr_004_6c41:
    push bc                                       ; $6C41
    push hl                                       ; $6C42
    ldh a, [hScyShadow]                           ; $6C43
    sub [hl]                                      ; $6C45
    ldh [hScyShadow], a                           ; $6C46
    cpl                                           ; $6C48
    add $64                                       ; $6C49
    ldh [hLycShadowSplit1], a                     ; $6C4B
    rst Rst08_WaitVBlank                          ; $6C4D
    pop hl                                        ; $6C4E
    pop bc                                        ; $6C4F
    inc hl                                        ; $6C50
    dec b                                         ; $6C51
    jr nz, jr_004_6c41                            ; $6C52

    pop af                                        ; $6C54
    bit 0, a                                      ; $6C55
    jr nz, jr_004_6c5f                            ; $6C57

    set_state STATE_09_PHOTO_ARROWS               ; $6C59
    ret                                           ; $6C5E


jr_004_6c5f:
    screen_off                                    ; $6C5F
    stat_irq_off                                  ; $6C65
    ld a, [wPhotoNumberSel]                       ; $6C6F
    ld [wPhotoIndex], a                           ; $6C72
    ld a, $01                                     ; $6C75
    ld [wAbResult], a                             ; $6C77
    ld a, $01                                     ; $6C7A
    ld [wCallerCode], a                           ; $6C7C
    xor a                                         ; $6C7F
    ld [wPrintLayoutFlag], a                      ; $6C80
    ld [wBorderNormalised], a                     ; $6C83
    ld [wPrintExtraFlag], a                       ; $6C86
    ld a, MODE_PRINT_PHOTO_PICKER                 ; $6C89
    ld [wMode], a                                 ; $6C8B
    set_state STATE_1C_SHOW_PRINT_SCREEN          ; $6C8E
    ret                                           ; $6C93


; C: down page: Delete (mode 0F with caller_code 1)
Mode09_State06_PageDown::
    call AlbumPage_DrawDown                       ; $6C94
    ldh a, [hKeysNew]                             ; $6C97
    and PADF_A | PADF_B | PADF_UP                 ; $6C99
    ret z                                         ; $6C9B

    push af                                       ; $6C9C
    bit 0, a                                      ; $6C9D
    ld a, SFX1_PAGE_STEP                          ; $6C9F
    call nz, Snd_Sfx1                             ; $6CA1
    pop af                                        ; $6CA4
    push af                                       ; $6CA5
    bit 1, a                                      ; $6CA6
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6CA8
    call nz, Snd_Sfx1                             ; $6CAA
    pop af                                        ; $6CAD
    push af                                       ; $6CAE
    bit 6, a                                      ; $6CAF
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $6CB1
    call nz, Snd_Sfx1                             ; $6CB3
    pop af                                        ; $6CB6
    push af                                       ; $6CB7
    bit 0, a                                      ; $6CB8
    jr z, jr_004_6cd8                             ; $6CBA

    ld hl, wArrowAnimFrame                        ; $6CBC
    inc [hl]                                      ; $6CBF
    call Oam_HideUnused                           ; $6CC0
    rst Rst08_WaitVBlank                          ; $6CC3
    ld hl, $9a88                                  ; $6CC4
    call Album_DrawChoiceMarker                   ; $6CC7

jr_004_6cca:
    call AlbumPage_DrawDown                       ; $6CCA
    call Oam_HideUnused                           ; $6CCD
    rst Rst08_WaitVBlank                          ; $6CD0
    ld a, [wArrowAnimFrame]                       ; $6CD1
    cp $02                                        ; $6CD4
    jr nz, jr_004_6cca                            ; $6CD6

jr_004_6cd8:
    call Oam_ClearShadow                          ; $6CD8
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $6CDB
    ld b, $10                                     ; $6CDE

jr_004_6ce0:
    push bc                                       ; $6CE0
    push hl                                       ; $6CE1
    ldh a, [hScyShadow]                           ; $6CE2
    add [hl]                                      ; $6CE4
    ldh [hScyShadow], a                           ; $6CE5
    cpl                                           ; $6CE7
    add $64                                       ; $6CE8
    ldh [hLycShadowSplit1], a                     ; $6CEA
    rst Rst08_WaitVBlank                          ; $6CEC
    pop hl                                        ; $6CED
    pop bc                                        ; $6CEE
    inc hl                                        ; $6CEF
    dec b                                         ; $6CF0
    jr nz, jr_004_6ce0                            ; $6CF1

    pop af                                        ; $6CF3
    bit 0, a                                      ; $6CF4
    jr nz, jr_004_6cfe                            ; $6CF6

    set_state STATE_09_PHOTO_ARROWS               ; $6CF8
    ret                                           ; $6CFD


jr_004_6cfe:
    screen_off                                    ; $6CFE
    stat_irq_off                                  ; $6D04
    ld a, [wPhotoNumberSel]                       ; $6D0E
    ld [wPhotoIndex], a                           ; $6D11
    ld a, $01                                     ; $6D14
    ld [wAbResult], a                             ; $6D16
    ld a, $02                                     ; $6D19
    ld [wMsgStripSel], a                          ; $6D1B
    ld a, $00                                     ; $6D1E
    ld [wIconSel], a                              ; $6D20
    ld a, $01                                     ; $6D23
    ld [wCallerCode], a                           ; $6D25
    ld a, MODE_DELETE_PHOTO                       ; $6D28
    ld [wMode], a                                 ; $6D2A
    set_state STATE_0F_CONFIRM_INIT               ; $6D2D
    ret                                           ; $6D32


; C: B: back to mode 01
Mode09_State07_LeaveToShoot::
    screen_off                                    ; $6D33
    stat_irq_off                                  ; $6D39
    ld a, MODE_SHOOT_PARLOR                       ; $6D43
    ld [wMode], a                                 ; $6D45
    set_state STATE_01_INTRO                      ; $6D48
    ret                                           ; $6D4D


; C: loads the frame of the photo (02:4E31)
Mode09_State08_FrameInit::
    screen_off                                    ; $6D4E
    stat_irq_off                                  ; $6D54
    ld a, [wPhotoNumberSel]                       ; $6D5E
    ldh [hFarcallAArg], a                         ; $6D61
    farcall Photo_LoadBorder_Far                  ; $6D63
    xor a                                         ; $6D6B
    ld [wSubstate], a                             ; $6D6C
    next_state                                    ; $6D6F
    ret                                           ; $6D73


; C: far call 08:4DF2
Mode09_State09_FrameEdit::
    ldh [hFarcallAArg], a                         ; $6D74
    farcall BorderPicker_Far                      ; $6D76
    ret                                           ; $6D7E


; C: stores the frame (02:48F7) then restarts the viewer
Mode09_State0A_FrameSave::
    ld a, [wPhotoNumberSel]                       ; $6D7F
    ldh [hFarcallAArg], a                         ; $6D82
    farcall Photo_StoreBorder_Far                 ; $6D84
    jp Mode09_State00_Init                        ; $6D8C


; C: loads the tag fields of the photo (02:4E5F)
Mode09_State0B_CommentInit::
    screen_off                                    ; $6D8F
    stat_irq_off                                  ; $6D95
    ld a, [wPhotoNumberSel]                       ; $6D9F
    ld [wCmtPhotoIndex], a                        ; $6DA2
    ldh [hFarcallAArg], a                         ; $6DA5
    farcall Photo_LoadTagFields_Far               ; $6DA7
    xor a                                         ; $6DAF
    ld [wSubstate], a                             ; $6DB0
    next_state                                    ; $6DB3
    ret                                           ; $6DB7


; C: far call 09:4281
Mode09_State0C_CommentEdit::
    ldh [hFarcallAArg], a                         ; $6DB8
    ld a, $09                                     ; $6DBA
    ld hl, CommentEditor_Far                      ; $6DBC
    call Far_Call                                 ; $6DBF
    ret                                           ; $6DC2


; C: stores the comment (02:494B) then restarts the viewer
Mode09_State0D_CommentSave::
    ld a, [wPhotoNumberSel]                       ; $6DC3
    ldh [hFarcallAArg], a                         ; $6DC6
    farcall Photo_StoreTagFields_Far              ; $6DC8
    ld a, $01                                     ; $6DD0
    ld [wAbResult], a                             ; $6DD2
    jp Mode09_State00_Init                        ; $6DD5


; C: tilemap 27:4470 and the number tiles
Album_ShowPageScreen::
    call Oam_ClearShadow                          ; $6DD8
    ld a, $e4                                     ; $6DDB
    ldh [hBgpShadow], a                           ; $6DDD
    ldh [hObp0Shadow], a                          ; $6DDF
    ld a, $c6                                     ; $6DE1
    ldh [hObp1Shadow], a                          ; $6DE3
    farcopy Vram_CopyFromBank, Map_27_4470_Mode0D_State06_PlayInit, $9800, $02c0 ; $6DE5
    call Album_DrawPhotoNumber                    ; $6DF3
    farcopy Vram_CopyFromBank, Gfx_0C_7800_Mode09_State00_Init, $8900, $0300 ; $6DF6
    farcopy Vram_CopyFromBank, Gfx_0C_7B00_Mode09_State00_Init, $8500, $0300 ; $6E04
    farcopy Vram_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $6E12
    farcopy Vram_CopyFromBank, Gfx_0C_7FD0_Mode09_State00_Init, $8f70, $0030 ; $6E20
    farcopy Vram_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $6E2E
    ret                                           ; $6E3C


; C: same with other palettes. L3 pass 2026-10-26: executed in BGB in 41 replay(s) of the organic corpus, modes 09
; (tcrf_check/assets/l3_names/)
Album_ShowPageScreenB::
    call Oam_ClearShadow                          ; $6E3D
    ld a, $e4                                     ; $6E40
    ldh [hObp0Shadow], a                          ; $6E42
    ld a, $d2                                     ; $6E44
    ldh [hObp1Shadow], a                          ; $6E46
    farcopy Vram_CopyFromBank, Map_27_4470_Mode0D_State06_PlayInit, $9800, $02c0 ; $6E48
    farcopy Vram_CopyFromBank, Gfx_1A_7600_Album_ShowPageScreenB, $8900, $0700 ; $6E56
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $6E64
    farcopy Vram_CopyFromBank, Map_24_73E0_Album_ShowPageScreenB, $9800, $02c0 ; $6E72
    ret                                           ; $6E80


; C: slides the knob to the target photo (slider_pos -> slider_target)
Slider_Update::
    ld a, [wSliderTarget]                         ; $6E81
    ld hl, wSliderPos                             ; $6E84
    cp [hl]                                       ; $6E87
    jr z, jr_004_6ea9                             ; $6E88

    jr c, jr_004_6e90                             ; $6E8A

    ld a, $01                                     ; $6E8C
    jr jr_004_6e92                                ; $6E8E

jr_004_6e90:
    ld a, $ff                                     ; $6E90

jr_004_6e92:
    add [hl]                                      ; $6E92
    ld [hl], a                                    ; $6E93
    ld hl, wSliderTarget                          ; $6E94
    cp [hl]                                       ; $6E97
    jr nz, jr_004_6ed4                            ; $6E98

    srl a                                         ; $6E9A
    ld [wPhotoNumberSel], a                       ; $6E9C
    ld a, $01                                     ; $6E9F
    ld [wSliderRedraw], a                         ; $6EA1
    ld a, $40                                     ; $6EA4
    ld [wSliderTimer], a                          ; $6EA6

jr_004_6ea9:
    ld a, [wSliderTimer]                          ; $6EA9
    and a                                         ; $6EAC
    jr nz, jr_004_6ecb                            ; $6EAD

    ld a, [wPhotoNumberSel]                       ; $6EAF
    sla a                                         ; $6EB2
    sla a                                         ; $6EB4
    add $17                                       ; $6EB6
    ld b, a                                       ; $6EB8
    ld c, $86                                     ; $6EB9
    ldh a, [hFrameCounter]                        ; $6EBB
    srl a                                         ; $6EBD
    srl a                                         ; $6EBF
    srl a                                         ; $6EC1
    and $03                                       ; $6EC3
    add $09                                       ; $6EC5
    call Oam_AddMeta_B01_4000                     ; $6EC7
    ret                                           ; $6ECA


jr_004_6ecb:
    dec a                                         ; $6ECB
    ld [wSliderTimer], a                          ; $6ECC
    ld a, [wPhotoNumberSel]                       ; $6ECF
    sla a                                         ; $6ED2

jr_004_6ed4:
    cp $3a                                        ; $6ED4
    jr z, jr_004_6eeb                             ; $6ED6

    push af                                       ; $6ED8
    and $fc                                       ; $6ED9
    sla a                                         ; $6EDB
    add $10                                       ; $6EDD
    ld b, a                                       ; $6EDF
    ld c, $80                                     ; $6EE0
    pop af                                        ; $6EE2
    and $03                                       ; $6EE3
    add $04                                       ; $6EE5
    call Oam_AddMeta_B01_4000                     ; $6EE7
    ret                                           ; $6EEA


jr_004_6eeb:
    ld bc, $8080                                  ; $6EEB
    ld a, $08                                     ; $6EEE
    call Oam_AddMeta_B01_4000                     ; $6EF0
    ret                                           ; $6EF3


; C: metasprite $0D at (0. L3 pass 2026-10-26: executed in BGB in 42 replay(s) of the organic corpus, modes 09
; (tcrf_check/assets/l3_names/)
Slider_DrawBar::
    ld bc, $0800                                  ; $6EF4
    ld a, $0d                                     ; $6EF7
    call Oam_AddMeta_B01_4000                     ; $6EF9
    ret                                           ; $6EFC


; C: Left / Right (also held) changes the target photo with wrap
Slider_Input::
    ld a, [wSliderTarget]                         ; $6EFD
    ld hl, wSliderPos                             ; $6F00
    cp [hl]                                       ; $6F03
    ret nz                                        ; $6F04

    ldh a, [hKeysHeldSticky]                      ; $6F05
    bit PADB_A, a                                 ; $6F07
    jr nz, jr_004_6f0b                            ; $6F09

jr_004_6f0b:
    ld b, a                                       ; $6F0B
    ld a, [wPhotoNumberSel]                       ; $6F0C
    sla a                                         ; $6F0F
    bit 5, b                                      ; $6F11
    jr z, jr_004_6f26                             ; $6F13

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6F15
    dec a                                         ; $6F1C
    dec a                                         ; $6F1D
    bit 7, a                                      ; $6F1E
    jr z, jr_004_6f37                             ; $6F20

    ld a, $3a                                     ; $6F22
    jr jr_004_6f37                                ; $6F24

jr_004_6f26:
    bit 4, b                                      ; $6F26
    ret z                                         ; $6F28

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $6F29
    inc a                                         ; $6F30
    inc a                                         ; $6F31
    cp $3c                                        ; $6F32
    jr nz, jr_004_6f37                            ; $6F34

    xor a                                         ; $6F36

jr_004_6f37:
    ld [wSliderTarget], a                         ; $6F37
    ld a, [wPhotoNumberSel]                       ; $6F3A
    sla a                                         ; $6F3D
    ld [wSliderPos], a                            ; $6F3F
    ldh a, [hKeysHeld]                            ; $6F42
    bit PADB_A, a                                 ; $6F44
    ld a, [wSliderTarget]                         ; $6F46
    ld [wSliderPos], a                            ; $6F49
    srl a                                         ; $6F4C
    ld [wPhotoNumberSel], a                       ; $6F4E
    ld a, $01                                     ; $6F51
    ld [wSliderRedraw], a                         ; $6F53
    ld a, $40                                     ; $6F56
    ld [wSliderTimer], a                          ; $6F58
    ret                                           ; $6F5B


; C: photo number +1 as two decimal digits (stock pictures count from 1 again)
Album_DrawPhotoNumber::
    ld a, [wPhotoNumberSel]                       ; $6F5C
    inc a                                         ; $6F5F
    ld bc, $0000                                  ; $6F60
    cp $1f                                        ; $6F63
    jr c, jr_004_6f6a                             ; $6F65

    sub $1e                                       ; $6F67
    inc c                                         ; $6F69

jr_004_6f6a:
    cp $0a                                        ; $6F6A
    jr c, jr_004_6f73                             ; $6F6C

    sub $0a                                       ; $6F6E
    inc b                                         ; $6F70
    jr jr_004_6f6a                                ; $6F71

jr_004_6f73:
    push af                                       ; $6F73
    ld de, $8fa0                                  ; $6F74
    ld a, b                                       ; $6F77
    inc a                                         ; $6F78
    inc a                                         ; $6F79
    call Album_LoadNumeralTile                    ; $6F7A
    pop af                                        ; $6F7D
    inc a                                         ; $6F7E
    inc a                                         ; $6F7F

; C: loads one numeral tile (32 bytes) from bank 0C:7E00
Album_LoadNumeralTile::
    swap a                                        ; $6F80
    ld c, a                                       ; $6F82
    ld b, $00                                     ; $6F83
    sla c                                         ; $6F85
    rl b                                          ; $6F87
    ld hl, Gfx_0C_7E00_Album_LoadNumeralTile      ; $6F89
    add hl, bc                                    ; $6F8C
    ld a, BANK(Gfx_0C_7E00_Album_LoadNumeralTile) ; $6F8D
    ld bc, $0020                                  ; $6F8F
    call Vram_CopyFromBank                        ; $6F92
    ret                                           ; $6F95


; C: mode 01: SHOOT parlor (RPG battle window)
Mode01_ShootParlor::
    ld a, [wState]                                ; $6F96
    rst Rst18_JumpTable                           ; $6F99

; C: 12 states, rst $18 table of mode $01
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
    call Rng_Next                                 ; $6FB2
    and $03                                       ; $6FB5
    jr nz, jr_004_6fbf                            ; $6FB7

    set_state STATE_01_INTRO_PAGE_B               ; $6FB9
    ret                                           ; $6FBE


jr_004_6fbf:
    call Parlor_ScreenOn                          ; $6FBF
    play_music MUSIC_SHOOT_INTRO_A                ; $6FC2
    xor a                                         ; $6FC9
    ld [wMenuPageShadow], a                       ; $6FCA
    call Parlor_LoadPage                          ; $6FCD
    call Parlor_SpiralWipeIn                      ; $6FD0
    call Parlor_DrawPortraits                     ; $6FD3
    call Oam_HideUnused                           ; $6FD6
    rst Rst08_WaitVBlank                          ; $6FD9
    farcopy Vram_CopyFromBank, Map_24_6320_Mode01_State00_Intro, $9920, $0040 ; $6FDA
    call Parlor_DrawPortraits                     ; $6FE8
    next_state                                    ; $6FEB
    ret                                           ; $6FEF


; C: command menu, caption page A ("Welcome to my parlor!")
Mode01_State01_MenuPageA::
    ld de, wMode1CursorA                          ; $6FF0
    ld hl, Parlor_PageAB_NavTbl                   ; $6FF3
    call Parlor_MenuInput                         ; $6FF6
    ld hl, Parlor_PageA_CursorPosTbl              ; $6FF9
    ld a, $dc                                     ; $6FFC
    call Parlor_DrawCursor                        ; $6FFE
    call Parlor_Animate                           ; $7001
    ldh a, [hKeysNew]                             ; $7004
    and PADF_A | PADF_B                           ; $7006
    ret z                                         ; $7008

    ld [wAbResult], a                             ; $7009
    push af                                       ; $700C
    bit 0, a                                      ; $700D
    ld a, SFX1_MENU_CHOOSE                        ; $700F
    call nz, Snd_Sfx1                             ; $7011
    pop af                                        ; $7014
    push af                                       ; $7015
    bit 1, a                                      ; $7016
    ld a, SFX1_KEY_B                              ; $7018
    call nz, Snd_Sfx1                             ; $701A
    pop af                                        ; $701D
    next_state                                    ; $701E
    ret                                           ; $7022


; C: 5 x {y; x} of the cursor sprite $DC of parlor page A, indexed by wMode1CursorA: Parlor_DrawCursor (04:7279) loads
; C = y, B = x for Oam_AddMeta_B01_4000; items 0-2 (SHOOT / ITEMS / MAGIC) at x = $09, items 3-4 (CHECK / RUN) at x =
; $41 (read 2026-10-25)
Parlor_PageA_CursorPosTbl::
    db $66, $09, $72, $09, $7e, $09, $66, $41, $72, $41

; C: spiral wipe then the chosen mode
Mode01_State02_ApplyPageA::
    call Oam_ClearShadow                          ; $702D
    farcopy Vram_CopyFromBank, Map_24_61C0_Mode01_State02_ApplyPageA, $9920, $0040 ; $7030
    call Map_SpiralWipeOut                        ; $703E
    ld a, [wAbResult]                             ; $7041
    bit 0, a                                      ; $7044
    jr nz, jr_004_7059                            ; $7046

    screen_off                                    ; $7048
    ld a, MODE_MAIN_MENU                          ; $704E
    ld [wMode], a                                 ; $7050
    set_state STATE_00_INIT                       ; $7053
    ret                                           ; $7058


jr_004_7059:
    ld a, [wPhotoCount]                           ; $7059
    and a                                         ; $705C
    jr z, jr_004_7060                             ; $705D

    dec a                                         ; $705F

jr_004_7060:
    ld [wPhotoNumberSel], a                       ; $7060
    ld a, [wMode1CursorA]                         ; $7063
    sla a                                         ; $7066
    ld c, a                                       ; $7068
    ld b, $00                                     ; $7069
    ld hl, Parlor_PageA_TargetTbl                 ; $706B
    add hl, bc                                    ; $706E
    ld a, [hl+]                                   ; $706F
    ld [wMode], a                                 ; $7070
    ld a, [hl]                                    ; $7073
    ld [wState], a                                ; $7074
    ld a, [wMode]                                 ; $7077
    cp MODE_SHOOT_PARLOR                          ; $707A
    ret z                                         ; $707C

    screen_off                                    ; $707D
    ret                                           ; $7083


; C: 5 x {mode; state} of parlor page A (SHOOT / ITEMS / MAGIC / CHECK / RUN): $15:00, $01:06, $16:00, $09:00, $01:09;
; Mode01_State02_ApplyPageA (04:706B) writes them to wMode / wState when the choice is A (also in const_tables_jp.csv)
; (read 2026-10-25)
Parlor_PageA_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_RETURN_TO_SHOOT, MODE_SHOOT_PARLOR, STATE_01_INTRO_PAGE_C, MODE_SHUTTERBUG_MAGIC, STATE_16_INIT, MODE_ALBUM_EDIT, STATE_09_INIT, MODE_SHOOT_PARLOR, STATE_01_RUN_INIT

; C: music 7
Mode01_State03_IntroPageB::
    call Parlor_ScreenOn                          ; $708E
    play_music MUSIC_SHOOT_INTRO_B                ; $7091
    ld a, $01                                     ; $7098
    ld [wMenuPageShadow], a                       ; $709A
    call Parlor_LoadPage                          ; $709D
    call Parlor_SpiralWipeIn                      ; $70A0
    next_state                                    ; $70A3
    ret                                           ; $70A7


; C
Mode01_State04_MenuPageB::
    ld de, wMode1CursorA                          ; $70A8
    ld hl, Parlor_PageAB_NavTbl                   ; $70AB
    call Parlor_MenuInput                         ; $70AE
    ld hl, Parlor_PageB_CursorPosTbl              ; $70B1
    ld a, $df                                     ; $70B4
    call Parlor_DrawCursor                        ; $70B6
    call Parlor_AnimateB                          ; $70B9
    ldh a, [hKeysNew]                             ; $70BC
    and PADF_A | PADF_B                           ; $70BE
    ret z                                         ; $70C0

    ld [wAbResult], a                             ; $70C1
    push af                                       ; $70C4
    bit 0, a                                      ; $70C5
    ld a, SFX1_MENU_CHOOSE                        ; $70C7
    call nz, Snd_Sfx1                             ; $70C9
    pop af                                        ; $70CC
    push af                                       ; $70CD
    bit 1, a                                      ; $70CE
    ld a, SFX1_KEY_B                              ; $70D0
    call nz, Snd_Sfx1                             ; $70D2
    pop af                                        ; $70D5
    next_state                                    ; $70D6
    ret                                           ; $70DA


; C: 5 x {y; x} of the cursor sprite $DF of parlor page B (same bytes as Parlor_PageA_CursorPosTbl), read by
; Parlor_DrawCursor from Mode01_State04_MenuPageB (read 2026-10-25)
Parlor_PageB_CursorPosTbl::
    db $66, $09, $72, $09, $7e, $09, $66, $41, $72, $41

; C
Mode01_State05_ApplyPageB::
    call Map_SpiralWipeOut                        ; $70E5
    ld a, [wAbResult]                             ; $70E8
    bit 0, a                                      ; $70EB
    jr nz, jr_004_7100                            ; $70ED

    screen_off                                    ; $70EF
    ld a, MODE_MAIN_MENU                          ; $70F5
    ld [wMode], a                                 ; $70F7
    set_state STATE_00_INIT                       ; $70FA
    ret                                           ; $70FF


jr_004_7100:
    ld a, [wPhotoCount]                           ; $7100
    and a                                         ; $7103
    jr z, jr_004_7107                             ; $7104

    dec a                                         ; $7106

jr_004_7107:
    ld [wPhotoNumberSel], a                       ; $7107
    ld a, [wMode1CursorA]                         ; $710A
    sla a                                         ; $710D
    ld c, a                                       ; $710F
    ld b, $00                                     ; $7110
    ld hl, Parlor_PageB_TargetTbl                 ; $7112
    add hl, bc                                    ; $7115
    ld a, [hl+]                                   ; $7116
    ld [wMode], a                                 ; $7117
    ld a, [hl]                                    ; $711A
    ld [wState], a                                ; $711B
    ld a, [wMode]                                 ; $711E
    cp MODE_SHOOT_PARLOR                          ; $7121
    ret z                                         ; $7123

    screen_off                                    ; $7124
    ret                                           ; $712A


; C: 5 x {mode; state} of parlor page B, the same five targets as page A; Mode01_State05_ApplyPageB (04:7112) (read
; 2026-10-25)
Parlor_PageB_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_RETURN_TO_SHOOT, MODE_SHOOT_PARLOR, STATE_01_INTRO_PAGE_C, MODE_SHUTTERBUG_MAGIC, STATE_16_INIT, MODE_ALBUM_EDIT, STATE_09_INIT, MODE_SHOOT_PARLOR, STATE_01_RUN_INIT

; C: music $0E
Mode01_State06_IntroPageC::
    call Parlor_ScreenOn                          ; $7135
    play_music MUSIC_SHOOT_INTRO_C                ; $7138
    ld a, $02                                     ; $713F
    ld [wMenuPageShadow], a                       ; $7141
    call Parlor_LoadPage                          ; $7144
    call Parlor_SpiralWipeIn                      ; $7147
    next_state                                    ; $714A
    ret                                           ; $714E


; C: second cursor and table
Mode01_State07_MenuPageC::
    ld de, wMode1CursorB                          ; $714F
    ld hl, Parlor_PageC_NavTbl                    ; $7152
    call Parlor_MenuInput                         ; $7155
    ld hl, Parlor_PageC_CursorPosTbl              ; $7158
    ld a, $df                                     ; $715B
    call Parlor_DrawCursor                        ; $715D
    call Parlor_AnimateC                          ; $7160
    ldh a, [hKeysNew]                             ; $7163
    and PADF_A | PADF_B                           ; $7165
    ret z                                         ; $7167

    ld [wAbResult], a                             ; $7168
    push af                                       ; $716B
    bit 0, a                                      ; $716C
    ld a, SFX1_MENU_CHOOSE                        ; $716E
    call nz, Snd_Sfx1                             ; $7170
    pop af                                        ; $7173
    push af                                       ; $7174
    bit 1, a                                      ; $7175
    ld a, SFX1_KEY_B                              ; $7177
    call nz, Snd_Sfx1                             ; $7179
    pop af                                        ; $717C
    next_state                                    ; $717D
    ret                                           ; $7181


; C: 2 x {y; x} of the cursor sprite $DF of parlor page C (the ITEMS sub-menu, cursor $D5E1): y = $6A / $79, x = $09;
; read by Parlor_DrawCursor from Mode01_State07_MenuPageC (read 2026-10-25)
Parlor_PageC_CursorPosTbl::
    db $6a, $09, $79, $09

; C
Mode01_State08_ApplyPageC::
    call Map_SpiralWipeOut                        ; $7186
    ld a, [wAbResult]                             ; $7189
    bit 0, a                                      ; $718C
    jr nz, jr_004_7196                            ; $718E

    set_state STATE_01_INTRO                      ; $7190
    ret                                           ; $7195


jr_004_7196:
    screen_off                                    ; $7196
    ld a, [wMode1CursorB]                         ; $719C
    sla a                                         ; $719F
    ld c, a                                       ; $71A1
    ld b, $00                                     ; $71A2
    ld hl, Parlor_PageC_TargetTbl                 ; $71A4
    add hl, bc                                    ; $71A7
    ld a, [hl+]                                   ; $71A8
    ld [wMode], a                                 ; $71A9
    ld a, [hl]                                    ; $71AC
    ld [wState], a                                ; $71AD
    ret                                           ; $71B0


; C: 2 x {mode; state} of the ITEMS sub-menu: $15:01 (self-timer, Mode15_State01_TimerInit) and $15:05 (interval,
; Mode15_State05_IntervalInit); Mode01_State08_ApplyPageC (04:71A4) (read 2026-10-25)
Parlor_PageC_TargetTbl::
    db MODE_SELF_TIMER_INTERVAL, STATE_15_TIMER_INIT, MODE_SELF_TIMER_INTERVAL, STATE_15_INTERVAL_INIT

; C: RUN: picks the message 0E or, 30 % of the time, 04
Mode01_State09_RunInit::
    screen_off                                    ; $71B5
    ld a, $0e                                     ; $71BB
    ld [wResultMsgId], a                          ; $71BD
    call Rng_Next                                 ; $71C0
    cp $4c                                        ; $71C3
    jr nc, jr_004_71cc                            ; $71C5

    ld a, $04                                     ; $71C7
    ld [wResultMsgId], a                          ; $71C9

jr_004_71cc:
    xor a                                         ; $71CC
    ld [wSubstate], a                             ; $71CD
    next_state                                    ; $71D0
    ret                                           ; $71D4


; C: far call 09:7290 (result screen)
Mode01_State0A_RunResult::
    ldh [hFarcallAArg], a                         ; $71D5
    farcall ResultScreen_Far                      ; $71D7
    ret                                           ; $71DF


; C
Mode01_State0B_RunEnd::
    ld a, [wResultMsgId]                          ; $71E0
    cp $0e                                        ; $71E3
    jr nz, jr_004_71ed                            ; $71E5

    set_state STATE_01_INTRO                      ; $71E7
    ret                                           ; $71EC


jr_004_71ed:
    cp $04                                        ; $71ED
    jr nz, jr_004_7207                            ; $71EF

    call Rng_Next                                 ; $71F1
    cp $4c                                        ; $71F4
    jr nc, jr_004_7207                            ; $71F6

    ld a, $08                                     ; $71F8
    ld [wResultMsgId], a                          ; $71FA
    xor a                                         ; $71FD
    ld [wSubstate], a                             ; $71FE
    set_state STATE_01_RUN_RESULT                 ; $7201
    ret                                           ; $7206


jr_004_7207:
    set_state STATE_01_INTRO                      ; $7207
    ret                                           ; $720C


; C: Up / Down moves the cursor in a table of items
Parlor_MenuInput::
    push de                                       ; $720D
    ld a, [de]                                    ; $720E
    ld c, a                                       ; $720F
    ld b, $00                                     ; $7210
    add hl, bc                                    ; $7212
    ld c, [hl]                                    ; $7213
    add hl, bc                                    ; $7214
    ldh a, [hKeysNewRepeat]                       ; $7215
    ld b, a                                       ; $7217
    ld a, [hl+]                                   ; $7218

jr_004_7219:
    and b                                         ; $7219
    jr z, jr_004_721f                             ; $721A

    ld c, [hl]                                    ; $721C
    jr jr_004_7227                                ; $721D

jr_004_721f:
    inc hl                                        ; $721F
    ld a, [hl+]                                   ; $7220
    and a                                         ; $7221
    jr nz, jr_004_7219                            ; $7222

    pop hl                                        ; $7224
    ld c, [hl]                                    ; $7225
    ret                                           ; $7226


jr_004_7227:
    ld a, b                                       ; $7227
    push af                                       ; $7228
    bit 5, a                                      ; $7229
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $722B
    call nz, Snd_Sfx1                             ; $722D
    pop af                                        ; $7230
    push af                                       ; $7231
    bit 4, a                                      ; $7232
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7234
    call nz, Snd_Sfx1                             ; $7236
    pop af                                        ; $7239
    push af                                       ; $723A
    bit 6, a                                      ; $723B
    ld a, SFX1_KEY_UP_DOWN                        ; $723D
    call nz, Snd_Sfx1                             ; $723F
    pop af                                        ; $7242
    push af                                       ; $7243
    bit 7, a                                      ; $7244
    ld a, SFX1_KEY_UP_DOWN                        ; $7246
    call nz, Snd_Sfx1                             ; $7248
    pop af                                        ; $724B
    pop hl                                        ; $724C
    ld [hl], c                                    ; $724D
    ret                                           ; $724E


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
    sla c                                         ; $7279
    ld b, $00                                     ; $727B
    add hl, bc                                    ; $727D
    ld c, [hl]                                    ; $727E
    inc hl                                        ; $727F
    ld b, [hl]                                    ; $7280
    call Oam_AddMeta_B01_4000                     ; $7281
    ret                                           ; $7284


; C: animates the queen tiles and sprite
Parlor_Animate::
    call Parlor_AnimQueenTiles                    ; $7285
    call Parlor_AnimQueenSprite                   ; $7288
    ret                                           ; $728B


; C
Parlor_AnimQueenTiles::
    ld a, [wSpriteAnimFrame]                      ; $728C
    sla a                                         ; $728F
    sla a                                         ; $7291
    ld c, a                                       ; $7293
    ld b, $00                                     ; $7294
    ld hl, Parlor_AnimQueenTiles_Tbl72CA          ; $7296
    add hl, bc                                    ; $7299
    ld c, [hl]                                    ; $729A
    inc hl                                        ; $729B
    ld b, [hl]                                    ; $729C
    inc hl                                        ; $729D
    push hl                                       ; $729E
    ld l, c                                       ; $729F
    ld h, b                                       ; $72A0
    ld a, $24                                     ; $72A1
    ld de, $98a0                                  ; $72A3
    ld bc, $0040                                  ; $72A6
    call Vram_CopyFromBank                        ; $72A9
    pop hl                                        ; $72AC
    ld a, [wSpriteAnimTick]                       ; $72AD
    cp [hl]                                       ; $72B0
    jr nz, jr_004_72c5                            ; $72B1

    inc hl                                        ; $72B3
    inc hl                                        ; $72B4
    ld a, [hl]                                    ; $72B5
    inc a                                         ; $72B6
    jr z, jr_004_72bd                             ; $72B7

    ld a, [wSpriteAnimFrame]                      ; $72B9
    inc a                                         ; $72BC

jr_004_72bd:
    ld [wSpriteAnimFrame], a                      ; $72BD
    call Rng_Next                                 ; $72C0
    and $07                                       ; $72C3

jr_004_72c5:
    inc a                                         ; $72C5
    ld [wSpriteAnimTick], a                       ; $72C6
    ret                                           ; $72C9


; C: 4-byte records {src lo, src hi, duration, flag}: 24:6140 for $10 ticks, 24:62E0 for $0E, ... flag $FF wraps the
; frame index; the record is read by Parlor_AnimQueenTiles (04:728C) with the frame index $D500 x 4; 6 records + end
Parlor_AnimQueenTiles_Tbl72CA::
    dw Map_24_6140_Parlor_Page0_QueenFrameA
    db $10, $00, $e0, $62, $0e, $00
    dw Map_24_6140_Parlor_Page0_QueenFrameA
    db $0e, $00, $e0, $62, $0e, $00, $40, $61, $0e, $00, $e0, $62, $0e, $00, $ff

; C
Parlor_AnimQueenSprite::
    ld a, [wSpriteAnimFrame + $1]                 ; $72E3
    ld c, a                                       ; $72E6
    sla a                                         ; $72E7
    sla a                                         ; $72E9
    add c                                         ; $72EB
    ld c, a                                       ; $72EC
    ld b, $00                                     ; $72ED
    ld hl, Parlor_AnimQueenSprite_Tbl7321         ; $72EF
    add hl, bc                                    ; $72F2
    ld b, [hl]                                    ; $72F3
    inc hl                                        ; $72F4
    ld c, [hl]                                    ; $72F5
    inc hl                                        ; $72F6
    ld a, $dd                                     ; $72F7
    call Oam_AddMeta_B01_4000                     ; $72F9
    ld b, [hl]                                    ; $72FC
    inc hl                                        ; $72FD
    ld c, [hl]                                    ; $72FE
    inc hl                                        ; $72FF
    ld a, $de                                     ; $7300
    call Oam_AddMeta_B01_4000                     ; $7302
    ld a, [wSpriteAnimTick + $1]                  ; $7305
    cp [hl]                                       ; $7308
    jr c, jr_004_731c                             ; $7309

    inc hl                                        ; $730B
    ld a, [hl+]                                   ; $730C
    inc a                                         ; $730D
    jr z, jr_004_7314                             ; $730E

    ld a, [wSpriteAnimFrame + $1]                 ; $7310
    inc a                                         ; $7313

jr_004_7314:
    ld [wSpriteAnimFrame + $1], a                 ; $7314
    call Rng_Next                                 ; $7317
    and $07                                       ; $731A

jr_004_731c:
    inc a                                         ; $731C
    ld [wSpriteAnimTick + $1], a                  ; $731D
    ret                                           ; $7320


; C: auto: 31 bytes, bytes; referenced by Parlor_AnimQueenSprite. L3 pass 2026-10-26: read in BGB in 88 replay(s) of
; the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimQueenSprite_Tbl7321::
    db $31, $51, $62, $51, $12, $32, $51, $61, $51, $0c, $31, $51, $62, $51, $0a, $32
    db $51, $61, $51, $0c, $31, $51, $62, $51, $0a, $32, $51, $61, $51, $0e, $ff

; C: L3 pass 2026-10-26: executed in BGB in 24 replay(s) of the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateB::
    ld a, [wSpriteAnimTick]                       ; $7340
    inc a                                         ; $7343
    cp $14                                        ; $7344
    jr c, jr_004_736e                             ; $7346

    ld a, [wSpriteAnimFrame]                      ; $7348
    xor $01                                       ; $734B
    ld [wSpriteAnimFrame], a                      ; $734D
    sla a                                         ; $7350
    ld c, a                                       ; $7352
    ld b, $00                                     ; $7353
    ld hl, Parlor_AnimateB_PtrTbl7372             ; $7355
    add hl, bc                                    ; $7358
    ld c, [hl]                                    ; $7359
    inc hl                                        ; $735A
    ld b, [hl]                                    ; $735B
    ld l, c                                       ; $735C
    ld h, b                                       ; $735D
    ld a, $23                                     ; $735E
    ld de, $9800                                  ; $7360
    ld bc, $0160                                  ; $7363
    call Vram_CopyFromBank                        ; $7366
    call Rng_Next                                 ; $7369
    and $03                                       ; $736C

jr_004_736e:
    ld [wSpriteAnimTick], a                       ; $736E
    ret                                           ; $7371


; C: word table: the two 11-row map pieces 23:7040 and 23:7280 copied by Parlor_AnimateB (04:7340), index $D500 xor 1
; every $14 frames
Parlor_AnimateB_PtrTbl7372::
    dw Map_23_7040_Parlor_Page1
    dw Map_23_7280_Parlor_Page1_AltTopRows

; C: L3 pass 2026-10-26: executed in BGB in 27 replay(s) of the organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateC::
    ld a, [wSpriteAnimFrame]                      ; $7376
    sla a                                         ; $7379
    ld c, a                                       ; $737B
    ld b, $00                                     ; $737C
    ld hl, Parlor_AnimateC_Tbl73A2                ; $737E
    add hl, bc                                    ; $7381
    ld a, [hl+]                                   ; $7382
    ld bc, $1f12                                  ; $7383
    and a                                         ; $7386
    call nz, Oam_AddMeta_B01_4000                 ; $7387
    ld a, [wSpriteAnimTick]                       ; $738A
    cp [hl]                                       ; $738D
    jr c, jr_004_739d                             ; $738E

    inc hl                                        ; $7390
    ld a, [hl]                                    ; $7391
    inc a                                         ; $7392
    jr z, jr_004_7399                             ; $7393

    ld a, [wSpriteAnimFrame]                      ; $7395
    inc a                                         ; $7398

jr_004_7399:
    ld [wSpriteAnimFrame], a                      ; $7399
    xor a                                         ; $739C

jr_004_739d:
    inc a                                         ; $739D
    ld [wSpriteAnimTick], a                       ; $739E
    ret                                           ; $73A1


; C: auto: 9 bytes, bytes; referenced by Parlor_AnimateC. L3 pass 2026-10-26: read in BGB in 27 replay(s) of the
; organic corpus, modes 01 (tcrf_check/assets/l3_names/)
Parlor_AnimateC_Tbl73A2::
    db $e0, $04, $e1, $04, $e2, $04, $00, $08, $ff

; C: metasprites $DD / $DE. L3 pass 2026-10-26: executed in BGB in 88 replay(s) of the organic corpus, modes 01
; (tcrf_check/assets/l3_names/)
Parlor_DrawPortraits::
    ld bc, $3151                                  ; $73AB
    ld a, $dd                                     ; $73AE
    call Oam_AddMeta_B01_4000                     ; $73B0
    ld bc, $6251                                  ; $73B3
    ld a, $de                                     ; $73B6
    call Oam_AddMeta_B01_4000                     ; $73B8
    ret                                           ; $73BB


; C: clears OAM and fades the screen in once; sets lcdc and palettes
Parlor_ScreenOn::
    call Oam_ClearShadow                          ; $73BC
    ldh a, [hLcdcShadow]                          ; $73BF
    bit 7, a                                      ; $73C1
    jr nz, jr_004_73d3                            ; $73C3

    ld a, $ff                                     ; $73C5
    ld [wPaletteTarget], a                        ; $73C7
    call Pal_AllWhite                             ; $73CA
    call Lcd_On                                   ; $73CD
    call Pal_FadeIn                               ; $73D0

jr_004_73d3:
    rst Rst08_WaitVBlank                          ; $73D3
    ld a, LCDCF_ON | LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $73D4
    ldh [hLcdcShadow], a                          ; $73D6
    ld a, $e4                                     ; $73D8
    ld [wPaletteTarget], a                        ; $73DA
    ld a, $ff                                     ; $73DD
    ldh [hBgpShadow], a                           ; $73DF
    ld a, $e4                                     ; $73E1
    ldh [hObp0Shadow], a                          ; $73E3
    ld a, $c6                                     ; $73E5
    ldh [hObp1Shadow], a                          ; $73E7
    xor a                                         ; $73E9
    ldh [hScxShadow], a                           ; $73EA
    ldh [hScyShadow], a                           ; $73EC
    ret                                           ; $73EE


; C: graphics and map of page A in the table at 7436 (A = page)
Parlor_LoadPage::
    sla a                                         ; $73EF
    ld c, a                                       ; $73F1
    ld b, $00                                     ; $73F2
    ld hl, Parlor_PageTbl                         ; $73F4
    add hl, bc                                    ; $73F7
    ld a, [hl+]                                   ; $73F8
    ld h, [hl]                                    ; $73F9
    ld l, a                                       ; $73FA

jr_004_73fb:
    ld a, [hl+]                                   ; $73FB
    cp $ff                                        ; $73FC
    jr z, jr_004_7419                             ; $73FE

    push hl                                       ; $7400
    ld c, a                                       ; $7401
    ld b, [hl]                                    ; $7402
    inc hl                                        ; $7403
    push bc                                       ; $7404
    ld a, [hl+]                                   ; $7405
    ld e, [hl]                                    ; $7406
    inc hl                                        ; $7407
    ld d, [hl]                                    ; $7408
    inc hl                                        ; $7409
    ld c, [hl]                                    ; $740A
    inc hl                                        ; $740B
    ld b, [hl]                                    ; $740C
    inc hl                                        ; $740D
    pop hl                                        ; $740E
    call Vram_CopyFromBank                        ; $740F
    pop hl                                        ; $7412
    ld bc, $0006                                  ; $7413
    add hl, bc                                    ; $7416
    jr jr_004_73fb                                ; $7417

jr_004_7419:
    ld a, [hl+]                                   ; $7419
    ld [wMenuMapPtr], a                           ; $741A
    ld a, [hl+]                                   ; $741D
    ld [wMenuMapPtr + $1], a                      ; $741E
    ld a, [hl]                                    ; $7421
    ld [wMenuMapPtr + $2], a                      ; $7422
    xor a                                         ; $7425
    ld [wSpriteAnimFrame], a                      ; $7426
    ld [wSpriteAnimTick], a                       ; $7429
    ld [wSpriteAnimFrame + $1], a                 ; $742C
    ld [wSpriteAnimTick + $1], a                  ; $742F
    ld [wSpriteAnimFrame], a                      ; $7432
    ret                                           ; $7435


; C: 3 pointers to lists of 7-byte records {src lo, src hi, bank, dst lo, dst hi, len lo, len hi} ended by $FF; the
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
    dwb Map_26_7BC0_Parlor_Page2

; C: spiral wipe in of the map saved in menu_map_ptr
Parlor_SpiralWipeIn::
    ld a, [wMenuMapPtr]                           ; $7479
    ld l, a                                       ; $747C
    ld a, [wMenuMapPtr + $1]                      ; $747D
    ld h, a                                       ; $7480
    ld a, [wMenuMapPtr + $2]                      ; $7481
    call Map_SpiralWipeIn                         ; $7484
    ret                                           ; $7487


; C: mode 0A: VIEW album: pick a photo then browse with a slider and edit pages
Mode0A_AlbumView::
    ld a, [wState]                                ; $7488
    rst Rst18_JumpTable                           ; $748B

; C: 16 states, rst $18 table of mode $0A
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
    ld a, $01                                     ; $74AC
    ld [wMsgStripSel], a                          ; $74AE
    ld a, $02                                     ; $74B1
    ld [wIconSel], a                              ; $74B3
    xor a                                         ; $74B6
    ld [wSubstate], a                             ; $74B7
    ld a, $01                                     ; $74BA
    ld [wStockNavAllowed], a                      ; $74BC
    next_state                                    ; $74BF
    ret                                           ; $74C3


; C: far call to the photo grid picker
Mode0A_State01_PickPhoto::
    ldh [hFarcallAArg], a                         ; $74C4
    ld a, $04                                     ; $74C6
    ld hl, PhotoPicker_Far                        ; $74C8
    call Far_Call                                 ; $74CB
    ret                                           ; $74CE


; C
Mode0A_State02_Setup::
    ld a, [wAbResult]                             ; $74CF
    bit 0, a                                      ; $74D2
    jr nz, jr_004_74e1                            ; $74D4

    ld a, MODE_VIEW_MENU                          ; $74D6
    ld [wMode], a                                 ; $74D8
    set_state STATE_02_INIT                       ; $74DB
    ret                                           ; $74E0


jr_004_74e1:
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $74E1
    ldh [hLcdcShadow], a                          ; $74E3
    ld a, $e4                                     ; $74E5
    ld [wPaletteTarget], a                        ; $74E7
    ld [wPaletteTarget + $1], a                   ; $74EA
    ld a, $d2                                     ; $74ED
    ld [wPaletteTarget + $2], a                   ; $74EF
    ld a, $10                                     ; $74F2
    ldh [hScxShadow], a                           ; $74F4
    ldh [hScyShadow], a                           ; $74F6
    xor a                                         ; $74F8
    ld [wChoiceCursorA], a                        ; $74F9
    ld [wChoiceCursorB], a                        ; $74FC
    ld [wSliderRedraw], a                         ; $74FF
    ld a, $b4                                     ; $7502
    ld [wSliderTimer], a                          ; $7504
    farcopy Mem_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $7507
    farcopy Mem_CopyFromBank, Gfx_0C_79A0_Mode0A_State02_Setup, $8f70, $0010 ; $7515
    farcopy Mem_CopyFromBank, Map_24_7C20_Mode12_State11_TestStart, $9800, $02c0 ; $7523
    ld hl, $9ac0                                  ; $7531
    ld bc, $0140                                  ; $7534
    ld a, $ff                                     ; $7537
    call Mem_FillBc1                              ; $7539
    ld a, [wPhotoIndex]                           ; $753C
    ld [wCopyPhotoIdxA], a                        ; $753F
    ldh [hFarcallAArg], a                         ; $7542
    farcall Photo_LoadToVram_Far                  ; $7544
    ld a, [wCopyPhotoIdxA]                        ; $754C
    ldh [hFarcallAArg], a                         ; $754F
    farcall Photo_LoadBorder_Far                  ; $7551
    ldh [hFarcallAArg], a                         ; $7559
    farcall Border_LoadMap_LcdOff                 ; $755B
    ld a, $54                                     ; $7563
    ldh [hLycShadowSplit1], a                     ; $7565
    ldh [hSplit1Latch], a                         ; $7567
    ld hl, hStatShadow                            ; $7569
    set 6, [hl]                                   ; $756C
    ld hl, rIE                                    ; $756E
    set 1, [hl]                                   ; $7571
    ld a, $01                                     ; $7573
    ldh [hStatHandlerIndex], a                    ; $7575
    screen_on                                     ; $7577
    play_music MUSIC_ALBUM_VIEWER                 ; $7580
    call Album_DrawSliderNumber                   ; $7587
    call Pal_FadeIn                               ; $758A
    set_state STATE_0A_SLIDER_BROWSE              ; $758D
    ret                                           ; $7592


; C
Mode0A_State03_SliderBrowse::
    call Slider_DrawTimerSpark                    ; $7593
    ld a, [wSliderRedraw]                         ; $7596
    and a                                         ; $7599
    jr z, jr_004_75e8                             ; $759A

    call Oam_HideUnused                           ; $759C
    ld a, [wCopyPhotoIdxA]                        ; $759F
    ldh [hFarcallAArg], a                         ; $75A2
    farcall Photo_LoadToVram_Far                  ; $75A4
    ld a, [wBorderNumber]                         ; $75AC
    ld c, a                                       ; $75AF
    push bc                                       ; $75B0
    ld a, [wCopyPhotoIdxA]                        ; $75B1
    ldh [hFarcallAArg], a                         ; $75B4
    farcall Photo_LoadBorder_Far                  ; $75B6
    pop bc                                        ; $75BE
    ld a, [wBorderNumber]                         ; $75BF
    cp c                                          ; $75C2
    jr z, jr_004_75dd                             ; $75C3

    farcopy Vram_CopyFromBank, Map_27_4470_Mode0D_State06_PlayInit, $9800, $02c0 ; $75C5
    ldh [hFarcallAArg], a                         ; $75D3
    farcall Border_LoadMap_Safe                   ; $75D5

jr_004_75dd:
    call Album_DrawSliderNumber                   ; $75DD
    rst Rst08_WaitVBlank                          ; $75E0
    call Slider_DrawTimerSpark                    ; $75E1
    xor a                                         ; $75E4
    ld [wSliderRedraw], a                         ; $75E5

jr_004_75e8:
    ldh a, [hKeysNewSticky]                       ; $75E8
    and PADF_A | PADF_SELECT                      ; $75EA
    jr z, jr_004_7605                             ; $75EC

    play_sfx1 SFX1_KEY_SELECT                     ; $75EE
    ld a, [wCopyPhotoIdxA]                        ; $75F5
    ld hl, wPhotoCount                            ; $75F8
    cp [hl]                                       ; $75FB
    ret nc                                        ; $75FC

    call Album_LoadBorderScreen                   ; $75FD
    next_state                                    ; $7600
    ret                                           ; $7604


jr_004_7605:
    ldh a, [hKeysNewSticky]                       ; $7605
    bit PADB_B, a                                 ; $7607
    ret z                                         ; $7609

    play_sfx1 SFX1_KEY_B                          ; $760A
    set_state STATE_0A_LEAVE                      ; $7611
    ret                                           ; $7616


; C
Mode0A_State04_PhotoArrows::
    ld a, [wBlinkCounter]                         ; $7617
    inc a                                         ; $761A
    ld [wBlinkCounter], a                         ; $761B
    bit 4, a                                      ; $761E
    jr z, jr_004_7642                             ; $7620

    ld a, $a3                                     ; $7622
    ld bc, $5078                                  ; $7624
    call Oam_AddMeta_B01_4000                     ; $7627
    ld a, $a2                                     ; $762A
    ld bc, $5018                                  ; $762C
    call Oam_AddMeta_B01_4000                     ; $762F
    ld a, $a5                                     ; $7632
    ld bc, $1848                                  ; $7634
    call Oam_AddMeta_B01_4000                     ; $7637
    ld a, $a4                                     ; $763A
    ld bc, $8848                                  ; $763C
    call Oam_AddMeta_B01_4000                     ; $763F

jr_004_7642:
    ldh a, [hKeysNew]                             ; $7642
    and PADF_B | PADF_SELECT                      ; $7644
    jr z, jr_004_7657                             ; $7646

    play_sfx1 SFX1_KEY_B                          ; $7648
    call Album_LoadSliderScreen                   ; $764F
    ld hl, wState                                 ; $7652
    dec [hl]                                      ; $7655
    ret                                           ; $7656


jr_004_7657:
    ldh a, [hKeysNewRepeat]                       ; $7657
    and PADF_DPAD                                 ; $7659
    ret z                                         ; $765B

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $765C
    xor a                                         ; $7663
    ld [wArrowAnimTick], a                        ; $7664
    ld [wArrowAnimFrame], a                       ; $7667
    ldh a, [hKeysNewRepeat]                       ; $766A
    bit PADB_LEFT, a                              ; $766C
    jr z, jr_004_76a8                             ; $766E

    call Oam_ClearShadow                          ; $7670
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $7673
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $7681
    ld hl, Slide_ScyDeltaTbl                      ; $768F
    ld b, $10                                     ; $7692

jr_004_7694:
    push bc                                       ; $7694
    push hl                                       ; $7695
    ldh a, [hScxShadow]                           ; $7696
    add [hl]                                      ; $7698
    ldh [hScxShadow], a                           ; $7699
    rst Rst08_WaitVBlank                          ; $769B
    pop hl                                        ; $769C
    pop bc                                        ; $769D
    inc hl                                        ; $769E
    dec b                                         ; $769F
    jr nz, jr_004_7694                            ; $76A0

    set_state STATE_0A_PAGE_LEFT                  ; $76A2
    ret                                           ; $76A7


jr_004_76a8:
    bit 4, a                                      ; $76A8
    jr z, jr_004_76e4                             ; $76AA

    call Oam_ClearShadow                          ; $76AC
    farcopy Vram_CopyFromBank, Gfx_1C_5BE0_Mode09_State02_PhotoArrows, $8680, $0040 ; $76AF
    farcopy Vram_CopyFromBank, Gfx_1C_5CE0_Mode09_State02_PhotoArrows, $8780, $0040 ; $76BD
    ld hl, Slide_ScyDeltaTbl                      ; $76CB
    ld b, $10                                     ; $76CE

jr_004_76d0:
    push bc                                       ; $76D0
    push hl                                       ; $76D1
    ldh a, [hScxShadow]                           ; $76D2
    sub [hl]                                      ; $76D4
    ldh [hScxShadow], a                           ; $76D5
    rst Rst08_WaitVBlank                          ; $76D7
    pop hl                                        ; $76D8
    pop bc                                        ; $76D9
    inc hl                                        ; $76DA
    dec b                                         ; $76DB
    jr nz, jr_004_76d0                            ; $76DC

    set_state STATE_0A_PAGE_RIGHT                 ; $76DE
    ret                                           ; $76E3


jr_004_76e4:
    bit 6, a                                      ; $76E4
    jr z, jr_004_7725                             ; $76E6

    call Oam_ClearShadow                          ; $76E8
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $76EB
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $76F9
    ld hl, Slide_ScyDeltaTbl                      ; $7707
    ld b, $10                                     ; $770A

jr_004_770c:
    push bc                                       ; $770C
    push hl                                       ; $770D
    ldh a, [hScyShadow]                           ; $770E
    add [hl]                                      ; $7710
    ldh [hScyShadow], a                           ; $7711
    cpl                                           ; $7713
    add $64                                       ; $7714
    ldh [hLycShadowSplit1], a                     ; $7716
    rst Rst08_WaitVBlank                          ; $7718
    pop hl                                        ; $7719
    pop bc                                        ; $771A
    inc hl                                        ; $771B
    dec b                                         ; $771C
    jr nz, jr_004_770c                            ; $771D

    set_state STATE_0A_PAGE_UP                    ; $771F
    ret                                           ; $7724


jr_004_7725:
    bit 7, a                                      ; $7725
    ret z                                         ; $7727

    call Oam_ClearShadow                          ; $7728
    farcopy Vram_CopyFromBank, Gfx_1C_5B80_Mode09_State02_PhotoArrows, $8680, $0040 ; $772B
    farcopy Vram_CopyFromBank, Gfx_1C_5C80_Mode09_State02_PhotoArrows, $8780, $0040 ; $7739
    ld hl, Slide_ScyDeltaTbl                      ; $7747
    ld b, $10                                     ; $774A

jr_004_774c:
    push bc                                       ; $774C
    push hl                                       ; $774D
    ldh a, [hScyShadow]                           ; $774E
    sub [hl]                                      ; $7750
    ldh [hScyShadow], a                           ; $7751
    cpl                                           ; $7753
    add $64                                       ; $7754
    ldh [hLycShadowSplit1], a                     ; $7756
    rst Rst08_WaitVBlank                          ; $7758
    pop hl                                        ; $7759
    pop bc                                        ; $775A
    inc hl                                        ; $775B
    dec b                                         ; $775C
    jr nz, jr_004_774c                            ; $775D

    set_state STATE_0A_PAGE_DOWN                  ; $775F
    ret                                           ; $7764


; C
Mode0A_State05_PageLeft::
    call AlbumPage_ReadChoiceA                    ; $7765
    call AlbumPage_DrawChoiceA                    ; $7768
    ldh a, [hKeysNew]                             ; $776B
    and PADF_A | PADF_B | PADF_RIGHT              ; $776D
    ret z                                         ; $776F

    push af                                       ; $7770
    bit 0, a                                      ; $7771
    ld a, SFX1_PAGE_STEP                          ; $7773
    call nz, Snd_Sfx1                             ; $7775
    pop af                                        ; $7778
    push af                                       ; $7779
    bit 1, a                                      ; $777A
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $777C
    call nz, Snd_Sfx1                             ; $777E
    pop af                                        ; $7781
    push af                                       ; $7782
    bit 4, a                                      ; $7783
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7785
    call nz, Snd_Sfx1                             ; $7787
    pop af                                        ; $778A
    push af                                       ; $778B
    bit 0, a                                      ; $778C
    jp z, Mode0A_State05_PageLeft_SlideOut        ; $778E

    ld hl, wArrowAnimFrame                        ; $7791
    inc [hl]                                      ; $7794
    call Oam_HideUnused                           ; $7795
    rst Rst08_WaitVBlank                          ; $7798
    ld hl, $9880                                  ; $7799
    ld a, [wChoiceCursorA]                        ; $779C
    and a                                         ; $779F
    jr z, jr_004_77a5                             ; $77A0

    ld hl, $9980                                  ; $77A2

jr_004_77a5:
    call Album_DrawChoiceMarker                   ; $77A5

jr_004_77a8:
    call AlbumPage_DrawChoiceA                    ; $77A8
    call Oam_HideUnused                           ; $77AB
    rst Rst08_WaitVBlank                          ; $77AE
    ld a, [wArrowAnimFrame]                       ; $77AF
    cp $02                                        ; $77B2
    jr nz, jr_004_77a8                            ; $77B4

; C: same tail as Mode09_State03_PageLeft_SlideOut in mode $0A (shares the table Tbl2FB5) (branch target; code read
; 2026-10-19)
Mode0A_State05_PageLeft_SlideOut::
    call Oam_ClearShadow                          ; $77B6
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $77B9
    ld b, $10                                     ; $77BC

jr_004_77be:
    push bc                                       ; $77BE
    push hl                                       ; $77BF
    ldh a, [hScxShadow]                           ; $77C0
    sub [hl]                                      ; $77C2
    ldh [hScxShadow], a                           ; $77C3
    rst Rst08_WaitVBlank                          ; $77C5
    pop hl                                        ; $77C6
    pop bc                                        ; $77C7
    inc hl                                        ; $77C8
    dec b                                         ; $77C9
    jr nz, jr_004_77be                            ; $77CA

    pop af                                        ; $77CC
    bit 0, a                                      ; $77CD
    jr nz, jr_004_77d7                            ; $77CF

    set_state STATE_0A_PHOTO_ARROWS               ; $77D1
    ret                                           ; $77D6


jr_004_77d7:
    screen_off                                    ; $77D7
    stat_irq_off                                  ; $77DD
    ld a, [wCopyPhotoIdxA]                        ; $77E7
    ld [wPhotoIndex], a                           ; $77EA
    ld a, $01                                     ; $77ED
    ld [wAbResult], a                             ; $77EF
    ld a, $02                                     ; $77F2
    ld [wCallerCode], a                           ; $77F4
    xor a                                         ; $77F7
    ld [wDoodleFromShutterbug], a                 ; $77F8
    ld a, [wChoiceCursorA]                        ; $77FB
    and a                                         ; $77FE
    jr nz, jr_004_780c                            ; $77FF

    ld a, MODE_PAINT                              ; $7801
    ld [wMode], a                                 ; $7803
    set_state STATE_10_SETUP                      ; $7806
    ret                                           ; $780B


jr_004_780c:
    ld a, MODE_STAMP                              ; $780C
    ld [wMode], a                                 ; $780E
    set_state STATE_11_SETUP                      ; $7811
    ret                                           ; $7816


; C: Up / Down toggles choice_cursor_a with a blip
AlbumPage_ReadChoiceA::
    ldh a, [hKeysNew]                             ; $7817
    bit PADB_UP, a                                ; $7819
    jr z, jr_004_7820                             ; $781B

    xor a                                         ; $781D
    jr jr_004_7825                                ; $781E

jr_004_7820:
    bit 7, a                                      ; $7820
    ret z                                         ; $7822

    ld a, $01                                     ; $7823

jr_004_7825:
    ld hl, wChoiceCursorA                         ; $7825
    cp [hl]                                       ; $7828
    ld [hl], a                                    ; $7829
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $782A
    ret                                           ; $7831


; C: arrow sprite at the choice A position
AlbumPage_DrawChoiceA::
    ld a, [wChoiceCursorA]                        ; $7832
    sla a                                         ; $7835
    ld c, a                                       ; $7837
    ld b, $00                                     ; $7838
    ld hl, AlbumPage_ChoiceAPosTbl                ; $783A
    add hl, bc                                    ; $783D
    ld c, [hl]                                    ; $783E
    inc hl                                        ; $783F
    ld b, [hl]                                    ; $7840
    ld a, [wArrowAnimFrame]                       ; $7841
    cp $02                                        ; $7844
    ret z                                         ; $7846

    ld a, [wArrowAnimFrame]                       ; $7847
    sla a                                         ; $784A
    ld e, a                                       ; $784C
    ld d, $00                                     ; $784D
    ld hl, AlbumPage_ArrowAnimTbl                 ; $784F
    add hl, de                                    ; $7852
    ld a, [hl+]                                   ; $7853
    call Oam_AddMeta_B01_4000                     ; $7854
    ld a, [wArrowAnimTick]                        ; $7857
    cp [hl]                                       ; $785A
    jr nz, jr_004_7865                            ; $785B

    ld hl, wArrowAnimFrame                        ; $785D
    inc [hl]                                      ; $7860
    xor a                                         ; $7861
    ld [wArrowAnimTick], a                        ; $7862

jr_004_7865:
    ld a, [wArrowAnimFrame]                       ; $7865
    and a                                         ; $7868
    ret z                                         ; $7869

    ld hl, wArrowAnimTick                         ; $786A
    inc [hl]                                      ; $786D
    ret                                           ; $786E


; C: L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_ChoiceAPosTbl::
    db $17, $10, $57, $10

; C: L3 pass 2026-10-26: read in BGB in 9 replay(s) of the organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_ArrowAnimTbl::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode0A_State06_PageRight::
    call AlbumPage_ReadChoiceB                    ; $7879
    call AlbumPage_DrawChoiceB                    ; $787C
    ldh a, [hKeysNew]                             ; $787F
    and PADF_A | PADF_B | PADF_LEFT               ; $7881
    ret z                                         ; $7883

    push af                                       ; $7884
    bit 0, a                                      ; $7885
    ld a, SFX1_PAGE_STEP                          ; $7887
    call nz, Snd_Sfx1                             ; $7889
    pop af                                        ; $788C
    push af                                       ; $788D
    bit 1, a                                      ; $788E
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7890
    call nz, Snd_Sfx1                             ; $7892
    pop af                                        ; $7895
    push af                                       ; $7896
    bit 5, a                                      ; $7897
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7899
    call nz, Snd_Sfx1                             ; $789B
    pop af                                        ; $789E
    push af                                       ; $789F
    bit 0, a                                      ; $78A0
    jr z, jr_004_78c9                             ; $78A2

    ld hl, wArrowAnimFrame                        ; $78A4
    inc [hl]                                      ; $78A7
    call Oam_HideUnused                           ; $78A8
    rst Rst08_WaitVBlank                          ; $78AB
    ld hl, $9896                                  ; $78AC
    ld a, [wChoiceCursorB]                        ; $78AF
    and a                                         ; $78B2
    jr z, jr_004_78b8                             ; $78B3

    ld hl, $9996                                  ; $78B5

jr_004_78b8:
    call Album_DrawChoiceMarker                   ; $78B8

jr_004_78bb:
    call AlbumPage_DrawChoiceB                    ; $78BB
    call Oam_HideUnused                           ; $78BE
    rst Rst08_WaitVBlank                          ; $78C1
    ld a, [wArrowAnimFrame]                       ; $78C2
    cp $02                                        ; $78C5
    jr nz, jr_004_78bb                            ; $78C7

jr_004_78c9:
    call Oam_ClearShadow                          ; $78C9
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $78CC
    ld b, $10                                     ; $78CF

jr_004_78d1:
    push bc                                       ; $78D1
    push hl                                       ; $78D2
    ldh a, [hScxShadow]                           ; $78D3
    add [hl]                                      ; $78D5
    ldh [hScxShadow], a                           ; $78D6
    rst Rst08_WaitVBlank                          ; $78D8
    pop hl                                        ; $78D9
    pop bc                                        ; $78DA
    inc hl                                        ; $78DB
    dec b                                         ; $78DC
    jr nz, jr_004_78d1                            ; $78DD

    pop af                                        ; $78DF
    bit 0, a                                      ; $78E0
    jr nz, jr_004_78ea                            ; $78E2

    set_state STATE_0A_PHOTO_ARROWS               ; $78E4
    ret                                           ; $78E9


jr_004_78ea:
    ld a, [wChoiceCursorB]                        ; $78EA
    and a                                         ; $78ED
    jr nz, jr_004_78f6                            ; $78EE

    set_state STATE_0A_FRAME_INIT                 ; $78F0
    ret                                           ; $78F5


jr_004_78f6:
    set_state STATE_0A_COMMENT_INIT               ; $78F6
    ret                                           ; $78FB


; C
AlbumPage_ReadChoiceB::
    ldh a, [hKeysNew]                             ; $78FC
    bit PADB_UP, a                                ; $78FE
    jr z, jr_004_7905                             ; $7900

    xor a                                         ; $7902
    jr jr_004_790a                                ; $7903

jr_004_7905:
    bit 7, a                                      ; $7905
    ret z                                         ; $7907

    ld a, $01                                     ; $7908

jr_004_790a:
    ld hl, wChoiceCursorB                         ; $790A
    cp [hl]                                       ; $790D
    ld [hl], a                                    ; $790E
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $790F
    ret                                           ; $7916


; C
AlbumPage_DrawChoiceB::
    ld a, [wChoiceCursorB]                        ; $7917
    sla a                                         ; $791A
    ld c, a                                       ; $791C
    ld b, $00                                     ; $791D
    ld hl, AlbumPage_DrawChoiceB_Tbl7954          ; $791F
    add hl, bc                                    ; $7922
    ld c, [hl]                                    ; $7923
    inc hl                                        ; $7924
    ld b, [hl]                                    ; $7925
    ld a, [wArrowAnimFrame]                       ; $7926
    cp $02                                        ; $7929
    ret z                                         ; $792B

    ld a, [wArrowAnimFrame]                       ; $792C
    sla a                                         ; $792F
    ld e, a                                       ; $7931
    ld d, $00                                     ; $7932
    ld hl, AlbumPage_DrawChoiceB_Tbl7958          ; $7934
    add hl, de                                    ; $7937
    ld a, [hl+]                                   ; $7938
    call Oam_AddMeta_B01_4000                     ; $7939
    ld a, [wArrowAnimTick]                        ; $793C
    cp [hl]                                       ; $793F
    jr nz, jr_004_794a                            ; $7940

    ld hl, wArrowAnimFrame                        ; $7942
    inc [hl]                                      ; $7945
    xor a                                         ; $7946
    ld [wArrowAnimTick], a                        ; $7947

jr_004_794a:
    ld a, [wArrowAnimFrame]                       ; $794A
    and a                                         ; $794D
    ret z                                         ; $794E

    ld hl, wArrowAnimTick                         ; $794F
    inc [hl]                                      ; $7952
    ret                                           ; $7953


; C: auto: 4 bytes, bytes; referenced by AlbumPage_DrawChoiceB. L3 pass 2026-10-26: read in BGB in 43 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawChoiceB_Tbl7954::
    db $19, $90, $59, $90

; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawChoiceB. L3 pass 2026-10-26: read in BGB in 43 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawChoiceB_Tbl7958::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode0A_State07_PageUp::
    call AlbumPage_DrawUp                         ; $795E
    ldh a, [hKeysNew]                             ; $7961
    and PADF_A | PADF_B | PADF_DOWN               ; $7963
    ret z                                         ; $7965

    push af                                       ; $7966
    bit 0, a                                      ; $7967
    ld a, SFX1_PAGE_STEP                          ; $7969
    call nz, Snd_Sfx1                             ; $796B
    pop af                                        ; $796E
    push af                                       ; $796F
    bit 1, a                                      ; $7970
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7972
    call nz, Snd_Sfx1                             ; $7974
    pop af                                        ; $7977
    push af                                       ; $7978
    bit 7, a                                      ; $7979
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $797B
    call nz, Snd_Sfx1                             ; $797D
    pop af                                        ; $7980
    push af                                       ; $7981
    bit 0, a                                      ; $7982
    jr z, jr_004_79a2                             ; $7984

    ld hl, wArrowAnimFrame                        ; $7986
    inc [hl]                                      ; $7989
    call Oam_HideUnused                           ; $798A
    rst Rst08_WaitVBlank                          ; $798D
    ld hl, $9808                                  ; $798E
    call Album_DrawChoiceMarker                   ; $7991

jr_004_7994:
    call AlbumPage_DrawUp                         ; $7994
    call Oam_HideUnused                           ; $7997
    rst Rst08_WaitVBlank                          ; $799A
    ld a, [wArrowAnimFrame]                       ; $799B
    cp $02                                        ; $799E
    jr nz, jr_004_7994                            ; $79A0

jr_004_79a2:
    call Oam_ClearShadow                          ; $79A2
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $79A5
    ld b, $10                                     ; $79A8

jr_004_79aa:
    push bc                                       ; $79AA
    push hl                                       ; $79AB
    ldh a, [hScyShadow]                           ; $79AC
    sub [hl]                                      ; $79AE
    ldh [hScyShadow], a                           ; $79AF
    cpl                                           ; $79B1
    add $64                                       ; $79B2
    ldh [hLycShadowSplit1], a                     ; $79B4
    rst Rst08_WaitVBlank                          ; $79B6
    pop hl                                        ; $79B7
    pop bc                                        ; $79B8
    inc hl                                        ; $79B9
    dec b                                         ; $79BA
    jr nz, jr_004_79aa                            ; $79BB

    pop af                                        ; $79BD
    bit 0, a                                      ; $79BE
    jr nz, jr_004_79c8                            ; $79C0

    set_state STATE_0A_PHOTO_ARROWS               ; $79C2
    ret                                           ; $79C7


jr_004_79c8:
    screen_off                                    ; $79C8
    stat_irq_off                                  ; $79CE
    ld a, [wCopyPhotoIdxA]                        ; $79D8
    ld [wPhotoIndex], a                           ; $79DB
    ld a, $01                                     ; $79DE
    ld [wAbResult], a                             ; $79E0
    ld a, $02                                     ; $79E3
    ld [wCallerCode], a                           ; $79E5
    xor a                                         ; $79E8
    ld [wPrintLayoutFlag], a                      ; $79E9
    ld [wBorderNormalised], a                     ; $79EC
    ld [wPrintExtraFlag], a                       ; $79EF
    ld a, MODE_PRINT_PHOTO_PICKER                 ; $79F2
    ld [wMode], a                                 ; $79F4
    set_state STATE_1C_SHOW_PRINT_SCREEN          ; $79F7
    ret                                           ; $79FC


; C: single item page (Print)
AlbumPage_DrawUp::
    ld bc, $3910                                  ; $79FD
    ld a, [wArrowAnimFrame]                       ; $7A00
    cp $02                                        ; $7A03
    ret z                                         ; $7A05

    ld a, [wArrowAnimFrame]                       ; $7A06
    sla a                                         ; $7A09
    ld e, a                                       ; $7A0B
    ld d, $00                                     ; $7A0C
    ld hl, AlbumPage_DrawUp_Tbl7A2E               ; $7A0E
    add hl, de                                    ; $7A11
    ld a, [hl+]                                   ; $7A12
    call Oam_AddMeta_B01_4000                     ; $7A13
    ld a, [wArrowAnimTick]                        ; $7A16
    cp [hl]                                       ; $7A19
    jr nz, jr_004_7a24                            ; $7A1A

    ld hl, wArrowAnimFrame                        ; $7A1C
    inc [hl]                                      ; $7A1F
    xor a                                         ; $7A20
    ld [wArrowAnimTick], a                        ; $7A21

jr_004_7a24:
    ld a, [wArrowAnimFrame]                       ; $7A24
    and a                                         ; $7A27
    ret z                                         ; $7A28

    ld hl, wArrowAnimTick                         ; $7A29
    inc [hl]                                      ; $7A2C
    ret                                           ; $7A2D


; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawUp. L3 pass 2026-10-26: read in BGB in 63 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawUp_Tbl7A2E::
    db $a0, $10, $a1, $0b, $a1, $ff

; C
Mode0A_State08_PageDown::
    call AlbumPage_DrawDown                       ; $7A34
    ldh a, [hKeysNew]                             ; $7A37
    and PADF_A | PADF_B | PADF_UP                 ; $7A39
    ret z                                         ; $7A3B

    push af                                       ; $7A3C
    bit 0, a                                      ; $7A3D
    ld a, SFX1_PAGE_STEP                          ; $7A3F
    call nz, Snd_Sfx1                             ; $7A41
    pop af                                        ; $7A44
    push af                                       ; $7A45
    bit 1, a                                      ; $7A46
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7A48
    call nz, Snd_Sfx1                             ; $7A4A
    pop af                                        ; $7A4D
    push af                                       ; $7A4E
    bit 6, a                                      ; $7A4F
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7A51
    call nz, Snd_Sfx1                             ; $7A53
    pop af                                        ; $7A56
    push af                                       ; $7A57
    bit 0, a                                      ; $7A58
    jr z, jr_004_7a78                             ; $7A5A

    ld hl, wArrowAnimFrame                        ; $7A5C
    inc [hl]                                      ; $7A5F
    call Oam_HideUnused                           ; $7A60
    rst Rst08_WaitVBlank                          ; $7A63
    ld hl, $9a88                                  ; $7A64
    call Album_DrawChoiceMarker                   ; $7A67

jr_004_7a6a:
    call AlbumPage_DrawDown                       ; $7A6A
    call Oam_HideUnused                           ; $7A6D
    rst Rst08_WaitVBlank                          ; $7A70
    ld a, [wArrowAnimFrame]                       ; $7A71
    cp $02                                        ; $7A74
    jr nz, jr_004_7a6a                            ; $7A76

jr_004_7a78:
    call Oam_ClearShadow                          ; $7A78
    ld hl, Mode09_State03_PageLeft_Tbl2FB5        ; $7A7B
    ld b, $10                                     ; $7A7E

jr_004_7a80:
    push bc                                       ; $7A80
    push hl                                       ; $7A81
    ldh a, [hScyShadow]                           ; $7A82
    add [hl]                                      ; $7A84
    ldh [hScyShadow], a                           ; $7A85
    cpl                                           ; $7A87
    add $64                                       ; $7A88
    ldh [hLycShadowSplit1], a                     ; $7A8A
    rst Rst08_WaitVBlank                          ; $7A8C
    pop hl                                        ; $7A8D
    pop bc                                        ; $7A8E
    inc hl                                        ; $7A8F
    dec b                                         ; $7A90
    jr nz, jr_004_7a80                            ; $7A91

    pop af                                        ; $7A93
    bit 0, a                                      ; $7A94
    jr nz, jr_004_7a9e                            ; $7A96

    set_state STATE_0A_PHOTO_ARROWS               ; $7A98
    ret                                           ; $7A9D


jr_004_7a9e:
    screen_off                                    ; $7A9E
    stat_irq_off                                  ; $7AA4
    ld a, [wCopyPhotoIdxA]                        ; $7AAE
    ld [wPhotoIndex], a                           ; $7AB1
    ld a, $01                                     ; $7AB4
    ld [wAbResult], a                             ; $7AB6
    ld a, $02                                     ; $7AB9
    ld [wMsgStripSel], a                          ; $7ABB
    ld a, $00                                     ; $7ABE
    ld [wIconSel], a                              ; $7AC0
    ld a, $02                                     ; $7AC3
    ld [wCallerCode], a                           ; $7AC5
    ld a, MODE_DELETE_PHOTO                       ; $7AC8
    ld [wMode], a                                 ; $7ACA
    set_state STATE_0F_CONFIRM_INIT               ; $7ACD
    ret                                           ; $7AD2


; C: single item page (Delete)
AlbumPage_DrawDown::
    ld bc, $3780                                  ; $7AD3
    ld a, [wArrowAnimFrame]                       ; $7AD6
    cp $02                                        ; $7AD9
    ret z                                         ; $7ADB

    ld a, [wArrowAnimFrame]                       ; $7ADC
    sla a                                         ; $7ADF
    ld e, a                                       ; $7AE1
    ld d, $00                                     ; $7AE2
    ld hl, AlbumPage_DrawDown_Tbl7B04             ; $7AE4
    add hl, de                                    ; $7AE7
    ld a, [hl+]                                   ; $7AE8
    call Oam_AddMeta_B01_4000                     ; $7AE9
    ld a, [wArrowAnimTick]                        ; $7AEC
    cp [hl]                                       ; $7AEF
    jr nz, jr_004_7afa                            ; $7AF0

    ld hl, wArrowAnimFrame                        ; $7AF2
    inc [hl]                                      ; $7AF5
    xor a                                         ; $7AF6
    ld [wArrowAnimTick], a                        ; $7AF7

jr_004_7afa:
    ld a, [wArrowAnimFrame]                       ; $7AFA
    and a                                         ; $7AFD
    ret z                                         ; $7AFE

    ld hl, wArrowAnimTick                         ; $7AFF
    inc [hl]                                      ; $7B02
    ret                                           ; $7B03


; C: auto: 6 bytes, bytes; referenced by AlbumPage_DrawDown. L3 pass 2026-10-26: read in BGB in 35 replay(s) of the
; organic corpus, modes 09 0A (tcrf_check/assets/l3_names/)
AlbumPage_DrawDown_Tbl7B04::
    db $bc, $10, $bd, $0b, $bd, $ff

; C
Mode0A_State09_Leave::
    screen_off                                    ; $7B0A
    stat_irq_off                                  ; $7B10
    set_state STATE_0A_INIT                       ; $7B1A
    ret                                           ; $7B1F


; C
Mode0A_State0A_FrameInit::
    screen_off                                    ; $7B20
    stat_irq_off                                  ; $7B26
    xor a                                         ; $7B30
    ld [wSubstate], a                             ; $7B31
    next_state                                    ; $7B34
    ret                                           ; $7B38


; C: far call 08:4DF2
Mode0A_State0B_FrameEdit::
    ldh [hFarcallAArg], a                         ; $7B39
    farcall BorderPicker_Far                      ; $7B3B
    ret                                           ; $7B43


; C
Mode0A_State0C_FrameSave::
    ld a, [wCopyPhotoIdxA]                        ; $7B44
    ldh [hFarcallAArg], a                         ; $7B47
    farcall Photo_StoreBorder_Far                 ; $7B49
    ld a, $01                                     ; $7B51
    ld [wAbResult], a                             ; $7B53
    jp Mode0A_State02_Setup                       ; $7B56


; C
Mode0A_State0D_CommentInit::
    screen_off                                    ; $7B59
    stat_irq_off                                  ; $7B5F
    ld a, [wCopyPhotoIdxA]                        ; $7B69
    ld [wCmtPhotoIndex], a                        ; $7B6C
    ldh [hFarcallAArg], a                         ; $7B6F
    farcall Photo_LoadTagFields_Far               ; $7B71
    xor a                                         ; $7B79
    ld [wSubstate], a                             ; $7B7A
    next_state                                    ; $7B7D
    ret                                           ; $7B81


; C: far call 09:4281
Mode0A_State0E_CommentEdit::
    ldh [hFarcallAArg], a                         ; $7B82
    ld a, $09                                     ; $7B84
    ld hl, CommentEditor_Far                      ; $7B86
    call Far_Call                                 ; $7B89
    ret                                           ; $7B8C


; C
Mode0A_State0F_CommentSave::
    ld a, [wCopyPhotoIdxA]                        ; $7B8D
    ldh [hFarcallAArg], a                         ; $7B90
    farcall Photo_StoreTagFields_Far              ; $7B92
    ld a, $01                                     ; $7B9A
    ld [wAbResult], a                             ; $7B9C
    jp Mode0A_State02_Setup                       ; $7B9F


; C: writes the 2x2 marker tiles $AC..$AF at HL
Album_DrawChoiceMarker::
    ld a, $ac                                     ; $7BA2
    call Vram_WriteByteSafe                       ; $7BA4
    inc a                                         ; $7BA7
    inc hl                                        ; $7BA8
    call Vram_WriteByteSafe                       ; $7BA9
    inc a                                         ; $7BAC
    ld bc, $001f                                  ; $7BAD
    add hl, bc                                    ; $7BB0
    call Vram_WriteByteSafe                       ; $7BB1
    inc a                                         ; $7BB4
    inc hl                                        ; $7BB5
    call Vram_WriteByteSafe                       ; $7BB6
    ret                                           ; $7BB9


; C
Album_LoadSliderScreen::
    call Oam_ClearShadow                          ; $7BBA
    ld a, $e4                                     ; $7BBD
    ldh [hBgpShadow], a                           ; $7BBF
    ldh [hObp0Shadow], a                          ; $7BC1
    ld a, $d2                                     ; $7BC3
    ldh [hObp1Shadow], a                          ; $7BC5
    farcopy Vram_CopyFromBank, Map_27_4470_Mode0D_State06_PlayInit, $9800, $02c0 ; $7BC7
    call Album_DrawSliderNumber                   ; $7BD5
    farcopy Vram_CopyFromBank, Gfx_0C_7C00_Album_LoadSliderScreen, $8900, $0200 ; $7BD8
    farcopy Vram_CopyFromBank, Gfx_0C_7900_Album_LoadSliderScreen, $8600, $0200 ; $7BE6
    farcopy Vram_CopyFromBank, Gfx_0C_7930_Mode09_State00_Init, $8ff0, $0010 ; $7BF4
    farcopy Vram_CopyFromBank, Gfx_0C_79A0_Mode0A_State02_Setup, $8f70, $0010 ; $7C02
    ld a, [wCopyPhotoIdxA]                        ; $7C10
    ldh [hFarcallAArg], a                         ; $7C13
    farcall Photo_LoadBorder_Far                  ; $7C15
    ldh [hFarcallAArg], a                         ; $7C1D
    farcall Border_LoadMap_Safe                   ; $7C1F
    ret                                           ; $7C27


; C
Album_LoadBorderScreen::
    call Oam_ClearShadow                          ; $7C28
    ld a, $e4                                     ; $7C2B
    ldh [hObp0Shadow], a                          ; $7C2D
    ld a, $d2                                     ; $7C2F
    ldh [hObp1Shadow], a                          ; $7C31
    farcopy Vram_CopyFromBank, Map_27_4470_Mode0D_State06_PlayInit, $9800, $02c0 ; $7C33
    farcopy Vram_CopyFromBank, Gfx_1A_7600_Album_ShowPageScreenB, $8900, $0700 ; $7C41
    farcopy Vram_CopyFromBank, Gfx_1C_5600_Album_ShowPageScreenB, $87e0, $0020 ; $7C4F
    farcopy Vram_CopyFromBank, Map_24_73E0_Album_ShowPageScreenB, $9800, $02c0 ; $7C5D
    ret                                           ; $7C6B


; C: jittering metasprite $0E while slider_timer runs
Slider_DrawTimerSpark::
    ld a, [wSliderTimer]                          ; $7C6C
    and a                                         ; $7C6F
    ret z                                         ; $7C70

    dec a                                         ; $7C71
    ld [wSliderTimer], a                          ; $7C72
    ldh a, [hFrameCounter]                        ; $7C75
    and $01                                       ; $7C77
    jr nz, jr_004_7c87                            ; $7C79

    call Rng_Next                                 ; $7C7B
    ld [wJitterX], a                              ; $7C7E
    call Rng_Next                                 ; $7C81
    ld [wJitterY], a                              ; $7C84

jr_004_7c87:
    ld a, [wJitterX]                              ; $7C87
    and $01                                       ; $7C8A
    add $14                                       ; $7C8C
    ld b, a                                       ; $7C8E
    ld a, [wJitterY]                              ; $7C8F
    and $01                                       ; $7C92
    add $14                                       ; $7C94
    ld c, a                                       ; $7C96
    ld a, $0e                                     ; $7C97
    call Oam_AddMeta_B01_4000                     ; $7C99
    ret                                           ; $7C9C


; I: UNREFERENCED: Left / Right steps copy_photo_idx_a with wrap in 0..29 / 30..59
Unused_Mode0A_PhotoStepWrap::
    ld hl, hKeysRepeatSticky                      ; $7C9D
    ld a, [wCopyPhotoIdxA]                        ; $7CA0
    cp $1e                                        ; $7CA3
    jr nc, jr_004_7caf                            ; $7CA5

    ld bc, $001d                                  ; $7CA7
    call Photo_StepWrap                           ; $7CAA
    jr jr_004_7cb5                                ; $7CAD

jr_004_7caf:
    ld bc, $1e3b                                  ; $7CAF
    call Photo_StepWrap                           ; $7CB2

jr_004_7cb5:
    bit 6, [hl]                                   ; $7CB5
    jr nz, jr_004_7cbd                            ; $7CB7

    bit 7, [hl]                                   ; $7CB9
    jr z, jr_004_7cc3                             ; $7CBB

jr_004_7cbd:
    sub $1e                                       ; $7CBD
    jr nc, jr_004_7cc3                            ; $7CBF

    add $3c                                       ; $7CC1

jr_004_7cc3:
    ld hl, wCopyPhotoIdxA                         ; $7CC3
    cp [hl]                                       ; $7CC6
    ret z                                         ; $7CC7

    ld [hl], a                                    ; $7CC8
    ld a, $b4                                     ; $7CC9
    ld [wSliderTimer], a                          ; $7CCB
    ld a, $01                                     ; $7CCE
    ld [wSliderRedraw], a                         ; $7CD0
    ret                                           ; $7CD3


; C: B = first C = last: Left/Right (bit 5 / 4 of HL) step A
Photo_StepWrap::
    bit 5, [hl]                                   ; $7CD4
    jr z, jr_004_7ce6                             ; $7CD6

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7CD8
    cp b                                          ; $7CDF
    jr nz, jr_004_7ce4                            ; $7CE0

    ld a, c                                       ; $7CE2
    ret                                           ; $7CE3


jr_004_7ce4:
    dec a                                         ; $7CE4
    ret                                           ; $7CE5


jr_004_7ce6:
    bit 4, [hl]                                   ; $7CE6
    ret z                                         ; $7CE8

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7CE9
    cp c                                          ; $7CF0
    jr nz, jr_004_7cf5                            ; $7CF1

    ld a, b                                       ; $7CF3
    ret                                           ; $7CF4


jr_004_7cf5:
    inc a                                         ; $7CF5
    ret                                           ; $7CF6


; C
Album_DrawSliderNumber::
    ld a, [wCopyPhotoIdxA]                        ; $7CF7
    inc a                                         ; $7CFA
    ld bc, $0000                                  ; $7CFB
    cp $1f                                        ; $7CFE
    jr c, jr_004_7d05                             ; $7D00

    sub $1e                                       ; $7D02
    inc c                                         ; $7D04

jr_004_7d05:
    cp $0a                                        ; $7D05
    jr c, jr_004_7d0e                             ; $7D07

    sub $0a                                       ; $7D09
    inc b                                         ; $7D0B
    jr jr_004_7d05                                ; $7D0C

jr_004_7d0e:
    push af                                       ; $7D0E
    push bc                                       ; $7D0F
    ld de, $8f80                                  ; $7D10
    ld a, c                                       ; $7D13
    call Album_LoadNumeralTileB                   ; $7D14
    pop bc                                        ; $7D17
    ld a, b                                       ; $7D18
    inc a                                         ; $7D19
    inc a                                         ; $7D1A
    call Album_LoadNumeralTileB                   ; $7D1B
    pop af                                        ; $7D1E
    inc a                                         ; $7D1F
    inc a                                         ; $7D20

; C: numeral tile (32 bytes) from bank 26:7E00
Album_LoadNumeralTileB::
    swap a                                        ; $7D21
    ld c, a                                       ; $7D23
    ld b, $00                                     ; $7D24
    sla c                                         ; $7D26
    rl b                                          ; $7D28
    ld hl, Gfx_26_7E00_Album_LoadNumeralTileB     ; $7D2A
    add hl, bc                                    ; $7D2D
    ld a, BANK(Gfx_26_7E00_Album_LoadNumeralTileB) ; $7D2E
    ld bc, $0020                                  ; $7D30
    call Vram_CopyFromBank                        ; $7D33
    ret                                           ; $7D36


    ; padding
    ds $2c9, $00

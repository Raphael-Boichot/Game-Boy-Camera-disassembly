; Game Boy Camera (USA, Europe), bank $05. Written by tools/make_source.py from roms/us_eu/gbcam_usa_eu.sym and the tables of
; roms/us_eu/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; C: mode 1F: D.J. (TRIPY-H) music editor
Mode1F_DjEditor::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; I: 13 states
Mode1F_StateTable::
    dw Mode1F_State00_TitleInit
    dw Mode1F_State01_MenuSource
    dw Mode1F_State02_MenuSong
    dw Mode1F_State03_MenuPerformer
    dw Mode1F_State04_PerformanceSetup
    dw Mode1F_State05_Performance
    dw Mode1F_State06_SavePanel
    dw Mode1F_State07_QuitPanel
    dw Mode1F_State08_EditPagesSetup
    dw Mode1F_State09_PageSound1
    dw Mode1F_State0A_PageSound2
    dw Mode1F_State0B_PageNoise
    dw Mode1F_State0C_Restart

; C: title screen graphics; music; performer / source defaults
Mode1F_State00_TitleInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJ16 | LCDCF_OBJON | LCDCF_BGON ; $401E
    ldh [hLcdcShadow], a                          ; $4020
    ld a, $e4                                     ; $4022
    ld [wPaletteTarget], a                        ; $4024
    ld [wPaletteTarget + $1], a                   ; $4027
    ld a, $d2                                     ; $402A
    ld [wPaletteTarget + $2], a                   ; $402C
    xor a                                         ; $402F
    ldh [hScxShadow], a                           ; $4030
    ldh [hScyShadow], a                           ; $4032
    ldh [hFarcallAArg], a                         ; $4034
    farcall GameFace_LoadTiles_Far                ; $4036
    ld a, [wGamefacePresent]                      ; $403E
    and a                                         ; $4041
    jr z, jr_005_4049                             ; $4042

    ld a, $02                                     ; $4044
    ld [wStartPerformerSet], a                    ; $4046

jr_005_4049:
    ldh [hFarcallAArg], a                         ; $4049
    farcall Dj_LoadTune_Far                       ; $404B
    ld a, [wSavedTunePresent]                     ; $4053
    and a                                         ; $4056
    jr z, jr_005_405e                             ; $4057

    ld a, $02                                     ; $4059
    ld [wStartTuneSource], a                      ; $405B

jr_005_405e:
    farcopy Mem_CopyFromBank, Gfx_10_5C00_Mode1F_State00_TitleInit, $8000, $1800 ; $405E
    farcopy Mem_CopyFromBank, Map_26_6540_Mode1F_State00_TitleInit, $9800, $0240 ; $406C
    screen_on                                     ; $407A
    play_music MUSIC_DJ_TITLE                     ; $4083
    call Pal_FadeIn                               ; $408A
    next_state                                    ; $408D
    ret                                           ; $4091


; C: start menu 1: source of the tune (factory songs / blank / saved)
Mode1F_State01_MenuSource::
    call DjTitle_ReadSourceKeys                   ; $4092
    call DjTitle_DrawMenu1                        ; $4095
    ldh a, [hKeysNew]                             ; $4098
    bit PADB_A, a                                 ; $409A
    jr z, jr_005_40cb                             ; $409C

    play_sfx1 SFX1_CURSOR_MOVE                    ; $409E
    ld a, [wStartTuneSource]                      ; $40A5
    and a                                         ; $40A8
    jr nz, jr_005_40b3                            ; $40A9

    call DjTitle_DrawSongNumber                   ; $40AB
    next_state                                    ; $40AE
    ret                                           ; $40B2


jr_005_40b3:
    cp $01                                        ; $40B3
    jr z, jr_005_40c5                             ; $40B5

    ld a, [wSavedTunePresent]                     ; $40B7
    and a                                         ; $40BA
    jr nz, jr_005_40c5                            ; $40BB

    play_sfx1 SFX1_BEEP_REFUSED                   ; $40BD
    ret                                           ; $40C4


jr_005_40c5:
    set_state STATE_1F_MENU_PERFORMER             ; $40C5
    ret                                           ; $40CA


jr_005_40cb:
    bit 1, a                                      ; $40CB
    ret z                                         ; $40CD

    play_sfx1 SFX1_KEY_B                          ; $40CE
    screen_off                                    ; $40D5
    ld a, MODE_MAIN_MENU                          ; $40DB
    ld [wMode], a                                 ; $40DD
    set_state STATE_00_INIT                       ; $40E0
    ret                                           ; $40E5


; C: Left / Right changes start_menu_1 (0..2; saved only if present)
DjTitle_ReadSourceKeys::
    ldh a, [hKeysNewRepeat]                       ; $40E6
    ld b, a                                       ; $40E8
    ld a, [wStartTuneSource]                      ; $40E9
    bit 5, b                                      ; $40EC
    jr z, jr_005_40f5                             ; $40EE

    and a                                         ; $40F0
    ret z                                         ; $40F1

    dec a                                         ; $40F2
    jr jr_005_40fc                                ; $40F3

jr_005_40f5:
    bit 4, b                                      ; $40F5
    ret z                                         ; $40F7

    cp $02                                        ; $40F8
    ret z                                         ; $40FA

    inc a                                         ; $40FB

jr_005_40fc:
    ld [wStartTuneSource], a                      ; $40FC
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $40FF
    ret                                           ; $4106


; C
DjTitle_DrawMenu1::
    call DjTitle_DrawSourceSprite                 ; $4107
    call DjTitle_DrawArrowLeft                    ; $410A
    call DjTitle_DrawArrowRight                   ; $410D
    call DjTitle_DrawPerformer                    ; $4110
    ret                                           ; $4113


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite::
    ldh a, [hFrameCounter]                        ; $4114
    srl a                                         ; $4116
    srl a                                         ; $4118
    and $01                                       ; $411A
    ld hl, wStartTuneSource                       ; $411C
    add [hl]                                      ; $411F
    add [hl]                                      ; $4120
    add $55                                       ; $4121
    ld bc, $306c                                  ; $4123
    call Oam_AddMeta_B02_6F16                     ; $4126
    ret                                           ; $4129


; I: left arrow of the tune-source selector ($D9D5 = 0 factory songs / 1 blank / 2 saved): drawn when $D9D5 >= 1 at x
; = $13 (value 1) or $2B (value 2), y = $59, meta $60 + frame; the sprite alternates between two frames every 4 frames
; ($FFC8 >> 2 & 1) through Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowLeft::
    ld a, [wStartTuneSource]                      ; $412A
    cp $01                                        ; $412D
    ret c                                         ; $412F

    ld bc, $1359                                  ; $4130
    jr z, jr_005_4137                             ; $4133

    ld b, $2b                                     ; $4135

jr_005_4137:
    ldh a, [hFrameCounter]                        ; $4137
    srl a                                         ; $4139
    srl a                                         ; $413B
    and $01                                       ; $413D
    add $5d                                       ; $413F
    call Oam_AddMeta_B02_6F16                     ; $4141
    ret                                           ; $4144


; I: right arrow of the tune-source selector: drawn when $D9D5 < 2 at x = $2D (value 0) or $45 (value 1), y = $59,
; meta $5E + frame; the sprite alternates between two frames every 4 frames ($FFC8 >> 2 & 1) through
; Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowRight::
    ld a, [wStartTuneSource]                      ; $4145
    cp $02                                        ; $4148
    ret nc                                        ; $414A

    ld bc, $4559                                  ; $414B
    cp $01                                        ; $414E
    jr z, jr_005_4154                             ; $4150

    ld b, $2d                                     ; $4152

jr_005_4154:
    ldh a, [hFrameCounter]                        ; $4154
    srl a                                         ; $4156
    srl a                                         ; $4158
    and $01                                       ; $415A
    add $5b                                       ; $415C
    call Oam_AddMeta_B02_6F16                     ; $415E
    ret                                           ; $4161


; I: performer sprite from start_menu_performer_character. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; executed in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjTitle_DrawPerformer::
    ld a, [wStartPerformerSet]                    ; $4162
    add $60                                       ; $4165
    ld bc, $348e                                  ; $4167
    call Oam_AddMeta_B02_6F16                     ; $416A
    ret                                           ; $416D


; C: start menu 2: factory song number (4 songs)
Mode1F_State02_MenuSong::
    call DjTitle_ReadSongKeys                     ; $416E
    call DjTitle_DrawMenu2                        ; $4171
    ldh a, [hKeysNew]                             ; $4174
    bit PADB_A, a                                 ; $4176
    jr z, jr_005_4186                             ; $4178

    play_sfx1 SFX1_CURSOR_MOVE                    ; $417A
    next_state                                    ; $4181
    ret                                           ; $4185


jr_005_4186:
    bit 1, a                                      ; $4186
    ret z                                         ; $4188

    play_sfx1 SFX1_KEY_B                          ; $4189
    ld hl, wState                                 ; $4190
    dec [hl]                                      ; $4193
    ret                                           ; $4194


; C
DjTitle_ReadSongKeys::
    ldh a, [hKeysNewRepeat]                       ; $4195
    ld b, a                                       ; $4197
    ld a, [wStartFactorySong]                     ; $4198
    bit 5, b                                      ; $419B
    jr z, jr_005_41a4                             ; $419D

    and a                                         ; $419F
    ret z                                         ; $41A0

    dec a                                         ; $41A1
    jr jr_005_41ab                                ; $41A2

jr_005_41a4:
    bit 4, b                                      ; $41A4
    ret z                                         ; $41A6

    cp $03                                        ; $41A7
    ret z                                         ; $41A9

    inc a                                         ; $41AA

jr_005_41ab:
    ld [wStartFactorySong], a                     ; $41AB
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $41AE
    call DjTitle_DrawSongNumber                   ; $41B5
    ret                                           ; $41B8


; C
DjTitle_DrawMenu2::
    call DjTitle_DrawFrame2                       ; $41B9
    call DjTitle_DrawArrowUp2                     ; $41BC
    call DjTitle_DrawArrowDown2                   ; $41BF
    call DjTitle_DrawSourceSprite2                ; $41C2
    call DjTitle_DrawPerformer2                   ; $41C5
    ret                                           ; $41C8


; I: two sprites $6E / $6F. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
DjTitle_DrawFrame2::
    ld a, $6b                                     ; $41C9
    ld bc, $4658                                  ; $41CB
    call Oam_AddMeta_B02_6F16                     ; $41CE
    ld a, $6c                                     ; $41D1
    ld bc, $4e58                                  ; $41D3
    call Oam_AddMeta_B02_6F16                     ; $41D6
    ret                                           ; $41D9


; I: up arrow of the factory-song selector ($D9D6 = 0-3): drawn when $D9D6 >= 1 at x = $3E, y = $54, meta $6A + frame;
; the sprite alternates between two frames every 4 frames ($FFC8 >> 2 & 1) through Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowUp2::
    ld a, [wStartFactorySong]                     ; $41DA
    cp $01                                        ; $41DD
    ret c                                         ; $41DF

    ld bc, $3e54                                  ; $41E0
    ldh a, [hFrameCounter]                        ; $41E3
    srl a                                         ; $41E5
    srl a                                         ; $41E7
    and $01                                       ; $41E9
    add $67                                       ; $41EB
    call Oam_AddMeta_B02_6F16                     ; $41ED
    ret                                           ; $41F0


; I: down arrow of the factory-song selector: drawn when $D9D6 < 3 at x = $4E, y = $54, meta $6C + frame; the sprite
; alternates between two frames every 4 frames ($FFC8 >> 2 & 1) through Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowDown2::
    ld a, [wStartFactorySong]                     ; $41F1
    cp $03                                        ; $41F4
    ret nc                                        ; $41F6

    ld bc, $4e54                                  ; $41F7
    ldh a, [hFrameCounter]                        ; $41FA
    srl a                                         ; $41FC
    srl a                                         ; $41FE
    and $01                                       ; $4200
    add $69                                       ; $4202
    call Oam_AddMeta_B02_6F16                     ; $4204
    ret                                           ; $4207


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite2::
    ld a, [wStartTuneSource]                      ; $4208
    sla a                                         ; $420B
    add $55                                       ; $420D
    ld bc, $306c                                  ; $420F
    call Oam_AddMeta_B02_6F16                     ; $4212
    ret                                           ; $4215


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawPerformer2::
    ld a, [wStartPerformerSet]                    ; $4216
    add $60                                       ; $4219
    ld bc, $348e                                  ; $421B
    call Oam_AddMeta_B02_6F16                     ; $421E
    ret                                           ; $4221


; C: song number as two numeral tiles at $8800
DjTitle_DrawSongNumber::
    ld a, [wStartFactorySong]                     ; $4222
    inc a                                         ; $4225
    ld c, $00                                     ; $4226

jr_005_4228:
    cp $0a                                        ; $4228
    jr c, jr_005_4231                             ; $422A

    sub $0a                                       ; $422C
    inc c                                         ; $422E
    jr jr_005_4228                                ; $422F

jr_005_4231:
    ld de, $8800                                  ; $4231
    push af                                       ; $4234
    ld a, c                                       ; $4235
    call DjTitle_LoadNumeralTile                  ; $4236
    pop af                                        ; $4239

; C: 32-byte numeral tile from 10:7400
DjTitle_LoadNumeralTile::
    swap a                                        ; $423A
    ld c, a                                       ; $423C
    ld b, $00                                     ; $423D
    sla c                                         ; $423F
    rl b                                          ; $4241
    ld hl, Gfx_10_7400_DjTitle_LoadNumeralTile    ; $4243
    add hl, bc                                    ; $4246
    ld a, BANK(Gfx_10_7400_DjTitle_LoadNumeralTile) ; $4247
    ld bc, $0020                                  ; $4249
    call Vram_CopyFromBank                        ; $424C
    ret                                           ; $424F


; C: start menu 3: performer character; A loads the tune and starts the editor
Mode1F_State03_MenuPerformer::
    call DjTitle_ReadPerformerKeys                ; $4250
    call DjTitle_DrawMenu3                        ; $4253
    ldh a, [hKeysNew]                             ; $4256
    bit PADB_A, a                                 ; $4258
    jr z, jr_005_42ad                             ; $425A

    play_sfx1 SFX1_CURSOR_MOVE                    ; $425C
    screen_off                                    ; $4263
    ld a, [wStartTuneSource]                      ; $4269
    and a                                         ; $426C
    jr nz, jr_005_4278                            ; $426D

    ld a, [wStartFactorySong]                     ; $426F
    inc a                                         ; $4272
    call DjEd_SetFieldCursor                      ; $4273
    jr jr_005_428c                                ; $4276

jr_005_4278:
    cp $01                                        ; $4278
    jr nz, jr_005_4282                            ; $427A

    xor a                                         ; $427C
    call DjEd_SetFieldCursor                      ; $427D
    jr jr_005_428c                                ; $4280

jr_005_4282:
    ldh [hFarcallAArg], a                         ; $4282
    farcall Dj_LoadTune_Far                       ; $4284

jr_005_428c:
    xor a                                         ; $428C
    ld [wDirtyFlag], a                            ; $428D
    call DjEd_ResetCursors                        ; $4290
    xor a                                         ; $4293
    ldh [rNR50], a                                ; $4294
    ldh [rNR51], a                                ; $4296
    call DjSnd_BuildWaveStaging                   ; $4298
    call DjSnd_LoadWaveRam                        ; $429B
    ld a, $ff                                     ; $429E
    ldh [rNR50], a                                ; $42A0
    ldh [rNR51], a                                ; $42A2
    ld a, $80                                     ; $42A4
    ldh [rNR52], a                                ; $42A6
    next_state                                    ; $42A8
    ret                                           ; $42AC


jr_005_42ad:
    bit 1, a                                      ; $42AD
    ret z                                         ; $42AF

    play_sfx1 SFX1_KEY_B                          ; $42B0
    ld a, [wStartTuneSource]                      ; $42B7
    and a                                         ; $42BA
    jr nz, jr_005_42c5                            ; $42BB

    call DjTitle_DrawSongNumber                   ; $42BD
    ld hl, wState                                 ; $42C0
    dec [hl]                                      ; $42C3
    ret                                           ; $42C4


jr_005_42c5:
    set_state STATE_1F_MENU_SOURCE                ; $42C5
    ret                                           ; $42CA


; C
DjTitle_ReadPerformerKeys::
    ldh a, [hKeysNewRepeat]                       ; $42CB
    ld b, a                                       ; $42CD
    ld a, [wStartPerformerSet]                    ; $42CE
    bit 5, b                                      ; $42D1
    jr z, jr_005_42da                             ; $42D3

    and a                                         ; $42D5
    ret z                                         ; $42D6

    dec a                                         ; $42D7
    jr jr_005_42e1                                ; $42D8

jr_005_42da:
    bit 4, b                                      ; $42DA
    ret z                                         ; $42DC

    cp $02                                        ; $42DD
    ret z                                         ; $42DF

    inc a                                         ; $42E0

jr_005_42e1:
    ld [wStartPerformerSet], a                    ; $42E1
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $42E4
    ret                                           ; $42EB


; C
DjTitle_DrawMenu3::
    call DjTitle_DrawSourceSprite3                ; $42EC
    call DjTitle_DrawPerformerBlink               ; $42EF
    call DjTitle_DrawArrowLeft3                   ; $42F2
    call DjTitle_DrawArrowRight3                  ; $42F5
    call DjTitle_DrawFrame3                       ; $42F8
    ret                                           ; $42FB


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite3::
    ld a, [wStartTuneSource]                      ; $42FC
    sla a                                         ; $42FF
    add $55                                       ; $4301
    ld bc, $306c                                  ; $4303
    call Oam_AddMeta_B02_6F16                     ; $4306
    ret                                           ; $4309


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawPerformerBlink::
    ldh a, [hFrameCounter]                        ; $430A
    srl a                                         ; $430C
    srl a                                         ; $430E
    and $01                                       ; $4310
    jr z, jr_005_4318                             ; $4312

    ld hl, wStartPerformerSet                     ; $4314
    add [hl]                                      ; $4317

jr_005_4318:
    add $5f                                       ; $4318
    ld bc, $348e                                  ; $431A
    call Oam_AddMeta_B02_6F16                     ; $431D
    ret                                           ; $4320


; I: left arrow of the performer-set selector ($D9D3 = 0-2): drawn when $D9D3 >= 1 at x = $1E, y = $8D, meta $66 +
; frame; the sprite alternates between two frames every 4 frames ($FFC8 >> 2 & 1) through Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowLeft3::
    ld a, [wStartPerformerSet]                    ; $4321
    cp $01                                        ; $4324
    ret c                                         ; $4326

    ld bc, $1e8d                                  ; $4327
    ldh a, [hFrameCounter]                        ; $432A
    srl a                                         ; $432C
    srl a                                         ; $432E
    and $01                                       ; $4330
    add $63                                       ; $4332
    call Oam_AddMeta_B02_6F16                     ; $4334
    ret                                           ; $4337


; I: right arrow of the performer-set selector: drawn when $D9D3 < 2 at x = $42, y = $8D, meta $68 + frame; the sprite
; alternates between two frames every 4 frames ($FFC8 >> 2 & 1) through Oam_AddMeta_B02_6E4B
DjTitle_DrawArrowRight3::
    ld a, [wStartPerformerSet]                    ; $4338
    cp $02                                        ; $433B
    ret nc                                        ; $433D

    ld bc, $428d                                  ; $433E
    ldh a, [hFrameCounter]                        ; $4341
    srl a                                         ; $4343
    srl a                                         ; $4345
    and $01                                       ; $4347
    add $65                                       ; $4349
    call Oam_AddMeta_B02_6F16                     ; $434B
    ret                                           ; $434E


; I: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawFrame3::
    ld a, [wStartTuneSource]                      ; $434F
    and a                                         ; $4352
    ret nz                                        ; $4353

    ld a, $6b                                     ; $4354
    ld bc, $4658                                  ; $4356
    call Oam_AddMeta_B02_6F16                     ; $4359
    ld a, $6c                                     ; $435C
    ld bc, $4e58                                  ; $435E
    call Oam_AddMeta_B02_6F16                     ; $4361
    ret                                           ; $4364


; I: performance screen: graphics; three channel indicators; tempo and level digits
Mode1F_State04_PerformanceSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $4365
    ldh [hLcdcShadow], a                          ; $4367
    ld a, $e4                                     ; $4369
    ld [wPaletteTarget], a                        ; $436B
    ld [wPaletteTarget + $1], a                   ; $436E
    ld a, $d2                                     ; $4371
    ld [wPaletteTarget + $2], a                   ; $4373
    xor a                                         ; $4376
    ldh [hScxShadow], a                           ; $4377
    ldh [hScxBand1], a                            ; $4379
    ldh [hScxBand2], a                            ; $437B
    ldh [hScyShadow], a                           ; $437D
    ldh [hScyBand1], a                            ; $437F
    ld a, $30                                     ; $4381
    ldh [hScyBand2], a                            ; $4383
    ld a, $07                                     ; $4385
    ldh [hWxShadow], a                            ; $4387
    ld a, $9c                                     ; $4389
    ldh [hWyShadow], a                            ; $438B
    ld a, $1a                                     ; $438D
    ld hl, Gfx_1A_4000_Mode1F_State04_PerformanceSetup ; $438F
    ld de, $8000                                  ; $4392
    ld bc, $0d80                                  ; $4395
    call Mem_CopyFromBank                         ; $4398
    farcopy Mem_CopyFromBank, Map_20_7E40_Mode1F_State04_PerformanceSetup, $9e00, $01c0 ; $439B
    farcopy Mem_CopyFromBank, Map_22_7B40_Mode1F_State04_PerformanceSetup, $9800, $0400 ; $43A9
    ldh [hFarcallAArg], a                         ; $43B7
    farcall GameFace_LoadTiles_Far                ; $43B9
    call DjTitle_LoadPerformerGfx                 ; $43C1
    call DjPerf_Init                              ; $43C4
    ld a, $0f                                     ; $43C7
    ldh [hLycShadowSplit1], a                     ; $43C9
    ldh [hSplit1Latch], a                         ; $43CB
    ld hl, hStatShadow                            ; $43CD
    set 6, [hl]                                   ; $43D0
    ld hl, rIE                                    ; $43D2
    set 1, [hl]                                   ; $43D5
    ld a, $06                                     ; $43D7
    ldh [hStatHandlerIndex], a                    ; $43D9
    screen_on                                     ; $43DB
    play_music MUSIC_STOP                         ; $43E4
    rst Rst08_WaitVBlank                          ; $43EB
    play_music MUSIC_HOLD                         ; $43EC
    call DjPerf_DrawTempo                         ; $43F3
    call DjPerf_DrawChannel1State                 ; $43F6
    call DjPerf_DrawChannel2State                 ; $43F9
    call DjPerf_DrawChannel3State                 ; $43FC
    call DjPerf_DrawLevelDigit                    ; $43FF
    xor a                                         ; $4402
    ldh [rNR50], a                                ; $4403
    ldh [rNR51], a                                ; $4405
    call Pal_FadeIn                               ; $4407
    ld a, $ff                                     ; $440A
    ldh [rNR50], a                                ; $440C
    ldh [rNR51], a                                ; $440E
    ld a, $80                                     ; $4410
    ldh [rNR52], a                                ; $4412
    next_state                                    ; $4414
    ret                                           ; $4418


; C: plays the tune; Select goes to the edit pages (state 08)
Mode1F_State05_Performance::
    call DjEd_Tick                                ; $4419
    call DjPerf_Input                             ; $441C
    call DjPerf_Animate                           ; $441F
    call DjPerf_ChannelFade                       ; $4422
    call DjSnd_Tick                               ; $4425
    ldh a, [hKeysNew]                             ; $4428
    bit PADB_SELECT, a                            ; $442A
    jr z, jr_005_4444                             ; $442C

    screen_off                                    ; $442E
    stat_irq_off                                  ; $4434
    set_state STATE_1F_EDIT_PAGES_SETUP           ; $443E
    ret                                           ; $4443


jr_005_4444:
    ld a, [wState]                                ; $4444
    cp $06                                        ; $4447
    ret nz                                        ; $4449

    ld a, [wDirtyFlag]                            ; $444A
    and a                                         ; $444D
    jr nz, jr_005_446d                            ; $444E

    screen_off                                    ; $4450
    stat_irq_off                                  ; $4456
    play_music MUSIC_STOP                         ; $4460
    set_state STATE_1F_TITLE_INIT                 ; $4467
    ret                                           ; $446C


jr_005_446d:
    call Oam_HideUnused                           ; $446D
    ld c, $03                                     ; $4470
    call DjEd_LoadPerformerTiles9480              ; $4472
    farcopy Vram_CopyFromBank, Gfx_1A_4E00_Mode1F_State05_Performance, $8d60, $02a0 ; $4475
    farcopy Vram_CopyFromBank, Map_27_63D0_Mode1F_State05_Performance, $9c00, $00e0 ; $4483
    rst Rst08_WaitVBlank                          ; $4491
    call DjEd_Tick                                ; $4492
    call DjPerf_NR51MaskAll                       ; $4495
    call DjSnd_Tick                               ; $4498
    call DjPanel_SlideOut                         ; $449B
    call Oam_ClearShadow                          ; $449E
    call DjPerf_UpdatePerformerTiles              ; $44A1
    call DjPanel_WaitLine                         ; $44A4
    ret                                           ; $44A7


; I: A: stores the tune (02:4A6B); slides the panel away; BGB watchpoint pass 2026-10-25: ran only in mode 1F and
; state 06 (5044 hits in 2 runs: 1F:06 x5044; tcrf_check/assets/mode_state_wp/)
Mode1F_State06_SavePanel::
    call DjPerf_UpdatePerformerTiles              ; $44A8
    ldh a, [hKeysNew]                             ; $44AB
    bit PADB_B, a                                 ; $44AD
    jr nz, jr_005_44c7                            ; $44AF

    bit PADB_A, a                                 ; $44B1
    ret z                                         ; $44B3

    play_sfx3 SFX3_DELETE_DIALOG_FIRST            ; $44B4
    ldh [hFarcallAArg], a                         ; $44BB
    farcall Dj_StoreTune_Far                      ; $44BD
    jr jr_005_44ce                                ; $44C5

jr_005_44c7:
    play_sfx3 SFX3_DELETE_DIALOG_SECOND           ; $44C7

jr_005_44ce:
    call Oam_HideUnused                           ; $44CE
    rst Rst08_WaitVBlank                          ; $44D1
    call DjPerf_AnimateSprites                    ; $44D2
    call Oam_HideUnused                           ; $44D5
    call DjPanel_SlideIn                          ; $44D8
    farcopy Vram_CopyFromBank, Map_27_64B0_Mode1F_State06_SavePanel, $9c00, $00e0 ; $44DB
    call DjPanel_SlideOut                         ; $44E9
    call Oam_ClearShadow                          ; $44EC
    call DjPerf_UpdatePerformerTiles              ; $44EF
    call DjPanel_WaitLine                         ; $44F2
    next_state                                    ; $44F5
    ret                                           ; $44F9


; I: A: back to the title; B: back to the performance; BGB watchpoint pass 2026-10-25: ran only in mode 1F and state
; 07 (4322 hits in 1 runs: 1F:07 x4322; tcrf_check/assets/mode_state_wp/)
Mode1F_State07_QuitPanel::
    call DjPerf_UpdatePerformerTiles              ; $44FA
    ldh a, [hKeysNew]                             ; $44FD
    bit PADB_A, a                                 ; $44FF
    jr z, jr_005_4534                             ; $4501

    play_sfx3 SFX3_DELETE_DIALOG_FIRST            ; $4503
    call Oam_HideUnused                           ; $450A
    rst Rst08_WaitVBlank                          ; $450D
    call DjPerf_AnimateSprites                    ; $450E
    call Oam_HideUnused                           ; $4511
    call DjPanel_SlideIn                          ; $4514
    screen_off                                    ; $4517
    stat_irq_off                                  ; $451D
    play_music MUSIC_STOP                         ; $4527
    set_state STATE_1F_TITLE_INIT                 ; $452E
    ret                                           ; $4533


jr_005_4534:
    bit 1, a                                      ; $4534
    ret z                                         ; $4536

    play_sfx3 SFX3_DELETE_DIALOG_SECOND           ; $4537
    call Oam_HideUnused                           ; $453E
    rst Rst08_WaitVBlank                          ; $4541
    call DjPerf_AnimateSprites                    ; $4542
    call Oam_HideUnused                           ; $4545
    call DjPanel_SlideIn                          ; $4548
    ld c, $00                                     ; $454B
    call DjEd_LoadPerformerTiles8D80              ; $454D
    ld c, $02                                     ; $4550
    call DjEd_LoadPerformerTiles9480              ; $4552
    call DjPerf_NR51MaskFromChannels              ; $4555
    call DjPerf_AnimateSprites                    ; $4558
    set_state STATE_1F_PERFORMANCE                ; $455B
    ret                                           ; $4560


; C: builds the SOUND I / SOUND II / NOISE pages; wave graph and cursors
Mode1F_State08_EditPagesSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $4561
    ldh [hLcdcShadow], a                          ; $4563
    ld a, $e4                                     ; $4565
    ld [wPaletteTarget], a                        ; $4567
    ld [wPaletteTarget + $1], a                   ; $456A
    ld a, $d2                                     ; $456D
    ld [wPaletteTarget + $2], a                   ; $456F
    xor a                                         ; $4572
    ldh [hScxShadow], a                           ; $4573
    ldh [hScxBand1], a                            ; $4575
    ld a, $fc                                     ; $4577
    ldh [hScyShadow], a                           ; $4579
    ldh [hScyBand1], a                            ; $457B
    ld a, $77                                     ; $457D
    ldh [hWxShadow], a                            ; $457F
    ld a, $64                                     ; $4581
    ldh [hWyShadow], a                            ; $4583
    call DjPerf_Init                              ; $4585
    call DjSnd_BuildWaveStaging                   ; $4588
    ld a, $ff                                     ; $458B
    ld [wSound1FieldCursor + $1], a               ; $458D
    ld [wSound2FieldCursor + $1], a               ; $4590
    ld [wNoiseFieldCursor + $1], a                ; $4593
    ld a, $09                                     ; $4596
    ld [wSound1FieldCursor], a                    ; $4598
    ld a, $07                                     ; $459B
    ld [wSound2FieldCursor], a                    ; $459D
    ld a, $05                                     ; $45A0
    ld [wNoiseFieldCursor], a                     ; $45A2
    xor a                                         ; $45A5
    ld [wSound1FieldCursor + $2], a               ; $45A6
    ld [wSound2FieldCursor + $2], a               ; $45A9
    ld [wNoiseFieldCursor + $2], a                ; $45AC
    ld hl, wDirtyFlag                             ; $45AF
    set 0, [hl]                                   ; $45B2
    farcopy Mem_CopyFromBank, Data_1C_6D60_Mode1F_State07_QuitPanel, $9000, $0500 ; $45B4
    farcopy Mem_CopyFromBank, Gfx_1C_7260_Mode1F_State08_EditPagesSetup, $8a00, $0600 ; $45C2
    farcopy Mem_CopyFromBank, Gfx_1C_7860_Mode1F_State08_EditPagesSetup, $8400, $0400 ; $45D0
    ld a, $1d                                     ; $45DE
    ld hl, Gfx_1D_4000_Mode1F_State08_EditPagesSetup ; $45E0
    ld de, $9500                                  ; $45E3
    ld bc, $0300                                  ; $45E6
    call Mem_CopyFromBank                         ; $45E9
    farcopy Mem_CopyFromBank, Gfx_1D_4300_Mode1F_State08_EditPagesSetup, $8800, $0200 ; $45EC
    farcopy Mem_CopyFromBank, Map_23_68C0_Mode1F_State08_EditPagesSetup, $9800, $02c0 ; $45FA
    farcopy Mem_CopyFromBank, Map_27_7DB0_Mode1F_State08_EditPagesSetup, $9c00, $00c0 ; $4608
    ld hl, $9be0                                  ; $4616
    ld bc, $0020                                  ; $4619
    ld a, $ff                                     ; $461C
    call Mem_FillBc1                              ; $461E
    farcopy Mem_CopyFromBank, Data_1C_6D60_Mode1F_State07_QuitPanel, wLevelTileStaging, $0080 ; $4621
    farcopy Mem_CopyFromBank, Src_1C_6E60_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $80, $0080 ; $462F
    farcopy Mem_CopyFromBank, Src_1C_6F60_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $100, $0080 ; $463D
    farcopy Mem_CopyFromBank, Src_1C_7060_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $180, $0080 ; $464B
    ld a, $04                                     ; $4659
    ld [wWaveGraphPhase], a                       ; $465B
    ld a, $63                                     ; $465E
    ldh [hLycShadowSplit1], a                     ; $4660
    ldh [hSplit1Latch], a                         ; $4662
    ld hl, hStatShadow                            ; $4664
    set 6, [hl]                                   ; $4667
    ld hl, rIE                                    ; $4669
    set 1, [hl]                                   ; $466C
    ld a, $02                                     ; $466E
    ldh [hStatHandlerIndex], a                    ; $4670
    call Oam_ClearShadow                          ; $4672
    call DjEd_DrawPageTabs                        ; $4675
    call Pal_AllWhite                             ; $4678
    call Lcd_On                                   ; $467B
    ld a, [wSound1DutyLen]                        ; $467E
    swap a                                        ; $4681
    sla a                                         ; $4683
    ld c, a                                       ; $4685
    ld b, $00                                     ; $4686
    ld hl, $9861                                  ; $4688
    add hl, bc                                    ; $468B
    ld a, $c9                                     ; $468C
    call Vram_WriteByteSafe                       ; $468E
    ld a, [wSound1Envelope]                       ; $4691
    ld hl, $9884                                  ; $4694
    add $da                                       ; $4697
    call Vram_WriteByteSafe                       ; $4699
    ld a, [wSound1Modulation + $2]                ; $469C
    swap a                                        ; $469F
    sla a                                         ; $46A1
    ld c, a                                       ; $46A3
    ld b, $00                                     ; $46A4
    ld hl, $9871                                  ; $46A6
    add hl, bc                                    ; $46A9
    ld a, $ca                                     ; $46AA
    call Vram_WriteByteSafe                       ; $46AC
    ld de, wSound1Notes                           ; $46AF
    call DjEd_DrawNoteRow                         ; $46B2
    call Pal_FadeIn                               ; $46B5
    next_state                                    ; $46B8
    ret                                           ; $46BC


; C: page tab sprites $A5 / $A7
DjEd_DrawPageTabs::
    ld bc, $0084                                  ; $46BD
    ld a, $a5                                     ; $46C0
    call Oam_AddMeta_B01_5D2B                     ; $46C2
    ld bc, $7f0e                                  ; $46C5
    ld a, $a7                                     ; $46C8
    call Oam_AddMeta_B01_5D2B                     ; $46CA
    ret                                           ; $46CD


; C: SOUND I page: field editor; redraw; page keys
Mode1F_State09_PageSound1::
    call DjEd_DrawPageTabs                        ; $46CE
    call DjS1_FieldDispatch                       ; $46D1
    call DjEd_Tick                                ; $46D4
    call DjS1_DrawAllValues                       ; $46D7
    call DjS2_DrawValueRow                        ; $46DA
    call DjSnd_Tick                               ; $46DD
    ldh a, [hKeysNew]                             ; $46E0
    bit PADB_SELECT, a                            ; $46E2
    jr z, jr_005_4754                             ; $46E4

    call Oam_HideUnused                           ; $46E6
    rst Rst08_WaitVBlank                          ; $46E9
    call DjEd_DrawPageTabs                        ; $46EA
    call DjS1_DrawModAndLoop                      ; $46ED
    call DjS2_DrawValueRow                        ; $46F0
    farcopy Vram_CopyFromBank, Gfx_1D_4500_Mode1F_State09_PageSound1, $9500, $0300 ; $46F3
    farcopy Vram_CopyFromBank, Map_23_6B00_Mode1F_State09_PageSound1, $9840, $0080 ; $4701
    farcopy Vram_CopyFromBank, Gfx_1D_4800_Mode1F_State09_PageSound1, $8800, $0200 ; $470F
    ld a, [wSound2WaveLen]                        ; $471D
    swap a                                        ; $4720
    sla a                                         ; $4722
    ld c, a                                       ; $4724
    ld b, $00                                     ; $4725
    ld hl, $9861                                  ; $4727
    add hl, bc                                    ; $472A
    ld a, $cb                                     ; $472B
    call Vram_WriteByteSafe                       ; $472D
    ld a, [wSound2Modulation + $2]                ; $4730
    swap a                                        ; $4733
    sla a                                         ; $4735
    ld c, a                                       ; $4737
    ld b, $00                                     ; $4738
    ld hl, $9871                                  ; $473A
    add hl, bc                                    ; $473D
    ld a, $ca                                     ; $473E
    call Vram_WriteByteSafe                       ; $4740
    ld a, $ff                                     ; $4743
    ld [wSound2FieldCursor + $1], a               ; $4745
    ld de, wSound2Notes                           ; $4748
    call DjEd_DrawNoteRow                         ; $474B
    set_state STATE_1F_PAGE_SOUND2                ; $474E
    ret                                           ; $4753


jr_005_4754:
    bit 1, a                                      ; $4754
    jr z, jr_005_475e                             ; $4756

    set_state STATE_1F_RESTART                    ; $4758
    ret                                           ; $475D


jr_005_475e:
    ldh a, [hKeysHeld]                            ; $475E
    bit PADB_START, a                             ; $4760
    ret z                                         ; $4762

    ldh a, [hKeysNew]                             ; $4763
    bit PADB_A, a                                 ; $4765
    ret z                                         ; $4767

    jp DjPrint_Job                                ; $4768


; C: rst $18 on the SOUND I field cursor
DjS1_FieldDispatch::
    ld a, [wSound1FieldCursor]                    ; $476B
    rst Rst18_JumpTable                           ; $476E

; I: 12 SOUND I field handlers
DjS1_FieldTbl::
    dw DjS1_Field00_Duty
    dw DjS1_Field01_EnvDir
    dw DjS1_Field02_Volume
    dw DjS1_Field03_EnvPeriod
    dw DjS1_Field04_Length
    dw DjS1_Field05_ModDepth
    dw DjS1_Field06_ModSpeed
    dw DjS1_Field07_ModMode
    dw DjS1_Field08_LoopLength
    dw DjS1_Field09_NoteGrid
    dw DjS1_Field0A_NoteEdit
    dw DjS1_Field0B_StereoEdit

; C: SOUND II page
Mode1F_State0A_PageSound2::
    call DjEd_DrawPageTabs                        ; $4787
    call DjS2_FieldDispatch                       ; $478A
    call DjEd_Tick                                ; $478D
    call DjS2_RedrawWaveGraphStep                 ; $4790
    call DjS2_WaveRedrawTick                      ; $4793
    call DjS2_WaveRedrawColumns                   ; $4796
    call DjS2_WaveGraphToVram                     ; $4799
    call DjSnd_Tick                               ; $479C
    ldh a, [hKeysNew]                             ; $479F
    bit PADB_SELECT, a                            ; $47A1
    jr z, jr_005_4809                             ; $47A3

    call Oam_HideUnused                           ; $47A5
    rst Rst08_WaitVBlank                          ; $47A8
    call DjEd_DrawPageTabs                        ; $47A9
    call DjS2_DrawAllValues                       ; $47AC
    call DjS2_WaveRedrawTick                      ; $47AF
    farcopy Vram_CopyFromBank, Map_23_6C00_Mode1F_State0A_PageSound2, $9840, $0080 ; $47B2
    farcopy Vram_CopyFromBank, Gfx_1D_4A00_Mode1F_State0A_PageSound2, $9500, $0300 ; $47C0
    farcopy Vram_CopyFromBank, Map_23_6B80_Mode1F_State0A_PageSound2, $9840, $0080 ; $47CE
    farcopy Vram_CopyFromBank, Gfx_1D_4D00_Mode1F_State0A_PageSound2, $8800, $0200 ; $47DC
    call DjEd_DrawPageTabNoise                    ; $47EA
    ld a, [wNoiseEnvelope]                        ; $47ED
    ld hl, $9884                                  ; $47F0
    add $da                                       ; $47F3
    call Vram_WriteByteSafe                       ; $47F5
    ld a, $ff                                     ; $47F8
    ld [wNoiseFieldCursor + $1], a                ; $47FA
    ld de, wNoiseNotes                            ; $47FD
    call DjEd_DrawNoteRow                         ; $4800
    set_state STATE_1F_PAGE_NOISE                 ; $4803
    ret                                           ; $4808


jr_005_4809:
    bit 1, a                                      ; $4809
    ret z                                         ; $480B

    set_state STATE_1F_RESTART                    ; $480C
    ret                                           ; $4811


; C: rst $18 on the SOUND II field cursor
DjS2_FieldDispatch::
    ld a, [wSound2FieldCursor]                    ; $4812
    rst Rst18_JumpTable                           ; $4815

; I: 10 SOUND II field handlers
DjS2_FieldTbl::
    dw DjS2_Field00_WavePattern
    dw DjS2_Field01_WaveGrid
    dw DjS2_Field02_Length
    dw DjS2_Field03_ModDepth
    dw DjS2_Field04_ModSpeed
    dw DjS2_Field05_ModMode
    dw DjS2_Field06_LoopLength
    dw DjS2_Field07_NoteGrid
    dw DjS2_Field08_NoteEdit
    dw DjS2_Field09_StereoEdit

; C: NOISE page
Mode1F_State0B_PageNoise::
    call DjEd_DrawPageTabs                        ; $482A
    call DjEd_DrawPageTabNoise                    ; $482D
    call DjNs_FieldDispatch                       ; $4830
    call DjEd_Tick                                ; $4833
    call DjNs_DrawAllValues                       ; $4836
    call DjNs_DrawPlayCursor                      ; $4839
    call DjSnd_Tick                               ; $483C
    ldh a, [hKeysNew]                             ; $483F
    bit PADB_SELECT, a                            ; $4841
    jr z, jr_005_48be                             ; $4843

    call Oam_HideUnused                           ; $4845
    rst Rst08_WaitVBlank                          ; $4848
    call DjEd_DrawPageTabs                        ; $4849
    call DjNs_DrawAllValues                       ; $484C
    call DjNs_DrawPlayCursor                      ; $484F
    ld a, $1d                                     ; $4852
    ld hl, Gfx_1D_4000_Mode1F_State08_EditPagesSetup ; $4854
    ld de, $9500                                  ; $4857
    ld bc, $0300                                  ; $485A
    call Vram_CopyFromBank                        ; $485D
    farcopy Vram_CopyFromBank, Map_23_6900_Mode1F_State0B_PageNoise, $9840, $0080 ; $4860
    farcopy Vram_CopyFromBank, Gfx_1D_4300_Mode1F_State08_EditPagesSetup, $8800, $0200 ; $486E
    ld a, [wSound1DutyLen]                        ; $487C
    swap a                                        ; $487F
    sla a                                         ; $4881
    ld c, a                                       ; $4883
    ld b, $00                                     ; $4884
    ld hl, $9861                                  ; $4886
    add hl, bc                                    ; $4889
    ld a, $c9                                     ; $488A
    call Vram_WriteByteSafe                       ; $488C
    ld a, [wSound1Envelope]                       ; $488F
    ld hl, $9884                                  ; $4892
    add $da                                       ; $4895
    call Vram_WriteByteSafe                       ; $4897
    ld a, [wSound1Modulation + $2]                ; $489A
    swap a                                        ; $489D
    sla a                                         ; $489F
    ld c, a                                       ; $48A1
    ld b, $00                                     ; $48A2
    ld hl, $9871                                  ; $48A4
    add hl, bc                                    ; $48A7
    ld a, $ca                                     ; $48A8
    call Vram_WriteByteSafe                       ; $48AA
    ld a, $ff                                     ; $48AD
    ld [wSound1FieldCursor + $1], a               ; $48AF
    ld de, wSound1Notes                           ; $48B2
    call DjEd_DrawNoteRow                         ; $48B5
    set_state STATE_1F_PAGE_SOUND1                ; $48B8
    ret                                           ; $48BD


jr_005_48be:
    bit 1, a                                      ; $48BE
    ret z                                         ; $48C0

    set_state STATE_1F_RESTART                    ; $48C1
    ret                                           ; $48C6


; C: tab sprite $A6. L3 pass 2026-10-26: executed in BGB in the scenarios dj_perf_start_noise 1F:0A,
; dj_perf_start_noise 1F:0B, dj_print_noise 1F:0A, dj_print_noise 1F:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
DjEd_DrawPageTabNoise::
    ld bc, $062f                                  ; $48C7
    ld a, $a6                                     ; $48CA
    call Oam_AddMeta_B01_5D2B                     ; $48CC
    ret                                           ; $48CF


; C: rst $18 on the NOISE field cursor
DjNs_FieldDispatch::
    ld a, [wNoiseFieldCursor]                     ; $48D0
    rst Rst18_JumpTable                           ; $48D3

; I: 8 NOISE field handlers
DjNs_FieldTbl::
    dw DjNs_Field00_EnvDir
    dw DjNs_Field01_Volume
    dw DjNs_Field02_EnvPeriod
    dw DjNs_Field03_Gate
    dw DjNs_Field04_LoopLength
    dw DjNs_Field05_NoteGrid
    dw DjNs_Field06_NoteEdit
    dw DjNs_Field07_StereoEdit

; C: back to state 04 with a fade
Mode1F_State0C_Restart::
    set_state STATE_1F_PERFORMANCE_SETUP          ; $48E4
    screen_off                                    ; $48E9
    stat_irq_off                                  ; $48EF
    ret                                           ; $48F9


; C: A held: Left / Right steps A within [B;C] with auto repeat and a blip (variant 1)
DjEd_StepValue_Right::
    ld hl, hKeysHeld                              ; $48FA
    bit 0, [hl]                                   ; $48FD
    ret z                                         ; $48FF

    ld hl, hKeysNewRepeat                         ; $4900
    bit 7, [hl]                                   ; $4903
    jr z, jr_005_4914                             ; $4905

    cp b                                          ; $4907
    jr z, jr_005_4923                             ; $4908

    ui_sfx $03                                    ; $490A
    dec a                                         ; $4911
    jr jr_005_4923                                ; $4912

jr_005_4914:
    bit 6, [hl]                                   ; $4914
    jr z, jr_005_4923                             ; $4916

    cp c                                          ; $4918
    jr z, jr_005_4923                             ; $4919

    ui_sfx $02                                    ; $491B
    inc a                                         ; $4922

jr_005_4923:
    ld hl, hKeysHeld                              ; $4923
    res 7, [hl]                                   ; $4926
    res 6, [hl]                                   ; $4928
    inc hl                                        ; $492A
    res 7, [hl]                                   ; $492B
    res 6, [hl]                                   ; $492D
    inc hl                                        ; $492F
    res 7, [hl]                                   ; $4930
    res 6, [hl]                                   ; $4932
    ret                                           ; $4934


; C: same for Up / Down (bits 6 / 7)
DjEd_StepValue_Up::
    ld hl, hKeysHeld                              ; $4935
    bit 0, [hl]                                   ; $4938
    ret z                                         ; $493A

    ld hl, hKeysNewRepeat                         ; $493B
    bit 6, [hl]                                   ; $493E
    jr z, jr_005_494f                             ; $4940

    cp b                                          ; $4942
    jr z, jr_005_495e                             ; $4943

    ui_sfx $06                                    ; $4945
    dec a                                         ; $494C
    jr jr_005_495e                                ; $494D

jr_005_494f:
    bit 7, [hl]                                   ; $494F
    jr z, jr_005_495e                             ; $4951

    cp c                                          ; $4953
    jr z, jr_005_495e                             ; $4954

    ui_sfx $07                                    ; $4956
    inc a                                         ; $495D

jr_005_495e:
    ld hl, hKeysHeld                              ; $495E
    res 7, [hl]                                   ; $4961
    res 6, [hl]                                   ; $4963
    inc hl                                        ; $4965
    res 7, [hl]                                   ; $4966
    res 6, [hl]                                   ; $4968
    inc hl                                        ; $496A
    res 7, [hl]                                   ; $496B
    res 6, [hl]                                   ; $496D
    ret                                           ; $496F


; C: same for Left / Right (bits 5 / 4)
DjEd_StepValue_LeftRight::
    ld hl, hKeysHeld                              ; $4970
    bit 0, [hl]                                   ; $4973
    ret z                                         ; $4975

    ld hl, hKeysNewRepeat                         ; $4976
    bit 5, [hl]                                   ; $4979
    jr z, jr_005_498a                             ; $497B

    cp b                                          ; $497D
    jr z, jr_005_4999                             ; $497E

    ui_sfx $06                                    ; $4980
    dec a                                         ; $4987
    jr jr_005_4999                                ; $4988

jr_005_498a:
    bit 4, [hl]                                   ; $498A
    jr z, jr_005_4999                             ; $498C

    cp c                                          ; $498E
    jr z, jr_005_4999                             ; $498F

    ui_sfx $07                                    ; $4991
    inc a                                         ; $4998

jr_005_4999:
    ld hl, hKeysHeld                              ; $4999
    res 4, [hl]                                   ; $499C
    res 5, [hl]                                   ; $499E
    inc hl                                        ; $49A0
    res 4, [hl]                                   ; $49A1
    res 5, [hl]                                   ; $49A3
    inc hl                                        ; $49A5
    res 4, [hl]                                   ; $49A6
    res 5, [hl]                                   ; $49A8
    ret                                           ; $49AA


; C: Left / Right step A between B and C (no A held needed)
DjEd_StepLeftRight::
    ld hl, hKeysNewRepeat                         ; $49AB
    bit 5, [hl]                                   ; $49AE
    jr z, jr_005_49bd                             ; $49B0

    cp b                                          ; $49B2
    ret z                                         ; $49B3

    ui_sfx $08                                    ; $49B4
    dec a                                         ; $49BB
    ret                                           ; $49BC


jr_005_49bd:
    bit 4, [hl]                                   ; $49BD
    ret z                                         ; $49BF

    cp c                                          ; $49C0
    ret z                                         ; $49C1

    ui_sfx $08                                    ; $49C2
    inc a                                         ; $49C9
    ret                                           ; $49CA


; C: Up / Down step A between B and C
DjEd_StepUpDown::
    ld hl, hKeysNewRepeat                         ; $49CB
    bit 6, [hl]                                   ; $49CE
    jr z, jr_005_49dd                             ; $49D0

    cp b                                          ; $49D2
    ret z                                         ; $49D3

    ui_sfx $08                                    ; $49D4
    dec a                                         ; $49DB
    ret                                           ; $49DC


jr_005_49dd:
    bit 7, [hl]                                   ; $49DD
    ret z                                         ; $49DF

    cp c                                          ; $49E0
    ret z                                         ; $49E1

    ui_sfx $08                                    ; $49E2
    inc a                                         ; $49E9
    ret                                           ; $49EA


; C: Down / Up step with auto repeat
DjEd_StepDownUp::
    ld hl, hKeysNewRepeat                         ; $49EB
    bit 7, [hl]                                   ; $49EE
    jr z, jr_005_49fd                             ; $49F0

    cp b                                          ; $49F2
    ret z                                         ; $49F3

    ui_sfx $08                                    ; $49F4
    dec a                                         ; $49FB
    ret                                           ; $49FC


jr_005_49fd:
    bit 6, [hl]                                   ; $49FD
    ret z                                         ; $49FF

    cp c                                          ; $4A00
    ret z                                         ; $4A01

    ui_sfx $08                                    ; $4A02
    inc a                                         ; $4A09
    ret                                           ; $4A0A


; I: tempo accumulator: +tempo each frame; tick at 900; advances the three playback steps
DjEd_Tick::
    xor a                                         ; $4A0B
    ld [wTickFlag], a                             ; $4A0C
    ld a, [wPerfPaused]                           ; $4A0F
    and a                                         ; $4A12
    ret nz                                        ; $4A13

    ld a, [wTempo]                                ; $4A14
    ld hl, wTempoAcc                              ; $4A17
    add [hl]                                      ; $4A1A
    ld [hl+], a                                   ; $4A1B
    jr nc, jr_005_4a1f                            ; $4A1C

    inc [hl]                                      ; $4A1E

jr_005_4a1f:
    ld a, [hl-]                                   ; $4A1F
    cp $03                                        ; $4A20
    ret c                                         ; $4A22

    ld a, [hl]                                    ; $4A23
    jr nz, jr_005_4a29                            ; $4A24

    cp $84                                        ; $4A26
    ret c                                         ; $4A28

jr_005_4a29:
    sub $84                                       ; $4A29
    ld [hl+], a                                   ; $4A2B
    ld a, [hl]                                    ; $4A2C
    sbc $03                                       ; $4A2D
    ld [hl], a                                    ; $4A2F
    ld hl, wTickFlag                              ; $4A30
    inc [hl]                                      ; $4A33
    ret                                           ; $4A34


; C: field cursors to their first fields and steps to 0
DjEd_ResetCursors::
    ld a, $ff                                     ; $4A35
    ld [wSound1FieldCursor + $1], a               ; $4A37
    ld [wSound2FieldCursor + $1], a               ; $4A3A
    ld [wNoiseFieldCursor + $1], a                ; $4A3D
    ld a, $09                                     ; $4A40
    ld [wSound1FieldCursor], a                    ; $4A42
    ld a, $07                                     ; $4A45
    ld [wSound2FieldCursor], a                    ; $4A47
    ld a, $05                                     ; $4A4A
    ld [wNoiseFieldCursor], a                     ; $4A4C
    xor a                                         ; $4A4F
    ld [wSound1FieldCursor + $2], a               ; $4A50
    ld [wSound2FieldCursor + $2], a               ; $4A53
    ld [wNoiseFieldCursor + $2], a                ; $4A56
    xor a                                         ; $4A59
    ld [wSound1PlayStep], a                       ; $4A5A
    ld [wSound2PlayStep], a                       ; $4A5D
    ld [wNoisePlayStep], a                        ; $4A60
    ret                                           ; $4A63


Call_005_4a64:
    call Call_005_6266                            ; $4A64

; C: playback step cursor sprite
DjEd_DrawPlayCursor::
    push af                                       ; $4A67
    sla a                                         ; $4A68
    sla a                                         ; $4A6A
    sla a                                         ; $4A6C
    add $1d                                       ; $4A6E
    ld b, a                                       ; $4A70
    ld c, $49                                     ; $4A71
    pop af                                        ; $4A73
    and $03                                       ; $4A74
    jr nz, jr_005_4a7c                            ; $4A76

    ld a, $7a                                     ; $4A78
    jr jr_005_4a7e                                ; $4A7A

jr_005_4a7c:
    ld a, $7b                                     ; $4A7C

jr_005_4a7e:
    call Oam_AddMeta_B01_5D2B                     ; $4A7E
    ret                                           ; $4A81


; C
DjEd_DrawNoteStepCursor::
    ld c, a                                       ; $4A82
    ld b, $00                                     ; $4A83
    add hl, bc                                    ; $4A85
    ld a, [hl]                                    ; $4A86
    ld c, a                                       ; $4A87
    sla a                                         ; $4A88
    add c                                         ; $4A8A
    ld c, a                                       ; $4A8B
    ld b, $00                                     ; $4A8C
    ld hl, DjEd_DrawNoteStepCursor_Tbl4BF8        ; $4A8E
    add hl, bc                                    ; $4A91
    ld a, [hl+]                                   ; $4A92
    push af                                       ; $4A93
    ld a, [hl+]                                   ; $4A94
    ld c, a                                       ; $4A95
    call DjEd_ColumnVisible                       ; $4A96
    pop af                                        ; $4A99
    call Oam_AddMeta_B01_5D2B                     ; $4A9A
    ret                                           ; $4A9D


; C: tests whether a column is inside the scrolled window. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; executed in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjEd_ColumnVisible::
    ld a, [hl]                                    ; $4A9E
    ld b, a                                       ; $4A9F
    ld hl, hScxBand1                              ; $4AA0
    sub [hl]                                      ; $4AA3
    jr c, jr_005_4ab0                             ; $4AA4

    cp $18                                        ; $4AA6
    jr c, jr_005_4ab0                             ; $4AA8

    cp $60                                        ; $4AAA
    jr nc, jr_005_4abc                            ; $4AAC

    ld b, a                                       ; $4AAE
    ret                                           ; $4AAF


jr_005_4ab0:
    ld a, b                                       ; $4AB0
    sub $18                                       ; $4AB1
    jr c, jr_005_4ab9                             ; $4AB3

    ld [hl], a                                    ; $4AB5
    ld b, $18                                     ; $4AB6
    ret                                           ; $4AB8


jr_005_4ab9:
    xor a                                         ; $4AB9
    ld [hl], a                                    ; $4ABA
    ret                                           ; $4ABB


jr_005_4abc:
    ld a, b                                       ; $4ABC
    sub $60                                       ; $4ABD
    cp $90                                        ; $4ABF
    jr nc, jr_005_4ac7                            ; $4AC1

    ld [hl], a                                    ; $4AC3
    ld b, $60                                     ; $4AC4
    ret                                           ; $4AC6


jr_005_4ac7:
    ld [hl], $90                                  ; $4AC7
    ld a, b                                       ; $4AC9
    sub $90                                       ; $4ACA
    ld b, a                                       ; $4ACC
    ret                                           ; $4ACD


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjEd_DrawNoteMarker::
    push af                                       ; $4ACE
    sla a                                         ; $4ACF
    sla a                                         ; $4AD1
    sla a                                         ; $4AD3
    add $1c                                       ; $4AD5
    ld b, a                                       ; $4AD7
    ld c, $57                                     ; $4AD8
    ld de, $000f                                  ; $4ADA
    jp DjEd_DrawNoteCursor_BlinkTail              ; $4ADD


; C: blinking cursor on the note grid (blink table at 4B84)
DjEd_DrawNoteCursorBlink::
    ld c, a                                       ; $4AE0
    ld b, $00                                     ; $4AE1
    add hl, bc                                    ; $4AE3
    ld a, [hl]                                    ; $4AE4
    push af                                       ; $4AE5
    ld c, a                                       ; $4AE6
    sla a                                         ; $4AE7
    add c                                         ; $4AE9
    ld c, a                                       ; $4AEA
    ld b, $00                                     ; $4AEB
    ld hl, DjEd_DrawNoteCursorBlink_Tbl4BF9       ; $4AED
    add hl, bc                                    ; $4AF0
    ld c, [hl]                                    ; $4AF1
    inc hl                                        ; $4AF2
    call DjEd_ColumnVisible                       ; $4AF3
    ld de, $0025                                  ; $4AF6

; C: shared tail of DjEd_DrawNoteMarker and DjEd_DrawNoteCursorBlink: frame from the blink table 4B84 by the phase
; $D893, +4 / +2 when A = D / E, Oam_AddMeta_B01_5D47, then advances the blink counter $D892 / phase $D893 (branch
; target; code read 2026-10-19)
DjEd_DrawNoteCursor_BlinkTail::
    push de                                       ; $4AF9
    ld a, [wSndNoteBlinkPhase]                    ; $4AFA
    and $03                                       ; $4AFD
    sla a                                         ; $4AFF
    ld e, a                                       ; $4B01
    ld d, $00                                     ; $4B02
    ld hl, DjEd_DrawNoteCursorBlink_Tbl4B2E       ; $4B04
    add hl, de                                    ; $4B07
    pop de                                        ; $4B08
    pop af                                        ; $4B09
    cp d                                          ; $4B0A
    jr z, jr_005_4b13                             ; $4B0B

    cp e                                          ; $4B0D
    jr z, jr_005_4b17                             ; $4B0E

    xor a                                         ; $4B10
    jr jr_005_4b19                                ; $4B11

jr_005_4b13:
    ld a, $04                                     ; $4B13
    jr jr_005_4b19                                ; $4B15

jr_005_4b17:
    ld a, $02                                     ; $4B17

jr_005_4b19:
    add [hl]                                      ; $4B19
    call Oam_AddMeta_B01_5D2B                     ; $4B1A
    inc hl                                        ; $4B1D
    ld a, [wSndNoteBlinkCounter]                  ; $4B1E
    cp [hl]                                       ; $4B21
    jr c, jr_005_4b29                             ; $4B22

    ld hl, wSndNoteBlinkPhase                     ; $4B24
    inc [hl]                                      ; $4B27
    xor a                                         ; $4B28

jr_005_4b29:
    inc a                                         ; $4B29
    ld [wSndNoteBlinkCounter], a                  ; $4B2A
    ret                                           ; $4B2D


; C: auto: 8 bytes, bytes; referenced by DjEd_DrawNoteCursorBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteCursorBlink_Tbl4B2E::
    db $8c, $15, $8d, $04, $8c, $05, $8d, $02

; C
DjEd_DrawNoteColumn::
    ld c, a                                       ; $4B36
    ld b, $00                                     ; $4B37
    add hl, bc                                    ; $4B39
    ld a, [hl]                                    ; $4B3A
    and $0f                                       ; $4B3B
    ld c, a                                       ; $4B3D
    ld hl, DjEd_DrawNoteColumn_Tbl4B5C            ; $4B3E
    add hl, bc                                    ; $4B41
    ld c, [hl]                                    ; $4B42
    add hl, bc                                    ; $4B43
    ld d, $04                                     ; $4B44

jr_005_4b46:
    ld b, [hl]                                    ; $4B46
    inc hl                                        ; $4B47
    ld c, [hl]                                    ; $4B48
    inc hl                                        ; $4B49
    push hl                                       ; $4B4A
    bit 0, e                                      ; $4B4B
    jr z, jr_005_4b50                             ; $4B4D

    inc hl                                        ; $4B4F

jr_005_4b50:
    ld a, [hl]                                    ; $4B50
    and a                                         ; $4B51
    call nz, Oam_AddMeta_B01_5D2B                 ; $4B52
    pop hl                                        ; $4B55
    inc hl                                        ; $4B56
    inc hl                                        ; $4B57
    dec d                                         ; $4B58
    jr nz, jr_005_4b46                            ; $4B59

    ret                                           ; $4B5B


; C: auto: 102 bytes, bytes; referenced by DjEd_DrawNoteColumn. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteColumn_Tbl4B5C::
    db $06, $15, $24, $33, $42, $51, $80, $86, $74, $75, $78, $86, $6e, $6e, $92, $86
    db $71, $71, $84, $7d, $00, $af, $84, $86, $74, $75, $78, $86, $6e, $6e, $92, $86
    db $6f, $6f, $84, $7d, $00, $ad, $88, $86, $74, $75, $78, $86, $70, $70, $92, $86
    db $6f, $6f, $84, $7d, $00, $ae, $80, $86, $74, $75, $78, $86, $6e, $6e, $92, $86
    db $71, $71, $84, $7d, $00, $ac, $84, $86, $74, $75, $78, $86, $6e, $6e, $92, $86
    db $6f, $6f, $84, $7d, $00, $aa, $88, $86, $74, $75, $78, $86, $70, $70, $92, $86
    db $6f, $6f, $84, $7d, $00, $ab

; C: NOISE width flag sprite. L3 pass 2026-10-26: executed in BGB in the scenarios dj_perf_start_noise 1F:0B,
; dj_print_noise 1F:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
DjEd_DrawWidthFlag::
    ld c, a                                       ; $4BC2
    ld b, $00                                     ; $4BC3
    add hl, bc                                    ; $4BC5
    ld a, [hl]                                    ; $4BC6
    and $10                                       ; $4BC7
    srl a                                         ; $4BC9
    add $80                                       ; $4BCB
    ld b, a                                       ; $4BCD
    ld c, $73                                     ; $4BCE
    ld a, $74                                     ; $4BD0
    call Oam_AddMeta_B01_5D2B                     ; $4BD2
    ret                                           ; $4BD5


; C: loop-length bar sprites $74 / $6E
DjEd_DrawLoopBar::
    ld bc, $8486                                  ; $4BD6
    ld a, $74                                     ; $4BD9
    call Oam_AddMeta_B01_5D2B                     ; $4BDB
    ld bc, $7886                                  ; $4BDE
    ld a, $6e                                     ; $4BE1
    call Oam_AddMeta_B01_5D2B                     ; $4BE3
    ld bc, $9286                                  ; $4BE6
    ld a, $6f                                     ; $4BE9
    call Oam_AddMeta_B01_5D2B                     ; $4BEB
    ret                                           ; $4BEE


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the loop bar sprite of the NOISE page (meta $74 at $8073)
DjEd_DrawLoopBarNoise::
    ld bc, $8073                                  ; $4BEF
    ld a, $74                                     ; $4BF2
    call Oam_AddMeta_B01_5D2B                     ; $4BF4
    ret                                           ; $4BF7


; C: auto: 1 bytes, bytes; referenced by DjEd_DrawNoteStepCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteStepCursor_Tbl4BF8::
    db $77

; C: auto: 113 bytes, bytes; referenced by DjEd_DrawNoteCursorBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteCursorBlink_Tbl4BF9::
    db $80, $10, $77, $80, $1e, $76, $72, $24, $77, $80, $29, $76, $72, $2e, $77, $80
    db $33, $77, $80, $3d, $76, $72, $42, $77, $80, $47, $76, $72, $4c, $77, $80, $51
    db $76, $72, $56, $77, $80, $5b, $77, $80, $66, $76, $72, $6c, $77, $80, $71, $76
    db $72, $76, $77, $80, $7b, $77, $80, $85, $76, $72, $8a, $77, $80, $8f, $76, $72
    db $94, $77, $80, $99, $76, $72, $9e, $77, $80, $a3, $77, $80, $ae, $76, $72, $b4
    db $77, $80, $b9, $76, $72, $be, $77, $80, $c3, $77, $80, $cd, $76, $72, $d2, $77
    db $80, $d7, $76, $72, $dc, $77, $80, $e1, $76, $72, $e6, $77, $80, $eb, $77, $80
    db $f6

; C: one row of 16 notes to the BG at $9923
DjEd_DrawNoteRow::
    ld hl, $9923                                  ; $4C6A
    ld b, $10                                     ; $4C6D

jr_005_4c6f:
    push bc                                       ; $4C6F
    push hl                                       ; $4C70
    ld a, [de]                                    ; $4C71
    and a                                         ; $4C72
    jr z, jr_005_4c85                             ; $4C73

    ld a, $cd                                     ; $4C75
    call Vram_WriteByteSafe                       ; $4C77
    res 5, l                                      ; $4C7A
    set 6, l                                      ; $4C7C
    ld a, $dd                                     ; $4C7E
    call Vram_WriteByteSafe                       ; $4C80
    jr jr_005_4c93                                ; $4C83

jr_005_4c85:
    ld a, $cc                                     ; $4C85
    call Vram_WriteByteSafe                       ; $4C87
    res 5, l                                      ; $4C8A
    set 6, l                                      ; $4C8C
    ld a, $dc                                     ; $4C8E
    call Vram_WriteByteSafe                       ; $4C90

jr_005_4c93:
    pop hl                                        ; $4C93
    pop bc                                        ; $4C94
    inc de                                        ; $4C95
    inc hl                                        ; $4C96
    dec b                                         ; $4C97
    jr nz, jr_005_4c6f                            ; $4C98

    ret                                           ; $4C9A


; C
DjEd_DrawNoteRowOffset::
    ld c, a                                       ; $4C9B
    ld b, $00                                     ; $4C9C
    add hl, bc                                    ; $4C9E
    ld a, [hl]                                    ; $4C9F
    and a                                         ; $4CA0
    jr z, jr_005_4cb6                             ; $4CA1

    ld hl, $9923                                  ; $4CA3
    add hl, bc                                    ; $4CA6
    ld a, $cd                                     ; $4CA7
    call Vram_WriteByteSafe                       ; $4CA9
    res 5, l                                      ; $4CAC
    set 6, l                                      ; $4CAE
    ld a, $dd                                     ; $4CB0
    call Vram_WriteByteSafe                       ; $4CB2
    ret                                           ; $4CB5


jr_005_4cb6:
    ld hl, $9923                                  ; $4CB6
    add hl, bc                                    ; $4CB9
    ld a, $cc                                     ; $4CBA
    call Vram_WriteByteSafe                       ; $4CBC
    res 5, l                                      ; $4CBF
    set 6, l                                      ; $4CC1
    ld a, $dc                                     ; $4CC3
    call Vram_WriteByteSafe                       ; $4CC5
    ret                                           ; $4CC8


; C: pop-in cursor for the highlighted field (frame counter D891)
DjEd_DrawFieldCursor::
    push af                                       ; $4CC9
    ld a, [wSndCursorPopFrames]                   ; $4CCA
    inc a                                         ; $4CCD
    cp $07                                        ; $4CCE
    jr c, jr_005_4cd4                             ; $4CD0

    ld a, $06                                     ; $4CD2

jr_005_4cd4:
    ld [wSndCursorPopFrames], a                   ; $4CD4
    ld e, a                                       ; $4CD7
    ld d, $00                                     ; $4CD8
    ld hl, DjEd_DrawFieldCursor_Tbl4CE5           ; $4CDA
    add hl, de                                    ; $4CDD
    ld e, [hl]                                    ; $4CDE
    pop af                                        ; $4CDF
    add e                                         ; $4CE0
    call Oam_AddMeta_B01_5D2B                     ; $4CE1
    ret                                           ; $4CE4


; C: auto: 7 bytes, bytes; referenced by DjEd_DrawFieldCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjEd_DrawFieldCursor_Tbl4CE5::
    db $00, $01, $01, $02, $02, $01, $02

; C: performance state: pose; channel states; NR51 mask; animation slots
DjPerf_Init::
    ld a, $01                                     ; $4CEC
    ld [wPerformerPose], a                        ; $4CEE
    ld [wPerfChannelState], a                     ; $4CF1
    ld [wPerfChannelState + $1], a                ; $4CF4
    ld [wPerfChannelState + $2], a                ; $4CF7
    ld [wPerfStepIncrement], a                    ; $4CFA
    ld a, $ff                                     ; $4CFD
    ld [wPerfNr51Mask], a                         ; $4CFF
    xor a                                         ; $4D02
    ld [wPerformerFrameGroup], a                  ; $4D03
    ld [wPerformerBeatPhase], a                   ; $4D06
    ld [wPerformerBounceCounter], a               ; $4D09
    ld [wPerfControlCursor], a                    ; $4D0C
    ld [wPerfLevel], a                            ; $4D0F
    ld [wPerformerScriptId], a                    ; $4D12
    ld [wPerfPaused], a                           ; $4D15
    ld [wPerfPausedIcon], a                       ; $4D18
    ld [wPerfPausedAtStart], a                    ; $4D1B
    ld [wSound1VolAtten], a                       ; $4D1E
    ld [wSound2VolAtten], a                       ; $4D21
    ld [wNoiseVolAtten], a                        ; $4D24
    ld a, $dd                                     ; $4D27
    ld [wPerformerTilesTarget], a                 ; $4D29
    ld [wPerformerTilesTarget2], a                ; $4D2C
    ld [wPerformerTilesShown], a                  ; $4D2F
    ld [wPerformerTilesShown2], a                 ; $4D32
    ld a, [wTempo]                                ; $4D35
    ld [wPerfTempoAtRelease], a                   ; $4D38
    ld a, [wPerfLevel]                            ; $4D3B
    ld [wPerfLevelAtRelease], a                   ; $4D3E
    ret                                           ; $4D41


; C: performer; equaliser; speaker and control sprites
DjPerf_Animate::
    call DjPerf_AnimateControlCursor              ; $4D42
    call DjPerf_UpdatePose                        ; $4D45
    call DjPerf_ScrollPerformer                   ; $4D48
    call DjPerf_StepBeatPhase                     ; $4D4B
    call DjPerf_BounceOffset                      ; $4D4E
    call DjPerf_PerformerScript                   ; $4D51
    call DjPerf_UpdatePerformerTiles              ; $4D54
    call DjPerf_AnimateSpeakerBlink               ; $4D57
    call DjPerf_Equaliser                         ; $4D5A
    call DjPerf_DrawPlayIcon                      ; $4D5D
    call DjPerf_DrawTempoNeedle                   ; $4D60
    call DjPerf_DrawSpeakingIcon                  ; $4D63
    call DjPerf_DrawLevelSlider                   ; $4D66
    ret                                           ; $4D69


; C: sprites only
DjPerf_AnimateSprites::
    call DjPerf_AnimateControlCursor              ; $4D6A
    call DjPerf_UpdatePerformerTiles              ; $4D6D
    call DjPerf_AnimateSpeakerBlink               ; $4D70
    call DjPerf_DrawPlayIcon                      ; $4D73
    call DjPerf_DrawTempoNeedle                   ; $4D76
    call DjPerf_DrawSpeakingIcon                  ; $4D79
    call DjPerf_DrawLevelSlider                   ; $4D7C
    ret                                           ; $4D7F


; C
DjPerf_AnimateControlCursor::
    ld a, [wPerfControlCursor]                    ; $4D80
    ld c, a                                       ; $4D83
    ld b, $00                                     ; $4D84
    ld hl, DjPerf_AnimateControlCursor_Tbl4DCA    ; $4D86
    add hl, bc                                    ; $4D89
    ld c, [hl]                                    ; $4D8A
    add hl, bc                                    ; $4D8B
    push hl                                       ; $4D8C
    ld c, $00                                     ; $4D8D
    ld a, [wPerfControlCursor]                    ; $4D8F
    cp $01                                        ; $4D92
    jr z, jr_005_4da0                             ; $4D94

    cp $02                                        ; $4D96
    jr z, jr_005_4dab                             ; $4D98

    cp $03                                        ; $4D9A
    jr z, jr_005_4db6                             ; $4D9C

    jr jr_005_4dbf                                ; $4D9E

jr_005_4da0:
    ld a, [wPerfChannelState]                     ; $4DA0
    and $01                                       ; $4DA3
    jr nz, jr_005_4dbf                            ; $4DA5

    ld c, $05                                     ; $4DA7
    jr jr_005_4dbf                                ; $4DA9

jr_005_4dab:
    ld a, [wPerfChannelState + $1]                ; $4DAB
    and $01                                       ; $4DAE
    jr nz, jr_005_4dbf                            ; $4DB0

    ld c, $05                                     ; $4DB2
    jr jr_005_4dbf                                ; $4DB4

jr_005_4db6:
    ld a, [wPerfChannelState + $2]                ; $4DB6
    and $01                                       ; $4DB9
    jr nz, jr_005_4dbf                            ; $4DBB

    ld c, $05                                     ; $4DBD

jr_005_4dbf:
    pop hl                                        ; $4DBF
    add hl, bc                                    ; $4DC0
    ld de, wAnimSlotFrame + $2                    ; $4DC1
    ld b, $01                                     ; $4DC4
    call DjPerf_Animator                          ; $4DC6
    ret                                           ; $4DC9


; C: auto: 45 bytes, bytes; referenced by DjPerf_AnimateControlCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_AnimateControlCursor_Tbl4DCA::
    db $05, $09, $12, $1b, $24, $0e, $13, $01, $90, $02, $13, $16, $29, $90, $02, $16
    db $19, $21, $90, $02, $13, $16, $49, $90, $02, $16, $19, $41, $90, $02, $13, $16
    db $69, $90, $02, $16, $19, $61, $90, $02, $0e, $13, $91, $90, $02

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_UpdatePose::
    ld a, [wPerformerTilesShown]                  ; $4DF7
    cp $e9                                        ; $4DFA
    jr nc, jr_005_4e12                            ; $4DFC

    cp $df                                        ; $4DFE
    jr c, jr_005_4e0c                             ; $4E00

    cp $e3                                        ; $4E02
    jr nc, jr_005_4e0c                            ; $4E04

    ld a, $02                                     ; $4E06
    ld [wPerformerPose], a                        ; $4E08
    ret                                           ; $4E0B


jr_005_4e0c:
    ld a, $01                                     ; $4E0C
    ld [wPerformerPose], a                        ; $4E0E
    ret                                           ; $4E11


jr_005_4e12:
    ld a, [wTickFlag]                             ; $4E12
    ld hl, wPerformerBeatAcc                      ; $4E15
    add [hl]                                      ; $4E18
    and $07                                       ; $4E19
    ld [hl], a                                    ; $4E1B
    srl a                                         ; $4E1C
    ld c, a                                       ; $4E1E
    ld b, $00                                     ; $4E1F
    ld hl, DjPerf_UpdatePose_Tbl4E2A              ; $4E21
    add hl, bc                                    ; $4E24
    ld a, [hl]                                    ; $4E25
    ld [wPerformerPose], a                        ; $4E26
    ret                                           ; $4E29


; C: auto: 4 bytes, bytes; referenced by DjPerf_UpdatePose. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_UpdatePose_Tbl4E2A::
    db $00, $01, $02, $01

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_ScrollPerformer::
    ld a, [wPerformerPose]                        ; $4E2E
    sla a                                         ; $4E31
    ld c, a                                       ; $4E33
    ld b, $00                                     ; $4E34
    ld hl, DjPerf_ScrollPerformer_Tbl4E41         ; $4E36
    add hl, bc                                    ; $4E39
    ld a, [hl+]                                   ; $4E3A
    ldh [hScxBand1], a                            ; $4E3B
    ld a, [hl]                                    ; $4E3D
    ldh [hScyBand2], a                            ; $4E3E
    ret                                           ; $4E40


; C: auto: 6 bytes, bytes; referenced by DjPerf_ScrollPerformer. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_ScrollPerformer_Tbl4E41::
    db $08, $88, $00, $30, $f8, $70

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_StepBeatPhase::
    ld a, [wPerformerPose]                        ; $4E47
    ld c, a                                       ; $4E4A
    ld b, $00                                     ; $4E4B
    ld hl, DjPerf_StepBeatPhase_Tbl4E9F           ; $4E4D
    add hl, bc                                    ; $4E50
    ld a, [hl]                                    ; $4E51
    ld [wPerformerBounceCounter], a               ; $4E52
    ld a, [wPerformerScriptId]                    ; $4E55
    cp $08                                        ; $4E58
    jr nz, jr_005_4e62                            ; $4E5A

    ld a, $02                                     ; $4E5C
    ld [wPerformerFrameGroup], a                  ; $4E5E
    ret                                           ; $4E61


jr_005_4e62:
    ld a, [wPerfChannelState + $2]                ; $4E62
    and a                                         ; $4E65
    ret z                                         ; $4E66

    ld a, [wNoisePlayStep]                        ; $4E67
    ld c, a                                       ; $4E6A
    ld b, $00                                     ; $4E6B
    ld hl, wNoiseNotes                            ; $4E6D
    add hl, bc                                    ; $4E70
    ld a, [hl]                                    ; $4E71
    and a                                         ; $4E72
    jr z, jr_005_4e80                             ; $4E73

jr_005_4e75:
    cp $06                                        ; $4E75
    jr c, jr_005_4e7d                             ; $4E77

    sub $06                                       ; $4E79
    jr jr_005_4e75                                ; $4E7B

jr_005_4e7d:
    ld [wPerformerBeatPhase], a                   ; $4E7D

jr_005_4e80:
    ld a, [wPerformerBeatPhase]                   ; $4E80
    sla a                                         ; $4E83
    ld c, a                                       ; $4E85
    ld a, [wPerformerPose]                        ; $4E86
    and $01                                       ; $4E89
    add c                                         ; $4E8B
    ld c, a                                       ; $4E8C
    ld b, $00                                     ; $4E8D
    ld hl, DjPerf_StepBeatPhase_Tbl4EA2           ; $4E8F
    add hl, bc                                    ; $4E92
    ld a, [hl]                                    ; $4E93
    ld [wPerformerFrameGroup], a                  ; $4E94
    ld a, [wPerformerBounceCounter]               ; $4E97
    dec a                                         ; $4E9A
    ld [wPerformerBounceCounter], a               ; $4E9B
    ret                                           ; $4E9E


; C: auto: 3 bytes, bytes; referenced by DjPerf_StepBeatPhase. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_StepBeatPhase_Tbl4E9F::
    db $01, $04, $01

; C: auto: 12 bytes, bytes; referenced by DjPerf_StepBeatPhase. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_StepBeatPhase_Tbl4EA2::
    db $00, $01, $01, $02, $02, $00, $01, $00, $02, $01, $00, $02

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_BounceOffset::
    ld a, [wPerformerFrameGroup]                  ; $4EAE
    ld c, a                                       ; $4EB1
    ld b, $00                                     ; $4EB2
    ld hl, DjPerf_BounceOffset_Tbl4EBF            ; $4EB4
    add hl, bc                                    ; $4EB7
    ld a, [wPerformerBounceCounter]               ; $4EB8
    add [hl]                                      ; $4EBB
    ldh [hScyBand1], a                            ; $4EBC
    ret                                           ; $4EBE


; C: auto: 3 bytes, bytes; referenced by DjPerf_BounceOffset. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_BounceOffset_Tbl4EBF::
    db $00, $48, $90

; C: runs the performer animation script ids 0..8
DjPerf_PerformerScript::
    xor a                                         ; $4EC2
    ld [wPerformerSpeakingIcon], a                ; $4EC3
    ld a, [wPerformerScriptId]                    ; $4EC6
    and a                                         ; $4EC9
    jr z, jr_005_4ef5                             ; $4ECA

    cp $01                                        ; $4ECC
    jp z, DjPerf_PerformerScript_Id1              ; $4ECE

    cp $02                                        ; $4ED1
    jp z, DjPerf_PerformerScript_Id2              ; $4ED3

    cp $03                                        ; $4ED6
    jp z, DjPerf_PerformerScript_Id3              ; $4ED8

    cp $04                                        ; $4EDB
    jp z, DjPerf_PerformerScript_Id4              ; $4EDD

    cp $05                                        ; $4EE0
    jp z, DjPerf_PerformerScript_Id5              ; $4EE2

    cp $06                                        ; $4EE5
    jp z, DjPerf_PerformerScript_Id6              ; $4EE7

    cp $07                                        ; $4EEA
    jp z, DjPerf_PerformerScript_Id7              ; $4EEC

    cp $08                                        ; $4EEF
    jp z, DjPerf_PerformerScript_Id8              ; $4EF1

    ret                                           ; $4EF4


jr_005_4ef5:
    ld a, [wPerfChannelState + $1]                ; $4EF5
    and a                                         ; $4EF8
    jr z, jr_005_4f09                             ; $4EF9

    ld a, [wSound2PlayStep]                       ; $4EFB
    ld c, a                                       ; $4EFE
    ld b, $00                                     ; $4EFF
    ld hl, wSound2Notes                           ; $4F01
    add hl, bc                                    ; $4F04
    ld a, [hl]                                    ; $4F05
    and a                                         ; $4F06
    jr nz, jr_005_4f21                            ; $4F07

jr_005_4f09:
    ld a, [wPerfChannelState]                     ; $4F09
    and a                                         ; $4F0C
    jr z, jr_005_4f1d                             ; $4F0D

    ld a, [wSound1PlayStep]                       ; $4F0F
    ld c, a                                       ; $4F12
    ld b, $00                                     ; $4F13
    ld hl, wSound1Notes                           ; $4F15
    add hl, bc                                    ; $4F18
    ld a, [hl]                                    ; $4F19
    and a                                         ; $4F1A
    jr nz, jr_005_4f21                            ; $4F1B

jr_005_4f1d:
    ld a, $0c                                     ; $4F1D
    jr jr_005_4f2a                                ; $4F1F

jr_005_4f21:
    dec a                                         ; $4F21

jr_005_4f22:
    cp $0c                                        ; $4F22
    jr c, jr_005_4f2a                             ; $4F24

    sub $0c                                       ; $4F26
    jr jr_005_4f22                                ; $4F28

jr_005_4f2a:
    ld c, a                                       ; $4F2A
    sla a                                         ; $4F2B
    add c                                         ; $4F2D
    ld hl, wPerformerPose                         ; $4F2E
    add [hl]                                      ; $4F31
    sla a                                         ; $4F32
    ld c, a                                       ; $4F34
    ld b, $00                                     ; $4F35
    ld hl, DjPerf_PerformerScript_Tbl4F48         ; $4F37
    add hl, bc                                    ; $4F3A
    ld a, [hl+]                                   ; $4F3B
    add $e9                                       ; $4F3C
    ld [wPerformerTilesTarget], a                 ; $4F3E
    ld a, [hl]                                    ; $4F41
    add $ea                                       ; $4F42
    ld [wPerformerTilesTarget2], a                ; $4F44
    ret                                           ; $4F47


; C: auto: 78 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F
; 20)
DjPerf_PerformerScript_Tbl4F48::
    db $06, $02, $02, $02, $02, $06, $06, $00, $06, $06, $00, $06, $08, $02, $08, $08
    db $02, $08, $04, $0a, $0a, $0a, $0a, $04, $04, $06, $04, $04, $06, $04, $02, $00
    db $00, $00, $00, $02, $04, $02, $04, $04, $02, $04, $0a, $08, $08, $08, $08, $0a
    db $08, $06, $06, $06, $06, $08, $00, $04, $00, $00, $04, $00, $0a, $06, $0a, $0a
    db $0a, $06, $06, $02, $02, $08, $0a, $06, $04, $06, $04, $04, $06, $04

; C: case 1 of the performer script dispatch (script id in $D897 = 1) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id1::
    ld a, [wAnimSlotDone + $3]                    ; $4F96
    and a                                         ; $4F99
    jr z, jr_005_4fa4                             ; $4F9A

    xor a                                         ; $4F9C
    ld [wPerformerScriptId], a                    ; $4F9D
    ld [wAnimSlotDone + $3], a                    ; $4FA0
    ret                                           ; $4FA3


jr_005_4fa4:
    ld hl, DjPerf_PerformerScript_Tbl4FB0         ; $4FA4
    ld de, wAnimSlotFrame + $3                    ; $4FA7
    ld b, $01                                     ; $4FAA
    call DjPerf_Animator                          ; $4FAC
    ret                                           ; $4FAF


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl4FB0::
    db $19, $1c, $50, $60, $03

; C: case 2 of the performer script dispatch (script id in $D897 = 2) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id2::
    ld a, [wAnimSlotDone + $3]                    ; $4FB5
    and a                                         ; $4FB8
    jr z, jr_005_4fc3                             ; $4FB9

    xor a                                         ; $4FBB
    ld [wPerformerScriptId], a                    ; $4FBC
    ld [wAnimSlotDone + $3], a                    ; $4FBF
    ret                                           ; $4FC2


jr_005_4fc3:
    ld hl, DjPerf_PerformerScript_Tbl4FCF         ; $4FC3
    ld de, wAnimSlotFrame + $3                    ; $4FC6
    ld b, $01                                     ; $4FC9
    call DjPerf_Animator                          ; $4FCB
    ret                                           ; $4FCE


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 3, same layout as the
; scripts BGB ran (Tbl5006, Tbl50D3)
DjPerf_PerformerScript_Tbl4FCF::
    db $22, $25, $50, $60, $03

; C: case 3 of the performer script dispatch (script id in $D897 = 3) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id3::
    ld a, [wAnimSlotDone + $3]                    ; $4FD4
    and a                                         ; $4FD7
    jr z, jr_005_4fe2                             ; $4FD8

    xor a                                         ; $4FDA
    ld [wPerformerScriptId], a                    ; $4FDB
    ld [wAnimSlotDone + $3], a                    ; $4FDE
    ret                                           ; $4FE1


jr_005_4fe2:
    ld hl, DjPerf_PerformerScript_Tbl4FEE         ; $4FE2
    ld de, wAnimSlotFrame + $3                    ; $4FE5
    ld b, $01                                     ; $4FE8
    call DjPerf_Animator                          ; $4FEA
    ret                                           ; $4FED


; C: auto: 4 bytes, bytes; referenced by DjPerf_PerformerScript | 5 bytes 22 25 50 60 03 (the last one was cut off by
; a false label at 5048 = `ld bc,$5048` in Ball_DrawPauseText, a sprite position); the code of DjPerf_PerformerScript
; starts at 5049. L3 pass 2026-10-26: no organic run reached it (BGB ...
DjPerf_PerformerScript_Tbl4FEE::
    db $22, $25, $50, $60, $03

; C: case 4 of the performer script dispatch (script id in $D897 = 4) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id4::
    ld a, [wAnimSlotDone + $3]                    ; $4FF3
    and a                                         ; $4FF6
    jr z, jr_005_5001                             ; $4FF7

    xor a                                         ; $4FF9
    ld [wPerformerScriptId], a                    ; $4FFA
    ld [wAnimSlotDone + $3], a                    ; $4FFD
    ret                                           ; $5000


jr_005_5001:
    ld hl, DjPerf_PerformerScript_Tbl500D         ; $5001
    ld de, wAnimSlotFrame + $3                    ; $5004
    ld b, $01                                     ; $5007
    call DjPerf_Animator                          ; $5009
    ret                                           ; $500C


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 5, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl500D::
    db $22, $25, $50, $60, $03

; C: case 5 of the performer script dispatch (script id in $D897 = 5) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id5::
    ld a, [wAnimSlotDone + $3]                    ; $5012
    and a                                         ; $5015
    jr z, jr_005_5020                             ; $5016

    xor a                                         ; $5018
    ld [wPerformerScriptId], a                    ; $5019
    ld [wAnimSlotDone + $3], a                    ; $501C
    ret                                           ; $501F


jr_005_5020:
    ld hl, DjPerf_PerformerScript_Tbl502C         ; $5020
    ld de, wAnimSlotFrame + $3                    ; $5023
    ld b, $01                                     ; $5026
    call DjPerf_Animator                          ; $5028
    ret                                           ; $502B


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 6, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl502C::
    db $25, $28, $50, $60, $03

; C: case 6 of the performer script dispatch (script id in $D897 = 6): sets $D8B8 = 1 and runs the longer step with
; the $D8A6 counter (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id6::
    ld a, $01                                     ; $5031
    ld [wPerformerSpeakingIcon], a                ; $5033
    ld a, [wAnimSlotFrame + $3]                   ; $5036
    cp $20                                        ; $5039
    jr nc, jr_005_5063                            ; $503B

    ld a, [wAnimSlotDone + $3]                    ; $503D
    and a                                         ; $5040
    jr z, jr_005_5057                             ; $5041

    ldh a, [hKeysHeld]                            ; $5043
    bit PADB_A, a                                 ; $5045
    jr nz, jr_005_5057                            ; $5047

    ld a, $20                                     ; $5049
    ld [wAnimSlotFrame + $3], a                   ; $504B
    xor a                                         ; $504E
    ld [wAnimSlotTimer + $3], a                   ; $504F
    ld [wAnimSlotDone + $3], a                    ; $5052
    jr jr_005_5063                                ; $5055

jr_005_5057:
    ld hl, DjPerf_PerformerScript_Tbl507D         ; $5057
    ld de, wAnimSlotFrame + $3                    ; $505A
    ld b, $01                                     ; $505D
    call DjPerf_Animator                          ; $505F
    ret                                           ; $5062


jr_005_5063:
    ld a, [wAnimSlotDone + $3]                    ; $5063
    and a                                         ; $5066
    jr z, jr_005_5071                             ; $5067

    xor a                                         ; $5069
    ld [wPerformerScriptId], a                    ; $506A
    ld [wAnimSlotDone + $3], a                    ; $506D
    ret                                           ; $5070


jr_005_5071:
    ld hl, DjPerf_PerformerScript_Tbl5082         ; $5071
    ld de, wAnimSlotFrame + $3                    ; $5074
    ld b, $01                                     ; $5077
    call DjPerf_Animator                          ; $5079
    ret                                           ; $507C


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl507D::
    db $1c, $20, $50, $60, $03

; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_PerformerScript_Tbl5082::
    db $20, $22, $50, $60, $03

; C: case 7 of the performer script dispatch (script id in $D897 = 7) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id7::
    ld a, [wAnimSlotDone + $3]                    ; $5087
    and a                                         ; $508A
    jr z, jr_005_509b                             ; $508B

    xor a                                         ; $508D
    ld [wPerformerScriptId], a                    ; $508E
    ld [wAnimSlotDone + $3], a                    ; $5091
    ld a, [wPerfPaused]                           ; $5094
    ld [wPerfPausedIcon], a                       ; $5097
    ret                                           ; $509A


jr_005_509b:
    ld hl, DjPerf_PerformerScript_Tbl50A7         ; $509B
    ld de, wAnimSlotFrame + $3                    ; $509E
    ld b, $01                                     ; $50A1
    call DjPerf_Animator                          ; $50A3
    ret                                           ; $50A6


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 7, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl50A7::
    db $28, $2b, $50, $60, $03

; C: case 8 of the performer script dispatch (script id in $D897 = 8) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id8::
    ld a, [wAnimSlotDone + $3]                    ; $50AC
    and a                                         ; $50AF
    jr z, jr_005_50be                             ; $50B0

    xor a                                         ; $50B2
    ld [wPerformerScriptId], a                    ; $50B3
    ld [wAnimSlotDone + $3], a                    ; $50B6
    next_state                                    ; $50B9
    ret                                           ; $50BD


jr_005_50be:
    ld hl, DjPerf_PerformerScript_Tbl50CA         ; $50BE
    ld de, wAnimSlotFrame + $3                    ; $50C1
    ld b, $01                                     ; $50C4
    call DjPerf_Animator                          ; $50C6
    ret                                           ; $50C9


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl50CA::
    db $2b, $2e, $50, $60, $03

; C: performer sprite tile change at most every 4 frames
DjPerf_UpdatePerformerTiles::
    ld a, [wPerformerUpdateFrames]                ; $50CF
    inc a                                         ; $50D2
    ld [wPerformerUpdateFrames], a                ; $50D3
    ld hl, wPerformerTilesShown                   ; $50D6
    ld a, [wPerformerTilesTarget]                 ; $50D9
    cp [hl]                                       ; $50DC
    jr z, jr_005_50f4                             ; $50DD

    ld a, [wPerformerUpdateFrames]                ; $50DF
    cp $04                                        ; $50E2
    jr c, jr_005_50f4                             ; $50E4

    ld a, [wPerformerTilesTarget]                 ; $50E6
    ld [hl], a                                    ; $50E9
    ld a, [wPerformerTilesTarget2]                ; $50EA
    ld [wPerformerTilesShown2], a                 ; $50ED
    xor a                                         ; $50F0
    ld [wPerformerUpdateFrames], a                ; $50F1

jr_005_50f4:
    ld a, [wPerformerTilesShown]                  ; $50F4
    cp $e9                                        ; $50F7
    jr nc, jr_005_510b                            ; $50F9

    ld a, $50                                     ; $50FB
    ld hl, hScxBand1                              ; $50FD
    sub [hl]                                      ; $5100
    ld b, a                                       ; $5101
    ld c, $61                                     ; $5102
    ld a, [wPerformerTilesShown]                  ; $5104
    call Oam_AddMeta_B01_5D2B                     ; $5107
    ret                                           ; $510A


jr_005_510b:
    ld a, $50                                     ; $510B
    ld hl, hScxBand1                              ; $510D
    sub [hl]                                      ; $5110
    ld b, a                                       ; $5111
    ld c, $81                                     ; $5112
    ld a, [wPerformerTilesShown]                  ; $5114
    call Oam_AddMeta_B01_5D2B                     ; $5117
    ld a, [wPerformerTilesShown2]                 ; $511A
    call Oam_AddMeta_B01_5D2B                     ; $511D
    ret                                           ; $5120


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_AnimateSpeakerBlink::
    ldh a, [rNR52]                                ; $5121
    bit 0, a                                      ; $5123
    jr z, jr_005_5146                             ; $5125

    ldh a, [rNR12]                                ; $5127
    and $f0                                       ; $5129
    jr z, jr_005_5146                             ; $512B

    ld a, [wAnimSlotFrame]                        ; $512D
    cp $2e                                        ; $5130
    jr nc, jr_005_513a                            ; $5132

    cpl                                           ; $5134
    add $36                                       ; $5135
    ld [wAnimSlotFrame], a                        ; $5137

jr_005_513a:
    ld hl, DjPerf_AnimateSpeakerBlink_Tbl515F     ; $513A
    ld de, wAnimSlotFrame                         ; $513D
    ld b, $02                                     ; $5140
    call DjPerf_Animator                          ; $5142
    ret                                           ; $5145


jr_005_5146:
    ld a, [wAnimSlotFrame]                        ; $5146
    cp $2e                                        ; $5149
    jr c, jr_005_5153                             ; $514B

    cpl                                           ; $514D
    add $36                                       ; $514E
    ld [wAnimSlotFrame], a                        ; $5150

jr_005_5153:
    ld hl, DjPerf_AnimateSpeakerBlink_Tbl5169     ; $5153
    ld de, wAnimSlotFrame                         ; $5156
    ld b, $02                                     ; $5159
    call DjPerf_Animator                          ; $515B
    ret                                           ; $515E


; C: auto: 10 bytes, bytes; referenced by DjPerf_AnimateSpeakerBlink. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_AnimateSpeakerBlink_Tbl515F::
    db $2e, $37, $78, $73, $00, $09, $0e, $80, $7a, $01

; C: auto: 10 bytes, bytes; referenced by DjPerf_AnimateSpeakerBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_AnimateSpeakerBlink_Tbl5169::
    db $00, $09, $78, $73, $00, $09, $0e, $80, $7a, $01

; I: equaliser animation phase built in D000..D013
DjPerf_Equaliser::
    farcopy Mem_CopyFromBank, Src_20_7F00_DjPerf_Equaliser, wBgRowBuffer, $0014 ; $5173
    ld a, [wTickFlag]                             ; $5181
    ld hl, wPerfEqualiserPhase                    ; $5184
    add [hl]                                      ; $5187
    and $03                                       ; $5188
    ld [hl], a                                    ; $518A
    jr nz, jr_005_5196                            ; $518B

    ld hl, DjPerf_Equaliser_PtrTbl521E            ; $518D
    ld de, wBgRowBuffer                           ; $5190
    call DjPerf_CopyEqualiserRow                  ; $5193

jr_005_5196:
    ld a, [wPerfChannelState]                     ; $5196
    and a                                         ; $5199
    jr z, jr_005_51b3                             ; $519A

    ld a, [wSound1PlayStep]                       ; $519C
    ld c, a                                       ; $519F
    ld b, $00                                     ; $51A0
    ld hl, wSound1Notes                           ; $51A2
    add hl, bc                                    ; $51A5
    ld a, [hl]                                    ; $51A6
    and a                                         ; $51A7
    jr z, jr_005_51b3                             ; $51A8

    ld hl, DjPerf_Equaliser_PtrTbl5222            ; $51AA
    ld de, wBgRowBuffer + $4                      ; $51AD
    call DjPerf_CopyEqualiserRow                  ; $51B0

jr_005_51b3:
    ld a, [wPerfChannelState + $1]                ; $51B3
    and a                                         ; $51B6
    jr z, jr_005_51d0                             ; $51B7

    ld a, [wSound2PlayStep]                       ; $51B9
    ld c, a                                       ; $51BC
    ld b, $00                                     ; $51BD
    ld hl, wSound2Notes                           ; $51BF
    add hl, bc                                    ; $51C2
    ld a, [hl]                                    ; $51C3
    and a                                         ; $51C4
    jr z, jr_005_51d0                             ; $51C5

    ld hl, DjPerf_Equaliser_Tbl5226               ; $51C7
    ld de, wBgRowBuffer + $8                      ; $51CA
    call DjPerf_CopyEqualiserRow                  ; $51CD

jr_005_51d0:
    ld a, [wPerfChannelState + $2]                ; $51D0
    and a                                         ; $51D3
    jr z, jr_005_51ed                             ; $51D4

    ld a, [wNoisePlayStep]                        ; $51D6
    ld c, a                                       ; $51D9
    ld b, $00                                     ; $51DA
    ld hl, wNoiseNotes                            ; $51DC
    add hl, bc                                    ; $51DF
    ld a, [hl]                                    ; $51E0
    and a                                         ; $51E1
    jr z, jr_005_51ed                             ; $51E2

    ld hl, DjPerf_Equaliser_Tbl522A               ; $51E4
    ld de, wBgRowBuffer + $c                      ; $51E7
    call DjPerf_CopyEqualiserRow                  ; $51EA

jr_005_51ed:
    ldh a, [rNR52]                                ; $51ED
    bit 0, a                                      ; $51EF
    jr z, jr_005_5202                             ; $51F1

    ldh a, [rNR12]                                ; $51F3
    and $f0                                       ; $51F5
    jr z, jr_005_5202                             ; $51F7

    ld hl, DjPerf_Equaliser_Map522E               ; $51F9
    ld de, wBgRowBuffer + $10                     ; $51FC
    call DjPerf_CopyEqualiserRow                  ; $51FF

jr_005_5202:
    ld a, $00                                     ; $5202
    ld hl, wBgRowBuffer                           ; $5204
    ld de, $9ec0                                  ; $5207
    ld bc, $0014                                  ; $520A
    call Vram_CopyFromBank                        ; $520D
    ret                                           ; $5210


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_CopyEqualiserRow::
    REPT 4                                        ; $5211
        ld a, [hl+]
        ld [de], a
        inc e
    ENDR                                         ; 4 copies of 3 bytes
    ret                                           ; $521D


; C: auto: 4 bytes, word table; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_Equaliser_PtrTbl521E::
    dw $4140
    dw $4342

; C: auto: 4 bytes, word table; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_PtrTbl5222::
    dw $5150
    dw $5352

; C: auto: 4 bytes, bytes; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Tbl5226::
    db $50, $51, $52, $20

; C: auto: 4 bytes, bytes; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Tbl522A::
    db $1c, $1d, $24, $2d

; C: auto: 4 bytes, tile map; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Map522E::
    db $14, $15, $6e, $6e

; C
DjPerf_DrawPlayIcon::
    ld a, [wPerfPausedIcon]                       ; $5232
    and a                                         ; $5235
    jr nz, jr_005_5241                            ; $5236

    ld bc, $3d81                                  ; $5238
    ld a, $d1                                     ; $523B
    call Oam_AddMeta_B01_5D2B                     ; $523D
    ret                                           ; $5240


jr_005_5241:
    ld bc, $3f78                                  ; $5241
    ld a, $d1                                     ; $5244
    call Oam_AddMeta_B01_5D2B                     ; $5246
    ret                                           ; $5249


; C
DjPerf_DrawTempoNeedle::
    ld a, [wPerfTempoAtRelease]                   ; $524A
    sub $3c                                       ; $524D
    ld l, $e3                                     ; $524F
    call Math_MulAL                               ; $5251
    ld bc, $0080                                  ; $5254
    add hl, bc                                    ; $5257
    ld a, h                                       ; $5258
    swap a                                        ; $5259
    and $0f                                       ; $525B
    add $76                                       ; $525D
    push af                                       ; $525F
    ld a, [wPerfTempoAtRelease]                   ; $5260
    sub $3c                                       ; $5263
    ld l, $5b                                     ; $5265
    call Math_MulAL                               ; $5267
    ld bc, $0080                                  ; $526A
    add hl, bc                                    ; $526D
    ld a, h                                       ; $526E
    swap a                                        ; $526F
    and $0f                                       ; $5271
    cpl                                           ; $5273
    add $2d                                       ; $5274
    ld b, a                                       ; $5276
    pop af                                        ; $5277
    ld c, a                                       ; $5278
    ld a, $d1                                     ; $5279
    call Oam_AddMeta_B01_5D2B                     ; $527B
    ret                                           ; $527E


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_DrawSpeakingIcon::
    ld a, [wPerformerSpeakingIcon]                ; $527F
    and a                                         ; $5282
    jr nz, jr_005_528e                            ; $5283

    ld bc, $4871                                  ; $5285
    ld a, $d2                                     ; $5288
    call Oam_AddMeta_B01_5D2B                     ; $528A
    ret                                           ; $528D


jr_005_528e:
    ld bc, $5471                                  ; $528E
    ld a, $d2                                     ; $5291
    call Oam_AddMeta_B01_5D2B                     ; $5293
    ret                                           ; $5296


; C
DjPerf_DrawLevelSlider::
    ld a, [wPerfLevelAtRelease]                   ; $5297
    add $78                                       ; $529A
    ld c, a                                       ; $529C
    ld b, $57                                     ; $529D
    ld a, $d1                                     ; $529F
    call Oam_AddMeta_B01_5D2B                     ; $52A1
    ret                                           ; $52A4


; C: animation slot stepper
DjPerf_Animator::
    push bc                                       ; $52A5
    push de                                       ; $52A6
    ld a, [de]                                    ; $52A7
    cp [hl]                                       ; $52A8
    jr c, jr_005_52b0                             ; $52A9

    inc hl                                        ; $52AB
    cp [hl]                                       ; $52AC
    jr c, jr_005_52b3                             ; $52AD

    dec hl                                        ; $52AF

jr_005_52b0:
    ld a, [hl]                                    ; $52B0
    ld [de], a                                    ; $52B1
    inc hl                                        ; $52B2

jr_005_52b3:
    inc hl                                        ; $52B3
    ld a, e                                       ; $52B4
    add $04                                       ; $52B5
    ld e, a                                       ; $52B7
    jr nc, jr_005_52bb                            ; $52B8

    inc d                                         ; $52BA

jr_005_52bb:
    ld a, [hl+]                                   ; $52BB
    ld [de], a                                    ; $52BC
    ld a, e                                       ; $52BD
    add $04                                       ; $52BE
    ld e, a                                       ; $52C0
    jr nc, jr_005_52c4                            ; $52C1

    inc d                                         ; $52C3

jr_005_52c4:
    ld a, [hl+]                                   ; $52C4
    ld [de], a                                    ; $52C5
    push hl                                       ; $52C6
    ld e, [hl]                                    ; $52C7
    call DjPerf_AnimatorDraw                      ; $52C8
    pop hl                                        ; $52CB
    pop de                                        ; $52CC
    pop bc                                        ; $52CD
    inc hl                                        ; $52CE
    inc de                                        ; $52CF
    dec b                                         ; $52D0
    jr nz, DjPerf_Animator                        ; $52D1

    ret                                           ; $52D3


; C: draws one animation slot
DjPerf_AnimatorDraw::
    ld d, $00                                     ; $52D4
    ld hl, wAnimSlotDone                          ; $52D6
    add hl, de                                    ; $52D9
    ld [hl], $00                                  ; $52DA
    ld hl, wAnimSlotFrame                         ; $52DC
    add hl, de                                    ; $52DF
    ld a, [hl]                                    ; $52E0
    sla a                                         ; $52E1
    ld c, a                                       ; $52E3
    ld b, $00                                     ; $52E4
    ld hl, DjPerf_AnimatorDraw_Tbl532B            ; $52E6
    add hl, bc                                    ; $52E9
    ld a, [hl+]                                   ; $52EA
    push hl                                       ; $52EB
    ld hl, wAnimSlotX                             ; $52EC
    add hl, de                                    ; $52EF
    ld b, [hl]                                    ; $52F0
    ld hl, wAnimSlotY                             ; $52F1
    add hl, de                                    ; $52F4
    ld c, [hl]                                    ; $52F5
    cp $dd                                        ; $52F6
    jr nc, jr_005_52ff                            ; $52F8

    call Oam_AddMeta_B01_5D2B                     ; $52FA
    jr jr_005_5302                                ; $52FD

jr_005_52ff:
    ld [wPerformerTilesTarget], a                 ; $52FF

jr_005_5302:
    ld hl, wAnimSlotTimer                         ; $5302
    add hl, de                                    ; $5305
    ld a, [hl]                                    ; $5306
    pop hl                                        ; $5307
    cp [hl]                                       ; $5308
    jr c, jr_005_5324                             ; $5309

    inc hl                                        ; $530B
    ld a, [hl+]                                   ; $530C
    cp $ff                                        ; $530D
    ld a, [hl]                                    ; $530F
    ld hl, wAnimSlotFrame                         ; $5310
    add hl, de                                    ; $5313
    jr z, jr_005_531c                             ; $5314

    ld a, [hl]                                    ; $5316
    inc a                                         ; $5317
    ld [hl], a                                    ; $5318
    xor a                                         ; $5319
    jr jr_005_5324                                ; $531A

jr_005_531c:
    ld [hl], a                                    ; $531C
    ld hl, wAnimSlotDone                          ; $531D
    add hl, de                                    ; $5320
    ld [hl], $01                                  ; $5321
    xor a                                         ; $5323

jr_005_5324:
    inc a                                         ; $5324
    ld hl, wAnimSlotTimer                         ; $5325
    add hl, de                                    ; $5328
    ld [hl], a                                    ; $5329
    ret                                           ; $532A


; C: auto: 110 bytes, bytes; referenced by DjPerf_AnimatorDraw. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F
; 20)
DjPerf_AnimatorDraw_Tbl532B::
    db $c9, $0a, $ca, $08, $cb, $08, $cc, $0a, $cd, $0a, $ce, $08, $cf, $08, $d0, $0a
    db $ff, $00, $d3, $0a, $d4, $08, $d3, $08, $d4, $0a, $ff, $09, $da, $0a, $db, $0a
    db $da, $0a, $dc, $0a, $ff, $0e, $da, $0a, $db, $0a, $ff, $13, $da, $0a, $dc, $0a
    db $ff, $16, $dd, $08, $de, $08, $ff, $1a, $df, $05, $e0, $04, $e1, $07, $ff, $1d
    db $e2, $04, $ff, $20, $e3, $08, $e4, $08, $ff, $23, $e3, $08, $e5, $08, $ff, $26
    db $e3, $08, $e6, $08, $ff, $29, $e7, $0b, $e8, $0b, $ff, $2c, $d0, $0a, $cf, $08
    db $ce, $08, $cd, $0a, $cc, $0a, $cb, $08, $ca, $08, $c9, $0a, $ff, $2e

; C: performance screen control: tempo / channels / level; Start; A; B; Left / Right pitch
DjPerf_Input::
    ld a, $01                                     ; $5399
    ld [wPerfStepIncrement], a                    ; $539B
    ldh a, [hKeysHeld]                            ; $539E
    bit PADB_RIGHT, a                             ; $53A0
    jr nz, jr_005_53b5                            ; $53A2

    ld a, [wPerfPitchShift]                       ; $53A4
    and a                                         ; $53A7
    jr z, jr_005_53b5                             ; $53A8

    bit 7, a                                      ; $53AA
    jr nz, jr_005_53b1                            ; $53AC

    dec a                                         ; $53AE
    jr jr_005_53b2                                ; $53AF

jr_005_53b1:
    inc a                                         ; $53B1

jr_005_53b2:
    ld [wPerfPitchShift], a                       ; $53B2

jr_005_53b5:
    ldh a, [hKeysHeld]                            ; $53B5
    and PADF_RIGHT | PADF_LEFT                    ; $53B7
    jr z, jr_005_5421                             ; $53B9

    ld a, [wPerfControlCursor]                    ; $53BB
    and a                                         ; $53BE
    jr nz, jr_005_53cd                            ; $53BF

    ldh a, [hKeysHeld]                            ; $53C1
    bit PADB_LEFT, a                              ; $53C3
    jr z, jr_005_53cd                             ; $53C5

    ld a, $ff                                     ; $53C7
    ld [wPerfStepIncrement], a                    ; $53C9
    ret                                           ; $53CC


jr_005_53cd:
    ld a, [wPerfControlCursor]                    ; $53CD
    cp $04                                        ; $53D0
    jr nz, jr_005_5411                            ; $53D2

    ldh a, [hKeysHeld]                            ; $53D4
    bit PADB_UP, a                                ; $53D6
    jr nz, jr_005_53ef                            ; $53D8

    bit PADB_DOWN, a                              ; $53DA
    jr nz, jr_005_5400                            ; $53DC

    ldh a, [hKeysNew]                             ; $53DE
    bit PADB_RIGHT, a                             ; $53E0
    jr z, jr_005_5411                             ; $53E2

    xor a                                         ; $53E4
    ld [wSound1PlayStep], a                       ; $53E5
    ld [wSound2PlayStep], a                       ; $53E8
    ld [wNoisePlayStep], a                        ; $53EB
    ret                                           ; $53EE


jr_005_53ef:
    ldh a, [hKeysHeld]                            ; $53EF
    bit PADB_RIGHT, a                             ; $53F1
    jr z, jr_005_5411                             ; $53F3

    ld a, [wPerfPitchShift]                       ; $53F5
    inc a                                         ; $53F8
    cp $0c                                        ; $53F9
    ret z                                         ; $53FB

    ld [wPerfPitchShift], a                       ; $53FC
    ret                                           ; $53FF


jr_005_5400:
    ldh a, [hKeysHeld]                            ; $5400
    bit PADB_RIGHT, a                             ; $5402
    jr z, jr_005_5411                             ; $5404

    ld a, [wPerfPitchShift]                       ; $5406
    dec a                                         ; $5409
    cp $f4                                        ; $540A
    ret z                                         ; $540C

    ld [wPerfPitchShift], a                       ; $540D
    ret                                           ; $5410


jr_005_5411:
    ld a, [wPerfControlCursor]                    ; $5411
    ld bc, $0004                                  ; $5414
    call DjEd_StepLeftRight                       ; $5417
    ld hl, wPerfControlCursor                     ; $541A
    cp [hl]                                       ; $541D
    ret z                                         ; $541E

    ld [hl], a                                    ; $541F
    ret                                           ; $5420


jr_005_5421:
    ldh a, [hKeysNew]                             ; $5421
    bit PADB_A, a                                 ; $5423
    jr z, jr_005_5449                             ; $5425

    ld a, [wPerfLevel]                            ; $5427
    ld hl, DjPerf_Input_Tbl54F7                   ; $542A
    call Snd_PlayFromList                         ; $542D
    ld a, $01                                     ; $5430
    ld [wPerformerSpeakingIcon], a                ; $5432
    ld a, [wPerformerScriptId]                    ; $5435
    and a                                         ; $5438
    ret nz                                        ; $5439

    ld a, $06                                     ; $543A
    ld [wPerformerScriptId], a                    ; $543C
    ld a, $1c                                     ; $543F
    ld [wAnimSlotFrame + $3], a                   ; $5441
    xor a                                         ; $5444
    ld [wAnimSlotTimer + $3], a                   ; $5445
    ret                                           ; $5448


jr_005_5449:
    ldh a, [hKeysNew]                             ; $5449
    bit PADB_START, a                             ; $544B
    jr z, jr_005_5485                             ; $544D

    ui_sfx $04                                    ; $544F
    xor a                                         ; $5456
    ld [wPerfStartHold], a                        ; $5457
    ld a, [wPerfPaused]                           ; $545A
    ld [wPerfPausedAtStart], a                    ; $545D
    ld a, $01                                     ; $5460
    ld [wPerfPaused], a                           ; $5462
    call DjPerf_NR51MaskAll                       ; $5465
    call DjPerf_DrawChannel1State                 ; $5468
    call DjPerf_DrawChannel2State                 ; $546B
    call DjPerf_DrawChannel3State                 ; $546E
    ld a, [wPerformerScriptId]                    ; $5471
    and a                                         ; $5474
    ret nz                                        ; $5475

    ld a, $07                                     ; $5476
    ld [wPerformerScriptId], a                    ; $5478
    ld a, $28                                     ; $547B
    ld [wAnimSlotFrame + $3], a                   ; $547D
    xor a                                         ; $5480
    ld [wAnimSlotTimer + $3], a                   ; $5481
    ret                                           ; $5484


jr_005_5485:
    ldh a, [hKeysHeld]                            ; $5485
    bit PADB_START, a                             ; $5487
    jr z, jr_005_5491                             ; $5489

    ld hl, wPerfStartHold                         ; $548B
    inc [hl]                                      ; $548E
    jr jr_005_54df                                ; $548F

jr_005_5491:
    ldh a, [hKeysReleased]                        ; $5491
    bit PADB_START, a                             ; $5493
    jr z, jr_005_54ca                             ; $5495

    ld a, [wPerfPausedAtStart]                    ; $5497
    and a                                         ; $549A
    jr nz, jr_005_54af                            ; $549B

    ld a, [wPerfStartHold]                        ; $549D
    cp $1e                                        ; $54A0
    jr nc, jr_005_54af                            ; $54A2

    xor a                                         ; $54A4
    ld [wSound1PlayStep], a                       ; $54A5
    ld [wSound2PlayStep], a                       ; $54A8
    ld [wNoisePlayStep], a                        ; $54AB
    ret                                           ; $54AE


jr_005_54af:
    xor a                                         ; $54AF
    ld [wPerfPaused], a                           ; $54B0
    call DjPerf_NR51MaskFromChannels              ; $54B3
    ld a, [wPerformerScriptId]                    ; $54B6
    and a                                         ; $54B9
    ret nz                                        ; $54BA

    ld a, $07                                     ; $54BB
    ld [wPerformerScriptId], a                    ; $54BD
    ld a, $28                                     ; $54C0
    ld [wAnimSlotFrame + $3], a                   ; $54C2
    xor a                                         ; $54C5
    ld [wAnimSlotTimer + $3], a                   ; $54C6
    ret                                           ; $54C9


jr_005_54ca:
    ldh a, [hKeysNew]                             ; $54CA
    bit PADB_B, a                                 ; $54CC
    jr z, jr_005_54df                             ; $54CE

    ld a, $08                                     ; $54D0
    ld [wPerformerScriptId], a                    ; $54D2
    ld a, $2b                                     ; $54D5
    ld [wAnimSlotFrame + $3], a                   ; $54D7
    xor a                                         ; $54DA
    ld [wAnimSlotTimer + $3], a                   ; $54DB
    ret                                           ; $54DE


jr_005_54df:
    ld a, [wPerfControlCursor]                    ; $54DF
    and a                                         ; $54E2
    jr z, jr_005_5509                             ; $54E3

    cp $01                                        ; $54E5
    jp z, DjPerf_Input_Channel1Keys               ; $54E7

    cp $02                                        ; $54EA
    jp z, DjPerf_Input_Channel2Keys               ; $54EC

    cp $03                                        ; $54EF
    jp z, DjPerf_Input_Channel3Keys               ; $54F1

    jp DjPerf_Input_LevelKeys                     ; $54F4


; I: auto: 18 bytes, bytes; referenced by DjPerf_Input. L3 pass 2026-10-26: not reached by the 206 BGB replays; read
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F 20)
DjPerf_Input_Tbl54F7::
    db SFX1_DJ_PERFORM_SE_1, SNDCH_SFX1  ; #1
    db SFX1_DJ_PERFORM_SE_2, SNDCH_SFX1  ; #2
    db SFX1_DJ_PERFORM_SE_3, SNDCH_SFX1  ; #3
    db SFX1_DJ_PERFORM_SE_4, SNDCH_SFX1  ; #4
    db SFX1_RUN_CELEBRATION, SNDCH_SFX1  ; #5
    db SFX1_DJ_PERFORM_SE_6, SNDCH_SFX1  ; #6
    db SFX1_DJ_PERFORM_SE_7, SNDCH_SFX1  ; #7
    db SFX1_DJ_PERFORM_SE_8, SNDCH_SFX1  ; #8
    db SFX1_DJ_PERFORM_SE_9, SNDCH_SFX1  ; #9

jr_005_5509:
    ldh a, [hKeysNewRepeat]                       ; $5509
    and PADF_UP | PADF_DOWN                       ; $550B
    jr z, jr_005_5526                             ; $550D

    ld a, [wTempo]                                ; $550F
    ld bc, $0ff0                                  ; $5512
    call DjEd_StepDownUp                          ; $5515
    ld hl, wTempo                                 ; $5518
    cp [hl]                                       ; $551B
    ret z                                         ; $551C

    ld [hl], a                                    ; $551D
    call DjPerf_DrawTempo                         ; $551E
    ld hl, wDirtyFlag                             ; $5521
    inc [hl]                                      ; $5524
    ret                                           ; $5525


jr_005_5526:
    ldh a, [hKeysReleased]                        ; $5526
    and PADF_UP | PADF_DOWN                       ; $5528
    ret z                                         ; $552A

    ld a, [wTempo]                                ; $552B
    ld hl, wPerfTempoAtRelease                    ; $552E
    cp [hl]                                       ; $5531
    ret z                                         ; $5532

    ld [hl], a                                    ; $5533
    ld a, [wPerformerScriptId]                    ; $5534
    and a                                         ; $5537
    ret nz                                        ; $5538

    ld a, $01                                     ; $5539
    ld [wPerformerScriptId], a                    ; $553B
    ld a, $19                                     ; $553E
    ld [wAnimSlotFrame + $3], a                   ; $5540
    xor a                                         ; $5543
    ld [wAnimSlotTimer + $3], a                   ; $5544
    ret                                           ; $5547


; C: selector $D8B3 = 1: Up / Down held ($FFA3 and $C0) step channel 1 ($D8B4) and redraw its state; restarts the
; performer script when idle (branch target; code read 2026-10-19)
DjPerf_Input_Channel1Keys::
    ldh a, [hKeysNewRepeat]                       ; $5548
    and PADF_UP | PADF_DOWN                       ; $554A
    ret z                                         ; $554C

    ld a, [wPerfChannelState]                     ; $554D
    call DjPerf_ChannelToggleKeys                 ; $5550
    ld hl, wPerfChannelState                      ; $5553
    cp [hl]                                       ; $5556
    ret z                                         ; $5557

    ld [hl], a                                    ; $5558
    call DjPerf_DrawChannel1State                 ; $5559
    ld a, [wPerformerScriptId]                    ; $555C
    and a                                         ; $555F
    ret nz                                        ; $5560

    ld a, $02                                     ; $5561
    ld [wPerformerScriptId], a                    ; $5563
    ld a, $22                                     ; $5566
    ld [wAnimSlotFrame + $3], a                   ; $5568
    xor a                                         ; $556B
    ld [wAnimSlotTimer + $3], a                   ; $556C
    ret                                           ; $556F


; C: selector $D8B3 = 2: Up / Down step channel 2 ($D8B5) (branch target; code read 2026-10-19)
DjPerf_Input_Channel2Keys::
    ldh a, [hKeysNewRepeat]                       ; $5570
    and PADF_UP | PADF_DOWN                       ; $5572
    ret z                                         ; $5574

    ld a, [wPerfChannelState + $1]                ; $5575
    call DjPerf_ChannelToggleKeys                 ; $5578
    ld hl, wPerfChannelState + $1                 ; $557B
    cp [hl]                                       ; $557E
    ret z                                         ; $557F

    ld [hl], a                                    ; $5580
    call DjPerf_DrawChannel2State                 ; $5581
    ld a, [wPerformerScriptId]                    ; $5584
    and a                                         ; $5587
    ret nz                                        ; $5588

    ld a, $03                                     ; $5589
    ld [wPerformerScriptId], a                    ; $558B
    ld a, $22                                     ; $558E
    ld [wAnimSlotFrame + $3], a                   ; $5590
    xor a                                         ; $5593
    ld [wAnimSlotTimer + $3], a                   ; $5594
    ret                                           ; $5597


; C: selector $D8B3 = 3: Up / Down step channel 3 ($D8B6) (branch target; code read 2026-10-19)
DjPerf_Input_Channel3Keys::
    ldh a, [hKeysNewRepeat]                       ; $5598
    and PADF_UP | PADF_DOWN                       ; $559A
    ret z                                         ; $559C

    ld a, [wPerfChannelState + $2]                ; $559D
    call DjPerf_ChannelToggleKeys                 ; $55A0
    ld hl, wPerfChannelState + $2                 ; $55A3
    cp [hl]                                       ; $55A6
    ret z                                         ; $55A7

    ld [hl], a                                    ; $55A8
    call DjPerf_DrawChannel3State                 ; $55A9
    ld a, [wPerformerScriptId]                    ; $55AC
    and a                                         ; $55AF
    ret nz                                        ; $55B0

    ld a, $04                                     ; $55B1
    ld [wPerformerScriptId], a                    ; $55B3
    ld a, $22                                     ; $55B6
    ld [wAnimSlotFrame + $3], a                   ; $55B8
    xor a                                         ; $55BB
    ld [wAnimSlotTimer + $3], a                   ; $55BC
    ret                                           ; $55BF


; C: any other selector value: Up / Down step the level $D8B7 (DjEd_StepDownUp, 8 steps) and redraw the level digit
; (branch target; code read 2026-10-19)
DjPerf_Input_LevelKeys::
    ldh a, [hKeysNewRepeat]                       ; $55C0
    and PADF_UP | PADF_DOWN                       ; $55C2
    jr z, jr_005_55d9                             ; $55C4

    ld a, [wPerfLevel]                            ; $55C6
    ld bc, $0008                                  ; $55C9
    call DjEd_StepDownUp                          ; $55CC
    ld hl, wPerfLevel                             ; $55CF
    cp [hl]                                       ; $55D2
    ret z                                         ; $55D3

    ld [hl], a                                    ; $55D4
    call DjPerf_DrawLevelDigit                    ; $55D5
    ret                                           ; $55D8


jr_005_55d9:
    ldh a, [hKeysReleased]                        ; $55D9
    and PADF_UP | PADF_DOWN                       ; $55DB
    ret z                                         ; $55DD

    ld a, [wPerfLevel]                            ; $55DE
    ld hl, wPerfLevelAtRelease                    ; $55E1
    cp [hl]                                       ; $55E4
    ret z                                         ; $55E5

    ld [hl], a                                    ; $55E6
    ld a, [wPerformerScriptId]                    ; $55E7
    and a                                         ; $55EA
    ret nz                                        ; $55EB

    ld a, $05                                     ; $55EC
    ld [wPerformerScriptId], a                    ; $55EE
    ld a, $25                                     ; $55F1
    ld [wAnimSlotFrame + $3], a                   ; $55F3
    xor a                                         ; $55F6
    ld [wAnimSlotTimer + $3], a                   ; $55F7
    ret                                           ; $55FA


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; Up / Down step the channel state 0-3 on the performance screen (paused: A / B shortcuts to 3 / 2)
DjPerf_ChannelToggleKeys::
    ld hl, wPerfPaused                            ; $55FB
    bit 0, [hl]                                   ; $55FE
    ld hl, hKeysNew                               ; $5600
    jr nz, jr_005_5609                            ; $5603

    bit 1, a                                      ; $5605
    jr nz, jr_005_5618                            ; $5607

jr_005_5609:
    bit 6, [hl]                                   ; $5609
    jr z, jr_005_5611                             ; $560B

    dec a                                         ; $560D
    and $03                                       ; $560E
    ret                                           ; $5610


jr_005_5611:
    bit 7, [hl]                                   ; $5611
    ret z                                         ; $5613

    inc a                                         ; $5614
    and $03                                       ; $5615
    ret                                           ; $5617


jr_005_5618:
    bit 6, [hl]                                   ; $5618
    jr z, jr_005_561f                             ; $561A

    ld a, $03                                     ; $561C
    ret                                           ; $561E


jr_005_561f:
    bit 7, [hl]                                   ; $561F
    ret z                                         ; $5621

    ld a, $02                                     ; $5622
    ret                                           ; $5624


; C: fades the three channels in and out on each tick
DjPerf_ChannelFade::
    ld a, [wTickFlag]                             ; $5625
    and a                                         ; $5628
    ret z                                         ; $5629

    ld c, $22                                     ; $562A
    ld hl, wSound1VolAtten                        ; $562C
    ld de, wPerfChannelState                      ; $562F
    call DjPerf_ChannelStep                       ; $5632
    ld c, $44                                     ; $5635
    ld hl, wSound2VolAtten                        ; $5637
    ld de, wPerfChannelState + $1                 ; $563A
    call DjPerf_ChannelStep                       ; $563D
    ld c, $88                                     ; $5640
    ld hl, wNoiseVolAtten                         ; $5642
    ld de, wPerfChannelState + $2                 ; $5645
    call DjPerf_ChannelStep                       ; $5648
    call DjSnd_BuildWaveStaging                   ; $564B
    call DjPerf_DrawChannel1State                 ; $564E
    call DjPerf_DrawChannel2State                 ; $5651
    call DjPerf_DrawChannel3State                 ; $5654
    ret                                           ; $5657


; C: one channel state machine (0 off .. 3 fading in)
DjPerf_ChannelStep::
    ld a, [de]                                    ; $5658
    and a                                         ; $5659
    jr nz, jr_005_566a                            ; $565A

    ld a, c                                       ; $565C
    cpl                                           ; $565D
    ld c, a                                       ; $565E
    ld a, [wPerfNr51Mask]                         ; $565F
    and c                                         ; $5662
    ld [wPerfNr51Mask], a                         ; $5663
    ld a, $0f                                     ; $5666
    ld [hl], a                                    ; $5668
    ret                                           ; $5669


jr_005_566a:
    push af                                       ; $566A
    ld a, [wPerfNr51Mask]                         ; $566B
    or c                                          ; $566E
    ld [wPerfNr51Mask], a                         ; $566F
    pop af                                        ; $5672
    cp $01                                        ; $5673
    jr nz, jr_005_567a                            ; $5675

    xor a                                         ; $5677
    ld [hl], a                                    ; $5678
    ret                                           ; $5679


jr_005_567a:
    cp $02                                        ; $567A
    jr nz, jr_005_5693                            ; $567C

    ld a, [hl]                                    ; $567E
    cp $0f                                        ; $567F
    jr z, jr_005_5686                             ; $5681

    inc a                                         ; $5683
    ld [hl], a                                    ; $5684
    ret                                           ; $5685


jr_005_5686:
    ld a, c                                       ; $5686
    cpl                                           ; $5687
    ld c, a                                       ; $5688
    ld a, [wPerfNr51Mask]                         ; $5689
    and c                                         ; $568C
    ld [wPerfNr51Mask], a                         ; $568D
    xor a                                         ; $5690
    ld [de], a                                    ; $5691
    ret                                           ; $5692


jr_005_5693:
    ld a, [hl]                                    ; $5693
    and a                                         ; $5694
    jr z, jr_005_569a                             ; $5695

    dec a                                         ; $5697
    ld [hl], a                                    ; $5698
    ret                                           ; $5699


jr_005_569a:
    ld a, $01                                     ; $569A
    ld [de], a                                    ; $569C
    ret                                           ; $569D


; C: tempo digits to VRAM
DjPerf_DrawTempo::
    ld a, [wTempo]                                ; $569E
    ld bc, $0000                                  ; $56A1

jr_005_56a4:
    cp $64                                        ; $56A4
    jr c, jr_005_56ad                             ; $56A6

    sub $64                                       ; $56A8
    inc b                                         ; $56AA
    jr jr_005_56a4                                ; $56AB

jr_005_56ad:
    cp $0a                                        ; $56AD
    jr c, jr_005_56b6                             ; $56AF

    sub $0a                                       ; $56B1
    inc c                                         ; $56B3
    jr jr_005_56ad                                ; $56B4

jr_005_56b6:
    push bc                                       ; $56B6
    swap a                                        ; $56B7
    ld c, a                                       ; $56B9
    ld b, $00                                     ; $56BA
    ld hl, Gfx_1A_4D60_DjPerf_DrawTempo           ; $56BC
    add hl, bc                                    ; $56BF
    ld a, BANK(Gfx_1A_4D60_DjPerf_DrawTempo)      ; $56C0
    ld de, $8720                                  ; $56C2
    ld bc, $0010                                  ; $56C5
    call Vram_CopyFromBank                        ; $56C8
    pop bc                                        ; $56CB
    push bc                                       ; $56CC
    swap c                                        ; $56CD
    ld b, $00                                     ; $56CF
    ld hl, Gfx_1A_4D60_DjPerf_DrawTempo           ; $56D1
    add hl, bc                                    ; $56D4
    ld a, BANK(Gfx_1A_4D60_DjPerf_DrawTempo)      ; $56D5
    ld de, $8710                                  ; $56D7
    ld bc, $0010                                  ; $56DA
    call Vram_CopyFromBank                        ; $56DD
    pop bc                                        ; $56E0
    swap b                                        ; $56E1
    ld c, b                                       ; $56E3
    ld b, $00                                     ; $56E4
    ld hl, Gfx_1A_4D60_DjPerf_DrawTempo           ; $56E6
    add hl, bc                                    ; $56E9
    ld a, BANK(Gfx_1A_4D60_DjPerf_DrawTempo)      ; $56EA
    ld de, $8700                                  ; $56EC
    ld bc, $0010                                  ; $56EF
    call Vram_CopyFromBank                        ; $56F2
    ret                                           ; $56F5


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_ToggleBlink::
    ldh [hScratchA], a                            ; $56F6
    cp $02                                        ; $56F8
    jr c, jr_005_5709                             ; $56FA

    ld a, [hl]                                    ; $56FC
    cpl                                           ; $56FD
    ld [hl], a                                    ; $56FE
    and $01                                       ; $56FF
    jr z, jr_005_5707                             ; $5701

    ldh a, [hScratchA]                            ; $5703
    jr jr_005_5709                                ; $5705

jr_005_5707:
    ld a, $04                                     ; $5707

jr_005_5709:
    ld e, a                                       ; $5709
    sla a                                         ; $570A
    add e                                         ; $570C
    ld de, DjPerf_ToggleBlink_Tbl5715             ; $570D
    add e                                         ; $5710
    ld e, a                                       ; $5711
    ret nc                                        ; $5712

    inc d                                         ; $5713
    ret                                           ; $5714


; C: auto: 15 bytes, bytes; referenced by DjPerf_ToggleBlink. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_ToggleBlink_Tbl5715::
    db $7a, $7c, $7c, $7e, $7a, $7b, $75, $76, $77, $7e, $78, $79, $7e, $7e, $7e

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_Write2Tiles::
    ld a, [de]                                    ; $5724
    call Vram_WriteByteSafe                       ; $5725
    inc de                                        ; $5728
    inc hl                                        ; $5729
    ld a, [de]                                    ; $572A
    call Vram_WriteByteSafe                       ; $572B
    inc de                                        ; $572E
    inc hl                                        ; $572F
    ld a, [de]                                    ; $5730
    call Vram_WriteByteSafe                       ; $5731
    ret                                           ; $5734


; C: indicator tiles of SOUND I
DjPerf_DrawChannel1State::
    ld a, [wPerfChannelState]                     ; $5735
    and a                                         ; $5738
    jr nz, jr_005_573f                            ; $5739

    ld a, $c9                                     ; $573B
    jr jr_005_5741                                ; $573D

jr_005_573f:
    ld a, $ca                                     ; $573F

jr_005_5741:
    ld hl, $9ea9                                  ; $5741
    call Vram_WriteByteSafe                       ; $5744
    ld a, [wPerfPaused]                           ; $5747
    and a                                         ; $574A
    jr z, jr_005_5751                             ; $574B

    xor a                                         ; $574D
    ld [wPerfChannelBlink], a                     ; $574E

jr_005_5751:
    ld a, [wPerfChannelState]                     ; $5751
    ld hl, wPerfChannelBlink                      ; $5754
    call DjPerf_ToggleBlink                       ; $5757
    ld hl, $9ee5                                  ; $575A
    call DjPerf_Write2Tiles                       ; $575D
    ret                                           ; $5760


; C
DjPerf_DrawChannel2State::
    ld a, [wPerfChannelState + $1]                ; $5761
    and a                                         ; $5764
    jr nz, jr_005_576b                            ; $5765

    ld a, $c9                                     ; $5767
    jr jr_005_576d                                ; $5769

jr_005_576b:
    ld a, $ca                                     ; $576B

jr_005_576d:
    ld hl, $9eaa                                  ; $576D
    call Vram_WriteByteSafe                       ; $5770
    ld a, [wPerfPaused]                           ; $5773
    and a                                         ; $5776
    jr z, jr_005_577d                             ; $5777

    xor a                                         ; $5779
    ld [wPerfChannelBlink + $1], a                ; $577A

jr_005_577d:
    ld a, [wPerfChannelState + $1]                ; $577D
    ld hl, wPerfChannelBlink + $1                 ; $5780
    call DjPerf_ToggleBlink                       ; $5783
    ld hl, $9ee9                                  ; $5786
    call DjPerf_Write2Tiles                       ; $5789
    ret                                           ; $578C


; C
DjPerf_DrawChannel3State::
    ld a, [wPerfChannelState + $2]                ; $578D
    and a                                         ; $5790
    jr nz, jr_005_5797                            ; $5791

    ld a, $a9                                     ; $5793
    jr jr_005_5799                                ; $5795

jr_005_5797:
    ld a, $ba                                     ; $5797

jr_005_5799:
    ld hl, $9e8a                                  ; $5799
    call Vram_WriteByteSafe                       ; $579C
    ld a, [wPerfPaused]                           ; $579F
    and a                                         ; $57A2
    jr z, jr_005_57a9                             ; $57A3

    xor a                                         ; $57A5
    ld [wPerfChannelBlink + $2], a                ; $57A6

jr_005_57a9:
    ld a, [wPerfChannelState + $2]                ; $57A9
    ld hl, wPerfChannelBlink + $2                 ; $57AC
    call DjPerf_ToggleBlink                       ; $57AF
    ld hl, $9eed                                  ; $57B2
    call DjPerf_Write2Tiles                       ; $57B5
    ret                                           ; $57B8


; C
DjPerf_DrawLevelDigit::
    ld a, [wPerfLevel]                            ; $57B9
    inc a                                         ; $57BC
    swap a                                        ; $57BD
    ld c, a                                       ; $57BF
    ld b, $00                                     ; $57C0
    ld hl, Gfx_1A_4D60_DjPerf_DrawTempo           ; $57C2
    add hl, bc                                    ; $57C5
    ld a, BANK(Gfx_1A_4D60_DjPerf_DrawTempo)      ; $57C6
    ld de, $8730                                  ; $57C8
    ld bc, $0010                                  ; $57CB
    call Vram_CopyFromBank                        ; $57CE
    ret                                           ; $57D1


; C: NR51 mask = $11
DjPerf_NR51MaskAll::
    ld a, $11                                     ; $57D2
    ld [wPerfNr51Mask], a                         ; $57D4
    ret                                           ; $57D7


; C
DjPerf_NR51MaskFromChannels::
    ld b, $11                                     ; $57D8
    ld a, [wPerfChannelState]                     ; $57DA
    and a                                         ; $57DD
    jr z, jr_005_57e4                             ; $57DE

    set 5, b                                      ; $57E0
    set 1, b                                      ; $57E2

jr_005_57e4:
    ld a, [wPerfChannelState + $1]                ; $57E4
    and a                                         ; $57E7
    jr z, jr_005_57ee                             ; $57E8

    set 6, b                                      ; $57EA
    set 2, b                                      ; $57EC

jr_005_57ee:
    ld a, [wPerfChannelState + $2]                ; $57EE
    and a                                         ; $57F1
    jr z, jr_005_57f8                             ; $57F2

    set 7, b                                      ; $57F4
    set 3, b                                      ; $57F6

jr_005_57f8:
    ld a, b                                       ; $57F8
    ld [wPerfNr51Mask], a                         ; $57F9
    ret                                           ; $57FC


; C: sound $12 and window slide
DjPanel_SlideIn::
    play_sfx1 SFX1_PANEL_OPEN                     ; $57FD
    ld hl, Slide_WyDeltaTbl                       ; $5804
    ld b, $24                                     ; $5807

jr_005_5809:
    push bc                                       ; $5809
    push hl                                       ; $580A
    ldh a, [hWyShadow]                            ; $580B
    add [hl]                                      ; $580D
    ldh [hWyShadow], a                            ; $580E
    call DjPanel_WaitLine                         ; $5810
    rst Rst08_WaitVBlank                          ; $5813
    pop hl                                        ; $5814
    pop bc                                        ; $5815
    inc hl                                        ; $5816
    dec b                                         ; $5817
    jr nz, jr_005_5809                            ; $5818

    ret                                           ; $581A


; C: sound $13 and window slide back
DjPanel_SlideOut::
    play_sfx1 SFX1_PANEL_CLOSE                    ; $581B
    ld hl, Slide_WyDeltaTbl                       ; $5822
    ld b, $24                                     ; $5825

jr_005_5827:
    push bc                                       ; $5827
    push hl                                       ; $5828
    ldh a, [hWyShadow]                            ; $5829
    sub [hl]                                      ; $582B
    ldh [hWyShadow], a                            ; $582C
    call DjPanel_WaitLine                         ; $582E
    rst Rst08_WaitVBlank                          ; $5831
    pop hl                                        ; $5832
    pop bc                                        ; $5833
    inc hl                                        ; $5834
    dec b                                         ; $5835
    jr nz, jr_005_5827                            ; $5836

    ret                                           ; $5838


; C: waits for LY to pass the window line. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjPanel_WaitLine::
    ldh a, [rWY]                                  ; $5839
    dec a                                         ; $583B
    cp $90                                        ; $583C
    ret nc                                        ; $583E

    ld c, a                                       ; $583F

jr_005_5840:
    ldh a, [rLY]                                  ; $5840
    cp c                                          ; $5842
    jr nz, jr_005_5840                            ; $5843

    ld a, $03                                     ; $5845
    ld hl, $ff41                                  ; $5847

jr_005_584a:
    ld a, [hl]                                    ; $584A
    and $03                                       ; $584B
    jr nz, jr_005_584a                            ; $584D

    ldh a, [rLCDC]                                ; $584F
    res 1, a                                      ; $5851
    ldh [rLCDC], a                                ; $5853
    ret                                           ; $5855


; C: C = A / 10; A = A mod 10
DjEd_DivMod10::
    ld c, $00                                     ; $5856

jr_005_5858:
    cp $0a                                        ; $5858
    ret c                                         ; $585A

    sub $0a                                       ; $585B
    inc c                                         ; $585D
    jr jr_005_5858                                ; $585E

; C
DjEd_DrawVolumeDigits::
    call DjEd_DivMod10                            ; $5860
    push af                                       ; $5863
    ld a, c                                       ; $5864
    and a                                         ; $5865
    jr z, jr_005_5870                             ; $5866

    ld bc, $2b30                                  ; $5868
    ld a, $80                                     ; $586B
    call Oam_AddMeta_B01_5D2B                     ; $586D

jr_005_5870:
    pop af                                        ; $5870
    ld bc, $3130                                  ; $5871
    add $7f                                       ; $5874
    call Oam_AddMeta_B01_5D2B                     ; $5876
    ret                                           ; $5879


; C
DjEd_DrawEnvPeriodDigit::
    ld bc, $4030                                  ; $587A
    and a                                         ; $587D
    jr nz, jr_005_5882                            ; $587E

    ld a, $0a                                     ; $5880

jr_005_5882:
    add $7f                                       ; $5882
    call Oam_AddMeta_B01_5D2B                     ; $5884
    ret                                           ; $5887


; C
DjEd_DrawLengthDigit::
    push af                                       ; $5888
    ld bc, $582e                                  ; $5889
    and a                                         ; $588C
    jr nz, jr_005_5891                            ; $588D

    ld a, $0a                                     ; $588F

jr_005_5891:
    add $7f                                       ; $5891
    call Oam_AddMeta_B01_5D2B                     ; $5893
    pop af                                        ; $5896
    cpl                                           ; $5897
    add $2f                                       ; $5898
    ld c, a                                       ; $589A
    ld b, $51                                     ; $589B
    ld a, $73                                     ; $589D
    call Oam_AddMeta_B01_5D2B                     ; $589F
    ret                                           ; $58A2


; C
DjEd_DrawModDepthDigits::
    call DjEd_DivMod10                            ; $58A3
    push af                                       ; $58A6
    ld a, c                                       ; $58A7
    and a                                         ; $58A8
    jr z, jr_005_58b3                             ; $58A9

    ld bc, $6930                                  ; $58AB
    add $7f                                       ; $58AE
    call Oam_AddMeta_B01_5D2B                     ; $58B0

jr_005_58b3:
    pop af                                        ; $58B3
    ld bc, $6f30                                  ; $58B4
    add $7f                                       ; $58B7
    call Oam_AddMeta_B01_5D2B                     ; $58B9
    ret                                           ; $58BC


; C
DjEd_DrawModSpeedDigits::
    call DjEd_DivMod10                            ; $58BD
    push af                                       ; $58C0
    ld a, c                                       ; $58C1
    and a                                         ; $58C2
    jr z, jr_005_58cd                             ; $58C3

    ld bc, $7b30                                  ; $58C5
    add $7f                                       ; $58C8
    call Oam_AddMeta_B01_5D2B                     ; $58CA

jr_005_58cd:
    pop af                                        ; $58CD
    ld bc, $8130                                  ; $58CE
    add $7f                                       ; $58D1
    call Oam_AddMeta_B01_5D2B                     ; $58D3
    ret                                           ; $58D6


; C: loop digits; during print also the printer loop (A / rows)
DjEd_DrawLoopDigitsAndPrint::
    push af                                       ; $58D7
    call DjEd_DivMod10                            ; $58D8
    push af                                       ; $58DB
    ld a, c                                       ; $58DC
    and a                                         ; $58DD
    jr z, jr_005_58e8                             ; $58DE

    ld bc, $084a                                  ; $58E0
    ld a, $80                                     ; $58E3
    call Oam_AddMeta_B01_5D2B                     ; $58E5

jr_005_58e8:
    pop af                                        ; $58E8
    ld bc, $0e4a                                  ; $58E9
    add $7f                                       ; $58EC
    call Oam_AddMeta_B01_5D2B                     ; $58EE
    pop af                                        ; $58F1
    sla a                                         ; $58F2
    sla a                                         ; $58F4
    sla a                                         ; $58F6
    add $18                                       ; $58F8
    ld b, a                                       ; $58FA
    ld c, $44                                     ; $58FB
    ld a, $7e                                     ; $58FD
    call Oam_AddMeta_B01_5D2B                     ; $58FF
    ret                                           ; $5902


; C: the TRIPY-H score print job (reached by A on Start-held in the editor, 05:4758): DjPrint_BeginSerial, INIT, bands
; of 9 rows (DjPrint_RowDispatch, DjPrint_SendBand), PRINT, wait, repeated until row $27 or B; ends with
; DjPrint_EndSerial (branch target; code read 2026-10-19)
DjPrint_Job::
    xor a                                         ; $5903
    ldh [rNR51], a                                ; $5904
    call DjPrint_BeginSerial                      ; $5906
    xor a                                         ; $5909
    ld [wPerfPrintRow], a                         ; $590A
    ld hl, wPerfPrintBandFlags                    ; $590D
    set 0, [hl]                                   ; $5910

jr_005_5912:
    call DjPrint_SendInitWait                     ; $5912
    jr c, jr_005_5969                             ; $5915

    ld b, $09                                     ; $5917
    ld a, [wPerfPrintRow]                         ; $5919
    cpl                                           ; $591C
    add $28                                       ; $591D
    cp $09                                        ; $591F
    jr nc, jr_005_5924                            ; $5921

    ld b, a                                       ; $5923

jr_005_5924:
    push bc                                       ; $5924
    call DjPrint_RowDispatch                      ; $5925
    pop bc                                        ; $5928
    push bc                                       ; $5929
    ld a, b                                       ; $592A
    cp $01                                        ; $592B
    jr nz, jr_005_5933                            ; $592D

    ld a, $01                                     ; $592F
    jr jr_005_5934                                ; $5931

jr_005_5933:
    xor a                                         ; $5933

jr_005_5934:
    call DjPrint_SendBand                         ; $5934
    pop bc                                        ; $5937
    jr c, jr_005_5969                             ; $5938

    dec b                                         ; $593A
    jr nz, jr_005_5924                            ; $593B

    ld a, [wPerfPrintRow]                         ; $593D
    cp $27                                        ; $5940
    jr nz, jr_005_5949                            ; $5942

    ld hl, wPerfPrintBandFlags                    ; $5944
    set 1, [hl]                                   ; $5947

jr_005_5949:
    call DjPrint_SendPrint                        ; $5949
    jr c, jr_005_5969                             ; $594C

    call DjPrint_WaitDone                         ; $594E
    push af                                       ; $5951
    call Prn_EngineStop                           ; $5952
    pop af                                        ; $5955
    jr c, jr_005_5969                             ; $5956

    ld a, [wPerfPrintRow]                         ; $5958
    cp $27                                        ; $595B
    jr z, jr_005_5969                             ; $595D

    ldh a, [hKeysNewSticky]                       ; $595F
    ld b, a                                       ; $5961
    xor a                                         ; $5962
    ldh [hKeysNewSticky], a                       ; $5963
    bit 1, b                                      ; $5965
    jr z, jr_005_5912                             ; $5967

jr_005_5969:
    call Prn_EngineStop                           ; $5969
    call DjPrint_EndSerial                        ; $596C
    ret                                           ; $596F


; C: enables the serial IRQ and the printer poll
DjPrint_BeginSerial::
    ld hl, rIE                                    ; $5970
    set 3, [hl]                                   ; $5973
    ld a, $00                                     ; $5975
    ldh [hSerialHandlerIndex], a                  ; $5977
    ld a, $01                                     ; $5979
    ld [wPrnPollEnable], a                        ; $597B
    ret                                           ; $597E


; I: Prn_SendInit until the answer is not $F0
DjPrint_SendInitWait::
    call Prn_SendInit                             ; $597F
    cp $f0                                        ; $5982
    jr nz, jr_005_5989                            ; $5984

    rst Rst08_WaitVBlank                          ; $5986
    jr DjPrint_SendInitWait                       ; $5987

jr_005_5989:
    cp $ff                                        ; $5989
    jr z, jr_005_5996                             ; $598B

    ld a, [wPrnDevId]                             ; $598D
    cp $81                                        ; $5990
    jr nz, jr_005_5996                            ; $5992

    and a                                         ; $5994
    ret                                           ; $5995


jr_005_5996:
    scf                                           ; $5996
    ret                                           ; $5997


; C: one band of 40 rows
DjPrint_SendBand::
    ldh [hScratchA], a                            ; $5998

jr_005_599a:
    rst Rst08_WaitVBlank                          ; $599A
    ldh a, [hScratchA]                            ; $599B
    ld [wPrnLastChunk], a                         ; $599D
    ld hl, wBandBuffer                            ; $59A0
    ld a, $01                                     ; $59A3
    call Prn_SendData                             ; $59A5
    cp $f0                                        ; $59A8
    jr z, jr_005_599a                             ; $59AA

    cp $ff                                        ; $59AC
    jr z, jr_005_59b2                             ; $59AE

    and a                                         ; $59B0
    ret                                           ; $59B1


jr_005_59b2:
    scf                                           ; $59B2
    ret                                           ; $59B3


; C: print command with the margins of the band
DjPrint_SendPrint::
    ld a, $01                                     ; $59B4
    ld [wPrnSheets], a                            ; $59B6
    xor a                                         ; $59B9
    ld hl, wPerfPrintBandFlags                    ; $59BA
    bit 0, [hl]                                   ; $59BD
    jr z, jr_005_59c5                             ; $59BF

    or $30                                        ; $59C1
    res 0, [hl]                                   ; $59C3

jr_005_59c5:
    bit 1, [hl]                                   ; $59C5
    jr z, jr_005_59cd                             ; $59C7

    or $03                                        ; $59C9
    res 1, [hl]                                   ; $59CB

jr_005_59cd:
    ld [wPrnMargin], a                            ; $59CD
    ld a, $e4                                     ; $59D0
    ld [wPrnPalette], a                           ; $59D2
    call Prn_SendPrint                            ; $59D5
    cp $f0                                        ; $59D8
    jr nz, jr_005_59df                            ; $59DA

    rst Rst08_WaitVBlank                          ; $59DC
    jr DjPrint_SendPrint                          ; $59DD

jr_005_59df:
    cp $ff                                        ; $59DF
    jr z, jr_005_59e5                             ; $59E1

    and a                                         ; $59E3
    ret                                           ; $59E4


jr_005_59e5:
    scf                                           ; $59E5
    ret                                           ; $59E6


; C: waits for the printer status
DjPrint_WaitDone::
    ld bc, $000c                                  ; $59E7
    call Wait_Frames                              ; $59EA

jr_005_59ed:
    rst Rst08_WaitVBlank                          ; $59ED
    ld a, [wPrnStatus]                            ; $59EE
    cp $ff                                        ; $59F1
    jr z, jr_005_59fb                             ; $59F3

    bit 1, a                                      ; $59F5
    jr nz, jr_005_59ed                            ; $59F7

    and a                                         ; $59F9
    ret                                           ; $59FA


jr_005_59fb:
    scf                                           ; $59FB
    ret                                           ; $59FC


; C
DjPrint_EndSerial::
    ld hl, rIE                                    ; $59FD
    res 3, [hl]                                   ; $5A00
    xor a                                         ; $5A02
    ld [wPrnPollEnable], a                        ; $5A03
    ret                                           ; $5A06


; C: jumps through the 39-entry row table at 5A67
DjPrint_RowDispatch::
    ld a, [wPerfPrintRow]                         ; $5A07
    ld c, a                                       ; $5A0A
    inc a                                         ; $5A0B
    ld [wPerfPrintRow], a                         ; $5A0C
    sla c                                         ; $5A0F
    ld b, $00                                     ; $5A11
    ld hl, DjPrint_RowTbl                         ; $5A13
    add hl, bc                                    ; $5A16
    ld a, [hl+]                                   ; $5A17
    ld h, [hl]                                    ; $5A18
    ld l, a                                       ; $5A19
    jp hl                                         ; $5A1A


; I: 39 code pointers: one per printed line
DjPrint_RowTbl::
    dw DjPrintRow_Text0
    dw DjPrintRow_Text1
    dw DjPrintRow_Text2
    dw DjPrintRow_Text1
    dw DjPrintRow_Text0
    dw DjPrintRow_Tempo
    dw DjPrintRow_Text3
    dw DjPrintRow_Text7
    dw DjPrintRow_S1Notes0
    dw DjPrintRow_S1Notes1
    dw DjPrintRow_S1Notes2
    dw DjPrintRow_S1Notes3
    dw DjPrintRow_S1Duty
    dw DjPrintRow_S1Envelope
    dw DjPrintRow_S1Modulation
    dw DjPrintRow_S1Loop
    dw DjPrintRow_Text4
    dw DjPrintRow_Text7
    dw DjPrintRow_S2Notes0
    dw DjPrintRow_S2Notes1
    dw DjPrintRow_S2Notes2
    dw DjPrintRow_S2Notes3
    dw DjPrintRow_S2WaveTitle
    dw DjPrintRow_S2WaveGraph0
    dw DjPrintRow_S2WaveGraph1
    dw DjPrintRow_S2WaveGraph2
    dw DjPrintRow_S2WaveGraph3
    dw DjPrintRow_S2WavePattern
    dw DjPrintRow_S2Modulation
    dw DjPrintRow_S2Loop
    dw DjPrintRow_Text5
    dw DjPrintRow_Text7
    dw DjPrintRow_NsNotes0
    dw DjPrintRow_NsNotes1
    dw DjPrintRow_NsNotes2
    dw DjPrintRow_NsNotes3
    dw DjPrintRow_NsEnvelope
    dw DjPrintRow_NsLoop
    dw DjPrintRow_Text6

; C: fixed text line of the score sheet (rows 0 / 4). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print
; 1F:09, err_dj_dataFF 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text0::
    ld hl, DjPrintRow_Text0_Tbl5A6F               ; $5A69
    jp DjPrint_RenderTextRow                      ; $5A6C


; C: row table of DjPrintRow_Text0 (ld hl,5ABB; jp 60EE): 20 x $8B (blank row); was typed as padding
DjPrintRow_Text0_Tbl5A6F::
    db $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b

; C: fixed text line (rows 1 / 3). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text1::
    ld hl, DjPrintRow_Text1_Tbl5A89               ; $5A83
    jp DjPrint_RenderTextRow                      ; $5A86


; C: row table of DjPrintRow_Text1: $8B, 18 x $9F, $8B (20 tile codes); the 1 + 18 + 1 byte split was a typing
; artefact
DjPrintRow_Text1_Tbl5A89::
    db $8b, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $8b

; C: fixed text line (row 2). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text2::
    ld hl, DjPrintRow_Text2_Tbl5AA3               ; $5A9D
    jp DjPrint_RenderTextRow                      ; $5AA0


; I: auto: 20 bytes, bytes; referenced by DjPrintRow_Text2. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text2_Tbl5AA3::
    db $8b, $9f, $9f, $9f, $9f, $9f, $83, $81, $68, $6f, $6f, $88, $4d, $67, $9f, $9f
    db $9f, $9f, $9f, $8b

; C: fixed text line (row 6). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text3::
    ld hl, DjPrintRow_Text3_Tbl5ABD               ; $5AB7
    jp DjPrint_RenderTextRow                      ; $5ABA


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text3. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text3_Tbl5ABD::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $00, $01, $02, $03, $04, $07, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 16). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text4::
    ld hl, DjPrintRow_Text4_Tbl5AD7               ; $5AD1
    jp DjPrint_RenderTextRow                      ; $5AD4


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text4. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text4_Tbl5AD7::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $00, $01, $02, $03, $04, $08, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 30). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text5::
    ld hl, DjPrintRow_Text5_Tbl5AF1               ; $5AEB
    jp DjPrint_RenderTextRow                      ; $5AEE


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text5. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text5_Tbl5AF1::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $03, $01, $05, $00, $06, $4d, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 38). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text6::
    ld hl, DjPrintRow_Text6_Tbl5B0B               ; $5B05
    jp DjPrint_RenderTextRow                      ; $5B08


; C: row table of DjPrintRow_Text6 (ld hl,5B57; jp 60EE): 20 x $4D; was typed as padding
DjPrintRow_Text6_Tbl5B0B::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d

; C: fixed text line (rows 7 / 17 / 31). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text7::
    ld hl, DjPrintRow_Text7_Tbl5B25               ; $5B1F
    jp DjPrint_RenderTextRow                      ; $5B22


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text7. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text7_Tbl5B25::
    db $6d, $6e, $83, $64, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND I notes 0-3 and their stereo codes
DjPrintRow_S1Notes0::
    ld hl, wSound1Notes                           ; $5B39
    ld de, wSound1Stereo                          ; $5B3C
    ld c, $00                                     ; $5B3F
    jp DjPrintRow_NsNotes_Build                   ; $5B41


; C: SOUND I notes 4-7
DjPrintRow_S1Notes1::
    ld hl, wSound1Notes + $4                      ; $5B44
    ld de, wSound1Stereo + $4                     ; $5B47
    ld c, $00                                     ; $5B4A
    jp DjPrintRow_NsNotes_Build                   ; $5B4C


; C: SOUND I notes 8-11
DjPrintRow_S1Notes2::
    ld hl, wSound1Notes + $8                      ; $5B4F
    ld de, wSound1Stereo + $8                     ; $5B52
    ld c, $00                                     ; $5B55
    jp DjPrintRow_NsNotes_Build                   ; $5B57


; C: SOUND I notes 12-15
DjPrintRow_S1Notes3::
    ld hl, wSound1Notes + $c                      ; $5B5A
    ld de, wSound1Stereo + $c                     ; $5B5D
    ld c, $00                                     ; $5B60
    jp DjPrintRow_NsNotes_Build                   ; $5B62


; C: SOUND II notes 0-3
DjPrintRow_S2Notes0::
    ld hl, wSound2Notes                           ; $5B65
    ld de, wSound2Stereo                          ; $5B68
    ld c, $00                                     ; $5B6B
    jp DjPrintRow_NsNotes_Build                   ; $5B6D


; C: SOUND II notes 4-7
DjPrintRow_S2Notes1::
    ld hl, wSound2Notes + $4                      ; $5B70
    ld de, wSound2Stereo + $4                     ; $5B73
    ld c, $00                                     ; $5B76
    jp DjPrintRow_NsNotes_Build                   ; $5B78


; C: SOUND II notes 8-11
DjPrintRow_S2Notes2::
    ld hl, wSound2Notes + $8                      ; $5B7B
    ld de, wSound2Stereo + $8                     ; $5B7E
    ld c, $00                                     ; $5B81
    jp DjPrintRow_NsNotes_Build                   ; $5B83


; C: SOUND II notes 12-15
DjPrintRow_S2Notes3::
    ld hl, wSound2Notes + $c                      ; $5B86
    ld de, wSound2Stereo + $c                     ; $5B89
    ld c, $00                                     ; $5B8C
    jp DjPrintRow_NsNotes_Build                   ; $5B8E


; C: NOISE notes 0-3
DjPrintRow_NsNotes0::
    ld hl, wNoiseNotes                            ; $5B91
    ld de, wNoiseStereoWidth                      ; $5B94
    ld c, $10                                     ; $5B97
    jp DjPrintRow_NsNotes_Build                   ; $5B99


; C: NOISE notes 4-7
DjPrintRow_NsNotes1::
    ld hl, wNoiseNotes + $4                       ; $5B9C
    ld de, wNoiseStereoWidth + $4                 ; $5B9F
    ld c, $10                                     ; $5BA2
    jp DjPrintRow_NsNotes_Build                   ; $5BA4


; C: NOISE notes 8-11
DjPrintRow_NsNotes2::
    ld hl, wNoiseNotes + $8                       ; $5BA7
    ld de, wNoiseStereoWidth + $8                 ; $5BAA
    ld c, $10                                     ; $5BAD
    jp DjPrintRow_NsNotes_Build                   ; $5BAF


; C: NOISE notes 12-15; followed by the shared note-row renderer
DjPrintRow_NsNotes3::
    ld hl, wNoiseNotes + $c                       ; $5BB2
    ld de, wNoiseStereoWidth + $c                 ; $5BB5
    ld c, $10                                     ; $5BB8
    jp DjPrintRow_NsNotes_Build                   ; $5BBA


; C: shared tail of the five noise-step note rows (callers 5B8D-5BB9): copies the 20-byte template Tbl5C7E to $C480,
; then writes the notes of one 4-note group (branch target; code read 2026-10-19)
DjPrintRow_NsNotes_Build::
    push bc                                       ; $5BBD
    push de                                       ; $5BBE
    push hl                                       ; $5BBF
    ld hl, DjPrintRow_NsNotes3_Tbl5C32            ; $5BC0
    ld de, wTextLineSrc                           ; $5BC3
    ld b, $14                                     ; $5BC6

jr_005_5bc8:
    ld a, [hl+]                                   ; $5BC8
    ld [de], a                                    ; $5BC9
    inc e                                         ; $5BCA
    dec b                                         ; $5BCB
    jr nz, jr_005_5bc8                            ; $5BCC

    pop hl                                        ; $5BCE
    ld de, wTextLineSrc + $1                      ; $5BCF
    ld b, $04                                     ; $5BD2

jr_005_5bd4:
    ld a, [hl+]                                   ; $5BD4
    and a                                         ; $5BD5
    jr nz, jr_005_5bdf                            ; $5BD6

    inc de                                        ; $5BD8
    ld a, $8a                                     ; $5BD9
    ld [de], a                                    ; $5BDB
    inc de                                        ; $5BDC
    jr jr_005_5c02                                ; $5BDD

jr_005_5bdf:
    dec a                                         ; $5BDF
    ld c, $00                                     ; $5BE0

jr_005_5be2:
    cp $0c                                        ; $5BE2
    jr c, jr_005_5beb                             ; $5BE4

    sub $0c                                       ; $5BE6
    inc c                                         ; $5BE8
    jr jr_005_5be2                                ; $5BE9

jr_005_5beb:
    push bc                                       ; $5BEB
    push hl                                       ; $5BEC
    sla a                                         ; $5BED
    ld c, a                                       ; $5BEF
    ld b, $00                                     ; $5BF0
    ld hl, DjPrintRow_NsNotes3_Tbl5C46            ; $5BF2
    add hl, bc                                    ; $5BF5
    ld a, [hl+]                                   ; $5BF6
    ld [de], a                                    ; $5BF7
    inc de                                        ; $5BF8
    ld a, [hl]                                    ; $5BF9
    ld [de], a                                    ; $5BFA
    inc de                                        ; $5BFB
    pop hl                                        ; $5BFC
    pop bc                                        ; $5BFD
    ld a, c                                       ; $5BFE
    add $23                                       ; $5BFF
    ld [de], a                                    ; $5C01

jr_005_5c02:
    inc de                                        ; $5C02
    inc de                                        ; $5C03
    inc de                                        ; $5C04
    dec b                                         ; $5C05
    jr nz, jr_005_5bd4                            ; $5C06

    pop hl                                        ; $5C08
    pop bc                                        ; $5C09
    ld a, c                                       ; $5C0A
    ldh [hScratchA], a                            ; $5C0B
    ld de, wTextLineSrc + $4                      ; $5C0D
    ld b, $04                                     ; $5C10

jr_005_5c12:
    ld a, [hl]                                    ; $5C12
    and $03                                       ; $5C13
    ld c, a                                       ; $5C15
    ldh a, [hScratchA]                            ; $5C16
    add [hl]                                      ; $5C18
    srl a                                         ; $5C19
    srl a                                         ; $5C1B
    and $0c                                       ; $5C1D
    or c                                          ; $5C1F
    or $f0                                        ; $5C20
    ld [de], a                                    ; $5C22
    inc hl                                        ; $5C23
    inc de                                        ; $5C24
    inc de                                        ; $5C25
    inc de                                        ; $5C26
    inc de                                        ; $5C27
    inc de                                        ; $5C28
    dec b                                         ; $5C29
    jr nz, jr_005_5c12                            ; $5C2A

    ld hl, wTextLineSrc                           ; $5C2C
    jp DjPrint_RenderTextRow                      ; $5C2F


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsNotes3. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsNotes3_Tbl5C32::
    db $9f, $9f, $9f, $9f, $9f, $4f, $9f, $9f, $9f, $9f, $4f, $9f, $9f, $9f, $9f, $4f
    db $9f, $9f, $9f, $9f

; C: auto: 24 bytes, bytes; referenced by DjPrintRow_NsNotes3. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsNotes3_Tbl5C46::
    db $09, $9f, $09, $20, $0a, $9f, $0a, $20, $0b, $9f, $0c, $9f, $0c, $20, $0d, $9f
    db $0d, $20, $0e, $9f, $0e, $20, $0f, $9f

; C: SOUND I duty and length line
DjPrintRow_S1Duty::
    ld hl, DjPrintRow_S1Duty_Tbl5C84              ; $5C5E
    ld de, wTextLineSrc                           ; $5C61
    ld b, $14                                     ; $5C64

jr_005_5c66:
    ld a, [hl+]                                   ; $5C66
    ld [de], a                                    ; $5C67
    inc e                                         ; $5C68
    dec b                                         ; $5C69
    jr nz, jr_005_5c66                            ; $5C6A

    ld de, wTextLineSrc + $5                      ; $5C6C
    ld a, [wSound1DutyLen]                        ; $5C6F
    ld c, a                                       ; $5C72
    ld b, $00                                     ; $5C73
    ld hl, DjPrintRow_S1Duty_Tbl5C98              ; $5C75
    add hl, bc                                    ; $5C78
    ld a, [hl]                                    ; $5C79
    ld [de], a                                    ; $5C7A
    inc de                                        ; $5C7B
    inc a                                         ; $5C7C
    ld [de], a                                    ; $5C7D
    ld hl, wTextLineSrc                           ; $5C7E
    jp DjPrint_RenderTextRow                      ; $5C81


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S1Duty. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S1Duty_Tbl5C84::
    db $63, $84, $83, $88, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 3 bytes, bytes; referenced by DjPrintRow_S1Duty. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S1Duty_Tbl5C98::
    db $2c, $2e, $40

; C: SOUND I envelope line
DjPrintRow_S1Envelope::
    ld a, [wSound1Envelope]                       ; $5C9B
    ldh [hScratchA], a                            ; $5C9E
    ld a, [wSound1Envelope + $2]                  ; $5CA0
    ldh [hScratchB], a                            ; $5CA3
    ld a, [wSound1Envelope + $1]                  ; $5CA5
    ldh [hScratchC], a                            ; $5CA8
    ld a, [wSound1DutyLen + $1]                   ; $5CAA
    ldh [hScratchD], a                            ; $5CAD
    jp DjPrintRow_NsEnvelope_Build                ; $5CAF


; C: NOISE envelope line
DjPrintRow_NsEnvelope::
    ld a, [wNoiseEnvelope]                        ; $5CB2
    ldh [hScratchA], a                            ; $5CB5
    ld a, [wNoiseEnvelope + $2]                   ; $5CB7
    ldh [hScratchB], a                            ; $5CBA
    ld a, [wNoiseEnvelope + $1]                   ; $5CBC
    ldh [hScratchC], a                            ; $5CBF
    ld a, [wNoiseGateLoop]                        ; $5CC1
    ldh [hScratchD], a                            ; $5CC4
    jp DjPrintRow_NsEnvelope_Build                ; $5CC6


; C: shared tail of the two envelope rows (callers 5CFB, 5D12): copies the template Tbl5D4A to $C480 and writes the
; step number, the dash and the envelope values (branch target; code read 2026-10-19)
DjPrintRow_NsEnvelope_Build::
    ld hl, DjPrintRow_NsEnvelope_Tbl5CFE          ; $5CC9
    ld de, wTextLineSrc                           ; $5CCC
    ld b, $14                                     ; $5CCF

jr_005_5cd1:
    ld a, [hl+]                                   ; $5CD1
    ld [de], a                                    ; $5CD2
    inc e                                         ; $5CD3
    dec b                                         ; $5CD4
    jr nz, jr_005_5cd1                            ; $5CD5

    ld de, wTextLineSrc + $5                      ; $5CD7
    ldh a, [hScratchA]                            ; $5CDA
    add $42                                       ; $5CDC
    ld [de], a                                    ; $5CDE
    inc de                                        ; $5CDF
    call DjPrint_PutDash                          ; $5CE0
    ldh a, [hScratchB]                            ; $5CE3
    call DjPrint_PutNumber2                       ; $5CE5
    call DjPrint_PutDash                          ; $5CE8
    ldh a, [hScratchC]                            ; $5CEB
    call DjPrint_PutDigitOrBlank                  ; $5CED
    call DjPrint_PutDash                          ; $5CF0
    ldh a, [hScratchD]                            ; $5CF3
    call DjPrint_PutDigitOrBlank                  ; $5CF5
    ld hl, wTextLineSrc                           ; $5CF8
    jp DjPrint_RenderTextRow                      ; $5CFB


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsEnvelope. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsEnvelope_Tbl5CFE::
    db $64, $6d, $85, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND II wave pattern line
DjPrintRow_S2WavePattern::
    ld hl, DjPrintRow_S2WavePattern_Tbl5D2F       ; $5D12
    ld de, wTextLineSrc                           ; $5D15
    ld b, $14                                     ; $5D18

jr_005_5d1a:
    ld a, [hl+]                                   ; $5D1A
    ld [de], a                                    ; $5D1B
    inc e                                         ; $5D1C
    dec b                                         ; $5D1D
    jr nz, jr_005_5d1a                            ; $5D1E

    ld de, wTextLineSrc + $5                      ; $5D20
    ld a, [wSound2WaveLen + $1]                   ; $5D23
    call DjPrint_PutDigitOrBlank                  ; $5D26
    ld hl, wTextLineSrc                           ; $5D29
    jp DjPrint_RenderTextRow                      ; $5D2C


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2WavePattern. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WavePattern_Tbl5D2F::
    db $64, $6d, $85, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND I modulation line
DjPrintRow_S1Modulation::
    ld a, [wSound1Modulation]                     ; $5D43
    ldh [hScratchA], a                            ; $5D46
    ld a, [wSound1Modulation + $1]                ; $5D48
    ldh [hScratchB], a                            ; $5D4B
    ld a, [wSound1Modulation + $2]                ; $5D4D
    ldh [hScratchC], a                            ; $5D50
    jp DjPrintRow_S2Modulation_Build              ; $5D52


; C: SOUND II modulation line
DjPrintRow_S2Modulation::
    ld a, [wSound2Modulation]                     ; $5D55
    ldh [hScratchA], a                            ; $5D58
    ld a, [wSound2Modulation + $1]                ; $5D5A
    ldh [hScratchB], a                            ; $5D5D
    ld a, [wSound2Modulation + $2]                ; $5D5F
    ldh [hScratchC], a                            ; $5D62
    jp DjPrintRow_S2Modulation_Build              ; $5D64


; C: shared tail of the two modulation rows (callers 5D9E, 5DB0): copies the template Tbl5DE8 to $C480, then the
; numbers with DjPrint_PutNumber2 / DjPrint_PutDash (branch target; code read 2026-10-19)
DjPrintRow_S2Modulation_Build::
    ld hl, DjPrintRow_S2Modulation_Tbl5D9C        ; $5D67
    ld de, wTextLineSrc                           ; $5D6A
    ld b, $14                                     ; $5D6D

jr_005_5d6f:
    ld a, [hl+]                                   ; $5D6F
    ld [de], a                                    ; $5D70
    inc e                                         ; $5D71
    dec b                                         ; $5D72
    jr nz, jr_005_5d6f                            ; $5D73

    ld de, wTextLineSrc + $5                      ; $5D75
    ldh a, [hScratchA]                            ; $5D78
    call DjPrint_PutNumber2                       ; $5D7A
    call DjPrint_PutDash                          ; $5D7D
    ldh a, [hScratchB]                            ; $5D80
    call DjPrint_PutNumber2                       ; $5D82
    call DjPrint_PutDash                          ; $5D85
    ldh a, [hScratchC]                            ; $5D88
    ld c, a                                       ; $5D8A
    ld b, $00                                     ; $5D8B
    ld hl, DjPrintRow_S2Modulation_Tbl5DB0        ; $5D8D
    add hl, bc                                    ; $5D90
    ld a, [hl]                                    ; $5D91
    ld [de], a                                    ; $5D92
    inc de                                        ; $5D93
    inc a                                         ; $5D94
    ld [de], a                                    ; $5D95
    ld hl, wTextLineSrc                           ; $5D96
    jp DjPrint_RenderTextRow                      ; $5D99


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2Modulation. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2Modulation_Tbl5D9C::
    db $6c, $6e, $63, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 3 bytes, bytes; referenced by DjPrintRow_S2Modulation. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2Modulation_Tbl5DB0::
    db $46, $44, $4a

; C: SOUND I loop length line
DjPrintRow_S1Loop::
    ld a, [wLoopLengths]                          ; $5DB3
    ldh [hScratchA], a                            ; $5DB6
    jp DjPrintRow_NsLoop_Build                    ; $5DB8


; C: SOUND II loop length line
DjPrintRow_S2Loop::
    ld a, [wLoopLengths + $1]                     ; $5DBB
    ldh [hScratchA], a                            ; $5DBE
    jp DjPrintRow_NsLoop_Build                    ; $5DC0


; C: NOISE loop length line
DjPrintRow_NsLoop::
    ld a, [wNoiseGateLoop + $1]                   ; $5DC3
    ldh [hScratchA], a                            ; $5DC6
    jp DjPrintRow_NsLoop_Build                    ; $5DC8


; C: shared tail of the three loop rows (callers 5E04, 5E0C, 5E14): template Tbl5E33 to $C480, step number, then
; DjPrint_RenderTextRow (branch target; code read 2026-10-19)
DjPrintRow_NsLoop_Build::
    ld hl, DjPrintRow_NsLoop_Tbl5DE7              ; $5DCB
    ld de, wTextLineSrc                           ; $5DCE
    ld b, $14                                     ; $5DD1

jr_005_5dd3:
    ld a, [hl+]                                   ; $5DD3
    ld [de], a                                    ; $5DD4
    inc e                                         ; $5DD5
    dec b                                         ; $5DD6
    jr nz, jr_005_5dd3                            ; $5DD7

    ld de, wTextLineSrc + $5                      ; $5DD9
    ldh a, [hScratchA]                            ; $5DDC
    call DjPrint_PutNumber2                       ; $5DDE
    ld hl, wTextLineSrc                           ; $5DE1
    jp DjPrint_RenderTextRow                      ; $5DE4


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsLoop. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsLoop_Tbl5DE7::
    db $6b, $6e, $6e, $6f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: tempo line
DjPrintRow_Tempo::
    ld hl, DjPrintRow_Tempo_Tbl5E18               ; $5DFB
    ld de, wTextLineSrc                           ; $5DFE
    ld b, $14                                     ; $5E01

jr_005_5e03:
    ld a, [hl+]                                   ; $5E03
    ld [de], a                                    ; $5E04
    inc e                                         ; $5E05
    dec b                                         ; $5E06
    jr nz, jr_005_5e03                            ; $5E07

    ld de, wTextLineSrc + $6                      ; $5E09
    ld a, [wTempo]                                ; $5E0C
    call DjPrint_PutTempo                         ; $5E0F
    ld hl, wTextLineSrc                           ; $5E12
    jp DjPrint_RenderTextRow                      ; $5E15


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Tempo. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Tempo_Tbl5E18::
    db $83, $64, $6c, $6f, $6e, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND II wave title line. L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WaveTitle::
    ld hl, DjPrintRow_S2WaveTitle_Tbl5E5E         ; $5E2C
    ld de, wTextLineSrc                           ; $5E2F
    ld b, $14                                     ; $5E32

jr_005_5e34:
    ld a, [hl+]                                   ; $5E34
    ld [de], a                                    ; $5E35
    inc e                                         ; $5E36
    dec b                                         ; $5E37
    jr nz, jr_005_5e34                            ; $5E38

    ld de, wTextLineSrc + $5                      ; $5E3A
    ld a, [wSound2WaveLen]                        ; $5E3D
    cp $02                                        ; $5E40
    jr z, jr_005_5e58                             ; $5E42

    ld c, a                                       ; $5E44
    ld b, $00                                     ; $5E45
    ld hl, DjPrintRow_S2WaveTitle_Tbl5E72         ; $5E47
    add hl, bc                                    ; $5E4A
    ld a, [hl]                                    ; $5E4B
    ld [de], a                                    ; $5E4C
    inc de                                        ; $5E4D
    inc a                                         ; $5E4E
    ld [de], a                                    ; $5E4F
    ld a, [wPerfPrintRow]                         ; $5E50
    add $04                                       ; $5E53
    ld [wPerfPrintRow], a                         ; $5E55

jr_005_5e58:
    ld hl, wTextLineSrc                           ; $5E58
    jp DjPrint_RenderTextRow                      ; $5E5B


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2WaveTitle. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WaveTitle_Tbl5E5E::
    db $86, $60, $85, $64, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 2 bytes, bytes; referenced by DjPrintRow_S2WaveTitle. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: second table of DjPrintRow_S2WaveTitle (the first,
; Tbl5EAA, was read by the D.J. print in BGB)
DjPrintRow_S2WaveTitle_Tbl5E72::
    dw $4844

; C: wave graph band 0 (never run until the printer runs)
DjPrintRow_S2WaveGraph0::
    call DjPrint_ClearBand                        ; $5E74
    call DjPrint_DrawRuler                        ; $5E77
    ld hl, wBandBuffer + $20                      ; $5E7A
    call DjPrint_FillCol                          ; $5E7D
    ld hl, wBandBuffer + $16e                     ; $5E80
    call DjPrint_FillRow                          ; $5E83
    ld de, wSound2UserWave                        ; $5E86
    ld hl, wBandBuffer + $20                      ; $5E89
    ld b, $10                                     ; $5E8C

jr_005_5e8e:
    ld a, [de]                                    ; $5E8E
    inc de                                        ; $5E8F
    cp $0c                                        ; $5E90
    jr c, jr_005_5e9b                             ; $5E92

    sub $0b                                       ; $5E94
    ld c, $e0                                     ; $5E96
    call DjPrint_PlotBars4                        ; $5E98

jr_005_5e9b:
    ld a, [de]                                    ; $5E9B
    inc de                                        ; $5E9C
    cp $0c                                        ; $5E9D
    jr c, jr_005_5ea8                             ; $5E9F

    sub $0b                                       ; $5EA1
    ld c, $0e                                     ; $5EA3
    call DjPrint_PlotBars4                        ; $5EA5

jr_005_5ea8:
    ld a, l                                       ; $5EA8
    add $10                                       ; $5EA9
    ld l, a                                       ; $5EAB
    jr nc, jr_005_5eaf                            ; $5EAC

    inc h                                         ; $5EAE

jr_005_5eaf:
    dec b                                         ; $5EAF
    jr nz, jr_005_5e8e                            ; $5EB0

    ret                                           ; $5EB2


; C
DjPrintRow_S2WaveGraph1::
    call DjPrint_ClearBand                        ; $5EB3
    call DjPrint_DrawRuler                        ; $5EB6
    ld hl, wBandBuffer + $16f                     ; $5EB9
    call DjPrint_FillRow                          ; $5EBC
    ld de, wSound2UserWave                        ; $5EBF
    ld hl, wBandBuffer + $20                      ; $5EC2
    ld b, $10                                     ; $5EC5

jr_005_5ec7:
    ld a, [de]                                    ; $5EC7
    inc de                                        ; $5EC8
    cp $08                                        ; $5EC9
    jr c, jr_005_5ed4                             ; $5ECB

    sub $07                                       ; $5ECD
    ld c, $e0                                     ; $5ECF
    call DjPrint_PlotBars4                        ; $5ED1

jr_005_5ed4:
    ld a, [de]                                    ; $5ED4
    inc de                                        ; $5ED5
    cp $08                                        ; $5ED6
    jr c, jr_005_5ee1                             ; $5ED8

    sub $07                                       ; $5EDA
    ld c, $0e                                     ; $5EDC
    call DjPrint_PlotBars4                        ; $5EDE

jr_005_5ee1:
    ld a, l                                       ; $5EE1
    add $10                                       ; $5EE2
    ld l, a                                       ; $5EE4
    jr nc, jr_005_5ee8                            ; $5EE5

    inc h                                         ; $5EE7

jr_005_5ee8:
    dec b                                         ; $5EE8
    jr nz, jr_005_5ec7                            ; $5EE9

    ret                                           ; $5EEB


; C
DjPrintRow_S2WaveGraph2::
    call DjPrint_ClearBand                        ; $5EEC
    call DjPrint_DrawRuler                        ; $5EEF
    ld hl, wBandBuffer + $16e                     ; $5EF2
    call DjPrint_FillRow                          ; $5EF5
    ld de, wSound2UserWave                        ; $5EF8
    ld hl, wBandBuffer + $20                      ; $5EFB
    ld b, $10                                     ; $5EFE

jr_005_5f00:
    ld a, [de]                                    ; $5F00
    inc de                                        ; $5F01
    cp $08                                        ; $5F02
    jr nc, jr_005_5f0e                            ; $5F04

    cpl                                           ; $5F06
    add $09                                       ; $5F07
    ld c, $e0                                     ; $5F09
    call DjPrint_PlotBars4B                       ; $5F0B

jr_005_5f0e:
    ld a, [de]                                    ; $5F0E
    inc de                                        ; $5F0F
    cp $08                                        ; $5F10
    jr nc, jr_005_5f1c                            ; $5F12

    cpl                                           ; $5F14
    add $09                                       ; $5F15
    ld c, $0e                                     ; $5F17
    call DjPrint_PlotBars4B                       ; $5F19

jr_005_5f1c:
    ld a, l                                       ; $5F1C
    add $10                                       ; $5F1D
    ld l, a                                       ; $5F1F
    jr nc, jr_005_5f23                            ; $5F20

    inc h                                         ; $5F22

jr_005_5f23:
    dec b                                         ; $5F23
    jr nz, jr_005_5f00                            ; $5F24

    ret                                           ; $5F26


; C
DjPrintRow_S2WaveGraph3::
    call DjPrint_ClearBand                        ; $5F27
    call DjPrint_DrawRuler                        ; $5F2A
    ld hl, wBandBuffer + $16e                     ; $5F2D
    call DjPrint_FillCol                          ; $5F30
    ld de, wSound2UserWave                        ; $5F33
    ld hl, wBandBuffer + $20                      ; $5F36
    ld b, $10                                     ; $5F39

jr_005_5f3b:
    ld a, [de]                                    ; $5F3B
    inc de                                        ; $5F3C
    cp $04                                        ; $5F3D
    jr nc, jr_005_5f49                            ; $5F3F

    cpl                                           ; $5F41
    add $05                                       ; $5F42
    ld c, $e0                                     ; $5F44
    call DjPrint_PlotBars4B                       ; $5F46

jr_005_5f49:
    ld a, [de]                                    ; $5F49
    inc de                                        ; $5F4A
    cp $04                                        ; $5F4B
    jr nc, jr_005_5f57                            ; $5F4D

    cpl                                           ; $5F4F
    add $05                                       ; $5F50
    ld c, $0e                                     ; $5F52
    call DjPrint_PlotBars4B                       ; $5F54

jr_005_5f57:
    ld a, l                                       ; $5F57
    add $10                                       ; $5F58
    ld l, a                                       ; $5F5A
    jr nc, jr_005_5f5e                            ; $5F5B

    inc h                                         ; $5F5D

jr_005_5f5e:
    dec b                                         ; $5F5E
    jr nz, jr_005_5f3b                            ; $5F5F

    ret                                           ; $5F61


; C: clears the 20x2 tile band buffer
DjPrint_ClearBand::
    xor a                                         ; $5F62
    ld hl, wBandBuffer                            ; $5F63
    ld b, $a0                                     ; $5F66

jr_005_5f68:
    ld [hl+], a                                   ; $5F68
    ld [hl+], a                                   ; $5F69
    ld [hl+], a                                   ; $5F6A
    ld [hl+], a                                   ; $5F6B
    dec b                                         ; $5F6C
    jr nz, jr_005_5f68                            ; $5F6D

    ret                                           ; $5F6F


; C: ruler marks in the band
DjPrint_DrawRuler::
    ld a, $01                                     ; $5F70
    ld hl, wBandBuffer + $10                      ; $5F72
    call DjPrint_RulerLong                        ; $5F75
    ld hl, wBandBuffer + $50                      ; $5F78
    call DjPrint_RulerShort                       ; $5F7B
    ld hl, wBandBuffer + $91                      ; $5F7E
    call DjPrint_RulerShort                       ; $5F81
    ld hl, wBandBuffer + $d0                      ; $5F84
    call DjPrint_RulerShort                       ; $5F87
    ld hl, wBandBuffer + $110                     ; $5F8A

; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_RulerLong::
    ld b, $08                                     ; $5F8D

jr_005_5f8f:
    ld [hl+], a                                   ; $5F8F
    ld [hl+], a                                   ; $5F90
    dec b                                         ; $5F91
    jr nz, jr_005_5f8f                            ; $5F92

    ld bc, $0130                                  ; $5F94
    add hl, bc                                    ; $5F97
    ld b, $08                                     ; $5F98

jr_005_5f9a:
    ld [hl+], a                                   ; $5F9A
    ld [hl+], a                                   ; $5F9B
    dec b                                         ; $5F9C
    jr nz, jr_005_5f9a                            ; $5F9D

    ret                                           ; $5F9F


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_RulerShort::
    ld b, $08                                     ; $5FA0

jr_005_5fa2:
    ld [hl+], a                                   ; $5FA2
    inc hl                                        ; $5FA3
    dec b                                         ; $5FA4
    jr nz, jr_005_5fa2                            ; $5FA5

    ld bc, $0130                                  ; $5FA7
    add hl, bc                                    ; $5FAA
    ld b, $08                                     ; $5FAB

jr_005_5fad:
    ld [hl+], a                                   ; $5FAD
    inc hl                                        ; $5FAE
    dec b                                         ; $5FAF
    jr nz, jr_005_5fad                            ; $5FB0

    ret                                           ; $5FB2


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_FillCol::
    ld a, $ff                                     ; $5FB3
    ld de, $000f                                  ; $5FB5
    ld b, $10                                     ; $5FB8

jr_005_5fba:
    ld [hl+], a                                   ; $5FBA
    ld [hl], a                                    ; $5FBB
    add hl, de                                    ; $5FBC
    dec b                                         ; $5FBD
    jr nz, jr_005_5fba                            ; $5FBE

    ret                                           ; $5FC0


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_FillRow::
    ld a, $ff                                     ; $5FC1
    ld de, $0010                                  ; $5FC3
    ld b, $10                                     ; $5FC6

jr_005_5fc8:
    ld [hl], a                                    ; $5FC8
    add hl, de                                    ; $5FC9
    dec b                                         ; $5FCA
    jr nz, jr_005_5fc8                            ; $5FCB

    ret                                           ; $5FCD


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PlotBars4::
    push de                                       ; $5FCE
    cp $04                                        ; $5FCF
    jr c, jr_005_5fd8                             ; $5FD1

    push hl                                       ; $5FD3
    call DjPrint_OrC3                             ; $5FD4
    pop hl                                        ; $5FD7

jr_005_5fd8:
    cp $03                                        ; $5FD8
    jr c, jr_005_5fe5                             ; $5FDA

    push hl                                       ; $5FDC
    ld de, $0008                                  ; $5FDD
    add hl, de                                    ; $5FE0
    call DjPrint_OrC3                             ; $5FE1
    pop hl                                        ; $5FE4

jr_005_5fe5:
    cp $02                                        ; $5FE5
    jr c, jr_005_5ff2                             ; $5FE7

    push hl                                       ; $5FE9
    ld de, $0140                                  ; $5FEA
    add hl, de                                    ; $5FED
    call DjPrint_OrC3                             ; $5FEE
    pop hl                                        ; $5FF1

jr_005_5ff2:
    cp $01                                        ; $5FF2
    jr c, jr_005_5fff                             ; $5FF4

    push hl                                       ; $5FF6
    ld de, HeaderROMSize                          ; $5FF7
    add hl, de                                    ; $5FFA
    call DjPrint_OrC3                             ; $5FFB
    pop hl                                        ; $5FFE

jr_005_5fff:
    pop de                                        ; $5FFF
    ret                                           ; $6000


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PlotBars4B::
    push de                                       ; $6001
    cp $04                                        ; $6002
    jr c, jr_005_600f                             ; $6004

    push hl                                       ; $6006
    ld de, HeaderROMSize                          ; $6007
    add hl, de                                    ; $600A
    call DjPrint_OrC3                             ; $600B
    pop hl                                        ; $600E

jr_005_600f:
    cp $03                                        ; $600F
    jr c, jr_005_601c                             ; $6011

    push hl                                       ; $6013
    ld de, $0140                                  ; $6014
    add hl, de                                    ; $6017
    call DjPrint_OrC3                             ; $6018
    pop hl                                        ; $601B

jr_005_601c:
    cp $02                                        ; $601C
    jr c, jr_005_6029                             ; $601E

    push hl                                       ; $6020
    ld de, $0008                                  ; $6021
    add hl, de                                    ; $6024
    call DjPrint_OrC3                             ; $6025
    pop hl                                        ; $6028

jr_005_6029:
    cp $01                                        ; $6029
    jr c, jr_005_6032                             ; $602B

    push hl                                       ; $602D
    call DjPrint_OrC3                             ; $602E
    pop hl                                        ; $6031

jr_005_6032:
    pop de                                        ; $6032
    ret                                           ; $6033


; C: ORs C into three bytes at HL. L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_OrC3::
    ld a, [hl]                                    ; $6034
    or c                                          ; $6035
    ld [hl+], a                                   ; $6036
    ld a, [hl]                                    ; $6037
    or c                                          ; $6038
    ld [hl+], a                                   ; $6039
    ld a, [hl]                                    ; $603A
    or c                                          ; $603B
    ld [hl+], a                                   ; $603C
    ld a, [hl]                                    ; $603D
    or c                                          ; $603E
    ld [hl+], a                                   ; $603F
    ld a, [hl]                                    ; $6040
    or c                                          ; $6041
    ld [hl+], a                                   ; $6042
    ld a, [hl]                                    ; $6043
    or c                                          ; $6044
    ld [hl+], a                                   ; $6045
    ret                                           ; $6046


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutDash::
    ld a, $30                                     ; $6047
    ld [de], a                                    ; $6049
    inc de                                        ; $604A
    ret                                           ; $604B


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutDigitOrBlank::
    and a                                         ; $604C
    jr nz, jr_005_6054                            ; $604D

    ld a, $4d                                     ; $604F
    ld [de], a                                    ; $6051
    inc de                                        ; $6052
    ret                                           ; $6053


jr_005_6054:
    add $21                                       ; $6054
    ld [de], a                                    ; $6056
    inc de                                        ; $6057
    ret                                           ; $6058


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutNumber2::
    ld c, $00                                     ; $6059

jr_005_605b:
    cp $0a                                        ; $605B
    jr c, jr_005_6064                             ; $605D

    sub $0a                                       ; $605F
    inc c                                         ; $6061
    jr jr_005_605b                                ; $6062

jr_005_6064:
    push af                                       ; $6064
    ld a, c                                       ; $6065
    and a                                         ; $6066
    jr z, jr_005_606d                             ; $6067

    add $21                                       ; $6069
    ld [de], a                                    ; $606B
    inc de                                        ; $606C

jr_005_606d:
    pop af                                        ; $606D
    add $21                                       ; $606E
    ld [de], a                                    ; $6070
    inc de                                        ; $6071
    ret                                           ; $6072


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutTempo::
    ld bc, $0000                                  ; $6073

jr_005_6076:
    cp $64                                        ; $6076
    jr c, jr_005_607f                             ; $6078

    sub $64                                       ; $607A
    inc b                                         ; $607C
    jr jr_005_6076                                ; $607D

jr_005_607f:
    cp $0a                                        ; $607F
    jr c, jr_005_6088                             ; $6081

    sub $0a                                       ; $6083
    inc c                                         ; $6085
    jr jr_005_607f                                ; $6086

jr_005_6088:
    push af                                       ; $6088
    ld a, b                                       ; $6089
    and a                                         ; $608A
    jr z, jr_005_6094                             ; $608B

    add $21                                       ; $608D
    ld [de], a                                    ; $608F
    inc de                                        ; $6090
    ld a, c                                       ; $6091
    jr jr_005_6098                                ; $6092

jr_005_6094:
    ld a, c                                       ; $6094
    and a                                         ; $6095
    jr z, jr_005_609c                             ; $6096

jr_005_6098:
    add $21                                       ; $6098
    ld [de], a                                    ; $609A
    inc de                                        ; $609B

jr_005_609c:
    pop af                                        ; $609C
    add $21                                       ; $609D
    ld [de], a                                    ; $609F
    inc de                                        ; $60A0
    ret                                           ; $60A1


; C: HL = 20-character row of print glyph codes: expands it into the band at $C200 (space, digit, $4F/$9F, $F0+
; cases); entry used by every DjPrintRow_* builder (branch target; code read 2026-10-19)
DjPrint_RenderTextRow::
    ld de, wBandBuffer                            ; $60A2
    ld b, $14                                     ; $60A5

; C: per-character loop top of DjPrint_RenderTextRow (B counts the 20 characters) (branch target; code read
; 2026-10-19)
DjPrint_RenderTextRow_CharLoop::
    ld a, [hl+]                                   ; $60A7
    cp $20                                        ; $60A8
    jr z, jr_005_60dc                             ; $60AA

    cp $30                                        ; $60AC
    jr z, jr_005_60f6                             ; $60AE

    cp $5f                                        ; $60B0
    jr z, jr_005_60f6                             ; $60B2

    cp $4f                                        ; $60B4
    jr z, jr_005_6112                             ; $60B6

    cp $9f                                        ; $60B8
    jr z, jr_005_6112                             ; $60BA

    cp $f0                                        ; $60BC
    jr nc, jr_005_612c                            ; $60BE

    push af                                       ; $60C0
    call Gfx_Copy16FromBank10                     ; $60C1
    ld a, e                                       ; $60C4
    add $30                                       ; $60C5
    ld e, a                                       ; $60C7
    ld a, d                                       ; $60C8
    adc $01                                       ; $60C9
    ld d, a                                       ; $60CB
    pop af                                        ; $60CC
    add $10                                       ; $60CD
    call Gfx_Copy16FromBank10                     ; $60CF
    ld a, e                                       ; $60D2
    sub $40                                       ; $60D3
    ld e, a                                       ; $60D5
    ld a, d                                       ; $60D6
    sbc $01                                       ; $60D7
    ld d, a                                       ; $60D9
    jr jr_005_6155                                ; $60DA

jr_005_60dc:
    call Gfx_Copy16FromBank10                     ; $60DC
    ld a, e                                       ; $60DF
    add $30                                       ; $60E0
    ld e, a                                       ; $60E2
    ld a, d                                       ; $60E3
    adc $01                                       ; $60E4
    ld d, a                                       ; $60E6
    ld a, $9f                                     ; $60E7
    call Gfx_Copy16FromBank10                     ; $60E9
    ld a, e                                       ; $60EC
    sub $40                                       ; $60ED
    ld e, a                                       ; $60EF
    ld a, d                                       ; $60F0
    sbc $01                                       ; $60F1
    ld d, a                                       ; $60F3
    jr jr_005_6155                                ; $60F4

jr_005_60f6:
    push af                                       ; $60F6
    ld a, $9f                                     ; $60F7
    call Gfx_Copy16FromBank10                     ; $60F9
    ld a, e                                       ; $60FC
    add $30                                       ; $60FD
    ld e, a                                       ; $60FF
    ld a, d                                       ; $6100
    adc $01                                       ; $6101
    ld d, a                                       ; $6103
    pop af                                        ; $6104
    call Gfx_Copy16FromBank10                     ; $6105
    ld a, e                                       ; $6108
    sub $40                                       ; $6109
    ld e, a                                       ; $610B
    ld a, d                                       ; $610C
    sbc $01                                       ; $610D
    ld d, a                                       ; $610F
    jr jr_005_6155                                ; $6110

jr_005_6112:
    push af                                       ; $6112
    call Gfx_Copy16FromBank10                     ; $6113
    ld a, e                                       ; $6116
    add $30                                       ; $6117
    ld e, a                                       ; $6119
    ld a, d                                       ; $611A
    adc $01                                       ; $611B
    ld d, a                                       ; $611D
    pop af                                        ; $611E
    call Gfx_Copy16FromBank10                     ; $611F
    ld a, e                                       ; $6122
    sub $40                                       ; $6123
    ld e, a                                       ; $6125
    ld a, d                                       ; $6126
    sbc $01                                       ; $6127
    ld d, a                                       ; $6129
    jr jr_005_6155                                ; $612A

jr_005_612c:
    push bc                                       ; $612C
    push hl                                       ; $612D
    and $0f                                       ; $612E
    sla a                                         ; $6130
    ld c, a                                       ; $6132
    ld b, $00                                     ; $6133
    ld hl, DjPrint_PutTempo_Tbl615A               ; $6135
    add hl, bc                                    ; $6138
    ld a, [hl+]                                   ; $6139
    push hl                                       ; $613A
    call Gfx_Copy16FromBank10                     ; $613B
    ld a, e                                       ; $613E
    add $30                                       ; $613F
    ld e, a                                       ; $6141
    ld a, d                                       ; $6142
    adc $01                                       ; $6143
    ld d, a                                       ; $6145
    pop hl                                        ; $6146
    ld a, [hl]                                    ; $6147
    call Gfx_Copy16FromBank10                     ; $6148
    ld a, e                                       ; $614B
    sub $40                                       ; $614C
    ld e, a                                       ; $614E
    ld a, d                                       ; $614F
    sbc $01                                       ; $6150
    ld d, a                                       ; $6152
    pop hl                                        ; $6153
    pop bc                                        ; $6154

jr_005_6155:
    dec b                                         ; $6155
    jp nz, DjPrint_RenderTextRow_CharLoop         ; $6156

    ret                                           ; $6159


; C: auto: 32 bytes, bytes; referenced by DjPrint_PutTempo. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutTempo_Tbl615A::
    db $9f, $2b, $9f, $9f, $9f, $3b, $9f, $9f, $4c, $2b, $4c, $9f, $4c, $3b, $9f, $9f
    db $5c, $2b, $5c, $9f, $5c, $3b, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f

; I: toggles the double buffer and loads the performer tiles
DjTitle_LoadPerformerGfx::
    ld a, [wDjTitlePerformerToggle]               ; $617A
    inc a                                         ; $617D
    and $01                                       ; $617E
    ld [wDjTitlePerformerToggle], a               ; $6180
    call DjTitle_PickGraphicsBank                 ; $6183
    push af                                       ; $6186
    ld c, $00                                     ; $6187
    ldh [hFarcallAArg], a                         ; $6189
    ld a, BANK(Album_LoadNumeralTileB)            ; $618B
    ld hl, Album_LoadNumeralTileB_7CE3            ; $618D
    call Far_Call                                 ; $6190
    ld de, $8d80                                  ; $6193
    ld bc, $0380                                  ; $6196
    call Mem_CopyFromBank                         ; $6199
    pop af                                        ; $619C
    push af                                       ; $619D
    ld c, $01                                     ; $619E
    ldh [hFarcallAArg], a                         ; $61A0
    ld a, BANK(Album_LoadNumeralTileB)            ; $61A2
    ld hl, Album_LoadNumeralTileB_7CE3            ; $61A4
    call Far_Call                                 ; $61A7
    ld de, $9100                                  ; $61AA
    ld bc, $0380                                  ; $61AD
    call Mem_CopyFromBank                         ; $61B0
    pop af                                        ; $61B3
    ld c, $02                                     ; $61B4
    ldh [hFarcallAArg], a                         ; $61B6
    ld a, BANK(Album_LoadNumeralTileB)            ; $61B8
    ld hl, Album_LoadNumeralTileB_7CE3            ; $61BA
    call Far_Call                                 ; $61BD
    ld de, $9480                                  ; $61C0
    ld bc, $0380                                  ; $61C3
    call Mem_CopyFromBank                         ; $61C6
    ret                                           ; $61C9


; I
DjEd_LoadPerformerTiles8D80::
    call DjTitle_PickGraphicsBank                 ; $61CA
    ldh [hFarcallAArg], a                         ; $61CD
    ld a, BANK(Album_LoadNumeralTileB)            ; $61CF
    ld hl, Album_LoadNumeralTileB_7CE3            ; $61D1
    call Far_Call                                 ; $61D4
    ld de, $8d80                                  ; $61D7
    ld bc, $0380                                  ; $61DA
    call Vram_CopyFromBank_4                      ; $61DD
    ret                                           ; $61E0


; I: UNREFERENCED
Unused_DjEd_LoadPerformerTiles9100::
    call DjTitle_PickGraphicsBank                 ; $61E1
    ldh [hFarcallAArg], a                         ; $61E4
    ld a, BANK(Album_LoadNumeralTileB)            ; $61E6
    ld hl, Album_LoadNumeralTileB_7CE3            ; $61E8
    call Far_Call                                 ; $61EB
    ld de, $9100                                  ; $61EE
    ld bc, $0380                                  ; $61F1
    call Vram_CopyFromBank_4                      ; $61F4
    ret                                           ; $61F7


; I
DjEd_LoadPerformerTiles9480::
    call DjTitle_PickGraphicsBank                 ; $61F8
    ldh [hFarcallAArg], a                         ; $61FB
    ld a, BANK(Album_LoadNumeralTileB)            ; $61FD
    ld hl, Album_LoadNumeralTileB_7CE3            ; $61FF
    call Far_Call                                 ; $6202
    ld de, $9480                                  ; $6205
    ld bc, $0380                                  ; $6208
    call Vram_CopyFromBank_4                      ; $620B
    ret                                           ; $620E


; C: bank for the performer set (hidden Game Face set when present)
DjTitle_PickGraphicsBank::
    push bc                                       ; $620F
    ld a, [wStartPerformerSet]                    ; $6210
    cp $02                                        ; $6213
    jr nz, jr_005_6221                            ; $6215

    ld hl, wGamefacePresent                       ; $6217
    bit 0, [hl]                                   ; $621A
    jr nz, jr_005_6221                            ; $621C

    ld a, [wDjTitlePerformerToggle]               ; $621E

jr_005_6221:
    ld c, a                                       ; $6221
    ld b, $00                                     ; $6222
    ld hl, DjTitle_PickGraphicsBank_Tbl622B       ; $6224
    add hl, bc                                    ; $6227
    ld a, [hl]                                    ; $6228
    pop bc                                        ; $6229
    ret                                           ; $622A


; I: auto: 3 bytes, bytes; referenced by DjTitle_PickGraphicsBank. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjTitle_PickGraphicsBank_Tbl622B::
    db $01, $02, $08

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjEd_SetFieldCursor::
    ld c, a                                       ; $622E
    sla a                                         ; $622F
    add c                                         ; $6231
    ld c, a                                       ; $6232
    ld b, $00                                     ; $6233
    ld hl, DjEd_SetFieldCursor_Tbl6257            ; $6235
    add hl, bc                                    ; $6238
    ld c, [hl]                                    ; $6239
    inc hl                                        ; $623A
    ld b, [hl]                                    ; $623B
    inc hl                                        ; $623C
    ld a, [hl]                                    ; $623D
    ld h, b                                       ; $623E
    ld l, c                                       ; $623F
    ld de, wSettingsPreset                        ; $6240
    ld bc, $0059                                  ; $6243
    call Mem_CopyFromBank                         ; $6246
    ld de, wSettingsPreset                        ; $6249
    ldh [hFarcallAArg], a                         ; $624C
    farcall Dj_LoadTune_FromDE_Far                ; $624E
    ret                                           ; $6256


; I: auto: 15 bytes, bytes; referenced by DjEd_SetFieldCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjEd_SetFieldCursor_Tbl6257::
    dw Map_29_6164_Map05_6257 + $1A9C
    db BANK(Map_29_6164_Map05_6257)
    dw Map_29_6164_Map05_6257 + $1AF5
    db BANK(Map_29_6164_Map05_6257)
    dw Map_29_6164_Map05_6257 + $1C00
    db BANK(Map_29_6164_Map05_6257)
    dw Map_29_6164_Map05_6257 + $1BA7
    db BANK(Map_29_6164_Map05_6257)
    dw Map_29_6164_Map05_6257 + $1B4E
    db BANK(Map_29_6164_Map05_6257)

Call_005_6266:
    ld b, a                                       ; $6266
    ld a, [wTickFlag]                             ; $6267
    and a                                         ; $626A
    ld a, b                                       ; $626B
    jr nz, jr_005_6272                            ; $626C

    ld hl, wPerfStepIncrement                     ; $626E
    sub [hl]                                      ; $6271

jr_005_6272:
    bit 7, a                                      ; $6272
    jr z, jr_005_6278                             ; $6274

    ld a, c                                       ; $6276
    dec a                                         ; $6277

jr_005_6278:
    cp c                                          ; $6278
    jr c, jr_005_627c                             ; $6279

    xor a                                         ; $627B

jr_005_627c:
    ret                                           ; $627C


; C
DjS1_DrawAllValues::
    ld a, [wSound1Envelope + $2]                  ; $627D
    call DjEd_DrawVolumeDigits                    ; $6280
    ld a, [wSound1Envelope + $1]                  ; $6283
    call DjEd_DrawEnvPeriodDigit                  ; $6286
    ld a, [wSound1DutyLen + $1]                   ; $6289
    call DjEd_DrawLengthDigit                     ; $628C
    ld a, [wSound1Modulation]                     ; $628F
    call DjEd_DrawModDepthDigits                  ; $6292
    ld a, [wSound1Modulation + $1]                ; $6295
    call DjEd_DrawModSpeedDigits                  ; $6298
    ld a, [wLoopLengths]                          ; $629B
    call DjEd_DrawLoopDigitsAndPrint              ; $629E
    ret                                           ; $62A1


; C
DjS1_DrawModAndLoop::
    ld a, [wSound1Modulation]                     ; $62A2
    call DjEd_DrawModDepthDigits                  ; $62A5
    ld a, [wSound1Modulation + $1]                ; $62A8
    call DjEd_DrawModSpeedDigits                  ; $62AB
    ld a, [wLoopLengths]                          ; $62AE
    call DjEd_DrawLoopDigitsAndPrint              ; $62B1
    ret                                           ; $62B4


; C: handler of the DjS1 field cursor value 0
DjS1_Field00_Duty::
    call DjS1_Field00_SyncCursor                  ; $62B5
    call DjS1_Field00_Edit                        ; $62B8
    call DjS1_Field00_DrawCursor                  ; $62BB
    ldh a, [hKeysNew]                             ; $62BE
    bit PADB_RIGHT, a                             ; $62C0
    jr z, jr_005_62d8                             ; $62C2

    ui_sfx $01                                    ; $62C4
    call DjS1_Field00_DrawMarker                  ; $62CB
    ld a, $01                                     ; $62CE
    ld [wSound1FieldCursor], a                    ; $62D0
    xor a                                         ; $62D3
    ld [wSndCursorPopFrames], a                   ; $62D4
    ret                                           ; $62D7


jr_005_62d8:
    bit 7, a                                      ; $62D8
    ret z                                         ; $62DA

    ui_sfx $01                                    ; $62DB
    call DjS1_Field00_DrawMarker                  ; $62E2
    ld a, [wSound1FieldCursor]                    ; $62E5
    ld [wSound1FieldCursor + $2], a               ; $62E8
    ld a, $08                                     ; $62EB
    ld [wSound1FieldCursor], a                    ; $62ED
    xor a                                         ; $62F0
    ld [wSndCursorPopFrames], a                   ; $62F1
    ret                                           ; $62F4


; C
DjS1_Field00_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $62F5
    ld hl, wSound1FieldCursor + $1                ; $62F8
    cp [hl]                                       ; $62FB
    ret z                                         ; $62FC

    ld [hl], a                                    ; $62FD
    ld a, $51                                     ; $62FE
    ld hl, $9861                                  ; $6300
    call Vram_WriteByteSafe                       ; $6303
    ld a, $51                                     ; $6306
    ld hl, $9881                                  ; $6308
    call Vram_WriteByteSafe                       ; $630B
    ld a, $51                                     ; $630E
    ld hl, $98a1                                  ; $6310
    call Vram_WriteByteSafe                       ; $6313
    ret                                           ; $6316


; C
DjS1_Field00_Edit::
    ld a, [wSound1DutyLen]                        ; $6317
    ld bc, $0002                                  ; $631A
    call DjEd_StepValue_Up                        ; $631D
    ld hl, wSound1DutyLen                         ; $6320
    cp [hl]                                       ; $6323
    ret z                                         ; $6324

    ld [hl], a                                    ; $6325
    ret                                           ; $6326


; C
DjS1_Field00_DrawCursor::
    ld bc, $051c                                  ; $6327
    ld a, $92                                     ; $632A
    call DjEd_DrawFieldCursor                     ; $632C
    ldh a, [hFrameCounter]                        ; $632F
    bit 4, a                                      ; $6331
    ret z                                         ; $6333

    ld a, [wSound1DutyLen]                        ; $6334
    swap a                                        ; $6337
    srl a                                         ; $6339
    add $20                                       ; $633B
    ld c, a                                       ; $633D
    ld b, $09                                     ; $633E
    ld a, $79                                     ; $6340
    call Oam_AddMeta_B01_5D2B                     ; $6342
    ret                                           ; $6345


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the SOUND I duty marker (tile $C9 in the row of wSound1DutyLen)
DjS1_Field00_DrawMarker::
    ld a, [wSound1DutyLen]                        ; $6346
    swap a                                        ; $6349
    sla a                                         ; $634B
    ld c, a                                       ; $634D
    ld b, $00                                     ; $634E
    ld hl, $9861                                  ; $6350
    add hl, bc                                    ; $6353
    ld a, $c9                                     ; $6354
    call Vram_WriteByteSafe                       ; $6356
    ret                                           ; $6359


; C: handler of the DjS1 field cursor value 1
DjS1_Field01_EnvDir::
    call DjS1_Field01_SyncCursor                  ; $635A
    call DjS1_Field01_Edit                        ; $635D
    call DjS1_Field01_DrawCursor                  ; $6360
    ldh a, [hKeysNew]                             ; $6363
    bit PADB_LEFT, a                              ; $6365
    jr z, jr_005_637a                             ; $6367

    ui_sfx $01                                    ; $6369
    ld a, $00                                     ; $6370
    ld [wSound1FieldCursor], a                    ; $6372
    xor a                                         ; $6375
    ld [wSndCursorPopFrames], a                   ; $6376
    ret                                           ; $6379


jr_005_637a:
    bit 4, a                                      ; $637A
    jr z, jr_005_638b                             ; $637C

    ui_sfx $01                                    ; $637E
    ld a, $02                                     ; $6385
    ld [wSound1FieldCursor], a                    ; $6387
    ret                                           ; $638A


jr_005_638b:
    bit 7, a                                      ; $638B
    ret z                                         ; $638D

    ui_sfx $01                                    ; $638E
    ld a, [wSound1FieldCursor]                    ; $6395
    ld [wSound1FieldCursor + $2], a               ; $6398
    ld a, $08                                     ; $639B
    ld [wSound1FieldCursor], a                    ; $639D
    xor a                                         ; $63A0
    ld [wSndCursorPopFrames], a                   ; $63A1
    ret                                           ; $63A4


; C
DjS1_Field01_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $63A5
    ld hl, wSound1FieldCursor + $1                ; $63A8
    cp [hl]                                       ; $63AB
    ret z                                         ; $63AC

    ld [hl], a                                    ; $63AD
    ret                                           ; $63AE


; C
DjS1_Field01_Edit::
    ld a, [wSound1Envelope]                       ; $63AF
    ld bc, $0001                                  ; $63B2
    call DjEd_StepValue_Up                        ; $63B5
    ld hl, wSound1Envelope                        ; $63B8
    cp [hl]                                       ; $63BB
    ret z                                         ; $63BC

    ld [hl], a                                    ; $63BD
    ld hl, $9884                                  ; $63BE
    add $da                                       ; $63C1
    call Vram_WriteByteSafe                       ; $63C3
    ret                                           ; $63C6


; C
DjS1_Field01_DrawCursor::
    ld bc, $1c1c                                  ; $63C7
    ld a, $95                                     ; $63CA
    call DjEd_DrawFieldCursor                     ; $63CC
    ldh a, [hFrameCounter]                        ; $63CF
    bit 4, a                                      ; $63D1
    ret z                                         ; $63D3

    ld a, [wSound1Envelope]                       ; $63D4
    sla a                                         ; $63D7
    sla a                                         ; $63D9
    add $26                                       ; $63DB
    ld c, a                                       ; $63DD
    ld b, $22                                     ; $63DE
    ld a, $78                                     ; $63E0
    call Oam_AddMeta_B01_5D2B                     ; $63E2
    ret                                           ; $63E5


; C: handler of the DjS1 field cursor value 2
DjS1_Field02_Volume::
    call DjS1_Field02_SyncCursor                  ; $63E6
    call DjS1_Field02_Edit                        ; $63E9
    call DjS1_Field02_DrawCursor                  ; $63EC
    ldh a, [hKeysNew]                             ; $63EF
    bit PADB_LEFT, a                              ; $63F1
    jr z, jr_005_6402                             ; $63F3

    ui_sfx $01                                    ; $63F5
    ld a, $01                                     ; $63FC
    ld [wSound1FieldCursor], a                    ; $63FE
    ret                                           ; $6401


jr_005_6402:
    bit 4, a                                      ; $6402
    jr z, jr_005_6413                             ; $6404

    ui_sfx $01                                    ; $6406
    ld a, $03                                     ; $640D
    ld [wSound1FieldCursor], a                    ; $640F
    ret                                           ; $6412


jr_005_6413:
    bit 7, a                                      ; $6413
    ret z                                         ; $6415

    ui_sfx $01                                    ; $6416
    ld a, [wSound1FieldCursor]                    ; $641D
    ld [wSound1FieldCursor + $2], a               ; $6420
    ld a, $08                                     ; $6423
    ld [wSound1FieldCursor], a                    ; $6425
    xor a                                         ; $6428
    ld [wSndCursorPopFrames], a                   ; $6429
    ret                                           ; $642C


; C
DjS1_Field02_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $642D
    ld hl, wSound1FieldCursor + $1                ; $6430
    cp [hl]                                       ; $6433
    ret z                                         ; $6434

    ld [hl], a                                    ; $6435
    ret                                           ; $6436


; C
DjS1_Field02_Edit::
    ld a, [wSound1Envelope + $2]                  ; $6437
    ld bc, $000f                                  ; $643A
    call DjEd_StepValue_Right                     ; $643D
    ld hl, wSound1Envelope + $2                   ; $6440
    cp [hl]                                       ; $6443
    ret z                                         ; $6444

    ld [hl], a                                    ; $6445
    ret                                           ; $6446


; C
DjS1_Field02_DrawCursor::
    ld bc, $1c1c                                  ; $6447
    ld a, $95                                     ; $644A
    call DjEd_DrawFieldCursor                     ; $644C
    ldh a, [hFrameCounter]                        ; $644F
    bit 4, a                                      ; $6451
    ret z                                         ; $6453

    ld bc, $312c                                  ; $6454
    ld a, $7d                                     ; $6457
    call Oam_AddMeta_B01_5D2B                     ; $6459
    ret                                           ; $645C


; C: handler of the DjS1 field cursor value 3
DjS1_Field03_EnvPeriod::
    call DjS1_Field03_SyncCursor                  ; $645D
    call DjS1_Field03_Edit                        ; $6460
    call DjS1_Field03_DrawCursor                  ; $6463
    ldh a, [hKeysNew]                             ; $6466
    bit PADB_LEFT, a                              ; $6468
    jr z, jr_005_6479                             ; $646A

    ui_sfx $01                                    ; $646C
    ld a, $02                                     ; $6473
    ld [wSound1FieldCursor], a                    ; $6475
    ret                                           ; $6478


jr_005_6479:
    bit 4, a                                      ; $6479
    jr z, jr_005_648a                             ; $647B

    ui_sfx $01                                    ; $647D
    ld a, $04                                     ; $6484
    ld [wSound1FieldCursor], a                    ; $6486
    ret                                           ; $6489


jr_005_648a:
    bit 7, a                                      ; $648A
    ret z                                         ; $648C

    ui_sfx $01                                    ; $648D
    ld a, [wSound1FieldCursor]                    ; $6494
    ld [wSound1FieldCursor + $2], a               ; $6497
    ld a, $08                                     ; $649A
    ld [wSound1FieldCursor], a                    ; $649C
    xor a                                         ; $649F
    ld [wSndCursorPopFrames], a                   ; $64A0
    ret                                           ; $64A3


; C
DjS1_Field03_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $64A4
    ld hl, wSound1FieldCursor + $1                ; $64A7
    cp [hl]                                       ; $64AA
    ret z                                         ; $64AB

    ld [hl], a                                    ; $64AC
    ret                                           ; $64AD


; C
DjS1_Field03_Edit::
    ld a, [wSound1Envelope + $1]                  ; $64AE
    ld bc, $0007                                  ; $64B1
    call DjEd_StepValue_Right                     ; $64B4
    ld hl, wSound1Envelope + $1                   ; $64B7
    cp [hl]                                       ; $64BA
    ret z                                         ; $64BB

    ld [hl], a                                    ; $64BC
    ret                                           ; $64BD


; C
DjS1_Field03_DrawCursor::
    ld bc, $1c1c                                  ; $64BE
    ld a, $95                                     ; $64C1
    call DjEd_DrawFieldCursor                     ; $64C3
    ldh a, [hFrameCounter]                        ; $64C6
    bit 4, a                                      ; $64C8
    ret z                                         ; $64CA

    ld bc, $422c                                  ; $64CB
    ld a, $7d                                     ; $64CE
    call Oam_AddMeta_B01_5D2B                     ; $64D0
    ret                                           ; $64D3


; C: handler of the DjS1 field cursor value 4
DjS1_Field04_Length::
    call DjS1_Field04_SyncCursor                  ; $64D4
    call DjS1_Field04_Edit                        ; $64D7
    call DjS1_Field04_DrawCursor                  ; $64DA
    ldh a, [hKeysNew]                             ; $64DD
    bit PADB_LEFT, a                              ; $64DF
    jr z, jr_005_64f0                             ; $64E1

    ui_sfx $01                                    ; $64E3
    ld a, $03                                     ; $64EA
    ld [wSound1FieldCursor], a                    ; $64EC
    ret                                           ; $64EF


jr_005_64f0:
    bit 4, a                                      ; $64F0
    jr z, jr_005_6505                             ; $64F2

    ui_sfx $01                                    ; $64F4
    ld a, $05                                     ; $64FB
    ld [wSound1FieldCursor], a                    ; $64FD
    xor a                                         ; $6500
    ld [wSndCursorPopFrames], a                   ; $6501
    ret                                           ; $6504


jr_005_6505:
    bit 7, a                                      ; $6505
    ret z                                         ; $6507

    ui_sfx $01                                    ; $6508
    ld a, [wSound1FieldCursor]                    ; $650F
    ld [wSound1FieldCursor + $2], a               ; $6512
    ld a, $08                                     ; $6515
    ld [wSound1FieldCursor], a                    ; $6517
    xor a                                         ; $651A
    ld [wSndCursorPopFrames], a                   ; $651B
    ret                                           ; $651E


; C
DjS1_Field04_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $651F
    ld hl, wSound1FieldCursor + $1                ; $6522
    cp [hl]                                       ; $6525
    ret z                                         ; $6526

    ld [hl], a                                    ; $6527
    ret                                           ; $6528


; C
DjS1_Field04_Edit::
    ld a, [wSound1DutyLen + $1]                   ; $6529
    ld bc, $0009                                  ; $652C
    call DjEd_StepValue_Right                     ; $652F
    ld hl, wSound1DutyLen + $1                    ; $6532
    cp [hl]                                       ; $6535
    ret z                                         ; $6536

    ld [hl], a                                    ; $6537
    ret                                           ; $6538


; C
DjS1_Field04_DrawCursor::
    ld bc, $1c1c                                  ; $6539
    ld a, $95                                     ; $653C
    call DjEd_DrawFieldCursor                     ; $653E
    ldh a, [hFrameCounter]                        ; $6541
    bit 4, a                                      ; $6543
    ret z                                         ; $6545

    ld bc, $5a2a                                  ; $6546
    ld a, $7d                                     ; $6549
    call Oam_AddMeta_B01_5D2B                     ; $654B
    ret                                           ; $654E


; C: handler of the DjS1 field cursor value 5
DjS1_Field05_ModDepth::
    call DjS1_Field05_SyncCursor                  ; $654F
    call DjS1_Field05_Edit                        ; $6552
    call DjS1_Field05_DrawCursor                  ; $6555
    ldh a, [hKeysNew]                             ; $6558
    bit PADB_LEFT, a                              ; $655A
    jr z, jr_005_656f                             ; $655C

    ui_sfx $01                                    ; $655E
    ld a, $04                                     ; $6565
    ld [wSound1FieldCursor], a                    ; $6567
    xor a                                         ; $656A
    ld [wSndCursorPopFrames], a                   ; $656B
    ret                                           ; $656E


jr_005_656f:
    bit 4, a                                      ; $656F
    jr z, jr_005_6580                             ; $6571

    ui_sfx $01                                    ; $6573
    ld a, $06                                     ; $657A
    ld [wSound1FieldCursor], a                    ; $657C
    ret                                           ; $657F


jr_005_6580:
    bit 7, a                                      ; $6580
    ret z                                         ; $6582

    ui_sfx $01                                    ; $6583
    ld a, [wSound1FieldCursor]                    ; $658A
    ld [wSound1FieldCursor + $2], a               ; $658D
    ld a, $08                                     ; $6590
    ld [wSound1FieldCursor], a                    ; $6592
    xor a                                         ; $6595
    ld [wSndCursorPopFrames], a                   ; $6596
    ret                                           ; $6599


; C
DjS1_Field05_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $659A
    ld hl, wSound1FieldCursor + $1                ; $659D
    cp [hl]                                       ; $65A0
    ret z                                         ; $65A1

    ld [hl], a                                    ; $65A2
    ret                                           ; $65A3


; C
DjS1_Field05_Edit::
    ld a, [wSound1Modulation]                     ; $65A4
    ld bc, $0063                                  ; $65A7
    call DjEd_StepValue_Right                     ; $65AA
    ld [wSound1Modulation], a                     ; $65AD
    ret                                           ; $65B0


; C
DjS1_Field05_DrawCursor::
    ld bc, $661c                                  ; $65B1
    ld a, $98                                     ; $65B4
    call DjEd_DrawFieldCursor                     ; $65B6
    ldh a, [hFrameCounter]                        ; $65B9
    bit 4, a                                      ; $65BB
    ret z                                         ; $65BD

    ld bc, $6e2c                                  ; $65BE
    ld a, $7d                                     ; $65C1
    call Oam_AddMeta_B01_5D2B                     ; $65C3
    ret                                           ; $65C6


; C: handler of the DjS1 field cursor value 6
DjS1_Field06_ModSpeed::
    call DjS1_Field06_SyncCursor                  ; $65C7
    call DjS1_Field06_Edit                        ; $65CA
    call DjS1_Field06_DrawCursor                  ; $65CD
    ldh a, [hKeysNew]                             ; $65D0
    bit PADB_LEFT, a                              ; $65D2
    jr z, jr_005_65e3                             ; $65D4

    ui_sfx $01                                    ; $65D6
    ld a, $05                                     ; $65DD
    ld [wSound1FieldCursor], a                    ; $65DF
    ret                                           ; $65E2


jr_005_65e3:
    bit 4, a                                      ; $65E3
    jr z, jr_005_65f4                             ; $65E5

    ui_sfx $01                                    ; $65E7
    ld a, $07                                     ; $65EE
    ld [wSound1FieldCursor], a                    ; $65F0
    ret                                           ; $65F3


jr_005_65f4:
    bit 7, a                                      ; $65F4
    ret z                                         ; $65F6

    ui_sfx $01                                    ; $65F7
    ld a, [wSound1FieldCursor]                    ; $65FE
    ld [wSound1FieldCursor + $2], a               ; $6601
    ld a, $08                                     ; $6604
    ld [wSound1FieldCursor], a                    ; $6606
    xor a                                         ; $6609
    ld [wSndCursorPopFrames], a                   ; $660A
    ret                                           ; $660D


; C
DjS1_Field06_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $660E
    ld hl, wSound1FieldCursor + $1                ; $6611
    cp [hl]                                       ; $6614
    ret z                                         ; $6615

    ld [hl], a                                    ; $6616
    ret                                           ; $6617


; C
DjS1_Field06_Edit::
    ld a, [wSound1Modulation + $1]                ; $6618
    ld bc, $0063                                  ; $661B
    call DjEd_StepValue_Right                     ; $661E
    ld [wSound1Modulation + $1], a                ; $6621
    ret                                           ; $6624


; C
DjS1_Field06_DrawCursor::
    ld bc, $661c                                  ; $6625
    ld a, $98                                     ; $6628
    call DjEd_DrawFieldCursor                     ; $662A
    ldh a, [hFrameCounter]                        ; $662D
    bit 4, a                                      ; $662F
    ret z                                         ; $6631

    ld bc, $802c                                  ; $6632
    ld a, $7d                                     ; $6635
    call Oam_AddMeta_B01_5D2B                     ; $6637
    ret                                           ; $663A


; C: handler of the DjS1 field cursor value 7
DjS1_Field07_ModMode::
    call DjS1_Field07_SyncCursor                  ; $663B
    call DjS1_Field07_Edit                        ; $663E
    call DjS1_Field07_DrawCursor                  ; $6641
    ldh a, [hKeysNew]                             ; $6644
    bit PADB_LEFT, a                              ; $6646
    jr z, jr_005_665a                             ; $6648

    ui_sfx $01                                    ; $664A
    call DjS1_Field07_DrawMarker                  ; $6651
    ld a, $06                                     ; $6654
    ld [wSound1FieldCursor], a                    ; $6656
    ret                                           ; $6659


jr_005_665a:
    bit 7, a                                      ; $665A
    ret z                                         ; $665C

    ui_sfx $01                                    ; $665D
    call DjS1_Field07_DrawMarker                  ; $6664
    ld a, [wSound1FieldCursor]                    ; $6667
    ld [wSound1FieldCursor + $2], a               ; $666A
    ld a, $08                                     ; $666D
    ld [wSound1FieldCursor], a                    ; $666F
    xor a                                         ; $6672
    ld [wSndCursorPopFrames], a                   ; $6673
    ret                                           ; $6676


; C
DjS1_Field07_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6677
    ld hl, wSound1FieldCursor + $1                ; $667A
    cp [hl]                                       ; $667D
    ret z                                         ; $667E

    ld [hl], a                                    ; $667F
    ld a, $55                                     ; $6680
    ld hl, $9871                                  ; $6682
    call Vram_WriteByteSafe                       ; $6685
    ld a, $55                                     ; $6688
    ld hl, $9891                                  ; $668A
    call Vram_WriteByteSafe                       ; $668D
    ld a, $55                                     ; $6690
    ld hl, $98b1                                  ; $6692
    call Vram_WriteByteSafe                       ; $6695
    ret                                           ; $6698


; C
DjS1_Field07_Edit::
    ld a, [wSound1Modulation + $2]                ; $6699
    ld bc, $0002                                  ; $669C
    call DjEd_StepValue_Up                        ; $669F
    ld [wSound1Modulation + $2], a                ; $66A2
    ret                                           ; $66A5


; C
DjS1_Field07_DrawCursor::
    ld bc, $661c                                  ; $66A6
    ld a, $98                                     ; $66A9
    call DjEd_DrawFieldCursor                     ; $66AB
    ldh a, [hFrameCounter]                        ; $66AE
    bit 4, a                                      ; $66B0
    ret z                                         ; $66B2

    ld a, [wSound1Modulation + $2]                ; $66B3
    swap a                                        ; $66B6
    srl a                                         ; $66B8
    add $21                                       ; $66BA
    ld c, a                                       ; $66BC
    ld b, $8d                                     ; $66BD
    ld a, $79                                     ; $66BF
    call Oam_AddMeta_B01_5D2B                     ; $66C1
    ret                                           ; $66C4


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND I field 7 (modulation mode)
DjS1_Field07_DrawMarker::
    ld a, [wSound1Modulation + $2]                ; $66C5
    swap a                                        ; $66C8
    sla a                                         ; $66CA
    ld c, a                                       ; $66CC
    ld b, $00                                     ; $66CD
    ld hl, $9871                                  ; $66CF
    add hl, bc                                    ; $66D2
    ld a, $ca                                     ; $66D3
    call Vram_WriteByteSafe                       ; $66D5
    ret                                           ; $66D8


; C: handler of the DjS1 field cursor value 8
DjS1_Field08_LoopLength::
    call DjS1_Field08_SyncCursor                  ; $66D9
    call DjS1_Field08_Edit                        ; $66DC
    call DjS1_Field08_DrawCursor                  ; $66DF
    ldh a, [hKeysNew]                             ; $66E2
    bit PADB_UP, a                                ; $66E4
    jr z, jr_005_66fa                             ; $66E6

    ui_sfx $01                                    ; $66E8
    ld a, [wSound1FieldCursor + $2]               ; $66EF
    ld [wSound1FieldCursor], a                    ; $66F2
    xor a                                         ; $66F5
    ld [wSndCursorPopFrames], a                   ; $66F6
    ret                                           ; $66F9


jr_005_66fa:
    bit 7, a                                      ; $66FA
    ret z                                         ; $66FC

    ui_sfx $01                                    ; $66FD
    call DjEd_DrawLoopBar                         ; $6704
    ld a, $09                                     ; $6707
    ld [wSound1FieldCursor], a                    ; $6709
    xor a                                         ; $670C
    ld [wSndCursorPopFrames], a                   ; $670D
    ret                                           ; $6710


; C
DjS1_Field08_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6711
    ld hl, wSound1FieldCursor + $1                ; $6714
    cp [hl]                                       ; $6717
    ret z                                         ; $6718

    ld [hl], a                                    ; $6719
    ret                                           ; $671A


; C
DjS1_Field08_Edit::
    ld a, [wLoopLengths]                          ; $671B
    ld bc, $0210                                  ; $671E
    call DjEd_StepValue_Right                     ; $6721
    ld [wLoopLengths], a                          ; $6724
    ld a, [wLoopLengths]                          ; $6727
    ld bc, $0210                                  ; $672A
    call DjEd_StepValue_LeftRight                 ; $672D
    ld [wLoopLengths], a                          ; $6730
    ret                                           ; $6733


; C
DjS1_Field08_DrawCursor::
    ld bc, $053d                                  ; $6734
    ld a, $9b                                     ; $6737
    call DjEd_DrawFieldCursor                     ; $6739
    ldh a, [hFrameCounter]                        ; $673C
    bit 4, a                                      ; $673E
    ret z                                         ; $6740

    ld bc, $0e46                                  ; $6741
    ld a, $7d                                     ; $6744
    call Oam_AddMeta_B01_5D2B                     ; $6746
    ret                                           ; $6749


; C: handler of the DjS1 field cursor value 9
DjS1_Field09_NoteGrid::
    call DjS1_Field09_SyncCursor                  ; $674A
    call DjS1_Field09_Edit                        ; $674D
    call DjS1_Field09_DrawCursor                  ; $6750
    ldh a, [hKeysNew]                             ; $6753
    bit PADB_UP, a                                ; $6755
    jr z, jr_005_676a                             ; $6757

    ui_sfx $01                                    ; $6759
    ld a, $08                                     ; $6760
    ld [wSound1FieldCursor], a                    ; $6762
    xor a                                         ; $6765
    ld [wSndCursorPopFrames], a                   ; $6766
    ret                                           ; $6769


jr_005_676a:
    bit 3, a                                      ; $676A
    jr z, jr_005_677b                             ; $676C

    ui_sfx $04                                    ; $676E
    ld a, $0b                                     ; $6775
    ld [wSound1FieldCursor], a                    ; $6777
    ret                                           ; $677A


jr_005_677b:
    bit 0, a                                      ; $677B
    ret z                                         ; $677D

    ui_sfx $04                                    ; $677E
    ld a, $0a                                     ; $6785
    ld [wSound1FieldCursor], a                    ; $6787
    ret                                           ; $678A


; C
DjS1_Field09_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $678B
    ld hl, wSound1FieldCursor + $1                ; $678E
    cp [hl]                                       ; $6791
    ret z                                         ; $6792

    ld [hl], a                                    ; $6793
    ret                                           ; $6794


; C
DjS1_Field09_Edit::
    ld a, [wSound1NoteCursor]                     ; $6795
    ld bc, $000f                                  ; $6798
    call DjEd_StepLeftRight                       ; $679B
    ld [wSound1NoteCursor], a                     ; $679E
    ld a, [wSound1NoteCursor]                     ; $67A1
    ld c, a                                       ; $67A4
    ld b, $00                                     ; $67A5
    ld hl, wSound1Notes                           ; $67A7
    add hl, bc                                    ; $67AA
    ldh a, [hKeysNew]                             ; $67AB
    bit PADB_DOWN, a                              ; $67AD
    ret z                                         ; $67AF

    xor a                                         ; $67B0
    ld [hl], a                                    ; $67B1
    ld a, [wSound1NoteCursor]                     ; $67B2
    ld hl, wSound1Notes                           ; $67B5
    call DjEd_DrawNoteRowOffset                   ; $67B8
    ret                                           ; $67BB


; C
DjS1_Field09_DrawCursor::
    ld bc, $0557                                  ; $67BC
    ld a, $9e                                     ; $67BF
    call DjEd_DrawFieldCursor                     ; $67C1
    ldh a, [hFrameCounter]                        ; $67C4
    bit 4, a                                      ; $67C6
    jr z, jr_005_67dd                             ; $67C8

    ld a, [wSound1NoteCursor]                     ; $67CA
    sla a                                         ; $67CD
    sla a                                         ; $67CF
    sla a                                         ; $67D1
    add $1d                                       ; $67D3
    ld b, a                                       ; $67D5
    ld c, $57                                     ; $67D6
    ld a, $7c                                     ; $67D8
    call Oam_AddMeta_B01_5D2B                     ; $67DA

jr_005_67dd:
    ld a, [wSound1NoteCursor]                     ; $67DD
    call DjEd_DrawNoteMarker                      ; $67E0
    ld hl, wSound1Notes                           ; $67E3
    ld a, [wSound1NoteCursor]                     ; $67E6
    call DjEd_DrawNoteStepCursor                  ; $67E9
    ld e, $00                                     ; $67EC
    ld hl, wSound1Stereo                          ; $67EE
    ld a, [wSound1NoteCursor]                     ; $67F1
    call DjEd_DrawNoteColumn                      ; $67F4
    ret                                           ; $67F7


; C: handler of the DjS1 field cursor value 10
DjS1_Field0A_NoteEdit::
    call DjS1_Field0A_SyncCursor                  ; $67F8
    call DjS1_Field0A_Edit                        ; $67FB
    call DjS1_Field0A_DrawCursor                  ; $67FE
    ldh a, [hKeysHeld]                            ; $6801
    bit PADB_A, a                                 ; $6803
    ret nz                                        ; $6805

    ui_sfx $05                                    ; $6806
    call DjS1_Field0A_DrawMarker                  ; $680D
    ld a, $09                                     ; $6810
    ld [wSound1FieldCursor], a                    ; $6812
    ret                                           ; $6815


; C
DjS1_Field0A_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6816
    ld hl, wSound1FieldCursor + $1                ; $6819
    cp [hl]                                       ; $681C
    ret z                                         ; $681D

    ld [hl], a                                    ; $681E
    ret                                           ; $681F


; C
DjS1_Field0A_Edit::
    ld a, [wSound1NoteCursor]                     ; $6820
    ld c, a                                       ; $6823
    ld b, $00                                     ; $6824
    ld hl, wSound1Notes                           ; $6826
    add hl, bc                                    ; $6829
    ld bc, $0025                                  ; $682A
    ld a, [hl]                                    ; $682D
    push hl                                       ; $682E
    call DjEd_StepLeftRight                       ; $682F
    pop hl                                        ; $6832
    cp [hl]                                       ; $6833
    ret z                                         ; $6834

    ld [hl], a                                    ; $6835
    call DjS1_Field0A_DrawMarker                  ; $6836
    ret                                           ; $6839


; C
DjS1_Field0A_DrawCursor::
    ld bc, $0557                                  ; $683A
    ld a, $9e                                     ; $683D
    call DjEd_DrawFieldCursor                     ; $683F
    ld hl, wSound1Notes                           ; $6842
    ld a, [wSound1NoteCursor]                     ; $6845
    call DjEd_DrawNoteStepCursor                  ; $6848
    ldh a, [hKeysHeld]                            ; $684B
    and PADF_RIGHT | PADF_LEFT                    ; $684D
    ld hl, wSound1Notes                           ; $684F
    ld a, [wSound1NoteCursor]                     ; $6852
    call z, DjEd_DrawNoteCursorBlink              ; $6855
    ld a, [wSound1NoteCursor]                     ; $6858
    sla a                                         ; $685B
    sla a                                         ; $685D
    sla a                                         ; $685F
    add $1d                                       ; $6861
    ld b, a                                       ; $6863
    ld c, $57                                     ; $6864
    ld a, $7c                                     ; $6866
    call Oam_AddMeta_B01_5D2B                     ; $6868
    ld e, $00                                     ; $686B
    ld hl, wSound1Stereo                          ; $686D
    ld a, [wSound1NoteCursor]                     ; $6870
    call DjEd_DrawNoteColumn                      ; $6873
    ret                                           ; $6876


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND I field 10 (note edit)
DjS1_Field0A_DrawMarker::
    ld a, [wSound1NoteCursor]                     ; $6877
    ld hl, wSound1Notes                           ; $687A
    call DjEd_DrawNoteRowOffset                   ; $687D
    ret                                           ; $6880


; C: handler of the DjS1 field cursor value 11
DjS1_Field0B_StereoEdit::
    call DjS1_Field0B_SyncCursor                  ; $6881
    call DjS1_Field0B_Edit                        ; $6884
    call DjS1_Field0B_DrawCursor                  ; $6887
    ldh a, [hKeysHeld]                            ; $688A
    bit PADB_START, a                             ; $688C
    ret nz                                        ; $688E

    ui_sfx $05                                    ; $688F
    ld a, $09                                     ; $6896
    ld [wSound1FieldCursor], a                    ; $6898
    ret                                           ; $689B


; C
DjS1_Field0B_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $689C
    ld hl, wSound1FieldCursor + $1                ; $689F
    cp [hl]                                       ; $68A2
    ret z                                         ; $68A3

    ld [hl], a                                    ; $68A4
    ld a, [wSound1NoteCursor]                     ; $68A5
    ld c, a                                       ; $68A8
    ld b, $00                                     ; $68A9
    ld hl, wSound1Stereo                          ; $68AB
    add hl, bc                                    ; $68AE
    ld a, [hl]                                    ; $68AF
    and $03                                       ; $68B0
    ld [wSound1StereoEdit], a                     ; $68B2
    ret                                           ; $68B5


; C
DjS1_Field0B_Edit::
    ld a, [wSound1StereoEdit]                     ; $68B6
    ld bc, $0002                                  ; $68B9
    call DjEd_StepLeftRight                       ; $68BC
    ld [wSound1StereoEdit], a                     ; $68BF
    ld a, [wSound1NoteCursor]                     ; $68C2
    ld c, a                                       ; $68C5
    ld b, $00                                     ; $68C6
    ld hl, wSound1Stereo                          ; $68C8
    add hl, bc                                    ; $68CB
    ld a, [wSound1StereoEdit]                     ; $68CC
    ld [hl], a                                    ; $68CF
    ret                                           ; $68D0


; C
DjS1_Field0B_DrawCursor::
    ld bc, $0557                                  ; $68D1
    ld a, $9e                                     ; $68D4
    call DjEd_DrawFieldCursor                     ; $68D6
    ld a, [wSound1NoteCursor]                     ; $68D9
    sla a                                         ; $68DC
    sla a                                         ; $68DE
    sla a                                         ; $68E0
    add $1d                                       ; $68E2
    ld b, a                                       ; $68E4
    ld c, $57                                     ; $68E5
    ld a, $7c                                     ; $68E7
    call Oam_AddMeta_B01_5D2B                     ; $68E9
    ld hl, wSound1Notes                           ; $68EC
    ld a, [wSound1NoteCursor]                     ; $68EF
    call DjEd_DrawNoteStepCursor                  ; $68F2
    ldh a, [hFrameCounter]                        ; $68F5
    srl a                                         ; $68F7
    srl a                                         ; $68F9
    srl a                                         ; $68FB
    and $01                                       ; $68FD
    ld e, a                                       ; $68FF
    ld hl, wSound1Stereo                          ; $6900
    ld a, [wSound1NoteCursor]                     ; $6903
    call DjEd_DrawNoteColumn                      ; $6906
    ret                                           ; $6909


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjS2_DrawValueRow::
    ld a, [wLoopLengths]                          ; $690A
    ld c, a                                       ; $690D
    ld a, [wSound1PlayStep]                       ; $690E
    call Call_005_4a64                            ; $6911
    ld a, [wSound1FieldCursor]                    ; $6914
    cp $09                                        ; $6917
    ret z                                         ; $6919

    cp $0a                                        ; $691A
    ret z                                         ; $691C

    cp $0b                                        ; $691D
    ret z                                         ; $691F

    call DjEd_DrawLoopBar                         ; $6920
    ret                                           ; $6923


; C
DjS2_RedrawWaveGraphStep::
    ld a, [wSound2WaveLen + $1]                   ; $6924
    ld bc, $5a2e                                  ; $6927
    and a                                         ; $692A
    jr nz, jr_005_692f                            ; $692B

    ld a, $0a                                     ; $692D

jr_005_692f:
    add $7f                                       ; $692F
    call Oam_AddMeta_B01_5D2B                     ; $6931
    ld a, [wSound2Modulation]                     ; $6934
    call DjEd_DrawModDepthDigits                  ; $6937
    ld a, [wSound2Modulation + $1]                ; $693A
    call DjEd_DrawModSpeedDigits                  ; $693D
    ld a, [wLoopLengths + $1]                     ; $6940
    call DjEd_DrawLoopDigitsAndPrint              ; $6943
    ld a, [wSound2FieldCursor]                    ; $6946
    cp $00                                        ; $6949
    ret z                                         ; $694B

    ld bc, $0b31                                  ; $694C
    ld a, $8a                                     ; $694F
    call Oam_AddMeta_B01_5D2B                     ; $6951
    ret                                           ; $6954


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise 1F:0A
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjS2_DrawAllValues::
    ld a, [wLoopLengths + $1]                     ; $6955
    call DjEd_DrawLoopDigitsAndPrint              ; $6958
    ret                                           ; $695B


; C: handler of the DjS2 field cursor value 0
DjS2_Field00_WavePattern::
    call DjS2_Field00_SyncCursor                  ; $695C
    call DjS2_Field00_Edit                        ; $695F
    call DjS2_Field00_DrawCursor                  ; $6962
    ldh a, [hKeysNew]                             ; $6965
    bit PADB_RIGHT, a                             ; $6967
    jr z, jr_005_699c                             ; $6969

    ld a, [wSound2WaveLen]                        ; $696B
    cp $02                                        ; $696E
    jr nz, jr_005_6988                            ; $6970

    ldh a, [hKeysHeld]                            ; $6972
    bit PADB_A, a                                 ; $6974
    jr z, jr_005_6988                             ; $6976

    ui_sfx $01                                    ; $6978
    call DjS2_Field00_DrawMarker                  ; $697F
    ld a, $01                                     ; $6982
    ld [wSound2FieldCursor], a                    ; $6984
    ret                                           ; $6987


jr_005_6988:
    ui_sfx $01                                    ; $6988
    call DjS2_Field00_DrawMarker                  ; $698F
    ld a, $02                                     ; $6992
    ld [wSound2FieldCursor], a                    ; $6994
    xor a                                         ; $6997
    ld [wSndCursorPopFrames], a                   ; $6998
    ret                                           ; $699B


jr_005_699c:
    bit 7, a                                      ; $699C
    ret z                                         ; $699E

    ui_sfx $01                                    ; $699F
    call DjS2_Field00_DrawMarker                  ; $69A6
    ld a, [wSound2FieldCursor]                    ; $69A9
    ld [wSound2FieldCursor + $2], a               ; $69AC
    ld a, $06                                     ; $69AF
    ld [wSound2FieldCursor], a                    ; $69B1
    xor a                                         ; $69B4
    ld [wSndCursorPopFrames], a                   ; $69B5
    ret                                           ; $69B8


; C
DjS2_Field00_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $69B9
    ld hl, wSound2FieldCursor + $1                ; $69BC
    cp [hl]                                       ; $69BF
    ret z                                         ; $69C0

    ld [hl], a                                    ; $69C1
    ld a, $51                                     ; $69C2
    ld hl, $9861                                  ; $69C4
    call Vram_WriteByteSafe                       ; $69C7
    ld a, $51                                     ; $69CA
    ld hl, $9881                                  ; $69CC
    call Vram_WriteByteSafe                       ; $69CF
    ld a, $51                                     ; $69D2
    ld hl, $98a1                                  ; $69D4
    call Vram_WriteByteSafe                       ; $69D7
    ld a, $6f                                     ; $69DA
    ld hl, $9842                                  ; $69DC
    call Vram_WriteByteSafe                       ; $69DF
    call DjSnd_BuildWaveStaging                   ; $69E2
    call DjS2_WaveRedrawStart                     ; $69E5
    ret                                           ; $69E8


; C
DjS2_Field00_Edit::
    ld a, [wSound2WaveLen]                        ; $69E9
    ld bc, $0002                                  ; $69EC
    call DjEd_StepValue_Up                        ; $69EF
    ld hl, wSound2WaveLen                         ; $69F2
    cp [hl]                                       ; $69F5
    ret z                                         ; $69F6

    ld [hl], a                                    ; $69F7
    call DjSnd_BuildWaveStaging                   ; $69F8
    call DjS2_WaveRedrawStart                     ; $69FB
    ret                                           ; $69FE


; C
DjS2_Field00_DrawCursor::
    ld bc, $051c                                  ; $69FF
    ld a, $a1                                     ; $6A02
    call DjEd_DrawFieldCursor                     ; $6A04
    ld a, [wSound2WaveLen]                        ; $6A07
    cp $02                                        ; $6A0A
    jr nz, jr_005_6a1e                            ; $6A0C

    ldh a, [hFrameCounter]                        ; $6A0E
    bit 3, a                                      ; $6A10
    jr nz, jr_005_6a1e                            ; $6A12

    ld bc, $0b31                                  ; $6A14
    ld a, $70                                     ; $6A17
    call Oam_AddMeta_B01_5D2B                     ; $6A19
    jr jr_005_6a26                                ; $6A1C

jr_005_6a1e:
    ld bc, $0b31                                  ; $6A1E
    ld a, $8a                                     ; $6A21
    call Oam_AddMeta_B01_5D2B                     ; $6A23

jr_005_6a26:
    ldh a, [hFrameCounter]                        ; $6A26
    bit 4, a                                      ; $6A28
    ret z                                         ; $6A2A

    ld a, [wSound2WaveLen]                        ; $6A2B
    swap a                                        ; $6A2E
    srl a                                         ; $6A30
    add $20                                       ; $6A32
    ld c, a                                       ; $6A34
    ld b, $09                                     ; $6A35
    ld a, $79                                     ; $6A37
    call Oam_AddMeta_B01_5D2B                     ; $6A39
    ret                                           ; $6A3C


; C: wave pattern marker tile $CB
DjS2_Field00_DrawMarker::
    ld a, [wSound2WaveLen]                        ; $6A3D
    swap a                                        ; $6A40
    sla a                                         ; $6A42
    ld c, a                                       ; $6A44
    ld b, $00                                     ; $6A45
    ld hl, $9861                                  ; $6A47
    add hl, bc                                    ; $6A4A
    ld a, $cb                                     ; $6A4B
    call Vram_WriteByteSafe                       ; $6A4D
    ret                                           ; $6A50


; C: handler of the DjS2 field cursor value 1
DjS2_Field01_WaveGrid::
    call DjS2_Field01_SyncCursor                  ; $6A51
    call DjS2_Field01_Edit                        ; $6A54
    call DjS2_Field01_DrawCursor                  ; $6A57
    ld a, [wSound2WaveCursor]                     ; $6A5A
    cp $ff                                        ; $6A5D
    jr z, jr_005_6a66                             ; $6A5F

    ldh a, [hKeysHeld]                            ; $6A61
    bit PADB_A, a                                 ; $6A63
    ret nz                                        ; $6A65

jr_005_6a66:
    xor a                                         ; $6A66
    ld [wSndCursorPopFrames], a                   ; $6A67
    call DjS2_Field01_DrawMarker                  ; $6A6A
    ld a, $00                                     ; $6A6D
    ld [wSound2FieldCursor], a                    ; $6A6F
    ret                                           ; $6A72


; C
DjS2_Field01_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6A73
    ld hl, wSound2FieldCursor + $1                ; $6A76
    cp [hl]                                       ; $6A79
    ret z                                         ; $6A7A

    ld [hl], a                                    ; $6A7B
    ld a, $00                                     ; $6A7C
    ld hl, $9842                                  ; $6A7E
    call Vram_WriteByteSafe                       ; $6A81
    call DjS2_WaveRedrawStart                     ; $6A84
    xor a                                         ; $6A87
    ld [wSound2WaveCursor], a                     ; $6A88
    ret                                           ; $6A8B


; C
DjS2_Field01_Edit::
    ld a, [wSound2WaveCursor]                     ; $6A8C
    ld bc, $ff1f                                  ; $6A8F
    call DjEd_StepValue_LeftRight                 ; $6A92
    ld hl, wSound2WaveCursor                      ; $6A95
    cp [hl]                                       ; $6A98
    jr z, jr_005_6a9c                             ; $6A99

    ld [hl], a                                    ; $6A9B

jr_005_6a9c:
    ld c, a                                       ; $6A9C
    ld b, $00                                     ; $6A9D
    push bc                                       ; $6A9F
    ld hl, wWaveStaging                           ; $6AA0
    add hl, bc                                    ; $6AA3
    ld a, [hl]                                    ; $6AA4
    push hl                                       ; $6AA5
    ld bc, $000f                                  ; $6AA6
    call DjEd_StepValue_Right                     ; $6AA9
    pop hl                                        ; $6AAC
    pop bc                                        ; $6AAD
    cp [hl]                                       ; $6AAE
    ret z                                         ; $6AAF

    ld [hl], a                                    ; $6AB0
    ld hl, wSound2UserWave                        ; $6AB1
    add hl, bc                                    ; $6AB4
    ld [hl], a                                    ; $6AB5
    call DjS2_WaveGraphColumn                     ; $6AB6
    ret                                           ; $6AB9


; C
DjS2_Field01_DrawCursor::
    ld bc, $051c                                  ; $6ABA
    ld a, $a4                                     ; $6ABD
    call Oam_AddMeta_B01_5D2B                     ; $6ABF
    ldh a, [hFrameCounter]                        ; $6AC2
    bit 4, a                                      ; $6AC4
    ret z                                         ; $6AC6

    ld a, [wSound2WaveCursor]                     ; $6AC7
    sla a                                         ; $6ACA
    add $10                                       ; $6ACC
    ld b, a                                       ; $6ACE
    ld c, $33                                     ; $6ACF
    ld a, $8b                                     ; $6AD1
    call Oam_AddMeta_B01_5D2B                     ; $6AD3
    ret                                           ; $6AD6


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the cursor of SOUND II field 1 (DjEd_DrawFieldCursor $A1 at $051C)
DjS2_Field01_DrawMarker::
    ld bc, $051c                                  ; $6AD7
    ld a, $a1                                     ; $6ADA
    call DjEd_DrawFieldCursor                     ; $6ADC
    ret                                           ; $6ADF


; C: handler of the DjS2 field cursor value 2
DjS2_Field02_Length::
    call DjS2_Field02_SyncCursor                  ; $6AE0
    call DjS2_Field02_Edit                        ; $6AE3
    call DjS2_Field02_DrawCursor                  ; $6AE6
    ldh a, [hKeysNew]                             ; $6AE9
    bit PADB_LEFT, a                              ; $6AEB
    jr z, jr_005_6b00                             ; $6AED

    ui_sfx $01                                    ; $6AEF
    ld a, $00                                     ; $6AF6
    ld [wSound2FieldCursor], a                    ; $6AF8
    xor a                                         ; $6AFB
    ld [wSndCursorPopFrames], a                   ; $6AFC
    ret                                           ; $6AFF


jr_005_6b00:
    bit 4, a                                      ; $6B00
    jr z, jr_005_6b15                             ; $6B02

    ui_sfx $01                                    ; $6B04
    ld a, $03                                     ; $6B0B
    ld [wSound2FieldCursor], a                    ; $6B0D
    xor a                                         ; $6B10
    ld [wSndCursorPopFrames], a                   ; $6B11
    ret                                           ; $6B14


jr_005_6b15:
    bit 7, a                                      ; $6B15
    ret z                                         ; $6B17

    ui_sfx $01                                    ; $6B18
    ld a, [wSound2FieldCursor]                    ; $6B1F
    ld [wSound2FieldCursor + $2], a               ; $6B22
    ld a, $06                                     ; $6B25
    ld [wSound2FieldCursor], a                    ; $6B27
    xor a                                         ; $6B2A
    ld [wSndCursorPopFrames], a                   ; $6B2B
    ret                                           ; $6B2E


; C
DjS2_Field02_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6B2F
    ld hl, wSound2FieldCursor + $1                ; $6B32
    cp [hl]                                       ; $6B35
    ret z                                         ; $6B36

    ld [hl], a                                    ; $6B37

; C
DjS2_Field02_Edit::
    ld a, [wSound2WaveLen + $1]                   ; $6B38
    ld bc, $0009                                  ; $6B3B
    call DjEd_StepValue_Right                     ; $6B3E
    ld hl, wSound2WaveLen + $1                    ; $6B41
    cp [hl]                                       ; $6B44
    ret z                                         ; $6B45

    ld [hl], a                                    ; $6B46
    ret                                           ; $6B47


; C
DjS2_Field02_DrawCursor::
    ld bc, $541c                                  ; $6B48
    ld a, $95                                     ; $6B4B
    call DjEd_DrawFieldCursor                     ; $6B4D
    ldh a, [hFrameCounter]                        ; $6B50
    bit 4, a                                      ; $6B52
    ret z                                         ; $6B54

    ld bc, $5c2a                                  ; $6B55
    ld a, $7d                                     ; $6B58
    call Oam_AddMeta_B01_5D2B                     ; $6B5A
    ret                                           ; $6B5D


; C: handler of the DjS2 field cursor value 3
DjS2_Field03_ModDepth::
    call DjS2_Field03_SyncCursor                  ; $6B5E
    call DjS2_Field03_Edit                        ; $6B61
    call DjS2_Field03_DrawCursor                  ; $6B64
    ldh a, [hKeysNew]                             ; $6B67
    bit PADB_LEFT, a                              ; $6B69
    jr z, jr_005_6b7e                             ; $6B6B

    ui_sfx $01                                    ; $6B6D
    ld a, $02                                     ; $6B74
    ld [wSound2FieldCursor], a                    ; $6B76
    xor a                                         ; $6B79
    ld [wSndCursorPopFrames], a                   ; $6B7A
    ret                                           ; $6B7D


jr_005_6b7e:
    bit 4, a                                      ; $6B7E
    jr z, jr_005_6b8f                             ; $6B80

    ui_sfx $01                                    ; $6B82
    ld a, $04                                     ; $6B89
    ld [wSound2FieldCursor], a                    ; $6B8B
    ret                                           ; $6B8E


jr_005_6b8f:
    bit 7, a                                      ; $6B8F
    ret z                                         ; $6B91

    ui_sfx $01                                    ; $6B92
    ld a, [wSound2FieldCursor]                    ; $6B99
    ld [wSound2FieldCursor + $2], a               ; $6B9C
    ld a, $06                                     ; $6B9F
    ld [wSound2FieldCursor], a                    ; $6BA1
    xor a                                         ; $6BA4
    ld [wSndCursorPopFrames], a                   ; $6BA5
    ret                                           ; $6BA8


; C
DjS2_Field03_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6BA9
    ld hl, wSound2FieldCursor + $1                ; $6BAC
    cp [hl]                                       ; $6BAF
    ret z                                         ; $6BB0

    ld [hl], a                                    ; $6BB1
    ld [wSound2FieldCursor + $2], a               ; $6BB2
    ret                                           ; $6BB5


; C
DjS2_Field03_Edit::
    ld a, [wSound2Modulation]                     ; $6BB6
    ld bc, $0063                                  ; $6BB9
    call DjEd_StepValue_Right                     ; $6BBC
    ld [wSound2Modulation], a                     ; $6BBF
    ret                                           ; $6BC2


; C
DjS2_Field03_DrawCursor::
    ld bc, $661c                                  ; $6BC3
    ld a, $98                                     ; $6BC6
    call DjEd_DrawFieldCursor                     ; $6BC8
    ldh a, [hFrameCounter]                        ; $6BCB
    bit 4, a                                      ; $6BCD
    ret z                                         ; $6BCF

    ld bc, $6e2c                                  ; $6BD0
    ld a, $7d                                     ; $6BD3
    call Oam_AddMeta_B01_5D2B                     ; $6BD5
    ret                                           ; $6BD8


; C: handler of the DjS2 field cursor value 4
DjS2_Field04_ModSpeed::
    call DjS2_Field04_SyncCursor                  ; $6BD9
    call DjS2_Field04_Edit                        ; $6BDC
    call DjS2_Field04_DrawCursor                  ; $6BDF
    ldh a, [hKeysNew]                             ; $6BE2
    bit PADB_LEFT, a                              ; $6BE4
    jr z, jr_005_6bf5                             ; $6BE6

    ui_sfx $01                                    ; $6BE8
    ld a, $03                                     ; $6BEF
    ld [wSound2FieldCursor], a                    ; $6BF1
    ret                                           ; $6BF4


jr_005_6bf5:
    bit 4, a                                      ; $6BF5
    jr z, jr_005_6c06                             ; $6BF7

    ui_sfx $01                                    ; $6BF9
    ld a, $05                                     ; $6C00
    ld [wSound2FieldCursor], a                    ; $6C02
    ret                                           ; $6C05


jr_005_6c06:
    bit 7, a                                      ; $6C06
    ret z                                         ; $6C08

    ui_sfx $01                                    ; $6C09
    ld a, [wSound2FieldCursor]                    ; $6C10
    ld [wSound2FieldCursor + $2], a               ; $6C13
    ld a, $06                                     ; $6C16
    ld [wSound2FieldCursor], a                    ; $6C18
    xor a                                         ; $6C1B
    ld [wSndCursorPopFrames], a                   ; $6C1C
    ret                                           ; $6C1F


; C
DjS2_Field04_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6C20
    ld hl, wSound2FieldCursor + $1                ; $6C23
    cp [hl]                                       ; $6C26
    ret z                                         ; $6C27

    ld [hl], a                                    ; $6C28
    ld [wSound2FieldCursor + $2], a               ; $6C29
    ret                                           ; $6C2C


; C
DjS2_Field04_Edit::
    ld a, [wSound2Modulation + $1]                ; $6C2D
    ld bc, $0063                                  ; $6C30
    call DjEd_StepValue_Right                     ; $6C33
    ld [wSound2Modulation + $1], a                ; $6C36
    ret                                           ; $6C39


; C
DjS2_Field04_DrawCursor::
    ld bc, $661c                                  ; $6C3A
    ld a, $98                                     ; $6C3D
    call DjEd_DrawFieldCursor                     ; $6C3F
    ldh a, [hFrameCounter]                        ; $6C42
    bit 4, a                                      ; $6C44
    ret z                                         ; $6C46

    ld bc, $802c                                  ; $6C47
    ld a, $7d                                     ; $6C4A
    call Oam_AddMeta_B01_5D2B                     ; $6C4C
    ret                                           ; $6C4F


; C: handler of the DjS2 field cursor value 5
DjS2_Field05_ModMode::
    call DjS2_Field05_SyncCursor                  ; $6C50
    call DjS2_Field05_Edit                        ; $6C53
    call DjS2_Field05_DrawCursor                  ; $6C56
    ldh a, [hKeysNew]                             ; $6C59
    bit PADB_LEFT, a                              ; $6C5B
    jr z, jr_005_6c6f                             ; $6C5D

    ui_sfx $01                                    ; $6C5F
    call DjS2_Field05_DrawMarker                  ; $6C66
    ld a, $04                                     ; $6C69
    ld [wSound2FieldCursor], a                    ; $6C6B
    ret                                           ; $6C6E


jr_005_6c6f:
    bit 7, a                                      ; $6C6F
    ret z                                         ; $6C71

    ui_sfx $01                                    ; $6C72
    call DjS2_Field05_DrawMarker                  ; $6C79
    ld a, [wSound2FieldCursor]                    ; $6C7C
    ld [wSound2FieldCursor + $2], a               ; $6C7F
    ld a, $06                                     ; $6C82
    ld [wSound2FieldCursor], a                    ; $6C84
    xor a                                         ; $6C87
    ld [wSndCursorPopFrames], a                   ; $6C88
    ret                                           ; $6C8B


; C
DjS2_Field05_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6C8C
    ld hl, wSound2FieldCursor + $1                ; $6C8F
    cp [hl]                                       ; $6C92
    ret z                                         ; $6C93

    ld [hl], a                                    ; $6C94
    ld [wSound2FieldCursor + $2], a               ; $6C95
    ld a, $55                                     ; $6C98
    ld hl, $9871                                  ; $6C9A
    call Vram_WriteByteSafe                       ; $6C9D
    ld a, $55                                     ; $6CA0
    ld hl, $9891                                  ; $6CA2
    call Vram_WriteByteSafe                       ; $6CA5
    ld a, $55                                     ; $6CA8
    ld hl, $98b1                                  ; $6CAA
    call Vram_WriteByteSafe                       ; $6CAD
    ret                                           ; $6CB0


; C
DjS2_Field05_Edit::
    ld a, [wSound2Modulation + $2]                ; $6CB1
    ld bc, $0002                                  ; $6CB4
    call DjEd_StepValue_Up                        ; $6CB7
    ld [wSound2Modulation + $2], a                ; $6CBA
    ret                                           ; $6CBD


; C
DjS2_Field05_DrawCursor::
    ld bc, $661c                                  ; $6CBE
    ld a, $98                                     ; $6CC1
    call DjEd_DrawFieldCursor                     ; $6CC3
    ldh a, [hFrameCounter]                        ; $6CC6
    bit 4, a                                      ; $6CC8
    ret z                                         ; $6CCA

    ld a, [wSound2Modulation + $2]                ; $6CCB
    swap a                                        ; $6CCE
    srl a                                         ; $6CD0
    add $21                                       ; $6CD2
    ld c, a                                       ; $6CD4
    ld b, $8d                                     ; $6CD5
    ld a, $79                                     ; $6CD7
    call Oam_AddMeta_B01_5D2B                     ; $6CD9
    ret                                           ; $6CDC


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND II field 5 (modulation mode)
DjS2_Field05_DrawMarker::
    ld a, [wSound2Modulation + $2]                ; $6CDD
    swap a                                        ; $6CE0
    sla a                                         ; $6CE2
    ld c, a                                       ; $6CE4
    ld b, $00                                     ; $6CE5
    ld hl, $9871                                  ; $6CE7
    add hl, bc                                    ; $6CEA
    ld a, $ca                                     ; $6CEB
    call Vram_WriteByteSafe                       ; $6CED
    ret                                           ; $6CF0


; C: handler of the DjS2 field cursor value 6
DjS2_Field06_LoopLength::
    call DjS2_Field06_SyncCursor                  ; $6CF1
    call DjS2_Field06_Edit                        ; $6CF4
    call DjS2_Field06_DrawCursor                  ; $6CF7
    ldh a, [hKeysNew]                             ; $6CFA
    bit PADB_UP, a                                ; $6CFC
    jr z, jr_005_6d12                             ; $6CFE

    ui_sfx $01                                    ; $6D00
    ld a, [wSound2FieldCursor + $2]               ; $6D07
    ld [wSound2FieldCursor], a                    ; $6D0A
    xor a                                         ; $6D0D
    ld [wSndCursorPopFrames], a                   ; $6D0E
    ret                                           ; $6D11


jr_005_6d12:
    bit 7, a                                      ; $6D12
    ret z                                         ; $6D14

    ui_sfx $01                                    ; $6D15
    call DjEd_DrawLoopBar                         ; $6D1C
    ld a, $07                                     ; $6D1F
    ld [wSound2FieldCursor], a                    ; $6D21
    xor a                                         ; $6D24
    ld [wSndCursorPopFrames], a                   ; $6D25
    ret                                           ; $6D28


; C
DjS2_Field06_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6D29
    ld hl, wSound2FieldCursor + $1                ; $6D2C
    cp [hl]                                       ; $6D2F
    ret z                                         ; $6D30

    ld [hl], a                                    ; $6D31
    ret                                           ; $6D32


; C
DjS2_Field06_Edit::
    ld a, [wLoopLengths + $1]                     ; $6D33
    ld bc, $0210                                  ; $6D36
    call DjEd_StepValue_Right                     ; $6D39
    ld [wLoopLengths + $1], a                     ; $6D3C
    ld a, [wLoopLengths + $1]                     ; $6D3F
    ld bc, $0210                                  ; $6D42
    call DjEd_StepValue_LeftRight                 ; $6D45
    ld [wLoopLengths + $1], a                     ; $6D48
    ret                                           ; $6D4B


; C
DjS2_Field06_DrawCursor::
    ld bc, $053d                                  ; $6D4C
    ld a, $9b                                     ; $6D4F
    call DjEd_DrawFieldCursor                     ; $6D51
    ldh a, [hFrameCounter]                        ; $6D54
    bit 4, a                                      ; $6D56
    ret z                                         ; $6D58

    ld bc, $0e46                                  ; $6D59
    ld a, $7d                                     ; $6D5C
    call Oam_AddMeta_B01_5D2B                     ; $6D5E
    ret                                           ; $6D61


; C: handler of the DjS2 field cursor value 7
DjS2_Field07_NoteGrid::
    call DjS2_Field07_SyncCursor                  ; $6D62
    call DjS2_Field07_Edit                        ; $6D65
    call DjS2_Field07_DrawCursor                  ; $6D68
    ldh a, [hKeysNew]                             ; $6D6B
    bit PADB_UP, a                                ; $6D6D
    jr z, jr_005_6d82                             ; $6D6F

    ui_sfx $01                                    ; $6D71
    ld a, $06                                     ; $6D78
    ld [wSound2FieldCursor], a                    ; $6D7A
    xor a                                         ; $6D7D
    ld [wSndCursorPopFrames], a                   ; $6D7E
    ret                                           ; $6D81


jr_005_6d82:
    bit 3, a                                      ; $6D82
    jr z, jr_005_6d93                             ; $6D84

    ui_sfx $04                                    ; $6D86
    ld a, $09                                     ; $6D8D
    ld [wSound2FieldCursor], a                    ; $6D8F
    ret                                           ; $6D92


jr_005_6d93:
    bit 0, a                                      ; $6D93
    ret z                                         ; $6D95

    ui_sfx $04                                    ; $6D96
    ld a, $08                                     ; $6D9D
    ld [wSound2FieldCursor], a                    ; $6D9F
    ret                                           ; $6DA2


; C
DjS2_Field07_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6DA3
    ld hl, wSound2FieldCursor + $1                ; $6DA6
    cp [hl]                                       ; $6DA9
    ret z                                         ; $6DAA

    ld [hl], a                                    ; $6DAB
    ret                                           ; $6DAC


; C
DjS2_Field07_Edit::
    ld a, [wSound2NoteCursor]                     ; $6DAD
    ld bc, $000f                                  ; $6DB0
    call DjEd_StepLeftRight                       ; $6DB3
    ld [wSound2NoteCursor], a                     ; $6DB6
    ld a, [wSound2NoteCursor]                     ; $6DB9
    ld c, a                                       ; $6DBC
    ld b, $00                                     ; $6DBD
    ld hl, wSound2Notes                           ; $6DBF
    add hl, bc                                    ; $6DC2
    ldh a, [hKeysNew]                             ; $6DC3
    bit PADB_DOWN, a                              ; $6DC5
    ret z                                         ; $6DC7

    xor a                                         ; $6DC8
    ld [hl], a                                    ; $6DC9
    ld a, [wSound2NoteCursor]                     ; $6DCA
    ld hl, wSound2Notes                           ; $6DCD
    call DjEd_DrawNoteRowOffset                   ; $6DD0
    ret                                           ; $6DD3


; C
DjS2_Field07_DrawCursor::
    ld bc, $0557                                  ; $6DD4
    ld a, $9e                                     ; $6DD7
    call DjEd_DrawFieldCursor                     ; $6DD9
    ldh a, [hFrameCounter]                        ; $6DDC
    bit 4, a                                      ; $6DDE
    jr z, jr_005_6df5                             ; $6DE0

    ld a, [wSound2NoteCursor]                     ; $6DE2
    sla a                                         ; $6DE5
    sla a                                         ; $6DE7
    sla a                                         ; $6DE9
    add $1d                                       ; $6DEB
    ld b, a                                       ; $6DED
    ld c, $57                                     ; $6DEE
    ld a, $7c                                     ; $6DF0
    call Oam_AddMeta_B01_5D2B                     ; $6DF2

jr_005_6df5:
    ld a, [wSound2NoteCursor]                     ; $6DF5
    call DjEd_DrawNoteMarker                      ; $6DF8
    ld hl, wSound2Notes                           ; $6DFB
    ld a, [wSound2NoteCursor]                     ; $6DFE
    call DjEd_DrawNoteStepCursor                  ; $6E01
    ld e, $00                                     ; $6E04
    ld hl, wSound2Stereo                          ; $6E06
    ld a, [wSound2NoteCursor]                     ; $6E09
    call DjEd_DrawNoteColumn                      ; $6E0C
    ret                                           ; $6E0F


; C: handler of the DjS2 field cursor value 8
DjS2_Field08_NoteEdit::
    call DjS2_Field08_SyncCursor                  ; $6E10
    call DjS2_Field08_Edit                        ; $6E13
    call DjS2_Field08_DrawCursor                  ; $6E16
    ldh a, [hKeysHeld]                            ; $6E19
    bit PADB_A, a                                 ; $6E1B
    ret nz                                        ; $6E1D

    ui_sfx $05                                    ; $6E1E
    call DjS2_Field08_DrawMarker                  ; $6E25
    ld a, $07                                     ; $6E28
    ld [wSound2FieldCursor], a                    ; $6E2A
    ret                                           ; $6E2D


; C
DjS2_Field08_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6E2E
    ld hl, wSound2FieldCursor + $1                ; $6E31
    cp [hl]                                       ; $6E34
    ret z                                         ; $6E35

    ld [hl], a                                    ; $6E36
    ret                                           ; $6E37


; C
DjS2_Field08_Edit::
    ld a, [wSound2NoteCursor]                     ; $6E38
    ld c, a                                       ; $6E3B
    ld b, $00                                     ; $6E3C
    ld hl, wSound2Notes                           ; $6E3E
    add hl, bc                                    ; $6E41
    ld bc, $0025                                  ; $6E42
    ld a, [hl]                                    ; $6E45
    push hl                                       ; $6E46
    call DjEd_StepLeftRight                       ; $6E47
    pop hl                                        ; $6E4A
    cp [hl]                                       ; $6E4B
    ret z                                         ; $6E4C

    ld [hl], a                                    ; $6E4D
    call DjS2_Field08_DrawMarker                  ; $6E4E
    ret                                           ; $6E51


; C
DjS2_Field08_DrawCursor::
    ld bc, $0557                                  ; $6E52
    ld a, $9e                                     ; $6E55
    call DjEd_DrawFieldCursor                     ; $6E57
    ld hl, wSound2Notes                           ; $6E5A
    ld a, [wSound2NoteCursor]                     ; $6E5D
    call DjEd_DrawNoteStepCursor                  ; $6E60
    ldh a, [hKeysHeld]                            ; $6E63
    and PADF_RIGHT | PADF_LEFT                    ; $6E65
    ld hl, wSound2Notes                           ; $6E67
    ld a, [wSound2NoteCursor]                     ; $6E6A
    call z, DjEd_DrawNoteCursorBlink              ; $6E6D
    ld a, [wSound2NoteCursor]                     ; $6E70
    sla a                                         ; $6E73
    sla a                                         ; $6E75
    sla a                                         ; $6E77
    add $1d                                       ; $6E79
    ld b, a                                       ; $6E7B
    ld c, $57                                     ; $6E7C
    ld a, $7c                                     ; $6E7E
    call Oam_AddMeta_B01_5D2B                     ; $6E80
    ld e, $00                                     ; $6E83
    ld hl, wSound2Stereo                          ; $6E85
    ld a, [wSound2NoteCursor]                     ; $6E88
    call DjEd_DrawNoteColumn                      ; $6E8B
    ret                                           ; $6E8E


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND II field 8 (note edit)
DjS2_Field08_DrawMarker::
    ld a, [wSound2NoteCursor]                     ; $6E8F
    ld hl, wSound2Notes                           ; $6E92
    call DjEd_DrawNoteRowOffset                   ; $6E95
    ret                                           ; $6E98


; C: handler of the DjS2 field cursor value 9
DjS2_Field09_StereoEdit::
    call DjS2_Field09_SyncCursor                  ; $6E99
    call DjS2_Field09_Edit                        ; $6E9C
    call DjS2_Field09_DrawCursor                  ; $6E9F
    ldh a, [hKeysHeld]                            ; $6EA2
    bit PADB_START, a                             ; $6EA4
    ret nz                                        ; $6EA6

    ui_sfx $05                                    ; $6EA7
    ld a, $07                                     ; $6EAE
    ld [wSound2FieldCursor], a                    ; $6EB0
    ret                                           ; $6EB3


; C
DjS2_Field09_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6EB4
    ld hl, wSound2FieldCursor + $1                ; $6EB7
    cp [hl]                                       ; $6EBA
    ret z                                         ; $6EBB

    ld [hl], a                                    ; $6EBC
    ld a, [wSound2NoteCursor]                     ; $6EBD
    ld c, a                                       ; $6EC0
    ld b, $00                                     ; $6EC1
    ld hl, wSound2Stereo                          ; $6EC3
    add hl, bc                                    ; $6EC6
    ld a, [hl]                                    ; $6EC7
    and $03                                       ; $6EC8
    ld [wSound2StereoEdit], a                     ; $6ECA
    ret                                           ; $6ECD


; C
DjS2_Field09_Edit::
    ld a, [wSound2StereoEdit]                     ; $6ECE
    ld bc, $0002                                  ; $6ED1
    call DjEd_StepLeftRight                       ; $6ED4
    ld [wSound2StereoEdit], a                     ; $6ED7
    ld a, [wSound2NoteCursor]                     ; $6EDA
    ld c, a                                       ; $6EDD
    ld b, $00                                     ; $6EDE
    ld hl, wSound2Stereo                          ; $6EE0
    add hl, bc                                    ; $6EE3
    ld a, [wSound2StereoEdit]                     ; $6EE4
    ld [hl], a                                    ; $6EE7
    ret                                           ; $6EE8


; C
DjS2_Field09_DrawCursor::
    ld bc, $0557                                  ; $6EE9
    ld a, $9e                                     ; $6EEC
    call DjEd_DrawFieldCursor                     ; $6EEE
    ld a, [wSound2NoteCursor]                     ; $6EF1
    sla a                                         ; $6EF4
    sla a                                         ; $6EF6
    sla a                                         ; $6EF8
    add $1d                                       ; $6EFA
    ld b, a                                       ; $6EFC
    ld c, $57                                     ; $6EFD
    ld a, $7c                                     ; $6EFF
    call Oam_AddMeta_B01_5D2B                     ; $6F01
    ld hl, wSound2Notes                           ; $6F04
    ld a, [wSound2NoteCursor]                     ; $6F07
    call DjEd_DrawNoteStepCursor                  ; $6F0A
    ldh a, [hFrameCounter]                        ; $6F0D
    srl a                                         ; $6F0F
    srl a                                         ; $6F11
    srl a                                         ; $6F13
    and $01                                       ; $6F15
    ld e, a                                       ; $6F17
    ld hl, wSound2Stereo                          ; $6F18
    ld a, [wSound2NoteCursor]                     ; $6F1B
    call DjEd_DrawNoteColumn                      ; $6F1E
    ret                                           ; $6F21


; C
DjS2_WaveRedrawTick::
    ld a, [wLoopLengths + $1]                     ; $6F22
    ld c, a                                       ; $6F25
    ld a, [wSound2PlayStep]                       ; $6F26
    call Call_005_4a64                            ; $6F29
    ld a, [wSound2FieldCursor]                    ; $6F2C
    cp $07                                        ; $6F2F
    ret z                                         ; $6F31

    cp $08                                        ; $6F32
    ret z                                         ; $6F34

    cp $09                                        ; $6F35
    ret z                                         ; $6F37

    call DjEd_DrawLoopBar                         ; $6F38
    ret                                           ; $6F3B


; C: D8F1 = 4
DjS2_WaveRedrawStart::
    ld a, $04                                     ; $6F3C
    ld [wWaveGraphPhase], a                       ; $6F3E
    ret                                           ; $6F41


; C: 8 columns per frame
DjS2_WaveRedrawColumns::
    ld a, [wWaveGraphPhase]                       ; $6F42
    and a                                         ; $6F45
    ret z                                         ; $6F46

    dec a                                         ; $6F47
    ld [wWaveGraphPhase], a                       ; $6F48
    sla a                                         ; $6F4B
    sla a                                         ; $6F4D
    sla a                                         ; $6F4F
    ld c, a                                       ; $6F51
    ld b, $00                                     ; $6F52
    ld hl, wWaveStaging                           ; $6F54
    add hl, bc                                    ; $6F57
    ld b, $08                                     ; $6F58

jr_005_6f5a:
    ld a, [hl+]                                   ; $6F5A
    push bc                                       ; $6F5B
    call DjS2_WaveGraphColumn                     ; $6F5C
    pop bc                                        ; $6F5F
    inc c                                         ; $6F60
    dec b                                         ; $6F61
    jr nz, jr_005_6f5a                            ; $6F62

    ret                                           ; $6F64


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjS2_WaveGraphColumn::
    push hl                                       ; $6F65
    push af                                       ; $6F66
    ld a, c                                       ; $6F67
    and $0c                                       ; $6F68
    swap a                                        ; $6F6A
    ld e, a                                       ; $6F6C
    ld a, c                                       ; $6F6D
    and $10                                       ; $6F6E
    swap a                                        ; $6F70
    ld d, a                                       ; $6F72
    ld hl, wLevelTileStaging + $1                 ; $6F73
    add hl, de                                    ; $6F76
    pop af                                        ; $6F77
    ld b, $0f                                     ; $6F78

; C: per-row loop top of one wave-graph column (B counts down, bit 3 of B selects the compare direction) (branch
; target; code read 2026-10-19)
DjS2_WaveGraphColumn_RowLoop::
    push af                                       ; $6F7A
    bit 3, b                                      ; $6F7B
    jr z, jr_005_6f84                             ; $6F7D

    cp b                                          ; $6F7F
    jr c, jr_005_6fa0                             ; $6F80

    jr jr_005_6f89                                ; $6F82

jr_005_6f84:
    cp b                                          ; $6F84
    jr z, jr_005_6f89                             ; $6F85

    jr nc, jr_005_6fa0                            ; $6F87

jr_005_6f89:
    push hl                                       ; $6F89
    ld a, c                                       ; $6F8A
    and $03                                       ; $6F8B
    ld e, a                                       ; $6F8D
    ld d, $00                                     ; $6F8E
    ld hl, DjS2_WaveGraphColumn_Tbl6FC5           ; $6F90
    add hl, de                                    ; $6F93
    ld a, [hl]                                    ; $6F94
    pop hl                                        ; $6F95
    push af                                       ; $6F96
    or [hl]                                       ; $6F97
    ld [hl], a                                    ; $6F98
    pop af                                        ; $6F99
    inc l                                         ; $6F9A
    inc l                                         ; $6F9B
    or [hl]                                       ; $6F9C
    ld [hl], a                                    ; $6F9D
    jr jr_005_6fb5                                ; $6F9E

jr_005_6fa0:
    push hl                                       ; $6FA0
    ld a, c                                       ; $6FA1
    and $03                                       ; $6FA2
    ld e, a                                       ; $6FA4
    ld d, $00                                     ; $6FA5
    ld hl, DjS2_WaveGraphColumn_Tbl6FC9           ; $6FA7
    add hl, de                                    ; $6FAA
    ld a, [hl]                                    ; $6FAB
    pop hl                                        ; $6FAC
    push af                                       ; $6FAD
    and [hl]                                      ; $6FAE
    ld [hl], a                                    ; $6FAF
    pop af                                        ; $6FB0
    inc l                                         ; $6FB1
    inc l                                         ; $6FB2
    and [hl]                                      ; $6FB3
    ld [hl], a                                    ; $6FB4

jr_005_6fb5:
    inc l                                         ; $6FB5
    inc l                                         ; $6FB6
    pop af                                        ; $6FB7
    dec b                                         ; $6FB8
    bit 7, b                                      ; $6FB9
    jp z, DjS2_WaveGraphColumn_RowLoop            ; $6FBB

    pop hl                                        ; $6FBE
    ld a, $03                                     ; $6FBF
    ld [wWaveRedrawCountdown], a                  ; $6FC1
    ret                                           ; $6FC4


; C: auto: 4 bytes, bytes; referenced by DjS2_WaveGraphColumn. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjS2_WaveGraphColumn_Tbl6FC5::
    db $c0, $30, $0c, $03

; C: auto: 4 bytes, bytes; referenced by DjS2_WaveGraphColumn. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjS2_WaveGraphColumn_Tbl6FC9::
    db $3f, $cf, $f3, $fc

; C: copies the wave graph to VRAM $9200 / $9300
DjS2_WaveGraphToVram::
    ld a, [wWaveRedrawCountdown]                  ; $6FCD
    and a                                         ; $6FD0
    ret z                                         ; $6FD1

    dec a                                         ; $6FD2
    ld [wWaveRedrawCountdown], a                  ; $6FD3
    jr nz, jr_005_6ff5                            ; $6FD6

    ld a, $00                                     ; $6FD8
    ld hl, wLevelTileStaging + $100               ; $6FDA
    ld de, $9200                                  ; $6FDD
    ld bc, $0080                                  ; $6FE0
    call Vram_CopyFromBank                        ; $6FE3
    ld a, $00                                     ; $6FE6
    ld hl, wLevelTileStaging + $180               ; $6FE8
    ld de, $9300                                  ; $6FEB
    ld bc, $0080                                  ; $6FEE
    call Vram_CopyFromBank                        ; $6FF1
    ret                                           ; $6FF4


jr_005_6ff5:
    cp $01                                        ; $6FF5
    ret nz                                        ; $6FF7

    ld a, $00                                     ; $6FF8
    ld hl, wLevelTileStaging                      ; $6FFA
    ld de, $9000                                  ; $6FFD
    ld bc, $0080                                  ; $7000
    call Vram_CopyFromBank                        ; $7003
    ld a, $00                                     ; $7006
    ld hl, wLevelTileStaging + $80                ; $7008
    ld de, $9100                                  ; $700B
    ld bc, $0080                                  ; $700E
    call Vram_CopyFromBank                        ; $7011
    ret                                           ; $7014


; C
DjNs_DrawAllValues::
    ld a, [wNoiseEnvelope + $2]                   ; $7015
    call DjEd_DrawVolumeDigits                    ; $7018
    ld a, [wNoiseEnvelope + $1]                   ; $701B
    call DjEd_DrawEnvPeriodDigit                  ; $701E
    ld a, [wNoiseGateLoop]                        ; $7021
    call DjEd_DrawLengthDigit                     ; $7024
    ld a, [wNoiseGateLoop + $1]                   ; $7027
    call DjEd_DrawLoopDigitsAndPrint              ; $702A
    ret                                           ; $702D


; C: handler of the DjNs field cursor value 0
DjNs_Field00_EnvDir::
    call DjNs_Field00_SyncCursor                  ; $702E
    call DjNs_Field00_Edit                        ; $7031
    call DjNs_Field00_DrawCursor                  ; $7034
    ldh a, [hKeysNew]                             ; $7037
    bit PADB_RIGHT, a                             ; $7039
    jr z, jr_005_704a                             ; $703B

    ui_sfx $01                                    ; $703D
    ld a, $01                                     ; $7044
    ld [wNoiseFieldCursor], a                     ; $7046
    ret                                           ; $7049


jr_005_704a:
    bit 7, a                                      ; $704A
    ret z                                         ; $704C

    ui_sfx $01                                    ; $704D
    ld a, [wNoiseFieldCursor]                     ; $7054
    ld [wNoiseFieldCursor + $2], a                ; $7057
    ld a, $04                                     ; $705A
    ld [wNoiseFieldCursor], a                     ; $705C
    xor a                                         ; $705F
    ld [wSndCursorPopFrames], a                   ; $7060
    ret                                           ; $7063


; C
DjNs_Field00_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7064
    ld hl, wNoiseFieldCursor + $1                 ; $7067
    cp [hl]                                       ; $706A
    ret z                                         ; $706B

    ld [hl], a                                    ; $706C
    ret                                           ; $706D


; C
DjNs_Field00_Edit::
    ld a, [wNoiseEnvelope]                        ; $706E
    ld bc, $0001                                  ; $7071
    call DjEd_StepValue_Up                        ; $7074
    ld hl, wNoiseEnvelope                         ; $7077
    cp [hl]                                       ; $707A
    ret z                                         ; $707B

    ld [hl], a                                    ; $707C
    ld hl, $9884                                  ; $707D
    add $da                                       ; $7080
    call Vram_WriteByteSafe                       ; $7082
    ret                                           ; $7085


; C
DjNs_Field00_DrawCursor::
    ld bc, $1c1c                                  ; $7086
    ld a, $95                                     ; $7089
    call DjEd_DrawFieldCursor                     ; $708B
    ldh a, [hFrameCounter]                        ; $708E
    bit 4, a                                      ; $7090
    ret z                                         ; $7092

    ld a, [wNoiseEnvelope]                        ; $7093
    sla a                                         ; $7096
    sla a                                         ; $7098
    add $26                                       ; $709A
    ld c, a                                       ; $709C
    ld b, $22                                     ; $709D
    ld a, $78                                     ; $709F
    call Oam_AddMeta_B01_5D2B                     ; $70A1
    ret                                           ; $70A4


; C: handler of the DjNs field cursor value 1
DjNs_Field01_Volume::
    call DjNs_Field01_SyncCursor                  ; $70A5
    call DjNs_Field01_Edit                        ; $70A8
    call DjNs_Field01_DrawCursor                  ; $70AB
    ldh a, [hKeysNew]                             ; $70AE
    bit PADB_LEFT, a                              ; $70B0
    jr z, jr_005_70c1                             ; $70B2

    ui_sfx $01                                    ; $70B4
    ld a, $00                                     ; $70BB
    ld [wNoiseFieldCursor], a                     ; $70BD
    ret                                           ; $70C0


jr_005_70c1:
    bit 4, a                                      ; $70C1
    jr z, jr_005_70d2                             ; $70C3

    ui_sfx $01                                    ; $70C5
    ld a, $02                                     ; $70CC
    ld [wNoiseFieldCursor], a                     ; $70CE
    ret                                           ; $70D1


jr_005_70d2:
    bit 7, a                                      ; $70D2
    ret z                                         ; $70D4

    ui_sfx $01                                    ; $70D5
    ld a, [wNoiseFieldCursor]                     ; $70DC
    ld [wNoiseFieldCursor + $2], a                ; $70DF
    ld a, $04                                     ; $70E2
    ld [wNoiseFieldCursor], a                     ; $70E4
    xor a                                         ; $70E7
    ld [wSndCursorPopFrames], a                   ; $70E8
    ret                                           ; $70EB


; C
DjNs_Field01_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $70EC
    ld hl, wNoiseFieldCursor + $1                 ; $70EF
    cp [hl]                                       ; $70F2
    ret z                                         ; $70F3

    ld [hl], a                                    ; $70F4
    ret                                           ; $70F5


; C
DjNs_Field01_Edit::
    ld a, [wNoiseEnvelope + $2]                   ; $70F6
    ld bc, $000f                                  ; $70F9
    call DjEd_StepValue_Right                     ; $70FC
    ld hl, wNoiseEnvelope + $2                    ; $70FF
    cp [hl]                                       ; $7102
    ret z                                         ; $7103

    ld [hl], a                                    ; $7104
    ret                                           ; $7105


; C
DjNs_Field01_DrawCursor::
    ld bc, $1c1c                                  ; $7106
    ld a, $95                                     ; $7109
    call DjEd_DrawFieldCursor                     ; $710B
    ldh a, [hFrameCounter]                        ; $710E
    bit 4, a                                      ; $7110
    ret z                                         ; $7112

    ld bc, $312c                                  ; $7113
    ld a, $7d                                     ; $7116
    call Oam_AddMeta_B01_5D2B                     ; $7118
    ret                                           ; $711B


; C: handler of the DjNs field cursor value 2
DjNs_Field02_EnvPeriod::
    call DjNs_Field02_SyncCursor                  ; $711C
    call DjNs_Field02_Edit                        ; $711F
    call DjNs_Field02_DrawCursor                  ; $7122
    ldh a, [hKeysNew]                             ; $7125
    bit PADB_LEFT, a                              ; $7127
    jr z, jr_005_7138                             ; $7129

    ui_sfx $01                                    ; $712B
    ld a, $01                                     ; $7132
    ld [wNoiseFieldCursor], a                     ; $7134
    ret                                           ; $7137


jr_005_7138:
    bit 4, a                                      ; $7138
    jr z, jr_005_7149                             ; $713A

    ui_sfx $01                                    ; $713C
    ld a, $03                                     ; $7143
    ld [wNoiseFieldCursor], a                     ; $7145
    ret                                           ; $7148


jr_005_7149:
    bit 7, a                                      ; $7149
    ret z                                         ; $714B

    ui_sfx $01                                    ; $714C
    ld a, [wNoiseFieldCursor]                     ; $7153
    ld [wNoiseFieldCursor + $2], a                ; $7156
    ld a, $04                                     ; $7159
    ld [wNoiseFieldCursor], a                     ; $715B
    xor a                                         ; $715E
    ld [wSndCursorPopFrames], a                   ; $715F
    ret                                           ; $7162


; C
DjNs_Field02_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7163
    ld hl, wNoiseFieldCursor + $1                 ; $7166
    cp [hl]                                       ; $7169
    ret z                                         ; $716A

    ld [hl], a                                    ; $716B
    ld [wNoiseFieldCursor + $2], a                ; $716C
    ret                                           ; $716F


; C
DjNs_Field02_Edit::
    ld a, [wNoiseEnvelope + $1]                   ; $7170
    ld bc, $0007                                  ; $7173
    call DjEd_StepValue_Right                     ; $7176
    ld hl, wNoiseEnvelope + $1                    ; $7179
    cp [hl]                                       ; $717C
    ret z                                         ; $717D

    ld [hl], a                                    ; $717E
    ret                                           ; $717F


; C
DjNs_Field02_DrawCursor::
    ld bc, $1c1c                                  ; $7180
    ld a, $95                                     ; $7183
    call DjEd_DrawFieldCursor                     ; $7185
    ldh a, [hFrameCounter]                        ; $7188
    bit 4, a                                      ; $718A
    ret z                                         ; $718C

    ld bc, $422c                                  ; $718D
    ld a, $7d                                     ; $7190
    call Oam_AddMeta_B01_5D2B                     ; $7192
    ret                                           ; $7195


; C: handler of the DjNs field cursor value 3
DjNs_Field03_Gate::
    call DjNs_Field03_SyncCursor                  ; $7196
    call DjNs_Field03_Edit                        ; $7199
    call DjNs_Field03_DrawCursor                  ; $719C
    ldh a, [hKeysNew]                             ; $719F
    bit PADB_LEFT, a                              ; $71A1
    jr z, jr_005_71b2                             ; $71A3

    ui_sfx $01                                    ; $71A5
    ld a, $02                                     ; $71AC
    ld [wNoiseFieldCursor], a                     ; $71AE
    ret                                           ; $71B1


jr_005_71b2:
    bit 7, a                                      ; $71B2
    ret z                                         ; $71B4

    ui_sfx $01                                    ; $71B5
    ld a, [wNoiseFieldCursor]                     ; $71BC
    ld [wNoiseFieldCursor + $2], a                ; $71BF
    ld a, $04                                     ; $71C2
    ld [wNoiseFieldCursor], a                     ; $71C4
    xor a                                         ; $71C7
    ld [wSndCursorPopFrames], a                   ; $71C8
    ret                                           ; $71CB


; C
DjNs_Field03_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $71CC
    ld hl, wNoiseFieldCursor + $1                 ; $71CF
    cp [hl]                                       ; $71D2
    ret z                                         ; $71D3

    ld [hl], a                                    ; $71D4
    ld [wNoiseFieldCursor + $2], a                ; $71D5
    ret                                           ; $71D8


; C
DjNs_Field03_Edit::
    ld a, [wNoiseGateLoop]                        ; $71D9
    ld bc, $0009                                  ; $71DC
    call DjEd_StepValue_Right                     ; $71DF
    ld hl, wNoiseGateLoop                         ; $71E2
    cp [hl]                                       ; $71E5
    ret z                                         ; $71E6

    ld [hl], a                                    ; $71E7
    ret                                           ; $71E8


; C
DjNs_Field03_DrawCursor::
    ld bc, $1c1c                                  ; $71E9
    ld a, $95                                     ; $71EC
    call DjEd_DrawFieldCursor                     ; $71EE
    ldh a, [hFrameCounter]                        ; $71F1
    bit 4, a                                      ; $71F3
    ret z                                         ; $71F5

    ld bc, $5a2a                                  ; $71F6
    ld a, $7d                                     ; $71F9
    call Oam_AddMeta_B01_5D2B                     ; $71FB
    ret                                           ; $71FE


; C: handler of the DjNs field cursor value 4
DjNs_Field04_LoopLength::
    call DjNs_Field04_SyncCursor                  ; $71FF
    call DjNs_Field04_Edit                        ; $7202
    call DjNs_Field04_DrawCursor                  ; $7205
    ldh a, [hKeysNew]                             ; $7208
    bit PADB_UP, a                                ; $720A
    jr z, jr_005_7220                             ; $720C

    ui_sfx $01                                    ; $720E
    ld a, [wNoiseFieldCursor + $2]                ; $7215
    ld [wNoiseFieldCursor], a                     ; $7218
    xor a                                         ; $721B
    ld [wSndCursorPopFrames], a                   ; $721C
    ret                                           ; $721F


jr_005_7220:
    bit 7, a                                      ; $7220
    ret z                                         ; $7222

    ui_sfx $01                                    ; $7223
    call DjEd_DrawLoopBar                         ; $722A
    call DjEd_DrawLoopBarNoise                    ; $722D
    ld a, $05                                     ; $7230
    ld [wNoiseFieldCursor], a                     ; $7232
    xor a                                         ; $7235
    ld [wSndCursorPopFrames], a                   ; $7236
    ret                                           ; $7239


; C
DjNs_Field04_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $723A
    ld hl, wNoiseFieldCursor + $1                 ; $723D
    cp [hl]                                       ; $7240
    ret z                                         ; $7241

    ld [hl], a                                    ; $7242
    ret                                           ; $7243


; C
DjNs_Field04_Edit::
    ld a, [wNoiseGateLoop + $1]                   ; $7244
    ld bc, $0210                                  ; $7247
    call DjEd_StepValue_Right                     ; $724A
    ld [wNoiseGateLoop + $1], a                   ; $724D
    ld a, [wNoiseGateLoop + $1]                   ; $7250
    ld bc, $0210                                  ; $7253
    call DjEd_StepValue_LeftRight                 ; $7256
    ld [wNoiseGateLoop + $1], a                   ; $7259
    ret                                           ; $725C


; C
DjNs_Field04_DrawCursor::
    ld bc, $053d                                  ; $725D
    ld a, $9b                                     ; $7260
    call DjEd_DrawFieldCursor                     ; $7262
    ldh a, [hFrameCounter]                        ; $7265
    bit 4, a                                      ; $7267
    ret z                                         ; $7269

    ld bc, $0e46                                  ; $726A
    ld a, $7d                                     ; $726D
    call Oam_AddMeta_B01_5D2B                     ; $726F
    ret                                           ; $7272


; C: handler of the DjNs field cursor value 5
DjNs_Field05_NoteGrid::
    call DjNs_Field05_SyncCursor                  ; $7273
    call DjNs_Field05_Edit                        ; $7276
    call DjNs_Field05_DrawCursor                  ; $7279
    ldh a, [hKeysNew]                             ; $727C
    bit PADB_UP, a                                ; $727E
    jr z, jr_005_7293                             ; $7280

    ui_sfx $01                                    ; $7282
    ld a, $04                                     ; $7289
    ld [wNoiseFieldCursor], a                     ; $728B
    xor a                                         ; $728E
    ld [wSndCursorPopFrames], a                   ; $728F
    ret                                           ; $7292


jr_005_7293:
    bit 3, a                                      ; $7293
    jr z, jr_005_72a4                             ; $7295

    ui_sfx $04                                    ; $7297
    ld a, $07                                     ; $729E
    ld [wNoiseFieldCursor], a                     ; $72A0
    ret                                           ; $72A3


jr_005_72a4:
    bit 0, a                                      ; $72A4
    ret z                                         ; $72A6

    ui_sfx $04                                    ; $72A7
    ld a, $06                                     ; $72AE
    ld [wNoiseFieldCursor], a                     ; $72B0
    ret                                           ; $72B3


; C
DjNs_Field05_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $72B4
    ld hl, wNoiseFieldCursor + $1                 ; $72B7
    cp [hl]                                       ; $72BA
    ret z                                         ; $72BB

    ld [hl], a                                    ; $72BC
    ret                                           ; $72BD


; C
DjNs_Field05_Edit::
    ld a, [wNoiseNoteCursor]                      ; $72BE
    ld bc, $000f                                  ; $72C1
    call DjEd_StepLeftRight                       ; $72C4
    ld [wNoiseNoteCursor], a                      ; $72C7
    ld a, [wNoiseNoteCursor]                      ; $72CA
    ld c, a                                       ; $72CD
    ld b, $00                                     ; $72CE
    ld hl, wNoiseNotes                            ; $72D0
    add hl, bc                                    ; $72D3
    ldh a, [hKeysNew]                             ; $72D4
    bit PADB_DOWN, a                              ; $72D6
    ret z                                         ; $72D8

    xor a                                         ; $72D9
    ld [hl], a                                    ; $72DA
    ld a, [wNoiseNoteCursor]                      ; $72DB
    ld hl, wNoiseNotes                            ; $72DE
    call DjEd_DrawNoteRowOffset                   ; $72E1
    ret                                           ; $72E4


; C
DjNs_Field05_DrawCursor::
    ld bc, $0557                                  ; $72E5
    ld a, $9e                                     ; $72E8
    call DjEd_DrawFieldCursor                     ; $72EA
    ldh a, [hFrameCounter]                        ; $72ED
    bit 4, a                                      ; $72EF
    jr z, jr_005_7306                             ; $72F1

    ld a, [wNoiseNoteCursor]                      ; $72F3
    sla a                                         ; $72F6
    sla a                                         ; $72F8
    sla a                                         ; $72FA
    add $1d                                       ; $72FC
    ld b, a                                       ; $72FE
    ld c, $57                                     ; $72FF
    ld a, $7c                                     ; $7301
    call Oam_AddMeta_B01_5D2B                     ; $7303

jr_005_7306:
    ld a, [wNoiseNoteCursor]                      ; $7306
    call DjEd_DrawNoteMarker                      ; $7309
    ld hl, wNoiseNotes                            ; $730C
    ld a, [wNoiseNoteCursor]                      ; $730F
    call DjEd_DrawNoteStepCursor                  ; $7312
    ld e, $00                                     ; $7315
    ld hl, wNoiseStereoWidth                      ; $7317
    ld a, [wNoiseNoteCursor]                      ; $731A
    call DjEd_DrawNoteColumn                      ; $731D
    ld e, $00                                     ; $7320
    ld hl, wNoiseStereoWidth                      ; $7322
    ld a, [wNoiseNoteCursor]                      ; $7325
    call DjEd_DrawWidthFlag                       ; $7328
    ret                                           ; $732B


; C: handler of the DjNs field cursor value 6
DjNs_Field06_NoteEdit::
    call DjNs_Field06_SyncCursor                  ; $732C
    call DjNs_Field06_Edit                        ; $732F
    call DjNs_Field06_DrawCursor                  ; $7332
    ldh a, [hKeysHeld]                            ; $7335
    bit PADB_A, a                                 ; $7337
    ret nz                                        ; $7339

    ui_sfx $05                                    ; $733A
    call DjNs_Field06_DrawMarker                  ; $7341
    ld a, $07                                     ; $7344
    ld [wNoiseFieldCursor], a                     ; $7346
    ret                                           ; $7349


; C
DjNs_Field06_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $734A
    ld hl, wNoiseFieldCursor + $1                 ; $734D
    cp [hl]                                       ; $7350
    ret z                                         ; $7351

    ld [hl], a                                    ; $7352
    ret                                           ; $7353


; C
DjNs_Field06_Edit::
    ld a, [wNoiseNoteCursor]                      ; $7354
    ld c, a                                       ; $7357
    ld b, $00                                     ; $7358
    ld hl, wNoiseNotes                            ; $735A
    add hl, bc                                    ; $735D
    ld bc, $0025                                  ; $735E
    ld a, [hl]                                    ; $7361
    push hl                                       ; $7362
    call DjEd_StepLeftRight                       ; $7363
    pop hl                                        ; $7366
    cp [hl]                                       ; $7367
    jr z, jr_005_736e                             ; $7368

    ld [hl], a                                    ; $736A
    call DjNs_Field06_DrawMarker                  ; $736B

jr_005_736e:
    ld a, [wNoiseNoteCursor]                      ; $736E
    ld c, a                                       ; $7371
    ld b, $00                                     ; $7372
    ld hl, wNoiseStereoWidth                      ; $7374
    add hl, bc                                    ; $7377
    ld bc, $0001                                  ; $7378
    ld a, [hl]                                    ; $737B
    and $10                                       ; $737C
    swap a                                        ; $737E
    ld e, a                                       ; $7380
    push hl                                       ; $7381
    call DjEd_StepUpDown                          ; $7382
    pop hl                                        ; $7385
    cp e                                          ; $7386
    ret z                                         ; $7387

    swap a                                        ; $7388
    ld e, a                                       ; $738A
    ld a, [hl]                                    ; $738B
    and $0f                                       ; $738C
    or e                                          ; $738E
    ld [hl], a                                    ; $738F
    ret                                           ; $7390


; C
DjNs_Field06_DrawCursor::
    ld bc, $0557                                  ; $7391
    ld a, $9e                                     ; $7394
    call DjEd_DrawFieldCursor                     ; $7396
    ld hl, wNoiseNotes                            ; $7399
    ld a, [wNoiseNoteCursor]                      ; $739C
    call DjEd_DrawNoteStepCursor                  ; $739F
    ldh a, [hKeysHeld]                            ; $73A2
    and PADF_RIGHT | PADF_LEFT                    ; $73A4
    ld hl, wNoiseNotes                            ; $73A6
    ld a, [wNoiseNoteCursor]                      ; $73A9
    call z, DjEd_DrawNoteCursorBlink              ; $73AC
    ld a, [wNoiseNoteCursor]                      ; $73AF
    sla a                                         ; $73B2
    sla a                                         ; $73B4
    sla a                                         ; $73B6
    add $1d                                       ; $73B8
    ld b, a                                       ; $73BA
    ld c, $57                                     ; $73BB
    ld a, $7c                                     ; $73BD
    call Oam_AddMeta_B01_5D2B                     ; $73BF
    ld e, $00                                     ; $73C2
    ld hl, wNoiseStereoWidth                      ; $73C4
    ld a, [wNoiseNoteCursor]                      ; $73C7
    call DjEd_DrawNoteColumn                      ; $73CA
    ld e, $00                                     ; $73CD
    ld hl, wNoiseStereoWidth                      ; $73CF
    ld a, [wNoiseNoteCursor]                      ; $73D2
    call DjEd_DrawWidthFlag                       ; $73D5
    ret                                           ; $73D8


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of NOISE field 6 (note edit)
DjNs_Field06_DrawMarker::
    ld a, [wNoiseNoteCursor]                      ; $73D9
    ld hl, wNoiseNotes                            ; $73DC
    call DjEd_DrawNoteRowOffset                   ; $73DF
    ret                                           ; $73E2


; C: handler of the DjNs field cursor value 7
DjNs_Field07_StereoEdit::
    call DjNs_Field07_SyncCursor                  ; $73E3
    call DjNs_Field07_Edit                        ; $73E6
    call DjNs_Field07_DrawCursor                  ; $73E9
    ldh a, [hKeysHeld]                            ; $73EC
    bit PADB_START, a                             ; $73EE
    ret nz                                        ; $73F0

    ui_sfx $05                                    ; $73F1
    ld a, $05                                     ; $73F8
    ld [wNoiseFieldCursor], a                     ; $73FA
    ret                                           ; $73FD


; C
DjNs_Field07_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $73FE
    ld hl, wNoiseFieldCursor + $1                 ; $7401
    cp [hl]                                       ; $7404
    ret z                                         ; $7405

    ld [hl], a                                    ; $7406
    ld a, [wNoiseNoteCursor]                      ; $7407
    ld c, a                                       ; $740A
    ld b, $00                                     ; $740B
    ld hl, wNoiseStereoWidth                      ; $740D
    add hl, bc                                    ; $7410
    ld a, [hl]                                    ; $7411
    and $03                                       ; $7412
    ld [wNoiseStereoEdit], a                      ; $7414
    ret                                           ; $7417


; C
DjNs_Field07_Edit::
    ld a, [wNoiseStereoEdit]                      ; $7418
    ld bc, $0002                                  ; $741B
    call DjEd_StepLeftRight                       ; $741E
    ld [wNoiseStereoEdit], a                      ; $7421
    ld a, [wNoiseNoteCursor]                      ; $7424
    ld c, a                                       ; $7427
    ld b, $00                                     ; $7428
    ld hl, wNoiseStereoWidth                      ; $742A
    add hl, bc                                    ; $742D
    push hl                                       ; $742E
    ld a, [hl]                                    ; $742F
    and $f0                                       ; $7430
    ld hl, wNoiseStereoEdit                       ; $7432
    or [hl]                                       ; $7435
    pop hl                                        ; $7436
    ld [hl], a                                    ; $7437
    ret                                           ; $7438


; C
DjNs_Field07_DrawCursor::
    ld bc, $0557                                  ; $7439
    ld a, $9e                                     ; $743C
    call DjEd_DrawFieldCursor                     ; $743E
    ld a, [wNoiseNoteCursor]                      ; $7441
    sla a                                         ; $7444
    sla a                                         ; $7446
    sla a                                         ; $7448
    add $1d                                       ; $744A
    ld b, a                                       ; $744C
    ld c, $57                                     ; $744D
    ld a, $7c                                     ; $744F
    call Oam_AddMeta_B01_5D2B                     ; $7451
    ld hl, wNoiseNotes                            ; $7454
    ld a, [wNoiseNoteCursor]                      ; $7457
    call DjEd_DrawNoteStepCursor                  ; $745A
    ldh a, [hFrameCounter]                        ; $745D
    srl a                                         ; $745F
    srl a                                         ; $7461
    srl a                                         ; $7463
    and $01                                       ; $7465
    ld e, a                                       ; $7467
    ld hl, wNoiseStereoWidth                      ; $7468
    ld a, [wNoiseNoteCursor]                      ; $746B
    call DjEd_DrawNoteColumn                      ; $746E
    ldh a, [hFrameCounter]                        ; $7471
    srl a                                         ; $7473
    srl a                                         ; $7475
    srl a                                         ; $7477
    and $01                                       ; $7479
    ld e, a                                       ; $747B
    ld hl, wNoiseStereoWidth                      ; $747C
    ld a, [wNoiseNoteCursor]                      ; $747F
    call DjEd_DrawWidthFlag                       ; $7482
    ret                                           ; $7485


; C
DjNs_DrawPlayCursor::
    ld a, [wNoiseGateLoop + $1]                   ; $7486
    ld c, a                                       ; $7489
    ld a, [wNoisePlayStep]                        ; $748A
    call Call_005_4a64                            ; $748D
    ld a, [wNoiseFieldCursor]                     ; $7490
    cp $05                                        ; $7493
    ret z                                         ; $7495

    cp $06                                        ; $7496
    ret z                                         ; $7498

    cp $07                                        ; $7499
    ret z                                         ; $749B

    call DjEd_DrawLoopBar                         ; $749C
    call DjEd_DrawLoopBarNoise                    ; $749F
    ret                                           ; $74A2


; C: mode 20: BALL
Mode20_Ball::
    ld a, [wState]                                ; $74A3
    rst Rst18_JumpTable                           ; $74A6

; I: 12 states
Mode20_StateTable::
    dw Mode20_State00_MenuInit
    dw Mode20_State01_Menu
    dw Mode20_State02_GameSetup
    dw Mode20_State03_GameStart
    dw Mode20_State04_Play
    dw Mode20_State05_PlayDemo
    dw Mode20_State06_GameOver
    dw Mode20_State07_Pause
    dw Mode20_State08_Leave
    dw Mode20_State09_ResultInit
    dw Mode20_State0A_ResultKeys
    dw Mode20_State0B_ResultLeave

; C: character / music pick menu
Mode20_State00_MenuInit::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $74BF
    ldh [hLcdcShadow], a                          ; $74C1
    ld a, $e4                                     ; $74C3
    ld [wPaletteTarget], a                        ; $74C5
    ld [wPaletteTarget + $1], a                   ; $74C8
    ld a, $d2                                     ; $74CB
    ld [wPaletteTarget + $2], a                   ; $74CD
    xor a                                         ; $74D0
    ldh [hScxShadow], a                           ; $74D1
    ldh [hScyShadow], a                           ; $74D3
    ld [wMenuRow], a                              ; $74D5
    ldh [hFarcallAArg], a                         ; $74D8
    farcall GameFace_LoadTiles_Far                ; $74DA
    ld a, [wGamefacePresent]                      ; $74E2
    and a                                         ; $74E5
    jr z, jr_005_74ed                             ; $74E6

    ld a, $02                                     ; $74E8
    ld [wPickCharacter], a                        ; $74EA

jr_005_74ed:
    farcopy Mem_CopyFromBank, Gfx_1A_6400_Mode20_State00_MenuInit, $9000, $0800 ; $74ED
    farcopy Mem_CopyFromBank, Gfx_1A_6C00_Mode20_State00_MenuInit, $8800, $0800 ; $74FB
    farcopy Mem_CopyFromBank, Gfx_1A_7400_Mode20_State00_MenuInit, $8000, $0200 ; $7509
    farcopy Mem_CopyFromBank, Map_24_4480_Mode20_State00_MenuInit, $9800, $0240 ; $7517
    screen_on                                     ; $7525
    xor a                                         ; $752E
    call Ball_DrawMenuBall                        ; $752F
    play_music MUSIC_BALL_MENU                    ; $7532
    call Pal_FadeIn                               ; $7539
    next_state                                    ; $753C
    ret                                           ; $7540


; C
Mode20_State01_Menu::
    call Ball_MenuInput                           ; $7541
    call Ball_MenuDrawCursor                      ; $7544
    call Ball_MenuAnimA                           ; $7547
    call Ball_MenuAnimate                         ; $754A
    xor a                                         ; $754D
    call Ball_DrawMenuBall                        ; $754E
    ldh a, [hKeysNew]                             ; $7551
    bit PADB_A, a                                 ; $7553
    jr z, jr_005_7574                             ; $7555

    play_sfx1 SFX1_CHOOSE_D                       ; $7557
    ld a, $01                                     ; $755E
    call Ball_MenuBlinkSelection                  ; $7560
    screen_off                                    ; $7563
    ld a, [wMode]                                 ; $7569
    ld [wMode20Caller], a                         ; $756C
    next_state                                    ; $756F
    ret                                           ; $7573


jr_005_7574:
    bit 1, a                                      ; $7574
    ret z                                         ; $7576

    play_sfx1 SFX1_TAG_DIGITS_JINGLE              ; $7577
    ld a, $02                                     ; $757E
    call Ball_MenuBlinkSelection                  ; $7580
    screen_off                                    ; $7583
    ld a, MODE_MAIN_MENU                          ; $7589
    ld [wMode], a                                 ; $758B
    set_state STATE_00_INIT                       ; $758E
    ret                                           ; $7593


; C
Ball_MenuInput::
    ldh a, [hKeysNew]                             ; $7594
    bit PADB_UP, a                                ; $7596
    jr z, jr_005_759d                             ; $7598

    xor a                                         ; $759A
    jr jr_005_75a3                                ; $759B

jr_005_759d:
    bit 7, a                                      ; $759D
    jr z, jr_005_75b4                             ; $759F

    ld a, $01                                     ; $75A1

jr_005_75a3:
    ld hl, wMenuRow                               ; $75A3
    cp [hl]                                       ; $75A6
    jr z, jr_005_75b4                             ; $75A7

    ld [hl], a                                    ; $75A9
    play_sfx1 SFX1_MENU_CHOOSE                    ; $75AA
    call Ball_MenuLoadRow                         ; $75B1

jr_005_75b4:
    ld a, [wMenuRow]                              ; $75B4
    ld c, a                                       ; $75B7
    ld b, $00                                     ; $75B8
    ld hl, wPickMusic                             ; $75BA
    add hl, bc                                    ; $75BD
    inc c                                         ; $75BE
    ldh a, [hKeysNew]                             ; $75BF
    ld b, a                                       ; $75C1
    ld a, [hl]                                    ; $75C2
    bit 5, b                                      ; $75C3
    jr z, jr_005_75cc                             ; $75C5

    and a                                         ; $75C7
    ret z                                         ; $75C8

    dec a                                         ; $75C9
    jr jr_005_75d2                                ; $75CA

jr_005_75cc:
    bit 4, b                                      ; $75CC
    ret z                                         ; $75CE

    cp c                                          ; $75CF
    ret z                                         ; $75D0

    inc a                                         ; $75D1

jr_005_75d2:
    ld [hl], a                                    ; $75D2
    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $75D3
    ret                                           ; $75DA


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuDrawCursor::
    ld a, [wMenuRow]                              ; $75DB
    ld c, a                                       ; $75DE
    ld b, $00                                     ; $75DF
    ld hl, wPickMusic                             ; $75E1
    add hl, bc                                    ; $75E4
    ld a, [wMenuRow]                              ; $75E5
    ld c, a                                       ; $75E8
    sla a                                         ; $75E9
    add c                                         ; $75EB
    add [hl]                                      ; $75EC
    ld c, a                                       ; $75ED
    sla c                                         ; $75EE
    ld hl, Ball_MenuDrawCursor_Tbl7602            ; $75F0
    add hl, bc                                    ; $75F3
    ld c, [hl]                                    ; $75F4
    inc hl                                        ; $75F5
    ld b, [hl]                                    ; $75F6
    ldh a, [hFrameCounter]                        ; $75F7
    bit 3, a                                      ; $75F9
    ret z                                         ; $75FB

    ld a, $8e                                     ; $75FC
    call Oam_AddMeta_B02_52BD                     ; $75FE
    ret                                           ; $7601


; C: auto: 12 bytes, bytes; referenced by Ball_MenuDrawCursor. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuDrawCursor_Tbl7602::
    db $08, $60, $08, $70, $08, $80, $88, $60, $88, $70, $88, $80

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimate::
    call Ball_MenuAnimB                           ; $760E
    call Ball_MenuAnimC                           ; $7611
    ret                                           ; $7614


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB::
    ld a, [wMenuRow]                              ; $7615
    and a                                         ; $7618
    jr z, jr_005_7621                             ; $7619

    xor a                                         ; $761B
    ld [wMenuAnimBPhase], a                       ; $761C
    jr jr_005_763a                                ; $761F

jr_005_7621:
    ld a, [wMenuAnimBTick]                        ; $7621
    inc a                                         ; $7624
    cp $04                                        ; $7625
    jr c, jr_005_7636                             ; $7627

    ld a, [wMenuAnimBPhase]                       ; $7629
    inc a                                         ; $762C
    cp $04                                        ; $762D
    jr c, jr_005_7632                             ; $762F

    xor a                                         ; $7631

jr_005_7632:
    ld [wMenuAnimBPhase], a                       ; $7632
    xor a                                         ; $7635

jr_005_7636:
    inc a                                         ; $7636
    ld [wMenuAnimBTick], a                        ; $7637

jr_005_763a:
    ld a, [wPickMusic]                            ; $763A
    sla a                                         ; $763D
    ld c, a                                       ; $763F
    ld b, $00                                     ; $7640
    ld hl, Ball_MenuAnimB_Tbl7658                 ; $7642
    add hl, bc                                    ; $7645
    ld c, [hl]                                    ; $7646
    inc hl                                        ; $7647
    ld b, [hl]                                    ; $7648
    ld a, [wMenuAnimBPhase]                       ; $7649
    ld e, a                                       ; $764C
    ld d, $00                                     ; $764D
    ld hl, Ball_MenuAnimB_Tbl765E                 ; $764F
    add hl, de                                    ; $7652
    ld a, [hl]                                    ; $7653
    call Oam_AddMeta_B02_52BD                     ; $7654
    ret                                           ; $7657


; C: auto: 6 bytes, bytes; referenced by Ball_MenuAnimB. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB_Tbl7658::
    db $18, $60, $18, $70, $18, $80

; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimB. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB_Tbl765E::
    db $84, $85, $86, $85

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC::
    ld a, [wMenuRow]                              ; $7662
    and a                                         ; $7665
    jr nz, jr_005_766e                            ; $7666

    xor a                                         ; $7668
    ld [wMenuAnimCPhase], a                       ; $7669
    jr jr_005_7687                                ; $766C

jr_005_766e:
    ld a, [wMenuAnimCTick]                        ; $766E
    inc a                                         ; $7671
    cp $04                                        ; $7672
    jr c, jr_005_7683                             ; $7674

    ld a, [wMenuAnimCPhase]                       ; $7676
    inc a                                         ; $7679
    cp $04                                        ; $767A
    jr c, jr_005_767f                             ; $767C

    xor a                                         ; $767E

jr_005_767f:
    ld [wMenuAnimCPhase], a                       ; $767F
    xor a                                         ; $7682

jr_005_7683:
    inc a                                         ; $7683
    ld [wMenuAnimCTick], a                        ; $7684

jr_005_7687:
    ld a, [wPickCharacter]                        ; $7687
    sla a                                         ; $768A
    ld c, a                                       ; $768C
    ld b, $00                                     ; $768D
    ld hl, Ball_MenuAnimC_Tbl76A5                 ; $768F
    add hl, bc                                    ; $7692
    ld c, [hl]                                    ; $7693
    inc hl                                        ; $7694
    ld b, [hl]                                    ; $7695
    ld a, [wMenuAnimCPhase]                       ; $7696
    ld e, a                                       ; $7699
    ld d, $00                                     ; $769A
    ld hl, Ball_MenuAnimC_Tbl76AB                 ; $769C
    add hl, de                                    ; $769F
    ld a, [hl]                                    ; $76A0
    call Oam_AddMeta_B02_52BD                     ; $76A1
    ret                                           ; $76A4


; C: auto: 6 bytes, bytes; referenced by Ball_MenuAnimC. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC_Tbl76A5::
    db $80, $60, $80, $70, $80, $80

; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimC. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC_Tbl76AB::
    db $81, $82, $83, $82

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA::
    ld a, [wMenuAnimATick]                        ; $76AF
    inc a                                         ; $76B2
    cp $03                                        ; $76B3
    jr c, jr_005_76c4                             ; $76B5

    ld a, [wMenuAnimAPhase]                       ; $76B7
    inc a                                         ; $76BA
    cp $0c                                        ; $76BB
    jr c, jr_005_76c0                             ; $76BD

    xor a                                         ; $76BF

jr_005_76c0:
    ld [wMenuAnimAPhase], a                       ; $76C0
    xor a                                         ; $76C3

jr_005_76c4:
    inc a                                         ; $76C4
    ld [wMenuAnimATick], a                        ; $76C5
    ld a, [wMenuRow]                              ; $76C8
    sla a                                         ; $76CB
    ld c, a                                       ; $76CD
    ld b, $00                                     ; $76CE
    ld hl, Ball_MenuAnimA_Tbl76E6                 ; $76D0
    add hl, bc                                    ; $76D3
    ld c, [hl]                                    ; $76D4
    inc hl                                        ; $76D5
    ld b, [hl]                                    ; $76D6
    ld a, [wMenuAnimAPhase]                       ; $76D7
    ld e, a                                       ; $76DA
    ld d, $00                                     ; $76DB
    ld hl, Ball_MenuAnimA_Tbl76EA                 ; $76DD
    add hl, de                                    ; $76E0
    ld a, [hl]                                    ; $76E1
    call Oam_AddMeta_B02_52BD                     ; $76E2
    ret                                           ; $76E5


; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimA. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA_Tbl76E6::
    db $11, $30, $91, $30

; C: auto: 12 bytes, bytes; referenced by Ball_MenuAnimA. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA_Tbl76EA::
    db $87, $88, $89, $8a, $8b, $8c, $8d, $8c, $8b, $8a, $89, $88

; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawMenuBall::
    ld bc, $1870                                  ; $76F6
    add $7e                                       ; $76F9
    call Oam_AddMeta_B02_52BD                     ; $76FB
    ret                                           ; $76FE


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuBlinkSelection::
    ldh [hScratchA], a                            ; $76FF
    call Oam_HideUnused                           ; $7701
    rst Rst08_WaitVBlank                          ; $7704
    ld b, $03                                     ; $7705

jr_005_7707:
    ld d, $00                                     ; $7707
    ld c, $02                                     ; $7709

jr_005_770b:
    push bc                                       ; $770B
    ld a, b                                       ; $770C
    add $02                                       ; $770D

jr_005_770f:
    push af                                       ; $770F
    ld a, d                                       ; $7710
    call Ball_DrawMenuBall                        ; $7711
    call Oam_HideUnused                           ; $7714
    rst Rst08_WaitVBlank                          ; $7717
    pop af                                        ; $7718
    dec a                                         ; $7719
    jr nz, jr_005_770f                            ; $771A

    pop bc                                        ; $771C
    ldh a, [hScratchA]                            ; $771D
    ld d, a                                       ; $771F
    dec c                                         ; $7720
    jr nz, jr_005_770b                            ; $7721

    dec b                                         ; $7723
    jr nz, jr_005_7707                            ; $7724

    ret                                           ; $7726


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Ball_MenuLoadRow::
    ld a, [wMenuRow]                              ; $7727
    and a                                         ; $772A
    jr nz, jr_005_773c                            ; $772B

    farcopy Vram_CopyFromBank, Map_24_4480_Ball_MenuLoadRow_Part4500, $9880, $0100 ; $772D
    ret                                           ; $773B


jr_005_773c:
    farcopy Vram_CopyFromBank, Map_24_46C0_Ball_MenuLoadRow, $9880, $0100 ; $773C
    ret                                           ; $774A


; C
Mode20_State02_GameSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $774B
    ldh [hLcdcShadow], a                          ; $774D
    ld a, $e4                                     ; $774F
    ld [wPaletteTarget], a                        ; $7751
    ld [wPaletteTarget + $1], a                   ; $7754
    ld a, $d2                                     ; $7757
    ld [wPaletteTarget + $2], a                   ; $7759
    ld a, $00                                     ; $775C
    ldh [hScxShadow], a                           ; $775E
    ldh [hScxBand1], a                            ; $7760
    xor a                                         ; $7762
    ldh [hScyShadow], a                           ; $7763
    ldh [hScyBand1], a                            ; $7765
    ldh [hScxBand2], a                            ; $7767
    ld a, $98                                     ; $7769
    ldh [hScyBand2], a                            ; $776B
    ldh [hFarcallAArg], a                         ; $776D
    farcall Counters_Load_Far                     ; $776F
    farcopy Mem_CopyFromBank, Gfx_1D_5D00_Mode20_State02_GameSetup, $8000, $0d80 ; $7777
    farcopy Mem_CopyFromBank, Map_22_7740_Mode20_State02_GameSetup, $9800, $0400 ; $7785
    farcopy Mem_CopyFromBank, Map_22_5F40_Mode20_State02_GameSetup, $9c00, $0400 ; $7793
    ldh [hFarcallAArg], a                         ; $77A1
    farcall GameFace_LoadTiles_Far                ; $77A3
    call Ball_LoadCharacterGfx                    ; $77AB
    ld a, $27                                     ; $77AE
    ldh [hLycShadowSplit1], a                     ; $77B0
    ldh [hSplit1Latch], a                         ; $77B2
    ld hl, hStatShadow                            ; $77B4
    set 6, [hl]                                   ; $77B7
    ld hl, rIE                                    ; $77B9
    set 1, [hl]                                   ; $77BC
    ld a, $05                                     ; $77BE
    ldh [hStatHandlerIndex], a                    ; $77C0
    screen_on                                     ; $77C2
    call Ball_DrawHud                             ; $77CB
    next_state                                    ; $77CE
    ret                                           ; $77D2


; C
Mode20_State03_GameStart::
    ld a, [wPickMusic]                            ; $77D3
    ld hl, Mode20_State03_GameStart_Tbl77F2       ; $77D6
    call Snd_PlayFromList                         ; $77D9
    call Ball_DrawHud                             ; $77DC
    call Ball_ResetGame                           ; $77DF
    call Ball_DrawScore                           ; $77E2
    ld c, $00                                     ; $77E5
    call Ball_LoadGfx8D80                         ; $77E7
    call Pal_FadeIn                               ; $77EA
    next_state                                    ; $77ED
    ret                                           ; $77F1


; C: auto: 4 bytes, bytes; referenced by Mode20_State03_GameStart, Mode20_State07_Pause. L3 pass 2026-10-26: read in
; BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Mode20_State03_GameStart_Tbl77F2::
    db MUSIC_BALL_BGM_1, SNDCH_MUSIC  ; #1
    db MUSIC_BALL_BGM_2, SNDCH_MUSIC  ; #2

; C
Mode20_State04_Play::
    call Ball_DrawHud                             ; $77F6
    call Ball_StepObjects                         ; $77F9
    call Ball_PlayerInput                         ; $77FC
    call Ball_Animate                             ; $77FF
    call Ball_DrawPlayer                          ; $7802
    call Ball_ScrollBg                            ; $7805
    call Ball_PoseScroll                          ; $7808
    call Ball_DrawObjects                         ; $780B
    call Ball_Collide                             ; $780E
    ldh a, [hKeysNew]                             ; $7811
    bit PADB_START, a                             ; $7813
    ret z                                         ; $7815

    play_sfx1 SFX1_KEY_START                      ; $7816
    ld bc, $000a                                  ; $781D
    call Wait_Frames                              ; $7820
    play_music MUSIC_STOP                         ; $7823
    set_state STATE_20_PAUSE                      ; $782A
    ret                                           ; $782F


; C: input from the demo / autopilot (7DCC)
Mode20_State05_PlayDemo::
    ldh a, [hKeysNew]                             ; $7830
    push af                                       ; $7832
    call Ball_DemoInput                           ; $7833
    call Ball_DrawHud                             ; $7836
    call Ball_StepObjects                         ; $7839
    call Ball_PlayerInput                         ; $783C
    call Ball_Animate                             ; $783F
    call Ball_DrawPlayer                          ; $7842
    call Ball_ScrollBg                            ; $7845
    call Ball_PoseScroll                          ; $7848
    call Ball_DrawObjects                         ; $784B
    call Ball_Collide                             ; $784E
    pop af                                        ; $7851
    bit 1, a                                      ; $7852
    jr z, jr_005_7863                             ; $7854

    play_sfx1 SFX1_KEY_B                          ; $7856
    set_state STATE_20_LEAVE                      ; $785D
    ret                                           ; $7862


jr_005_7863:
    and a                                         ; $7863
    ret z                                         ; $7864

    set_state STATE_20_GAME_START                 ; $7865
    call Pal_FadeOut                              ; $786A
    ret                                           ; $786D


; C
Mode20_State06_GameOver::
    call Ball_DrawHud                             ; $786E
    call Ball_DrawPlayer                          ; $7871
    call Ball_DrawObjects                         ; $7874
    ld a, [wBallGameoverBlink]                    ; $7877
    dec a                                         ; $787A
    call z, Ball_FlipPalettes                     ; $787B
    jr nz, jr_005_788f                            ; $787E

    play_music MUSIC_BALL_GAME_OVER               ; $7880
    push af                                       ; $7887
    rst Rst08_WaitVBlank                          ; $7888
    ld c, $03                                     ; $7889
    call Ball_LoadGfx8D80                         ; $788B
    pop af                                        ; $788E

jr_005_788f:
    bit 7, a                                      ; $788F
    jr nz, jr_005_7896                            ; $7891

    ld [wBallGameoverBlink], a                    ; $7893

jr_005_7896:
    ld a, [wBallGameoverTimeout]                  ; $7896
    dec a                                         ; $7899
    jr nz, jr_005_78b7                            ; $789A

    ldh a, [hKeysNew]                             ; $789C
    and a                                         ; $789E
    jr z, jr_005_78ba                             ; $789F

    screen_off                                    ; $78A1
    stat_irq_off                                  ; $78A7
    set_state STATE_20_RESULT_INIT                ; $78B1
    ret                                           ; $78B6


jr_005_78b7:
    ld [wBallGameoverTimeout], a                  ; $78B7

jr_005_78ba:
    ldh a, [hFrameCounter]                        ; $78BA
    and a                                         ; $78BC
    ret nz                                        ; $78BD

    ld hl, wBallGameoverDelay                     ; $78BE
    dec [hl]                                      ; $78C1
    ret nz                                        ; $78C2

    ld c, $00                                     ; $78C3
    call Ball_LoadGfx8D80                         ; $78C5
    set_state STATE_20_PLAY_DEMO                  ; $78C8
    call Ball_FlipPalettes                        ; $78CD
    call Ball_DrawHud                             ; $78D0
    call Ball_ResetGame                           ; $78D3
    call Ball_DrawScore                           ; $78D6
    ret                                           ; $78D9


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Mode20_State07_Pause::
    call Ball_DrawHud                             ; $78DA
    call Ball_DrawPlayer                          ; $78DD
    call Ball_DrawPauseText                       ; $78E0
    ldh a, [hKeysNew]                             ; $78E3
    bit PADB_A, a                                 ; $78E5
    jr nz, jr_005_78ed                            ; $78E7

    bit PADB_START, a                             ; $78E9
    jr z, jr_005_7909                             ; $78EB

jr_005_78ed:
    play_sfx1 SFX1_KEY_START                      ; $78ED
    ld bc, $000a                                  ; $78F4
    call Wait_Frames                              ; $78F7
    ld a, [wPickMusic]                            ; $78FA
    ld hl, Mode20_State03_GameStart_Tbl77F2       ; $78FD
    call Snd_PlayFromList                         ; $7900
    set_state STATE_20_PLAY                       ; $7903
    ret                                           ; $7908


jr_005_7909:
    bit 1, a                                      ; $7909
    ret z                                         ; $790B

    play_sfx1 SFX1_KEY_B                          ; $790C
    set_state STATE_20_LEAVE                      ; $7913
    ret                                           ; $7918


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawPauseText::
    ld bc, $5048                                  ; $7919
    ld a, $b7                                     ; $791C
    call Oam_AddMeta_B01_5D2B                     ; $791E
    ret                                           ; $7921


; C
Mode20_State08_Leave::
    call Ball_DrawHud                             ; $7922
    screen_off                                    ; $7925
    stat_irq_off                                  ; $792B
    ld a, [wMode20Caller]                         ; $7935
    cp MODE_SHUTTERBUG_MAGIC                      ; $7938
    jr nz, jr_005_7945                            ; $793A

    ld [wMode], a                                 ; $793C
    set_state STATE_20_MENU                       ; $793F
    ret                                           ; $7944


jr_005_7945:
    set_state STATE_20_MENU_INIT                  ; $7945
    ret                                           ; $794A


; C
Mode20_State09_ResultInit::
    ld a, LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $794B
    ldh [hLcdcShadow], a                          ; $794D
    ld a, $e4                                     ; $794F
    ld [wPaletteTarget], a                        ; $7951
    ld [wPaletteTarget + $1], a                   ; $7954
    ld a, $d2                                     ; $7957
    ld [wPaletteTarget + $2], a                   ; $7959
    xor a                                         ; $795C
    ldh [hScxShadow], a                           ; $795D
    ldh [hScyShadow], a                           ; $795F
    farcopy Mem_CopyFromBank, Gfx_1B_5100_Mode20_State09_ResultInit, $8000, $1000 ; $7961
    farcopy Mem_CopyFromBank, Map_23_4CC0_Mode20_State09_ResultInit, $9800, $0400 ; $796F
    screen_on                                     ; $797D
    call Pal_FadeIn                               ; $7986
    next_state                                    ; $7989
    ret                                           ; $798D


; C
Mode20_State0A_ResultKeys::
    ldh a, [hKeysNew]                             ; $798E
    and PADF_A | PADF_B                           ; $7990
    ret z                                         ; $7992

    ld [wAbResult], a                             ; $7993
    bit 0, a                                      ; $7996
    jr z, jr_005_79a6                             ; $7998

    play_sfx1 SFX1_KEY_A                          ; $799A
    next_state                                    ; $79A1
    ret                                           ; $79A5


jr_005_79a6:
    play_sfx1 SFX1_KEY_B                          ; $79A6
    next_state                                    ; $79AD
    ret                                           ; $79B1


; C
Mode20_State0B_ResultLeave::
    screen_off                                    ; $79B2
    ld a, [wAbResult]                             ; $79B8
    bit 0, a                                      ; $79BB
    jr z, jr_005_79c5                             ; $79BD

    set_state STATE_20_GAME_SETUP                 ; $79BF
    ret                                           ; $79C4


jr_005_79c5:
    ld a, [wMode20Caller]                         ; $79C5
    cp MODE_SHUTTERBUG_MAGIC                      ; $79C8
    jr nz, jr_005_79d6                            ; $79CA

    ld [wMode], a                                 ; $79CC
    set_state STATE_20_MENU                       ; $79CF
    jr jr_005_79db                                ; $79D4

jr_005_79d6:
    set_state STATE_20_MENU_INIT                  ; $79D6

jr_005_79db:
    ret                                           ; $79DB


; C: score; positions; directions; speed
Ball_ResetGame::
    ld a, $ff                                     ; $79DC
    ld [wBallDir + $1], a                         ; $79DE
    inc a                                         ; $79E1
    ld [wBallPose], a                             ; $79E2
    ld [wBallPos], a                              ; $79E5
    ld [wBallPos + $2], a                         ; $79E8
    ld [wBallSpeedAcc], a                         ; $79EB
    ld [wBallSpeedAcc + $1], a                    ; $79EE
    ld [wBallNextIndex], a                        ; $79F1
    ld [wBallScoreBcd], a                         ; $79F4
    ld [wBallScoreBcd + $1], a                    ; $79F7
    ld [wBallBlinkCounter], a                     ; $79FA
    inc a                                         ; $79FD
    ld [wBallDir], a                              ; $79FE
    ld [wBallDir + $2], a                         ; $7A01
    ld [wBallBlinkPhase], a                       ; $7A04
    ld [wBallPlayerPos], a                        ; $7A07
    ld a, $09                                     ; $7A0A
    ld [wBallPos + $1], a                         ; $7A0C
    ret                                           ; $7A0F


; C
Ball_PlayerInput::
    ld a, [wBallPlayerPos]                        ; $7A10
    ld hl, hKeysNew                               ; $7A13
    bit 5, [hl]                                   ; $7A16
    jr nz, jr_005_7a1e                            ; $7A18

    bit 1, [hl]                                   ; $7A1A
    jr z, jr_005_7a2a                             ; $7A1C

jr_005_7a1e:
    and a                                         ; $7A1E
    ret z                                         ; $7A1F

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7A20
    dec a                                         ; $7A27
    jr jr_005_7a3c                                ; $7A28

jr_005_7a2a:
    bit 4, [hl]                                   ; $7A2A
    jr nz, jr_005_7a31                            ; $7A2C

    bit 0, [hl]                                   ; $7A2E
    ret z                                         ; $7A30

jr_005_7a31:
    cp $02                                        ; $7A31
    ret z                                         ; $7A33

    play_sfx1 SFX1_KEY_LEFT_RIGHT                 ; $7A34
    inc a                                         ; $7A3B

jr_005_7a3c:
    ld [wBallPlayerPos], a                        ; $7A3C
    ret                                           ; $7A3F


; C
Ball_DrawPlayer::
    ld a, [wBallPlayerPos]                        ; $7A40
    sla a                                         ; $7A43
    sla a                                         ; $7A45
    ld c, a                                       ; $7A47
    ld b, $00                                     ; $7A48
    ld hl, Ball_DrawPlayer_Tbl7A61                ; $7A4A
    add hl, bc                                    ; $7A4D
    ld b, [hl]                                    ; $7A4E
    inc hl                                        ; $7A4F
    ld c, $70                                     ; $7A50
    ld a, [hl+]                                   ; $7A52
    push hl                                       ; $7A53
    call Oam_AddMeta_B01_5D2B                     ; $7A54
    pop hl                                        ; $7A57
    ld b, [hl]                                    ; $7A58
    inc hl                                        ; $7A59
    ld c, $70                                     ; $7A5A
    ld a, [hl]                                    ; $7A5C
    call Oam_AddMeta_B01_5D2B                     ; $7A5D
    ret                                           ; $7A60


; C: auto: 12 bytes, bytes; referenced by Ball_DrawPlayer. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawPlayer_Tbl7A61::
    db $20, $b5, $70, $b4, $28, $b1, $78, $b2, $30, $b3, $80, $b6

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_ScrollBg::
    ld a, [wBallPlayerPos]                        ; $7A6D
    sla a                                         ; $7A70
    ld c, a                                       ; $7A72
    ld b, $00                                     ; $7A73
    ld hl, Ball_ScrollBg_Tbl7A80                  ; $7A75
    add hl, bc                                    ; $7A78
    ld a, [hl+]                                   ; $7A79
    ldh [hScyBand2], a                            ; $7A7A
    ld a, [hl]                                    ; $7A7C
    ldh [hScxBand2], a                            ; $7A7D
    ret                                           ; $7A7F


; C: auto: 6 bytes, bytes; referenced by Ball_ScrollBg. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_ScrollBg_Tbl7A80::
    db $e8, $08, $98, $00, $c0, $f8

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll::
    ld a, [wBallPlayerPos]                        ; $7A86
    ld c, a                                       ; $7A89
    ld b, $00                                     ; $7A8A
    ld hl, Ball_PoseScroll_Tbl7AA1                ; $7A8C
    add hl, bc                                    ; $7A8F
    ld a, [hl]                                    ; $7A90
    ldh [hScxBand1], a                            ; $7A91
    ld a, [wBallPose]                             ; $7A93
    ld c, a                                       ; $7A96
    ld b, $00                                     ; $7A97
    ld hl, Ball_PoseScroll_Tbl7AA4                ; $7A99
    add hl, bc                                    ; $7A9C
    ld a, [hl]                                    ; $7A9D
    ldh [hScyBand1], a                            ; $7A9E
    ret                                           ; $7AA0


; C: auto: 3 bytes, bytes; referenced by Ball_PoseScroll. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll_Tbl7AA1::
    db $08, $00, $f8

; C: auto: 3 bytes, bytes; referenced by Ball_PoseScroll. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll_Tbl7AA4::
    db $00, $48, $90

; C: speed table 05:7B6D; objects 0..2; bounce / miss; end of game
Ball_StepObjects::
    xor a                                         ; $7AA7
    ld [wBallStepFlag], a                         ; $7AA8
    ld c, $28                                     ; $7AAB
    ld a, [wBallScoreBcd + $1]                    ; $7AAD
    cp $04                                        ; $7AB0
    jr nc, jr_005_7abd                            ; $7AB2

    sla a                                         ; $7AB4
    ld c, a                                       ; $7AB6
    sla a                                         ; $7AB7
    sla a                                         ; $7AB9
    add c                                         ; $7ABB
    ld c, a                                       ; $7ABC

jr_005_7abd:
    ld a, [wBallScoreBcd]                         ; $7ABD
    and $f0                                       ; $7AC0
    swap a                                        ; $7AC2
    add c                                         ; $7AC4
    ld c, a                                       ; $7AC5
    and a                                         ; $7AC6
    jr nz, jr_005_7ad5                            ; $7AC7

    ld a, [wBallScoreBcd]                         ; $7AC9
    cp $05                                        ; $7ACC
    jr nc, jr_005_7ad5                            ; $7ACE

    ld hl, Ball_StepObjects_Tbl7B55               ; $7AD0
    jr jr_005_7adf                                ; $7AD3

jr_005_7ad5:
    ld b, $00                                     ; $7AD5
    sla c                                         ; $7AD7
    rl b                                          ; $7AD9
    ld hl, Ball_StepObjects_Tbl7B57               ; $7ADB
    add hl, bc                                    ; $7ADE

jr_005_7adf:
    ld a, [wBallSpeedAcc]                         ; $7ADF
    add [hl]                                      ; $7AE2
    ld [wBallSpeedAcc], a                         ; $7AE3
    inc hl                                        ; $7AE6
    ld a, [wBallSpeedAcc + $1]                    ; $7AE7
    adc [hl]                                      ; $7AEA
    ld [wBallSpeedAcc + $1], a                    ; $7AEB
    ret nc                                        ; $7AEE

    ld a, $01                                     ; $7AEF
    ld [wBallStepFlag], a                         ; $7AF1
    ld a, [wBallNextIndex]                        ; $7AF4
    add $20                                       ; $7AF7
    call Snd_Sfx1                                 ; $7AF9
    ld a, [wBallNextIndex]                        ; $7AFC
    ld c, a                                       ; $7AFF
    ld b, $00                                     ; $7B00
    ld hl, wBallPos                               ; $7B02
    add hl, bc                                    ; $7B05
    ld a, [hl]                                    ; $7B06
    bit 7, a                                      ; $7B07
    ret nz                                        ; $7B09

    ld hl, Ball_StepObjects_Tbl7BBB               ; $7B0A
    add hl, bc                                    ; $7B0D
    cp [hl]                                       ; $7B0E
    ret z                                         ; $7B0F

    ld hl, wBallDir                               ; $7B10
    add hl, bc                                    ; $7B13
    add [hl]                                      ; $7B14
    ld hl, wBallPos                               ; $7B15
    add hl, bc                                    ; $7B18
    ld [hl], a                                    ; $7B19
    bit 7, a                                      ; $7B1A
    jr nz, jr_005_7b32                            ; $7B1C

    ld hl, Ball_StepObjects_Tbl7BBB               ; $7B1E
    add hl, bc                                    ; $7B21
    cp [hl]                                       ; $7B22
    jr z, jr_005_7b32                             ; $7B23

    ld a, [wBallNextIndex]                        ; $7B25
    inc a                                         ; $7B28
    cp $03                                        ; $7B29
    jr nz, jr_005_7b2e                            ; $7B2B

    xor a                                         ; $7B2D

jr_005_7b2e:
    ld [wBallNextIndex], a                        ; $7B2E
    ret                                           ; $7B31


jr_005_7b32:
    set_state STATE_20_GAME_OVER                  ; $7B32
    call Ball_StoreBest                           ; $7B37
    ld a, $06                                     ; $7B3A
    ld [wBallGameoverBlink], a                    ; $7B3C
    ld a, $08                                     ; $7B3F
    ld [wBallGameoverDelay], a                    ; $7B41
    ld a, $78                                     ; $7B44
    ld [wBallGameoverTimeout], a                  ; $7B46
    xor a                                         ; $7B49
    ld [wBallPose], a                             ; $7B4A
    xor a                                         ; $7B4D
    ld [wBallStepFlag], a                         ; $7B4E
    ld [wBallAnimTick], a                         ; $7B51
    ret                                           ; $7B54


; C: auto: 2 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_StepObjects_Tbl7B55::
    dw $0c30

; C: auto: 100 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F 20)
Ball_StepObjects_Tbl7B57::
    db $38, $0e, $65, $13, $51, $14, $55, $15, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $51, $14, $55, $15, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $68, $2f, $55, $35
    db $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $68, $2f, $55, $35, $55, $35, $55, $35
    db $55, $35, $55, $35

; C: auto: 3 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_StepObjects_Tbl7BBB::
    db $08, $0a, $0c

; C
Ball_DrawObjects::
    ld a, [wBallPos]                              ; $7BBE
    ld hl, Ball_DrawObjects_Tbl7C0B               ; $7BC1
    call Ball_DrawObject                          ; $7BC4
    ld a, [wBallPos + $1]                         ; $7BC7
    ld hl, Ball_DrawObjects_Tbl7C1F               ; $7BCA
    call Ball_DrawObject                          ; $7BCD
    ld a, [wBallPos + $2]                         ; $7BD0
    ld hl, Ball_DrawObjects_Tbl7C37               ; $7BD3
    call Ball_DrawObject                          ; $7BD6
    ret                                           ; $7BD9


; C
Ball_DrawObject::
    inc a                                         ; $7BDA
    sla a                                         ; $7BDB
    ld c, a                                       ; $7BDD
    ld b, $00                                     ; $7BDE
    add hl, bc                                    ; $7BE0
    ld c, [hl]                                    ; $7BE1
    inc hl                                        ; $7BE2
    ld b, [hl]                                    ; $7BE3
    ld a, $b0                                     ; $7BE4
    bit 7, c                                      ; $7BE6
    jr nz, jr_005_7bee                            ; $7BE8

    call Oam_AddMeta_B01_5D2B                     ; $7BEA
    ret                                           ; $7BED


jr_005_7bee:
    ld a, [wBallBlinkPhase]                       ; $7BEE
    ld a, $bc                                     ; $7BF1
    call Oam_AddMeta_B01_5D2B                     ; $7BF3
    ld a, [wBallBlinkCounter]                     ; $7BF6
    cp $12                                        ; $7BF9
    jr nz, jr_005_7c06                            ; $7BFB

    ld a, [wBallBlinkPhase]                       ; $7BFD
    xor $01                                       ; $7C00
    ld [wBallBlinkPhase], a                       ; $7C02
    xor a                                         ; $7C05

jr_005_7c06:
    inc a                                         ; $7C06
    ld [wBallBlinkCounter], a                     ; $7C07
    ret                                           ; $7C0A


; C: auto: 20 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C0B::
    db $88, $17, $63, $28, $4a, $2b, $32, $33, $20, $44, $20, $5c, $32, $6d, $4a, $75
    db $63, $78, $88, $7e

; C: auto: 24 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C1F::
    db $88, $17, $63, $18, $4a, $1b, $32, $22, $1d, $2f, $12, $44, $12, $5c, $1d, $71
    db $32, $7e, $4a, $85, $63, $88, $88, $7e

; C: auto: 28 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C37::
    db $88, $17, $63, $08, $48, $0b, $30, $12, $1a, $1d, $09, $2d, $05, $44, $05, $5c
    db $09, $73, $1a, $83, $30, $8e, $48, $95, $63, $98, $88, $7e

; C
Ball_Collide::
    xor a                                         ; $7C53
    ld [wBallBounceFlag], a                       ; $7C54
    ld a, [wBallPlayerPos]                        ; $7C57
    and a                                         ; $7C5A
    jr nz, jr_005_7c8b                            ; $7C5B

    ld a, [wBallPos]                              ; $7C5D
    cp $07                                        ; $7C60
    jr nz, jr_005_7c75                            ; $7C62

    ld hl, wBallDir                               ; $7C64
    ld a, $ff                                     ; $7C67
    cp [hl]                                       ; $7C69
    jr z, jr_005_7c75                             ; $7C6A

    ld [hl], a                                    ; $7C6C
    call Ball_AddPoint                            ; $7C6D
    ld a, $01                                     ; $7C70
    ld [wBallBounceFlag], a                       ; $7C72

jr_005_7c75:
    ld a, [wBallPos + $2]                         ; $7C75
    and a                                         ; $7C78
    ret nz                                        ; $7C79

    ld hl, wBallDir + $2                          ; $7C7A
    ld a, $01                                     ; $7C7D
    cp [hl]                                       ; $7C7F
    ret z                                         ; $7C80

    ld [hl], a                                    ; $7C81
    call Ball_AddPoint                            ; $7C82
    ld a, $01                                     ; $7C85
    ld [wBallBounceFlag], a                       ; $7C87
    ret                                           ; $7C8A


jr_005_7c8b:
    dec a                                         ; $7C8B
    jr nz, jr_005_7cbc                            ; $7C8C

    ld a, [wBallPos + $1]                         ; $7C8E
    cp $09                                        ; $7C91
    jr nz, jr_005_7ca6                            ; $7C93

    ld hl, wBallDir + $1                          ; $7C95
    ld a, $ff                                     ; $7C98
    cp [hl]                                       ; $7C9A
    jr z, jr_005_7ca6                             ; $7C9B

    ld [hl], a                                    ; $7C9D
    call Ball_AddPoint                            ; $7C9E
    ld a, $01                                     ; $7CA1
    ld [wBallBounceFlag], a                       ; $7CA3

jr_005_7ca6:
    ld a, [wBallPos + $1]                         ; $7CA6
    and a                                         ; $7CA9
    ret nz                                        ; $7CAA

    ld hl, wBallDir + $1                          ; $7CAB
    ld a, $01                                     ; $7CAE
    cp [hl]                                       ; $7CB0
    ret z                                         ; $7CB1

    ld [hl], a                                    ; $7CB2
    call Ball_AddPoint                            ; $7CB3
    ld a, $01                                     ; $7CB6
    ld [wBallBounceFlag], a                       ; $7CB8
    ret                                           ; $7CBB


jr_005_7cbc:
    dec a                                         ; $7CBC
    ret nz                                        ; $7CBD

    ld a, [wBallPos + $2]                         ; $7CBE
    cp $0b                                        ; $7CC1
    jr nz, jr_005_7cd6                            ; $7CC3

    ld hl, wBallDir + $2                          ; $7CC5
    ld a, $ff                                     ; $7CC8
    cp [hl]                                       ; $7CCA
    jr z, jr_005_7cd6                             ; $7CCB

    ld [hl], a                                    ; $7CCD
    call Ball_AddPoint                            ; $7CCE
    ld a, $01                                     ; $7CD1
    ld [wBallBounceFlag], a                       ; $7CD3

jr_005_7cd6:
    ld a, [wBallPos]                              ; $7CD6
    and a                                         ; $7CD9
    ret nz                                        ; $7CDA

    ld hl, wBallDir                               ; $7CDB
    ld a, $01                                     ; $7CDE
    cp [hl]                                       ; $7CE0
    ret z                                         ; $7CE1

    ld [hl], a                                    ; $7CE2
    call Ball_AddPoint                            ; $7CE3
    ld a, $01                                     ; $7CE6
    ld [wBallBounceFlag], a                       ; $7CE8
    ret                                           ; $7CEB


; C
Ball_Animate::
    ld a, [wBallAnimTick]                         ; $7CEC
    ld hl, wBallStepFlag                          ; $7CEF
    add [hl]                                      ; $7CF2
    ld [wBallAnimTick], a                         ; $7CF3
    ld a, [wBallIdleFrames]                       ; $7CF6
    cp $ff                                        ; $7CF9
    jr z, jr_005_7d01                             ; $7CFB

    inc a                                         ; $7CFD
    ld [wBallIdleFrames], a                       ; $7CFE

jr_005_7d01:
    cp $46                                        ; $7D01
    jr c, jr_005_7d0f                             ; $7D03

    ld a, [wBallAnimTick]                         ; $7D05
    srl a                                         ; $7D08
    and $01                                       ; $7D0A
    ld [wBallPose], a                             ; $7D0C

jr_005_7d0f:
    ldh a, [hKeysNew]                             ; $7D0F
    and a                                         ; $7D11
    ret z                                         ; $7D12

    ld a, [wBallIdleFrames]                       ; $7D13
    push af                                       ; $7D16
    xor a                                         ; $7D17
    ld [wBallIdleFrames], a                       ; $7D18
    pop af                                        ; $7D1B
    cp $0a                                        ; $7D1C
    jr nc, jr_005_7d26                            ; $7D1E

    ld a, $02                                     ; $7D20
    ld [wBallPose], a                             ; $7D22
    ret                                           ; $7D25


jr_005_7d26:
    cp $3c                                        ; $7D26
    ret nc                                        ; $7D28

    ld a, [wBallAnimTick]                         ; $7D29
    srl a                                         ; $7D2C
    and $01                                       ; $7D2E
    inc a                                         ; $7D30
    ld [wBallPose], a                             ; $7D31
    ret                                           ; $7D34


; C: sound $23 and +1 on the BCD score (saturating at 9999)
Ball_AddPoint::
    play_sfx1 SFX1_BALL_POINT                     ; $7D35
    ld a, $01                                     ; $7D3C
    ld hl, wBallScoreBcd                          ; $7D3E
    ld b, $02                                     ; $7D41
    call Bcd_AddSaturate                          ; $7D43

; C
Ball_DrawScore::
    ld de, wBallScoreBcd + $1                     ; $7D46
    ld hl, $9830                                  ; $7D49
    ld bc, $020a                                  ; $7D4C
    jr jr_005_7d6f                                ; $7D4F

jr_005_7d51:
    ld a, [de]                                    ; $7D51
    swap a                                        ; $7D52
    and $0f                                       ; $7D54
    jr nz, jr_005_7d5b                            ; $7D56

    ld a, c                                       ; $7D58
    jr jr_005_7d5d                                ; $7D59

jr_005_7d5b:
    ld c, $00                                     ; $7D5B

jr_005_7d5d:
    add $80                                       ; $7D5D
    call Vram_WriteByteSafe                       ; $7D5F
    res 5, l                                      ; $7D62
    set 6, l                                      ; $7D64
    add $10                                       ; $7D66
    call Vram_WriteByteSafe                       ; $7D68
    set 5, l                                      ; $7D6B
    res 6, l                                      ; $7D6D

jr_005_7d6f:
    inc hl                                        ; $7D6F
    ld a, b                                       ; $7D70
    cp $01                                        ; $7D71
    jr nz, jr_005_7d77                            ; $7D73

    ld c, $00                                     ; $7D75

jr_005_7d77:
    ld a, [de]                                    ; $7D77
    and $0f                                       ; $7D78
    jr nz, jr_005_7d7f                            ; $7D7A

    ld a, c                                       ; $7D7C
    jr jr_005_7d81                                ; $7D7D

jr_005_7d7f:
    ld c, $00                                     ; $7D7F

jr_005_7d81:
    add $80                                       ; $7D81
    call Vram_WriteByteSafe                       ; $7D83
    res 5, l                                      ; $7D86
    set 6, l                                      ; $7D88
    add $10                                       ; $7D8A
    call Vram_WriteByteSafe                       ; $7D8C
    set 5, l                                      ; $7D8F
    res 6, l                                      ; $7D91
    inc hl                                        ; $7D93
    dec de                                        ; $7D94
    dec b                                         ; $7D95
    jr nz, jr_005_7d51                            ; $7D96

    ret                                           ; $7D98


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawHud::
    ld bc, $8808                                  ; $7D99
    ld a, $b8                                     ; $7D9C
    call Oam_AddMeta_B01_5D2B                     ; $7D9E
    ret                                           ; $7DA1


; C: game-over blink. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 20
; (tcrf_check/assets/l3_names/)
Ball_FlipPalettes::
    push af                                       ; $7DA2
    ldh a, [hBgpShadow]                           ; $7DA3
    cpl                                           ; $7DA5
    ldh [hBgpShadow], a                           ; $7DA6
    ldh a, [hObp0Shadow]                          ; $7DA8
    cpl                                           ; $7DAA
    ldh [hObp0Shadow], a                          ; $7DAB
    ldh a, [hObp1Shadow]                          ; $7DAD
    cpl                                           ; $7DAF
    ldh [hObp1Shadow], a                          ; $7DB0
    pop af                                        ; $7DB2
    ret                                           ; $7DB3


; C: autopilot
Ball_DemoInput::
    xor a                                         ; $7DB4
    ldh [hKeysNew], a                             ; $7DB5
    ld a, [wDemoInputHoldoff]                     ; $7DB7
    and a                                         ; $7DBA
    jr z, jr_005_7dc2                             ; $7DBB

    dec a                                         ; $7DBD
    ld [wDemoInputHoldoff], a                     ; $7DBE
    ret                                           ; $7DC1


jr_005_7dc2:
    ldh a, [hFrameCounter]                        ; $7DC2
    and $01                                       ; $7DC4
    ret nz                                        ; $7DC6

    ld a, [wBallNextIndex]                        ; $7DC7
    and a                                         ; $7DCA
    jr z, jr_005_7dd2                             ; $7DCB

    dec a                                         ; $7DCD
    jr z, jr_005_7e00                             ; $7DCE

    jr jr_005_7e3e                                ; $7DD0

jr_005_7dd2:
    ld a, [wBallPos]                              ; $7DD2
    cp $01                                        ; $7DD5
    jr nz, jr_005_7dec                            ; $7DD7

    ld a, [wBallDir]                              ; $7DD9
    cp $ff                                        ; $7DDC
    ret nz                                        ; $7DDE

    ld a, [wBallPlayerPos]                        ; $7DDF
    cp $02                                        ; $7DE2
    jp z, Ball_DemoInput_SetHoldoff               ; $7DE4

    ld a, PADF_RIGHT                              ; $7DE7
    ldh [hKeysNew], a                             ; $7DE9
    ret                                           ; $7DEB


jr_005_7dec:
    cp $06                                        ; $7DEC
    ret nz                                        ; $7DEE

    ld a, [wBallDir]                              ; $7DEF
    cp $01                                        ; $7DF2
    ret nz                                        ; $7DF4

    ld a, [wBallPlayerPos]                        ; $7DF5
    and a                                         ; $7DF8
    jr z, Ball_DemoInput_SetHoldoff               ; $7DF9

    ld a, PADF_LEFT                               ; $7DFB
    ldh [hKeysNew], a                             ; $7DFD
    ret                                           ; $7DFF


jr_005_7e00:
    ld a, [wBallPos + $1]                         ; $7E00
    cp $01                                        ; $7E03
    jr nz, jr_005_7e21                            ; $7E05

    ld a, [wBallDir + $1]                         ; $7E07
    cp $ff                                        ; $7E0A
    ret nz                                        ; $7E0C

    ld a, [wBallPlayerPos]                        ; $7E0D
    and a                                         ; $7E10
    jr nz, jr_005_7e18                            ; $7E11

    ld a, PADF_RIGHT                              ; $7E13
    ldh [hKeysNew], a                             ; $7E15
    ret                                           ; $7E17


jr_005_7e18:
    cp $02                                        ; $7E18
    jr nz, Ball_DemoInput_SetHoldoff              ; $7E1A

    ld a, PADF_LEFT                               ; $7E1C
    ldh [hKeysNew], a                             ; $7E1E
    ret                                           ; $7E20


jr_005_7e21:
    cp $08                                        ; $7E21
    ret nz                                        ; $7E23

    ld a, [wBallDir + $1]                         ; $7E24
    cp $01                                        ; $7E27
    ret nz                                        ; $7E29

    ld a, [wBallPlayerPos]                        ; $7E2A
    and a                                         ; $7E2D
    jr nz, jr_005_7e35                            ; $7E2E

    ld a, PADF_RIGHT                              ; $7E30
    ldh [hKeysNew], a                             ; $7E32
    ret                                           ; $7E34


jr_005_7e35:
    cp $02                                        ; $7E35
    jr nz, Ball_DemoInput_SetHoldoff              ; $7E37

    ld a, PADF_LEFT                               ; $7E39
    ldh [hKeysNew], a                             ; $7E3B
    ret                                           ; $7E3D


jr_005_7e3e:
    ld a, [wBallPos + $2]                         ; $7E3E
    cp $01                                        ; $7E41
    jr nz, jr_005_7e56                            ; $7E43

    ld a, [wBallDir + $2]                         ; $7E45
    cp $ff                                        ; $7E48
    ret nz                                        ; $7E4A

    ld a, [wBallPlayerPos]                        ; $7E4B
    and a                                         ; $7E4E
    jr z, Ball_DemoInput_SetHoldoff               ; $7E4F

    ld a, PADF_LEFT                               ; $7E51
    ldh [hKeysNew], a                             ; $7E53
    ret                                           ; $7E55


jr_005_7e56:
    cp $0a                                        ; $7E56
    ret nz                                        ; $7E58

    ld a, [wBallDir + $2]                         ; $7E59
    cp $01                                        ; $7E5C
    ret nz                                        ; $7E5E

    ld a, [wBallPlayerPos]                        ; $7E5F
    cp $02                                        ; $7E62
    jr z, Ball_DemoInput_SetHoldoff               ; $7E64

    ld a, PADF_RIGHT                              ; $7E66
    ldh [hKeysNew], a                             ; $7E68
    ret                                           ; $7E6A


; C: sets wDemoInputHoldoff ($D9EA) = 1 and returns: the autopilot waits one more frame; shared by the cases where
; $D9D7 (ball player position) fits no move (branch target; code read 2026-10-19)
Ball_DemoInput_SetHoldoff::
    ld a, $01                                     ; $7E6B
    ld [wDemoInputHoldoff], a                     ; $7E6D
    ret                                           ; $7E70


; C: best score compare and far store
Ball_StoreBest::
    ld de, wBallScoreBcd + $1                     ; $7E71
    ld hl, wBestBall + $1                         ; $7E74
    ld b, $02                                     ; $7E77

jr_005_7e79:
    ld a, [de]                                    ; $7E79
    cp [hl]                                       ; $7E7A
    ret c                                         ; $7E7B

    jr nz, jr_005_7e84                            ; $7E7C

    dec de                                        ; $7E7E
    dec hl                                        ; $7E7F
    dec b                                         ; $7E80
    jr nz, jr_005_7e79                            ; $7E81

    ret                                           ; $7E83


jr_005_7e84:
    ld de, wBallScoreBcd                          ; $7E84
    ld hl, wBestBall                              ; $7E87
    ld b, $02                                     ; $7E8A

jr_005_7e8c:
    ld a, [de]                                    ; $7E8C
    ld [hl+], a                                   ; $7E8D
    inc de                                        ; $7E8E
    dec b                                         ; $7E8F
    jr nz, jr_005_7e8c                            ; $7E90

    ldh [hFarcallAArg], a                         ; $7E92
    farcall Counters_Store_Far                    ; $7E94
    ret                                           ; $7E9C


; I
Ball_LoadCharacterGfx::
    ld a, [wPickGfxToggle]                        ; $7E9D
    inc a                                         ; $7EA0
    and $01                                       ; $7EA1
    ld [wPickGfxToggle], a                        ; $7EA3
    call Ball_PickGfxBank                         ; $7EA6
    push af                                       ; $7EA9
    ld c, $00                                     ; $7EAA
    ldh [hFarcallAArg], a                         ; $7EAC
    ld a, BANK(Album_LoadNumeralTileB)            ; $7EAE
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7EB0
    call Far_Call                                 ; $7EB3
    ld de, $8d80                                  ; $7EB6
    ld bc, $0380                                  ; $7EB9
    call Mem_CopyFromBank                         ; $7EBC
    pop af                                        ; $7EBF
    push af                                       ; $7EC0
    ld c, $01                                     ; $7EC1
    ldh [hFarcallAArg], a                         ; $7EC3
    ld a, BANK(Album_LoadNumeralTileB)            ; $7EC5
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7EC7
    call Far_Call                                 ; $7ECA
    ld de, $9100                                  ; $7ECD
    ld bc, $0380                                  ; $7ED0
    call Mem_CopyFromBank                         ; $7ED3
    pop af                                        ; $7ED6
    ld c, $02                                     ; $7ED7
    ldh [hFarcallAArg], a                         ; $7ED9
    ld a, BANK(Album_LoadNumeralTileB)            ; $7EDB
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7EDD
    call Far_Call                                 ; $7EE0
    ld de, $9480                                  ; $7EE3
    ld bc, $0380                                  ; $7EE6
    call Mem_CopyFromBank                         ; $7EE9
    ret                                           ; $7EEC


; I
Ball_LoadGfx8D80::
    call Ball_PickGfxBank                         ; $7EED
    ldh [hFarcallAArg], a                         ; $7EF0
    ld a, BANK(Album_LoadNumeralTileB)            ; $7EF2
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7EF4
    call Far_Call                                 ; $7EF7
    ld de, $8d80                                  ; $7EFA
    ld bc, $0380                                  ; $7EFD
    call Vram_CopyFromBank_4                      ; $7F00
    ret                                           ; $7F03


; I: UNREFERENCED
Unused_Ball_LoadGfx9100::
    call Ball_PickGfxBank                         ; $7F04
    ldh [hFarcallAArg], a                         ; $7F07
    ld a, BANK(Album_LoadNumeralTileB)            ; $7F09
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7F0B
    call Far_Call                                 ; $7F0E
    ld de, $9100                                  ; $7F11
    ld bc, $0380                                  ; $7F14
    call Vram_CopyFromBank_4                      ; $7F17
    ret                                           ; $7F1A


; I: UNREFERENCED
Unused_Ball_LoadGfx9480::
    call Ball_PickGfxBank                         ; $7F1B
    ldh [hFarcallAArg], a                         ; $7F1E
    ld a, BANK(Album_LoadNumeralTileB)            ; $7F20
    ld hl, Album_LoadNumeralTileB_7CE3            ; $7F22
    call Far_Call                                 ; $7F25
    ld de, $9480                                  ; $7F28
    ld bc, $0380                                  ; $7F2B
    call Vram_CopyFromBank_4                      ; $7F2E
    ret                                           ; $7F31


; C
Ball_PickGfxBank::
    push bc                                       ; $7F32
    ld a, [wPickCharacter]                        ; $7F33
    cp $02                                        ; $7F36
    jr nz, jr_005_7f44                            ; $7F38

    ld hl, wGamefacePresent                       ; $7F3A
    bit 0, [hl]                                   ; $7F3D
    jr nz, jr_005_7f44                            ; $7F3F

    ld a, [wPickGfxToggle]                        ; $7F41

jr_005_7f44:
    ld c, a                                       ; $7F44
    ld b, $00                                     ; $7F45
    ld hl, Ball_PickGfxBank_Tbl7F4E               ; $7F47
    add hl, bc                                    ; $7F4A
    ld a, [hl]                                    ; $7F4B
    pop bc                                        ; $7F4C
    ret                                           ; $7F4D


; I: auto: 3 bytes, bytes; referenced by Ball_PickGfxBank. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PickGfxBank_Tbl7F4E::
    db $00

    db $07, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    ; padding
    ds $a1, $00

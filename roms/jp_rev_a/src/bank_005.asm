; Pocket Camera (Japan) (Rev A), bank $05. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; C: mode 1F: D.J. (TRIPY-H) music editor
Mode1F_DjEditor::
    ld a, [wState]                                ; $4000
    rst Rst18_JumpTable                           ; $4003

; C: 13 states
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
    farcopy Mem_CopyFromBank, Map_26_6780_Mode1F_State00_TitleInit, $9800, $0240 ; $406C
    call Oam_ClearShadow                          ; $407A
    call Pal_AllWhite                             ; $407D
    call Lcd_On                                   ; $4080
    push af                                       ; $4083
    ld a, MUSIC_DJ_TITLE                          ; $4084
    call Snd_Music                                ; $4086
    pop af                                        ; $4089
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

    push af                                       ; $409E
    ld a, SFX1_CURSOR_MOVE                        ; $409F
    call Snd_Sfx1                                 ; $40A1
    pop af                                        ; $40A4
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

    push af                                       ; $40BD
    ld a, SFX1_BEEP_REFUSED                       ; $40BE
    call Snd_Sfx1                                 ; $40C0
    pop af                                        ; $40C3
    ret                                           ; $40C4


jr_005_40c5:
    set_state STATE_1F_MENU_PERFORMER             ; $40C5
    ret                                           ; $40CA


jr_005_40cb:
    bit 1, a                                      ; $40CB
    ret z                                         ; $40CD

    push af                                       ; $40CE
    ld a, SFX1_KEY_B                              ; $40CF
    call Snd_Sfx1                                 ; $40D1
    pop af                                        ; $40D4
    call Pal_FadeOut                              ; $40D5
    call Lcd_Off                                  ; $40D8
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
    push af                                       ; $40FF
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $4100
    call Snd_Sfx1                                 ; $4102
    pop af                                        ; $4105
    ret                                           ; $4106


; C
DjTitle_DrawMenu1::
    call DjTitle_DrawSourceSprite                 ; $4107
    call DjTitle_DrawArrowLeft                    ; $410A
    call DjTitle_DrawArrowRight                   ; $410D
    call DjTitle_DrawPerformer                    ; $4110
    ret                                           ; $4113


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite::
    ldh a, [hFrameCounter]                        ; $4114
    srl a                                         ; $4116
    srl a                                         ; $4118
    and $01                                       ; $411A
    ld hl, wStartTuneSource                       ; $411C
    add [hl]                                      ; $411F
    add [hl]                                      ; $4120
    add $58                                       ; $4121
    ld bc, $306c                                  ; $4123
    call Oam_AddMeta_B02_6E4B                     ; $4126
    ret                                           ; $4129


; C: left arrow of the tune-source selector ($D9D5 = 0 factory songs / 1 blank / 2 saved): drawn when $D9D5 >= 1 at x
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
    add $60                                       ; $413F
    call Oam_AddMeta_B02_6E4B                     ; $4141
    ret                                           ; $4144


; C: right arrow of the tune-source selector: drawn when $D9D5 < 2 at x = $2D (value 0) or $45 (value 1), y = $59,
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
    add $5e                                       ; $415C
    call Oam_AddMeta_B02_6E4B                     ; $415E
    ret                                           ; $4161


; C: performer sprite from start_menu_performer_character. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; executed in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjTitle_DrawPerformer::
    ld a, [wStartPerformerSet]                    ; $4162
    add $63                                       ; $4165
    ld bc, $348e                                  ; $4167
    call Oam_AddMeta_B02_6E4B                     ; $416A
    ret                                           ; $416D


; C: start menu 2: factory song number (4 songs)
Mode1F_State02_MenuSong::
    call DjTitle_ReadSongKeys                     ; $416E
    call DjTitle_DrawMenu2                        ; $4171
    ldh a, [hKeysNew]                             ; $4174
    bit PADB_A, a                                 ; $4176
    jr z, jr_005_4186                             ; $4178

    push af                                       ; $417A
    ld a, SFX1_CURSOR_MOVE                        ; $417B
    call Snd_Sfx1                                 ; $417D
    pop af                                        ; $4180
    next_state                                    ; $4181
    ret                                           ; $4185


jr_005_4186:
    bit 1, a                                      ; $4186
    ret z                                         ; $4188

    push af                                       ; $4189
    ld a, SFX1_KEY_B                              ; $418A
    call Snd_Sfx1                                 ; $418C
    pop af                                        ; $418F
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
    push af                                       ; $41AE
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $41AF
    call Snd_Sfx1                                 ; $41B1
    pop af                                        ; $41B4
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


; C: two sprites $6E / $6F. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
DjTitle_DrawFrame2::
    ld a, $6e                                     ; $41C9
    ld bc, $4658                                  ; $41CB
    call Oam_AddMeta_B02_6E4B                     ; $41CE
    ld a, $6f                                     ; $41D1
    ld bc, $4e58                                  ; $41D3
    call Oam_AddMeta_B02_6E4B                     ; $41D6
    ret                                           ; $41D9


; C: up arrow of the factory-song selector ($D9D6 = 0-3): drawn when $D9D6 >= 1 at x = $3E, y = $54, meta $6A + frame;
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
    add $6a                                       ; $41EB
    call Oam_AddMeta_B02_6E4B                     ; $41ED
    ret                                           ; $41F0


; C: down arrow of the factory-song selector: drawn when $D9D6 < 3 at x = $4E, y = $54, meta $6C + frame; the sprite
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
    add $6c                                       ; $4202
    call Oam_AddMeta_B02_6E4B                     ; $4204
    ret                                           ; $4207


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite2::
    ld a, [wStartTuneSource]                      ; $4208
    sla a                                         ; $420B
    add $58                                       ; $420D
    ld bc, $306c                                  ; $420F
    call Oam_AddMeta_B02_6E4B                     ; $4212
    ret                                           ; $4215


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawPerformer2::
    ld a, [wStartPerformerSet]                    ; $4216
    add $63                                       ; $4219
    ld bc, $348e                                  ; $421B
    call Oam_AddMeta_B02_6E4B                     ; $421E
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
    ld hl, $7400                                  ; $4243
    add hl, bc                                    ; $4246
    ld a, $10                                     ; $4247
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

    push af                                       ; $425C
    ld a, SFX1_CURSOR_MOVE                        ; $425D
    call Snd_Sfx1                                 ; $425F
    pop af                                        ; $4262
    call Pal_FadeOut                              ; $4263
    call Lcd_Off                                  ; $4266
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

    push af                                       ; $42B0
    ld a, SFX1_KEY_B                              ; $42B1
    call Snd_Sfx1                                 ; $42B3
    pop af                                        ; $42B6
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
    push af                                       ; $42E4
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $42E5
    call Snd_Sfx1                                 ; $42E7
    pop af                                        ; $42EA
    ret                                           ; $42EB


; C
DjTitle_DrawMenu3::
    call DjTitle_DrawSourceSprite3                ; $42EC
    call DjTitle_DrawPerformerBlink               ; $42EF
    call DjTitle_DrawArrowLeft3                   ; $42F2
    call DjTitle_DrawArrowRight3                  ; $42F5
    call DjTitle_DrawFrame3                       ; $42F8
    ret                                           ; $42FB


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawSourceSprite3::
    ld a, [wStartTuneSource]                      ; $42FC
    sla a                                         ; $42FF
    add $58                                       ; $4301
    ld bc, $306c                                  ; $4303
    call Oam_AddMeta_B02_6E4B                     ; $4306
    ret                                           ; $4309


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
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
    add $62                                       ; $4318
    ld bc, $348e                                  ; $431A
    call Oam_AddMeta_B02_6E4B                     ; $431D
    ret                                           ; $4320


; C: left arrow of the performer-set selector ($D9D3 = 0-2): drawn when $D9D3 >= 1 at x = $1E, y = $8D, meta $66 +
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
    add $66                                       ; $4332
    call Oam_AddMeta_B02_6E4B                     ; $4334
    ret                                           ; $4337


; C: right arrow of the performer-set selector: drawn when $D9D3 < 2 at x = $42, y = $8D, meta $68 + frame; the sprite
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
    add $68                                       ; $4349
    call Oam_AddMeta_B02_6E4B                     ; $434B
    ret                                           ; $434E


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjTitle_DrawFrame3::
    ld a, [wStartTuneSource]                      ; $434F
    and a                                         ; $4352
    ret nz                                        ; $4353

    ld a, $6e                                     ; $4354
    ld bc, $4658                                  ; $4356
    call Oam_AddMeta_B02_6E4B                     ; $4359
    ld a, $6f                                     ; $435C
    ld bc, $4e58                                  ; $435E
    call Oam_AddMeta_B02_6E4B                     ; $4361
    ret                                           ; $4364


; C: performance screen: graphics; three channel indicators; tempo and level digits
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
    farcopy Mem_CopyFromBank, Map_27_59F0_Mode1F_State04_PerformanceSetup, $9e00, $01c0 ; $439B
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
    call Oam_ClearShadow                          ; $43DB
    call Pal_AllWhite                             ; $43DE
    call Lcd_On                                   ; $43E1
    push af                                       ; $43E4
    ld a, MUSIC_STOP                              ; $43E5
    call Snd_Music                                ; $43E7
    pop af                                        ; $43EA
    rst Rst08_WaitVBlank                          ; $43EB
    push af                                       ; $43EC
    ld a, MUSIC_HOLD                              ; $43ED
    call Snd_Music                                ; $43EF
    pop af                                        ; $43F2
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

    call Pal_FadeOut                              ; $442E
    call Lcd_Off                                  ; $4431
    ld hl, hStatShadow                            ; $4434
    res 6, [hl]                                   ; $4437
    ld hl, rIE                                    ; $4439
    res 1, [hl]                                   ; $443C
    set_state STATE_1F_EDIT_PAGES_SETUP           ; $443E
    ret                                           ; $4443


jr_005_4444:
    ld a, [wState]                                ; $4444
    cp $06                                        ; $4447
    ret nz                                        ; $4449

    ld a, [wDirtyFlag]                            ; $444A
    and a                                         ; $444D
    jr nz, jr_005_446d                            ; $444E

    call Pal_FadeOut                              ; $4450
    call Lcd_Off                                  ; $4453
    ld hl, hStatShadow                            ; $4456
    res 6, [hl]                                   ; $4459
    ld hl, rIE                                    ; $445B
    res 1, [hl]                                   ; $445E
    push af                                       ; $4460
    ld a, MUSIC_STOP                              ; $4461
    call Snd_Music                                ; $4463
    pop af                                        ; $4466
    set_state STATE_1F_TITLE_INIT                 ; $4467
    ret                                           ; $446C


jr_005_446d:
    call Oam_HideUnused                           ; $446D
    ld c, $03                                     ; $4470
    call DjEd_LoadPerformerTiles9480              ; $4472
    farcopy Vram_CopyFromBank, Gfx_1A_4E00_Mode1F_State05_Performance, $8d60, $02a0 ; $4475
    farcopy Vram_CopyFromBank, Map_27_5D70_Mode1F_State05_Performance, $9c00, $00e0 ; $4483
    rst Rst08_WaitVBlank                          ; $4491
    call DjEd_Tick                                ; $4492
    call DjPerf_NR51MaskAll                       ; $4495
    call DjSnd_Tick                               ; $4498
    call DjPanel_SlideOut                         ; $449B
    call Oam_ClearShadow                          ; $449E
    call DjPerf_UpdatePerformerTiles              ; $44A1
    call DjPanel_WaitLine                         ; $44A4
    ret                                           ; $44A7


; C: A: stores the tune (02:4A6B); slides the panel away; BGB watchpoint pass 2026-10-25: ran only in mode 1F and
; state 06 (5044 hits in 2 runs: 1F:06 x5044; tcrf_check/assets/mode_state_wp/)
Mode1F_State06_SavePanel::
    call DjPerf_UpdatePerformerTiles              ; $44A8
    ldh a, [hKeysNew]                             ; $44AB
    bit PADB_B, a                                 ; $44AD
    jr nz, jr_005_44be                            ; $44AF

    bit PADB_A, a                                 ; $44B1
    ret z                                         ; $44B3

    ldh [hFarcallAArg], a                         ; $44B4
    farcall Dj_StoreTune_Far                      ; $44B6

jr_005_44be:
    call Oam_HideUnused                           ; $44BE
    rst Rst08_WaitVBlank                          ; $44C1
    call DjPerf_AnimateSprites                    ; $44C2
    call Oam_HideUnused                           ; $44C5
    call DjPanel_SlideIn                          ; $44C8
    farcopy Vram_CopyFromBank, Gfx_1A_50A0_Mode1F_State06_SavePanel, $8f40, $00c0 ; $44CB
    farcopy Vram_CopyFromBank, Map_27_5E50_Mode1F_State06_SavePanel, $9c00, $00e0 ; $44D9
    call DjPanel_SlideOut                         ; $44E7
    call Oam_ClearShadow                          ; $44EA
    call DjPerf_UpdatePerformerTiles              ; $44ED
    call DjPanel_WaitLine                         ; $44F0
    next_state                                    ; $44F3
    ret                                           ; $44F7


; C: A: back to the title; B: back to the performance; BGB watchpoint pass 2026-10-25: ran only in mode 1F and state
; 07 (4322 hits in 1 runs: 1F:07 x4322; tcrf_check/assets/mode_state_wp/)
Mode1F_State07_QuitPanel::
    call DjPerf_UpdatePerformerTiles              ; $44F8
    ldh a, [hKeysNew]                             ; $44FB
    bit PADB_A, a                                 ; $44FD
    jr z, jr_005_452b                             ; $44FF

    call Oam_HideUnused                           ; $4501
    rst Rst08_WaitVBlank                          ; $4504
    call DjPerf_AnimateSprites                    ; $4505
    call Oam_HideUnused                           ; $4508
    call DjPanel_SlideIn                          ; $450B
    call Pal_FadeOut                              ; $450E
    call Lcd_Off                                  ; $4511
    ld hl, hStatShadow                            ; $4514
    res 6, [hl]                                   ; $4517
    ld hl, rIE                                    ; $4519
    res 1, [hl]                                   ; $451C
    push af                                       ; $451E
    ld a, MUSIC_STOP                              ; $451F
    call Snd_Music                                ; $4521
    pop af                                        ; $4524
    set_state STATE_1F_TITLE_INIT                 ; $4525
    ret                                           ; $452A


jr_005_452b:
    bit 1, a                                      ; $452B
    ret z                                         ; $452D

    call Oam_HideUnused                           ; $452E
    rst Rst08_WaitVBlank                          ; $4531
    call DjPerf_AnimateSprites                    ; $4532
    call Oam_HideUnused                           ; $4535
    call DjPanel_SlideIn                          ; $4538
    ld c, $00                                     ; $453B
    call DjEd_LoadPerformerTiles8D80              ; $453D
    ld c, $02                                     ; $4540
    call DjEd_LoadPerformerTiles9480              ; $4542
    call DjPerf_NR51MaskFromChannels              ; $4545
    call DjPerf_AnimateSprites                    ; $4548
    set_state STATE_1F_PERFORMANCE                ; $454B
    ret                                           ; $4550


; C: builds the SOUND I / SOUND II / NOISE pages; wave graph and cursors
Mode1F_State08_EditPagesSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_WINON | LCDCF_OBJON | LCDCF_BGON ; $4551
    ldh [hLcdcShadow], a                          ; $4553
    ld a, $e4                                     ; $4555
    ld [wPaletteTarget], a                        ; $4557
    ld [wPaletteTarget + $1], a                   ; $455A
    ld a, $d2                                     ; $455D
    ld [wPaletteTarget + $2], a                   ; $455F
    xor a                                         ; $4562
    ldh [hScxShadow], a                           ; $4563
    ldh [hScxBand1], a                            ; $4565
    ld a, $fc                                     ; $4567
    ldh [hScyShadow], a                           ; $4569
    ldh [hScyBand1], a                            ; $456B
    ld a, $77                                     ; $456D
    ldh [hWxShadow], a                            ; $456F
    ld a, $64                                     ; $4571
    ldh [hWyShadow], a                            ; $4573
    call DjPerf_Init                              ; $4575
    call DjSnd_BuildWaveStaging                   ; $4578
    ld a, $ff                                     ; $457B
    ld [wSound1FieldCursor + $1], a               ; $457D
    ld [wSound2FieldCursor + $1], a               ; $4580
    ld [wNoiseFieldCursor + $1], a                ; $4583
    ld a, $09                                     ; $4586
    ld [wSound1FieldCursor], a                    ; $4588
    ld a, $07                                     ; $458B
    ld [wSound2FieldCursor], a                    ; $458D
    ld a, $05                                     ; $4590
    ld [wNoiseFieldCursor], a                     ; $4592
    xor a                                         ; $4595
    ld [wSound1FieldCursor + $2], a               ; $4596
    ld [wSound2FieldCursor + $2], a               ; $4599
    ld [wNoiseFieldCursor + $2], a                ; $459C
    ld hl, wDirtyFlag                             ; $459F
    set 0, [hl]                                   ; $45A2
    farcopy Mem_CopyFromBank, Data_1C_6D60_Mode1F_State07_QuitPanel, $9000, $0500 ; $45A4
    farcopy Mem_CopyFromBank, Gfx_1C_7260_Mode1F_State08_EditPagesSetup, $8a00, $0600 ; $45B2
    farcopy Mem_CopyFromBank, Gfx_1C_7860_Mode1F_State08_EditPagesSetup, $8400, $0400 ; $45C0
    ld a, $1d                                     ; $45CE
    ld hl, Gfx_1D_4000_Mode1F_State08_EditPagesSetup ; $45D0
    ld de, $9500                                  ; $45D3
    ld bc, $0300                                  ; $45D6
    call Mem_CopyFromBank                         ; $45D9
    farcopy Mem_CopyFromBank, Gfx_1D_4300_Mode1F_State08_EditPagesSetup, $8800, $0200 ; $45DC
    farcopy Mem_CopyFromBank, Map_23_68C0_Mode1F_State08_EditPagesSetup, $9800, $02c0 ; $45EA
    farcopy Mem_CopyFromBank, Map_27_7990_Mode1F_State08_EditPagesSetup, $9c00, $00c0 ; $45F8
    ld hl, $9be0                                  ; $4606
    ld bc, $0020                                  ; $4609
    ld a, $ff                                     ; $460C
    call Mem_FillBc1                              ; $460E
    farcopy Mem_CopyFromBank, Data_1C_6D60_Mode1F_State07_QuitPanel, wLevelTileStaging, $0080 ; $4611
    farcopy Mem_CopyFromBank, Src_1C_6E60_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $80, $0080 ; $461F
    farcopy Mem_CopyFromBank, Src_1C_6F60_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $100, $0080 ; $462D
    farcopy Mem_CopyFromBank, Src_1C_7060_Mode1F_State08_EditPagesSetup, wLevelTileStaging + $180, $0080 ; $463B
    ld a, $04                                     ; $4649
    ld [wWaveGraphPhase], a                       ; $464B
    ld a, $63                                     ; $464E
    ldh [hLycShadowSplit1], a                     ; $4650
    ldh [hSplit1Latch], a                         ; $4652
    ld hl, hStatShadow                            ; $4654
    set 6, [hl]                                   ; $4657
    ld hl, rIE                                    ; $4659
    set 1, [hl]                                   ; $465C
    ld a, $02                                     ; $465E
    ldh [hStatHandlerIndex], a                    ; $4660
    call Oam_ClearShadow                          ; $4662
    call DjEd_DrawPageTabs                        ; $4665
    call Pal_AllWhite                             ; $4668
    call Lcd_On                                   ; $466B
    ld a, [wSound1DutyLen]                        ; $466E
    swap a                                        ; $4671
    sla a                                         ; $4673
    ld c, a                                       ; $4675
    ld b, $00                                     ; $4676
    ld hl, $9861                                  ; $4678
    add hl, bc                                    ; $467B
    ld a, $c9                                     ; $467C
    call Vram_WriteByteSafe                       ; $467E
    ld a, [wSound1Envelope]                       ; $4681
    ld hl, $9884                                  ; $4684
    add $da                                       ; $4687
    call Vram_WriteByteSafe                       ; $4689
    ld a, [wSound1Modulation + $2]                ; $468C
    swap a                                        ; $468F
    sla a                                         ; $4691
    ld c, a                                       ; $4693
    ld b, $00                                     ; $4694
    ld hl, $9871                                  ; $4696
    add hl, bc                                    ; $4699
    ld a, $ca                                     ; $469A
    call Vram_WriteByteSafe                       ; $469C
    ld de, wSound1Notes                           ; $469F
    call DjEd_DrawNoteRow                         ; $46A2
    call Pal_FadeIn                               ; $46A5
    next_state                                    ; $46A8
    ret                                           ; $46AC


; C: page tab sprites $A5 / $A7
DjEd_DrawPageTabs::
    ld bc, $0084                                  ; $46AD
    ld a, $a5                                     ; $46B0
    call Oam_AddMeta_B01_5D47                     ; $46B2
    ld bc, $7f0e                                  ; $46B5
    ld a, $a7                                     ; $46B8
    call Oam_AddMeta_B01_5D47                     ; $46BA
    ret                                           ; $46BD


; C: SOUND I page: field editor; redraw; page keys
Mode1F_State09_PageSound1::
    call DjEd_DrawPageTabs                        ; $46BE
    call DjS1_FieldDispatch                       ; $46C1
    call DjEd_Tick                                ; $46C4
    call DjS1_DrawAllValues                       ; $46C7
    call DjS2_DrawValueRow                        ; $46CA
    call DjSnd_Tick                               ; $46CD
    ldh a, [hKeysNew]                             ; $46D0
    bit PADB_SELECT, a                            ; $46D2
    jr z, jr_005_4744                             ; $46D4

    call Oam_HideUnused                           ; $46D6
    rst Rst08_WaitVBlank                          ; $46D9
    call DjEd_DrawPageTabs                        ; $46DA
    call DjS1_DrawModAndLoop                      ; $46DD
    call DjS2_DrawValueRow                        ; $46E0
    farcopy Vram_CopyFromBank, Gfx_1D_4500_Mode1F_State09_PageSound1, $9500, $0300 ; $46E3
    farcopy Vram_CopyFromBank, Map_23_6B00_Mode1F_State09_PageSound1, $9840, $0080 ; $46F1
    farcopy Vram_CopyFromBank, Gfx_1D_4800_Mode1F_State09_PageSound1, $8800, $0200 ; $46FF
    ld a, [wSound2WaveLen]                        ; $470D
    swap a                                        ; $4710
    sla a                                         ; $4712
    ld c, a                                       ; $4714
    ld b, $00                                     ; $4715
    ld hl, $9861                                  ; $4717
    add hl, bc                                    ; $471A
    ld a, $cb                                     ; $471B
    call Vram_WriteByteSafe                       ; $471D
    ld a, [wSound2Modulation + $2]                ; $4720
    swap a                                        ; $4723
    sla a                                         ; $4725
    ld c, a                                       ; $4727
    ld b, $00                                     ; $4728
    ld hl, $9871                                  ; $472A
    add hl, bc                                    ; $472D
    ld a, $ca                                     ; $472E
    call Vram_WriteByteSafe                       ; $4730
    ld a, $ff                                     ; $4733
    ld [wSound2FieldCursor + $1], a               ; $4735
    ld de, wSound2Notes                           ; $4738
    call DjEd_DrawNoteRow                         ; $473B
    set_state STATE_1F_PAGE_SOUND2                ; $473E
    ret                                           ; $4743


jr_005_4744:
    bit 1, a                                      ; $4744
    jr z, jr_005_474e                             ; $4746

    set_state STATE_1F_RESTART                    ; $4748
    ret                                           ; $474D


jr_005_474e:
    ldh a, [hKeysHeld]                            ; $474E
    bit PADB_START, a                             ; $4750
    ret z                                         ; $4752

    ldh a, [hKeysNew]                             ; $4753
    bit PADB_A, a                                 ; $4755
    ret z                                         ; $4757

    jp DjPrint_Job                                ; $4758


; C: rst $18 on the SOUND I field cursor
DjS1_FieldDispatch::
    ld a, [wSound1FieldCursor]                    ; $475B
    rst Rst18_JumpTable                           ; $475E

; C: 12 SOUND I field handlers
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
    call DjEd_DrawPageTabs                        ; $4777
    call DjS2_FieldDispatch                       ; $477A
    call DjEd_Tick                                ; $477D
    call DjS2_RedrawWaveGraphStep                 ; $4780
    call DjS2_WaveRedrawTick                      ; $4783
    call DjS2_WaveRedrawColumns                   ; $4786
    call DjS2_WaveGraphToVram                     ; $4789
    call DjSnd_Tick                               ; $478C
    ldh a, [hKeysNew]                             ; $478F
    bit PADB_SELECT, a                            ; $4791
    jr z, jr_005_47f9                             ; $4793

    call Oam_HideUnused                           ; $4795
    rst Rst08_WaitVBlank                          ; $4798
    call DjEd_DrawPageTabs                        ; $4799
    call DjS2_DrawAllValues                       ; $479C
    call DjS2_WaveRedrawTick                      ; $479F
    farcopy Vram_CopyFromBank, Map_23_6C00_Mode1F_State0A_PageSound2, $9840, $0080 ; $47A2
    farcopy Vram_CopyFromBank, Gfx_1D_4A00_Mode1F_State0A_PageSound2, $9500, $0300 ; $47B0
    farcopy Vram_CopyFromBank, Map_23_6B80_Mode1F_State0A_PageSound2, $9840, $0080 ; $47BE
    farcopy Vram_CopyFromBank, Gfx_1D_4D00_Mode1F_State0A_PageSound2, $8800, $0200 ; $47CC
    call DjEd_DrawPageTabNoise                    ; $47DA
    ld a, [wNoiseEnvelope]                        ; $47DD
    ld hl, $9884                                  ; $47E0
    add $da                                       ; $47E3
    call Vram_WriteByteSafe                       ; $47E5
    ld a, $ff                                     ; $47E8
    ld [wNoiseFieldCursor + $1], a                ; $47EA
    ld de, wNoiseNotes                            ; $47ED
    call DjEd_DrawNoteRow                         ; $47F0
    set_state STATE_1F_PAGE_NOISE                 ; $47F3
    ret                                           ; $47F8


jr_005_47f9:
    bit 1, a                                      ; $47F9
    ret z                                         ; $47FB

    set_state STATE_1F_RESTART                    ; $47FC
    ret                                           ; $4801


; C: rst $18 on the SOUND II field cursor
DjS2_FieldDispatch::
    ld a, [wSound2FieldCursor]                    ; $4802
    rst Rst18_JumpTable                           ; $4805

; C: 10 SOUND II field handlers
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
    call DjEd_DrawPageTabs                        ; $481A
    call DjEd_DrawPageTabNoise                    ; $481D
    call DjNs_FieldDispatch                       ; $4820
    call DjEd_Tick                                ; $4823
    call DjNs_DrawAllValues                       ; $4826
    call DjNs_DrawPlayCursor                      ; $4829
    call DjSnd_Tick                               ; $482C
    ldh a, [hKeysNew]                             ; $482F
    bit PADB_SELECT, a                            ; $4831
    jr z, jr_005_48ae                             ; $4833

    call Oam_HideUnused                           ; $4835
    rst Rst08_WaitVBlank                          ; $4838
    call DjEd_DrawPageTabs                        ; $4839
    call DjNs_DrawAllValues                       ; $483C
    call DjNs_DrawPlayCursor                      ; $483F
    ld a, $1d                                     ; $4842
    ld hl, Gfx_1D_4000_Mode1F_State08_EditPagesSetup ; $4844
    ld de, $9500                                  ; $4847
    ld bc, $0300                                  ; $484A
    call Vram_CopyFromBank                        ; $484D
    farcopy Vram_CopyFromBank, Map_23_6900_Mode1F_State0B_PageNoise, $9840, $0080 ; $4850
    farcopy Vram_CopyFromBank, Gfx_1D_4300_Mode1F_State08_EditPagesSetup, $8800, $0200 ; $485E
    ld a, [wSound1DutyLen]                        ; $486C
    swap a                                        ; $486F
    sla a                                         ; $4871
    ld c, a                                       ; $4873
    ld b, $00                                     ; $4874
    ld hl, $9861                                  ; $4876
    add hl, bc                                    ; $4879
    ld a, $c9                                     ; $487A
    call Vram_WriteByteSafe                       ; $487C
    ld a, [wSound1Envelope]                       ; $487F
    ld hl, $9884                                  ; $4882
    add $da                                       ; $4885
    call Vram_WriteByteSafe                       ; $4887
    ld a, [wSound1Modulation + $2]                ; $488A
    swap a                                        ; $488D
    sla a                                         ; $488F
    ld c, a                                       ; $4891
    ld b, $00                                     ; $4892
    ld hl, $9871                                  ; $4894
    add hl, bc                                    ; $4897
    ld a, $ca                                     ; $4898
    call Vram_WriteByteSafe                       ; $489A
    ld a, $ff                                     ; $489D
    ld [wSound1FieldCursor + $1], a               ; $489F
    ld de, wSound1Notes                           ; $48A2
    call DjEd_DrawNoteRow                         ; $48A5
    set_state STATE_1F_PAGE_SOUND1                ; $48A8
    ret                                           ; $48AD


jr_005_48ae:
    bit 1, a                                      ; $48AE
    ret z                                         ; $48B0

    set_state STATE_1F_RESTART                    ; $48B1
    ret                                           ; $48B6


; C: tab sprite $A6. L3 pass 2026-10-26: executed in BGB in the scenarios dj_perf_start_noise 1F:0A,
; dj_perf_start_noise 1F:0B, dj_print_noise 1F:0A, dj_print_noise 1F:0B (tcrf_check/assets/l3_names/scen_hits*.csv)
DjEd_DrawPageTabNoise::
    ld bc, $062f                                  ; $48B7
    ld a, $a6                                     ; $48BA
    call Oam_AddMeta_B01_5D47                     ; $48BC
    ret                                           ; $48BF


; C: rst $18 on the NOISE field cursor
DjNs_FieldDispatch::
    ld a, [wNoiseFieldCursor]                     ; $48C0
    rst Rst18_JumpTable                           ; $48C3

; C: 8 NOISE field handlers
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
    set_state STATE_1F_PERFORMANCE_SETUP          ; $48D4
    call Pal_FadeOut                              ; $48D9
    call Lcd_Off                                  ; $48DC
    ld hl, hStatShadow                            ; $48DF
    res 6, [hl]                                   ; $48E2
    ld hl, rIE                                    ; $48E4
    res 1, [hl]                                   ; $48E7
    ret                                           ; $48E9


; C: A held: Left / Right steps A within [B;C] with auto repeat and a blip (variant 1)
DjEd_StepValue_Right::
    ld hl, hKeysHeld                              ; $48EA
    bit 0, [hl]                                   ; $48ED
    ret z                                         ; $48EF

    ld hl, hKeysNewRepeat                         ; $48F0
    bit 7, [hl]                                   ; $48F3
    jr z, jr_005_4904                             ; $48F5

    cp b                                          ; $48F7
    jr z, jr_005_4913                             ; $48F8

    push af                                       ; $48FA
    ld a, $03                                     ; $48FB
    ld [wUiSfxRequest], a                         ; $48FD
    pop af                                        ; $4900
    dec a                                         ; $4901
    jr jr_005_4913                                ; $4902

jr_005_4904:
    bit 6, [hl]                                   ; $4904
    jr z, jr_005_4913                             ; $4906

    cp c                                          ; $4908
    jr z, jr_005_4913                             ; $4909

    push af                                       ; $490B
    ld a, $02                                     ; $490C
    ld [wUiSfxRequest], a                         ; $490E
    pop af                                        ; $4911
    inc a                                         ; $4912

jr_005_4913:
    ld hl, hKeysHeld                              ; $4913
    res 7, [hl]                                   ; $4916
    res 6, [hl]                                   ; $4918
    inc hl                                        ; $491A
    res 7, [hl]                                   ; $491B
    res 6, [hl]                                   ; $491D
    inc hl                                        ; $491F
    res 7, [hl]                                   ; $4920
    res 6, [hl]                                   ; $4922
    ret                                           ; $4924


; C: same for Up / Down (bits 6 / 7)
DjEd_StepValue_Up::
    ld hl, hKeysHeld                              ; $4925
    bit 0, [hl]                                   ; $4928
    ret z                                         ; $492A

    ld hl, hKeysNewRepeat                         ; $492B
    bit 6, [hl]                                   ; $492E
    jr z, jr_005_493f                             ; $4930

    cp b                                          ; $4932
    jr z, jr_005_494e                             ; $4933

    push af                                       ; $4935
    ld a, $06                                     ; $4936
    ld [wUiSfxRequest], a                         ; $4938
    pop af                                        ; $493B
    dec a                                         ; $493C
    jr jr_005_494e                                ; $493D

jr_005_493f:
    bit 7, [hl]                                   ; $493F
    jr z, jr_005_494e                             ; $4941

    cp c                                          ; $4943
    jr z, jr_005_494e                             ; $4944

    push af                                       ; $4946
    ld a, $07                                     ; $4947
    ld [wUiSfxRequest], a                         ; $4949
    pop af                                        ; $494C
    inc a                                         ; $494D

jr_005_494e:
    ld hl, hKeysHeld                              ; $494E
    res 7, [hl]                                   ; $4951
    res 6, [hl]                                   ; $4953
    inc hl                                        ; $4955
    res 7, [hl]                                   ; $4956
    res 6, [hl]                                   ; $4958
    inc hl                                        ; $495A
    res 7, [hl]                                   ; $495B
    res 6, [hl]                                   ; $495D
    ret                                           ; $495F


; C: same for Left / Right (bits 5 / 4)
DjEd_StepValue_LeftRight::
    ld hl, hKeysHeld                              ; $4960
    bit 0, [hl]                                   ; $4963
    ret z                                         ; $4965

    ld hl, hKeysNewRepeat                         ; $4966
    bit 5, [hl]                                   ; $4969
    jr z, jr_005_497a                             ; $496B

    cp b                                          ; $496D
    jr z, jr_005_4989                             ; $496E

    push af                                       ; $4970
    ld a, $06                                     ; $4971
    ld [wUiSfxRequest], a                         ; $4973
    pop af                                        ; $4976
    dec a                                         ; $4977
    jr jr_005_4989                                ; $4978

jr_005_497a:
    bit 4, [hl]                                   ; $497A
    jr z, jr_005_4989                             ; $497C

    cp c                                          ; $497E
    jr z, jr_005_4989                             ; $497F

    push af                                       ; $4981
    ld a, $07                                     ; $4982
    ld [wUiSfxRequest], a                         ; $4984
    pop af                                        ; $4987
    inc a                                         ; $4988

jr_005_4989:
    ld hl, hKeysHeld                              ; $4989
    res 4, [hl]                                   ; $498C
    res 5, [hl]                                   ; $498E
    inc hl                                        ; $4990
    res 4, [hl]                                   ; $4991
    res 5, [hl]                                   ; $4993
    inc hl                                        ; $4995
    res 4, [hl]                                   ; $4996
    res 5, [hl]                                   ; $4998
    ret                                           ; $499A


; C: Left / Right step A between B and C (no A held needed)
DjEd_StepLeftRight::
    ld hl, hKeysNewRepeat                         ; $499B
    bit 5, [hl]                                   ; $499E
    jr z, jr_005_49ad                             ; $49A0

    cp b                                          ; $49A2
    ret z                                         ; $49A3

    push af                                       ; $49A4
    ld a, $08                                     ; $49A5
    ld [wUiSfxRequest], a                         ; $49A7
    pop af                                        ; $49AA
    dec a                                         ; $49AB
    ret                                           ; $49AC


jr_005_49ad:
    bit 4, [hl]                                   ; $49AD
    ret z                                         ; $49AF

    cp c                                          ; $49B0
    ret z                                         ; $49B1

    push af                                       ; $49B2
    ld a, $08                                     ; $49B3
    ld [wUiSfxRequest], a                         ; $49B5
    pop af                                        ; $49B8
    inc a                                         ; $49B9
    ret                                           ; $49BA


; C: Up / Down step A between B and C
DjEd_StepUpDown::
    ld hl, hKeysNewRepeat                         ; $49BB
    bit 6, [hl]                                   ; $49BE
    jr z, jr_005_49cd                             ; $49C0

    cp b                                          ; $49C2
    ret z                                         ; $49C3

    push af                                       ; $49C4
    ld a, $08                                     ; $49C5
    ld [wUiSfxRequest], a                         ; $49C7
    pop af                                        ; $49CA
    dec a                                         ; $49CB
    ret                                           ; $49CC


jr_005_49cd:
    bit 7, [hl]                                   ; $49CD
    ret z                                         ; $49CF

    cp c                                          ; $49D0
    ret z                                         ; $49D1

    push af                                       ; $49D2
    ld a, $08                                     ; $49D3
    ld [wUiSfxRequest], a                         ; $49D5
    pop af                                        ; $49D8
    inc a                                         ; $49D9
    ret                                           ; $49DA


; C: Down / Up step with auto repeat
DjEd_StepDownUp::
    ld hl, hKeysNewRepeat                         ; $49DB
    bit 7, [hl]                                   ; $49DE
    jr z, jr_005_49ed                             ; $49E0

    cp b                                          ; $49E2
    ret z                                         ; $49E3

    push af                                       ; $49E4
    ld a, $08                                     ; $49E5
    ld [wUiSfxRequest], a                         ; $49E7
    pop af                                        ; $49EA
    dec a                                         ; $49EB
    ret                                           ; $49EC


jr_005_49ed:
    bit 6, [hl]                                   ; $49ED
    ret z                                         ; $49EF

    cp c                                          ; $49F0
    ret z                                         ; $49F1

    push af                                       ; $49F2
    ld a, $08                                     ; $49F3
    ld [wUiSfxRequest], a                         ; $49F5
    pop af                                        ; $49F8
    inc a                                         ; $49F9
    ret                                           ; $49FA


; C: tempo accumulator: +tempo each frame; tick at 900; advances the three playback steps
DjEd_Tick::
    xor a                                         ; $49FB
    ld [wTickFlag], a                             ; $49FC
    ld a, [wPerfPaused]                           ; $49FF
    and a                                         ; $4A02
    ret nz                                        ; $4A03

    ld a, [wTempo]                                ; $4A04
    ld hl, wTempoAcc                              ; $4A07
    add [hl]                                      ; $4A0A
    ld [hl+], a                                   ; $4A0B
    jr nc, jr_005_4a0f                            ; $4A0C

    inc [hl]                                      ; $4A0E

jr_005_4a0f:
    ld a, [hl-]                                   ; $4A0F
    cp $03                                        ; $4A10
    ret c                                         ; $4A12

    ld a, [hl]                                    ; $4A13
    jr nz, jr_005_4a19                            ; $4A14

    cp $84                                        ; $4A16
    ret c                                         ; $4A18

jr_005_4a19:
    sub $84                                       ; $4A19
    ld [hl+], a                                   ; $4A1B
    ld a, [hl]                                    ; $4A1C
    sbc $03                                       ; $4A1D
    ld [hl], a                                    ; $4A1F
    ld hl, wPerfStepIncrement                     ; $4A20
    ld a, [wSound1PlayStep]                       ; $4A23
    add [hl]                                      ; $4A26
    ld [wSound1PlayStep], a                       ; $4A27
    ld a, [wSound2PlayStep]                       ; $4A2A
    add [hl]                                      ; $4A2D
    ld [wSound2PlayStep], a                       ; $4A2E
    ld a, [wNoisePlayStep]                        ; $4A31
    add [hl]                                      ; $4A34
    ld [wNoisePlayStep], a                        ; $4A35
    ld hl, wTickFlag                              ; $4A38
    inc [hl]                                      ; $4A3B
    ld a, [wSound1PlayStep]                       ; $4A3C
    bit 7, a                                      ; $4A3F
    jr z, jr_005_4a4a                             ; $4A41

    ld a, [wLoopLengths]                          ; $4A43
    dec a                                         ; $4A46
    ld [wSound1PlayStep], a                       ; $4A47

jr_005_4a4a:
    ld a, [wSound2PlayStep]                       ; $4A4A
    bit 7, a                                      ; $4A4D
    jr z, jr_005_4a58                             ; $4A4F

    ld a, [wLoopLengths + $1]                     ; $4A51
    dec a                                         ; $4A54
    ld [wSound2PlayStep], a                       ; $4A55

jr_005_4a58:
    ld a, [wNoisePlayStep]                        ; $4A58
    bit 7, a                                      ; $4A5B
    jr z, jr_005_4a66                             ; $4A5D

    ld a, [wNoiseGateLoop + $1]                   ; $4A5F
    dec a                                         ; $4A62
    ld [wNoisePlayStep], a                        ; $4A63

jr_005_4a66:
    ld a, [wSound1PlayStep]                       ; $4A66
    ld hl, wLoopLengths                           ; $4A69
    cp [hl]                                       ; $4A6C
    jr c, jr_005_4a73                             ; $4A6D

    xor a                                         ; $4A6F
    ld [wSound1PlayStep], a                       ; $4A70

jr_005_4a73:
    ld a, [wSound2PlayStep]                       ; $4A73
    ld hl, wLoopLengths + $1                      ; $4A76
    cp [hl]                                       ; $4A79
    jr c, jr_005_4a80                             ; $4A7A

    xor a                                         ; $4A7C
    ld [wSound2PlayStep], a                       ; $4A7D

jr_005_4a80:
    ld a, [wNoisePlayStep]                        ; $4A80
    ld hl, wNoiseGateLoop + $1                    ; $4A83
    cp [hl]                                       ; $4A86
    jr c, jr_005_4a8d                             ; $4A87

    xor a                                         ; $4A89
    ld [wNoisePlayStep], a                        ; $4A8A

jr_005_4a8d:
    ret                                           ; $4A8D


; C: field cursors to their first fields and steps to 0
DjEd_ResetCursors::
    ld a, $ff                                     ; $4A8E
    ld [wSound1FieldCursor + $1], a               ; $4A90
    ld [wSound2FieldCursor + $1], a               ; $4A93
    ld [wNoiseFieldCursor + $1], a                ; $4A96
    ld a, $09                                     ; $4A99
    ld [wSound1FieldCursor], a                    ; $4A9B
    ld a, $07                                     ; $4A9E
    ld [wSound2FieldCursor], a                    ; $4AA0
    ld a, $05                                     ; $4AA3
    ld [wNoiseFieldCursor], a                     ; $4AA5
    xor a                                         ; $4AA8
    ld [wSound1FieldCursor + $2], a               ; $4AA9
    ld [wSound2FieldCursor + $2], a               ; $4AAC
    ld [wNoiseFieldCursor + $2], a                ; $4AAF
    xor a                                         ; $4AB2
    ld [wSound1PlayStep], a                       ; $4AB3
    ld [wSound2PlayStep], a                       ; $4AB6
    ld [wNoisePlayStep], a                        ; $4AB9
    ret                                           ; $4ABC


; C: playback step cursor sprite
DjEd_DrawPlayCursor::
    push af                                       ; $4ABD
    sla a                                         ; $4ABE
    sla a                                         ; $4AC0
    sla a                                         ; $4AC2
    add $1d                                       ; $4AC4
    ld b, a                                       ; $4AC6
    ld c, $49                                     ; $4AC7
    pop af                                        ; $4AC9
    and $03                                       ; $4ACA
    jr nz, jr_005_4ad2                            ; $4ACC

    ld a, $7a                                     ; $4ACE
    jr jr_005_4ad4                                ; $4AD0

jr_005_4ad2:
    ld a, $7b                                     ; $4AD2

jr_005_4ad4:
    call Oam_AddMeta_B01_5D47                     ; $4AD4
    ret                                           ; $4AD7


; C
DjEd_DrawNoteStepCursor::
    ld c, a                                       ; $4AD8
    ld b, $00                                     ; $4AD9
    add hl, bc                                    ; $4ADB
    ld a, [hl]                                    ; $4ADC
    ld c, a                                       ; $4ADD
    sla a                                         ; $4ADE
    add c                                         ; $4AE0
    ld c, a                                       ; $4AE1
    ld b, $00                                     ; $4AE2
    ld hl, DjEd_DrawNoteStepCursor_Tbl4C4E        ; $4AE4
    add hl, bc                                    ; $4AE7
    ld a, [hl+]                                   ; $4AE8
    push af                                       ; $4AE9
    ld a, [hl+]                                   ; $4AEA
    ld c, a                                       ; $4AEB
    call DjEd_ColumnVisible                       ; $4AEC
    pop af                                        ; $4AEF
    call Oam_AddMeta_B01_5D47                     ; $4AF0
    ret                                           ; $4AF3


; C: tests whether a column is inside the scrolled window. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; executed in the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjEd_ColumnVisible::
    ld a, [hl]                                    ; $4AF4
    ld b, a                                       ; $4AF5
    ld hl, hScxBand1                              ; $4AF6
    sub [hl]                                      ; $4AF9
    jr c, jr_005_4b06                             ; $4AFA

    cp $18                                        ; $4AFC
    jr c, jr_005_4b06                             ; $4AFE

    cp $60                                        ; $4B00
    jr nc, jr_005_4b12                            ; $4B02

    ld b, a                                       ; $4B04
    ret                                           ; $4B05


jr_005_4b06:
    ld a, b                                       ; $4B06
    sub $18                                       ; $4B07
    jr c, jr_005_4b0f                             ; $4B09

    ld [hl], a                                    ; $4B0B
    ld b, $18                                     ; $4B0C
    ret                                           ; $4B0E


jr_005_4b0f:
    xor a                                         ; $4B0F
    ld [hl], a                                    ; $4B10
    ret                                           ; $4B11


jr_005_4b12:
    ld a, b                                       ; $4B12
    sub $60                                       ; $4B13
    cp $90                                        ; $4B15
    jr nc, jr_005_4b1d                            ; $4B17

    ld [hl], a                                    ; $4B19
    ld b, $60                                     ; $4B1A
    ret                                           ; $4B1C


jr_005_4b1d:
    ld [hl], $90                                  ; $4B1D
    ld a, b                                       ; $4B1F
    sub $90                                       ; $4B20
    ld b, a                                       ; $4B22
    ret                                           ; $4B23


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjEd_DrawNoteMarker::
    push af                                       ; $4B24
    sla a                                         ; $4B25
    sla a                                         ; $4B27
    sla a                                         ; $4B29
    add $1c                                       ; $4B2B
    ld b, a                                       ; $4B2D
    ld c, $57                                     ; $4B2E
    ld de, $000f                                  ; $4B30
    jp DjEd_DrawNoteCursor_BlinkTail              ; $4B33


; C: blinking cursor on the note grid (blink table at 4B84)
DjEd_DrawNoteCursorBlink::
    ld c, a                                       ; $4B36
    ld b, $00                                     ; $4B37
    add hl, bc                                    ; $4B39
    ld a, [hl]                                    ; $4B3A
    push af                                       ; $4B3B
    ld c, a                                       ; $4B3C
    sla a                                         ; $4B3D
    add c                                         ; $4B3F
    ld c, a                                       ; $4B40
    ld b, $00                                     ; $4B41
    ld hl, DjEd_DrawNoteCursorBlink_Tbl4C4F       ; $4B43
    add hl, bc                                    ; $4B46
    ld c, [hl]                                    ; $4B47
    inc hl                                        ; $4B48
    call DjEd_ColumnVisible                       ; $4B49
    ld de, $0025                                  ; $4B4C

; C: shared tail of DjEd_DrawNoteMarker and DjEd_DrawNoteCursorBlink: frame from the blink table 4B84 by the phase
; $D893, +4 / +2 when A = D / E, Oam_AddMeta_B01_5D47, then advances the blink counter $D892 / phase $D893 (branch
; target; code read 2026-10-19)
DjEd_DrawNoteCursor_BlinkTail::
    push de                                       ; $4B4F
    ld a, [wSndNoteBlinkPhase]                    ; $4B50
    and $03                                       ; $4B53
    sla a                                         ; $4B55
    ld e, a                                       ; $4B57
    ld d, $00                                     ; $4B58
    ld hl, DjEd_DrawNoteCursorBlink_Tbl4B84       ; $4B5A
    add hl, de                                    ; $4B5D
    pop de                                        ; $4B5E
    pop af                                        ; $4B5F
    cp d                                          ; $4B60
    jr z, jr_005_4b69                             ; $4B61

    cp e                                          ; $4B63
    jr z, jr_005_4b6d                             ; $4B64

    xor a                                         ; $4B66
    jr jr_005_4b6f                                ; $4B67

jr_005_4b69:
    ld a, $04                                     ; $4B69
    jr jr_005_4b6f                                ; $4B6B

jr_005_4b6d:
    ld a, $02                                     ; $4B6D

jr_005_4b6f:
    add [hl]                                      ; $4B6F
    call Oam_AddMeta_B01_5D47                     ; $4B70
    inc hl                                        ; $4B73
    ld a, [wSndNoteBlinkCounter]                  ; $4B74
    cp [hl]                                       ; $4B77
    jr c, jr_005_4b7f                             ; $4B78

    ld hl, wSndNoteBlinkPhase                     ; $4B7A
    inc [hl]                                      ; $4B7D
    xor a                                         ; $4B7E

jr_005_4b7f:
    inc a                                         ; $4B7F
    ld [wSndNoteBlinkCounter], a                  ; $4B80
    ret                                           ; $4B83


; C: auto: 8 bytes, bytes; referenced by DjEd_DrawNoteCursorBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteCursorBlink_Tbl4B84::
    db $8c, $15, $8d, $04, $8c, $05, $8d, $02

; C
DjEd_DrawNoteColumn::
    ld c, a                                       ; $4B8C
    ld b, $00                                     ; $4B8D
    add hl, bc                                    ; $4B8F
    ld a, [hl]                                    ; $4B90
    and $0f                                       ; $4B91
    ld c, a                                       ; $4B93
    ld hl, DjEd_DrawNoteColumn_Tbl4BB2            ; $4B94
    add hl, bc                                    ; $4B97
    ld c, [hl]                                    ; $4B98
    add hl, bc                                    ; $4B99
    ld d, $04                                     ; $4B9A

jr_005_4b9c:
    ld b, [hl]                                    ; $4B9C
    inc hl                                        ; $4B9D
    ld c, [hl]                                    ; $4B9E
    inc hl                                        ; $4B9F
    push hl                                       ; $4BA0
    bit 0, e                                      ; $4BA1
    jr z, jr_005_4ba6                             ; $4BA3

    inc hl                                        ; $4BA5

jr_005_4ba6:
    ld a, [hl]                                    ; $4BA6
    and a                                         ; $4BA7
    call nz, Oam_AddMeta_B01_5D47                 ; $4BA8
    pop hl                                        ; $4BAB
    inc hl                                        ; $4BAC
    inc hl                                        ; $4BAD
    dec d                                         ; $4BAE
    jr nz, jr_005_4b9c                            ; $4BAF

    ret                                           ; $4BB1


; C: auto: 102 bytes, bytes; referenced by DjEd_DrawNoteColumn. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteColumn_Tbl4BB2::
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
    ld c, a                                       ; $4C18
    ld b, $00                                     ; $4C19
    add hl, bc                                    ; $4C1B
    ld a, [hl]                                    ; $4C1C
    and $10                                       ; $4C1D
    srl a                                         ; $4C1F
    add $80                                       ; $4C21
    ld b, a                                       ; $4C23
    ld c, $73                                     ; $4C24
    ld a, $74                                     ; $4C26
    call Oam_AddMeta_B01_5D47                     ; $4C28
    ret                                           ; $4C2B


; C: loop-length bar sprites $74 / $6E
DjEd_DrawLoopBar::
    ld bc, $8486                                  ; $4C2C
    ld a, $74                                     ; $4C2F
    call Oam_AddMeta_B01_5D47                     ; $4C31
    ld bc, $7886                                  ; $4C34
    ld a, $6e                                     ; $4C37
    call Oam_AddMeta_B01_5D47                     ; $4C39
    ld bc, $9286                                  ; $4C3C
    ld a, $6f                                     ; $4C3F
    call Oam_AddMeta_B01_5D47                     ; $4C41
    ret                                           ; $4C44


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the loop bar sprite of the NOISE page (meta $74 at $8073)
DjEd_DrawLoopBarNoise::
    ld bc, $8073                                  ; $4C45
    ld a, $74                                     ; $4C48
    call Oam_AddMeta_B01_5D47                     ; $4C4A
    ret                                           ; $4C4D


; C: auto: 1 bytes, bytes; referenced by DjEd_DrawNoteStepCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteStepCursor_Tbl4C4E::
    db $77

; C: auto: 113 bytes, bytes; referenced by DjEd_DrawNoteCursorBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjEd_DrawNoteCursorBlink_Tbl4C4F::
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
    ld hl, $9923                                  ; $4CC0
    ld b, $10                                     ; $4CC3

jr_005_4cc5:
    push bc                                       ; $4CC5
    push hl                                       ; $4CC6
    ld a, [de]                                    ; $4CC7
    and a                                         ; $4CC8
    jr z, jr_005_4cdb                             ; $4CC9

    ld a, $cd                                     ; $4CCB
    call Vram_WriteByteSafe                       ; $4CCD
    res 5, l                                      ; $4CD0
    set 6, l                                      ; $4CD2
    ld a, $dd                                     ; $4CD4
    call Vram_WriteByteSafe                       ; $4CD6
    jr jr_005_4ce9                                ; $4CD9

jr_005_4cdb:
    ld a, $cc                                     ; $4CDB
    call Vram_WriteByteSafe                       ; $4CDD
    res 5, l                                      ; $4CE0
    set 6, l                                      ; $4CE2
    ld a, $dc                                     ; $4CE4
    call Vram_WriteByteSafe                       ; $4CE6

jr_005_4ce9:
    pop hl                                        ; $4CE9
    pop bc                                        ; $4CEA
    inc de                                        ; $4CEB
    inc hl                                        ; $4CEC
    dec b                                         ; $4CED
    jr nz, jr_005_4cc5                            ; $4CEE

    ret                                           ; $4CF0


; C
DjEd_DrawNoteRowOffset::
    ld c, a                                       ; $4CF1
    ld b, $00                                     ; $4CF2
    add hl, bc                                    ; $4CF4
    ld a, [hl]                                    ; $4CF5
    and a                                         ; $4CF6
    jr z, jr_005_4d0c                             ; $4CF7

    ld hl, $9923                                  ; $4CF9
    add hl, bc                                    ; $4CFC
    ld a, $cd                                     ; $4CFD
    call Vram_WriteByteSafe                       ; $4CFF
    res 5, l                                      ; $4D02
    set 6, l                                      ; $4D04
    ld a, $dd                                     ; $4D06
    call Vram_WriteByteSafe                       ; $4D08
    ret                                           ; $4D0B


jr_005_4d0c:
    ld hl, $9923                                  ; $4D0C
    add hl, bc                                    ; $4D0F
    ld a, $cc                                     ; $4D10
    call Vram_WriteByteSafe                       ; $4D12
    res 5, l                                      ; $4D15
    set 6, l                                      ; $4D17
    ld a, $dc                                     ; $4D19
    call Vram_WriteByteSafe                       ; $4D1B
    ret                                           ; $4D1E


; C: pop-in cursor for the highlighted field (frame counter D891)
DjEd_DrawFieldCursor::
    push af                                       ; $4D1F
    ld a, [wSndCursorPopFrames]                   ; $4D20
    inc a                                         ; $4D23
    cp $07                                        ; $4D24
    jr c, jr_005_4d2a                             ; $4D26

    ld a, $06                                     ; $4D28

jr_005_4d2a:
    ld [wSndCursorPopFrames], a                   ; $4D2A
    ld e, a                                       ; $4D2D
    ld d, $00                                     ; $4D2E
    ld hl, DjEd_DrawFieldCursor_Tbl4D3B           ; $4D30
    add hl, de                                    ; $4D33
    ld e, [hl]                                    ; $4D34
    pop af                                        ; $4D35
    add e                                         ; $4D36
    call Oam_AddMeta_B01_5D47                     ; $4D37
    ret                                           ; $4D3A


; C: auto: 7 bytes, bytes; referenced by DjEd_DrawFieldCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjEd_DrawFieldCursor_Tbl4D3B::
    db $00, $01, $01, $02, $02, $01, $02

; C: performance state: pose; channel states; NR51 mask; animation slots
DjPerf_Init::
    ld a, $01                                     ; $4D42
    ld [wPerformerPose], a                        ; $4D44
    ld [wPerfChannelState], a                     ; $4D47
    ld [wPerfChannelState + $1], a                ; $4D4A
    ld [wPerfChannelState + $2], a                ; $4D4D
    ld [wPerfStepIncrement], a                    ; $4D50
    ld a, $ff                                     ; $4D53
    ld [wPerfNr51Mask], a                         ; $4D55
    xor a                                         ; $4D58
    ld [wPerformerFrameGroup], a                  ; $4D59
    ld [wPerformerBeatPhase], a                   ; $4D5C
    ld [wPerformerBounceCounter], a               ; $4D5F
    ld [wPerfControlCursor], a                    ; $4D62
    ld [wPerfLevel], a                            ; $4D65
    ld [wPerformerScriptId], a                    ; $4D68
    ld [wPerfPaused], a                           ; $4D6B
    ld [wPerfPausedIcon], a                       ; $4D6E
    ld [wPerfPausedAtStart], a                    ; $4D71
    ld [wSound1VolAtten], a                       ; $4D74
    ld [wSound2VolAtten], a                       ; $4D77
    ld [wNoiseVolAtten], a                        ; $4D7A
    ld a, $dd                                     ; $4D7D
    ld [wPerformerTilesTarget], a                 ; $4D7F
    ld [wPerformerTilesTarget2], a                ; $4D82
    ld [wPerformerTilesShown], a                  ; $4D85
    ld [wPerformerTilesShown2], a                 ; $4D88
    ld a, [wTempo]                                ; $4D8B
    ld [wPerfTempoAtRelease], a                   ; $4D8E
    ld a, [wPerfLevel]                            ; $4D91
    ld [wPerfLevelAtRelease], a                   ; $4D94
    ret                                           ; $4D97


; C: performer; equaliser; speaker and control sprites
DjPerf_Animate::
    call DjPerf_AnimateControlCursor              ; $4D98
    call DjPerf_UpdatePose                        ; $4D9B
    call DjPerf_ScrollPerformer                   ; $4D9E
    call DjPerf_StepBeatPhase                     ; $4DA1
    call DjPerf_BounceOffset                      ; $4DA4
    call DjPerf_PerformerScript                   ; $4DA7
    call DjPerf_UpdatePerformerTiles              ; $4DAA
    call DjPerf_AnimateSpeakerBlink               ; $4DAD
    call DjPerf_Equaliser                         ; $4DB0
    call DjPerf_DrawPlayIcon                      ; $4DB3
    call DjPerf_DrawTempoNeedle                   ; $4DB6
    call DjPerf_DrawSpeakingIcon                  ; $4DB9
    call DjPerf_DrawLevelSlider                   ; $4DBC
    ret                                           ; $4DBF


; C: sprites only
DjPerf_AnimateSprites::
    call DjPerf_AnimateControlCursor              ; $4DC0
    call DjPerf_UpdatePerformerTiles              ; $4DC3
    call DjPerf_AnimateSpeakerBlink               ; $4DC6
    call DjPerf_DrawPlayIcon                      ; $4DC9
    call DjPerf_DrawTempoNeedle                   ; $4DCC
    call DjPerf_DrawSpeakingIcon                  ; $4DCF
    call DjPerf_DrawLevelSlider                   ; $4DD2
    ret                                           ; $4DD5


; C
DjPerf_AnimateControlCursor::
    ld a, [wPerfControlCursor]                    ; $4DD6
    ld c, a                                       ; $4DD9
    ld b, $00                                     ; $4DDA
    ld hl, DjPerf_AnimateControlCursor_Tbl4E20    ; $4DDC
    add hl, bc                                    ; $4DDF
    ld c, [hl]                                    ; $4DE0
    add hl, bc                                    ; $4DE1
    push hl                                       ; $4DE2
    ld c, $00                                     ; $4DE3
    ld a, [wPerfControlCursor]                    ; $4DE5
    cp $01                                        ; $4DE8
    jr z, jr_005_4df6                             ; $4DEA

    cp $02                                        ; $4DEC
    jr z, jr_005_4e01                             ; $4DEE

    cp $03                                        ; $4DF0
    jr z, jr_005_4e0c                             ; $4DF2

    jr jr_005_4e15                                ; $4DF4

jr_005_4df6:
    ld a, [wPerfChannelState]                     ; $4DF6
    and $01                                       ; $4DF9
    jr nz, jr_005_4e15                            ; $4DFB

    ld c, $05                                     ; $4DFD
    jr jr_005_4e15                                ; $4DFF

jr_005_4e01:
    ld a, [wPerfChannelState + $1]                ; $4E01
    and $01                                       ; $4E04
    jr nz, jr_005_4e15                            ; $4E06

    ld c, $05                                     ; $4E08
    jr jr_005_4e15                                ; $4E0A

jr_005_4e0c:
    ld a, [wPerfChannelState + $2]                ; $4E0C
    and $01                                       ; $4E0F
    jr nz, jr_005_4e15                            ; $4E11

    ld c, $05                                     ; $4E13

jr_005_4e15:
    pop hl                                        ; $4E15
    add hl, bc                                    ; $4E16
    ld de, wAnimSlotFrame + $2                    ; $4E17
    ld b, $01                                     ; $4E1A
    call DjPerf_Animator                          ; $4E1C
    ret                                           ; $4E1F


; C: auto: 45 bytes, bytes; referenced by DjPerf_AnimateControlCursor. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_AnimateControlCursor_Tbl4E20::
    db $05, $09, $12, $1b, $24, $0e, $13, $01, $90, $02, $13, $16, $29, $90, $02, $16
    db $19, $21, $90, $02, $13, $16, $49, $90, $02, $16, $19, $41, $90, $02, $13, $16
    db $69, $90, $02, $16, $19, $61, $90, $02, $0e, $13, $91, $90, $02

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_UpdatePose::
    ld a, [wPerformerTilesShown]                  ; $4E4D
    cp $e9                                        ; $4E50
    jr nc, jr_005_4e68                            ; $4E52

    cp $df                                        ; $4E54
    jr c, jr_005_4e62                             ; $4E56

    cp $e3                                        ; $4E58
    jr nc, jr_005_4e62                            ; $4E5A

    ld a, $02                                     ; $4E5C
    ld [wPerformerPose], a                        ; $4E5E
    ret                                           ; $4E61


jr_005_4e62:
    ld a, $01                                     ; $4E62
    ld [wPerformerPose], a                        ; $4E64
    ret                                           ; $4E67


jr_005_4e68:
    ld a, [wTickFlag]                             ; $4E68
    ld hl, wPerformerBeatAcc                      ; $4E6B
    add [hl]                                      ; $4E6E
    and $07                                       ; $4E6F
    ld [hl], a                                    ; $4E71
    srl a                                         ; $4E72
    ld c, a                                       ; $4E74
    ld b, $00                                     ; $4E75
    ld hl, DjPerf_UpdatePose_Tbl4E80              ; $4E77
    add hl, bc                                    ; $4E7A
    ld a, [hl]                                    ; $4E7B
    ld [wPerformerPose], a                        ; $4E7C
    ret                                           ; $4E7F


; C: auto: 4 bytes, bytes; referenced by DjPerf_UpdatePose. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_UpdatePose_Tbl4E80::
    db $00, $01, $02, $01

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_ScrollPerformer::
    ld a, [wPerformerPose]                        ; $4E84
    sla a                                         ; $4E87
    ld c, a                                       ; $4E89
    ld b, $00                                     ; $4E8A
    ld hl, DjPerf_ScrollPerformer_Tbl4E97         ; $4E8C
    add hl, bc                                    ; $4E8F
    ld a, [hl+]                                   ; $4E90
    ldh [hScxBand1], a                            ; $4E91
    ld a, [hl]                                    ; $4E93
    ldh [hScyBand2], a                            ; $4E94
    ret                                           ; $4E96


; C: auto: 6 bytes, bytes; referenced by DjPerf_ScrollPerformer. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_ScrollPerformer_Tbl4E97::
    db $08, $88, $00, $30, $f8, $70

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_StepBeatPhase::
    ld a, [wPerformerPose]                        ; $4E9D
    ld c, a                                       ; $4EA0
    ld b, $00                                     ; $4EA1
    ld hl, DjPerf_StepBeatPhase_Tbl4EF5           ; $4EA3
    add hl, bc                                    ; $4EA6
    ld a, [hl]                                    ; $4EA7
    ld [wPerformerBounceCounter], a               ; $4EA8
    ld a, [wPerformerScriptId]                    ; $4EAB
    cp $08                                        ; $4EAE
    jr nz, jr_005_4eb8                            ; $4EB0

    ld a, $02                                     ; $4EB2
    ld [wPerformerFrameGroup], a                  ; $4EB4
    ret                                           ; $4EB7


jr_005_4eb8:
    ld a, [wPerfChannelState + $2]                ; $4EB8
    and a                                         ; $4EBB
    ret z                                         ; $4EBC

    ld a, [wNoisePlayStep]                        ; $4EBD
    ld c, a                                       ; $4EC0
    ld b, $00                                     ; $4EC1
    ld hl, wNoiseNotes                            ; $4EC3
    add hl, bc                                    ; $4EC6
    ld a, [hl]                                    ; $4EC7
    and a                                         ; $4EC8
    jr z, jr_005_4ed6                             ; $4EC9

jr_005_4ecb:
    cp $06                                        ; $4ECB
    jr c, jr_005_4ed3                             ; $4ECD

    sub $06                                       ; $4ECF
    jr jr_005_4ecb                                ; $4ED1

jr_005_4ed3:
    ld [wPerformerBeatPhase], a                   ; $4ED3

jr_005_4ed6:
    ld a, [wPerformerBeatPhase]                   ; $4ED6
    sla a                                         ; $4ED9
    ld c, a                                       ; $4EDB
    ld a, [wPerformerPose]                        ; $4EDC
    and $01                                       ; $4EDF
    add c                                         ; $4EE1
    ld c, a                                       ; $4EE2
    ld b, $00                                     ; $4EE3
    ld hl, DjPerf_StepBeatPhase_Tbl4EF8           ; $4EE5
    add hl, bc                                    ; $4EE8
    ld a, [hl]                                    ; $4EE9
    ld [wPerformerFrameGroup], a                  ; $4EEA
    ld a, [wPerformerBounceCounter]               ; $4EED
    dec a                                         ; $4EF0
    ld [wPerformerBounceCounter], a               ; $4EF1
    ret                                           ; $4EF4


; C: auto: 3 bytes, bytes; referenced by DjPerf_StepBeatPhase. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_StepBeatPhase_Tbl4EF5::
    db $01, $04, $01

; C: auto: 12 bytes, bytes; referenced by DjPerf_StepBeatPhase. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_StepBeatPhase_Tbl4EF8::
    db $00, $01, $01, $02, $02, $00, $01, $00, $02, $01, $00, $02

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_BounceOffset::
    ld a, [wPerformerFrameGroup]                  ; $4F04
    ld c, a                                       ; $4F07
    ld b, $00                                     ; $4F08
    ld hl, DjPerf_BounceOffset_Tbl4F15            ; $4F0A
    add hl, bc                                    ; $4F0D
    ld a, [wPerformerBounceCounter]               ; $4F0E
    add [hl]                                      ; $4F11
    ldh [hScyBand1], a                            ; $4F12
    ret                                           ; $4F14


; C: auto: 3 bytes, bytes; referenced by DjPerf_BounceOffset. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_BounceOffset_Tbl4F15::
    db $00, $48, $90

; C: runs the performer animation script ids 0..8
DjPerf_PerformerScript::
    xor a                                         ; $4F18
    ld [wPerformerSpeakingIcon], a                ; $4F19
    ld a, [wPerformerScriptId]                    ; $4F1C
    and a                                         ; $4F1F
    jr z, jr_005_4f4b                             ; $4F20

    cp $01                                        ; $4F22
    jp z, DjPerf_PerformerScript_Id1              ; $4F24

    cp $02                                        ; $4F27
    jp z, DjPerf_PerformerScript_Id2              ; $4F29

    cp $03                                        ; $4F2C
    jp z, DjPerf_PerformerScript_Id3              ; $4F2E

    cp $04                                        ; $4F31
    jp z, DjPerf_PerformerScript_Id4              ; $4F33

    cp $05                                        ; $4F36
    jp z, DjPerf_PerformerScript_Id5              ; $4F38

    cp $06                                        ; $4F3B
    jp z, DjPerf_PerformerScript_Id6              ; $4F3D

    cp $07                                        ; $4F40
    jp z, DjPerf_PerformerScript_Id7              ; $4F42

    cp $08                                        ; $4F45
    jp z, DjPerf_PerformerScript_Id8              ; $4F47

    ret                                           ; $4F4A


jr_005_4f4b:
    ld a, [wPerfChannelState + $1]                ; $4F4B
    and a                                         ; $4F4E
    jr z, jr_005_4f5f                             ; $4F4F

    ld a, [wSound2PlayStep]                       ; $4F51
    ld c, a                                       ; $4F54
    ld b, $00                                     ; $4F55
    ld hl, wSound2Notes                           ; $4F57
    add hl, bc                                    ; $4F5A
    ld a, [hl]                                    ; $4F5B
    and a                                         ; $4F5C
    jr nz, jr_005_4f77                            ; $4F5D

jr_005_4f5f:
    ld a, [wPerfChannelState]                     ; $4F5F
    and a                                         ; $4F62
    jr z, jr_005_4f73                             ; $4F63

    ld a, [wSound1PlayStep]                       ; $4F65
    ld c, a                                       ; $4F68
    ld b, $00                                     ; $4F69
    ld hl, wSound1Notes                           ; $4F6B
    add hl, bc                                    ; $4F6E
    ld a, [hl]                                    ; $4F6F
    and a                                         ; $4F70
    jr nz, jr_005_4f77                            ; $4F71

jr_005_4f73:
    ld a, $0c                                     ; $4F73
    jr jr_005_4f80                                ; $4F75

jr_005_4f77:
    dec a                                         ; $4F77

jr_005_4f78:
    cp $0c                                        ; $4F78
    jr c, jr_005_4f80                             ; $4F7A

    sub $0c                                       ; $4F7C
    jr jr_005_4f78                                ; $4F7E

jr_005_4f80:
    ld c, a                                       ; $4F80
    sla a                                         ; $4F81
    add c                                         ; $4F83
    ld hl, wPerformerPose                         ; $4F84
    add [hl]                                      ; $4F87
    sla a                                         ; $4F88
    ld c, a                                       ; $4F8A
    ld b, $00                                     ; $4F8B
    ld hl, DjPerf_PerformerScript_Tbl4F9E         ; $4F8D
    add hl, bc                                    ; $4F90
    ld a, [hl+]                                   ; $4F91
    add $e9                                       ; $4F92
    ld [wPerformerTilesTarget], a                 ; $4F94
    ld a, [hl]                                    ; $4F97
    add $ea                                       ; $4F98
    ld [wPerformerTilesTarget2], a                ; $4F9A
    ret                                           ; $4F9D


; C: auto: 78 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F
; 20)
DjPerf_PerformerScript_Tbl4F9E::
    db $06, $02, $02, $02, $02, $06, $06, $00, $06, $06, $00, $06, $08, $02, $08, $08
    db $02, $08, $04, $0a, $0a, $0a, $0a, $04, $04, $06, $04, $04, $06, $04, $02, $00
    db $00, $00, $00, $02, $04, $02, $04, $04, $02, $04, $0a, $08, $08, $08, $08, $0a
    db $08, $06, $06, $06, $06, $08, $00, $04, $00, $00, $04, $00, $0a, $06, $0a, $0a
    db $0a, $06, $06, $02, $02, $08, $0a, $06, $04, $06, $04, $04, $06, $04

; C: case 1 of the performer script dispatch (script id in $D897 = 1) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id1::
    ld a, [wAnimSlotDone + $3]                    ; $4FEC
    and a                                         ; $4FEF
    jr z, jr_005_4ffa                             ; $4FF0

    xor a                                         ; $4FF2
    ld [wPerformerScriptId], a                    ; $4FF3
    ld [wAnimSlotDone + $3], a                    ; $4FF6
    ret                                           ; $4FF9


jr_005_4ffa:
    ld hl, DjPerf_PerformerScript_Tbl5006         ; $4FFA
    ld de, wAnimSlotFrame + $3                    ; $4FFD
    ld b, $01                                     ; $5000
    call DjPerf_Animator                          ; $5002
    ret                                           ; $5005


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl5006::
    db $19, $1c, $50, $60, $03

; C: case 2 of the performer script dispatch (script id in $D897 = 2) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id2::
    ld a, [wAnimSlotDone + $3]                    ; $500B
    and a                                         ; $500E
    jr z, jr_005_5019                             ; $500F

    xor a                                         ; $5011
    ld [wPerformerScriptId], a                    ; $5012
    ld [wAnimSlotDone + $3], a                    ; $5015
    ret                                           ; $5018


jr_005_5019:
    ld hl, DjPerf_PerformerScript_Tbl5025         ; $5019
    ld de, wAnimSlotFrame + $3                    ; $501C
    ld b, $01                                     ; $501F
    call DjPerf_Animator                          ; $5021
    ret                                           ; $5024


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 3, same layout as the
; scripts BGB ran (Tbl5006, Tbl50D3)
DjPerf_PerformerScript_Tbl5025::
    db $22, $25, $50, $60, $03

; C: case 3 of the performer script dispatch (script id in $D897 = 3) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id3::
    ld a, [wAnimSlotDone + $3]                    ; $502A
    and a                                         ; $502D
    jr z, jr_005_5038                             ; $502E

    xor a                                         ; $5030
    ld [wPerformerScriptId], a                    ; $5031
    ld [wAnimSlotDone + $3], a                    ; $5034
    ret                                           ; $5037


jr_005_5038:
    ld hl, DjPerf_PerformerScript_Tbl5044         ; $5038
    ld de, wAnimSlotFrame + $3                    ; $503B
    ld b, $01                                     ; $503E
    call DjPerf_Animator                          ; $5040
    ret                                           ; $5043


; C: auto: 4 bytes, bytes; referenced by DjPerf_PerformerScript | 5 bytes 22 25 50 60 03 (the last one was cut off by
; a false label at 5048 = `ld bc,$5048` in Ball_DrawPauseText, a sprite position); the code of DjPerf_PerformerScript
; starts at 5049. L3 pass 2026-10-26: no organic run reached it (BGB ...
DjPerf_PerformerScript_Tbl5044::
    db $22, $25, $50, $60, $03

; C: case 4 of the performer script dispatch (script id in $D897 = 4) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id4::
    ld a, [wAnimSlotDone + $3]                    ; $5049
    and a                                         ; $504C
    jr z, jr_005_5057                             ; $504D

    xor a                                         ; $504F
    ld [wPerformerScriptId], a                    ; $5050
    ld [wAnimSlotDone + $3], a                    ; $5053
    ret                                           ; $5056


jr_005_5057:
    ld hl, DjPerf_PerformerScript_Tbl5063         ; $5057
    ld de, wAnimSlotFrame + $3                    ; $505A
    ld b, $01                                     ; $505D
    call DjPerf_Animator                          ; $505F
    ret                                           ; $5062


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 5, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl5063::
    db $22, $25, $50, $60, $03

; C: case 5 of the performer script dispatch (script id in $D897 = 5) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id5::
    ld a, [wAnimSlotDone + $3]                    ; $5068
    and a                                         ; $506B
    jr z, jr_005_5076                             ; $506C

    xor a                                         ; $506E
    ld [wPerformerScriptId], a                    ; $506F
    ld [wAnimSlotDone + $3], a                    ; $5072
    ret                                           ; $5075


jr_005_5076:
    ld hl, DjPerf_PerformerScript_Tbl5082         ; $5076
    ld de, wAnimSlotFrame + $3                    ; $5079
    ld b, $01                                     ; $507C
    call DjPerf_Animator                          ; $507E
    ret                                           ; $5081


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 6, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl5082::
    db $25, $28, $50, $60, $03

; C: case 6 of the performer script dispatch (script id in $D897 = 6): sets $D8B8 = 1 and runs the longer step with
; the $D8A6 counter (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id6::
    ld a, $01                                     ; $5087
    ld [wPerformerSpeakingIcon], a                ; $5089
    ld a, [wAnimSlotFrame + $3]                   ; $508C
    cp $20                                        ; $508F
    jr nc, jr_005_50b9                            ; $5091

    ld a, [wAnimSlotDone + $3]                    ; $5093
    and a                                         ; $5096
    jr z, jr_005_50ad                             ; $5097

    ldh a, [hKeysHeld]                            ; $5099
    bit PADB_A, a                                 ; $509B
    jr nz, jr_005_50ad                            ; $509D

    ld a, $20                                     ; $509F
    ld [wAnimSlotFrame + $3], a                   ; $50A1
    xor a                                         ; $50A4
    ld [wAnimSlotTimer + $3], a                   ; $50A5
    ld [wAnimSlotDone + $3], a                    ; $50A8
    jr jr_005_50b9                                ; $50AB

jr_005_50ad:
    ld hl, DjPerf_PerformerScript_Tbl50D3         ; $50AD
    ld de, wAnimSlotFrame + $3                    ; $50B0
    ld b, $01                                     ; $50B3
    call DjPerf_Animator                          ; $50B5
    ret                                           ; $50B8


jr_005_50b9:
    ld a, [wAnimSlotDone + $3]                    ; $50B9
    and a                                         ; $50BC
    jr z, jr_005_50c7                             ; $50BD

    xor a                                         ; $50BF
    ld [wPerformerScriptId], a                    ; $50C0
    ld [wAnimSlotDone + $3], a                    ; $50C3
    ret                                           ; $50C6


jr_005_50c7:
    ld hl, DjPerf_PerformerScript_Tbl50D8         ; $50C7
    ld de, wAnimSlotFrame + $3                    ; $50CA
    ld b, $01                                     ; $50CD
    call DjPerf_Animator                          ; $50CF
    ret                                           ; $50D2


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl50D3::
    db $1c, $20, $50, $60, $03

; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_PerformerScript_Tbl50D8::
    db $20, $22, $50, $60, $03

; C: case 7 of the performer script dispatch (script id in $D897 = 7) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id7::
    ld a, [wAnimSlotDone + $3]                    ; $50DD
    and a                                         ; $50E0
    jr z, jr_005_50f1                             ; $50E1

    xor a                                         ; $50E3
    ld [wPerformerScriptId], a                    ; $50E4
    ld [wAnimSlotDone + $3], a                    ; $50E7
    ld a, [wPerfPaused]                           ; $50EA
    ld [wPerfPausedIcon], a                       ; $50ED
    ret                                           ; $50F0


jr_005_50f1:
    ld hl, DjPerf_PerformerScript_Tbl50FD         ; $50F1
    ld de, wAnimSlotFrame + $3                    ; $50F4
    ld b, $01                                     ; $50F7
    call DjPerf_Animator                          ; $50F9
    ret                                           ; $50FC


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: frame list of performer script 7, same layout as the
; scripts BGB ran
DjPerf_PerformerScript_Tbl50FD::
    db $28, $2b, $50, $60, $03

; C: case 8 of the performer script dispatch (script id in $D897 = 8) (branch target; code read 2026-10-19)
DjPerf_PerformerScript_Id8::
    ld a, [wAnimSlotDone + $3]                    ; $5102
    and a                                         ; $5105
    jr z, jr_005_5114                             ; $5106

    xor a                                         ; $5108
    ld [wPerformerScriptId], a                    ; $5109
    ld [wAnimSlotDone + $3], a                    ; $510C
    next_state                                    ; $510F
    ret                                           ; $5113


jr_005_5114:
    ld hl, DjPerf_PerformerScript_Tbl5120         ; $5114
    ld de, wAnimSlotFrame + $3                    ; $5117
    ld b, $01                                     ; $511A
    call DjPerf_Animator                          ; $511C
    ret                                           ; $511F


; C: auto: 5 bytes, bytes; referenced by DjPerf_PerformerScript. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_PerformerScript_Tbl5120::
    db $2b, $2e, $50, $60, $03

; C: performer sprite tile change at most every 4 frames
DjPerf_UpdatePerformerTiles::
    ld a, [wPerformerUpdateFrames]                ; $5125
    inc a                                         ; $5128
    ld [wPerformerUpdateFrames], a                ; $5129
    ld hl, wPerformerTilesShown                   ; $512C
    ld a, [wPerformerTilesTarget]                 ; $512F
    cp [hl]                                       ; $5132
    jr z, jr_005_514a                             ; $5133

    ld a, [wPerformerUpdateFrames]                ; $5135
    cp $04                                        ; $5138
    jr c, jr_005_514a                             ; $513A

    ld a, [wPerformerTilesTarget]                 ; $513C
    ld [hl], a                                    ; $513F
    ld a, [wPerformerTilesTarget2]                ; $5140
    ld [wPerformerTilesShown2], a                 ; $5143
    xor a                                         ; $5146
    ld [wPerformerUpdateFrames], a                ; $5147

jr_005_514a:
    ld a, [wPerformerTilesShown]                  ; $514A
    cp $e9                                        ; $514D
    jr nc, jr_005_5161                            ; $514F

    ld a, $50                                     ; $5151
    ld hl, hScxBand1                              ; $5153
    sub [hl]                                      ; $5156
    ld b, a                                       ; $5157
    ld c, $61                                     ; $5158
    ld a, [wPerformerTilesShown]                  ; $515A
    call Oam_AddMeta_B01_5D47                     ; $515D
    ret                                           ; $5160


jr_005_5161:
    ld a, $50                                     ; $5161
    ld hl, hScxBand1                              ; $5163
    sub [hl]                                      ; $5166
    ld b, a                                       ; $5167
    ld c, $81                                     ; $5168
    ld a, [wPerformerTilesShown]                  ; $516A
    call Oam_AddMeta_B01_5D47                     ; $516D
    ld a, [wPerformerTilesShown2]                 ; $5170
    call Oam_AddMeta_B01_5D47                     ; $5173
    ret                                           ; $5176


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_AnimateSpeakerBlink::
    ldh a, [rNR52]                                ; $5177
    bit 0, a                                      ; $5179
    jr z, jr_005_519c                             ; $517B

    ldh a, [rNR12]                                ; $517D
    and $f0                                       ; $517F
    jr z, jr_005_519c                             ; $5181

    ld a, [wAnimSlotFrame]                        ; $5183
    cp $2e                                        ; $5186
    jr nc, jr_005_5190                            ; $5188

    cpl                                           ; $518A
    add $36                                       ; $518B
    ld [wAnimSlotFrame], a                        ; $518D

jr_005_5190:
    ld hl, DjPerf_AnimateSpeakerBlink_Tbl51B5     ; $5190
    ld de, wAnimSlotFrame                         ; $5193
    ld b, $02                                     ; $5196
    call DjPerf_Animator                          ; $5198
    ret                                           ; $519B


jr_005_519c:
    ld a, [wAnimSlotFrame]                        ; $519C
    cp $2e                                        ; $519F
    jr c, jr_005_51a9                             ; $51A1

    cpl                                           ; $51A3
    add $36                                       ; $51A4
    ld [wAnimSlotFrame], a                        ; $51A6

jr_005_51a9:
    ld hl, DjPerf_AnimateSpeakerBlink_Tbl51BF     ; $51A9
    ld de, wAnimSlotFrame                         ; $51AC
    ld b, $02                                     ; $51AF
    call DjPerf_Animator                          ; $51B1
    ret                                           ; $51B4


; C: auto: 10 bytes, bytes; referenced by DjPerf_AnimateSpeakerBlink. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_AnimateSpeakerBlink_Tbl51B5::
    db $2e, $37, $78, $73, $00, $09, $0e, $80, $7a, $01

; C: auto: 10 bytes, bytes; referenced by DjPerf_AnimateSpeakerBlink. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_AnimateSpeakerBlink_Tbl51BF::
    db $00, $09, $78, $73, $00, $09, $0e, $80, $7a, $01

; C: equaliser animation phase built in D000..D013
DjPerf_Equaliser::
    farcopy Mem_CopyFromBank, Src_27_5AB0_DjPerf_Equaliser, wBgRowBuffer, $0014 ; $51C9
    ld a, [wTickFlag]                             ; $51D7
    ld hl, wPerfEqualiserPhase                    ; $51DA
    add [hl]                                      ; $51DD
    and $03                                       ; $51DE
    ld [hl], a                                    ; $51E0
    jr nz, jr_005_51ec                            ; $51E1

    ld hl, DjPerf_Equaliser_PtrTbl5274            ; $51E3
    ld de, wBgRowBuffer                           ; $51E6
    call DjPerf_CopyEqualiserRow                  ; $51E9

jr_005_51ec:
    ld a, [wPerfChannelState]                     ; $51EC
    and a                                         ; $51EF
    jr z, jr_005_5209                             ; $51F0

    ld a, [wSound1PlayStep]                       ; $51F2
    ld c, a                                       ; $51F5
    ld b, $00                                     ; $51F6
    ld hl, wSound1Notes                           ; $51F8
    add hl, bc                                    ; $51FB
    ld a, [hl]                                    ; $51FC
    and a                                         ; $51FD
    jr z, jr_005_5209                             ; $51FE

    ld hl, DjPerf_Equaliser_PtrTbl5278            ; $5200
    ld de, wBgRowBuffer + $4                      ; $5203
    call DjPerf_CopyEqualiserRow                  ; $5206

jr_005_5209:
    ld a, [wPerfChannelState + $1]                ; $5209
    and a                                         ; $520C
    jr z, jr_005_5226                             ; $520D

    ld a, [wSound2PlayStep]                       ; $520F
    ld c, a                                       ; $5212
    ld b, $00                                     ; $5213
    ld hl, wSound2Notes                           ; $5215
    add hl, bc                                    ; $5218
    ld a, [hl]                                    ; $5219
    and a                                         ; $521A
    jr z, jr_005_5226                             ; $521B

    ld hl, DjPerf_Equaliser_Tbl527C               ; $521D
    ld de, wBgRowBuffer + $8                      ; $5220
    call DjPerf_CopyEqualiserRow                  ; $5223

jr_005_5226:
    ld a, [wPerfChannelState + $2]                ; $5226
    and a                                         ; $5229
    jr z, jr_005_5243                             ; $522A

    ld a, [wNoisePlayStep]                        ; $522C
    ld c, a                                       ; $522F
    ld b, $00                                     ; $5230
    ld hl, wNoiseNotes                            ; $5232
    add hl, bc                                    ; $5235
    ld a, [hl]                                    ; $5236
    and a                                         ; $5237
    jr z, jr_005_5243                             ; $5238

    ld hl, DjPerf_Equaliser_Tbl5280               ; $523A
    ld de, wBgRowBuffer + $c                      ; $523D
    call DjPerf_CopyEqualiserRow                  ; $5240

jr_005_5243:
    ldh a, [rNR52]                                ; $5243
    bit 0, a                                      ; $5245
    jr z, jr_005_5258                             ; $5247

    ldh a, [rNR12]                                ; $5249
    and $f0                                       ; $524B
    jr z, jr_005_5258                             ; $524D

    ld hl, DjPerf_Equaliser_Map5284               ; $524F
    ld de, wBgRowBuffer + $10                     ; $5252
    call DjPerf_CopyEqualiserRow                  ; $5255

jr_005_5258:
    ld a, $00                                     ; $5258
    ld hl, wBgRowBuffer                           ; $525A
    ld de, $9ec0                                  ; $525D
    ld bc, $0014                                  ; $5260
    call Vram_CopyFromBank                        ; $5263
    ret                                           ; $5266


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_CopyEqualiserRow::
    ld a, [hl+]                                   ; $5267
    ld [de], a                                    ; $5268
    inc e                                         ; $5269
    ld a, [hl+]                                   ; $526A
    ld [de], a                                    ; $526B
    inc e                                         ; $526C
    ld a, [hl+]                                   ; $526D
    ld [de], a                                    ; $526E
    inc e                                         ; $526F
    ld a, [hl+]                                   ; $5270
    ld [de], a                                    ; $5271
    inc e                                         ; $5272
    ret                                           ; $5273


; C: auto: 4 bytes, word table; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjPerf_Equaliser_PtrTbl5274::
    dw $4140
    dw $4342

; C: auto: 4 bytes, word table; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_PtrTbl5278::
    dw $5150
    dw $5352

; C: auto: 4 bytes, bytes; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Tbl527C::
    db $50, $51, $52, $20

; C: auto: 4 bytes, bytes; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios dj_editor
; 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Tbl5280::
    db $1c, $1d, $24, $2d

; C: auto: 4 bytes, tile map; referenced by DjPerf_Equaliser. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_editor 1F:05, dj_editor_sound2 1F:05, dj_perf_start 1F:05, dj_perf_start_noise 1F:05
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPerf_Equaliser_Map5284::
    db $14, $15, $6e, $6e

; C
DjPerf_DrawPlayIcon::
    ld a, [wPerfPausedIcon]                       ; $5288
    and a                                         ; $528B
    jr nz, jr_005_5297                            ; $528C

    ld bc, $3d81                                  ; $528E
    ld a, $d1                                     ; $5291
    call Oam_AddMeta_B01_5D47                     ; $5293
    ret                                           ; $5296


jr_005_5297:
    ld bc, $3f78                                  ; $5297
    ld a, $d1                                     ; $529A
    call Oam_AddMeta_B01_5D47                     ; $529C
    ret                                           ; $529F


; C
DjPerf_DrawTempoNeedle::
    ld a, [wPerfTempoAtRelease]                   ; $52A0
    sub $3c                                       ; $52A3
    ld l, $e3                                     ; $52A5
    call Math_MulAL                               ; $52A7
    ld bc, $0080                                  ; $52AA
    add hl, bc                                    ; $52AD
    ld a, h                                       ; $52AE
    swap a                                        ; $52AF
    and $0f                                       ; $52B1
    add $76                                       ; $52B3
    push af                                       ; $52B5
    ld a, [wPerfTempoAtRelease]                   ; $52B6
    sub $3c                                       ; $52B9
    ld l, $5b                                     ; $52BB
    call Math_MulAL                               ; $52BD
    ld bc, $0080                                  ; $52C0
    add hl, bc                                    ; $52C3
    ld a, h                                       ; $52C4
    swap a                                        ; $52C5
    and $0f                                       ; $52C7
    cpl                                           ; $52C9
    add $2d                                       ; $52CA
    ld b, a                                       ; $52CC
    pop af                                        ; $52CD
    ld c, a                                       ; $52CE
    ld a, $d1                                     ; $52CF
    call Oam_AddMeta_B01_5D47                     ; $52D1
    ret                                           ; $52D4


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_DrawSpeakingIcon::
    ld a, [wPerformerSpeakingIcon]                ; $52D5
    and a                                         ; $52D8
    jr nz, jr_005_52e4                            ; $52D9

    ld bc, $4871                                  ; $52DB
    ld a, $d2                                     ; $52DE
    call Oam_AddMeta_B01_5D47                     ; $52E0
    ret                                           ; $52E3


jr_005_52e4:
    ld bc, $5471                                  ; $52E4
    ld a, $d2                                     ; $52E7
    call Oam_AddMeta_B01_5D47                     ; $52E9
    ret                                           ; $52EC


; C
DjPerf_DrawLevelSlider::
    ld a, [wPerfLevelAtRelease]                   ; $52ED
    add $78                                       ; $52F0
    ld c, a                                       ; $52F2
    ld b, $57                                     ; $52F3
    ld a, $d1                                     ; $52F5
    call Oam_AddMeta_B01_5D47                     ; $52F7
    ret                                           ; $52FA


; C: animation slot stepper
DjPerf_Animator::
    push bc                                       ; $52FB
    push de                                       ; $52FC
    ld a, [de]                                    ; $52FD
    cp [hl]                                       ; $52FE
    jr c, jr_005_5306                             ; $52FF

    inc hl                                        ; $5301
    cp [hl]                                       ; $5302
    jr c, jr_005_5309                             ; $5303

    dec hl                                        ; $5305

jr_005_5306:
    ld a, [hl]                                    ; $5306
    ld [de], a                                    ; $5307
    inc hl                                        ; $5308

jr_005_5309:
    inc hl                                        ; $5309
    ld a, e                                       ; $530A
    add $04                                       ; $530B
    ld e, a                                       ; $530D
    jr nc, jr_005_5311                            ; $530E

    inc d                                         ; $5310

jr_005_5311:
    ld a, [hl+]                                   ; $5311
    ld [de], a                                    ; $5312
    ld a, e                                       ; $5313
    add $04                                       ; $5314
    ld e, a                                       ; $5316
    jr nc, jr_005_531a                            ; $5317

    inc d                                         ; $5319

jr_005_531a:
    ld a, [hl+]                                   ; $531A
    ld [de], a                                    ; $531B
    push hl                                       ; $531C
    ld e, [hl]                                    ; $531D
    call DjPerf_AnimatorDraw                      ; $531E
    pop hl                                        ; $5321
    pop de                                        ; $5322
    pop bc                                        ; $5323
    inc hl                                        ; $5324
    inc de                                        ; $5325
    dec b                                         ; $5326
    jr nz, DjPerf_Animator                        ; $5327

    ret                                           ; $5329


; C: draws one animation slot
DjPerf_AnimatorDraw::
    ld d, $00                                     ; $532A
    ld hl, wAnimSlotDone                          ; $532C
    add hl, de                                    ; $532F
    ld [hl], $00                                  ; $5330
    ld hl, wAnimSlotFrame                         ; $5332
    add hl, de                                    ; $5335
    ld a, [hl]                                    ; $5336
    sla a                                         ; $5337
    ld c, a                                       ; $5339
    ld b, $00                                     ; $533A
    ld hl, DjPerf_AnimatorDraw_Tbl5381            ; $533C
    add hl, bc                                    ; $533F
    ld a, [hl+]                                   ; $5340
    push hl                                       ; $5341
    ld hl, wAnimSlotX                             ; $5342
    add hl, de                                    ; $5345
    ld b, [hl]                                    ; $5346
    ld hl, wAnimSlotY                             ; $5347
    add hl, de                                    ; $534A
    ld c, [hl]                                    ; $534B
    cp $dd                                        ; $534C
    jr nc, jr_005_5355                            ; $534E

    call Oam_AddMeta_B01_5D47                     ; $5350
    jr jr_005_5358                                ; $5353

jr_005_5355:
    ld [wPerformerTilesTarget], a                 ; $5355

jr_005_5358:
    ld hl, wAnimSlotTimer                         ; $5358
    add hl, de                                    ; $535B
    ld a, [hl]                                    ; $535C
    pop hl                                        ; $535D
    cp [hl]                                       ; $535E
    jr c, jr_005_537a                             ; $535F

    inc hl                                        ; $5361
    ld a, [hl+]                                   ; $5362
    cp $ff                                        ; $5363
    ld a, [hl]                                    ; $5365
    ld hl, wAnimSlotFrame                         ; $5366
    add hl, de                                    ; $5369
    jr z, jr_005_5372                             ; $536A

    ld a, [hl]                                    ; $536C
    inc a                                         ; $536D
    ld [hl], a                                    ; $536E
    xor a                                         ; $536F
    jr jr_005_537a                                ; $5370

jr_005_5372:
    ld [hl], a                                    ; $5372
    ld hl, wAnimSlotDone                          ; $5373
    add hl, de                                    ; $5376
    ld [hl], $01                                  ; $5377
    xor a                                         ; $5379

jr_005_537a:
    inc a                                         ; $537A
    ld hl, wAnimSlotTimer                         ; $537B
    add hl, de                                    ; $537E
    ld [hl], a                                    ; $537F
    ret                                           ; $5380


; C: auto: 110 bytes, bytes; referenced by DjPerf_AnimatorDraw. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F
; 20)
DjPerf_AnimatorDraw_Tbl5381::
    db $c9, $0a, $ca, $08, $cb, $08, $cc, $0a, $cd, $0a, $ce, $08, $cf, $08, $d0, $0a
    db $ff, $00, $d3, $0a, $d4, $08, $d3, $08, $d4, $0a, $ff, $09, $da, $0a, $db, $0a
    db $da, $0a, $dc, $0a, $ff, $0e, $da, $0a, $db, $0a, $ff, $13, $da, $0a, $dc, $0a
    db $ff, $16, $dd, $08, $de, $08, $ff, $1a, $df, $05, $e0, $04, $e1, $07, $ff, $1d
    db $e2, $04, $ff, $20, $e3, $08, $e4, $08, $ff, $23, $e3, $08, $e5, $08, $ff, $26
    db $e3, $08, $e6, $08, $ff, $29, $e7, $0b, $e8, $0b, $ff, $2c, $d0, $0a, $cf, $08
    db $ce, $08, $cd, $0a, $cc, $0a, $cb, $08, $ca, $08, $c9, $0a, $ff, $2e

; C: performance screen control: tempo / channels / level; Start; A; B; Left / Right pitch
DjPerf_Input::
    ld a, $01                                     ; $53EF
    ld [wPerfStepIncrement], a                    ; $53F1
    ldh a, [hKeysHeld]                            ; $53F4
    bit PADB_RIGHT, a                             ; $53F6
    jr nz, jr_005_540b                            ; $53F8

    ld a, [wPerfPitchShift]                       ; $53FA
    and a                                         ; $53FD
    jr z, jr_005_540b                             ; $53FE

    bit 7, a                                      ; $5400
    jr nz, jr_005_5407                            ; $5402

    dec a                                         ; $5404
    jr jr_005_5408                                ; $5405

jr_005_5407:
    inc a                                         ; $5407

jr_005_5408:
    ld [wPerfPitchShift], a                       ; $5408

jr_005_540b:
    ldh a, [hKeysHeld]                            ; $540B
    and PADF_RIGHT | PADF_LEFT                    ; $540D
    jr z, jr_005_5477                             ; $540F

    ld a, [wPerfControlCursor]                    ; $5411
    and a                                         ; $5414
    jr nz, jr_005_5423                            ; $5415

    ldh a, [hKeysHeld]                            ; $5417
    bit PADB_LEFT, a                              ; $5419
    jr z, jr_005_5423                             ; $541B

    ld a, $ff                                     ; $541D
    ld [wPerfStepIncrement], a                    ; $541F
    ret                                           ; $5422


jr_005_5423:
    ld a, [wPerfControlCursor]                    ; $5423
    cp $04                                        ; $5426
    jr nz, jr_005_5467                            ; $5428

    ldh a, [hKeysHeld]                            ; $542A
    bit PADB_UP, a                                ; $542C
    jr nz, jr_005_5445                            ; $542E

    bit PADB_DOWN, a                              ; $5430
    jr nz, jr_005_5456                            ; $5432

    ldh a, [hKeysNew]                             ; $5434
    bit PADB_RIGHT, a                             ; $5436
    jr z, jr_005_5467                             ; $5438

    xor a                                         ; $543A
    ld [wSound1PlayStep], a                       ; $543B
    ld [wSound2PlayStep], a                       ; $543E
    ld [wNoisePlayStep], a                        ; $5441
    ret                                           ; $5444


jr_005_5445:
    ldh a, [hKeysHeld]                            ; $5445
    bit PADB_RIGHT, a                             ; $5447
    jr z, jr_005_5467                             ; $5449

    ld a, [wPerfPitchShift]                       ; $544B
    inc a                                         ; $544E
    cp $0c                                        ; $544F
    ret z                                         ; $5451

    ld [wPerfPitchShift], a                       ; $5452
    ret                                           ; $5455


jr_005_5456:
    ldh a, [hKeysHeld]                            ; $5456
    bit PADB_RIGHT, a                             ; $5458
    jr z, jr_005_5467                             ; $545A

    ld a, [wPerfPitchShift]                       ; $545C
    dec a                                         ; $545F
    cp $f4                                        ; $5460
    ret z                                         ; $5462

    ld [wPerfPitchShift], a                       ; $5463
    ret                                           ; $5466


jr_005_5467:
    ld a, [wPerfControlCursor]                    ; $5467
    ld bc, $0004                                  ; $546A
    call DjEd_StepLeftRight                       ; $546D
    ld hl, wPerfControlCursor                     ; $5470
    cp [hl]                                       ; $5473
    ret z                                         ; $5474

    ld [hl], a                                    ; $5475
    ret                                           ; $5476


jr_005_5477:
    ldh a, [hKeysNew]                             ; $5477
    bit PADB_A, a                                 ; $5479
    jr z, jr_005_549f                             ; $547B

    ld a, [wPerfLevel]                            ; $547D
    ld hl, DjPerf_Input_Tbl554D                   ; $5480
    call Snd_PlayFromList                         ; $5483
    ld a, $01                                     ; $5486
    ld [wPerformerSpeakingIcon], a                ; $5488
    ld a, [wPerformerScriptId]                    ; $548B
    and a                                         ; $548E
    ret nz                                        ; $548F

    ld a, $06                                     ; $5490
    ld [wPerformerScriptId], a                    ; $5492
    ld a, $1c                                     ; $5495
    ld [wAnimSlotFrame + $3], a                   ; $5497
    xor a                                         ; $549A
    ld [wAnimSlotTimer + $3], a                   ; $549B
    ret                                           ; $549E


jr_005_549f:
    ldh a, [hKeysNew]                             ; $549F
    bit PADB_START, a                             ; $54A1
    jr z, jr_005_54db                             ; $54A3

    push af                                       ; $54A5
    ld a, $04                                     ; $54A6
    ld [wUiSfxRequest], a                         ; $54A8
    pop af                                        ; $54AB
    xor a                                         ; $54AC
    ld [wPerfStartHold], a                        ; $54AD
    ld a, [wPerfPaused]                           ; $54B0
    ld [wPerfPausedAtStart], a                    ; $54B3
    ld a, $01                                     ; $54B6
    ld [wPerfPaused], a                           ; $54B8
    call DjPerf_NR51MaskAll                       ; $54BB
    call DjPerf_DrawChannel1State                 ; $54BE
    call DjPerf_DrawChannel2State                 ; $54C1
    call DjPerf_DrawChannel3State                 ; $54C4
    ld a, [wPerformerScriptId]                    ; $54C7
    and a                                         ; $54CA
    ret nz                                        ; $54CB

    ld a, $07                                     ; $54CC
    ld [wPerformerScriptId], a                    ; $54CE
    ld a, $28                                     ; $54D1
    ld [wAnimSlotFrame + $3], a                   ; $54D3
    xor a                                         ; $54D6
    ld [wAnimSlotTimer + $3], a                   ; $54D7
    ret                                           ; $54DA


jr_005_54db:
    ldh a, [hKeysHeld]                            ; $54DB
    bit PADB_START, a                             ; $54DD
    jr z, jr_005_54e7                             ; $54DF

    ld hl, wPerfStartHold                         ; $54E1
    inc [hl]                                      ; $54E4
    jr jr_005_5535                                ; $54E5

jr_005_54e7:
    ldh a, [hKeysReleased]                        ; $54E7
    bit PADB_START, a                             ; $54E9
    jr z, jr_005_5520                             ; $54EB

    ld a, [wPerfPausedAtStart]                    ; $54ED
    and a                                         ; $54F0
    jr nz, jr_005_5505                            ; $54F1

    ld a, [wPerfStartHold]                        ; $54F3
    cp $1e                                        ; $54F6
    jr nc, jr_005_5505                            ; $54F8

    xor a                                         ; $54FA
    ld [wSound1PlayStep], a                       ; $54FB
    ld [wSound2PlayStep], a                       ; $54FE
    ld [wNoisePlayStep], a                        ; $5501
    ret                                           ; $5504


jr_005_5505:
    xor a                                         ; $5505
    ld [wPerfPaused], a                           ; $5506
    call DjPerf_NR51MaskFromChannels              ; $5509
    ld a, [wPerformerScriptId]                    ; $550C
    and a                                         ; $550F
    ret nz                                        ; $5510

    ld a, $07                                     ; $5511
    ld [wPerformerScriptId], a                    ; $5513
    ld a, $28                                     ; $5516
    ld [wAnimSlotFrame + $3], a                   ; $5518
    xor a                                         ; $551B
    ld [wAnimSlotTimer + $3], a                   ; $551C
    ret                                           ; $551F


jr_005_5520:
    ldh a, [hKeysNew]                             ; $5520
    bit PADB_B, a                                 ; $5522
    jr z, jr_005_5535                             ; $5524

    ld a, $08                                     ; $5526
    ld [wPerformerScriptId], a                    ; $5528
    ld a, $2b                                     ; $552B
    ld [wAnimSlotFrame + $3], a                   ; $552D
    xor a                                         ; $5530
    ld [wAnimSlotTimer + $3], a                   ; $5531
    ret                                           ; $5534


jr_005_5535:
    ld a, [wPerfControlCursor]                    ; $5535
    and a                                         ; $5538
    jr z, jr_005_555f                             ; $5539

    cp $01                                        ; $553B
    jp z, DjPerf_Input_Channel1Keys               ; $553D

    cp $02                                        ; $5540
    jp z, DjPerf_Input_Channel2Keys               ; $5542

    cp $03                                        ; $5545
    jp z, DjPerf_Input_Channel3Keys               ; $5547

    jp DjPerf_Input_LevelKeys                     ; $554A


; C: auto: 18 bytes, bytes; referenced by DjPerf_Input. L3 pass 2026-10-26: not reached by the 206 BGB replays; read
; in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F 20)
DjPerf_Input_Tbl554D::
    db SFX1_DJ_PERFORM_SE_1, SNDCH_SFX1  ; #1
    db SFX1_DJ_PERFORM_SE_2, SNDCH_SFX1  ; #2
    db SFX1_DJ_PERFORM_SE_3, SNDCH_SFX1  ; #3
    db SFX1_DJ_PERFORM_SE_4, SNDCH_SFX1  ; #4
    db SFX1_RUN_CELEBRATION, SNDCH_SFX1  ; #5
    db SFX1_DJ_PERFORM_SE_6, SNDCH_SFX1  ; #6
    db SFX1_DJ_PERFORM_SE_7, SNDCH_SFX1  ; #7
    db SFX1_DJ_PERFORM_SE_8, SNDCH_SFX1  ; #8
    db SFX1_DJ_PERFORM_SE_9, SNDCH_SFX1  ; #9

jr_005_555f:
    ldh a, [hKeysNewRepeat]                       ; $555F
    and PADF_UP | PADF_DOWN                       ; $5561
    jr z, jr_005_557c                             ; $5563

    ld a, [wTempo]                                ; $5565
    ld bc, $0ff0                                  ; $5568
    call DjEd_StepDownUp                          ; $556B
    ld hl, wTempo                                 ; $556E
    cp [hl]                                       ; $5571
    ret z                                         ; $5572

    ld [hl], a                                    ; $5573
    call DjPerf_DrawTempo                         ; $5574
    ld hl, wDirtyFlag                             ; $5577
    inc [hl]                                      ; $557A
    ret                                           ; $557B


jr_005_557c:
    ldh a, [hKeysReleased]                        ; $557C
    and PADF_UP | PADF_DOWN                       ; $557E
    ret z                                         ; $5580

    ld a, [wTempo]                                ; $5581
    ld hl, wPerfTempoAtRelease                    ; $5584
    cp [hl]                                       ; $5587
    ret z                                         ; $5588

    ld [hl], a                                    ; $5589
    ld a, [wPerformerScriptId]                    ; $558A
    and a                                         ; $558D
    ret nz                                        ; $558E

    ld a, $01                                     ; $558F
    ld [wPerformerScriptId], a                    ; $5591
    ld a, $19                                     ; $5594
    ld [wAnimSlotFrame + $3], a                   ; $5596
    xor a                                         ; $5599
    ld [wAnimSlotTimer + $3], a                   ; $559A
    ret                                           ; $559D


; C: selector $D8B3 = 1: Up / Down held ($FFA3 and $C0) step channel 1 ($D8B4) and redraw its state; restarts the
; performer script when idle (branch target; code read 2026-10-19)
DjPerf_Input_Channel1Keys::
    ldh a, [hKeysNewRepeat]                       ; $559E
    and PADF_UP | PADF_DOWN                       ; $55A0
    ret z                                         ; $55A2

    ld a, [wPerfChannelState]                     ; $55A3
    call DjPerf_ChannelToggleKeys                 ; $55A6
    ld hl, wPerfChannelState                      ; $55A9
    cp [hl]                                       ; $55AC
    ret z                                         ; $55AD

    ld [hl], a                                    ; $55AE
    call DjPerf_DrawChannel1State                 ; $55AF
    ld a, [wPerformerScriptId]                    ; $55B2
    and a                                         ; $55B5
    ret nz                                        ; $55B6

    ld a, $02                                     ; $55B7
    ld [wPerformerScriptId], a                    ; $55B9
    ld a, $22                                     ; $55BC
    ld [wAnimSlotFrame + $3], a                   ; $55BE
    xor a                                         ; $55C1
    ld [wAnimSlotTimer + $3], a                   ; $55C2
    ret                                           ; $55C5


; C: selector $D8B3 = 2: Up / Down step channel 2 ($D8B5) (branch target; code read 2026-10-19)
DjPerf_Input_Channel2Keys::
    ldh a, [hKeysNewRepeat]                       ; $55C6
    and PADF_UP | PADF_DOWN                       ; $55C8
    ret z                                         ; $55CA

    ld a, [wPerfChannelState + $1]                ; $55CB
    call DjPerf_ChannelToggleKeys                 ; $55CE
    ld hl, wPerfChannelState + $1                 ; $55D1
    cp [hl]                                       ; $55D4
    ret z                                         ; $55D5

    ld [hl], a                                    ; $55D6
    call DjPerf_DrawChannel2State                 ; $55D7
    ld a, [wPerformerScriptId]                    ; $55DA
    and a                                         ; $55DD
    ret nz                                        ; $55DE

    ld a, $03                                     ; $55DF
    ld [wPerformerScriptId], a                    ; $55E1
    ld a, $22                                     ; $55E4
    ld [wAnimSlotFrame + $3], a                   ; $55E6
    xor a                                         ; $55E9
    ld [wAnimSlotTimer + $3], a                   ; $55EA
    ret                                           ; $55ED


; C: selector $D8B3 = 3: Up / Down step channel 3 ($D8B6) (branch target; code read 2026-10-19)
DjPerf_Input_Channel3Keys::
    ldh a, [hKeysNewRepeat]                       ; $55EE
    and PADF_UP | PADF_DOWN                       ; $55F0
    ret z                                         ; $55F2

    ld a, [wPerfChannelState + $2]                ; $55F3
    call DjPerf_ChannelToggleKeys                 ; $55F6
    ld hl, wPerfChannelState + $2                 ; $55F9
    cp [hl]                                       ; $55FC
    ret z                                         ; $55FD

    ld [hl], a                                    ; $55FE
    call DjPerf_DrawChannel3State                 ; $55FF
    ld a, [wPerformerScriptId]                    ; $5602
    and a                                         ; $5605
    ret nz                                        ; $5606

    ld a, $04                                     ; $5607
    ld [wPerformerScriptId], a                    ; $5609
    ld a, $22                                     ; $560C
    ld [wAnimSlotFrame + $3], a                   ; $560E
    xor a                                         ; $5611
    ld [wAnimSlotTimer + $3], a                   ; $5612
    ret                                           ; $5615


; C: any other selector value: Up / Down step the level $D8B7 (DjEd_StepDownUp, 8 steps) and redraw the level digit
; (branch target; code read 2026-10-19)
DjPerf_Input_LevelKeys::
    ldh a, [hKeysNewRepeat]                       ; $5616
    and PADF_UP | PADF_DOWN                       ; $5618
    jr z, jr_005_562f                             ; $561A

    ld a, [wPerfLevel]                            ; $561C
    ld bc, $0008                                  ; $561F
    call DjEd_StepDownUp                          ; $5622
    ld hl, wPerfLevel                             ; $5625
    cp [hl]                                       ; $5628
    ret z                                         ; $5629

    ld [hl], a                                    ; $562A
    call DjPerf_DrawLevelDigit                    ; $562B
    ret                                           ; $562E


jr_005_562f:
    ldh a, [hKeysReleased]                        ; $562F
    and PADF_UP | PADF_DOWN                       ; $5631
    ret z                                         ; $5633

    ld a, [wPerfLevel]                            ; $5634
    ld hl, wPerfLevelAtRelease                    ; $5637
    cp [hl]                                       ; $563A
    ret z                                         ; $563B

    ld [hl], a                                    ; $563C
    ld a, [wPerformerScriptId]                    ; $563D
    and a                                         ; $5640
    ret nz                                        ; $5641

    ld a, $05                                     ; $5642
    ld [wPerformerScriptId], a                    ; $5644
    ld a, $25                                     ; $5647
    ld [wAnimSlotFrame + $3], a                   ; $5649
    xor a                                         ; $564C
    ld [wAnimSlotTimer + $3], a                   ; $564D
    ret                                           ; $5650


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; Up / Down step the channel state 0-3 on the performance screen (paused: A / B shortcuts to 3 / 2)
DjPerf_ChannelToggleKeys::
    ld hl, wPerfPaused                            ; $5651
    bit 0, [hl]                                   ; $5654
    ld hl, hKeysNew                               ; $5656
    jr nz, jr_005_565f                            ; $5659

    bit 1, a                                      ; $565B
    jr nz, jr_005_566e                            ; $565D

jr_005_565f:
    bit 6, [hl]                                   ; $565F
    jr z, jr_005_5667                             ; $5661

    dec a                                         ; $5663
    and $03                                       ; $5664
    ret                                           ; $5666


jr_005_5667:
    bit 7, [hl]                                   ; $5667
    ret z                                         ; $5669

    inc a                                         ; $566A
    and $03                                       ; $566B
    ret                                           ; $566D


jr_005_566e:
    bit 6, [hl]                                   ; $566E
    jr z, jr_005_5675                             ; $5670

    ld a, $03                                     ; $5672
    ret                                           ; $5674


jr_005_5675:
    bit 7, [hl]                                   ; $5675
    ret z                                         ; $5677

    ld a, $02                                     ; $5678
    ret                                           ; $567A


; C: fades the three channels in and out on each tick
DjPerf_ChannelFade::
    ld a, [wTickFlag]                             ; $567B
    and a                                         ; $567E
    ret z                                         ; $567F

    ld c, $22                                     ; $5680
    ld hl, wSound1VolAtten                        ; $5682
    ld de, wPerfChannelState                      ; $5685
    call DjPerf_ChannelStep                       ; $5688
    ld c, $44                                     ; $568B
    ld hl, wSound2VolAtten                        ; $568D
    ld de, wPerfChannelState + $1                 ; $5690
    call DjPerf_ChannelStep                       ; $5693
    ld c, $88                                     ; $5696
    ld hl, wNoiseVolAtten                         ; $5698
    ld de, wPerfChannelState + $2                 ; $569B
    call DjPerf_ChannelStep                       ; $569E
    call DjSnd_BuildWaveStaging                   ; $56A1
    call DjPerf_DrawChannel1State                 ; $56A4
    call DjPerf_DrawChannel2State                 ; $56A7
    call DjPerf_DrawChannel3State                 ; $56AA
    ret                                           ; $56AD


; C: one channel state machine (0 off .. 3 fading in)
DjPerf_ChannelStep::
    ld a, [de]                                    ; $56AE
    and a                                         ; $56AF
    jr nz, jr_005_56c0                            ; $56B0

    ld a, c                                       ; $56B2
    cpl                                           ; $56B3
    ld c, a                                       ; $56B4
    ld a, [wPerfNr51Mask]                         ; $56B5
    and c                                         ; $56B8
    ld [wPerfNr51Mask], a                         ; $56B9
    ld a, $0f                                     ; $56BC
    ld [hl], a                                    ; $56BE
    ret                                           ; $56BF


jr_005_56c0:
    push af                                       ; $56C0
    ld a, [wPerfNr51Mask]                         ; $56C1
    or c                                          ; $56C4
    ld [wPerfNr51Mask], a                         ; $56C5
    pop af                                        ; $56C8
    cp $01                                        ; $56C9
    jr nz, jr_005_56d0                            ; $56CB

    xor a                                         ; $56CD
    ld [hl], a                                    ; $56CE
    ret                                           ; $56CF


jr_005_56d0:
    cp $02                                        ; $56D0
    jr nz, jr_005_56e9                            ; $56D2

    ld a, [hl]                                    ; $56D4
    cp $0f                                        ; $56D5
    jr z, jr_005_56dc                             ; $56D7

    inc a                                         ; $56D9
    ld [hl], a                                    ; $56DA
    ret                                           ; $56DB


jr_005_56dc:
    ld a, c                                       ; $56DC
    cpl                                           ; $56DD
    ld c, a                                       ; $56DE
    ld a, [wPerfNr51Mask]                         ; $56DF
    and c                                         ; $56E2
    ld [wPerfNr51Mask], a                         ; $56E3
    xor a                                         ; $56E6
    ld [de], a                                    ; $56E7
    ret                                           ; $56E8


jr_005_56e9:
    ld a, [hl]                                    ; $56E9
    and a                                         ; $56EA
    jr z, jr_005_56f0                             ; $56EB

    dec a                                         ; $56ED
    ld [hl], a                                    ; $56EE
    ret                                           ; $56EF


jr_005_56f0:
    ld a, $01                                     ; $56F0
    ld [de], a                                    ; $56F2
    ret                                           ; $56F3


; C: tempo digits to VRAM
DjPerf_DrawTempo::
    ld a, [wTempo]                                ; $56F4
    ld bc, $0000                                  ; $56F7

jr_005_56fa:
    cp $64                                        ; $56FA
    jr c, jr_005_5703                             ; $56FC

    sub $64                                       ; $56FE
    inc b                                         ; $5700
    jr jr_005_56fa                                ; $5701

jr_005_5703:
    cp $0a                                        ; $5703
    jr c, jr_005_570c                             ; $5705

    sub $0a                                       ; $5707
    inc c                                         ; $5709
    jr jr_005_5703                                ; $570A

jr_005_570c:
    push bc                                       ; $570C
    swap a                                        ; $570D
    ld c, a                                       ; $570F
    ld b, $00                                     ; $5710
    ld hl, $4d60                                  ; $5712
    add hl, bc                                    ; $5715
    ld a, $1a                                     ; $5716
    ld de, $8720                                  ; $5718
    ld bc, $0010                                  ; $571B
    call Vram_CopyFromBank                        ; $571E
    pop bc                                        ; $5721
    push bc                                       ; $5722
    swap c                                        ; $5723
    ld b, $00                                     ; $5725
    ld hl, $4d60                                  ; $5727
    add hl, bc                                    ; $572A
    ld a, $1a                                     ; $572B
    ld de, $8710                                  ; $572D
    ld bc, $0010                                  ; $5730
    call Vram_CopyFromBank                        ; $5733
    pop bc                                        ; $5736
    swap b                                        ; $5737
    ld c, b                                       ; $5739
    ld b, $00                                     ; $573A
    ld hl, $4d60                                  ; $573C
    add hl, bc                                    ; $573F
    ld a, $1a                                     ; $5740
    ld de, $8700                                  ; $5742
    ld bc, $0010                                  ; $5745
    call Vram_CopyFromBank                        ; $5748
    ret                                           ; $574B


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_ToggleBlink::
    ldh [hScratchA], a                            ; $574C
    cp $02                                        ; $574E
    jr c, jr_005_575f                             ; $5750

    ld a, [hl]                                    ; $5752
    cpl                                           ; $5753
    ld [hl], a                                    ; $5754
    and $01                                       ; $5755
    jr z, jr_005_575d                             ; $5757

    ldh a, [hScratchA]                            ; $5759
    jr jr_005_575f                                ; $575B

jr_005_575d:
    ld a, $04                                     ; $575D

jr_005_575f:
    ld e, a                                       ; $575F
    sla a                                         ; $5760
    add e                                         ; $5762
    ld de, DjPerf_ToggleBlink_Tbl576B             ; $5763
    add e                                         ; $5766
    ld e, a                                       ; $5767
    ret nc                                        ; $5768

    inc d                                         ; $5769
    ret                                           ; $576A


; C: auto: 15 bytes, bytes; referenced by DjPerf_ToggleBlink. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjPerf_ToggleBlink_Tbl576B::
    db $7a, $7c, $7c, $7e, $7a, $7b, $75, $76, $77, $7e, $78, $79, $7e, $7e, $7e

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjPerf_Write2Tiles::
    ld a, [de]                                    ; $577A
    call Vram_WriteByteSafe                       ; $577B
    inc de                                        ; $577E
    inc hl                                        ; $577F
    ld a, [de]                                    ; $5780
    call Vram_WriteByteSafe                       ; $5781
    inc de                                        ; $5784
    inc hl                                        ; $5785
    ld a, [de]                                    ; $5786
    call Vram_WriteByteSafe                       ; $5787
    ret                                           ; $578A


; C: indicator tiles of SOUND I
DjPerf_DrawChannel1State::
    ld a, [wPerfChannelState]                     ; $578B
    and a                                         ; $578E
    jr nz, jr_005_5795                            ; $578F

    ld a, $c9                                     ; $5791
    jr jr_005_5797                                ; $5793

jr_005_5795:
    ld a, $ca                                     ; $5795

jr_005_5797:
    ld hl, $9ea9                                  ; $5797
    call Vram_WriteByteSafe                       ; $579A
    ld a, [wPerfPaused]                           ; $579D
    and a                                         ; $57A0
    jr z, jr_005_57a7                             ; $57A1

    xor a                                         ; $57A3
    ld [wPerfChannelBlink], a                     ; $57A4

jr_005_57a7:
    ld a, [wPerfChannelState]                     ; $57A7
    ld hl, wPerfChannelBlink                      ; $57AA
    call DjPerf_ToggleBlink                       ; $57AD
    ld hl, $9ee5                                  ; $57B0
    call DjPerf_Write2Tiles                       ; $57B3
    ret                                           ; $57B6


; C
DjPerf_DrawChannel2State::
    ld a, [wPerfChannelState + $1]                ; $57B7
    and a                                         ; $57BA
    jr nz, jr_005_57c1                            ; $57BB

    ld a, $c9                                     ; $57BD
    jr jr_005_57c3                                ; $57BF

jr_005_57c1:
    ld a, $ca                                     ; $57C1

jr_005_57c3:
    ld hl, $9eaa                                  ; $57C3
    call Vram_WriteByteSafe                       ; $57C6
    ld a, [wPerfPaused]                           ; $57C9
    and a                                         ; $57CC
    jr z, jr_005_57d3                             ; $57CD

    xor a                                         ; $57CF
    ld [wPerfChannelBlink + $1], a                ; $57D0

jr_005_57d3:
    ld a, [wPerfChannelState + $1]                ; $57D3
    ld hl, wPerfChannelBlink + $1                 ; $57D6
    call DjPerf_ToggleBlink                       ; $57D9
    ld hl, $9ee9                                  ; $57DC
    call DjPerf_Write2Tiles                       ; $57DF
    ret                                           ; $57E2


; C
DjPerf_DrawChannel3State::
    ld a, [wPerfChannelState + $2]                ; $57E3
    and a                                         ; $57E6
    jr nz, jr_005_57ed                            ; $57E7

    ld a, $a9                                     ; $57E9
    jr jr_005_57ef                                ; $57EB

jr_005_57ed:
    ld a, $ba                                     ; $57ED

jr_005_57ef:
    ld hl, $9e8a                                  ; $57EF
    call Vram_WriteByteSafe                       ; $57F2
    ld a, [wPerfPaused]                           ; $57F5
    and a                                         ; $57F8
    jr z, jr_005_57ff                             ; $57F9

    xor a                                         ; $57FB
    ld [wPerfChannelBlink + $2], a                ; $57FC

jr_005_57ff:
    ld a, [wPerfChannelState + $2]                ; $57FF
    ld hl, wPerfChannelBlink + $2                 ; $5802
    call DjPerf_ToggleBlink                       ; $5805
    ld hl, $9eed                                  ; $5808
    call DjPerf_Write2Tiles                       ; $580B
    ret                                           ; $580E


; C
DjPerf_DrawLevelDigit::
    ld a, [wPerfLevel]                            ; $580F
    inc a                                         ; $5812
    swap a                                        ; $5813
    ld c, a                                       ; $5815
    ld b, $00                                     ; $5816
    ld hl, $4d60                                  ; $5818
    add hl, bc                                    ; $581B
    ld a, $1a                                     ; $581C
    ld de, $8730                                  ; $581E
    ld bc, $0010                                  ; $5821
    call Vram_CopyFromBank                        ; $5824
    ret                                           ; $5827


; C: NR51 mask = $11
DjPerf_NR51MaskAll::
    ld a, $11                                     ; $5828
    ld [wPerfNr51Mask], a                         ; $582A
    ret                                           ; $582D


; C
DjPerf_NR51MaskFromChannels::
    ld b, $11                                     ; $582E
    ld a, [wPerfChannelState]                     ; $5830
    and a                                         ; $5833
    jr z, jr_005_583a                             ; $5834

    set 5, b                                      ; $5836
    set 1, b                                      ; $5838

jr_005_583a:
    ld a, [wPerfChannelState + $1]                ; $583A
    and a                                         ; $583D
    jr z, jr_005_5844                             ; $583E

    set 6, b                                      ; $5840
    set 2, b                                      ; $5842

jr_005_5844:
    ld a, [wPerfChannelState + $2]                ; $5844
    and a                                         ; $5847
    jr z, jr_005_584e                             ; $5848

    set 7, b                                      ; $584A
    set 3, b                                      ; $584C

jr_005_584e:
    ld a, b                                       ; $584E
    ld [wPerfNr51Mask], a                         ; $584F
    ret                                           ; $5852


; C: sound $12 and window slide
DjPanel_SlideIn::
    push af                                       ; $5853
    ld a, SFX1_PANEL_OPEN                         ; $5854
    call Snd_Sfx1                                 ; $5856
    pop af                                        ; $5859
    ld hl, Slide_WyDeltaTbl                       ; $585A
    ld b, $24                                     ; $585D

jr_005_585f:
    push bc                                       ; $585F
    push hl                                       ; $5860
    ldh a, [hWyShadow]                            ; $5861
    add [hl]                                      ; $5863
    ldh [hWyShadow], a                            ; $5864
    call DjPanel_WaitLine                         ; $5866
    rst Rst08_WaitVBlank                          ; $5869
    pop hl                                        ; $586A
    pop bc                                        ; $586B
    inc hl                                        ; $586C
    dec b                                         ; $586D
    jr nz, jr_005_585f                            ; $586E

    ret                                           ; $5870


; C: sound $13 and window slide back
DjPanel_SlideOut::
    push af                                       ; $5871
    ld a, SFX1_PANEL_CLOSE                        ; $5872
    call Snd_Sfx1                                 ; $5874
    pop af                                        ; $5877
    ld hl, Slide_WyDeltaTbl                       ; $5878
    ld b, $24                                     ; $587B

jr_005_587d:
    push bc                                       ; $587D
    push hl                                       ; $587E
    ldh a, [hWyShadow]                            ; $587F
    sub [hl]                                      ; $5881
    ldh [hWyShadow], a                            ; $5882
    call DjPanel_WaitLine                         ; $5884
    rst Rst08_WaitVBlank                          ; $5887
    pop hl                                        ; $5888
    pop bc                                        ; $5889
    inc hl                                        ; $588A
    dec b                                         ; $588B
    jr nz, jr_005_587d                            ; $588C

    ret                                           ; $588E


; C: waits for LY to pass the window line. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz)
DjPanel_WaitLine::
    ldh a, [rWY]                                  ; $588F
    dec a                                         ; $5891
    cp $90                                        ; $5892
    ret nc                                        ; $5894

    ld c, a                                       ; $5895

jr_005_5896:
    ldh a, [rLY]                                  ; $5896
    cp c                                          ; $5898
    jr nz, jr_005_5896                            ; $5899

    ld a, $03                                     ; $589B
    ld hl, $ff41                                  ; $589D

jr_005_58a0:
    ld a, [hl]                                    ; $58A0
    and $03                                       ; $58A1
    jr nz, jr_005_58a0                            ; $58A3

    ldh a, [rLCDC]                                ; $58A5
    res 1, a                                      ; $58A7
    ldh [rLCDC], a                                ; $58A9
    ret                                           ; $58AB


; C: C = A / 10; A = A mod 10
DjEd_DivMod10::
    ld c, $00                                     ; $58AC

jr_005_58ae:
    cp $0a                                        ; $58AE
    ret c                                         ; $58B0

    sub $0a                                       ; $58B1
    inc c                                         ; $58B3
    jr jr_005_58ae                                ; $58B4

; C
DjEd_DrawVolumeDigits::
    call DjEd_DivMod10                            ; $58B6
    push af                                       ; $58B9
    ld a, c                                       ; $58BA
    and a                                         ; $58BB
    jr z, jr_005_58c6                             ; $58BC

    ld bc, $2b30                                  ; $58BE
    ld a, $80                                     ; $58C1
    call Oam_AddMeta_B01_5D47                     ; $58C3

jr_005_58c6:
    pop af                                        ; $58C6
    ld bc, $3130                                  ; $58C7
    add $7f                                       ; $58CA
    call Oam_AddMeta_B01_5D47                     ; $58CC
    ret                                           ; $58CF


; C
DjEd_DrawEnvPeriodDigit::
    ld bc, $4030                                  ; $58D0
    and a                                         ; $58D3
    jr nz, jr_005_58d8                            ; $58D4

    ld a, $0a                                     ; $58D6

jr_005_58d8:
    add $7f                                       ; $58D8
    call Oam_AddMeta_B01_5D47                     ; $58DA
    ret                                           ; $58DD


; C
DjEd_DrawLengthDigit::
    push af                                       ; $58DE
    ld bc, DjPerf_NR51MaskFromChannels            ; $58DF
    and a                                         ; $58E2
    jr nz, jr_005_58e7                            ; $58E3

    ld a, $0a                                     ; $58E5

jr_005_58e7:
    add $7f                                       ; $58E7
    call Oam_AddMeta_B01_5D47                     ; $58E9
    pop af                                        ; $58EC
    cpl                                           ; $58ED
    add $2f                                       ; $58EE
    ld c, a                                       ; $58F0
    ld b, $51                                     ; $58F1
    ld a, $73                                     ; $58F3
    call Oam_AddMeta_B01_5D47                     ; $58F5
    ret                                           ; $58F8


; C
DjEd_DrawModDepthDigits::
    call DjEd_DivMod10                            ; $58F9
    push af                                       ; $58FC
    ld a, c                                       ; $58FD
    and a                                         ; $58FE
    jr z, jr_005_5909                             ; $58FF

    ld bc, $6930                                  ; $5901
    add $7f                                       ; $5904
    call Oam_AddMeta_B01_5D47                     ; $5906

jr_005_5909:
    pop af                                        ; $5909
    ld bc, $6f30                                  ; $590A
    add $7f                                       ; $590D
    call Oam_AddMeta_B01_5D47                     ; $590F
    ret                                           ; $5912


; C
DjEd_DrawModSpeedDigits::
    call DjEd_DivMod10                            ; $5913
    push af                                       ; $5916
    ld a, c                                       ; $5917
    and a                                         ; $5918
    jr z, jr_005_5923                             ; $5919

    ld bc, $7b30                                  ; $591B
    add $7f                                       ; $591E
    call Oam_AddMeta_B01_5D47                     ; $5920

jr_005_5923:
    pop af                                        ; $5923
    ld bc, $8130                                  ; $5924
    add $7f                                       ; $5927
    call Oam_AddMeta_B01_5D47                     ; $5929
    ret                                           ; $592C


; C: loop digits; during print also the printer loop (A / rows)
DjEd_DrawLoopDigitsAndPrint::
    push af                                       ; $592D
    call DjEd_DivMod10                            ; $592E
    push af                                       ; $5931
    ld a, c                                       ; $5932
    and a                                         ; $5933
    jr z, jr_005_593e                             ; $5934

    ld bc, $084a                                  ; $5936
    ld a, $80                                     ; $5939
    call Oam_AddMeta_B01_5D47                     ; $593B

jr_005_593e:
    pop af                                        ; $593E
    ld bc, $0e4a                                  ; $593F
    add $7f                                       ; $5942
    call Oam_AddMeta_B01_5D47                     ; $5944
    pop af                                        ; $5947
    sla a                                         ; $5948
    sla a                                         ; $594A
    sla a                                         ; $594C
    add $18                                       ; $594E
    ld b, a                                       ; $5950
    ld c, $44                                     ; $5951
    ld a, $7e                                     ; $5953
    call Oam_AddMeta_B01_5D47                     ; $5955
    ret                                           ; $5958


; C: the TRIPY-H score print job (reached by A on Start-held in the editor, 05:4758): DjPrint_BeginSerial, INIT, bands
; of 9 rows (DjPrint_RowDispatch, DjPrint_SendBand), PRINT, wait, repeated until row $27 or B; ends with
; DjPrint_EndSerial (branch target; code read 2026-10-19)
DjPrint_Job::
    xor a                                         ; $5959
    ldh [rNR51], a                                ; $595A
    call DjPrint_BeginSerial                      ; $595C
    xor a                                         ; $595F
    ld [wPerfPrintRow], a                         ; $5960
    ld hl, wPerfPrintBandFlags                    ; $5963
    set 0, [hl]                                   ; $5966

jr_005_5968:
    call DjPrint_SendInitWait                     ; $5968
    jr c, jr_005_59bf                             ; $596B

    ld b, $09                                     ; $596D
    ld a, [wPerfPrintRow]                         ; $596F
    cpl                                           ; $5972
    add $28                                       ; $5973
    cp $09                                        ; $5975
    jr nc, jr_005_597a                            ; $5977

    ld b, a                                       ; $5979

jr_005_597a:
    push bc                                       ; $597A
    call DjPrint_RowDispatch                      ; $597B
    pop bc                                        ; $597E
    push bc                                       ; $597F
    ld a, b                                       ; $5980
    cp $01                                        ; $5981
    jr nz, jr_005_5989                            ; $5983

    ld a, $01                                     ; $5985
    jr jr_005_598a                                ; $5987

jr_005_5989:
    xor a                                         ; $5989

jr_005_598a:
    call DjPrint_SendBand                         ; $598A
    pop bc                                        ; $598D
    jr c, jr_005_59bf                             ; $598E

    dec b                                         ; $5990
    jr nz, jr_005_597a                            ; $5991

    ld a, [wPerfPrintRow]                         ; $5993
    cp $27                                        ; $5996
    jr nz, jr_005_599f                            ; $5998

    ld hl, wPerfPrintBandFlags                    ; $599A
    set 1, [hl]                                   ; $599D

jr_005_599f:
    call DjPrint_SendPrint                        ; $599F
    jr c, jr_005_59bf                             ; $59A2

    call DjPrint_WaitDone                         ; $59A4
    push af                                       ; $59A7
    call Prn_EngineStop                           ; $59A8
    pop af                                        ; $59AB
    jr c, jr_005_59bf                             ; $59AC

    ld a, [wPerfPrintRow]                         ; $59AE
    cp $27                                        ; $59B1
    jr z, jr_005_59bf                             ; $59B3

    ldh a, [hKeysNewSticky]                       ; $59B5
    ld b, a                                       ; $59B7
    xor a                                         ; $59B8
    ldh [hKeysNewSticky], a                       ; $59B9
    bit 1, b                                      ; $59BB
    jr z, jr_005_5968                             ; $59BD

jr_005_59bf:
    call DjPrint_EndSerial                        ; $59BF
    ret                                           ; $59C2


; C: enables the serial IRQ and the printer poll
DjPrint_BeginSerial::
    ld hl, rIE                                    ; $59C3
    set 3, [hl]                                   ; $59C6
    ld a, $00                                     ; $59C8
    ldh [hSerialHandlerIndex], a                  ; $59CA
    ld a, $01                                     ; $59CC
    ld [wPrnPollEnable], a                        ; $59CE
    ret                                           ; $59D1


; C: Prn_SendInit until the answer is not $F0
DjPrint_SendInitWait::
    call Prn_SendInit                             ; $59D2
    cp $f0                                        ; $59D5
    jr nz, jr_005_59dc                            ; $59D7

    rst Rst08_WaitVBlank                          ; $59D9
    jr DjPrint_SendInitWait                       ; $59DA

jr_005_59dc:
    cp $ff                                        ; $59DC
    jr z, jr_005_59e2                             ; $59DE

    and a                                         ; $59E0
    ret                                           ; $59E1


jr_005_59e2:
    scf                                           ; $59E2
    ret                                           ; $59E3


; C: one band of 40 rows
DjPrint_SendBand::
    ldh [hScratchA], a                            ; $59E4

jr_005_59e6:
    rst Rst08_WaitVBlank                          ; $59E6
    ldh a, [hScratchA]                            ; $59E7
    ld [wPrnLastChunk], a                         ; $59E9
    ld hl, wBandBuffer                            ; $59EC
    ld a, $01                                     ; $59EF
    call Prn_SendData                             ; $59F1
    cp $f0                                        ; $59F4
    jr z, jr_005_59e6                             ; $59F6

    cp $ff                                        ; $59F8
    jr z, jr_005_59fe                             ; $59FA

    and a                                         ; $59FC
    ret                                           ; $59FD


jr_005_59fe:
    scf                                           ; $59FE
    ret                                           ; $59FF


; C: print command with the margins of the band
DjPrint_SendPrint::
    ld a, $01                                     ; $5A00
    ld [wPrnSheets], a                            ; $5A02
    xor a                                         ; $5A05
    ld hl, wPerfPrintBandFlags                    ; $5A06
    bit 0, [hl]                                   ; $5A09
    jr z, jr_005_5a11                             ; $5A0B

    or $30                                        ; $5A0D
    res 0, [hl]                                   ; $5A0F

jr_005_5a11:
    bit 1, [hl]                                   ; $5A11
    jr z, jr_005_5a19                             ; $5A13

    or $03                                        ; $5A15
    res 1, [hl]                                   ; $5A17

jr_005_5a19:
    ld [wPrnMargin], a                            ; $5A19
    ld a, $e4                                     ; $5A1C
    ld [wPrnPalette], a                           ; $5A1E
    call Prn_SendPrint                            ; $5A21
    cp $f0                                        ; $5A24
    jr nz, jr_005_5a2b                            ; $5A26

    rst Rst08_WaitVBlank                          ; $5A28
    jr DjPrint_SendPrint                          ; $5A29

jr_005_5a2b:
    cp $ff                                        ; $5A2B
    jr z, jr_005_5a31                             ; $5A2D

    and a                                         ; $5A2F
    ret                                           ; $5A30


jr_005_5a31:
    scf                                           ; $5A31
    ret                                           ; $5A32


; C: waits for the printer status
DjPrint_WaitDone::
    ld bc, $000c                                  ; $5A33
    call Wait_Frames                              ; $5A36

jr_005_5a39:
    rst Rst08_WaitVBlank                          ; $5A39
    ld a, [wPrnStatus]                            ; $5A3A
    cp $ff                                        ; $5A3D
    jr z, jr_005_5a47                             ; $5A3F

    bit 1, a                                      ; $5A41
    jr nz, jr_005_5a39                            ; $5A43

    and a                                         ; $5A45
    ret                                           ; $5A46


jr_005_5a47:
    scf                                           ; $5A47
    ret                                           ; $5A48


; C
DjPrint_EndSerial::
    ld hl, rIE                                    ; $5A49
    res 3, [hl]                                   ; $5A4C
    xor a                                         ; $5A4E
    ld [wPrnPollEnable], a                        ; $5A4F
    ret                                           ; $5A52


; C: jumps through the 39-entry row table at 5A67
DjPrint_RowDispatch::
    ld a, [wPerfPrintRow]                         ; $5A53
    ld c, a                                       ; $5A56
    inc a                                         ; $5A57
    ld [wPerfPrintRow], a                         ; $5A58
    sla c                                         ; $5A5B
    ld b, $00                                     ; $5A5D
    ld hl, DjPrint_RowTbl                         ; $5A5F
    add hl, bc                                    ; $5A62
    ld a, [hl+]                                   ; $5A63
    ld h, [hl]                                    ; $5A64
    ld l, a                                       ; $5A65
    jp hl                                         ; $5A66


; C: 39 code pointers: one per printed line
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
    ld hl, DjPrintRow_Text0_Tbl5ABB               ; $5AB5
    jp DjPrint_RenderTextRow                      ; $5AB8


; C: row table of DjPrintRow_Text0 (ld hl,5ABB; jp 60EE): 20 x $8B (blank row); was typed as padding
DjPrintRow_Text0_Tbl5ABB::
    db $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b, $8b

; C: fixed text line (rows 1 / 3). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text1::
    ld hl, DjPrintRow_Text1_Tbl5AD5               ; $5ACF
    jp DjPrint_RenderTextRow                      ; $5AD2


; C: row table of DjPrintRow_Text1: $8B, 18 x $9F, $8B (20 tile codes); the 1 + 18 + 1 byte split was a typing
; artefact
DjPrintRow_Text1_Tbl5AD5::
    db $8b, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $8b

; C: fixed text line (row 2). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text2::
    ld hl, DjPrintRow_Text2_Tbl5AEF               ; $5AE9
    jp DjPrint_RenderTextRow                      ; $5AEC


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text2. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text2_Tbl5AEF::
    db $8b, $9f, $9f, $9f, $9f, $9f, $83, $81, $68, $6f, $88, $4d, $67, $9f, $9f, $9f
    db $9f, $9f, $9f, $8b

; C: fixed text line (row 6). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text3::
    ld hl, DjPrintRow_Text3_Tbl5B09               ; $5B03
    jp DjPrint_RenderTextRow                      ; $5B06


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text3. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text3_Tbl5B09::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $00, $01, $02, $03, $04, $07, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 16). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text4::
    ld hl, DjPrintRow_Text4_Tbl5B23               ; $5B1D
    jp DjPrint_RenderTextRow                      ; $5B20


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text4. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text4_Tbl5B23::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $00, $01, $02, $03, $04, $08, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 30). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text5::
    ld hl, DjPrintRow_Text5_Tbl5B3D               ; $5B37
    jp DjPrint_RenderTextRow                      ; $5B3A


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text5. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text5_Tbl5B3D::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $03, $01, $05, $00, $06, $4d, $4d, $4d, $4d
    db $4d, $4d, $4d, $4d

; C: fixed text line (row 38). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text6::
    ld hl, DjPrintRow_Text6_Tbl5B57               ; $5B51
    jp DjPrint_RenderTextRow                      ; $5B54


; C: row table of DjPrintRow_Text6 (ld hl,5B57; jp 60EE): 20 x $4D; was typed as padding
DjPrintRow_Text6_Tbl5B57::
    db $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d, $4d

; C: fixed text line (rows 7 / 17 / 31). L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text7::
    ld hl, DjPrintRow_Text7_Tbl5B71               ; $5B6B
    jp DjPrint_RenderTextRow                      ; $5B6E


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Text7. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Text7_Tbl5B71::
    db $6d, $6e, $83, $64, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND I notes 0-3 and their stereo codes
DjPrintRow_S1Notes0::
    ld hl, wSound1Notes                           ; $5B85
    ld de, wSound1Stereo                          ; $5B88
    ld c, $00                                     ; $5B8B
    jp DjPrintRow_NsNotes_Build                   ; $5B8D


; C: SOUND I notes 4-7
DjPrintRow_S1Notes1::
    ld hl, wSound1Notes + $4                      ; $5B90
    ld de, wSound1Stereo + $4                     ; $5B93
    ld c, $00                                     ; $5B96
    jp DjPrintRow_NsNotes_Build                   ; $5B98


; C: SOUND I notes 8-11
DjPrintRow_S1Notes2::
    ld hl, wSound1Notes + $8                      ; $5B9B
    ld de, wSound1Stereo + $8                     ; $5B9E
    ld c, $00                                     ; $5BA1
    jp DjPrintRow_NsNotes_Build                   ; $5BA3


; C: SOUND I notes 12-15
DjPrintRow_S1Notes3::
    ld hl, wSound1Notes + $c                      ; $5BA6
    ld de, wSound1Stereo + $c                     ; $5BA9
    ld c, $00                                     ; $5BAC
    jp DjPrintRow_NsNotes_Build                   ; $5BAE


; C: SOUND II notes 0-3
DjPrintRow_S2Notes0::
    ld hl, wSound2Notes                           ; $5BB1
    ld de, wSound2Stereo                          ; $5BB4
    ld c, $00                                     ; $5BB7
    jp DjPrintRow_NsNotes_Build                   ; $5BB9


; C: SOUND II notes 4-7
DjPrintRow_S2Notes1::
    ld hl, wSound2Notes + $4                      ; $5BBC
    ld de, wSound2Stereo + $4                     ; $5BBF
    ld c, $00                                     ; $5BC2
    jp DjPrintRow_NsNotes_Build                   ; $5BC4


; C: SOUND II notes 8-11
DjPrintRow_S2Notes2::
    ld hl, wSound2Notes + $8                      ; $5BC7
    ld de, wSound2Stereo + $8                     ; $5BCA
    ld c, $00                                     ; $5BCD
    jp DjPrintRow_NsNotes_Build                   ; $5BCF


; C: SOUND II notes 12-15
DjPrintRow_S2Notes3::
    ld hl, wSound2Notes + $c                      ; $5BD2
    ld de, wSound2Stereo + $c                     ; $5BD5
    ld c, $00                                     ; $5BD8
    jp DjPrintRow_NsNotes_Build                   ; $5BDA


; C: NOISE notes 0-3
DjPrintRow_NsNotes0::
    ld hl, wNoiseNotes                            ; $5BDD
    ld de, wNoiseStereoWidth                      ; $5BE0
    ld c, $10                                     ; $5BE3
    jp DjPrintRow_NsNotes_Build                   ; $5BE5


; C: NOISE notes 4-7
DjPrintRow_NsNotes1::
    ld hl, wNoiseNotes + $4                       ; $5BE8
    ld de, wNoiseStereoWidth + $4                 ; $5BEB
    ld c, $10                                     ; $5BEE
    jp DjPrintRow_NsNotes_Build                   ; $5BF0


; C: NOISE notes 8-11
DjPrintRow_NsNotes2::
    ld hl, wNoiseNotes + $8                       ; $5BF3
    ld de, wNoiseStereoWidth + $8                 ; $5BF6
    ld c, $10                                     ; $5BF9
    jp DjPrintRow_NsNotes_Build                   ; $5BFB


; C: NOISE notes 12-15; followed by the shared note-row renderer
DjPrintRow_NsNotes3::
    ld hl, wNoiseNotes + $c                       ; $5BFE
    ld de, wNoiseStereoWidth + $c                 ; $5C01
    ld c, $10                                     ; $5C04
    jp DjPrintRow_NsNotes_Build                   ; $5C06


; C: shared tail of the five noise-step note rows (callers 5B8D-5BB9): copies the 20-byte template Tbl5C7E to $C480,
; then writes the notes of one 4-note group (branch target; code read 2026-10-19)
DjPrintRow_NsNotes_Build::
    push bc                                       ; $5C09
    push de                                       ; $5C0A
    push hl                                       ; $5C0B
    ld hl, DjPrintRow_NsNotes3_Tbl5C7E            ; $5C0C
    ld de, wTextLineSrc                           ; $5C0F
    ld b, $14                                     ; $5C12

jr_005_5c14:
    ld a, [hl+]                                   ; $5C14
    ld [de], a                                    ; $5C15
    inc e                                         ; $5C16
    dec b                                         ; $5C17
    jr nz, jr_005_5c14                            ; $5C18

    pop hl                                        ; $5C1A
    ld de, wTextLineSrc + $1                      ; $5C1B
    ld b, $04                                     ; $5C1E

jr_005_5c20:
    ld a, [hl+]                                   ; $5C20
    and a                                         ; $5C21
    jr nz, jr_005_5c2b                            ; $5C22

    inc de                                        ; $5C24
    ld a, $8a                                     ; $5C25
    ld [de], a                                    ; $5C27
    inc de                                        ; $5C28
    jr jr_005_5c4e                                ; $5C29

jr_005_5c2b:
    dec a                                         ; $5C2B
    ld c, $00                                     ; $5C2C

jr_005_5c2e:
    cp $0c                                        ; $5C2E
    jr c, jr_005_5c37                             ; $5C30

    sub $0c                                       ; $5C32
    inc c                                         ; $5C34
    jr jr_005_5c2e                                ; $5C35

jr_005_5c37:
    push bc                                       ; $5C37
    push hl                                       ; $5C38
    sla a                                         ; $5C39
    ld c, a                                       ; $5C3B
    ld b, $00                                     ; $5C3C
    ld hl, DjPrintRow_NsNotes3_Tbl5C92            ; $5C3E
    add hl, bc                                    ; $5C41
    ld a, [hl+]                                   ; $5C42
    ld [de], a                                    ; $5C43
    inc de                                        ; $5C44
    ld a, [hl]                                    ; $5C45
    ld [de], a                                    ; $5C46
    inc de                                        ; $5C47
    pop hl                                        ; $5C48
    pop bc                                        ; $5C49
    ld a, c                                       ; $5C4A
    add $23                                       ; $5C4B
    ld [de], a                                    ; $5C4D

jr_005_5c4e:
    inc de                                        ; $5C4E
    inc de                                        ; $5C4F
    inc de                                        ; $5C50
    dec b                                         ; $5C51
    jr nz, jr_005_5c20                            ; $5C52

    pop hl                                        ; $5C54
    pop bc                                        ; $5C55
    ld a, c                                       ; $5C56
    ldh [hScratchA], a                            ; $5C57
    ld de, wTextLineSrc + $4                      ; $5C59
    ld b, $04                                     ; $5C5C

jr_005_5c5e:
    ld a, [hl]                                    ; $5C5E
    and $03                                       ; $5C5F
    ld c, a                                       ; $5C61
    ldh a, [hScratchA]                            ; $5C62
    add [hl]                                      ; $5C64
    srl a                                         ; $5C65
    srl a                                         ; $5C67
    and $0c                                       ; $5C69
    or c                                          ; $5C6B
    or $f0                                        ; $5C6C
    ld [de], a                                    ; $5C6E
    inc hl                                        ; $5C6F
    inc de                                        ; $5C70
    inc de                                        ; $5C71
    inc de                                        ; $5C72
    inc de                                        ; $5C73
    inc de                                        ; $5C74
    dec b                                         ; $5C75
    jr nz, jr_005_5c5e                            ; $5C76

    ld hl, wTextLineSrc                           ; $5C78
    jp DjPrint_RenderTextRow                      ; $5C7B


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsNotes3. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsNotes3_Tbl5C7E::
    db $9f, $9f, $9f, $9f, $9f, $4f, $9f, $9f, $9f, $9f, $4f, $9f, $9f, $9f, $9f, $4f
    db $9f, $9f, $9f, $9f

; C: auto: 24 bytes, bytes; referenced by DjPrintRow_NsNotes3. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsNotes3_Tbl5C92::
    db $09, $9f, $09, $20, $0a, $9f, $0a, $20, $0b, $9f, $0c, $9f, $0c, $20, $0d, $9f
    db $0d, $20, $0e, $9f, $0e, $20, $0f, $9f

; C: SOUND I duty and length line
DjPrintRow_S1Duty::
    ld hl, DjPrintRow_S1Duty_Tbl5CD0              ; $5CAA
    ld de, wTextLineSrc                           ; $5CAD
    ld b, $14                                     ; $5CB0

jr_005_5cb2:
    ld a, [hl+]                                   ; $5CB2
    ld [de], a                                    ; $5CB3
    inc e                                         ; $5CB4
    dec b                                         ; $5CB5
    jr nz, jr_005_5cb2                            ; $5CB6

    ld de, wTextLineSrc + $5                      ; $5CB8
    ld a, [wSound1DutyLen]                        ; $5CBB
    ld c, a                                       ; $5CBE
    ld b, $00                                     ; $5CBF
    ld hl, DjPrintRow_S1Duty_Tbl5CE4              ; $5CC1
    add hl, bc                                    ; $5CC4
    ld a, [hl]                                    ; $5CC5
    ld [de], a                                    ; $5CC6
    inc de                                        ; $5CC7
    inc a                                         ; $5CC8
    ld [de], a                                    ; $5CC9
    ld hl, wTextLineSrc                           ; $5CCA
    jp DjPrint_RenderTextRow                      ; $5CCD


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S1Duty. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S1Duty_Tbl5CD0::
    db $63, $84, $83, $88, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 3 bytes, bytes; referenced by DjPrintRow_S1Duty. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S1Duty_Tbl5CE4::
    db $2c, $2e, $40

; C: SOUND I envelope line
DjPrintRow_S1Envelope::
    ld a, [wSound1Envelope]                       ; $5CE7
    ldh [hScratchA], a                            ; $5CEA
    ld a, [wSound1Envelope + $2]                  ; $5CEC
    ldh [hScratchB], a                            ; $5CEF
    ld a, [wSound1Envelope + $1]                  ; $5CF1
    ldh [hScratchC], a                            ; $5CF4
    ld a, [wSound1DutyLen + $1]                   ; $5CF6
    ldh [hScratchD], a                            ; $5CF9
    jp DjPrintRow_NsEnvelope_Build                ; $5CFB


; C: NOISE envelope line
DjPrintRow_NsEnvelope::
    ld a, [wNoiseEnvelope]                        ; $5CFE
    ldh [hScratchA], a                            ; $5D01
    ld a, [wNoiseEnvelope + $2]                   ; $5D03
    ldh [hScratchB], a                            ; $5D06
    ld a, [wNoiseEnvelope + $1]                   ; $5D08
    ldh [hScratchC], a                            ; $5D0B
    ld a, [wNoiseGateLoop]                        ; $5D0D
    ldh [hScratchD], a                            ; $5D10
    jp DjPrintRow_NsEnvelope_Build                ; $5D12


; C: shared tail of the two envelope rows (callers 5CFB, 5D12): copies the template Tbl5D4A to $C480 and writes the
; step number, the dash and the envelope values (branch target; code read 2026-10-19)
DjPrintRow_NsEnvelope_Build::
    ld hl, DjPrintRow_NsEnvelope_Tbl5D4A          ; $5D15
    ld de, wTextLineSrc                           ; $5D18
    ld b, $14                                     ; $5D1B

jr_005_5d1d:
    ld a, [hl+]                                   ; $5D1D
    ld [de], a                                    ; $5D1E
    inc e                                         ; $5D1F
    dec b                                         ; $5D20
    jr nz, jr_005_5d1d                            ; $5D21

    ld de, wTextLineSrc + $5                      ; $5D23
    ldh a, [hScratchA]                            ; $5D26
    add $42                                       ; $5D28
    ld [de], a                                    ; $5D2A
    inc de                                        ; $5D2B
    call DjPrint_PutDash                          ; $5D2C
    ldh a, [hScratchB]                            ; $5D2F
    call DjPrint_PutNumber2                       ; $5D31
    call DjPrint_PutDash                          ; $5D34
    ldh a, [hScratchC]                            ; $5D37
    call DjPrint_PutDigitOrBlank                  ; $5D39
    call DjPrint_PutDash                          ; $5D3C
    ldh a, [hScratchD]                            ; $5D3F
    call DjPrint_PutDigitOrBlank                  ; $5D41
    ld hl, wTextLineSrc                           ; $5D44
    jp DjPrint_RenderTextRow                      ; $5D47


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsEnvelope. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsEnvelope_Tbl5D4A::
    db $64, $6d, $85, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND II wave pattern line
DjPrintRow_S2WavePattern::
    ld hl, DjPrintRow_S2WavePattern_Tbl5D7B       ; $5D5E
    ld de, wTextLineSrc                           ; $5D61
    ld b, $14                                     ; $5D64

jr_005_5d66:
    ld a, [hl+]                                   ; $5D66
    ld [de], a                                    ; $5D67
    inc e                                         ; $5D68
    dec b                                         ; $5D69
    jr nz, jr_005_5d66                            ; $5D6A

    ld de, wTextLineSrc + $5                      ; $5D6C
    ld a, [wSound2WaveLen + $1]                   ; $5D6F
    call DjPrint_PutDigitOrBlank                  ; $5D72
    ld hl, wTextLineSrc                           ; $5D75
    jp DjPrint_RenderTextRow                      ; $5D78


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2WavePattern. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WavePattern_Tbl5D7B::
    db $64, $6d, $85, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND I modulation line
DjPrintRow_S1Modulation::
    ld a, [wSound1Modulation]                     ; $5D8F
    ldh [hScratchA], a                            ; $5D92
    ld a, [wSound1Modulation + $1]                ; $5D94
    ldh [hScratchB], a                            ; $5D97
    ld a, [wSound1Modulation + $2]                ; $5D99
    ldh [hScratchC], a                            ; $5D9C
    jp DjPrintRow_S2Modulation_Build              ; $5D9E


; C: SOUND II modulation line
DjPrintRow_S2Modulation::
    ld a, [wSound2Modulation]                     ; $5DA1
    ldh [hScratchA], a                            ; $5DA4
    ld a, [wSound2Modulation + $1]                ; $5DA6
    ldh [hScratchB], a                            ; $5DA9
    ld a, [wSound2Modulation + $2]                ; $5DAB
    ldh [hScratchC], a                            ; $5DAE
    jp DjPrintRow_S2Modulation_Build              ; $5DB0


; C: shared tail of the two modulation rows (callers 5D9E, 5DB0): copies the template Tbl5DE8 to $C480, then the
; numbers with DjPrint_PutNumber2 / DjPrint_PutDash (branch target; code read 2026-10-19)
DjPrintRow_S2Modulation_Build::
    ld hl, DjPrintRow_S2Modulation_Tbl5DE8        ; $5DB3
    ld de, wTextLineSrc                           ; $5DB6
    ld b, $14                                     ; $5DB9

jr_005_5dbb:
    ld a, [hl+]                                   ; $5DBB
    ld [de], a                                    ; $5DBC
    inc e                                         ; $5DBD
    dec b                                         ; $5DBE
    jr nz, jr_005_5dbb                            ; $5DBF

    ld de, wTextLineSrc + $5                      ; $5DC1
    ldh a, [hScratchA]                            ; $5DC4
    call DjPrint_PutNumber2                       ; $5DC6
    call DjPrint_PutDash                          ; $5DC9
    ldh a, [hScratchB]                            ; $5DCC
    call DjPrint_PutNumber2                       ; $5DCE
    call DjPrint_PutDash                          ; $5DD1
    ldh a, [hScratchC]                            ; $5DD4
    ld c, a                                       ; $5DD6
    ld b, $00                                     ; $5DD7
    ld hl, DjPrintRow_S2Modulation_Tbl5DFC        ; $5DD9
    add hl, bc                                    ; $5DDC
    ld a, [hl]                                    ; $5DDD
    ld [de], a                                    ; $5DDE
    inc de                                        ; $5DDF
    inc a                                         ; $5DE0
    ld [de], a                                    ; $5DE1
    ld hl, wTextLineSrc                           ; $5DE2
    jp DjPrint_RenderTextRow                      ; $5DE5


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2Modulation. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2Modulation_Tbl5DE8::
    db $6c, $6e, $63, $5f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 3 bytes, bytes; referenced by DjPrintRow_S2Modulation. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2Modulation_Tbl5DFC::
    db $46, $44, $4a

; C: SOUND I loop length line
DjPrintRow_S1Loop::
    ld a, [wLoopLengths]                          ; $5DFF
    ldh [hScratchA], a                            ; $5E02
    jp DjPrintRow_NsLoop_Build                    ; $5E04


; C: SOUND II loop length line
DjPrintRow_S2Loop::
    ld a, [wLoopLengths + $1]                     ; $5E07
    ldh [hScratchA], a                            ; $5E0A
    jp DjPrintRow_NsLoop_Build                    ; $5E0C


; C: NOISE loop length line
DjPrintRow_NsLoop::
    ld a, [wNoiseGateLoop + $1]                   ; $5E0F
    ldh [hScratchA], a                            ; $5E12
    jp DjPrintRow_NsLoop_Build                    ; $5E14


; C: shared tail of the three loop rows (callers 5E04, 5E0C, 5E14): template Tbl5E33 to $C480, step number, then
; DjPrint_RenderTextRow (branch target; code read 2026-10-19)
DjPrintRow_NsLoop_Build::
    ld hl, DjPrintRow_NsLoop_Tbl5E33              ; $5E17
    ld de, wTextLineSrc                           ; $5E1A
    ld b, $14                                     ; $5E1D

jr_005_5e1f:
    ld a, [hl+]                                   ; $5E1F
    ld [de], a                                    ; $5E20
    inc e                                         ; $5E21
    dec b                                         ; $5E22
    jr nz, jr_005_5e1f                            ; $5E23

    ld de, wTextLineSrc + $5                      ; $5E25
    ldh a, [hScratchA]                            ; $5E28
    call DjPrint_PutNumber2                       ; $5E2A
    ld hl, wTextLineSrc                           ; $5E2D
    jp DjPrint_RenderTextRow                      ; $5E30


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_NsLoop. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_NsLoop_Tbl5E33::
    db $6b, $6e, $6e, $6f, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: tempo line
DjPrintRow_Tempo::
    ld hl, DjPrintRow_Tempo_Tbl5E64               ; $5E47
    ld de, wTextLineSrc                           ; $5E4A
    ld b, $14                                     ; $5E4D

jr_005_5e4f:
    ld a, [hl+]                                   ; $5E4F
    ld [de], a                                    ; $5E50
    inc e                                         ; $5E51
    dec b                                         ; $5E52
    jr nz, jr_005_5e4f                            ; $5E53

    ld de, wTextLineSrc + $6                      ; $5E55
    ld a, [wTempo]                                ; $5E58
    call DjPrint_PutTempo                         ; $5E5B
    ld hl, wTextLineSrc                           ; $5E5E
    jp DjPrint_RenderTextRow                      ; $5E61


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_Tempo. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_Tempo_Tbl5E64::
    db $83, $64, $6c, $6f, $6e, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: SOUND II wave title line. L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WaveTitle::
    ld hl, DjPrintRow_S2WaveTitle_Tbl5EAA         ; $5E78
    ld de, wTextLineSrc                           ; $5E7B
    ld b, $14                                     ; $5E7E

jr_005_5e80:
    ld a, [hl+]                                   ; $5E80
    ld [de], a                                    ; $5E81
    inc e                                         ; $5E82
    dec b                                         ; $5E83
    jr nz, jr_005_5e80                            ; $5E84

    ld de, wTextLineSrc + $5                      ; $5E86
    ld a, [wSound2WaveLen]                        ; $5E89
    cp $02                                        ; $5E8C
    jr z, jr_005_5ea4                             ; $5E8E

    ld c, a                                       ; $5E90
    ld b, $00                                     ; $5E91
    ld hl, DjPrintRow_S2WaveTitle_Tbl5EBE         ; $5E93
    add hl, bc                                    ; $5E96
    ld a, [hl]                                    ; $5E97
    ld [de], a                                    ; $5E98
    inc de                                        ; $5E99
    inc a                                         ; $5E9A
    ld [de], a                                    ; $5E9B
    ld a, [wPerfPrintRow]                         ; $5E9C
    add $04                                       ; $5E9F
    ld [wPerfPrintRow], a                         ; $5EA1

jr_005_5ea4:
    ld hl, wTextLineSrc                           ; $5EA4
    jp DjPrint_RenderTextRow                      ; $5EA7


; C: auto: 20 bytes, bytes; referenced by DjPrintRow_S2WaveTitle. L3 pass 2026-10-26: read in BGB in the scenarios
; dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrintRow_S2WaveTitle_Tbl5EAA::
    db $86, $60, $85, $64, $4e, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f
    db $9f, $9f, $9f, $9f

; C: auto: 2 bytes, bytes; referenced by DjPrintRow_S2WaveTitle. L3 pass 2026-10-26: no organic run reached it (BGB
; replays, BGB scenarios, core organic runs); C from the code: second table of DjPrintRow_S2WaveTitle (the first,
; Tbl5EAA, was read by the D.J. print in BGB)
DjPrintRow_S2WaveTitle_Tbl5EBE::
    dw $4844

; C: wave graph band 0 (never run until the printer runs)
DjPrintRow_S2WaveGraph0::
    call DjPrint_ClearBand                        ; $5EC0
    call DjPrint_DrawRuler                        ; $5EC3
    ld hl, wBandBuffer + $20                      ; $5EC6
    call DjPrint_FillCol                          ; $5EC9
    ld hl, wBandBuffer + $16e                     ; $5ECC
    call DjPrint_FillRow                          ; $5ECF
    ld de, wSound2UserWave                        ; $5ED2
    ld hl, wBandBuffer + $20                      ; $5ED5
    ld b, $10                                     ; $5ED8

jr_005_5eda:
    ld a, [de]                                    ; $5EDA
    inc de                                        ; $5EDB
    cp $0c                                        ; $5EDC
    jr c, jr_005_5ee7                             ; $5EDE

    sub $0b                                       ; $5EE0
    ld c, $e0                                     ; $5EE2
    call DjPrint_PlotBars4                        ; $5EE4

jr_005_5ee7:
    ld a, [de]                                    ; $5EE7
    inc de                                        ; $5EE8
    cp $0c                                        ; $5EE9
    jr c, jr_005_5ef4                             ; $5EEB

    sub $0b                                       ; $5EED
    ld c, $0e                                     ; $5EEF
    call DjPrint_PlotBars4                        ; $5EF1

jr_005_5ef4:
    ld a, l                                       ; $5EF4
    add $10                                       ; $5EF5
    ld l, a                                       ; $5EF7
    jr nc, jr_005_5efb                            ; $5EF8

    inc h                                         ; $5EFA

jr_005_5efb:
    dec b                                         ; $5EFB
    jr nz, jr_005_5eda                            ; $5EFC

    ret                                           ; $5EFE


; C
DjPrintRow_S2WaveGraph1::
    call DjPrint_ClearBand                        ; $5EFF
    call DjPrint_DrawRuler                        ; $5F02
    ld hl, wBandBuffer + $16f                     ; $5F05
    call DjPrint_FillRow                          ; $5F08
    ld de, wSound2UserWave                        ; $5F0B
    ld hl, wBandBuffer + $20                      ; $5F0E
    ld b, $10                                     ; $5F11

jr_005_5f13:
    ld a, [de]                                    ; $5F13
    inc de                                        ; $5F14
    cp $08                                        ; $5F15
    jr c, jr_005_5f20                             ; $5F17

    sub $07                                       ; $5F19
    ld c, $e0                                     ; $5F1B
    call DjPrint_PlotBars4                        ; $5F1D

jr_005_5f20:
    ld a, [de]                                    ; $5F20
    inc de                                        ; $5F21
    cp $08                                        ; $5F22
    jr c, jr_005_5f2d                             ; $5F24

    sub $07                                       ; $5F26
    ld c, $0e                                     ; $5F28
    call DjPrint_PlotBars4                        ; $5F2A

jr_005_5f2d:
    ld a, l                                       ; $5F2D
    add $10                                       ; $5F2E
    ld l, a                                       ; $5F30
    jr nc, jr_005_5f34                            ; $5F31

    inc h                                         ; $5F33

jr_005_5f34:
    dec b                                         ; $5F34
    jr nz, jr_005_5f13                            ; $5F35

    ret                                           ; $5F37


; C
DjPrintRow_S2WaveGraph2::
    call DjPrint_ClearBand                        ; $5F38
    call DjPrint_DrawRuler                        ; $5F3B
    ld hl, wBandBuffer + $16e                     ; $5F3E
    call DjPrint_FillRow                          ; $5F41
    ld de, wSound2UserWave                        ; $5F44
    ld hl, wBandBuffer + $20                      ; $5F47
    ld b, $10                                     ; $5F4A

jr_005_5f4c:
    ld a, [de]                                    ; $5F4C
    inc de                                        ; $5F4D
    cp $08                                        ; $5F4E
    jr nc, jr_005_5f5a                            ; $5F50

    cpl                                           ; $5F52
    add $09                                       ; $5F53
    ld c, $e0                                     ; $5F55
    call DjPrint_PlotBars4B                       ; $5F57

jr_005_5f5a:
    ld a, [de]                                    ; $5F5A
    inc de                                        ; $5F5B
    cp $08                                        ; $5F5C
    jr nc, jr_005_5f68                            ; $5F5E

    cpl                                           ; $5F60
    add $09                                       ; $5F61
    ld c, $0e                                     ; $5F63
    call DjPrint_PlotBars4B                       ; $5F65

jr_005_5f68:
    ld a, l                                       ; $5F68
    add $10                                       ; $5F69
    ld l, a                                       ; $5F6B
    jr nc, jr_005_5f6f                            ; $5F6C

    inc h                                         ; $5F6E

jr_005_5f6f:
    dec b                                         ; $5F6F
    jr nz, jr_005_5f4c                            ; $5F70

    ret                                           ; $5F72


; C
DjPrintRow_S2WaveGraph3::
    call DjPrint_ClearBand                        ; $5F73
    call DjPrint_DrawRuler                        ; $5F76
    ld hl, wBandBuffer + $16e                     ; $5F79
    call DjPrint_FillCol                          ; $5F7C
    ld de, wSound2UserWave                        ; $5F7F
    ld hl, wBandBuffer + $20                      ; $5F82
    ld b, $10                                     ; $5F85

jr_005_5f87:
    ld a, [de]                                    ; $5F87
    inc de                                        ; $5F88
    cp $04                                        ; $5F89
    jr nc, jr_005_5f95                            ; $5F8B

    cpl                                           ; $5F8D
    add $05                                       ; $5F8E
    ld c, $e0                                     ; $5F90
    call DjPrint_PlotBars4B                       ; $5F92

jr_005_5f95:
    ld a, [de]                                    ; $5F95
    inc de                                        ; $5F96
    cp $04                                        ; $5F97
    jr nc, jr_005_5fa3                            ; $5F99

    cpl                                           ; $5F9B
    add $05                                       ; $5F9C
    ld c, $0e                                     ; $5F9E
    call DjPrint_PlotBars4B                       ; $5FA0

jr_005_5fa3:
    ld a, l                                       ; $5FA3
    add $10                                       ; $5FA4
    ld l, a                                       ; $5FA6
    jr nc, jr_005_5faa                            ; $5FA7

    inc h                                         ; $5FA9

jr_005_5faa:
    dec b                                         ; $5FAA
    jr nz, jr_005_5f87                            ; $5FAB

    ret                                           ; $5FAD


; C: clears the 20x2 tile band buffer
DjPrint_ClearBand::
    xor a                                         ; $5FAE
    ld hl, wBandBuffer                            ; $5FAF
    ld b, $a0                                     ; $5FB2

jr_005_5fb4:
    ld [hl+], a                                   ; $5FB4
    ld [hl+], a                                   ; $5FB5
    ld [hl+], a                                   ; $5FB6
    ld [hl+], a                                   ; $5FB7
    dec b                                         ; $5FB8
    jr nz, jr_005_5fb4                            ; $5FB9

    ret                                           ; $5FBB


; C: ruler marks in the band
DjPrint_DrawRuler::
    ld a, $01                                     ; $5FBC
    ld hl, wBandBuffer + $10                      ; $5FBE
    call DjPrint_RulerLong                        ; $5FC1
    ld hl, wBandBuffer + $50                      ; $5FC4
    call DjPrint_RulerShort                       ; $5FC7
    ld hl, wBandBuffer + $91                      ; $5FCA
    call DjPrint_RulerShort                       ; $5FCD
    ld hl, wBandBuffer + $d0                      ; $5FD0
    call DjPrint_RulerShort                       ; $5FD3
    ld hl, wBandBuffer + $110                     ; $5FD6

; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_RulerLong::
    ld b, $08                                     ; $5FD9

jr_005_5fdb:
    ld [hl+], a                                   ; $5FDB
    ld [hl+], a                                   ; $5FDC
    dec b                                         ; $5FDD
    jr nz, jr_005_5fdb                            ; $5FDE

    ld bc, $0130                                  ; $5FE0
    add hl, bc                                    ; $5FE3
    ld b, $08                                     ; $5FE4

jr_005_5fe6:
    ld [hl+], a                                   ; $5FE6
    ld [hl+], a                                   ; $5FE7
    dec b                                         ; $5FE8
    jr nz, jr_005_5fe6                            ; $5FE9

    ret                                           ; $5FEB


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_RulerShort::
    ld b, $08                                     ; $5FEC

jr_005_5fee:
    ld [hl+], a                                   ; $5FEE
    inc hl                                        ; $5FEF
    dec b                                         ; $5FF0
    jr nz, jr_005_5fee                            ; $5FF1

    ld bc, $0130                                  ; $5FF3
    add hl, bc                                    ; $5FF6
    ld b, $08                                     ; $5FF7

jr_005_5ff9:
    ld [hl+], a                                   ; $5FF9
    inc hl                                        ; $5FFA
    dec b                                         ; $5FFB
    jr nz, jr_005_5ff9                            ; $5FFC

    ret                                           ; $5FFE


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_FillCol::
    ld a, $ff                                     ; $5FFF
    ld de, $000f                                  ; $6001
    ld b, $10                                     ; $6004

jr_005_6006:
    ld [hl+], a                                   ; $6006
    ld [hl], a                                    ; $6007
    add hl, de                                    ; $6008
    dec b                                         ; $6009
    jr nz, jr_005_6006                            ; $600A

    ret                                           ; $600C


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_FillRow::
    ld a, $ff                                     ; $600D
    ld de, $0010                                  ; $600F
    ld b, $10                                     ; $6012

jr_005_6014:
    ld [hl], a                                    ; $6014
    add hl, de                                    ; $6015
    dec b                                         ; $6016
    jr nz, jr_005_6014                            ; $6017

    ret                                           ; $6019


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PlotBars4::
    push de                                       ; $601A
    cp $04                                        ; $601B
    jr c, jr_005_6024                             ; $601D

    push hl                                       ; $601F
    call DjPrint_OrC3                             ; $6020
    pop hl                                        ; $6023

jr_005_6024:
    cp $03                                        ; $6024
    jr c, jr_005_6031                             ; $6026

    push hl                                       ; $6028
    ld de, $0008                                  ; $6029
    add hl, de                                    ; $602C
    call DjPrint_OrC3                             ; $602D
    pop hl                                        ; $6030

jr_005_6031:
    cp $02                                        ; $6031
    jr c, jr_005_603e                             ; $6033

    push hl                                       ; $6035
    ld de, $0140                                  ; $6036
    add hl, de                                    ; $6039
    call DjPrint_OrC3                             ; $603A
    pop hl                                        ; $603D

jr_005_603e:
    cp $01                                        ; $603E
    jr c, jr_005_604b                             ; $6040

    push hl                                       ; $6042
    ld de, HeaderROMSize                          ; $6043
    add hl, de                                    ; $6046
    call DjPrint_OrC3                             ; $6047
    pop hl                                        ; $604A

jr_005_604b:
    pop de                                        ; $604B
    ret                                           ; $604C


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PlotBars4B::
    push de                                       ; $604D
    cp $04                                        ; $604E
    jr c, jr_005_605b                             ; $6050

    push hl                                       ; $6052
    ld de, HeaderROMSize                          ; $6053
    add hl, de                                    ; $6056
    call DjPrint_OrC3                             ; $6057
    pop hl                                        ; $605A

jr_005_605b:
    cp $03                                        ; $605B
    jr c, jr_005_6068                             ; $605D

    push hl                                       ; $605F
    ld de, $0140                                  ; $6060
    add hl, de                                    ; $6063
    call DjPrint_OrC3                             ; $6064
    pop hl                                        ; $6067

jr_005_6068:
    cp $02                                        ; $6068
    jr c, jr_005_6075                             ; $606A

    push hl                                       ; $606C
    ld de, $0008                                  ; $606D
    add hl, de                                    ; $6070
    call DjPrint_OrC3                             ; $6071
    pop hl                                        ; $6074

jr_005_6075:
    cp $01                                        ; $6075
    jr c, jr_005_607e                             ; $6077

    push hl                                       ; $6079
    call DjPrint_OrC3                             ; $607A
    pop hl                                        ; $607D

jr_005_607e:
    pop de                                        ; $607E
    ret                                           ; $607F


; C: ORs C into three bytes at HL. L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_OrC3::
    ld a, [hl]                                    ; $6080
    or c                                          ; $6081
    ld [hl+], a                                   ; $6082
    ld a, [hl]                                    ; $6083
    or c                                          ; $6084
    ld [hl+], a                                   ; $6085
    ld a, [hl]                                    ; $6086
    or c                                          ; $6087
    ld [hl+], a                                   ; $6088
    ld a, [hl]                                    ; $6089
    or c                                          ; $608A
    ld [hl+], a                                   ; $608B
    ld a, [hl]                                    ; $608C
    or c                                          ; $608D
    ld [hl+], a                                   ; $608E
    ld a, [hl]                                    ; $608F
    or c                                          ; $6090
    ld [hl+], a                                   ; $6091
    ret                                           ; $6092


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutDash::
    ld a, $30                                     ; $6093
    ld [de], a                                    ; $6095
    inc de                                        ; $6096
    ret                                           ; $6097


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutDigitOrBlank::
    and a                                         ; $6098
    jr nz, jr_005_60a0                            ; $6099

    ld a, $4d                                     ; $609B
    ld [de], a                                    ; $609D
    inc de                                        ; $609E
    ret                                           ; $609F


jr_005_60a0:
    add $21                                       ; $60A0
    ld [de], a                                    ; $60A2
    inc de                                        ; $60A3
    ret                                           ; $60A4


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutNumber2::
    ld c, $00                                     ; $60A5

jr_005_60a7:
    cp $0a                                        ; $60A7
    jr c, jr_005_60b0                             ; $60A9

    sub $0a                                       ; $60AB
    inc c                                         ; $60AD
    jr jr_005_60a7                                ; $60AE

jr_005_60b0:
    push af                                       ; $60B0
    ld a, c                                       ; $60B1
    and a                                         ; $60B2
    jr z, jr_005_60b9                             ; $60B3

    add $21                                       ; $60B5
    ld [de], a                                    ; $60B7
    inc de                                        ; $60B8

jr_005_60b9:
    pop af                                        ; $60B9
    add $21                                       ; $60BA
    ld [de], a                                    ; $60BC
    inc de                                        ; $60BD
    ret                                           ; $60BE


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_print 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutTempo::
    ld bc, $0000                                  ; $60BF

jr_005_60c2:
    cp $64                                        ; $60C2
    jr c, jr_005_60cb                             ; $60C4

    sub $64                                       ; $60C6
    inc b                                         ; $60C8
    jr jr_005_60c2                                ; $60C9

jr_005_60cb:
    cp $0a                                        ; $60CB
    jr c, jr_005_60d4                             ; $60CD

    sub $0a                                       ; $60CF
    inc c                                         ; $60D1
    jr jr_005_60cb                                ; $60D2

jr_005_60d4:
    push af                                       ; $60D4
    ld a, b                                       ; $60D5
    and a                                         ; $60D6
    jr z, jr_005_60e0                             ; $60D7

    add $21                                       ; $60D9
    ld [de], a                                    ; $60DB
    inc de                                        ; $60DC
    ld a, c                                       ; $60DD
    jr jr_005_60e4                                ; $60DE

jr_005_60e0:
    ld a, c                                       ; $60E0
    and a                                         ; $60E1
    jr z, jr_005_60e8                             ; $60E2

jr_005_60e4:
    add $21                                       ; $60E4
    ld [de], a                                    ; $60E6
    inc de                                        ; $60E7

jr_005_60e8:
    pop af                                        ; $60E8
    add $21                                       ; $60E9
    ld [de], a                                    ; $60EB
    inc de                                        ; $60EC
    ret                                           ; $60ED


; C: HL = 20-character row of print glyph codes: expands it into the band at $C200 (space, digit, $4F/$9F, $F0+
; cases); entry used by every DjPrintRow_* builder (branch target; code read 2026-10-19)
DjPrint_RenderTextRow::
    ld de, wBandBuffer                            ; $60EE
    ld b, $14                                     ; $60F1

; C: per-character loop top of DjPrint_RenderTextRow (B counts the 20 characters) (branch target; code read
; 2026-10-19)
DjPrint_RenderTextRow_CharLoop::
    ld a, [hl+]                                   ; $60F3
    cp $20                                        ; $60F4
    jr z, jr_005_6128                             ; $60F6

    cp $30                                        ; $60F8
    jr z, jr_005_6142                             ; $60FA

    cp $5f                                        ; $60FC
    jr z, jr_005_6142                             ; $60FE

    cp $4f                                        ; $6100
    jr z, jr_005_615e                             ; $6102

    cp $9f                                        ; $6104
    jr z, jr_005_615e                             ; $6106

    cp $f0                                        ; $6108
    jr nc, jr_005_6178                            ; $610A

    push af                                       ; $610C
    call Gfx_Copy16FromBank10                     ; $610D
    ld a, e                                       ; $6110
    add $30                                       ; $6111
    ld e, a                                       ; $6113
    ld a, d                                       ; $6114
    adc $01                                       ; $6115
    ld d, a                                       ; $6117
    pop af                                        ; $6118
    add $10                                       ; $6119
    call Gfx_Copy16FromBank10                     ; $611B
    ld a, e                                       ; $611E
    sub $40                                       ; $611F
    ld e, a                                       ; $6121
    ld a, d                                       ; $6122
    sbc $01                                       ; $6123
    ld d, a                                       ; $6125
    jr jr_005_61a1                                ; $6126

jr_005_6128:
    call Gfx_Copy16FromBank10                     ; $6128
    ld a, e                                       ; $612B
    add $30                                       ; $612C
    ld e, a                                       ; $612E
    ld a, d                                       ; $612F
    adc $01                                       ; $6130
    ld d, a                                       ; $6132
    ld a, $9f                                     ; $6133
    call Gfx_Copy16FromBank10                     ; $6135
    ld a, e                                       ; $6138
    sub $40                                       ; $6139
    ld e, a                                       ; $613B
    ld a, d                                       ; $613C
    sbc $01                                       ; $613D
    ld d, a                                       ; $613F
    jr jr_005_61a1                                ; $6140

jr_005_6142:
    push af                                       ; $6142
    ld a, $9f                                     ; $6143
    call Gfx_Copy16FromBank10                     ; $6145
    ld a, e                                       ; $6148
    add $30                                       ; $6149
    ld e, a                                       ; $614B
    ld a, d                                       ; $614C
    adc $01                                       ; $614D
    ld d, a                                       ; $614F
    pop af                                        ; $6150
    call Gfx_Copy16FromBank10                     ; $6151
    ld a, e                                       ; $6154
    sub $40                                       ; $6155
    ld e, a                                       ; $6157
    ld a, d                                       ; $6158
    sbc $01                                       ; $6159
    ld d, a                                       ; $615B
    jr jr_005_61a1                                ; $615C

jr_005_615e:
    push af                                       ; $615E
    call Gfx_Copy16FromBank10                     ; $615F
    ld a, e                                       ; $6162
    add $30                                       ; $6163
    ld e, a                                       ; $6165
    ld a, d                                       ; $6166
    adc $01                                       ; $6167
    ld d, a                                       ; $6169
    pop af                                        ; $616A
    call Gfx_Copy16FromBank10                     ; $616B
    ld a, e                                       ; $616E
    sub $40                                       ; $616F
    ld e, a                                       ; $6171
    ld a, d                                       ; $6172
    sbc $01                                       ; $6173
    ld d, a                                       ; $6175
    jr jr_005_61a1                                ; $6176

jr_005_6178:
    push bc                                       ; $6178
    push hl                                       ; $6179
    and $0f                                       ; $617A
    sla a                                         ; $617C
    ld c, a                                       ; $617E
    ld b, $00                                     ; $617F
    ld hl, DjPrint_PutTempo_Tbl61A6               ; $6181
    add hl, bc                                    ; $6184
    ld a, [hl+]                                   ; $6185
    push hl                                       ; $6186
    call Gfx_Copy16FromBank10                     ; $6187
    ld a, e                                       ; $618A
    add $30                                       ; $618B
    ld e, a                                       ; $618D
    ld a, d                                       ; $618E
    adc $01                                       ; $618F
    ld d, a                                       ; $6191
    pop hl                                        ; $6192
    ld a, [hl]                                    ; $6193
    call Gfx_Copy16FromBank10                     ; $6194
    ld a, e                                       ; $6197
    sub $40                                       ; $6198
    ld e, a                                       ; $619A
    ld a, d                                       ; $619B
    sbc $01                                       ; $619C
    ld d, a                                       ; $619E
    pop hl                                        ; $619F
    pop bc                                        ; $61A0

jr_005_61a1:
    dec b                                         ; $61A1
    jp nz, DjPrint_RenderTextRow_CharLoop         ; $61A2

    ret                                           ; $61A5


; C: auto: 32 bytes, bytes; referenced by DjPrint_PutTempo. L3 pass 2026-10-26: read in BGB in the scenarios dj_print
; 1F:09 (tcrf_check/assets/l3_names/scen_hits*.csv)
DjPrint_PutTempo_Tbl61A6::
    db $9f, $2b, $9f, $9f, $9f, $3b, $9f, $9f, $4c, $2b, $4c, $9f, $4c, $3b, $9f, $9f
    db $5c, $2b, $5c, $9f, $5c, $3b, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f, $9f

; C: toggles the double buffer and loads the performer tiles
DjTitle_LoadPerformerGfx::
    ld a, [wDjTitlePerformerToggle]               ; $61C6
    inc a                                         ; $61C9
    and $01                                       ; $61CA
    ld [wDjTitlePerformerToggle], a               ; $61CC
    call DjTitle_PickGraphicsBank                 ; $61CF
    push af                                       ; $61D2
    ld c, $00                                     ; $61D3
    ldh [hFarcallAArg], a                         ; $61D5
    ld a, $05                                     ; $61D7
    ld hl, Photo_FarGetAddress                    ; $61D9
    call Far_Call                                 ; $61DC
    ld de, $8d80                                  ; $61DF
    ld bc, $0380                                  ; $61E2
    call Mem_CopyFromBank                         ; $61E5
    pop af                                        ; $61E8
    push af                                       ; $61E9
    ld c, $01                                     ; $61EA
    ldh [hFarcallAArg], a                         ; $61EC
    ld a, $05                                     ; $61EE
    ld hl, Photo_FarGetAddress                    ; $61F0
    call Far_Call                                 ; $61F3
    ld de, $9100                                  ; $61F6
    ld bc, $0380                                  ; $61F9
    call Mem_CopyFromBank                         ; $61FC
    pop af                                        ; $61FF
    ld c, $02                                     ; $6200
    ldh [hFarcallAArg], a                         ; $6202
    ld a, $05                                     ; $6204
    ld hl, Photo_FarGetAddress                    ; $6206
    call Far_Call                                 ; $6209
    ld de, $9480                                  ; $620C
    ld bc, $0380                                  ; $620F
    call Mem_CopyFromBank                         ; $6212
    ret                                           ; $6215


; C
DjEd_LoadPerformerTiles8D80::
    call DjTitle_PickGraphicsBank                 ; $6216
    ldh [hFarcallAArg], a                         ; $6219
    ld a, $05                                     ; $621B
    ld hl, Photo_FarGetAddress                    ; $621D
    call Far_Call                                 ; $6220
    ld de, $8d80                                  ; $6223
    ld bc, $0380                                  ; $6226
    call Vram_CopyFromBank_4                      ; $6229
    ret                                           ; $622C


; I: UNREFERENCED
Unused_DjEd_LoadPerformerTiles9100::
    call DjTitle_PickGraphicsBank                 ; $622D
    ldh [hFarcallAArg], a                         ; $6230
    ld a, $05                                     ; $6232
    ld hl, Photo_FarGetAddress                    ; $6234
    call Far_Call                                 ; $6237
    ld de, $9100                                  ; $623A
    ld bc, $0380                                  ; $623D
    call Vram_CopyFromBank_4                      ; $6240
    ret                                           ; $6243


; C
DjEd_LoadPerformerTiles9480::
    call DjTitle_PickGraphicsBank                 ; $6244
    ldh [hFarcallAArg], a                         ; $6247
    ld a, $05                                     ; $6249
    ld hl, Photo_FarGetAddress                    ; $624B
    call Far_Call                                 ; $624E
    ld de, $9480                                  ; $6251
    ld bc, $0380                                  ; $6254
    call Vram_CopyFromBank_4                      ; $6257
    ret                                           ; $625A


; C: bank for the performer set (hidden Game Face set when present)
DjTitle_PickGraphicsBank::
    push bc                                       ; $625B
    ld a, [wStartPerformerSet]                    ; $625C
    cp $02                                        ; $625F
    jr nz, jr_005_626d                            ; $6261

    ld hl, wGamefacePresent                       ; $6263
    bit 0, [hl]                                   ; $6266
    jr nz, jr_005_626d                            ; $6268

    ld a, [wDjTitlePerformerToggle]               ; $626A

jr_005_626d:
    ld c, a                                       ; $626D
    ld b, $00                                     ; $626E
    ld hl, DjTitle_PickGraphicsBank_Tbl6277       ; $6270
    add hl, bc                                    ; $6273
    ld a, [hl]                                    ; $6274
    pop bc                                        ; $6275
    ret                                           ; $6276


; C: auto: 3 bytes, bytes; referenced by DjTitle_PickGraphicsBank. L3 pass 2026-10-26: not reached by the 206 BGB
; replays; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode
; 1F)
DjTitle_PickGraphicsBank_Tbl6277::
    db $01, $02, $06

; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjEd_SetFieldCursor::
    ld c, a                                       ; $627A
    sla a                                         ; $627B
    add c                                         ; $627D
    ld c, a                                       ; $627E
    ld b, $00                                     ; $627F
    ld hl, DjEd_SetFieldCursor_Tbl62A3            ; $6281
    add hl, bc                                    ; $6284
    ld c, [hl]                                    ; $6285
    inc hl                                        ; $6286
    ld b, [hl]                                    ; $6287
    inc hl                                        ; $6288
    ld a, [hl]                                    ; $6289
    ld h, b                                       ; $628A
    ld l, c                                       ; $628B
    ld de, wSettingsPreset                        ; $628C
    ld bc, $0059                                  ; $628F
    call Mem_CopyFromBank                         ; $6292
    ld de, wSettingsPreset                        ; $6295
    ldh [hFarcallAArg], a                         ; $6298
    farcall Dj_LoadTune_FromDE_Far                ; $629A
    ret                                           ; $62A2


; C: auto: 15 bytes, bytes; referenced by DjEd_SetFieldCursor. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjEd_SetFieldCursor_Tbl62A3::
    dwb Map_29_6000_Map05_62A3
    dwb Map_29_6059_Map05_62A3
    dwb Map_29_6164_Map05_62A3
    dwb Map_29_610B_Map05_62A3
    dwb Map_29_60B2_Map05_62A3

; C
DjS1_DrawAllValues::
    ld a, [wSound1Envelope + $2]                  ; $62B2
    call DjEd_DrawVolumeDigits                    ; $62B5
    ld a, [wSound1Envelope + $1]                  ; $62B8
    call DjEd_DrawEnvPeriodDigit                  ; $62BB
    ld a, [wSound1DutyLen + $1]                   ; $62BE
    call DjEd_DrawLengthDigit                     ; $62C1
    ld a, [wSound1Modulation]                     ; $62C4
    call DjEd_DrawModDepthDigits                  ; $62C7
    ld a, [wSound1Modulation + $1]                ; $62CA
    call DjEd_DrawModSpeedDigits                  ; $62CD
    ld a, [wLoopLengths]                          ; $62D0
    call DjEd_DrawLoopDigitsAndPrint              ; $62D3
    ret                                           ; $62D6


; C
DjS1_DrawModAndLoop::
    ld a, [wSound1Modulation]                     ; $62D7
    call DjEd_DrawModDepthDigits                  ; $62DA
    ld a, [wSound1Modulation + $1]                ; $62DD
    call DjEd_DrawModSpeedDigits                  ; $62E0
    ld a, [wLoopLengths]                          ; $62E3
    call DjEd_DrawLoopDigitsAndPrint              ; $62E6
    ret                                           ; $62E9


; C: handler of the DjS1 field cursor value 0
DjS1_Field00_Duty::
    call DjS1_Field00_SyncCursor                  ; $62EA
    call DjS1_Field00_Edit                        ; $62ED
    call DjS1_Field00_DrawCursor                  ; $62F0
    ldh a, [hKeysNew]                             ; $62F3
    bit PADB_RIGHT, a                             ; $62F5
    jr z, jr_005_630d                             ; $62F7

    push af                                       ; $62F9
    ld a, $01                                     ; $62FA
    ld [wUiSfxRequest], a                         ; $62FC
    pop af                                        ; $62FF
    call DjS1_Field00_DrawMarker                  ; $6300
    ld a, $01                                     ; $6303
    ld [wSound1FieldCursor], a                    ; $6305
    xor a                                         ; $6308
    ld [wSndCursorPopFrames], a                   ; $6309
    ret                                           ; $630C


jr_005_630d:
    bit 7, a                                      ; $630D
    ret z                                         ; $630F

    push af                                       ; $6310
    ld a, $01                                     ; $6311
    ld [wUiSfxRequest], a                         ; $6313
    pop af                                        ; $6316
    call DjS1_Field00_DrawMarker                  ; $6317
    ld a, [wSound1FieldCursor]                    ; $631A
    ld [wSound1FieldCursor + $2], a               ; $631D
    ld a, $08                                     ; $6320
    ld [wSound1FieldCursor], a                    ; $6322
    xor a                                         ; $6325
    ld [wSndCursorPopFrames], a                   ; $6326
    ret                                           ; $6329


; C
DjS1_Field00_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $632A
    ld hl, wSound1FieldCursor + $1                ; $632D
    cp [hl]                                       ; $6330
    ret z                                         ; $6331

    ld [hl], a                                    ; $6332
    ld a, $51                                     ; $6333
    ld hl, $9861                                  ; $6335
    call Vram_WriteByteSafe                       ; $6338
    ld a, $51                                     ; $633B
    ld hl, $9881                                  ; $633D
    call Vram_WriteByteSafe                       ; $6340
    ld a, $51                                     ; $6343
    ld hl, $98a1                                  ; $6345
    call Vram_WriteByteSafe                       ; $6348
    ret                                           ; $634B


; C
DjS1_Field00_Edit::
    ld a, [wSound1DutyLen]                        ; $634C
    ld bc, $0002                                  ; $634F
    call DjEd_StepValue_Up                        ; $6352
    ld hl, wSound1DutyLen                         ; $6355
    cp [hl]                                       ; $6358
    ret z                                         ; $6359

    ld [hl], a                                    ; $635A
    ret                                           ; $635B


; C
DjS1_Field00_DrawCursor::
    ld bc, $051c                                  ; $635C
    ld a, $92                                     ; $635F
    call DjEd_DrawFieldCursor                     ; $6361
    ldh a, [hFrameCounter]                        ; $6364
    bit 4, a                                      ; $6366
    ret z                                         ; $6368

    ld a, [wSound1DutyLen]                        ; $6369
    swap a                                        ; $636C
    srl a                                         ; $636E
    add $20                                       ; $6370
    ld c, a                                       ; $6372
    ld b, $09                                     ; $6373
    ld a, $79                                     ; $6375
    call Oam_AddMeta_B01_5D47                     ; $6377
    ret                                           ; $637A


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the SOUND I duty marker (tile $C9 in the row of wSound1DutyLen)
DjS1_Field00_DrawMarker::
    ld a, [wSound1DutyLen]                        ; $637B
    swap a                                        ; $637E
    sla a                                         ; $6380
    ld c, a                                       ; $6382
    ld b, $00                                     ; $6383
    ld hl, $9861                                  ; $6385
    add hl, bc                                    ; $6388
    ld a, $c9                                     ; $6389
    call Vram_WriteByteSafe                       ; $638B
    ret                                           ; $638E


; C: handler of the DjS1 field cursor value 1
DjS1_Field01_EnvDir::
    call DjS1_Field01_SyncCursor                  ; $638F
    call DjS1_Field01_Edit                        ; $6392
    call DjS1_Field01_DrawCursor                  ; $6395
    ldh a, [hKeysNew]                             ; $6398
    bit PADB_LEFT, a                              ; $639A
    jr z, jr_005_63af                             ; $639C

    push af                                       ; $639E
    ld a, $01                                     ; $639F
    ld [wUiSfxRequest], a                         ; $63A1
    pop af                                        ; $63A4
    ld a, $00                                     ; $63A5
    ld [wSound1FieldCursor], a                    ; $63A7
    xor a                                         ; $63AA
    ld [wSndCursorPopFrames], a                   ; $63AB
    ret                                           ; $63AE


jr_005_63af:
    bit 4, a                                      ; $63AF
    jr z, jr_005_63c0                             ; $63B1

    push af                                       ; $63B3
    ld a, $01                                     ; $63B4
    ld [wUiSfxRequest], a                         ; $63B6
    pop af                                        ; $63B9
    ld a, $02                                     ; $63BA
    ld [wSound1FieldCursor], a                    ; $63BC
    ret                                           ; $63BF


jr_005_63c0:
    bit 7, a                                      ; $63C0
    ret z                                         ; $63C2

    push af                                       ; $63C3
    ld a, $01                                     ; $63C4
    ld [wUiSfxRequest], a                         ; $63C6
    pop af                                        ; $63C9
    ld a, [wSound1FieldCursor]                    ; $63CA
    ld [wSound1FieldCursor + $2], a               ; $63CD
    ld a, $08                                     ; $63D0
    ld [wSound1FieldCursor], a                    ; $63D2
    xor a                                         ; $63D5
    ld [wSndCursorPopFrames], a                   ; $63D6
    ret                                           ; $63D9


; C
DjS1_Field01_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $63DA
    ld hl, wSound1FieldCursor + $1                ; $63DD
    cp [hl]                                       ; $63E0
    ret z                                         ; $63E1

    ld [hl], a                                    ; $63E2
    ret                                           ; $63E3


; C
DjS1_Field01_Edit::
    ld a, [wSound1Envelope]                       ; $63E4
    ld bc, $0001                                  ; $63E7
    call DjEd_StepValue_Up                        ; $63EA
    ld hl, wSound1Envelope                        ; $63ED
    cp [hl]                                       ; $63F0
    ret z                                         ; $63F1

    ld [hl], a                                    ; $63F2
    ld hl, $9884                                  ; $63F3
    add $da                                       ; $63F6
    call Vram_WriteByteSafe                       ; $63F8
    ret                                           ; $63FB


; C
DjS1_Field01_DrawCursor::
    ld bc, $1c1c                                  ; $63FC
    ld a, $95                                     ; $63FF
    call DjEd_DrawFieldCursor                     ; $6401
    ldh a, [hFrameCounter]                        ; $6404
    bit 4, a                                      ; $6406
    ret z                                         ; $6408

    ld a, [wSound1Envelope]                       ; $6409
    sla a                                         ; $640C
    sla a                                         ; $640E
    add $26                                       ; $6410
    ld c, a                                       ; $6412
    ld b, $22                                     ; $6413
    ld a, $78                                     ; $6415
    call Oam_AddMeta_B01_5D47                     ; $6417
    ret                                           ; $641A


; C: handler of the DjS1 field cursor value 2
DjS1_Field02_Volume::
    call DjS1_Field02_SyncCursor                  ; $641B
    call DjS1_Field02_Edit                        ; $641E
    call DjS1_Field02_DrawCursor                  ; $6421
    ldh a, [hKeysNew]                             ; $6424
    bit PADB_LEFT, a                              ; $6426
    jr z, jr_005_6437                             ; $6428

    push af                                       ; $642A
    ld a, $01                                     ; $642B
    ld [wUiSfxRequest], a                         ; $642D
    pop af                                        ; $6430
    ld a, $01                                     ; $6431
    ld [wSound1FieldCursor], a                    ; $6433
    ret                                           ; $6436


jr_005_6437:
    bit 4, a                                      ; $6437
    jr z, jr_005_6448                             ; $6439

    push af                                       ; $643B
    ld a, $01                                     ; $643C
    ld [wUiSfxRequest], a                         ; $643E
    pop af                                        ; $6441
    ld a, $03                                     ; $6442
    ld [wSound1FieldCursor], a                    ; $6444
    ret                                           ; $6447


jr_005_6448:
    bit 7, a                                      ; $6448
    ret z                                         ; $644A

    push af                                       ; $644B
    ld a, $01                                     ; $644C
    ld [wUiSfxRequest], a                         ; $644E
    pop af                                        ; $6451
    ld a, [wSound1FieldCursor]                    ; $6452
    ld [wSound1FieldCursor + $2], a               ; $6455
    ld a, $08                                     ; $6458
    ld [wSound1FieldCursor], a                    ; $645A
    xor a                                         ; $645D
    ld [wSndCursorPopFrames], a                   ; $645E
    ret                                           ; $6461


; C
DjS1_Field02_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6462
    ld hl, wSound1FieldCursor + $1                ; $6465
    cp [hl]                                       ; $6468
    ret z                                         ; $6469

    ld [hl], a                                    ; $646A
    ret                                           ; $646B


; C
DjS1_Field02_Edit::
    ld a, [wSound1Envelope + $2]                  ; $646C
    ld bc, $000f                                  ; $646F
    call DjEd_StepValue_Right                     ; $6472
    ld hl, wSound1Envelope + $2                   ; $6475
    cp [hl]                                       ; $6478
    ret z                                         ; $6479

    ld [hl], a                                    ; $647A
    ret                                           ; $647B


; C
DjS1_Field02_DrawCursor::
    ld bc, $1c1c                                  ; $647C
    ld a, $95                                     ; $647F
    call DjEd_DrawFieldCursor                     ; $6481
    ldh a, [hFrameCounter]                        ; $6484
    bit 4, a                                      ; $6486
    ret z                                         ; $6488

    ld bc, $312c                                  ; $6489
    ld a, $7d                                     ; $648C
    call Oam_AddMeta_B01_5D47                     ; $648E
    ret                                           ; $6491


; C: handler of the DjS1 field cursor value 3
DjS1_Field03_EnvPeriod::
    call DjS1_Field03_SyncCursor                  ; $6492
    call DjS1_Field03_Edit                        ; $6495
    call DjS1_Field03_DrawCursor                  ; $6498
    ldh a, [hKeysNew]                             ; $649B
    bit PADB_LEFT, a                              ; $649D
    jr z, jr_005_64ae                             ; $649F

    push af                                       ; $64A1
    ld a, $01                                     ; $64A2
    ld [wUiSfxRequest], a                         ; $64A4
    pop af                                        ; $64A7
    ld a, $02                                     ; $64A8
    ld [wSound1FieldCursor], a                    ; $64AA
    ret                                           ; $64AD


jr_005_64ae:
    bit 4, a                                      ; $64AE
    jr z, jr_005_64bf                             ; $64B0

    push af                                       ; $64B2
    ld a, $01                                     ; $64B3
    ld [wUiSfxRequest], a                         ; $64B5
    pop af                                        ; $64B8
    ld a, $04                                     ; $64B9
    ld [wSound1FieldCursor], a                    ; $64BB
    ret                                           ; $64BE


jr_005_64bf:
    bit 7, a                                      ; $64BF
    ret z                                         ; $64C1

    push af                                       ; $64C2
    ld a, $01                                     ; $64C3
    ld [wUiSfxRequest], a                         ; $64C5
    pop af                                        ; $64C8
    ld a, [wSound1FieldCursor]                    ; $64C9
    ld [wSound1FieldCursor + $2], a               ; $64CC
    ld a, $08                                     ; $64CF
    ld [wSound1FieldCursor], a                    ; $64D1
    xor a                                         ; $64D4
    ld [wSndCursorPopFrames], a                   ; $64D5
    ret                                           ; $64D8


; C
DjS1_Field03_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $64D9
    ld hl, wSound1FieldCursor + $1                ; $64DC
    cp [hl]                                       ; $64DF
    ret z                                         ; $64E0

    ld [hl], a                                    ; $64E1
    ret                                           ; $64E2


; C
DjS1_Field03_Edit::
    ld a, [wSound1Envelope + $1]                  ; $64E3
    ld bc, $0007                                  ; $64E6
    call DjEd_StepValue_Right                     ; $64E9
    ld hl, wSound1Envelope + $1                   ; $64EC
    cp [hl]                                       ; $64EF
    ret z                                         ; $64F0

    ld [hl], a                                    ; $64F1
    ret                                           ; $64F2


; C
DjS1_Field03_DrawCursor::
    ld bc, $1c1c                                  ; $64F3
    ld a, $95                                     ; $64F6
    call DjEd_DrawFieldCursor                     ; $64F8
    ldh a, [hFrameCounter]                        ; $64FB
    bit 4, a                                      ; $64FD
    ret z                                         ; $64FF

    ld bc, $422c                                  ; $6500
    ld a, $7d                                     ; $6503
    call Oam_AddMeta_B01_5D47                     ; $6505
    ret                                           ; $6508


; C: handler of the DjS1 field cursor value 4
DjS1_Field04_Length::
    call DjS1_Field04_SyncCursor                  ; $6509
    call DjS1_Field04_Edit                        ; $650C
    call DjS1_Field04_DrawCursor                  ; $650F
    ldh a, [hKeysNew]                             ; $6512
    bit PADB_LEFT, a                              ; $6514
    jr z, jr_005_6525                             ; $6516

    push af                                       ; $6518
    ld a, $01                                     ; $6519
    ld [wUiSfxRequest], a                         ; $651B
    pop af                                        ; $651E
    ld a, $03                                     ; $651F
    ld [wSound1FieldCursor], a                    ; $6521
    ret                                           ; $6524


jr_005_6525:
    bit 4, a                                      ; $6525
    jr z, jr_005_653a                             ; $6527

    push af                                       ; $6529
    ld a, $01                                     ; $652A
    ld [wUiSfxRequest], a                         ; $652C
    pop af                                        ; $652F
    ld a, $05                                     ; $6530
    ld [wSound1FieldCursor], a                    ; $6532
    xor a                                         ; $6535
    ld [wSndCursorPopFrames], a                   ; $6536
    ret                                           ; $6539


jr_005_653a:
    bit 7, a                                      ; $653A
    ret z                                         ; $653C

    push af                                       ; $653D
    ld a, $01                                     ; $653E
    ld [wUiSfxRequest], a                         ; $6540
    pop af                                        ; $6543
    ld a, [wSound1FieldCursor]                    ; $6544
    ld [wSound1FieldCursor + $2], a               ; $6547
    ld a, $08                                     ; $654A
    ld [wSound1FieldCursor], a                    ; $654C
    xor a                                         ; $654F
    ld [wSndCursorPopFrames], a                   ; $6550
    ret                                           ; $6553


; C
DjS1_Field04_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6554
    ld hl, wSound1FieldCursor + $1                ; $6557
    cp [hl]                                       ; $655A
    ret z                                         ; $655B

    ld [hl], a                                    ; $655C
    ret                                           ; $655D


; C
DjS1_Field04_Edit::
    ld a, [wSound1DutyLen + $1]                   ; $655E
    ld bc, $0009                                  ; $6561
    call DjEd_StepValue_Right                     ; $6564
    ld hl, wSound1DutyLen + $1                    ; $6567
    cp [hl]                                       ; $656A
    ret z                                         ; $656B

    ld [hl], a                                    ; $656C
    ret                                           ; $656D


; C
DjS1_Field04_DrawCursor::
    ld bc, $1c1c                                  ; $656E
    ld a, $95                                     ; $6571
    call DjEd_DrawFieldCursor                     ; $6573
    ldh a, [hFrameCounter]                        ; $6576
    bit 4, a                                      ; $6578
    ret z                                         ; $657A

    ld bc, $5a2a                                  ; $657B
    ld a, $7d                                     ; $657E
    call Oam_AddMeta_B01_5D47                     ; $6580
    ret                                           ; $6583


; C: handler of the DjS1 field cursor value 5
DjS1_Field05_ModDepth::
    call DjS1_Field05_SyncCursor                  ; $6584
    call DjS1_Field05_Edit                        ; $6587
    call DjS1_Field05_DrawCursor                  ; $658A
    ldh a, [hKeysNew]                             ; $658D
    bit PADB_LEFT, a                              ; $658F
    jr z, jr_005_65a4                             ; $6591

    push af                                       ; $6593
    ld a, $01                                     ; $6594
    ld [wUiSfxRequest], a                         ; $6596
    pop af                                        ; $6599
    ld a, $04                                     ; $659A
    ld [wSound1FieldCursor], a                    ; $659C
    xor a                                         ; $659F
    ld [wSndCursorPopFrames], a                   ; $65A0
    ret                                           ; $65A3


jr_005_65a4:
    bit 4, a                                      ; $65A4
    jr z, jr_005_65b5                             ; $65A6

    push af                                       ; $65A8
    ld a, $01                                     ; $65A9
    ld [wUiSfxRequest], a                         ; $65AB
    pop af                                        ; $65AE
    ld a, $06                                     ; $65AF
    ld [wSound1FieldCursor], a                    ; $65B1
    ret                                           ; $65B4


jr_005_65b5:
    bit 7, a                                      ; $65B5
    ret z                                         ; $65B7

    push af                                       ; $65B8
    ld a, $01                                     ; $65B9
    ld [wUiSfxRequest], a                         ; $65BB
    pop af                                        ; $65BE
    ld a, [wSound1FieldCursor]                    ; $65BF
    ld [wSound1FieldCursor + $2], a               ; $65C2
    ld a, $08                                     ; $65C5
    ld [wSound1FieldCursor], a                    ; $65C7
    xor a                                         ; $65CA
    ld [wSndCursorPopFrames], a                   ; $65CB
    ret                                           ; $65CE


; C
DjS1_Field05_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $65CF
    ld hl, wSound1FieldCursor + $1                ; $65D2
    cp [hl]                                       ; $65D5
    ret z                                         ; $65D6

    ld [hl], a                                    ; $65D7
    ret                                           ; $65D8


; C
DjS1_Field05_Edit::
    ld a, [wSound1Modulation]                     ; $65D9
    ld bc, $0063                                  ; $65DC
    call DjEd_StepValue_Right                     ; $65DF
    ld [wSound1Modulation], a                     ; $65E2
    ret                                           ; $65E5


; C
DjS1_Field05_DrawCursor::
    ld bc, $661c                                  ; $65E6
    ld a, $98                                     ; $65E9
    call DjEd_DrawFieldCursor                     ; $65EB
    ldh a, [hFrameCounter]                        ; $65EE
    bit 4, a                                      ; $65F0
    ret z                                         ; $65F2

    ld bc, $6e2c                                  ; $65F3
    ld a, $7d                                     ; $65F6
    call Oam_AddMeta_B01_5D47                     ; $65F8
    ret                                           ; $65FB


; C: handler of the DjS1 field cursor value 6
DjS1_Field06_ModSpeed::
    call DjS1_Field06_SyncCursor                  ; $65FC
    call DjS1_Field06_Edit                        ; $65FF
    call DjS1_Field06_DrawCursor                  ; $6602
    ldh a, [hKeysNew]                             ; $6605
    bit PADB_LEFT, a                              ; $6607
    jr z, jr_005_6618                             ; $6609

    push af                                       ; $660B
    ld a, $01                                     ; $660C
    ld [wUiSfxRequest], a                         ; $660E
    pop af                                        ; $6611
    ld a, $05                                     ; $6612
    ld [wSound1FieldCursor], a                    ; $6614
    ret                                           ; $6617


jr_005_6618:
    bit 4, a                                      ; $6618
    jr z, jr_005_6629                             ; $661A

    push af                                       ; $661C
    ld a, $01                                     ; $661D
    ld [wUiSfxRequest], a                         ; $661F
    pop af                                        ; $6622
    ld a, $07                                     ; $6623
    ld [wSound1FieldCursor], a                    ; $6625
    ret                                           ; $6628


jr_005_6629:
    bit 7, a                                      ; $6629
    ret z                                         ; $662B

    push af                                       ; $662C
    ld a, $01                                     ; $662D
    ld [wUiSfxRequest], a                         ; $662F
    pop af                                        ; $6632
    ld a, [wSound1FieldCursor]                    ; $6633
    ld [wSound1FieldCursor + $2], a               ; $6636
    ld a, $08                                     ; $6639
    ld [wSound1FieldCursor], a                    ; $663B
    xor a                                         ; $663E
    ld [wSndCursorPopFrames], a                   ; $663F
    ret                                           ; $6642


; C
DjS1_Field06_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6643
    ld hl, wSound1FieldCursor + $1                ; $6646
    cp [hl]                                       ; $6649
    ret z                                         ; $664A

    ld [hl], a                                    ; $664B
    ret                                           ; $664C


; C
DjS1_Field06_Edit::
    ld a, [wSound1Modulation + $1]                ; $664D
    ld bc, $0063                                  ; $6650
    call DjEd_StepValue_Right                     ; $6653
    ld [wSound1Modulation + $1], a                ; $6656
    ret                                           ; $6659


; C
DjS1_Field06_DrawCursor::
    ld bc, $661c                                  ; $665A
    ld a, $98                                     ; $665D
    call DjEd_DrawFieldCursor                     ; $665F
    ldh a, [hFrameCounter]                        ; $6662
    bit 4, a                                      ; $6664
    ret z                                         ; $6666

    ld bc, $802c                                  ; $6667
    ld a, $7d                                     ; $666A
    call Oam_AddMeta_B01_5D47                     ; $666C
    ret                                           ; $666F


; C: handler of the DjS1 field cursor value 7
DjS1_Field07_ModMode::
    call DjS1_Field07_SyncCursor                  ; $6670
    call DjS1_Field07_Edit                        ; $6673
    call DjS1_Field07_DrawCursor                  ; $6676
    ldh a, [hKeysNew]                             ; $6679
    bit PADB_LEFT, a                              ; $667B
    jr z, jr_005_668f                             ; $667D

    push af                                       ; $667F
    ld a, $01                                     ; $6680
    ld [wUiSfxRequest], a                         ; $6682
    pop af                                        ; $6685
    call DjS1_Field07_DrawMarker                  ; $6686
    ld a, $06                                     ; $6689
    ld [wSound1FieldCursor], a                    ; $668B
    ret                                           ; $668E


jr_005_668f:
    bit 7, a                                      ; $668F
    ret z                                         ; $6691

    push af                                       ; $6692
    ld a, $01                                     ; $6693
    ld [wUiSfxRequest], a                         ; $6695
    pop af                                        ; $6698
    call DjS1_Field07_DrawMarker                  ; $6699
    ld a, [wSound1FieldCursor]                    ; $669C
    ld [wSound1FieldCursor + $2], a               ; $669F
    ld a, $08                                     ; $66A2
    ld [wSound1FieldCursor], a                    ; $66A4
    xor a                                         ; $66A7
    ld [wSndCursorPopFrames], a                   ; $66A8
    ret                                           ; $66AB


; C
DjS1_Field07_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $66AC
    ld hl, wSound1FieldCursor + $1                ; $66AF
    cp [hl]                                       ; $66B2
    ret z                                         ; $66B3

    ld [hl], a                                    ; $66B4
    ld a, $55                                     ; $66B5
    ld hl, $9871                                  ; $66B7
    call Vram_WriteByteSafe                       ; $66BA
    ld a, $55                                     ; $66BD
    ld hl, $9891                                  ; $66BF
    call Vram_WriteByteSafe                       ; $66C2
    ld a, $55                                     ; $66C5
    ld hl, $98b1                                  ; $66C7
    call Vram_WriteByteSafe                       ; $66CA
    ret                                           ; $66CD


; C
DjS1_Field07_Edit::
    ld a, [wSound1Modulation + $2]                ; $66CE
    ld bc, $0002                                  ; $66D1
    call DjEd_StepValue_Up                        ; $66D4
    ld [wSound1Modulation + $2], a                ; $66D7
    ret                                           ; $66DA


; C
DjS1_Field07_DrawCursor::
    ld bc, $661c                                  ; $66DB
    ld a, $98                                     ; $66DE
    call DjEd_DrawFieldCursor                     ; $66E0
    ldh a, [hFrameCounter]                        ; $66E3
    bit 4, a                                      ; $66E5
    ret z                                         ; $66E7

    ld a, [wSound1Modulation + $2]                ; $66E8
    swap a                                        ; $66EB
    srl a                                         ; $66ED
    add $21                                       ; $66EF
    ld c, a                                       ; $66F1
    ld b, $8d                                     ; $66F2
    ld a, $79                                     ; $66F4
    call Oam_AddMeta_B01_5D47                     ; $66F6
    ret                                           ; $66F9


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND I field 7 (modulation mode)
DjS1_Field07_DrawMarker::
    ld a, [wSound1Modulation + $2]                ; $66FA
    swap a                                        ; $66FD
    sla a                                         ; $66FF
    ld c, a                                       ; $6701
    ld b, $00                                     ; $6702
    ld hl, $9871                                  ; $6704
    add hl, bc                                    ; $6707
    ld a, $ca                                     ; $6708
    call Vram_WriteByteSafe                       ; $670A
    ret                                           ; $670D


; C: handler of the DjS1 field cursor value 8
DjS1_Field08_LoopLength::
    call DjS1_Field08_SyncCursor                  ; $670E
    call DjS1_Field08_Edit                        ; $6711
    call DjS1_Field08_DrawCursor                  ; $6714
    ldh a, [hKeysNew]                             ; $6717
    bit PADB_UP, a                                ; $6719
    jr z, jr_005_672f                             ; $671B

    push af                                       ; $671D
    ld a, $01                                     ; $671E
    ld [wUiSfxRequest], a                         ; $6720
    pop af                                        ; $6723
    ld a, [wSound1FieldCursor + $2]               ; $6724
    ld [wSound1FieldCursor], a                    ; $6727
    xor a                                         ; $672A
    ld [wSndCursorPopFrames], a                   ; $672B
    ret                                           ; $672E


jr_005_672f:
    bit 7, a                                      ; $672F
    ret z                                         ; $6731

    push af                                       ; $6732
    ld a, $01                                     ; $6733
    ld [wUiSfxRequest], a                         ; $6735
    pop af                                        ; $6738
    call DjEd_DrawLoopBar                         ; $6739
    ld a, $09                                     ; $673C
    ld [wSound1FieldCursor], a                    ; $673E
    xor a                                         ; $6741
    ld [wSndCursorPopFrames], a                   ; $6742
    ret                                           ; $6745


; C
DjS1_Field08_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $6746
    ld hl, wSound1FieldCursor + $1                ; $6749
    cp [hl]                                       ; $674C
    ret z                                         ; $674D

    ld [hl], a                                    ; $674E
    ret                                           ; $674F


; C
DjS1_Field08_Edit::
    ld a, [wLoopLengths]                          ; $6750
    ld bc, $0210                                  ; $6753
    call DjEd_StepValue_Right                     ; $6756
    ld [wLoopLengths], a                          ; $6759
    ld a, [wLoopLengths]                          ; $675C
    ld bc, $0210                                  ; $675F
    call DjEd_StepValue_LeftRight                 ; $6762
    ld [wLoopLengths], a                          ; $6765
    ret                                           ; $6768


; C
DjS1_Field08_DrawCursor::
    ld bc, $053d                                  ; $6769
    ld a, $9b                                     ; $676C
    call DjEd_DrawFieldCursor                     ; $676E
    ldh a, [hFrameCounter]                        ; $6771
    bit 4, a                                      ; $6773
    ret z                                         ; $6775

    ld bc, $0e46                                  ; $6776
    ld a, $7d                                     ; $6779
    call Oam_AddMeta_B01_5D47                     ; $677B
    ret                                           ; $677E


; C: handler of the DjS1 field cursor value 9
DjS1_Field09_NoteGrid::
    call DjS1_Field09_SyncCursor                  ; $677F
    call DjS1_Field09_Edit                        ; $6782
    call DjS1_Field09_DrawCursor                  ; $6785
    ldh a, [hKeysNew]                             ; $6788
    bit PADB_UP, a                                ; $678A
    jr z, jr_005_679f                             ; $678C

    push af                                       ; $678E
    ld a, $01                                     ; $678F
    ld [wUiSfxRequest], a                         ; $6791
    pop af                                        ; $6794
    ld a, $08                                     ; $6795
    ld [wSound1FieldCursor], a                    ; $6797
    xor a                                         ; $679A
    ld [wSndCursorPopFrames], a                   ; $679B
    ret                                           ; $679E


jr_005_679f:
    bit 3, a                                      ; $679F
    jr z, jr_005_67b0                             ; $67A1

    push af                                       ; $67A3
    ld a, $04                                     ; $67A4
    ld [wUiSfxRequest], a                         ; $67A6
    pop af                                        ; $67A9
    ld a, $0b                                     ; $67AA
    ld [wSound1FieldCursor], a                    ; $67AC
    ret                                           ; $67AF


jr_005_67b0:
    bit 0, a                                      ; $67B0
    ret z                                         ; $67B2

    push af                                       ; $67B3
    ld a, $04                                     ; $67B4
    ld [wUiSfxRequest], a                         ; $67B6
    pop af                                        ; $67B9
    ld a, $0a                                     ; $67BA
    ld [wSound1FieldCursor], a                    ; $67BC
    ret                                           ; $67BF


; C
DjS1_Field09_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $67C0
    ld hl, wSound1FieldCursor + $1                ; $67C3
    cp [hl]                                       ; $67C6
    ret z                                         ; $67C7

    ld [hl], a                                    ; $67C8
    ret                                           ; $67C9


; C
DjS1_Field09_Edit::
    ld a, [wSound1NoteCursor]                     ; $67CA
    ld bc, $000f                                  ; $67CD
    call DjEd_StepLeftRight                       ; $67D0
    ld [wSound1NoteCursor], a                     ; $67D3
    ld a, [wSound1NoteCursor]                     ; $67D6
    ld c, a                                       ; $67D9
    ld b, $00                                     ; $67DA
    ld hl, wSound1Notes                           ; $67DC
    add hl, bc                                    ; $67DF
    ldh a, [hKeysNew]                             ; $67E0
    bit PADB_DOWN, a                              ; $67E2
    ret z                                         ; $67E4

    xor a                                         ; $67E5
    ld [hl], a                                    ; $67E6
    ld a, [wSound1NoteCursor]                     ; $67E7
    ld hl, wSound1Notes                           ; $67EA
    call DjEd_DrawNoteRowOffset                   ; $67ED
    ret                                           ; $67F0


; C
DjS1_Field09_DrawCursor::
    ld bc, $0557                                  ; $67F1
    ld a, $9e                                     ; $67F4
    call DjEd_DrawFieldCursor                     ; $67F6
    ldh a, [hFrameCounter]                        ; $67F9
    bit 4, a                                      ; $67FB
    jr z, jr_005_6812                             ; $67FD

    ld a, [wSound1NoteCursor]                     ; $67FF
    sla a                                         ; $6802
    sla a                                         ; $6804
    sla a                                         ; $6806
    add $1d                                       ; $6808
    ld b, a                                       ; $680A
    ld c, $57                                     ; $680B
    ld a, $7c                                     ; $680D
    call Oam_AddMeta_B01_5D47                     ; $680F

jr_005_6812:
    ld a, [wSound1NoteCursor]                     ; $6812
    call DjEd_DrawNoteMarker                      ; $6815
    ld hl, wSound1Notes                           ; $6818
    ld a, [wSound1NoteCursor]                     ; $681B
    call DjEd_DrawNoteStepCursor                  ; $681E
    ld e, $00                                     ; $6821
    ld hl, wSound1Stereo                          ; $6823
    ld a, [wSound1NoteCursor]                     ; $6826
    call DjEd_DrawNoteColumn                      ; $6829
    ret                                           ; $682C


; C: handler of the DjS1 field cursor value 10
DjS1_Field0A_NoteEdit::
    call DjS1_Field0A_SyncCursor                  ; $682D
    call DjS1_Field0A_Edit                        ; $6830
    call DjS1_Field0A_DrawCursor                  ; $6833
    ldh a, [hKeysHeld]                            ; $6836
    bit PADB_A, a                                 ; $6838
    ret nz                                        ; $683A

    push af                                       ; $683B
    ld a, $05                                     ; $683C
    ld [wUiSfxRequest], a                         ; $683E
    pop af                                        ; $6841
    call DjS1_Field0A_DrawMarker                  ; $6842
    ld a, $09                                     ; $6845
    ld [wSound1FieldCursor], a                    ; $6847
    ret                                           ; $684A


; C
DjS1_Field0A_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $684B
    ld hl, wSound1FieldCursor + $1                ; $684E
    cp [hl]                                       ; $6851
    ret z                                         ; $6852

    ld [hl], a                                    ; $6853
    ret                                           ; $6854


; C
DjS1_Field0A_Edit::
    ld a, [wSound1NoteCursor]                     ; $6855
    ld c, a                                       ; $6858
    ld b, $00                                     ; $6859
    ld hl, wSound1Notes                           ; $685B
    add hl, bc                                    ; $685E
    ld bc, $0025                                  ; $685F
    ld a, [hl]                                    ; $6862
    push hl                                       ; $6863
    call DjEd_StepLeftRight                       ; $6864
    pop hl                                        ; $6867
    cp [hl]                                       ; $6868
    ret z                                         ; $6869

    ld [hl], a                                    ; $686A
    call DjS1_Field0A_DrawMarker                  ; $686B
    ret                                           ; $686E


; C
DjS1_Field0A_DrawCursor::
    ld bc, $0557                                  ; $686F
    ld a, $9e                                     ; $6872
    call DjEd_DrawFieldCursor                     ; $6874
    ld hl, wSound1Notes                           ; $6877
    ld a, [wSound1NoteCursor]                     ; $687A
    call DjEd_DrawNoteStepCursor                  ; $687D
    ldh a, [hKeysHeld]                            ; $6880
    and PADF_RIGHT | PADF_LEFT                    ; $6882
    ld hl, wSound1Notes                           ; $6884
    ld a, [wSound1NoteCursor]                     ; $6887
    call z, DjEd_DrawNoteCursorBlink              ; $688A
    ld a, [wSound1NoteCursor]                     ; $688D
    sla a                                         ; $6890
    sla a                                         ; $6892
    sla a                                         ; $6894
    add $1d                                       ; $6896
    ld b, a                                       ; $6898
    ld c, $57                                     ; $6899
    ld a, $7c                                     ; $689B
    call Oam_AddMeta_B01_5D47                     ; $689D
    ld e, $00                                     ; $68A0
    ld hl, wSound1Stereo                          ; $68A2
    ld a, [wSound1NoteCursor]                     ; $68A5
    call DjEd_DrawNoteColumn                      ; $68A8
    ret                                           ; $68AB


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND I field 10 (note edit)
DjS1_Field0A_DrawMarker::
    ld a, [wSound1NoteCursor]                     ; $68AC
    ld hl, wSound1Notes                           ; $68AF
    call DjEd_DrawNoteRowOffset                   ; $68B2
    ret                                           ; $68B5


; C: handler of the DjS1 field cursor value 11
DjS1_Field0B_StereoEdit::
    call DjS1_Field0B_SyncCursor                  ; $68B6
    call DjS1_Field0B_Edit                        ; $68B9
    call DjS1_Field0B_DrawCursor                  ; $68BC
    ldh a, [hKeysHeld]                            ; $68BF
    bit PADB_START, a                             ; $68C1
    ret nz                                        ; $68C3

    push af                                       ; $68C4
    ld a, $05                                     ; $68C5
    ld [wUiSfxRequest], a                         ; $68C7
    pop af                                        ; $68CA
    ld a, $09                                     ; $68CB
    ld [wSound1FieldCursor], a                    ; $68CD
    ret                                           ; $68D0


; C
DjS1_Field0B_SyncCursor::
    ld a, [wSound1FieldCursor]                    ; $68D1
    ld hl, wSound1FieldCursor + $1                ; $68D4
    cp [hl]                                       ; $68D7
    ret z                                         ; $68D8

    ld [hl], a                                    ; $68D9
    ld a, [wSound1NoteCursor]                     ; $68DA
    ld c, a                                       ; $68DD
    ld b, $00                                     ; $68DE
    ld hl, wSound1Stereo                          ; $68E0
    add hl, bc                                    ; $68E3
    ld a, [hl]                                    ; $68E4
    and $03                                       ; $68E5
    ld [wSound1StereoEdit], a                     ; $68E7
    ret                                           ; $68EA


; C
DjS1_Field0B_Edit::
    ld a, [wSound1StereoEdit]                     ; $68EB
    ld bc, $0002                                  ; $68EE
    call DjEd_StepLeftRight                       ; $68F1
    ld [wSound1StereoEdit], a                     ; $68F4
    ld a, [wSound1NoteCursor]                     ; $68F7
    ld c, a                                       ; $68FA
    ld b, $00                                     ; $68FB
    ld hl, wSound1Stereo                          ; $68FD
    add hl, bc                                    ; $6900
    ld a, [wSound1StereoEdit]                     ; $6901
    ld [hl], a                                    ; $6904
    ret                                           ; $6905


; C
DjS1_Field0B_DrawCursor::
    ld bc, $0557                                  ; $6906
    ld a, $9e                                     ; $6909
    call DjEd_DrawFieldCursor                     ; $690B
    ld a, [wSound1NoteCursor]                     ; $690E
    sla a                                         ; $6911
    sla a                                         ; $6913
    sla a                                         ; $6915
    add $1d                                       ; $6917
    ld b, a                                       ; $6919
    ld c, $57                                     ; $691A
    ld a, $7c                                     ; $691C
    call Oam_AddMeta_B01_5D47                     ; $691E
    ld hl, wSound1Notes                           ; $6921
    ld a, [wSound1NoteCursor]                     ; $6924
    call DjEd_DrawNoteStepCursor                  ; $6927
    ldh a, [hFrameCounter]                        ; $692A
    srl a                                         ; $692C
    srl a                                         ; $692E
    srl a                                         ; $6930
    and $01                                       ; $6932
    ld e, a                                       ; $6934
    ld hl, wSound1Stereo                          ; $6935
    ld a, [wSound1NoteCursor]                     ; $6938
    call DjEd_DrawNoteColumn                      ; $693B
    ret                                           ; $693E


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjS2_DrawValueRow::
    ld a, [wSound1PlayStep]                       ; $693F
    call DjEd_DrawPlayCursor                      ; $6942
    ld a, [wSound1FieldCursor]                    ; $6945
    cp $09                                        ; $6948
    ret z                                         ; $694A

    cp $0a                                        ; $694B
    ret z                                         ; $694D

    cp $0b                                        ; $694E
    ret z                                         ; $6950

    call DjEd_DrawLoopBar                         ; $6951
    ret                                           ; $6954


; C
DjS2_RedrawWaveGraphStep::
    ld a, [wSound2WaveLen + $1]                   ; $6955
    ld bc, $5a2e                                  ; $6958
    and a                                         ; $695B
    jr nz, jr_005_6960                            ; $695C

    ld a, $0a                                     ; $695E

jr_005_6960:
    add $7f                                       ; $6960
    call Oam_AddMeta_B01_5D47                     ; $6962
    ld a, [wSound2Modulation]                     ; $6965
    call DjEd_DrawModDepthDigits                  ; $6968
    ld a, [wSound2Modulation + $1]                ; $696B
    call DjEd_DrawModSpeedDigits                  ; $696E
    ld a, [wLoopLengths + $1]                     ; $6971
    call DjEd_DrawLoopDigitsAndPrint              ; $6974
    ld a, [wSound2FieldCursor]                    ; $6977
    cp $00                                        ; $697A
    ret z                                         ; $697C

    ld bc, $0b31                                  ; $697D
    ld a, $8a                                     ; $6980
    call Oam_AddMeta_B01_5D47                     ; $6982
    ret                                           ; $6985


; C: L3 pass 2026-10-26: executed in BGB in the scenarios dj_perf_start_noise 1F:0A, dj_print_noise 1F:0A
; (tcrf_check/assets/l3_names/scen_hits*.csv)
DjS2_DrawAllValues::
    ld a, [wLoopLengths + $1]                     ; $6986
    call DjEd_DrawLoopDigitsAndPrint              ; $6989
    ret                                           ; $698C


; C: handler of the DjS2 field cursor value 0
DjS2_Field00_WavePattern::
    call DjS2_Field00_SyncCursor                  ; $698D
    call DjS2_Field00_Edit                        ; $6990
    call DjS2_Field00_DrawCursor                  ; $6993
    ldh a, [hKeysNew]                             ; $6996
    bit PADB_RIGHT, a                             ; $6998
    jr z, jr_005_69cd                             ; $699A

    ld a, [wSound2WaveLen]                        ; $699C
    cp $02                                        ; $699F
    jr nz, jr_005_69b9                            ; $69A1

    ldh a, [hKeysHeld]                            ; $69A3
    bit PADB_A, a                                 ; $69A5
    jr z, jr_005_69b9                             ; $69A7

    push af                                       ; $69A9
    ld a, $01                                     ; $69AA
    ld [wUiSfxRequest], a                         ; $69AC
    pop af                                        ; $69AF
    call DjS2_Field00_DrawMarker                  ; $69B0
    ld a, $01                                     ; $69B3
    ld [wSound2FieldCursor], a                    ; $69B5
    ret                                           ; $69B8


jr_005_69b9:
    push af                                       ; $69B9
    ld a, $01                                     ; $69BA
    ld [wUiSfxRequest], a                         ; $69BC
    pop af                                        ; $69BF
    call DjS2_Field00_DrawMarker                  ; $69C0
    ld a, $02                                     ; $69C3
    ld [wSound2FieldCursor], a                    ; $69C5
    xor a                                         ; $69C8
    ld [wSndCursorPopFrames], a                   ; $69C9
    ret                                           ; $69CC


jr_005_69cd:
    bit 7, a                                      ; $69CD
    ret z                                         ; $69CF

    push af                                       ; $69D0
    ld a, $01                                     ; $69D1
    ld [wUiSfxRequest], a                         ; $69D3
    pop af                                        ; $69D6
    call DjS2_Field00_DrawMarker                  ; $69D7
    ld a, [wSound2FieldCursor]                    ; $69DA
    ld [wSound2FieldCursor + $2], a               ; $69DD
    ld a, $06                                     ; $69E0
    ld [wSound2FieldCursor], a                    ; $69E2
    xor a                                         ; $69E5
    ld [wSndCursorPopFrames], a                   ; $69E6
    ret                                           ; $69E9


; C
DjS2_Field00_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $69EA
    ld hl, wSound2FieldCursor + $1                ; $69ED
    cp [hl]                                       ; $69F0
    ret z                                         ; $69F1

    ld [hl], a                                    ; $69F2
    ld a, $51                                     ; $69F3
    ld hl, $9861                                  ; $69F5
    call Vram_WriteByteSafe                       ; $69F8
    ld a, $51                                     ; $69FB
    ld hl, $9881                                  ; $69FD
    call Vram_WriteByteSafe                       ; $6A00
    ld a, $51                                     ; $6A03
    ld hl, $98a1                                  ; $6A05
    call Vram_WriteByteSafe                       ; $6A08
    ld a, $6f                                     ; $6A0B
    ld hl, $9842                                  ; $6A0D
    call Vram_WriteByteSafe                       ; $6A10
    call DjSnd_BuildWaveStaging                   ; $6A13
    call DjS2_WaveRedrawStart                     ; $6A16
    ret                                           ; $6A19


; C
DjS2_Field00_Edit::
    ld a, [wSound2WaveLen]                        ; $6A1A
    ld bc, $0002                                  ; $6A1D
    call DjEd_StepValue_Up                        ; $6A20
    ld hl, wSound2WaveLen                         ; $6A23
    cp [hl]                                       ; $6A26
    ret z                                         ; $6A27

    ld [hl], a                                    ; $6A28
    call DjSnd_BuildWaveStaging                   ; $6A29
    call DjS2_WaveRedrawStart                     ; $6A2C
    ret                                           ; $6A2F


; C
DjS2_Field00_DrawCursor::
    ld bc, $051c                                  ; $6A30
    ld a, $a1                                     ; $6A33
    call DjEd_DrawFieldCursor                     ; $6A35
    ld a, [wSound2WaveLen]                        ; $6A38
    cp $02                                        ; $6A3B
    jr nz, jr_005_6a4f                            ; $6A3D

    ldh a, [hFrameCounter]                        ; $6A3F
    bit 3, a                                      ; $6A41
    jr nz, jr_005_6a4f                            ; $6A43

    ld bc, $0b31                                  ; $6A45
    ld a, $70                                     ; $6A48
    call Oam_AddMeta_B01_5D47                     ; $6A4A
    jr jr_005_6a57                                ; $6A4D

jr_005_6a4f:
    ld bc, $0b31                                  ; $6A4F
    ld a, $8a                                     ; $6A52
    call Oam_AddMeta_B01_5D47                     ; $6A54

jr_005_6a57:
    ldh a, [hFrameCounter]                        ; $6A57
    bit 4, a                                      ; $6A59
    ret z                                         ; $6A5B

    ld a, [wSound2WaveLen]                        ; $6A5C
    swap a                                        ; $6A5F
    srl a                                         ; $6A61
    add $20                                       ; $6A63
    ld c, a                                       ; $6A65
    ld b, $09                                     ; $6A66
    ld a, $79                                     ; $6A68
    call Oam_AddMeta_B01_5D47                     ; $6A6A
    ret                                           ; $6A6D


; C: wave pattern marker tile $CB
DjS2_Field00_DrawMarker::
    ld a, [wSound2WaveLen]                        ; $6A6E
    swap a                                        ; $6A71
    sla a                                         ; $6A73
    ld c, a                                       ; $6A75
    ld b, $00                                     ; $6A76
    ld hl, $9861                                  ; $6A78
    add hl, bc                                    ; $6A7B
    ld a, $cb                                     ; $6A7C
    call Vram_WriteByteSafe                       ; $6A7E
    ret                                           ; $6A81


; C: handler of the DjS2 field cursor value 1
DjS2_Field01_WaveGrid::
    call DjS2_Field01_SyncCursor                  ; $6A82
    call DjS2_Field01_Edit                        ; $6A85
    call DjS2_Field01_DrawCursor                  ; $6A88
    ld a, [wSound2WaveCursor]                     ; $6A8B
    cp $ff                                        ; $6A8E
    jr z, jr_005_6a97                             ; $6A90

    ldh a, [hKeysHeld]                            ; $6A92
    bit PADB_A, a                                 ; $6A94
    ret nz                                        ; $6A96

jr_005_6a97:
    xor a                                         ; $6A97
    ld [wSndCursorPopFrames], a                   ; $6A98
    call DjS2_Field01_DrawMarker                  ; $6A9B
    ld a, $00                                     ; $6A9E
    ld [wSound2FieldCursor], a                    ; $6AA0
    ret                                           ; $6AA3


; C
DjS2_Field01_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6AA4
    ld hl, wSound2FieldCursor + $1                ; $6AA7
    cp [hl]                                       ; $6AAA
    ret z                                         ; $6AAB

    ld [hl], a                                    ; $6AAC
    ld a, $00                                     ; $6AAD
    ld hl, $9842                                  ; $6AAF
    call Vram_WriteByteSafe                       ; $6AB2
    call DjS2_WaveRedrawStart                     ; $6AB5
    xor a                                         ; $6AB8
    ld [wSound2WaveCursor], a                     ; $6AB9
    ret                                           ; $6ABC


; C
DjS2_Field01_Edit::
    ld a, [wSound2WaveCursor]                     ; $6ABD
    ld bc, $ff1f                                  ; $6AC0
    call DjEd_StepValue_LeftRight                 ; $6AC3
    ld hl, wSound2WaveCursor                      ; $6AC6
    cp [hl]                                       ; $6AC9
    jr z, jr_005_6acd                             ; $6ACA

    ld [hl], a                                    ; $6ACC

jr_005_6acd:
    ld c, a                                       ; $6ACD
    ld b, $00                                     ; $6ACE
    push bc                                       ; $6AD0
    ld hl, wWaveStaging                           ; $6AD1
    add hl, bc                                    ; $6AD4
    ld a, [hl]                                    ; $6AD5
    push hl                                       ; $6AD6
    ld bc, $000f                                  ; $6AD7
    call DjEd_StepValue_Right                     ; $6ADA
    pop hl                                        ; $6ADD
    pop bc                                        ; $6ADE
    cp [hl]                                       ; $6ADF
    ret z                                         ; $6AE0

    ld [hl], a                                    ; $6AE1
    ld hl, wSound2UserWave                        ; $6AE2
    add hl, bc                                    ; $6AE5
    ld [hl], a                                    ; $6AE6
    call DjS2_WaveGraphColumn                     ; $6AE7
    ret                                           ; $6AEA


; C
DjS2_Field01_DrawCursor::
    ld bc, $051c                                  ; $6AEB
    ld a, $a4                                     ; $6AEE
    call Oam_AddMeta_B01_5D47                     ; $6AF0
    ldh a, [hFrameCounter]                        ; $6AF3
    bit 4, a                                      ; $6AF5
    ret z                                         ; $6AF7

    ld a, [wSound2WaveCursor]                     ; $6AF8
    sla a                                         ; $6AFB
    add $10                                       ; $6AFD
    ld b, a                                       ; $6AFF
    ld c, $33                                     ; $6B00
    ld a, $8b                                     ; $6B02
    call Oam_AddMeta_B01_5D47                     ; $6B04
    ret                                           ; $6B07


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the cursor of SOUND II field 1 (DjEd_DrawFieldCursor $A1 at $051C)
DjS2_Field01_DrawMarker::
    ld bc, $051c                                  ; $6B08
    ld a, $a1                                     ; $6B0B
    call DjEd_DrawFieldCursor                     ; $6B0D
    ret                                           ; $6B10


; C: handler of the DjS2 field cursor value 2
DjS2_Field02_Length::
    call DjS2_Field02_SyncCursor                  ; $6B11
    call DjS2_Field02_Edit                        ; $6B14
    call DjS2_Field02_DrawCursor                  ; $6B17
    ldh a, [hKeysNew]                             ; $6B1A
    bit PADB_LEFT, a                              ; $6B1C
    jr z, jr_005_6b31                             ; $6B1E

    push af                                       ; $6B20
    ld a, $01                                     ; $6B21
    ld [wUiSfxRequest], a                         ; $6B23
    pop af                                        ; $6B26
    ld a, $00                                     ; $6B27
    ld [wSound2FieldCursor], a                    ; $6B29
    xor a                                         ; $6B2C
    ld [wSndCursorPopFrames], a                   ; $6B2D
    ret                                           ; $6B30


jr_005_6b31:
    bit 4, a                                      ; $6B31
    jr z, jr_005_6b46                             ; $6B33

    push af                                       ; $6B35
    ld a, $01                                     ; $6B36
    ld [wUiSfxRequest], a                         ; $6B38
    pop af                                        ; $6B3B
    ld a, $03                                     ; $6B3C
    ld [wSound2FieldCursor], a                    ; $6B3E
    xor a                                         ; $6B41
    ld [wSndCursorPopFrames], a                   ; $6B42
    ret                                           ; $6B45


jr_005_6b46:
    bit 7, a                                      ; $6B46
    ret z                                         ; $6B48

    push af                                       ; $6B49
    ld a, $01                                     ; $6B4A
    ld [wUiSfxRequest], a                         ; $6B4C
    pop af                                        ; $6B4F
    ld a, [wSound2FieldCursor]                    ; $6B50
    ld [wSound2FieldCursor + $2], a               ; $6B53
    ld a, $06                                     ; $6B56
    ld [wSound2FieldCursor], a                    ; $6B58
    xor a                                         ; $6B5B
    ld [wSndCursorPopFrames], a                   ; $6B5C
    ret                                           ; $6B5F


; C
DjS2_Field02_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6B60
    ld hl, wSound2FieldCursor + $1                ; $6B63
    cp [hl]                                       ; $6B66
    ret z                                         ; $6B67

    ld [hl], a                                    ; $6B68

; C
DjS2_Field02_Edit::
    ld a, [wSound2WaveLen + $1]                   ; $6B69
    ld bc, $0009                                  ; $6B6C
    call DjEd_StepValue_Right                     ; $6B6F
    ld hl, wSound2WaveLen + $1                    ; $6B72
    cp [hl]                                       ; $6B75
    ret z                                         ; $6B76

    ld [hl], a                                    ; $6B77
    ret                                           ; $6B78


; C
DjS2_Field02_DrawCursor::
    ld bc, $541c                                  ; $6B79
    ld a, $95                                     ; $6B7C
    call DjEd_DrawFieldCursor                     ; $6B7E
    ldh a, [hFrameCounter]                        ; $6B81
    bit 4, a                                      ; $6B83
    ret z                                         ; $6B85

    ld bc, $5c2a                                  ; $6B86
    ld a, $7d                                     ; $6B89
    call Oam_AddMeta_B01_5D47                     ; $6B8B
    ret                                           ; $6B8E


; C: handler of the DjS2 field cursor value 3
DjS2_Field03_ModDepth::
    call DjS2_Field03_SyncCursor                  ; $6B8F
    call DjS2_Field03_Edit                        ; $6B92
    call DjS2_Field03_DrawCursor                  ; $6B95
    ldh a, [hKeysNew]                             ; $6B98
    bit PADB_LEFT, a                              ; $6B9A
    jr z, jr_005_6baf                             ; $6B9C

    push af                                       ; $6B9E
    ld a, $01                                     ; $6B9F
    ld [wUiSfxRequest], a                         ; $6BA1
    pop af                                        ; $6BA4
    ld a, $02                                     ; $6BA5
    ld [wSound2FieldCursor], a                    ; $6BA7
    xor a                                         ; $6BAA
    ld [wSndCursorPopFrames], a                   ; $6BAB
    ret                                           ; $6BAE


jr_005_6baf:
    bit 4, a                                      ; $6BAF
    jr z, jr_005_6bc0                             ; $6BB1

    push af                                       ; $6BB3
    ld a, $01                                     ; $6BB4
    ld [wUiSfxRequest], a                         ; $6BB6
    pop af                                        ; $6BB9
    ld a, $04                                     ; $6BBA
    ld [wSound2FieldCursor], a                    ; $6BBC
    ret                                           ; $6BBF


jr_005_6bc0:
    bit 7, a                                      ; $6BC0
    ret z                                         ; $6BC2

    push af                                       ; $6BC3
    ld a, $01                                     ; $6BC4
    ld [wUiSfxRequest], a                         ; $6BC6
    pop af                                        ; $6BC9
    ld a, [wSound2FieldCursor]                    ; $6BCA
    ld [wSound2FieldCursor + $2], a               ; $6BCD
    ld a, $06                                     ; $6BD0
    ld [wSound2FieldCursor], a                    ; $6BD2
    xor a                                         ; $6BD5
    ld [wSndCursorPopFrames], a                   ; $6BD6
    ret                                           ; $6BD9


; C
DjS2_Field03_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6BDA
    ld hl, wSound2FieldCursor + $1                ; $6BDD
    cp [hl]                                       ; $6BE0
    ret z                                         ; $6BE1

    ld [hl], a                                    ; $6BE2
    ld [wSound2FieldCursor + $2], a               ; $6BE3
    ret                                           ; $6BE6


; C
DjS2_Field03_Edit::
    ld a, [wSound2Modulation]                     ; $6BE7
    ld bc, $0063                                  ; $6BEA
    call DjEd_StepValue_Right                     ; $6BED
    ld [wSound2Modulation], a                     ; $6BF0
    ret                                           ; $6BF3


; C
DjS2_Field03_DrawCursor::
    ld bc, $661c                                  ; $6BF4
    ld a, $98                                     ; $6BF7
    call DjEd_DrawFieldCursor                     ; $6BF9
    ldh a, [hFrameCounter]                        ; $6BFC
    bit 4, a                                      ; $6BFE
    ret z                                         ; $6C00

    ld bc, $6e2c                                  ; $6C01
    ld a, $7d                                     ; $6C04
    call Oam_AddMeta_B01_5D47                     ; $6C06
    ret                                           ; $6C09


; C: handler of the DjS2 field cursor value 4
DjS2_Field04_ModSpeed::
    call DjS2_Field04_SyncCursor                  ; $6C0A
    call DjS2_Field04_Edit                        ; $6C0D
    call DjS2_Field04_DrawCursor                  ; $6C10
    ldh a, [hKeysNew]                             ; $6C13
    bit PADB_LEFT, a                              ; $6C15
    jr z, jr_005_6c26                             ; $6C17

    push af                                       ; $6C19
    ld a, $01                                     ; $6C1A
    ld [wUiSfxRequest], a                         ; $6C1C
    pop af                                        ; $6C1F
    ld a, $03                                     ; $6C20
    ld [wSound2FieldCursor], a                    ; $6C22
    ret                                           ; $6C25


jr_005_6c26:
    bit 4, a                                      ; $6C26
    jr z, jr_005_6c37                             ; $6C28

    push af                                       ; $6C2A
    ld a, $01                                     ; $6C2B
    ld [wUiSfxRequest], a                         ; $6C2D
    pop af                                        ; $6C30
    ld a, $05                                     ; $6C31
    ld [wSound2FieldCursor], a                    ; $6C33
    ret                                           ; $6C36


jr_005_6c37:
    bit 7, a                                      ; $6C37
    ret z                                         ; $6C39

    push af                                       ; $6C3A
    ld a, $01                                     ; $6C3B
    ld [wUiSfxRequest], a                         ; $6C3D
    pop af                                        ; $6C40
    ld a, [wSound2FieldCursor]                    ; $6C41
    ld [wSound2FieldCursor + $2], a               ; $6C44
    ld a, $06                                     ; $6C47
    ld [wSound2FieldCursor], a                    ; $6C49
    xor a                                         ; $6C4C
    ld [wSndCursorPopFrames], a                   ; $6C4D
    ret                                           ; $6C50


; C
DjS2_Field04_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6C51
    ld hl, wSound2FieldCursor + $1                ; $6C54
    cp [hl]                                       ; $6C57
    ret z                                         ; $6C58

    ld [hl], a                                    ; $6C59
    ld [wSound2FieldCursor + $2], a               ; $6C5A
    ret                                           ; $6C5D


; C
DjS2_Field04_Edit::
    ld a, [wSound2Modulation + $1]                ; $6C5E
    ld bc, $0063                                  ; $6C61
    call DjEd_StepValue_Right                     ; $6C64
    ld [wSound2Modulation + $1], a                ; $6C67
    ret                                           ; $6C6A


; C
DjS2_Field04_DrawCursor::
    ld bc, $661c                                  ; $6C6B
    ld a, $98                                     ; $6C6E
    call DjEd_DrawFieldCursor                     ; $6C70
    ldh a, [hFrameCounter]                        ; $6C73
    bit 4, a                                      ; $6C75
    ret z                                         ; $6C77

    ld bc, $802c                                  ; $6C78
    ld a, $7d                                     ; $6C7B
    call Oam_AddMeta_B01_5D47                     ; $6C7D
    ret                                           ; $6C80


; C: handler of the DjS2 field cursor value 5
DjS2_Field05_ModMode::
    call DjS2_Field05_SyncCursor                  ; $6C81
    call DjS2_Field05_Edit                        ; $6C84
    call DjS2_Field05_DrawCursor                  ; $6C87
    ldh a, [hKeysNew]                             ; $6C8A
    bit PADB_LEFT, a                              ; $6C8C
    jr z, jr_005_6ca0                             ; $6C8E

    push af                                       ; $6C90
    ld a, $01                                     ; $6C91
    ld [wUiSfxRequest], a                         ; $6C93
    pop af                                        ; $6C96
    call DjS2_Field05_DrawMarker                  ; $6C97
    ld a, $04                                     ; $6C9A
    ld [wSound2FieldCursor], a                    ; $6C9C
    ret                                           ; $6C9F


jr_005_6ca0:
    bit 7, a                                      ; $6CA0
    ret z                                         ; $6CA2

    push af                                       ; $6CA3
    ld a, $01                                     ; $6CA4
    ld [wUiSfxRequest], a                         ; $6CA6
    pop af                                        ; $6CA9
    call DjS2_Field05_DrawMarker                  ; $6CAA
    ld a, [wSound2FieldCursor]                    ; $6CAD
    ld [wSound2FieldCursor + $2], a               ; $6CB0
    ld a, $06                                     ; $6CB3
    ld [wSound2FieldCursor], a                    ; $6CB5
    xor a                                         ; $6CB8
    ld [wSndCursorPopFrames], a                   ; $6CB9
    ret                                           ; $6CBC


; C
DjS2_Field05_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6CBD
    ld hl, wSound2FieldCursor + $1                ; $6CC0
    cp [hl]                                       ; $6CC3
    ret z                                         ; $6CC4

    ld [hl], a                                    ; $6CC5
    ld [wSound2FieldCursor + $2], a               ; $6CC6
    ld a, $55                                     ; $6CC9
    ld hl, $9871                                  ; $6CCB
    call Vram_WriteByteSafe                       ; $6CCE
    ld a, $55                                     ; $6CD1
    ld hl, $9891                                  ; $6CD3
    call Vram_WriteByteSafe                       ; $6CD6
    ld a, $55                                     ; $6CD9
    ld hl, $98b1                                  ; $6CDB
    call Vram_WriteByteSafe                       ; $6CDE
    ret                                           ; $6CE1


; C
DjS2_Field05_Edit::
    ld a, [wSound2Modulation + $2]                ; $6CE2
    ld bc, $0002                                  ; $6CE5
    call DjEd_StepValue_Up                        ; $6CE8
    ld [wSound2Modulation + $2], a                ; $6CEB
    ret                                           ; $6CEE


; C
DjS2_Field05_DrawCursor::
    ld bc, $661c                                  ; $6CEF
    ld a, $98                                     ; $6CF2
    call DjEd_DrawFieldCursor                     ; $6CF4
    ldh a, [hFrameCounter]                        ; $6CF7
    bit 4, a                                      ; $6CF9
    ret z                                         ; $6CFB

    ld a, [wSound2Modulation + $2]                ; $6CFC
    swap a                                        ; $6CFF
    srl a                                         ; $6D01
    add $21                                       ; $6D03
    ld c, a                                       ; $6D05
    ld b, $8d                                     ; $6D06
    ld a, $79                                     ; $6D08
    call Oam_AddMeta_B01_5D47                     ; $6D0A
    ret                                           ; $6D0D


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND II field 5 (modulation mode)
DjS2_Field05_DrawMarker::
    ld a, [wSound2Modulation + $2]                ; $6D0E
    swap a                                        ; $6D11
    sla a                                         ; $6D13
    ld c, a                                       ; $6D15
    ld b, $00                                     ; $6D16
    ld hl, $9871                                  ; $6D18
    add hl, bc                                    ; $6D1B
    ld a, $ca                                     ; $6D1C
    call Vram_WriteByteSafe                       ; $6D1E
    ret                                           ; $6D21


; C: handler of the DjS2 field cursor value 6
DjS2_Field06_LoopLength::
    call DjS2_Field06_SyncCursor                  ; $6D22
    call DjS2_Field06_Edit                        ; $6D25
    call DjS2_Field06_DrawCursor                  ; $6D28
    ldh a, [hKeysNew]                             ; $6D2B
    bit PADB_UP, a                                ; $6D2D
    jr z, jr_005_6d43                             ; $6D2F

    push af                                       ; $6D31
    ld a, $01                                     ; $6D32
    ld [wUiSfxRequest], a                         ; $6D34
    pop af                                        ; $6D37
    ld a, [wSound2FieldCursor + $2]               ; $6D38
    ld [wSound2FieldCursor], a                    ; $6D3B
    xor a                                         ; $6D3E
    ld [wSndCursorPopFrames], a                   ; $6D3F
    ret                                           ; $6D42


jr_005_6d43:
    bit 7, a                                      ; $6D43
    ret z                                         ; $6D45

    push af                                       ; $6D46
    ld a, $01                                     ; $6D47
    ld [wUiSfxRequest], a                         ; $6D49
    pop af                                        ; $6D4C
    call DjEd_DrawLoopBar                         ; $6D4D
    ld a, $07                                     ; $6D50
    ld [wSound2FieldCursor], a                    ; $6D52
    xor a                                         ; $6D55
    ld [wSndCursorPopFrames], a                   ; $6D56
    ret                                           ; $6D59


; C
DjS2_Field06_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6D5A
    ld hl, wSound2FieldCursor + $1                ; $6D5D
    cp [hl]                                       ; $6D60
    ret z                                         ; $6D61

    ld [hl], a                                    ; $6D62
    ret                                           ; $6D63


; C
DjS2_Field06_Edit::
    ld a, [wLoopLengths + $1]                     ; $6D64
    ld bc, $0210                                  ; $6D67
    call DjEd_StepValue_Right                     ; $6D6A
    ld [wLoopLengths + $1], a                     ; $6D6D
    ld a, [wLoopLengths + $1]                     ; $6D70
    ld bc, $0210                                  ; $6D73
    call DjEd_StepValue_LeftRight                 ; $6D76
    ld [wLoopLengths + $1], a                     ; $6D79
    ret                                           ; $6D7C


; C
DjS2_Field06_DrawCursor::
    ld bc, $053d                                  ; $6D7D
    ld a, $9b                                     ; $6D80
    call DjEd_DrawFieldCursor                     ; $6D82
    ldh a, [hFrameCounter]                        ; $6D85
    bit 4, a                                      ; $6D87
    ret z                                         ; $6D89

    ld bc, $0e46                                  ; $6D8A
    ld a, $7d                                     ; $6D8D
    call Oam_AddMeta_B01_5D47                     ; $6D8F
    ret                                           ; $6D92


; C: handler of the DjS2 field cursor value 7
DjS2_Field07_NoteGrid::
    call DjS2_Field07_SyncCursor                  ; $6D93
    call DjS2_Field07_Edit                        ; $6D96
    call DjS2_Field07_DrawCursor                  ; $6D99
    ldh a, [hKeysNew]                             ; $6D9C
    bit PADB_UP, a                                ; $6D9E
    jr z, jr_005_6db3                             ; $6DA0

    push af                                       ; $6DA2
    ld a, $01                                     ; $6DA3
    ld [wUiSfxRequest], a                         ; $6DA5
    pop af                                        ; $6DA8
    ld a, $06                                     ; $6DA9
    ld [wSound2FieldCursor], a                    ; $6DAB
    xor a                                         ; $6DAE
    ld [wSndCursorPopFrames], a                   ; $6DAF
    ret                                           ; $6DB2


jr_005_6db3:
    bit 3, a                                      ; $6DB3
    jr z, jr_005_6dc4                             ; $6DB5

    push af                                       ; $6DB7
    ld a, $04                                     ; $6DB8
    ld [wUiSfxRequest], a                         ; $6DBA
    pop af                                        ; $6DBD
    ld a, $09                                     ; $6DBE
    ld [wSound2FieldCursor], a                    ; $6DC0
    ret                                           ; $6DC3


jr_005_6dc4:
    bit 0, a                                      ; $6DC4
    ret z                                         ; $6DC6

    push af                                       ; $6DC7
    ld a, $04                                     ; $6DC8
    ld [wUiSfxRequest], a                         ; $6DCA
    pop af                                        ; $6DCD
    ld a, $08                                     ; $6DCE
    ld [wSound2FieldCursor], a                    ; $6DD0
    ret                                           ; $6DD3


; C
DjS2_Field07_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6DD4
    ld hl, wSound2FieldCursor + $1                ; $6DD7
    cp [hl]                                       ; $6DDA
    ret z                                         ; $6DDB

    ld [hl], a                                    ; $6DDC
    ret                                           ; $6DDD


; C
DjS2_Field07_Edit::
    ld a, [wSound2NoteCursor]                     ; $6DDE
    ld bc, $000f                                  ; $6DE1
    call DjEd_StepLeftRight                       ; $6DE4
    ld [wSound2NoteCursor], a                     ; $6DE7
    ld a, [wSound2NoteCursor]                     ; $6DEA
    ld c, a                                       ; $6DED
    ld b, $00                                     ; $6DEE
    ld hl, wSound2Notes                           ; $6DF0
    add hl, bc                                    ; $6DF3
    ldh a, [hKeysNew]                             ; $6DF4
    bit PADB_DOWN, a                              ; $6DF6
    ret z                                         ; $6DF8

    xor a                                         ; $6DF9
    ld [hl], a                                    ; $6DFA
    ld a, [wSound2NoteCursor]                     ; $6DFB
    ld hl, wSound2Notes                           ; $6DFE
    call DjEd_DrawNoteRowOffset                   ; $6E01
    ret                                           ; $6E04


; C
DjS2_Field07_DrawCursor::
    ld bc, $0557                                  ; $6E05
    ld a, $9e                                     ; $6E08
    call DjEd_DrawFieldCursor                     ; $6E0A
    ldh a, [hFrameCounter]                        ; $6E0D
    bit 4, a                                      ; $6E0F
    jr z, jr_005_6e26                             ; $6E11

    ld a, [wSound2NoteCursor]                     ; $6E13
    sla a                                         ; $6E16
    sla a                                         ; $6E18
    sla a                                         ; $6E1A
    add $1d                                       ; $6E1C
    ld b, a                                       ; $6E1E
    ld c, $57                                     ; $6E1F
    ld a, $7c                                     ; $6E21
    call Oam_AddMeta_B01_5D47                     ; $6E23

jr_005_6e26:
    ld a, [wSound2NoteCursor]                     ; $6E26
    call DjEd_DrawNoteMarker                      ; $6E29
    ld hl, wSound2Notes                           ; $6E2C
    ld a, [wSound2NoteCursor]                     ; $6E2F
    call DjEd_DrawNoteStepCursor                  ; $6E32
    ld e, $00                                     ; $6E35
    ld hl, wSound2Stereo                          ; $6E37
    ld a, [wSound2NoteCursor]                     ; $6E3A
    call DjEd_DrawNoteColumn                      ; $6E3D
    ret                                           ; $6E40


; C: handler of the DjS2 field cursor value 8
DjS2_Field08_NoteEdit::
    call DjS2_Field08_SyncCursor                  ; $6E41
    call DjS2_Field08_Edit                        ; $6E44
    call DjS2_Field08_DrawCursor                  ; $6E47
    ldh a, [hKeysHeld]                            ; $6E4A
    bit PADB_A, a                                 ; $6E4C
    ret nz                                        ; $6E4E

    push af                                       ; $6E4F
    ld a, $05                                     ; $6E50
    ld [wUiSfxRequest], a                         ; $6E52
    pop af                                        ; $6E55
    call DjS2_Field08_DrawMarker                  ; $6E56
    ld a, $07                                     ; $6E59
    ld [wSound2FieldCursor], a                    ; $6E5B
    ret                                           ; $6E5E


; C
DjS2_Field08_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6E5F
    ld hl, wSound2FieldCursor + $1                ; $6E62
    cp [hl]                                       ; $6E65
    ret z                                         ; $6E66

    ld [hl], a                                    ; $6E67
    ret                                           ; $6E68


; C
DjS2_Field08_Edit::
    ld a, [wSound2NoteCursor]                     ; $6E69
    ld c, a                                       ; $6E6C
    ld b, $00                                     ; $6E6D
    ld hl, wSound2Notes                           ; $6E6F
    add hl, bc                                    ; $6E72
    ld bc, $0025                                  ; $6E73
    ld a, [hl]                                    ; $6E76
    push hl                                       ; $6E77
    call DjEd_StepLeftRight                       ; $6E78
    pop hl                                        ; $6E7B
    cp [hl]                                       ; $6E7C
    ret z                                         ; $6E7D

    ld [hl], a                                    ; $6E7E
    call DjS2_Field08_DrawMarker                  ; $6E7F
    ret                                           ; $6E82


; C
DjS2_Field08_DrawCursor::
    ld bc, $0557                                  ; $6E83
    ld a, $9e                                     ; $6E86
    call DjEd_DrawFieldCursor                     ; $6E88
    ld hl, wSound2Notes                           ; $6E8B
    ld a, [wSound2NoteCursor]                     ; $6E8E
    call DjEd_DrawNoteStepCursor                  ; $6E91
    ldh a, [hKeysHeld]                            ; $6E94
    and PADF_RIGHT | PADF_LEFT                    ; $6E96
    ld hl, wSound2Notes                           ; $6E98
    ld a, [wSound2NoteCursor]                     ; $6E9B
    call z, DjEd_DrawNoteCursorBlink              ; $6E9E
    ld a, [wSound2NoteCursor]                     ; $6EA1
    sla a                                         ; $6EA4
    sla a                                         ; $6EA6
    sla a                                         ; $6EA8
    add $1d                                       ; $6EAA
    ld b, a                                       ; $6EAC
    ld c, $57                                     ; $6EAD
    ld a, $7c                                     ; $6EAF
    call Oam_AddMeta_B01_5D47                     ; $6EB1
    ld e, $00                                     ; $6EB4
    ld hl, wSound2Stereo                          ; $6EB6
    ld a, [wSound2NoteCursor]                     ; $6EB9
    call DjEd_DrawNoteColumn                      ; $6EBC
    ret                                           ; $6EBF


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of SOUND II field 8 (note edit)
DjS2_Field08_DrawMarker::
    ld a, [wSound2NoteCursor]                     ; $6EC0
    ld hl, wSound2Notes                           ; $6EC3
    call DjEd_DrawNoteRowOffset                   ; $6EC6
    ret                                           ; $6EC9


; C: handler of the DjS2 field cursor value 9
DjS2_Field09_StereoEdit::
    call DjS2_Field09_SyncCursor                  ; $6ECA
    call DjS2_Field09_Edit                        ; $6ECD
    call DjS2_Field09_DrawCursor                  ; $6ED0
    ldh a, [hKeysHeld]                            ; $6ED3
    bit PADB_START, a                             ; $6ED5
    ret nz                                        ; $6ED7

    push af                                       ; $6ED8
    ld a, $05                                     ; $6ED9
    ld [wUiSfxRequest], a                         ; $6EDB
    pop af                                        ; $6EDE
    ld a, $07                                     ; $6EDF
    ld [wSound2FieldCursor], a                    ; $6EE1
    ret                                           ; $6EE4


; C
DjS2_Field09_SyncCursor::
    ld a, [wSound2FieldCursor]                    ; $6EE5
    ld hl, wSound2FieldCursor + $1                ; $6EE8
    cp [hl]                                       ; $6EEB
    ret z                                         ; $6EEC

    ld [hl], a                                    ; $6EED
    ld a, [wSound2NoteCursor]                     ; $6EEE
    ld c, a                                       ; $6EF1
    ld b, $00                                     ; $6EF2
    ld hl, wSound2Stereo                          ; $6EF4
    add hl, bc                                    ; $6EF7
    ld a, [hl]                                    ; $6EF8
    and $03                                       ; $6EF9
    ld [wSound2StereoEdit], a                     ; $6EFB
    ret                                           ; $6EFE


; C
DjS2_Field09_Edit::
    ld a, [wSound2StereoEdit]                     ; $6EFF
    ld bc, $0002                                  ; $6F02
    call DjEd_StepLeftRight                       ; $6F05
    ld [wSound2StereoEdit], a                     ; $6F08
    ld a, [wSound2NoteCursor]                     ; $6F0B
    ld c, a                                       ; $6F0E
    ld b, $00                                     ; $6F0F
    ld hl, wSound2Stereo                          ; $6F11
    add hl, bc                                    ; $6F14
    ld a, [wSound2StereoEdit]                     ; $6F15
    ld [hl], a                                    ; $6F18
    ret                                           ; $6F19


; C
DjS2_Field09_DrawCursor::
    ld bc, $0557                                  ; $6F1A
    ld a, $9e                                     ; $6F1D
    call DjEd_DrawFieldCursor                     ; $6F1F
    ld a, [wSound2NoteCursor]                     ; $6F22
    sla a                                         ; $6F25
    sla a                                         ; $6F27
    sla a                                         ; $6F29
    add $1d                                       ; $6F2B
    ld b, a                                       ; $6F2D
    ld c, $57                                     ; $6F2E
    ld a, $7c                                     ; $6F30
    call Oam_AddMeta_B01_5D47                     ; $6F32
    ld hl, wSound2Notes                           ; $6F35
    ld a, [wSound2NoteCursor]                     ; $6F38
    call DjEd_DrawNoteStepCursor                  ; $6F3B
    ldh a, [hFrameCounter]                        ; $6F3E
    srl a                                         ; $6F40
    srl a                                         ; $6F42
    srl a                                         ; $6F44
    and $01                                       ; $6F46
    ld e, a                                       ; $6F48
    ld hl, wSound2Stereo                          ; $6F49
    ld a, [wSound2NoteCursor]                     ; $6F4C
    call DjEd_DrawNoteColumn                      ; $6F4F
    ret                                           ; $6F52


; C
DjS2_WaveRedrawTick::
    ld a, [wSound2PlayStep]                       ; $6F53
    call DjEd_DrawPlayCursor                      ; $6F56
    ld a, [wSound2FieldCursor]                    ; $6F59
    cp $07                                        ; $6F5C
    ret z                                         ; $6F5E

    cp $08                                        ; $6F5F
    ret z                                         ; $6F61

    cp $09                                        ; $6F62
    ret z                                         ; $6F64

    call DjEd_DrawLoopBar                         ; $6F65
    ret                                           ; $6F68


; C: D8F1 = 4
DjS2_WaveRedrawStart::
    ld a, $04                                     ; $6F69
    ld [wWaveGraphPhase], a                       ; $6F6B
    ret                                           ; $6F6E


; C: 8 columns per frame
DjS2_WaveRedrawColumns::
    ld a, [wWaveGraphPhase]                       ; $6F6F
    and a                                         ; $6F72
    ret z                                         ; $6F73

    dec a                                         ; $6F74
    ld [wWaveGraphPhase], a                       ; $6F75
    sla a                                         ; $6F78
    sla a                                         ; $6F7A
    sla a                                         ; $6F7C
    ld c, a                                       ; $6F7E
    ld b, $00                                     ; $6F7F
    ld hl, wWaveStaging                           ; $6F81
    add hl, bc                                    ; $6F84
    ld b, $08                                     ; $6F85

jr_005_6f87:
    ld a, [hl+]                                   ; $6F87
    push bc                                       ; $6F88
    call DjS2_WaveGraphColumn                     ; $6F89
    pop bc                                        ; $6F8C
    inc c                                         ; $6F8D
    dec b                                         ; $6F8E
    jr nz, jr_005_6f87                            ; $6F8F

    ret                                           ; $6F91


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
DjS2_WaveGraphColumn::
    push hl                                       ; $6F92
    push af                                       ; $6F93
    ld a, c                                       ; $6F94
    and $0c                                       ; $6F95
    swap a                                        ; $6F97
    ld e, a                                       ; $6F99
    ld a, c                                       ; $6F9A
    and $10                                       ; $6F9B
    swap a                                        ; $6F9D
    ld d, a                                       ; $6F9F
    ld hl, wLevelTileStaging + $1                 ; $6FA0
    add hl, de                                    ; $6FA3
    pop af                                        ; $6FA4
    ld b, $0f                                     ; $6FA5

; C: per-row loop top of one wave-graph column (B counts down, bit 3 of B selects the compare direction) (branch
; target; code read 2026-10-19)
DjS2_WaveGraphColumn_RowLoop::
    push af                                       ; $6FA7
    bit 3, b                                      ; $6FA8
    jr z, jr_005_6fb1                             ; $6FAA

    cp b                                          ; $6FAC
    jr c, jr_005_6fcd                             ; $6FAD

    jr jr_005_6fb6                                ; $6FAF

jr_005_6fb1:
    cp b                                          ; $6FB1
    jr z, jr_005_6fb6                             ; $6FB2

    jr nc, jr_005_6fcd                            ; $6FB4

jr_005_6fb6:
    push hl                                       ; $6FB6
    ld a, c                                       ; $6FB7
    and $03                                       ; $6FB8
    ld e, a                                       ; $6FBA
    ld d, $00                                     ; $6FBB
    ld hl, DjS2_WaveGraphColumn_Tbl6FF2           ; $6FBD
    add hl, de                                    ; $6FC0
    ld a, [hl]                                    ; $6FC1
    pop hl                                        ; $6FC2
    push af                                       ; $6FC3
    or [hl]                                       ; $6FC4
    ld [hl], a                                    ; $6FC5
    pop af                                        ; $6FC6
    inc l                                         ; $6FC7
    inc l                                         ; $6FC8
    or [hl]                                       ; $6FC9
    ld [hl], a                                    ; $6FCA
    jr jr_005_6fe2                                ; $6FCB

jr_005_6fcd:
    push hl                                       ; $6FCD
    ld a, c                                       ; $6FCE
    and $03                                       ; $6FCF
    ld e, a                                       ; $6FD1
    ld d, $00                                     ; $6FD2
    ld hl, DjS2_WaveGraphColumn_Tbl6FF6           ; $6FD4
    add hl, de                                    ; $6FD7
    ld a, [hl]                                    ; $6FD8
    pop hl                                        ; $6FD9
    push af                                       ; $6FDA
    and [hl]                                      ; $6FDB
    ld [hl], a                                    ; $6FDC
    pop af                                        ; $6FDD
    inc l                                         ; $6FDE
    inc l                                         ; $6FDF
    and [hl]                                      ; $6FE0
    ld [hl], a                                    ; $6FE1

jr_005_6fe2:
    inc l                                         ; $6FE2
    inc l                                         ; $6FE3
    pop af                                        ; $6FE4
    dec b                                         ; $6FE5
    bit 7, b                                      ; $6FE6
    jp z, DjS2_WaveGraphColumn_RowLoop            ; $6FE8

    pop hl                                        ; $6FEB
    ld a, $03                                     ; $6FEC
    ld [wWaveRedrawCountdown], a                  ; $6FEE
    ret                                           ; $6FF1


; C: auto: 4 bytes, bytes; referenced by DjS2_WaveGraphColumn. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjS2_WaveGraphColumn_Tbl6FF2::
    db $c0, $30, $0c, $03

; C: auto: 4 bytes, bytes; referenced by DjS2_WaveGraphColumn. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F)
DjS2_WaveGraphColumn_Tbl6FF6::
    db $3f, $cf, $f3, $fc

; C: copies the wave graph to VRAM $9200 / $9300
DjS2_WaveGraphToVram::
    ld a, [wWaveRedrawCountdown]                  ; $6FFA
    and a                                         ; $6FFD
    ret z                                         ; $6FFE

    dec a                                         ; $6FFF
    ld [wWaveRedrawCountdown], a                  ; $7000
    jr nz, jr_005_7022                            ; $7003

    ld a, $00                                     ; $7005
    ld hl, wLevelTileStaging + $100               ; $7007
    ld de, $9200                                  ; $700A
    ld bc, $0080                                  ; $700D
    call Vram_CopyFromBank                        ; $7010
    ld a, $00                                     ; $7013
    ld hl, wLevelTileStaging + $180               ; $7015
    ld de, $9300                                  ; $7018
    ld bc, $0080                                  ; $701B
    call Vram_CopyFromBank                        ; $701E
    ret                                           ; $7021


jr_005_7022:
    cp $01                                        ; $7022
    ret nz                                        ; $7024

    ld a, $00                                     ; $7025
    ld hl, wLevelTileStaging                      ; $7027
    ld de, $9000                                  ; $702A
    ld bc, $0080                                  ; $702D
    call Vram_CopyFromBank                        ; $7030
    ld a, $00                                     ; $7033
    ld hl, wLevelTileStaging + $80                ; $7035
    ld de, $9100                                  ; $7038
    ld bc, $0080                                  ; $703B
    call Vram_CopyFromBank                        ; $703E
    ret                                           ; $7041


; C
DjNs_DrawAllValues::
    ld a, [wNoiseEnvelope + $2]                   ; $7042
    call DjEd_DrawVolumeDigits                    ; $7045
    ld a, [wNoiseEnvelope + $1]                   ; $7048
    call DjEd_DrawEnvPeriodDigit                  ; $704B
    ld a, [wNoiseGateLoop]                        ; $704E
    call DjEd_DrawLengthDigit                     ; $7051
    ld a, [wNoiseGateLoop + $1]                   ; $7054
    call DjEd_DrawLoopDigitsAndPrint              ; $7057
    ret                                           ; $705A


; C: handler of the DjNs field cursor value 0
DjNs_Field00_EnvDir::
    call DjNs_Field00_SyncCursor                  ; $705B
    call DjNs_Field00_Edit                        ; $705E
    call DjNs_Field00_DrawCursor                  ; $7061
    ldh a, [hKeysNew]                             ; $7064
    bit PADB_RIGHT, a                             ; $7066
    jr z, jr_005_7077                             ; $7068

    push af                                       ; $706A
    ld a, $01                                     ; $706B
    ld [wUiSfxRequest], a                         ; $706D
    pop af                                        ; $7070
    ld a, $01                                     ; $7071
    ld [wNoiseFieldCursor], a                     ; $7073
    ret                                           ; $7076


jr_005_7077:
    bit 7, a                                      ; $7077
    ret z                                         ; $7079

    push af                                       ; $707A
    ld a, $01                                     ; $707B
    ld [wUiSfxRequest], a                         ; $707D
    pop af                                        ; $7080
    ld a, [wNoiseFieldCursor]                     ; $7081
    ld [wNoiseFieldCursor + $2], a                ; $7084
    ld a, $04                                     ; $7087
    ld [wNoiseFieldCursor], a                     ; $7089
    xor a                                         ; $708C
    ld [wSndCursorPopFrames], a                   ; $708D
    ret                                           ; $7090


; C
DjNs_Field00_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7091
    ld hl, wNoiseFieldCursor + $1                 ; $7094
    cp [hl]                                       ; $7097
    ret z                                         ; $7098

    ld [hl], a                                    ; $7099
    ret                                           ; $709A


; C
DjNs_Field00_Edit::
    ld a, [wNoiseEnvelope]                        ; $709B
    ld bc, $0001                                  ; $709E
    call DjEd_StepValue_Up                        ; $70A1
    ld hl, wNoiseEnvelope                         ; $70A4
    cp [hl]                                       ; $70A7
    ret z                                         ; $70A8

    ld [hl], a                                    ; $70A9
    ld hl, $9884                                  ; $70AA
    add $da                                       ; $70AD
    call Vram_WriteByteSafe                       ; $70AF
    ret                                           ; $70B2


; C
DjNs_Field00_DrawCursor::
    ld bc, $1c1c                                  ; $70B3
    ld a, $95                                     ; $70B6
    call DjEd_DrawFieldCursor                     ; $70B8
    ldh a, [hFrameCounter]                        ; $70BB
    bit 4, a                                      ; $70BD
    ret z                                         ; $70BF

    ld a, [wNoiseEnvelope]                        ; $70C0
    sla a                                         ; $70C3
    sla a                                         ; $70C5
    add $26                                       ; $70C7
    ld c, a                                       ; $70C9
    ld b, $22                                     ; $70CA
    ld a, $78                                     ; $70CC
    call Oam_AddMeta_B01_5D47                     ; $70CE
    ret                                           ; $70D1


; C: handler of the DjNs field cursor value 1
DjNs_Field01_Volume::
    call DjNs_Field01_SyncCursor                  ; $70D2
    call DjNs_Field01_Edit                        ; $70D5
    call DjNs_Field01_DrawCursor                  ; $70D8
    ldh a, [hKeysNew]                             ; $70DB
    bit PADB_LEFT, a                              ; $70DD
    jr z, jr_005_70ee                             ; $70DF

    push af                                       ; $70E1
    ld a, $01                                     ; $70E2
    ld [wUiSfxRequest], a                         ; $70E4
    pop af                                        ; $70E7
    ld a, $00                                     ; $70E8
    ld [wNoiseFieldCursor], a                     ; $70EA
    ret                                           ; $70ED


jr_005_70ee:
    bit 4, a                                      ; $70EE
    jr z, jr_005_70ff                             ; $70F0

    push af                                       ; $70F2
    ld a, $01                                     ; $70F3
    ld [wUiSfxRequest], a                         ; $70F5
    pop af                                        ; $70F8
    ld a, $02                                     ; $70F9
    ld [wNoiseFieldCursor], a                     ; $70FB
    ret                                           ; $70FE


jr_005_70ff:
    bit 7, a                                      ; $70FF
    ret z                                         ; $7101

    push af                                       ; $7102
    ld a, $01                                     ; $7103
    ld [wUiSfxRequest], a                         ; $7105
    pop af                                        ; $7108
    ld a, [wNoiseFieldCursor]                     ; $7109
    ld [wNoiseFieldCursor + $2], a                ; $710C
    ld a, $04                                     ; $710F
    ld [wNoiseFieldCursor], a                     ; $7111
    xor a                                         ; $7114
    ld [wSndCursorPopFrames], a                   ; $7115
    ret                                           ; $7118


; C
DjNs_Field01_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7119
    ld hl, wNoiseFieldCursor + $1                 ; $711C
    cp [hl]                                       ; $711F
    ret z                                         ; $7120

    ld [hl], a                                    ; $7121
    ret                                           ; $7122


; C
DjNs_Field01_Edit::
    ld a, [wNoiseEnvelope + $2]                   ; $7123
    ld bc, $000f                                  ; $7126
    call DjEd_StepValue_Right                     ; $7129
    ld hl, wNoiseEnvelope + $2                    ; $712C
    cp [hl]                                       ; $712F
    ret z                                         ; $7130

    ld [hl], a                                    ; $7131
    ret                                           ; $7132


; C
DjNs_Field01_DrawCursor::
    ld bc, $1c1c                                  ; $7133
    ld a, $95                                     ; $7136
    call DjEd_DrawFieldCursor                     ; $7138
    ldh a, [hFrameCounter]                        ; $713B
    bit 4, a                                      ; $713D
    ret z                                         ; $713F

    ld bc, $312c                                  ; $7140
    ld a, $7d                                     ; $7143
    call Oam_AddMeta_B01_5D47                     ; $7145
    ret                                           ; $7148


; C: handler of the DjNs field cursor value 2
DjNs_Field02_EnvPeriod::
    call DjNs_Field02_SyncCursor                  ; $7149
    call DjNs_Field02_Edit                        ; $714C
    call DjNs_Field02_DrawCursor                  ; $714F
    ldh a, [hKeysNew]                             ; $7152
    bit PADB_LEFT, a                              ; $7154
    jr z, jr_005_7165                             ; $7156

    push af                                       ; $7158
    ld a, $01                                     ; $7159
    ld [wUiSfxRequest], a                         ; $715B
    pop af                                        ; $715E
    ld a, $01                                     ; $715F
    ld [wNoiseFieldCursor], a                     ; $7161
    ret                                           ; $7164


jr_005_7165:
    bit 4, a                                      ; $7165
    jr z, jr_005_7176                             ; $7167

    push af                                       ; $7169
    ld a, $01                                     ; $716A
    ld [wUiSfxRequest], a                         ; $716C
    pop af                                        ; $716F
    ld a, $03                                     ; $7170
    ld [wNoiseFieldCursor], a                     ; $7172
    ret                                           ; $7175


jr_005_7176:
    bit 7, a                                      ; $7176
    ret z                                         ; $7178

    push af                                       ; $7179
    ld a, $01                                     ; $717A
    ld [wUiSfxRequest], a                         ; $717C
    pop af                                        ; $717F
    ld a, [wNoiseFieldCursor]                     ; $7180
    ld [wNoiseFieldCursor + $2], a                ; $7183
    ld a, $04                                     ; $7186
    ld [wNoiseFieldCursor], a                     ; $7188
    xor a                                         ; $718B
    ld [wSndCursorPopFrames], a                   ; $718C
    ret                                           ; $718F


; C
DjNs_Field02_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7190
    ld hl, wNoiseFieldCursor + $1                 ; $7193
    cp [hl]                                       ; $7196
    ret z                                         ; $7197

    ld [hl], a                                    ; $7198
    ld [wNoiseFieldCursor + $2], a                ; $7199
    ret                                           ; $719C


; C
DjNs_Field02_Edit::
    ld a, [wNoiseEnvelope + $1]                   ; $719D
    ld bc, $0007                                  ; $71A0
    call DjEd_StepValue_Right                     ; $71A3
    ld hl, wNoiseEnvelope + $1                    ; $71A6
    cp [hl]                                       ; $71A9
    ret z                                         ; $71AA

    ld [hl], a                                    ; $71AB
    ret                                           ; $71AC


; C
DjNs_Field02_DrawCursor::
    ld bc, $1c1c                                  ; $71AD
    ld a, $95                                     ; $71B0
    call DjEd_DrawFieldCursor                     ; $71B2
    ldh a, [hFrameCounter]                        ; $71B5
    bit 4, a                                      ; $71B7
    ret z                                         ; $71B9

    ld bc, $422c                                  ; $71BA
    ld a, $7d                                     ; $71BD
    call Oam_AddMeta_B01_5D47                     ; $71BF
    ret                                           ; $71C2


; C: handler of the DjNs field cursor value 3
DjNs_Field03_Gate::
    call DjNs_Field03_SyncCursor                  ; $71C3
    call DjNs_Field03_Edit                        ; $71C6
    call DjNs_Field03_DrawCursor                  ; $71C9
    ldh a, [hKeysNew]                             ; $71CC
    bit PADB_LEFT, a                              ; $71CE
    jr z, jr_005_71df                             ; $71D0

    push af                                       ; $71D2
    ld a, $01                                     ; $71D3
    ld [wUiSfxRequest], a                         ; $71D5
    pop af                                        ; $71D8
    ld a, $02                                     ; $71D9
    ld [wNoiseFieldCursor], a                     ; $71DB
    ret                                           ; $71DE


jr_005_71df:
    bit 7, a                                      ; $71DF
    ret z                                         ; $71E1

    push af                                       ; $71E2
    ld a, $01                                     ; $71E3
    ld [wUiSfxRequest], a                         ; $71E5
    pop af                                        ; $71E8
    ld a, [wNoiseFieldCursor]                     ; $71E9
    ld [wNoiseFieldCursor + $2], a                ; $71EC
    ld a, $04                                     ; $71EF
    ld [wNoiseFieldCursor], a                     ; $71F1
    xor a                                         ; $71F4
    ld [wSndCursorPopFrames], a                   ; $71F5
    ret                                           ; $71F8


; C
DjNs_Field03_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $71F9
    ld hl, wNoiseFieldCursor + $1                 ; $71FC
    cp [hl]                                       ; $71FF
    ret z                                         ; $7200

    ld [hl], a                                    ; $7201
    ld [wNoiseFieldCursor + $2], a                ; $7202
    ret                                           ; $7205


; C
DjNs_Field03_Edit::
    ld a, [wNoiseGateLoop]                        ; $7206
    ld bc, $0009                                  ; $7209
    call DjEd_StepValue_Right                     ; $720C
    ld hl, wNoiseGateLoop                         ; $720F
    cp [hl]                                       ; $7212
    ret z                                         ; $7213

    ld [hl], a                                    ; $7214
    ret                                           ; $7215


; C
DjNs_Field03_DrawCursor::
    ld bc, $1c1c                                  ; $7216
    ld a, $95                                     ; $7219
    call DjEd_DrawFieldCursor                     ; $721B
    ldh a, [hFrameCounter]                        ; $721E
    bit 4, a                                      ; $7220
    ret z                                         ; $7222

    ld bc, $5a2a                                  ; $7223
    ld a, $7d                                     ; $7226
    call Oam_AddMeta_B01_5D47                     ; $7228
    ret                                           ; $722B


; C: handler of the DjNs field cursor value 4
DjNs_Field04_LoopLength::
    call DjNs_Field04_SyncCursor                  ; $722C
    call DjNs_Field04_Edit                        ; $722F
    call DjNs_Field04_DrawCursor                  ; $7232
    ldh a, [hKeysNew]                             ; $7235
    bit PADB_UP, a                                ; $7237
    jr z, jr_005_724d                             ; $7239

    push af                                       ; $723B
    ld a, $01                                     ; $723C
    ld [wUiSfxRequest], a                         ; $723E
    pop af                                        ; $7241
    ld a, [wNoiseFieldCursor + $2]                ; $7242
    ld [wNoiseFieldCursor], a                     ; $7245
    xor a                                         ; $7248
    ld [wSndCursorPopFrames], a                   ; $7249
    ret                                           ; $724C


jr_005_724d:
    bit 7, a                                      ; $724D
    ret z                                         ; $724F

    push af                                       ; $7250
    ld a, $01                                     ; $7251
    ld [wUiSfxRequest], a                         ; $7253
    pop af                                        ; $7256
    call DjEd_DrawLoopBar                         ; $7257
    call DjEd_DrawLoopBarNoise                    ; $725A
    ld a, $05                                     ; $725D
    ld [wNoiseFieldCursor], a                     ; $725F
    xor a                                         ; $7262
    ld [wSndCursorPopFrames], a                   ; $7263
    ret                                           ; $7266


; C
DjNs_Field04_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7267
    ld hl, wNoiseFieldCursor + $1                 ; $726A
    cp [hl]                                       ; $726D
    ret z                                         ; $726E

    ld [hl], a                                    ; $726F
    ret                                           ; $7270


; C
DjNs_Field04_Edit::
    ld a, [wNoiseGateLoop + $1]                   ; $7271
    ld bc, $0210                                  ; $7274
    call DjEd_StepValue_Right                     ; $7277
    ld [wNoiseGateLoop + $1], a                   ; $727A
    ld a, [wNoiseGateLoop + $1]                   ; $727D
    ld bc, $0210                                  ; $7280
    call DjEd_StepValue_LeftRight                 ; $7283
    ld [wNoiseGateLoop + $1], a                   ; $7286
    ret                                           ; $7289


; C
DjNs_Field04_DrawCursor::
    ld bc, $053d                                  ; $728A
    ld a, $9b                                     ; $728D
    call DjEd_DrawFieldCursor                     ; $728F
    ldh a, [hFrameCounter]                        ; $7292
    bit 4, a                                      ; $7294
    ret z                                         ; $7296

    ld bc, $0e46                                  ; $7297
    ld a, $7d                                     ; $729A
    call Oam_AddMeta_B01_5D47                     ; $729C
    ret                                           ; $729F


; C: handler of the DjNs field cursor value 5
DjNs_Field05_NoteGrid::
    call DjNs_Field05_SyncCursor                  ; $72A0
    call DjNs_Field05_Edit                        ; $72A3
    call DjNs_Field05_DrawCursor                  ; $72A6
    ldh a, [hKeysNew]                             ; $72A9
    bit PADB_UP, a                                ; $72AB
    jr z, jr_005_72c0                             ; $72AD

    push af                                       ; $72AF
    ld a, $01                                     ; $72B0
    ld [wUiSfxRequest], a                         ; $72B2
    pop af                                        ; $72B5
    ld a, $04                                     ; $72B6
    ld [wNoiseFieldCursor], a                     ; $72B8
    xor a                                         ; $72BB
    ld [wSndCursorPopFrames], a                   ; $72BC
    ret                                           ; $72BF


jr_005_72c0:
    bit 3, a                                      ; $72C0
    jr z, jr_005_72d1                             ; $72C2

    push af                                       ; $72C4
    ld a, $04                                     ; $72C5
    ld [wUiSfxRequest], a                         ; $72C7
    pop af                                        ; $72CA
    ld a, $07                                     ; $72CB
    ld [wNoiseFieldCursor], a                     ; $72CD
    ret                                           ; $72D0


jr_005_72d1:
    bit 0, a                                      ; $72D1
    ret z                                         ; $72D3

    push af                                       ; $72D4
    ld a, $04                                     ; $72D5
    ld [wUiSfxRequest], a                         ; $72D7
    pop af                                        ; $72DA
    ld a, $06                                     ; $72DB
    ld [wNoiseFieldCursor], a                     ; $72DD
    ret                                           ; $72E0


; C
DjNs_Field05_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $72E1
    ld hl, wNoiseFieldCursor + $1                 ; $72E4
    cp [hl]                                       ; $72E7
    ret z                                         ; $72E8

    ld [hl], a                                    ; $72E9
    ret                                           ; $72EA


; C
DjNs_Field05_Edit::
    ld a, [wNoiseNoteCursor]                      ; $72EB
    ld bc, $000f                                  ; $72EE
    call DjEd_StepLeftRight                       ; $72F1
    ld [wNoiseNoteCursor], a                      ; $72F4
    ld a, [wNoiseNoteCursor]                      ; $72F7
    ld c, a                                       ; $72FA
    ld b, $00                                     ; $72FB
    ld hl, wNoiseNotes                            ; $72FD
    add hl, bc                                    ; $7300
    ldh a, [hKeysNew]                             ; $7301
    bit PADB_DOWN, a                              ; $7303
    ret z                                         ; $7305

    xor a                                         ; $7306
    ld [hl], a                                    ; $7307
    ld a, [wNoiseNoteCursor]                      ; $7308
    ld hl, wNoiseNotes                            ; $730B
    call DjEd_DrawNoteRowOffset                   ; $730E
    ret                                           ; $7311


; C
DjNs_Field05_DrawCursor::
    ld bc, $0557                                  ; $7312
    ld a, $9e                                     ; $7315
    call DjEd_DrawFieldCursor                     ; $7317
    ldh a, [hFrameCounter]                        ; $731A
    bit 4, a                                      ; $731C
    jr z, jr_005_7333                             ; $731E

    ld a, [wNoiseNoteCursor]                      ; $7320
    sla a                                         ; $7323
    sla a                                         ; $7325
    sla a                                         ; $7327
    add $1d                                       ; $7329
    ld b, a                                       ; $732B
    ld c, $57                                     ; $732C
    ld a, $7c                                     ; $732E
    call Oam_AddMeta_B01_5D47                     ; $7330

jr_005_7333:
    ld a, [wNoiseNoteCursor]                      ; $7333
    call DjEd_DrawNoteMarker                      ; $7336
    ld hl, wNoiseNotes                            ; $7339
    ld a, [wNoiseNoteCursor]                      ; $733C
    call DjEd_DrawNoteStepCursor                  ; $733F
    ld e, $00                                     ; $7342
    ld hl, wNoiseStereoWidth                      ; $7344
    ld a, [wNoiseNoteCursor]                      ; $7347
    call DjEd_DrawNoteColumn                      ; $734A
    ld e, $00                                     ; $734D
    ld hl, wNoiseStereoWidth                      ; $734F
    ld a, [wNoiseNoteCursor]                      ; $7352
    call DjEd_DrawWidthFlag                       ; $7355
    ret                                           ; $7358


; C: handler of the DjNs field cursor value 6
DjNs_Field06_NoteEdit::
    call DjNs_Field06_SyncCursor                  ; $7359
    call DjNs_Field06_Edit                        ; $735C
    call DjNs_Field06_DrawCursor                  ; $735F
    ldh a, [hKeysHeld]                            ; $7362
    bit PADB_A, a                                 ; $7364
    ret nz                                        ; $7366

    push af                                       ; $7367
    ld a, $05                                     ; $7368
    ld [wUiSfxRequest], a                         ; $736A
    pop af                                        ; $736D
    call DjNs_Field06_DrawMarker                  ; $736E
    ld a, $07                                     ; $7371
    ld [wNoiseFieldCursor], a                     ; $7373
    ret                                           ; $7376


; C
DjNs_Field06_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $7377
    ld hl, wNoiseFieldCursor + $1                 ; $737A
    cp [hl]                                       ; $737D
    ret z                                         ; $737E

    ld [hl], a                                    ; $737F
    ret                                           ; $7380


; C
DjNs_Field06_Edit::
    ld a, [wNoiseNoteCursor]                      ; $7381
    ld c, a                                       ; $7384
    ld b, $00                                     ; $7385
    ld hl, wNoiseNotes                            ; $7387
    add hl, bc                                    ; $738A
    ld bc, $0025                                  ; $738B
    ld a, [hl]                                    ; $738E
    push hl                                       ; $738F
    call DjEd_StepLeftRight                       ; $7390
    pop hl                                        ; $7393
    cp [hl]                                       ; $7394
    jr z, jr_005_739b                             ; $7395

    ld [hl], a                                    ; $7397
    call DjNs_Field06_DrawMarker                  ; $7398

jr_005_739b:
    ld a, [wNoiseNoteCursor]                      ; $739B
    ld c, a                                       ; $739E
    ld b, $00                                     ; $739F
    ld hl, wNoiseStereoWidth                      ; $73A1
    add hl, bc                                    ; $73A4
    ld bc, $0001                                  ; $73A5
    ld a, [hl]                                    ; $73A8
    and $10                                       ; $73A9
    swap a                                        ; $73AB
    ld e, a                                       ; $73AD
    push hl                                       ; $73AE
    call DjEd_StepUpDown                          ; $73AF
    pop hl                                        ; $73B2
    cp e                                          ; $73B3
    ret z                                         ; $73B4

    swap a                                        ; $73B5
    ld e, a                                       ; $73B7
    ld a, [hl]                                    ; $73B8
    and $0f                                       ; $73B9
    or e                                          ; $73BB
    ld [hl], a                                    ; $73BC
    ret                                           ; $73BD


; C
DjNs_Field06_DrawCursor::
    ld bc, $0557                                  ; $73BE
    ld a, $9e                                     ; $73C1
    call DjEd_DrawFieldCursor                     ; $73C3
    ld hl, wNoiseNotes                            ; $73C6
    ld a, [wNoiseNoteCursor]                      ; $73C9
    call DjEd_DrawNoteStepCursor                  ; $73CC
    ldh a, [hKeysHeld]                            ; $73CF
    and PADF_RIGHT | PADF_LEFT                    ; $73D1
    ld hl, wNoiseNotes                            ; $73D3
    ld a, [wNoiseNoteCursor]                      ; $73D6
    call z, DjEd_DrawNoteCursorBlink              ; $73D9
    ld a, [wNoiseNoteCursor]                      ; $73DC
    sla a                                         ; $73DF
    sla a                                         ; $73E1
    sla a                                         ; $73E3
    add $1d                                       ; $73E5
    ld b, a                                       ; $73E7
    ld c, $57                                     ; $73E8
    ld a, $7c                                     ; $73EA
    call Oam_AddMeta_B01_5D47                     ; $73EC
    ld e, $00                                     ; $73EF
    ld hl, wNoiseStereoWidth                      ; $73F1
    ld a, [wNoiseNoteCursor]                      ; $73F4
    call DjEd_DrawNoteColumn                      ; $73F7
    ld e, $00                                     ; $73FA
    ld hl, wNoiseStereoWidth                      ; $73FC
    ld a, [wNoiseNoteCursor]                      ; $73FF
    call DjEd_DrawWidthFlag                       ; $7402
    ret                                           ; $7405


; C: L3 pass 2026-10-26: no organic run reached it (BGB replays, BGB scenarios, core organic runs); C from the code:
; draws the marker of NOISE field 6 (note edit)
DjNs_Field06_DrawMarker::
    ld a, [wNoiseNoteCursor]                      ; $7406
    ld hl, wNoiseNotes                            ; $7409
    call DjEd_DrawNoteRowOffset                   ; $740C
    ret                                           ; $740F


; C: handler of the DjNs field cursor value 7
DjNs_Field07_StereoEdit::
    call DjNs_Field07_SyncCursor                  ; $7410
    call DjNs_Field07_Edit                        ; $7413
    call DjNs_Field07_DrawCursor                  ; $7416
    ldh a, [hKeysHeld]                            ; $7419
    bit PADB_START, a                             ; $741B
    ret nz                                        ; $741D

    push af                                       ; $741E
    ld a, $05                                     ; $741F
    ld [wUiSfxRequest], a                         ; $7421
    pop af                                        ; $7424
    ld a, $05                                     ; $7425
    ld [wNoiseFieldCursor], a                     ; $7427
    ret                                           ; $742A


; C
DjNs_Field07_SyncCursor::
    ld a, [wNoiseFieldCursor]                     ; $742B
    ld hl, wNoiseFieldCursor + $1                 ; $742E
    cp [hl]                                       ; $7431
    ret z                                         ; $7432

    ld [hl], a                                    ; $7433
    ld a, [wNoiseNoteCursor]                      ; $7434
    ld c, a                                       ; $7437
    ld b, $00                                     ; $7438
    ld hl, wNoiseStereoWidth                      ; $743A
    add hl, bc                                    ; $743D
    ld a, [hl]                                    ; $743E
    and $03                                       ; $743F
    ld [wNoiseStereoEdit], a                      ; $7441
    ret                                           ; $7444


; C
DjNs_Field07_Edit::
    ld a, [wNoiseStereoEdit]                      ; $7445
    ld bc, $0002                                  ; $7448
    call DjEd_StepLeftRight                       ; $744B
    ld [wNoiseStereoEdit], a                      ; $744E
    ld a, [wNoiseNoteCursor]                      ; $7451
    ld c, a                                       ; $7454
    ld b, $00                                     ; $7455
    ld hl, wNoiseStereoWidth                      ; $7457
    add hl, bc                                    ; $745A
    push hl                                       ; $745B
    ld a, [hl]                                    ; $745C
    and $f0                                       ; $745D
    ld hl, wNoiseStereoEdit                       ; $745F
    or [hl]                                       ; $7462
    pop hl                                        ; $7463
    ld [hl], a                                    ; $7464
    ret                                           ; $7465


; C
DjNs_Field07_DrawCursor::
    ld bc, $0557                                  ; $7466
    ld a, $9e                                     ; $7469
    call DjEd_DrawFieldCursor                     ; $746B
    ld a, [wNoiseNoteCursor]                      ; $746E
    sla a                                         ; $7471
    sla a                                         ; $7473
    sla a                                         ; $7475
    add $1d                                       ; $7477
    ld b, a                                       ; $7479
    ld c, $57                                     ; $747A
    ld a, $7c                                     ; $747C
    call Oam_AddMeta_B01_5D47                     ; $747E
    ld hl, wNoiseNotes                            ; $7481
    ld a, [wNoiseNoteCursor]                      ; $7484
    call DjEd_DrawNoteStepCursor                  ; $7487
    ldh a, [hFrameCounter]                        ; $748A
    srl a                                         ; $748C
    srl a                                         ; $748E
    srl a                                         ; $7490
    and $01                                       ; $7492
    ld e, a                                       ; $7494
    ld hl, wNoiseStereoWidth                      ; $7495
    ld a, [wNoiseNoteCursor]                      ; $7498
    call DjEd_DrawNoteColumn                      ; $749B
    ldh a, [hFrameCounter]                        ; $749E
    srl a                                         ; $74A0
    srl a                                         ; $74A2
    srl a                                         ; $74A4
    and $01                                       ; $74A6
    ld e, a                                       ; $74A8
    ld hl, wNoiseStereoWidth                      ; $74A9
    ld a, [wNoiseNoteCursor]                      ; $74AC
    call DjEd_DrawWidthFlag                       ; $74AF
    ret                                           ; $74B2


; C
DjNs_DrawPlayCursor::
    ld a, [wNoisePlayStep]                        ; $74B3
    call DjEd_DrawPlayCursor                      ; $74B6
    ld a, [wNoiseFieldCursor]                     ; $74B9
    cp $05                                        ; $74BC
    ret z                                         ; $74BE

    cp $06                                        ; $74BF
    ret z                                         ; $74C1

    cp $07                                        ; $74C2
    ret z                                         ; $74C4

    call DjEd_DrawLoopBar                         ; $74C5
    call DjEd_DrawLoopBarNoise                    ; $74C8
    ret                                           ; $74CB


; C: mode 20: BALL
Mode20_Ball::
    ld a, [wState]                                ; $74CC
    rst Rst18_JumpTable                           ; $74CF

; C: 12 states
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
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $74E8
    ldh [hLcdcShadow], a                          ; $74EA
    ld a, $e4                                     ; $74EC
    ld [wPaletteTarget], a                        ; $74EE
    ld [wPaletteTarget + $1], a                   ; $74F1
    ld a, $d2                                     ; $74F4
    ld [wPaletteTarget + $2], a                   ; $74F6
    xor a                                         ; $74F9
    ldh [hScxShadow], a                           ; $74FA
    ldh [hScyShadow], a                           ; $74FC
    ld [wMenuRow], a                              ; $74FE
    ldh [hFarcallAArg], a                         ; $7501
    farcall GameFace_LoadTiles_Far                ; $7503
    ld a, [wGamefacePresent]                      ; $750B
    and a                                         ; $750E
    jr z, jr_005_7516                             ; $750F

    ld a, $02                                     ; $7511
    ld [wPickCharacter], a                        ; $7513

jr_005_7516:
    farcopy Mem_CopyFromBank, Gfx_1A_6400_Mode20_State00_MenuInit, $9000, $0800 ; $7516
    farcopy Mem_CopyFromBank, Gfx_1A_6C00_Mode20_State00_MenuInit, $8800, $0800 ; $7524
    farcopy Mem_CopyFromBank, Gfx_1A_7400_Mode20_State00_MenuInit, $8000, $0200 ; $7532
    farcopy Mem_CopyFromBank, Map_24_4480_Mode20_State00_MenuInit, $9800, $0240 ; $7540
    call Oam_ClearShadow                          ; $754E
    call Pal_AllWhite                             ; $7551
    call Lcd_On                                   ; $7554
    xor a                                         ; $7557
    call Ball_DrawMenuBall                        ; $7558
    push af                                       ; $755B
    ld a, MUSIC_BALL_MENU                         ; $755C
    call Snd_Music                                ; $755E
    pop af                                        ; $7561
    call Pal_FadeIn                               ; $7562
    next_state                                    ; $7565
    ret                                           ; $7569


; C
Mode20_State01_Menu::
    call Ball_MenuInput                           ; $756A
    call Ball_MenuDrawCursor                      ; $756D
    call Ball_MenuAnimA                           ; $7570
    call Ball_MenuAnimate                         ; $7573
    xor a                                         ; $7576
    call Ball_DrawMenuBall                        ; $7577
    ldh a, [hKeysNew]                             ; $757A
    bit PADB_A, a                                 ; $757C
    jr z, jr_005_759d                             ; $757E

    push af                                       ; $7580
    ld a, SFX1_CHOOSE_D                           ; $7581
    call Snd_Sfx1                                 ; $7583
    pop af                                        ; $7586
    ld a, $01                                     ; $7587
    call Ball_MenuBlinkSelection                  ; $7589
    call Pal_FadeOut                              ; $758C
    call Lcd_Off                                  ; $758F
    ld a, [wMode]                                 ; $7592
    ld [wMode20Caller], a                         ; $7595
    next_state                                    ; $7598
    ret                                           ; $759C


jr_005_759d:
    bit 1, a                                      ; $759D
    ret z                                         ; $759F

    push af                                       ; $75A0
    ld a, SFX1_TAG_DIGITS_JINGLE                  ; $75A1
    call Snd_Sfx1                                 ; $75A3
    pop af                                        ; $75A6
    ld a, $02                                     ; $75A7
    call Ball_MenuBlinkSelection                  ; $75A9
    call Pal_FadeOut                              ; $75AC
    call Lcd_Off                                  ; $75AF
    ld a, MODE_MAIN_MENU                          ; $75B2
    ld [wMode], a                                 ; $75B4
    set_state STATE_00_INIT                       ; $75B7
    ret                                           ; $75BC


; C
Ball_MenuInput::
    ldh a, [hKeysNew]                             ; $75BD
    bit PADB_UP, a                                ; $75BF
    jr z, jr_005_75c6                             ; $75C1

    xor a                                         ; $75C3
    jr jr_005_75cc                                ; $75C4

jr_005_75c6:
    bit 7, a                                      ; $75C6
    jr z, jr_005_75dd                             ; $75C8

    ld a, $01                                     ; $75CA

jr_005_75cc:
    ld hl, wMenuRow                               ; $75CC
    cp [hl]                                       ; $75CF
    jr z, jr_005_75dd                             ; $75D0

    ld [hl], a                                    ; $75D2
    push af                                       ; $75D3
    ld a, SFX1_MENU_CHOOSE                        ; $75D4
    call Snd_Sfx1                                 ; $75D6
    pop af                                        ; $75D9
    call Ball_MenuLoadRow                         ; $75DA

jr_005_75dd:
    ld a, [wMenuRow]                              ; $75DD
    ld c, a                                       ; $75E0
    ld b, $00                                     ; $75E1
    ld hl, wPickMusic                             ; $75E3
    add hl, bc                                    ; $75E6
    inc c                                         ; $75E7
    ldh a, [hKeysNew]                             ; $75E8
    ld b, a                                       ; $75EA
    ld a, [hl]                                    ; $75EB
    bit 5, b                                      ; $75EC
    jr z, jr_005_75f5                             ; $75EE

    and a                                         ; $75F0
    ret z                                         ; $75F1

    dec a                                         ; $75F2
    jr jr_005_75fb                                ; $75F3

jr_005_75f5:
    bit 4, b                                      ; $75F5
    ret z                                         ; $75F7

    cp c                                          ; $75F8
    ret z                                         ; $75F9

    inc a                                         ; $75FA

jr_005_75fb:
    ld [hl], a                                    ; $75FB
    push af                                       ; $75FC
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $75FD
    call Snd_Sfx1                                 ; $75FF
    pop af                                        ; $7602
    ret                                           ; $7603


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuDrawCursor::
    ld a, [wMenuRow]                              ; $7604
    ld c, a                                       ; $7607
    ld b, $00                                     ; $7608
    ld hl, wPickMusic                             ; $760A
    add hl, bc                                    ; $760D
    ld a, [wMenuRow]                              ; $760E
    ld c, a                                       ; $7611
    sla a                                         ; $7612
    add c                                         ; $7614
    add [hl]                                      ; $7615
    ld c, a                                       ; $7616
    sla c                                         ; $7617
    ld hl, Ball_MenuDrawCursor_Tbl762B            ; $7619
    add hl, bc                                    ; $761C
    ld c, [hl]                                    ; $761D
    inc hl                                        ; $761E
    ld b, [hl]                                    ; $761F
    ldh a, [hFrameCounter]                        ; $7620
    bit 3, a                                      ; $7622
    ret z                                         ; $7624

    ld a, $8e                                     ; $7625
    call Oam_AddMeta_B02_5272                     ; $7627
    ret                                           ; $762A


; C: auto: 12 bytes, bytes; referenced by Ball_MenuDrawCursor. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuDrawCursor_Tbl762B::
    db $08, $60, $08, $70, $08, $80, $88, $60, $88, $70, $88, $80

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimate::
    call Ball_MenuAnimB                           ; $7637
    call Ball_MenuAnimC                           ; $763A
    ret                                           ; $763D


; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB::
    ld a, [wMenuRow]                              ; $763E
    and a                                         ; $7641
    jr z, jr_005_764a                             ; $7642

    xor a                                         ; $7644
    ld [wMenuAnimBPhase], a                       ; $7645
    jr jr_005_7663                                ; $7648

jr_005_764a:
    ld a, [wMenuAnimBTick]                        ; $764A
    inc a                                         ; $764D
    cp $04                                        ; $764E
    jr c, jr_005_765f                             ; $7650

    ld a, [wMenuAnimBPhase]                       ; $7652
    inc a                                         ; $7655
    cp $04                                        ; $7656
    jr c, jr_005_765b                             ; $7658

    xor a                                         ; $765A

jr_005_765b:
    ld [wMenuAnimBPhase], a                       ; $765B
    xor a                                         ; $765E

jr_005_765f:
    inc a                                         ; $765F
    ld [wMenuAnimBTick], a                        ; $7660

jr_005_7663:
    ld a, [wPickMusic]                            ; $7663
    sla a                                         ; $7666
    ld c, a                                       ; $7668
    ld b, $00                                     ; $7669
    ld hl, Ball_MenuAnimB_Tbl7681                 ; $766B
    add hl, bc                                    ; $766E
    ld c, [hl]                                    ; $766F
    inc hl                                        ; $7670
    ld b, [hl]                                    ; $7671
    ld a, [wMenuAnimBPhase]                       ; $7672
    ld e, a                                       ; $7675
    ld d, $00                                     ; $7676
    ld hl, Ball_MenuAnimB_Tbl7687                 ; $7678
    add hl, de                                    ; $767B
    ld a, [hl]                                    ; $767C
    call Oam_AddMeta_B02_5272                     ; $767D
    ret                                           ; $7680


; C: auto: 6 bytes, bytes; referenced by Ball_MenuAnimB. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB_Tbl7681::
    db $18, $60, $18, $70, $18, $80

; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimB. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimB_Tbl7687::
    db $84, $85, $86, $85

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC::
    ld a, [wMenuRow]                              ; $768B
    and a                                         ; $768E
    jr nz, jr_005_7697                            ; $768F

    xor a                                         ; $7691
    ld [wMenuAnimCPhase], a                       ; $7692
    jr jr_005_76b0                                ; $7695

jr_005_7697:
    ld a, [wMenuAnimCTick]                        ; $7697
    inc a                                         ; $769A
    cp $04                                        ; $769B
    jr c, jr_005_76ac                             ; $769D

    ld a, [wMenuAnimCPhase]                       ; $769F
    inc a                                         ; $76A2
    cp $04                                        ; $76A3
    jr c, jr_005_76a8                             ; $76A5

    xor a                                         ; $76A7

jr_005_76a8:
    ld [wMenuAnimCPhase], a                       ; $76A8
    xor a                                         ; $76AB

jr_005_76ac:
    inc a                                         ; $76AC
    ld [wMenuAnimCTick], a                        ; $76AD

jr_005_76b0:
    ld a, [wPickCharacter]                        ; $76B0
    sla a                                         ; $76B3
    ld c, a                                       ; $76B5
    ld b, $00                                     ; $76B6
    ld hl, Ball_MenuAnimC_Tbl76CE                 ; $76B8
    add hl, bc                                    ; $76BB
    ld c, [hl]                                    ; $76BC
    inc hl                                        ; $76BD
    ld b, [hl]                                    ; $76BE
    ld a, [wMenuAnimCPhase]                       ; $76BF
    ld e, a                                       ; $76C2
    ld d, $00                                     ; $76C3
    ld hl, Ball_MenuAnimC_Tbl76D4                 ; $76C5
    add hl, de                                    ; $76C8
    ld a, [hl]                                    ; $76C9
    call Oam_AddMeta_B02_5272                     ; $76CA
    ret                                           ; $76CD


; C: auto: 6 bytes, bytes; referenced by Ball_MenuAnimC. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC_Tbl76CE::
    db $80, $60, $80, $70, $80, $80

; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimC. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimC_Tbl76D4::
    db $81, $82, $83, $82

; C: L3 pass 2026-10-26: executed in BGB in 5 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA::
    ld a, [wMenuAnimATick]                        ; $76D8
    inc a                                         ; $76DB
    cp $03                                        ; $76DC
    jr c, jr_005_76ed                             ; $76DE

    ld a, [wMenuAnimAPhase]                       ; $76E0
    inc a                                         ; $76E3
    cp $0c                                        ; $76E4
    jr c, jr_005_76e9                             ; $76E6

    xor a                                         ; $76E8

jr_005_76e9:
    ld [wMenuAnimAPhase], a                       ; $76E9
    xor a                                         ; $76EC

jr_005_76ed:
    inc a                                         ; $76ED
    ld [wMenuAnimATick], a                        ; $76EE
    ld a, [wMenuRow]                              ; $76F1
    sla a                                         ; $76F4
    ld c, a                                       ; $76F6
    ld b, $00                                     ; $76F7
    ld hl, Ball_MenuAnimA_Tbl770F                 ; $76F9
    add hl, bc                                    ; $76FC
    ld c, [hl]                                    ; $76FD
    inc hl                                        ; $76FE
    ld b, [hl]                                    ; $76FF
    ld a, [wMenuAnimAPhase]                       ; $7700
    ld e, a                                       ; $7703
    ld d, $00                                     ; $7704
    ld hl, Ball_MenuAnimA_Tbl7713                 ; $7706
    add hl, de                                    ; $7709
    ld a, [hl]                                    ; $770A
    call Oam_AddMeta_B02_5272                     ; $770B
    ret                                           ; $770E


; C: auto: 4 bytes, bytes; referenced by Ball_MenuAnimA. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA_Tbl770F::
    db $11, $30, $91, $30

; C: auto: 12 bytes, bytes; referenced by Ball_MenuAnimA. L3 pass 2026-10-26: read in BGB in 5 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuAnimA_Tbl7713::
    db $87, $88, $89, $8a, $8b, $8c, $8d, $8c, $8b, $8a, $89, $88

; C: L3 pass 2026-10-26: executed in BGB in 6 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawMenuBall::
    ld bc, $1870                                  ; $771F
    add $7e                                       ; $7722
    call Oam_AddMeta_B02_5272                     ; $7724
    ret                                           ; $7727


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_MenuBlinkSelection::
    ldh [hScratchA], a                            ; $7728
    call Oam_HideUnused                           ; $772A
    rst Rst08_WaitVBlank                          ; $772D
    ld b, $03                                     ; $772E

jr_005_7730:
    ld d, $00                                     ; $7730
    ld c, $02                                     ; $7732

jr_005_7734:
    push bc                                       ; $7734
    ld a, b                                       ; $7735
    add $02                                       ; $7736

jr_005_7738:
    push af                                       ; $7738
    ld a, d                                       ; $7739
    call Ball_DrawMenuBall                        ; $773A
    call Oam_HideUnused                           ; $773D
    rst Rst08_WaitVBlank                          ; $7740
    pop af                                        ; $7741
    dec a                                         ; $7742
    jr nz, jr_005_7738                            ; $7743

    pop bc                                        ; $7745
    ldh a, [hScratchA]                            ; $7746
    ld d, a                                       ; $7748
    dec c                                         ; $7749
    jr nz, jr_005_7734                            ; $774A

    dec b                                         ; $774C
    jr nz, jr_005_7730                            ; $774D

    ret                                           ; $774F


; C: L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of the core emulator
; (coverage/results/merged_state/cov.npz)
Ball_MenuLoadRow::
    ld a, [wMenuRow]                              ; $7750
    and a                                         ; $7753
    jr nz, jr_005_7765                            ; $7754

    farcopy Vram_CopyFromBank, Map_24_4480_Ball_MenuLoadRow_Part4500, $9880, $0100 ; $7756
    ret                                           ; $7764


jr_005_7765:
    farcopy Vram_CopyFromBank, Map_24_46C0_Ball_MenuLoadRow, $9880, $0100 ; $7765
    ret                                           ; $7773


; C
Mode20_State02_GameSetup::
    ld a, LCDCF_WIN9C00 | LCDCF_OBJON | LCDCF_BGON ; $7774
    ldh [hLcdcShadow], a                          ; $7776
    ld a, $e4                                     ; $7778
    ld [wPaletteTarget], a                        ; $777A
    ld [wPaletteTarget + $1], a                   ; $777D
    ld a, $d2                                     ; $7780
    ld [wPaletteTarget + $2], a                   ; $7782
    ld a, $00                                     ; $7785
    ldh [hScxShadow], a                           ; $7787
    ldh [hScxBand1], a                            ; $7789
    xor a                                         ; $778B
    ldh [hScyShadow], a                           ; $778C
    ldh [hScyBand1], a                            ; $778E
    ldh [hScxBand2], a                            ; $7790
    ld a, $98                                     ; $7792
    ldh [hScyBand2], a                            ; $7794
    ldh [hFarcallAArg], a                         ; $7796
    farcall Counters_Load_Far                     ; $7798
    farcopy Mem_CopyFromBank, Gfx_1D_5D00_Mode20_State02_GameSetup, $8000, $0d80 ; $77A0
    farcopy Mem_CopyFromBank, Map_22_7740_Mode20_State02_GameSetup, $9800, $0400 ; $77AE
    farcopy Mem_CopyFromBank, Map_22_5F40_Mode20_State02_GameSetup, $9c00, $0400 ; $77BC
    ldh [hFarcallAArg], a                         ; $77CA
    farcall GameFace_LoadTiles_Far                ; $77CC
    call Ball_LoadCharacterGfx                    ; $77D4
    ld a, $27                                     ; $77D7
    ldh [hLycShadowSplit1], a                     ; $77D9
    ldh [hSplit1Latch], a                         ; $77DB
    ld hl, hStatShadow                            ; $77DD
    set 6, [hl]                                   ; $77E0
    ld hl, rIE                                    ; $77E2
    set 1, [hl]                                   ; $77E5
    ld a, $05                                     ; $77E7
    ldh [hStatHandlerIndex], a                    ; $77E9
    call Oam_ClearShadow                          ; $77EB
    call Pal_AllWhite                             ; $77EE
    call Lcd_On                                   ; $77F1
    call Ball_DrawHud                             ; $77F4
    next_state                                    ; $77F7
    ret                                           ; $77FB


; C
Mode20_State03_GameStart::
    ld a, [wPickMusic]                            ; $77FC
    ld hl, Mode20_State03_GameStart_Tbl781B       ; $77FF
    call Snd_PlayFromList                         ; $7802
    call Ball_DrawHud                             ; $7805
    call Ball_ResetGame                           ; $7808
    call Ball_DrawScore                           ; $780B
    ld c, $00                                     ; $780E
    call Ball_LoadGfx8D80                         ; $7810
    call Pal_FadeIn                               ; $7813
    next_state                                    ; $7816
    ret                                           ; $781A


; C: auto: 4 bytes, bytes; referenced by Mode20_State03_GameStart, Mode20_State07_Pause. L3 pass 2026-10-26: read in
; BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Mode20_State03_GameStart_Tbl781B::
    db MUSIC_BALL_BGM_1, SNDCH_MUSIC  ; #1
    db MUSIC_BALL_BGM_2, SNDCH_MUSIC  ; #2

; C
Mode20_State04_Play::
    call Ball_DrawHud                             ; $781F
    call Ball_StepObjects                         ; $7822
    call Ball_PlayerInput                         ; $7825
    call Ball_Animate                             ; $7828
    call Ball_DrawPlayer                          ; $782B
    call Ball_ScrollBg                            ; $782E
    call Ball_PoseScroll                          ; $7831
    call Ball_DrawObjects                         ; $7834
    call Ball_Collide                             ; $7837
    ldh a, [hKeysNew]                             ; $783A
    bit PADB_START, a                             ; $783C
    ret z                                         ; $783E

    push af                                       ; $783F
    ld a, SFX1_KEY_START                          ; $7840
    call Snd_Sfx1                                 ; $7842
    pop af                                        ; $7845
    ld bc, $000a                                  ; $7846
    call Wait_Frames                              ; $7849
    push af                                       ; $784C
    ld a, MUSIC_STOP                              ; $784D
    call Snd_Music                                ; $784F
    pop af                                        ; $7852
    set_state STATE_20_PAUSE                      ; $7853
    ret                                           ; $7858


; C: input from the demo / autopilot (7DCC)
Mode20_State05_PlayDemo::
    ldh a, [hKeysNew]                             ; $7859
    push af                                       ; $785B
    call Ball_DemoInput                           ; $785C
    call Ball_DrawHud                             ; $785F
    call Ball_StepObjects                         ; $7862
    call Ball_PlayerInput                         ; $7865
    call Ball_Animate                             ; $7868
    call Ball_DrawPlayer                          ; $786B
    call Ball_ScrollBg                            ; $786E
    call Ball_PoseScroll                          ; $7871
    call Ball_DrawObjects                         ; $7874
    call Ball_Collide                             ; $7877
    pop af                                        ; $787A
    and a                                         ; $787B
    ret z                                         ; $787C

    set_state STATE_20_GAME_START                 ; $787D
    call Pal_FadeOut                              ; $7882
    ret                                           ; $7885


; C
Mode20_State06_GameOver::
    call Ball_DrawHud                             ; $7886
    call Ball_DrawPlayer                          ; $7889
    call Ball_DrawObjects                         ; $788C
    ld a, [wBallGameoverBlink]                    ; $788F
    dec a                                         ; $7892
    call z, Ball_FlipPalettes                     ; $7893
    jr nz, jr_005_78a7                            ; $7896

    push af                                       ; $7898
    ld a, MUSIC_BALL_GAME_OVER                    ; $7899
    call Snd_Music                                ; $789B
    pop af                                        ; $789E
    push af                                       ; $789F
    rst Rst08_WaitVBlank                          ; $78A0
    ld c, $03                                     ; $78A1
    call Ball_LoadGfx8D80                         ; $78A3
    pop af                                        ; $78A6

jr_005_78a7:
    bit 7, a                                      ; $78A7
    jr nz, jr_005_78ae                            ; $78A9

    ld [wBallGameoverBlink], a                    ; $78AB

jr_005_78ae:
    ld a, [wBallGameoverTimeout]                  ; $78AE
    dec a                                         ; $78B1
    jr nz, jr_005_78cf                            ; $78B2

    ldh a, [hKeysNew]                             ; $78B4
    and a                                         ; $78B6
    jr z, jr_005_78d2                             ; $78B7

    call Pal_FadeOut                              ; $78B9
    call Lcd_Off                                  ; $78BC
    ld hl, hStatShadow                            ; $78BF
    res 6, [hl]                                   ; $78C2
    ld hl, rIE                                    ; $78C4
    res 1, [hl]                                   ; $78C7
    set_state STATE_20_RESULT_INIT                ; $78C9
    ret                                           ; $78CE


jr_005_78cf:
    ld [wBallGameoverTimeout], a                  ; $78CF

jr_005_78d2:
    ldh a, [hFrameCounter]                        ; $78D2
    and a                                         ; $78D4
    ret nz                                        ; $78D5

    ld hl, wBallGameoverDelay                     ; $78D6
    dec [hl]                                      ; $78D9
    ret nz                                        ; $78DA

    ld c, $00                                     ; $78DB
    call Ball_LoadGfx8D80                         ; $78DD
    set_state STATE_20_PLAY_DEMO                  ; $78E0
    call Ball_FlipPalettes                        ; $78E5
    call Ball_DrawHud                             ; $78E8
    call Ball_ResetGame                           ; $78EB
    call Ball_DrawScore                           ; $78EE
    ret                                           ; $78F1


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Mode20_State07_Pause::
    call Ball_DrawHud                             ; $78F2
    call Ball_DrawPlayer                          ; $78F5
    call Ball_DrawPauseText                       ; $78F8
    ldh a, [hKeysNew]                             ; $78FB
    bit PADB_A, a                                 ; $78FD
    jr nz, jr_005_7905                            ; $78FF

    bit PADB_START, a                             ; $7901
    jr z, jr_005_7921                             ; $7903

jr_005_7905:
    push af                                       ; $7905
    ld a, SFX1_KEY_START                          ; $7906
    call Snd_Sfx1                                 ; $7908
    pop af                                        ; $790B
    ld bc, $000a                                  ; $790C
    call Wait_Frames                              ; $790F
    ld a, [wPickMusic]                            ; $7912
    ld hl, Mode20_State03_GameStart_Tbl781B       ; $7915
    call Snd_PlayFromList                         ; $7918
    set_state STATE_20_PLAY                       ; $791B
    ret                                           ; $7920


jr_005_7921:
    bit 1, a                                      ; $7921
    ret z                                         ; $7923

    push af                                       ; $7924
    ld a, SFX1_KEY_B                              ; $7925
    call Snd_Sfx1                                 ; $7927
    pop af                                        ; $792A
    set_state STATE_20_LEAVE                      ; $792B
    ret                                           ; $7930


; C: L3 pass 2026-10-26: executed in BGB in 1 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawPauseText::
    ld bc, $5048                                  ; $7931
    ld a, $b7                                     ; $7934
    call Oam_AddMeta_B01_5D47                     ; $7936
    ret                                           ; $7939


; C
Mode20_State08_Leave::
    call Ball_DrawHud                             ; $793A
    call Pal_FadeOut                              ; $793D
    call Lcd_Off                                  ; $7940
    ld hl, hStatShadow                            ; $7943
    res 6, [hl]                                   ; $7946
    ld hl, rIE                                    ; $7948
    res 1, [hl]                                   ; $794B
    ld a, [wMode20Caller]                         ; $794D
    cp MODE_SHUTTERBUG_MAGIC                      ; $7950
    jr nz, jr_005_795d                            ; $7952

    ld [wMode], a                                 ; $7954
    set_state STATE_20_MENU                       ; $7957
    ret                                           ; $795C


jr_005_795d:
    set_state STATE_20_MENU_INIT                  ; $795D
    ret                                           ; $7962


; C
Mode20_State09_ResultInit::
    ld a, LCDCF_WIN9C00 | LCDCF_BLK01 | LCDCF_OBJON | LCDCF_BGON ; $7963
    ldh [hLcdcShadow], a                          ; $7965
    ld a, $e4                                     ; $7967
    ld [wPaletteTarget], a                        ; $7969
    ld [wPaletteTarget + $1], a                   ; $796C
    ld a, $d2                                     ; $796F
    ld [wPaletteTarget + $2], a                   ; $7971
    xor a                                         ; $7974
    ldh [hScxShadow], a                           ; $7975
    ldh [hScyShadow], a                           ; $7977
    farcopy Mem_CopyFromBank, Gfx_1B_5100_Mode20_State09_ResultInit, $8000, $1000 ; $7979
    ld a, $23                                     ; $7987
    ld hl, Map_23_4CC0_Mode20_State09_ResultInit  ; $7989
    ld de, $9800                                  ; $798C
    ld bc, $0400                                  ; $798F
    call Mem_CopyFromBank                         ; $7992
    call Oam_ClearShadow                          ; $7995
    call Pal_AllWhite                             ; $7998
    call Lcd_On                                   ; $799B
    call Pal_FadeIn                               ; $799E
    next_state                                    ; $79A1
    ret                                           ; $79A5


; C
Mode20_State0A_ResultKeys::
    ldh a, [hKeysNew]                             ; $79A6
    and PADF_A | PADF_B                           ; $79A8
    ret z                                         ; $79AA

    ld [wAbResult], a                             ; $79AB
    bit 0, a                                      ; $79AE
    jr z, jr_005_79be                             ; $79B0

    push af                                       ; $79B2
    ld a, SFX1_KEY_A                              ; $79B3
    call Snd_Sfx1                                 ; $79B5
    pop af                                        ; $79B8
    next_state                                    ; $79B9
    ret                                           ; $79BD


jr_005_79be:
    push af                                       ; $79BE
    ld a, SFX1_KEY_B                              ; $79BF
    call Snd_Sfx1                                 ; $79C1
    pop af                                        ; $79C4
    next_state                                    ; $79C5
    ret                                           ; $79C9


; C
Mode20_State0B_ResultLeave::
    call Pal_FadeOut                              ; $79CA
    call Lcd_Off                                  ; $79CD
    ld a, [wAbResult]                             ; $79D0
    bit 0, a                                      ; $79D3
    jr z, jr_005_79dd                             ; $79D5

    set_state STATE_20_GAME_SETUP                 ; $79D7
    ret                                           ; $79DC


jr_005_79dd:
    ld a, [wMode20Caller]                         ; $79DD
    cp MODE_SHUTTERBUG_MAGIC                      ; $79E0
    jr nz, jr_005_79ee                            ; $79E2

    ld [wMode], a                                 ; $79E4
    set_state STATE_20_MENU                       ; $79E7
    jr jr_005_79f3                                ; $79EC

jr_005_79ee:
    set_state STATE_20_MENU_INIT                  ; $79EE

jr_005_79f3:
    ret                                           ; $79F3


; C: score; positions; directions; speed
Ball_ResetGame::
    ld a, $ff                                     ; $79F4
    ld [wBallDir + $1], a                         ; $79F6
    inc a                                         ; $79F9
    ld [wBallPose], a                             ; $79FA
    ld [wBallPos], a                              ; $79FD
    ld [wBallPos + $2], a                         ; $7A00
    ld [wBallSpeedAcc], a                         ; $7A03
    ld [wBallSpeedAcc + $1], a                    ; $7A06
    ld [wBallNextIndex], a                        ; $7A09
    ld [wBallScoreBcd], a                         ; $7A0C
    ld [wBallScoreBcd + $1], a                    ; $7A0F
    ld [wBallBlinkCounter], a                     ; $7A12
    inc a                                         ; $7A15
    ld [wBallDir], a                              ; $7A16
    ld [wBallDir + $2], a                         ; $7A19
    ld [wBallBlinkPhase], a                       ; $7A1C
    ld [wBallPlayerPos], a                        ; $7A1F
    ld a, $09                                     ; $7A22
    ld [wBallPos + $1], a                         ; $7A24
    ret                                           ; $7A27


; C
Ball_PlayerInput::
    ld a, [wBallPlayerPos]                        ; $7A28
    ld hl, hKeysNew                               ; $7A2B
    bit 5, [hl]                                   ; $7A2E
    jr nz, jr_005_7a36                            ; $7A30

    bit 1, [hl]                                   ; $7A32
    jr z, jr_005_7a42                             ; $7A34

jr_005_7a36:
    and a                                         ; $7A36
    ret z                                         ; $7A37

    push af                                       ; $7A38
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7A39
    call Snd_Sfx1                                 ; $7A3B
    pop af                                        ; $7A3E
    dec a                                         ; $7A3F
    jr jr_005_7a54                                ; $7A40

jr_005_7a42:
    bit 4, [hl]                                   ; $7A42
    jr nz, jr_005_7a49                            ; $7A44

    bit 0, [hl]                                   ; $7A46
    ret z                                         ; $7A48

jr_005_7a49:
    cp $02                                        ; $7A49
    ret z                                         ; $7A4B

    push af                                       ; $7A4C
    ld a, SFX1_KEY_LEFT_RIGHT                     ; $7A4D
    call Snd_Sfx1                                 ; $7A4F
    pop af                                        ; $7A52
    inc a                                         ; $7A53

jr_005_7a54:
    ld [wBallPlayerPos], a                        ; $7A54
    ret                                           ; $7A57


; C
Ball_DrawPlayer::
    ld a, [wBallPlayerPos]                        ; $7A58
    sla a                                         ; $7A5B
    sla a                                         ; $7A5D
    ld c, a                                       ; $7A5F
    ld b, $00                                     ; $7A60
    ld hl, Ball_DrawPlayer_Tbl7A79                ; $7A62
    add hl, bc                                    ; $7A65
    ld b, [hl]                                    ; $7A66
    inc hl                                        ; $7A67
    ld c, $70                                     ; $7A68
    ld a, [hl+]                                   ; $7A6A
    push hl                                       ; $7A6B
    call Oam_AddMeta_B01_5D47                     ; $7A6C
    pop hl                                        ; $7A6F
    ld b, [hl]                                    ; $7A70
    inc hl                                        ; $7A71
    ld c, $70                                     ; $7A72
    ld a, [hl]                                    ; $7A74
    call Oam_AddMeta_B01_5D47                     ; $7A75
    ret                                           ; $7A78


; C: auto: 12 bytes, bytes; referenced by Ball_DrawPlayer. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawPlayer_Tbl7A79::
    db $20, $b5, $70, $b4, $28, $b1, $78, $b2, $30, $b3, $80, $b6

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_ScrollBg::
    ld a, [wBallPlayerPos]                        ; $7A85
    sla a                                         ; $7A88
    ld c, a                                       ; $7A8A
    ld b, $00                                     ; $7A8B
    ld hl, Ball_ScrollBg_Tbl7A98                  ; $7A8D
    add hl, bc                                    ; $7A90
    ld a, [hl+]                                   ; $7A91
    ldh [hScyBand2], a                            ; $7A92
    ld a, [hl]                                    ; $7A94
    ldh [hScxBand2], a                            ; $7A95
    ret                                           ; $7A97


; C: auto: 6 bytes, bytes; referenced by Ball_ScrollBg. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the organic
; corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_ScrollBg_Tbl7A98::
    db $e8, $08, $98, $00, $c0, $f8

; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll::
    ld a, [wBallPlayerPos]                        ; $7A9E
    ld c, a                                       ; $7AA1
    ld b, $00                                     ; $7AA2
    ld hl, Ball_PoseScroll_Tbl7AB9                ; $7AA4
    add hl, bc                                    ; $7AA7
    ld a, [hl]                                    ; $7AA8
    ldh [hScxBand1], a                            ; $7AA9
    ld a, [wBallPose]                             ; $7AAB
    ld c, a                                       ; $7AAE
    ld b, $00                                     ; $7AAF
    ld hl, Ball_PoseScroll_Tbl7ABC                ; $7AB1
    add hl, bc                                    ; $7AB4
    ld a, [hl]                                    ; $7AB5
    ldh [hScyBand1], a                            ; $7AB6
    ret                                           ; $7AB8


; C: auto: 3 bytes, bytes; referenced by Ball_PoseScroll. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll_Tbl7AB9::
    db $08, $00, $f8

; C: auto: 3 bytes, bytes; referenced by Ball_PoseScroll. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PoseScroll_Tbl7ABC::
    db $00, $48, $90

; C: speed table 05:7B6D; objects 0..2; bounce / miss; end of game
Ball_StepObjects::
    xor a                                         ; $7ABF
    ld [wBallStepFlag], a                         ; $7AC0
    ld c, $28                                     ; $7AC3
    ld a, [wBallScoreBcd + $1]                    ; $7AC5
    cp $04                                        ; $7AC8
    jr nc, jr_005_7ad5                            ; $7ACA

    sla a                                         ; $7ACC
    ld c, a                                       ; $7ACE
    sla a                                         ; $7ACF
    sla a                                         ; $7AD1
    add c                                         ; $7AD3
    ld c, a                                       ; $7AD4

jr_005_7ad5:
    ld a, [wBallScoreBcd]                         ; $7AD5
    and $f0                                       ; $7AD8
    swap a                                        ; $7ADA
    add c                                         ; $7ADC
    ld c, a                                       ; $7ADD
    and a                                         ; $7ADE
    jr nz, jr_005_7aed                            ; $7ADF

    ld a, [wBallScoreBcd]                         ; $7AE1
    cp $05                                        ; $7AE4
    jr nc, jr_005_7aed                            ; $7AE6

    ld hl, Ball_StepObjects_Tbl7B6D               ; $7AE8
    jr jr_005_7af7                                ; $7AEB

jr_005_7aed:
    ld b, $00                                     ; $7AED
    sla c                                         ; $7AEF
    rl b                                          ; $7AF1
    ld hl, Ball_StepObjects_Tbl7B6F               ; $7AF3
    add hl, bc                                    ; $7AF6

jr_005_7af7:
    ld a, [wBallSpeedAcc]                         ; $7AF7
    add [hl]                                      ; $7AFA
    ld [wBallSpeedAcc], a                         ; $7AFB
    inc hl                                        ; $7AFE
    ld a, [wBallSpeedAcc + $1]                    ; $7AFF
    adc [hl]                                      ; $7B02
    ld [wBallSpeedAcc + $1], a                    ; $7B03
    ret nc                                        ; $7B06

    ld a, $01                                     ; $7B07
    ld [wBallStepFlag], a                         ; $7B09
    ld a, [wBallNextIndex]                        ; $7B0C
    add $20                                       ; $7B0F
    call Snd_Sfx1                                 ; $7B11
    ld a, [wBallNextIndex]                        ; $7B14
    ld c, a                                       ; $7B17
    ld b, $00                                     ; $7B18
    ld hl, wBallPos                               ; $7B1A
    add hl, bc                                    ; $7B1D
    ld a, [hl]                                    ; $7B1E
    bit 7, a                                      ; $7B1F
    ret nz                                        ; $7B21

    ld hl, Ball_StepObjects_Tbl7BD3               ; $7B22
    add hl, bc                                    ; $7B25
    cp [hl]                                       ; $7B26
    ret z                                         ; $7B27

    ld hl, wBallDir                               ; $7B28
    add hl, bc                                    ; $7B2B
    add [hl]                                      ; $7B2C
    ld hl, wBallPos                               ; $7B2D
    add hl, bc                                    ; $7B30
    ld [hl], a                                    ; $7B31
    bit 7, a                                      ; $7B32
    jr nz, jr_005_7b4a                            ; $7B34

    ld hl, Ball_StepObjects_Tbl7BD3               ; $7B36
    add hl, bc                                    ; $7B39
    cp [hl]                                       ; $7B3A
    jr z, jr_005_7b4a                             ; $7B3B

    ld a, [wBallNextIndex]                        ; $7B3D
    inc a                                         ; $7B40
    cp $03                                        ; $7B41
    jr nz, jr_005_7b46                            ; $7B43

    xor a                                         ; $7B45

jr_005_7b46:
    ld [wBallNextIndex], a                        ; $7B46
    ret                                           ; $7B49


jr_005_7b4a:
    set_state STATE_20_GAME_OVER                  ; $7B4A
    call Ball_StoreBest                           ; $7B4F
    ld a, $06                                     ; $7B52
    ld [wBallGameoverBlink], a                    ; $7B54
    ld a, $08                                     ; $7B57
    ld [wBallGameoverDelay], a                    ; $7B59
    ld a, $78                                     ; $7B5C
    ld [wBallGameoverTimeout], a                  ; $7B5E
    xor a                                         ; $7B61
    ld [wBallPose], a                             ; $7B62
    xor a                                         ; $7B65
    ld [wBallStepFlag], a                         ; $7B66
    ld [wBallAnimTick], a                         ; $7B69
    ret                                           ; $7B6C


; C: auto: 2 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_StepObjects_Tbl7B6D::
    dw $0c30

; C: auto: 100 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: not reached by the 206 BGB replays;
; read in the organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 1F 20)
Ball_StepObjects_Tbl7B6F::
    db $38, $0e, $65, $13, $51, $14, $55, $15, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $51, $14, $55, $15, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $75, $16, $b4, $17, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $19, $19, $ab, $1a
    db $72, $1c, $7a, $1e, $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $68, $2f, $55, $35
    db $d2, $20, $8e, $23, $ca, $26, $ab, $2a, $68, $2f, $55, $35, $55, $35, $55, $35
    db $55, $35, $55, $35

; C: auto: 3 bytes, bytes; referenced by Ball_StepObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_StepObjects_Tbl7BD3::
    db $08, $0a, $0c

; C
Ball_DrawObjects::
    ld a, [wBallPos]                              ; $7BD6
    ld hl, Ball_DrawObjects_Tbl7C23               ; $7BD9
    call Ball_DrawObject                          ; $7BDC
    ld a, [wBallPos + $1]                         ; $7BDF
    ld hl, Ball_DrawObjects_Tbl7C37               ; $7BE2
    call Ball_DrawObject                          ; $7BE5
    ld a, [wBallPos + $2]                         ; $7BE8
    ld hl, Ball_DrawObjects_Tbl7C4F               ; $7BEB
    call Ball_DrawObject                          ; $7BEE
    ret                                           ; $7BF1


; C
Ball_DrawObject::
    inc a                                         ; $7BF2
    sla a                                         ; $7BF3
    ld c, a                                       ; $7BF5
    ld b, $00                                     ; $7BF6
    add hl, bc                                    ; $7BF8
    ld c, [hl]                                    ; $7BF9
    inc hl                                        ; $7BFA
    ld b, [hl]                                    ; $7BFB
    ld a, $b0                                     ; $7BFC
    bit 7, c                                      ; $7BFE
    jr nz, jr_005_7c06                            ; $7C00

    call Oam_AddMeta_B01_5D47                     ; $7C02
    ret                                           ; $7C05


jr_005_7c06:
    ld a, [wBallBlinkPhase]                       ; $7C06
    ld a, $bc                                     ; $7C09
    call Oam_AddMeta_B01_5D47                     ; $7C0B
    ld a, [wBallBlinkCounter]                     ; $7C0E
    cp $12                                        ; $7C11
    jr nz, jr_005_7c1e                            ; $7C13

    ld a, [wBallBlinkPhase]                       ; $7C15
    xor $01                                       ; $7C18
    ld [wBallBlinkPhase], a                       ; $7C1A
    xor a                                         ; $7C1D

jr_005_7c1e:
    inc a                                         ; $7C1E
    ld [wBallBlinkCounter], a                     ; $7C1F
    ret                                           ; $7C22


; C: auto: 20 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C23::
    db $88, $17, $63, $28, $4a, $2b, $32, $33, $20, $44, $20, $5c, $32, $6d, $4a, $75
    db $63, $78, $88, $7e

; C: auto: 24 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C37::
    db $88, $17, $63, $18, $4a, $1b, $32, $22, $1d, $2f, $12, $44, $12, $5c, $1d, $71
    db $32, $7e, $4a, $85, $63, $88, $88, $7e

; C: auto: 28 bytes, bytes; referenced by Ball_DrawObjects. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawObjects_Tbl7C4F::
    db $88, $17, $63, $08, $48, $0b, $30, $12, $1a, $1d, $09, $2d, $05, $44, $05, $5c
    db $09, $73, $1a, $83, $30, $8e, $48, $95, $63, $98, $88, $7e

; C
Ball_Collide::
    xor a                                         ; $7C6B
    ld [wBallBounceFlag], a                       ; $7C6C
    ld a, [wBallPlayerPos]                        ; $7C6F
    and a                                         ; $7C72
    jr nz, jr_005_7ca3                            ; $7C73

    ld a, [wBallPos]                              ; $7C75
    cp $07                                        ; $7C78
    jr nz, jr_005_7c8d                            ; $7C7A

    ld hl, wBallDir                               ; $7C7C
    ld a, $ff                                     ; $7C7F
    cp [hl]                                       ; $7C81
    jr z, jr_005_7c8d                             ; $7C82

    ld [hl], a                                    ; $7C84
    call Ball_AddPoint                            ; $7C85
    ld a, $01                                     ; $7C88
    ld [wBallBounceFlag], a                       ; $7C8A

jr_005_7c8d:
    ld a, [wBallPos + $2]                         ; $7C8D
    and a                                         ; $7C90
    ret nz                                        ; $7C91

    ld hl, wBallDir + $2                          ; $7C92
    ld a, $01                                     ; $7C95
    cp [hl]                                       ; $7C97
    ret z                                         ; $7C98

    ld [hl], a                                    ; $7C99
    call Ball_AddPoint                            ; $7C9A
    ld a, $01                                     ; $7C9D
    ld [wBallBounceFlag], a                       ; $7C9F
    ret                                           ; $7CA2


jr_005_7ca3:
    dec a                                         ; $7CA3
    jr nz, jr_005_7cd4                            ; $7CA4

    ld a, [wBallPos + $1]                         ; $7CA6
    cp $09                                        ; $7CA9
    jr nz, jr_005_7cbe                            ; $7CAB

    ld hl, wBallDir + $1                          ; $7CAD
    ld a, $ff                                     ; $7CB0
    cp [hl]                                       ; $7CB2
    jr z, jr_005_7cbe                             ; $7CB3

    ld [hl], a                                    ; $7CB5
    call Ball_AddPoint                            ; $7CB6
    ld a, $01                                     ; $7CB9
    ld [wBallBounceFlag], a                       ; $7CBB

jr_005_7cbe:
    ld a, [wBallPos + $1]                         ; $7CBE
    and a                                         ; $7CC1
    ret nz                                        ; $7CC2

    ld hl, wBallDir + $1                          ; $7CC3
    ld a, $01                                     ; $7CC6
    cp [hl]                                       ; $7CC8
    ret z                                         ; $7CC9

    ld [hl], a                                    ; $7CCA
    call Ball_AddPoint                            ; $7CCB
    ld a, $01                                     ; $7CCE
    ld [wBallBounceFlag], a                       ; $7CD0
    ret                                           ; $7CD3


jr_005_7cd4:
    dec a                                         ; $7CD4
    ret nz                                        ; $7CD5

    ld a, [wBallPos + $2]                         ; $7CD6
    cp $0b                                        ; $7CD9
    jr nz, jr_005_7cee                            ; $7CDB

    ld hl, wBallDir + $2                          ; $7CDD
    ld a, $ff                                     ; $7CE0
    cp [hl]                                       ; $7CE2
    jr z, jr_005_7cee                             ; $7CE3

    ld [hl], a                                    ; $7CE5
    call Ball_AddPoint                            ; $7CE6
    ld a, $01                                     ; $7CE9
    ld [wBallBounceFlag], a                       ; $7CEB

jr_005_7cee:
    ld a, [wBallPos]                              ; $7CEE
    and a                                         ; $7CF1
    ret nz                                        ; $7CF2

    ld hl, wBallDir                               ; $7CF3
    ld a, $01                                     ; $7CF6
    cp [hl]                                       ; $7CF8
    ret z                                         ; $7CF9

    ld [hl], a                                    ; $7CFA
    call Ball_AddPoint                            ; $7CFB
    ld a, $01                                     ; $7CFE
    ld [wBallBounceFlag], a                       ; $7D00
    ret                                           ; $7D03


; C
Ball_Animate::
    ld a, [wBallAnimTick]                         ; $7D04
    ld hl, wBallStepFlag                          ; $7D07
    add [hl]                                      ; $7D0A
    ld [wBallAnimTick], a                         ; $7D0B
    ld a, [wBallIdleFrames]                       ; $7D0E
    cp $ff                                        ; $7D11
    jr z, jr_005_7d19                             ; $7D13

    inc a                                         ; $7D15
    ld [wBallIdleFrames], a                       ; $7D16

jr_005_7d19:
    cp $46                                        ; $7D19
    jr c, jr_005_7d27                             ; $7D1B

    ld a, [wBallAnimTick]                         ; $7D1D
    srl a                                         ; $7D20
    and $01                                       ; $7D22
    ld [wBallPose], a                             ; $7D24

jr_005_7d27:
    ldh a, [hKeysNew]                             ; $7D27
    and a                                         ; $7D29
    ret z                                         ; $7D2A

    ld a, [wBallIdleFrames]                       ; $7D2B
    push af                                       ; $7D2E
    xor a                                         ; $7D2F
    ld [wBallIdleFrames], a                       ; $7D30
    pop af                                        ; $7D33
    cp $0a                                        ; $7D34
    jr nc, jr_005_7d3e                            ; $7D36

    ld a, $02                                     ; $7D38
    ld [wBallPose], a                             ; $7D3A
    ret                                           ; $7D3D


jr_005_7d3e:
    cp $3c                                        ; $7D3E
    ret nc                                        ; $7D40

    ld a, [wBallAnimTick]                         ; $7D41
    srl a                                         ; $7D44
    and $01                                       ; $7D46
    inc a                                         ; $7D48
    ld [wBallPose], a                             ; $7D49
    ret                                           ; $7D4C


; C: sound $23 and +1 on the BCD score (saturating at 9999)
Ball_AddPoint::
    push af                                       ; $7D4D
    ld a, SFX1_BALL_POINT                         ; $7D4E
    call Snd_Sfx1                                 ; $7D50
    pop af                                        ; $7D53
    ld a, $01                                     ; $7D54
    ld hl, wBallScoreBcd                          ; $7D56
    ld b, $02                                     ; $7D59
    call Bcd_AddSaturate                          ; $7D5B

; C
Ball_DrawScore::
    ld de, wBallScoreBcd + $1                     ; $7D5E
    ld hl, $9830                                  ; $7D61
    ld bc, $020a                                  ; $7D64
    jr jr_005_7d87                                ; $7D67

jr_005_7d69:
    ld a, [de]                                    ; $7D69
    swap a                                        ; $7D6A
    and $0f                                       ; $7D6C
    jr nz, jr_005_7d73                            ; $7D6E

    ld a, c                                       ; $7D70
    jr jr_005_7d75                                ; $7D71

jr_005_7d73:
    ld c, $00                                     ; $7D73

jr_005_7d75:
    add $80                                       ; $7D75
    call Vram_WriteByteSafe                       ; $7D77
    res 5, l                                      ; $7D7A
    set 6, l                                      ; $7D7C
    add $10                                       ; $7D7E
    call Vram_WriteByteSafe                       ; $7D80
    set 5, l                                      ; $7D83
    res 6, l                                      ; $7D85

jr_005_7d87:
    inc hl                                        ; $7D87
    ld a, b                                       ; $7D88
    cp $01                                        ; $7D89
    jr nz, jr_005_7d8f                            ; $7D8B

    ld c, $00                                     ; $7D8D

jr_005_7d8f:
    ld a, [de]                                    ; $7D8F
    and $0f                                       ; $7D90
    jr nz, jr_005_7d97                            ; $7D92

    ld a, c                                       ; $7D94
    jr jr_005_7d99                                ; $7D95

jr_005_7d97:
    ld c, $00                                     ; $7D97

jr_005_7d99:
    add $80                                       ; $7D99
    call Vram_WriteByteSafe                       ; $7D9B
    res 5, l                                      ; $7D9E
    set 6, l                                      ; $7DA0
    add $10                                       ; $7DA2
    call Vram_WriteByteSafe                       ; $7DA4
    set 5, l                                      ; $7DA7
    res 6, l                                      ; $7DA9
    inc hl                                        ; $7DAB
    dec de                                        ; $7DAC
    dec b                                         ; $7DAD
    jr nz, jr_005_7d69                            ; $7DAE

    ret                                           ; $7DB0


; C: L3 pass 2026-10-26: executed in BGB in 4 replay(s) of the organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_DrawHud::
    ld bc, $8808                                  ; $7DB1
    ld a, $b8                                     ; $7DB4
    call Oam_AddMeta_B01_5D47                     ; $7DB6
    ret                                           ; $7DB9


; C: game-over blink. L3 pass 2026-10-26: executed in BGB in 2 replay(s) of the organic corpus, modes 20
; (tcrf_check/assets/l3_names/)
Ball_FlipPalettes::
    push af                                       ; $7DBA
    ldh a, [hBgpShadow]                           ; $7DBB
    cpl                                           ; $7DBD
    ldh [hBgpShadow], a                           ; $7DBE
    ldh a, [hObp0Shadow]                          ; $7DC0
    cpl                                           ; $7DC2
    ldh [hObp0Shadow], a                          ; $7DC3
    ldh a, [hObp1Shadow]                          ; $7DC5
    cpl                                           ; $7DC7
    ldh [hObp1Shadow], a                          ; $7DC8
    pop af                                        ; $7DCA
    ret                                           ; $7DCB


; C: autopilot
Ball_DemoInput::
    xor a                                         ; $7DCC
    ldh [hKeysNew], a                             ; $7DCD
    ld a, [wDemoInputHoldoff]                     ; $7DCF
    and a                                         ; $7DD2
    jr z, jr_005_7dda                             ; $7DD3

    dec a                                         ; $7DD5
    ld [wDemoInputHoldoff], a                     ; $7DD6
    ret                                           ; $7DD9


jr_005_7dda:
    ldh a, [hFrameCounter]                        ; $7DDA
    and $01                                       ; $7DDC
    ret nz                                        ; $7DDE

    ld a, [wBallNextIndex]                        ; $7DDF
    and a                                         ; $7DE2
    jr z, jr_005_7dea                             ; $7DE3

    dec a                                         ; $7DE5
    jr z, jr_005_7e18                             ; $7DE6

    jr jr_005_7e56                                ; $7DE8

jr_005_7dea:
    ld a, [wBallPos]                              ; $7DEA
    cp $01                                        ; $7DED
    jr nz, jr_005_7e04                            ; $7DEF

    ld a, [wBallDir]                              ; $7DF1
    cp $ff                                        ; $7DF4
    ret nz                                        ; $7DF6

    ld a, [wBallPlayerPos]                        ; $7DF7
    cp $02                                        ; $7DFA
    jp z, Ball_DemoInput_SetHoldoff               ; $7DFC

    ld a, PADF_RIGHT                              ; $7DFF
    ldh [hKeysNew], a                             ; $7E01
    ret                                           ; $7E03


jr_005_7e04:
    cp $06                                        ; $7E04
    ret nz                                        ; $7E06

    ld a, [wBallDir]                              ; $7E07
    cp $01                                        ; $7E0A
    ret nz                                        ; $7E0C

    ld a, [wBallPlayerPos]                        ; $7E0D
    and a                                         ; $7E10
    jr z, Ball_DemoInput_SetHoldoff               ; $7E11

    ld a, PADF_LEFT                               ; $7E13
    ldh [hKeysNew], a                             ; $7E15
    ret                                           ; $7E17


jr_005_7e18:
    ld a, [wBallPos + $1]                         ; $7E18
    cp $01                                        ; $7E1B
    jr nz, jr_005_7e39                            ; $7E1D

    ld a, [wBallDir + $1]                         ; $7E1F
    cp $ff                                        ; $7E22
    ret nz                                        ; $7E24

    ld a, [wBallPlayerPos]                        ; $7E25
    and a                                         ; $7E28
    jr nz, jr_005_7e30                            ; $7E29

    ld a, PADF_RIGHT                              ; $7E2B
    ldh [hKeysNew], a                             ; $7E2D
    ret                                           ; $7E2F


jr_005_7e30:
    cp $02                                        ; $7E30
    jr nz, Ball_DemoInput_SetHoldoff              ; $7E32

    ld a, PADF_LEFT                               ; $7E34
    ldh [hKeysNew], a                             ; $7E36
    ret                                           ; $7E38


jr_005_7e39:
    cp $08                                        ; $7E39
    ret nz                                        ; $7E3B

    ld a, [wBallDir + $1]                         ; $7E3C
    cp $01                                        ; $7E3F
    ret nz                                        ; $7E41

    ld a, [wBallPlayerPos]                        ; $7E42
    and a                                         ; $7E45
    jr nz, jr_005_7e4d                            ; $7E46

    ld a, PADF_RIGHT                              ; $7E48
    ldh [hKeysNew], a                             ; $7E4A
    ret                                           ; $7E4C


jr_005_7e4d:
    cp $02                                        ; $7E4D
    jr nz, Ball_DemoInput_SetHoldoff              ; $7E4F

    ld a, PADF_LEFT                               ; $7E51
    ldh [hKeysNew], a                             ; $7E53
    ret                                           ; $7E55


jr_005_7e56:
    ld a, [wBallPos + $2]                         ; $7E56
    cp $01                                        ; $7E59
    jr nz, jr_005_7e6e                            ; $7E5B

    ld a, [wBallDir + $2]                         ; $7E5D
    cp $ff                                        ; $7E60
    ret nz                                        ; $7E62

    ld a, [wBallPlayerPos]                        ; $7E63
    and a                                         ; $7E66
    jr z, Ball_DemoInput_SetHoldoff               ; $7E67

    ld a, PADF_LEFT                               ; $7E69
    ldh [hKeysNew], a                             ; $7E6B
    ret                                           ; $7E6D


jr_005_7e6e:
    cp $0a                                        ; $7E6E
    ret nz                                        ; $7E70

    ld a, [wBallDir + $2]                         ; $7E71
    cp $01                                        ; $7E74
    ret nz                                        ; $7E76

    ld a, [wBallPlayerPos]                        ; $7E77
    cp $02                                        ; $7E7A
    jr z, Ball_DemoInput_SetHoldoff               ; $7E7C

    ld a, PADF_RIGHT                              ; $7E7E
    ldh [hKeysNew], a                             ; $7E80
    ret                                           ; $7E82


; C: sets wDemoInputHoldoff ($D9EA) = 1 and returns: the autopilot waits one more frame; shared by the cases where
; $D9D7 (ball player position) fits no move (branch target; code read 2026-10-19)
Ball_DemoInput_SetHoldoff::
    ld a, $01                                     ; $7E83
    ld [wDemoInputHoldoff], a                     ; $7E85
    ret                                           ; $7E88


; C: best score compare and far store
Ball_StoreBest::
    ld de, wBallScoreBcd + $1                     ; $7E89
    ld hl, wBestBall + $1                         ; $7E8C
    ld b, $02                                     ; $7E8F

jr_005_7e91:
    ld a, [de]                                    ; $7E91
    cp [hl]                                       ; $7E92
    ret c                                         ; $7E93

    jr nz, jr_005_7e9c                            ; $7E94

    dec de                                        ; $7E96
    dec hl                                        ; $7E97
    dec b                                         ; $7E98
    jr nz, jr_005_7e91                            ; $7E99

    ret                                           ; $7E9B


jr_005_7e9c:
    ld de, wBallScoreBcd                          ; $7E9C
    ld hl, wBestBall                              ; $7E9F
    ld b, $02                                     ; $7EA2

jr_005_7ea4:
    ld a, [de]                                    ; $7EA4
    ld [hl+], a                                   ; $7EA5
    inc de                                        ; $7EA6
    dec b                                         ; $7EA7
    jr nz, jr_005_7ea4                            ; $7EA8

    ldh [hFarcallAArg], a                         ; $7EAA
    ld a, $02                                     ; $7EAC
    ld hl, Counters_Store_Far                     ; $7EAE
    call Far_Call                                 ; $7EB1
    ret                                           ; $7EB4


; C
Ball_LoadCharacterGfx::
    ld a, [wPickGfxToggle]                        ; $7EB5
    inc a                                         ; $7EB8
    and $01                                       ; $7EB9
    ld [wPickGfxToggle], a                        ; $7EBB
    call Ball_PickGfxBank                         ; $7EBE
    push af                                       ; $7EC1
    ld c, $00                                     ; $7EC2
    ldh [hFarcallAArg], a                         ; $7EC4
    ld a, $05                                     ; $7EC6
    ld hl, Photo_FarGetAddress                    ; $7EC8
    call Far_Call                                 ; $7ECB
    ld de, $8d80                                  ; $7ECE
    ld bc, $0380                                  ; $7ED1
    call Mem_CopyFromBank                         ; $7ED4
    pop af                                        ; $7ED7
    push af                                       ; $7ED8
    ld c, $01                                     ; $7ED9
    ldh [hFarcallAArg], a                         ; $7EDB
    ld a, $05                                     ; $7EDD
    ld hl, Photo_FarGetAddress                    ; $7EDF
    call Far_Call                                 ; $7EE2
    ld de, $9100                                  ; $7EE5
    ld bc, $0380                                  ; $7EE8
    call Mem_CopyFromBank                         ; $7EEB
    pop af                                        ; $7EEE
    ld c, $02                                     ; $7EEF
    ldh [hFarcallAArg], a                         ; $7EF1
    ld a, $05                                     ; $7EF3
    ld hl, Photo_FarGetAddress                    ; $7EF5
    call Far_Call                                 ; $7EF8
    ld de, $9480                                  ; $7EFB
    ld bc, $0380                                  ; $7EFE
    call Mem_CopyFromBank                         ; $7F01
    ret                                           ; $7F04


; C
Ball_LoadGfx8D80::
    call Ball_PickGfxBank                         ; $7F05
    ldh [hFarcallAArg], a                         ; $7F08
    ld a, $05                                     ; $7F0A
    ld hl, Photo_FarGetAddress                    ; $7F0C
    call Far_Call                                 ; $7F0F
    ld de, $8d80                                  ; $7F12
    ld bc, $0380                                  ; $7F15
    call Vram_CopyFromBank_4                      ; $7F18
    ret                                           ; $7F1B


; I: UNREFERENCED
Unused_Ball_LoadGfx9100::
    call Ball_PickGfxBank                         ; $7F1C
    ldh [hFarcallAArg], a                         ; $7F1F
    ld a, $05                                     ; $7F21
    ld hl, Photo_FarGetAddress                    ; $7F23
    call Far_Call                                 ; $7F26
    ld de, $9100                                  ; $7F29
    ld bc, $0380                                  ; $7F2C
    call Vram_CopyFromBank_4                      ; $7F2F
    ret                                           ; $7F32


; I: UNREFERENCED
Unused_Ball_LoadGfx9480::
    call Ball_PickGfxBank                         ; $7F33
    ldh [hFarcallAArg], a                         ; $7F36
    ld a, $05                                     ; $7F38
    ld hl, Photo_FarGetAddress                    ; $7F3A
    call Far_Call                                 ; $7F3D
    ld de, $9480                                  ; $7F40
    ld bc, $0380                                  ; $7F43
    call Vram_CopyFromBank_4                      ; $7F46
    ret                                           ; $7F49


; C
Ball_PickGfxBank::
    push bc                                       ; $7F4A
    ld a, [wPickCharacter]                        ; $7F4B
    cp $02                                        ; $7F4E
    jr nz, jr_005_7f5c                            ; $7F50

    ld hl, wGamefacePresent                       ; $7F52
    bit 0, [hl]                                   ; $7F55
    jr nz, jr_005_7f5c                            ; $7F57

    ld a, [wPickGfxToggle]                        ; $7F59

jr_005_7f5c:
    ld c, a                                       ; $7F5C
    ld b, $00                                     ; $7F5D
    ld hl, Ball_PickGfxBank_Tbl7F66               ; $7F5F
    add hl, bc                                    ; $7F62
    ld a, [hl]                                    ; $7F63
    pop bc                                        ; $7F64
    ret                                           ; $7F65


; C: auto: 3 bytes, bytes; referenced by Ball_PickGfxBank. L3 pass 2026-10-26: read in BGB in 4 replay(s) of the
; organic corpus, modes 20 (tcrf_check/assets/l3_names/)
Ball_PickGfxBank_Tbl7F66::
    db $00, $03, $06

; C: far helper: photo / graphics pointer (24 callers)
Photo_FarGetAddress::
    push bc                                       ; $7F69
    ld c, a                                       ; $7F6A
    ld b, $00                                     ; $7F6B
    ld hl, Photo_FarGetAddress_Tbl7F86            ; $7F6D
    add hl, bc                                    ; $7F70
    ld c, [hl]                                    ; $7F71
    add hl, bc                                    ; $7F72
    pop bc                                        ; $7F73
    ld a, c                                       ; $7F74
    sla a                                         ; $7F75
    add c                                         ; $7F77
    ld c, a                                       ; $7F78
    ld b, $00                                     ; $7F79
    add hl, bc                                    ; $7F7B
    ld c, [hl]                                    ; $7F7C
    inc hl                                        ; $7F7D
    ld b, [hl]                                    ; $7F7E
    inc hl                                        ; $7F7F
    ld a, [hl]                                    ; $7F80
    ld l, c                                       ; $7F81
    ld h, b                                       ; $7F82
    jp Far_Call_Return                            ; $7F83


; C: auto: 91 bytes, bytes; referenced by Photo_FarGetAddress. L3 pass 2026-10-26: read in BGB in 7 replay(s) of the
; organic corpus, modes 07 20 (tcrf_check/assets/l3_names/)
Photo_FarGetAddress_Tbl7F86::
    db $08, $13, $1e, $29, $34, $3f, $4a, $49, $00, $5f, $0f, $80, $62, $0f, $00, $66
    db $0f, $80, $69, $0f, $00, $6d, $0f, $80, $70, $0f, $00, $74, $0f, $80, $77, $0f
    db $00, $63, $0e, $80, $66, $0e, $00, $6a, $0e, $80, $6d, $0e, $00, $71, $0e, $80
    db $74, $0e, $00, $78, $0e, $80, $7b, $0e, $00, $40, $10, $80, $43, $10, $00, $47
    db $10, $80, $4a, $10, $00, $4e, $10, $80, $51, $10, $00, $55, $10, $80, $58, $10
    db $00, $c0, $00, $80, $c3, $00, $00, $c7, $00, $80, $ca

    ; padding
    ds $1f, $00

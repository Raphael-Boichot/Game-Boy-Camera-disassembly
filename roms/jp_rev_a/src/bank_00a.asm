; Pocket Camera (Japan) (Rev A), bank $0A. Written by tools/make_source.py from roms/jp_rev_a/pocketcamera_jp.sym and the tables of
; roms/jp_rev_a/disasm/ (mgbdis + tools/sym_fix.py). The comment of a label is its tag (C / I / ?) and note; `; $XXXX` is the ROM address.


SECTION "ROM Bank $00a", ROMX[$4000], BANK[$a]

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_MainDispatch::
    ld [wCamBrightnessSetpoint], a                ; $4000
    ld a, $00                                     ; $4003
    ld [$4000], a                                 ; $4005
    ld bc, $0000                                  ; $4008
    ld de, $a320                                  ; $400B
    call Cam_PopcountSampleLoop                   ; $400E
    ld a, [wCamBrightnessSetpoint]                ; $4011
    ld e, a                                       ; $4014
    xor a                                         ; $4015
    ldh [hScratchA], a                            ; $4016

jr_00a_4018:
    ld a, c                                       ; $4018
    sub e                                         ; $4019
    ld c, a                                       ; $401A
    jr nc, jr_00a_4023                            ; $401B

    dec b                                         ; $401D
    ld a, b                                       ; $401E
    cp $ff                                        ; $401F
    jr z, jr_00a_402d                             ; $4021

jr_00a_4023:
    ld a, c                                       ; $4023
    ldh a, [hScratchA]                            ; $4024
    inc a                                         ; $4026
    ldh [hScratchA], a                            ; $4027
    cp $9f                                        ; $4029
    jr nz, jr_00a_4018                            ; $402B

jr_00a_402d:
    ldh a, [hScratchA]                            ; $402D
    ld bc, Cam_ExposureShiftTable                 ; $402F
    add c                                         ; $4032
    ld c, a                                       ; $4033
    jr nc, jr_00a_4037                            ; $4034

    inc b                                         ; $4036

jr_00a_4037:
    ld a, [bc]                                    ; $4037
    ldh [hScratchB], a                            ; $4038
    ld a, [wCamExposureShadow]                    ; $403A
    ld h, a                                       ; $403D
    ld d, a                                       ; $403E
    ld a, [wCamExposureShadow + $1]               ; $403F
    ld l, a                                       ; $4042
    ld e, a                                       ; $4043
    ldh a, [hScratchA]                            ; $4044
    sub $24                                       ; $4046
    jr c, jr_00a_4061                             ; $4048

    ldh a, [hScratchB]                            ; $404A

jr_00a_404c:
    cp $00                                        ; $404C
    jr z, jr_00a_4057                             ; $404E

    srl d                                         ; $4050
    rr e                                          ; $4052
    dec a                                         ; $4054
    jr jr_00a_404c                                ; $4055

jr_00a_4057:
    add hl, de                                    ; $4057
    jr c, jr_00a_405c                             ; $4058

    jr jr_00a_4076                                ; $405A

jr_00a_405c:
    ld hl, $ffff                                  ; $405C
    jr jr_00a_4076                                ; $405F

jr_00a_4061:
    ldh a, [hScratchB]                            ; $4061

jr_00a_4063:
    cp $00                                        ; $4063
    jr z, jr_00a_406e                             ; $4065

    srl d                                         ; $4067
    rr e                                          ; $4069
    dec a                                         ; $406B
    jr jr_00a_4063                                ; $406C

jr_00a_406e:
    ld a, d                                       ; $406E
    cpl                                           ; $406F
    ld d, a                                       ; $4070
    ld a, e                                       ; $4071
    cpl                                           ; $4072
    ld e, a                                       ; $4073
    inc de                                        ; $4074
    add hl, de                                    ; $4075

jr_00a_4076:
    ld a, $10                                     ; $4076
    ld [$4000], a                                 ; $4078
    ld a, h                                       ; $407B
    ld [wCamExposureShadow], a                    ; $407C
    ld a, l                                       ; $407F
    ld [wCamExposureShadow + $1], a               ; $4080
    ld a, [wCamGainAlt]                           ; $4083
    ld b, a                                       ; $4086
    ld a, [wCamGainSel]                           ; $4087
    cp b                                          ; $408A
    jp z, Cam_MainDispatch_Band2                  ; $408B

    cp $08                                        ; $408E
    jp z, Cam_MainDispatch_Band3                  ; $4090

    cp $0a                                        ; $4093
    jp z, Cam_MainDispatch_Band4                  ; $4095

    ld b, h                                       ; $4098
    ld c, l                                       ; $4099
    ld a, [wCamA001Shadow]                        ; $409A
    bit 7, a                                      ; $409D
    jp nz, Cam_MainDispatch_Band1                 ; $409F

    ld de, $ffd0                                  ; $40A2
    add hl, de                                    ; $40A5
    jp c, Cam_MainDispatch_EnterBand1             ; $40A6

    ld h, b                                       ; $40A9
    ld l, c                                       ; $40AA
    ld de, $fff0                                  ; $40AB
    add hl, de                                    ; $40AE
    jp c, Cam_MainDispatch_WriteExposure          ; $40AF

    ld a, $10                                     ; $40B2
    ld [wCamExposureShadow + $1], a               ; $40B4
    jp Cam_MainDispatch_WriteExposure             ; $40B7


; C: band 0 -> band 1 ($D587 = $D588, reg 1 = $D588 | $E0, exposure e = $0048, reg 7 = $D5C2, dither matrix rebuilt);
; README §10, e >= $0030 in band 0 (branch target; code read 2026-10-19)
Cam_MainDispatch_EnterBand1::
    ld a, [wCamGainCommitted]                     ; $40BA
    ld [wCamGainSel], a                           ; $40BD
    or $e0                                        ; $40C0
    ld [wCamA001Shadow], a                        ; $40C2
    ld [$a001], a                                 ; $40C5
    xor a                                         ; $40C8
    ld [wCamExposureShadow], a                    ; $40C9
    ld [$a002], a                                 ; $40CC
    ld a, $48                                     ; $40CF
    ld [wCamExposureShadow + $1], a               ; $40D1
    ld [$a003], a                                 ; $40D4
    ld a, [wCamBootV + $1]                        ; $40D7
    ld [wCamA004Shadow], a                        ; $40DA
    ld [$a004], a                                 ; $40DD
    ld a, [wCamBootO + $1]                        ; $40E0
    set 7, a                                      ; $40E3
    ld [wCamA005Shadow], a                        ; $40E5
    ld [$a005], a                                 ; $40E8
    jp Cam_MainDispatch_WriteExposure             ; $40EB


; C: band 1 handler (reg 1 bit 7 set, $D587 = $D588): e < $0031 -> Cam_MainDispatch_EnterBand0, e >= $1200 -> band 2
; with e = $0D80, else keep (branch target; code read 2026-10-19)
Cam_MainDispatch_Band1::
    ld de, $ffcf                                  ; $40EE
    add hl, de                                    ; $40F1
    jp nc, Cam_MainDispatch_EnterBand0            ; $40F2

    ld h, b                                       ; $40F5
    ld l, c                                       ; $40F6
    ld de, $ee00                                  ; $40F7
    add hl, de                                    ; $40FA
    jp nc, Cam_MainDispatch_WriteExposure         ; $40FB

    ld a, [wCamGainAlt]                           ; $40FE
    ld [wCamGainSel], a                           ; $4101
    or $e0                                        ; $4104
    ld [wCamA001Shadow], a                        ; $4106
    ld [$a001], a                                 ; $4109
    ld a, $0d                                     ; $410C
    ld [wCamExposureShadow], a                    ; $410E
    ld a, $80                                     ; $4111
    ld [wCamExposureShadow + $1], a               ; $4113
    ld a, [wCamBootV + $2]                        ; $4116
    ld [wCamA004Shadow], a                        ; $4119
    ld [$a004], a                                 ; $411C
    ld a, [wCamBootO + $2]                        ; $411F
    set 7, a                                      ; $4122
    ld [wCamA005Shadow], a                        ; $4124
    ld [$a005], a                                 ; $4127
    ld a, [wCamGainSel]                           ; $412A
    ld b, a                                       ; $412D
    ld a, [wCamContrastRow]                       ; $412E
    ld c, a                                       ; $4131
    call Cam_BuildDitherMatrix                    ; $4132
    jp Cam_MainDispatch_WriteExposure             ; $4135


; C: band 1 -> band 0 (reg 1 = $D588 | $20, e = $001F, reg 7 = $D5C1) (branch target; code read 2026-10-19)
Cam_MainDispatch_EnterBand0::
    ld a, [wCamGainCommitted]                     ; $4138
    ld [wCamGainSel], a                           ; $413B
    or $20                                        ; $413E
    ld [wCamA001Shadow], a                        ; $4140
    ld [$a001], a                                 ; $4143
    xor a                                         ; $4146
    ld [wCamExposureShadow], a                    ; $4147
    ld [$a002], a                                 ; $414A
    ld a, $1f                                     ; $414D
    ld [wCamExposureShadow + $1], a               ; $414F
    ld [$a003], a                                 ; $4152
    ld a, [wCamBootV]                             ; $4155
    ld [wCamA004Shadow], a                        ; $4158
    ld [$a004], a                                 ; $415B
    ld a, [wCamBootO]                             ; $415E
    set 7, a                                      ; $4161
    ld [wCamA005Shadow], a                        ; $4163
    ld [$a005], a                                 ; $4166
    jp Cam_MainDispatch_WriteExposure             ; $4169


; C: band 2 handler ($D587 = $D589, reg 1 $E4 / $E5): e >= $6000 -> band 3 (e = $3500), e < $0800 -> band 1 (e =
; $0B00) (branch target; code read 2026-10-19)
Cam_MainDispatch_Band2::
    ld b, h                                       ; $416C
    ld c, l                                       ; $416D
    ld de, $f800                                  ; $416E
    add hl, de                                    ; $4171
    jr nc, jr_00a_41b9                            ; $4172

    ld h, b                                       ; $4174
    ld l, c                                       ; $4175
    ld de, $a000                                  ; $4176
    add hl, de                                    ; $4179
    jp nc, Cam_MainDispatch_WriteExposure         ; $417A

    ld a, $08                                     ; $417D
    ld [wCamGainSel], a                           ; $417F
    or $e0                                        ; $4182
    ld [wCamA001Shadow], a                        ; $4184
    ld [$a001], a                                 ; $4187
    ld a, $35                                     ; $418A
    ld [wCamExposureShadow], a                    ; $418C
    ld [$a002], a                                 ; $418F
    xor a                                         ; $4192
    ld [wCamExposureShadow + $1], a               ; $4193
    ld [$a003], a                                 ; $4196
    ld a, [wCamBootV + $3]                        ; $4199
    ld [wCamA004Shadow], a                        ; $419C
    ld [$a004], a                                 ; $419F
    ld a, [wCamBootO + $3]                        ; $41A2
    set 7, a                                      ; $41A5
    ld [wCamA005Shadow], a                        ; $41A7
    ld [$a005], a                                 ; $41AA
    ld a, [wCamGainSel]                           ; $41AD
    ld b, a                                       ; $41B0
    ld a, [wCamContrastRow]                       ; $41B1
    ld c, a                                       ; $41B4
    call Cam_BuildDitherMatrix                    ; $41B5
    ret                                           ; $41B8


jr_00a_41b9:
    ld a, [wCamGainCommitted]                     ; $41B9
    ld [wCamGainSel], a                           ; $41BC
    or $e0                                        ; $41BF
    ld [wCamA001Shadow], a                        ; $41C1
    ld [$a001], a                                 ; $41C4
    ld a, $0b                                     ; $41C7
    ld [wCamExposureShadow], a                    ; $41C9
    ld [$a002], a                                 ; $41CC
    ld a, $00                                     ; $41CF
    ld [wCamExposureShadow + $1], a               ; $41D1
    ld [$a003], a                                 ; $41D4
    ld a, [wCamBootV + $1]                        ; $41D7
    ld [wCamA004Shadow], a                        ; $41DA
    ld [$a004], a                                 ; $41DD
    ld a, [wCamBootO + $1]                        ; $41E0
    set 7, a                                      ; $41E3
    ld [wCamA005Shadow], a                        ; $41E5
    ld [$a005], a                                 ; $41E8
    ld a, [wCamGainSel]                           ; $41EB
    ld b, a                                       ; $41EE
    ld a, [wCamContrastRow]                       ; $41EF
    ld c, a                                       ; $41F2
    call Cam_BuildDitherMatrix                    ; $41F3
    ret                                           ; $41F6


; C: band 3 handler ($D587 = 8, reg 1 $E8): e >= $C000 -> band 4 (e = $8500), e < $2800 -> band 2 (e = $4500) (branch
; target; code read 2026-10-19)
Cam_MainDispatch_Band3::
    ld b, h                                       ; $41F7
    ld c, l                                       ; $41F8
    ld de, $d800                                  ; $41F9
    add hl, de                                    ; $41FC
    jr nc, jr_00a_4237                            ; $41FD

    ld h, b                                       ; $41FF
    ld l, c                                       ; $4200
    ld de, Cam_MainDispatch                       ; $4201
    add hl, de                                    ; $4204
    jp nc, Cam_MainDispatch_WriteExposure         ; $4205

    ld a, $0a                                     ; $4208
    ld [wCamGainSel], a                           ; $420A
    ld [wCamA001Shadow], a                        ; $420D
    ld [$a001], a                                 ; $4210
    ld a, $85                                     ; $4213
    ld [wCamExposureShadow], a                    ; $4215
    ld [$a002], a                                 ; $4218
    xor a                                         ; $421B
    ld [wCamExposureShadow + $1], a               ; $421C
    ld [$a003], a                                 ; $421F
    ld a, [wCamBootV + $4]                        ; $4222
    ld [wCamA004Shadow], a                        ; $4225
    ld [$a004], a                                 ; $4228
    ld a, [wCamBootO + $4]                        ; $422B
    set 7, a                                      ; $422E
    ld [wCamA005Shadow], a                        ; $4230
    ld [$a005], a                                 ; $4233
    ret                                           ; $4236


jr_00a_4237:
    ld a, [wCamGainAlt]                           ; $4237
    ld [wCamGainSel], a                           ; $423A
    or $e0                                        ; $423D
    ld [wCamA001Shadow], a                        ; $423F
    ld [$a001], a                                 ; $4242
    ld a, $45                                     ; $4245
    ld [wCamExposureShadow], a                    ; $4247
    ld [$a002], a                                 ; $424A
    xor a                                         ; $424D
    ld [wCamExposureShadow + $1], a               ; $424E
    ld [$a003], a                                 ; $4251
    ld a, [wCamBootV + $2]                        ; $4254
    ld [wCamA004Shadow], a                        ; $4257
    ld [$a004], a                                 ; $425A
    ld a, [wCamBootO + $2]                        ; $425D
    set 7, a                                      ; $4260
    ld [wCamA005Shadow], a                        ; $4262
    ld [$a005], a                                 ; $4265
    ld a, [wCamGainSel]                           ; $4268
    ld b, a                                       ; $426B
    ld a, [wCamContrastRow]                       ; $426C
    ld c, a                                       ; $426F
    call Cam_BuildDitherMatrix                    ; $4270
    ret                                           ; $4273


; C: band 4 handler ($D587 = $0A, reg 1 $0A): saturates at $FFFF, e < $6000 -> band 3 (reg 1 $E8, e = $8C00) (branch
; target; code read 2026-10-19)
Cam_MainDispatch_Band4::
    ld b, h                                       ; $4274
    ld c, l                                       ; $4275
    ld de, $a000                                  ; $4276
    add hl, de                                    ; $4279
    jr c, Cam_MainDispatch_WriteExposure          ; $427A

    ld a, $08                                     ; $427C
    ld [wCamGainSel], a                           ; $427E
    or $e0                                        ; $4281
    ld [wCamA001Shadow], a                        ; $4283
    ld [$a001], a                                 ; $4286
    ld a, $8c                                     ; $4289
    ld [wCamExposureShadow], a                    ; $428B
    ld [$a002], a                                 ; $428E
    xor a                                         ; $4291
    ld [wCamExposureShadow + $1], a               ; $4292
    ld [$a003], a                                 ; $4295
    ld a, [wCamBootV + $3]                        ; $4298
    ld [wCamA004Shadow], a                        ; $429B
    ld [$a004], a                                 ; $429E
    ld a, [wCamBootO + $3]                        ; $42A1
    set 7, a                                      ; $42A4
    ld [wCamA005Shadow], a                        ; $42A6
    ld [$a005], a                                 ; $42A9
    ret                                           ; $42AC


; C: common tail: copies the shadow exposure $D596 / $D597 to the sensor registers $A002 / $A003 (the five registers
; go out with the next capture start) (branch target; code read 2026-10-19)
Cam_MainDispatch_WriteExposure::
    ld a, [wCamExposureShadow]                    ; $42AD
    ld [$a002], a                                 ; $42B0
    ld a, [wCamExposureShadow + $1]               ; $42B3
    ld [$a003], a                                 ; $42B6
    ret                                           ; $42B9


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 14 (tcrf_check/assets/l3_names/)
Cam_BuildDitherMatrix::
    ld a, $10                                     ; $42BA
    ld [$4000], a                                 ; $42BC
    ld a, [wCamGainCommitted]                     ; $42BF
    cp b                                          ; $42C2
    jr nz, jr_00a_42ca                            ; $42C3

    ld hl, Cam_DitherRamp_ParamsA                 ; $42C5
    jr jr_00a_42e2                                ; $42C8

jr_00a_42ca:
    ld a, [wCamGainAlt]                           ; $42CA
    cp b                                          ; $42CD
    jr nz, jr_00a_42d5                            ; $42CE

    ld hl, Cam_DitherRamp_ParamsB                 ; $42D0
    jr jr_00a_42e2                                ; $42D3

jr_00a_42d5:
    ld a, $08                                     ; $42D5
    cp b                                          ; $42D7
    jr nz, jr_00a_42df                            ; $42D8

    ld hl, Cam_DitherRamp_ParamsA                 ; $42DA
    jr jr_00a_42e2                                ; $42DD

jr_00a_42df:
    ld hl, Cam_DitherRamp_ParamsA                 ; $42DF

jr_00a_42e2:
    ld de, $0004                                  ; $42E2

jr_00a_42e5:
    dec c                                         ; $42E5
    jr z, jr_00a_42eb                             ; $42E6

    add hl, de                                    ; $42E8
    jr jr_00a_42e5                                ; $42E9

jr_00a_42eb:
    ld de, wDitherParams                          ; $42EB
    ld a, [hl+]                                   ; $42EE
    ld [de], a                                    ; $42EF
    inc de                                        ; $42F0
    ld a, [hl+]                                   ; $42F1
    ld [de], a                                    ; $42F2
    inc de                                        ; $42F3
    ld a, [hl+]                                   ; $42F4
    ld [de], a                                    ; $42F5
    inc de                                        ; $42F6
    ld a, [hl+]                                   ; $42F7
    ld [de], a                                    ; $42F8
    ld a, [wCamDitherMode]                        ; $42F9
    cp $00                                        ; $42FC
    jp z, Cam_Dither_Flat                         ; $42FE

    cp $01                                        ; $4301
    jp z, Cam_Dither_RampA                        ; $4303

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_Dither_RampB::
    ld a, [wDitherParams]                         ; $4306
    ld b, a                                       ; $4309
    ld a, [wDitherParams + $1]                    ; $430A
    sub b                                         ; $430D
    swap a                                        ; $430E
    ld b, a                                       ; $4310
    and $f0                                       ; $4311
    ld c, a                                       ; $4313
    ld a, b                                       ; $4314
    and $0f                                       ; $4315
    ld b, a                                       ; $4317
    ld l, $00                                     ; $4318
    ld a, [wDitherParams]                         ; $431A
    ld h, a                                       ; $431D
    ld [$a006], a                                 ; $431E
    ld [$a012], a                                 ; $4321
    ld [$a009], a                                 ; $4324
    ld [$a015], a                                 ; $4327
    add hl, bc                                    ; $432A
    add hl, bc                                    ; $432B
    add hl, bc                                    ; $432C
    add hl, bc                                    ; $432D
    ld a, h                                       ; $432E
    ld [$a024], a                                 ; $432F
    ld [$a030], a                                 ; $4332
    ld [$a027], a                                 ; $4335
    ld [$a033], a                                 ; $4338
    add hl, bc                                    ; $433B
    add hl, bc                                    ; $433C
    add hl, bc                                    ; $433D
    add hl, bc                                    ; $433E
    ld a, h                                       ; $433F
    ld [$a01e], a                                 ; $4340
    ld [$a02a], a                                 ; $4343
    ld [$a021], a                                 ; $4346
    ld [$a02d], a                                 ; $4349
    add hl, bc                                    ; $434C
    add hl, bc                                    ; $434D
    add hl, bc                                    ; $434E
    add hl, bc                                    ; $434F
    ld a, h                                       ; $4350
    ld [$a00c], a                                 ; $4351
    ld [$a018], a                                 ; $4354
    ld [$a00f], a                                 ; $4357
    ld [$a01b], a                                 ; $435A
    ld a, [wDitherParams + $1]                    ; $435D
    ld b, a                                       ; $4360
    ld a, [wDitherParams + $2]                    ; $4361
    sub b                                         ; $4364
    swap a                                        ; $4365
    ld b, a                                       ; $4367
    and $f0                                       ; $4368
    ld c, a                                       ; $436A
    ld a, b                                       ; $436B
    and $0f                                       ; $436C
    ld b, a                                       ; $436E
    ld l, $00                                     ; $436F
    ld a, [wDitherParams + $1]                    ; $4371
    ld h, a                                       ; $4374
    ld [$a007], a                                 ; $4375
    ld [$a013], a                                 ; $4378
    ld [$a00a], a                                 ; $437B
    ld [$a016], a                                 ; $437E
    add hl, bc                                    ; $4381
    add hl, bc                                    ; $4382
    add hl, bc                                    ; $4383
    add hl, bc                                    ; $4384
    ld a, h                                       ; $4385
    ld [$a025], a                                 ; $4386
    ld [$a031], a                                 ; $4389
    ld [$a028], a                                 ; $438C
    ld [$a034], a                                 ; $438F
    add hl, bc                                    ; $4392
    add hl, bc                                    ; $4393
    add hl, bc                                    ; $4394
    add hl, bc                                    ; $4395
    ld a, h                                       ; $4396
    ld [$a01f], a                                 ; $4397
    ld [$a02b], a                                 ; $439A
    ld [$a022], a                                 ; $439D
    ld [$a02e], a                                 ; $43A0
    add hl, bc                                    ; $43A3
    add hl, bc                                    ; $43A4
    add hl, bc                                    ; $43A5
    add hl, bc                                    ; $43A6
    ld a, h                                       ; $43A7
    ld [$a00d], a                                 ; $43A8
    ld [$a019], a                                 ; $43AB
    ld [$a010], a                                 ; $43AE
    ld [$a01c], a                                 ; $43B1
    ld a, [wDitherParams + $2]                    ; $43B4
    ld b, a                                       ; $43B7
    ld a, [wDitherParams + $3]                    ; $43B8
    sub b                                         ; $43BB
    swap a                                        ; $43BC
    ld b, a                                       ; $43BE
    and $f0                                       ; $43BF
    ld c, a                                       ; $43C1
    ld a, b                                       ; $43C2
    and $0f                                       ; $43C3
    ld b, a                                       ; $43C5
    ld l, $00                                     ; $43C6
    ld a, [wDitherParams + $2]                    ; $43C8
    ld h, a                                       ; $43CB
    ld [$a008], a                                 ; $43CC
    ld [$a014], a                                 ; $43CF
    ld [$a00b], a                                 ; $43D2
    ld [$a017], a                                 ; $43D5
    add hl, bc                                    ; $43D8
    add hl, bc                                    ; $43D9
    add hl, bc                                    ; $43DA
    add hl, bc                                    ; $43DB
    ld a, h                                       ; $43DC
    ld [$a026], a                                 ; $43DD
    ld [$a032], a                                 ; $43E0
    ld [$a029], a                                 ; $43E3
    ld [$a035], a                                 ; $43E6
    add hl, bc                                    ; $43E9
    add hl, bc                                    ; $43EA
    add hl, bc                                    ; $43EB
    add hl, bc                                    ; $43EC
    ld a, h                                       ; $43ED
    ld [$a020], a                                 ; $43EE
    ld [$a02c], a                                 ; $43F1
    ld [$a023], a                                 ; $43F4
    ld [$a02f], a                                 ; $43F7
    add hl, bc                                    ; $43FA
    add hl, bc                                    ; $43FB
    add hl, bc                                    ; $43FC
    add hl, bc                                    ; $43FD
    ld a, h                                       ; $43FE
    ld [$a00e], a                                 ; $43FF
    ld [$a01a], a                                 ; $4402
    ld [$a011], a                                 ; $4405
    ld [$a01d], a                                 ; $4408
    ret                                           ; $440B


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_Dither_Flat::
    ld hl, $a006                                  ; $440C
    ld a, [wDitherParams]                         ; $440F
    ld b, a                                       ; $4412
    ld a, [wDitherParams + $1]                    ; $4413
    ld c, a                                       ; $4416
    ld a, [wDitherParams + $2]                    ; $4417
    ld d, a                                       ; $441A
    ld e, $10                                     ; $441B

jr_00a_441d:
    ld a, b                                       ; $441D
    ld [hl+], a                                   ; $441E
    ld a, c                                       ; $441F
    ld [hl+], a                                   ; $4420
    ld a, d                                       ; $4421
    ld [hl+], a                                   ; $4422
    dec e                                         ; $4423
    jr nz, jr_00a_441d                            ; $4424

    ret                                           ; $4426


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 14 (tcrf_check/assets/l3_names/)
Cam_Dither_RampA::
    ld a, [wDitherParams]                         ; $4427
    ld b, a                                       ; $442A
    ld a, [wDitherParams + $1]                    ; $442B
    sub b                                         ; $442E
    swap a                                        ; $442F
    ld b, a                                       ; $4431
    and $f0                                       ; $4432
    ld c, a                                       ; $4434
    ld a, b                                       ; $4435
    and $0f                                       ; $4436
    ld b, a                                       ; $4438
    ld l, $00                                     ; $4439
    ld a, [wDitherParams]                         ; $443B
    ld h, a                                       ; $443E
    ld [$a006], a                                 ; $443F
    add hl, bc                                    ; $4442
    ld a, h                                       ; $4443
    ld [$a024], a                                 ; $4444
    add hl, bc                                    ; $4447
    ld a, h                                       ; $4448
    ld [$a01e], a                                 ; $4449
    add hl, bc                                    ; $444C
    ld a, h                                       ; $444D
    ld [$a00c], a                                 ; $444E
    add hl, bc                                    ; $4451
    ld a, h                                       ; $4452
    ld [$a015], a                                 ; $4453
    add hl, bc                                    ; $4456
    ld a, h                                       ; $4457
    ld [$a033], a                                 ; $4458
    add hl, bc                                    ; $445B
    ld a, h                                       ; $445C
    ld [$a02d], a                                 ; $445D
    add hl, bc                                    ; $4460
    ld a, h                                       ; $4461
    ld [$a01b], a                                 ; $4462
    add hl, bc                                    ; $4465
    ld a, h                                       ; $4466
    ld [$a012], a                                 ; $4467
    add hl, bc                                    ; $446A
    ld a, h                                       ; $446B
    ld [$a030], a                                 ; $446C
    add hl, bc                                    ; $446F
    ld a, h                                       ; $4470
    ld [$a02a], a                                 ; $4471
    add hl, bc                                    ; $4474
    ld a, h                                       ; $4475
    ld [$a018], a                                 ; $4476
    add hl, bc                                    ; $4479
    ld a, h                                       ; $447A
    ld [$a009], a                                 ; $447B
    add hl, bc                                    ; $447E
    ld a, h                                       ; $447F
    ld [$a027], a                                 ; $4480
    add hl, bc                                    ; $4483
    ld a, h                                       ; $4484
    ld [$a021], a                                 ; $4485
    add hl, bc                                    ; $4488
    ld a, h                                       ; $4489
    ld [$a00f], a                                 ; $448A
    ld a, [wDitherParams + $1]                    ; $448D
    ld b, a                                       ; $4490
    ld a, [wDitherParams + $2]                    ; $4491
    sub b                                         ; $4494
    swap a                                        ; $4495
    ld b, a                                       ; $4497
    and $f0                                       ; $4498
    ld c, a                                       ; $449A
    ld a, b                                       ; $449B
    and $0f                                       ; $449C
    ld b, a                                       ; $449E
    ld l, $00                                     ; $449F
    ld a, [wDitherParams + $1]                    ; $44A1
    ld h, a                                       ; $44A4
    ld [$a007], a                                 ; $44A5
    add hl, bc                                    ; $44A8
    ld a, h                                       ; $44A9
    ld [$a025], a                                 ; $44AA
    add hl, bc                                    ; $44AD
    ld a, h                                       ; $44AE
    ld [$a01f], a                                 ; $44AF
    add hl, bc                                    ; $44B2
    ld a, h                                       ; $44B3
    ld [$a00d], a                                 ; $44B4
    add hl, bc                                    ; $44B7
    ld a, h                                       ; $44B8
    ld [$a016], a                                 ; $44B9
    add hl, bc                                    ; $44BC
    ld a, h                                       ; $44BD
    ld [$a034], a                                 ; $44BE
    add hl, bc                                    ; $44C1
    ld a, h                                       ; $44C2
    ld [$a02e], a                                 ; $44C3
    add hl, bc                                    ; $44C6
    ld a, h                                       ; $44C7
    ld [$a01c], a                                 ; $44C8
    add hl, bc                                    ; $44CB
    ld a, h                                       ; $44CC
    ld [$a013], a                                 ; $44CD
    add hl, bc                                    ; $44D0
    ld a, h                                       ; $44D1
    ld [$a031], a                                 ; $44D2
    add hl, bc                                    ; $44D5
    ld a, h                                       ; $44D6
    ld [$a02b], a                                 ; $44D7
    add hl, bc                                    ; $44DA
    ld a, h                                       ; $44DB
    ld [$a019], a                                 ; $44DC
    add hl, bc                                    ; $44DF
    ld a, h                                       ; $44E0
    ld [$a00a], a                                 ; $44E1
    add hl, bc                                    ; $44E4
    ld a, h                                       ; $44E5
    ld [$a028], a                                 ; $44E6
    add hl, bc                                    ; $44E9
    ld a, h                                       ; $44EA
    ld [$a022], a                                 ; $44EB
    add hl, bc                                    ; $44EE
    ld a, h                                       ; $44EF
    ld [$a010], a                                 ; $44F0
    ld a, [wDitherParams + $2]                    ; $44F3
    ld b, a                                       ; $44F6
    ld a, [wDitherParams + $3]                    ; $44F7
    sub b                                         ; $44FA
    swap a                                        ; $44FB
    ld b, a                                       ; $44FD
    and $f0                                       ; $44FE
    ld c, a                                       ; $4500
    ld a, b                                       ; $4501
    and $0f                                       ; $4502
    ld b, a                                       ; $4504
    ld l, $00                                     ; $4505
    ld a, [wDitherParams + $2]                    ; $4507
    ld h, a                                       ; $450A
    ld [$a008], a                                 ; $450B
    add hl, bc                                    ; $450E
    ld a, h                                       ; $450F
    ld [$a026], a                                 ; $4510
    add hl, bc                                    ; $4513
    ld a, h                                       ; $4514
    ld [$a020], a                                 ; $4515
    add hl, bc                                    ; $4518
    ld a, h                                       ; $4519
    ld [$a00e], a                                 ; $451A
    add hl, bc                                    ; $451D
    ld a, h                                       ; $451E
    ld [$a017], a                                 ; $451F
    add hl, bc                                    ; $4522
    ld a, h                                       ; $4523
    ld [$a035], a                                 ; $4524
    add hl, bc                                    ; $4527
    ld a, h                                       ; $4528
    ld [$a02f], a                                 ; $4529
    add hl, bc                                    ; $452C
    ld a, h                                       ; $452D
    ld [$a01d], a                                 ; $452E
    add hl, bc                                    ; $4531
    ld a, h                                       ; $4532
    ld [$a014], a                                 ; $4533
    add hl, bc                                    ; $4536
    ld a, h                                       ; $4537
    ld [$a032], a                                 ; $4538
    add hl, bc                                    ; $453B
    ld a, h                                       ; $453C
    ld [$a02c], a                                 ; $453D
    add hl, bc                                    ; $4540
    ld a, h                                       ; $4541
    ld [$a01a], a                                 ; $4542
    add hl, bc                                    ; $4545
    ld a, h                                       ; $4546
    ld [$a00b], a                                 ; $4547
    add hl, bc                                    ; $454A
    ld a, h                                       ; $454B
    ld [$a029], a                                 ; $454C
    add hl, bc                                    ; $454F
    ld a, h                                       ; $4550
    ld [$a023], a                                 ; $4551
    add hl, bc                                    ; $4554
    ld a, h                                       ; $4555
    ld [$a011], a                                 ; $4556
    ret                                           ; $4559


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryTest::
    ld a, $a0                                     ; $455A
    ldh [hScratchC], a                            ; $455C
    ld a, $82                                     ; $455E
    ldh [hScratchD], a                            ; $4560
    call Cam_FactoryMeasure1                      ; $4562
    ld a, $a0                                     ; $4565
    ldh [hScratchC], a                            ; $4567
    ld a, $02                                     ; $4569
    ldh [hScratchD], a                            ; $456B
    call Cam_FactoryMeasure2                      ; $456D
    ld a, $02                                     ; $4570
    ld [$4000], a                                 ; $4572
    ld a, [wCamCalibVector + $a]                  ; $4575
    ld b, a                                       ; $4578
    ld a, [$affc]                                 ; $4579
    cp b                                          ; $457C
    jr c, jr_00a_4588                             ; $457D

    sub b                                         ; $457F
    ldh [hDiffOrValue], a                         ; $4580
    ld a, $24                                     ; $4582
    ldh [hScratchD], a                            ; $4584
    jr jr_00a_4591                                ; $4586

jr_00a_4588:
    ld c, a                                       ; $4588
    ld a, b                                       ; $4589
    sub c                                         ; $458A
    ldh [hDiffOrValue], a                         ; $458B
    ld a, $25                                     ; $458D
    ldh [hScratchD], a                            ; $458F

jr_00a_4591:
    ld a, [wCamCalibVector + $b]                  ; $4591
    ld b, a                                       ; $4594
    ld a, [$affd]                                 ; $4595
    cp b                                          ; $4598
    jr c, jr_00a_45a4                             ; $4599

    sub b                                         ; $459B
    ldh [hDiff2], a                               ; $459C
    ld a, $24                                     ; $459E
    ldh [hPrevOrSign], a                          ; $45A0
    jr jr_00a_45ad                                ; $45A2

jr_00a_45a4:
    ld c, a                                       ; $45A4
    ld a, b                                       ; $45A5
    sub c                                         ; $45A6
    ldh [hDiff2], a                               ; $45A7
    ld a, $25                                     ; $45A9
    ldh [hPrevOrSign], a                          ; $45AB

jr_00a_45ad:
    ldh a, [hDiffOrValue]                         ; $45AD
    ld b, a                                       ; $45AF
    ld a, [$aff0]                                 ; $45B0
    sub b                                         ; $45B3
    jr c, jr_00a_45c4                             ; $45B4

    ldh a, [hDiff2]                               ; $45B6
    ld b, a                                       ; $45B8
    ld a, [$aff1]                                 ; $45B9
    sub b                                         ; $45BC
    jr c, jr_00a_45c4                             ; $45BD

    xor a                                         ; $45BF
    ldh [hDiagPassFlag], a                        ; $45C0
    jr jr_00a_45c8                                ; $45C2

jr_00a_45c4:
    ld a, $ff                                     ; $45C4
    ldh [hDiagPassFlag], a                        ; $45C6

jr_00a_45c8:
    ret                                           ; $45C8


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_Calib_ValidityCheck::
    call Cam_Calib_ReadPrimaryCopy                ; $45C9
    or a                                          ; $45CC
    jr z, jr_00a_460b                             ; $45CD

    ld a, $7e                                     ; $45CF
    ld [wCamCalibVector], a                       ; $45D1
    ld a, $7f                                     ; $45D4
    ld [wCamCalibVector + $1], a                  ; $45D6
    ld a, $7f                                     ; $45D9
    ld [wCamCalibVector + $2], a                  ; $45DB
    ld a, $7f                                     ; $45DE
    ld [wCamCalibVector + $3], a                  ; $45E0
    ld a, $7e                                     ; $45E3
    ld [wCamCalibVector + $4], a                  ; $45E5
    ld a, $7d                                     ; $45E8
    ld [wCamCalibVector + $5], a                  ; $45EA
    ld a, $7e                                     ; $45ED
    ld [wCamCalibVector + $6], a                  ; $45EF
    ld a, $7e                                     ; $45F2
    ld [wCamCalibVector + $7], a                  ; $45F4
    ld a, $7d                                     ; $45F7
    ld [wCamCalibVector + $8], a                  ; $45F9
    ld a, $7e                                     ; $45FC
    ld [wCamCalibVector + $9], a                  ; $45FE
    ld a, $7d                                     ; $4601
    ld [wCamCalibVector + $a], a                  ; $4603
    ld a, $6a                                     ; $4606
    ld [wCamCalibVector + $b], a                  ; $4608

jr_00a_460b:
    call Cam_Calib_Loader                         ; $460B
    ret                                           ; $460E


; C: checksum of the 12-byte vector at $AFF2 (sum+$0D; xor+$23); FF8A := 1 when valid
Cam_Calib_ReadPrimaryCopy::
    ld a, $02                                     ; $460F
    ld [$4000], a                                 ; $4611
    ld hl, $aff2                                  ; $4614
    ld b, $00                                     ; $4617
    ld c, $00                                     ; $4619
    ld d, $0c                                     ; $461B

jr_00a_461d:
    ld a, [hl+]                                   ; $461D
    ld e, a                                       ; $461E
    add b                                         ; $461F
    ld b, a                                       ; $4620
    ld a, e                                       ; $4621
    xor c                                         ; $4622
    ld c, a                                       ; $4623
    dec d                                         ; $4624
    jr nz, jr_00a_461d                            ; $4625

    ld a, b                                       ; $4627
    add $0d                                       ; $4628
    ld b, a                                       ; $462A
    ld a, c                                       ; $462B
    add $23                                       ; $462C
    ld c, a                                       ; $462E
    ld a, [hl+]                                   ; $462F
    cp b                                          ; $4630
    jr nz, jr_00a_4641                            ; $4631

    ldh [hScratchB], a                            ; $4633
    ld a, [hl+]                                   ; $4635
    cp c                                          ; $4636
    jr nz, jr_00a_4641                            ; $4637

    ldh [hScratchC], a                            ; $4639
    ld a, $01                                     ; $463B
    ldh [hScratchA], a                            ; $463D
    jr Cam_Calib_EchoCompare                      ; $463F

jr_00a_4641:
    ld a, $00                                     ; $4641
    ldh [hScratchA], a                            ; $4643

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_Calib_EchoCompare::
    ld a, $08                                     ; $4645
    ld [$4000], a                                 ; $4647
    ld hl, $bff2                                  ; $464A
    ld b, $00                                     ; $464D
    ld c, $00                                     ; $464F
    ld d, $0c                                     ; $4651

jr_00a_4653:
    ld a, [hl+]                                   ; $4653
    ld e, a                                       ; $4654
    add b                                         ; $4655
    ld b, a                                       ; $4656
    ld a, e                                       ; $4657
    xor c                                         ; $4658
    ld c, a                                       ; $4659
    dec d                                         ; $465A
    jr nz, jr_00a_4653                            ; $465B

    ld a, b                                       ; $465D
    add $0d                                       ; $465E
    ld b, a                                       ; $4660
    ld a, c                                       ; $4661
    add $23                                       ; $4662
    ld c, a                                       ; $4664
    ld a, [hl+]                                   ; $4665
    cp b                                          ; $4666
    jr nz, jr_00a_4678                            ; $4667

    ldh [hScratchD], a                            ; $4669
    ld a, [hl+]                                   ; $466B
    cp c                                          ; $466C
    jr nz, jr_00a_4678                            ; $466D

    ldh [hDiffOrValue], a                         ; $466F
    ldh a, [hScratchA]                            ; $4671
    and a                                         ; $4673
    jr z, jr_00a_46b7                             ; $4674

    jr jr_00a_467f                                ; $4676

jr_00a_4678:
    ldh a, [hScratchA]                            ; $4678
    and a                                         ; $467A
    jr z, jr_00a_469c                             ; $467B

    jr Cam_Calib_RepairPaths                      ; $467D

jr_00a_467f:
    ldh a, [hScratchB]                            ; $467F
    ld b, a                                       ; $4681
    ldh a, [hScratchD]                            ; $4682
    cp b                                          ; $4684
    jr nz, jr_00a_469c                            ; $4685

    ldh a, [hScratchC]                            ; $4687
    ld b, a                                       ; $4689
    ldh a, [hDiffOrValue]                         ; $468A
    cp b                                          ; $468C
    jr nz, jr_00a_469c                            ; $468D

    ld a, $02                                     ; $468F
    ld [$4000], a                                 ; $4691
    ld hl, $aff2                                  ; $4694
    call Cam_Calib_CopyFromSram                   ; $4697
    xor a                                         ; $469A
    ret                                           ; $469B


jr_00a_469c:
    ld a, $ff                                     ; $469C
    ret                                           ; $469E


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_Calib_RepairPaths::
    ld a, $02                                     ; $469F
    ld [$4000], a                                 ; $46A1
    ld hl, $aff2                                  ; $46A4
    call Cam_Calib_CopyFromSram                   ; $46A7
    ld a, $08                                     ; $46AA
    ld [$4000], a                                 ; $46AC
    ld hl, $bff2                                  ; $46AF
    call Cam_Calib_CopyToSram                     ; $46B2
    xor a                                         ; $46B5
    ret                                           ; $46B6


jr_00a_46b7:
    ld a, $08                                     ; $46B7
    ld [$4000], a                                 ; $46B9
    ld hl, $bff2                                  ; $46BC
    call Cam_Calib_CopyFromSram                   ; $46BF
    ld a, $02                                     ; $46C2
    ld [$4000], a                                 ; $46C4
    ld hl, $aff2                                  ; $46C7
    call Cam_Calib_CopyToSram                     ; $46CA
    xor a                                         ; $46CD
    ret                                           ; $46CE


; C: 12 bytes + 2 checksum bytes to D5B5
Cam_Calib_CopyFromSram::
    ld de, wCamCalibVector                        ; $46CF
    ld b, $0c                                     ; $46D2

jr_00a_46d4:
    ld a, [hl+]                                   ; $46D4
    ld [de], a                                    ; $46D5
    inc de                                        ; $46D6
    dec b                                         ; $46D7
    jr nz, jr_00a_46d4                            ; $46D8

    ld a, [hl+]                                   ; $46DA
    ldh [hScratchB], a                            ; $46DB
    ld a, [hl+]                                   ; $46DD
    ldh [hScratchC], a                            ; $46DE
    ret                                           ; $46E0


; C: writes the vector with SRAM enabled
Cam_Calib_CopyToSram::
    ld a, $0a                                     ; $46E1
    ld [$0000], a                                 ; $46E3
    ld de, wCamCalibVector                        ; $46E6
    ld b, $0c                                     ; $46E9

jr_00a_46eb:
    ld a, [de]                                    ; $46EB
    ld [hl+], a                                   ; $46EC
    inc de                                        ; $46ED
    dec b                                         ; $46EE
    jr nz, jr_00a_46eb                            ; $46EF

    ldh a, [hScratchB]                            ; $46F1
    ld [hl+], a                                   ; $46F3
    ldh a, [hScratchC]                            ; $46F4
    ld [hl], a                                    ; $46F6
    ld a, $00                                     ; $46F7
    ld [$0000], a                                 ; $46F9
    ret                                           ; $46FC


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_Calib_Loader::
    ld a, $02                                     ; $46FD
    ld [$4000], a                                 ; $46FF
    ld hl, $aff2                                  ; $4702
    ld b, $aa                                     ; $4705
    ld c, $0c                                     ; $4707

jr_00a_4709:
    ld a, [hl+]                                   ; $4709
    cp b                                          ; $470A
    jr nz, Cam_Calib_BootMeasureSeq               ; $470B

    dec c                                         ; $470D
    jr nz, jr_00a_4709                            ; $470E

    ld a, $08                                     ; $4710
    ld [$4000], a                                 ; $4712
    ld hl, $bff2                                  ; $4715
    ld c, $0c                                     ; $4718

jr_00a_471a:
    ld a, [hl+]                                   ; $471A
    cp b                                          ; $471B
    jr nz, Cam_Calib_BootMeasureSeq               ; $471C

    dec c                                         ; $471E
    jr nz, jr_00a_471a                            ; $471F

    ld a, $ff                                     ; $4721
    ret                                           ; $4723


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_Calib_BootMeasureSeq::
    ld a, $a0                                     ; $4724
    ldh [hScratchC], a                            ; $4726
    ld a, $02                                     ; $4728
    ldh [hScratchD], a                            ; $472A
    call Cam_ExposureBandSelect                   ; $472C
    ld a, $10                                     ; $472F
    ld [$4000], a                                 ; $4731
    ld a, [wCamBootMatrixRef]                     ; $4734
    ld b, a                                       ; $4737
    ld hl, $a006                                  ; $4738
    ld de, $0030                                  ; $473B

jr_00a_473e:
    ld [hl], b                                    ; $473E
    inc hl                                        ; $473F
    dec de                                        ; $4740
    ld a, d                                       ; $4741
    or e                                          ; $4742
    jr nz, jr_00a_473e                            ; $4743

    ld a, $02                                     ; $4745
    ld [wCamA000Shadow], a                        ; $4747
    ld a, [wCamGainCommitted]                     ; $474A
    or $20                                        ; $474D
    ld [$a001], a                                 ; $474F
    ld [wCamA001Shadow], a                        ; $4752
    xor a                                         ; $4755
    ld [$a002], a                                 ; $4756
    ld [wCamExposureShadow], a                    ; $4759
    ld a, $10                                     ; $475C
    ld [$a003], a                                 ; $475E
    ld [wCamExposureShadow + $1], a               ; $4761
    ld a, $03                                     ; $4764
    ld [$a004], a                                 ; $4766
    ld [wCamA004Shadow], a                        ; $4769
    call Cam_ORegister_SAR_Search                 ; $476C
    ld a, [wCamA004Shadow]                        ; $476F
    and $07                                       ; $4772
    ld [wCamBootV], a                             ; $4774
    ld a, [wCamA005Shadow]                        ; $4777
    res 7, a                                      ; $477A
    ld [wCamBootO], a                             ; $477C
    ld a, [wCamBootMatrixRef + $1]                ; $477F
    ld b, a                                       ; $4782
    ld hl, $a006                                  ; $4783
    ld de, $0030                                  ; $4786

jr_00a_4789:
    ld [hl], b                                    ; $4789
    inc hl                                        ; $478A
    dec de                                        ; $478B
    ld a, d                                       ; $478C
    or e                                          ; $478D
    jr nz, jr_00a_4789                            ; $478E

    ld a, [wCamGainCommitted]                     ; $4790
    or $20                                        ; $4793
    ld [$a001], a                                 ; $4795
    ld [wCamA001Shadow], a                        ; $4798
    ld a, $23                                     ; $479B
    ld [$a004], a                                 ; $479D
    ld [wCamA004Shadow], a                        ; $47A0
    call Cam_ORegister_SAR_Search                 ; $47A3
    ld a, [wCamA004Shadow]                        ; $47A6
    and $07                                       ; $47A9
    ld [wCamBootV + $1], a                        ; $47AB
    ld a, [wCamA005Shadow]                        ; $47AE
    res 7, a                                      ; $47B1
    ld [wCamBootO + $1], a                        ; $47B3
    ld a, [wCamBootMatrixRef + $2]                ; $47B6
    ld b, a                                       ; $47B9
    ld hl, $a006                                  ; $47BA
    ld de, $0030                                  ; $47BD

jr_00a_47c0:
    ld [hl], b                                    ; $47C0
    inc hl                                        ; $47C1
    dec de                                        ; $47C2
    ld a, d                                       ; $47C3
    or e                                          ; $47C4
    jr nz, jr_00a_47c0                            ; $47C5

    ld a, [wCamGainAlt]                           ; $47C7
    or $20                                        ; $47CA
    ld [$a001], a                                 ; $47CC
    ld [wCamA001Shadow], a                        ; $47CF
    ld a, $23                                     ; $47D2
    ld [$a004], a                                 ; $47D4
    ld [wCamA004Shadow], a                        ; $47D7
    call Cam_ORegister_SAR_Search                 ; $47DA
    ld a, [wCamA004Shadow]                        ; $47DD
    and $07                                       ; $47E0
    ld [wCamBootV + $2], a                        ; $47E2
    ld a, [wCamA005Shadow]                        ; $47E5
    res 7, a                                      ; $47E8
    ld [wCamBootO + $2], a                        ; $47EA
    ld a, [wCamCalibVector + $a]                  ; $47ED
    ld b, a                                       ; $47F0
    ld hl, $a006                                  ; $47F1
    ld de, $0030                                  ; $47F4

jr_00a_47f7:
    ld [hl], b                                    ; $47F7
    inc hl                                        ; $47F8
    dec de                                        ; $47F9
    ld a, d                                       ; $47FA
    or e                                          ; $47FB
    jr nz, jr_00a_47f7                            ; $47FC

    ld a, $08                                     ; $47FE
    or $20                                        ; $4800
    ld [$a001], a                                 ; $4802
    ld [wCamA001Shadow], a                        ; $4805
    ld a, $23                                     ; $4808
    ld [$a004], a                                 ; $480A
    ld [wCamA004Shadow], a                        ; $480D
    call Cam_ORegister_SAR_Search                 ; $4810
    ld a, [wCamA004Shadow]                        ; $4813
    and $07                                       ; $4816
    ld [wCamBootV + $3], a                        ; $4818
    ld a, [wCamA005Shadow]                        ; $481B
    res 7, a                                      ; $481E
    ld [wCamBootO + $3], a                        ; $4820
    ld a, [wCamCalibVector + $b]                  ; $4823
    ld b, a                                       ; $4826
    ld hl, $a006                                  ; $4827
    ld de, $0030                                  ; $482A

jr_00a_482d:
    ld [hl], b                                    ; $482D
    inc hl                                        ; $482E
    dec de                                        ; $482F
    ld a, d                                       ; $4830
    or e                                          ; $4831
    jr nz, jr_00a_482d                            ; $4832

    ld a, $0a                                     ; $4834
    ld [$a001], a                                 ; $4836
    ld [wCamA001Shadow], a                        ; $4839
    ld a, $03                                     ; $483C
    ld [$a004], a                                 ; $483E
    ld [wCamA004Shadow], a                        ; $4841
    call Cam_ORegister_SAR_Search                 ; $4844
    ld a, [wCamA004Shadow]                        ; $4847
    and $07                                       ; $484A
    ld [wCamBootV + $4], a                        ; $484C
    ld a, [wCamA005Shadow]                        ; $484F
    res 7, a                                      ; $4852
    ld [wCamBootO + $4], a                        ; $4854
    xor a                                         ; $4857
    ret                                           ; $4858


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_ExposureBandSelect::
    ld a, $10                                     ; $4859
    ld [$4000], a                                 ; $485B
    xor a                                         ; $485E
    ld [wCamGainSel], a                           ; $485F

jr_00a_4862:
    ld a, $02                                     ; $4862
    ld [wCamA000Shadow], a                        ; $4864
    ld a, [wCamGainSel]                           ; $4867
    ld [$a001], a                                 ; $486A
    xor a                                         ; $486D
    ld [$a002], a                                 ; $486E
    ld a, $10                                     ; $4871
    ld [$a003], a                                 ; $4873
    ld a, $05                                     ; $4876
    ld [$a004], a                                 ; $4878
    ld a, $80                                     ; $487B
    ld [$a005], a                                 ; $487D
    ld [wCamA005Shadow], a                        ; $4880
    ld b, $d5                                     ; $4883
    ld hl, $a006                                  ; $4885
    ld de, $0030                                  ; $4888

jr_00a_488b:
    ld [hl], b                                    ; $488B
    inc hl                                        ; $488C
    dec de                                        ; $488D
    ld a, d                                       ; $488E
    or e                                          ; $488F
    jr nz, jr_00a_488b                            ; $4890

    call Cam_ORegister_SAR_Search                 ; $4892
    ld a, [wCamA005Shadow]                        ; $4895
    res 7, a                                      ; $4898
    ld [$a005], a                                 ; $489A
    ld [wCamA005Shadow], a                        ; $489D
    ld b, $80                                     ; $48A0
    ld hl, $a006                                  ; $48A2
    ld de, $0030                                  ; $48A5

jr_00a_48a8:
    ld [hl], b                                    ; $48A8
    inc hl                                        ; $48A9
    dec de                                        ; $48AA
    ld a, d                                       ; $48AB
    or e                                          ; $48AC
    jr nz, jr_00a_48a8                            ; $48AD

    ld a, $10                                     ; $48AF
    ld [$4000], a                                 ; $48B1
    ld a, [wCamA000Shadow]                        ; $48B4
    set 0, a                                      ; $48B7
    ld [$a000], a                                 ; $48B9

jr_00a_48bc:
    ld a, [$a000]                                 ; $48BC
    bit 0, a                                      ; $48BF
    jr nz, jr_00a_48bc                            ; $48C1

    ld a, $09                                     ; $48C3
    call Cam_PixelTestHelper                      ; $48C5
    or a                                          ; $48C8
    jr nz, jr_00a_48d6                            ; $48C9

    ld a, [wCamGainSel]                           ; $48CB
    inc a                                         ; $48CE
    ld [wCamGainSel], a                           ; $48CF
    cp $03                                        ; $48D2
    jr nz, jr_00a_4862                            ; $48D4

jr_00a_48d6:
    ld a, [wCamGainSel]                           ; $48D6
    ld [wCamGainCommitted], a                     ; $48D9
    or a                                          ; $48DC
    jr nz, jr_00a_48f7                            ; $48DD

    ld a, $04                                     ; $48DF
    ld [wCamGainAlt], a                           ; $48E1
    ld a, [wCamCalibVector]                       ; $48E4
    ld [wCamBootMatrixRef], a                     ; $48E7
    ld a, [wCamCalibVector + $4]                  ; $48EA
    ld [wCamBootMatrixRef + $1], a                ; $48ED
    ld a, [wCamCalibVector + $8]                  ; $48F0
    ld [wCamBootMatrixRef + $2], a                ; $48F3
    ret                                           ; $48F6


jr_00a_48f7:
    cp $01                                        ; $48F7
    jr nz, jr_00a_4913                            ; $48F9

    ld a, $04                                     ; $48FB
    ld [wCamGainAlt], a                           ; $48FD
    ld a, [wCamCalibVector + $1]                  ; $4900
    ld [wCamBootMatrixRef], a                     ; $4903
    ld a, [wCamCalibVector + $5]                  ; $4906
    ld [wCamBootMatrixRef + $1], a                ; $4909
    ld a, [wCamCalibVector + $8]                  ; $490C
    ld [wCamBootMatrixRef + $2], a                ; $490F
    ret                                           ; $4912


jr_00a_4913:
    cp $02                                        ; $4913
    jr nz, jr_00a_492f                            ; $4915

    ld a, $05                                     ; $4917
    ld [wCamGainAlt], a                           ; $4919
    ld a, [wCamCalibVector + $2]                  ; $491C
    ld [wCamBootMatrixRef], a                     ; $491F
    ld a, [wCamCalibVector + $6]                  ; $4922
    ld [wCamBootMatrixRef + $1], a                ; $4925
    ld a, [wCamCalibVector + $9]                  ; $4928
    ld [wCamBootMatrixRef + $2], a                ; $492B
    ret                                           ; $492E


jr_00a_492f:
    ld a, $05                                     ; $492F
    ld [wCamGainAlt], a                           ; $4931
    ld a, [wCamCalibVector + $3]                  ; $4934
    ld [wCamBootMatrixRef], a                     ; $4937
    ld a, [wCamCalibVector + $7]                  ; $493A
    ld [wCamBootMatrixRef + $1], a                ; $493D
    ld a, [wCamCalibVector + $9]                  ; $4940
    ld [wCamBootMatrixRef + $2], a                ; $4943
    ret                                           ; $4946


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FullCalibration::
    ld a, $a0                                     ; $4947
    ldh [hScratchC], a                            ; $4949
    ld a, $82                                     ; $494B
    ldh [hScratchD], a                            ; $494D
    call Cam_FactoryMeasure1                      ; $494F
    ld a, $a0                                     ; $4952
    ldh [hScratchC], a                            ; $4954
    ld a, $02                                     ; $4956
    ldh [hScratchD], a                            ; $4958
    call Cam_FactoryMeasure2                      ; $495A
    call Cam_CommitVectorToSRAM                   ; $495D
    ret                                           ; $4960


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryMeasure1::
    ld a, $10                                     ; $4961
    ld [$4000], a                                 ; $4963
    ld b, $80                                     ; $4966
    ld hl, $a006                                  ; $4968
    ld de, $0030                                  ; $496B

jr_00a_496e:
    ld [hl], b                                    ; $496E
    inc hl                                        ; $496F
    dec de                                        ; $4970
    ld a, d                                       ; $4971
    or e                                          ; $4972
    jr nz, jr_00a_496e                            ; $4973

    ld a, $02                                     ; $4975
    ld [wCamA000Shadow], a                        ; $4977
    ld a, $20                                     ; $497A
    ld [$a001], a                                 ; $497C
    ld [wCamA001Shadow], a                        ; $497F
    xor a                                         ; $4982
    ld [$a002], a                                 ; $4983
    ld [wCamExposureShadow], a                    ; $4986
    ld a, $30                                     ; $4989
    ld [$a003], a                                 ; $498B
    ld [wCamExposureShadow + $1], a               ; $498E
    ld a, $03                                     ; $4991
    ld [$a004], a                                 ; $4993
    ld [wCamA004Shadow], a                        ; $4996
    call Cam_ORegister_SAR_Search                 ; $4999
    ld a, [wCamA004Shadow]                        ; $499C
    and $07                                       ; $499F
    ld [wCamFactoryVo], a                         ; $49A1
    ld a, [wCamA005Shadow]                        ; $49A4
    res 7, a                                      ; $49A7
    ld [wCamFactoryVo + $c], a                    ; $49A9
    ld a, $21                                     ; $49AC
    ld [$a001], a                                 ; $49AE
    ld [wCamA001Shadow], a                        ; $49B1
    ld a, $03                                     ; $49B4
    ld [$a004], a                                 ; $49B6
    ld [wCamA004Shadow], a                        ; $49B9
    call Cam_ORegister_SAR_Search                 ; $49BC
    ld a, [wCamA004Shadow]                        ; $49BF
    and $07                                       ; $49C2
    ld [wCamFactoryVo + $1], a                    ; $49C4
    ld a, [wCamA005Shadow]                        ; $49C7
    res 7, a                                      ; $49CA
    ld [wCamFactoryVo + $d], a                    ; $49CC
    ld a, $22                                     ; $49CF
    ld [$a001], a                                 ; $49D1
    ld [wCamA001Shadow], a                        ; $49D4
    ld a, $03                                     ; $49D7
    ld [$a004], a                                 ; $49D9
    ld [wCamA004Shadow], a                        ; $49DC
    call Cam_ORegister_SAR_Search                 ; $49DF
    ld a, [wCamA004Shadow]                        ; $49E2
    and $07                                       ; $49E5
    ld [wCamFactoryVo + $2], a                    ; $49E7
    ld a, [wCamA005Shadow]                        ; $49EA
    res 7, a                                      ; $49ED
    ld [wCamFactoryVo + $e], a                    ; $49EF
    ld a, $23                                     ; $49F2
    ld [$a001], a                                 ; $49F4
    ld [wCamA001Shadow], a                        ; $49F7
    ld a, $03                                     ; $49FA
    ld [$a004], a                                 ; $49FC
    ld [wCamA004Shadow], a                        ; $49FF
    call Cam_ORegister_SAR_Search                 ; $4A02
    ld a, [wCamA004Shadow]                        ; $4A05
    and $07                                       ; $4A08
    ld [wCamFactoryVo + $3], a                    ; $4A0A
    ld a, [wCamA005Shadow]                        ; $4A0D
    res 7, a                                      ; $4A10
    ld [wCamFactoryVo + $f], a                    ; $4A12
    ld a, $e0                                     ; $4A15
    ld [$a001], a                                 ; $4A17
    ld [wCamA001Shadow], a                        ; $4A1A
    ld a, $09                                     ; $4A1D
    ld [$a002], a                                 ; $4A1F
    ld [wCamExposureShadow], a                    ; $4A22
    xor a                                         ; $4A25
    ld [$a003], a                                 ; $4A26
    ld [wCamExposureShadow + $1], a               ; $4A29
    ld a, $03                                     ; $4A2C
    ld [$a004], a                                 ; $4A2E
    ld [wCamA004Shadow], a                        ; $4A31
    call Cam_ORegister_SAR_Search                 ; $4A34
    ld a, [wCamA004Shadow]                        ; $4A37
    and $07                                       ; $4A3A
    ld [wCamFactoryVo + $4], a                    ; $4A3C
    ld a, [wCamA005Shadow]                        ; $4A3F
    res 7, a                                      ; $4A42
    ld [wCamFactoryVo + $10], a                   ; $4A44
    ld a, $e1                                     ; $4A47
    ld [$a001], a                                 ; $4A49
    ld [wCamA001Shadow], a                        ; $4A4C
    ld a, $03                                     ; $4A4F
    ld [$a004], a                                 ; $4A51
    ld [wCamA004Shadow], a                        ; $4A54
    call Cam_ORegister_SAR_Search                 ; $4A57
    ld a, [wCamA004Shadow]                        ; $4A5A
    and $07                                       ; $4A5D
    ld [wCamFactoryVo + $5], a                    ; $4A5F
    ld a, [wCamA005Shadow]                        ; $4A62
    res 7, a                                      ; $4A65
    ld [wCamFactoryVo + $11], a                   ; $4A67
    ld a, $e2                                     ; $4A6A
    ld [$a001], a                                 ; $4A6C
    ld [wCamA001Shadow], a                        ; $4A6F
    ld a, $03                                     ; $4A72
    ld [$a004], a                                 ; $4A74
    ld [wCamA004Shadow], a                        ; $4A77
    call Cam_ORegister_SAR_Search                 ; $4A7A
    ld a, [wCamA004Shadow]                        ; $4A7D
    and $07                                       ; $4A80
    ld [wCamFactoryVo + $6], a                    ; $4A82
    ld a, [wCamA005Shadow]                        ; $4A85
    res 7, a                                      ; $4A88
    ld [wCamFactoryVo + $12], a                   ; $4A8A
    ld a, $e3                                     ; $4A8D
    ld [$a001], a                                 ; $4A8F
    ld [wCamA001Shadow], a                        ; $4A92
    ld a, $03                                     ; $4A95
    ld [$a004], a                                 ; $4A97
    ld [wCamA004Shadow], a                        ; $4A9A
    call Cam_ORegister_SAR_Search                 ; $4A9D
    ld a, [wCamA004Shadow]                        ; $4AA0
    and $07                                       ; $4AA3
    ld [wCamFactoryVo + $7], a                    ; $4AA5
    ld a, [wCamA005Shadow]                        ; $4AA8
    res 7, a                                      ; $4AAB
    ld [wCamFactoryVo + $13], a                   ; $4AAD
    ld a, $e4                                     ; $4AB0
    ld [$a001], a                                 ; $4AB2
    ld [wCamA001Shadow], a                        ; $4AB5
    ld a, $20                                     ; $4AB8
    ld [$a002], a                                 ; $4ABA
    ld [wCamExposureShadow], a                    ; $4ABD
    xor a                                         ; $4AC0
    ld [$a003], a                                 ; $4AC1
    ld [wCamExposureShadow + $1], a               ; $4AC4
    ld a, $03                                     ; $4AC7
    ld [$a004], a                                 ; $4AC9
    ld [wCamA004Shadow], a                        ; $4ACC
    call Cam_ORegister_SAR_Search                 ; $4ACF
    ld a, [wCamA004Shadow]                        ; $4AD2
    and $07                                       ; $4AD5
    ld [wCamFactoryVo + $8], a                    ; $4AD7
    ld a, [wCamA005Shadow]                        ; $4ADA
    res 7, a                                      ; $4ADD
    ld [wCamFactoryVo + $14], a                   ; $4ADF
    ld a, $e5                                     ; $4AE2
    ld [$a001], a                                 ; $4AE4
    ld [wCamA001Shadow], a                        ; $4AE7
    ld a, $03                                     ; $4AEA
    ld [$a004], a                                 ; $4AEC
    ld [wCamA004Shadow], a                        ; $4AEF
    call Cam_ORegister_SAR_Search                 ; $4AF2
    ld a, [wCamA004Shadow]                        ; $4AF5
    and $07                                       ; $4AF8
    ld [wCamFactoryVo + $9], a                    ; $4AFA
    ld a, [wCamA005Shadow]                        ; $4AFD
    res 7, a                                      ; $4B00
    ld [wCamFactoryVo + $15], a                   ; $4B02
    ld a, $e8                                     ; $4B05
    ld [$a001], a                                 ; $4B07
    ld [wCamA001Shadow], a                        ; $4B0A
    ld a, $32                                     ; $4B0D
    ld [$a002], a                                 ; $4B0F
    ld [wCamExposureShadow], a                    ; $4B12
    xor a                                         ; $4B15
    ld [$a003], a                                 ; $4B16
    ld [wCamExposureShadow + $1], a               ; $4B19
    ld a, $03                                     ; $4B1C
    ld [$a004], a                                 ; $4B1E
    ld [wCamA004Shadow], a                        ; $4B21
    call Cam_ORegister_SAR_Search                 ; $4B24
    ld a, [wCamA004Shadow]                        ; $4B27
    and $07                                       ; $4B2A
    ld [wCamFactoryVo + $a], a                    ; $4B2C
    ld a, [wCamA005Shadow]                        ; $4B2F
    res 7, a                                      ; $4B32
    ld [wCamFactoryVo + $16], a                   ; $4B34
    ld a, $0a                                     ; $4B37
    ld [$a001], a                                 ; $4B39
    ld [wCamA001Shadow], a                        ; $4B3C
    ld a, $80                                     ; $4B3F
    ld [$a002], a                                 ; $4B41
    ld [wCamExposureShadow], a                    ; $4B44
    xor a                                         ; $4B47
    ld [$a003], a                                 ; $4B48
    ld [wCamExposureShadow + $1], a               ; $4B4B
    ld a, $03                                     ; $4B4E
    ld [$a004], a                                 ; $4B50
    ld [wCamA004Shadow], a                        ; $4B53
    call Cam_ORegister_SAR_Search                 ; $4B56
    ld a, [wCamA004Shadow]                        ; $4B59
    and $07                                       ; $4B5C
    ld [wCamFactoryVo + $b], a                    ; $4B5E
    ld a, [wCamA005Shadow]                        ; $4B61
    res 7, a                                      ; $4B64
    ld [wCamFactoryVo + $17], a                   ; $4B66
    ret                                           ; $4B69


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_ORegister_SAR_Search::
    ld a, $10                                     ; $4B6A
    ld [$4000], a                                 ; $4B6C
    xor a                                         ; $4B6F
    ldh [hSarScratch], a                          ; $4B70
    ld a, $bf                                     ; $4B72
    ld [wCamA005Shadow], a                        ; $4B74
    ld [$a005], a                                 ; $4B77

jr_00a_4b7a:
    ld a, [wCamA000Shadow]                        ; $4B7A
    set 0, a                                      ; $4B7D
    ld [$a000], a                                 ; $4B7F

jr_00a_4b82:
    ld a, [$a000]                                 ; $4B82
    bit 0, a                                      ; $4B85
    jr nz, jr_00a_4b82                            ; $4B87

    ld a, $09                                     ; $4B89
    call Cam_PixelTestHelper                      ; $4B8B
    or a                                          ; $4B8E
    jr z, jr_00a_4baf                             ; $4B8F

    ld a, $ff                                     ; $4B91
    ldh [hSarScratch], a                          ; $4B93
    ld a, [wCamA004Shadow]                        ; $4B95
    ld b, a                                       ; $4B98
    and $07                                       ; $4B99
    inc a                                         ; $4B9B
    ld c, a                                       ; $4B9C
    ld a, b                                       ; $4B9D
    and $f8                                       ; $4B9E
    or c                                          ; $4BA0
    ld [$a004], a                                 ; $4BA1
    ld [wCamA004Shadow], a                        ; $4BA4
    and $07                                       ; $4BA7
    cp $07                                        ; $4BA9
    jr z, Cam_ORegister_SAR_Tail                  ; $4BAB

    jr jr_00a_4b7a                                ; $4BAD

jr_00a_4baf:
    ldh a, [hSarScratch]                          ; $4BAF
    cp $ff                                        ; $4BB1
    jr z, Cam_ORegister_SAR_Tail                  ; $4BB3

    ld a, $9f                                     ; $4BB5
    ld [wCamA005Shadow], a                        ; $4BB7
    ld [$a005], a                                 ; $4BBA

jr_00a_4bbd:
    ld a, [wCamA000Shadow]                        ; $4BBD
    set 0, a                                      ; $4BC0
    ld [$a000], a                                 ; $4BC2

jr_00a_4bc5:
    ld a, [$a000]                                 ; $4BC5
    bit 0, a                                      ; $4BC8
    jr nz, jr_00a_4bc5                            ; $4BCA

    ld a, $09                                     ; $4BCC
    call Cam_PixelTestHelper                      ; $4BCE
    or a                                          ; $4BD1
    jr nz, Cam_ORegister_SAR_Tail                 ; $4BD2

    ld a, [wCamA004Shadow]                        ; $4BD4
    ld b, a                                       ; $4BD7
    and $07                                       ; $4BD8
    dec a                                         ; $4BDA
    ld c, a                                       ; $4BDB
    ld a, b                                       ; $4BDC
    and $f8                                       ; $4BDD
    or c                                          ; $4BDF
    ld [$a004], a                                 ; $4BE0
    ld [wCamA004Shadow], a                        ; $4BE3
    and $07                                       ; $4BE6
    cp $01                                        ; $4BE8
    jr nz, jr_00a_4bbd                            ; $4BEA

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_ORegister_SAR_Tail::
    ld a, $a0                                     ; $4BEC
    ld [wCamA005Shadow], a                        ; $4BEE
    ld [$a005], a                                 ; $4BF1
    ld a, $06                                     ; $4BF4
    ldh [hScratchB], a                            ; $4BF6

jr_00a_4bf8:
    ld a, [wCamA000Shadow]                        ; $4BF8
    set 0, a                                      ; $4BFB
    ld [$a000], a                                 ; $4BFD

jr_00a_4c00:
    ld a, [$a000]                                 ; $4C00
    bit 0, a                                      ; $4C03
    jr nz, jr_00a_4c00                            ; $4C05

    ld a, $09                                     ; $4C07
    call Cam_PixelTestHelper                      ; $4C09
    or a                                          ; $4C0C
    jr z, jr_00a_4c14                             ; $4C0D

    ld hl, Cam_ORegSAR_Table_Above                ; $4C0F
    jr jr_00a_4c17                                ; $4C12

jr_00a_4c14:
    ld hl, Cam_ORegSAR_Table_Below                ; $4C14

jr_00a_4c17:
    ld a, [wCamA005Shadow]                        ; $4C17
    and $3f                                       ; $4C1A
    add l                                         ; $4C1C
    ld l, a                                       ; $4C1D
    jr nc, jr_00a_4c21                            ; $4C1E

    inc h                                         ; $4C20

jr_00a_4c21:
    ld a, [hl]                                    ; $4C21
    ld [wCamA005Shadow], a                        ; $4C22
    ld [$a005], a                                 ; $4C25
    ldh a, [hScratchB]                            ; $4C28
    dec a                                         ; $4C2A
    ldh [hScratchB], a                            ; $4C2B
    jr nz, jr_00a_4bf8                            ; $4C2D

    ret                                           ; $4C2F


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_PixelTestHelper::
    ld h, a                                       ; $4C30
    xor a                                         ; $4C31
    ld [$4000], a                                 ; $4C32
    ldh a, [hScratchC]                            ; $4C35
    ld d, a                                       ; $4C37
    ldh a, [hScratchD]                            ; $4C38
    ld e, a                                       ; $4C3A
    ld b, $00                                     ; $4C3B
    ld c, $04                                     ; $4C3D

jr_00a_4c3f:
    ld a, [de]                                    ; $4C3F
    bit 6, a                                      ; $4C40
    jr z, jr_00a_4c45                             ; $4C42

    inc b                                         ; $4C44

jr_00a_4c45:
    bit 5, a                                      ; $4C45
    jr z, jr_00a_4c4a                             ; $4C47

    inc b                                         ; $4C49

jr_00a_4c4a:
    bit 4, a                                      ; $4C4A
    jr z, jr_00a_4c4f                             ; $4C4C

    inc b                                         ; $4C4E

jr_00a_4c4f:
    bit 3, a                                      ; $4C4F
    jr jr_00a_4c54                                ; $4C51

; I: tail piece: B vs H compare; result in A. Dead-code root: nothing calls it; assembled as code tagged unused (owner
; decision 2026-10-26, README 13.6).
Unused_Cam_FactoryMeasure2_Tail::
    inc b                                         ; $4C53

jr_00a_4c54:
    inc de                                        ; $4C54
    inc de                                        ; $4C55
    dec c                                         ; $4C56
    jr nz, jr_00a_4c3f                            ; $4C57

    ld a, b                                       ; $4C59
    sub h                                         ; $4C5A
    jr c, jr_00a_4c65                             ; $4C5B

    ld a, $10                                     ; $4C5D
    ld [$4000], a                                 ; $4C5F
    ld a, $01                                     ; $4C62
    ret                                           ; $4C64


jr_00a_4c65:
    ld a, $10                                     ; $4C65
    ld [$4000], a                                 ; $4C67
    xor a                                         ; $4C6A
    ret                                           ; $4C6B


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryMeasure2::
    ld a, $10                                     ; $4C6C
    ld [$4000], a                                 ; $4C6E
    ld a, $02                                     ; $4C71
    ld [wCamA000Shadow], a                        ; $4C73
    ld a, $20                                     ; $4C76
    ld [$a001], a                                 ; $4C78
    ld [wCamA001Shadow], a                        ; $4C7B
    xor a                                         ; $4C7E
    ld [$a002], a                                 ; $4C7F
    ld [wCamExposureShadow], a                    ; $4C82
    ld a, $10                                     ; $4C85
    ld [$a003], a                                 ; $4C87
    ld [wCamExposureShadow + $1], a               ; $4C8A
    ld a, [wCamFactoryVo]                         ; $4C8D
    ld [$a004], a                                 ; $4C90
    ld [wCamA004Shadow], a                        ; $4C93
    ld a, [wCamFactoryVo + $c]                    ; $4C96
    set 7, a                                      ; $4C99
    ld [$a005], a                                 ; $4C9B
    ld [wCamA005Shadow], a                        ; $4C9E
    call Cam_ThresholdConverge                    ; $4CA1
    ldh a, [hDiffOrValue]                         ; $4CA4
    ld [wCamCalibVector], a                       ; $4CA6
    ld a, $21                                     ; $4CA9
    ld [$a001], a                                 ; $4CAB
    ld [wCamA001Shadow], a                        ; $4CAE
    ld a, [wCamFactoryVo + $1]                    ; $4CB1
    ld [$a004], a                                 ; $4CB4
    ld [wCamA004Shadow], a                        ; $4CB7
    ld a, [wCamFactoryVo + $d]                    ; $4CBA
    set 7, a                                      ; $4CBD
    ld [$a005], a                                 ; $4CBF
    ld [wCamA005Shadow], a                        ; $4CC2
    call Cam_ThresholdConverge                    ; $4CC5
    ldh a, [hDiffOrValue]                         ; $4CC8
    ld [wCamCalibVector + $1], a                  ; $4CCA
    ld a, $22                                     ; $4CCD
    ld [$a001], a                                 ; $4CCF
    ld [wCamA001Shadow], a                        ; $4CD2
    ld a, [wCamFactoryVo + $2]                    ; $4CD5
    ld [$a004], a                                 ; $4CD8
    ld [wCamA004Shadow], a                        ; $4CDB
    ld a, [wCamFactoryVo + $e]                    ; $4CDE
    set 7, a                                      ; $4CE1
    ld [$a005], a                                 ; $4CE3
    ld [wCamA005Shadow], a                        ; $4CE6
    call Cam_ThresholdConverge                    ; $4CE9
    ldh a, [hDiffOrValue]                         ; $4CEC
    ld [wCamCalibVector + $2], a                  ; $4CEE
    ld a, $23                                     ; $4CF1
    ld [$a001], a                                 ; $4CF3
    ld [wCamA001Shadow], a                        ; $4CF6
    ld a, [wCamFactoryVo + $3]                    ; $4CF9
    ld [$a004], a                                 ; $4CFC
    ld [wCamA004Shadow], a                        ; $4CFF
    ld a, [wCamFactoryVo + $f]                    ; $4D02
    set 7, a                                      ; $4D05
    ld [$a005], a                                 ; $4D07
    ld [wCamA005Shadow], a                        ; $4D0A
    call Cam_ThresholdConverge                    ; $4D0D
    ldh a, [hDiffOrValue]                         ; $4D10
    ld [wCamCalibVector + $3], a                  ; $4D12
    ld a, $20                                     ; $4D15
    ld [$a001], a                                 ; $4D17
    ld [wCamA001Shadow], a                        ; $4D1A
    ld a, [wCamFactoryVo + $4]                    ; $4D1D
    or $20                                        ; $4D20
    ld [$a004], a                                 ; $4D22
    ld [wCamA004Shadow], a                        ; $4D25
    ld a, [wCamFactoryVo + $10]                   ; $4D28
    set 7, a                                      ; $4D2B
    ld [$a005], a                                 ; $4D2D
    ld [wCamA005Shadow], a                        ; $4D30
    call Cam_ThresholdConverge                    ; $4D33
    ldh a, [hDiffOrValue]                         ; $4D36
    ld [wCamCalibVector + $4], a                  ; $4D38
    ld a, $21                                     ; $4D3B
    ld [$a001], a                                 ; $4D3D
    ld [wCamA001Shadow], a                        ; $4D40
    ld a, [wCamFactoryVo + $5]                    ; $4D43
    or $20                                        ; $4D46
    ld [$a004], a                                 ; $4D48
    ld [wCamA004Shadow], a                        ; $4D4B
    ld a, [wCamFactoryVo + $11]                   ; $4D4E
    set 7, a                                      ; $4D51
    ld [$a005], a                                 ; $4D53
    ld [wCamA005Shadow], a                        ; $4D56
    call Cam_ThresholdConverge                    ; $4D59
    ldh a, [hDiffOrValue]                         ; $4D5C
    ld [wCamCalibVector + $5], a                  ; $4D5E
    ld a, $22                                     ; $4D61
    ld [$a001], a                                 ; $4D63
    ld [wCamA001Shadow], a                        ; $4D66
    ld a, [wCamFactoryVo + $6]                    ; $4D69
    or $20                                        ; $4D6C
    ld [$a004], a                                 ; $4D6E
    ld [wCamA004Shadow], a                        ; $4D71
    ld a, [wCamFactoryVo + $12]                   ; $4D74
    set 7, a                                      ; $4D77
    ld [$a005], a                                 ; $4D79
    ld [wCamA005Shadow], a                        ; $4D7C
    call Cam_ThresholdConverge                    ; $4D7F
    ldh a, [hDiffOrValue]                         ; $4D82
    ld [wCamCalibVector + $6], a                  ; $4D84
    ld a, $23                                     ; $4D87
    ld [$a001], a                                 ; $4D89
    ld [wCamA001Shadow], a                        ; $4D8C
    ld a, [wCamFactoryVo + $7]                    ; $4D8F
    or $20                                        ; $4D92
    ld [$a004], a                                 ; $4D94
    ld [wCamA004Shadow], a                        ; $4D97
    ld a, [wCamFactoryVo + $13]                   ; $4D9A
    set 7, a                                      ; $4D9D
    ld [$a005], a                                 ; $4D9F
    ld [wCamA005Shadow], a                        ; $4DA2
    call Cam_ThresholdConverge                    ; $4DA5
    ldh a, [hDiffOrValue]                         ; $4DA8
    ld [wCamCalibVector + $7], a                  ; $4DAA
    ld a, $24                                     ; $4DAD
    ld [$a001], a                                 ; $4DAF
    ld [wCamA001Shadow], a                        ; $4DB2
    ld a, [wCamFactoryVo + $8]                    ; $4DB5
    or $20                                        ; $4DB8
    ld [$a004], a                                 ; $4DBA
    ld [wCamA004Shadow], a                        ; $4DBD
    ld a, [wCamFactoryVo + $14]                   ; $4DC0
    set 7, a                                      ; $4DC3
    ld [$a005], a                                 ; $4DC5
    ld [wCamA005Shadow], a                        ; $4DC8
    call Cam_ThresholdConverge                    ; $4DCB
    ldh a, [hDiffOrValue]                         ; $4DCE
    ld [wCamCalibVector + $8], a                  ; $4DD0
    ld a, $25                                     ; $4DD3
    ld [$a001], a                                 ; $4DD5
    ld [wCamA001Shadow], a                        ; $4DD8
    ld a, [wCamFactoryVo + $9]                    ; $4DDB
    or $20                                        ; $4DDE
    ld [$a004], a                                 ; $4DE0
    ld [wCamA004Shadow], a                        ; $4DE3
    ld a, [wCamFactoryVo + $15]                   ; $4DE6
    set 7, a                                      ; $4DE9
    ld [$a005], a                                 ; $4DEB
    ld [wCamA005Shadow], a                        ; $4DEE
    call Cam_ThresholdConverge                    ; $4DF1
    ldh a, [hDiffOrValue]                         ; $4DF4
    ld [wCamCalibVector + $9], a                  ; $4DF6
    ld a, $28                                     ; $4DF9
    ld [$a001], a                                 ; $4DFB
    ld [wCamA001Shadow], a                        ; $4DFE
    ld a, [wCamFactoryVo + $a]                    ; $4E01
    or $20                                        ; $4E04
    ld [$a004], a                                 ; $4E06
    ld [wCamA004Shadow], a                        ; $4E09
    ld a, [wCamFactoryVo + $16]                   ; $4E0C
    set 7, a                                      ; $4E0F
    ld [$a005], a                                 ; $4E11
    ld [wCamA005Shadow], a                        ; $4E14
    call Cam_ThresholdConverge                    ; $4E17
    ldh a, [hDiffOrValue]                         ; $4E1A
    ld [wCamCalibVector + $a], a                  ; $4E1C
    ld a, $0a                                     ; $4E1F
    ld [$a001], a                                 ; $4E21
    ld [wCamA001Shadow], a                        ; $4E24
    ld a, [wCamFactoryVo + $b]                    ; $4E27
    ld [$a004], a                                 ; $4E2A
    ld [wCamA004Shadow], a                        ; $4E2D
    ld a, [wCamFactoryVo + $17]                   ; $4E30
    set 7, a                                      ; $4E33
    ld [$a005], a                                 ; $4E35
    ld [wCamA005Shadow], a                        ; $4E38
    call Cam_ThresholdConverge                    ; $4E3B
    ldh a, [hDiffOrValue]                         ; $4E3E
    ld [wCamCalibVector + $b], a                  ; $4E40
    ret                                           ; $4E43


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_ThresholdConverge::
    ld hl, $a006                                  ; $4E44
    ld de, $0030                                  ; $4E47
    ld a, $80                                     ; $4E4A
    ldh [hDiffOrValue], a                         ; $4E4C
    ld b, a                                       ; $4E4E

jr_00a_4e4f:
    ld [hl], b                                    ; $4E4F
    inc hl                                        ; $4E50
    dec de                                        ; $4E51
    ld a, d                                       ; $4E52
    or e                                          ; $4E53
    jr nz, jr_00a_4e4f                            ; $4E54

    ld a, [wCamA000Shadow]                        ; $4E56
    set 0, a                                      ; $4E59
    ld [$a000], a                                 ; $4E5B

jr_00a_4e5e:
    ld a, [$a000]                                 ; $4E5E
    bit 0, a                                      ; $4E61
    jr nz, jr_00a_4e5e                            ; $4E63

    ld a, $09                                     ; $4E65
    call Cam_PixelTestHelper                      ; $4E67
    and a                                         ; $4E6A
    jp z, Cam_ThresholdConverge_Up                ; $4E6B

jr_00a_4e6e:
    ldh a, [hDiffOrValue]                         ; $4E6E
    dec a                                         ; $4E70
    ldh [hDiffOrValue], a                         ; $4E71
    cp $01                                        ; $4E73
    jr z, jr_00a_4e9e                             ; $4E75

    ld hl, $a006                                  ; $4E77
    ld de, $0030                                  ; $4E7A
    ldh a, [hDiffOrValue]                         ; $4E7D
    ld b, a                                       ; $4E7F

jr_00a_4e80:
    ld [hl], b                                    ; $4E80
    inc hl                                        ; $4E81
    dec de                                        ; $4E82
    ld a, d                                       ; $4E83
    or e                                          ; $4E84
    jr nz, jr_00a_4e80                            ; $4E85

    ld a, [wCamA000Shadow]                        ; $4E87
    set 0, a                                      ; $4E8A
    ld [$a000], a                                 ; $4E8C

jr_00a_4e8f:
    ld a, [$a000]                                 ; $4E8F
    bit 0, a                                      ; $4E92
    jr nz, jr_00a_4e8f                            ; $4E94

    ld a, $09                                     ; $4E96
    call Cam_PixelTestHelper                      ; $4E98
    and a                                         ; $4E9B
    jr nz, jr_00a_4e6e                            ; $4E9C

jr_00a_4e9e:
    ldh a, [hDiffOrValue]                         ; $4E9E
    ldh [hPrevOrSign], a                          ; $4EA0

jr_00a_4ea2:
    ldh a, [hDiffOrValue]                         ; $4EA2
    dec a                                         ; $4EA4
    ldh [hDiffOrValue], a                         ; $4EA5
    jr z, jr_00a_4ed0                             ; $4EA7

    ld hl, $a006                                  ; $4EA9
    ld de, $0030                                  ; $4EAC
    ldh a, [hDiffOrValue]                         ; $4EAF
    ld b, a                                       ; $4EB1

jr_00a_4eb2:
    ld [hl], b                                    ; $4EB2
    inc hl                                        ; $4EB3
    dec de                                        ; $4EB4
    ld a, d                                       ; $4EB5
    or e                                          ; $4EB6
    jr nz, jr_00a_4eb2                            ; $4EB7

    ld a, [wCamA000Shadow]                        ; $4EB9
    set 0, a                                      ; $4EBC
    ld [$a000], a                                 ; $4EBE

jr_00a_4ec1:
    ld a, [$a000]                                 ; $4EC1
    bit 0, a                                      ; $4EC4
    jr nz, jr_00a_4ec1                            ; $4EC6

    ld a, $08                                     ; $4EC8
    call Cam_PixelTestHelper                      ; $4ECA
    and a                                         ; $4ECD
    jr nz, jr_00a_4ea2                            ; $4ECE

jr_00a_4ed0:
    ldh a, [hDiffOrValue]                         ; $4ED0
    ld c, a                                       ; $4ED2
    ld b, $00                                     ; $4ED3
    ldh a, [hPrevOrSign]                          ; $4ED5
    ld l, a                                       ; $4ED7
    ld h, $00                                     ; $4ED8
    add hl, bc                                    ; $4EDA
    srl h                                         ; $4EDB
    rr l                                          ; $4EDD
    ld a, l                                       ; $4EDF
    ldh [hDiffOrValue], a                         ; $4EE0
    ret                                           ; $4EE2


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_ThresholdConverge_Up::
    ldh a, [hDiffOrValue]                         ; $4EE3
    inc a                                         ; $4EE5
    ldh [hDiffOrValue], a                         ; $4EE6
    cp $ff                                        ; $4EE8
    jr z, jr_00a_4f13                             ; $4EEA

    ld hl, $a006                                  ; $4EEC
    ld de, $0030                                  ; $4EEF
    ldh a, [hDiffOrValue]                         ; $4EF2
    ld b, a                                       ; $4EF4

jr_00a_4ef5:
    ld [hl], b                                    ; $4EF5
    inc hl                                        ; $4EF6
    dec de                                        ; $4EF7
    ld a, d                                       ; $4EF8
    or e                                          ; $4EF9
    jr nz, jr_00a_4ef5                            ; $4EFA

    ld a, [wCamA000Shadow]                        ; $4EFC
    set 0, a                                      ; $4EFF
    ld [$a000], a                                 ; $4F01

jr_00a_4f04:
    ld a, [$a000]                                 ; $4F04
    bit 0, a                                      ; $4F07
    jr nz, jr_00a_4f04                            ; $4F09

    ld a, $09                                     ; $4F0B
    call Cam_PixelTestHelper                      ; $4F0D
    and a                                         ; $4F10
    jr z, Cam_ThresholdConverge_Up                ; $4F11

jr_00a_4f13:
    ldh a, [hDiffOrValue]                         ; $4F13
    ldh [hPrevOrSign], a                          ; $4F15

jr_00a_4f17:
    ldh a, [hDiffOrValue]                         ; $4F17
    dec a                                         ; $4F19
    ldh [hDiffOrValue], a                         ; $4F1A
    jr z, jr_00a_4f45                             ; $4F1C

    ld hl, $a006                                  ; $4F1E
    ld de, $0030                                  ; $4F21
    ldh a, [hDiffOrValue]                         ; $4F24
    ld b, a                                       ; $4F26

jr_00a_4f27:
    ld [hl], b                                    ; $4F27
    inc hl                                        ; $4F28
    dec de                                        ; $4F29
    ld a, d                                       ; $4F2A
    or e                                          ; $4F2B
    jr nz, jr_00a_4f27                            ; $4F2C

    ld a, [wCamA000Shadow]                        ; $4F2E
    set 0, a                                      ; $4F31
    ld [$a000], a                                 ; $4F33

jr_00a_4f36:
    ld a, [$a000]                                 ; $4F36
    bit 0, a                                      ; $4F39
    jr nz, jr_00a_4f36                            ; $4F3B

    ld a, $08                                     ; $4F3D
    call Cam_PixelTestHelper                      ; $4F3F
    and a                                         ; $4F42
    jr nz, jr_00a_4f17                            ; $4F43

jr_00a_4f45:
    ldh a, [hDiffOrValue]                         ; $4F45
    ld c, a                                       ; $4F47
    ld b, $00                                     ; $4F48
    ldh a, [hPrevOrSign]                          ; $4F4A
    ld l, a                                       ; $4F4C
    ld h, $00                                     ; $4F4D
    add hl, bc                                    ; $4F4F
    srl h                                         ; $4F50
    rr l                                          ; $4F52
    ld a, l                                       ; $4F54
    ldh [hDiffOrValue], a                         ; $4F55
    ret                                           ; $4F57


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_CommitVectorToSRAM::
    ld a, $0a                                     ; $4F58
    ld [$0000], a                                 ; $4F5A
    ld a, $02                                     ; $4F5D
    ld [$4000], a                                 ; $4F5F
    ld hl, $aff2                                  ; $4F62
    ld de, wCamCalibVector                        ; $4F65
    ld b, $00                                     ; $4F68
    ld c, $00                                     ; $4F6A
    ld a, $0c                                     ; $4F6C
    ldh [hScratchA], a                            ; $4F6E

jr_00a_4f70:
    ld a, [de]                                    ; $4F70
    inc de                                        ; $4F71
    ld [hl+], a                                   ; $4F72
    ldh [hScratchB], a                            ; $4F73
    add b                                         ; $4F75
    ld b, a                                       ; $4F76
    ldh a, [hScratchB]                            ; $4F77
    xor c                                         ; $4F79
    ld c, a                                       ; $4F7A
    ldh a, [hScratchA]                            ; $4F7B
    dec a                                         ; $4F7D
    ldh [hScratchA], a                            ; $4F7E
    jr nz, jr_00a_4f70                            ; $4F80

    ld a, b                                       ; $4F82
    add $0d                                       ; $4F83
    ld [hl+], a                                   ; $4F85
    ld a, c                                       ; $4F86
    add $23                                       ; $4F87
    ld [hl], a                                    ; $4F89
    ld a, $08                                     ; $4F8A
    ld [$4000], a                                 ; $4F8C
    ld hl, $bff2                                  ; $4F8F
    ld de, wCamCalibVector                        ; $4F92
    ld b, $00                                     ; $4F95
    ld c, $00                                     ; $4F97
    ld a, $0c                                     ; $4F99
    ldh [hScratchA], a                            ; $4F9B

jr_00a_4f9d:
    ld a, [de]                                    ; $4F9D
    inc de                                        ; $4F9E
    ld [hl+], a                                   ; $4F9F
    ldh [hScratchB], a                            ; $4FA0
    add b                                         ; $4FA2
    ld b, a                                       ; $4FA3
    ldh a, [hScratchB]                            ; $4FA4
    xor c                                         ; $4FA6
    ld c, a                                       ; $4FA7
    ldh a, [hScratchA]                            ; $4FA8
    dec a                                         ; $4FAA
    ldh [hScratchA], a                            ; $4FAB
    jr nz, jr_00a_4f9d                            ; $4FAD

    ld a, b                                       ; $4FAF
    add $0d                                       ; $4FB0
    ld [hl+], a                                   ; $4FB2
    ld a, c                                       ; $4FB3
    add $23                                       ; $4FB4
    ld [hl], a                                    ; $4FB6
    ld a, $00                                     ; $4FB7
    ld [$0000], a                                 ; $4FB9
    ret                                           ; $4FBC


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_PopcountSampleLoop::
    ld a, $0a                                     ; $4FBD
    ldh [hScratchA], a                            ; $4FBF

jr_00a_4fc1:
    call Cam_PopcountSampleLoop_inner             ; $4FC1
    ld hl, $0014                                  ; $4FC4
    add hl, de                                    ; $4FC7
    ld d, h                                       ; $4FC8
    ld e, l                                       ; $4FC9
    call Cam_PopcountSampleLoop_inner             ; $4FCA
    ld hl, $0014                                  ; $4FCD
    add hl, de                                    ; $4FD0
    ld d, h                                       ; $4FD1
    ld e, l                                       ; $4FD2
    call Cam_PopcountSampleLoop_inner             ; $4FD3
    ld hl, $0004                                  ; $4FD6
    add hl, de                                    ; $4FD9
    ld d, h                                       ; $4FDA
    ld e, l                                       ; $4FDB
    call Cam_PopcountSampleLoop_inner             ; $4FDC
    ld hl, $0014                                  ; $4FDF
    add hl, de                                    ; $4FE2
    ld d, h                                       ; $4FE3
    ld e, l                                       ; $4FE4
    call Cam_PopcountSampleLoop_inner             ; $4FE5
    ld hl, $0014                                  ; $4FE8
    add hl, de                                    ; $4FEB
    ld d, h                                       ; $4FEC
    ld e, l                                       ; $4FED
    call Cam_PopcountSampleLoop_inner             ; $4FEE
    ld hl, $0004                                  ; $4FF1
    add hl, de                                    ; $4FF4
    ld d, h                                       ; $4FF5
    ld e, l                                       ; $4FF6
    call Cam_PopcountSampleLoop_inner             ; $4FF7
    ld hl, $0014                                  ; $4FFA
    add hl, de                                    ; $4FFD
    ld d, h                                       ; $4FFE
    ld e, l                                       ; $4FFF
    call Cam_PopcountSampleLoop_inner             ; $5000
    ld hl, $0004                                  ; $5003
    add hl, de                                    ; $5006
    ld d, h                                       ; $5007
    ld e, l                                       ; $5008
    call Cam_PopcountSampleLoop_inner             ; $5009
    ld hl, $0014                                  ; $500C
    add hl, de                                    ; $500F
    ld d, h                                       ; $5010
    ld e, l                                       ; $5011
    call Cam_PopcountSampleLoop_inner             ; $5012
    ld hl, $0014                                  ; $5015
    add hl, de                                    ; $5018
    ld d, h                                       ; $5019
    ld e, l                                       ; $501A
    call Cam_PopcountSampleLoop_inner             ; $501B
    ld hl, $0004                                  ; $501E
    add hl, de                                    ; $5021
    ld d, h                                       ; $5022
    ld e, l                                       ; $5023
    call Cam_PopcountSampleLoop_inner             ; $5024
    ld hl, $004f                                  ; $5027
    add hl, de                                    ; $502A
    ld d, h                                       ; $502B
    ld e, l                                       ; $502C
    ldh a, [hScratchA]                            ; $502D
    dec a                                         ; $502F
    jr z, jr_00a_5036                             ; $5030

    ldh [hScratchA], a                            ; $5032
    jr jr_00a_4fc1                                ; $5034

jr_00a_5036:
    sla c                                         ; $5036
    rl b                                          ; $5038
    ld de, $a540                                  ; $503A
    ld a, $06                                     ; $503D
    ldh [hScratchA], a                            ; $503F

jr_00a_5041:
    call Cam_PopcountSampleLoop_inner             ; $5041
    ld hl, $0014                                  ; $5044
    add hl, de                                    ; $5047
    ld d, h                                       ; $5048
    ld e, l                                       ; $5049
    call Cam_PopcountSampleLoop_inner             ; $504A
    ld hl, $0014                                  ; $504D
    add hl, de                                    ; $5050
    ld d, h                                       ; $5051
    ld e, l                                       ; $5052
    call Cam_PopcountSampleLoop_inner             ; $5053
    ld hl, $0004                                  ; $5056
    add hl, de                                    ; $5059
    ld d, h                                       ; $505A
    ld e, l                                       ; $505B
    call Cam_PopcountSampleLoop_inner             ; $505C
    ld hl, $0014                                  ; $505F
    add hl, de                                    ; $5062
    ld d, h                                       ; $5063
    ld e, l                                       ; $5064
    call Cam_PopcountSampleLoop_inner             ; $5065
    ld hl, $0014                                  ; $5068
    add hl, de                                    ; $506B
    ld d, h                                       ; $506C
    ld e, l                                       ; $506D
    call Cam_PopcountSampleLoop_inner             ; $506E
    ld hl, $0004                                  ; $5071
    add hl, de                                    ; $5074
    ld d, h                                       ; $5075
    ld e, l                                       ; $5076
    call Cam_PopcountSampleLoop_inner             ; $5077
    ld hl, $0014                                  ; $507A
    add hl, de                                    ; $507D
    ld d, h                                       ; $507E
    ld e, l                                       ; $507F
    call Cam_PopcountSampleLoop_inner             ; $5080
    ld hl, $0084                                  ; $5083
    add hl, de                                    ; $5086
    ld d, h                                       ; $5087
    ld e, l                                       ; $5088
    ldh a, [hScratchA]                            ; $5089
    dec a                                         ; $508B
    ret z                                         ; $508C

    ldh [hScratchA], a                            ; $508D
    jr jr_00a_5041                                ; $508F

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_PopcountSampleLoop_inner::
    ld h, $73                                     ; $5091
    ld a, [de]                                    ; $5093
    inc de                                        ; $5094
    ld l, a                                       ; $5095
    ld l, [hl]                                    ; $5096
    ld h, $00                                     ; $5097
    add hl, bc                                    ; $5099
    ld b, h                                       ; $509A
    ld c, l                                       ; $509B
    ld h, $73                                     ; $509C
    ld a, [de]                                    ; $509E
    inc de                                        ; $509F
    ld l, a                                       ; $50A0
    ld l, [hl]                                    ; $50A1
    sla l                                         ; $50A2
    ld h, $00                                     ; $50A4
    add hl, bc                                    ; $50A6
    ld b, h                                       ; $50A7
    ld c, l                                       ; $50A8
    ret                                           ; $50A9


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_LiveInit::
    call Cam_ExposureBandSelect                   ; $50AA
    ld a, $10                                     ; $50AD
    ld [$4000], a                                 ; $50AF
    ld a, $02                                     ; $50B2
    ld [wCamA000Shadow], a                        ; $50B4
    ld a, [wCamGainAlt]                           ; $50B7
    ld [wCamGainSel], a                           ; $50BA
    or $e0                                        ; $50BD
    ld [$a001], a                                 ; $50BF
    ld [wCamA001Shadow], a                        ; $50C2
    ld a, $10                                     ; $50C5
    ld [$a002], a                                 ; $50C7
    ld [wCamExposureShadow], a                    ; $50CA
    xor a                                         ; $50CD
    ld [$a003], a                                 ; $50CE
    ld [wCamExposureShadow + $1], a               ; $50D1
    ld a, [wCamBootV + $2]                        ; $50D4
    ld [$a004], a                                 ; $50D7
    ld [wCamA004Shadow], a                        ; $50DA
    ld a, [wCamBootO + $2]                        ; $50DD
    set 7, a                                      ; $50E0
    ld [$a005], a                                 ; $50E2
    ld [wCamA005Shadow], a                        ; $50E5
    ld a, $54                                     ; $50E8
    ld [wCamBrightnessSetpoint], a                ; $50EA
    ld a, $01                                     ; $50ED
    ld [wCamDitherMode], a                        ; $50EF
    ld a, $08                                     ; $50F2
    ld [wCamContrastRow], a                       ; $50F4
    ld c, a                                       ; $50F7
    ld a, [wCamGainSel]                           ; $50F8
    ld b, a                                       ; $50FB
    call Cam_BuildDitherMatrix                    ; $50FC
    ret                                           ; $50FF


; C: copies 8 bytes per row; B tile rows from HL to DE
Cam_CopyTileRows::
    ld a, [hl+]                                   ; $5100
    ld [de], a                                    ; $5101
    inc e                                         ; $5102
    ld a, [hl+]                                   ; $5103
    ld [de], a                                    ; $5104
    inc e                                         ; $5105
    ld a, [hl+]                                   ; $5106
    ld [de], a                                    ; $5107
    inc e                                         ; $5108
    ld a, [hl+]                                   ; $5109
    ld [de], a                                    ; $510A
    inc e                                         ; $510B
    ld a, [hl+]                                   ; $510C
    ld [de], a                                    ; $510D
    inc e                                         ; $510E
    ld a, [hl+]                                   ; $510F
    ld [de], a                                    ; $5110
    inc e                                         ; $5111
    ld a, [hl+]                                   ; $5112
    ld [de], a                                    ; $5113
    inc e                                         ; $5114
    ld a, [hl+]                                   ; $5115
    ld [de], a                                    ; $5116
    inc e                                         ; $5117
    ld a, [hl+]                                   ; $5118
    ld [de], a                                    ; $5119
    inc e                                         ; $511A
    ld a, [hl+]                                   ; $511B
    ld [de], a                                    ; $511C
    inc e                                         ; $511D
    ld a, [hl+]                                   ; $511E
    ld [de], a                                    ; $511F
    inc e                                         ; $5120
    ld a, [hl+]                                   ; $5121
    ld [de], a                                    ; $5122
    inc e                                         ; $5123
    ld a, [hl+]                                   ; $5124
    ld [de], a                                    ; $5125
    inc e                                         ; $5126
    ld a, [hl+]                                   ; $5127
    ld [de], a                                    ; $5128
    inc e                                         ; $5129
    ld a, [hl+]                                   ; $512A
    ld [de], a                                    ; $512B
    inc e                                         ; $512C
    ld a, [hl+]                                   ; $512D
    ld [de], a                                    ; $512E
    inc e                                         ; $512F
    ld a, [hl+]                                   ; $5130
    ld [de], a                                    ; $5131
    inc e                                         ; $5132
    ld a, [hl+]                                   ; $5133
    ld [de], a                                    ; $5134
    inc e                                         ; $5135
    ld a, [hl+]                                   ; $5136
    ld [de], a                                    ; $5137
    inc e                                         ; $5138
    ld a, [hl+]                                   ; $5139
    ld [de], a                                    ; $513A
    inc e                                         ; $513B
    ld a, [hl+]                                   ; $513C
    ld [de], a                                    ; $513D
    inc e                                         ; $513E
    ld a, [hl+]                                   ; $513F
    ld [de], a                                    ; $5140
    inc e                                         ; $5141
    ld a, [hl+]                                   ; $5142
    ld [de], a                                    ; $5143
    inc e                                         ; $5144
    ld a, [hl+]                                   ; $5145
    ld [de], a                                    ; $5146
    inc e                                         ; $5147
    ld a, [hl+]                                   ; $5148
    ld [de], a                                    ; $5149
    inc e                                         ; $514A
    ld a, [hl+]                                   ; $514B
    ld [de], a                                    ; $514C
    inc e                                         ; $514D
    ld a, [hl+]                                   ; $514E
    ld [de], a                                    ; $514F
    inc e                                         ; $5150
    ld a, [hl+]                                   ; $5151
    ld [de], a                                    ; $5152
    inc e                                         ; $5153
    ld a, [hl+]                                   ; $5154
    ld [de], a                                    ; $5155
    inc e                                         ; $5156
    ld a, [hl+]                                   ; $5157
    ld [de], a                                    ; $5158
    inc e                                         ; $5159
    ld a, [hl+]                                   ; $515A
    ld [de], a                                    ; $515B
    inc e                                         ; $515C
    ld a, [hl+]                                   ; $515D
    ld [de], a                                    ; $515E
    inc e                                         ; $515F
    ld a, [hl+]                                   ; $5160
    ld [de], a                                    ; $5161
    inc e                                         ; $5162
    ld a, [hl+]                                   ; $5163
    ld [de], a                                    ; $5164
    inc e                                         ; $5165
    ld a, [hl+]                                   ; $5166
    ld [de], a                                    ; $5167
    inc e                                         ; $5168
    ld a, [hl+]                                   ; $5169
    ld [de], a                                    ; $516A
    inc e                                         ; $516B
    ld a, [hl+]                                   ; $516C
    ld [de], a                                    ; $516D
    inc e                                         ; $516E
    ld a, [hl+]                                   ; $516F
    ld [de], a                                    ; $5170
    inc e                                         ; $5171
    ld a, [hl+]                                   ; $5172
    ld [de], a                                    ; $5173
    inc e                                         ; $5174
    ld a, [hl+]                                   ; $5175
    ld [de], a                                    ; $5176
    inc e                                         ; $5177
    ld a, [hl+]                                   ; $5178
    ld [de], a                                    ; $5179
    inc e                                         ; $517A
    ld a, [hl+]                                   ; $517B
    ld [de], a                                    ; $517C
    inc e                                         ; $517D
    ld a, [hl+]                                   ; $517E
    ld [de], a                                    ; $517F
    inc e                                         ; $5180
    ld a, [hl+]                                   ; $5181
    ld [de], a                                    ; $5182
    inc e                                         ; $5183
    ld a, [hl+]                                   ; $5184
    ld [de], a                                    ; $5185
    inc e                                         ; $5186
    ld a, [hl+]                                   ; $5187
    ld [de], a                                    ; $5188
    inc e                                         ; $5189
    ld a, [hl+]                                   ; $518A
    ld [de], a                                    ; $518B
    inc e                                         ; $518C
    ld a, [hl+]                                   ; $518D
    ld [de], a                                    ; $518E
    inc e                                         ; $518F
    ld a, [hl+]                                   ; $5190
    ld [de], a                                    ; $5191
    inc e                                         ; $5192
    ld a, [hl+]                                   ; $5193
    ld [de], a                                    ; $5194
    inc e                                         ; $5195
    ld a, [hl+]                                   ; $5196
    ld [de], a                                    ; $5197
    inc e                                         ; $5198
    ld a, [hl+]                                   ; $5199
    ld [de], a                                    ; $519A
    inc e                                         ; $519B
    ld a, [hl+]                                   ; $519C
    ld [de], a                                    ; $519D
    inc e                                         ; $519E
    ld a, [hl+]                                   ; $519F
    ld [de], a                                    ; $51A0
    inc e                                         ; $51A1
    ld a, [hl+]                                   ; $51A2
    ld [de], a                                    ; $51A3
    inc e                                         ; $51A4
    ld a, [hl+]                                   ; $51A5
    ld [de], a                                    ; $51A6
    inc e                                         ; $51A7
    ld a, [hl+]                                   ; $51A8
    ld [de], a                                    ; $51A9
    inc e                                         ; $51AA
    ld a, [hl+]                                   ; $51AB
    ld [de], a                                    ; $51AC
    inc e                                         ; $51AD
    ld a, [hl+]                                   ; $51AE
    ld [de], a                                    ; $51AF
    inc e                                         ; $51B0
    ld a, [hl+]                                   ; $51B1
    ld [de], a                                    ; $51B2
    inc e                                         ; $51B3
    ld a, [hl+]                                   ; $51B4
    ld [de], a                                    ; $51B5
    inc e                                         ; $51B6
    ld a, [hl+]                                   ; $51B7
    ld [de], a                                    ; $51B8
    inc e                                         ; $51B9
    ld a, [hl+]                                   ; $51BA
    ld [de], a                                    ; $51BB
    inc e                                         ; $51BC
    ld a, [hl+]                                   ; $51BD
    ld [de], a                                    ; $51BE
    inc e                                         ; $51BF
    ld a, [hl+]                                   ; $51C0
    ld [de], a                                    ; $51C1
    inc e                                         ; $51C2
    ld a, [hl+]                                   ; $51C3
    ld [de], a                                    ; $51C4
    inc e                                         ; $51C5
    ld a, [hl+]                                   ; $51C6
    ld [de], a                                    ; $51C7
    inc e                                         ; $51C8
    ld a, [hl+]                                   ; $51C9
    ld [de], a                                    ; $51CA
    inc e                                         ; $51CB
    ld a, [hl+]                                   ; $51CC
    ld [de], a                                    ; $51CD
    inc e                                         ; $51CE
    ld a, [hl+]                                   ; $51CF
    ld [de], a                                    ; $51D0
    inc e                                         ; $51D1
    ld a, [hl+]                                   ; $51D2
    ld [de], a                                    ; $51D3
    inc e                                         ; $51D4
    ld a, [hl+]                                   ; $51D5
    ld [de], a                                    ; $51D6
    inc e                                         ; $51D7
    ld a, [hl+]                                   ; $51D8
    ld [de], a                                    ; $51D9
    inc e                                         ; $51DA
    ld a, [hl+]                                   ; $51DB
    ld [de], a                                    ; $51DC
    inc e                                         ; $51DD
    ld a, [hl+]                                   ; $51DE
    ld [de], a                                    ; $51DF
    inc e                                         ; $51E0
    ld a, [hl+]                                   ; $51E1
    ld [de], a                                    ; $51E2
    inc e                                         ; $51E3
    ld a, [hl+]                                   ; $51E4
    ld [de], a                                    ; $51E5
    inc e                                         ; $51E6
    ld a, [hl+]                                   ; $51E7
    ld [de], a                                    ; $51E8
    inc e                                         ; $51E9
    ld a, [hl+]                                   ; $51EA
    ld [de], a                                    ; $51EB
    inc e                                         ; $51EC
    ld a, [hl+]                                   ; $51ED
    ld [de], a                                    ; $51EE
    inc e                                         ; $51EF
    ld a, [hl+]                                   ; $51F0
    ld [de], a                                    ; $51F1
    inc e                                         ; $51F2
    ld a, [hl+]                                   ; $51F3
    ld [de], a                                    ; $51F4
    inc e                                         ; $51F5
    ld a, [hl+]                                   ; $51F6
    ld [de], a                                    ; $51F7
    inc e                                         ; $51F8
    ld a, [hl+]                                   ; $51F9
    ld [de], a                                    ; $51FA
    inc e                                         ; $51FB
    ld a, [hl+]                                   ; $51FC
    ld [de], a                                    ; $51FD
    inc e                                         ; $51FE
    ld a, [hl+]                                   ; $51FF
    ld [de], a                                    ; $5200
    inc e                                         ; $5201
    ld a, [hl+]                                   ; $5202
    ld [de], a                                    ; $5203
    inc e                                         ; $5204
    ld a, [hl+]                                   ; $5205
    ld [de], a                                    ; $5206
    inc e                                         ; $5207
    ld a, [hl+]                                   ; $5208
    ld [de], a                                    ; $5209
    inc e                                         ; $520A
    ld a, [hl+]                                   ; $520B
    ld [de], a                                    ; $520C
    inc e                                         ; $520D
    ld a, [hl+]                                   ; $520E
    ld [de], a                                    ; $520F
    inc e                                         ; $5210
    ld a, [hl+]                                   ; $5211
    ld [de], a                                    ; $5212
    inc e                                         ; $5213
    ld a, [hl+]                                   ; $5214
    ld [de], a                                    ; $5215
    inc e                                         ; $5216
    ld a, [hl+]                                   ; $5217
    ld [de], a                                    ; $5218
    inc e                                         ; $5219
    ld a, [hl+]                                   ; $521A
    ld [de], a                                    ; $521B
    inc e                                         ; $521C
    ld a, [hl+]                                   ; $521D
    ld [de], a                                    ; $521E
    inc e                                         ; $521F
    ld a, [hl+]                                   ; $5220
    ld [de], a                                    ; $5221
    inc e                                         ; $5222
    ld a, [hl+]                                   ; $5223
    ld [de], a                                    ; $5224
    inc e                                         ; $5225
    ld a, [hl+]                                   ; $5226
    ld [de], a                                    ; $5227
    inc e                                         ; $5228
    ld a, [hl+]                                   ; $5229
    ld [de], a                                    ; $522A
    inc e                                         ; $522B
    ld a, [hl+]                                   ; $522C
    ld [de], a                                    ; $522D
    inc e                                         ; $522E
    ld a, [hl+]                                   ; $522F
    ld [de], a                                    ; $5230
    inc e                                         ; $5231
    ld a, [hl+]                                   ; $5232
    ld [de], a                                    ; $5233
    inc e                                         ; $5234
    ld a, [hl+]                                   ; $5235
    ld [de], a                                    ; $5236
    inc e                                         ; $5237
    ld a, [hl+]                                   ; $5238
    ld [de], a                                    ; $5239
    inc e                                         ; $523A
    ld a, [hl+]                                   ; $523B
    ld [de], a                                    ; $523C
    inc e                                         ; $523D
    ld a, [hl+]                                   ; $523E
    ld [de], a                                    ; $523F
    inc e                                         ; $5240
    ld a, [hl+]                                   ; $5241
    ld [de], a                                    ; $5242
    inc e                                         ; $5243
    ld a, [hl+]                                   ; $5244
    ld [de], a                                    ; $5245
    inc e                                         ; $5246
    ld a, [hl+]                                   ; $5247
    ld [de], a                                    ; $5248
    inc e                                         ; $5249
    ld a, [hl+]                                   ; $524A
    ld [de], a                                    ; $524B
    inc e                                         ; $524C
    ld a, [hl+]                                   ; $524D
    ld [de], a                                    ; $524E
    inc e                                         ; $524F
    ld a, [hl+]                                   ; $5250
    ld [de], a                                    ; $5251
    inc e                                         ; $5252
    ld a, [hl+]                                   ; $5253
    ld [de], a                                    ; $5254
    inc e                                         ; $5255
    ld a, [hl+]                                   ; $5256
    ld [de], a                                    ; $5257
    inc e                                         ; $5258
    ld a, [hl+]                                   ; $5259
    ld [de], a                                    ; $525A
    inc e                                         ; $525B
    ld a, [hl+]                                   ; $525C
    ld [de], a                                    ; $525D
    inc e                                         ; $525E
    ld a, [hl+]                                   ; $525F
    ld [de], a                                    ; $5260
    inc e                                         ; $5261
    ld a, [hl+]                                   ; $5262
    ld [de], a                                    ; $5263
    inc e                                         ; $5264
    ld a, [hl+]                                   ; $5265
    ld [de], a                                    ; $5266
    inc e                                         ; $5267
    ld a, [hl+]                                   ; $5268
    ld [de], a                                    ; $5269
    inc e                                         ; $526A
    ld a, [hl+]                                   ; $526B
    ld [de], a                                    ; $526C
    inc e                                         ; $526D
    ld a, [hl+]                                   ; $526E
    ld [de], a                                    ; $526F
    inc e                                         ; $5270
    ld a, [hl+]                                   ; $5271
    ld [de], a                                    ; $5272
    inc e                                         ; $5273
    ld a, [hl+]                                   ; $5274
    ld [de], a                                    ; $5275
    inc e                                         ; $5276
    ld a, [hl+]                                   ; $5277
    ld [de], a                                    ; $5278
    inc e                                         ; $5279
    ld a, [hl+]                                   ; $527A
    ld [de], a                                    ; $527B
    inc e                                         ; $527C
    ld a, [hl+]                                   ; $527D
    ld [de], a                                    ; $527E
    inc e                                         ; $527F
    ld a, [hl+]                                   ; $5280
    ld [de], a                                    ; $5281
    inc e                                         ; $5282
    ld a, [hl+]                                   ; $5283
    ld [de], a                                    ; $5284
    inc e                                         ; $5285
    ld a, [hl+]                                   ; $5286
    ld [de], a                                    ; $5287
    inc e                                         ; $5288
    ld a, [hl+]                                   ; $5289
    ld [de], a                                    ; $528A
    inc e                                         ; $528B
    ld a, [hl+]                                   ; $528C
    ld [de], a                                    ; $528D
    inc e                                         ; $528E
    ld a, [hl+]                                   ; $528F
    ld [de], a                                    ; $5290
    inc e                                         ; $5291
    ld a, [hl+]                                   ; $5292
    ld [de], a                                    ; $5293
    inc e                                         ; $5294
    ld a, [hl+]                                   ; $5295
    ld [de], a                                    ; $5296
    inc e                                         ; $5297
    ld a, [hl+]                                   ; $5298
    ld [de], a                                    ; $5299
    inc e                                         ; $529A
    ld a, [hl+]                                   ; $529B
    ld [de], a                                    ; $529C
    inc e                                         ; $529D
    ld a, [hl+]                                   ; $529E
    ld [de], a                                    ; $529F
    inc e                                         ; $52A0
    ld a, [hl+]                                   ; $52A1
    ld [de], a                                    ; $52A2
    inc e                                         ; $52A3
    ld a, [hl+]                                   ; $52A4
    ld [de], a                                    ; $52A5
    inc e                                         ; $52A6
    ld a, [hl+]                                   ; $52A7
    ld [de], a                                    ; $52A8
    inc e                                         ; $52A9
    ld a, [hl+]                                   ; $52AA
    ld [de], a                                    ; $52AB
    inc e                                         ; $52AC
    ld a, [hl+]                                   ; $52AD
    ld [de], a                                    ; $52AE
    inc e                                         ; $52AF
    ld a, [hl+]                                   ; $52B0
    ld [de], a                                    ; $52B1
    inc e                                         ; $52B2
    ld a, [hl+]                                   ; $52B3
    ld [de], a                                    ; $52B4
    inc e                                         ; $52B5
    ld a, [hl+]                                   ; $52B6
    ld [de], a                                    ; $52B7
    inc e                                         ; $52B8
    ld a, [hl+]                                   ; $52B9
    ld [de], a                                    ; $52BA
    inc e                                         ; $52BB
    ld a, [hl+]                                   ; $52BC
    ld [de], a                                    ; $52BD
    inc e                                         ; $52BE
    ld a, [hl+]                                   ; $52BF
    ld [de], a                                    ; $52C0
    inc e                                         ; $52C1
    ld a, [hl+]                                   ; $52C2
    ld [de], a                                    ; $52C3
    inc e                                         ; $52C4
    ld a, [hl+]                                   ; $52C5
    ld [de], a                                    ; $52C6
    inc e                                         ; $52C7
    ld a, [hl+]                                   ; $52C8
    ld [de], a                                    ; $52C9
    inc e                                         ; $52CA
    ld a, [hl+]                                   ; $52CB
    ld [de], a                                    ; $52CC
    inc e                                         ; $52CD
    ld a, [hl+]                                   ; $52CE
    ld [de], a                                    ; $52CF
    inc e                                         ; $52D0
    ld a, [hl+]                                   ; $52D1
    ld [de], a                                    ; $52D2
    inc e                                         ; $52D3
    ld a, [hl+]                                   ; $52D4
    ld [de], a                                    ; $52D5
    inc e                                         ; $52D6
    ld a, [hl+]                                   ; $52D7
    ld [de], a                                    ; $52D8
    inc e                                         ; $52D9
    ld a, [hl+]                                   ; $52DA
    ld [de], a                                    ; $52DB
    inc e                                         ; $52DC
    ld a, [hl+]                                   ; $52DD
    ld [de], a                                    ; $52DE
    inc e                                         ; $52DF
    ld a, [hl+]                                   ; $52E0
    ld [de], a                                    ; $52E1
    inc e                                         ; $52E2
    ld a, [hl+]                                   ; $52E3
    ld [de], a                                    ; $52E4
    inc e                                         ; $52E5
    ld a, [hl+]                                   ; $52E6
    ld [de], a                                    ; $52E7
    inc e                                         ; $52E8
    ld a, [hl+]                                   ; $52E9
    ld [de], a                                    ; $52EA
    inc e                                         ; $52EB
    ld a, [hl+]                                   ; $52EC
    ld [de], a                                    ; $52ED
    inc e                                         ; $52EE
    ld a, [hl+]                                   ; $52EF
    ld [de], a                                    ; $52F0
    inc e                                         ; $52F1
    ld a, [hl+]                                   ; $52F2
    ld [de], a                                    ; $52F3
    inc e                                         ; $52F4
    ld a, [hl+]                                   ; $52F5
    ld [de], a                                    ; $52F6
    inc e                                         ; $52F7
    ld a, [hl+]                                   ; $52F8
    ld [de], a                                    ; $52F9
    inc e                                         ; $52FA
    ld a, [hl+]                                   ; $52FB
    ld [de], a                                    ; $52FC
    inc e                                         ; $52FD
    ld a, [hl+]                                   ; $52FE
    ld [de], a                                    ; $52FF
    inc e                                         ; $5300
    ld a, [hl+]                                   ; $5301
    ld [de], a                                    ; $5302
    inc e                                         ; $5303
    ld a, [hl+]                                   ; $5304
    ld [de], a                                    ; $5305
    inc e                                         ; $5306
    ld a, [hl+]                                   ; $5307
    ld [de], a                                    ; $5308
    inc e                                         ; $5309
    ld a, [hl+]                                   ; $530A
    ld [de], a                                    ; $530B
    inc e                                         ; $530C
    ld a, [hl+]                                   ; $530D
    ld [de], a                                    ; $530E
    inc e                                         ; $530F
    ld a, [hl+]                                   ; $5310
    ld [de], a                                    ; $5311
    inc e                                         ; $5312
    ld a, [hl+]                                   ; $5313
    ld [de], a                                    ; $5314
    inc e                                         ; $5315
    ld a, [hl+]                                   ; $5316
    ld [de], a                                    ; $5317
    inc e                                         ; $5318
    ld a, [hl+]                                   ; $5319
    ld [de], a                                    ; $531A
    inc e                                         ; $531B
    ld a, [hl+]                                   ; $531C
    ld [de], a                                    ; $531D
    inc e                                         ; $531E
    ld a, [hl+]                                   ; $531F
    ld [de], a                                    ; $5320
    inc e                                         ; $5321
    ld a, [hl+]                                   ; $5322
    ld [de], a                                    ; $5323
    inc e                                         ; $5324
    ld a, [hl+]                                   ; $5325
    ld [de], a                                    ; $5326
    inc e                                         ; $5327
    ld a, [hl+]                                   ; $5328
    ld [de], a                                    ; $5329
    inc e                                         ; $532A
    ld a, [hl+]                                   ; $532B
    ld [de], a                                    ; $532C
    inc e                                         ; $532D
    ld a, [hl+]                                   ; $532E
    ld [de], a                                    ; $532F
    inc e                                         ; $5330
    ld a, [hl+]                                   ; $5331
    ld [de], a                                    ; $5332
    inc e                                         ; $5333
    ld a, [hl+]                                   ; $5334
    ld [de], a                                    ; $5335
    inc e                                         ; $5336
    ld a, [hl+]                                   ; $5337
    ld [de], a                                    ; $5338
    inc e                                         ; $5339
    ld a, [hl+]                                   ; $533A
    ld [de], a                                    ; $533B
    inc e                                         ; $533C
    ld a, [hl+]                                   ; $533D
    ld [de], a                                    ; $533E
    inc e                                         ; $533F
    ld a, [hl+]                                   ; $5340
    ld [de], a                                    ; $5341
    inc e                                         ; $5342
    ld a, [hl+]                                   ; $5343
    ld [de], a                                    ; $5344
    inc e                                         ; $5345
    ld a, [hl+]                                   ; $5346
    ld [de], a                                    ; $5347
    inc e                                         ; $5348
    ld a, [hl+]                                   ; $5349
    ld [de], a                                    ; $534A
    inc e                                         ; $534B
    ld a, [hl+]                                   ; $534C
    ld [de], a                                    ; $534D
    inc e                                         ; $534E
    ld a, [hl+]                                   ; $534F
    ld [de], a                                    ; $5350
    inc e                                         ; $5351
    ld a, [hl+]                                   ; $5352
    ld [de], a                                    ; $5353
    inc e                                         ; $5354
    ld a, [hl+]                                   ; $5355
    ld [de], a                                    ; $5356
    inc e                                         ; $5357
    ld a, [hl+]                                   ; $5358
    ld [de], a                                    ; $5359
    inc e                                         ; $535A
    ld a, [hl+]                                   ; $535B
    ld [de], a                                    ; $535C
    inc e                                         ; $535D
    ld a, [hl+]                                   ; $535E
    ld [de], a                                    ; $535F
    inc e                                         ; $5360
    ld a, [hl+]                                   ; $5361
    ld [de], a                                    ; $5362
    inc e                                         ; $5363
    ld a, [hl+]                                   ; $5364
    ld [de], a                                    ; $5365
    inc e                                         ; $5366
    ld a, [hl+]                                   ; $5367
    ld [de], a                                    ; $5368
    inc e                                         ; $5369
    ld a, [hl+]                                   ; $536A
    ld [de], a                                    ; $536B
    inc e                                         ; $536C
    ld a, [hl+]                                   ; $536D
    ld [de], a                                    ; $536E
    inc e                                         ; $536F
    ld a, [hl+]                                   ; $5370
    ld [de], a                                    ; $5371
    inc e                                         ; $5372
    ld a, [hl+]                                   ; $5373
    ld [de], a                                    ; $5374
    inc e                                         ; $5375
    ld a, [hl+]                                   ; $5376
    ld [de], a                                    ; $5377
    inc e                                         ; $5378
    ld a, [hl+]                                   ; $5379
    ld [de], a                                    ; $537A
    inc e                                         ; $537B
    ld a, [hl+]                                   ; $537C
    ld [de], a                                    ; $537D
    inc e                                         ; $537E
    ld a, [hl+]                                   ; $537F
    ld [de], a                                    ; $5380
    inc e                                         ; $5381
    ld a, [hl+]                                   ; $5382
    ld [de], a                                    ; $5383
    inc e                                         ; $5384
    ld a, [hl+]                                   ; $5385
    ld [de], a                                    ; $5386
    inc e                                         ; $5387
    ld a, [hl+]                                   ; $5388
    ld [de], a                                    ; $5389
    inc e                                         ; $538A
    ld a, [hl+]                                   ; $538B
    ld [de], a                                    ; $538C
    inc e                                         ; $538D
    ld a, [hl+]                                   ; $538E
    ld [de], a                                    ; $538F
    inc e                                         ; $5390
    ld a, [hl+]                                   ; $5391
    ld [de], a                                    ; $5392
    inc e                                         ; $5393
    ld a, [hl+]                                   ; $5394
    ld [de], a                                    ; $5395
    inc e                                         ; $5396
    ld a, [hl+]                                   ; $5397
    ld [de], a                                    ; $5398
    inc e                                         ; $5399
    ld a, [hl+]                                   ; $539A
    ld [de], a                                    ; $539B
    inc e                                         ; $539C
    ld a, [hl+]                                   ; $539D
    ld [de], a                                    ; $539E
    inc e                                         ; $539F
    ld a, [hl+]                                   ; $53A0
    ld [de], a                                    ; $53A1
    inc e                                         ; $53A2
    ld a, [hl+]                                   ; $53A3
    ld [de], a                                    ; $53A4
    inc e                                         ; $53A5
    ld a, [hl+]                                   ; $53A6
    ld [de], a                                    ; $53A7
    inc e                                         ; $53A8
    ld a, [hl+]                                   ; $53A9
    ld [de], a                                    ; $53AA
    inc e                                         ; $53AB
    ld a, [hl+]                                   ; $53AC
    ld [de], a                                    ; $53AD
    inc e                                         ; $53AE
    ld a, [hl+]                                   ; $53AF
    ld [de], a                                    ; $53B0
    inc e                                         ; $53B1
    ld a, [hl+]                                   ; $53B2
    ld [de], a                                    ; $53B3
    inc e                                         ; $53B4
    ld a, [hl+]                                   ; $53B5
    ld [de], a                                    ; $53B6
    inc e                                         ; $53B7
    ld a, [hl+]                                   ; $53B8
    ld [de], a                                    ; $53B9
    inc e                                         ; $53BA
    ld a, [hl+]                                   ; $53BB
    ld [de], a                                    ; $53BC
    inc e                                         ; $53BD
    ld a, [hl+]                                   ; $53BE
    ld [de], a                                    ; $53BF
    inc e                                         ; $53C0
    ld a, [hl+]                                   ; $53C1
    ld [de], a                                    ; $53C2
    inc e                                         ; $53C3
    ld a, [hl+]                                   ; $53C4
    ld [de], a                                    ; $53C5
    inc e                                         ; $53C6
    ld a, [hl+]                                   ; $53C7
    ld [de], a                                    ; $53C8
    inc e                                         ; $53C9
    ld a, [hl+]                                   ; $53CA
    ld [de], a                                    ; $53CB
    inc e                                         ; $53CC
    ld a, [hl+]                                   ; $53CD
    ld [de], a                                    ; $53CE
    inc e                                         ; $53CF
    ld a, [hl+]                                   ; $53D0
    ld [de], a                                    ; $53D1
    inc e                                         ; $53D2
    ld a, [hl+]                                   ; $53D3
    ld [de], a                                    ; $53D4
    inc e                                         ; $53D5
    ld a, [hl+]                                   ; $53D6
    ld [de], a                                    ; $53D7
    inc e                                         ; $53D8
    ld a, [hl+]                                   ; $53D9
    ld [de], a                                    ; $53DA
    inc e                                         ; $53DB
    ld a, [hl+]                                   ; $53DC
    ld [de], a                                    ; $53DD
    inc e                                         ; $53DE
    ld a, [hl+]                                   ; $53DF
    ld [de], a                                    ; $53E0
    inc e                                         ; $53E1
    ld a, [hl+]                                   ; $53E2
    ld [de], a                                    ; $53E3
    inc e                                         ; $53E4
    ld a, [hl+]                                   ; $53E5
    ld [de], a                                    ; $53E6
    inc e                                         ; $53E7
    ld a, [hl+]                                   ; $53E8
    ld [de], a                                    ; $53E9
    inc e                                         ; $53EA
    ld a, [hl+]                                   ; $53EB
    ld [de], a                                    ; $53EC
    inc e                                         ; $53ED
    ld a, [hl+]                                   ; $53EE
    ld [de], a                                    ; $53EF
    inc e                                         ; $53F0
    ld a, [hl+]                                   ; $53F1
    ld [de], a                                    ; $53F2
    inc e                                         ; $53F3
    ld a, [hl+]                                   ; $53F4
    ld [de], a                                    ; $53F5
    inc e                                         ; $53F6
    ld a, [hl+]                                   ; $53F7
    ld [de], a                                    ; $53F8
    inc e                                         ; $53F9
    ld a, [hl+]                                   ; $53FA
    ld [de], a                                    ; $53FB
    inc e                                         ; $53FC
    ld a, [hl+]                                   ; $53FD
    ld [de], a                                    ; $53FE
    inc e                                         ; $53FF
    inc d                                         ; $5400
    dec b                                         ; $5401
    jp nz, Cam_CopyTileRows                       ; $5402

    ret                                           ; $5405


; C: A = slot 0-95: jp [0A:541A + 2A] (Funtography: SHOOT variants)
Cam_DispatchEffect::
    sla a                                         ; $5406
    ld c, a                                       ; $5408
    ld b, $00                                     ; $5409
    ld hl, Cam_EffectJumpTbl                      ; $540B
    add hl, bc                                    ; $540E
    ld a, [hl+]                                   ; $540F
    ld b, a                                       ; $5410
    ld a, [hl]                                    ; $5411
    ld c, a                                       ; $5412
    ld l, b                                       ; $5413
    ld h, c                                       ; $5414
    xor a                                         ; $5415
    ld [$4000], a                                 ; $5416
    jp hl                                         ; $5419


; C: 96 entries; index = 06:60DB byte | D7EB (0/$20/$40)
Cam_EffectJumpTbl::
    dw Fx00_Copy
    dw Fx01_MirrorRtoL
    dw Fx02_MirrorLtoR
    dw Fx03_MirrorBtoT
    dw Fx04_MirrorTtoB
    dw Fx05_StretchV2x
    dw Fx06_StretchH2x
    dw Fx07_Zoom2x
    dw Fx08_Reduce2xTile2x2
    dw Fx09_Reduce2xQuadTL
    dw Fx0A_Reduce2xQuadTR
    dw Fx0B_Reduce2xQuadBL
    dw Fx0C_Reduce2xQuadBR
    dw Fx0D_CopyLeftHalf
    dw Fx0E_CopyRightHalf
    dw Fx0F_CopyTopHalf
    dw Fx10_CopyBottomHalf
    dw Fx11_CopyQuads_TR_BL
    dw Fx12_CopyQuads_TR_BL_BR
    dw Fx13_CopyTop10Rows
    dw Fx14_CopyBottom4Rows
    dw Fx15_CopyTop4Rows
    dw Fx16_CopyBottom10Rows
    dw Fx17_CopyWindow
    dw Fx18_CopyQuadBR
    dw Fx19_Nop
    dw Fx1A_Nop
    dw Fx1B_Nop
    dw Fx1C_Nop
    dw Fx1D_Nop
    dw Fx1E_Nop
    dw Fx1F_Nop
    dw Fx20_FlipH
    dw Fx02_MirrorLtoR
    dw Fx01_MirrorRtoL
    dw Fx23_MirrorBtoT_OnFlipH
    dw Fx24_MirrorTtoB_OnFlipH
    dw Fx25_StretchV2x_OnFlipH
    dw Fx26_StretchH2x_OnFlipH
    dw Fx27_Zoom2x_OnFlipH
    dw Fx28_Reduce2xTile2x2_FlipH
    dw Fx29_Reduce2xQuadTL_FlipH
    dw Fx2A_Reduce2xQuadTR_FlipH
    dw Fx2B_Reduce2xQuadBL_FlipH
    dw Fx2C_Reduce2xQuadBR_FlipH
    dw Fx2D_CopyLeftHalf_OnFlipH
    dw Fx2E_CopyRightHalf_OnFlipH
    dw Fx2F_CopyTopHalf_OnFlipH
    dw Fx30_CopyBottomHalf_OnFlipH
    dw Fx31_CopyQuads_TR_BL_OnFlipH
    dw Fx32_CopyQuads_TR_BL_BR_OnFlipH
    dw Fx33_CopyTop10Rows_OnFlipH
    dw Fx34_CopyBottom4Rows_OnFlipH
    dw Fx35_CopyTop4Rows_OnFlipH
    dw Fx36_CopyBottom10Rows_OnFlipH
    dw Fx37_CopyWindow_OnFlipH
    dw Fx38_CopyQuadBR_OnFlipH
    dw Fx39_Nop
    dw Fx3A_Nop
    dw Fx3B_Nop
    dw Fx3C_Nop
    dw Fx3D_Nop
    dw Fx3E_Nop
    dw Fx3F_Nop
    dw Fx40_FlipV
    dw Fx41_MirrorRtoL_OnFlipV
    dw Fx42_MirrorLtoR_OnFlipV
    dw Fx04_MirrorTtoB
    dw Fx03_MirrorBtoT
    dw Fx45_StretchV2x_FlipV
    dw Fx46_StretchH2x_OnFlipV
    dw Fx47_Zoom2x_FlipV
    dw Fx48_Reduce2xTile2x2_FlipV
    dw Fx49_Reduce2xQuadTL_FlipV
    dw Fx4A_Reduce2xQuadTR_FlipV
    dw Fx4B_Reduce2xQuadBL_FlipV
    dw Fx4C_Reduce2xQuadBR_FlipV
    dw Fx4D_CopyLeftHalf_OnFlipV
    dw Fx4E_CopyRightHalf_OnFlipV
    dw Fx4F_CopyTopHalf_OnFlipV
    dw Fx50_CopyBottomHalf_OnFlipV
    dw Fx51_CopyQuads_TR_BL_OnFlipV
    dw Fx52_CopyQuads_TR_BL_BR_OnFlipV
    dw Fx53_CopyTop10Rows_OnFlipV
    dw Fx54_CopyBottom4Rows_OnFlipV
    dw Fx55_CopyTop4Rows_OnFlipV
    dw Fx56_CopyBottom10Rows_OnFlipV
    dw Fx57_CopyWindow_OnFlipV
    dw Fx58_CopyQuadBR_OnFlipV
    dw Fx59_Nop
    dw Fx5A_Nop
    dw Fx5B_Nop
    dw Fx5C_Nop
    dw Fx5D_Nop
    dw Fx5E_Nop
    dw Fx5F_Nop

; C: plain copy of the photo; reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 00; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx00_CopyRows_A100toC000
Fx00_Copy::
    ld hl, $a100                                  ; $54DA
    ld de, wPhotoImage                            ; $54DD
    ld b, $0e                                     ; $54E0
    call Cam_CopyTileRows                         ; $54E2
    ret                                           ; $54E5


; C: left half of the picture = right half of the photo mirrored; reads x 64-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 01;22; scratch FF8A-FF8D loops; selected
; by the game (06:60DB); was Fx01_MirrorCopy_A180toC080
Fx01_MirrorRtoL::
    ld hl, $a180                                  ; $54E6
    ld de, wPhotoImage + $80                      ; $54E9
    ld b, $74                                     ; $54EC
    ld a, $0e                                     ; $54EE
    ldh [hScratchA], a                            ; $54F0

jr_00a_54f2:
    ld a, $08                                     ; $54F2
    ldh [hScratchB], a                            ; $54F4

jr_00a_54f6:
    ld a, $08                                     ; $54F6
    ldh [hScratchD], a                            ; $54F8

jr_00a_54fa:
    ld a, [hl+]                                   ; $54FA
    ld [de], a                                    ; $54FB
    ld c, a                                       ; $54FC
    ld a, [bc]                                    ; $54FD
    ld c, a                                       ; $54FE
    ld a, e                                       ; $54FF
    xor $f0                                       ; $5500
    ld e, a                                       ; $5502
    ld a, c                                       ; $5503
    ld [de], a                                    ; $5504
    inc e                                         ; $5505
    ld a, [hl+]                                   ; $5506
    ld c, a                                       ; $5507
    ld a, [bc]                                    ; $5508
    ld [de], a                                    ; $5509
    ld a, e                                       ; $550A
    xor $f0                                       ; $550B
    ld e, a                                       ; $550D
    ld a, c                                       ; $550E
    ld [de], a                                    ; $550F
    inc e                                         ; $5510
    ldh a, [hScratchD]                            ; $5511
    dec a                                         ; $5513
    ldh [hScratchD], a                            ; $5514
    jr nz, jr_00a_54fa                            ; $5516

    ldh a, [hScratchB]                            ; $5518
    dec a                                         ; $551A
    jr z, jr_00a_5521                             ; $551B

    ldh [hScratchB], a                            ; $551D
    jr jr_00a_54f6                                ; $551F

jr_00a_5521:
    ldh a, [hScratchA]                            ; $5521
    dec a                                         ; $5523
    ret z                                         ; $5524

    ldh [hScratchA], a                            ; $5525
    inc d                                         ; $5527
    ld e, $80                                     ; $5528
    ld l, $80                                     ; $552A
    jr jr_00a_54f2                                ; $552C

; C: right half of the picture = left half of the photo mirrored; reads x 0-63, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 02;21; scratch FF8A-FF8D loops; selected
; by the game (06:60DB); was Fx02_MirrorCopy_A100toC000
Fx02_MirrorLtoR::
    ld hl, $a100                                  ; $552E
    ld de, wPhotoImage                            ; $5531
    ld b, $74                                     ; $5534
    ld a, $0e                                     ; $5536
    ldh [hScratchA], a                            ; $5538

jr_00a_553a:
    ld a, $08                                     ; $553A
    ldh [hScratchB], a                            ; $553C

jr_00a_553e:
    ld a, $08                                     ; $553E
    ldh [hScratchD], a                            ; $5540

jr_00a_5542:
    ld a, [hl+]                                   ; $5542
    ld [de], a                                    ; $5543
    ld c, a                                       ; $5544
    ld a, [bc]                                    ; $5545
    ld c, a                                       ; $5546
    ld a, e                                       ; $5547
    xor $f0                                       ; $5548
    ld e, a                                       ; $554A
    ld a, c                                       ; $554B
    ld [de], a                                    ; $554C
    inc e                                         ; $554D
    ld a, [hl+]                                   ; $554E
    ld c, a                                       ; $554F
    ld a, [bc]                                    ; $5550
    ld [de], a                                    ; $5551
    ld a, e                                       ; $5552
    xor $f0                                       ; $5553
    ld e, a                                       ; $5555
    ld a, c                                       ; $5556
    ld [de], a                                    ; $5557
    inc e                                         ; $5558
    ldh a, [hScratchD]                            ; $5559
    dec a                                         ; $555B
    ldh [hScratchD], a                            ; $555C
    jr nz, jr_00a_5542                            ; $555E

    ldh a, [hScratchB]                            ; $5560
    dec a                                         ; $5562
    jr z, jr_00a_5569                             ; $5563

    ldh [hScratchB], a                            ; $5565
    jr jr_00a_553e                                ; $5567

jr_00a_5569:
    ldh a, [hScratchA]                            ; $5569
    dec a                                         ; $556B
    ret z                                         ; $556C

    ldh [hScratchA], a                            ; $556D
    inc d                                         ; $556F
    ld e, $00                                     ; $5570
    inc h                                         ; $5572
    ld l, $00                                     ; $5573
    jr jr_00a_553a                                ; $5575

; C: top half of the picture = bottom half of the photo flipped upside down; reads x 0-127, y 56-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 03;44; scratch FF8A-FF8D loops; selected
; by the game (06:60DB); was Fx03_Copy_A800toC60E
Fx03_MirrorBtoT::
    ld hl, $a800                                  ; $5577
    ld bc, wPhotoImage + $60e                     ; $557A
    ld de, wEffRegionRow7                         ; $557D
    ld a, $07                                     ; $5580
    ldh [hScratchA], a                            ; $5582

jr_00a_5584:
    ld a, $10                                     ; $5584
    ldh [hScratchB], a                            ; $5586

jr_00a_5588:
    ld a, $08                                     ; $5588
    ldh [hScratchD], a                            ; $558A

jr_00a_558c:
    ld a, [hl+]                                   ; $558C
    ld [de], a                                    ; $558D
    ld [bc], a                                    ; $558E
    inc e                                         ; $558F
    inc c                                         ; $5590
    ld a, [hl+]                                   ; $5591
    ld [de], a                                    ; $5592
    ld [bc], a                                    ; $5593
    inc e                                         ; $5594
    dec c                                         ; $5595
    dec c                                         ; $5596
    dec c                                         ; $5597
    ldh a, [hScratchD]                            ; $5598
    dec a                                         ; $559A
    ldh [hScratchD], a                            ; $559B
    jr nz, jr_00a_558c                            ; $559D

    ldh a, [hScratchB]                            ; $559F
    dec a                                         ; $55A1
    jr z, jr_00a_55ac                             ; $55A2

    ldh [hScratchB], a                            ; $55A4
    ld a, c                                       ; $55A6
    add $20                                       ; $55A7
    ld c, a                                       ; $55A9
    jr jr_00a_5588                                ; $55AA

jr_00a_55ac:
    ldh a, [hScratchA]                            ; $55AC
    dec a                                         ; $55AE
    ret z                                         ; $55AF

    ldh [hScratchA], a                            ; $55B0
    inc d                                         ; $55B2
    ld e, $00                                     ; $55B3
    dec b                                         ; $55B5
    ld c, $0e                                     ; $55B6
    jr jr_00a_5584                                ; $55B8

; C: bottom half of the picture = top half of the photo flipped upside down; reads x 0-127, y 0-55; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 04;43; scratch FF8A-FF8D loops; selected
; by the game (06:60DB); was Fx04_Copy_A100toC000
Fx04_MirrorTtoB::
    ld hl, $a100                                  ; $55BA
    ld de, wPhotoImage                            ; $55BD
    ld bc, wPhotoImage + $d0e                     ; $55C0
    ld a, $07                                     ; $55C3
    ldh [hScratchA], a                            ; $55C5

jr_00a_55c7:
    ld a, $10                                     ; $55C7
    ldh [hScratchB], a                            ; $55C9

jr_00a_55cb:
    ld a, $08                                     ; $55CB
    ldh [hScratchD], a                            ; $55CD

jr_00a_55cf:
    ld a, [hl+]                                   ; $55CF
    ld [de], a                                    ; $55D0
    ld [bc], a                                    ; $55D1
    inc e                                         ; $55D2
    inc c                                         ; $55D3
    ld a, [hl+]                                   ; $55D4
    ld [de], a                                    ; $55D5
    ld [bc], a                                    ; $55D6
    inc e                                         ; $55D7
    dec c                                         ; $55D8
    dec c                                         ; $55D9
    dec c                                         ; $55DA
    ldh a, [hScratchD]                            ; $55DB
    dec a                                         ; $55DD
    ldh [hScratchD], a                            ; $55DE
    jr nz, jr_00a_55cf                            ; $55E0

    ldh a, [hScratchB]                            ; $55E2
    dec a                                         ; $55E4
    jr z, jr_00a_55ef                             ; $55E5

    ldh [hScratchB], a                            ; $55E7
    ld a, c                                       ; $55E9
    add $20                                       ; $55EA
    ld c, a                                       ; $55EC
    jr jr_00a_55cb                                ; $55ED

jr_00a_55ef:
    ldh a, [hScratchA]                            ; $55EF
    dec a                                         ; $55F1
    ret z                                         ; $55F2

    ldh [hScratchA], a                            ; $55F3
    inc d                                         ; $55F5
    ld e, $00                                     ; $55F6
    dec b                                         ; $55F8
    ld c, $0e                                     ; $55F9
    jr jr_00a_55c7                                ; $55FB

; C: the middle band of the photo stretched to double height; reads x 0-127, y 24-79; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 05; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx05_Copy_A400toC000
Fx05_StretchV2x::
    ld hl, $a400                                  ; $55FD
    ld de, wPhotoImage                            ; $5600
    ld a, $07                                     ; $5603
    ldh [hScratchA], a                            ; $5605

jr_00a_5607:
    ld a, $10                                     ; $5607
    ldh [hScratchB], a                            ; $5609

jr_00a_560b:
    ld a, $04                                     ; $560B
    ldh [hScratchD], a                            ; $560D

jr_00a_560f:
    ld a, [hl+]                                   ; $560F
    ld [de], a                                    ; $5610
    inc e                                         ; $5611
    inc e                                         ; $5612
    ld [de], a                                    ; $5613
    dec e                                         ; $5614
    ld a, [hl+]                                   ; $5615
    ld [de], a                                    ; $5616
    inc e                                         ; $5617
    inc e                                         ; $5618
    ld [de], a                                    ; $5619
    inc e                                         ; $561A
    ldh a, [hScratchD]                            ; $561B
    dec a                                         ; $561D
    ldh [hScratchD], a                            ; $561E
    jr nz, jr_00a_560f                            ; $5620

    inc d                                         ; $5622
    ld a, e                                       ; $5623
    sub $10                                       ; $5624
    ld e, a                                       ; $5626
    ld a, $04                                     ; $5627
    ldh [hScratchD], a                            ; $5629

jr_00a_562b:
    ld a, [hl+]                                   ; $562B
    ld [de], a                                    ; $562C
    inc e                                         ; $562D
    inc e                                         ; $562E
    ld [de], a                                    ; $562F
    dec e                                         ; $5630
    ld a, [hl+]                                   ; $5631
    ld [de], a                                    ; $5632
    inc e                                         ; $5633
    inc e                                         ; $5634
    ld [de], a                                    ; $5635
    inc e                                         ; $5636
    ldh a, [hScratchD]                            ; $5637
    dec a                                         ; $5639
    ldh [hScratchD], a                            ; $563A
    jr nz, jr_00a_562b                            ; $563C

    ldh a, [hScratchB]                            ; $563E
    dec a                                         ; $5640
    jr z, jr_00a_5648                             ; $5641

    ldh [hScratchB], a                            ; $5643
    dec d                                         ; $5645
    jr jr_00a_560b                                ; $5646

jr_00a_5648:
    ldh a, [hScratchA]                            ; $5648
    dec a                                         ; $564A
    ret z                                         ; $564B

    ldh [hScratchA], a                            ; $564C
    inc d                                         ; $564E
    jr jr_00a_5607                                ; $564F

; C: the middle columns of the photo stretched to double width; reads x 32-95, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 06; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx06_Copy_A140toC000
Fx06_StretchH2x::
    ld hl, $a140                                  ; $5651
    ld de, wPhotoImage                            ; $5654
    ld a, $0e                                     ; $5657
    ldh [hScratchA], a                            ; $5659

jr_00a_565b:
    ld a, $08                                     ; $565B
    ldh [hScratchB], a                            ; $565D

jr_00a_565f:
    ld a, $10                                     ; $565F
    ldh [hScratchD], a                            ; $5661

jr_00a_5663:
    ld a, [hl+]                                   ; $5663
    ld c, a                                       ; $5664
    ld b, $75                                     ; $5665
    ld a, [bc]                                    ; $5667
    ld [de], a                                    ; $5668
    ld a, e                                       ; $5669
    add $10                                       ; $566A
    ld e, a                                       ; $566C
    ld b, $76                                     ; $566D
    ld a, [bc]                                    ; $566F
    ld [de], a                                    ; $5670
    ld a, e                                       ; $5671
    sub $0f                                       ; $5672
    ld e, a                                       ; $5674
    ldh a, [hScratchD]                            ; $5675
    dec a                                         ; $5677
    ldh [hScratchD], a                            ; $5678
    jr nz, jr_00a_5663                            ; $567A

    ld a, e                                       ; $567C
    add $10                                       ; $567D
    ld e, a                                       ; $567F
    ldh a, [hScratchB]                            ; $5680
    dec a                                         ; $5682
    jr z, jr_00a_5689                             ; $5683

    ldh [hScratchB], a                            ; $5685
    jr jr_00a_565f                                ; $5687

jr_00a_5689:
    ldh a, [hScratchA]                            ; $5689
    dec a                                         ; $568B
    ret z                                         ; $568C

    ldh [hScratchA], a                            ; $568D
    inc d                                         ; $568F
    inc h                                         ; $5690
    ld l, $40                                     ; $5691
    jr jr_00a_565b                                ; $5693

; C: the centre of the photo magnified x2 (both axes); reads x 32-95, y 24-79; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 07; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx07_Copy_A440toC000
Fx07_Zoom2x::
    ld hl, $a440                                  ; $5695
    ld de, wPhotoImage                            ; $5698
    ld a, $07                                     ; $569B
    ldh [hScratchA], a                            ; $569D

; C: pass top of the zoom 2x loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-entered after a source
; / destination pointer step (branch target; code read 2026-10-19)
Fx07_Zoom2x_PassTop::
    ld a, $08                                     ; $569F
    ldh [hScratchB], a                            ; $56A1

; C: group top of the zoom 2x loop: sets the column counter $FF8D = 4, then reads the next tile rows through the
; lookup table (branch target; code read 2026-10-19)
Fx07_Zoom2x_GroupTop::
    ld a, $04                                     ; $56A3
    ldh [hScratchD], a                            ; $56A5

jr_00a_56a7:
    ld a, [hl+]                                   ; $56A7
    ld c, a                                       ; $56A8
    ld b, $75                                     ; $56A9
    ld a, [bc]                                    ; $56AB
    ld [de], a                                    ; $56AC
    inc e                                         ; $56AD
    inc e                                         ; $56AE
    ld [de], a                                    ; $56AF
    ld a, e                                       ; $56B0
    add $0e                                       ; $56B1
    ld e, a                                       ; $56B3
    ld b, $76                                     ; $56B4
    ld a, [bc]                                    ; $56B6
    ld [de], a                                    ; $56B7
    inc e                                         ; $56B8
    inc e                                         ; $56B9
    ld [de], a                                    ; $56BA
    ld a, e                                       ; $56BB
    sub $11                                       ; $56BC
    ld e, a                                       ; $56BE
    ld a, [hl+]                                   ; $56BF
    ld c, a                                       ; $56C0
    ld b, $75                                     ; $56C1
    ld a, [bc]                                    ; $56C3
    ld [de], a                                    ; $56C4
    inc e                                         ; $56C5
    inc e                                         ; $56C6
    ld [de], a                                    ; $56C7
    ld a, e                                       ; $56C8
    add $0e                                       ; $56C9
    ld e, a                                       ; $56CB
    ld b, $76                                     ; $56CC
    ld a, [bc]                                    ; $56CE
    ld [de], a                                    ; $56CF
    inc e                                         ; $56D0
    inc e                                         ; $56D1
    ld [de], a                                    ; $56D2
    ld a, e                                       ; $56D3
    sub $0f                                       ; $56D4
    ld e, a                                       ; $56D6
    ldh a, [hScratchD]                            ; $56D7
    dec a                                         ; $56D9
    ldh [hScratchD], a                            ; $56DA
    jr nz, jr_00a_56a7                            ; $56DC

    inc d                                         ; $56DE
    ld a, e                                       ; $56DF
    sub $10                                       ; $56E0
    ld e, a                                       ; $56E2
    ld a, $04                                     ; $56E3
    ldh [hScratchD], a                            ; $56E5

jr_00a_56e7:
    ld a, [hl+]                                   ; $56E7
    ld c, a                                       ; $56E8
    ld b, $75                                     ; $56E9
    ld a, [bc]                                    ; $56EB
    ld [de], a                                    ; $56EC
    inc e                                         ; $56ED
    inc e                                         ; $56EE
    ld [de], a                                    ; $56EF
    ld a, e                                       ; $56F0
    add $0e                                       ; $56F1
    ld e, a                                       ; $56F3
    ld b, $76                                     ; $56F4
    ld a, [bc]                                    ; $56F6
    ld [de], a                                    ; $56F7
    inc e                                         ; $56F8
    inc e                                         ; $56F9
    ld [de], a                                    ; $56FA
    ld a, e                                       ; $56FB
    sub $11                                       ; $56FC
    ld e, a                                       ; $56FE
    ld a, [hl+]                                   ; $56FF
    ld c, a                                       ; $5700
    ld b, $75                                     ; $5701
    ld a, [bc]                                    ; $5703
    ld [de], a                                    ; $5704
    inc e                                         ; $5705
    inc e                                         ; $5706
    ld [de], a                                    ; $5707
    ld a, e                                       ; $5708
    add $0e                                       ; $5709
    ld e, a                                       ; $570B
    ld b, $76                                     ; $570C
    ld a, [bc]                                    ; $570E
    ld [de], a                                    ; $570F
    inc e                                         ; $5710
    inc e                                         ; $5711
    ld [de], a                                    ; $5712
    ld a, e                                       ; $5713
    sub $0f                                       ; $5714
    ld e, a                                       ; $5716
    ldh a, [hScratchD]                            ; $5717
    dec a                                         ; $5719
    ldh [hScratchD], a                            ; $571A
    jr nz, jr_00a_56e7                            ; $571C

    ldh a, [hScratchB]                            ; $571E
    dec a                                         ; $5720
    jr z, jr_00a_572d                             ; $5721

    ldh [hScratchB], a                            ; $5723
    dec d                                         ; $5725
    ld a, e                                       ; $5726
    add $10                                       ; $5727
    ld e, a                                       ; $5729
    jp Fx07_Zoom2x_GroupTop                       ; $572A


jr_00a_572d:
    ldh a, [hScratchA]                            ; $572D
    dec a                                         ; $572F
    ret z                                         ; $5730

    ldh [hScratchA], a                            ; $5731
    inc h                                         ; $5733
    ld l, $40                                     ; $5734
    inc d                                         ; $5736
    ld e, $00                                     ; $5737
    jp Fx07_Zoom2x_PassTop                        ; $5739


; C: the photo reduced to half size (every second pixel and row) and tiled 2 x 2; reads x 0-126, y 0-110; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 08; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx08_Reduce79_A100toC000
Fx08_Reduce2xTile2x2::
    ld hl, $a100                                  ; $573C
    ld de, wPhotoImage                            ; $573F
    ld b, $79                                     ; $5742
    ld a, $07                                     ; $5744
    ldh [hScratchA], a                            ; $5746

; C: pass top of the 2x reduction loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-entered after a
; source / destination pointer step (branch target; code read 2026-10-19)
Fx08_Reduce2xTile2x2_PassTop::
    ld a, $08                                     ; $5748
    ldh [hScratchB], a                            ; $574A

; C: group top of the 2x reduction loop: sets the column counter $FF8D = 4, then reads the next tile rows through the
; lookup table (branch target; code read 2026-10-19)
Fx08_Reduce2xTile2x2_GroupTop::
    ld a, $04                                     ; $574C
    ldh [hScratchD], a                            ; $574E

jr_00a_5750:
    ld c, [hl]                                    ; $5750
    ld a, [bc]                                    ; $5751
    swap a                                        ; $5752
    ldh [hScratchC], a                            ; $5754
    ld a, l                                       ; $5756
    add $10                                       ; $5757
    ld l, a                                       ; $5759
    ld c, [hl]                                    ; $575A
    ld a, [bc]                                    ; $575B
    ld c, a                                       ; $575C
    ldh a, [hScratchC]                            ; $575D
    or c                                          ; $575F
    ld c, a                                       ; $5760
    ld [de], a                                    ; $5761
    ld a, e                                       ; $5762
    add $80                                       ; $5763
    ld e, a                                       ; $5765
    ld a, c                                       ; $5766
    ld [de], a                                    ; $5767
    ld a, d                                       ; $5768
    add $07                                       ; $5769
    ld d, a                                       ; $576B
    ld a, c                                       ; $576C
    ld [de], a                                    ; $576D
    ld a, e                                       ; $576E
    add $80                                       ; $576F
    ld e, a                                       ; $5771
    ld a, c                                       ; $5772
    ld [de], a                                    ; $5773
    ld a, d                                       ; $5774
    sub $07                                       ; $5775
    ld d, a                                       ; $5777
    inc e                                         ; $5778
    ld a, l                                       ; $5779
    sub $0f                                       ; $577A
    ld l, a                                       ; $577C
    ld c, [hl]                                    ; $577D
    ld a, [bc]                                    ; $577E
    swap a                                        ; $577F
    ldh [hScratchC], a                            ; $5781
    ld a, l                                       ; $5783
    add $10                                       ; $5784
    ld l, a                                       ; $5786
    ld c, [hl]                                    ; $5787
    ld a, [bc]                                    ; $5788
    ld c, a                                       ; $5789
    ldh a, [hScratchC]                            ; $578A
    or c                                          ; $578C
    ld c, a                                       ; $578D
    ld [de], a                                    ; $578E
    ld a, e                                       ; $578F
    add $80                                       ; $5790
    ld e, a                                       ; $5792
    ld a, c                                       ; $5793
    ld [de], a                                    ; $5794
    ld a, d                                       ; $5795
    add $07                                       ; $5796
    ld d, a                                       ; $5798
    ld a, c                                       ; $5799
    ld [de], a                                    ; $579A
    ld a, e                                       ; $579B
    add $80                                       ; $579C
    ld e, a                                       ; $579E
    ld a, c                                       ; $579F
    ld [de], a                                    ; $57A0
    ld a, d                                       ; $57A1
    sub $07                                       ; $57A2
    ld d, a                                       ; $57A4
    inc e                                         ; $57A5
    ld a, l                                       ; $57A6
    sub $0d                                       ; $57A7
    ld l, a                                       ; $57A9
    ldh a, [hScratchD]                            ; $57AA
    dec a                                         ; $57AC
    ldh [hScratchD], a                            ; $57AD
    jr nz, jr_00a_5750                            ; $57AF

    inc h                                         ; $57B1
    ld a, l                                       ; $57B2
    sub $10                                       ; $57B3
    ld l, a                                       ; $57B5
    ld a, $04                                     ; $57B6
    ldh [hScratchD], a                            ; $57B8

jr_00a_57ba:
    ld c, [hl]                                    ; $57BA
    ld a, [bc]                                    ; $57BB
    swap a                                        ; $57BC
    ldh [hScratchC], a                            ; $57BE
    ld a, l                                       ; $57C0
    add $10                                       ; $57C1
    ld l, a                                       ; $57C3
    ld c, [hl]                                    ; $57C4
    ld a, [bc]                                    ; $57C5
    ld c, a                                       ; $57C6
    ldh a, [hScratchC]                            ; $57C7
    or c                                          ; $57C9
    ld c, a                                       ; $57CA
    ld [de], a                                    ; $57CB
    ld a, e                                       ; $57CC
    add $80                                       ; $57CD
    ld e, a                                       ; $57CF
    ld a, c                                       ; $57D0
    ld [de], a                                    ; $57D1
    ld a, d                                       ; $57D2
    add $07                                       ; $57D3
    ld d, a                                       ; $57D5
    ld a, c                                       ; $57D6
    ld [de], a                                    ; $57D7
    ld a, e                                       ; $57D8
    add $80                                       ; $57D9
    ld e, a                                       ; $57DB
    ld a, c                                       ; $57DC
    ld [de], a                                    ; $57DD
    ld a, d                                       ; $57DE
    sub $07                                       ; $57DF
    ld d, a                                       ; $57E1
    inc e                                         ; $57E2
    ld a, l                                       ; $57E3
    sub $0f                                       ; $57E4
    ld l, a                                       ; $57E6
    ld c, [hl]                                    ; $57E7
    ld a, [bc]                                    ; $57E8
    swap a                                        ; $57E9
    ldh [hScratchC], a                            ; $57EB
    ld a, l                                       ; $57ED
    add $10                                       ; $57EE
    ld l, a                                       ; $57F0
    ld c, [hl]                                    ; $57F1
    ld a, [bc]                                    ; $57F2
    ld c, a                                       ; $57F3
    ldh a, [hScratchC]                            ; $57F4
    or c                                          ; $57F6
    ld c, a                                       ; $57F7
    ld [de], a                                    ; $57F8
    ld a, e                                       ; $57F9
    add $80                                       ; $57FA
    ld e, a                                       ; $57FC
    ld a, c                                       ; $57FD
    ld [de], a                                    ; $57FE
    ld a, d                                       ; $57FF
    add $07                                       ; $5800
    ld d, a                                       ; $5802
    ld a, c                                       ; $5803
    ld [de], a                                    ; $5804
    ld a, e                                       ; $5805
    add $80                                       ; $5806
    ld e, a                                       ; $5808
    ld a, c                                       ; $5809
    ld [de], a                                    ; $580A
    ld a, d                                       ; $580B
    sub $07                                       ; $580C
    ld d, a                                       ; $580E
    inc e                                         ; $580F
    ld a, l                                       ; $5810
    sub $0d                                       ; $5811
    ld l, a                                       ; $5813
    ldh a, [hScratchD]                            ; $5814
    dec a                                         ; $5816
    ldh [hScratchD], a                            ; $5817
    jr nz, jr_00a_57ba                            ; $5819

    ldh a, [hScratchB]                            ; $581B
    dec a                                         ; $581D
    jr z, jr_00a_582a                             ; $581E

    ldh [hScratchB], a                            ; $5820
    dec h                                         ; $5822
    ld a, l                                       ; $5823
    add $10                                       ; $5824
    ld l, a                                       ; $5826
    jp Fx08_Reduce2xTile2x2_GroupTop              ; $5827


jr_00a_582a:
    ldh a, [hScratchA]                            ; $582A
    dec a                                         ; $582C
    ret z                                         ; $582D

    ldh [hScratchA], a                            ; $582E
    inc d                                         ; $5830
    ld a, e                                       ; $5831
    add $80                                       ; $5832
    ld e, a                                       ; $5834
    inc h                                         ; $5835
    ld l, $00                                     ; $5836
    jp Fx08_Reduce2xTile2x2_PassTop               ; $5838


; C: the photo reduced to half size (every second pixel and row) into the TL quadrant (56 of 224 tiles; the rest of
; the buffer is left alone); reads x 0-126, y 0-110; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); stub: DE := C000; then shared body 0A:6866 (b=$79 reduce
; table); ...
Fx09_Reduce2xQuadTL::
    ld de, wPhotoImage                            ; $583B
    jp FxShared_ReduceBody_G0                     ; $583E


; C: the photo reduced to half size (every second pixel and row) into the TR quadrant (56 of 224 tiles; the rest of
; the buffer is left alone); reads x 0-126, y 0-110; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); stub: DE := C080; then shared body 0A:6866 (b=$79 reduce
; table); ...
Fx0A_Reduce2xQuadTR::
    ld de, wPhotoImage + $80                      ; $5841
    jp FxShared_ReduceBody_G0                     ; $5844


; C: the photo reduced to half size (every second pixel and row) into the BL quadrant (56 of 224 tiles; the rest of
; the buffer is left alone); reads x 0-126, y 0-110; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); stub: DE := C700; then shared body 0A:6866 (b=$79 reduce
; table); ...
Fx0B_Reduce2xQuadBL::
    ld de, wEffRegionRow7                         ; $5847
    jp FxShared_ReduceBody_G0                     ; $584A


; C: the photo reduced to half size (every second pixel and row) into the BR quadrant (56 of 224 tiles; the rest of
; the buffer is left alone); reads x 0-126, y 0-110; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); stub: DE := C780; then shared body 0A:6866 (b=$79 reduce
; table); ...
Fx0C_Reduce2xQuadBR::
    ld de, wEffRegionRow7Right                    ; $584D
    jp FxShared_ReduceBody_G0                     ; $5850


; C: copy of part of the photo (LeftHalf) (112 of 224 tiles; the rest of the buffer is left alone); reads x 0-63, y
; 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 0D; scratch
; FF8A-FF8D loops; never selected by the game (06:60DB does not produce this ...
Fx0D_CopyLeftHalf::
    ld hl, $a100                                  ; $5853
    ld de, wPhotoImage                            ; $5856
    ld a, $0e                                     ; $5859
    ldh [hScratchA], a                            ; $585B

jr_00a_585d:
    ld a, $08                                     ; $585D
    ldh [hScratchB], a                            ; $585F

jr_00a_5861:
    ld a, [hl+]                                   ; $5861
    ld [de], a                                    ; $5862
    inc e                                         ; $5863
    ld a, [hl+]                                   ; $5864
    ld [de], a                                    ; $5865
    inc e                                         ; $5866
    ld a, [hl+]                                   ; $5867
    ld [de], a                                    ; $5868
    inc e                                         ; $5869
    ld a, [hl+]                                   ; $586A
    ld [de], a                                    ; $586B
    inc e                                         ; $586C
    ld a, [hl+]                                   ; $586D
    ld [de], a                                    ; $586E
    inc e                                         ; $586F
    ld a, [hl+]                                   ; $5870
    ld [de], a                                    ; $5871
    inc e                                         ; $5872
    ld a, [hl+]                                   ; $5873
    ld [de], a                                    ; $5874
    inc e                                         ; $5875
    ld a, [hl+]                                   ; $5876
    ld [de], a                                    ; $5877
    inc e                                         ; $5878
    ld a, [hl+]                                   ; $5879
    ld [de], a                                    ; $587A
    inc e                                         ; $587B
    ld a, [hl+]                                   ; $587C
    ld [de], a                                    ; $587D
    inc e                                         ; $587E
    ld a, [hl+]                                   ; $587F
    ld [de], a                                    ; $5880
    inc e                                         ; $5881
    ld a, [hl+]                                   ; $5882
    ld [de], a                                    ; $5883
    inc e                                         ; $5884
    ld a, [hl+]                                   ; $5885
    ld [de], a                                    ; $5886
    inc e                                         ; $5887
    ld a, [hl+]                                   ; $5888
    ld [de], a                                    ; $5889
    inc e                                         ; $588A
    ld a, [hl+]                                   ; $588B
    ld [de], a                                    ; $588C
    inc e                                         ; $588D
    ld a, [hl+]                                   ; $588E
    ld [de], a                                    ; $588F
    inc e                                         ; $5890
    ldh a, [hScratchB]                            ; $5891
    dec a                                         ; $5893
    jr z, jr_00a_589a                             ; $5894

    ldh [hScratchB], a                            ; $5896
    jr jr_00a_5861                                ; $5898

jr_00a_589a:
    ldh a, [hScratchA]                            ; $589A
    dec a                                         ; $589C
    ret z                                         ; $589D

    ldh [hScratchA], a                            ; $589E
    ld a, e                                       ; $58A0
    add $80                                       ; $58A1
    ld e, a                                       ; $58A3
    inc d                                         ; $58A4
    inc h                                         ; $58A5
    ld l, $00                                     ; $58A6
    jr jr_00a_585d                                ; $58A8

; C: copy of part of the photo (RightHalf) (112 of 224 tiles; the rest of the buffer is left alone); reads x 64-127, y
; 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 0E; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx0E_Copy_A180toC080
Fx0E_CopyRightHalf::
    ld hl, $a180                                  ; $58AA
    ld de, wPhotoImage + $80                      ; $58AD
    ld a, $0e                                     ; $58B0
    ldh [hScratchA], a                            ; $58B2

jr_00a_58b4:
    ld a, $08                                     ; $58B4
    ldh [hScratchB], a                            ; $58B6

jr_00a_58b8:
    ld a, [hl+]                                   ; $58B8
    ld [de], a                                    ; $58B9
    inc e                                         ; $58BA
    ld a, [hl+]                                   ; $58BB
    ld [de], a                                    ; $58BC
    inc e                                         ; $58BD
    ld a, [hl+]                                   ; $58BE
    ld [de], a                                    ; $58BF
    inc e                                         ; $58C0
    ld a, [hl+]                                   ; $58C1
    ld [de], a                                    ; $58C2
    inc e                                         ; $58C3
    ld a, [hl+]                                   ; $58C4
    ld [de], a                                    ; $58C5
    inc e                                         ; $58C6
    ld a, [hl+]                                   ; $58C7
    ld [de], a                                    ; $58C8
    inc e                                         ; $58C9
    ld a, [hl+]                                   ; $58CA
    ld [de], a                                    ; $58CB
    inc e                                         ; $58CC
    ld a, [hl+]                                   ; $58CD
    ld [de], a                                    ; $58CE
    inc e                                         ; $58CF
    ld a, [hl+]                                   ; $58D0
    ld [de], a                                    ; $58D1
    inc e                                         ; $58D2
    ld a, [hl+]                                   ; $58D3
    ld [de], a                                    ; $58D4
    inc e                                         ; $58D5
    ld a, [hl+]                                   ; $58D6
    ld [de], a                                    ; $58D7
    inc e                                         ; $58D8
    ld a, [hl+]                                   ; $58D9
    ld [de], a                                    ; $58DA
    inc e                                         ; $58DB
    ld a, [hl+]                                   ; $58DC
    ld [de], a                                    ; $58DD
    inc e                                         ; $58DE
    ld a, [hl+]                                   ; $58DF
    ld [de], a                                    ; $58E0
    inc e                                         ; $58E1
    ld a, [hl+]                                   ; $58E2
    ld [de], a                                    ; $58E3
    inc e                                         ; $58E4
    ld a, [hl+]                                   ; $58E5
    ld [de], a                                    ; $58E6
    inc e                                         ; $58E7
    ldh a, [hScratchB]                            ; $58E8
    dec a                                         ; $58EA
    jr z, jr_00a_58f1                             ; $58EB

    ldh [hScratchB], a                            ; $58ED
    jr jr_00a_58b8                                ; $58EF

jr_00a_58f1:
    ldh a, [hScratchA]                            ; $58F1
    dec a                                         ; $58F3
    ret z                                         ; $58F4

    ldh [hScratchA], a                            ; $58F5
    inc d                                         ; $58F7
    ld a, e                                       ; $58F8
    add $80                                       ; $58F9
    ld e, a                                       ; $58FB
    ld l, $80                                     ; $58FC
    jr jr_00a_58b4                                ; $58FE

; C: copy of part of the photo (TopHalf) (112 of 224 tiles; the rest of the buffer is left alone); reads x 0-127, y
; 0-55; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 0F; scratch FF8A-FF8D
; loops; never selected by the game (06:60DB does not produce this slot); ...
Fx0F_CopyTopHalf::
    ld hl, $a100                                  ; $5900
    ld de, wPhotoImage                            ; $5903
    ld b, $07                                     ; $5906
    call Cam_CopyTileRows                         ; $5908
    ret                                           ; $590B


; C: copy of part of the photo (BottomHalf) (112 of 224 tiles; the rest of the buffer is left alone); reads x 0-127, y
; 56-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 10; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx10_CopyRows_A800toC700
Fx10_CopyBottomHalf::
    ld hl, $a800                                  ; $590C
    ld de, wEffRegionRow7                         ; $590F
    ld b, $07                                     ; $5912
    call Cam_CopyTileRows                         ; $5914
    ret                                           ; $5917


; C: copy of part of the photo (Quads TR BL) (112 of 224 tiles; the rest of the buffer is left alone); reads x 0-127,
; y 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 11; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx11_Copy_A180toC080
Fx11_CopyQuads_TR_BL::
    ld hl, $a180                                  ; $5918
    ld de, wPhotoImage + $80                      ; $591B
    ld c, $07                                     ; $591E

jr_00a_5920:
    ld b, $08                                     ; $5920

jr_00a_5922:
    ld a, [hl+]                                   ; $5922
    ld [de], a                                    ; $5923
    inc e                                         ; $5924
    ld a, [hl+]                                   ; $5925
    ld [de], a                                    ; $5926
    inc e                                         ; $5927
    ld a, [hl+]                                   ; $5928
    ld [de], a                                    ; $5929
    inc e                                         ; $592A
    ld a, [hl+]                                   ; $592B
    ld [de], a                                    ; $592C
    inc e                                         ; $592D
    ld a, [hl+]                                   ; $592E
    ld [de], a                                    ; $592F
    inc e                                         ; $5930
    ld a, [hl+]                                   ; $5931
    ld [de], a                                    ; $5932
    inc e                                         ; $5933
    ld a, [hl+]                                   ; $5934
    ld [de], a                                    ; $5935
    inc e                                         ; $5936
    ld a, [hl+]                                   ; $5937
    ld [de], a                                    ; $5938
    inc e                                         ; $5939
    ld a, [hl+]                                   ; $593A
    ld [de], a                                    ; $593B
    inc e                                         ; $593C
    ld a, [hl+]                                   ; $593D
    ld [de], a                                    ; $593E
    inc e                                         ; $593F
    ld a, [hl+]                                   ; $5940
    ld [de], a                                    ; $5941
    inc e                                         ; $5942
    ld a, [hl+]                                   ; $5943
    ld [de], a                                    ; $5944
    inc e                                         ; $5945
    ld a, [hl+]                                   ; $5946
    ld [de], a                                    ; $5947
    inc e                                         ; $5948
    ld a, [hl+]                                   ; $5949
    ld [de], a                                    ; $594A
    inc e                                         ; $594B
    ld a, [hl+]                                   ; $594C
    ld [de], a                                    ; $594D
    inc e                                         ; $594E
    ld a, [hl+]                                   ; $594F
    ld [de], a                                    ; $5950
    inc e                                         ; $5951
    dec b                                         ; $5952
    jr nz, jr_00a_5922                            ; $5953

    dec c                                         ; $5955
    jr z, jr_00a_595f                             ; $5956

    inc d                                         ; $5958
    ld e, $80                                     ; $5959
    ld l, $80                                     ; $595B
    jr jr_00a_5920                                ; $595D

jr_00a_595f:
    inc d                                         ; $595F
    ld c, $07                                     ; $5960

jr_00a_5962:
    ld b, $08                                     ; $5962

jr_00a_5964:
    ld a, [hl+]                                   ; $5964
    ld [de], a                                    ; $5965
    inc e                                         ; $5966
    ld a, [hl+]                                   ; $5967
    ld [de], a                                    ; $5968
    inc e                                         ; $5969
    ld a, [hl+]                                   ; $596A
    ld [de], a                                    ; $596B
    inc e                                         ; $596C
    ld a, [hl+]                                   ; $596D
    ld [de], a                                    ; $596E
    inc e                                         ; $596F
    ld a, [hl+]                                   ; $5970
    ld [de], a                                    ; $5971
    inc e                                         ; $5972
    ld a, [hl+]                                   ; $5973
    ld [de], a                                    ; $5974
    inc e                                         ; $5975
    ld a, [hl+]                                   ; $5976
    ld [de], a                                    ; $5977
    inc e                                         ; $5978
    ld a, [hl+]                                   ; $5979
    ld [de], a                                    ; $597A
    inc e                                         ; $597B
    ld a, [hl+]                                   ; $597C
    ld [de], a                                    ; $597D
    inc e                                         ; $597E
    ld a, [hl+]                                   ; $597F
    ld [de], a                                    ; $5980
    inc e                                         ; $5981
    ld a, [hl+]                                   ; $5982
    ld [de], a                                    ; $5983
    inc e                                         ; $5984
    ld a, [hl+]                                   ; $5985
    ld [de], a                                    ; $5986
    inc e                                         ; $5987
    ld a, [hl+]                                   ; $5988
    ld [de], a                                    ; $5989
    inc e                                         ; $598A
    ld a, [hl+]                                   ; $598B
    ld [de], a                                    ; $598C
    inc e                                         ; $598D
    ld a, [hl+]                                   ; $598E
    ld [de], a                                    ; $598F
    inc e                                         ; $5990
    ld a, [hl+]                                   ; $5991
    ld [de], a                                    ; $5992
    inc e                                         ; $5993
    dec b                                         ; $5994
    jr nz, jr_00a_5964                            ; $5995

    dec c                                         ; $5997
    ret z                                         ; $5998

    inc d                                         ; $5999
    ld e, $00                                     ; $599A
    inc h                                         ; $599C
    ld l, $00                                     ; $599D
    jr jr_00a_5962                                ; $599F

; C: copy of part of the photo (Quads TR BL BR) (168 of 224 tiles; the rest of the buffer is left alone); reads x
; 0-127, y 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 12; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx12_Copy_A180toC080
Fx12_CopyQuads_TR_BL_BR::
    ld hl, $a180                                  ; $59A1
    ld de, wPhotoImage + $80                      ; $59A4
    ld c, $07                                     ; $59A7

jr_00a_59a9:
    ld b, $08                                     ; $59A9

jr_00a_59ab:
    ld a, [hl+]                                   ; $59AB
    ld [de], a                                    ; $59AC
    inc e                                         ; $59AD
    ld a, [hl+]                                   ; $59AE
    ld [de], a                                    ; $59AF
    inc e                                         ; $59B0
    ld a, [hl+]                                   ; $59B1
    ld [de], a                                    ; $59B2
    inc e                                         ; $59B3
    ld a, [hl+]                                   ; $59B4
    ld [de], a                                    ; $59B5
    inc e                                         ; $59B6
    ld a, [hl+]                                   ; $59B7
    ld [de], a                                    ; $59B8
    inc e                                         ; $59B9
    ld a, [hl+]                                   ; $59BA
    ld [de], a                                    ; $59BB
    inc e                                         ; $59BC
    ld a, [hl+]                                   ; $59BD
    ld [de], a                                    ; $59BE
    inc e                                         ; $59BF
    ld a, [hl+]                                   ; $59C0
    ld [de], a                                    ; $59C1
    inc e                                         ; $59C2
    ld a, [hl+]                                   ; $59C3
    ld [de], a                                    ; $59C4
    inc e                                         ; $59C5
    ld a, [hl+]                                   ; $59C6
    ld [de], a                                    ; $59C7
    inc e                                         ; $59C8
    ld a, [hl+]                                   ; $59C9
    ld [de], a                                    ; $59CA
    inc e                                         ; $59CB
    ld a, [hl+]                                   ; $59CC
    ld [de], a                                    ; $59CD
    inc e                                         ; $59CE
    ld a, [hl+]                                   ; $59CF
    ld [de], a                                    ; $59D0
    inc e                                         ; $59D1
    ld a, [hl+]                                   ; $59D2
    ld [de], a                                    ; $59D3
    inc e                                         ; $59D4
    ld a, [hl+]                                   ; $59D5
    ld [de], a                                    ; $59D6
    inc e                                         ; $59D7
    ld a, [hl+]                                   ; $59D8
    ld [de], a                                    ; $59D9
    inc e                                         ; $59DA
    dec b                                         ; $59DB
    jr nz, jr_00a_59ab                            ; $59DC

    dec c                                         ; $59DE
    jp z, Fx10_CopyBottomHalf                     ; $59DF

    inc d                                         ; $59E2
    ld e, $80                                     ; $59E3
    ld l, $80                                     ; $59E5
    jr jr_00a_59a9                                ; $59E7

; C: copy of part of the photo (Top10Rows) (160 of 224 tiles; the rest of the buffer is left alone); reads x 0-127, y
; 0-79; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 13; scratch FF8A-FF8D
; loops; never selected by the game (06:60DB does not produce this ...
Fx13_CopyTop10Rows::
    ld hl, $a100                                  ; $59E9
    ld de, wPhotoImage                            ; $59EC
    ld b, $0a                                     ; $59EF
    call Cam_CopyTileRows                         ; $59F1
    ret                                           ; $59F4


; C: copy of part of the photo (Bottom4Rows) (64 of 224 tiles; the rest of the buffer is left alone); reads x 0-127, y
; 80-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 14; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx14_CopyRows_AB00toCA00
Fx14_CopyBottom4Rows::
    ld hl, $ab00                                  ; $59F5
    ld de, wEffRegionRow10                        ; $59F8
    ld b, $04                                     ; $59FB
    call Cam_CopyTileRows                         ; $59FD
    ret                                           ; $5A00


; C: copy of part of the photo (Top4Rows) (64 of 224 tiles; the rest of the buffer is left alone); reads x 0-127, y
; 0-31; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 15; scratch FF8A-FF8D
; loops; never selected by the game (06:60DB does not produce this slot); ...
Fx15_CopyTop4Rows::
    ld hl, $a100                                  ; $5A01
    ld de, wPhotoImage                            ; $5A04
    ld b, $04                                     ; $5A07
    call Cam_CopyTileRows                         ; $5A09
    ret                                           ; $5A0C


; C: copy of part of the photo (Bottom10Rows) (160 of 224 tiles; the rest of the buffer is left alone); reads x 0-127,
; y 32-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 16; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx16_CopyBottom10Rows::
    ld hl, $a500                                  ; $5A0D
    ld de, wEffRegionRow4                         ; $5A10
    ld b, $0a                                     ; $5A13
    call Cam_CopyTileRows                         ; $5A15
    ret                                           ; $5A18


; C: copy of part of the photo (Window) (80 of 224 tiles; the rest of the buffer is left alone); reads x 24-103, y
; 24-87; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 17; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx17_Copy_A430toC330
Fx17_CopyWindow::
    ld hl, $a430                                  ; $5A19
    ld de, wEffRegionTile33                       ; $5A1C
    ld a, $08                                     ; $5A1F
    ldh [hScratchA], a                            ; $5A21

jr_00a_5a23:
    ld a, $0a                                     ; $5A23
    ldh [hScratchB], a                            ; $5A25

jr_00a_5a27:
    ld a, [hl+]                                   ; $5A27
    ld [de], a                                    ; $5A28
    inc e                                         ; $5A29
    ld a, [hl+]                                   ; $5A2A
    ld [de], a                                    ; $5A2B
    inc e                                         ; $5A2C
    ld a, [hl+]                                   ; $5A2D
    ld [de], a                                    ; $5A2E
    inc e                                         ; $5A2F
    ld a, [hl+]                                   ; $5A30
    ld [de], a                                    ; $5A31
    inc e                                         ; $5A32
    ld a, [hl+]                                   ; $5A33
    ld [de], a                                    ; $5A34
    inc e                                         ; $5A35
    ld a, [hl+]                                   ; $5A36
    ld [de], a                                    ; $5A37
    inc e                                         ; $5A38
    ld a, [hl+]                                   ; $5A39
    ld [de], a                                    ; $5A3A
    inc e                                         ; $5A3B
    ld a, [hl+]                                   ; $5A3C
    ld [de], a                                    ; $5A3D
    inc e                                         ; $5A3E
    ld a, [hl+]                                   ; $5A3F
    ld [de], a                                    ; $5A40
    inc e                                         ; $5A41
    ld a, [hl+]                                   ; $5A42
    ld [de], a                                    ; $5A43
    inc e                                         ; $5A44
    ld a, [hl+]                                   ; $5A45
    ld [de], a                                    ; $5A46
    inc e                                         ; $5A47
    ld a, [hl+]                                   ; $5A48
    ld [de], a                                    ; $5A49
    inc e                                         ; $5A4A
    ld a, [hl+]                                   ; $5A4B
    ld [de], a                                    ; $5A4C
    inc e                                         ; $5A4D
    ld a, [hl+]                                   ; $5A4E
    ld [de], a                                    ; $5A4F
    inc e                                         ; $5A50
    ld a, [hl+]                                   ; $5A51
    ld [de], a                                    ; $5A52
    inc e                                         ; $5A53
    ld a, [hl+]                                   ; $5A54
    ld [de], a                                    ; $5A55
    inc e                                         ; $5A56
    ldh a, [hScratchB]                            ; $5A57
    dec a                                         ; $5A59
    jr z, jr_00a_5a60                             ; $5A5A

    ldh [hScratchB], a                            ; $5A5C
    jr jr_00a_5a27                                ; $5A5E

jr_00a_5a60:
    ldh a, [hScratchA]                            ; $5A60
    dec a                                         ; $5A62
    ret z                                         ; $5A63

    ldh [hScratchA], a                            ; $5A64
    ld a, e                                       ; $5A66
    add $60                                       ; $5A67
    ld e, a                                       ; $5A69
    inc d                                         ; $5A6A
    inc h                                         ; $5A6B
    ld l, $30                                     ; $5A6C
    jr jr_00a_5a23                                ; $5A6E

; C: copy of part of the photo (QuadBR) (56 of 224 tiles; the rest of the buffer is left alone); reads x 64-127, y
; 56-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 18; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx18_Copy_A880toC780
Fx18_CopyQuadBR::
    ld hl, $a880                                  ; $5A70
    ld de, wEffRegionRow7Right                    ; $5A73
    ld c, $07                                     ; $5A76

jr_00a_5a78:
    ld b, $08                                     ; $5A78

jr_00a_5a7a:
    ld a, [hl+]                                   ; $5A7A
    ld [de], a                                    ; $5A7B
    inc e                                         ; $5A7C
    ld a, [hl+]                                   ; $5A7D
    ld [de], a                                    ; $5A7E
    inc e                                         ; $5A7F
    ld a, [hl+]                                   ; $5A80
    ld [de], a                                    ; $5A81
    inc e                                         ; $5A82
    ld a, [hl+]                                   ; $5A83
    ld [de], a                                    ; $5A84
    inc e                                         ; $5A85
    ld a, [hl+]                                   ; $5A86
    ld [de], a                                    ; $5A87
    inc e                                         ; $5A88
    ld a, [hl+]                                   ; $5A89
    ld [de], a                                    ; $5A8A
    inc e                                         ; $5A8B
    ld a, [hl+]                                   ; $5A8C
    ld [de], a                                    ; $5A8D
    inc e                                         ; $5A8E
    ld a, [hl+]                                   ; $5A8F
    ld [de], a                                    ; $5A90
    inc e                                         ; $5A91
    ld a, [hl+]                                   ; $5A92
    ld [de], a                                    ; $5A93
    inc e                                         ; $5A94
    ld a, [hl+]                                   ; $5A95
    ld [de], a                                    ; $5A96
    inc e                                         ; $5A97
    ld a, [hl+]                                   ; $5A98
    ld [de], a                                    ; $5A99
    inc e                                         ; $5A9A
    ld a, [hl+]                                   ; $5A9B
    ld [de], a                                    ; $5A9C
    inc e                                         ; $5A9D
    ld a, [hl+]                                   ; $5A9E
    ld [de], a                                    ; $5A9F
    inc e                                         ; $5AA0
    ld a, [hl+]                                   ; $5AA1
    ld [de], a                                    ; $5AA2
    inc e                                         ; $5AA3
    ld a, [hl+]                                   ; $5AA4
    ld [de], a                                    ; $5AA5
    inc e                                         ; $5AA6
    ld a, [hl+]                                   ; $5AA7
    ld [de], a                                    ; $5AA8
    inc e                                         ; $5AA9
    dec b                                         ; $5AAA
    jr nz, jr_00a_5a7a                            ; $5AAB

    dec c                                         ; $5AAD
    ret z                                         ; $5AAE

    inc d                                         ; $5AAF
    ld e, $80                                     ; $5AB0
    ld l, $80                                     ; $5AB2
    jr jr_00a_5a78                                ; $5AB4

; C: single ret: slot 19 of the effect table
Fx19_Nop::
    ret                                           ; $5AB6


; C: single ret: slot 1A of the effect table
Fx1A_Nop::
    ret                                           ; $5AB7


; C: single ret: slot 1B of the effect table
Fx1B_Nop::
    ret                                           ; $5AB8


; C: single ret: slot 1C of the effect table
Fx1C_Nop::
    ret                                           ; $5AB9


; C: single ret: slot 1D of the effect table
Fx1D_Nop::
    ret                                           ; $5ABA


; C: single ret: slot 1E of the effect table
Fx1E_Nop::
    ret                                           ; $5ABB


; C: single ret: slot 1F of the effect table
Fx1F_Nop::
    ret                                           ; $5ABC


; C: the photo flipped left-right; reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 20; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx20_MirrorCopy_A100toC0F0
Fx20_FlipH::
    ld hl, $a100                                  ; $5ABD
    ld de, wPhotoImage + $f0                      ; $5AC0
    ld b, $74                                     ; $5AC3
    ld a, $0e                                     ; $5AC5
    ldh [hScratchA], a                            ; $5AC7

; C: pass top of the flip left-right loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-entered after a
; source / destination pointer step (branch target; code read 2026-10-19)
Fx20_FlipH_PassTop::
    ld a, $10                                     ; $5AC9
    ldh [hScratchB], a                            ; $5ACB

; C: group top of the flip left-right loop: sets the column counter $FF8D = 4, then reads the next tile rows through
; the lookup table (branch target; code read 2026-10-19)
Fx20_FlipH_GroupTop::
    ld a, [hl+]                                   ; $5ACD
    ld c, a                                       ; $5ACE
    ld a, [bc]                                    ; $5ACF
    ld [de], a                                    ; $5AD0
    inc e                                         ; $5AD1
    ld a, [hl+]                                   ; $5AD2
    ld c, a                                       ; $5AD3
    ld a, [bc]                                    ; $5AD4
    ld [de], a                                    ; $5AD5
    inc e                                         ; $5AD6
    ld a, [hl+]                                   ; $5AD7
    ld c, a                                       ; $5AD8
    ld a, [bc]                                    ; $5AD9
    ld [de], a                                    ; $5ADA
    inc e                                         ; $5ADB
    ld a, [hl+]                                   ; $5ADC
    ld c, a                                       ; $5ADD
    ld a, [bc]                                    ; $5ADE
    ld [de], a                                    ; $5ADF
    inc e                                         ; $5AE0
    ld a, [hl+]                                   ; $5AE1
    ld c, a                                       ; $5AE2
    ld a, [bc]                                    ; $5AE3
    ld [de], a                                    ; $5AE4
    inc e                                         ; $5AE5
    ld a, [hl+]                                   ; $5AE6
    ld c, a                                       ; $5AE7
    ld a, [bc]                                    ; $5AE8
    ld [de], a                                    ; $5AE9
    inc e                                         ; $5AEA
    ld a, [hl+]                                   ; $5AEB
    ld c, a                                       ; $5AEC
    ld a, [bc]                                    ; $5AED
    ld [de], a                                    ; $5AEE
    inc e                                         ; $5AEF
    ld a, [hl+]                                   ; $5AF0
    ld c, a                                       ; $5AF1
    ld a, [bc]                                    ; $5AF2
    ld [de], a                                    ; $5AF3
    inc e                                         ; $5AF4
    ld a, [hl+]                                   ; $5AF5
    ld c, a                                       ; $5AF6
    ld a, [bc]                                    ; $5AF7
    ld [de], a                                    ; $5AF8
    inc e                                         ; $5AF9
    ld a, [hl+]                                   ; $5AFA
    ld c, a                                       ; $5AFB
    ld a, [bc]                                    ; $5AFC
    ld [de], a                                    ; $5AFD
    inc e                                         ; $5AFE
    ld a, [hl+]                                   ; $5AFF
    ld c, a                                       ; $5B00
    ld a, [bc]                                    ; $5B01
    ld [de], a                                    ; $5B02
    inc e                                         ; $5B03
    ld a, [hl+]                                   ; $5B04
    ld c, a                                       ; $5B05
    ld a, [bc]                                    ; $5B06
    ld [de], a                                    ; $5B07
    inc e                                         ; $5B08
    ld a, [hl+]                                   ; $5B09
    ld c, a                                       ; $5B0A
    ld a, [bc]                                    ; $5B0B
    ld [de], a                                    ; $5B0C
    inc e                                         ; $5B0D
    ld a, [hl+]                                   ; $5B0E
    ld c, a                                       ; $5B0F
    ld a, [bc]                                    ; $5B10
    ld [de], a                                    ; $5B11
    inc e                                         ; $5B12
    ld a, [hl+]                                   ; $5B13
    ld c, a                                       ; $5B14
    ld a, [bc]                                    ; $5B15
    ld [de], a                                    ; $5B16
    inc e                                         ; $5B17
    ld a, [hl+]                                   ; $5B18
    ld c, a                                       ; $5B19
    ld a, [bc]                                    ; $5B1A
    ld [de], a                                    ; $5B1B
    inc e                                         ; $5B1C
    ldh a, [hScratchB]                            ; $5B1D
    dec a                                         ; $5B1F
    jr z, jr_00a_5b2b                             ; $5B20

    ldh [hScratchB], a                            ; $5B22
    ld a, e                                       ; $5B24
    sub $20                                       ; $5B25
    ld e, a                                       ; $5B27
    jp Fx20_FlipH_GroupTop                        ; $5B28


jr_00a_5b2b:
    ldh a, [hScratchA]                            ; $5B2B
    dec a                                         ; $5B2D
    ret z                                         ; $5B2E

    ldh [hScratchA], a                            ; $5B2F
    inc d                                         ; $5B31
    ld e, $f0                                     ; $5B32
    jp Fx20_FlipH_PassTop                         ; $5B34


; C: top half of the picture = bottom half of the photo flipped upside down; = slot 03 applied to the photo flipped
; left-right; reads x 0-127, y 56-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect
; table slot(s) 23; scratch FF8A-FF8D loops; selected by the game (06:60DB); ...
Fx23_MirrorBtoT_OnFlipH::
    ld hl, $a800                                  ; $5B37
    ld de, wPhotoImage + $7f0                     ; $5B3A
    ld bc, wPhotoImage + $6fe                     ; $5B3D
    ld a, $07                                     ; $5B40
    ldh [hScratchA], a                            ; $5B42

jr_00a_5b44:
    ld a, $10                                     ; $5B44
    ldh [hScratchB], a                            ; $5B46

jr_00a_5b48:
    ld a, $08                                     ; $5B48
    ldh [hScratchD], a                            ; $5B4A

jr_00a_5b4c:
    ld a, [hl+]                                   ; $5B4C
    push hl                                       ; $5B4D
    ld l, a                                       ; $5B4E
    ld h, $74                                     ; $5B4F
    ld a, [hl]                                    ; $5B51
    pop hl                                        ; $5B52
    ld [de], a                                    ; $5B53
    ld [bc], a                                    ; $5B54
    inc e                                         ; $5B55
    inc c                                         ; $5B56
    ld a, [hl+]                                   ; $5B57
    push hl                                       ; $5B58
    ld l, a                                       ; $5B59
    ld h, $74                                     ; $5B5A
    ld a, [hl]                                    ; $5B5C
    pop hl                                        ; $5B5D
    ld [de], a                                    ; $5B5E
    ld [bc], a                                    ; $5B5F
    inc e                                         ; $5B60
    dec c                                         ; $5B61
    dec c                                         ; $5B62
    dec c                                         ; $5B63
    ldh a, [hScratchD]                            ; $5B64
    dec a                                         ; $5B66
    ldh [hScratchD], a                            ; $5B67
    jr nz, jr_00a_5b4c                            ; $5B69

    ldh a, [hScratchB]                            ; $5B6B
    dec a                                         ; $5B6D
    jr z, jr_00a_5b78                             ; $5B6E

    ldh [hScratchB], a                            ; $5B70
    ld a, e                                       ; $5B72
    sub $20                                       ; $5B73
    ld e, a                                       ; $5B75
    jr jr_00a_5b48                                ; $5B76

jr_00a_5b78:
    ldh a, [hScratchA]                            ; $5B78
    dec a                                         ; $5B7A
    ret z                                         ; $5B7B

    ldh [hScratchA], a                            ; $5B7C
    ld e, $f0                                     ; $5B7E
    inc d                                         ; $5B80
    ld c, $fe                                     ; $5B81
    dec b                                         ; $5B83
    jr jr_00a_5b44                                ; $5B84

; C: bottom half of the picture = top half of the photo flipped upside down; = slot 04 applied to the photo flipped
; left-right; reads x 0-127, y 0-55; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table
; slot(s) 24; scratch FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx24_MirrorTtoB_OnFlipH::
    ld hl, $a100                                  ; $5B86
    ld de, wPhotoImage + $f0                      ; $5B89
    ld bc, wPhotoImage + $dfe                     ; $5B8C
    ld a, $07                                     ; $5B8F
    ldh [hScratchA], a                            ; $5B91

jr_00a_5b93:
    ld a, $10                                     ; $5B93
    ldh [hScratchB], a                            ; $5B95

jr_00a_5b97:
    ld a, $08                                     ; $5B97
    ldh [hScratchD], a                            ; $5B99

jr_00a_5b9b:
    ld a, [hl+]                                   ; $5B9B
    push hl                                       ; $5B9C
    ld l, a                                       ; $5B9D
    ld h, $74                                     ; $5B9E
    ld a, [hl]                                    ; $5BA0
    pop hl                                        ; $5BA1
    ld [de], a                                    ; $5BA2
    ld [bc], a                                    ; $5BA3
    inc e                                         ; $5BA4
    inc c                                         ; $5BA5
    ld a, [hl+]                                   ; $5BA6
    push hl                                       ; $5BA7
    ld l, a                                       ; $5BA8
    ld h, $74                                     ; $5BA9
    ld a, [hl]                                    ; $5BAB
    pop hl                                        ; $5BAC
    ld [de], a                                    ; $5BAD
    ld [bc], a                                    ; $5BAE
    inc e                                         ; $5BAF
    dec c                                         ; $5BB0
    dec c                                         ; $5BB1
    dec c                                         ; $5BB2
    ldh a, [hScratchD]                            ; $5BB3
    dec a                                         ; $5BB5
    ldh [hScratchD], a                            ; $5BB6
    jr nz, jr_00a_5b9b                            ; $5BB8

    ldh a, [hScratchB]                            ; $5BBA
    dec a                                         ; $5BBC
    jr z, jr_00a_5bc7                             ; $5BBD

    ldh [hScratchB], a                            ; $5BBF
    ld a, e                                       ; $5BC1
    sub $20                                       ; $5BC2
    ld e, a                                       ; $5BC4
    jr jr_00a_5b97                                ; $5BC5

jr_00a_5bc7:
    ldh a, [hScratchA]                            ; $5BC7
    dec a                                         ; $5BC9
    ret z                                         ; $5BCA

    ldh [hScratchA], a                            ; $5BCB
    ld e, $f0                                     ; $5BCD
    inc d                                         ; $5BCF
    ld c, $fe                                     ; $5BD0
    dec b                                         ; $5BD2
    jr jr_00a_5b93                                ; $5BD3

; C: the middle band of the photo stretched to double height; = slot 05 applied to the photo flipped left-right; reads
; x 0-127, y 24-79; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 25;
; scratch FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx25_StretchV2x_OnFlipH::
    ld hl, $a400                                  ; $5BD5
    ld de, wPhotoImage + $f0                      ; $5BD8
    ld b, $74                                     ; $5BDB
    ld a, $07                                     ; $5BDD
    ldh [hScratchA], a                            ; $5BDF

jr_00a_5be1:
    ld a, $10                                     ; $5BE1
    ldh [hScratchB], a                            ; $5BE3

jr_00a_5be5:
    ld a, $04                                     ; $5BE5
    ldh [hScratchD], a                            ; $5BE7

jr_00a_5be9:
    ld a, [hl+]                                   ; $5BE9
    ld c, a                                       ; $5BEA
    ld a, [bc]                                    ; $5BEB
    ld [de], a                                    ; $5BEC
    inc e                                         ; $5BED
    inc e                                         ; $5BEE
    ld [de], a                                    ; $5BEF
    dec e                                         ; $5BF0
    ld a, [hl+]                                   ; $5BF1
    ld c, a                                       ; $5BF2
    ld a, [bc]                                    ; $5BF3
    ld [de], a                                    ; $5BF4
    inc e                                         ; $5BF5
    inc e                                         ; $5BF6
    ld [de], a                                    ; $5BF7
    inc e                                         ; $5BF8
    ldh a, [hScratchD]                            ; $5BF9
    dec a                                         ; $5BFB
    ldh [hScratchD], a                            ; $5BFC
    jr nz, jr_00a_5be9                            ; $5BFE

    inc d                                         ; $5C00
    ld a, e                                       ; $5C01
    sub $10                                       ; $5C02
    ld e, a                                       ; $5C04
    ld a, $04                                     ; $5C05
    ldh [hScratchD], a                            ; $5C07

jr_00a_5c09:
    ld a, [hl+]                                   ; $5C09
    ld c, a                                       ; $5C0A
    ld a, [bc]                                    ; $5C0B
    ld [de], a                                    ; $5C0C
    inc e                                         ; $5C0D
    inc e                                         ; $5C0E
    ld [de], a                                    ; $5C0F
    dec e                                         ; $5C10
    ld a, [hl+]                                   ; $5C11
    ld c, a                                       ; $5C12
    ld a, [bc]                                    ; $5C13
    ld [de], a                                    ; $5C14
    inc e                                         ; $5C15
    inc e                                         ; $5C16
    ld [de], a                                    ; $5C17
    inc e                                         ; $5C18
    ldh a, [hScratchD]                            ; $5C19
    dec a                                         ; $5C1B
    ldh [hScratchD], a                            ; $5C1C
    jr nz, jr_00a_5c09                            ; $5C1E

    dec d                                         ; $5C20
    ldh a, [hScratchB]                            ; $5C21
    dec a                                         ; $5C23
    jr z, jr_00a_5c2e                             ; $5C24

    ldh [hScratchB], a                            ; $5C26
    ld a, e                                       ; $5C28
    sub $20                                       ; $5C29
    ld e, a                                       ; $5C2B
    jr jr_00a_5be5                                ; $5C2C

jr_00a_5c2e:
    ldh a, [hScratchA]                            ; $5C2E
    dec a                                         ; $5C30
    ret z                                         ; $5C31

    ldh [hScratchA], a                            ; $5C32
    inc d                                         ; $5C34
    inc d                                         ; $5C35
    ld e, $f0                                     ; $5C36
    jr jr_00a_5be1                                ; $5C38

; C: the middle columns of the photo stretched to double width; = slot 06 applied to the photo flipped left-right;
; reads x 32-95, y 0-111; grey levels: identity except 36 px that follow the wrong table byte 0A:774D (14336 px); BGB
; hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect ...
Fx26_StretchH2x_OnFlipH::
    ld hl, $a140                                  ; $5C3A
    ld de, wPhotoImage + $f0                      ; $5C3D
    ld a, $0e                                     ; $5C40
    ldh [hScratchA], a                            ; $5C42

jr_00a_5c44:
    ld a, $08                                     ; $5C44
    ldh [hScratchB], a                            ; $5C46

jr_00a_5c48:
    ld a, $10                                     ; $5C48
    ldh [hScratchD], a                            ; $5C4A

jr_00a_5c4c:
    ld a, [hl+]                                   ; $5C4C
    ld c, a                                       ; $5C4D
    ld b, $77                                     ; $5C4E
    ld a, [bc]                                    ; $5C50
    ld [de], a                                    ; $5C51
    ld a, e                                       ; $5C52
    sub $10                                       ; $5C53
    ld e, a                                       ; $5C55
    ld b, $78                                     ; $5C56
    ld a, [bc]                                    ; $5C58
    ld [de], a                                    ; $5C59
    ld a, e                                       ; $5C5A
    add $11                                       ; $5C5B
    ld e, a                                       ; $5C5D
    ldh a, [hScratchD]                            ; $5C5E
    dec a                                         ; $5C60
    ldh [hScratchD], a                            ; $5C61
    jr nz, jr_00a_5c4c                            ; $5C63

    ld a, e                                       ; $5C65
    sub $30                                       ; $5C66
    ld e, a                                       ; $5C68
    ldh a, [hScratchB]                            ; $5C69
    dec a                                         ; $5C6B
    jr z, jr_00a_5c72                             ; $5C6C

    ldh [hScratchB], a                            ; $5C6E
    jr jr_00a_5c48                                ; $5C70

jr_00a_5c72:
    ldh a, [hScratchA]                            ; $5C72
    dec a                                         ; $5C74
    ret z                                         ; $5C75

    ldh [hScratchA], a                            ; $5C76
    inc d                                         ; $5C78
    ld e, $f0                                     ; $5C79
    inc h                                         ; $5C7B
    ld l, $40                                     ; $5C7C
    jr jr_00a_5c44                                ; $5C7E

; C: the centre of the photo magnified x2 (both axes); = slot 07 applied to the photo flipped left-right; reads x
; 32-95, y 24-79; grey levels: identity except 24 px that follow the wrong table byte 0A:774D (14336 px); BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table ...
Fx27_Zoom2x_OnFlipH::
    ld hl, $a440                                  ; $5C80
    ld de, wPhotoImage + $f0                      ; $5C83
    ld a, $07                                     ; $5C86
    ldh [hScratchA], a                            ; $5C88

; C: pass top of the zoom 2x on the flipped photo loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-
; entered after a source / destination pointer step (branch target; code read 2026-10-19)
Fx27_Zoom2x_OnFlipH_PassTop::
    ld a, $08                                     ; $5C8A
    ldh [hScratchB], a                            ; $5C8C

; C: group top of the zoom 2x on the flipped photo loop: sets the column counter $FF8D = 4, then reads the next tile
; rows through the lookup table (branch target; code read 2026-10-19)
Fx27_Zoom2x_OnFlipH_GroupTop::
    ld a, $04                                     ; $5C8E
    ldh [hScratchD], a                            ; $5C90

jr_00a_5c92:
    ld a, [hl+]                                   ; $5C92
    ld c, a                                       ; $5C93
    ld b, $77                                     ; $5C94
    ld a, [bc]                                    ; $5C96
    ld [de], a                                    ; $5C97
    inc e                                         ; $5C98
    inc e                                         ; $5C99
    ld [de], a                                    ; $5C9A
    ld a, e                                       ; $5C9B
    sub $12                                       ; $5C9C
    ld e, a                                       ; $5C9E
    ld b, $78                                     ; $5C9F
    ld a, [bc]                                    ; $5CA1
    ld [de], a                                    ; $5CA2
    inc e                                         ; $5CA3
    inc e                                         ; $5CA4
    ld [de], a                                    ; $5CA5
    ld a, e                                       ; $5CA6
    add $0f                                       ; $5CA7
    ld e, a                                       ; $5CA9
    ld a, [hl+]                                   ; $5CAA
    ld c, a                                       ; $5CAB
    ld b, $77                                     ; $5CAC
    ld a, [bc]                                    ; $5CAE
    ld [de], a                                    ; $5CAF
    inc e                                         ; $5CB0
    inc e                                         ; $5CB1
    ld [de], a                                    ; $5CB2
    ld a, e                                       ; $5CB3
    sub $12                                       ; $5CB4
    ld e, a                                       ; $5CB6
    ld b, $78                                     ; $5CB7
    ld a, [bc]                                    ; $5CB9
    ld [de], a                                    ; $5CBA
    inc e                                         ; $5CBB
    inc e                                         ; $5CBC
    ld [de], a                                    ; $5CBD
    ld a, e                                       ; $5CBE
    add $11                                       ; $5CBF
    ld e, a                                       ; $5CC1
    ldh a, [hScratchD]                            ; $5CC2
    dec a                                         ; $5CC4
    ldh [hScratchD], a                            ; $5CC5
    jr nz, jr_00a_5c92                            ; $5CC7

    inc d                                         ; $5CC9
    ld a, e                                       ; $5CCA
    sub $10                                       ; $5CCB
    ld e, a                                       ; $5CCD
    ld a, $04                                     ; $5CCE
    ldh [hScratchD], a                            ; $5CD0

jr_00a_5cd2:
    ld a, [hl+]                                   ; $5CD2
    ld c, a                                       ; $5CD3
    ld b, $77                                     ; $5CD4
    ld a, [bc]                                    ; $5CD6
    ld [de], a                                    ; $5CD7
    inc e                                         ; $5CD8
    inc e                                         ; $5CD9
    ld [de], a                                    ; $5CDA
    ld a, e                                       ; $5CDB
    sub $12                                       ; $5CDC
    ld e, a                                       ; $5CDE
    ld b, $78                                     ; $5CDF
    ld a, [bc]                                    ; $5CE1
    ld [de], a                                    ; $5CE2
    inc e                                         ; $5CE3
    inc e                                         ; $5CE4
    ld [de], a                                    ; $5CE5
    ld a, e                                       ; $5CE6
    add $0f                                       ; $5CE7
    ld e, a                                       ; $5CE9
    ld a, [hl+]                                   ; $5CEA
    ld c, a                                       ; $5CEB
    ld b, $77                                     ; $5CEC
    ld a, [bc]                                    ; $5CEE
    ld [de], a                                    ; $5CEF
    inc e                                         ; $5CF0
    inc e                                         ; $5CF1
    ld [de], a                                    ; $5CF2
    ld a, e                                       ; $5CF3
    sub $12                                       ; $5CF4
    ld e, a                                       ; $5CF6
    ld b, $78                                     ; $5CF7
    ld a, [bc]                                    ; $5CF9
    ld [de], a                                    ; $5CFA
    inc e                                         ; $5CFB
    inc e                                         ; $5CFC
    ld [de], a                                    ; $5CFD
    ld a, e                                       ; $5CFE
    add $11                                       ; $5CFF
    ld e, a                                       ; $5D01
    ldh a, [hScratchD]                            ; $5D02
    dec a                                         ; $5D04
    ldh [hScratchD], a                            ; $5D05
    jr nz, jr_00a_5cd2                            ; $5D07

    ldh a, [hScratchB]                            ; $5D09
    dec a                                         ; $5D0B
    jr z, jr_00a_5d18                             ; $5D0C

    ldh [hScratchB], a                            ; $5D0E
    dec d                                         ; $5D10
    ld a, e                                       ; $5D11
    sub $30                                       ; $5D12
    ld e, a                                       ; $5D14
    jp Fx27_Zoom2x_OnFlipH_GroupTop               ; $5D15


jr_00a_5d18:
    ldh a, [hScratchA]                            ; $5D18
    dec a                                         ; $5D1A
    ret z                                         ; $5D1B

    ldh [hScratchA], a                            ; $5D1C
    inc h                                         ; $5D1E
    ld l, $40                                     ; $5D1F
    inc d                                         ; $5D21
    ld e, $f0                                     ; $5D22
    jp Fx27_Zoom2x_OnFlipH_PassTop                ; $5D24


; C: the photo reduced to half size (every second pixel and row) and tiled 2 x 2; = slot 08 with its picture flipped
; left-right; reads x 0-126, y 0-110; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table
; slot(s) 28; scratch FF8A-FF8D loops; selected by the game (06:60DB); ...
Fx28_Reduce2xTile2x2_FlipH::
    ld hl, $a100                                  ; $5D27
    ld de, wPhotoImage + $70                      ; $5D2A
    ld b, $7a                                     ; $5D2D
    ld a, $07                                     ; $5D2F
    ldh [hScratchA], a                            ; $5D31

; C: pass top of the 2x reduction on the flipped photo loop: sets the row counter $FF8B = 8 and falls into _GroupTop;
; re-entered after a source / destination pointer step (branch target; code read 2026-10-19)
Fx28_Reduce2xTile2x2_FlipH_PassTop::
    ld a, $08                                     ; $5D33
    ldh [hScratchB], a                            ; $5D35

; C: group top of the 2x reduction on the flipped photo loop: sets the column counter $FF8D = 4, then reads the next
; tile rows through the lookup table (branch target; code read 2026-10-19)
Fx28_Reduce2xTile2x2_FlipH_GroupTop::
    ld a, $04                                     ; $5D37
    ldh [hScratchD], a                            ; $5D39

jr_00a_5d3b:
    ld c, [hl]                                    ; $5D3B
    ld a, [bc]                                    ; $5D3C
    ldh [hScratchC], a                            ; $5D3D
    ld a, l                                       ; $5D3F
    add $10                                       ; $5D40
    ld l, a                                       ; $5D42
    ld c, [hl]                                    ; $5D43
    ld a, [bc]                                    ; $5D44
    swap a                                        ; $5D45
    ld c, a                                       ; $5D47
    ldh a, [hScratchC]                            ; $5D48
    or c                                          ; $5D4A
    ld c, a                                       ; $5D4B
    ld [de], a                                    ; $5D4C
    ld a, e                                       ; $5D4D
    add $80                                       ; $5D4E
    ld e, a                                       ; $5D50
    ld a, c                                       ; $5D51
    ld [de], a                                    ; $5D52
    ld a, d                                       ; $5D53
    add $07                                       ; $5D54
    ld d, a                                       ; $5D56
    ld a, c                                       ; $5D57
    ld [de], a                                    ; $5D58
    ld a, e                                       ; $5D59
    sub $80                                       ; $5D5A
    ld e, a                                       ; $5D5C
    ld a, c                                       ; $5D5D
    ld [de], a                                    ; $5D5E
    ld a, d                                       ; $5D5F
    sub $07                                       ; $5D60
    ld d, a                                       ; $5D62
    inc e                                         ; $5D63
    ld a, l                                       ; $5D64
    sub $0f                                       ; $5D65
    ld l, a                                       ; $5D67
    ld c, [hl]                                    ; $5D68
    ld a, [bc]                                    ; $5D69
    ldh [hScratchC], a                            ; $5D6A
    ld a, l                                       ; $5D6C
    add $10                                       ; $5D6D
    ld l, a                                       ; $5D6F
    ld c, [hl]                                    ; $5D70
    ld a, [bc]                                    ; $5D71
    swap a                                        ; $5D72
    ld c, a                                       ; $5D74
    ldh a, [hScratchC]                            ; $5D75
    or c                                          ; $5D77
    ld c, a                                       ; $5D78
    ld [de], a                                    ; $5D79
    ld a, e                                       ; $5D7A
    add $80                                       ; $5D7B
    ld e, a                                       ; $5D7D
    ld a, c                                       ; $5D7E
    ld [de], a                                    ; $5D7F
    ld a, d                                       ; $5D80
    add $07                                       ; $5D81
    ld d, a                                       ; $5D83
    ld a, c                                       ; $5D84
    ld [de], a                                    ; $5D85
    ld a, e                                       ; $5D86
    sub $80                                       ; $5D87
    ld e, a                                       ; $5D89
    ld a, c                                       ; $5D8A
    ld [de], a                                    ; $5D8B
    ld a, d                                       ; $5D8C
    sub $07                                       ; $5D8D
    ld d, a                                       ; $5D8F
    inc e                                         ; $5D90
    ld a, l                                       ; $5D91
    sub $0d                                       ; $5D92
    ld l, a                                       ; $5D94
    ldh a, [hScratchD]                            ; $5D95
    dec a                                         ; $5D97
    ldh [hScratchD], a                            ; $5D98
    jr nz, jr_00a_5d3b                            ; $5D9A

    inc h                                         ; $5D9C
    ld a, l                                       ; $5D9D
    sub $10                                       ; $5D9E
    ld l, a                                       ; $5DA0
    ld a, $04                                     ; $5DA1
    ldh [hScratchD], a                            ; $5DA3

jr_00a_5da5:
    ld c, [hl]                                    ; $5DA5
    ld a, [bc]                                    ; $5DA6
    ldh [hScratchC], a                            ; $5DA7
    ld a, l                                       ; $5DA9
    add $10                                       ; $5DAA
    ld l, a                                       ; $5DAC
    ld c, [hl]                                    ; $5DAD
    ld a, [bc]                                    ; $5DAE
    swap a                                        ; $5DAF
    ld c, a                                       ; $5DB1
    ldh a, [hScratchC]                            ; $5DB2
    or c                                          ; $5DB4
    ld c, a                                       ; $5DB5
    ld [de], a                                    ; $5DB6
    ld a, e                                       ; $5DB7
    add $80                                       ; $5DB8
    ld e, a                                       ; $5DBA
    ld a, c                                       ; $5DBB
    ld [de], a                                    ; $5DBC
    ld a, d                                       ; $5DBD
    add $07                                       ; $5DBE
    ld d, a                                       ; $5DC0
    ld a, c                                       ; $5DC1
    ld [de], a                                    ; $5DC2
    ld a, e                                       ; $5DC3
    sub $80                                       ; $5DC4
    ld e, a                                       ; $5DC6
    ld a, c                                       ; $5DC7
    ld [de], a                                    ; $5DC8
    ld a, d                                       ; $5DC9
    sub $07                                       ; $5DCA
    ld d, a                                       ; $5DCC
    inc e                                         ; $5DCD
    ld a, l                                       ; $5DCE
    sub $0f                                       ; $5DCF
    ld l, a                                       ; $5DD1
    ld c, [hl]                                    ; $5DD2
    ld a, [bc]                                    ; $5DD3
    ldh [hScratchC], a                            ; $5DD4
    ld a, l                                       ; $5DD6
    add $10                                       ; $5DD7
    ld l, a                                       ; $5DD9
    ld c, [hl]                                    ; $5DDA
    ld a, [bc]                                    ; $5DDB
    swap a                                        ; $5DDC
    ld c, a                                       ; $5DDE
    ldh a, [hScratchC]                            ; $5DDF
    or c                                          ; $5DE1
    ld c, a                                       ; $5DE2
    ld [de], a                                    ; $5DE3
    ld a, e                                       ; $5DE4
    add $80                                       ; $5DE5
    ld e, a                                       ; $5DE7
    ld a, c                                       ; $5DE8
    ld [de], a                                    ; $5DE9
    ld a, d                                       ; $5DEA
    add $07                                       ; $5DEB
    ld d, a                                       ; $5DED
    ld a, c                                       ; $5DEE
    ld [de], a                                    ; $5DEF
    ld a, e                                       ; $5DF0
    sub $80                                       ; $5DF1
    ld e, a                                       ; $5DF3
    ld a, c                                       ; $5DF4
    ld [de], a                                    ; $5DF5
    ld a, d                                       ; $5DF6
    sub $07                                       ; $5DF7
    ld d, a                                       ; $5DF9
    inc e                                         ; $5DFA
    ld a, l                                       ; $5DFB
    sub $0d                                       ; $5DFC
    ld l, a                                       ; $5DFE
    ldh a, [hScratchD]                            ; $5DFF
    dec a                                         ; $5E01
    ldh [hScratchD], a                            ; $5E02
    jr nz, jr_00a_5da5                            ; $5E04

    ld a, e                                       ; $5E06
    sub $20                                       ; $5E07
    ld e, a                                       ; $5E09
    ldh a, [hScratchB]                            ; $5E0A
    dec a                                         ; $5E0C
    jr z, jr_00a_5e19                             ; $5E0D

    ldh [hScratchB], a                            ; $5E0F
    dec h                                         ; $5E11
    ld a, l                                       ; $5E12
    add $10                                       ; $5E13
    ld l, a                                       ; $5E15
    jp Fx28_Reduce2xTile2x2_FlipH_GroupTop        ; $5E16


jr_00a_5e19:
    ldh a, [hScratchA]                            ; $5E19
    dec a                                         ; $5E1B
    ret z                                         ; $5E1C

    ldh [hScratchA], a                            ; $5E1D
    ld e, $70                                     ; $5E1F
    inc d                                         ; $5E21
    inc h                                         ; $5E22
    ld l, $00                                     ; $5E23
    jp Fx28_Reduce2xTile2x2_FlipH_PassTop         ; $5E25


; C: the photo reduced to half size (every second pixel and row) into the TL quadrant; = slot 09 with its picture
; flipped left-right inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx29_Reduce2xQuadTL_FlipH::
    ld de, wPhotoImage + $70                      ; $5E28
    jp FxShared_ReduceBody_G1                     ; $5E2B


; C: the photo reduced to half size (every second pixel and row) into the TR quadrant; = slot 0A with its picture
; flipped left-right inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx2A_Reduce2xQuadTR_FlipH::
    ld de, wPhotoImage + $f0                      ; $5E2E
    jp FxShared_ReduceBody_G1                     ; $5E31


; C: the photo reduced to half size (every second pixel and row) into the BL quadrant; = slot 0B with its picture
; flipped left-right inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx2B_Reduce2xQuadBL_FlipH::
    ld de, wPhotoImage + $770                     ; $5E34
    jp FxShared_ReduceBody_G1                     ; $5E37


; C: the photo reduced to half size (every second pixel and row) into the BR quadrant; = slot 0C with its picture
; flipped left-right inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx2C_Reduce2xQuadBR_FlipH::
    ld de, wPhotoImage + $7f0                     ; $5E3A
    jp FxShared_ReduceBody_G1                     ; $5E3D


; C: copy of part of the photo (LeftHalf); = slot 0D applied to the photo flipped left-right (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 64-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 2D; scratch FF8A-FF8D loops; never ...
Fx2D_CopyLeftHalf_OnFlipH::
    ld hl, $a180                                  ; $5E40
    ld de, wPhotoImage + $70                      ; $5E43
    ld b, $74                                     ; $5E46
    ld a, $0e                                     ; $5E48
    ldh [hScratchA], a                            ; $5E4A

jr_00a_5e4c:
    ld a, $08                                     ; $5E4C
    ldh [hScratchB], a                            ; $5E4E

jr_00a_5e50:
    ld a, $08                                     ; $5E50
    ldh [hScratchD], a                            ; $5E52

jr_00a_5e54:
    ld a, [hl+]                                   ; $5E54
    ld c, a                                       ; $5E55
    ld a, [bc]                                    ; $5E56
    ld [de], a                                    ; $5E57
    inc e                                         ; $5E58
    ld a, [hl+]                                   ; $5E59
    ld c, a                                       ; $5E5A
    ld a, [bc]                                    ; $5E5B
    ld [de], a                                    ; $5E5C
    inc e                                         ; $5E5D
    ldh a, [hScratchD]                            ; $5E5E
    dec a                                         ; $5E60
    ldh [hScratchD], a                            ; $5E61
    jr nz, jr_00a_5e54                            ; $5E63

    ldh a, [hScratchB]                            ; $5E65
    dec a                                         ; $5E67
    jr z, jr_00a_5e72                             ; $5E68

    ldh [hScratchB], a                            ; $5E6A
    ld a, e                                       ; $5E6C
    sub $20                                       ; $5E6D
    ld e, a                                       ; $5E6F
    jr jr_00a_5e50                                ; $5E70

jr_00a_5e72:
    ldh a, [hScratchA]                            ; $5E72
    dec a                                         ; $5E74
    ret z                                         ; $5E75

    ldh [hScratchA], a                            ; $5E76
    ld l, $80                                     ; $5E78
    inc d                                         ; $5E7A
    ld e, $70                                     ; $5E7B
    jr jr_00a_5e4c                                ; $5E7D

; C: copy of part of the photo (RightHalf); = slot 0E applied to the photo flipped left-right (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-63, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 2E; scratch FF8A-FF8D loops; selected by
; ...
Fx2E_CopyRightHalf_OnFlipH::
    ld hl, $a100                                  ; $5E7F
    ld de, wPhotoImage + $f0                      ; $5E82
    ld b, $74                                     ; $5E85
    ld a, $0e                                     ; $5E87
    ldh [hScratchA], a                            ; $5E89

jr_00a_5e8b:
    ld a, $08                                     ; $5E8B
    ldh [hScratchB], a                            ; $5E8D

jr_00a_5e8f:
    ld a, $08                                     ; $5E8F
    ldh [hScratchD], a                            ; $5E91

jr_00a_5e93:
    ld a, [hl+]                                   ; $5E93
    ld c, a                                       ; $5E94
    ld a, [bc]                                    ; $5E95
    ld [de], a                                    ; $5E96
    inc e                                         ; $5E97
    ld a, [hl+]                                   ; $5E98
    ld c, a                                       ; $5E99
    ld a, [bc]                                    ; $5E9A
    ld [de], a                                    ; $5E9B
    inc e                                         ; $5E9C
    ldh a, [hScratchD]                            ; $5E9D
    dec a                                         ; $5E9F
    ldh [hScratchD], a                            ; $5EA0
    jr nz, jr_00a_5e93                            ; $5EA2

    ldh a, [hScratchB]                            ; $5EA4
    dec a                                         ; $5EA6
    jr z, jr_00a_5eb1                             ; $5EA7

    ldh [hScratchB], a                            ; $5EA9
    ld a, e                                       ; $5EAB
    sub $20                                       ; $5EAC
    ld e, a                                       ; $5EAE
    jr jr_00a_5e8f                                ; $5EAF

jr_00a_5eb1:
    ldh a, [hScratchA]                            ; $5EB1
    dec a                                         ; $5EB3
    ret z                                         ; $5EB4

    ldh [hScratchA], a                            ; $5EB5
    inc h                                         ; $5EB7
    ld l, $00                                     ; $5EB8
    inc d                                         ; $5EBA
    ld e, $f0                                     ; $5EBB
    jr jr_00a_5e8b                                ; $5EBD

; C: copy of part of the photo (TopHalf); = slot 0F applied to the photo flipped left-right (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-55; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 2F; scratch FF8A-FF8D loops; never ...
Fx2F_CopyTopHalf_OnFlipH::
    ld hl, $a100                                  ; $5EBF
    ld de, wPhotoImage + $f0                      ; $5EC2
    ld b, $74                                     ; $5EC5
    ld a, $07                                     ; $5EC7
    ldh [hScratchA], a                            ; $5EC9

jr_00a_5ecb:
    ld a, $10                                     ; $5ECB
    ldh [hScratchB], a                            ; $5ECD

jr_00a_5ecf:
    ld a, $08                                     ; $5ECF
    ldh [hScratchD], a                            ; $5ED1

jr_00a_5ed3:
    ld a, [hl+]                                   ; $5ED3
    ld c, a                                       ; $5ED4
    ld a, [bc]                                    ; $5ED5
    ld [de], a                                    ; $5ED6
    inc e                                         ; $5ED7
    ld a, [hl+]                                   ; $5ED8
    ld c, a                                       ; $5ED9
    ld a, [bc]                                    ; $5EDA
    ld [de], a                                    ; $5EDB
    inc e                                         ; $5EDC
    ldh a, [hScratchD]                            ; $5EDD
    dec a                                         ; $5EDF
    ldh [hScratchD], a                            ; $5EE0
    jr nz, jr_00a_5ed3                            ; $5EE2

    ldh a, [hScratchB]                            ; $5EE4
    dec a                                         ; $5EE6
    jr z, jr_00a_5ef1                             ; $5EE7

    ldh [hScratchB], a                            ; $5EE9
    ld a, e                                       ; $5EEB
    sub $20                                       ; $5EEC
    ld e, a                                       ; $5EEE
    jr jr_00a_5ecf                                ; $5EEF

jr_00a_5ef1:
    ldh a, [hScratchA]                            ; $5EF1
    dec a                                         ; $5EF3
    ret z                                         ; $5EF4

    ldh [hScratchA], a                            ; $5EF5
    inc d                                         ; $5EF7
    ld e, $f0                                     ; $5EF8
    jr jr_00a_5ecb                                ; $5EFA

; C: copy of part of the photo (BottomHalf); = slot 10 applied to the photo flipped left-right (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 56-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 30; scratch FF8A-FF8D loops; selected
; ...
Fx30_CopyBottomHalf_OnFlipH::
    ld hl, $a800                                  ; $5EFC
    ld de, wPhotoImage + $7f0                     ; $5EFF
    ld b, $74                                     ; $5F02
    ld a, $07                                     ; $5F04
    ldh [hScratchA], a                            ; $5F06

jr_00a_5f08:
    ld a, $10                                     ; $5F08
    ldh [hScratchB], a                            ; $5F0A

jr_00a_5f0c:
    ld a, $08                                     ; $5F0C
    ldh [hScratchD], a                            ; $5F0E

jr_00a_5f10:
    ld a, [hl+]                                   ; $5F10
    ld c, a                                       ; $5F11
    ld a, [bc]                                    ; $5F12
    ld [de], a                                    ; $5F13
    inc e                                         ; $5F14
    ld a, [hl+]                                   ; $5F15
    ld c, a                                       ; $5F16
    ld a, [bc]                                    ; $5F17
    ld [de], a                                    ; $5F18
    inc e                                         ; $5F19
    ldh a, [hScratchD]                            ; $5F1A
    dec a                                         ; $5F1C
    ldh [hScratchD], a                            ; $5F1D
    jr nz, jr_00a_5f10                            ; $5F1F

    ldh a, [hScratchB]                            ; $5F21
    dec a                                         ; $5F23
    jr z, jr_00a_5f2e                             ; $5F24

    ldh [hScratchB], a                            ; $5F26
    ld a, e                                       ; $5F28
    sub $20                                       ; $5F29
    ld e, a                                       ; $5F2B
    jr jr_00a_5f0c                                ; $5F2C

jr_00a_5f2e:
    ldh a, [hScratchA]                            ; $5F2E
    dec a                                         ; $5F30
    ret z                                         ; $5F31

    ldh [hScratchA], a                            ; $5F32
    inc d                                         ; $5F34
    ld e, $f0                                     ; $5F35
    jr jr_00a_5f08                                ; $5F37

; C: copy of part of the photo (Quads TR BL); = slot 11 applied to the photo flipped left-right (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 31; scratch FF8A-FF8D loops; selected
; ...
Fx31_CopyQuads_TR_BL_OnFlipH::
    ld hl, $a100                                  ; $5F39
    ld de, wPhotoImage + $f0                      ; $5F3C
    ld b, $74                                     ; $5F3F
    ld a, $07                                     ; $5F41
    ldh [hScratchA], a                            ; $5F43

jr_00a_5f45:
    ld a, $08                                     ; $5F45
    ldh [hScratchB], a                            ; $5F47

jr_00a_5f49:
    ld a, $08                                     ; $5F49
    ldh [hScratchD], a                            ; $5F4B

jr_00a_5f4d:
    ld a, [hl+]                                   ; $5F4D
    ld c, a                                       ; $5F4E
    ld a, [bc]                                    ; $5F4F
    ld [de], a                                    ; $5F50
    inc e                                         ; $5F51
    ld a, [hl+]                                   ; $5F52
    ld c, a                                       ; $5F53
    ld a, [bc]                                    ; $5F54
    ld [de], a                                    ; $5F55
    inc e                                         ; $5F56
    ldh a, [hScratchD]                            ; $5F57
    dec a                                         ; $5F59
    ldh [hScratchD], a                            ; $5F5A
    jr nz, jr_00a_5f4d                            ; $5F5C

    ldh a, [hScratchB]                            ; $5F5E
    dec a                                         ; $5F60
    jr z, jr_00a_5f6b                             ; $5F61

    ldh [hScratchB], a                            ; $5F63
    ld a, e                                       ; $5F65
    sub $20                                       ; $5F66
    ld e, a                                       ; $5F68
    jr jr_00a_5f49                                ; $5F69

jr_00a_5f6b:
    ldh a, [hScratchA]                            ; $5F6B
    dec a                                         ; $5F6D
    jr z, jr_00a_5f7a                             ; $5F6E

    ldh [hScratchA], a                            ; $5F70
    inc h                                         ; $5F72
    ld l, $00                                     ; $5F73
    inc d                                         ; $5F75
    ld e, $f0                                     ; $5F76
    jr jr_00a_5f45                                ; $5F78

jr_00a_5f7a:
    ld hl, $a880                                  ; $5F7A
    ld de, wPhotoImage + $770                     ; $5F7D
    ld b, $74                                     ; $5F80
    ld a, $07                                     ; $5F82
    ldh [hScratchA], a                            ; $5F84

jr_00a_5f86:
    ld a, $08                                     ; $5F86
    ldh [hScratchB], a                            ; $5F88

jr_00a_5f8a:
    ld a, $08                                     ; $5F8A
    ldh [hScratchD], a                            ; $5F8C

jr_00a_5f8e:
    ld a, [hl+]                                   ; $5F8E
    ld c, a                                       ; $5F8F
    ld a, [bc]                                    ; $5F90
    ld [de], a                                    ; $5F91
    inc e                                         ; $5F92
    ld a, [hl+]                                   ; $5F93
    ld c, a                                       ; $5F94
    ld a, [bc]                                    ; $5F95
    ld [de], a                                    ; $5F96
    inc e                                         ; $5F97
    ldh a, [hScratchD]                            ; $5F98
    dec a                                         ; $5F9A
    ldh [hScratchD], a                            ; $5F9B
    jr nz, jr_00a_5f8e                            ; $5F9D

    ldh a, [hScratchB]                            ; $5F9F
    dec a                                         ; $5FA1
    jr z, jr_00a_5fac                             ; $5FA2

    ldh [hScratchB], a                            ; $5FA4
    ld a, e                                       ; $5FA6
    sub $20                                       ; $5FA7
    ld e, a                                       ; $5FA9
    jr jr_00a_5f8a                                ; $5FAA

jr_00a_5fac:
    ldh a, [hScratchA]                            ; $5FAC
    dec a                                         ; $5FAE
    ret z                                         ; $5FAF

    ldh [hScratchA], a                            ; $5FB0
    ld l, $80                                     ; $5FB2
    inc d                                         ; $5FB4
    ld e, $70                                     ; $5FB5
    jr jr_00a_5f86                                ; $5FB7

; C: copy of part of the photo (Quads TR BL BR); = slot 12 applied to the photo flipped left-right (168 of 224 tiles;
; the rest of the buffer is left alone); reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 32; scratch FF8A-FF8D loops; ...
Fx32_CopyQuads_TR_BL_BR_OnFlipH::
    ld hl, $a100                                  ; $5FB9
    ld de, wPhotoImage + $f0                      ; $5FBC
    ld b, $74                                     ; $5FBF
    ld a, $07                                     ; $5FC1
    ldh [hScratchA], a                            ; $5FC3

jr_00a_5fc5:
    ld a, $08                                     ; $5FC5
    ldh [hScratchB], a                            ; $5FC7

jr_00a_5fc9:
    ld a, $08                                     ; $5FC9
    ldh [hScratchD], a                            ; $5FCB

jr_00a_5fcd:
    ld a, [hl+]                                   ; $5FCD
    ld c, a                                       ; $5FCE
    ld a, [bc]                                    ; $5FCF
    ld [de], a                                    ; $5FD0
    inc e                                         ; $5FD1
    ld a, [hl+]                                   ; $5FD2
    ld c, a                                       ; $5FD3
    ld a, [bc]                                    ; $5FD4
    ld [de], a                                    ; $5FD5
    inc e                                         ; $5FD6
    ldh a, [hScratchD]                            ; $5FD7
    dec a                                         ; $5FD9
    ldh [hScratchD], a                            ; $5FDA
    jr nz, jr_00a_5fcd                            ; $5FDC

    ldh a, [hScratchB]                            ; $5FDE
    dec a                                         ; $5FE0
    jr z, jr_00a_5feb                             ; $5FE1

    ldh [hScratchB], a                            ; $5FE3
    ld a, e                                       ; $5FE5
    sub $20                                       ; $5FE6
    ld e, a                                       ; $5FE8
    jr jr_00a_5fc9                                ; $5FE9

jr_00a_5feb:
    ldh a, [hScratchA]                            ; $5FEB
    dec a                                         ; $5FED
    jr z, jr_00a_5ffa                             ; $5FEE

    ldh [hScratchA], a                            ; $5FF0
    inc h                                         ; $5FF2
    ld l, $00                                     ; $5FF3
    ld e, $f0                                     ; $5FF5
    inc d                                         ; $5FF7
    jr jr_00a_5fc5                                ; $5FF8

jr_00a_5ffa:
    ld hl, $a800                                  ; $5FFA
    ld de, wPhotoImage + $7f0                     ; $5FFD
    ld b, $74                                     ; $6000
    ld a, $07                                     ; $6002
    ldh [hScratchA], a                            ; $6004

jr_00a_6006:
    ld a, $10                                     ; $6006
    ldh [hScratchB], a                            ; $6008

jr_00a_600a:
    ld a, $08                                     ; $600A
    ldh [hScratchD], a                            ; $600C

jr_00a_600e:
    ld a, [hl+]                                   ; $600E
    ld c, a                                       ; $600F
    ld a, [bc]                                    ; $6010
    ld [de], a                                    ; $6011
    inc e                                         ; $6012
    ld a, [hl+]                                   ; $6013
    ld c, a                                       ; $6014
    ld a, [bc]                                    ; $6015
    ld [de], a                                    ; $6016
    inc e                                         ; $6017
    ldh a, [hScratchD]                            ; $6018
    dec a                                         ; $601A
    ldh [hScratchD], a                            ; $601B
    jr nz, jr_00a_600e                            ; $601D

    ldh a, [hScratchB]                            ; $601F
    dec a                                         ; $6021
    jr z, jr_00a_602c                             ; $6022

    ldh [hScratchB], a                            ; $6024
    ld a, e                                       ; $6026
    sub $20                                       ; $6027
    ld e, a                                       ; $6029
    jr jr_00a_600a                                ; $602A

jr_00a_602c:
    ldh a, [hScratchA]                            ; $602C
    dec a                                         ; $602E
    ret z                                         ; $602F

    ldh [hScratchA], a                            ; $6030
    ld e, $f0                                     ; $6032
    inc d                                         ; $6034
    jr jr_00a_6006                                ; $6035

; C: copy of part of the photo (Top10Rows); = slot 13 applied to the photo flipped left-right (160 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-79; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 33; scratch FF8A-FF8D loops; never ...
Fx33_CopyTop10Rows_OnFlipH::
    ld hl, $a100                                  ; $6037
    ld de, wPhotoImage + $f0                      ; $603A
    ld b, $74                                     ; $603D
    ld a, $0a                                     ; $603F
    ldh [hScratchA], a                            ; $6041

jr_00a_6043:
    ld a, $10                                     ; $6043
    ldh [hScratchB], a                            ; $6045

jr_00a_6047:
    ld a, $08                                     ; $6047
    ldh [hScratchD], a                            ; $6049

jr_00a_604b:
    ld a, [hl+]                                   ; $604B
    ld c, a                                       ; $604C
    ld a, [bc]                                    ; $604D
    ld [de], a                                    ; $604E
    inc e                                         ; $604F
    ld a, [hl+]                                   ; $6050
    ld c, a                                       ; $6051
    ld a, [bc]                                    ; $6052
    ld [de], a                                    ; $6053
    inc e                                         ; $6054
    ldh a, [hScratchD]                            ; $6055
    dec a                                         ; $6057
    ldh [hScratchD], a                            ; $6058
    jr nz, jr_00a_604b                            ; $605A

    ldh a, [hScratchB]                            ; $605C
    dec a                                         ; $605E
    jr z, jr_00a_6069                             ; $605F

    ldh [hScratchB], a                            ; $6061
    ld a, e                                       ; $6063
    sub $20                                       ; $6064
    ld e, a                                       ; $6066
    jr jr_00a_6047                                ; $6067

jr_00a_6069:
    ldh a, [hScratchA]                            ; $6069
    dec a                                         ; $606B
    ret z                                         ; $606C

    ldh [hScratchA], a                            ; $606D
    ld e, $f0                                     ; $606F
    inc d                                         ; $6071
    jr jr_00a_6043                                ; $6072

; C: copy of part of the photo (Bottom4Rows); = slot 14 applied to the photo flipped left-right (64 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 80-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 34; scratch FF8A-FF8D loops; selected
; ...
Fx34_CopyBottom4Rows_OnFlipH::
    ld hl, $ab00                                  ; $6074
    ld de, wPhotoImage + $af0                     ; $6077
    ld b, $74                                     ; $607A
    ld a, $04                                     ; $607C
    ldh [hScratchA], a                            ; $607E

jr_00a_6080:
    ld a, $10                                     ; $6080
    ldh [hScratchB], a                            ; $6082

jr_00a_6084:
    ld a, $08                                     ; $6084
    ldh [hScratchD], a                            ; $6086

jr_00a_6088:
    ld a, [hl+]                                   ; $6088
    ld c, a                                       ; $6089
    ld a, [bc]                                    ; $608A
    ld [de], a                                    ; $608B
    inc e                                         ; $608C
    ld a, [hl+]                                   ; $608D
    ld c, a                                       ; $608E
    ld a, [bc]                                    ; $608F
    ld [de], a                                    ; $6090
    inc e                                         ; $6091
    ldh a, [hScratchD]                            ; $6092
    dec a                                         ; $6094
    ldh [hScratchD], a                            ; $6095
    jr nz, jr_00a_6088                            ; $6097

    ldh a, [hScratchB]                            ; $6099
    dec a                                         ; $609B
    jr z, jr_00a_60a6                             ; $609C

    ldh [hScratchB], a                            ; $609E
    ld a, e                                       ; $60A0
    sub $20                                       ; $60A1
    ld e, a                                       ; $60A3
    jr jr_00a_6084                                ; $60A4

jr_00a_60a6:
    ldh a, [hScratchA]                            ; $60A6
    dec a                                         ; $60A8
    ret z                                         ; $60A9

    ldh [hScratchA], a                            ; $60AA
    ld e, $f0                                     ; $60AC
    inc d                                         ; $60AE
    jr jr_00a_6080                                ; $60AF

; C: copy of part of the photo (Top4Rows); = slot 15 applied to the photo flipped left-right (64 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-31; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 35; scratch FF8A-FF8D loops; never ...
Fx35_CopyTop4Rows_OnFlipH::
    ld hl, $a100                                  ; $60B1
    ld de, wPhotoImage + $f0                      ; $60B4
    ld b, $74                                     ; $60B7
    ld a, $04                                     ; $60B9
    ldh [hScratchA], a                            ; $60BB

jr_00a_60bd:
    ld a, $10                                     ; $60BD
    ldh [hScratchB], a                            ; $60BF

jr_00a_60c1:
    ld a, $08                                     ; $60C1
    ldh [hScratchD], a                            ; $60C3

jr_00a_60c5:
    ld a, [hl+]                                   ; $60C5
    ld c, a                                       ; $60C6
    ld a, [bc]                                    ; $60C7
    ld [de], a                                    ; $60C8
    inc e                                         ; $60C9
    ld a, [hl+]                                   ; $60CA
    ld c, a                                       ; $60CB
    ld a, [bc]                                    ; $60CC
    ld [de], a                                    ; $60CD
    inc e                                         ; $60CE
    ldh a, [hScratchD]                            ; $60CF
    dec a                                         ; $60D1
    ldh [hScratchD], a                            ; $60D2
    jr nz, jr_00a_60c5                            ; $60D4

    ldh a, [hScratchB]                            ; $60D6
    dec a                                         ; $60D8
    jr z, jr_00a_60e3                             ; $60D9

    ldh [hScratchB], a                            ; $60DB
    ld a, e                                       ; $60DD
    sub $20                                       ; $60DE
    ld e, a                                       ; $60E0
    jr jr_00a_60c1                                ; $60E1

jr_00a_60e3:
    ldh a, [hScratchA]                            ; $60E3
    dec a                                         ; $60E5
    ret z                                         ; $60E6

    ldh [hScratchA], a                            ; $60E7
    ld e, $f0                                     ; $60E9
    inc d                                         ; $60EB
    jr jr_00a_60bd                                ; $60EC

; C: copy of part of the photo (Bottom10Rows); = slot 16 applied to the photo flipped left-right (160 of 224 tiles;
; the rest of the buffer is left alone); reads x 0-127, y 32-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 36; scratch FF8A-FF8D loops; ...
Fx36_CopyBottom10Rows_OnFlipH::
    ld hl, $a500                                  ; $60EE
    ld de, wPhotoImage + $4f0                     ; $60F1
    ld b, $74                                     ; $60F4
    ld a, $0a                                     ; $60F6
    ldh [hScratchA], a                            ; $60F8

jr_00a_60fa:
    ld a, $10                                     ; $60FA
    ldh [hScratchB], a                            ; $60FC

jr_00a_60fe:
    ld a, $08                                     ; $60FE
    ldh [hScratchD], a                            ; $6100

jr_00a_6102:
    ld a, [hl+]                                   ; $6102
    ld c, a                                       ; $6103
    ld a, [bc]                                    ; $6104
    ld [de], a                                    ; $6105
    inc e                                         ; $6106
    ld a, [hl+]                                   ; $6107
    ld c, a                                       ; $6108
    ld a, [bc]                                    ; $6109
    ld [de], a                                    ; $610A
    inc e                                         ; $610B
    ldh a, [hScratchD]                            ; $610C
    dec a                                         ; $610E
    ldh [hScratchD], a                            ; $610F
    jr nz, jr_00a_6102                            ; $6111

    ldh a, [hScratchB]                            ; $6113
    dec a                                         ; $6115
    jr z, jr_00a_6120                             ; $6116

    ldh [hScratchB], a                            ; $6118
    ld a, e                                       ; $611A
    sub $20                                       ; $611B
    ld e, a                                       ; $611D
    jr jr_00a_60fe                                ; $611E

jr_00a_6120:
    ldh a, [hScratchA]                            ; $6120
    dec a                                         ; $6122
    ret z                                         ; $6123

    ldh [hScratchA], a                            ; $6124
    ld e, $f0                                     ; $6126
    inc d                                         ; $6128
    jr jr_00a_60fa                                ; $6129

; C: copy of part of the photo (Window); = slot 17 applied to the photo flipped left-right (80 of 224 tiles; the rest
; of the buffer is left alone); reads x 24-103, y 24-87; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 37; scratch FF8A-FF8D loops; selected by
; ...
Fx37_CopyWindow_OnFlipH::
    ld hl, $a430                                  ; $612B
    ld de, wPhotoImage + $3c0                     ; $612E
    ld b, $74                                     ; $6131
    ld a, $08                                     ; $6133
    ldh [hScratchA], a                            ; $6135

jr_00a_6137:
    ld a, $0a                                     ; $6137
    ldh [hScratchB], a                            ; $6139

jr_00a_613b:
    ld a, $08                                     ; $613B
    ldh [hScratchD], a                            ; $613D

jr_00a_613f:
    ld a, [hl+]                                   ; $613F
    ld c, a                                       ; $6140
    ld a, [bc]                                    ; $6141
    ld [de], a                                    ; $6142
    inc e                                         ; $6143
    ld a, [hl+]                                   ; $6144
    ld c, a                                       ; $6145
    ld a, [bc]                                    ; $6146
    ld [de], a                                    ; $6147
    inc e                                         ; $6148
    ldh a, [hScratchD]                            ; $6149
    dec a                                         ; $614B
    ldh [hScratchD], a                            ; $614C
    jr nz, jr_00a_613f                            ; $614E

    ldh a, [hScratchB]                            ; $6150
    dec a                                         ; $6152
    jr z, jr_00a_615d                             ; $6153

    ldh [hScratchB], a                            ; $6155
    ld a, e                                       ; $6157
    sub $20                                       ; $6158
    ld e, a                                       ; $615A
    jr jr_00a_613b                                ; $615B

jr_00a_615d:
    ldh a, [hScratchA]                            ; $615D
    dec a                                         ; $615F
    ret z                                         ; $6160

    ldh [hScratchA], a                            ; $6161
    inc h                                         ; $6163
    ld l, $30                                     ; $6164
    inc d                                         ; $6166
    ld e, $c0                                     ; $6167
    jr jr_00a_6137                                ; $6169

; C: copy of part of the photo (QuadBR); = slot 18 applied to the photo flipped left-right (56 of 224 tiles; the rest
; of the buffer is left alone); reads x 0-63, y 56-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 38; scratch FF8A-FF8D loops; selected by
; ...
Fx38_CopyQuadBR_OnFlipH::
    ld hl, $a800                                  ; $616B
    ld de, wPhotoImage + $7f0                     ; $616E
    ld b, $74                                     ; $6171
    ld a, $07                                     ; $6173
    ldh [hScratchA], a                            ; $6175

jr_00a_6177:
    ld a, $08                                     ; $6177
    ldh [hScratchB], a                            ; $6179

jr_00a_617b:
    ld a, $08                                     ; $617B
    ldh [hScratchD], a                            ; $617D

jr_00a_617f:
    ld a, [hl+]                                   ; $617F
    ld c, a                                       ; $6180
    ld a, [bc]                                    ; $6181
    ld [de], a                                    ; $6182
    inc e                                         ; $6183
    ld a, [hl+]                                   ; $6184
    ld c, a                                       ; $6185
    ld a, [bc]                                    ; $6186
    ld [de], a                                    ; $6187
    inc e                                         ; $6188
    ldh a, [hScratchD]                            ; $6189
    dec a                                         ; $618B
    ldh [hScratchD], a                            ; $618C
    jr nz, jr_00a_617f                            ; $618E

    ldh a, [hScratchB]                            ; $6190
    dec a                                         ; $6192
    jr z, jr_00a_619d                             ; $6193

    ldh [hScratchB], a                            ; $6195
    ld a, e                                       ; $6197
    sub $20                                       ; $6198
    ld e, a                                       ; $619A
    jr jr_00a_617b                                ; $619B

jr_00a_619d:
    ldh a, [hScratchA]                            ; $619D
    dec a                                         ; $619F
    ret z                                         ; $61A0

    ldh [hScratchA], a                            ; $61A1
    inc h                                         ; $61A3
    ld l, $00                                     ; $61A4
    ld e, $f0                                     ; $61A6
    inc d                                         ; $61A8
    jr jr_00a_6177                                ; $61A9

; C: single ret: slot 39 of the effect table
Fx39_Nop::
    ret                                           ; $61AB


; C: single ret: slot 3A of the effect table
Fx3A_Nop::
    ret                                           ; $61AC


; C: single ret: slot 3B of the effect table
Fx3B_Nop::
    ret                                           ; $61AD


; C: single ret: slot 3C of the effect table
Fx3C_Nop::
    ret                                           ; $61AE


; C: single ret: slot 3D of the effect table
Fx3D_Nop::
    ret                                           ; $61AF


; C: single ret: slot 3E of the effect table
Fx3E_Nop::
    ret                                           ; $61B0


; C: single ret: slot 3F of the effect table
Fx3F_Nop::
    ret                                           ; $61B1


; C: the photo flipped upside down; reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 40; scratch FF8A-FF8D loops; selected by
; the game (06:60DB); was Fx40_Copy_A100toCD0E
Fx40_FlipV::
    ld hl, $a100                                  ; $61B2
    ld bc, wPhotoImage + $d0e                     ; $61B5
    ld a, $0e                                     ; $61B8
    ldh [hScratchA], a                            ; $61BA

jr_00a_61bc:
    ld a, $10                                     ; $61BC
    ldh [hScratchB], a                            ; $61BE

jr_00a_61c0:
    ld a, [hl+]                                   ; $61C0
    ld [bc], a                                    ; $61C1
    inc c                                         ; $61C2
    ld a, [hl+]                                   ; $61C3
    ld [bc], a                                    ; $61C4
    dec c                                         ; $61C5
    dec c                                         ; $61C6
    dec c                                         ; $61C7
    ld a, [hl+]                                   ; $61C8
    ld [bc], a                                    ; $61C9
    inc c                                         ; $61CA
    ld a, [hl+]                                   ; $61CB
    ld [bc], a                                    ; $61CC
    dec c                                         ; $61CD
    dec c                                         ; $61CE
    dec c                                         ; $61CF
    ld a, [hl+]                                   ; $61D0
    ld [bc], a                                    ; $61D1
    inc c                                         ; $61D2
    ld a, [hl+]                                   ; $61D3
    ld [bc], a                                    ; $61D4
    dec c                                         ; $61D5
    dec c                                         ; $61D6
    dec c                                         ; $61D7
    ld a, [hl+]                                   ; $61D8
    ld [bc], a                                    ; $61D9
    inc c                                         ; $61DA
    ld a, [hl+]                                   ; $61DB
    ld [bc], a                                    ; $61DC
    dec c                                         ; $61DD
    dec c                                         ; $61DE
    dec c                                         ; $61DF
    ld a, [hl+]                                   ; $61E0
    ld [bc], a                                    ; $61E1
    inc c                                         ; $61E2
    ld a, [hl+]                                   ; $61E3
    ld [bc], a                                    ; $61E4
    dec c                                         ; $61E5
    dec c                                         ; $61E6
    dec c                                         ; $61E7
    ld a, [hl+]                                   ; $61E8
    ld [bc], a                                    ; $61E9
    inc c                                         ; $61EA
    ld a, [hl+]                                   ; $61EB
    ld [bc], a                                    ; $61EC
    dec c                                         ; $61ED
    dec c                                         ; $61EE
    dec c                                         ; $61EF
    ld a, [hl+]                                   ; $61F0
    ld [bc], a                                    ; $61F1
    inc c                                         ; $61F2
    ld a, [hl+]                                   ; $61F3
    ld [bc], a                                    ; $61F4
    dec c                                         ; $61F5
    dec c                                         ; $61F6
    dec c                                         ; $61F7
    ld a, [hl+]                                   ; $61F8
    ld [bc], a                                    ; $61F9
    inc c                                         ; $61FA
    ld a, [hl+]                                   ; $61FB
    ld [bc], a                                    ; $61FC
    dec c                                         ; $61FD
    dec c                                         ; $61FE
    dec c                                         ; $61FF
    ldh a, [hScratchB]                            ; $6200
    dec a                                         ; $6202
    jr z, jr_00a_620d                             ; $6203

    ldh [hScratchB], a                            ; $6205
    ld a, c                                       ; $6207
    add $20                                       ; $6208
    ld c, a                                       ; $620A
    jr jr_00a_61c0                                ; $620B

jr_00a_620d:
    ldh a, [hScratchA]                            ; $620D
    dec a                                         ; $620F
    ret z                                         ; $6210

    ldh [hScratchA], a                            ; $6211
    ld e, $00                                     ; $6213
    inc d                                         ; $6215
    ld c, $0e                                     ; $6216
    dec b                                         ; $6218
    jr jr_00a_61bc                                ; $6219

; C: left half of the picture = right half of the photo mirrored; = slot 01 applied to the photo flipped upside down;
; reads x 64-127, y 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s)
; 41; scratch FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx41_MirrorRtoL_OnFlipV::
    ld hl, $a180                                  ; $621B
    ld de, wPhotoImage + $d8e                     ; $621E
    ld b, $74                                     ; $6221
    ld a, $0e                                     ; $6223
    ldh [hScratchA], a                            ; $6225

jr_00a_6227:
    ld a, $08                                     ; $6227
    ldh [hScratchB], a                            ; $6229

jr_00a_622b:
    ld a, $08                                     ; $622B
    ldh [hScratchD], a                            ; $622D

jr_00a_622f:
    ld a, [hl+]                                   ; $622F
    ld [de], a                                    ; $6230
    ld c, a                                       ; $6231
    ld a, [bc]                                    ; $6232
    ld c, a                                       ; $6233
    ld a, e                                       ; $6234
    xor $f0                                       ; $6235
    ld e, a                                       ; $6237
    ld a, c                                       ; $6238
    ld [de], a                                    ; $6239
    inc e                                         ; $623A
    ld a, [hl+]                                   ; $623B
    ld c, a                                       ; $623C
    ld a, [bc]                                    ; $623D
    ld [de], a                                    ; $623E
    ld a, e                                       ; $623F
    xor $f0                                       ; $6240
    ld e, a                                       ; $6242
    ld a, c                                       ; $6243
    ld [de], a                                    ; $6244
    dec e                                         ; $6245
    dec e                                         ; $6246
    dec e                                         ; $6247
    ldh a, [hScratchD]                            ; $6248
    dec a                                         ; $624A
    ldh [hScratchD], a                            ; $624B
    jr nz, jr_00a_622f                            ; $624D

    ld a, e                                       ; $624F
    add $20                                       ; $6250
    ld e, a                                       ; $6252
    ldh a, [hScratchB]                            ; $6253
    dec a                                         ; $6255
    jr z, jr_00a_625c                             ; $6256

    ldh [hScratchB], a                            ; $6258
    jr jr_00a_622b                                ; $625A

jr_00a_625c:
    ldh a, [hScratchA]                            ; $625C
    dec a                                         ; $625E
    ret z                                         ; $625F

    ldh [hScratchA], a                            ; $6260
    ld e, $8e                                     ; $6262
    dec d                                         ; $6264
    ld l, $80                                     ; $6265
    jr jr_00a_6227                                ; $6267

; C: right half of the picture = left half of the photo mirrored; = slot 02 applied to the photo flipped upside down;
; reads x 0-63, y 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 42;
; scratch FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx42_MirrorLtoR_OnFlipV::
    ld hl, $a100                                  ; $6269
    ld de, wPhotoImage + $d0e                     ; $626C
    ld b, $74                                     ; $626F
    ld a, $0e                                     ; $6271
    ldh [hScratchA], a                            ; $6273

jr_00a_6275:
    ld a, $08                                     ; $6275
    ldh [hScratchB], a                            ; $6277

jr_00a_6279:
    ld a, $08                                     ; $6279
    ldh [hScratchD], a                            ; $627B

jr_00a_627d:
    ld a, [hl+]                                   ; $627D
    ld [de], a                                    ; $627E
    ld c, a                                       ; $627F
    ld a, [bc]                                    ; $6280
    ld c, a                                       ; $6281
    ld a, e                                       ; $6282
    xor $f0                                       ; $6283
    ld e, a                                       ; $6285
    ld a, c                                       ; $6286
    ld [de], a                                    ; $6287
    inc e                                         ; $6288
    ld a, [hl+]                                   ; $6289
    ld c, a                                       ; $628A
    ld a, [bc]                                    ; $628B
    ld [de], a                                    ; $628C
    ld a, e                                       ; $628D
    xor $f0                                       ; $628E
    ld e, a                                       ; $6290
    ld a, c                                       ; $6291
    ld [de], a                                    ; $6292
    dec e                                         ; $6293
    dec e                                         ; $6294
    dec e                                         ; $6295
    ldh a, [hScratchD]                            ; $6296
    dec a                                         ; $6298
    ldh [hScratchD], a                            ; $6299
    jr nz, jr_00a_627d                            ; $629B

    ld a, e                                       ; $629D
    add $20                                       ; $629E
    ld e, a                                       ; $62A0
    ldh a, [hScratchB]                            ; $62A1
    dec a                                         ; $62A3
    jr z, jr_00a_62aa                             ; $62A4

    ldh [hScratchB], a                            ; $62A6
    jr jr_00a_6279                                ; $62A8

jr_00a_62aa:
    ldh a, [hScratchA]                            ; $62AA
    dec a                                         ; $62AC
    ret z                                         ; $62AD

    ldh [hScratchA], a                            ; $62AE
    dec d                                         ; $62B0
    ld e, $0e                                     ; $62B1
    inc h                                         ; $62B3
    ld l, $00                                     ; $62B4
    jr jr_00a_6275                                ; $62B6

; C: the middle band of the photo stretched to double height; = slot 05 with its picture flipped upside down; reads x
; 0-127, y 24-79; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 45; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx45_StretchV2x_FlipV::
    ld hl, $a400                                  ; $62B8
    ld de, wPhotoImage + $d0c                     ; $62BB
    ld a, $07                                     ; $62BE
    ldh [hScratchA], a                            ; $62C0

jr_00a_62c2:
    ld a, $10                                     ; $62C2
    ldh [hScratchB], a                            ; $62C4

jr_00a_62c6:
    ld a, $04                                     ; $62C6
    ldh [hScratchD], a                            ; $62C8

jr_00a_62ca:
    ld a, [hl+]                                   ; $62CA
    ld [de], a                                    ; $62CB
    inc e                                         ; $62CC
    inc e                                         ; $62CD
    ld [de], a                                    ; $62CE
    dec e                                         ; $62CF
    ld a, [hl+]                                   ; $62D0
    ld [de], a                                    ; $62D1
    inc e                                         ; $62D2
    inc e                                         ; $62D3
    ld [de], a                                    ; $62D4
    ld a, e                                       ; $62D5
    sub $07                                       ; $62D6
    ld e, a                                       ; $62D8
    ldh a, [hScratchD]                            ; $62D9
    dec a                                         ; $62DB
    ldh [hScratchD], a                            ; $62DC
    jr nz, jr_00a_62ca                            ; $62DE

    dec d                                         ; $62E0
    ld a, e                                       ; $62E1
    add $10                                       ; $62E2
    ld e, a                                       ; $62E4
    ld a, $04                                     ; $62E5
    ldh [hScratchD], a                            ; $62E7

jr_00a_62e9:
    ld a, [hl+]                                   ; $62E9
    ld [de], a                                    ; $62EA
    inc e                                         ; $62EB
    inc e                                         ; $62EC
    ld [de], a                                    ; $62ED
    dec e                                         ; $62EE
    ld a, [hl+]                                   ; $62EF
    ld [de], a                                    ; $62F0
    inc e                                         ; $62F1
    inc e                                         ; $62F2
    ld [de], a                                    ; $62F3
    ld a, e                                       ; $62F4
    sub $07                                       ; $62F5
    ld e, a                                       ; $62F7
    ldh a, [hScratchD]                            ; $62F8
    dec a                                         ; $62FA
    ldh [hScratchD], a                            ; $62FB
    jr nz, jr_00a_62e9                            ; $62FD

    ld a, e                                       ; $62FF
    add $20                                       ; $6300
    ld e, a                                       ; $6302
    ldh a, [hScratchB]                            ; $6303
    dec a                                         ; $6305
    jr z, jr_00a_630d                             ; $6306

    ldh [hScratchB], a                            ; $6308
    inc d                                         ; $630A
    jr jr_00a_62c6                                ; $630B

jr_00a_630d:
    ldh a, [hScratchA]                            ; $630D
    dec a                                         ; $630F
    ret z                                         ; $6310

    ldh [hScratchA], a                            ; $6311
    dec d                                         ; $6313
    ld e, $0c                                     ; $6314
    jr jr_00a_62c2                                ; $6316

; C: the middle columns of the photo stretched to double width; = slot 06 applied to the photo flipped upside down;
; reads x 32-95, y 0-111; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 46;
; scratch FF8A-FF8D loops; selected by the game (06:60DB); was ...
Fx46_StretchH2x_OnFlipV::
    ld hl, $a140                                  ; $6318
    ld de, wPhotoImage + $d0e                     ; $631B
    ld a, $0e                                     ; $631E
    ldh [hScratchA], a                            ; $6320

jr_00a_6322:
    ld a, $08                                     ; $6322
    ldh [hScratchB], a                            ; $6324

jr_00a_6326:
    ld a, $08                                     ; $6326
    ldh [hScratchD], a                            ; $6328

jr_00a_632a:
    ld a, [hl+]                                   ; $632A
    ld c, a                                       ; $632B
    ld b, $75                                     ; $632C
    ld a, [bc]                                    ; $632E
    ld [de], a                                    ; $632F
    ld a, e                                       ; $6330
    add $10                                       ; $6331
    ld e, a                                       ; $6333
    ld b, $76                                     ; $6334
    ld a, [bc]                                    ; $6336
    ld [de], a                                    ; $6337
    inc e                                         ; $6338
    ld a, [hl+]                                   ; $6339
    ld c, a                                       ; $633A
    ld b, $76                                     ; $633B
    ld a, [bc]                                    ; $633D
    ld [de], a                                    ; $633E
    ld a, e                                       ; $633F
    sub $10                                       ; $6340
    ld e, a                                       ; $6342
    ld b, $75                                     ; $6343
    ld a, [bc]                                    ; $6345
    ld [de], a                                    ; $6346
    dec e                                         ; $6347
    dec e                                         ; $6348
    dec e                                         ; $6349
    ldh a, [hScratchD]                            ; $634A
    dec a                                         ; $634C
    ldh [hScratchD], a                            ; $634D
    jr nz, jr_00a_632a                            ; $634F

    ld a, e                                       ; $6351
    add $30                                       ; $6352
    ld e, a                                       ; $6354
    ldh a, [hScratchB]                            ; $6355
    dec a                                         ; $6357
    jr z, jr_00a_635e                             ; $6358

    ldh [hScratchB], a                            ; $635A
    jr jr_00a_6326                                ; $635C

jr_00a_635e:
    ldh a, [hScratchA]                            ; $635E
    dec a                                         ; $6360
    ret z                                         ; $6361

    ldh [hScratchA], a                            ; $6362
    dec d                                         ; $6364
    inc h                                         ; $6365
    ld l, $40                                     ; $6366
    jr jr_00a_6322                                ; $6368

; C: the centre of the photo magnified x2 (both axes); = slot 07 with its picture flipped upside down; reads x 32-95,
; y 24-79; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 47; scratch
; FF8A-FF8D loops; selected by the game (06:60DB); was Fx47_Copy_A440toCD0C
Fx47_Zoom2x_FlipV::
    ld hl, $a440                                  ; $636A
    ld de, wPhotoImage + $d0c                     ; $636D
    ld a, $07                                     ; $6370
    ldh [hScratchA], a                            ; $6372

; C: pass top of the zoom 2x, flipped vertically loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-
; entered after a source / destination pointer step (branch target; code read 2026-10-19)
Fx47_Zoom2x_FlipV_PassTop::
    ld a, $08                                     ; $6374
    ldh [hScratchB], a                            ; $6376

; C: group top of the zoom 2x, flipped vertically loop: sets the column counter $FF8D = 4, then reads the next tile
; rows through the lookup table (branch target; code read 2026-10-19)
Fx47_Zoom2x_FlipV_GroupTop::
    ld a, $04                                     ; $6378
    ldh [hScratchD], a                            ; $637A

jr_00a_637c:
    ld a, [hl+]                                   ; $637C
    ld c, a                                       ; $637D
    ld b, $75                                     ; $637E
    ld a, [bc]                                    ; $6380
    ld [de], a                                    ; $6381
    inc e                                         ; $6382
    inc e                                         ; $6383
    ld [de], a                                    ; $6384
    ld a, e                                       ; $6385
    add $0e                                       ; $6386
    ld e, a                                       ; $6388
    ld b, $76                                     ; $6389
    ld a, [bc]                                    ; $638B
    ld [de], a                                    ; $638C
    inc e                                         ; $638D
    inc e                                         ; $638E
    ld [de], a                                    ; $638F
    ld a, e                                       ; $6390
    sub $11                                       ; $6391
    ld e, a                                       ; $6393
    ld a, [hl+]                                   ; $6394
    ld c, a                                       ; $6395
    ld b, $75                                     ; $6396
    ld a, [bc]                                    ; $6398
    ld [de], a                                    ; $6399
    inc e                                         ; $639A
    inc e                                         ; $639B
    ld [de], a                                    ; $639C
    ld a, e                                       ; $639D
    add $0e                                       ; $639E
    ld e, a                                       ; $63A0
    ld b, $76                                     ; $63A1
    ld a, [bc]                                    ; $63A3
    ld [de], a                                    ; $63A4
    inc e                                         ; $63A5
    inc e                                         ; $63A6
    ld [de], a                                    ; $63A7
    ld a, e                                       ; $63A8
    sub $17                                       ; $63A9
    ld e, a                                       ; $63AB
    ldh a, [hScratchD]                            ; $63AC
    dec a                                         ; $63AE
    ldh [hScratchD], a                            ; $63AF
    jr nz, jr_00a_637c                            ; $63B1

    dec d                                         ; $63B3
    ld a, e                                       ; $63B4
    add $10                                       ; $63B5
    ld e, a                                       ; $63B7
    ld a, $04                                     ; $63B8
    ldh [hScratchD], a                            ; $63BA

jr_00a_63bc:
    ld a, [hl+]                                   ; $63BC
    ld c, a                                       ; $63BD
    ld b, $75                                     ; $63BE
    ld a, [bc]                                    ; $63C0
    ld [de], a                                    ; $63C1
    inc e                                         ; $63C2
    inc e                                         ; $63C3
    ld [de], a                                    ; $63C4
    ld a, e                                       ; $63C5
    add $0e                                       ; $63C6
    ld e, a                                       ; $63C8
    ld b, $76                                     ; $63C9
    ld a, [bc]                                    ; $63CB
    ld [de], a                                    ; $63CC
    inc e                                         ; $63CD
    inc e                                         ; $63CE
    ld [de], a                                    ; $63CF
    ld a, e                                       ; $63D0
    sub $11                                       ; $63D1
    ld e, a                                       ; $63D3
    ld a, [hl+]                                   ; $63D4
    ld c, a                                       ; $63D5
    ld b, $75                                     ; $63D6
    ld a, [bc]                                    ; $63D8
    ld [de], a                                    ; $63D9
    inc e                                         ; $63DA
    inc e                                         ; $63DB
    ld [de], a                                    ; $63DC
    ld a, e                                       ; $63DD
    add $0e                                       ; $63DE
    ld e, a                                       ; $63E0
    ld b, $76                                     ; $63E1
    ld a, [bc]                                    ; $63E3
    ld [de], a                                    ; $63E4
    inc e                                         ; $63E5
    inc e                                         ; $63E6
    ld [de], a                                    ; $63E7
    ld a, e                                       ; $63E8
    sub $17                                       ; $63E9
    ld e, a                                       ; $63EB
    ldh a, [hScratchD]                            ; $63EC
    dec a                                         ; $63EE
    ldh [hScratchD], a                            ; $63EF
    jr nz, jr_00a_63bc                            ; $63F1

    ldh a, [hScratchB]                            ; $63F3
    dec a                                         ; $63F5
    jr z, jr_00a_6402                             ; $63F6

    ldh [hScratchB], a                            ; $63F8
    inc d                                         ; $63FA
    ld a, e                                       ; $63FB
    add $30                                       ; $63FC
    ld e, a                                       ; $63FE
    jp Fx47_Zoom2x_FlipV_GroupTop                 ; $63FF


jr_00a_6402:
    ldh a, [hScratchA]                            ; $6402
    dec a                                         ; $6404
    ret z                                         ; $6405

    ldh [hScratchA], a                            ; $6406
    inc h                                         ; $6408
    ld l, $40                                     ; $6409
    dec d                                         ; $640B
    ld e, $0c                                     ; $640C
    jp Fx47_Zoom2x_FlipV_PassTop                  ; $640E


; C: the photo reduced to half size (every second pixel and row) and tiled 2 x 2; = slot 08 with its picture flipped
; upside down; reads x 0-126, y 0-110; BGB hook run (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect
; table slot(s) 48; scratch FF8A-FF8D loops; selected by the game (06:60DB); ...
Fx48_Reduce2xTile2x2_FlipV::
    ld hl, $a100                                  ; $6411
    ld de, wPhotoImage + $60e                     ; $6414
    ld b, $79                                     ; $6417
    ld a, $07                                     ; $6419
    ldh [hScratchA], a                            ; $641B

; C: pass top of the 2x reduction, flipped vertically loop: sets the row counter $FF8B = 8 and falls into _GroupTop;
; re-entered after a source / destination pointer step (branch target; code read 2026-10-19)
Fx48_Reduce2xTile2x2_FlipV_PassTop::
    ld a, $08                                     ; $641D
    ldh [hScratchB], a                            ; $641F

; C: group top of the 2x reduction, flipped vertically loop: sets the column counter $FF8D = 4, then reads the next
; tile rows through the lookup table (branch target; code read 2026-10-19)
Fx48_Reduce2xTile2x2_FlipV_GroupTop::
    ld a, $04                                     ; $6421
    ldh [hScratchD], a                            ; $6423

jr_00a_6425:
    ld c, [hl]                                    ; $6425
    ld a, [bc]                                    ; $6426
    swap a                                        ; $6427
    ldh [hScratchC], a                            ; $6429
    ld a, l                                       ; $642B
    add $10                                       ; $642C
    ld l, a                                       ; $642E
    ld c, [hl]                                    ; $642F
    ld a, [bc]                                    ; $6430
    ld c, a                                       ; $6431
    ldh a, [hScratchC]                            ; $6432
    or c                                          ; $6434
    ld c, a                                       ; $6435
    ld [de], a                                    ; $6436
    ld a, e                                       ; $6437
    add $80                                       ; $6438
    ld e, a                                       ; $643A
    ld a, c                                       ; $643B
    ld [de], a                                    ; $643C
    ld a, d                                       ; $643D
    add $07                                       ; $643E
    ld d, a                                       ; $6440
    ld a, c                                       ; $6441
    ld [de], a                                    ; $6442
    ld a, e                                       ; $6443
    add $80                                       ; $6444
    ld e, a                                       ; $6446
    ld a, c                                       ; $6447
    ld [de], a                                    ; $6448
    ld a, d                                       ; $6449
    sub $07                                       ; $644A
    ld d, a                                       ; $644C
    inc e                                         ; $644D
    ld a, l                                       ; $644E
    sub $0f                                       ; $644F
    ld l, a                                       ; $6451
    ld c, [hl]                                    ; $6452
    ld a, [bc]                                    ; $6453
    swap a                                        ; $6454
    ldh [hScratchC], a                            ; $6456
    ld a, l                                       ; $6458
    add $10                                       ; $6459
    ld l, a                                       ; $645B
    ld c, [hl]                                    ; $645C
    ld a, [bc]                                    ; $645D
    ld c, a                                       ; $645E
    ldh a, [hScratchC]                            ; $645F
    or c                                          ; $6461
    ld c, a                                       ; $6462
    ld [de], a                                    ; $6463
    ld a, e                                       ; $6464
    add $80                                       ; $6465
    ld e, a                                       ; $6467
    ld a, c                                       ; $6468
    ld [de], a                                    ; $6469
    ld a, d                                       ; $646A
    add $07                                       ; $646B
    ld d, a                                       ; $646D
    ld a, c                                       ; $646E
    ld [de], a                                    ; $646F
    ld a, e                                       ; $6470
    add $80                                       ; $6471
    ld e, a                                       ; $6473
    ld a, c                                       ; $6474
    ld [de], a                                    ; $6475
    ld a, d                                       ; $6476
    sub $07                                       ; $6477
    ld d, a                                       ; $6479
    dec e                                         ; $647A
    dec e                                         ; $647B
    dec e                                         ; $647C
    ld a, l                                       ; $647D
    sub $0d                                       ; $647E
    ld l, a                                       ; $6480
    ldh a, [hScratchD]                            ; $6481
    dec a                                         ; $6483
    ldh [hScratchD], a                            ; $6484
    jr nz, jr_00a_6425                            ; $6486

    inc h                                         ; $6488
    ld a, l                                       ; $6489
    sub $10                                       ; $648A
    ld l, a                                       ; $648C
    ld a, $04                                     ; $648D
    ldh [hScratchD], a                            ; $648F

jr_00a_6491:
    ld c, [hl]                                    ; $6491
    ld a, [bc]                                    ; $6492
    swap a                                        ; $6493
    ldh [hScratchC], a                            ; $6495
    ld a, l                                       ; $6497
    add $10                                       ; $6498
    ld l, a                                       ; $649A
    ld c, [hl]                                    ; $649B
    ld a, [bc]                                    ; $649C
    ld c, a                                       ; $649D
    ldh a, [hScratchC]                            ; $649E
    or c                                          ; $64A0
    ld c, a                                       ; $64A1
    ld [de], a                                    ; $64A2
    ld a, e                                       ; $64A3
    add $80                                       ; $64A4
    ld e, a                                       ; $64A6
    ld a, c                                       ; $64A7
    ld [de], a                                    ; $64A8
    ld a, d                                       ; $64A9
    add $07                                       ; $64AA
    ld d, a                                       ; $64AC
    ld a, c                                       ; $64AD
    ld [de], a                                    ; $64AE
    ld a, e                                       ; $64AF
    add $80                                       ; $64B0
    ld e, a                                       ; $64B2
    ld a, c                                       ; $64B3
    ld [de], a                                    ; $64B4
    ld a, d                                       ; $64B5
    sub $07                                       ; $64B6
    ld d, a                                       ; $64B8
    inc e                                         ; $64B9
    ld a, l                                       ; $64BA
    sub $0f                                       ; $64BB
    ld l, a                                       ; $64BD
    ld c, [hl]                                    ; $64BE
    ld a, [bc]                                    ; $64BF
    swap a                                        ; $64C0
    ldh [hScratchC], a                            ; $64C2
    ld a, l                                       ; $64C4
    add $10                                       ; $64C5
    ld l, a                                       ; $64C7
    ld c, [hl]                                    ; $64C8
    ld a, [bc]                                    ; $64C9
    ld c, a                                       ; $64CA
    ldh a, [hScratchC]                            ; $64CB
    or c                                          ; $64CD
    ld c, a                                       ; $64CE
    ld [de], a                                    ; $64CF
    ld a, e                                       ; $64D0
    add $80                                       ; $64D1
    ld e, a                                       ; $64D3
    ld a, c                                       ; $64D4
    ld [de], a                                    ; $64D5
    ld a, d                                       ; $64D6
    add $07                                       ; $64D7
    ld d, a                                       ; $64D9
    ld a, c                                       ; $64DA
    ld [de], a                                    ; $64DB
    ld a, e                                       ; $64DC
    add $80                                       ; $64DD
    ld e, a                                       ; $64DF
    ld a, c                                       ; $64E0
    ld [de], a                                    ; $64E1
    ld a, d                                       ; $64E2
    sub $07                                       ; $64E3
    ld d, a                                       ; $64E5
    dec e                                         ; $64E6
    dec e                                         ; $64E7
    dec e                                         ; $64E8
    ld a, l                                       ; $64E9
    sub $0d                                       ; $64EA
    ld l, a                                       ; $64EC
    ldh a, [hScratchD]                            ; $64ED
    dec a                                         ; $64EF
    ldh [hScratchD], a                            ; $64F0
    jr nz, jr_00a_6491                            ; $64F2

    ldh a, [hScratchB]                            ; $64F4
    dec a                                         ; $64F6
    jr z, jr_00a_6507                             ; $64F7

    ldh [hScratchB], a                            ; $64F9
    dec h                                         ; $64FB
    ld a, l                                       ; $64FC
    add $10                                       ; $64FD
    ld l, a                                       ; $64FF
    ld a, e                                       ; $6500
    add $20                                       ; $6501
    ld e, a                                       ; $6503
    jp Fx48_Reduce2xTile2x2_FlipV_GroupTop        ; $6504


jr_00a_6507:
    ldh a, [hScratchA]                            ; $6507
    dec a                                         ; $6509
    ret z                                         ; $650A

    ldh [hScratchA], a                            ; $650B
    dec d                                         ; $650D
    ld e, $0e                                     ; $650E
    inc h                                         ; $6510
    ld l, $00                                     ; $6511
    jp Fx48_Reduce2xTile2x2_FlipV_PassTop         ; $6513


; C: the photo reduced to half size (every second pixel and row) into the TL quadrant; = slot 09 with its picture
; flipped upside down inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx49_Reduce2xQuadTL_FlipV::
    ld de, wPhotoImage + $60e                     ; $6516
    jp FxShared_ReduceBody_G2                     ; $6519


; C: the photo reduced to half size (every second pixel and row) into the TR quadrant; = slot 0A with its picture
; flipped upside down inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx4A_Reduce2xQuadTR_FlipV::
    ld de, wPhotoImage + $68e                     ; $651C
    jp FxShared_ReduceBody_G2                     ; $651F


; C: the photo reduced to half size (every second pixel and row) into the BL quadrant; = slot 0B with its picture
; flipped upside down inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx4B_Reduce2xQuadBL_FlipV::
    ld de, wPhotoImage + $d0e                     ; $6522
    jp FxShared_ReduceBody_G2                     ; $6525


; C: the photo reduced to half size (every second pixel and row) into the BR quadrant; = slot 0C with its picture
; flipped upside down inside the part of the buffer it writes (56 of 224 tiles; the rest of the buffer is left alone);
; reads x 0-126, y 0-110; BGB hook run ...
Fx4C_Reduce2xQuadBR_FlipV::
    ld de, wPhotoImage + $d8e                     ; $6528
    jp FxShared_ReduceBody_G2                     ; $652B


; C: copy of part of the photo (LeftHalf); = slot 0D applied to the photo flipped upside down (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-63, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 4D; scratch FF8A-FF8D loops; never ...
Fx4D_CopyLeftHalf_OnFlipV::
    ld hl, $a100                                  ; $652E
    ld bc, wPhotoImage + $d0e                     ; $6531
    ld a, $0e                                     ; $6534
    ldh [hScratchA], a                            ; $6536

jr_00a_6538:
    ld a, $08                                     ; $6538
    ldh [hScratchB], a                            ; $653A

jr_00a_653c:
    ld a, $08                                     ; $653C
    ldh [hScratchD], a                            ; $653E

jr_00a_6540:
    ld a, [hl+]                                   ; $6540
    ld [bc], a                                    ; $6541
    inc c                                         ; $6542
    ld a, [hl+]                                   ; $6543
    ld [bc], a                                    ; $6544
    dec c                                         ; $6545
    dec c                                         ; $6546
    dec c                                         ; $6547
    ldh a, [hScratchD]                            ; $6548
    dec a                                         ; $654A
    ldh [hScratchD], a                            ; $654B
    jr nz, jr_00a_6540                            ; $654D

    ldh a, [hScratchB]                            ; $654F
    dec a                                         ; $6551
    jr z, jr_00a_655c                             ; $6552

    ldh [hScratchB], a                            ; $6554
    ld a, c                                       ; $6556
    add $20                                       ; $6557
    ld c, a                                       ; $6559
    jr jr_00a_653c                                ; $655A

jr_00a_655c:
    ldh a, [hScratchA]                            ; $655C
    dec a                                         ; $655E
    ret z                                         ; $655F

    ldh [hScratchA], a                            ; $6560
    dec b                                         ; $6562
    ld c, $0e                                     ; $6563
    inc h                                         ; $6565
    ld l, $00                                     ; $6566
    jr jr_00a_6538                                ; $6568

; C: copy of part of the photo (RightHalf); = slot 0E applied to the photo flipped upside down (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 64-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 4E; scratch FF8A-FF8D loops; selected
; ...
Fx4E_CopyRightHalf_OnFlipV::
    ld hl, $a180                                  ; $656A
    ld bc, wPhotoImage + $d8e                     ; $656D
    ld a, $0e                                     ; $6570
    ldh [hScratchA], a                            ; $6572

jr_00a_6574:
    ld a, $08                                     ; $6574
    ldh [hScratchB], a                            ; $6576

jr_00a_6578:
    ld a, $08                                     ; $6578
    ldh [hScratchD], a                            ; $657A

jr_00a_657c:
    ld a, [hl+]                                   ; $657C
    ld [bc], a                                    ; $657D
    inc c                                         ; $657E
    ld a, [hl+]                                   ; $657F
    ld [bc], a                                    ; $6580
    dec c                                         ; $6581
    dec c                                         ; $6582
    dec c                                         ; $6583
    ldh a, [hScratchD]                            ; $6584
    dec a                                         ; $6586
    ldh [hScratchD], a                            ; $6587
    jr nz, jr_00a_657c                            ; $6589

    ldh a, [hScratchB]                            ; $658B
    dec a                                         ; $658D
    jr z, jr_00a_6598                             ; $658E

    ldh [hScratchB], a                            ; $6590
    ld a, c                                       ; $6592
    add $20                                       ; $6593
    ld c, a                                       ; $6595
    jr jr_00a_6578                                ; $6596

jr_00a_6598:
    ldh a, [hScratchA]                            ; $6598
    dec a                                         ; $659A
    ret z                                         ; $659B

    ldh [hScratchA], a                            ; $659C
    dec b                                         ; $659E
    ld c, $8e                                     ; $659F
    ld l, $80                                     ; $65A1
    jr jr_00a_6574                                ; $65A3

; C: copy of part of the photo (TopHalf); = slot 0F applied to the photo flipped upside down (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 56-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 4F; scratch FF8A-FF8D loops; never ...
Fx4F_CopyTopHalf_OnFlipV::
    ld hl, $a800                                  ; $65A5
    ld bc, wPhotoImage + $60e                     ; $65A8
    ld a, $07                                     ; $65AB
    ldh [hScratchA], a                            ; $65AD

jr_00a_65af:
    ld a, $10                                     ; $65AF
    ldh [hScratchB], a                            ; $65B1

jr_00a_65b3:
    ld a, $08                                     ; $65B3
    ldh [hScratchD], a                            ; $65B5

jr_00a_65b7:
    ld a, [hl+]                                   ; $65B7
    ld [bc], a                                    ; $65B8
    inc c                                         ; $65B9
    ld a, [hl+]                                   ; $65BA
    ld [bc], a                                    ; $65BB
    dec c                                         ; $65BC
    dec c                                         ; $65BD
    dec c                                         ; $65BE
    ldh a, [hScratchD]                            ; $65BF
    dec a                                         ; $65C1
    ldh [hScratchD], a                            ; $65C2
    jr nz, jr_00a_65b7                            ; $65C4

    ldh a, [hScratchB]                            ; $65C6
    dec a                                         ; $65C8
    jr z, jr_00a_65d3                             ; $65C9

    ldh [hScratchB], a                            ; $65CB
    ld a, c                                       ; $65CD
    add $20                                       ; $65CE
    ld c, a                                       ; $65D0
    jr jr_00a_65b3                                ; $65D1

jr_00a_65d3:
    ldh a, [hScratchA]                            ; $65D3
    dec a                                         ; $65D5
    ret z                                         ; $65D6

    ldh [hScratchA], a                            ; $65D7
    dec b                                         ; $65D9
    ld c, $0e                                     ; $65DA
    jr jr_00a_65af                                ; $65DC

; C: copy of part of the photo (BottomHalf); = slot 10 applied to the photo flipped upside down (112 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-55; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 50; scratch FF8A-FF8D loops; selected
; ...
Fx50_CopyBottomHalf_OnFlipV::
    ld hl, $a100                                  ; $65DE
    ld bc, wPhotoImage + $d0e                     ; $65E1
    ld a, $07                                     ; $65E4
    ldh [hScratchA], a                            ; $65E6

jr_00a_65e8:
    ld a, $10                                     ; $65E8
    ldh [hScratchB], a                            ; $65EA

jr_00a_65ec:
    ld a, $08                                     ; $65EC
    ldh [hScratchD], a                            ; $65EE

jr_00a_65f0:
    ld a, [hl+]                                   ; $65F0
    ld [bc], a                                    ; $65F1
    inc c                                         ; $65F2
    ld a, [hl+]                                   ; $65F3
    ld [bc], a                                    ; $65F4
    dec c                                         ; $65F5
    dec c                                         ; $65F6
    dec c                                         ; $65F7
    ldh a, [hScratchD]                            ; $65F8
    dec a                                         ; $65FA
    ldh [hScratchD], a                            ; $65FB
    jr nz, jr_00a_65f0                            ; $65FD

    ldh a, [hScratchB]                            ; $65FF
    dec a                                         ; $6601
    jr z, jr_00a_660c                             ; $6602

    ldh [hScratchB], a                            ; $6604
    ld a, c                                       ; $6606
    add $20                                       ; $6607
    ld c, a                                       ; $6609
    jr jr_00a_65ec                                ; $660A

jr_00a_660c:
    ldh a, [hScratchA]                            ; $660C
    dec a                                         ; $660E
    ret z                                         ; $660F

    ldh [hScratchA], a                            ; $6610
    dec b                                         ; $6612
    ld c, $0e                                     ; $6613
    jr jr_00a_65e8                                ; $6615

; C: copy of part of the photo (Quads TR BL); = slot 11 applied to the photo flipped upside down (112 of 224 tiles;
; the rest of the buffer is left alone); reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 51; scratch FF8A-FF8D loops; ...
Fx51_CopyQuads_TR_BL_OnFlipV::
    ld hl, $a100                                  ; $6617
    ld bc, wPhotoImage + $d0e                     ; $661A
    ld a, $07                                     ; $661D
    ldh [hScratchA], a                            ; $661F

jr_00a_6621:
    ld a, $08                                     ; $6621
    ldh [hScratchB], a                            ; $6623

jr_00a_6625:
    ld a, $08                                     ; $6625
    ldh [hScratchD], a                            ; $6627

jr_00a_6629:
    ld a, [hl+]                                   ; $6629
    ld [bc], a                                    ; $662A
    inc c                                         ; $662B
    ld a, [hl+]                                   ; $662C
    ld [bc], a                                    ; $662D
    dec c                                         ; $662E
    dec c                                         ; $662F
    dec c                                         ; $6630
    ldh a, [hScratchD]                            ; $6631
    dec a                                         ; $6633
    ldh [hScratchD], a                            ; $6634
    jr nz, jr_00a_6629                            ; $6636

    ldh a, [hScratchB]                            ; $6638
    dec a                                         ; $663A
    jr z, jr_00a_6645                             ; $663B

    ldh [hScratchB], a                            ; $663D
    ld a, c                                       ; $663F
    add $20                                       ; $6640
    ld c, a                                       ; $6642
    jr jr_00a_6625                                ; $6643

jr_00a_6645:
    ldh a, [hScratchA]                            ; $6645
    dec a                                         ; $6647
    jr z, jr_00a_6654                             ; $6648

    ldh [hScratchA], a                            ; $664A
    dec b                                         ; $664C
    ld c, $0e                                     ; $664D
    inc h                                         ; $664F
    ld l, $00                                     ; $6650
    jr jr_00a_6621                                ; $6652

jr_00a_6654:
    ld hl, $a880                                  ; $6654
    ld bc, wPhotoImage + $68e                     ; $6657
    ld a, $07                                     ; $665A
    ldh [hScratchA], a                            ; $665C

jr_00a_665e:
    ld a, $08                                     ; $665E
    ldh [hScratchB], a                            ; $6660

jr_00a_6662:
    ld a, $08                                     ; $6662
    ldh [hScratchD], a                            ; $6664

jr_00a_6666:
    ld a, [hl+]                                   ; $6666
    ld [bc], a                                    ; $6667
    inc c                                         ; $6668
    ld a, [hl+]                                   ; $6669
    ld [bc], a                                    ; $666A
    dec c                                         ; $666B
    dec c                                         ; $666C
    dec c                                         ; $666D
    ldh a, [hScratchD]                            ; $666E
    dec a                                         ; $6670
    ldh [hScratchD], a                            ; $6671
    jr nz, jr_00a_6666                            ; $6673

    ldh a, [hScratchB]                            ; $6675
    dec a                                         ; $6677
    jr z, jr_00a_6682                             ; $6678

    ldh [hScratchB], a                            ; $667A
    ld a, c                                       ; $667C
    add $20                                       ; $667D
    ld c, a                                       ; $667F
    jr jr_00a_6662                                ; $6680

jr_00a_6682:
    ldh a, [hScratchA]                            ; $6682
    dec a                                         ; $6684
    ret z                                         ; $6685

    ldh [hScratchA], a                            ; $6686
    dec b                                         ; $6688
    ld c, $8e                                     ; $6689
    ld l, $80                                     ; $668B
    jr jr_00a_665e                                ; $668D

; C: copy of part of the photo (Quads TR BL BR); = slot 12 applied to the photo flipped upside down (168 of 224 tiles;
; the rest of the buffer is left alone); reads x 0-127, y 0-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 52; scratch FF8A-FF8D loops; ...
Fx52_CopyQuads_TR_BL_BR_OnFlipV::
    ld hl, $a100                                  ; $668F
    ld bc, wPhotoImage + $d0e                     ; $6692
    ld a, $07                                     ; $6695
    ldh [hScratchA], a                            ; $6697

jr_00a_6699:
    ld a, $10                                     ; $6699
    ldh [hScratchB], a                            ; $669B

jr_00a_669d:
    ld a, $08                                     ; $669D
    ldh [hScratchD], a                            ; $669F

jr_00a_66a1:
    ld a, [hl+]                                   ; $66A1
    ld [bc], a                                    ; $66A2
    inc c                                         ; $66A3
    ld a, [hl+]                                   ; $66A4
    ld [bc], a                                    ; $66A5
    dec c                                         ; $66A6
    dec c                                         ; $66A7
    dec c                                         ; $66A8
    ldh a, [hScratchD]                            ; $66A9
    dec a                                         ; $66AB
    ldh [hScratchD], a                            ; $66AC
    jr nz, jr_00a_66a1                            ; $66AE

    ldh a, [hScratchB]                            ; $66B0
    dec a                                         ; $66B2
    jr z, jr_00a_66bd                             ; $66B3

    ldh [hScratchB], a                            ; $66B5
    ld a, c                                       ; $66B7
    add $20                                       ; $66B8
    ld c, a                                       ; $66BA
    jr jr_00a_669d                                ; $66BB

jr_00a_66bd:
    ldh a, [hScratchA]                            ; $66BD
    dec a                                         ; $66BF
    jr z, jr_00a_66c9                             ; $66C0

    ldh [hScratchA], a                            ; $66C2
    dec b                                         ; $66C4
    ld c, $0e                                     ; $66C5
    jr jr_00a_6699                                ; $66C7

jr_00a_66c9:
    ld hl, $a880                                  ; $66C9
    ld bc, wPhotoImage + $68e                     ; $66CC
    ld a, $07                                     ; $66CF
    ldh [hScratchA], a                            ; $66D1

jr_00a_66d3:
    ld a, $08                                     ; $66D3
    ldh [hScratchB], a                            ; $66D5

jr_00a_66d7:
    ld a, $08                                     ; $66D7
    ldh [hScratchD], a                            ; $66D9

jr_00a_66db:
    ld a, [hl+]                                   ; $66DB
    ld [bc], a                                    ; $66DC
    inc c                                         ; $66DD
    ld a, [hl+]                                   ; $66DE
    ld [bc], a                                    ; $66DF
    dec c                                         ; $66E0
    dec c                                         ; $66E1
    dec c                                         ; $66E2
    ldh a, [hScratchD]                            ; $66E3
    dec a                                         ; $66E5
    ldh [hScratchD], a                            ; $66E6
    jr nz, jr_00a_66db                            ; $66E8

    ldh a, [hScratchB]                            ; $66EA
    dec a                                         ; $66EC
    jr z, jr_00a_66f7                             ; $66ED

    ldh [hScratchB], a                            ; $66EF
    ld a, c                                       ; $66F1
    add $20                                       ; $66F2
    ld c, a                                       ; $66F4
    jr jr_00a_66d7                                ; $66F5

jr_00a_66f7:
    ldh a, [hScratchA]                            ; $66F7
    dec a                                         ; $66F9
    ret z                                         ; $66FA

    ldh [hScratchA], a                            ; $66FB
    dec b                                         ; $66FD
    ld c, $8e                                     ; $66FE
    ld l, $80                                     ; $6700
    jr jr_00a_66d3                                ; $6702

; C: copy of part of the photo (Top10Rows); = slot 13 applied to the photo flipped upside down (160 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 32-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 53; scratch FF8A-FF8D loops; never ...
Fx53_CopyTop10Rows_OnFlipV::
    ld hl, $a500                                  ; $6704
    ld bc, wPhotoImage + $90e                     ; $6707
    ld a, $0a                                     ; $670A
    ldh [hScratchA], a                            ; $670C

jr_00a_670e:
    ld a, $10                                     ; $670E
    ldh [hScratchB], a                            ; $6710

jr_00a_6712:
    ld a, $08                                     ; $6712
    ldh [hScratchD], a                            ; $6714

jr_00a_6716:
    ld a, [hl+]                                   ; $6716
    ld [bc], a                                    ; $6717
    inc c                                         ; $6718
    ld a, [hl+]                                   ; $6719
    ld [bc], a                                    ; $671A
    dec c                                         ; $671B
    dec c                                         ; $671C
    dec c                                         ; $671D
    ldh a, [hScratchD]                            ; $671E
    dec a                                         ; $6720
    ldh [hScratchD], a                            ; $6721
    jr nz, jr_00a_6716                            ; $6723

    ldh a, [hScratchB]                            ; $6725
    dec a                                         ; $6727
    jr z, jr_00a_6732                             ; $6728

    ldh [hScratchB], a                            ; $672A
    ld a, c                                       ; $672C
    add $20                                       ; $672D
    ld c, a                                       ; $672F
    jr jr_00a_6712                                ; $6730

jr_00a_6732:
    ldh a, [hScratchA]                            ; $6732
    dec a                                         ; $6734
    ret z                                         ; $6735

    ldh [hScratchA], a                            ; $6736
    dec b                                         ; $6738
    ld c, $0e                                     ; $6739
    jr jr_00a_670e                                ; $673B

; C: copy of part of the photo (Bottom4Rows); = slot 14 applied to the photo flipped upside down (64 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 0-31; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 54; scratch FF8A-FF8D loops; selected
; ...
Fx54_CopyBottom4Rows_OnFlipV::
    ld hl, $a100                                  ; $673D
    ld bc, wPhotoImage + $d0e                     ; $6740
    ld a, $04                                     ; $6743
    ldh [hScratchA], a                            ; $6745

jr_00a_6747:
    ld a, $10                                     ; $6747
    ldh [hScratchB], a                            ; $6749

jr_00a_674b:
    ld a, $08                                     ; $674B
    ldh [hScratchD], a                            ; $674D

jr_00a_674f:
    ld a, [hl+]                                   ; $674F
    ld [bc], a                                    ; $6750
    inc c                                         ; $6751
    ld a, [hl+]                                   ; $6752
    ld [bc], a                                    ; $6753
    dec c                                         ; $6754
    dec c                                         ; $6755
    dec c                                         ; $6756
    ldh a, [hScratchD]                            ; $6757
    dec a                                         ; $6759
    ldh [hScratchD], a                            ; $675A
    jr nz, jr_00a_674f                            ; $675C

    ldh a, [hScratchB]                            ; $675E
    dec a                                         ; $6760
    jr z, jr_00a_676b                             ; $6761

    ldh [hScratchB], a                            ; $6763
    ld a, c                                       ; $6765
    add $20                                       ; $6766
    ld c, a                                       ; $6768
    jr jr_00a_674b                                ; $6769

jr_00a_676b:
    ldh a, [hScratchA]                            ; $676B
    dec a                                         ; $676D
    ret z                                         ; $676E

    ldh [hScratchA], a                            ; $676F
    dec b                                         ; $6771
    ld c, $0e                                     ; $6772
    jr jr_00a_6747                                ; $6774

; C: copy of part of the photo (Top4Rows); = slot 15 applied to the photo flipped upside down (64 of 224 tiles; the
; rest of the buffer is left alone); reads x 0-127, y 80-111; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 55; scratch FF8A-FF8D loops; never ...
Fx55_CopyTop4Rows_OnFlipV::
    ld hl, $ab00                                  ; $6776
    ld bc, wPhotoImage + $30e                     ; $6779
    ld a, $04                                     ; $677C
    ldh [hScratchA], a                            ; $677E

jr_00a_6780:
    ld a, $10                                     ; $6780
    ldh [hScratchB], a                            ; $6782

jr_00a_6784:
    ld a, $08                                     ; $6784
    ldh [hScratchD], a                            ; $6786

jr_00a_6788:
    ld a, [hl+]                                   ; $6788
    ld [bc], a                                    ; $6789
    inc c                                         ; $678A
    ld a, [hl+]                                   ; $678B
    ld [bc], a                                    ; $678C
    dec c                                         ; $678D
    dec c                                         ; $678E
    dec c                                         ; $678F
    ldh a, [hScratchD]                            ; $6790
    dec a                                         ; $6792
    ldh [hScratchD], a                            ; $6793
    jr nz, jr_00a_6788                            ; $6795

    ldh a, [hScratchB]                            ; $6797
    dec a                                         ; $6799
    jr z, jr_00a_67a4                             ; $679A

    ldh [hScratchB], a                            ; $679C
    ld a, c                                       ; $679E
    add $20                                       ; $679F
    ld c, a                                       ; $67A1
    jr jr_00a_6784                                ; $67A2

jr_00a_67a4:
    ldh a, [hScratchA]                            ; $67A4
    dec a                                         ; $67A6
    ret z                                         ; $67A7

    ldh [hScratchA], a                            ; $67A8
    dec b                                         ; $67AA
    ld c, $0e                                     ; $67AB
    jr jr_00a_6780                                ; $67AD

; C: copy of part of the photo (Bottom10Rows); = slot 16 applied to the photo flipped upside down (160 of 224 tiles;
; the rest of the buffer is left alone); reads x 0-127, y 0-79; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 56; scratch FF8A-FF8D loops; ...
Fx56_CopyBottom10Rows_OnFlipV::
    ld hl, $a100                                  ; $67AF
    ld bc, wPhotoImage + $d0e                     ; $67B2
    ld a, $0a                                     ; $67B5
    ldh [hScratchA], a                            ; $67B7

jr_00a_67b9:
    ld a, $10                                     ; $67B9
    ldh [hScratchB], a                            ; $67BB

jr_00a_67bd:
    ld a, $08                                     ; $67BD
    ldh [hScratchD], a                            ; $67BF

jr_00a_67c1:
    ld a, [hl+]                                   ; $67C1
    ld [bc], a                                    ; $67C2
    inc c                                         ; $67C3
    ld a, [hl+]                                   ; $67C4
    ld [bc], a                                    ; $67C5
    dec c                                         ; $67C6
    dec c                                         ; $67C7
    dec c                                         ; $67C8
    ldh a, [hScratchD]                            ; $67C9
    dec a                                         ; $67CB
    ldh [hScratchD], a                            ; $67CC
    jr nz, jr_00a_67c1                            ; $67CE

    ldh a, [hScratchB]                            ; $67D0
    dec a                                         ; $67D2
    jr z, jr_00a_67dd                             ; $67D3

    ldh [hScratchB], a                            ; $67D5
    ld a, c                                       ; $67D7
    add $20                                       ; $67D8
    ld c, a                                       ; $67DA
    jr jr_00a_67bd                                ; $67DB

jr_00a_67dd:
    ldh a, [hScratchA]                            ; $67DD
    dec a                                         ; $67DF
    ret z                                         ; $67E0

    ldh [hScratchA], a                            ; $67E1
    dec b                                         ; $67E3
    ld c, $0e                                     ; $67E4
    jr jr_00a_67b9                                ; $67E6

; C: copy of part of the photo (Window); = slot 17 applied to the photo flipped upside down (80 of 224 tiles; the rest
; of the buffer is left alone); reads x 24-103, y 24-87; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 57; scratch FF8A-FF8D loops; selected by
; ...
Fx57_CopyWindow_OnFlipV::
    ld hl, $a430                                  ; $67E8
    ld bc, wPhotoImage + $a3e                     ; $67EB
    ld a, $08                                     ; $67EE
    ldh [hScratchA], a                            ; $67F0

jr_00a_67f2:
    ld a, $0a                                     ; $67F2
    ldh [hScratchB], a                            ; $67F4

jr_00a_67f6:
    ld a, $08                                     ; $67F6
    ldh [hScratchD], a                            ; $67F8

jr_00a_67fa:
    ld a, [hl+]                                   ; $67FA
    ld [bc], a                                    ; $67FB
    inc c                                         ; $67FC
    ld a, [hl+]                                   ; $67FD
    ld [bc], a                                    ; $67FE
    dec c                                         ; $67FF
    dec c                                         ; $6800
    dec c                                         ; $6801
    ldh a, [hScratchD]                            ; $6802
    dec a                                         ; $6804
    ldh [hScratchD], a                            ; $6805
    jr nz, jr_00a_67fa                            ; $6807

    ldh a, [hScratchB]                            ; $6809
    dec a                                         ; $680B
    jr z, jr_00a_6816                             ; $680C

    ldh [hScratchB], a                            ; $680E
    ld a, c                                       ; $6810
    add $20                                       ; $6811
    ld c, a                                       ; $6813
    jr jr_00a_67f6                                ; $6814

jr_00a_6816:
    ldh a, [hScratchA]                            ; $6816
    dec a                                         ; $6818
    ret z                                         ; $6819

    ldh [hScratchA], a                            ; $681A
    dec b                                         ; $681C
    ld c, $3e                                     ; $681D
    inc h                                         ; $681F
    ld l, $30                                     ; $6820
    jr jr_00a_67f2                                ; $6822

; C: copy of part of the photo (QuadBR); = slot 18 applied to the photo flipped upside down (56 of 224 tiles; the rest
; of the buffer is left alone); reads x 64-127, y 0-55; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); effect table slot(s) 58; scratch FF8A-FF8D loops; selected by
; ...
Fx58_CopyQuadBR_OnFlipV::
    ld hl, $a180                                  ; $6824
    ld bc, wPhotoImage + $d8e                     ; $6827
    ld a, $07                                     ; $682A
    ldh [hScratchA], a                            ; $682C

jr_00a_682e:
    ld a, $08                                     ; $682E
    ldh [hScratchB], a                            ; $6830

jr_00a_6832:
    ld a, $08                                     ; $6832
    ldh [hScratchD], a                            ; $6834

jr_00a_6836:
    ld a, [hl+]                                   ; $6836
    ld [bc], a                                    ; $6837
    inc c                                         ; $6838
    ld a, [hl+]                                   ; $6839
    ld [bc], a                                    ; $683A
    dec c                                         ; $683B
    dec c                                         ; $683C
    dec c                                         ; $683D
    ldh a, [hScratchD]                            ; $683E
    dec a                                         ; $6840
    ldh [hScratchD], a                            ; $6841
    jr nz, jr_00a_6836                            ; $6843

    ldh a, [hScratchB]                            ; $6845
    dec a                                         ; $6847
    jr z, jr_00a_6852                             ; $6848

    ldh [hScratchB], a                            ; $684A
    ld a, c                                       ; $684C
    add $20                                       ; $684D
    ld c, a                                       ; $684F
    jr jr_00a_6832                                ; $6850

jr_00a_6852:
    ldh a, [hScratchA]                            ; $6852
    dec a                                         ; $6854
    ret z                                         ; $6855

    ldh [hScratchA], a                            ; $6856
    dec b                                         ; $6858
    ld c, $8e                                     ; $6859
    ld l, $80                                     ; $685B
    jr jr_00a_682e                                ; $685D

; C: single ret: slot 59 of the effect table
Fx59_Nop::
    ret                                           ; $685F


; C: single ret: slot 5A of the effect table
Fx5A_Nop::
    ret                                           ; $6860


; C: single ret: slot 5B of the effect table
Fx5B_Nop::
    ret                                           ; $6861


; C: single ret: slot 5C of the effect table
Fx5C_Nop::
    ret                                           ; $6862


; C: single ret: slot 5D of the effect table
Fx5D_Nop::
    ret                                           ; $6863


; C: single ret: slot 5E of the effect table
Fx5E_Nop::
    ret                                           ; $6864


; C: single ret: slot 5F of the effect table
Fx5F_Nop::
    ret                                           ; $6865


; C: shared body of slots 09-0C (the stubs Fx09-Fx0C load DE with the destination quadrant): reduces the photo to half
; size (every second pixel and row, sx = 2x, sy = 2y) into the 64 x 56 pixel quadrant at DE; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); b=$79 selects the reduce ...
FxShared_ReduceBody_G0::
    ld hl, $a100                                  ; $6866
    ld b, $79                                     ; $6869
    ld a, $07                                     ; $686B
    ldh [hScratchA], a                            ; $686D

; C: pass top of the shared reduction body, group 0 loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-
; entered after a source / destination pointer step (branch target; code read 2026-10-19)
FxShared_ReduceBody_G0_PassTop::
    ld a, $08                                     ; $686F
    ldh [hScratchB], a                            ; $6871

; C: group top of the shared reduction body, group 0 loop: sets the column counter $FF8D = 4, then reads the next tile
; rows through the lookup table (branch target; code read 2026-10-19)
FxShared_ReduceBody_G0_GroupTop::
    ld a, $04                                     ; $6873
    ldh [hScratchD], a                            ; $6875

jr_00a_6877:
    ld c, [hl]                                    ; $6877
    ld a, [bc]                                    ; $6878
    swap a                                        ; $6879
    ldh [hScratchC], a                            ; $687B
    ld a, l                                       ; $687D
    add $10                                       ; $687E
    ld l, a                                       ; $6880
    ld c, [hl]                                    ; $6881
    ld a, [bc]                                    ; $6882
    ld c, a                                       ; $6883
    ldh a, [hScratchC]                            ; $6884
    or c                                          ; $6886
    ld [de], a                                    ; $6887
    inc e                                         ; $6888
    ld a, l                                       ; $6889
    sub $0f                                       ; $688A
    ld l, a                                       ; $688C
    ld c, [hl]                                    ; $688D
    ld a, [bc]                                    ; $688E
    swap a                                        ; $688F
    ldh [hScratchC], a                            ; $6891
    ld a, l                                       ; $6893
    add $10                                       ; $6894
    ld l, a                                       ; $6896
    ld c, [hl]                                    ; $6897
    ld a, [bc]                                    ; $6898
    ld c, a                                       ; $6899
    ldh a, [hScratchC]                            ; $689A
    or c                                          ; $689C
    ld [de], a                                    ; $689D
    inc e                                         ; $689E
    ld a, l                                       ; $689F
    sub $0d                                       ; $68A0
    ld l, a                                       ; $68A2
    ldh a, [hScratchD]                            ; $68A3
    dec a                                         ; $68A5
    ldh [hScratchD], a                            ; $68A6
    jr nz, jr_00a_6877                            ; $68A8

    inc h                                         ; $68AA
    ld a, l                                       ; $68AB
    sub $10                                       ; $68AC
    ld l, a                                       ; $68AE
    ld a, $04                                     ; $68AF
    ldh [hScratchD], a                            ; $68B1

jr_00a_68b3:
    ld c, [hl]                                    ; $68B3
    ld a, [bc]                                    ; $68B4
    swap a                                        ; $68B5
    ldh [hScratchC], a                            ; $68B7
    ld a, l                                       ; $68B9
    add $10                                       ; $68BA
    ld l, a                                       ; $68BC
    ld c, [hl]                                    ; $68BD
    ld a, [bc]                                    ; $68BE
    ld c, a                                       ; $68BF
    ldh a, [hScratchC]                            ; $68C0
    or c                                          ; $68C2
    ld [de], a                                    ; $68C3
    inc e                                         ; $68C4
    ld a, l                                       ; $68C5
    sub $0f                                       ; $68C6
    ld l, a                                       ; $68C8
    ld c, [hl]                                    ; $68C9
    ld a, [bc]                                    ; $68CA
    swap a                                        ; $68CB
    ldh [hScratchC], a                            ; $68CD
    ld a, l                                       ; $68CF
    add $10                                       ; $68D0
    ld l, a                                       ; $68D2
    ld c, [hl]                                    ; $68D3
    ld a, [bc]                                    ; $68D4
    ld c, a                                       ; $68D5
    ldh a, [hScratchC]                            ; $68D6
    or c                                          ; $68D8
    ld [de], a                                    ; $68D9
    inc e                                         ; $68DA
    ld a, l                                       ; $68DB
    sub $0d                                       ; $68DC
    ld l, a                                       ; $68DE
    ldh a, [hScratchD]                            ; $68DF
    dec a                                         ; $68E1
    ldh [hScratchD], a                            ; $68E2
    jr nz, jr_00a_68b3                            ; $68E4

    ldh a, [hScratchB]                            ; $68E6
    dec a                                         ; $68E8
    jr z, jr_00a_68f5                             ; $68E9

    ldh [hScratchB], a                            ; $68EB
    dec h                                         ; $68ED
    ld a, l                                       ; $68EE
    add $10                                       ; $68EF
    ld l, a                                       ; $68F1
    jp FxShared_ReduceBody_G0_GroupTop            ; $68F2


jr_00a_68f5:
    ldh a, [hScratchA]                            ; $68F5
    dec a                                         ; $68F7
    ret z                                         ; $68F8

    ldh [hScratchA], a                            ; $68F9
    inc d                                         ; $68FB
    ld a, e                                       ; $68FC
    add $80                                       ; $68FD
    ld e, a                                       ; $68FF
    inc h                                         ; $6900
    ld l, $00                                     ; $6901
    jp FxShared_ReduceBody_G0_PassTop             ; $6903


; C: shared body of slots 29-2C (the photo flipped left-right first): reduces the photo to half size (every second
; pixel and row, sx = -2x + 126 or -2x + 254, sy = 2y) into the 64 x 56 pixel quadrant at DE; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); b=$79 selects the reduce table
FxShared_ReduceBody_G1::
    ld hl, $a100                                  ; $6906
    ld b, $7a                                     ; $6909
    ld a, $07                                     ; $690B
    ldh [hScratchA], a                            ; $690D

; C: pass top of the shared reduction body, group 1 loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-
; entered after a source / destination pointer step (branch target; code read 2026-10-19)
FxShared_ReduceBody_G1_PassTop::
    ld a, $08                                     ; $690F
    ldh [hScratchB], a                            ; $6911

; C: group top of the shared reduction body, group 1 loop: sets the column counter $FF8D = 4, then reads the next tile
; rows through the lookup table (branch target; code read 2026-10-19)
FxShared_ReduceBody_G1_GroupTop::
    ld a, $04                                     ; $6913
    ldh [hScratchD], a                            ; $6915

jr_00a_6917:
    ld c, [hl]                                    ; $6917
    ld a, [bc]                                    ; $6918
    ldh [hScratchC], a                            ; $6919
    ld a, l                                       ; $691B
    add $10                                       ; $691C
    ld l, a                                       ; $691E
    ld c, [hl]                                    ; $691F
    ld a, [bc]                                    ; $6920
    swap a                                        ; $6921
    ld c, a                                       ; $6923
    ldh a, [hScratchC]                            ; $6924
    or c                                          ; $6926
    ld [de], a                                    ; $6927
    inc e                                         ; $6928
    ld a, l                                       ; $6929
    sub $0f                                       ; $692A
    ld l, a                                       ; $692C
    ld c, [hl]                                    ; $692D
    ld a, [bc]                                    ; $692E
    ldh [hScratchC], a                            ; $692F
    ld a, l                                       ; $6931
    add $10                                       ; $6932
    ld l, a                                       ; $6934
    ld c, [hl]                                    ; $6935
    ld a, [bc]                                    ; $6936
    swap a                                        ; $6937
    ld c, a                                       ; $6939
    ldh a, [hScratchC]                            ; $693A
    or c                                          ; $693C
    ld [de], a                                    ; $693D
    inc e                                         ; $693E
    ld a, l                                       ; $693F
    sub $0d                                       ; $6940
    ld l, a                                       ; $6942
    ldh a, [hScratchD]                            ; $6943
    dec a                                         ; $6945
    ldh [hScratchD], a                            ; $6946
    jr nz, jr_00a_6917                            ; $6948

    inc h                                         ; $694A
    ld a, l                                       ; $694B
    sub $10                                       ; $694C
    ld l, a                                       ; $694E
    ld a, $04                                     ; $694F
    ldh [hScratchD], a                            ; $6951

jr_00a_6953:
    ld c, [hl]                                    ; $6953
    ld a, [bc]                                    ; $6954
    ldh [hScratchC], a                            ; $6955
    ld a, l                                       ; $6957
    add $10                                       ; $6958
    ld l, a                                       ; $695A
    ld c, [hl]                                    ; $695B
    ld a, [bc]                                    ; $695C
    swap a                                        ; $695D
    ld c, a                                       ; $695F
    ldh a, [hScratchC]                            ; $6960
    or c                                          ; $6962
    ld [de], a                                    ; $6963
    inc e                                         ; $6964
    ld a, l                                       ; $6965
    sub $0f                                       ; $6966
    ld l, a                                       ; $6968
    ld c, [hl]                                    ; $6969
    ld a, [bc]                                    ; $696A
    ldh [hScratchC], a                            ; $696B
    ld a, l                                       ; $696D
    add $10                                       ; $696E
    ld l, a                                       ; $6970
    ld c, [hl]                                    ; $6971
    ld a, [bc]                                    ; $6972
    swap a                                        ; $6973
    ld c, a                                       ; $6975
    ldh a, [hScratchC]                            ; $6976
    or c                                          ; $6978
    ld [de], a                                    ; $6979
    inc e                                         ; $697A
    ld a, l                                       ; $697B
    sub $0d                                       ; $697C
    ld l, a                                       ; $697E
    ldh a, [hScratchD]                            ; $697F
    dec a                                         ; $6981
    ldh [hScratchD], a                            ; $6982
    jr nz, jr_00a_6953                            ; $6984

    ld a, e                                       ; $6986
    sub $20                                       ; $6987
    ld e, a                                       ; $6989
    ldh a, [hScratchB]                            ; $698A
    dec a                                         ; $698C
    jr z, jr_00a_6999                             ; $698D

    ldh [hScratchB], a                            ; $698F
    dec h                                         ; $6991
    ld a, l                                       ; $6992
    add $10                                       ; $6993
    ld l, a                                       ; $6995
    jp FxShared_ReduceBody_G1_GroupTop            ; $6996


jr_00a_6999:
    ldh a, [hScratchA]                            ; $6999
    dec a                                         ; $699B
    ret z                                         ; $699C

    ldh [hScratchA], a                            ; $699D
    inc d                                         ; $699F
    ld a, e                                       ; $69A0
    add $80                                       ; $69A1
    ld e, a                                       ; $69A3
    inc h                                         ; $69A4
    ld l, $00                                     ; $69A5
    jp FxShared_ReduceBody_G1_PassTop             ; $69A7


; C: shared body of slots 49-4C (the photo flipped upside down first): reduces the photo to half size (every second
; pixel and row, sx = 2x, sy = -2y + 110 or -2y + 222) into the 64 x 56 pixel quadrant at DE; BGB hook run
; (tcrf_check/assets/effect_slots/effect_slots_bgb.csv); b=$79 selects the reduce ...
FxShared_ReduceBody_G2::
    ld hl, $a100                                  ; $69AA
    ld b, $79                                     ; $69AD
    ld a, $07                                     ; $69AF
    ldh [hScratchA], a                            ; $69B1

; C: pass top of the shared reduction body, group 2 loop: sets the row counter $FF8B = 8 and falls into _GroupTop; re-
; entered after a source / destination pointer step (branch target; code read 2026-10-19)
FxShared_ReduceBody_G2_PassTop::
    ld a, $08                                     ; $69B3
    ldh [hScratchB], a                            ; $69B5

; C: group top of the shared reduction body, group 2 loop: sets the column counter $FF8D = 4, then reads the next tile
; rows through the lookup table (branch target; code read 2026-10-19)
FxShared_ReduceBody_G2_GroupTop::
    ld a, $04                                     ; $69B7
    ldh [hScratchD], a                            ; $69B9

jr_00a_69bb:
    ld c, [hl]                                    ; $69BB
    ld a, [bc]                                    ; $69BC
    swap a                                        ; $69BD
    ldh [hScratchC], a                            ; $69BF
    ld a, l                                       ; $69C1
    add $10                                       ; $69C2
    ld l, a                                       ; $69C4
    ld c, [hl]                                    ; $69C5
    ld a, [bc]                                    ; $69C6
    ld c, a                                       ; $69C7
    ldh a, [hScratchC]                            ; $69C8
    or c                                          ; $69CA
    ld [de], a                                    ; $69CB
    inc e                                         ; $69CC
    ld a, l                                       ; $69CD
    sub $0f                                       ; $69CE
    ld l, a                                       ; $69D0
    ld c, [hl]                                    ; $69D1
    ld a, [bc]                                    ; $69D2
    swap a                                        ; $69D3
    ldh [hScratchC], a                            ; $69D5
    ld a, l                                       ; $69D7
    add $10                                       ; $69D8
    ld l, a                                       ; $69DA
    ld c, [hl]                                    ; $69DB
    ld a, [bc]                                    ; $69DC
    ld c, a                                       ; $69DD
    ldh a, [hScratchC]                            ; $69DE
    or c                                          ; $69E0
    ld [de], a                                    ; $69E1
    dec e                                         ; $69E2
    dec e                                         ; $69E3
    dec e                                         ; $69E4
    ld a, l                                       ; $69E5
    sub $0d                                       ; $69E6
    ld l, a                                       ; $69E8
    ldh a, [hScratchD]                            ; $69E9
    dec a                                         ; $69EB
    ldh [hScratchD], a                            ; $69EC
    jr nz, jr_00a_69bb                            ; $69EE

    inc h                                         ; $69F0
    ld a, l                                       ; $69F1
    sub $10                                       ; $69F2
    ld l, a                                       ; $69F4
    ld a, $04                                     ; $69F5
    ldh [hScratchD], a                            ; $69F7

jr_00a_69f9:
    ld c, [hl]                                    ; $69F9
    ld a, [bc]                                    ; $69FA
    swap a                                        ; $69FB
    ldh [hScratchC], a                            ; $69FD
    ld a, l                                       ; $69FF
    add $10                                       ; $6A00
    ld l, a                                       ; $6A02
    ld c, [hl]                                    ; $6A03
    ld a, [bc]                                    ; $6A04
    ld c, a                                       ; $6A05
    ldh a, [hScratchC]                            ; $6A06
    or c                                          ; $6A08
    ld [de], a                                    ; $6A09
    inc e                                         ; $6A0A
    ld a, l                                       ; $6A0B
    sub $0f                                       ; $6A0C
    ld l, a                                       ; $6A0E
    ld c, [hl]                                    ; $6A0F
    ld a, [bc]                                    ; $6A10
    swap a                                        ; $6A11
    ldh [hScratchC], a                            ; $6A13
    ld a, l                                       ; $6A15
    add $10                                       ; $6A16
    ld l, a                                       ; $6A18
    ld c, [hl]                                    ; $6A19
    ld a, [bc]                                    ; $6A1A
    ld c, a                                       ; $6A1B
    ldh a, [hScratchC]                            ; $6A1C
    or c                                          ; $6A1E
    ld [de], a                                    ; $6A1F
    dec e                                         ; $6A20
    dec e                                         ; $6A21
    dec e                                         ; $6A22
    ld a, l                                       ; $6A23
    sub $0d                                       ; $6A24
    ld l, a                                       ; $6A26
    ldh a, [hScratchD]                            ; $6A27
    dec a                                         ; $6A29
    ldh [hScratchD], a                            ; $6A2A
    jr nz, jr_00a_69f9                            ; $6A2C

    ldh a, [hScratchB]                            ; $6A2E
    dec a                                         ; $6A30
    jr z, FxShared_ReduceBody_G2_OuterLoopTail    ; $6A31

    ldh [hScratchB], a                            ; $6A33
    dec h                                         ; $6A35
    ld a, l                                       ; $6A36
    add $10                                       ; $6A37
    ld l, a                                       ; $6A39
    ld a, e                                       ; $6A3A
    add $20                                       ; $6A3B
    ld e, a                                       ; $6A3D
    jp FxShared_ReduceBody_G2_GroupTop            ; $6A3E


; C: outer-loop tail of FxShared_ReduceBody_G2 (0A:69AA), reached by the jr z at the end of its inner loop: ldh
; a,[$ff8a]; dec a; ret z (the reduction ends when the outer counter $FF8A reaches 0), else $FF8A := a, dec d, e +=
; $A0, inc h, l := 0 and jp 0A:69B3. The old name Cam_BootHiddenCombo_Check was ...
FxShared_ReduceBody_G2_OuterLoopTail::
    ldh a, [hScratchA]                            ; $6A41
    dec a                                         ; $6A43
    ret z                                         ; $6A44

    ldh [hScratchA], a                            ; $6A45
    dec d                                         ; $6A47
    ld a, e                                       ; $6A48
    add $a0                                       ; $6A49
    ld e, a                                       ; $6A4B
    inc h                                         ; $6A4C
    ld l, $00                                     ; $6A4D
    jp FxShared_ReduceBody_G2_PassTop             ; $6A4F


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_BootSelfTest_Entry::
    ldh a, [hKeysHeld]                            ; $6A52
    cp PADF_A | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $6A54
    jp z, Cam_FactoryDiag_AllButtonsExceptB       ; $6A56

    cp PADF_A | PADF_B | PADF_SELECT | PADF_START | PADF_RIGHT | PADF_LEFT | PADF_UP | PADF_DOWN ; $6A59
    jp z, Cam_FirstBoot_StorePleaseWait           ; $6A5B

    di                                            ; $6A5E
    ldh [hFarcallAArg], a                         ; $6A5F
    ld a, $0a                                     ; $6A61
    ld hl, Cam_FarStub_ValidityCheck              ; $6A63
    call Far_Call                                 ; $6A66
    ei                                            ; $6A69
    and a                                         ; $6A6A
    jp nz, Cam_FirstBoot_StorePleaseWait          ; $6A6B

    ldh [hFarcallAArg], a                         ; $6A6E
    ld a, $0a                                     ; $6A70
    ld hl, Cam_FarStub_LiveInit                   ; $6A72
    call Far_Call                                 ; $6A75
    jp Far_Call_Return                            ; $6A78


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_AllButtonsExceptB::
    call Pal_FadeOut                              ; $6A7B
    call Lcd_Off                                  ; $6A7E
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $6A81
    ldh [hLcdcShadow], a                          ; $6A83
    ld a, $e4                                     ; $6A85
    ld [wPaletteTarget], a                        ; $6A87
    ld [wPaletteTarget + $1], a                   ; $6A8A
    ld [wPaletteTarget + $2], a                   ; $6A8D
    xor a                                         ; $6A90
    ldh [hScxShadow], a                           ; $6A91
    ldh [hScyShadow], a                           ; $6A93
    ld a, BANK(Gfx_24_57E0_Unused_Link_LoadTiles) ; $6A95
    ld hl, Gfx_24_57E0_Unused_Link_LoadTiles      ; $6A97
    ld de, $9000                                  ; $6A9A
    ld bc, $0300                                  ; $6A9D
    call Mem_CopyFromBank                         ; $6AA0
    ld a, BANK(Map_25_5840_Cam_FactoryDiag_AllButtonsExceptB); $6AA3
    ld hl, Map_25_5840_Cam_FactoryDiag_AllButtonsExceptB; $6AA5
    ld de, $9800                                  ; $6AA8
    ld bc, $0240                                  ; $6AAB
    call Mem_CopyFromBank                         ; $6AAE
    ld a, $02                                     ; $6AB1
    ld [$4000], a                                 ; $6AB3
    ld hl, $982f                                  ; $6AB6
    ld a, [$aff0]                                 ; $6AB9
    call Cam_FactoryDiag_HexDigitWrite            ; $6ABC
    ld hl, $984f                                  ; $6ABF
    ld a, [$aff1]                                 ; $6AC2
    call Cam_FactoryDiag_HexDigitWrite            ; $6AC5
    ld hl, $9908                                  ; $6AC8
    ld a, [$affc]                                 ; $6ACB
    call Cam_FactoryDiag_HexDigitWrite            ; $6ACE
    ld hl, $9968                                  ; $6AD1
    ld a, [$affd]                                 ; $6AD4
    call Cam_FactoryDiag_HexDigitWrite            ; $6AD7
    call Oam_ClearShadow                          ; $6ADA
    call Pal_AllWhite                             ; $6ADD
    call Lcd_On                                   ; $6AE0
    push af                                       ; $6AE3
    ld a, MUSIC_JINGLE                            ; $6AE4
    call Snd_Music                                ; $6AE6
    pop af                                        ; $6AE9
    call Pal_FadeIn                               ; $6AEA
    ldh [hFarcallAArg], a                         ; $6AED
    ld a, $0a                                     ; $6AEF
    ld hl, Cam_FarStub_FactoryTest                ; $6AF1
    call Far_Call                                 ; $6AF4
    ld hl, $990c                                  ; $6AF7
    ld a, [wCamCalibVector + $a]                  ; $6AFA
    call Cam_FactoryDiag_ByteToTiles              ; $6AFD
    ld hl, $996c                                  ; $6B00
    ld a, [wCamCalibVector + $b]                  ; $6B03
    call Cam_FactoryDiag_ByteToTiles              ; $6B06
    ld hl, $9910                                  ; $6B09
    ldh a, [hScratchD]                            ; $6B0C
    call Cam_FactoryDiag_NibbleToTile_lo          ; $6B0E
    ldh a, [hDiffOrValue]                         ; $6B11
    call Cam_FactoryDiag_ByteToTiles              ; $6B13
    ld hl, $9970                                  ; $6B16
    ldh a, [hPrevOrSign]                          ; $6B19
    call Cam_FactoryDiag_NibbleToTile_lo          ; $6B1B
    ldh a, [hDiff2]                               ; $6B1E
    call Cam_FactoryDiag_ByteToTiles              ; $6B20
    ldh a, [hDiagPassFlag]                        ; $6B23
    and a                                         ; $6B25
    jr nz, jr_00a_6b3f                            ; $6B26

    ld a, BANK(Map_25_5A80_Cam_FactoryDiag_AllButtonsExceptB); $6B28
    ld hl, Map_25_5A80_Cam_FactoryDiag_AllButtonsExceptB; $6B2A
    ld de, $98a0                                  ; $6B2D
    ld bc, $0020                                  ; $6B30
    call Vram_CopyFromBank_4                      ; $6B33
    push af                                       ; $6B36
    ld a, MUSIC_FACTORY_DIAG                      ; $6B37
    call Snd_Music                                ; $6B39
    pop af                                        ; $6B3C
    jr jr_00a_6b54                                ; $6B3D

jr_00a_6b3f:
    ld a, BANK(Map_25_5AA0_Cam_FactoryDiag_AllButtonsExceptB); $6B3F
    ld hl, Map_25_5AA0_Cam_FactoryDiag_AllButtonsExceptB; $6B41
    ld de, $98a0                                  ; $6B44
    ld bc, $0020                                  ; $6B47
    call Vram_CopyFromBank_4                      ; $6B4A
    push af                                       ; $6B4D
    ld a, MUSIC_TOTAKA_TUNE                       ; $6B4E
    call Snd_Music                                ; $6B50
    pop af                                        ; $6B53

jr_00a_6b54:
    jr jr_00a_6b54                                ; $6B54

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_HexDigitWrite::
    push af                                       ; $6B56
    swap a                                        ; $6B57
    and $0f                                       ; $6B59
    call Cam_FactoryDiag_NibbleToTile_hi          ; $6B5B
    pop af                                        ; $6B5E
    and $0f                                       ; $6B5F

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_NibbleToTile_hi::
    ld [hl+], a                                   ; $6B61
    ret                                           ; $6B62


; C: two hex nibbles to tiles. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in the organic runs of
; the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_ByteToTiles::
    push af                                       ; $6B63
    swap a                                        ; $6B64
    and $0f                                       ; $6B66
    call Cam_FactoryDiag_NibbleToTile_lo          ; $6B68
    pop af                                        ; $6B6B
    and $0f                                       ; $6B6C

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_NibbleToTile_lo::
    call Vram_WriteByteSafe                       ; $6B6E
    inc hl                                        ; $6B71
    ret                                           ; $6B72


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FirstBoot_StorePleaseWait::
    call Pal_FadeOut                              ; $6B73
    call Lcd_Off                                  ; $6B76
    ld a, LCDCF_WIN9C00 | LCDCF_BGON              ; $6B79
    ldh [hLcdcShadow], a                          ; $6B7B
    ld a, $e4                                     ; $6B7D
    ld [wPaletteTarget], a                        ; $6B7F
    ld [wPaletteTarget + $1], a                   ; $6B82
    ld [wPaletteTarget + $2], a                   ; $6B85
    xor a                                         ; $6B88
    ldh [hScxShadow], a                           ; $6B89
    ldh [hScyShadow], a                           ; $6B8B
    ld a, BANK(Gfx_24_57E0_Unused_Link_LoadTiles) ; $6B8D
    ld hl, Gfx_24_57E0_Unused_Link_LoadTiles      ; $6B8F
    ld de, $9000                                  ; $6B92
    ld bc, $0300                                  ; $6B95
    call Mem_CopyFromBank                         ; $6B98
    ld a, BANK(Map_25_5AC0_Cam_FirstBoot_StorePleaseWait); $6B9B
    ld hl, Map_25_5AC0_Cam_FirstBoot_StorePleaseWait; $6B9D
    ld de, $9800                                  ; $6BA0
    ld bc, $0240                                  ; $6BA3
    call Mem_CopyFromBank                         ; $6BA6
    call Oam_ClearShadow                          ; $6BA9
    call Pal_AllWhite                             ; $6BAC
    call Lcd_On                                   ; $6BAF
    push af                                       ; $6BB2
    ld a, MUSIC_JINGLE                            ; $6BB3
    call Snd_Music                                ; $6BB5
    pop af                                        ; $6BB8
    call Pal_FadeIn                               ; $6BB9
    ldh [hFarcallAArg], a                         ; $6BBC
    ld a, $0a                                     ; $6BBE
    ld hl, Cam_FarStub_FullCalibration            ; $6BC0
    call Far_Call                                 ; $6BC3
    ld a, BANK(Map_25_5D00_Cam_FirstBoot_StorePleaseWait); $6BC6
    ld hl, Map_25_5D00_Cam_FirstBoot_StorePleaseWait; $6BC8
    ld de, $9900                                  ; $6BCB
    ld bc, $0020                                  ; $6BCE
    call Vram_CopyFromBank_4                      ; $6BD1
    push af                                       ; $6BD4
    ld a, MUSIC_RUN_RACE                          ; $6BD5
    call Snd_Music                                ; $6BD7
    pop af                                        ; $6BDA

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FactoryDiag_StoreWaitScreen::
    jr Cam_FactoryDiag_StoreWaitScreen            ; $6BDB

    ; padding
    ds $723, $00

; C: table[i] = number of set bits of i (256 bytes, README 5); read with ld h,3 by Cam_PopcountSampleLoop_inner
; (0A:5091, 509C)
Cam_PopcountTable256::
    INCBIN "data/bank_0a/Cam_PopcountTable256.bin" ; $7300, 256 bytes
; C: table[i] = bit-reversed byte i (horizontal mirror of 8 pixels); read with ld b,4 by the 20 MirrorCopy effect
; handlers (Fx01, Fx02, Fx20, Fx25, Fx2D-Fx38, Fx41, Fx42) and by Fx23 / Fx24
Cam_BitReverseTbl::
    INCBIN "data/bank_0a/Cam_BitReverseTbl.bin" ; $7400, 256 bytes
; C: table[c] = high nibble of c with every bit doubled (4 pixels -> 8 pixels, 16 groups of 16 equal bytes); first
; output byte of Fx06 / Fx07 / Fx46 / Fx47 (ld b,5); Fx06 re-simulated byte for byte against the core (3,584 cells)
Cam_ZoomX2_HiTbl::
    INCBIN "data/bank_0a/Cam_ZoomX2_HiTbl.bin" ; $7500, 256 bytes
; C: table[c] = low nibble of c with every bit doubled (period 16); second output byte, 16 bytes further, of Fx06 /
; Fx07 / Fx46 / Fx47 (ld b,6)
Cam_ZoomX2_LoTbl::
    INCBIN "data/bank_0a/Cam_ZoomX2_LoTbl.bin" ; $7600, 256 bytes
; C: table[c] = high nibble of c, bits in reverse order, every bit doubled (16 groups of 16 bytes; byte 0A:774D is $C0
; where the pattern gives $0C, a single odd byte in the ROM); first output byte of the mirrored zoom Fx26 / Fx27 (ld
; b,7); Fx26 re-simulated byte for byte against the core
Cam_ZoomX2Mirror_HiTbl::
    INCBIN "data/bank_0a/Cam_ZoomX2Mirror_HiTbl.bin" ; $7700, 256 bytes
; C: table[c] = low nibble of c, bits in reverse order, every bit doubled (period 16); second output byte (16 bytes
; before) of Fx26 / Fx27 (ld b,8)
Cam_ZoomX2Mirror_LoTbl::
    INCBIN "data/bank_0a/Cam_ZoomX2Mirror_LoTbl.bin" ; $7800, 256 bytes
; C: bit decimation (every other bit pair). L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the
; organic runs of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 14)
Cam_ReduceTbl_Lo::
    INCBIN "data/bank_0a/Cam_ReduceTbl_Lo.bin" ; $7900, 256 bytes
; C: same as 7900 shifted by 2 bits. L3 pass 2026-10-26: not reached by the 206 BGB replays; read in the organic runs
; of the core emulator (coverage/results/merged_state/cov.npz, first read in mode 14)
Cam_ReduceTbl_Hi::
    INCBIN "data/bank_0a/Cam_ReduceTbl_Hi.bin" ; $7A00, 256 bytes
; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: read in BGB in 71 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_ExposureShiftTable::
    db $02, $03, $03, $03, $04, $03, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
    db $04, $04, $04, $05, $04, $05, $05, $05, $05, $05, $06, $05, $06, $06, $06, $07
    db $07, $08, $09, $10, $10, $10, $09, $08, $07, $07, $06, $06, $05, $06, $05, $05
    db $05, $05, $04, $05

    ; padding
    ds $1c, $04

    ; padding
    ds $50, $03

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_ORegSAR_Table_Above::
    db $b0, $81, $81, $83, $82, $85, $85, $87, $84, $89, $89, $8b, $8a, $8d, $8d, $8f
    db $88, $91, $91, $93, $92, $95, $95, $97, $94, $99, $99, $9b, $9a, $9d, $9d, $9f
    db $b0, $a1, $a3, $a3, $a6, $a5, $a7, $a7, $ac, $a9, $ab, $ab, $ae, $ad, $af, $af
    db $b8, $b1, $b3, $b3, $b6, $b5, $b7, $b7, $bc, $b9, $bb, $bb, $be, $bd, $bf, $bf

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_ORegSAR_Table_Below::
    db $90, $82, $83, $84, $86, $86, $87, $88, $8c, $8a, $8b, $8c, $8e, $8e, $8f, $90
    db $98, $92, $93, $94, $96, $96, $97, $98, $9c, $9a, $9b, $9c, $9e, $9e, $9f, $9f
    db $90, $a0, $a1, $a2, $a2, $a4, $a5, $a6, $a4, $a8, $a9, $aa, $aa, $ac, $ad, $ae
    db $a8, $b0, $b1, $b2, $b2, $b4, $b5, $b6, $b4, $b8, $b9, $ba, $ba, $bc, $bd, $be

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: read in BGB in 26 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_DitherRamp_ParamsA::
    db $80, $8f, $d0, $e6, $82, $90, $c8, $e3, $84, $90, $c0, $e0, $85, $91, $b8, $dd
    db $86, $91, $b1, $db, $87, $92, $aa, $d8, $88, $92, $a5, $d5, $89, $92, $a2, $d2
    db $8a, $92, $a1, $c8, $8b, $92, $a0, $be, $8c, $92, $9e, $b4, $8d, $92, $9c, $ac
    db $8e, $92, $9b, $a5, $8f, $92, $99, $a0, $90, $92, $97, $9a, $92, $92, $92, $92

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: read in BGB in 205 replay(s) of the organic
; corpus, modes 00 14 (tcrf_check/assets/l3_names/)
Cam_DitherRamp_ParamsB::
    db $80, $94, $dc, $ff, $82, $95, $d2, $ff, $84, $96, $ca, $ff, $86, $96, $c4, $ff
    db $88, $97, $be, $ff, $8a, $97, $b8, $ff, $8b, $98, $b2, $f5, $8c, $98, $ac, $eb
    db $8d, $98, $aa, $dd, $8e, $98, $a8, $d0, $8f, $98, $a6, $c4, $90, $98, $a4, $ba
    db $92, $98, $a1, $b1, $94, $98, $9d, $a8, $96, $98, $99, $a0, $98, $98, $98, $98

; I: from the previous .sym (camera / sensor code
Cam_DitherRamp_ParamsUnused::
    db $87, $98, $b7, $ff, $88, $98, $b6, $ff, $89, $97, $b3, $ff, $8a, $97, $b0, $fa
    db $8b, $97, $ae, $f0, $8c, $96, $ab, $e6, $8d, $96, $aa, $dc, $8e, $96, $a4, $d4
    db $8f, $96, $a2, $c8, $90, $96, $a0, $be, $91, $96, $9e, $b4, $92, $96, $9c, $ac
    db $93, $96, $9b, $a5, $94, $96, $99, $a0, $95, $96, $97, $9a, $96, $96, $96, $96

; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FarStub_FactoryTest::
    call Cam_FactoryTest                          ; $7CE0
    jp Far_Call_Return                            ; $7CE3


; I: from the previous .sym (camera / sensor code. Dead-code root: nothing calls it; assembled as code tagged unused
; (owner decision 2026-10-26, README 13.6).
Unused_Cam_FarStub_GainProbe::
    call Cam_ExposureBandSelect                   ; $7CE6
    jp Far_Call_Return                            ; $7CE9


; I: far stub; no caller found. Dead-code root: nothing calls it; assembled as code tagged unused (owner decision
; 2026-10-26, README 13.6).
Unused_Cam_FarStub_FactoryMeasure1::
    call Cam_FactoryMeasure1                      ; $7CEC
    jp Far_Call_Return                            ; $7CEF


; C
Cam_FarStub_BuildDitherMatrix::
    call Cam_BuildDitherMatrix                    ; $7CF2
    jp Far_Call_Return                            ; $7CF5


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 71 replay(s) of the organic
; corpus, modes 14 (tcrf_check/assets/l3_names/)
Cam_FarStub_MainDispatch::
    call Cam_MainDispatch                         ; $7CF8
    jp Far_Call_Return                            ; $7CFB


; C: far call target of 06:781F
Cam_FarStub_DispatchEffect::
    call Cam_DispatchEffect                       ; $7CFE
    jp Far_Call_Return                            ; $7D01


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_FarStub_ValidityCheck::
    call Cam_Calib_ValidityCheck                  ; $7D04
    jp Far_Call_Return                            ; $7D07


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: not reached by the 206 BGB replays; executed in
; the organic runs of the core emulator (coverage/results/merged_state/cov.npz)
Cam_FarStub_FullCalibration::
    call Cam_FullCalibration                      ; $7D0A
    jp Far_Call_Return                            ; $7D0D


; C: from the previous .sym (camera / sensor code. L3 pass 2026-10-26: executed in BGB in 205 replay(s) of the organic
; corpus, modes 00 (tcrf_check/assets/l3_names/)
Cam_FarStub_LiveInit::
    call Cam_LiveInit                             ; $7D10
    jp Far_Call_Return                            ; $7D13


    ; padding
    ds $2ea, $00
